# raw/webadmin 적재명세 (loadspec) — round-11

> **작성** 2026-06-10 · round-11. raw/webadmin Django `catalog` 소스에서 **각 t_* 가 무엇을 어떻게 적재하는가**를 코드 근거(file:line)로 추출. dbm-schema-analyst(라이브 DB DDL=런타임 사실)와 상보 — 본 문서는 **소스코드가 규정한 적재 방법**.
>
> **권위:** `raw/webadmin/webadmin/catalog/{models,admin,basecodes,cfg_utils,views}.py`. DB 미접속.
> **전 t_* 도메인 적재 컨벤션:** PK 자동채번 · 감사컬럼(`reg_dt`/`upd_dt`) 비입력 · 논리삭제(`del_yn`) · FK 코드그룹 제한.

---

## 1. 제너릭 적재 기계 — `BaseAdmin` (admin.py:134, 전 t_* 공통 1회)

전 t_* 모델은 `_make_admin`(admin.py:262)이 `BaseAdmin(UnfoldModelAdmin)`로 자동 등록. 모델별 재기술 불요 — 공통 동작:

| 적재 메커니즘 | 동작 | 근거 |
|---------------|------|------|
| **PK 자동채번** | `AUTO_SERIAL_TABLES` 모델은 PK 입력 선택(`required=False`), 저장 시 `PREFIX+max+1` 채번. placeholder "비우면 저장 시 자동 채번". 기초코드=상위코드.NN. 동시성 재시도 10회. `t_prd_templates`=`TMPL_000001` 폴백 | admin.py:163·178·196·203 |
| **감사컬럼 비입력** | `reg_dt`/`upd_dt`=`AUDIT` → `readonly_fields`. **`reg_dt` 파이썬 default=`timezone.now`**(managed=False라 NULL 전송 방지 — round-5 교훈 정합) | admin.py:283·258 |
| **YN 드롭다운** | `*_yn` 필드 → `forms.Select(Y/N)`. 신규 기본값 `YN_DEFAULTS`(없으면 N) 프리필 | admin.py:171·228 |
| **FK 코드그룹 제한** | `formfield_for_foreignkey`가 `basecode_queryset(name)`로 해당 코드그룹 멤버만 노출(§3). 자기참조 트리(`SELF_PARENT_TREES`)는 부모만+레벨 들여쓰기 | admin.py:136·152 |
| **disp_seq 자동** | 비었으면 형제(같은 상위) `max+1`(저장 시점·동시성 안전) | admin.py:187 |
| **list/search/filter** | list_display=앞 8컬럼 · search=`*_nm`/`*_cd`/note · filter=`use_yn`/`*_typ_cd` | admin.py:270·272·279 |

**필수 입력 도출 규칙:** `NOT NULL`(models) + no default + `readonly`/`exclude` 아님 = 필수. `reg_dt`/`upd_dt`/`del_dt` = 비입력(자동). PK = 비입력(채번).

---

## 2. 두 적재 surface

| Surface | 무엇 | 대상 t_* | 근거 |
|---------|------|----------|------|
| **A. 표준 admin changeform** | 모델 1개씩 직접 등록(전 필드) — 마스터 등록용 | `t_mat_materials`·`t_proc_processes`·`t_siz_sizes`·`t_cod_base_codes`·`t_prd_products`·`t_prc_*` 등 | `_make_admin` admin.py:262 |
| **B. 상품 인라인(상품뷰어)** | 상품 편집화면에서 하위 차원 CRUD(인라인 탭) | `t_prd_product_categories/sizes/print_options/plate_sizes/materials/processes` | `_make_inline` admin.py:298, `PRODUCT_INLINE_MODELS` admin.py:312 |
| (B 보강) views.py | 커스텀 상품뷰어 섹션/드릴다운 저장 | `section_edit`(566)·`_save_inline_items`(1101)·`_save_drilldown_row`(1156) | views.py |

> **함의:** 마스터(자재·공정·사이즈·코드)는 surface A로 **선적재**(FK 의존순), 상품 하위(상품별 자재/공정/사이즈)는 surface B로 **상품에 연결**. 적재 순서 = 마스터 A → 상품 t_prd_products A → 상품 하위 B (round-4 FK 위상정렬과 정합).

---

## 3. 코드값 적재 도메인 — `BASE_CODE_GROUP` (basecodes.py:7)

FK가 `t_cod_base_codes`를 가리키는 컬럼은 **해당 그룹 멤버만** 허용(`basecode_queryset`가 `cod_cd__startswith=GROUP+"."` 필터, basecodes.py:25). 매핑은 실제 허용 enum이 필요:

| 필드 | 코드그룹 | 용도(디지털인쇄 관련) |
|------|----------|----------------------|
| `prd_typ_cd` | PRD_TYPE | 상품유형(.04 디자인/.03 기성) |
| `usage_cd` | USAGE | 자재 용도(.01 본체/내지·.02 표지·.03 면지·.07 공통) |
| `mat_typ_cd` | MAT_TYPE | 자재유형(종이/소재/부속) |
| `sel_typ_cd` | SEL_TYPE | 선택유형(택1/택N) |
| `bdl_unit_typ_cd` | QTY_UNIT | 묶음단위(건/권/세트) |
| `qty_unit_typ_cd` | QTY_UNIT | 수량단위(건수 등) |
| `output_paper_typ_cd` | OUTPUT_PAPER_TYPE | 출력용지유형(전지 규격) |
| `comp_typ_cd` | PRC_COMPONENT_TYPE | 가격 구성요소유형 |
| `frm_typ_cd` | FRM_TYPE | 가격공식유형 |
| `ref_dim_cd` | OPT_REF_DIM | CPQ 옵션 polymorphic 참조(L2) |
| `dsc_typ_cd` | DSC_TYPE | 할인유형 |
| `grade_cd` | CUS_GRADE | 고객등급 |
| `semi_role_cd` | SEMI_ROLE | 반제품역할(낱장=미사용) |
| `rule_typ_cd` | RULE_TYPE | 룰유형 |
| `frm_typ_cd`·`comp_typ_cd` | (가격) | round-2 영역 |

> 14 코드그룹. 컬럼이 위 목록에 없으면 일반 FK(마스터 직접). `output_file_typ`(plate)은 코드 아닌 CharField(자유 텍스트).

---

## 4. 디지털인쇄 관련 t_* 적재명세 (엔티티별)

> 필수=●(NOT NULL+no default+입력), 자동=▲(채번/감사/default), 옵션=○. 적재 surface A=마스터 changeform / B=상품 인라인.

### t_prd_products (상품정보, surface A) — models.py:444
| 컬럼 | 타입 | 필수 | 적재 | 코드그룹 | 비고 |
|------|------|:--:|------|---------|------|
| prd_cd | char PK | ▲ | 자동채번 PREFIX+max+1 | — | 비입력(placeholder) |
| mes_item_cd | char unique | ○ | 입력(원형 대문자) | — | NULL 가능 |
| prd_nm | char | ● | 입력 | — | 멱등 키 |
| prd_typ_cd | FK | ● | 드롭다운(PRD_TYPE) | PRD_TYPE | .04/.03 |
| nonspec_yn / nonspec_*_min/max | char/dec | ●/○ | YN 드롭다운/입력 | — | 비규격(낱장=N) |
| file_upload_yn / editor_yn | char | ● | YN 드롭다운 | — | C14/C15 |
| min_qty/max_qty/qty_incr/dflt_qty | int | ○ | 입력 | — | C27~29 |
| constraint_json | json | ○ | JSON 입력 | — | 조건부 캐스케이드(180g 코팅) |
| qty_unit_typ_cd | FK | ○ | 드롭다운(QTY_UNIT) | QTY_UNIT | C26 건수 |
| reg_dt/upd_dt | ts | ▲ | 자동(default now/트리거) | — | readonly |

### t_siz_sizes (사이즈정보, surface A) — models.py:492
siz_cd(▲채번) · siz_nm(●) · work_width/height(작업=C8) · cut_width/height(재단=C5/C9) · margin_top/bot/lft/rgt(여백·블리드 도출) · impos_yn(조판판형여부=출력판형 표시) · use_yn(●) · del_yn(▲). **재단≠작업 2슬롯 한 행에 공존.**

### t_prd_product_sizes (상품별사이즈, surface B) — models.py:427
복합 PK(prd_cd+siz_cd) · dflt_yn · disp_seq · del_yn. 상품↔사이즈 연결만(치수는 t_siz_sizes).

### t_prd_product_plate_sizes (상품별판형, surface B) — models.py:317
복합 PK(prd_cd+siz_cd) · dflt_plt_yn · **output_paper_typ_cd**(OUTPUT_PAPER_TYPE=C10 출력용지규격) · **output_file_typ**(C12 PDF/AI, 자유텍스트). 출력판형 적재.

