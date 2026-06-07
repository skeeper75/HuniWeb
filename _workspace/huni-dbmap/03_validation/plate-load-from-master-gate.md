# 출력용지규격 plate 적재(상품마스터 권위) — 독립 검증 게이트 (V1~V6)

> **라운드**: 출력용지규격 plate 적재 설계 독립 검증 (생성≠검증)
> **검증 대상**: `08_remediation/plate-load-from-master-design.md` + 부속 CSV(`08_remediation/csv/plate-*.csv`) — designer 산출
> **권위**: 라이브 `railway` DB(PostgreSQL 18.4) 읽기전용 직접 조회(2026-06-07) > 설계서 수치. + 엑셀 L1 추출본(`06_extract/{digital-print,calendar,design-calendar}-l1.csv`) 출력용지규격 컬럼. 추측 없음·라이브 실재만.
> **확정 전제(사용자 2026-06-07)**: plate=출력용지규격. 권위=상품마스터 `파일사양_출력용지규격` 컬럼. 316x467=SIZ_000499 재사용·330x660 신규·315x467 신규(투명). 가격 정합은 다음 단계(본 범위 외).
> **read-only 준수**: `SELECT`/`information_schema`/`pg_index`만 실행. INSERT/UPDATE/DELETE/DDL/COMMIT/쓰기 트랜잭션 0건. 비밀번호 stdout 미출력. 자가 git 커밋 없음.
> **범위 한계**: 로컬 사전검사 + 라이브 read-only 대조까지. 라이브 DRY-RUN(BEGIN…ROLLBACK 쓰기 트랜잭션)은 lead 승인 사항이므로 미실행.
> **선행 검증**: `03_validation/plate-price-unify-gate.md`(1차판 F-1~F-5) 참조. 본 검증은 권위 전환(상품마스터 컬럼)·투명 추가·범위 38 재확정분을 라이브로 재검증.

---

## 종합 판정: **CONDITIONAL-GO** (가격정합 동시처리 결정 필요 — plate 자체는 적재 가능)

설계의 핵심 안전 구조(무손실·권위 정합·FK 위상·멱등)는 **라이브 대조로 전건 정합**한다. 1차판의 BLOCKER였던 F-1(가격 마이그 ON CONFLICT NULL 비발화)은 **본 라운드가 가격을 터치하지 않으므로 미발생** — 멱등 위험 해소. 그러나 **R-5(가격조회축 깨짐)가 라이브 증거상 "다음 단계"가 아니라 본 plate 적재 직후 6상품(3절3+투명3)의 디지털인쇄 공정비 조회가 즉시 깨지는 실재 위험**임을 적발했다. plate 자체는 적재 가능하나, **3절·투명 6상품 plate는 가격 정합과 동시 적용하거나 보류해야** 위젯 가격 조회가 깨지지 않는다.

| 게이트 | 판정 | 핵심 |
|--------|------|------|
| V1 무손실 | **PASS** | ORPHAN 62 라이브 독립 재산정 정확 일치·가격참조 0 확인·PRESERVE 14 보존·soft-delete 3중 가드 실효 |
| V2 권위 정합 | **PASS (정직성 MINOR 1)** | 상품마스터 출력용지규격 컬럼 38상품·혼용 0·316/330/315 분포 정확 일치·prd_nm 매핑 정확. 단 **공란 상품 3개**(설계서 R-1은 1개만 명시) |
| V3 FK 위상·멱등 | **PASS** | plate PK·siz PK 둘 다 NOT NULL→ON CONFLICT 정상·DELETE 한정이 PRD_000016 SIZ_000499/비교정 참조 보존·2-pass 멱등·F-1 미적용(가격 미터치) |
| V4 라이브 사전검사 | **PASS** | 330x660/315x467 부재·SIZ_000499 impos=Y 가격870·plate 114·dflt_plt_yn NOT NULL DEFAULT없음·output_paper_typ_cd FK·.01 존재 전건 정합 |
| V5 영향 | **PASS** | plate 114→38 collapse가 판수(앱 런타임)와 무충돌·신규 siz 2 부모추가 무위험·가격 무변경(316x467만 가격 정합 유지) |
| V6 범위·가격 불일치 정직성 | **PASS (R-5 위험 격상)** | 가격 잔존 불일치를 다음 단계로 정직 분리. **단 R-5는 라이브 증거상 plate 적재 직후 6상품 가격조회 즉시 깨짐 — "다음 단계" 격하 부적절** |

