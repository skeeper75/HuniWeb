# engine-design-design-calendar.md — 디자인캘린더(가격포함) 가격엔진 설계 (11번째·최종 종단·고정가형 완제 SKU)

> **핵심 설계가(hpe-engine-designer) 산출 — 디자인캘린더 종단(11번째·디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치]·문구[고정가+매트릭스]·책자[부품합산세트]·스티커[이산siz단가형+세트]·상품악세사리[inline고정가]·캘린더[원자합산형]·포토북[per2p선형세트] 다음·최종).**
> cartographer 지도(`formula-map-design-calendar.md`·`component-inventory-design-calendar.md`·`gap-board-design-calendar.md`) + inline 권위(`inline-authority-evidence.md`) + benchmark 흡수(`competitor-pricing-design-calendar.md`·`absorption-candidates-design-calendar.md`·`set-pricing-design-calendar.md`) + 캘린더 직계 동형(`engine-design-calendar.md`·`golden-cases-calendar.md`)을 종합해, 디자인캘린더 7 inline 행의 **가격공식 + 가격구성요소 + t_prc_* 그릇 매핑 + G-DCAL-DUAL 결판**을 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — t_prc_*/t_prd_* 데이터 그릇/배선/바인딩 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) `디자인캘린더(가격포함)` 시트 inline 정찰가 > ② 인쇄상품 가격표(260527) > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학·경쟁사(흡수 후보·naming 유입 금지).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-22 · 단가값=권위 verbatim(날조 0·비정수 역산 단가 날조 금지) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 10종단 GO 설계와 동일 컨벤션·동일 engine-contract(pricing.py).

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나 (정찰가 BLOCKED·신규 mint 0·G-DCAL-DUAL 결판)

라이브 실측(2026-06-22 읽기전용 SELECT)이 cartographer/benchmark 지도를 **전건 확인**했고, 핵심 결판 사안 G-DCAL-DUAL을 라이브 권위로 종결했다.

| 라이브 실측 (2026-06-22) | 값 | 설계 함의 |
|--------------------------|----|-----------|
| **디자인캘린더 5 prd_cd**(t_prd_products MES 007-*) | PRD_000108~112 전부 use_yn=Y·del_yn=N·prd_typ=PRD_TYPE.04 | ★일반 캘린더와 **동일 5 prd_cd** 확정 — 신규 상품군 아님(11번째 시트지만 신규 prd 0) |
| **editor_yn** | 108/109/111/112=**Y**(편집기) · 110(엽서)=**N** | 디자인보유 ● 시트값과 정합(엽서만 ● 없음). "가격포함"=편집기형 디자인 제공 |
| **t_prd_product_prices**(108~112) | **0행**(전체 테이블도 0행) | ★G-DCAL-PRICE-EMPTY 확정 — inline 정찰가 담을 그릇조차 비어있음. **product_prices 0행 = PRODUCT_PRICE 선점 가드 자동 충족**(G-DC-2) |
| **공식 바인딩**(108~112) | **0건** | ★G-DCAL-FORMULA-WIRE 확정 — 일반 캘린더 PRF_CAL_*도, 디자인 정찰가도 **둘 다 미배선**(견적 불가·source=NONE) |
| **PRF_CAL_\* 공식 라이브 존재** | **부존재**(이름 캘린더/달력 공식 0건) | ★**G-DCAL-DUAL "이중 정의"는 현 라이브엔 미존재**(둘 다 미적재) — 충돌은 미래 적재 시점의 잠재 위험 → 설계가 분기 구조를 미리 결판 |
| **재사용 comp**(인쇄/용지/제본) | COMP_PRINT_DIGITAL_S1(212)·COMP_PAPER(56)·COMP_BIND_CAL_DESK130/220/MINI(각6·del_yn=Y)·WALL(24·del_yn=N) 전부 실재 | (의도 비목) 직계 재사용 — 단 inline BLOCKED이라 **본 시트로는 미배선** |
| **frm_cd 채번 방식** | 의미코드(PRF_<X>·숫자 suffix 아님) | 디자인캘린더 신규 공식도 의미코드 PRF_DCAL_*(채택 시) |
| **캘린더봉투 독립 PRD** | PRD_000005(012-0008·캘린더봉투) 실재 | 봉투 add-on=독립판매+본체addon 이중역할 → 봉투제작 트랙 위임(신규 mint 금지) |
| **option_groups**(108~112) | **0행** | 옵션 레이어 전면 미적재(편집기형 spec baked·가격무관 옵션 분리) |

