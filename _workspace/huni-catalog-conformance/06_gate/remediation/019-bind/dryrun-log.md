# dryrun-log.md — 019 묶음 교정(A5-plate + A2-bind) 롤백전용 DRY-RUN 결과

> 실행 2026-06-22 · 라이브 `railway` · `BEGIN … ROLLBACK`(쓰기 0·커밋 0) · `ON_ERROR_STOP=1`.
> [HARD] NEVER COMMIT. 단일 트랜잭션 롤백전용 — 라이브 불변(post-rollback 재확인).
> 대상: `apply.sql` (STEP1 plate UPDATE + STEP2 bind UPSERT).

## 트랜잭션 내 단계별 결과

| 단계 | 결과 | 판정 |
|------|------|:----:|
| [BEFORE] 019 plate / binding | plate 출력판형=**SIZ_000522** · binding **0** | 시작점 |
| [PASS1] STEP1 UPDATE + STEP2 INSERT | plate 출력판형 → **SIZ_000499** · binding → **1** | 적재 성공 |
| [PASS2] 양 STEP 재실행 | UPDATE 0행 · INSERT 0행 (델타 0) | **멱등 PASS** |
| [RECON] 정정 plate 단가 도달 | SIZ_000499: COMP_PRINT **106 tier** · COMP_PAPER **56행** | 환원 성립(이전 0행) |
| [GOLDEN] 대표 견적 재계산 | 비-0 산출 (아래) | **0원→정상 전환 PASS** |
| [PARITY] 형제 016/017/018 | 전부 SIZ_000499·106 tier 동일 경로 | **정합 동치 PASS** |
| [FK CHECK] | siz_fk=1·otyp_fk=1·frm_fk=1 | **FK PASS** |
| [ROLLBACK] / [VERIFY] | still_522=1·has_499=0·bind=0 | 라이브 불변 확인 |

## 멱등성 증명(R1)

- PASS2: STEP1 UPDATE 영향 0행(`WHERE siz_cd='SIZ_000522'` 가드 — 1회차로 522 소멸), STEP2 INSERT 0행(ON CONFLICT DO NOTHING).
- 2회차 PK 충돌 에러 없음 → 충돌키 정합(plate PK=(prd_cd,siz_cd)·binding PK=(prd_cd,apply_bgn_ymd)).

## 원자성(R2)

- 단일 `BEGIN … ROLLBACK`·중간 COMMIT 없음·`ON_ERROR_STOP=1` → STEP1·STEP2 묶음 all-or-nothing.

## 단가 환원 + 골든 재계산 (★0원→정상 전환 입증)

**RECON** — 정정 후 019 출력판형:

| plt_siz_cd | siz_nm | COMP_PRINT_DIGITAL_S1 tiers | COMP_PAPER rows |
|---|---|:--:|:--:|
| SIZ_000499 (정정 후) | 316x467 | **106** | **56** |
| (정정 전 SIZ_000522) | 315x467 | 0 | 0 |

**GOLDEN** — 대표 케이스(plt=SIZ_000499·mat=MAT_000074·인쇄 단면·qty=100·무광 1면), `component_subtotal=unit_price×qty`(PRICE_TYPE.01 단가형):

| 구성요소 | unit_price | qty | subtotal |
|---|---:|---:|---:|
| COMP_PRINT_DIGITAL_S1 (min_qty=100) | 200.00 | 100 | 20,000 |
| COMP_PAPER (MAT_000074) | 70.64 | 100 | 7,064 |
| COMP_COAT_MATTE (1면·tier≤100) | 500.00 | 100 | 50,000 |
| **Σ included (round 전 합산)** | | | **77,064** |

- 정정 전(plate=SIZ_000522): 전 구성요소 no-match → 합계 0 → lenient 0원.
- 정정+바인딩 후: **비-0 산출(예: 77,064원/100매 대표케이스)** → 0원 차단 해소·실가격 전환 입증.
- 단가값 verbatim(라이브 SELECT)·신규 mint 0·날조 0.

## 형제 정합 비교(PARITY)

| prd_cd | frm_cd | 출력판형 | COMP_PRINT tiers |
|---|---|---|:--:|
| PRD_000016 | PRF_DGP_A | SIZ_000499 | 106 |
| PRD_000017 | PRF_DGP_A | SIZ_000499 | 106 |
| PRD_000018 | PRF_DGP_A | SIZ_000499 | 106 |
| **PRD_000019 (교정 후)** | **PRF_DGP_A** | **SIZ_000499** | **106** |

→ 019 가 형제 엽서와 동일 공식·동일 출력판형·동일 단가행 경로에 합류 = 정합.

## ROLLBACK 확인

- ROLLBACK 후 fresh read: still_522=1(라이브 plate 여전히 SIZ_000522), has_499=0, bind_cnt=0 → **라이브에 아무것도 커밋되지 않음**.

## 종합

- 적재 가능성 PASS · 멱등성 PASS · 원자성 PASS · FK PASS · 롤백 무손상 PASS.
- **차단 해소 PASS + 가격 실현 PASS**(묶음 효과) — 단건 A2-bind 의 잔여 의존(plate)을 A5-plate 동반으로 완결.
