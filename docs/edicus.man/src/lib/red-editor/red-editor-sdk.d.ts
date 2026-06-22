/**
 * RedEditorSDK TypeScript 타입 선언 파일
 *
 * RedEditorSDK(RedEditorSDK.js)와 EdicusSDK v2(edicus-sdk-v2.js)의
 * 퍼블릭 API 표면에 대한 타입 정의입니다.
 *
 * 참조:
 * - src/lib/red-editor/analyzed/red-editor-class.js (레이어 4 분석)
 * - ref/edicus-dev/edicus-sdk-v2.js (Edicus SDK v2 레퍼런스)
 */

// =====================================================
// Edicus SDK v2 (레거시 인터페이스)
// =====================================================

/**
 * Edicus 에디터 URL에 공통으로 추가되는 파라미터들입니다.
 * 환경 설정, 페이지 제어, 편집 제어 등을 포함합니다.
 */
export interface EdicusCommonUrlParams {
  /** 파트너 식별자 */
  partner?: string;
  /** 모바일 환경 여부 */
  mobile?: string;
  /** 부서 구분 */
  div?: string;
  /** 템플릿 언어 설정 ("ko" | "en" | "ja") */
  lang?: string;
  /** UI 언어 설정 ("ko" | "en" | "ja") */
  ui_locale?: string;
  /** 에디터 타입 ("template" | "print") */
  editor_type?: string;
  /** UI 스타일 ("tab-less" | "tab-top-less") */
  ui_style?: string;
  /** 부모 타입 (웹인앱 등) */
  parent_type?: string;
  /** 환경 모드 ("dev" | "demo") */
  env_mode?: string;
  /** 실행 모드 ("passive") */
  run_mode?: string;
  /** 마스터 모드 권한 ("view" | "edit") */
  master_mode?: string;
  /** 페이지 수 */
  num_page?: number;
  /** 최대 페이지 수 */
  max_page?: number;
  /** 최소 페이지 수 */
  min_page?: number;
  /** 최대 주문 수량 */
  max_order?: number;
  /** 최소 주문 수량 */
  min_order?: number;
  /** 강제 플러그인 */
  force_plugin?: string;
  /** 플러그인 파라미터 */
  plugin_param?: string;
  /** 편집 잠금 설정 */
  edit_lock?: string;
  /** 줌 레벨 */
  zoom?: number | string;
  /** 달력 날짜 */
  cal_date?: string;
  /** 비디오 프레임 수 */
  video_frames?: number;
  /** DDP 블록 데이터 (지연 전달) */
  ddp_block?: unknown;
  /** 개인 CSS (지연 전달) */
  private_css?: string;
  /** 상품 정보 (지연 전달) */
  prod_info?: ProductInfo;
  /** 옵션 정보 (지연 전달) */
  options?: Record<string, unknown>;
  /** 옵션 문자열 (지연 전달) */
  option_string?: string;
  /** 데이터 행 (지연 전달) */
  data_row?: Record<string, unknown>;
  /** 데이터 피드 (지연 전달) */
  data_feed?: unknown;
  /** 데이터 컨텐츠 (지연 전달) */
  data_content?: unknown;
  /** 템플릿 목록 (지연 전달) */
  template_list?: Template[];
  /** API 호스트 (개발용) */
  dev_apiHost?: string;
  /** 에셋 호스트 (개발용) */
  dev_assetHost?: string;
  /** 업로드 호스트 (개발용) */
  dev_uploadHost?: string;
  /** 리소스 호스트 (개발용) */
  dev_resHost?: string;
  /** 마운트할 DOM 부모 요소 */
  parent_element: HTMLElement;
  /** API 접근 토큰 */
  token: string;
}

/**
 * 프로젝트 생성 파라미터
 */
export interface CreateProjectParams extends EdicusCommonUrlParams {
  /** 상품 코드 (필수) */
  ps_code: string;
  /** 프로젝트 제목 */
  title: string;
  /** 상품 코드 파라미터 */
  ps_code_param?: string;
  /** 템플릿 URI */
  template_uri?: string;
  /** 컨텐츠 URI */
  content_uri?: string;
}

/**
 * 프로젝트 열기 파라미터
 */
