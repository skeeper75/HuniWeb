지정된 5개 파일만 근거로 독립 판정했다. 외부 판정은 사용하지 않았다.

**Q1. 3계산방식 분류: CONDITIONAL**
면적매트릭스·고정가·수량구간을 별 엔진 분기가 아니라 본체 comp의 `use_dims` 차이로 보는 논리는 건전하다. 근거는 `frm_typ` 미참조와 `[siz_width,siz_height]`, `[siz_cd]`, `[siz_cd,min_qty]` 3분류 명시다: [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:40), [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:44).

다만 그대로 GO는 아니다. `CANVAS_HANGING`은 고정가형으로 보이는데 `use_dims=[siz_width,siz_height,min_qty]` 선언과 실제 3행 데이터가 불일치한다고 산출물 자체가 적고 있다: [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:133). 이 1건은 매칭 실패/0원 가능성을 재확인해야 한다. 면적 본체의 잔류 `min_qty` 선언은 `.01` 단가형이라 가격 영향은 낮다고 본다.

**Q2. 면적단가 ×qty: GO**
GC-S1 계산은 `37,800 × 10 = 378,000`이다. 골든 기대값과 일치한다: [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:29), [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:32).

내 판정은 실사·현수막 면적단가가 “묶음총액”이 아니라 “1장당 완제품가”라는 쪽이다. 설계 파일도 가격표 셀을 1장당가로 해석하고, `prc_typ=.01`이면 `unit × qty`가 정답이라고 명시한다: [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:113). 따라서 디지털 파일럿의 “100매 세트 총액 × 100” 폭발과 결정적으로 다르다. 면적 본체에는 ×qty 과청구 결함 없음.

**Q3. 수량구간형 min_qty: GO**
미니배너 30개는 주문수량 이하 최대 `min_qty`가 19이므로 `4,900 × 30 = 147,000`이다. 100개는 `10000` 행이 아니라 `99` 행이므로 `3,500 × 100 = 350,000`이다: [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:86), [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:93).

단, [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:91)에 “280,000”이라는 낡은/모순 문구가 남아 있다. 같은 줄의 주의 문구, 다음 설명, 체크리스트는 350,000이 맞다. 수량밴드 단가는 구간 총액이 아니라 개당가로 보는 것이 타당하다. `t_dsc`를 또 붙이면 이중 볼륨할인이 되며, 설계는 이 위험을 잡고 있다: [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:151).

**Q4. G-S1 후가공 배선: CONDITIONAL**
진단은 맞다. `PUNCH_4/6/8`처럼 `use_dims=[]`이고 전 차원 NULL인 comp를 그대로 같은 공식에 배선하면 선택값과 무관하게 모두 매칭된다. 본체 8,000원 현수막에 타공 4/6/8을 모두 배선하면 `8,000 + 3,000 + 4,000 + 5,000 = 20,000`이 된다. 타공 6개 정답은 `8,000 + 4,000 = 12,000`이다: [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:179), [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:119).

따라서 “판별차원 충전 후 배선” 가드는 과잉이 아니라 필수다. 공통 후가공 중 `proc_cd`/`opt_cd`/`siz_cd`가 있는 것들은 구조상 더 안전하다: [engine-design-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/engine-design-silsa-banner.md:175). 다만 후가공/거치가 1장당인지 1주문건당인지는 모른다. 설계는 이를 컨펌큐로 남겼고, 이 처리는 정직하다. 예를 들어 거치대 25,000원이 1건당인데 qty=10에 `.01`로 곱하면 250,000원이 되어 과청구다: [design-decisions.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/design-decisions.md:292).

**Q5. 경쟁사 흡수: GO**
C-SB1~C-SB7은 답습이라기보다 후니 기존 그릇으로 닫는 방식이다. 신규 `real_price` 엔진, 면적함수, 자재 그룹핑 슬롯을 만들지 않고 `siz_width/siz_height` 매트릭스, `nonspec_*`, 소재별 공식, 고정가 comp, CPQ 제약, `dim_vals`로 처리하는 판단은 타당하다: [absorption-candidates-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/02_benchmark/absorption-candidates-silsa-banner.md:42), [absorption-candidates-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/02_benchmark/absorption-candidates-silsa-banner.md:264).

내 독립 판단으로 신규 가격축 신설 필요는 없음. 단 WowPress는 미관측이라고 되어 있으므로, WowPress를 근거로 한 보강은 “모른다”가 맞다: [absorption-candidates-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/02_benchmark/absorption-candidates-silsa-banner.md:34).

**Q6. 골든 재현: CONDITIONAL**
재현되는 것: GC-S1 `378,000`, GC-S3 린넨 `600×600=17,000`, `600×1800=32,400`, GC-S7 `147,000`/`350,000`, GC-S10 미충전 `20,000` vs 충전 후 `12,000`은 엔진 계약과 산출물 수치가 맞다: [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:45), [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:151).

조건부인 이유는 세 가지다. 첫째, GC-S5 `650×650`은 “다음 큰 ceiling 셀”이라는 규칙은 맞지만, 지정 5개 파일만으로 정확히 700×700인지 900×900인지 확정 못 한다. 파일도 “예 700×700 또는 900×900 첫 행 8,000”처럼 쓴다: [golden-cases-silsa-banner.md](/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/golden-cases-silsa-banner.md:59). 둘째, 후가공 골든은 현재 라이브 미배선 상태와 배선 후 상태를 구분해야 한다. 셋째, GC-S7 100개 행의 280,000 문구는 오류로 보이며 350,000이 정답이다.

**종합 판정**
그대로 적용하면 안 된다. 본체 가격사슬과 3계산방식은 GO에 가깝지만, 후가공 배선은 조건 충족 전 적용 금지다.

가장 위험한 결함/우려는 3개다.

1. 배너 후가공 `use_dims=[]` 상태에서 배선 시 silent 이중합산: 타공 6개가 12,000이 아니라 20,000으로 과청구.
2. 후가공/거치의 1장당 vs 1주문건당 의미 미확정: 거치대류는 ×qty 과청구 가능성이 큼.
3. `CANVAS_HANGING` 차원 선언 불일치와 GC-S7 100개 표기 오류 같은 문서/데이터 정합 이슈.

디지털인쇄 파일럿과의 결정적 차이는 명확하다. 디지털은 단가가 묶음총액인데 `.01`로 qty를 곱해 폭발했다. 실사·현수막 면적단가는 1장당 완제품가로 보는 근거가 충분하고, `.01 unit×qty`가 정상 계산이다.