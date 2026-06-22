// PassiveToolbar 컴포넌트 단위 테스트
// @MX:SPEC: SPEC-PASSIVE-001 Phase E

import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { PassiveToolbarTop, PassiveToolbarBottom } from '../PassiveToolbar';

// PassiveToolbar는 Top/Bottom 두 컴포넌트로 분리되어 있음
// 이 테스트는 두 컴포넌트를 함께 렌더링하여 전체 PassiveToolbar 동작을 검증

// 헬퍼: 두 컴포넌트를 하나로 묶어 렌더링
function renderPassiveToolbar(props: {
  onUndo: () => void;
  onRedo: () => void;
  onSave: () => void;
  onDone: () => void;
  onClose: () => void;
  title?: string;
  className?: string;
}) {
  return render(
    <>
      <PassiveToolbarTop
        onClose={props.onClose}
        title={props.title}
        className={props.className}
      />
      <PassiveToolbarBottom
        onUndo={props.onUndo}
        onRedo={props.onRedo}
        onSave={props.onSave}
        onDone={props.onDone}
        className={props.className}
      />
    </>,
  );
}

describe('PassiveToolbar', () => {
  // TC-E1-1: 상단 바와 하단 바가 모두 렌더링되는지 확인
  it('TC-E1-1: Top bar와 Bottom bar가 모두 렌더링된다', () => {
    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo: vi.fn(),
      onSave: vi.fn(),
      onDone: vi.fn(),
      onClose: vi.fn(),
    });

    // 상단 바: 닫기 버튼 존재 확인
    expect(screen.getByRole('button', { name: '편집기 닫기' })).toBeInTheDocument();

    // 하단 바: 도구 버튼들 존재 확인
    expect(screen.getByRole('button', { name: '실행 취소' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: '다시 실행' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: '저장' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: '편집 완료' })).toBeInTheDocument();
  });

  // TC-E1-2: Undo 버튼 클릭 시 onUndo 콜백 호출
  it('TC-E1-2: Undo 버튼 클릭 시 onUndo 콜백이 호출된다', () => {
    const onUndo = vi.fn();

    renderPassiveToolbar({
      onUndo,
      onRedo: vi.fn(),
      onSave: vi.fn(),
      onDone: vi.fn(),
      onClose: vi.fn(),
    });

    fireEvent.click(screen.getByRole('button', { name: '실행 취소' }));

    expect(onUndo).toHaveBeenCalledTimes(1);
  });

  // TC-E1-3: Redo 버튼 클릭 시 onRedo 콜백 호출
  it('TC-E1-3: Redo 버튼 클릭 시 onRedo 콜백이 호출된다', () => {
    const onRedo = vi.fn();

    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo,
      onSave: vi.fn(),
      onDone: vi.fn(),
      onClose: vi.fn(),
    });

    fireEvent.click(screen.getByRole('button', { name: '다시 실행' }));

    expect(onRedo).toHaveBeenCalledTimes(1);
  });

  // TC-E1-4: Save 버튼 클릭 시 onSave 콜백 호출
  it('TC-E1-4: Save 버튼 클릭 시 onSave 콜백이 호출된다', () => {
    const onSave = vi.fn();

    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo: vi.fn(),
      onSave,
      onDone: vi.fn(),
      onClose: vi.fn(),
    });

    fireEvent.click(screen.getByRole('button', { name: '저장' }));

    expect(onSave).toHaveBeenCalledTimes(1);
  });

  // TC-E1-5: Done 버튼 클릭 시 onDone 콜백 호출
  it('TC-E1-5: Done 버튼 클릭 시 onDone 콜백이 호출된다', () => {
    const onDone = vi.fn();

    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo: vi.fn(),
      onSave: vi.fn(),
      onDone,
      onClose: vi.fn(),
    });

    // "편집 완료" aria-label로 버튼 탐색 (컴포넌트 내 aria-label="편집 완료" 사용)
    fireEvent.click(screen.getByRole('button', { name: '편집 완료' }));

    expect(onDone).toHaveBeenCalledTimes(1);
  });

  // TC-E1-6: Close 버튼 클릭 시 onClose 콜백 호출
  it('TC-E1-6: Close 버튼 클릭 시 onClose 콜백이 호출된다', () => {
    const onClose = vi.fn();

    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo: vi.fn(),
      onSave: vi.fn(),
      onDone: vi.fn(),
      onClose,
    });

    fireEvent.click(screen.getByRole('button', { name: '편집기 닫기' }));

    expect(onClose).toHaveBeenCalledTimes(1);
  });

  // TC-E1-7: title prop 전달 시 제목이 표시된다
  it('TC-E1-7: title prop 전달 시 제목이 표시된다', () => {
    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo: vi.fn(),
      onSave: vi.fn(),
      onDone: vi.fn(),
      onClose: vi.fn(),
      title: '명함 디자인',
    });

    expect(screen.getByText('명함 디자인')).toBeInTheDocument();
    // 기본 "편집 중" 텍스트는 표시되지 않아야 함
    expect(screen.queryByText('편집 중')).not.toBeInTheDocument();
  });

  // TC-E1-8: 접근성 - aria-label 확인
  it('TC-E1-8: 모든 버튼에 aria-label이 올바르게 설정된다', () => {
    renderPassiveToolbar({
      onUndo: vi.fn(),
      onRedo: vi.fn(),
      onSave: vi.fn(),
      onDone: vi.fn(),
      onClose: vi.fn(),
    });

    // 상단 바 닫기 버튼
    expect(screen.getByLabelText('편집기 닫기')).toBeInTheDocument();

    // 하단 바 도구 버튼들
    expect(screen.getByLabelText('실행 취소')).toBeInTheDocument();
    expect(screen.getByLabelText('다시 실행')).toBeInTheDocument();
    expect(screen.getByLabelText('저장')).toBeInTheDocument();
  });
});
