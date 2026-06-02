// #4 color-chip (50×50) / #7 mini-color-chip (32×32) / #8 large-color-chip (grid-cols-5, 50×50).
// RULE-4/7/8-EXT: 원형, 선택=흰채움+ring-2 #553886. 색상은 colorHex 동적.
import type { OptionGroup } from '@/contract';
import { cn } from '../primitives/cn';

interface Props {
  group: OptionGroup;
  value: string | string[] | undefined;
  onChange: (valueId: string | string[]) => void;
}

function Chip({
  hex,
  label,
  selected,
  disabled,
  size,
  onClick,
}: {
  hex?: string;
  label: string;
  selected: boolean;
  disabled: boolean;
  size: number;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      aria-label={label}
      aria-pressed={selected}
      aria-disabled={disabled}
      disabled={disabled}
      onClick={onClick}
      style={{ width: size, height: size, backgroundColor: hex ?? '#FFFFFF' }}
      className={cn(
        'rounded-full border border-[#CACACA] transition-shadow',
        selected && 'ring-2 ring-[#553886] ring-offset-2', // 흰채움 ring 강조
        disabled && 'opacity-40 cursor-not-allowed',
      )}
    />
  );
}

function ChipGroup({ group, value, onChange, size, grid }: Props & { size: number; grid?: boolean }) {
  const selectedId = Array.isArray(value) ? value[0] : value;
  return (
    <div
      className={cn(grid ? 'grid grid-cols-5 gap-3' : 'flex flex-wrap gap-3')}
      role="radiogroup"
      aria-label={group.label}
    >
      {group.values.map((v) => (
        <div key={v.id} className="flex flex-col items-center gap-1">
          <Chip
            hex={v.colorHex}
            label={v.label}
            selected={v.id === selectedId}
            disabled={v.disabled === true}
            size={size}
            onClick={() => v.disabled !== true && onChange(v.id)}
          />
          {grid && <span className="text-[11px] text-[#979797]">{v.label}</span>}
        </div>
      ))}
    </div>
  );
}

export function ColorChipGroup(props: Props) {
  return <ChipGroup {...props} size={50} />;
}

export function MiniColorChipGroup(props: Props) {
  return <ChipGroup {...props} size={32} />;
}

export function LargeColorChipGroup(props: Props) {
  return <ChipGroup {...props} size={50} grid />;
}
