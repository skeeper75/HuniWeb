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
| 2026-06-18 | **round-24 상품마스터 MAP 시트(고객 카테고리 IA) 검증 + 카테고리-상품 매핑 — 검증 GO·DB 미적재** — 사용자 `/harness:harness`. 신규 트랙(에이전트 2 `dbm-category-auditor`/`dbm-category-mapper` + 스킬 2 `dbm-category-audit`/`dbm-category-mapping`). **1단계(MAP 검증·출시상태 3분류)**: MAP 시트=고객 카테고리 IA(12 1차 카테고리 × ▶︎하위 × 상품 × →별칭, 321 엔트리). **★MAP 12 1차 = 라이브 t_cat_categories L1 활성 12(CAT_000001~012) 1:1 정합**(IA 골격 건전). 244 MAP 상품 출시상태 3분류(권위=라이브 DB 적재+데이터시트 교차) = **✅정상등록가능 36·🟡옵션부족 197·❌미출시 11**. ★🟡 지배는 매칭오류 아닌 라이브 실상(opt_items>0 36·priced 76·둘다 36 — round-7 옵션 전역미적재/round-16·18 가격사슬 단절 정합). MAP-only 12(명명변형 실존 5·포토북 variant 3·진짜부재 4)·Sheet-only 18(폰케이스·★신규 에어팟/버즈케이스=고객노출 누락후보). **2단계(카테고리-상품 매핑 명세)**: 레이어A 노드매핑(재사용 66·**신규 mint 0**·search-before-mint 통과·라이브 논리삭제 240노드[del_yn=Y]는 round-22 ⑥ 정합 정리라우팅만) + 레이어B prd_cd→cat_cd 귀속(연결=junction `t_prd_product_categories`(prd_cd,cat_cd) PK·본체 230+별칭 18=**248행**·다중분류 18·prd_cd당 main_cat_yn=Y 단일). **★생성≠검증: dbm-validator 1차 NO-GO(BLOCKER 2[junction PK충돌 8쌍·del='Y' CAT_000066 활성 target]·MAJOR 2[substring 과매칭 4건 phantom·false-negative 5건])→보정 폐루프→재게이트 V1~V6 전건 GO**(PK충돌 0·main_cat_yn 단일성 위반 0·del='Y' 귀속 0·날조 0·신규 mint 0). 교훈: partial 매칭은 라이브 prd_nm 1:1 검증 후 승인(substring 과매칭 가드). 컨펌큐(variant 바인딩·부재 4 신규정의·Sheet-only IA 노출). **★✅완비 36건 라이브 COMMIT 완료(사용자 승인)**: junction `t_prd_product_categories` DELETE26[del='Y' orphan 정리·활성 오삭제0]·UPDATE4[엽서3·전단지1 가변계층 대표 L1→L2 이동·main 플래그만]·UPSERT36·사후검증 V1~V5 GO(main단일성위반0·del='Y'귀속0·FK고아0·멱등 delta0)·백업 `bak_pc_green_20260618_1322`(39행)·undo 보유. **★설계철학=상품군별 가변 계층 깊이**(포토북류 L3·신규 mint 0=기존 활성노드 재사용). 🟡옵션부족 197·❌미출시 11 보류. **★[기준 정정·재분류 v2 — 사용자 피드백] 출시상태 판정 권위=라이브 적재→원천(상품마스터+가격표) 분석으로 전환**(라이브 미적재를 출시결격으로 오판한 게 1차 오류). "옵션부족"=옵션 개수 아닌 **가격/견적 계산 불가(필수입력 결손)**. dbm-price-arbiter 원천 가격계산 성립 판정(QUOTABLE 222·NOT-QUOTABLE 0) → 재판정 **✅222(기존36+격상186)·🟡0·🟦보류11(NEEDS-DOMAIN: 아크릴완제품6·굿즈가격공란4·트레싱지봉투1)·❌11**. 진짜 옵션부족=0. **★격상 183건(distinct) 카테고리 junction 라이브 COMMIT 완료**(DELETE87[del='Y' orphan]·UPDATE58[main강등]·UPSERT200·R1~R7 GO·백업 `bak_prd_cat_round24_after_20260618_1405`[356행]). ★사건: 검증 중 apply SQL 내장 BEGIN/COMMIT으로 비인가 COMMIT 발생→데이터 정합(R1~R7 GO) 확인 후 사용자 사후승인(accept)·재발방지 가드 스킬 박제(dryrun/apply 분리·물리백업 필수). 🟦보류11·❌11 인간 컨펌 큐 | `_workspace/huni-dbmap/35_category-map/`(01~07·_gate·_live·_meta·scripts)·`.claude/agents/huni-dbmap/dbm-category-{auditor,mapper}`·`.claude/skills/dbm-category-{audit,mapping}`·CLAUDE.md §7 | 사용자(`/harness:harness` MAP 카테고리 분류 검증 + 카테고리-상품 매핑) |
| 2026-06-18 | **실사 동형 가격테이블 결합 + 가격구성요소 네이밍 표준화 — 라이브 COMMIT** — `/harness:harness` 2건·생성≠검증·실 COMMIT(사용자 최종승인). **[실사 동형 결합] UPDATE19·INSERT/DELETE0**: 실사 본체 면적매트릭스 13 comp 중 단가 **byte-identical(전컬럼 md5/셀diff) 2그룹만** 결합→**13→7**. 그룹A 정본 `COMP_POSTER_CANVAS_FABRIC`←레더/메쉬/타이벡·그룹B 정본 `COMP_POSTER_ARTPRINT_PHOTO`(PRF_POSTER_FIXED 보유)←방수PVC/아트패브릭/방수PET. 배선재지정6+레거시 use_yn=N6+comp_nm/note7·**단가행 보존·가격불변**(골든A37,800·B21,600). 단독5(일반현수막·린넨·접착투명·메쉬현수막·아트페이퍼) 결합금지(단가상이·ARTPAPER 26좌표공유했으나 범위달라 정당). ★교훈: 동형=byte-identical만(행수같아도 단가다르면 금지). **[네이밍 표준화] UPDATE111**(comp_nm110·note2·comp_typ1)·INSERT/DELETE0: comp_nm **코드노출102→0**(빈더미2제외)·실무진 표준 한글용어+변별자. **★네이밍 권위순서=후니프린팅 레거시(huniprinting.com·buysangsang) 최우선→라이브 DB→rpmeta(RP흡수·naming유입금지)→인쇄표준**. 후니 고유상품(스탠다드/화이트인쇄[큐리어스스킨]/펄[스타드림]/오리지널박명함·떡메모지·합판도무송·큐방). 컨펌해소(큐방·열재단PROC_000084·봉미싱·귀돌이비·각목+끈). 가격행7293·use_yn무변경·멱등. 전 admin 18메뉴 캡처(admin/test1234·드리프트=커스텀 마스터-디테일). 양트랙 R1~R6 GO·undo 보유. 빈더미2 별도트랙 | `33_silsa-price-quote/_exec_isomorph`·`34_naming-standardization/`{_exec_naming·_gate·live-capture}·CLAUDE.md §7·[[dbmap-price-component-grouping]]·[[dbmap-naming-standardization]] | 사용자(`/harness:harness` 실사 동형 결합·네이밍 표준화) |
| 2026-06-17 | **round-23 후속 — 린넨 가공옵션·아크릴 동형/마무리·스티커 라이브 COMMIT** — 사용자 "린넨페브릭포스터 가공옵션 등록+가격, 아크릴 동형 확장, 아크릴 마무리하고 스티커로". 두 트랙 생성≠검증·실 COMMIT(사용자 최종승인). **린넨(PRD_000124) 마감가공 5택1 INSERT 10**(오버로크0·+리본끈800·말아박기1000·+면끈2000·봉미싱7cm2000·단가 verbatim·복합 OPV-000024 재사용/OPV_000424 신규·add-on comp `COMP_POSTEROPT_LINEN_FINISH` use_dims[opt_cd]+단가행5+`PRF_POSTER_LINEN` 배선·트리거 fn_chk_opt_item_ref 통과·골든 본체32,400+가산). **아크릴 동형 217셀**(A1 siz_cd→siz_width/height 전환121·A2 GAP verbatim96·use_dims2·배선1·**★work금지 siz_nm파싱 W앞·두께 mat_cd 직교**·골든30×30 3T3100/1.5T2480[×0.8]·채번0·off-grid ceiling). 사후검증 GO(단가verbatim·골든·채번0·FK고아0). **BLOCKED(미COMMIT)**: 아크릴 .02 엔진계약(Q-ACR-7)·미러 바인딩·코롯토/카라비너 신설. undo round-trip diff0 보유. 교훈: option_items에 dflt_yn 부재(L5 no-op). **[아크릴 마무리] ★A5 긴급보정(이미 COMMIT된 결함): CLEAR3T(.02 합가형) 81행 min_qty NULL→엔진 ÷min_qty ValueError 견적불가→min_qty=1(골든 불변)·교훈 .02는 min_qty 필수**+코롯토 comp신설(B06 verbatim·채번0)·미러/카라비너 BLOCKED. **[스티커 항목7] 405행: 소재4미적재288(그룹단가→mat_cd 개별전개)·투명 오매핑 170→162 교정90(과교정0)·판형 B3/B4 24·바인딩3. ★스티커 판형=이산 siz_cd(명시규격·신안 가로세로구간 제외 반례)**. 사후검증 GO(견적불가0·170잔존0·소재288·코롯토21). **[별색 dedup] 형제 9 comp(COMP_PRINT_SPOT_ CLEAR/GOLD/PINK/SILVER S1·S2+WHITE_S2) use_yn=N+배선제거37→정본 WHITE_S1 "별색인쇄비"(5색 proc×2면 통합·단가행 보존·재적재0). [스티커SB] 타투(.02 min_qty3)·팩교정(.01→.02 min_qty54)·채번 SIZ_000518/519+B01 504. [미싱 dangling] PERF_2L/3L 레거시 배선 DELETE4(정본 PERF_1L 보존·가격불변·교훈 use_yn=N 시 배선도 제거). 사후검증 GO(dangling0·형제9 N·채번2). **[스티커 명명/매칭 정정+062/063 COMMIT] ★"반칼변형"=우리 명명 폐기→실제 반칼원형/정사각/직사각/띠지/팬시062/팬시투명063/소량자유형064. ★반칼 형상=칼틀(도무송·가격축 아님·같은 사이즈/소재 동일가)→062/063만 가격연결(PRF_STK_FIXED 바인딩2·가격행0·골든5900/7000). 058~061·064 BLOCKED=등록 siz↔가격표 B01 불일치(근본 매핑결함·round-13). ★실무자 코멘트 "국4절 인쇄 아니라 판걸이수 무관"=생산방식(임포지션vs개별출력) 분기. 카라비너(166) 분석완료·등록0(형상4=가격축·고리색 가격표10종 무료직교·비활성 보류)·미러 보류. 타투 3장당4000 적재·1~2장2000=주문정책+고정가 설계 필요(미해소)**. **[058~061 적재 COMMIT] 심층이 siz불일치 의심 반증(A5/A4=마스터 정답·형상=칼선조각수). B01 A5(=124x186 동일가)·A4 단가 적재+바인딩4. ★돈크리티컬 A4 분리: 058~061 A4가 완칼낱장 SIZ_172 공유→반칼전용 SIZ_000520 채번+교정+B01 col2 5000 적재(낱장4000 오청구 회피·SIZ_172 무접촉). 064만 진짜 BLOCKED(소형반칼 가격표 부재). 교훈: 같은 치수라도 가공별 가격 다르면 siz_cd 분리**. **[064 잠정 적재+스티커 완결] ★규칙[HARD·사용자] "(완칼)" 미명시=기본 반칼→B01 귀속(전체 재분류 오매핑0). 064 소량자유형=반칼·소재 B01 col1까지 풀렸으나 소형7사이즈 단가 부재→사용자 "우선 B01 규격가 동일 적용·추후변경"→1260 단가행(SIZ_059 verbatim 복사·사이즈무관·전건 [잠정] note)+바인딩. 스티커 052~067 16상품 가격사슬 완결(064 잠정)**. BLOCKED 잔여=064 실측단가(추후)·타투 1~2장·카라비너 채번·미러 | `_workspace/huni-dbmap/33_silsa-price-quote/`{`_exec_*`(linen·acrylic·acrylic2·sticker·sticker2·balsaek·perf_dangling·bankal)·정립md·_gate}·CLAUDE.md §7·[[dbmap-area-matrix-wh-dimension]] | 사용자(린넨·아크릴·스티커·별색·반칼·카라비너) |---

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
| 2026-06-19 | **하네스 강화 — codex 게이트 교차검증 레인 신설(Phase 6.5) + FS 패브릭 종단 GO** — 사용자 `/harness:harness` "다음 카테고리군부터 + codex cli로 검증 한 번 더". **[확장] 신규 에이전트 `rpm-codex-validator` + 스킬 `rpm-codex-validate` — rpm-validator(Claude)의 M1~M6·distinct 승격/부결 결론을 codex(gpt-5.5)로 독립 재판정 후 reconcile(Phase 6.5·8인 팀). ★deepcheck(누락 발굴)와 구분=결론 검증 · ★독립성[HARD] codex에 우리 verdict 비노출(echo 방지)·workdir 격리 · codex 판정=가설(환각 경계·자동 flip 금지·라이브 우선). 형제 하네스(§15/§16/§17 codex 교차검증) 패턴 정합·codex-review.sh/preflight 재사용.** **[FS 실행] 패브릭 21상품 10번째 카테고리 종단: reverse(라이브 SSR 5상품)→타일링(TILL_WH_GBN) #18 부결(①전용슬롯 충족·②KB 무왜곡흡수불가 불충족·prcs_dtl_opt jsonb 흡수·★타일링≠판걸이수[고객입력 vs 앱계산])→deepcheck codex가 패널구성(cut-and-sew) 강도전 제기→환류 적대검증 부결(①UNOBSERVED·면별 디자인 슬롯 0)→M1~M6 전건 GO·라이브 7건 일치→Phase 6.5 codex 독립 ABSORBED 전건 합의·divergence 0=고신뢰 확정. distinct 0·17축 재포화·신규 vessel 0(V-11/V-12 불변·search-before-mint 10연속). 상품 커버리지 79%.** **[NC 실행·선별 진행] [옵셋] 명함·쿠폰·포토카드 9상품 11번째 종단(81%·M1~M6 GO + Phase 6.5 codex 7/7 합의·divergence 0): ★선별 모드 핵심 프로브=인쇄방식(옵셋 vs 디지털) #18 부결 — 별도 가격엔진(offset2023_price)·자재종속 이산 부수 tier·옵셋전용 자재풀·item_gbn 토큰까지 가진 최강 #18 후보조차 부결. ★인쇄방식은 새 축 아니라 이미 #12(생산레시피/게이팅 축·BN v2.0 등재)·NC=4번째 토큰 인코딩. 이산 부수 tier=수량#10 이산모드 표현력 data-gap(vessel-gap 아님). dbmap `print-method-not-absolute-axis`("인쇄방식≠절대축")와 같은 결론·다른 렌즈. codex가 인쇄방식 #18 부결·합판터잡기=앱계산 독립 동의. ★Phase 6.5 정식 에이전트 실증(FS는 인라인·NC는 rpm-codex-validator 직접·codex `/tmp` trusted-dir 미인정→`--skip-git-repo-check`+stdin 우회).** **[OT 실행·선별 진행] 상자·패키징 7상품 12번째 종단(82%·M1~M6 GO + Phase 6.5 codex 전10항 합의): ★전개도/dieline #18 부결 — 평면 인쇄물에 전무했던 입체/전개/접합 차원의 첫 상품군조차 ①전용슬롯조차 부재(박스 옵션=평면 인쇄물 100% 동형). 전개도=사이즈#13(work/cut 8컬럼 실보유·66행 work≠cut)+공정#2(도무송/오시)+카테고리#7 무왜곡 흡수·3D치수=앱계산 파생(미저장). ★형태가공#14 음의사례 확정(박스 조립=고객 수작업=#14 정반대). codex 전개도 #18 부결 독립 동의(12번째 외부 재포화)·makers gcs 미해석 fabrication 경계까지 독립 일치.** **[PO 실행·선별 진행] 포맥스·폼보드·등신대 7상품 13번째 종단(84%·M1~M6 GO + Phase 6.5 codex 6/6 합의): ★기재마운팅/자립구조 #18 부결 — 제작방식(합지 vs 직접출력)=인쇄방식#12 5번째 인코딩(NC 동형·①전용슬롯 부재·합지=라미 게이팅 멤버)·자립구조(등신대 거치대 CDL_DFT/피켓)=형상#17 모양재단+부속물#8 거치대(★`t_prd_product_addons.tmpl_cd`→독립 SKU·PRD_000016 5개 SKU 다중귀속 PASS). ★7상품 전부 레거시 SSR 완전노출→관측 기반 부결(PH client-render 판정불가와 대조). codex 독립 "18번째 축 불필요"+overfit 경고·construction_route 자인 부결. 최강 잔여 #18 후보 3종(인쇄방식·전개도·기재마운팅) 전부 재포화로 수렴.** ★교훈: codex-review.sh 내부 preflight 백그라운드 행(exit 144·timeout 미설치 exit 127)→`codex exec -m gpt-5.5 --sandbox read-only --output-last-message` foreground 직접 호출 우회. 신규 에이전트는 생성 세션 레지스트리 미반영(다음 호출부터 사용 가능). | `.claude/agents/huni-rpmeta/rpm-codex-validator`·`.claude/skills/rpm-codex-validate`·`huni-rpmeta-orchestrator`(Phase 6.5·8인)·`_workspace/huni-rpmeta/categories/{FS,NC,OT,PO}/`·`05_validation/{mgate-verdict,codex-reconcile}-{FS,NC,OT,PO}`·CLAUDE.md §11·[[huni-rpmeta-harness]] | 사용자(`/harness:harness` codex 검증 레인 + FS·NC·OT·PO 선별 진행) |
| 2026-06-17 | **PH(포토보드·액자·사진인화) 종단 GO — gstack client-render 재캡처로 마운팅 블로커 해소·distinct #18 부결·17축 재포화(9번째)** — 사용자 "핸드오프 후 PH 재개"(reverse 완료·metamodel부터). chrome MCP 미등록이나 **gstack browse 헤드리스 chromium으로 Vue client-render 실측 성공** → §0.2 미싱데이터(마운팅/거치) 해소: PHFRDIA 디아섹 액자 거치(탁상용/벽걸이) 토글이 **캐스케이드 상위 차원**(거치→마감→완제SKU사이즈→수량)으로 OBSERVED·사진인화 인화지×마감 합성·[재고부족]홀로그램 disabled 제약 입증. **★재캡처가 헛되지 않음: 거치 OBSERVED(✅)에도 후니 KB "기존 축 못담음" 결함 없음(❌·옵션 일반 cascade가 무왜곡 흡수)→HARD ②불충족→distinct #18 부결이 "판정불가"에서 "관측 기반 부결"로 격상**(ST 형상#17 둘다 충족·승격과 결정적 분기). gap PASS3·WEAK3·GAP0·신규 vessel 0(거치=option_groups 134/items 469·완제SKU=templates 12·다중분류 8상품 라이브 실재). codex(gpt-5.5)도 #18 부결 독립 동의(9번째)·HIGH 후보 3(매팅/aperture/glazing)=전부 unobserved-pending·mint 0. **M1~M6 전건 GO·validator 라이브 14건 byte 일치(날조 0).** | `_workspace/huni-rpmeta/categories/PH/{reverse §0.5,summary,deepcheck,viz}`·02~05 v9.0·`05_validation/mgate-verdict-PH.md`·HANDOFF.md·CLAUDE.md §11·[[huni-rpmeta-harness]] | 사용자(핸드오프 후 PH 재개·gstack 재캡처) |
| 2026-06-17 | **PR·ST·CL·AC·PD 5개 카테고리 종단 + PH reverse — 16→17축 수렴 입증** — 사용자 "다음 카테고리 분석"→연속 5개 종단(PR 인쇄물56·ST 스티커36·CL 의류30·AC 아크릴20·PD 스툴/구조물3)+PH reverse(API 529 중단·metamodel부터 재개). **ST가 #17 "형상(shape)" distinct 승격**(전용 shape_info 슬롯 실재+후니 KB G-SK-2 "형상 어느 축에도 없음" 결함→그릇 V-12 SHAPE base_code6+컬럼2·테이블0). 나머지 **PR/CL/AC/PD = distinct 0 재포화**(의류 variant·가공방식그룹핑 A-8·codex layer-stack D-13·완제 내재BOM PD-4 등 최강 #18 후보 적대 검증 전부 부결). ★수렴: 16축 4카테고리 안정→ST 1개 승격→3 연속 재포화·codex도 #18 부결 독립 동의(상품 68%). **★승격/부결 일관 기준[HARD]: 전용 슬롯 라이브 실재+KB 결함 둘 다→승격·기존 축이 왜곡없이 담음→부결("외형 이질" 아님). ★vessel-gap(축 부재·신규 그릇·ST 형상 V-12) vs data-gap(축 있으나 미적재·dbmap 트랙·PD-4 addons/usage 그릇 실재)=라이브 그릇 실재 여부로 판별.** 신규 테이블 mint=V-11 TemplateAsset·V-12 SHAPE 2건만(나머지 facet 컬럼/코드행 흡수·search-before-mint 8연속 통과). M1~M6 전건 GO·Low 정정(PD D-PD-2만 open). PH=액자/사진인화 라이브 전부 SSR-negative로 마운팅/거치/전면유리 미관측=#18 판정 미싱데이터(라이브 재캡처 또는 후니 도메인 권위 필요). | `_workspace/huni-rpmeta/categories/{PR,ST,CL,AC,PD,PH}/`·02~05 v8.0 extend·`04_vessel/vessel-shape-axis.md`·`11_ddl_proposals/ddl-proposal-shape-axis.sql`·HANDOFF.md·CLAUDE.md §11·[[huni-rpmeta-harness]] | 사용자(다음 카테고리 분석·계속·선별 진행) |
---

