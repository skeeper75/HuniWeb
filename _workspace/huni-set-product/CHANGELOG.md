# Huni-Set-Product 하네스 CHANGELOG

셋트상품(부품조립형) 구성·설계·라이브 적재 하네스(§23). 최신이 위.

---

## 2026-07-01 — 069 무선·070 PUR 소프트커버 셋트 완전 동작화 COMMIT (저청구 → 138,688·288,688·068 동형 전파)

068 중철에서 확립한 분해형 소프트커버 패턴(표지공식 PRF_BOOK_COVER + 표지 member 분리)을 069 무선·070 PUR에 전파. 둘 다 완전 동작화 COMMIT.

- **068 대비 단순**: **신규 가격공식 0·신규 comp 0** — PRF_BOOK_COVER(068에서 신설)·PRF_DGP_INNER·PRF_BIND_MUSEON·PRF_BIND_PUR 전부 라이브 재사용. 068의 t_prc_* 선행 COMMIT 트랙 불요 → t_prd_* 단일 트랙.
- **신규 mint**: 반제품 4(PRD_000289 069내지·290 069표지·291 070내지·292 070표지·prd_typ.02). MAX=288(068 표지)→289~292.
- **라이브 COMMIT(인간 승인)**: 셋트행 각 2행(069·070)·반제품 4·차원·공식 바인딩(290/292→PRF_BOOK_COVER 재사용·289/291→PRF_DGP_INNER·부모 제본 NO-OP). 백업·undo·멱등·회귀 0(068/072/077/082 무손상).
- **사후 evaluate_set_price**: 069=**138,688**(표지88,688 + 제본 MUSEON 500×100=50,000) / 070=**288,688**(표지88,688 + 제본 PUR 2000×100=200,000). 오차 0·단가 verbatim. 표지 member SIZ_000499 fn_calc_pansu=1.
- **★S8 제본 격리 결정적**: COMP_BIND_MUSEON=PROC_000019 단독·COMP_BIND_PUR=PROC_000020 단독 → silent 다중매칭 0. PRF_BOOK_COVER 재사용이 069/070 표지 member(290/292) 전용·오염 0.
- 내지 page_rule 24/300/2(068의 4/28/4와 다름·라이브 verbatim). cover_mult=1(책등 펼침)이라 071/082 ×2 무관.
- **잔존 BLOCKED**: 071 트윈링(cover_mult ×2·엔진 미지원·C트랙)·088 레더링바인더·DBLPANSU(C트랙·표지/제본 무영향)·BLOCKED-MAT070-LINK(070 완제품 자재 link 0·견적 미관여·dbmap)·usage_cd 표시명 정합(dbmap·가격 무관).
- 산출=`06_load/booklet-museon-069-load.sql`·`booklet-pur-070-load.sql`·`booklet-museon-pur-069-070-{apply,undo,backup,commit-log,exec-report}.*`·`05_gate/gate-verdict-booklet-museon-pur-069-070.md`·[[leather-hardcover-077-live-commit-260701]].

---

## 2026-07-01 — 068 중철 소프트커버 셋트 완전 동작화 COMMIT (저청구 → 골든 158,688·표지 동작 첫 소프트커버)

077/082(하드커버·통합 COVERBIND)와 달리 068=소프트커버(분해형)라 표지가 인쇄/코팅/용지 3비목으로 쪼개짐. 사용자 "표지까지 완전 동작화" 선택 → 표지를 member로 분리해 골든 **158,688** 완전 도달.

- **077/082 대비 차이[핵심]**: 068 표지 3중 BLOCKED — (a) 표지 3비목만 가진 깔끔한 공식 부재(기존 PRF_DGP_*는 굿즈/명함 후가공 혼입·S8 오염) (b) 표지 반제품 부재 (c) 완제품 판형(SIZ_000250)≠표지 단가행 판형(SIZ_000499) NO_MATCH. **해법 = 표지를 별도 member로 분리**(booklet-cover-branch 종단 결론).
- **신규 mint**: 표지 가격공식 **PRF_BOOK_COVER**(인쇄 COMP_PRINT_DIGITAL_S1 + 코팅 COMP_COAT_MATTE + 용지 COMP_PAPER 3비목만·신설·신규 comp 0) + 반제품 2(표지 PRD_000288·내지 PRD_000287). PRF_DGP_A 등 후가공 혼입 공식 빌리기 부결(S8).
- **★판형 해소**: 표지288을 A3펼침(SIZ_000174)+판형 SIZ_000499로 → `fn_calc_pansu(499,174)=1` → 표지 1매=1판 정확(A4=pansu2 저청구·499자신=0 부결). 068 완제품 판형엔 SIZ_000499 단가행 없음 → **member 분리 필연**(직배선 불가 검증).
- **라이브 COMMIT(인간 승인)**: 단일 트랜잭션 41행(가격공식4+반제품2+차원30+바인딩3+셋트행2). ★의존순서[HARD]: 가격공식(t_prc_*) 먼저→반제품/셋트행(t_prd_*) FK 위상순(역순이면 288→PRF_BOOK_COVER FK 깨져 표지 0). 백업·undo·멱등·회귀 0.
- **사후 evaluate_set_price = 158,688**(표지 88,688[인쇄350×100+코팅500×100+용지36.88×100] + 제본 JUNGCHEOL 700×100=70,000·오차 0·단가 verbatim). 068 셋트행 0→2행(표지288+내지287·소프트커버 면지 0).
- **S8 오염 0**: PRF_BOOK_COVER 비목 3개만·후가공/굿즈 혼입 0·proc_cd 주입(인쇄 PROC_000004·코팅 PROC_000015) silent 다중매칭 가드.
- codex Q-A(표지 용지비 누락 NO-GO 후보·6/29 reconcile) → COMP_PAPER 3,688 member 명시로 해소.
- **069/070 전파 준비**: 분해형 동형(cover_mult=1) → PRF_BOOK_COVER 재사용·반제품2+셋트만 mint. **071=BLOCKED**(트윈링 cover_mult ×2·엔진 미지원·C트랙). DBLPANSU 내지 이중÷pansu도 C트랙(표지/제본 무영향).
- 산출=`06_load/booklet-jungcheol-068-{full-load.sql,apply.sql,undo.sql,backup-*.sql,commit-log.md}`·`05_gate/gate-verdict-booklet-jungcheol-068.md`·`price-e2e-trace-*.md`·[[leather-hardcover-077-live-commit-260701]].

