# 봉투제작 import 그릇 검증 게이트 (envelope-gate) — round-16

> **검증자** dbm-validator (독립·생성자≠검증자) · 2026-06-13 · round-16.
> **권위 직접 실측** = ① openpyxl `봉투제작` 시트(8×9) 전수 카운트 ② 라이브 `t_prc_*`/`t_siz_sizes`/`t_mat_materials` information_schema + 실데이터 read-only SELECT(2026-06-13) ③ Phase11 엔진 권위 `raw/webadmin/.planning/phases/11-price-engine-simulator/11-CONTEXT.md`.
> **"맞아 보임" 금지 — 모든 PASS/FAIL은 직접 인용 근거 첨부.** DB 미적재.

---

## 0. 종합 평결: **CONDITIONAL-GO** (P1·P3·P5 PASS / P2·P6 PASS-with-finding / **P4 FAIL — BLOCKER**)

봉투제작 그릇은 **분해·매핑·차원 모델·동시매칭은 정합**하나, **prc_typ_cd 라벨 오적재(ENV-C3)가 BLOCKER로 실재**하며 복합셀 줄무늬 누락(ENV-C1)이 부분 단절로 실재한다. 빌더의 핵심 주장은 대체로 정확히 재현되었고, **빌더가 자기 산출 내부에서 ENV-C3·169누락을 스스로 적발한 점은 정직**하다. 다만 빌더의 structure.md/README **한 줄 평결 "순수 단가형(.01)"은 빌더 자신의 decomposition §4·ENV-C3와 모순**이며 이 모순을 검증자가 엔진 권위로 종결한다.

---

## P1~P6 게이트 표

