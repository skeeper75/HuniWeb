'use client';

/**
 * HuniEditorSDK
 *
 * EdicusClient를 합성(composition)으로 감싸는 고수준 SDK 클래스입니다.
 * PC passive 모드 편집기 및 외부 통합을 위한 단순화된 API를 제공합니다.
 */

// @MX:ANCHOR: [AUTO] SDK 초기화 및 이벤트 관리의 공개 API 경계
// @MX:REASON: useHuniEditor 훅, PCPassiveEditor, 테스트 등 다수 모듈에서 참조하는 핵심 진입점

import { EdicusClient } from './client';
import { getDesktopConfig } from './mobile-config';

/** 신뢰할 수 있는 편집기 iframe origin */
const TRUSTED_ORIGIN = 'edicusbase.firebaseapp.com';

/**
 * HuniEditorSDK 초기화 설정
 */
export interface HuniEditorConfig {
  /** 편집기를 마운트할 컨테이너 요소의 ID */
  containerId: string;
  /** 상품 코드 (ps_code) */
  productId: string;
  /** 파트너 코드 */
  partnerId: string;
  /** passive 모드 활성화 여부 */
  passiveMode?: boolean;
  /** 사용자 정의 CSS */
  privateCss?: string;
  /** 추가 파라미터 */
  extraParams?: Record<string, string>;
  /** 편집기 준비 완료 콜백 */
  onReady?: () => void;
  /** 편집기 닫기 콜백 */
  onClose?: () => void;
  /** 오류 콜백 */
  onError?: (error: Error) => void;
}

/**
 * HuniEditorSDK가 발행하는 이벤트 타입
 */
export type HuniEditorEvent =
  | 'ready'
  | 'close'
  | 'doc-changed'
  | 'ready-to-listen'
  | 'save-complete'
  | 'error';

/**
 * 편집기 이벤트 핸들러 타입
 */
type EventHandler = (...args: unknown[]) => void;

/**
 * HuniEditorSDK
 *
 * EdicusClient를 합성으로 사용하는 SDK 클래스입니다.
 * 타입 안전한 이벤트 시스템과 postMessage 수신 처리를 포함합니다.
 */
export class HuniEditorSDK {
  /** EdicusClient 인스턴스 (합성) */
  private client: EdicusClient | null = null;

  /** SDK 준비 상태 */
  private _isReady = false;

  /** passive 모드 활성화 여부 */
  private _isPassiveMode = false;

  /** 타입 안전한 이벤트 리스너 맵 */
  private listeners: Map<HuniEditorEvent, Set<EventHandler>> = new Map();

  /** window message 이벤트 핸들러 참조 (제거 시 사용) */
  private messageHandler: ((event: MessageEvent) => void) | null = null;

  /** 컨테이너 요소 참조 */
  private container: HTMLElement | null = null;

  /**
   * SDK를 초기화합니다.
   *
   * @param config - 초기화 설정
   */
  async init(config: HuniEditorConfig): Promise<void> {
    this._isPassiveMode = config.passiveMode ?? false;

    // EdicusClient 생성 및 초기화
    const baseUrl = process.env.NEXT_PUBLIC_EDICUS_BASE_URL ?? '';
    this.client = new EdicusClient({
      baseUrl,
      partner: config.partnerId,
    });

    await this.client.init();

    // 컨테이너 요소 탐색
    const container = document.getElementById(config.containerId);
    if (!container) {
      throw new Error(`컨테이너 요소를 찾을 수 없습니다: ${config.containerId}`);
    }
    this.container = container;

    // postMessage 리스너 등록
    this._setupMessageListener();

    // 토큰 발급
    const token = await this._fetchToken();

    // 데스크탑 설정 로드
    const desktopConfig = getDesktopConfig(config.partnerId);

    // 편집기 프로젝트 생성 파라미터 구성
    const projectParams: Record<string, unknown> = {
      token,
      ps_code: config.productId,
      title: '',
      parent_element: container,
      ...desktopConfig,
      ...(config.privateCss ? { private_css: config.privateCss } : {}),
      ...(config.extraParams ?? {}),
    };

    // passive 모드인 경우 run_mode 추가
    if (this._isPassiveMode) {
      projectParams.run_mode = 'passive';
    }

    // 프로젝트 생성 및 편집기 시작
    // unknown을 경유하여 타입 안전하게 캐스팅 (SDK API 형식 요구사항)
    this.client.createProject(
      projectParams as unknown as Parameters<EdicusClient['createProject']>[0],
      (_err, data) => {
        const eventType = (data as { type?: string; action?: string }).type ??
          (data as { type?: string; action?: string }).action;

        if (eventType === 'ready' || eventType === 'ready-to-listen') {
          this._isReady = true;
          this._emit('ready');
          config.onReady?.();
        } else if (eventType === 'close') {
          this._emit('close');
          config.onClose?.();
        } else if (eventType === 'doc-changed') {
          this._emit('doc-changed', data);
        } else if (eventType === 'save-complete') {
          this._emit('save-complete', data);
        } else if (eventType === 'error') {
          const error = new Error('편집기 오류가 발생했습니다.');
          this._emit('error', error);
          config.onError?.(error);
        }
      },
    );
  }

