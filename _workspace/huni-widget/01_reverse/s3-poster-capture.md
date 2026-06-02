# S3 — 포스터·실사·사인·배너 라이브 캡처 + NC-1 명세

> 근거 표기: `[라이브 검증]` = localhost:3001 실캡처 / `[정적 분석]` = 계약·소스 코드 검증 / `[추정]` = 미검증.
> 캡처 원본: `05_qa/captures/s3_*.json` + `01_reverse/s3_raw_captures/`. 캡처 스크립트: `raw/widget_monitor/local/s3-poster-capture.cjs`, `s3-realprice-capture.cjs`.
> 안전 모드(read-only): 견적/옵션/가격 API까지만. 주문/결제 미진입. JWT redact.

---

## 0. 캡처 요약

| 항목 | 값 | 근거 |
|------|-----|------|
| 캡처 대상 | BNBNFBL(현수막), BNPTPET(PET배너), PRPOXXX(종이포스터) | [라이브 검증] |
| 토큰 | 캡처 시점 유효(exp 1780410076, 만료 전 완료) | [라이브 검증] |
| 가격호출 | 각 2~3회(get_ajax_price_vTmpl), retCode 200(현수막/포스터)·999(빈사이즈) | [라이브 검증] |
| productInfo | 각 1회(get_digital_product_info) FULL 캡처 | [라이브 검증] |

---

## 1. (a) productCode · 옵션트리 · SizeMatrix2D 계약

### 1.1 productCode 전수 탐색 [라이브 검증]
Red 메인(`/rp-api/ko`) 정독 → `/ko/product/item/{CAT}/{CODE}` 패턴으로 전수 수집.
- **BN(배너) 23종**: BNBNFBL(현수막), BNBNLOW(특가현수막), BNBNDAY(오늘출발현수막), BNTPSNG(타포린단면), BNPTPET(PET배너), BNPTMAS(매쉬배너), BNTNHVY(텐트천현수막), BNSTPED/BNSTDFT(X배너), BNFGBNR(깃발), BNHGDBL(양면행잉), BNHGTRA(투명행잉), BNRLSLV(롤업PET), BNBNSOD(어깨띠) 등.
- **PR(포스터/카드) 118종** 중 포스터군: PRPOXXX(종이포스터), PRPODAY(오늘출발), PRPOBIG(대형A1), PRPORSO(리소), PRPOSTK(고투명점착), PRPOWTT(방수), PRPOWHT(화이트), PRPOBLT(백릿) 등.
- 사인/시트커팅은 별도 카테고리(`/ko/main/index_new/20` "현수막/시트커팅/배너"), AI 카테고리에 자석시트지(AISHMGC) 등.

### 1.2 입력수단 메타 (product_option.option) [라이브 검증]
| 상품 | item_gbn | price_gbn | usePDF | useKoiEditor | useRPEditor | cut_guide_yn | price_table_yn |
|------|----------|-----------|--------|--------------|-------------|--------------|----------------|
| BNBNFBL 현수막 | real_item | **real_price** | Y | N | N | N | N |
| BNPTPET PET배너 | real_item | **real_price** | Y | N | N | N | N |
| PRPOXXX 포스터 | digital_item | **digital_price** | Y | N | N | N | N |

→ **대형 실사/배너 = `real_price` + PDF 업로드 전용**(에디터 없음). 포스터 = `digital_price`. price_gbn 분기는 BFF 가격모델 선택 단서(SizeMatrix2D vs 일반). [라이브 검증]

### 1.3 사이즈 입력 이중 모드 (NC-1 핵심 근거) [라이브 검증]
캡처된 Shadow DOM `sizes` select 옵션:
- **BNBNFBL**: `["사이즈직접입력", "5000X900", "900X900", "900X5000", "1800X1780"]` (규격프리셋 + 자유입력)
- **PRPOXXX**: `["사이즈직접입력", "A2", "A3", "A4", "B3(4절)", "B4(8절)", ...]` (규격 A-series)
- **BNPTPET**: `["사이즈직접입력", "1000X1000"]`

number input 4종 + 수량: `w-재단사이즈 / h-재단사이즈 / w-작업사이즈 / h-작업사이즈 / ORD_CNT`.
**작업사이즈 = 재단사이즈 + CUT_MRG(4mm)** 자동 (캡처: 5000→5004, 900→904). [라이브 검증]

