# 반제품/세트 가격 합성 패턴 — 디지털인쇄 (파일럿)

> `hpe-benchmark-analyst` 산출 3/3. 여러 구성품 조합 상품(책자=표지+내지+제본·묶음/세트·접지 등)의
> 가격을 경쟁사가 **어떻게 합성하는가**를 정리해 후니 세트상품 가격 설계 입력으로 제공.
> **흡수 vs 답습[HARD]**: 메커니즘만 흡수·naming/codes 후니 유입 금지·권위 엑셀 최종.

## 출처

- `[wow:booklet]` = `raw/widget_monitor/wow_capture/fresh_booklet_capture.json` (책자 40004·2026-03-31).
- `[red:NC]` = `_workspace/huni-rpmeta/categories/NC/reverse.md` (접지 명함 SKU 합성·포토카드 부수tier).
- `[red:book]` = `raw/widget_monitor/red_captures/v2_PRBKORD_capture.json` (`book2025_price`·MTRL_CD 다행).
- `[huni:ddl]` = `_workspace/huni-dbmap/00_schema/price-engine-ddl.md` (`bdl_qty`·`t_prd_product_bundle_qtys`·template).

---

## 0. 세트/반제품 가격 합성의 3가지 패턴 (디지털인쇄에서 관측)

| 패턴 | 정의 | 경쟁사 관측 | 후니 그릇 |
|------|------|-----------|----------|
| **P-1 다부품 합성** (책자형) | 서로 다른 부품(표지/내지/제본)의 단가를 각각 계산해 합산 | 와우 책자(`paperno3/4/5` 다단)·레드 `book2025_price` | 공식 합산형 `addtn_yn` Σ + (잠재) template 묶음 |
| **P-2 묶음수 단가** (세트/EA) | 한 SKU를 묶음 단위(세트/EA/권)로 단가 적용 | 와우 ordcnt·수량 tier | `bdl_qty` 차원 + `t_prd_product_bundle_qtys` |
| **P-3 변형 SKU 합성** (접지/완제) | 변형(접지수·방향)을 SKU에 베이크해 하나의 완제 단가로 | 레드 접지명함 16 SKU `[red:NC]` | `siz_cd` SKU + 후가공 구성요소 |

---

## P-1. 다부품 합성 (책자형 반제품) ★

### 경쟁사 패턴
- **와우프레스 책자(40004)** `[wow:booklet]`: 용지 select가 **다단(`paperno3`=PP·`paperno4`=반투명·`paperno5`=0.2T)** + 도수 본판(`colorno`) + 추가도수(`colorno_add`: 백색/은별색/별색1도) + 박앞/뒤. 책자는 표지·내지·제본이 각자 사양을 갖고, 각 부품 단가가 합산된다(본판 도수 + 추가도수 별색 + 박 = Σ).
- **레드프린팅 책자(`book2025_price`)** `[red:book]`: `price_gbn=book2025_price` 전용 엔진. `MTRL_CD` 행이 여러 종(RXART250 표지·RXOMO080/100 내지 등) populated = **부품별 자재가 한 상품 안에 공존** → 표지자재 + 내지자재 + (페이지수·제본) 합성.

### 합성식 (관측·추정)
```
책자 가격 = 표지(자재×인쇄×후가공) + 내지(자재×인쇄×페이지수) + 제본비 + (박/형압 가산)
         = Σ 부품 component 단가  (각 부품이 자기 차원으로 단가 룩업)
```

### 후니 매핑
후니 4단 엔진의 **합산형(`frm_typ_cd=합산형`)** + `addtn_yn='Y'` 구성요소 Σ가 다부품 합성을 담는다. 표지비·내지비·제본비를 각각 `comp_cd`로 두고 한 공식(`frm_cd`)에 배선하면 됨. dbmap round-21 BOOKLET-BIND-WIRE(제본 구성요소 배선)가 이미 이 방향.

### trade-off / 가드
- **부품별 자재가 다르다** → `component_prices`의 `mat_cd` 차원이 부품마다 다른 단가행을 가짐(표지 mat_cd ≠ 내지 mat_cd). 한 공식이 부품별 comp를 합산.
- **페이지수**: 내지 단가는 페이지수에 비례 → `min_qty`(출력매수) 또는 별도 수량 입력으로 환원(앱 계산, DB는 룩업). 메모리 `compute-in-app-db-stores-lookup` 준수.
- **흡수 불요**: 합산형 다부품은 후니가 이미 동형. 단 **세트=template로 부품을 묶는 그릇**(아래 P-1b)이 가격 합성과 별개로 필요할 수 있음.

