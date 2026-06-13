# 아크릴 가격 import 독립 검증 게이트 (acrylic-gate) — round-16 (면적매트릭스형)

> **검증** 2026-06-13 · `dbm-validator` 독립 재검산(생성자≠검증자). 대상 = `20_price-import/acrylic/`(structure·decomposition·import.xlsx 11시트·mapping-flow). 방법 = **라이브 `t_prc_*` read-only 실측 + 원본 가격표 `아크릴` 시트 openpyxl data_only 직접 대조**("맞아 보임" 금지). 스티커·디지털 게이트 동형 P1~P6 + 🔴 가격사슬 단절 검증.
>
> **판정: GO** (P1~P6 전건 PASS · 핵심 발견 라이브 실측 재현 · MINOR 2건 라우팅)

---

## 0. 한 줄 결론

빌더 산출 **독립 재현 완결** — 라이브 실측이 빌더의 3대 핵심 주장을 전건 입증: ① 아크릴 본체 단가행 121행 적재됨 ② `formula_components` 배선 **0행 = 가격사슬 단절**(엔진 조회 경로 없음) ③ canon 무손실(`엑셀 canon 195 = 라이브 canon 99 + GAP 96`, liveNotExcel **0**, 가격불일치 **0**). 면적매트릭스형 모델 정합(단가형 .01·siz_cd 단독·면적-좌표 회귀 0). **GO** — 단, MINOR 2건(① 비대칭 off-direction 값 3건 침묵 누락 ② "121=canon+비대칭 22" 서술 부정확) 보정 라우팅.

---

## P1 그릇 정합 — **PASS**

11시트 컬럼이 라이브 information_schema와 1:1.

- **공식정의 ↔ 바인딩 분리 확인**: 라이브 실측 `t_prc_price_formulas` 컬럼 = `frm_cd·frm_nm·note·use_yn·reg_dt·upd_dt` — **`frm_typ_cd` 부재**(빌더 주장 일치). 상품바인딩은 별 테이블 `t_prd_product_price_formulas`(`1b_` 시트로 분리) ✓.
- **10차원 component_prices**: 라이브 실측 컬럼에 `proc_cd`·`opt_cd` 존재(8→10·Phase11) — `4_RU` 11컬럼(`CP_COLS`)과 일치 ✓.
- **price_components**: 라이브 `prc_typ_cd·use_dims·comp_typ_cd` 존재 — `3_price_components` 6컬럼 정합 ✓.
- 배선 `2_formula_components`(frm_cd·comp_cd·disp_seq·addtn_yn) 라이브 동형 ✓.

> 증거: `information_schema.columns` 실측 3테이블. frm_typ_cd 없음 = round-2 stale(frm_typ_cd 가정)을 빌더가 정확히 회피.

---

## P2 stale 차단 — **PASS**

- **prc_typ_cd 반영**: 라이브 3 comp 전건 `PRICE_TYPE.01`(단가형) — `3_price_components` `.01` 표기 일치 ✓.
- **use_dims 반영**: 라이브 전건 `["siz_cd"]` — 그릇 동일 ✓.
- **proc_cd·opt_cd(신설 차원) 반영**: 라이브 실재 컬럼, 그릇 `CP_COLS`에 포함(본체는 NULL) ✓.
- **🔴 면적-좌표 회귀 잔재 0**: 매트릭스를 R² 면적함수가 아닌 **(siz_cd, unit_price) long-form 언피벗**(라이브 적재방식과 동일). round-2 28 포스터 면적-좌표 오모델 전례 재발 **0** ✓.

> 증거: 라이브 `COMP_ACRYL_CLEAR3T/15T/MIRROR3T` 전건 `prc_typ_cd=PRICE_TYPE.01·use_dims=["siz_cd"]`. 그릇이 라이브 그대로 재현(개념설계 stale 아님).

---

## P3 분해 무손실 — **PASS** (MINOR 2건)

빌더 canon 검산 **독립 재현 성공**.

