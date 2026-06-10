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

---

# 포토북 적재명세 delta (round-11 확대 #3 · 2026-06-10)

> §1~3(제너릭 `BaseAdmin`·두 적재 surface·`BASE_CODE_GROUP`)은 전 시트 공유 — 재기술 안 함. 포토북이 책자 대비 **새로 활성화하는 적재 경로의 delta만**. 포토북은 책자類(반제품·page_rule·usage 3슬롯)이나 **PUR 단일(excl_group 불요) + 가격포함(t_prc_* 활성)**이 핵심 차이.

## P1. 포토북이 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 포토북 delta | 적재 surface | 근거 |
|-----------|--------------|:--:|------|
| **t_prd_product_prices / t_prc_*** | **가격포함 시트** — C37 기본(24P) base + C38 추가(2P)당 per-page. 디지털인쇄(원자합산)·스티커·책자는 가격 컬럼 부재였으나 **포토북은 가격 내장**. round-2(`dbm-price-formula`) 고정가 base + 증분 component(PRF_PHOTOBOOK) | A | models.py:336·203 · round-2 |
| **t_prd_products**(반제품) | 표지타입(C18) 하드/레더하드=`prd_typ_cd`=PRD_TYPE.02 반제품 sub_prd + sets. 소프트=종이표지(A 통합 근접) | A | PRD_TYPE.02·entity-semantic §2/§4 |
| **t_prd_product_page_rules** | 내지 page_min/max/incr(C15~17, 24~150·증가2). 책자처럼 활성. **증가2=가격 추가(2P)당 정합** | B | models.py:302 |
| **t_prd_product_processes**(PUR 제본) | PROC_000017 자식 **PUR 단일** + mand=Y. **excl_group 불요**(책자 GRP-BOOK-제본 택일과 차이 — 포토북=PUR만) | B | models.py:391 |
| **t_prd_product_materials**(3 usage) | USAGE.01 내지(몽블랑130)·.02 표지(아트250/레더)·.03 면지(그레이). 책자와 동일 3슬롯 | B | models.py:283·USAGE |
| **t_prd_products**(에디터) | `editor_yn`=Y(C35, 에디터 중심)·디자인명=디자인 템플릿(PRD_TYPE.04 디자인·디자인보유) | A | models.py:444 |

## P2. 포토북 미사용/희소 t_*

| t_* | 사유 |
|-----|------|
| `t_prd_process_excl_groups` | **포토북=PUR 단일**(택일 불요). 책자 GRP-BOOK-제본과 차이 |
| `t_proc_processes`(별색·커팅) | 포토북=별색/커팅 없음(제본물) |
| `t_prd_product_addons` | 포토북 추가상품 없음(C 부재) |
| `t_prd_product_bundle_qtys` | 포토북=권/조각 묶음 없음(page_rule로 페이지) |

## P3. 적재 surface별 코드값 도메인 (포토북 활성 enum)

| 필드 | 코드그룹 | 포토북 허용값(엑셀 도출) |
|------|----------|--------------------------|
| `usage_cd` | USAGE | .01 내지·.02 표지·.03 면지 |
| `prd_typ_cd` | PRD_TYPE | .02 반제품(하드/레더 표지 sub_prd)·.04 디자인(에디터) |
| `mat_typ_cd` | MAT_TYPE | 종이(몽블랑130·아트250)·.06 가죽(레더) |
| `frm_typ_cd`·`comp_typ_cd` | (가격) | 고정가 base + per-page 증분(round-2) |

## P4. 포토북 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드(models.py) | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| 레이플랫 vs PUR | PROC_000017 family(PUR·레이플랫 둘 다 자리) | C28 PUR 전 variant·레이플랫 적재0 | CONFIRM-PB-2(C-10 1순위·미운영 가설) |
| 표지타입 sub_prd 분해 | sets/sub_prd 자리 있음 | 하드/레더=반제품·소프트=종이표지 | CONFIRM-PB-1(소프트 분해 범위) |
| 가격 내장 | t_prc_*·product_prices 자리 | C37/38 base+per-page | CONFIRM-PB-4(round-2 고정가+증분) |

---

# 캘린더 적재명세 delta (round-11 확대 #4 · 2026-06-10)

> §1~3 공유 — 재기술 안 함. 캘린더가 포토북/책자 대비 **새로 활성화하는 적재 경로의 delta만**. 캘린더는 **낱장(내지/표지·page_rule 없음) + GRP-CAL-가공 택일 + addon 첫 활성 + 장수 GAP**이 핵심 차이.

