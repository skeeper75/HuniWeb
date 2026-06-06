# HuniWeb Project Directive

This is a **harness-driven workspace**. Day-to-day work runs through three domain
harnesses (Print-Quote / Huni-Widget / Huni-DBMap) via their orchestrator skills.
The full MoAI-ADK framework is installed but rarely used here — its detailed rules
are gated (load on demand) and the full original directive is archived at
`.moai/_archive/CLAUDE-full-moai-2026-06-05.md`.

@.moai/config/sections/user.yaml
@.moai/config/sections/language.yaml

---

## 1. Core Rules (always apply)

- [HARD] Respond to the user in `conversation_language` (ko). Code, identifiers,
  table/column names, SQL, and skill names stay in English. Code comments per
  `code_comments` (ko).
- [HARD] All user-facing questions go through `AskUserQuestion` — no free-form prose
  questions. First option marked "(권장)", each option has a description. Max 4
  questions / 4 options, no emoji.
- [HARD] Execute independent tool calls in parallel (single message, multiple calls).
- [HARD] No XML tags in user-facing output (except Markdown). Use Markdown only.
- [HARD] Secrets live ONLY in `.env.local` (chmod 600, gitignored). Never write
  credentials into `_workspace/` (git-tracked) or echo them to stdout.
- [HARD] Prefer dedicated tools: Read over cat, Edit over sed, Grep over grep, Glob over find.
- No time estimates ("2-3 days"). Use priority labels (High/Medium/Low) or phase ordering.

## 2. Agent Core Behaviors (always apply)

These six cross-cutting behaviors apply regardless of task. (Detailed version lives in
the gated `.claude/rules/moai/core/moai-constitution.md`.)

1. **Surface assumptions** — list non-trivial assumptions before implementing; don't silently pick one reading of an ambiguous request.
2. **Manage confusion actively** — on conflicting requirements, STOP, name the conflict, ask; don't guess.
3. **Push back when warranted** — name concrete downsides directly, propose an alternative, accept an informed override. Sycophancy is a failure mode.
4. **Enforce simplicity** — resist over-engineering; the smallest change that works wins. No factories for a single implementation, no unrequested abstractions.
5. **Maintain scope discipline** — touch only what was asked. No drive-by refactors, no deleting "unused" code without approval.
6. **Verify, don't assume** — show evidence (test output, build result, Read-back). "Seems right" is never sufficient.

## 3. Safe Development Protocol (always apply)

- **Approach-first**: explain the approach and which files change before non-trivial code; get approval. Exceptions: typos, single-line, obvious fixes.
- **Multi-file decomposition**: when touching 3+ files, split into logical units and report progress per unit.
- **Reproduction-first bug fix**: write a failing test that reproduces the bug, confirm it fails, fix minimally, confirm it passes.
- **Post-implementation review**: after coding, list edge cases / risks and suggest tests.
- **Context-first discovery**: when intent is ambiguous (vague pronouns, multi-interpretable verbs, unclear boundaries, state conflicts), run a Socratic interview via AskUserQuestion until intent is 100% clear, then confirm before executing.

---

## 4. Session Handoff — "다음세션을 위해 정리"

When the user says **"다음세션을 위해 정리"**, **"핸드오프 정리"**, **"세션 마무리"**,
or an equivalent, perform this routine (do NOT wait for further instruction):

1. **Identify the active harness** from the session's work (Print-Quote / Huni-Widget /
   Huni-DBMap), or treat it as general if none.
