# 출력용지규격 plate 적재 설계 — 상품마스터 컬럼 권위판

> **라운드**: 출력용지규격 plate 적재 설계 (사용자 확정 2026-06-07 — 재론 금지)
> **권위 입력**: 사용자 확정 결정(§0.1) · **상품마스터 각 시트 `파일사양_출력용지규격` 컬럼**(`06_extract/{digital-print,calendar,design-calendar}-l1.csv`, plate 적재 권위) · `08_remediation/output-paper-3way-reconciliation.md`(3자 관계) · 라이브 `railway` DB 읽기전용 직접 조회(2026-06-07).
> **선행 설계 관계**: 본 설계는 `08_remediation/plate-price-unify-design.md`(전지통일 1차판) + `03_validation/plate-price-unify-gate.md`(validator F-1~F-5 적발)를 **권위 보강·투명추가·결함반영**한 base다. 핵심 차이 = **(1) 권위를 라이브 plate가 아닌 상품마스터 출력용지규격 컬럼으로 전환**, **(2) 투명(315x467) 신규 siz 추가**(1차판은 투명을 국4절로 통일 — 3자 분석이 오류로 판정), **(3) 제품 범위를 출력용지규격 컬럼 보유 38상품으로 재확정**(1차판 42 ≠ 본판 38).
> **DB read-only**: `SELECT`/`information_schema`/`pg_index`만(2026-06-07). 라이브 INSERT/UPDATE/DELETE/DDL/COMMIT 없음. 비밀번호 stdout 미출력. 식별자/SQL 영어·해석 한국어. **자가 git 커밋 없음**.
> **범위**: 설계 + 근거 + 영향분석 + 라이브 read-only 검증까지. 실제 적용·siz 채번·COMMIT은 인간 승인 후 별도 실행본(`09_load/_migrate_plate_load_from_master/`).
> **부속 CSV**(`08_remediation/csv/`): `plate-load-products.csv`(38상품×출력용지규격→siz) · `plate-new-siz-proposals.csv`(신규 siz 2) · `plate-insert-rows.csv`(plate INSERT 37행) · `plate-delete-existing-rows.csv`(plate DELETE 114행 라이브 실측) · `plate-worksize-orphan-cleanup.csv`(작업사이즈 정리 76 distinct).

---

## 0. 요약 (orchestrator data)

### 0.1 사용자 확정 (권위 — 재론 금지)
`t_prd_product_plate_sizes`(판형) = **출력용지규격**. **권위 = 상품마스터 각 시트 `파일사양_출력용지규격` 컬럼**(판걸이수·라이브 plate 아님). 디지털인쇄 계열 plate를 이 컬럼 값으로 적재. 출력용지규격 3종: **316x467(국4절)·330x660(3절)·315x467(투명)**. 종이별 용지비·종이옵션(띤또레또 464x320 등)은 **별 트랙**(이번 범위 외). 가격 정합(3절·투명)은 **다음 단계**.

### 0.2 라이브 규명 확정 사실 (read-only 전수, 2026-06-07)
- **출력용지규격 siz 현황**(search-before-mint):
  - **316x467 = `SIZ_000499`**(work 316x467, cut 306x457, impos=Y, use_yn=Y) — **존재·재사용**.
  - **330x660 = 부재**(±5mm 양방향·siz_nm LIKE = 0행) → **신규 제안 1**.
  - **315x467 = 부재**(±5mm 양방향 = 0행) → **신규 제안 1**(투명).
- **plate 스키마**(라이브 `information_schema`):
  - PK = `(prd_cd, siz_cd)`. NOT NULL = `prd_cd`·`siz_cd`·`dflt_plt_yn`(char, **DEFAULT 없음** → INSERT 명시 필수, validator F-4)·`reg_dt`(DEFAULT now())·`del_yn`(DEFAULT 'N').
  - `output_paper_typ_cd` = NULLABLE, FK→`t_cod_base_codes` **RESTRICT**. 코드 `OUTPUT_PAPER_TYPE.01`(국전계열, use_yn=Y) 실재.
