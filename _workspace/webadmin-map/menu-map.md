# 후니 webadmin 화면 지도 (menu-map)

> 목적 — 「이 개념은 어느 화면이 주인이고, 그 화면이 DB에 무엇을 쓰는가」를 **재탐색 없이** 답하게 만든다.
> 다음 세션이 이 문서 하나로 admin 구조 전체를 파악할 수 있어야 한다.
>
> 작성일: 2026-08-28 · 원천: 소스 정적 판독(라이브 화면·라이브 DB 미접속)

---

## 0. 읽은 원천 / 읽지 않은 원천 (정직 고지)

원천 우선순위는 `.claude/rules/moai/domains/huni-webadmin-manual-first.md` §[HARD] 원천 우선순위를 따랐다.

### 실제로 읽은 것

| 순위 | 파일 | 범위 |
|---|---|---|
| 1 | `raw/webadmin/tools/manual_content.py` | **전문 924줄 정독** |
| 2 | `raw/webadmin/tools/widget_manual_content.py` | 구조 grep(SCREENS·COMPONENTS 목록·id/menu/path) — 본문 전문은 미독 |
| 4 | `raw/webadmin/webadmin/config/settings.py` | `UNFOLD["SIDEBAR"]["navigation"]` 전문 (L106-235) |
| 4 | `raw/webadmin/webadmin/config/urls.py` | 전문 379줄 |
| 4 | `raw/webadmin/webadmin/catalog/admin.py` | 헤더 L1-60 · 제네릭 등록 루프 L1974-2199 · 특수분기 |
| 4 | `raw/webadmin/webadmin/catalog/models.py` | `db_table` / `db_table_comment` / `CompositePrimaryKey` 전수 grep + 일부 클래스 정독 |
| 4 | `raw/webadmin/webadmin/catalog/views.py` | `SECTIONS`(L728-764) · `_MD_REG`(L1027-1059) · `_IMPACT_SECTIONS`(L3936-3944) |
| 4 | `raw/webadmin/webadmin/catalog/price_views.py` | `price_product_detail`(L1014-1100) · 쓰기 대상 grep |
| 4 | `catalog/{tmpl_combo,paper,main_img,guide,start_price,design,widget}_views.py` | 쓰기 대상(`objects.create/update`) grep만 |

### 읽지 않은 것 (이 문서의 한계)

- **라이브 화면(gstack)** — 미접속. 「소스에는 있으나 화면에서 안 보이는 것」은 이 문서로 판정 불가.
- **라이브 DB** — 미접속. 행 수·실제 사용 여부는 이 문서에 없다.
- `raw/webadmin/docs/admin-manual.html` 등 생성 HTML — 원고(`manual_content.py`)의 파생물이므로 생략.
- `widget_manual_content.py` 본문 — 위젯빌더 내부 컴포넌트 속성 16종은 그 문서가 정본이며 여기서 다루지 않는다.
- `views.py` 4,626줄 중 위 3구간 외 — 화면 존재 여부 판정에는 불필요.

---

## 1. 전체 메뉴 트리 (사이드바 전수)

**사이드바의 정본은 `config/settings.py` `UNFOLD["SIDEBAR"]["navigation"]`** 이다 —
매뉴얼의 「사이드바 메뉴 지도」(`manual_content.py:28-41`)는 요약이라 항목이 몇 개 빠져 있다(§4-C 참조).

출처 표기: `S`=settings.py 사이드바 · `U`=urls.py · `M`=manual_content.py SCREENS · `W`=widget_manual_content.py SCREENS · `A`=admin.py

### 그룹 1 — 상품 (`settings.py:110-132`)

| # | 메뉴명 | URL | 뒤에 있는 것 | 출처 |
|---|---|---|---|---|
| 1-1 | 상품정보 | `/admin/catalog/tprdproducts/` | 표준 admin `TPrdProducts` (+`ProductCategoriesInline`·`ProductSetsInline`) | S:113 · A:2012-2062 |
| 1-2 | **상품 뷰어** | `/admin/product-viewer/` | 커스텀 `views.product_viewer` | S:115 · U:320 · M:142 |
| 1-3 | 셋트상품 관리 | `/admin/set-products/` | 커스텀 `views.set_products` | S:117 · U:323 · M:201 |
| 1-4 | 추가상품 템플릿 | `/admin/catalog/tprdtemplates/` | 표준 admin `TPrdTemplatesAdmin`(선택값 인라인) | S:119 · A:1834,2179 |
| 1-5 | 상품별 Edicus 템플릿 연결 | `/admin/edicus-template-md/` | 커스텀 `edicus_views.edicus_template_md` | S:121 · U:41 · M:433 |
| 1-6 | 상품별 작업가이드 파일 | `/admin/guide-file-md/` | 커스텀 `guide_views.guide_file_md` | S:123 · U:61 · **M 없음** |
| 1-7 | 상품별 메인이미지 | `/admin/main-img-md/` | 커스텀 `main_img_views.main_img_md` | S:125 · U:80 · **M 없음** |
| 1-8 | 상품별 시작가 | `/admin/start-price/` | 커스텀 `start_price_views.start_price_md` | S:127 · U:102 · M:449 |
| 1-9 | 상품별 디자인 | `/admin/design-md/` | 커스텀 `design_views.design_md` | S:129 · U:110 · M:488 |

### 그룹 2 — 기준정보 (마스터) (`settings.py:133-154`)

