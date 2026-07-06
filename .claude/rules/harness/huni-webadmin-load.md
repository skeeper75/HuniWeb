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
**변경이력:** 최신 2026-07-07 전상품 배치 진단 스캐너(batch-scan/·v4)로 260상품 진단→진짜결함 5 전부 교정(모양명함 siz재키·봉투 mat재키+사이즈등록·스티커2 판수/낱장 신규적재·머그컵 직접가). ★체계적 근본원인=상품 base코드≠가격 base코드 드리프트·사이즈는 작업치수로 판정·굿즈=직접가. 다음=드리프트 전수 스캐너 → `_workspace/huni-webadmin-load/CHANGELOG.md`