## 12. Harness: Huni-Basecode-Governance (기초코드 등록 거버넌스)

**목표:** 후니프린팅 기초코드(자재·사이즈·도수·인쇄옵션·공정·기초코드+카테고리)를 개선/보완/수정하기 위해, **rpmeta 그릇 처방(vessel-gap)** + **dbmap 데이터 진단(round-13/22)** + 인쇄 도메인 지식 + 역공학 + 경쟁사를 종합해 "**기초코드 등록 명세 마스터**"(축별 신규 등록/교정/축이동 + webadmin 적재경로 + 4-way 근거)를 도출한다. 권위[HARD]=상품마스터(260610)+인쇄상품 가격표(260527), 역공학·경쟁사는 갭헌팅 보강(권위 덮어쓰기 금지). **rpmeta(그릇 부재 판정)도 dbmap(데이터 교정 적재)도 아닌, 그 둘의 교집합을 "무엇을 기초코드로 등록/교정할 것인가"의 거버넌스 명세로 종합**. 분석·명세 전용 — 실 라이브 COMMIT은 인간 승인 후 dbmap 적재 트랙(dbm-load-execution·dbm-axis-staged-load) 위임.

**트리거:** "기초코드 등록", "기초코드 등록 필요분 도출", "기초코드 거버넌스", "기초코드 개선/보완/수정", "자재/사이즈/도수/인쇄옵션/공정/기초코드 정리", "잘못된 매핑 도출", "등록 명세 마스터", "권위 정답 사전", "4-way 진단", "basecode 하네스 실행/재실행/업데이트/보완", "특정 축만 등록명세", "자재 등록명세", "카테고리 등록명세", "huni-basecode" 등 본 도메인 요청 시 `huni-basecode-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-basecode/` (01_authority·02_diagnosis·03_registration·04_gate). 4인 팀(`hbg-authority-curator`→`hbg-basecode-diagnostician`→`hbg-registration-designer`→`hbg-validator`)·권위 정답 사전→4-way 진단→등록 명세→B1~B6 게이트. 1순위 축=자재🔴·카테고리🔴(round-22 진단), 나머지 4축 스캐폴드(후속 확장). 라이브 읽기전용 SELECT만(파괴적 쓰기 0)·`.env.local` RAILWAY_DB_*.

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 4 에이전트(hbg-authority-curator·diagnostician·registration-designer·validator) + 5 스킬(orchestrator + curation·diagnosis·registration-spec·governance-evaluation). rpmeta∩dbmap을 기초코드 등록 명세로 종합하는 신규 통합 거버넌스 하네스. 산출=등록 명세 마스터(분석·명세 전용·실 COMMIT은 dbmap 위임). 1순위=자재·카테고리 | `.claude/agents/huni-basecode/`·`.claude/skills/{huni-basecode-orchestrator,hbg-*}`·CLAUDE.md §12 | 사용자(`/harness:harness` — rpmeta 읽고 기초코드 등록 필요분 도출 전략) |
| 2026-06-18 | 6축 등록 명세 마스터 완주(GO) — 자재·카테고리(1차)+사이즈·도수·인쇄옵션·공정(2차) 전건 GO. ★3대 발견: del_yn 권위 정정·ref_param_json 신규그릇 철회(dtl_opt 재사용)·.10 3용도 분해. 신규 코드행 0(결함=오염/미적재). 커밋 d382a56~33f4407 | `_workspace/huni-basecode/`(01~04)·메모리 [[del_yn 권위]] | 사용자(파이프라인 실행) |
| 2026-06-18 | **교정 실행 우선순위 트랙 추가(Phase 5)** — 신규 에이전트 `hbg-remediation-planner` + 스킬 `hbg-remediation-planning`. 등록 명세를 안전·가역성 우선 우선순위화 + ★가격사슬 영향 분석(t_prc_* 교정 영향·dbm-price-arbiter 협업) + 교정 경로 혼합(가역=라이브직접/근본=경로Y) + wave 단계별 인간 승인 큐. 실 COMMIT은 GO분 wave 단위 승인 후 dbmap 트랙(dbm-axis-staged-load·dbm-load-execution) 위임 | `.claude/agents/huni-basecode/hbg-remediation-planner`·`.claude/skills/hbg-remediation-planning`·오케스트레이터 §Phase5·CLAUDE.md §12 | 사용자(`/harness:harness` — 우선순위로 라이브 실제 교정·가격사슬 점검) |

