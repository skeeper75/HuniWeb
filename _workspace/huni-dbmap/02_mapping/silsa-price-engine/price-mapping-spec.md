# 일반현수막(PRD_000138) 가격엔진 매핑 설계서 — silsa-price-engine

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-08 |
| 대상 상품 | **일반현수막 PRD_000138** (실사 시트, 면적매트릭스형) |
| 권위 순서 | 라이브 DDL/존재 > 가격표 B26 엑셀 명시값 > 도메인+경쟁사 리서치 > `06_extract` L1 스냅샷 > 설계 |
| 1차 권위 | `04_audit/banner-domain-competitor-research.md` (도메인+경쟁사 자가확보 결론) |
| 가격 실측 | `10_configurator/silsa-price-table-gap.md` B26 (매트릭스 5×16 + 옵션 추가가격) |
| 원본 | `06_extract/price-poster-sign-l1.csv` B26 |
| 가격엔진 DDL | `00_schema/price-engine-ddl.md` (컬럼/타입/C-1~C-9) |
| 검증 | 본 문서는 **생성**. 독립 재검증(dbm-validator)은 별도 단계 |

> 본 트랙은 round-2 가격 트랙이며 **DB 미적재**(적재용 CSV + 매핑설계만). 라이브 t_* 직접 쓰기 없음.

---

## 0. 사용자 확정 (HARD 권위 — 추측·재도출 금지)

| ID | 확정 내용 | 매핑 반영 |
|----|-----------|-----------|
| U-1 | **off-grid 가격 = 가로·세로 각각 한 단계 큰 규격으로 올려 그 셀 가격(ceiling), 앱 런타임. DB는 격자 셀단가만.** | `component_prices`에 80 격자 셀단가만 적재. ceiling 룩업 로직은 적재 안 함(앱 책임). §2.5 |
| U-2 | **가로 하한 = 900mm. 가로 500~900은 주문불가(가격 없는 조합=주문불가).** 상품마스터 비규격 500은 입력폼 자여값. | siz 차원 = 가로 {900,1000,1200,1500,1750}만. 500~900 격자행 미생성. §2.1 |
| U-3 | **각목 추가가격 2단(900↓ 4000 / 900↑ 8000) 기준 = 세로(높이)변 길이.** | 각목 옵션 2값(LE900/GT900)의 분기 기준 = 세로변. component note 명시. §3.3 |
| U-4 | 입력 UX=혼합(프리셋+자유입력)이나 **가격 권위=이산 5×16 매트릭스**. 비치수 연속범위 모델 금지. | siz_cd 이산 차원만. R-SIZE-NONSPEC(연속범위) 폐기. §2.1 |
| U-5 (이번 트랙) | **옵션 추가가격 = 가격트랙 component 분리.** | 가공6·추가5 추가가격을 별도 comp_cd로 분리 적재. CPQ 옵션레이어(option_items)는 공정 참조 유지, 가격은 본 트랙 component가 보유. §3 |

---

## 1. 모델 개요 — 공식 사슬 (per-product 합산형)

판매가(1장) = **사이즈 면적매트릭스 셀단가** + **선택된 가공 추가가격** + **선택된 추가 추가가격**, 이후 `× 제작수량`(공식 외부·앱).

```
판매가(1장) = AREA_CELL(가로,세로)             [필수 1항, siz 차원 룩업]
            + GAGONG_ADDPRICE(선택 가공옵션)     [택1 필수, flat·타공만 개수별]
            + CHUGA_ADDPRICE(선택 추가옵션)       [택1 선택, flat·각목만 세로 2단]
최종가 = 판매가(1장) × 제작수량                  [공식 외부 = 앱 런타임, 규칙⑤]
```

### 1.1 엔진 배선 (per-product formula — D-WIRE 정합)

라이브 현황: PRD_000138은 `PRF_POSTER_FIXED`(공유공식)에 바인딩돼 있으나, 그 공식엔 `COMP_POSTER_ARTPRINT_PHOTO` 1개만 배선됨(28상품 공유) → **PRD_000138 자기 comp 미배선 = 가격조회 사슬 단절**(D-WIRE GAP, 메모리 `dbmap-price-chain-dwire-per-product-formula` HARD).

