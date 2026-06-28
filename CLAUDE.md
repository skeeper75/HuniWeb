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

- [HARD] **상품 유형 분류 정본(SOT)** = `_workspace/_foundation/product-type-classification-sot.md`.
  완제품(.01)=일반 단일+셋트 완제품 · 반제품(.02)=셋트 구성원(부품) · 기성상품(.03)=제조 없음 ·
  디자인상품(.04)=폐기→재분류 · 추가상품(.05)=addon. 이 분류는 relitigate 금지, 라이브를 이에
  맞춰 교정(역방향 금지). 셋트 완제품/일반 단일 구분 = `t_prd_product_sets` 부모 등록 여부.
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
3. **Update this CLAUDE.md** — refresh the relevant harness's "**변경이력:**" pointer
   line to "최신: <날짜> <한 줄 요약> → `_workspace/<harness>/CHANGELOG.md`", and PREPEND
   the full row to that harness's CHANGELOG.md (newest on top). Keep CLAUDE.md to the
   one-line pointer only — never re-add a multi-row table.
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

**변경이력:** 최신: 2026-05-27 To-Be 아키텍처 edicus.man 베이스라인 채택 → `_workspace/print-quote/CHANGELOG.md`

---

## 6. Harness: Huni-Widget (인쇄 자동견적 위젯 구현)

**목표:** RedPrinting 위젯 역공학 보강(`raw/widget_monitor/local` 동작 검증된 라이브 테스트베드 활용) → 동작 구조 분석 + 국내외 베스트프랙티스 리서치 → 위젯 개발 요소 상세 명세 → **React-in-Shadow-DOM 임베드 위젯** 구현 → 경계면 교차 QA 까지 6인 에이전트 파이프라인(hw-reverse-engineer / hw-runtime-analyst / hw-researcher / hw-architect / hw-builder / hw-qa)으로 수행. Print-Quote(설계 문서)와 별개의 신규 독립 하네스(구현 목적).

**트리거:** "후니 위젯 구현", "인쇄 자동견적 위젯", "위젯 하네스 실행", "huni-widget", "역공학 보강", "위젯 동작 분석", "위젯 명세 작성", "위젯 빌드", "위젯 QA", "위젯 다시 구현", "특정 단계만 재실행" 등 본 도메인 요청 시 `huni-widget-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-widget/` (01_reverse·02_analysis·02_research·03_spec·04_build·05_qa)

**입력 자산·핵심 결정:** 입력자산(역공학 86/100·Widget/SDK 리포트·widget_monitor 테스트베드·DESIGN.md 14 componentType·`.env.local`)과 핵심결정 5건(역공학→구현 end-to-end·React-in-Shadow-DOM·미검증 영역 라이브 보강·정규화 계약 의존+어댑터 무손실 컨버전·RedPrinting=사용자 본인 시스템) → `_workspace/huni-widget/HANDOFF.md`·`CHANGELOG.md`

**변경이력:** 최신: 2026-06-04 보정 W2-a SUB_MTR 이중의미 평면화(A-2) 해소·vitest 150 → `_workspace/huni-widget/CHANGELOG.md`

---

## 7. Harness: Huni-DBMap (Railway DB 데이터 매핑)

**목표:** Railway `railway` DB(PostgreSQL 18.4, t_* 34테이블) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 라이브 `t_*` 스키마에 매핑(매핑 설계서 + 적재용 CSV)한다. **DB 직접 적재는 보류**(사용자 결정) — round-4(적재 준비)는 검증된 적재본 + 트랜잭션 롤백 DRY-RUN까지만 산출하고 **실제 INSERT는 인간 승인**(완료 기준 G1~G9·권위 `docs/goal-2026-06-06-01.md`). 5인 에이전트 팀(`dbm-schema-analyst` / `dbm-excel-analyst` / `dbm-mapping-designer` / `dbm-validator` / `dbm-load-builder`)으로 구조분석·엑셀분석 병렬 → 매핑 설계 → 경계면 교차검증 → 적재본 조립·G1~G9 게이트.

**트리거:** "DB 매핑", "DB 구조 파악", "테이블 시트화", "엑셀 데이터 매핑", "구간할인 매핑", "수량구간 할인", "가격표 매핑", "상품마스터 매핑", "Railway DB", "적재 CSV", "매핑 검증", "정합 재검증", "DB매핑 하네스 실행/재실행/업데이트", "특정 테이블만 매핑", "적재 준비", "round-4", "적재본 빌드/조립", "FK 위상정렬", "코드행 선적재", "적재 매니페스트", "DRY-RUN", "적재 가능성 검증", "G1 G9 게이트", "t_* 화이트리스트" 등 본 도메인 요청 시 `huni-dbmap-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-dbmap/` (00_schema·01_excel·02_mapping·03_validation·04_audit·05_method·06_extract·09_load·10_configurator·_meta). round-4 적재본=`09_load/`(매니페스트·순서적재 CSV·코드행 선적재·차단/GAP). 하네스 권위 goal=`docs/goal-2026-06-06-01.md`.

**접속/보안:** Railway 자격증명은 `.env.local`의 `RAILWAY_DB_*`에만 저장(chmod 600·gitignore). `_workspace`(git 추적)에 비밀값 금지. DB 파괴적 쓰기 없음 — 읽기전용 조회 + 롤백전용 dry-run만 허용. 데이터는 `db railway`에(postgres 아님), 비표준 포트, JOIN KEY=`prd_nm` only.

**진행 상태:** round-24까지 진행(round-1~24 누적 서술 상세 → `_workspace/huni-dbmap/CHANGELOG.md` "## 진행 상태 스냅샷"). GO분 적재됨·차단/결정분만 미적재 원칙.

**변경이력:** 최신: 2026-06-18 round-24 MAP 카테고리 IA 검증+카테고리-상품 매핑 GO·격상 183건 junction COMMIT → `_workspace/huni-dbmap/CHANGELOG.md`

---

## 8. Harness: Huni-Admin-Manual (라이브 Django admin 운영자 사용 매뉴얼)

**목표:** 라이브 후니 Django admin(`huni-admin-production.up.railway.app/admin/`, `raw/webadmin` 소스·Railway DB)을 ① 소스 ② 라이브 DB ③ 실제 화면 3중 대조로 전수 분석하여, 비개발자 운영자가 상품·가격·옵션을 등록/수정하기 위한 **상세 사용 매뉴얼(전 화면 전수 + 실제 스크린샷 임베드 + step-by-step)** 을 5인 에이전트 팀(`ham-source-analyst` / `ham-db-verifier` / `ham-live-capturer` / `ham-manual-writer` / `ham-manual-qa`)으로 산출.

