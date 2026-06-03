// 정규화 계약 단일 진입점. 위젯은 여기서만 타입을 가져온다.
export type {
  SideKey,
  ComponentType,
  ProductSide,
  InputSpec,
  OptionValue,
  OptionGroup,
  AccFilterGroup,
  AccPanelSpec,
  EditorCapability,
  CtaCapability,
  NormalizedProduct,
} from './product';
export type {
  DisableRule,
  VisibilityRule,
  QuantityRule,
  SizeRule,
  BaseRule,
  NormalizedConstraints,
} from './constraints';
export type {
  PriceDimension,
  SelectedFinish,
  NormalizedPriceRequest,
  PriceLine,
  NormalizedPriceBreakdown,
} from './price';
export type {
  NormalizedPresignedRequest,
  NormalizedPresigned,
  NormalizedUploadResult,
} from './upload';
export type { NormalizedEditorConfig, NormalizedEditorResult } from './editor';
export type {
  SelectedOption,
  NormalizedArtifact,
  NormalizedCartHandoff,
  NormalizedOrderReadiness,
} from './cart';
