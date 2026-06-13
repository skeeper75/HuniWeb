# 아크릴 분해 설계 (acrylic-decomposition) — round-16 (면적매트릭스형)

> **작성** 2026-06-13 · round-16. 입력 = `acrylic-structure.md`(8블록 해부) + 라이브 `t_prc_*` 실측(2026-06-13 read-only) + `02_mapping/price-formula-types-authoritative.md`(면적매트릭스 권위·off-grid ceiling) + round-14 stale 진단. **분해 기준 = Phase11 가격엔진 `evaluate_price` 매칭 규칙**(보기 좋게 ✗ → 엔진이 먹는 형태 ⭕). **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위, 2026-06-13)

스티커·디지털 파일럿 교훈 적용 — **라이브 실측 선행**(개념설계 `11-CONTEXT` 아님). 실측 결과:

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)          ← frm_typ_cd 없음(라이브 실측 확정)
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd) ← 별 테이블(공식정의와 분리)
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims jsonb, use_yn)
[단가행]     t_prc_component_prices(comp_price_id PK, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd,
                                    coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd)
                                                                                          ↑신설 ↑신설(8→10차원)
```

- **PRICE_TYPE 코드값 실측 확정**(`t_cod_base_codes`): `PRICE_TYPE.01=단가형` / `PRICE_TYPE.02=합가형`.
- **라이브 아크릴 components 실측**: `COMP_ACRYL_CLEAR3T`·`COMP_ACRYL_CLEAR15T`·`COMP_ACRYL_MIRROR3T` 3종, **전건 `prc_typ_cd=PRICE_TYPE.01`(단가형)·`use_dims=["siz_cd"]`·`comp_typ_cd=PRC_COMPONENT_TYPE.01`**.
- **그릇 엑셀 시트** = `1_price_formulas` + `1b_product_price_formulas` + `2_formula_components` + `3_price_components`(RU 3 + 신규 코롯토/카라비너) + `4_component_prices_RU`(라이브 121행 재현) + `4b_component_prices_GAP`(siz 미채번 좌표) + `5_korotto_NEW`(코롯토 매트릭스) + `6_carabiner_NEW`(고정가) + `7_finishing_options`(후가공 opt) + `8_BLOCKED`.

---

## 1. 공식 매핑 (아크릴 = 면적매트릭스형 — 스티커/디지털과 근본 차이)

면적매트릭스형은 **수량축이 없다**. `siz_cd`(가로×세로 면적) 1개 차원이 단가를 가른다. 주문수량은 **단가형 곱셈**(`단가 × 주문수량`)으로만 작동(수량할인은 별도 t_dsc).

| frm_cd(제안) | 대상 자재 | 구성요소(Σ) | 라이브 상태 |
|---|---|---|---|
| `PRF_ACRYL_CLEAR3T`(신규) | 투명아크릴3T 본체 | `COMP_ACRYL_CLEAR3T`(+후가공 opt 합산) | 🔴 comp 적재됐으나 **공식·배선 0** |
| `PRF_ACRYL_CLEAR15T`(신규) | 투명아크릴1.5T 본체 | `COMP_ACRYL_CLEAR15T` | 🔴 동일 |
| `PRF_ACRYL_MIRROR3T`(신규) | 미러아크릴3T 본체 | `COMP_ACRYL_MIRROR3T` | 🔴 동일 |
| `PRF_ACRYL_COROTTO`(신규) | 아크릴코롯토 | `COMP_ACRYL_COROTTO`(신규) | ❌ 전건 미적재 |
| `PRF_ACRYL_CARABINER`(신규) | 아크릴카라비너 | `COMP_ACRYL_CARABINER`(신규·고정가형) | ❌ 미적재 |

> **🔴 가격사슬 단절(핵심 발견·structure §4)**: 라이브 `t_prc_formula_components`에 `COMP_ACRYL_*` 배선이 **0행**. 즉 단가행은 있으나 어느 공식에도 연결 안 됨 → 엔진이 아크릴 본체 가격을 조회할 경로 **없음**(메모리 [[dbmap-price-chain-dwire-per-product-formula]]). round-2가 단가행만 적재하고 공식 사슬을 미완성. **round-16 그릇은 공식정의+배선+상품바인딩을 신규로 제안해 사슬을 완결**한다(단가행 재적재 ✗ — 재현만).

> **혼동 주의**: `PRD_000142 유광아크릴스티커`·`PRD_000143 미러아크릴스티커`는 `PRF_POSTER_FIXED`(포스터사인 영역)에 바인딩됨 — 이 시트의 아크릴 **본체 매트릭스와 다른 트랙**(아크릴스티커 ≠ 아크릴 본체). 본 분해는 본체 매트릭스 대상.

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심)

판별 근거 = 가격표 단위 표기 + 라이브 실측.

| 구성요소 | prc_typ_cd | 근거 | 엔진 계산 |
|----------|-----------|------|----------|
| `COMP_ACRYL_CLEAR3T/15T/MIRROR3T` | **.01 단가형** | 라이브 실측 전건 `PRICE_TYPE.01`. 매트릭스 셀 = **개당 면적단가**(수량구간 없음·제목 "통용 단가"). | `면적단가 × 주문수량` |
| `COMP_ACRYL_COROTTO`(신규) | **.01 단가형** | 코롯토도 가로×세로 개당단가(B06 매트릭스·수량축 없음) | `면적단가 × 주문수량` |
| `COMP_ACRYL_CARABINER`(신규) | **.01 단가형** | 카라비너 옵션별 고정단가(개당)·수량구간 없음(별 t_dsc) | `고정단가 × 주문수량` |

- **합가형(.02) 없음** — 아크릴 전 구성요소가 개당 면적·고정단가(단가형). 스티커 타투/팩(세트 총액=합가형)과 달리 **구간총액·세트 단위 표기 없음**. 라이브 실측이 `.01`로 확정(추정 아님).
- **수량할인은 prc_typ가 아니라 t_dsc**(§5) — 단가형 단가에 곱셈 후 구간할인 적용은 엔진 별 단계.

---

## 3. 🔴 면적매트릭스 → siz_cd long-form 분해 (면적-좌표 회귀 금지)

```
B01 매트릭스 셀 (가로 g, 세로 s) = 단가 p
  → component_prices row:
     comp_cd=COMP_ACRYL_CLEAR3T, siz_cd=<(g,s) 규격코드>,
     clr_cd=NULL, mat_cd=NULL, proc_cd=NULL, coat_side_cnt=NULL, opt_cd=NULL,
     bdl_qty=NULL, min_qty=NULL, unit_price=p, apply_ymd='2026-06-01'
