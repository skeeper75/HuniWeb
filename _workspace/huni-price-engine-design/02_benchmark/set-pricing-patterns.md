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

## P-4. 아크릴 세트/반제품 합성 ★ (면적매트릭스 종단 보강)

> 출처 `[red:AC]` = `_workspace/huni-rpmeta/categories/AC/reverse.md` · `[huni:acryl]` = `_workspace/huni-dbmap/31_acrylic-price-link/`.

아크릴은 **본체(면적) + 부착물(부자재 BUNDLE)** 또는 **접합 완제(고정가)** 의 두 합성 형태를 보인다.

### P-4a. 본체 + 부착물 BUNDLE (키링·등신대·명찰)
- **레드** `[red:AC]`: 아크릴 본체(면적·두께) + `SUB_MTR`/`WRK_MTR` 부착물(키링 고리 80+·등신대 받침 12 ESN=Y 필수·명찰 뒷면 옷핀/마그넷). 부착물 = 자재코드 + 부착공정 BUNDLE·QTY_INPUT_YN(수량 종속). 가격 = 본체 면적단가 + Σ 부착물 가산.
- **후니 매핑**: 본체 면적매트릭스 comp + 후가공 추가단가 comp(B05 고리없음0/은색고리1100…) Σ — `addtn_yn` 합산형(P-1과 동형). 받침은 ESN=Y(필수 동반)·고리는 선택 = round-6 CPQ 필수/선택 제약. **흡수 불요**(합산형 + 제약 기존 그릇).

### P-4b. 접합 완제 = 고정가형 (카라비너)
- **후니** `[huni:acryl B07]`: 아크릴카라비너(투명3T+3T 접합)는 면적이 아니라 **4형상 고정가**(자물쇠5800/하트6300/원형6900) — 접합 완제품을 형상별 통가격으로 판매. 본체+본체 접합이나 **합산이 아닌 단일 완제 단가**.
- **후니 매핑**: 고정가 comp(`.06 완제품비`·`use_dims=[opt_cd]`). ★세트(합성)처럼 보이나 **가격은 완제 단일가**(부품 합산 아님) — "접합=세트"로 오해해 본체×2 + 접합비 합산하면 오모델(가격표가 형상 고정가로 정의). 합성 패턴 P-1과 명확히 구분.

### P-4c. 코롯토 = 면적매트릭스 단일 (입체 블록)
- **후니** `[huni:acryl B06]`: 코롯토(입체 블록)도 6×6 면적매트릭스(30~80mm·3600~8400) **단일 본체 단가** — 입체조형(FCO)·양면(BCO)·두께블록(DCO) variant나 가격은 면적매트릭스 1 comp(`PRF_COROTTO_ACRYL`). 입체라고 세트 합성 아님.

### 아크릴 합성 가드
- **본체+부착물(P-4a)** = 합산형(흡수 불요)·**접합 완제(P-4b)** = 고정가형(합산 금지)·**코롯토(P-4c)** = 면적매트릭스(단일). 셋을 한 공식으로 강제 금지(메모리 `dbmap-print-domain-recipe-philosophy`).
- 부자재 카탈로그(고리/받침)는 굿즈/스티커 횡단 공유(absorption-candidates-acrylic C-A4).

---

## P-5. 실사·현수막 세트/반제품 합성 ★ (면적매트릭스형 종단 보강)

> 출처 `[red:BN]` = `_workspace/huni-rpmeta/categories/BN/reverse.md` · `[huni:silsa]` = `_workspace/huni-dbmap/33_silsa-price-quote/{silsa-quote-design,silsa-isomorph-merge-design}.md`.

실사·현수막은 **본체(면적) + 거치대 부속(고정가)** 또는 **본체 + 강제 후가공/포장**의 합성을 보인다 — 아크릴 P-4(본체+부착물·접합완제)와 같은 클래스이나 거치대·소재강제가 변별.

