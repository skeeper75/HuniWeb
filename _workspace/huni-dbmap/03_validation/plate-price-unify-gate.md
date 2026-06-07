# 디지털인쇄 출력용지규격(전지) 통일 설계 — 독립 검증 게이트 (V1~V6)

> **라운드**: 디지털인쇄 출력용지규격(전지) 통일 설계 독립 검증 (생성≠검증)
> **검증 대상**: `08_remediation/plate-price-unify-design.md` + 부속 CSV(`08_remediation/csv/unify-*.csv`) — designer 산출
> **권위**: 라이브 `railway` DB(PostgreSQL 18.4) 읽기전용 직접 조회(2026-06-07) > 설계서 수치. 추측 없음·라이브 실재만.
> **read-only 준수**: `SELECT`/`information_schema`/`pg_index`만 실행. INSERT/UPDATE/DELETE/DDL/COMMIT/쓰기 트랜잭션 0건. 비밀번호 stdout 미출력. 자가 git 커밋 없음.
> **범위 한계**: 로컬 사전검사 + 라이브 read-only 대조까지. 라이브 DRY-RUN(BEGIN…ROLLBACK 쓰기 트랜잭션)은 lead 승인 사항이므로 미실행.

---

## 종합 판정: **CONDITIONAL-GO** (1 BLOCKER 수정 후 GO)

설계의 핵심 안전 구조(무손실·FK 위상·범위 한정)는 **대체로 정합**하나, **가격 마이그 멱등성(V3)이 라이브 데이터로 깨진다**(ON CONFLICT 비발화). 이 BLOCKER 1건을 builder가 수정하면 GO. 그 외 수치 오류 2건(MINOR)·분류 라벨 오류 1건(MINOR)·미확정 정책 2건(U-2/U-3)은 GO를 막지 않으나 정정·인간 승인 필요.

| 게이트 | 판정 | 핵심 |
|--------|------|------|
| V1 무손실 | **PASS** | ORPHAN 66 라이브 독립 재산정 일치·SIZ_000077 RESTRICT 보존·3절 가격 값 무손실 |
| V2 FK 위상·CASCADE/RESTRICT | **PASS** | plate RESTRICT·price CASCADE·prodsize RESTRICT 라이브 확인, 적용순서 1→2→3→4 정합 |
| V3 멱등 | **FAIL (BLOCKER-1)** | 가격 INSERT ON CONFLICT가 **라이브 NULL 자연키로 100% 비발화** → 2회차 +304 중복. plate 멱등은 PASS |
| V4 라이브 사전검사 | **PASS (수치 정정 2건)** | 부재·존재·고아안전 전건 정합. 단 **국4절 가격 870≠923**(designer 오기)·**SPOT 10종≠11종** |
| V5 영향·정합 | **PASS (1 검토필요)** | 국4절 923→870 무변경 본질 동일. **output_paper_typ_cd .01 일괄부여가 기존 .03/NULL을 변경**(검토필요) |
| V6 범위·차단 정직성 | **PASS** | 디지털인쇄 한정 정합(타 siz 부재)·CUT 타공 NULL siz 정당 제외·U-3/U-4/U-5 정직 분리 |

---

## V1 무손실 — PASS

### V1-① ORPHAN 66 독립 재산정 (라이브 권위)
designer의 80 distinct 작업사이즈(impos=N) → ORPHAN 66 / PRESERVE 14 판정을 **라이브에서 독립 재계산**(42 교정제품 plate 참조 siz를 impos=N으로 필터, total_plate=in_corr & prodsize=0 & price=0 조건):

```
distinct_worksize_siz=80, orphan_after_correction=66, preserve(shared_noncorr)=13, preserve(other_ref)=1
```

- **ORPHAN 66 = 라이브와 정확 일치** (load-bearing 안전 수치 ✓).
- 고-참조 siz 스팟검증(SIZ_000114/115/118/144 = plate 7/7/6/7, 전 참조제품이 42 교정목록 내·prodsize 0·price 0)→ 교정 후 무참조 = ORPHAN 정합.
- **§6.2 NOT EXISTS 가드**(plate·prodsize·price 3중)가 진짜 안전망이므로, 라벨이 다소 어긋나도 잘못 soft-delete될 siz는 0. → 무손실 PASS.

