# _rc2_confirm_resolved_260623 — RC-2 CONFIRM 확정 3건 적재본

§21 RC-2 CONFIRM 확정 3건(린넨마감·타공 데이터·족자)의 멱등 적재본. **DB 미적재** — 기본 DRY-RUN(롤백전용).
실 COMMIT은 dbm-validator R1~R6 GO + 인간 승인 후 hbd-load-executor만 수행(빌더 COMMIT 금지).

## 대상 (3건)
- **CONFIRM-B 린넨마감(124)**: LINEN_FINISH → PRF_POSTER_LINEN 공식 바인딩 1건만(재배선 0·단가행 정합).
- **CONFIRM-A 타공(138/139)**: 일반 proc_cd 105→104(3행) / 메쉬 proc_cd NULL→079+dim_vals 충전(3행)+use_dims 충전+바인딩(disp_seq 4/5/6) / 좀비 use_yn=N. 단가 verbatim.
- **CONFIRM-C 족자(135)**: 신규 opt_cd OPV_000431 + 단가행 bdl_qty→opt_cd 재배선(6500 verbatim) + use_dims 재배선 + PRF_POSTER_JOKJA 바인딩(disp_seq=2).
- ★**각목(CONFIRM-4)=범위 밖·일절 미접촉**. 기초코드 마스터(t_siz/t_mat/proc) 불변.

## 파일
- `apply.sql` — 단일 트랜잭션 래퍼(FK 위상·BEGIN…ROLLBACK[기본]). `01→02→03→04→05` `\i`.
- `01_options.sql` · `02_use_dims.sql` · `03_price_fill.sql` · `04_formula_components.sql` · `05_zombie_cleanup.sql` — 멱등 단계 SQL.
- `undo.sql` — 원복(역순·verbatim 복원).
- `apply.sh` — psql 로더(기본 dryrun). 비밀번호 PGPASSWORD 전용·미노출.
- `manifest.md` — 전 행 1:1(현재값↔설계값)·라이브 재실측 근거·멱등성.
- `dryrun-result.md` — 영향행수·제약위반 0·2-pass 멱등·always-add 가드 입증·타공 한계.
- `load.provenance.csv` — 행별 출처(라이브 id↔명세↔설계값).

## 실행
```bash
./apply.sh            # DRY-RUN (롤백전용·아무것도 커밋 안 됨·기본)
./apply.sh dryrun     # 동일
./apply.sh commit     # ★인간 승인(R1~R6 GO) 후에만. 실제 적재(COMMIT).
./apply.sh undo       # DRY-RUN 원복
./apply.sh undo-commit # ★인간 승인 후에만. 실제 원복(COMMIT).
```

## 멱등성·안전
- UPDATE = `IS DISTINCT FROM` 가드 + 단가행은 `unit_price=<검증값>` verbatim 가드. INSERT = `NOT EXISTS`(PK).
- 2-pass: PASS1=19행·PASS2=전부 0행(실증·dryrun-result.md).
- search-before-mint: 신규 opt_cd OPV_000431(MAX+1·충돌 0)·신규 그룹/comp/공식/마스터 0.
- always-add 제거: 판별차원(proc_cd/opt_cd) 충전 → 미선택 0가산 보장(와일드카드 단가행 잔존 0).
- 타공수별 가산 = 위젯 코드 동반 후 작동(데이터 트랙 한계·§21 범위 밖). 데이터 트랙=always-add 제거까지.

## HOLD (정직 표기)
HOLD-125(캔버스 마감비 비동형·미적재) · HOLD-C-PRICE(족자 6500 vs 권위 4000? 실무 확정) · HOLD-C-ITEM(천정고리 자재 135 미등록·환원 HOLD·가격 무영향) · HOLD-MESH-MERGE(메쉬 1 comp 통합 보류·3 comp 유지).
