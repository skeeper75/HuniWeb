'use client';

/**
 * Edicus SDK 브라우저 클라이언트 래퍼
 *
 * 브라우저 환경에서 Edicus SDK를 초기화하고 타입 안전한 메서드를 제공합니다.
 * postMessage 이벤트를 처리하며, Next.js 클라이언트 컴포넌트에서 사용됩니다.
 */

// @MX:ANCHOR: SDK 초기화 및 이벤트 관리의 공개 API 경계
// @MX:REASON: useEdicus 훅과 EdicusEditor 컴포넌트 등 다수 모듈에서 참조하는 핵심 진입점

import type {
  EdicusContext,
  CreateProjectParams,
  OpenProjectParams,
  EdicusCallback,
} from '@/types/edicus';

/** SDK 스크립트 기본 URL */
const DEFAULT_SDK_URL = '/edicus-sdk-v2.js';

/** SDK 로드 상태 캐시 (중복 로드 방지) */
const scriptLoadPromiseCache = new Map<string, Promise<void>>();

/**
 * 브라우저 환경 여부를 확인합니다.
 * Next.js SSR 환경에서 window 접근 오류를 방지합니다.
 */
export function isBrowser(): boolean {
  return typeof window !== 'undefined';
}

/**
 * 외부 스크립트를 동적으로 로드합니다.
 * 동일한 URL은 한 번만 로드하며, 이후 호출은 캐시된 Promise를 반환합니다.
 *
 * @param url - 로드할 스크립트 URL
 * @param timeout - 로드 타임아웃 (밀리초, 기본값: 10000)
 * @returns 로드 완료 시 resolve되는 Promise
 */
export function loadScript(url: string, timeout = 10000): Promise<void> {
  if (!isBrowser()) {
    return Promise.reject(new Error('loadScript: 브라우저 환경에서만 사용 가능합니다.'));
  }

  // 캐시된 Promise가 있으면 재사용
  const cached = scriptLoadPromiseCache.get(url);
  if (cached) return cached;

  const promise = new Promise<void>((resolve, reject) => {
    // DOM에 이미 스크립트가 있으면 즉시 resolve
    const existing = document.querySelector<HTMLScriptElement>(`script[src="${url}"]`);
    if (existing) {
      resolve();
      return;
    }

    const script = document.createElement('script');
    script.src = url;
    script.async = true;

    const timerId = setTimeout(() => {
      scriptLoadPromiseCache.delete(url);
      reject(new Error(`스크립트 로드 타임아웃: ${url}`));
    }, timeout);

    script.onload = () => {
      clearTimeout(timerId);
      resolve();
    };

    script.onerror = () => {
      clearTimeout(timerId);
      scriptLoadPromiseCache.delete(url);
      reject(new Error(`스크립트 로드 실패: ${url}`));
    };

    document.head.appendChild(script);
  });

  scriptLoadPromiseCache.set(url, promise);
  return promise;
}

/**
 * Edicus SDK 클라이언트 설정
 */
export interface EdicusClientConfig {
  /** 편집기 베이스 URL */
  baseUrl: string;
  /** 파트너 코드 */
  partner: string;
  /** SDK 스크립트 URL (기본값: DEFAULT_SDK_URL) */
  scriptUrl?: string;
}

/**
 * Edicus SDK 브라우저 클라이언트
 *
 * SDK를 동적으로 로드하고 초기화하며, 편집기 컨텍스트를 관리합니다.
 *
 * @MX:ANCHOR: SDK 초기화 및 컨텍스트 관리 공개 인터페이스
 * @MX:REASON: useEdicus 훅과 EdicusEditor 컴포넌트의 핵심 의존성으로 다중 호출 지점 존재
 *
 * @example
 * ```typescript
 * const client = new EdicusClient({
 *   baseUrl: process.env.NEXT_PUBLIC_EDICUS_BASE_URL!,
 *   partner: process.env.NEXT_PUBLIC_EDICUS_PARTNER!,
 * });
 * await client.init();
 * const ctx = client.getContext();
 * ```
 */
export class EdicusClient {
  private config: EdicusClientConfig;
  private context: EdicusContext | null = null;
  private initPromise: Promise<EdicusContext> | null = null;

  constructor(config: EdicusClientConfig) {
    this.config = config;
  }