export interface OpenProjectParams extends EdicusCommonUrlParams {
  /** 열 프로젝트 ID (필수) */
  prjid: string;
  /** 상품 코드 */
  ps_code?: string;
}

/**
 * 프로젝트 개편(reform) 파라미터
 */
export interface ReformProjectParams extends EdicusCommonUrlParams {
  /** 개편할 프로젝트 ID */
  prjid: string;
  /** 상품 코드 */
  ps_code: string;
}

/**
 * Edicus 에디터 컨텍스트 객체
 * init() 호출 후 반환되는 모든 에디터 제어 메서드를 포함합니다.
 */
export interface EdicusContext {
  /** 에디터 베이스 URL */
  base_url: string;
  /** 에디터 랜딩 경로 */
  landing_path: string;
  /** 썸네일 뷰어 경로 */
  tnview_path: string;
  /** 미리보기 경로 */
  preview_path: string;
  /** iframe 엘리먼트 참조 */
  iframe_el: HTMLIFrameElement | null;
  /** 메시지 리스너 */
  messageListener: ((event: MessageEvent) => void) | null;

  /**
   * 에디터 닫기 (iframe 제거)
   * @param params - parent_element를 포함하는 파라미터
   */
  close(params: { parent_element: HTMLElement }): void;

  /**
   * 에디터 완전 종료 (이벤트 리스너 해제 + iframe 제거)
   * @param params - parent_element를 포함하는 파라미터
   */
  destroy(params: { parent_element: HTMLElement }): void;

  /**
   * 새 프로젝트 생성 및 에디터 열기
   * @param params - 프로젝트 생성 파라미터
   * @param callback - 콜백 함수 (에러, 데이터)
   */
  create_project(
    params: CreateProjectParams,
    callback: EdicusCallback,
  ): void;

  /**
   * 기존 프로젝트 열기
   * @param params - 프로젝트 열기 파라미터
   * @param callback - 콜백 함수
   */
  open_project(
    params: OpenProjectParams,
    callback: EdicusCallback,
  ): void;

  /**
   * 템플릿 편집
   * @param params - 템플릿 편집 파라미터
   * @param callback - 콜백 함수
   */
  edit_template(
    params: CreateProjectParams,
    callback: EdicusCallback,
  ): void;

  /**
   * 디자인 프로젝트 생성
   * @param params - 디자인 프로젝트 파라미터
   * @param callback - 콜백 함수
   */
  create_design_project(
    params: CreateProjectParams,
    callback: EdicusCallback,
  ): void;

  /**
   * 디자인 프로젝트 열기
   * @param params - 디자인 프로젝트 열기 파라미터
   * @param callback - 콜백 함수
   */
  open_design_project(
    params: OpenProjectParams,
    callback: EdicusCallback,
  ): void;

  /**
   * 프로젝트 개편(상품 변경)
   * @param params - 개편 파라미터
   * @param callback - 콜백 함수
   */
  reform_project(
    params: ReformProjectParams,
    callback: EdicusCallback,
  ): void;

  /**
   * 에디터에 postMessage 전송
   * @param message - 전송할 메시지 객체
   */
  post_to_editor(message: EditorMessage): void;
}

/**
 * Edicus SDK v2 콜백 타입
 * 에디터에서 이벤트 발생 시 호출됩니다.
 */
export type EdicusCallback = (
  error: Error | null,
  data: EdicusEventData,
) => void;

/**
 * 에디터에서 수신되는 이벤트 데이터
 */
export interface EdicusEventData {
  /** 이벤트 타입 (예: "from-edicus", "from-edicus-private") */
  type: string;
  /** 이벤트 액션 */
  action?: string;
  /** 이벤트 추가 정보 */
  info?: Record<string, unknown>;
}

/**
 * Edicus SDK v2 메인 인터페이스
 */
export interface EdicusSDKV2 {
  /** SDK 버전 */
  ver: string;

  /**
   * SDK 컨텍스트를 초기화합니다.
   * @param config - 초기화 설정
   * @returns EdicusContext 인스턴스
   */
  init(config: EdicusInitConfig): EdicusContext;

  /**
   * 컨텍스트 객체를 생성합니다. (내부 사용)
   * @param config - 설정 객체
   * @returns 컨텍스트 초기 상태 객체
   */
  _create_context(config: EdicusInitConfig): Partial<EdicusContext>;
}

