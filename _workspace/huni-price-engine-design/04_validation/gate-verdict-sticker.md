# gate-verdict-sticker.md — 스티커(이산 siz_cd 단가형 + 세트 합가형·바인딩 정합 교정) 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 검증 (생성≠검증).** engine-designer 설계 주장을 라이브 t_prc_*·t_prd_*·t_mat_*·t_siz_*·권위 가격표로 직접 재실측해 결판.
> 라이브 읽기전용 SELECT 실측 **2026-06-20**(Railway `db railway`·psql) · pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`·569줄) 코드 직접 검증 · 골든 GC-STK1~8 충실 재구현(허용오차 0).
> 검증 대상: `03_design/engine-design-sticker.md`·`golden-cases-sticker.md`(GC-STK1~8)·`design-decisions.md` 스티커절(STK-1~11)·`set-product-design.md` §11.
> 기준점: `01_formula/formula-map-sticker.md`·`02_benchmark/absorption-candidates-sticker.md`.

---

## 0. 종합 판정: **GO** (E1~E7 전건 PASS · 보정-1 RESOLVED · 차단 결함 0 · 정정 권고 1[LOW·골든 표기 — designer 폐루프 완료] · 잔여=인간/실무 컨펌큐 5)

> **★재게이트(보정-1 폐루프 후 독립 재검증·2026-06-22).** 직전 조건부 GO(E1 CONDITIONAL·보정 요구 1[053/054 교정경로])에 대해 designer가 §4-2 재작성(4-2a/4-2b/4-2c)·GC-STK6/6b 신규·STK-5/11·CV-STK-053/054로 보정-1을 완료. hpe-validator가 designer 주장 신뢰 없이 **라이브 읽기전용 SELECT + import xlsx(가격표260527 분해 권위) 직접 재실측**으로 보정 결함 닫힘을 결판. **보정-1 RESOLVED·E1 CONDITIONAL→PASS.**

스티커는 6종단 중 **라이브 완성도 최고**(공식 4·comp 4·단가행 3,066·바인딩 16/16 전건 실재). designer 핵심 명제(이산 siz_cd 단가형·B06 팩 .02 결판·동형결함 3종 부재·G-STK-1~4 바인딩 교정·세트조합 불요·신규 mint 0)를 라이브로 독립 재실측해 **전건 정확**. 골든 GC-STK1~8 라이브 verbatim 대조 일치.

**★보정-1 닫힘 — 독립 라이브 재실측이 designer 보정 명제를 전건 입증:**
1. **일괄 SIZ_172→SIZ_520 함정 입증** — `SELECT … siz='SIZ_000520' GROUP BY mat_cd` = mat {084,153,155,156,242}만(각 36단)·**mat162/163 부재**. 053/054를 SIZ_520으로 교정해도 여전히 no_match → designer "일괄 묶음 함정" 명제 정확.
2. **052 "정상 아님" 재판정 입증** — 052 5소재 × {170,172,196} 실측: SIZ_170=5소재 각 36단(A5 정상)·**SIZ_172=mat153만 6단(낱장 4,000 오청구)·4소재 0행(no_match)**·**SIZ_196=전건 0행**. 직전 verdict "052 5소재 정상"은 부정확 → designer 정정 정확.
3. **054 전건 no_match(Critical·active) 입증** — mat163 단가행 = {059,060,518,519}만(각 36단)·**바인딩 siz 170/172/196 전건 0행**. 054 use_yn=Y(active) → 현재 견적 불가 긴급.
4. **단가 verbatim 입증** — import xlsx(권위)·라이브 둘 다: A5(059) 투명/홀로 qty1=**7,000**(designer 기록 일치)·053 SIZ_172 mat162 qty1=**7,000**(B03 낱장 오청구)·import xlsx A4(SIZ_172) 반칼 투명/홀로 36단 qty1=**6,000**(designer "A4 반칼 6,000 verbatim" = import xlsx 셀 일치·날조 0). 052 SIZ_172×153=4,000(낱장)·SIZ_520×153=5,000(반칼) verbatim.
5. **추측 INSERT 가드 입증** — A6(196)·100x140(058)은 라이브 0행·import xlsx에도 부재 → designer "바인딩 제거 권고·단가 출처 컨펌"(추측 적재 금지)로 정직히 컨펌큐에 남김. 신규 mint 0(059 재바인딩·SIZ_520 재사용·단가행 INSERT는 import xlsx verbatim).

**∴ 보정-1이 결함을 정확히 닫음**(날조 0·추측 0·교정 경로 052≠053/054 분리 정확·import xlsx 권위 대조). 보정으로 새 결함 0(16/16 바인딩·prc_typ·comp 1개씩·freshness 무드리프트 재확인). 잔여는 **인간/실무 컨펌큐**(차단 아님·dbm-price-arbiter 심의 + 인간 승인)·**정정-1(LOW)은 designer 폐루프 완료**(GC-STK1 골든표 단가행/최종가 구분).

| 게이트 | 판정(재게이트) | 핵심 근거(라이브 독립 재실측 2026-06-22) |
|--------|------|------------------------------------|
| E1 공식 추출 충실성 | **PASS** (CONDITIONAL→PASS) | 가격표 7블록·prc_typ·use_dims·단가행·바인딩 전건 verbatim 일치(날조 0)·v03 미인용. **★053/054 교차바인딩 결함 카탈로그 보강(4-2a/2b/2c·G-STK-2a/2b/2c)·일괄 교정 함정 명시·052 재판정·사이즈축별 분리 경로 — 독립 라이브 실측과 전건 일치** |
| E2 구성요소 분해 정합 | **PASS** | 가격축 3축뿐(siz/mat/수량)·형상/칼선/재단=가격직교·공식당 comp 1개([21] 실측)·시트경계 SOT 1·완제품/세트 구분 정확 |
| E3 경쟁사 흡수 타당성 | **PASS** | 신규 가격축 0·naming(shape_info/THO_DFT/CUT_DFT/digital_price…) 유입 0·형상 #17 옵션 distinct≠가격축 분리 정확·후니 표현력 동형 |
| E4 엔진 설계 건전성 | **PASS** | NON_QTY_DIMS 정확매칭·.01 unit×qty·.02 ÷min_qty(코드 검증)·search-before-mint(신규 mint 0·SIZ_520/059 재사용·단가행=verbatim)·**SIZ_172 낱장↔반칼 collision 실측 입증→반칼 전용 siz 분리 정확**(ERR_AMBIGUOUS 회피) |
| E5 세트 조합 정합 | **PASS** | t_prd_product_sets 스티커 0행·타투/팩=단일본체 묶음단위(부품 합산 아님)·이중계상 구조적 부재·세트레이어 불요 라이브 확정 |
| E6 골든 재현 | **PASS** | GC-STK1~8 + 신규 GC-STK6/6b 라이브 verbatim 대조 일치(허용오차 0)·.02 타투12,000/팩4,000 재계산·B06 54배 왜곡 부재·052/053/054 교정 케이스 import xlsx verbatim 입증 |
| E7 생성검증 독립성 | **PASS** | B06 prc_typ·del_yn·교차바인딩·SIZ_520 trap·import xlsx 권위 라이브 독립 재실측·골든 충실 재구현·**보정-1 명제를 designer 신뢰 없이 직접 SELECT/대조로 입증**·self-approve 없음 |

---

## E1 — 공식 추출 충실성 (cartographer 지도 ↔ 가격표/라이브 셀 재대조) · **PASS** (CONDITIONAL→PASS·보정-1 RESOLVED)

**재현 SQL:**
```sql
SELECT comp_cd,prc_typ_cd,use_dims,use_yn,del_yn FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_STK_PRINT','COMP_STK_TATTOO','COMP_STK_PACK','COMP_GANGPAN_PRINT');
SELECT comp_cd,count(*) FROM t_prc_component_prices WHERE comp_cd IN (…) GROUP BY comp_cd;
SELECT mat_cd,count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' GROUP BY mat_cd;
```

| 항목 | 설계/지도 기술 | 라이브 실측 | 판정 |
|------|----------------|-------------|------|
| COMP_STK_PRINT | .01·`["siz_cd","mat_cd","min_qty"]`·2,694행·mat 7종 | **PRICE_TYPE.01·동일 use_dims·2694행·mat {084,153,155,156,162,163,242}** | ✓ |
| COMP_STK_TATTOO | .02·1행(siz060·mat167·min3·4000) | **.02·1행·verbatim 일치** | ✓ |
| COMP_STK_PACK | .02·1행(siz068·min54·4000·mat 미사용) | **.02·use_dims=["siz_cd","min_qty"]·mat 빈값·verbatim** | ✓ |
| COMP_GANGPAN_PRINT | .01·370행·mat {084,153} | **.01·370행·mat084(185)·mat153(185)** | ✓ |
| siz_width/height 사용 | 0(이산 siz_cd) | **0행** | ✓ |
| mat 7종(3 collapse stale 해소) | 7종 전개 | **7종 실측**(153·084·155·156·242·162·163) | ✓ |
| 7블록 가격표(B01~B06+합판) | verbatim 인용 | (가격표260527 권위·셀 일치) | ✓ |

- **날조 0·v03 미인용**: 설계는 가격표260527·상품마스터260610·라이브만 인용. 단가값 출처=라이브 단가행 verbatim(순환참조 0). ✓
- **dbmap stale 해소 정확**: "3 mat collapse·투명 170 오매핑·13 미배선"이 round-23 COMMIT 이전 stale이고 2026-06-20 라이브가 7소재·16/16 바인딩으로 해소됐다는 designer 갱신 = 라이브 실측 정확. ✓

**★E1 보정-1 RESOLVED — 053/054 교차바인딩 + 052 재판정 결함 카탈로그 보강 (독립 라이브+import xlsx 재실측 2026-06-22):**

직전 CONDITIONAL 사유(053/054 siz↔mat 교차바인딩 no_match 누락)를 designer가 §4-2 재작성(4-2a/2b/2c·G-STK-2a/2b/2c·일괄 교정 함정 명시·052 재판정·사이즈축별 분리 경로)으로 보강. 독립 재실측으로 전건 검증:

```sql
-- [4] mat162(투명) siz 분포 → 059(36)·060(36)·172(6)·174(6)·197(6)·514(6)·515(6)·518(36)·519(36)  ⇒ 170·196 부재·172=6단(낱장)
-- [5] mat163(홀로) siz 분포 → 059·060·518·519(각 36)  ⇒ 170·172·196 전건 부재 = 054 전건 no_match
-- [6] SIZ_520 mat 커버리지 → 084·153·155·156·242(각 36)만·mat162/163 부재 = 일괄 교정 함정 입증
-- [7] 052 5소재×{170,172,196} → 170=5소재 각36단(A5정상)·172=mat153만 6단(낱장)·4소재0·196=전건0 = 052 정상아님
```

| design 보강 명제 | 독립 라이브/import xlsx 실측 | 판정 |
|------------------|------------------------------|------|
| ★일괄 SIZ_172→SIZ_520 함정 | [6] SIZ_520에 mat162/163 0행(5소재만) → 053/054 교정 무효 | ✓ 함정 입증 |
| ★052 "정상 아님"(verdict 정정) | [7] 052 A5만 정상·A4=mat153만 낱장4,000+4소재 no_match·A6 전건 0 | ✓ 052 정정 정확 |
| 054 전건 no_match(Critical·active) | [5] mat163={059,060,518,519}·바인딩 170/172/196 전건 0·[14] 054 use_yn=Y | ✓ active 긴급 |
| 053 SIZ_172만 B03 낱장 7,000 오청구 | [9] SIZ_172×mat162 qty1=7,000(낱장)·170/196 no_match | ✓ |
| A5 투명/홀로 = 7,000(059 col1) | [8][11] 059×mat162/163 qty1=7,000·import xlsx "A5(4판)"=7,000 | ✓ verbatim |
| A4 반칼 투명/홀로 = 6,000(import xlsx) | import xlsx sheet4 SIZ_172 "A4(2판)" mat162/163 36단 qty1=6,000 | ✓ verbatim·날조 0 |
| A6(196)·100x140(058) 추측 금지 | [17] 라이브 0행·import xlsx에도 A6 부재 → 바인딩 제거 권고·컨펌 | ✓ 정직 컨펌 |

★ **E1 PASS 근거**: 053/054 교차바인딩 + 052 재판정이 결함 카탈로그(§4-2 G-STK-2a/2b/2c)에 정확·완전히 진입. 일괄 교정 함정·사이즈축별 분리(경로 a 재바인딩 / b 단가행 적재 / c 바인딩 제거)·052≠053/054 경로 분리가 라이브 + import xlsx 권위와 전건 일치. 날조 0·추측 0·v03 미인용. **보정-1 RESOLVED → CONDITIONAL 해소.**

---

## E2 — 구성요소 분해 정합 (시트 차원경계 SOT 1·완제품/반제품) · **PASS**

- **가격축 = siz_cd·mat_cd·수량 3축뿐**: 라이브 use_dims 실측(`["siz_cd","mat_cd","min_qty"]`)이 3축 확정. 형상/칼선/재단 차원이 component_prices에 baked-in 0(siz_width=0·형상 컬럼 부재). ✓
- **형상=가격직교 라이브 입증**: 058~062 반칼 모양 스티커가 같은 siz/mat면 동일 단가행(형상별 분기 0). 형상은 상품 정체·칼틀·round-6 CPQ. rpmeta ST 형상 #17 distinct(옵션 그릇 V-12)는 *옵션축*이지 *가격축* 아님 → component_prices baked-in 부결 정확(option-axis≠price-axis). ✓
- **공식당 comp 1개**: `t_prc_formula_components` 실측 = PRF_STK_FIXED→COMP_STK_PRINT·PACK→PACK·TATTOO→TATTOO·GANGPAN→GANGPAN 각 disp_seq=1·addtn_yn=Y·comp 1개 → silent 이중합산 구조적 불가. ✓
- **시트경계 SOT 1**: PRF_STK_FIXED=스티커 본체 단일 comp(디지털/아크릴 comp 침입 없음·라이브 확인). ✓
- **완제품/세트 구분**: 052~064 완제품·055~057 완칼·066 합판=완제품(1공식)·067 타투/065 팩=세트단위(단일본체 묶음)·반제품(다본체 조합) 부재. 의미축 이중 인코딩 없음. ✓

---

## E3 — 경쟁사 흡수 타당성 (답습 아닌 흡수·naming 유입·형상≠가격축) · **PASS**

- **신규 가격축 0**: C-S1~C-S8 전부 후니 기존 그릇(이산 siz_cd·mat_cd·min_qty 구간·.02 합가형·proc_cd 공정·round-6 CPQ 제약·frm_cd 바인딩). 신규 테이블/가격축 0. rpmeta ST distinct #18 부결·6종단 누적(신규 축 0)과 정합. ✓
- **naming 유입 0**: `shape_info`/SQ/CL/EL/RC/FR·`THO_DFT`/`THO_GRA`·`CUT_DFT`/DFXXX/DFITM·`digital_price`/`vTmpl_price`/`tmpl_price`·`MTRL_CD`/STRMDFT·STPAU/STPAD/STBP 등 후니 유입 없음. 후니 frm_cd/comp_cd/mat_cd/siz_cd 컨벤션만. ✓
- **★형상/칼선/재단 = 옵션축≠가격축 분리 정확**: RedPrinting이 형상(shape_info 1급 enum)·칼선(THO)·재단(CUT)을 1급 옵션 슬롯으로 두는 것을 가격축으로 오독하지 않음. 단 "재단입자가 단가 가르면 siz_cd 분리"(반칼 SIZ_520 5000 vs 완칼 SIZ_172 4000) 예외 정확 — 라이브 verbatim 확인. ✓
- **후니 표현력 동형**: 스티커 가격 골격(이산 siz_cd×mat_cd×min_qty + 세트 .02)이 PRF_STK_FIXED/COMP_STK_PRINT로 이미 동형 → 핵심 흡수 불요·설계 원칙 못박기. 답습(엔진 3분기 digital/vTmpl/tmpl) 아닌 메커니즘 흡수(frm_cd+prc_typ 데이터 분기). ✓

---

## E4 — 엔진 설계 건전성 (evaluate_price 계약·NON_QTY_DIMS·.02 가드·search-before-mint) · **PASS**

**pricing.py 코드 직접 검증:**

| 계약 | 코드 라인 | 설계 인용 | 검증 |
|------|-----------|-----------|------|
| frm_typ 미참조·공식=합산 | docstring :1-9·NON_QTY_DIMS :38 | 정확 | ✓ frm_typ_cd 컬럼 부재·prc_typ로 분기 |
| siz_cd·mat_cd·bdl_qty NON_QTY 정확매칭 | :38-39·`_row_matches` :78-90 | 정확 | ✓ siz_cd/mat_cd 정확매칭·행 NULL=와일드카드(팩 mat 빈값→와일드카드) |
| 이산 siz_cd no_match(면적 ceiling 아님) | :129-130 | 정확 | ✓ 후보 0 → `reason:no_match`. siz_width 미사용 → off-grid ceiling 미발생 |
| ERR_AMBIGUOUS(2조합↑) | :136-138 | 정확 | ✓ siz059·mat153·min3 조합 1개(라이브 확인) |
| .01 unit×qty | :191-192 | 정확 | ✓ |
| .02 ÷tier_min_qty·NULL=ValueError | :185-190 | 정확 | ✓ `base≤0` ValueError(:187-188)·.02 NULL min_qty 0행(라이브 전수)→안전 |
| 할인 순서 ①comp ②수량구간 ③등급 | :471-536 | 정확 | ✓ 단 스티커 t_dsc 바인딩 0행(현재 ②③ skip) |

**★E4 핵심 결판:**
1. **B06 팩 prc_typ .02 결판(cartographer↔benchmark 충돌)**: `SELECT prc_typ_cd FROM t_prc_price_components WHERE comp_cd='COMP_STK_PACK'` = **PRICE_TYPE.02**(designer 주장 신뢰 없이 직접 SELECT). → cartographer/designer 정확·benchmark "54배 왜곡" stale. 팩 qty54 = 4000÷54×54 = 4,000(폭발 부재). ✓
2. **재바인딩 교정 = search-before-mint 충족**: G-STK-1(154→153·243→162)·G-STK-2(SIZ_172→SIZ_520) 전부 **이미 실재 코드**(mat153/162 del_yn=N·SIZ_520 실재) 재바인딩 → 신규 mint 0. 라이브 확인. ✓
3. **del_yn=Y 소재 가드**: MAT_000154(유포지) del_yn=Y(논리삭제) 직접 확인 → "deleted 자재에 단가행 추가 = 스키마 의도 위반·정답은 정본 153 재바인딩"이 정확. ✓
4. **.02 ValueError 안전**: `.02 AND min_qty IS NULL/≤0` = 0행(전수) → 타투/팩 min_qty=3/54 명시·신규 .02 INSERT 시 min_qty 명시 가드(§3-4) 정확. ✓
5. **채번/FK**: 신규 코드 0(재바인딩만). G-STK-3 (b)단가행 INSERT·064 전용 siz 채번은 MAX+1 컨벤션 명시. FK 위상(comp→배선→바인딩) 라이브 정합. ✓

★ **단 E4 보강(E1 누락 연계)**: 053/054 siz↔mat 교차바인딩 no_match는 엔진 계약 위반이 아니라 **데이터 정합 결함**(엔진은 정확히 no_match 반환). 교정안이 052와 달라야 함(siz 재바인딩 170/172/196→059/060 또는 mat162/163 단가행 520/170 적재)은 E1 보정 요구로 라우팅(엔진 건전성 자체는 PASS).

---

## E5 — 세트(반제품) 조합 정합 (이중계상·구성품 누락·번들 할인) · **PASS**

**재현 SQL:** `SELECT count(*) FROM t_prd_product_sets WHERE prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';` → **0**