---

## 2026-07-01 — 082 하드커버링 셋트 라이브 동작화 COMMIT (견적 0원 → 44,123·077 동형 전파 2번째)

077 패턴을 082 하드커버링에 전파(권위대조→설계→독립 게이트 DRY-RUN→인간 승인 후 실 COMMIT). 견적 **0원 → 44,123원**(A5·30p·양면).

- **077 대비 차이[핵심]**: 082=하드커버**트윈링(링)**이라 무선 부모공식 `PRF_HC_MUSEON_SET` **재사용 불가**(S8 옵션 오염=링에 무선 제본단가) → 링 전용 부모공식 **PRF_HC_TWINRING_SET 신설**(분해형). 077은 재사용이었으나 082는 신설.
- **신규 mint 2건**: 링 부모공식 PRF_HC_TWINRING_SET(+비목배선 COMP_BIND_HC_TWINRING addtn_yn=Y) + 내지 반제품 **PRD_000286**(page8/100/+2·072 내지284 재사용 불가). 제본비 `COMP_BIND_HC_TWINRING`(PROC_000024·6밴드 verbatim 30000~7000·이미 실재·미바인딩) 재사용.
- **라이브 COMMIT(인간 승인)**: 단일 트랜잭션 **27행**(공식1+비목배선1+286마스터1+차원15+바인딩2+셋트행6[5→6]). 백업·undo 보유·멱등·FK 위상·기존 077/072 회귀 0.
- **★S8 제본 오염 0(견고)**: COMP_BIND_HC_TWINRING 단가행 proc_cd=PROC_000024 **단독**·무선(019)/일반트윈링(018~021)/PUR(020)/중철(018)과 무중첩·5개 제본 comp 전부 use_dims에 proc_cd → 엔진 proc_cd 분기로 silent 매칭 불가. 077 COVERBIND(무차원 와일드)보다 데이터 레벨 격리 우수. **링≠무선≠일반트윈링 혼선 0**.
- **사후**: evaluate_set_price 0원→44,123(제본 30,000 + 내지 인쇄 14,000 + 용지·fn_calc_pansu(SIZ_000499,A5)=4 실측). 082 셋트행 5→6행.
- **잔존 BLOCKED(077 동형·동작 안 막음·저청구 잔존하나 0원 아님)**: 표지/면지 ×2 인쇄·코팅(BLOCKED-COVER-MYUNJI-PRINT·§18)·cover_mult ×2(엔진)·면지 유료 결판(CONFIRM-MYUNJI-PAID·077은 면지무료였으나 082 권위는 유료 명시·라이브 ASP 골든 역산 필요)·좀비 link(dbmap)·C트랙.
- **동형 전파 대기**: 088 레더 링바인더(082 패턴 동형·072:077 = 082:088 매트릭스).
- 산출=`06_load/hardcover-ring-082-{load.sql,load-spec.md,backup-*.sql,undo.sql,commit-log.md,post-verify.md}`·`05_gate/gate-verdict-hardcover-ring-082.md`·`03_design/hardcover-ring-082-authority.md`·[[leather-hardcover-077-live-commit-260701]].

---

## 2026-07-01 — 077 레더하드커버 셋트 라이브 동작화 COMMIT (견적 0원 → 51,146·첫 셋트 동작화 종단)

사용자 요청("실제 라이브 셋트상품 하나를 동작하게")으로 **077 레더하드커버**를 권위대조→설계→독립 게이트 DRY-RUN→**인간 승인 후 실 COMMIT**까지 종단.

- **권위 대조 결판(요청 ①·빈 껍데기 결함 vs 설계의도)**: 077 표지078·면지079/080/081 = **설계의도(가격0)** — 072 동형으로 부모 `COMP_HC_MUSEON_COVERBIND`(표지+제본 권당 통합)가 흡수·면지 권위상 무료(072 라이브 ASP 블랙=화이트=그레이 동일가 46,500 입증). 내지 부재 = **결함**(책 본문 가격 통째 누락=저청구 진짜 원인). 산출=`03_design/leather-hardcover-077-authority.md`.
- **동작 경로 = 072 패턴 재사용 + 내지 1건 신설**: 부모공식 `PRF_HC_MUSEON_SET`·내지공식 `PRF_DGP_INNER`·`COMP_HC_MUSEON_COVERBIND` 6밴드·레더자재 MAT_000186·공유 단가행 전부 재사용(신규 공식/comp/단가행 mint **0**). 신규 mint = 내지 반제품 **PRD_000285** 1건만(search-before-mint 전수 확인·MAX prd_cd=284).
- **라이브 COMMIT(인간 승인)**: 단일 트랜잭션 **23행**(products 1 + 285 차원 15[사이즈3·인쇄옵션2·자재9·판형1] + 공식 바인딩 2 + 셋트행 5). 백업=`leather-hardcover-077-backup-20260701_0005.sql`·undo=`leather-hardcover-077-undo.sql`. 멱등(2회차 delta 0)·FK 위상(285→차원→공식→셋트행)·**기존 072 등 회귀 0**.
- **사후 검증**: evaluate_set_price 견적 **0원 → 51,146원**(PRICE≠0 동작 입증·A4·30p·qty1). 077 셋트행 4→5행(disp_seq 1~5·내지285 min24/max300/incr2).
- **★돈크리티컬 결판(레더 +3,900 BLOCKED)**: COVERBIND `use_dims=["min_qty"]`만이고 6밴드 mat_cd=NULL → `_row_matches`(pricing.py:94)가 use_dims와 무관하게 mat_cd 검사 → 레더 단가행 추가 시 NULL밴드+레더 combo 2개 = **ERR_AMBIGUOUS → 합산 제외(34,100조차 0)**. **designer가 레더 단가행 안 넣은 게 옳음.** 결과: 077이 072 전용지와 동일가(레더 프리미엄 +3,900 미반영=저청구)이지 **0원·계산불가 아님**. 견적 0원→정상 동작 목표 달성. 레더 델타는 엔진 use_dims 확장 필요(C트랙·개발팀).
- 골든 50,800 vs 계산 51,146(+346) = 072가 이미 가진 산식 편차(권당/내지환산) 상속·077 적재 결함 아님(C트랙).
- **동형 전파 패턴 입증**: 082 하드커버링(단 cover_mult ×2 BLOCKED 동반)·068~071 소프트커버(부모공식 4비목)에 같은 패턴 적용 가능.
- **잔존 BLOCKED**: BLOCKED-COVERBIND-LEATHER(레더 +3,900·엔진)·BLOCKED-MAT-REWIRE(좀비 MAT_000002 아크릴 link 정리·표지078 레더 link·dbmap)·CONFIRM-LEATHER-PRINT(실무진)·C-TRACK-ENGINE(COVERBIND ×qty·DBLPANSU).
- 산출=`06_load/leather-hardcover-077-{load.sql,load-spec.md,backup-*.sql,undo.sql,commit-log.md}`·`05_gate/gate-verdict-leather-hardcover-077.md`·[[leather-hardcover-077-live-commit-260701]].