---

## V1 무손실 — PASS

### V1-① ORPHAN 62 / PRESERVE 14 라이브 독립 재산정 (라이브 권위)
designer의 76 distinct 작업사이즈(SIZ_000499 제외) → ORPHAN 62 / PRESERVE 14 판정을 **라이브에서 독립 재계산**(total_plate=in_corr & prodsize=0 & price=0 조건):
```
distinct_worksize_siz(excl 499)=76, orphan=62, preserve=14 (shared 12 / other_ref_only 2)
```
- **ORPHAN 62 = 라이브 목록과 정확 일치**. soft-delete 후보 62 siz(SIZ_000023…SIZ_000292)가 CSV `plate-worksize-orphan-cleanup.csv` ORPHAN 62와 siz_cd 단위 전건 동일 ✓ (load-bearing 안전 수치).
- **ORPHAN 62 가격참조 = 0 라이브 실측 확인**(스팟 12 siz 전수 + 집계 0) → CASCADE 위험 없음. soft-delete 안전 ✓.
- **PRESERVE 14 = 라이브 목록 정확 일치**: SIZ_000002·113·114·115·132·147·148·157·171·173·175·179·180·181 — CSV와 siz_cd 단위 동일 ✓. 그중 12 price rows(SIZ_000113·132·147·148 각 3행=별색엽서 가격)는 NOT EXISTS 3중 가드(price)가 보존.

### V1-② soft-delete NOT EXISTS 3중 가드 실효성
§5.2 `UPDATE … WHERE NOT EXISTS(plate) AND NOT EXISTS(prodsize) AND NOT EXISTS(price)`는 plate 교정(DELETE) 후에만 실행. 라이브 FK delete_rule: plate→siz **RESTRICT**·prodsize→siz **RESTRICT**·price→siz **CASCADE**(전건 확인). soft-delete는 del_yn 토글(물리삭제 아님)이라 RESTRICT 미발화. 3중 가드가 실권위라 분류 라벨이 어긋나도 잘못 soft-delete될 siz는 0 — 무손실 PASS.

### V1-③ MINOR: PRESERVE 분류 라벨 (1차판 F-3 재현, 안전 영향 0)
designer §5.1은 PRESERVE를 "other_ref 3(SIZ_000002·132·148) / shared 11"로 라벨링. 라이브 재산정은 **other_ref_only 2(SIZ_000002·132) / shared 12**. **SIZ_000148**은 total_plate(4)>in_corr(2)라 실제 *shared*(prodsize5+price3도 보유해 어느 가드로든 보존). 합계 14는 동일·CSV 수치 정확. 라벨만 부정확. **안전 영향 0**(NOT EXISTS 가드가 실권위). 1차판 F-3과 동일 패턴 → designer 라벨 정정 권고.

---

## V2 권위 정합 — PASS (정직성 MINOR 1)

### V2-① 상품마스터 출력용지규격 컬럼 ↔ 38상품 매핑 (L1 재대조)
엑셀 L1 3시트의 `파일사양_출력용지규격` 컬럼 전수 재추출(라이브 대조):

| 항목 | designer 주장 | L1 재추출 실측 | 판정 |
|------|---------------|----------------|------|
| 비공란 distinct 상품 | 38 | **38** | ✓ |
| 316x467 상품 | 32 | **32** | ✓ |
| 330x660 상품 | 3 (PRD_000030·049·112) | **3**(지그재그엽서·와이드접지리플렛·와이드벽걸이캘린더) | ✓ |
| 315x467 투명 상품 | 3 (PRD_000019·025·039) | **3**(투명엽서·투명포토카드·투명명함) | ✓ |
| **혼용 상품(1상품 다종 출력용지규격)** | **0** | **0**(컬럼 기준 제품당 distinct=1) | ✓ |
| 셀 분포 digital-print | 316x467(56)·330x660(5)·315x467(3) | **동일** | ✓ |
| 셀 분포 calendar | 316x467(13)·330x660(1) | **동일** | ✓ |
| 셀 분포 design-calendar | 316x467(6)·330x660(1) | **동일** | ✓ |