- **38상품 plate 현황**: 총 **114행**. PRD_000016(프리미엄엽서) = `SIZ_000499` 1행(**이미 정답 → KEEP**). 나머지 37상품 = 작업사이즈 중복행(impos=N) 참조 = 잘못된 패턴.
- **기존 output_paper_typ_cd 분포**(38상품 plate 114행): `NULL` 38 / `.03`(기타) 75 / `.01`(국전계열) 1(PRD_000016만).
- **siz 자식 FK delete_rule**(라이브 확인): plate→siz **RESTRICT** / prodsize→siz **RESTRICT** / component_prices→siz **CASCADE**. → 작업사이즈 정리는 plate 교정 *후* NOT EXISTS 3중 가드로만 안전.
- **가격 정합**: `SIZ_000499`(국4절) 가격 **870행**(validator F-2 정정값, 1차판 923 오기). `SIZ_000077`(3절 작업사이즈 304x629) 가격 304행. 투명(315x467) 가격 = **0행**(별도 siz 부재).

### 0.3 핵심 수치
| 항목 | 값 |
|------|-----|
| 출력용지규격 컬럼 보유 시트 | **3** (digital-print·calendar·design-calendar) |
| 출력용지규격 컬럼 보유 상품(distinct prd_cd) | **38** |
| └ **316x467**(국4절, SIZ_000499 재사용) | **32상품** (PRD_000016 KEEP → INSERT 31) |
| └ **330x660**(3절, 신규 siz) | **3상품** (PRD_000030·049·112) |
| └ **315x467**(투명, 신규 siz) | **3상품** (PRD_000019·025·039) |
| 혼용 상품(1상품 다종 출력용지규격) | **0** (제품당 distinct=1) |
| **신규 siz 제안** | **2개** (SIZ_PROPOSE_3JEOL 330x660 · SIZ_PROPOSE_TUMYEONG 315x467) |
| plate DELETE | **113행** (114 − PRD_000016 KEEP 1) |
| plate INSERT | **37행** (제품당 출력용지규격 1행 collapse, PRD_000016 제외) |
| 작업사이즈 정리(소프트삭제 후보) | **76 distinct siz 중 ORPHAN 62 → soft-delete** / PRESERVE 14(other_ref 3·shared 11) |
| 가격 잔존 불일치 | 🟡 3절(plate 330x660 ≠ 가격 SIZ_000077) · 투명(plate 315x467 ≠ 가격 SIZ_000499·투명 가격 0행) — **다음 단계** |
| 미해결 | 🟡 신규 siz 2 채번(인간)·cut 정책 · 🔴 가격 정합(다음 단계) |

---

## 1. 권위 = 상품마스터 출력용지규격 컬럼 (전수 추출)

### 1.1 추출 결과 (라이브 대조 검증)
상품마스터 시트 중 **`파일사양_출력용지규격` 단일 컬럼 보유 = digital-print·calendar·design-calendar 3시트**. booklet·photobook·stationery는 표지/내지 분리 구조라 출력용지규격 단일 컬럼 부재(작업사이즈만) → 본 라운드 비대상.

| 시트 | 컬럼 idx | 출력용지규격 분포(셀 count) |
|------|---------|------------------------------|
| digital-print | `파일사양_출력용지규격`(17) | 316x467(56) · 330x660(5) · 315x467(3) |
| calendar | `파일사양_출력용지규격`(16) | 316x467(13) · 330x660(1) |
| design-calendar | `파일사양_출력용지규격`(16) | 316x467(6) · 330x660(1) |

> calendar·design-calendar의 330x660 1행은 **둘 다 와이드벽걸이캘린더(PRD_000112)** — 동일 상품(시트 중복). 따라서 distinct prd_cd 기준 3절은 3상품.

### 1.2 distinct 상품×출력용지규격 (38상품, 혼용 0)
JOIN KEY=`prd_nm`으로 라이브 38상품 전건 prd_cd 매핑 성공. **혼용 0건**(상품당 distinct 출력용지규격=1) → 제품당 plate 1행으로 collapse 가능. 전수 = `csv/plate-load-products.csv`.

### 1.3 1차 전지통일 설계와의 범위 차이 (정직 명시)
| 항목 | 1차판(plate-price-unify) | 본판(상품마스터 권위) | 차이 사유 |
|------|---------------------------|------------------------|-----------|
| 권위 | 판걸이수 시트 상품명 + 라이브 plate | **상품마스터 출력용지규격 컬럼** | 사용자 확정 |
| 제품 범위 | 42(국4절 39·3절 3) | **38**(316x467 32·330x660 3·315x467 3) | 1차판은 출력용지규격 컬럼 공란 상품(오리지널박명함 PRD_000037 등)·판걸이수 등재분 포함. 본판은 **출력용지규격 컬럼 명시값 보유 상품만** |
| 투명(019/025/039) | 국4절(316x467)로 통일 | **315x467 신규 siz** | 3자 분석이 "국4절 통일은 오류" 판정. 상품마스터 컬럼 = 315x467 명시 |
| 신규 siz | 1(330x660) | **2(330x660·315x467)** | 투명 추가 |

