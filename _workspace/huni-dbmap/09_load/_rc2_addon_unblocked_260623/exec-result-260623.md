# exec-result-260623.md — RC-2 추가물형(비BLOCKED) 라이브 적재 실행 결과

> 2026-06-23 · §21 RC-2 추가물형 3상품(메쉬현수막 139·캔버스행잉 133·린넨우드봉 134) · **인간 승인 완료 · dbm-validator R1~R6 GO** 후 hbd-load-executor 실행.
> 자격증명 `.env.local RAILWAY_DB_*`(chmod 600 확인). PGPASSWORD 전달·stdout/로그 비노출.
> PET(136)=HOLD-1 BLOCKED 제외.

## 판정: **COMMIT 성공 (23행 적재 · 사후검증 전건 PASS)**

단일 트랜잭션 COMMIT. 영향 23행 정착. FK 고아 0 · 멱등 재-dryrun 0 · always-add 가드 라이브 실효 입증 · 단가 verbatim · 기초코드 마스터 불변 · PET 미관여 확인.

---

## 1. 물리 백업 (적재 전·undo ground-truth)

`backup-before-260623.csv` — 영향 대상 현재 상태 read-only 스냅샷 (2026-06-23T05:28Z).

| 섹션 | 백업 결과 |
|---|---|
| 옵션 (4 대상) | **0행** = 사전 미존재 (신규 INSERT 대상 확정) |
| comp use_dims (4) | 메쉬 2개 `[]` · 캔버스/린넨 `["siz_cd"]` |
| 단가행 (8 PK) | 4598/99/600 canvas siz 258/315/317·opt_cd NULL·16000/18000/20000 · 4604/05/06 linen 258/315/317·NULL·7000/9800/12000 · 4751 mesh qbang NULL·3000 · 4753 mesh string NULL·4000 |
| 공식 바인딩 (4) | **0행** = 사전 미존재 (신규 INSERT 대상 확정) |

백업이 manifest 현재값 주장과 전건 일치. undo.sql 원복 대상이 이 스냅샷과 정합.

## 2. 사전 게이트 (COMMIT 전 라이브 실측)

| 검사 | 결과 |
|---|---|
| DB 접속 | OK |
| upd_dt/reg_dt 컬럼 실재 (4 테이블) | 전부 실재 (COMMIT 실패 방지) |
| FK: rebind siz 172/174/197 실재 | 3/3 ✅ |
| FK: frm 마스터 3종 실재 | 3/3 ✅ |
| FK: 옵션그룹 3종 실재 | 3/3 ✅ |
| FK: 4 comp 마스터 실재 | 4/4 ✅ |
| opt_cd MAX | OPV_000424 → 신규 425/426/429/430 충돌 0 |
| RC-4 차원 등가 (라이브 실측) | 258=172 (A4 210×297) · 315=174 (A3 297×420) · 317=197 (A2 420×594) 전건 동일치수 확정 |

## 3. DRY-RUN 재실행 (BEGIN…ROLLBACK · COMMIT 전)

검증자 주장 비신뢰·직접 실측. 2회 실행:

```
1-pass:  INSERT 0 1 ×4 · UPDATE 1 ×15 · INSERT 0 1 ×4  = 23행 · ERROR 0 · ROLLBACK
2-pass:  INSERT 0 0 ×4 · UPDATE 0 ×15 · INSERT 0 0 ×4  = 0행 (멱등 입증)
```

제약위반(FK/NOT NULL/CHECK/트리거) 0 — `ON_ERROR_STOP on` 하 전 문장 통과. 가드(NOT EXISTS·IS DISTINCT FROM·verbatim WHERE·ON CONFLICT DO UPDATE WHERE) 전부 작동.

## 4. 실 COMMIT (`./apply.sh commit`)

단일 트랜잭션. **23행 영향 · COMMIT 성공.**

```
BEGIN
01 options    : INSERT 0 1 ×4   (4)
02 use_dims   : UPDATE 1   ×4   (4)
03 price_fill : UPDATE 1   ×11  (opt_cd 8 + RC-4 siz 3)
04 formula    : INSERT 0 1 ×4   (4)
COMMIT
```

IDENTITY 채번 정상 · FK 부모 실재 · 부분 실패 0.

## 5. 사후검증 (COMMIT 후 라이브 재실측)

