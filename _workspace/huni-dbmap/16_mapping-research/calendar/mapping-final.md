# 캘린더 + 디자인캘린더(가격포함) — 매핑 확정 (round-12)

> **작성** 2026-06-10 · round-12 매핑 확정 리서치(`dbm-mapping-research` P1~P4). 설명 한국어, 식별자/컬럼/코드값/SQL 영어.
>
> **대상:** 상품마스터 `캘린더` 시트(20행·5 form factor) + `디자인캘린더(가격포함)` 시트(10행·같은 5 form factor). 둘 다 round-11 calendar family.
>
> **권위 순서(HARD):** ① 실무진 확정 Q1~Q15(★5건) ② 후니 PDF/table-spec/configurator-design ③ **라이브 DB 실측**(읽기전용·`live-crosscheck.md`) ④ webadmin loadspec ⑤ round-11 산출/07_domain ⑥ 외부(보조).
>
> **확정도:** ✅ 4소스 일치·라이브 검증 · 🟡 도출 일치하나 라이브 미적재/부분 · 🔴 미확정(컨펌 질문 동반). **빈칸 0.**
>
> **★ round-11 초안을 이긴 실무진 확정:** Q1(파일메타 견적제외)·Q5(부속 시트별 귀속)·Q12(장수=고객옵션+공식)·Q13(우드거치대=자재). round-11의 CONFIRM-CL-1~6 중 **CL-1·CL-2·CL-3·CL-6은 실무진/라이브로 해소**, 잔존은 §6.

---

## 0. 라이브 실측 선결 사실 (live-crosscheck.md 요약 — 매핑의 우변 권위)

| 사실 | 실측 | 매핑 함의 |
|------|------|-----------|
| **5 form factor 라이브 적재됨** | PRD_000108(탁상)·109(미니)·110(엽서)·111(벽걸이)·112(와이드), **전부 PRD_TYPE.04 디자인상품** | round-11 "form factor 5상품" 확정. **디자인캘린더=별 상품 아님**(같은 prd_cd, CL-1 해소) |
| **MES_ITEM_CD 라이브 NULL** | 5상품 전부 `MES_ITEM_CD IS NULL` (엑셀=007-0001~5) | C3 = **업데이트 대상**(엑셀값으로 채움) |
| **종이=USAGE.07(공통)** | 벽걸이 materials 23행 전부 `usage_cd=USAGE.07` | ★ round-11 "USAGE.01 본체" 인용 **오류** → 정정: 캘린더 종이=**USAGE.07 공통** |
| **OUTPUT_PAPER_TYPE=계열코드** | .01=국전계열·.02=46계열·.03=기타 (치수 아님). 캘린더 plate=.01, 와이드=.03 | ★ round-11 "316x467/330x660" 코드값 인용 **오류** → 정정: 코드는 **계열**, 치수는 별도 |
| **page_rules=0·prices=0·formulas=0·option_*=0·addons=0** | 5상품 전부 | 장수·가격·CPQ·봉투/거치대 = **미적재(적재 대상)** |
| **봉투=별 상품 PRD_000005**(PRD_TYPE.03 기성상품) | 캘린더봉투 독립 상품 존재, 단 캘린더 5상품에 addon 연결 0행 | C26 봉투 = `t_prd_product_addons`+`t_prd_templates`로 연결(미적재) |
| **링칼라 조건부 = 엑셀 명시** | C21 값 `★고리형트윈링제본선택시만 : 링칼라선택` | constraint_json 캐스케이드(라이브 constraint_json 컬럼 존재) |

> **D-1 교훈(변형 커버리지):** 엽서캘린더 라이브 sizes 6종 적재 확인 — 단 `SIZ_000007=148x210`이 엑셀 distinct(145x145~145x300·130x220)와 1종 차이. 변형 정합은 round-4 적재 audit에서 셀단위 대조 필요(본 round=매핑 확정까지).

---

