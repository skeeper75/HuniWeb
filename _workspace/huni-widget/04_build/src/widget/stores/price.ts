// 가격 요청 조립 + 결정적 해시 — price-engine.md §1·3.
// [HARD] 위젯은 단가/공식 없음. 옵션 선택을 정규화 요청으로 조립만.
import type {
  NormalizedPriceRequest,
  PriceDimension,
  SelectedFinish,
  SideKey,
  OptionGroup,
} from '@/contract';
import type { WidgetState, SelectionValue } from './widget-store';

function selectedId(v: SelectionValue | undefined): string | undefined {
  if (v == null) return undefined;
  return Array.isArray(v) ? v[0] : v;
}

// 선택된 규격 → dimensions (cut/work). size 그룹의 선택값 → SizeRule.
function dimsFromSelection(s: WidgetState, side: SideKey): PriceDimension {
  const product = s.product!;
  const sizeGroup = product.optionGroups.find((g) => g.id === 'GRP_SIZE');
  const sel = sizeGroup ? selectedId(s.selections[sizeGroup.id]) : undefined;
  const rule = product.constraints.sizeRules.find((r) => r.valueId === sel);
  if (rule) {
    return { side, cutW: rule.cutW, cutH: rule.cutH, workW: rule.workW, workH: rule.workH };
  }
  return { side, cutW: 0, cutH: 0, workW: 0, workH: 0 };
}

// dosu 선택값의 priceColorCount 평면화 사용.
function colorCountsFromSelections(s: WidgetState): Partial<Record<SideKey, number>> {
  const product = s.product!;
  const out: Partial<Record<SideKey, number>> = {};
  for (const g of product.optionGroups) {
    if (!g.id.startsWith('GRP_DOSU')) continue;
    const sel = selectedId(s.selections[g.id]);
    const val = g.values.find((v) => v.id === sel);
    if (val?.priceColorCount != null) out[g.side] = val.priceColorCount;
  }
  return out;
}

function materialsFromSelections(s: WidgetState): Partial<Record<SideKey, string>> {
  const product = s.product!;
  const out: Partial<Record<SideKey, string>> = {};
  for (const g of product.optionGroups) {
    if (!g.id.startsWith('GRP_MTRL')) continue;
    const sel = selectedId(s.selections[g.id]);
    if (sel) out[g.side] = sel;
  }
  return out;
}

function finishesFromSelections(s: WidgetState): SelectedFinish[] {
  const product = s.product!;
  const out: SelectedFinish[] = [];
  for (const g of product.optionGroups as OptionGroup[]) {
    if (!g.id.startsWith('PCS_')) continue;
    const v = s.selections[g.id];
    if (v == null) continue;
    for (const valueId of Array.isArray(v) ? v : [v]) out.push({ groupId: g.id, valueId });
  }
  return out;
}

export function buildPriceRequest(s: WidgetState): NormalizedPriceRequest {
  const product = s.product!;
  return {
    productCode: product.code,
    priceSchemeKey: product.priceSchemeKey, // 불투명 echo
    customerTier: s.member.tier,
    dimensions: product.sides.map((side) => dimsFromSelection(s, side.key)),
    colorCounts: colorCountsFromSelections(s),
    materials: materialsFromSelections(s),
    quantity: s.quantity,
    pageCount: s.pageCount,
    selectedFinishes: finishesFromSelections(s),
  };
}

// 결정적 직렬화 해시 — 동일 옵션 조합 = 동일 키 (price-engine §3 캐시 키).
export function hashRequest(req: NormalizedPriceRequest): string {
  const stable = JSON.stringify(req, Object.keys(req).sort());
  return stable;
}
