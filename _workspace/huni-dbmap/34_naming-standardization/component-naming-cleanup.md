# 가격구성요소 146 comp_nm/note 표준 정리표 (현재값 → 표준안) [v2 정교화]

> **산출자:** dbm-price-formula-auditor(v1) · dbm-domain-researcher(v2 정교화) · round-34 · 2026-06-18 · 라이브 `t_prc_price_components` 146행 실측
> **v2 권위 순서(HARD):** ① 후니 레거시(huniprinting.com·buysangsang.com 상품명) → ② 라이브 note·proc_nm·cod_nm → ③ huni-rpmeta(흡수·naming 유입 0) → ④ 인쇄표준
> **v2 핵심 정정:** 명함 종류=후니 실제명(스탠다드·화이트인쇄·펄(스타드림)·오리지널박명함) · add-on=라이브 note 후니 용어(큐방·열재단·봉미싱·각목900±·천정형고리·우드행거+면끈) · 컨펌 3건 라이브 권위 해소. 상세 §naming-domain-refinement.md.
> **결함 핵심:** **comp_nm 코드 노출 102/146** (`[COMP_xxx]`) — 실무진이 화면에서 코드를 읽게 됨.
> **DB 쓰기 0 (정리안까지·실 UPDATE는 인간 승인).** 변별자(소재·면·옵션)는 코드가 아닌 **사람이 읽는 한글**로.

## 통계
- 전체 comp = **146** · 코드 노출 = **102** (.04 후가공 16 + .05 박형압 2 + .06 완제품 83 + 빈typ 1)
- 코드 노출 클러스터 = 15 (아래 §클러스터별 정리)
- 빈 note(use_yn=Y) = 2 (COMP_ACRYL_COROTTO·STK_TATTOO) — note 보강 대상
- comp_typ_cd 빈값 = 1 (COMP_STK_TATTOO) → `PRC_COMPONENT_TYPE.06` 설정 필요

---

## A. 코드 노출 클러스터별 표준안 (102개 — 우선순위 1)

핵심 규칙: **base 클러스터명을 표준어로 + 코드 접미사를 한글 변별자로.** S1=단면, S2=양면.

### A-1. 명함 완제품가 (19개) — `{후니 명함 종류명} 완제품가(용지포함)` [v2: 라이브 note 후니 종류명 권위]
표준안 base = **{후니 종류명}명함 완제품가(용지포함)** + 면. **★종류명 = 라이브 `t_prc_component_prices.note` 후니 실제 용어**(STD→스탠다드·WHITE→화이트인쇄·PEARL→펄(스타드림)).