---

## 13. Harness: Huni-Price-Quote (옵션 선택→가격계산 검증·뼈대)

**목표:** 라이브 가격엔진(`raw/webadmin` `catalog/pricing.py`의 `evaluate_price` **단일 권위 알고리즘**)과 라이브 `t_prc_*` 가격 데이터(공식 48·formula_components 301·구성요소 146·단가행 7,293·상품-공식 바인딩 76·사이즈 520, 직접단가 0=전 상품 공식기반)가 **권위 엑셀**(상품마스터 260610·인쇄상품 가격표 260527)에 맞게 적재됐는지 **냉철하게 평가·검증**하고, 옵션선택→가격구성요소→가격공식→시뮬레이터 검증→위젯 계약의 **단단한 뼈대**를 명세한다. 4구성물(가격공식·가격구성요소·가격뷰어·가격시뮬레이터) 역할·흐름 도해 + evaluate_price 계약 추출이 검증의 자(尺). 5인 에이전트 팀(`hpq-engine-cartographer`→기준점 / `hpq-authority-curator`→기준점 / `hpq-price-chain-inspector`→생성 / `hpq-option-constraint-mapper`→생성 / `hpq-quote-gate-validator`→검증)으로 기준점 팬아웃→생성 검사 팬아웃→P1~P7 냉철한 게이트. **생성≠검증 분리·권위 엑셀 절대 권위·라이브 읽기전용·DB 미적재**(실 교정은 인간 승인 후 dbmap 위임)·대표 상품군 파일럿 우선. 기존 `dbm-price-*` 6종을 입력·도구로 재사용.

