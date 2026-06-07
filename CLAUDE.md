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
| 2026-06-07 | **판형=출력용지규격 규명 + 국4절 32상품 plate 실제 적재 + 디지털인쇄 가격엔진 미설계 발견** — 사용자 `/goal`("미적재 확인·적재, 스키마/엔티티 이해 후 라이브 개선, 판형=출력용지규격·판걸이수 도메인"). ①**판형=출력용지규격 확정**(권위=상품마스터 `파일사양_출력용지규격` 컬럼, 라이브 plate=작업사이즈는 잘못 기재). 출력용지규격 9종·**종이 종속**·전지(원지 국전939×636)≠출력용지규격(인쇄단위). 3자(상품마스터·출력소재IMPORT·판걸이수) 일관(316x467 국4절·330x660 3절·315x467 투명). ②**국4절 32상품 plate 실제 라이브 적재**(COMMIT·검증 전건 통과·커밋 c722c24): 작업사이즈 중복행 DELETE 101·`SIZ_000499` INSERT 31·작업사이즈 ORPHAN siz soft-delete 53·가격 무변경·FK고아0·PRD_000016 KEEP. 라이브 롤백전용 DRY-RUN GO(멱등 2-pass·제약위반0·영구변경0)→인간승인 COMMIT. ③**핵심 발견: 디지털인쇄 원자합산형 가격엔진 "미설계"**(round-2 단순형 10공식만·원자합산형 누락). 계산공식집초안 정의(판매가=인쇄비+코팅비+용지비+접지비+후가공+박+추가상품) 있으나 라이브엔 단가만·공식 사슬(formula→formula_components→product_price_formulas) 없음 → 디지털인쇄 ~28상품 가격조회 불가. 용지비(IMPORT 종이120종)도 미적재. ④검증 6건 능동적발(G-1 MAJOR: plate만 옮기면 3절·투명 가격조회 깸). 폐기: plate-size-remodel(공존)·plate-size-correction(316단일)·plate-size-live-diagnosis(오판). **다음=디지털인쇄 가격엔진 설계+적재(큰 트랙)·3절투명 동시·용지비**. | _workspace/huni-dbmap/{08_remediation/{output-paper-3way-reconciliation,plate-load-from-master-design},03_validation/{plate-load-from-master-gate,plate-load-guk4-dryrun-gate},09_load/_migrate_plate_load_guk4,HANDOFF}·메모리3·CLAUDE.md, 커밋 c722c24 | 사용자(`/goal` 미적재 확인·판형 검증·라이브 개선) |
| 2026-06-07 | **round-5 미적재 7개 차단 전수 분석 + 설계 트랙** — 사용자 "/goal 핸드오프 읽고 round-5 미적재 분석해 적재 가능화". ①**GP 합판도무송 원형 빌드**(`09_load/_migrate_gp_circle/`): GP원형 가격 100행=sticker 066 원형과 동일직경 입증→sticker siz `SIZ_000501~510` 공유(신규등록0). 로컬게이트 G1~G9·R1~R4·R6 PASS(GO-PENDING-LIVE-DRYRUN). ②**아키텍처 원리 확정**(메모리 `dbmap-compute-in-app-db-stores-lookup`): 중간계산=앱 런타임·DB=룩업. 판수(판걸이수)=임포지션 계산(DB 미저장)·박 면적→등급=앱 계산. **STK 판수축 해법=bundle_qty 아님(정정)**. ③**박(foil) 매핑 설계**(`02_mapping/price-foil-matrix-mapping.md`): 등급 A~E=엑셀 편의물 폐기, B02⋈B03 조인 면적매트릭스 환원(등급 DB미저장). 재계산 2143행·등급소멸 PASS, **검증 CONDITIONAL-GO**(BLOCKER-1: 재사용 siz 혼합축·`SIZ_000047` 삼중바인딩→축통일 재게이트). ④**ENV 봉투 매핑**: 봉투 4종 작업사이즈(상품마스터 봉투제작 003-0015)=라이브 siz `SIZ_000191~194` EXACT 재사용·40행, **검증 GO**. ⑤**아크릴 인쇄사양·가공·코롯토 수집**+검토5 처리(코롯토 매핑·투명부채/극세사 무시·카드봉투블랙/트레싱지=상품악세사리). ⑥**자재-옵션 정규화 설계**(메모리 `dbmap-material-option-normalization`): 자재 마스터 오염(색/형상/사이즈가 자재로 ~120행)→**WowPress 6축 흡수 벤치마크**(docs/wowpress 326상품)→후니 5축 보유·1축 GAP. **본체색=재질합성(과분할금지·파우치 이미 정답)·형상/사이즈=규격·인쇄면/잉크색=도수**. 도메인확인3+GAP3(SHAPE/COUNT/OPT). DB 미적재·DDL 무적용 유지 | _workspace/huni-dbmap/{09_load/_migrate_gp_circle,02_mapping/price-{foil-matrix,envelope}-mapping,03_validation/{price-foil-envelope-gate,load-execution-gate-gp-circle,product-viewer/acrylic-spec-and-review5},04_audit/material-master-analysis,10_configurator/{wowpress-option-model,huni-goods-option-mapping},HANDOFF}·메모리3·CLAUDE.md | 사용자(`/goal` 미적재 적재 가능화) — 분석·도메인이해·벤치마킹·매핑설계 |
| 2026-06-06 | **가격 권위정정 + GO분 실제 적재 + 교정 마이그레이션 준비** — 사용자 "html(product-viewer) 토대 전체 상품마스터+인쇄가격 적재" 목표. ①**후니 권위 가격공식 정정**(면적매트릭스형 실사/현수막/아크릴=[세로][가로] · 고정가형 수량×옵션 · off-grid=한단계 큰 크기 런타임): round-2가 28 포스터사인 상품을 일괄 `PRF_POSTER_FIXED`(면적-좌표)로 오모델링한 것을 **면적13/고정가15로 분리정정**(데이터 R²아닌 후니 권위공식 기준 — 면적함수 추천은 오판). ②**가격 siz 차단 재진단**(스키마 심층분석 `00_schema/schema-relationship-analysis.md`: 출력판형/면적=신규등록 아닌 **기존 판형/siz 재사용**): GUK4 870→`SIZ_000499`·3JEOL 304→`SIZ_000077`(impos=Y)·GP35 10→`SIZ_000422` = **1,184행 자율 판형교정**. ③**GO분 실제 라이브 적재**(사용자 "GO분 안전 적재" 승인→백업[read-only]→COMMIT): **인쇄가격 3,504행**(t_prc_* 이제 비어있지 않음)+**상품마스터 398행**(materials 716·proc 260·bundle 26)+update-set, FK고아0·멱등, 백업·undo 안전망(`backup_20260606_202911`). ④**고정가 15**(규격 siz 전건 라이브 재사용·73 cells·**DELETE 재바인딩**)+**면적 13+아크릴**(211 신규 좌표 siz `SIZ_000511~721`·907 단가) **2대 교정 마이그레이션 준비·라이브 롤백 DRY-RUN 검증**(승인 대기, `_migrate_fixedprice/`·`_migrate_areamatrix/`). ⑤전체 275상품 적재가능성 매트릭스·정정 묶음수18 통합·도메인 의미 S-gate. **교훈: GO 커밋 후 교정은 멱등 append 아닌 별도 마이그레이션(DELETE/UPDATE)**·siz 번호조율(501~510 sticker[=GP 공유]·511~721 면적). 잔여=STK/GP/ENV·상품마스터290(MAT_*/PLATE/PRINTSIDE/검토)·코드행·실COMMIT(후니). 권위 HANDOFF=`_workspace/huni-dbmap/HANDOFF.md` | _workspace/huni-dbmap/{09_load/{_exec*,_migrate_fixedprice,_migrate_areamatrix,_exec/load-decision-request·catalog-loadability},02_mapping/{price-correction-poster-sign,load_price_correction,price-siz-mapping-inspection},00_schema/schema-relationship-analysis,HANDOFF}·메모리·CLAUDE.md, 커밋 9ec8be9·9c6c134·a606710 등 | 사용자(`/goal` html토대 전체적재) — 권위 가격모델 정정·GO 적재·교정 마이그레이션 |
---

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
