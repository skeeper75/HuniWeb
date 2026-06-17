# RP-Meta 결함 라우팅 (_defects.md)

> rpm-validator. M1~M6 게이트에서 발견한 결함을 책임 단계로 라우팅.
> 전체 판정 = **GO**(NO-GO 0). 결함은 전부 **Low**(판정 무영향·문서 정합/freshness). 차단 0.

---

## D-1 (Low) — SIZE_0 토큰 표기 정밀도 [M1 → rpm-reverse-engineer]

- **위치:** `01_reverse/rp-option-extract-BN.md:54` `사이즈직접입력(SIZE_0 cut 0x0)`.
- **결함:** 캡처(`s3_BNBNFBL.json`)에 리터럴 `SIZE_0` 부재. 실제 토큰=`사이즈직접입력`+`DIV_NM`/`DIV_CD`. `SIZE_0`은 아키텍트 약어.
- **심각도:** Low — 날조 아님(자유입력 모드는 캡처 실재, 출처규칙이 unobserved 날조 금지 명시). 표기 약어가 리터럴 코드처럼 보일 소지만 있음.
- **조치(선택):** `SIZE_0`을 "(자유입력 모드, 아키텍트 표기)"로 주석하거나 캡처 실토큰(DIV_CD) 병기. 메타모델 §13은 이미 `user_input(SIZE_0 자유)`로 약어 명시 — 일관성 OK.

---

## D-2 (Low) — 부차 행수 freshness 드리프트 [M4 → rpm-gap-analyst]

- **위치:** `03_gap/gap-matrix.md` 본문 부차 행수.
- **결함:** 일부 비핵심 행수가 검증자 라이브 재실측(2026-06-17)과 상이:
  | 테이블 | gap 표기 | 검증자 재실측 |
  |---|---:|---:|
  | t_prd_product_materials | 402 | **772** |
  | t_siz_sizes | 497 | **510** |
  | t_prd_product_sizes | 444 | **449** |
  | t_prd_product_plate_sizes | 509 | **424** |
- **심각도:** Low — 이 행수들은 어떤 PASS/WEAK/GAP 판정의 *근거*가 아님(전부 표현력 판정). gap-matrix §0의 핵심 12행수(option_items 등)는 전부 일치. 동일 세션 내 다른 시점 조회 또는 본문 내 옛 인용 혼입 추정.
- **조치(선택):** 부차 행수를 본 verdict 재실측값으로 갱신. 판정 변경 불요.

---

---

# ═══ GS(굿즈) 확장 결함 (v2.0·BN D-1/D-2 보존) ═══

## D-3 (Low) — 형태가공 공정 행 과소카운트 [M4 → rpm-gap-analyst]

