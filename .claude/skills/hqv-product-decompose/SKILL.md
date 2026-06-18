---
name: hqv-product-decompose
description: 후니프린팅 "상품군+상품명" 한 줄 명령을 가격계산 검증용 work-spec으로 해독하는 방법론 스킬. 상품 정체 확정(prd_nm→prd_cd·라이브 1:1·동명이품 주의), 요소 전수 분해(자재·공정·사이즈·도수·인쇄옵션·묶음수·코팅면수·옵션·차원·각 출처), 가격공식 사슬 식별(상품-공식 바인딩→공식→formula_components→price_components→component_prices), 기대 골든 케이스 도출(가격표 verbatim), 3축 검증 작업명세(work-spec) 작성, 확신도 표기를 제공한다. '상품 분해', '명령 해독', '상품 요소 파악', 'prd_cd 식별', '가격공식 바인딩 파악', '골든 케이스 도출', '검증 work-spec', '상품 분해 다시' 작업 시 반드시 이 스킬을 사용. 3축 실측 검증은 hqv-quote-verification, codex 교차검증은 hqv-codex-cross-verify가 담당하므로 그 작업에는 트리거하지 않는다.
---

# hqv-product-decompose — 명령 해독·상품 분해 방법론

"프린트엽서 가격계산 검증해줘" 한 줄을, 검증가가 일할 수 있는 work-spec으로 펼친다.

## 왜 이 방법론인가

한 줄 명령은 "이 상품을 이루는 모든 요소를 파악하고, 그 상품에 묶인 공식·구성요소가 권위대로 매핑·차원정합 됐는지 확인하라"를 함축한다. 이 해독 없이 검증하면 범위를 모르고 엉뚱한 데이터(예: 다른 SIZ)를 짚는다. 분해가 검증의 정확도를 결정한다.

## 분해 절차

### 1. 상품 정체 확정
- 상품명(prd_nm)으로 라이브 `t_prd_products`에서 prd_cd 조회. 상품군(카테고리)으로 상품마스터 시트·가격표 시트 특정.
- ★동명이품·별칭 주의: 라이브 prd_nm과 1:1 대조(substring 과매칭 금지). 모호하면 컨펌큐.

### 2. 요소 전수 분해
그 상품을 이루는 모든 요소를 권위 엑셀+라이브에서 추출(각 항목 출처 명기):
- 자재(mat_cd)·공정(proc_cd)·사이즈(siz_cd·siz_width/height)·도수(print_opt_cd)·인쇄옵션·묶음수(bdl_qty)·코팅면수(coat_side_cnt)·옵션(option_groups/items).
- 상품마스터 행의 "가격계산공식" 셀 = 상품군 공식 형태(합산형/면적매트릭스/고정 등).

### 3. 가격공식 사슬 식별
- 바인딩: `t_prd_product_price_formulas`(prd_cd→frm_cd).
- 공식: `t_prc_price_formulas`(frm_cd).
- 배선: `t_prc_formula_components`(frm_cd→comp_cd·addtn_yn·disp_seq).
- 구성요소: `t_prc_price_components`(comp_cd·use_dims·prc_typ).
- 단가행: `t_prc_component_prices`(comp_cd·차원·단가).

### 4. 기대 골든 케이스
- 가격표(권위)에서 대표 선택값+수량 케이스의 골든 final_price(verbatim·셀 출처). 검증가가 재계산값과 대조할 기준. 가공·반올림 임의 금지.

### 5. 3축 work-spec
후속 검증가·codex 교차검증가가 쓸 공통 입력:
- 축1(SOT 일치): 상품마스터 행 ↔ 가격표 구역 대조 대상.
- 축2(공식↔구성요소 매핑): 배선 목록 + 시트 차원경계(SOT 1) + U-7 binding-validity 관련 위반 후보.
- 축3(차원 매칭): use_dims ↔ 가격테이블 차원 ↔ component_prices 충전 차원 대조 대상.

## 확신도·안전 [HARD]
- 모든 항목에 확신도(확정·라이브/엑셀 / 추정 / 미지) + 출처. 미지는 컨펌큐(검증가가 추정으로 메우지 않게).
- 라이브 읽기전용 SELECT만·DB 미적재. 권위 엑셀 절대(v03/STALE 금지). 비밀값 비노출.
