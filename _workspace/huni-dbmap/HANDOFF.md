# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-09(최신·round-9). 권위 = 본 문서 + 메모리 `dbmap-code-identifier-strategy`·`dbmap-option-material-process-bundle`·`dbmap-schema-design-intent-first`·`dbmap-live-admin-product-viewer`·`dbmap-l2-requires-l1-price-table`·`dbmap-admin-ui-spec`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄·CPQ·round-6 현수막·round-7 커버리지) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황 (round-9 — 2026-06-09)
**silsa(PRD_000138) CPQ 옵션 레이어 43행 라이브 COMMIT 완료 — CPQ 옵션 레이어가 라이브 운영 DB에 최초로 성립(option_items 전역 0→18).** 코드 식별자 전략 비준(D1~D5: 순차 surrogate PK·이름기반 멱등·separator `_` 통일·생성메커니즘 별도트랙 — `00_schema/code-identifier-strategy.md`, expert-backend 독립검토 CONFIRM-WITH-ADJ). 적재본 `09_load/_exec_silsa_cpq/`(자재mint4[큐방 MAT_000337·각목LE/GT 338/339·봉제사 340]+공정mint1[열재단 PROC_000084]+링크7+그룹2[OPT_000003 가공·OPT_000004 추가]+옵션11[OPV_000006~16]+옵션항목18) → 독립게이트 `03_validation/silsa-cpq-load-gate.md` GO → `./apply.sh commit` 43행 COMMIT → 라이브 실측 일치 + 재-dryrun delta 0 멱등 실증. 큐방=mint(사용자 승인). **잔여 BLOCKED 처리 완료(2026-06-09): 각목을 방향(세로/가로) 옵션으로 재모델→R-GAKMOK 제약 폐기(높이-매칭 불요·길이는 변 치수서 도출·900구간=가격엔진 length-tier)·각목 자재 1개 통합(MAT_000338 "각목", MAT_000339 soft-delete)** — `09_load/_exec_silsa_cpq_remodel/` 6 UPDATE COMMIT·멱등 실증. enum 2[CONFIRM](큐방·양면테입 부착)=ref_param_json 부재라 ddl-proposer 트랙(적재 대상 아님). 전 11시트 OTC 인벤토리 `10_configurator/all-sheets-otc-extract.md` 완료(widening 토대) + OTC [CONFIRM] 6건 확정(C-2/3/5/6 사용자·C-1/4 리서치 `cpq-confirm-research-c1-c4.md`).

**엽서(PRD_000016) CPQ 적재본 빌드됨·DRY-RUN GO — 그러나 COMMIT 미실행(보류).** `09_load/_exec_postcard_cpq/`(29 INSERT+1 UPDATE: groups5·options13·items4·template1·selection1·addons2·constraints3·constraint_json·BLOCKED 5[후가공 PROC_029~032·종이*별도설정 차원 0행]). **빌더가 카드봉투 base를 PRD_000004로 잘못 잡음.**

**[방법론 전환 — 사용자 directive 2026-06-09·다음 세션 최우선] 기계적 매핑 중단.** 카드봉투 사례(PRD_000004의 SIZ_000104="화이트…"·SIZ_000105="블랙…" = **색이 SIZE에 인코딩**됨, 반면 PRD_000281 카드봉투(화이트)·PRD_000282 카드봉투(블랙)는 별도 상품인데 사이즈 미적재)가 "같은 값을 잘못된 t_*에 매핑"하는 위험을 노출. **적재 전에 스키마 설계의도를 먼저 파악해야 함** — 각 t_* 엔티티/속성이 *왜* 그렇게 설계됐는지 + 인쇄상품 구성요소의 **삼중 바인딩(① UI 어떤 componentType ② 생산 자재/공정 BOM·MES ③ 가격 가격엔진 연결)**을 RedPrinting 역공학(componenttype-mapping-matrix·cascade-rules·가격API·MES) 참조로 정립. 이게 권위가 되면 "카드봉투를 어디 넣나"는 추측 아닌 도출.
> 이전: **round-8 admin UI 입력 명세 완료(GO)** — admin product-viewer 34 t_* 332컬럼 전수 정의(`13_admin-ui-spec/`). 상세는 CHANGELOG.

## 이번 세션(round-9) 핵심 결정·발견 (재논의 금지)
- **코드 식별자 전략 D1~D5 비준** — 순차 surrogate PK + **이름(prd_cd+`*_nm`) 기반 멱등(신규 DDL 0)** + separator `_` 통일(CPQ 하이픈 폐기) + 코드생성 메커니즘 별도트랙. 채번=라이브 MAX+1·`_`. 권위 `00_schema/code-identifier-strategy.md`([[dbmap-code-identifier-strategy]]). silsa 적재로 멱등 실증(COMMIT 후 재-dryrun delta 0).
- **silsa CPQ 43행 라이브 COMMIT 완료** + 각목 방향(세로/가로) 재모델·R-GAKMOK 제약 폐기(비규격이라 siz집합/숫자var 부적합→파생옵션으로 제약 소멸). 큐방=mint. [[dbmap-option-material-process-bundle]] 갱신.
- **OTC [CONFIRM] 6건 확정**: C-1 볼체인/리필잉크=**TEMPLATE**(후니 리필잉크=PRD_000015 독립상품·WowPress 부자재 별도SKU) · C-2 만년스탬프 잉크색≠도수(도수=인쇄전용) · C-3 booklet 면지/바인더링=자재(트윈링/하드커버 붙임시 자재+공정 BUNDLE) · C-4 우드거치대=가공컬럼 OPTION/추가상품컬럼 TEMPLATE 분기(WowPress 40210/40211) · C-5 50장1권=제본+묶음수 · C-6 굿즈 화이트M/L=한덩어리(분할금지). 권위 `all-sheets-otc-extract.md §15`+`cpq-confirm-research-c1-c4.md`.
- **[HARD·사용자 방법론] 기계적 매핑 금지 → 스키마 설계의도 선행.** 같은 엑셀 값을 잘못된 t_*에 넣는 위험(카드봉투 색=siz). 적재 전 "왜 이 스키마인가 + 삼중 바인딩(UI·생산·가격)"을 RedPrinting 역공학 참조로 정립. 이게 권위가 되면 매핑은 도출.
- **[교훈] 에이전트 위임이 최종 텍스트를 "완료/Complete"로만 반환하는 실패모드** — 산출 파일/게이트를 직접 읽어 회수. 사용자가 영어 위임 지시문에 혼란 + 호출이 자꾸 끊김 → **다음 세션은 가능하면 인라인(한국어·보이게) 진행 선호.**

