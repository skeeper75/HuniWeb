import type { Metadata } from 'next';
import { Store, Settings2 } from 'lucide-react';

export const metadata: Metadata = {
  title: '상점 관리',
};

export default function ShopPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">상점 관리</h1>
        <p className="mt-1 text-sm text-gray-500">상점 기본 설정을 관리합니다.</p>
      </div>

      {/* 준비 중 안내 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-12 text-center">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-huni-primary-light-3">
          <Store className="h-7 w-7 text-huni-primary" aria-hidden="true" />
        </div>
        <h2 className="text-lg font-semibold text-gray-900 mb-2">상점 설정</h2>
        <p className="text-sm text-gray-500 mb-1">준비 중입니다.</p>
        <p className="text-xs text-gray-400">상점 이름, 연락처, 운영 시간 등을 설정할 수 있습니다.</p>
      </div>

      {/* 설정 섹션 스켈레톤 */}
      <div className="mt-5 rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
          <Settings2 className="h-4 w-4 text-gray-400" aria-hidden="true" />
          <h2 className="text-sm font-semibold text-gray-900">기본 설정</h2>
        </div>
        <div className="p-5 space-y-4">
          {['상점 이름', '대표 연락처', '운영 시간', '배송 안내'].map((label) => (
            <div key={label} className="space-y-1">
              <label className="block text-xs font-medium text-gray-400">{label}</label>
              <div className="h-9 rounded-lg bg-gray-100 border border-gray-200" />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