## CL1. 캘린더가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 캘린더 delta | 적재 surface | 근거 |
|-----------|--------------|:--:|------|
| **t_prd_process_excl_groups** | **GRP-CAL-가공 택일그룹**(SEL_TYPE.01 단일). 캘린더가공(C19) 6멤버(가공없음·우드거치대·타공·트윈링제본·제본없음). 책자=GRP-BOOK-제본, 캘린더=**GRP-CAL-가공**(별 그룹) | B | db-structure GRP-CAL-가공·entity-semantic §1 #5 |
| **t_prd_product_addons** | **첫 활성**(스티커/책자/포토북 미사용). C26 캘린더봉투(★사이즈선택)·우드거치대 → `tmpl_cd` PK + `t_prd_templates`(SKU). ★사이즈선택=constraint 캐스케이드 | B | models.py:218 addon→tmpl 전환 |
| **t_prd_product_processes**(거치/제본/타공) | 삼각대거치(C18 그레이/블랙)·고리형트윈링제본(C21 링칼라)·타공(1구/2구)+끈. prcs_dtl_opt=삼각대컬러·링칼라·구수 | A→B | models.py:391·473 |
| **t_prd_product_plate_sizes**(출력판형) | output_paper_typ_cd=316x467·**330x660(와이드 3절)**. 출력판형≠재단 | B | models.py:317·OUTPUT_PAPER_TYPE |
| **장수(C17)** | **GAP — 미확정**. page_rule(min/max/incr) vs variant 선택옵션 vs 가격차원. 라이브 page_rule 0행(G-CL-5). CONFIRM-CL-3 | — | entity-semantic §2 |
| **가공/추가상품 추가가격(C20/C27)** | round-6 옵션 가격(가공별 우드4000·트윈링2000·봉투2400) | (round-6) | round-6 L2 |
| **t_prd_products**(2 surface) | 캘린더=file_upload_yn=Y·디자인캘린더=editor_yn=Y·가격포함·PRD_TYPE.04 디자인 | A | models.py:444 |

## CL2. 캘린더 미사용 t_* (낱장 — 책자/포토북과 차이)

| t_* | 사유 |
|-----|------|
| `t_prd_product_page_rules` | **캘린더=낱장(내지 없음)** — page_rule 무관(장수는 별 축, GAP). 책자/포토북과 정반대 |
| `t_prd_product_materials`(.02 표지/.03 면지) | 캘린더=낱장 usage.01 본체만(내지/표지/면지 없음) |
| `t_prd_products`(반제품 sub_prd) | 캘린더=C 완제품/단일(반제품 없음) |
| `t_proc_processes`(별색·커팅·박/형압) | 캘린더 후가공 없음 |

## CL3. 적재 surface별 코드값 도메인 (캘린더 활성 enum)

| 필드 | 코드그룹 | 캘린더 허용값(엑셀 도출) |
|------|----------|--------------------------|
| `usage_cd` | USAGE | .01 본체(낱장) |
| `sel_typ_cd` | SEL_TYPE | .01 단일(GRP-CAL-가공 택1) |
| `output_paper_typ_cd` | OUTPUT_PAPER_TYPE | 316x467·330x660(와이드) |
| `prd_typ_cd` | PRD_TYPE | .04 디자인(디자인캘린더)·.01 완제품 |
| `bdl_unit_typ_cd`·`qty_unit_typ_cd` | QTY_UNIT | 장수 단위(장) — 라이브 코드값 확인 대상(CL-3) |

## CL4. 캘린더 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드(models.py) | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| 장수(낱장 매수) | page_rule 자리(책자용) | C17 4(8P)/8(16P)·page_rule 0행 | CONFIRM-CL-3(G-CL-5 — page_rule vs variant vs 가격) |
| 우드거치대 | 가공 process + addon tmpl 둘 다 자리 | C19 가공·C26 추가상품 양쪽 | CONFIRM-CL-2(OPTION vs TEMPLATE·C-4) |
| 디자인캘린더 | 같은 prd_cd + PRD_TYPE.04 둘 다 가능 | 같은 MES 007-0001~5·가격포함 | CONFIRM-CL-1(별 상품 vs surface) |

> **불일치 처리 원칙(스킬 HARD):** 코드와 라이브 스키마가 어긋나 보이면 추측으로 메우지 않고 discrepancy로 기록 → validator/schema-analyst가 라이브 실측으로 해소. 본 delta는 코드 권위 + 엑셀 현실 대조까지만.

---

# 실사 적재명세 delta (round-11 확대 #5 · 2026-06-10)

> §1~3 공유 — 재기술 안 함. 실사가 앞 시트 대비 **새로 활성화하는 적재 경로의 delta만**. 실사는 **면적형 사이즈(규격+비규격+자유) + 소재=상품정체 + 실사 후가공(D-24/b.9) + 화이트 별색 + 가격은 포스터사인 매트릭스(분석 제외)**가 핵심 차이.
>
> **⚠️ [HARD·사용자] 가격 5컬럼(R/S/V/X/Z) 분석 제외** — 적재명세도 가격 경로는 다루지 않음(round-2 포스터사인 면적매트릭스 트랙).