| # | 메뉴명 | URL | 뒤에 있는 것 | 출처 |
|---|---|---|---|---|
| 2-1 | 카테고리 | `/admin/category-master/` | 커스텀 `views.category_master` (밀러 칼럼 3단) | S:136 · U:336 · M:268 |
| 2-2 | 자재정보 | `/admin/master/mat/` | 제네릭 `views.master_detail` (`_MD_REG["mat"]`) | S:138 · U:333 · M:282 |
| 2-3 | 용지 관리 | `/admin/paper-management/` | 커스텀 `paper_views.paper_management` | S:141 · U:293 · M:250 |
| 2-4 | 사이즈정보 | `/admin/catalog/tsizsizes/` | 표준 admin `TSizSizes` | S:143 · A:2129 · M:539 |
| 2-5 | 도수정보 | `/admin/catalog/tclrcolorcounts/` | 표준 admin `TClrColorCounts` | S:145 |
| 2-6 | 인쇄옵션 | `/admin/catalog/tprtprintoptions/` | 표준 admin `TPrtPrintOptions` (`print_side` 제외) | S:147 · A:2125-2128 |
| 2-7 | 공정정보 | `/admin/master/proc/` | 제네릭 `master_detail` (`_MD_REG["proc"]`) **+ 책등 계산 패널** | S:149 · U:333 · views.py:1035-1049 · M:295,301 |
| 2-8 | 기초코드정보 | `/admin/basecode-master/` | 커스텀 `views.basecode_master` (자기참조 2단) | S:151 · U:326 · M:298 |

> ⚠ `/admin/master/basecode/` 도 살아 있다(`_MD_REG["basecode"]`, views.py:1028). 사이드바는 `basecode_master` 쪽을 쓴다 — **경로 2개, 화면 성격 유사**. 라이브 대조 필요.

### 그룹 3 — 가격 관리 (`settings.py:155-175`)

| # | 메뉴명 | URL | 뒤에 있는 것 | 출처 |
|---|---|---|---|---|
| 3-1 | 가격공식 | `/admin/price-formula-md/` | 커스텀 `price_views.price_formula_md` | S:162 · U:35 · M:352 |
| 3-2 | 가격구성요소 | `/admin/price-component-md/` | 커스텀 `price_views.price_component_md` | S:164 · U:38 · M:366 |
| 3-3 | 할인테이블(수량구간) | `/admin/discount-table-md/` | 커스텀 `price_views.discount_table_md` | S:166 · U:126 · M:389 |
| 3-4 | **가격 뷰어** | `/admin/price-viewer/` | 커스텀 `price_views.price_viewer` | S:168 · U:32 · M:316 |
| 3-5 | 가격 시뮬레이터 | `/admin/price-simulator/` | 커스텀 `price_views.price_simulator` | S:170 · U:161 · M:338 |

> 원본 changelist 3종(`tprcpriceformulas`·`tprcpricecomponents`·`tdscdiscounttables`)은 **등록은 되어 있으나 사이드바에서 숨김**(`settings.py:159-161` 주석). URL 직접 접근은 가능하다.

### 그룹 4 — 위젯 (`settings.py:176-187`)

| # | 메뉴명 | URL | 뒤에 있는 것 | 출처 |
|---|---|---|---|---|
| 4-1 | 위젯빌더 | `/admin/widget-builder/` | `widget_views.widget_builder` | S:180 · U:173 · M:410 · W:162~324(전 장) |
| 4-2 | 상품별 위젯 관리 | `/admin/widget-manager/` | `widget_views.widget_manager` | S:182 · U:203 · W:328 |
| 4-3 | 위젯 템플릿 관리 | `/admin/widget-templates/` | `widget_views.widget_template_screen` | S:184 · U:212 · W:351 |

### 그룹 5~8 — 고객·권한·문서 (`settings.py:188-233`)

| # | 메뉴명 | URL | 뒤에 있는 것 | 출처 |
|---|---|---|---|---|
| 5-1 | 고객관리 › 고객 | `/admin/catalog/tcuscustomers/` | 표준 admin `TCusCustomers` | S:191 |
| 6-1 | 인증 및 권한 › 사용자 | `/admin/auth/user/` | `UserAdmin` (Group 은 unregister) | S:198 · A:2247,2257 |
| 7-1 | 문서 › 퀵스타트 가이드 | `/admin/quickstart/` | `views.quickstart` (정적 HTML 서빙) | S:209 · U:369 |
| 7-2 | 문서 › 메뉴얼 | `/admin/manual/` | `views.manual` | S:211 · U:371 |
| 7-3 | 문서 › 위젯빌더 메뉴얼 | `/admin/widget-manual/` | `views.widget_manual` | S:213 · U:373 |
| 7-4 | 문서 › 테이블 명세서 | `/admin/table-spec/` | `views.table_spec` (**superuser 한정**) | S:215-217 · U:374 |
| 8-1 | 개발자 문서 › SDK 개발가이드 | `/sdk/guide/` | `views.sdk_guide` (**비로그인 공개**) | S:228 · U:230 |
| 8-2 | 개발자 문서 › 임베드 라이브 데모 | `/sdk/demo/` | `views.sdk_demo` (**비로그인 공개**) | S:230 · U:231 |

### 사이드바에 없는 화면 (URL 로만 도달)

| 화면 | URL | 진입 경로 | 출처 |
|---|---|---|---|
| 옵션 드릴다운 (그룹→옵션→항목) | `/admin/product-viewer/{prd}/options/[{grp}/[{opt}/]]` | 상품 뷰어 섹션 링크 | U:343-348 · M:176 |
| 제약 폼빌더 | `/admin/product-viewer/{prd}/constraints/` | 상품 뷰어 | U:358 · M:185 |
| 상품별 추가상품 템플릿 | `/admin/product-viewer/{prd}/templates/[{tmpl}/]` | 추가상품 템플릿 카탈로그의 [편집] | U:350-353 · M:215 |
| 추가상품 템플릿 카탈로그 | `/admin/sku-catalog/` | 직접 URL | U:365 · M:194 |
| **사용처(영향도) 상세** | `/admin/impact/` | 상품 뷰어 섹션의 사용처 배지 | U:363 · **M 화면섹션 없음** |
| 구성템플릿 조합(내부 대조표) | `/admin/tmpl-combo-md/` | 직접 URL | U:52 · M:232 · **S 없음** |
| 단가표 그리드 편집(팝업) | `/admin/price-viewer/comp/{comp}/edit/` | 가격구성요소 [단가표 편집] | U:133 · M:378 |
| 할인 구간 그리드 편집(팝업) | `/admin/discount/{tbl}/edit/` | 할인테이블 [편집] | U:166 · M:401 |
| 가격 구조 다이어그램 | `/admin/price-viewer/{prd}/diagram/` | 가격 뷰어 [가격 구조 보기] | U:146 · M:331 |
| 섹션 편집 팝업 | `/admin/product-viewer/{prd}/edit/{section}/` | 상품 뷰어 각 섹션 [편집] | U:340 |