**트리거:** "가격계산 하네스", "옵션 가격 검증", "가격엔진 검증", "가격공식/가격구성요소 검증", "가격 정합 평가", "권위 엑셀 매핑 검증", "인쇄상품가격테이블 차원 검증", "시뮬레이터 검증", "옵션/템플릿/제약 검증", "사이즈 중복 점검", "가격 뼈대", "가격계산 하네스 실행/재실행/업데이트/보완", "특정 상품군만 가격검증" 등 본 도메인 요청 시 `huni-price-quote-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-quote/` (01_engine·02_authority·03_chain·04_option·05_gate). 자격증명: `.env.local` `RAILWAY_DB_*`(읽기전용 SELECT)·`HUNI_ADMIN_*`(라이브 화면 읽기 탐색만, 저장/삭제 금지·admin/test1234).

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 5 에이전트(hpq-engine-cartographer·authority-curator·price-chain-inspector·option-constraint-mapper·quote-gate-validator) + 6 스킬(orchestrator + 5 방법론). 라이브 evaluate_price 권위 알고리즘 실측(공식 48·단가행 7,293·직접단가 0=전 상품 공식기반)·webadmin pricing.py/price_views.py 흐름 파악. 생성≠검증 분리(P1~P7 게이트)·권위 엑셀 절대 권위·DB 미적재·대표 상품군 파일럿 우선(사용자 4결정) | `.claude/agents/huni-price-quote/`·`.claude/skills/{huni-price-quote-orchestrator,hpq-*}`·CLAUDE.md §13 | 사용자(`/harness:harness` — 옵션 선택→가격계산 검증·뼈대 하네스) |