> ⚠ **PRD_000037(오리지널박명함)**: 1차판 39 국4절 목록엔 포함됐으나, 상품마스터 digital-print `출력용지규격` 컬럼에 **명시값 없음**(공란) → 본판 권위에서 **비대상**. plate 교정 시 건드리지 않음. 🟡 R-1.

---

## 2. 출력용지규격 siz 매핑

| 출력용지규격 | siz_cd | 처리 | search-before-mint |
|--------------|--------|------|---------------------|
| **316x467**(국4절) | `SIZ_000499` | **REUSE**(라이브 존재·impos=Y) | — (존재) |
| **330x660**(3절) | `SIZ_PROPOSE_3JEOL`(placeholder, 인간 채번) | **NEW** | 라이브 0행(부재) ✓ |
| **315x467**(투명) | `SIZ_PROPOSE_TUMYEONG`(placeholder, 인간 채번) | **NEW** | 라이브 0행(부재) ✓ |

전수 = `csv/plate-new-siz-proposals.csv`.

---

## 3. 신규 siz 등록 제안 (2개)

> 부속 CSV `csv/plate-new-siz-proposals.csv`. `output_paper_typ_cd`는 t_siz_sizes 컬럼 아님(plate 컬럼) → siz엔 부여 안 함.

### 3.1 SIZ_PROPOSE_3JEOL (330x660)
| 항목 | 값 |
|------|-----|
| siz_nm | `330x660` |
| work_width / work_height | 330.00 / 660.00 |
| cut_width / cut_height | NULL (전지 인쇄가능영역 정책 후니 확인 — 🟡 R-2) |
| impos_yn | `Y` (조판용 전지) |
| use_yn / del_yn | `Y` / `N` |
| note | `[전지] 디지털인쇄 3절(330x660). 지그재그/와이드접지/와이드벽걸이캘린더` |
| reg_dt | DEFAULT now() (**명시 NULL 금지** — NOT NULL DEFAULT 함정, 메모리 교훈) |

### 3.2 SIZ_PROPOSE_TUMYEONG (315x467, 투명)
| 항목 | 값 |
|------|-----|
| siz_nm | `315x467` |
| work_width / work_height | 315.00 / 467.00 |
| cut_width / cut_height | NULL (🟡 R-2) |
| impos_yn | `Y` (조판용 투명 PET 전지) |
| use_yn / del_yn | `Y` / `N` |
| note | `[전지] 디지털인쇄 투명 PET(315x467). 투명엽서/투명포토카드/투명명함` |
| reg_dt | DEFAULT now() |

### 3.3 등록 SQL (설계만)
```sql
INSERT INTO t_siz_sizes (siz_cd, siz_nm, work_width, work_height, impos_yn, use_yn, note, del_yn)
VALUES
 ('<채번_3JEOL>',   '330x660', 330.00, 660.00, 'Y', 'Y', '[전지] 디지털인쇄 3절(330x660)', 'N'),
 ('<채번_TUMYEONG>','315x467', 315.00, 467.00, 'Y', 'Y', '[전지] 디지털인쇄 투명 PET(315x467)', 'N')
ON CONFLICT (siz_cd) DO NOTHING;  -- reg_dt/del_yn DEFAULT 발화. 명시 NULL 금지
```

---

## 4. plate 재기재 매핑

> 부속 CSV `csv/plate-insert-rows.csv`(37 INSERT) · `csv/plate-delete-existing-rows.csv`(114 DELETE 라이브 실측).

### 4.1 교정 규칙
제품별 기존 plate 행(작업사이즈 중복행 참조)을 **전부 DELETE → 출력용지규격 siz 1행 INSERT**(collapse). PRD_000016 = SIZ_000499 1행 이미 정답 → **KEEP**(건드리지 말 것).

