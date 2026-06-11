# 캘린더 + 디자인캘린더 — 정답 추출규칙 (round-13 C2)

> **작성** round-13 Phase 2a. 각 상품 × 속성축에 대해 **엑셀 원본(L1)에서 어떻게 추출·변환해 어느 t_*.컬럼에 넣어야 정확한지**를 확정. 라이브 실제 적재(loadlogic-notes)와 나란히 둔다(실제 vs 정답).
> **권위:** ① 엑셀 L1(`calendar-l1.csv`·`design-calendar-l1.csv`) ② 스키마 의도(`schema-design-intent-map.md` OM·삼중바인딩) ③ 도메인(round-11 product-bom·round-12 mapping-final·실무진 확정 Q12/Q13/Q14). 빈칸 0.
> **표기:** 목표 t_* = 정답 귀속. "라이브 실제" = 현 적재 상태. 충돌 시 oracle이 정답(라이브=피고).

---

## A. 5 속성축 × 5 form factor (정답 추출규칙)

### 축 1 — size (사이즈/작업/재단)

| 상품 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 탁상(108) | E `사이즈(필수)` 220x145·130x220 / G 작업 224x149 / H 재단 220x145 | distinct 재단치수→siz_cd, 상품별 다수행. work=작업·cut=재단 | `t_prd_product_sizes`(siz_cd)→`t_siz_sizes.work_*/cut_*` | schema-intent §2.1(siz=치수만) | SIZ_000069/070(2종) | ✅ |
| 미니(109) | 90x100·148x60 | 동일 | `t_prd_product_sizes` | 동일 | SIZ_000018/071(2종) | ✅ |
| 엽서(110) | 145x145~145x300·130x220·220x145·220x130·148x210(6종) | 동일·6 variant | `t_prd_product_sizes` | 동일 | 6종(SIZ_000007/069/070/072/073/074) | ✅ |
| 벽걸이(111) | 210x297·210x420·300x420 | 동일·3 variant | `t_prd_product_sizes` | 동일 | 3종(SIZ_000050/075/076) | ✅ |
| 와이드(112) | 300x625(3절) | 동일·1 variant | `t_prd_product_sizes` | 동일 | 1종(SIZ_000077) | ✅ |

> **블리드(C6=2mm)·작업사이즈(C7)·재단사이즈(C8):** Q14 확정=자동 도출(작업−재단). 별 컬럼 불요. `t_siz_sizes.work_*`(작업)·`cut_*`(재단)·margin(도출)에 흡수. ✅

### 축 2 — 자재 (종이 본체 + 부속 거치/제본)

| 상품 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 탁상(108) | O `종이사양`=`*별도설정`(IMPORT 포인터) | 본체 종이 자재→`t_prd_product_materials`(usage=본체 슬롯), `*별도설정`=종이군 IMPORT | `t_prd_product_materials`+`t_mat_materials`(MAT_TYPE.01 종이) | schema-intent §3 #3(자재=parent+usage) | 종이 다수 usage=USAGE.07 | 🟡(usage 공통) |
| **(부속) 삼각대** | (디자인캘린더 R `삼각대컬러`=삼각대(그레이)·삼각대(블랙)) | **거치 공정**(삼각대 거치)→`t_prd_product_processes` + 삼각대컬러=공정 param. **자재 아님** | `t_prd_product_processes`(삼각대 거치 PROC) + param | **schema-intent §3 #6(후가공=공정)·bom.md §1**·Q5 | **MAT_000252/254 자재(MAT_TYPE.07) 오적재** | ❌ |
| **(부속) 링** | 벽걸이 캘린더가공=고리형트윈링제본·U `링칼라`=블랙 | **트윈링 제본 공정**→`t_prd_product_processes`(PROC_000021) + 링칼라=공정 param. **자재 아님** | `t_prd_product_processes`(PROC_000021) + 링칼라 param | schema-intent §3 #7(제본=공정)·bom.md §4 | **MAT_000253 링 블랙 자재(MAT_TYPE.07) + PROC_000021 공정 이중** | ❌(자재행) |
| 와이드(112) | O `종이사양`=스노우지250/몽블랑190/240 (3절) | 3절 본체 종이 직접명→자재 | `t_prd_product_materials`(MAT_TYPE.01) | bom.md §5 | MAT_000093/111/112(3절 종이)+링 | 🟡(usage 공통·링 자재) |

