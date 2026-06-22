/**
 * RedEditorSDK Next.js 래퍼 모듈
 *
 * 브라우저 전용 SDK를 Next.js 환경에서 안전하게 사용하기 위한 래퍼입니다.
 * SSR/SSG 환경에서 window 객체 접근 오류를 방지하고,
 * 동적 스크립트 로딩 및 타입 안전성을 제공합니다.
 *
 * 주요 기능:
 * - 동적 스크립트 로딩 (브라우저 전용)
 * - SDK 싱글턴 인스턴스 관리
 * - 타입 안전한 이벤트 핸들링
 * - 에러 바운더리 통합 지원
 */

import type {
  RedEditorSDKConfig,
  RedEditorEventType,
  RedEditorEventCallback,
  ProjectInfo,
  ProductInfo,
  VDPEntity,
  CustomTabInfo,
  RemoteEditorCommand,
  Template,
} from "./red-editor-sdk.d";

// =====================================================
// 타입 정의
// =====================================================

/**
 * SDK 초기화 상태
 */
type SDKStatus = "idle" | "loading" | "ready" | "error";

/**
 * 스크립트 로드 옵션
 */
interface LoadScriptOptions {
  /** SDK 스크립트 URL */
  scriptUrl?: string;
  /** 로드 타임아웃 (밀리초, 기본값: 10000) */
  timeout?: number;
}

/**
 * SDK 래퍼 초기화 옵션
 */
export interface RedEditorWrapperOptions extends RedEditorSDKConfig {
  /** SDK 스크립트 URL (기본값: CDN URL) */
  scriptUrl?: string;
  /** 로드 타임아웃 (밀리초) */
  loadTimeout?: number;
  /** 초기화 실패 시 폴백 URL */
  fallbackScriptUrl?: string;
}

/**
 * 에디터 이벤트 핸들러 맵
 */
export interface EditorEventHandlers {
  /** 에디터 닫힐 때 */
  onClose?: RedEditorEventCallback;
  /** 사용자 토큰 갱신 요청 시 */
  onRequestUserToken?: RedEditorEventCallback<{ userId: string }>;
  /** 장바구니 이동 요청 시 */
  onGotoCart?: RedEditorEventCallback<{ cartData: unknown }>;
  /** 저장 완료 시 */
  onSave?: RedEditorEventCallback<{ projectId: string }>;
}

/**
 * 프로젝트 생성 옵션
 */
export interface CreateProjectOptions {
  /** 에디터를 마운트할 컨테이너 */
  container: HTMLElement;
  /** 팝업으로 열기 여부 */
  popup?: boolean;
  /** 기타 SDK 옵션 */
  [key: string]: unknown;
}

/**
 * 프로젝트 열기 옵션
 */
export interface OpenProjectOptions {
  /** 에디터를 마운트할 컨테이너 */
  container: HTMLElement;
  /** 기타 SDK 옵션 */
  [key: string]: unknown;
}

// =====================================================
// 스크립트 동적 로딩
// =====================================================

/** SDK 스크립트 로드 상태 캐시 */
const scriptLoadCache = new Map<string, Promise<void>>();

/**
 * 브라우저 환경 여부를 확인합니다.
 * Next.js SSR 환경에서 window 접근 오류를 방지합니다.
 *
 * @returns 브라우저 환경이면 true
 */
export function isBrowser(): boolean {
  return typeof window !== "undefined";
}

/**
 * 외부 JavaScript 스크립트를 동적으로 로드합니다.
 * 동일한 URL은 한 번만 로드하며, 이후 호출은 캐시된 Promise를 반환합니다.
 *
 * @param url - 로드할 스크립트 URL
 * @param options - 로드 옵션
 * @returns 로드 완료 시 resolve되는 Promise
 * @throws SSR 환경에서 호출 시 또는 타임아웃 시 오류
 */
