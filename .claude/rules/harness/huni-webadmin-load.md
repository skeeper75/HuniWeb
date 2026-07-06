---
paths:
  - "_workspace/huni-webadmin-load/**"
---

# §36 Harness: Huni-Webadmin-Load — webadmin UI 전용 적재·가격시뮬레이터 완성

**목표:** 라이브 DB 직접 적재 없이 **오직 webadmin UI**로 상품 가격을 등록·교정해, 가격시뮬레이터에서
**예측 기대값(권위 셀)=실제 가격·제외0** 달성. 잘못된 차원 매핑 전수 교정·전 메뉴 누락 0.
**스킬:** `huni-webadmin-load-orchestrator` — 트리거: webadmin UI 적재·UI 등록·가격시뮬레이터 완성·잘못된 차원 매핑·예측vs실제·프리미엄명함 적재.
**산출물:** `_workspace/huni-webadmin-load/`(PATH-MAP·preflight.py·MAPPING-DEFECTS·LOAD-LOG·VERIFY-*).
**핵심 규칙:** [HARD] 라이브 DB 직접 적재/psql 쓰기 금지·webadmin UI만(gstack). [HARD] 착수 전 preflight(SOT+엑셀 셀·코멘트+코드)·재질문 금지. 종료=제외0·예측=실제.
**변경이력:** 최신 2026-07-06 박 차원 교정 설계 확정(가로×세로=공정상세옵션→dim_vals·오시 동형·데이터만·siz_width 제거는 값 이전과 동시)+하네스 신설(경로맵·preflight·에이전트5·프리미엄명함 파일럿) → `_workspace/huni-webadmin-load/CHANGELOG.md`
