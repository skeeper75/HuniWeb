# 독립 교차검증 요청 — 후니프린팅 셋트상품 088 "레더 링바인더" 가격구성 재설계 적재본

당신은 인쇄 커머스 가격엔진의 **독립 2차 검증자**다. 아래는 한 셋트상품(부품조립형)의 가격구성 재설계 적재본(SQL 8행)과 그 권위 근거다. **다른 검증자의 판정은 제공되지 않는다 — 당신이 스스로 처음부터 판정하라.** 근거 없는 추정은 "가설"로 표기하고, 사실 주장은 반드시 아래 제공 데이터로만 뒷받침하라.

## 도메인 배경 (가격엔진 계약)
- 셋트 완제품 `prd_cd`(부모) ← 반제품 구성원 `sub_prd_cd` (`t_prd_product_sets`).
- `evaluate_set_price` = Σ(각 member의 evaluate_price) + 부모공식 evaluate_price(copies) + 할인. (pricing.py:854)
- 각 member의 evaluate_price는 그 member(prd_cd)에 바인딩된 가격공식(t_prd_product_price_formulas → t_prc_price_formulas → t_prc_formula_components → t_prc_price_components → t_prc_component_prices)으로 계산.
- prc_typ=`PRICE_TYPE.01`(단가형)이고 use_dims=`["min_qty"]`이면: 수량밴드 lookup 후 unit_price × (출력매수). 여기서는 표지 출력매수=부수(cover_mult ×1 전제).
- 부모공식은 use_dims에 `proc_cd`가 있는 component를 쓰면, 상품(prd_cd)의 `t_prd_product_processes`에 선언된 proc_cd로 밴드가 매칭된다.

## 대상 상품 088 (라이브 실측)
- PRD_000088 "레더 링바인더" = PRD_TYPE.01(셋트 완제품). A4·표지 레더(화이트)·면지4종·D링(31/42/56)·**내지 없음(빈 바인더)**.
- 셋트 구성원 5행(t_prd_product_sets, parent=088):
  - seq1 PRD_000089 표지(레더 화이트) .02 반제품 qty1
  - seq2 PRD_000090 면지(화이트) .02 qty1
  - seq3 PRD_000091 면지(블랙) .02 qty1
  - seq4 PRD_000092 면지(그레이) .02 qty1
  - seq5 PRD_000093 면지(인쇄) .02 qty1
- 구성원 전부 라이브 실재·전부 .02 반제품.

