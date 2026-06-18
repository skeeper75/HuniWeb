# apply-plan — 사이즈 축 D-1 안전 merge 실행 명세

생성: 2026-06-19 / hbd-dedup-analyst / 대상: **D-1 SIZ_000105 → SIZ_000104 무손실 통합 1건**
권위: 라이브 t_* 직접 재실측(dedup-report.md 재판정 §D-1) · del_yn 논리삭제 권위 [[dbmap-del-yn-soft-delete-authority]]
실행 주체: **인간 승인 후 hbd-load-execution / dbm-load-execution 위임** (본 문서는 명세까지)

## 0. 범위 (안전분만)

- ✅ 포함: **D-1 1건** (SIZ_000105 → SIZ_000104). pd=N·외부 참조 0·라이브 안전 입증분.
- ❌ 제외: D-2(A3 174/315)·D-3(A2 197/317) — pd=Y → component_prices CASCADE → 라이브 직접 금지·경로 Y.

## 1. 사전 실측 (라이브 확정값 — 2026-06-19)

| 항목 | 값 | 근거 쿼리 |
|---|---|---|
| 정본 | SIZ_000104 (165x115mm(10장)·pd=N·cp_rows=0) | t_siz_sizes |
| 멤버 | SIZ_000105 (104와 byte-identical) | t_siz_sizes |
| 멤버 바인딩 | t_prd_product_sizes 1행: PRD_000004(카드봉투)·dflt_yn=Y·disp_seq=1·del_yn=N | t_prd_product_sizes |
| 정본 바인딩 | t_prd_product_sizes 1행: PRD_000004·dflt_yn=Y·disp_seq=1·del_yn=N (이미 존재) | t_prd_product_sizes |
| 멤버 외부 참조 | component_prices=0·option_items=0·plate_sizes=0·templates=0·constraints=0 | 전수 스캔 |

★ 멤버(105)를 쓰는 유일 상품 PRD_000004는 정본(104)도 이미 바인딩 → 멤버 바인딩 제거 시 무손실(상품은 104 default 유지).

## 2. 백업 대상 (실행 전 필수)

```sql
-- 물리 백업(타임스탬프 테이블) — undo 안전망
CREATE TABLE bak_siz_dedup_d1_20260619 AS
  SELECT * FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000104','SIZ_000105');
CREATE TABLE bak_prdsiz_dedup_d1_20260619 AS
  SELECT * FROM t_prd_product_sizes WHERE prd_cd='PRD_000004' AND siz_cd IN ('SIZ_000104','SIZ_000105');
```

## 3. 적용 SQL (단일 트랜잭션 · 멱등 가드 · dryrun/apply 분리)

★ [HARD] 내장 BEGIN/COMMIT 금지(round-24 비인가 COMMIT 사고 재발방지). 아래는 **본문만** — 실행 래퍼(BEGIN/검증/COMMIT 또는 ROLLBACK)는 hbd-load-execution이 분리 관리.

```sql
-- (a) 멤버 바인딩 제거: PRD_000004 → SIZ_000105 (104가 이미 바인딩되어 무손실)
--     멱등 가드: 이미 제거됐으면 0행
DELETE FROM t_prd_product_sizes
 WHERE prd_cd='PRD_000004' AND siz_cd='SIZ_000105' AND del_yn='N';
-- 예상 delta: 1행 (재실행 시 0)

-- (b) 멤버 논리삭제: SIZ_000105 (권위=del_yn)
--     멱등 가드: WHERE del_yn='N'
UPDATE t_siz_sizes
   SET del_yn='Y', upd_dt=now()
 WHERE siz_cd='SIZ_000105' AND del_yn='N';
-- 예상 delta: 1행 (재실행 시 0)
```

주: 정본 104는 무변경. 105를 참조하는 곳이 0이므로 "재배선"은 (a) 바인딩 제거로 충분(104 신규 INSERT 불필요·이미 존재).

## 4. 사후검증 (GO 게이트)

```sql
-- V1 멤버 논리삭제 확정 + 정본 활성
SELECT siz_cd, del_yn FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000104','SIZ_000105');
--   기대: 104→N, 105→Y
-- V2 PRD_000004 사이즈 단일·이중 default 해소
SELECT siz_cd, dflt_yn, del_yn FROM t_prd_product_sizes WHERE prd_cd='PRD_000004' AND del_yn='N';
--   기대: SIZ_000104 1행만(dflt_yn=Y)
-- V3 멤버 외부 참조 여전히 0 (CASCADE 무발생)
SELECT (SELECT COUNT(*) FROM t_prc_component_prices WHERE siz_cd='SIZ_000105') AS cp,
       (SELECT COUNT(*) FROM t_prd_product_sizes WHERE siz_cd='SIZ_000105' AND del_yn='N') AS prd_active;
--   기대: 0, 0
-- V4 멱등: 위 (a)(b) 재실행 시 delta=0
```

## 5. 예상 delta 요약

| 변경 | 테이블 | 행수 | 가역 |
|---|---|:---:|---|
| 멤버 바인딩 제거 | t_prd_product_sizes | 1 (del) | 백업 복원 |
| 멤버 논리삭제 | t_siz_sizes | 1 (upd del_yn) | del_yn='N' 복귀 |
| INSERT / 물리 DELETE | — | 0 | — |

총 안전 적재(교정) 건수: **2 UPDATE/DELETE (= D-1 merge 1건)**. 가격행·정본·타 상품 무영향.

## 6. 잔여(미적용 — 컨펌/경로 Y)

- D-2 A3(174/315)·D-3 A2(197/317): pd=Y BLOCKED → 경로 Y(개발자 v03 재적재). 라이브 직접 금지.
- SIZ_000499 판형 모델링 확인 큐(BLOCKED·실행영향 0).
- 나머지 28 충돌그룹 멤버별 가드 1:1 재검(다음 라운드).
