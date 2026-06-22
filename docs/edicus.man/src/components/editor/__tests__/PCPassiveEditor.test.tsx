/**
 * PCPassiveEditor 컴포넌트 단위 테스트
 *
 * @MX:SPEC: SPEC-PCPASSIVE-001 Phase E-3
 */

import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { PCPassiveEditor } from '../PCPassiveEditor';

// useHuniEditor 훅 모킹
const mockUndo = vi.fn();
const mockRedo = vi.fn();
const mockSave = vi.fn();
const mockClose = vi.fn();

vi.mock('@/hooks/useHuniEditor', () => ({
  useHuniEditor: vi.fn(() => ({
    sdk: null,
    isReady: true,
    isLoading: false,
    error: null,
    undo: mockUndo,
    redo: mockRedo,
    save: mockSave,
    close: mockClose,
  })),
}));

describe('PCPassiveEditor', () => {
  const defaultProps = {
    templateId: 'test-template',
    psCode: 'test-ps-code',
    onClose: vi.fn(),
  };

  beforeEach(() => {
    vi.clearAllMocks();
    // window.confirm 모킹
    vi.spyOn(window, 'confirm').mockReturnValue(true);
  });

  describe('렌더링', () => {
    it('TC-PC-ED-1: 도구바와 편집기 컨테이너가 렌더링된다', () => {
      render(<PCPassiveEditor {...defaultProps} />);

      // 도구바 버튼들이 렌더링되는지 확인
      expect(screen.getByRole('button', { name: '편집기 닫기' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '실행 취소' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '편집 완료' })).toBeInTheDocument();

      // 편집기 컨테이너가 렌더링되는지 확인
      expect(document.getElementById('pc-passive-editor-container')).toBeInTheDocument();
    });

    it('TC-PC-ED-2: isLoading=true 시 로딩 오버레이가 표시된다', async () => {
      const { useHuniEditor } = await import('@/hooks/useHuniEditor');
      vi.mocked(useHuniEditor).mockReturnValueOnce({
        sdk: null,
        isReady: false,
        isLoading: true,
        error: null,
        undo: mockUndo,
        redo: mockRedo,
        save: mockSave,
        close: mockClose,
      });

      render(<PCPassiveEditor {...defaultProps} />);

      expect(screen.getByText('편집기를 불러오는 중...')).toBeInTheDocument();
    });

    it('TC-PC-ED-3: error 상태 시 오류 메시지와 닫기 버튼이 표시된다', async () => {
      const { useHuniEditor } = await import('@/hooks/useHuniEditor');
      vi.mocked(useHuniEditor).mockReturnValueOnce({
        sdk: null,
        isReady: false,
        isLoading: false,
        error: new Error('SDK 초기화 실패'),
        undo: mockUndo,
        redo: mockRedo,
        save: mockSave,
        close: mockClose,
      });

      render(<PCPassiveEditor {...defaultProps} />);

      expect(screen.getByText('편집기를 불러오는 중 오류가 발생했습니다.')).toBeInTheDocument();
      expect(screen.getByText('SDK 초기화 실패')).toBeInTheDocument();
      expect(screen.getByRole('button', { name: '닫기' })).toBeInTheDocument();
    });
  });

  describe('키보드 단축키', () => {
    it('TC-PC-ED-4: Ctrl+Z 단축키로 실행 취소가 호출된다', () => {
      render(<PCPassiveEditor {...defaultProps} />);

      fireEvent.keyDown(window, { key: 'z', ctrlKey: true, shiftKey: false });

      expect(mockUndo).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-ED-5: Ctrl+Y 단축키로 다시 실행이 호출된다', () => {
      render(<PCPassiveEditor {...defaultProps} />);

      fireEvent.keyDown(window, { key: 'y', ctrlKey: true });

      expect(mockRedo).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-ED-6: Ctrl+Shift+Z 단축키로 다시 실행이 호출된다', () => {
      render(<PCPassiveEditor {...defaultProps} />);

      fireEvent.keyDown(window, { key: 'z', ctrlKey: true, shiftKey: true });

      expect(mockRedo).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-ED-7: Ctrl+S 단축키로 저장이 호출된다', () => {
      render(<PCPassiveEditor {...defaultProps} />);

      fireEvent.keyDown(window, { key: 's', ctrlKey: true });

      expect(mockSave).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-ED-8: Escape 키로 닫기 확인 다이얼로그가 표시된다', () => {
      render(<PCPassiveEditor {...defaultProps} />);

      fireEvent.keyDown(window, { key: 'Escape' });

      expect(window.confirm).toHaveBeenCalled();
    });

    it('TC-PC-ED-9: Escape 후 confirm=true이면 onClose가 호출된다', () => {
      const onClose = vi.fn();
      vi.spyOn(window, 'confirm').mockReturnValue(true);
      render(<PCPassiveEditor {...defaultProps} onClose={onClose} />);

      fireEvent.keyDown(window, { key: 'Escape' });

      expect(onClose).toHaveBeenCalledTimes(1);
    });

    it('TC-PC-ED-10: Escape 후 confirm=false이면 onClose가 호출되지 않는다', () => {
      const onClose = vi.fn();
      vi.spyOn(window, 'confirm').mockReturnValue(false);
      render(<PCPassiveEditor {...defaultProps} onClose={onClose} />);

      fireEvent.keyDown(window, { key: 'Escape' });

      expect(onClose).not.toHaveBeenCalled();
    });
  });
});
