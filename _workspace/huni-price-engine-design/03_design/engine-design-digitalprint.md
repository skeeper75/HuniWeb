# engine-design-digitalprint.md — 디지털인쇄 가격엔진 설계 (완제품)

> **핵심 설계가(hpe-engine-designer) 산출 1/4.** cartographer 지도(01_formula)+benchmark 흡수(02_benchmark)를
> 종합해, 디지털인쇄 완제품의 **가격공식 + 가격구성요소 + t_prc_* 단가행 그릇 + 상품↔공식 바인딩**을
> 라이브 `evaluate_price`가 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — t_prc_* 데이터 그릇 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) > ② 인쇄상품 가격표(260527) > ③ 라이브 t_prc_*(기준선) > ④ 역공학(후보).
> 공식 정본 = `calc-formula-draft-l1.csv`(상품마스터 `가격공식` 칸 희소·truncated 시 calc-draft 우선·G-6 컨펌큐).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-20 · 단가값=가격표 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임).

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 바꾸나

라이브 실측(2026-06-20)으로 cartographer 지도가 **부분 stale**임이 드러났다. 핵심 정정 3건이 설계 방향을 바꾼다:

| 정정 | cartographer 지도 | 라이브 실측(2026-06-20) | 설계 함의 |
|------|------------------|------------------------|-----------|
| **명함 variant comp** | "단가행 결손(NAMECARD 2행)" | **25 variant comp 전부 실재·단가행 충전**(STD/COAT/PEARL/WHITE/PREMIUM/SHAPE/MINISHAPE/CLEAR/FOIL) | G-3는 결손 아님. **진짜 갭=공식 미배선(orphan comp)**·G-4 |
| **오리지널박명함(박)** | "FOIL comp 실재하나 미배선" | **COMP_NAMECARD_FOIL_*(STD/HOLO × S1/S2) 9행씩 + SETUP(동판) 실재** | G-1/G-2 박 = comp 부재 아님. **공식 신설+배선**만 필요 |
| **엽서북** | "세트조합 미모델 GAP" | **PRF_PCB_FIXED(COMP_PCB_S1/S2_20P) 본체 바인딩 실재** | G-5 재정의 — 본체 엽서북은 고정가형 실재. 내지/표지 분리 SKU는 미바인딩(세트 모델 §set-product) |

**∴ 디지털인쇄 설계의 핵심은 "신규 comp mint"가 아니라 "이미 충전된 orphan comp를 올바른 공식에 바인딩"이다.** search-before-mint 강하게 충족 — 명함·포토카드·엽서북 comp는 전부 실재(단가행 verbatim). 신규 mint는 **대형박 1건뿐**(G-1, comp 실재 점검 후).

---

## 1. 계산방식 2종 (calc-formula-draft 권위)

| 계산방식 | 정의 | 디지털인쇄 상품군 | 엔진 처리(engine-contract) |
|----------|------|------------------|---------------------------|
| **원자합산형** | 판매가 = Σ(구성요소 subtotal) | 엽서류·상품권·슬로건·모양엽서·라벨택·배경지·헤더택·소량전단·접지카드·접지리플렛 | 공식=구성요소 합산(C7·P2-1). 단가형 comp는 unit×qty, 합가형은 ÷min_qty×qty(P4) |
| **고정가형** | 판매가 = [수량][소재/면] 룩업단가(용지포함)(+후가공) | 명함류(8종)·오리지널박명함·포토카드 | **엔진 동일** — frm_typ 미참조(C7). 단지 "완제품 통합단가 comp 1개"만 매칭되는 합산형의 특수형 |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·라이브 컬럼 부재 확인). "고정가형"은 별 엔진 분기가 아니라 **단가형 comp 1개(용지·인쇄·코팅 통합단가)만 배선된 합산형**이다. 설계는 두 방식을 똑같이 `formula_components` 배선으로 표현한다.

---

## 2. 원자합산형 공식 설계 (라이브 baseline 유지 + 갭 폐쇄)

원자합산 6공식(PRF_DGP_A~F)은 **라이브 배선·단가행이 calc-draft와 일치**(실측). 설계는 baseline을 **유지**하고 갭(박·미바인딩)만 닫는다.

### 2-A. PRF_DGP_A — 엽서류·상품권·슬로건 (유지 + G-1 대형박 배선)

