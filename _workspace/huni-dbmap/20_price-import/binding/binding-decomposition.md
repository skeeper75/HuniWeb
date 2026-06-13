# 제본 분해 설계 (binding-decomposition) — round-16

> **작성** 2026-06-13 · round-16. 입력 = `binding-structure.md`(3블록 해부) + 라이브 `t_prc_*`/`t_proc_processes` 실측 + round-14 stale 진단. **분해 기준 = Phase11 가격엔진 `evaluate_price` 매칭 규칙.** **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위)

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)          ← frm_typ_cd·prd_cd 없음(실측·스킬 권위표 stale)
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd) ← 별 테이블
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd[단가/합가], use_dims, use_yn)
[단가행]     t_prc_component_prices(comp_cd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, proc_cd, opt_cd, apply_ymd)
                                                                                                          ↑신설   ↑신설(8→10차원)
```

- **그릇 엑셀 시트** = `1_price_formulas_RU` + `1b_product_price_formulas_RU` + `2_formula_components_RU` + `3_price_components_RU` + `4_component_prices_RU`(74행) + `8_FIX_wiring_chain`(단절1·10행) + `9_FIX_binding_chain`(단절2·제안).
- **BLOCKED 별 시트 불필요** — 제본방식을 comp_cd 분리로 표현해 proc_cd 미실재 방식(싸바리·캘린더)도 그릇에 정상 수용(NULL 강제 회피). 11종 전건 라이브 실재.

---

## 1. 공식 매핑 (블록 → price_formulas + formula_components)

| 블록 | 제본방식(comp_cd) | 공식(frm_cd) | 배선 상태 |
|------|-------------------|-------------|----------|
| B1 제본비 | COMP_BIND_JUNGCHEOL/MUSEON/PUR/TWINRING | `PRF_BIND_SUM`(기존) | 🔴 JUNGCHEOL 1개만 배선 |
| B2 하드커버 | COMP_BIND_HC_MUSEON/HC_TWINRING/SSABARI | (미배선) | 🔴 0 배선 |
| B3 캘린더 | COMP_BIND_CAL_WALL/DESK220/DESK130/DESKMINI | (미배선) | 🔴 0 배선 |

- 라이브 공식 정의: `PRF_BIND_SUM = "제본 합산형(제본비 구성요소)"`. note = "합산형: 제본비=[수량행][제본종류열] 구성요소. 책자 원자합산형 공식의 제본 구성요소".
- **제본비는 책자/캘린더 등 완제품 원자합산 공식의 한 구성요소**(인쇄비+용지비+제본비+…). 제본 시트 단독으로 완결되는 가격이 아니라 상품 공식에 합산되는 후가공 항.

## 2. 제본방식 분해 = comp_cd 분리 (proc_cd 아님 — 엔진 매칭 규칙)

§2 분해 기준(엔진 매칭 단위)으로 판정:

- **왜 proc_cd가 아닌가**: 제본방식은 의미상 후가공 공정(PROC_000017 자식)이지만, 라이브 가격엔진은 제본방식마다 **별도 구성요소(COMP_BIND_*)**를 만들고 `use_dims=["min_qty"]`만 사용. `proc_cd`는 전건 NULL(신설 차원 미사용). → 제본방식 차원 = **comp_cd 분리**.
- **엔진 매칭**: 손님이 (제본=무선) 선택 → 상품 공식이 `COMP_BIND_MUSEON` 구성요소를 흡수 → 그 안에서 `min_qty` 매칭으로 장당가 산출. 제본방식이 선택값이면 **공식이 해당 comp 1개만 배선**해야 동시매칭 회피(아래 §6).
- **싸바리·캘린더 BLOCKED 해소**: PROC_000017 자식에 없는 방식도 comp만 만들면 됨 → proc_cd NULL 강제 금지 규칙 위반 0. 11종 전건 정상 수용.

## 3. 단가/합가 판별 = 단가형(.01) [전건]

- 라이브 11 component 전건 `prc_typ_cd = PRICE_TYPE.01`(단가형).
- **근거**: 셀 값 = 권당(1권) 장당 단가. 수량(권수)↑ → 단가↓(중철 3000→500). 구간총액 표기 부재. 헤더 `제본/수량`.
- **엔진**: `매칭된 min_qty 구간 unit_price × 주문수량(권수)`. (합가형 ÷min_qty 환산 불필요)
- **component 레벨 속성**: 같은 comp의 모든 단가행 동일 prc_typ_cd. 행별 차이 없음.

## 4. use_dims = `["min_qty"]` [전건]

- 제본비 단가표가 실제 쓰는 차원 = **수량구간(min_qty)** 하나뿐. 제본방식은 comp로 이미 분리됨(차원 아님).
- siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·proc_cd·opt_cd = 전건 NULL(와일드카드). **과분할 0** — 제본비는 사이즈/도수/자재 무관(권당 정액 차등).
- 라이브 use_dims 대조: 11 component 전건 `["min_qty"]` 일치.

## 5. 가격사슬 점검 (🔴 단절 발견 — 핵심)

| 사슬 | 라이브 | 정상 필요 | 단절 |
|------|--------|----------|------|
| 단가행 component_prices | 74행(11종) | 74 | ✅ 완전 |
| 구성요소 price_components | 11 | 11 | ✅ 완전 |
| 배선 formula_components | **1**(JUNGCHEOL만) | 11 | 🔴 **단절1**: 10/11 미배선 |
| 공식정의 price_formulas | 1(PRF_BIND_SUM) | — | (공식 1개로 11 흡수 시 동시매칭 위험·§6) |
| 상품바인딩 product_price_formulas | **4**(책자4종) | 제본 쓰는 전 상품 | 🔴 **단절2**: 하드커버/캘린더/포토북/다이어리 미바인딩 |

### 단절1 — 배선 (10/11 component 미배선)
- 단가행은 74행 전부 적재됐으나 `formula_components`에 COMP_BIND_JUNGCHEOL만 배선. 손님이 **무선/PUR/트윈링/하드커버/싸바리/캘린더** 선택 시 엔진이 해당 comp를 못 찾음.
- 교정: `8_FIX_wiring_chain`에 미배선 10 component 배선 제안. **단, 단일 공식 PRF_BIND_SUM에 11개를 다 배선하면 동시매칭 발생**(§6) → 상품별 공식 분리 권장(아래).

### 단절2 — 바인딩 (책자4종만)
- PRF_BIND_SUM이 PRD_000068~071(중철/무선/PUR/트윈링 책자)에만 바인딩. **하드커버책자(PRD_000072·077·082)·캘린더(PRD_000108~112)·포토북(PRD_000100)·다이어리(PRD_000173·174)** 등 제본 쓰는 상품 미바인딩.
- 교정: `9_FIX_binding_chain`에 제안. 단, 상품별 제본방식이 고정(중철책자=중철만)이라 **상품↔제본방식 매핑 확정 필요**(컨펌 대상 — §7).

### ⚠️ 공식 설계 미스매치 (단순 배선 추가로 해결 안 됨)
- 현재 PRF_BIND_SUM은 책자4종 공통 공식. 책자4종은 제본방식이 상품마다 1개 고정(중철책자→중철). 그런데 배선이 JUNGCHEOL 1개뿐 → **무선책자(PRD_000069)도 중철 단가로 계산되는 오류 가능**.
- **올바른 모델 2안**(컨펌 필요·추정 분해 금지):
  - **(A) 상품별 공식**: PRF_BIND_<방식>를 제본방식별로 분리, 각 책자 상품에 1:1 바인딩 (중철책자→PRF_BIND_JUNGCHEOL, 무선책자→PRF_BIND_MUSEON…). 동시매칭 0.
  - **(B) 옵션 선택 기반**: 제본방식을 CPQ 옵션(opt_cd)으로 올리고 공식 1개가 선택값으로 comp 1개 매칭. comp_cd 분리 모델과 충돌 → opt_cd 차원 재설계 필요(L2 트랙).
- **본 산출은 단절을 명세·교정 제안까지만.** 어느 안인지는 상품↔제본방식 바인딩 권위(상품마스터·책자 도메인) 확정 후 결정. **추정 분해 금지.**

## 6. 동시매칭 금지 검증

- 같은 comp 내부: `use_dims=["min_qty"]` 단일 차원, min_qty 구간 비중복(1/4/10/30/50/70/100/1000 단조증가) → 한 주문수량에 1행만 매칭. **동시매칭 0** ✅.
- **공식 레벨 위험**: 만약 PRF_BIND_SUM에 11 component를 전부 배선(`8_FIX` 순진 적용)하면, 한 주문에 11개 comp가 다 합산되어 **모든 제본방식 단가가 더해지는 오류**(동시매칭의 공식판). → §5 (A)안(상품별 공식) 또는 (B)안(opt_cd 선택)으로만 안전. `8_FIX`는 "배선 후보"이지 "그대로 INSERT"가 아님을 명시.

## 7. 컨펌 (추정 분해 금지 — 별도 표기)

| ID | 항목 | 질문 | 막힌 이유 |
|----|------|------|----------|
| BIND-C1 | 공식 모델 | 제본방식별 공식 분리(A안) vs 옵션 선택(B안) 중 무엇? | 상품↔제본방식 바인딩 권위가 단절2에 없음. 책자4종 외 제본 쓰는 상품 목록·각 상품 허용 제본방식 미확정 |
| BIND-C2 | 하드커버/캘린더 상품 바인딩 | 하드커버무선/싸바리/벽걸이 등은 어느 prd_cd에 붙나? | 상품명(하드커버책자·벽걸이캘린더)과 제본방식 1:1 추정되나 상품마스터 명시값 미확인 |
| BIND-C3 | "표지비용 따로 계산" | 하드커버 표지비는 별 상품(PRD_000073 표지)인가, 별 component인가? | 가격경계 명시됐으나 표지비 그릇 위치 미확인(제본 시트 범위 외) |

---

## 8. round-trip 무손실

| 검산 | 결과 |
|------|------|
| 시트 데이터셀 74 ↔ 라이브 단가행 74 | matched 74·mismatch 0·missing 0 |
| 제본방식 11 ↔ comp_cd 11 | 전건 매핑 |
| 부유/노트 셀 | 표지비용 따로 계산·삼각대 포함 → README·decomposition note 보존 |
| 수량구간 보존 | B1 8구간(30·70 포함)·B2/B3 6구간 — 블록별 상이 그대로 |
