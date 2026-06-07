# 디지털인쇄 원자합산형 가격엔진 설계 (round-2 미설계분 완성)

> 작성 2026-06-07 · dbm-mapping-designer. 권위 입력: `00_schema/price-engine-ddl.md`·`price-engine-fk-refs.md`(스키마), `06_extract/calc-formula-draft-l1.csv`(공식), `06_extract/import-paper-l1.csv`(용지비), `08_remediation/digital-print.md`(36상품)·`output-paper-3way-reconciliation.md`(siz), 라이브 railway DB read-only(2026-06-07, SELECT 12회 전부 read-only·쓰기 0).
> 식별자·컬럼·코드값·SQL·상태토큰(GO/BLOCKED/ADEQUATE/GAP) 영어, 해석 한국어.
> **DB 직접 적재·DDL·COMMIT·siz채번·코드행등록 금지** — 본 산출은 **설계 + 적재용 CSV + 차단 정직표기**까지. 실제 적재는 인간 승인.

---

## 보정 이력 (dbm-validator CONDITIONAL-GO → 보정, 2026-06-07)

독립검증 게이트(`03_validation/digital-print-engine-gate.md`) 적발 실결함 보정 완료. D-1/D-2/D-4(1차) + D-5(재게이트). D-3는 schema 문서 소관이라 본 설계는 §1 의미 정정만:

| 결함 | 심각도 | 보정 | 결과 |
|------|:------:|------|------|
| **D-1** | MAJOR | DGP-A·D에 후가공비 14 component(오시3+미싱3+가변텍스트3+가변이미지3+모서리2, .04 라이브 실재) disp_seq 배선 추가 | 배선 44→**72** (+28) |
| **D-2** | MAJOR | 019 투명엽서·030 지그재그엽서를 LOADABLE 바인딩에서 BLOCKED로 이동(라이브 plate coverage 0 확증) | 바인딩 22→20 loadable + 2 blocked |
| **D-4** | MINOR | 용지비 note MAT_000150/151 평량 명기(뉴크라프트 250g·팬시크라프트 120g, 라이브 mat_nm 권위) | note 2행 보정 |
| D-3 | MINOR | (schema-analyst 소관) §1 fit-gap에서 COMP_CUT_FULL_DIECUT 의미를 `.04`→**`.06 완제품비`**로 정정. 배선 comp_cd 불변 | 문서 의미 정정만 |
| **D-5** | MAJOR | (재게이트) 와이드접지리플렛(049) LOADABLE 오분류 — 019/030과 동일 plate 결함부류. use_yn=Y(활성)이나 plate=SIZ_000186/188/190(작업사이즈·impos=N), 디지털인쇄비 커버 {SIZ_000077,SIZ_000499} 0/3 → BLOCKED 이동 | 바인딩 20→**19** loadable + **3** blocked |

plate 결함 BLOCKED 3상품 판정 근거(라이브 read-only 2026-06-07, 디지털인쇄비 커버 {SIZ_000077,SIZ_000499} 교차):
- **019 투명엽서**: plate=SIZ_000113/114/115/118(작업사이즈) → 0/4. 투명 315x467 siz채번+투명 인쇄비/별색/용지비 단가 대기.
- **030 지그재그엽서**: plate=SIZ_000142/143(604x154 작업사이즈, impos=N) → 0/2. "3절이라 SIZ_000077 커버" 가설 거짓 확인.
- **049 와이드접지리플렛**: plate=SIZ_000186/188/190(635x303 등 작업사이즈, impos=N) → 0/3. use_yn=Y인데도 plate가 국4절 교정 미적용분(작업사이즈 적재).
- 공통 근인: 출력용지규격이 작업사이즈로 잘못 적재된 plate 결함. 출력용지규격 plate 교정(`08_remediation/output-paper-3way-reconciliation.md` §5) 또는 해당 siz 인쇄비 단가 적재 후 LOADABLE 복귀.
- 대조 정상: 016 covered=1.