```

- **[HARD] 면적-좌표 회귀 금지**(메모리 [[dbmap-price-formula-types-authority]]): 매트릭스를 면적함수(R²)로 적합하지 않음. **격자 단가를 (siz_cd, unit_price) 행으로 언피벗**(라이브 실측 적재방식과 동일). off-grid는 §6 ceiling 런타임.
- **use_dims = `["siz_cd"]`**(라이브 실측). 나머지 9차원 전부 NULL(와일드카드). min_qty도 NULL = 수량 무관(면적매트릭스 특성).
- **🔴 좌표 방향성 주의**: 라이브 siz_nm 비대칭 2쌍(`50x30` 등)에서 라이브값 = 엑셀 **세로×가로** 셀값(라이브 `50x30`=3800=엑셀 30(가로)×50(세로)). 매트릭스가 거의 대칭(asym 2쌍만)이라 무손실은 보존되나, **siz_cd 좌표 라벨 방향(가로우선 vs 세로우선)을 등록 시 확정**해야 비대칭 좌표가 정확. 컨펌 Q-ACR-4.

### 무손실 검산 (P3·P6 예비)
| comp | 엑셀 데이터셀 | 엑셀 unique(대칭병합) | 라이브 물리행 | 라이브 canon | GAP(canon 미적재) | 손실위험 |
|------|--------------|----------------------|--------------|-------------|------------------|---------|
| CLEAR3T | 196 | 105 | 47 | 39 | 66 | **0** |
| CLEAR1.5T | 81 | 45 | 37 | 30 | 15 | **0** |
| MIRROR3T | 81 | 45 | 37 | 30 | 15 | **0** |
| 코롯토 | 36 | 21 | 0(미적재) | 0 | 21(=`5_korotto_NEW`) | — |

→ **무손실 완결(canonical 검산)**: `엑셀 canon = 라이브 canon(RU) + GAP`, **라이브에 있고 엑셀에 없는 좌표 = 0**(round-trip 보존). 라이브 물리행(121 = canon 99 + 비대칭 양쪽 22)이 canon보다 많은 건 비대칭 좌표(`50x30`·`30x50`)를 양방향 적재한 것. 가격 "불일치" 3건(comp당 1)은 비대칭 좌표 방향성(라이브 `50x30`=엑셀 30(가로)×50(세로)값)이지 손실 아님 → §3 좌표 방향성 주의·Q-ACR-4.
> **그릇 시트 분배**: `4_component_prices_RU`=라이브 물리 121행 재현 · `4b_GAP`=canon 미적재 96 · `5_korotto_NEW`=코롯토 21조합.

---

## 4. use_dims (구성요소별 차원 집합 — 라이브 실측 재현 + 신규)

| comp_cd | use_dims | 안 쓰는 차원(NULL) |
|---------|----------|-------------------|
| `COMP_ACRYL_CLEAR3T/15T/MIRROR3T` | `["siz_cd"]`(라이브 실측) | clr·mat·proc·coat·opt·bdl·**min_qty**(수량무관) |
| `COMP_ACRYL_COROTTO`(신규) | `["siz_cd"]` | 〃 |
| `COMP_ACRYL_CARABINER`(신규·고정가) | `["opt_cd"]` 또는 `[]` | 형상=opt_cd로 단가분기. siz 아님(완제 고정) — 컨펌 Q-ACR-2 |

- **clr_cd=NULL**: 매트릭스 제목 "양면9도/단면7도 통용 단가" = 도수 무관 단가(별색=공정 규칙·[[dbmap-digitalprint-atomic-formula-unbuilt]]).
- **mat_cd=NULL**: 자재(투명3T/1.5T/미러)가 **구성요소명에 박혀있음**(CLEAR3T/CLEAR15T/MIRROR3T 별 comp) → mat_cd 차원 미사용. 디지털 별색(SPOT_*)과 같은 패턴(자재가 차원 아니라 구성요소 분기).
- **min_qty=NULL**: 면적매트릭스는 수량축 없음 — 디지털/스티커(min_qty 사용)와 결정적 차이.

---

## 5. 구간할인(B04·B08)은 가격 그릇 제외 (round-1 t_dsc 영역)

| 블록 | 내용 | round-16 처리 |
|------|------|--------------|
| **B04** 아크릴 수량구간할인(A49:B56) | 6구간 0/10/20/30/40/50% | **그릇 제외** — round-1 `t_dsc_*` 영역(가격 t_prc 아님). 메모리 dbmap-discount-authority |
| **B08** 카라비너 수량구간할인(D102:E107) | 3구간 0/10/20% | **그릇 제외** — round-1 `t_dsc_*` |

> **이유**: Phase11 엔진은 `단가 × 수량` 후 별 단계로 수량할인(t_dsc) 적용. 구간할인은 t_prc 4테이블에 안 들어감. round-1이 아크릴 할인 그룹을 이미 매핑(미적재). round-16 그릇은 **단가매트릭스만** 담음. 구간할인 블록은 부유 참조로 보존(침묵 삭제 금지)하되 그릇 행으로 변환 안 함.

---

## 6. off-grid ceiling (런타임 규칙 — DB 미저장)

- **off-grid = 가로×세로가 매트릭스에 정확히 없으면 → 한 단계 큰 크기 가격**(round-2 권위·메모리 [[dbmap-compute-in-app-db-stores-lookup]]).
- **DB는 격자 단가만 저장**, off-grid 선택은 엔진/위젯 런타임 계산(중간계산=앱·DB=룩업 철학). 그릇에는 ceiling 행을 만들지 않음(과적재 금지).
- 그릇 README·mapping-flow에 ceiling 규칙 문서화(엔진 계약).

---

## 7. 후가공 옵션(B05)·카라비너 형상(B07) = opt 영역 분리

| 블록 | 내용 | 차원 결정 | 처리 |
|------|------|----------|------|
| **B05** 후가공(키링/뱃지/마그넷/집게/명찰/스마트톡/지비츠/볼펜/머리끈/카라비너고리) | 11 옵션그룹 · 하위값+추가단가 | 🟡 **CPQ opt 영역**(group→item·add_price) — round-6 | `7_finishing_options` 시트(참조)·**가격 구성요소 아님**(옵션 추가단가는 가격엔진 합산 or CPQ add_price 컨펌 Q-ACR-1) |
| **B07** 카라비너 형상(자물쇠/하트A/하트B/원형) | 4 형상 × 고정단가 | 고정가형 본체 `opt_cd` 분기 or 별 comp | `6_carabiner_NEW`(고정가형 단가행) |

> **후가공 추가단가(B05)의 귀속이 미해소**: 키링 "은색고리 1100" 등이 (a) 가격엔진 component(아크릴 본체 + 고리 합산) 인지 (b) CPQ option_item add_price 인지 — round-6 영역과 경계. round-16 그릇은 **참조 시트로 보존**하고 component 변환은 **컨펌 후**(기계적 분해 금지·round-6 CPQ 경고).

---

## 8. 미적재·갭 정직표기 (HARD)

| 항목 | 상태 | 처리 |
|------|------|------|
| 매트릭스 미적재 좌표 117(siz 미채번 100) | 라이브 부분적재(큰사이즈·비대칭 좌표 다수 누락) | `4b_..._GAP` 시트 — **siz 좌표 채번 요청 후 적재**(round-2 권위 "좌표 siz 등록 요청서") |
| 코롯토 매트릭스 21조합 | 전건 미적재(comp 자체 없음) | `5_korotto_NEW`(신규 comp+단가행 제안·siz 채번 일부 필요) |
| 카라비너 4형상 고정가 | 미적재 | `6_carabiner_NEW`(고정가형) |
| 공식 사슬(formulas·배선·바인딩) | 🔴 라이브 0행(단가행만 있음) | `1`·`2`·`1b` 시트 신규 제안(사슬 완결) |

---

## 9. 자체검산 (recompute sanity — P6 예비)

아크릴키링(PRD_000146·투명3T·20×20mm·1개 주문) 엔진 손계산:
```
본체가 = COMP_ACRYL_CLEAR3T[siz_cd=20x20(SIZ_000336)] = 2500원 (라이브·엑셀 B3 일치)
+ 후가공 = 은색고리(B63) 1100원 (옵션 합산 or CPQ add — 컨펌 Q-ACR-1)
× 주문수량 1
→ 본체 2500 일치 → 매트릭스 그릇 정합 (공식 배선 신규 시 조회가능)
```
off-grid 예: 25×25mm 선택 → 매트릭스 부재 → ceiling 30×30(3100) 적용(런타임·DB 미저장).

---

## 10. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-ACR-1** | 후가공 추가단가(B05 키링고리 등) = 가격엔진 component 합산 vs CPQ option_item add_price | B05 후가공 귀속·가격조립 |
| **Q-ACR-2** | 카라비너(B07) = 고정가 `opt_cd` 단가 vs 별 면적/siz 차원(40x69 등 치수 표기 있음) | B07 모델·use_dims |
| **Q-ACR-3** | 코롯토(B06)는 면적매트릭스(실측) vs round-2 권위 ④ 고정가형 분류 — 어느 쪽 | B06 모델 |
| **Q-ACR-4** | siz_cd 좌표 라벨 방향(가로우선 vs 세로우선) 확정 — 비대칭 2쌍 정확성 | 매트릭스 siz 채번·적재 |
| **Q-ACR-5** | 매트릭스 미적재 117좌표 채번 시점(round-2 "좌표 siz 등록 요청서") — 영구 격자 vs 부분 | GAP 좌표 적재 |
| **Q-ACR-6** | 3 매트릭스 comp 공식 배선 0행 = 의도적 미완 vs 결함 — 공식사슬 신규 승인 | 가격사슬 완결 |

---

## 11. 한 줄 현황

아크릴 분해 설계 완료 — **면적매트릭스형**(스티커 단순형·디지털 합산형과 근본 차이). 4 매트릭스(CLEAR3T/15T/MIRROR3T 라이브 부분적재 + 코롯토 신규)·**단가형 전건(.01·라이브 실측)**·use_dims `["siz_cd"]`(min_qty 무관)·자재=구성요소분기/도수=NULL. **🔴 핵심 발견: 단가행 적재됐으나 공식 배선 0행 = 가격사슬 단절** → 공식+배선+바인딩 신규 제안. 구간할인 2블록=t_dsc 그릇 제외. off-grid=ceiling 런타임. 후가공=opt 영역 참조 보존(컨펌). **무손실: 라이브 121행 전건 엑셀 대조 일치·미적재 117좌표 GAP 정직표기**. 컨펌 6건. **다음 = import.xlsx 빌드 + mapping-flow mermaid → validator P1~P6.**
