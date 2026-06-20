너는 후니프린팅 디지털인쇄 가격엔진 설계의 **독립 외부 검토자**다. 아래 설계 산출물을 읽고, 다른 누구의 판정도 참고하지 말고 **너 자신의 독립 판정**을 내려라. 근거와 함께, 모르면 "모른다"고 명시하라.

## 배경: 후니 가격엔진 구조 (사실)
- 후니 라이브 가격엔진 `evaluate_price`는 4단 구조: 공식(price_formulas) → 공식-구성요소 배선(formula_components) → 구성요소(price_components, prc_typ=단가형/합가형) → 단가행(component_prices, 차원 매트릭스).
- 엔진 동작(엔진 계약):
  - 공식 가격 = Σ(배선된 구성요소 subtotal). frm_typ는 참조 안 함(분기 없음·항상 합산).
  - **단가형(PRICE_TYPE.01)**: subtotal = unit_price × qty.
  - **합가형(PRICE_TYPE.02)**: subtotal = (unit_price ÷ min_qty) × qty.
  - 단가행 매칭: 선택값(selections)이 그 단가행의 use_dims(예 mat_cd·min_qty·print_opt_cd·siz_cd·bdl_qty)와 전부 일치해야 매칭. 어떤 use_dim 컬럼이 단가행에서 NULL이면 그 차원은 "무엇이든 매칭"으로 통과.
  - 한 공식에 여러 구성요소가 배선되면 매칭된 것들이 전부 합산됨. addtn_yn=Y는 가산 비목.
  - min_qty는 수량구간 하한('이상' 최대임계). min_qty=NULL인 합가형은 ÷NULL 오류.

## 검토 대상 설계 산출물 (이것만이 증거)
아래 파일들을 직접 읽어라(워크디렉토리=프로젝트 루트):
- `_workspace/huni-price-engine-design/03_design/engine-design-digitalprint.md` — 디지털인쇄 완제품 가격공식+구성요소+바인딩 설계.
- `_workspace/huni-price-engine-design/03_design/set-product-design.md` — 엽서북/포토카드 등 세트/반제품 가격 모델.
- `_workspace/huni-price-engine-design/03_design/golden-cases.md` — 대표 케이스 + 기대 골든값(단가=가격표 verbatim).
- `_workspace/huni-price-engine-design/03_design/design-decisions.md` — 설계 결정·흡수·컨펌큐.
- `_workspace/huni-price-engine-design/01_formula/formula-map-digitalprint.md` — 상품→구성요소→계산방식 지도.
- `_workspace/huni-price-engine-design/02_benchmark/absorption-candidates.md` — 경쟁사(RedPrinting/WowPress) 흡수 후보 C-1~C-5.

## 너의 독립 판정 질문 (각각 근거 제시)

### Q1. 설계 건전성 — 이 가격공식+구성요소 설계가 디지털인쇄 상품을 실제로 가격계산 가능하게 하는가?
- 빠진 구성요소로 견적 결과가 안 나오는 상품이 있나?
- 오배선(엉뚱한 구성요소가 합산됨)이 있나?
- 차원 미스매치(use_dims와 단가행 차원이 안 맞아 매칭 실패/오매칭)가 있나?

### Q2. ★돈크리티컬 — 단가형 ×qty 분석 (직접 계산해보라)
- golden-cases의 명함(GC-1 스탠다드명함)·포토카드(GC-5/6)·엽서북(GC-7/8)·박(GC-4)을 보라.
- 이 상품들의 구성요소가 **prc_typ=단가형(.01)**인데 단가(unit_price)가 "100매 1세트 총액" 또는 "수량구간 묶음 총액"처럼 보인다(예 명함 3500=100매 총액, 엽서북 11000=2매 단가, 박 24800=200매 tier).
- 엔진이 **단가형이면 subtotal = unit × qty**로 계산한다. 그러면 손님이 qty=100(또는 그 구간 수량)을 주문하면 **계산 결과가 어떻게 되는가? 직접 곱해보라.** 예: 명함 unit=3500, qty=100 → ?
- 기대 골든값(명함 3500·엽서북 11000·박 29800·포토카드BULK 9500)과 **일치하는가, 아니면 ×qty 만큼 과대청구되는가?**
- 이 ×qty 과청구 위험이 **어느 상품들까지** 퍼지는가? golden-cases에서 D-10이 "명함"만 언급하는데, 같은 패턴(단가형+묶음/구간총액 단가)이 엽서북·포토카드BULK·박 SETUP에도 있는가? 설계가 그 범위를 제대로 잡았는가?

