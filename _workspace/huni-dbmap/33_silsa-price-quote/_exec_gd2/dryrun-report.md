# G-D2 후가공 배선 — 롤백전용 라이브 DRY-RUN 리포트 (R1~R6)

> 실행 2026-06-17 · Railway `railway` read-only psql · `BEGIN … ROLLBACK` (COMMIT 0).
> 비밀값 비노출. 생성자(load-builder) 산출 — GO 판정은 dbm-validator(독립).
> 입력 = `gd2-wiring-design.md` + pricing.py 엔진 동작(addtn_yn 미참조·_row_matches·combos>1 ERR_AMBIGUOUS).

---

## R1 — 영향행수 (PASS1·apply.sql 순서)

```
BEGIN
W1 INSERT 0 28      소재별 공식 28 (PRF_POSTER_<MAT>)
W2 INSERT 0 28      본체 배선 disp_seq=1
W3 DELETE 28        FIXED 바인딩 제거
   INSERT 0 28      유형별 바인딩 신규 (apply_bgn_ymd='2026-06-01')
W4 INSERT 0 196     후가공 배선 7×28 (오시·귀돌이2·가변2·별색2)
W5 UPDATE 1         PERF use_dims opt→proc 모델
   UPDATE 1         PERF prc_typ .02→.01
   UPDATE 30        PERF 단가행 opt_cd→proc_cd=PROC_000086 + dim_vals.줄수
   UPDATE 2         PERF_2L/3L use_yn=N
W6 INSERT 0 28      미싱 배선 disp_seq=9
ROLLBACK
COMMITTED = 0
```
- 합계 INSERT 308 · DELETE 28 · UPDATE 34. 단가행 재적재 0(전부 배선/차원전환·값 불변).
- POST-STATE: 공식 29(28신규+FIXED 보존) · 배선 252(본체28+후가공196+미싱28) · 바인딩 28→유형별 · FIXED 잔여 0 · PERF_1L=.01·proc_cd=PROC_000086 30행·opt 잔여 0 · 2L/3L use_yn=N 2.

## R2 — 멱등 2-pass (PASS B 전건 0)

```
PASS A: INSERT 28·28·28·196·28 / UPDATE 1·1·30·2 / DELETE 28
PASS B: INSERT 0·0·0·0·0      / UPDATE 0·0·0·0   / DELETE 0
```
- 2회 적용 시 2nd pass 전 DML delta = **0**. 멱등 입증(NOT EXISTS 가드·전환 전 상태 매칭 UPDATE).

## R3 — FK 고아 0

```
orphan_fc_frm   = 0   (formula_components.frm_cd → price_formulas)
orphan_fc_comp  = 0   (formula_components.comp_cd → price_components)
orphan_bind_frm = 0   (product_price_formulas.frm_cd → price_formulas)
```
- comp_cd 8종·prd_cd 28·proc_cd PROC_000086 전부 라이브 선존재(검증). component_prices.proc_cd FK(fk_comp_prices_proc → t_proc_processes) 충족.

## R4 — ★동시매칭 0 (엔진 ERR_AMBIGUOUS 미발생 실증)

엔진(`pricing.py _row_matches`/combos): 행 차원 NULL=와일드카드·combos>1 → `ERR_AMBIGUOUS`(합산 거부).
selections={siz_cd=SIZ_000321} (사이즈만, 후가공 미선택) 으로 PRF_POSTER_ARTPRINT 배선 comp 매칭:

```
comp_matched_for_siz_only : COMP_POSTER_ARTPRINT_PHOTO = 1행
distinct_comps_matched_siz_only = 1   ← 본체 1개만 매칭 (후가공 0)
```
- **동시매칭 0**: 본체(use_dims siz_cd)와 후가공(use_dims proc_cd+dim_vals)은 차원축이 달라, 사이즈만 준 selection에 후가공 comp는 매칭 안 됨(proc_cd 요구). 각 comp combos=1 → ERR_AMBIGUOUS 미발생.
- ★U6 공식 분리(W1)가 핵심: 단일 공식에 27 소재 comp 배선 시 siz만 맞으면 27 동시매칭이나, 소재별 분리로 본체 1개 → combos=1.

## R5 — 골든 재현 + 미선택 제외

| 케이스 | selections | 산출 | 손계산 | 일치 |
|--------|-----------|------|--------|:--:|
| **골든(오시 2줄)** | siz=SIZ_000321(600×1800), proc_cd=PROC_000090, {줄수:2}, qty=1 | 본체 21,600 + 오시 6,000 = **27,600** | 21,600+6,000=27,600 | ✅ |
| **미선택 제외** | siz=SIZ_000321 만 | 본체만 **21,600**(후가공 row=None 제외·무경고) | 21,600 | ✅ |
| **미싱 3줄(W5 후)** | proc_cd=PROC_000086, {줄수:3}, qty=1 | PERF 7,000 | OPV-000009(3줄) 7,000 값동일 | ✅ |

- 후가공 미선택 시 자연 제외(`match_component` row=None) 입증. addtn_yn 무관(엔진 미참조).
- W5 차원전환 후 미싱이 proc_cd 모델로 정상 매칭(값 불변 이설 확인).

## R6 — COMMIT 0 / 라이브 무변경

- 전 DRY-RUN `BEGIN…ROLLBACK`. 다회 실행 후 라이브 재측정:
```
live_PRF_POSTER = 1 (신규 0 누락)   live_perf1L_prctyp = PRICE_TYPE.02 (미전환)
live_perf1L_opt_rows = 30 (미이설)  live_fixed_bindings = 28 (미교체)
```
→ 라이브 사전상태 그대로. **COMMIT 0·DB 무변경 입증.**

---

## 종합

- R1~R6 전건 통과(생성자 측정). **동시매칭 0·골든 27,600 재현·미선택 제외·2-pass delta 0·FK고아 0·COMMIT 0.**
- BLOCKED: 별색 dedup(grouping U5' 별 트랙·W4 배선은 정상 동작). 설계 B-1(미싱 배선)은 W5로 해소.
- 실 COMMIT은 인간 승인(`apply.sh --commit`). GO 판정은 dbm-validator 독립 게이트.
