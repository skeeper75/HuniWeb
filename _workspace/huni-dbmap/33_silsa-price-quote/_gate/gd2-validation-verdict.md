# G-D2 포스터 본체 후가공 배선 — Phase D 독립 검증 verdict (R1~R6)

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립.
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. COMMIT 0·비밀값 비노출.
> 엔진 의미는 `raw/webadmin/webadmin/catalog/pricing.py` 직접 확인(생성자 인용 라인 실재성 검증). 권위: 라이브 information_schema + 실데이터 + 엔진 소스(2026-06-17).

## 종합 판정: **CONDITIONAL-GO**

R1~R6 전건 PASS(라이브 독립 재현). **동시매칭 0·골든 27,600 독립 재계산 일치·2-pass delta 0·FK고아 0·COMMIT 0** 모두 실측 확인. 잔존 조건: ① 별색 dedup(W4-spot) 별 트랙(grouping U5')에 정당히 분리(BLOCKED 아님·데이터 위생) ② CANVAS_HANGING use_dims 라벨-데이터 불일치(G-D2 도입 아님·pre-existing MINOR) ③ 실 COMMIT 인간 승인. **U6/Phase C와 W1~W3 중복 — 동일 권위·동시 COMMIT 금지(택일 또는 멱등 1회)**.

---

## R1 멱등성 — **PASS**
2-pass 독립 재현(단일 ROLLBACK tx·apply 2회). **PASS2 전 DML = 0**:
```
PASS2: INSERT 0×5 · UPDATE 0×4 · DELETE 0   (전건 0)
```
W1/W2/W4/W6 = (frm_cd,comp_cd) NOT EXISTS · W3 = PK NOT EXISTS 가드 · W5 = "전환 전 상태"만 매칭하는 조건부 UPDATE. 생성자 주장과 일치.

## R2 트랜잭션 원자성 — **PASS**
`apply.sql` 단일 `BEGIN; \i W1→W2→W3→W4→W5→W6; ROLLBACK`. `ON_ERROR_STOP on`. apply.sql 기본 ROLLBACK(로더가 --commit 시 COMMIT 치환). FK 위상순(W1 공식 부모 → W2/W4/W6 frm_cd 자식 · W5 차원전환 → W6 배선) 정합. 전체가 단일 tx로 오류 없이 롤백.

## R3 실행가능성 — **PASS**
apply.sql 6단위 라이브 스키마에서 문법·참조 오류 0(R4 DRY-RUN clean 통과).
- **PK 실측**: `t_prd_product_price_formulas` PK = **(prd_cd, apply_bgn_ymd)** (information_schema). W3 정정 정확.
- **FK 타깃 실재**: PROC_000086(미싱 leaf)·PROC_000030(미싱 부모)·PROC_000090(오시)·PROC_000029 전부 t_proc_processes 실재. 8 후가공 comp + 28 본체 comp 전부 price_components 실재 → W2/W4/W6 FK 고아 위험 0.
- POST-STATE orphan(fc_frm·fc_comp·bind_frm) = **전부 0**.

## R4 라이브 DRY-RUN 영향행수 — **PASS (생성자 보고와 완전 일치)**
독립 BEGIN…ROLLBACK 실측:
```
W1 INSERT 28 · W2 INSERT 28 · W3 DELETE 28 + INSERT 28 · W4 INSERT 196
W5 UPDATE 1+1+30+2 · W6 INSERT 28
합계: INSERT 308 · DELETE 28 · UPDATE 34 · ERROR 0 · ROLLBACK
```
생성자 보고(INSERT308 / DELETE28 / UPDATE34 / 단가행 재적재 0)와 **전건 일치**. 단가행(component_prices) INSERT 0 확인 — 전부 공식/배선/차원전환(값 불변).

## R5 ★동시매칭 0 (엔진 핵심) — **PASS**
엔진 소스 검증(`pricing.py`): `_row_matches:70`(NON_QTY_DIMS NULL=와일드카드·dim_vals 키 일치 필수) · `_combo_key:85`(min_qty 제외 조합) · `combos>1 → ERR_AMBIGUOUS:108`. 생성자 인용 라인 실재.
- **PRE 대조(단절 증명)**: PRF_POSTER_FIXED 현재 1 comp(ARTPRINT_PHOTO)만 배선. 본체 comp use_dims=`["siz_cd"]`(mat_cd NULL) → 단일 공식에 27 본체 배선 시 siz만 맞으면 27 동시매칭=ERR_AMBIGUOUS(돈-크리티컬). 전제 실재.
- **POST 실측**: W1 공식분리 후 **siz-only selection에 복수 comp가 매칭되는 공식 = 0** (28공식 전수). 각 공식 본체 1 comp만 매칭 → combos=1 → ERR_AMBIGUOUS 미발생.
- **결합 selection SIM**(siz+proc+줄수): PRF_POSTER_ARTPRINT에서 본체 1행·오시 10행(전부 동일 combo_key, min_qty만 상이→1 combo) 매칭, 그 외 comp 0 → 전 comp combos=1. **동시매칭 0 확정.**

## R6 ★골든 가격 + 후가공 견적 독립 재현 — **PASS**
엔진 로직(`component_subtotal:129` 단가형=unit_price×qty)대로 손계산:
| 케이스 | selections | comp 매칭(엔진) | 손계산 | 일치 |
|--------|-----------|-----------------|--------|:--:|
| **골든(오시 2줄)** | siz=SIZ_000321(600×1800)·proc=PROC_000090·{줄수:2}·qty1 | 본체 ARTPRINT_PHOTO 21,600(.01 단가형) + 오시 CREASE_1L tier(min_qty1) 6,000 | 21,600+6,000=**27,600** | ✅ |
| **미선택 제외** | siz=SIZ_000321 만 | 본체 21,600 · 후가공 전부 row=None(무경고 제외) | **21,600** | ✅ |
| **미싱 W5 후** | proc=PROC_000086·{줄수:3}·qty1 | PERF_1L 이설행 7,000 | OPV-000009(3줄) 7,000 byte-identical | ✅ |
- 실측 단가행: ARTPRINT_PHOTO SIZ_000321=21,600(1행·.01) · CREASE_1L proc=PROC_000090·{줄수:2}·min_qty1=6,000. 골든 정확.
- **W5 값손실 0 실측**: PERF_2L↔PERF_1L OPV-000008 / PERF_3L↔OPV-000009 unit_price 불일치 **0행**(각 10행). OPV→줄수 매핑(007=1줄·008=2줄·009=3줄) 라이브 t_prd_product_options 일치 → W5 CASE 정확. 2L/3L use_yn=N 의미손실 0.
- **28공식 전건 후가공 조회가능**: POST 28공식 전부 9 comp(본체1+오시1+귀돌이2+가변2+별색2+미싱1) 배선·FIXED 잔존 0·28상품 자기공식 바인딩. W5 후 PERF_1L=.01·PROC_000086 30행·opt 잔여 0.

---

## 미해소 차단 / 컨펌 (인간 승인 대기)
| ID | 항목 | 상태 | 라우팅 |
|----|------|------|--------|
| W4-spot-dedup | 별색 WHITE_S1 530행(5색 proc 교차)·형제 4색 use_yn=Y | **BLOCKED(별 트랙 grouping U5')** — W4 배선은 정상(selection에 proc/popt/plt/min_qty 전건 지정 시 단가행 1건 결정). dedup은 데이터 위생·배선 차단 아님 | grouping U5'(별색 정본화) |
| F-1 | CANVAS_HANGING(PRF_POSTER_CANVAS_HANGING) use_dims=`["siz_width","siz_height","min_qty"]`인데 단가행은 siz_cd 사용·siz_width/height 빈값 | **MINOR·pre-existing(G-D2 도입 아님)**. 엔진 NON_QTY_DIMS에 siz_width/height 부재 → 실제론 siz_cd로 매칭(조회 성립)이나 라벨 불일치 | dbm-mapping-designer(use_dims→siz_cd 정정) |
| X-1 | W1~W3가 Phase C/U6와 동일(공식분리+본체배선+바인딩) | **중복** — 동일 권위. 두 트랙 동시 COMMIT 금지(멱등이라 1회만 효과·재실행 무해하나 의도 명확화 필요) | lead — G-D2를 U6 상위집합으로 단일화 |
| — | 실 COMMIT(`apply.sh --commit`) | 인간 승인 | lead |

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| 영향행수 308/28/34·단가행0 | 보고 | **동일** | 일치 |
| PK=(prd_cd,apply_bgn_ymd) | 정정 | **확인** | 일치 |
| 동시매칭 0 | 주장 | **확인(28공식 복수매칭 0·결합 selection도 combos=1)** | 일치 |
| 골든 27,600 / 미선택 21,600 / 미싱 7,000 | 주장 | **엔진 로직 손계산 재현 일치** | 일치 |
| W5 값손실 0(2L/3L byte-identical) | 주장 | **0 mismatch 실측** | 일치 |
| 2-pass delta 0·FK고아 0·COMMIT 0 | 주장 | **확인** | 일치 |
| (신규 적발) CANVAS_HANGING use_dims 라벨 불일치 | 미언급 | **MINOR pre-existing** | 보완 권고 |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·엔진 소스 인용 라인 실재 확인·골든 손계산 독립.
