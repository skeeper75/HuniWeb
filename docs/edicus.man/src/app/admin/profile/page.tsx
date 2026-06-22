import type { Metadata } from 'next';
import { User, Mail, Lock, Camera } from 'lucide-react';

export const metadata: Metadata = {
  title: '프로필',
};

export default function ProfilePage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">프로필</h1>
        <p className="mt-1 text-sm text-gray-500">계정 정보를 확인하고 수정합니다.</p>
      </div>

      <div className="max-w-2xl space-y-5">
        {/* 프로필 이미지 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-6">
          <div className="flex items-center gap-5">
            <div className="relative">
              <div className="flex h-20 w-20 items-center justify-center rounded-full bg-huni-primary-light-2">
                <User className="h-10 w-10 text-huni-primary" aria-hidden="true" />
              </div>
              <button
                className="absolute bottom-0 right-0 flex h-7 w-7 items-center justify-center rounded-full bg-white border border-gray-300 text-gray-500 hover:bg-gray-50 shadow-sm disabled:opacity-50 transition-colors"
                disabled
                aria-label="프로필 이미지 변경 (준비 중)"
              >
                <Camera className="h-3.5 w-3.5" aria-hidden="true" />
              </button>
            </div>
            <div>
              <p className="text-base font-semibold text-gray-900">관리자</p>
              <p className="text-sm text-gray-500">admin@example.com</p>
              <p className="mt-1 text-xs text-gray-400">이미지 변경 기능 준비 중</p>
            </div>
          </div>
        </div>

        {/* 기본 정보 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
          <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
            <User className="h-4 w-4 text-gray-400" aria-hidden="true" />
            <h2 className="text-sm font-semibold text-gray-900">기본 정보</h2>
          </div>
          <div className="p-5 space-y-4">
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">이름</label>
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  defaultValue="관리자"
                  disabled
                  className="flex-1 rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-sm text-gray-400 disabled:cursor-not-allowed"
                  aria-label="이름 (준비 중)"
                />
              </div>
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">
                <Mail className="inline h-3.5 w-3.5 mr-1 text-gray-400" aria-hidden="true" />
                이메일
              </label>
              <input
                type="email"
                defaultValue="admin@example.com"
                disabled
                className="w-full rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-sm text-gray-400 disabled:cursor-not-allowed"
                aria-label="이메일 (준비 중)"
              />
            </div>
          </div>
        </div>

        {/* 비밀번호 변경 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
          <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
            <Lock className="h-4 w-4 text-gray-400" aria-hidden="true" />
            <h2 className="text-sm font-semibold text-gray-900">비밀번호 변경</h2>
          </div>
          <div className="p-5 space-y-4">
            {['현재 비밀번호', '새 비밀번호', '새 비밀번호 확인'].map((label) => (
              <div key={label}>
                <label className="block text-xs font-medium text-gray-500 mb-1">{label}</label>
                <input
                  type="password"
                  disabled
                  placeholder="준비 중입니다"
                  className="w-full rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-sm text-gray-400 placeholder-gray-300 disabled:cursor-not-allowed"
                  aria-label={`${label} (준비 중)`}
                />
              </div>
            ))}
          </div>
          <div className="px-5 py-4 bg-gray-50 border-t border-gray-100">
            <button
              disabled
              className="rounded-lg bg-huni-primary px-4 py-2 text-sm font-semibold text-white opacity-50 cursor-not-allowed"
            >
              비밀번호 변경
            </button>
            <p className="mt-1 text-xs text-gray-400">준비 중입니다.</p>
          </div>
        </div>
      </div>
    </div>
  );
}
