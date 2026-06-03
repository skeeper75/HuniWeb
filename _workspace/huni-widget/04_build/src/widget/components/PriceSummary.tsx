// #13 summary — DESIGN 7.13: 항목 12px #616161 + 금액, 합계 24px/600 보라.
// [HARD] 위젯은 계산 안 함 — NormalizedPriceBreakdown 표시만.
import { usePrice, useStatus } from '../stores/context';

const won = (n: number) => `${n.toLocaleString('ko-KR')}원`;

export function PriceSummary() {
  const price = usePrice();
  const status = useStatus();

  if (status === 'loading' || (!price && status === 'pricing')) {
    return <div className="text-[12px] text-[#979797]">가격 계산 중...</div>;
  }
  if (!price) return null;

  return (
    <div className="flex flex-col gap-2">
      {/* 공정별 분해 (투명성 — 후니 차별점). 백엔드가 lines 제공 시만 표시 */}
      {price.lines.length > 0 && (
        <div className="flex flex-col gap-1">
          {price.lines.map((l) => (
            <div key={l.code} className="flex justify-between text-[12px]">
              <span className="text-[#616161]">{l.label}</span>
              <span className="text-[#424242]">{won(l.amount)}</span>
            </div>
          ))}
        </div>
      )}
      <div className="my-1 h-px bg-[#CACACA]" />
      <div className="flex items-center justify-between">
        <span className="text-[12px] text-[#424242]">부가세</span>
        <span className="text-[12px] text-[#424242]">{won(price.vat)}</span>
      </div>
      {price.shipping > 0 && (
        <div className="flex items-center justify-between">
          <span className="text-[12px] text-[#424242]">배송비</span>
          <span className="text-[12px] text-[#424242]">{won(price.shipping)}</span>
        </div>
      )}
      <div className="mt-1 flex items-center justify-between">
        <span className="text-[16px] font-semibold text-[#1E1E1E]">합계</span>
        <span className="text-[24px] font-semibold text-[#553886]">{won(price.finalPrice)}</span>
      </div>
    </div>
  );
}
