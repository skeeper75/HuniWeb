// editor-integration.md §3·4·5 — Edicus from-edicus postMessage 브리지.
// [HARD 보안] origin 검증을 payload 파싱보다 먼저(allowlist). targetOrigin 명시 송신.
// 정규화 경계: goto-cart → NormalizedEditorResult. 위젯은 case 등 미해석(pass-through).
import type { NormalizedEditorConfig, NormalizedEditorResult, SideKey } from '@/contract';

// ── origin allowlist (editor-integration §4) ─────────────────────────────────
// 운영 origin = https://edicusbase.firebaseapp.com [동작분석 §4 라이브 관찰].
// .env.local(EDICUS_BASE_HOST/EDICUS_EDITOR_HOST)에서 BFF 가 init opts 로 주입. 하드코딩 금지 — 기본값은 폴백.
const DEFAULT_ALLOWED_ORIGINS = ['https://edicusbase.firebaseapp.com'];

interface EdicusDocInfo {
  projectID?: string;
  psCode?: string;
  tnUrlList?: string[];
  totalPageCount?: number;
}

// from-edicus 메시지 모양(불투명) — 위젯은 action 분기만 하고 info 는 대부분 그대로 흡수.
interface FromEdicusMessage {
  type?: string; // 'from-edicus'
  action?: string;
  info?: {
    project_id?: string;
    projectID?: string;
    ps_code?: string;
    tnUrlList?: string[];
    totalPageCount?: number;
    page_count?: number; // page-count-changed
    case?: unknown; // [O4] 값 종류 미캡처 — pass-through, 해석 안 함.
    docInfo?: EdicusDocInfo;
    [k: string]: unknown; // prod-var-changed 등 불투명 info echo
  };
}

export interface EditorBridgeCallbacks {
  // request-prod-info 핸드셰이크 응답에 실어 보낼 deferred 파라미터(어댑터/BFF 가 채운 불투명 데이터).
  buildProdInfo(): Record<string, unknown>;
  onProjectId(side: SideKey, projectId: string): void;
  onResult(result: NormalizedEditorResult): void; // goto-cart 정규화 결과
  onClose(side: SideKey): void;
  // 에디터 3액션(MAJOR) — 그 외 ~25 from-edicus 액션은 에디터 내부 UX 라 의도적 미처리.
  //  page-count-changed: 면수 변동 → 가격재계산(불투명 totalPageCount echo).
  onPageCountChanged?(side: SideKey, totalPageCount: number): void;
  //  request-user-token: 에디터가 토큰 갱신 요청 → 호스트/BFF 가 새 토큰을 to-edicus 로 송신.
  onRequestUserToken?(side: SideKey): void;
  //  prod-var-changed: 커스텀탭 변수변경 → 가격재계산(불투명 info echo).
  onProdVarChanged?(side: SideKey, info: Record<string, unknown>): void;
}

// 메시지 리스너를 붙일 대상(기본 window). 테스트에서 가짜 타깃 주입 가능.
export interface MessageTarget {
  addEventListener(type: 'message', cb: (e: MessageEvent) => void): void;
  removeEventListener(type: 'message', cb: (e: MessageEvent) => void): void;
}

export interface EditorBridgeOptions {
  allowedOrigins?: string[]; // BFF 주입(.env). 미지정 시 운영 폴백.
  messageTarget?: MessageTarget; // 기본 window — 테스트 주입용 seam.
}

function parse(data: unknown): FromEdicusMessage | null {
  if (typeof data === 'string') {
    try {
      return JSON.parse(data) as FromEdicusMessage;
    } catch {
      return null;
    }
  }
  if (data && typeof data === 'object') return data as FromEdicusMessage;
  return null;
}

// 한 에디터 세션을 추적하는 브리지. 멀티 인스턴스 시 인스턴스별로 생성하고
// e.source === iframe.contentWindow 로 자기 인스턴스 메시지만 처리(editor-integration §5).
export class EditorBridge {
  private allowed: string[];
  private listener: ((e: MessageEvent) => void) | null = null;
  private iframeWindow: Window | null = null;
  private side: SideKey = 'default';
  private lastDocInfo: EdicusDocInfo | undefined;
  private target: MessageTarget;

  constructor(
    private config: NormalizedEditorConfig,
    private cb: EditorBridgeCallbacks,
    opts?: EditorBridgeOptions,
  ) {
    this.allowed = opts?.allowedOrigins?.length ? opts.allowedOrigins : DEFAULT_ALLOWED_ORIGINS;
    this.side = config.side;
    this.target = opts?.messageTarget ?? (window as unknown as MessageTarget);
  }

  private isAllowedOrigin(o: string): boolean {
    return this.allowed.includes(o);
  }

