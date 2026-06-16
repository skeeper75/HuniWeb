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

**진행 상태:** round-1(구간할인, GO·미적재) DONE · round-2(가격 t_prc_*) **15시트 평면화 DONE**(베스트프랙티스 ETL·component_prices 4805행·검증 GO·후니 siz등록 대기) · round-3(매핑 audit→처리적재 설계) **DONE·DB 미적재**(master 신설·적재 별도 승인) · **CPQ 트랙: 라이브 구현 확인 DONE**(옵션/템플릿/제약 7테이블·트리거 7종·excl_groups 흡수 — 재문서화 `00_schema/cpq-schema.md`·하네스 강화) · **round-4(적재 준비) DONE**(양 트랙 GO: 상품마스터 384행+가격 2,320행, G1~G9 PASS·라이브 DRY-RUN 보류) · **round-5(적재 실행본) DONE**(양 트랙 GO: 상품마스터 384행+코드11+update289·가격 2,320행. **S-gate[도메인 의미]+G1~G9+R1~R6 전건 PASS**·라이브 롤백전용 DRY-RUN 2-pass 멱등·제약위반0·COMMIT0 실증. reg_dt NOT NULL 결함 라이브 적발→수정 RESOLVED. DDL 제안 2건[비치수 size·박 2단룩업]. 실제 COMMIT·DDL적용·코드행등록은 인간 승인 대기) · **GO분 실제 적재 DONE(2026-06-06)**(사용자 "GO분 안전 적재" 승인→백업(read-only)→실제 COMMIT: **인쇄가격 3,504행**[t_prc_component_prices 3,292 등, 라이브 t_prc_* 이제 비어있지 않음]+**상품마스터 398행**[materials 716·processes 260·bundle 26]+update-set, 검증 전건 통과·FK고아0·멱등. 코드행 placeholder(PROC_000084·SIZ_000501~510) 의도적 제외. 백업·undo 안전망 보유. **DB 미적재 원칙→"GO분 적재됨, 차단/결정분만 미적재"로 갱신**. 가격 siz 권위정정[round-2 28상품 면적-좌표 오모델링→면적매트릭스13/고정가15, GUK4/3JEOL/GP35 1,184행 판형교정] 반영분 포함) · **디지털인쇄 가격엔진 트랙 DONE(2026-06-07)**(미설계 SUM 공식 6종 설계+독립검증 GO → 라이브 적재: 디지털 147+ENV 40+GP 121=**308행 COMMIT**, R1~R6 PASS·멱등·공식사슬 완결. 잔존 차단=3절/투명/박/048) · **round-7(입체 커버리지 검증) 실행 완료·GO(2026-06-08)**(전 상품군 11시트 × 라이브 t_* 19엔티티 **209셀 매트릭스**[✅51·🟡44·❌49·◆DB-ONLY17·➖48]+admin 3원대조 3종 일치+관계무결성 R1~R7+갭보드. `evaluator-active` 독립평가 C1~C8 전건 PASS — 행수 10셀·R1/R4/R7·admin 3종 독립 재측정 일치. 횡단 발견: CPQ 옵션 레이어 전면 미적재[option_items 전역 0행·R7 FAIL]·가격사슬 6상품군 부재·DB-ONLY 17셀[외부권위 vs 과적재]·DOMAIN-UNDECIDED 2[기성품 사이즈]. 실결함 D-1[LOADED=행존재만·변형커버리지 미검증]. **조망/검증 전용·DB 미적재**, 발견 미적재 실 적재는 인간 승인) · **round-8(admin UI 입력 명세) 완료·GO(2026-06-08)**(라이브 admin product-viewer `gstack live` 전수 분석 → **34 t_* 엔티티 332컬럼**의 모든 항목을 {UI라벨·컬럼·위젯·필수·타입제약·코드값도메인·미적재입력법·입력화면}으로 정의[`13_admin-ui-spec/`]. 입력화면 2종[catalog Django change form 14모델·product-viewer pvEdit 섹션]. round-7 미적재 갭→admin 입력 FK 위상순서 환원. `evaluator-active` 독립검증이 information_schema로 컬럼수 재집계→1차 NO-GO[tags jsonb 2건 누락]→보정→G1~G7 GO. **교훈: 컬럼 권위=라이브 information_schema, table-spec 보조**. 사용자 directive[각 페이지 모든 항목 정의·누락0] 충족. 명세/입력경로 전용·실 입력은 인간 승인) · **round-10(버전 변경 추적 하네스 신설 + 260527→260610 실행) DONE·GO(2026-06-10)**(`/harness:harness`로 변경추적 트랙 신설[스킬 `dbm-change-tracking`·에이전트 `dbm-change-tracker`·**키 기반 3-way diff**{baseline 260527/new 260610/라이브}·V1~V8 게이트] → 상품마스터 실행: **상품 추가/삭제/재명명 0**·MODIFIED 527셀이지만 **자동 UPSERT 0·전부 ESCALATE(526)/GAP(1)**[굿즈파우치 448=`사이즈(필수)`→`상품(옵션)` 재분류·스티커 37=커팅클리어·아크릴 41=아크릴미니파츠 변형행−16·실사 1=범례텍스트]. `dbm-validator` 독립 **V1~V8 8/8 PASS GO**[diff 스크립트 byte-identical 재실행·라이브 read-only 실측(레더라벨 SIZ_000492/494/496·option_items 18=silsa)·527셀 dodge-hunt→진짜 in-place 스칼라=실사 범례 1건뿐=정당 GAP]. **교훈: 버전변경=데이터모델 의도전환[size→option]일 수 있음·기계적 size 삭제 금지[적재된 size/price 사슬 파손, schema-design-intent-first]**. 가격표는 신규버전 없어 범위 외. 추적·델타 DRY-RUN 전용·실 COMMIT/CPQ L2/논리삭제는 인간 승인) · **round-11(상품마스터 컬럼 도메인 의미 + 상품 BOM + 적재명세) 하네스 확장·디지털인쇄 파일럿 DONE(2026-06-10)**(`/harness:harness`로 신규 에이전트 2[`dbm-domain-researcher` 컬럼의미+상품BOM·`dbm-loadspec-extractor` webadmin 적재명세]·스킬 2[`dbm-column-domain`·`dbm-loadspec-extract`]·오케스트레이터 round-11 추가. **디지털인쇄 7상품·44컬럼·1026행** 파일럿 5산출: column-dictionary[44컬럼 의미축·목표 t_*·확정도 빈칸0]+product-bom[7상품 자재/공정]+loadspec[webadmin BaseAdmin 제너릭·BASE_CODE_GROUP 14·상품인라인6·file:line]+mapping-info[컬럼→t_* 통합·FK 적재순서]+domain-research-notes[컨펌5]. **핵심 도출: 별색≠도수[C18~22→`t_proc_processes`]·판수=앱 임포지션 계산[C6 DB 미저장]·출력판형≠재단≠작업[C10/C5/C8 3축]·자재=parent+usage_cd[낱장 C단일]·박색/파일명약어/폴더[C37/C11/C13] 귀속 컨펌**. round-9 `schema-design-intent-map`의 엑셀 측 입력 절반 충족·07_domain 의미축[L2 공정레시피·L3 9속성] 재사용[재유도0]. DB 미적재[분석/정리 전용]·나머지 10시트 확대·컨펌 5건 해소는 인간/다음) · **round-22(6축 기초데이터 staged 교정·적재 트랙 신설·방법론 설계 DONE(2026-06-16))**(`/harness:harness`로 신규 스킬 `dbm-axis-staged-load` 1개 신설[신규 에이전트 0·기존 6 에이전트 재사용·오케스트레이션만 신설]. 상품마스터를 webadmin `load_master`의 실제 적재 단위 **6축**[① 기초코드→② 사이즈→③ 도수→④ 자재→⑤ 공정→⑥ 카테고리]으로 횡단 재조망. 방법론 2산출[`32_axis-staged-load/01` 정답규칙·`02` 오류진단]: 경계 충돌 15케이스 정답 확정[**별색=공정·색≠자재·두께=자재·UV=공정param·판걸이수=앱계산·출력판형=판형축·시트구분≠카테고리**]·FK 위상 5단계 적재순서·축별 교정 의사결정 트리. **★중대 발견 2[HARD 전제]: ① P-TRUNCATE 재실행 가드** — load_master가 6축 전부 `TRUNCATE … CASCADE` 후 v03 무변환 재INSERT[:168/185/198/214/231/253] → 재실행 가드 없으면 모든 교정 무효(staged의 절대 전제·B-1 1순위) **② 착수 전 6축 라이브 전수 재실측** — 라이브 부분 진화(레더 .08→.06 이미 교정·del_yn 흔적)로 진단 stale. 라이브 실측 오류 보드: **④자재 🔴 최대결함**(색/형상/사이즈/용량/구수가 자재행 .08/.09/.10 130+행)·**⑥카테고리 🔴 고아 14노드 113상품**·③도수 🟢정상(별색 분리 정상·④잉크색 유입 목적지)·①🟢·②🟡·⑤🟡. X1~X6 게이트[P-TRUNCATE 가드·freshness·경계오염0·멱등·라이브 DRY-RUN·비파괴/독립]. 차단 13건[P1=B-1 가드·B-3 자재분리·B-2 카테고리]. **[v2 경로 판정 — 03 적재경로 분석·04 재실측 추가]**: load_master=무변환 전파기(v03 셀값 TRUNCATE 후 그대로 INSERT·도메인 변환 0) → **6축 오류 진원 전부 ⓐ(입력 v03)**(자재 오염·카테고리 고아 모두 v03 인코딩 전파·코드 결함 아님) → 교정 정답=**교정 입력 엑셀 재적재(경로 Y·근본·P-TRUNCATE 안전)** > 라이브 직접 SQL(경로 X·재적재 시 소멸 임시책). **webadmin 코드 수정 금지**(개발자 GitHub 배포·read-only)·코드 강제 영역=개발자 백로그 C-1~C-6. 경로 Y 3조건(시트/헤더 v03 동일·행순/surrogate 보존[삭제=use_yn N·신규 append]·개발자 재적재). 04 재실측: 오염 자재행 component_prices 0건 참조=가격사슬 안전. **가역·고효과 실행·라이브 COMMIT(2026-06-16)**: ★실측이 진단 정정 — ⑥카테고리 교정=재연결 아닌 **고아 부카테고리 페어 삭제**(111상품 이미 정상 잎노드 main='Y'·고아=부카테고리 중복). 경로 X 라이브 COMMIT(`DELETE 111` 고아페어+`UPDATE 12` 빈노드 use_yn=N·정상 273 무손상·BLOCKED 2건[PRD_000218/229 비활성] 보존·undo 보유·멱등 페어 0). ④mat_typ 정정 0건(레더 이미 .06·진짜 자재오염=비소재 행은 CPQ/siz 축이동 B-3·다음). **②사이즈·⑤공정 종단(2026-06-16·검증 X1~X6 GO)**: ②=라이브 가역0(component_prices 116siz 2,601행 CASCADE·전부 가격종속 경로Y/BLOCKED·size↔option경계/판형혼동 0건 CORRECT 반증) · **⑤=에폭시 PRD_000169(아크릴입체블럭) 1건 라이브 COMMIT**(가역·멱등·가격사슬0·168 코롯토는 B-10 정체 BLOCKED)·봉제↔부착6 경로Y·신규mint3 BLOCKED. **★v03 미반영 시 회귀**→경로 Y 백로그(`_backlog/`: v03 11_상품별카테고리 고아페어 제거·15_상품별공정 봉제정정·개발자 재적재)+ⓑ 코드 백로그 C-1~C-6. **④비소재 CPQ 축이동(B-3) 설계 완료·검증 GO(2026-06-16)**: .08/.09/.10 131행·82상품/172link·cp 0참조. 라벨별 목표축(색=본체색 2~3종 자재유지/4종+→CPQ option·형상→siz·구수→bundle·인쇄면→print_side). **라이브 적용 0**(전부 경로Y+round-6 CPQ[색→option·webadmin 적재경로 부재]+BLOCKED). **★FK 위상 load-bearing**(80/82 상품 BOM이 .08/.09/.10 의존→siz/CPQ 적재→재배선→use_yn=N 마지막·삭제 선행 시 본체 자재 전손). 도메인 컨펌 4(AX-1 잉크색·AX-2·AX-4·B-7 형상). **굿즈/파우치 본체 자재 BOM(사용자 "자재 확인됐나" 질의→진단)**: 103상품 본체 소재 확인 **0개**(상품마스터에 소재 컬럼 부재·소재는 상품명에만·진짜 소재행 .05/.06은 실사/책자 고아). **명확분 41상품 라이브 COMMIT**(레더23·캔버스9·린넨5·메쉬4·기존 자재 재사용·신규mint0·INSERT 41·FK고아0·멱등·검증 X1~X6 GO·undo 보유). BLOCKED=타이벡11(하드/소프트)·모호3·신규mint~25(우드/규조토/코르크/벨벳/세라믹·ddl-proposer)·폰케이스5 미등록. 다음=GPM-4(오염 .09 link 제거·본체 선적재 후)·①기초코드·round-6 CPQ 색→option·경로 Y 개발자 재적재·BLOCKED 컨펌).

