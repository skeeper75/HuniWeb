# 08 — ✅GREEN 36 라이브 적재본 매니페스트 (manifest-green.md)

round-24 2단계 · dbm-category-mapper · **DB 미적재**(적재본 생성까지·실 COMMIT은 검증 GO 후 별도 실행자).
권위: `product-cat.csv`(verdict v2 GO) + 라이브 read-only 재실측(2026-06-18).
**적재 범위 = ✅정상등록가능 36건만**(사용자 확정 2). 🟡197·❌11은 명세 유지·이번 적재 제외.

## 0. 산출 파일

| 파일 | 내용 |
|------|------|
| `product-cat-green.csv` | ✅GREEN 36 본체 junction(+해당 별칭 0건) · 가변깊이 재지정 반영 |
| `apply-green.sql` | 멱등 UPSERT 36 + 재배선 + 3 가드, 단일 트랜잭션 BEGIN/COMMIT |
| `backup-green.sql` | 적재 전 영향 36 prd_cd 기존 junction SELECT 백업(undo 근거) |
| `dryrun-green.sql` | BEGIN…ROLLBACK DRY-RUN(INSERT/UPDATE/DELETE·제약·FK·main 단일성 집계) |
| `build_green.py` · `gen_sql.py` | 결정적 빌드(가변깊이 맵·활성노드 가드 내장) |

## 1. 적재 행수 (junction `t_prd_product_categories`)

| 구분 | 행수 | 비고 |
|------|-----:|------|
| 본체(main_cat_yn='Y') | **36** | ✅GREEN 36 상품 1:1 |
| 별칭(main_cat_yn='N') | **0** | ✅GREEN 36 본체에 속한 별칭 0건(18 별칭은 전부 🟡 본체 소속 → 제외) |
| **적재 junction 총** | **36** | distinct prd_cd 36 · distinct cat_cd 13 |

### 가변깊이 재지정 11행 (설계철학 반영)
사용자 확정 1 — 상품군별 가변 계층 깊이. 자연스러운 활성(del='N') 깊은 노드 존재 시 그 노드 귀속:

| prd_cd | 상품 | 이전(05 초안) | → 가변깊이 target(활성) |
|--------|------|---------------|------------------------|
| PRD_000016/017/018 | 프리미엄/코팅/스탠다드엽서 | CAT_000001 엽서/카드(L1) | **CAT_000307 엽서(L2)** |
| PRD_000027/029 | 2단/3단접지카드 | CAT_000001(L1) | **CAT_000021 접지카드(L2)** ※라이브 현행 일치 |
| PRD_000041/042 | 스탠다드쿠폰·프리미엄상품권 | CAT_000003(L1) | **CAT_000062 쿠폰/상품권(L2)** |
| PRD_000047 | 소량전단지 | CAT_000003(L1) | **CAT_000058 전단지/리플랫(L2)** |
| PRD_000118 | 아트프린트포스터 | CAT_000004(L1) | **CAT_000076 아트프린트(L2)** |
| PRD_000124/125 | 린넨/캔버스패브릭포스터 | CAT_000004(L1) | **CAT_000072 패브릭포스터(L2)** |

나머지 25행은 자연스러운 활성 깊은 노드 부재(자유형스티커≠규격스티커·자유형명함 그룹 없음·중철/무선/트윈링≠하드커버·방수/족자포스터 활성 L2 없음·배너류 활성 L2 없음) → L1 직속 유지. 엽서북(PRD_000094)은 이미 CAT_000308(활성 L2).

> **search-before-mint**: 13 target cat_cd 전부 **기존 활성 노드**(라이브 del_yn='N'·use_yn='Y' 재실측). **신규 mint = 0건.** 가변깊이는 신규 노드 신설이 아니라 기존 활성 깊은 노드 재사용.

## 2. 적재 순서 (FK 위상)

| 순서 | 작업 | 대상 | 가드 |
|-----:|------|------|------|
| 0 | (선행 검증) 타깃 13 cat_cd del='N' 활성 | t_cat_categories | 비활성 시 RAISE EXCEPTION → ROLLBACK |
| 1 | (선행 검증) 36 prd_cd 실재·del='N' | t_prd_products | 부재 시 RAISE EXCEPTION → ROLLBACK |
| 2A | 재배선 — del='Y' 노드 가리키는 기존 행 DELETE | junction | orphan 정리(del_yn 권위) |
| 2B | 재배선 — 대표 외 활성 노드 기존 main='Y' → 'N' 강등 | junction | main 단일성 |
| 3 | 멱등 UPSERT 36 본체(main='Y'·disp_seq·upd_dt) | junction | ON CONFLICT (prd_cd,cat_cd) |
| 4 | (사후 가드) prd_cd당 main='Y' 정확히 1 | junction | 위반 시 RAISE EXCEPTION |

