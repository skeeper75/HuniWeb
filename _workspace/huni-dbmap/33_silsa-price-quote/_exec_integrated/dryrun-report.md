# 통합 실행본 DRY-RUN 리포트 — 신안 + G-D2 (X-1 단일화)

> 작성 2026-06-17 · `dbm-load-builder` · 롤백전용 라이브 DRY-RUN(BEGIN…ROLLBACK). **COMMIT 0**.
> 라이브 = Railway `railway` read-only psql. 비밀값 비노출. 단가행 재적재 0(값 불변).

## 0. X-1 단일화 요지

validator 적발: 신안 **V2**(13 본체 comp `use_dims`→`[siz_width,siz_height]`)와 G-D2 **W2**(본체 배선)가
같은 13 면적 comp를 건드림 → 따로 COMMIT 시 엔진 **selection 키 비결정**(area body가 `siz_cd`인지
`siz_width/height`인지). 본 통합은 use_dims 전환(V2)·면적단가(V1/V1b)·배선(W1~W6)을 **단일 트랜잭션**에
묶어 신안을 G-D2 상위 차원으로 단일화. 면적 13(siz_width/height)·고정 15(siz_cd)는 비충돌 분리(검증).

## 1. 통합 영향행수 (PASS 1·단위별 실측)

| 순 | 단위 | 테이블 | 조치 | 행수 |
|----|------|--------|------|------|
| 1 | V1 면적단가 | t_prc_component_prices | INSERT (가격표 verbatim, siz_width/height) | **INSERT 667** |
| 2 | V1b siz_cd 전환 | t_prc_component_prices | UPDATE (라이브 매트릭스 siz_cd→width/height·값불변) | **UPDATE 17** |
| 3 | V2 use_dims 전환 | t_prc_price_components | UPDATE (면적13 `[siz_cd]`→`[siz_width,siz_height]`) | **UPDATE 13** |
| 4 | W1 공식분리 | t_prc_price_formulas | INSERT (28 PRF_POSTER_*) | **INSERT 28** |
| 5 | W2 본체배선 | t_prc_formula_components | INSERT (28 disp1=본체) | **INSERT 28** |
| 6 | W3 바인딩교체 | t_prd_product_price_formulas | DELETE(FIXED)+INSERT(유형별) | **DELETE 28 / INSERT 28** |
| 7 | W4 후가공배선 | t_prc_formula_components | INSERT (7후가공×28공식) | **INSERT 196** |
| 8 | W5 미싱 차원전환 | price_components·component_prices | UPDATE×4 (use_dims·prc_typ·단가행30·2L3L use_yn) | **UPDATE 1+1+30+2** |
| 9 | W6 미싱배선 | t_prc_formula_components | INSERT (PERF_1L→28공식) | **INSERT 28** |
| 10 | V3 nonspec | t_prd_products | UPDATE (13상품 incr) | **UPDATE 13** |

**합산:** INSERT 667+28+28+28+196+28 = **975** · UPDATE 17+13+34+13 = **77** · DELETE **28**.
좌표 siz 채번 0(U1 폐기) · U2(면적단가)=V1로 대체 · U5'(별색 dedup) 별 트랙 제외(W4 배선만 포함).

## 2. 멱등 2-pass delta 0

단일 트랜잭션 내 전 단위를 **2회** 적용 → **PASS-B 전건 0**:
```
PASS-A: INSERT 667·UPDATE 17·UPDATE 13·INSERT 28·INSERT 28·DELETE 28·INSERT 28·INSERT 196·UPDATE(1,1,30,2)·INSERT 28·UPDATE×13
PASS-B: INSERT 0 ·UPDATE 0 ·UPDATE 0 ·INSERT 0 ·INSERT 0 ·DELETE 0 ·INSERT 0 ·INSERT 0  ·UPDATE 0       ·INSERT 0 ·UPDATE 0
```
멱등키: V1=자연키 NOT EXISTS · V1b/V2/V5/V3=조건부 UPDATE WHERE(전환 전 상태만) · W1/W2/W4/W6=`NOT EXISTS` · W3=DELETE 후 PK NOT EXISTS INSERT.

## 3. FK 고아 0

```
FK_fc_frm_orphan   = 0   (formula_components.frm_cd → price_formulas)
FK_fc_comp_orphan  = 0   (formula_components.comp_cd → price_components)
FK_ppf_frm_orphan  = 0   (product_price_formulas.frm_cd → price_formulas)
```

## 4. 동시매칭 0 (ERR_AMBIGUOUS 방지)

```
multi_body_formulas    = 0   각 PRF_POSTER_* 공식 disp_seq=1 본체 comp 정확히 1개
area_leftover_sizcd    = 0   면적13 comp 전환 후 siz_cd 잔여 0 (siz_cd/siz_width 이중 매칭 차단)
area_dup_wh            = 0   comp별 (siz_width,siz_height) 중복 0 (매트릭스 룩업 결정적)
body_rows_matching_600x1800 = 1   단일 (w,h) 주문에 본체 1행만 매칭 (combos=1)
```
신안 단일화로 면적 body가 `siz_width/height` 단일 모델 → siz_cd 잔여행과의 combos>1 위험 제거.

## 5. 골든 재현 — 면적 매트릭스 룩업 + 후가공 가산 결합

입력: **PRD_000118 아트프린트포스터 · 가로 600 세로 1800 · 오시 2줄 · 수량 1**

```
(a) 바인딩  PRD_000118 → PRF_POSTER_ARTPRINT
(b) 배선    disp1 COMP_POSTER_ARTPRINT_PHOTO(본체) + disp2~9 후가공/미싱
(c) 본체    siz_width/height TIER(이하 상한) 600×1800 매칭 → 21,600   (시트 verbatim)
(d) 후가공  COMP_PP_CREASE_1L dim_vals{줄수:2} → 6,000
─────────────────────────────────────────────────────────────
   엔진 합산(addtn 무관·매칭 comp Σ) = 21,600 + 6,000 = 27,600
```

**off-grid ceiling 재현:** 가로 650 세로 650(격자 부재) → 다음 큰 구간 **800×800 = 20,000**
(엔진 TIER 이하 상한 = ceiling 내장. A안의 런타임 ceiling 불요).

## 6. COMMIT 0 (라이브 무변경 입증)

전 DRY-RUN 후 라이브 재조회 — 사전상태 그대로:
```
live_prf_poster        = 1        (FIXED만, W1 신규 28 미반영)
live_rows_with_width   = 0        (V1/V1b 미반영)
live_artprint_use_dims = ["siz_cd"]  (V2 미반영)
live_fixed_bindings    = 28       (W3 미반영)
```
→ 모든 DRY-RUN이 ROLLBACK 종료. 라이브 0 변경.

## 7. 종합 판정

| 게이트 | 결과 |
|--------|------|
| 단일 트랜잭션·FK 위상 | ✅ V1→V1b→V2→W1→W2→W3→W4→W5→W6→V3 정상 |
| 멱등 2-pass delta 0 | ✅ 전건 0 |
| FK 고아 0 | ✅ 3종 0 |
| 동시매칭 0 | ✅ body 1매칭·siz_cd 잔여 0·중복 0 |
| 골든 재현(결합) | ✅ 27,600 = 21,600(면적)+6,000(오시) · off-grid 800×800=20,000 |
| 단가행 재적재 0 | ✅ V1=신규 verbatim·V1b/W5=값불변 전환 |
| COMMIT 0 | ✅ 라이브 무변경 |

**GO (롤백전용 DRY-RUN).** 실 COMMIT은 `apply.sh --commit` + 인간 최종 승인(이번 범위 아님).
