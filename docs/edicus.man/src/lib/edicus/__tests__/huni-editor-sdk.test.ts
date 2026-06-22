/**
 * HuniEditorSDK 단위 테스트
 *
 * @MX:SPEC: SPEC-PCPASSIVE-001 Phase E-1
 */

import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { HuniEditorSDK } from '../huni-editor-sdk';

// EdicusClient 모킹
vi.mock('../client', () => ({
  EdicusClient: vi.fn().mockImplementation(() => ({
    init: vi.fn().mockResolvedValue({}),
    createProject: vi.fn(),
    postToEditor: vi.fn(),
    destroy: vi.fn(),
    isReady: vi.fn().mockReturnValue(true),
  })),
}));

// mobile-config 모킹
vi.mock('../mobile-config', () => ({
  getDesktopConfig: vi.fn(() => ({ mobile: false, private_css: '' })),
}));

// fetch 모킹 (토큰 발급)
global.fetch = vi.fn(() =>
  Promise.resolve({
    ok: true,
    json: () => Promise.resolve({ token: 'test-token' }),
  }),
) as unknown as typeof fetch;

// 테스트용 DOM 컨테이너 생성 헬퍼
function createContainer(id: string): HTMLElement {
  const el = document.createElement('div');
  el.id = id;
  document.body.appendChild(el);
  return el;
}