---

## 2026-06-27 — 전 상품 가격공식 완전성 마스터 + 가격만결손 51 분해 + 명함특수 4 라이브 COMMIT + 아크릴 코드버그

세션 시작 = 가격만결손 51 바인딩(§23 핸드오프). 중간에 `/harness:harness`로 두 목표(①가격구성 적재 ②전 상품 공식 정리) 요청 → **Phase 0 감사로 신규 하네스 불요 판정**(§18+§7+§17 커버·SOT [HARD] "새 하네스 금지") → 수렴-실행 + 사용자 지적("전체 공식 수립 시도 부재") 반영.

### 전 상품 가격공식 통합 마스터 (완전성 자·goal 2)
- `_foundation/price-formula-master.{csv,md}` — 전 275상품 1행. hpe-formula-cartographer가 §18 11시트 formula-map/component-inventory 합본 + 라이브 병합(신규 하네스 0). main 독립검증(바인딩78·공식52·고아3·status합275).
- status 7분류: BOUND_OK 77·LIVE_UNBOUND 24·DESIGNED_NOT_LOADED 22·NEEDS_BASICS_FIRST 97(굿즈/파우치 87)·DESIGN_BLOCKED 5·BOUND_DEFECT 1·NA 49. **완제품226 가격작동 78/35%·미수립 148.**
- **가격만결손 51 = LIVE_UNBOUND 24 + DESIGNED_NOT_LOADED 22 + DESIGN_BLOCKED 5** 정확 분해.

### 가격만결손 51 바인딩 보드 (생성≠검증)
- hsp-set-designer 생성 BIND_ONLY 16 주장 → hsp-set-gate 독립검증 **6만 GO**·10 매트릭스 희소격자 홀 적발(생성≠검증 실효). 산출 `_foundation/remediation/price-only-51-binding-board.*`.

### ★아크릴 siz_cd×면적 코드버그 (개발팀 C트랙·DB 미변경)
- 6 GO 아크릴(157~162·nonspec_yn=N) area 공식 바인딩 시 **과소청구 확정** 규명: 엔진(pricing.py match_component)이 siz_cd→치수 미환원→tier=0→최소사이즈 행. 데이터 단가편집 불가(어느 행 뽑히나 문제)·근본=코드(siz_cd→t_siz_sizes.cut_width/height 환원). 기존 146=nonspec_yn=Y라 무관. 문서 `_foundation/remediation/CODEBUG-sizcd-area-undercharge.md` → 개발팀 위임·바인딩 보류.

### ✅ 명함특수 4 라이브 COMMIT (되돌리지말것)
- hpe-engine-designer 설계 → main 독립검증+사후검증. **035 모양(단면18000/양면19000)·036 미니모양(16000/17000)·037 박(24200)·039 투명(13500)** 견적가능화.
- 패턴 = 특수 comp 단가행 print_opt_cd 태깅(S1=단면POPT_001·S2=양면POPT_002·단가값 verbatim 불변·NULL→코드) + use_dims에 print_opt_cd 추가 → S1/S2 정상 배선(STD 패턴). ★035/036 양면 이중합산 홀(태깅 전 양면=S1+S2=37000 과청구·사용자 적발) → 태깅 후 S2만 19000 해소.
- footprint: 신규 PRF 5(SHAPE·MINISHAPE·FOIL·CLEAR·PEARL)·배선 9·바인딩 4·태깅 12행·use_dims 10 comp. 바인딩 distinct prd **78→82**. 부수효과 0(대상 comp 전부 기존 미배선)·단가값 0 변경. 백업/undo 보유.
- ⏸️ 034 펄(PRF/배선 적재·바인딩 보류=자재 collapse)·040 화이트(태깅만) = dbmap namecard-mat-fix + 코팅 차원 선결.
- ※프로세스 사고: dryrun 대신 fix.sql(끝 COMMIT) 오실행으로 조기 COMMIT → 독립검증 통과·승인접근 일치로 **유지** 결정. 교훈 [[dryrun-vs-fix-script-commit-lesson]].

### 다음
아크릴 코드(C·dev) → 명함 034/040 자재 → DESIGNED_NOT_LOADED 22 민팅 → NEEDS_BASICS 97(굿즈).

---

## 2026-06-26 — 072 내지 승격 그릇 GO + PRF 트랙 설계 + ★전체 7×4 현황판(조각 방지) · DB COMMIT 0

