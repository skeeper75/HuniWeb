# 후니 Admin 화면 맵 (소스 권위 전수 도출)

> **산출자:** ham-source-analyst · **권위:** `raw/webadmin/webadmin/` Django 소스 (catalog + config)
> **목적:** 라이브 후니 Django admin(https://huni-admin-production.up.railway.app/admin/)의
> 모든 화면·메뉴·항목을 소스에서 결정적으로 열거 → 캡처·DB검증·작성의 단일 뿌리.
> **추측 0 원칙:** 모든 항목은 소스 라인 근거. 소스만으로 불확실한 동작은 §6 "라이브 확인 필요"로 위임.

---

## 1. 사이트 개요

| 항목 | 값 | 근거 |
|------|----|------|
| 사이트 헤더 | **후니 상품·가격 DB 관리자** | `admin.py:453` `site_header` / `settings.py:45` UNFOLD SITE_HEADER |
| 사이트 타이틀 | 후니 DB Admin | `admin.py:454` / `settings.py:44` |
| 서브헤더 | Railway PostgreSQL | `settings.py:46` |
| 인덱스 타이틀 | 테이블 관리 | `admin.py:455` |
| 테마 | **Unfold** (django-unfold) | `settings.py:31-41` INSTALLED_APPS, `admin.py:18` UnfoldModelAdmin |
| 홈 (`/admin/`) | **상품 뷰어로 redirect** (앱 목록 대시보드 대신) | `urls.py:42` RedirectView→`product_viewer` |
| 로그인 | 표준 Django admin 로그인 (`/admin/login/`) | `urls.py:43` `admin.site.urls`, 모든 커스텀 뷰 `admin_view`로 인증 강제 |
| 좌측 사이드바 | 5개 도메인 그룹(아래) + 검색박스(show_search) | `settings.py:57-119` UNFOLD SIDEBAR navigation |
| 색상 | primary=blue 계열(50~950) | `settings.py:49-56` |
| iframe | SAMEORIGIN 허용(섹션편집 모달이 admin 추가폼을 same-origin iframe으로) | `settings.py:28` X_FRAME_OPTIONS |

### 좌측 사이드바 메뉴 그룹 (고정 navigation — 소스에 명시)

`settings.py:57-119`의 SIDEBAR.navigation은 **명시적 링크 목록**이다(자동 생성 아님). `show_all_applications: False`라 등록된 모든 모델이 자동 노출되지 않고, 아래 13개 링크만 메뉴에 보인다. 나머지 등록 모델(복합PK 인라인 제외 모델 중 메뉴 미등록분)은 직접 URL로만 접근.

| 그룹 | 메뉴 항목 | 아이콘 | 링크 대상 |
|------|----------|--------|----------|
| **상품** | 상품정보 | inventory_2 | tprdproducts changelist |
| | 상품 뷰어 | dashboard | `product_viewer` (커스텀) |
| | 구성 템플릿(SKU) | dashboard_customize | tprdtemplates changelist |
| **기준정보 (마스터)** | 카테고리 | category | tcatcategories changelist |
| | 자재정보 | texture | tmatmaterials changelist |
| | 사이즈정보 | straighten | tsizsizes changelist |
| | 도수정보 | palette | tclrcolorcounts changelist |
| | 공정정보 | precision_manufacturing | tprocprocesses changelist |
| | 기초코드정보 | list | tcodbasecodes changelist |
| **가격** | 가격공식 | functions | tprcpriceformulas changelist |
| | 가격구성요소 | tune | tprcpricecomponents changelist |
| | 구성요소 다차원 단가 | payments | tprccomponentprices changelist |
| **할인 · 고객** | 수량구간할인 | percent | tdscdiscounttables changelist |
| | 고객 | group | tcuscustomers changelist |
| **인증 및 권한** | 사용자 | person | auth_user changelist |
| | 그룹 | groups | auth_group changelist |

> **메뉴 미등록이지만 등록되는 모델(직접 URL 접근만):** `t_prc_formula_components`(공식별구성요소·복합PK→인라인 아님·standalone 등록됨? — 아래 §3 주의), `t_dsc_discount_details`(인라인 아님), `t_dsc_grade_discount_rates`, `t_prd_product_prices`, `t_prd_product_price_formulas`, `t_prd_product_discount_tables`, `t_prd_product_sets` 등. → 이들은 **복합PK라 standalone 등록 자체가 skip**됨(§3 참조). 따라서 메뉴 미등록 + 인라인 미등록 = **어느 화면에도 직접 안 나오는 모델**이 존재(§6 플래그).

---

## 2. 화면 목록 표 (캡처가·작가 작업 큐)

화면ID 규칙: 표준=`{model}__{changelist|add|change}`, 커스텀=뷰 함수명.
URL 베이스: 표준 changelist=`/admin/catalog/{model}/`, change=`/admin/catalog/{model}/<pk>/change/`, add=`/admin/catalog/{model}/add/`.

### 2-A. 표준 Django admin — standalone 등록 모델 (13종, 각 changelist+changeform)

| 화면ID | 레이어 | 유형 | 한글 라벨 | URL 패턴 | 우선순위 |
|--------|--------|------|----------|----------|----------|
| tprdproducts__changelist | 표준 | 목록 | 상품정보 | /admin/catalog/tprdproducts/ | **High** |
| tprdproducts__change | 표준 | 수정(상품뷰어링크) | 상품정보 편집 | /admin/catalog/tprdproducts/`<pk>`/change/ | **High** |
| tprdtemplates__changelist | 표준(특수) | 목록(팝업JS) | 구성템플릿(SKU) | /admin/catalog/tprdtemplates/ | **High** |
| tprdtemplates__change | 표준(특수) | →SKU화면 redirect | (구성템플릿 직접편집 없음) | /admin/catalog/tprdtemplates/`<pk>`/change/ | Medium |
| tprdtemplates__add | 표준(특수) | 추가(인라인) | 구성템플릿 추가 | /admin/catalog/tprdtemplates/add/ | Medium |
| tcatcategories__changelist | 표준 | 목록 | 카테고리 | /admin/catalog/tcatcategories/ | Medium |
| tcatcategories__add/change | 표준 | 추가/수정 | 카테고리 | …/add/, …/`<pk>`/change/ | Medium |
| tmatmaterials__changelist | 표준 | 목록 | 자재정보 | /admin/catalog/tmatmaterials/ | **High** |
| tmatmaterials__add/change | 표준 | 추가/수정 | 자재정보 | …/add/, …/`<pk>`/change/ | **High** |
| tsizsizes__changelist | 표준 | 목록 | 사이즈정보 | /admin/catalog/tsizsizes/ | **High** |
| tsizsizes__add/change | 표준 | 추가/수정 | 사이즈정보 | …/add/, …/`<pk>`/change/ | **High** |
| tclrcolorcounts__changelist | 표준 | 목록 | 도수정보 | /admin/catalog/tclrcolorcounts/ | Medium |
| tclrcolorcounts__add/change | 표준 | 추가/수정 | 도수정보 | …/add/, …/`<pk>`/change/ | Medium |
| tprocprocesses__changelist | 표준 | 목록 | 공정정보 | /admin/catalog/tprocprocesses/ | **High** |
| tprocprocesses__add/change | 표준 | 추가/수정 | 공정정보 | …/add/, …/`<pk>`/change/ | **High** |
| tcodbasecodes__changelist | 표준 | 목록 | 기초코드정보 | /admin/catalog/tcodbasecodes/ | Medium |
| tcodbasecodes__add/change | 표준(특수폼) | 추가/수정 | 기초코드정보 | …/add/, …/`<pk>`/change/ | Medium |
| tprcpriceformulas__changelist | 표준 | 목록 | 가격공식 | /admin/catalog/tprcpriceformulas/ | **High** |
| tprcpriceformulas__add/change | 표준 | 추가/수정 | 가격공식 | …/add/, …/`<pk>`/change/ | **High** |
| tprcpricecomponents__changelist | 표준 | 목록 | 가격구성요소 | /admin/catalog/tprcpricecomponents/ | **High** |
| tprcpricecomponents__add/change | 표준 | 추가/수정 | 가격구성요소 | …/add/, …/`<pk>`/change/ | **High** |
| tprccomponentprices__changelist | 표준 | 목록 | 구성요소 다차원 단가 | /admin/catalog/tprccomponentprices/ | **High** |
| tprccomponentprices__add/change | 표준 | 추가/수정 | 구성요소 다차원 단가 | …/add/, …/`<pk>`/change/ | **High** |
| tdscdiscounttables__changelist | 표준 | 목록 | 수량구간할인 마스터 | /admin/catalog/tdscdiscounttables/ | Medium |
| tdscdiscounttables__add/change | 표준 | 추가/수정 | 수량구간할인 마스터 | …/add/, …/`<pk>`/change/ | Medium |
| tcuscustomers__changelist | 표준 | 목록 | 고객 | /admin/catalog/tcuscustomers/ | Low |
| tcuscustomers__add/change | 표준 | 추가/수정 | 고객 | …/add/, …/`<pk>`/change/ | Low |
| auth_user / auth_group | 표준(Django) | 목록/편집 | 사용자 / 그룹 | /admin/auth/user/, /admin/auth/group/ | Low |

> **주의:** `t_prc_component_prices`, `t_prc_price_components`, `t_prc_price_formulas`는 단일PK라 standalone 등록되지만, **`t_prc_formula_components`(공식별구성요소)는 복합PK** → standalone 등록 skip, 인라인 미등록(§6 플래그 — 어느 화면에도 직접 안 나옴).

### 2-B. 커스텀 뷰 (상품 뷰어 레이어, 11종)

| 화면ID | 레이어 | 유형 | 한글 라벨 | URL 패턴 | 우선순위 |
|--------|--------|------|----------|----------|----------|
| product_viewer | 커스텀 | 목록/대시보드(홈) | 상품 뷰어 | /admin/product-viewer/ | **High** |
| product_detail | 커스텀 | 상품 상세(섹션 집계) | 상품 상세 | /admin/product-viewer/`<prd_cd>`/ | **High** |
| section_edit | 커스텀 | 섹션 인라인 편집(9섹션) | {상품}—{섹션} 편집 | /admin/product-viewer/`<prd_cd>`/edit/`<section>`/ | **High** |
| option_groups | 커스텀 | 옵션 드릴다운 1계층 | {상품}—옵션그룹 편집 | /admin/product-viewer/`<prd_cd>`/options/ | **High** |
| options | 커스텀 | 옵션 드릴다운 2계층 | {상품}—{그룹} 옵션 편집 | /admin/product-viewer/`<prd_cd>`/options/`<opt_grp_cd>`/ | **High** |
| option_items | 커스텀 | 옵션 드릴다운 3계층 | {상품}—{옵션} 구성요소 편집 | /admin/product-viewer/`<prd_cd>`/options/`<grp>`/`<opt>`/ | **High** |
| sku_list | 커스텀 | SKU 드릴다운 1계층 | {상품}—구성템플릿(SKU) 편집 | /admin/product-viewer/`<prd_cd>`/templates/ | **High** |
| sku_selections | 커스텀 | SKU 드릴다운 2계층 | {상품}—{SKU} 선택값 편집 | /admin/product-viewer/`<prd_cd>`/templates/`<tmpl_cd>`/ | **High** |
| constraints | 커스텀 | 제약 폼빌더 | {상품}—제약 규칙 편집 | /admin/product-viewer/`<prd_cd>`/constraints/ | Medium |
| dim_choices | 커스텀(Ajax) | JSON 응답 | (차원 후보 조회) | /admin/product-viewer/`<prd_cd>`/dim-choices/?dim= | (비시각) |
| validate_preview | 커스텀(Ajax) | JSON 응답(POST) | (제약 검증 미리보기) | /admin/product-viewer/`<prd_cd>`/validate/ | (비시각) |
| impact_detail | 커스텀 | standalone 사용처 상세 | 사용처 상세 — {dim}/{key} | /admin/impact/?dim=&key1=&key2= | Medium |
| sku_catalog | 커스텀 | standalone 전체 SKU 목록 | (전체 SKU 카탈로그) | /admin/sku-catalog/ | Medium |

> **총 화면 수:** 표준 standalone 등록 13모델 × (changelist+changeform) + Django auth 2 + 커스텀 13뷰(2 Ajax 포함). 시각 화면 기준 **약 28종 화면군**(표준 13개 모델 화면군 + auth 2 + 커스텀 11 시각/standalone). 비시각 Ajax 2(dim_choices, validate_preview).

---

## 3. 표준 모델 상세 (제너릭 ModelAdmin 자동 전개)

### 3-0. 자동 등록 규칙 (`admin.py:428-451`, `_make_admin:262-294`)

`apps.get_app_config("catalog").get_models()`로 **전 34모델 루프 등록**. 각 모델에 `_apply_readability`(한글 라벨·__str__) 적용 후:
- **복합PK(`CompositePrimaryKey`) 모델 → standalone 등록 skip** (`_skipped_composite`, `admin.py:434-437`). Django 5.2 admin이 복합PK 단독 등록 불가.
- **OneToOne-PK 모델(page_rules)도 사실상 인라인 전용** (단일 OneToOne PK).
- 단일PK 모델만 `admin.site.register`로 changelist/changeform 생성.

**changelist 규칙(`_make_admin`):**
- `list_display` = **concrete 필드 앞 8개** (`names[:8]`). 필드 없으면 전체.
- `search_fields` = CharField 중 `*_nm`/`*_cd`/`note` 최대 6개.
- `list_filter` = `use_yn` 또는 `*_typ_cd` 필드 최대 4개.
- `list_per_page` = 50.
- `readonly_fields` = `reg_dt`, `upd_dt` (감사컬럼).

**changeform 규칙(`BaseAdmin`):** concrete 필드 전체, 라벨=`db_comment`(한글). 감사컬럼 readonly. YN 드롭다운·자동채번·placeholder는 §5.

### 3-1. standalone 등록 모델 (단일PK, 13종)

각 모델의 list_display는 "concrete 필드 앞 8개"로 결정 → 아래 표는 그 8개를 소스 필드 순서로 명시.

| 모델 (한글 라벨 / db_table) | list_display (앞 8필드) | search | filter | 자동채번 | 특수 |
|------|------|--------|--------|---------|------|
| **상품정보** `t_prd_products` | prd_cd, MES_ITEM_CD, prd_nm, prd_typ_cd, semi_role_cd, nonspec_yn, nonspec_width_min, nonspec_width_max | prd_cd, prd_nm | prd_typ_cd, qty_unit_typ_cd, semi_role_cd | **PRD_** 시리얼 | 상품뷰어 링크 템플릿(`product_change_with_viewer_link.html`) |
| **자재정보** `t_mat_materials` | mat_cd, mat_nm, mat_typ_cd, upr_mat_cd, sel_typ_cd, max_sel_cnt, width, height | mat_cd, mat_nm, note | mat_typ_cd, sel_typ_cd | **MAT_** 시리얼 | upr_mat_cd 트리 드롭다운(parents_only) |
| **사이즈정보** `t_siz_sizes` | siz_cd, siz_nm, work_width, work_height, cut_width, cut_height, margin_top, margin_bot | siz_cd, siz_nm, note | use_yn | **SIZ_** 시리얼 | — |
| **도수정보** `t_clr_color_counts` | clr_cd, clr_nm, chnl_cnt, use_yn, note, del_yn, del_dt, reg_dt | clr_cd, clr_nm, note | use_yn | **CLR_** 시리얼 | — |
| **공정정보** `t_proc_processes` | proc_cd, proc_nm, upr_proc_cd, prcs_dtl_opt, disp_seq, use_yn, note, del_yn | proc_cd, proc_nm, note | use_yn | **PROC_** 시리얼 | upr_proc_cd 트리 드롭다운(parents_only); prcs_dtl_opt=JSON |
| **카테고리** `t_cat_categories` | cat_cd, cat_nm, upr_cat_cd, cat_lvl, disp_seq, use_yn, reg_dt, upd_dt | cat_cd, cat_nm | use_yn | **CAT_** 시리얼 | upr_cat_cd 트리 드롭다운(exclude_leaf_level, cat_lvl 기준) |
| **기초코드정보** `t_cod_base_codes` | cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, note, reg_dt, upd_dt | cod_cd, cod_nm, note | use_yn | **GROUP.NN** 그룹채번 | `BaseCodeAdminForm`(빈코드+상위미선택 시 폼오류); upr_cod_cd=루트만 |
| **가격공식** `t_prc_price_formulas` | frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt, upd_dt | frm_cd, frm_nm, note | frm_typ_cd | (시리얼 대상 아님) | — |
| **가격구성요소** `t_prc_price_components` | comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, upd_dt | comp_cd, comp_nm, note | comp_typ_cd | (시리얼 대상 아님) | — |
| **구성요소 다차원 단가** `t_prc_component_prices` | comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty | comp_cd | — | BigAutoField(DB자동) | unique_together 8키 |
| **수량구간할인 마스터** `t_dsc_discount_tables` | dsc_tbl_cd, dsc_tbl_nm, note, use_yn, reg_dt, upd_dt | dsc_tbl_cd, dsc_tbl_nm, note | use_yn | (시리얼 대상 아님) | **YN_ENHANCE_EXCLUDE** — YN 드롭다운·placeholder 미적용 |
| **고객** `t_cus_customers` | cus_cd, cus_nm, grade_cd, reg_ymd, use_yn, reg_dt, upd_dt | cus_cd, cus_nm | use_yn | (시리얼 대상 아님) | — |
| **구성템플릿** `t_prd_templates` | tmpl_nm, base_prd_cd, selections_summary, dflt_qty, use_yn (오버라이드) | tmpl_cd, tmpl_nm | use_yn, base_prd_cd | **TMPL_** 시리얼(첫행 TMPL_000001 폴백) | `TPrdTemplatesAdmin` 특수(§3-2) |

> `t_dsc_discount_details`(수량구간할인상세)는 **복합PK→인라인 미등록·메뉴 미등록** → 마스터 `t_dsc_discount_tables` 화면에서도 인라인으로 안 보임(인라인 대상은 PRODUCT_INLINE_MODELS·템플릿 선택값뿐). §6 플래그.

### 3-2. 특수 Admin 오버라이드

1. **`TPrdProducts`** (`admin.py:439-441`): changeform 템플릿을 `product_change_with_viewer_link.html`로 교체 → 상품 편집화면 상단에 **상품 뷰어로 가는 링크** 표시. (하위 차원은 표준 인라인 아닌 상품 뷰어 커스텀 화면에서 편집.)

2. **`TCodBaseCodes`** (`admin.py:442-444`): `form = BaseCodeAdminForm`. cod_cd·upr_cod_cd 둘 다 비면 폼 오류("상위기초코드를 선택하거나… 직접 입력"). upr_cod_cd 드롭다운은 루트(부모 없는)만.

3. **`TPrdTemplates` → `TPrdTemplatesAdmin`** (`admin.py:339-424`):
   - `inlines = [TPrdTemplateSelectionsInline]` — 템플릿선택값(복합PK) 인라인. `can_delete=False`(물리삭제 체크박스 제거), del_yn YN 드롭다운으로 논리삭제 전환.
   - list_display = tmpl_nm, base_prd_cd, **selections_summary**(구성 내용 pill 배지), dflt_qty, use_yn.
   - `get_queryset`: del_yn='Y' 숨김(논리삭제 필터).
   - **changelist_view**: 행 클릭 시 SKU 선택값 화면을 **팝업(window.open 960×760)**으로 여는 JS 주입(`_tmpl_popup_js`).
   - **change_view**: 직접 URL 접근 시 `sku_selections`(SKU 화면)으로 **redirect** → 표준 changeform 안 보임.
   - **delete_model/delete_queryset**: 물리 DELETE 대신 논리삭제(del_yn='Y').

### 3-3. 인라인 매핑 (복합PK·OneToOne-PK 모델 = standalone 안 나옴)

**A) 상품 인라인 (`PRODUCT_INLINE_MODELS`, `admin.py:312-324`)** — 단, 이 PRODUCT_INLINES 리스트는 _make_inline으로 생성되지만 **상품(TPrdProducts) admin에 부착되지 않는다**(상품 changeform 템플릿이 상품뷰어 링크로 교체됨). 실제 이 차원들의 편집은 **커스텀 `section_edit` 화면**에서 일어남(§4). 인라인 클래스 자체는 정의되어 있으나 상품 admin inlines로 등록되지 않음 → **§6 라이브 확인 필요**.