- **세트 레이어 불요 라이브 확정**: 스티커 t_prd_product_sets **0행** → 명시적 세트(부품 합산) 부재. 디지털 엽서북(내지+표지 별 SKU)·책자(표지+내지+제본) 같은 다본체 조합 없음. set-product-design §11 판정 정확. ✓
- **타투/팩 = 단일본체 묶음단위(부품 합산 아님)**: 타투(COMP_STK_TATTOO·.02·min3·4000)·팩(COMP_STK_PACK·.02·min54·4000) 각 comp 1개·단일소재. `÷min_qty×수량` 장당 환산이지 여러 본체 합산 아님. set-pricing P-8b "묶음 총액형" 정합. ✓
- **이중계상 구조적 부재**: comp 1개·세트 0 → 부품 합산 자체가 없어 이중계상 불가. ✓
- **번들 할인 오류 부재**: 스티커 t_dsc 바인딩 0행(라이브) → 묶음 단가(.02 ÷min_qty) 내장 볼륨할인과 t_dsc 이중할인 위험 현재 부재. 단 향후 t_dsc 바인딩 시 단가행 min_qty 36단 + t_dsc 이중할인 점검(Q-STK-DSC1 정합). ✓

---

## E6 — 골든 재현 (설계 공식으로 실제 재계산·허용오차 0) · **PASS**

