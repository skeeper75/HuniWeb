import type { Metadata } from 'next';
import { TrendingUp } from 'lucide-react';

export const metadata: Metadata = {
  title: '인사이트',
};

export default function InsightsPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">인사이트</h1>
        <p className="mt-1 text-sm text-gray-500">비즈니스 분석 및 인사이트를 확인합니다.</p>
      </div>

      {/* 준비 중 안내 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-12 text-center mb-5">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-indigo-50">
          <TrendingUp className="h-7 w-7 text-indigo-600" aria-hidden="true" />
        </div>
        <h2 className="text-lg font-semibold text-gray-900 mb-2">비즈니스 인사이트</h2>
        <p className="text-sm text-gray-500 mb-1">준비 중입니다.</p>
        <p className="text-xs text-gray-400">
          고객 행동 분석, 인기 상품, 전환율 등 심층 분석 기능이 제공될 예정입니다.
        </p>
      </div>

      {/* 인사이트 카드 그리드 스켈레톤 */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {[
          '인기 템플릿',
          '고객 재주문율',
          '평균 주문 금액',
          '피크 타임',
          '지역별 주문',
          '취소율',
        ].map((title) => (
          <div key={title} className="rounded-xl bg-white border border-gray-200 p-5 shadow-sm">
            <h3 className="text-sm font-medium text-gray-500 mb-3">{title}</h3>
            <div className="h-6 bg-gray-100 rounded mb-2" />
            <div className="h-3 bg-gray-50 rounded w-2/3" />
          </div>
        ))}
      </div>
    </div>
  );
}