/**
 * Edicus SDK v2 초기화 설정
 */
export interface EdicusInitConfig {
  /** 에디터 베이스 URL */
  base_url?: string;
}

// =====================================================
// RedEditorSDK (v6 이상)
// =====================================================

/**
 * RedEditorSDK 초기화 옵션
 */
export interface RedEditorSDKConfig {
  /** API 접근 토큰 (필수) */
  accessToken: string;
  /** 현재 사용자 ID */
  userId?: string;
  /** 사용자 이메일 */
  email?: string;
  /** 직원 코드 */
  staffCode?: string;
  /** 샌드박스/개발 모드 여부 */
  sandboxMode?: boolean | "local";
  /** 에디터 스테이지 초기 URL */
  initialStageUrl?: string;
  /** 부모 토큰 상속 여부 */
  inheritToken?: boolean;
  /** 오류 핸들러 콜백 */
  errorHandler?: (error: SDKError) => void;
  /** i18n 설정 */
  i18n?: Record<string, unknown>;
  /** 기타 옵션 */
  [key: string]: unknown;
}

/**
 * SDK 오류 객체
 * errorHandler 콜백에 전달됩니다.
 */
export interface SDKError extends Error {
  /** 오류 코드 ("001", "002", "003" 등) */
  code?: string;
}

/**
 * 에디터에 전송하는 postMessage 형식
 */
export interface EditorMessage {
  /** 메시지 타겟 ("KOI-SDK" 등) */
  target: string;
  /** 액션 이름 */
  action: string;
  /** 액션에 전달할 정보 */
  info?: Record<string, unknown>;
}

/**
 * 상품 정보
 */
export interface ProductInfo {
  /** 상품 코드 */
  psCode: string;
  /** 상품명 */
  name?: string;
  /** 상품 설명 */
  description?: string;
  /** 상품 썸네일 URL */
  thumbnailUrl?: string;
  /** 기타 상품 속성 */
  [key: string]: unknown;
}

/**
 * 템플릿 정보
 */
export interface Template {
  /** 템플릿 ID */
  id: string;
  /** 템플릿 URL */
  url?: string;
  /** 템플릿 기능/특성 */
  features?: TemplateFeatures;
}

/**
 * 템플릿 기능 정보
 */
export interface TemplateFeatures {
  /** 커스텀 정보 */
  customInfo?: {
    /** 소재 타입 */
    materialType?: string;
    /** 인쇄 영역 */
    printArea?: string[];
    [key: string]: unknown;
  };
  [key: string]: unknown;
}

/**
 * VDP(Variable Data Printing) 변수 매핑
 * 각 변수에 대한 실제 데이터 값을 매핑합니다.
 */
export interface VarMap {
  /** 템플릿 URL 변수 */
  $TMPL?: string;
  /** 상품 코드 변수 */
  $PSCD?: string;
  /** 가격 변수 */
  $PRCE?: number | string;
  /** 기타 VDP 변수 */
  [key: string]: unknown;
}

/**
 * VDP 엔티티 항목
 */
export interface VDPEntity {
  /** 엔티티 ID */
  id?: string;
  /** 엔티티 타입 ("uniform-select" | "individual-select") */
  type?: string;
  /** 변수 매핑 */
  varMap?: VarMap;
  /** 기타 속성 */
  [key: string]: unknown;
}

/**
 * 프로젝트 정보
 */
export interface ProjectInfo {
  /** 프로젝트 ID */
  id: string;
  /** 프로젝트 제목 */
  title?: string;
  /** 상품 코드 */
  psCode?: string;
  /** 생성일 */
  createdAt?: string;
  /** 수정일 */
  updatedAt?: string;
  /** 소유자 ID */
  ownerId?: string;
  /** 기타 속성 */
  [key: string]: unknown;
}

/**
 * 커스텀 탭 설정
 */
export interface CustomTabSettings {
  /** 선택 비교 기준 */
  selectionInfo?: {
    /** 비교 키 ("materialType" | "productCode") */
    compareKey?: string;
  };
  [key: string]: unknown;
}

/**
 * 커스텀 탭 정보
 */
