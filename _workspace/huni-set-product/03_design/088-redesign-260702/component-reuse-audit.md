# 088 재설계 — 싸바리 제본 component 라이브 실측 (재사용 vs 신설 판정)

- 작성 2026-07-02 · 라이브 Railway DB 읽기전용 SELECT · search-before-mint 근거
- 목적: 088 [싸바리바인더 제본비] 조각을 새로 만들기 전에 라이브 t_prc_*에 실재하는지 확인하고,
  재사용/신설을 판정한다. (소재+인쇄비 X = BLOCKED-Q2 후보 component도 병기.)

---

## 1. 싸바리 제본 component — 판정 = **재사용 (신설 불요)**

### 1.1 실측 (t_prc_price_components)

| comp_cd | comp_nm | prc_typ | use_dims | use_yn | del_yn |
|---|---|---|---|---|---|
| **COMP_BIND_SSABARI** | 제본비 싸바리바인더 | PRICE_TYPE.01 | `["proc_cd","min_qty","proc_grp:PROC_000017"]` | Y | N |

### 1.2 단가행 verbatim 대조 (t_prc_component_prices, comp_cd=COMP_BIND_SSABARI, proc_cd=PROC_000098)

| comp_price_id | proc_cd | min_qty | unit_price | note | 권위 격자 | 일치 |
|---|---|---|---|---|---|---|
| 8318 | PROC_000098 | 1 | 30,000 | 하드커버 제본비/싸바리바인더 수량 1 이상 | 30,000 | ✅ |
| 8319 | PROC_000098 | 4 | 25,000 | 〃 수량 4 이상 | 25,000 | ✅ |
| 8320 | PROC_000098 | 10 | 20,000 | 〃 수량 10 이상 | 20,000 | ✅ |
| 8321 | PROC_000098 | 50 | 15,000 | 〃 수량 50 이상 | 15,000 | ✅ |
| 8322 | PROC_000098 | 100 | 9,000 | 〃 수량 100 이상 | 9,000 | ✅ |
| 8323 | PROC_000098 | 1000 | 7,000 | 〃 수량 1000 이상 | 7,000 | ✅ |

→ **6밴드 100% 일치**(권위 sabari-binder-bind-grid.csv = 30000/25000/20000/15000/9000/7000). **신설·mint 불요.**

### 1.3 바인딩(고아) 상태
- `t_prc_formula_components WHERE comp_cd='COMP_BIND_SSABARI'` = **0건**.
- → component·단가는 실재하나 **어떤 공식에도 미배선(고아)**. 088 부모공식에 배선하는 것이 재설계의 실질 배선 작업.

### 1.4 proc 실재
- `t_proc_processes`: PROC_000098 = "싸바리바인더"(use_yn=Y·del_yn=N)·PROC_000017 = "제본"(그룹). 실재.

---

## 2. ★옵션 오염 주의 — COMP_BIND_SSABARI가 3 proc 밴드 보유

`COMP_BIND_SSABARI`는 이름이 "싸바리"이나 실제로 **하드커버 3종 제본 밴드를 모두 보유**한다(단일 component 안에 proc_cd로 구분):

| proc_cd | proc_nm | 1부 | 100부 | 별도 전용 component 존재 |
|---|---|---|---|---|
| PROC_000023 | 하드커버무선제본 | 30,000 | 7,000 | COMP_BIND_HC_MUSEON (무선 전용) |
| PROC_000024 | 하드커버트윈링제본 | 30,000 | 8,000 | COMP_BIND_HC_TWINRING (트윈링 전용) |
| **PROC_000098** | **싸바리바인더** | **30,000** | **9,000** | (싸바리 전용 component 없음) |

