// 캐스케이드 룰엔진 — cascade-rules.md 6종 + state-management §4.
// 적용 순서 보존: 자재변경 → disable 룩업 → UI disable → 선택해제 → (가격재계산은 store 가 호출).
import type { NormalizedProduct, OptionGroup } from '@/contract';
import type { SelectionValue } from './widget-store';

// 그룹이 자재 그룹인지 판별 (어댑터가 부여한 안정 id 규칙: GRP_MTRL_*).
function isMaterialGroup(g: OptionGroup): boolean {
  return g.id.startsWith('GRP_MTRL');
}

export interface CascadeResult {
  product: NormalizedProduct;
  selections: Record<string, SelectionValue>;
}

export function applyCascade(
  product: NormalizedProduct,
  selections: Record<string, SelectionValue>,
  changedGroupId: string,
): CascadeResult {
  const group = product.optionGroups.find((g) => g.id === changedGroupId);
  if (!group) return { product, selections };

  // 자재 그룹 변경이 아니면 disable 캐스케이드 불필요(size/dosu/quantity 는 가격재계산만).
  if (!isMaterialGroup(group)) return { product, selections };

  const selectedMtrl = selections[changedGroupId];
  const selectedId = Array.isArray(selectedMtrl) ? selectedMtrl[0] : selectedMtrl;

  // ① material → pcs disable 룩업
  const rules = product.constraints.disableRules.filter((r) => r.triggerValueId === selectedId);
  const disabledGroupIds = new Set(rules.map((r) => r.disablesGroupId).filter(Boolean) as string[]);
  const disabledValueIds = new Set(rules.map((r) => r.disablesValueId).filter(Boolean) as string[]);

  // ② UI disable: product.values[].disabled 갱신 (불변 복제 — immer 미사용, 단순 map)
  // 우선 모든 후가공 그룹의 disabled 를 재계산(이전 자재로 인한 disable 도 해제되도록).
  const allDisabledRules = product.constraints.disableRules;
  const activeMtrlIds = Object.entries(selections)
    .filter(([gid]) => product.optionGroups.find((g) => g.id === gid && isMaterialGroup(g)))
    .map(([, v]) => (Array.isArray(v) ? v[0] : v));
  const activeGroupDisable = new Set<string>();
  const activeValueDisable = new Set<string>();
  for (const r of allDisabledRules) {
    if (activeMtrlIds.includes(r.triggerValueId)) {
      if (r.disablesGroupId) activeGroupDisable.add(r.disablesGroupId);
      if (r.disablesValueId) activeValueDisable.add(r.disablesValueId);
    }
  }

  const nextGroups: OptionGroup[] = product.optionGroups.map((g) => {
    const groupDisabled = activeGroupDisable.has(g.id);
    const nextValues = g.values.map((v) => ({
      ...v,
      disabled: groupDisabled || activeValueDisable.has(v.id),
    }));
    return { ...g, values: nextValues };
  });
  const nextProduct: NormalizedProduct = { ...product, optionGroups: nextGroups };

  // ③ 선택해제 연쇄: disable 된 값이 선택돼 있었으면 해제
  const nextSelections = { ...selections };
  for (const g of nextProduct.optionGroups) {
    const cur = nextSelections[g.id];
    if (cur == null) continue;
    const allDisabled =
      disabledGroupIds.has(g.id) || activeGroupDisable.has(g.id);
    if (allDisabled) {
      delete nextSelections[g.id];
      continue;
    }
    if (Array.isArray(cur)) {
      const kept = cur.filter((id) => !disabledValueIds.has(id) && !activeValueDisable.has(id));
      nextSelections[g.id] = kept;
    } else if (disabledValueIds.has(cur) || activeValueDisable.has(cur)) {
      delete nextSelections[g.id];
    }
  }

  return { product: nextProduct, selections: nextSelections };
}
