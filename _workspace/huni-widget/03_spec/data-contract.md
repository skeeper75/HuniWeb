# data-contract.md — 정규화 위젯 계약 (키스톤)

> 파이프라인 ③ 키스톤 산출물. 위젯이 의존하는 **유일한 데이터 모델**. Red/후니/커머스 백엔드와 무관한 단일 shape.
> [HARD] 위젯·훅·컴포넌트·store는 오직 이 계약 타입만 import한다. Red 원시 필드(`PCS_COD`/`MTRL_CD`/`price_gbn`/`ORD_INFO`...)를 직접 참조하면 컨버전 시 위젯 재작성이 필요하므로 금지.
> 근거: [역공학] 가격·옵션·캐스케이드·업로드 실측 + [동작분석] 이벤트/에디터 + [DESIGN] componentType.

---

## 0. 설계 원칙

1. **componentType 중심**: 옵션은 Red의 데이터셋 이름(`pdt_size_info` 등)이 아니라 DESIGN.md의 14 componentType 중 하나로 표현된다. 어댑터가 "이 Red 데이터셋은 어떤 componentType로 렌더되는가"를 결정한다. → 위젯은 componentType만 보고 렌더(RULE-5 동적).
2. **코드 비투명(opaque) 처리**: 자재코드·공정코드 등은 위젯에 `id: string`(불투명 토큰)으로만 보인다. 위젯은 `id`를 비교·전달만 하고 의미를 해석하지 않는다. Red `RXART300`이든 후니 `HUNI_ART_300`이든 위젯엔 그냥 `id`.
3. **가격은 서버 권위**: 위젯은 옵션 선택 상태(`NormalizedPriceRequest`)를 보내고 분해 결과(`NormalizedPriceBreakdown`)를 받는다. 계산식·단가 테이블은 계약에 없다. [역공학 price-engine §3 — 클라이언트 재계산 금지 반증].

---

## 1. 제품/옵션 계약

```ts
// contract/product.ts
export interface NormalizedProduct {
  code: string;                 // 불투명 상품 식별자 (Red pdt_cod ↔ 후니 코드)
  name: string;
  unit: string;                 // "권" | "개" ... 표시용 (Red unit)
  priceSchemeKey: string;       // 불투명 가격체계 키 (Red price_gbn). 위젯은 가격요청에 echo만
  sides: ProductSide[];         // 단일면=[default], 책자=[default(표지), inner(내지)]
  optionGroups: OptionGroup[];  // 렌더 순서대로
  constraints: NormalizedConstraints;
  editors: EditorCapability;    // 어떤 입력수단 허용
  cta: CtaCapability;           // PDF/Design/Cart/Estimate 노출 (DESIGN 부록A)
}

export type SideKey = 'default' | 'inner';   // [역공학] exterior.uploadType 키와 정렬
export interface ProductSide {
  key: SideKey;
  label: string;                // "표지" | "내지"
  uploadType: 'editor' | 'pdf'; // [동작분석 runtime §3] 면별 입력수단 분기
}

export interface OptionGroup {
  id: string;                   // 불투명 그룹 식별 (어댑터 생성, 안정 키)
  side: SideKey;
  label: string;                // 동적 라벨 (RULE-5 — 하드코딩 금지)
  componentType: ComponentType; // ↓ §2 — 14종 중 하나
  required: boolean;            // ESN_YN 매핑
  visible: boolean;             // VIEW_YN 매핑 (false=hidden essential, 자동적용)
  values: OptionValue[];        // 동적 .map() 대상
  // 입력형(counter/area/page)은 values 대신 inputSpec
  inputSpec?: InputSpec;
}

export interface OptionValue {
  id: string;                   // 불투명 값 식별 (Red MTRL_CD/PCS_DTL_COD 등)
  label: string;                // 동적 라벨
  colorHex?: string;            // ColorChip/MiniColorChip/LargeColorChip 용
  imageUrl?: string;            // ImageChip 용
  badge?: 'recommend' | 'best' | 'new' | 'up'; // DESIGN 배지 (선택)
  disabled?: boolean;           // 캐스케이드로 비활성 (런타임 계산, 어댑터 초기값 false)
  priceColorCount?: number;     // dosu→CLR_CNT 매핑값 (가격요청 조립용, 불투명)
}

export interface InputSpec {    // counter/area/page-counter 입력 제약
  min: number; max: number; step: number; first?: number; defaultValue: number;
  // area: width/height 2축이면 axis2 추가
  axis2?: { min: number; max: number; label: string };
  helpText?: string;            // "가로 30~125mm" (동적)
}

export type ComponentType =
  | 'option-button' | 'select-box' | 'counter-input' | 'color-chip'
  | 'price-slider' | 'image-chip' | 'mini-color-chip' | 'large-color-chip'
  | 'area-input' | 'page-counter-input' | 'finish-button' | 'finish-select-box'
  | 'summary' | 'upload-cta';
```

