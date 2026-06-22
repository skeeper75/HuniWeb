import type { Metadata } from 'next';
import { ImageIcon } from 'lucide-react';

export const metadata: Metadata = {
  title: '디자인 에셋',
};

export default function AssetsPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">디자인 에셋</h1>
          <p className="mt-1 text-sm text-gray-500">로고, 이미지 등 디자인 에셋을 관리합니다.</p>
        </div>
        <button
          className="rounded-lg bg-huni-primary px-4 py-2 text-sm font-semibold text-white hover:bg-huni-primary-dark transition-colors disabled:opacity-50"
          disabled
          aria-label="에셋 업로드 (준비 중)"
        >
          에셋 업로드
        </button>
      </div>

      {/* 준비 중 안내 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-12 text-center mb-5">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-violet-50">
          <ImageIcon className="h-7 w-7 text-violet-600" aria-hidden="true" />
        </div>
        <h2 className="text-lg font-semibold text-gray-900 mb-2">에셋 라이브러리</h2>
        <p className="text-sm text-gray-500 mb-1">준비 중입니다.</p>
        <p className="text-xs text-gray-400">이미지, 로고, 폰트 등 디자인 에셋을 업로드하고 관리할 수 있습니다.</p>
      </div>

      {/* 그리드 스켈레톤 */}
      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
        {[...Array(10)].map((_, i) => (
          <div
            key={i}
            className="aspect-square rounded-lg bg-gray-100 border border-gray-200 flex items-center justify-center"
          >
            <ImageIcon className="h-8 w-8 text-gray-300" aria-hidden="true" />
          </div>
        ))}
      </div>
    </div>
  );
}
