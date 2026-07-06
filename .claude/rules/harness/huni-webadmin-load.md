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
**변경이력:** 최신 2026-07-07 박 소형+대형 6 comp dim_vals 교정 완료 + 형압 별도 EMBOSS 컴포넌트 신설·배선·검증 완료(무선/PUR책자). 범위=has_proc=t 공정만(포스터/아크릴 제외). 교훈=3단계 순서(proc_grp+siz유지→그리드저장→siz제거)·공식배선 인라인+autocomplete option 주입 → `_workspace/huni-webadmin-load/CHANGELOG.md`
