// Edicus SDK 관련 타입 정의
// SDK v2.0.3 (ref/edicus-dev/edicus-sdk-v2.js) 기반

// SDK 초기화 설정
export interface EdicusConfig {
  // 편집기 베이스 URL (기본값: https://edicusbase.firebaseapp.com)
  base_url: string;
}

// 편집기 컨텍스트 - window.edicusSDK.init() 반환값
export interface EdicusContext {
  // 경로 설정
  base_url: string;
  landing_path: string;      // /ed#/editor_landing
  tnview_path: string;       // /ed#/tnview/landing
  preview_path: string;      // /ed#/preview/landing
  lite_path: string;         // /ed#/lite/landing
  test_path: string;         // /ed#/test/testpage

  // 내부 상태
  target_callback: ((err: null, data: EdicusCallbackData) => void) | null;
  iframe_el: HTMLIFrameElement | null;
  messageListener: ((event: MessageEvent) => void) | null;

  // 지연 파라미터 (iframe 로드 후 편집기가 요청할 때 전달)
  ddp_block: unknown | null;
  private_css: string | null;
  option_string: string | null;
  i18n: unknown | null;
  prod_info: unknown | null;
  options: unknown | null;
  data_row: unknown | null;
  data_feed: unknown | null;
  data_content: unknown | null;
  zoom: unknown | null;
  template_list: unknown | null;

  // 메서드
  close: (params: { parent_element: HTMLElement }) => void;
  destroy: (params: { parent_element: HTMLElement }) => void;
  create_project: (params: CreateProjectParams, callback: EdicusCallback) => void;
  open_project: (params: OpenProjectParams, callback: EdicusCallback) => void;
  edit_template: (params: EditTemplateParams, callback: EdicusCallback) => void;
  create_design_project: (params: CreateDesignProjectParams, callback: EdicusCallback) => void;
  open_design_project: (params: OpenProjectParams, callback: EdicusCallback) => void;
  recycle_project: (params: RecycleProjectParams, callback: EdicusCallback) => void;
  reform_project: (params: ReformProjectParams, callback: EdicusCallback) => void;
  fit_project: (params: FitProjectParams, callback: EdicusCallback) => void;
  open_preview: (params: OpenPreviewParams, callback: EdicusCallback) => void;
  show_tnview: (params: TnviewParams, callback: EdicusCallback) => void;
  create_tnview: (params: TnviewParams, callback: EdicusCallback) => void;
  open_tnview: (params: OpenTnviewParams, callback: EdicusCallback) => void;
  show_gallery: (params: ShowGalleryParams, callback: EdicusCallback) => void;
  create_lite_project: (params: LiteProjectParams, callback: EdicusCallback) => void;
  open_lite_project: (params: OpenLiteProjectParams, callback: EdicusCallback) => void;
  show_lite_editor: (params: LiteProjectParams, callback: EdicusCallback) => void;
  change_project: (projectId: string) => void;
  change_template: (psCode: string, template_uri: string) => void;
  change_template_v2: (option: ChangeTemplateV2Option) => void;
  execute_ddp_block: (ddp_block: unknown, history_label: string) => void;
  post_to_editor: (action: string, info: unknown) => void;
  post_to_tnview: (action: string, info: unknown) => void;
  post_to_preview: (action: string, info: unknown) => void;
}

// SDK 콜백 타입
export type EdicusCallback = (err: null, data: EdicusCallbackData) => void;

// 편집기에서 수신되는 콜백 데이터
export interface EdicusCallbackData {
  // from-edicus-* 타입 메시지 (from-edicus-private 제외)
  type: string;
  action?: string;
  info?: EdicusCallbackInfo;
}

// 콜백 info 페이로드
export interface EdicusCallbackInfo {
  // 프로젝트 관련
  project_id?: string;
  prjid?: string;

  // 상태 관련
  status?: ProjectStatus;

  // 토큰 관련 (request-user-token 이벤트)
  uid?: string;

  // 기타 동적 데이터
  [key: string]: unknown;
}

// 프로젝트 상태
// - editing: 편집 중 (잠정주문 전)
// - ordering: 잠정주문 완료 (취소 가능, 편집 불가)
// - ordered: 확정주문 완료 (취소 불가, 인쇄파일 렌더링 시작)
export type ProjectStatus = 'editing' | 'ordering' | 'ordered';

// 공통 URL 파라미터 (편집기 iframe URL에 추가)
export interface EdicusCommonUrlParams {
  // 환경 설정
  partner?: string;           // 파트너 코드 (예: hunip)
  mobile?: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja'; // 템플릿 언어
  ui_locale?: 'ko' | 'en' | 'ja'; // UI 언어
  editor_type?: 'template' | 'print';
  ui_style?: 'tab-less' | 'tab-top-less';
  parent_type?: string;       // .. / web_in_app
  env_mode?: string;          // .. / dev / demo
  run_mode?: string;          // .. / passive

  // 페이지 제어
  num_page?: number;
  max_page?: number;
  min_page?: number;
  max_order?: number;
  min_order?: number;

  // 편집 제어
  force_plugin?: string;
  plugin_param?: string;
  resapi_param?: string;
  unlayers?: string;
  edit_lock?: string;         // edit-group / set-strict-color / no-font-preview
  no_update?: string;
  clear_src?: string;
  cal_date?: string;
  video_frames?: string;