**트리거:** "admin 매뉴얼", "관리자 매뉴얼 작성", "webadmin 매뉴얼", "라이브 사이트 사용 설명서", "운영자 가이드", "admin 사용법 문서", "화면 캡처 매뉴얼", "매뉴얼 하네스 실행/재실행/업데이트/보완", "특정 화면만 매뉴얼", "캡처만 다시", "매뉴얼 검증" 등 본 도메인 요청 시 `huni-admin-manual-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**대상 구조(이중 레이어):** ① 표준 Django admin(Unfold 테마) — `catalog/admin.py`가 전 `t_*` 모델을 제너릭 ModelAdmin으로 자동 등록(모델별 목록 changelist/추가·수정 changeform, 자동채번·YN 드롭다운·트리 드롭다운·논리삭제). ② 커스텀 상품 뷰어 — `admin/`의 홈(상품 목록→상세→섹션편집), 옵션 드릴다운 3계층, SKU 템플릿 2계층, 제약 폼빌더+검증 미리보기, impact·sku-catalog standalone.

**산출물 루트:** `_workspace/huni-admin-manual/` (`01_source_*`·`02_db_*`·`03_capture_*`+`captures/`·`manual/`(11챕터)·`04_qa_*`·`site-src/`(MkDocs)).

**문서 발행:** 매뉴얼은 **Material for MkDocs**로 문서 사이트 발행(`ham-docs-publisher` + `huni-admin-docs-publish` 스킬). `site-src/`(mkdocs.yml·`build_docs.py` 정규화 빌드·requirements) + CI 워크플로 템플릿 `site-src/ci/docs.yml`(docs-as-code — 빌드·배포만 자동, 매뉴얼 재생성은 사람이 하네스로 트리거). **CI 활성화 시 `site-src/ci/docs.yml`을 레포 `.github/workflows/docs.yml`로 복사**(OAuth `workflow` scope 회피용 — git push가 `.github/workflows/`를 막으므로 템플릿으로 보관). 호스팅 연결(GitHub Pages)·webadmin(별도 레포 HuniProductPrice2) 배포 연동은 인간 승인. `site-src/{docs,site,.venv}`는 빌드 생성물로 gitignore.

**자격증명/안전:** 라이브 운영 DB — DB는 `.env.local` `RAILWAY_DB_*`로 읽기전용 SELECT만, 라이브 화면은 `.env.local` `HUNI_ADMIN_*`로 읽기 탐색만(저장/삭제 클릭 금지). 비밀값은 `_workspace`(git 추적)·stdout·스크린샷에 비노출.

**변경이력:** 최신: 2026-06-10 라이브 재대조 0 드리프트·QA Low 3건 해소 확인 → `_workspace/huni-admin-manual/CHANGELOG.md`

---

## 9. Harness: Print-KB Wiki (LLM 레시피 위키)

**목표:** 전 하네스 산출물(huni-dbmap·huni-widget·print-quote·huni-admin-manual·docs/huni·raw/webadmin)을 원천으로, `_workspace/print-kb/wiki/`(Karpathy 모델, 기존 스키마 계승)에 **상품군(11시트) 단위 레시피 페이지**(정체→차원→자재/공정 BOM→가격공식 사슬→CPQ 옵션→위젯 계약→webadmin 적재 경로→결함 현황)와 횡단 축 페이지 6종을 집필한다. 페이지 뼈대=라이브 DB 스키마(t_*·webadmin) 기준. 4인 에이전트(`pkw-source-curator` 원천 큐레이션·stale 등급 / `pkw-researcher` 방법론+검증 리서치 / `pkw-recipe-writer` 집필 / `pkw-wiki-qa` W1~W8 게이트). 목적: 미래 LLM 세션이 위키만 읽고 인쇄상품을 빠르게 조립(정의→DB 등록→가격→위젯).

**트리거:** "LLM 위키", "kapasy/karpathy 위키", "레시피 위키", "상품 레시피 페이지", "위키 구축/집필/확장/업데이트/보완", "print-kb", "특정 상품군만 위키", "위키 검증/lint", "큐레이션 다시" 등 본 도메인 요청 시 `print-kb-wiki-orchestrator` 스킬을 사용. 위키 내용 단순 조회는 `wiki/index.md`부터 직접.

**핵심 규칙:** STALE/v03 인용 금지(큐레이션 팩 freshness 권위=round-14 진단) · 라이브 오적재(round-13)는 "현재값 vs 정답" 양면 표기 · 생성자≠검증자 · 모든 블록 출처+badge 필수.

**변경이력:** 최신: 2026-06-12 하네스 초기 구성(4 에이전트+3 스킬·기존 위키 확장) → `_workspace/print-kb/CHANGELOG.md`

---

## 10. Harness: Huni-Project-Plan (프로젝트 일정관리 통합 IA 문서)

**목표:** 후니프린팅 리뉴얼(Classic ASP→신규)의 **프로젝트 일정관리 통합 IA 문서(엑셀)**를 산출·갱신. 후니에서 논의된 IA·정책이 권위이며, 위젯·에디쿠스(레드 역공학)·주문→생산(MES) 흐름·Shopby 표준 갭·라이브 DB 실측을 반영해 실무진용 일정관리 엑셀(역할·담당자·주차 병렬일정·고객 준비물·외부계약·개발자 상세)을 만든다. 실제 기능목록 권위(가상 창작 금지)·쉬운 말+용어집·주차 상대일정(날짜 날조 금지)·쇼핑개발(김동학 1명) 병목→AI 병행 가속.

**트리거:** "프로젝트 일정관리 문서", "일정관리 IA", "통합 IA 일정", "일정표 작성", "역할분담 문서", "페이즈 일정", "단계배치", "일정관리 다시/업데이트/보완", "위젯 기능목록 일정", "MES 흐름 일정", "고객 준비물 정리", "huni-project-plan" 등 본 도메인 요청 시 `huni-project-plan-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-project-plan/` (01_research·02_synthesis·03_build·04_qa). 최종=`docs/huni/후니프린팅_프로젝트일정관리_통합IA_*.xlsx`(11시트). 에이전트=`hpp-ia-curator`·`hpp-xlsx-builder`·`hpp-plan-qa`(+콘텐츠 수집은 `hw-reverse-engineer`/`dbm-schema-analyst`/`pq-researcher` 재사용).

**변경이력:** 최신: 2026-06-16 하네스 초기 구성+일정관리 엑셀 산출(162기능·11시트·QA GO) → `_workspace/huni-project-plan/CHANGELOG.md`

---

## 11. Harness: Huni-RP-Meta (RedPrinting 옵션 관리 메타모델 → 후니 기초데이터 관리 그릇 설계)

**목표:** RedPrinting 라이브(redprinting.co.kr, 479상품/26카테고리)의 주문옵션 구성을 **대표 샘플**로 역공학하여 "옵션 관리 메타모델"(자재/공정/옵션/템플릿/제약/기초코드/카테고리 + **추가 발굴 축**)을 도출하고, 후니 실제 t_* 현황과 갭 분석한 뒤, 후니에 필요한 기초데이터 관리 **"그릇"(스키마/관리축)**을 설계 제안한다. RedPrinting은 사용자 본인 설계 시스템이므로 검증된 참조 모델로 흡수(답습 아님). 위젯 구현 역공학(huni-widget)·후니 t_* 실 적재/매핑(huni-dbmap)과 별개의 **메타모델 발굴·그릇 설계 전용** 하네스.

**트리거:** "레드프린팅 옵션 분석", "RP 메타모델", "옵션 관리 메타모델", "기초데이터 관리 체계/그릇", "자재 공정 옵션 관리 그릇", "관리 메타모델 발굴", "RedPrinting 벤치마크 메타모델", "후니 기초데이터 그릇 설계", "현수막 옵션 구성 분석", "RP-Meta 하네스 실행/재실행/업데이트/보완", "특정 상품군만 메타모델" 등 본 도메인 요청 시 `huni-rpmeta-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-rpmeta/` (01_reverse·02_metamodel·03_gap·04_vessel·05_validation). 에이전트=`rpm-reverse-engineer`·`rpm-metamodel-architect`·`rpm-gap-analyst`·`rpm-vessel-designer`·`rpm-validator`(+재사용 `dbm-schema-analyst`/`dbm-ddl-proposer`/`dbm-domain-researcher`).

**핵심 결정:** ① 대표샘플→메타모델→확대(전수수집 금지) ② 7버킷 외 **추가 메타모델 심층 발굴**이 핵심 directive ③ 라이브 읽기전용(주문/POST 금지) ④ **DB 미적재 — 그릇=설계 제안, 실 적용 인간 승인**(search-before-mint·정규화·컨벤션 정합) ⑤ RedPrinting 모델은 흡수하되 naming/codes는 후니로 유입 금지 ⑥ 생성≠검증(M1~M6 게이트).

**변경이력:** 최신: 2026-06-19 codex 게이트 교차검증 레인(Phase 6.5) 신설 + FS·NC·OT·PO 선별 종단 GO(13번째·17축 수렴·divergence 0) → `_workspace/huni-rpmeta/CHANGELOG.md`

---

## 12. Harness: Huni-Basecode-Governance (기초코드 등록 거버넌스)

**목표:** 후니프린팅 기초코드(자재·사이즈·도수·인쇄옵션·공정·기초코드+카테고리)를 개선/보완/수정하기 위해, **rpmeta 그릇 처방(vessel-gap)** + **dbmap 데이터 진단(round-13/22)** + 인쇄 도메인 지식 + 역공학 + 경쟁사를 종합해 "**기초코드 등록 명세 마스터**"(축별 신규 등록/교정/축이동 + webadmin 적재경로 + 4-way 근거)를 도출한다. 권위[HARD]=상품마스터(260610)+인쇄상품 가격표(260527), 역공학·경쟁사는 갭헌팅 보강(권위 덮어쓰기 금지). **rpmeta(그릇 부재 판정)도 dbmap(데이터 교정 적재)도 아닌, 그 둘의 교집합을 "무엇을 기초코드로 등록/교정할 것인가"의 거버넌스 명세로 종합**. 분석·명세 전용 — 실 라이브 COMMIT은 인간 승인 후 dbmap 적재 트랙(dbm-load-execution·dbm-axis-staged-load) 위임.

**트리거:** "기초코드 등록", "기초코드 등록 필요분 도출", "기초코드 거버넌스", "기초코드 개선/보완/수정", "자재/사이즈/도수/인쇄옵션/공정/기초코드 정리", "잘못된 매핑 도출", "등록 명세 마스터", "권위 정답 사전", "4-way 진단", "basecode 하네스 실행/재실행/업데이트/보완", "특정 축만 등록명세", "자재 등록명세", "카테고리 등록명세", "huni-basecode" 등 본 도메인 요청 시 `huni-basecode-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-basecode/` (01_authority·02_diagnosis·03_registration·04_gate). 4인 팀(`hbg-authority-curator`→`hbg-basecode-diagnostician`→`hbg-registration-designer`→`hbg-validator`)·권위 정답 사전→4-way 진단→등록 명세→B1~B6 게이트. 1순위 축=자재🔴·카테고리🔴(round-22 진단), 나머지 4축 스캐폴드(후속 확장). 라이브 읽기전용 SELECT만(파괴적 쓰기 0)·`.env.local` RAILWAY_DB_*.

**변경이력:** 최신: 2026-06-18 교정 실행 우선순위 트랙(Phase 5·hbg-remediation-planner) 추가 → `_workspace/huni-basecode/CHANGELOG.md`

---

## 13. Harness: Huni-Price-Quote (옵션 선택→가격계산 검증·뼈대)

**목표:** 라이브 가격엔진(`raw/webadmin` `catalog/pricing.py`의 `evaluate_price` **단일 권위 알고리즘**)과 라이브 `t_prc_*` 가격 데이터(공식 48·formula_components 301·구성요소 146·단가행 7,293·상품-공식 바인딩 76·사이즈 520, 직접단가 0=전 상품 공식기반)가 **권위 엑셀**(상품마스터 260610·인쇄상품 가격표 260527)에 맞게 적재됐는지 **냉철하게 평가·검증**하고, 옵션선택→가격구성요소→가격공식→시뮬레이터 검증→위젯 계약의 **단단한 뼈대**를 명세한다. 4구성물(가격공식·가격구성요소·가격뷰어·가격시뮬레이터) 역할·흐름 도해 + evaluate_price 계약 추출이 검증의 자(尺). 5인 에이전트 팀(`hpq-engine-cartographer`→기준점 / `hpq-authority-curator`→기준점 / `hpq-price-chain-inspector`→생성 / `hpq-option-constraint-mapper`→생성 / `hpq-quote-gate-validator`→검증)으로 기준점 팬아웃→생성 검사 팬아웃→P1~P7 냉철한 게이트. **생성≠검증 분리·권위 엑셀 절대 권위·라이브 읽기전용·DB 미적재**(실 교정은 인간 승인 후 dbmap 위임)·대표 상품군 파일럿 우선. 기존 `dbm-price-*` 6종을 입력·도구로 재사용.

**트리거:** "가격계산 하네스", "옵션 가격 검증", "가격엔진 검증", "가격공식/가격구성요소 검증", "가격 정합 평가", "권위 엑셀 매핑 검증", "인쇄상품가격테이블 차원 검증", "시뮬레이터 검증", "옵션/템플릿/제약 검증", "사이즈 중복 점검", "가격 뼈대", "가격계산 하네스 실행/재실행/업데이트/보완", "특정 상품군만 가격검증" 등 본 도메인 요청 시 `huni-price-quote-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-quote/` (01_engine·02_authority·03_chain·04_option·05_gate). 자격증명: `.env.local` `RAILWAY_DB_*`(읽기전용 SELECT)·`HUNI_ADMIN_*`(라이브 화면 읽기 탐색만, 저장/삭제 금지·admin/test1234).

**변경이력:** 최신: 2026-06-18 하네스 초기 구성(5 에이전트+6 스킬·P1~P7 게이트·evaluate_price 실측) → `_workspace/huni-price-quote/CHANGELOG.md`

---

## 14. Harness: Huni-Price-Engine-Diag (가격엔진 이해·진단)

**목표:** 가격계산엔진을 이루는 5개 장치(① 가격공식 ② 가격구성요소 ③ 할인테이블=수량구간 ④ 가격뷰어 ⑤ 가격시뮬레이터)의 역할·조합 메커니즘을 원리적으로 정의하고, 프로그램 코드(`raw/webadmin` `pricing.py`·`price_views.py`)가 DB 엔티티 각 속성(t_prc_*/t_dsc_* 컬럼·타입·제약·코드값·FK·트리거)에 맞게 제대로 구현됐는지 진단하며, **결론을 내리기 전에 "원리상 아는 것 vs 모르는 것"을 지식맵으로 분리**한다. §13 huni-price-quote(검증·게이트·결론)와 분리된 **선행 이해·진단 트랙** — 장치 역할을 정확히 정의하지 않으면 잘못 적재된다는 전제(직전 검증에서 검증자조차 도수축 오해·SIZ 오선택). 2인 에이전트 팀(`hped-mechanism-researcher` 장치 역할 원리 정의·지식격차 / `hped-code-schema-auditor` 코드↔DB 속성 정합·설계 산출물 3-way 추적)이 팬아웃+교차참조.

**트리거:** "가격엔진 이해", "가격엔진 진단", "가격 장치 역할", "공식/구성요소/할인/뷰어/시뮬레이터 역할", "가격엔진 원리", "조합 메커니즘", "코드 DB 정합", "속성 단위 구현 진단", "설계 산출물 반영", "아는것 모르는것", "지식격차 리서치", "가격엔진 이해 하네스 실행/재실행/업데이트/보완", "특정 장치만 진단" 등 본 도메인 요청 시 `huni-price-engine-diag-orchestrator` 스킬을 사용. 권위 엑셀 대비 정합 검증·P1~P7 게이트·결함 교정은 §13 검증 트랙. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-engine-diag/` (01_mechanism·02_code_schema·03_synthesis). 권위 순서: ① 라이브 코드(동작) ② 설계 산출물(docs/prcx01-pricing-model.md·pricing-erd.md=의도) ③ 라이브 스키마/데이터 ④ 인쇄 도메인(보강). 라이브 읽기전용 SELECT만·DB 미적재(검증·교정은 §13/dbmap 위임).

