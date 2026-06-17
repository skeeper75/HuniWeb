# 신안(siz_width/siz_height 구간) — Phase D 독립 검증 verdict (R1~R6)

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립.
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. 가격표 xlsx는 openpyxl 독립 추출 후 V1 SQL과 field-for-field 대조. COMMIT 0·비밀값 비노출.
> 엔진 의미는 `raw/webadmin/webadmin/catalog/pricing.py`(TIER_DIMS/TIER_UPPER·match_component) 직접 확인. 권위: 라이브 information_schema + 실데이터 + 가격표 셀 verbatim + 엔진 소스(2026-06-17).

## 종합 판정: **CONDITIONAL-GO**

R1~R6 전건 PASS(라이브+xlsx 독립 재현). **가격표 667셀 field-for-field 일치(price mismatch 0·날조/오프셋/전치 0)·골든 매트릭스 룩업 4종(정확·off-grid ceiling·above-max) 엔진 TIER로 독립 재현·2-pass delta 0·FK고아 0·17행 비충돌 in-place 전환·COMMIT 0** 모두 실측. 잔존 조건: ① 아크릴 동형(Q-PR-3) 별 트랙 BLOCKED ② 고정가 15 comp siz_cd 유지(본 실행본 미포함·면적 13만) ③ V1/V2가 G-D2/U6 트랙과 동일 13 comp use_dims를 건드림 — **동시 COMMIT 금지(V2 use_dims 전환은 신안 전용·G-D2는 siz_cd 가정)** ④ 실 COMMIT 인간 승인.

---

## R1 멱등성 — **PASS**
2-pass 독립 재현(단일 ROLLBACK tx·apply 2회). **PASS2 전 DML = 0**:
```
PASS2: V1 INSERT 0 · V1b UPDATE 0 · V2 UPDATE 0 · V3 UPDATE 0×13   (전건 0)
```
V1=자연키(comp,apply_ymd,siz_width,siz_height,…,COALESCE(dim_vals,'{}')) NOT EXISTS 가드 · V1b=`siz_cd IS NOT NULL AND siz_width IS NULL`(전환 후 0행) · V2=`use_dims @> ["siz_cd"]`(전환 후 미매칭) · V3=`incr IS NULL`. 생성자 주장 일치.

## R2 트랜잭션 원자성 — **PASS**
`apply.sql` 단일 `BEGIN; \i V1→V1b→V2→V3; ROLLBACK`. `ON_ERROR_STOP on`. FK 위상순: V1(INSERT 단가)·V1b(siz_cd→width/height 전환)가 V2(use_dims 모델 전환) 선행 → 가격 공백 0. 전체 단일 tx 오류 없이 롤백.

## R3 실행가능성 — **PASS**
라이브 스키마 실측 일치, 문법·참조 오류 0(R4 clean):
- `t_prc_component_prices.siz_width/siz_height` = **numeric** · `t_prc_price_components.use_dims` = **jsonb** · `t_prd_products.nonspec_width_incr/height_incr` = **numeric**(nonspec_yn=char). 14차원 자연키 모델 정합.
- **V2 `@> [siz_cd]` 정확성 실측**: WATERPROOF_PET use_dims=`["siz_cd","min_qty"]`(잉여 min_qty) 포함·고정가 미포함 — V2가 13 면적 comp 전건만 포착(UPDATE 13). 본체 13 comp = ["siz_cd"]/["siz_cd","min_qty"]로 전부 siz_cd 토큰 보유 확인.
- POST orphan(comp_cd) = 0 · 매트릭스 comp 잔여 siz_cd 행 = **0**(V1b 17 전건 전환).

## R4 영향행수 — **PASS (생성자 보고와 완전 일치)**
독립 BEGIN…ROLLBACK 실측:
```
V1  INSERT 667 · V1b UPDATE 17 · V2 UPDATE 13 · V3 UPDATE 1×13(=13)
합계: INSERT 667 · UPDATE 43(17+13+13) · 채번 0 · ERROR 0 · ROLLBACK
```
생성자 보고(V1 667·V1b 17·V2 13·V3 13·채번0)와 **전건 일치**. 단가행 = 가격표 verbatim.

## R5 ★가격표 셀 verbatim 대조 (돈-크리티컬) — **PASS**
xlsx `4b_component_prices_GAP_BLOCKED` 시트를 openpyxl로 **검증자 독립 추출**(667셀·13 comp·dup 0·null price 0·bad siz 0) → V1 SQL VALUES 667행 파싱 → field-for-field diff:
```
only_in_xls = 0 · only_in_v1 = 0 · price_mismatch = 0 · apply_ymd 일괄 '2026-06-01'
```
- **샘플 교차검증**: ARTPRINT 600×600=12,000 · 800×800=20,000 · BANNER_NORMAL 5000×1750=72,000 — 전부 xls=v1 일치. 오프셋/전치/날조 0.
- **17행 비충돌 실측**: 라이브 siz_cd 17행 좌표(600×1800·900×900·900×1200·1500×1000)는 667 GAP·V1 INSERT와 **충돌 0** → V1(667)+V1b(17)=684 distinct, 중복 0. 생성자 "687→684 정정" 정확.
- **V1b 값 불변 실측**: 전환 후 ARTPRINT 600×1800=21,600·BANNER 1500×1000=12,000 — 전환 전 siz_cd 행 단가와 동일(unit_price UPDATE 안 함).

