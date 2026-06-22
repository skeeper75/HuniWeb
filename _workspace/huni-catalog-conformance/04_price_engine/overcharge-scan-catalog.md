# overcharge-scan-catalog.md — 전 카탈로그 과대청구(silent 이중합산) 타겟 스캔 마스터

> **Phase 4 타겟 스캔 — hcc-price-engine-inspector** · 2026-06-23 · 라이브 읽기전용 SELECT 실측.
> 스코프: t_prc_* 전 카탈로그(공식 48·formula_components 85·comps 149·단가행 7,292·바인딩 77).
> **단일 패턴 집중**: 판별차원(print_opt_cd 등) NULL/누락으로 같은 공식의 복수 comp가 동시 매칭되어
> **silent 합산**(0원도 에러도 아닌 "그럴듯하게 비싼 값")되는 과대청구만 적출.
> 권위 기준(재조사 0): `engine-contract.md`(P3-1·P3-8·P8-1 인용)·`price-engine-defect-board.md`
> (DEF-PE-03 명함·DEF-PE-10 엽서북 확정사례=자[尺]). 단가값 verbatim·날조 0·v03/STALE 인용 0.
> **직접 교정 금지 — 라우팅만.** 실 교정 인간 승인·webadmin 코드 직접수정 금지.

---

## 0. 패턴 정의 — silent 이중합산이 성립하는 정확한 조건 (engine-contract 인용)

명함/094가 **0원도 ERR_AMBIGUOUS도 아닌데** 과대청구가 성립하는 이유:

| 단계 | engine-contract 명제 | 효과 |
|------|---------------------|------|
| 1 | **P3-1 (NULL=와일드카드)** — 단가행 비수량 차원이 NULL이면 어떤 선택값이든 통과 | 판별축 NULL → 단/양면 선택이 어느 행도 못 거름 |
| 2 | **P2-2 (자동매칭)** — 각 comp가 selections와 매칭되면 자동 포함 | 같은 공식의 S1·S2 둘 다 매칭행 보유 |
| 3 | **P3-8 (ERR_AMBIGUOUS는 comp 내부)** — combo_key 2개+ 매칭은 **한 comp_cd 안**에서만 차단 | **별 comp_cd**(S1≠S2)는 P3-8 비해당 → 차단 안 됨 |
| 4 | **P2-3 (included 합산)** — included=True entry의 subtotal 전부 합산 | S1·S2 둘 다 included → **silent 합산**(경고 없음) |

→ **핵심 시그니처**: ① 같은 공식에 의미가 분리돼야 하는 comp가 2개+ 배선 + ② 그 분리 의미를
판별할 차원이 use_dims·단가행 **어디에도 없음**(또는 전 행 NULL) + ③ 별 comp_cd라 P3-8 미발화.
→ proc_grp 토큰이 use_dims에 있으면 **P8-1(proc_sels 개별평가)로 정당 분리** = silent 합산 아님(가드).

---

## 1. 적출 결과 — 8건 (확실 8 / 의심 0)