### t_mat_materials (자재정보, surface A) — models.py:126
mat_cd(▲) · mat_nm(●=종이명+평량) · mat_typ_cd(MAT_TYPE) · upr_mat_cd(자기참조 트리) · sel_typ_cd(SEL_TYPE) · max_sel_cnt · width/height/depth(두께)/weight · bdl_qty · use_yn · del_yn.

### t_prd_product_materials (상품별자재, surface B) — models.py:283
복합 PK(prd_cd+mat_cd+**usage_cd**) · **dep_proc_cd**(종속공정=자재→코팅 게이팅) · dflt_yn · del_yn. **자재 권위 위치(parent+usage_cd).**

### t_prd_product_print_options (상품별인쇄옵션, surface B) — models.py:366
복합 PK(prd_cd+opt_id) · **print_side**(C17 단/양면) · front_colrcnt_cd/back_colrcnt_cd(→t_clr_color_counts 도수) · dflt_yn · del_yn. unique(prd_cd+print_side+front+back). **별색은 여기 아님(process).**

### t_proc_processes (공정정보, surface A) — models.py:473
proc_cd(▲) · proc_nm(●) · upr_proc_cd(자기참조 트리=공정 family) · **prcs_dtl_opt**(JSON=줄수/형상/단수/박색/음각양각 param) · use_yn · del_yn.

### t_prd_product_processes (상품별공정, surface B) — models.py:391
복합 PK(prd_cd+proc_cd) · mand_proc_yn(필수공정여부) · disp_seq · del_yn. 별색·코팅·커팅·접지·박·형압·오시·미싱·가변 모두 여기로 연결.

### t_prd_product_bundle_qtys (상품별묶음수, surface B) — models.py:234
복합 PK(prd_cd+bdl_qty) · bdl_unit_typ_cd(QTY_UNIT) · dflt_yn · del_yn. (디지털인쇄 낱장=건수 단위, 묶음은 봉투50장 등에서).

### t_prd_product_addons (상품별추가상품, surface B) — models.py:218
복합 PK(prd_cd+**tmpl_cd**) · disp_seq · note. **addon=tmpl_cd PK 전환됨**(구 addon_cd DROP, Phase7). 봉투류 → `t_prd_templates`(SKU).

### t_prd_product_page_rules (상품별페이지룰) — models.py:302
prd_cd PK(1:1) · page_min/max/incr. **디지털인쇄 낱장=무관(0행 정상)** — 책자/노트 전용.

### t_prd_product_price_formulas + t_prc_price_formulas (가격) — models.py:336·203
복합 PK(prd_cd+frm_cd) ↔ 공식. **round-2(dbm-price-formula) 영역** — C40 가격공식.

---

## 5. 적재 GAP (소스에 컬럼 부재 — 견적 DB 밖 가능)

| 엑셀 컬럼 | 귀속처 부재 | 처리 |
|-----------|-------------|------|
| C11 파일명약어 | t_* 컬럼 없음 | 생산 메타 → note 또는 GAP(견적 밖). dbm-ddl-proposer 검토 |
| C13 폴더 | t_* 컬럼 없음 | 생산 라우팅 → note 또는 견적 밖 |
| C6 판수 | (의도적 부재) | 앱 런타임 계산(메모리 `compute-in-app-db-stores-lookup`) — GAP 아님 |
| C37 박칼라 | prcs_dtl_opt vs 자재 미정 | 박색 귀속(공정 param vs 포일 자재) 컨펌 — `domain-research-notes` |

> **불일치(discrepancy) 없음:** 소스 models.py와 본 분석은 정합. 라이브 DB 실제 행은 dbm-schema-analyst/validator가 별도 확인(본 문서는 코드 권위만).

---

# 스티커 적재명세 delta (round-11 확대 #1 · 2026-06-10)

> §1~3(제너릭 `BaseAdmin` 기계·두 적재 surface·`BASE_CODE_GROUP` 14)은 **전 시트 공유** — 재기술 안 함. 스티커가 디지털인쇄 대비 **새로 활성화하는 적재 경로의 delta만** 기록.

