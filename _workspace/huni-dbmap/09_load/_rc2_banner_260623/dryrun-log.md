# dryrun-log.md — RC-2 일반현수막 옵션 바인딩 라이브 DRY-RUN

> 2026-06-23 · 단일 트랜잭션 BEGIN…ROLLBACK. ★COMMIT 안 함. 라이브 미변경.
> 멱등 입증 = 동일 트랜잭션 내 적재 2회(PASS1 적용·PASS2 0행).

## 실행 명령
```
psql … <<'SQL'  BEGIN; \i 01..03 (PASS1) → 상태검증 → \i 01..03 (PASS2) → 단가검증 → ROLLBACK; SQL
```

## PASS 1 (적재) — 0 제약위반
- `01_use_dims.sql`: **UPDATE 5** (CUTEDGE·DTAPE·BONGSEW use_dims `[]`→`[opt_cd,opt_grp:OPT_000003]` / QBANG opt_grp 018→004 / STRING `[]`→`[opt_cd,opt_grp:OPT_000004]`)
- `02_opt_fill.sql`: **UPDATE 5** (단가행 opt_cd 충전 — 4692→OPV_000006·4699→OPV_000010·4701→OPV_000011·4694→OPV_000013·4696→OPV_000014)
- `03_formula_components.sql`: **INSERT/UPSERT 6** (PUNCH_4 기존행 addtn_yn=Y·disp_seq=2 충전 + CUTEDGE/DTAPE/BONGSEW/QBANG/STRING 신규 바인딩 seq 3~7)
- 제약위반(type/length/NOT NULL/CHECK/FK/PK): **0건**

### PASS1 후 상태 검증 (라이브 트랜잭션 내)
```
use_dims:  QBANG=["opt_cd","opt_grp:OPT_000004"]  CUTEDGE=["opt_cd","opt_grp:OPT_000003"]
opt_cd:    4692=OPV_000006 4694=OPV_000013 4696=OPV_000014 4699=OPV_000010 4701=OPV_000011 (단가 3000/3000/4000/3000/4000 불변)
바인딩:    PRF_POSTER_BANNER_N → 본체(seq1)+PUNCH_4(2)+CUTEDGE(3)+DTAPE(4)+BONGSEW(5)+QBANG(6)+STRING(7) 전부 addtn_yn=Y
```

## PASS 2 (멱등 재적재) — 전부 0행
- `01_use_dims.sql`: **UPDATE 0** (IS DISTINCT FROM 가드 — 이미 충전됨)
- `02_opt_fill.sql`: **UPDATE 0** (opt_cd IS DISTINCT FROM 가드)
- `03_formula_components.sql`: **INSERT 0** (ON CONFLICT + addtn/seq IS DISTINCT FROM 가드)
- **멱등성 입증 ✅** — 2회차 변경 0행.

## 단가 verbatim 불변 (PASS2 후)
CUTEDGE 3000 · STRING 4000 · BONGSEW 4000 · QBANG 3000 · DTAPE 3000 — 전부 불변 ✅

## ROLLBACK
완료 — 라이브 영구 변경 0. 본 DRY-RUN은 쓰기 트랜잭션이나 전부 롤백됨.

## 판정
적재 가능성(R5 제약위반 0)·멱등성(R1 2회차 0행)·원자성(단일 BEGIN…ROLLBACK)·단가 verbatim 전부 PASS.
COMMIT은 인간 승인 후 `./apply.sh commit`.
