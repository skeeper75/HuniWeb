---
name: hcc-conformance-gate
description: >-
  후니프린팅 카탈로그 종단 정합 하네스의 독립 검증 게이트 방법론(생성≠검증). 인스펙터 결함 보드·커버리지 셀·
  codex reconcile를 라이브 읽기전용 재실측 + ★gstack browse로 product-viewer 라이브 화면(엑셀↔DB↔화면 3원)
  대조 + evaluate_price 재계산으로 독립 재판정해 K1~K8 게이트로 GO/NO-GO를 낸다(누락 0 커버리지·기초데이터·
  CPQ 연결·가격엔진·종단 e2e 추적·codex 수렴·생성검증 독립성). 확정 결함은 교정 명세(dbmap 라우팅·인간 승인)로
  종합. 트리거: 정합 게이트, K1 K8, 독립 재실측, product-viewer 라이브 확인, gstack 화면 대조, 커버리지 누락 0
  검증, 교정 명세 종합, 종단 e2e 골든 추적, 게이트 다시. 생성자 주장 비신뢰·라이브 읽기전용·DB 미적재.
---

# hcc-conformance-gate — 독립 검증 게이트 방법론 (생성≠검증)

## 목적

생성측(인스펙터·codex) 산출을 **신뢰하지 않고 직접 재실측**해 GO/NO-GO를 내고, 확정 결함을 교정 명세로
종합한다. 이 하네스가 "e2e 베스트프랙티스 정석"이 되는 마지막 관문.

## ★gstack product-viewer 라이브 확인 [HARD] (사용자 명시)

대표 상품 + 의심 결함분을 `browse`(gstack) 스킬로 라이브 product-viewer에서 직접 열어 **엑셀↔DB↔실제
화면 3원 대조**(전수 아님·세션 비용 큼).
- URL: `https://huni-admin-production.up.railway.app/admin/product-viewer/`.
- 자격증명 `.env.local HUNI_ADMIN_*`(없으면 블로커 보고·추측 로그인 금지). [[dbmap-live-admin-product-viewer]].
- 12편집탭(=t_prd_product_*) 캡처로 결함이 실제 화면에 나타나는지 확인. `06_gate/captures/`. 저장/삭제 클릭 금지.

## K1~K8 게이트

| 게이트 | 판정 | 방법 |
|--------|------|------|
| K1 커버리지 누락 0 | checklist 모든 셀 채워졌나(빈 셀=NO-GO) | cells.csv 3종 ↔ checklist 대조 |
| K2 기초데이터 정합 | basedata 결함 표본 재실측 일치하나 | 라이브 psql 재실측 |
| K3 CPQ 연결 무결성 | 옵션→차원·템플릿→추가상품 dead link 표본(고아 0) | polymorphic 해소 재실측 |
| K4 가격엔진 정합 | 바인딩·use_dims 3원·단가행 재실측 | 진단 뷰·psql |
| K5 종단 e2e 추적 | 옵션→차원→단가행→final_price 재현(허용오차 0) | evaluate_price 재계산 |
| K6 라이브 화면 대조 | 엑셀↔DB↔화면 일치 | gstack product-viewer |
| K7 codex reconcile 수렴 | 불일치·codex 신규발굴 후보 라이브 최종 판정(미해결 0) | 05_codex/reconcile.md |
| K8 생성≠검증 독립성 | 네가 직접 재실측한 증거인가(주장 인용만 PASS 금지) | 자체 재현 SQL/캡처 |

단일 FAIL = NO-GO. 정직한 BLOCKED(자격증명·접근 불가)는 사유 명시 시 CONDITIONAL.

## K5 종단 골든 추적 (정석)

대표 상품 1건에 대해 사용자 옵션 선택부터 최종 가격까지 완전 재현:
`옵션 선택값 → polymorphic 차원 환원 → component_prices 단가행 매칭 → evaluate_price → final_price`.
권위 골든값과 수치 대조(오차 0). 이 추적이 e2e 정합의 살아있는 증거다.

## 교정 명세 (개선/보완/수정안)

확정 결함을 실행 가능하게: `{결함·권위 정답·교정 방법·대상 t_*·FK 위상·돈영향·dbmap 트랙·인간 승인 필요}`.
직접 COMMIT 금지·search-before-mint 준수. 실 적재는 인간 승인 후 dbmap 트랙(dbm-axis-staged-load·
dbm-load-execution·dbm-correctness-audit·dbm-option-mapper·dbm-price-arbiter) 위임.

## 산출 (`_workspace/huni-catalog-conformance/06_gate/`)

`conformance-verdict.md`(K1~K8 판정·증거·종합 GO/NO-GO) · `remediation-spec.md`(교정 명세·인간 승인 큐) ·
`e2e-golden-trace.md`(K5 정석) · `captures/`(product-viewer 3원 대조).

## 안전 [HARD]

라이브 읽기전용 SELECT만·gstack 저장/삭제 금지·DB 미적재·비밀값(스크린샷 포함) 비노출·생성자 주장
비신뢰·근거 못 찾으면 NO-GO.
