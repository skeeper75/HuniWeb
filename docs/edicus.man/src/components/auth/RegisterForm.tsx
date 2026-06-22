'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

// @MX:NOTE: 회원가입 폼 컴포넌트, onRegister prop을 통해 register 함수를 주입받아 사용

interface RegisterFormProps {
  onRegister?: (email: string, password: string) => Promise<void>;
}

export default function RegisterForm({ onRegister }: RegisterFormProps) {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError(null);

    if (password !== confirmPassword) {
      setError('비밀번호가 일치하지 않습니다.');
      return;
    }

    if (password.length < 8) {
      setError('비밀번호는 최소 8자 이상이어야 합니다.');
      return;
    }

    setLoading(true);

    try {
      if (onRegister) {
        await onRegister(email, password);
      } else {
        console.warn('onRegister prop이 제공되지 않았습니다.');
      }
      // 회원가입 성공 후 관리자 페이지로 이동
      router.push('/admin');
    } catch (err) {
      setError(err instanceof Error ? err.message : '회원가입에 실패했습니다. 다시 시도해주세요.');
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
          htmlFor="register-email"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          이메일
        </label>
        <input
          id="register-email"
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
          htmlFor="register-password"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          비밀번호
        </label>
        <input
          id="register-password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          autoComplete="new-password"
          disabled={loading}
          placeholder="최소 8자 이상"
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-900 placeholder-gray-400 focus:border-huni-primary focus:outline-none focus:ring-1 focus:ring-huni-primary disabled:bg-gray-50 disabled:cursor-not-allowed"
        />
      </div>

      {/* 비밀번호 확인 */}
      <div>
        <label
          htmlFor="confirm-password"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          비밀번호 확인
        </label>
        <input
          id="confirm-password"
          type="password"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          required
          autoComplete="new-password"
          disabled={loading}
          placeholder="비밀번호를 다시 입력하세요"
          className={`w-full rounded-lg border px-3 py-2 text-sm text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-1 disabled:bg-gray-50 disabled:cursor-not-allowed ${
            confirmPassword && confirmPassword !== password
              ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
              : 'border-gray-300 focus:border-huni-primary focus:ring-huni-primary'
          }`}
        />
        {confirmPassword && confirmPassword !== password && (
          <p className="mt-1 text-xs text-red-600">비밀번호가 일치하지 않습니다.</p>
        )}
      </div>

      {/* 제출 버튼 */}
      <button
        type="submit"
        disabled={loading || !email || !password || !confirmPassword}
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
            가입 중...
          </span>
        ) : (
          '회원가입'
        )}
      </button>

      {/* 로그인 링크 */}
      <p className="text-center text-sm text-gray-500">
        이미 계정이 있으신가요?{' '}
        <Link
          href="/login"
          className="font-medium text-huni-primary hover:text-huni-primary-dark hover:underline"
        >
          로그인
        </Link>
      </p>
    </form>
  );
}
