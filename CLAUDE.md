# HuniWeb Project Directive

This is a **harness-driven workspace**. Domain work routes through orchestrator skills
(레지스트리 표 참조). 하네스별 상세 directive는 **경로 게이트 규칙**
`.claude/rules/harness/<slug>.md`(해당 `_workspace/<하네스>/**` 파일 작업 시에만 자동 로딩)에 있고,
전문 아카이브 = `.moai/_archive/CLAUDE-full-harness-2026-07-04.md`.
MoAI-ADK는 설치돼 있으나 거의 미사용 — 아카이브 `.moai/_archive/CLAUDE-full-moai-2026-06-05.md`,
명시 사용은 `moai` 스킬.

@.moai/config/sections/user.yaml
@.moai/config/sections/language.yaml

---

## 1. Core Rules (always apply)

- [HARD] **상품 유형 분류 정본(SOT)** = `_workspace/_foundation/product-type-classification-sot.md`.
  완제품(.01)=일반 단일+셋트 완제품 · 반제품(.02)=셋트 구성원(부품) · 기성상품(.03)=제조 없음 ·
  디자인상품(.04)=폐기→재분류 · 추가상품(.05)=addon. relitigate 금지, 라이브를 이에 맞춰 교정(역방향 금지).
  셋트 완제품/일반 단일 구분 = `t_prd_product_sets` 부모 등록 여부.
- [HARD] Respond to the user in `conversation_language` (ko). Code, identifiers,
  table/column names, SQL, and skill names stay in English. Code comments ko.
- [HARD] All user-facing questions go through `AskUserQuestion` — no free-form prose
  questions. First option "(권장)", each option has a description. Max 4/4, no emoji.
- [HARD] Execute independent tool calls in parallel (single message, multiple calls).
- [HARD] No XML tags in user-facing output (except Markdown). Use Markdown only.
- [HARD] Secrets live ONLY in `.env.local` (chmod 600, gitignored). Never write
  credentials into `_workspace/` (git-tracked) or echo them to stdout.
- [HARD] Prefer dedicated tools: Read over cat, Edit over sed, Grep over grep, Glob over find.
- [HARD] **라이브 DB 적재 전 webadmin 실화면 확인 필수** — DB DRY-RUN만으로 COMMIT 금지.
  webadmin(product-viewer/가격시뮬레이터)에서 "제외 0·PRICE≠0"·판형 자동선택을 실화면으로
  확인된 경우에만(gstack + `HUNI_ADMIN_*` 읽기 탐색). 전 적재 트랙 공통.
- [HARD] **가격·판형·적재·위젯 도메인 규칙 정본(SOT)** = `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`
  (12규칙). 가격/위젯 하네스는 이 정본 참조. relitigate 금지.
- [HARD] **전 하네스 공통 프로토콜**: ① 라이브 Railway DB=`.env.local` `RAILWAY_DB_*`
  읽기전용 SELECT만(db=railway·JOIN KEY=`prd_nm`) ② 실 COMMIT/DDL/적재=인간 승인 후에만
  ③ 라이브 화면=`HUNI_ADMIN_*`/사이트 자격증명으로 gstack 읽기 탐색만(저장·삭제·주문·결제 금지)
  ④ 생성≠검증 분리(자기 산출 자기 승인 금지) ⑤ codex 주장=가설(라이브/권위 검증 전 사실 아님·환각 경계·
  미가용 시 "Claude 단독" 명시 폴백) ⑥ search-before-mint(기존 코드·siz·공식 재사용 우선·중복 mint 금지)
  ⑦ 권위=상품마스터+인쇄상품 가격표 엑셀(최신판 우선·역공학/경쟁사는 갭헌팅 보강, 덮어쓰기 금지).
- No time estimates. Use priority labels (High/Medium/Low) or phase ordering.

## 2. Agent Core Behaviors (always apply)

1. **Surface assumptions** — list non-trivial assumptions before implementing.
2. **Manage confusion actively** — on conflicting requirements, STOP, name the conflict, ask.
3. **Push back when warranted** — name downsides, propose alternative, accept informed override.
4. **Enforce simplicity** — smallest change that works wins; no unrequested abstractions.
5. **Maintain scope discipline** — touch only what was asked; no drive-by refactors.
6. **Verify, don't assume** — show evidence (test output, build result, Read-back).