| 인라인 모델 (한글/db_table) | 부모 | section_edit key | FK |
|------|------|-----------------|-----|
| 상품별카테고리 `t_prd_product_categories` | 상품 | categories | prd_cd |
| 상품별사이즈 `t_prd_product_sizes` | 상품 | sizes | prd_cd |
| 상품별인쇄옵션 `t_prd_product_print_options` | 상품 | print_options | prd_cd |
| 상품별판형사이즈 `t_prd_product_plate_sizes` | 상품 | plate_sizes | prd_cd |
| 상품별자재 `t_prd_product_materials` | 상품 | materials | prd_cd |
| 상품별공정 `t_prd_product_processes` | 상품 | processes | prd_cd |
| 상품별묶음수 `t_prd_product_bundle_qtys` | 상품 | bundle_qtys | prd_cd |
| 상품별추가상품 `t_prd_product_addons` | 상품 | addons | prd_cd (tmpl_cd FK) |
| 상품별페이지룰 `t_prd_product_page_rules`(OneToOne-PK) | 상품 | page_rules | prd_cd |

**B) 템플릿 선택값 인라인 (`TPrdTemplateSelectionsInline`, `admin.py:330-335`)**

| 인라인 모델 (한글/db_table) | 부모 admin | FK |
|------|-----------|-----|
| 템플릿선택값 `t_prd_template_selections`(복합PK) | TPrdTemplatesAdmin(구성템플릿) | tmpl_cd |

