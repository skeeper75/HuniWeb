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

**진행 상태:** round-1(구간할인, GO·미적재) DONE · round-2(가격 t_prc_*) **15시트 평면화 DONE**(베스트프랙티스 ETL·component_prices 4805행·검증 GO·후니 siz등록 대기) · round-3(매핑 audit→처리적재 설계) **DONE·DB 미적재**(master 신설·적재 별도 승인) · **CPQ 트랙: 라이브 구현 확인 DONE**(옵션/템플릿/제약 7테이블·트리거 7종·excl_groups 흡수 — 재문서화 `00_schema/cpq-schema.md`·하네스 강화) · **round-4(적재 준비) DONE**(양 트랙 GO: 상품마스터 384행+가격 2,320행, G1~G9 PASS·라이브 DRY-RUN 보류) · **round-5(적재 실행본) DONE**(양 트랙 GO: 상품마스터 384행+코드11+update289·가격 2,320행. **S-gate[도메인 의미]+G1~G9+R1~R6 전건 PASS**·라이브 롤백전용 DRY-RUN 2-pass 멱등·제약위반0·COMMIT0 실증. reg_dt NOT NULL 결함 라이브 적발→수정 RESOLVED. DDL 제안 2건[비치수 size·박 2단룩업]. 실제 COMMIT·DDL적용·코드행등록은 인간 승인 대기) · **GO분 실제 적재 DONE(2026-06-06)**(사용자 "GO분 안전 적재" 승인→백업(read-only)→실제 COMMIT: **인쇄가격 3,504행**[t_prc_component_prices 3,292 등, 라이브 t_prc_* 이제 비어있지 않음]+**상품마스터 398행**[materials 716·processes 260·bundle 26]+update-set, 검증 전건 통과·FK고아0·멱등. 코드행 placeholder(PROC_000084·SIZ_000501~510) 의도적 제외. 백업·undo 안전망 보유. **DB 미적재 원칙→"GO분 적재됨, 차단/결정분만 미적재"로 갱신**. 가격 siz 권위정정[round-2 28상품 면적-좌표 오모델링→면적매트릭스13/고정가15, GUK4/3JEOL/GP35 1,184행 판형교정] 반영분 포함) · **디지털인쇄 가격엔진 트랙 DONE(2026-06-07)**(미설계 SUM 공식 6종 설계+독립검증 GO → 라이브 적재: 디지털 147+ENV 40+GP 121=**308행 COMMIT**, R1~R6 PASS·멱등·공식사슬 완결. 잔존 차단=3절/투명/박/048) · **round-7(입체 커버리지 검증) 실행 완료·GO(2026-06-08)**(전 상품군 11시트 × 라이브 t_* 19엔티티 **209셀 매트릭스**[✅51·🟡44·❌49·◆DB-ONLY17·➖48]+admin 3원대조 3종 일치+관계무결성 R1~R7+갭보드. `evaluator-active` 독립평가 C1~C8 전건 PASS — 행수 10셀·R1/R4/R7·admin 3종 독립 재측정 일치. 횡단 발견: CPQ 옵션 레이어 전면 미적재[option_items 전역 0행·R7 FAIL]·가격사슬 6상품군 부재·DB-ONLY 17셀[외부권위 vs 과적재]·DOMAIN-UNDECIDED 2[기성품 사이즈]. 실결함 D-1[LOADED=행존재만·변형커버리지 미검증]. **조망/검증 전용·DB 미적재**, 발견 미적재 실 적재는 인간 승인) · **round-8(admin UI 입력 명세) 완료·GO(2026-06-08)**(라이브 admin product-viewer `gstack live` 전수 분석 → **34 t_* 엔티티 332컬럼**의 모든 항목을 {UI라벨·컬럼·위젯·필수·타입제약·코드값도메인·미적재입력법·입력화면}으로 정의[`13_admin-ui-spec/`]. 입력화면 2종[catalog Django change form 14모델·product-viewer pvEdit 섹션]. round-7 미적재 갭→admin 입력 FK 위상순서 환원. `evaluator-active` 독립검증이 information_schema로 컬럼수 재집계→1차 NO-GO[tags jsonb 2건 누락]→보정→G1~G7 GO. **교훈: 컬럼 권위=라이브 information_schema, table-spec 보조**. 사용자 directive[각 페이지 모든 항목 정의·누락0] 충족. 명세/입력경로 전용·실 입력은 인간 승인) · **round-10(버전 변경 추적 하네스 신설 + 260527→260610 실행) DONE·GO(2026-06-10)**(`/harness:harness`로 변경추적 트랙 신설[스킬 `dbm-change-tracking`·에이전트 `dbm-change-tracker`·**키 기반 3-way diff**{baseline 260527/new 260610/라이브}·V1~V8 게이트] → 상품마스터 실행: **상품 추가/삭제/재명명 0**·MODIFIED 527셀이지만 **자동 UPSERT 0·전부 ESCALATE(526)/GAP(1)**[굿즈파우치 448=`사이즈(필수)`→`상품(옵션)` 재분류·스티커 37=커팅클리어·아크릴 41=아크릴미니파츠 변형행−16·실사 1=범례텍스트]. `dbm-validator` 독립 **V1~V8 8/8 PASS GO**[diff 스크립트 byte-identical 재실행·라이브 read-only 실측(레더라벨 SIZ_000492/494/496·option_items 18=silsa)·527셀 dodge-hunt→진짜 in-place 스칼라=실사 범례 1건뿐=정당 GAP]. **교훈: 버전변경=데이터모델 의도전환[size→option]일 수 있음·기계적 size 삭제 금지[적재된 size/price 사슬 파손, schema-design-intent-first]**. 가격표는 신규버전 없어 범위 외. 추적·델타 DRY-RUN 전용·실 COMMIT/CPQ L2/논리삭제는 인간 승인) · **round-11(상품마스터 컬럼 도메인 의미 + 상품 BOM + 적재명세) 하네스 확장·디지털인쇄 파일럿 DONE(2026-06-10)**(`/harness:harness`로 신규 에이전트 2[`dbm-domain-researcher` 컬럼의미+상품BOM·`dbm-loadspec-extractor` webadmin 적재명세]·스킬 2[`dbm-column-domain`·`dbm-loadspec-extract`]·오케스트레이터 round-11 추가. **디지털인쇄 7상품·44컬럼·1026행** 파일럿 5산출: column-dictionary[44컬럼 의미축·목표 t_*·확정도 빈칸0]+product-bom[7상품 자재/공정]+loadspec[webadmin BaseAdmin 제너릭·BASE_CODE_GROUP 14·상품인라인6·file:line]+mapping-info[컬럼→t_* 통합·FK 적재순서]+domain-research-notes[컨펌5]. **핵심 도출: 별색≠도수[C18~22→`t_proc_processes`]·판수=앱 임포지션 계산[C6 DB 미저장]·출력판형≠재단≠작업[C10/C5/C8 3축]·자재=parent+usage_cd[낱장 C단일]·박색/파일명약어/폴더[C37/C11/C13] 귀속 컨펌**. round-9 `schema-design-intent-map`의 엑셀 측 입력 절반 충족·07_domain 의미축[L2 공정레시피·L3 9속성] 재사용[재유도0]. DB 미적재[분석/정리 전용]·나머지 10시트 확대·컨펌 5건 해소는 인간/다음).