| comp_cd | → 표준안 comp_nm (v2) | 권위출처(라이브 note 후니 종류명) |
|---|---|---|
| COMP_NAMECARD_STD_S1 | 스탠다드명함 완제품가 단면(용지포함) | "스탠다드명함/단면/백모조220·아트250·스노우250" |
| COMP_NAMECARD_STD_S2 | 스탠다드명함 완제품가 양면(용지포함) | "스탠다드명함/양면" |
| COMP_NAMECARD_COAT_S1 | 코팅명함 완제품가 단면(용지포함) | "코팅명함/단면/아트250·아트300" |
| COMP_NAMECARD_COAT_S2 | 코팅명함 완제품가 양면(용지포함) | "코팅명함/양면" |
| COMP_NAMECARD_CLEAR_S1 | 투명명함 완제품가 단면(용지포함) | "투명명함/단면/투명PET260·반투명PET260" |
| COMP_NAMECARD_PEARL_S1 | 펄명함(스타드림) 완제품가 단면(용지포함) | "펄명함 (스타드림)/단면/다이아·실버·골드·로츠쿼츠 240" |
| COMP_NAMECARD_PEARL_S2 | 펄명함(스타드림) 완제품가 양면(용지포함) | "펄명함 (스타드림)/양면" |
| COMP_NAMECARD_PREMIUM_S1_MGA | 프리미엄명함A 완제품가 단면(용지포함) | "프리미엄명함/단면/A" |
| COMP_NAMECARD_PREMIUM_S1_MGB | 프리미엄명함B 완제품가 단면(용지포함) | "프리미엄명함/단면/B" |
| COMP_NAMECARD_PREMIUM_S2_MGA | 프리미엄명함A 완제품가 양면(용지포함) | "프리미엄명함/양면/A" |
| COMP_NAMECARD_PREMIUM_S2_MGB | 프리미엄명함B 완제품가 양면(용지포함) | "프리미엄명함/양면/B" |
| COMP_NAMECARD_SHAPE_S1 | 모양명함 완제품가 단면(용지포함) | "모양명함 (90x50)/단면/몽블랑240" |
| COMP_NAMECARD_SHAPE_S2 | 모양명함 완제품가 양면(용지포함) | "모양명함 (90x50)/양면" |
| COMP_NAMECARD_MINISHAPE_S1 | 미니모양명함 완제품가 단면(용지포함) | "미니모양명함 (50x50)/단면/몽블랑240" |
| COMP_NAMECARD_MINISHAPE_S2 | 미니모양명함 완제품가 양면(용지포함) | "미니모양명함 (50x50)/양면" |
| COMP_NAMECARD_WHITE_S1W_CL | 화이트인쇄명함 완제품가 단면·코팅(용지포함) | "화이트인쇄명함 (큐리어스스킨)/화이트(단면)+클리어(단면)" |
| COMP_NAMECARD_WHITE_S1W_NOCL | 화이트인쇄명함 완제품가 단면·무코팅(용지포함) | "화이트인쇄명함 (큐리어스스킨)/화이트(단면)" |
| COMP_NAMECARD_WHITE_S2W_CL | 화이트인쇄명함 완제품가 양면·코팅(용지포함) | "화이트인쇄명함/양면·코팅" |
| COMP_NAMECARD_WHITE_S2W_NOCL | 화이트인쇄명함 완제품가 양면·무코팅(용지포함) | "화이트인쇄명함/양면·무코팅" |

> note 표준(전건): `{종류}명함 완제품가(용지 포함). 소재·인쇄면·수량 합산 1건당 단가표.` (현재값 유지·이미 양호)
> ★ 1차 정리안 "일반·화이트·펄" → 후니 실제명 "스탠다드·화이트인쇄·펄(스타드림)"으로 정정(buysangsang.com + 라이브 note 권위).

### A-2. 오리지널박명함 (4개) — `오리지널박명함 완제품가(종이+동판+박 합가)` [v2: 후니 라인업명]
표준안 base = **오리지널박명함 완제품가(종이+동판+박 합가)** + 면·박종류. **★"오리지널박명함" = 후니 고유 라인업명**(라이브 note·"일반박" 폐기).

| comp_cd | → 표준안 comp_nm (v2) | 권위출처(라이브 note) |
|---|---|---|
| COMP_NAMECARD_FOIL_S1_STD | 오리지널박명함 완제품가 단면·일반박(종이+동판+박) | "오리지널박명함…단면/금유광·은유광·먹유광·청박·적박·동박" |
| COMP_NAMECARD_FOIL_S1_HOLO | 오리지널박명함 완제품가 단면·홀로그램/트윙클(종이+동판+박) | "…단면/홀로그램·트윙클" |
| COMP_NAMECARD_FOIL_S2_STD | 오리지널박명함 완제품가 양면·일반박(종이+동판+박) | "…양면/금유광·은유광·먹유광·청박·적박·동박" |
| COMP_NAMECARD_FOIL_S2_HOLO | 오리지널박명함 완제품가 양면·홀로그램/트윙클(종이+동판+박) | "…양면/홀로그램·트윙클" |

> ★ 박종류 후니 용어: 일반박 = 금유광·은유광·먹유광·청박·적박·동박 / 특수박 = 홀로그램·트윙클(라이브 note). "STD/HOLO" 코드 폐기.

### A-3. 박·형압 동판셋업비 (2개) — `[COMP_NAMECARD_FOIL_SETUP_*]`
| comp_cd | → 표준안 comp_nm |
|---|---|
| COMP_NAMECARD_FOIL_SETUP_S1_STD | 박·형압 동판셋업비 단면 |
| COMP_NAMECARD_FOIL_SETUP_S2_STD | 박·형압 동판셋업비 양면 |