## SL1. 실사가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 실사 delta | 적재 surface | 근거 |
|-----------|-----------|:--:|------|
| **t_mat_materials**(실사소재 다종) | **소재=상품정체.** MAT_TYPE.08 실사소재(인화지·매트지·PET·PVC·투명PET/PVC) + .05 원단(그래픽천·린넨·캔버스·현수막천·타이벡·메쉬) + .06 가죽(레더) | A→B | models.py:126·db-structure §191 |
| **t_prd_product_processes**(실사 후가공) | 봉제(PROC_000080 유형=오버로크/봉미싱·폭4cm)·타공(PROC_000079 구수=4)·부착(PROC_000081)·족자제작(PROC_000082 모양=사각)·열재단(PROC_000084 round-9 mint)·보드마운팅(화이트보드/포맥스3mm) | A→B | models.py:391·473·D-24·b.9 |
| **t_prd_product_processes**(화이트 별색) | PROC_000008 화이트 underbase(투명/홀로그램 소재). clr_cd=NULL(별색=공정). G-SL-2 도메인 필수 | B | entity-semantic §3 |
| **t_prd_product_processes**(코팅) | 무광코팅=PROC 코팅(자재 아님·Q9 확정) | B | Q9 실무진 |
| **t_prd_product_sizes**(면적형) | 규격(A3/A2/A1)+고정(600x1800·5000x900)+인치(5x5)+**비규격 입력제약(min/max)**+사용자입력. 가격격자≠입력UX | A→B | models.py:427·492 |
| **t_prd_products**(인쇄방식 2종) | PROC_000006 실사(대부분)·**PROC_000002 UV**(아크릴스티커 폴더=레이저커팅. ※PROC_000007=별색인쇄). file_upload_yn=Y·일부 editor_yn=Y(액자/행잉/족자) | A | models.py:444·process-recipe §1 |
| **t_prd_product_addons**(거치/족자) | 거치대(배너/스탠딩)·우드봉(족자)·액자프레임 → tmpl_cd. "출력만"=addon 미선택 | B | models.py:218 |
| **가격(포스터사인 매트릭스)** | **분석 제외**(사용자). t_prc_component_prices(siz_cd 치수조합)+면적공식+ceiling=round-2 별도 | (round-2) | [[dbmap-silsa-price-via-poster-sign]] |

## SL2. 실사 미사용/희소 t_* (낱장 면적형 — 책자/캘린더와 차이)

| t_* | 사유 |
|-----|------|
| `t_prd_product_page_rules` | **실사=낱장 단일**(내지 없음·장수 없음). 캘린더 장수와도 다름(실사=면적, 매수 무관) |
| `t_prd_product_materials`(.02 표지/.03 면지) | 실사=낱장 본체 1슬롯(usage CONFIRM-SL-5). 표지/면지/반제품 없음 |
| `t_prd_product_bundle_qtys` | 실사=수량(개)만, 묶음수 없음 |
| `t_prd_product_plate_sizes`(출력판형) | **희소** — 실사=대형 롤출력이라 전지규격 무의미(K 숨김열·안내문만). 캘린더와 차이 |
| `t_prd_process_excl_groups` | **GRP-SL-가공 부재**(GRP-BOOK/CAL만) — 실사 가공 택일그룹 미적재(G-SL-3·CONFIRM-SL-3) |

## SL3. 적재 surface별 코드값 도메인 (실사 활성 enum)

| 필드 | 코드그룹 | 실사 허용값(엑셀 도출) |
|------|----------|------------------------|
| `mat_typ_cd` | MAT_TYPE | .08 실사소재·.05 원단·.06 가죽 |
| `usage_cd` | USAGE | .01 본체(낱장 — CONFIRM-SL-5) |
| (인쇄방식) | PROC 트리 | PROC_000006 실사·PROC_000002 UV(아크릴스티커) |
| prcs_dtl_opt | (공정 param) | 봉제 유형(오버로크/봉미싱)·폭(4cm)·타공 구수(4)·족자 모양(사각) |
| (화이트 별색) | PROC | PROC_000008 화이트(clr_cd=NULL) |
| `output_file_typ` | (파일포맷) | JPG(실사 주력)·PDF·PDF+커팅AI |

## SL4. 실사 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드(models.py) | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| 사이즈(면적형) | t_prd_product_sizes 이산 행 | C5 규격+C6/C7 비규격 연속범위+자유입력 | CONFIRM-SL-1(비규격=입력제약·가격유효=포스터사인 매트릭스) |
| 가공 택일그룹 | excl_groups(GRP-BOOK/CAL만) | C20 실사 가공 다종 UI 택일 | CONFIRM-SL-3(GRP-SL-가공 신규 vs 단순공정·G-SL-3) |
| 화이트 별색 | PROC_000008 자리 | C18 접착투명만 명시·투명/홀로그램 빈값 | CONFIRM-SL-2(도메인 강제 vs 명시분만·G-SL-2) |
| 아크릴스티커 인쇄방식 | 시트=실사 분류 | 폴더=레이저커팅(UV) | CONFIRM-SL-7(UV 라우팅 확정) |
| 거치대/우드봉 | addon tmpl + process 둘 다 자리 | C21 거치대/우드봉·"출력만" | CONFIRM-SL-4(자재 vs 공정 vs addon) |
| 가격(R/S/V/X/Z) | inline price 컬럼 5개 | 면적별 매트릭스 필요 | **분석 제외**(포스터사인 매트릭스·round-2) |

> **불일치 처리 원칙(스킬 HARD):** 코드와 라이브 스키마가 어긋나 보이면 추측으로 메우지 않고 discrepancy로 기록 → validator/schema-analyst가 라이브 실측으로 해소. 본 delta는 코드 권위 + 엑셀 현실 대조까지만. **가격 경로는 사용자 지시로 분석 제외**(포스터사인 면적매트릭스 round-2 트랙).