  // 지연 파라미터 (서버에서 처리 후 편집기에 전달)
  ddp_block?: unknown;
  private_css?: string;
  prod_info?: unknown;
  options?: unknown;
  option_string?: string;

  // 개발용
  dev_apiHost?: string;
  dev_assetHost?: string;
  dev_uploadHost?: string;
  dev_resHost?: string;

  // 공통 필수
  parent_element: HTMLElement;
}

// 프로젝트 생성 파라미터
export interface CreateProjectParams extends EdicusCommonUrlParams {
  token: string;
  ps_code: string;            // 상품 코드
  title: string;
  ps_code_param?: string;
  template_uri?: string;
  content_uri?: string;
}

// 프로젝트 열기 파라미터
export interface OpenProjectParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;              // 프로젝트 ID
  ps_code?: string;
}

// 템플릿 편집 파라미터
export interface EditTemplateParams extends EdicusCommonUrlParams {
  token: string;
  ps_code: string;
  prjid?: string;
  template_uri?: string;
  content_uri?: string;
}

// 디자인 프로젝트 생성 파라미터
export interface CreateDesignProjectParams extends EdicusCommonUrlParams {
  token: string;
  ps_code: string;
  title: string;
  template_uri?: string;
}

// 프로젝트 재활용 파라미터
export interface RecycleProjectParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;
  title: string;
}

// 프로젝트 개편 파라미터
export interface ReformProjectParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;
  ps_code: string;
}

// 프로젝트 피팅 파라미터
export interface FitProjectParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;
  ps_code: string;
  base_template_uri: string;
  content_overwrite?: string;
}

// 미리보기 열기 파라미터
export interface OpenPreviewParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;
  partner: string;
  uid: string;
  ps_code?: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja';
  npage?: number;
  flow?: 'horizontal' | 'vertical';
  mode?: string;
  data_row?: unknown;
  zoom?: unknown;
}

// 썸네일 뷰어 파라미터
export interface TnviewParams extends EdicusCommonUrlParams {
  token: string;
  ps_code: string;
  template_uri: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja';
  npage?: number;
  flow?: 'horizontal' | 'vertical';
  rotate?: boolean;
  show3d?: boolean;
}

// 프로젝트 기반 썸네일 뷰어 파라미터
export interface OpenTnviewParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;
  ps_code?: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja';
  npage?: number;
  flow?: 'horizontal' | 'vertical';
  rotate?: boolean;
  show3d?: boolean;
}

// 갤러리 표시 파라미터
export interface ShowGalleryParams extends EdicusCommonUrlParams {
  partner: string;
  token: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja';
  show_guide?: boolean;
  data_feed?: unknown;
  data_content?: unknown;
}

// 라이트 프로젝트 생성/표시 파라미터
export interface LiteProjectParams extends EdicusCommonUrlParams {
  token: string;
  ps_code: string;
  template_uri: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja';
  uilocale?: 'ko' | 'en' | 'ja';
  core_size_mm?: string;
  size_type?: string;
  round_mm?: string;
  num_page?: number;
  edit_lock?: string;
  i18n?: unknown;
}

// 라이트 프로젝트 열기 파라미터
export interface OpenLiteProjectParams extends EdicusCommonUrlParams {
  token: string;
  prjid: string;
  ps_code?: string;
  div?: string;
  lang?: 'ko' | 'en' | 'ja';
  uilocale?: 'ko' | 'en' | 'ja';
  edit_lock?: string;
  i18n?: unknown;
}

// 템플릿 변경 v2 옵션
export interface ChangeTemplateV2Option {
  psCode: string;
  template_uri: string;
  content_uri?: string;
  command?: string;
}

// Edicus 프로젝트 모델 (서버 API /api/projects 응답)
export interface EdicusProject {
  project_id: string;         // 프로젝트 고유 ID
  status: ProjectStatus;
  created_at: string;         // ISO 8601
  updated_at: string;
}

// 미리보기 URL 응답 (/api/projects/:id/preview_urls)
export interface PreviewUrlsResponse {
  urls: string[];
}

// 서버 API 토큰 응답 (/api/auth/token)
export interface TokenResponse {
  token: string;              // 편집기 iframe에 전달할 토큰
  expires_at?: string;        // ISO 8601
}

// Edicus API 공통 응답 래퍼
export interface EdicusApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

// Edicus 템플릿 모델 (Resource API /resapi/query, /resapi/resource/:id 응답)
export interface EdicusTemplate {
  resource_id: string;       // 리소스 고유 ID
  title: string;             // 템플릿 이름
  ps_code: string;           // 상품 코드
  template_uri: string;      // 템플릿 URI
  category?: string;         // 카테고리 코드
  thumbnail_url?: string;    // 썸네일 URL
  [key: string]: unknown;    // 추가 동적 필드
}

// Edicus 상품 모델 (Resource API /resapi/product/list 응답)
export interface EdicusProduct {
  ps_code: string;           // 상품 코드
  title: string;             // 상품 이름
  category: string;          // 카테고리
  [key: string]: unknown;    // 추가 동적 필드
}

// 리소스 API 쿼리 옵션
export interface QueryOptions {
  category?: string;         // 카테고리 필터
  page?: number;             // 페이지 번호
  limit?: number;            // 페이지 당 항목 수
  [key: string]: unknown;    // 추가 필터 옵션
}

// 글로벌 window.edicusSDK 타입은 red-editor-sdk.d.ts에서 EdicusSDKV2로 선언됨
// 여기서는 중복 선언하지 않음