### P-5a. 본체(면적) + 거치대 부속 SKU (X배너·롤업)
- **레드** `[red:BN §3·5]`: 인쇄 본체(면적·`real_price`) + `CDL_DFT` 거치대 SKU(X배너 8종·롤업 RLU 600/850/1000). 거치대 = 본체와 별개 완제 부속·**거치대 폭↔size 1:1 캐스케이드**(롤업600↔거치대600). 가격 = 본체 면적가 + 거치대 고정가.
- **후니 매핑**: 본체 면적매트릭스 comp + 거치대 고정가 comp(`.06 완제품비`) **합산**(`addtn_yn`·아크릴 P-4a 본체+부착물 동형). 거치대 종류=round-6 CPQ option·폭↔사이즈 매칭=CPQ constraints. **흡수 불요**(합산형 + 제약 기존 그릇). ★거치대를 면적 차원(siz_width/height)으로 오모델 금지(부속 고정가).

### P-5b. 본체 + 강제 후가공/포장 (PET·텐트천)
- **레드** `[red:BN §2·7]`: PET배너 → 코팅 ESN_Y 필수·텐트천 → 포장(PKG_GB) 단일강제. 소재특성이 후가공/포장을 강제 동반 → 가격 = 본체 + (강제)코팅/포장 가산.
- **후니 매핑**: 본체 면적가 + 강제 후가공 comp 합산 + round-6 CPQ constraints(소재→필수동반·absorption C-SB5). 접지→오시 필수(P-3)와 같은 캐스케이드. **흡수 불요**(합산형 + 필수제약). ★강제 옵션 비용 누락 금지(돈-크리티컬·접지/PET 코팅).

### P-5c. 소재별 공식 = 동형 단가표 공유 (세트 아닌 결합)
- **후니** `[huni:silsa isomorph]`: 실사 13소재가 각자 `PRF_POSTER_<MAT>` 별 공식이나, **단가가 byte-identical이면 정본 comp 단가표 공유**(13→7·캔버스/레더아트/메쉬/타이벡 그룹 + 방수PVC/아트패브릭/아트프린트/방수PET 그룹). ★세트(합성)가 아니라 **공식 간 단가표 공유**(중복 제거) — 합성 패턴과 구분. byte-identical만 결합(행수 같아도 단가 다르면 금지).

### 실사·현수막 합성 가드
- **본체+거치대(P-5a)** = 합산형(흡수 불요·거치대 고정가)·**본체+강제후가공(P-5b)** = 합산형 + 필수제약·**소재별 공식(P-5c)** = 동형 단가표 공유(합성 아님). 면적·고정가·강제옵션을 한 공식으로 강제 금지(메모리 `dbmap-print-domain-recipe-philosophy`).
- 거치대/우드행거 부속은 폼보드/액자류 횡단 공유 가능(absorption-candidates-silsa-banner C-SB4).

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

---

## P-6. 문구·제본물 세트/반제품 합성 ★ (다부품 합성형 종단 — 세트 각도의 핵심 사례)

> 출처 `[red:book]` = `raw/widget_monitor/red_captures/v2_PRBKORD_capture.json`(트윈링책자·`book2025`·INN_PAGE·표지/내지 WGT 분리·seneca) · `[red:TP]` = `_workspace/huni-rpmeta/categories/TP/reverse.md` · `[wow:booklet]` = `raw/widget_monitor/wow_capture/fresh_booklet_capture.json`(paperno3/4/5·jobcost0) · `[huni:book]` = 라이브 `t_prd_*`(`t_prd_product_sets` 28행·`t_prd_product_page_rules` 11행·제본 comp 11종) · `[huni:dwire]` = `_workspace/huni-dbmap/02_mapping/dwire-bind-namecard-photocard-remodel/`.

제본물은 **§0 P-1(다부품 합성)의 가장 본격적인 사례** — 평면 인쇄물(명함/엽서)이 단일 부품이라면, 제본물은 표지·내지·제본이 각자 사양과 단가를 갖는 진짜 다부품 세트다. ★후니가 **이 세트 구조를 전용 그릇으로 이미 보유**(아크릴/실사의 "부속 합산"보다 한 단계 명시적).