---

# 아크릴 적재명세 delta (round-11 확대 #6 · 2026-06-10)

> §1~3 공유 — 재기술 안 함. 아크릴이 앞 시트 대비 **새로 활성화하는 적재 경로의 delta만**. 아크릴은 **UV 단일 인쇄방식(PROC_000002·변형) + 두께=자재(MAT_TYPE.03) + 부속자재(MAT_TYPE.07)+부착공정(PROC_000081) 2축 + 완칼 묵시 + 조각수(조합형)**가 핵심 차이. 마스터는 round-3 라이브 확인상 **건전**(두께·부속·완칼·부착·UV 코드 전부 존재) — 결함은 **상품 연결 결손/오매핑**.
>
> **⚠️ 가격 3컬럼(H/V/X) 값 매핑 분석 제외** — 아크릴 가격표 round-2 트랙.

## AC1. 아크릴이 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 아크릴 delta | 적재 surface | 근거 |
|-----------|-----------|:--:|------|
| **t_prd_product_processes**(UV 인쇄방식) | **PROC_000002 UV** + `prcs_dtl_opt.변형`(배면양면/풀빼다/투명테두리/단면). 아크릴=UV 단일 — 인쇄방식 연결 필수(라이브 §264 전상품 미연결→첫 연결 대상) | A→B | models.py:391·473·db-structure §47/§264 |
| **t_prd_product_processes**(완칼) | **PROC_000053 완칼**{모양 string·조각수 int}(레이저커팅·die-cut). **묵시 필수**(엑셀 무명시이나 도메인 필수 G-AC-1). 형상 굿즈만 — 판/입체류 over-reach 제외(161/168/169) | B | models.py:391·db-structure §165-167 |
| **t_prd_product_processes**(부착) | **PROC_000081 부착**{대상=맥세이프/끈/자석/핀}. 라이브 맥세이프(PRD_000151)만 1행(G-AC-4) | B | models.py:391·D-24 |
| **t_mat_materials**(아크릴 두께) | `mat_typ_cd`=**MAT_TYPE.03**. **두께=자재 식별자**: MAT_000042(1.5mm)·043(3mm)·044(8mm)·195/196(골드/실버). 라이브 22상품 MAT_000192 일괄=두께소실(G-AC-3) | A→B | models.py:126·MAT_TYPE.03 |
| **t_mat_materials**(부속) | `mat_typ_cd`=**MAT_TYPE.07 부속**. 고리/자석/핀/집게/바디/끈/와이어링=MAT_000045~057. 라이브 전무(G-AC-4) | A→B | models.py:126/283 |
| **t_prd_product_bundle_qtys**(조각수) | `bdl_qty`=조각수(자유형스탠드 2~6·미니파츠 10). **조합형만**(단품형=1조각). 스티커 조각수 활성과 동류 | B | models.py:234·QTY_UNIT |
| **t_prd_products**(nonspec) | `nonspec_yn`/`nonspec_*_min/max`. `사용자입력` 11상품. 라이브 nonspec 전무(G-AC-6) | A | models.py:444 |
| **t_prd_product_addons**(볼체인) | 키링/포카키링 → tmpl_cd + PRD_000006 볼체인. 라이브 1행(선택안함)만(9색 미반영 G-AC-7) | B | models.py:218 |

## AC2. 아크릴 미사용/희소 t_*

| t_* | 사유 |
|-----|------|
| `t_prd_product_page_rules` | 아크릴=낱장 굿즈(내지/장수 없음) |
| `t_prd_product_materials`(.02 표지/.03 면지) | 아크릴=본체(.01)+부속(.07). 반제품 없음 |
| `t_prd_process_excl_groups` | 아크릴 택일그룹 0행(GRP-BOOK/CAL만). UV변형은 별 excl_group 불요 |
| `t_proc_processes`(코팅/제본/박/형압/오시/미싱) | 아크릴 후가공 미사용. 별색=UV 변형 풀빼다로 흡수 |
| `t_prd_product_plate_sizes`(출력판형) | **희소** — UV 평판=시트/판재라 전지규격 무의미 |

## AC3. 적재 surface별 코드값 도메인 (아크릴 활성 enum)

| 필드 | 코드그룹 | 아크릴 허용값 |
|------|----------|---------------|
| `mat_typ_cd` | MAT_TYPE | .03 아크릴(본체)·.07 부속 |
| `usage_cd` | USAGE | .01 본체·(부속 usage — CONFIRM-AC-3) |
| `prd_typ_cd` | PRD_TYPE | .04 디자인상품(라이브 전수) |
| (인쇄방식) | PROC 트리 | **PROC_000002 UV**(단일) |
| prcs_dtl_opt(UV변형) | (param) | 배면양면·풀빼다·투명테두리·단면 |
| prcs_dtl_opt(완칼) | (param) | 모양(원형/사각/하트/자물쇠/사용자)·조각수(2~10) |
| `bdl_unit_typ_cd` | QTY_UNIT | 조각/세트 |

## AC4. 아크릴 적재 discrepancy (코드 vs 라이브 — round-3 권위)

