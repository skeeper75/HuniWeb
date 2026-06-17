# _exec_064 — 064 소량자유형 가격 적재 실행본 (round-23 항목 7)

사용자 결정(B01 col1 규격가 사이즈무관 동일 적용·우선 등록 후 추후 변경) → 멱등 SQL + 롤백전용 DRY-RUN. **설계+DRY-RUN GO 까지 · 실 COMMIT 인간 승인.**
(`_exec_bankal2`(058~061)에서 BLOCKED 였던 064 — 사용자 결정으로 잠정 등록)

## 파일
| 파일 | 내용 |
|------|------|
| `S064a_prices.sql` | 064 소형 7siz × 5소재 × 36mq 단가행 1260 (B01 col1 SIZ_059 verbatim 복사·INSERT…SELECT·잠정 note) |
| `S064b_binding.sql` | 064 → PRF_STK_FIXED 바인딩 1 |
| `apply.sql` | 단일 트랜잭션·`ROLLBACK` 기본 |
| `apply.sh` | 백업 2 CSV → DRY-RUN(기본) / `--commit`(인간 승인 후) |
| `manifest.md`·`dryrun-report.md` | 매니페스트·R1~R6 |

## 실행
```bash
bash apply.sh dryrun     # 기본·라이브 무변경·COMMIT 0
bash apply.sh --commit   # 실 COMMIT (인간 최종 승인 후에만)
```

## 핵심
- 영향행 **1261** (INSERT만·단가 1260+바인딩 1) · 멱등 2-pass delta 0 · FK 고아 0 · COMMIT 0.
- 단가 = **B01 col1(SIZ_059·124x186) verbatim 복사**(INSERT…SELECT·하드코딩 0·소재별/수량밴드별 그대로) → 7 siz 사이즈무관 동일가.
- 골든: 064 유포 mq1 = 6000 · 무광 mq1 = 7000 · 7siz distinct=1 · B01 vs 064 mismatch 0.
- **★잠정**: 전 1260행 note `[잠정] 소형반칼 B01 규격가… 추후 변경` — 실무진 식별·추후 실측 단가 교체.
- 소재 5종(153/084/242/155/156) · siz 채번 0(7종 실존) · 동시매칭 0.
- 검증은 `dbm-validator` R1~R6 (자체승인 금지).

## 잔여
064는 사용자 결정으로 잠정 등록(BLOCKED 해소). ★단가는 잠정(064 실측 단가 아닌 B01 규격가 차용)·실측 단가 수령 시 note 식별로 교체. GAP 0.