### A-4. 제본비 후가공 (8개 코드노출 + 정리된 3 = 제본 클러스터) — `제본비(후가공) [COMP_BIND_*]`
표준안 = **제본비** + 종류(권위 proc PROC_000017 자식).

| comp_cd | → 표준안 comp_nm |
|---|---|
| COMP_BIND_JUNGCHEOL | 제본비 중철 |
| COMP_BIND_MUSEON | 제본비 무선 |
| COMP_BIND_PUR | 제본비 PUR |
| COMP_BIND_HC_MUSEON | 제본비 하드커버무선 |
| COMP_BIND_HC_TWINRING | 제본비 하드커버트윈링 |
| COMP_BIND_CAL_DESK130 | 제본비 탁상캘린더(130) |
| COMP_BIND_CAL_DESK220 | 제본비 탁상캘린더(220) |
| COMP_BIND_CAL_DESKMINI | 제본비 탁상캘린더(미니) |
| (이미 정리) COMP_BIND_TWINRING | 제본비 → **제본비 트윈링** (현재 "제본비"만 — 종류 변별자 부재로 모호) |
| (이미 정리) COMP_BIND_SSABARI | 하드커버 제본비 → **제본비 싸바리바인더** (통일) |
| (이미 정리) COMP_BIND_CAL_WALL | 캘린더 제본비 → **제본비 벽걸이캘린더** (통일) |

> ★ COMP_BIND_TWINRING의 현재 comp_nm "제본비"는 종류 변별자 없어 **8개 제본비와 화면에서 구분 불가** — 결함. 표준안 필수.

### A-5. 접지비 후가공 (7개) — `접지비(후가공) [COMP_FOLD_*]`
권위 proc PROC_000056 자식 + 카드/리플렛 구분.

| comp_cd | → 표준안 comp_nm |
|---|---|
| COMP_FOLD_CARD_2H | 접지비 카드 2단 |
| COMP_FOLD_CARD_3H | 접지비 카드 3단 |
| COMP_FOLD_CARD_6CR | 접지비 카드 6크리즈 |
| COMP_FOLD_LEAF_HALF | 접지비 리플렛 반접지 |
| COMP_FOLD_LEAF_3FOLD | 접지비 리플렛 3단 |
| COMP_FOLD_LEAF_4ACC | 접지비 리플렛 4단아코디언 |
| COMP_FOLD_LEAF_4GATE | 접지비 리플렛 4단게이트 |

### A-6. 타공비 (1개) — `타공비(후가공) [COMP_CUT_PERF_1H6]`
| COMP_CUT_PERF_1H6 | 타공비 1구(6mm) |

### A-7. 커팅 합가 (3개) — `커팅 합가(완제품가) [COMP_CUT_FULL_*]`
| comp_cd | → 표준안 comp_nm |
|---|---|
| COMP_CUT_FULL_DIECUT | 커팅 완제품가 완칼(모양엽서·라벨택) |
| COMP_CUT_FULL_PERF_1H6 | 커팅 완제품가 완칼+타공1구 |
| COMP_CUT_FULL_PERF_2H6 | 커팅 완제품가 완칼+타공2구 |

### A-8. 엽서북 (4개) — `엽서북 단가(완제품가) [COMP_PCB_*]`
| comp_cd | → 표준안 comp_nm |
|---|---|
| COMP_PCB_S1_20P | 엽서북 완제품가 단면·20p |
| COMP_PCB_S1_30P | 엽서북 완제품가 단면·30p |
| COMP_PCB_S2_20P | 엽서북 완제품가 양면·20p |
| COMP_PCB_S2_30P | 엽서북 완제품가 양면·30p |

### A-9. 포토카드 (3개) — `포토카드 단가(완제품가) [COMP_PHOTOCARD_*]`
| comp_cd | → 표준안 comp_nm |
|---|---|
| COMP_PHOTOCARD_SET | 포토카드 완제품가 일반세트 |
| COMP_PHOTOCARD_CLEAR_SET | 포토카드 완제품가 투명세트 |
| COMP_PHOTOCARD_BULK | 포토카드 완제품가 대량 |