### 홈 / 로그인

- `/` → `/admin/` 리다이렉트 (`urls.py:30`)
- `/admin/` → **상품 뷰어로 리다이렉트** (기본 대시보드 대신, `urls.py:377`)
- `/admin/login/` → Django 기본 (`urls.py:378` include)
- 헤더 우상단 「사이트 보기」 링크는 제거됨 (`urls.py:25` `admin.site.site_url = None`)

---

## 2. 화면별 한 줄 설명 (매뉴얼 원문 기준)

매뉴얼에 있는 것은 **매뉴얼의 말** 그대로, 없는 것은 「매뉴얼 없음」으로 표시하고 소스 근거만 적는다.

| 화면 | 운영자가 이걸로 하는 일 | 근거 |
|---|---|---|
| 상품 뷰어 | 「가장 많이 쓰는 작업 화면. 왼쪽 트리에서 상품을 고르면 오른쪽에 그 상품의 옵션·추가상품 템플릿·제약 등 모든 구성이 모여, 섹션별로 편집」 | manual:143 |
| 셋트상품 관리 | 「여러 상품을 묶은 셋트상품을 만들고 구성원·옵션을 편집」 | manual:202 |
| 상품별 추가상품 템플릿 | 「기준 상품에 옵션 조합을 미리 지정해 둔 '추가상품 템플릿'을 상품별로 만들고 고침. 여기서 만든 템플릿이 다른 상품의 '추가상품' 섹션에 끼워 팔 후보로 올라감」 | manual:216 |
| 추가상품 템플릿 카탈로그 | 「전체 추가상품 템플릿 카탈로그. 상품별 템플릿 편집 진입점」 | manual:199 |
| 구성템플릿 조합 | 「옵션 조합이 실제로 어떤 자재로 만들어지는지 적어 두는 내부 대조표. 고객 화면에는 절대 안 나오고, 주문이 들어왔을 때 어떤 자재로 생산할지 결정」 · **매핑이 비면 주문이 막힘** | manual:233,236 |
| 용지 관리 | 「종이 자재를 현업이 쓰는 말(평량·두께·거래처)로 한 화면에서 등록·수정하고, 용지 단가까지 함께 편집. 자재정보 화면의 종이 전용 간편 버전」 | manual:251 |
| 카테고리 | 「상품 분류(대>중>소)를 왼쪽부터 단계적으로 선택하며 관리하는 밀러 칼럼 화면」 | manual:269 |
| 자재·공정·기초코드 (마스터-디테일) | 「왼쪽 상위 항목을 고르면 오른쪽에 그 하위 항목 표가 열리는 2단 마스터-디테일. 자재정보·공정정보·기초코드정보가 모두 같은 방식」 | manual:283 |
| 공정정보 › 책등 계산 설정 패널 | 「설정을 저장한 공정만 책등 계산에 참여」 (여유분·올림 방식·표지 두께 포함·규격표) | manual:313, 653-672 |
| 가격 뷰어 | 「상품별 가격의 원천(직접단가/가격공식/할인테이블)을 시계열(적용일)로 연결·관리」 | manual:317 |
| 가격 구조 다이어그램 | 「가격공식이 어떤 구성요소들의 합으로 이뤄지는지 한눈에」 | manual:336 |
| 가격 시뮬레이터 | 「실제 주문 조건을 넣어 최종가가 어떻게 계산되는지 구성요소 단위로 확인(끼워팔기·셋트 지원)」 | manual:339 |
| 가격공식 (MD) | 「가격공식을 왼쪽 목록 + 오른쪽 편집(구성요소 포함)으로 관리」 | manual:353 |
| 가격구성요소 (MD) | 「구성요소의 속성을 편집하고, 차원별 단가표(그리드) 편집으로 진입」 | manual:367 |
| 단가표 그리드 편집 | 「엑셀처럼 붙여넣기·정렬·필터가 되며, 차원(사이즈·수량 등)별 단가를 입력」 | manual:387 |
| 할인테이블 (MD) | 「수량 구간별 할인을 왼쪽 목록 + 오른쪽(폼·사용처·구간 그리드)으로 관리」 | manual:390 |
| 위젯빌더 | 「고객이 주문할 때 보는 주문서 화면(주문위젯)을 끌어다 놓아 만드는 편집기」 | manual:411 |
| 상품별 Edicus 템플릿 연결 | 「웹 편집기(Edicus)에서 쓸 템플릿을 옵션 조합별로 연결. 고객이 '편집기로 만들기'를 눌렀을 때 어떤 템플릿이 열릴지가 여기서 정해짐」 | manual:434 |
| 상품별 시작가 | 「자사몰 상품 목록에 보여줄 시작가(위젯 첫 화면 기본 사양 가격)를 상품별로 관리. 자동 계산 결과와 실패 사유가 한 표에 모이고, 급한 상품은 수기 가격으로 임시 대응」 | manual:450 |
| 상품별 디자인 | 「포토북처럼 템플릿 디자인이 여러 개인 상품의 디자인 목록을 관리. 디자인 = 고정 사양 묶음」 | manual:489,492 |
| 사이즈정보 (표준 화면 예시) | 「표준 관리 화면의 공통 동작을 보여주는 예시」 | manual:540 |
| 상품별 위젯 관리 | 「어떤 상품에 위젯이 몇 개 있고 무엇이 게시됐는지 한눈에 보고, 게시를 내리거나 다시 올림」 | widget_manual:328 |
| 위젯 템플릿 관리 | 「어떤 위젯이 템플릿으로 잡혀 있는지 보고, 지정·해제하고, 무엇이 들어 있는지 확인」 | widget_manual:351 |
| **상품별 작업가이드 파일** | **매뉴얼 없음.** 소스: 좌 완제품 목록 + 우 파일 행 목록, S3 presign 업로드·논리삭제 | urls.py:60-77 |
| **상품별 메인이미지** | **매뉴얼 없음.** 소스: 좌 완제품 목록(이미지수·대표썸네일·샵바이 배지) + 우 이미지 행 목록, 저장 직후 샵바이 동기화 | urls.py:78-99 |
| **사용처(영향도) 상세** | **매뉴얼에 화면 섹션 없음.** 용어집·FAQ 에만 등장. 소스: `v_cfg_ref_impact` 뷰 조회 | urls.py:363 · views.py:3948-3968 |

