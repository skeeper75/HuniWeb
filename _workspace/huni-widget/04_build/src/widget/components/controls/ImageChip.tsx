// #6 image-chip — RULE-6-EXT: 50×50 원형, 선택 ring-2, 실패시 placeholder #F5F5F5, 라벨 11px 하단.
import { useState } from 'react';
import type { OptionGroup } from '@/contract';
import { cn } from '../primitives/cn';

interface Props {
  group: OptionGroup;
  value: string | string[] | undefined;
  onChange: (valueId: string | string[]) => void;
}

function ImageItem({
  label,
  imageUrl,
  selected,
  disabled,
  onClick,
}: {
  label: string;
  imageUrl?: string;
  selected: boolean;
  disabled: boolean;
  onClick: () => void;
}) {
  const [failed, setFailed] = useState(false);
  return (
    <div className="flex flex-col items-center gap-1">
      <button
        type="button"
        aria-label={label}
        aria-pressed={selected}
        aria-disabled={disabled}
        disabled={disabled}
        onClick={onClick}
        className={cn(
          'flex h-[50px] w-[50px] items-center justify-center overflow-hidden rounded-full border border-[#CACACA]',
          selected && 'ring-2 ring-[#553886] ring-offset-2',
          disabled && 'opacity-40 cursor-not-allowed',
        )}
        style={{ backgroundColor: failed || !imageUrl ? '#F5F5F5' : undefined }}
      >
        {imageUrl && !failed && (
          <img
            src={imageUrl}
            alt={label}
            className="h-full w-full object-cover"
            onError={() => setFailed(true)}
          />
        )}
      </button>
      <span className="text-[11px] text-[#979797]">{label}</span>
    </div>
  );
}

export function ImageChipGroup({ group, value, onChange }: Props) {
  const selectedId = Array.isArray(value) ? value[0] : value;
  return (
    <div className="flex flex-wrap gap-3" role="radiogroup" aria-label={group.label}>
      {group.values.map((v) => (
        <ImageItem
          key={v.id}
          label={v.label}
          imageUrl={v.imageUrl}
          selected={v.id === selectedId}
          disabled={v.disabled === true}
          onClick={() => v.disabled !== true && onChange(v.id)}
        />
      ))}
    </div>
  );
}
