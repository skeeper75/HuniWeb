# _exec_sticker2 — 스티커 BLOCKED 마무리 실행본 (round-23 항목 7)

arbiter `../sticker-blocked-resolution.md`(SB1~SB5) 중 즉시 GO분 → 멱등 SQL + 롤백전용 DRY-RUN. **설계+DRY-RUN GO 까지 · 실 COMMIT 인간 승인.**
(1차 `_exec_sticker`(소재4·투명교정·B3/B4·바인딩) 후속 — BLOCKED 분리분 해소)

## 파일
| 파일 | 내용 |
|------|------|
| `gen_load_sql.py` | xlsx verbatim → SB3 B01 단가행 504 재현 생성기(byte-identical) |
| `SB3_codegen.sql` | siz 채번 SIZ_000518(100x148)·SIZ_000519(90x110) — search-before-mint |
| `SB3_b01_prices.sql` | B01 100x148/90x110 단가행 504 (7mat×2siz×36mq·verbatim) |
| `SB1_tattoo.sql` | 타투 합가형 사슬 5 (COMP_STK_TATTOO .02 + PRF_STK_TATTOO + 배선 + 단가행 min_qty=3 + 바인딩067) |
| `SB2_pack_fix.sql` | 팩 교정 (comp .01→.02 + 기존2행 DELETE + min_qty=54 단일행 + PRF_STK_PACK + 배선 + 바인딩065) |
| `apply.sql` | 단일 트랜잭션·FK 위상·`ROLLBACK` 기본 |
| `apply.sh` | 백업 4 CSV → DRY-RUN(기본) / `--commit`(인간 승인 후) |
| `manifest.md`·`dryrun-report.md`·`blocked-and-gaps.md` | 매니페스트·R1~R6·잔여 차단 |

## 실행
```bash
bash apply.sh dryrun     # 기본·라이브 무변경·COMMIT 0
bash apply.sh --commit   # 실 COMMIT (인간 최종 승인 후에만)
```

## 핵심
- 영향행 **518** (INSERT 515 + UPDATE 1 + DELETE 2) · 멱등 2-pass delta 0 · FK 고아 0 · COMMIT 0.
- **★.02 합가형 min_qty NOT NULL**: 타투 min_qty=3·팩 min_qty=54 (엔진 base<=0 ValueError 회피·검증 0).
- 골든: 타투 q9=12000(4000÷3×9)·팩 q54=4000(세트총액)·B01 6700/7700 verbatim.
- 채번 SIZ_000518/519 (max=SIZ_000517 → 무충돌·search-before-mint).
- PK=시퀀스(comp_price_id)→NOT EXISTS 자연키 가드 · ppf PK=(prd,apply_bgn_ymd) NOT EXISTS.
- 검증은 `dbm-validator` R1~R6 (자체승인 금지).

## 잔여 BLOCKED (blocked-and-gaps.md)
타투 기본가2000(Q-STK-1b)·058~064 반칼변형 출처(Q-STK-8 data-gap)·B01 A4/A3 단가 실재(Q-STK-7r·별 siz 채번 선결)·팩 환산단위(Q-STK-3b 컨펌).