**C) 복합PK이나 인라인·메뉴 모두 미등록 (= 어느 화면에도 직접 안 나옴 — §6 플래그):**
`t_dsc_discount_details`(수량구간할인상세), `t_dsc_grade_discount_rates`(등급별할인율), `t_prc_formula_components`(공식별구성요소), `t_prd_product_discount_tables`(상품별할인테이블), `t_prd_product_price_formulas`(상품별가격공식), `t_prd_product_prices`(상품단가), `t_prd_product_sets`(상품셋트정보).
**CPQ 옵션 레이어(복합PK)** — `t_prd_product_option_groups`/`options`/`option_items`, `t_prd_product_constraints`: standalone·표준인라인 미등록이나 **커스텀 드릴다운/폼빌더 화면(§4)에서 편집**됨.

---

## 4. 커스텀 뷰 상세

### 4-1. `product_viewer` — 상품 뷰어 홈 (`views.py:478-483`, `product_viewer.html`)
- **진입:** `/admin/`(홈 redirect), 사이드바 "상품 뷰어".
- **구성요소:** 전 상품 목록(prd_cd·prd_nm·prd_typ_cd, prd_cd 정렬) + **검색박스**(placeholder "상품명/코드 검색…"). 카드/행 클릭 → product_detail.
- **context:** `products`, admin each_context.