- **위치:** `03_gap/gap-matrix.md:215` (§V #14) "라이브 `t_proc_processes` 실측: 조립/봉제/지퍼/가공 검색 → `PROC_000080 봉제`·`PROC_000088 봉제` 2행만".
- **결함:** 검색어(조립/봉제/지퍼/가공)가 **부착/족자제작/에폭시를 누락**. 검증자 라이브 재실측(2026-06-17): 형태가공 관련 = PROC_000080 봉제·**081 부착·082 족자제작·083 에폭시**(+중복 088/089/093/095). "봉제 2행만"은 과소.
- **심각도:** Low — **판정 무영향**(#14 GAP 판정 자체는 정확·`proc_typ_cd` 분류축 부재가 진짜 결손). 더구나 **04_vessel/vessel-form-assembly가 자체 라이브 재측으로 이미 정정**(PROC_000080~083 + prcs_dtl_opt 4스키마 정확 인용) → gap의 과소카운트가 vessel에서 교정됨(생성자≠검증자 분리 실작동).
- **조치(선택):** gap-matrix §V #14 행수를 "봉제/부착/족자/에폭시 4축(+중복)·proc_typ_cd 부재가 핵심 결손"으로 갱신. 판정(GAP) 변경 불요.
- **재실측 근거:** `t_proc_processes` proc_nm ~ '봉제|부착|족자|에폭시|조립|지퍼|가공' → 080봉제·081부착·082족자제작·083에폭시·088봉제·089부착·093족자제작·095에폭시. prcs_dtl_opt: 봉제`{유형:[오버로크,말아박기,봉미싱],폭:mm}`·부착`{대상:[라벨,맥세이프,끈,테입]}`·족자`{모양:[사각,원형]}`·에폭시 NULL.

---

---
---

# ═══ TP(디자인템플릿) 확장 결함 (v3.0·BN/GS 보존) ═══

## D-4 (Low) — "ORD_CNT=13" 캡처 미실재 표기 [M1 → rpm-reverse-engineer]

- **위치:** `categories/TP/reverse.md:163` `→ result_sum.PRICE=11900 (개당단가, ORD_CNT=13)`.
- **결함:** TPCLWLB priceCall 캡처(`s6_cal_TPCLWLB.json`) PRICE_LOG 재파싱 = "개당단가:11900.00원, 인쇄수량:1, **주문건수:1**". **ORD_CNT(주문건수)=1**, 13 아님.
- **심각도:** Low — **판정 무영향**(load-bearing 주장 PRICE=11900·PRT_DFT 인쇄 주체·에디터 PCS=0는 field-for-field 정확). "ORD_CNT=13"은 비-load-bearing 보조 주석(효도달력 13면 페이지수를 ORD_CNT로 오기 또는 다른 수량 상태 혼입 추정).
- **조치(선택):** `ORD_CNT=13` 삭제 또는 "(주문건수=1, 비로그인 캡처)"로 정정. 가격 구조 주장 무영향.
- **재실측 근거:** priceCalls[0].respBody.result[3] PRICE=11900(PCS_COD=PRT_DFT 인쇄단면)·result_sum.PRICE=11900·PRICE_LOG 주문건수=1.

---

## D-5 (Low) — 부차 카운트 freshness(proc 96/97·templates 테스트행) [M4 → rpm-gap-analyst]

- **위치:** `03_gap/gap-matrix.md:53`(t_proc_processes 96)·§IX-A(t_prd_templates 12행 봉투 전수).
- **결함:** ① 검증자 라이브 재실측(2026-06-17) `t_proc_processes`=**97**(gap·이전 verdict 인용 96, +1 드리프트). ② `t_prd_templates` 12행 중 **3행이 "테스트 템플릿"**(테스트 더미)·9행이 봉투 완제SKU — gap/vessel이 봉투류만 인용(테스트행 미언급).
- **심각도:** Low — **판정 무영향**. proc 96/97 ±1은 어떤 PASS/WEAK/GAP 근거 행수 아님(공정=PASS 표현력 판정). templates 테스트 3행은 T-A 이중의미 판정(봉투=완제SKU≠디자인 시안)을 바꾸지 않음(테스트행도 디자인 시안 아님).
- **조치(선택):** proc 카운트를 97로 갱신·templates 인용에 "(테스트 3행 포함 12)" 병기. 판정 변경 불요.

---

## 라우팅 요약

| ID | 게이트 | 책임 단계 | 심각도 | 차단? | 군 |
|---|---|---|:--:|:--:|:--:|
| D-1 | M1 | rpm-reverse-engineer | Low | No | BN |
| D-2 | M4 | rpm-gap-analyst | Low | No | BN |
| D-3 | M4 | rpm-gap-analyst | Low | No | GS |
| D-4 | M1 | rpm-reverse-engineer | Low | No | TP |
| D-5 | M4 | rpm-gap-analyst | Low | No | TP |

- **NO-GO 0 / 차단 0** — 재게이트 불요. BN+GS+TP 전 단계 GO 비준.
- D-1~D-5는 정합 개선(선택) — 산출물 신뢰성·판정에 영향 없음.
- **GS vessel(04) 4종 결함 0** — M5 search-before-mint 라이브 입증 통과(신규 테이블 0·이행종속 거부 정당·84상품 load-bearing 확증·컨벤션 drift 0).
- **TP vessel(04) V-10/V-11 결함 0** — M5 search-before-mint 라이브 입증 + 양 DDL BEGIN..ROLLBACK DRY-RUN 0 leaked(INSERT11+ALTER8+UPDATE107+CREATE2 무오류). 신규 테이블 2(V-11 시안 1:N·이중의미) 정당·V-10 테이블 0(채널 1:1) 정당.
- **GS 핵심 직답 확인:** 본체소재 vessel-gap(분해축)+data 양면 · #15 신규 그릇 0 정당(semi_role_cd 28행) · MAT_TYPE.09/.10 오라벨 확정(112 비자재·목적지 선행 필수).
- **TP 핵심 직답 확인:** #16 디자인 입력 채널 = **GAP(vessel-gap)** 라이브 확정(editor_yn 불리언만·item_gbn/채널/리소스/VDP 그릇 전무·base_code 에디터 enum 0·dbmap 미터치 신규) · D-11 = **진짜 distinct**(캡처 cross-tab으로 채널⊥가격·editor_yn 환원불가 동의) · 템플릿#4↔#16 이중의미 분리 정당(t_prd_templates=봉투 완제SKU 실측).

---

## PR-M1 (추출 충실성) — rpm-reverse-engineer 신규 산출 독립 검증

> 검증 대상 `categories/PR/reverse.md`. 인용 캡처를 직접 Read/parse하여 라인/필드 단위 실측 대조.
> **판정 = CONDITIONAL-GO** (날조 0·핵심 실측 전건 일치, but 전수추적 1누락 + 내부 수치 불일치 1).

### 실측 대조 결과 (전건 일치 — 날조 없음)
- **PRBKYPR 캡처(`captures/product_PRBKYPR.json`) 풀 실측 일치:** 표지/내지 분리(`pdt_mtrl_info` RXART300 vs `inner_pdt_mtrl_info` RXYWM080/100·RXPLW080/100 윤전전용지) · `inner_pdt_dosu_info`=SID_D 양면(NOTE "책자 내지 인쇄색도") · INN_MAX_WGT=130/COV_MIN_WGT=150 · INN_PAGE(MIN 10/MAX 300/STEP 1/DFT 30)·PRN(MIN 30/INC 10) · 면지 END_PAP 10색(노랑~회색 + NOTICE "내지 시작 전/후 컬러 양면인쇄 면지 삽입") · BIND_DIRECTION(BPLFT 좌철/BPTOP 상철 ESN=Y) · CVR_SWN 날개·CVR_SFT 소프트·SCO_DFT 부분UV(NOTICE "에디터 주문 불가") · disable 24건(RXOMO080 7건/RXOMO100 9건/RXPL* 각2건) · skinInfo quantityGroup={"orderCnt":"수량","printCnt":"내지장수"} · useKoiEditor=Y/usePDF=Y. **전부 캡처에 리터럴 실재.**
- **가격 8조합(`price-engine-reversed.md`) 일치:** Δ1,120/page(라인125 "+1,120/page"·라인128 "1,115~1,120원") · 56,000/420,900/89,500 · CVR_CLR_CNT/INN_CLR_CNT 독립입력 · book2025_price. 수치 날조 0.
- **PRPOXXX 포스터(`s3_PRPOXXX.json` productInfo[0]) 일치:** pdt_mtrl_info=**45** · FLD_DFT **7종 정확**(2단/3단/4단/대문/반대문/4단 병풍/N모양 — 캡처와 리터럴 일치) · 사이즈 6종(A2 420×594 DFT=Y/A3/A4/B3(4절)364×515/B4(8절)257×364/직접입력 100×150~) · digital_price·digital_item·NO_STD_ABL_YN=N·PDT_UNIT=장·useKoiEditor=N/usePDF=Y. 가격 PRICE=0(비로그인) 정직 기록.
- **badge 정직성:** `[live:SSR-negative]`(PRLFXXX Vue client-render·옵션 미노출)는 정직한 "검증불가"로, 접지축을 동형 포스터 실측으로 보강·리플렛 강제여부는 unobserved 처리 — 날조를 가린 흔적 없음. unobserved 53건 모두 catalog 상품명만 보유분에 정직 부착.
- **catalog 56 PR-prefix 코드** 라이브 실재 확인(`redprinting_catalog.json` PR##### 56개). 인용 코드 전건 실재.

### D-6 (Low) — 포스터 후가공 "11그룹" vs 실측 9그룹 내부 불일치 [M1 → rpm-reverse-engineer]
- **위치:** `categories/PR/reverse.md:210`·`:316` "풍부한 후가공(11그룹)"·"후가공11그룹".
- **결함:** `s3_PRPOXXX.json` productInfo[0] `pdt_pcs_info`의 distinct PCS_CD = **9그룹**(CUT/COT/FLD/HOL/LAM/MIS/OSI/SCO/THO_GRA). §3 본문 축 나열도 정확히 9개. 요약 prose만 "11그룹"으로 과대 표기.
- **심각도:** Low — 날조 아님(개별 축은 전부 실측 일치). 요약 수치만 +2 부풀림.
- **조치:** "11그룹" → "9그룹"으로 정정(본문 9축과 일치).

### D-7 (Low/Medium) — 전수추적 누락: PRSHTAG 미추적 [M1 → rpm-reverse-engineer]
- **위치:** `categories/PR/reverse.md` 전체(§4 그룹표·§331 미샘플 목록). PR##### 토큰 55종만 등장.
- **결함:** catalog PR-prefix 56종 중 **PRSHTAG("다양한 모양택")가 reverse.md 어디에도 미추적**. 반면 §4-C(라인258)에 **TPRNBND(TP접두·catalog category=GS·"링바인더")를 PR 책자군에 편입** — 결과적으로 "56상품 전수" 충족이 비-PR 코드 1개 대입 + PR 코드 1개 누락으로 성립. (TPRNBND는 URL이 `/item/PR/`이라 PR 경로 편입은 근거 있음·정직히 "코드=TP접두" 표기. 그러나 PRSHTAG 누락은 미보정.)
- **심각도:** Low~Medium — "전수 추적성" directive 대비 1상품 누락. 단 PRSHTAG는 catalog `category=ET`(URL `/item/ET/PRSHTAG`)로 진짜 PR 카테고리 소속이 아닐 수 있어(코드 prefix만 PR) 메타모델 영향은 경미.
- **조치:** PRSHTAG를 §4 카드/모양엽서군에 1행 추가(또는 "PR-prefix이나 ET 카테고리·범위 외" 명시)하여 56 전수 닫기. "56상품" 정의(코드 prefix vs catalog category)를 출처규칙에 명시 권장.

### PR-M1 종합
- **GO 근거:** 핵심 2 풀캡처(PRBKYPR/PRPOXXX) + 가격 8조합 + catalog 인용 전건 라인/필드 실측 일치. **단일 날조 0.** badge·unobserved 정직.
- **CONDITIONAL 사유:** D-7(PRSHTAG 전수추적 1누락) + D-6(11→9 수치 불일치). 둘 다 Low·판정 무영향·문서 정합. 보정 시 GO.

---

## PR 카테고리 M2~M6 결함 (라이브 재실측 2026-06-17)

> M2~M6 전건 GO. 결함 1건(Low·판정 무영향). 라우팅 = gap-analyst.

### D-PR-1 (Low) — 평량 컬럼 표기 부정확 → gap-analyst
- **위치:** `03_gap/gap-matrix.md §XI-0` 표 마지막 행 "product_materials 평량 min/max 컬럼 / COV_MIN_WGT/INN_MAX_WGT 대응 `wgt/weight/min/max` 컬럼 **0건**".
- **결함:** 라이브 재실측 결과 `t_mat_materials.weight` **컬럼 실재**(+`max_sel_cnt`). "`weight` 컬럼 0건"은 거짓 — `weight`는 존재한다(자재 단일 평량값).
- **단, 판정 무영향:** 실재하는 `weight`는 *자재 1행의 평량값*이지 RP `COV_MIN_WGT=150/INN_MAX_WGT=130` 같은 *표지/내지 플랫폼 제약 min/max 쌍*이 아니다. 정확한 표기 = "**평량 제약 min/max 쌍 컬럼 0건**". XI-3 결론(평량제약=제약#5 WEAK 흡수·별 vessel 불요) 그대로 정당 — `weight`는 자재 facet(분해축)이지 제약쌍 그릇이 아니므로 갭 판정 불변.
- **심각도:** Low — 단어 정밀도 결함. 판정(PASS/WEAK/GAP 6항·vessel mint 0) 무영향.
- **조치:** §XI-0 표를 "`weight`(자재 단일평량)는 실재하나 COV_MIN/INN_MAX *제약쌍* 컬럼 0건"으로 1줄 정정. 검증 무차단.

### PR-M2~M6 종합
- **GO 근거:** M2(16축 보존·distinct 0 도출·ERD 무모순) · M3(facet 9 역검·P-2 라이브 robust) · M4(facet 6항 PASS4/WEAK1/GAP1 전건 라이브 일치) · M5(search-before-mint 라이브 입증·mint 0 정당) · M6(deepcheck 20후보 채택0·17축 0 유입·H-1 독립 dodge-hunt 깨기 실패). **NO-GO 0·차단 0.**
- **유일 결함:** D-PR-1(평량 컬럼 표기·Low·무영향). 보정 권장이나 재게이트 불요.

---

# ═══ ST(스티커) 확장 결함 (v5.0·★16축 포화 붕괴 검증·BN/GS/TP/PR 보존) ═══

> ST M2~M6 라이브 재실측(2026-06-17·psql 직접 SELECT + 캡처 raw 파싱). **★형상축 #17 distinct 승격 = VALIDATED.** NO-GO 0·차단 0.

## ST 카테고리 M2~M6 결함

### D-ST-1 (Low) — V-12 ②a/②b 형상 컬럼 중복운영 정합규칙 미확정 [M5 → rpm-vessel-designer]
- **위치:** `04_vessel/vessel-shape-axis.md:121`(open decision 1)·`ddl-proposal-shape-axis.sql:73`.
- **결함:** V-12가 형상을 `t_prd_products.shape_cd`(②a 상품 단일형상) + `t_prd_product_sizes.shape_cd`(②b 칼틀별 1:多) 두 컬럼에 매되, 둘 다 보유 상품(원형 스티커인데 CL001~ 칼틀 다수)의 정합규칙 `products.shape_cd NOT NULL ⇒ product_sizes.shape_cd ∈ {NULL, 동일값}`을 **앱/V-4 검증으로 미루고 DB 제약으로 미확정**(open decision). 5형상 superset(STDCFBR)=②a NULL·②b 권위 분담은 무손실이나, 단일형상+다칼틀 상품의 이중저장 일관성 강제 수단이 open.
- **심각도:** Low — 설계 무손실/무중복 논증(§3.1)은 정당하고 open decision으로 정직 명시됨. 실 적용(인간 승인+dbmap 적재) 전 ST 적재 실측으로 ②a/②b 단순화 여부 판정 가능. 판정(M5 GO·신규 테이블 0·컬럼 2 최소성) 무영향.
- **조치:** ST 형상 백필 시 ②a/②b 중 하나로 단순화(상품분기형만이면 ②a·옵션형만이면 ②b) 또는 정합 트리거/CHECK 추가 검토. 검증 무차단.

### ST-M2~M6 종합
- **GO 근거:** M2(17축 5파일 카운트 일관·SHAPE 엔티티 관계 무모순·형상 도출 증거 실측 인용) · M3(★형상 #17 distinct 적대 재검 통과 — STDCFBR 5형상·CL/RC 1:多 캡처 직접 재현·과잉승격 반증 실패 / 칼선·재단·점착 facet 역검 통과·숨김 0) · M4(#17 GAP 라이브 3-레벨 전건 재현·facet 5항 PASS1/WEAK2/GAP1/부분PASS1 전건 라이브 일치) · M5(search-before-mint 라이브 입증·junction 449행 선재로 신규 테이블 0 정당·reg_dt 트랩 준수·dbmap round-3 정정=정밀화) · M6(deepcheck 30후보 채택0·#18 0 유입·codex HIGH 무검증 유입 grep 0건·형상 1:多 dodge-hunt 독립 재현). **NO-GO 0·차단 0.**
- **★형상축 #17 직답:** distinct 승격 = **VALIDATED**. 16축 포화 붕괴(5번째 카테고리 distinct 1종)는 오버피팅이 아니라 사이즈축 1:1 흡수 전제가 ST 전용 shape_info 슬롯·1:多·5형상 superset으로 깨진 증거 강제 결과 — 라이브 3-레벨 + 캡처 raw로 검증.
- **유일 결함:** D-ST-1(②a/②b 중복운영 정합규칙·Low·open decision·무영향). 보정 권장이나 재게이트 불요.

---

## CL-M1 — 추출 충실성 (CL 카테고리 reverse.md) [verdict GO·날조 0]

> rpm-validator 독립 재측정 2026-06-17. 캡처 직접 parse + 라이브 read-only GET 재현. 전 인용 수치 실재·일치. **NO-GO 0.**

### CL-M1 재측정 증거 (전건 일치)
- **인용 소스 실재성:** `major_apparel_CLSTSHS.json`(1.73MB)·`major_apparel_CLTMSHS.json`(577KB)·`clstshs_price.json`(12.7KB) 3종 전부 실재. `apparel_info` 경로(`/rawProductData/result/product_data/apparel_info`) 6키(print_type/print_area/apparel_color/size_info/size_color_info/pantone_color) 정확.
- **CLSTSHS 카운트 전건 일치:** print_type=3(PTP_DTF/DIR/SLK USE_YN=Y)·print_area=6·apparel_color=54·size_info=7·size_color_info=227·pantone_color=1124 — **6/6 정확**. pdt_pcs_info=591(DIR_MTR 584+PDT_WRK 6+PAK_POL 1)·pdt_mtrl_info=584 정확.
- **MTRL_COD 인코딩 실재:** SXSRT103(S×블랙03)·SXSRT126(S×화이트26)·SXSRT226·SXSRT326 전부 size_color_info에 실재. print_area COD/KOI_NME(CL011/leftchest·CL001/front·CL009/leftsleeve·CL010/rightsleeve·CL004/neck·CL002/back) verbatim. size COD_NME(XS/S/M/L/XL/2XL/3XL) GBN=adult. apparel_color(26 화이트#FFFFFF DEFAULT=Y·03 블랙·65 애쉬) 정확.
- **가격 수치 실재:** clstshs_price.json — DIR_MTR PRICE=16200·PDT_WRK PRICE=3700·result_sum 19900 PCS_COD→PRICE 페어링 직접 확인. PRINT_TYPE PTP_DTF→PTP_DIR·MTRL_CD SXSRT226/326·CL011/SI014/SI030 실재.
- **CLTMSHS 차이 전건 일치:** color=6·size=9(adult 5+child 4: 120/130/140/150 GBN=child)·size_color=54·pantone=1124·MTRL prefix SXZSB(SXZSB103/SXZSB162)·pdt_pcs_info=62 정확.
- **CLAPDFT SSR 라이브 재현:** read-only GET HTTP 200·385KB(reverse 기록 일치)·`check_CLAPDFT`(레거시 jQuery)·`tmpl_price`(clothes2025 아님) 실재. paper select 8옵션(SXPWAX49/46/54/03·SXPSAX57/03·SXPGAX19/32 verbatim)·size 5옵션(disabled — "초기 비활성" 일치)·sodu 2옵션(data-type=4 단면·data-type=0 인쇄없음 정확)·paper_sub_select 1빈옵션(disabled)·name="print_area" radio·CL005 가슴 실재.
- **전수 추적성:** catalog category=CL=30·CL접두 30코드 누수 0·reverse §14 30코드 열거 catalog와 완전 일치.
- **unobserved 정직성(dodge-hunt):** unobserved/추정 마커 46건. §5 CLST 스펙트럼·§4 CLDFSHS·§6 CLDF는 옵션 VALUE를 전부 `unobserved`/`동형 추정`으로 표기 — 의류 일반지식(S/M/L)으로 미관측 상품 날조 0건. §5 oz 평량(4.01/10.0oz)은 catalog 상품명 유래(검증가능, 옵션 날조 아님).
- **variant #18 토대 실재:** 메타모델 판정 토대인 `clothes2025_item`/`clothes2025_price` item_gbn이 양 캡처에 실재(GS tmpl 아님) — distinct 축 가설 증거 진본.

### CL-M1 결함 (Low·판정 무영향)
- **D-CL-1 (Low) — CLTMSHS DIR_MTR 행수 라벨 정밀도.** `categories/CL/reverse.md:139` 축 라벨 `본체(브랜드 완제 SKU) # PCS_COD=DIR_MTR (62행)`에서 "62행"을 DIR_MTR에 귀속. 재측정: pdt_pcs_info **총 62행** = DIR_MTR **55** + PDT_WRK 6 + PAK_POL 1. 62는 전체 pcs_info 총수(line 143 note "pdt_pcs_info 62행"은 정확). DIR_MTR 단독은 55. 날조 아님(소스 실재·62는 실수치) — 라벨이 총수를 단일 PCS_COD에 귀속한 표기 부정확. **조치(선택):** `DIR_MTR (55행, pcs_info 총 62)`로 정정. 메타모델/갭 판정 무영향.

### CL-M2~M6 재측정 증거 (라이브 직접 SELECT + 캡처 파싱·전건 일치)
- **M2 (메타모델):** 17축 4문서 일관(discovered-axes:29·dictionary:16·erd:3,205·_resolved:503)·distinct 0·apparel_sku_matrix=MATERIAL enum facet(erd:108·신규 엔티티 0)·SIZE_PRESET↔MATERIAL 간선(erd:55) 모순 0.
- **M3 (★#18 부결):** size_color_info=227셀=227 distinct (size,color) pair·dup 0(캡처 python 파싱)·MTRL_COD=SXSRT+사이즈자리+색자리(SXSRT103/126/158)·라이브 option_items ref_key1 469/ref_key2 255/2키 동시 255 전부 .03자재·PRD_000071=33×4 매트릭스·HIDE_RSN 226blank+1"재고부족". 4 distinct 근거 깨기 4/4 실패.
- **M4 (갭):** option_items 469·ref_key2 255·ref_dim_cd .03=255/.04=156/.06=45/.01=11/.07=2(gap §XV-0 byte-exact)·PROC_000007~012 별색 family 실재·print_method/item_gbn/pricing_model/price_gbn 컬럼 전 테이블 0건·processes PK=(prd_cd,proc_cd) 위치컬럼 0·OPT_REF_DIM 7종(color 없음)·MAT_TYPE 14종(apparel 버킷 없음)·SEL_TYPE.01=123/.02=11.
- **M5 (그릇):** ref_key1/ref_key2 2D 페어링 라이브 활성 255행이 size×color 무손실 수용 실증·신규 V번호/테이블/컬럼 0(roadmap:12,74)·V-3 흡수=강화.
- **M6 (독립성):** deepcheck 13후보 채택 0(deepcheck:11,31,151)·H-2 REFUTED-for-RP 독립 재현(print_type=PTP_DTF/DIR/SLK 3종 닫힘·자수 0 hit)·codex #18 동의=robustness 기록(근거 아님·환각경계 HARD:8~11)·H-1/H-3 unverified 유지.

### CL-M2~M6 결함 (Low·판정 무영향)
- **D-CL-2 (Low) — gap §XV-2 "PASS측면" 표기 모호.** `03_gap/gap-matrix.md:474,482` size×color 2D matrix를 WEAK 판정하면서 본문에 "그릇 견딤(PASS측면)"을 병기. 라이브 재측 결과 2D 페어링 구조는 실제 그릇 보유(ref_key 255 활성)이고 결손은 자재 CLR 분해축/apparel 버킷이므로 *내용은 정확*하나, "PASS측면"이라는 표현이 한 facet의 최종 판정(WEAK)과 혼동될 수 있음. **조치(선택):** "구조 보유(✅)·분해축 결손(WEAK)"로 두 면을 분리 라벨. 판정값(WEAK) 자체는 정확·무영향.
- **D-CL-3 (Low·전역) — gap §III 전역 공정 카운트 드리프트.** `03_gap/gap-matrix.md:56`(추정 인용) `t_proc_processes` 96·`t_prd_product_processes` 196 기록이나 라이브 재측 = **97·270**(데이터 진화). **CL §XV 판정 무영향**(load-bearing 수치 option_items 469/255·ref_dim 분포·PROC_000007 family·print_method 0·PK는 전부 정확). 단 BN/GS 등 다른 섹션이 96/196 절대수를 인용하면 stale. **조치(선택·전역):** §III 공정 카운트를 97/270으로 갱신. CL 게이트 재게이트 불요.

> **CL M2~M6 종합: NO-GO 0.** 결함 D-CL-1/D-CL-2/D-CL-3 전부 Low·메타모델/갭/그릇 판정 무영향. **의류 variant #18 부결 = VALIDATED(역방향 오류 없음).** 라우팅: D-CL-1→reverse-engineer·D-CL-2/D-CL-3→gap-analyst(선택 정정·재게이트 불요).

---

## AC-M1 결함 (추출 충실성 — rpm-reverse-engineer) — 판정 GO (날조 0)

검증자 독립 재실측(캡처 직접 Read/grep, 2026-06-17). 대조 결과 **핵심 수치·코드·구조 전건 일치**. 단일 Low 1건.

### 재실측 일치 증거 (날조 0)
- **ACTHDKY 두께×소재 자재 6행** [`major_radius_ACTHDKY.json` pdt_mtrl_info] — PXAATD01/D02(3T/5T 투명)·PXAATL01~L04(라미·홀로그램 깨진유리/격자), WGT_CD=D01/D02/L01~04, GRP_OPTION_CD=MTG_DFT/MTG_LAM **전건 일치**.
- **고리 SUB_MTR** — SUB_MTRL_YN=Y 79행 실측: 카라비너고리(BN001)·열쇠고리 41(KR001~)·컬러구슬줄 22(CN)·컬러와이어링 15(CR). reverse "80+ KR/CN/CR" **일치**(79 SUB_MTR + 카라비너 ≈ 80, 라운딩 정직). STICKER_TYPE=FR·FRXXX·LAS_DFT 실재.
- **production_method**(MTG_DFT 일반/MTG_LAM 라미)·**print_data**(O 앞뒤같음/X 앞뒤다름) — option_info 리터럴 **일치**.
- **ACPDSTD 받침 12 SKU** [`major_acc_ACPDSTD.json`] — AB005~016(원형/타원/사각/육각×S/M/L), MTRL_CD=SXAPR005~016, ESN_YN=Y·QTY_INPUT_YN=Y·SUB_MTRL_YN=Y **전건 일치**. 본체 PXACR016 3T투명·edicus_item/tmpl_price 일치.
- **ACNTHAP** [`product_ACNTHAP.json`] — vDigital_item/vTmpl_price·RXIGC075(고투명 PET 리무버블 75g)·ACXXS 아크릴합지·DFXXX 레이저·NBPIN(SXANB001)/NBMGN(SXANB002) 뒷면자재·disable 3건(COT_DFT/MIS_DFT/SCO_DFT)·size 소70X25(WRK72X27 DFT=Y)/중75X25(WRK77X27) **전건 일치**.
- **qtysweep_ACNTHAP.json** — vTmpl_price·PRN_CNT·WRK_MTR/NBPIN ATTB·ORD_CNT_echo 실재(수량 가격 sweep 실재).
- **디자인 입력 플래그**(useKoiEditor/usePDF/price_table_yn/able_paper_yn) 3캡처 전건 일치.
- **catalog AC=20** — 20 pdtCode(ACNTHAP·ACPD*4·ACTH*13·ACTPKEY) 전부 category=AC·접두 누수 0. reverse 로스터(대표3+17)와 정확 일치. **전수 추적성 OK.**
- **A-8(GRP_OPTION_CD 가공방식 그룹핑)·A-4(SUB_MTR ST KR/CN/CR 코드 공유)** — 메타모델 판정 토대 근거 **캡처 실재 확인**.
- **`unobserved` 정직성** — 소재특화 키링(글리터/거울/자개/유색/렌티큘러/파스텔) 자재코드·코롯토 입체옵션을 전부 `[live:catalog]` unobs로 정직 표기. 아크릴 도메인 지식 날조 없음. `[live:SSR-negative]`(ACTHFCO Vue 정적카피) 정직.

### D-AC-1 (Low) — `PTT=AAT` 필드 표기 정밀도 [M1 → rpm-reverse-engineer]
- **위치:** `categories/AC/reverse.md:29-36`(§0.1 표 헤더 `PTT(소재)` 열·값 "AAT 투명아크릴")·`:151`(§2 `base_data_tag: 자재(소재 PTT=AAT ...)`).
- **결함:** 캡처(`major_radius_ACTHDKY.json` pdt_mtrl_info)에 **`PTT` 필드 부재**(grep 결과 `"PTT"` 0건). reverse는 PTT를 마치 자재행 필드처럼 표기하나, 실제로는 **MTRL_CD 접두(`PXAAT...`)에서 유도한 약어**(`AAT` 문자열은 코드 내 26회 출현·소재계열 추론). WGT_CD/MTRL_NM/GRP_OPTION_CD는 전부 리터럴 필드로 실재하나 PTT만 유도값.
- **심각도:** Low — **날조 아님**(AAT는 실제 MTRL_CD에 인코딩된 소재계열 식별자·"투명아크릴" 해석도 MTRL_NM "아크릴_3T 투명"과 정합). 단 리터럴 필드(WGT_CD 등)와 같은 표에 병기되어 *관측 필드처럼* 보일 소지. BN/ST의 PTT 표기 관행 계승으로 추정.
- **조치(선택):** PTT 열에 "(MTRL_CD 접두 유도)" 주석 또는 `PTT(유도)` 라벨. 메타모델 두께=자재 facet 판정(A-1)은 WGT_CD 리터럴이 근거이므로 **판정 무영향**.

> **AC M1 종합: GO.** 인용 캡처 4종 전부 실재·핵심 수치(두께6·고리79/80+·받침12·disable3·size2)·코드(D01/D02·KR/CN/CR·AB005~016·SXANB·SXAPR)·헤더(item_gbn/price_gbn 3종) **전건 캡처 일치·날조 0**. 전수 추적성(AC=20·누수0)·`unobserved`/`[live:SSR-negative]` 정직성 충족. 결함 D-AC-1 단 1건 Low(PTT 유도값 표기 정밀도·판정 무영향). 라우팅: D-AC-1→reverse-engineer(선택 정정·재게이트 불요).

### AC M2~M6 — 신규 결함 0 (Low 후속만)
- **M2/M3/M4/M5/M6 신규 결함 0건.** AC M2~M6 전건 GO. 라이브 재실측(railway read-only psql)·캡처 raw 직접 파싱으로 §XVII facet 6항(84/37행·컬럼 부재/존재)·A-8/D-13 부결(production_method=자재행 속성·layer 필드 0건)·신규 그릇 0(search-before-mint)·채택 0(deepcheck) 전건 재현·일치.
- **★A-8/D-13 역방향 오류 없음 VALIDATED** — distinct를 facet으로 숨긴 흔적 0(ST 형상#17 일관 기준·전용 슬롯+KB 결함 유무로 승격/부결 비대칭 정당). 적대 검정 4/4 깨기 실패. owning agent(metamodel-architect) 정정 불요.
- **잔여 = D-AC-1(Low·M1·reverse-engineer·PTT 유도값 표기 정밀도·판정 무영향) 단 1건**(위 AC M1 섹션). M2~M6 게이트는 추가 결함 없음.
- **dbmap 가격 트랙 위임 사항(vessel 범위 외·결함 아님):** Q-ACR-7(CLEAR3T prc_typ .02 엔진계산 미확정·라이브 84행 확증)·미러/코롯토/카라비너 공식 미신설은 `dbmap 31_acrylic` Q-ACR/GAP-CHAIN 범위(돈 크리티컬·인간 승인). rpmeta 그릇 결함 아님(frm_typ_cd는 기존 V-7).

---

## PD-M1 (추출 충실성) — rpm-reverse-engineer 신규 산출 독립 검증 [verdict: CONDITIONAL — 슬롯 귀속 결함 1건]

> 라이브 읽기전용 재실측 2026-06-17. PD는 재사용 캡처 0 → 라이브 GET이 유일 근거. 3 PD 페이지(PDCHSTL/PDWRSLP/PDSRPPY) HTTP 200·실 SSR 파싱으로 reverse.md 원자 전건 대조.

### 재실측 일치 증거 (대부분 전건 일치 — 날조 없음)
- **catalog 전수·누수 0:** `redprinting_catalog.json` 479상품 중 category=PD = **정확히 3건**(PDCHSTL 스툴·PDWRSLP 슬리퍼·PDSRPPY 강아지 계단). ACPD*/GSCAPD*/STBPDFT 등 PD 문자 포함 코드는 전부 AC/GS/ST로 올바르게 분류(접두 누수 0). reverse.md §5 "3상품 전수" 정확.
- **라이브 크기:** 392657/399344/369065 byte = reverse.md §1~3 헤더 "392KB/399KB/369KB" 정확.
- **paper(자재) verbatim 일치:** 면10수화이트 / 슬리퍼원단 / PU(폴리우레탄)-코끼리원단 — §0.2·§1~3 일치.
- **size verbatim 일치:** PDCHSTL 미니사각(292×292)·미니원형(305×305)·원형(305×305)·긴사각(580×290) / PDWRSLP 230~280mm 6프리셋 / PDSRPPY 2단(495×320)·3단(717×382) — §0.3·§1~3 전건 일치.
- **sodu=단면** 3상품 전부 — §0.4 일치.
- **PCS 슬롯 CHK 실재:** PDCHSTL `SEW_LTR_CHK+THO_CUT_CHK+SUB_MTR_CHK+six_clr` / PDWRSLP `PDT_WRK_CHK+THO_CUT_CHK+SUB_MTR_CHK`(SEW_LTR 없음) / PDSRPPY `SEW_LTR_CHK+THO_CUT_CHK+SUB_MTR_CHK+six_clr` — §0.5 슬롯 패턴(스툴/계단=SEW_LTR, 슬리퍼=PDT_WRK) 정확.
- **icon_txt 라벨:** 레더재봉/모양커팅/추가부자재(스툴·계단)·제품가공/모양커팅/추가부자재(슬리퍼) — §0.5 라벨 일치.
- **TIP "검정 밑창 1켤레씩 주문 가능":** 라이브 dd 실재("- 검정 밑창은 1켤레씩 주문 가능합니다 / - 화이트 밑창은 현재 주문이 불가하며 500켤레 이상…") — §2 note·§0.5 "검정=1켤레 가능 제약" 정직(추가로 화이트=현재 주문불가는 reverse 미기재).
- **number1/number2 2슬롯**(수량·건수 직접입력) 실재 — §0.6 일치.
- **unobserved 정직성:** THO_CUT_SUB_SELECT 상세 enum·SUB_MTR 상세·가격 infoCall 후행 = SSR 미노출 확인 → `unobserved` 표기 정직(날조 은폐 아님). 구조물 마케팅 카피(다리/솜/지퍼/논슬립)는 `[live:SSR-marketing]` non-axis로 옵션과 엄격 분리(라이브 detail 카피 실재).

### D-PD-1 (Medium) — 슬리퍼 밑창색(검정/흰색)을 `six_clr`에 오귀속 [M1 → rpm-reverse-engineer]
- **위치:** `categories/PD/reverse.md:74`(§0.5 표 `PDWRSLP | (six_clr→) 검정·흰색 | 밑창(sole) 색`)·`:166-171`(§2 `axis: 밑창색(six_clr→검정/흰색)` choices `[검정, 흰색]` base_data_tag `자재(본체색=밑창 sole)`).
- **재측정(라이브 SSR):** `six_clr`는 3상품 전부 **별색(spot-color) 체크박스**(`name="six_clr" id="six_clr" value="Y" onclick="productOrder.sixclr_check('','')"`) — 검정/흰색 값이 부착돼 있지 않음(별색 standard 슬롯, reverse §0.4·§1·§3에서 별색으로 올바르게 판정한 바로 그 필드). **검정/흰색 밑창색 variant는 실제로 `SUB_MTR(추가부자재) sub-radio`에 인코딩**: `opt_checked('SUB_MTR','SLB01'..'SLB06')`=검정색 슬리퍼 230~280mm(MTRL_COD `SBSLP230~280`)·`SLW01~06`=흰색 슬리퍼 230~280mm(MTRL_COD `SWSLP*`). 즉 PDWRSLP의 밑창색은 **SUB_MTR 슬롯의 밑창색×사이즈 12-variant 매트릭스**이며, `six_clr`(별색)와는 별개 슬롯.
- **결함 성격:** 값 날조 아님(검정/흰색·1켤레 TIP·밑창 sole 의미는 전부 실재) — **소스 슬롯 귀속이 틀림**(M1 "atom must match cited source"). `six_clr→검정/흰색`은 별색 체크박스에 부자재 매트릭스 값을 잘못 결선. 부작용 2건: ① reverse가 SUB_MTR을 별도 generic "추가부자재" 축(§2:188)으로도 나열해 밑창색이 **이중표상**(six_clr 1회 + SUB_MTR 1회)·SUB_MTR이 실은 밑창색 매트릭스를 *담고 있다*는 사실 누락. ② "자재(본체색=밑창)" 태그가 별색 슬롯에 붙어 메타모델 §4 "본체/밑창색 six_clr" 행(reverse §4:254)으로 전파 위험.
- **심각도:** Medium — 단일 슬롯 귀속 오류이나 메타모델 자재#1 본체색 family·SUB_MTR 부자재 BUNDLE 판정 토대를 흔들 수 있음(밑창색이 별색이냐 부자재냐). distinct #18 부결 핵심 판정(구조/조립/3D폼=facet)에는 **무영향**(밑창색 귀속과 독립).
- **조치:** §0.5·§2의 밑창색 축을 `six_clr` → `SUB_MTR_SUB_RADIO`(SLB*/SLW* 밑창색×사이즈 매트릭스)로 정정. six_clr은 PDWRSLP에서도 별색(spot-color)으로 통일 표기. §4 횡단표 "본체/밑창색 six_clr(PDWRSLP)" 행을 SUB_MTR 부자재 매트릭스로 재귀속. **재게이트 권장**(슬롯 귀속 정정 후 M2 자재#1 본체색 전파 재확인).

> **PD-M1 종합: CONDITIONAL.** catalog 전수(3·누수0)·paper/size/sodu/PCS슬롯/icon_txt/TIP/수량모델 **전건 라이브 verbatim 일치·날조 0**, unobserved/SSR-marketing 정직성 충족. 단 **D-PD-1(Medium·밑창색 six_clr 오귀속)** 1건 — 값은 실재하나 인용 소스 슬롯이 틀림(별색 체크박스 ≠ SUB_MTR 부자재 매트릭스). NO-GO는 아님(날조·부존재 인용 아닌 슬롯 결선 오류)이나 M2 본체색 전파 위험으로 CONDITIONAL 처리. 라우팅: D-PD-1→rpm-reverse-engineer(정정 후 재게이트).

### PD M2~M6 게이트 결과 (rpm-validator·2026-06-17·라이브 재실측) — 차단 결함 0건

> M1 재확인(D-PD-1 정정 정합) + M2~M6 전건 GO. 라이브 information_schema 직접 SELECT(railway·read-only)로 PD facet 5항·PD-4 data-gap·distinct 0 부결 검증. **신규 차단(High/Medium) 결함 0건.** 비차단 Low 1건만 기록.

### D-PD-2 (Low·비차단) — reverse 횡단표 SUB_MTR 밑창색에 `자재(본체색)` 태그 병기 [M1/M2 → rpm-reverse-engineer]
- **위치:** `categories/PD/reverse.md:74·77·176·260` — D-PD-1 정정 후 밑창색을 SUB_MTR sub-radio로 올바르게 재귀속했으나, base_data_tag에 `자재(본체색=밑창 sole)`를 병기(예: §4:260 `자재(본체색 합성) + SUB_MTR 부자재#8`).
- **재측정:** metamodel 전수 grep — 밑창색이 dictionary/discovered-axes/erd 어디에도 **자재 CLR(본체색)로 등재되지 않음**(부속물#8/자재 sub_mtrl variant로만 라우팅). 즉 reverse의 `본체색` 태그가 metamodel에 전파되지 않음(M2 토대 무영향).
- **성격:** 밑창=슬리퍼 본체에 결합되는 부자재(sole)의 색이므로 "본체색"이라는 표현이 자재 CLR(인쇄 본체색)과 혼동될 여지가 있는 라벨링 슬랙. _resolved-fragments PD-6(:651)이 이미 "부속물#8 vs 자재 sub_mtrl 최종 귀속은 reverse SUB_MTR 정정본 검증 후"로 명시 — 미세 경계 미확정 상태를 정직하게 보유.
- **심각도:** Low — 값·슬롯 귀속 정확(SUB_MTR·SLB*/SLW*·MTRL_COD SBSLP/SWSLP 실재)·distinct 0 불변·M2 자재 CLR 미전파(grep 0)이므로 비차단.
- **조치(선택):** reverse §0.2/§4 밑창색 태그를 `자재(본체색=밑창)` → `SUB_MTR 부자재 variant(밑창 sole 소재 색·자재 CLR 아님)`로 명확화. 또는 PD-6 미세 경계(부속물#8 vs 자재 sub_mtrl) 확정 시 일괄 정리. **재게이트 불요**(비차단).

> **PD M2~M6 종합: GO (전건).** 라이브 재실측 8검사 일치·PD-4 data-gap(addons PK·usage_cd .07=639 그릇 실재 직접 확인)·distinct 0 부결 검증·codex 17후보 채택 0. 차단 결함 0건·Low 1건(D-PD-2·비차단).
