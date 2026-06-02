// data-adapter.md §3 — componentType 매핑 규칙 (어댑터 결정 로직).
// [결정] 위젯이 아니라 어댑터가 "Red 데이터셋 → componentType" 을 결정. 룩업 테이블이면 충분(과한 휴리스틱 금지).
import type { ComponentType } from '@/contract';

// Red 논리 데이터셋 키 → componentType.
// PCS 그룹은 색상 여부에 따라 color-chip 분기가 필요하므로 별도 함수에서 처리.
export const DATASET_COMPONENT_TYPE: Record<string, ComponentType> = {
  size: 'option-button', // pdt_size_info (값 ≤ ~6, 텍스트)
  material: 'select-box', // pdt_mtrl_info (값 多)
  dosu: 'option-button', // pdt_dosu_info (단면/양면)
  quantity: 'counter-input', // pdt_base_info FIR/INC
  innerPage: 'page-counter-input', // 내지 페이지수 min/max/step
};

// 후가공(PCS) 그룹의 componentType 결정: 색상값(colorHex)이 있으면 color-chip, 아니면 finish-button.
export function pcsComponentType(hasColor: boolean): ComponentType {
  return hasColor ? 'color-chip' : 'finish-button';
}
