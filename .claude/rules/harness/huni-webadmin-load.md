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
**변경이력:** 최신 2026-07-07(후속8) 떡메모지 de-set 진단·설계·검증 — 껍데기 셋트(097 단일구성원) 삼중 corroboration(사용자직관+가격표SOT+RED라이브)·전 사슬 검증·셋트경로=단일경로 가격동일 실증(리그레션0). **BLOCKER**=셋트행(복합PK 인라인) 논리삭제 경로 WebUI 부재(물리삭제만)→(a)물리삭제 vs (b)DEV-REQUEST 결정 대기. 명목상-셋트 전수(19셋트 4버킷)·미팅결정 6항 기록. 앞서: 사이즈 매핑 감사(verify_size_mapping.py·WRONG_CODE4)+비규격 폼보드 플립+드리프트 전수 완결(DRIFT0). → `_workspace/huni-webadmin-load/CHANGELOG.md`