| 항목 | 코드/마스터 존재 | 라이브 현실(round-3 SELECT) | 처리 |
|------|------------------|------------------------------|------|
| UV변형 | PROC_000002 변형 param + print_side | print_side에 배면양면/풀빼다 오적재 | CONFIRM-AC-4(변형 process 이동·G-AC-5) |
| 두께 자재 | MAT_000042/043/044 | 22상품 MAT_000192 일괄(두께 소실) | CONFIRM-AC-2(192→042/044·G-AC-3) |
| 완칼 | PROC_000053 마스터 존재 | 23상품 0건 + 161/168/169 over-reach | CONFIRM-AC-1(형상 굿즈만·G-AC-1) |
| 가공 부속 | MAT_000045~057 + PROC_000081 | 맥세이프만 1행·부속 전무 | CONFIRM-AC-3(자재+부착 2축·G-AC-3/4) |
| 조각수 | bundle + prcs_dtl_opt 둘 다 | process 0행 | CONFIRM-AC-5(둘 다·G-AC-2) |
| 볼체인 9색 | addon tmpl(PRD_000006) | 1행(선택안함)만 | CONFIRM-AC-6(variant vs 9 addon·G-AC-7) |
| nonspec | nonspec_*_min/max | 전 NULL | CONFIRM-AC-7(비규격 범위·G-AC-6) |
| ★신규 | 등록 가능 | 쉐이커★/지비츠★ 미등록 | CONFIRM-AC-8(출시 vs 보류) |
| 가격(H/V/X) | inline price | 사이즈별 단가 | **분석 제외**(아크릴 가격표·round-2) |

> **권위:** 아크릴은 round-3가 이미 라이브 13 SELECT로 G-AC-1~9 확정(마스터 건전·상품 연결 결손). 본 delta는 그 권위 + 엑셀 대조까지. 가격 경로 분석 제외.

---

# 문구(가격포함) 적재명세 delta (round-11 확대 #6 · 2026-06-10)

> §1~3 공유 — 재기술 안 함. 문구는 booklet과 구조 동형(반제품·page_rule·제본·usage 슬롯)이나 **① 가격포함(t_prc_* 고정가 활성, booklet 부재) ② 박/형압 전무 ③ 미싱제본 신규(PROC_000017 자식 부재) ④ 구간할인(round-1) 연결 ⑤ PVC커버(USAGE.05)·합지보드/하드보드 부속**이 차이.

## ST2-1. 문구가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 문구 delta | 적재 surface | 근거 |
|------------|-----------|:--:|------|
| **t_prd_product_prices / t_prc_*** | **가격포함** — C29 inline 고정가(다이어리 9000~15000·스프링 4500·수첩 3000·메모 5000/6000·중철 2500). round-2 고정가형. **떡메모지=`*가격표참고`**(묶음수 50/100장 × size 매트릭스, component_prices siz 차원) | A | models.py:336·203·round-2 |
| **t_prd_product_page_rules** | 내지 page_min/max/incr. 먼슬리=28~28·증가0(고정 28P)·떡메모=3~3·증가3. 무지내지 다수=빈값(page 무의미) | B | models.py:302 |
| **t_prd_product_bundle_qtys** | **떡메모지 묶음수** — 50장1권·100장1권. `bdl_unit`=QTY_UNIT.03 권. page_rule과 별 축 | B | models.py:234·entity-semantic §28·138 |
| **t_proc_processes**(트윈링 PROC_000021) | 스프링노트(좌철)/수첩(상철)=트윈링 + 방향 param·실버링 링컬러 | A→B | db-structure §306·161 |
| **t_proc_processes**(미싱제본 — 신규) | 만년다이어리 소프트/레더소프트·먼슬리=미싱제본(`*출력+미싱`). **PROC_000017 8자식에 부재 → 신규 등록 후보**(ST2-5) | A→B | db-structure §127 갭 |
| **t_prd_product_materials**(usage 슬롯+부속) | USAGE.01 내지(백모조)·.02 표지(아트250/레더)·.03 면지(하드커버)·.05 투명커버(PVC) + 부속(실버링·합지보드·하드보드) | B | models.py:283·USAGE |
| **t_dsc_***(구간할인 round-1) | C36 `문구 구간할인` → 상품 연결 | (round-1) | round-1 t_dsc_* |

## ST2-2. 문구 미사용/희소 t_* (booklet 대비)

| t_* 엔티티 | 사유 |
|------------|------|
| `t_proc_processes`(박 PROC_000033·형압 051/052) | **문구=박/형압 컬럼 전무**(문구류 박 미운영) |
| `t_proc_processes`(별색인쇄 PROC_000007) | 문구=별색 없음 |
| `t_proc_processes`(커팅 53/54/55) | 문구=제본물(스티커 전용) |
| `t_prd_product_addons` | 문구=추가상품 없음(캘린더 첫 활성과 차이) |
| `t_prd_product_plate_sizes` | **희소** — 낱장 PDF 출력 |
| `t_prd_process_excl_groups`(GRP-CAL-가공) | 문구=캘린더 가공 없음. 단 GRP-BOOK-제본은 사용 |

## ST2-3. 적재 surface별 코드값 도메인 (문구 활성 enum)