### Q3. ★인쇄면(단면 S1/양면 S2) 합산 분석
- 명함과 엽서북은 인쇄면을 **별도 구성요소**로 인코딩한다(예 COMP_NAMECARD_STD_S1 단면, COMP_NAMECARD_STD_S2 양면). 두 구성요소가 **한 공식에 둘 다 배선**되고, 그 단가행의 print_opt_cd(인쇄면 차원)가 NULL이다.
- 엔진은 NULL 차원을 "무엇이든 매칭"으로 통과시키고 매칭된 구성요소를 전부 합산한다.
- 그러면 손님이 인쇄면 하나(단면)를 선택해도 **S1과 S2가 둘 다 매칭되어 합산되는가?** 직접 추론하라. 결과가 단면+양면 합산(예 3500+4500=8000)이 되는가?
- 설계는 이 문제를 "ERR_AMBIGUOUS(견적 깨짐·둘 다 매칭되어 모호)"라고 진단한다(design-decisions D-2b·D-3). 그런데 별도의 두 구성요소가 합산되는 상황이 "모호해서 견적이 깨지는 것"인가, 아니면 "조용히 둘 다 합산되어 과청구되는 것"인가? **너의 독립 판단으로 어느 쪽인지 말하라.** print_opt_cd 차원 충전이 푸는 것이 정확히 무엇인지도.

### Q4. 세트(엽서북) 이중계상 분석
- set-product-design은 엽서북이 "완제품 통합단가·이중계상 0"이라 판정한다.
- 하지만 엽서북 PCB 구성요소도 S1_20P·S2_20P를 한 공식에 둘 다 배선한다(Q3과 동형). 그리고 prc_typ=단가형이다(Q2와 동형).
- 엽서북 견적이 정말 "이중계상 0·완제품 단일가"인가, 아니면 Q3(인쇄면 합산)·Q2(×qty)가 엽서북에도 발생하는가? 설계의 "이중계상 0" 판정이 맞는가?

### Q5. 경쟁사 흡수 타당성 (overfit/답습 여부)
- absorption-candidates의 C-2(자재×허용수량 제약)·C-4(자재×후가공 비활성 제약) 흡수가 답습(경쟁사 베끼기)인가, 아니면 후니에 정당한 가드인가?
- 신규 가격축/테이블을 남발하나, 아니면 기존 그릇(제약 레이어)으로 닫히는가? overfit 위험은?

### Q6. 골든 재현
- golden-cases의 기대 골든값(GC-1~GC-10)이 설계 공식을 그대로 엔진에 태웠을 때 재현되는가?
- 위 Q2~Q4 분석을 종합해, **설계 공식대로 라이브 엔진이 계산하면 골든값이 나오는가, 아니면 다른 값이 나오는가?** 다르다면 어느 골든이 안 맞고 그 진원이 "설계 골든값 자체가 틀림"인지 "라이브 단가행/구조 결함(prc_typ·차원부재)"인지 구분하라.

## 출력 형식
- 각 Q에 GO/CONDITIONAL/FAIL 같은 자기 판정 + 근거(어느 파일·어느 케이스).
- ×qty 과청구·인쇄면 이중합산을 발견하면 명확히 명시(구체 수치 계산 포함).
- 마지막에 종합 판정(이 설계를 그대로 적용해도 되는가)과 가장 위험한 결함 1~3개.
- 모르는 것은 "모른다"고. 추측은 추측이라고 표시.