---

## 14. Harness: Huni-Price-Engine-Diag (가격엔진 이해·진단)

**목표:** 가격계산엔진을 이루는 5개 장치(① 가격공식 ② 가격구성요소 ③ 할인테이블=수량구간 ④ 가격뷰어 ⑤ 가격시뮬레이터)의 역할·조합 메커니즘을 원리적으로 정의하고, 프로그램 코드(`raw/webadmin` `pricing.py`·`price_views.py`)가 DB 엔티티 각 속성(t_prc_*/t_dsc_* 컬럼·타입·제약·코드값·FK·트리거)에 맞게 제대로 구현됐는지 진단하며, **결론을 내리기 전에 "원리상 아는 것 vs 모르는 것"을 지식맵으로 분리**한다. §13 huni-price-quote(검증·게이트·결론)와 분리된 **선행 이해·진단 트랙** — 장치 역할을 정확히 정의하지 않으면 잘못 적재된다는 전제(직전 검증에서 검증자조차 도수축 오해·SIZ 오선택). 2인 에이전트 팀(`hped-mechanism-researcher` 장치 역할 원리 정의·지식격차 / `hped-code-schema-auditor` 코드↔DB 속성 정합·설계 산출물 3-way 추적)이 팬아웃+교차참조.

**트리거:** "가격엔진 이해", "가격엔진 진단", "가격 장치 역할", "공식/구성요소/할인/뷰어/시뮬레이터 역할", "가격엔진 원리", "조합 메커니즘", "코드 DB 정합", "속성 단위 구현 진단", "설계 산출물 반영", "아는것 모르는것", "지식격차 리서치", "가격엔진 이해 하네스 실행/재실행/업데이트/보완", "특정 장치만 진단" 등 본 도메인 요청 시 `huni-price-engine-diag-orchestrator` 스킬을 사용. 권위 엑셀 대비 정합 검증·P1~P7 게이트·결함 교정은 §13 검증 트랙. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-engine-diag/` (01_mechanism·02_code_schema·03_synthesis). 권위 순서: ① 라이브 코드(동작) ② 설계 산출물(docs/prcx01-pricing-model.md·pricing-erd.md=의도) ③ 라이브 스키마/데이터 ④ 인쇄 도메인(보강). 라이브 읽기전용 SELECT만·DB 미적재(검증·교정은 §13/dbmap 위임).

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 2 에이전트(hped-mechanism-researcher·code-schema-auditor) + 3 스킬(orchestrator + mechanism-research·code-schema-audit). §13 검증 트랙의 선행 이해·진단 레이어(5장치 역할 원리 정의·코드↔DB 속성 정합·아는것/모르는것 분리). 신규 독립 하네스 | `.claude/agents/huni-price-engine-diag/`·`.claude/skills/{huni-price-engine-diag-orchestrator,hped-*}`·CLAUDE.md §14 | 사용자(`/harness:harness` — 5장치 역할 정의+코드/DB 정합 진단+지식격차) |
| 2026-06-18 | U-7 트랙 추가 — 에이전트 `hped-binding-validity-designer` + 스킬 `hped-binding-validity-mapping`. 오적재 단일병인(formula_components prd_cd 부재→시트밖 구성요소 silent 합산)을 닫는 구성요소↔상품군 유효성 정합 설계(Phase 3). ★초점=코드(트리거/DDL) 구현 아닌 데이터 정합(제대로된 가격 결과)·SOT 1 권위·DDL은 dbm-ddl-proposer 위임 | `.claude/agents/huni-price-engine-diag/hped-binding-validity-designer`·`.claude/skills/hped-binding-validity-mapping`·오케스트레이터 Phase3·CLAUDE.md §14 | 사용자(`/harness:harness` — U-7 배선레벨 제약 데이터 정합 설계) |
| 2026-06-18 | **전 하네스 전수 감사 + 정리(운영/유지보수·문서·배선만·코드/DB/삭제 0)** — 2 감사관 병렬(인벤토리·드리프트 / 가격 클러스터). ★결론: 가격 4하네스(§7·§13·§14·§15)=**중복 아닌 의도적 상보 레이어**(이해→게이트→온디맨드→적재·재병합 금지). 실행: A-1 STALE 정정("evaluate_price 미구현"→실재·§13/§15 실호출·dbm-price-engine-verifier/verify·dbm 오케스트레이터 round-18 4곳·prcx01 STALE 가드) · A-2 dbm-schema-analyst 29→44테이블 · B-1 round-24 dbm-category 오케스트레이터 등재 · B-3 방법론 스킬 12 에이전트 durable 배선 · C 경계 명문화(cartographer↔mechanism·§13↔§15). ★B-2 유령토큰=오탐(grep `pq-`가 `cpq-` 부분매칭). 보류: frm_typ/clr_cd는 dbm-price-formula-audit 결판 후 | `_workspace/_harness-audit/`·dbm/hpq/hped/hqv/hbg 에이전트·스킬·CLAUDE.md §14·[[harness-audit-maintenance]] | 사용자(`/harness:harness` — 전수 감사·중복/이전버전 정리) |

---

## 15. Harness: Huni-Quote-Verify (상품 가격계산 검증 · Claude+Codex 병행)

**목표:** 사용자가 **"상품군(카테고리)+상품명"**(예: "프린트엽서 가격계산 검증해줘")을 주면, 그 상품이 자기 가격공식으로 **가격계산이 되는지** 검증하고 개선/수정/보완안을 도출한다. 검증 3축[HARD]: ① **SOT 일치**(상품마스터 260610 ↔ 인쇄상품 가격표 260527 데이터 일치) ② **가격공식 속 가격구성요소 매핑 정합**(시트 차원경계 SOT 안에서 제대로 배선) ③ **가격구성요소 차원 ↔ 가격테이블 차원 매칭**. 한 줄 명령이 무엇을 뜻하는지를 분해가가 해독(상품 요소 전수+공식사슬+골든)해 목표를 푼다. §13(대표 상품군 파일럿 냉철 게이트)·§14(5장치 이해·진단)의 산출을 입력으로 재사용하는 **단일 상품 온디맨드 검증+개선** 트랙.

**★Claude+Codex 병행(독립 교차검증):** Claude(라이브 실측·evaluate_price 실호출)가 1차 검증, **Codex gpt-5.5**(`codex exec` 읽기전용·ChatGPT 구독 OAuth·API 종량과금 없음)가 같은 work-spec으로 독립 2nd opinion → reconcile(합의=고신뢰·불일치=조사). ★Codex 주장=가설(라이브/권위 검증 전 채택 금지·환각 경계). codex-preflight로 가용성 판정·미가용 시 "Claude 단독" 명시 폴백(pending 금지).

**트리거:** "가격계산 검증", "상품 가격 검증", "프린트엽서 가격검증", "이 상품 가격계산 되는지", "가격공식 검증", "SOT 일치 검증", "공식/구성요소 매핑 검증", "차원 매칭 검증", "codex 병행 검증", "가격검증 하네스 실행/재실행/업데이트/보완", "특정 상품만 검증", "검증 다시" 등 본 도메인 요청 시 `huni-quote-verify-orchestrator` 스킬을 사용. 5장치 역할 이해·진단은 §14, 대표 상품군 냉철 게이트는 §13. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-quote-verify/<product>/` (01_decompose·02_verify·03_codex·04_remediation). 생성≠검증·라이브 읽기전용 SELECT만·DB 미적재(실 교정은 인간 승인 후 dbmap 위임). 자격증명 `.env.local RAILWAY_DB_*`.

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 3 에이전트(hqv-product-decomposer·quote-verifier·codex-cross-verifier) + 4 스킬(orchestrator + product-decompose·quote-verification·codex-cross-verify) + codex-review.sh. Claude+Codex 병행 독립 교차검증(구독=ChatGPT OAuth 실측·종량과금 없음). 단일 상품 온디맨드 "가격계산 되는지" 3축 검증+개선. dbm-price-arbiter 재사용(개선 심의) | `.claude/agents/huni-quote-verify/`·`.claude/skills/{huni-quote-verify-orchestrator,hqv-*}`·CLAUDE.md §15 | 사용자(`/harness:harness` — codex 병행 단일상품 가격계산 검증+개선) |

