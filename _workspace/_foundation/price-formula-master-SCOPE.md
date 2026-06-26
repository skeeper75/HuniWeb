# 전 상품 가격공식 통합 마스터 — 스코프 브리프 (수렴-실행·신규 하네스 0)

작성 2026-06-26 · 사용자 directive: "1번(수렴-실행)으로 하되 **전체 상품의 가격공식을 세우기 위한 시도가 없어서** 이 부분을 짚어야 한다." → §18이 시트별 설계는 했으나 **전 상품 단일 완전성 조망·수립 자(尺)가 부재**. 이 마스터가 그 자.

권위 = [[product-type-classification-sot]]·[[product-config-readiness-260626]]·§18 `01_formula/`·A2 실측. **신규 하네스/에이전트 금지**(SOT [HARD]) — 기존 §18 산출 합본 + 라이브 상태 병합만.

## 목적
전 상품(완제품226 + 반제품29 + 기성20 = 275 라이브)에 대해 "이 상품이 가격공식을 가졌는가/가져야 하는가/어디서 막혔는가"를 **한 표**로 세운다. 누락 0의 완전성 자.

## 입력 (재발견 0 — 합본 대상)
1. §18 `01_formula/formula-map-*.md` 11종(digitalprint·acrylic·booklet·calendar·photobook·silsa-banner·stationery·sticker·accessory·goods-pouch·design-calendar) — 상품군별 공식 설계.
2. §18 `01_formula/component-inventory*.md` — 가격구성요소 인벤토리.
3. §18 `03_design/engine-design-*.md` 11종 + `golden-cases-*.md` — t_prc_* 그릇 설계.
4. 라이브 t_prc_*/t_prd_product_price_formulas 실측(아래 §1).
5. `_foundation/remediation/price-only-missing-51.csv`·`price-only-51-binding-board.csv` — 가격만결손 51 분류(부분집합).
6. A2 `06_load/a2-price-conformance/_A2-SUMMARY.md` — 미바인딩 197·결함 보드.

## §1. 라이브 실측 기준값 (2026-06-26 main 측정 — 합본 시 이 값 사용)
- t_prc_price_formulas=50(use_yn=Y) · formula_components=103 · price_components=149 · component_prices=7,293 · 바인딩(t_prd_product_price_formulas)=78 / 275상품 → **197 미바인딩**.
- prd_typ 분포(del_yn≠Y): 완제품226·반제품29·기성20.
- 견적준비도 버킷(완제품226): 견적가능70 · 가격만결손51 · 기초부실105.
- 고아 공식(바인딩0·단가행>0): PRF_COROTTO_ACRYL(21)·PRF_POSTER_FIXED(52).
- use_yn=N 공식: PRF_PHOTOCARD_FIXED 1개뿐 → §18 설계분 라이브 미적재 = "설계됨≠적재됨".

## §2. 산출 = `_workspace/_foundation/price-formula-master.csv` + `.md`
CSV 컬럼(전 275 상품 1행씩):
`prd_cd, prd_nm, prd_typ, sheet_group, live_bound_frm, target_frm(§18 or live), comp_inventory(주요 comp_cd), calc_method(원자합산/면적매트릭스/구간/고정/세트조합/정찰가), status, gap_note, evidence_src`

**status 분류(완전성 taxonomy):**
| status | 정의 | 대략 |
|---|---|---|
| BOUND_OK | 공식 라이브+바인딩+견적가능 | 견적가능70 일부 |
| BOUND_DEFECT | 바인딩됐으나 A2 결함(저청구 등) | A2 HIGH 대상 |
| LIVE_UNBOUND | 공식·단가행 라이브 실재·상품 미바인딩(바인딩만/배선) | 아크릴 등 |
| DESIGNED_NOT_LOADED | §18 설계 있음·라이브 t_prc_* 미적재(민팅 필요) | 197 핵심·책자셋트 |
| NEEDS_BASICS_FIRST | 차원/자재 결손으로 공식 이전 단계 | 기초부실105 |
| DESIGN_BLOCKED | §18 의도적 보류(정찰가 역산 비정수) | 캘린더 등 |
| NA_NO_FORMULA | 기성(제조없음 고정가)·반제품(부모귀속) | 기성20·반제품29 |

**.md**: 상품군별 공식 수립 현황 서술 + status 집계표 + "공식 미수립(DESIGNED_NOT_LOADED+NEEDS_DESIGN) 상품" 우선순위 + §18 설계↔라이브 적재 갭(설계됨≠적재됨) 정량화.

## §3. 규칙 [HARD]
- §18 설계와 라이브가 다르면 **양면 표기**(설계값 vs 라이브 현재값) — 한쪽으로 덮지 말 것.
- 단가/공식명 verbatim·날조 0. 라이브 읽기전용 SELECT만(`.env.local RAILWAY_DB_*`). 비밀값 비노출.
- 가격연결 기초데이터 이름 수정/추가 가능, **삭제 금지**(사용자).
- 이 마스터는 **조망·자(尺)**다. 실 적재/민팅은 별도(게이트+인간/자율승인). DB 미변경.
- 생성≠검증: 이 산출은 생성. 별도 게이트가 status 분류·갭 정량화를 독립 재실측.