**[부수 기록 — 조치 불요] 썬캡(051)**: plate=SIZ_000195 커버 0/1이나 **use_yn=N(미출시)**이라 LOADABLE 잔존. 단 **출시 전 plate/인쇄비 정합 검증 필수**(019/030/049와 동일 plate 결함부류 — 활성화 시 가격조회 깸).

---

## 0. 무엇이 미설계였나 (라이브 확정)

후니 가격엔진(t_prc_* 6테이블 4단)에서 **디지털인쇄 원자합산형 공식이 통째로 미설계**였다. 라이브 read-only 확정:

| 검증 항목 | 라이브 결과 | 의미 |
|-----------|-------------|------|
| `t_prc_price_formulas` PRF_DGP* | **0** | 원자합산형 공식 부재 |
| `t_prc_formula_components` 디지털 component 배선 | **0** | COMP_PRINT_DIGITAL/SPOT/COAT 전부 **고아단가**(formula 미연결) |
| 디지털 단가 적재 상태 | COMP_PRINT_DIGITAL_S1/S2=212행씩·SPOT_*=53행씩·COAT_*=92행씩 | 단가는 적재됨, 공식만 없음 |
| `t_prc_price_components` `%PAPER%` | **0** (COMP_POSTER_ARTPAPER는 완제품가) | **용지비 component 부재** |
| 디지털 36상품 공식 바인딩 | 7만 바인딩(024/025 포토카드·031/032/033 명함·048 접지리플렛·050 봉투) | 엽서·상품권·배경지·소량전단지·접지카드 대부분 미바인딩 |

→ **디지털인쇄 ~22 원자합산형 상품 가격조회 사슬 끊김.** 본 트랙이 그 사슬을 잇는다: `formula → formula_components → product_price_formulas` + **용지비 COMP_PAPER 신설**.

---

## 1. Fit-Gap Verdict — FRM_TYPE.01로 6공식 다 흡수되는가?

### Verdict: **ADEQUATE** (신규 엔티티 불요 — 기존 6테이블 구조로 6공식 전부 표현 가능)

| 공식 요소 | 스키마 표현 | Verdict |
|-----------|-------------|---------|
| `판매가 = Σ components` | `t_prc_formula_components` (addtn_yn='Y' 합산, FRM_TYPE.01) | **ADEQUATE** (구조 자체) |
| 인쇄비(4도)·별색인쇄비 | 기존 `COMP_PRINT_DIGITAL_S1/S2`·`COMP_PRINT_SPOT_*` (PRC_COMPONENT_TYPE.01) | **ADEQUATE** (재사용) |
| 코팅비 | 기존 `COMP_COAT_GLOSSY/MATTE` (.02) | **ADEQUATE** (재사용) |
| **용지비** | **COMP_PAPER 신규** (.03 용지비) + mat_cd×siz_cd 차원 | **ADEQUATE-WITH-MINT** (단일 component + 차원, 과분할 없음) |
| 접지비·타공비·후가공비(오시/미싱/가변/모서리) | 기존 `COMP_FOLD_*`·`COMP_CUT_PERF_1H6`·`COMP_PP_*` (.04 후가공비) | **ADEQUATE** (재사용) |
| 커팅비(완칼 die-cut) | 기존 `COMP_CUT_FULL_DIECUT` (**.06 완제품비** — 커팅 합가, 라이브 확증. D-3 정정: 이전 ".04"는 오기) | **ADEQUATE** (재사용) |
| 박(대형) | foil 트랙 `COMP_FOIL_LARGE_*`(.05 박형압비) — disp_seq 슬롯만 예약 | **BLOCKED** (foil 트랙 CONDITIONAL-GO 의존) |
| 곱셈계수(×출력매수·÷판걸이수·+손지율) | **앱 런타임**(DB 미저장) | **ADEQUATE** (C-4: addtn_yn=합산플래그뿐) |
| 도수(4도/흑백) | 기존 `clr_cd` 차원(라이브 COMP_PRINT_DIGITAL_S1에 CLR_000002/000005 사용 확인) | **ADEQUATE** |