**∴ 디자인캘린더 설계의 핵심 5가지:**
1. **계산방식 = 정찰가 스냅샷 [BLOCKED·공식화 불가]** — inline 7건(10400/9700/6500/6500/4000/9900/24000)이 단가행 산식으로 **정수·일관 재현 안 됨**(유효판수 1.313/0.486/1.285/1.574/6.104=전부 비정수·미니 0.486판으로 26P 물리 불가). 일반 캘린더(원자합산형)·포토북(per2p cost-driven 선형)과 **결정적 대비**. **추측 단가 INSERT 금지 [HARD]**.
2. **★G-DCAL-DUAL 결판 = 정찰가 채택(고정가형·.01 단가형+min_qty=1)·일반 캘린더 공식과 별 공식 분리·prd 분리 금지** — 동일 prd_cd가 두 가격을 가지면 비결정. 라이브는 둘 다 미배선이므로, 디자인캘린더는 inline 정찰가를 **고정가형 완제 SKU**(use_dims=[siz_cd])로 설계하되 일반 캘린더 PRF_CAL_* 산식과는 **별 공식·주문방법 차원 분기**(아래 §3).
3. **★고정가형이라도 add-on 있으면 formula 구조 유지(G-PRODPRICE 가드)** — 엽서캘린더 우드거치대(4000)·탁상형 봉투(2500/2400) add-on 가산이 필요 → 본체 정찰가를 product_prices 1건으로 박으면 add-on이 silent 우회(FORMULA 통째 스킵). **본체 정찰가를 .01 단가형(min_qty=1) comp로 formula 바인딩 + add-on 별 comp 가산**(GP-2·캘린더 G-CAL-2·악세사리·포토북 선례 동형).
4. **신규 mint = 0(시트 본체)** — inline BLOCKED이라 본체 공식/comp 신규 mint 0. 정찰가 채택 경로(권고)에서만 PRF_DCAL_* 5 + 정찰가 comp 1(COMP_DCAL_FIXED) mint·이는 **인간 컨펌 후**(추측 아닌 verbatim 정찰가 적재). add-on(우드거치대)은 **캘린더 종단이 신규 mint로 명시한 COMP_CALOPT_STAND에 선행 의존**(현 라이브 component·단가행 0행·캘린더 종단 소관·디자인캘린더 독자 mint 금지).
5. **세트조합 레이어 불요** — 본체 단일 prd·t_prd_product_sets 0행·페이지(30/26/12/13)=baked 사양값(책자/포토북 내지 부품 오적용 금지). benchmark set-pricing §0 부품합산❌ 정합.

> ★**prc_typ 표기 [HARD·validator 라이브 재실측 2026-06-22]**: 라이브 PRICE_TYPE enum = `.01(단가형)·.02(합가형)`뿐이고 **`.03` 부존재**(component 실측 distinct = .01/.02). 본 설계의 "고정가형 정찰가"는 라이브에 .03 그릇이 없으므로 **.01 단가형 + min_qty=1 단일 단가행**(정찰가 = 1부 단가)으로 표현한다.
> ★**qty 의미 [HARD·돈크리티컬·codex D1 적발·엔진계약 정합]**: `.01 단가형`은 엔진계약상 **항상 `subtotal = unit_price × qty`**(price-flow-map ④·engine-contract E0-1). `min_qty=1`은 **티어 비교 키**(`_tier_order_val(min_qty)=qty`·widget-price-contract W-3)이지 **qty-불변 신호가 아니다**. 따라서 본체 정찰가(예 탁상 10,400)는 **1부 단가**이며 견적가 = **정찰가 × qty**(탁상 10부 = 104,000·10,400 고정은 93,600 저청구 = G-DCAL-QTY 위반). 도메인상으로도 캘린더 정찰가는 1부 단가이므로 ×qty가 정답. 굿즈 GP-1·악세사리 inline 고정가도 "qty 무관"이 아니라 **per-unit ×qty 동일 계약**(엔진 동일). 수량구간할인(DSC)이 별도 존재하면 별 레이어(미확인 시 단순 ×qty base + Q-DCAL-DSC 컨펌큐).

★ **11종단 동형 클래스 판정**: 디자인캘린더 = **고정가형 완제 SKU**(굿즈 GP-1·상품악세사리 inline 고정가 동일 클래스) **+ 외부 add-on 가산**(우드거치대 = 캘린더 종단 신규 mint COMP_CALOPT_STAND 선행 의존·현 라이브 0행). **신규 가격축·t_prc_* 테이블 = 0건**(11연속 search-before-mint 통과). 신규 mint = (정찰가 채택 시) PRF_DCAL_* 5 + COMP_DCAL_FIXED 1뿐·인간 컨펌 후. 단가값=상품마스터 inline verbatim(비정수 역산 단가 날조 0).