### P-6a. 책자 = 표지+내지+제본 다부품 합성 (P-1의 본격 사례)
- **레드** `[red:book]`: 한 책자 안에 표지자재(ART250·COV_MIN_WGT 200) + 내지(INN_MAX_WGT 1000) **분리** + 제본방향/PVC커버. 가격 = 표지(자재×인쇄×후가공) + 내지(자재×인쇄×**페이지수**) + 제본 + 박. `book2025_price`가 부품 단가 합산.
- **와우** `[wow:booklet]`: `paperno3/4/5` 다단 용지(표지 vs 내지) + colorno/colorno_add + 박앞뒤. `jobcost0`이 작업량 환산 후 합산.
- **★후니 매핑 (전용 세트 그릇 보유)**: `t_prd_product_sets`(`[huni:book]` 28행) — 하드커버책자(072) = 세트 부모, sub_prd로 **표지(073 전용지) + 면지(074화이트/075블랙/076그레이)**. 표지·면지를 **각각 별 prd_cd 반제품**으로 두고 세트로 묶는다(RedPrinting WGT 분리·WowPress 용지 분리보다 명시적). 가격 = 부품 prd별 자재 단가 + 제본비 Σ(`addtn_yn` 합산형).
- **★현황 (배선 gap)**: 후니 라이브는 `PRF_BIND_SUM` 공유공식이 **제본비 단일항(중철)만** 배선(`[huni:dwire]` D-WIRE 4/1 broken). 표지/내지/인쇄 comp 미배선. → **세트 구조(구성)는 보유, 가격 합산(배선)은 미완**. 흡수 = 부품 comp 단가행 확보 + 합산 배선.

### P-6b. 페이지수 계층 = 내지 단가 비례 (P-3 변형 SKU와 구분)
- **레드** `[red:book·TP]`: INN_PAGE 2~130(STEP1)·캘린더 2~200. 내지 단가 = 1면(또는 1대) × 페이지수.
- **★후니 매핑**: `t_prd_product_page_rules`(`[huni:book]` 11행·page_min/max/incr) **라이브 실재** — RedPrinting INN_PAGE 1:1 동형. ★페이지수 = **입력 차원**·내지 단가 곱 = **앱 런타임 계산**(메모리 `compute-in-app-db-stores-lookup`). 접지(P-3)는 변형을 SKU에 베이크하지만 **책자 페이지수는 SKU 아닌 입력 차원**(2~300면 SKU 폭발 금지). 흡수 불요(그릇 보유)·앱 계산 명시.

### P-6c. 책등(seneca) = 페이지수 파생 (off-grid ceiling 동류)
- **레드** `[red:book]`: `seneca=0.64`·max 1000 = 페이지수×내지두께 파생. 무선/하드커버 표지 재단·인쇄 영역에 영향.
- **★후니 매핑**: 앱 런타임 계산(판수·박 등급·off-grid ceiling과 동일 철학)·DB 미저장. 신규 축/단가행 불요. 표지 면적이 책등에 의존하면 페이지수에서 앱 계산.

### P-6d. 떡메/메모패드 = 풀제본 묶음 (소량 세트·미바인딩)
- **레드** `[red:TP 그룹E]`: 떡메(TPBLMEO)·점메(TPBLPST) = 메모지 풀제본(점착) + 권/묶음 판매.
- **★후니 매핑**: 떡메모지(097)·메모패드(179) = `frm_cd=NULL`(`[huni:book]` 가격사슬 전무). 그릇은 보유(page_rules 097=3~3·`bdl_qty`·`bundle_qtys` QTY_UNIT 권/묶음·`t_prd_product_sets` 떡메=점착커버+내지 가능). 흡수 = 풀제본비 comp + 내지비 + 묶음 단가 신규 설계(권위 가격표 단가).