**변경 이력 (최근 3건, 전체는 `_workspace/huni-dbmap/CHANGELOG.md`):**
| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-15 | **round-19 신설 — 상품군 종단 견적가능 파이프라인(`/harness:harness` 검증·강화)** — 사용자 "분석된 내용 기반 파이프라인 검증·개선/보완/강화". 감사: 16라운드가 전부 **레이어(가로)**·한 상품군도 견적가능까지 **종단(세로)으로 닫힌 적 0**(D-1 근본결함)·목적(CPQ 3종 차원환원=생산정보)과 무게중심 불일치(가격 5라운드 vs CPQ 1)·readiness 비균질(booklet 1시트만). 라이브 실측: CPQ option 37/247상품·**template 5·constraint 8(거의 0)**·option_items 차원환원 87%=자재(.03)254+공정(.04)143=선택→생산정보 데이터 성립 확인. **강화 A+B+C(사용자 선택): round-19 종단 파이프라인 신설** — 기존 레이어 라운드를 호출 순서로 엮는 메타(S0 컬럼 readiness→S1 미적재 식별/라우팅→S2~4 적재[round-13/5/6/16/18]→S5 견적가능 Q1~Q6→S7 RTM). **견적가능=①UI 옵션선택+②선택의 차원환원 생산정보(MES_ITEM_CD 아님)+③가격계산 셋 다**(거짓 GO 금지). 신규 에이전트 `dbm-readiness-auditor`+스킬 `dbm-product-readiness`(컬럼 readiness 매트릭스·Q게이트·RTM). **+ 3상품군 종단 실행**(`29_readiness/{postcard,voucher,namecard}/`): 엽서016/017/018·상품권041/042(PRF_DGP_A 합산형)·명함031/032/033(고정가형) — ①UI·②차원환원(생산정보) 전건 PASS·③가격만 막힘·복제성/일반성/거짓GO차단 입증·골든 라이브 재현(보정0)·견적가능 완전0/조건부2/NO-GO1/미검증7. **+ 가격 3종 횡단 인간 승인 큐**(`_price-remediation-queue.md`): D-1b 후가공 prc_typ(22comp·ⓒ-2 신규 PRICE_TYPE.03 권고·엽서+상품권 동시정상화 최고ROI)·WIRE 배선미완(명함 공식분리 ⓑ·박 공용 comp·종이 이중계상 방지)·GAP-PARAM(ref_param_json)·컨펌7건. DB 미적재(엔진 미구현=실청구 위험0·실 적재=기존 라운드+인간 승인). 커밋 5건(5131f14·ebdbc94·7492a1b·3d65a65·7031cad). | `.claude/agents/huni-dbmap/dbm-readiness-auditor.md`·`.claude/skills/dbm-product-readiness/SKILL.md`·`huni-dbmap-orchestrator/SKILL.md`·`29_readiness/`·CLAUDE.md §7·메모리 | 사용자(`/harness:harness` 파이프라인 검증·종단 강화·폐루프 준비) |
| 2026-06-15 | **round-18+ 게이트형 파이프라인 실증 실행 — PRF_DGP_A 완주 + 전수 파이프라인 설계 + PRF_BIND_SUM 첫 패스** — 앞 정립(게이트 순서 데이터정합→사슬→계산)을 실제 클래스에 돌려 작동 입증. ① **PRF_DGP_A(엽서 9) 완주**: C-2 확정[사용자 비준] 옵션→comp 멤버십 권위=**가설 A**(CPQ option_items + 신규 `OPT_REF_DIM.08 가격구성요소`)·B(가격차원 오인코딩)/C(공정 2-hop) 기각. ⓐ DDL 제안서(base_code 1행 + **트리거 `fn_chk_opt_item_ref` 보강 필수**=ELSE RAISE EXCEPTION이 .08 INSERT 차단·테이블 ALTER 0). ⓑ 멤버십 option_items **12행**(016 기본8[인쇄2·모서리2·후가공4]+017/026 코팅4·종이는 .03 자재 자동연결)·[CONFIRM:016-COATING 해소] 016 코팅 미실재(엑셀 공란·억지적재 안함). **D-1[RESOLVED]** 작업사이즈→출력판형=`t_siz_sizes.note` 전지룩업(316×467)→9상품 전부 SIZ_000499·결합 재계산 C1=44,330·C2=141,650 known 일치(보정 하드코딩0=[HARD] 충족). 🔴 **D-1b[돈-크리티컬]** 후가공 13comp `prc_typ_cd` 단가형(.01) 오적재→가격표 권위로 **ⓒ 구간고정총액형** 확정(헤더 "합가"·값은 정확=메타데이터 오적재). ② **전수 파이프라인 설계 심의**(arbiter+general-purpose 병렬): 결함=스키마 횡단(D-2 합산형 전클래스·opt_cd 3,481행 NULL / D-1b 22comp=STK/NAMECARD/GANGPAN)·반복 템플릿 S0진입스캔~S7재검증·중단없음=DEFERRED(승인큐)/BLOCKING·경량 산출물 4종·신규 에이전트0·외부 베스트프랙티스 정합. ③ **PRF_BIND_SUM(제본4) 첫 패스**: 템플릿 반복 입증·**D-2 재발견(재진단0=카탈로그 효과)**·S1🔴(B-WIRE 공식 3/4 배선단절)·S2🔴(A-2 값 32/32 일치)·골든 8/8(보정0)·BLOCKING 2(B-WIRE·B-FORMULA)·DEFERRED 2. ④ **BIND 정립 완주[arbiter]**: BIND-C1 권고 A안(제본방식별 공식분리·DDL0)·★일반원칙=멤버십 구조가 해법 결정(한 상품 다중택1→option_items+.08 / 상품별 1고정→공식분리). 레드 PRBKYPR 벤치마크 0건 보류(좌철 단일·완제품총액·B-WIRE 봉쇄). ⑤ **후니 제본 12종 전수 조망**: 값 확인 11종 74셀 전건 일치(책자32+하드커버18+캘린더24)·prc_typ 전건 단가형·활성화 임박 7종(하드커버3+캘린더4 데이터 건강·배선+바인딩만)·BC-3 캘린더=COMP_BIND_CAL_* 별도부품(트윈링 아님)·🔴 제본 상품 18종 중 가격공식 5종뿐·13종 미구성(매출직결). 컨펌 BIND-C1·BC-5·BC-1/2·C-D1b-SCOPE. DB 미적재(실 적용=인간 승인 DEFERRED 큐). | `26_price-engine-verify/{PRF_DGP_A,PRF_BIND_SUM,_binding-overview}/`·`27_competitor-benchmark/PRF_BIND_SUM/`·`28_price-arbitration/{PRF_DGP_A,PRF_BIND_SUM,_pipeline-review}/`·HANDOFF·CLAUDE.md §7·메모리 | 사용자(게이트형 파이프라인 실증 실행·전수 확장 방향) |
| 2026-06-14 | **round-18+ 게이트형 파이프라인 정립 — 매핑검증→통과시 계산(`/harness:harness` 감사)** — 사용자 "오케스트레이터가 ①구성요소 매핑 제대로됐나 검증→②확인되면 가격계산→③경쟁사 대조→④차이로 공식검증, 현재 그렇게 구성됐나? 실 적재 DB 검증·개선 시 요건 충분반영 베스트프랙티스 전문에이전트와 꼼꼼 체크". **정직 진단=아니오**(현행은 매핑 의미정합[arbiter]이 계산 뒤 Phase4·하드게이트 부재). **결정적 발견: verifier `recompute.py`가 옵션→구성요소 매핑을 파이썬 하드코딩(`compute_corrected`)→라이브엔 그 매핑 없는데(D-2) 계산기가 메워 "거짓 GO"** — 사용자가 막으려던 상황. `dbm-price-arbiter`(전문 심의)+general-purpose(베스트프랙티스 리서치) 병렬 심의(`28_price-arbitration/_pipeline-review/`). **정립(신규 에이전트 0·기존 재배치): 게이트 순서 데이터정합→사슬→계산**(CPQ 표준 data integrity→config→pricing): G-DATA(arbiter mapping-integrity 셀단위 정합+round-13 재사용)→G-CHAIN(verifier chain-completeness)→**통과시만** G-CALC(verifier recompute·**보정 하드코딩 [HARD] 금지**·corrected=진단용·GO근거 아님)→벤치마크(정답+합리성 오라클·materiality PASS/WARN/🔴FAIL)→arbiter 정립→**재검증 폐루프+RTM**(요건↔게이트 추적·빈칸=미검증). 오케스트레이터 8-Phase 게이트형 재작성·verify/arbiter/benchmark 스킬 정립 반영. 컨펌 C-1(round-13 GO 선행 강제 여부)·C-2(D-2 매핑 권위 CPQ vs 차원컬럼). | `huni-dbmap-orchestrator/SKILL.md`·`dbm-price-engine-verify`·`dbm-price-arbiter`·`dbm-competitor-benchmark` 스킬·`28_price-arbitration/_pipeline-review/{arbiter-review,bestpractice-research}.md`·CLAUDE.md §7·HANDOFF·메모리 | 사용자(`/harness:harness` 게이트형 파이프라인 감사·정립) |
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

## 10. MoAI Framework (gated — rarely used here)

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
