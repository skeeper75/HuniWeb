// data-contract.md §2 — 캐스케이드 제약 계약 (6종).
import type { SideKey } from './product';

export interface DisableRule {
  triggerValueId: string; // 선택 시 트리거되는 OptionValue.id (Red MTRL_CD)
  disablesGroupId?: string; // 그룹 전체 비활성 (PCS_DTL_CD null)
  disablesValueId?: string; // 특정 값만 비활성
}

export interface QuantityRule {
  min: number;
  first: number;
  increment: number;
  step: number;
  default: number;
  pageMin?: number; // 책자 내지
  pageMax?: number;
  pageStep?: number;
}

export interface SizeRule {
  valueId: string;
  cutW: number;
  cutH: number;
  workW: number;
  workH: number;
}

export interface BaseRule {
  unit: string;
  cutMargin: number;
  minCutW: number;
  minCutH: number;
  maxCutW: number;
  maxCutH: number;
  nonStandardAllowed: boolean;
}

export interface NormalizedConstraints {
  // ① material → pcs disable
  disableRules: DisableRule[];
  // ② quantity (수량/페이지 clamp/snap) — side별
  quantity: Partial<Record<SideKey, QuantityRule>>;
  // ③ dosu↔bnc → OptionValue.priceColorCount 로 평면화 (별도 배열 없음)
  // ④ size (규격 → cut/work 치수)
  sizeRules: SizeRule[];
  // ⑤ pcs essential/hidden → OptionGroup.required/visible 로 평면화 (별도 배열 없음)
  // ⑥ base (단위·재단마진·최소/최대 치수)
  base: BaseRule;
}
