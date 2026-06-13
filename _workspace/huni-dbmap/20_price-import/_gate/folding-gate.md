# 접지옵션(folding) import 준비 게이트 — round-16 (B) 독립 검증

> **검증자** dbm-validator(생성자 아님·빌더 의심·직접 실측) · 2026-06-13
> **대상** `20_price-import/folding/` (structure·decomposition·import.xlsx·mapping-flow)
> **권위** 원본 시트 `후니프린팅_인쇄상품_가격표_260527.xlsx#접지옵션`(openpyxl 전수 카운트·149행×16열) + 라이브 `t_prc_*`·`t_proc_processes` information_schema·실데이터(`.env.local` `RAILWAY_DB_*` 읽기전용·`db railway`).
> **방법** 빌더 산출을 신뢰하지 않고 원본 셀·라이브 행을 직접 재카운트·재대조.

---

## 종합 평결: **GO (조건부)** — 빌더 주장 전건 실측 일치, 가격사슬 단절은 정직 표기됨

빌더의 핵심 수치(336/480), proc_cd 분해 매핑, 단가형 판정, 가격사슬 단절을 **독립 실측으로 전건 재현**했고 모두 일치한다. 뒤집힌 항목 0. 그릇은 라이브 정합·무손실. 단, **실제 적재 GO는 아님** — Q-FOLD-1(RU vs DECOMP 택1)·Q-FOLD-3(CARD_3H/6CR 가격사슬 단절 복구)는 인간 결정이 선행돼야 하며, 이는 빌더가 컨펌으로 정직하게 열어둔 상태다.

---

## P1~P6 게이트

| 게이트 | 판정 | 독립 실측 증거 |
|--------|:----:|----------------|
| **P1 그릇=라이브 1:1** | **PASS** | import.xlsx 6시트 = 라이브 `t_prc_price_formulas/t_prd_product_price_formulas/t_prc_formula_components/t_prc_price_components/t_prc_component_prices`(RU+DECOMP) 1:1. `component_prices` 라이브 컬럼에 `proc_cd`·`opt_cd` 실재(8→10차원 실측 확정). DECOMP 컬럼순서 라이브 일치. |
| **P2 stale 무** | **PASS** | `t_prc_price_formulas`에 `frm_typ_cd`·`prd_cd` **부존재** 실측(빌더 교훈① 정확). `prc_typ_cd`·`use_dims`는 `t_prc_price_components`에 실재. round-14 Phase11(8→10차원·단가/합가) 반영분 정합. |
| **P3 무손실 336/480** | **PASS** | 원본 직접 재카운트: 블록1 48구간×3컬럼=**144**, 블록2 48구간×4컬럼=**192**, 합 **336**. RU 시트 데이터행 **336**·가격 mismatch **0**·round-trip 누락 **0**. DECOMP 시트 **480**(블록1 6proc×48=288 + 블록2 4proc×48=192)·가격 mismatch **0**·중복 자연키 **0**. 라이브 7 comp × 48행 = **336행** 실측 일치. |
| **P4 단가/합가** | **PASS** | 원본 2단(B열) 수량↑→셀값 단조 비증가(1매=5000→500매=80→5000매=40). 합가(구간총액)면 증가해야 함 → **장당가=단가형(PRICE_TYPE.01)** 판정 정당. 라이브 7 comp 전건 `prc_typ_cd=PRICE_TYPE.01` 실측 일치. 합가형(.02) 없음 확인. |
| **P5 동시매칭0 + proc 차원** | **PASS** | 라이브 `t_proc_processes` 실측: PROC_000065~74 = 2단가로/2단세로/3단가로/3단세로/4단가로/4단세로/병풍(71)/롤(72)/6단오시(73)/6단미싱(74). DECOMP proc 매핑(CARD_2H→{65,66}, CARD_3H→{67,68}, CARD_6CR→{73,74}, LEAF_HALF→56, LEAF_3FOLD→60, LEAF_4GATE→71) **전건 라이브 일치**. RU use_dims=`["min_qty"]`·proc_cd 전건 NULL(collapse) 실측. DECOMP 중복 (comp,proc,min_qty) **0**(동시매칭 없음). |
| **P6 가격사슬 단절** | **PASS(정직표기)** | 라이브 `t_prc_formula_components` 실측: CARD_2H=PRF_DGP_C(seq4)·PRF_FOLD_SUM(seq1)✅ / **CARD_3H 배선 0·CARD_6CR 배선 0**🔴 / LEAF 4종=PRF_DGP_E seq6~9✅. 상품바인딩 실측: PRD_000027/028/029(접지카드/미니/3단접지카드)→PRF_DGP_E이나 E엔 LEAF만 배선 → **카드 3단/6단 접지 엔진 조회불가** 라이브 실증. 빌더 §6 단절 주장 정확. |