### 4-2. `product_detail` — 상품 상세 (`views.py:486-563`, `_product_detail.html`)
- **진입:** product_viewer에서 상품 클릭.
- **구성요소:** 9개 섹션 집계 카드(SECTIONS) + 옵션그룹 목록 + 제약 규칙 목록 + SKU(구성템플릿) 목록. 각 섹션·블록에 **"편집" 버튼**.
  - 섹션 9종(`SECTIONS`, `views.py:437-457`): 카테고리·사이즈·도수/인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰. 각 행수(count)·헤더·셀 + **사용처 배지**(impact, _IMPACT_SECTIONS 대상만).
  - 옵션그룹 블록: opt_grp_nm·use_yn·옵션수 → "편집"=`pvPopup(option_groups)`.
  - 제약 블록: 규칙유형(호환/금지/필수동반)·규칙명·use_yn → "편집"=`pvPopup(constraints)`.
  - SKU 블록: tmpl_nm·구성요약·use_yn → "편집"=`pvPopup(sku_list)`.
- **액션:** 섹션 "편집"=`pvEdit(prd_cd, section)`(section_edit), 나머지=`pvPopup(...)` 팝업.

### 4-3. `section_edit` — 섹션 인라인 편집 (`views.py:566-724`, `section_edit.html`)
- **진입:** product_detail 섹션 "편집"(pvEdit) → 팝업/모달.
- **section 파라미터:** SECTION_MAP 9종(categories/sizes/print_options/plate_sizes/materials/processes/bundle_qtys/addons/page_rules). 미지원 section은 "알 수 없는 섹션" 오류.
- **구성요소:** 해당 차원 모델의 행 폼(modelform_factory, prd_cd·reg_dt·upd_dt 제외 필드) + **"+ 추가" 빈 행**. del_yn 보유 모델은 논리삭제. FK는 BaseCodeLimitedForm(기초코드 그룹 제한). `addons`는 tmpl_cd FK를 base_prd_cd≠현재상품으로 좁히고 +버튼 제거.
- **자동:** 표시순서·opt_id·item_seq·sel_seq는 빈값이면 채번(present 판단서 제외). 사용처 배지(impact_map).

