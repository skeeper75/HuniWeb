# 미싱 dangling 배선 정리 (D1) — 롤백전용 라이브 DRY-RUN 리포트 (R1~R6)

> 실행 2026-06-17 · Railway `railway` read-only psql · `BEGIN … ROLLBACK`(COMMIT 0). 비밀값 비노출.
> 생성자(load-builder) 산출 — GO 판정은 dbm-validator(독립). 결함 = G-D2 W5 잔재(validator 별색 검증 중 발견·사용자 "이번 같이 정리" 승인).

---

## 0. 결함·해소 요지

W5(미싱 차원전환·정본 PERF_1L 통합·2L/3L use_yn=N) 때 레거시 배선 제거 누락 →
**비활성(use_yn='N') COMP_PP_PERF_2L·_3L 가 PRF_DGP_A·PRF_DGP_D 에 formula_components 배선 잔존(4건)**.
별색 dedup U5'-1 과 동류(비활성 comp dangling 배선 정리). 해소 = 4 배선 DELETE(comp/단가행 무변경).

## R1 — 영향행수 (PASS1)

```
D1 미싱 레거시 배선 제거   DELETE 4
  · PRF_DGP_A : COMP_PP_PERF_2L(disp20)·COMP_PP_PERF_3L(disp21)
  · PRF_DGP_D : COMP_PP_PERF_2L(disp11)·COMP_PP_PERF_3L(disp12)
```
합계 **DELETE 4**. comp/단가행 변경 0(배선만).

## R2 — 멱등 2-pass delta 0

동일 트랜잭션 내 D1 **2회** 적용 → **2nd pass DELETE 0**.
멱등키: `comp_cd IN (PERF_2L,PERF_3L) AND use_yn='N'` 배선만 매칭 → 재실행 시 행 부재.

## R3 — ★정본 PERF_1L 동반 배선으로 미싱 가격 보존 (가격 불변)

| 검증 | 결과 |
|------|------|
| 정본 PERF_1L use_yn | **Y**(활성) |
| 정본 PERF_1L 단가행 | **30** = 줄수 1/2/3 × 10구간(W5 가 2/3줄 dim_vals 흡수) |
| 정본 PERF_1L use_dims | `["proc_cd","min_qty","proc_grp:PROC_000030"]` |
| 정본 PERF_1L 배선(제거 후) | **PRF_DGP_A · PRF_DGP_D 둘 다 잔존** |

→ 2L/3L 배선 제거 후에도 **미싱 1/2/3줄 가격 경로 = 정본 PERF_1L 로 전건 보존**(dangling 제거 = 가격 손실 0).
PERF_2L/3L 단가행(10+10=20) = use_yn=N comp 에 **보존**(이 작업은 배선만 제거·단가행 무변경).
→ **BLOCKED 없음**(정본 미배선 공식 0·가격 손실 위험 0).

## R4 — dangling 0 / FK 고아 0 (제거 후)

```
dangling_after = 0    use_yn=N PERF comp 의 잔존 배선 0
orphan_comp    = 0    formula_components.comp_cd → price_components
orphan_frm     = 0    formula_components.frm_cd → price_formulas
```

## R5 — 엔진 정합

PRF_DGP_A·PRF_DGP_D 의 미싱 배선 = 정본 PERF_1L 1개로 정리(레거시 2L/3L 제거).
엔진: 미싱 N줄 선택 → PERF_1L 에서 (proc_cd=PROC_000086, dim_vals.줄수, min_qty) 매칭 → 단가.
use_yn=N comp(2L/3L) 는 엔진 use_yn 필터로 이미 제외됐으나, 배선까지 제거해 dangling 0(데이터 위생).

## R6 — COMMIT 0 (라이브 무변경)

전 DRY-RUN `BEGIN…ROLLBACK`. 다회 실행 후 라이브 재조회 — 사전상태 그대로:
```
live_dangling = 4          (제거 미적용)
live_perf2L3L_wiring = 4    (제거 미적용)
live_perf1L_wiring = 30     (무변경)
```
→ COMMIT 0·DB 무변경 입증. `apply.sh` 로더 정상(백업 1 TSV[perf 배선 34행·PERF_1L 포함 undo 컨텍스트] + dryrun + rollback)·비밀값 비노출(leak 0).

---

## 종합

| 게이트 | 결과 |
|--------|------|
| 단일 트랜잭션·배선만 DELETE | ✅ DELETE 4 |
| 멱등 2-pass delta 0 | ✅ |
| 정본 가격 보존(PERF_1L 동반 배선) | ✅ PRF_DGP_A·PRF_DGP_D 잔존·30 단가행·BLOCKED 0 |
| dangling 0 · FK 고아 0 | ✅ |
| COMMIT 0 | ✅ 라이브 무변경 |

**GO (롤백전용 DRY-RUN).** 실 COMMIT 은 `apply.sh --commit` + 인간 최종 승인(이번 범위 아님).
