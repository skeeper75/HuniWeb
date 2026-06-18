# exec-log.md — ✅GREEN 36 카테고리 적재 실 COMMIT 실행 로그 (round-24 2단계)

실행자: 실행 전담(생성자 dbm-category-mapper · 검증자 dbm-validator와 분리) · 2026-06-18
권위: 검증 GO `_gate/green-verdict.md`(R1~R6 전건 PASS) + 사용자 최종 승인
대상: 라이브 `t_prd_product_categories` (PK = prd_cd, cat_cd)
방식: 물리 백업 → COMMIT 전 read-only 재확인 → 단일 트랜잭션 실 COMMIT → 사후검증 5항목 → undo 문서화

## 0. 라이브 스키마 사전 확인
- 접속: railway / PostgreSQL 18.4 (`.env.local` RAILWAY_DB_*, chmod 600·읽기 검증).
- `t_prd_product_categories` 컬럼: prd_cd(NN)·cat_cd(NN)·main_cat_yn(NN)·disp_seq·note·**reg_dt(NOT NULL)**·upd_dt.
- PK = (prd_cd, cat_cd) — apply-green.sql ON CONFLICT 충돌키와 정확 일치.
- reg_dt NOT NULL → apply INSERT가 `now()` 명시 제공(NOT NULL 함정 회피).

## 1. 물리 백업 (undo 근거 · COMMIT 전 완료)
| 항목 | 값 |
|------|----|
| 백업 테이블명 | **`bak_pc_green_20260618_1322`** |
| 백업 방식 | `CREATE TABLE bak_pc_green_20260618_1322 AS SELECT * FROM t_prd_product_categories WHERE prd_cd IN (<green 36>)` |
| 백업 행수 | **39** (검증자 pre-state 39와 일치 — 삭제 26 + 강등 4 + 잔존 9 전수 캡처) |

> 백업은 영향 36 prd_cd의 적재 전 junction 전수 스냅샷. DELETE 26 대상(del='Y' 노드 행) 포함 → 완전 가역.

## 2. COMMIT 직전 재확인 (read-only)
| 검사 | 결과 |
|------|------|
| 36 prd_cd del='N' 실재 | **36 / 36** ✓ |
| 13 cat_cd del='N' 활성 | **13 / 13** ✓ |
| 현재 junction 행수(36 prd) | **39** |
| 그중 del='Y' 노드 귀속(DELETE 후보) | **26** (검증자 재실측 26과 일치) |

## 3. 실 COMMIT (단일 트랜잭션 BEGIN…COMMIT)
`psql -v ON_ERROR_STOP=1 -f apply-green.sql` 실행 — 가드 2종 + main 단일성 사후 가드 전부 통과·예외 0·COMMIT 완료.

| 작업 | 실측 건수 |
|------|----------:|
| [재배선 A] DELETE (del='Y' 노드 orphan 정리) | **DELETE 26** |
| [재배선 B] UPDATE (활성 노드 대표 강등 main Y→N) | **UPDATE 4** |
| [UPSERT] INSERT … ON CONFLICT DO UPDATE | **36** (신규 27 + 기존 UPDATE 9) |
| COMMIT | ✅ 완료 |

검증자 예측(DELETE26·UPDATE4·UPSERT36, 신규 27·UPDATE 9)과 **정확 일치**.

## 4. 사후검증 (read-only · 5항목)
| # | 항목 | 기대 | 실측 | 판정 |
|---|------|------|------|------|
| V1 | 36 prd_cd main='Y' 단일성(위반 0 / 각 정확히 1) | 0 / 36 | 위반 **0** · 정확1 **36/36** | **PASS** |
| V2 | 적재 cat_cd del='Y' 귀속 0 | 0 | **0** | **PASS** |
| V3 | FK 고아 0 (cat / prd) | 0 / 0 | **0 / 0** | **PASS** |
| V4 | 멱등 재실행 delta 0 (apply 2회차 BEGIN…ROLLBACK) | 0 | DELETE **0** · UPDATE **0** · INSERT 신규 **0** (36 전부 DO UPDATE upd_dt만) | **PASS** |
| V5 | 골든 샘플 3건 귀속·main 플래그 | 설계대로 | 아래 | **PASS** |

post 총 junction(36 prd) = **40** (= 39 − 26 + 27, 검증자 산식 일치).

### V5 골든 샘플 실측
| prd_cd | 상품 | 귀속(main='Y') | 부가(main='N') | 정합 |
|--------|------|----------------|----------------|------|
| PRD_000024 | 포토카드 | CAT_000001 엽서/카드 (L1 직속·disp 1) | — | ✓ |
| PRD_000047 | 소량전단지 | CAT_000058 전단지/리플랫 (L2·disp 1) | CAT_000003 인쇄홍보물 (L1 강등·다중분류 노출) | ✓ (L1→L2 변동깊이 이동) |
| PRD_000016 | 프리미엄엽서 | CAT_000307 엽서 (L2·disp 1) | CAT_000001 엽서/카드 (L1 강등) | ✓ (L1→L2 변동깊이 이동) |

## 5. 종합
- **5항목 전건 PASS** · 멱등 재실행 delta 0 · 제약위반 0 · FK고아 0 · main 단일성 위반 0.
- undo 보유: `bak_pc_green_20260618_1322` (39행 물리 보존) → `undo-green.md` 절차로 가역.
- 비밀값 미노출(접속정보 stdout/산출 비기록).