| 게이트 | 판정 | 직접 실측 근거 |
|--------|------|----------------|
| **P1 그릇 정합** | ✅ PASS | import.xlsx `4_component_prices_RU` 헤더 = `comp_cd,siz_cd,clr_cd,mat_cd,proc_cd,coat_side_cnt,opt_cd,bdl_qty,min_qty,apply_ymd,unit_price`(11). 라이브 `t_prc_component_prices` 컬럼 실측 = `comp_price_id(PK)·comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·unit_price·note·reg_dt·upd_dt·proc_cd·opt_cd`. 자연키 차원 8(siz·clr·mat·coat_side·bdl·min·proc·opt)+comp_cd+apply_ymd 1:1 매핑. `4_RU`는 컬럼순서를 라이브와 다르게(proc_cd를 mat_cd 직후) 배치했으나 컬럼명 1:1·누락/잉여 0. formulas/components/wiring 시트도 라이브 컬럼과 1:1(`frm_typ_cd·prd_cd` 부존재를 정확히 반영). |
| **P2 stale 차단** | ✅ PASS | 그릇이 `prc_typ_cd`·`use_dims`(jsonb)·`proc_cd`·`opt_cd` 신설 차원 전건 반영. round-2 8차원 잔재 0. ⚠️ **용어 정정**: 빌더가 "10차원"으로 표기하나 라이브 자연키 차원은 **8개**(siz·clr·mat·coat_side·bdl·min·proc·opt) + comp_cd + apply_ymd. Phase11 CONTEXT(L20)도 "단가 차원 2개 신설(공정·옵션)"으로 기존 6+2=8을 명시. "10차원"은 comp_cd·apply_ymd를 차원에 합산한 부정확 표기이나 **실질 그릇 구조는 정확**(stale 0). MINOR 용어 보정 권고. |
| **P3 분해 무손실** | ✅ PASS | openpyxl 직접 카운트: 데이터영역 B4:I8 = **8열×5행 = 40 데이터셀** 빌더 주장과 일치. 값 round-trip 전건 일치 (B4=96000→SIZ_000191/MAT_000159/1000=96000.00 ✅, C4=111000→SIZ_000191/MAT_000168/1000=111000.00 ✅, I8=760000→SIZ_000194/MAT_000168/5000=760000.00 ✅). 부유셀 A1="봉투제작" note 보존 확인. import.xlsx `4_RU` 40행+`4b_FIX` 20행. 드롭/날조 0. |
| **P4 단가/합가 정당** | 🔴 **FAIL — BLOCKER** | **ENV-C3 충돌 실재 확정.** 라이브 `COMP_ENV_MAKING.prc_typ_cd = PRICE_TYPE.01`(단가형). 그러나 단가행 unit_price = **구간총액**(min_qty=1000→96000, =2000→192000; 96000÷1000=96원/매 장당). Phase11 엔진 권위(11-CONTEXT L17-18): **.01 단가형 = `unit_price(장당) × 주문수량`** / **.02 합가형 = `구간총액 ÷ min_qty × 주문수량`**. 라이브를 .01로 계산 시 `96000 × 2000매 = 192,000,000원`(폭증). 정답 192,000원은 .02 규칙(`96000÷1000×2000`)으로만 성립. **→ 라이브 prc_typ_cd가 .01로 오적재됨(.02여야 정합).** 빌더 판정(.01)은 라이브 라벨을 그대로 받아들인 1차 오류였으나 빌더 스스로 decomposition §4·ENV-C3에서 적발·교정 제안. 검증자가 엔진 권위로 **충돌 실재 확정**. |
| **P5 동시매칭 0 + 차원** | ✅ PASS | 라이브 실측: 봉투종류 4종 → siz_cd 4 전건 실재(`SIZ_000191`225x193·`192`238x262·`193`262x238·`194`510x387). 소재 → mat_cd: 모조`MAT_000159`·레자크체크`168`·레자크줄무늬`169` 전건 실재(MAT_TYPE.01·소재오염 없음). 가격 대조로 siz 4/4 확정(티켓 96000·소 48000·자켓 48000·대 134000 = 가격표 B4/D4/F4/H4 일치). 자연키 (siz,mat,min_qty) 조합별 단가행 1개·중복 0(min_qty 5구간 단조). NULL행+전용행 공존 0. **opt_cd로 안 담고 siz/mat로 담은 게 정당**: 횡단 실측 `opt_cd` 전역 비NULL **0행**, `proc_cd` 전역 비NULL **0행** — opt_cd 차원은 라이브 전역 미사용이고 봉투종류는 물리 치수(siz)로 등록됨이 의미상 정당. |
| **P6 엔진 시뮬 + 가격사슬·복합셀** | 🟡 PASS-with-finding | **가격사슬 완전 정합 빌더 주장 = 라이브 재확인 PASS**: `PRF_ENV_MAKING`(공식정의)→`PRD_000050`바인딩(`t_prd_product_price_formulas` 1건·2026-06-01)→`COMP_ENV_MAKING`배선(`t_prc_formula_components` seq1)→구성요소 정의(`use_dims=["siz_cd","mat_cd","min_qty"]`)→단가행 40. 아크릴(배선0)·제본(배선1/11) 같은 단절 0 — **round-16 6시트 중 유일 완전체 확정**. **🔴 복합셀 collapse 실재 확정**: 라이브 distinct mat_cd in ENV = `{MAT_000159, MAT_000168}` 2종 → **레자크줄무늬 `MAT_000169` 단가행 0행 실측**(가격표 C3계열 "레자크체크 / 레자크줄무늬" 2소재 동일가인데 줄무늬 미적재). 손님이 줄무늬 선택 시 엔진 매칭 실패=부분 단절. 빌더 4b_FIX 20행(체크 동일가 복제) 제안은 정당. 단 P4 BLOCKER로 엔진 손계산 자체가 라이브 라벨로는 폭증하므로 **시뮬 일치는 .02 거동 가정 하에서만 성립**(192,000원). |

---

## 1. 봉투제작 = 세트형인가? (round-16 세트형 부재 결론 정당성 평결)