`확신도: 높음(라이브 prd_cd 동일성·product_prices/바인딩/PRF_CAL 부존재 3건 실측 + inline-authority-evidence python 역산)`

---

## 1. 계산방식 — 정찰가 스냅샷 [BLOCKED] (frm_typ 미참조·inline=권위)

inline-authority-evidence §1 독립 역산(절대 권위):
- 산식 `유효판수 = (inline − 제본비) / (인쇄단가 + 112.58용지)` → 유효판수 전부 비정수(1.313/0.486/1.285/1.574/6.104).
- 페이지수(30/26/12/13)와 정수 배수 관계 없음(미니 0.486판으로 26P 물리 불가).
- ∴ inline = **에디터형 디자인 상품의 1부 정찰가 스냅샷**(소비자 표시가)이지 단가행 합산 결과 아님.

| 계산방식 | 정의 | 디자인캘린더 상품군 | 엔진 처리(engine-contract·pricing.py) |
|----------|------|---------------------|---------------------------------------|
| **고정가형(정찰가)** | 판매가 = 정찰가(1부 단가) 룩업(사이즈 차원) **× qty** + add-on Σ | 디자인캘린더 7 inline 행 | 정찰가 comp .01 단가형(min_qty=1·`unit×qty`) 룩업(use_dims=[siz_cd]) + add-on comp 가산·전부 addtn_yn='Y' Σ |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·pricing.py:8 "공식유형 frm_typ 폐기→공식은 항상 구성요소 합산"). 디자인캘린더 고정가형 = `formula_components`의 정찰가 comp(.01 단가형·min_qty=1) + add-on comp(.01)의 Σ. 굿즈 GP-1·상품악세사리 inline 고정가 §1과 동형. **단가행 산식(원자합산형 캘린더 PRF_CAL_*)은 본 시트에 미적용**(inline=합산 미재현·정찰가 권위).

`확신도: 높음(inline-authority-evidence §1.4 BLOCKED 판정·python 역산 verbatim)`

---

## 2. ★G-DCAL-DUAL 결판 — 동일 prd_cd 이중 가격 정의 (최우선·돈크리티컬)

### 2.1 결판 질문 (directive 최우선)
동일 prd_cd(PRD_000108~112)가 **일반 캘린더(공식 PRF_CAL_*·단가행 산식)** 와 **디자인캘린더(inline 정찰가)** 두 가격을 가질 수 있다. "정찰가 채택 vs 공식 통합 vs 별 prd 분리" 중 어느 게 권위·무손실인가?

### 2.2 라이브 실측 (이중 정의 충돌의 현 상태 — 결판의 토대)

| 검사 | 실측 (2026-06-22) | 함의 |
|------|-------------------|------|
| `t_prd_product_prices`(108~112) | **0행**(전체 테이블 0행) | 디자인 정찰가 그릇 비어있음 |
| 공식 바인딩(108~112) | **0건** | 일반 캘린더 산식도 미배선 |
| PRF_CAL_* 라이브 존재 | **부존재** | 일반 캘린더 설계도 아직 미적재 |

★ **결정적**: 라이브에는 일반 캘린더 공식도, 디자인 정찰가도 **둘 다 미적재**. 즉 **G-DCAL-DUAL "이중 정의 충돌"은 현 라이브엔 존재하지 않는다**(둘 다 0). 충돌은 **미래 적재 시점의 잠재 위험**이므로, 설계가 지금 분기 구조를 결판해 충돌을 원천 차단해야 한다.

### 2.3 3안 평가

| 안 | 내용 | 무손실? | 권위 정합? | 돈크리티컬 위험 | 판정 |
|----|------|---------|-----------|-----------------|------|
| **① 정찰가 채택**(권고) | inline 정찰가를 디자인캘린더 전용 공식(PRF_DCAL_*·.01 단가형 min_qty=1 고정가)으로 바인딩·일반 캘린더 PRF_CAL_*과 **별 공식·주문방법 차원 분기** | ✅ inline verbatim 보존 | ✅ 상품마스터 가격 컬럼 정찰가 명시·RedPrinting tmpl_price 표준 | 낮음 | **채택** |
| **② 공식 통합(inline 폐기)** | 디자인캘린더를 일반 캘린더 PRF_CAL_* 산식으로 흡수·inline 폐기 | ❌ inline 정찰가 손실 | ❌ 정찰가≠산식 합산값(비정수 역산)·권위 엑셀 덮어쓰기 | **높음**(정찰가 권위 폐기·산식 결과로 견적가 변동) | 부결 |
| **③ 별 prd 분리** | 디자인캘린더용 신규 prd_cd 신설 | ❌ 라이브 동일 prd_cd 실측 역행(인위 분리) | ❌ 상품마스터 동일 ID(14599 등) 위반 | 중(prd 중복·MES 충돌) | 부결 |

