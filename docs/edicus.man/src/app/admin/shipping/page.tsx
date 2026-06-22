import type { Metadata } from 'next';
import { Truck } from 'lucide-react';

export const metadata: Metadata = {
  title: '배송 관리',
};

export default function ShippingPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">배송 관리</h1>
        <p className="mt-1 text-sm text-gray-500">배송 현황을 조회하고 관리합니다.</p>
      </div>

      {/* 준비 중 안내 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-12 text-center mb-5">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-orange-50">
          <Truck className="h-7 w-7 text-orange-600" aria-hidden="true" />
        </div>
        <h2 className="text-lg font-semibold text-gray-900 mb-2">배송 추적</h2>
        <p className="text-sm text-gray-500 mb-1">준비 중입니다.</p>
        <p className="text-xs text-gray-400">배송 조회, 운송장 입력, 배송 상태 업데이트 기능이 제공될 예정입니다.</p>
      </div>

      {/* 배송 현황 테이블 스켈레톤 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
          <Truck className="h-4 w-4 text-gray-400" aria-hidden="true" />
          <h2 className="text-sm font-semibold text-gray-900">배송 목록</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50">
                {['주문번호', '수령인', '배송지', '운송장번호', '배송상태', '배송일'].map((h) => (
                  <th
                    key={h}
                    className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide"
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              <tr>
                <td colSpan={6} className="px-4 py-12 text-center">
                  <p className="text-sm text-gray-400">준비 중입니다.</p>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
