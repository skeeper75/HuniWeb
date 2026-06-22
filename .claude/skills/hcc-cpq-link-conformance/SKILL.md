---
name: hcc-cpq-link-conformance
description: >-
  후니프린팅 카탈로그 종단 정합 하네스의 CPQ L2 연결 정합 검사 방법론. authority-spec·체크리스트를 기준으로
  전 상품의 옵션그룹·제약규칙·추가상품·추가상품 템플릿과 ★두 연결(옵션→차원 polymorphic ref_dim_cd 해소·
  템플릿→추가상품 묶음)이 권위대로 배선됐는지 3원 대조로 전수 검사해, 끊긴 연결(dead link)·고아 참조·
  오배선·JSONLogic 제약 부정합을 결함 보드 + 연결 해소 매트릭스로 산출한다(빈 셀 0). 트리거: 옵션 연결 검사,
  CPQ 정합, 옵션 차원 연결, 템플릿 추가상품 연결, 제약규칙 검사, ref_dim_cd 해소, dead link 적발, CPQ 검사
  다시. 생성측·교정 인간 승인. 기초데이터는 hcc-basedata-conformance, 가격은 hcc-price-engine-conformance.
---

# hcc-cpq-link-conformance — CPQ L2 연결 정합 검사 방법론

## 목적

전 상품의 CPQ 옵션 레이어 + **연결 배선**이 권위대로인지 전수 대조. 사용자 핵심 요구: "옵션으로 차원을
연결하거나 템플릿으로 추가상품을 함께 연결하는 부분까지 모두 확인." **생성측**.

## 검사 대상

| 대상 | 라이브 t_* | 핵심 |
|------|-----------|------|
| 옵션그룹 | t_prd_product_option_groups | 택1/택N·disp_seq=권위 표시순서([[dbmap-tierA-cpq-option-load]]) |
| 옵션·항목 | t_prd_product_options·option_items | 권위 옵션성 속성이 옳은 그룹에 |
| 제약규칙 | t_prd_product_constraints | JSONLogic 정합(사이즈→추가상품/박/접지 min·max) |
| 추가상품 | t_prd_product_addons | addtn_yn·합산 귀속([[dbmap-acrylic-price-chain-link]]) |
| 추가상품 템플릿 | t_prd_templates·연결 | 묶음 정합 |

## ★두 연결 무결성 [HARD] (사용자 강조)

### 옵션→차원 (polymorphic)
각 option_item의 `(ref_dim_cd, ref_key1, ref_key2)`가 대상 차원 테이블(siz/mat/proc/print_opt/plate/bdl
등)의 **실재 행으로 100% 해소**되는가. 고아 참조 1건도 = 그 옵션 선택 시 차원 환원 실패 → 견적 불가.
- 트리거 `fn_chk_opt_item_ref` 무결성 점검.
- 해소율 = 해소된 참조 / 전체 참조. 100% 미만이면 dead link 목록.
- [[dbmap-cpq-option-layer-mapping]] reference resolution = L2 핵심검사.

### 템플릿→추가상품
추가상품 템플릿이 묶은 연결상품이 권위(상품마스터 추가상품/세트 컬럼)대로인가. 끊긴 묶음 = 추가상품이
견적·주문에 안 붙음. 누락·오묶음·고아 템플릿 적발.

## 3원 정합 원칙 [HARD]

① 권위 엑셀 ② 라이브 실측(psql) ③ 도메인 의미(옵션=자재+공정 BUNDLE [[dbmap-option-material-process-bundle]]).
판정: MATCH/MISSING/EXTRA/MISMATCH/**DEAD_LINK**/N/A/CONFIRM/BLOCKED. 결함마다 재현 쿼리.

## 워크플로

1. checklist owner=cpq-link 셀 로드.
2. 라이브 CPQ 레이어 배치 조회(option_groups→options→option_items, constraints, addons, templates).
3. 연결 해소: option_items polymorphic FK를 대상 차원 테이블에 LEFT JOIN으로 해소율 측정·고아 추출.
4. 템플릿 묶음을 권위 추가상품/세트 컬럼과 대조.
5. 3원 대조 → 셀 verdict + 결함 보드. 빈 셀 0.

## 산출 (`_workspace/huni-catalog-conformance/03_cpq_link/`)

`cpq-defect-board.md` · `link-integrity-matrix.md`(상품별 옵션→차원 해소율·고아 목록·템플릿→추가상품 묶음 상태) · `cpq-cells.csv`.

## 라우팅

직접 교정 금지. CPQ 오배선→dbm-option-mapper · 제약→dbm-cpq-option-mapping 트랙.
