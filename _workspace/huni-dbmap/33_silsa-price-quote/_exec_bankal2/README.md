# _exec_bankal2 — 반칼 058~061 가능분 가격 연결 실행본 (round-23 항목 7·BK6)

arbiter `../bankal-058-064-deepcheck.md`(BK6) + 사용자 컨펌(A5=124x186 동일가 GO·A4 반칼 전용 분리 GO) → 멱등 SQL + 롤백전용 DRY-RUN. **설계+DRY-RUN GO 까지 · 실 COMMIT 인간 승인.**
(`_exec_bankal`(062/063) 후속 — 058~061 반칼원형/정사각/직사각/띠지 가격 연결)

## 파일
| 파일 | 내용 |
|------|------|
| `gen_load_sql.py` | xlsx verbatim → A5/A4 단가행 360 재현 생성기(byte-identical) |
| `BK6a_codegen.sql` | A4 반칼 전용 siz 채번 SIZ_000520 (search-before-mint·B02 SIZ_172와 분리) |
| `BK6b_price_a5.sql` | A5(SIZ_170) 단가행 180 (5소재×36mq·col1=124x186 동일가) |
| `BK6c_price_a4.sql` | A4 반칼(SIZ_520) 단가행 180 (5소재×36mq·col2 5000/6000) |
| `BK6d_fix_product_sizes.sql` | 058~061 A4 등록 SIZ_172→SIZ_520 교정 (오청구 회피·완칼 무접촉) |
| `BK6e_bindings.sql` | 058~061 → PRF_STK_FIXED 바인딩 4 |
| `apply.sql` | 단일 트랜잭션·FK 위상·`ROLLBACK` 기본 |
| `apply.sh` | 백업 4 CSV → DRY-RUN(기본) / `--commit`(인간 승인 후) |
| `manifest.md`·`dryrun-report.md`·`blocked-and-gaps.md` | 매니페스트·R1~R6·잔여 차단 |

## 실행
```bash
bash apply.sh dryrun     # 기본·라이브 무변경·COMMIT 0
bash apply.sh --commit   # 실 COMMIT (인간 최종 승인 후에만)
```

## 핵심
- 영향행 **369** (INSERT 365 + UPDATE 4) · 멱등 2-pass delta 0 · FK 고아 0 · COMMIT 0.
- **★돈 크리티컬 오청구 회피**: A4 반칼 = SIZ_000520 신규(col2 5000/6000) · B02 낱장 SIZ_172(4000) 무접촉 · 완칼 055/056 무접촉.
- 골든: 058 A5 유포 mq1 = 6000(=124x186 동일가·mismatch 0) · A4 반칼 = 5000(≠낱장 4000).
- 소재 5종(153/084/242/155/156)만 — 058~061 라이브 등록분(투명/홀로 미등록).
- 채번 SIZ_000520 (max=SIZ_000519 → 무충돌·search-before-mint).
- 검증은 `dbm-validator` R1~R6 (자체승인 금지).

## 잔여 BLOCKED (blocked-and-gaps.md)
064 소량자유형(소형반칼 7사이즈·가격표 6블록에 단가 부재·Q-DC-3). 058~061 A3=마스터 미등록 불요.