### 072 내지 반제품 승격 — 그릇 단계 GO (검증+codex 수렴·DB 미적재)
- **배경**: 072=원자합산형(권위 확정·094/097 고정가형과 달리 derive_inner_sheets 경로 필요). 내지 본체통합→총내지매수 미반영 → 내지 반제품 SEMI_ROLE.01 승격이 정석.
- **그릇 설계**(inner-promotion/inner-promotion-design.md): 채번 PRD_000284·내지 차원 copy·069 무선책자 내지 7자재 재사용·국4절 plate·sets 1행. 신규 mint 14행·신규 자재/siz/단가행 0.
- **정본 siz 4원천 권위 분석**(inner-size-authority.md): 삭제 SIZ_000170(A5) 대신 **active A5=SIZ_000007·A4=SIZ_000050**(note "책자내지"). 가격영향 0(절가=국4절 기준·use_dims에 siz_cd 부재·fn_calc_pansu pansu 불변 007=4=구170·050=2=구172). 삭제 170 20상품 활성참조 광역 dedup→basedata-dedup 라우팅.
- **검증 rev2 GO**(validation-gate.md): 차단 3건 실발동 입증(P1-e A5 정본 assert·채번 ABORT·CASE 멱등 dryrun 4회 ROLLBACK)·돈무영향(072 UNBOUND)·FK·멱등 회귀.
- **codex rev2 GO**(codex-reconcile.md): 차단1/2 CLOSED·DBLPANSU CODE 트랙 확정(`_row_matches` 하드코딩 NON_QTY_DIMS 순회·데이터-only는 over-mint뿐). Claude↔codex 불일치 0.

### PRF 트랙 설계 — NO-GO (4 선결·골든 968,433)
- **3 PRF**(prf-track-design.md): PRF_HC_INNER(내지284)·PRF_HC_COVER(표지073)·PRF_HC_BODY(072 제본only). S2 부활(참조 0·verbatim). 전 comp 표준 재사용·신규 단가행 0.
- **★골든 968,432.5→round_won 968,433**(3자 일치·표지 64,832.5+내지 453,600[인쇄407,500+용지46,100]+제본450,000). DBLPANSU 함정 695,395.94(내지 ~0.4배).
- **DBLPANSU**: 데이터 정석해소 불가·canonical=price_views.py:1707 `derive_inner_sheets→copies*pages` 1줄(§6 webadmin·인간 승인).
- **★codex 신규 돈 크리티컬 — S1/S2 내지인쇄 이중합산**(prf-track-codex-reconcile.md): 양면 주문 시 S1·S2 단가행 NON_QTY_DIM 동일 매칭→배타선택 부재→S1+S2 합산. print_opt_cd=색상축(면축 아님). **094 엽서북 R-3와 동일=가격엔진 구조결함·전 책자 공통**. 생성≠검증 거듭 실효.

### 책등(spine) 원칙 + 판형 출력가능영역 여백 감사 (사용자 원칙 질문 대응)
- **fn_calc_pansu 실측**: 판형 work−margin(출력가능영역)·아이템 work(도련 포함)로 임포지션. 국4절(306×457)에 A5 4-up. **출력가능영역 정확 처리**.
- **판형 여백 감사**(plate-margin-audit.md): 돈경로 판형=국4절(5mm)·국3절(2mm) 2개뿐·여백 clean·과소청구 0. 비활성 229건 여백 누락(단가행 미진입·돈0·향후 포스터 pansu CONFIRM).
- **책등**(cover-spine-principle.md): 책등=(페이지÷2)×종이두께+보드. A5 펼침 가로 24p384→300p405mm·국4절 한계 457까지 여유. **072(24~300p)·082(8~100p) 전 범위 1-up 유지→pansu 상수 1→돈영향 0**. plate-based 절가라 펼침치수 가격 무관. 정적 펼침siz(390×268) 충분(가변폭 큰 레더 바인더만 이산 버킷). 진짜 결함=펼침siz 미등록(3.8배). 책등 종이비 권위 부재(CONFIRM).

### ★전체 7×4 현황판 (사용자 피드백 — 조각 금지)
- **사용자 피드백**: "조각된 방식으로 전체를 보지 않고 일부분만 수정하고 있는 것 같다." → 메모리 [[set-product-whole-before-pieces]].
- **현황판**(set-product-readiness-master.md): 7셋트 × 4축(①기초데이터 ②전체 가격표 적재정합 ③set-products 코드 ④구성매핑). 라이브 바인딩=097(완료)·094(결함)만·5셋트 미바인딩. set-products 사용법(views.py:622·admin.py:1041·set_products.html) 숙지.
- **공통 선결 블로커**(한 셋트 아닌 전체): 가격엔진 코드결함 2(DBLPANSU·S1/S2·전책자)·기초데이터 정정·**전체 가격표 적재정합 전수(미수행=핵심 공백)**.
- **로드맵**: A2(전체 적재정합 전수)→A1(기초데이터)→A3(코드결함2)→B(그릇)→C(민팅·바인딩 072→전파).

### COMMIT 0 / 안전
- 이번 세션 라이브 DB 변경 0(그릇·PRF·검증 전부 설계+DRY-RUN ROLLBACK). 산출물만 작성. 기존 COMMIT(좀비배선13·W2·097) 보존.

---

## 2026-06-25 — W1-2 좀비 배선 정리 종단 완주(라이브 COMMIT 4+9건) + rev2 전체 재검토 + codex 교차

### 좀비 배선(삭제 자재가 활성 상품에 BOM 배선) 교정
- **정의**: `t_mat_materials.del_yn='Y'`(논리삭제) 자재가 `t_prd_product_materials.del_yn='N'`(활성) 상품에 BOM 배선됨. baseline 92건 → W1-1/W1-3 COMMIT 후 **87 재집계**.
- **dbm-correctness-auditor 1차**(disposition.csv): ★전 87 자재 component_prices 단가행 0 → 어떤 처분도 **돈영향 0원**. REWIRE 2 / REVIVE 2 / BLOCKED 83.
- **확정 4건 COMMIT**(`_exec/`·되돌리지말것): REWIRE 260→정본250·270→정본343(동일명, 충돌 0=8행 정상 재지정) + REVIVE 008레더(23배선)·261무지내지(4배선). 좀비 **87→83**(wires 175→140)·PK중복0·FK고아0·돈불변·백업 `bak_*_zombiewire_20260625_053924`·undo.

