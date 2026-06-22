'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

// @MX:NOTE: 로그인 폼 컴포넌트, useAuth 훅에서 login 함수를 주입받아 사용
// useAuth 훅은 firebase auth를 래핑하며, 별도 에이전트가 생성 예정

interface LoginFormProps {
  onLogin?: (email: string, password: string) => Promise<void>;
}

export default function LoginForm({ onLogin }: LoginFormProps) {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      if (onLogin) {
        await onLogin(email, password);
      } else {
        // onLogin prop이 제공되지 않은 경우 경고만 출력
        // useAuth 훅은 페이지 컴포넌트에서 props로 주입해야 합니다
        console.warn('onLogin prop이 제공되지 않았습니다.');
      }
      // 로그인 성공 시 세션 쿠키 설정 및 리다이렉트
      document.cookie = '__session=true; path=/; SameSite=Lax';
      router.push('/admin');
    } catch (err) {
      setError(err instanceof Error ? err.message : '로그인에 실패했습니다. 다시 시도해주세요.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4" noValidate>
      {/* 오류 메시지 */}
      {error && (
        <div
          role="alert"
          className="rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700"
        >
          {error}
        </div>
      )}

      {/* 이메일 입력 */}
      <div>
        <label
          htmlFor="email"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          이메일
        </label>
        <input
          id="email"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          autoComplete="email"
          disabled={loading}
          placeholder="admin@example.com"
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-900 placeholder-gray-400 focus:border-huni-primary focus:outline-none focus:ring-1 focus:ring-huni-primary disabled:bg-gray-50 disabled:cursor-not-allowed"
        />
      </div>

      {/* 비밀번호 입력 */}
      <div>
        <label
          htmlFor="password"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          비밀번호
        </label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          autoComplete="current-password"
          disabled={loading}
          placeholder="••••••••"
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-900 placeholder-gray-400 focus:border-huni-primary focus:outline-none focus:ring-1 focus:ring-huni-primary disabled:bg-gray-50 disabled:cursor-not-allowed"
        />
      </div>

      {/* 제출 버튼 */}
      <button
        type="submit"
        disabled={loading || !email || !password}
        className="w-full rounded-lg bg-huni-primary px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-huni-primary-dark focus:outline-none focus:ring-2 focus:ring-huni-primary focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 transition-colors"
      >
        {loading ? (
          <span className="flex items-center justify-center gap-2">
            <svg
              className="h-4 w-4 animate-spin"
              fill="none"
              viewBox="0 0 24 24"
              aria-hidden="true"
            >
              <circle
                className="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                strokeWidth="4"
              />
              <path
                className="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
              />
            </svg>
            로그인 중...
          </span>
        ) : (
          '로그인'
        )}
      </button>

      {/* 회원가입 링크 */}
      <p className="text-center text-sm text-gray-500">
        계정이 없으신가요?{' '}
        <Link
          href="/register"
          className="font-medium text-huni-primary hover:text-huni-primary-dark hover:underline"
        >
          회원가입
        </Link>
      </p>
    </form>
  );
}