## 3. Safe Development Protocol (always apply)

- **Approach-first**: explain approach + files to change before non-trivial code; get approval.
- **Multi-file decomposition**: 3+ files → split into logical units, report per unit.
- **Reproduction-first bug fix**: failing test → confirm fail → minimal fix → confirm pass.
- **Post-implementation review**: list edge cases/risks, suggest tests.
- **Context-first discovery**: ambiguous intent → Socratic interview via AskUserQuestion → confirm → execute.

---

## 4. Session Handoff — "다음세션을 위해 정리"

트리거: **"다음세션을 위해 정리" / "핸드오프 정리" / "세션 마무리"** 등 — 즉시 수행:

1. 활성 하네스 식별 → `_workspace/<harness>/HANDOFF.md` 갱신
   (다음 시작점 · 미해결/블로커 · 이번 세션 결정 · 건드리지 말 것).
2. 변경이력: 전체 서술은 하네스 `CHANGELOG.md`에 PREPEND(최신 위), 해당
   `.claude/rules/harness/<slug>.md`의 "변경이력:" 라인을 최신 1줄로 교체.
   **루트 CLAUDE.md는 건드리지 않는다**(새 하네스 추가로 레지스트리 행이 늘 때만 수정).
3. auto-memory 갱신(비자명한 사실만) + `MEMORY.md` 인덱스.
4. 커밋(git_commit_messages: ko) — `.env.local` IGNORED 검증 후. Push는 요청 시만.

핸드오프는 재시작 포인터다 — 새 세션이 HANDOFF.md + CHANGELOG만 읽고 재발견 0으로 재개.

---

## 5. 하네스 레지스트리

도메인 요청 → 해당 **오케스트레이터 스킬** 사용(단순 질문은 직접 응답). 상세 directive·핵심 규칙·
변경이력 = `.claude/rules/harness/<slug>.md`(해당 워크스페이스 파일 작업 시 자동 로딩) → 필요 시 직접 Read.
진행 상태 = `_workspace/<harness>/HANDOFF.md`·`CHANGELOG.md`.