### 4-4. 옵션 드릴다운 3계층 (`option_drilldown.html`, `_drilldown_edit:1312-1557`)
- **`option_groups`** (1계층, `views.py:1560-1584`): 옵션그룹 목록/편집. "+ 그룹 추가". 다음계층=옵션. 자동채번 `OPT-` 그룹코드.
- **`options`** (2계층, `views.py:1587-1617`): 그룹 내 옵션 목록/편집. "+ 옵션 추가". **selection_preview**(POD 사이트 표시 미리보기: 라디오/체크박스·필수·선택안함 — read-only). 다음=구성요소. 자동채번 옵션코드.
- **`option_items`** (3계층, `views.py:1706-1733`): 옵션 구성요소 목록/편집. "+ 구성요소 추가". **폴리모픽 ref_dim_cd + select2 동적 로드**(dim_choices Ajax). breadcrumb 3단.
- **공통 context:** rows·row_count·breadcrumb·add_label·is_popup·saved·has_errors·add_urls·dim_choices_url.

### 4-5. SKU 드릴다운 2계층 (`sku_drilldown.html`)
- **`sku_list`** (1계층, `views.py:2332-2362`): 상품의 구성템플릿(SKU) 목록/편집. "+ 템플릿 추가". 자동채번 `TMPL_`. parent_field=base_prd_cd.
- **`sku_selections`** (2계층, `views.py:2365-2477`): SKU 선택값 목록/편집. "+ 선택값 추가". 폴리모픽 ref_dim_cd(자재는 mat_cd__usage_cd 분리저장). **저장 직후 제약 평가**→위반 시 warn 배너(세션 메시지). back_url(템플릿 admin 진입 시 복귀).