JOIN KEY=`prd_nm` 38상품 매핑 라이브 대조 정확(투명/3절 6상품 + PRD_000016 + PRD_000037 스팟 전건 일치). PRD_000016=프리미엄엽서·PRD_000037=오리지널박명함 확인.

### V2-② 혼용 0 — 3자 분석 §3 모순 해소
`output-paper-3way-reconciliation.md` §3/§5는 "출력용지규격이 (상품×종이) 조합으로 결정 → 한 상품이 출력용지규격 2종(316x467+464x320 띤또레또)"이라 했으나, **이는 종이옵션에서 파생되는 가설이지 `파일사양_출력용지규격` 컬럼 명시값이 아니다**. 컬럼 기준 혼용 0이 라이브 실측 정합. 사용자 확정 = 이 컬럼이 권위이므로 혼용 0 수용 PASS. (띤또레또 464x320 종이 종속 출력용지규격은 종이별 용지비 별 트랙으로 정직 분리 — V6.)

### V2-③ MINOR(정직성): 공란 상품 1개→3개
설계서 §1.3·R-1은 출력용지규격 컬럼 공란 상품으로 **PRD_000037(오리지널박명함) 1개만** 명시. L1 재추출 실측 = 공란 상품 **3개 = 오리지널박명함·봉투제작·썬캡**. 봉투제작·썬캡 2개는 설계서 미언급. **적재 안전 영향 0**(공란이라 본 라운드 plate 미교정·비대상). 단 "공란=미입력인지 비대상인지" R-1 확인 범위가 1→3으로 확대돼야 정직. (봉투제작=작업사이즈 분리구조·썬캡=굿즈류로 출력용지규격 개념 비적용 가능성). **라우팅: designer(R-1 범위 정정).**

---

## V3 FK 위상·멱등 — PASS

### V3-① PK·ON CONFLICT 정상 발화
- plate PK = `t_prd_product_plate_sizes_pkey (prd_cd, siz_cd)` 둘 다 NOT NULL(라이브 `pg_index` 확인) → `ON CONFLICT (prd_cd, siz_cd) DO NOTHING` 정상 발화 ✓.
- siz PK = `siz_cd` NOT NULL → `ON CONFLICT (siz_cd) DO NOTHING` 정상 ✓.
- **1차판 BLOCKER-1(F-1: 가격 마이그 ON CONFLICT NULL 자연키 100% 비발화)은 본 라운드 미적용** — 본 라운드는 component_prices를 터치하지 않음(plate/siz만). plate/siz PK는 전부 NOT NULL이라 NULL 자연키 멱등 깨짐 위험 없음. **F-1 위험 해소 확인** ✓.

### V3-② DELETE 한정이 KEEP/비교정 참조 보존
§4.4 안전형 DELETE = `WHERE prd_cd IN(38교정) AND siz_cd IN(작업사이즈 76종 목록)`. 라이브 검증:
- **PRD_000016 SIZ_000499 보존**: SIZ_000499는 작업사이즈 76종 목록에 없음(출력용지규격 siz) → DELETE 대상 외. PRD_000016 plate 1행 자동 보존 ✓.
- **PRESERVE siz의 비교정(non-corr) 참조 보존**: 라이브 실측 — PRESERVE 14 siz 전건이 corr 제품에서만 DELETE되고 non-corr 참조는 KEEP. 예: SIZ_000113 corr 7 DELETE/non-corr 4 KEEP, SIZ_000148 corr 2 DELETE/non-corr 2 KEEP, SIZ_000114/115 각 corr 6 DELETE/non-corr 1 KEEP. → DELETE가 `prd_cd IN(38)`으로 한정돼야 non-corr 보존 성립 ✓. (builder는 DELETE WHERE에 prd_cd IN(38) 조건 반드시 포함해야 함 — 누락 시 비교정 제품 plate 손실 위험.)

### V3-③ dflt_plt_yn NOT NULL 명시 (1차판 F-4 반영 확인)
plate `dflt_plt_yn` = NOT NULL·**DEFAULT 없음**(라이브 `information_schema` 확인). CSV `plate-insert-rows.csv` 37행 전건 `dflt_plt_yn='Y'` 명시 ✓ (F-4 반영). `reg_dt` NOT NULL DEFAULT now() → 명시 NULL 금지(설계서 §3.1/§6.4 반영) ✓. `del_yn` DEFAULT 'N' ✓.

