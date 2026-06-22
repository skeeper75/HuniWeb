# HuniWeb — 진입점 참조

> 개요: [overview.md](overview.md) | 모듈: [modules.md](modules.md) | 의존성: [dependencies.md](dependencies.md) | 데이터 흐름: [data-flow.md](data-flow.md)

---

## 5개 도메인 하네스 오케스트레이터 스킬

사용자가 자연어 트리거로 호출하는 직접 진입점이다. 각 오케스트레이터 스킬이 에이전트 팀을 스폰하고 파이프라인을 관리한다.

| 스킬 | 트리거 키워드 (예시) | 구동 결과 |
|------|-------------------|---------|
| `print-quote-orchestrator` | "후니프린팅 자동견적 사이트 설계", "경쟁사 분석", "견적 마법사 설계", "설계서 작성", "특정 영역 재설계" | 5인 팀(pq-pm·researcher·business-analyst·architect·designer)이 기획/설계 문서 일체를 `_workspace/print-quote/`에 산출 |
| `huni-widget-orchestrator` | "후니 위젯 구현", "인쇄 자동견적 위젯", "위젯 하네스 실행", "역공학 보강", "위젯 빌드", "위젯 QA", "코드 정합", "확대 스테이지", "시각재현" | 7인 파이프라인(reverse-engineer→runtime-analyst·researcher→architect→builder→qa·design-fidelity)이 React 위젯을 `_workspace/huni-widget/04_build/`에 구현·검증 |
| `huni-dbmap-orchestrator` | "DB 매핑", "Railway DB", "상품마스터 매핑", "가격표 매핑", "적재 준비", "round-4", "라이브 정합 교정", "round-13", "webadmin 스키마 변경 추적", "round-14" | 최대 12인 팀이 round 체계(1~14)로 `_workspace/huni-dbmap/`에 매핑 설계서·적재 CSV·검증 게이트 산출 |
| `huni-admin-manual-orchestrator` | "admin 매뉴얼", "관리자 매뉴얼 작성", "운영자 가이드", "매뉴얼 하네스 실행", "문서 사이트 발행", "docs 빌드" | 6인 팀(source-analyst→db-verifier·live-capturer→manual-writer→manual-qa→docs-publisher)이 운영자 매뉴얼 + MkDocs 사이트를 `_workspace/huni-admin-manual/`에 산출 |
| `print-kb-wiki-orchestrator` | "LLM 위키", "karpathy 위키", "레시피 위키", "위키 구축", "특정 상품군만 위키", "위키 검증", "큐레이션 다시" | 4인 파이프라인(source-curator·researcher→recipe-writer→wiki-qa)이 11 family 레시피 위키를 `_workspace/print-kb/wiki/`에 집필 |

---

## harness:harness — 메타 스킬 (하네스 신설용)

| 스킬 | 트리거 | 구동 결과 |
|------|--------|---------|
| `harness:harness` | `/harness:harness` (명시 호출) | 신규 도메인 하네스를 설계: 에이전트 정의 파일 + 스킬 파일 + 오케스트레이터 스킬 생성, CLAUDE.md에 하네스 섹션 등록 |

사용 예시: "webadmin 변경 추적 하네스 신설"(→ round-14 스킬 신설), "라이브 정합 교정 하네스 신설"(→ round-13 스킬 신설) 등 이미 5개 하네스 모두 이 스킬로 확장되었다.

---

## moai — MoAI 프레임워크 스킬 (gated)

| 스킬 | 서브커맨드 | 용도 |
|------|----------|------|
| `moai` | `/moai plan` | SPEC-First 계획 수립 (EARS 형식) |
| `moai` | `/moai run` | DDD/TDD 기반 구현 실행 |
| `moai` | `/moai sync` | 문서 동기화 (코드맵·API 문서) |
| `moai` | `/moai design` | 디자인 GAN 루프 (브랜드 컨텍스트 의존) |

이 리포지토리에서는 드물게 사용. 세부 규칙은 `.claude/rules/moai/` 및 `.moai/_archive/CLAUDE-full-moai-2026-06-05.md` 참조.

---

## 세션 핸드오프 트리거

코드 작성이나 하네스 실행이 아닌, **세션 마무리용** 진입점이다. `CLAUDE.md §4`에 정의된 루틴이 실행된다.

| 트리거 표현 | 실행 내용 |
|-----------|---------|
| "다음세션을 위해 정리" | 활성 하네스 HANDOFF.md 갱신 + CLAUDE.md 변경이력 갱신 + auto-memory 갱신 + 커밋 |
| "핸드오프 정리" | 동일 |
| "세션 마무리" | 동일 |

HANDOFF.md 위치:
- `_workspace/huni-widget/HANDOFF.md`
- `_workspace/huni-dbmap/HANDOFF.md`
- `_workspace/huni-admin-manual/` (QA 게이트 파일)
- print-quote·print-kb-wiki: HANDOFF 없음 (CHANGELOG + CLAUDE.md로 대체)

---

## 에이전트·스킬 파일 위치

| 유형 | 경로 패턴 |
|------|---------|
| 도메인 에이전트 정의 | `.claude/agents/<harness>/<agent-name>.md` |
| 오케스트레이터 스킬 | `.claude/skills/<harness>-orchestrator/SKILL.md` |
| 메서드 스킬 | `.claude/skills/<skill-name>/SKILL.md` |
| MoAI 에이전트 | `.claude/agents/moai/<agent-name>.md` |
| MoAI 스킬 | `.claude/skills/moai-*/SKILL.md` |
| gated 규칙 | `.claude/rules/moai/**/*.md` |

하네스별 에이전트 디렉토리:
- `.claude/agents/print-quote/` — pq-pm, pq-researcher, pq-business-analyst, pq-architect, pq-designer
- `.claude/agents/huni-widget/` — hw-reverse-engineer, hw-runtime-analyst, hw-researcher, hw-architect, hw-builder, hw-design-fidelity, hw-qa
- `.claude/agents/huni-dbmap/` — dbm-schema-analyst, dbm-excel-analyst, dbm-mapping-designer, dbm-validator, dbm-load-builder, dbm-domain-researcher, dbm-loadspec-extractor, dbm-ddl-proposer, dbm-option-mapper, dbm-coverage-auditor, dbm-change-tracker, dbm-correctness-auditor
- `.claude/agents/huni-admin-manual/` — ham-source-analyst, ham-db-verifier, ham-live-capturer, ham-manual-writer, ham-manual-qa, ham-docs-publisher
- `.claude/agents/print-kb/` — pkw-source-curator, pkw-researcher, pkw-recipe-writer, pkw-wiki-qa