**변경이력:** 최신: 2026-06-18 전 하네스 전수 감사+정리(가격 4하네스=상보 레이어·재병합 금지·STALE 정정·문서/배선만) → `_workspace/huni-price-engine-diag/CHANGELOG.md`

---

## 15. Harness: Huni-Quote-Verify (상품 가격계산 검증 · Claude+Codex 병행)

**목표:** 사용자가 **"상품군(카테고리)+상품명"**(예: "프린트엽서 가격계산 검증해줘")을 주면, 그 상품이 자기 가격공식으로 **가격계산이 되는지** 검증하고 개선/수정/보완안을 도출한다. 검증 3축[HARD]: ① **SOT 일치**(상품마스터 260610 ↔ 인쇄상품 가격표 260527 데이터 일치) ② **가격공식 속 가격구성요소 매핑 정합**(시트 차원경계 SOT 안에서 제대로 배선) ③ **가격구성요소 차원 ↔ 가격테이블 차원 매칭**. 한 줄 명령이 무엇을 뜻하는지를 분해가가 해독(상품 요소 전수+공식사슬+골든)해 목표를 푼다. §13(대표 상품군 파일럿 냉철 게이트)·§14(5장치 이해·진단)의 산출을 입력으로 재사용하는 **단일 상품 온디맨드 검증+개선** 트랙.