| 필드 | 코드그룹 | 문구 허용값 |
|------|----------|-------------|
| `mat_typ_cd` | MAT_TYPE | .01 종이(백모조·아트250)·.06 가죽(레더)·.07 부속(실버링·합지보드·하드보드)·(.05 USAGE 투명커버=PVC) |
| `usage_cd` | USAGE | .01 내지·.02 표지·.03 면지·.05 투명커버·(.06 표지타입 variant) |
| `proc_cd`(제본) | PROC_000017 자식 | 트윈링(021)·중철·떡제본·하드커버 + **미싱제본(신규)** |
| `bdl_unit` | QTY_UNIT | .03 권(떡메모 50/100장1권) |
| `sel_typ_cd` | SEL_TYPE | .01 단일(GRP-BOOK-제본 택일) |
| 방향(prcs_dtl_opt) | (트윈링) | 좌철(노트)·상철(수첩) |

## ST2-4. 문구 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드/스키마 자리 | 엑셀 현실 | 처리 |
|------|-----------------|-----------|------|
| 미싱제본 | PROC_000017 자식 8종 | 만년다이어리 소프트/먼슬리=`*출력+미싱` | CONFIRM-ST2-5(신규 등록 vs 후가공) |
| 만년다이어리 커버타입 | 1 vs 4 prd_cd | MES 008-0020~0023 별 4코드·130x190 동일 | CONFIRM-ST2-2(별상품 vs 표지타입 variant USAGE.06) |
| 떡메모지 가격 | inline 고정가 | `*가격표참고`(묶음수×size 매트릭스) | CONFIRM-ST2-7(component_prices siz 차원) |
| 제본옵션(C27) 이중의미 | 단일 컬럼 | 트윈링=실버링(링)·하드커버=면지 | CONFIRM-ST2-3(링 param/자재 vs 면지 USAGE.03) |
| 표지사양 복합(C25) | 자재 컬럼 | `아트250 + 무광코팅`(자재+공정) | 분해(자재 USAGE.02 + 코팅 공정) |
| page vs 묶음수 vs 장수 | page_rule/bundle | 먼슬리 28·떡메모 page3·떡메모 묶음수(권) | 3축 분리 적재 |
| COMMENT 부속힌트 | 견적 컬럼 부재 | `*합지보드`·`*PVC커버`=BOM 힌트 | note 보존 + 부속 자재 도출 |

> **적재 순서:** 마스터(제본+미싱 신규·USAGE·QTY_UNIT.03) → 상품(11, 노트류 editor_yn=Y·메모패드내지커스텀 준비중 보류) → 하위(usage 4슬롯·page_rule·bundle 떡메모·제본) → round-6(GRP-BOOK-제본 택일·면지 캐스케이드) → round-2(고정가·떡메모 가격표참고) → round-1(구간할인).

---

# 굿즈파우치(가격포함) 적재명세 delta (round-11 확대 #6 · 2026-06-10)

> §1~3 공유 — 재기술 안 함. 굿즈파우치 핵심 차이: **혼합 인쇄방식 다종(폴더=라우팅) + 색상×사이즈 variant(round-10 size→option) + 굿즈 후가공(봉제 D-24/에폭시 b.12/맥세이프) + 본체색=재질행 합성 + MES 코드 미부여 + 가격포함(round-2 고정가형) + 구간할인(round-1)**.
>
> **⚠️ 가격 4컬럼(가격·선택가격·가공가격·추가가격) 분석 제외** — round-2 고정가형 트랙.

## GP1. 굿즈파우치가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 굿즈파우치 delta | 적재 surface | 근거 |
|-----------|-----------------|:--:|------|
| **t_mat_materials**(굿즈 자재 다종) | **소재=상품군 정체.** MAT_TYPE.05 원단(린넨/캔버스/광목/메쉬/타이벡/면/극세사)·.06 가죽·.09 파우치·.10 악세사리·.03 아크릴·.04 금속·.02 필름. **본체색=재질행 합성**(split 금지) | A→B | models.py:126·db-structure §191 |
| **t_prd_product_processes**(굿즈 후가공) | 봉제(PROC_000080 오버로크/말아박기/봉미싱·폭)·에폭시(PROC_000083 b.12 굿즈파우치 전용)·부착(PROC_000081 맥세이프/보냉/라벨)·레이저커팅 | A→B | models.py:391·473·D-24·b.12 |
| **t_prd_products**(인쇄방식 다종·MES 미부여) | **폴더=라우팅:** UV(000002)·디지털(000004)·실사(000006) + 외주/신규(이지굿즈 PVC고주파·만년도장·전사·패브릭→봉제). editor_yn=Y 주력·**mes_item_cd 대부분 NULL**(신규 등록) | A | models.py:444·process-recipe §207 |
| **t_prd_product_sizes**(치수+variant) | 치수형(작업사이즈만·재단/블리드 빈값 G-GP-2) + 사이즈등급(M/L/XL)·형상 융합(siz_nm). 옵션형(폰기종/방향/구수/면)=round-6 | A→B | models.py:427·G-GP-2/3 |
| **t_prd_product_options/option_items**(round-6 variant) | **본체색**(재질행 합성 ref_dim_cd=mat+usage)·사이즈등급/폰기종·방향/면(도수)·구수(공정). round-10 size→option 재분류분 | B(round-6) | round-10 |
| **t_prd_product_addons**(굿즈 부속) | 볼체인(키링 9색)·잉크 5cc(만년스탬프 리필)·아크릴스탠드 → tmpl_cd | B | models.py:218 |
| **t_prd_product_categories**(19 구분) | **구분 풍부**(폰케이스/말랑/데스크/라이프/레더파우치/패션 등) — 인쇄방식·구간할인 라우팅 키 | B | models.py |
| **t_dsc_***(구간할인 round-1) | 굿즈A타입(15)·B타입(11)·말랑상품(5)·파우치/에코백(1)·없음(2). 카테고리단위 | (round-1) | [[dbmap-discount-authority]] |