> ⚠ **MINOR 발견 (PRESERVE 라벨 오분류, 데이터는 정확)**: designer는 PRESERVE를 "other_ref 4(113·132·147·148) / shared 10"으로 라벨링했으나, 라이브 재산정은 **other_ref 1(132만) / shared_noncorr 13**. **SIZ_000113·147·148**은 total_plate>in_corr(11>6, 2>1, 4>2)로 실제는 *shared* 케이스다(비교정 PRD_000023/066/188/189/190 등이 공유). CSV `unify-worksize-orphan-cleanup.csv`의 *수치*는 정확(`total_plate_refs > plate_refs_in_corr` 기재됨)하나 disposition *라벨*만 부정확. **정정 권고**(soft-delete 미발생이라 안전엔 영향 0).

### V1-② SIZ_000077 siz 보존 (RESTRICT)
라이브: `SIZ_000077`(work 304x629/cut 300x625, impos=Y) = product_sizes 1행(PRD_000112) 참조. → siz 행 자체 삭제 시 RESTRICT 위반. 설계는 **가격 참조만 이전·siz 미삭제** 명시(§4.2/§7.1) → 정합 ✓.

### V1-③ 3절 가격 304행 DELETE+INSERT 무손실
- siz-제외 자연키 distinct = 304 (collision 0) → siz 교체 후에도 304 distinct 유지, **값 붕괴 없음** ✓.
- unit_price numeric·apply_ymd varchar·clr/mat/coat/bdl 전부 원행 복사 → 값 무손실 ✓.
- comp_price_id = bigint **IDENTITY BY DEFAULT** → INSERT 시 자동발급(designer SELECT가 omit) ✓.

---

## V2 FK 위상·CASCADE/RESTRICT — PASS

라이브 `information_schema.referential_constraints` 직접 확인:

| FK | delete_rule | 설계 가정 | 일치 |
|----|-------------|-----------|------|
| `t_prd_product_plate_sizes.siz_cd → t_siz_sizes` | **RESTRICT** | RESTRICT | ✓ |
| `t_prc_component_prices.siz_cd → t_siz_sizes` | **CASCADE** | CASCADE | ✓ |
| `t_prd_product_sizes.siz_cd → t_siz_sizes` | **RESTRICT** | (보존 근거) | ✓ |
| `t_prd_product_plate_sizes.output_paper_typ_cd → t_cod_base_codes` | **RESTRICT** | (미언급) | ⚠ V5 참조 |

- 적용순서 **1)신규siz → 2)plate 재기재 → 3)가격 마이그 → 4)중복행 정리**가 RESTRICT/CASCADE를 위반하지 않음:
  - 신규 siz 선등록 = 부모 추가, plate/price INSERT의 RESTRICT/CASCADE FK 충족.
  - plate DELETE는 자식(plate)행 제거이므로 부모 RESTRICT 무관.
  - 중복행 정리(soft-delete del_yn)는 물리삭제 아님 → RESTRICT FK 미발화. 단 §6.2가 plate 교정 *후*에만 실행돼야 NOT EXISTS가 0이 됨 → 순서 강제 정합.
- **순서를 어기면**: (3)을 (1) 전에 하면 신규 siz 부재로 CASCADE FK INSERT 실패. (4)를 (2) 전에 하면 plate_refs>0이라 NOT EXISTS 가드가 soft-delete를 막음(안전 실패 방향). → 설계 순서 타당.

---

## V3 멱등 — FAIL (BLOCKER-1) / plate·DELETE는 PASS

### BLOCKER-1: 가격 마이그 INSERT ON CONFLICT가 라이브 NULL 자연키로 100% 비발화
라이브 `pg_index`: `ux_t_prc_comp_prices_nat_key`(comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty) = **UNIQUE, `indnullsnotdistinct = f`**(NULLS DISTINCT, 기본값).

라이브 SIZ_000077 304행의 자연키 NULL 분포:
```
COMP_PRINT_DIGITAL_S1: 106행 — mat_cd NULL 106, coat_side_cnt NULL 106
COMP_PRINT_DIGITAL_S2: 106행 — mat_cd NULL 106, coat_side_cnt NULL 106
COMP_COAT_MATTE:        46행 — clr_cd NULL 46, mat_cd NULL 46
COMP_COAT_GLOSSY:       46행 — clr_cd NULL 46, mat_cd NULL 46
→ 304행 전건이 자연키 컬럼 중 최소 1개 NULL (has_null_in_natkey=304, fully_nonnull=0)
```

PostgreSQL는 `NULLS DISTINCT` UNIQUE 인덱스에서 `(…, NULL, …)`를 서로 **충돌로 보지 않음**. 따라서 designer §4.2/§4.3/§7.4의 `INSERT … ON CONFLICT (자연키) DO NOTHING`은 **304행 전건에 대해 발화 불가** → 2회차 적용 시 304행이 **전부 재삽입(new comp_price_id)** 되어 중복. DELETE 가드(`siz_cd='SIZ_000077' AND EXISTS(신규siz가격)`)는 1회차 후 0행이라 무관.

