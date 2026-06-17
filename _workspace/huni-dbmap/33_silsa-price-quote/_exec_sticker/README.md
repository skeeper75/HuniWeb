# _exec_sticker — 스티커 누락 채움 실행본 (round-23 항목 7)

arbiter `../sticker-3axis-design.md`(S1~S8) → 멱등 SQL + 롤백전용 DRY-RUN. **설계+DRY-RUN GO 까지 · 실 COMMIT 인간 승인.**

## 파일
| 파일 | 내용 |
|------|------|
| `gen_load_sql.py` | xlsx verbatim → S1/S3 SQL 재현 생성기(byte-identical·provenance) |
| `S1_b01_materials.sql` | B01 소재 4미적재 INSERT 288 (비코팅·미색·유광·홀로) |
| `S2_clear_remap.sql` | 투명 오매핑 170→162 UPDATE ≤90 (기존 행·과교정 0) |
| `S3_b3b4_prices.sql` | B4/B3 단가행 INSERT 24 (siz 실존·즉시 GO) |
| `S8_bindings.sql` | 바인딩 054/056/057 → PRF_STK_FIXED INSERT 3 |
| `apply.sql` | 단일 트랜잭션·FK 위상·`ROLLBACK` 기본 |
| `apply.sh` | 백업 CSV → DRY-RUN(기본) / `--commit`(인간 승인 후) |
| `manifest.md` | 적재 순서·집계 |
| `dryrun-report.md` | R1~R6·멱등 2-pass·verbatim·골든 |
| `blocked-and-gaps.md` | S4/S5/S6/S7·058~064·066 차단 + 해제 조건 |

## 실행
```bash
# DRY-RUN (기본·라이브 무변경·COMMIT 0)
bash apply.sh dryrun
# 실 COMMIT (인간 최종 승인 후에만)
bash apply.sh --commit
```

## 핵심
- 영향행 **405** (INSERT 315 + UPDATE 90) · 멱등 2-pass delta 0 · FK 고아 0 · COMMIT 0.
- `apply_ymd='2026-06-01'` 고정(적용일 분기 금지=이중계상).
- PK=시퀀스(comp_price_id) → ON CONFLICT 불가, **NOT EXISTS 자연키 가드** 사용.
- 단가 전건 가격표 verbatim · search-before-mint(신규 siz/mat/comp/frm 0).
- 검증은 `dbm-validator` R1~R6 (자체승인 금지).