export function loadScript(
  url: string,
  options: LoadScriptOptions = {},
): Promise<void> {
  if (!isBrowser()) {
    return Promise.reject(
      new Error("loadScript: 브라우저 환경에서만 사용 가능합니다."),
    );
  }

  // 이미 로드되었거나 로드 중인 경우 캐시된 Promise 반환
  if (scriptLoadCache.has(url)) {
    return scriptLoadCache.get(url)!;
  }

  const { timeout = 10000 } = options;

  const loadPromise = new Promise<void>((resolve, reject) => {
    // 이미 DOM에 스크립트가 있으면 재사용
    const existing = document.querySelector<HTMLScriptElement>(
      `script[src="${url}"]`,
    );
    if (existing) {
      resolve();
      return;
    }

    const script = document.createElement("script");
    script.src = url;
    script.async = true;

    // 타임아웃 처리
    const timeoutId = setTimeout(() => {
      scriptLoadCache.delete(url);
      reject(new Error(`스크립트 로드 타임아웃: ${url}`));
    }, timeout);

    script.onload = () => {
      clearTimeout(timeoutId);
      resolve();
    };

    script.onerror = () => {
      clearTimeout(timeoutId);
      scriptLoadCache.delete(url);
      reject(new Error(`스크립트 로드 실패: ${url}`));
    };

    document.head.appendChild(script);
  });

  scriptLoadCache.set(url, loadPromise);
  return loadPromise;
}

// =====================================================
// SDK 래퍼 클래스
// =====================================================

/**
 * RedEditorSDK의 Next.js 안전 래퍼 클래스
 *
 * SSR 환경 대응, 동적 스크립트 로딩, 타입 안전성을 제공합니다.
 *
 * @MX:NOTE: 외부 SDK 래핑 패턴 - SSR 환경에서 window 접근 방지, 싱글턴 관리
 *
 * @example
 * ```typescript
 * // Next.js 컴포넌트에서 사용
 * const wrapper = new RedEditorWrapper({
 *   accessToken: process.env.NEXT_PUBLIC_EDICUS_TOKEN!,
 *   userId: session.user.id,
 * });
 *
 * // 에디터 열기
 * await wrapper.initSDK();
 * await wrapper.createProject(
 *   { psCode: 'PROD001' },
 *   { container: containerRef.current! }
 * );
 *
 * // 이벤트 핸들링
 * wrapper.setupEventHandlers({
 *   onClose: () => router.push('/'),
 *   onGotoCart: ({ cartData }) => handleCart(cartData),
 * });
 * ```
 */
export class RedEditorWrapper {
  private config: RedEditorWrapperOptions;
  private sdk: InstanceType<typeof window.RedEditorSDK> | null = null;
  private status: SDKStatus = "idle";
  private initPromise: Promise<void> | null = null;

  constructor(config: RedEditorWrapperOptions) {
    this.config = config;
  }

  // ===== SDK 초기화 =====

  /**
   * SDK를 초기화합니다.
   * 브라우저 환경에서만 동작하며, 중복 초기화를 방지합니다.
   *
   * @returns 초기화 완료 시 resolve되는 Promise
   * @throws 브라우저 환경이 아니거나 SDK 로드 실패 시
   */
  async initSDK(): Promise<void> {
    if (!isBrowser()) {
      throw new Error("initSDK: 브라우저 환경에서만 사용 가능합니다.");
    }

    if (this.status === "ready") {
      return;
    }

    if (this.initPromise) {
      return this.initPromise;
    }

    this.status = "loading";
    this.initPromise = this._doInit();

    try {
      await this.initPromise;
      this.status = "ready";
    } catch (error) {
      this.status = "error";
      this.initPromise = null;
      throw error;
    }
  }

  private async _doInit(): Promise<void> {
    const { scriptUrl, fallbackScriptUrl, loadTimeout, ...sdkConfig } =
      this.config;

    // SDK 스크립트 로드
    if (scriptUrl) {
      try {
        await loadScript(scriptUrl, { timeout: loadTimeout });
      } catch (primaryError) {
        // 폴백 URL 시도
        if (fallbackScriptUrl) {
          await loadScript(fallbackScriptUrl, { timeout: loadTimeout });
        } else {
          throw primaryError;
        }
      }
    }

    // window.RedEditorSDK 존재 확인
    if (!window.RedEditorSDK) {
      throw new Error(
        "RedEditorSDK를 찾을 수 없습니다. scriptUrl을 확인하거나 SDK 스크립트를 직접 로드하세요.",
      );
    }

    // SDK 인스턴스 생성
    this.sdk = new window.RedEditorSDK(sdkConfig);
  }

  // ===== SDK 인스턴스 접근 =====

