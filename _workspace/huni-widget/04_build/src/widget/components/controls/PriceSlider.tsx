// #5 price-slider — RULE-5-EXT: @radix-ui/react-slider 필수(native range 금지).
// track 4px, thumb 16×16 원형 border-2, 틱 ≤6.
import * as Slider from '@radix-ui/react-slider';
import type { InputSpec } from '@/contract';

interface Props {
  spec: InputSpec;
  value: number | undefined;
  onChange: (v: number) => void;
}

export function PriceSlider({ spec, value, onChange }: Props) {
  const v = value ?? spec.defaultValue;
  // 틱 ≤6 — step 으로 분할되는 마커 (시각용)
  const tickCount = Math.min(6, Math.max(2, Math.floor((spec.max - spec.min) / spec.step) + 1));
  const ticks = Array.from({ length: tickCount }, (_, i) =>
    Math.round(spec.min + (i * (spec.max - spec.min)) / (tickCount - 1)),
  );

  return (
    <div className="w-full max-w-[348px]">
      <Slider.Root
        className="relative flex h-5 w-full touch-none select-none items-center"
        min={spec.min}
        max={spec.max}
        step={spec.step}
        value={[v]}
        onValueChange={([n]) => onChange(n)}
        aria-label="수량 슬라이더"
      >
        <Slider.Track className="relative h-1 w-full grow rounded-full bg-[#CACACA]">
          <Slider.Range className="absolute h-full rounded-full bg-[#553886]" />
        </Slider.Track>
        <Slider.Thumb className="block h-4 w-4 rounded-full border-2 border-[#553886] bg-white" />
      </Slider.Root>
      <div className="mt-1 flex justify-between">
        {ticks.map((t) => (
          <span key={t} className="text-[11px] text-[#979797]">
            {t}
          </span>
        ))}
      </div>
    </div>
  );
}