**본 트랙 해법:** PRD_000138 전용 합산형 공식 `PRF_BANNER_NORMAL`(FRM_TYPE.01)을 신설하고, 자기 구성요소 전부를 배선·바인딩한다. 공유공식 sparse 모델 폐기.

| 엔진 단 | 적재 대상 | 본 트랙 행 |
|---------|-----------|:--:|
| 1. 공식 헤더 `t_prc_price_formulas` | `PRF_BANNER_NORMAL` (FRM_TYPE.01 합산형) 1행 신설 | 1 |
| 2. 구성요소 `t_prc_price_components` | 면적 comp 1(라이브 선존재 `COMP_POSTER_BANNER_NORMAL`) + 옵션 추가가격 comp **10 신설**(가공6+추가4, "추가없음"=0원 센티넬 comp 없음) | 10 신설 |
| 3. 공식↔구성요소 배선 `t_prc_formula_components` | PRF_BANNER_NORMAL ↔ **11 comp**(면적1+옵션10) (disp_seq·addtn_yn) | 11 |
| 4. 다차원 단가 `t_prc_component_prices` | 면적 80셀 + 옵션 추가가격 10행 | 90 |
| 5. 상품 바인딩 `t_prd_product_price_formulas` | PRD_000138 ↔ PRF_BANNER_NORMAL | 1 |

> [설계결정 D-FRM] round-2 가 면적매트릭스에 FRM_TYPE.02(단순형, 통가격 1셀)을 썼다. 본 트랙은 **사이즈셀 + 옵션추가가가 합산**되므로 **FRM_TYPE.01 합산형이 의미상 정합**(여러 항목 Σ). 단순형은 단일 룩업 1항만 가능해 옵션추가가를 합칠 수 없다. → **FRM_TYPE.01 채택.** 라이브 공유공식(PRF_POSTER_FIXED, FRM_TYPE.02)은 본 트랙이 건드리지 않음(다른 상품 영향 회피).

---

## 2. 사이즈 면적매트릭스 가격 (B26 80셀)

### 2.1 매트릭스 축 (이산 5×16 = 80셀)

- **가로(width) = {900, 1000, 1200, 1500, 1750}mm** (5 이산, U-2 가로 하한 900).
- **세로(height) = {900, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3500, 4000, 4500, 5000}mm** (16 이산, B26 row 244~261 전수).
- 80셀 전부 명시 단가(B26 `value` 컬럼) — sparse 아님. 코팅포함 통가격이 아니라 현수막 본체 인쇄가(코팅 무관, 별도 가공은 §3 옵션).
- **비대칭 순서쌍**((900,1000)≠(1000,900)) — 각 (가로,세로) 고유 siz_cd. 면적 스칼라 합치기 금지(round-2 오모델 함정).

### 2.2 평면화 (B26 → component_prices long-form)

| 차원 | 값 | 근거 |
|------|----|----|
| `comp_cd` | `COMP_POSTER_BANNER_NORMAL` (라이브 선존재, area-matrix 트랙 등록) | 면적셀단가 구성요소 |
| `siz_cd` | (가로,세로) → siz_cd (§2.3) | 면적 차원 |
| `clr_cd` / `mat_cd` / `coat_side_cnt` / `bdl_qty` / `min_qty` | **전부 NULL** | 면적매트릭스는 도수·자재·코팅·묶음·수량 무관(셀단가=1장 기준) |
| `unit_price` | B26 셀값 (8000~72000) | 엑셀 명시 권위 |
| `apply_ymd` | `2026-06-01` (C-1 통일) | |

80셀 → 80 `component_prices` 행. 자연키 8컬럼 중복 0(siz_cd가 셀마다 고유).

### 2.3 siz_cd RESOLUTION (search-before-mint)

각 (가로,세로) 셀은 siz_cd 필요. 라이브 t_siz_sizes 우선 검색, 미존재 시 **발명 금지 → BLOCKED**. area-matrix 트랙이 이미 동일 치수의 siz 검색·제안을 완료했으므로 **그 결과를 재사용**(코드 중복 채번 방지).