**결론: 신규 엔티티(테이블/FRM_TYPE.03 등) 필요 없음.** 6공식 모두 FRM_TYPE.01 합산형 + 기존 component 재사용 + COMP_PAPER 1종 신규로 흡수된다. "면적매트릭스형 FRM_TYPE 부재(G-3)"는 디지털인쇄와 무관(디지털은 합산형). 별색=공정(G-1)은 이미 COMP_PRINT_SPOT_*(clr_cd=NULL)로 적재됨 — 본 설계는 그것을 공식에 배선만 한다.

---

## 2. 6공식 분류표 (PRF_DGP_A~F · FRM_TYPE.01 합산형)

| frm_cd | 대상 상품군 | 공식(calc-formula 행) | 구성요소 | use_yn |
|--------|-------------|----------------------|----------|:------:|
| **PRF_DGP_A** | 엽서(8)·상품권(2)·종이슬로건 | 인쇄비+코팅비+용지비+**후가공비**+추가상품 (r4). 별색 r7·박(대형) r11 | 인쇄(단/양면)+별색(5종×면)+코팅(2)+용지+**후가공비(오시/미싱/가변/모서리 14)**+박슬롯 | Y |
| **PRF_DGP_B** | 모양엽서·라벨택 | 인쇄비+용지비+커팅비 (r15) | 인쇄(단/양면)+용지+완칼(die-cut) | Y |
| **PRF_DGP_C** | 인쇄배경지·헤더택 | 인쇄비+용지비+접지비+타공비+추가상품 (r19) | 인쇄(단/양면)+용지+접지+타공 | Y |
| **PRF_DGP_D** | 소량전단지 | 인쇄비+코팅비+용지비+**후가공비** (r25) | 인쇄(단/양면)+코팅(2)+용지+타공+**후가공비(오시/미싱/가변/모서리 14)** | Y |
| **PRF_DGP_E** | 접지카드(4)·접지리플렛(와이드) | 인쇄비+코팅비+용지비+접지비+후가공비+박(대형)+추가상품 (r29, 국4절/3절기준) | 인쇄+코팅(2)+용지+접지(4)+타공+박슬롯 | Y |
| **PRF_DGP_F** | 썬캡 | 용지비+인쇄비+커팅비 (r49) | 용지+인쇄(단/양면)+완칼 | **N** (미출시) |

산출: `t_prc_price_formulas_DGP.csv` (6행, frm_typ_cd=FRM_TYPE.01).

---

## 3. Component 배선표 (`t_prc_formula_components_DGP.csv` — 72행 loadable · D-1 보정후)

각 공식에 필요 component를 disp_seq 순으로 배선. **addtn_yn='Y'**(합산 플래그뿐, 곱셈 아님 — C-4). **신규 mint는 COMP_PAPER 1종**뿐, 나머지 component(35종)는 **라이브 재사용**(round-2 적재됨, FK 부모 선존재 라이브 확인 — 후가공비 14종 포함 전건).

| frm_cd | 배선 component (요약) | 행수 |
|--------|----------------------|:----:|
| PRF_DGP_A | DIGITAL_S1/S2 + SPOT 5종×2면(10) + COAT_GLOSSY/MATTE + COMP_PAPER + **후가공비 14(오시3+미싱3+가변텍스트3+가변이미지3+모서리2)** + (박슬롯=blocked) | 29(loadable 29) |
| PRF_DGP_B | DIGITAL_S1/S2 + COMP_PAPER + CUT_FULL_DIECUT | 4 |
| PRF_DGP_C | DIGITAL_S1/S2 + COMP_PAPER + FOLD_CARD_2H + CUT_PERF_1H6 | 5 |
| PRF_DGP_D | DIGITAL_S1/S2 + COAT_GLOSSY/MATTE + COMP_PAPER + CUT_PERF_1H6(타공) + **후가공비 14** | 20 |
| PRF_DGP_E | DIGITAL_S1/S2 + COAT_GLOSSY/MATTE + COMP_PAPER + FOLD_LEAF 4종 + CUT_PERF_1H6 + (박슬롯=blocked) | 10(loadable 10) |
| PRF_DGP_F | COMP_PAPER + DIGITAL_S1/S2 + CUT_FULL_DIECUT | 4 |