| 출력용지규격 | plate target siz | output_paper_typ_cd | dflt_plt_yn | INSERT 행수 |
|--------------|------------------|---------------------|-------------|-------------|
| 316x467(국4절) | `SIZ_000499` | `OUTPUT_PAPER_TYPE.01` | `Y` | **31** (32 − PRD_000016 KEEP) |
| 330x660(3절) | `SIZ_PROPOSE_3JEOL` | `OUTPUT_PAPER_TYPE.01` | `Y` | **3** |
| 315x467(투명) | `SIZ_PROPOSE_TUMYEONG` | `OUTPUT_PAPER_TYPE.01` | `Y` | **3** |
| **합계 INSERT** | | | | **37** |

DELETE 행수: **113** (114 − PRD_000016 1행 KEEP).

### 4.2 output_paper_typ_cd `.01` 일괄부여 = 기존 값 정정 (validator F-5)
기존 38상품 plate 114행의 output_paper_typ_cd = NULL 38 / `.03`(기타) 75 / `.01` 1(PRD_000016). collapse INSERT 시 전 37행에 **`.01`(국전계열)** 부여 → 기존 NULL/`.03`이 `.01`로 의미 변경(보존 아닌 **정정**). 디지털인쇄 출력용지규격은 국전계열이므로 `.01` 부여는 도메인상 타당(오히려 기존 NULL/.03이 부정확). FK(.01 존재·use_yn=Y) 충족. 🟡 **R-3**(정정 의도 후니 확인).

> ⚠ 단 **투명(315x467)을 `.01` 국전계열로 부여하는 것의 적정성**: 315x467은 PET 투명원단이며 국전 계열 종이가 아니다. output_paper_typ_cd 코드는 `.01 국전계열·.02 46계열·.03 기타`뿐 — 투명 PET 전용 코드 부재. **투명 3행은 `.01`보다 `.03`(기타)이 의미상 정확할 수 있음** → 🟡 **R-4**(투명 output_paper_typ_cd 후니 확인). 현재 CSV는 `.01` 제안(전지 일괄정합 우선)이나 본 모호 명시.

### 4.3 INSERT SQL (설계만, dflt_plt_yn 명시 — F-4)
```sql
-- 국4절 31행 (PRD_000016 제외)
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, del_yn)
SELECT v.prd_cd, 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01', 'N'
FROM (VALUES ('PRD_000017'),('PRD_000018'),... ) v(prd_cd)   -- csv/plate-insert-rows.csv 국4절 31행
ON CONFLICT (prd_cd, siz_cd) DO NOTHING;  -- reg_dt DEFAULT now() 발화
-- 3절 3행 → '<채번_3JEOL>' / 투명 3행 → '<채번_TUMYEONG>' 동형
```

### 4.4 DELETE SQL (설계만)
```sql
-- 38상품 작업사이즈 plate 행 제거(PRD_000016 SIZ_000499 KEEP 제외)
DELETE FROM t_prd_product_plate_sizes
WHERE prd_cd IN (<38 corr prd_cd>)
  AND NOT (prd_cd='PRD_000016' AND siz_cd='SIZ_000499')  -- KEEP 가드
  AND siz_cd <> 'SIZ_000499' OR (prd_cd<>'PRD_000016' AND siz_cd='SIZ_000499' /*없음*/);
-- 안전형: 제거 대상 = 작업사이즈 siz 목록(impos=N + SIZ_000023/024 impos=Y 단독)으로 한정
DELETE FROM t_prd_product_plate_sizes
WHERE prd_cd IN (<38 corr>) AND siz_cd IN (<csv/plate-worksize-orphan-cleanup.csv siz 목록 76종>);
```
> DELETE는 **작업사이즈 siz 목록 한정**으로 PRD_000016 SIZ_000499 자동 보존(SIZ_000499는 작업사이즈 목록에 없음). 2회차 0행 = 멱등.

---

## 5. 작업사이즈 중복행 정리

> 부속 CSV `csv/plate-worksize-orphan-cleanup.csv` = 76 distinct siz 전수 + 고아 판정(라이브 독립 재산정).

### 5.1 라이브 독립 재산정 (2026-06-07)
38상품 plate가 참조하던 **76 distinct 작업사이즈 siz**를 라이브 전수 판정(total_plate_refs / plate_refs_in_corr / prodsize_refs / price_refs):

