# 설계 — 미러/거울류 견적0 해소 + COMP_ACRYL_MIRROR3T 고아 처분 (§18/§27)

- 일자: 2026-07-01
- 트랙: §27 배선 서브트랙 (종료척도 = 배선 결함 0 + PRICE≠0) · §18 엔진 설계
- 방법론: `hpe-engine-design` · 라이브 읽기전용 실측 + 권위(상품마스터260610·인쇄상품가격표260527) verbatim
- 산출: 본 설계 명세 + `design-mirror-acryl3t-260701-dryrun.sql` (BEGIN…ROLLBACK) · **실 COMMIT 없음(인간 승인 후 §7 위임)**

---

## 0. 헤드라인 — ★디렉티브 전제 정정 (권위 실측 결과)

디렉티브 전제: "COMP_ACRYL_MIRROR3T(미러아크릴3T)를 투명3T 동형 공식 `PRF_MIRROR_ACRYL`로 신설·거울류(183~187) 바인딩". 
**라이브 + 권위 실측 결과 이 전제는 성립하지 않는다. 그대로 배선하면 오적재(오가격 + M/L 사이즈 견적불가).**

증거 (전부 실측):
| 항목 | 실측 사실 |
|---|---|
| **COMP_ACRYL_MIRROR3T 정체** | 인쇄상품가격표 **아크릴 B03 "미러아크릴3T (직접입력형) 전면5도 통용 단가"**(A35:J35). **가로/세로 20~100mm 면적매트릭스**(9×9=81셀). 라이브 81행 verbatim 일치(20×20=5000·30×30=6200…). = **직접입력(자유치수) 미러아크릴** 통용단가. |
| **COMP_ACRYL_MIRROR3T 호스트** | 라이브에서 **이 comp를 참조하는 상품 0건**(formula_components·product_price_formulas 조인 결과 공집합). 순수 고아. |
| **직접입력 미러아크릴 상품 존재?** | 라이브 상품 중 미러/거울 = 143(미러아크릴스티커·별 comp로 이미 배선)·183~187(거울류). **직접입력형 미러아크릴 완제품은 미존재.** |
| **183~187 정체** | 상품마스터 **"굿즈파우치(가격포함)" 시트** — **사이즈별 고정가 굿즈**(가격포함). 아크릴 시트에 없음. |
| **183~187 사이즈** | 사각손186/블랙187 = S(75×130)·M(95×166)·L(120×218)mm. **미러 격자 최대 100×100을 초과** → 면적격자 배선 시 M/L은 `ERR_ABOVE_MAX`(견적불가). |
| **183~187 가격** | 고정가(가격포함): 틴3,000·컴팩트3,600·카드2,500·사각손 5,000/5,500/6,000·블랙 6,000/7,500/9,000. **면적단가와 무관.** |
| **183~187 라이브 설정** | 186/187이 이미 **DSC_GOODSA_QTY(굿즈상품 A타입)** 할인테이블에 연결됨 = 라이브 스스로 "굿즈"로 규정. 아크릴 면적공식과 모순. |

결론: **183~187 거울류의 견적0은 "굿즈 고정가" 모델로 풀어야 한다**(면적격자 아님). **COMP_ACRYL_MIRROR3T는 별개의 authority 통용단가로, 소비 상품(직접입력 미러아크릴)이 아직 없어서 고아**다 — 강제 배선 대상이 아니라 처분 대상.

---

## 1. Part A (실 결함 해소) — 183~187 거울류 = 굿즈 고정가 모델

### 1.1 가격공식 (price_formulas) — 상품별 1:1 (poster 굿즈 컨벤션 계승)

굿즈 고정가는 comp가 `siz_cd`만으로 키잉되므로, siz_cd를 공유하되 가격이 다른 상품(186 S=5000 vs 187 S=6000)은 **각자 comp/공식**이어야 한다(공유 시 siz_cd 단일가 충돌). 동형 선례 = `PRF_POSTER_ACRYLSTK_MIRROR`(143)·`PRF_POSTER_FOAMBOARD_*`.

