# MIGRATION — 국4절(316x467) 32상품 plate 적재 실행본

> **라운드**: 국4절 316x467 32상품 plate 적재 (round-5 적재 실행본, 사용자 확정 2026-06-07)
> **권위 입력(재매핑 금지)**: `08_remediation/plate-load-from-master-design.md` + `csv/plate-load-products.csv`
> (출력용지규격 권위=상품마스터 `파일사양_출력용지규격` 컬럼) · `03_validation/plate-load-from-master-gate.md`
> (V1~V6·G-1~G-6 적발 반영) · 라이브 `railway` DB read-only 검증(2026-06-07).
> **[HARD]** 라이브 INSERT/UPDATE/DELETE/DDL/COMMIT 미실행. 멱등 SQL + 로더(기본 ROLLBACK)까지만.
> 비밀번호 stdout 미출력. 자가 git 커밋 없음.

---

## 0. 요약

| 항목 | 값 |
|------|-----|
| 대상 | 국4절 316x467 **32상품** (PRD_000016 KEEP + 31 교정) |
| target siz | `SIZ_000499` (316x467·cut 306x457·impos=Y·use_yn=Y·라이브 존재) — **REUSE, 신규 siz 0** |
| plate DELETE | **101행** (31교정상품 작업사이즈 plate 행, siz_cd<>SIZ_000499) — 라이브 실측 확인 |
| plate INSERT | **31행** (31상품 × SIZ_000499, `dflt_plt_yn='Y'`·`OUTPUT_PAPER_TYPE.01`) |
| PRD_000016 | **KEEP** (SIZ_000499 1행 이미 정답. 작업사이즈 목록에 없어 DELETE 대상 외) |
| 작업사이즈 soft-delete | **53행** (32상품 범위 ORPHAN. 라이브 재산정·NOT EXISTS 3중 가드) |
| 신규 siz / DDL | **0** |
| 가격(component_prices) | **무변경** (본 라운드 미터치) |
| 제외(범위 외) | 3절 3상품(PRD_000030·049·112)·투명 3상품(PRD_000019·025·039) — 가격 정합 트랙 분리 |

---

## 1. 범위 확정 — 왜 32상품만인가 (validator G-1 반영)

설계서(`plate-load-from-master-design.md`)는 출력용지규격 컬럼 보유 **38상품** 전체를 대상으로 했다.
validator(`plate-load-from-master-gate.md`)가 **G-1 MAJOR**를 적발: 디지털인쇄 공정비
(`COMP_PRINT_DIGITAL_S1`)는 출력용지규격 siz(`SIZ_000499`·`SIZ_000077`) 단위로만 존재하므로,
3절(330x660)·투명(315x467) 6상품을 **신규 siz**로 옮기면 그 siz에 디지털인쇄 가격 0행 → 적용 직후
가격조회가 즉시 깨진다.

- **316x467 32상품은 가격이 이미 SIZ_000499(870행)에 정합** → plate를 SIZ_000499로 보내도 가격조회 유지.
  validator V6: *"316x467 32상품 plate 적재(국4절·SIZ_000499 재사용)는 가격 정합 유지·단독 적재 안전 → 즉시
  적재 가능(GO)."*
- 사용자 확정(2026-06-07): **국4절 32상품만 적재. 3절·투명 6상품 제외**(가격 정합은 다음 단계 분리).

본 실행본은 그 GO 부분집합만 구현한다. 신규 siz·DDL이 전혀 없는 이유 = SIZ_000499 라이브 재사용.

---

## 2. 적용 순서 (FK 위상 + 무손실 게이트)

```
apply.sql (단일 BEGIN…COMMIT, ON_ERROR_STOP on)
 ├ 01_plate_correction_guk4.sql
 │    DELETE 31교정 작업사이즈 plate 101행  (prd_cd IN(31) AND siz_cd<>SIZ_000499 AND del_yn='N')
 │    INSERT 31 × SIZ_000499 (dflt_plt_yn='Y'·OUTPUT_PAPER_TYPE.01) ON CONFLICT(prd_cd,siz_cd) DO NOTHING
 └ 02_worksize_orphan_cleanup.sql
      UPDATE 53 ORPHAN siz del_yn='Y'·del_dt=now()  (del_yn='N' AND NOT EXISTS ×3 가드)
```