| ID | prd_cd | 상품명 | 시트 | 공식 | 판별축 누락 | 1단위당 과대 | 확정도 |
|----|--------|-------|------|------|-----------|:-----------:|:------:|
| OC-01 | PRD_000032 | 코팅명함 | 명함 | PRF_NAMECARD_FIXED | print_opt_cd | +4,500/100매 | 확실(기존 DEF-PE-03) |
| OC-02 | PRD_000031 | 프리미엄명함 | 명함 | PRF_NAMECARD_FIXED | print_opt_cd | +4,500/100매 | 확실(기존 DEF-PE-03) |
| OC-03 | PRD_000094 | 엽서북 | 책자 | PRF_PCB_FIXED | print_opt_cd | +11,500/장 | 확실(기존 DEF-PE-10) |
| **OC-04** | **PRD_000027** | **2단접지카드** | **접지카드** | **PRF_DGP_E** | **접지방식 전무** | **+18,000~20,000/장** | **확실(신규)** |
| **OC-05** | **PRD_000028** | **미니접지카드** | **접지카드** | **PRF_DGP_E** | **접지방식 전무** | **+18,000~20,000/장** | **확실(신규)** |
| **OC-06** | **PRD_000029** | **3단접지카드** | **접지카드** | **PRF_DGP_E** | **접지방식 전무** | **+18,000~20,000/장** | **확실(신규)** |
| **OC-07** | **PRD_000024** | **포토카드** | **포토카드** | **PRF_PHOTOCARD_FIXED** | **투명/일반 전무** | **+8,500/세트** | **확실(신규)** |
| **OC-08** | **PRD_000025** | **투명포토카드** | **포토카드** | **PRF_PHOTOCARD_FIXED** | **투명/일반 전무** | **+6,000/세트** | **확실(신규)** |

**신규 적발 5건**(OC-04~08): 명함/094 외 접지카드 3 + 포토카드 2.

---

## 2. 변종 분류 — 판별축 종류별

### 변종 V1 — print_opt_cd(단/양면) NULL [확정사례·OC-01~03]

명함·엽서북. 기존 DEF-PE-03·DEF-PE-10. S1(단면)·S2(양면) comp가 같은 공식에 배선되고 단가행
print_opt_cd 전 행 NULL. **재검증 결과 변동 없음 — 유효분 이월.**

- 재현: `SELECT comp_cd, COALESCE(print_opt_cd,'<NULL>'), count(*) FROM t_prc_component_prices
  WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P') GROUP BY 1,2;`
  → 전부 `<NULL>` (명함 각2행·엽서북 각117행).

### 변종 V2 — 공정 variant 판별축 전무 (접지방식) [★신규·OC-04~06]

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_formula_components(PRF_DGP_E) — COMP_FOLD_LEAF_3FOLD/4ACC/4GATE/HALF 4개 배선 |
| **증상** | 4개 접지비 comp가 use_dims=`["min_qty"]`만 보유 → **proc_cd·dim_vals·opt_cd 전부 NULL, proc_grp 토큰 없음**. 손님이 접지방식 1개(예 3단)를 골라도 4개 접지비가 min_qty 구간만으로 전부 매칭 → silent 합산. **proc_grp가 없어 P8-1(proc_sels 개별평가)로 분리되지 않음** = 인쇄 공정처럼 정당 분리되지 못하는 결정적 차이 |
| **권위 정답** | 리플렛 접지방식은 택일 옵션 — 선택분 1개만 매칭돼야. 접지방식 판별차원(opt_cd 또는 proc_cd/proc_grp) 신설 필요 |
| **라이브** | PRD_000027/028/029(2단/미니/3단접지카드) 바인딩. 4 comp 전부 prc_typ=PRICE_TYPE.01(단가형 ×qty) |
| **돈영향** | **과대청구**(손님 손해). min_qty=1 구간 단가: 3단6,000·4ACC7,000·4GATE7,000·반접지5,000 → 4개 합 25,000. 선택 1개 제외 **3개분 +18,000~20,000/장** 과대. ×qty이므로 100장이면 ~수십만원 |

- **재현 쿼리**:
```sql
SELECT comp_cd, use_dims, prc_typ_cd FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%';
-- 4건 전부 use_dims=["min_qty"]·PRICE_TYPE.01 (proc_grp 토큰 없음)
SELECT comp_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' AND min_qty=1 ORDER BY comp_cd;
-- 3FOLD=6000·4ACC=7000·4GATE=7000·HALF=5000 (동시합산 25000)
```
- PRD_000028은 옵션그룹 0행(접지방식 선택 UI 자체 부재)이라 합산 더 확정적.
- **라우팅**: 접지방식 판별차원 설계 → `dbm-price-arbiter`(opt_cd vs proc_grp 택일 심의) → `dbm-load-execution`(단가값 verbatim·use_dims 등재). webadmin 코드 직접수정 금지.