### 문구·제본물 합성 가드
- **책자(P-6a)** = 다부품 합산형(표지+내지+제본 Σ·세트 그릇 보유·**배선 미완**)·**페이지수(P-6b)** = 입력 차원+앱 계산(SKU 폭발 금지)·**책등(P-6c)** = 앱 계산 파생·**떡메(P-6d)** = 풀제본+묶음 단가(미바인딩). 넷을 한 공식으로 강제 금지(메모리 `dbmap-print-domain-recipe-philosophy`).
- **★세트 "구성"(`t_prd_product_sets` 표지+면지) 과 세트 "가격"(부품 합산 공식) 분리** = §0 P-1b 원칙의 가장 명확한 후니 사례. 후니는 구성 그릇을 보유하나 가격 합산을 미배선 → designer가 **구성 그릇 → 합산 공식 배선**을 설계.
- **★D-BIND-SCOPE 인간 결정**: "책자 = 제본비 단일 합산"(라이브) vs "표지+내지+인쇄+제본 부품 합산"(경쟁사 동형·세트 그릇 보유). 권위 가격표가 부품별 단가 주면 부품 합산이 정답.
- **★돈-크리티컬**: 제본비 `COMP_BIND_*` .01(min_qty 1/4/10 구간 = .02 합가형 성격)이 "부수당×수량 vs 묶음 총액" — 엔진 계약 확정 선결(디지털·아크릴 종단 동일 클래스).

---

## P-7. 굿즈/파우치 세트/반제품 합성 ★ (완제 SKU·다부품 조립형 종단 — 세트 vs 개당단가의 결정적 분기)

> 출처 `[red:GS]` = `_workspace/huni-rpmeta/categories/GS/reverse.md`(GS 대표 12·`tmpl_price` 개당단가·`DIR_MTR`/`WRK_MTR` 본체·자재 usage 다중슬롯·`PDT_WRK` 조립) · `[wow:goods]` = `_workspace/huni-dbmap/10_configurator/wowpress-option-model.md`(paperinfo 재질 합성·sizeinfo 형상 융합) · `[huni:goods-map]` = `_workspace/huni-dbmap/10_configurator/huni-goods-option-mapping.md` · `[huni:live]` = 라이브 `t_*`(굿즈/파우치 30상품 바인딩 0·가격사슬 전무).

굿즈/파우치는 **§0 P-1(다부품 합성)과 P-2(개당단가)의 분기점** — 책자(P-1)는 표지+내지+제본 부품을 합산하지만, 완제 굿즈(텀블러·머그·키링)는 **부품 합산이 아니라 완제 SKU 개당단가**다. 다만 노트/파우치(자재 usage 다중슬롯+조립)는 책자형 다부품 합성에 가깝다 — 굿즈 내부에서도 두 패턴이 공존한다.

### P-7a. 완제 굿즈 = 개당단가 (고정가형·합산 아님)
- **레드** `[red:GS §0.1·1]`: `tmpl_price` — 완제 굿즈 본체(`DIR_MTR`)가 개당단가 PRICE 주체(텀블러 45000=1개당). 소재/색/용량이 완제 SKU 라벨에 융합. **부품을 합산하지 않는다**(책자 P-1과 결정적 차이).
- **후니 매핑**: 고정가형 comp(`.06 완제품비`·카라비너 P-4b 동형). ★**가격사슬 전무**(`[huni:live]` 바인딩 0) — 완제 개당단가형 공식 신규 설계. ★개당단가 = min_qty=1 × 수량(아크릴 면적단가=개당 동형·÷1)·묶음단가면 ÷min_qty(디지털 .02 교정 동형). ★**"세트처럼 보이나 가격은 완제 단일가"** = P-4b 카라비너(접합 완제=형상 고정가·합산 아님)와 같은 클래스 — 굿즈를 부품 합산으로 오모델 금지.

### P-7b. 자재 usage 다중슬롯 = 노트/파우치 다부품 합성 (P-1 동류)
- **레드** `[red:GS §0.4·4]`: 한 굿즈에 본체지+내지(`INN_DFT`)+링(`RIN_DFT`)+스펀지(`WRK_MTR`) 동시. 스프링노트 = 표지+내지+트윈링 = 책자형 다부품(GS인데 책자 합성). 가격 = usage별 자재 단가 Σ + 제본/조립.
- **후니 매핑**: `t_prd_product_materials` + `usage_cd`(USAGE) 다슬롯 — 책자 P-6a와 동형(표지/내지 분리). 합산형(`addtn_yn`). ★노트류 굿즈는 P-1(다부품 합산), 완제 굿즈는 P-7a(개당단가) — **같은 GS 카테고리 안에서 패턴이 갈린다**(상품정체가 결정·권위 가격표가 정답).