| 검사 | 빌더 주장 | 검증자 직접 실측 | 평결 |
|------|----------|------------------|------|
| 가격축에 결합 본품 차원? | 부재 | 라이브 use_dims=`[siz_cd,mat_cd,min_qty]` — 봉투종류·소재·수량만. 본품(엽서·카드) 차원 0 | ✅ 세트 아님 |
| `t_prd_product_sets` 참조? | 미참조 | 라이브 `t_prd_product_sets`(28행) 실측: `WHERE prd_cd='PRD_000050' OR sub_prd_cd='PRD_000050'` = **0건** | ✅ 세트 구성요소 아님 |
| 직접 고정가(`product_prices`)? | 0행 | 가격=공식경로(component_prices 40행). 세트 고정가 패턴 부재 | ✅ |
| 제작 단가 선형성? | 96원/매 고정 | openpyxl: 96000/192000/288000…(÷수량=96 고정) — 봉투 자체 제작 단가표 | ✅ |

**평결: 봉투제작 = 봉투 단품 제작 MATRIX 단가표 — 세트형(본품+부속 1세트 고정가) 아님이 데이터로 정당.** `PRD_000050`이 `t_prd_product_sets` 어디에도(parent·sub 양방향) 0건으로 미참조됨이 결정적 증거. 빌더의 **[round-16 세트형 부재 결론]**(엽서북떡메·박·제본·봉투제작 전건 검사 → 가격표 6시트에 세트형 구조 부재)은 **데이터로 정당**. 세트 결합은 CPQ 옵션 레이어(L2·product_sets 28행)에서 처리되며 가격표 그릇(t_prc_*)의 별도 패턴이 아니라는 빌더 결론 = 검증자 동의.

---

## 2. 빌더 주장 대비 뒤집힌 / 보정된 항목

| 항목 | 빌더 주장 | 검증자 실측 결과 | 처리 |
|------|----------|------------------|------|
| 40 단가셀 카운트 | "봉투종류4 × 소재2 × 수량5 = 40" | openpyxl 직접 카운트 B4:I8 = 40 데이터셀·라이브 40행 일치 | ✅ **확인** (뒤집힘 없음) |
| 무손실 분해 기준 | 본문 §6: 60(4×3mat×5)이 정답·라이브 40은 부분 | 라이브 mat distinct=2(159·168)·169 0행 → 무손실은 60, 적재는 40 | ✅ **확인** — 빌더가 60≠40을 정직히 명세 |
| 봉투종류 = siz_cd | 티켓191·소192·자켓193·대194 | 라이브 siz 4종 실재·가격대조 4/4 확정 | ✅ **확인** |
| 소재 = mat_cd | 모조159·체크168·줄무늬169 | 라이브 mat 3종 실재(169 포함·MAT_TYPE.01 정상) | ✅ **확인** |
| 가격사슬 완전체 | round-16 유일 단절0 | 공식→바인딩→배선→구성요소→40행 라이브 전건 실재 | ✅ **확인** |
| 레자크줄무늬(169) 누락 | 라이브 169 0행·4b_FIX 20행 제안 | 라이브 distinct mat = {159,168}만·169 단가행 **0행 실측** | ✅ **확인** (실재) |
| **prc_typ_cd 단가/합가** | structure 한줄평결 "순수 단가형(.01)" ↔ decomposition ENV-C3 "합가형(.02) 정합·.01 오적재 의심" | 엔진 권위(11-CONTEXT L17-18)로 **.01 계산시 폭증 확정·.02여야 정합** → **라이브 .01 오적재 BLOCKER 확정** | 🔴 **보정·확정** — 빌더 내부 모순을 검증자가 엔진 권위로 종결. structure.md/README의 "순수 단가형(.01)" 평결은 **틀림**; 정답=합가형(.02) |
| "10차원" 표기 | component_prices "10차원" | 라이브 자연키 차원 = 8(+comp_cd+apply_ymd). CONTEXT도 6+2신설=8 | 🟡 **MINOR 보정** — "8차원 자연키 + comp_cd/apply_ymd"로 표기 정정 권고 |

---

## 3. 컨펌·차단 인계 (라우팅)