| disp_seq | comp_cd | 의미축 | prc_typ | use_dims | 단가행 | addtn_yn | 상태 |
|----------|---------|--------|---------|----------|--------|----------|------|
| 0 | COMP_PRINT_DIGITAL_S1 | 인쇄(도수) | 단가형 | plt_siz_cd·print_opt_cd·proc_cd·min_qty·proc_grp:001 | 212 | Y | 유지 |
| 1 | COMP_PRINT_SPOT_WHITE_S1 | 별색(색×면) | 단가형 | plt_siz_cd·proc_cd·print_opt_cd·min_qty·proc_grp:007 | 530 | Y | 유지(정본·형제 del_yn=Y) |
| 2 | COMP_PAPER | 용지 | 단가형 | siz_cd·mat_cd | 56 | Y | 유지 |
| 3 | COMP_PP_CORNER_RIGHT | 후가공(귀돌이) | 단가형 | proc_cd·min_qty·proc_grp:026 | — | — | 유지 |
| 4 | COMP_PP_CREASE_1L | 후가공(오시) | 단가형 | proc_cd·min_qty·proc_grp:029 | — | Y | 유지(2L/3L 미배선=정상 R-2) |
| 5 | COMP_PP_PERF_1L | 후가공(미싱) | 단가형 | proc_cd·min_qty·proc_grp:030 | — | Y | 유지 |
| 6 | COMP_PP_VARTEXT_1EA | 후가공(가변텍스트) | 단가형 | proc_cd·min_qty·dim_vals·proc_grp:085 | — | Y | 유지(dim_vals 정확매칭 P3-3) |
| 7 | COMP_PP_VARIMG_1EA | 후가공(가변이미지) | 단가형 | proc_cd·min_qty·dim_vals·proc_grp:085 | — | Y | 유지 |
| 8 | COMP_COAT_GLOSSY | 코팅(유광) | 단가형 | siz_cd·coat_side_cnt·min_qty | (D/E공용) | — | 유지(★유광 단가행 결손 V-4·dbmap import 큐) |
| 9 | COMP_COAT_MATTE | 코팅(무광) | 단가형 | siz_cd·coat_side_cnt·min_qty | 92 | — | 유지 |
| **신** | **COMP_FOIL_LARGE**(신설 후보) | **후가공박(대형)** | **합가형** | **siz_cd(면적군)·proc_cd·min_qty** | — | **Y** | **G-1 신설(search-before-mint §3)** |

- **인쇄비 = [수량행단가] × 출력매수**(calc-draft). 출력매수 = 주문수량 / 판걸이수 = **앱 계산**(DB 미저장·[[dbmap-compute-in-app-db-stores-lookup]]). 단가행은 [수량행][출력판형]×도수로 충전.
- **별색 = 단일 comp + 색(proc_cd)×면(print_opt_cd) 차원**(component-inventory §2 [HARD]). 색·면을 별 comp로 분할 금지(형제 del_yn=Y 정합).
- **G-1 대형박**: calc-draft `(7)후가공박(대형)=[면적별동판비]+[면적별A~E군][군별·칼라별 수량행 합가]`. 면적→등급은 앱 계산(DB는 등급별 단가만). 신설 전 §3 search-before-mint 필수.

### 2-B~F. PRF_DGP_B/C/D/E/F (전부 유지)

| 공식 | 상품군 | 배선 comp(라이브 실측) | 갭 |
|------|--------|----------------------|-----|
| PRF_DGP_B (3) | 모양엽서·라벨택 | 인쇄·용지·완칼(COMP_CUT_FULL_DIECUT) | 없음 |
| PRF_DGP_C (4) | 배경지·헤더택 | 인쇄·용지·접지(FOLD_CARD_2H)·타공(CUT_PERF_1H6) | 없음 |
| PRF_DGP_D (10) | 소량전단지 | 인쇄·코팅·용지·후가공 다수 | 없음(코팅 180g 제약=CPQ §design-decisions) |
| PRF_DGP_E (9) | 접지카드(2단/미니/3단) | 인쇄·코팅·용지·접지·타공 | **G-1 대형박 배선**(A와 동일 COMP_FOIL_LARGE) |
| PRF_DGP_F (3) | 썬캡(미출시) | 인쇄·용지·완칼 | 없음(MES 미등록·보류) |

---

## 3. 고정가형 공식 설계 — 명함 ★ (핵심 재설계: orphan comp 바인딩 + 인쇄면 silent 이중합산 해소 + prc_typ ×qty 결함 R-1)

### 3.0 라이브 실측 결함 2건 (PRF_NAMECARD_FIXED 실재 결함)

라이브 PRF_NAMECARD_FIXED는 **STD_S1·STD_S2 2 comp만** 배선됐고 상품 3개(스탠다드·코팅·프리미엄명함)가 바인딩돼 있다. 두 결함:

| 결함 | 근거(실측) | 영향 |
|------|-----------|------|
| **D-A misfire** | 코팅명함(PRD_000032)·프리미엄명함(PRD_000031)이 PRF_NAMECARD_FIXED 바인딩인데 그 공식엔 STD comp만 배선 | 코팅·프리미엄 견적 시 **STD 단가(3500)가 매겨짐** — variant comp(COAT 5500·PREMIUM 4500) 무시 |
| **D-B 인쇄면 silent 이중합산 (V-DGP-1)** | STD_S1·S2 둘 다 배선·단가행 print_opt_cd=NULL | mat_cd+100매+단면 선택 시 S1(350,000)·S2(450,000) **둘 다 와일드카드 통과→silent 합산 800,000**(경고 없음). ★ERR_AMBIGUOUS **아님**(별 comp_cd라 match_component 내부서 안 만남) — 견적이 깨지는 게 아니라 틀린 값으로 성립=더 위험 |

★ **[보정 R-2 — 2026-06-20]** D-B를 ERR_AMBIGUOUS에서 silent 이중합산으로 정정(검증가 recompute §3 반증·codex Q3 독립 합의). 또 명함 STD는 prc_typ 단가형 ×qty 결함(D-10·아래)도 보유. **둘 다 라이브 실재 결함** — 설계가 닫아야 할 1순위. dbm-price-arbiter(심의) 라우팅 표기.

### 3.1 설계 원칙 — variant별 전용 PRF (1 variant : 1 PRF : 1 상품)

명함 variant comp는 **각자 use_dims가 다르다**(STD/COAT/PEARL=mat_cd·PREMIUM/CLEAR=없음·SHAPE/MINISHAPE=siz_cd). 한 공식에 여러 variant를 묶으면:
- PREMIUM_MGA·MGB(둘 다 mat_cd 없음·min_qty=100) → `_combo_key` 동일 → ERR_AMBIGUOUS.
- variant마다 판별차원이 달라 자동매칭으로 분기 불가.

**∴ variant별 전용 PRF가 정답.** RedPrinting `price_gbn` 라우팅 흡수(C-1)와 정합 — 같은 상품군이라도 variant는 다른 공식. 인쇄면 S1/S2는 **공식 내 print_opt_cd 차원으로 분기**(아래 3.2).

| 신설 공식(frm_cd) | 상품 | 배선 comp(orphan→배선) | 인쇄면 분기 |
|------------------|------|----------------------|-------------|
| PRF_NAMECARD_FIXED (유지·교정) | 스탠다드명함 PRD_000033 | STD_S1·STD_S2 (★3.2 면 분기) | print_opt_cd |
| **PRF_NAMECARD_COAT** (신설) | 코팅명함 PRD_000032 | COAT_S1·COAT_S2 | print_opt_cd |
| **PRF_NAMECARD_PREMIUM** (신설) | 프리미엄명함 PRD_000031 | PREMIUM_S1_MGA/MGB·S2_MGA/MGB (★MGA/MGB=등급) | print_opt_cd + 등급 |
| **PRF_NAMECARD_PEARL** (신설) | 펄명함 PRD_000034 | PEARL_S1·S2 | print_opt_cd |
| **PRF_NAMECARD_WHITE** (신설) | 화이트인쇄명함 PRD_000040 | WHITE_S1W_CL/NOCL·S2W_CL/NOCL (★코팅 분기) | print_opt_cd + 코팅 |
| **PRF_NAMECARD_SHAPE** (신설) | 모양명함 PRD_000035 | SHAPE_S1·S2 (siz_cd=칼틀) | print_opt_cd |
| **PRF_NAMECARD_MINISHAPE** (신설) | 미니모양명함 PRD_000036 | MINISHAPE_S1·S2 | print_opt_cd |
| **PRF_NAMECARD_CLEAR** (신설) | 투명명함 PRD_000039 | CLEAR_S1 (단면만 실재) | — |
| **PRF_NAMECARD_FOIL** (신설) | 오리지널박명함 PRD_000037 | FOIL_S1/S2_STD·HOLO + SETUP_S1/S2 (동판비) | print_opt_cd + 박종류 |
| (보류) 형압명함 PRD_000038 | 형압명함 | comp 미실재 → G-4 컨펌큐(FOIL 공유? 별 comp?) | — |

### 3.2 인쇄면 S1/S2 분기 — silent 이중합산 해소 (★핵심·R-2/D-2 보정)

