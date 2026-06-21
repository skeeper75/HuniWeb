# 캘린더(달력) 흡수 후보 — 경쟁사 가격계산 방식 벤치마크 (9번째 종단)

> `hpe-benchmark-analyst` 캘린더 종단. designer가 바로 쓸 수 있게 **흡수 후보·후니 t_prc_* 매핑·우선순위·trade-off·naming 유입 가드**로 정리.
> **중복 금지**: 기존 `competitor-pricing-models.md` §7/§8·`absorption-candidates-booklet.md`·`absorption-candidates-goods-pouch.md`는 보존(재유도 0)·본 파일이 캘린더 전용.
> **흡수 vs 답습[HARD]**: 메커니즘만 흡수 · naming/codes(offset2023/vTmpl/tiered/tmpl_price/CLD_STD/RIN_DFT/STA_CLD) 후니 유입 금지 · 권위 엑셀 최종 · 경쟁사 주장=가설.

## 출처
- `[red:cal]` = `_workspace/huni-widget/05_qa/captures/s6_cal_*.json` (5 SKU 라이브 가격분해 실측).
- `[huni:cal]` = `_workspace/huni-dbmap/06_extract/calendar-l1.csv`(상품마스터 권위) · `[huni:bind]` = price-binding-l1.csv B03(가격표 권위).
- `[model]` = `02_benchmark/competitor-pricing-models-calendar.md`(본 종단 §1~5).
- `[huni:prior]` = §7/§8 모델·booklet/goods 흡수 후보(재사용).

---

## 0. 흡수 판정 요약 — 새 축 0 / 배선·가드 후보 2 / 컨펌큐 1

| # | 경쟁사 패턴 | 후니 권위가 담는가 | 판정 | 우선순위 |
|---|-------------|-------------------|------|----------|
| A | `offset2023_price` PCS 합산(인쇄+제본+거치대 Σ) | ✅ 합산형 디지털 SUM(§7·디지털 종단) | **흡수 불요**(동형) | — |
| B | `vTmpl_price` 개당단가×수량×건수 | ✅ 개당단가형 product_price×qty(GP-1) | **흡수 불요**(동형) | — |
| C | `tiered_price` 수량구간 단가표 | ✅ 수량구간할인 t_dsc_*(굿즈/문구) | **흡수 불요**(동형) | — |
| D | `tmpl_price` edicus 완제 SKU | ✅ 고정가형 완제 SKU(GP-1·디자인캘린더) | **흡수 불요**(동형) | — |
| **AC-1** | **제본/거치대 = 부당×수량 매트릭스 단가**(RedPrinting 실측·사이즈/수량 종속) | △ B03 그릇 실재·**미배선** | **흡수 후보(배선·data-gap)** | **High** |
| **AC-2** | **캘린더가공 inline 고정가 add-on**(삼각대/링/타공/거치대) | ✅ 상품마스터 추가가격·LINEN_FINISH 그릇(GP-2) | **흡수 후보(평탄화 가드)** | **High** |
| CQ-1 | 제본/가공 가격 그릇 이중성(inline 고정가 vs B03 매트릭스) | 두 그릇 다 권위 실재 | **컨펌큐(인간 결정)** | High |

★**price_gbn 4분기(엔진 라우팅) = 새 가격축 아님**: 후니 frm_cd(상품→공식 바인딩)로 이미 표현. rpmeta TP 종단 "인쇄방식=#12 기존축·새 축 부결"·§7 "엔진 선택자=공식 라우팅 enum" 정합. 신규 t_prc_* 테이블/축 mint **0**.

---

## AC-1. 제본/거치대 부당×수량 매트릭스 단가 (흡수 후보·High) ★

### 경쟁사 메커니즘 `[red:cal]`
RedPrinting `offset2023_price`에서 삼각대(CLD_STD)·제본(RIN_DFT)·타공(HOL_DFT)이 **사이즈별 단가표 × 수량**으로 산정(§1.2 실측: 삼각대 297,000원@세로형500부 → 198,000원@narrow500부). 즉 **거치대/제본 = 개당 고정가가 아니라 사이즈·수량 종속 단가 룩업**.

### 후니 그릇 — 이미 실재 (data/배선-gap·vessel-gap 아님)
| 항목 | 후니 권위 `[huni:bind]` | 매핑 |
|------|------------------------|------|
| B03 캘린더 제본비 | 제본/수량 매트릭스(벽걸이/탁상220/탁상130/미니 × 1·4·10·50·100·1000부·부당가·삼각대 포함) | **`t_prc_component_prices`** 단가행(use_dims=[제본방식, min_qty]) |
| 제본 comp | `COMP_BIND_*`/CAL_* 계열(`.04 공정비`·수량구간 min_qty)`[huni:prior]` | 제본비 구성요소 |
| 공식 | 합산형(`addtn_yn='Y'` Σ) | 본체 디지털 SUM + 제본비 가산 |

### 흡수 = 배선(설계 입력)
- **B03 부당×수량 매트릭스를 component_prices use_dims=[제본방식, min_qty]로 적재**하고 **본체 디지털 SUM 공식에 제본비 항을 합산 배선**. RedPrinting이 "거치대/제본=사이즈/수량 종속 단가"임을 실증 → 후니 B03이 동형 표현(제본방식×수량 부당가).
- ★**trade-off / 돈크리티컬**: B03 단가 의미 = **부당(권당)** `[huni:bind A2 '제본/수량']`. prc_typ가 **.01 단가형(부당×수량)** 인지 **.02 합가형(묶음총액÷수량)** 인지 **엔진 계약 확정 선결**(디지털·아크릴·스티커 종단 동일 클래스). 부당가를 합가형으로 오적재 시 ÷수량 붕괴(스티커 052/053 함정·굿즈 묶음 .01 선례). **B03=부당가이므로 .01 단가형 ×수량이 정답**(권위 검증 필수).
- **naming 가드**: CLD_STD/RIN_DFT/HOL_DFT/offset2023 후니 유입 금지 → 후니 comp_cd(제본방식 한글 표준)·frm_cd로 번역.