| 분류 | 조건 | 수 | 처리 |
|------|------|----|------|
| **ORPHAN** | total_plate=plate_in_corr & prodsize=0 & price=0 → 교정후 무참조 | **62** | soft-delete(`del_yn='Y'`, del_dt=now()) |
| **PRESERVE_OTHER_REF** | prodsize>0 또는 price>0 (비교정 plate 공유 아님) | **3** | 보존 강제(SIZ_000002 prodsize7·SIZ_000132 prodsize1+price3·SIZ_000148 prodsize5+price3) |
| **PRESERVE_SHARED** | total_plate>plate_in_corr(비교정 제품도 참조) | **11** | 보존(그중 SIZ_000113 plate11>7+price3·SIZ_000147 plate2>1+price3 = SHARED+PRICE 복합. 나머지 114/115/157/171/173/175/179/180/181) |

> PRESERVE 합계 = **14**(other_ref 3 + shared 11). SIZ_000113·147은 비교정 plate 공유(shared) **이며 동시에** 가격(별색엽서 3행씩) 보유 → 어느 한쪽 가드만으로도 보존됨(CASCADE 위험). 별색엽서 가격은 별 트랙 검토. 분류 라벨이 어긋나도 §5.2 NOT EXISTS 3중 가드가 실권위라 잘못 soft-delete될 siz는 0.

### 5.2 안전 정리 규칙 (NOT EXISTS 3중 가드 — soft-delete)
```sql
UPDATE t_siz_sizes SET del_yn='Y', del_dt=now()
WHERE siz_cd IN (<ORPHAN 62 목록>)
  AND del_yn='N'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes x WHERE x.siz_cd=t_siz_sizes.siz_cd)
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes  x WHERE x.siz_cd=t_siz_sizes.siz_cd)
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices x WHERE x.siz_cd=t_siz_sizes.siz_cd);
```
→ plate 교정(DELETE) **후에만** 실행해야 plate_refs=0. 3중 가드가 진짜 안전망 — 라벨이 어긋나도 잘못 soft-delete될 siz는 0. **soft-delete만**(del_yn 토글, 물리삭제 아님) → 롤백 복원 가능, 손실 0.

### 5.3 무손실
작업사이즈 정보는 런타임 재현(작업사이즈는 블리드+재단사이즈에서 도출) 또는 보존행으로 유지. soft-delete는 물리삭제 아님 → 롤백 시 `del_yn='N'` 복원. 손실 0.

---

## 6. 마이그레이션 설계 (설계만 — 실제 COMMIT/DDL/채번은 인간 승인)

> [HARD] 본 절은 설계다. 라이브 INSERT/UPDATE/DELETE/DDL/COMMIT 미실행. 적용은 인간 승인 후 별도 실행본(`09_load/_migrate_plate_load_from_master/`).

### 6.1 적용 순서 (FK 위상 + 무손실 게이트)
```
1) [신규 siz 선등록]   SIZ_PROPOSE_3JEOL(330x660) + SIZ_PROPOSE_TUMYEONG(315x467) INSERT ON CONFLICT DO NOTHING.
                      316x467 SIZ_000499 라이브 선존재 → 등록 0.
2) [plate 재기재]      37상품(국4절 31 + 3절 3 + 투명 3):
                      - DELETE 기존 plate 행(작업사이즈 목록 한정, 113행) — PRD_000016 SIZ_000499 자동보존
                      - INSERT 출력용지규격 1행/제품(dflt_plt_yn='Y'·output_paper_typ_cd='.01') = 37행
3) [작업사이즈 정리]   plate 참조 제거 후 NOT EXISTS 3중 확인 → ORPHAN 62 soft-delete
                      PRESERVE 14(other_ref 3·shared 11) 보존
```
RESTRICT(plate→siz)·CASCADE(price→siz) 때문에 **1)→2)→3) 순서 강제**. 신규 siz는 부모 추가라 무위험. PRESERVE siz는 절대 삭제 안 함.

### 6.2 영향 분석
| 영향 대상 | 변화 | 위험 |
|-----------|------|------|
| `t_siz_sizes` | 신규 siz 2 INSERT + ORPHAN 62 soft-delete(조건부) | 신규=부모추가 무위험. soft-delete=NOT EXISTS 3중 가드로 안전 |
| `t_prd_product_plate_sizes` | DELETE 113 + INSERT 37 (114행→38행) | 판수(판걸이수)=앱 런타임 계산(메모리 `dbmap-compute-in-app-db-stores-lookup`)이라 plate 행수 축소 무해. output_paper_typ_cd FK(.01) 존재 |
| `t_prc_component_prices` | **무변경**(본 라운드는 가격 미터치) | 0 — 단 §7 가격 잔존 불일치 |
| `t_prd_product_sizes` | 무변경 | 0 |

