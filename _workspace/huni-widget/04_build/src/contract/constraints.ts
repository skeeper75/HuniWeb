// data-contract.md §2 — 캐스케이드 제약 계약 (6종).
import type { SideKey } from './product';

export interface DisableRule {
  triggerValueId: string; // 선택 시 트리거되는 OptionValue.id (Red MTRL_CD)
  disablesGroupId?: string; // 그룹 전체 비활성 (PCS_DTL_CD null)
  disablesValueId?: string; // 특정 값만 비활성
}

// P4 (L-D2-1): VIEW_YN 런타임 동적 add/remove (Red v() mod_06:1452).
//  특정 값 선택 시 후가공 그룹을 런타임에 표시(add)/숨김(remove)한다. disable(회색) 과 다른 축 —
//  visible 토글(렌더 자체 add/remove). 어댑터가 add_pcs_info/Red 룰에서 채움(현 fixture 미보유 시 빈 배열).
export interface VisibilityRule {
  triggerValueId: string; // 선택 시 트리거되는 OptionValue.id
  showsGroupId?: string; // 표시(add)할 그룹 id
  hidesGroupId?: string; // 숨김(remove)할 그룹 id
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
  // ①-b P4: material/값 → 그룹 visible 동적 토글(add/remove). OPTIONAL·additive(미보유 시 빈 배열).
  visibilityRules?: VisibilityRule[];
  // ② quantity (수량/페이지 clamp/snap) — side별
  quantity: Partial<Record<SideKey, QuantityRule>>;
  // ③ dosu↔bnc → OptionValue.priceColorCount 로 평면화 (별도 배열 없음)
  // ④ size (규격 → cut/work 치수)
  sizeRules: SizeRule[];
  // ⑤ pcs essential/hidden → OptionGroup.required/visible 로 평면화 (별도 배열 없음)
  // ⑥ base (단위·재단마진·최소/최대 치수)
  base: BaseRule;
}
