---
paths:
  - "_workspace/huni-set-product/**"
---

# §23 Harness: Huni-Set-Product — 셋트상품 구성·설계·적재

셋트 완제품←반제품 구성(`t_prd_product_sets`) 설계·evaluate_set_price 정합·자체 적재(S1~S8·인간 승인).
스킬=`huni-set-product-orchestrator` (트리거: 셋트상품 구성/설계·t_prd_product_sets 적재·셋트 가격).
산출=`_workspace/huni-set-product/`. 핵심: 면지=1멤버 내부 택1 목표모델·내지 min/max=구성원개수[HARD].
변경이력: 최신 2026-07-03 레더/하드커버 면지 통합 재설계 4셋트(072/077/082/088) 라이브 COMMIT 완주
(골든 무손상·undo 보유) → `_workspace/huni-set-product/HANDOFF.md`·`CHANGELOG.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §23.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
