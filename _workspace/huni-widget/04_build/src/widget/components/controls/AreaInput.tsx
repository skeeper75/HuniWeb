// #9 area-input — DESIGN 7.9: 각 140×50, X 구분자 #424242, placeholder #CACACA, help 11px.
import type { InputSpec } from '@/contract';

interface Props {
  spec: InputSpec;
  value: [number, number] | number | undefined;
  onChange: (v: [number, number]) => void;
}

export function AreaInput({ spec, value, onChange }: Props) {
  const pair: [number, number] = Array.isArray(value)
    ? value
    : [spec.defaultValue, spec.axis2 ? spec.axis2.min : spec.defaultValue];

  const setAxis = (idx: 0 | 1, raw: string) => {
    const n = parseInt(raw.replace(/[^0-9]/g, ''), 10);
    const next: [number, number] = [...pair] as [number, number];
    next[idx] = Number.isFinite(n) ? n : 0;
    onChange(next);
  };

  return (
    <div>
      <div className="flex items-center gap-2">
        <input
          type="text"
          inputMode="numeric"
          aria-label="가로"
          value={pair[0]}
          onChange={(e) => setAxis(0, e.target.value)}
          placeholder="가로"
          className="h-[50px] w-[140px] border border-[#CACACA] bg-white px-3 text-[14px] text-[#424242] outline-none placeholder:text-[#CACACA] focus:border-[#553886]"
        />
        <span className="text-[14px] text-[#424242]">X</span>
        <input
          type="text"
          inputMode="numeric"
          aria-label="세로"
          value={pair[1]}
          onChange={(e) => setAxis(1, e.target.value)}
          placeholder="세로"
          className="h-[50px] w-[140px] border border-[#CACACA] bg-white px-3 text-[14px] text-[#424242] outline-none placeholder:text-[#CACACA] focus:border-[#553886]"
        />
      </div>
      {spec.helpText && <p className="mt-1 text-[11px] text-[#979797]">{spec.helpText}</p>}
    </div>
  );
}
