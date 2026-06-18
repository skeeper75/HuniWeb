# 드리프트 보드 — 고아·미배선·명명불일치

감사일: 2026-06-18 · 모든 항목 파일 근거 첨부 · 읽기 전용(정리 후보 도출만)

## A. 고아 / 미로드 스킬 (가장 큰 드리프트)

방법론 스킬이 디스크에 존재하나 **오케스트레이터·해당 하네스 에이전트 어디서도 이름으로 참조되지 않음** = 로드되지 않는 죽은 스킬. 검증 방법: 각 스킬명을 (a) 자기 오케스트레이터 SKILL.md (b) 자기 하네스 전체 에이전트 본문에서 `grep -c` → 둘 다 0.

### A-1. Huni-Basecode (hbg) — 방법론 스킬 5종 전부 고아

| 스킬 | orch 참조 | agent 참조 | 근거 |
|------|----------|-----------|------|
| `hbg-authority-curation` | 0 | 0 | `.claude/skills/hbg-authority-curation/` 실재, `huni-basecode-orchestrator/SKILL.md`·`agents/huni-basecode/*.md` 전수 grep 0 |
| `hbg-basecode-diagnosis` | 0 | 0 | 동일 |
| `hbg-registration-spec` | 0 | 0 | 동일 |
| `hbg-governance-evaluation` | 0 | 0 | 동일 |
| `hbg-remediation-planning` | 0 | 0 | 동일 |

→ hbg 에이전트들은 자기 방법론 스킬 대신 `dbm-axis-staged-load`·`dbm-ddl-proposer`·`dbm-load-execution`·`dbm-price-arbiter`·`dbm-validator`(재사용 스킬)만 본문에서 호출. 5개 방법론 스킬은 생성됐으나 배선되지 않음.

### A-2. Huni-Price-Quote (hpq) — 방법론 스킬 5종 전부 고아

| 스킬 | orch 참조 | agent 참조 |
|------|----------|-----------|
| `hpq-authority-curation` | 0 | 0 |
| `hpq-engine-cartography` | 0 | 0 |
| `hpq-option-constraint-mapping` | 0 | 0 |
| `hpq-price-chain-inspection` | 0 | 0 |
| `hpq-quote-gate-validation` | 0 | 0 |

근거: `huni-price-quote-orchestrator/SKILL.md` + `agents/huni-price-quote/*.md` 전수 grep 0. hpq 에이전트는 `dbm-excel-parse`·`dbm-price-import-prep`·`dbm-schema-extract`만 참조.

### A-3. 부분 고아 (정상 배선 하네스 내 1종씩)

| 스킬 | 하네스 | orch | agent | 비고 |
|------|--------|------|-------|------|
| `hped-binding-validity-mapping` | hped | 0 | 0 | hped의 다른 2 스킬(mechanism-research·code-schema-audit)은 정상 배선(orch 3·agent 2~4). 이것만 고아. U-7 트랙(나중 추가)인데 미배선 |
| `hqv-quote-verification` | hqv | 0 | 0 | hqv의 다른 2 스킬(product-decompose·codex-cross-verify)은 배선됨. 핵심 검증 스킬인데 고아 |
| `pkw-wiki-evaluation` | pkw | 0 | **1** | orch엔 없으나 `pkw-wiki-qa.md` 본문이 참조 → 실질 로드됨(경미·orch 보강 권장) |

> 참고: rpm 방법론 스킬(live-reverse·metamodel-design·gap-vessel·validation·deep-augment)은 orch=0이나 agent 본문 참조 1~2 → 정상(에이전트 로드 패턴). hped-mechanism-research·hped-code-schema-audit·hqv-product-decompose·hqv-codex-cross-verify·pkw-recipe-authoring도 정상 배선.

## B. 미배선 에이전트 (round-24 최신 작업)

| 에이전트 | orch 참조 | CLAUDE.md | 근거 |
|----------|----------|-----------|------|
| `dbm-category-auditor` | **0** | §7 narrative만 | `huni-dbmap-orchestrator/SKILL.md` grep `dbm-category` = 0. CLAUDE.md §7엔 round-24 기록 존재 |
| `dbm-category-mapper` | **0** | §7 narrative만 | 동일 |

→ round-24(카테고리 맵·가장 최근 라이브 COMMIT 작업)의 신규 에이전트 2종 + 스킬 2종(`dbm-category-audit`·`dbm-category-mapping`)이 dbm 오케스트레이터 round 테이블에 등재되지 않음. 스킬은 frontmatter 설명(트리거)으로 자동 발동 가능하나, 오케스트레이터가 라우팅 표에서 인지하지 못함.

## C. 명명 불일치

- 에이전트 frontmatter `name` ↔ 파일명: **불일치 0건** (전 68 후니 에이전트 일치).
- 스킬 frontmatter `name` ↔ 디렉토리명: **불일치 0건**.
- 오케스트레이터 호출명 ↔ 실제 에이전트명: 아래 D의 유령 토큰 외 일치.

## D. dbm 오케스트레이터 유령 참조 (옛 명명 잔류)

`huni-dbmap-orchestrator/SKILL.md` 본문에 디스크에 없는 토큰이 남아 있음(과거 명명/타 하네스 누수):

| 잔류 토큰 | 디스크 실재 | 판정 |
|-----------|------------|------|
| `pq-schema` | 없음 | 유령(과거 dbm 명명 추정) |
| `pq-option-gaps`·`pq-option-load`·`pq-option-validation`·`pq-option` (`PQ-option`) | 없음 | 유령 |
| `pq-design`·`pq-design-team`·`pq-discovery-team` | 없음(print-quote 오케스트레이터의 토큰이 print-quote엔 팀명으로 존재하나 dbm엔 무관) | dbm 문맥에선 유령 |

근거: `grep -oiE '(pq)-[a-z-]+' .claude/skills/huni-dbmap-orchestrator/SKILL.md` 결과에 위 토큰 출현, `find .claude/agents` 대조 시 부재. (참고: print-quote-orchestrator의 `pq-design-team`·`pq-discovery-team`도 디스크 에이전트 부재 — 오케스트레이터 내부 "팀" 논리명일 수 있으니 print-quote 문맥은 별도 확인 권장.)

## E. 드리프트 집계

- 완전 고아 방법론 스킬: **12종** (hbg 5 + hpq 5 + hped 1 + hqv 1)
- 경미(agent엔 있으나 orch 누락): 1종 (pkw-wiki-evaluation)
- 미배선 신규 에이전트: **2종** (dbm-category-auditor·mapper) + 짝 스킬 2종 orch 미등재
- 명명 불일치: 0건
- 오케스트레이터 유령 토큰: dbm 5+종