> **[보정 R-2 + D-2 — 2026-06-20]** 제목/사유 정정: ERR_AMBIGUOUS가 아니라 **silent 이중합산** 해소. + 라이브 코드 검증으로 "컬럼 충전 + use_dims 등재 둘 다 필요" 보강(design-decisions D-3 ★).

**문제**: S1(단면)·S2(양면) comp가 한 공식에 둘 다 배선되고 판별차원(print_opt_cd) 단가행이 NULL → 인쇄면 무관 둘 다 매칭 → **silent 이중합산**(경고 없이 단면+양면 합산 과청구). ERR_AMBIGUOUS 아님(별 comp_cd).

**해법 2안 (dbm-price-arbiter 심의 권고·둘 다 무손실)**:
- **안 ① print_opt_cd 차원 충전 + use_dims 등재** (권장): (a) S1 단가행에 `print_opt_cd=POPT_000001(단면)`, S2에 `POPT_000002(양면)` 충전 — 매칭은 `_row_matches`가 행 컬럼(NON_QTY_DIMS, print_opt_cd 포함) 기준이라 컬럼만 채우면 단면 선택은 단면행만 통과(이중합산 차단). (b) 두 comp의 `use_dims` 배열에 print_opt_cd 등재 — 안 하면 `_match_entry`(:412-415)가 "판별차원 없음 항상매칭" 오경고 + 옵션→차원 주입 레이어가 인쇄면을 안 받아 0원 침묵으로 뒤집힘. 단가값 불변(verbatim)·차원값/use_dims만 추가. → **단가행 UPDATE + use_dims UPDATE**(dbmap 위임).
- **안 ② 별 공식 분리**: 단면용 PRF·양면용 PRF 2개. 상품 1개에 인쇄면 선택→공식 라우팅. 과설계(상품수 2배)·비권장.

**설계 채택 = 안 ①** (차원 충전 + use_dims 등재). 명함 옵션그룹에 "인쇄" 옵션(OPT_000048) 실재·POPT_000001/002 실재 확인. **컨펌큐 G-7**: 인쇄 옵션값↔POPT 코드 매핑(option_items 매핑 0행이라 옵션→차원 자동주입 현재 미연결).

### 3.3 포토카드 — PRF_PHOTOCARD_FIXED (유지 + BULK 배선 검토)

| comp | 의미 | use_dims | 단가행 | 상태 |
|------|------|----------|--------|------|
| COMP_PHOTOCARD_SET | 일반세트 고정 | siz_cd·bdl_qty·min_qty | 1 | 유지 |
| COMP_PHOTOCARD_CLEAR_SET | 투명세트 고정 | siz_cd·bdl_qty·min_qty | 1 | 유지 |
| COMP_PHOTOCARD_BULK | **대량(낱장)** | min_qty | **50** | **orphan — 바인딩 검토** |

★ **PHOTOCARD_BULK 50행 실재·orphan**. SET(묶음)과 BULK(낱장)은 주문 단위가 다름(세트 vs 대량). **컨펌큐**: 포토카드 = 세트 주문 + 대량 주문 두 모드인가? 그러면 BULK도 PRF_PHOTOCARD_FIXED에 배선(또는 별 공식)하되 **세트/대량 동시매칭 방지**(bdl_qty 유무로 판별 — SET은 bdl_qty 차원, BULK는 min_qty만 → combo_key 다름 → 안전). → 설계: **BULK를 PRF_PHOTOCARD_FIXED에 addtn_yn=Y 배선**(bdl_qty 판별로 ambiguous 회피). dbm-price-arbiter 심의.

---

## 4. 상품↔공식 바인딩 설계 (product_price_formulas)

미바인딩 25상품(실측) 중 디지털인쇄 본체 바인딩 명세. **신규 mint 0**(공식은 위 신설, comp는 실재).

| 상품군 | 상품(prd_cd) | 바인딩 공식 | 비고 |
|--------|-------------|-------------|------|
| 명함 variant 7 | PRD_000034~040 | 각 PRF_NAMECARD_* (3.1) | orphan comp 바인딩 |
| 투명엽서 | PRD_000019 | PRF_DGP_A | 투명종이=mat_cd 차원(엽서 공식 재사용·신규 불요) |
| 와이드접지리플렛 | PRD_000049 | PRF_DGP_E or PRF_FOLD_SUM | 접지 family·컨펌(접지타입) |
| 엽서북 내지/표지 | PRD_000095/096 | (세트 — §set-product) | 본체 PRD_000094=PRF_PCB_FIXED 실재 |
| 봉투류 5 | PRD_000001~005·281~283 | (추가상품 vs 독립 — 컨펌큐 G-6) | OPP·카드봉투·트레싱지·캘린더봉투 |

