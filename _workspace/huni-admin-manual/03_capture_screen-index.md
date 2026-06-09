# 후니 Admin 라이브 캡처 인덱스

> **산출자:** ham-live-capturer · **도구:** gstack browse (headless Chromium) · **로그인:** 성공
> **권위:** 라이브 후니 Django admin(Unfold 테마, Railway PostgreSQL) — 소스 화면 맵(`01_source_admin-screen-map.md`)이 "있다"고 한 화면을 실제로 열어 스크린샷으로 증명한 결과.
> **안전:** 읽기 탐색만 수행 — 저장/추가/삭제/제출 버튼 클릭 0건. 추가(changeform)는 빈 폼 열기까지, 기존 행은 보기까지만.
> **자격증명:** `.env.local` `HUNI_ADMIN_*` (캡션·산출물에 비노출).

## 핵심 라이브 사실 (캡처로 확정)

- **admin 루트 = `/admin/`** (`.env.local`의 `HUNI_ADMIN_URL`은 `/admin/product-viewer/`라 루트를 별도 도출). 표준 모델 URL은 `/admin/catalog/{model}/`.
- **로그인 흐름:** `/admin/login/` 표준 폼(사용자 이름*/비밀번호*/로그인). 로그인 성공 후 홈(`/admin/`)은 **상품 뷰어(`/admin/product-viewer/`)로 redirect**. `next` 파라미터가 `/product-viewer/login/`(미존재)을 가리켜 제출 직후 일시적 Not Found가 보이나, 세션 쿠키는 정상 설정됨 → 홈 직접 진입으로 인증 확인됨.
- **상품정보 275건** (changelist 페이지네이션 1–275). 소스 맵의 "약 384" 표기와 차이 → 라이브 권위 275.
- **좌측 사이드바:** 상품(상품정보/상품 뷰어/구성 템플릿) · 기준정보 마스터(카테고리/자재/사이즈/도수/공정/기초코드) · 가격(가격공식/가격구성요소/구성요소 다차원 단가) · 할인·고객(수량구간할인/고객) · 인증 및 권한(사용자). 소스 맵 13링크와 일치.

## 라이브 확인 플래그 해소 (소스 맵 §6)

| # | 플래그 | 라이브 결과 |
|---|--------|-------------|
| **F-1** | 상품 인라인 부착 여부 | **인라인 미부착 확정.** `tprdproducts/<pk>/change/`는 표준 인라인 섹션 없이 상단에 "상품 뷰어 / 하위정보 뷰어 ↗" 링크만 표시. 9개 차원 편집은 전부 커스텀 product-viewer에서. (`tprdproducts__change.png`) |
| **F-2** | 인라인·메뉴 모두 미등록 모델 접근성 | **직접 URL = 404 "Not Found" 확정.** `tdscdiscountdetails`·`tprcformulacomponents`·`tprdproductsets` 모두 Not Found. admin 어디에서도 직접 편집 불가(데이터는 DB에만). |
| **F-4** | TPrdTemplates change_view redirect | **redirect 확정.** `/admin/catalog/tprdtemplates/TMPL-000005/change/` → `/admin/product-viewer/PRD_000001/templates/TMPL-000005/`(SKU 선택값 편집)로 즉시 이동. 표준 changeform 안 보임. **주의: 라이브 tmpl_cd는 하이픈(`TMPL-000005`)** — 시리얼 placeholder는 `TMPL_` 언더스코어이나 실제 적재행은 하이픈. |
| **F-7** | Unfold 위젯 외형 | `tmatmaterials__changeform-dropdown.png`로 확정 — native `<select>` 코드값 드롭다운(종이/필름/아크릴/금속/원단/가죽/부속/실사소재/파우치…), YN Y/N select, placeholder("비우면 저장 시 자동 채번"·"숫자 (mm)"·"묶음 수량 · 예: 50, 100"), 필수 `*` 표시, 등록일시/수정일시 readonly, 하단 저장 버튼 바(저장/저장 및 편집 계속/저장 및 다른 이름으로 추가). |
| **F-5/F-6** | 드릴다운 형태·진입점 | 커스텀 화면은 product-viewer 내 동일 레이아웃 페이지 전환(별도 모달 아닌 풀페이지). 드릴다운 다음계층은 JS(`pvOpenNextLevel`, `data-okey` JSON) — 직접 URL `/options/<grp>/`로도 진입 가능(`admin_view` 인증만 통과하면). |

