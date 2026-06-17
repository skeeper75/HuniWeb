# 별색 dedup (U5') — 실행본 manifest (round-23)

> 작성 2026-06-17 · `dbm-load-builder`. arbiter 정립 = `balsaek-dedup-design.md`(U5'-1~3).
> 형제 색 별색 comp(9) → 정본 **COMP_PRINT_SPOT_WHITE_S1**(530행·5색×2면) 흡수.
> 그룹핑 모델(삭제 아닌 use_yn=N·단가행 보존). **DB 미적재 — 롤백전용 DRY-RUN GO 까지·실 COMMIT 인간 승인.**

## 1. 단위·영향행수 (PASS1 실측·FK 위상순)

| 단위 | 파일 | 테이블 | 조치 | 행수 |
|------|------|--------|------|:--:|
| **U5'-1** 배선 제거 | `U5p_1_unwire_siblings.sql` | t_prc_formula_components | 8색 형제 PRF_DGP_A 배선 DELETE(8) + WHITE_S2 29공식 배선 DELETE(29) | **DELETE 37** |
| **U5'-2** 논리삭제 | `U5p_2_logical_delete.sql` | t_prc_price_components | 형제 9 comp use_yn='N'(단가행 보존) | **UPDATE 9** |
| **U5'-3** 명명 보정 | `U5p_3_rename_master.sql` | t_prc_price_components | WHITE_S1 comp_nm "별색인쇄 출력비"→"별색인쇄비" | **UPDATE 1** |
| (단가행) | — | t_prc_component_prices | 형제 단가행 477 보존(이설/삭제/INSERT 0) | **0** |

**합계: DELETE 37 · UPDATE 10 · 단가행 재적재 0.**

순서: **U5'-1(배선 제거) → U5'-2(use_yn=N)** = use_yn=N comp 의 잔존 배선 0(dangling 방지). U5'-3 독립.

## 2. 흡수 매핑 (정본 = 부분집합 관계·라이브 실측)

| 형제 comp | 색 proc_cd | 면 | 정본 WHITE_S1 대응 | 대조 |
|-----------|:--:|:--:|------|:--:|
| WHITE_S2 | PROC_000008 | 양면 POPT_000002 | proc008+POPT_000002 | match 53·diff 0 |
| CLEAR_S1/S2 | PROC_000009 | 단/양면 | proc009 × 2면 | match 53·diff 0 |
| GOLD_S1/S2 | PROC_000011 | 단/양면 | proc011 × 2면 | match 53·diff 0 |
| PINK_S1/S2 | PROC_000010 | 단/양면 | proc010 × 2면 | match 53·diff 0 |
| SILVER_S1/S2 | PROC_000012 | 단/양면 | proc012 × 2면 | match 53·diff 0 |

정본 WHITE_S1 = 5색 × 2면(print_opt_cd) × 53구간 = 530행. 형제 9 = 정본 부분집합 → **재적재 0·가격 불변**.

## 3. 스코프 정정 (설계 ↔ 라이브·1건)

설계 U5'-2 = "PRF_DGP_A 의 형제 9 배선 제거". 실측:
- **8색 형제** = PRF_DGP_A 에만 배선 → 설계대로 PRF_DGP_A 제거.
- **WHITE_S2** = PRF_DGP_A + 포스터 28공식 = **29 배선**. use_yn=N 후 28 dangling 방지 위해 **29공식 전부 제거**.
- WHITE_S1 이 29공식 전부에 동반 배선(실측) → 양면 화이트(proc008+POPT_000002)·가격 보존(위험 0).

## 4. 백업 / undo

`apply.sh` 가 실행 전 `backup_<ts>/` 에 2 TSV:
- `pre_components.tsv` — 별색 10 comp `comp_cd, comp_nm, use_yn`(U5'-2·U5'-3 undo: use_yn=N→Y·comp_nm 원복 "별색인쇄 출력비")
- `pre_formula_components.tsv` — 별색 배선 전건 66행 `frm_cd, comp_cd, disp_seq, addtn_yn`(U5'-1 undo: 제거 37 배선 재INSERT)

undo(실 COMMIT 후): 백업 TSV 로 ① 형제 use_yn='Y' 복원 ② WHITE_S1 comp_nm 원복 ③ 제거된 37 배선 재INSERT.
물리삭제 0(단가행·comp 행 전부 보존)이라 데이터 손실 없음 — 백업은 메타(use_yn·comp_nm·배선)만.

## 5. 실 COMMIT 절차 (인간 최종 승인 후)

```bash
bash _exec_balsaek/apply.sh            # 1) DRY-RUN 재확인(라이브 무변경)
# 2) dryrun-report.md GO + 인간 승인
bash _exec_balsaek/apply.sh --commit   # 3) ROLLBACK→COMMIT 치환·백업 자동 선행
# 4) 사후: 정본 530 무변경·형제 9 use_yn=N·PRF_DGP_A 별색=WHITE_S1 1개·색 단가 불변 확인
```
[HARD] `--commit` 은 인간 최종 승인 전제. 비밀값 `.env.local` RAILWAY_DB_* 만 사용(비노출).

## 6. 컨펌 (설계 §4 Q-B)

- Q-B1 정본 명명 = "별색인쇄비"(종류중립·적용). Q-B2 comp_cd SPOT_WHITE_S1 유지(FK 연쇄 회피·comp_nm 만 보정).
- Q-B3 형제 단가행 물리삭제 = 보존(논리삭제만). Q-B4 S1/S2 정본 1개(print_opt_cd 면축 흡수).
