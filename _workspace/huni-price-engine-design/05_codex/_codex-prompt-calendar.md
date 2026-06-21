# codex 독립 2차 교차검증 프롬프트 — 캘린더 가격엔진 설계 (Phase 5.5)

> ★우리(Claude) 게이트 판정·E1~E7 결론 일절 비노출. codex는 설계·지도·골든·권위·엔진계약만 보고 자기 독립 판정을 낸다.

## 프롬프트 (codex exec stdin)

당신은 인쇄 자동견적 가격엔진 설계의 독립 외부 심사관입니다. 한 한국 인쇄회사(후니프린팅)의 "캘린더"(탁상형·미니탁상형·엽서·벽걸이·와이드벽걸이) 가격계산 엔진 설계를 받았습니다. 이 설계가 실제로 가격계산을 성립시키는지 독립적으로 판정하세요. 다른 사람의 판정은 받지 않았습니다 — 당신의 독립 의견이 필요합니다. 가격은 돈 크리티컬입니다.

### 배경 (엔진 계약 = 라이브 pricing.py, 고정·변경 불가)
가격엔진 evaluate_price는 가격 소스를 우선순위로 선택합니다:
1. TEMPLATE_PRICE: 타깃이 template(tmpl_cd)이고 t_prd_template_prices.unit_price 존재 → unit_price × qty
2. PRODUCT_PRICE: t_prd_product_prices.unit_price 존재 → unit_price × qty (FORMULA보다 선점)
3. FORMULA: 위가 없으면 상품-공식 바인딩(t_prd_product_price_formulas)으로 공식 평가(구성요소 합산 Σ)
4. NONE: 전부 없으면 0원(strict는 error)
- 엔진은 frm_typ_cd(공식유형)를 참조하지 않음 — 공식은 항상 구성요소 합산(addtn_yn='Y' 항의 Σ).
- 구성요소 소계: prc_typ가 단가형(.01)이면 `unit_price × qty`. 합가형(.02)이면 `unit_price ÷ tier_min_qty × qty` (tier min_qty 없으면 ValueError).
- 차원 매칭: proc_cd·opt_cd·siz_cd 등 비수량 차원은 정확매칭(NON_QTY_DIMS) — 후보가 2개 이상이면 ERR_AMBIGUOUS. min_qty는 수량구간 tier 룩업 키(분모 아님, 단가형일 때).

### 후니 라이브 현황 (읽기전용 실측 2026-06-22)
- 캘린더 5상품(PRD_000108~112): t_prd_product_prices 0행 / 공식 바인딩(t_prd_product_price_formulas) 0행 / CPQ option_groups 0행 / 수량구간할인(t_prd_product_discount_tables) 바인딩 0행. → 가격사슬 사실상 전무(견적 불가·source=NONE).
- 라이브에 실재하는 것: 제본비 구성요소 COMP_BIND_CAL_DESK220/DESK130/DESKMINI/WALL (4개)와 그 단가행. 인쇄비 COMP_PRINT_DIGITAL_S1(212행)·용지비 COMP_PAPER. 디지털인쇄 공식 PRF_DGP_A~F. 캘린더 전용 공식(PRF_CAL_*)은 부존재.
- 제본비 구성요소 prc_typ: 4개 전부 PRICE_TYPE.01(단가형). use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"]. del_yn: DESK220/130/MINI=Y(논리삭제)·WALL=N(활성, 4 proc 통합 보유).

### 권위 가격값 (verbatim — 날조 금지)
**제본비 단가행(라이브 t_prc_component_prices, 부당 단가·수량구간 tier):**
- COMP_BIND_CAL_DESK220 (proc=PROC_000100): min_qty 1→5000 · 4→4000 · 10→3000 · 50→2500 · 100→2300 · 1000→2000
- COMP_BIND_CAL_DESKMINI (proc=PROC_000102): 1→4500 · 4→3500 · 10→2500 · 50→2000 · 100→1800 · 1000→1600
- COMP_BIND_CAL_WALL (proc=PROC_000099 벽걸이): 1→5000 · 4→4000 · 10→3000 · 50→2500 · 100→2000 · 1000→2000

**캘린더가공 add-on(상품마스터 `캘린더가공_추가가격` 칸):** 우드거치대=4000 / 1구타공+끈=1000 / 2구타공+끈=1500 / 고리형트윈링제본=2000 / 삼각대(그레이/블랙)=0 / 가공없음=0

**인쇄비·용지비 단가행(라이브):** 인쇄비 국4절 단면 min1=3000/판·3절 단면 min1=3500/판 / 용지비 국4절 몽블랑190g=112.58/판

**디자인캘린더(가격포함) 시트 inline 가격(상품마스터, 대표 1 variant):** 탁상형 220x145·몽블랑190g·삼각대=10,400 / 미니 90x100·삼각대=6,500 / 엽서 145x145·제본없음=4,000 / 벽걸이 210x297·트윈링=9,900 / 와이드 300x625(3절)·트윈링=24,000

