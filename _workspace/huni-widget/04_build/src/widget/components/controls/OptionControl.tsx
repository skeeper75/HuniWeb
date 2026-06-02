// component-tree §3 — 단일 switch 디스패처(팩토리/레지스트리 추상화 금지, 14개 고정).
// summary/upload-cta 는 OptionGroup 이 아니라 패널 고정 컴포넌트라 디스패처 제외.
import type { OptionGroup } from '@/contract';
import { useOptionSelection, useGroupValues, useWidgetSelector } from '../../stores/context';
import { OptionButtonGroup, FinishButtonGroup } from './OptionButton';
import { HuniSelect, FinishSelect } from './HuniSelect';
import { CounterInput, PageCounterInput } from './CounterInput';
import { ColorChipGroup, MiniColorChipGroup, LargeColorChipGroup } from './ColorChip';
import { ImageChipGroup } from './ImageChip';
import { PriceSlider } from './PriceSlider';
import { AreaInput } from './AreaInput';

export function OptionControl({ group }: { group: OptionGroup }) {
  const { value, set } = useOptionSelection(group.id);
  // 캐스케이드 disabled 반영을 위해 store 의 최신 values 를 구독.
  const liveValues = useGroupValues(group.id);
  const liveGroup: OptionGroup = liveValues ? { ...group, values: liveValues } : group;

  switch (group.componentType) {
    case 'option-button':
      return <OptionButtonGroup group={liveGroup} value={value} onChange={set} />;
    case 'finish-button':
      return <FinishButtonGroup group={liveGroup} value={value} onChange={set} />;
    case 'select-box':
      return <HuniSelect group={liveGroup} value={value} onChange={set} />;
    case 'finish-select-box':
      return <FinishSelect group={liveGroup} value={value} onChange={set} />;
    case 'color-chip':
      return <ColorChipGroup group={liveGroup} value={value} onChange={set} />;
    case 'mini-color-chip':
      return <MiniColorChipGroup group={liveGroup} value={value} onChange={set} />;
    case 'large-color-chip':
      return <LargeColorChipGroup group={liveGroup} value={value} onChange={set} />;
    case 'image-chip':
      return <ImageChipGroup group={liveGroup} value={value} onChange={set} />;
    case 'counter-input':
      return <CounterInputBridge group={group} />;
    case 'page-counter-input':
      return <PageCounterBridge group={group} />;
    case 'area-input':
      return <AreaInputBridge group={group} />;
    case 'price-slider':
      return <PriceSliderBridge group={group} />;
    // summary / upload-cta 는 디스패처 대상 아님(패널 고정)
    case 'summary':
    case 'upload-cta':
      return null;
  }
}

// 입력형 — quantity/pageCount 는 store 의 전용 상태를 쓰므로 별도 브리지.
function CounterInputBridge({ group }: { group: OptionGroup }) {
  const quantity = useWidgetSelector((s) => s.quantity);
  const setQuantity = useWidgetSelector((s) => s.setQuantity);
  if (!group.inputSpec) return null;
  return <CounterInput spec={group.inputSpec} value={quantity} onChange={setQuantity} />;
}

function PageCounterBridge({ group }: { group: OptionGroup }) {
  const pageCount = useWidgetSelector((s) => s.pageCount);
  const setPageCount = useWidgetSelector((s) => s.setPageCount);
  if (!group.inputSpec) return null;
  return <PageCounterInput spec={group.inputSpec} value={pageCount} onChange={setPageCount} />;
}

// area-input / price-slider 는 일반 selection 슬롯에 보관(문자열 직렬화). 본 패스는 selection 으로 처리.
function AreaInputBridge({ group }: { group: OptionGroup }) {
  const { value, set } = useOptionSelection(group.id);
  if (!group.inputSpec) return null;
  const parsed = typeof value === 'string' && value.includes('x')
    ? (value.split('x').map(Number) as [number, number])
    : undefined;
  return (
    <AreaInput
      spec={group.inputSpec}
      value={parsed}
      onChange={(v) => set(`${v[0]}x${v[1]}`)}
    />
  );
}

function PriceSliderBridge({ group }: { group: OptionGroup }) {
  const { value, set } = useOptionSelection(group.id);
  if (!group.inputSpec) return null;
  const n = typeof value === 'string' ? Number(value) : undefined;
  return <PriceSlider spec={group.inputSpec} value={n} onChange={(v) => set(String(v))} />;
}