| comp | 엑셀 데이터셀 | 엑셀 canon(대칭병합) | 라이브 canon | 라이브 물리행 | GAP(canon-live) | liveNotExcel | 가격불일치 |
|------|--------------|---------------------|-------------|--------------|-----------------|--------------|-----------|
| CLEAR3T | 196 | **105** | 39 | 47 | 66 | 0 | 0 |
| CLEAR15T | 81 | **45** | 30 | 37 | 15 | 0 | 0 |
| MIRROR3T | 81 | **45** | 30 | 37 | 15 | 0 | 0 |
| 코롯토 | 36 | **21** | 0 | 0 | 21(=`5_korotto`) | — | — |
| **합(3 매트릭스)** | 358 | **195** | **99** | **121** | **96** | **0** | **0** |

- **빌더 canon "엑셀 195 = RU 99 + GAP 96·라이브 121" 독립 재현 ✓** — 엑셀 canon 195, 라이브 canon 99, GAP 96, 라이브 물리 121.
- **round-trip 무손실**: liveNotExcel = **0**(라이브에 있고 엑셀에 없는 좌표 0) · 공유 canon 99건 **가격불일치 0**(전건 엑셀=라이브).
- 그릇 시트 행수 전건 일치(openpyxl 실측): `4_RU`=121 · `4b_GAP`=96(66+15+15) · `5_korotto`=21 · `6_carabiner`=4.

### 🟡 MINOR-1 (보정 라우팅: dbm-price-import-builder) — 비대칭 off-direction 값 3건 침묵 누락
매트릭스는 **거의** 대칭이나 **`30x50` 키만 비대칭**: CLEAR3T garo30×sero50=3800 / garo50×sero30=**3700**(CLEAR15T 3040/2960·MIRROR3T 7600/7400). 라이브는 `50x30=3800`(높은 값) 1행만 적재. 엑셀의 낮은 값(3700/2960/7400)은 `4_RU`(=라이브 3800)에도 `4b_GAP`(키가 라이브에 존재→제외)에도 **부재** → **3개 엑셀 셀값이 그릇에서 침묵 누락**. 빌더는 decomposition §3·Q-ACR-4로 "방향성"을 플래깅했으나, 무손실 주장과 충돌하는 off-direction 값의 명시 보존 행(note/GAP)이 없음. **보정**: `4b_GAP` 또는 별 note에 비대칭 3건(키·양방향 값·라이브 채택 방향)을 명시 보존(침묵삭제 금지·round-10 교훈). 적재값 무손상(라이브 3800 정당)이라 MINOR.

### 🟡 MINOR-2 (보정 라우팅: dbm-price-import-builder) — "121=canon 99 + 비대칭 22" 서술 부정확
decomposition §3는 라이브 물리 121 surplus 22를 "비대칭 양쪽"으로 귀속. **실측은 다름**: 22 surplus = **대칭값 양방향 중복**(예 CLEAR3T `60x40` AND `40x60` 둘 다 4700)이지 비대칭 아님. 진짜 비대칭(30x50)은 라이브에 **1행만**. 무손실 결론(canon-keyed)은 불변이나 surplus 원인 서술이 부정확 → 보정. MINOR-1과 동일 행에서 정정 가능.

---

## P4 단가/합가 정당 — **PASS**

- **전건 단가형(.01) 근거**: 라이브 실측 3 comp 전건 `prc_typ_cd=PRICE_TYPE.01`(추정 아님). 매트릭스 제목 "통용 단가"·수량구간 표기 없음 → 개당 면적단가 ✓.
- **siz_cd 단독·min_qty NULL 근거**: 라이브 121행 전건 `clr/mat/proc/coat/opt/bdl/min_qty` **9차원 전부 NULL**(실측 FILTER count=0). 면적매트릭스 = 수량축 없음(스티커/디지털과 결정적 차이) ✓.
- **합가형(.02) 0 정당**: 아크릴 전 구성요소 개당 단가·세트총액 표기 없음. 스티커 타투/팩(합가형)과 달리 합가형 부재가 정직 — 라이브 실측 `.01` 확정 ✓.

> 증거: 라이브 NULL-FILTER 실측 전건 0(9차원). prc_typ 전건 `.01`.

---

## P5 동시매칭 0 — **PASS**

