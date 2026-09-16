---
paths:
  - "_workspace/huni-shopby/**"
  - "docs/shopby/**"
---

# §24 Harness: Huni-Shopby-Commerce — 카트→주문 통합 설계

라이브 DB 상품/계산가 → Shopby 장바구니→주문 종단 통합 설계(SB1~SB7·핵심 난제=동적 계산가 무손실 주입).
2R(260716): 인쇄↔쇼핑몰 도메인 경계 분할·주문→배송 종단·원고(업로드/Edicus) 흐름·전달값/DB 정보 명세(설계 전용·구현 없음).
2R 실증 정책(260716 사용자 승인): Shopby 실API 검증=결제 직전까지(테스트 회원 카트·주문서 생성 OK·결제 금지·잔여물 정리)·Shopby 어드민 등록 카테고리↔라이브DB 상품 매칭 명세 포함.
스킬=`huni-shopby-orchestrator` (트리거: Shopby 통합·장바구니 연동·카트 주문 흐름·도메인 경계·전달값 명세).
산출=`_workspace/huni-shopby/`. 입력 권위=`docs/shopby/`. 변경이력: 최신 2026-07-29 — **H4 관문 해소**(server-api 인증=systemKey+Authorization Bearer·mallNo 쿼리 제거, 옵션 addPrice 주입 PUT 200·원상복구 확인) + **상품 카탈로그 적재 완료**(라이브 실사용 217건 등록·카테고리 216 배정·중복 0·미지정 1) + **카테고리 구조 정비 완료**(1레벨 12개 일치·표기 통일·자동 매칭 181→211). Shopby 제약 9건 실측 기록=`13_product-load/README.md`. 잔여 관문=NHN "동적 가격 미지원" 정책 답신. 재시작=HANDOFF.md → CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §24.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