**★Claude+Codex 병행(독립 교차검증):** Claude(라이브 실측·evaluate_price 실호출)가 1차 검증, **Codex gpt-5.5**(`codex exec` 읽기전용·ChatGPT 구독 OAuth·API 종량과금 없음)가 같은 work-spec으로 독립 2nd opinion → reconcile(합의=고신뢰·불일치=조사). ★Codex 주장=가설(라이브/권위 검증 전 채택 금지·환각 경계). codex-preflight로 가용성 판정·미가용 시 "Claude 단독" 명시 폴백(pending 금지).

**트리거:** "가격계산 검증", "상품 가격 검증", "프린트엽서 가격검증", "이 상품 가격계산 되는지", "가격공식 검증", "SOT 일치 검증", "공식/구성요소 매핑 검증", "차원 매칭 검증", "codex 병행 검증", "가격검증 하네스 실행/재실행/업데이트/보완", "특정 상품만 검증", "검증 다시" 등 본 도메인 요청 시 `huni-quote-verify-orchestrator` 스킬을 사용. 5장치 역할 이해·진단은 §14, 대표 상품군 냉철 게이트는 §13. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-quote-verify/<product>/` (01_decompose·02_verify·03_codex·04_remediation). 생성≠검증·라이브 읽기전용 SELECT만·DB 미적재(실 교정은 인간 승인 후 dbmap 위임). 자격증명 `.env.local RAILWAY_DB_*`.

**변경이력:** 최신: 2026-06-18 하네스 초기 구성(3 에이전트+4 스킬·codex-review.sh·Claude+Codex 병행 3축 검증) → `_workspace/huni-quote-verify/CHANGELOG.md`

---

## 16. Harness: Huni-Recipe-Viz (상품 구성요소 시각화·레시피 검증 · codex 중심)

**목표:** 상품마스터 각 시트의 각 상품을 이루는 구성요소(자재·공정·옵션·사이즈·도수)를 **한눈에 보는 시각화**로 만들고, 그 구성요소를 중심으로 가격이 만들어지는데 **누락되면 제대로된 결과값을 확인할 수 없는** 문제를, **codex-cli(레시피 생성·연결 검증)와 codex-imgage(mermaid→이미지 2단계 시각화)** 로 산출해, 상품마다 구성요소가 제대로 연결됐는지·상품에 연결할 가격공식의 가격구성요소가 제대로 설계됐는지 확인한다. 작업지시서/생산지시서형 **레시피**(도출: 상품마스터+가격표+round-11 BOM+라이브 t_*)를 토대로 인쇄자동견적이 가능하기 위한 모든 요소를 만든다. **★[HARD] 산출 본문은 Claude보다 codex로 만든다(사용자 directive)·생성=codex/검증=Claude.**

**트리거:** "상품 구성요소 시각화", "레시피 시각화", "구성요소 연결 확인", "가격구성요소 설계 확인", "작업지시서 레시피", "생산지시서", "인쇄자동견적 요소", "codex 레시피 시각화", "구성요소 한눈에", "상품마스터 시트 시각화", "레시피·시각화 하네스 실행/재실행/업데이트/보완", "특정 시트만 레시피", "시각화 다시", "연결검증 다시" 등 본 도메인 요청 시 `huni-recipe-viz-orchestrator` 스킬을 사용. 단일 상품 가격계산 검증은 §15, 상품군 위키 집필은 §9. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-recipe-viz/<sheet>/` (01_recipe·02_viz·03_audit·04_validation). 4 에이전트(`hrv-recipe-builder` codex-cli 레시피 / `hrv-component-visualizer` mermaid→codex-imgage 2단계 / `hrv-connection-auditor` codex-cli 연결·가격공식 설계 검증 / `hrv-validator` Claude R1~R6 독립 게이트) + 5 스킬. codex 헬퍼=`rpm-visualize/scripts/codex-preflight.sh`·`hqv-codex-cross-verify/scripts/codex-review.sh` 재사용. 라이브 읽기전용 SELECT만·codex `-s read-only`·DB 미적재(실 교정 인간 승인 후 dbmap/§15 위임).

**핵심 결정:** ① codex 중심(산출 본문 codex·Claude는 큐레이션·호출·검증) ② **시각화 2단계: mermaid 진실 소스 먼저 → codex-imgage 이미지 → mermaid 기준 정합 검증**(사용자) ③ 레시피=도출(작업지시서 문서 부재) ④ 생성=codex/검증=Claude(codex 주장=가설·환각 경계) ⑤ 디지털인쇄 시트 파일럿 우선.

**변경이력:** 최신: 2026-06-18 디지털인쇄 파일럿 완주 GO + R7 freshness 게이트 추가(라이브 드리프트 적발) → `_workspace/huni-recipe-viz/CHANGELOG.md`

---

## 17. Harness: Huni-Basedata-Dedup (기초데이터 표시중복 정리·검수·적재 · Claude+codex 교차)

**목표:** 두 SOT 권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)을 **토큰효율적으로 탐색**(1회 추출→CSV 캐시, 엑셀 반복 Read 금지)해, 6축 기초데이터(사이즈·공정·자재·기초코드·인쇄옵션·도수) 중 **사용자 화면 표시명/내부값이 중복**이거나 **표시↔실제가 불일치(오적재)**인 데이터를 검수하고, 정리/적재할 매핑데이터를 만들어 승인 후 라이브에 안전 적재한다. 중복의 본질[사용자 정의]=키는 고유하나 화면 표시가 중복으로 보이는 것(예 "60x60" 여러 코드). **★Claude 생성 + codex cli 2차 교차검증으로 오적재 방지. 정리/적재할 것 없으면 통과(NO-OP).** §12(basecode 정확성 거버넌스)·§7(dbmap 전체 매핑)과 별개의 표시중복+codex 안전적재 전용 트랙.

**검수 4축[HARD]:** ① 권위추출+표시↔실제 정합(siz_nm 등 라벨 ↔ 내부 치수값 일치·불일치=오적재) ② 표시 중복(화면 라벨 동일·코드 다름) ③ 내부값 중복(실제값 동일·코드 다름) ④ 의미구분 보존(작업/재단/판형/단위/상품전용은 중복 제외=false-positive 가드). 판정=권위에서 canonical(의미축+정규치수+단위) 도출→라이브 환원→충돌·불일치 검출.

**트리거:** "기초데이터 중복 정리", "사이즈 중복 정리", "표시명 중복", "사이즈정보 검수", "SOT 엑셀 사이즈 정리", "DB 적재 사이즈 매핑", "codex 교차 적재", "기초데이터 정합 검수", "공정/자재/도수 중복", "기초데이터 정리 하네스 실행/재실행/업데이트/보완", "특정 축만 중복 정리" 등 본 도메인 요청 시 `huni-basedata-dedup-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-basedata-dedup/<axis>/` (index/authority/live.csv·dedup-report·mapping.csv·reconcile.md·_exec). 4인 팀(`hbd-source-harvester`→`hbd-dedup-analyst`→`hbd-codex-verifier`→`hbd-load-executor`)·D1~D6 게이트·**사이즈 파일럿 우선**. 기존 `00_schema/ref-*.csv`·`24_master-extract-260610`·codex-review.sh 재사용. 라이브 읽기전용 기본(`.env.local RAILWAY_DB_*`)·실 적재는 승인 후·가격종속(component_prices)은 BLOCKED 보류.

**변경이력:** 최신: 2026-06-19 공정 파일럿 GO·라이브 COMMIT(9건 논리삭제·codex 합의 14/14·일괄 merge 함정 회피) → `_workspace/huni-basedata-dedup/CHANGELOG.md`

