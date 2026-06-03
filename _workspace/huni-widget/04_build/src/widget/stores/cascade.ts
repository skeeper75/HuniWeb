// 캐스케이드 룰엔진 — cascade-rules.md 6종 + state-management §4.
// 적용 순서 보존: 자재변경 → disable 룩업 → UI disable → 선택해제 → (가격재계산은 store 가 호출).
import type { NormalizedProduct, OptionGroup } from '@/contract';
import type { SelectionValue } from './widget-store';

// 그룹이 자재 그룹인지 판별 (어댑터가 부여한 안정 id 규칙: GRP_MTRL_*).
function isMaterialGroup(g: OptionGroup): boolean {
  return g.id.startsWith('GRP_MTRL');
}

// C-A: L-2 합성분해(COT_DFT/SCO_DFT → __side/__coating)로 그룹 id 가 base 와 달라진다.
//  disableRules 는 base PCS_CD(PCS_COT_DFT)를 가리키므로, 합성 분해된 그룹(PCS_COT_DFT__coating/__side)도
//  base 매칭으로 disable 이 적용돼야 한다(미스매치 silent no-op 방지, wave-a-verification §6 C-A).
const COMPOSITE_SUFFIXES = ['__side', '__coating'];
function compositeBaseId(groupId: string): string | undefined {
  for (const suf of COMPOSITE_SUFFIXES) {
    if (groupId.endsWith(suf)) return groupId.slice(0, -suf.length);
  }
  return undefined;
}
// 그룹이 disable 대상 집합에 걸리는지 — 직접 id 또는 합성 base id 로 매칭.
function groupDisabledBy(groupId: string, disabledSet: Set<string>): boolean {
  if (disabledSet.has(groupId)) return true;
  const base = compositeBaseId(groupId);
  return base != null && disabledSet.has(base);
}

export interface CascadeResult {
  product: NormalizedProduct;
  selections: Record<string, SelectionValue>;
}

// P4 (L-D2-1): VIEW_YN 런타임 동적 add/remove + hidden-essential 자동선택.
//  ① 활성 선택값들이 트리거하는 visibilityRules 로 그룹 visible 토글(add/remove).
//  ② required+숨김(VIEW_YN:N) 그룹은 hidden essential — 렌더 안 되지만 default 값이 항상 선택돼야 함.
//     cascade/사용자 해제로 비어버리면 첫 값 자동 재적재(가격요청 PCS_INFO 누락 방지).
//  disable(회색) 과 독립 축 — 본 단계는 visible 토글 + hidden essential 선택만(가격재계산은 store).
function applyVisibilityAndEssential(
  product: NormalizedProduct,
  selections: Record<string, SelectionValue>,
): CascadeResult {
  const rules = product.constraints.visibilityRules ?? [];
  let nextProduct = product;
  if (rules.length > 0) {
    // 활성 선택값 집합(단일/배열) 수집.
    const activeIds = new Set<string>();
    for (const v of Object.values(selections)) {
      for (const id of Array.isArray(v) ? v : [v]) if (id != null) activeIds.add(id);
    }
    const show = new Set<string>();
    const hide = new Set<string>();
    for (const r of rules) {
      if (!activeIds.has(r.triggerValueId)) continue;
      if (r.showsGroupId) show.add(r.showsGroupId);
      if (r.hidesGroupId) hide.add(r.hidesGroupId);
    }
    if (show.size > 0 || hide.size > 0) {
      const nextGroups = product.optionGroups.map((g) =>
        show.has(g.id)
          ? { ...g, visible: true }
          : hide.has(g.id)
            ? { ...g, visible: false }
            : g,
      );
      nextProduct = { ...product, optionGroups: nextGroups };
    }
  }

  // [C-B] required + 미선택 + 활성값보유 그룹 자가복구 — visible/hidden 대칭.
  //  이전(C-B 버그): `g.visible` 조건이 hidden-essential 만 채워, 자재 왕복(RXOMO080→RXART300)으로
  //  re-enable 된 visible+required 합성그룹(PCS_COT_DFT__side/__coating)은 selection 영구 undefined →
  //  가격요청서 코팅 소실. visible 조건 제거로 visible required 그룹도 첫 활성값 재적재.
  //  Red mod_07:2266 coating watcher(`find(!disabled)`, 빈값 금지)와 정합. 활성값 없으면(전체 disable) skip.
  const nextSelections = { ...selections };
  for (const g of nextProduct.optionGroups) {
    if (!g.required || g.inputSpec || g.values.length === 0) continue;
    if (nextSelections[g.id] != null) continue;
    const first = g.values.find((v) => v.disabled !== true);
    if (first) nextSelections[g.id] = first.id;
  }
  return { product: nextProduct, selections: nextSelections };
}

