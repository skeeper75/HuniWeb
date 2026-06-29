# validation-summary-foil.md — 박류(foil) 설계 독립 검증 종합

> hpe-validator(Claude) · 2026-06-30 · E1~E7 게이트 종합 + 보정 요청 + 컨펌큐.
> 독립 재실측: 권위 박(대형/소형) 시트 셀 + 라이브 읽기전용 SELECT(t_proc_processes·t_prc_price_components·t_prc_component_prices·t_prd_template_prices) + pricing.py 코드.
> codex 2차(Phase 5.5) 결과 미열람(독립성).

---

## ★★ REV3 최종판정 (동판비 proc_cd 게이트 보정 후·2026-06-30) = **GO (데이터 설계)**

REV3 재게이트 = `gate-verdict-foil-rev3.md`. codex가 validator E4 CONDITIONAL이 놓친 **동판비 proc_cd 게이트 누락(R-FOIL-CDX1·돈크리티컬·박 미선택 상시 과금)**을 적발했고, designer REV3가 정확히 보정(C-1=`["proc_cd","siz_width","siz_height"]`·C-2=`["proc_cd"]`·단가행 proc_cd 충전·명함박 SETUP `["min_qty"]` 답습 금지)했다. Claude 독립 재확인:

- **코드 정합 PASS**: `pricing.py:99-111 _row_matches`(proc_cd NULL=와일드카드 → REV2 상시 과금 / proc_cd 충전 → 박 미선택 no_match→0)·`match_component:133-145` 직접 추적. 박가공비(C-3~C-6 proc_cd 보유)와 동형 게이트 성립.
- **라이브 SELECT 실측**: 명함박 SETUP use_dims=`["min_qty"]`(proc_cd 없음·박 항상 거는 전용)·PRF_DGP_E 후가공 comp가 proc_cd 단가행 실 충전(COMP_FOLD_LEAF_3FOLD proc_cd=PROC_000060)으로 게이트하는 동형 실증.
- **골든 8/8 불변**: REV3 proc_cd 게이트는 박 선택 케이스 산술 불변(권위 verbatim 허용오차 0 재대조).
- **R-FOIL-CDX2(표 .02 정정)·R-FOIL-CDX3(proc_grp 표기 일원화) 반영 확인.**

| E1 | E2 | E3 | E4 | E5 | E6 | E7 |
|---|---|---|---|---|---|---|
| PASS | PASS | PASS | **PASS**(REV2 CONDITIONAL 해소) | N/A | PASS | PASS |

**박 데이터 설계 = GO(인간 승인 후 dbmap 적재).** 잔여 = B-FOIL-2 면적→등급 환산 엔진 미지원(개발팀 C트랙·데이터 GO와 별개·High). 돈크리티컬 3건(박 0원·박 미선택 상시 과금·×qty 폭발) 전부 설계로 해소.

> 아래 §는 REV2 시점 CONDITIONAL 기록(carry-forward). R-FOIL-CDX1 해소로 E4가 PASS로 격상됐다.

---

## (REV2 기록) 판정 = **조건부 GO (CONDITIONAL)**

단일 FAIL 없음. **설계 자체(공식 추출·구성요소 분해·골든 산술)는 권위 verbatim 정합·허용오차 0.** 단 **엔진 작동에 코드트랙 2건이 전제**되고, designer 한 곳의 단정이 라이브 메커니즘에 어긋나 보정 필요.

| E1 | E2 | E3 | E4 | E5 | E6 | E7 |
|---|---|---|---|---|---|---|
| PASS | PASS | PASS | **CONDITIONAL** | PASS | PASS | PASS |

## 무엇을 확정했나 (라이브·권위 독립 재실측)

1. **8 골든 전건 권위 verbatim 일치(허용오차 0)** — 동판비 면적매트릭스·박가공비 등급×수량·일반/특수 차등·먹유광 시트차이·off-grid ceiling 전부 권위 셀 추적.
2. **박 자식공정 16종 라이브 실재**(037~049 박색상 + 034~036) use_yn=Y·del_yn=N. 신규 mint 0 충족.
3. **proc_cd+proc_grp 차원 패턴 광범위 실재**(제본·접지·타공·코팅·미싱·오시) — designer §2-1 핵심 근거 사실.
4. **박가공비 prc_typ=.02 정정이 옳음** — .01은 unit×qty 폭발(pricing.py:212), .02+min_qty=구간하한이 박 "작업1건 총액" 모델에 정합(:205-210). 라이브 후가공(.01 장당가)과 데이터모델 다름을 designer가 올바로 구분.
5. **명함박 G6 갭 = 1000구간 단가행 1셀 −1,000 오적재**(라이브 63,000 vs 권위 64,000)로 확정. 200~900은 권위 E등급 verbatim 일치. designer 추정 "(나) 동판비 미합산"은 반증(SETUP 5,000 별도 comp 실재).

## 확정 결함 / 보정 요청

