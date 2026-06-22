import type { Metadata } from 'next';
import LoginForm from '@/components/auth/LoginForm';

export const metadata: Metadata = {
  title: '로그인 | Edicus Manager',
  description: 'Edicus Manager 관리자 로그인',
};

export default function LoginPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50 px-4 py-12">
      <div className="w-full max-w-md">
        {/* 헤더 */}
        <div className="text-center mb-8">
          <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-xl bg-huni-primary">
            <svg
              className="h-7 w-7 text-white"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
              />
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-gray-900">Edicus Manager</h1>
          <p className="mt-2 text-sm text-gray-500">관리자 계정으로 로그인하세요</p>
        </div>

        {/* 로그인 카드 */}
        <div className="rounded-2xl bg-white px-8 py-8 shadow-sm border border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">로그인</h2>
          <LoginForm />
        </div>
      </div>
    </div>
  );
}
