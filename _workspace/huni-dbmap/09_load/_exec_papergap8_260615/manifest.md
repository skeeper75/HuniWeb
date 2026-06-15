# 적재 매니페스트 — 디지털 국4절 종이비 GAP (round-19 첫 실제 적재 테스트)

> **작성** 2026-06-15 · round-19 가격 트랙 첫 실제 라이브 적재 전환.
> **상태: COMMIT 직전 정지** — 백업본 + 멱등 적재본 + DRY-RUN(1·2-pass)까지 완료.
>   **실 COMMIT 안 함**. 독립 검증(dbm-validator R1~R6) GO 후 별도 인간 승인 단계에서 COMMIT.
> **권위**: 가격표 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` 출력소재(IMPORT) 시트 I열(국4절가) · 라이브 `t_prc_component_prices` · `30_load-test-prep/{output-material-import-decompose,paper-price-and-output-size-diagnosis,live-apply-date-structure}.md`.
> **접속**: `.env.local RAILWAY_DB_*`(db=railway). 비밀값 비노출.

---

## 0. 한 줄 요약

디지털 국4절 종이비 **즉시 채움 GAP 7행**을 `t_prc_component_prices`(comp_cd=COMP_PAPER, siz_cd=SIZ_000499, apply_ymd=2026-06-01)에 멱등 적재하는 실행본. 신규 채번 0(mat_cd·siz_cd 마스터 기적재)·배선 완결(PRF_DGP_A~F)·동시매칭 0(GAP 자명). **라이브 DRY-RUN 2-pass 멱등 실증**(pass1 +7 → pass2 delta 0)·제약위반 0·FK 고아 0·COMMIT 0.

> ★ **8행 → 7행 정정**: directive §5 A는 "8행(앙상블 4·클래식스티플·리브스디자인·띤또레또 2)"이나, 라이브 실측 결과 **클래식 크래스트 스티플 270g(MAT_000118)은 이미 COMP_PAPER 480.00 적재된 RU(GAP 아님)** → 즉시 채움 GAP = **7행**으로 정정(decomposition.md §5.2 GAP 표와 정합·live existence is authority).

---

## 1. 적재 대상 7행 (자연키 + 단가 권위값)

**그릇**: `t_prc_component_prices` · **comp_cd** `COMP_PAPER` · **prc_typ** PRICE_TYPE.01 단가형(comp 정의 상속, 단가행엔 컬럼 없음).
**자연키(10컬럼)**: `comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty`.
고정값: comp_cd=COMP_PAPER · apply_ymd=2026-06-01 · siz_cd=SIZ_000499(316x467 국4절) · clr/proc/opt/coat_side_cnt/bdl_qty/min_qty = **NULL**(용지비는 색·공정·옵션·코팅·묶음·수량 무관).

| # | mat_cd | mat_nm | 가격표 행/열 | I(국4절) 권위 | 라이브 저장값 numeric(12,2) |
|---|--------|--------|-------------|:------------:|:--------------------------:|
| 1 | MAT_000096 | 앙상블 130g | R22 / I | 71.33 | 71.33 |
| 2 | MAT_000097 | 앙상블 160g | R23 / I | 87.795 | **87.80** (round) |
| 3 | MAT_000098 | 앙상블 190g | R24 / I | 104.24 | 104.24 |
| 4 | MAT_000099 | 앙상블 210g | R25 / I | 115.23 | 115.23 |
| 5 | MAT_000119 | 리브스디자인 250g | R40 / I | 500 | 500.00 |
| 6 | MAT_000123 | 띤또레또 200g | R43 / I | 245 | 245.00 |
| 7 | MAT_000124 | 띤또레또 250g | R44 / I | 306 | 306.00 |

- **unit_price = numeric(12,2)** — 소수 셋째자리는 round-half-up 으로 둘째자리 저장(라이브 49 RU 전체 동일 관례: 가격표 36.875→36.88·54.865→54.87). 87.795→87.80 은 무손실 위반 아님 = 컬럼 제약 honor.
- **동시매칭 0 자명**: 7 mat_cd 각각 자연키 기존행 0(실측 `rows_at_natkey = 0`) → GAP.
- **mat_cd·siz_cd 부모 실재**: 7 mat_cd 전건 MAT_TYPE.01 종이 마스터 기적재 · SIZ_000499 실재 → FK 고아 0.

---

## 2. 적재 순서 (FK 위상 — 단일 스텝)

| 순서 | 스텝 | 대상 테이블 | 행수 | FK 의존 엣지 | 비고 |
|:---:|------|-------------|:---:|-------------|------|
| 01 | `01_comp_paper_gap.sql` | t_prc_component_prices | 7 | mat_cd→t_mat_materials(기적재) · siz_cd→t_siz_sizes(SIZ_000499 기존) | 부모 전건 선재 → 코드행 선적재·신규 엔티티 0 |

신규 코드행 선적재 없음(00 스텝 불요)·DDL 제안 없음(그릇·차원·배선 전부 완결).

---

## 3. 멱등 전략 (★ 이 테이블 고유)

- **NOT EXISTS 가드(NULL-safe)** 사용 — `ON CONFLICT` 아님.
- **이유(라이브 실증)**: 자연키 UNIQUE 인덱스 `ux_t_prc_comp_prices_nat_key` 는 **NULLS DISTINCT**(`pg_index.indnullsnotdistinct = f`). 자연키 10컬럼 중 6컬럼이 NULL 이라 `ON CONFLICT` 가 발화하지 않음 → DRY-RUN 실증: ON CONFLICT 2회차 = 중복 2행(멱등 깨짐). 따라서 `INSERT … SELECT … WHERE NOT EXISTS (자연키 IS NULL 명시 비교)` 로 멱등 보장.
- **reg_dt 생략**(DEFAULT now() 발화·명시 NULL 금지) · **comp_price_id IDENTITY 비명시**(자동 채번·시퀀스 last_value=5123>MAX=4954 안전).

---

## 4. 산출물

| 파일 | 역할 |
|------|------|
| `manifest.md` | 본 매니페스트(적재 계획·7행·순서·멱등·DRY-RUN 결과) |
| `01_comp_paper_gap.sql` | 멱등 적재 SQL(7행 NOT EXISTS 가드·provenance 주석) |
| `01_comp_paper_gap.provenance.csv` | 행별 출처(자연키·가격표 행/열·권위값↔저장값) |
| `apply.sql` | 단일 트랜잭션 래퍼(적재 전후 검증 SELECT 포함·COMMIT/ROLLBACK 미주입) |
| `apply.sh` | 로더(기본 DRY-RUN·`idempotent` 2-pass·`commit` 인간 승인) |
| `backup.sql` | 실 COMMIT 직전 스냅샷(`bak_papergap8_260615 AS SELECT *`·IF NOT EXISTS) — **DRY-RUN 단계 미실행** |
| `pre_comp_paper_260615.csv` | 적재 전 COMP_PAPER 49행 baseline(읽기전용 덤프·undo 참조) |

---

## 5. 백업 스냅샷

| 백업 | 방식 | 행수 | 시점 |
|------|------|:---:|------|
| `pre_comp_paper_260615.csv` | 읽기전용 `\copy` 덤프(COMP_PAPER 전체) | 49 | 적재 전 baseline (생성 완료) |
| `bak_papergap8_260615` | DB 내부 `CREATE TABLE AS SELECT *`(t_prc_component_prices 전체) | 3,481 (예정) | **실 COMMIT 직전**(backup.sql·인간 승인 시 실행) |

> 본 단계(DRY-RUN)에서는 CSV baseline 만 생성. DB 내부 `bak_*` 스냅샷은 쓰기이므로 실 COMMIT 인간 승인 시점에 `backup.sql` 로 실행.

---

## 6. DRY-RUN 결과 (BEGIN…ROLLBACK · COMMIT 0)

### 6.1 1-pass (`./apply.sh`)
```
before COMP_PAPER rows : 49
01 적재               : INSERT 0 1 × 7  (신규 7행)
after  COMP_PAPER rows : 56            (49 + 7)
price_match           : 전건 t  (가격표값 ↔ numeric(12,2) 저장값 일치)
FK orphan             : mat_orphan 0 / siz_orphan 0
natkey dup            : 7 mat_cd 전건 1행 (중복 0)
→ ROLLBACK (커밋 0)
```

### 6.2 2-pass 멱등 (`./apply.sh idempotent`)
```
PASS 1 : INSERT 0 1 × 7 → after pass1 = 56
PASS 2 : INSERT 0 0 × 7 → after pass2 = 56   (delta 0 = 멱등 확정)
→ ROLLBACK (커밋 0)
```

| 검증 항목 | 결과 |
|----------|------|
| 1-pass delta | +7 (49→56) ✅ |
| 2-pass delta | 0 (56 유지) ✅ 멱등 |
| 제약위반(type/length/NOT NULL/CHECK) | 0 ✅ |
| FK 고아(mat_cd·siz_cd) | 0 ✅ |
| 자연키 중복 | 0 ✅ |
| 가격 권위값 일치 | 전건 ✅ |
| COMMIT | 0 ✅ (롤백전용) |

---

## 7. COMMIT 준비 상태 / 다음 단계

- **현재: COMMIT 직전 정지.** 백업본·멱등 적재본·DRY-RUN(1·2-pass) 완료. 실 COMMIT·DB 내부 백업 미실행.
- **다음(인간/검증 GO 후)**:
  1. `dbm-validator` 독립 검증 — G1~G9 carry-forward + R1~R6(특히 R1 멱등·R5 라이브 DRY-RUN·R6 독립검증). 자기 승인 금지.
  2. 검증 GO + 인간 승인 → `backup.sql` 실행(bak_papergap8_260615 스냅샷) → `./apply.sh commit` (COMMIT).
  3. 적재 후 검증 — 56행·값·FK 고아 0·멱등 2회차 delta 0 재확인.
- **범위 밖(별 트랙·건드리지 말 것)**: 3절(330x660 siz 선결)·투명 PET(315x467 선결)·특수지·스티커용지(C-1)·하드커버 소재비(C-2)·plate 교정·비-디지털 소재.

---

## 8. 한 줄 현황

디지털 국4절 종이비 **GAP 7행**(8행→7행 정정·클래식스티플 RU 제외) 멱등 적재본 완성 — COMP_PAPER 동형·siz=SIZ_000499·apply_ymd=2026-06-01(기존 세대 합류)·NOT EXISTS NULL-safe 멱등(NULLS DISTINCT 인덱스 대응)·신규 채번 0. 라이브 DRY-RUN 2-pass: pass1 +7 → pass2 delta 0·제약위반 0·FK 0·COMMIT 0 실증. **COMMIT 직전 정지 — 독립 검증 GO + 인간 승인 후 별도 COMMIT.**