> **자재 usage 슬롯 정답:** 캘린더=낱장 단품 → 본체 종이는 **단일 본체 슬롯**(USAGE.01 내지 또는 USAGE.07 공통 중 택1). 라이브=전부 USAGE.07 공통. round-12가 "USAGE.07이 정답"이라 했으나(낱장=본체 단일이므로 .07 공통도 수용 가능), **삼각대/링까지 같은 USAGE.07 공통에 dflt_yn=Y로 묶은 것은 부속을 본체 슬롯에 평면화** = 오적재(삼각대/링은 자재 자체가 아님).

### 축 3 — 공정 (캘린더가공 = 거치/제본/타공/포장)

| 상품 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 탁상(108) | S `캘린더가공`=*별도설정·R 삼각대(그레이)·Y 수축포장 | 삼각대 거치 공정 + (수축)포장 공정 | `t_prd_product_processes`(삼각대거치·PROC_000076 수축포장) | bom.md §1·schema-intent §3 #6 | **PROC_000076 수축포장만**(삼각대 거치 공정 없음·삼각대=자재) | ❌(거치 공정 누락) |
| 미니(109) | 삼각대(블랙)·수축포장 | 동일 | `t_prd_product_processes` | bom.md §2 | **PROC_000076 수축포장만** | ❌(거치 누락) |
| 엽서(110) | S 가공없음(재단만)·우드거치대·1구타공+끈 | 택일: 재단만/우드거치/타공+끈. 타공=PROC_000079·구수 param | `t_prd_product_processes`(PROC_000079 타공) + 택일그룹(option_groups) | bom.md §3·Q5 | **PROC_000079 타공 1행**(택일그룹·우드거치 미모델) | 🟡(택일/우드 미적재) |
| 벽걸이(111) | S 고리형트윈링제본·2구타공+끈·가공없음 | 택일: 트윈링제본(PROC_000021)+링칼라 / 타공(PROC_000079) / 재단만 | `t_prd_product_processes`(021+079) + 택일그룹 | bom.md §4·schema-intent §3 #7 | **PROC_000021+079**(2공정·택일그룹 0·둘 다 mand=N) | 🟡(택일그룹 미적재) |
| 와이드(112) | S 고리형트윈링제본·제본없음 | 택일: 트윈링제본(021)+링칼라 / 재단만 | `t_prd_product_processes`(021) + 택일그룹 | bom.md §5 | **PROC_000021 트윈링제본 1행** | 🟡(택일그룹 미적재) |

> **캘린더가공 택일그룹(C19) 정답:** 6멤버(가공없음·우드거치대·1구타공+끈·2구타공+끈·고리형트윈링제본·제본없음) → **`t_prd_product_option_groups`(GRP-CAL-가공·SEL_TYPE.01 단일·mand_yn=Y)** 로 흡수(excl_groups 테이블 부재). schema-intent §2.4(option_groups=excl 흡수처)·round-12 §A C19. 라이브 option_groups 0 = 미적재.
> **삼각대컬러(C18)·링칼라(C21) 정답:** 공정 param(`prcs_dtl_opt` 또는 ref_param_json). 링칼라=★고리형트윈링제본 선택시만(constraint_json 캐스케이드). 평면화 금지.

### 축 4 — 도수 (인쇄면 + color count)