## GP2. 굿즈파우치 미사용/희소 t_*

| t_* | 사유 |
|-----|------|
| `t_prd_product_page_rules` | 굿즈=낱장 단품(내지/장수 없음) |
| `t_prd_product_materials`(.02 표지/.03 면지) | 굿즈=낱장 본체 1슬롯(USAGE.01 CONFIRM-GP-5) |
| `t_prd_product_bundle_qtys` | 굿즈=수량(개)만 |
| `t_prd_product_plate_sizes` | **전 빈값** — 직인쇄/단품(전지규격 무의미) |
| `t_siz_sizes.margin_*/cut_*` | **전 빈값** — 리지드 굿즈(작업사이즈만·G-GP-2 재단치수 누락) |
| `t_prd_process_excl_groups` | **GRP-GP-가공 부재**(GRP-BOOK/CAL만)·CONFIRM-GP-3(실사 G-SL-3 동류) |

## GP3. 적재 surface별 코드값 도메인 (굿즈파우치 활성 enum)

| 필드 | 코드그룹 | 굿즈파우치 허용값 |
|------|----------|-------------------|
| `mat_typ_cd` | MAT_TYPE | .05 원단·.06 가죽·.09 파우치·.10 악세사리·.03 아크릴·.04 금속·.02 필름·.01 종이 |
| `usage_cd` | USAGE | .01 본체(낱장 — CONFIRM-GP-5) |
| (인쇄방식) | PROC 트리 | UV(000002)·디지털(000004)·실사(000006) + 외주/신규(패브릭·전사·이지굿즈·만년도장) CONFIRM-GP-7 |
| (가공) | PROC | 봉제(000080)·에폭시(000083 b.12)·부착(000081) |
| `output_file_typ` | (파일포맷) | JPG(주력)·PDF·AI·PNG |
| (구간할인) | t_dsc_* | 굿즈A/B타입·말랑상품·파우치/에코백·없음 |
| `mes_item_cd` | (MES) | **대부분 NULL**(미부여·신규 등록 CONFIRM-GP-8) |

## GP4. 굿즈파우치 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드(models.py) | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| 사이즈(variant) | 이산 치수행 | C5 224행 중 202 옵션성(폰기종/등급/방향/구수/면) | CONFIRM-GP-1(치수형→size·옵션형→CPQ·round-10 재분류) |
| 본체색 | 재질행 | C15 색상 옵션(블랙/화이트/글리터·복합 "블랙 XL") | CONFIRM-GP-2(재질행 합성·split 금지·2축 분리) |
| 가공 택일그룹 | excl_groups(GRP-BOOK/CAL만) | C17 굿즈 가공(라벨/에폭시/맥세이프) 택일 | CONFIRM-GP-3(GRP-GP-가공 신규 vs 단순공정·실사 SL-3 일괄) |
| 인쇄방식 PROC | UV/디지털/실사만 명시 | C12 폴더 다종(이지굿즈/만년도장/전사/패브릭 외주 코드 부재) | CONFIRM-GP-7(외주/신규 PROC mint vs 흡수) |
| MES 코드 | mes_item_cd NOT NULL 기대 | C3 대부분 빈값(신규 미등록) | CONFIRM-GP-8(NULL 적재·prd_nm 멱등·상태→use_yn) |
| 부속(볼체인/맥세이프/보냉) | addon+process+material 모두 자리 | C22/C17 볼체인·맥세이프·보냉 내피 | CONFIRM-GP-4(자재 vs 공정 vs addon·BK-3/CL-5/SL-4 일괄) |
| 블리드/재단/출력용지규격 | siz/plate 컬럼 | C6/C8/C9 전 빈값(리지드 굿즈) | 미적재 정당(작업사이즈만·G-GP-2) |
| 가격(4컬럼) | inline price | 가격포함(고정가형) | **분석 제외**(round-2 고정가형) |

> **불일치 처리 원칙(스킬 HARD):** 코드와 라이브가 어긋나면 추측으로 메우지 않고 discrepancy로 기록 → validator/schema-analyst가 라이브 실측으로 해소. **가격 경로는 가격포함 시트라도 round-2 고정가형 트랙으로 분리**.

---

# 상품악세사리(가격포함) 적재명세 delta (round-11 확대 #9 · 11시트 완성 · 2026-06-10)

