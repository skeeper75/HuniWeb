import type { Metadata } from 'next';
import Link from 'next/link';
import RegisterForm from '@/components/auth/RegisterForm';

export const metadata: Metadata = {
  title: '회원가입 | Edicus Manager',
  description: 'Edicus Manager 관리자 계정 생성',
};

export default function RegisterPage() {
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
                d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"
              />
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-gray-900">Edicus Manager</h1>
          <p className="mt-2 text-sm text-gray-500">새 관리자 계정을 만드세요</p>
        </div>

        {/* 회원가입 카드 */}
        <div className="rounded-2xl bg-white px-8 py-8 shadow-sm border border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900 mb-6">회원가입</h2>
          <RegisterForm />
        </div>

        {/* 로그인으로 돌아가기 */}
        <p className="mt-6 text-center text-sm text-gray-500">
          <Link
            href="/login"
            className="font-medium text-huni-primary hover:text-huni-primary-dark hover:underline"
          >
            ← 로그인으로 돌아가기
          </Link>
        </p>
      </div>
    </div>
  );
}
