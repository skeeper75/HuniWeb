import type { Metadata } from 'next';
import { CreditCard } from 'lucide-react';

export const metadata: Metadata = {
  title: '결제/정산',
};

const PLACEHOLDER_ROWS = ['2024-01', '2024-02', '2024-03'];

export default function BillingPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">결제/정산</h1>
        <p className="mt-1 text-sm text-gray-500">결제 내역과 정산 현황을 확인합니다.</p>
      </div>

      {/* 요약 카드 */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-6">
        {[
          { label: '이번달 매출', value: '—', color: 'text-huni-primary' },
          { label: '정산 대기', value: '—', color: 'text-yellow-600' },
          { label: '정산 완료', value: '—', color: 'text-green-600' },
        ].map(({ label, value, color }) => (
          <div key={label} className="rounded-xl bg-white border border-gray-200 p-5 shadow-sm">
            <p className="text-xs font-medium text-gray-500 mb-2">{label}</p>
            <p className={`text-2xl font-bold ${color}`}>{value}</p>
          </div>
        ))}
      </div>

      {/* 준비 중 테이블 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
          <CreditCard className="h-4 w-4 text-gray-400" aria-hidden="true" />
          <h2 className="text-sm font-semibold text-gray-900">정산 내역</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50">
                {['기간', '매출액', '수수료', '정산액', '상태'].map((h) => (
                  <th
                    key={h}
                    className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide"
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {PLACEHOLDER_ROWS.map((row) => (
                <tr key={row} className="animate-pulse">
                  <td className="px-4 py-3">
                    <div className="h-4 bg-gray-200 rounded w-20" />
                  </td>
                  {[...Array(4)].map((_, i) => (
                    <td key={i} className="px-4 py-3">
                      <div className="h-4 bg-gray-100 rounded w-full" />
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="px-5 py-8 text-center border-t border-gray-100">
          <p className="text-sm text-gray-400">준비 중입니다.</p>
        </div>
      </div>
    </div>
  );
}