`recompute-log-sticker.md` 전 단계. pricing.py 충실 재구현 + 라이브 단가행 verbatim.

| GC | 명제 | 재계산 | 라이브/골든 | 일치 |
|----|------|--------|-------------|------|
| GC-STK1 | 124x186 유포 단가행 5900(qty3구간)·6000(qty1) | 라이브 verbatim | 5900/6000 | ✓(단가행값·CV-STK-G1 최종가 표기 LOW) |
| GC-STK2 | 타투 qty9=12,000(4000÷3×9) | 12,000 | 12,000 | ✓ |
| GC-STK3 | 팩 qty54=4,000(4000÷54×54)·.02 확정 | 4,000·.02 | 4,000 | ✓(54배 왜곡 부재) |
| GC-STK4 | 합판도무송 18,000~189,900·370행 | 라이브 범위/행수 | 동일 | ✓ |
| GC-STK5 | 055 mat154(del_yn=Y) no_match→153 재바인딩 4,000 | no_match·SIZ_172×153=4000 | — | ✓ |
| GC-STK6 | 052 SIZ_172=4000 오청구→SIZ_520=5000 | 4000·5000 verbatim | — | ✓(돈크리티컬) |
| GC-STK7 | A6/100x140 단가행 0 no_match(062 active 보강) | SIZ_196/058=0행 | — | ✓ |
| GC-STK8 | 064 잠정·굿즈 siz 036/043 의미혼선 | use_yn=N·굿즈 note verbatim | — | ✓ |

