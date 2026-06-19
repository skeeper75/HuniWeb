# apply-plan — 카테고리 축 안전 적재 명세 (표시명 교정 1건 · 빈노드 보류)

생성: 2026-06-19 / hbd-dedup-analyst / 대상: **CAT_000104 cat_nm 표시↔권위 정합 교정 (가역·무손실)**
권위: 라이브 t_* 직접 재실측 + round-24 MAP IA(`35_category-map/matching.csv` F8 ▶︎하드커버)
실행 주체: **인간 승인 후 hbd-load-execution / dbm-load-execution 위임** (본 문서는 명세까지)

## 0. 범위 (안전분만)

- ✅ 포함: **CAT_000104 cat_nm 교정 1건** — '하드커버책자' → '하드커버'(MAP F8 섹션 라벨 복원).
  표시명만 변경·노드/계층/upr_cat_cd/상품귀속 전부 무변경·물리삭제 0·신규 노드 0. 가역(원복=다시 '하드커버책자').
- ❌ 제외(BLOCKED·IA 결정): **빈노드 318·319·320**(디자인캘린더 L3·상품0·자식0). MAP 권위가 채움
  (PRD_108/110/111 다중분류)을 명시 → 자의적 삭제 금지. 채움(A) vs 폐기(B)는 인간 IA 판단. dedup 비대상.
- ❌ 제외(④ 정당구분 keep): 105(잎 상품22)·112(L2 상품3)·115(L2 상품2) — 역할/부모 상이·통합 금지.

## 1. 사전 실측 (라이브 확정값 — 2026-06-19)

| 노드 | 현재 cat_nm | 부모/레벨 | 자식N | 상품귀속 | upd_dt |
|---|---|---|:---:|:---:|---|
| CAT_000104 | 하드커버책자 | 006 책자 / L2 | 3 | 0 | 2026-06-19 01:08:31 |
| (대조) CAT_000105 | 하드커버책자 | 104 / L3 | 0 | 22 | 2026-06-03 |

★ MAP 권위(matching.csv): F8 `section ▶︎하드커버`(컨테이너 라벨) · F9 `product 하드커버책자`(잎=105).
→ 104=컨테이너이므로 표시명은 섹션 라벨 '하드커버'가 정답. 교정 후 화면: `하드커버 > 하드커버책자(상품22)`.

## 2. 백업 대상 (실행 전 필수)

```sql
-- 물리 백업(타임스탬프 테이블) — undo 안전망
CREATE TABLE bak_cat_dedup_namefix_20260619 AS
  SELECT * FROM t_cat_categories WHERE cat_cd = 'CAT_000104';
```

## 3. 적용 SQL (단일 트랜잭션 · 멱등 가드 · dryrun/apply 분리)

★ [HARD] 내장 BEGIN/COMMIT 금지(round-24 비인가 COMMIT 사고 재발방지). 아래는 **본문만** —
실행 래퍼(BEGIN/검증/COMMIT 또는 ROLLBACK)는 hbd-load-execution이 분리 관리.

```sql
-- CAT_000104 컨테이너 표시명 권위 정합 교정 (MAP F8 ▶︎하드커버) · 멱등 가드
UPDATE t_cat_categories
   SET cat_nm = '하드커버', upd_dt = now()
 WHERE cat_cd = 'CAT_000104'
   AND cat_nm = '하드커버책자'
   AND del_yn = 'N';
-- 예상 delta: 1행 (재실행 시 0)
```

주: upr_cat_cd·cat_lvl·disp_seq·junction(상품귀속) 무변경. 잎 CAT_000105('하드커버책자' 상품22) 무접촉.
가격사슬 무관(pd=N·component_prices에 cat_cd 부재).

## 4. 사후검증 (GO 게이트)

```sql
-- V1 104 표시명 교정 확정 + 105 무변경
SELECT cat_cd, cat_nm, upr_cat_cd, cat_lvl, del_yn
FROM t_cat_categories WHERE cat_cd IN ('CAT_000104','CAT_000105') ORDER BY cat_cd;
--   기대: 104='하드커버'(부모006·L2) ; 105='하드커버책자'(부모104·L3) → 화면 충돌 해소

-- V2 활성 트리에 동명 충돌 잔존 확인 (책자 서브트리)
SELECT cat_nm, count(*) FROM t_cat_categories
WHERE del_yn='N' AND upr_cat_cd IN ('CAT_000006','CAT_000104')
GROUP BY cat_nm HAVING count(*)>1;
--   기대: 0행 (104 교정 후 '하드커버책자' 단일)

-- V3 104 상품귀속 무손실 (junction 무변경)
SELECT cat_cd, count(*) FROM t_prd_product_categories
WHERE cat_cd IN ('CAT_000104','CAT_000105') GROUP BY cat_cd;
--   기대: 104=0(컨테이너·여전히), 105=22(잎·무변경)

-- V4 멱등: 위 UPDATE 재실행 시 delta=0
```

## 5. 예상 delta 요약

| 변경 | 테이블 | 행수 | 가역 |
|---|---|:---:|---|
| 컨테이너 표시명 교정 | t_cat_categories | 1 (upd cat_nm) | cat_nm='하드커버책자' 복귀 |
| INSERT / 물리 DELETE / 논리삭제 / junction 재배선 | — | 0 | — |

총 안전 적재(교정) 건수: **1 UPDATE (cat_nm)**. 계층·상품귀속·가격 무영향.

## 6. 잔여 (미적용 — BLOCKED/컨펌)

- **빈노드 318/319/320 IA 결정**(BLOCKED): 디자인캘린더 L3 placeholder(상품0·자식0·round-24 01:12 신규).
  MAP G16-G19가 PRD_108/110/111 다중분류를 명시 → **자의적 삭제 금지**. 두 경로 인간 판단:
  - (A) 실현: junction에 PRD_108→318·PRD_111→319·PRD_110→320 append(main_cat_yn='N', round-24 다중분류 패턴).
  - (B) 폐기: 318/319/320 del_yn='Y'(3노드 논리삭제).
- **keep 정당구분**: 105(잎 상품22)·112(상품3)·115(상품2) — 통합/삭제 금지(역할/부모 상이).
