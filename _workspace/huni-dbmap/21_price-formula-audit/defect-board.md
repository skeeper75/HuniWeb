# 가격공식 결함 보드 — round-17

> 가독성(B)·배선(C)·뷰어노출(D) 결함 분류 + 우선순위. 라이브 읽기전용 실측 근거. DB 미적재(실 교정은 인간 승인).
> 우선순위: **High**(가격 조회 불능·운영 오해 유발) · **Medium**(가독성·일관성) · **Low**(서술·정보 보강).

---

## High

### D-1 · PRF_TTEOKME_FIXED 고아 공식 (배선·뷰어 단절) — C+D
- **현상**: 떡메모지 공식은 정의·배선(comp 1)·단가행까지 완결됐으나 **어떤 상품도 이 공식에 연결 안 됨**(`product_price_formulas` 0행). 떡메모지 상품(PRD_000097 떡메모지·PRD_000098 떡메모지-내지) 라이브 실재.
- **영향**: 가격뷰어에서 떡메모지 상품을 열면 `current_source=NONE`(가격원천 없음 배지) → **실무진이 "떡메모지는 가격이 안 들어갔다"고 오해**. 실제로는 공식은 있고 바인딩만 누락.
- **근거**: `t_prd_product_price_formulas WHERE frm_cd='PRF_TTEOKME_FIXED'` → 0행. `price_views.py:80,86` has_frm 집합에 미포함.
- **교정**: 떡메모지 상품 ↔ PRF_TTEOKME_FIXED 바인딩 INSERT(인간 승인). round-16 postcard-book-memo 시트 `1b_바인딩` 행 확인 필요.

### D-2 · 212/275 상품 가격원천 0 (가격사슬 미완 macro) — C+D
- **현상**: 275 상품 중 **공식 연결 63·직접단가 0 → 212 상품이 NONE**.
- **영향**: 가격뷰어 좌측 트리에서 212상품이 "가격원천 없음" 배지. round-16이 시트별로 발견한 "가격사슬 단절"(아크릴 본체 22상품·코롯토 등 공식 0개)의 집계. 위젯/견적엔진이 이 212상품 가격을 조회할 경로 없음.
- **근거**: `products LEFT JOIN product_price_formulas LEFT JOIN product_prices` → NONE 212.
- **교정**: round-16 `20_price-import/` 16시트가 제안한 신규 공식·배선·바인딩을 시트별로 적재(인간 승인·시트별 게이트 GO 분만). **이번 라운드 범위 밖**(공식 정리 검증), 라우팅만.

---

## Medium

### D-3 · note 내부 행번호 노출 (가독성) — B · 15/16 공식
- **현상**: note 15건이 "(계산공식집초안 행4)" 같은 **내부 작성 문서 행번호**를 노출. 비개발자 실무진에게 "행4"는 의미 없음.
- **영향**: 공식 비고를 봐도 "계산공식집초안 행N"이 끼어 즉시 이해 저하. B축 전건 🟡의 주원인.
- **근거**: `note LIKE '%계산공식집초안%' OR '%행%'` → 15/16.
- **교정**: note에서 내부 행번호 제거 또는 "(내부참조: 계산공식집초안 행N)"으로 괄호 격하(쉬운 한국어 본문 우선). §improvement-proposal 참조.

### D-4 · note 영문 약어 노출 (가독성) — B · 5/16 공식
- **현상**: note 5건이 "component", "comp 흡수" 등 영문 약어 노출(예 PRF_NAMECARD_FIXED "면=comp흡수, 소재=mat 차원", PRF_PCB_FIXED "면·페이지=comp흡수 차원").
- **영향**: "comp 흡수"·"mat 차원"은 개발 용어. 실무진이 "면이 어디 반영되는지" 코드 없이 이해 곤란.
- **교정**: "면·소재는 가격표 열로 들어감" 식 쉬운 한국어로 치환.

### D-5 · 공식유형(frm_typ_cd) 구조화 필드 부재 — A 구조한계 (전 공식)
- **현상**: 라이브 `t_prc_price_formulas`에 frm_typ_cd 컬럼 없음(formula-inventory §0 결판). 실무진이 "합산형/단순형"을 구조화 필드로 못 봄 — note 접두어로만.
- **영향**: 가격뷰어가 공식 유형을 배지/필터로 노출 못 함. 같은 유형 공식 묶어보기 불가. 소스(`price_views.py`)는 frm_typ_cd 미사용이라 화면 기능 영향은 현재 0이나, 확장성·가독성 한계.
- **근거**: information_schema 실측 컬럼 6개에 frm_typ_cd 없음. 소스 DDL `sql/01a_tables_master.sql:187`엔 선언됨(미적용).
- **교정**: frm_typ_cd 컬럼 백필(ALTER + seed FRM_TYPE 2종 + 16공식 값 채움) — round-14 "선언≠적용" 해소. **DDL 변경이라 인간 승인·round-5/dbm-ddl-proposer 트랙**.

---

## Low

### D-6 · 포스터 add-on comp 2건 미배선 (고아 구성요소) — C(구성요소 레벨)
- **현상**: COMP_POPT_BNR_GAKMOK_STR_900_4 · COMP_POSTEROPT_BANNER_MESH_PROC_OPT 2 comp가 `use_dims=NULL`·`formula_components` 배선 0.
- **영향**: 공식이 아니라 구성요소 레벨 고아. 포스터 추가옵션 통가격이 어느 공식에도 안 묶임 → 뷰어 사용처 팝업(`price_comp_usage`)에서 이 comp의 공식·상품 0.
- **교정**: POSTER 추가옵션을 PRF_POSTER_FIXED 또는 별도 add-on 공식에 배선(인간 승인). round-16 poster-sign 시트 참조.

### D-7 · PRF_DGP_F 미출시 공식 노출 — D(정보)
- **현상**: use_yn=N(미출시)인데 `price_select_options`(`:521`)는 use_yn 필터 없이 전 16공식을 셀렉트에 노출 → 실무진이 미출시 공식(썬캡)을 선택 가능.
- **영향**: 낮음(썬캡 상품도 미출시라 일관). 다만 실무진이 실수로 미출시 공식 바인딩 가능.
- **교정**: `price_select_options`에 `use_yn='Y'` 필터 또는 미출시 표시(앱 로직 변경·webadmin 트랙). 결함 아닌 개선 권고.

### D-8 · addtn_yn 전건 'Y' — C(의미 검증)
- **현상**: 배선 85건 전부 addtn_yn='Y'.
- **영향**: 단순형(1 comp)엔 무해. 합산형에서 "base 구성요소 vs 가산 구성요소" 구분이 필요하면 전건 Y는 의미 손실 가능(예 별색=가산이어야 정상). 현재 엔진 영향은 미검증.
- **교정**: 합산형 공식의 base/add 구분 필요성 도메인 확인(컨펌). 결함 단정 아님 — 관찰.

---

## 미해소 컨펌 (실무진/도메인 확인 필요)

| ID | 질문 | 영향 결함 |
|----|------|-----------|
| Q-1 | 떡메모지 상품을 PRF_TTEOKME_FIXED에 바인딩해도 되는가(상품 정체·적용시작일)? | D-1 |
| Q-2 | 합산형 공식에 frm_typ_cd 백필 시 단순형(FIXED) 8건은 "단순형(FRM_TYPE.02)"으로 분류 확정? | D-5 |
| Q-3 | 합산형 배선의 base/add 구분(addtn_yn)이 엔진 계산에 필요한가? | D-8 |
| Q-4 | 미출시(use_yn=N) 공식을 셀렉트에서 숨길지/표시할지? | D-7 |