export interface CustomTabInfo {
  /** 엔티티 목록 */
  entities?: VDPEntity[];
  /** 재고 없음 설정 */
  noStocks?: {
    /** 예외 조건 */
    exceptions?: Array<{
      field: string;
      values: string[];
    }>;
    /** 태그 항목 */
    tagItems?: Array<{
      sliceField?: boolean;
      variable: string;
      mappingKey?: string;
      baseField: string;
      range?: [number, number];
      mappingField?: string;
      referenceMappingData?: boolean;
    }>;
  };
  /** 커스텀 탭 설정 */
  settings?: CustomTabSettings;
  /** 동적 항목 */
  dynamicItems?: {
    list?: Array<{
      includeTemplateInfo?: boolean;
      targetItem?: string;
      [key: string]: unknown;
    }>;
  };
  /** 매핑 데이터 */
  mappingData?: Record<string, unknown>;
  [key: string]: unknown;
}

/**
 * SDK 이벤트 타입 목록
 */
export type RedEditorEventType =
  | "close"
  | "request-user-token"
  | "goto-cart"
  | "save"
  | "init"
  | "refreshToken"
  | string;

/**
 * 이벤트 콜백 함수 타입
 */
export type RedEditorEventCallback<T = unknown> = (data?: T) => void;

/**
 * 원격 에디터 명령
 */
export interface RemoteEditorCommand {
  /** 실행할 액션 */
  action: string;
  /** 액션 데이터 */
  data?: Record<string, unknown>;
}

/**
 * RedEditorSDK 메인 클래스
 *
 * Edicus 에디터를 Next.js 등 웹 애플리케이션에 통합하기 위한 SDK입니다.
 * iframe 기반으로 에디터를 로드하며, postMessage를 통해 양방향 통신합니다.
 *
 * @example
 * ```typescript
 * const sdk = new RedEditorSDK({
 *   accessToken: process.env.EDICUS_ACCESS_TOKEN!,
 *   userId: user.id,
 *   sandboxMode: process.env.NODE_ENV !== 'production',
 * });
 *
 * sdk.on('close', () => {
 *   router.push('/');
 * });
 *
 * await sdk.createProject({ psCode: 'PROD001' }, { container: editorRef.current });
 * ```
 */
export declare class RedEditorSDK {
  /**
   * RedEditorSDK 인스턴스를 생성하고 초기화합니다.
   * @param config - SDK 초기화 설정
   */
  constructor(config: RedEditorSDKConfig);

  // ===== 현재 템플릿 관리 =====

  /**
   * 현재 편집 중인 템플릿을 설정합니다. (localStorage에 저장)
   */
  setCurrentTemplate(template: Template): void;

  /**
   * 현재 편집 중인 템플릿을 가져옵니다.
   */
  getCurrentTemplate(): Template;

  // ===== 프로젝트 생성/열기 =====

  /**
   * 새 인쇄 프로젝트를 생성하고 에디터를 엽니다.
   */
  createProject(
    productInfo: { psCode: string; templateId?: string; [key: string]: unknown },
    options?: { container?: HTMLElement; popup?: boolean; [key: string]: unknown },
  ): Promise<void>;

  /**
   * 기존 저장된 프로젝트를 열어 에디터에 로드합니다.
   */
  openProject(
    projectId: string,
    options?: { container?: HTMLElement; [key: string]: unknown },
  ): Promise<void>;

  // ===== 이벤트 시스템 =====

  /**
   * SDK 이벤트 리스너를 등록합니다.
   * @param eventType - 이벤트 타입
   * @param callback - 이벤트 발생 시 실행할 콜백
   */
  on<T = unknown>(
    eventType: RedEditorEventType,
    callback: RedEditorEventCallback<T>,
  ): void;

  /**
   * 에디터 postMessage 이벤트 핸들러 (내부 메서드)
   */
  editorEventHandler(event: MessageEvent): void;

  // ===== VDP(Variable Data Printing) =====

  /**
   * 커스텀 탭의 VDP 엔티티 목록을 가져옵니다.
   * varMap 매핑을 통해 VDP 변수를 실제 데이터에 연결합니다.
   */
  getEntities(
    dataMap: Record<string, unknown[]>,
    templateList: Template[],
  ): VDPEntity[];

  /**
   * 재고 없음(HIDE_YN=Y) 항목에 대한 태그 문자열을 비동기로 가져옵니다.
   */
  getNoStocksInfo(items: Record<string, unknown>[]): Promise<string[]>;