---

## 16. Harness: Huni-Recipe-Viz (상품 구성요소 시각화·레시피 검증 · codex 중심)

**목표:** 상품마스터 각 시트의 각 상품을 이루는 구성요소(자재·공정·옵션·사이즈·도수)를 **한눈에 보는 시각화**로 만들고, 그 구성요소를 중심으로 가격이 만들어지는데 **누락되면 제대로된 결과값을 확인할 수 없는** 문제를, **codex-cli(레시피 생성·연결 검증)와 codex-imgage(mermaid→이미지 2단계 시각화)** 로 산출해, 상품마다 구성요소가 제대로 연결됐는지·상품에 연결할 가격공식의 가격구성요소가 제대로 설계됐는지 확인한다. 작업지시서/생산지시서형 **레시피**(도출: 상품마스터+가격표+round-11 BOM+라이브 t_*)를 토대로 인쇄자동견적이 가능하기 위한 모든 요소를 만든다. **★[HARD] 산출 본문은 Claude보다 codex로 만든다(사용자 directive)·생성=codex/검증=Claude.**

**트리거:** "상품 구성요소 시각화", "레시피 시각화", "구성요소 연결 확인", "가격구성요소 설계 확인", "작업지시서 레시피", "생산지시서", "인쇄자동견적 요소", "codex 레시피 시각화", "구성요소 한눈에", "상품마스터 시트 시각화", "레시피·시각화 하네스 실행/재실행/업데이트/보완", "특정 시트만 레시피", "시각화 다시", "연결검증 다시" 등 본 도메인 요청 시 `huni-recipe-viz-orchestrator` 스킬을 사용. 단일 상품 가격계산 검증은 §15, 상품군 위키 집필은 §9. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-recipe-viz/<sheet>/` (01_recipe·02_viz·03_audit·04_validation). 4 에이전트(`hrv-recipe-builder` codex-cli 레시피 / `hrv-component-visualizer` mermaid→codex-imgage 2단계 / `hrv-connection-auditor` codex-cli 연결·가격공식 설계 검증 / `hrv-validator` Claude R1~R6 독립 게이트) + 5 스킬. codex 헬퍼=`rpm-visualize/scripts/codex-preflight.sh`·`hqv-codex-cross-verify/scripts/codex-review.sh` 재사용. 라이브 읽기전용 SELECT만·codex `-s read-only`·DB 미적재(실 교정 인간 승인 후 dbmap/§15 위임).

**핵심 결정:** ① codex 중심(산출 본문 codex·Claude는 큐레이션·호출·검증) ② **시각화 2단계: mermaid 진실 소스 먼저 → codex-imgage 이미지 → mermaid 기준 정합 검증**(사용자) ③ 레시피=도출(작업지시서 문서 부재) ④ 생성=codex/검증=Claude(codex 주장=가설·환각 경계) ⑤ 디지털인쇄 시트 파일럿 우선.

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 4 에이전트(hrv-recipe-builder·component-visualizer·connection-auditor·validator) + 5 스킬(orchestrator + recipe-build·component-visualize·connection-audit·recipe-validation). codex 중심(codex-cli 레시피·연결검증 + codex-imgage mermaid→이미지 2단계)·생성=codex/검증=Claude. 디지털인쇄 파일럿 | `.claude/agents/huni-recipe-viz/`·`.claude/skills/{huni-recipe-viz-orchestrator,hrv-*}`·CLAUDE.md §16 | 사용자(`/harness:harness` — 상품 구성요소 시각화·레시피·codex 중심) |
| 2026-06-18 | 디지털인쇄 파일럿 완주(GO·운영검증) + R7 freshness 게이트 추가(진화). codex가 31상품 레시피·mermaid 4·이미지 3·연결진단 생성, Claude 검증, **메인 원천 재측정이 라이브 드리프트 적발**(PRF_DGP_A 배선 upd_dt 2026-06-18 21:11 변경=S2 제거·del_yn=Y). ★교훈: 라이브는 작업 중 변하는 표적·upd_dt freshness 필수·검증자도 드리프트를 "날조"로 오인 가능 | `04_validation/divergence-final-adjudication.md`·`hrv-recipe-validation`(R7)·[[huni-recipe-viz-harness]] | 파일럿 운영검증 + 진화 |

---

## 17. Harness: Huni-Basedata-Dedup (기초데이터 표시중복 정리·검수·적재 · Claude+codex 교차)

**목표:** 두 SOT 권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)을 **토큰효율적으로 탐색**(1회 추출→CSV 캐시, 엑셀 반복 Read 금지)해, 6축 기초데이터(사이즈·공정·자재·기초코드·인쇄옵션·도수) 중 **사용자 화면 표시명/내부값이 중복**이거나 **표시↔실제가 불일치(오적재)**인 데이터를 검수하고, 정리/적재할 매핑데이터를 만들어 승인 후 라이브에 안전 적재한다. 중복의 본질[사용자 정의]=키는 고유하나 화면 표시가 중복으로 보이는 것(예 "60x60" 여러 코드). **★Claude 생성 + codex cli 2차 교차검증으로 오적재 방지. 정리/적재할 것 없으면 통과(NO-OP).** §12(basecode 정확성 거버넌스)·§7(dbmap 전체 매핑)과 별개의 표시중복+codex 안전적재 전용 트랙.

**검수 4축[HARD]:** ① 권위추출+표시↔실제 정합(siz_nm 등 라벨 ↔ 내부 치수값 일치·불일치=오적재) ② 표시 중복(화면 라벨 동일·코드 다름) ③ 내부값 중복(실제값 동일·코드 다름) ④ 의미구분 보존(작업/재단/판형/단위/상품전용은 중복 제외=false-positive 가드). 판정=권위에서 canonical(의미축+정규치수+단위) 도출→라이브 환원→충돌·불일치 검출.

**트리거:** "기초데이터 중복 정리", "사이즈 중복 정리", "표시명 중복", "사이즈정보 검수", "SOT 엑셀 사이즈 정리", "DB 적재 사이즈 매핑", "codex 교차 적재", "기초데이터 정합 검수", "공정/자재/도수 중복", "기초데이터 정리 하네스 실행/재실행/업데이트/보완", "특정 축만 중복 정리" 등 본 도메인 요청 시 `huni-basedata-dedup-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-basedata-dedup/<axis>/` (index/authority/live.csv·dedup-report·mapping.csv·reconcile.md·_exec). 4인 팀(`hbd-source-harvester`→`hbd-dedup-analyst`→`hbd-codex-verifier`→`hbd-load-executor`)·D1~D6 게이트·**사이즈 파일럿 우선**. 기존 `00_schema/ref-*.csv`·`24_master-extract-260610`·codex-review.sh 재사용. 라이브 읽기전용 기본(`.env.local RAILWAY_DB_*`)·실 적재는 승인 후·가격종속(component_prices)은 BLOCKED 보류.

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-19 | **공정 파일럿 GO·라이브 COMMIT(9건 논리삭제)** — 5단계 파이프라인 전건 통과. 추출(D1·102행)에서 **★레지스트리 정정: 공정=가격비종속(N) 거짓→component_prices.proc_cd 1,919행/25코드 가격종속(Y)**. 표시중복 13그룹 멤버별 1:1 가드(사이즈 교훈) → **진짜중복 9(thin-mirror 자식 2026-06-17 일괄 INSERT·dtl_opt/authority 공란·참조0)·오적재 BLOCKED 3(미싱086/오시090/타공092 자식이 단가행 98행·부모↔자식 가격사슬 단절)·정당구분 keep 2(핑크 010/036 다른 부모·UV 002/016)**. ★"11쌍 일괄 merge" 함정(가격 98행 전손) 회피. codex(gpt-5.5) 2차 합의 14/14·divergence 0(BLOCKED 근거 nuance까지 pricing.py 코드로 단절 실재 확정·부모→자식 fallback 부재). 9건 del_yn='Y' 라이브 COMMIT(백업 `bak_proc_dedup_round_pilot`·DRY-RUN 2-pass 멱등·V1~V5 GO[정본 부모 무변경·가격 cp 7288 불변·FK고아0]·undo 보유). BLOCKED 3=보류 큐(경로Y/dbm-price-arbiter escalate). 다음=카테고리(재실측 후) | `_workspace/huni-basedata-dedup/processes/`(index/authority/live·dedup-report·mapping·reconcile·_exec)·HANDOFF.md·`_registry/basedata-axes.md`·CLAUDE.md §17·[[huni-basedata-dedup-harness]] | 사용자(공정 표시중복 정리·codex 교차·9건 적재 승인) |
| 2026-06-19 | **카테고리 파일럿 GO·라이브 COMMIT(rename 1 + 디자인캘린더 동형교정 노드3·상품3)** — ★착수 전 라이브 재실측이 핵심: 레지스트리 표시중복 "11"은 stale(round-24 240노드 논리삭제 전)→**활성 79 기준 실측 3그룹**. 가격 비종속 확정(component_prices에 cat_cd 없음·t_dsc_grade cat_cd 0행). 진짜중복 0·오적재 1·정당구분 keep 3·빈노드 3. **① rename**: CAT_000104 '하드커버책자'→'하드커버'(round-24가 MAP F8 섹션라벨 오변경→잎 105 동명충돌, codex 105삭제=사이즈패턴 오적용 false-merge 차단)·UPDATE1·동명충돌2→0. **② 빈노드 318/319/320(디자인캘린더 하위)**: dedup 1차 "빈슬롯 삭제"→**사용자 MAP 시트 이미지 권위 정정**(▶︎디자인캘린더=정당 하위분류·아래는 상품)→재분석 v2: **비동형 오모델 적발**(타 하위분류=L2+상품직결, 디자인캘린더만 L2+L3빈노드=상품을 카테고리로 잘못 만듦). **round-24 D-1이 틀림**(junction PK=(prd_cd,cat_cd) 복합인데 PRD_108→112와 →118을 "동일셀 중복"으로 통합=category-blind dedupe 오류·다중분류 의도 소실). 동형 교정 COMMIT: (가)318/319/320 del_yn='Y'·CAT_000118 유지 (나)PRD_108/110/111→CAT_000118 junction append main='N'(PK충돌0·합법 다중분류)·V1~V7 GO·백업2·undo. main 무결성 결함(PRD108/111 main결손·110 del참조)=컴펜 큐. 다음=자재(가격종속 신중) | `_workspace/huni-basedata-dedup/categories/`(empty-node-analysis v2·_exec)·HANDOFF·레지스트리·CLAUDE.md §17·[[huni-basedata-dedup-harness]] | 사용자(카테고리 표시중복+MAP 권위 정정·동형 교정 승인) |
| 2026-06-19 | **자재 파일럿 Phase1~3 GO·032 적재 승인 보류(미적재)·세션 정리** — 자재(t_mat_materials) 재실측: 활성 192·가격종속 실측 Y(component_prices.mat_cd 3,342행/66~68코드·신중)·**표시중복 1그룹만**(삼각대그레이 MAT_000032 vs MAT_000252). 4축 검수 1차 = **C 총보류(과보수)** → **codex 2차가 Claude 과보수(total-hold)를 적발**(사이즈 패턴 재현·방향 반대: 사이즈는 Claude false-negative, 이번은 Claude 과보수)→안전 정리분 **MAT_000032 1건 발굴**(삼각대그레이인데 mat_typ_cd=.02 링제본부자재·권위부재·BOM0·cp0·참조전무=고립 stale). 라이브 재실측으로 divergence 해소·D4 GO. **★MAT_000252 정본 무선언 가드**(252/254=dbmap C-CAL-01이 자재→공정 축이동 후보로 판정·표시중복 정리가 선점 금지·round-22④/basecode §12 인계). **Phase 4 승인에서 사용자 "질문 명확화" 요청→세션 정리 전환·032 미적재**. 다음=032 적재 의도 확인→도수→기초코드 | `_workspace/huni-basedata-dedup/materials/`(live/index/authority·dedup-report·mapping·reconcile)·HANDOFF·레지스트리·CLAUDE.md §17·[[huni-basedata-dedup-harness]] | 사용자(자재 표시중복 정리·다음세션 정리) |

---

## 18. Harness: Huni-Price-Engine-Design (가격계산 엔진 설계·구축)

**목표:** 역공학 자료(`raw/widget_monitor`·`docs/reversing`·`_workspace/huni-rpmeta`) + 상품마스터(260610) 가격계산공식 + 인쇄상품 가격표(260527) + 경쟁사(와우프레스·레드프린팅) 가격계산 방식을 종합해, **모든 상품군 완제품·반제품(세트상품)이 어떤 가격구성요소를 토대로 어떤 가격공식을 이루는지**를 설계한다. 산출=라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 t_prc_* 그릇 설계 명세(공식→formula_components→price_components→component_prices·use_dims 차원·세트 조합). **기존 가격 5하네스(§7 적재·§13 게이트·§14 이해·§15 온디맨드검증·§16 시각화)와 달리 "설계·구축" 각도 — 아직 없는/불완전한 가격공식을 경쟁사 흡수+역공학으로 새로 설계**(재병합 금지·상보). 5인 팀(`hpe-formula-cartographer`·`hpe-benchmark-analyst` 기준점 팬아웃 → `hpe-engine-designer` 설계 → `hpe-validator` E1~E7 게이트 → `hpe-codex-validator` codex 독립 2차 교차 Phase5.5). 대표 상품군 파일럿→동형 전파·생성≠검증·codex 주장=가설(환각 경계)·권위 엑셀 절대권위·라이브 읽기전용·**DB 미적재**(실 COMMIT/DDL은 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).

**트리거:** "가격계산 엔진 설계", "가격엔진 구현", "가격공식 설계", "가격구성요소 설계", "완제품 반제품 세트 가격", "경쟁사 가격계산 흡수", "와우프레스 레드 가격 분석", "codex 설계 검증", "t_prc 그릇 설계", "가격엔진 설계 하네스 실행/재실행/업데이트/보완", "특정 상품군만 엔진 설계" 등 본 도메인 요청 시 `huni-price-engine-design-orchestrator` 스킬을 사용. 단순 질문은 직접 응답.

**산출물 루트:** `_workspace/huni-price-engine-design/` (`_meta`·`01_formula`·`02_benchmark`·`03_design`·`04_validation`·`05_codex`). 자격증명 `.env.local RAILWAY_DB_*`(읽기전용 SELECT). codex 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh`(내부에서 `rpm-visualize/scripts/codex-preflight.sh` 호출) 재사용. 기존 `dbm-price-arbiter`·`dbm-ddl-proposer`·`dbm-schema-extract`·`dbm-excel-parse` 재사용.

