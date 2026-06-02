// data-contract.md §1 — 제품/옵션 계약.
// [HARD] 위젯·훅·컴포넌트·store 는 오직 이 계약 타입만 import. Red/후니 원시 필드 직접 참조 금지.

import type { NormalizedConstraints } from './constraints';

export type SideKey = 'default' | 'inner'; // [역공학] exterior.uploadType 키와 정렬

export type ComponentType =
  | 'option-button'
  | 'select-box'
  | 'counter-input'
  | 'color-chip'
  | 'price-slider'
  | 'image-chip'
  | 'mini-color-chip'
  | 'large-color-chip'
  | 'area-input'
  | 'page-counter-input'
  | 'finish-button'
  | 'finish-select-box'
  | 'summary'
  | 'upload-cta';

export interface ProductSide {
  key: SideKey;
  label: string; // "표지" | "내지"
  uploadType: 'editor' | 'pdf'; // 면별 입력수단 분기 [동작분석 runtime §3]
}

export interface InputSpec {
  // counter/area/page-counter 입력 제약
  min: number;
  max: number;
  step: number;
  first?: number;
  defaultValue: number;
  axis2?: { min: number; max: number; label: string }; // area: 2축
  helpText?: string; // 동적 도움말 "가로 30~125mm"
}

export interface OptionValue {
  id: string; // 불투명 값 식별 (Red MTRL_CD/PCS_DTL_COD 등). 위젯은 의미 해석 금지.
  label: string; // 동적 라벨
  colorHex?: string; // ColorChip/Mini/Large 용
  imageUrl?: string; // ImageChip 용
  badge?: 'recommend' | 'best' | 'new' | 'up';
  disabled?: boolean; // 캐스케이드 런타임 계산. 어댑터 초기값 false.
  priceColorCount?: number; // dosu→CLR_CNT 평면화 (가격요청 조립용, 불투명)
}

export interface OptionGroup {
  id: string; // 불투명 그룹 식별 (어댑터 생성, 안정 키)
  side: SideKey;
  label: string; // 동적 라벨 (RULE-5 — 하드코딩 금지)
  componentType: ComponentType;
  required: boolean; // ESN_YN 매핑
  visible: boolean; // VIEW_YN 매핑 (false=hidden essential, 자동적용)
  multiple?: boolean; // 다중 선택 여부 (후가공 등)
  values: OptionValue[]; // 동적 .map() 대상
  inputSpec?: InputSpec; // 입력형(counter/area/page) — values 대신
}

export interface EditorCapability {
  koi: boolean;
  rp: boolean;
  pdf: boolean;
}

export interface CtaCapability {
  pdfUpload: boolean;
  designEditor: boolean;
  cart: boolean;
  estimate: boolean;
}

export interface NormalizedProduct {
  code: string; // 불투명 상품 식별자
  name: string;
  unit: string; // "권" | "개" — 표시용
  priceSchemeKey: string; // 불투명 가격체계 키. 위젯은 가격요청에 echo만.
  sides: ProductSide[];
  optionGroups: OptionGroup[]; // 렌더 순서대로
  constraints: NormalizedConstraints;
  editors: EditorCapability;
  cta: CtaCapability;
}