### 4-6. `constraints` — 제약 폼빌더 (`views.py:1788-2039`, `constraint_builder.html`)
- **진입:** product_detail 제약 "편집"(pvPopup) / 직접 URL.
- **구성요소:** 기존 규칙 목록(del_yn='N') + **폼빌더**(규칙유형 호환/금지/필수동반 + 조건차원/조건값 + 결과차원/결과값 드롭다운 → JSONLogic 자동생성) + 고급 raw_logic 입력(escape hatch) + **검증 미리보기**(validate_url Ajax) + 편집(?edit=rule_cd 역파싱).
- **액션(POST):** save(폼빌더→logic 조립 저장), toggle(use_yn), delete(논리삭제). 저장 성공 시 on_commit→compile_constraints_orm.
- **context:** rule_rows·dim_choices·rule_typ_choices·dim_choices_url·validate_url·edit_rule·edit_logic_pretty·edit_conditions_json.

### 4-7. `dim_choices` (Ajax, `views.py:1736-1775`)
- **GET** `?dim=OPT_REF_DIM.0X` → 해당 상품의 그 차원 등록행 후보 JSON `[{value,label}]`. 자재(복합키)는 `mat_cd__usage_cd`. 미등록 dim=빈 리스트(화이트리스트). select2 동적 로드 소스. (비시각)

### 4-8. `validate_preview` (Ajax POST, `views.py:2178-2226`)
- **POST** 선택조합 → 서버 Python 제약평가 → `{ok, msg, blocked_rule}` JSON. constraint 폼빌더 미리보기용. (비시각)

### 4-9. `impact_detail` — 사용처 상세 standalone (`views.py:2135-2174`, `impact_detail.html`)
- **진입:** 차원행 사용처 배지 클릭 `/admin/impact/?dim=&key1=&key2=`.
- **구성요소:** `v_cfg_ref_impact` 뷰 기반 사용처 행을 src_kind별(OPTION_ITEM/TEMPLATE_SEL) 그룹 표시 + 총건수. **CONSTRAINT 레그 한계 안내**(ref_dim_cd=NULL이라 차원행 단위 매칭 불가, 상품 단위 count만) 항상 표시.
- **context:** dim·key1·key2·option_rows·template_rows·total_count·constraint_count·has_constraint_limit.

### 4-10. `sku_catalog` — 전체 SKU 카탈로그 standalone (`views.py:2480-2513`, `sku_catalog.html`)
- **진입:** `/admin/sku-catalog/` (메뉴 미등록·직접 URL).
- **구성요소:** del_yn='N' AND use_yn='Y' 전 템플릿(base_prd_cd·tmpl_cd 정렬). 행=tmpl·기준상품명·선택값수 + **"편집" 링크**(해당 상품 sku_list로 이동). **보기 전용(인라인 편집 없음).**
- **context:** rows·total.

---

## 5. 횡단 동작 사전 (운영자 체감 공통 동작)

| 동작 | 규칙 | 근거 |
|------|------|------|
| **자동채번(시리얼)** | `AUTO_SERIAL_TABLES`={t_cat_categories, t_clr_color_counts, t_mat_materials, t_prd_products, t_proc_processes, t_siz_sizes, t_prd_templates}. PK 비우면 저장 시 `PREFIX_000000`(최대값+1, zfill). placeholder "비우면 저장 시 자동 채번". 빈테이블 첫행 추론실패→IntegrityError(템플릿은 TMPL_000001 폴백). | `admin.py:33-37,42-51,163-167,196,203-219` |
| **자동채번(기초코드)** | `t_cod_base_codes`: 상위코드 선택+코드 비움 → `{GROUP}.NN`(그룹 내 max+1, 첫행 .01). 둘 다 비면 폼오류. | `admin.py:54-64,198-199`; BaseCodeAdminForm `124-131` |
| **자동채번(옵션/SKU 커스텀)** | option_groups=`_next_opt_grp_code`(OPT-), options=`_next_opt_code`, sku_list=`_next_tmpl_code`(TMPL_), item_seq/sel_seq=스코프 내 max+1. | `views.py:889,908,2233`; drilldown auto_code |
| **YN 드롭다운** | `*_yn` 필드 → Y/N Select(required면 빈옵션 없음). 신규 기본값: use_yn=Y, 기타 _yn=N. **단 YN_ENHANCE_EXCLUDE**(t_dsc_discount_tables, t_dsc_discount_details)는 미적용. | `admin.py:28-30,170-176,221-229` |
| **표시순서(disp_seq) 자동** | 추가 시 disp_seq 비면 같은 상위그룹(자기참조 부모 기준, 없으면 전역) 내 max+1. 저장시점 채번(프리필 안 함). | `admin.py:186-193` |
| **트리 드롭다운(상위 선택)** | `SELF_PARENT_TREES`: upr_cat_cd(exclude_leaf_level, cat_lvl), upr_mat_cd·upr_proc_cd(parents_only). 트리 순서 + 깊이 들여쓰기(nbsp). upr_cod_cd=루트만. | `admin.py:79-120,136-155` |
| **논리삭제(del_yn)** | TPrdTemplates 삭제=del_yn='Y'(물리삭제 아님). 템플릿선택값 인라인 can_delete=False. 커스텀 드릴다운/섹션편집/제약은 _logical_delete. del_yn 보유 모델 목록은 del_yn='N'만 표시. | `admin.py:347-348,335,417-424`; cfg_utils logical_delete |
| **한글 라벨** | verbose_name=db_comment(필드), verbose_name_plural/단수=db_table_comment. __str__=첫 *_nm 값. | `admin.py:236-259,430-433` |
| **placeholder 가이드** | 코드PK 채번대상="비우면 저장 시 자동 채번", 그 외 텍스트/숫자 필드=`_placeholder(model,name)`. | `admin.py:166,175`; `views.py:303` |
| **감사컬럼 readonly** | reg_dt·upd_dt는 changeform readonly. reg_dt는 파이썬 기본값 timezone.now(NULL 전송 방지). | `admin.py:283,257-259` |