### V3-④ 2-pass 멱등
plate INSERT 37행 라이브 선존재 0(SIZ_000499 참조는 PRD_000016만, 신규 plate 행 없음). plate DELETE `siz_cd IN(목록)` 2회차 0행. 신규 siz `ON CONFLICT(siz_cd)` 2회차 no-op. soft-delete `del_yn='Y' AND del_yn='N'` 2회차 0행. → 멱등 ✓.

---

## V4 라이브 사전검사 — PASS (designer 수치 독립 재확인)

| 항목 | designer 주장 | 라이브 실측 | 판정 |
|------|---------------|-------------|------|
| 330x660 search-before-mint | 부재 | **0행**(±5mm 양방향·siz_nm LIKE) | ✓ |
| 315x467 search-before-mint | 부재 | **0행**(±5mm 양방향) — 단 ⚠ 아래 | ✓* |
| SIZ_000499 = 316x467 work·impos=Y·use_yn=Y | 그렇다 | **316x467/306x457 cut·impos=Y·use_yn=Y·del_yn=N** | ✓ |
| SIZ_000499 가격행 | 870 | **870**(1차판 F-2 정정값·923 아님) | ✓ |
| 38상품 plate | 114 | **114**(active 114) | ✓ |
| PRD_000016 = SIZ_000499 1행 | KEEP | **1행, dflt_plt_yn=N, .01** | ✓(⚠ dflt_plt_yn=N) |
| dflt_plt_yn NOT NULL DEFAULT 없음 | 그렇다 | **NOT NULL·column_default 없음** | ✓ (F-4) |
| output_paper_typ_cd FK RESTRICT·.01 존재 use_yn=Y | 그렇다 | **RESTRICT·.01 국전계열 use_yn=Y**(+.02 46계열·.03 기타) | ✓ |
| siz 자식 FK: plate/prodsize RESTRICT·price CASCADE | 그렇다 | **전건 정합** | ✓ |
| 기존 output_paper_typ_cd 분포(38상품 114행) | NULL38/.03 75/.01 1 | **.03 75/NULL 38/.01 1** | ✓ |

**⚠ V4-* 모호(R-4 보강 증거)**: search-before-mint 315x467 ±5mm 범위(310~320×462~472)에 **SIZ_000499(316x467)가 1mm 차이로 걸려 나옴**. 즉 316x467과 315x467은 사실상 동일 규격(1mm). 사용자 확정으로 투명=315x467 신규 siz는 권위 결정이나, **투명을 별도 siz로 신규 등록 vs SIZ_000499 재사용**은 1mm 차이라 도메인상 재고 여지(투명 가격이 국4절과 동일하다면 siz 공유가 단순). 단 권위 결정 수용 — R-4로 격상 기록.

**⚠ V4 추가 발견(MINOR)**: PRD_000016 SIZ_000499의 라이브 **dflt_plt_yn = 'N'**. 설계서 §4.1은 "이미 정답 → KEEP"이라 했으나, 출력용지규격(국4절)을 기본판으로 삼는다면 dflt_plt_yn='Y'가 의미상 맞다. 신규 INSERT 37행은 전부 'Y'인데 KEEP되는 PRD_000016만 'N'으로 남음 → 동일 출력용지규격축의 dflt_plt_yn 일관성 결여. 적재 안전엔 무영향(NOT NULL 충족). **라우팅: designer→인간(PRD_000016 dflt_plt_yn 정정 포함 여부 확인).**

---

## V5 영향 — PASS

- **plate 114→38 collapse vs 판수**: 판수(판걸이수)=앱 런타임 임포지션 계산(메모리 `dbmap-compute-in-app-db-stores-lookup`)이라 plate 행수 축소가 판수/가격 계산을 깨지 않음 ✓.
- **신규 siz 2 = 부모 추가**: 무위험. RESTRICT FK는 부모 존재만 요구.
- **가격 무변경**: 본 라운드 component_prices 0 터치. 316x467 32상품은 plate가 SIZ_000499를 가리키고 SIZ_000499 가격 870행 유지 → **316x467 가격 정합 유지** ✓. (3절·투명은 V6/R-5.)
- **collapse INSERT 37행 FK 충족**: SIZ_000499 존재·신규 siz 2 선등록·output_paper_typ_cd .01 존재 → 전건 RESTRICT FK 충족 ✓.

---

## V6 범위·가격 불일치 정직성 — PASS (R-5 위험 격상)