**변경 이력 (최근 3건, 전체는 `_workspace/huni-dbmap/CHANGELOG.md`):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-16 | **round-22 세션 종합 — 6축 staged 교정 라이브 153행 + 굿즈 자재 정리(전수+RP·WP)** — 사용자 "실 라이브 변경까지·계속 진행". 생성≠검증(validator X1~X6 독립검증 5회 전건 GO). **★실 라이브 COMMIT 153행(undo.sh·되돌리지 말 것)**: ⑤에폭시 PRD_000169 1행(168 코롯토=B-10 BLOCKED)·굿즈/파우치 본체자재 41행(레더23·캔버스9·린넨5·메쉬4·기존 자재 재사용·신규mint0)·⑥카테고리(아래). **명세/제안**: ②사이즈(가역0)·④B-3 비소재 CPQ축이동·**굿즈 자재정리 제안**(전수103·완제품32/소재가공61/모호10 + RP·WP 독립수렴→**후니 자재모델=정답·완제품도 자재·모델 신설 불요**·근본=상품마스터 시트 "본체 소재" 컬럼 신설). **⑥카테고리=실측이 진단 정정: 재연결 아닌 고아 부카테고리 페어 삭제**(111상품 이미 정상 잎노드 main='Y'·고아=중복). 백업+롤백 DRY-RUN→**라이브 COMMIT: `DELETE 111`(고아페어)+`UPDATE 12`(빈노드 use_yn=N)·정상 273 무손상·product_categories 392→281·BLOCKED 2[PRD_000218 타이벡북커버/000229 이미지피켓 비활성] 보존·undo.sh 보유·멱등 페어 0**. ④mat_typ 정정 0건(레더 이미 .06). **★v03 미반영 시 회귀→경로 Y 백로그**(v03 11_상품별카테고리 고아페어 제거+01_카테고리 use_yn=N·개발자 재적재)+ⓑ 코드 백로그 C-1~C-6. 다음=④비소재 CPQ 축이동(B-3). | `_workspace/huni-dbmap/32_axis-staged-load/`{_corrected_xlsx(교정명세2)·_gate·_exec_category(backup·undo.sh·apply-log)·_backlog}·CLAUDE.md §7·[[dbmap-axis-staged-load-round22]] | 사용자(실 라이브 변경까지·둘 다 경로) |
| 2026-06-16 | **round-22 6축 기초데이터 staged 교정·적재 트랙 신설 — 방법론 설계 + v2 경로 판정** — 사용자 `/harness:harness`(기초코드·사이즈·도수·자재·공정·카테고리 6축 기준 상품마스터 단계별 라이브 적재 + 기존 매핑 오류 교정). Phase0 감사=기존 하네스 충분(신규 스킬 1개 `dbm-axis-staged-load`만 신설·신규 에이전트 0·6 에이전트 재사용). 인텐트 확정[축 우선 6축 종단·설계+검증+DRY-RUN까지·기존 재사용+오케스트레이션 신설]. domain-researcher(정답규칙)+correctness-auditor(오류진단) 병렬 → 방법론 2산출[`32_axis-staged-load/01·02`]. **6축=webadmin load_master 실제 적재단위**(SEED 기초코드→L1 5축 병렬→상품→연결행). 경계 충돌 15케이스 정답[별색=공정·색≠자재·두께=자재·UV=공정param·판걸이수=앱·출력판형=판형축]·FK 위상 5단계. **★발견 2[HARD]: ① P-TRUNCATE 재실행 가드**(load_master 6축 전부 TRUNCATE CASCADE 후 v03 무변환 재INSERT→가드 없으면 교정 무효·B-1 1순위) **② 착수 전 6축 라이브 전수 재실측**(부분 진화·진단 stale). 오류: ④자재 🔴·⑥카테고리 🔴(고아14노드113상품)·③도수 🟢. **★v2 경로 판정(03 적재경로 분석)**: load_master=무변환 전파기 → 6축 오류 진원 전부 ⓐ(입력 v03)·코드 결함 아님 → 교정 정답=**교정 입력 엑셀 재적재(경로 Y·근본·P-TRUNCATE 안전)** > 라이브 직접 SQL(경로 X·소멸). **webadmin 코드 수정 금지**(read-only·백로그 C-1~C-6)·권위=상품마스터/가격표·v03 배제. 경로 Y 3조건(시트/헤더 동일·행순/surrogate 보존·개발자 재적재). 04 재실측=오염자재행 가격사슬 0참조 안전. 우리 산출=교정엑셀+검증(X1~X6)+백로그·실 재적재=개발자 협업·인간 승인. | `.claude/skills/dbm-axis-staged-load/`(v2)·`huni-dbmap-orchestrator`(round-22)·`_workspace/huni-dbmap/32_axis-staged-load/`{01 정답규칙·02 오류진단·03 경로판정·04 재실측}·CLAUDE.md §7·[[dbmap-axis-staged-load-round22]] | 사용자(`/harness:harness` 6축 단계별 적재·매핑 교정·webadmin 경로) |
| 2026-06-15 | **아크릴 가격사슬 연결 설계+검증+DRY-RUN GO** — 사용자 `/harness:harness`(table-spec t_* 상품-가격 연결·가격표 ERD·아크릴 소재/후가공 라이브 확인·재사용 가격공식 생성). Phase0 감사=기존 하네스로 충분(신규 에이전트0). arbiter 정립→load-builder 실행본→validator R1~R6 GO 분리. **★발견: 라이브 부분 진화(round-16 stale)** — `PRF_CLR_ACRYL` 신설·`COMP_ACRYL_CLEAR3T`가 투명3T+1.5T를 mat_cd 통합(prc_typ .02·1.5T=3T×0.8)·`PRD_000146` 바인딩 2026-06-15 라이브 실재(검증자 독립실측 확정·wire-batch DRY-RUN 착각 아닌 실 부분 COMMIT 흔적)→투명 본체 이미 연결. **신설: 공식4(CLR실재+MIRROR/COROTTO/CARABINER 신규·매트릭스3+고정1)+comp2+배선3+바인딩18 멱등SQL·단가행 재적재0·골든 재현·DRY-RUN 멱등/FK고아0/제약위반0 GO.** 추가상품 귀속 제안(DB구조): 본체=component사슬·후가공=component합산(addtn_yn=Y)+CPQ노출(option_items에 add_price 컬럼 부재=가격은 항상 사슬)·addons/templates/template_prices=완제SKU전용(봉투 선례). BLOCKED: Q-ACR-7(.02 엔진계산법 미확정)·미러 바인딩 상품불명·코롯토/카라비너 단가행GAP. 실COMMIT=인간승인+webadmin Phase11 엔진 동시배포 선결(엔진 미구현=실청구0). | `31_acrylic-price-link/`{acrylic-chain-design·addon-attachment-proposal·confirms-and-gaps·_exec·_gate}·CLAUDE.md §7·[[dbmap-acrylic-price-chain-link]] | 사용자(`/harness:harness` 아크릴 가격연결) |
---

