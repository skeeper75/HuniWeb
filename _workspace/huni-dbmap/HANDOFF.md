# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-07(최신). 권위 goal=`docs/goal-2026-06-06-02.md`. 본 문서 + `09_load/_exec/load-decision-request.md`(결정 종합) + 각 `_migrate_*/MIGRATION.md` + 메모리(아래 결정)를 읽으면 재발견 0으로 재개. 이전 round-2/4/5 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
"html(product-viewer)을 토대로 전체 상품마스터+인쇄가격 적재" 진행 중. **GO분은 실제 라이브 적재 완료**(가격 3,504행+상품마스터 398행). **2026-06-07 세션**: round-5 미적재 7개 차단 전수 분석 + **GP원형 빌드(GO)·ENV 매핑 설계(검증 GO)·박 매핑 설계(검증 CONDITIONAL-GO, BLOCKER-1)·자재-옵션 정규화 설계(WowPress 벤치마크)** 진행. 핵심 아키텍처 원리 확정(중간계산=앱·DB=룩업). 남은 차단은 후니 도메인 결정·인간 승인(라이브 DRY-RUN·COMMIT·siz등록·마이그레이션·DDL).

## 다음 시작점 (정확한 다음 행동)
1. **[✅ 빌드 완료 2026-06-06] GP 합판도무송 원형 — `09_load/_migrate_gp_circle/`** — GP 원형(10~60mm) = sticker 066 원형과 동일 직경 입증(가격 `COMP_GANGPAN_PRINT` 100행 = `SIZ_PENDING_GP_원형*` 35제외, sticker siz `SIZ_000501~510` 공유·신규등록 0). 빌드(siz10+가격100+sticker066 size11) + 로컬게이트 **G1~G9·R1~R4·R6 PASS**(게이트 `03_validation/load-execution-gate-gp-circle.md` = GO-PENDING-LIVE-DRYRUN). **다음 행동: ① 리드 승인 후 라이브 롤백 DRY-RUN(R5) → ② 후니 siz 10등록 → ③ `apply.sh --commit`.** MINOR 3건(F-1 reg_dt 배치TS·F-3 undo 비대칭, 차단 아님).
2. **[✅ 검증 GO 2026-06-07] ENV 봉투 — `02_mapping/price-envelope-mapping.md`** — 봉투 4종 작업사이즈(상품마스터 디지털인쇄 봉투제작 003-0015: 티켓225×193/소238×262/자켓262×238/대510×387)가 라이브 siz `SIZ_000191~194` **EXACT 재사용(mint 0·바인딩 PRD_000050→PRF_ENV_MAKING 선존재)**. 가격 40행. 게이트 `03_validation/price-foil-envelope-gate.md`=**GO**. **다음: dbm-load-builder 적재본 빌드**(차단 없음).
3. **[⚠ 검증 CONDITIONAL-GO 2026-06-07] 박(foil) — `02_mapping/price-foil-matrix-mapping.md`** — 등급(A~E)=엑셀 편의물 폐기, B02⋈B03 조인으로 면적매트릭스 환원(siz=면적좌표·등급 DB미저장). 재계산 2143행 mismatch 0·등급소멸 PASS. **BLOCKER-1(적재 차단)**: 재사용 21 siz 혼합축(cut/work 섞임)+`SIZ_000047` 삼중바인딩(40×80/50×90/80×40이 1 siz로 수렴→면적권위 모호)+work-NULL siz(119/336/346). → **dbm-mapping-designer 재대조(축 단일화=cut 권장)·재게이트 필요**. MINOR2건(무손실표 오기·"26재사용"→실21). 53 mint siz 722~774(승인 대기).
4. **[설계 완료 2026-06-07] 자재-옵션 정규화 — `10_configurator/huni-goods-option-mapping.md`** — 자재 마스터 오염(색/형상/사이즈/구수가 자재로, MAT_TYPE.09/08/10 ~120행) → WowPress 6축 흡수 벤치마크(`wowpress-option-model.md`) → **후니 5축 보유·1축 GAP**. 본체색=재질합성(과분할금지·파우치 이미 정답)·형상/사이즈=규격 융합·인쇄면/잉크색=도수 분리. **다음: 도메인확인3(만년스탬프 잉크색축·머그용량 비치수siz·굿즈 UI우선순위) → ddl-proposer(GAP SHAPE/COUNT/OPT) → 마이그레이션(오염자재 DELETE/retype/재배선)**. 메모리 `dbmap-material-option-normalization`.
5. **[후니 승인] 고정가·면적 마이그레이션 적용** — `09_load/_migrate_fixedprice/apply.sh commit` + `09_load/_migrate_areamatrix/apply.sh commit`(각 backup→commit→뷰어확인→이상시 undo). 적용 시 가격 4,272/4,805(89%) 적재.
6. **[후니 결정/원천] STK 판수축 + 상품마스터 잔여** — STK 456(A4=SIZ_000258·A3=SIZ_000315 실존, 판수 1P/2P/8판/12판=판걸이수=앱 런타임 계산[메모리 `dbmap-compute-in-app-db-stores-lookup`], DB는 작업사이즈+판형만). 상품마스터: PLATE_FILETYPE 43(별색 손실위험)·PRINTSIDE 63(인쇄면)·MAT 자재변형 179는 위 4번 자재정규화 트랙으로 진행 중.

