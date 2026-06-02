# data-adapter.md — 어댑터 레이어 (컨버전 무손실 조건)

> 파이프라인 ③ 키스톤. Red shape → 정규화 계약 / 후니 DB → 정규화 계약 매퍼 명세.
> [HARD] 어댑터는 **유일한 신뢰 경계**. 외부 raw 데이터는 여기서만 정규화 타입(`data-contract.md`)으로 변환되고, 이후 위젯은 정규화만 본다.
> 근거: [역공학] 실측 shape / [동작분석] / 키스톤 컨버전 전략.

---

## 0. 컨버전 전략 (위젯 무변경)

```
오늘:   Red 캡처 fixture ──[red adapter]──▶ 정규화 계약 ──▶ 위젯 (구현·검증)
추후:   후니 DB/API     ──[huni adapter]──▶ 정규화 계약 ──▶ 위젯 (코드 무변경)
```

- [결정] 어댑터는 **BFF 레이어**에 산다(서버측). 위젯 번들에 어댑터를 넣지 않는다 → 위젯은 어댑터 존재조차 모름. BFF가 데이터소스(Red fixture / Neon / 커머스)에서 읽어 정규화하여 위젯에 응답.
- 컨버전 = `adapters/red/` → `adapters/huni/` 교체 + 데이터소스 스위치. 위젯/계약/컴포넌트 0 변경.
- 검증 기준: Red fixture로 통과한 위젯이 후니 어댑터 출력(동일 정규화 타입)으로도 동일 동작해야 함 → 어댑터 계약 테스트(정규화 타입 스키마 일치)가 게이트.

---

## 1. 어댑터 인터페이스 (양 구현 공통)

```ts
// adapters/types.ts — Red/후니 어댑터가 구현하는 동일 시그니처
export interface ProductAdapter {
  getProduct(code: string): Promise<NormalizedProduct>;
}
export interface PriceAdapter {
  // 정규화 요청 → 데이터소스 가격엔진 호출 → 정규화 분해
  quote(req: NormalizedPriceRequest): Promise<NormalizedPriceBreakdown>;
}
export interface UploadAdapter {
  issuePresigned(req: NormalizedPresignedRequest): Promise<NormalizedPresigned>;
  getFileMeta(storedFileName: string): Promise<Pick<NormalizedUploadResult,'pageCount'|'sizeBytes'>>;
}
export interface EditorAdapter {
  getConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig>; // 토큰 발급 포함
}
export interface CartAdapter {
  handoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }>;
  // [UNDECIDED] 내부에서 커머스 플랫폼 호출. Red/후니/미정. 위젯·계약과 무관.
}
```

---

## 2. Red 어댑터 매핑표 (오늘 — fixture 기반)

데이터소스: `01_reverse/captures/*.json` + `02_analysis/captures/*.json` (라이브 캡처 fixture).

### 2.1 Product (`get_digital_product_info` → NormalizedProduct)

| 정규화 필드 | Red 원천 | 변환 |
|------------|---------|------|
| `code` | `product_option.option.pdt_cod` | 그대로 |
| `unit` | catalog `unit` ("권"/"개") | 그대로 |
| `priceSchemeKey` | `option.price_gbn` (`book2025_price`...) | 불투명 echo |
| `sides` | `inner_pdt_*` 존재 여부 | 있으면 `[default(표지,editor), inner(내지,pdf)]`, 없으면 `[default]`. uploadType은 `exterior.uploadType` [동작분석 §3] |
| `optionGroups` | size/mtrl/dosu/pcs 데이터셋 | §3 componentType 매핑 규칙 적용 |
| `constraints.disableRules` | `pdt_disable_pcs_info[]` | `{MTRL_CD→triggerValueId, PCS_CD→disablesGroupId(DTL null) / disablesValueId}` |
| `constraints.quantity` | `pdt_base_info` (FIR/INC/STEP/MIN, 내지 MIN/MAX) | QuantityRule |
| `constraints.sizeRules` | `pdt_size_info[]` (CUT/WRK) | SizeRule |
| `constraints.base` | `pdt_base_info` (margin/min/max/nonStandard) | BaseRule |
| `editors` | `useKoiEditor`/`useRPEditor`/`usePDF` | EditorCapability |
| `cta` | DESIGN 부록A (상품군별) | CtaCapability |