describe('HuniEditorSDK', () => {
  let sdk: HuniEditorSDK;
  const containerId = 'test-editor-container';

  beforeEach(() => {
    sdk = new HuniEditorSDK();
    createContainer(containerId);
  });

  afterEach(() => {
    // 컨테이너 제거
    const el = document.getElementById(containerId);
    if (el) document.body.removeChild(el);
    sdk.destroy();
    vi.clearAllMocks();
  });

  describe('init()', () => {
    it('TC-SDK-1: EdicusClient를 생성하고 init()을 호출한다', async () => {
      const { EdicusClient } = await import('../client');

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      // EdicusClient 생성자가 호출되었는지 확인
      expect(EdicusClient).toHaveBeenCalled();
      // init()이 호출되었는지 확인
      const mockInstance = vi.mocked(EdicusClient).mock.results[0].value;
      expect(mockInstance.init).toHaveBeenCalled();
    });

    it('TC-SDK-2: passive 모드 활성화 시 isPassiveMode가 true이다', async () => {
      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
        passiveMode: true,
      });

      expect(sdk.isPassiveMode).toBe(true);
    });

    it('TC-SDK-3: 컨테이너가 없으면 오류를 발생시킨다', async () => {
      await expect(
        sdk.init({
          containerId: 'non-existent-container',
          productId: 'test-product',
          partnerId: 'hunip',
        }),
      ).rejects.toThrow('컨테이너 요소를 찾을 수 없습니다');
    });

    it('TC-SDK-4: 토큰 발급 API를 호출한다', async () => {
      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      expect(global.fetch).toHaveBeenCalledWith('/api/edicus/auth', { method: 'POST' });
    });
  });

  describe('undo()', () => {
    it('TC-SDK-5: 준비 상태일 때 postToEditor("undo", {})를 호출한다', async () => {
      const { EdicusClient } = await import('../client');

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      // isReady를 true로 설정하기 위해 ready 이벤트 시뮬레이션
      (sdk as unknown as { _isReady: boolean })._isReady = true;

      sdk.undo();

      const mockInstance = vi.mocked(EdicusClient).mock.results[0].value;
      expect(mockInstance.postToEditor).toHaveBeenCalledWith('undo', {});
    });

    it('TC-SDK-6: 준비되지 않은 상태에서는 no-op이다', async () => {
      const { EdicusClient } = await import('../client');

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      // _isReady가 false인 상태 (기본값)
      sdk.undo();

      const mockInstance = vi.mocked(EdicusClient).mock.results[0].value;
      expect(mockInstance.postToEditor).not.toHaveBeenCalled();
    });
  });

  describe('redo()', () => {
    it('TC-SDK-7: 준비 상태일 때 postToEditor("redo", {})를 호출한다', async () => {
      const { EdicusClient } = await import('../client');

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      (sdk as unknown as { _isReady: boolean })._isReady = true;
      sdk.redo();

      const mockInstance = vi.mocked(EdicusClient).mock.results[0].value;
      expect(mockInstance.postToEditor).toHaveBeenCalledWith('redo', {});
    });
  });

  describe('save()', () => {
    it('TC-SDK-8: 준비 상태일 때 postToEditor("save-doc", {})를 호출한다', async () => {
      const { EdicusClient } = await import('../client');

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      (sdk as unknown as { _isReady: boolean })._isReady = true;
      sdk.save();

      const mockInstance = vi.mocked(EdicusClient).mock.results[0].value;
      // 중요: "save"가 아닌 "save-doc"이어야 함
      expect(mockInstance.postToEditor).toHaveBeenCalledWith('save-doc', {});
    });
  });

  describe('on() / off() 이벤트 시스템', () => {
    it('TC-SDK-9: 이벤트 핸들러를 등록하고 _emit 시 호출된다', () => {
      const handler = vi.fn();
      sdk.on('ready', handler);

      // 내부 _emit 메서드 직접 호출
      (sdk as unknown as { _emit: (event: string, ...args: unknown[]) => void })._emit('ready');

      expect(handler).toHaveBeenCalledTimes(1);
    });

    it('TC-SDK-10: off()로 핸들러를 제거하면 이벤트가 호출되지 않는다', () => {
      const handler = vi.fn();
      sdk.on('close', handler);
      sdk.off('close', handler);

      (sdk as unknown as { _emit: (event: string, ...args: unknown[]) => void })._emit('close');

      expect(handler).not.toHaveBeenCalled();
    });

    it('TC-SDK-11: 동일 이벤트에 여러 핸들러를 등록할 수 있다', () => {
      const handler1 = vi.fn();
      const handler2 = vi.fn();

      sdk.on('doc-changed', handler1);
      sdk.on('doc-changed', handler2);

      (sdk as unknown as { _emit: (event: string, ...args: unknown[]) => void })._emit('doc-changed', { page: 1 });

      expect(handler1).toHaveBeenCalledTimes(1);
      expect(handler2).toHaveBeenCalledTimes(1);
    });
  });

  describe('postMessage origin 검증', () => {
    it('TC-SDK-12: 신뢰할 수 없는 origin의 메시지는 무시된다', async () => {
      const handler = vi.fn();
      sdk.on('ready', handler);

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      // 신뢰할 수 없는 origin으로 메시지 전송
      const event = new MessageEvent('message', {
        origin: 'https://malicious-site.com',
        data: { type: 'ready' },
      });
      window.dispatchEvent(event);

      // 핸들러가 호출되지 않아야 함
      expect(handler).not.toHaveBeenCalled();
    });

    it('TC-SDK-13: 신뢰할 수 있는 origin의 메시지는 처리된다', async () => {
      const handler = vi.fn();
      sdk.on('ready', handler);

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      // 신뢰할 수 있는 origin으로 메시지 전송
      const event = new MessageEvent('message', {
        origin: 'https://edicusbase.firebaseapp.com',
        data: { type: 'ready' },
      });
      window.dispatchEvent(event);

      expect(handler).toHaveBeenCalledTimes(1);
    });
  });

  describe('destroy()', () => {
    it('TC-SDK-14: destroy() 후 리스너가 모두 제거된다', async () => {
      const handler = vi.fn();
      sdk.on('ready', handler);

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      sdk.destroy();

      // destroy 후 이벤트 발행 시 핸들러가 호출되지 않아야 함
      (sdk as unknown as { _emit: (event: string, ...args: unknown[]) => void })._emit('ready');
      expect(handler).not.toHaveBeenCalled();
    });

    it('TC-SDK-15: destroy() 후 postMessage가 처리되지 않는다', async () => {
      const handler = vi.fn();
      sdk.on('close', handler);

      await sdk.init({
        containerId,
        productId: 'test-product',
        partnerId: 'hunip',
      });

      sdk.destroy();

      // destroy 후 신뢰할 수 있는 origin에서 메시지 전송
      const event = new MessageEvent('message', {
        origin: 'https://edicusbase.firebaseapp.com',
        data: { type: 'close' },
      });
      window.dispatchEvent(event);

      // 리스너가 제거되었으므로 핸들러가 호출되지 않아야 함
      expect(handler).not.toHaveBeenCalled();
    });
  });
});
