# 전 admin 페이지 보이는 요소 인벤토리 (네이밍 전수)

> **산출자:** dbm-price-formula-auditor · round-34 · 2026-06-18
> **권위:** 화면맵 `_workspace/huni-admin-manual/01_source_admin-screen-map.md`(소스 file:line) + 라이브 DB read-only 실측 + `_workspace/huni-dbmap/13_admin-ui-spec/`(332컬럼 UI라벨).
> **"보이는 요소" 3종:** ① 컬럼 라벨(db_comment·한글) ② 코드값 도메인(드롭다운 선택지) ③ 데이터 값(명칭 — comp_nm·frm_nm·proc_nm 등).
> **라이브 화면 캡처는 이번 제외**(자격증명) — 소스+DB 도출. 캡처 필요분은 "🔵라이브확인" 플래그.

---

## 1. 페이지 전수 (standalone 13 + 커스텀 11 + auth 2)

라벨 권위 = `admin.py:236-259`(verbose_name=db_comment) + `_make_admin` list_display(앞 8필드).

### 1-A. 표준 standalone 모델 (13) — list_display 컬럼 + 데이터 명칭

| # | 페이지(한글라벨) | URL | 보이는 컬럼(list_display) | 데이터 명칭 컬럼(네이밍 정리 대상) | 코드값 도메인 |
|---|---|---|---|---|---|
| 1 | 상품정보 | /catalog/tprdproducts/ | prd_cd·MES_ITEM_CD·prd_nm·prd_typ_cd·semi_role_cd·nonspec_yn·… | **prd_nm**(275상품명) | prd_typ_cd(PRD_TYPE).qty_unit_typ_cd(QTY_UNIT).semi_role_cd(SEMI_ROLE) |
| 2 | 자재정보 | /catalog/tmatmaterials/ | mat_cd·mat_nm·mat_typ_cd·upr_mat_cd·sel_typ_cd·… | **mat_nm**(자재명) | mat_typ_cd(MAT_TYPE).sel_typ_cd(SEL_TYPE) |
| 3 | 사이즈정보 | /catalog/tsizsizes/ | siz_cd·siz_nm·work_width·work_height·… | **siz_nm**(사이즈명) | use_yn |
| 4 | 도수정보 | /catalog/tclrcolorcounts/ | clr_cd·clr_nm·chnl_cnt·use_yn·… | **clr_nm**(도수명) | use_yn |
| 5 | 공정정보 | /catalog/tprocprocesses/ | proc_cd·proc_nm·upr_proc_cd·prcs_dtl_opt·disp_seq·… | **proc_nm**(공정명 102 — ★표준어 권위) | use_yn |
| 6 | 카테고리 | /catalog/tcatcategories/ | cat_cd·cat_nm·upr_cat_cd·cat_lvl·… | **cat_nm**(카테고리명) | use_yn |
| 7 | 기초코드정보 | /catalog/tcodbasecodes/ | cod_cd·cod_nm·upr_cod_cd·disp_seq·… | **cod_nm**(85 — ★유형 라벨 권위) | use_yn |
| 8 | **가격공식** | /catalog/tprcpriceformulas/ | frm_cd·frm_nm·frm_typ_cd·note·use_yn·… | **frm_nm**(48 — 정리됨 GO)·note | frm_typ_cd(🔵라이브확인 — DDL 선언만, 라이브 미사용 가능) |
| 9 | **가격구성요소** | /catalog/tprcpricecomponents/ | comp_cd·comp_nm·comp_typ_cd·note·use_yn·… | **comp_nm**(146 — ★코드노출 102 결함)·note | comp_typ_cd(PRC_COMPONENT_TYPE 6종) |
| 10 | 구성요소 다차원 단가 | /catalog/tprccomponentprices/ | comp_price_id·comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·… | (FK 코드만·명칭은 조인) | PRICE_TYPE(단가/합가) |
| 11 | 수량구간할인 마스터 | /catalog/tdscdiscounttables/ | dsc_tbl_cd·dsc_tbl_nm·note·… | dsc_tbl_nm | use_yn |
| 12 | 고객 | /catalog/tcuscustomers/ | cus_cd·cus_nm·grade_cd·… | cus_nm | grade_cd(CUS_GRADE) |
| 13 | 구성템플릿(SKU) | /catalog/tprdtemplates/ | tmpl_nm·base_prd_cd·selections_summary·dflt_qty·use_yn | tmpl_nm·selections_summary(pill) | use_yn |

### 1-B. 커스텀 뷰 (11) — 보이는 명칭

| 페이지 | URL | 보이는 명칭 요소 |
|---|---|---|
| 상품 뷰어(홈) | /product-viewer/ | prd_nm·prd_cd 목록 |
| 상품 상세 | /product-viewer/`<prd>`/ | 9섹션 헤더·옵션그룹명·제약규칙명·SKU명 |
| 섹션 편집 | …/edit/`<section>`/ | 차원 FK 라벨(mat_nm·siz_nm·proc_nm 등) |
| 옵션그룹/옵션/옵션항목 드릴다운 | …/options/… | opt_grp_nm·opt_nm·ref_dim 라벨 |
| SKU 목록/선택값 | …/templates/… | tmpl_nm·선택값(차원명) |
| 제약 폼빌더 | …/constraints/ | 규칙명·규칙유형(RULE_TYPE)·차원/값 |
| 사용처 상세(impact) | /impact/ | dim·key·src_kind |
| 전체 SKU 카탈로그 | /sku-catalog/ | tmpl·기준상품명·선택값수 |
| auth user/group | /auth/… | (정리 범위 외) |

> **네이밍 정리의 화면 영향:** comp_nm은 **#9 가격구성요소 list + changeform** 그리고 **#8 가격공식 changeform의 구성요소 인라인/조회**, 가격뷰어 제약·옵션 화면의 가격요소 표시에 노출. comp_nm 정리 = 이 모든 화면에서 코드가 사라지고 표준어 노출.

---

## 2. 데이터 명칭 네이밍 현황 요약 (라이브 실측)

| 명칭 컬럼 | 행수 | 코드노출 | 비표준/모호 | 상태 |
|---|---|---|---|---|
| **comp_nm** (가격구성요소) | 146 | **102** | TWINRING "제본비"(변별자부재)·DIGITAL_S1 "출력비"·"모서리 비"(귀돌이) | 🔴 결함 多 |
| frm_nm (가격공식) | 48 | 0 | 0 | ✅ GO |
| proc_nm (공정) | 102 | 0 | 0 (표준어 권위) | ✅ |
| cod_nm (기초코드) | 85 | 0 | TEST/TESTTEST/TESTTESTTEST 3 테스트잔재 | 🟡 테스트코드 |
| mat_nm·siz_nm·clr_nm·cat_nm | — | (이번 정리 핵심 아님·자재축은 round-22 트랙) | — | — |

---

## 3. 보이는 요소 중 정리 무관/범위 외
- auth_user/group, 고객(cus_nm), 수량구간할인 명칭: 가격요소 네이밍 directive 범위 외.
- comp_price/template_selection 등 복합PK 데이터 화면: FK 코드만 표시·명칭은 조인 라벨이라 별도 정리 불요(원천 comp_nm·proc_nm 정리하면 자동 반영).
- mat_nm 자재 오염(색/형상) 정리는 round-22 6축 staged 트랙 소관(별 트랙).