## 8. Harness: Huni-Admin-Manual (라이브 Django admin 운영자 사용 매뉴얼)

**목표:** 라이브 후니 Django admin(`huni-admin-production.up.railway.app/admin/`, `raw/webadmin` 소스·Railway DB)을 ① 소스 ② 라이브 DB ③ 실제 화면 3중 대조로 전수 분석하여, 비개발자 운영자가 상품·가격·옵션을 등록/수정하기 위한 **상세 사용 매뉴얼(전 화면 전수 + 실제 스크린샷 임베드 + step-by-step)** 을 5인 에이전트 팀(`ham-source-analyst` / `ham-db-verifier` / `ham-live-capturer` / `ham-manual-writer` / `ham-manual-qa`)으로 산출.

**트리거:** "admin 매뉴얼", "관리자 매뉴얼 작성", "webadmin 매뉴얼", "라이브 사이트 사용 설명서", "운영자 가이드", "admin 사용법 문서", "화면 캡처 매뉴얼", "매뉴얼 하네스 실행/재실행/업데이트/보완", "특정 화면만 매뉴얼", "캡처만 다시", "매뉴얼 검증" 등 본 도메인 요청 시 `huni-admin-manual-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**대상 구조(이중 레이어):** ① 표준 Django admin(Unfold 테마) — `catalog/admin.py`가 전 `t_*` 모델을 제너릭 ModelAdmin으로 자동 등록(모델별 목록 changelist/추가·수정 changeform, 자동채번·YN 드롭다운·트리 드롭다운·논리삭제). ② 커스텀 상품 뷰어 — `admin/`의 홈(상품 목록→상세→섹션편집), 옵션 드릴다운 3계층, SKU 템플릿 2계층, 제약 폼빌더+검증 미리보기, impact·sku-catalog standalone.

**산출물 루트:** `_workspace/huni-admin-manual/` (`01_source_*`·`02_db_*`·`03_capture_*`+`captures/`·`manual/`(11챕터)·`04_qa_*`·`site-src/`(MkDocs)).

**문서 발행:** 매뉴얼은 **Material for MkDocs**로 문서 사이트 발행(`ham-docs-publisher` + `huni-admin-docs-publish` 스킬). `site-src/`(mkdocs.yml·`build_docs.py` 정규화 빌드·requirements) + CI 워크플로 템플릿 `site-src/ci/docs.yml`(docs-as-code — 빌드·배포만 자동, 매뉴얼 재생성은 사람이 하네스로 트리거). **CI 활성화 시 `site-src/ci/docs.yml`을 레포 `.github/workflows/docs.yml`로 복사**(OAuth `workflow` scope 회피용 — git push가 `.github/workflows/`를 막으므로 템플릿으로 보관). 호스팅 연결(GitHub Pages)·webadmin(별도 레포 HuniProductPrice2) 배포 연동은 인간 승인. `site-src/{docs,site,.venv}`는 빌드 생성물로 gitignore.

**자격증명/안전:** 라이브 운영 DB — DB는 `.env.local` `RAILWAY_DB_*`로 읽기전용 SELECT만, 라이브 화면은 `.env.local` `HUNI_ADMIN_*`로 읽기 탐색만(저장/삭제 클릭 금지). 비밀값은 `_workspace`(git 추적)·stdout·스크린샷에 비노출.

**변경 이력 (최근 3건):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-10 | **라이브 재대조 갱신 — 0 드리프트·QA Low 3건 해소 확인** — 사용자 "admin 매뉴얼 업데이트"(라이브 재대조 후 반영). `ham-db-verifier`(DB 읽기전용 60+셀 재실측)+`ham-live-capturer`(gstack 14화면 재대조) 병렬 → **드리프트 0건**(코드값·행수·시각 전수 MATCH). CPQ 옵션 레이어(silsa `option_items` 18행)는 `02_db`가 round-9 적재(06-08~09) **이후** 캡처라 정합(빈→적재 드리프트 가설 거짓). QA 게이트가 미보정으로 남긴 Low 3건(L-1 7→8종·L-2 `use_yn` 필수·L-3 `print_side` 자유텍스트)은 작가가 게이트 직후(07:02) 이미 보정 완료 + 라이브 권위로 CONFIRMED → `04_qa` §0.5 재검증 갱신·미보정 0. **매뉴얼 본문·캡처·사이트 무변경**(정합 재확인). 교훈: 게이트 리포트는 보정 전 시점이라 stale 가능 → 매뉴얼 본문이 권위 | `_workspace/huni-admin-manual/{05_reverify_db-drift,05_reverify_capture-drift,04_qa_manual-gate}`·CLAUDE.md §8 | 사용자(라이브 재대조 후 반영) |
| 2026-06-10 | **문서 시스템 연동 보강 — Material for MkDocs 발행 트랙(docs-as-code)** — 베스트프랙티스 리서치(MkDocs Material vs Sphinx/Docusaurus/Nextra → Python·순수 Markdown·운영자 가이드에 MkDocs Material 최적) 후 6번째 에이전트 `ham-docs-publisher` + 스킬 `huni-admin-docs-publish` 추가. `site-src/`(mkdocs.yml·`build_docs.py` 정규화 빌드·requirements·README) + `.github/workflows/docs.yml`(push→build→Pages, 빌드·배포만 자동). 로컬 `mkdocs build --strict` 통과(11페이지·41이미지·깨진링크0). 자동화는 빌드·배포만(매뉴얼 재생성은 사람이 하네스 트리거)·호스팅 연결(Pages)·webadmin 연동은 인간 승인 | `.claude/agents/huni-admin-manual/ham-docs-publisher`·`.claude/skills/huni-admin-docs-publish`·`_workspace/huni-admin-manual/site-src/`·`.github/workflows/docs.yml`·오케스트레이터·`.gitignore`·CLAUDE.md §8 | 사용자(문서 시스템 연동·코드 배포 시 매뉴얼 자동 발행) |
| 2026-06-10 | 하네스 초기 구성 + 매뉴얼 산출 — 5인 팀(source-analyst·db-verifier·live-capturer·manual-writer·manual-qa) + 스킬 4종. 소스 이중 레이어(표준 admin + 상품뷰어) 파악, 3중 대조(소스맵·DB코드값72·캡처41) → 운영자 매뉴얼 11챕터·1296줄(스크린샷28)·QA GO(커버리지26/26 누락0) | `.claude/agents/huni-admin-manual/`·`.claude/skills/huni-admin-{manual-orchestrator,source-map,live-capture,manual-authoring}`·`_workspace/huni-admin-manual/`·CLAUDE.md §8, 커밋 486a54f | 사용자(라이브 admin 사용 매뉴얼 작성 하네스 구축) |

---

## 9. Harness: Print-KB Wiki (LLM 레시피 위키)

**목표:** 전 하네스 산출물(huni-dbmap·huni-widget·print-quote·huni-admin-manual·docs/huni·raw/webadmin)을 원천으로, `_workspace/print-kb/wiki/`(Karpathy 모델, 기존 스키마 계승)에 **상품군(11시트) 단위 레시피 페이지**(정체→차원→자재/공정 BOM→가격공식 사슬→CPQ 옵션→위젯 계약→webadmin 적재 경로→결함 현황)와 횡단 축 페이지 6종을 집필한다. 페이지 뼈대=라이브 DB 스키마(t_*·webadmin) 기준. 4인 에이전트(`pkw-source-curator` 원천 큐레이션·stale 등급 / `pkw-researcher` 방법론+검증 리서치 / `pkw-recipe-writer` 집필 / `pkw-wiki-qa` W1~W8 게이트). 목적: 미래 LLM 세션이 위키만 읽고 인쇄상품을 빠르게 조립(정의→DB 등록→가격→위젯).

**트리거:** "LLM 위키", "kapasy/karpathy 위키", "레시피 위키", "상품 레시피 페이지", "위키 구축/집필/확장/업데이트/보완", "print-kb", "특정 상품군만 위키", "위키 검증/lint", "큐레이션 다시" 등 본 도메인 요청 시 `print-kb-wiki-orchestrator` 스킬을 사용. 위키 내용 단순 조회는 `wiki/index.md`부터 직접.

**핵심 규칙:** STALE/v03 인용 금지(큐레이션 팩 freshness 권위=round-14 진단) · 라이브 오적재(round-13)는 "현재값 vs 정답" 양면 표기 · 생성자≠검증자 · 모든 블록 출처+badge 필수.

**변경 이력 (최근 3건):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-12 | 하네스 초기 구성 — 4 에이전트 + 3 스킬(orchestrator·recipe-authoring·wiki-evaluation). 기존 print-kb 위키(정책 파일럿) 확장 결정·레시피 단위=상품군·원천=전 하네스 산출물·리서치=방법론+검증 이중 역할(사용자 확정 4건) | `.claude/agents/print-kb/`·`.claude/skills/{print-kb-wiki-orchestrator,pkw-recipe-authoring,pkw-wiki-evaluation}`·CLAUDE.md §9 | 사용자(`/harness:harness` — kapasy LLM wiki 제작) |

---

## 10. Harness: Huni-Project-Plan (프로젝트 일정관리 통합 IA 문서)

**목표:** 후니프린팅 리뉴얼(Classic ASP→신규)의 **프로젝트 일정관리 통합 IA 문서(엑셀)**를 산출·갱신. 후니에서 논의된 IA·정책이 권위이며, 위젯·에디쿠스(레드 역공학)·주문→생산(MES) 흐름·Shopby 표준 갭·라이브 DB 실측을 반영해 실무진용 일정관리 엑셀(역할·담당자·주차 병렬일정·고객 준비물·외부계약·개발자 상세)을 만든다. 실제 기능목록 권위(가상 창작 금지)·쉬운 말+용어집·주차 상대일정(날짜 날조 금지)·쇼핑개발(김동학 1명) 병목→AI 병행 가속.

**트리거:** "프로젝트 일정관리 문서", "일정관리 IA", "통합 IA 일정", "일정표 작성", "역할분담 문서", "페이즈 일정", "단계배치", "일정관리 다시/업데이트/보완", "위젯 기능목록 일정", "MES 흐름 일정", "고객 준비물 정리", "huni-project-plan" 등 본 도메인 요청 시 `huni-project-plan-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-project-plan/` (01_research·02_synthesis·03_build·04_qa). 최종=`docs/huni/후니프린팅_프로젝트일정관리_통합IA_*.xlsx`(11시트). 에이전트=`hpp-ia-curator`·`hpp-xlsx-builder`·`hpp-plan-qa`(+콘텐츠 수집은 `hw-reverse-engineer`/`dbm-schema-analyst`/`pq-researcher` 재사용).

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-16 | 하네스 초기 구성 + 일정관리 엑셀 산출 — 경량 하네스(신규 에이전트 3 + 오케스트레이터 1·기존 hw/dbm/pq 재사용). 입력 IA 144기능 → **보강 162기능**(Shopby 표준 갭·주문 런타임·MES 생산브릿지 18행) + 신규 6시트(위젯·에디쿠스 22기능·주문→MES 안밖·고객준비물/최숙진실장·외부계약14·용어집·개발자상세). 실측 근거: 위젯 역공학·라이브 DB(주문 런타임 0개·MES_ITEM_CD 16/275)·Shopby OpenAPI. 주차 상대일정+병렬 레인+병목(쇼핑 공수 2배). 독립 QA Q1~Q5 GO(High 0·가상기능 0·집계 정합·비밀값 노출 0) | `.claude/agents/huni-project-plan/`·`.claude/skills/huni-project-plan-orchestrator`·`_workspace/huni-project-plan/`·CLAUDE.md §10 | 사용자(`/harness:harness` — 프로젝트 일정관리 문서) |

---

## 11. Harness: Huni-RP-Meta (RedPrinting 옵션 관리 메타모델 → 후니 기초데이터 관리 그릇 설계)

**목표:** RedPrinting 라이브(redprinting.co.kr, 479상품/26카테고리)의 주문옵션 구성을 **대표 샘플**로 역공학하여 "옵션 관리 메타모델"(자재/공정/옵션/템플릿/제약/기초코드/카테고리 + **추가 발굴 축**)을 도출하고, 후니 실제 t_* 현황과 갭 분석한 뒤, 후니에 필요한 기초데이터 관리 **"그릇"(스키마/관리축)**을 설계 제안한다. RedPrinting은 사용자 본인 설계 시스템이므로 검증된 참조 모델로 흡수(답습 아님). 위젯 구현 역공학(huni-widget)·후니 t_* 실 적재/매핑(huni-dbmap)과 별개의 **메타모델 발굴·그릇 설계 전용** 하네스.

**트리거:** "레드프린팅 옵션 분석", "RP 메타모델", "옵션 관리 메타모델", "기초데이터 관리 체계/그릇", "자재 공정 옵션 관리 그릇", "관리 메타모델 발굴", "RedPrinting 벤치마크 메타모델", "후니 기초데이터 그릇 설계", "현수막 옵션 구성 분석", "RP-Meta 하네스 실행/재실행/업데이트/보완", "특정 상품군만 메타모델" 등 본 도메인 요청 시 `huni-rpmeta-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-rpmeta/` (01_reverse·02_metamodel·03_gap·04_vessel·05_validation). 에이전트=`rpm-reverse-engineer`·`rpm-metamodel-architect`·`rpm-gap-analyst`·`rpm-vessel-designer`·`rpm-validator`(+재사용 `dbm-schema-analyst`/`dbm-ddl-proposer`/`dbm-domain-researcher`).

**핵심 결정:** ① 대표샘플→메타모델→확대(전수수집 금지) ② 7버킷 외 **추가 메타모델 심층 발굴**이 핵심 directive ③ 라이브 읽기전용(주문/POST 금지) ④ **DB 미적재 — 그릇=설계 제안, 실 적용 인간 승인**(search-before-mint·정규화·컨벤션 정합) ⑤ RedPrinting 모델은 흡수하되 naming/codes는 후니로 유입 금지 ⑥ 생성≠검증(M1~M6 게이트).

**변경 이력 (최근 3건):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-17 | **굿즈(GS) 확장 종단 완주 — M1~M6 전체 GO** — 사용자 "굿즈 갭분석". GS 대표 12종 역공학(재사용67% s3 GS캡처+라이브33%·신규Vue SSR미노출=catalog/unobserved 정직) → 메타모델 **13→15축**(GS 신축 distinct 2: **#14 본체형태가공**[조립/지퍼/봉제·평면→입체 생성]·**#15 생산형태**[완제/반제/기성/디자인·카테고리와 직교 governing]; facet 강등 4: 완제본체SKU=자재축facet·소재pdtCode분리·variant3채널·기종enum) → 굿즈 갭(PASS5·WEAK7·GAP3) → 그릇 설계(실신규 2=코드행/컬럼·**신규테이블 mint 0**) → validator GO(NO-GO0·D-3 Low 이미교정). **★핵심 발견: 굿즈 본체자재 결함의 스키마 진원 = vessel-gap(데이터 미적재 아님)** — `t_mat_materials`에 물리치수만, RP body_color/capacity/thickness 분해축 컬럼 부재 → 소재/색/용량이 상품명 의존 고착(round-22 "본체소재 0개"의 진짜 원인). **★MAT_TYPE.09 "파우치"·.10 "악세사리"=자재유형을 상품군명으로 만든 vessel-level 오라벨**(112행 비자재·84상품 BOM load-bearing→단순 재명명 금지·목적지 선행·use_yn=N 마지막·dbmap B-3 강결합). #15는 라이브 `semi_role_cd`(28행) 발견으로 "신규 불요" 재분류(후니 표현력이 추정보다 좋음). 실 적용 인간 승인·행 교정은 dbmap 트랙 | `_workspace/huni-rpmeta/`(01~05 GS 확장)·CLAUDE.md §11·[[huni-rpmeta-harness]] | 사용자(굿즈 갭분석) |
| 2026-06-17 | **현수막(BN) 파일럿 종단 완주 — M1~M6 전체 GO** — BN 대표 6종 역공학(재사용33%+SSR라이브67%·chrome MCP 미주입/BFF API 인증차단·상품HTML GET만 가능) → **옵션 관리 메타모델 13축 도출**(7정적+발굴 7 distinct: D-1부속물·D-2자재합성&공정결합·D-3제약6유형[force=disable역방향]·D-4공정파라미터·D-5수량모델·D-6가격기여역할·D-7인쇄방식레시피·D-8 UI런타임 facet강등) → 후니 갭(PASS5·WEAK6·GAP2) → 그릇 설계(**실그릇 3=코드행/컬럼만·신규테이블 mint 0**+재분류5) → validator M1~M6 GO(NO-GO0). **★라이브 재실측이 dbmap 스냅샷 stale 정정: option_items 0→469·groups 13→134·constraints 0→10·comp_prices 0→3,416·카테고리고아 0(round-22 반영)** → data-gap 대부분 닫힘·본 하네스=vessel-gap만. **★RP MTRL_CD 합성코드=후니 자재오염(MAT_TYPE.08~10=129행) 정답모델·SUB_MTRL_YN=후니 옵션=자재+공정 BUNDLE 동형·제약6유형=CPQ logic JSONLogic 대응.** open decision 5(인쇄방식 1급화·본체색 목적지 등)·실 적용 인간 승인 | `_workspace/huni-rpmeta/`(01_reverse~05_validation)·CLAUDE.md §11·[[huni-rpmeta-harness]] | 사용자(현수막 파일럿 먼저 실행) |
| 2026-06-17 | 하네스 초기 구성 — 5인 팀(rpm-reverse-engineer·metamodel-architect·gap-analyst·vessel-designer·validator) + 스킬 4종(rpm-live-reverse·rpm-metamodel-design·rpm-gap-vessel·rpm-validation) + 오케스트레이터. RedPrinting 옵션 구성 역공학(base-data 렌즈)→메타모델 발굴(7버킷+추가축)→후니 갭(PASS/WEAK/GAP)→그릇 설계(search-before-mint) 파이프라인. dbm-* 3 에이전트 재사용. 라이브 읽기전용·DB 미적재 | `.claude/agents/huni-rpmeta/`·`.claude/skills/{rpm-live-reverse,rpm-metamodel-design,rpm-gap-vessel,rpm-validation,huni-rpmeta-orchestrator}`·CLAUDE.md §11 | 사용자(`/harness:harness` — RedPrinting 메타모델로 후니 기초데이터 관리 그릇 만들기) |

---

## 12. MoAI Framework (gated — rarely used here)

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