모든 단계는 **단일 트랜잭션**(BEGIN…COMMIT). 카테고리 노드 선적재 불필요(전부 기존 활성).

## 3. 영향분석 (★ 순수 add 아님 — 재배선 포함)

라이브 DRY-RUN 실측(2026-06-18·롤백됨):

```
DELETE 26   -- GREEN 36 상품의 del='Y'(논리삭제) 노드 orphan 바인딩 정리
UPDATE 4    -- 대표 변경 상품의 기존 활성 L1 main='Y' → 'N' 강등(다중분류 노출 유지)
INSERT/UPSERT 36  -- 추정 신규 INSERT 27 · 기존 UPDATE 9(upd_dt·disp_seq 갱신)
제약 위반 0 · FK 고아 0 · main 단일성 위반 0
```

### 3.1 DELETE 26 (orphan 정리)의 정당성
26행 전부 GREEN 상품이 **논리삭제(del='Y') 전용 노드**(포토카드 CAT_000027·명함 CAT_000048~50·중철/무선/트윈링책자·포스터/배너 per-product 노드 등)를 가리키는 잔재. 과거 "상품당 전용 노드" 스킴이 round-22 ⑥에서 논리삭제됐으나 junction 바인딩이 남은 상태. del_yn 권위([[dbmap-del-yn-soft-delete-authority]]) — 논리삭제 노드 귀속은 조회 차단이므로 제거가 정합. 본 적재가 활성 노드(L1 또는 가변깊이 L2)로 대체.

### 3.2 UPDATE 4 (대표 강등)
PRD_000016/017/018(엽서)·PRD_000047(전단지)이 기존 활성 L1(엽서/카드·인쇄홍보물)에 main='Y' 보유 → 가변깊이 L2(엽서·전단지/리플랫)로 대표 이동하며 기존 L1 행은 main='N'(다중분류 노출 유지). 상품이 L1·L2 양쪽 노출(트리 자연스러움).

### 3.3 FK·롤백
- 13 target cat_cd ∈ 활성 노드·36 prd_cd ∈ 라이브 실재 → FK 고아 0.
- 카테고리는 가격사슬 비참여 → **돈 크리티컬 아님**.
- 멱등: 2회차 실행 시 DELETE 0(이미 제거)·INSERT 0·UPDATE 36(upd_dt만) — 동일 종착.

## 3.4 실 COMMIT 실행 결과 (2026-06-18)
- **백업 테이블 = `bak_pc_green_20260618_1322`** (39행 물리 보존).
- 실 COMMIT: DELETE 26 · UPDATE 4 · UPSERT 36(신규 27 + UPDATE 9) · COMMIT 완료.
- 사후검증 5항목 전건 PASS(main 단일성 위반 0·del=Y 귀속 0·FK 고아 0·멱등 delta 0·골든 3건 정합).
- 실행 로그 = `_exec/exec-log.md` · 롤백 절차 = `_exec/undo-green.md`.

## 4. undo 절차

1. 적재 전 `backup-green.sql` 실행 → 영향 36 prd_cd 기존 junction 39행 스냅샷 보존(`bak_pc_green_<ts>` 권장).
2. 문제 시: 적재로 변경된 prd_cd 행 전부 DELETE → 백업 스냅샷 행 INSERT 복원.
3. DELETE 26은 백업에 포함(del='Y' 노드 행 포함 전수 캡처) → 복원 가능.

## 5. 멱등 가드 요약

| 가드 | 보장 |
|------|------|
| del_yn 활성 검증 | 13 target cat_cd 전부 del='N'·아니면 전체 ABORT(RAISE EXCEPTION) |
| PK (prd_cd,cat_cd) | ON CONFLICT DO UPDATE → 중복 0·재실행 안전 |
| main 단일성 | 재배선(2A/2B) + 사후 가드 → prd_cd당 main='Y' 정확히 1(DRY-RUN 위반 0 실측) |
| prd 실재 | 36 prd_cd ∈ t_prd_products(del='N')·아니면 ABORT |

## 6. DRY-RUN 자가 예비결과 (생성자 자가 — GO 판정 아님)

라이브 `dryrun-green.sql` 실행(BEGIN…ROLLBACK·실 변경 0):
- **DELETE 26 · UPDATE 4 · INSERT(UPSERT) 36** 정상 실행 후 전부 ROLLBACK.
- 제약 위반 0 · FK 고아(cat) 0 · FK 고아(prd) 0 · **main 단일성 위반 0**.
- → 적재 가능성 예비 양호. **단, 생성자≠검증자 — GO 판정은 dbm-validator 독립 검증**.