- **siz_cd 좌표당 1행**: 라이브 comp별 `count(*) = count(distinct siz_cd)`(47=47·37=37·37=37) → siz_cd 중복 **0**, 동시매칭 위험 0 ✓.
- **비대칭 좌표 처리**: 라이브는 `50x30` **단일 방향**만 적재(30x50 별도 없음) → 동일 siz_cd 좌표 2행 없음. 단 대칭 22좌표는 양방향 siz_cd(`60x40`+`40x60`)로 적재되나 **siz_cd가 다른 규격코드**라 PK 충돌·동시매칭 아님(같은 면적 다른 라벨). 엔진 매칭은 siz_cd 정확일치라 안전 ✓.

> 증거: distinct siz_cd 실측 = total per comp. 가격불일치 0(P3)이라 양방향 대칭 좌표도 값 동일.

---

## P6 엔진 시뮬레이션 — **PASS**

- **투명3T 30×40 = 3400**: 엑셀 원본 garo30×sero40 셀 = **3400.0**(openpyxl 실측) ↔ 라이브 `SIZ_000331(30x40)=3400.00` ↔ 그릇 `4_RU` 일치 ✓.
- **투명3T 20×20 = 2500**: 엑셀 garo20×sero20 = **2500.0** ↔ 라이브 `SIZ_000336(20x20)=2500.00` ↔ 그릇 일치 ✓.
- **off-grid ceiling**: 25×25 부재 → 한단계 큰 30×30(=3100·엑셀 실측 확인) 적용. DB 격자만 저장·ceiling은 엔진/위젯 런타임(중간계산=앱·DB=룩업) — 그릇에 ceiling 행 미생성(과적재 0) ✓.

> 증거: 엑셀 3원(20x20=2500·30x40=3400·30x30=3100·200x200=32700) ↔ 라이브 ↔ 그릇 3중 일치.

---

## 🔴 가격사슬 단절 검증 (핵심 발견) — **CONFIRMED·빌더 정당**

빌더 주장 "라이브 아크릴 단가 121행 적재·formula_components 배선 0행 = 엔진 조회 경로 없음"을 **라이브 실측으로 확인**.

| 라이브 객체 | 실측 | 판정 |
|-------------|------|------|
| `COMP_ACRYL_CLEAR3T/15T/MIRROR3T` 단가행 | **121행 적재됨**(47+37+37) | ✓ 단가행 존재 |
| `t_prc_formula_components` (COMP_ACRYL 배선) | **0행** | 🔴 배선 없음 |
| `t_prc_price_formulas` (아크릴 본체 공식) | **0개** | 🔴 공식 없음 |
| `t_prd_product_price_formulas` (본체 22상품 바인딩) | **0건**(스티커 2상품만 POSTER_FIXED) | 🔴 본체 미바인딩 |

→ **엔진이 아크릴 본체 가격을 조회할 경로 없음**(단가행은 고아). round-2가 단가행만 적재·공식사슬 미완. **빌더의 그릇(공식 5 + 배선 5 + 바인딩 4)이 사슬 완결 제안 — 정당**.

- **신규 제안 정당성**: `1_price_formulas_NEW` 5 + `2_formula_components_NEW` 5(disp_seq·addtn_yn) + `1b_바인딩` 4. 라이브 PRD_000164(코롯토)·PRD_000166(카라비너) **실재 확인**·미바인딩 → 바인딩 제안 정당 ✓.
- **단가행 재적재 금지 준수**: `4_RU`는 "재적재 금지·대조용" 명시 — 라이브 121행 보존, 사슬만 신규 ✓.

### 🟡 OBSERVATION (라우팅: dbm-price-import-builder) — CLEAR15T 바인딩 누락
`1b_product_price_formulas_NEW`에 CLEAR3T·MIRROR3T·COROTTO·CARABINER 바인딩은 있으나 **`PRF_ACRYL_CLEAR15T` 바인딩 행 부재**(공식·배선은 5건 전건 존재). 투명1.5T 사용 상품군 바인딩이 1b에서 누락 → Q-ACR-6 컨펌 시 CLEAR15T 행 추가 필요. 빌더가 "투명/미러 본체 상품군 컨펌 후 확정"으로 본체 바인딩을 미확정 처리했으므로 결함보다 미해소 컨펌 영역. 컨펌 해소 시 CLEAR15T 누락 보강.