### ★BLOCKED 83 전체 재검토(rev2) — 회의적 재검토가 숨은 REVIVE 9건 적발
- **dbm-correctness-auditor rev2**(disposition-rev2.csv): 1차 76/83 변경. **BLOCKED→REVIVE 9 / BLOCKED→OPTIONIZE 67 / BLOCKED 유지 7**.
- **핵심 적발**: 1차 "옵션화 의존 BLOCKED"로 미룬 것 중 **8건이 사실 REVIVE 대상** — 활성 `option_items.ref_dim_cd='OPT_REF_DIM.03'`가 이 좀비 mat_cd를 ref_key1로 직접 참조 중인데 자재만 삭제됨=**옵션 참조 무결성 깨짐**. 현수막 추가물 5(양면테입069·끈070·큐방337·각목338·봉제사340·RC-2 자재축 누락)·투명커버마감 2(244·245)·유포지154 + 무광75mm262(거울 본체·정본부재)=REVIVE 9. OPTIONIZE 67(.09 라벨62·.08 색5)은 opt_item ref 0=옵션화 미완→부활 금지.
- **codex 독립 2차 교차검증**(codex-reconcile.md·gpt-5.5 high): rev2 **81/83 합의(97.6%)**·신규 적발 0·환각 0. 4대 적발 독립 재현=공유 맹점 낮음. 불일치 2(262·214)=돈0 BLOCKED 경계 보수성. **codex 보강**: 홀로그램/골드/실버/글리터류는 단순 색 라벨이 아닌 특수 원단·필름 가능성→W2 옵션화 시 소재/효과축 분리 검토(역방향 false-positive 가드).

### ZR-1 REVIVE 9건 COMMIT (인간 승인 "지금 실행")
- **COMMIT**(`_exec/zr1-*`·되돌리지말것): 9건 del_yn 'Y'→'N' 부활. 좀비 **83→74**(wires 140→128)·**깨진 옵션 참조 11→0 무결성 복구**·돈불변(단가행0)·멱등·백업 `bak_t_mat_materials_zr1revive_20260625_055716`(9행)·zr1-undo.sql.
- DRY-RUN 전항목 PASS(83→74·11→0·delta0·롤백 후 83 원상)·사후 재실측 PASS.
- ★메인 세션 직접 실행(실행기 서브에이전트가 조정자 전달 승인을 본인 승인으로 인정 거부=교착 → 사용자 본인 AskUserQuestion "지금 실행" 승인을 보유한 메인이 직접 안전 프로토콜 완주).

### 좀비 배선 트랙 마감 상태
- **처분: 13건 COMMIT(4+9) · OPTIONIZE 67→W2 · BLOCKED 7+돈변동 2(투명아크릴192 두께·유포지154→153 REWIRE)→실무진 확인큐.** 좀비 배선 92→**74 자재**(전부 OPTIONIZE/BLOCKED·REVIVE/REWIRE 대상 0=정합 결함 종결, 잔여는 옵션화/확인 트랙 의존).

### W2 CPQ 옵션화 1차 — 고신뢰 9그룹 라이브 COMMIT (자재→옵션값 전환)
- **설계**(dbm-option-mapper·`07_prereq/w2-optionize/`): 자재로 (오)등록된 색/투명도 변형을 §7 CPQ L2(polymorphic `OPT_REF_DIM.03`·ref_key1=mat_cd·ref_key2=usage_cd)로 옵션화. 3트랙=T1 면지(4종·책자4)·T2 굿즈 PET(투명도)·T3 OPTIONIZE 67.
- **★T3 정제**: 67건 일괄 옵션화 불가 — 다수가 해당 상품에 siz/print_options **차원행 0**이라 option_item 생성 시 트리거 거부 = **BLOCKED-needs-L1**(차원 선적재 선행·dbm-axis-staged-load 라우팅). 즉시 가능분은 색/투명도만.
- **codex 독립 2차**(w2-codex-reconcile.md·gpt-5.5 high): 합의 5·환각 0. **★머그컵(T2) HOLD 적발** — 같은 USAGE.07 4자재 중 2종만 "투명도"로 뽑은 분류 근거 불명·라이브 dflt/disp_seq 무차별로 구분 불가→상품마스터 재큐레이션+실무진 컨펌. N1(트리거 del_yn 미필터)→게이트 `del_yn='N'` 보완 내장. 링/D링 명세누락→CONFIRM 큐.
- **COMMIT**(`_exec/w2-*`·되돌리지말것): 고신뢰 **9 option_group / 29 option / 29 option_item**(T1 면지 4 + T3 즉시 5: PRD_072·077·082·088 면지색 / 140·142·197·198 색상 / 217 잉크7색). 채번 OPT_000064~072·OPV_000434~462(MAX+1 연속). 트리거 실 INSERT 통과 29/29·옵션 ref 활성자재 해소 29/29·FK고아0·멱등(ON CONFLICT DO NOTHING)·**돈영향 0**(단가행0). 백업 `bak_*_w2opt_20260624215218` 3종·w2-undo.sql. DRY-RUN 6검증 PASS·사후 재실측 PASS.
- **신규 mint = option layer만**(차원/자재/상품 신규 0·search-before-mint). 면지 disp_seq 권위=상품마스터 화이트→블랙→그레이→인쇄.
- **보류분**(w2-deferred.md): 머그컵 1그룹·BLOCKED-needs-L1 ~36(dbm-axis-staged-load)·CONFIRM ~30(소재효과축 홀로그램/골드/실버/글리터=실무진·구수=ref_param_json DDL·복합축=자재 정규화·단독배선·링/D링).