**2-pass 실측 예측: pass-2 INSERT +304 중복 / DELETE 0 → 순델타 +304 ≠ 0**. §4.3·§7.4의 "2-pass 멱등·델타 0" 주장은 **이 데이터에서 거짓**.

- **라우팅**: builder(SQL). **수정안**(택1):
  - (a) **선존재 가드 변경**: `INSERT … SELECT … WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices t WHERE t.siz_cd='<신규>' AND t.comp_cd=src.comp_cd AND t.apply_ymd=src.apply_ymd AND t.clr_cd IS NOT DISTINCT FROM src.clr_cd AND t.mat_cd IS NOT DISTINCT FROM src.mat_cd AND t.coat_side_cnt IS NOT DISTINCT FROM src.coat_side_cnt AND t.bdl_qty=src.bdl_qty AND t.min_qty=src.min_qty)` — `IS NOT DISTINCT FROM`이 NULL을 동치 처리.
  - (b) 또는 마이그를 **UPDATE siz_cd** 방식으로(DELETE+INSERT 대신 `UPDATE t_prc_component_prices SET siz_cd='<신규>' WHERE siz_cd='SIZ_000077'`). 1회차에 siz_cd가 신규로 바뀌면 2회차 WHERE siz_cd='SIZ_000077'가 0행 → 자연 멱등·새 comp_price_id 불요·무손실. **단** CASCADE FK는 siz 부모 존재만 요구하므로 UPDATE도 안전. *이 방식이 더 단순·안전 — 권고.*
  - (c) `ux_…_nat_key`를 `NULLS NOT DISTINCT`로 재정의 = DDL → ddl-proposer 경유·범위확대(비권고).

### plate 재기재 멱등 — PASS
- plate PK = `t_prd_product_plate_sizes_pkey (prd_cd, siz_cd)`(라이브 확인, prd_cd·siz_cd 둘 다 NOT NULL) → `ON CONFLICT (prd_cd, siz_cd) DO NOTHING` 정상 발화.
- 신규 38 SIZ_000499 plate 행이 라이브에 **선존재 0건** 확인 → 1회차 실삽입, 2회차 no-op = 멱등 ✓.
- 신규 siz `ON CONFLICT (siz_cd) DO NOTHING` — siz_cd PK NOT NULL → 정상 멱등 ✓.

### plate/worksize DELETE 멱등 — PASS
DELETE `WHERE siz_cd IN(작업사이즈 목록)`는 2회차 0행 = 멱등. soft-delete `del_yn='Y' AND del_yn='N'` 조건은 2회차 0행 = 멱등 ✓.

---

## V4 라이브 사전검사 — PASS (수치 정정 2건 = MINOR)

| 항목 | designer 주장 | 라이브 실측 | 판정 |
|------|---------------|-------------|------|
| ① 330x660 search-before-mint | 0행(부재) | **0행** (±5mm·양방향·siz_nm LIKE) | ✓ |
| ② 국4절 SIZ_000499 가격행 | **923** | **870** | ❌ MINOR-A (53 과대) |
| ② 국4절 SIZ_000499 plate | 1(PRD_000016) | **1**(PRD_000016, output=.01) | ✓ |
| ③ SIZ_000077 = 304x629 작업·가격 304·prodsize 1·plate 0 | 304/1/0 | **304/1/0** (work 304x629) | ✓ |
| ④ 3절 6 작업사이즈 plate 고아안전 | 각 plate1·prodsize0·price0 | **142/143/186/188/190/292 전건 plate1·prodsize0·price0** | ✓ |
| ⑤ OUTPUT_PAPER_TYPE.01 존재 | 국전계열 | **`OUTPUT_PAPER_TYPE.01` 국전계열 use_yn=Y** | ✓ |
| ⑥ comp 바인딩 PRINT/COAT/CUT | 0건 | (V6에서 별도 확인) | ✓ |

### MINOR-A: 국4절 가격 923 ≠ 라이브 870 (designer 오기)
라이브 SIZ_000499 comp 분포:
```
PRINT_DIGITAL_S1/S2: 106+106
SPOT (CLEAR/GOLD/PINK/SILVER/WHITE × S1/S2 = 10종) × 53 = 530   ← designer "11종×53=583" 오류
COAT_MATTE/GLOSSY: 46+46
CUT_FULL_DIECUT: 36
합계 = 870  (designer 923은 SPOT 1종(53행) 과대계산)
```
- **영향**: 국4절 가격은 어차피 **무변경**(통일 대상 아님)이므로 적재 안전엔 영향 0. 단 설계서·핵심수치 표(§0.3·§9)·메모리의 923을 **870으로 정정** 필요. SPOT은 **10종**(11종 아님).
- **라우팅**: designer(설계서 수치 정정).