## R6 ★골든 매트릭스 룩업 독립 재현 (엔진 '이하 상한') — **PASS**
엔진 소스 검증: `TIER_DIMS=(siz_width,siz_height,min_qty)`·`TIER_UPPER=(siz_width,siz_height)`·`_tier_val(NULL,upper)=Infinity`·upper축 `eligible=[t for t in tiers if t>=order]; selected=min(eligible)`·`if not eligible→ERR_ABOVE_MAX`(pricing.py:144-162). 생성자 인용 라인 실재.
post-state(rollback tx)에서 TIER 로직 직접 SIM:
| 케이스 | 주문 | 엔진 매칭 | 단가 | 판정 |
|--------|------|----------|------|:--:|
| 정확 G1 | ARTPRINT 600×600 | w=600·h=600 | **12,000** | ✅ |
| 정확 G2 | ARTPRINT 600×1000 | w=600·h=1000 | **20,000** | ✅ |
| off-grid G3 | ARTPRINT 700×650 | w tier=min≥700=**800**·h tier=min≥650=**800** | **20,000**(800×800 ceiling) | ✅ |
| above-max G4 | ARTPRINT 6000×600 | w≥6000 eligible **0**(max 3000) | **ERR_ABOVE_MAX** | ✅ |
- off-grid ceiling이 DB 차원(siz_width/height '이하')으로 내장 — 좌표 siz 채번 불요(U1 폐기 정당).
- NULL ∞ catch-all 미사용(상한=명시 3000) → above-max 정상 거부(Q-PR-1 실증).
- 잔여 매트릭스 siz_cd 행 **0**(고아 없음)·orphan_comp_cd 0·V1b 17 전건 전환 값불변 확인.

---

## 미해소 차단 / 컨펌 (인간 승인 대기)
| ID | 항목 | 상태 | 라우팅 |
|----|------|------|--------|
| Q-PR-3 | 아크릴 동형 siz_width/height 전환 | **별 트랙 BLOCKED**(라이브 부분진화 재실측 선행·본 실행본 범위 외) | dbm-load-builder(아크릴 트랙) |
| Q-PR-4 | 고정가 15 comp | siz_cd 유지(구간 아님)·본 실행본 미포함(면적 13만) | 설계 확정 사항 |
| X-1 | V2 use_dims 전환 = 13 comp(G-D2/U6와 동일 본체 comp) | **트랙 충돌 주의** — G-D2는 본체 use_dims=["siz_cd"] 가정·신안은 ["siz_width","siz_height"]로 교체. 두 트랙 동시 COMMIT 시 G-D2 골든(siz_cd 600×1800=21,600)이 siz_width 모델로 바뀜(값 보존되나 selection 키 변경). **신안이 G-D2 상위·신안 COMMIT 후 G-D2 골든은 siz_width selection으로 재검 필요** | lead — 신안·G-D2 단일화 순서 확정 |
| V3-incr | nonspec incr 포스터200/현수막100 | 매트릭스 그리드 스텝 도출(날조 아님)이나 **앱 입력 step 전용**(가격은 '이하' 구간 매칭) — 도메인 컨펌 권고 | dbm-domain(스텝값 검증) |
| — | 실 COMMIT(`apply.sh --commit`) | 인간 승인 | lead |

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| 영향행수 667/17/13/13·채번0 | 보고 | **동일** | 일치 |
| 가격표 667셀 verbatim·날조0 | 주장 | **xlsx 독립 추출 field-for-field 일치(mismatch 0)** | 일치 |
| 17행 비충돌·684 distinct | 정정(687→684) | **충돌 0 실측 확인** | 일치 |
| 골든 12,000/20,000/off-grid 20,000/above-max | 주장 | **엔진 TIER SIM 재현 일치** | 일치 |
| V1b 값 불변 | 주장 | **21,600/12,000 보존 실측** | 일치 |
| 2-pass delta 0·FK고아 0·잔여 siz_cd 0·COMMIT 0 | 주장 | **확인** | 일치 |
| (신규 적발) V2가 G-D2/U6 본체 use_dims와 충돌 가능 | 미명시(G-D2 정합만 언급) | **트랙 단일화 순서 명시 필요(X-1)** | 보완 권고 |

**self-approve 0 / 날조 0**: 가격표 셀은 xlsx 독립 추출 대조(생성자 /tmp JSON 비신뢰)·골든은 엔진 소스 인용 라인 실재 확인 + post-state 라이브 SIM·전 수치 라이브 직접 재현.
