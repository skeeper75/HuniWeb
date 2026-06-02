// #14 upload-cta — DESIGN 7.14: 465×50 radius 5px, outline/filled(#553886)/dark(#3B2573) 3종.
// CtaCapability 기반 노출. 본 패스는 cart-handoff 까지(커머스 바인딩 UNDECIDED).
import { useCanOrder, useProduct, useWidgetSelector } from '../stores/context';
import { cn } from './primitives/cn';

interface Props {
  onCartHandoff?: (payload: ReturnType<typeof handoffSnapshot>) => void;
}

// 타입 추론용 헬퍼 시그니처 (실제 호출은 store.cartHandoff).
function handoffSnapshot() {
  return undefined as unknown as import('@/contract').NormalizedCartHandoff;
}

export function OrderCTA({ onCartHandoff }: Props) {
  const product = useProduct();
  const { ok, reasons } = useCanOrder();
  const cartHandoff = useWidgetSelector((s) => s.cartHandoff);
  if (!product) return null;
  const cta = product.cta;

  const base =
    'flex h-[50px] items-center justify-center text-[14px] font-semibold transition-colors';
  const radius = { borderRadius: 5, width: 465, maxWidth: '100%' };

  return (
    <div className="flex flex-col gap-2">
      {cta.estimate && (
        <button
          type="button"
          style={radius}
          className={cn(base, 'border border-[#553886] bg-white text-[#553886]')}
        >
          견적 담기
        </button>
      )}
      {cta.cart && (
        <button
          type="button"
          style={radius}
          disabled={!ok}
          onClick={() => {
            const payload = cartHandoff();
            onCartHandoff?.(payload);
          }}
          className={cn(
            base,
            'bg-[#3B2573] text-white',
            !ok && 'cursor-not-allowed opacity-50',
          )}
        >
          장바구니 담기
        </button>
      )}
      {!ok && reasons.length > 0 && (
        <p className="text-[11px] text-[#979797]">{reasons.join(' / ')}</p>
      )}
    </div>
  );
}