### ★셋트 가격 적재 착수 — 097 떡메모지 가격공식 바인딩 라이브 COMMIT
- **준비도 평가**(06_load/price-mint-readiness.md): 적재 대상 5건 중 **097만 READY**. ★권위 정정 — set-price-authority는 097을 "미바인딩·PRF 신설 필요"로 봤으나 **round-16(dbmap)이 PRF_TTEOKME_FIXED·COMP_TTEOKME·112 단가행·formula_components 전부 적재 완료**, 유일 단절=097 바인딩 0행. 신규 mint 0·선행의존 0.
- **072·077·082(책자 원자합산형)·100(포토북)=BLOCKED**: PRF·comp·단가·배선 전부 신규 민팅 + 선행 W1/W2(책자 제본비). 088=진성 미정(권위 "보류중"·실무진).
- **097 파일럿 종단 검증**: 게이트(S1~S7 FAIL0·evaluate_set_price 독립 손계산 골든 **60,000**[90x90/50장/30권]·**19,200**[70x120/100장/6권] 정확·이중합산0·bdl_qty∈NON_QTY_DIMS pricing.py:43·DRY-RUN 멱등) + codex(GO·6/6 합의·divergence0·환각0) **이중 GO**.
- **COMMIT**(`06_load/price-pilot-tteokme/`·되돌리지말것): t_prd_product_price_formulas 1행 INSERT(PRD_000097→PRF_TTEOKME_FIXED·apply_bgn_ymd=2026-06-01·PK=(prd_cd,apply_bgn_ymd)·ON CONFLICT 멱등). 바인딩 77→78·신규 mint 0·돈영향 현재 0(떡메 견적 올바르게 ON). 백업 `bak_*_tteokme_20260625_153807`·undo.sql. CFM-097(apply_bgn_ymd) 라이브 3중 정합 해소.
### ★072 하드커버책자 가격 민팅 — 셋트 하이브리드 아키텍처 확정 + 전 블로커 규명(설계·검증·DB 미적재)
- **반복 심층조사로 6비목 전부 규명**: 면지=무료(권위 "★인쇄면지는 하드커버링/레더링만"·082/088만 087/093 인쇄면지)·표지 전용지 "계산식"=계산공식집 seq9 용지비공통산식(아트150 국4절 절가 46.65)·코팅 이중계상 0(comp/use_dims 상이)·제본 COMP_BIND_HC_MUSEON del_yn=Y→COMP_BIND_SSABARI 대체·내지인쇄 COMP_PRINT_DIGITAL_S2(양면) del_yn=Y.
- **★S1/S2 정체 규명(돈 크리티컬 함정 회피)**: S1=단면·S2=양면(컨벤션·note·단가 S2=S1×2.0). 내지=양면→S2. "S1 단가 복제 mint"는 양면 내지를 단면가로 ~50% 과소청구 함정 → **S2 부활이 정답**(좀비 가격행 159/119 동형·부작용0).
- **★아키텍처 교정(사용자 지적)**: 직전 단일 번들 공식 PRF_HC_MUSEON_SUM은 **잘못된 레이어**. 코드 실측(evaluate_set_price pricing.py:718·price_views.py:1472/1656 뷰 레이어가 구성원별 fn_calc_pansu)으로 확정 — 올바른 §23 부품조립형 = **구성원별 공식(표지=PRF_HC_COVER 인쇄+코팅+용지) + 셋트 본체 공식(제본) + 면지 무료**, evaluate_set_price 합산. 표지 pansu(~3.8배 과소)·S1 PK 충돌·내지 BLOCKED·용지 슬롯 = 단일번들 인공문제·하이브리드서 자연 해소.
- **072 구성원 실측**: sets=표지073+면지074/075/076(4종 PRD_TYPE.02·공식0). ★내지가 sets 구성원이 아니라 본체 072 통합.
- **게이트+codex 이중 NO-GO(수렴)**: ★CFM-INNER-TOTSHEET(돈 크리티컬) — 내지 본체 통합이라 evaluate_set_price가 본체를 copies만 평가→총내지매수(페이지 곱) 미반영→내지인쇄 **~20배 과소청구**(20,800 vs 정석 407,500). + R-3 표지 자재 오류(46.65=MAT_000078 아트150 단독·MAT_000246 전용지 단가행0)·CFM-INNER-PAPER(내지 종이 자재 미등록). S2 부활·하이브리드·단일번들 폐기·제본 9000×50=450,000=옳음(3자 합의).
- **정석 해법(3자 합의·전부 dbmap 구조변경+인간승인)**: ① 내지를 별도 반제품 구성원 승격(sets 행+PRF_HC_INNER) ② PRF_HC_BODY=제본만 ③ 내지/표지 자재 등록 정정 ④ 표지 qty 뷰 조립 계약 명문화 ⑤ S2 부활 ⑥ 표지 펼침 siz 신설·A4 3절 절가(89.54) 적재.
- **COMMIT 0**: 비바인딩 PRF·S2 부활은 바인딩 없이 실효0이라 보류. ★현재 어느 책자도 바인딩 안 됨=라이브 과소청구 없음(전부 바인딩 전 적발). 077=표지 레더 정액·082=면지 유료(트윈링)·100=base24 별 모델로 전파 시 동형 구조변경 필요.

---

## 2026-06-24 — 하네스 초기 구성 + 엽서북 파일럿 종단 완주(라이브 COMMIT)

### 하네스 구성
- 6 에이전트(`hsp-authority-curator`∥`hsp-domain-researcher` 기준점 → `hsp-set-designer` 설계 → `hsp-codex-verifier` codex 독립 2차 → `hsp-set-gate` S1~S7 → `hsp-load-executor` 안전 적재) + 5 스킬(+ dbm-load-execution·hqv-codex-cross-verify·hpe-competitor-benchmark·rpm-live-reverse 재사용).
- 하이브리드 파이프라인. 생성≠검증·codex 주장=가설·search-before-mint·권위(상품마스터 260610) 절대·라이브 읽기전용(적재 Phase 5만 인간 승인 후 COMMIT).

