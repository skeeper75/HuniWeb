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