> [DESIGN] componentType은 14종 그대로. [결정] 어댑터가 Red 데이터셋 특성(값 개수·색상 여부·입력 여부)을 componentType로 사상한다(매핑 규칙은 data-adapter §3).

---

## 2. 캐스케이드 제약 계약 (6종)

[동작분석 cascade-rules §0] 6 제약 타입을 위젯이 클라이언트 룰엔진으로 처리할 수 있는 정규화 형태로:

```ts
// contract/constraints.ts
export interface NormalizedConstraints {
  // ① material → pcs disable (자재 선택 시 후가공 비활성)
  disableRules: DisableRule[];
  // ② quantity (수량/페이지 clamp/snap)
  quantity: Record<SideKey, QuantityRule | undefined>;
  // ③ dosu↔bnc (도수 선택 → 색상수·제본그룹)  — colorCount는 OptionValue.priceColorCount로 평면화
  // ④ size (규격 → cut/work 치수)
  sizeRules: SizeRule[];
  // ⑤ pcs essential/hidden → OptionGroup.required/visible로 평면화 (별도 배열 불필요)
  // ⑥ base (단위·재단마진·최소/최대 치수)
  base: BaseRule;
}

export interface DisableRule {
  triggerValueId: string;       // 선택 시 트리거되는 OptionValue.id (Red MTRL_CD)
  disablesGroupId?: string;     // 그룹 전체 비활성 (PCS_DTL_CD null)
  disablesValueId?: string;     // 특정 값만 비활성
}
export interface QuantityRule {
  min: number; first: number; increment: number; step: number; default: number;
  pageMin?: number; pageMax?: number; pageStep?: number;  // 책자 내지
}
export interface SizeRule {
  valueId: string; cutW: number; cutH: number; workW: number; workH: number;
}
export interface BaseRule {
  unit: string; cutMargin: number;
  minCutW: number; minCutH: number; maxCutW: number; maxCutH: number;
  nonStandardAllowed: boolean;
}
```

> [결정] ③ dosu↔bnc 와 ⑤ essential/hidden 은 별도 배열로 두지 않고 `OptionValue.priceColorCount` / `OptionGroup.required·visible` 로 **평면화**했다. 이유(단순성 강제): 위젯은 "선택값의 색상수"와 "이 그룹이 필수/표시인가"만 필요하다. 매핑 로직은 어댑터가 흡수하고 위젯엔 결과만 노출 → 위젯 룰엔진이 단순해진다.

---

## 3. 가격 계약 (서버 권위, Red-shape 중립)

[설계] 가격 요청/응답은 **특정 백엔드 형태와 무관한 중립 정규화 shape**다. Red의 ORD_INFO+PCS_INFO/price_gbn 구조는 정규화의 출발 근거가 아니라 **오늘 Red 어댑터가 매핑해 들어오는 한 소스 형태(참고)**일 뿐이다. 이 계약은 Red 어댑터(오늘)와 후니 가격 API 어댑터(추후) 둘 다 — **각자의 고유 형태 그대로** — 만족할 수 있어야 한다. **위젯은 단가/공식 없음**(가격은 불투명 결과값).
> 아래 필드의 주석은 Red 어댑터가 그 필드를 어디서 채우는지에 대한 참고일 뿐(예: `quantity`↔Red PRN_CNT). 후니 어댑터는 후니 API에서 동일 정규화 필드를 자기 방식으로 채운다. 계약 필드명에 Red/후니 고유명은 없다.

```ts
// contract/price.ts
export interface NormalizedPriceRequest {
  productCode: string;
  priceSchemeKey: string;       // 불투명 echo (Red price_gbn)
  customerTier?: string;        // 불투명 (Red mb_cust_cod, 기본 어댑터가 채움)
  dimensions: PriceDimension[]; // side별 (책자=표지+내지, 단일=1개)
  colorCounts: Record<SideKey, number | undefined>; // CVR_CLR_CNT/INN_CLR_CNT
  materials: Record<SideKey, string | undefined>;   // 불투명 자재 id
  quantity: number;             // PRN_CNT
  pageCount?: number;           // PAGE_CNT (책자)
  selectedFinishes: SelectedFinish[];   // PCS_INFO
}
export interface PriceDimension { side: SideKey; cutW: number; cutH: number; workW: number; workH: number; }
export interface SelectedFinish { groupId: string; valueId: string; } // PCS_COD/PCS_DTL_COD 평면화

export interface NormalizedPriceBreakdown {
  ok: boolean;
  // 최종 표시금액 (3단 워터폴 [역공학] 은 어댑터가 적용해 final로 평면화)
  finalPrice: number;           // 결제금액(부가세 별산 전)
  vat: number;
  shipping: number;             // 배송비 (Red 어댑터는 book_info.DLVR_AMT에서 채움 — 참고)
  lines: PriceLine[];           // 공정별 분해 (선택적, 투명성 표시 — DESIGN Summary)
  raw?: unknown;                // 디버그용 (위젯은 안 씀)
}
export interface PriceLine { code: string; label: string; amount: number; } // PCS_CD → 한글 label
```