### 2.4 ★결판 = ① 정찰가 채택 + 주문방법 차원 분기 (무손실·비결정 회피)

**근거**:
1. **무손실**: inline 정찰가(10400 등)는 상품마스터 권위 명시값. ②는 이를 비정수 산식으로 덮어써 손실+권위 위반. ①만 verbatim 보존.
2. **업계 표준 정합(benchmark DC-1)**: RedPrinting은 디자인 제공 완제 라인을 `tmpl_price`(개당 정찰가)로 처리·산식은 고객 구성형 라인에만. 디자인캘린더는 전자.
3. **비결정 회피**: 동일 prd_cd가 두 공식을 동시 바인딩하면 evaluate_price가 어느 공식을 쓸지 비결정(ERR 또는 임의 1건). **주문방법(업로드=일반 캘린더 산식·편집기=디자인 정찰가)을 판별 차원**으로 공식을 가른다. ★**라우팅 키 [codex D2 적발·editor_yn 단독 의존 금지]**: editor_yn은 108/109/111/112=Y이나 **엽서캘린더 PRD_000110=editor_yn=N**(디자인보유 ● 없음)이라 editor_yn=Y 단독으로 라우팅하면 **엽서 정찰가 PRF_DCAL 라우팅 누락**(내부 모순). → **라우팅 신호 = "디자인캘린더(가격포함) 시트 등재 자체"**(정찰가 경로 신호) + **상품별 PRF_DCAL_* 바인딩**(엽서 포함 5상품 명시 바인딩)으로 처리·editor_yn은 보조 신호. 엽서(110)는 별 케이스로 명문(editor_yn=N이나 가격포함 시트 등재로 PRF_DCAL_POSTCARD 바인딩).
4. **add-on 보존**: ①은 formula 구조라 우드거치대/봉투 add-on 가산이 살아있음(③/product_prices 직접 적재는 add-on silent 우회).

★ **단, 정찰가 채택의 적재 자체는 인간 컨펌(Q-DCAL-AUTHORITY)** — 설계는 "정찰가 채택 시 어느 그릇·어떤 분기"를 무손실로 명세하되, 실 적재는 인간 승인 후 dbmap 위임. **추측 단가 INSERT 금지·inline verbatim만.**

`확신도: 높음(라이브 둘 다 미적재 실측 + 권위/업계 정합 + 비결정 회피 논증)`

---

## 3. 정찰가 채택 경로 공식 설계 — PRF_DCAL_* (인간 컨펌 후·고정가형 .01 단가형+min_qty=1)

> ★이하 §3~§5는 **G-DCAL-DUAL ① 정찰가 채택 결판을 인간이 비준할 경우의 설계 명세**다. 비준 전에는 BLOCKED 유지(추측 단가 금지). 채택 시 단가=inline verbatim.

### 3.1 공식 분할 — 상품(사이즈)별 전용 PRF (정찰가가 사이즈별로 다름)

inline 정찰가가 상품×사이즈 단위로 다름(탁상 220x145=10400 vs 130x220=9700). benchmark DC-1: use_dims=[siz_cd]가 유일 가격축. 동시매칭 회피를 위해 **상품별 전용 PRF**(캘린더 PRF_CAL_* 분할·디지털 variant별 전용 PRF 교훈 동형):

| 신설 공식(frm_cd·의미코드) | frm_nm(한글 표준·코드노출 0) | 바인딩 상품 | 본체 정찰가 comp | add-on |
|----------------------------|------------------------------|-------------|------------------|--------|
| **PRF_DCAL_DESK** | 디자인캘린더 정찰가 탁상형 | 탁상형캘린더 PRD_000108(220x145·130x220) | COMP_DCAL_FIXED(siz_cd 룩업) | (봉투=봉투제작 트랙·별도) |
| **PRF_DCAL_DESKMINI** | 디자인캘린더 정찰가 미니탁상형 | 미니탁상형캘린더 PRD_000109(90x100·148x60) | COMP_DCAL_FIXED | — |
| **PRF_DCAL_POSTCARD** | 디자인캘린더 정찰가 엽서형 | 엽서캘린더 PRD_000110(145x145) | COMP_DCAL_FIXED | **COMP_CALOPT_STAND**(우드거치대 4000·캘린더 종단 mint 선행 의존·현 라이브 0행) |
| **PRF_DCAL_WALL** | 디자인캘린더 정찰가 벽걸이 | 벽걸이캘린더 PRD_000111(210x297) | COMP_DCAL_FIXED | — |
| **PRF_DCAL_WALLWIDE** | 디자인캘린더 정찰가 와이드벽걸이 | 와이드벽걸이캘린더 PRD_000112(300x625) | COMP_DCAL_FIXED | — |

