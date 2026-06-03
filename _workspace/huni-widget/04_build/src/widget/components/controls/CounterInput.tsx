// #3 counter-input — RULE-3: 223×50 [34 −][155 값][34 +] 직사각 3-part. 원형/native-number 금지.
// #10 page-counter-input 도 동일 동작(min/max/step), 선택 ring-2 강조.
import type { InputSpec } from '@/contract';
import { cn } from '../primitives/cn';

interface Props {
  spec: InputSpec;
  value: number | undefined;
  onChange: (v: number) => void;
  variant?: 'counter' | 'page';
}

function clampStep(v: number, spec: InputSpec): number {
  let n = Math.min(Math.max(v, spec.min), spec.max);
  const base = spec.first ?? spec.min;
  const k = Math.max(0, Math.round((n - base) / spec.step));
  n = base + k * spec.step;
  return Math.min(Math.max(n, spec.min), spec.max);
}

export function CounterInput({ spec, value, onChange, variant = 'counter' }: Props) {
  const v = value ?? spec.defaultValue;
  const dec = () => onChange(clampStep(v - spec.step, spec));
  const inc = () => onChange(clampStep(v + spec.step, spec));
  const isPage = variant === 'page';

  return (
    <div
      className={cn(
        'flex items-stretch overflow-hidden rounded-[4px] bg-white',
        isPage ? 'border-2 border-[#553886]' : 'border border-[#CACACA]', // page 선택 ring 강조
      )}
      style={{ width: 223, height: 50 }}
    >
      <button
        type="button"
        aria-label="감소"
        onClick={dec}
        disabled={v <= spec.min}
        className="flex w-[34px] items-center justify-center border-r border-[#CACACA] text-[18px] text-[#424242] disabled:text-[#CACACA]"
      >
        −
      </button>
      <input
        type="text"
        inputMode="numeric"
        aria-label="수량"
        value={v}
        onChange={(e) => {
          const n = parseInt(e.target.value.replace(/[^0-9]/g, ''), 10);
          if (Number.isFinite(n)) onChange(n);
        }}
        onBlur={(e) => {
          const n = parseInt(e.target.value.replace(/[^0-9]/g, ''), 10);
          onChange(clampStep(Number.isFinite(n) ? n : spec.defaultValue, spec));
        }}
        className="w-[155px] border-0 bg-transparent text-center text-[14px] font-medium text-[#979797] outline-none"
        style={{ width: 155 }}
      />
      <button
        type="button"
        aria-label="증가"
        onClick={inc}
        disabled={v >= spec.max}
        className="flex w-[34px] items-center justify-center border-l border-[#CACACA] text-[18px] text-[#424242] disabled:text-[#CACACA]"
      >
        +
      </button>
    </div>
  );
}

export function PageCounterInput(props: Props) {
  return <CounterInput {...props} variant="page" />;
}
