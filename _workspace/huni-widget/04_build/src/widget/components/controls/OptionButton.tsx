// #1 option-button / #11 finish-button — RULE-2: 선택=흰배경+border-2 #553886+텍스트 #553886.
// [HARD RULE-5] 라벨은 props(.map) — JSX 하드코딩 금지.
import type { OptionGroup } from '@/contract';
import { cn } from '../primitives/cn';

interface Props {
  group: OptionGroup;
  value: string | string[] | undefined;
  onChange: (valueId: string | string[]) => void;
  width?: number; // 155(option) | 116(finish)
}

function OptionButtonBase({ group, value, onChange, width = 155 }: Props) {
  const selectedId = Array.isArray(value) ? value[0] : value;
  return (
    <div className="flex flex-wrap gap-0" role="radiogroup" aria-label={group.label}>
      {group.values.map((v) => {
        const selected = v.id === selectedId;
        const disabled = v.disabled === true;
        return (
          <button
            key={v.id}
            type="button"
            role="radio"
            aria-checked={selected}
            aria-disabled={disabled}
            disabled={disabled}
            onClick={() => !disabled && onChange(v.id)}
            style={{ width, height: 50 }}
            className={cn(
              'flex items-center justify-center rounded-[4px] text-[14px] font-semibold transition-colors',
              'border bg-white',
              disabled
                ? 'border-[#CACACA] bg-[#F5F5F5] text-[#CACACA] cursor-not-allowed'
                : selected
                  ? 'border-2 border-[#553886] text-[#553886]' // RULE-2 — 컬러 배경 채움 금지
                  : 'border-[#CACACA] text-[#979797] hover:border-[#553886]',
            )}
          >
            {v.label}
          </button>
        );
      })}
    </div>
  );
}

export function OptionButtonGroup(props: Props) {
  return <OptionButtonBase {...props} width={155} />;
}

export function FinishButtonGroup(props: Props) {
  return <OptionButtonBase {...props} width={116} />;
}
