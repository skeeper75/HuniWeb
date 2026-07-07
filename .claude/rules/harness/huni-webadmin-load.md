---
paths:
  - "_workspace/huni-webadmin-load/**"
---

# §36 Harness: Huni-Webadmin-Load — webadmin UI 전용 적재·가격시뮬레이터 완성

**목표:** 라이브 DB 직접 적재 없이 **오직 webadmin UI**로 상품 가격을 등록·교정해, 가격시뮬레이터에서
**예측 기대값(권위 셀)=실제 가격·제외0** 달성. 잘못된 차원 매핑 전수 교정·전 메뉴 누락 0.
**스킬:** `huni-webadmin-load-orchestrator`(적재·교정 조율) · `hwl-drift-remediation`(base-data 드리프트 전수 진단·교정) — 트리거: webadmin UI 적재·UI 등록·가격시뮬레이터 완성·잘못된 차원 매핑·예측vs실제·드리프트 진단·가격 커버리지 검증.
**산출물:** `_workspace/huni-webadmin-load/`(PATH-MAP·preflight.py·MAPPING-DEFECTS·LOAD-LOG·VERIFY-*·batch-scan/). 결정론 verifier=`raw/webadmin/tools/verify_price_coverage.py`.
**핵심 규칙:** [HARD] 라이브 DB 직접 적재/psql 쓰기 금지·webadmin UI만(gstack). [HARD] 착수 전 preflight(SOT+엑셀 셀·코멘트+코드)·재질문 금지. 종료=제외0·예측=실제.
**변경이력:** 최신 2026-07-07 사이즈 매핑 감사(인쇄도메인·블리드)+비규격 정합 — 결정론 `verify_size_mapping.py`(재단그룹+블리드+비규격 인지) 신설·WRONG_CODE 4 진단(스티커→SIZ_000426·맥세이프→559·교정 대기), 비규격 권위="사용자입력"→폼보드(129) nonspec_yn Y 플립. 앞서: 드리프트 전수 완결(verify_price_coverage.py·오탐0·실7건 교정·DRIFT0)+hwl-drift-remediation 스킬+drift-dashboard.html. → `_workspace/huni-webadmin-load/CHANGELOG.md`