## 다음 시작점 (정확한 다음 행동 — 순서대로)
1. **[최우선] 스키마 설계의도 지도 작성** — `00_schema/schema-design-intent-map.md`(미작성). 4부: ① t_* Mermaid ERD(FK·polymorphic ref_dim·트리거·가격사슬, 도메인 클러스터) ② 각 핵심 t_*의 WHY(설계 의도·무엇을 담으면 안 되나) ③ 인쇄상품 구성요소{사이즈·소재·인쇄·도수·후가공·제본·추가상품·수량·가격·제약} → t_* 귀속 + **삼중 바인딩(UI componentType / 생산 자재·공정 BOM·MES / 가격 엔진)** decision table ④ 라이브 현재 진단 + 오모델 목록(카드봉투 색=siz 등). 권위 입력=`cpq-design.md`·`attribute-entity-map.md`·`option-vs-template-guide.md` + RedPrinting 역공학(`_workspace/huni-widget/03_spec/componenttype-mapping-matrix.md`·`02_analysis/cascade-rules.md`·`docs/reversing/*.html` 가격API/MES). **인라인 한국어로 진행(에이전트 위임이 자꾸 끊김·영어 혼란).** 1회성·재사용 권위.
2. **[그 다음] 카드봉투 재모델** — 지도 ③④ 도출대로: 색(화이트/블랙)=상품 정체(PRD_000281/282) vs siz 결정. PRD_000281/282에 사이즈·가격 적재 필요 여부 판단. 엽서 추가상품 연결(template base)을 그 모델로 정정.
3. **[그 다음] 엽서 CPQ COMMIT** — `09_load/_exec_postcard_cpq/` 빌드됨(DRY-RUN GO). **카드봉투 base PRD_000004→정정(2번 결과)** 후 dbm-validator 독립 게이트 → COMMIT(silsa 패턴). BLOCKED 5(후가공/종이 차원 0행)는 정직 분리.
4. **[그 다음] 상품군 확장** — 설계의도 지도 위에서 calendar(C-4 우드거치대 분기·봉투 template·GRP 택일) → acrylic/goods-pouch(C-1 볼체인/리필잉크 template·C-6 합성) → booklet(C-3). `_exec_<family>_cpq/` 동일 패턴.
5. **[이월·낮음] GAP-PARAM DDL 제안**(ref_param_json·ddl-proposer)·**round-6 일반현수막 가격 siz 77 적재**(인간 승인). CHANGELOG.

## 미해결 / 블로커
- **[최우선] 스키마 설계의도 지도 미작성** — 이게 없으면 매핑이 기계적이 되어 잘못된 t_*에 적재(카드봉투 색=siz가 증거). 다음 시작점 #1.
- **엽서 카드봉투 base 오모델** — `_exec_postcard_cpq/`가 PRD_000004(범용·색이 siz)를 base로 잡음. PRD_000281(화이트)/PRD_000282(블랙) 별도상품이 맞으나 사이즈·가격 미적재. 설계의도 지도 후 정정→COMMIT.
- **엽서 CPQ COMMIT 보류** — 빌드+DRY-RUN GO이나 카드봉투 정정 전 COMMIT 금지.
- **GAP-PARAM**: option_items에 ref_param_json 부재 → 타공 구수·각목 규격 등 파라미터형은 별 옵션/별 코드로 우회. ALTER=ddl-proposer(인간 승인).
- **이전 트랙 잔존**(CHANGELOG): round-6 일반현수막 가격 siz 77·디지털인쇄 잔존차단(3절/투명/박)·DB-ONLY 17셀 판별·excl_group 마이그.

## 건드리지 말 것 (확정·검증 완료·라이브 COMMIT)
- **라이브 COMMIT분(되돌리지 말 것)**: silsa CPQ 43행(`_exec_silsa_cpq/`) + 각목 재모델(`_exec_silsa_cpq_remodel/`). 멱등 실증 완료.
- `_workspace/huni-dbmap/00_schema/code-identifier-strategy.md` — 코드 전략 D1~D5(사용자 비준·독립검토). `10_configurator/all-sheets-otc-extract.md`(§15 6결정)·`cpq-confirm-research-c1-c4.md`·`option-vs-template-guide.md` — OTC 권위.
- `_exec_postcard_cpq/` — 엽서 빌드본(카드봉투 base만 정정 대상, 나머지 GO).
- `13_admin-ui-spec/`·`admin-ui-spec-gate.md`·`12_coverage/` — round-7/8 GO.
- `.env.local` `RAILWAY_DB_*`·`HUNI_ADMIN_*` — 자격증명(chmod 600·gitignored). 이전 GO·COMMIT분(CHANGELOG).
