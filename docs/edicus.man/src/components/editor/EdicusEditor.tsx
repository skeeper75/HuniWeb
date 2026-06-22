'use client';

/**
 * EdicusEditor 컴포넌트
 *
 * Edicus SDK iframe 편집기를 렌더링합니다.
 * SDK 이벤트(request-user-token, close, goto-cart)를 처리합니다.
 */

import { useCallback, useEffect, useRef, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useEdicus } from '@/hooks/useEdicus';
import type { EdicusCallbackData } from '@/types/edicus';

interface EdicusEditorProps {
  /** 템플릿(상품) 코드 */
  templateId: string;
  /** 기존 프로젝트 ID (있으면 open, 없으면 create) */
  projectId?: string;
  /** 편집기 닫기 콜백 */
  onClose?: () => void;
  /** 장바구니 이동 콜백 */
  onGotoCart?: (data: EdicusCallbackData) => void;
  /** 모바일 모드 여부 (true이면 SDK에 mobile: true 전달) */
  mobile?: boolean;
  /** 커스텀 CSS (파트너 브랜딩용) */
  private_css?: string;
}

/**
 * 사용자 토큰을 가져오는 API 호출
 * /api/edicus/auth 엔드포인트에서 편집기용 토큰을 발급합니다.
 */
async function fetchUserToken(): Promise<string> {
  const response = await fetch('/api/edicus/auth', {
    method: 'POST',
  });

  if (!response.ok) {
    throw new Error('토큰 발급 실패');
  }

  const data = (await response.json()) as { token: string };
  return data.token;
}

/**
 * Edicus 편집기 전체화면 컴포넌트
 *
 * SDK를 초기화하고 iframe 편집기를 렌더링합니다.
 * - request-user-token 이벤트: 토큰 갱신 후 send-user-token 전송
 * - close 이벤트: 이전 페이지로 이동
 * - goto-cart 이벤트: 장바구니 페이지로 이동
 *
 * @MX:WARN: iframe postMessage 통신 및 이벤트 핸들링 복잡성
 * @MX:REASON: SDK 이벤트(request-user-token, close, goto-cart) 처리 시 예외처리 필요
 *
 * @example
 * ```tsx
 * <EdicusEditor templateId="PROD001" />
 * <EdicusEditor templateId="PROD001" projectId="proj_123" />
 * ```
 */
export function EdicusEditor({ templateId, projectId, onClose, onGotoCart, mobile, private_css }: EdicusEditorProps) {
  const router = useRouter();
  const containerRef = useRef<HTMLDivElement>(null);
  const [initToken, setInitToken] = useState<string | null>(null);
  const [tokenError, setTokenError] = useState<string | null>(null);
  const [isEditorStarted, setIsEditorStarted] = useState(false);

  // 초기 토큰 발급
  useEffect(() => {
    fetchUserToken()
      .then(setInitToken)
      .catch((err: unknown) => {
        const message = err instanceof Error ? err.message : '토큰 발급 중 오류가 발생했습니다.';
        setTokenError(message);
      });
  }, []);

  // @MX:NOTE: SDK 이벤트 핸들러 - request-user-token, close, goto-cart를 처리합니다
  const handleSdkEvent = useCallback(
    (err: null, data: EdicusCallbackData) => {
      if (err) {
        console.error('SDK 이벤트 오류:', err);
        return;
      }

      const action = data.action ?? data.type;

      if (action === 'request-user-token') {
        // 토큰 갱신 요청 처리
        fetchUserToken()
          .then((token) => {
            postToEditor('send-user-token', { token });
          })
          .catch(console.error);
        return;
      }

      if (action === 'close') {
        onClose?.();
        router.back();
        return;
      }

      if (action === 'goto-cart') {
        onGotoCart?.(data);
        router.push('/orders');
        return;
      }
    },
    [router, onClose, onGotoCart],
  );

  const { isReady, error, postToEditor, createProject, openProject } = useEdicus(
    containerRef as React.RefObject<HTMLElement | null>,
    {
      baseUrl: process.env.NEXT_PUBLIC_EDICUS_BASE_URL ?? 'https://edicusbase.firebaseapp.com',
      partner: process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip',
    },
    handleSdkEvent,
  );

  // SDK 준비 및 토큰 확보 시 편집기 시작
  useEffect(() => {
    if (!isReady || !initToken || isEditorStarted) return;

    setIsEditorStarted(true);

    // 모바일/커스텀CSS 옵션을 extraParams로 전달
    const extraParams: Record<string, unknown> = {};
    if (mobile) extraParams.mobile = true;
    if (private_css) extraParams.private_css = private_css;

    if (projectId) {
      openProject(initToken, projectId, Object.keys(extraParams).length > 0 ? extraParams : undefined);
    } else {
      createProject(initToken, templateId, `${templateId} 프로젝트`, Object.keys(extraParams).length > 0 ? extraParams : undefined);
    }
  }, [isReady, initToken, isEditorStarted, projectId, templateId, createProject, openProject]);

  // 오류 상태 표시
  const displayError = tokenError ?? (error?.message ?? null);

  if (displayError) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="rounded-xl bg-white p-8 shadow-sm text-center max-w-md">
          <svg className="mx-auto mb-4 h-12 w-12 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <h2 className="text-lg font-semibold text-gray-900">편집기를 불러올 수 없습니다</h2>
          <p className="mt-2 text-sm text-gray-500">{displayError}</p>
          <button
            onClick={() => router.back()}
            className="mt-6 rounded-lg bg-huni-primary px-6 py-2 text-sm font-semibold text-white hover:bg-huni-primary-dark"
          >
            돌아가기
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="relative flex h-screen w-full flex-col bg-gray-900">
      {/* 로딩 오버레이 */}
      {(!isReady || !isEditorStarted) && (
        <div className="absolute inset-0 z-10 flex items-center justify-center bg-gray-900">
          <div className="text-center text-white">
            <svg className="mx-auto h-10 w-10 animate-spin" fill="none" viewBox="0 0 24 24" aria-hidden="true">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
            </svg>
            <p className="mt-3 text-sm">편집기 로딩 중...</p>
          </div>
        </div>
      )}

      {/* SDK iframe 마운트 컨테이너 */}
      <div
        ref={containerRef}
        className="h-full w-full"
        id="edicus-editor-container"
        aria-label="Edicus 편집기"
      />
    </div>
  );
}