### A-10. 스티커/떡메/합판/타투 (5개)
| comp_cd | 현재 | → 표준안 comp_nm |
|---|---|---|
| COMP_STK_PRINT | 스티커 단가(완제품가) [COMP_STK_PRINT] | 스티커 완제품가(소재·규격) |
| COMP_STK_PACK | 스티커 단가(완제품가) [COMP_STK_PACK] | 스티커 완제품가 팩(54장1세트) |
| COMP_STK_TATTOO | 타투스티커 단가(3장 합가형) [COMP_STK_TATTOO] | 타투스티커 완제품가(3장세트) |
| COMP_TTEOKME | 떡메모지 단가(완제품가) [COMP_TTEOKME] | 떡메모지 완제품가(권당장수) |
| COMP_GANGPAN_PRINT | 합판도무송 단가(완제품가) [COMP_GANGPAN_PRINT] | 합판도무송 완제품가(형상·소재별) |

> ★ 합판도무송 = 후니/국내 인쇄 고유어(합판=여러 도안 1판, 도무송=완칼). 형상=원형·정사각·직사각, 소재=비코팅·무광코팅·유광코팅·유포·투명데드롱·은데드롱(라이브 note).

### A-11. 포스터/사인 본체 완제품가 (23개) — `포스터 완제품가(포함항목 통가격) [COMP_POSTER_*]`
표준안 = **{소재 한글명} 완제품가**(실사 결합본 패턴과 통일). frm_nm에 이미 소재 한글명 권위 있음.

| comp_cd | → 표준안 comp_nm (frm_nm 소재명 채택) |
|---|---|
| COMP_POSTER_CANVAS_HANGING | 캔버스 행잉포스터 완제품가 |
| COMP_POSTER_FOAMBOARD_WHITE | 폼보드(화이트) 완제품가 |
| COMP_POSTER_FOAMBOARD_BLACK | 폼보드(블랙) 완제품가 |
| COMP_POSTER_FOMEXBOARD_WHITE3MM | 포맥스보드(화이트3mm) 완제품가 |
| COMP_POSTER_FOMEXBOARD_WHITE5MM | 포맥스보드(화이트5mm) 완제품가 |
| COMP_POSTER_FRAMELESS_WOOD | 프레임리스우드액자 완제품가 |
| COMP_POSTER_JOKJA | 족자포스터 완제품가 |
| COMP_POSTER_LEATHER_FRAME | 레더아트액자 완제품가 |
| COMP_POSTER_LINEN_WOODBONG | 린넨 우드봉 족자 완제품가 |
| COMP_POSTER_MESH_BANNER | 메쉬배너 완제품가 |
| COMP_POSTER_MINI_BANNER | 미니배너 완제품가 |
| COMP_POSTER_MINI_STANDBOARD | 미니보드스탠딩 완제품가 |
| COMP_POSTER_PET_BANNER | PET배너 완제품가 |
| COMP_POSTER_SHEETCUT_HOLO | 홀로그램 시트커팅 완제품가 |
| COMP_POSTER_SHEETCUT_MATTE | 무광시트커팅 완제품가 |
| COMP_POSTER_ACRYLSTK_GLOSS | 유광아크릴스티커 완제품가 |
| COMP_POSTER_ACRYLSTK_MIRROR | 미러아크릴스티커 완제품가 |
| COMP_POSTER_ADH_WATERPROOF_PVC (use_yn=N) | (레거시·정본에 통합) 접착방수포스터 완제품가[레거시] |
| COMP_POSTER_ARTFABRIC_GRAPHIC (N) | 아트패브릭포스터 완제품가[레거시] |
| COMP_POSTER_LEATHER_ARTPRINT (N) | 레더아트프린트 완제품가[레거시] |
| COMP_POSTER_MESH_PRINT (N) | 메쉬프린트 완제품가[레거시] |
| COMP_POSTER_TYVEK_PRINT (N) | 타이벡프린트 완제품가[레거시] |
| COMP_POSTER_WATERPROOF_PET (N) | 방수포스터 완제품가[레거시] |