| 검증 | 결과 | 판정 |
|---|---|---|
| **POST-1** 신규 옵션 4건 정착 | (133,OPV_000429 disp2)·(134,OPV_000430 disp2)·(139,OPV_000425 disp2/OPV_000426 disp3)·use_yn=Y·del_yn=N | ✅ |
| **POST-2** comp use_dims opt_cd 가드 충전 | 메쉬 `[opt_cd,opt_grp:OPT_000023]` ×2 · 캔버스 `[opt_cd,siz_cd,opt_grp:OPT_000012]` · 린넨 `[opt_cd,siz_cd,opt_grp:OPT_000014]` | ✅ |
| **POST-3** 단가행 11행 판별값+단가 verbatim | RC-4 재배선 정착: 4598→SIZ_000172·4599→174·4600→197 / opt_cd 8행 충전 / 단가 16000·18000·20000·7000·9800·12000·3000·4000 전건 불변 | ✅ |
| **POST-4** 공식 바인딩 4행 addtn_yn=Y | BANNER_M(qbang disp2/string disp3)·CANVAS_HANGING disp2·LINEN_WOODBONG disp2 | ✅ |
| **POST-5** FK 고아 (rebind siz) | 0 | ✅ |
| **POST-6** 구 siz 258/315/317 canvas 잔존 | 0 (완전 재배선) | ✅ |
| **POST-7** 멱등 재-dryrun | INSERT 0 0 ×4 · UPDATE 0 ×15 · INSERT 0 0 ×4 = 전건 0 (이미 적재) | ✅ |

### ★ 엔진 재현 (always-add 가드 라이브 실효)

`pricing.py` `_row_matches`/`match_component` 로직을 라이브 단가행 입력으로 재현:

| 시나리오 | 매칭 단가행 | 가산 | 판정 |
|---|---|---|---|
| 우드행거 "출력만"(opt_cd≠OPV_000429)+siz172 | **0행** (NULL opt 와일드카드 누출 0 포함) | **0** | ✅ 가드 실효 |
| 우드행거 "선택"(OPV_000429)+siz172/174/197 | 각 **1행** | 16000/18000/20000 | ✅ 단일·정확 |
| 우드봉 "출력만"(opt_cd≠OPV_000430) | 0행 | 0 | ✅ |
| 우드봉 "선택"(OPV_000430)+258/315/317 | 각 1행 | 7000/9800/12000 | ✅ |
| 메쉬 큐방/끈 "출력만" | 각 0행 | 0 | ✅ |
| 메쉬 큐방/끈 "선택"(OPV_000425/426) | 각 1행 | 3000/4000 | ✅ |

ERR_AMBIGUOUS/ERR_DUPLICATE = 0. **적재 전 결함(opt_cd NULL 와일드카드 → 출력만 선택 시 silent 가산)이 라이브에서 해소됨.**

### 부작용 범위

| 검사 | 결과 |
|---|---|
| 기초코드 마스터 (t_siz_sizes) | **불변** — rebind은 component_prices 참조값만 변경, siz 마스터 행/치수 verbatim |
| t_mat | 미관여 (option_item MES 환원=HOLD-2/3·가격 무영향·본 적재 제외) |
| PET (136) | **미관여** — pet_opts 0 · STAND comp 바인딩 0 |
| 단가 합계 (4 comp) | 3000·4000·54000·28800 = 백업과 동일 (날조 0) |

## 6. undo 보유 (미실행)

`undo.sql` (역위상 원복·단가 불변) + `backup-before-260623.csv`(원복 ground-truth) 보유. **실행하지 않음** — 사후검증 전건 PASS이므로 원복 불요. 필요 시 `./apply.sh undo-commit`.

---

## 산출물

- `backup-before-260623.csv` — 적재 전 영향행 스냅샷 (undo ground-truth)
- `exec-result-260623.md` — 본 문서
- `undo.sql` — 역연산 (보유·미실행)

## 잔존 (적재 범위 밖·정직 보고)

- **PET S1/S2 (HOLD-1 BLOCKED)**: OPT_000009 그룹 모델링 충돌 — 실무진 CONFIRM 전 제외 (정확히 배제됨).
- **option_item MES 환원 (HOLD-2/3)**: 큐방 자재 MAT_000337(139 미등록)·우드 부속 자재 미확정 — **가격 무영향**(가격=단가행 opt_cd/siz_cd 단독 판별). 후속 트랙.