| 공식(frm_cd) | frm_nm(레거시 용어) | 유형 | 대상 | 상태 |
|---|---|---|---|---|
| PRF_MIRROR_SQHAND | 사각손거울 완제품가 | 고정가 by 사이즈 | 186 | **READY** |
| PRF_MIRROR_SQHAND_BLACK | 블랙사각손거울 완제품가 | 고정가 by 사이즈 | 187 | **READY** |
| PRF_MIRROR_TIN | 틴거울 완제품가 | 고정가 by 사이즈 | 183 | BLOCKED(§7 사이즈) |
| PRF_MIRROR_COMPACT | 컴팩트거울 완제품가 | 고정가 by 사이즈 | 184 | BLOCKED(§7 사이즈) |
| PRF_MIRROR_CARD | 카드거울 완제품가 | 고정가 by 사이즈 | 185 | BLOCKED(§7 사이즈) |

### 1.2 가격구성요소 (price_components) — search-before-mint

재사용 후보 없음(라이브 미러 comp = 면적격자 COMP_ACRYL_MIRROR3T·스티커 COMP_POSTER_ACRYLSTK_MIRROR 둘 다 siz_cd 고정가 아님·가격 상이). 신규 mint 필요(무손실 표현 불가 입증됨). 유형·차원은 **완제품 고정가 정본 패턴**(COMP_POSTER_ACRYLSTK_MIRROR 동형):

| comp_cd | comp_nm | comp_typ_cd | prc_typ_cd | use_dims | 의미축 | 상태 |
|---|---|---|---|---|---|---|
| COMP_MIRROR_GOODS_SQHAND | 사각손거울 완제품가 | PRC_COMPONENT_TYPE.06(완제품비) | PRICE_TYPE.01(단가형) | ["siz_cd"] | 사이즈 | READY |
| COMP_MIRROR_GOODS_SQHAND_BLACK | 블랙사각손거울 완제품가 | .06 | .01 | ["siz_cd"] | 사이즈 | READY |
| COMP_MIRROR_GOODS_TIN | 틴거울 완제품가 | .06 | .01 | ["siz_cd"] | 사이즈 | BLOCKED(§7) |
| COMP_MIRROR_GOODS_COMPACT | 컴팩트거울 완제품가 | .06 | .01 | ["siz_cd"] | 사이즈 | BLOCKED(§7) |
| COMP_MIRROR_GOODS_CARD | 카드거울 완제품가 | .06 | .01 | ["siz_cd"] | 사이즈 | BLOCKED(§7) |

- 단가형(.01) → 엔진 `component_subtotal` = `unit_price × 수량`(장당가). 굿즈 정본과 일치.
- use_dims=["siz_cd"] → NON_QTY_DIMS 정확매칭(와일드 always-match 아님·형제 오합산 없음).

### 1.3 단가행 (component_prices) — 권위 verbatim (날조 0)

**READY (186/187 — 사이즈 384/386/388 등록 확인)**:

| comp_cd | siz_cd | siz_nm | unit_price | 출처 |
|---|---|---|---|---|
| COMP_MIRROR_GOODS_SQHAND | SIZ_000384 | S(75×130) | 5000 | 가격포함 사각손 S |
| COMP_MIRROR_GOODS_SQHAND | SIZ_000386 | M(95×166) | 5500 | 사각손 M |
| COMP_MIRROR_GOODS_SQHAND | SIZ_000388 | L(120×218) | 6000 | 사각손 L |
| COMP_MIRROR_GOODS_SQHAND_BLACK | SIZ_000384 | S(75×130) | 6000 | 블랙 S |
| COMP_MIRROR_GOODS_SQHAND_BLACK | SIZ_000386 | M(95×166) | 7500 | 블랙 M |
| COMP_MIRROR_GOODS_SQHAND_BLACK | SIZ_000388 | L(120×218) | 9000 | 블랙 L |