---

## 18. Harness: Huni-Price-Engine-Design (가격계산 엔진 설계·구축)

**목표:** 역공학 자료(`raw/widget_monitor`·`docs/reversing`·`_workspace/huni-rpmeta`) + 상품마스터(260610) 가격계산공식 + 인쇄상품 가격표(260527) + 경쟁사(와우프레스·레드프린팅) 가격계산 방식을 종합해, **모든 상품군 완제품·반제품(세트상품)이 어떤 가격구성요소를 토대로 어떤 가격공식을 이루는지**를 설계한다. 산출=라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 t_prc_* 그릇 설계 명세(공식→formula_components→price_components→component_prices·use_dims 차원·세트 조합). **기존 가격 5하네스(§7 적재·§13 게이트·§14 이해·§15 온디맨드검증·§16 시각화)와 달리 "설계·구축" 각도 — 아직 없는/불완전한 가격공식을 경쟁사 흡수+역공학으로 새로 설계**(재병합 금지·상보). 5인 팀(`hpe-formula-cartographer`·`hpe-benchmark-analyst` 기준점 팬아웃 → `hpe-engine-designer` 설계 → `hpe-validator` E1~E7 게이트 → `hpe-codex-validator` codex 독립 2차 교차 Phase5.5). 대표 상품군 파일럿→동형 전파·생성≠검증·codex 주장=가설(환각 경계)·권위 엑셀 절대권위·라이브 읽기전용·**DB 미적재**(실 COMMIT/DDL은 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).