### V6-① 가격 잔존 불일치 정직 분리 — PASS (처리완료 포장 안 함)
설계서 §7은 가격 잔존 불일치(3절 SIZ_000077·투명 가격 0행)를 "다음 단계·본 범위 밖"으로 정직 분리하고 침묵하지 않음 ✓. 처리완료로 포장하지 않음.

### V6-② R-5 위젯 가격조회 위험 = **라이브 증거상 실재 (격상 필요)**
designer는 R-5를 🔴로 표기하되 "가격 정합은 다음 단계"로 분리. **라이브 가격엔진 구조 검증 결과, R-5는 "다음 단계" 격하가 부적절한 실재 위험**:

- **디지털인쇄 공정비(COMP_PRINT_DIGITAL_S1)는 출력용지규격(plate축) siz 단위로만 존재** — 라이브 실측: 이 comp의 siz_cd = **SIZ_000499(316x467, 106행) + SIZ_000077(304x629=3절 작업사이즈, 106행) 둘뿐**. 즉 디지털인쇄 가격조회축 = 출력용지규격 siz.
- 가격 바인딩: `t_prd_product_price_formulas(prd_cd?,frm_cd)` → `t_prc_formula_components(frm_cd,comp_cd)` → `t_prc_component_prices(comp_cd, siz_cd)`. **comp+siz로 단가 룩업** (component_prices에 prd_cd 컬럼 없음).
- **결과**:
  - **316x467 32상품**: plate→SIZ_000499, 디지털인쇄 공정비 870행 SIZ_000499에 존재 → **정합 유지**.
  - **3절 330x660 3상품**: 디지털인쇄 공정비는 SIZ_000077(304x629)에 묶임. plate를 신규 SIZ_PROPOSE_3JEOL(330x660)로 보내면 그 siz에 디지털인쇄 가격 **0행** → **가격조회 즉시 깨짐**.
  - **투명 315x467 3상품**: 디지털인쇄 출력용지규격 공정비 **0행**. (투명엽서 product_size SIZ_000003/004 156행은 별색/주문옵션 가격이지 디지털인쇄 출력용지규격 공정비 아님) → **깨짐**.

**즉 본 plate 적재를 그대로 적용하면 3절3+투명3=6상품의 디지털인쇄 공정비 가격조회가 적용 직후 깨진다.** plate-siz↔가격-siz 조회축이 같은 siz여야 하는데(SIZ_000077↔plate, SIZ_000499↔plate), 신규 siz로 plate만 옮기고 가격을 안 옮기면 어긋남. designer R-5 진단은 **방향 정확**(라이브 입증)하나, **심각도가 "다음 단계 분리"가 아니라 "6상품 plate 적재 = 가격 정합과 동시 적용 강제 또는 6상품 plate 보류"여야** 깨짐을 막는다.

> **316x467 32상품은 본 위험과 무관** — 가격이 이미 SIZ_000499에 정합. 따라서 **316x467 32상품 plate 적재(국4절)는 단독 적재 가능·안전**. 위험은 3절·투명 6상품에 국한.

### V6-③ 투명 output_paper_typ_cd `.01` 적정성 (R-4) — 라이브 보강
설계서 §4.2는 투명 3행에 `.01`(국전계열) 부여하되 §4.2 ⚠와 R-4로 "투명 PET는 국전계열 종이 아님 → `.03`(기타)이 의미상 정확할 수 있음"을 정직 명시 ✓. 라이브 코드 = .01 국전계열·.02 46계열·.03 기타뿐(투명 전용 부재). **315x467이 316x467과 1mm 차이(V4-*)라 국4절 계열로 본 .01도 일리 있으나, PET 투명원단은 국전 종이가 아니므로 .03이 도메인상 정확**. designer 정직 분리 PASS — R-4 후니 확인.

---

## 능동 적발 결함 목록 (독립성 입증 — 생성≠검증·R6)