**순서 강제 근거**: siz 자식 FK `t_prd_product_plate_sizes → t_siz_sizes` = **RESTRICT**(라이브 확인).
plate가 작업사이즈 siz를 참조하는 동안은 그 siz를 건드릴 수 없다. 따라서 plate DELETE(01)를 먼저 해
plate_refs=0을 만든 후에야 siz soft-delete(02)의 `NOT EXISTS(plate)` 가드가 참이 된다. soft-delete는
del_yn 토글이라 RESTRICT 자체는 미발화하지만, 의미상 무참조 확인이 선행돼야 정당.

---

## 3. 검증 적발 반영 (게이트 V/G → 실행본)

| 적발 | 심각도 | 본 실행본 반영 |
|------|--------|----------------|
| **G-1**(R-5) 가격조회축 깨짐 | MAJOR | **3절·투명 6상품 제외** — 본 실행본은 316x467 32상품만(가격 정합 유지분). 6상품·신규 siz 0 |
| **G-6** DELETE prd_cd 한정 누락 위험 | builder 강제 | `01` DELETE = `prd_cd IN(31) AND siz_cd<>SIZ_000499` **양조건**. 비교정(non-corr) 제품의 PRESERVE siz plate 보존 |
| **F-4** dflt_plt_yn NOT NULL DEFAULT 없음 | — | `01` INSERT 31행 전건 `dflt_plt_yn='Y'` 명시 |
| **F-5/H-5** output_paper_typ_cd `.01` 일괄정정 | 후니 확인(H-5) | `01` INSERT 전건 `OUTPUT_PAPER_TYPE.01`. 기존 NULL/.03 → .01 정정(디지털인쇄=국전계열, 타당) |
| reg_dt NOT NULL DEFAULT now() 함정 | 메모리 교훈 | INSERT 컬럼 목록에서 `reg_dt` 생략 → DEFAULT now() 발화(명시 NULL 금지) |
| **F-1**(1차판 가격 ON CONFLICT NULL) | 무관 | 본 라운드 component_prices 미터치 → F-1 멱등 위험 미발생 |
| **G-3** PRESERVE 라벨 오분류 | 안전영향0 | 라벨 무관 — 본 실행본은 라이브 NOT EXISTS 3중 가드가 실권위. 후보 목록 53은 32범위 라이브 재산정 |

### G-4 / PRD_000016 dflt_plt_yn 메모 (인간 결정)
라이브 PRD_000016 SIZ_000499의 `dflt_plt_yn='N'`. 신규 INSERT 31행은 전부 'Y'라 KEEP행만 'N'으로 일관성
결여 가능. **본 실행본은 PRD_000016을 건드리지 않음**(KEEP 가드). 'N'→'Y' 정정 포함 여부는 인간 결정
(아래 H-3). 적재 안전엔 무영향(NOT NULL 충족).

---

## 4. 영향 분석

| 영향 대상 | 변화 | 위험 |
|-----------|------|------|
| `t_prd_product_plate_sizes` | DELETE 101 + INSERT 31 (32상품 102행→32행 collapse) | 판수(판걸이수)=앱 런타임 임포지션 계산(메모리 `dbmap-compute-in-app-db-stores-lookup`)이라 plate 행수 축소 무해. output_paper_typ_cd FK(.01) 라이브 존재·use_yn=Y |
| `t_siz_sizes` | 53 ORPHAN soft-delete(del_yn='Y') | NOT EXISTS 3중 가드(plate·prodsize·price)로 안전. 53행 전건 prodsize/price 참조 0 라이브 확인 |
| `t_prc_component_prices` | **무변경** | 0 — SIZ_000499 가격 870행 그대로 유지. 316x467 가격 정합 유지 |
| `t_prd_product_sizes` | 무변경 | 0 |
| 비교정(non-corr) 제품 plate | **무변경** | 0 — DELETE가 `prd_cd IN(31)` 한정(G-6). PRESERVE siz(SIZ_000113/114/115/144 등)는 6상품·non-corr 참조 보존 |

