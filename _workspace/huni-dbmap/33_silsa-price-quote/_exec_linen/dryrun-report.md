# 린넨 마감가공 옵션 등록 — 롤백전용 라이브 DRY-RUN 리포트 (R1~R6)

> 실행 2026-06-17 · Railway `railway` read-only psql · `BEGIN … ROLLBACK`(COMMIT 0). 비밀값 비노출.
> 생성자(load-builder) 산출 — GO 판정은 dbm-validator(독립). 단가 verbatim(0/800/1000/2000/2000).

---

## R1 — 영향행수 (PASS1·apply.sql 순서)

```
L1  INSERT 1   말아박기+면끈 OPV_000424 신규 (오버로크+리본끈 OPV-000024 기존→skip)
L1b INSERT 2   복합 2 option_items (OPT_REF_DIM.04→PROC_000080)
L2  INSERT 1   COMP_POSTEROPT_LINEN_FINISH (.01·use_dims ["opt_cd"])
L3  INSERT 5   단가행 (opt_cd별 0/800/1000/2000/2000)
L4  INSERT 1   PRF_POSTER_LINEN ← FINISH disp_seq10 addtn_yn=Y
L5  UPDATE 0+0 dflt 오버로크=Y·복합/유료=N (라이브 이미 정합)
```
합계 **INSERT 10 · UPDATE 0**. mint: 옵션 1·comp 1·단가행 5·item 2·배선 1 / proc·자재 신규 0(search-before-mint).

## R2 — 멱등 2-pass delta 0

동일 트랜잭션 내 L1~L5 **2회** 적용 → **2nd pass 전건 0**:
```
1st: INSERT 1·2·1·5·1 / UPDATE 0·0
2nd: INSERT 0·0·0·0·0 / UPDATE 0·0      ← delta 0
```
멱등키: L1/L1b/L2/L4 = PK NOT EXISTS · L3 = `(comp_cd,apply_ymd,opt_cd)` 논리키 NOT EXISTS(component_prices 자연키 unique 부재·PK 시퀀스) · L5 = 조건부 UPDATE(목표값 다른 행만).

## R3 — FK 고아 0

```
orphan_items   = 0   option_items.opt_cd → options (복합 2)
orphan_prices  = 0   component_prices.comp_cd → price_components
orphan_wiring  = 0   formula_components → price_formulas & price_components
orphan_procref = 0   option_items(OPT_REF_DIM.04).ref_key1 → product_processes (트리거 fn_chk_opt_item_ref 정합·PROC_000080 실재)
```

## R4 — 동시매칭 0 (엔진 opt_cd 단일 매칭)

```
distinct_opt = 5 · total_rows = 5  → opt_cd별 1행(중복 0)
```
COMP_POSTEROPT_LINEN_FINISH use_dims=`["opt_cd"]` → 사용자가 선택한 1 opt_cd 에 단가행 1건만 매칭(combos=1·ERR_AMBIGUOUS 없음). 본체(use_dims siz_width/height)와 차원축 직교 → 동시매칭 0.

## R5 — 골든 재현 (본체 면적가 + 마감옵션 가산)

마감옵션 단가 verbatim(opt_cd 매칭):

| 옵션 | opt_cd | 단가 |
|------|--------|:--:|
| 오버로크 | OPV_000025 | **0** |
| 오버로크+리본끈 | OPV-000024 | **800** |
| 말아박기 | OPV_000026 | **1,000** |
| 말아박기+면끈 | OPV_000424 | **2,000** |
| 봉미싱(7cm) | OPV_000027 | **2,000** |

**결합 골든** — 린넨 본체 600×1800 면적단가 = **32,400**(라이브 COMP_POSTER_LINEN_FABRIC siz_width=600/siz_height=1800):

| 선택 | 합산 | 결과 |
|------|------|:--:|
| 오버로크(무료 기본) | 32,400 + 0 | **32,400** |
| 오버로크+리본끈 | 32,400 + 800 | **33,200** |
| 말아박기 | 32,400 + 1,000 | **33,400** |
| 말아박기+면끈 | 32,400 + 2,000 | **34,400** |

엔진: 본체(면적 매칭) + 선택 마감옵션(opt_cd 매칭) 합산(addtn_yn 무참조). 미선택/오버로크 = +0(가산 없음).

## R6 — COMMIT 0 (라이브 무변경)

전 DRY-RUN `BEGIN…ROLLBACK`. 다회 실행 후 라이브 재조회 — 사전상태 그대로:
```
OPV_000424 존재 = 0            (L1 미반영)
COMP_POSTEROPT_LINEN_FINISH = 0 (L2 미반영)
finishing 단가행 = 0           (L3 미반영)
PRF_POSTER_LINEN 배선 = 9      (L4 미반영·disp10 없음)
```
→ COMMIT 0·DB 무변경 입증. `apply.sh` 로더 end-to-end 정상(백업 5 CSV + dryrun + rollback).

---

## 종합

| 게이트 | 결과 |
|--------|------|
| 단일 트랜잭션·FK 위상 | ✅ L1→L1b→L2→L3→L4→L5·트리거 통과 |
| 멱등 2-pass delta 0 | ✅ 전건 0 |
| FK 고아 0 | ✅ 4종 0(트리거 정합 포함) |
| 동시매칭 0 | ✅ opt_cd 5 distinct·1행 매칭 |
| 골든(결합) | ✅ 본체 32,400 + 가산(0/800/1000/2000/2000) 정확 |
| 단가 verbatim | ✅ 0/800/1000/2000/2000 |
| COMMIT 0 | ✅ 라이브 무변경 |
| search-before-mint | ✅ OPV-000024 재사용·proc/자재 mint 0·신규 최소(옵션1·comp1·단가5·item2·배선1) |

**GO (롤백전용 DRY-RUN).** 실 COMMIT 은 `apply.sh --commit` + 인간 최종 승인(이번 범위 아님).
