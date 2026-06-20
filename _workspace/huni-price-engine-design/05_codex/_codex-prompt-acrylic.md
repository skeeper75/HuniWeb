너는 후니프린팅 **아크릴(면적매트릭스형) 가격엔진 설계**의 **독립 외부 검토자**다. 아래 설계 산출물을 읽고, 다른 누구의 판정도 참고하지 말고 **너 자신의 독립 판정**을 내려라. 근거와 함께, 모르면 "모른다"고 명시하라. 추측은 추측이라고 표시.

## 배경: 후니 가격엔진 구조 (사실)
- 후니 라이브 가격엔진 `evaluate_price`는 4단 구조: 공식(price_formulas) → 공식-구성요소 배선(formula_components) → 구성요소(price_components, prc_typ=단가형/합가형) → 단가행(component_prices, 차원 매트릭스).
- 엔진 동작(엔진 계약):
  - 공식 가격 = Σ(배선된 구성요소 subtotal). frm_typ는 참조 안 함(분기 없음·항상 합산).
  - **단가형(PRICE_TYPE.01)**: subtotal = unit_price × qty.
  - **합가형(PRICE_TYPE.02)**: subtotal = (unit_price ÷ min_qty) × qty. min_qty=NULL(또는 ≤0)이면 ÷ 오류(ValueError).
  - 단가행 매칭: 선택값(selections)이 그 단가행의 차원(use_dims/NON_QTY_DIMS·예 siz_width·siz_height·mat_cd·opt_cd·min_qty)과 전부 일치해야 매칭. 어떤 차원 컬럼이 단가행에서 NULL이면 그 차원은 "무엇이든 매칭"으로 통과(와일드카드).
  - 한 공식에 여러 구성요소가 배선되면 매칭된 것들이 전부 합산됨. addtn_yn=Y는 가산 비목.
  - 면적 차원(siz_width·siz_height)은 '이하' 상한 ceiling 매칭(off-grid 주문값 → 한 단계 큰 격자). 비수량 차원(mat_cd·opt_cd)은 정확매칭.

## 검토 대상 설계 산출물 (이것만이 증거 — 워크디렉토리=프로젝트 루트)
아래 6개 파일을 직접 읽어라:
- `_workspace/huni-price-engine-design/03_design/engine-design-acrylic.md` — 아크릴 면적매트릭스 완제품 가격공식+구성요소+바인딩 설계.
- `_workspace/huni-price-engine-design/03_design/golden-cases-acrylic.md` — 대표 케이스 + 기대 골든값(단가=가격표 verbatim).
- `_workspace/huni-price-engine-design/03_design/set-product-design.md` — 세트/입체(코롯토·블럭·쉐이커) 가격 모델(아크릴 절=§7).
- `_workspace/huni-price-engine-design/03_design/design-decisions.md` — 설계 결정·흡수·컨펌큐(아크릴 절).
- `_workspace/huni-price-engine-design/01_formula/formula-map-acrylic.md` — 상품→구성요소→계산방식 지도.
- `_workspace/huni-price-engine-design/02_benchmark/absorption-candidates-acrylic.md` — 경쟁사(RedPrinting/WowPress) 흡수 후보 C-A1~C-A7.

## 너의 독립 판정 질문 (각각 근거 + 자기 판정 GO/CONDITIONAL/FAIL)

### Q1. 면적매트릭스 설계 건전성 — 이 설계가 아크릴 상품을 실제로 가격계산 가능하게 하는가?
- 본체 comp(COMP_ACRYL_CLEAR3T)의 use_dims=[siz_width, siz_height, mat_cd]와 단가행 차원이 맞아 정확히 1행이 매칭되는가? 빠진 구성요소로 견적이 안 나오는 상품이 있나?
- off-grid 사이즈(격자에 없는 값, 예 가로35×세로35)가 '이하' ceiling으로 한 단계 큰 격자(40×40)에 정확히 룩업되는가? 단가행에 ceiling 행을 만들지 않는 설계가 옳은가?
- 차원 미스매치(use_dims와 단가행 차원이 안 맞아 매칭 실패/오매칭)가 있나?