### 1.4 MIN/MAX_CUT 슬롯 (nonspec 자유입력 제약) [라이브 검증]
`product_data.pdt_base_info[0]`:
| 상품 | WDT_HGH_GBN_YN | NO_STD_ABL_YN | MIN_CUT_WDT | MAX_CUT_WDT | MAX_CUT_HGH | CUT_MRG |
|------|----------------|----------------|-------------|-------------|-------------|---------|
| BNBNFBL | N | N | 0.00 | **5000.00** | **5000.00** | 4.00 |
| BNPTPET | N | N | 0.00 | **1000.00** | (1000) | 4.00 |

→ PM §1.4 nonspec의 `MIN/MAX_CUT_WDT/HGH` 슬롯이 productInfo에 **실재**. 자유입력 시 위젯이 이 범위로 가로×세로를 검증해야 함(InputSpec.min/max/axis2). [라이브 검증]

### 1.5 가격 API 계약 — cutW/cutH 수치 직접 전달 (SizeMatrix2D 핵심) [라이브 검증]
가격요청 `dataJson.ORD_INFO[0]` 실측:
```
BNBNFBL: {PDT_CD:"BNBNFBL", MTRL_CD:"PXBFCXXX", CUT_WDT:5000, CUT_HGH:900, WRK_WDT:5004, WRK_HGH:904, DOSU_COD:"SID_S", PRN_CLR_CNT:4}
PRPOXXX: {PDT_CD:"PRPOXXX", MTRL_CD:"RXART100", CUT_WDT:420,  CUT_HGH:594, WRK_WDT:424,  WRK_HGH:598, DOSU_COD:"SID_S", PRN_CLR_CNT:4}  (A2=420×594)
PCS_INFO: BNBNFBL=[{CUT_ZUN/ZDINC}], BNPTPET=[{COT_DFT/TCMAS},{CUT_ZUN/ZDINC}]  (배너 가공옵션)
```
**핵심: `CUT_WDT`/`CUT_HGH`가 가격요청에 수치로 직접 실림.** S1/S2(옵션 코드 선택)와 다른 **수치 직접 전달 경로**. 규격프리셋 변경 시 수치 변동 확인(A2=420×594 → 100×150). [라이브 검증]

### 1.6 가격모델 = BFF SP (INV-1 확인) [라이브 검증]
가격응답 `query`/`query_flexible`에 SP 호출이 그대로 노출:
```
dbo.WSP_ACPT_ORDER_TMPL_PCS_PRICE '0101', 'LNG_KO', 'BNPTPET', '<?xml ...><PARAMS><DETAIL><MTRL_COD>...<CUT_WDT/><CUT_HGH/>...'
```
→ SizeMatrix2D 보간·소재별 m² 단가는 **전부 BFF SP**. 위젯은 cutW/cutH 입력만 보내고 불투명 `result_sum.PRICE`만 받음. **위젯 가격계산 0(INV-1)**. [라이브 검증]

> **미검증 flag**: PRICE>0 실가는 미확보(비로그인 PRICE=0 / 수량·사이즈 확정 조합 미캡처). SizeMatrix2D 보간 "결과 수치"는 BFF 권위라 위젯 무관 — INV-1상 위젯 검증 불필요. 그러나 후니 비교검증 시 PRICE>0 캡처 필요(§6 리스크). [추정 회피 — 미검증 명시]

---

## 2. (b) 어댑터 매핑 [정적 분석 + 라이브 검증]

현 어댑터(`mapProduct`)가 S3 fixture를 매핑한 실결과(red-adapter-poster.test.ts 로그):

| 상품 | groups | componentTypes | scheme | 비고 |
|------|--------|----------------|--------|------|
| BNBNFBL | 12 | option-button, select-box, finish-button, counter-input | real_price | GRP_SIZE + 8 PCS 가공옵션 |
| BNPTPET | 9 | (동일 4종) | real_price | PCS_COT_DFT(타공) 등 |

- `GRP_SIZE` → **현재 `option-button`** 매핑(values=5: 사이즈직접입력+규격4). **MTRL_COVER → select-box, DOSU → option-button, 가공(PCS_*) → finish-button, 수량 → counter-input.**
- 배너 가공옵션(CUT_ZUN 열재단/COT_DFT 타공/SEW_RIN 봉미싱/ROP_DFT 로프/QBG_DFT 등)이 **전부 finish-button으로 흡수** → expansion-strategy §S3 "배너 가공옵션=finish-button" 가설 **[라이브 검증 확정]**. 신규 컴포넌트 불필요.