- 즉 무선·트윈링은 **각각 전용 격리 component**(COMP_BIND_HC_MUSEON=023만·COMP_BIND_HC_TWINRING=024만)가 별도로 있으나, **싸바리 전용 격리 component는 없고** COMP_BIND_SSABARI가 3밴드 통합 보유(네이밍 냄새).
- **isolation 메커니즘**: use_dims에 `proc_cd`가 있으므로, 088이 product_processes에 **PROC_000098만** 선언하면 `_row_matches`가 proc_cd로 싸바리 밴드(098)만 매칭 → 무선(023)·트윈링(024) 밴드는 조용히 적용되지 않음. proc당 밴드 1개씩이라 088 내부 ambiguity 0.
- **판정 = 재사용(COMP_BIND_SSABARI @ PROC_000098) + 088 proc 격리**. search-before-mint 준수(데이터 verbatim 실재).
  - **[HARD] 전제**: 088 product_processes = {PROC_000098} 단독(023·024 미포함). 현재 088 proc 0건 → PROC_000098 추가가 배선 항목(값 무관·지금 명세 가능).
- **대안(비권고)**: §3 경계 청결(082 COMP_BIND_HC_TWINRING=단일 proc 패턴)에 엄격히 맞추려면 `COMP_BIND_HC_SABARI`(PROC_000098 밴드만) 신설 가능. 그러나 ① 데이터 중복 mint ② proc_cd가 이미 격리 ③ search-before-mint(재사용 우선) → **신설 비권고**. 냄새는 기록만(088 스코프 밖 리팩터).

---

## 3. 소재+인쇄비 X 후보 component 실측 (BLOCKED-Q2 병기)

| 후보 | component | 실재 | 값(611×374 커버) | 재사용 가능? |
|---|---|---|---|---|
| **(a) 레더하드커버 A4 소재 7000** | (없음 — 라이브 단가행 부재) | ❌ | 엑셀 IMPORT r101에만·라이브 t_prc_component_prices에 MAT_000175(레더하드커버A4) 단가행 0건 | **불가**(mint 필요·인쇄비 component도 미지정) → BLOCKED-Q2 |
| **(b) 레더아트프린트 611×374 = 19000** | COMP_POSTER_CANVAS_FABRIC (use_dims=[siz_width,siz_height,min_qty], use_yn=Y) | ✅ | 800×600 밴드 = 19,000(611이 ≤800·374가 ≤600 밴드에 듦·flat, min_qty NULL) | **가능**(단 실무진 미지목 경로) → 경로 확정 시 재사용 |

- 레더 자재 마스터 실재: MAT_000175(레더하드커버 A4)·MAT_000379(레더(화이트))·MAT_000008/000186(레더) 등 — 자재코드는 있으나 **소재비 단가행(component_prices)이 없음**(엑셀 IMPORT에만).
- **판정**: X 조각은 (a)=신설 필요·(b)=재사용 가능이나 **어느 경로인지 실무진 미확정** → **BLOCKED-Q2**. 값 채움·component 확정 후 재사용/mint 결정.

---

## 4. 요약 판정

| 조각 | 판정 | 근거 |
|---|---|---|
| 싸바리 제본비 | **재사용** COMP_BIND_SSABARI @ PROC_000098 | 6밴드 verbatim 일치·실재·고아→배선 |
| 088 부모공식 shell | **재사용** PRF_LEATHER_RINGBINDER_SET | 실재(component만 교체) |
| 현 COVERBIND | **폐기(배선 제거)** | 제본 종류·레더 원가 불일치 |
| member 6종 | **재사용**(변경 0) | 전부 라이브 실재 반제품 |
| 소재+인쇄비 X | **BLOCKED-Q2** | 값·경로·component 미확정((a)mint/(b)재사용 후보) |

## 출처
- t_prc_price_components·t_prc_component_prices(comp_price_id 8318~8323 싸바리·8336~8347 무선/트윈링)·t_prc_formula_components(SSABARI 고아)·t_proc_processes(PROC_000098)·t_mat_materials(레더 MAT)·COMP_POSTER_CANVAS_FABRIC(800×600=19000) — 2026-07-02 읽기전용
- 동형: t_prd_product_price_formulas(082=PRF_HC_TWINRING_SET)·t_prc_formula_components(082=COMP_BIND_HC_TWINRING 단일)