### Q2. ★돈크리티컬 — 면적단가가 개당가인가 묶음총액인가·×qty 폭발 분석 (직접 계산해보라)
- 본체 comp COMP_ACRYL_CLEAR3T는 **prc_typ=합가형(.02)**이고 단가행 min_qty가 **전건 1**이라고 설계가 주장한다.
- 합가형 엔진식은 `subtotal = (unit ÷ min_qty) × qty`다. min_qty=1이면 `unit ÷ 1 × qty = unit × qty`다.
- golden GC-A1(키링 가로30×세로30 3T, unit=3100)을 손님이 **qty=100** 주문하면 결과가 얼마인가? **직접 곱해보라.** 기대 골든(310,000)과 일치하는가, 아니면 ×qty 만큼 과대청구되는가?
- ★핵심 비교: 디지털인쇄 파일럿에선 단가가 "100매 1세트 총액"(예 명함 3500=100매 총액)인데 prc_typ가 잘못 설정돼 qty=100을 곱하면 350,000으로 ×100 폭발했다. **아크릴 면적단가(3100)는 "1개당 완제품가"인가, 아니면 "묶음/구간 총액"인가?** 가격표 매트릭스 셀의 의미를 설계 근거로 판단하라. 단가 의미가 개당가라면 ×qty가 정답이고, 묶음총액이라면 폭발이다.
- COROTTO(.01·min_qty=1)·MIRROR(.01·min_qty=NULL)는 ×qty 위험이 있는가? .01 단가형에서 ÷min_qty가 발생하는가?
- ★신규 면적행 INSERT 시 가드: CLEAR3T가 .02인데 향후 미적재 좌표를 min_qty=NULL로 INSERT하면 어떻게 되는가(÷NULL)? 설계가 이 가드(min_qty=1 명시 필수)를 잡았는가?

### Q3. ★두께=mat_cd 직교가 silent 이중합산을 차단하는가 (구조 분석)
- 두께(3T MAT_000043 / 1.5T MAT_000042)를 **별도 comp나 별도 가격축으로 분리하지 않고**, 같은 1개 comp(CLEAR3T)의 **mat_cd 차원 정확매칭**으로 두 두께를 분기한다(165행 = 3T 113 + 1.5T 52).
- 이 구조에서 PRF_CLR_ACRYL 공식에 배선된 comp는 **CLEAR3T 1개뿐**(addtn_yn=N·disp_seq=1)이다.
- 질문: 공식당 comp가 1개이고 두께를 mat_cd 정확매칭으로 1행만 선택하면, 디지털인쇄에서 발생한 "두 comp가 한 공식에 배선되고 판별차원 NULL이라 둘 다 와일드카드 통과→silent 이중합산"(예 단면+양면 합산)이 아크릴에서 **구조적으로 차단되는가?** 직접 추론하라.
- ★예외 위험: 설계는 미러(MIRROR3T·mat_cd 차원 **없음**·단가행 mat_cd NULL)를 향후 "소재 택1(투명/미러)"으로 CLEAR3T와 한 공식에 합치면 silent 이중합산 위험이 있어 mat_cd 판별차원 충전 선결을 요구하며, 그 전까지 미러 바인딩을 BLOCKED로 둔다. 이 가드/BLOCKED 판단이 타당한가, 아니면 과잉/누락인가?