★ **주문방법 차원 분기 (G-DCAL-DUAL §2.4·codex D2 교정)**: 같은 prd_cd가 일반 캘린더 PRF_CAL_*(업로드)과 PRF_DCAL_*(정찰가)을 둘 다 바인딩하지 않도록 가른다. **라우팅 신호 = "디자인캘린더(가격포함) 시트 등재 = 정찰가 경로" + 상품별 PRF_DCAL_* 바인딩**이지 editor_yn 단독이 아니다 — ★**엽서캘린더 PRD_000110=editor_yn=N**이라 editor_yn=Y 단독 라우팅 시 엽서 누락(내부 모순). 5상품(엽서 포함) 전부 PRF_DCAL_* 명시 바인딩으로 라우팅하고 editor_yn은 보조 신호. evaluate_price가 경로를 selection으로 받아 공식을 가르는 배선은 옵션 레이어 의존(현 option_groups 0행) → **Q-DCAL-ROUTE 컨펌큐**(엽서 editor_yn=N 라우팅 포함·메커니즘 확정).

### 3.2 formula_components 배선 명세 (PRF_DCAL_DESK 대표 — 다른 PRF 동형)

| disp_seq | comp_cd | 의미축 | prc_typ | use_dims | addtn_yn | 단가행 상태 |
|----------|---------|--------|---------|----------|----------|-------------|
| 0 | COMP_DCAL_FIXED | 본체 정찰가(사이즈별) | **고정가형(.01 단가형·min_qty=1)** | siz_cd | **Y** | 신규(inline verbatim·인간 컨펌 후) |

PRF_DCAL_POSTCARD만 add-on 1행 추가:
| 1 | COMP_CALOPT_STAND | 캘린더 거치 가공비(우드거치대) | 단가형(.01) | opt_cd·min_qty | **Y** | 캘린더 종단 신규 mint comp 선행 의존(현 라이브 0행·우드거치대=4000) |

★ **본체 정찰가 = .01 단가형(min_qty=1·1부 정찰가 ×qty) 고정가** — 굿즈 GP-1·상품악세사리 inline 고정가와 동일 prc_typ(라이브 .03 부재)·**per-unit ×qty 동일 계약**(qty 무관 아님·G-DCAL-QTY). siz_cd 차원만 충전(나머지 spec은 정찰가에 baked·디자인비 별 comp 분리 금지·benchmark DC-1). add-on도 .01 단가형 ×qty(개당 가산·캘린더 §4.4 동형).

### 3.3 ★일반 캘린더 PRF_CAL_*와의 관계 (별 공식·중복 아님)

| 항목 | PRF_CAL_*(일반 캘린더·engine-design-calendar) | PRF_DCAL_*(디자인캘린더·본 설계) | 관계 |
|------|----------------------------------------------|-----------------------------------|------|
| 계산방식 | 원자합산형(인쇄+용지+제본 Σ·단가행 산식) | 고정가형 정찰가(.01 단가형 min_qty=1·siz_cd 룩업) | **별 계산방식**(정찰가 vs 산식) |
| 가격 권위 | 가격표 단가행(수량·페이지수 종속) | 상품마스터 inline(1부 정찰가·baked) | **별 권위 소스** |
| 주문방법 | 업로드(고객 디자인) | 편집기(후니 디자인 제공) | **차원 분기 키** |
| 본체 comp | COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_BIND_CAL_* | COMP_DCAL_FIXED | comp 비공유(별 비목 모델) |

★ 두 공식은 **동일 prd_cd를 주문방법으로 가르는 별 공식**이지 한쪽이 다른 쪽 중복이 아니다. inline 정찰가는 PRF_CAL_*의 골든이 될 수 없으므로(합산 미재현·§5) PRF_CAL_*은 가격표 단가행 기반 자체 골든을 가짐(engine-design-calendar §golden 별도). **재병합 금지**(상보 공식).