> [결정] 위젯엔 항상 `finalPrice` 단일값만 준다. 최종금액을 **어떻게 산정하는지**는 백엔드/어댑터 영역이다 — Red의 3단 워터폴(정가/할인가/몰가)은 [역공학 §1] Red 산정 방식(참고)이고, 후니는 후니 자체 할인·금액 산정을 쓴다. 어느 쪽이든 위젯은 산정 방식을 모르고 결과 `finalPrice`만 표시(단순성). 공정별 `lines`는 선택적 — 백엔드가 분해 행을 제공하면 DESIGN Summary 투명성 표시에 쓰고, 없으면 비워도 된다.

---

## 4. 업로드 계약 (presigned)

[역공학 s3-upload-flow] presigned → S3 PUT 직접.

```ts
// contract/upload.ts
export interface NormalizedPresignedRequest {
  fileName: string; productCode: string; contentType: string; // "application/pdf"
  side: SideKey;
}
export interface NormalizedPresigned {
  uploadUrl: string;            // presigned PUT URL (60분 만료 — 발급 직전 호출)
  storedFileName: string;       // 서버생성 UUID (주문데이터 보관)
  expiresInSec: number;
}
export interface NormalizedUploadResult {
  side: SideKey; storedFileName: string; originalFileName: string;
  pageCount?: number; sizeBytes?: number;   // s3GetObjectJson 메타
}
```

> [결정] presigned는 발급 직전 1회. 미리 발급 금지(60분 만료). PUT은 위젯이 S3로 직접(BFF 경유 안 함). 파일 검증(application/pdf, ≤1GB)은 위젯 클라이언트 + BFF 양측.

---

## 5. 에디터 계약 (Edicus)

[동작분석 runtime §4 / editor-bridge] from-edicus 라이프사이클을 정규화.

```ts
// contract/editor.ts
export interface NormalizedEditorConfig {
  side: SideKey;
  psCode: string;               // "{edicusPsCode}@{productCode}" (불투명)
  templateUrl: string;          // gcs://...
  resourceId: number;
  token: string;                // JWT (BFF/어댑터 발급, 위젯은 보관 안 함 — 즉시 SDK 전달)
  pluginCustomData?: Record<string, unknown>;  // {mtrlCode} 등 — 불투명 전달
}
export interface NormalizedEditorResult {       // from-edicus:goto-cart 정규화
  side: SideKey;
  projectId: string;            // Edicus Firebase pushID
  thumbnailUrls: string[];      // tnUrlList
  totalPageCount: number;
}
```

---

## 6. 장바구니 핸드오프 계약 (커머스 바인딩 UNDECIDED)

[스코프 제약 — HARD] 장바구니/주문 경로는 정규화 페이로드를 BFF로 넘기는 데서 끝난다. 그 뒤 커머스 플랫폼 바인딩은 어댑터/BFF의 미정 책임. 위젯은 특정 플랫폼을 모른다.

```ts
// contract/cart.ts
export interface NormalizedCartHandoff {
  productCode: string;
  selectedOptions: SelectedOption[];   // 옵션 스냅샷 (id+label, 불투명)
  quantity: number;
  pageCount?: number;
  priceSnapshot: { finalPrice: number; vat: number; shipping: number };
  artifacts: NormalizedArtifact[];     // 면별 에디터projectId 또는 업로드파일
}
export interface SelectedOption { groupId: string; valueId: string; }
export interface NormalizedArtifact {
  side: SideKey; kind: 'editor' | 'pdf';
  projectId?: string; thumbnailUrls?: string[]; totalPageCount?: number;  // editor
  storedFileName?: string; originalFileName?: string;                     // pdf
}
```

> [결정] 위젯은 `onCartHandoff(payload: NormalizedCartHandoff)` 콜백으로 호스트/BFF에 전달하고 종료. 위젯이 직접 커머스 API(장바구니 추가 등)를 호출하지 않는다. 커머스 바인딩은 BFF `/cart-handoff` 뒤편(어댑터, UNDECIDED).

---

## 7. 능력(capability) 계약

```ts
export interface EditorCapability { koi: boolean; rp: boolean; pdf: boolean; } // useKoiEditor 등
export interface CtaCapability { pdfUpload: boolean; designEditor: boolean; cart: boolean; estimate: boolean; } // DESIGN 부록A
```

---

## 8. 계약 안정성 규칙

- [HARD] 계약 타입에 Red/후니 고유 필드명(`ORD_INFO`/`PCS_COD`/Shopby 필드) 등장 금지. 모두 `id`/`label`/도메인 중립명.
- 새 componentType 추가 = 계약 + 14 매핑 동시 갱신(DESIGN과 동기).
- 불투명 `id`는 어댑터가 round-trip 보장(요청 시 그대로 echo). 위젯은 의미 해석 금지.
