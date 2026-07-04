---
paths:
  - "_workspace/_foundation/batch/**"
  - "_workspace/_foundation/price-pipeline-rtm.csv"
---

# §27 Harness: 가격 종단 마스터 오케스트레이터 — 수렴 실행 조율자

8개 가격 하네스를 의존 순서(§26→§7→§18→§7→§21/§13/§15)로 엮어 상품군을 "제대로된 가격값"까지 완주.
스킬=`huni-price-master-orchestrator` (트리거: 가격 종단 파이프라인·formula_components 배선·배선 진척 보드).
RTM=`_workspace/_foundation/price-pipeline-rtm.csv`. 배선 측도=`_foundation/batch/wiring_scan.py`
(종료척도[HARD]=배선 결함 0+PRICE≠0). 변경이력: 최신 2026-07-04 ★통합 진단·교정 배치 hdx **P2**
(5 Diagnoser 어댑트+통합 결함보드 CSV/HTML·가격 파일럿 331건·드리프트 0·다음 P3 Remediator) ← P1 foundation
← 가격구성요소 병합 9군 GO(27→9) + 타공 교정/병합/저청구
→ `_workspace/huni-price-master/HANDOFF.md`·`_workspace/_foundation/hdx/HANDOFF.md`·각 CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §27.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
