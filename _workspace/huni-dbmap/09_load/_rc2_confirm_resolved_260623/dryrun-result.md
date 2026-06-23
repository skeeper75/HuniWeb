# dryrun-result.md — RC-2 CONFIRM 확정 3건 롤백전용 라이브 DRY-RUN 결과

> dbm-load-builder · 2026-06-23 · 라이브 `BEGIN … apply … ROLLBACK` (실제 COMMIT 0·아무것도 커밋 안 됨).
> 자격증명 = `.env.local RAILWAY_DB_*`(읽기/롤백 전용). 비밀번호 PGPASSWORD 전용·미노출.
> ★빌더 셀프 DRY-RUN(빌드 실증용). 공식 R1~R6 게이트 판정은 dbm-validator 독립 수행.

---

## 영향 행수 (BEGIN…ROLLBACK 1회·제약위반 0)

| step | 문 | 영향행수 |
|---|---|---|
| 01 options INSERT | 1 | 1 |
| 02 use_dims UPDATE | 4 (메쉬 3 + 족자 1) | 4 |
| 03 price_fill UPDATE | 7 (일반 타공 3 + 메쉬 타공 3 + 족자 1) | 7 |
| 04 formula_components INSERT | 5 (린넨 1 + 메쉬 3 + 족자 1) | 5 |
| 05 zombie_cleanup UPDATE | 2 | 2 |
| **합계** | | **19** |

- 구문 오류 **0**. 제약 위반(type/length/NOT NULL/CHECK/FK/PK) **0**. `ON_ERROR_STOP=1` 하 정상 완주 → ROLLBACK.
- 트랜잭션 원자성: 단일 `BEGIN … ROLLBACK` (apply.sh가 ROLLBACK 주입). 중간 COMMIT 없음·부분적재 경로 없음.

## R1 멱등성 — 같은 트랜잭션 2-pass

| 문 | PASS1 | PASS2 |
|---|---|---|
| 01 options INSERT | INSERT 0 1 | **INSERT 0 0** |
| 02 use_dims UPDATE ×4 | 각 UPDATE 1 | **각 UPDATE 0** |
| 03 price_fill UPDATE ×7 | 각 UPDATE 1 | **각 UPDATE 0** |
| 04 formula INSERT ×5 | 각 INSERT 0 1 | **각 INSERT 0 0** |
| 05 zombie UPDATE | UPDATE 2 | **UPDATE 0** |

**→ PASS2 전 문 0행. 멱등성 확정.** (`IS DISTINCT FROM` + `unit_price` verbatim 가드 + `NOT EXISTS`)

## POST-STATE 검증 (TX 내·롤백 전 SELECT)

- 족자 옵션: `PRD_000135 | OPV_000431 | OPT_000016 | 천정형고리 포함 | disp_seq=2 | use_yn=Y` ✅
- 족자 단가행 4594: `opt_cd=OPV_000431 | bdl_qty=NULL | unit_price=6500.00` ✅ (verbatim)
- 일반 타공 38219/20/21: `proc_cd=PROC_000104 | {"타공수":4/6/8} | 3000/4000/8000` ✅ (verbatim)
- 메쉬 타공 4750/52/54: `proc_cd=PROC_000079 | {"타공수":4/6/8} | 3000/4000/5000` ✅ (verbatim)
- 바인딩 5건: 린넨 disp_seq=2·메쉬 4/5/6·족자 2 (전부 addtn_yn=Y) ✅
- 좀비: NORMAL_PUNCH_6/8 `use_yn=N | del_yn=Y` ✅

## ALWAYS-ADD 가드 입증 (적재 후 와일드카드 단가행 잔존 = 0)

엔진 `_row_matches`(pricing.py line87-88): 판별차원이 None이면 always-match(silent always-add).
적재 후 판별차원 충전으로 와일드카드 제거됨을 SELECT로 확인:

| 점검 | 결과 |
|---|---|
| 메쉬 타공 3행 proc_cd NULL 잔존 | **0** |
| 족자 천정고리 opt_cd NULL 잔존 | **0** |
| 활성(use_yn=Y·del_yn=N) 일반 타공 comp 중 use_dims=[] 잔존 | **0** |

**→ 미선택 0가산 보장(과대청구 always-add 제거)이 데이터로 완결.**
- 미선택 시: selections에 proc_cd/opt_cd 키 부재 → `_norm(None)≠_norm(실제값)` → row=None → 가산 0.
- 선택 시: 위젯이 `procs=[{proc_cd:부모, detail:{타공수:N}}]` 전송 시 dim_vals 매칭 1행만 → 정확 단가 1행(ERR 0).

## ★타공 데이터 트랙 한계 (정직 명시·[HARD])

- **타공수별 가산은 데이터만으론 미작동**: option_item 환원이 타공수 detail(ref_key2/qty) 미전송. 엔진은 호출자 `procs[].detail{타공수:N}`로만 dim_vals 매칭(line583-589·dim_vals 와일드카드 없음).
- **위젯 코드 동반 필요**(§6/webadmin·§21 범위 밖): 타공 옵션 선택→타공수 추출→procs 조립 전송이 있어야 타공수별 작동.
- **데이터 트랙 확정 성과 = always-add(과대청구) 제거**: 미선택 0가산은 데이터로 보장(위 가드 입증).

## UNDO DRY-RUN (undo.sql)

`./apply.sh undo` → `BEGIN … ROLLBACK` 정상 완주·구문/제약 오류 0. (현 라이브=apply 미커밋 상태이므로 undo 가드가 0행 매칭 = 안전·멱등.)

## 판정 (빌더 자체 실증 — 게이트 아님)

- ✅ 구문/제약 위반 0 · 원자성(단일 TX) · 멱등(2-pass PASS2 전부 0)
- ✅ 단가 verbatim 전건 보존(0/800/1000/2000/3000/4000/5000/6500/8000 불변)
- ✅ search-before-mint(신규 opt_cd OPV_000431 MAX+1·신규 그룹 0·신규 comp/공식/마스터 0)
- ✅ always-add 제거(와일드카드 단가행 잔존 0) · ★각목 미접촉 · 기초코드 마스터 불변
- → **dbm-validator R1~R6 독립 게이트 + 인간 승인 후 hbd-load-executor COMMIT.** 빌더 COMMIT 금지.