---

## 6. 라이브 확인 필요 플래그 (소스만으로 불확실 → 캡처가에 위임)

| # | 항목 | 불확실 이유 | 캡처가 확인 포인트 |
|---|------|-------------|-------------------|
| F-1 | **상품 인라인 부착 여부** | `PRODUCT_INLINES`(`admin.py:324`)는 _make_inline으로 생성되나, TPrdProducts admin의 `inlines`에 **부착되는 코드가 없음**(상품 changeform은 product_change_with_viewer_link 템플릿으로 교체). 실제 상품 표준 편집화면에 9개 차원 인라인이 보이는지 vs 상품뷰어 링크만 보이는지 라이브 확인 필요. | tprdproducts__change 화면에 TabularInline 섹션이 렌더되는가 |
| F-2 | **인라인·메뉴 모두 미등록 모델의 접근성** | 복합PK라 standalone skip + 인라인 미부착 + 메뉴 미등록 = `t_dsc_discount_details`, `t_dsc_grade_discount_rates`, `t_prc_formula_components`, `t_prd_product_discount_tables`, `t_prd_product_price_formulas`, `t_prd_product_prices`, `t_prd_product_sets`. 이들이 **admin 어디에서도 편집 불가**한지(데이터는 DB에만), 혹은 다른 경로가 있는지 확인 필요. | 직접 URL `/admin/catalog/{model}/` 접근 시 404/Not registered 여부 |
| F-3 | **메뉴 미등록 standalone 모델 노출** | `show_all_applications: False`라 사이드바엔 13링크만. 단일PK이나 메뉴 미등록인 모델 없음(13개 모두 메뉴 있음)이지만, Unfold가 등록모델을 "all applications" 안에서 보여주는지 확인. | 사이드바에 메뉴 외 모델 노출 여부 |
| F-4 | **TPrdTemplates change_view redirect 동작** | 직접 URL `/admin/catalog/tprdtemplates/<pk>/change/` 접근 시 sku_selections로 redirect(base_prd_cd 있을 때). base_prd_cd 없는 템플릿은 표준 changeform 표시. 실제 redirect/팝업 동작 라이브 확인. | changelist 행 클릭 시 팝업 vs change URL 직접접근 시 redirect |
| F-5 | **section_edit / 드릴다운 팝업 모달 형태** | is_popup·X_FRAME SAMEORIGIN iframe 모달. 실제 모달/팝업/iframe 중 어느 UI인지, 닫기·부모새로고침 흐름. | pvEdit/pvPopup 클릭 시 화면 전환 형태 |
| F-6 | **option_groups/constraints가 product_detail에서만 진입 가능한가** | URL은 존재하나 사이드바 메뉴엔 없음. product_detail "편집" 버튼이 유일 진입점인지. | 직접 URL 접근 가능 여부(admin_view 인증만 통과하면 가능) |
| F-7 | **Unfold 위젯 외형** | unfold.contrib.filters/forms 향상 위젯이 list_filter·폼에 실제 어떻게 렌더되는지(드롭다운/날짜피커 등) 소스로 단정 불가. | 필터·폼 위젯 시각 캡처 |

---

## 부록: 등록 모델 전수 (34종) — PK·인라인·자동채번 분류