  /**
   * SDK 인스턴스를 반환합니다.
   * initSDK()가 완료되지 않은 경우 오류를 발생시킵니다.
   *
   * @throws SDK가 초기화되지 않은 경우
   */
  getSDK(): NonNullable<typeof this.sdk> {
    if (!this.sdk) {
      throw new Error(
        "SDK가 초기화되지 않았습니다. initSDK()를 먼저 호출하세요.",
      );
    }
    return this.sdk;
  }

  /**
   * SDK 초기화 상태를 반환합니다.
   */
  getStatus(): SDKStatus {
    return this.status;
  }

  /**
   * SDK가 사용 가능한 상태인지 확인합니다.
   */
  isReady(): boolean {
    return this.status === "ready" && this.sdk !== null;
  }

  // ===== 이벤트 핸들러 설정 =====

  /**
   * 에디터 이벤트 핸들러들을 일괄 등록합니다.
   *
   * @param handlers - 이벤트 핸들러 맵
   */
  setupEventHandlers(handlers: EditorEventHandlers): void {
    const sdk = this.getSDK();

    if (handlers.onClose) {
      sdk.on("close", handlers.onClose);
    }

    if (handlers.onRequestUserToken) {
      sdk.on("request-user-token", handlers.onRequestUserToken);
    }

    if (handlers.onGotoCart) {
      sdk.on("goto-cart", handlers.onGotoCart);
    }

    if (handlers.onSave) {
      sdk.on("save", handlers.onSave);
    }
  }

  /**
   * 단일 이벤트 리스너를 등록합니다.
   *
   * @param eventType - 이벤트 타입
   * @param callback - 콜백 함수
   */
  on<T = unknown>(
    eventType: RedEditorEventType,
    callback: RedEditorEventCallback<T>,
  ): void {
    this.getSDK().on(eventType, callback);
  }

  // ===== 프로젝트 생성/열기 =====

  /**
   * 새 프로젝트를 생성하고 에디터를 엽니다.
   * initSDK()가 완료된 후 호출해야 합니다.
   *
   * @param productInfo - 상품 정보
   * @param options - 에디터 옵션
   */
  async createProject(
    productInfo: { psCode: string; templateId?: string; [key: string]: unknown },
    options: CreateProjectOptions,
  ): Promise<void> {
    return this.getSDK().createProject(productInfo, options);
  }

  /**
   * 기존 프로젝트를 열어 에디터에 로드합니다.
   *
   * @param projectId - 열 프로젝트 ID
   * @param options - 에디터 옵션
   */
  async openProject(
    projectId: string,
    options: OpenProjectOptions,
  ): Promise<void> {
    return this.getSDK().openProject(projectId, options);
  }

  // ===== 에디터 제어 =====

  /**
   * 에디터를 저장하지 않고 닫습니다.
   */
  close(): void {
    this.getSDK().close();
  }

  /**
   * 현재 편집 내용을 저장합니다.
   */
  async save(): Promise<void> {
    return this.getSDK().save();
  }

  /**
   * 저장 후 에디터를 닫습니다.
   */
  async saveThenClose(): Promise<void> {
    return this.getSDK().saveThenClose();
  }

  /**
   * 에디터 인스턴스를 완전히 제거합니다.
   * React 컴포넌트 언마운트 시 호출하세요.
   */
  destroy(): void {
    if (this.sdk) {
      this.sdk.destroy();
      this.sdk = null;
      this.status = "idle";
      this.initPromise = null;
    }
  }

  // ===== VDP 관련 =====

  /**
   * VDP 엔티티 목록을 가져옵니다.
   */
  getEntities(
    dataMap: Record<string, unknown[]>,
    templateList: Template[],
  ): VDPEntity[] {
    return this.getSDK().getEntities(dataMap, templateList);
  }

  /**
   * 재고 없음 항목 정보를 비동기로 가져옵니다.
   */
  async getNoStocksInfo(items: Record<string, unknown>[]): Promise<string[]> {
    return this.getSDK().getNoStocksInfo(items);
  }

  // ===== 프로젝트 조회 =====

  /**
   * 프로젝트 목록을 가져옵니다.
   */
  async getProjectList(): Promise<ProjectInfo[]> {
    return this.getSDK().getProjectList();
  }

  /**
   * 상품 정보를 가져옵니다.
   */
  async getProductInfo(productCode: string): Promise<ProductInfo> {
    return this.getSDK().getProductInfo(productCode);
  }