# A. 캘린더 시트 (업로드판 · 20행 · 30 의미 컬럼)

> L1 컬럼 30개(`구분`~`디자인보유`) 전수. 트레일링 빈 컬럼(`0`,`AF`~`AL`)은 데이터 0 → §A.99 제외 사유.

| # | 엑셀 컬럼 | 의미축(round-11) | 목표 t_*.컬럼 | 변환 규칙 | 코드값/FK | 라이브 실측 | 권위 | 확정 | 비고 |
|---|----------|------------------|---------------|-----------|-----------|-------------|------|:--:|------|
| 1 | 구분 | 상품군 분류 | `t_prd_product_categories.cat_cd` | form factor 그룹→cat_cd 매핑 | CAT_000112/114/115(FK `t_cat_categories`) | **적재됨**(5상품 각 1행) | 라이브·round-11 col-dict L35 | ✅ | 탁상/엽서/벽걸이 그룹 |
| 2 | ID | 외부 식별자 | (보조키 — 미적재) | prd_cd 아님. 무시 또는 note | — | (라이브 컬럼 없음) | round-11 L36 | 🟡 | **prd_cd 오인 금지.** 견적 무관 |
| 3 | MES ITEM_CD | MES 품목코드 | `t_prd_products."MES_ITEM_CD"` | 엑셀 007-0001~5 그대로 | — | **NULL(미적재)** → 업데이트 대상 | 라이브·loadspec | ✅ | 라이브 NULL → 엑셀값 채움. 대문자 컬럼명 |
| 4 | 상품명 | **상품정체(form factor)** | `t_prd_products.prd_nm` | 멱등 키(prd_nm) | PRD_000108~112 | **적재됨** | 라이브·round-11 L38 | ✅ | form factor=정체(5상품) |
| 5 | 사이즈(필수) | 재단치수 variant | `t_siz_sizes.cut_*` + `t_prd_product_sizes` | "220 x 145 mm"→siz_cd, 상품별 다수 | SIZ_000069/070/072~074 등(FK) | **적재됨**(엽서6·탁상2·벽걸이3·와이드1) | 라이브·round-11 L46 | ✅ | 엑셀 distinct↔라이브 1종 차이(SIZ_000007) audit |
| 6 | 파일사양_블리드 | 재단여유(도련) | `t_siz_sizes` work−cut 도출 | 2mm. 별도 칸 불요 | — | (전용 컬럼 없음) | **Q14 확정**(작업/재단 도출) | ✅ | Q14: 별도 관리 불요 |
| 7 | 파일사양_작업사이즈 | 작업치수 | `t_siz_sizes.work_*` | "224 x 149"→work 치수 | (siz_cd 종속) | 적재됨(sizes 일부) | round-11 L55 | ✅ | — |
| 8 | 파일사양_재단사이즈 | 재단치수 | `t_siz_sizes.cut_*` | "220 x 145"→cut 치수. C5 정합 | (siz_cd) | 적재됨 | round-11 L56 | ✅ | C5와 동일 치수 |
| 9 | 파일사양_출력용지규격 | **출력판형**(전지) | `t_prd_product_plate_sizes.output_paper_typ_cd` | **316x467→.01 국전계열·330x660→.03 기타** | OUTPUT_PAPER_TYPE.01/.03 | **적재됨**(탁상/벽걸이=.01·와이드=.03) | **라이브 정정**·loadspec L282 | ✅ | ★코드=계열(치수 아님). hidden 컬럼 |
| 10 | 파일사양_파일명약어 | 생산메타 | **견적 제외**(미적재) | 탁상달력 등 → MES만 | — | (미적재) | **Q1 확정**(견적 제외) | ✅ | ★CL-6 해소: Q1 견적제외 |
| 11 | 파일사양_출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ` | "PDF" 자유텍스트 | — | (plate_sizes 적재 시 동반) | loadspec L90 | 🟡 | 자유텍스트 |
| 12 | 파일사양_폴더 | 인쇄방식 라우팅 | (견적 미저장 — 공정 root 도출) | "디지털인쇄" → 캘린더=디지털 일관 | — | (전용 컬럼 없음) | round-11 L60 | 🟡 | 인쇄방식 일관(디지털). MES 라우팅 |
| 13 | 주문방법_업로드 | 주문채널 | `t_prd_products.file_upload_yn` | "Y"→Y | — | **라이브 확인 필요**(미실측) | 라이브·round-11 L68 | 🟡 | 캘린더(업로드)=Y |
| 14 | 주문방법_편집기 | 주문채널 | `t_prd_products.editor_yn` | 캘린더=빈/디자인캘린더=Y | — | (디자인캘린더 §B에서 Y) | round-11 L69 | 🟡 | 2 surface 구분축 |
| 15 | 종이사양 | **자재** | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.07 공통**) | `*별도설정`→IMPORT 포인터·3절=직접명 | USAGE.07(FK `t_cod_base_codes`) | **적재됨**(usage=USAGE.07 실측) | **라이브 정정**·round-11 L77 | ✅ | ★usage=.07 공통(round-11 .01 오류). `*별도설정` IMPORT 결함(benchmark B1) |
| 16 | 인쇄(필수) | **인쇄면 도수** | `t_prd_product_print_options.print_side` | "양면"/"단면" 자유텍스트 | — | **적재됨**(탁상="양면") | 라이브·round-11 L78 | ✅ | print_side 자유텍스트(코드 아님) |
| 17 | 장수(필수) | **장수(낱장 매수)** | **CPQ option + 가격공식**(`t_prd_product_options`/`option_items` + 가격엔진) | `4(8P)/8(16P)`→옵션 항목. page_rule 아님 | (OPT_REF_DIM·미적재) | **page_rules=0**(정상)·option_*=0(미적재) | **★Q12 확정**·schema-intent L461 | 🟡 | ★CL-3 해소: 고객 선택 옵션+가격공식. page_rule 단정 금지 |
| 18 | 캘린더가공_삼각대컬러 | **공정 param**(삼각대) | `t_prd_product_processes.prcs_dtl_opt`(삼각대컬러) | 삼각대(그레이/블랙)→param | (process FK) | (process 적재됨·param 미상) | **Q5 보류**·round-11 L89 | 🟡 | ★Q5: 시트별 옵션 확인 후 귀속. 탁상 전용 |
| 19 | 캘린더가공_캘린더가공 | **공정+택일그룹** | `t_prd_product_processes`(proc_cd) + **`t_prd_product_option_groups`(GRP-CAL-가공 흡수)** | 6멤버→택1 옵션그룹 + 공정행 | PROC_000021(트윈링)·079(타공)·삼각대거치·SEL_TYPE.01 | **processes 적재됨**(벽걸이=PROC_000021+079)·option_groups=0(미적재) | **라이브**·loadspec L279·schema-intent L366 | ✅ | ★excl_groups 테이블 부재 → **option_groups로 흡수**(SEL_TYPE.01) |
| 20 | 캘린더가공_추가가격 | **옵션 추가가격** | `t_prd_product_options`/option price(L2) | 0·1000·1500·2000·4000→옵션가 | — | (option_*=0 미적재) | round-11 L91·Q12 | 🟡 | 가공별 추가가(우드4000·트윈링2000). round-6 L2 |
| 21 | 캘린더가공_링칼라 | **공정 param**(조건부) | `prcs_dtl_opt`(링칼라) + `t_prd_products.constraint_json` | "블랙"·★조건부 캐스케이드 | (constraint_json) | (constraint_json 컬럼 존재) | 라이브·엑셀 명시·round-11 L92 | 🟡 | ★트윈링 선택시만(엑셀 `★고리형트윈링제본선택시만`). 평면화 금지 |
| 22 | 제작수량_최소 | 수량하한 | `t_prd_products.min_qty` | 1→1 | — | **적재됨** | 라이브·round-11 L100 | ✅ | — |
| 23 | 제작수량_최대 | 수량상한 | `t_prd_products.max_qty` | 10000→10000 | — | **적재됨** | 라이브 | ✅ | — |
| 24 | 제작수량_증가 | 수량step | `t_prd_products.qty_incr` | 1→1 | — | **적재됨** | 라이브 | ✅ | qty_unit_typ_cd=QTY_UNIT.01(EA) 실측 |
| 25 | 개별포장(옵션) | **공정**(포장) | `t_prd_product_processes`(포장/수축) | 수축포장/개별포장없음→공정 옵션 | (process FK) | (미실측) | round-11 L103 | 🟡 | 포장 공정 옵션 |
| 26 | 추가상품_추가상품 | **추가상품**(addon) | `t_prd_product_addons`(tmpl_cd) + `t_prd_templates` | 캘린더봉투(★사이즈선택)·우드거치대 | TMPL(봉투=PRD_000005 별 상품) | **addons=0(미적재)** | 라이브·round-11 L104 | ✅ | ★봉투=사이즈종속 캐스케이드. **우드거치대=자재(Q13)** — §A.1 분기 |
| 27 | 추가상품_추가가격 | 추가상품 가격 | template price(L2) | 2400/2500→addon 가격 | — | (미적재) | round-11 L105·Q15 | 🟡 | 봉투 추가가. round-6 L2 |
| 28 | 가이드파일 | 생산메타 | **견적 제외**(미적재) | AI/PSD → note | — | (미적재) | **Q1 확정**(생산메타 견적제외) | ✅ | ★Q1 일괄: 생산 파일 표기 견적제외 |
| 29 | 템플릿 | 디자인 메타 | `t_prd_templates`(에디터 템플릿 연계) | 값/빈 → 디자인 보유시 템플릿 | — | **templates 0행**(미적재) | round-11 L114·Q6 | 🟡 | 디자인보유와 교차. Q6 에디터 템플릿 |
| 30 | 디자인보유 | 디자인 제공 | `t_prd_products.prd_typ_cd`(=PRD_TYPE.04) | ●→PRD_TYPE.04 디자인상품 | PRD_TYPE.04 | **적재됨**(5상품 전부 .04) | **라이브 확정**·Q6 | ✅ | ★●=디자인 제공 → 라이브 이미 .04. CL-1 정합 |

## A.1 우드거치대 귀속 — ★Q13 확정 반영 (round-11 CL-2 철회)

| 항목 | round-11 초안 | **★Q13 확정** | 매핑 |
|------|---------------|----------------|------|
| 우드거치대 | C19 가공(OPTION) vs C26 추가상품(TEMPLATE) 분기(C-4) | **자재**(캘린더가공 컬럼에 있으나 실제 귀속=자재) | `t_mat_materials`(우드거치대 자재) + `t_prd_product_materials`(usage=부속/거치, 본체와 별 슬롯) |

> ★ Q13가 round-11 CL-2(OPTION vs TEMPLATE 분기)를 **철회**. 우드거치대는 엑셀상 캘린더가공(C19)·추가상품(C26 디자인캘린더) 양쪽에 나타나지만 **자재로 단일 귀속**. C19/C26의 "우드거치대" 텍스트는 자재 선택을 가리키는 표면 표기. Q5 원칙("컬럼 옵션 확인 후 귀속")과 정합 — 삼각대/트윈링은 공정 param(거치/제본 색), 우드거치대는 자재.

## A.99 제외 컬럼 (사유 명기)

| 컬럼 | 제외 사유 |
|------|-----------|
| `_anchor_ffilled`·`_row_hidden`·`_work_size_col`·`_work_size_value`·`row_seq`·`sheet`·`prd_nm`(파서 메타) | L1 파서 산출 구조 컬럼(엑셀 원본 컬럼 아님) |
| `0`·`AF`·`AG`·`AH`·`AI`·`AJ`·`AK`·`AL` | 트레일링 빈 컬럼 — 전 20행 데이터 0(엑셀 빈 열). `cell_meta_json`=셀 메타 |

---

# B. 디자인캘린더(가격포함) 시트 (10행 · 같은 5 form factor)

> **CL-1 해소(라이브):** 디자인캘린더는 별 상품이 **아니다** — 캘린더 5상품(PRD_000108~112)과 **같은 prd_cd**. 라이브가 이미 5상품 전부 PRD_TYPE.04(디자인)로 적재 → Q6(A: 1상품+에디터 디자인 템플릿) 정합. 디자인캘린더 시트 = 같은 상품의 **에디터·가격포함 surface**.
>
> 캘린더(§A)와 **공유 컬럼은 §A 매핑 동일** — 아래는 **차이 컬럼만**. 공유 컬럼(구분·ID·MES·상품명·사이즈·파일사양·종이사양·수량·개별포장·추가상품·가이드파일·템플릿·디자인보유)은 §A 행 그대로 적용.

| # | 엑셀 컬럼 | 의미축 | 목표 t_*.컬럼 | 변환 규칙 | 코드값/FK | 라이브 실측 | 권위 | 확정 | 비고 |
|---|----------|--------|---------------|-----------|-----------|-------------|------|:--:|------|
| B1 | 주문방법_편집기 | 주문채널 | `t_prd_products.editor_yn` | "Y"→Y | — | (라이브 확인 필요) | round-11 §9·Q6 | 🟡 | 디자인캘린더=편집기 surface |
| B2 | 인쇄사양 | 인쇄면 도수 | `t_prd_product_print_options.print_side` | "양면"/"단면" | — | 적재됨(공유) | round-11 §9 | ✅ | =C16(컬럼명만 다름) |
| B3 | **페이지사양** | **고정 페이지**(디자인 확정) | CPQ option 또는 고정값 | 12P/13P/26P/30P→고정(variant 아님) | — | page_rules=0 | round-11 §9·Q12 | 🟡 | ★디자인 확정=고정 페이지(캘린더 장수=multi와 대비). 장수와 동일 축(Q12) |
| B4 | 캘린더사양_캘린더가공 | 공정+택일 | `t_prd_product_processes` + `t_prd_product_option_groups` | 삼각대(그레이/블랙)·고리형트윈링제본 | PROC·SEL_TYPE.01 | processes 적재됨 | round-11 §9·loadspec | ✅ | ★삼각대가 가공 컬럼에 통합(캘린더는 삼각대 별도 C18). 같은 공정 |
| B5 | 캘린더사양_링칼라 | 공정 param(조건부) | `prcs_dtl_opt`(링칼라)+constraint_json | "블랙" | (constraint_json) | constraint_json 존재 | round-11 §9 | 🟡 | =C21. 트윈링 조건부 |
| B6 | **가격** | **가격 base(고정가)** | `t_prd_product_prices`(고정가) | 4000~24000→가격행. 사이즈·표지·페이지별 | (가격 차원 FK) | **prices=0(미적재)** | **★Q15 확정**·round-11 §9 | 🟡 | ★고정가형(캘린더=공식엔진과 대비). Q15: 사이즈/페이지별 기본가 |

## B.1 디자인캘린더 차이 — 가격 모델 (★Q15)

| 축 | 캘린더(§A) | 디자인캘린더(§B) | 매핑 함의 |
|----|-----------|-------------------|-----------|
| **주문 surface** | file_upload_yn=Y | editor_yn=Y | 같은 prd_cd 두 채널(CL-1 해소) |
| **장수/페이지** | C17 장수=multi `4(8P)/8(16P)`(고객옵션·Q12) | B3 페이지=고정 `30P/26P/12P/13P`(디자인 확정) | 디자인캘린더=확정 페이지(에디터 디자인 고정) |
| **가격** | 없음(별도 — 디지털인쇄 가격엔진 트랙) | **B6 가격=고정가 4000~24000** | ★캘린더=원자합산형 공식엔진 / 디자인캘린더=**고정가 직접**(`t_prd_product_prices`). Q15 |
| **캘린더가공** | C18~C21(4컬럼: 삼각대·가공·추가가격·링칼라) | B4~B5(2컬럼: 가공·링칼라) | 디자인 확정으로 가공 간소화 |
| **추가상품** | 봉투(★사이즈선택) | 봉투 + **우드거치대(4000)** | 우드거치대=자재(Q13). 봉투=addon |

## B.99 디자인캘린더 제외 컬럼

| 컬럼 | 제외 사유 |
|------|-----------|
| `AD`·`AE`·`AF`·`AG`·`AH`·`AI`·`AJ` + 파서 메타(`sheet`·`row_seq`·`prd_nm`·`_anchor_ffilled` 등) | 트레일링 빈 컬럼(데이터 0) + L1 파서 구조 컬럼 |

---

# C. 가격 모델 — 두 시트의 차이 (메모리 권위)

| 시트 | 가격 모델 | t_* | 근거 |
|------|-----------|-----|------|
| **캘린더(업로드)** | **원자합산형 공식엔진**(디지털인쇄 가격엔진 트랙) | `t_prc_*` 4단 + `t_prd_product_price_formulas` | [[dbmap-digitalprint-atomic-formula-unbuilt]]. 캘린더는 디지털인쇄 분류(폴더=디지털인쇄) |
| **디자인캘린더(가격포함)** | **고정가형 직접** | `t_prd_product_prices`(고정가 4000~24000) | ★Q15 확정. 디자인 확정 → 사이즈/페이지별 기본가 |

> **캘린더 가격 차단 확인:** 라이브 `t_prd_product_price_formulas`·`t_prc_*` 캘린더 5상품 **0행** — 디지털인쇄 가격엔진 트랙(2026-06-07)의 잔존 차단(3절/투명/박/048)과 별개로, **캘린더는 아직 가격엔진 미연결**. 캘린더 가격 적재는 디지털인쇄 가격엔진 공식(PRF_DGP_A~F)을 form factor에 바인딩하는 별도 작업(round-2/가격 트랙·인간 승인).

---

# D. FK 위상정렬 적재순서 (round-4 입력 — 미적재 우변)

```
1. 마스터(선적재·대부분 존재):
   t_cod_base_codes(USAGE.07·SEL_TYPE.01·OUTPUT_PAPER_TYPE.01/.03·PRD_TYPE.04·QTY_UNIT.01) [존재]
   → t_siz_sizes(form factor 재단/작업) [존재] → t_mat_materials(*별도설정·3절·우드거치대[신규]·삼각대·트윈링) [부분]
   → t_proc_processes(삼각대거치·트윈링제본 PROC_000021·타공 PROC_000079·포장) [존재]
2. 상품(존재 — 업데이트):
   t_prd_products PRD_000108~112 — MES_ITEM_CD 채움(NULL→007-0001~5)·editor_yn(디자인캘린더)
3. 상품 하위(부분 적재):
   sizes[존재]·materials[존재 USAGE.07]·print_options[존재]·plate_sizes[존재]·processes[존재]·categories[존재]
   → addons(봉투 tmpl_cd·미적재)
4. CPQ L2(미적재 — round-6):
   option_groups(GRP-CAL-가공 흡수·SEL_TYPE.01) → options → option_items
   → 장수 옵션(Q12)·링칼라 조건부 constraint_json·봉투 ★사이즈선택
5. 가격(미적재):
   캘린더=가격엔진 공식 / 디자인캘린더=t_prd_product_prices 고정가(Q15)
```

> **채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`)(round-9 D1~D5). 우드거치대 자재 신규 = search-before-mint(기존 MAT 재사용 우선).