### 2.2 colorCount 평면화 (dosu↔bnc)

[동작분석 cascade §3] `pdt_dosu_bnc_info`의 `printColorCount`(SID_S=4 / SID_D=8)를 dosu OptionGroup의 각 `OptionValue.priceColorCount`에 주입. `type:"inner"` 항목은 inner side 그룹으로. → 위젯은 선택값의 `priceColorCount`를 가격요청 `colorCounts[side]`에 넣기만.

### 2.3 essential/hidden 평면화

[cascade §5] `ESN_YN`/`VIEW_YN` → `OptionGroup.required`/`visible`. `visible:false && required:true` = hidden essential(자동적용) → 어댑터가 해당 그룹의 default value를 미리 selected로 표시하고 위젯은 UI 미렌더(가격요청엔 포함).

### 2.4 Price (`get_ajax_price_vTmpl`)

요청 정규화→Red:
```
NormalizedPriceRequest → { dataJson: {
  ORD_INFO:[{ PDT_CD:productCode, CUT_WDT/HGH/WRK_*:dimensions[default],
    PRN_CNT:quantity, PAGE_CNT:pageCount,
    CVR_CLR_CNT:colorCounts.default, INN_CLR_CNT:colorCounts.inner,
    CVR_MTRL_CD:materials.default, INN_MTRL_CD:materials.inner }],
  PCS_INFO: selectedFinishes.map(f=>({PCS_COD:f.groupId, PCS_DTL_COD:f.valueId})),
  price_gbn:priceSchemeKey, mb_cust_cod:customerTier??'10000000' }}
```
응답 Red→정규화 (3단 워터폴 [역공학 §1] 어댑터가 적용):
```
finalPrice = PRICE_MALL≠PRICE ? PRICE_MALL : ORG_PRICE≠PRICE ? PRICE : ORG_PRICE
vat        = 대응 _VAT
shipping   = book_info.DLVR_AMT
lines      = result[].map → {code:PCS_CD, label:result_log[0] 한글, amount:PRICE}
```

### 2.5 Upload / Editor / Cart

| 계약 | Red 매핑 |
|------|---------|
| presigned | `POST /api/aws/presigned-url {file_name,pdt_cod,content_type}` → `{presignedURL→uploadUrl, filename→storedFileName}` |
| fileMeta | `POST /ko/product/s3GetObjectJson {file_name}` → pageCount/size |
| editorConfig | `POST /api/editor/config/KOI` → `{config:{psCode,templateUrl,resource_id,token}, option.pluginCustomData}`. 토큰체인(makers /token,/editor,/template/hit)은 어댑터/BFF가 수행 |
| cartHandoff | `from-edicus:goto-cart` 페이로드 → Red `sdkCreatePot` 주문데이터 형태 (Red 검증 경로) |

---

## 3. componentType 매핑 규칙 (어댑터 결정 로직)

[결정] 위젯이 아니라 **어댑터**가 "Red 데이터셋 → componentType"을 결정한다(위젯은 결과만). 규칙:

| Red 데이터셋/특성 | componentType | 근거 |
|-------------------|---------------|------|
| `pdt_size_info` (값 ≤ ~6, 텍스트) | `option-button` | DESIGN 7.1 사이즈 |
| `pdt_mtrl_info` 표지/내지 용지 (값 多) | `select-box` / `finish-select-box` | DESIGN 7.2/7.12 RULE-1 |
| `pdt_dosu_info` (단면/양면) | `option-button` | 도수 토글 |
| `pdt_pcs_info` 후가공 (선택 2~3값) | `finish-button` | DESIGN 7.11 |
| 후가공 색상값(`colorHex` 有, 박/포일) | `color-chip` (50×50) | DESIGN 7.4 RULE-4 |
| 부자재 색상(소형) | `mini-color-chip` (32×32) | DESIGN 7.7 |
| 다수 색상 그리드 | `large-color-chip` | DESIGN 7.8 |
| 재질 이미지 칩 | `image-chip` | DESIGN 7.6 |
| 수량(`pdt_base_info` FIR/INC) | `counter-input` | DESIGN 7.3 RULE-3 |
| 내지 페이지수(min/max/step) | `page-counter-input` | DESIGN 7.10 |
| 박크기 가로×세로 mm 입력 | `area-input` | DESIGN 7.9 |
| 수량 구간 슬라이더(옵션) | `price-slider` | DESIGN 7.5 RULE-5-EXT |

> [결정] 매핑은 어댑터 설정 테이블로 명시(자동 추론 최소화). Red 캡처는 데이터셋명이 안정적이므로 데이터셋→componentType 룩업 테이블이면 충분. 과한 휴리스틱 금지(단순성).

---

## 4. 후니 어댑터 (DB 확정 후 — 설계만)

후니 DB가 Neon이든 다른 형태든, `ProductAdapter`/`PriceAdapter`/... 5개 인터페이스를 구현하면 위젯은 무변경. 후니 어댑터가 해야 할 일:

1. 후니 옵션 마스터 → `NormalizedProduct`(componentType 매핑 테이블은 후니 옵션 타입 기준으로 1회 작성).
2. 후니 가격엔진(또는 Red 동형 ORD_INFO+PCS_INFO 계약) → `NormalizedPriceBreakdown`. 후니가 동일 계약을 노출하면 §2.4 거의 재사용.
3. 후니 S3/스토리지 presigned → `NormalizedPresigned`.
4. 후니 Edicus 파트너 설정(`.env.local` EDICUS_PARTNER_CODE 등) → 토큰 발급 → `NormalizedEditorConfig`.
5. cartHandoff → [UNDECIDED 커머스]. 후니 커머스 확정 시 이 메서드 내부만 구현.

> [결정] 후니 어댑터는 DB 확정 전까지 stub. 컨버전 게이트 = "후니 어댑터가 정규화 타입 스키마를 만족하는가"의 계약 테스트. 위젯 회귀테스트는 fixture 그대로 통과해야 함(불변 증명).

---

## 5. 잔존 미검증 흡수 (어댑터가 책임)

[역공학 gaps-resolved §3] 미검증 항목은 모두 어댑터 경계에서 흡수:

| 미검증 | 어댑터 흡수 방법 |
|--------|----------------|
| 비책자(굿즈/아크릴) 가격 ORD_INFO 정확 필드 | 어댑터 quote()가 상품군별 분기(PAGE_CNT 생략 등). 위젯은 정규화 요청만 |
| 회원등급 할인(PRICE_MALL≠PRICE) | 어댑터 워터폴이 처리. 위젯엔 finalPrice만 |
| 고급 후가공(스코딕스/박/형압) 가격기여 | PCS_INFO에 valueId 추가만. 위젯 무관 |
| 아크릴 option_info(제작방식/형태) | 어댑터가 OptionGroup으로 사상(componentType=option-button 등) |
| presigned SignedHeaders/checksum | PUT 헤더는 위젯 uploader가 Content-Type만; 어댑터 발급 시 결정 |
| editor/config 직접호출 페이로드 | 어댑터/BFF가 토큰체인 수행, 위젯엔 최종 NormalizedEditorConfig만 |

> 결론: 잔존 미검증은 전부 **구현 비차단** — 정규화 계약 경계가 위젯을 보호한다.