| 상품 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 탁상(108) | P `인쇄`=양면 | print_side 자유텍스트·앞/뒷면 4도(CMYK) | `t_prd_product_print_options`(print_side·front/back_colrcnt=CLR_000005) | schema-intent §2.2(도수=print_options) | print_side=양면·CLR_000005/005 | ✅ |
| 엽서(110) | 단면 | print_side=단면·앞=4도·뒤=0도(인쇄안함) | `t_prd_product_print_options`(CLR_000005/CLR_000001) | 동일 | 단면·CLR_000005/001 | ✅ |
| 벽걸이(111) | 단면(13장)/양면(8P~) | 2 옵션(단면·양면) | `t_prd_product_print_options`(2행) | 동일 | 2행(단면·양면) | ✅ |
| 와이드(112) | 단면/양면 | 2 옵션 | `t_prd_product_print_options`(2행) | 동일 | 2행 | ✅ |

> **별색 없음:** 캘린더는 별색(화이트/금/은) 컬럼 없음 → 별색=공정 이슈(OM-5) 무관. 도수 깨끗. ✅

### 축 5 — 인쇄옵션 (출력판형 + 주문 surface)

| 상품 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 탁상/미니/엽서/벽걸이 | I `출력용지규격`=316x467(국전계열) | 316x467→판형 siz_cd + output_paper_typ=**.01 국전계열**(국전 원지 계열) | `t_prd_product_plate_sizes`(siz_cd·output_paper_typ_cd) | schema-intent §3 #2(판형=출력용지규격)·도메인(국전 절수) | SIZ_000499·**.01 국전계열** | ✅(값)·F-1(경로) |
| 와이드(112) | 330x660(3절·기타 계열) | 304x629→판형 siz_cd + output_paper_typ=**.03 기타** | `t_prd_product_plate_sizes` | 동일 | SIZ_000292·**.03 기타** | ✅(값)·F-1(경로) |
| 전 상품 | M `업로드`=Y / (디자인)N `편집기`=Y | 주문채널→file_upload_yn·editor_yn | `t_prd_products.file_upload_yn/editor_yn` | round-12 §A C13/C14 | 업로드 Y·편집기 N(캘린더 surface) | 🟡(디자인 surface editor_yn 미반영) |

> **출력판형 값은 정답(국4절=국전계열·3절=기타)이나, F-1: 현 load_master 코드는 .01을 재현 못함**(전부 .03). 값 유지·경로 결함 별도(loadlogic F-1).

---

## B. 캘린더 고유축 (장수 · 가공 추가가격)

### 고유축 1 — 장수 (낱장 매수) [★Q12·핵심]

| 상품 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 탁상(108) | Q `장수`=`4(8P)/8(16P)/12(24P)/16(32P)` | 낱장 매수→**고객 선택 옵션 + 가격공식**. **page_rule 아님·bundle 아님** | `t_prd_product_option_groups`/options/items(장수 옵션) + 가격엔진 | **Q12 확정**·schema-intent §2.3(낱장에 page_rule ✗) | **page_rule 0·option 0**(완전 미적재) | ❌(MISSING) |
| 엽서(110) | 12/13/14/15/16 | 동일·낱장 매수 옵션 | CPQ option | Q12 | 미적재 | ❌ |
| 벽걸이(111) | 4~13(단면)·4(8P)~(양면) | 동일 | CPQ option | Q12 | 미적재 | ❌ |
| 와이드(112) | 4~13 | 동일 | CPQ option | Q12 | 미적재 | ❌ |
| **(디자인)** | B3 페이지사양=30P/26P/12P/13P (고정) | **고정 페이지**(디자인 확정)→고정값(variant 아님) | 고정 페이지 속성(option 단일값 또는 메타) | mapping-final §B B3 | 미적재 | ❌ |

> **장수 정답 못박음:** Q12 = "고객 선택 옵션 + 가격 계산공식". 장수는 page_rule(책자 내지)도 bundle(떡제본 권)도 아닌 **캘린더 고유 옵션축**. 라이브 어디에도 적재 안 됨(page_rules 0·option 0) = MISSING. **기계적으로 page_rule에 넣지 말 것**(schema-intent OM 정합).