**변경 이력:**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-20 | **아크릴 파일럿 종단·검증 GO(E1~E7 전건 PASS·보정 0)·codex high 교차검증·DB 미적재** — 두 번째 종단=면적매트릭스형 대표(디지털인쇄=원자합산+고정가 다음). Phase1~5.5 **첫 게이트부터 GO**(디지털 NO-GO·보정 폐루프와 대조). **★면적매트릭스 엔진: COMP_ACRYL_CLEAR3T 1 comp 3차원(siz_width/siz_height ceiling off-grid + mat_cd 두께 직교)·출력매수 곱셈사슬 없음(디지털과 결정적 차이)·W=가로 H=세로 가격축 권위(work사이즈 블리드 가산 금물·dbmap round-23 돈크리티컬).** **★디지털 ×qty/silent 이중합산 결함 아크릴엔 구조적 부재**: 면적단가=개당 완제품가(묶음총액 아님)·min_qty=1 전건(÷1=개당×수량)·comp 1배선(합산대상 1개=이중합산 불가). benchmark "엔진계약 미확정" 경계는 라이브 confirm(CLEAR3T 165행 min_qty=1·MIRROR 52행 NULL=.01)으로 해소=디지털과 단가 의미 정반대. **★G-A1 본체 활성 16~17상품 미바인딩**(라이브 바인딩 PRD_000146 1건뿐→source=NONE)→PRF_CLR_ACRYL/COROTTO 재사용 바인딩(신규 mint 0). 골든 8/8(30×30 3T=3100·1.5T=2480·비대칭 50×30=3800·off-grid 35×35→40×40·코롯토 3600). 미러 BLOCKED(본체 0개·소재옵션 가능성)·카라비너 신설(고정가형·형상≠siz)·컨펌큐 6~7(후가공 개당/×수량 돈크리티컬 CA-4). **★codex effort high(세션 헤더 reasoning effort: high confirm)**: GO 지지·핵심3(개당가/×qty없음·mat_cd 직교·G-A1)합의·divergence 0·codex가 mat_cd 주입누락/미러합류 위험 독립 재발견(고신뢰). 신규 가격축 0(rpmeta AC distinct #19 부결 정합). 부수: effortLevel medium→high·codex-review.sh effort 인자 추가 | `_workspace/huni-price-engine-design/{01_formula/formula-map-acrylic·02_benchmark/absorption-candidates-acrylic·03_design/{engine-design-acrylic,golden-cases-acrylic}·04_validation/gate-verdict-acrylic·05_codex/codex-reconcile-acrylic·HANDOFF}`·`.claude/settings.json`·`.claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh`·CLAUDE.md §18·[[huni-price-engine-design-harness]] | 사용자(다음 상품군 동형 전파·effort high·codex high) |
| 2026-06-20 | **디지털인쇄 파일럿 완주·재게이트 GO(전건 PASS)·DB 미적재** — 전 파이프라인 종단(Phase1~3 설계→Phase4 검증 NO-GO→Phase5.5 codex 교차검증[NO-GO 강하게 지지·핵심3결함 전건 합의·divergence 0·인쇄면 silent 이중합산을 codex가 독립 도출=echo불가 최고신뢰]→보정 폐루프→재게이트 GO). **★핵심 결함·진원[HARD]: 전 고정가형(명함25·엽서북4·포토카드3·박FOIL)이 라이브 prc_typ=단가형(.01)인데 단가가 묶음/구간 총액→엔진 unit×qty로 ×qty 과대청구(명함 3500→350,000·박 24,800→7.44M). 진원=라이브 prc_typ 오적재이지 설계 골든값 오류 아님(단가행 값은 가격표 verbatim으로 옳음).** **★권위 확정(CV-1~4·가격표260527 구조가 권위): ①합가형(.02) 확정**(명함 행축 라벨 `소재/제작수량`100·셀3500=100매 묶음총액·단가형이면 행축이 "제작수량100"일 수 없음·반증불가) **②명함UX=수량 브래킷 택1 ③인쇄면/페이지/소재=가격표 열 차원=통합**(comp 1개·use_dims·라이브 S1+S2 합산은 구조위반) **④박 동판비=`기본가(아연판)` 별행5000=정액 1회**. **★교정안 A(.01→.02·÷min_qty·단가행 값 불변): 엔진 (unit÷min_qty)×qty로 골든 8/8 재현**(3500·9500·11000·박29,800)·round-23 스티커 COMP_STK_PACK/TATTOO 합가형 교정 동형 선례(신규 아님)·min_qty=NULL 행 0건(ValueError위험0). **★D-2 codex 가설 정정**: codex "매칭=use_dims 기준" 사유 거짓(pricing.py는 NON_QTY_DIMS 고정상수 순회)·단 use_dims 등재는 필요(오경고·옵션주입)·designer 라이브 반증 정확. 실 prc_typ 교정(값불변·멱등·백업)은 인간 승인 후 dbm-axis-staged-load/dbm-load-execution 위임·박동판=차선A(qty=1격리) vs B(정액 prc_typ 신설·개발자 백로그)·webadmin pricing.py read-only | `_workspace/huni-price-engine-design/{03_design/{remediation-applied,pricetype-remediation-arbitration},04_validation/regate-verdict-digitalprint,05_codex/codex-reconcile-digitalprint,HANDOFF}`·CLAUDE.md §18·[[huni-price-engine-design-harness]] | 사용자(codex 검증 재개→보정 폐루프→재게이트 GO) |
| 2026-06-20 | 하네스 초기 구성 — 5 에이전트(hpe-formula-cartographer·benchmark-analyst·engine-designer·validator·codex-validator) + 6 스킬(orchestrator + 5 방법론). 역공학+상품마스터 공식+경쟁사 흡수→전 상품군 완제품·반제품 가격공식+구성요소 설계. 기존 가격 5하네스와 "설계·구축" 각도로 분리(재병합 금지)·생성≠검증·codex 독립 2차 교차(Phase5.5)·대표 파일럿→동형 전파·DB 미적재 | `.claude/agents/huni-price-engine-design/`·`.claude/skills/{huni-price-engine-design-orchestrator,hpe-*}`·CLAUDE.md §18 | 사용자(`/harness:harness` — 역공학+상품마스터+경쟁사로 가격계산 엔진 설계·codex 검증) |

---

## 19. MoAI Framework (gated — rarely used here)

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