| # | 심각도 | 게이트 | 결함 | 증거(라이브/L1) | 라우팅 |
|---|--------|--------|------|------------------|--------|
| **G-1** | **MAJOR(심각도 격상)** | V6 | **R-5 "다음 단계" 격하 부적절** — 라이브 가격엔진상 디지털인쇄 공정비는 출력용지규격 siz(SIZ_000499·SIZ_000077)에만 존재. 3절·투명 6상품 plate를 신규 siz로 옮기면 **적용 직후 디지털인쇄 가격조회 즉시 깨짐**. plate 적재=가격 정합 동시 강제 또는 6상품 보류 필요 | COMP_PRINT_DIGITAL_S1 siz_cd = SIZ_000499(106)+SIZ_000077(106) 둘뿐. 신규 3절/투명 siz 가격 0행 | **designer→인간** (R-5 심각도 격상·6상품 적재 시점 결정) |
| **G-2** | MINOR(정직성) | V2 | 출력용지규격 컬럼 **공란 상품 3개**(오리지널박명함·봉투제작·썬캡), 설계서 R-1은 **1개만** 명시. 봉투제작·썬캡 누락 언급 | L1 3시트 공란 distinct 상품 = 3 | **designer** (R-1 범위 1→3 정정. 안전 영향 0) |
| **G-3** | MINOR | V1 | PRESERVE 라벨 오분류: SIZ_000148은 "other_ref"가 아니라 **shared**(total_plate 4>in_corr 2). 라이브 = other_ref 2(002·132)/shared 12. CSV 수치 정확·라벨만 부정확 | total_plate>in_corr: SIZ_000148(4>2) | **designer** (§5.1 라벨 정정. NOT EXISTS 가드가 실권위라 안전 영향 0. 1차판 F-3 재현) |
| **G-4** | MINOR | V4 | PRD_000016 KEEP 행 **dflt_plt_yn='N'** — 신규 37행은 전부 'Y'인데 KEEP되는 출력용지규격 기본판만 'N'으로 일관성 결여. 의미상 'Y'가 맞을 수 있음 | 라이브 PRD_000016 SIZ_000499 dflt_plt_yn=N | **designer→인간** (PRD_000016 dflt_plt_yn 정정 포함 여부 확인) |
| **G-5** | 검토(R-4 보강) | V4 | 투명 315x467이 **SIZ_000499(316x467)와 1mm 차이** — search-before-mint ±5mm에 SIZ_000499 포함. 신규 siz 등록 vs SIZ_000499 재사용 재고 여지(투명 가격=국4절 동일 시 siz 공유 단순) | ±5mm 범위에 SIZ_000499 매칭 | **designer→인간** (사용자 확정=신규지만 1mm 동일 명시) |
| **G-6** | 검토(builder) | V3 | DELETE WHERE에 **`prd_cd IN(38교정)` 조건 반드시 포함** — 누락 시 PRESERVE siz의 비교정(non-corr) 제품 plate 행 손실. 안전형 SQL(§4.4 2번째)은 이 조건 보유 | SIZ_000113 non-corr 4행 등 비교정 참조 실재 | **builder** (실행본 SQL DELETE에 prd_cd IN(38) AND siz_cd IN(76) 동시 한정 강제) |

> **독립성 입증**: 본 검증은 설계서를 무비판 승인하지 않고, ① **R-5를 라이브 가격엔진 구조(디지털인쇄 공정비=출력용지규격 siz 전용)로 검증해 "다음 단계 분리"가 6상품 가격조회 즉시 깨짐을 가리는 격하임을 적발(G-1 MAJOR)**, ② 설계서가 공란 1개로 본 것을 L1 재추출로 3개 적발(G-2), ③ 1차판 F-3 라벨 오분류 재현 적발(G-3), ④ KEEP 행 dflt_plt_yn 불일치(G-4)·1mm siz 중복(G-5)·DELETE 한정 누락 위험(G-6) 적발. 6건 능동 적발(독립성 충족).

---

## 인간 승인 큐

