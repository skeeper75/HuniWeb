# exec-result-260623.md — RC-2 CONFIRM 확정 3건 라이브 COMMIT 실행 결과

> hbd-load-executor · 2026-06-23 · §21 RC-2 CONFIRM 3건(린넨마감 124·타공 데이터 138/139·족자 135).
> 인간 승인 완료 + dbm-validator R1~R6 전건 GO. 자격증명 = `.env.local RAILWAY_DB_*`(비밀 비노출).
> **결과: COMMIT 성공 · 19행 정착 · 사후검증 전건 PASS · 롤백/실패 없음.** undo.sql 보유(미실행).
> ★각목(GAKMOK) 일절 미접촉 · 기초코드 마스터(t_siz/t_mat/proc) 불변 확인.

---

## 1. 실행 전제 확인 (3조건)

| 조건 | 충족 | 근거 |
|---|---|---|
| (a) 인간 승인 | ✅ | 작업 지시서 "인간 승인 완료" 명시 |
| (b) 검증 합의 (dbm-validator) | ✅ | validation-r1-r6.md R1~R6 전건 GO |
| (c) 가격행 무손상 | ✅ | 단가 전부 verbatim(0 변경)·BLOCKED 없음 |

→ 3건 전부 실행 대상. 제외 0.

## 2. 물리 백업 (실행 전·undo ground-truth)

- 위치: `backup-before-260623.csv` (라이브 read-only 시점 스냅샷 2026-06-23 12:15Z)
- 백업 행수:
  - component_prices 7행 (38219/20/21 proc=105·4750/52/54 proc/dim NULL·4594 bdl_qty=2)
  - price_components 6행 (mesh_4/8 use_dims=[]·mesh_6 PROC_000080·jokja [bdl_qty,min_qty]·normal_6/8 좀비 use_yn=Y/del_yn=Y)
  - product_options OPV_000431 = **0행**(부재 확인 — INSERT 신규 타당)
  - formula_components 대상 5건 = **0행**(부재 확인 — INSERT 신규 타당)
  - GAKMOK comp 3행 기록(비접촉 증거): `STR_900_4`·`_GT`·`_LE` 전부 use_yn=Y·del_yn=N

## 3. DRY-RUN 재실행 (COMMIT 전·독립 실측)

- `apply.sh dryrun` (BEGIN…ROLLBACK) 1회 더: **INSERT 1 + UPDATE 11 + INSERT 5 + UPDATE 2 = 19행**·구문/제약위반 0·ROLLBACK 정상.
- 독립 2-pass 멱등 (단일 TX): **PASS1 = 19행 · PASS2 = 전 문 0행** → 멱등성 직접 실증(검증 주장 비신뢰·재측정).
- FK 부모 실재 확인: PROC_000104(del_yn=N)·PROC_000079(del_yn=N)·PRF_POSTER_LINEN/BANNER_M/JOKJA·comp 5종·OPT_000016 그룹·opt_cd MAX=OPV_000430(OPV_000431 충돌 0).
- 부모 테이블 정정: formula 부모 = `t_prc_price_formulas`(명세상 추정과 무관·실재 확인).

## 4. 실 COMMIT

- `apply.sh commit` — 단일 트랜잭션. apply.sql(BEGIN+5 step, COMMIT 미내장) + apply.sh가 외부 `COMMIT;` 주입(dryrun/apply 분리 프로토콜 준수·비인가 내장 COMMIT 없음).
- 결과: `INSERT 0 1` ×1(옵션) + `UPDATE 1` ×11(use_dims 4 + price_fill 7) + `INSERT 0 1` ×5(바인딩) + `UPDATE 2`(좀비) = **19행 COMMIT 성공**.

## 5. 사후검증 (COMMIT 후 라이브 재실측·전건 PASS)

### 5.1 19행 정착
| 항목 | 결과 |
|---|---|
| 옵션 OPV_000431 | PRD_000135·OPT_000016·"천정형고리 포함"·disp_seq=2·dflt=N·use=Y·del=N ✅ |
| use_dims 4행 | mesh_4/6/8 = `["proc_cd","min_qty","proc_grp:PROC_000079"]`·jokja = `["opt_cd","min_qty"]` ✅ |
| 일반 타공 38219/20/21 | proc_cd=PROC_000104·{타공수 4/6/8}·3000/4000/8000 verbatim ✅ |
| 메쉬 타공 4750/52/54 | proc_cd=PROC_000079·{타공수 4/6/8}·3000/4000/5000 verbatim ✅ |
| 족자 4594 | opt_cd=OPV_000431·bdl_qty=NULL·6500 verbatim ✅ |
| 바인딩 5행 | 린넨 disp_seq=2·메쉬 4/5/6·족자 2 — 전부 addtn_yn=Y ✅ |
| 좀비 2행 | NORMAL_PUNCH_6/8 use_yn=N·del_yn=Y ✅ |

### 5.2 always-add 가드 실효 (엔진 의미 입증)
- 메쉬 타공 proc_cd NULL 잔존 = **0** · 족자 opt_cd NULL 잔존 = **0** · 활성 일반타공 comp use_dims=[] 잔존 = **0**.
- 엔진 `_row_matches`(pricing.py L82-94): 행 차원 NULL=와일드카드(always-match). 판별차원 충전으로 와일드카드 제거.
  - **미선택**: selections에 proc_cd/opt_cd 키 부재 → `_norm(None)≠_norm("PROC_000079")` → row=False → **가산 0**(과대청구 always-add 제거 실효).
  - **선택**: 위젯이 `procs=[{proc_cd:부모, detail:{타공수:N}}]` 전송 → dim_vals 매칭 1행만 → **정확 단가 1행**(메쉬/족자 각 comp 1행·일반 PUNCH_4 3행 distinct 타공수·ERR_DUPLICATE 0).

### 5.3 FK 고아 / 멱등 / 기초코드 불변
- FK 고아(proc_cd→t_proc_processes) = **0**.
- 재-dryrun(post-commit): 전 문 **delta 0** → 정착·멱등 확정(재실행 무변화).
- 기초코드 마스터 불변: PROC_000104/079/105=del_yn N·PROC_000103=좀비(Y) — 본 적재로 변경 0. t_siz/t_mat 미접촉.

### 5.4 ★각목(GAKMOK) 비접촉
- COMMIT 후 GAKMOK comp 3행 = 백업과 동일(use_yn=Y·del_yn=N) — **일절 미변경**. 캔버스125·HOLD-125 미접촉.

## 6. undo 보유

- `undo.sql` — 역연산(좀비 use_yn Y복원·바인딩 5 DELETE·단가행 판별값 직전복원·use_dims 직전복원·옵션 DELETE). FK 위상 역순.
- 백업 정합: undo.sql 직전값 = backup-before-260623.csv와 일치(proc 105/NULL·bdl_qty 2·use_dims []/[PROC_000080]/[bdl_qty,min_qty]). **미실행 보유**(현 라이브=정상 적재 상태).

## 7. HOLD·범위 밖 (정직 표기)
- ★각목(CONFIRM-4)=범위 밖·미접촉. HOLD-125(캔버스 마감비)·HOLD-C-PRICE(족자 6500 vs 권위 4000? 미확정·6500 verbatim)·HOLD-C-ITEM(족자 천정고리 자재 미등록·가격 무영향).
- 타공 코드 트랙: 타공수별 가산은 위젯 코드 동반 후 작동. 데이터 트랙 성과 = always-add(과대청구) 제거 완결.
