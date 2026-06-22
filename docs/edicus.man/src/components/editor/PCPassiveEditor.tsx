'use client';

/**
 * PCPassiveEditor 컴포넌트
 *
 * PC 환경에서 전체화면 passive 모드 편집기를 렌더링합니다.
 * 키보드 단축키(Undo/Redo/Save/Escape)를 지원합니다.
 */

import { useEffect } from 'react';
import { useHuniEditor } from '@/hooks/useHuniEditor';
import { PCPassiveToolbar } from './PCPassiveToolbar';

/**
 * PCPassiveEditor 컴포넌트 Props
 */
interface PCPassiveEditorProps {
  /** 템플릿 ID */
  templateId: string;
  /** 상품 코드 (ps_code) */
  psCode?: string;
  /** 편집기 닫기 콜백 */
  onClose: () => void;
  /** 장바구니 이동 콜백 */
  onGotoCart?: (data: unknown) => void;
}

/** 편집기 컨테이너 고유 ID */
const CONTAINER_ID = 'pc-passive-editor-container';

/**
 * PC 전체화면 passive 모드 편집기
 *
 * - 키보드 단축키 지원 (Mac/Windows 호환)
 *   - Ctrl+Z / Cmd+Z: 실행 취소
 *   - Ctrl+Y / Cmd+Y / Ctrl+Shift+Z / Cmd+Shift+Z: 다시 실행
 *   - Ctrl+S / Cmd+S: 저장
 *   - Escape: 닫기 확인 다이얼로그
 * - 로딩 상태 오버레이
 * - 오류 표시
 */
export function PCPassiveEditor({
  templateId: _templateId,
  psCode,
  onClose,
  onGotoCart: _onGotoCart,
}: PCPassiveEditorProps): React.ReactElement {
  const partner = process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip';

  const { isReady, isLoading, error, undo, redo, save, close } = useHuniEditor({
    containerId: CONTAINER_ID,
    productId: psCode ?? '',
    partnerId: partner,
    passiveMode: true,
  });

  // @MX:NOTE: [AUTO] PC 키보드 단축키 핸들링 - Mac/Windows 호환
  // @MX:SPEC: SPEC-PCPASSIVE-001 Phase D
  useEffect(() => {
    // Mac 환경 감지
    const isMac =
      typeof navigator !== 'undefined' && /Mac|iPhone|iPad/.test(navigator.userAgent);

    const handleKeyDown = (event: KeyboardEvent) => {
      // 수식키: Mac은 metaKey, Windows/Linux는 ctrlKey
      const modifier = isMac ? event.metaKey : event.ctrlKey;

      if (!modifier) return;

      if (event.key === 'z' && !event.shiftKey) {
        // Ctrl+Z / Cmd+Z: 실행 취소
        event.preventDefault();
        undo();
      } else if (
        event.key === 'y' ||
        (event.key === 'z' && event.shiftKey)
      ) {
        // Ctrl+Y / Cmd+Y / Ctrl+Shift+Z / Cmd+Shift+Z: 다시 실행
        event.preventDefault();
        redo();
      } else if (event.key === 's') {
        // Ctrl+S / Cmd+S: 저장
        event.preventDefault();
        save();
      }
    };

    const handleKeyDownWithEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        // Escape: 닫기 확인 다이얼로그
        const confirmed = window.confirm('편집 내용이 저장되지 않을 수 있습니다. 닫으시겠습니까?');
        if (confirmed) {
          close();
          onClose();
        }
        return;
      }
      handleKeyDown(event);
    };

    window.addEventListener('keydown', handleKeyDownWithEscape);

    return () => {
      window.removeEventListener('keydown', handleKeyDownWithEscape);
    };
  }, [undo, redo, save, close, onClose]);

  // 오류 상태
  if (error) {
    return (
      <div className="fixed inset-0 z-50 flex flex-col items-center justify-center bg-white">
        <p className="text-red-600 mb-4">편집기를 불러오는 중 오류가 발생했습니다.</p>
        <p className="text-sm text-gray-500 mb-6">{error.message}</p>
        <button
          onClick={onClose}
          className="px-4 py-2 bg-gray-800 text-white rounded-lg hover:bg-gray-700 transition-colors"
        >
          닫기
        </button>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 z-50 flex flex-col bg-white">
      {/* 도구바 (flex-shrink-0으로 높이 고정) */}
      <div className="flex-shrink-0">
        <PCPassiveToolbar
          onClose={() => {
            const confirmed = window.confirm(
              '편집 내용이 저장되지 않을 수 있습니다. 닫으시겠습니까?',
            );
            if (confirmed) {
              close();
              onClose();
            }
          }}
          onUndo={undo}
          onRedo={redo}
          onSave={save}
          onDone={() => {
            save();
            close();
            onClose();
          }}
          isReady={isReady}
        />
      </div>

      {/* 편집기 컨테이너 (flex-1로 나머지 공간 차지) */}
      <div className="flex-1 relative">
        {/* 로딩 오버레이 */}
        {isLoading && (
          <div className="absolute inset-0 flex items-center justify-center bg-white z-10">
            <div className="flex flex-col items-center gap-3">
              <div className="w-8 h-8 border-2 border-gray-300 border-t-gray-700 rounded-full animate-spin" />
              <p className="text-sm text-gray-500">편집기를 불러오는 중...</p>
            </div>
          </div>
        )}

        {/* Edicus 편집기가 마운트될 컨테이너 */}
        <div id={CONTAINER_ID} className="w-full h-full" />
      </div>
    </div>
  );
}