> ★ use_yn=N 6건은 round-23 동형결합 dedup의 레거시(정본 ARTPRINT_PHOTO/CANVAS_FABRIC에 가격 통합). comp_nm에 `[레거시]` 명시로 화면에서 비활성임을 표시(코드 제거).

### A-12. 포스터/현수막 추가옵션 add-on (23개) — `{소재} {후니 옵션명} 추가가격` [v2: 라이브 note 권위로 확정]
표준안 = **{소재} {옵션 후니 한글명} 추가가격**. **★옵션 한글명 = 라이브 `t_prc_component_prices.note` 후니 실제 용어**(추정 폐기·컨펌 해소). 정정: QBANG=**큐방**(구방❌)·CUTEDGE=**열재단**(재단마감❌)·BONGSEW=**봉미싱**(봉제❌).

| comp_cd | → 표준안 comp_nm (v2) | 권위출처(라이브 note 후니 용어) |
|---|---|---|
| COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4 | 일반현수막 끈(4개) 추가가격 | "일반현수막 추가옵션 끈(4개)" |
| COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4 | 일반현수막 큐방(4개) 추가가격 | "일반현수막 추가옵션 큐방(4개)" |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4 | 일반현수막 타공(4개) 추가가격 | "가공옵션 타공(4개)" |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6 | 일반현수막 타공(6개) 추가가격 | "가공옵션 타공(6개)" |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8 | 일반현수막 타공(8개) 추가가격 | "가공옵션 타공(8개)" |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW | 일반현수막 봉미싱 추가가격 | "가공옵션 봉미싱"(4000) |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE | 일반현수막 열재단 추가가격 | "가공옵션 열재단"(3000)·proc PROC_000084 |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE | 일반현수막 양면테잎 추가가격 | "가공옵션 양면테잎"(3000) |
| COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4 | 메쉬현수막 끈(4개) 추가가격 | "메쉬현수막 추가옵션 끈(4개)" |
| COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4 | 메쉬현수막 큐방(4개) 추가가격 | "메쉬현수막 추가옵션 큐방(4개)" |
| COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4 | 메쉬현수막 타공(4개) 추가가격 | note |
| COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6 | 메쉬현수막 타공(6개) 추가가격 | note |
| COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8 | 메쉬현수막 타공(8개) 추가가격 | note |
| COMP_POSTEROPT_BANNER_MESH_PROC_OPT | 🔵 (가격행 0행·빈 더미) | **컨펌**: 미사용 잔재면 use_yn=N |
| COMP_POPT_BNR_GAKMOK_STR_900_4 | 🔵 (가격행 0행·base 빈 더미) | **컨펌**: _GT/_LE만 활성 → use_yn=N 검토 |
| COMP_POPT_BNR_GAKMOK_STR_900_4_GT | 현수막 각목(900mm 초과)+끈(4개) 추가가격 | "각목(900mm 초과)+끈(4개)"(8000) |
| COMP_POPT_BNR_GAKMOK_STR_900_4_LE | 현수막 각목(900mm이하)+끈(4개) 추가가격 | "각목(900mm이하)+끈(4개)"(4000) |
| COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER | 캔버스행잉포스터 우드행거+면끈 추가가격 | "우드행거+면끈/A2·A3·A4" |
| COMP_POSTEROPT_JOKJA_CEILHOOK | 족자포스터 천정형고리 추가가격 | "천정형고리 포함(2개 1세트)" |
| COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG | 린넨우드봉족자 우드봉+면끈 추가가격 | "우드봉+면끈/A2·A3·A4" |
| COMP_POSTEROPT_PET_BANNER_STAND_IN | PET배너 실내용배너거치대 추가가격 | "실내용배너거치대" |
| COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1 | PET배너 실외용배너거치대(단면용) 추가가격 | "실외용배너거치대(단면용)" |
| COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2 | PET배너 실외용배너거치대(양면용) 추가가격 | "실외용배너거치대(양면용)" |