**[D-1 보정 — MAJOR 해소]** calc-formula r4(엽서·상품권)·r25(소량전단지)의 권위 가산항 **후가공비**가 DGP-A·D에 미배선이던 결함을 보정. 후가공비 후보 14 component(`COMP_PP_CREASE_1L/2L/3L`·`COMP_PP_PERF_1L/2L/3L`·`COMP_PP_VARTEXT_1EA/2EA/3EA`·`COMP_PP_VARIMG_1EA/2EA/3EA`·`COMP_PP_CORNER_RIGHT/ROUND`, 전부 PRC_COMPONENT_TYPE.04, 라이브 단가 실재 14/14 확인)를 disp_seq 슬롯으로 배선. 추가 적재 불요(FK 안전). 컨펌① "옵션 후보 전부 배선" 정책을 후가공비에 일관 적용. 라이브 후가공 공정 근거: 016=직각/둥근/오시/미싱/가변텍스트/가변이미지·041=오시/미싱/가변텍스트/가변이미지·047=가변텍스트/가변이미지.

**박(대형) 슬롯 정직표기:** PRF_DGP_A·E에 박 component 슬롯을 disp_seq로 예약하되, 그 단가/배선은 **차단**(§6.3). 슬롯 배선 6행은 `t_prc_formula_components_DGP_BLOCKED_foil.csv`에 분리 — foil 트랙(`02_mapping/price-foil-matrix-mapping.md`, CONDITIONAL-GO·BLOCKER-1 미해소)이 `COMP_FOIL_LARGE_GENERAL/SPECIAL`·`COMP_FOIL_DIE_LARGE`(.05 박형압비)를 적재한 뒤 배선해야 함. 라이브에 해당 component 미존재 확인 → loadable 배선에서 제외(FK 위반 방지).

**[설계 결정 — 컨펌 필요 ①]** disp_seq 단/양면 인쇄(S1/S2)·별색 5종·코팅 2종·후가공비 14종은 **선택지 후보 전부**를 배선했다. 런타임에 주문 옵션(print_side·별색공정·코팅타입·오시/미싱/가변/모서리)에 따라 해당 component만 활성화되어 합산된다(addtn_yn은 "이 component가 합산 후보"라는 의미). 만약 후니가 "옵션 미선택 component는 배선하지 않는다"는 정책이면 상품별 배선으로 좁혀야 함. 현 설계는 **공식 단위 배선**(상품 무관 재사용)이 후니 엔진 구조(formula_components는 frm_cd 키)에 정합.

---

## 4. 상품↔공식 바인딩표 (`t_prd_product_price_formulas_DGP.csv` — 19행 loadable · D-2/D-5 보정후)

원자합산형 LOADABLE 19상품 바인딩 + BLOCKED 3상품(019/030/049, plate 결함·siz 미정합). **고정가형 제외**: 명함 031~040(PRF_NAMECARD_FIXED)·포토카드 024/025(PRF_PHOTOCARD_FIXED)·봉투 050(PRF_ENV_MAKING)·엽서북/떡메. 라이브 prd_cd 선존재 확인 22/22.

| frm_cd | 바인딩 상품 (prd_cd) — LOADABLE | 수 |
|--------|---------------------|:--:|
| PRF_DGP_A | 016 프리미엄·017 코팅·018 스탠다드·020 화이트인쇄·021 핑크별색(N)·022 금은별색(N)·026 종이슬로건·041 스탠다드상품권·042 프리미엄상품권 | 9 |
| PRF_DGP_B | 023 모양엽서(N)·046 라벨/택 | 2 |
| PRF_DGP_C | 043 인쇄배경지(OPP)·044 인쇄배경지(투명케이스)·045 인쇄헤더택 | 3 |
| PRF_DGP_D | 047 소량전단지 | 1 |
| PRF_DGP_E | 027 2단접지카드·028 미니접지카드(N)·029 3단접지카드 | 3 |
| PRF_DGP_F | 051 썬캡(N) | 1 |
| **LOADABLE 소계** | | **19** |