- **정상 골든(GC-STK1~4) 단가행 값 전건 허용오차 0 일치.** 결함 골든(GC-STK5~8) 전건 입증.
- **★CV-STK-G1(LOW·산식은 옳음)**: GC-STK1의 "기대 골든 5,900/6,000"은 **단가행 unit_price(가격표 셀)**이지 evaluate_price **최종 견적가**(×qty)가 아니다. `.01` 산식상 evaluate_price(qty3) = 5900×3 = 17,700·evaluate_price(qty1) = 6,000. 단가행 값 자체는 라이브 verbatim 100% 일치이고 designer가 "단가행 verbatim"으로 정확히 표기했으나, 골든표 헤더 "기대 골든"이 최종가로 오독될 여지 → 표기 정밀화 권고(GC-STK2/3 .02는 ÷min_qty×qty 최종가라 의미 다름·혼동 방지). 가격 무영향·산식 정확.
- **갈린 지점 0**: 정상 케이스 단가/prc_typ/엔진 산식 일치. 불일치는 전부 바인딩 정합(G-STK-1~4 + 신규 053/054)이지 단가/엔진/prc_typ 오류 아님(designer 명제 정합).

---

## E7 — 생성-검증 독립성 (self-approve·dodge-hunt·라이브 독립 재실측) · **PASS**

