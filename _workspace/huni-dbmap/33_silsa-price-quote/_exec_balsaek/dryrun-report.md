# 별색 dedup (U5') — 롤백전용 라이브 DRY-RUN 리포트 (R1~R6)

> 실행 2026-06-17 · Railway `railway` read-only psql · `BEGIN … ROLLBACK`(COMMIT 0). 비밀값 비노출.
> 생성자(load-builder) 산출 — GO 판정은 dbm-validator(독립). 그룹핑 모델(삭제 아닌 use_yn=N·단가행 보존).

---

## R1 — 영향행수 (PASS1·apply.sql 순서)

```
U5p-1 형제 배선 제거   DELETE 8   (8색 형제: CLEAR/GOLD/PINK/SILVER × S1/S2 — PRF_DGP_A 에서만)
                       DELETE 29  (WHITE_S2 — PRF_DGP_A + 포스터 28공식 = 29)
U5p-2 형제 use_yn=N    UPDATE 9   (9 형제 comp 논리삭제·단가행 보존)
U5p-3 정본 명명 보정    UPDATE 1   (WHITE_S1 comp_nm "별색인쇄 출력비"→"별색인쇄비")
```
합계 **DELETE 37 · UPDATE 10**. 단가행 DELETE/INSERT/이설 **0**.

## R2 — 멱등 2-pass delta 0

동일 트랜잭션 내 U5p-1~3 **2회** 적용 → **2nd pass 전건 0**:
```
2nd: DELETE 0 · DELETE 0 · UPDATE 0 · UPDATE 0
```
멱등키: U5p-1=DELETE 대상 행만 매칭(재실행 시 행 부재) · U5p-2=use_yn<>'N' 행만 · U5p-3=comp_nm<>'별색인쇄비' 행만.

## R3 — ★단가행 재적재 0 / 가격 불변 입증

정본 WHITE_S1 = 5색(PROC_000008~012) × 2면(POPT_000001/002) × 53구간 = **530행 전건 보유**. 형제는 부분집합.
형제 4색 S1(단면) vs 정본 WHITE_S1 해당 proc + POPT_000001 대조(라이브 실측·적용 전):

| 색 | proc_cd | 형제행 | match | diff |
|----|---------|:--:|:--:|:--:|
| CLEAR | PROC_000009 | 53 | **53** | **0** |
| GOLD | PROC_000011 | 53 | **53** | **0** |
| PINK | PROC_000010 | 53 | **53** | **0** |
| SILVER | PROC_000012 | 53 | **53** | **0** |

WHITE_S2(양면 화이트)=PROC_000008+POPT_000002, 정본 대조 match 53·diff 0.
→ 형제 9 단가행 = 정본 전건 동일값 실재. **흡수=배선 제거+use_yn=N만·단가행 0 변경.**
형제 단가행 477(8색×53 + WHITE_S2 53) **전건 보존**(물리삭제 0·그룹핑 모델 P-1 준수).

## R4 — FK 고아 0 / dangling 배선 0

```
orphan_comp     = 0   formula_components.comp_cd → price_components
orphan_frm      = 0   formula_components.frm_cd → price_formulas
dangling_wiring = 0   use_yn=N comp 가 formula_components 에 잔존 (★WHITE_S2 29공식 전부 배선 제거로 0 보장)
```

## R5 — 정본 무변경 / 배선 단일화 / 엔진 정합

```
master_rows       = 530        WHITE_S1 단가행 무변경
master_use_yn     = Y          정본 활성 유지
master_comp_nm    = 별색인쇄비   (U5p-3 보정 적용)
master_wiring_cnt = 29         PRF_DGP_A + 포스터 28 배선 무변경
dgpa_spot_remaining = COMP_PRINT_SPOT_WHITE_S1   (PRF_DGP_A 별색 = 정본 1개로 축소)
```
엔진: 별색 선택(proc_cd 색 + print_opt_cd 면) → 정본 WHITE_S1 1 comp 에서 (proc_cd, print_opt_cd, min_qty) 매칭.
5색 전부 정본 1 comp 조회. 형제 use_yn=N → 엔진 제외 → 동시매칭 0(정본만 활성).
WHITE_S1 이 WHITE_S2 배선 29공식 전부에 동반 배선(실측) → WHITE_S2 제거해도 양면 화이트(proc008+POPT_000002) 경로 보존.

## R6 — COMMIT 0 (라이브 무변경)

전 DRY-RUN `BEGIN…ROLLBACK`. 다회 실행 후 라이브 재조회 — 사전상태 그대로:
```
형제 9 use_yn = Y (변경 안 됨)
정본 comp_nm = 별색인쇄 출력비 (rename 미적용)
PRF_DGP_A 별색 배선 = 10 (제거 미적용)
WHITE_S2 배선 = 29 (제거 미적용)
```
→ COMMIT 0·DB 무변경 입증. `apply.sh` 로더 정상(백업 2 TSV[components 10·formula_components 66] + dryrun + rollback)·비밀값 비노출.

---

## 종합

| 게이트 | 결과 |
|--------|------|
| 단일 트랜잭션·순서(배선제거→use_yn=N→명명) | ✅ dangling 방지 순서 |
| 멱등 2-pass delta 0 | ✅ 전건 0 |
| 단가행 재적재 0 / 가격 불변 | ✅ 4색+WHITE_S2 전건 match·diff 0·정본 530 무변경·형제 477 보존 |
| FK 고아 0 · dangling 0 | ✅ |
| 정본 단일화 | ✅ PRF_DGP_A 별색=WHITE_S1 1개·정본 명명 보정 |
| COMMIT 0 | ✅ 라이브 무변경 |

**GO (롤백전용 DRY-RUN).** 실 COMMIT 은 `apply.sh --commit` + 인간 최종 승인(이번 범위 아님).

## 설계 대비 스코프 정정 (1건·라이브 실측)

- 설계 U5'-2 = "PRF_DGP_A 의 형제 9 comp 배선 제거". 실측: **WHITE_S2 는 PRF_DGP_A 외 포스터 28공식에도 배선**(총 29).
  WHITE_S2 use_yn=N 후 28 포스터 배선이 dangling 되므로, 설계 §0.3 "WHITE_S2 흡수·정본 단일화" 의도에 맞춰
  **U5p-1 에서 WHITE_S2 는 29공식 전부 제거**(8색 형제는 설계대로 PRF_DGP_A 만). WHITE_S1 이 29공식 전부 동반 배선
  → 양면 화이트 경로·가격 보존(0 위험 실측). dbm-validator 재검 권고.