**[D-2/D-5 보정 — MAJOR 해소] 019/030/049 BLOCKED 이동** (`t_prd_product_price_formulas_DGP_BLOCKED_siz.csv` 3행):

| prd_cd | frm_cd | use_yn | 차단 사유 (라이브 확증 2026-06-07) |
|--------|--------|:------:|-----------------------------------|
| 019 투명엽서 | PRF_DGP_A | Y | plate=SIZ_000113/114/115/118(작업사이즈), 디지털인쇄비 커버 {SIZ_000077,SIZ_000499} **0/4** → 인쇄비·별색·용지비 lookup 전부 깸. 투명 315x467 siz채번 + 투명 인쇄비/별색/용지비 단가 적재 대기 |
| 030 지그재그엽서 | PRF_DGP_E | Y | plate=SIZ_000142/143(604x154·154x604 작업사이즈, impos=N, OUTPUT_PAPER_TYPE.03), 3절 인쇄비 SIZ_000077 커버 **0/2** → 가격조회 깸. "3절이라 커버" 가설 거짓 확인. 3절 plate 교정 또는 3절 인쇄비 siz 정합 대기 |
| 049 와이드접지리플렛 | PRF_DGP_E | Y | **[D-5]** plate=SIZ_000186/188/190(635x303 등 작업사이즈, impos=N), 디지털인쇄비 커버 **0/3** → 가격조회 깸. 049 출력용지규격 plate 교정 또는 해당 siz 인쇄비 단가 적재 후 LOADABLE 복귀 |

대조 정상: 016 등 9개 DGP-A 잔여상품은 plate가 SIZ_000499 커버 1/1 확인(예: 016 covered=1). **LOADABLE 바인딩 22 → 20(D-2) → 19(D-5)**(019·030·049 모두 라이브 검증으로 BLOCKED 확정). 공통 근인 = 출력용지규격이 작업사이즈로 잘못 적재된 plate 결함(출력용지규격 plate 교정 후 일괄 복귀 가능).

**use_yn=N 상품(LOADABLE 중 4)**: 021·022·023·028·051. 바인딩은 하되 공식 use_yn 또는 상품 use_yn으로 미노출 처리. (038 형압명함은 고정가형이라 본 트랙 범위 밖.)

**[설계 결정 — 컨펌 필요 ②] 048 접지리플렛 재바인딩**: 라이브에서 048은 이미 `PRF_FOLD_SUM`(접지비만 있는 불완전 공식)에 바인딩됨. 올바른 공식은 PRF_DGP_E(인쇄+코팅+용지+접지+후가공+박). PK=(prd_cd,frm_cd)라 단순 INSERT로는 안 되고 **기존 (PRD_000048, PRF_FOLD_SUM) DELETE 후 (PRD_000048, PRF_DGP_E) INSERT**가 필요. 본 CSV는 충돌 회피를 위해 048을 **제외**했고, 재바인딩은 인간 승인 마이그레이션으로 분리. (049 와이드접지리플렛은 미바인딩이라 충돌 없이 DGP-E 직바인딩.)

---

## 5. 용지비 COMP_PAPER 차원모델 + 종이↔mat_cd 매핑

### 5.1 단일 component + 차원 (과분할 금지)

용지비는 **종이별 분리 component(120종)가 아니라** 단일 `COMP_PAPER`(comp_typ_cd=PRC_COMPONENT_TYPE.03)에 **차원으로** 단가를 저장한다(스킬 권장·과분할 회피).