| 구분 | 셀 수 | siz_cd | 처리 |
|------|:--:|------|------|
| 라이브 siz 선존재 | **3** | 900x900=`SIZ_000323` · 900x1200=`SIZ_000320` · 1500x1000=`SIZ_000403` | INSERTABLE |
| 라이브 siz 부재 | **77** | 제안 `SIZ_000538`~`SIZ_000618` 중 B26 해당분 (area-matrix `t_siz_sizes_BLOCKED.csv` 재사용, 실 CSV 권위) | BLOCKED — siz 등록 후 적재 |

> [HARD] siz 발명 금지. 77 BLOCKED 면적셀은 siz 적재(인간승인) 전 적재 불가 → `_BLOCKED.csv` 명시 분리. siz 제안 명명 = `{가로}x{세로}`, area-matrix 트랙 채번(SIZ_000538~000618, 실 CSV 권위)과 동일(중복 채번 금지). max 라이브 siz = SIZ_000510.

### 2.4 공식 배선 (면적 항)

`t_prc_formula_components`: `(PRF_BANNER_NORMAL, COMP_POSTER_BANNER_NORMAL)` disp_seq=1, addtn_yn='Y'(합산 1항). 룩업 = (comp_cd, siz_cd=치수) 단일 셀.

### 2.5 off-grid (U-1 — DB 미적재, 앱 책임)

off-grid(매트릭스 외 치수) = **가로·세로 각각 한 단계 큰 규격으로 올림 → 그 셀 가격**(ceiling). 예: 가로 1100×세로 950 → 가로 1200(다음 큰 규격)·세로 1000(다음 큰 규격) → (1200,1000) 셀단가. **DB는 격자 셀단가 80개만 저장**, ceiling 룩업은 앱 런타임. 적재 행 없음(설계 규약만 명문화).

---

## 3. 옵션 추가가격 component (U-5 — 가격트랙 분리)

가공6·추가5 옵션의 추가가격을 **각각 독립 comp_cd**로 분리. 가격엔진 `component_prices`엔 **공정/옵션 차원이 없으므로**(siz/clr/mat/coat/bdl/min 6차원뿐, FIT-GAP-1), 옵션값 1개 = comp_cd 1개로 표현하고, 그 추가가격을 **차원 전부 NULL인 flat `component_prices` 1행**으로 저장한다. 옵션→가격 연결은 §4(opt_cd ↔ comp_cd 맵)로 명문화.

### 3.1 가공옵션 추가가격 (B26 J/K 컬럼, 택1 필수 OG-GAGONG)

| 옵션 (opt_cd) | comp_cd (신설) | 추가가격 | 사이즈 의존 |
|---|---|--:|---|
| 열재단 OP-GAGONG-YEOLJAEDAN | `COMP_BANNER_FIN_HEATCUT` | 3,000 | flat |
| 타공(4개) OP-GAGONG-TAGONG4 | `COMP_BANNER_FIN_EYELET4` | 3,000 | 개수(4) |
| 타공(6개) OP-GAGONG-TAGONG6 | `COMP_BANNER_FIN_EYELET6` | 4,000 | 개수(6) |
| 타공(8개) OP-GAGONG-TAGONG8 | `COMP_BANNER_FIN_EYELET8` | 5,000 | 개수(8) |
| 양면테입 OP-GAGONG-YANGMYEONTAPE | `COMP_BANNER_FIN_DTAPE` | 3,000 | flat |
| 봉미싱 OP-GAGONG-BONGMISING | `COMP_BANNER_FIN_SEW` | 4,000 | flat |

> 타공 3값(4/6/8개)은 **개수별 별도 옵션**이라 각 옵션=각 comp_cd(개수는 옵션 분기로 흡수, B26 K246~K249 사다리 `3000>4000>5000`). 사이즈 무관 flat(리서치 B.3 권위).

### 3.2 추가옵션 추가가격 (B26 M/N 컬럼, 택1 선택 OG-CHUGA)