- apply_ymd=2026-06-01(라이브 굿즈 관례) · comp_price_id=IDENTITY(자동)

**BLOCKED — §7 사이즈 등록 선결 후 충전(단가 확정·siz_cd만 대기)**:
| 상품 | 사이즈(권위) | 단가 | 필요 §7 작업 |
|---|---|---|---|
| 183 틴거울 | 무광 75mm(원형) | 3000 | siz_cd 신규 등록 + product_sizes 연결 |
| 184 컴팩트거울 | 무광 75mm(원형) | 3600 | 〃 (183과 물리동일 75mm이나 가격상이→별 comp) |
| 185 카드거울 | 57×91mm (min 3·incr 3) | 2500 | siz_cd 신규 등록 + product_sizes + 수량 min/incr=3 |

### 1.4 상품↔공식 바인딩 (product_price_formulas)

| prd_cd | 상품 | frm_cd | apply_bgn_ymd | 상태 |
|---|---|---|---|---|
| PRD_000186 | 사각손거울 | PRF_MIRROR_SQHAND | 2026-06-01 | READY |
| PRD_000187 | 블랙사각손거울 | PRF_MIRROR_SQHAND_BLACK | 2026-06-01 | READY |
| PRD_000183 | 틴거울 | PRF_MIRROR_TIN | 2026-06-01 | BLOCKED(§7) |
| PRD_000184 | 컴팩트거울 | PRF_MIRROR_COMPACT | 2026-06-01 | BLOCKED(§7) |
| PRD_000185 | 카드거울 | PRF_MIRROR_CARD | 2026-06-01 | BLOCKED(§7) |

- ppf PK=(prd_cd, apply_bgn_ymd)·frm_cd는 PK밖(실측). 할인=186/187 이미 DSC_GOODSA_QTY 연결(추가작업 불요). 183~185는 §7에서 DSC_GOODSB_QTY 연결 필요(권위: 굿즈상품 B타입).

---

## 2. Part B (고아 처분) — COMP_ACRYL_MIRROR3T (직접입력형 통용단가)

- **정체**: authority 통용단가(아크릴 B03·면적 20~100mm 9×9). 라이브 81셀 verbatim. **삭제/오적재 아님** — 정당한 권위 단가표.
- **문제**: 이를 소비할 **직접입력형(자유치수) 미러아크릴 완제품이 라이브에 미존재**. 183~187은 굿즈 고정가라 소비자 아님.
- **디렉티브 요청(PRF_MIRROR_ACRYL 신설·거울류 바인딩) 처분**:
  - PRF_MIRROR_ACRYL 신설 + COMP_ACRYL_MIRROR3T 배선은 **동형 공식 설계로는 타당**(PRF_CLR_ACRYL 동형: 면적격자·단가형). dryrun에 **READY 공식+배선**으로 포함(향후 직접입력 미러아크릴 상품 생성 시 즉시 사용).
  - **단 거울류(183~187) 바인딩은 REJECT**(권위 위반·M/L 견적불가). 바인딩 대상 = 미존재 직접입력 상품 → **CONFIRM 큐**.
- **스캐너 종료척도 정합**: PRF_MIRROR_ACRYL을 신설·배선하면 "고아" → "미배선공식"으로 결함 유형만 이동(순감 0). 따라서 **권장 = COMP_ACRYL_MIRROR3T를 `orphan-classification.json`에서 LEGIT_UNUSED("직접입력 미러아크릴 상품 미생성·authority 통용단가 대기")로 재분류**(round9 addon/superseded 분리와 동형·결함 은닉 아님). 상품 생성 결정(CONFIRM) 후 READY 공식/배선/바인딩 활성화.

---

## 3. disjoint 진리표 자가검증 (오합산·동시매칭 방지)