  /**
   * 현재 템플릿의 VDP 항목 목록을 가져옵니다.
   */
  getCurrentTemplateVdpList(): VDPEntity[];

  /**
   * 에디터의 변수 데이터를 설정합니다.
   */
  setVariableData(variableData: Record<string, unknown>): void;

  /**
   * VDP 뷰어를 엽니다.
   */
  openVdpViewer(vdpConfig: Record<string, unknown>): void;

  // ===== 에디터 제어 =====

  /**
   * 에디터를 저장하지 않고 닫습니다.
   */
  close(): void;

  /**
   * 현재 편집 내용을 저장합니다.
   */
  save(): Promise<void>;

  /**
   * 저장 후 에디터를 닫습니다.
   */
  saveThenClose(): Promise<void>;

  /**
   * 에디터 인스턴스를 완전히 제거합니다.
   */
  destroy(): void;

  /**
   * 에디터에 원격 명령을 전송합니다.
   */
  remoteEditor(action: string, data?: Record<string, unknown>): Promise<unknown>;

  /**
   * 여러 원격 명령을 일괄 전송합니다.
   */
  remoteEditorBulk(commands: RemoteEditorCommand[]): Promise<unknown[]>;

  // ===== 프로젝트 조회/관리 =====

  /**
   * 프로젝트 목록을 가져옵니다.
   */
  getProjectList(): Promise<ProjectInfo[]>;

  /**
   * 상품 정보를 가져옵니다.
   */
  getProductInfo(productCode: string): Promise<ProductInfo>;

  /**
   * 프로젝트 썸네일 URL 목록을 가져옵니다.
   */
  getProjectThumbnails(projectId: string): Promise<string[]>;

  /**
   * 인쇄 부수 정보를 가져옵니다.
   */
  getImposeCount(): Promise<Record<string, unknown>>;

  /**
   * 프로젝트를 복제합니다.
   */
  cloneProject(projectId: string): Promise<ProjectInfo>;

  /**
   * 주문 전 준비 작업을 수행합니다.
   */
  prepareOrder(orderInfo: Record<string, unknown>): Promise<Record<string, unknown>>;

  /**
   * 주문 가능 여부를 확인합니다.
   */
  checkOrderable(): Promise<boolean>;

  // ===== 커스텀 탭 =====

  /**
   * 커스텀 탭의 선택 정보를 가져옵니다.
   */
  getCustomTabSelectInfo(params?: Record<string, unknown>): Record<string, unknown>;

  /**
   * 커스텀 탭 전체 정보를 가져옵니다.
   */
  getCustomTabInfo(): CustomTabInfo;

  /**
   * 팔레트 사용 가능 여부를 확인합니다.
   */
  whetherUsePalette(): boolean;

  // ===== 사용자/토큰 관리 =====

  /**
   * 현재 프로젝트 ID를 가져옵니다.
   */
  getProjectId(): string;

  /**
   * 사용자 ID를 설정합니다.
   */
  setUserId(userId: string): Promise<void>;

  /**
   * API 토큰을 업데이트합니다.
   */
  setToken(token: string): void;

  /**
   * 프로젝트 소유자 ID를 가져옵니다.
   */
  getProjectOwnerId(): Promise<string>;

  // ===== 기타 =====

  /**
   * 가격 정보를 에디터에 설정합니다. (varMap.$PRCE에 매핑)
   */
  setPrice(price: number | string): void;

  /**
   * 에디터 스테이지 URL을 변경합니다.
   */
  setEdicusStageUrl(url: string): void;

  /**
   * 커스텀 CSS를 에디터에 적용합니다.
   */
  getCustomCss(css: string): Promise<void>;

  /**
   * 씬(장면) 정보를 가져옵니다.
   */
  getSceneInfo(): Promise<Record<string, unknown>>;

  /**
   * 현재 활성 씬 정보를 가져옵니다.
   */
  getActiveSceneInfo(): Promise<Record<string, unknown>>;
}

// =====================================================
// 전역 타입 선언
// =====================================================

/**
 * window.edicusSDK 전역 객체 타입 (EdicusSDK v2)
 */
declare global {
  interface Window {
    edicusSDK: EdicusSDKV2;
    RedEditorSDK: typeof RedEditorSDK;
  }
}