---

## 3. 화면 → 테이블 쓰기 지도 (load-bearing)

「X 를 바꾸려면 어느 화면인가」의 답. 테이블명은 전부 `models.py` 의 `db_table` 선언에서 확인했다(짐작 없음).

### 3-A. 두 적재 표면 (도메인 룰이 지적한 구분)

| 표면 | 무엇인가 | 특징 |
|---|---|---|
| **표준 changeform** | `/admin/catalog/<model>/` — `admin.py` 제네릭 루프가 등록한 Django admin 목록·편집 화면 | 단일PK 모델 34종만. 자동채번·YN 드롭다운·논리삭제 공통 적용 |
| **상품뷰어 / 가격뷰어 임베드 패널** | `/admin/product-viewer/…`·`/admin/price-viewer/…` 안의 섹션·팝업·그리드 | **복합PK 24종은 여기서만 편집 가능**(표준 changelist 자체가 없음) |

복합PK 모델은 `admin.py:2007-2010` 에서 등록이 스킵된다 — Django 5.2 admin 이 복합PK 단독 등록을 지원하지 않기 때문. 즉 **`t_prd_product_*` 계열 대부분은 표준 admin 화면이 존재하지 않는다.**

### 3-B. 상품뷰어 섹션 → 테이블 (`views.py:728-764` `SECTIONS`)

| 섹션 key | 화면 표기 | 테이블 | 자연키(prd_cd 제외) |
|---|---|---|---|
| `sizes` | 사이즈 | `t_prd_product_sizes` | `siz_cd` |
| `print_options` | 도수 / 인쇄옵션 | `t_prd_product_print_options` | `opt_id` |
| `plate_sizes` | 판형 | `t_prd_product_plate_sizes` | `siz_cd`,`item_siz_cd` |
| `materials` | 자재 | `t_prd_product_materials` | `mat_cd`,`usage_cd` |
| `processes` | 공정 | `t_prd_product_processes` | `proc_cd` |
| `bundle_qtys` | 묶음수 | `t_prd_product_bundle_qtys` | `bdl_qty` |
| `addons` | 추가상품 | `t_prd_product_addons` | `tmpl_cd` |
| `page_rules` | 페이지룰 | `t_prd_product_page_rules` | `print_opt_cd` |

> 카테고리 섹션은 뷰어에서 **제거**되어 상품정보 changeform 인라인으로 이관됨(`views.py:729`, `admin.py:2018`).

### 3-C. 상품뷰어 하위 화면 → 테이블

| 화면 | URL | 쓰는 테이블 |
|---|---|---|
| 옵션 드릴다운 1단 | `…/options/` | `t_prd_product_option_groups` |
| 옵션 드릴다운 2단 | `…/options/{grp}/` | `t_prd_product_options` |
| 옵션 드릴다운 3단 | `…/options/{grp}/{opt}/` | `t_prd_product_option_items` |
| 제약 폼빌더 | `…/constraints/` | `t_prd_product_constraints` (JSONLogic) |
| 상품별 템플릿 목록 | `…/templates/` | `t_prd_templates` |
| 템플릿 선택값 | `…/templates/{tmpl}/` | `t_prd_template_selections` |

### 3-D. 가격 뷰어 상세 패널 → 테이블 (`price_views.py:1014-1100`)

| 패널 | 쓰는 테이블 | 근거 |
|---|---|---|
| 직접단가 (상품) | `t_prd_product_prices` | price_views.py:1017, 1632 |
| 가격공식 연결 | `t_prd_product_price_formulas` | :1023, 1644 |
| 공식 구성요소(읽기) | `t_prc_formula_components` → `t_prc_price_components` → `t_prc_component_prices` | :1032-1046 |
| **추가상품 템플릿 직접단가** | **`t_prd_template_prices`** | :1055-1078, 1685 — **매뉴얼 누락 M-1** |
| 할인테이블 연결 (전체/구성요소 스코프) | `t_prd_product_discount_tables` (`comp_cd` ''=총액) | :1080-1097, 1667 |
| 등급 할인(읽기) | `t_dsc_grade_discount_rates` | models.py:151 |

전 패널의 저장 엔드포인트는 `price_source_save` 하나(`urls.py:148`, `price_views.py:1604`).

### 3-E. 커스텀 화면 → 테이블 (전수)