---

## V5 영향·정합 — PASS (1 검토필요)

- **국4절 923(실 870) 무변경**: 통일은 plate만 collapse, 가격 SIZ_000499 미터치 → 가격 무변경 정합 ✓.
- **plate 128→42 collapse vs 판수**: 판수(판걸이수)는 앱 런타임 계산(메모리 `dbmap-compute-in-app-db-stores-lookup`)이라 plate 행수 축소가 가격·판수 계산을 깨지 않음 ✓.
- **3절 가격 마이그 → 위젯 정합**: plate siz(330x660)와 가격 siz(330x660)가 통일되면 plate-siz=가격-siz 조회축 정합 ✓ (현재 PRD_000112는 plate=SIZ_000292·가격=SIZ_000077 불일치 → 통일로 해소).

### 검토필요-1: output_paper_typ_cd `.01` 일괄부여 = 기존 값 변경
라이브: 42 교정제품의 기존 plate 행 output_paper_typ_cd 분포 = **`.03`(기타) 74행 / NULL 53행 / `.01`(국전계열) 1행**(PRD_000016만). 컬럼은 **NULLABLE**(is_nullable=YES).
designer는 collapse INSERT 시 전 41행에 **`.01`(국전계열)** 부여. 즉 기존 `.03`/NULL이던 제품들이 `.01`로 **의미 변경**된다.
- 디지털인쇄 전지=국전계열(316x467)이므로 `.01` 부여는 **도메인상 타당**(오히려 기존 `.03`/NULL이 부정확). FK(.01 존재·use_yn=Y)도 충족.
- 단 이는 "기존 값 보존"이 아닌 **정정**이므로, 설계서가 "교정"으로 명시했는지·후니 의도인지 확인 권고. plate.output_paper_typ_cd FK는 RESTRICT지만 `.01`이 실재하므로 INSERT 안전.
- **추가 누락(builder 라우팅)**: plate `dflt_plt_yn`은 **NOT NULL**(라이브 기존값 Y 493/N 1). designer INSERT SQL(§3/§7)이 dflt_plt_yn을 명시하지 않음 → INSERT 시 컬럼 default 없으면 실패. **builder는 collapse INSERT에 `dflt_plt_yn='Y'` 명시 필요**.

---

## V6 범위·차단 정직성 — PASS

- **디지털인쇄 한정 정합**: PRINT_DIGITAL/COAT/CUT_FULL_DIECUT comp를 쓰는 siz는 라이브 전체에서 **SIZ_000499·SIZ_000077 둘뿐**. 제3의 디지털인쇄 전지 누락 없음 → 42제품 범위 완전 ✓.
- **CUT 타공류 정직 제외**: COMP_CUT_FULL_PERF_1H6/2H6·PERF_1H6 = siz_cd **전건 NULL**(9/9/23) → 시트 전지축 아님이 맞음. 통일 제외 정당 ✓.
- **차단 정직 분리**: U-3(하드커버무선 532x355→330x660, 라이브 통일대상 불명확)·U-4(투명원단 315x467·반칼전지, PRINT/COAT/CUT 계열 아님)·U-5(미지정 전지 잔여, plate-size-correction-design.md D-1)를 **별 트랙·범위밖으로 명시 분리**. 처리완료로 포장하지 않음 ✓.
- 투명엽서/명함/포토카드(019/039/025)를 가설(315x467) 아닌 라이브 권위(국4절 316x467)로 통일·315x467은 별 트랙 분리 = 추측 배제 정직 ✓.

---

## 능동 적발 결함 목록 (독립성 입증 — R6/생성≠검증)