---

## AC-2. 캘린더가공 inline 고정가 add-on — 평탄화 가드 (흡수 후보·High) ★

### 경쟁사·후니 동형
- RedPrinting `vTmpl_price`(TPCLWLB) = 개당단가×수량(가공 PCS=0 합산) — 가공이 단가에 baked. 후니 상품마스터 캘린더가공_추가가격(2000원 트윈링·4000원 우드거치대·1000/1500원 타공) = **inline 고정가 add-on**(굿즈 GP-2 변형고정가·상품악세사리 AC-2와 동형).

### 후니 매핑
| 가공 | 추가가격 | 후니 그릇 |
|------|----------|-----------|
| 고리형트윈링제본 | 2,000원 | add-on comp(`COMP_CALOPT_*` 계열·LINEN_FINISH opt_cd 그릇 재사용)·use_dims=[opt_cd] |
| 우드거치대 | 4,000원 | add-on comp(거치대=부속물·rpmeta PD addons 정합) |
| 1구/2구타공+끈 | 1,000/1,500원 | add-on comp(타공+부자재 BUNDLE) |
| 삼각대(컬러) | 기본 포함/0 | 본체 포함(별 가산 없음) 또는 B03 매트릭스(AC-1) |

### ★돈크리티컬 가드 (굿즈 GP-2·상품악세사리 AC-2 선례 동형)
- **G-CAL-1 평탄화 함정**: 캘린더가공이 variant별 고정가(트윈링2000 vs 거치대4000)인데 단일 평탄 적재 시 가공 선택과 무관하게 한 값 오청구 → **가공축 use_dims 충전 필수**(opt_cd 차원).
- **G-CAL-2 PRODUCT_PRICE 선점 가드**(GP-2 선례·codex 독립발견): 본체를 product_prices 1건으로 적재하면 FORMULA(가공 가산) 통째 우회 silent → **본체 디지털 SUM은 formula 바인딩만·product_prices INSERT 금지**.
- **G-CAL-3 inline 가산 ×수량 여부**(컨펌큐 Q-CAL-FIN): 추가가격(2000원)이 **개당 가산**(×수량)인지 **주문당 정액**인지 — 상품마스터 명시 부족·돈크리티컬(굿즈 Q-GP-FIN1 동일 미해소). RedPrinting 실측은 가공이 사이즈/수량 종속(개당) 경향 → 개당 가산 가설이나 **권위 검증 필수**.
- **naming 가드**: vTmpl/STA_CLD/edicus 후니 유입 금지.

---

## CQ-1. 컨펌큐 — 제본/가공 가격 그릇 이중성 (인간 결정) ★

후니 권위에 **캘린더 제본/가공 가격을 담는 그릇이 둘** 공존:
1. **상품마스터 캘린더가공_추가가격**(inline 고정가·2000/4000/1000원·삼각대 기본 포함) — 디자인캘린더·디지털 캘린더용으로 보임.
2. **가격표 B03 캘린더 제본비**(부당×수량 매트릭스·삼각대 포함) — 옵셋·대량 캘린더용으로 보임.

★**designer/인간이 상품별로 어느 그릇이 권위인지 확정**(추측 금지·권위 대조):
- RedPrinting 실측 = **(2) 부당×수량 매트릭스 방향**(삼각대/제본 사이즈·수량 종속).
- 상품마스터 디자인캘린더 = **(1) inline 고정가 방향**.
- **두 방향이 상충 시 상품마스터+가격표 교차 대조가 최종 권위**(경쟁사=갭헌팅 보강일 뿐·덮어쓰기 금지). 같은 상품에 두 그릇 단가가 다르면 가격표↔상품마스터 정합 검증 후 채택.

---

## 핵심 흡수후보 Top 3 (designer 공급)

1. **AC-1 — B03 부당×수량 제본/거치대 매트릭스 배선**(High): RedPrinting이 "거치대/제본=사이즈/수량 종속 단가"임을 실증·후니 B03 그릇 동형 실재·미배선. component_prices use_dims=[제본방식, min_qty] + 합산형 공식 가산. **돈크리티컬=prc_typ .01 단가형(부당×수량) 확정**(.02 오적용 시 ÷수량 붕괴).
2. **AC-2 — 캘린더가공 inline 고정가 add-on 평탄화 가드**(High): 굿즈 GP-2·상품악세사리 AC-2 동형. 가공축(트윈링2000/거치대4000/타공1000) use_dims=[opt_cd] 충전·G-CAL-2 PRODUCT_PRICE 선점 가드·본체 formula-only 바인딩.
3. **CQ-1 — 제본/가공 그릇 이중성 인간 결정**(High): inline 고정가(상품마스터) vs B03 매트릭스(가격표) 중 상품별 권위 확정. RedPrinting=(2) 방향이나 후니 권위 교차대조 최종.

★**새 가격축·t_prc_* 테이블 신설 0**(price_gbn 4분기=frm_cd 라우팅으로 흡수·search-before-mint 9연속 통과). 캘린더 계산방식=기존 종단 5방식의 인스턴스(합산형·개당단가·수량구간·고정가)·새 계산방식 0.