**트리거:** "가격계산 엔진 설계", "가격엔진 구현", "가격공식 설계", "가격구성요소 설계", "완제품 반제품 세트 가격", "경쟁사 가격계산 흡수", "와우프레스 레드 가격 분석", "codex 설계 검증", "t_prc 그릇 설계", "가격엔진 설계 하네스 실행/재실행/업데이트/보완", "특정 상품군만 엔진 설계" 등 본 도메인 요청 시 `huni-price-engine-design-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-engine-design/` (`_meta`·`01_formula`·`02_benchmark`·`03_design`·`04_validation`·`05_codex`). 자격증명 `.env.local RAILWAY_DB_*`(읽기전용 SELECT). codex 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh`(내부에서 `rpm-visualize/scripts/codex-preflight.sh` 호출) 재사용. 기존 `dbm-price-arbiter`·`dbm-ddl-proposer`·`dbm-schema-extract`·`dbm-excel-parse` 재사용.

**변경이력:** 최신: 2026-06-22 디자인캘린더 종단 GO(inline 정찰가 BLOCKED·고정가형 완제 SKU·11번째 최종 종단·★상품마스터 11시트 전수 완주·codex가 돈크리티컬 2건[본체 ×qty 저청구·엽서 라우팅] 독립 적발→교정 후 GO) → `_workspace/huni-price-engine-design/CHANGELOG.md`

## 19. Harness: Huni-Widget-Flow (위젯 구조·플로우 문서화 + 이중 청중 시각화)

**목표:** `docs/reversing`(RedPrinting 위젯/SDK 역공학 — productRedWidgetSDK 브릿지·widget.js Vue3+Pinia Shadow DOM·RedEditorSDK Edicus) + `raw/widget_monitor` 캡처를 근거로, 개발자가 전체 위젯 구조와 플로우를 확인할 수 있는 **① 개발자용 mermaid 기술 문서**(전체 아키텍처+초기화/가격/주문 시퀀스+에디쿠스 라이프사이클+26 상품군별 **파일 업로드 vs 에디쿠스(편집기) 연결** flowchart)와 비전문가도 한눈에 파악하는 **② codex-imgage 인포그래픽**(제품군 구성·전체 고객 여정·두 경로 대비)을 산출. 분기 권위 메커니즘=`exterior.uploadType`(editor|pdf)+상품 `item_gbn`(book2025_item=양쪽/vDigital_item=에디터 전용). 위젯 구현(§6)·가격 레시피 시각화(§16)와 별개의 "구조·플로우 문서화" 전용 하네스.

**트리거:** "위젯 구조 문서", "위젯 플로우 문서화", "위젯 mermaid", "파일업로드 에디쿠스 연결", "제품군 플로우 시각화", "위젯 플로우 하네스 실행/재실행/업데이트/보완", "특정 상품군만 플로우" 등 본 도메인 요청 시 `huni-widget-flow-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-widget-flow/` (01_curation·02_mermaid·03_visual·04_validation). 4 에이전트(`hwf-flow-curator` 증거 큐레이션 → `hwf-mermaid-author` 개발자 mermaid ∥ `hwf-flow-visualizer` codex-imgage 비전문가 시각화 → `hwf-validator` F1~F6 독립검증)·하이브리드(팬아웃→병렬 생성→독립 검증)·생성≠검증·근거 충실·미상 정직(모름 표기)·읽기전용(라이브 접속 불요). 최종 mermaid 통합본은 인간 확인 후 `docs/reversing/widget-flow/`로 모을 수 있음.

**변경이력:** 최신: 2026-06-22 하네스 초기 구성(4 에이전트+5 스킬·역공학 3계층/경로분기 도메인 확정) → 첫 실행 시 CHANGELOG 생성

## 20. Harness: Huni-Edicus-Codemap (edicus.man 코드맵 + Edicus SDK/API → 개발팀 아키텍처/플로우 문서)

**목표:** `docs/edicus.man`(후니 Web-to-Print SaaS — Next.js 15 App Router·React 19·TS·Edicus SDK 통합) 코드베이스 + **Edicus 공식 SDK/Server API PDF**(JS SDK 38p·Server API 43p, ㈜모션원) + `EDICUS_*` 환경변수(18종)를 종합해, **개발팀이 전체 아키텍처·플로우·각 코드·API를 알 수 있는 mermaid 기술 문서**를 산출 — 시스템 아키텍처(Next.js·Edicus·Firebase·S3 경계)·라우트맵·인증→편집→주문 시퀀스·Edicus 패시브모드 라이프사이클(info@*)·주문 상태머신·**코드↔API 배선도**(useEdicus/useHuniEditor 등 hook ↔ SDK 메서드/Server API). §19(역공학 위젯 플로우·비전문가 시각화)와 달리 **자체 구현 코드맵 + 공식 SDK/API 권위 + 개발팀 전용**.

**트리거:** "edicus 코드맵", "edicus.man 분석", "Edicus SDK API 분석", "코드맵 mermaid", "전체 아키텍처 플로우 문서", "개발팀 아키텍처 문서", "Edicus 코드맵 하네스 실행/재실행/업데이트/보완", "특정 코드/API만 분석" 등 본 도메인 요청 시 `huni-edicus-codemap-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-edicus-codemap/` (01_api·02_codemap·03_flow·04_validation). 4 에이전트(`hec-api-cartographer` 공식 SDK/API+env ∥ `hec-code-cartographer` Next.js 코드맵 → `hec-flow-author` mermaid 통합 → `hec-validator` C1~C6 독립검증)·하이브리드(팬아웃→통합→검증)·생성≠검증·PDF=1차권위·코드=권위·근거(`PDF p.N`/`파일:라인`)·**비밀값 비노출[HARD]**(env 키 이름·역할만, 값 금지)·읽기전용. 최종 mermaid 통합본은 인간 확인 후 `docs/edicus.man/docs/codemap/`로 모을 수 있음.

**변경이력:** 최신: 2026-06-22 역공학 양면 권위 진화+재실행 GO(RedEditorSDK 45메서드 카탈로그·passive 양면=공식 from-edicus 14↔KOI-Passive 4·후니=공식 from-edicus 전용/KOI=잔재 코드실증) → `_workspace/huni-edicus-codemap/`

## 21. Harness: Huni-Catalog-Conformance (전 상품 카탈로그 종단 정합 검증 + 교정 명세)

**목표:** 전 라이브 DB 상품에 등록된 12축(사이즈코드·도수·인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰·옵션그룹·제약규칙·추가상품 템플릿) + **가격엔진 항목**이 두 권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)과 일치하는지 **누락 0으로 종단 정합 검증**하고 개선/보완/수정 명세를 산출. **옵션→차원 연결(polymorphic ref_dim_cd)·템플릿→추가상품 연결**까지 잇고, `옵션 선택→차원 환원→단가행→final_price` 종단 e2e 골든 추적으로 정석을 보인다. ★[HARD] 인쇄 도메인 지식 먼저·★기존 가격엔진 5하네스(§13·§14·§15·§16·§18) 산출물 재사용(조사 반복 금지)·codex-cli 독립 2차 교차검증·gstack browse로 product-viewer 라이브 3원 대조(엑셀↔DB↔화면). §7 Coverage(존재만)·§13(대표 파일럿)·§15(단일 상품)·§17(표시중복)과 별개의 **전 상품×전 축 종단 정합** 트랙. 6인 팀(`hcc-authority-curator` 기준점 → `hcc-basedata-inspector`·`hcc-cpq-link-inspector`·`hcc-price-engine-inspector` 생성 팬아웃 → `hcc-codex-verifier` 독립 2차 → `hcc-conformance-gate` K1~K8 검증). 생성≠검증·codex 주장=가설(환각 경계)·권위 엑셀 절대권위·라이브 읽기전용 SELECT만·검증+교정명세+codex합의까지(실 COMMIT/DDL은 인간 승인 후 dbmap 트랙 위임·webadmin 코드 직접수정 금지).

**트리거:** "카탈로그 정합 검증", "전 상품 등록 데이터 정합 검증", "등록 데이터 권위 일치 확인", "12축 정합", "옵션 차원 연결 검증", "템플릿 추가상품 연결 검증", "가격엔진 항목 정합", "누락 없는 검증", "codex 교차 정합", "product-viewer 확인 검증", "정합 하네스 실행/재실행/업데이트/보완", "특정 축/상품만 정합 검증" 등 본 도메인 요청 시 `huni-catalog-conformance-orchestrator` 스킬을 사용. 단일 상품 온디맨드는 §15, 대표 파일럿 가격 게이트는 §13, 표시중복은 §17, 위젯 코드 동작 정합은 §6. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-catalog-conformance/` (01_authority·02_basedata·03_cpq_link·04_price_engine·05_codex·06_gate·_meta). 누락 0의 자=`01_authority/conformance-checklist.csv`(전 상품×12축). 자격증명 `.env.local RAILWAY_DB_*`(읽기전용 SELECT)·`HUNI_ADMIN_*`(gstack 읽기 탐색만). codex 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh` 재사용.

**변경이력:** 최신: 2026-06-23 RC-2 각목 COMMIT(손님 택1 900이하/초과·세로가로 생산메타 분리·12000 이중합산 해소·12행·Q3 도메인/경쟁사 손님직접 수렴·R1~R6 GO)→RC-2 데이터 트랙(추가물·CONFIRM·각목) 전부 완료. 직전: RC-2 CONFIRM 3건·추가물·RC-5 COMMIT. 잔여=PET(HOLD-1)·타공8/족자 단가 컨펌·타공 위젯 코드트랙·RC-1 → `_workspace/huni-catalog-conformance/CHANGELOG.md`

## 22. Harness: Huni-RE-Verify (RedPrinting 위젯/SDK 역공학 재검증 + 런타임 동등성 검증 · codex high 교차)

**목표:** RedPrinting 위젯/SDK를 두 역공학 리포트(`docs/reversing` SDK Deep Analysis·Widget Analysis)와 최신 베스트프랙티스(차등/동등성 테스트·골든 마스터 record-replay·메타모픽·CASCADE 환각가드)로 재검증하되, **★역공학한 코드가 실제로 동작/재현되는지**를 라이브 RedPrinting을 **기준 오라클(reference oracle)**로 한 차등 테스트로 입증하고, **codex-cli high 독립 2차 교차검증**(서브시스템별 reconcile)으로 환각을 가드한다. §6 huni-widget 재구성(04_build·05_qa 동등성게이트·07_parity)·`raw/widget_monitor` 라이브 테스트베드를 **80% 재사용**(역공학·테스트베드 재구축 금지). §6(구현)·§19(플로우 문서)·§20(edicus 코드맵)과 별개의 **"역공학 정확성 + 런타임 동등성 검증" 전용** 트랙(검증+교정명세까지·실 수정은 §6 위임·인간 승인).

**검증 게이트[HARD]:** V-PRICE(6: 골든 strict 재생·라이브 차등·PRICE≠0 sanity·result_sum 권위·조합 fuzz/메타모픽·필드사전 정합)·V-WIDGET(5: 캐스케이드·emit-on-change·Shadow DOM 렌더·주문조립·커버리지)·V-EDITOR(5: mock postMessage peer 프로토콜·라이프사이클·가격콜백·업로드·무백엔드) + 메타게이트(VM-1 생성≠검증·VM-2 codex reconcile·VM-3 무날조). 오라클=라이브(Red 산식 재유도에 맞추지 않음)·PRICE=0=결함신호·codex 주장=가설(확증 전 사실 아님·미가용 시 Claude 단독 명시 pending 금지)·라이브 읽기전용(주문/결제/폼submit 금지)·비밀 [REDACTED].

**트리거:** "역공학 재검증", "역공학 코드 동작 검증", "RedPrinting 위젯 동등성 검증", "역공학 런타임 검증", "골든 마스터 검증", "차등 테스트", "codex high 교차검증", "price-calc 동등성", "RE-verify 하네스 실행/재실행/업데이트/보완", "특정 서브시스템만 검증" 등 본 도메인 요청 시 `huni-re-verify-orchestrator` 스킬을 사용. 위젯 구현은 §6, 플로우 문서화는 §19, edicus 코드맵은 §20. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-re-verify/` (`_meta` 방법론리서치·codex-high-spec·01_inventory·02_golden·03_price·04_widget·05_editor·06_codex·07_gate). 7인 팀(`hrev-asset-curator` 기준점 → `hrev-golden-recorder` 라이브 골든캡처 → `hrev-price-equivalence`·`hrev-widget-behavior`·`hrev-editor-bridge` 검사 팬아웃 → `hrev-codex-verifier` codex high 2차 → `hrev-verify-gate` V+메타게이트). **파일럿=가격계산 API**. codex 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh ... high`(stdin `</dev/null`·`--skip-git-repo-check` 패치 적용). 자격증명 `.env.local`(라이브 세션·EDICUS_* — 골든/로그 비노출).

**변경이력:** 최신: 2026-06-23 첫 종단 실행+역공학 최신화(4월→6월 widget.js +137KB·R0~R3 재역공학·Garage/신규14필드/신규옵션군)+신규필드 재검증(V-PRICE NO-GO·N3 견적불가/N1 저청구)+N3·N1 교정(vitest 159 green·N3 CLOSED) → `_workspace/huni-re-verify/CHANGELOG.md`

## 23. Harness: Huni-Set-Product (셋트상품 구성·설계·라이브 적재)

**목표:** 기초마스터~상품정보~상품뷰어~셋트상품관리 4계층을 종합해 **셋트상품(부품조립형: 셋트 완제품 `prd_cd` ← 반제품 구성원 `sub_prd_cd`, `t_prd_product_sets`)** 구성 데이터를 설계하고 **라이브 DB에 실제 적재**(자체 load-executor·인간 승인 게이트)한다. 권위[HARD]=상품마스터 엑셀(260610), 참조=인쇄도메인+경쟁사(레드프린팅·와우프레스 상품군), 가격은 `evaluate_set_price`(pricing.py:718 — 구성원별 evaluate_price 합산 + 셋트 완제품 공식 + 할인) 정합으로 **가격 구성 가능성**까지. 상품유형[사용자 확정]: 기성상품(제조불필요)·디자인상품 **제외**·완제품=셋트 아닌 단일 제조상품·반제품=셋트 구성원(webadmin admin.py:1082 인라인 필터와 정합). §18(셋트 가격공식 설계·DB 미적재)·§7(CPQ/templates 스키마)·§21(addon 정합 검증)·§11(세트 메타모델)의 산출을 **입력으로 종합**해 셋트 구성 데이터 조립·실 적재하는 전용 트랙(재병합 금지·상보).

**트리거:** "셋트상품 구성", "셋트상품 설계", "세트상품 설계", "부품조립 셋트", "t_prd_product_sets 적재", "셋트 구성 데이터", "셋트상품 라이브 적재", "셋트 가격 구성", "셋트상품 하네스 실행/재실행/업데이트/보완", "특정 셋트만 구성/설계" 등 본 도메인 요청 시 `huni-set-product-orchestrator` 스킬을 사용. 가격공식 설계 자체는 §18, 전 상품 정합은 §21, CPQ 옵션 매핑은 §7(dbmap). 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-set-product/` (01_authority·02_reference·03_design·04_codex·05_gate·06_load·_meta). 6인 팀(`hsp-authority-curator`∥`hsp-domain-researcher` 기준점 팬아웃 → `hsp-set-designer` 설계 → `hsp-codex-verifier` codex 독립 2차 → `hsp-set-gate` S1~S7 게이트(evaluate_set_price 재계산·DRY-RUN) → `hsp-load-executor` 승인 후 안전 적재(백업·복합PK 멱등·사후검증)) + 5 스킬(+ `dbm-load-execution`·`hqv-codex-cross-verify`·`hpe-competitor-benchmark`·`rpm-live-reverse` 재사용). 생성≠검증·codex 주장=가설·search-before-mint(반제품 신규 mint 금지·미등록은 BLOCKED→dbmap 위임)·라이브 읽기전용(적재 Phase 5만 인간 승인 후 COMMIT)·파일럿(책자류·엽서북·떡메) 완주→동형 전파. 자격증명 `.env.local RAILWAY_DB_*`.