export function applyCascade(
  product: NormalizedProduct,
  selections: Record<string, SelectionValue>,
  changedGroupId: string,
): CascadeResult {
  const group = product.optionGroups.find((g) => g.id === changedGroupId);
  if (!group) return { product, selections };

  // 자재 그룹 변경이 아니면 disable 캐스케이드는 불필요하나, P4 visible 토글 + hidden essential 은 적용.
  if (!isMaterialGroup(group)) {
    return applyVisibilityAndEssential(product, selections);
  }

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
    // C-A: 합성 base id 매칭 포함 — PCS_COT_DFT 룰이 PCS_COT_DFT__coating/__side 에도 적용.
    const groupDisabled = groupDisabledBy(g.id, activeGroupDisable);
    const nextValues = g.values.map((v) => ({
      ...v,
      disabled: groupDisabled || activeValueDisable.has(v.id),
    }));
    return { ...g, values: nextValues };
  });
  const nextProduct: NormalizedProduct = { ...product, optionGroups: nextGroups };

  // ③ 선택해제 연쇄: disable 된 값이 선택돼 있었으면 해제
  // C-2 폴백(mod_07:2266~2269): required 그룹은 빈 선택 대신 첫 활성값으로 자동 재선택.
  //  Red 는 현재값이 disable 되면 find(!disabled) 활성값을 채운다. 우리는 기존엔 지우기만(빈 선택) → 정합.
  const nextSelections = { ...selections };
  // 그룹별 첫 활성값 룩업(C-2 자동 재선택용). nextGroups 의 disabled 반영본을 본다.
  const firstActiveOf = (g: OptionGroup): string | undefined =>
    g.values.find((v) => v.disabled !== true)?.id;
  for (const g of nextProduct.optionGroups) {
    const cur = nextSelections[g.id];
    if (cur == null) continue;
    // C-A: 합성 base id 매칭 포함.
    const allDisabled =
      groupDisabledBy(g.id, disabledGroupIds) || groupDisabledBy(g.id, activeGroupDisable);
    if (allDisabled) {
      // 그룹 전체 비활성 — 재선택할 활성값 없음. 해제.
      delete nextSelections[g.id];
      continue;
    }
    if (Array.isArray(cur)) {
      const kept = cur.filter((id) => !disabledValueIds.has(id) && !activeValueDisable.has(id));
      // C-2: 멀티 required 인데 전부 제거됐으면 첫 활성값 1개 자동선택.
      if (kept.length === 0 && g.required && !g.inputSpec) {
        const fa = firstActiveOf(g);
        nextSelections[g.id] = fa ? [fa] : kept;
      } else {
        nextSelections[g.id] = kept;
      }
    } else if (disabledValueIds.has(cur) || activeValueDisable.has(cur)) {
      // C-2: 단일 선택값이 disable 됨 → required 면 첫 활성값으로 자동 재선택, 아니면 해제.
      const fa = g.required && !g.inputSpec ? firstActiveOf(g) : undefined;
      if (fa) nextSelections[g.id] = fa;
      else delete nextSelections[g.id];
    }
  }

  // P4: 자재 변경 후에도 visible 토글 + hidden essential 자동선택을 이어 적용(disable 결과 위에).
  return applyVisibilityAndEssential(nextProduct, nextSelections);
}