## 화면별 캡처 인덱스

### 진입/홈

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| admin-login | `captures/admin-login__login.png` | /admin/login/ | ① 사용자 이름* 입력 ② 비밀번호* 입력 ③ "로그인 →" 버튼 ④ "← Return to site" 링크 | 표준 Django/Unfold 로그인. | ✅ |
| product_viewer | `captures/product_viewer__home.png` | /admin/product-viewer/ | ① 상단 "상품 뷰어" 제목 ② "상품명/코드 검색…" 검색박스 ③ 좌측 전 상품 목록(prd_nm + PRD_코드, prd_cd 정렬) ④ 우측 "좌측에서 상품을 선택하세요" 빈 상태 | 홈 redirect 도착지. PRD_000001~ 순. | ✅ |

### 표준 모델 — 목록(changelist) 13종

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| tprdproducts__changelist | `captures/tprdproducts__changelist.png` | /admin/catalog/tprdproducts/ | ① 상단 브레드크럼(후니 상품·가격 DB › 상품정보) + 우상단 ⊕추가 ② "Type to search" 검색 + Filters 버튼 ③ 컬럼헤더: 상품코드·MES품목코드·상품명·상품유형코드·반제품역할코드·비규격여부·비규격가로최소·비규격가로최대 ④ 행 체크박스 + 페이지네이션(1–275) | **275건.** prd_typ_cd=추가상품/기성품. | ✅ |
| tprdtemplates__changelist | `captures/tprdtemplates__changelist.png` | /admin/catalog/tprdtemplates/ | ① 제목 "구성 템플릿(SKU)" ② 컬럼: 템플릿명·base_prd_cd·구성요약·dflt_qty·use_yn ③ 행(OPP접착봉투 110x160 mm 50장 등) | 행 존재(TMPL-000005 등). 행 클릭=SKU 팝업(JS). | ✅ |
| tcatcategories__changelist | `captures/tcatcategories__changelist.png` | /admin/catalog/tcatcategories/ | ① 카테고리 목록 ② 컬럼: cat_cd·cat_nm·upr_cat_cd·cat_lvl·disp_seq·use_yn·reg_dt·upd_dt | 트리 카테고리. | ✅ |
| tmatmaterials__changelist | `captures/tmatmaterials__changelist.png` | /admin/catalog/tmatmaterials/ | ① 자재정보 목록 ② 컬럼: mat_cd·mat_nm·mat_typ_cd·upr_mat_cd·sel_typ_cd·max_sel_cnt·width·height ③ 검색·필터(mat_typ_cd/sel_typ_cd) | 자재유형 다수. | ✅ |
| tsizsizes__changelist | `captures/tsizsizes__changelist.png` | /admin/catalog/tsizsizes/ | ① 사이즈정보 목록 ② 컬럼: siz_cd·siz_nm·work_width·work_height·cut_width·cut_height·margin_top·margin_bot | 작업/재단 치수. | ✅ |
| tclrcolorcounts__changelist | `captures/tclrcolorcounts__changelist.png` | /admin/catalog/tclrcolorcounts/ | ① 도수정보 목록 ② 컬럼: clr_cd·clr_nm·chnl_cnt·use_yn·note·del_yn·del_dt·reg_dt | 도수(CMYK 등). | ✅ |
| tprocprocesses__changelist | `captures/tprocprocesses__changelist.png` | /admin/catalog/tprocprocesses/ | ① 공정정보 목록 ② 컬럼: proc_cd·proc_nm·upr_proc_cd·prcs_dtl_opt·disp_seq·use_yn·note·del_yn | 트리 공정. | ✅ |
| tcodbasecodes__changelist | `captures/tcodbasecodes__changelist.png` | /admin/catalog/tcodbasecodes/ | ① 기초코드정보 목록 ② 컬럼: cod_cd·cod_nm·upr_cod_cd·disp_seq·use_yn·note·reg_dt·upd_dt | 코드 그룹. | ✅ |
| tprcpriceformulas__changelist | `captures/tprcpriceformulas__changelist.png` | /admin/catalog/tprcpriceformulas/ | ① 가격공식 목록 ② 컬럼: frm_cd·frm_nm·frm_typ_cd·note·use_yn·reg_dt·upd_dt | PRF_* 공식. | ✅ |
| tprcpricecomponents__changelist | `captures/tprcpricecomponents__changelist.png` | /admin/catalog/tprcpricecomponents/ | ① 가격구성요소 목록 ② 컬럼: comp_cd·comp_nm·comp_typ_cd·note·use_yn·reg_dt·upd_dt | COMP_* 구성요소(대량). | ✅ |
| tprccomponentprices__changelist | `captures/tprccomponentprices__changelist.png` | /admin/catalog/tprccomponentprices/ | ① 구성요소 다차원 단가 목록 ② 컬럼: comp_price_id·comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty | 다차원 단가 행 다수. | ✅ |
| tdscdiscounttables__changelist | `captures/tdscdiscounttables__changelist.png` | /admin/catalog/tdscdiscounttables/ | ① 수량구간할인 마스터 목록 ② 컬럼: dsc_tbl_cd·dsc_tbl_nm·note·use_yn·reg_dt·upd_dt | YN_ENHANCE_EXCLUDE 대상. | ✅ |
| tcuscustomers__changelist | `captures/tcuscustomers__changelist.png` | /admin/catalog/tcuscustomers/ | ① 고객 목록 ② 컬럼: cus_cd·cus_nm·grade_cd·reg_ymd·use_yn·reg_dt·upd_dt | 고객. | ✅ |

