# 09 화면 레퍼런스

[← 목차로](00_index.md)

이 챕터는 시스템의 **모든 화면** 을 빠짐없이 표로 정리합니다(전수 커버리지). 어떤 화면이 있고, 어디로 가며, 무슨 항목이 있는지 한눈에 확인하는 용도입니다. 자세한 작업 절차는 각 업무 챕터를 보세요.

화면은 네 종류로 나눕니다.

1. [표준 관리 화면](#a-표준-관리-화면-좌측-메뉴) — 좌측 메뉴에서 바로 열림
2. [커스텀 상품 뷰어 화면](#b-커스텀-상품-뷰어-화면) — 상품을 펼쳐 세부 구성 관리
3. [화면이 없는 데이터](#c-화면이-없는-데이터-편집-불가) — 관리자에 안 나타남(DB 전용)
4. [비시각 응답](#d-비시각-응답-화면-아님) — 화면이 아닌 내부 동작

---

## A. 표준 관리 화면 (좌측 메뉴)

좌측 메뉴에서 열리는 13개 데이터 + 인증 2개. 각각 **목록** 과 **추가/수정 폼** 이 있습니다. URL은 `/admin/catalog/{모델}/` 형식.

| # | 메뉴 라벨 | 모델 (`db_table`) | 목록 컬럼(앞부분) | 자동채번 | 자세히 |
|---|-----------|-------------------|-------------------|----------|--------|
| 1 | 상품정보 | `t_prd_products` | 상품코드·MES품목코드·상품명·상품유형·반제품역할·비규격여부·비규격가로 | PRD_ | [01](02_product-register.md) |
| 2 | 자재정보 | `t_mat_materials` | 자재코드·자재명·자재유형·상위자재·선택유형·최대선택수·가로·세로 | MAT_ | [06-1](07_masters.md) |
| 3 | 사이즈정보 | `t_siz_sizes` | 사이즈코드·사이즈명·작업/재단 가로·세로·여백 | SIZ_ | [06-2](07_masters.md) |
| 4 | 도수정보 | `t_clr_color_counts` | 도수코드·도수명·채널수·사용여부·비고·삭제 | CLR_ | [06-3](07_masters.md) |
| 5 | 공정정보 | `t_proc_processes` | 공정코드·공정명·상위공정·상세옵션·표시순서·사용여부 | PROC_ | [06-4](07_masters.md) |
| 6 | 카테고리 | `t_cat_categories` | 카테고리코드·명·상위·레벨·표시순서·사용여부 | CAT_ | [06-5](07_masters.md) |
| 7 | 기초코드정보 | `t_cod_base_codes` | 코드·명·상위·표시순서·사용여부·비고 | GROUP.NN | [06-6](07_masters.md) |
| 8 | 가격공식 | `t_prc_price_formulas` | 공식코드·명·유형·비고·사용여부 | 직접 입력 | [07-1](08_pricing.md) |
| 9 | 가격구성요소 | `t_prc_price_components` | 구성요소코드·명·유형·비고·사용여부 | 직접 입력 | [07-2](08_pricing.md) |
| 10 | 구성요소 다차원 단가 | `t_prc_component_prices` | 단가ID·구성요소·적용일자·사이즈·도수·자재·코팅면수·묶음수 | DB 자동 | [07-3](08_pricing.md) |
| 11 | 수량구간할인 | `t_dsc_discount_tables` | 할인테이블코드·명·비고·사용여부 | 직접 입력 | [07-4](08_pricing.md) |
| 12 | 고객 | `t_cus_customers` | 고객코드·명·등급·등록일자·사용여부 | 직접 입력 | [07-5](08_pricing.md) |
| 13 | 구성 템플릿(SKU) | `t_prd_templates` | 템플릿명·기준상품·구성요약·기본수량·사용여부 | TMPL_ | [04](05_sku-templates.md) |
| 14 | 사용자 | `auth_user` | 사용자명·이메일·이름·권한 | (Django) | 권한 관리 영역 |
| 15 | 그룹 | `auth_group` | 그룹명 | (Django) | 권한 관리 영역 |

### 화면별 캡처 보유 현황 (표준)

모든 표준 모델은 목록·추가 폼 스크린샷을 갖추고 있습니다.

| 모델 | 목록 캡처 | 추가폼 캡처 |
|------|-----------|-------------|
| 상품정보 | `tprdproducts__changelist.png` | `tprdproducts__changeform.png` (+ 편집 `tprdproducts__change.png`) |
| 자재정보 | `tmatmaterials__changelist.png` | `tmatmaterials__changeform.png` (+ 드롭다운 `tmatmaterials__changeform-dropdown.png`) |
| 사이즈정보 | `tsizsizes__changelist.png` | `tsizsizes__changeform.png` |
| 도수정보 | `tclrcolorcounts__changelist.png` | `tclrcolorcounts__changeform.png` |
| 공정정보 | `tprocprocesses__changelist.png` | `tprocprocesses__changeform.png` |
| 카테고리 | `tcatcategories__changelist.png` | `tcatcategories__changeform.png` |
| 기초코드정보 | `tcodbasecodes__changelist.png` | `tcodbasecodes__changeform.png` |
| 가격공식 | `tprcpriceformulas__changelist.png` | `tprcpriceformulas__changeform.png` |
| 가격구성요소 | `tprcpricecomponents__changelist.png` | `tprcpricecomponents__changeform.png` |
| 구성요소 다차원 단가 | `tprccomponentprices__changelist.png` | `tprccomponentprices__changeform.png` |
| 수량구간할인 | `tdscdiscounttables__changelist.png` | `tdscdiscounttables__changeform.png` |
| 고객 | `tcuscustomers__changelist.png` | `tcuscustomers__changeform.png` |
| 구성 템플릿(SKU) | `tprdtemplates__changelist.png` | `tprdtemplates__changeform.png` |
| 사용자 | `auth_user__changelist.png` | (Django 표준 — 본 매뉴얼 범위 밖) |
| 그룹 | `auth_group__changelist.png` | (Django 표준 — 본 매뉴얼 범위 밖) |

> ℹ️ **구성 템플릿(SKU) 목록의 특이 동작:** 목록에서 행을 클릭하면 표준 수정 폼이 아니라 해당 상품의 **SKU 선택값 화면으로 이동(또는 팝업)** 합니다. SKU 편집은 [04 구성 템플릿(SKU)](05_sku-templates.md) 를 보세요.

---

## B. 커스텀 상품 뷰어 화면

상품을 펼쳐 세부 구성을 다루는 특수 화면입니다. 좌측 메뉴 "상품 뷰어"에서 시작합니다.

| # | 화면 | 무엇을 하나 | 진입 | 캡처 | 자세히 |
|---|------|------------|------|------|--------|
| 1 | 상품 뷰어(홈) | 전 상품 목록·검색 | 메뉴 "상품 뷰어" / 로그인 후 홈 | `product_viewer__home.png` | [1-4](02_product-register.md) |
| 2 | 상품 상세 | 11개 섹션 집계·편집 진입 | 상품 클릭 | `product_detail__detail.png` | [1-4](02_product-register.md) |
| 3 | 섹션 편집 | 9개 세부 구성 행 편집 | 상세 섹션 "편집" | `section_edit__sizes.png` (사이즈 예시·9섹션 동형) | [02](03_product-sections.md) |
| 4 | 옵션그룹(1계층) | 선택 묶음 | 상세 "옵션그룹" "편집" | `option_groups__options-l1.png` | [03-1](04_options.md) |
| 5 | 옵션+구성요소(2·3계층) | 옵션·자재/공정 묶기 | 그룹 "열기 ›" | `options__options-l2.png` | [03-2](04_options.md) |
| 6 | SKU 목록(1계층) | 구성템플릿 만들기 | 상세 "구성템플릿(SKU)" "편집" | `sku_list__sku-l1.png` | [04-1](05_sku-templates.md) |
| 7 | SKU 선택값(2계층) | 차원·값 고정 | SKU "열기 ›" | `sku_selections__sku-l2.png` | [04-2](05_sku-templates.md) |
| 8 | 제약 규칙 | 선택 제한 규칙 폼빌더 | 상세 "제약규칙" "편집" | `constraints__constraints.png` | [05-1](06_constraints.md) |
| 9 | 사용처 상세 | 차원 값이 쓰이는 곳 조회 | 사용처 배지 클릭 | `impact_detail__impact.png` | [05-2](06_constraints.md) |
| 10 | 전체 SKU 카탈로그 | 모든 SKU 둘러보기(보기 전용) | 주소 `/admin/sku-catalog/` | `sku_catalog__catalog.png` | [05-3](06_constraints.md) |

> ℹ️ **섹션 편집(3번)은 9개 세부 구성이 모두 같은 형태** 입니다(사이즈/도수·인쇄옵션/판형/자재/공정/묶음수/추가상품/페이지룰/카테고리). 대표로 사이즈 화면 한 장을 캡처했습니다. 각 섹션의 입력 항목은 [02 상품 하위정보](03_product-sections.md) 의 표를 보세요.
>
> ℹ️ **옵션 3계층(`option_items`)은 별도 화면이 아닙니다.** 라이브에서는 옵션 편집 화면(2계층) 안에서 각 옵션 카드 아래에 구성요소가 인라인으로 함께 표시·편집됩니다. 그래서 3계층 전용 스크린샷은 없고, 2계층 캡처(`options__options-l2.png`)에 포함되어 있습니다.

---

## C. 화면이 없는 데이터 (편집 불가)

아래 데이터는 데이터베이스에는 있지만 **관리자 화면이 전혀 없습니다.** 직접 주소로 들어가도 "Not Found"(404)가 뜹니다(라이브 확인됨). 화면 편집이 불가능하며, 데이터는 개발 담당자가 데이터베이스에서 직접 다룹니다.

`[스크린샷 없음: 설계상 관리자에 노출되지 않는 모델 — 직접 URL 접근 시 404]`

| 모델 (`db_table`) | 한글 | 현재 행수 | 비고 |
|-------------------|------|-----------|------|
| `t_dsc_discount_details` | 수량구간할인상세 | 35 | 할인표의 실제 구간·할인율 |
| `t_dsc_grade_discount_rates` | 등급별할인율 | 0 (빈) | 고객 등급별 할인 |
| `t_prc_formula_components` | 공식별구성요소 | 85 | 공식에 묶인 구성요소 |
| `t_prd_product_discount_tables` | 상품별할인테이블 | 98 | 상품↔할인표 연결 |
| `t_prd_product_price_formulas` | 상품별가격공식 | 64 | 상품↔가격공식 연결 |
| `t_prd_product_prices` | 상품단가 | 0 (빈) | 상품 직접 단가 |
| `t_prd_product_sets` | 상품셋트정보 | 28 | 셋트 상품 구성 |
| `t_prd_template_prices` | 템플릿단가 | 0 (빈) | SKU 단가 |

> ⚠️ **운영 영향:** 가격이 상품과 연결되는 핵심 데이터(상품별 가격공식·상품별 할인테이블·공식별 구성요소)가 여기 포함됩니다. 즉 **가격 계산의 연결 부분은 운영자가 화면에서 바꿀 수 없습니다.** 가격이 잘못 나오면 개발 담당자에게 문의하세요.

---

## D. 비시각 응답 (화면 아님)

아래는 화면이 아니라, 다른 화면이 내부적으로 호출하는 **데이터 응답** 입니다. 운영자가 직접 열 일은 없습니다.

`[스크린샷 없음: 화면이 아닌 내부 데이터 응답(JSON) — 다른 화면이 자동 호출]`

| 이름 | 하는 일 | 어디서 쓰이나 |
|------|---------|---------------|
| 차원 후보 조회 (`dim_choices`) | 옵션·SKU 구성요소 드롭다운의 선택지 목록을 채움 | 옵션 구성요소·SKU 선택값 화면 |
| 제약 검증 (`validate_preview`) | 선택 조합이 제약에 걸리는지 즉시 판정 | 제약 폼빌더 "검증 미리보기" |

---

## 입력 항목 빠른 사전 (코드값·필수 요약)

자주 쓰는 입력값의 코드 도메인·필수 여부를 한 표로 모았습니다(라이브 권위, 2026-06-10).

| 항목 | 어디서 | 필수 | 값 |
|------|--------|------|-----|
| 상품유형 (`prd_typ_cd`) | 상품 | **필수** | 완제품·반제품·기성상품·디자인상품·추가상품 |
| 수량단위 (`qty_unit_typ_cd`) | 상품·묶음 | 선택 | EA·매·권·세트 |
| 반제품역할 (`semi_role_cd`) | 반제품 상품 | 선택 | 내지·표지·면지·간지·투명커버 |
| 자재유형 (`mat_typ_cd`) | 자재 | **필수** | 종이·필름·아크릴·금속·원단·가죽·부속·실사소재·파우치·악세사리·스티커 |
| 선택유형 (`sel_typ_cd`) | 자재·옵션그룹 | 선택 | 단일·다중 |
| 용도 (`usage_cd`) | 상품별자재 | **필수** | 내지·표지·면지·간지·투명커버·표지타입·공통 |
| 출력용지유형 (`output_paper_typ_cd`) | 판형 | 선택 | 국전계열·46계열·기타 |
| 도수 (`front/back_colrcnt_cd`) | 인쇄옵션 | **필수** | 인쇄 안 함·1도(흑백)·2도·3도·CMYK 4도 |
| 옵션참조차원 (`ref_dim_cd`) | 옵션·SKU 구성요소 | 옵션은 필수 | 사이즈·판형·자재·공정·묶음수·도수·셋트 |
| 공식유형 (`frm_typ_cd`) | 가격공식 | **필수** | 합산형·단순형 |
| 가격구성요소유형 (`comp_typ_cd`) | 가격구성요소 | 선택 | 인쇄비·코팅비·용지비·후가공비·박형압비·완제품비 |
| 제약규칙유형 (`rule_typ_cd`) | 제약 | 선택 | 금지·필수동반 *(호환은 중지)* |
| 고객등급 (`grade_cd`) | 고객 | 선택 | VIP·일반 |
| 인쇄면 (`print_side`) | 인쇄옵션 | **필수** | **자유 입력**(고정 아님): 현재 5가지 사용 — 단면·양면·투명테두리·배면양면·풀빼다 |
| 출력파일유형 (`output_file_typ`) | 판형 | 선택 | **자유 입력**: JPG·PDF·AI·AI(칼선) 등 |
| 모든 `*_yn` | 거의 모든 화면 | 대개 필수 | **Y 또는 N만** |

---

[← 이전: 07 가격·할인·고객](08_pricing.md) · [목차](00_index.md) · [다음: 10 부록 →](10_appendix.md)