### P-1b. template 묶음 (세트 구성 그릇) — 흡수 nuance
후니 `t_prd_templates`/template_selections(round-3·round-6)는 완제 SKU(여러 부품을 하나의 주문/생산 단위로 묶음)를 담는다. 다부품 책자가 **하나의 완제 상품**으로 팔리면 template이 부품 구성을 묶고, 가격은 여전히 공식 합산형으로 계산(template은 구성, 공식은 가격). → designer는 **세트 "구성"(template)과 세트 "가격"(합산 공식)을 분리** 설계할 것.

---

## P-2. 묶음수 단가 (세트/EA/권) — 후니 이미 보유

### 경쟁사 패턴
와우프레스 수량 tier(명함 500~30000매)·ordcnt(1~50건), 레드 부수 tier(100~500). 묶음 단위로 단가가 적용되고 단위가 올라가면 단가 하향(볼륨디스카운트).

### 후니 매핑 (흡수 불요)
후니는 **이미 전용 그릇 보유**: `component_prices.bdl_qty`(묶음수 차원) + `t_prd_product_bundle_qtys(prd_cd, bdl_qty)` (상품별 묶음 옵션·`bdl_unit_typ_cd` FK = QTY_UNIT: EA/매/권/세트) `[huni:ddl]`. 묶음 단위별 단가행을 `component_prices`에 두면 세트/EA/권 단가가 그대로 표현됨.

### trade-off
- 후니가 경쟁사보다 **묶음 단위 모델이 명시적**(QTY_UNIT 코드값). 흡수할 것 없음 — 오히려 후니가 표현력 우위.

---

## P-3. 변형 SKU 합성 (접지/완제) — 후니 이미 흡수

### 경쟁사 패턴
레드 접지명함(NCDFFLD): 접지를 별도 옵션축이 아니라 **사이즈 SKU 16종에 베이크**(`2단 세로형 90X50` 등 — 접지수×방향×규격) + 오시 공정 동반 `[red:NC]`. 펼친 크기(WRK/CUT)가 접지수에 비례. 가격 = (펼친 면적 SKU 단가) + 오시 가산.

### 후니 매핑 (흡수 불요)
후니 `siz_cd`(사이즈 차원) + 후가공 구성요소(오시=`comp`)로 동형. 접지 변형을 siz_cd SKU로 두고 오시 비용을 합산. dbmap 메모리 `dbmap-acrylic-price-chain-link`·`area-matrix-wh-dimension`(SKU 합성 패턴)와 정합.

### trade-off / 가드
- **변형 SKU vs 옵션축 선택**: RedPrinting은 명함=SKU 흡수, 리플렛=옵션축 분리(PR). 후니도 상품군마다 선택 자유 — "어느 쪽이 가격표 권위와 맞는가"가 기준(엑셀이 정답).
- **오시=사이즈 종속 공정**: 접지 SKU 선택 시 오시가 캐스케이드(필수 동반) → round-6 CPQ 제약(사이즈→공정 필수)으로 표현. C-4(자재×후가공) 제약 레이어와 같은 그릇.

---

## 세트 가격 합성 종합 판정

1. **세 패턴(다부품합성·묶음단가·변형SKU) 전부 후니 4단 엔진 + 보조그릇이 이미 동형으로 담는다** — 신규 가격축 0.
   - P-1 다부품 = 합산형 `addtn_yn` Σ (+ template은 구성 그릇·가격과 분리).
   - P-2 묶음 = `bdl_qty` + `bundle_qtys`(QTY_UNIT) — 후니가 오히려 명시적.
   - P-3 변형SKU = `siz_cd` SKU + 후가공 comp + 캐스케이드 제약.
2. **designer 핵심 입력**:
   - 세트 **"구성"(template)** 과 세트 **"가격"(합산 공식)** 을 분리 설계 (P-1b).
   - 다부품 책자는 부품별 `comp_cd`(표지비/내지비/제본비)를 한 `frm_cd`에 합산 배선 (round-21 정합).
   - 페이지수·접지수·면적 등 **파생값은 앱에서 계산, DB는 단가 룩업만** (메모리 `compute-in-app-db-stores-lookup` 절대 준수).
3. **흡수할 실질 = 0건(가격 합성 메커니즘)** + **구성 제약 가드 재확인**(접지→오시 필수 등 = C-4 제약 레이어와 공통). 권위 엑셀(상품마스터·가격표)이 세트 구성·단가의 최종 권위.

### naming 유입 가드 [HARD]
`book2025_price`·`MTRL_CD`(RXART250 등)·접지 SKU 라벨 후니 유입 금지. 후니 `frm_cd`/`comp_cd`/`mat_cd`/`siz_cd` 컨벤션으로 번역(dbmap-naming-standardization 권위순서).
