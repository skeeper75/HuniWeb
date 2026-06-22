'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

interface ErrorProps {
  error: Error & { digest?: string };
  reset: () => void;
}

/**
 * 내 프로젝트 페이지 오류 UI
 */
export default function ProjectsError({ error, reset }: ErrorProps) {
  const router = useRouter();

  useEffect(() => {
    console.error('프로젝트 페이지 오류:', error);
  }, [error]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50">
      <div className="rounded-xl bg-white p-8 shadow-sm text-center max-w-md">
        <svg className="mx-auto mb-4 h-12 w-12 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        <h2 className="text-lg font-semibold text-gray-900">프로젝트 목록 오류</h2>
        <p className="mt-2 text-sm text-gray-500">{error.message}</p>
        <div className="mt-6 flex gap-3 justify-center">
          <button onClick={reset} className="rounded-lg bg-huni-primary px-5 py-2 text-sm font-semibold text-white hover:bg-huni-primary-dark">
            다시 시도
          </button>
          <button onClick={() => router.push('/')} className="rounded-lg border border-gray-300 px-5 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50">
            홈으로
          </button>
        </div>
      </div>
    </div>
  );
}