| 옵션 (opt_cd) | comp_cd (신설) | 추가가격 | 비고 |
|---|---|--:|---|
| 추가없음 OP-CHUGA-NONE | (component 없음) | 0 | 센티넬 — 추가가격 0, comp 미생성 |
| 큐방(4개) OP-CHUGA-QBANG4 | `COMP_BANNER_ADD_QBANG4` | 3,000 | flat |
| 끈(4개) OP-CHUGA-STRING4 | `COMP_BANNER_ADD_STRING4` | 4,000 | flat |
| 각목(900↓)+끈 OP-CHUGA-GAKMOK-LE900 | `COMP_BANNER_ADD_LUMBER_LE900` | 4,000 | 세로변 ≤900 (U-3) |
| 각목(900↑)+끈 OP-CHUGA-GAKMOK-GT900 | `COMP_BANNER_ADD_LUMBER_GT900` | 8,000 | 세로변 >900 (U-3) |

> 각목 2값(LE900/GT900)은 **세로(높이)변 길이 기준 2단가**(U-3). 끈 포함 복합가(B26 N249/N250). 옵션 분기로 길이단계 흡수 → 각 comp_cd flat 1행. "추가없음"은 0원 센티넬이라 comp 미생성(옵션레이어 OP-CHUGA-NONE만 유지).

### 3.3 옵션 추가가격 component_prices (차원 전부 NULL)

각 옵션 comp_cd 1개 → `component_prices` 1행, `siz/clr/mat/coat/bdl/min` 전부 NULL(flat·사이즈무관), `unit_price`=추가가격. 10 comp → 10행.

| comp_typ_cd | 값 | 근거 |
|---|---|---|
| 가공옵션(열재단·타공·양면테입·봉미싱) | `PRC_COMPONENT_TYPE.04 후가공비` | 본체 마감 가공(리서치 C.1, 공정 `.04` 계열) |
| 추가옵션(큐방·끈·각목) | `PRC_COMPONENT_TYPE.06 완제품비` | 거치 부자재 통가격(분해 불가). [설계결정 D-CHUGA-TYP] |

> [설계결정 D-CHUGA-TYP] 거치 부자재(큐방/끈/각목)는 인쇄·코팅으로 분해 안 되는 부속 통가격 → `.06 완제품비`가 의미상 가장 근접. 대안 `.04 후가공비`(가공 성격 약함)·전용 코드 신설(스키마 변경 금지). **검증단계 의미확정 권고.**

### 3.4 공식 배선 (옵션 항)

`t_prc_formula_components`: PRF_BANNER_NORMAL ↔ 10 옵션 comp, disp_seq=2~11, addtn_yn='Y'(합산). 단 **선택된 옵션만 합산**(택1) — addtn_yn은 합산 플래그일 뿐 "택1 중 선택분만"은 표현 불가(C-4). → **옵션 택1 선택 로직은 공식 외부(앱·옵션레이어 sel_typ)**가 결정, 공식은 "선택 시 합산 가능 항목" 카탈로그로 배선. (FIT-GAP-2)

---

## 4. 옵션레이어 ↔ 가격 component 연결 (L2 ↔ 가격트랙)

round-6 CPQ 옵션레이어(`10_configurator/load_silsa/`)는 옵션을 **공정 참조**(option_items `ref_dim_cd=OPT_REF_DIM.04 PROC_xxx`)로 재구성했으나 **추가가격은 0으로 누락**(PG-2). 본 트랙이 그 추가가격을 가격 component로 채운다. 연결 = `(prd_cd, opt_cd) → comp_cd` 맵(아래). 앱: 사용자가 opt_cd 선택 → 매핑된 comp_cd의 `component_prices.unit_price`를 합산.