### 표준 모델 — 추가 폼(changeform, 빈 폼·미제출) 13종

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| tprdproducts__changeform | `captures/tprdproducts__changeform.png` | /admin/catalog/tprdproducts/add/ | ① 좌측 도메인 사이드바 ② 상단 제목+저장 바 ③ prd_cd "비우면 저장 시 자동 채번" placeholder ④ prd_nm* 필수 ⑤ prd_typ_cd·semi_role_cd 드롭다운 ⑥ 비규격 여부/가로min·max ⑦ 등록·수정일시 readonly | PRD_ 시리얼. | ✅ |
| tprdtemplates__changeform | `captures/tprdtemplates__changeform.png` | /admin/catalog/tprdtemplates/add/ | ① tmpl_nm·base_prd_cd·dflt_qty·use_yn ② 템플릿선택값 인라인 섹션(can_delete=False) | TMPL_ 시리얼. | ✅ |
| tcatcategories__changeform | `captures/tcatcategories__changeform.png` | /admin/catalog/tcatcategories/add/ | ① cat_cd 자동채번 placeholder ② cat_nm* ③ upr_cat_cd 트리 드롭다운(깊이 들여쓰기) ④ cat_lvl·disp_seq·use_yn | CAT_ 시리얼·트리DD. | ✅ |
| tmatmaterials__changeform | `captures/tmatmaterials__changeform.png` | /admin/catalog/tmatmaterials/add/ | ① mat_cd 자동채번 ② mat_nm* ③ mat_typ_cd* 드롭다운 ④ upr_mat_cd 트리DD ⑤ sel_typ_cd ⑥ max_sel_cnt·width·height·무게·묶음수 ⑦ use_yn·비고 | MAT_ 시리얼. | ✅ |
| tsizsizes__changeform | `captures/tsizsizes__changeform.png` | /admin/catalog/tsizsizes/add/ | ① siz_cd 자동채번 ② siz_nm* ③ work/cut width·height ④ margin_top/bot ⑤ use_yn | SIZ_ 시리얼. | ✅ |
| tclrcolorcounts__changeform | `captures/tclrcolorcounts__changeform.png` | /admin/catalog/tclrcolorcounts/add/ | ① clr_cd 자동채번 ② clr_nm* ③ chnl_cnt ④ use_yn·note | CLR_ 시리얼. | ✅ |
| tprocprocesses__changeform | `captures/tprocprocesses__changeform.png` | /admin/catalog/tprocprocesses/add/ | ① proc_cd 자동채번 ② proc_nm* ③ upr_proc_cd 트리DD ④ prcs_dtl_opt(JSON) ⑤ disp_seq·use_yn·note | PROC_ 시리얼. | ✅ |
| tcodbasecodes__changeform | `captures/tcodbasecodes__changeform.png` | /admin/catalog/tcodbasecodes/add/ | ① cod_cd(비우고 상위선택 시 GROUP.NN 채번) ② cod_nm* ③ upr_cod_cd 드롭다운(루트만) ④ disp_seq·use_yn·note | BaseCodeAdminForm — 둘 다 비면 폼오류. | ✅ |
| tprcpriceformulas__changeform | `captures/tprcpriceformulas__changeform.png` | /admin/catalog/tprcpriceformulas/add/ | ① frm_cd ② frm_nm* ③ frm_typ_cd 드롭다운 ④ note·use_yn | 시리얼 비대상. | ✅ |
| tprcpricecomponents__changeform | `captures/tprcpricecomponents__changeform.png` | /admin/catalog/tprcpricecomponents/add/ | ① comp_cd ② comp_nm* ③ comp_typ_cd 드롭다운 ④ note·use_yn | 시리얼 비대상. | ✅ |
| tprccomponentprices__changeform | `captures/tprccomponentprices__changeform.png` | /admin/catalog/tprccomponentprices/add/ | ① comp_cd ② apply_ymd ③ siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty(8키) ④ 단가 | BigAuto PK. unique_together 8키. | ✅ |
| tdscdiscounttables__changeform | `captures/tdscdiscounttables__changeform.png` | /admin/catalog/tdscdiscounttables/add/ | ① dsc_tbl_cd ② dsc_tbl_nm* ③ note·use_yn | YN enhance 미적용(텍스트 입력). | ✅ |
| tcuscustomers__changeform | `captures/tcuscustomers__changeform.png` | /admin/catalog/tcuscustomers/add/ | ① cus_cd ② cus_nm* ③ grade_cd·reg_ymd·use_yn | 고객. | ✅ |