> ✅ **컨펌-1 해소:** `_GT`/`_LE` = 각목 900mm 초과/이하(라이브 note·단가 8000/4000). PROC_OPT·GAKMOK base = **가격행 0행 빈 더미**(미사용 잔재 가능성·use_yn=N 검토 컨펌).
> ✅ **컨펌 정정:** QBANG→큐방·CUTEDGE→열재단·BONGSEW→봉미싱 (라이브 note 후니 실무 용어 권위·rpmeta QBG_DFT/CUT_ZUN/SEW_DFT 개념 교차검증·naming 유입 0).

---

## B. 이미 정리됨(코드 없음) — 유지/소폭 보정 (44개)

| comp_cd | 현재 comp_nm | 조치 |
|---|---|---|
| COMP_PRINT_DIGITAL_S2 | 디지털인쇄비 | 유지 |
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 출력비 | → **디지털인쇄비(단면)** ("출력비" 중복어·S2와 변별) |
| COMP_PRINT_SPOT_WHITE_S1 | 별색인쇄비 | 유지(정본·5색 통합) |
| COMP_PRINT_SPOT_*_S1/S2 (9건 use_yn=N) | 별색인쇄비 클리어(단면) 등 | 유지(레거시·이미 표준 패턴·코드 없음) |
| COMP_COAT_GLOSSY/MATTE | 유광/무광코팅비 | 유지 |
| COMP_PAPER | 용지비(종이별 절가) | 유지 |
| COMP_PP_CREASE_1L | 오시비 | 유지 |
| COMP_PP_CREASE_2L/3L | 오시 2줄/3줄 | → **오시비 2줄/3줄** ("비" 일관) |
| COMP_PP_PERF_1L | 미싱비 | 유지 |
| COMP_PP_PERF_2L/3L (use_yn=N) | 미싱 2줄/3줄 | → **미싱비 2줄/3줄** |
| COMP_PP_CORNER_RIGHT/ROUND | 모서리 비/모서리 둥근 | → **귀돌이비 직각/귀돌이비 둥근** (proc PROC_000026 "귀돌이" 권위·"모서리 비" 띄어쓰기 오류) |
| COMP_PP_VARTEXT_1EA | 가변텍스트 | 유지 (→ "가변텍스트비"는 선택적) |
| COMP_PP_VARTEXT_2EA/3EA | 가변텍스트 2개/3개 | 유지 |
| COMP_PP_VARIMG_1/2/3EA | 가변이미지/가변이미지 2개/3개 | 유지 |
| COMP_ENV_MAKING | 봉투제작 완제품가 | 유지 |
| COMP_ACRYL_CLEAR3T | 투명아크릴 인쇄가공비 | 유지 |
| COMP_ACRYL_MIRROR3T | 미러아크릴3T 인쇄가공비 | 유지 |
| COMP_ACRYL_COROTTO | 아크릴코롯토 인쇄가공비 | 유지 + **note 빈값 보강** |
| COMP_POSTEROPT_LINEN_FINISH | 린넨 마감가공비 | 유지 |
| COMP_POSTER_*_PHOTO/_FABRIC/_PVC/_MATTE 등 실사 결합본 8건 | 실사 완제품가 (…) | 유지(모범 패턴) |

---

## C. note 표준 양식 + 보강 대상

note 일관 양식: `{무엇}. {차원축}. {특이사항/골든}`
- 빈 note 2건(use_yn=Y) 보강:
  - COMP_ACRYL_COROTTO → `아크릴코롯토 인쇄·가공 포함가. 사이즈·수량별 단가표.`
  - COMP_STK_TATTOO → `타투스티커 완제품가. 3장 1세트당 합산가(합가형).`
- COMP_STK_TATTOO **comp_typ_cd 빈값 → PRC_COMPONENT_TYPE.06 설정**(완제품비).

---

## D. 가격공식 frm_nm 점검 (48) — GO
- 48/48 코드 노출 0 (이미 정리됨). 정리 불필요.
- note 빈값 3건 보강 권장: PRF_COROTTO_ACRYL·PRF_STK_PACK·PRF_STK_TATTOO.