### 사용자 확정 directive (Phase 0~1 충돌 해소)
- **셋트 = 부품조립형**: 셋트 완제품(prd_cd) ← 반제품 구성원(sub_prd_cd), `t_prd_product_sets`.
- **상품유형**: 기성·디자인 제외·완제품=단일 제조상품·반제품=구성원. 단 **셋트 부모는 01완제품으로 교정**(라이브 7셋트가 04디자인이었음 — directive 충돌→완제품 교정 결정).
- **작업 성격**: 기존 7셋트 보정+확장(빈 테이블 아님 — 라이브 28행/7셋트 실재 확정. 사전탐색 "0 vs 28" 충돌=28 확정).
- **가격**: 가격공식 있는 엽서북 먼저 종단 완주.
- **★면지 자재 정규화**: 자재의 화이트/그레이/인쇄/블랙면지(MAT_000001~004)는 용도성 오등록 → 삭제·출력소재(종이) 귀속·용도(면지)는 상품뷰어 자재추가 용도축 분리.

### 엽서북(PRD_000094) 파일럿 — GO(CONDITIONAL) → 라이브 COMMIT
- **적재 3 DML**(멱등·신규 mint 0): ① t_prd_products 유형 04→01 ② (94,95) 내지 min/max/incr=20/30/10 충전 ③ (94,96) 표지 disp_seq 보정.
- **S1~S7 전부 PASS**. S4 evaluate_set_price 재계산 = **450,000원**(20P·단면·100부)·PRICE≠0·이중합산 0.
- 백업 `bak_*_setbuild_20260624_0600`·undo 보유·사후검증 6항목 PASS·가격사슬 무손상.
- **★생성≠검증 실효 입증**: 설계·codex 모두 "30P 견적불가(comp 부재)"라 진단 → 게이트 라이브 실측이 "30P comp/단가행 실재하나 미바인딩 → 20P 단가로 **과소청구**(돈결함)"로 정정. 부재가 아니라 오청구·교정경로 정반대.
- codex AVAILABLE(gpt-5.5 high)·R-1~R-4 CLOSED(R-3 codex false-positive 기각).

### 라이브 t_prd_product_sets 실스키마 정정
- `semi_role_cd` 컬럼 **부재**(reuse-map "있음" 주장이 틀림) — 역할은 note로 표현. 적재본은 실스키마 컬럼만 사용.

### 미해결 / BLOCKED 라우팅 (인간 승인·별도 트랙)
- **RM-1 [돈결함]**: 30P 미바인딩 과소청구 → §18/dbmap 가격 트랙(30P comp 배선+페이지 차원 도입·신규 단가 생성 아님).
- **RM-2**: 면지 자재 4종 재배선(하드커버/링책자 PRD_000072/077/082/088·엽서북 N/A) → dbmap/basecode.
- **RM-3**: 나머지 6셋트(04디자인) 유형정책 확인 → 확장 phase.

### 동형 전파 2차 — 남은 6셋트 구조 보정 라이브 COMMIT (같은 날)
- 대상=하드커버책자(072)·레더 하드커버(077)·하드커버 링(082)·레더 링바인더(088)·떡메(097)·포토북(100).
- **적재 32 DML**: 6 UPDATE(유형 04→01·RM-3 정책=완제품 확정 해소) + 26 UPSERT(disp_seq 단조·note). min/max/incr는 **NULL 유지**(권위 침묵·내지 member 부재=MES별도설정·RM-4). 백업 `bak_*_setbuild_ext_20260624_0651`·되돌리지말것·사후검증 5 PASS·멱등 fingerprint 동일.
- **S1~S7 GO·codex AVAILABLE·D1~D5 CLOSED**. D1(유형 권위)=게이트가 094 선례+admin.py:1095(디자인 셋트부모 허용·반제품만 제외)+라이브 PRD_TYPE.04 셋트부모=정확히 이 6개뿐(타 영향0)으로 해소.
- **★택1 면지 합산0 재확인**: 면지/표지 평면 다중행(072 면지3·082/088 면지4·100 표지5)이 공식0·차원0이라 현재 합산 오염 0(행 보존이 정답). GUARD-1=가격 신설 시 평면합산 즉시 과대청구 → §18 가격설계서 옵션축 모델링 필수.
- **6셋트 전부 BLOCKED-PRICE(엽서북과 다름)**: 셋트공식·구성원공식 **진성 부재** → PRICE=0 견적불가(엽서북 30P "미바인딩 오청구"보다 무거움). §18 셋트 제본/조립 공식 신설 라우팅.

### 현재 상태 (7/7 셋트 구조 보정 완료)
- 7 셋트 부모 유형 전부 01완제품 교정·disp_seq 정규화 라이브 반영. 엽서북만 가격 견적 가능(20P·450,000원), 나머지 6셋트는 가격공식 부재로 견적불가.

### ★하네스 진화 + 권위 재큐레이션 (계산공식집 시트 누락 적발·같은 날)
- **누락 적발(사용자)**: Phase 1 큐레이터가 booklet-l1(구성)만 보고 상품마스터 **"계산공식집" 시트**(`calc-formula-draft-l1.csv`)를 안 봄 → "6셋트 셋트공식 진성 부재 → §18 신설"이 **오프레이밍**. 실제 권위엔 공식 명시 존재.
- **하네스 보완**: hsp-authority-curator/curation·hsp-set-gate(S4)·orchestrator에 **계산공식집 시트 필수화 + BLOCKED-PRICE "2층 구분"**(권위 공식 존재+라이브 미적재=적재 대상 vs 진성 부재=신설) 강제.
- **권위 재큐레이션 결과**(set-price-authority.md): 7셋트 권위 공식 추출 — 원자합산형(072/077 하드커버무선 6비목·082/088 하드커버링 8비목·표지/면지×2)·고정가형(094/097 `(가격포함)`)·통합형(100 포토북). **§18 PRF_BIND_* 대조 일치 6/7·갭 0**.
- **2층 재분류**: 적재 대상(전사) **5건**(072·077·082·097·100) · 적재됨(결함) **1건**(094 엽서북 silent 이중합산+prc_typ×qty §18 R-3) · 진성 미정 **1건**(088 권위 보류중) · **진성 부재 0건**. CONFIRM-3(포토북) 해소.
- 단 §18 설계 PRF(PRF_HC_MUSEON_SUM 등)는 **라이브 미민팅(설계 제안 단계)** — 라이브엔 PRF_BIND_SUM(stale)·PRF_PCB_FIXED(094)만.