### 계산공식집초안(절대 권위 r94~98)
- r94 `[원자합산형: 캘린더]`
- r95 `판매가 = 인쇄비 + 용지비 + (제본비 or 캘린더가공비)`
- r96 `인쇄비 = [총출력장수/판걸이수] × 인쇄비` (총출력장수 = 주문수량 × **페이지수(장수)** / 판걸이수)
- r97 `제본비 = [수량행][제본종류열]`
- r98 `캘린더가공비 = [가공비] × 제작수량`

### 설계 요지 (판정 대상)
- 계산방식 = 원자합산형. 디지털인쇄 PRF_DGP_A/E chassis 직계 재사용 — 인쇄비(COMP_PRINT_DIGITAL_S1)·용지비(COMP_PAPER) comp 그대로, 차이는 **페이지수(장수) 곱** 하나뿐.
- 신규 공식 5개(PRF_CAL_DESK220/DESKMINI/POSTCARD/WALL/WALLWIDE) — 제본방식(사이즈)별 전용 공식(한 공식에 4 제본비 다 배선하면 동시매칭→ERR_AMBIGUOUS 회피). 각 공식 = 인쇄비+용지비+제본비(+가공 add-on) 구성요소 Σ.
- 제본비 prc_typ = **.01 단가형 ×qty(부당가)**가 정답. ÷min_qty 합가형(.02) 아님. min_qty는 tier 룩업 키. del_yn 충돌(DESK=Y/WALL=N)은 WALL 통합 comp 단독 사용 권장(proc_cd로 사이즈 분기) vs DESK 부활 — 인간 컨펌으로 남김.
- 캘린더가공 add-on = 신규 구성요소 1개(COMP_CALOPT_STAND), use_dims=["opt_cd","min_qty"], .01 ×qty. 우드4000/타공1000/타공1500/0을 opt_cd로 판별. (기존 린넨가공 LINEN_FINISH 그릇 동형 재사용.)
- 신규 테이블/가격축 0. PRODUCT_PRICE INSERT 금지(product_prices 0행 유지·FORMULA만 — 본체 product_prices에 값 넣으면 FORMULA 통째 우회 silent).
- 디자인캘린더 inline 가격(10,400 등)은 단가행 합산으로 깨끗이 재현 안 됨 → 에디터형 1부 정찰가 스냅샷으로 보고 BLOCKED 표기(추측 단가 INSERT 안 함).

### 당신이 독립 판정할 열린 질문 (우리 결론 없음 — 당신의 답을 주세요)
각 질문에 SOUND/RISK/FLAW (또는 ABSORBED/CONDITIONAL/REJECT) 명확한 판정 + 근거:

1. **계산방식**: 캘린더가 원자합산형(인쇄비+용지비+제본비/가공비)인가? 디지털인쇄 PRF_DGP chassis 직계 재사용이 타당한가, 아니면 새 가격축/구성요소를 놓쳤는가?

2. **★페이지수(장수 4~16) 곱 차원**: 출력매수 = 주문수량 × 페이지수 / 판걸이수. 페이지수 곱이 인쇄비·용지비에 반드시 반영돼야 하는가? 누락 시 위험을 정량화하라. 설계가 페이지수를 구성요소 차원이 아니라 "수량 배수"(앱 산식)로 흡수하는 게 건전한가?

3. **★제본비 prc_typ 결판(돈크리티컬)**: 위 제본비 단가행을 직접 보고, .01 단가형(unit×qty)이 정답인가 .02 합가형(÷min_qty×qty)이 정답인가 **독립 산출**하라. 각 경로로 DESK220 qty=4와 qty=100을 직접 계산해 비교하고, 오적용 시 붕괴를 보여라.

4. **★디자인캘린더 inline 재현**: inline 가격(탁상10,400/미니6,500/엽서4,000/벽걸이9,900/와이드24,000)을 제본비(verbatim)+인쇄비+용지비 단가행 합산으로 **깨끗이 재현 가능한가**? 제본비를 빼고 인쇄+용지 잔여가 출력판수의 정수해를 주는지 직접 검산하라. 못 하면 그 의미는(정찰가 스냅샷? 적재 시 어느 그릇이 권위인지)?

5. **add-on 평탄화/선점 위험**: 캘린더가공(우드4000 vs 타공1000)을 opt_cd 판별차원 없이 평탄 적재하면 위험한가? 본체를 product_prices에 넣으면(FORMULA 우회) 위험한가? 이 가드들이 실재 위험인가 과잉설계인가?

6. **놓친 것**: 신규로 만들 게 공식 5 + add-on comp 1뿐인가? 추가로 놓친 가격축/구성요소/세트조합/이중계상이 있는가? (캘린더봉투 addon, 링칼라/삼각대컬러 옵션, 트윈링제본의 제본비 vs 가공 분기 등)

각 항목 SOUND/RISK/FLAW 명시. 근거는 위 데이터로 직접 산술하라. 환각 금지 — 데이터에 없으면 "데이터 부족"이라고 하라.