  /**
   * SDK를 정리합니다.
   * 메시지 리스너를 제거하고 편집기 인스턴스를 파괴합니다.
   */
  destroy(): void {
    // window 메시지 리스너 제거
    if (this.messageHandler) {
      window.removeEventListener('message', this.messageHandler);
      this.messageHandler = null;
    }

    // EdicusClient 정리
    if (this.client && this.container) {
      try {
        this.client.destroy(this.container);
      } catch {
        // 이미 제거된 경우 무시
      }
    }

    this.client = null;
    this.container = null;
    this._isReady = false;
    this.listeners.clear();
  }

  /**
   * 실행 취소 명령을 편집기에 전송합니다.
   */
  undo(): void {
    if (!this._isReady || !this.client) return;
    this.client.postToEditor('undo', {});
  }

  /**
   * 다시 실행 명령을 편집기에 전송합니다.
   */
  redo(): void {
    if (!this._isReady || !this.client) return;
    this.client.postToEditor('redo', {});
  }

  /**
   * 저장 명령을 편집기에 전송합니다.
   *
   * 주의: 액션 이름은 'save-doc'이어야 합니다. 'save'가 아닙니다.
   */
  save(): void {
    if (!this._isReady || !this.client) return;
    this.client.postToEditor('save-doc', {});
  }

  /**
   * 편집기를 닫습니다.
   * 'close' 이벤트를 발행한 후 SDK를 정리합니다.
   */
  close(): void {
    this._emit('close');
    this.destroy();
  }

  /**
   * 이벤트 핸들러를 등록합니다.
   *
   * @param event - 구독할 이벤트 타입
   * @param handler - 이벤트 핸들러
   */
  on(event: HuniEditorEvent, handler: EventHandler): void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Set());
    }
    this.listeners.get(event)!.add(handler);
  }

  /**
   * 이벤트 핸들러를 제거합니다.
   *
   * @param event - 구독 해제할 이벤트 타입
   * @param handler - 제거할 이벤트 핸들러
   */
  off(event: HuniEditorEvent, handler: EventHandler): void {
    this.listeners.get(event)?.delete(handler);
  }

  /**
   * SDK 준비 상태를 반환합니다.
   */
  get isReady(): boolean {
    return this._isReady;
  }

  /**
   * passive 모드 활성화 여부를 반환합니다.
   */
  get isPassiveMode(): boolean {
    return this._isPassiveMode;
  }

  /**
   * 편집기 토큰을 서버에서 발급받습니다.
   */
  private async _fetchToken(): Promise<string> {
    const response = await fetch('/api/edicus/auth', { method: 'POST' });
    if (!response.ok) throw new Error('토큰 발급 실패');
    const data = (await response.json()) as { token: string };
    return data.token;
  }

  /**
   * window message 이벤트 리스너를 등록합니다.
   *
   * @MX:WARN: [AUTO] Cross-origin postMessage 수신 처리 - origin 검증 필수
   * @MX:REASON: 신뢰할 수 없는 origin의 메시지를 처리하면 보안 취약점 발생
   */
  private _setupMessageListener(): void {
    this.messageHandler = (event: MessageEvent) => {
      // origin 검증: 신뢰할 수 없는 출처의 메시지는 무시
      if (!event.origin.includes(TRUSTED_ORIGIN)) return;

      const data = event.data as {
        action?: string;
        type?: string;
        info?: Record<string, unknown>;
      };

      if (!data) return;

      const eventType = data.action ?? data.type;
      if (!eventType) return;

      // SDK 이벤트 타입으로 매핑
      const mappedEvent = this._mapToHuniEvent(eventType);
      if (mappedEvent) {
        if (mappedEvent === 'ready') {
          this._isReady = true;
        }
        this._emit(mappedEvent, data.info);
      }
    };

    window.addEventListener('message', this.messageHandler);
  }

  /**
   * 편집기에서 수신한 action/type 문자열을 HuniEditorEvent로 변환합니다.
   */
  private _mapToHuniEvent(eventType: string): HuniEditorEvent | null {
    const mapping: Record<string, HuniEditorEvent> = {
      ready: 'ready',
      close: 'close',
      'doc-changed': 'doc-changed',
      'ready-to-listen': 'ready-to-listen',
      'save-complete': 'save-complete',
      error: 'error',
    };

    return mapping[eventType] ?? null;
  }

  /**
   * 등록된 핸들러에 이벤트를 발행합니다.
   */
  private _emit(event: HuniEditorEvent, ...args: unknown[]): void {
    this.listeners.get(event)?.forEach((handler) => {
      handler(...args);
    });
  }
}