> §1~3 공유 — 재기술 안 함. 상품악세사리는 **완제 부속·별매 부자재(인쇄 BOM 부재) + OTC TEMPLATE 카탈로그(이중 등록) + 사이즈 3축 복합(치수+묶음+색상) + 가격포함(round-2 고정가)**가 핵심 차이. round-9 OTC 인벤토리가 권위.

## PA1. 상품악세사리가 추가로 쓰는 t_* 적재 경로

| t_* 엔티티 | 상품악세사리 delta | 적재 surface | 근거 |
|-----------|-------------------|:--:|------|
| **t_prd_templates**(addon SKU) | **부자재=addon 참조 SKU.** 봉투(엽서/카드/캘린더)·볼체인(키링)·우드(캘린더/족자/행잉)·리필잉크(만년스탬프) → tmpl_cd. 다른 시트 `_addons.tmpl_cd`가 참조 | A | models.py addon→tmpl·round-9 OTC |
| **t_prd_products**(부자재 독립) | 15 부자재 자체 prd_cd(독립 판매). 라이브 PRD_000001/002 봉투·006 볼체인·015 리필잉크·281~283 카드봉투. **이중 등록**(prd_cd + tmpl_cd) | A | round-9 OTC TEMPLATE |
| **t_prd_product_bundle_qtys**(묶음수) | **사이즈 셀 묶음 인코딩** 50장·3개1팩·2개1세트·20개입·10개 → bdl_qty + QTY_UNIT(장/개/팩/세트) | B | models.py:234·QTY_UNIT |
| **t_prd_product_sizes**(치수 variant) | 봉투 치수·우드 길이(270/360/480mm)·잉크 용량(5cc)·투명케이스 3D치수 | A→B | models.py:427 |
| **t_prd_product_options/option_items**(색상 — round-6) | 볼체인 8색·리필잉크 7색·와이어링 3색·카드봉투 화이트/블랙·행택끈 3종 = 색상 variant(옵션 vs 별 SKU PA-3) | B(round-6) | round-9 C-6 |
| **t_prd_product_categories**(2 구분) | 봉투/케이스·상품액세서리 | B | models.py |
| **가격(고정가)** | **가격포함→round-2 고정가**(variant별 단가). 도메인은 BOM까지 | (round-2) | C9 |

## PA2. 상품악세사리 미사용 t_* (완제 부속 — 전 시트와 최대 차이)

| t_* | 사유 |
|-----|------|
| `t_prd_product_materials` | **완제 부속(인쇄 안 함)** — 자재=완제품 자체. 후니 자재 BOM 미적용 유일 시트 |
| `t_prd_product_processes` | **공정 없음**(매입 완제/외주 우드). 인쇄/후가공 부재 |
| `t_prd_product_print_options` | 인쇄 안 함(도수/인쇄면 없음) |
| `t_prd_product_plate_sizes`·`t_prd_product_page_rules` | 출력판형/page 무관(부자재) |
| `t_prd_process_excl_groups` | 택일그룹 없음 |

## PA3. 적재 surface별 코드값 도메인 (상품악세사리 활성 enum)

| 필드 | 코드그룹 | 상품악세사리 허용값 |
|------|----------|---------------------|
| `prd_typ_cd` | PRD_TYPE | (부자재/완제 — 라이브 확인) |
| `bdl_unit_typ_cd` | QTY_UNIT | 장(봉투)·개(케이스)·팩(볼체인)·세트(천정고리)·개입(자석) |
| (색상 variant) | (색상 코드/옵션) | 볼체인 8·리필잉크 7·와이어링 3·카드봉투 2·행택끈 3 |
| `mes_item_cd` | (MES) | 012-0004~0018(**공유 다수** PA-5) |

## PA4. 상품악세사리 적재 discrepancy (코드 vs 엑셀 현실)

| 항목 | 코드/스키마 자리 | 엑셀 현실(260610) | 처리 |
|------|-----------------|-------------------|------|
| 부자재 이중 등록 | prd_cd + tmpl_cd 둘 다 자리 | 15 부자재(라이브 일부 prd_cd 적재) | CONFIRM-PA-1(독립 + addon 이중) |
| 사이즈 3축 복합 | siz/bundle/색상 분리 자리 | C5 `70x200mm (50장)`·`오렌지 (3개1팩)` | CONFIRM-PA-2/3(치수/묶음/색상 분해) |
| 우드 부속 | addon tmpl + process 자리 | 우드거치대/봉/행거 | CONFIRM-PA-4(OPTION vs TEMPLATE·C-4·CL-2/SL-4 일괄) |
| MES 공유 | mes_item_cd | 012-0004 OPP접착=비접착 등 | CONFIRM-PA-5(별 prd_cd·prd_nm 멱등) |
| 가격 | inline 고정가 | 가격포함(variant 단가) | round-2 고정가형 |

> **불일치 처리 원칙(스킬 HARD):** 코드와 라이브가 어긋나면 추측으로 메우지 않고 discrepancy로 기록 → validator/schema-analyst가 라이브 실측으로 해소. 상품악세사리는 round-9 OTC 인벤토리가 이미 TEMPLATE/OPTION 판별 권위 — 본 delta는 그 권위 + 엑셀 대조까지. **MAP 시트=카테고리 맵(상품 아님) round-11 제외.**