  /**
   * SDK를 초기화합니다.
   * 중복 호출 시 동일한 Promise를 반환합니다.
   *
   * @returns 초기화된 EdicusContext
   */
  async init(): Promise<EdicusContext> {
    if (this.context) return this.context;
    if (this.initPromise) return this.initPromise;

    this.initPromise = this._doInit();
    try {
      this.context = await this.initPromise;
      return this.context;
    } catch (error) {
      this.initPromise = null;
      throw error;
    }
  }

  private async _doInit(): Promise<EdicusContext> {
    if (!isBrowser()) {
      throw new Error('EdicusClient: 브라우저 환경에서만 초기화할 수 있습니다.');
    }

    const scriptUrl = this.config.scriptUrl ?? DEFAULT_SDK_URL;
    await loadScript(scriptUrl);

    if (!window.edicusSDK) {
      throw new Error('edicusSDK 전역 객체를 찾을 수 없습니다. SDK 스크립트를 확인하세요.');
    }

    // window.edicusSDK.init() 반환 타입과 내부 EdicusContext 타입의 불일치를 해소
    const ctx = window.edicusSDK.init({ base_url: this.config.baseUrl }) as unknown as EdicusContext;
    return ctx;
  }

  /**
   * 초기화된 EdicusContext를 반환합니다.
   * init()이 완료되지 않은 경우 null을 반환합니다.
   */
  getContext(): EdicusContext | null {
    return this.context;
  }

  /**
   * SDK가 준비되었는지 확인합니다.
   */
  isReady(): boolean {
    return this.context !== null;
  }

  /**
   * 새 프로젝트를 생성하고 편집기를 엽니다.
   *
   * @param params - 프로젝트 생성 파라미터 (token, ps_code, title, parent_element 필수)
   * @param callback - 이벤트 콜백
   */
  createProject(params: CreateProjectParams, callback: EdicusCallback): void {
    const ctx = this._requireContext();
    ctx.create_project(
      { ...params, partner: params.partner ?? this.config.partner },
      callback,
    );
  }

  /**
   * 기존 프로젝트를 열어 편집기에 로드합니다.
   *
   * @param params - 프로젝트 열기 파라미터 (token, prjid, parent_element 필수)
   * @param callback - 이벤트 콜백
   */
  openProject(params: OpenProjectParams, callback: EdicusCallback): void {
    const ctx = this._requireContext();
    ctx.open_project(
      { ...params, partner: params.partner ?? this.config.partner },
      callback,
    );
  }

  /**
   * 편집기를 닫습니다.
   *
   * @param parentElement - 편집기가 마운트된 부모 DOM 요소
   */
  close(parentElement: HTMLElement): void {
    const ctx = this._requireContext();
    ctx.close({ parent_element: parentElement });
  }

  /**
   * 편집기를 완전히 제거합니다. (이벤트 리스너 포함)
   *
   * @param parentElement - 편집기가 마운트된 부모 DOM 요소
   */
  destroy(parentElement: HTMLElement): void {
    const ctx = this._requireContext();
    ctx.destroy({ parent_element: parentElement });
    this.context = null;
    this.initPromise = null;
  }

  /**
   * postMessage를 편집기 iframe에 전송합니다.
   * 예: 토큰 갱신 시 'send-user-token' 액션 전송
   *
   * @param action - 액션 이름
   * @param info - 액션 정보
   */
  postToEditor(action: string, info: unknown): void {
    const ctx = this._requireContext();
    ctx.post_to_editor(action, info);
  }

  // @MX:NOTE: context가 null인 경우 명확한 오류 메시지를 제공합니다
  private _requireContext(): EdicusContext {
    if (!this.context) {
      throw new Error('EdicusClient: init()을 먼저 호출하세요.');
    }
    return this.context;
  }
}

/**
 * 싱글턴 EdicusClient 인스턴스를 관리합니다.
 * 애플리케이션 전체에서 단일 인스턴스를 공유할 때 사용합니다.
 */
let globalClient: EdicusClient | null = null;

/**
 * 전역 EdicusClient를 가져오거나 생성합니다.
 * 최초 호출 시 설정이 적용되며, 이후 호출은 동일한 인스턴스를 반환합니다.
 *
 * @param config - 클라이언트 설정 (최초 호출 시만 적용)
 * @returns EdicusClient 인스턴스
 */
export function getOrCreateClient(config: EdicusClientConfig): EdicusClient {
  if (!globalClient) {
    globalClient = new EdicusClient(config);
  }
  return globalClient;
}

/**
 * 전역 EdicusClient를 제거합니다.
 * 테스트 또는 완전한 정리가 필요한 경우 사용합니다.
 */
export function destroyGlobalClient(): void {
  globalClient = null;
}