  // 호스트→에디터 송신 — targetOrigin 명시(editor-integration §4, Red 의 "*" 대비 보안 강화).
  // @MX:WARN [O10] Edicus 가 sandbox/redirect 로 origin 을 바꾸면 송신이 막힐 수 있다.
  // 그 경우 첫 수신 메시지의 e.origin 을 targetOrigin 으로 쓰도록 빌드타임 검증 필요.
  private postToEditor(type: string, action: string, payload: Record<string, unknown>): void {
    if (!this.iframeWindow) return;
    const target = this.allowed[0]; // 명시 origin
    const msg = JSON.stringify({ type, action, info: payload });
    this.iframeWindow.postMessage(msg, target);
  }

  // iframe 마운트 후 호출 — message 리스너 등록 + iframe window 추적.
  attach(iframe: HTMLIFrameElement): void {
    this.iframeWindow = iframe.contentWindow;
    this.listener = (e: MessageEvent) => this.onMessage(e);
    this.target.addEventListener('message', this.listener);
  }

  detach(): void {
    if (this.listener) this.target.removeEventListener('message', this.listener);
    this.listener = null;
    this.iframeWindow = null;
  }

  private onMessage(e: MessageEvent): void {
    // [HARD] ① origin 검증 — 최우선(payload 파싱 전).
    if (!this.isAllowedOrigin(e.origin)) return;
    // ② 인스턴스 라우팅 — 내 iframe 의 메시지만(멀티 인스턴스). source 미상이면 origin 통과로 허용.
    if (this.iframeWindow && e.source && e.source !== this.iframeWindow) return;
    const d = parse(e.data);
    if (!d || d.type !== 'from-edicus') return; // type 필터 [event-contract §4]

    switch (d.action) {
      case 'request-prod-info':
        // deferred-param 핸드셰이크 공개 신호 → send-extra-param 응답.
        this.postToEditor('to-edicus-root', 'send-extra-param', this.cb.buildProdInfo());
        break;
      case 'project-id-created': {
        const pid = d.info?.project_id;
        if (pid) this.cb.onProjectId(this.side, pid);
        break;
      }
      case 'save-doc-report':
        // phase:"end" 의 docInfo 보관 — goto-cart 에서 tnUrlList 누락 시 fallback(라이브 검증된 호스트 동작).
        if (d.info?.docInfo) this.lastDocInfo = d.info.docInfo;
        break;
      case 'goto-cart': {
        const info = d.info ?? {};
        const result: NormalizedEditorResult = {
          side: this.side,
          projectId: info.projectID ?? this.lastDocInfo?.projectID ?? '',
          thumbnailUrls: info.tnUrlList ?? this.lastDocInfo?.tnUrlList ?? [],
          totalPageCount: info.totalPageCount ?? this.lastDocInfo?.totalPageCount ?? 0,
        };
        // case 값은 해석하지 않고 흡수(O4). 정규화 경계에서 종료.
        this.cb.onResult(result);
        break;
      }
      case 'page-count-changed': {
        // 면수 변동 → 가격재계산(불투명 totalPageCount echo). page_count/totalPageCount 둘 중 하나.
        const pc = d.info?.totalPageCount ?? d.info?.page_count;
        if (pc != null) this.cb.onPageCountChanged?.(this.side, pc);
        break;
      }
      case 'request-user-token':
        // 에디터 토큰 갱신 요청 → 호스트/BFF 가 새 토큰 발급해 to-edicus 로 송신.
        this.cb.onRequestUserToken?.(this.side);
        break;
      case 'prod-var-changed':
        // 커스텀탭 변수변경 → 가격재계산(불투명 info echo).
        this.cb.onProdVarChanged?.(this.side, (d.info ?? {}) as Record<string, unknown>);
        break;
      case 'close':
        this.cb.onClose(this.side);
        break;
    }
  }

  // 에디터 iframe src 조립 — editor-integration §1.
  // 토큰은 위젯이 보관하지 않고 즉시 URL 로 전달(메모리 노출 최소화).
  // L-D3-5: cmd 분기 — 신규작업=create / 기존 프로젝트 재편집=open(projectId) / 재구성=reform.
  //  Red 는 진입 의도별로 cmd 를 달리한다. projectId 가 있으면 재편집/재구성 진입.
  buildIframeSrc(
    editorHost: string,
    opts?: { mode?: 'create' | 'edit' | 'reform'; projectId?: string },
  ): string {
    const mode = opts?.mode ?? 'create';
    const cmd = mode === 'edit' ? 'open' : mode === 'reform' ? 'reform' : 'create';
    const u = new URL(`${editorHost}/ed`);
    let hash = `#/editor_landing?cmd=${cmd}&token=${encodeURIComponent(
      this.config.token,
    )}&ps_code=${encodeURIComponent(this.config.psCode)}`;
    // 재편집/재구성은 기존 프로젝트 식별자(projectId)를 URL 로 전달.
    if ((mode === 'edit' || mode === 'reform') && opts?.projectId) {
      hash += `&project_id=${encodeURIComponent(opts.projectId)}`;
    }
    u.hash = hash;
    return u.toString();
  }
}