## S1. 스티커가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 스티커 delta | 적재 surface | 근거 |
|-----------|--------------|:--:|------|
| **t_proc_processes** (커팅) | PROC_000053 완칼{`모양` string} · PROC_000054 반칼{`모양` string, `조각수` int} · PROC_000055 스티커완칼{`조각수` int≥1} → `prcs_dtl_opt` JSON에 모양·조각수 param. 디지털인쇄는 코팅/별색 위주, 스티커는 **커팅 공정이 주축** | A(마스터) | models.py:473 `prcs_dtl_opt` · db-domain-structure-live §165-167 |
| **t_prd_product_processes** (커팅 연결) | 반칼/완칼/스티커완칼 + 화이트별색을 상품에 연결. `mand_proc_yn`=커팅은 필수공정(스티커 정체) | B(상품인라인) | models.py:391 |
| **t_mat_materials** (점착지) | `mat_typ_cd`=**MAT_TYPE.11 스티커**(디지털인쇄=종이.01). 무광/유광코팅스티커=별 mat_cd(코팅 자재 흡수). 데드롱=합판 전용 | A | models.py:126 · MAT_TYPE.11 |
| **t_prd_product_bundle_qtys** (조각수) | `bdl_qty`=조각수(*최대20·5~10·*1조각), `bdl_unit_typ_cd`=QTY_UNIT(조각 단위). 디지털인쇄 낱장은 0행이었으나 **스티커는 조각수로 활성** | B | models.py:234 |
| **t_prd_product_print_options** | `print_side`=**단면 단일**(양면 없음), back_colrcnt=0 | B | models.py:366 |
| **t_prd_product_plate_sizes** | `output_file_typ`=PDF/PDF(W)/AI(칼선)/JPG(전사) 자유텍스트. **PDF(W)=화이트별색·AI(칼선)=커팅 동반** | B | models.py:317 |

## S2. 스티커 미사용 t_* (디지털인쇄와 차이 — 적재 안 함)

| t_* | 사유 |
|-----|------|
| `t_prd_product_processes`(접지/오시/미싱/박/형압/가변) | 스티커 후가공 미사용(C29~30·박/형압 컬럼 부재·빈값) |
| `t_prd_product_addons` | 스티커 추가상품 없음(C31~32 빈값) |
| `t_proc_processes`(코팅 family) | **코팅=자재 흡수**(무광/유광코팅스티커 mat_cd) — C23 빈값 |
| `t_prc_price_formulas`(C40 가격공식) | 스티커 시트 가격공식 컬럼 부재 → 가격표(`06_extract/price-gangpan-sticker`)·round-2 별도 |

## S3. 적재 surface별 코드값 도메인 (스티커 활성 enum)

| 필드 | 코드그룹 | 스티커 허용값(엑셀 도출) |
|------|----------|--------------------------|
| `mat_typ_cd` | MAT_TYPE | .11 스티커(점착지) |
| `usage_cd` | USAGE | .01 본체(낱장 점착물) |
| `output_paper_typ_cd` | OUTPUT_PAPER_TYPE | 330x470·210x297·297x420·420x594·400x600(6) |
| `bdl_unit_typ_cd`·`qty_unit_typ_cd` | QTY_UNIT | 조각/장(조각수 단위) — 라이브 코드값 확인 대상(CONFIRM-ST-2) |
| `prd_typ_cd` | PRD_TYPE | .04 디자인/.03 기성 |

## S4. 스티커 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드(models.py) | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| **합판도무송 형상** | `prcs_dtl_opt.모양`(공정 param 자리 있음) | C24 커팅 빈값·형상 37종이 `t_siz_sizes`로 흡수(정사각NxN(EA)) | **discrepancy = CONFIRM-ST-1**(형상 size 흡수). dbm-validator/schema-analyst가 라이브 실제 행 확인 후 해소. round-10 escalate와 동일 대상 |
| 조각수 적재 위치 | bundle_qty + prcs_dtl_opt 둘 다 자리 있음 | C25 조각수 일부 상품만 | CONFIRM-ST-2(이중 vs 택1) |

> **불일치 처리 원칙(스킬 HARD):** 코드와 라이브 스키마가 어긋나 보이면 추측으로 메우지 않고 discrepancy로 기록 → validator/schema-analyst가 라이브 실측으로 해소. 본 delta는 코드 권위 + 엑셀 현실 대조까지만.

---

# 책자 적재명세 delta (round-11 확대 #2 · 2026-06-10)

> §1~3(제너릭 `BaseAdmin`·두 적재 surface·`BASE_CODE_GROUP`)은 전 시트 공유 — 재기술 안 함. 책자가 디지털인쇄/스티커 대비 **새로 활성화하는 적재 경로의 delta만**. 책자는 **반제품(B 셋트)·page_rule·제본 택일** 때문에 가장 많은 t_* 경로를 쓴다.

