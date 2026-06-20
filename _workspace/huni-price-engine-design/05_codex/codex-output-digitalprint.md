검토 범위: 지정한 6개 파일만 근거로 봤고, 라이브 DB는 호출하지 않았다. 따라서 “실제 라이브 코드가 문서와 다르게 ERR를 던지는지”는 모른다. 다만 사용자가 제시한 엔진 계약을 그대로 적용하면 결론은 명확하다.

## Q1. 설계 건전성: **FAIL**

구조 방향은 일부 맞다. 명함 variant별 PRF 분리, orphan comp 재배선, 신규 comp 최소화는 건전하다. 근거는 [engine-design-digitalprint.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-digitalprint.md:87)의 variant 전용 PRF 설계와 [design-decisions.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/design-decisions.md:84)의 search-before-mint 결과다.

하지만 그대로 적용 가능하지 않다.

- **누락/미완료**: 형압명함 comp 부재, 봉투류 경계, 와이드접지리플렛 접지타입, 유광코팅 단가행 결손이 남아 있다. [engine-design-digitalprint.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-digitalprint.md:150)
- **차원 미스매치**: 명함 S1/S2, 엽서북 S1/S2·20P/30P가 같은 공식에 함께 배선되는데, 판별 차원이 비어 있거나 부족하다. [engine-design-digitalprint.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-digitalprint.md:110), [set-product-design.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/set-product-design.md:51)
- **돈크리티컬 prc_typ 불일치**: 완제품/묶음 총액처럼 보이는 단가를 단가형으로 두면 `unit_price × qty`가 된다. 이 설계는 “가격계산 가능”하더라도 “정확한 가격계산”은 실패한다.

## Q2. 단가형 ×qty: **FAIL**

사용자 제시 엔진 계약상 단가형은 `subtotal = unit_price × qty`다.

- GC-1 명함: `3500 × 100 = 350,000원`. 기대값 3,500원과 불일치. 문서도 이 위험을 감지했다. [golden-cases.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases.md:31)
- GC-2 명함 양면: `4500 × 100 = 450,000원`. 기대값 4,500원과 불일치.
- GC-3 코팅명함: `5500 × 100 = 550,000원`. 기대값 5,500원과 불일치.
- GC-6 포토카드 BULK: `9500 × 100 = 950,000원`. 기대값 9,500원과 불일치. [golden-cases.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases.md:64)
- GC-7 엽서북: `11000 × 2 = 22,000원`. 기대값 11,000원과 불일치.
- GC-8 엽서북: `5200 × 20 = 104,000원`. 기대값 5,200원과 불일치.
- GC-4 박: 문서상 `FOIL unit=24800, min_qty=300`, 기대는 `24800 + 5000 = 29,800원`. 단가형이면 FOIL만 `24800 × 300 = 7,440,000원`. SETUP 5000도 같은 qty로 단가형 합산되면 `5000 × 300 = 1,500,000원`, 총 `8,940,000원`이다. [golden-cases.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases.md:47)

이 위험은 명함만이 아니라 **명함 전 variant, 포토카드 BULK, 엽서북, 오리지널박명함 FOIL/SETUP**까지 퍼진다. 설계의 D-10은 명함만 명시해서 범위를 과소평가했다. [design-decisions.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/design-decisions.md:99)

## Q3. 인쇄면 S1/S2 합산: **FAIL**

사용자가 준 엔진 계약대로라면, 이건 “ERR_AMBIGUOUS로 깨짐”이 아니라 **조용히 둘 다 합산될 가능성이 높다**.

명함 S1/S2가 같은 공식에 둘 다 배선되고 `print_opt_cd`가 NULL 또는 use_dims 밖이면, 단면 선택을 해도 S1과 S2가 모두 통과한다. 그러면 GC-1은 최소:

- S1: `3500 × 100 = 350,000`
- S2: `4500 × 100 = 450,000`
- 합계: `800,000원`

기대값 3,500원이 아니다.

문서는 이를 ERR_AMBIGUOUS라고 부르지만 [engine-design-digitalprint.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-digitalprint.md:82), 사용자가 제시한 “한 공식에 여러 구성요소가 배선되면 매칭된 것들이 전부 합산”이라는 계약을 기준으로는 **silent overcharge**가 더 타당한 독립 판단이다.

`print_opt_cd` 충전이 푸는 문제는 “모호성 표시”가 아니라 **S1 행은 단면 선택에서만, S2 행은 양면 선택에서만 매칭되게 하는 판별 차원 부재**다. 단, 단순히 컬럼값만 채우는 것으로는 부족할 수 있다. 계약상 매칭은 `use_dims` 기준이므로 `print_opt_cd`가 실제 use_dims에 포함되어야 한다.

## Q4. 엽서북 이중계상: **FAIL / 부분만 맞음**

