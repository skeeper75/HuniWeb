# dryrun-result.md — RC-2 추가물형 적재 롤백전용 DRY-RUN 결과

> 2026-06-23 · `BEGIN … ROLLBACK` 라이브 트랜잭션. **COMMIT 0·라이브 무변경.** psql `.env.local RAILWAY_DB_*`.
> 비밀값 비노출(PGPASSWORD 전달·stdout echo 없음).

## A. 1-pass 영향행수 (제약위반 0)

```
01 options INSERT  : INSERT 0 1 × 4   = 4행
02 use_dims UPDATE : UPDATE 1   × 4   = 4행
03 price_fill      : UPDATE 1   × 11  = 11행 (opt_cd 8 + RC-4 siz 3)
04 formula bind    : INSERT 0 1 × 4   = 4행
------------------------------------------------
합계 23행 · ERROR 0 · 제약위반(FK/NOT NULL/CHECK/트리거) 0
```

ON_ERROR_STOP on 하에서 전 문장 무오류 통과 → ROLLBACK.

## B. 적재후 상태 검증 (트랜잭션 내 SELECT)

- **검증A 옵션 4건**: (139,OPV_000425/426)·(133,OPV_000429)·(134,OPV_000430) disp_seq 2/3/2/2·use_yn=Y·del_yn=N·FK 그룹 정합.
- **검증B use_dims**: 메쉬 `[opt_cd,opt_grp:OPT_000023]`·캔버스 `[opt_cd,siz_cd,opt_grp:OPT_000012]`·린넨 `[opt_cd,siz_cd,opt_grp:OPT_000014]` → **always-add 가드(opt_cd 포함) 충전 확인**.
- **검증C 단가행**: 4598→siz SIZ_000172/opt OPV_000429/16000 · 4599→174/OPV_000429/18000 · 4600→197/OPV_000429/20000 · 4751→opt OPV_000425/3000 · 4753→OPV_000426/4000 · 4604/05/06→OPV_000430/7000·9800·12000. **단가 전부 verbatim 불변.**
- **검증D 바인딩**: 4 comp 전부 addtn_yn=Y·disp_seq(메쉬 2/3·캔버스 2·린넨 2).

## C. always-add 가드 입증 (★핵심)

```
검증E: SELECT count(*) FROM t_prc_component_prices
       WHERE comp_cd='COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
         AND siz_cd='SIZ_000172' AND opt_cd IS NOT NULL AND opt_cd<>'OPV_000429';
→ rows_matching_outputonly = 0
```

해석: use_dims에 opt_cd 추가 + 단가행 3행 모두 opt_cd=OPV_000429 충전 후, **"출력만"(opt_cd≠OPV_000429) 선택 시 매칭 단가행 = 0행 → `_row_matches` None → 우드행거 가산 0**. opt_cd 미충전 시 발생하던 always-add(siz_cd만 매칭·opt_cd NULL 와일드카드) 결함 해소 입증. 메쉬 큐방/끈도 동형(use_dims opt_cd·단가행 opt_cd 충전).

## D. 멱등성 2-pass (PASS2 전 문장 0행)

같은 트랜잭션에서 4 SQL을 연속 2회 실행:

```
PASS 1: INSERT 0 1 ×4 · UPDATE 1 ×15 · INSERT 0 1 ×4   (23행 변경)
PASS 2: INSERT 0 0 ×4 · UPDATE 0 ×15 · INSERT 0 0 ×4   (0행 — 멱등 입증)
```

NOT EXISTS·IS DISTINCT FROM·verbatim WHERE·ON CONFLICT DO UPDATE WHERE 가드 전부 작동.

## E. undo round-trip (apply→undo 같은 tx·ROLLBACK)

```
undo: DELETE 4 (바인딩) · UPDATE 1×3 (siz 원복) · UPDATE 8 (opt_cd NULL) · UPDATE 2×2 (use_dims 원복) · DELETE 4 (옵션)
원복후: opt_remaining=0 · use_dims 원상태([] / [siz_cd]) · 단가행 opt_cd NULL·siz_cd 258 복귀·단가 verbatim · bind_remaining=0
```

undo.sql이 apply.sql을 정확히 원복(단가 불변) 입증.

## F. 단가 합계 불변 (verbatim 가드)

| comp | 단가 합계(적재후) |
|---|---|
| MESH_ADD_QBANG_4 | 3000.00 |
| MESH_ADD_STRING_4 | 4000.00 |
| CANVAS_HANGING_WOODHANGER | 54000.00 (16000+18000+20000) |
| LINEN_WOODBONG_WOODBONG | 28800.00 (7000+9800+12000) |

라이브 현재값과 동일 → 단가 날조 0.

## 판정 (빌더 측 DRY-RUN — self-approve 아님)

- 영향행수 23 · 제약위반 0 · 멱등 2-pass 0행 · always-add 가드 입증 · RC-4 재배선 확정 · 단가 verbatim · undo 정합.
- **COMMIT 0 · 라이브 무변경.** dbm-validator R1~R6 독립 게이트 + 인간 승인 후 실 COMMIT.