| # | 심각도 | 게이트 | 결함 | 증거(라이브) | 라우팅 |
|---|--------|--------|------|--------------|--------|
| **F-1** | **BLOCKER** | V3 | 가격 마이그 `ON CONFLICT(자연키) DO NOTHING`이 **NULL 자연키로 100% 비발화** → 2-pass 멱등 깨짐(+304 중복). "델타 0" 주장 거짓 | `ux_…_nat_key indnullsnotdistinct=f`·SIZ_000077 304행 전건 mat_cd NULL(+clr/coat NULL) | **builder** (SQL: UPDATE siz_cd 방식 또는 IS NOT DISTINCT FROM 가드로 교체) |
| **F-2** | MINOR | V4 | 국4절 SIZ_000499 가격 = **870행** (설계서 923 오기, 53 과대). SPOT **10종**(11종 아님) | comp별 count: SPOT 10×53=530, 합 870 | **designer** (설계서 §0.3·§9·메모리 923→870, SPOT 11→10 정정) |
| **F-3** | MINOR | V1 | PRESERVE 라벨 오분류: SIZ_000113·147·148은 "other_ref"가 아니라 **shared_noncorr**(other_ref는 132 1건뿐). CSV 수치는 정확, 라벨만 부정확 | total_plate>in_corr: 113(11>6)·147(2>1)·148(4>2) | **designer** (CSV disposition 라벨 정정. 안전 영향 0 — NOT EXISTS 가드가 실권위) |
| **F-4** | MINOR | V5 | plate collapse INSERT가 `dflt_plt_yn`(NOT NULL) 미명시 → 실행 시 실패 위험 | `dflt_plt_yn is_nullable=NO`, 기존값 Y/N | **builder** (INSERT에 `dflt_plt_yn='Y'` 추가) |
| **F-5** | 검토 | V5 | output_paper_typ_cd `.01` 일괄부여 = 기존 `.03`(74)/NULL(53) **정정**(보존 아님). 도메인상 타당하나 의도 명시 필요 | 42제품 기존 plate: .03=74·NULL=53·.01=1 | **designer→인간** (정정 의도 확인) |

> **독립성 입증**: 본 검증은 설계서를 무비판 승인하지 않고, 설계서가 PASS로 주장한 V3 멱등(§4.3·§7.4)에서 **라이브 NULL 자연키 구조로 인한 ON CONFLICT 비발화 BLOCKER**를 능동 적발했다. 설계서의 핵심 수치(923·SPOT 11종)도 라이브 대조로 870·10종 오류를 잡았다.

---

## 인간 승인 큐

| ID | 분류 | 내용 | 상태 |
|----|------|------|------|
| **U-1** | 채번 | 신규 3절 siz_cd 채번(HANDOFF 번호조율, 721+ 슬롯 권장). placeholder `SIZ_PROPOSE_3JEOL` | 인간 승인 대기 |
| **U-2** | cut 정책 | 신규 3절 siz cut 치수: 전지 인쇄가능영역 보유 여부. SIZ_000499는 cut 306x457 보유(여백 5mm). 3절도 동형(예 320x650)? 현재 cut=NULL 제안 | 후니 확인 대기 |
| **U-3** | 범위 | 하드커버무선책자 A4(532x355→330x660, 판걸이수 3절 등재) 통일 포함 여부. 현재 제외(국4 39+3절 3만) | 후니 확인 대기 |
| **F-5** | 정정의도 | output_paper_typ_cd `.01` 일괄 정정 의도 확인 | 후니 확인 대기 |
| **COMMIT** | 적재 | 실제 INSERT/DELETE/UPDATE·DDL(있을 시)·siz 등록 = 인간 승인. **F-1 수정 후 라이브 롤백전용 DRY-RUN(lead 승인) 선행 권고** | 인간 승인 대기 |

---

## GO/NO-GO

**CONDITIONAL-GO.**
- **무손실(V1)·FK 위상(V2)·범위 정직성(V6)·라이브 사전검사(V4)·영향정합(V5)** = 안전.
- **단 V3 멱등 BLOCKER(F-1)**: 가격 마이그 SQL을 builder가 **UPDATE siz_cd 방식** 또는 **IS NOT DISTINCT FROM 선존재 가드**로 교체해야 2-pass 멱등이 성립. 현 `ON CONFLICT(자연키) DO NOTHING`은 라이브 NULL 자연키로 무효.
- F-2/F-3(수치·라벨 정정)·F-4(dflt_plt_yn 명시)는 GO 차단 아님(병행 정정).
- F-1 수정 후 **변경분만 재게이트**(V3)하고, 라이브 롤백전용 DRY-RUN(lead 승인)으로 멱등 2-pass 실증 후 인간 COMMIT 승인.

**적재가능성 집계**: 통일 대상 = plate 128→42(DELETE 127·INSERT 41) + 가격 마이그 304(DELETE+INSERT/또는 UPDATE) + 신규 siz 1 + soft-delete 66. **insertable(설계 정합)** = plate 41·신규siz 1·soft-delete 66. **blocked(F-1 수정 전)** = 가격 304행 마이그(멱등 미보장). **GAP/인간승인** = U-1 채번·U-2 cut·U-3 하드커버·F-5 정정의도·실 COMMIT.