## 권위 데이터 (verbatim)
### (A) 싸바리바인더 제본비 — 인쇄상품_가격표_260702 > 제본 sheet (수량밴드 단일축, 부당 원, 두께/링종류축 없음)
```
qty_band, 싸바리바인더
1,      30000
4,      25000
10,     20000
50,     15000
100,    9000
1000,   7000
```
- 라이브 component `COMP_BIND_SSABARI`(prc_typ=PRICE_TYPE.01, use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"], proc_cd=PROC_000098 싸바리 밴드) 실재, 위 6밴드 verbatim 일치. 단 현재 이 component는 어떤 공식에도 배선 안 됨(고아).

### (B) 레더 링바인더 표지 소재+인쇄비 — 출력소재관리 0702 (사용자 실무진 발췌·verbatim)
```
구역=하드커버전용, 행명=레더 링바인더 A4, 규격설명="A4 하드커버 표지사이즈 기준 636*374기준 소재비", 가격=9000
```
- 실무진 공식 문장: "소재+인쇄비는 (출력소재관리)>하드커버전용>레더링바인더 A4에 가격 입력해놨다" → 9,000이 소재+인쇄비 통합가.
- ★주의: 이 9,000 행은 260702 가격표 IMPORT 시트 본문에는 아직 없고(레더하드커버 A4=7000만 존재), 실무진 별도 발췌로 전달됨. 따라서 라이브 단가행 부재 → 신규 mint 필요.

### (C) 사용자 기대 골든 (재설계 목표값)
- 1부 = 39,000 / 10부 = 290,000 / 100부 = 1,800,000

## 검증할 재설계 적재본 (apply.sql 8행 요지)
1. mint component `COMP_LEATHER_RINGBINDER_COVER`(레더 표지 소재+인쇄비, prc_typ=PRICE_TYPE.01, comp_typ=PRC_COMPONENT_TYPE.06, use_dims=["min_qty"]).
2. mint 단가행: COMP_LEATHER_RINGBINDER_COVER @ apply_ymd=2026-06-01, min_qty=1, unit_price=9000 (flat 단일밴드). comp_price_id=MAX+1, NOT EXISTS 가드.
3. mint 공식 `PRF_LEATHER_RINGBINDER_COVER`.
4. mint 배선: PRF_LEATHER_RINGBINDER_COVER → COMP_LEATHER_RINGBINDER_COVER (disp_seq1, addtn_yn=Y).
5. member 089 바인딩: PRD_000089 → PRF_LEATHER_RINGBINDER_COVER (apply_bgn_ymd=2026-01-01). (현재 089 공식 0건)
6. DELETE 부모 배선: PRF_LEATHER_RINGBINDER_SET → COMP_HC_MUSEON_COVERBIND (기존 하드커버무선 blended 표지+제본 comp 배선 제거. component 자체는 타상품용 보존).
7. INSERT 부모 배선: PRF_LEATHER_RINGBINDER_SET → COMP_BIND_SSABARI (disp_seq1, addtn_yn=Y).
8. INSERT 088 proc: PRD_000088 → PROC_000098 (mand=Y). (현재 088 proc 0건) — 싸바리 밴드로만 매칭되게 proc 격리.

- 부모공식 PRF_LEATHER_RINGBINDER_SET는 088에 바인딩된 셋트 완제품 공식(실재, shell 재사용).
- member 090~093(면지)은 가격공식 0행 유지 → 기여 0 (제본비에 면지 포함).
- 088에 수량구간 할인 테이블 바인딩 없음(0건).
- 현 임시 모델(교체 대상): 부모공식이 COMP_HC_MUSEON_COVERBIND 단일 → 1부 34,100 / 100부 796,900.

## 멱등 SQL 세부 (검토용)
- (1)(3) ON CONFLICT(comp_cd)/(frm_cd) DO UPDATE. (4)(7) ON CONFLICT(frm_cd,comp_cd) DO UPDATE. (5) ON CONFLICT(prd_cd,apply_bgn_ymd) DO UPDATE. (8) ON CONFLICT(prd_cd,proc_cd) DO UPDATE. (2) NOT EXISTS(comp_cd,apply_ymd,min_qty). (6) 무조건 DELETE(멱등).
- undo.sql: 7역 DELETE SSABARI배선 → 6역 INSERT COVERBIND배선복원 → 5역 DELETE 089바인딩 → 4역 DELETE 표지배선 → 3역 DELETE 표지공식 → 2역 DELETE 표지단가행 → 1역 DELETE 표지component → 8역 DELETE 088 proc.

---

## 독립 판정 요청 (항목별로 GO/NO-GO/CONDITIONAL + 근거)

**Q1. 골든 재계산.** 위 모델로 copies=1/10/100 각각의 final_price를 당신이 직접 재계산하라. member 089(9000×부수) + 부모(싸바리 밴드단가×부수) + 면지0. 사용자 기대(39,000/290,000/1,800,000)와 일치하는가? 밴드 lookup(10부=20000, 100부=9000)이 맞는가?

**Q2. 오구성.** 완제품을 구성원으로 넣었거나 반제품 누락이 있는가? member 5행(표지1+면지4·내지 없음) 구조가 권위(빈 바인더)와 정합한가?

**Q3. 가격 결함(중대).**
 (a) 이중합산: 표지 9,000이 부모공식과 member 089 양쪽에서 중복 합산될 구조인가? (부모=SSABARI만, member089=표지comp만인지 확인)
 (b) COVERBIND 배선 제거(#6) 후 잔여 배선 오염/고아 발생 가능성.
 (c) 싸바리 6밴드 값이 권위와 정합한가.
 (d) min_qty 차원 해석: 10부일 때 밴드 lookup이 20,000/부(밴드10)로 적용되는 게 맞는가? (밴드 경계 해석: 4≤q<10 vs 10≤q<50 등)
 (e) 표지 component가 flat 단일밴드(min_qty=1만)인데 copies=100일 때 9,000×100=900,000이 맞는가, 아니면 밴드 없어서 다르게 계산될 위험?

**Q4. SQL 안전.** 복합PK 중복, FK 고아(089·088·PROC_000098·COMP_BIND_SSABARI 실재 전제), 멱등성 구멍, undo 대칭성.

**Q5. False-positive 적발.** 위 설계 중 "정당한 구성인데 결함으로 오판하기 쉬운" 지점을 지적하라(예: 면지 4행 동시등록·flat 단일밴드·proc 격리).

각 Q에 대해 명확한 판정과 근거를 제시하고, 마지막에 **종합 판정(설계 지지 / 조건부 / 수정 필요)**과 발견한 결함/리스크 목록을 우선순위로 정리하라.