## 미해결 / 블로커
- **[2026-06-07] 박 BLOCKER-1**(적재 차단): 재사용 21 siz 혼합축 매칭(cut/work 섞임)+`SIZ_000047` 삼중바인딩(40×80/50×90/80×40→1 siz, 면적권위 모호)+work-NULL siz(119/336/346). → dbm-mapping-designer가 siz 매칭축 단일화(cut 권장)·삼중바인딩 해소·work-NULL siz mint 전환 후 재게이트.
- **[2026-06-07] 자재정규화 도메인확인 3**(후니): ①만년스탬프 잉크색=도수축 vs 옵션그릇 ②머그 용량(11온스)=규격 비치수 siz 확정 ③굿즈 옵션 UI 노출 우선순위. + GAP 3건(SHAPE/COUNT/OPT)=ddl-proposer.
- **실제 COMMIT 승인**(인간): 고정가/면적 마이그레이션 apply, siz 211+sticker 원형 10 등록, 코드행(PROC_000084·PRC_COMPONENT_TYPE.06) 등록.
- **STK/GP/ENV 차원모델**: GP는 sticker 원형 재사용으로 자율해소 가능(위 1). STK 판수축·ENV 봉투는 후니 모델 결정.
- **상품마스터 290건**: 후니 원천확정(특히 PLATE_FILETYPE는 별색/칼선이 output_file_typ에 합성돼 단순정규화 시 손실 — 후니 정규화 방식 결정).
- **siz 번호 조율(HARD)**: 미등록 siz 충돌 방지 할당 = `501~510 sticker 원형`(=GP 공유)·`511~721 면적`·`721+ 이후 ENV/STK`. 후니가 최종 코드 부여 가능. (면적 마이그가 원래 501부터 노렸다가 sticker와 충돌→511로 수정한 이력.)

## 주요 결정 (재론 금지)

### 2026-06-07 세션 결정
- **아키텍처 원리(메모리 `dbmap-compute-in-app-db-stores-lookup`)**: **중간 계산은 앱 런타임, DB는 최종 룩업만**. 판수(판걸이수)=임포지션/네스팅 런타임 계산(DB 미저장, 입력=판형 인쇄가능영역+작업사이즈). 박 면적→등급=앱 계산(DB는 등급별 가격만). off-grid ceiling과 동일 철학. **STK 판수축 해법=bundle_qty 칸 아님(이전 권고 정정)·박 GAP 해법=등급 DB정착 아님(면적환원)**.
- **박 등급 폐기·면적매트릭스 환원**: 박등급 A~E=엑셀 실무자 편의물(사용자 결정). B02(면적→등급)⋈B03(등급×수량→가격) 조인으로 (면적좌표×수량→가격) 환원, 등급 DB 미저장. 재계산 2143행 검증 PASS.
- **ENV 봉투=작업사이즈 매칭**: 봉투 4종 siz가 라이브 `SIZ_000191~194` 이미 실재(작업사이즈로 검색). "봉투 siz 0건" 진단 정정.
- **자재-옵션 정규화(메모리 `dbmap-material-option-normalization`)**: 자재 마스터 오염(색/형상/사이즈가 자재로)→WowPress 6축 흡수. **본체색=재질행 합성(과분할 금지·파우치 MAT_TYPE.05는 이미 정답)·형상/사이즈=규격 융합·인쇄면/잉크색=도수 분리**.
- **검토 5상품 처리(사용자)**: 아크릴입체코롯토(168)=코롯토 사양 상속(루아샵·투명아크릴8mm·배면양면·고정가)·투명부채(199)/극세사타월(207)=무시·카드봉투블랙(282)/트레싱지봉투(283)=상품악세사리(product-accessory 실재).