### 고유축 2 — 가공 추가가격 (C20) + 추가상품 (C26/C27)

| 항목 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|---------------|----------------|----------|-------------|-------------|:--:|
| 가공 추가가격 | T `추가가격`=0/1000/1500/2000/4000 | 가공별 옵션 추가가(우드4000·트윈링2000·타공1000/1500) | 옵션 가격(L2·round-6) | round-12 §A C20·Q12 | 미적재(option 0) | ❌(MISSING) |
| 캘린더봉투 addon | Z `추가상품`=캘린더봉투(★사이즈선택) | 별 SKU(PRD_000005)→addon 연결·★사이즈종속 캐스케이드 | `t_prd_product_addons`(tmpl_cd) + `t_prd_templates` | round-12 §A C26·schema-intent §3 #8 | **addons 0행**(캘린더봉투 template 부재) | ❌(MISSING) |
| 우드거치대 | Z 추가상품=우드거치대(엽서·디자인) | **자재**(Q13: 가공컬럼에 있으나 자재) | `t_prd_product_materials`(우드거치대 자재) | **Q13 확정**·schema-intent §4.3.1 | 미적재 | ❌(MISSING) |
| 봉투 추가가격 | (디자인)AA=2400/2500 | 봉투 SKU 가격 | template price(`t_prd_template_prices`·Phase11 신설) | mapping-final §B·round-14 | 미적재 | ❌ |

---

## C. 디자인캘린더 surface — 차이 컬럼 (가격포함판)

| 항목 | 엑셀 출처(design-l1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 | 라이브 실제 | 정합 |
|------|----------------------|----------------|----------|-------------|-------------|:--:|
| 주문 surface | T `편집기`=Y | editor_yn=Y(같은 prd_cd) | `t_prd_products.editor_yn` | mapping-final §B B1·Q6 | **editor_yn=N**(캘린더 surface만 반영) | ❌(MISMATCH) |
| **가격(B6)** | `가격`=10400/9700/6500/4000/9900/24000 | **고정가형 직접단가**(사이즈/페이지별) | `t_prd_product_prices`(prd_cd·apply_ymd·price) | **★Q15**·mapping-final §B.1·schema-intent §3.1(고정가형) | **prices 0행**(전역) | ❌(MISSING) |
| 종이사양(B) | `몽블랑 190g`(명시·`*별도설정` 아님) | **명시 종이명**→자재 직접 매핑(디자인=확정 종이) | `t_prd_product_materials` | design-l1 R3(몽블랑190g 명시) | (캘린더 surface는 `*별도설정`) | 🟡(surface별 종이 확정도 다름) |
| 페이지(B3) | 30P/26P/12P/13P(고정) | 고정 페이지(variant 아님) | 고정 속성 | mapping-final §B B3 | 미적재 | ❌ |

> **디자인캘린더 핵심:** 같은 5상품(PRD_000108~112)의 surface다. **별 상품 mint 금지.** 차이=① editor_yn=Y(라이브 N=미반영) ② 고정가(prices 0=미적재) ③ 종이 명시(`몽블랑190g`, 캘린더판 `*별도설정`보다 확정도 높음). **디자인캘린더 종이명 명시는 캘린더판 `*별도설정` IMPORT 결함의 정답 소스**가 될 수 있음(같은 상품).

---

## K1 게이트 자기점검 (커버리지)

- family 전 6상품(5 form factor + 디자인 surface) × 5 속성축(size·자재·공정·도수·인쇄옵션) + 고유축 2(장수·가공/추가상품) = **전 셀 존재**, N/A는 사유 명기(별색 N/A=캘린더 별색 컬럼 없음).
- 각 정답값 oracle 근거(엑셀 L1 셀·Q번호·schema-intent §) 인용 실재.
- 정합 ❌(오적재/MISSING) 셀이 correction-manifest로 환원.