### 변종 V3 — variant 상품 판별축 전무 (투명/일반 세트) [★신규·OC-07~08]

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_formula_components(PRF_PHOTOCARD_FIXED) — COMP_PHOTOCARD_SET + COMP_PHOTOCARD_CLEAR_SET |
| **증상** | 일반세트·투명세트 comp가 단가행 **siz_cd=SIZ_000012·bdl_qty=20·min_qty=1 완전 동일** + use_dims 동일 `["siz_cd","bdl_qty","min_qty"]` + proc_grp 없음 → 차원으로 둘을 구분 못 함 → 둘 다 매칭 silent 합산. ★**상품이 024(일반)·025(투명)로 분리됐는데 둘 다 같은 PRF_PHOTOCARD_FIXED에 바인딩** → 공식·판별차원 어느 쪽도 투명 여부를 안 가름 = 구조적 silent 합산 |
| **권위 정답** | 일반포토카드=일반세트만(6,000)·투명포토카드=투명세트만(8,500). 상품별 공식 분리 또는 투명여부 판별차원 |
| **라이브** | 둘 다 prc_typ=PRICE_TYPE.01. 합산=6,000+8,500=14,500 (정답 택일 6,000 or 8,500) |
| **돈영향** | **과대청구**. 일반포토카드(024) 주문 시 투명비 +8,500/세트, 투명포토카드(025) 주문 시 일반비 +6,000/세트 |

- **재현 쿼리**:
```sql
SELECT comp_cd, siz_cd, bdl_qty, min_qty, unit_price FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET'); -- 차원 완전동일·6000 vs 8500
SELECT b.prd_cd, b.frm_cd FROM t_prd_product_price_formulas b WHERE b.prd_cd IN ('PRD_000024','PRD_000025');
-- 024·025 둘 다 PRF_PHOTOCARD_FIXED (상품 분리·공식 미분리)
```
- **기존 보드 정정**: `price-engine-defect-board.md §0` 디지털 요약이 포토카드를 MATCH(정합)로 분류했으나, 본 타겟 스캔 재검증 결과 **silent 합산 위험 확정** → MATCH 오분류. 게이트가 evaluate_price 재계산으로 독립 재실측 권장.
- **라우팅**: `dbm-price-arbiter`(상품별 공식분리 vs 투명 판별차원 심의) → `dbm-load-execution`.

---

## 3. 추정 과대액 Top (1단위당·근거 1줄)

| 순위 | prd | 1단위당 과대 | 근거 |
|:--:|-----|:-----------:|------|
| 1 | PRD_000027/028/029 접지카드 | **+18,000~20,000/장** | min_qty=1 구간 4 접지비 합 25,000 − 선택 1개 = 3개분 과대(단가형 ×qty) |
| 2 | PRD_000094 엽서북 | **+11,500/장** | S1 11,000 + S2 11,500 둘 다 매칭(정답 단면 11,000)·SIZ_000003 min_qty=2 |
| 3 | PRD_000024 포토카드 | **+8,500/세트** | 일반 6,000 + 투명 8,500 둘 다(정답 일반 6,000)·SIZ_000012 |
| 4 | PRD_000025 투명포토카드 | **+6,000/세트** | 투명 8,500 + 일반 6,000 둘 다(정답 투명 8,500) |
| 5 | PRD_000031/032 명함 | **+4,500/100매** | S1 3,500 + S2 4,500 둘 다(정답 단면 3,500)·MAT_000074 min_qty=100 |

★ 접지카드가 **단가형 ×qty**라 수량 곱하면 가장 큰 누적 과대(100장이면 ~180만원 과대 가능).

---

## 4. clean 확인 — silent 합산 아님으로 판정된 후보 (proc_grp 가드 입증)

SCAN-OVERLAP(같은 공식·동일 use_dims comp 2개+)에서 적출됐으나 **정당 분리** 확인:

| 후보 | 공식 | 분리 메커니즘 | 판정 |
|------|------|-------------|:--:|
| COMP_PP_CORNER/CREASE/PERF/VARIMG/VARTEXT (귀돌이·오시·미싱·가변) | PRF_DGP_A/D | proc_cd 100% 충전 + use_dims에 proc_grp 토큰 → **P8-1 proc_sels 개별평가** | ✅ clean |
| COMP_CUT_PERF_1H6 (타공) | PRF_DGP_D | proc_cd 18/18 충전 + proc_grp | ✅ clean |
| **COMP_PRINT_DIGITAL_S1 vs COMP_PRINT_SPOT_WHITE_S1** (디지털인쇄 vs 별색인쇄) | PRF_DGP_A | **서로 다른 proc_grp**(DIGITAL=PROC_000001·SPOT=PROC_000007) → P8-1 분리. plt_siz_cd SIZ_000499 겹쳐도 proc_grp 달라 동시매칭 아님 | ✅ clean |
| COMP_COAT_GLOSSY vs COMP_COAT_MATTE (유광 vs 무광코팅) | PRF_DGP_A/D/E | coat_side_cnt 충전(MATTE 92/92) + GLOSSY 단가행 0행 → 겹칠 행 없음(별개 결함 DEF-PE-04는 GLOSSY 0원 과소) | ✅ silent합산 아님 |
| COMP_PHOTOCARD_SET vs CLEAR_SET | PRF_PHOTOCARD_FIXED | proc_grp 없음·차원 동일 → **분리 안 됨** | ⛔ V3 silent합산(OC-07/08) |

→ **핵심 가드 입증**: proc_grp 토큰이 use_dims에 있으면 P8-1로 정당 분리. **접지비(V2)·포토카드세트(V3)는
proc_grp가 없어** 분리 실패 = silent 합산. 인쇄/공정 add-on이 clean인 이유와 정확히 대비된다.

---

## 5. codex 교차·교정명세로 넘길 핵심

1. **신규 5건(접지카드3·포토카드2)이 명함/094와 같은 클래스인지** codex 독립 재실측 — 특히 접지비
   "proc_grp 없음 → proc_sels 미분리" 인과를 evaluate_price 실호출로 확증(게이트 K-가격).
2. **포토카드 MATCH 오분류 정정** — 기존 보드 §0 디지털 요약을 silent 합산으로 재판정. 게이트가
   evaluate_price 재계산으로 14,500 합산을 독립 입증.
3. **교정 방향 심의(dbm-price-arbiter)**: V2 접지=접지방식 판별차원(opt_cd vs proc_grp 신설)·V3 포토카드=
   상품별 공식분리 vs 투명 판별차원. 단가값 verbatim 불변(차원 충전·use_dims 등재만).
4. **돈크리티컬 우선순위**: 접지카드(단가형 ×qty 누적 최대) > 엽서북 > 포토카드 > 명함.

---

## 부록 — 전수 스캔 쿼리 (재현·감사용)

```sql
-- SCAN-OVERLAP: 같은 공식에 동일 use_dims(proc_grp 토큰 제외) comp 2개+ = silent 합산 후보
WITH fc_dims AS (
  SELECT fc.frm_cd, fc.comp_cd,
    (SELECT jsonb_agg(d ORDER BY d) FROM jsonb_array_elements_text(pc.use_dims) d
       WHERE d NOT LIKE 'proc_grp:%') AS core_dims
  FROM t_prc_formula_components fc JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd)
SELECT frm_cd, core_dims::text, count(*), string_agg(comp_cd,', ')
FROM fc_dims GROUP BY frm_cd, core_dims::text HAVING count(*)>=2;
-- 10개 후보 → proc_grp 충전분(공정/인쇄) clean, proc_grp 없는 접지/포토카드/명함/엽서북 = silent
```