| 화면 | 쓰는 테이블 | 근거 |
|---|---|---|
| 용지 관리 | `t_mat_materials` + `t_prc_component_prices`(COMP_PAPER) | paper_views.py:362,528,576 |
| 자재정보 (`/master/mat/`) | `t_mat_materials` (팝업은 표준 changeform 재사용) | views.py:1050 · admin.py:2070 |
| 공정정보 (`/master/proc/`) | `t_proc_processes` | views.py:1035 |
| 공정정보 › 책등 계산 패널 | `t_proc_spine_calcs` + `t_proc_spine_specs` | urls.py:311-318 · models.py:1394,1422 |
| 기초코드정보 | `t_cod_base_codes` | views.py:1028 |
| 카테고리 | `t_cat_categories` | admin.py:2109-2124 |
| 구성템플릿 조합 | `t_prd_tmpl_combo_configs` + `t_prd_templates` + `t_prd_template_selections` | tmpl_combo_views.py:267,398,431,438 |
| 상품별 Edicus 템플릿 연결 | `t_prd_edicus_configs` + `t_prd_edicus_templates` | urls.py:43-50 · models.py:1207,1243 |
| 상품별 작업가이드 파일 | `t_prd_guide_files` | guide_views.py:352 |
| 상품별 메인이미지 | `t_prd_main_imgs` (+ `t_prd_shopby_sync` 를 `shopby_sync` 가 갱신) | main_img_views.py:354,370,375 · shopby_sync.py |
| 상품별 시작가 | `t_prd_start_prices` (**수기 `man_*` 만** — `auto_*` 는 배치 전용) | start_price_views.py:100 · models.py:1325-1327 |
| 상품별 디자인 | `t_prd_designs` | design_views.py:170 |
| 단가표 그리드 | `t_prc_component_prices` | urls.py:137 |
| 할인 구간 그리드 | `t_dsc_discount_details` | urls.py:170 · models.py:117 |
| 위젯빌더 | `t_wgt_widgets` · `t_wgt_widget_items` · `t_wgt_widget_versions` | widget_views.py |
| 상품별 위젯 관리 | `t_wgt_widgets` (상태) | urls.py:209 |
| 셋트상품 관리 | `t_prd_product_sets` (편집은 상품정보 인라인 재사용) | urls.py:322-324 · models.py:527 |

### 3-F. 표준 admin changelist 를 가진 34개 모델

`admin.py:1996` 루프가 `apps.get_app_config("catalog").get_models()` 전수를 돌며 등록한다. 복합PK 24종 제외 + 용지 프록시 전용 등록.

| 모델 | 테이블 | 사이드바 | 특수 처리 |
|---|---|---|---|
| TPrdProducts | `t_prd_products` | 상품정보 | 인라인 2종·MES 중복 폼검증·전용 change_form (A:2012-2062) |
| TPrdTemplates | `t_prd_templates` | 추가상품 템플릿 | `TPrdTemplatesAdmin` 선택값 인라인 (A:1834,2179) |
| TCatCategories | `t_cat_categories` | (카테고리 화면 팝업) | `cat_lvl` 자동도출·경로형 `__str__` (A:2109-2124) |
| TMatMaterials | `t_mat_materials` | (자재 화면 팝업) | 스와치 업로드 (A:2105-2108) |
| TPaperMaterials | `t_mat_materials` (프록시) | (용지 관리) | 전용 `PaperAdmin`, 종이 고정 (A:2203) |
| TProcProcesses | `t_proc_processes` | (공정 화면 팝업) | 작업여백 fieldset·상세옵션 조절 (A:2071-2104) |
| TCodBaseCodes | `t_cod_base_codes` | (기초코드 팝업) | `BaseCodeAdminForm` (A:2063-2067) |
| TSizSizes | `t_siz_sizes` | 사이즈정보 | 목록에 `impos_yn` (A:2129-2135) |
| TClrColorCounts | `t_clr_color_counts` | 도수정보 | — |
| TPrtPrintOptions | `t_prt_print_options` | 인쇄옵션 | `print_side` 제외 (A:2125-2128) |
| TPrcPriceFormulas | `t_prc_price_formulas` | (숨김) | 구성요소 인라인·전용 change_form (A:2136-2146) |
| TPrcPriceComponents | `t_prc_price_components` | (숨김) | 사용차원 위젯·목록 단가표 버튼 (A:2147-2165) |
| TPrcComponentPrices | `t_prc_component_prices` | (메뉴 제거) | 단가표 원본. 그리드 팝업이 정상 경로 |
| TDscDiscountTables | `t_dsc_discount_tables` | (숨김) | 구간 그리드 버튼 (A:2166-2178) |
| TCusCustomers | `t_cus_customers` | 고객 | — |
| TWgtSites | `t_wgt_sites` | 없음 | 허용사이트·사이트 키 |
| TWgtWidgets | `t_wgt_widgets` | 없음 | — |
| TWgtWidgetItems | `t_wgt_widget_items` | 없음 | — |
| TWgtHandoffLogs | `t_wgt_handoff_logs` | 없음 | **읽기전용**(추가·수정·삭제 금지) (A:2182-2187) |
| TWgtCartItems | `t_wgt_cart_items` | 없음 | — |
| TOrdOrders / TOrdArtworks / TOrdWebhooks | `t_ord_orders`·`t_ord_artworks`·`t_ord_webhooks` | 없음 | — |
| TAstChatLogs / TAstIssueReports | `t_ast_chat_logs`·`t_ast_issue_reports` | 없음 | 비서 로그 |
| TPrdTmplComboConfigs | `t_prd_tmpl_combo_configs` | 없음 | 조합 화면이 정상 경로 |
| TPrdEdicusConfigs / TPrdEdicusTemplates | `t_prd_edicus_configs`·`t_prd_edicus_templates` | 없음 | Edicus MD 가 정상 경로 |
| TPrdGuideFiles | `t_prd_guide_files` | 없음 | 가이드파일 MD 가 정상 경로 |
| TPrdMainImgs | `t_prd_main_imgs` | 없음 | 메인이미지 MD 가 정상 경로 |
| TPrdShopbySync | `t_prd_shopby_sync` | 없음 | 동기화 상태 |
| TPrdDesigns | `t_prd_designs` | 없음 | 디자인 MD 가 정상 경로 |
| TProcSpineCalcs / TProcSpineSpecs | `t_proc_spine_calcs`·`t_proc_spine_specs` | 없음 | 공정 화면 패널이 정상 경로 |

### 3-G. 표준 changelist 가 **없는** 24개 복합PK 테이블

`models.py` `CompositePrimaryKey` 선언 전수(24건). 이들을 고치려면 반드시 커스텀 화면·인라인을 써야 한다.

