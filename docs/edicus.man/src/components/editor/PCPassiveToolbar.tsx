'use client';

/**
 * PCPassiveToolbar 컴포넌트
 *
 * PC passive 모드 편집기용 단일 수평 도구바입니다.
 * 모바일 PassiveToolbar와 달리 상단/하단으로 분리되지 않고 하나의 바로 구성됩니다.
 */

// @MX:NOTE: [AUTO] PC passive 모드 도구바 - 키보드 단축키 매핑은 PCPassiveEditor에서 처리
// @MX:SPEC: SPEC-PCPASSIVE-001 Phase D

import { X, Undo2, Redo2, Save } from 'lucide-react';
import { cn } from '@/lib/utils';

/**
 * PCPassiveToolbar 컴포넌트 Props
 */
interface PCPassiveToolbarProps {
  /** 편집기 닫기 콜백 (항상 활성) */
  onClose: () => void;
  /** 실행 취소 콜백 */
  onUndo: () => void;
  /** 다시 실행 콜백 */
  onRedo: () => void;
  /** 저장 콜백 */
  onSave: () => void;
  /** 완료 콜백 */
  onDone: () => void;
  /** 편집기 준비 상태 (false이면 Undo/Redo/Save 비활성화) */
  isReady: boolean;
  /** 추가 클래스명 */
  className?: string;
}

/**
 * PC passive 모드 편집기 도구바
 *
 * 레이아웃:
 * - 왼쪽: 닫기 버튼 (X)
 * - 중앙: Undo, Redo, Save 버튼 (isReady=false 시 비활성화)
 * - 오른쪽: 완료 버튼 (huni-primary 색상)
 */
export function PCPassiveToolbar({
  onClose,
  onUndo,
  onRedo,
  onSave,
  onDone,
  isReady,
  className,
}: PCPassiveToolbarProps): React.ReactElement {
  return (
    <div
      className={cn(
        'flex items-center justify-between bg-white border-b border-gray-200 px-4',
        className,
      )}
    >
      {/* 왼쪽: 닫기 버튼 */}
      <div className="flex items-center">
        <button
          onClick={onClose}
          className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 active:bg-gray-200 transition-colors"
          aria-label="편집기 닫기"
        >
          <X className="h-5 w-5" aria-hidden="true" />
        </button>
      </div>

      {/* 중앙: 편집 도구 그룹 */}
      <div className="flex items-center gap-1">
        <button
          onClick={onUndo}
          disabled={!isReady}
          className={cn(
            'min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg transition-colors',
            isReady
              ? 'text-gray-700 hover:bg-gray-100 active:bg-gray-200'
              : 'text-gray-300 cursor-not-allowed',
          )}
          aria-label="실행 취소"
        >
          <Undo2 className="h-5 w-5" aria-hidden="true" />
        </button>

        <button
          onClick={onRedo}
          disabled={!isReady}
          className={cn(
            'min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg transition-colors',
            isReady
              ? 'text-gray-700 hover:bg-gray-100 active:bg-gray-200'
              : 'text-gray-300 cursor-not-allowed',
          )}
          aria-label="다시 실행"
        >
          <Redo2 className="h-5 w-5" aria-hidden="true" />
        </button>

        <button
          onClick={onSave}
          disabled={!isReady}
          className={cn(
            'min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg transition-colors',
            isReady
              ? 'text-gray-700 hover:bg-gray-100 active:bg-gray-200'
              : 'text-gray-300 cursor-not-allowed',
          )}
          aria-label="저장"
        >
          <Save className="h-5 w-5" aria-hidden="true" />
        </button>
      </div>

      {/* 오른쪽: 완료 버튼 */}
      <div className="flex items-center">
        <button
          onClick={onDone}
          className="min-h-[44px] px-5 flex items-center justify-center rounded-lg bg-huni-primary text-white text-sm font-medium hover:bg-huni-primary-dark active:opacity-90 transition-colors"
          aria-label="편집 완료"
        >
          완료
        </button>
      </div>
    </div>
  );
}
