// MobileEditor passive mode 통합 테스트
// @MX:SPEC: SPEC-PASSIVE-001 Phase E

import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach, type Mock } from 'vitest';
import { MobileEditor } from '../MobileEditor';

// useEdicus 훅 모킹
vi.mock('@/hooks/useEdicus', () => ({
  useEdicus: vi.fn(() => ({
    isReady: true,
    error: null,
    postToEditor: vi.fn(),
    createProject: vi.fn(),
  })),
}));

// getMobileConfig 모킹
vi.mock('@/lib/edicus/mobile-config', () => ({
  getMobileConfig: vi.fn(() => ({
    mobile: true,
    lang: 'ko',
    ui_locale: 'ko',
    private_css: '',
  })),
}));

// fetch 모킹 - 편집기 토큰 발급 API
global.fetch = vi.fn(() =>
  Promise.resolve({
    ok: true,
    json: () => Promise.resolve({ token: 'test-token' }),
  }),
) as unknown as typeof fetch;

// useEdicus 훅의 mock 참조를 가져오기 위한 import
import { useEdicus } from '@/hooks/useEdicus';

describe('MobileEditor passive mode', () => {
  beforeEach(() => {
    vi.clearAllMocks();

    // fetch 기본 응답 재설정
    (global.fetch as Mock).mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ token: 'test-token' }),
    });
  });

  // TC-E2-1: passiveMode={true} 시 PassiveToolbar 렌더링 확인
  it('TC-E2-1: passiveMode={true}일 때 PassiveToolbar(상단/하단 도구바)가 렌더링된다', async () => {
    const onClose = vi.fn();

    render(
      <MobileEditor
        templateId="test-template"
        passiveMode={true}
        onClose={onClose}
      />,
    );

    // passive mode: PassiveToolbarTop의 닫기 버튼이 표시되어야 함
    await waitFor(() => {
      expect(screen.getByRole('button', { name: '편집기 닫기' })).toBeInTheDocument();
    });

    // passive mode: PassiveToolbarBottom의 도구 버튼들이 표시되어야 함
    expect(screen.getByRole('button', { name: '실행 취소' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: '다시 실행' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: '저장' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: '편집 완료' })).toBeInTheDocument();
  });

  // TC-E2-2: passiveMode={false} 시 PassiveToolbar 미렌더링
  it('TC-E2-2: passiveMode={false}(기본값)일 때 PassiveToolbar가 렌더링되지 않는다', async () => {
    const onClose = vi.fn();

    render(
      <MobileEditor
        templateId="test-template"
        passiveMode={false}
        onClose={onClose}
      />,
    );

    // 표준 모드: PassiveToolbar 하단 도구 버튼이 없어야 함
    await waitFor(() => {
      // 표준 모드에도 닫기 버튼이 있지만, aria-label이 "편집기 닫기"인 것은 PassiveToolbarTop 것
      // 하단 도구바(Undo/Redo/Save/Done)가 없어야 함
      expect(screen.queryByRole('button', { name: '실행 취소' })).not.toBeInTheDocument();
    });

    expect(screen.queryByRole('button', { name: '다시 실행' })).not.toBeInTheDocument();
    expect(screen.queryByRole('button', { name: '저장' })).not.toBeInTheDocument();
    expect(screen.queryByRole('button', { name: '완료' })).not.toBeInTheDocument();
  });

  // TC-E2-3: PassiveToolbar 버튼 클릭 시 postToEditor 명령 전달 확인
  it('TC-E2-3: PassiveToolbar 버튼 클릭 시 postToEditor에 올바른 명령이 전달된다', async () => {
    const onClose = vi.fn();
    const mockPostToEditor = vi.fn();

    // postToEditor 모킹된 버전으로 교체
    (useEdicus as Mock).mockReturnValue({
      isReady: true,
      error: null,
      postToEditor: mockPostToEditor,
      createProject: vi.fn(),
    });

    render(
      <MobileEditor
        templateId="test-template"
        passiveMode={true}
        onClose={onClose}
      />,
    );

    // 버튼이 렌더링될 때까지 대기
    await waitFor(() => {
      expect(screen.getByRole('button', { name: '실행 취소' })).toBeInTheDocument();
    });

    // Undo 버튼 클릭 → postToEditor('undo', {}) 호출
    fireEvent.click(screen.getByRole('button', { name: '실행 취소' }));
    expect(mockPostToEditor).toHaveBeenCalledWith('undo', {});

    // Redo 버튼 클릭 → postToEditor('redo', {}) 호출
    fireEvent.click(screen.getByRole('button', { name: '다시 실행' }));
    expect(mockPostToEditor).toHaveBeenCalledWith('redo', {});

    // Save 버튼 클릭 → postToEditor('save-doc', {}) 호출
    fireEvent.click(screen.getByRole('button', { name: '저장' }));
    expect(mockPostToEditor).toHaveBeenCalledWith('save-doc', {});
  });

  // TC-E2-4: onDocChanged 콜백 호출 확인 (mock SDK 이벤트 통해)
  it('TC-E2-4: doc-changed SDK 이벤트 수신 시 onDocChanged 콜백이 호출된다', async () => {
    const onDocChanged = vi.fn();
    const onClose = vi.fn();

    // handleSdkEvent를 캡처하기 위해 useEdicus 모킹
    let capturedEventHandler: ((err: null, data: unknown) => void) | null = null;
    (useEdicus as Mock).mockImplementation(
      (_ref: unknown, _opts: unknown, eventHandler: (err: null, data: unknown) => void) => {
        capturedEventHandler = eventHandler;
        return {
          isReady: true,
          error: null,
          postToEditor: vi.fn(),
          createProject: vi.fn(),
        };
      },
    );

    render(
      <MobileEditor
        templateId="test-template"
        passiveMode={true}
        onClose={onClose}
        onDocChanged={onDocChanged}
      />,
    );

    // SDK 이벤트 핸들러가 등록될 때까지 대기
    await waitFor(() => {
      expect(capturedEventHandler).not.toBeNull();
    });

    // doc-changed 이벤트 시뮬레이션
    const mockDocData = { action: 'doc-changed', pageCount: 3 };
    capturedEventHandler!(null, mockDocData);

    expect(onDocChanged).toHaveBeenCalledWith(mockDocData);
  });

  // TC-E2-5: onReadyToListen 콜백 호출 확인 (mock SDK 이벤트 통해)
  it('TC-E2-5: ready-to-listen SDK 이벤트 수신 시 onReadyToListen 콜백이 호출된다', async () => {
    const onReadyToListen = vi.fn();
    const onClose = vi.fn();

    // handleSdkEvent를 캡처하기 위해 useEdicus 모킹
    let capturedEventHandler: ((err: null, data: unknown) => void) | null = null;
    (useEdicus as Mock).mockImplementation(
      (_ref: unknown, _opts: unknown, eventHandler: (err: null, data: unknown) => void) => {
        capturedEventHandler = eventHandler;
        return {
          isReady: true,
          error: null,
          postToEditor: vi.fn(),
          createProject: vi.fn(),
        };
      },
    );

    render(
      <MobileEditor
        templateId="test-template"
        passiveMode={true}
        onClose={onClose}
        onReadyToListen={onReadyToListen}
      />,
    );

    // SDK 이벤트 핸들러가 등록될 때까지 대기
    await waitFor(() => {
      expect(capturedEventHandler).not.toBeNull();
    });

    // ready-to-listen 이벤트 시뮬레이션
    capturedEventHandler!(null, { action: 'ready-to-listen' });

    expect(onReadyToListen).toHaveBeenCalledTimes(1);
  });
});