| § | 하네스 (slug) | 오케스트레이터 스킬 | 도메인 요지 |
|---|---|---|---|
| 5 | print-quote | `print-quote-orchestrator` | 자동견적 사이트 설계 문서·경쟁사 분석 |
| 6 | huni-widget | `huni-widget-orchestrator` | 자동견적 위젯 구현(React-in-Shadow-DOM)·역공학 보강·컨버전 |
| 7 | huni-dbmap | `huni-dbmap-orchestrator` | Railway DB 매핑·적재 CSV/실행·DRY-RUN·G1~G9 |
| 8 | huni-admin-manual | `huni-admin-manual-orchestrator` | webadmin 운영자 매뉴얼·화면 캡처·MkDocs |
| 9 | print-kb | `print-kb-wiki-orchestrator` | LLM 레시피 위키(상품군·횡단 축) |
| 10 | huni-project-plan | `huni-project-plan-orchestrator` | 일정관리 통합 IA 엑셀 |
| 11 | huni-rpmeta | `huni-rpmeta-orchestrator` | RP 옵션 메타모델→기초데이터 그릇 설계 |
| 12 | huni-basecode | `huni-basecode-orchestrator` | 기초코드 등록 거버넌스·4-way 진단 |
| 13 | huni-price-quote | `huni-price-quote-orchestrator` | 가격 적재 검증·P1~P7 게이트 |
| 14 | huni-price-engine-diag | `huni-price-engine-diag-orchestrator` | 가격엔진 5장치 이해·진단·지식맵 |
| 15 | huni-quote-verify | `huni-quote-verify-orchestrator` | 단일 상품 가격검증(Claude+Codex 3축) |
| 16 | huni-recipe-viz | `huni-recipe-viz-orchestrator` | 구성요소 시각화·레시피(생성=codex/검증=Claude) |
| 17 | huni-basedata-dedup | `huni-basedata-dedup-orchestrator` | 기초데이터 표시중복 정리·적재 |
| 18 | huni-price-engine-design | `huni-price-engine-design-orchestrator` | 가격공식·구성요소 설계(t_prc 그릇·E1~E7) |
| 19 | huni-widget-flow | `huni-widget-flow-orchestrator` | 위젯 구조·플로우 문서화(mermaid+인포그래픽) |
| 20 | huni-edicus-codemap | `huni-edicus-codemap-orchestrator` | edicus.man 코드맵·Edicus SDK/API |
| 21 | huni-catalog-conformance | `huni-catalog-conformance-orchestrator` | 전 상품 12축 종단 정합(K1~K8) |
| 22 | huni-re-verify | `huni-re-verify-orchestrator` | 역공학 재검증·런타임 동등성(골든·차등) |
| 23 | huni-set-product | `huni-set-product-orchestrator` | 셋트상품 구성·설계·적재(t_prd_product_sets·S1~S8) |
| 24 | huni-shopby | `huni-shopby-orchestrator` | Shopby 카트→주문 통합 설계(SB1~SB7) |
| 25 | huni-recode | `huni-recode-orchestrator` | 역공학 코드 가독화(AST 동작 보존·G1~G6) |
| 26 | huni-price-table-integrity | `huni-price-table-integrity-orchestrator` | 가격테이블 적재 무결성(미적재 셀·차원 누락·I1~I7) |
| 27 | price-master | `huni-price-master-orchestrator` | 가격 종단 파이프라인 조율·formula_components 배선 |
| 28 | huni-launch-scope | `huni-launch-scope-orchestrator` | 1차 런칭 범위·Shopby 갭·마이그레이션(L1~L7) |
| 29 | huni-product-readiness | `huni-product-readiness-orchestrator` | 상품별 준비도 평가·위젯/제약 일정(Q1~Q7) |
| 31 | huni-constraint-rules | `huni-constraint-rules-orchestrator` | 제약규칙 거버넌스(CN-1~6·폼빌더 정형 shape·CR1~CR7) |
| 32 | excel-to-db | `excel-to-db-orchestrator` | 범용 엑셀→DB 파이프라인(x2d·X1~X7) |
| 33 | huni-ontology-kb | `huni-ontology-kb-orchestrator` | 온톨로지 KB·자연어→상품 추천→가격(O1~O7) |
| 34 | huni-load-governance | `huni-load-governance-orchestrator` | 적재 거버넌스·옵션 3용도 판정(LG1~LG7) |
| 35 | huni-multibrand-ontology | `huni-multibrand-ontology-orchestrator` | 다중 브랜드 온톨로지·와우/레드 분석·CIP4 표준 상위 온톨로지·교차 연관(MB1~MB7) |

---

## 6. 하네스 생성·유지보수 규약 [HARD]

설계 배경·비유·근거 전문(비전문가용) = `_workspace/_foundation/HARNESS-CONTEXT-ARCHITECTURE.md`.
`harness` 스킬(또는 수동)로 하네스를 만들·수정할 때:

1. **루트 CLAUDE.md에는 레지스트리 표 1행만 추가** — 목표·트리거·변경이력 블록 금지.
2. **하네스 directive는 `.claude/rules/harness/<slug>.md`에** — `paths: ["_workspace/<slug>/**"]`
   frontmatter로 경로 게이트(해당 파일 작업 시에만 로딩). 내용: 목표·스킬/트리거·산출물·핵심 규칙·
   변경이력 최신 1줄.
3. **변경이력 서술 누적은 `_workspace/<harness>/CHANGELOG.md`에만** (rules 파일은 최신 1줄 포인터).
4. **에이전트 description 예산**: 역할 1문장 + 트리거 키워드 ≤4개 + "상세는 본문." (~150자).
   상세 charter·[HARD] 규칙·전체 트리거는 에이전트 **본문**에(호출 시에만 로딩). 이유: 모든 에이전트
   description은 매 세션 시스템 프롬프트에 주입되며 전역 15k 토큰 한도가 있다.
5. **스킬 description**: 트리거 유도는 적극적으로 하되 2~3문장 이내. 방법론 상세는 SKILL.md 본문에.
6. 루트 CLAUDE.md는 **200줄 이하 유지**(공식 권고). 늘어나면 rules/워크스페이스로 밀어내라.

---

When editing this file: keep only always-apply rules, the handoff routine, the registry
table, and the governance rules. Harness detail goes to `.claude/rules/harness/` +
`_workspace/<harness>/` — never back here.
