# Huni-Recode HANDOFF (역공학 코드 가독화 · §25)

> 이 파일 = **이 하네스의 단일 라이브 시작점.** 다음 세션은 CLAUDE.md §25 → 이 파일 → CHANGELOG.md 순으로 읽고 재개.
> 산출 루트 `docs/reversing/red_reverse_engineer/05_readable/`. 오케스트레이터 스킬 `huni-recode-orchestrator`.

## 다음 시작점 (정확한 다음 행동)
**deob_07 처리 경로 결정이 미정** — 가능성 타진 완료(`_meta/deob07-feasibility-verdict.md`, 판정 **中上·PARTIAL-SETUP-ONLY**). 사용자에게 경로 확인 후 실행:
- (권장) setup 가독화 + 포팅 모델 추출 / 포팅 모델만 / setup 가독화만 / 보류.
- ★사용자 선호: **구조화 선택지로 바로 가지 말고 대화로 먼저 클arify**(2회 그렇게 요청함).
- 실행 시 PARTIAL-SETUP-ONLY: 공유 20컴포넌트=v1 이름맵 **자동 전이**(정렬 187/187 무오류) → 꼬리 30=반자동 → 머리 6=선별 수작업(distinct ~123, 강근거 ~40 우선·temp 면제) → **render/temp/free-ref 제외** → G4(setup 스코프 잔여0)+G6 게이트.
- 동적 워크플로(Workflow) + API 과부하 시 **resume**(scriptPath+resumeFromRunId·성공분 캐시).
- **읽기 좋은 07을 즉시 원하면**(재디옵 없이): `git checkout 044cc2b -- docs/reversing/red_reverse_engineer/05_readable/02_readable/deob_07_app_components.js` (v1 디옵본 복원).

## 현 상태 (4파일)
| 파일 | 상태 | 커밋 |
|------|------|------|
| 05_app_api | ✅ 정식 GO (바이트동일 AST·잔여0·읽기 좋음) | 044cc2b |
| 06_widget_sdk | ✅ 정식 GO | 044cc2b |
| editor_sdk | ✅ GO·개선 (G2 보존·기계명 450→268·핵심 메서드 의미화) | e6e479b |
| 07_app_components | ⚠️ **미결** | — |

**07 이중 상태**: working tree/현 HEAD = `full.js` 기반(클린 소스·합성래퍼 없음·**G2 pass vs full.js**)이나 **원시 minified(1421 단문자·G4 NO-GO·읽기 나쁨)**. 읽기 좋은 **v1**(디옵·절단·1컴포넌트만 합성래퍼)은 **커밋 044cc2b**에 보존. `full.js`(186KB 클린 소스)·`01_cartography/deob_07_full/` 맵·feasibility 판정 = 재디옵 자산.

## 미해결 / 블로커
- 07 경로 결정(위). **전부 1421 명명은 ROI 음수** — render=재작성영역(컴파일·비가역)·free-ref=외부청크(PaperModule 등) 필요·head temp 67% 면제.
- **포팅엔 변수명만 불충분** → 도메인규칙·상태흐름·API계약(타입·DTO·의존) 모델이 실질.
- editor 잔여 ~233 역할명(비핵심 메서드) = 의도적 미완(사용자: 핵심함수만). 추가 심화는 선택.

## 이번 세션 결정 (재논쟁 금지)
- 하네스 Huni-Recode 신설(§25). 기법: **LLM 이름추론 → AST scope.rename(텍스트치환 금지) → AST 구조동등성(G2)으로 동작보존 증명**. 서드파티 in-place fold(삭제 아님). **G4b 의미품질 게이트**(역할범주명 `_arg/_val/_reg/_tmp` 별도 집계 → GO 과대표기 방지).
- 사용자 확정: 가독소스+문서 / **실행가능 동등 유지**(→AST 안전변환) / 서드파티 분리·요약 / G4b 추가 / editor=핵심함수만 심화 / 07=00_raw 재추출.
- 07 재추출 결과: 절단/합성래퍼 제거·G2 클린 달성, **그러나 재-minify**(v1 디옵은 별도 패스라 전체 모듈엔 부재).
- **v1 정렬 전이 건전**(187/187 무오류)·단 v1은 순수 리네임 아님(구조편집 섞임) → **이름맵만 전이 오라클, v1 AST는 G2 오라클 아님**.

## 건드리지 말 것
- 05/06/editor 가독본(커밋된 GO). v1 07(044cc2b). 도메인 preserve 식별자(PDT_CD·PRICE·COD…). `_tooling/node_modules`.

## 도구·게이트 (재현)
- Node + @babel + prettier@2.8.8 in `_tooling/`. `RCD_NM=<abs>/_tooling/node_modules`.
- 코드모드: `.claude/skills/rcd-ast-deobfuscate/scripts/`(apply-rename-map·fold-thirdparty·**structural-rename**[역할기반 안전 리네이머]). 검증: `rcd-equivalence-verify/scripts/`(parse-check·ast-structural-diff[포매팅 정규화 포함]·readability-metrics[+G4b]). ★메서드 스킬·rcd 에이전트는 `.claude` gitignore상 **로컬**(추적 안 됨·원하면 force-add).
- 게이트: G1 구문 · G2 AST구조동등(동작보존) · G3 서드파티무손실 · G4 잔여단문자0 · **G4b 역할범주명(의미품질)** · G5 preserve불변 · G6 생성검증독립.

## 핸드오프 우선순위 (여러 문서일 때 기준)
1. **CLAUDE.md** = 진입 인덱스(매 세션 로드). §5~§25 각 하네스의 트리거·산출루트·`변경이력 최신 <날짜>`.
2. **HANDOFF.md(이 파일)** = 해당 하네스의 **단일 라이브 시작점**(매 세션 덮어씀=항상 최신).
3. **CHANGELOG.md** = 이력(최신 상단·날짜).  `_meta/*`·verdict = 분석 자산(시작점 아님).
- 규칙: **작업 도메인 → CLAUDE.md 트리거로 하네스 식별 → 그 하네스의 HANDOFF.md 하나**. 하네스마다 HANDOFF는 독립(경쟁 아님). 충돌 시 HANDOFF(라이브)+CHANGELOG 최신행 우선.