### P-7c. 본체 + 부착물/조립 BUNDLE = 합산형 (파우치 지퍼·끈)
- **레드** `[red:GS §7·8]`: 본체(`DIR_MTR`/`MTRL_CD`) + `PDT_WRK`(봉제 조립) + `FLX_ZIP`(지퍼=자재+공정 BUNDLE·방향 variant). 아크릴 P-4a(본체+부착물)·실사 P-5a(본체+거치대)와 같은 합산 클래스이나 지퍼/끈/봉제가 변별.
- **후니 매핑**: 본체 개당단가/면적단가 comp + 조립공정(`t_prd_product_processes`) + 지퍼/끈 자재+공정 BUNDLE Σ(`addtn_yn`·dbmap 린넨 마감가공 5택1·각목+끈 BUNDLE 선례). **흡수 불요**(합산형 + BUNDLE 기존 그릇). ★조립비가 개당 baked-in인지 별 가산인지 검증(GSTGMIC PKT01=0 baked-in·GSPDLNG 인쇄 5000=별 가산).

### P-7d. 본체색/형상/사이즈 = 합성 (SKU 폭발 vs 옵션 분리)
- **레드/와우** `[red:GS §0.3]` `[wow:goods Q2]`: 본체색=재질행 합성(파우치색·캔버스 색6)·형상=규격 융합(원형/하트)·사이즈+방향=규격 1행(에코백 S/M/L). variant를 SKU 폭발이 아니라 의미축 합성으로.
- **후니 매핑**: 본체색=재질 합성(파우치 정답 패턴·split 금지)·형상=siz_nm 융합·사이즈/방향=siz 1행(`[huni:goods-map §3]`). ★**"함께 고르는 물리속성은 한 행 합성"**(과분할 금지)이 세트가 아니라 SKU 입도 규칙 — 색×형상×사이즈 곱집합 SKU 폭발 금지(WowPress 규칙 A·B). 가격은 합성 SKU(siz/mat)별 단가.

### 굿즈/파우치 합성 가드
- **완제 굿즈(P-7a)** = 개당단가 고정가형(합산 금지·카라비너 P-4b 동류)·**노트/파우치 usage 다슬롯(P-7b)** = 다부품 합산형(P-1/P-6a 동형)·**본체+조립 BUNDLE(P-7c)** = 합산형 + BUNDLE·**본체색/형상(P-7d)** = 합성 SKU(과분할 금지·세트 아님). 같은 GS 카테고리 안에서 패턴이 갈리므로 **한 공식으로 강제 금지**(메모리 `dbmap-print-domain-recipe-philosophy`).
- **★세트 vs 개당단가 분기 = 상품정체가 결정** — 완제 굿즈(텀블러)=개당단가·다부품 노트=합산. 권위 가격표(굿즈 시트)가 부품별 단가 주면 합산·완제 단가 주면 개당단가(designer 판정 입력).
- 부자재 카탈로그(지퍼/끈/고리/받침)는 아크릴·실사·굿즈 횡단 공유(absorption-candidates-goods-pouch C-GP6·acrylic C-A4·silsa C-SB4).

---

## P-8. 스티커 세트/묶음 가격 합성 ★ (이산규격형 종단 — 세트형 합가형의 대표 사례)

> 출처 `[red:ST]` = `_workspace/huni-rpmeta/categories/ST/{reverse,summary}.md`(STTHUSR/STCUXXX/STPADPN 풀 실측·재단입자·인쇄방식) · `[huni:stk]` = `_workspace/huni-dbmap/33_silsa-price-quote/{sticker-3axis-design,bankal-shapes-resolution}.md`(가격표 스티커 7블록·라이브 t_prc_*·**형상=칼틀=가격축 아님**·B06 팩 .01 오적재).

