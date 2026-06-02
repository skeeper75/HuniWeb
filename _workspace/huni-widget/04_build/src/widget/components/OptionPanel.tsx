// component-tree §1 — OptionPanel: optionGroups.filter(visible).map() (RULE-5 동적, Zone 하드코딩 금지).
// 책자: 표지(default)/내지(inner) side 섹션 분리.
import type { SideKey } from '@/contract';
import { useProduct } from '../stores/context';
import { OptionControl } from './controls/OptionControl';
import { PriceSummary } from './PriceSummary';
import { OrderCTA } from './OrderCTA';
import type { NormalizedCartHandoff } from '@/contract';

function SideSection({ side, label }: { side: SideKey; label: string }) {
  const product = useProduct();
  if (!product) return null;
  // visible=false 는 hidden essential(자동적용) → UI 미렌더.
  const groups = product.optionGroups.filter((g) => g.side === side && g.visible);
  if (groups.length === 0) return null;
  const multiSide = product.sides.length > 1;
  return (
    <section className="flex flex-col gap-5">
      {multiSide && <h2 className="text-[16px] font-semibold text-[#424242]">{label}</h2>}
      {groups.map((g) => (
        <div key={g.id} className="flex flex-col gap-2">
          <label className="text-[16px] font-medium text-[#424242]">{g.label}</label>
          <OptionControl group={g} />
        </div>
      ))}
    </section>
  );
}

export function OptionPanel({
  onCartHandoff,
}: {
  onCartHandoff?: (p: NormalizedCartHandoff) => void;
}) {
  const product = useProduct();
  if (!product) return null;

  return (
    <div className="flex flex-col gap-8 bg-white p-6 text-[#424242]">
      {product.sides.map((s) => (
        <SideSection key={s.key} side={s.key} label={s.label} />
      ))}
      <div className="border-t border-[#CACACA] pt-6">
        <PriceSummary />
      </div>
      <OrderCTA onCartHandoff={onCartHandoff} />
    </div>
  );
}