### Q4. G-A1 본체 미바인딩 해소 + 미러 BLOCKED 타당성
- 라이브에 본체 아크릴 상품 중 PRD_000146(키링)→PRF_CLR_ACRYL **1건만** 바인딩돼 있고, 나머지 활성 본체 16상품 + 코롯토 168 = 17상품이 미바인딩(source=NONE·가격계산 불가)이라 설계가 진단한다.
- 설계 해소책: 투명 본체 16상품→PRF_CLR_ACRYL **재사용 바인딩**(신규 공식/comp mint 0·INSERT into product_price_formulas만), 168→PRF_COROTTO_ACRYL.
- 질문: 신규 mint 0으로 17상품 가격계산을 살리는 이 바인딩 해소가 옳은가? 빠진 상품이나 잘못된 공식 연결이 있나?
- 미러(공식·배선·바인딩 전무·바인딩 대상 상품 0개)·카라비너(comp·공식·형상 opt_cd 전무·PRD 비활성)를 "신설 확정 못 하고 컨펌 대기/BLOCKED"로 둔 판단이 정직한가, 아니면 무리하게 신설했어야 하는가?

### Q5. 경쟁사 흡수 overfit/답습 여부 (신규 가격축 0건)
- absorption-candidates-acrylic의 C-A1(두께=mat_cd 차원)·C-A2(면적 자유사이즈→매트릭스 ceiling·면적함수 부결)·C-A6(카라비너 고정가형)·C-A3(엔진 분기=frm_cd 데이터·코드 분기 부결)·C-A7(라미=자재 mat_cd·그룹핑 슬롯 신설 부결) 흡수가 답습(경쟁사 베끼기·overfit)인가, 아니면 후니에 정당한가?
- 신규 가격축/테이블을 남발하나, 아니면 기존 그릇(mat_cd 차원·면적 comp·고정가 comp·round-6 CPQ 제약)으로 닫히는가? 특히 RedPrinting `acrylic2025_price` 전용 엔진·면적함수·자재 그룹핑 슬롯을 후니에 신설하지 않고 부결한 것이 타당한가?

### Q6. 골든 재현 (허용오차 0)
- golden-cases-acrylic의 GC-A1~GC-A7이 설계 공식을 그대로 엔진에 태웠을 때 재현되는가? 직접 계산하라:
  - GC-A1 키링 30×30 3T ×100 = ? (개당 3100 기대 310,000)
  - GC-A2 30×30 1.5T ×1 = ? (mat_cd만 MAT_000042로 바꿔 2480)
  - GC-A3 비대칭 가로50×세로30 3T ×1 = ? (3800·W=가로 앞·H=세로 뒤 축 권위)
  - GC-A4 off-grid 35×35 → 40×40 ceiling = ?
- ★W×H 축 권위: 설계는 siz_width=가로(앞)·siz_height=세로(뒤)이고 **work사이즈(블리드 가산·50→60) 기준 룩업은 절대 금물**이라 한다. 만약 work사이즈로 룩업하면 30×30 주문에 40×40 단가가 나와 더 비싸진다. 이 축 권위/ work 금지가 골든 재현에 맞는가?
- 골든값 출처가 "라이브 단가행 verbatim(가격표260527)"이고 "설계가 만든 값"이 아닌가(순환참조 0)? 불일치가 나온다면 진원이 "설계 골든값 자체가 틀림"인지 "라이브 구조 결함(prc_typ·차원부재·미바인딩)"인지 구분하라.

## 출력 형식
- 각 Q에 GO/CONDITIONAL/FAIL 자기 판정 + 근거(어느 파일·어느 케이스·구체 수치 계산).
- ×qty 과청구·silent 이중합산을 발견하면 명확히 명시(구체 수치 계산 포함). 발견 못 하면 "없음"이라고 명시.
- 마지막에 종합 판정(이 아크릴 설계를 그대로 적용해도 되는가)과 가장 위험한 결함/우려 1~3개(없으면 "차단 결함 0").
- 디지털인쇄 파일럿과 아크릴의 결정적 차이(단가 의미가 개당가 vs 묶음총액)를 너의 독립 판단으로 확인/반박하라.
- 모르는 것은 "모른다"고. 추측은 추측이라고 표시.