| ID | 결함 | 심각도 | 라우팅 | 조치 |
|----|------|--------|--------|------|
| **ENV-C3** | 라이브 `COMP_ENV_MAKING.prc_typ_cd=PRICE_TYPE.01`이나 데이터 거동은 합가형(.02). 엔진 .01 계산 시 가격 폭증(96000×주문수) | 🔴 **BLOCKER** | `dbm-mapping-designer`(prc_typ_cd 교정) + 인간 승인 | `UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.02' WHERE comp_cd='COMP_ENV_MAKING'` 제안 — 단 **엔진 시뮬 회귀 1건(192,000원)으로 .02 확정 후** 적재. 추정 적재 금지. |
| **ENV-C1** | 레자크줄무늬(MAT_000169) 단가행 0행 — 가격표엔 존재(체크와 동일가) | 🔴 부분 단절 | `dbm-price-import-builder`(4b_FIX) + 상품옵션 권위 확정 | "봉투제작에서 줄무늬 선택가능?" 권위 확정 후 4b_FIX 20행 INSERT. 미확정 시 추정 적재 금지(빌더 처리 정당). |
| **ENV-C2** | `siz_nm`이 치수("225x193")로 등록 — 봉투종류명("티켓봉투") 부재 | 🟡 라벨 GAP | 운영 라벨 권위(siz_nm vs 옵션) | 매핑은 가격대조로 확정. 운영화면 인지 라벨 보강 컨펌. |

---

## 4. 라이브 실측 직접 인용 (재현 가능)

```
-- 단가행 수
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ENV_MAKING';  → 40
-- distinct 소재 (169 누락 증거)
SELECT DISTINCT mat_cd FROM ... WHERE comp_cd='COMP_ENV_MAKING';  → MAT_000159, MAT_000168  (169 없음)
-- prc_typ (ENV-C3 증거)
COMP_ENV_MAKING | PRICE_TYPE.01 | use_dims=["siz_cd","mat_cd","min_qty"]
   ↳ unit_price(min_qty=1000)=96000  (=1000매 구간총액, 장당 96원)
-- 세트형 부재 증거
SELECT * FROM t_prd_product_sets WHERE prd_cd='PRD_000050' OR sub_prd_cd='PRD_000050';  → 0건 (28행 중)
-- 횡단: opt_cd/proc_cd 전역 미사용
SELECT count(opt_cd), count(proc_cd) FROM t_prc_component_prices;  → 0, 0  (전체 3481행)
-- 엔진 권위 (11-CONTEXT.md L17-18)
.01 단가형 = 장당 × 주문수량  |  .02 합가형 = 구간총액 ÷ min_qty × 주문수량
```

```
-- openpyxl 봉투제작 전수 카운트
데이터영역 B4:I8 = 8열 × 5행 = 40 데이터셀
병합셀 5: A1:I1(타이틀)·B2:C2·D2:E2·F2:G2·H2:I2(봉투종류4)
C3계열 = "레자크체크백색 110g / 레자크줄무늬백색 110g " (2소재 동일가·복합셀)
값 검산: B4=96000 C4=111000 D4=48000 H4=134000 I8=760000 → 라이브 40행 전건 일치
```

---

## 5. 결론

- **종합: CONDITIONAL-GO.** 그릇 구조·분해·차원 모델·가격사슬 완전체·세트형 부재 결론은 데이터로 정당(P1·P3·P5 PASS, P6 PASS-with-finding). **P4가 BLOCKER FAIL**(prc_typ_cd .01 오적재)로, **그릇을 그대로 엔진에 태우면 가격 폭증**한다 — 이 1건이 GO를 막는다.
- **빌더 정직성 인정**: 빌더가 ENV-C3·169누락을 자기 산출 안에서 스스로 적발·교정제안한 것은 정직. 다만 structure.md/README "한 줄 평결 = 순수 단가형(.01)"은 빌더 자신의 ENV-C3와 **모순**이므로 검증자가 엔진 권위로 **합가형(.02)이 정답**임을 종결한다. → 빌더에게 structure.md §0·§4·README 평결을 ".02 합가형(라이브 .01 오적재)"으로 통일 보정 인계.
- **세트형 부재 결론**: `PRD_000050` 미참조(product_sets 0건) 실측으로 round-16 세트형 부재 결론 **정당** — 검증자 동의.
- **실 적재(prc_typ_cd 교정·169 INSERT)는 인간 승인.** 라이브 직접 쓰기 없음.
