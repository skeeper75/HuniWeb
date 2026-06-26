# Huni-Recode CHANGELOG (역공학 코드 가독화 · §25)

> 최신 상단. 라이브 시작점은 `HANDOFF.md`.

## 2026-06-26 — editor 핵심메서드 의미화 + 07 재추출/가능성 타진
- **editor_sdk GO·개선 COMMIT(e6e479b)**: 핵심 메서드(createProject·prepareOrder·setPrice 등 10) 로컬을 역할범주명→의미명 상향. 독립 재검증 G2 동작보존 유지·기계명 **450→268**(160종, _iter*=반복자 역할명 정상). 나머지 메서드 역할명 유지(사용자: 핵심함수만).
- **07 비절단 재추출**: `beautified_widget.js`[18501,22747]에서 **합성 래퍼 없이** 균형 추출 → `03_deobfuscated/deob_07_app_components.full.js`(186KB·파싱OK). G2를 진짜 full.js 기준 통과(합성 recovered.js 폐기). 단 원시 minified라 **G4 NO-GO**(1421 단문자) — v1 디옵본(044cc2b)은 읽기 좋으나 절단.
- **G4b 의미품질 게이트 추가**: readability-metrics.cjs에 역할범주명(`_arg/_val/_reg/_tmp/_iter`) 별도 집계·`fullySemantic` → "GO지만 의미 미완" 구분.
- **07 가능성 타진(workflow)**: 1421 의미부여 실현가능성 = **中上·PARTIAL-SETUP-ONLY**. v1 정렬 전이 건전(187/187 무오류·자동 ~40-47%)·꼬리 반자동 ~30-37%·머리 distinct ~123(강근거 ~40)·render=명명대상 아님(재작성)·free-ref=외부청크 필요. **포팅 가치=setup 도메인/상태/API 모델**(변수명만 불충분). → `_meta/deob07-feasibility-verdict.md`.
- 하네스 자가진화: 검증자가 ast-structural-diff에 포매팅 정규화(블록/논리식 결합법칙) 추가·structural-rename.cjs 신설(역할기반 안전 리네이머). API 과부하로 1차 워크플로 ~14h 정체 → TaskStop+resume로 복구.

## 2026-06-25 — 하네스 초기 구성 + 동적 워크플로 1차 산출 (COMMIT 044cc2b)
- 하네스 Huni-Recode 신설: 5 rcd-* 에이전트(로컬)·3 스킬(huni-recode-orchestrator 추적·rcd-ast-deobfuscate/rcd-equivalence-verify 로컬)·AST 코드모드/검증 스크립트.
- dynamic workflow로 4파일 가독화: **05/06 정식 GO**(바이트동일 AST·잔여0)·07 조건부(합성복원)·editor 부분(서드파티 9108줄 fold·문서화 52식별자).
- 기법: LLM 이름추론→AST scope.rename→AST 구조동등성(G2) 동작보존 증명. 길잡이 문서 7종.