### ★자재 기초데이터 총점검 + W1 계층 부활 라이브 COMMIT (가격 적재 선행조건·같은 날)
- **사용자 directive**: 가격 적재 전 자재 정합 라이브 확인. 자재=실 재고품만·출력소재는 상위자재→자재 계층·면지/내지/표지=용도(자재 아님)·상품마스터 적재 원칙 반영 여부.
- **전수 총점검**(07_prereq/full-audit): t_mat_materials 343(활성194/삭제149). 출력소재 110 중 **종이 family root 9 전멸→고아64**. 비출력 활성96% 정당 stock·오염8. ★진짜 위기="논리삭제 정합 붕괴"(고아64+좀비배선92+좀비가격행2 돈영향). **그릇 합격·데이터 불합격**(상품마스터 적재가 자재 vs 용도 원칙 미반영).
- **결정**: 면지=색상 택1 CPQ 옵션화(자재 4종 정리·인쇄면지만 실 stock 유지). 상위자재 13 del_yn=Y=오류→부활. 자재 교정 먼저(돈 제외).
- **W1 계층 부활 COMMIT**(07_prereq/remediation/_exec·되돌리지말것): 종이 root 9+전용지=**10행 del_yn Y→N**·자식41 계층복구·**FK 고아 64→23**·돈0·멱등·백업 bak_*_w1_20260624_1137·undo 보유. ★dbm-validator가 설계의 "전 9root 부작용없음" 오단언 적발(생성≠검증)=투명/반투명 PET 굿즈 USAGE.07 오배선. 굿즈 PET=**CONFIRM 분리**(상품마스터가 투명/반투명을 머그컵/키링 정당 선택옵션 등재→스퓨리어스 아님·올바른 굿즈 투명자재 부재→면지 동형 CPQ 옵션 트랙·추측 COMMIT 거부).

### ★좀비 가격행 판정 + 부활 COMMIT (돈크리티컬·같은 날)
- dbm-price-arbiter 전수 판정(07_prereq/zombie-price): MAT_000159 모조120g(단가행20=봉투 COMP_ENV_MAKING)·MAT_000119 리브스250g(단가행1=COMP_PAPER) **둘 다 고유·유효**(원 의심 159=073 동일물 기각·073 봉투가격행0=병합슬롯 부재). 21 단가행 중복0·전부 분할.
- ★결정적: `pricing.py:259 _component_rows`가 comp_cd만 필터·**자재 del_yn JOIN 없음** → 삭제 자재도 단가가 견적 도달=**현행 라이브 이미 좀비 단가로 청구 중**. 단순 삭제 정리했으면 봉투 0원/전단지 저청구 돈결함 유발(함정 회피).
- **부활 COMMIT**(07_prereq/zombie-price/_exec·되돌리지말것): 159·119 del_yn Y→N **2 UPDATE**·단가행/배선 0변경·**견적 골든 diff=0**(봉투 96,000/672,000·전단지 500/판 전후 동일=청구 불변)·백업 bak_*_zombie_20260624_1250·undo. 권고2(죽은 119 배선)·CONFIRM(159=073 통합·119 root) 제외.

### 다음 시작점 (정정 2026-06-25 셋트 가격 적재 착수 후) — ★상세 HANDOFF.md 참조
**셋트 가격 적재**: 097 떡메모지 바인딩 COMMIT 완료(고정가형). 책자류 가격은 **셋트 하이브리드 모델**이 정석(구성원별 공식+셋트 제본)으로 확정. **072 다음 시작점=내지 반제품 구성원 승격(dbmap 구조변경+인간승인)** → 그 후 PRF_HC_INNER/COVER/제본 민팅+바인딩. 077/082/100 동형 전파. 자재 잔여(W2 보류분·돈변동 2·NO_ROOT)는 아래.

(이하 자재 선행조건 잔여 — 가격 적재와 병행)
**자재 W1(종이 계층)+좀비 가격행+좀비 배선(4+9건)+W2 1차(9그룹/29옵션) COMMIT 완료.** 자재 잔여: ① **W2 보류분 처리** — 머그컵(실무진 컨펌)·BLOCKED-needs-L1 ~36(dbm-axis-staged-load로 siz/print_options 차원 선적재 후 옵션화)·CONFIRM ~30(소재효과축 홀로그램/골드/실버/글리터=실무진·구수 ref_param_json DDL·복합축 자재정규화·링/D링) ② **돈변동 2건 실무진 확인큐**(투명아크릴192 정본 두께 1.5/3mm·유포지154→정본153 REWIRE 돈변동) ③ 31 NO_ROOT·비종이 root 4 CONFIRM ④ 권고2 죽은 119 배선·CONFIRM 159=073 통합. **그 후 가격 적재**: 적재 대상 5셋트 §18 PRF→t_prc_* 민팅+바인딩 ·097 고정가 신설 ·094 결함 교정(이중합산+prc_typ×qty·30P) ·088 실무진. 권위·설계 갖춰짐(신설 아닌 적재). ★자재 논리삭제 결함(고아·좀비가격·좀비배선) 3건 종결 + 핵심 색/면지 옵션화 1차 완료 → 셋트 가격 적재 선행조건 실질 충족(잔여는 옵션 확장·실무진 컨펌 의존).
