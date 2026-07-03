---
paths:
  - "_workspace/huni-shopby/**"
  - "docs/shopby/**"
---

# §24 Harness: Huni-Shopby-Commerce — 카트→주문 통합 설계

라이브 DB 상품/계산가 → Shopby 장바구니→주문 종단 통합 설계(SB1~SB7·핵심 난제=동적 계산가 무손실 주입).
스킬=`huni-shopby-orchestrator` (트리거: Shopby 통합·장바구니 연동·카트 주문 흐름).
산출=`_workspace/huni-shopby/`. 입력 권위=`docs/shopby/`. 변경이력: 최신 2026-06-25 초기 구성+토대 큐레이터 → CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §24.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
