'use client';

/**
 * 모바일 전체화면 편집기 컴포넌트
 *
 * SDK를 모바일 모드로 초기화하고 전체화면 iframe 편집기를 렌더링합니다.
 *
 * @MX:WARN: 전체화면 오버레이 + 스크롤 잠금 처리
 * @MX:REASON: body scroll lock은 마운트/언마운트 시 반드시 복구해야 합니다.
 *             미복구 시 편집기 닫힌 후 페이지 스크롤이 불가능해집니다.
 */

import { useCallback, useEffect, useRef, useState } from 'react';
import { useEdicus } from '@/hooks/useEdicus';
import { getMobileConfig } from '@/lib/edicus/mobile-config';
import type { EdicusCallbackData } from '@/types/edicus';
import { PassiveToolbarTop, PassiveToolbarBottom } from './PassiveToolbar';

interface MobileEditorProps {
  templateId: string;
  psCode?: string;
  templateUri?: string;
  /** passive mode 활성화: 에디터 내부 툴바 숨김, 호스트가 postToEditor로 제어 */
  passiveMode?: boolean;
  onClose: () => void;
  onGotoCart?: (data: unknown) => void;
  /** passive mode 전용: 문서 변경 이벤트 (페이지 수, VDP 카탈로그 등) */
  onDocChanged?: (data: EdicusCallbackData) => void;
  /** passive mode 전용: 에디터 준비 완료 이벤트 */
  onReadyToListen?: () => void;
}

// 편집기 토큰 발급
async function fetchEditorToken(): Promise<string> {
  const response = await fetch('/api/edicus/auth', { method: 'POST' });
  if (!response.ok) throw new Error('토큰 발급 실패');
  const data = (await response.json()) as { token: string };
  return data.token;
}

/**
 * 모바일 전체화면 편집기
 *
 * - body 스크롤 잠금 (마운트 시 잠금, 언마운트 시 해제)
 * - 모바일 SDK 설정 (mobile: true)
 * - 이벤트: close → onClose, goto-cart → onGotoCart
 */
