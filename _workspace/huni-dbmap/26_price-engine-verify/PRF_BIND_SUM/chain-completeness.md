# PRF_BIND_SUM — S1 GATE-S 가격사슬 완전성 (구조 배선)

> 작성 2026-06-15 · round-18+ S1 · 클래스 PRF_BIND_SUM(제본 합산형 4상품).
> 입력: 라이브 `t_prc_*`/`t_prd_*` 읽기전용 실측 + round-16 `binding-decomposition.md`(재사용).
> 게이트 의미: **연결 자체만**(값 옳음은 S2 GATE-A). 라이브 실측.
> 권위 = 라이브 information_schema/행 존재. DB 미적재.

---

## 0. GATE-S 판정 = 🔴 NO-GO (배선 단절)

| 검사 | 기준 | 결과 | 판정 |
|---|---|---|---|
| ⓐ 공식 바인딩 | 4상품 product_price_formulas에 PRF_BIND_SUM | ✅ 4행(068~071 전건) | PASS |
| ⓑ formula_components 배선 ≥1 | 공식에 comp 배선 | 🔴 **1행만**(COMP_BIND_JUNGCHEOL) | **FAIL** |
| ⓒ comp마다 component_prices 단가행 ≥1 | 배선된/필요한 comp 단가행 | ✅ 4 comp 각 8행(단가행 자체는 완전) | PASS(값) |
| ⓓ t_dsc 수량할인 연결 | 책자 할인 바인딩 | ⚪ 미연결(설계상 불요·§4) | N/A |
| 등급할인 | t_dsc_grade_discount_rates | 0행(전역) | N/A(round-1 동일) |

> **단절 지점 = ⓑ 배선.** 단가행(ⓒ)은 4종 전부 완비됐으나, 공식이 중철 1개만 흡수 → 무선/PUR/트윈링은 **공식→comp 경로가 없어 계산불가**. "단가행 존재"를 "사슬 완결"로 위장 금지([HARD]).

## 1. 상품별 사슬 추적 (라이브)

| 상품 | 공식 바인딩 | 필요 제본 comp | 공식 배선됨? | 단가행 | 사슬 |
|---|:--:|---|:--:|:--:|:--:|
| PRD_000068 중철책자 | ✅ PRF_BIND_SUM | COMP_BIND_JUNGCHEOL | ✅ (1/1) | 8행 | ✅ **완결** |
| PRD_000069 무선책자 | ✅ PRF_BIND_SUM | COMP_BIND_MUSEON | 🔴 미배선 | 8행(존재) | 🔴 **단절(배선)** |
| PRD_000070 PUR책자 | ✅ PRF_BIND_SUM | COMP_BIND_PUR | 🔴 미배선 | 8행(존재) | 🔴 **단절(배선)** |
| PRD_000071 트윈링책자 | ✅ PRF_BIND_SUM | COMP_BIND_TWINRING | 🔴 미배선 | 8행(존재) | 🔴 **단절(배선)** |

- 4상품이 **동일 공식 1개**를 공유하는데 공식엔 중철 comp만 배선 → 구조상 4상품 다 같은 제본비(중철)를 합산하게 됨. 무선책자가 무선 단가표를 못 씀 = 단절. (B-FORMULA: 공식 설계 미스매치.)

## 2. 배선 실측 (formula_components)

```
frm_cd=PRF_BIND_SUM : comp_cd=COMP_BIND_JUNGCHEOL, disp_seq=1, addtn_yn=Y  (1행, 전부)
```
- 필요하나 미배선: COMP_BIND_MUSEON · COMP_BIND_PUR · COMP_BIND_TWINRING (3종).
- round-16 §5 단절1과 동일(11 comp 중 1 배선). 본 클래스 범위(책자4)에서는 3/4 미배선.

## 3. 구성요소·단가행 (price_components / component_prices)

4 제본 comp 전건 동질(use_dims·prc_typ·차원 NULL):

| comp | comp_nm | prc_typ_cd | use_dims | 단가행 | min_qty 구간 | 단가(min→max) |
|---|---|---|---|:--:|---|---|
| COMP_BIND_JUNGCHEOL | 제본비(후가공) | PRICE_TYPE.01 | `["min_qty"]` | 8 | 1·4·10·30·50·70·100·1000 | 3000→500 |
| COMP_BIND_MUSEON | 제본비(후가공) | PRICE_TYPE.01 | `["min_qty"]` | 8 | 동상 | 3000→500 |
| COMP_BIND_PUR | 제본비(후가공) | PRICE_TYPE.01 | `["min_qty"]` | 8 | 동상 | 5000→1500 |
| COMP_BIND_TWINRING | 제본비(후가공) | PRICE_TYPE.01 | `["min_qty"]` | 8 | 동상 | 4000→1000 |

- siz_cd/clr_cd/mat_cd/coat_side_cnt/bdl_qty/proc_cd/opt_cd = 전건 NULL(와일드카드).
- apply_ymd = 2026-06-01 단일(시계열 단일·최신 선택 자명).
- 동시매칭 0(comp별 min_qty 중복 없음·단조증가).

## 4. t_dsc 할인 연결 (책자 = 미연결·설계상 정당)
- 책자4상품 `t_prd_product_discount_tables` = 0행.
- `t_dsc_discount_tables`에 제본/책자용 테이블 **자체 없음**(아크릴/파우치/굿즈/문구 7종만).
- 제본비 수량할인은 **단가행 권당가 차등(min_qty 구간)**에 내재 → 별도 t_dsc 불요. = 결함 아님(D-3 무관).
- 등급할인 t_dsc_grade_discount_rates 0행(전역 미적재·round-1과 동일·본 클래스 책임 외).

## 5. GATE-S 결론
- **🔴 NO-GO** — ⓑ 배선 단절(3/4 comp 미배선). 중철책자(068)만 사슬 완결, 무선/PUR/트윈링은 계산불가.
- 단가행·구성요소·시계열·동시매칭은 모두 정상(값 그릇은 건강) → 결함은 **순수 배선/공식설계**(B-WIRE·B-FORMULA), 데이터 손상 아님.
- S2 GATE-A로 진행(의미 정합·prc_typ·단가단위 권위 대조). 단, S3 G-CALC는 **중철책자만 사슬 완결**이므로 무선/PUR/트윈링 재계산은 "comp 단가행 직접 조회(공식 우회)"로 골든값 검증하되 **사슬상 계산불가**임을 명시.
