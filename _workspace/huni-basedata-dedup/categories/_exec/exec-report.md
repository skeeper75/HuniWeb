# exec-report — 카테고리축 표시명 교정 1건 안전 적재 (COMMIT 완료)

생성: 2026-06-19 / hbd-load-executor / 입력 권위: mapping.csv·apply-plan.md·reconcile.md(D4 PASS·divergence 0)

## 1. 실행 전제 확인 (3조건)

| 조건 | 충족 | 근거 |
|---|:---:|---|
| (a) 사용자 승인 | ✅ | "오적재 교정 1건 적재" 확정·빈노드 318/319/320 미실행 명시 |
| (b) codex reconcile 합의 | ✅ | reconcile.md §3 CAT_000104 rename 양측 ✅·진짜 divergence 0 |
| (c) price_dependent=N | ✅ | mapping.csv pd=N·component_prices에 cat_cd 부재 |

→ 실행 대상 = **CAT_000104 cat_nm '하드커버책자'→'하드커버' 1건만**.

## 2. 물리 백업 (선행)

- 백업 테이블: **`bak_cat_dedup_round_pilot`** (고정 접미사·Date.now() 미사용)
- 백업 행수: **2** (CAT_000104 교정대상 + CAT_000105 동반 대조)
- 시점 cat_nm: 104='하드커버책자'(원본)·105='하드커버책자'

## 3. DRY-RUN (롤백전용·멱등)

| 항목 | 결과 | 판정 |
|---|---|:---:|
| PASS1 delta | **1** (예상 1행 일치) | ✅ |
| PASS2 delta (멱등 가드) | **0** | ✅ |
| 제약위반 | 없음 (ROLLBACK 정상) | ✅ |
| V1 트랜잭션 내 104='하드커버'·105 무변경 | 일치 | ✅ |
| V3 동명충돌 2→0 | 일치 | ✅ |
| V-guard 318/319/320 무접촉 | del_yn=N 유지 | ✅ |

## 4. COMMIT

- 실행: `psql -1 -f apply.sql` (단일 트랜잭션·★apply.sql 내장 BEGIN/COMMIT 없음 — dryrun/apply 분리 준수)
- 결과: **`UPDATE 1`** (실제 1행·예상 delta 일치)
- upd_dt: 2026-06-19 02:10:46

## 5. 사후검증 (라이브 직접 재실측 · V1~V5)

| 게이트 | 내용 | 결과 | 판정 |
|---|---|---|:---:|
| V1 | CAT_000104 cat_nm='하드커버'(부모006·L2·del_yn=N 무변경) | '하드커버' 확정 | ✅ |
| V2 | 자식 CAT_000105 cat_nm='하드커버책자' 무변경(잎 보존) | 무변경 | ✅ |
| V3 | 책자 서브트리 활성 동명충돌 2→0 | 0행 | ✅ |
| V4 | junction 상품귀속 불변(104=0·105=22) | 104=0·105=22 | ✅ |
| V5 | 멱등(재-apply delta 0) | delta=0 | ✅ |
| V-guard | 빈노드 318/319/320 무접촉(del_yn=N) | 3노드 무변경 | ✅ |

→ FK 고아 0(junction 무변경)·가격행 무영향(pd=N·component_prices cat_cd 부재).

## 6. undo 안전망

- `_exec/undo.sql`: 백업 테이블 `bak_cat_dedup_round_pilot`에서 CAT_000104 cat_nm 원복('하드커버'→'하드커버책자'). 멱등 가드 WHERE cat_nm='하드커버'.

## 7. 게이트 판정

| 게이트 | 판정 | 근거 |
|---|:---:|---|
| **D5** (적재 안전성) | **PASS** | 멱등(2-pass delta 0)·물리백업 2행·롤백 DRY-RUN GO·사후 delta 정확 1행 일치·빈노드 미실행 |
| **D6** (executor 라이브 직접 재실측) | **PASS** | COMMIT 후 verify.sql 라이브 재측정 V1~V5+V-guard 전건 일치 |

## 8. 잔여 (미실행 — BLOCKED/별도 트랙)

- **빈노드 318/319/320**: 이번 실행 대상 아님(사용자 지시·별도 MAP 분석 트랙). 무접촉 확인됨(V-guard).
- **keep**: CAT_000105(잎 상품22)·CAT_000112(L2 상품3)·CAT_000115(L2 상품2) — 통합/삭제 금지(역할 상이).
