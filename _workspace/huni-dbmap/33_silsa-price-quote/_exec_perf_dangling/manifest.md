# 미싱 dangling 배선 정리 (D1) — 실행본 manifest (round-23)

> 작성 2026-06-17 · `dbm-load-builder`. 결함 = G-D2 W5 잔재(미싱 차원전환 시 레거시 배선 제거 누락).
> validator 가 별색 dedup 검증 중 발견·사용자 "이번 같이 정리" 승인. **DB 미적재 — 롤백전용 DRY-RUN GO·실 COMMIT 인간 승인.**

## 1. 결함 (라이브 실측)

비활성(use_yn='N') `COMP_PP_PERF_2L`·`COMP_PP_PERF_3L` 가 공식에 formula_components 배선 잔존:

| frm_cd | comp_cd | disp_seq | use_yn(comp) | 상태 |
|--------|---------|:--:|:--:|------|
| PRF_DGP_A | COMP_PP_PERF_2L | 20 | N | dangling |
| PRF_DGP_A | COMP_PP_PERF_3L | 21 | N | dangling |
| PRF_DGP_D | COMP_PP_PERF_2L | 11 | N | dangling |
| PRF_DGP_D | COMP_PP_PERF_3L | 12 | N | dangling |

## 2. 단위·영향행수 (PASS1 실측)

| 단위 | 파일 | 테이블 | 조치 | 행수 |
|------|------|--------|------|:--:|
| **D1** dangling 제거 | `D1_unwire_perf_legacy.sql` | t_prc_formula_components | use_yn=N PERF_2L/3L 배선 DELETE | **DELETE 4** |
| (comp/단가행) | — | — | 무변경(배선만) | **0** |

## 3. 가격 보존 (정본 PERF_1L 동반 배선)

- 정본 `COMP_PP_PERF_1L`(use_yn='Y') = 줄수 1/2/3 × 10구간 = **30 단가행**(W5 가 2/3줄 dim_vals 흡수).
- PERF_1L 이 **PRF_DGP_A(disp19)·PRF_DGP_D(disp10)** 둘 다 배선(실측) → 2L/3L 배선 제거해도 미싱 1/2/3줄 가격 경로 전건 보존.
- PERF_2L/3L 단가행(10+10=20) = use_yn=N comp 에 보존(배선만 제거).
- **BLOCKED 없음**(정본 미배선 공식 0·가격 손실 위험 0).

## 4. 백업 / undo

`apply.sh` 가 실행 전 `backup_<ts>/pre_perf_formula_components.tsv` 에 PERF 배선 전건(34행·PERF_1L 포함) 저장.
undo(실 COMMIT 후): 백업 TSV 에서 제거된 4 배선(`PRF_DGP_A/D × PERF_2L/3L`) 재INSERT. 물리삭제는 배선 4행만(comp·단가행 무손상)이라 손실 0.

## 5. 실 COMMIT 절차 (인간 최종 승인 후)

```bash
bash _exec_perf_dangling/apply.sh            # 1) DRY-RUN 재확인(라이브 무변경)
# 2) dryrun-report.md GO + 인간 승인
bash _exec_perf_dangling/apply.sh --commit   # 3) ROLLBACK→COMMIT 치환·백업 자동 선행
# 4) 사후: dangling 0·PERF_1L 양 공식 배선 잔존·미싱 가격 불변 확인
```
[HARD] `--commit` 은 인간 최종 승인 전제. 비밀값 `.env.local` RAILWAY_DB_* 만 사용(비노출).
