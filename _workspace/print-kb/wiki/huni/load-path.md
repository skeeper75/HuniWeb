# 적재 경로 (Load Path) — 횡단 축

> huni 레이어(분석대상). webadmin 적재 단계·FK 위상·멱등 패턴을 원자 항목으로 분리해 레시피가 `loaded-via`로 조립한다.
> 앵커: `raw/webadmin/sql/*`(적재 oracle DDL+seed) · `tools/load_master.py`·`load_discounts.py`(적재 로직) · round-8 `13_admin-ui-spec/`(입력경로).
> **[HARD] v03 입력 xlsx 인용 금지**(round-13 결함 진원 ③). load_master는 **로직(전파기)만** oracle. **"컬럼 존재 ≠ 백필 완료"** 분리.
> 큐레이션 팩: `_curation/axis-load-path.md`.

---

## 1. 적재 oracle·로직

### [LP-001] 적재 oracle = sql/01a~23 + load 로직  {✅}
- 내용: 라이브 DB 스키마·코드값·적재의 **소스 오브 트루스 = webadmin** `raw/webadmin/sql/01a~23_*.sql`(DDL+seed) + `tools/load_master.py`(상품마스터 전파)·`load_discounts.py`(구간할인). `models.py`는 inspectdb 거울일 뿐 적재 로직 아님.
- 앵커: `raw/webadmin/sql/01a~23_*.sql` · `tools/load_master.py`·`load_discounts.py`
- 출처: `raw/webadmin/sql/01a~23_*.sql` + `raw/webadmin/tools/load_master.py`(로직만) {tier A, FRESH(HEAD bd12d03)}
- 연결: [[#LP-STALE]] (v03 입력 금지) · [[#LP-002]]
- 사용처: [[recipes/booklet#BK-LP-001]] (책자 load_master 10·11~21 시트 적재) · [[recipes/digital-print#DGP-LP-001]] (loaded-via — 디지털인쇄 적재 oracle·v03 금지) · [[recipes/sticker#STK-LP-001]] (loaded-via — 스티커 v03 전파기) · [[recipes/photobook#PB-LP-001]] (loaded-via — 포토북 load_master·가격 함수 부재) · [[recipes/acrylic#AC-LP-001]] (loaded-via — 적재 oracle) · [[recipes/calendar#CAL-LP-001]] (loaded-via — 캘린더 load_master 순수 전파기)
- answers_cq: CQ-PROD-01 (상품 분류·적재 기준) · CQ-TERM-07 (코드체계 적재)
- tags: #적재 #oracle #webadmin #load_master

### [LP-002] 배포 객체 기대치 (테이블45·FK73·인덱스62·트리거37)  {✅}
- 내용: 배포 시 기대 객체 수 = **테이블 45 · FK 73 · 인덱스 62 · 트리거 37**(`deploy.py`). 적재 후 객체 수 검증 기준선. CPQ 트리거·가격 트리거 포함.
- 앵커: `raw/webadmin/tools/deploy.py` (객체 기대치)
- 출처: `raw/webadmin/tools/deploy.py` {tier A, FRESH}
- 연결: [[#LP-001]] · [[cpq-options#CPQ-003]] (트리거)
- 사용처: _(레시피 집필 시 채움)_
- tags: #적재 #배포 #객체기대치

---

## 2. FK 위상·멱등 패턴

### [LP-003] FK 위상순서 · 코드행 선적재  {🟡}
- 내용: 적재는 **FK 의존 위상순서**로(코드값 그룹 → 마스터 코드행 → 상품 → 상품-자식). CPQ option_item은 차원행 선적재 필수(트리거 [[cpq-options#CPQ-003]]). 코드값은 `t_cod_base_codes`에 14개 코드 그룹(`BASE_CODE_GROUP`)으로 적재된다 — **[W3] `BASE_CODE_GROUP`은 컬럼명이 아니라 적재 로직(loadspec) 상의 그룹 단위**이며, 라이브 그룹핑은 `t_cod_base_codes.upr_cod_cd`(상위코드) 계층으로 표현된다(`cod_grp_cd` 컬럼 부존재 — [[materials#MAT-003]]).
- 앵커: `t_cod_base_codes`(`upr_cod_cd` 계층) · `00_schema/code-identifier-strategy.md` + `15_domain-spec/<family>/mapping-info.md`
- 출처: `00_schema/code-identifier-strategy.md`(전략 FRESH) + `15_domain-spec/<family>/mapping-info.md`(PARTIAL: I-6) {tier C}
- 연결: [[#LP-004]] · [[cpq-options#CPQ-003]] (requires — 차원행 선적재 트리거) · [[materials#MAT-003]] (mapped-to — t_cod_base_codes)
- 사용처: [[recipes/booklet#BK-LP-001]] (책자 FK 위상 적재) · [[recipes/digital-print#DGP-LP-002]] (loaded-via — 디지털인쇄 FK 위상·코드행) · [[recipes/sticker#STK-LP-002]] (loaded-via — 스티커 FK 위상·코드행) · [[recipes/photobook#PB-LP-001]] (loaded-via — 포토북 FK 위상·sets B셋트) · [[recipes/acrylic#AC-LP-002]] (loaded-via — FK 위상·코드행 선적재) · [[recipes/calendar#CAL-LP-001]] (uses — 캘린더 FK 위상·코드행 선적재)
- answers_cq: CQ-FILE-05 (조판/임포지션 적재 입력값)
- tags: #적재 #FK위상 #코드행선적재 #BASE_CODE_GROUP

### [LP-004] 멱등 패턴 = 이름 기반 UPSERT · search-before-mint  {🟡}
- 내용: 적재 멱등성 = **이름(prd_cd+_nm) 기반 UPSERT**(신규 DDL 0) + **search-before-mint**(코드 신설 전 기존 검색 — 원형35mm=SIZ_000422 같은 중복 채번 방지). 채번 = MAX+1, separator `_` 통일(CPQ 하이픈 폐기). silsa CPQ 43행 재-dryrun delta 0으로 멱등 실증.
- 앵커: ON CONFLICT (이름 기반) + 채번 MAX+1
- 출처: 메모리 `dbmap-code-identifier-strategy`·`dbmap-no-db-load-file-first` {tier C, FRESH}
- 연결: [[#LP-005]] (PK 주의) · [[price-engine#PE-003]]
- 사용처: [[recipes/digital-print#DGP-LP-002]] (loaded-via — 봉투 template 재사용·separator) · [[recipes/digital-print#DGP-DM-004]] (loaded-via — 묶음수 멱등) · [[recipes/sticker#STK-LP-002]] (loaded-via — 스티커 search-before-mint 030~047) · [[recipes/photobook#PB-LP-001]] (loaded-via — 포토북 멱등·search-before-mint) · [[recipes/acrylic#AC-LP-002]] (loaded-via — 멱등 UPSERT) · [[recipes/calendar#CAL-ST-DEF-004]] (멱등 — plate 재적재 .01→.03 퇴행 위험) · [[recipes/calendar#CAL-ST-DEF-007]] (search-before-mint — 삼각대거치 공정 마스터 부재 입증)
- tags: #적재 #멱등 #UPSERT #search-before-mint #채번

### [LP-005] 가격 ON CONFLICT 새 PK = (prd_cd, apply_bgn_ymd)  {🟡}
- 내용: impact-diagnosis I-7 — 가격공식 PK가 통합됨. **`09_load/_exec*/` 적재 SQL이 구 PK(frm_cd/dsc_tbl_cd 포함)면 멱등 UPSERT 충돌** → 새 PK (prd_cd, apply_bgn_ymd)로 갱신 필요. PARTIAL-STALE(round-13 교정 전 적재본).
- 앵커: 가격공식 ON CONFLICT (prd_cd, apply_bgn_ymd)
- 출처: `18_schema-change/impact-diagnosis.md` I-7 + `09_load/_exec*/` {tier A/C, PARTIAL-STALE}
- 연결: [[price-engine#PE-003]] · [[#LP-STALE]]
- 사용처: _(레시피 집필 시 채움)_
- tags: #적재 #ON_CONFLICT #PK #I-7

---

## 3. admin 입력경로 · 백필 분리

### [LP-006] admin UI 입력경로 (34 t_* 332컬럼) · 컬럼 존재 ≠ 백필 완료  {🟡}
- 내용: 비개발 운영자 입력경로 = admin product-viewer pvEdit 섹션 + catalog Django change form. round-8이 34 t_* 332컬럼 입력법 정의(입력경로 FRESH). **[HARD] "컬럼 존재 ≠ 백필 완료"**: Phase11이 신설한 차원 컬럼(proc_cd/opt_cd 0행)·template_prices(0행)는 DDL은 반영됐으나 **데이터 백필 미완** — 라이브에 컬럼이 있다고 값이 채워졌다고 단정 금지.
- 앵커: `13_admin-ui-spec/admin-ui-spec.md`·`entities/` + product-viewer pvEdit
- 출처: `13_admin-ui-spec/admin-ui-spec.md`·`entities/`(입력경로 FRESH) + `18_schema-change/impact-diagnosis.md`(백필 미완) {tier C/A, PARTIAL-STALE: I-10·I-11}
- 연결: [[price-engine#PE-002]] (백필 0행) · [[price-engine#PE-004]] (template_prices 0행)
- 사용처: [[recipes/sticker#STK-LP-002]] (loaded-via — 스티커 admin pvEdit 입력경로) · [[recipes/acrylic#AC-LP-002]] (loaded-via — admin 입력경로)
- answers_cq: CQ-FILE-01 (파일 입고 상태머신·운영자 입력경로)
- tags: #적재 #adminUI #입력경로 #백필미완 #컬럼존재≠백필

### [LP-007] 실 적재 현황 = "GO분 적재됨 · 차단/결정분 미적재"  {🟡}
- 내용: 적재 원칙 갱신 — **GO분은 라이브 COMMIT됨**(인쇄가격 3,504행·상품마스터 398행·디지털 308행 등), **차단/결정분만 미적재**. round-7 D-1 교훈: "LOADED=행 존재만"(변형 커버리지 미검증). 라이브값 = 교정대상([LP-STALE]).
- 앵커: CLAUDE.md §7 진행상태 + `09_load/_exec*/` 매니페스트
- 출처: CLAUDE.md §7 진행상태 + `09_load/_exec*/` {tier C, FRESH}
- 연결: [[#LP-STALE]] · 메모리 `dbmap-round5-load-execution`
- 사용처: [[recipes/digital-print#DGP-DM-003]] (loaded-via — plate 값정답·경로불명) · [[recipes/digital-print#DGP-PR-002]] (디지털 308행 적재·차단 잔존) · [[recipes/calendar#CAL-LP-002]] (캘린더 GO분 적재됨·미적재/drift 구분)
- tags: #적재 #현황 #GO분적재 #LOADED=행존재만

---

## 4. STALE 함정 (인용 금지)

### [LP-STALE] v03 입력 xlsx · constraint_json/dep_proc_cd 적재 타깃 = STALE  {🔴 STALE}
- 내용: ① **[HARD] v03 입력 xlsx 인용 금지** — `load_master.py:39` 입력 `prdmaster_full_migration_v03_20260518.xlsx`는 round-13 결함 진원 ③. 정답=상품마스터 L1(B-L1-PM). load_master **로직(전파기)만** oracle. ② **constraint_json/dep_proc_cd 적재 타깃 STALE**(I-5·I-6) — `_loadspec/loadspec.md` L79(constraint_json)·L96(dep_proc_cd) 컬럼 삭제됨. 제약=constraints.logic·게이팅=대체경로(미확정). ③ template_prices 누락(I-4)도 loadspec 미반영. ④ 라이브 적재값 = 교정대상(round-13, correction-manifest 대조).
- 출처: `raw/webadmin/tools/load_master.py:39`(v03 입력) + `18_schema-change/impact-diagnosis.md` I-4·I-5·I-6 + round-13 {tier A}
- 연결: [[materials#MAT-GAP-3]] · [[cpq-options#CPQ-STALE]] · [[#LP-001]]
- tags: #STALE #v03금지 #constraint_json #dep_proc_cd #인용금지

---

## 5. GAP (미모델링·미결)

### [LP-GAP-1] v03 상류 수정 vs DB 직접 교정 미결 (BATCH-12)  {🔴}
- 내용: 결함 진원 v03 상류를 고칠지 DB를 직접 교정할지 미결.
- 출처: `_curation/axis-load-path.md` GAP-LP-1 · `_crosscut/` BATCH-12 {tier C}
- 연결: [[#LP-STALE]]
- 사용처: [[recipes/calendar#CAL-ST-DEF-013]] (캘린더 v03 상류 vs DB 직접 BATCH-12) · [[recipes/calendar#CAL-LP-002]] (캘린더 결함 진원=상류 v03/스키마 drift)
- tags: #GAP #v03상류 #BATCH-12

### [LP-GAP-2] template_prices 적재 경로 미반영 (SKU 가격 오버라이드 I-4)  {🔴}
- 내용: template_prices(I-4) 적재 경로가 loadspec에 미반영.
- 출처: `_curation/axis-load-path.md` GAP-LP-2 · impact-diagnosis I-4 {tier A}
- 연결: [[price-engine#PE-004]]
- tags: #GAP #template_prices #I-4

### [LP-GAP-3] 카테고리 고아 113상품 재연결 미적재 (BATCH-1·9 family)  {🔴}
- 내용: round-13 횡단 — 카테고리 고아 113상품 재연결 미적재.
- 출처: `_curation/axis-load-path.md` GAP-LP-3 · `_crosscut/` BATCH-1 {tier C}
- 연결: [[#LP-003]]
- 사용처: [[recipes/digital-print#DGP-ST-001]] (디지털인쇄 배경지/상품권/라벨택 카테고리 고아 5상품)
- tags: #GAP #카테고리고아 #BATCH-1

### [LP-GAP-4] 실 교정 COMMIT 인간 승인 대기  {🔴}
- 내용: round-5/6/10 교정 + 신규 교정의 실 COMMIT은 인간 승인 대기.
- 출처: `_curation/axis-load-path.md` GAP-LP-4 {tier C}
- 연결: [[#LP-007]]
- 사용처: [[recipes/acrylic#GAP-AC-7]] (아크릴 실 교정 COMMIT 승인 대기)
- tags: #GAP #COMMIT승인대기

---

## Sources
- 큐레이션 팩: `_curation/axis-load-path.md`
- 정답: `raw/webadmin/sql/01a~23_*.sql`; `raw/webadmin/tools/load_master.py`(로직만)·`load_discounts.py`·`deploy.py`; `raw/webadmin/docs/entity-table-map.md`·`fk-action-policy.md`·`naming-guide.md`·`handoff-2026-06-11.md`; `00_schema/code-identifier-strategy.md`; `15_domain-spec/<family>/mapping-info.md`; `13_admin-ui-spec/admin-ui-spec.md`·`entities/`; `09_load/<family>/`·`09_load/_exec*/`; `17_correctness/<family>/loadlogic-notes.md`.
- 보조: `huni-admin-manual/manual/02_product-register.md`·`07_masters.md`.
- freshness: `18_schema-change/impact-diagnosis.md` I-4·I-5·I-6·I-7·I-10·I-11.
- 메모리: `dbmap-no-db-load-file-first`·`dbmap-code-identifier-strategy`·`dbmap-schema-design-intent-first`·`dbmap-round5-load-execution`·`dbmap-schema-change-round14`.
- **STALE(인용 금지):** v03 입력 xlsx(`load_master.py:39`); `_loadspec/loadspec.md` L79(constraint_json, I-5)·L96(dep_proc_cd, I-6); ON CONFLICT 구 PK(I-7); 라이브 적재값 직접 단정(round-13 교정대상).
