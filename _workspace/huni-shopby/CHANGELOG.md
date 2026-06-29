# Huni-Shopby-Commerce — CHANGELOG

라이브 DB 상품/가격 → Shopby(NHN Commerce) 장바구니→주문 종단 통합 설계 하네스. (CLAUDE.md §24)

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-25 | ★재게이트 R2 — **GO (CONDITIONAL)**. 직전 NO-GO(R1)의 8 FAIL 드라이버(X03 salePrice=0 불변식·X04 put-product-options full shape·X05 server API systemKey 인증분리·X07 recurringPaymentDelivery·X08 addressRequest·X09 reserve 필수9·X10 guest-token POST+password·X11 클레임 추적)가 설계 본문에 전부 보정 반영됨을 게이트가 스펙 라인 직접 재대조해 verified(반증 0). SB1~SB7 단일 FAIL 0·신규 결함 0. 라이브 토대 재실측 104(공식78∪직접단가26)·골든 PRD_000016(공식 PRF_DGP_A·옵션그룹8)·라인 가격필드 0건 드리프트 0. CONDITIONAL 사유=I-PRICE-1/2/3 BLOCKED(상품심사·정산권위·동시성/클레임추적, 실 구현 전 인간 승인·갭필 선결). | 05_gate/gate-verdict·e2e-golden-trace·remediation-spec | 재게이트(직전 NO-GO 항목 해소 확인): architect 보정 루프 후 8 교정 CLOSED |
| 2026-06-25 | ★선행 토대 큐레이터 추가 — `hsb-foundation-curator` + `hsb-foundation` 스킬. Phase 1에 후니 측 선행 토대(① webadmin 상품+구성요소 선택→evaluate_price→final_price 가격계산 흐름 ② 라이브 DB 적재 현황·결함/갭)를 기존 §13/§14/§21/§7 산출 재사용으로 못박는 단계 신설. 브리지를 토대+커머스 종합 단계로 재배선(5→6 에이전트). 워크스페이스 `00_foundation/` 추가. | hsb-foundation-curator·orchestrator·CLAUDE.md §24 | 사용자 피드백: webadmin 상품+구성요소 선택→가격계산·라이브 DB 적재 현황이 Shopby 브리지의 선행 리서치여야 함 |
| 2026-06-25 | 하네스 초기 구성 — 5 에이전트(hsb-commerce-researcher·hsb-product-bridge-analyst·hsb-integration-architect·hsb-codex-verifier·hsb-integration-gate) + 6 스킬 + SB1~SB7 게이트. Shopby=커머스 백엔드 확정(`shopby-excluded-from-scope` 결정 갱신). 범위=리서치+통합설계(구현은 §6 위임)·문서 권위+라이브 갭필·브리지 전략은 하네스 권고. | 전체 | 사용자 요청: 라이브DB 상품/가격을 카트에 전달, 추후 위젯으로 주문 완료 흐름 구성 |
