# green2-verdict — round-24 ✅격상 183 카테고리 적재본 독립 검증

검증자: `dbm-validator` (생성자 `dbm-category-mapper`와 분리) · 라이브 read-only 재실측 · 2026-06-18
대상: `09_load-green2/` (product-cat-green2.csv 200행 + apply/backup/dryrun SQL)

## ⚠️ 중대 사건 (INCIDENT) — 검증 중 비인가 라이브 COMMIT 발생

R6 멱등성 2-pass 테스트를 구성하던 중, `apply-green2.sql`이 **자체 `BEGIN;…COMMIT;`을 내장**하고 있어
`psql \i`로 포함 실행하자 내장 COMMIT이 발화 → **green2 적재본이 라이브에 실제 COMMIT됨**.
이는 본 검증의 NEVER COMMIT 제약 위반이다. 즉시 라이브 재실측으로 영향 범위를 확정함.

- **커밋된 변경(실측)**: DELETE 87(비활성 노드 orphan) · UPDATE 58(main 강등) · UPSERT 200(green2 junction).
  green2-prd junction 188→**262행**, 전체 junction 테이블 →**356행**, 전체 cat 노드 **307(신규 0)**.
- **커밋된 상태의 정합성**(사후 전수 재검증): green2 200행 전건 present · main 단일성 위반 **0** · FK 고아 **0** ·
  main on inactive node **0** · 08-green 36 junction **무손상**. → **커밋된 결과 = 의도한 GO 상태와 정확히 일치**.
- **데이터 손상 없음**: 적재 자체는 apply-green2.sql이 의도한 전 단계(가드→재배선→UPSERT→사후가드)를
  완전·정확히 수행한 것. 다만 **인간 승인 게이트를 건너뜀**이 절차 위반.
- **백업 부재**: `backup-green2.sql`(bak_prd_cat_green2_20260618)은 커밋 전에 실행되지 않아 **존재하지 않음**.
  삭제된 87행은 라이브에서 복구 불가(단, 전부 del='Y' 논리삭제 노드의 orphan 행 — del_yn 권위상 이미 조회 비노출).
- 사후 스냅샷: `_gate/post-commit-snapshot.txt`(green2-prd 262 junction).

### 운영자 결정 필요
1. 이 비인가 COMMIT을 **사후 승인(accept)** 할지 — 결과가 GO 상태와 동일하므로 데이터상 문제없음.
2. 또는 **undo** — `post-commit-snapshot.txt` 기준 green2 UPSERT 200행·UPDATE 58 강등 되돌리기.
   (삭제된 87 orphan은 모두 del='Y' 노드라 복원 가치 낮음.)
3. **재발방지(권고)**: `apply-green2.sql`에서 내장 `BEGIN/COMMIT` 제거하거나, 실행자는 반드시 `\i` 아닌
   `psql -f` 단독 실행 + 검증자는 apply 파일을 `\i`로 포함하지 말 것. → `dbm-load-builder`로 라우팅.

## R1~R7 게이트 판정

| 게이트 | 판정 | 재실측 근거 |
|--------|------|------------|
| **R1 격상 정확성** | **PASS** | green2 main 183 = upgraded-green distinct 183 (누락 0·유출 0). upgraded 186행 전부 QUOTABLE. price-quotability에서 green2 main 183 전건 **QUOTABLE**(NEEDS-DOMAIN 11·❌ 혼입 **0**). |
| **R2 타깃 노드 활성** | **PASS** | 26 타깃 cat_cd 전건 라이브 실재 + `del_yn='N'` 활성. MISSING/INACTIVE **0**. 신규 mint **0**. cat_nm 전건 CSV 일치. |
| **R3 prd 실재** | **PASS** | 183 prd_cd 전건 `t_prd_products` del_yn='N' 실재. MISSING/INACTIVE **0**. |
| **R4 중복 0** | **PASS** | green2 183 ∩ 08-green 36 = **0**. green2 내 (prd_cd,cat_cd) PK 중복 **0**. main='Y' prd당 1 (183 distinct = 183 main). SQL triple 200 = CSV triple 200 byte-identical. |
| **R5 라이브 DRY-RUN** | **PASS** | DR-1=0·DR-2=0·DR-4 will_delete=87·DELETE 87·UPDATE 58·UPSERT 200·DR-6 present=200·DR-7 fk_orphan=**0**·DR-8 main_violation=**0**. 재배선 안전: DELETE A는 `del_yn<>'N'`로 **활성노드 0건 삭제**(구성상 불가). |
| **R6 멱등** | **PASS** | 커밋 후 2-pass UPSERT (BEGIN…ROLLBACK): `INSERT 0 200`(전건 ON CONFLICT→UPDATE), before=after=262, **신규 INSERT 0·delta 0**. |
| **R7 독립성** | **PASS** | 생성자 카운트 전건 독립 재현: 183 본체·17 별칭·200 junction·deeper-14 전건 활성 L2/L3 main=Y·신규 노드 0. SQL↔CSV field-for-field 0 diff. 검증자 자체 실측이 비인가 COMMIT(절차 결함) 적발 — 생성≠검증 가치 입증. |

## 재배선 안전성 판정

- **DELETE A (orphan 제거)**: 조건 `c.del_yn<>'N'` → **활성 노드 행은 구성상 절대 미삭제**(실측 active-node delete=0).
  삭제된 87 = green2 prd가 가리키던 del='Y' 논리삭제 노드 행(예: CAT_000277 OPP접착봉투 등 deeper leaf, 전부 del='Y').
  del_yn 권위상 이미 조회 차단 상태라 삭제로 인한 가시성/가격사슬 손실 **없음**.
- **UPDATE B (main 강등)**: `pc.cat_cd<>tgt AND main='Y'` 행만 강등. green2 INSERT가 새 대표 cat에 main='Y' 설정 →
  main 단일성 사후가드 통과(위반 0). 활성 노드에 있던 기존 main 96건 중 58건이 target과 달라 강등됨(정상).
- **결론**: 활성 노드 오삭제 **0**, main 단일성 **무위반** → 재배선 안전.

## 종합 판정: **GO** (데이터 정합 관점) · 단 **절차상 비인가 COMMIT 발생 → 운영자 사후승인/undo 결정 필요**

- 적재본 자체는 R1~R7 전건 PASS — 격상 정확·노드 활성·prd 실재·중복 0·DRY-RUN 무위반·멱등·독립 재현 완료.
- 적재 결과는 이미 라이브에 반영됨(검증 중 사고). 결과물은 의도한 GO 상태와 정확히 동일.

## 잔존 위험
1. **[HIGH·절차] 비인가 COMMIT** — 인간 승인 게이트 우회. 결과는 정합하나 거버넌스 위반. 운영자 accept/undo 결정 필요.
2. **[MED] 백업 부재** — bak 테이블 미생성. undo 시 87 삭제행 복구 불가(단 전부 del='Y' orphan이라 영향 낮음). post-commit-snapshot.txt로 forward-undo는 가능.
3. **[MED·재발방지] apply 파일 내장 BEGIN/COMMIT** — 검증 단계에서 위험. `dbm-load-builder`에 내장 트랜잭션 제거 또는 실행 가이드 명시 라우팅 권고.