2. **Write/update the harness HANDOFF doc** at `_workspace/<harness>/HANDOFF.md` with:
   - **다음 시작점** — the exact next action a fresh session should take.
   - **미해결/블로커** — open issues, pending decisions, failed checks.
   - **이번 세션 결정** — decisions made and why (so they aren't relitigated).
   - **건드리지 말 것** — confirmed-good outputs that must be preserved.
3. **Update this CLAUDE.md** — refresh the relevant harness's "변경 이력 (최근 3건)"
   table (keep only the latest 3 rows; older rows live in that harness's CHANGELOG.md).
   Do NOT let CLAUDE.md grow back — if a section bloats, move detail into the harness
   workspace and leave a pointer.
4. **Update auto-memory** — add/update memory files for non-obvious facts only
   (per the memory rules), and refresh `MEMORY.md` index lines.
5. **Commit** — stage the docs + CLAUDE.md changes, commit (git_commit_messages: ko),
   and verify `.env.local` is IGNORED before committing. Push only if the user asks.

Keep the handoff tight: it is a restart pointer, not a full report. The goal is that a
fresh session reads HANDOFF.md + the harness CHANGELOG and resumes with zero re-discovery.

---

## 5. Harness: Print-Quote (후니프린팅 자동견적 사이트 설계)

**목표:** buysangsang.com/wowpress/RedPrinting 경쟁사 분석 + huni 실데이터 분석을 통합하여 자동인쇄 견적사이트의 기획·설계 문서 일체(IA·DB·API·가격엔진·화면설계·통합 설계서)를 5인 에이전트 팀(pq-researcher / pq-business-analyst / pq-architect / pq-designer / pq-pm)으로 산출.

**트리거:** "후니프린팅 자동견적 사이트 설계", "print quote design", "경쟁사 분석", "견적 마법사 설계", "설계서 작성", "다시 분석", "설계 업데이트", "특정 영역 재설계" 등 본 도메인 요청 시 `print-quote-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/print-quote/` (00_pm·01_research·02_business·03_architecture·04_design·99_integrated, `_baseline/`은 이전 dbtest DB 스키마 7종)

**변경 이력 (최근 3건, 전체는 `_workspace/print-quote/CHANGELOG.md`):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-05-27 | 라이브크롤 스킬 WP+Woo+Elementor 특화 + 저트래픽·읽기전용 안전 모드 | print-quote-live-crawl, pq-researcher | buysangsang 분석 시 상대 서비스 영향·트래픽 비용 0 보장 |
| 2026-05-27 | 분석 프레임 재정의: "경쟁사 분석" → "As-Is 빌더 패턴 역공학(7축)" | pq-researcher, pq-architect | 사용자 컨텍스트 확정 — 자체 빌더 구축 + Big-Bang 컷오버 |
| 2026-05-27 | To-Be 아키텍처 결정: edicus.man(Next.js 15+Edicus SDK+Huni DS v6.0) 베이스라인 채택, 견적·카탈로그·가격엔진 등 자체 신규 구축 | 전체 (pq-architect 影 大) | 사용자 결정 + edicus.man 코드 분석 완료 |

---

## 6. Harness: Huni-Widget (인쇄 자동견적 위젯 구현)

**목표:** RedPrinting 위젯 역공학 보강(`raw/widget_monitor/local` 동작 검증된 라이브 테스트베드 활용) → 동작 구조 분석 + 국내외 베스트프랙티스 리서치 → 위젯 개발 요소 상세 명세 → **React-in-Shadow-DOM 임베드 위젯** 구현 → 경계면 교차 QA 까지 6인 에이전트 파이프라인(hw-reverse-engineer / hw-runtime-analyst / hw-researcher / hw-architect / hw-builder / hw-qa)으로 수행. Print-Quote(설계 문서)와 별개의 신규 독립 하네스(구현 목적).

**트리거:** "후니 위젯 구현", "인쇄 자동견적 위젯", "위젯 하네스 실행", "huni-widget", "역공학 보강", "위젯 동작 분석", "위젯 명세 작성", "위젯 빌드", "위젯 QA", "위젯 다시 구현", "특정 단계만 재실행" 등 본 도메인 요청 시 `huni-widget-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-widget/` (01_reverse·02_analysis·02_research·03_spec·04_build·05_qa)

**입력 자산(read-only):** `docs/reversing/red_reverse_engineer/`(역공학 86/100), `docs/reversing/*.html`(Widget/SDK 심층 분석 리포트 2종 — 가격 API 실측 계약·45 에디터 메서드·브릿지 17함수·3계층 아키텍처), `raw/widget_monitor/local/`(라이브 테스트베드, `node server.js`→localhost:3001), `_workspace/print-quote/04_design/DESIGN.md`(14 componentType), `.env.local`(RP_*/Edicus/Shopby/Neon).

**핵심 결정:** ① 역공학 보강→구현 end-to-end ② React-in-Shadow-DOM(내부 React+shadcn/Tailwind, 격리 Shadow DOM) ③ 미검증 영역(S3 presigned·가격 rule·postMessage 라이프사이클) 라이브 보강 ④ 신규 독립 하네스 ⑤ **후니 DB 미정 → 위젯은 DB가 아닌 정규화 계약에 의존. Red 역공학 데이터로 구현·검증 후 후니 어댑터 교체로 무손실 컨버전(위젯 코드 불변). 사이에 어댑터 레이어 필수**. RedPrinting은 사용자 본인 설계 시스템.

**변경 이력 (최근 3건, 전체는 `_workspace/huni-widget/CHANGELOG.md`):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-04 | 2차 팀 교차검증(3렌즈) + 보정 Wave1 — G-1 "RESOLVED" ATTB 권위 날조 적발(인용 deob 부존재), PDT_WRK echo 제거·침묵 PRICE=0 가드. 신규 G-5/A-2/B-1 발굴. vitest 148→149 | 04_build src/adapters·test, 07_parity, 커밋 3844eb6 | 팀 교차검증 + 보정 웨이브 |
| 2026-06-04 | 라이브 qty-sweep 캡처 — D-1 RESOLVED(WRK/DIR_MTR ATTB=건수 echo 정당 입증)·G-5 CONFIRMED(apparel 삼항 드롭 실결함)·G-6 신규(굿즈 수량 필드축 스왑). 가격권위=result_sum.PRICE | 05_qa/captures, 07_parity §5, 04_build | 캡처 세션 진행 |
| 2026-06-04 | 보정 W2-a — SUB_MTR 이중의미 평면화(A-2) 해소. isMaterialMultiSubMtr discriminator로 material-multi↔단일 add-on 분기. 어댑터 전용(INV-3 0줄). vitest 149→150 | 04_build src/adapters/red·test, 커밋 2bcb480 | W2-a 보정 + hw-qa 독립 재검증 |

---

## 7. Harness: Huni-DBMap (Railway DB 데이터 매핑)

**목표:** Railway `railway` DB(PostgreSQL 18.4, t_* 34테이블) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 라이브 `t_*` 스키마에 매핑(매핑 설계서 + 적재용 CSV)한다. **DB 직접 적재는 보류**(사용자 결정) — round-4(적재 준비)는 검증된 적재본 + 트랜잭션 롤백 DRY-RUN까지만 산출하고 **실제 INSERT는 인간 승인**(완료 기준 G1~G9·권위 `docs/goal-2026-06-06-01.md`). 5인 에이전트 팀(`dbm-schema-analyst` / `dbm-excel-analyst` / `dbm-mapping-designer` / `dbm-validator` / `dbm-load-builder`)으로 구조분석·엑셀분석 병렬 → 매핑 설계 → 경계면 교차검증 → 적재본 조립·G1~G9 게이트.

**트리거:** "DB 매핑", "DB 구조 파악", "테이블 시트화", "엑셀 데이터 매핑", "구간할인 매핑", "수량구간 할인", "가격표 매핑", "상품마스터 매핑", "Railway DB", "적재 CSV", "매핑 검증", "정합 재검증", "DB매핑 하네스 실행/재실행/업데이트", "특정 테이블만 매핑", "적재 준비", "round-4", "적재본 빌드/조립", "FK 위상정렬", "코드행 선적재", "적재 매니페스트", "DRY-RUN", "적재 가능성 검증", "G1 G9 게이트", "t_* 화이트리스트" 등 본 도메인 요청 시 `huni-dbmap-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-dbmap/` (00_schema·01_excel·02_mapping·03_validation·04_audit·05_method·06_extract·09_load·10_configurator·_meta). round-4 적재본=`09_load/`(매니페스트·순서적재 CSV·코드행 선적재·차단/GAP). 하네스 권위 goal=`docs/goal-2026-06-06-01.md`.

**접속/보안:** Railway 자격증명은 `.env.local`의 `RAILWAY_DB_*`에만 저장(chmod 600·gitignore). `_workspace`(git 추적)에 비밀값 금지. DB 파괴적 쓰기 없음 — 읽기전용 조회 + 롤백전용 dry-run만 허용. 데이터는 `db railway`에(postgres 아님), 비표준 포트, JOIN KEY=`prd_nm` only.

**진행 상태:** round-1(구간할인, GO·미적재) DONE · round-2(가격 t_prc_*) **15시트 평면화 DONE**(베스트프랙티스 ETL·component_prices 4805행·검증 GO·후니 siz등록 대기) · round-3(매핑 audit→처리적재 설계) **DONE·DB 미적재**(master 신설·적재 별도 승인) · **CPQ 트랙: 라이브 구현 확인 DONE**(옵션/템플릿/제약 7테이블·트리거 7종·excl_groups 흡수 — 재문서화 `00_schema/cpq-schema.md`·하네스 강화) · **round-4(적재 준비) DONE**(양 트랙 GO: 상품마스터 384행+가격 2,320행, G1~G9 PASS·라이브 DRY-RUN 보류) · **round-5(적재 실행본) DONE**(양 트랙 GO: 상품마스터 384행+코드11+update289·가격 2,320행. **S-gate[도메인 의미]+G1~G9+R1~R6 전건 PASS**·라이브 롤백전용 DRY-RUN 2-pass 멱등·제약위반0·COMMIT0 실증. reg_dt NOT NULL 결함 라이브 적발→수정 RESOLVED. DDL 제안 2건[비치수 size·박 2단룩업]. 실제 COMMIT·DDL적용·코드행등록은 인간 승인 대기) · **GO분 실제 적재 DONE(2026-06-06)**(사용자 "GO분 안전 적재" 승인→백업(read-only)→실제 COMMIT: **인쇄가격 3,504행**[t_prc_component_prices 3,292 등, 라이브 t_prc_* 이제 비어있지 않음]+**상품마스터 398행**[materials 716·processes 260·bundle 26]+update-set, 검증 전건 통과·FK고아0·멱등. 코드행 placeholder(PROC_000084·SIZ_000501~510) 의도적 제외. 백업·undo 안전망 보유. **DB 미적재 원칙→"GO분 적재됨, 차단/결정분만 미적재"로 갱신**. 가격 siz 권위정정[round-2 28상품 면적-좌표 오모델링→면적매트릭스13/고정가15, GUK4/3JEOL/GP35 1,184행 판형교정] 반영분 포함).

**변경 이력 (최근 3건, 전체는 `_workspace/huni-dbmap/CHANGELOG.md`):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-06 | round-5 **실행 완료 — 양 트랙 GO** — round-4 GO 적재본을 멱등 `INSERT…ON CONFLICT` SQL + 단일 트랜잭션 `apply.sql`(BEGIN…COMMIT·ON_ERROR_STOP) + 로더 `apply.sh`(기본 ROLLBACK·`commit`=인간플래그) + 재현 생성기 `gen_load_sql.py`로 실행본화(`_exec/` 상품마스터 384+코드11+update289·`_exec_price/` 가격 2,320). **3중 게이트 전건 PASS**: ①**S-gate(도메인 의미 정합)** — 라이브 직접 대조로 적재 데이터가 인쇄 도메인에 올바름 입증(표지/내지 usage·프리미엄 고급지/스탠다드 보급지·제본 필수공정·UV 아크릴·단가 음수0). 표면 의심 3건 전부 정합 확정(와이드리플렛=엑셀 명시5종·0원=직각모서리/1구타공 기본옵션 무료·40원=대량접지 저가) ②G1~G9 carry-forward ③R1~R6. **라이브 롤백전용 DRY-RUN**(사용자 승인): 2-pass 멱등(2회차 델타0)·제약위반0·FK고아0·COMMIT0·영구변경0 실증. **결함 적발·수정**: 라이브 DRY-RUN이 `reg_dt` NOT NULL 위반 87행(round-4 로컬 columns.csv 검사가 놓친 "공란→NULL on NOT NULL DEFAULT" 케이스) 적발→builder 수정(공란 `NULL`→`DEFAULT` 키워드·실값 보존)→RESOLVED(R6 독립성 가치 입증). DDL 제안 2건(`11_ddl_proposals/`: goods-pouch 비치수 size·박 2단룩업, search-before-mint·정규화·영향분석·propose≠apply) + NOT-DDL 4(addon template·레이저커팅·sticker원형·가격§A siz=코드행/데이터)·DEFER 2(sticker 형상enum·책등param). **실제 COMMIT·DDL적용·코드행등록(PROC_000084·SIZ_000501~510·PRC_COMPONENT_TYPE.06 등)은 인간 승인 대기**. DB 미적재·DDL 무적용 유지 | _workspace/huni-dbmap/09_load/{_exec,_exec_price} · 11_ddl_proposals/ · 03_validation/{domain-semantic-gate,load-execution-gate}.md · CLAUDE.md | 사용자(`/goal` round-5 실행) — 도메인 의미 검증(라이브 직접 대조) 추가 요청 반영 |
| 2026-06-06 | round-5(적재 실행본) 트랙 신설 — round-4 GO 적재본(상품마스터 384행+가격 2,320행)을 **실제 적재 가능한 실행 산출물**로 완성하는 트랙. goal 정본화(`docs/goal-2026-06-06-02.md`: round-4 G1~G9 **상속**+**R1~R6 추가**[멱등성·트랜잭션원자성·실행가능성·DDL제안정합·라이브DRY-RUN·생성검증독립]). **사용자 4분기 확정(HARD)**: ①DDL 제안 **격상**(GAP을 신규엔티티 CREATE/ALTER 제안서로 능동해결, 직접적용은 인간승인) ②실행SQL/로더+롤백전용 라이브DRY-RUN까지(COMMIT 별도승인) ③멱등 UPSERT(`INSERT…ON CONFLICT`, 충돌키=라이브 PK/UNIQUE) ④round-5 신규트랙+에이전트 보강. **신규 에이전트 `dbm-ddl-proposer`**(GAP/BLOCKED[박2단룩업·gp비치수size·sticker형상enum·책등param·addon template]를 라이브 t_* 컨벤션 정합 최소 신규엔티티 DDL 제안서로 닫음, search-before-mint·사다리[코드행<컬럼<JSONB<테이블]·정규화·영향분석, `11_ddl_proposals/`). **신규 스킬 `dbm-load-execution`**(3역할 공유: §1 멱등SQL빌드+§2 DDL제안+§3 R1~R6게이트, references 3종). **`dbm-load-builder` 보강**(GO적재본→멱등 INSERT…ON CONFLICT+단일트랜잭션 apply.sql+FK순+적재로더[기본 롤백·--commit=인간승인], `09_load/_exec*/`). **`dbm-validator` 보강**(R1~R6+라이브 롤백 DRY-RUN 2회 멱등성·제약위반0 실증, G1~G9 carry-forward, NEVER COMMIT). 오케스트레이터 round-5 파이프라인(Phase0 GO입력→2 빌드+DDL제안 병렬→3 R1~R6+DRY-RUN→4 승인게이트)·트리거·user-decision·테스트6종. DB 미적재·DDL 무적용 유지 | docs/goal-2026-06-06-02.md(신규), .claude/agents/huni-dbmap/{dbm-ddl-proposer(신규),dbm-load-builder,dbm-validator}, .claude/skills/{dbm-load-execution(신규)+references 3종,huni-dbmap-orchestrator}, CLAUDE.md·CHANGELOG.md | 사용자(`/harness:harness`) — round-4 검증 적재본을 실제 적재 스크립트/SQL+라이브 정규화+신규 엔티티 제안으로 완성(베스트프랙티스 기반) |
| 2026-06-06 | round-4(적재 준비) 트랙 신설 — goal 정본화(`docs/goal-2026-06-06-01.md`: 완료기준 G1~G9·t_* 화이트리스트·무적재 원칙·권위 우선순위·DRY-RUN, 베스트프랙티스 Anthropic 롱러닝하네스+Codex AGENTS.md 반영) + 하네스 확장(5인). **신규 에이전트 `dbm-load-builder`**(검증된 매핑→FK 위상정렬 적재본·코드행 선적재 제안·적재 매니페스트·차단/GAP 분리, t_* 화이트리스트 강제, `09_load/` 산출). **신규 스킬 `dbm-load-readiness`**(공유: §1 빌드 + §2 G1~G9 게이트, references g-gates/fk-load-order/dry-run). **`dbm-validator` 보강**(round-4 G1~G9 게이트 종합판정 GO/NO-GO·DRY-RUN, 생성/검증 분리=G9). 오케스트레이터에 round-4 파이프라인(Phase0 GO입력→2 조립→3 게이트+DRY-RUN→4 승인게이트)·트리거·테스트시나리오 인코딩. 적재 범위=검증된 적재본+DRY-RUN까지, 실제 INSERT는 인간 승인. DB 미적재·DDL 무변경 유지 | docs/goal-2026-06-06-01.md(신규), .claude/agents/huni-dbmap/{dbm-load-builder(신규),dbm-validator}, .claude/skills/{dbm-load-readiness(신규),huni-dbmap-orchestrator}, CLAUDE.md | 사용자 — 전체 산출 문서 기반 상품마스터·가격표 → 라이브 t_* 매핑 하네스 구축(goal 선작성 후 구축) |---

## 8. MoAI Framework (gated — rarely used here)

The MoAI-ADK orchestration framework (SPEC plan/run/sync, TRUST 5, DDD/TDD, Agent Teams,
design GAN loop) is installed but not the primary workflow in this repo. Its detailed
rules are gated by `globs:` frontmatter and load only when you work in the matching paths:

- `.claude/rules/moai/core/moai-constitution.md` — loads on `.moai/specs/**`, `.claude/skills/moai/**`
- `.claude/rules/moai/core/agent-common-protocol.md` — loads on `.claude/agents/**`
- `.claude/rules/moai/design/constitution.md` — loads on `.moai/design/**`, brand paths
- `.claude/rules/moai/workflow/*` — load on agents / specs / moai skill paths
- `.claude/rules/moai/languages/*` — load per source-file language (already gated)

To use MoAI workflows explicitly, invoke the `moai` skill (`/moai plan|run|sync|...`).
The full original directive (all 17 sections, verbatim) is archived at
`.moai/_archive/CLAUDE-full-moai-2026-06-05.md` — restore from there or `git revert` if needed.

When editing this file: it must stay lean. Keep only always-apply rules, the handoff
routine, and the three harness sections. Move any growing detail into the relevant
harness workspace and leave a pointer here.
