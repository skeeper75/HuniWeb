---
name: hcc-basedata-conformance
description: >-
  후니프린팅 카탈로그 종단 정합 하네스의 기초데이터·차원 8축 정합 검사 방법론. authority-spec·체크리스트를
  기준으로 전 상품의 사이즈코드·도수·인쇄옵션·판형·자재·공정·묶음수·페이지룰이 라이브 t_prd_product_*에
  권위 엑셀대로 등록됐는지 ① 권위 엑셀 ② 라이브 실측 ③ 인쇄 도메인 의미 3원 대조로 전수 검사해 결함 보드 +
  채워진 커버리지 셀(빈 셀 0)을 산출한다. 결함마다 재현 쿼리·라우팅. 트리거: 기초데이터 정합 검사, 차원 축
  검사, 사이즈 도수 자재 공정 검사, 판형 묶음수 페이지룰, 등록 누락 적발, 오등록 잉여 적발, 기초데이터 검사
  다시. 생성측·교정 인간 승인. CPQ는 hcc-cpq-link-conformance, 가격은 hcc-price-engine-conformance.
---

# hcc-basedata-conformance — 기초데이터·차원 8축 정합 검사 방법론

## 목적

전 상품의 기초데이터 8축이 라이브에 권위 엑셀대로 등록됐는지 전수 대조해 결함 보드를 만든다.
**생성측** — 판정은 게이트가 독립 재실측.

## 3원 정합 원칙 [HARD]

모든 셀은 ① 권위 엑셀(authority-spec 인용) ② 라이브 실측(읽기전용 psql) ③ 인쇄 도메인 의미
(domain-lens) **세 면 대조**. 한 면만 보고 단정 금지. 결함마다 **재현 쿼리(psql 한 줄)** 첨부.

## 8축 검사 가이드

| 축 | 라이브 t_* | 검사 핵심 · 함정 |
|----|-----------|-----------------|
| 사이즈코드 | t_prd_product_sizes·t_siz_sizes | 작업/재단/판형 의미구분 보존(동의어 중복≠오류·[[dbmap-area-matrix-wh-dimension]]) |
| 도수 | t_prd_product_print_options | 도수=print_opt_cd(clr_cd 아님·[[huni-price-engine-diag-harness]]) |
| 인쇄옵션 | t_prd_product_print_options | 인쇄면/방식 enum |
| 판형 | t_prd_product_plate_sizes·plate_sizes | 판형=출력용지(전지)·[[dbmap-platesize-is-output-paper]]·누락 전지 등록건([[dbmap-platesize-missing-register-260610]]) |
| 자재 | t_prd_product_materials·t_mat_materials | 색/형상/사이즈 오염 경계([[dbmap-material-option-normalization]]) |
| 공정 | t_prd_product_processes | 택일그룹=인쇄방식 레시피([[dbmap-process-select-group-domain]]) |
| 묶음수 | t_prd_product_bundle_qtys | bdl_qty 정합 |
| 페이지룰 | t_prd_product_page_rules | 책자류 페이지 제약 |

## 판정 유형

`MATCH` · `MISSING`(권위○ 라이브✗=누락) · `EXTRA`(라이브○ 권위✗=잉여/오염) · `MISMATCH`(값 다름=오등록)
· `N/A`(needed=N) · `CONFIRM`(권위 충돌·도메인 모호) · `BLOCKED`(접근 불가, 사유 명시).

## 워크플로

1. checklist에서 owner=basedata 셀 로드(전 상품 × 8축).
2. 권위값: `24_master-extract-260610/*.csv`에서 축별 컬럼 추출(재파싱 금지·캐시 우선).
3. 라이브값: prd_cd별 t_prd_product_* 자식 행을 배치 psql로 집계(쿼리 최소화).
4. 3원 대조 → 셀 verdict + 결함이면 보드 행.
5. 모든 셀 채움(빈 셀 0). 못 채운 셀은 BLOCKED로 명시.

## 함정 (false-positive 가드)

- 의미구분(작업/재단/판형/단위/상품전용)을 "중복"으로 오판 금지([[dbmap-price-component-grouping]] 종류축 누락 오독).
- 라이브 enum 추론 < 엑셀 명시값([[dbmap-option-material-process-bundle]]).
- 번호 연속·인쇄방식 절대축 추론 금지([[dbmap-print-method-not-absolute-axis]]).

## 산출 (`_workspace/huni-catalog-conformance/02_basedata/`)

`basedata-defect-board.md`(결함: 위치·증상·권위 정답·라이브·도메인 근거·재현 쿼리·라우팅) ·
`basedata-cells.csv`(prd_cd,axis,verdict,evidence) · `basedata-coverage-note.md`(BLOCKED 정직 명시).

## 라우팅

직접 교정 금지. 자재 오염→dbm-axis-staged-load · siz/코드행→dbm-load-builder · 변경 추적→dbm-correctness-audit.
