'use client';

// @MX:NOTE: [AUTO] passive 모드 외부 도구바 - postToEditor 명령 매핑
// @MX:SPEC: SPEC-PASSIVE-001 Phase D
// @MX:WARN: [AUTO] Undo/Redo 버튼 항상 활성 - SDK 상태 리포팅 미지원
// @MX:REASON: Edicus SDK가 undo/redo 가능 여부를 외부에 알리지 않음

import { cn } from '@/lib/utils';
import { X, Undo2, Redo2, Save } from 'lucide-react';

interface PassiveToolbarProps {
  onUndo: () => void;
  onRedo: () => void;
  onSave: () => void;
  onDone: () => void;
  onClose: () => void;
  title?: string;
  className?: string;
}

// 상단 바: 닫기 버튼 + 제목
export function PassiveToolbarTop({ onClose, title, className }: Pick<PassiveToolbarProps, 'onClose' | 'title' | 'className'>) {
  return (
    <div
      className={cn(
        'flex items-center bg-white border-b border-gray-200 px-2',
        className,
      )}
      style={{ paddingTop: 'env(safe-area-inset-top)' }}
    >
      {/* 닫기 버튼 */}
      <button
        onClick={onClose}
        className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-full text-gray-700 hover:bg-gray-100 active:bg-gray-200 transition-colors"
        aria-label="편집기 닫기"
      >
        <X className="h-5 w-5" aria-hidden="true" />
      </button>

      {/* 제목 (가운데 정렬) */}
      <div className="flex-1 text-center pr-[44px]">
        {title ? (
          <span className="text-sm font-medium text-gray-800 truncate">{title}</span>
        ) : (
          <span className="text-sm font-medium text-gray-500">편집 중</span>
        )}
      </div>
    </div>
  );
}

// 하단 바: Undo, Redo, Save, Done
export function PassiveToolbarBottom({ onUndo, onRedo, onSave, onDone, className }: Omit<PassiveToolbarProps, 'onClose' | 'title'>) {
  return (
    <div
      className={cn(
        'flex items-center justify-between bg-white border-t border-gray-200 px-4',
        className,
      )}
      style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}
    >
      {/* 편집 도구 그룹: Undo / Redo / Save */}
      <div className="flex items-center gap-1">
        <button
          onClick={onUndo}
          className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 active:bg-gray-200 transition-colors"
          aria-label="실행 취소"
        >
          <Undo2 className="h-5 w-5" aria-hidden="true" />
        </button>

        <button
          onClick={onRedo}
          className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 active:bg-gray-200 transition-colors"
          aria-label="다시 실행"
        >
          <Redo2 className="h-5 w-5" aria-hidden="true" />
        </button>

        <button
          onClick={onSave}
          className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg text-gray-700 hover:bg-gray-100 active:bg-gray-200 transition-colors"
          aria-label="저장"
        >
          <Save className="h-5 w-5" aria-hidden="true" />
        </button>
      </div>

      {/* 완료 버튼 */}
      <button
        onClick={onDone}
        className="min-h-[44px] px-5 flex items-center justify-center rounded-lg bg-huni-primary text-white text-sm font-medium hover:bg-huni-primary-dark active:opacity-90 transition-colors"
        aria-label="편집 완료"
      >
        완료
      </button>
    </div>
  );
}