### 2026-06-06 세션 결정
- **GO분 실제 적재됨**(커밋 9ec8be9): 가격 3,504행(component_prices 3,292 등) + 상품마스터 398행(materials 716·processes 260·bundle 26). 백업=`09_load/_exec*/backup_20260606_202911/`. "DB 미적재" 원칙 → **"GO분 적재됨·차단/결정분만 미적재"로 갱신**.
- **후니 권위 가격모델**(메모리 `dbmap-price-formula-types-authority`): 면적매트릭스형(실사/현수막/아크릴=[세로][가로])·고정가형(수량×옵션). off-grid=한단계 큰 크기(런타임). **데이터 R²아닌 후니 권위공식이 기준**(면적함수 추천은 오판).
- **판형 매핑**(메모리 `dbmap-output-plate-mapping`): 가격 출력판형(국4절/3절/면적)은 신규등록 아닌 기존 판형/siz 재사용. GUK4 870→SIZ_000499·3JEOL 304→SIZ_000077(impos=Y 근거)·GP35 10→SIZ_000422 = 1,184행 자율교정(GO 포함 적재됨). round-2가 28 포스터상품 전부 면적-좌표로 오모델→면적13/고정가15 정정.
- **고정가 siz 전건 라이브 재사용**(신규등록 0): 규격옵션 A1~A5·5x5~8x10·mm좌표 전부 기존 siz.
- **교정=마이그레이션**: GO 커밋 후 교정은 멱등 append 아닌 별도 마이그레이션(DELETE/UPDATE). `_exec*`에 append 금지.

## 건드리지 말 것 (확정 산출)
- `09_load/_exec/`·`_exec_price/`: GO 적재본(라이브 반영됨). **재생성/수정 금지**(라이브와 동기).
- `09_load/_migrate_fixedprice/`·`_migrate_areamatrix/`: 검증된 승인-대기 마이그레이션. 적용 전 변경 금지.
- `09_load/_exec*/backup_20260606_202911/`: GO 적재 undo용 before-state. 보존.
- `02_mapping/load_price_correction/`·`price-correction-poster-sign.md`: 권위 정정본.

## 핵심 산출물 위치
- 결정 종합: `09_load/_exec/load-decision-request.md`
- 가격 정정: `02_mapping/price-correction-poster-sign.md` + `load_price_correction/`
- 스키마/매핑 분석: `00_schema/schema-relationship-analysis.md` · `02_mapping/price-siz-mapping-inspection.md`
- 게이트: `03_validation/{load-execution-gate,domain-semantic-gate}.md` · 전체 매트릭스 `09_load/_exec/catalog-loadability.md`
- **2026-06-07 산출물**: GP원형 `09_load/_migrate_gp_circle/`(+게이트 `03_validation/load-execution-gate-gp-circle.md`) · 박/ENV 설계 `02_mapping/{price-foil-matrix-mapping,price-envelope-mapping}.md`(+게이트 `03_validation/price-foil-envelope-gate.md`) · 자재분석 `04_audit/{material-master-analysis.md,material-master-fulldump.tsv}` · 옵션설계 `10_configurator/{wowpress-option-model,huni-goods-option-mapping}.md` · 아크릴 `03_validation/product-viewer/acrylic-spec-and-review5.md`
- 커밋: GO 9ec8be9 · 고정가 9c6c134 · 면적 a606710 · 안전망 f272c2e · 스키마 d6d4b4f · 정정 32cc6a3

## 하네스 운영 메모 (다음 세션 주의)
- 빌더 에이전트 spawn 시 **"자가커밋 금지"** 명시(과거 자가커밋 사례). **커밋된 라이브 데이터 교정은 DELETE/UPDATE 마이그레이션**(멱등 append 아님).
- 라이브는 이제 GO분 적재 상태 — 조회 시 t_prc_*·materials 등 비어있지 않음. siz 신규 제안 전 search-before-mint(판형·기존 좌표·sticker 원형 공유까지 확장).
