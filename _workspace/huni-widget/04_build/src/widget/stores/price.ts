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
// NC-1: 자유입력 모드(SIZE_0 sentinel: cutW=0&cutH=0)일 때 numeric slot 의 사용자 수치를 직접 전달.
function dimsFromSelection(s: WidgetState, side: SideKey): PriceDimension {
  const product = s.product!;
  const sizeGroup = product.optionGroups.find((g) => g.id === 'GRP_SIZE');
  const sel = sizeGroup ? selectedId(s.selections[sizeGroup.id]) : undefined;
  const rule = product.constraints.sizeRules.find((r) => r.valueId === sel);
  // 자유입력 분기: 선택된 규격 rule 이 0×0 sentinel("사이즈직접입력")이고 사용자 수치가 있으면 직접 공급.
  // 작업사이즈 = 재단사이즈 + CUT_MRG(BaseRule). 가격 산술 없음 — 수치 전달만(INV-1).
  if (sizeGroup && rule && rule.cutW === 0 && rule.cutH === 0) {
    const dim = s.dimensionInputs[sizeGroup.id];
    if (dim && (dim.w > 0 || dim.h > 0)) {
      const mrg = product.constraints.base.cutMargin;
      return { side, cutW: dim.w, cutH: dim.h, workW: dim.w + mrg, workH: dim.h + mrg };
    }
  }
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

// L-2 복합 2축 후가공 그룹 식별 suffix (어댑터가 PCS_DTL_CD 를 coating/side 2축으로 분해할 때 부여).
//  직렬화 전에 store 가 `coating+side` 단일 PCS_DTL_COD 로 재합성한다.
const COMPOSITE_SIDE_SUFFIX = '__side';
const COMPOSITE_COATING_SUFFIX = '__coating';

function selectedAttb(g: OptionGroup, valueId: string): string | undefined {
  // L-1: 선택값의 attb(어댑터가 산출한 불투명 속성문자열) 운반. 미보유 시 undefined.
  return g.values.find((v) => v.id === valueId)?.attb;
}

function finishesFromSelections(s: WidgetState): SelectedFinish[] {
  const product = s.product!;
  const groups = product.optionGroups as OptionGroup[];
  const out: SelectedFinish[] = [];
  // L-2: 복합 2축(coating/side) 그룹 base PCS_CD 별로 짝을 모아 재합성.
  const composite = new Map<string, { coating?: string; side?: string }>();
  for (const g of groups) {
    if (!g.id.startsWith('PCS_')) continue;
    // L-2: 복합 2축 그룹은 직접 emit 하지 않고 base 별로 모음(아래에서 재합성).
    if (g.id.endsWith(COMPOSITE_SIDE_SUFFIX) || g.id.endsWith(COMPOSITE_COATING_SUFFIX)) {
      const sel = selectedId(s.selections[g.id]);
      if (sel == null) continue;
      const isSide = g.id.endsWith(COMPOSITE_SIDE_SUFFIX);
      const base = g.id.slice(0, g.id.lastIndexOf('__'));
      const entry = composite.get(base) ?? {};
      if (isSide) entry.side = sel;
      else entry.coating = sel;
      composite.set(base, entry);
      continue;
    }
    const v = s.selections[g.id];
    if (v == null) continue;
    for (const valueId of Array.isArray(v) ? v : [v]) {
      out.push({ groupId: g.id, valueId, attb: selectedAttb(g, valueId) });
    }
  }
  // L-2 재합성: coating+side 둘 다 선택된 base 만 단일 PCS_DTL_COD(=coating+side)로 emit.
  for (const [base, { coating, side }] of composite) {
    if (coating != null && side != null) {
      out.push({ groupId: base, valueId: `${coating}${side}` });
    }
  }
  return out;
}

export function buildPriceRequest(s: WidgetState): NormalizedPriceRequest {
  const product = s.product!;
  return {
    productCode: product.code,
    priceSchemeKey: product.priceSchemeKey, // 불투명 echo
    itemGroup: product.itemGroup, // D-L2 불투명 분류 echo (직렬화 스키마 분기 권위)
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
// [HARD] 중첩 객체 키까지 안정 정렬해야 옵션 변경(dimensions/selectedFinishes/materials/colorCounts 내부)이
//  서로 다른 키를 낸다. JSON.stringify(req, replacerArray) 는 replacer 가 모든 레벨에 적용돼 중첩 키를 누락하므로 금지.
function stableSerialize(v: unknown): string {
  if (v === null || typeof v !== 'object') return JSON.stringify(v) ?? 'null';
  if (Array.isArray(v)) return `[${v.map(stableSerialize).join(',')}]`;
  const obj = v as Record<string, unknown>;
  const body = Object.keys(obj)
    .sort()
    .map((k) => `${JSON.stringify(k)}:${stableSerialize(obj[k])}`)
    .join(',');
  return `{${body}}`;
}

export function hashRequest(req: NormalizedPriceRequest): string {
  return stableSerialize(req);
}
