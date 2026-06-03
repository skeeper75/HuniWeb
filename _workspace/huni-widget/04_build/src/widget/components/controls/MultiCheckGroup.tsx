// L-3a (D4 정당화 신규 leaf 1) — 멀티선택 후가공(귀돌이 ROU_DFT 4귀) 체크박스 그리드 + 전체토글.
//  Red(mod_07:3325~3330): u=선택목록 배열, l=전체토글(all 체크→전 4개 / all 해제+4개→비움 / 선택4=all on).
//  [HARD RULE-5] 라벨은 props(.map) — JSX 하드코딩 금지. 선택=흰배경+border-2 #553886(RULE-2 동형).
//  반경 ATTB(L-3b)는 Wave B(번들상수 이식) — 본 컨트롤은 귀 선택만(value=string[]).
import type { OptionGroup } from '@/contract';
import { cn } from '../primitives/cn';

interface Props {
  group: OptionGroup;
  value: string | string[] | undefined;
  onChange: (valueId: string[]) => void;
}

export function MultiCheckGroup({ group, value, onChange }: Props) {
  const selected = Array.isArray(value) ? value : value != null ? [value] : [];
  const enabled = group.values.filter((v) => v.disabled !== true);
  const allIds = enabled.map((v) => v.id);
  const allSelected = allIds.length > 0 && allIds.every((id) => selected.includes(id));

  // 전체토글: 전부 선택돼 있으면 비움, 아니면 전체 선택(Red 양방향 watch 동형).
  const toggleAll = () => onChange(allSelected ? [] : allIds);
  const toggleOne = (id: string) => {
    const next = selected.includes(id)
      ? selected.filter((x) => x !== id)
      : [...selected, id];
    onChange(next);
  };

  return (
    <div className="flex flex-col gap-2" role="group" aria-label={group.label}>
      <button
        type="button"
        aria-pressed={allSelected}
        onClick={toggleAll}
        style={{ height: 50 }}
        className={cn(
          'flex items-center justify-center rounded-[4px] text-[14px] font-semibold transition-colors border bg-white px-4',
          allSelected
            ? 'border-2 border-[#553886] text-[#553886]'
            : 'border-[#CACACA] text-[#979797] hover:border-[#553886]',
        )}
      >
        전체
      </button>
      <div className="flex flex-wrap gap-0">
        {group.values.map((v) => {
          const isOn = selected.includes(v.id);
          const disabled = v.disabled === true;
          return (
            <button
              key={v.id}
              type="button"
              role="checkbox"
              aria-checked={isOn}
              aria-disabled={disabled}
              disabled={disabled}
              onClick={() => !disabled && toggleOne(v.id)}
              style={{ width: 116, height: 50 }}
              className={cn(
                'flex items-center justify-center rounded-[4px] text-[14px] font-semibold transition-colors border bg-white',
                disabled
                  ? 'border-[#CACACA] bg-[#F5F5F5] text-[#CACACA] cursor-not-allowed'
                  : isOn
                    ? 'border-2 border-[#553886] text-[#553886]'
                    : 'border-[#CACACA] text-[#979797] hover:border-[#553886]',
              )}
            >
              {v.label}
            </button>
          );
        })}
      </div>
    </div>
  );
}
