/**
 * PCPassiveToolbar 컴포넌트 단위 테스트
 *
 * @MX:SPEC: SPEC-PCPASSIVE-001 Phase E-2
 */

import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { PCPassiveToolbar } from '../PCPassiveToolbar';

// 기본 Props 헬퍼
const defaultProps = {
  onClose: vi.fn(),
  onUndo: vi.fn(),
  onRedo: vi.fn(),
  onSave: vi.fn(),
  onDone: vi.fn(),
  isReady: true,
};

describe('PCPassiveToolbar', () => {
  describe('렌더링', () => {
    it('TC-PC-TB-1: 5개 버튼(닫기, 실행취소, 다시실행, 저장, 완료)이 모두 렌더링된다', () => {
      render(<PCPassiveToolbar {...defaultProps} />);

      expect(screen.getByRole('button', { name: '편집기 닫기' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '실행 취소' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '다시 실행' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '저장' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '편집 완료' })).toBeInTheDocument();
    });
  });

  describe('클릭 핸들러', () => {
    it('TC-PC-TB-2: 닫기 버튼 클릭 시 onClose가 호출된다', () => {
      const onClose = vi.fn();
      render(<PCPassiveToolbar {...defaultProps} onClose={onClose} />);

      fireEvent.click(screen.getByRole('button', { name: '편집기 닫기' }));
      expect(onClose).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-TB-3: 실행 취소 버튼 클릭 시 onUndo가 호출된다', () => {
      const onUndo = vi.fn();
      render(<PCPassiveToolbar {...defaultProps} onUndo={onUndo} />);

      fireEvent.click(screen.getByRole('button', { name: '실행 취소' }));
      expect(onUndo).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-TB-4: 다시 실행 버튼 클릭 시 onRedo가 호출된다', () => {
      const onRedo = vi.fn();
      render(<PCPassiveToolbar {...defaultProps} onRedo={onRedo} />);

      fireEvent.click(screen.getByRole('button', { name: '다시 실행' }));
      expect(onRedo).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-TB-5: 저장 버튼 클릭 시 onSave가 호출된다', () => {
      const onSave = vi.fn();
      render(<PCPassiveToolbar {...defaultProps} onSave={onSave} />);

      fireEvent.click(screen.getByRole('button', { name: '저장' }));
      expect(onSave).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-TB-6: 완료 버튼 클릭 시 onDone이 호출된다', () => {
      const onDone = vi.fn();
      render(<PCPassiveToolbar {...defaultProps} onDone={onDone} />);

      fireEvent.click(screen.getByRole('button', { name: '편집 완료' }));
      expect(onDone).toHaveBeenCalledTimes(1);
    });
  });

  describe('isReady 상태', () => {
    it('TC-PC-TB-7: isReady=false 시 Undo/Redo/Save 버튼이 비활성화된다', () => {
      render(<PCPassiveToolbar {...defaultProps} isReady={false} />);

      expect(screen.getByRole('button', { name: '실행 취소' })).toBeDisabled();
      expect(screen.getByRole('button', { name: '다시 실행' })).toBeDisabled();
      expect(screen.getByRole('button', { name: '저장' })).toBeDisabled();
    });

    it('TC-PC-TB-8: isReady=false 시 닫기 버튼은 여전히 활성화된다', () => {
      render(<PCPassiveToolbar {...defaultProps} isReady={false} />);

      // 닫기 버튼은 disabled 속성이 없어야 함
      expect(screen.getByRole('button', { name: '편집기 닫기' })).not.toBeDisabled();
    });

    it('TC-PC-TB-9: isReady=false 시 완료 버튼은 여전히 활성화된다', () => {
      render(<PCPassiveToolbar {...defaultProps} isReady={false} />);

      // 완료 버튼은 disabled 속성이 없어야 함
      expect(screen.getByRole('button', { name: '편집 완료' })).not.toBeDisabled();
    });

    it('TC-PC-TB-10: isReady=true 시 모든 버튼이 활성화된다', () => {
      render(<PCPassiveToolbar {...defaultProps} isReady={true} />);

      expect(screen.getByRole('button', { name: '실행 취소' })).not.toBeDisabled();
      expect(screen.getByRole('button', { name: '다시 실행' })).not.toBeDisabled();
      expect(screen.getByRole('button', { name: '저장' })).not.toBeDisabled();
    });

    it('TC-PC-TB-11: isReady=false 시 비활성화된 버튼 클릭은 핸들러를 호출하지 않는다', () => {
      const onUndo = vi.fn();
      render(<PCPassiveToolbar {...defaultProps} onUndo={onUndo} isReady={false} />);

      fireEvent.click(screen.getByRole('button', { name: '실행 취소' }));
      // disabled 버튼이므로 핸들러가 호출되지 않아야 함
      expect(onUndo).not.toHaveBeenCalled();
    });
  });
});