### 2.1 sizeRules 자유입력 폴백 결함 (NC-1 필요성의 결정적 증거) [라이브 검증]
어댑터 매핑 결과 `constraints.sizeRules`:
```
sizeRules count=5, e0: {valueId:"SIZE_0", cutW:0, cutH:0, workW:4, workH:4}   ← "사이즈직접입력"
```
→ **"사이즈직접입력"(SIZE_0)의 cutW/cutH=0**. 규격프리셋(5000X900 등)은 sizeRule로 cutW/cutH가 채워지지만, **자유입력은 정적 sizeRule 룩업으로 수치를 못 얻음** → cutW=0 폴백 → 가격요청 빈값(BNPTPET retCode=999와 일치). **이것이 NC-1 + store 분기가 필요한 정확한 이유.** [라이브 검증]

---

## 3. (c) NC-1 명세 — `dimension-matrix-input`

### 3.1 책임
규격 프리셋 선택(칩) + 비규격 가로×세로 자유입력을 **하나의 leaf 컴포넌트**로 제공. 선택 모드에 따라 **2D 단가 결정 차원(cutW/cutH)을 store에 공급**. area-input(후가공 치수 보조)과 의미·가격역할이 다름.

### 3.2 props (기존 패턴 따름)
```
{ group: OptionGroup, value, onChange }   // OptionControl 디스패처 통일 시그니처
```
- `group.values`: 규격프리셋(OptionValue[], 각 valueId가 sizeRule 키) + 자유입력 sentinel(SIZE_0).
- `group.inputSpec`: 자유입력 범위 — `{ min: MIN_CUT_WDT, max: MAX_CUT_WDT, axis2: {min: MIN_CUT_HGH, max: MAX_CUT_HGH, label:"세로"}, helpText:"가로 0~5000mm" }`. **InputSpec.axis2 슬롯 이미 존재**(product.ts:37). [정적 분석 확정]

### 3.3 계약 사용 (신규 필드 0 검증) [정적 분석 확정]
| 계약 슬롯 | 위치 | NC-1 사용 | 신규? |
|-----------|------|-----------|-------|
| `ComponentType` union | product.ts:8-22 | `\| 'dimension-matrix-input'` 1줄 추가 | **union 1줄** |
| `InputSpec.axis2` | product.ts:37 | 가로/세로 2축 범위 | 이미 존재 ✅ |
| `PriceDimension.cutW/cutH` | price.ts:7-8 (number) | 자유입력 수치 직접 전달 | 이미 존재 ✅ |
| `constraints.sizeRules` | (규격프리셋→cutW/cutH 룩업) | 프리셋 모드 시 사용 | 이미 존재 ✅ |

→ **계약 변경 = ComponentType union 1줄. 신규 필드 0** (INV-2/INV-5 충족). [정적 분석 확정]

### 3.4 dispatcher case 추가 위치 [정적 분석]
`04_build/src/widget/components/controls/OptionControl.tsx:40` (area-input 직후):
```
case 'dimension-matrix-input':
  return <DimensionMatrixInputBridge group={group} />;
```
INV-5: union 추가 시 이 switch가 exhaustive하므로 **동시 갱신 필수**(미추가 시 tsc 에러 — 의도된 안전망).

### 3.5 store 조립 경로 — **코어 변경 범위 정직한 flag** [정적 분석 — 중요]
`04_build/src/widget/stores/price.ts:18-27` `dimsFromSelection`:
- **현재**: `GRP_SIZE` 선택값 → `sizeRules` 정적 룩업만. rule 없으면 `{cutW:0,cutH:0}` 폴백.
- **NC-1 필요 변경**: 자유입력 모드(SIZE_0 선택 + W/H 입력)일 때 **사용자 입력 수치를 직접 dimensions.cutW/cutH에 전달**하는 분기 추가.

> **정직한 판정**: NC-1은 **순수 leaf 추가가 아님**. 다음 2개소 변경 필요:
> 1. **leaf 컴포넌트 신규** (`DimensionMatrixInput.tsx`) — 신규 파일, 코어 재작성 아님.
> 2. **dispatcher case 추가** (OptionControl.tsx) — union 동기화, 기존 case 불변.
> 3. **store `dimsFromSelection` 분기 추가** (price.ts) — "자유입력 수치 → cutW/cutH" 경로. **이것이 유일한 코어(store) 터치.**
>
> 단 이 store 분기는 **계약 변경 0**(cutW/cutH 슬롯 존재)이고 `dimsFromSelection` 내부 분기 1개 추가 수준. store/cascade/shadow/price-seam/editor-bridge **재작성 아님**(INV-3 유지). 자유입력 W/H 값을 어디에 보관할지(widget-store에 selection 외 numeric slot)는 hw-architect 설계 포인트.

