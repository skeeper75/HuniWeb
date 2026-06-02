// EditorBridge 단위 테스트 — origin 보안(allowlist) + goto-cart 정규화.
// [HARD] origin 검증이 payload 파싱보다 먼저여야 한다(비허용 origin 은 무시).
// node 환경에서 DOM 없이 검증하기 위해 가짜 MessageTarget + 합성 이벤트를 주입한다(jsdom 미도입 — 단순성).
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { EditorBridge, type MessageTarget } from '@/widget/editor/editor-bridge';
import type { NormalizedEditorConfig, NormalizedEditorResult } from '@/contract';

const config: NormalizedEditorConfig = {
  side: 'default',
  psCode: 'EDICUS_STUB@PRBKYPR',
  templateUrl: 'gcs://x/template.json',
  resourceId: 0,
  token: 'JWT_TOKEN',
  pluginCustomData: { mtrlCode: 'M1' },
};

const ALLOWED = 'https://edicusbase.firebaseapp.com';
const EVIL = 'https://evil.example.com';

// 합성 message 이벤트를 보관·발사하는 가짜 타깃.
class FakeTarget implements MessageTarget {
  private cb: ((e: MessageEvent) => void) | null = null;
  addEventListener(_t: 'message', cb: (e: MessageEvent) => void) {
    this.cb = cb;
  }
  removeEventListener() {
    this.cb = null;
  }
  fire(origin: string, data: unknown, source?: unknown) {
    this.cb?.({ origin, data, source } as unknown as MessageEvent);
  }
}

describe('EditorBridge origin 보안 + 정규화', () => {
  let results: NormalizedEditorResult[];
  let prodInfoCalls: number;
  let closed: number;
  let bridge: EditorBridge;
  let target: FakeTarget;
  const postMessage = vi.fn();
  const fakeWin = { postMessage } as unknown as Window;
  const fakeIframe = { contentWindow: fakeWin } as unknown as HTMLIFrameElement;

  beforeEach(() => {
    results = [];
    prodInfoCalls = 0;
    closed = 0;
    postMessage.mockClear();
    target = new FakeTarget();
    bridge = new EditorBridge(
      config,
      {
        buildProdInfo: () => {
          prodInfoCalls += 1;
          return { ps_code: config.psCode };
        },
        onProjectId: () => {},
        onResult: (r) => results.push(r),
        onClose: () => {
          closed += 1;
        },
      },
      { allowedOrigins: [ALLOWED], messageTarget: target },
    );
    bridge.attach(fakeIframe);
  });

  it('비허용 origin 의 goto-cart 는 무시한다(파싱 전 차단)', () => {
    target.fire(EVIL, JSON.stringify({ type: 'from-edicus', action: 'goto-cart', info: { projectID: 'P1' } }), fakeWin);
    expect(results).toHaveLength(0);
  });

  it('허용 origin 의 goto-cart → NormalizedEditorResult 로 정규화', () => {
    target.fire(
      ALLOWED,
      JSON.stringify({
        type: 'from-edicus',
        action: 'goto-cart',
        info: { projectID: 'P123', tnUrlList: ['t1.png'], totalPageCount: 12, case: 'whatever' },
      }),
      fakeWin,
    );
    expect(results).toHaveLength(1);
    expect(results[0]).toEqual({
      side: 'default',
      projectId: 'P123',
      thumbnailUrls: ['t1.png'],
      totalPageCount: 12,
    });
  });

  it('goto-cart tnUrlList 누락 시 save-doc-report 의 docInfo 로 fallback', () => {
    target.fire(
      ALLOWED,
      JSON.stringify({
        type: 'from-edicus',
        action: 'save-doc-report',
        info: { docInfo: { projectID: 'P9', tnUrlList: ['d.png'], totalPageCount: 5 } },
      }),
      fakeWin,
    );
    target.fire(ALLOWED, JSON.stringify({ type: 'from-edicus', action: 'goto-cart', info: { projectID: 'P9' } }), fakeWin);
    expect(results[0].thumbnailUrls).toEqual(['d.png']);
    expect(results[0].totalPageCount).toBe(5);
  });

  it('다른 인스턴스(e.source 불일치) 메시지는 무시(멀티 인스턴스 라우팅)', () => {
    const otherWin = {} as unknown as Window;
    target.fire(ALLOWED, JSON.stringify({ type: 'from-edicus', action: 'goto-cart', info: { projectID: 'PX' } }), otherWin);
    expect(results).toHaveLength(0);
  });

  it('request-prod-info → send-extra-param 을 명시 origin 으로 송신(targetOrigin != "*")', () => {
    target.fire(ALLOWED, JSON.stringify({ type: 'from-edicus', action: 'request-prod-info', info: {} }), fakeWin);
    expect(prodInfoCalls).toBe(1);
    const call = postMessage.mock.calls[0];
    expect(call[1]).toBe(ALLOWED); // targetOrigin 명시
    expect(call[1]).not.toBe('*');
  });

  it('type !== from-edicus 메시지는 무시', () => {
    target.fire(ALLOWED, JSON.stringify({ type: 'other', action: 'goto-cart', info: { projectID: 'X' } }), fakeWin);
    expect(results).toHaveLength(0);
  });

  it('close → onClose', () => {
    target.fire(ALLOWED, JSON.stringify({ type: 'from-edicus', action: 'close' }), fakeWin);
    expect(closed).toBe(1);
  });

  it('iframe src 조립 — token/ps_code 포함', () => {
    const src = bridge.buildIframeSrc(ALLOWED);
    expect(src).toContain('cmd=create');
    expect(src).toContain(encodeURIComponent(config.token));
    expect(src).toContain(encodeURIComponent(config.psCode));
  });
});