`확신도: 높음(라이브 별 공식 부존재·주문방법 분기 논증)`

---

## 4. add-on 귀속 설계 (캘린더봉투·우드거치대 · search-before-mint)

> calc-draft 동형 · 상품마스터 `추가상품(옵션)_추가가격` 칸 verbatim

### 4.1 우드거치대 (엽서캘린더·4000) = 캘린더 종단 신규 mint COMP_CALOPT_STAND 선행 의존 (현 라이브 0행)

| add-on | 출처(verbatim) | 추가가격 | 귀속 설계 |
|--------|----------------|---------|-----------|
| 우드거치대 | row8(엽서캘린더) `추가상품`=우드거치대·`추가가격`=4000 | **4,000** | **COMP_CALOPT_STAND opt_cd=우드거치대**(캘린더 engine-design §4.2가 신규 mint로 명시한 그릇·현 라이브 component·단가행 0행·단가 4000 일치) |

★ **search-before-mint 충족(단 라이브 미적재 명시·validator 재실측 2026-06-22)**: 우드거치대 4000 = 일반 캘린더 §4 COMP_CALOPT_STAND의 우드거치대 단가행(4000)과 **단가 일치·동일 add-on**. **이 comp는 라이브에 component 자체도 단가행도 0행**(캘린더 종단이 신규 mint로 명시한 미적재 그릇) → 디자인캘린더는 **"재사용"이 아니라 캘린더 종단 신규 mint에 선행 의존**(우드거치대 mint는 캘린더 종단 소관·디자인캘린더 독자 mint 금지). 디자인캘린더 시트 본체 신규 mint 0 카운트는 불변(우드거치대는 캘린더 종단 소관). LINEN_FINISH 그릇 동형(opt_cd·.01·×qty). G-DCAL-WOODSTAND(이중 mint 위험) 해소.

### 4.2 캘린더봉투 (탁상형·2500/2400) = 독립 PRD + 봉투제작 트랙 위임

| add-on | 출처(verbatim) | 추가가격 | 귀속 설계 |
|--------|----------------|---------|-----------|
| 캘린더봉투 240x230 10장 | row3(탁상130) `추가상품`/`추가가격` | **2,500** | 본체 addon — 독립 **PRD_000005(012-0008·캘린더봉투)** 동시 존재(라이브 실측) |
| 캘린더봉투 150x310 10장 | row6(탁상) `추가상품`/`추가가격` | **2,400** | 본체 addon(대형봉투) |
| 캘린더봉투 ★사이즈선택 220x145 | row2(탁상220) `추가상품` | (가격 미명시·부모행) | 본체 addon |
| 캘린더봉투 ★사이즈선택 130x220 | row5(탁상) `추가상품` | (가격 미명시) | 본체 addon |

★ **봉투제작 트랙 위임 (G-DCAL-ENVELOPE)**: 캘린더봉투는 **독립판매(PRD_000005)** + 본체 addon 이중역할(일반 캘린더 Q-CAL-ENVELOPE 연계·동일 봉투 PRD 두 시트 참조). 봉투를 디자인캘린더 본체 가격공식에 합산하면 오과금 → **봉투제작 트랙(독립 PRD 가격)에 위임**·디자인캘린더 가격공식 외부. set-product-design 디자인캘린더 절에 봉투 nuance 명기.

★ **봉투 사이즈별 변형가 가드 (benchmark G-DC-1)**: 봉투가 사이즈별 변형가(240x230=2500 vs 150x310=2400)이므로 봉투제작 트랙에서 봉투사이즈 차원(use_dims) 충전 필수(평탄화 시 봉투 무관 한 값 오청구). 디자인캘린더 본체 공식엔 미합산.

### 4.3 add-on prc_typ — ×제작수량 (개당 가산·컨펌큐 Q-DCAL-FIN)

우드거치대 4000 = .01 단가형 ×qty(개당 가산·COMP_CALOPT_STAND min_qty NULL ×qty 동형). 상품마스터에 "개당 vs 주문당" 명시 부족(굿즈 Q-GP-FIN1·캘린더 Q-CAL-FIN·악세사리 동일 미해소) → **개당 가산 가설**(물리 부속물 단위)이나 인간 컨펌. benchmark Q-DC-FIN 동일.

`확신도: 높음(우드거치대 단가 일치·봉투 독립 PRD 실측·search-before-mint)`

---

## 5. 상품↔공식 바인딩 설계 (product_price_formulas · 정찰가 채택 시·WIRE 폐쇄)