## B1. 책자가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 책자 delta | 적재 surface | 근거 |
|-----------|------------|:--:|------|
| **t_prd_product_page_rules** | `page_min`/`page_max`/`page_incr`(C15~17). 디지털인쇄/스티커는 0행이었으나 **책자 내지에서 처음 활성**. 제본별 차등(중철 4~28/4배수·무선 24~300·트윈링 8~100·떡제본 무관) | B(상품인라인) | models.py:302 `t_prd_product_page_rules` |
| **t_prd_product_processes**(제본) | PROC_000017 제본 자식 7종(중철/무선/PUR/트윈링/하드커버무선/하드커버트윈링/떡) + `mand_proc_yn=Y`(제본 필수). prcs_dtl_opt=방향(좌철/상철)·책등(mm)·묶음단위·고리형 | B | models.py:391·473 |
| **t_prd_process_excl_groups** | **GRP-BOOK-제본 택일그룹**(SEL_TYPE.01 단일, 헤더+멤버 FK). 디지털/스티커 미사용. 제본은 택1 | B | db-structure §219·entity-semantic §26 |
| **t_prd_product_materials**(usage 분리) | **3 usage 슬롯**: USAGE.01 내지(C13)·USAGE.02 표지(C24)·USAGE.03 면지(C33). 디지털/스티커는 본체(.01)만. B 셋트라도 자재 권위=parent+usage_cd | B | models.py:283 `usage_cd`·USAGE |
| **t_prd_products**(반제품) | B 셋트 표지=`prd_typ_cd`=**PRD_TYPE.02 반제품** sub_prd 빈 껍데기 선생성 후 sets 연결. 하드커버/레더만 | A | PRD_TYPE.02·entity-semantic §119 |
| **t_prd_product_bundle_qtys**(권) | 떡제본 `bdl_qty`=50/100장1권, `bdl_unit_typ_cd`=QTY_UNIT.03 권(C36). 스티커는 조각 단위였음 | B | models.py:234·QTY_UNIT.03 |
| **t_prd_product_print_options**(내지/표지 별도) | 내지 print_side(C14)·표지 print_side(C25) 별 행. 양면(내지)+단면(하드 표지) | B | models.py:366 |
| **t_proc_processes**(표지 공정) | 코팅(C26)·투명커버 부착(C27)·박/형압(C28)·포장 수축(C42) — usage=표지로 연결 | A→B | models.py:473 |

## B2. 책자 미사용/희소 t_*

| t_* | 사유 |
|-----|------|
| `t_proc_processes`(별색인쇄 PROC_000007) | 책자=별색 없음(C 별색 컬럼 부재). db-structure §308 "별색인쇄 적재 0" 정합 |
| `t_proc_processes`(커팅 PROC_53/54/55) | 책자=반칼/완칼 없음(제본물). 스티커 전용 |
| `t_prd_product_addons` | 책자 추가상품 없음 |
| `t_prc_price_formulas`(C 가격공식) | 책자 시트 가격 컬럼 부재 → 가격표/round-2 별도 |

## B3. 적재 surface별 코드값 도메인 (책자 활성 enum)

| 필드 | 코드그룹 | 책자 허용값(엑셀 도출) |
|------|----------|------------------------|
| `usage_cd` | USAGE | .01 내지·.02 표지·.03 면지·.05 투명커버 |
| `prd_typ_cd` | PRD_TYPE | .01 완제품(A 통합)·.02 반제품(B 셋트 표지 sub_prd)·.04 디자인 |
| `mat_typ_cd` | MAT_TYPE | 종이(내지/표지)·.06 가죽(레더)·부속(D링/트윈링) |
| `bdl_unit_typ_cd` | QTY_UNIT | .03 권(떡제본 50/100장1권) |
| `sel_typ_cd` | SEL_TYPE | .01 단일(GRP-BOOK-제본 택1) |
| `semi_role_cd` | SEMI_ROLE | .02 표지·.03 면지(B 셋트 sub_prd 역할) |

## B4. 책자 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드(models.py) | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| 레더 링바인더 제본 | PROC_000017 제본 family 자리 있음 | C31 제본 빈값(바인더링만) | CONFIRM-BK-2(바인더가 제본인가) |
| 링/D링 귀속 | 자재(부속) + prcs_dtl_opt(책등) 둘 다 자리 | C34/C35 링컬러·D링 mm | CONFIRM-BK-3(자재 vs param) |
| B 셋트 sub_prd 분해 | sets/sub_prd 자리 있음 | A 통합은 표지도 parent 적재 | CONFIRM-BK-5(분해 범위) |

> **불일치 처리 원칙(스킬 HARD):** 코드와 라이브 스키마가 어긋나 보이면 추측으로 메우지 않고 discrepancy로 기록 → validator/schema-analyst가 라이브 실측으로 해소. 본 delta는 코드 권위 + 엑셀 현실 대조까지만.