### 드롭다운 펼친 상태 (코드값·YN 위젯 증거)

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| tmatmaterials__changeform-dropdown | `captures/tmatmaterials__changeform-dropdown.png` | /admin/catalog/tmatmaterials/add/ | ① 자재유형코드* 드롭다운 펼침: 종이·필름·아크릴·금속·원단·가죽·부속·실사소재·파우치·(악세사리) ② 사용여부 Y/N select ③ placeholder 가이드 전부 노출 | **F-7 대표 증거.** native select. 다른 코드값 드롭다운(use_yn, frm_typ_cd 등)도 동형. | ✅ |

### 인증·권한(Django 표준)

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| auth_user__changelist | `captures/auth_user__changelist.png` | /admin/auth/user/ | ① 사용자 목록 ② 컬럼: username·email·이름·staff status 등 | 표준 Django 사용자. | ✅ |
| auth_group__changelist | `captures/auth_group__changelist.png` | /admin/auth/group/ | ① 그룹 목록 ② name | 표준 Django 그룹. | ✅ |

### 커스텀 상품 뷰어 레이어

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| product_detail | `captures/product_detail__detail.png` | /admin/product-viewer/PRD_000016/ | ① 상단 상품명+코드(프리미엄엽서 PRD_000016) + "모두 접기" ② 11개 섹션 카드(접이식): 사이즈(7)·도수/인쇄옵션(2)·판형(1)·자재(21)·공정(6)·묶음수(0)·추가상품(1)·페이지룰(0)·옵션그룹(0)·제약규칙(0)·구성템플릿SKU(0) ③ 각 카드 헤더 "편집" 버튼 + 행 테이블(기본여부·표시순서 포함) | **F-1 핵심 증거** — 인라인 아닌 섹션 집계 카드. 각 섹션 행수 표기. PRD_000016은 옵션그룹/제약/SKU=0(미적재). | ✅ |
| section_edit | `captures/section_edit__sizes.png` | /admin/product-viewer/PRD_000016/edit/sizes/ | ① 브레드크럼(상품 › 섹션) ② 섹션 행 폼(modelform, prd_cd/감사컬럼 제외) ③ "+ 추가" 빈 행 ④ 사용처 배지 | sizes 섹션 예시. SECTION_MAP 9종 동형. | ✅ |
| option_groups | `captures/option_groups__options-l1.png` | /admin/product-viewer/PRD_000138/options/ | ① 제목 "옵션그룹 편집 — 일반현수막(PRD_000138)" ② 안내문(편집/그룹추가/열기 ›) ③ 옵션그룹 행(편집/열기·●필수) ④ "+ 그룹 추가" 점선 | **드릴다운 1계층.** PRD_000138(일반현수막=silsa, CPQ 적재됨). PRD_000016은 옵션그룹 0이라 PRD_000138로 캡처. | ✅ |
| options | `captures/options__options-l2.png` | /admin/product-viewer/PRD_000138/options/OPT_000003/ | ① 제목 "가공 옵션 편집" ② **선택 미리보기 패널**(라디오/단일·필수 동작 미리보기·저장 안 함) ③ 옵션별 카드(양면테입·봉미싱·열재단·타공4/6/8개·봉미싱) ④ **각 옵션 내 구성요소 인라인**(자재/공정 배지 + ×수량 + 편집/삭제) ⑤ "+ 구성요소 추가(자재/공정)" ⑥ "+ 옵션 추가" | **드릴다운 2계층.** opt_grp_cd=OPT_000003(가공). **자재+공정 BUNDLE** 라이브 확인(양면테입=자재 양면테입/공정 부착, 봉미싱=자재 봉제사/공정 봉제). | ✅ |
| option_items | `captures/options__options-l2.png` (L2 내 인라인) | /admin/product-viewer/PRD_000138/options/`<grp>`/`<opt>`/ | (옵션 카드 내 "구성요소" 행: 자재/공정 배지·×수량·편집/삭제·+추가) | **L3는 별도 페이지가 아니라 L2 옵션 카드 안에 인라인 렌더.** 소스 맵 §4-4는 별도 URL 존재로 기술하나, 라이브 UI는 인라인 편집("각 옵션 아래에서 구성요소를 바로 추가·수정"). 별도 캡처 없음 — L2 스크린샷이 L3 항목을 포함. | ◑ 인라인(L2에 포함) |
| sku_list | `captures/sku_list__sku-l1.png` | /admin/product-viewer/PRD_000138/templates/ | ① 제목 "구성템플릿(SKU) 편집" ② 템플릿 행/편집 ③ "+ 템플릿 추가" | **SKU 드릴다운 1계층.** | ✅ |
| sku_selections | `captures/sku_selections__sku-l2.png` | /admin/product-viewer/PRD_000001/templates/TMPL-000005/ | ① 제목 "…선택값 편집 — OPP접착봉투(PRD_000001)" ② 브레드크럼(템플릿 › 선택값) ③ 선택값 행 폼(폴리모픽 ref_dim_cd) ④ "+ 선택값 추가" 점선 ⑤ ●필수 | **SKU 드릴다운 2계층.** F-4 redirect 도착지. tmpl_cd=TMPL-000005(하이픈). | ✅ |
| constraints | `captures/constraints__constraints.png` | /admin/product-viewer/PRD_000138/constraints/ | ① 기존 규칙 목록(del_yn='N') ② 폼빌더(규칙유형 호환/금지/필수동반 + 조건/결과 차원·값 드롭다운) ③ raw_logic 고급 입력 ④ 검증 미리보기 | 제약 폼빌더(JSONLogic 자동생성). | ✅ |
| sku_catalog | `captures/sku_catalog__catalog.png` | /admin/sku-catalog/ | ① 전체 SKU 목록(base_prd_cd·tmpl_cd·선택값수) ② 행별 "편집" 링크(해당 상품 sku_list로) | standalone(메뉴 미등록). 보기 전용. 행=상품 templates/ 링크. | ✅ |
| impact_detail | `captures/impact_detail__impact.png` | /admin/impact/?dim=OPT_REF_DIM.01&key1=SIZ_000001 | ① 제목 "사용처 상세 — {dim}/{key}" ② src_kind별 그룹(OPTION_ITEM/TEMPLATE_SEL) + 총건수 ③ CONSTRAINT 레그 한계 안내 | standalone. v_cfg_ref_impact 기반. | ✅ |