### 6.3 롤백
- before-state 백업: 38상품 plate 114행 + 정리대상 siz del_yn 상태 → `_migrate_plate_load_from_master/backup_*`.
- 롤백 = 신규 siz del_yn='Y' / plate 원행 114 재INSERT·출력용지규격행 DELETE / ORPHAN siz del_yn='N' 복원. 멱등.

### 6.4 멱등성 (1차판 F-1 교훈 반영)
- 신규 siz: `ON CONFLICT (siz_cd) DO NOTHING`(siz_cd PK NOT NULL → 정상 발화).
- plate INSERT: `ON CONFLICT (prd_cd, siz_cd) DO NOTHING`(PK 둘 다 NOT NULL → 정상 발화). 신규 37행 라이브 선존재 0 확인.
- plate DELETE: `WHERE siz_cd IN(작업사이즈 목록)` 2회차 0행 = 멱등.
- soft-delete: `del_yn='Y' AND del_yn='N'` 2회차 0행 = 멱등.
> ⚠ **1차판 BLOCKER-1(가격 마이그 ON CONFLICT NULL 자연키 비발화)는 본 라운드에 미적용** — 본 라운드는 가격(component_prices)을 **터치하지 않음**. 따라서 F-1 멱등 깨짐 위험 없음. plate/siz의 PK는 전부 NOT NULL이라 ON CONFLICT 정상.

### 6.5 라이브 검증 (읽기전용, COMMIT 없음 — 본 설계 완료분)
- 330x660 + 315x467 search-before-mint = 0행(부재) ✓
- SIZ_000499 = 316x467(work) impos=Y use_yn=Y, plate 1(PRD_000016) ✓
- 38상품 plate = 114행, PRD_000016=SIZ_000499 1행 ✓
- 76 distinct 작업사이즈 → ORPHAN 62 / PRESERVE 14(other_ref 3·shared 11) 독립 재산정 ✓
- plate dflt_plt_yn NOT NULL·DEFAULT 없음 → INSERT 명시 필요 ✓(F-4 반영)
- output_paper_typ_cd FK RESTRICT·`.01` 존재 ✓
- siz 자식 FK: plate/prodsize RESTRICT·price CASCADE ✓

---

## 7. 가격 잔존 불일치 (다음 단계 — 침묵 금지)

본 라운드는 plate를 출력용지규격 siz로 적재할 뿐, 가격(component_prices)을 터치하지 않는다. 따라서 plate-siz와 가격-siz가 어긋나는 잔존 불일치가 발생한다. 이는 **사용자 확정상 다음 단계**이며 본 범위 밖이다. 정직 명시:

| 출력용지규격 | plate siz(본 라운드 후) | 가격 siz(현행) | 정합 여부 | 처리(다음 단계) |
|--------------|--------------------------|----------------|-----------|------------------|
| 316x467(국4절) | `SIZ_000499` | `SIZ_000499`(870행) | ✅ **정합** | 변경 불요 |
| 330x660(3절) | `SIZ_PROPOSE_3JEOL`(신규) | `SIZ_000077`(304x629 작업사이즈, 304행) | ❌ **불일치** | 3절 가격 304행을 신규 3절 siz로 마이그(1차판 §4, F-1 수정안: UPDATE siz_cd 방식) |
| 315x467(투명) | `SIZ_PROPOSE_TUMYEONG`(신규) | (투명 전용 가격 **0행**) | ❌ **미확인** | 투명 가격이 국4절 가격(SIZ_000499) 공유인지·별도 종이비 필요한지 도메인 확인. 위젯 조회축(plate-siz=가격-siz) 깨짐 — 가격 매핑 재설계 필요 |

> 🔴 **R-5**: 투명(315x467) plate를 신규 siz로 보내면 위젯의 plate-siz↔가격-siz 조회축이 깨진다(투명 가격 siz 부재). 본 plate 적재는 출력용지규격 권위 충실이나, **가격 정합 없이 plate만 적재하면 위젯 가격 조회 실패 위험** → 가격 정합을 plate 적재와 동시 또는 직후에 처리할지 후니 결정 필요. (3절도 동일 — 단 3절은 SIZ_000077 가격이 실재하므로 마이그 경로 명확.)

---

## 8. 결정 필요 / 모호 플래그