export function MobileEditor({
  templateId,
  psCode,
  templateUri,
  passiveMode = false,
  onClose,
  onGotoCart,
  onDocChanged,
  onReadyToListen,
}: MobileEditorProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [initToken, setInitToken] = useState<string | null>(null);
  const [tokenError, setTokenError] = useState<string | null>(null);
  const [isEditorStarted, setIsEditorStarted] = useState(false);

  const partner = process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip';
  const mobileConfig = getMobileConfig(partner);

  // @MX:WARN: body 스크롤 잠금 - 언마운트 시 반드시 해제 필요
  // @MX:REASON: overflow:hidden 미해제 시 편집기 종료 후 페이지 전체가 스크롤 불가
  useEffect(() => {
    const originalOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';

    return () => {
      document.body.style.overflow = originalOverflow;
    };
  }, []);

  // 초기 토큰 발급
  useEffect(() => {
    fetchEditorToken()
      .then(setInitToken)
      .catch((err: unknown) => {
        const message = err instanceof Error ? err.message : '토큰 발급 중 오류가 발생했습니다.';
        setTokenError(message);
      });
  }, []);

  // SDK 이벤트 핸들러
  const handleSdkEvent = useCallback(
    (_err: null, data: EdicusCallbackData) => {
      const action = data.action ?? data.type;

      if (action === 'request-user-token') {
        fetchEditorToken()
          .then((token) => {
            postToEditor('send-user-token', { token });
          })
          .catch(console.error);
        return;
      }

      if (action === 'close') {
        onClose();
        return;
      }

      if (action === 'goto-cart') {
        onGotoCart?.(data);
        return;
      }

      // passive mode 이벤트
      if (action === 'ready-to-listen') {
        onReadyToListen?.();
        return;
      }

      if (action === 'doc-changed') {
        onDocChanged?.(data);
        return;
      }
    },
    [onClose, onGotoCart, onDocChanged, onReadyToListen],
  );

  const { isReady, error, postToEditor, createProject } = useEdicus(
    containerRef as React.RefObject<HTMLElement | null>,
    {
      baseUrl: process.env.NEXT_PUBLIC_EDICUS_BASE_URL ?? 'https://edicusbase.firebaseapp.com',
      partner,
    },
    handleSdkEvent,
  );

  // SDK 준비 + 토큰 확보 시 편집기 시작
  useEffect(() => {
    if (!isReady || !initToken || isEditorStarted) return;

    setIsEditorStarted(true);

    const effectivePsCode = psCode ?? templateId;

    // 모바일 설정을 extraParams로 전달
    const extraParams: Record<string, unknown> = {
      mobile: mobileConfig.mobile,
      lang: mobileConfig.lang,
      ui_locale: mobileConfig.ui_locale,
    };

    if (mobileConfig.private_css) {
      extraParams.private_css = mobileConfig.private_css;
    }

    if (templateUri) {
      extraParams.template_uri = templateUri;
    }

    // passive mode: 에디터 내부 툴바 숨김 → 호스트가 postToEditor로 직접 제어
    // @MX:NOTE: run_mode=passive → Edicus iframe URL 파라미터로 전달됨
    // @MX:SPEC: SPEC-PASSIVE-001 Phase A 발견 (phase-a-findings.md)
    if (passiveMode) {
      extraParams.run_mode = 'passive';
    }

    createProject(initToken, effectivePsCode, `${effectivePsCode} 프로젝트`, extraParams);
  }, [isReady, initToken, isEditorStarted, templateId, psCode, templateUri, passiveMode, mobileConfig, createProject]);

  const displayError = tokenError ?? (error?.message ?? null);

  if (displayError) {
    return (
      <div className="fixed inset-0 z-[9999] bg-white flex items-center justify-center p-6">
        <div className="text-center">
          <p className="text-sm text-red-500 mb-4">{displayError}</p>
          <button
            onClick={onClose}
            className="px-4 py-2 text-sm font-medium text-huni-primary border border-huni-primary rounded-lg"
          >
            닫기
          </button>
        </div>
      </div>
    );
  }

  // @MX:NOTE: [AUTO] passiveMode 조건부 렌더링 - PassiveToolbar 통합
  // @MX:SPEC: SPEC-PASSIVE-001 Phase D

  if (passiveMode) {
    return (
      // passiveMode: 상단바 + iframe + 하단바 flex 레이아웃
      <div className="fixed inset-0 z-[9999] bg-white flex flex-col" role="dialog" aria-modal="true" aria-label="편집기">
        {/* 로딩 오버레이 */}
        {(!isReady || !isEditorStarted) && (
          <div className="absolute inset-0 z-10 flex items-center justify-center bg-gray-900">
            <div className="text-center text-white">
              <div className="mx-auto h-10 w-10 animate-spin rounded-full border-4 border-white border-t-transparent" />
              <p className="mt-3 text-sm">편집기 로딩 중...</p>
            </div>
          </div>
        )}

        {/* 상단 도구바 */}
        <PassiveToolbarTop
          onClose={onClose}
          className="flex-shrink-0"
        />

        {/* SDK iframe 마운트 컨테이너 (flex-1로 남은 공간 채움) */}
        <div
          ref={containerRef}
          className="flex-1 min-h-0 w-full"
          id="mobile-editor-container"
          aria-label="모바일 Edicus 편집기"
        />

        {/* 하단 도구바 */}
        <PassiveToolbarBottom
          onUndo={() => postToEditor('undo', {})}
          onRedo={() => postToEditor('redo', {})}
          onSave={() => postToEditor('save-doc', {})}
          onDone={onClose}
          className="flex-shrink-0"
        />
      </div>
    );
  }

  return (
    // 표준 모드: 전체화면 오버레이
    <div className="fixed inset-0 z-[9999] bg-white" role="dialog" aria-modal="true" aria-label="편집기">
      {/* 로딩 오버레이 */}
      {(!isReady || !isEditorStarted) && (
        <div className="absolute inset-0 z-10 flex items-center justify-center bg-gray-900">
          <div className="text-center text-white">
            <div className="mx-auto h-10 w-10 animate-spin rounded-full border-4 border-white border-t-transparent" />
            <p className="mt-3 text-sm">편집기 로딩 중...</p>
          </div>
        </div>
      )}

      {/* 닫기 버튼 */}
      <button
        onClick={onClose}
        className="absolute top-4 right-4 z-20 min-w-[44px] min-h-[44px] flex items-center justify-center rounded-full bg-black/50 text-white active:bg-black/70 transition-colors"
        aria-label="편집기 닫기"
        style={{ paddingTop: 'env(safe-area-inset-top)' }}
      >
        <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>

      {/* SDK iframe 마운트 컨테이너 */}
      <div
        ref={containerRef}
        className="h-full w-full"
        id="mobile-editor-container"
        aria-label="모바일 Edicus 편집기"
      />
    </div>
  );
}