| 테이블 | 복합PK | 유일한 편집 경로 |
|---|---|---|
| `t_prd_product_sizes` | prd_cd+siz_cd | 상품뷰어 사이즈 섹션 |
| `t_prd_product_print_options` | prd_cd+opt_id | 상품뷰어 도수/인쇄옵션 섹션 |
| `t_prd_product_plate_sizes` | prd_cd+siz_cd+item_siz_cd | 상품뷰어 판형 섹션 |
| `t_prd_product_materials` | prd_cd+mat_cd+usage_cd | 상품뷰어 자재 섹션 |
| `t_prd_product_processes` | prd_cd+proc_cd | 상품뷰어 공정 섹션 |
| `t_prd_product_bundle_qtys` | prd_cd+bdl_qty | 상품뷰어 묶음수 섹션 |
| `t_prd_product_addons` | prd_cd+tmpl_cd | 상품뷰어 추가상품 섹션 (**del_yn 컬럼 자체가 없음** — 순수 연결표) |
| `t_prd_product_page_rules` | prd_cd+print_opt_cd | 상품뷰어 페이지룰 섹션 |
| `t_prd_product_option_groups` | prd_cd+opt_grp_cd | 옵션 드릴다운 1단 |
| `t_prd_product_options` | prd_cd+opt_cd | 옵션 드릴다운 2단 |
| `t_prd_product_option_items` | prd_cd+opt_cd+item_seq | 옵션 드릴다운 3단 |
| `t_prd_product_constraints` | prd_cd+rule_cd | 제약 폼빌더 |
| `t_prd_template_selections` | tmpl_cd+sel_seq | 추가상품 템플릿 changeform 인라인 |
| `t_prd_product_categories` | prd_cd+cat_cd | 상품정보 changeform 인라인 |
| `t_prd_product_sets` | prd_cd+sub_prd_cd | 상품정보 changeform 인라인 / 셋트상품 관리 |
| `t_prd_product_prices` | prd_cd+apply_ymd | 가격 뷰어 직접단가 패널 |
| `t_prd_product_price_formulas` | prd_cd+apply_bgn_ymd | 가격 뷰어 공식 패널 |
| `t_prd_product_discount_tables` | prd_cd+apply_bgn_ymd+comp_cd | 가격 뷰어 할인 패널 |
| `t_prd_template_prices` | tmpl_cd+apply_ymd | 가격 뷰어 **추가상품 템플릿 직접단가** 패널 (M-1) |
| `t_prc_formula_components` | frm_cd+comp_cd | 가격공식 changeform 인라인 |
| `t_dsc_discount_details` | dsc_tbl_cd+apply_ymd+min_qty | 할인 구간 그리드 팝업 |
| `t_dsc_grade_discount_rates` | grade_cd+cat_cd+apply_ymd | **편집 경로 없음** — `catalog/` 전수 grep 결과 참조 3곳 전부 읽기(`pricing.py:1038`·`price_views.py:1117,2429`). admin 화면에서 등급할인율을 넣을 수 없다 |
| `t_wgt_widget_versions` | wgt_cd+ver_no | 위젯빌더 게시/롤백 |
| `t_prd_start_prices` | prd_cd+dsn_cd | 상품별 시작가 (수기 필드만) |

---

## 4. 매뉴얼 누락 (체계적 diff 결과)

### 방법

사이드바 항목 전수(`settings.py:109-234`, 30건) × 매뉴얼 SCREENS 커버리지(`manual_content.py` SCREENS 17건 + MODEL_ADMIN_SCREENS 10건 + `widget_manual_content.py` SCREENS 27건) 을 대조하고,
가격 뷰어 상세의 실제 패널(`price_views.py:1014-1100`)을 매뉴얼 본문 문자열 grep 으로 재대조했다.

### 4-A. 확인된 누락 (신규 3건 + 기존 1건)