| ID | 분류 | 내용 |
|----|------|------|
| 🟡 R-1 | 범위 | **PRD_000037(오리지널박명함)**: 1차판 39 국4절 목록 포함이나 상품마스터 출력용지규격 컬럼 공란 → 본판 비대상. 누락 의도인지(공란=미입력) 후니 확인. |
| 🟡 R-2 | cut 정책 | **신규 siz cut 치수**: 전지 인쇄가능영역(cut) 보유 여부. SIZ_000499는 cut 306x457 보유(여백 5mm). 330x660·315x467도 동형 부여할지 후니 확정. 현재 cut=NULL 제안. |
| 🟡 R-3 | 정정의도 | **output_paper_typ_cd `.01` 일괄정정**: 기존 NULL 38·`.03` 75를 `.01`로 정정(보존 아님). 디지털인쇄=국전계열이라 도메인 타당. 정정 의도 후니 확인(F-5 carry). |
| 🟡 R-4 | 모호 | **투명 output_paper_typ_cd**: 315x467은 PET 투명원단으로 국전계열 종이 아님. 코드(.01국전/.02 46/.03 기타)에 투명 전용 부재 → 투명 3행은 `.03`(기타)이 의미상 정확할 수 있음. 현재 `.01` 제안(전지 일괄정합)이나 후니 확인. |
| 🔴 R-5 | 가격정합(다음단계) | **plate-siz↔가격-siz 조회축**: 투명(315x467 plate)은 투명 가격 siz 부재로 위젯 가격 조회 깨짐. 3절(330x660 plate)은 가격 SIZ_000077 불일치. 가격 정합 시점(plate와 동시/직후) 후니 결정. |
| 🟡 R-6 | 채번 | **신규 siz 2 채번**(HANDOFF 번호조율, 721+ 슬롯 권장). placeholder `SIZ_PROPOSE_3JEOL`·`SIZ_PROPOSE_TUMYEONG`. |
| 🟢 R-7 | 정보 | **국4절 32상품 = SIZ_000499 가격(870행) 이미 정합**. PRD_000016 plate KEEP. 본 라운드 실작업 = 신규 siz 2 + plate 113 DELETE/37 INSERT + ORPHAN 62 soft-delete. |

---

## 9. 산출 핵심 수치 (재게재)

| 항목 | 값 |
|------|-----|
| 출력용지규격 컬럼 보유 상품 | **38** (digital-print 33·calendar 5·design-calendar 중복) |
| 출력용지규격별 분포 | 316x467 **32** · 330x660 **3** · 315x467 **3** |
| 신규 siz | **2** (SIZ_PROPOSE_3JEOL 330x660 · SIZ_PROPOSE_TUMYEONG 315x467) |
| plate | DELETE **113** + INSERT **37** (114행 → 38행 collapse) |
| 작업사이즈 정리 | 76 distinct 중 **ORPHAN 62 soft-delete** / PRESERVE 14(other_ref 3·shared 11) |
| 가격 잔존 불일치 | 316x467 정합 · **330x660 불일치(SIZ_000077)** · **315x467 미확인(투명 가격 0행)** — 다음 단계 |
| 미해결 | 🟡 신규siz 2 채번·cut·output_paper_typ_cd 투명 · 🔴 가격 정합(R-5, 다음 단계) |

## 판정
설계 완료. 권위 = **상품마스터 `파일사양_출력용지규격` 컬럼**(라이브 plate·판걸이수 아님). 출력용지규격 컬럼 보유 38상품을 출력용지규격 3종(316x467 32·330x660 3·315x467 3)으로 plate 적재. 316x467=`SIZ_000499` 재사용(가격 870행 이미 정합·변경0), 330x660·315x467(투명)=신규 siz 2 + plate 113 DELETE/37 INSERT + 작업사이즈 ORPHAN 62 soft-delete. 무손실 입증(NOT EXISTS 3중 가드·soft-delete·PRESERVE 14 보존). 멱등(plate/siz PK NOT NULL → ON CONFLICT 정상, 1차판 F-1 가격 NULL 자연키 위험 미적용 — 가격 미터치). 라이브 read-only 검증 전건 통과. **가격 정합(3절·투명)은 다음 단계로 분리 명시**(R-5, 침묵 안 함). **실제 COMMIT·신규 siz 채번·output_paper_typ_cd 투명 정책은 인간 승인 대기(R-1~R-6)**.