| ID | 분류 | 내용 | 상태 |
|----|------|------|------|
| **H-1** | **가격정합 시점(R-5/G-1)** | **3절·투명 6상품 plate 적재 = 가격 정합 동시 적용 강제 또는 6상품 보류**. 단독 적용 시 6상품 디지털인쇄 가격조회 즉시 깨짐. 316x467 32상품은 단독 적재 안전 | **인간 결정 대기(우선)** |
| **H-2** | 채번(R-6) | 신규 siz 2 채번(`SIZ_PROPOSE_3JEOL` 330x660·`SIZ_PROPOSE_TUMYEONG` 315x467). HANDOFF 번호조율(721+ 슬롯 권장) | 인간 승인 대기 |
| **H-3** | cut 정책(R-2) | 신규 siz 2 cut 치수: SIZ_000499 cut 306x457(여백 5mm) 보유. 330x660·315x467 동형 부여 여부. 현재 cut=NULL 제안 | 후니 확인 대기 |
| **H-4** | 투명 output_paper_typ_cd(R-4/G-5) | 투명 3행 `.01`(국전) vs `.03`(기타). PET 투명원단은 국전 종이 아님 → `.03` 의미상 정확. 단 315x467≈316x467(1mm) | 후니 확인 대기 |
| **H-5** | 정정의도(R-3/F-5 carry) | output_paper_typ_cd `.01` 일괄정정(NULL 38·.03 75→.01). 디지털인쇄=국전계열 도메인 타당하나 보존 아닌 정정 의도 확인 | 후니 확인 대기 |
| **H-6** | 범위(R-1/G-2) | 공란 상품 3개(오리지널박명함·봉투제작·썬캡) 비대상 처리 확인(공란=미입력 vs 출력용지규격 비적용 상품) | 후니 확인 대기 |
| **H-7** | KEEP 일관성(G-4) | PRD_000016 dflt_plt_yn='N'→'Y' 정정 포함 여부 | 후니 확인 대기 |
| **DRY-RUN** | 적재 | 라이브 롤백전용 DRY-RUN(BEGIN…ROLLBACK 쓰기 트랜잭션) = **lead 승인** 후 실행. G-1 결정·H-2 채번 선행 권고 | lead 승인 대기 |
| **COMMIT** | 적재 | 실제 INSERT/DELETE/UPDATE·siz 등록 = 인간 승인. NEVER COMMIT until approved | 인간 승인 대기 |

---

## GO/NO-GO

**CONDITIONAL-GO.**
- **무손실(V1)·권위 정합(V2)·FK 위상·멱등(V3)·라이브 사전검사(V4)·영향(V5)** = 라이브 대조로 안전·정합. **1차판 F-1(가격 NULL 자연키 멱등 깨짐)은 본 라운드 가격 미터치로 미발생** — 멱등 위험 해소 확인.
- **단 G-1(MAJOR/R-5)**: 라이브 증거상 디지털인쇄 공정비는 출력용지규격 siz(SIZ_000499·SIZ_000077)에만 존재 → **3절·투명 6상품 plate를 신규 siz로 옮기면 적용 직후 가격조회 즉시 깨짐**. 가격 정합 동시 적용 또는 6상품 보류가 인간 결정으로 선행돼야 함. "다음 단계 분리"는 심각도 격하.
- **316x467 32상품 plate 적재(국4절·SIZ_000499 재사용)는 가격 정합 유지·단독 적재 안전** → 즉시 적재 가능(GO).
- G-2~G-6(정직성·라벨·일관성·DELETE 한정)은 GO 차단 아님(병행 정정·builder 강제).

**적재가능성 집계**:
- **insertable(설계 정합·즉시 가능)**: 316x467 31상품 plate INSERT(PRD_000016 KEEP) + ORPHAN 62 soft-delete(316x467 상품 작업사이즈분) + 가격 무변경.
- **blocked(G-1 결정 전)**: 3절 3상품·투명 3상품 plate INSERT 6행 + 신규 siz 2(가격 정합 동시처리 결정 필요).
- **GAP/인간승인**: H-1 가격정합 시점(우선)·H-2 채번·H-3 cut·H-4 투명 코드·H-5 정정의도·H-6 공란 범위·H-7 KEEP 일관성·실 COMMIT·라이브 DRY-RUN(lead).
- **soft-delete**: ORPHAN 62 — plate 교정 후 NOT EXISTS 3중 가드로 안전(가격참조 0 라이브 확인).

**R-5 위젯 가격조회 위험 최종 평가**: **실재(MAJOR)**. plate-siz와 가격-siz가 같아야 디지털인쇄 공정비가 조회되는 구조(COMP_PRINT_DIGITAL siz=SIZ_000499·SIZ_000077). 316x467은 SIZ_000499로 정합 유지되나, 3절·투명 6상품을 신규 siz로 옮기면 그 siz에 디지털인쇄 가격 0행이라 즉시 깨짐. plate 적재와 가격 정합을 분리하면 6상품이 깨진 채 노출됨 → 동시 처리 또는 6상품 보류가 인간 결정으로 필요.