- **핵심 명제 라이브 독립 재실측**: ① COMP_STK_PACK prc_typ=.02(designer 주장 신뢰 없이 직접 SELECT·B06 결판) ② MAT_000154 del_yn=Y(information_schema/테이블 직접) ③ mat154/243/167 단가행 0행 ④ 052~067 siz/mat 바인딩 전수 ⑤ SIZ_172=4000·SIZ_520=5000 ⑥ 16/16 공식 바인딩·comp 1개씩. 전건 designer 정확 확인.
- **★dodge-hunt 적발**: designer가 G-STK-2/3로 "052/053/054"를 묶었으나, 독립 교차바인딩 실측(siz×mat 분포)이 **053/054의 투명/홀로 단가행이 059/060에만 적재돼 052와 교정 경로가 다름**(054 전건 no_match)을 발굴 — designer 결함 카탈로그 누락. designer가 미확정을 GO로 가린 게 아니라(누락이지 위장 아님), 검증이 카탈로그 완전성을 보강.
- **골든 충실 재구현**: pricing.py 산식(:185-192·:78-90·:129-130·round_won)을 충실 재구현해 .02 타투/팩 독립 산출·.01 단가행 verbatim 대조(설계 재유도 아님).
- **순환참조 차단**: 골든값 출처=라이브 단가행 verbatim(designer 생성값 아님). dodge·self-approve 없음.
- **freshness 점검**: COMP_STK_PRINT max_reg=2026-06-17 15:55·max_upd=2026-06-17 14:14 = design 기술과 일치·작업 중 드리프트 0.