“내지+표지 별도 합산을 하지 않는다”는 의미에서는 맞다. 문서는 엽서북을 완제품 통합단가로 보고, 내지/표지는 BOM이지 가격 comp가 아니라고 정리한다. [set-product-design.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/set-product-design.md:31)

하지만 가격엔진 관점에서는 “이중계상 0” 판정이 불완전하다.

- PCB S1_20P·S2_20P가 같은 공식에 있고 `use_dims=[siz_cd,min_qty]`라면 단면 선택에도 둘 다 매칭될 수 있다.
- 20P·30P도 같은 `siz_cd + min_qty`이면 4개 comp가 동시 매칭될 수 있다고 문서 스스로 인정한다. [set-product-design.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/set-product-design.md:51)
- 게다가 prc_typ이 단가형이면 GC-7은 `11000 × 2 = 22,000원`, GC-8은 `5200 × 20 = 104,000원`이다.

따라서 엽서북은 “내지+표지 이중계상”은 피했지만, **인쇄면/페이지 comp 동시합산 + ×qty 과청구**가 남아 있다. 기대 골든값 11,000/5,200은 그대로는 재현되지 않는다.

## Q5. 경쟁사 흡수 타당성: **GO**

C-2와 C-4는 답습으로 보이지 않는다. 둘 다 가격축이나 신규 테이블을 만들지 않고, 기존 CPQ 제약 레이어로 닫는다.

- C-2는 자재별 허용 수량을 선택 제약으로 막는 가드다. 가격은 이미 `mat_cd × min_qty`로 표현되며, 부족한 것은 “선택 가능 조합”이다. [absorption-candidates.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/02_benchmark/absorption-candidates.md:50)
- C-4는 자재×후가공 불가 조합을 막는 생산/견적 정합 가드다. [absorption-candidates.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/02_benchmark/absorption-candidates.md:88)
- 신규 테이블 0건, 기존 constraints JSONLogic 사용이라는 점도 과적합 위험을 낮춘다. [absorption-candidates.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/02_benchmark/absorption-candidates.md:125)

단, 권위 엑셀/후니 운영 규칙에 없는 경쟁사 제약을 그대로 넣으면 답습이 된다. 문서는 “경쟁사는 갭헌팅, 권위 엑셀이 최종”이라고 명시하므로 그 전제에서는 GO다.

## Q6. 골든 재현: **FAIL**

설계 공식 그대로 라이브 엔진 계약에 태우면 주요 골든은 재현되지 않는다.

- GC-1: 기대 3,500 → 실제 `350,000`, S1/S2 동시합산이면 `800,000`.
- GC-4: 기대 29,800 → 실제 최소 FOIL만 `7,440,000`, SETUP까지 단가형이면 `8,940,000`.
- GC-5: 기대 6,000 → `qty=1`이라 이 케이스만 재현 가능. 다만 일반 SET/CLEAR_SET을 같은 공식에 넣고 같은 판별 차원이면 동시합산 위험은 별도 확인 필요.
- GC-6: 기대 9,500 → 실제 `950,000`.
- GC-7: 기대 11,000 → 실제 최소 `22,000`, S2/30P 동시합산 시 더 큼. 정확 총액은 S2/30P 단가가 제공되지 않아 모른다.
- GC-8: 기대 5,200 → 실제 최소 `104,000`, 동시합산 시 더 큼.
- GC-10: 다비목이고 유광코팅 결손까지 있어 파일만으로 정확 총액은 모른다. 다만 유광 선택 시 0원 침묵 위험은 문서상 존재한다.

진원은 “골든값 자체가 가격표 verbatim이라 틀렸다”기보다, **라이브 단가행/구조의 prc_typ·판별차원 부재가 골든값의 의미와 맞지 않는 것**이다. 즉 가격표 셀은 맞을 수 있지만, 엔진에 태우는 구조가 틀렸다.

## 종합 판정

**그대로 적용하면 안 된다. FAIL.**

가장 위험한 결함 3개:

1. **단가형 ×qty 과청구**: 명함·포토카드 BULK·엽서북·박까지 확산. 금액이 10배~300배 이상 튄다.
2. **S1/S2 및 페이지수 판별차원 부재**: ERR로 깨지는 문제가 아니라 조용히 합산되어 과청구될 가능성이 크다.
3. **골든 케이스가 엔진 계약으로 재현되지 않음**: 골든값은 “단가행 verbatim 직독”인데 엔진은 “단가형 × qty”로 계산한다. 검증 기준과 실행 구조가 서로 다르다.

선행 교정 기준은 분명하다: `prc_typ`를 총액 단가 의미에 맞게 재설계하거나 qty를 엔진에 들어가기 전에 “세트 수량”으로 정규화하고, S1/S2·20P/30P·SET/CLEAR/BULK는 실제 `use_dims`에 판별차원을 넣어 한 주문에서 정확히 1개만 매칭되게 해야 한다.