| # | 누락 대상 | 종류 | 증거 |
|---|---|---|---|
| **M-1** | 가격 뷰어 › **「추가상품 템플릿 직접단가」 패널** | 화면 내 패널 | `price_views.py:1055-1078`(렌더)·`:1685`(저장) 에 실재. 매뉴얼 2파일 전수 grep — `직접단가` 3건 전부 **상품** 직접단가 문맥(`manual:317,324,326`), `템플릿단가`/`템플릿 단가` **0건**. 기존 확인건(도메인 룰 § 확인된 매뉴얼 누락) |
| **M-2** | **상품별 작업가이드 파일** (`/admin/guide-file-md/`) | 사이드바 화면 통째 | 사이드바 실재(`settings.py:123`)·URL 8개(`urls.py:60-77`). SCREENS 항목 없음. 매뉴얼이 **스스로 인정** — `HELP_FALLBACK_OK` 에 등재(`manual_content.py:891`), 도움말 아이콘이 목차(#toc)로 폴백 |
| **M-3** | **상품별 메인이미지** (`/admin/main-img-md/`) | 사이드바 화면 통째 | 사이드바 실재(`settings.py:125`)·URL 9개(`urls.py:78-99`). `HELP_FALLBACK_OK` 등재(`manual_content.py:890`). 본문 언급은 디자인 화면의 곁가지 한 줄뿐(`manual:531` "메인이미지 화면과 같은 방식") |
| **M-4** | **사용처(영향도) 상세 화면** (`/admin/impact/`) | 독립 화면 | `urls.py:363` 에 실재하는 standalone 화면. 매뉴얼에는 **용어집**(`manual:84`)·**섹션 안내 한 줄**(`manual:164`)·**FAQ**(`manual:734`) 만 있고 화면 섹션(SCREENS) 없음. 「배지를 누르면 무엇이 열리는가」가 매뉴얼로 답이 안 나옴 |

### 4-B. 역방향 불일치 (매뉴얼에는 있는데 사이드바에 없음)

| # | 대상 | 증거 |
|---|---|---|
| R-1 | **구성템플릿 조합** (`/admin/tmpl-combo-md/`) | 매뉴얼 SCREENS 항목 존재(`manual:232-248`, 「상품 › 구성템플릿 조합」이라 표기). 그러나 `settings.py` 상품 그룹(L110-132)에 해당 항목 **없음** → 메뉴로는 도달 불가. 삭제된 메뉴인지 표기 오류인지 **라이브 확인 필요** |
| R-2 | 「가격 관리 › 가격공식/가격구성요소/할인테이블 (표준 목록)」 | `MODEL_ADMIN_SCREENS`(`manual:575`)에 등재. 사이드바에서는 의도적으로 숨김(`settings.py:159-161`) — 문서와 화면의 의도적 불일치이며 매뉴얼이 「실제 편집은 MD 화면이 편하다」로 설명 |

### 4-C. 매뉴얼 개요의 사이드바 요약이 실제와 다른 점

`manual_content.py:28-41` 「사이드바 메뉴 지도」가 열거하지 않는 실재 메뉴:
상품별 작업가이드 파일 · 상품별 메인이미지 · 상품별 시작가 · 상품별 디자인 · 상품별 위젯 관리 · 위젯 템플릿 관리 · 개발자 문서 그룹 2건.
(상품별 시작가·디자인은 SCREENS 상세에는 있으나 개요 목록에서 빠짐 — 개요만 읽으면 놓친다.)

### 4-D. 왜 이런 누락이 구조적으로 발생하는가

매뉴얼 게이트 `tests/test_help_icon_coverage.py` 는 **「사이드바 화면이 매핑 없이 남으면 실패」만** 검사한다(`manual_content.py:874`).
따라서 ① `HELP_FALLBACK_OK` 에 등재하면 화면 통째 누락도 통과하고(M-2·M-3), ② **화면이 등재돼 있으면 그 화면 안의 패널이 통째로 빠져도 통과한다**(M-1).
M-4 처럼 사이드바에 없는 standalone 화면은 애초에 게이트 대상이 아니다.

---

## 5. 개념 → 화면 인덱스 (한 번 조회로 답 나오게)

| 개념 | 「어디서 하나」 | URL | 대상 테이블 |
|---|---|---|---|
| **사이즈** (상품이 파는 규격 목록) | 상품 뷰어 › 사이즈 섹션 | `/admin/product-viewer/` | `t_prd_product_sizes` |
| 사이즈 **마스터**(가로×세로·조판여부) | 기준정보 › 사이즈정보 | `/admin/catalog/tsizsizes/` | `t_siz_sizes` |
| **자재** (상품이 쓰는 자재·용도·고객선택여부) | 상품 뷰어 › 자재 섹션 | `/admin/product-viewer/` | `t_prd_product_materials` |
| 자재 **마스터** | 기준정보 › 자재정보 | `/admin/master/mat/` | `t_mat_materials` |
| 종이(용지) 자재 + 용지 단가 | 기준정보 › 용지 관리 | `/admin/paper-management/` | `t_mat_materials` + `t_prc_component_prices` |
| **공정** (상품에 붙는 공정·필수여부·상세범위) | 상품 뷰어 › 공정 섹션 | `/admin/product-viewer/` | `t_prd_product_processes` |
| 공정 **마스터**(면별선택·상세옵션·스와치·작업여백) | 기준정보 › 공정정보 | `/admin/master/proc/` | `t_proc_processes` |
| 책등 계산 설정 · 규격표 | 기준정보 › 공정정보 우측 패널 | `/admin/master/proc/` | `t_proc_spine_calcs`·`t_proc_spine_specs` |
| **도수 / 인쇄옵션** (상품별 선택지+표시명) | 상품 뷰어 › 도수/인쇄옵션 섹션 | `/admin/product-viewer/` | `t_prd_product_print_options` |
| 도수 **마스터** | 기준정보 › 도수정보 | `/admin/catalog/tclrcolorcounts/` | `t_clr_color_counts` |
| 인쇄옵션 **마스터**(앞/뒷면 도수의 진실) | 기준정보 › 인쇄옵션 | `/admin/catalog/tprtprintoptions/` | `t_prt_print_options` |
| 판형 (완제품→인쇄판 매핑) | 상품 뷰어 › 판형 섹션 | `/admin/product-viewer/` | `t_prd_product_plate_sizes` |
| **옵션그룹 / 옵션 / 옵션항목** | 상품 뷰어 → 옵션 드릴다운 | `/admin/product-viewer/{prd}/options/` | `t_prd_product_option_groups` → `_options` → `_option_items` |
| **제약규칙** (금지/필수/호환, JSONLogic) | 상품 뷰어 → 제약 폼빌더 | `/admin/product-viewer/{prd}/constraints/` | `t_prd_product_constraints` |
| **추가상품** (이 상품에 끼워 팔 후보) | 상품 뷰어 › 추가상품 섹션 | `/admin/product-viewer/` | `t_prd_product_addons` |
| **추가상품 템플릿** (만들기) | 상품별 템플릿 편집 / 사이드바 추가상품 템플릿 | `/admin/product-viewer/{prd}/templates/` · `/admin/catalog/tprdtemplates/` | `t_prd_templates`·`t_prd_template_selections` |
| 추가상품 템플릿 **전체 카탈로그** | 추가상품 템플릿 카탈로그 | `/admin/sku-catalog/` | (조회) |
| 추가상품 템플릿 **단가** | 가격 뷰어 › 추가상품 템플릿 직접단가 패널 ⚠매뉴얼 없음(M-1) | `/admin/price-viewer/` | `t_prd_template_prices` |
| **카테고리** (분류 트리) | 기준정보 › 카테고리 | `/admin/category-master/` | `t_cat_categories` |
| 상품 ↔ 카테고리 귀속 | 상품정보 changeform 인라인 | `/admin/catalog/tprdproducts/{pk}/change/` | `t_prd_product_categories` |
| **가격공식** | 가격 관리 › 가격공식 | `/admin/price-formula-md/` | `t_prc_price_formulas` (+`t_prc_formula_components` 인라인) |
| **가격구성요소** | 가격 관리 › 가격구성요소 | `/admin/price-component-md/` | `t_prc_price_components` |
| **단가표** (차원별 단가) | 가격구성요소 › [단가표 편집] 그리드 | `/admin/price-viewer/comp/{comp}/edit/` | `t_prc_component_prices` |
| 상품 ↔ 가격공식 연결(적용일) | 가격 뷰어 | `/admin/price-viewer/` | `t_prd_product_price_formulas` |
| 상품 직접단가 | 가격 뷰어 | `/admin/price-viewer/` | `t_prd_product_prices` |
| **할인테이블** (마스터) | 가격 관리 › 할인테이블(수량구간) | `/admin/discount-table-md/` | `t_dsc_discount_tables` |
| 할인 수량구간 상세 | 할인테이블 › [편집] 그리드 | `/admin/discount/{tbl}/edit/` | `t_dsc_discount_details` |
| 상품 ↔ 할인테이블 연결(+적용대상 구성요소) | 가격 뷰어 › 할인 패널 | `/admin/price-viewer/` | `t_prd_product_discount_tables` |
| 등급 할인율 | **admin 에 편집 화면 없음** (읽기 전용 소비만 — SQL 직접 적재로 추정) | — | `t_dsc_grade_discount_rates` |
| **위젯** (주문서 화면 만들기) | 위젯 › 위젯빌더 | `/admin/widget-builder/` | `t_wgt_widgets`·`t_wgt_widget_items`·`t_wgt_widget_versions` |
| 위젯 게시 상태 관리 | 위젯 › 상품별 위젯 관리 | `/admin/widget-manager/` | `t_wgt_widgets` |
| 위젯 템플릿 지정/해제 | 위젯 › 위젯 템플릿 관리 | `/admin/widget-templates/` | `t_wgt_widgets` |
| 허용 사이트 / 사이트 키 | 사이드바 없음 — URL 직접 | `/admin/catalog/twgtsites/` | `t_wgt_sites` |
| **시작가** (자사몰 목록 대표가) | 상품 › 상품별 시작가 | `/admin/start-price/` | `t_prd_start_prices` (수기 `man_*` 만) |
| 묶음수 | 상품 뷰어 › 묶음수 섹션 | `/admin/product-viewer/` | `t_prd_product_bundle_qtys` |
| 페이지룰 | 상품 뷰어 › 페이지룰 섹션 | `/admin/product-viewer/` | `t_prd_product_page_rules` |
| 셋트 구성원 | 상품정보 인라인 / 셋트상품 관리 | `/admin/set-products/` | `t_prd_product_sets` |
| 옵션조합→자재 대조표 | 구성템플릿 조합 (사이드바 없음, R-1) | `/admin/tmpl-combo-md/` | `t_prd_tmpl_combo_configs`·`t_prd_templates`·`t_prd_template_selections` |
| Edicus 편집기 템플릿 | 상품 › 상품별 Edicus 템플릿 연결 | `/admin/edicus-template-md/` | `t_prd_edicus_configs`·`t_prd_edicus_templates` |
| 디자인(고정 사양 묶음) | 상품 › 상품별 디자인 | `/admin/design-md/` | `t_prd_designs` |
| 상품 스위치(비규격·파일업로드·편집기·게시·품절) | 상품 › 상품정보 changeform | `/admin/catalog/tprdproducts/{pk}/change/` | `t_prd_products` |
| 기초코드 | 기준정보 › 기초코드정보 | `/admin/basecode-master/` | `t_cod_base_codes` |
| 사용처(영향도) 확인 | 상품 뷰어 섹션 사용처 배지 → 상세 ⚠매뉴얼 없음(M-4) | `/admin/impact/` | (조회 · `v_cfg_ref_impact`) |

---

## 6. 횡단 동작 (모든 표준 화면 공통)

| 동작 | 내용 | 근거 |
|---|---|---|
| 자동 채번 | `PREFIX_000000` 6자리 시리얼 — 8개 테이블(`t_cat_categories`·`t_clr_color_counts`·`t_mat_materials`·`t_prd_products`·`t_proc_processes`·`t_siz_sizes`·`t_prd_templates`·`t_prt_print_options`) | admin.py:48-52 |
| 기초코드 채번 | `GROUP.NN` 그룹별 채번 | admin.py:53-54 |
| 논리삭제 | `del_yn='Y'` — 목록·드롭다운·API 는 `del_yn='N'` 필터 필수(D-06). 예외는 `# delyn:ok(사유)` 마커 | `raw/webadmin/CLAUDE.md` § Conventions |
| YN 드롭다운 기본값 | `use_yn`=Y, 그 외 `_yn`=N. `t_dsc_discount_tables`·`t_dsc_discount_details` 는 제외 | admin.py:42-46 |
| 감사 컬럼 | `reg_dt`·`upd_dt`·`del_dt` 는 읽기전용(폼 입력 금지) | admin.py:39 |
| 표시명 | Django 영문 복수화 대신 `db_table_comment` 한글을 verbose_name 으로 | admin.py:2001-2005 |
| 도움말 `?` 아이콘 | SCREENS 캡쳐 경로에서 자동 유도 → 매뉴얼 앵커 | manual_content.py:869-924 |

---

## 7. 다음 세션을 위한 미해결 항목

| # | 항목 | 왜 소스로 못 정하나 | 확정 방법 |
|---|---|---|---|
| Q-1 | `t_dsc_grade_discount_rates`(등급할인) 를 실무가 어떻게 넣는가 | 편집 화면이 **없다**는 것까지는 확정(전수 grep 읽기 3곳뿐). 대체 수단(SQL 직접·미사용)은 소스 밖 | 지니에게 확인 / 라이브 DB 행 수 실측 |
| Q-2 | 구성템플릿 조합(R-1) 이 사이드바에서 빠진 이유 | settings 에 흔적 없음(주석도 없음) | 라이브 사이드바 확인 |
| Q-3 | `/admin/master/basecode/` 와 `/admin/basecode-master/` 의 차이 | 둘 다 살아 있고 성격이 비슷 | 라이브 A/B |
| Q-4 | M-2·M-3 화면의 실제 조작 흐름 | 매뉴얼 자체가 없음 | 라이브 화면 조작(A/B) 후 이 문서 §2 보강 + 개발자 전달 |

---

*이 문서는 소스 정적 판독 산출물이다. 「라이브에 실제로 그렇게 보이는가」는 gstack 대조로 별도 확정한다 — 도메인 룰 §[HARD] 라이브 판정은 화면으로 대조한다.*