### 비시각(Ajax) — 캡처 대상 아님

| 화면ID | 실제 URL | 사유 |
|--------|----------|------|
| dim_choices | /admin/product-viewer/`<prd>`/dim-choices/?dim= | JSON 응답(select2 소스). 시각 화면 아님. |
| validate_preview | /admin/product-viewer/`<prd>`/validate/ (POST) | JSON 응답(제약 검증). 시각 화면 아님. |

## 미캡처/특이 사항

- **option_items 별도 페이지:** 라이브는 L2 옵션 카드 내 인라인 편집이라 별도 L3 페이지 캡처 없음(L2 스크린샷에 포함). 소스 맵 §4-4의 별도 URL은 존재하나 운영자 동선상 L2에서 처리.
- **PRD_000016 옵션/제약/SKU=0:** 프리미엄엽서는 CPQ 옵션그룹·제약·SKU 미적재(섹션 카드 (0) 표기). 드릴다운 L1/L2는 적재된 PRD_000138(일반현수막=silsa)로 캡처.
- **F-2 모델(7종):** 직접 URL 404 확정으로 캡처 불가(설계상 admin 미노출).

## 캡처 커버리지 집계

| 구분 | 캡처 | 전체(소스 맵 시각 화면) | 비고 |
|------|------|------------------------|------|
| 진입/홈 | 2 | 2 | login, product_viewer |
| 표준 changelist | 12 + auth 2 = 14 | 14 | 표준 13(상품 포함)+auth 2 |
| 표준 changeform(add) | 13 | 13 | 전 표준 모델 빈 폼 |
| 드롭다운 펼침 | 1 | 1 (대표) | F-7 증거 |
| 상품 change(상품뷰어 링크) | 1 | 1 | F-1 증거 |
| 커스텀 뷰어 | 10 | 11 (option_items는 L2 인라인) | detail/section/opt-L1/opt-L2/sku-L1/sku-L2/constraints/sku_catalog/impact + opt_items(L2 포함) |
| **합계(시각 화면)** | **41** | **약 42 시각 화면군** | 비시각 Ajax 2 제외 |

**쓰기 동작:** 0건 (저장/추가/삭제/제출 클릭 없음 — 읽기 탐색만).
**소스↔라이브 차이(QA 검토용):** ① 상품 275건(소스 맵 ~384 표기) ② tmpl_cd 하이픈(`TMPL-000005`) vs placeholder 언더스코어(`TMPL_`) ③ option_items L3 인라인 렌더 ④ login next 파라미터가 미존재 경로 가리킴(세션은 정상).