**변경이력:** 최신: 2026-06-27(2세션) 명함034 펄 collapse+바인딩 COMMIT(83바인딩)·굿즈 기초 시범3+라벨모델 확정(방식B 라벨옵션)·아크릴157 등록사이즈 가격모델 COMMIT·★siz_cd→cut환원 코드수정 검증(미배포 확인필요)·신설 §26 가격테이블 적재무결성 하네스+§27 가격 종단 마스터 오케스트레이터. 다음=마스터로 아크릴 종단 실행(단 코드배포 결정 선결) → `_workspace/_foundation/HANDOFF.md`(가격 파이프라인 핸드오프)·`_workspace/huni-set-product/HANDOFF.md`·`remediation/_REMEDIATION-LOG.md`

---

## 24. Harness: Huni-Shopby-Commerce (라이브DB 상품/가격 → Shopby 장바구니→주문 통합 설계)

**목표:** 라이브 Railway DB 상품/가격(t_prd_*·t_prc_*·`evaluate_price` 계산가·CPQ)을 **Shopby(NHN Commerce) 장바구니→주문**으로 보내고, 추후 위젯이 고객의 구성요소 선택을 카트를 통해 주문 완료까지 잇도록, ★선행 토대(webadmin 상품+구성요소 선택→가격계산 흐름·라이브 DB 적재 현황) + Shopby 전수 리서치 + 라이브DB→카트→주문 **종단 통합 설계서·아키텍처·API 계약·시퀀스**를 산출한다. admin-analysis 방향(주문/회원/정산/배송=Shopby 네이티브, 상품등록·인쇄옵션·생산워크플로우·파일업로드=커스텀)과 정합. 6인 팀(`hsb-foundation-curator`[후니 선행 토대·기존 §13/§14/§21/§7 산출 재사용] ∥ `hsb-commerce-researcher`[Shopby 커머스] 기준점 팬아웃 → `hsb-product-bridge-analyst` 브리지 → `hsb-integration-architect` 설계 → `hsb-codex-verifier` codex 독립 2차 → `hsb-integration-gate` SB1~SB7 게이트). 문서 권위(OpenAPI 24종+enterprise)+라이브 갭필·브리지 전략은 하네스가 리서치 후 권고(동적 계산가 무손실 주입이 핵심 난제)·생성≠검증·codex 주장=가설·라이브 읽기전용(주문/결제 submit 금지)·DB 미적재(실 구현/연동은 인간 승인 후 §6 huni-widget 위임).