---

## 4. (d) 코어 변경 범위 판정 (요약)

| 변경 대상 | 범위 | INV |
|-----------|------|-----|
| `ComponentType` union | +1줄 (`dimension-matrix-input`) | INV-2 OK(중립명), INV-5 |
| `OptionControl.tsx` dispatcher | +1 case (exhaustive 동기화) | INV-5 |
| `DimensionMatrixInput.tsx` leaf | 신규 파일 | INV-3 OK(leaf 추가) |
| `price.ts` `dimsFromSelection` | +1 분기(자유입력 수치 경로) | **INV-3 경계 — store 조립 분기(재작성 아님)** |
| `widget-store` numeric slot | 자유입력 W/H 보관(설계 포인트) | hw-architect |
| 계약 신규 필드 | **0** | INV-2 |

**판정: 순수 leaf만(❌) — store 조립 분기 포함(✅).** 단 store 변경은 "재작성"이 아니라 `dimsFromSelection`에 자유입력 수치 경로 1개 추가 + widget-store에 W/H 수치 슬롯. 가격모델(SizeMatrix2D 보간)은 전부 BFF(INV-1 불변).

---

## 5. (e) S1·S2 대비 델타

| 축 | S1(디지털) | S2(스티커) | S3(포스터/배너) |
|----|-----------|-----------|-----------------|
| 가격모델 | PriceTable3D | PriceTable3D변형 + FixedUnit | **SizeMatrix2D** (가로×세로) |
| 사이즈 입력 | 규격선택(코드) | 규격/사이즈직접입력(코드) | **규격프리셋 + 자유입력 수치 직접전달** |
| cutW/cutH 경로 | sizeRule 룩업 | sizeRule 룩업 | **자유입력=수치 직접(룩업 불가)** |
| 신규 componentType | 0 | 0 | **NC-1 dimension-matrix-input(확정)** |
| 가공옵션 | finish-button | finish-button(THO_DFT) | finish-button(CUT_ZUN/COT_DFT 등) — 흡수 확정 |
| 입력수단 | editor+pdf | editor+pdf | **pdf 전용(real_price 에디터 없음)** |
| price_gbn | digital_price | digital_price/vTmpl_price | **real_price**(현수막/PET) / digital_price(포스터) |

S1·S2는 위젯 코어 0변경. **S3가 첫 위젯 가시 변경**(NC-1 leaf + store 자유입력 분기).

---

## 6. (f) 리스크 / 미캡처 flag

| 항목 | 상태 | 영향 |
|------|------|------|
| **PRICE>0 실가** | 미캡처(비로그인 PRICE=0, qty/size 확정 조합 미수집) | SizeMatrix2D 결과 수치 비교검증 지연. INV-1상 위젯 무관하나 후니 비교 시 필요 |
| **자유입력 직접 W/H 가격응답** | 미캡처(realprice 스크립트 한글 input name 매칭 실패) | 자유입력 모드 cutW/cutH 변동→가격 변동 직접 증거 미확보. 가격요청 cutW/cutH 수치전달은 규격프리셋 캡처로 확정 |
| **사인/시트커팅(05)** | 미캡처 | 보드/액자 단일사이즈(option-button 충분 여부) 미검증 — §S3 (c) "보드·액자=단일사이즈 단가" 미확인 |
| **소재별 m² 단가표** | BFF 내부(미노출) | INV-1상 위젯 무관 |
| sizeRules 자유입력 cutW=0 폴백 | **확인됨(결함=NC-1 근거)** | NC-1 store 분기로 해소 예정 |

---

## 7. 산출물 인덱스
- 캡처: `05_qa/captures/s3_{BNBNFBL,PRPOXXX,BNPTPET}.{json,png}`, `s3_rp_{PRPOXXX,BNBNFBL}.json` + 원본 `01_reverse/s3_raw_captures/`
- fixture: `04_build/fixtures/product_BNBNFBL.json`, `product_BNPTPET.json`, `price_BNBNFBL_sample.json` (PRPOXXX는 S1 기존)
- 라우팅: `04_build/src/adapters/red/fixture-source.ts` (BN prefix 가격분기 추가)
- 테스트: `04_build/test/red-adapter-poster.test.ts` (4 tests, 전체 33 green)