| opt_cd (옵션레이어) | → comp_cd (가격트랙) | 추가가격 |
|---|---|--:|
| OP-GAGONG-YEOLJAEDAN | COMP_BANNER_FIN_HEATCUT | 3,000 |
| OP-GAGONG-TAGONG4 | COMP_BANNER_FIN_EYELET4 | 3,000 |
| OP-GAGONG-TAGONG6 | COMP_BANNER_FIN_EYELET6 | 4,000 |
| OP-GAGONG-TAGONG8 | COMP_BANNER_FIN_EYELET8 | 5,000 |
| OP-GAGONG-YANGMYEONTAPE | COMP_BANNER_FIN_DTAPE | 3,000 |
| OP-GAGONG-BONGMISING | COMP_BANNER_FIN_SEW | 4,000 |
| OP-CHUGA-NONE | (없음) | 0 |
| OP-CHUGA-QBANG4 | COMP_BANNER_ADD_QBANG4 | 3,000 |
| OP-CHUGA-STRING4 | COMP_BANNER_ADD_STRING4 | 4,000 |
| OP-CHUGA-GAKMOK-LE900 | COMP_BANNER_ADD_LUMBER_LE900 | 4,000 |
| OP-CHUGA-GAKMOK-GT900 | COMP_BANNER_ADD_LUMBER_GT900 | 8,000 |

> **연결 권위:** opt_cd 명명이 가격표 B26 옵션값과 char 일치(silsa-price-table-gap §1.2~1.3 검증). 이 맵은 본 트랙 산출 `option-component-link.csv`로도 별도 제공(앱 구현용 참조표 — 라이브 테이블 아님, **적재 대상 아님**).

> [FIT-GAP-2 함의] 라이브엔 "opt_cd→comp_cd" 직접 FK 테이블이 없다(가격엔진은 상품→공식→구성요소, 옵션레이어는 상품→옵션→공정 — 두 사슬이 분리). 본 맵은 **앱이 두 사슬을 잇는 참조표**. DB 구조 변경 없이 옵션 선택→가격 합산을 앱에서 수행. 스키마 변경 제안은 §6 GAP.

---

## 5. 적재 순서 & 산출 파일

### 5.1 FK 위상정렬 적재 순서

```
[단계 0] 부모 (선존재 검증만): t_cod_base_codes(FRM_TYPE/PRC_COMPONENT_TYPE), t_prd_products(PRD_000138)
[단계 0b] t_siz_sizes — 77 BLOCKED siz 등록 (인간승인 선행, area-matrix 트랙 SIZ_000538~000618 공유)
[단계 1] t_prc_price_formulas(PRF_BANNER_NORMAL) ∥ t_prc_price_components(11 신설)
[단계 2] t_prc_formula_components(11 배선) ∥ t_prc_component_prices(면적80+옵션10=90)
[단계 3] t_prd_product_price_formulas(PRD_000138↔PRF_BANNER_NORMAL)
```

### 5.2 산출 파일

| 파일 | 내용 | 행수 | 상태 |
|------|------|:--:|----|
| `load/t_prc_price_formulas.csv` | PRF_BANNER_NORMAL 1행 | 1 | INSERTABLE |
| `load/t_prc_price_components.csv` | 옵션 추가가격 comp 11 신설 | 11 | INSERTABLE |
| `load/t_prc_formula_components.csv` | 11 배선(면적1+옵션10) | 11 | INSERTABLE |
| `load/t_prc_component_prices_INSERTABLE.csv` | 면적 siz선존재 3 + 옵션 10 | 13 | INSERTABLE |
| `load/t_prc_component_prices_BLOCKED.csv` | 면적 siz미등록 77 | 77 | BLOCKED(siz 대기) |
| `load/t_prd_product_price_formulas.csv` | PRD_000138 바인딩 1 | 1 | INSERTABLE |
| `load/option-component-link.csv` | opt_cd↔comp_cd 참조표(앱용·비적재) | 11 | 참조 |
| `dsc-code-proposals.md` | 신규 comp_cd 11 + 공식 1 명명·근거 | — | 제안 |

CSV 공란 = NULL 규약(헤더=DB 컬럼명). `_provenance`/`_dim`은 추적 보조컬럼(적재 시 제외). comp_typ_cd 부모코드(.04/.06)는 선존재(라이브). FRM_TYPE.01 선존재.

---

## 6. 라이브 GAP / 설계결정 (인간확인 필요)