| component_prices 차원 | COMP_PAPER 용지비 의미 | 값 |
|------------------------|------------------------|-----|
| `mat_cd` | 종이(자재) | 종이별 live mat_cd |
| `siz_cd` | 출력용지규격 | 국4절=SIZ_000499 / 3절=미채번 / 투명=미채번 |
| `unit_price` | 종이별 절가 | import-paper 가격(국4절)/가격(3절) verbatim |
| `clr_cd`·`coat_side_cnt`·`bdl_qty`·`min_qty` | **NULL** | 용지비는 도수/코팅/묶음/수량 무관 — 손지율(+5장)·출력매수곱은 앱 |

### 5.2 종이↔mat_cd 매핑 (라이브 대조 — 58종 전건 매치)

import-paper의 **디지털인쇄용지 58종**(출력용지규격 316x467/330x660/315x467 + 절가 보유)을 live `t_mat_materials`와 대조:

| 출력용지규격 | siz_cd | 종이수 | mat_cd 매치 | 적재 상태 |
|--------------|--------|:-----:|:-----------:|-----------|
| 316x467 (국4절) | **SIZ_000499** (live OK) | 49 | **49/49** | **LOADABLE NOW** (`t_prc_component_prices_PAPER.csv` 49행) |
| 330x660 (3절) | 미채번 | 5 | 5/5 | **BLOCKED** (siz 채번 대기) |
| 315x467 (투명) | 미채번 | 4 | 4/4 | **BLOCKED** (siz 채번 대기) |

- **mat_cd 매치 58/58** (이름 정확매치 56 + prefix 매치 2: 뉴크라프트→MAT_000150, 팬시크라프트→MAT_000151). **종이 mat_cd 미등록 차단 = 0건** (당초 우려한 종이코드행 선적재 차단은 디지털인쇄용지엔 없음 — 전부 live 보유).
- 산출: `t_prc_component_prices_PAPER.csv`(국4절 49행 loadable) + `t_prc_component_prices_PAPER_BLOCKED_siz.csv`(3절5+투명4=9행, siz placeholder `<SIZ_3JEOL_330x660>`/`<SIZ_TRANSPARENT_315x467>`).

---

## 6. 차단/GAP 정직표기 (HARD — "처리완료" 포장 금지)

### 6.1 종이 mat_cd 미등록 → **차단 0건** (당초 우려 해소)
import-paper 디지털인쇄용지 58종 전부 live `t_mat_materials`에 선존재. 종이 코드행 선적재 차단 **없음**. (비디지털 계열 종이[현수막천·아크릴·PVC 등]는 본 트랙 범위 밖.)

### 6.2 3절/투명 siz 미채번 → **용지비 9행 + 상품 바인딩 2행 차단** (siz 채번 인간 승인)
- 3절 330x660 (지그재그엽서 등 5종이) + 투명 315x467 (투명엽서·투명포토카드·투명명함 4종이) siz 라이브 부재(SIZ_000077=300x625는 다른 규격).
- 용지비 영향: **국4절(SIZ_000499) 분 49행 먼저 적재 가능**. 3절/투명 용지비 9행은 siz 신규 채번(인간 승인) 후 placeholder→실 siz_cd 치환하면 즉시 적재 가능(mat_cd·가격 다 확보됨).
- **[D-2/D-5 보정] 상품 바인딩 영향(라이브 확정)**: 019 투명엽서·030 지그재그엽서·**049 와이드접지리플렛**(D-5) 3상품 plate가 디지털 인쇄비 커버 {SIZ_000077,SIZ_000499}에 **0** 교차(019: 0/4, 030: 0/2, 049: 0/3 — 라이브 SELECT 2026-06-07) → 가격조회 깸. 3상품 바인딩을 `t_prd_product_price_formulas_DGP_BLOCKED_siz.csv`(**3행**)로 분리. 공통 근인 = 출력용지규격이 작업사이즈로 잘못 적재된 plate 결함. 출력용지규격 plate 교정(`output-paper-3way-reconciliation.md` §5) + siz 채번/인쇄비 단가 적재 후 일괄 LOADABLE 전환.

