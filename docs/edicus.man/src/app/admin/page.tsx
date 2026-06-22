import type { Metadata } from 'next';
import {
  ShoppingCart,
  Clock,
  CheckCircle,
  FolderOpen,
} from 'lucide-react';

export const metadata: Metadata = {
  title: '대시보드',
};

/** 요약 카드 데이터 */
const SUMMARY_CARDS = [
  {
    title: '총 주문',
    value: '—',
    description: '전체 주문 수',
    icon: ShoppingCart,
    colorClass: 'bg-huni-primary-light-3 text-huni-primary',
    borderClass: 'border-huni-primary-light-2',
  },
  {
    title: '진행중 주문',
    value: '—',
    description: '처리 중인 주문',
    icon: Clock,
    colorClass: 'bg-yellow-50 text-yellow-600',
    borderClass: 'border-yellow-100',
  },
  {
    title: '완료 주문',
    value: '—',
    description: '완료된 주문',
    icon: CheckCircle,
    colorClass: 'bg-green-50 text-green-600',
    borderClass: 'border-green-100',
  },
  {
    title: '총 프로젝트',
    value: '—',
    description: '전체 프로젝트 수',
    icon: FolderOpen,
    colorClass: 'bg-purple-50 text-purple-600',
    borderClass: 'border-purple-100',
  },
] as const;

export default function AdminDashboardPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900">대시보드</h1>
        <p className="mt-1 text-sm text-gray-500">
          Edicus Manager 현황을 한눈에 확인하세요.
        </p>
      </div>

      {/* 요약 카드 그리드 */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 mb-8">
        {SUMMARY_CARDS.map(({ title, value, description, icon: Icon, colorClass, borderClass }) => (
          <div
            key={title}
            className={`rounded-xl bg-white border ${borderClass} p-5 shadow-sm`}
          >
            <div className="flex items-center justify-between mb-3">
              <span className="text-sm font-medium text-gray-600">{title}</span>
              <div className={`flex h-9 w-9 items-center justify-center rounded-lg ${colorClass}`}>
                <Icon className="h-5 w-5" aria-hidden="true" />
              </div>
            </div>
            <p className="text-2xl font-bold text-gray-900">{value}</p>
            <p className="mt-1 text-xs text-gray-400">{description}</p>
          </div>
        ))}
      </div>

      {/* 최근 활동 섹션 */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* 최근 주문 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm">
          <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
            <h2 className="text-base font-semibold text-gray-900">최근 주문</h2>
            <a
              href="/admin/orders"
              className="text-sm font-medium text-huni-primary hover:text-huni-primary-dark"
            >
              전체 보기
            </a>
          </div>
          <div className="p-5">
            <div className="flex flex-col items-center justify-center py-8 text-center">
              <ShoppingCart className="h-10 w-10 text-gray-300 mb-3" aria-hidden="true" />
              <p className="text-sm text-gray-400">최근 주문이 없습니다.</p>
              <p className="text-xs text-gray-300 mt-1">주문이 들어오면 여기에 표시됩니다.</p>
            </div>
          </div>
        </div>

        {/* 최근 활동 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm">
          <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
            <h2 className="text-base font-semibold text-gray-900">최근 활동</h2>
          </div>
          <div className="p-5">
            <div className="flex flex-col items-center justify-center py-8 text-center">
              <Clock className="h-10 w-10 text-gray-300 mb-3" aria-hidden="true" />
              <p className="text-sm text-gray-400">최근 활동이 없습니다.</p>
              <p className="text-xs text-gray-300 mt-1">활동이 생기면 여기에 표시됩니다.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