**트리거:** "Shopby 통합", "Shopby 장바구니 연동", "라이브DB 카트 전달", "카트 주문 흐름", "위젯 주문 연동", "상품 가격 카트 브리지", "Shopby 커머스 설계", "주문 완료 흐름", "NHN Commerce 연동", "커머스 통합 하네스 실행/재실행/업데이트/보완", "특정 흐름만 설계" 등 본 도메인 요청 시 `huni-shopby-orchestrator` 스킬을 사용. 위젯 UI 구현은 §6, 가격공식 설계는 §18, 사이트 설계 문서는 §5. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-shopby/` (00_foundation·01_research·02_bridge·03_design·04_codex·05_gate·_meta). 입력 권위=`docs/shopby/`(shopby-api OpenAPI YAML 24종·shopby-api-docs-complete·shopby_enterprise_docs·aurora-react-skin-guide·admin-analysis). 선행 토대=`raw/webadmin/webadmin/catalog/{pricing.py,price_views.py}`·기존 §13/§14/§21/§7 산출 재사용. 자격증명: `.env.local RAILWAY_DB_*`(읽기전용 shape 확인)·라이브 Shopby는 문서/갭필 읽기만.

**변경이력:** 최신: 2026-06-25 하네스 초기 구성(6 에이전트+7 스킬·SB1~SB7 게이트·Shopby 백엔드 확정·`shopby-excluded` 결정 갱신) + 선행 토대 큐레이터(hsb-foundation-curator) 추가(webadmin 가격계산 흐름·라이브 적재 현황을 브리지 선행 단계로·사용자 피드백) → `_workspace/huni-shopby/CHANGELOG.md`

---

## 25. Harness: Huni-Recode (역공학 코드 가독화 + 동작 보존 변환)

**목표:** 부분 디옵된 RedPrinting JS(`docs/reversing/red_reverse_engineer/03_deobfuscated/*.js` — app-api·widget-sdk·app-components·editor-sdk)를 **사람이 읽고 길찾는 형태로 완성**하되 **[HARD] 실행 가능 동등을 유지**한다. 현대 기법(LLM이 의미 이름 추론 → AST 코드모드가 스코프 안전 적용 → AST 구조 diff로 동작 보존 증명)을 쓴다 — 텍스트 치환 금지·도메인 식별자(PDT_CD·PRICE·COD…) preserve·서드파티(Sentry·Babel 폴리필 ~9,100줄) 분리·요약. 산출=가독 소스(.js) + 길잡이 문서(아키텍처·모듈 워크스루·내비게이션·기법 노트). §22(런타임 동등성 검증)·§19(플로우 문서)·§20(edicus 코드맵)과 별개의 **"축약 코드 자체를 동작 보존하며 가독화"** 전용 트랙.

**트리거:** "디옵 코드 가독화", "역공학 코드 사람이 읽게", "난독 코드 복원", "코드 가독화", "AST 디옵", "동작 보존 가독화", "서드파티 분리", "가독 소스 만들기", "Recode 하네스 실행/재실행/업데이트/보완", "특정 파일만 가독화", "가독화 다시" 등 본 도메인 요청 시 `huni-recode-orchestrator` 스킬을 사용. 위젯 동등성 검증은 §22, 플로우 문서는 §19, edicus 코드맵은 §20. 단순 질문은 직접 응답.

**산출물 루트:** `docs/reversing/red_reverse_engineer/05_readable/` (`_meta` 기법플레이북·toolset·`01_cartography`(리네임/주석/서드파티 맵)·`02_readable`(가독 .js)·`03_verify`(G1~G6 verdict)·`_tooling`(node_modules·gitignore)·`docs`(길잡이 문서)). 5 에이전트(`rcd-technique-researcher` 최신기법 → `rcd-module-cartographer` 맵 → `rcd-readability-engineer` AST 변환·생성 → `rcd-equivalence-verifier` 동등성·가독성 게이트·검증 → `rcd-doc-author` 문서) + 3 스킬(`rcd-ast-deobfuscate`·`rcd-equivalence-verify`·오케스트레이터). ★실행 모드=**dynamic workflow(Workflow 툴)**: cartograph→codemod→verify(G1~G6)→NO-GO 시 루프(맵/스크립트 보강·최대 3회)→doc, 목적 부합까지. 생성≠검증·동작 보존=AST 구조 동등성(G2)이 자·파일럿(deob_05)→동형 전파(06/07/editor_sdk)·읽기전용(라이브 불요·Node+@babel+recast+prettier). 도구 미설치 시 `_tooling/`에 npm 설치.

**변경이력:** 최신: 2026-06-26 editor 핵심메서드 의미화 GO(기계명 450→268)+07 비절단 재추출(full.js·G2클린이나 재-minify NO-GO)+G4b 의미품질 게이트+07 가능성 타진(中上·PARTIAL-SETUP-ONLY). 05/06 정식 GO. 다음=07 경로 결정 → `docs/reversing/red_reverse_engineer/05_readable/HANDOFF.md`·`CHANGELOG.md`

---

## 26. Harness: Huni-Price-Table-Integrity (권위 가격테이블 적재 무결성 진단)

**목표:** 두 권위 엑셀(상품마스터 가격표포함 260610·인쇄상품 가격표 260527)의 각 시트 **가격테이블 "차원 + 전 데이터셀"이 라이브 DB에 이 빠짐 없이·정확히 적재**됐는지 정밀 진단하고 보완/교정 명세를 산출한다. 권위=엑셀(절대)·라이브=감사 대상. 3종 결함=① 미적재 셀(sparse grid·이 빠진 것·견적 0/최소가) ② 차원 누락(권위 가격축이 라이브 use_dims·차원행에 없음·손님 선택불가/엔진 미환원) ③ 정합 불일치(적재값≠권위·mat 코드 불일치·표시↔실제 오적재). **가격공식·가격구성요소(차원 포함) 설계(§18)·검증(§13/15)의 선행 신뢰 기반** — 불완전 적재 위에 설계하면 정확값 불가(아크릴 siz_cd×면적·명함 자재 collapse가 실증). §21(전 상품 12축 종단 정합·존재 위주)과 달리 **가격테이블 셀·차원 적재 무결성에 집중·더 granular·설계 선행 게이트**.

**트리거:** "가격테이블 무결성", "적재 무결성 진단", "권위 적재 정밀 진단", "이 빠진 적재", "미적재 셀 진단", "차원 누락 검사", "권위 라이브 적재 대조", "가격격자 빈칸", "sparse grid 진단", "무결성 하네스 실행/재실행/업데이트/보완", "특정 시트만 무결성 진단" 등 본 도메인 요청 시 `huni-price-table-integrity-orchestrator` 스킬을 사용. 가격공식 설계 자체는 §18, 전 상품 12축 종단 정합은 §21, 표시명 중복은 §17, 라이브 실 교정 적재는 §7 dbmap. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-table-integrity/` (01_authority·02_load·03_codex·04_gate·_meta). 4 에이전트(`hpti-authority-extractor` 정답격자 → `hpti-load-inspector` 적재대조 결함보드(시트 팬아웃) → `hpti-codex-verifier` codex 독립2차 → `hpti-integrity-gate` I1~I7 게이트) + 방법론 스킬 `hpti-load-integrity-audit`(+ `hqv-codex-cross-verify`·`dbm-excel-parse`·`dbm-price-import-prep`·`dbm-correctness-audit` 재사용). 생성≠검증·codex 주장=가설·라이브 읽기전용 SELECT만(`.env.local RAILWAY_DB_*`)·DB 미적재(실 교정 인간 승인 후 dbmap 위임)·파일럿=아크릴(sparse grid 실증)→동형 전파.

**변경이력:** 최신: 2026-06-28 **★band-total .01 ×수량 과대청구 결함 발견+.02 라이브 실증+dryrun** — 명함/봉투/합판 "완제품가"(밴드총액)가 prc_typ .01(엔진 .01=총액×수량)로 오타이핑→100~1000배 과대(시뮬레이터 실증 투명명함 100매=1,350,000·정답13,500). 교정 25comp .01→.02(dryrun ROLLBACK검증·승인후 COMMIT). ★.02 실증=명함 전밴드 라이브 선형35원/매·봉투 밴드총액 정확일치. + **상품별 차원 정밀배치+라이브 off-grid 공식확정 방법**(`price-dimension-layout-method.md`·엑셀=값권위·라이브=계산방식권위)·가격표 19시트 단가/합가 계층맵·off-grid 공식4규칙 codify(Phase1 차원배치+계층분류·Phase4 오차3유형+밴드총액 prc_typ 점검). 진단=`remediation/FINDING-bandtotal-x-qty-overcharge.md` → `_workspace/_foundation/HANDOFF.md`·`remediation/`

## 27. 가격 종단 마스터 오케스트레이터 (상품군 단위 파이프라인·수렴 실행)

**목표:** 흩어진 8개 가격 하네스를 의존 순서대로 엮어, 한 상품군이 **"제대로된 가격값"**(전 사이즈·옵션이 권위대로 정확 계산)에 도달할 때까지 구동하는 종단 파이프라인. ★새 분석 하네스가 아니라 **수렴 실행 조율자**(SOT "새 하네스 금지·기존으로 수렴 실행" 정합·"분석 과잉 vs 적재 부족" 해소). 순서[HARD]=① 토대 무결성(§26) → ② 무결성 결함 교정 적재(§7·인간 승인) → ③ 공식·구성요소 설계(§18) → ④ 설계분 적재(§7·인간 승인) → ⑤ 검증(§21 전수+§13/§15 골든 재계산) → NO-GO면 해당 단계 라우팅 루프. 진척판 RTM(`_workspace/_foundation/price-pipeline-rtm.csv`)·실 COMMIT 인간 승인·코드버그=개발팀 C트랙.

**트리거:** "가격 종단 파이프라인", "상품군 가격 제대로", "가격 마스터 오케스트레이터", "상품군 가격 종단 완주", "정확한 가격값까지", "전 상품 가격 정합 완주", "가격 종단 실행/재실행/이어서", "특정 상품군 가격 종단" 등 본 요청 시 `huni-price-master-orchestrator` 스킬을 사용. 단일 레이어 작업은 해당 하네스 직접(§26 무결성·§18 설계·§7 적재·§21 정합). 단순 질문은 직접 응답.

**변경이력:** 최신: 2026-06-29(3세션) **채점 로봇 적발 막힌가격을 이전사이트 오라클로 실해소(라이브 COMMIT 4건)** — ① 채점 로봇 단순상품 3군 확대(sticker13·acrylic12 면적모델·문구 UNBOUND신호)+세트 채점(엽서북094/떡메097 PRICED) ② 투명엽서019 견적0 해소(PET용지비 미적재+판형 오적재 2결함) ③ 포토북100 종단(★페이지가=내지 구성원 단가형·기본24P+추가2P당·OI-3 옵션그룹·엔진 23,800 검증) ④ 072 표지+제본 합산가(이전사이트 실측 표지종이 무관). 방법론 정립=COMP_PAPER단가=가격표 국4절 verbatim·PRICED-0=용지+판형 복합·책자세트 페이지=내지구성원·별도/합산판정=이전사이트 cover paper 가격불변. C트랙=fn_calc_pansu 양방향결함(투명+50%저청구/스탠다드-33%과청구). 다음=072 내지(284)§18→종단·077/082/088 동형 → `_workspace/_foundation/HANDOFF.md`·`remediation/_REMEDIATION-LOG.md`

## 28. MoAI Framework (gated — rarely used here)

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