미바인딩 5상품(실측 0건)에 PRF_DCAL_* 바인딩(인간 컨펌 후). **신규 mint = 공식 5 + 정찰가 comp 1(COMP_DCAL_FIXED)뿐**(우드거치대 comp = 캘린더 종단 mint 선행 의존·디자인캘린더 시트 본체 신규 mint 0).

| prd_cd | 상품(라이브 prd_nm) | 바인딩 공식(편집기 주문) | inline 정찰가(verbatim) | 비고 |
|--------|---------------------|--------------------------|-------------------------|------|
| PRD_000108 | 탁상형캘린더 | **PRF_DCAL_DESK** | 220x145=10400 / 130x220=9700 | siz_cd 2행 정찰가(§6) |
| PRD_000109 | 미니탁상형캘린더 | **PRF_DCAL_DESKMINI** | 90x100=6500 / 148x60=6500 | 두 사이즈 동일가(정상·G-DCAL-MINI-FLAT) |
| PRD_000110 | 엽서캘린더 | **PRF_DCAL_POSTCARD** | 145x145=4000 | + 우드거치대 add-on(COMP_CALOPT_STAND·캘린더 종단 mint 선행 의존) |
| PRD_000111 | 벽걸이캘린더 | **PRF_DCAL_WALL** | 210x297=9900 | 트윈링 baked |
| PRD_000112 | 와이드벽걸이캘린더 | **PRF_DCAL_WALLWIDE** | 300x625=24000 | 3절·트윈링 baked |

★ **G-PRODPRICE 가드 (본체는 formula·product_prices 금지·돈크리티컬)**: product_prices 0행 실측 → 정찰가를 product_prices에 INSERT하면 FORMULA 통째 우회 silent(엔진 :315-330 PRODUCT_PRICE 선점·GP-2/캘린더 G-CAL-2/악세사리/포토북 선례). **디자인캘린더 본체 정찰가는 .01 단가형(min_qty=1) comp로 formula 바인딩만·product_prices INSERT 금지**(엽서캘린더 우드거치대 add-on 가산이 필요하므로 formula 합산 구조 필수). 정찰가형이라도 add-on 있으면 formula 유지 = benchmark G-DC-2·캘린더 §0-5 동형.

`확신도: 높음(바인딩 0건·product_prices 0행 실측·G-PRODPRICE 선례 계승)`

---

## 6. 단가행 그릇 (component_prices) — "정찰가 채택 시 신규 + 재사용"

| 작업 | 대상 | 내용 | 트랙 |
|------|------|------|------|
| **신규 comp + 단가행 INSERT**(컨펌 후) | COMP_DCAL_FIXED | siz_cd × inline 정찰가 verbatim: 220x145→10400·130x220→9700·90x100→6500·148x60→6500·145x145→4000·210x297→9900·300x625→24000 (7행·prc_typ .01 단가형·min_qty=1) | dbmap·인간 승인 후 |
| **캘린더 종단 mint 선행 의존**(현 라이브 0행) | COMP_CALOPT_STAND | 우드거치대 opt_cd 단가행(4000)·캘린더 종단 신규 mint 소관(디자인캘린더 독자 mint 금지) | 캘린더 종단·dbmap |
| **공식·배선·바인딩 INSERT**(컨펌 후) | PRF_DCAL_* 5 + formula_components 6(5 본체 + 1 우드거치대) + product_price_formulas 5 | WIRE 폐쇄·주문방법 분기 | dbmap |
| **봉투 add-on** | (디자인캘린더 본체 외부) | 캘린더봉투 PRD_000005 봉투제작 트랙 | 봉투 트랙 위임 |
| **product_prices** | (금지) | INSERT 금지(G-PRODPRICE 선점 가드) | — |

★ 단가값 = **전부 상품마스터 inline verbatim**(정찰가 7건·우드거치대 4000). 설계는 값을 만들지 않는다(비정수 역산 산식 단가 날조 0). siz_cd는 라이브 사이즈 코드로 매핑(인쇄/캘린더 설계 siz_cd 룩업 동형·SIZ_* 채번 불요·기존 사이즈 재사용).

`확신도: 높음(inline verbatim·단가행 grid 명세)`

---