| ID | 종류 | 내용 | 권고/처리 |
|----|------|------|-----------|
| **FIT-GAP-1** | 스키마 적정성 | `t_prc_component_prices`에 **공정/옵션 차원 컬럼 없음**(siz/clr/mat/coat/bdl/min 6차원뿐). 옵션 추가가격을 "옵션값=comp_cd 1개 + 차원전부NULL flat행"으로 우회 표현 | 모델링 우회로 ADEQUATE-WITH-PROPOSALS. 스키마 변경 없음. comp 수=옵션값 수 증가는 수용 |
| **FIT-GAP-2** | 사슬 분리 | 가격엔진(상품→공식→구성요소)과 옵션레이어(상품→옵션→공정)가 **분리 사슬** — opt_cd→comp_cd 직접 FK 없음. 옵션 선택→가격 합산은 앱이 참조표로 연결 | 앱 책임으로 명문화. DDL 신설(option↔component 링크 테이블) 제안은 ddl-proposer 라우팅 후보(현 트랙 범위 밖) |
| **D-SIZ** | 신규 siz | 77 면적치수 siz 신규등록(area-matrix SIZ_000538~000618 공유, `{가로}x{세로}`) | **승인 필요** — 면적 77행 차단 해소 전제 |
| **D-FRM** | 공식유형 | PRF_BANNER_NORMAL = FRM_TYPE.01 합산형(사이즈셀+옵션추가가 Σ). 라이브 공유 PRF_POSTER_FIXED(.02)는 미변경 | 합산형 정합. 검증 의미확정 |
| **D-CHUGA-TYP** | comp 유형 | 거치 부자재(큐방/끈/각목) comp_typ_cd = .06 완제품비(분해불가 통가격) vs .04 후가공비 | .06 권고. 검증 확정 |
| **D-WIRE** | 사슬재모델 | round-2 공유공식(PRF_POSTER_FIXED) sparse 폐기, PRD_000138 전용 PRF_BANNER_NORMAL 신설 | 메모리 `dbmap-price-chain-dwire-per-product-formula` 권위. 본 트랙은 PRD_000138만 재모델(타 27상품은 동일 패턴 별도 트랙) |
| **D-GAKMOK-DIM** | 옵션 의미 | 각목 LE900/GT900 기준 = **세로변**(U-3 확정). comp note에 명시, 앱이 세로변으로 분기 | U-3 권위 — 확정. 옵션레이어 OP-CHUGA-GAKMOK-* note 갱신 권고 |
| (옵션레이어 잔존) | BLOCKED | OP-GAGONG-YEOLJAEDAN(PROC_000084 신설 대기)·각목 sub_prd_cd 미상 = **옵션레이어(round-6) BLOCKED** — 본 가격트랙과 독립. 가격(추가가격)은 본 트랙이 채움(옵션레이어 차단과 무관하게 가격 component는 INSERTABLE) | round-6 트랙 소관. 가격은 분리 진행 가능 |

---

## 7. 제약 준수 (C-1~C-9)

| 제약 | 준수 |
|------|------|
| C-1 apply_ymd | varchar(10) `'2026-06-01'` 전건 |
| C-2 자연키 8 dedup | 면적: siz_cd 셀마다 고유. 옵션: comp_cd마다 고유(차원 전부 NULL이라 (comp_cd,apply_ymd) 단독 유일). CSV 내 중복 0 |
| C-4 addtn_yn | 'Y'(합산 플래그). 택1 선택 로직은 공식 외부(앱) — 곱셈·택일 표현 안 함 |
| C-5 FRM_TYPE | PRF_BANNER_NORMAL = FRM_TYPE.01(선존재 코드) |
| C-6 comp_typ_cd | .04/.06(선존재). 신규 comp_cd 11은 부모유형 참조만(코드행 신설 불요) |
| C-8 use_yn | 공식·구성요소 use_yn='Y' |
| C-9 NULL≠'' | 미사용 차원 SQL NULL, CSV 공란→NULL(헤더 주석) |
| reg_dt NOT NULL | 적재 SQL에서 `now()` 명시(round-5 함정: 명시 NULL은 DEFAULT 미발화) |