---

## 빌더 주장 vs 독립 실측 대조표 (적발 대상 4항목)

| 빌더 주장 | 독립 실측 결과 | 판정 |
|-----------|----------------|:----:|
| 카드 144셀(3×48) + 리플렛 192셀(4×48) = **336셀** ↔ 라이브 336행 | 원본 재카운트 144+192=336·라이브 7comp×48=336·RU round-trip 0누락 | ✅ **일치** |
| DECOMP proc_cd 분해 **480행** | 블록1 6proc×48=288 + 블록2 4proc×48=192 = 480·중복0·가격mismatch0 | ✅ **일치** |
| 전건 **단가형(.01)** 곱셈거동 | 원본 단조 비증가·라이브 prc_typ_cd 전건 .01 | ✅ **일치** |
| proc 분해(65/66·67/68·73/74·56·60·71) | 라이브 t_proc_processes 명칭과 전건 매칭 | ✅ **일치** |
| 4단대문접지 PROC **라이브 미등록** | t_proc_processes에 "대문" 부재 실측·DECOMP LEAF_4ACC proc=NULL | ✅ **일치** |
| **CARD_3H·CARD_6CR 단가행 적재 O·배선 0** | 라이브 formula_components에 CARD_3H/6CR 행 없음·단가행 각48 실재 | ✅ **일치(단절 실증)** |

**뒤집힌 항목: 0. 보정 항목: 0.**

---

## 보정·주의 (MINOR — 평결 불변)

1. **[MINOR·표현] Q-FOLD-1 "라이브 충돌" 한정 필요.** component_prices PK = **`comp_price_id`(surrogate)만**·UNIQUE 자연키 제약 **없음** 실측. 따라서 DECOMP가 proc_cd를 채워도 **PK/UNIQUE 충돌은 발생하지 않음**. 빌더가 일부 표현에서 "라이브 충돌 가능"이라 쓴 부분은 *DB 제약 충돌*이 아니라 *엔진 동시매칭(같은 comp에 NULL행 + proc행 공존 시 use_dims 확장)* 충돌로 한정돼야 정확하다. 빌더가 decomposition §5에서 "RU·DECOMP 동시 적재 금지(동시매칭)"로 이미 정확히 한정했으므로 결론은 정당하나, mapping-flow/structure 요약의 "라이브 충돌" 문구는 "use_dims 확장 시 엔진 동시매칭 회피 위해 RU와 택1"로 읽어야 한다.

2. **[INFO] Q-FOLD-1 택1은 본 게이트 범위 밖(인간 결정).** RU(336·collapse·위젯이 가로/세로 구분 비반영) vs DECOMP(480·proc_cd·가로/세로 개별 단가 반영). 위젯이 "2단가로 vs 2단세로"를 구분 선택하고 가격에 반영해야 하면 DECOMP 필수. 두 그릇 모두 무손실·정합 — 데이터 결함 없음, 의사결정만 남음.

3. **[INFO] Q-FOLD-3 가격사슬 단절은 적재 그릇 결함 아님.** CARD_3H/6CR 단가행은 적재·정합. 단절은 `formula_components` 배선 누락(round-5 마이그 영역). 이 시트 import 준비 산출의 책임 밖이며 정직 표기됨.

---

## 라우팅

- **빌더(dbm-price-import-builder)**: 보정#1 표현 한정(mapping-flow/structure의 "라이브 충돌" → "엔진 동시매칭" 명확화) — MINOR, 선택적.
- **인간/리드**: Q-FOLD-1(RU vs DECOMP 택1)·Q-FOLD-2(4단대문접지 PROC 신설 여부)·Q-FOLD-3(CARD_3H/6CR 배선 복구 시점) 결정 — 실제 적재 전 선행.

---

## insertable / blocked / GAP 집계

- **insertable 그릇(무손실·정합)**: RU 336행 또는 DECOMP 480행(택1) + 공식정의/배선/구성요소 재현분.
- **BLOCKED(인간 결정 선행)**: Q-FOLD-1 그릇 택1.
- **GAP**: 4단대문접지 PROC 미등록(Q-FOLD-2) · 카드 3/6단 가격사슬 배선 단절(Q-FOLD-3·라이브 기존 결함, 이 시트 신규 결함 아님).

**DB 미적재.** import 준비 그릇으로서 GO — 실제 적재·배선 복구는 인간 승인.