### 6.3 박(대형) 단가 → **6 슬롯 차단** (foil 트랙 위임)
- DGP-A·E 공식에 박 component disp_seq **슬롯만** 예약(`t_prc_formula_components_DGP_BLOCKED_foil.csv` 6행). 단가·component(`COMP_FOIL_LARGE_*`·.05 박형압비)는 foil 트랙(`price-foil-matrix-mapping.md`, CONDITIONAL-GO·BLOCKER-1[재사용 siz 혼합축·SIZ_000047 삼중바인딩] 미해소) 소관.
- 박 미해소여도 DGP-A·E의 **인쇄+코팅+용지+접지 분은 정상 가격조회**(박은 옵션 add-on이라 미선택 시 합산 제외).

---

## 7. 적재 순서 (FK 위상정렬)

```
[단계 0] FK 부모 (선존재 검증 완료 · 적재 대상 아님)
   t_cod_base_codes(FRM_TYPE.01·PRC_COMPONENT_TYPE.03 OK), t_siz_sizes(SIZ_000499 OK),
   t_mat_materials(49 OK), t_prd_products(22 OK), 기존 21 component OK
[단계 1] 엔진 부모 헤더 (병렬)
   t_prc_price_formulas_DGP.csv           (6 PRF_DGP_*, FRM_TYPE.01)
   t_prc_price_components_PAPER.csv        (COMP_PAPER 1행, .03)
[단계 2] 엔진 자식 (단계1 후, 병렬)
   t_prc_formula_components_DGP.csv        (72 배선 — frm_cd·comp_cd 선존재. D-1 후가공비 +28)
   t_prc_component_prices_PAPER.csv        (49 용지비 — comp_cd=COMP_PAPER·mat_cd·SIZ_000499 선존재)
[단계 3] 상품 바인딩
   t_prd_product_price_formulas_DGP.csv    (19 — prd_cd·frm_cd 선존재. D-2 019/030·D-5 049 제외)
[차단 — 인간 승인 후]
   t_prc_component_prices_PAPER_BLOCKED_siz.csv      (9 — 3절/투명 siz 채번 대기)
   t_prd_product_price_formulas_DGP_BLOCKED_siz.csv  (3 — 019/030/049 plate 결함·siz 미정합 대기)
   t_prc_formula_components_DGP_BLOCKED_foil.csv     (6 — foil 트랙 component 대기)
   048 접지리플렛 재바인딩 (DELETE PRF_FOLD_SUM + INSERT PRF_DGP_E)
```

FK 근거: formula_components.frm_cd RESTRICT→price_formulas, .comp_cd RESTRICT→price_components; component_prices.comp_cd CASCADE→price_components, siz/mat_cd→부모; product_price_formulas.prd_cd·frm_cd RESTRICT→부모.

---

## 8. 제약 준수 (적재 게이트 self-check — PASS)

| 제약 | 준수 |
|------|------|
| C-1 apply_ymd `yyyy-MM-dd` NOT NULL | 전건 `2026-06-01` (라이브 기존 디지털 단가와 정합 확인) |
| C-2 자연키 UNIQUE 8 (component_prices) | 49행 unique 49 — 중복 0 (PASS) |
| C-5 FRM_TYPE 2종 | 6공식 전부 FRM_TYPE.01 (PASS) |
| C-6 PRC_COMPONENT_TYPE | COMP_PAPER=.03 용지비 (PASS) |
| C-7 clr 5종 | 용지비 clr_cd=NULL (별색은 COMP_PRINT_SPOT comp, clr 매핑 안 함 — G-1 준수) |
| C-8 use_yn CHECK Y/N | 공식 use_yn Y(5)/N(1), component use_yn Y (PASS) |
| C-9 NULL=비차원 | 용지비 clr/coat/bdl/min = 빈문자열(로더가 NULL 매핑) — 빈값='' 아닌 NULL 변환 규칙 명문화 |
| PK uniqueness | formula_components 72 unique, product_price_formulas **19** unique, formulas 6 unique (PASS) |
| FK 선존재 (라이브) | 35 재사용 comp(후가공비 14 포함) + **19** prd + 49 mat + SIZ_000499 + 2 cod = 전건 확인 (PASS) |