---

## 5. 단가행 그릇 (component_prices) — 설계 = "실재 검증 + 차원 충전"

디지털인쇄 단가행은 **대부분 실재·verbatim**. 설계가 지정하는 그릇 작업:

| 작업 | 대상 | 내용 | 트랙 |
|------|------|------|------|
| **차원 충전(UPDATE)** | NAMECARD_*_S1/S2·PCB_S1/S2 단가행 | print_opt_cd(단면/양면·POPT_000001/002) 충전 → silent 이중합산 해소(3.2·R-2) | dbmap·단가값 불변 |
| **use_dims 등재(UPDATE)** | NAMECARD_*_S1/S2·PCB_S1/S2 comp | `t_prc_price_components.use_dims`에 print_opt_cd 추가 → "항상매칭" 오경고/0원 침묵 방지(D-2 검증) | dbmap·단가값 불변 |
| **★prc_typ 교정(컨펌 대기)** | 전 고정가형 comp(명함8+엽서북PCB+포토카드BULK+박 FOIL/SETUP) | 단가형 ×qty 과대청구(D-10·R-1) — 교정방향(합가형÷min_qty=X / qty정규화=Y) **dbm-price-arbiter 심의·사용자 컨펌 대기**. SETUP(D-11)=정액 처리 별도 | dbmap·**컨펌 대기·확정 금지** |
| **단가행 INSERT(결손)** | COMP_COAT_GLOSSY 유광 | 가격표 코팅 유광단/양 단가 적재(V-4·현재 0원 침묵) | [[dbmap-price-import-round16]] |
| **신규 단가행** | COMP_FOIL_LARGE(대형박) | 가격표 후가공_박 시트 [면적별 동판비]+[A~E군 합가] verbatim | G-1·search-before-mint 후 |
| **유지(무변경·단가값)** | 명함 variant·포토카드·엽서북 본체 단가값 | 단가값 실재·verbatim·결손 아님(prc_typ/차원만 교정·값 불변) | — |

★ 단가값은 **전부 가격표 verbatim**(예 STD MAT_000074=3500·COAT MAT_000081=5500·FOIL_HOLO 200매=24800 — 실측). 설계는 값을 만들지 않는다(날조 0). 신규 단가행(대형박)은 가격표 셀 출처 필수(§golden-cases).

---

## 6. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract) | 설계 준수 |
|----------------------|-----------|
| C7 frm_typ 미참조·공식=합산 | ✅ 고정가형도 합산형으로 표현(comp 1개 배선) |
| P3-8 ERR_AMBIGUOUS 금지 | ✅ variant별 전용 PRF(PREMIUM_MGA/MGB 동일combo ambiguous 회피·E4 확정)·포토카드 SET/BULK bdl_qty 판별. ★인쇄면 S1/S2는 별 comp라 ambiguous 아닌 silent 이중합산 → print_opt_cd 충전+use_dims 등재로 해소(R-2) |
| P3-DEF 판별차원 없음 금지 | ✅ 차원 충전(NULL 단가행에 판별값 부여)+use_dims 등재. ★박 SETUP use_dims=[]→정액 처리 컨펌 대기(D-11) |
| P4-1 단가형 ×qty | ⚠ **전 고정가형 단가형 ×qty 과대청구(D-10·R-1)** — 묶음/구간총액인데 단가형. 교정방향 컨펌 대기(합가형÷min_qty 시 P4-3 min_qty 必) |
| P4-3 합가형 min_qty 필수 | ⚠ COMP_FOIL_LARGE 합가형이면 단가행 min_qty 必(NULL 금지)·prc_typ 합가형 교정 시 전 고정가형 동일 가드 |
| U-7 시트 차원경계(R-4) | ✅ 명함=완제품 통합단가 comp만(종이 후가공 comp 침입 금지·R-4) |
| search-before-mint | ✅ 신규 comp = 대형박 1건만(나머지 orphan 바인딩) |

---

## 7. designer 큐 잔여 (set-product·design-decisions로 이관)

- **G-1 대형박 comp 실재 점검** → §3 search-before-mint(design-decisions)에서 라이브 FOIL/BAK comp 전수 후 신설 판정.
- **엽서북 세트(내지+표지)** → set-product-design.md.
- **봉투류 경계**(추가상품 vs 독립) → 컨펌큐(design-decisions G-6).
- **형압명함 comp 부재** → 컨펌큐(FOIL 공유 여부).