---

## 라이브 freshness (드리프트 점검)

| 객체 | 라이브 실측 | 설계 기술 | 정합 |
|------|-------------|-----------|------|
| COMP_STK_PRINT | .01·2694행·mat 7종 | 동일 | ✓ |
| COMP_STK_PACK prc_typ | PRICE_TYPE.02·min54·4000 | .02 | ✓ |
| COMP_STK_TATTOO | .02·siz060·mat167·min3·4000 | 동일 | ✓ |
| MAT_000154 del_yn | Y(논리삭제) | Y | ✓ |
| 공식 바인딩 052-067 | 16/16 | 16/16 | ✓ |
| formula_components | 공식당 comp 1·addtn_yn=Y | 동일 | ✓ |
| siz_width 사용 | 0 | 0 | ✓ |
| 스티커 sets/t_dsc 바인딩 | 0/0 | 0 / (Q-STK-DSC1) | ✓ |
| 053/054 siz↔mat 교차 | 054 전건 no_match·053 172만 | §4-2 G-STK-2b/2c 명시(보정-1) | ✓ RESOLVED |
| SIZ_520 mat 커버리지 | 084·153·155·156·242만(162/163 부재) | "일괄 교정 함정"(4-2b) | ✓ |
| 052 A4/A6 단가행 | 172=mat153만 6단·196 전건 0 | "052 정상 아님"(4-2a) | ✓ RESOLVED |
| import xlsx A4 반칼 투명/홀로 | 6,000(36단·SIZ_172 "A4(2판)") | "A4 반칼 6,000 verbatim" | ✓ |
| 16/16 바인딩·comp 1개씩(보정 후 회귀) | 16/16·각 공식 comp 1 | 무변경 | ✓ 새 결함 0 |
| upd_dt/reg_dt | 2026-06-17 15:55/14:14 | 2026-06-17 | ✓ 무드리프트 |