| # | 모델 | db_table | 한글라벨 | PK종류 | standalone | 인라인부모 | 자동채번 | 특수Admin |
|---|------|----------|---------|--------|-----------|-----------|---------|----------|
| 1 | TCatCategories | t_cat_categories | 카테고리 | 단일 | ✅ | — | CAT_시리얼 | 트리DD |
| 2 | TClrColorCounts | t_clr_color_counts | 도수정보 | 단일 | ✅ | — | CLR_시리얼 | — |
| 3 | TCodBaseCodes | t_cod_base_codes | 기초코드정보 | 단일 | ✅ | — | GROUP.NN | BaseCodeAdminForm |
| 4 | TCusCustomers | t_cus_customers | 고객 | 단일 | ✅ | — | — | — |
| 5 | TDscDiscountDetails | t_dsc_discount_details | 수량구간할인상세 | 복합 | ❌skip | **미부착(F-2)** | — | YN exclude |
| 6 | TDscDiscountTables | t_dsc_discount_tables | 수량구간할인 마스터 | 단일 | ✅ | — | — | YN exclude |
| 7 | TDscGradeDiscountRates | t_dsc_grade_discount_rates | 등급별할인율 | 복합 | ❌skip | **미부착(F-2)** | — | — |
| 8 | TMatMaterials | t_mat_materials | 자재정보 | 단일 | ✅ | — | MAT_시리얼 | 트리DD |
| 9 | TPrcComponentPrices | t_prc_component_prices | 구성요소 다차원 단가 | 단일(BigAuto) | ✅ | — | DB자동 | — |
| 10 | TPrcFormulaComponents | t_prc_formula_components | 공식별구성요소 | 복합 | ❌skip | **미부착(F-2)** | — | — |
| 11 | TPrcPriceComponents | t_prc_price_components | 가격구성요소 | 단일 | ✅ | — | — | — |
| 12 | TPrcPriceFormulas | t_prc_price_formulas | 가격공식 | 단일 | ✅ | — | — | — |
| 13 | TPrdProductAddons | t_prd_product_addons | 상품별추가상품 | 복합 | ❌skip | 상품(section_edit addons) | — | — |
| 14 | TPrdProductBundleQtys | t_prd_product_bundle_qtys | 상품별묶음수 | 복합 | ❌skip | 상품(bundle_qtys) | — | — |
| 15 | TPrdProductCategories | t_prd_product_categories | 상품별카테고리 | 복합 | ❌skip | 상품(categories) | — | — |
| 16 | TPrdProductDiscountTables | t_prd_product_discount_tables | 상품별할인테이블 | 복합 | ❌skip | **미부착(F-2)** | — | — |
| 17 | TPrdProductMaterials | t_prd_product_materials | 상품별자재 | 복합 | ❌skip | 상품(materials) | — | — |
| 18 | TPrdProductPageRules | t_prd_product_page_rules | 상품별페이지룰 | OneToOne-PK | ❌skip | 상품(page_rules) | — | — |
| 19 | TPrdProductPlateSizes | t_prd_product_plate_sizes | 상품별판형사이즈 | 복합 | ❌skip | 상품(plate_sizes) | — | — |
| 20 | TPrdProductPriceFormulas | t_prd_product_price_formulas | 상품별가격공식 | 복합 | ❌skip | **미부착(F-2)** | — | — |
| 21 | TPrdProductPrices | t_prd_product_prices | 상품단가 | 복합 | ❌skip | **미부착(F-2)** | — | — |
| 22 | TPrdProductPrintOptions | t_prd_product_print_options | 상품별인쇄옵션 | 복합 | ❌skip | 상품(print_options) | — | — |
| 23 | TPrdProductProcesses | t_prd_product_processes | 상품별공정 | 복합 | ❌skip | 상품(processes) | — | — |
| 24 | TPrdProductSets | t_prd_product_sets | 상품셋트정보 | 복합 | ❌skip | **미부착(F-2)** | — | — |
| 25 | TPrdProductSizes | t_prd_product_sizes | 상품별사이즈 | 복합 | ❌skip | 상품(sizes) | — | — |
| 26 | TPrdProducts | t_prd_products | 상품정보 | 단일 | ✅ | — | PRD_시리얼 | 상품뷰어 링크 템플릿 |
| 27 | TProcProcesses | t_proc_processes | 공정정보 | 단일 | ✅ | — | PROC_시리얼 | 트리DD |
| 28 | TSizSizes | t_siz_sizes | 사이즈정보 | 단일 | ✅ | — | SIZ_시리얼 | — |
| 29 | TPrdProductOptionGroups | t_prd_product_option_groups | 상품옵션그룹 | 복합 | ❌skip | 커스텀 option_groups | OPT- 커스텀 | 드릴다운 |
| 30 | TPrdProductOptions | t_prd_product_options | 상품옵션 | 복합 | ❌skip | 커스텀 options | 커스텀 | 드릴다운 |
| 31 | TPrdProductOptionItems | t_prd_product_option_items | 상품옵션항목 | 복합 | ❌skip | 커스텀 option_items | item_seq | 드릴다운(폴리모픽) |
| 32 | TPrdTemplates | t_prd_templates | 구성템플릿 | 단일 | ✅ | — | TMPL_시리얼 | TPrdTemplatesAdmin(팝업·redirect·논리삭제) |
| 33 | TPrdTemplateSelections | t_prd_template_selections | 템플릿선택값 | 복합 | ❌skip | 구성템플릿(인라인) + 커스텀 sku_selections | sel_seq | 인라인 can_delete=False |
| 34 | TPrdProductConstraints | t_prd_product_constraints | 상품제약규칙 | 복합 | ❌skip | 커스텀 constraints(폼빌더) | — | JSONLogic 폼빌더 |

**합계:** 단일PK standalone = **13** · 복합PK(+OneToOne-PK) inline-only/skip = **21** · 총 **34**.
그중 상품 차원 인라인(section_edit) = 9, 템플릿선택값 인라인 = 1, CPQ 커스텀 드릴다운/폼빌더 = 4(옵션그룹·옵션·옵션항목·제약), **인라인·메뉴 모두 미부착(F-2) = 7**.
