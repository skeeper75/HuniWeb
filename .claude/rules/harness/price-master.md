---
paths:
  - "_workspace/_foundation/batch/**"
  - "_workspace/_foundation/price-pipeline-rtm.csv"
---

# §27 Harness: 가격 종단 마스터 오케스트레이터 — 수렴 실행 조율자

8개 가격 하네스를 의존 순서(§26→§7→§18→§7→§21/§13/§15)로 엮어 상품군을 "제대로된 가격값"까지 완주.
스킬=`huni-price-master-orchestrator` (트리거: 가격 종단 파이프라인·formula_components 배선·배선 진척 보드).
RTM=`_workspace/_foundation/price-pipeline-rtm.csv`. 배선 측도=`_foundation/batch/wiring_scan.py`
(종료척도[HARD]=배선 결함 0+PRICE≠0). 변경이력: 최신 2026-07-04 ★통합 진단·교정 배치 hdx **P4**
(적대적 재실측 engine verbatim·3면 판정 가격중립/결함해소/무회귀·MutableSnapshot 오버레이·파일럿 GO·
음성대조 NO-GO·다음 P5 반자동 루프+OptionCpqDx+codex) ← P3 교정생성(값 날조 금지 라우팅·전건 라우팅·근본원인 dedup)
← P2 진단·보드(드리프트 0) ← P1 foundation ← 가격구성요소 병합 9군 GO + 타공 교정
→ `_workspace/huni-price-master/HANDOFF.md`·`_workspace/_foundation/hdx/HANDOFF.md`·각 CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §27.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