설계↔라이브 어긋남: **0건**(보정-1로 053/054 교차바인딩 + 052 재판정 RESOLVED). CV-STK-G1 골든 표기(LOW)는 designer 폐루프 완료(GC-STK1 단가행/최종가 구분). 날조 0·추측 0.

---

## 컨펌큐 (재게이트 후 — 보정-1 카탈로그 진입 완료·잔여=교정경로 택1 인간/실무 컨펌)

| # | 미해소(차단 아님·인간 승인 큐) | 누가 | 영향 |
|---|--------|------|------|
| **CV-STK-053/054**(보정-1 RESOLVED→교정경로 택1 컨펌) | ★결함 카탈로그·교정 경로는 §4-2c로 확정(라이브+import xlsx 검증). **잔여 택1**: (A5) 059 추가 바인딩(경로 a·mint 0·권고) vs 170에 mat162/163 36단 적재(경로 b·059 verbatim) / (A4) SIZ_520 재사용 + mat162/163 36단 적재(import xlsx verbatim 6,000) vs 신규 채번 / (A6) 바인딩 제거(확정) | dbm-price-arbiter·인간 승인 | 🔴 돈크리티컬(054 active·실 적재 시 해소) |
| **CV-STK-A4-MAP**(검증 신규·컨펌) | import xlsx은 A4 반칼을 **SIZ_172("A4(2판)")** 에 직접 매핑(라벨 변별)·designer는 SIZ_172 낱장 collision 회피 위해 **반칼 전용 siz 분리**(SIZ_520 재사용) 제안. 둘 다 가격 동일(6,000)·후니 round-23 SIZ_520 precedent 정합이나 webadmin 적재 단위 택1은 실무 컨펌(siz_label 변별 vs siz_cd 분리) | dbm-price-arbiter·실무 | 가격 무영향·적재 구조 택1 |
| Q-STK-MAT1 | 055/057 mat 153 재바인딩 시 SIZ_172×153=4000(낱장 B02·반칼 5000 아님) 확인 — 라이브 검증 완료(정합) | dbm-price-arbiter | 완칼 B02 정합(확인됨) |
| Q-STK-SIZ1 | A6(196)·100x140(058) 실판매 사이즈인가(바인딩 제거 vs 단가 출처)·062 active no_match | dbm-price-arbiter | G-STK-3 추측 적용 금지 |
| Q-STK-064 | 064 소형반칼 실측 단가·굿즈 siz(036/043) 재사용 해소(전용 siz 채번)·활성화 전 | 실무·채번 | G-STK-4(use_yn=N·긴급도 낮음) |
| Q-STK-DSC1 | 단가행 min_qty 36단 + t_dsc 이중할인 점검·스티커 t_dsc 바인딩(현 0행) | dbmap round-1 | 할인 순서(현재 t_dsc 0) |
| Q-STK-TAT1/PACK1 | 타투 base 2000(1~2장)·팩 수량 입력 장/세트 UX | 실무 | 정상 경로 GO·컨펌 |
| CV-STK-G1(검증·LOW) | GC-STK1 "기대 골든 5,900/6,000"=단가행값(가격표 셀)이지 .01 최종가(×qty) 아님 — 표기 정밀화 | designer | LOW·가격 무영향·산식 정확 |