- 각 거울 상품 → 전용 공식 → 전용 comp(1:1:1). comp 간 siz_cd 공유(384/386/388)하나 **상품이 서로 다른 comp에 바인딩**되므로 교차 매칭 불가.
- comp 내부: siz_cd = NON_QTY_DIMS 정확매칭. 각 comp 행의 siz_cd 상호 배타(384≠386≠388) → `_row_matches` 단일행 → `ERR_AMBIGUOUS` 불가.
- 판별 비수량차원 존재(siz_cd) → 와일드 always-match 아님(형제 옆 오합산 0).
- COMP_ACRYL_MIRROR3T(면적) = 별 공식(PRF_MIRROR_ACRYL)·거울 공식과 무접점 → 시트 차원경계(SOT1) 내 격리.
- **판정: disjoint 성립 · silent 합산 경로 0.**

---

## 4. golden-cases (검증가 재현 대상 · 권위 verbatim · qty=1 = DSC_GOODSA 0%구간)

| # | 상품 | 사이즈(siz_cd) | 수량 | 기대가 | 근거 |
|---|---|---|---|---|---|
| G1 | 186 사각손거울 | S(SIZ_000384) | 1 | **5,000** | 가격포함 5000×1 |
| G2 | 186 사각손거울 | M(SIZ_000386) | 1 | **5,500** | 5500×1 |
| G3 | 186 사각손거울 | L(SIZ_000388) | 1 | **6,000** | 6000×1 |
| G4 | 187 블랙사각손거울 | S(SIZ_000384) | 1 | **6,000** | 6000×1 |
| G5 | 187 블랙사각손거울 | M(SIZ_000386) | 1 | **7,500** | 7500×1 |
| G6 | 187 블랙사각손거울 | L(SIZ_000388) | 1 | **9,000** | 9000×1 |
| G7(BLOCKED) | 183 틴거울 | 무광75(§7) | 1 | 3,000 | §7 사이즈 등록 후 |
| G8(BLOCKED) | 184 컴팩트거울 | 무광75(§7) | 1 | 3,600 | 〃 |
| G9(BLOCKED) | 185 카드거울 | 57×91(§7) | 3 | 7,500 | 2500×3(min/incr=3) |

- 할인 검증(참고): 186 S qty=50 → 5000×50×(1-0.05)=237,500(DSC_GOODSA 50~99=5%).

---

## 5. 결정·트레이드오프·컨펌 큐

- **[결정] 거울류=굿즈 고정가**(면적격자 아님). 권위(가격포함)+라이브(DSC_GOODSA 연결) 이중 증거. relitigate 금지.
- **[결정] 상품별 comp/공식 1:1**(siz_cd 공유·가격상이 → 공유 불가). poster 굿즈 컨벤션 계승.
- **[trade-off] mint 규모**: comp 5·공식 5(READY 2/BLOCKED 3) + PRF_MIRROR_ACRYL 1. 굿즈 SKU=자체 comp/공식이 정본이라 불가피(무손실 표현 위해).
- **[CONFIRM ①]** 직접입력형(자유치수) 미러아크릴 완제품을 신설할 것인가? YES → PRF_MIRROR_ACRYL+COMP_ACRYL_MIRROR3T 배선 활성화·바인딩. NO → COMP_ACRYL_MIRROR3T = 통용단가 참조로 LEGIT_UNUSED 유지.
- **[CONFIRM ②]** 183/184 무광75mm·185 57×91 siz_cd 신규 등록(§7/dbmap)·185 수량 min/incr=3 적용.
- **[라우팅]** Part A READY(186/187)=§7 인간 승인 COMMIT. Part A BLOCKED(183~185)=§7 사이즈 선등록→본 comp/단가 충전. Part B=CONFIRM①→직접입력 상품 생성 시 §18 활성.

## 6. 산출 파일
- 본 설계: `_workspace/_foundation/batch/wiring/design-mirror-acryl3t-260701.md`
- dryrun: `_workspace/_foundation/batch/wiring/design-mirror-acryl3t-260701-dryrun.sql`