### P-8a. die-cut 스티커 = 단일 본체 (세트 아님)
- **레드** `[red:ST §1·§2]`: 자유형/반칼 die-cut = digital_price 단일 본체(좌표+칼틀+소재+수량). 부품 합성 아님.
- **후니** `[huni:stk]`: `PRF_STK_FIXED` 단일 comp(`COMP_STK_PRINT`·이산 siz_cd × mat_cd × min_qty 단가형 .01). **세트 합성 아님**(평면 인쇄물 단일 부품·명함/엽서 P-1 클래스). 후가공(코팅/화이트/넘버링/부분UV)만 Σ 가산(addtn_yn).

### P-8b. 세트형 합가형(타투 3장당·팩 54장당) = 묶음 총액형 ★ (돈크리티컬)
- **레드** `[red:ST §0.6·그룹 F]`: die-cut/판 외 묶음판매 완제형(타투·팩·마스킹테이프·밴드) — 장 단위 or 세트 단위 판매.
- **★후니** `[huni:stk §1.2]`: **B05 타투 = "3장마다 4000원"**(합가형 구간총액)·**B06 팩 = "54장 1세트 4000"**(세트당). 이는 die-cut 개당×수량(.01)과 **결정적으로 다른 묶음 총액형(.02 합가형)** — `구간총액÷min_qty(또는 bdl_qty)×수량`.
- **후니 매핑**: `.02 합가형` comp(`COMP_STK_TATTOO` bdl_qty=3·`COMP_STK_PACK` bdl_qty=54). ★**세트처럼 보이나 부품 합산 아님** = 묶음 단위 총액(아크릴 카라비너 P-4b·굿즈 P-7a "완제 단일가"와 같은 클래스). 부품 prd로 쪼개 합산하면 오모델.
- **★돈크리티컬**: B06 팩이 라이브 `prc_typ_cd .01 단가형`으로 **오적재**(.02여야 ÷54·54배 과청구 위험) — 디지털 명함 .01→.02·아크릴 min_qty 교정 동형 클래스. prc_typ 확정 후 적재(추측 금지).

### P-8c. 형상/재단입자 = 가격 합성 아님 (옵션·공정) ★ (세트 오모델 가드)
- **레드** `[red:ST §0.1~0.3]`: 형상(shape_info 5종)·칼선(THO 2메커니즘)·재단입자(반칼 DFXXX/완칼 DFITM)를 1급 옵션 슬롯으로.
- **후니** `[huni:stk:bankal]`: 형상(원형/정사각/팬시)=칼틀(도무송 목형)·가격 차원 0(같은 사이즈/소재=같은가). 재단입자=공정(proc_cd). **세트/합성 무관·옵션·공정** — RedPrinting이 형상/재단을 옵션 슬롯으로 둔 것을 "형상별 SKU 세트"로 오해 금지. ★단, 재단입자가 단가 가르면(반칼 B01 vs 완칼 B02 낱장) siz_cd 분리(돈크리티컬·합성 아님).

### 스티커 합성 가드
- **die-cut 단일 본체(P-8a)** = 단일 부품(세트 아님·명함/엽서 P-1 클래스)·**세트형 합가형(P-8b)** = 묶음 총액형(.02·부품 합산 아님·카라비너 P-4b/굿즈 P-7a 동류)·**형상/재단(P-8c)** = 옵션·공정(가격 합성 무관). 한 공식으로 강제 금지.
- **★세트 vs 묶음 총액 vs 단가형 분기 = 상품정체+가격표 단위가 결정** — 가격표가 "3장당/54장당" 총액 주면 .02 합가형(bdl_qty)·"개당 단가" 주면 .01 단가형. 형상/재단입자는 어느 쪽도 가격 합성 아님(옵션 그릇·공정).
- 세트 "구성"(template·완제 SKU·마스킹테이프 규격) vs 세트 "가격"(묶음 .02 합가형) 분리(§0 P-1b 원칙)·권위 가격표가 최종.