### B-FOIL-1 [돈크리티컬·보정요청] designer §5-3 "addon 이중×qty 폭발 0" 단정이 라이브 addon 메커니즘에 어긋남
- **근거(라이브)**: `t_prd_template_prices` = `tmpl_cd|apply_ymd|unit_price` 단일 고정단가만(차원 컬럼 0). pricing.py:441-446 템플릿가 = `unit_price × qty`(차원매칭 전무).
- **함의**: addon 템플릿에는 (면적등급×수량구간×박색상) 다차원 박가공비를 담을 수 없고, 단일값을 넣으면 ×qty 폭발(예 박가공비 75,000을 템플릿가로 → 1000매면 7,500만). designer가 §5-3에서 "동판비+박가공비 둘 다 비-수량비례→이중×qty 0·가드 통과"라 단정했으나 **addon 경로에선 거짓**.
- **단 정상참작**: designer는 §5-1 trade-off·Q-FOIL-CODE1에서 "addon 4축 미검증·미지원이면 C트랙"으로 **정직하게 분류**도 함. §5-3 단정과 §5-1 분류가 상호모순. §5-3을 "addon 미지원 시 ×qty 폭발 위험 — 본체 분기 comp 또는 엔진 multi-dim addon 필요"로 **정정** 요청.
- **라우팅**: designer 폐루프(§5 재설계) → 박 바인딩 모델 재결정.

### B-FOIL-2 [코드트랙 미확정] 면적→등급(grade) 환산 엔진 미지원
- **근거(라이브)**: pricing.py:42-50 NON_QTY_DIMS/TIER_DIMS/TIER_UPPER에 **grade·면적→등급 환산 없음**. dim_vals grade는 정확매칭 차원이라 면적값→등급 변환을 엔진이 안 함. 앱이 환산 후 grade selection을 넘겨야 함.
- **함의**: G-F5(격자빈칸 ceiling)·G-F6(off-grid 면적→등급 ceiling) 골든은 산술 정합이나 **현 엔진으로 미재현**. 명함박은 면적고정→E등급 collapse라 미사용이었음.
- **라우팅**: 개발팀 C트랙 + dbm-price-arbiter 심의(Q-FOIL-CODE1). 설계 결함 아님(designer 정직 분류).

### B-FOIL-3 [non-blocking·근거정정] designer 서술 부정확 2건
- §0 박 자식공정 "13종" → 라이브 **16종**(034~036 추가). 박색상 축엔 037~049만 쓰나 표기 정정.
- §4 C-3 "명함박 .06=종이통가와 달리 박만" → 라이브 명함박 S1_STD는 **종이+동판+박 통합 완제품가(.06)**. 박 단독 아님. 신규 7상품 comp 설계엔 무영향이나 근거 주석 정정.

## 컨펌큐 (designer CONFIRM 큐 검증가 의견)

| ID | designer 질문 | validator 검증 결과 |
|---|---|---|
| Q-FOIL-CODE1 | addon/엔진이 면적→등급·4축 박색상 지원? | ⛔ **둘 다 미지원 확정**(라이브 실측). addon 단일고정가·엔진 grade 차원 없음. C트랙 필수·심의 우선도 **High 격상** |
| Q-FOIL-SIZE1 | 상품별 대형/소형 시트 소속 | 실무진 컨펌 유효(권위에 면적임계 없음 확인·범위겹침 사실) |
| Q-FOIL-SETUP1 | 소형 동판비 명함박 SETUP 공유 vs 신설 | 신설 권장 타당([[base-master-code-no-delete]]). 명함박 SETUP=5,000 동일값 확인 |
| Q-FOIL-FACE1 | 양면 박 앞+뒷 2회 vs 1회 | 권위 박 시트에 면 차원 없음 확인 → 실무 컨펌 유효 |
| Q-FOIL-G6 | 명함박 63,000 오적재? | ✅ **확정**(1000구간 1셀 −1,000 오적재·라이브 실측). 명함박 검증/C트랙 라우팅·답습 금지 정합 |

## 다음 행동

1. **designer 폐루프** — B-FOIL-1(§5-3 정정·박 바인딩 모델 재결정: addon 미작동 → 본체 분기 comp[proc_cd 판별차원] 또는 엔진 multi-dim addon C트랙)·B-FOIL-3 근거 정정.
2. **dbm-price-arbiter 심의** — B-FOIL-2(grade 환산)·Q-FOIL-CODE1(High) 코드트랙 처방.
3. **검증/C트랙** — Q-FOIL-G6 명함박 1셀 오적재(별도, 박 설계 무관).
4. 실 COMMIT/DDL/엔진 수정 = 인간 승인 후 (dbmap/개발팀 C트랙). DB 미적재 유지.

★ **요약**: 박 가격모델 추출·골든 산술은 정확(GO 수준). 막는 것은 "라이브 엔진이 박을 옳게 계산할 수 있나"(코드트랙)와 designer가 그 위험을 한 곳(§5-3)에서 과소단정한 점. 데이터 그릇 설계는 건전하되 **엔진 능력 확정 전 적재 보류**가 정합(돈크리티컬).
