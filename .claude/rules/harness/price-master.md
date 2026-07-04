---
paths:
  - "_workspace/_foundation/batch/**"
  - "_workspace/_foundation/price-pipeline-rtm.csv"
---

# §27 Harness: 가격 종단 마스터 오케스트레이터 — 수렴 실행 조율자

8개 가격 하네스를 의존 순서(§26→§7→§18→§7→§21/§13/§15)로 엮어 상품군을 "제대로된 가격값"까지 완주.
스킬=`huni-price-master-orchestrator` (트리거: 가격 종단 파이프라인·formula_components 배선·배선 진척 보드).
RTM=`_workspace/_foundation/price-pipeline-rtm.csv`. 배선 측도=`_foundation/batch/wiring_scan.py`
(종료척도[HARD]=배선 결함 0+PRICE≠0). 변경이력: 최신 2026-07-05 ★hdx **등록 점검표(권위 엑셀↔DB 대조)로
키링류 저청구 7상품 라이브 교정**(webadmin 실화면이 오진단 자기교정=고리 base자재 오모델→addon 방식·HIGH 4→0·
지니 재설정: 엑셀=권위값 매핑·default-approve) ← 통합 진단·교정 배치 hdx 가격 파일럿 완성(진단 9차원 전 커버·--loop)
← P5-① 반자동 라운드 러너 ← P4 적대적 재실측 ← P3 교정생성(값 날조 금지) ← P2 진단·보드(드리프트 0) ← P1 foundation
→ `_workspace/huni-price-master/HANDOFF.md`·`_workspace/_foundation/hdx/HANDOFF.md`·각 CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §27.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
