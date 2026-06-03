// #2 select-box / #12 finish-select-box — RULE-1: native <select> 금지, Popover+커스텀 목록.
// ▼ 텍스트 캐럿(#979797), Lucide 등 아이콘 폰트 금지(DESIGN [CRITICAL]).
import * as Popover from '@radix-ui/react-popover';
import { useState } from 'react';
import type { OptionGroup } from '@/contract';
import { cn } from '../primitives/cn';
import { usePortalContainer } from '../../shadow/portal-context';

interface Props {
  group: OptionGroup;
  value: string | string[] | undefined;
  onChange: (valueId: string | string[]) => void;
  width?: number; // 348(select) | 461(finish-select)
}

function HuniSelectBase({ group, value, onChange, width = 348 }: Props) {
  const [open, setOpen] = useState(false);
  // [CRITICAL] Shadow Root 내부 포털 컨테이너 — 미지정 시 목록 스타일 전부 붕괴.
  const container = usePortalContainer();
  const selectedId = Array.isArray(value) ? value[0] : value;
  const selected = group.values.find((v) => v.id === selectedId);

  return (
    <Popover.Root open={open} onOpenChange={setOpen}>
      <Popover.Trigger asChild>
        <button
          type="button"
          aria-label={group.label}
          aria-haspopup="listbox"
          style={{ width, height: 50 }}
          className={cn(
            'flex items-center justify-between rounded-[4px] bg-white px-4 text-[14px]',
            'border',
            open ? 'border-[#553886]' : 'border-[#CACACA]',
            selected ? 'text-[#424242]' : 'text-[#979797]',
          )}
        >
          <span className="truncate">{selected?.label ?? `${group.label} 선택`}</span>
          {/* ▼ 텍스트 캐럿 (아이콘 폰트 금지) */}
          <span className="ml-2 text-[12px] text-[#979797]">▼</span>
        </button>
      </Popover.Trigger>
      <Popover.Portal container={container}>
        <Popover.Content
          align="start"
          sideOffset={4}
          role="listbox"
          className="z-50 max-h-[280px] overflow-y-auto rounded-b-[4px] border border-[#CACACA] bg-white"
          style={{ width, boxShadow: '0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1)' }}
        >
          {group.values.map((v) => {
            const isSel = v.id === selectedId;
            const disabled = v.disabled === true;
            return (
              <div
                key={v.id}
                role="option"
                aria-selected={isSel}
                aria-disabled={disabled}
                onClick={() => {
                  if (disabled) return;
                  onChange(v.id);
                  setOpen(false);
                }}
                className={cn(
                  'flex h-[44px] items-center px-4 text-[14px]',
                  disabled
                    ? 'cursor-not-allowed text-[#CACACA]'
                    : 'cursor-pointer hover:bg-[#F5F5F5]',
                  isSel ? 'text-[#553886]' : 'text-[#424242]',
                )}
              >
                {v.label}
              </div>
            );
          })}
        </Popover.Content>
      </Popover.Portal>
    </Popover.Root>
  );
}

export function HuniSelect(props: Props) {
  return <HuniSelectBase {...props} width={348} />;
}

export function FinishSelect(props: Props) {
  return <HuniSelectBase {...props} width={461} />;
}