**CSV 공란 = NULL 규칙**: 모든 적재 CSV에서 빈 문자열 칸은 로더가 NULL로 매핑(빈문자열 직삽 시 siz/clr/mat FK 위반 — C-9). 용지비 행의 clr_cd/coat_side_cnt/bdl_qty/min_qty 빈칸 = NULL.

---

## 9. 검산 (recompute sanity)

PRF_DGP_A 프리미엄엽서(016) 예시 (앱 런타임 합산):
```
판매가 = 인쇄비(COMP_PRINT_DIGITAL_S2[clr=CMYK,min_qty≤출력매수] × 출력매수)
       + 코팅비(COMP_COAT_GLOSSY × 출력매수)        ← 코팅 선택 시
       + 용지비(COMP_PAPER[mat=종이,siz=SIZ_000499] × (출력매수+5))  ← 손지율 앱
       + 후가공비(COMP_CUT_PERF_1H6[min_qty≤제작수량])  ← 후가공 선택 시
       + 별색(COMP_PRINT_SPOT_WHITE_S1)               ← 화이트별색 선택 시
       + 박(COMP_FOIL_LARGE_*)                         ← BLOCKED(foil)
```
출력매수=주문수량/판걸이수(앱), 손지율 +5장(앱), 판걸이수=임포지션(앱·DB 미저장). DB는 [수량행단가] lookup만 — 아키텍처 규칙 정합.

---

## 10. 산출 행수 요약

| 파일 | 행수 | 상태 |
|------|:----:|------|
| t_prc_price_formulas_DGP.csv | 6 | LOADABLE |
| t_prc_price_components_PAPER.csv | 1 (COMP_PAPER) | LOADABLE (신규 mint) |
| t_prc_formula_components_DGP.csv | **72** | LOADABLE (D-1 후가공비 +28) |
| t_prc_component_prices_PAPER.csv | 49 (국4절) | LOADABLE |
| t_prd_product_price_formulas_DGP.csv | **19** | LOADABLE (019/030/049 BLOCKED 이동·048 재바인딩 분리) |
| **소계 LOADABLE** | **147** | **국4절 즉시 적재가능** |
| t_prc_component_prices_PAPER_BLOCKED_siz.csv | 9 (3절5+투명4) | BLOCKED (siz 채번) |
| t_prd_product_price_formulas_DGP_BLOCKED_siz.csv | 3 (019·030·049) | BLOCKED (plate 결함·siz 미정합) |
| t_prc_formula_components_DGP_BLOCKED_foil.csv | 6 | BLOCKED (foil 트랙) |
| 048 재바인딩 (DELETE+INSERT) | 1 | 인간 승인 마이그레이션 |
| **소계 BLOCKED** | **19** | |

각 loadable 파일에 `.provenance.csv` 동반(per-row 출처: calc-formula 행·엑셀 셀·라이브 확인).

---

## 11. 설계 결정 — 인간 컨펌 필요 (HARD)

1. **[컨펌 ①] component 배선 단위** — 공식 단위로 옵션 후보 component 전부 배선(런타임 옵션 활성화). 상품별 배선 정책이면 좁혀야.
2. **[컨펌 ②] 048 접지리플렛 재바인딩** — 기존 PRF_FOLD_SUM(불완전) → PRF_DGP_E. DELETE+INSERT 마이그레이션.
3. **[컨펌 ③] 3절/투명 siz 채번** — 330x660·315x467 신규 siz 채번 후 BLOCKED 9행 적재.
4. **[컨펌 ④] 박(대형) foil 트랙** — BLOCKER-1 해소 후 DGP-A·E 박슬롯 배선 6행 적재.
5. **[컨펌 ⑤] use_yn=N 상품(021/022/023/028/051)** 바인딩을 지금 적재할지, 출시 시점까지 보류할지.