### SIZ_000499 정합 유지 근거
SIZ_000499 가격행 870(validator F-2 정정값). 32상품 plate가 SIZ_000499를 가리키고 가격도 SIZ_000499에
있으므로 위젯 plate-siz↔가격-siz 조회축 정합. **316x467은 G-1 위험 무관**(가격 이미 정합).

---

## 5. 멱등성 근거 (R1)

라이브 read-only 자기검사(2026-06-07, write 트랜잭션 없음):

| 문 | 1회차 | 2회차 | 멱등 보장 |
|----|-------|-------|-----------|
| plate DELETE | 101행 | **0행** | `siz_cd<>SIZ_000499 AND del_yn='N'` — 작업사이즈행 이미 삭제됨 |
| plate INSERT | 31행 | **0행** | `ON CONFLICT(prd_cd,siz_cd) DO NOTHING` — 1회차 후 (prd,499) 존재. PK 둘 다 NOT NULL → 정상 발화 |
| siz soft-delete | 53행 | **0행** | `del_yn='N'` 조건 — 1회차 후 'Y'. NOT EXISTS 3중도 참 유지 |

자기검사 결과: SC-1 DELETE=101 ✓ · SC-2 (prd,499) 선존재=0(전부 fresh INSERT) ✓ · SC-3 PRD_000016 KEEP
1행·전부 siz=499 ✓ · SC-4 53 ORPHAN의 corr-31 외 active plate 참조=0(DELETE 후 무참조 보장) ✓.

> **PK NOT NULL 확인**: plate PK=(prd_cd,siz_cd) 둘 다 NOT NULL, siz PK=siz_cd NOT NULL → ON CONFLICT
> 자연키 정상 발화. 1차판 F-1(가격 마이그 ON CONFLICT NULL 비발화)은 본 라운드 가격 미터치라 미적용.

---

## 6. 롤백

- **백업(권장)**: `./backup.sh` → `backup_state_<ts>.sql`. 32상품 plate 102행 재INSERT 문 + 53 ORPHAN siz
  `del_yn='N'`·`del_dt=NULL` 복원 UPDATE. read-only 덤프(DB 무변경).
- **롤백 절차**: ① 신규 31 SIZ_000499 plate 행 DELETE(또는 백업 재적용 시 ON CONFLICT no-op) ② 백업 SQL로
  원 plate 102행 재INSERT ③ 53 ORPHAN siz del_yn='N' 복원. soft-delete는 물리삭제 아님 → **손실 0**.

---

## 7. 인간 승인 큐

| ID | 분류 | 내용 | 상태 |
|----|------|------|------|
| **DRY-RUN** | 적재 | 라이브 롤백전용 DRY-RUN(`./apply.sh` — BEGIN…ROLLBACK 쓰기 트랜잭션). 2회 멱등·제약위반0 실증 | **lead 승인 대기** |
| **COMMIT** | 적재 | 실제 `./apply.sh --commit`(plate DELETE 101/INSERT 31 + siz soft-delete 53). 사전 backup.sh | **인간 승인 대기** |
| **H-3**(G-4) | KEEP 일관성 | PRD_000016 `dflt_plt_yn='N'`→'Y' 정정 포함 여부. 본 실행본은 미포함(KEEP). 의미상 'Y' 권고 | 후니 확인 |
| **H-5**(F-5) | 정정의도 | output_paper_typ_cd `.01` 일괄정정(기존 NULL 38·.03 → .01). 디지털인쇄=국전계열 도메인 타당 | 후니 확인 |

> 본 라운드는 **신규 siz 채번·DDL·코드행 등록 없음**(316x467=SIZ_000499 재사용). 3절·투명 6상품의 신규 siz
> 채번(H-2)·cut 정책(H-3)·투명 output_paper_typ_cd(H-4)·가격 정합(H-1)은 **다음 단계(범위 외)** — 본
> 실행본은 그 6상품을 적재하지 않으므로 해당 결정 불요.

---

## 8. 자기검증 후 핸드오프

생성기(`gen_migrate_sql.py`)로 재현 생성(손편집 0). provenance=`migrate.provenance.csv`.
`dbm-validator`에게 G1~G9 carry-forward + R1~R6 + (lead 승인 후) 라이브 롤백 DRY-RUN 변경분 재게이트 요청.
빌더는 자기 승인하지 않는다.