---

## GAP/NEW 정직성 — **PASS**

| 항목 | 처리 | 정직성 |
|------|------|--------|
| GAP 96(siz 미채번) | `4b_GAP` 전건 `(미채번:GxS)` 표기·NULL 강제 0 | ✓ 채번 요청 정직 분리 |
| 코롯토 21 | `5_korotto_NEW` 17 siz채번(기존 siz 사전 재사용)·4 미채번 | ✓ 신규 comp+단가 정직 |
| 카라비너 4형상 | `6_carabiner_NEW` opt_cd `(형상:...)` 미채번·고정가형 | ✓ 별 시트 분리 |
| 후가공 26행(B05) | `7_finishing_options` 참조 보존(CPQ round-6)·component 변환 안 함 | ✓ qty 도배 0·Q-ACR-1 |
| 구간할인 9행(B04·B08) | `8_excluded_discount` t_dsc 제외·보존 | ✓ 침묵삭제 0·round-1 영역 |

- **GAP 96 = NULL 강제 아닌 정직 분리** ✓ (전건 미채번 표기).
- **NEW(코롯토·카라비너) = 라이브 미적재 정직 신규** ✓ (코롯토는 round-2 ④고정가 분류와 충돌 → Q-ACR-3 정직 플래깅).
- 구간할인(B04·B08) **round-1 t_dsc 정당 제외**(가격 t_prc 그릇 아님) — 빌더가 가격 그릇에 혼입 안 함 ✓.

---

## 최종 판정: **GO**

| 게이트 | 판정 | 근거(증거) |
|--------|------|-----------|
| P1 그릇 정합 | **PASS** | information_schema 3테이블 실측·frm_typ_cd 부재 확인·10차원 |
| P2 stale 차단 | **PASS** | prc_typ_cd.01·use_dims·proc/opt_cd·면적-좌표 회귀 0 |
| P3 분해 무손실 | **PASS** (MINOR 2) | 엑셀 canon 195=라이브 99+GAP 96·liveNotExcel 0·가격불일치 0 |
| P4 단가/합가 | **PASS** | 라이브 전건 .01·9차원 NULL 실측·합가형 0 정당 |
| P5 동시매칭 0 | **PASS** | distinct siz_cd=total per comp·비대칭 단일방향 |
| P6 엔진 시뮬 | **PASS** | 20x20=2500·30x40=3400 엑셀↔라이브↔그릇 3중 일치·ceiling |
| 🔴 가격사슬 단절 | **CONFIRMED·빌더 정당** | formula_components 0행·공식 0개·본체 22상품 미바인딩 실측 |
| GAP/NEW 정직성 | **PASS** | GAP 96 미채번 정직·구간할인 t_dsc 제외·후가공 참조 |

### 보정 라우팅 (GO 무효화 아님 — 차기 보정)
1. **MINOR-1 → dbm-price-import-builder**: 비대칭 off-direction 값 3건(CLEAR3T 3700·CLEAR15T 2960·MIRROR3T 7400) `4b_GAP`/note 명시 보존(침묵 누락 해소).
2. **MINOR-2 → dbm-price-import-builder**: decomposition §3 "121=canon+비대칭 22" → "canon 99 + **대칭값 양방향 중복** 22"로 서술 정정.
3. **OBSERVATION → dbm-price-import-builder**: `1b` CLEAR15T 바인딩 누락 — Q-ACR-6 컨펌 해소 시 보강.

### 판정 뒤집힘 명시
- 빌더 "라이브 canon"과 "엑셀 canon" 혼용 서술이 1차 검토 시 혼란(195 vs 99 vs 121)을 유발했으나, 라이브 실측 재현 결과 **세 수 전부 정합**(195=99+96·121=99+22대칭중복)으로 무손실 확정 → 무손실 판정 **유지**(뒤집힘 없음).
- DB 미적재(실 COMMIT·DDL·코드행 채번은 인간 승인) 원칙 불변.