## 7. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract) | 설계 준수 |
|----------------------|-----------|
| C7 frm_typ 미참조·공식=합산 | ✅ PRF_DCAL_*=addtn_yn='Y' comp Σ(정찰가 .01 min_qty=1 + add-on .01) |
| P4 단가형 ×qty(.01·라이브 .03 부재) | ✅ 본체 정찰가 = .01 단가형 **1부 정찰가 ×qty** siz_cd 룩업(굿즈 GP-1·악세사리 inline 동형·per-unit ×qty)·우드거치대 .01 ×qty·**G-DCAL-QTY**(qty-불변 금지·저청구) |
| P3-8 ERR_AMBIGUOUS 금지 | ✅ 상품별 전용 PRF + siz_cd 판별차원(동시매칭 회피)·우드거치대 opt_cd 판별 |
| P3-DEF 판별차원 없음 금지 | ✅ COMP_DCAL_FIXED use_dims=[siz_cd] 충전·COMP_CALOPT_STAND use_dims=[opt_cd] 충전(NULL 항상매칭 금지) |
| PRODUCT_PRICE 선점(G-PRODPRICE) | ✅ product_prices 0행 유지·formula 바인딩만(add-on 가산 보존·선점 silent 우회 차단) |
| U-7 시트 차원경계(SOT 1) | ✅ 디자인캘린더 공식=정찰가+우드거치대만(타 상품군 comp 침입 0·봉투=외부 트랙·시트경계 안) |
| 도수=print_opt_cd | N/A(정찰가에 baked·도수 차원 미노출·별 도수 comp 분할 금지) |
| 면적=siz_width/height | N/A(디자인캘린더=이산 siz_cd 정찰가 룩업·면적매트릭스 아님) |
| P4-1 단가형 ×qty(돈크리티컬·G-DCAL-QTY) | ✅ 본체 정찰가·우드거치대 둘 다 `unit_price × qty`(qty-불변 금지·저청구·codex D1)·min_qty=1은 티어 키지 ÷분모/qty-불변 아님 |
| 차원 자동매칭 | ✅ siz_cd selection → COMP_DCAL_FIXED 정확 1행(탁상 220 vs 130 분기) |
| search-before-mint | ✅ 신규 comp=COMP_DCAL_FIXED 1건(굿즈/악세사리 .01 min_qty=1 고정가 그릇 동형)·우드거치대=캘린더 종단 mint 선행 의존·신규 가격축 0·11연속 통과 |

★ **G-DCAL-DUAL 차원경계 가드**: 디자인캘린더 PRF_DCAL_*과 일반 캘린더 PRF_CAL_*이 동일 prd_cd를 동시 바인딩 시 ERR_AMBIGUOUS/silent 비결정. → **주문방법 판별차원 분기로 1 prd 1 공식 보장**(편집기→DCAL·업로드→CAL). 이것이 G-DCAL-DUAL 결판의 엔진 계약 표현(Q-DCAL-ROUTE 컨펌).

---

## 8. designer 큐 잔여 (design-decisions·골든으로 이관)

- **Q-DCAL-AUTHORITY**(최우선·인간): inline 정찰가 채택(권고·①) 비준 → PRF_DCAL_* 적재 vs 견적 비대상 BLOCKED 유지. 본 설계는 ① 채택 시 무손실 명세 제공.
- **Q-DCAL-ROUTE**(codex D2 보강): 정찰가 경로(DCAL) vs 산식(CAL) 라우팅 메커니즘. ★**엽서캘린더 PRD_000110=editor_yn=N 라우팅** — editor_yn 단독 의존 금지(엽서 누락 내부 모순)·라우팅 신호=가격포함 시트 등재+상품별 PRF_DCAL_* 바인딩(엽서 포함 5상품). selection 배선은 option_groups 의존(현 0행).
- **Q-DCAL-DSC**(codex D1 연계·돈크리티컬): 본체 정찰가 × qty가 base이며 수량구간할인(DSC) 별도 레이어 존재 여부 — 미확인 시 단순 ×qty(할인 0)·DSC 있으면 별 레이어. 견적가 = 정찰가×qty(±DSC).
- **Q-DCAL-FIN**: 우드거치대 4000 개당 가산(×qty) 가설 vs 주문당 정액(캘린더 Q-CAL-FIN·굿즈 Q-GP-FIN1 동일 미해소).
- **Q-DCAL-ENVELOPE**: 캘린더봉투 PRD_000005를 본체 addon으로 묶을지 독립판매만 둘지 — 봉투제작 트랙·일반 캘린더 Q-CAL-ENVELOPE 연계.
- **G-DCAL-QTY 정직 유지 [HARD·돈크리티컬]**: 본체 정찰가는 `.01 단가형 1부 정찰가 ×qty`(qty-불변 모델링 금지·저청구·codex D1).
- **inline BLOCKED 정직 유지 [HARD]**: ① 비준 전에는 추측 단가 INSERT 금지·정찰가는 권위(비정수 역산 산식 단가 날조 0).