  /**
   * 프로젝트 썸네일 목록을 가져옵니다.
   */
  async getProjectThumbnails(projectId: string): Promise<string[]> {
    return this.getSDK().getProjectThumbnails(projectId);
  }

  /**
   * 주문 전 준비 작업을 수행합니다.
   */
  async prepareOrder(
    orderInfo: Record<string, unknown>,
  ): Promise<Record<string, unknown>> {
    return this.getSDK().prepareOrder(orderInfo);
  }

  // ===== 커스텀 탭 =====

  /**
   * 커스텀 탭 정보를 가져옵니다.
   */
  getCustomTabInfo(): CustomTabInfo {
    return this.getSDK().getCustomTabInfo();
  }

  // ===== 원격 제어 =====

  /**
   * 에디터에 원격 명령을 전송합니다.
   */
  async remoteEditor(
    action: string,
    data?: Record<string, unknown>,
  ): Promise<unknown> {
    return this.getSDK().remoteEditor(action, data);
  }

  /**
   * 여러 원격 명령을 일괄 전송합니다.
   */
  async remoteEditorBulk(commands: RemoteEditorCommand[]): Promise<unknown[]> {
    return this.getSDK().remoteEditorBulk(commands);
  }
}

// =====================================================
// 유틸리티 함수
// =====================================================

/**
 * 싱글턴 SDK 래퍼 인스턴스를 관리합니다.
 * 애플리케이션 전체에서 하나의 SDK 인스턴스만 사용할 때 활용합니다.
 */
let globalWrapper: RedEditorWrapper | null = null;

/**
 * 전역 SDK 래퍼를 초기화합니다.
 * 이미 초기화된 경우 기존 인스턴스를 반환합니다.
 *
 * @param config - SDK 설정 (최초 호출 시만 적용)
 * @returns SDK 래퍼 인스턴스
 */
export function getOrCreateWrapper(
  config: RedEditorWrapperOptions,
): RedEditorWrapper {
  if (!globalWrapper) {
    globalWrapper = new RedEditorWrapper(config);
  }
  return globalWrapper;
}

/**
 * 전역 SDK 래퍼를 제거합니다.
 * 완전한 정리가 필요한 경우 사용합니다.
 */
export function destroyGlobalWrapper(): void {
  if (globalWrapper) {
    globalWrapper.destroy();
    globalWrapper = null;
  }
}

/**
 * 이벤트 핸들러 유틸리티: 한 번만 실행되는 이벤트 리스너를 생성합니다.
 *
 * @param wrapper - SDK 래퍼 인스턴스
 * @param eventType - 이벤트 타입
 * @returns 한 번만 실행되는 Promise
 *
 * @example
 * ```typescript
 * // 에디터가 닫힐 때까지 대기
 * await waitForEvent(wrapper, 'close');
 * console.log('에디터가 닫혔습니다.');
 * ```
 */
export function waitForEvent<T = unknown>(
  wrapper: RedEditorWrapper,
  eventType: RedEditorEventType,
): Promise<T | undefined> {
  return new Promise<T | undefined>((resolve) => {
    const handler: RedEditorEventCallback<T> = (data) => {
      resolve(data);
    };
    wrapper.on<T>(eventType, handler);
  });
}

/**
 * 타임아웃이 있는 이벤트 대기 유틸리티
 *
 * @param wrapper - SDK 래퍼 인스턴스
 * @param eventType - 이벤트 타입
 * @param timeout - 타임아웃 (밀리초)
 * @returns 이벤트 데이터 또는 타임아웃 오류
 *
 * @example
 * ```typescript
 * try {
 *   const cartData = await waitForEventWithTimeout(wrapper, 'goto-cart', 30000);
 *   handleCart(cartData);
 * } catch (error) {
 *   console.error('장바구니 이벤트 타임아웃');
 * }
 * ```
 */
export function waitForEventWithTimeout<T = unknown>(
  wrapper: RedEditorWrapper,
  eventType: RedEditorEventType,
  timeout: number,
): Promise<T | undefined> {
  return Promise.race([
    waitForEvent<T>(wrapper, eventType),
    new Promise<never>((_, reject) =>
      setTimeout(
        () => reject(new Error(`이벤트 타임아웃: ${eventType}`)),
        timeout,
      ),
    ),
  ]);
}
