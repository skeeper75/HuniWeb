import type { Metadata } from 'next';
import { BarChart3 } from 'lucide-react';

export const metadata: Metadata = {
  title: '판매 통계',
};

export default function StatsPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">판매 통계</h1>
        <p className="mt-1 text-sm text-gray-500">매출 및 주문 통계를 확인합니다.</p>
      </div>

      {/* 기간 선택 */}
      <div className="mb-5 flex gap-2">
        {['7일', '30일', '3개월', '1년'].map((period) => (
          <button
            key={period}
            className="rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-sm font-medium text-gray-700 hover:bg-gray-50 first:bg-huni-primary first:text-white first:border-huni-primary transition-colors"
            aria-label={`${period} 통계 보기`}
          >
            {period}
          </button>
        ))}
      </div>

      {/* 차트 플레이스홀더 */}
      <div className="grid grid-cols-1 gap-5 mb-5 lg:grid-cols-2">
        {[
          { title: '매출 추이', height: 'h-48' },
          { title: '주문 건수', height: 'h-48' },
        ].map(({ title, height }) => (
          <div key={title} className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
              <BarChart3 className="h-4 w-4 text-gray-400" aria-hidden="true" />
              <h2 className="text-sm font-semibold text-gray-900">{title}</h2>
            </div>
            <div className={`${height} p-5 flex items-center justify-center`}>
              <div className="text-center">
                <BarChart3 className="mx-auto h-10 w-10 text-gray-200 mb-2" aria-hidden="true" />
                <p className="text-sm text-gray-400">준비 중입니다.</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* 상품별 통계 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
          <h2 className="text-sm font-semibold text-gray-900">상품별 판매 통계</h2>
        </div>
        <div className="p-5 text-center py-10">
          <p className="text-sm text-gray-400">준비 중입니다.</p>
        </div>
      </div>
    </div>
  );
}