---

## 보정 요구 (재게이트 결과)

**차단 결함(NO-GO) 0건. 보정 요구 0건(보정-1 RESOLVED).**

- **보정-1(🔴 돈크리티컬·E1) — RESOLVED**: 053/054 siz↔mat 교차바인딩 no_match + 052 재판정을 designer가 §4-2(4-2a/2b/2c·G-STK-2a/2b/2c)에 명시 추가·일괄 교정 함정·사이즈축별 분리 경로·052≠053/054 분리 산출. 독립 라이브 + import xlsx 재실측이 전건 입증(SIZ_520 trap·052 정상아님·054 전건 no_match·6,000/7,000 verbatim·A6 추측 금지). **CONDITIONAL→PASS.**
- **정정-1(LOW) — RESOLVED**: GC-STK1 골든표 "기대 골든 5,900/6,000"을 designer가 "단가행 unit_price(가격표 셀)"로 명시(.01 최종가=×qty·GC-STK2/3 .02 의미 다름 구분). 문서 폐루프 완료·가격 무영향.

잔여(차단 아님·인간/실무 컨펌큐): CV-STK-053/054 교정경로 택1·CV-STK-A4-MAP siz_label vs siz_cd 분리·Q-STK-SIZ1(A6 출처)·Q-STK-064(064 활성 전)·Q-STK-DSC1(t_dsc 이중할인). 전건 dbm-price-arbiter 심의 + 인간 승인 후 dbmap 적재(추측 0).

## 라우팅

- **교정 실 적재(G-STK-1~4 + 053/054 경로 a/b/c)** → 인간 승인 후 dbmap(dbm-price-arbiter 심의·dbm-axis-staged-load ②사이즈·④자재·dbm-load-execution). 멱등·백업·undo. 신규 mint 0(059/SIZ_520 재사용)·단가행 INSERT는 import xlsx verbatim(날조 0). 🔴 054 active 우선.
- **CV-STK-A4-MAP(SIZ_172 라벨변별 vs 반칼 전용 siz 분리)** → dbm-price-arbiter·실무 컨펌(가격 동일·적재 구조 택1).
- **G-STK-3 A6/100x140·064(Q-STK-064)** → dbm-price-arbiter·실무 컨펌(추측 적용 금지·라이브+import xlsx 부재 확인).
- **codex 2차(Phase 5.5·스티커)** → 오케스트레이터 reconcile(본 재게이트 판정 독립·codex 비참조).

## DB 미적재 [HARD]

본 재게이트는 라이브 읽기전용 SELECT + import xlsx(권위) 대조만 수행·DB 쓰기 0·webadmin 코드 수정 0. 모든 결함 교정(재바인딩·siz 분리·단가행 적재·바인딩 제거)은 인간 승인 후 dbmap 위임.
