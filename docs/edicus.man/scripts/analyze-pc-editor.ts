/**
 * 레드프린팅 PC 상품 페이지 분석
 * 목표:
 * 1. Shadow DOM (#redWidgetSdk) 구조 전체 문서화
 * 2. "에디터" 탭 버튼 및 "편집하기" / "무료 디자인으로 편집하기" 버튼 탐색
 * 3. 에디터 실행 흐름 - postMessage, SDK 초기화, iframe URL + run_mode 파라미터
 * 4. 네트워크 요청 캡처 (/api/editor/config/KOI, Firebase 토큰 등)
 * 5. window 객체 SDK 탐색 (RedEditorSDK, edicusSDK, sdkInit, sdkOpenEditor 등)
 * 6. Passive mode 감지 (run_mode, hideToolbar 등)
 */
import { chromium, Page, BrowserContext } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

// .env.local 로드
const envPath = path.join(__dirname, '..', '.env.local');
const ENV: Record<string, string> = {};
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf-8');
  for (const line of envContent.split('\n')) {
    const t = line.trim();
    if (!t || t.startsWith('#')) continue;
    const i = t.indexOf('=');
    if (i > 0) ENV[t.slice(0, i)] = t.slice(i + 1);
  }
}

const TARGET_URL = 'https://www.redprinting.co.kr/ko/product/item/PR/PRBKYPR';
const OUT = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-PASSIVE-001', 'analysis');
fs.mkdirSync(OUT, { recursive: true });

function log(msg: string): void {
  const ts = new Date().toLocaleTimeString('ko-KR');
  console.log(`[${ts}] ${msg}`);
}

async function screenshot(page: Page, name: string): Promise<void> {
  const filePath = path.join(OUT, `pc-${name}.png`);
  await page.screenshot({ path: filePath, fullPage: false });
  log(`스크린샷 저장: pc-${name}.png`);
}

async function waitMs(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Shadow DOM 전체 트리를 재귀적으로 직렬화
function serializeShadowTree(element: Element): Record<string, unknown> {
  const result: Record<string, unknown> = {
    tag: element.tagName.toLowerCase(),
    id: element.id || undefined,
    className: element.className || undefined,
    attributes: {} as Record<string, string>,
    children: [] as unknown[],
    shadowRoot: null as unknown,
    textContent: element.childElementCount === 0
      ? (element.textContent || '').trim().slice(0, 100) || undefined
      : undefined,
  };

  // 속성 수집
  for (let i = 0; i < element.attributes.length; i++) {
    const attr = element.attributes[i];
    (result.attributes as Record<string, string>)[attr.name] = attr.value.slice(0, 200);
  }

  // 자식 요소
  for (const child of Array.from(element.children)) {
    (result.children as unknown[]).push(serializeShadowTree(child));
  }

  // Shadow DOM
  if (element.shadowRoot) {
    const shadowChildren: unknown[] = [];
    for (const child of Array.from(element.shadowRoot.children)) {
      shadowChildren.push(serializeShadowTree(child));
    }
    result.shadowRoot = { mode: 'open', children: shadowChildren };
  }

  return result;
}

async function setupInterceptors(ctx: BrowserContext): Promise<void> {
  // postMessage, SDK, iframe src 인터셉션 스크립트
  await ctx.addInitScript(function () {
    (window as unknown as Record<string, unknown>).__pcLog = [];
    (window as unknown as Record<string, unknown>).__pmLog = [];
    (window as unknown as Record<string, unknown>).__iframeCreations = [];
    (window as unknown as Record<string, unknown>).__sdkInitCalls = [];
    (window as unknown as Record<string, unknown>).__bridgeFunctions = {};

    // postMessage 양방향 캡처
    const _origPM = window.postMessage;
    window.postMessage = function (msg: unknown, target: unknown, tr?: unknown) {
      try {
        const entry = { origin: location.origin, data: msg, ts: Date.now(), dir: 'out' };
        (window as unknown as Record<string, unknown[]>).__pmLog.push(entry);
        if (typeof msg === 'object' && msg !== null) {
          console.log('[PM_OUT]', JSON.stringify(msg).slice(0, 800));
        }
      } catch { /* ignore */ }
      return _origPM.call(window, msg, target as string, tr as Transferable[]);
    };

    window.addEventListener('message', function (e: MessageEvent) {
      try {
        const entry = { origin: e.origin, data: e.data, ts: Date.now(), dir: 'in' };
        (window as unknown as Record<string, unknown[]>).__pmLog.push(entry);
        if (typeof e.data === 'object' && e.data !== null) {
          console.log('[PM_IN]', JSON.stringify(e.data).slice(0, 800));
        }
      } catch { /* ignore */ }
    });

    // iframe src 인터셉션 (setAttribute 경유)
    const origSetAttr = Element.prototype.setAttribute;
    Element.prototype.setAttribute = function (name: string, value: string) {
      if (name === 'src' && this.tagName === 'IFRAME') {
        console.log('[IFRAME_SETATTR_SRC]', value.slice(0, 800));
        (window as unknown as Record<string, unknown[]>).__iframeCreations.push({
          src: value,
          ts: Date.now(),
          method: 'setAttribute',
        });
      }
      return origSetAttr.call(this, name, value);
    };

    // iframe.src 프로퍼티 직접 할당 인터셉션
    const origSrcDesc = Object.getOwnPropertyDescriptor(HTMLIFrameElement.prototype, 'src');
    if (origSrcDesc?.set) {
      const origSet = origSrcDesc.set;
      Object.defineProperty(HTMLIFrameElement.prototype, 'src', {
        get: origSrcDesc.get,
        set: function (val: string) {
          console.log('[IFRAME_SRC_PROP]', val.slice(0, 800));
          (window as unknown as Record<string, unknown[]>).__iframeCreations.push({
            src: val,
            ts: Date.now(),
            method: 'property',
          });
          origSet.call(this, val);
        },
        configurable: true,
      });
    }

    // RedWidgetSDK 인터셉션
    let _rwSDK: unknown;
    Object.defineProperty(window, 'RedWidgetSDK', {
      get: function () { return _rwSDK; },
      set: function (val: unknown) {
        _rwSDK = val;
        console.log('[SDK_SET] RedWidgetSDK', typeof val);
        if (val && typeof val === 'function') {
          const fn = val as { prototype?: Record<string, unknown> };
          if (fn.prototype) {
            const methods = Object.getOwnPropertyNames(fn.prototype);
            console.log('[WIDGET_SDK_PROTO]', JSON.stringify(methods));
            // init 인터셉션
            const origInit = fn.prototype.init;
            if (typeof origInit === 'function') {
              fn.prototype.init = function (options: unknown, callbacks: unknown) {
                console.log('[WIDGET_SDK_INIT]', JSON.stringify(options).slice(0, 600));
                (window as unknown as Record<string, unknown[]>).__sdkInitCalls.push({ options, ts: Date.now() });
                const result = (origInit as Function).call(this, options, callbacks);
                (window as unknown as Record<string, unknown>).__widgetSdkInstance = result;
                return result;
              };
            }
          }
        }
      },
      configurable: true,
    });

    // RedEditorSDK 인터셉션
    let _reSDK: unknown;
    Object.defineProperty(window, 'RedEditorSDK', {
      get: function () { return _reSDK; },
      set: function (val: unknown) {
        _reSDK = val;
        console.log('[EDITOR_SDK_SET] RedEditorSDK', typeof val);
        if (val && typeof val === 'function') {
          const fn = val as { prototype?: Record<string, unknown> };
          if (fn.prototype) {
            const proto = Object.getOwnPropertyNames(fn.prototype);
            console.log('[EDITOR_SDK_PROTO]', JSON.stringify(proto));
            // createProject 인터셉션
            const origCreate = fn.prototype.createProject;
            if (typeof origCreate === 'function') {
              fn.prototype.createProject = function (...args: unknown[]) {
                console.log('[CREATE_PROJECT]', JSON.stringify(args).slice(0, 800));
                (window as unknown as Record<string, unknown[]>).__sdkInitCalls.push({
                  method: 'createProject',
                  args,
                  ts: Date.now(),
                });
                return (origCreate as Function).apply(this, args);
              };
            }
            // openProject 인터셉션
            const origOpen = fn.prototype.openProject;
            if (typeof origOpen === 'function') {
              fn.prototype.openProject = function (...args: unknown[]) {
                console.log('[OPEN_PROJECT]', JSON.stringify(args).slice(0, 800));
                (window as unknown as Record<string, unknown[]>).__sdkInitCalls.push({
                  method: 'openProject',
                  args,
                  ts: Date.now(),
                });
                return (origOpen as Function).apply(this, args);
              };
            }
          }
        }
        (window as unknown as Record<string, unknown>).__redEditorSDK = val;
      },
      configurable: true,
    });

    // edicusSDK 인터셉션
    let _edicusSDK: unknown;
    Object.defineProperty(window, 'edicusSDK', {
      get: function () { return _edicusSDK; },
      set: function (val: unknown) {
        _edicusSDK = val;
        console.log('[EDICUS_SDK_SET]', typeof val);
        if (val && typeof val === 'object') {
          const keys = Object.keys(val as object);
          console.log('[EDICUS_SDK_KEYS]', JSON.stringify(keys));
        }
        (window as unknown as Record<string, unknown>).__edicusSDK = val;
      },
      configurable: true,
    });

    // 브리지 함수 감지 (sdkInit, sdkOpenEditor 등)
    const bridgeNames = ['sdkInit', 'sdkOpenEditor', 'openEditor', 'initEditor', 'launchEditor'];
    for (const fnName of bridgeNames) {
      const existing = (window as unknown as Record<string, unknown>)[fnName];
      if (typeof existing === 'function') {
        const orig = existing;
        (window as unknown as Record<string, unknown>)[fnName] = function (...args: unknown[]) {
          console.log(`[BRIDGE_FN] ${fnName}`, JSON.stringify(args).slice(0, 500));
          (window as unknown as Record<string, Record<string, unknown[]>>).__bridgeFunctions[fnName] = args;
          return (orig as Function).apply(window, args);
        };
      }
    }
  });
}

async function captureNetworkRequests(
  ctx: BrowserContext,
  networkCaptures: Array<{ url: string; status: number; body: unknown; type: string }>
): Promise<void> {
  // widget-api 캡처
  await ctx.route('**/*widget-api*/**', async (route) => {
    const response = await route.fetch();
    try {
      const body = await response.json().catch(() => null);
      const req = route.request();
      networkCaptures.push({ url: req.url(), status: response.status(), body, type: 'widget-api' });
      log(`widget-api: ${req.url()} → ${JSON.stringify(body)?.slice(0, 300)}`);
    } catch { /* ignore */ }
    await route.fulfill({ response });
  });

  // Firebase 토큰 교환 캡처
  await ctx.route('**/*securetoken.googleapis*/**', async (route) => {
    const req = route.request();
    const response = await route.fetch();
    try {
      const body = await response.json().catch(() => null);
      networkCaptures.push({ url: req.url(), status: response.status(), body: { ...body, idToken: '[REDACTED]', refreshToken: '[REDACTED]' }, type: 'firebase-token' });
      log(`Firebase 토큰: ${req.url()}`);
    } catch { /* ignore */ }
    await route.fulfill({ response });
  });

  // 에디터 iframe 관련 캡처
  await ctx.route('**/*edicus*/**', async (route) => {
    const req = route.request();
    networkCaptures.push({ url: req.url(), status: 0, body: null, type: 'edicus-request' });
    log(`Edicus 요청: ${req.url().slice(0, 200)}`);
    await route.continue();
  });
}

async function exploreShadowDOM(page: Page): Promise<Record<string, unknown>> {
  log('Shadow DOM 분석 시작...');

  // page.evaluate에 전달되는 함수는 브라우저 컨텍스트에서 실행됨
  // 내부 함수 참조를 피해야 __name 에러가 발생하지 않음
  return await page.evaluate(function () {
    var widgetEl = document.querySelector('#redWidgetSdk');
    if (!widgetEl) {
      return { found: false, error: '#redWidgetSdk not found' };
    }

    var result = {
      found: true,
      hasShadowRoot: !!widgetEl.shadowRoot,
      shadowRootHTML: '',
      buttons: [] as Array<Record<string, string>>,
      tabs: [] as Array<Record<string, string>>,
      editButtons: [] as Array<Record<string, string>>,
      iframes: [] as Array<Record<string, string>>,
      tree: [] as unknown[],
      error: '',
      outerHTML: '',
    };

    if (!widgetEl.shadowRoot) {
      result.error = 'shadowRoot is null (closed mode or not attached)';
      result.outerHTML = widgetEl.outerHTML.slice(0, 1000);
      return result;
    }

    // Shadow DOM 내부 HTML
    result.shadowRootHTML = widgetEl.shadowRoot.innerHTML.slice(0, 5000);

    // 버튼들 탐색
    var shadowButtons = widgetEl.shadowRoot.querySelectorAll('button, a[role="button"], [class*="btn"], [class*="tab"]');
    for (var i = 0; i < shadowButtons.length; i++) {
      var btn = shadowButtons[i];
      var dataAttrs = {};
      for (var j = 0; j < btn.attributes.length; j++) {
        var a = btn.attributes[j];
        if (a.name.indexOf('data-') === 0) {
          (dataAttrs as Record<string, string>)[a.name] = a.value;
        }
      }
      result.buttons.push({
        tag: btn.tagName.toLowerCase(),
        text: (btn.textContent || '').trim().slice(0, 100),
        className: btn.className,
        id: (btn as HTMLElement).id,
        type: (btn as HTMLButtonElement).type || '',
        dataAttrs: JSON.stringify(dataAttrs),
      });
    }

    // 탭 구조 탐색
    var tabEls = widgetEl.shadowRoot.querySelectorAll('[role="tab"], [class*="tab"]');
    for (var ti = 0; ti < tabEls.length; ti++) {
      var tab = tabEls[ti];
      result.tabs.push({
        tag: tab.tagName.toLowerCase(),
        text: (tab.textContent || '').trim().slice(0, 100),
        className: tab.className,
        ariaSelected: (tab as HTMLElement).getAttribute('aria-selected') || '',
      });
    }

    // 편집하기 버튼 특정 탐색
    var allEls = widgetEl.shadowRoot.querySelectorAll('*');
    for (var ei = 0; ei < allEls.length; ei++) {
      var el = allEls[ei];
      var elText = (el.textContent || '').trim();
      if (
        (elText.includes('편집하기') ||
         elText.includes('무료 디자인') ||
         elText.includes('에디터') ||
         elText.includes('디자인 편집')) &&
        el.children.length === 0
      ) {
        result.editButtons.push({
          tag: el.tagName.toLowerCase(),
          text: elText.slice(0, 200),
          className: el.className,
          id: (el as HTMLElement).id,
          parentTag: (el.parentElement ? el.parentElement.tagName : '').toLowerCase(),
          parentClass: el.parentElement ? el.parentElement.className : '',
        });
      }
    }

    // iframe 탐색
    var iframeEls = widgetEl.shadowRoot.querySelectorAll('iframe');
    for (var ii = 0; ii < iframeEls.length; ii++) {
      var iframe = iframeEls[ii];
      result.iframes.push({
        src: iframe.src,
        id: iframe.id,
        className: iframe.className,
        name: iframe.name,
      });
    }

    // 트리 구조 (단순 버전 - 중첩 함수 없이)
    var rootChildren = widgetEl.shadowRoot.children;
    for (var ri = 0; ri < rootChildren.length; ri++) {
      var rootChild = rootChildren[ri];
      var node = {
        tag: rootChild.tagName.toLowerCase(),
        id: rootChild.id || '',
        class: rootChild.className || '',
        childCount: rootChild.children.length,
        children: [] as unknown[],
      };
      // 1단계 자식만
      for (var ci = 0; ci < rootChild.children.length; ci++) {
        var c1 = rootChild.children[ci];
        var n1 = {
          tag: c1.tagName.toLowerCase(),
          id: c1.id || '',
          class: c1.className || '',
          childCount: c1.children.length,
          children: [] as unknown[],
        };
        // 2단계 자식
        for (var ci2 = 0; ci2 < c1.children.length; ci2++) {
          var c2 = c1.children[ci2];
          n1.children.push({
            tag: c2.tagName.toLowerCase(),
            id: c2.id || '',
            class: c2.className || '',
            childCount: c2.children.length,
            text: c2.children.length === 0 ? (c2.textContent || '').trim().slice(0, 80) : '',
          });
        }
        node.children.push(n1);
      }
      result.tree.push(node);
    }

    return result;
  });
}

async function exploreWindowSDKs(page: Page): Promise<Record<string, unknown>> {
  log('Window SDK 객체 탐색...');

  return await page.evaluate(function () {
    var result: Record<string, unknown> = {};

    // RedEditorSDK
    var reSDK = (window as unknown as Record<string, unknown>).RedEditorSDK;
    if (reSDK) {
      result.RedEditorSDK = {
        type: typeof reSDK,
        ownKeys: Object.keys(reSDK as object),
        protoMethods: reSDK && typeof reSDK === 'function'
          ? Object.getOwnPropertyNames((reSDK as { prototype?: object }).prototype || {})
          : [],
      };
    } else {
      result.RedEditorSDK = null;
    }

    // edicusSDK
    var eSDK = (window as unknown as Record<string, unknown>).edicusSDK;
    if (eSDK) {
      var eKeys = Object.keys(eSDK as object);
      var eMethods = eKeys.filter(function (k) {
        return typeof (eSDK as Record<string, unknown>)[k] === 'function';
      });
      result.edicusSDK = { type: typeof eSDK, keys: eKeys, methods: eMethods };
    } else {
      result.edicusSDK = null;
    }

    // RedWidgetSDK
    var rwSDK = (window as unknown as Record<string, unknown>).RedWidgetSDK;
    if (rwSDK) {
      result.RedWidgetSDK = {
        type: typeof rwSDK,
        ownKeys: Object.keys(rwSDK as object),
        protoMethods: rwSDK && typeof rwSDK === 'function'
          ? Object.getOwnPropertyNames((rwSDK as { prototype?: object }).prototype || {})
          : [],
      };
    } else {
      result.RedWidgetSDK = null;
    }

    // 브리지 함수들
    var bridgeNames = ['sdkInit', 'sdkOpenEditor', 'openEditor', 'initEditor', 'launchEditor'];
    var bridgeFunctions: Record<string, string> = {};
    for (var bi = 0; bi < bridgeNames.length; bi++) {
      var bName = bridgeNames[bi];
      var fn = (window as unknown as Record<string, unknown>)[bName];
      bridgeFunctions[bName] = fn ? typeof fn : 'not found';
    }
    result.bridgeFunctions = bridgeFunctions;

    // intercepted data
    result.intercepted = {
      pmLog: (window as unknown as Record<string, unknown[]>).__pmLog || [],
      iframeCreations: (window as unknown as Record<string, unknown[]>).__iframeCreations || [],
      sdkInitCalls: (window as unknown as Record<string, unknown[]>).__sdkInitCalls || [],
      bridgeFunctionCalls: (window as unknown as Record<string, unknown>).__bridgeFunctions || {},
    };

    return result;
  });
}

async function tryClickEditorButton(page: Page): Promise<{ clicked: boolean; buttonText: string; method: string }> {
  log('에디터 버튼 클릭 시도...');

  // 방법 1: Shadow DOM 내부 버튼 직접 클릭
  const result = await page.evaluate(function () {
    var widgetEl = document.querySelector('#redWidgetSdk');
    if (!widgetEl || !widgetEl.shadowRoot) return { found: false, text: '', tag: '', type: '' };

    var allEls = widgetEl.shadowRoot.querySelectorAll('*');
    for (var i = 0; i < allEls.length; i++) {
      var el = allEls[i];
      var text = (el.textContent || '').trim();
      if ((text.includes('편집하기') || text.includes('무료 디자인')) && el.children.length === 0) {
        var clickable = el.closest('button') || el.closest('a') || el;
        (clickable as HTMLElement).click();
        return { found: true, text: text, tag: (clickable as HTMLElement).tagName, type: 'edit-button' };
      }
    }

    // 에디터 탭 찾기
    var tabEls = widgetEl.shadowRoot.querySelectorAll('[role="tab"], [class*="tab"]');
    for (var ti = 0; ti < tabEls.length; ti++) {
      var tab = tabEls[ti];
      var tabText = (tab.textContent || '').trim();
      if (tabText.includes('에디터') || tabText.includes('편집')) {
        (tab as HTMLElement).click();
        return { found: true, text: tabText, tag: tab.tagName, type: 'tab' };
      }
    }

    // 버튼 전체 순회
    var buttons = widgetEl.shadowRoot.querySelectorAll('button');
    if (buttons.length > 0) {
      var btn = buttons[buttons.length - 1];
      var btnText = (btn.textContent || '').trim();
      (btn as HTMLElement).click();
      return { found: true, text: btnText, tag: 'button', type: 'last-button' };
    }

    return { found: false, text: '', tag: '', type: '' };
  });

  if (result.found) {
    return { clicked: true, buttonText: (result as Record<string, unknown>).text as string, method: 'shadow-dom-direct' };
  }

  // 방법 2: Playwright locator로 시도
  try {
    const locator = page.getByText('편집하기', { exact: false });
    if (await locator.count() > 0) {
      await locator.first().click({ timeout: 5000 });
      return { clicked: true, buttonText: '편집하기', method: 'playwright-locator' };
    }
  } catch { /* ignore */ }

  try {
    const locator = page.getByText('무료 디자인으로 편집하기', { exact: false });
    if (await locator.count() > 0) {
      await locator.first().click({ timeout: 5000 });
      return { clicked: true, buttonText: '무료 디자인으로 편집하기', method: 'playwright-locator' };
    }
  } catch { /* ignore */ }

  return { clicked: false, buttonText: '', method: 'none' };
}

async function main(): Promise<void> {
  log('=== 레드프린팅 PC 에디터 페이지 분석 시작 ===');
  log(`대상 URL: ${TARGET_URL}`);
  log(`출력 경로: ${OUT}`);

  const browser = await chromium.launch({
    headless: true,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-web-security',
      '--disable-features=VizDisplayCompositor',
    ],
  });

  const networkCaptures: Array<{ url: string; status: number; body: unknown; type: string }> = [];
  const consoleMessages: Array<{ type: string; text: string; ts: number }> = [];

  const ctx = await browser.newContext({
    // PC 데스크탑 뷰포트
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
    viewport: { width: 1920, height: 1080 },
    isMobile: false,
    hasTouch: false,
    locale: 'ko-KR',
    timezoneId: 'Asia/Seoul',
  });

  await setupInterceptors(ctx);
  await captureNetworkRequests(ctx, networkCaptures);

  const page = await ctx.newPage();

  // 콘솔 로그 캡처
  page.on('console', (msg) => {
    const text = msg.text();
    const entry = { type: msg.type(), text: text.slice(0, 1000), ts: Date.now() };
    consoleMessages.push(entry);

    if (
      text.startsWith('[SDK') ||
      text.startsWith('[PM') ||
      text.startsWith('[IFRAME') ||
      text.startsWith('[EDITOR') ||
      text.startsWith('[WIDGET') ||
      text.startsWith('[BRIDGE') ||
      text.startsWith('[CREATE') ||
      text.startsWith('[OPEN') ||
      text.startsWith('[EDICUS') ||
      text.includes('run_mode') ||
      text.includes('passive') ||
      text.includes('hideToolbar') ||
      text.includes('edicus') ||
      text.includes('RedEditor')
    ) {
      log(`콘솔: ${text.slice(0, 600)}`);
    }
  });

  page.on('pageerror', (err) => {
    log(`페이지 에러: ${err.message.slice(0, 200)}`);
  });

  const result: Record<string, unknown> = {
    timestamp: new Date().toISOString(),
    targetUrl: TARGET_URL,
    viewport: { width: 1920, height: 1080 },
    userAgent: 'Chrome Windows Desktop',
  };

  try {
    // 1. 로그인
    log('\n[STEP 1] PC 로그인 페이지 이동...');
    await page.goto('https://www.redprinting.co.kr/member/login', {
      waitUntil: 'networkidle',
      timeout: 30000,
    });
    await screenshot(page, '01-login-page');

    if (ENV.REDPRINTING_USERNAME && ENV.REDPRINTING_PASSWORD) {
      log('로그인 시도...');
      // PC 로그인 폼 셀렉터 (모바일과 다를 수 있음)
      const idField = page.locator('#mb_id, input[name="mb_id"], input[type="email"], input[placeholder*="아이디"]').first();
      const pwField = page.locator('#password, input[name="password"], input[type="password"]').first();

      if (await idField.count() > 0) {
        await idField.fill(ENV.REDPRINTING_USERNAME);
        await pwField.fill(ENV.REDPRINTING_PASSWORD);
        await screenshot(page, '02-login-filled');

        const loginBtn = page.locator('button:has-text("로그인"), input[type="submit"][value*="로그인"]').first();
        if (await loginBtn.count() > 0) {
          await loginBtn.click();
          await page.waitForTimeout(3000);
          await page.waitForLoadState('networkidle').catch(() => {});
          log('로그인 완료');
          await screenshot(page, '03-after-login');
        }
      } else {
        log('로그인 폼을 찾지 못했습니다.');
        result.loginError = 'Login form not found';
      }
    } else {
      log('환경변수 없음 - 비로그인 상태로 진행');
      result.loginSkipped = true;
    }

    // 2. 상품 페이지 이동
    log(`\n[STEP 2] 상품 페이지 이동: ${TARGET_URL}`);
    await page.goto(TARGET_URL, {
      waitUntil: 'networkidle',
      timeout: 45000,
    });
    await screenshot(page, '04-product-page');

    // 페이지 기본 정보
    result.pageTitle = await page.title();
    result.pageUrl = page.url();
    log(`페이지 제목: ${result.pageTitle}`);

    // 3. RedWidgetSDK 로드 대기
    log('\n[STEP 3] RedWidgetSDK 로드 대기...');
    let widgetLoaded = false;
    for (let i = 0; i < 10; i++) {
      await waitMs(2000);
      const loaded = await page.evaluate(function () {
        return !!(window as unknown as Record<string, unknown>).RedWidgetSDK;
      });
      if (loaded) {
        widgetLoaded = true;
        log(`RedWidgetSDK 감지 (${i * 2 + 2}초)`);
        break;
      }
      log(`대기 중... (${i * 2 + 2}초)`);
    }
    result.widgetLoaded = widgetLoaded;

    // #redWidgetSdk 요소 확인
    const widgetElExists = await page.locator('#redWidgetSdk').count() > 0;
    result.widgetElementExists = widgetElExists;
    log(`#redWidgetSdk 요소: ${widgetElExists ? '있음' : '없음'}`);

    // 4. Shadow DOM 분석
    log('\n[STEP 4] Shadow DOM 분석...');
    await screenshot(page, '05-before-shadow-analysis');

    const shadowDomResult = await exploreShadowDOM(page);
    result.shadowDom = shadowDomResult;

    // Shadow DOM HTML 저장
    if (shadowDomResult.shadowRootHTML) {
      fs.writeFileSync(
        path.join(OUT, 'pc-shadow-dom.html'),
        shadowDomResult.shadowRootHTML as string,
        'utf-8'
      );
      log('Shadow DOM HTML 저장: pc-shadow-dom.html');
    }

    // 5. Window SDK 객체 탐색
    log('\n[STEP 5] Window SDK 객체 탐색...');
    const sdkResult = await exploreWindowSDKs(page);
    result.sdkObjects = sdkResult;

    if (sdkResult.RedEditorSDK) {
      log(`RedEditorSDK 감지: ${JSON.stringify((sdkResult.RedEditorSDK as Record<string, unknown>).protoMethods)?.slice(0, 300)}`);
    }

    // 6. 에디터 버튼 클릭 시도
    log('\n[STEP 6] 에디터 버튼 클릭 시도...');
    await screenshot(page, '06-before-editor-click');

    const clickResult = await tryClickEditorButton(page);
    result.editorButtonClick = clickResult;

    if (clickResult.clicked) {
      log(`버튼 클릭 성공: "${clickResult.buttonText}" (${clickResult.method})`);

      // 에디터 로드 대기
      await waitMs(5000);
      await page.waitForLoadState('networkidle').catch(() => {});
      await screenshot(page, '07-after-editor-click');

      // iframe URL 캡처
      const iframeUrl = await page.evaluate(function () {
        var iframes = document.querySelectorAll('iframe');
        for (var i = 0; i < iframes.length; i++) {
          if (iframes[i].src && iframes[i].src.includes('edicus')) {
            return iframes[i].src;
          }
        }
        // Shadow DOM 내부 iframe
        var widget = document.querySelector('#redWidgetSdk');
        if (widget && widget.shadowRoot) {
          var shadowIframes = widget.shadowRoot.querySelectorAll('iframe');
          for (var si = 0; si < shadowIframes.length; si++) {
            if (shadowIframes[si].src) return shadowIframes[si].src;
          }
        }
        // 인터셉션 데이터
        var iframeCreations = (window as unknown as Record<string, unknown[]>).__iframeCreations || [];
        if (iframeCreations.length > 0) {
          return (iframeCreations[iframeCreations.length - 1] as Record<string, unknown>).src as string;
        }
        return null;
      });

      result.edicusIframeUrl = iframeUrl;
      if (iframeUrl) {
        log(`Edicus iframe URL: ${iframeUrl}`);
        // URL 파라미터 파싱
        try {
          const url = new URL(iframeUrl);
          result.edicusIframeParams = {
            hash: url.hash,
            search: url.search,
            params: Object.fromEntries(url.searchParams.entries()),
            hashParams: url.hash.startsWith('#?')
              ? Object.fromEntries(new URLSearchParams(url.hash.slice(2)).entries())
              : {},
          };
          log(`run_mode: ${url.searchParams.get('run_mode') || 'not in search params'}`);
          if (url.hash) {
            const hashUrl = new URLSearchParams(url.hash.replace(/^#\??/, ''));
            log(`hash run_mode: ${hashUrl.get('run_mode') || 'not in hash'}`);
          }
        } catch {
          result.edicusIframeUrlError = 'Failed to parse URL';
        }
      }

      // 추가 대기 후 SDK 상태 재확인
      await waitMs(5000);
      await screenshot(page, '08-editor-loaded');

      const postClickSdk = await exploreWindowSDKs(page);
      result.sdkObjectsAfterClick = postClickSdk;
    } else {
      log('에디터 버튼을 찾지 못했습니다.');
    }

    // 7. Passive mode 관련 파라미터 특정 검사
    log('\n[STEP 7] Passive mode 파라미터 검사...');
    const passiveCheck = await page.evaluate(function () {
      var runModes: string[] = [];
      var hideToolbars: string[] = [];
      var allIframeSrcs: string[] = [];

      var iframeCreations = (window as unknown as Record<string, unknown[]>).__iframeCreations || [];
      for (var i = 0; i < iframeCreations.length; i++) {
        var src = ((iframeCreations[i] as Record<string, unknown>).src as string) || '';
        allIframeSrcs.push(src);
        try {
          var u = new URL(src);
          var rm = u.searchParams.get('run_mode') || '';
          var ht = u.searchParams.get('hideToolbar') || '';
          if (rm) runModes.push(rm);
          if (ht) hideToolbars.push(ht);
          if (u.hash) {
            var hp = new URLSearchParams(u.hash.replace(/^#\??/, ''));
            var hrm = hp.get('run_mode') || '';
            var hht = hp.get('hideToolbar') || '';
            if (hrm) runModes.push('hash:' + hrm);
            if (hht) hideToolbars.push('hash:' + hht);
          }
        } catch (e) { /* ignore */ }
      }

      var pmLog = (window as unknown as Record<string, unknown[]>).__pmLog || [];
      var pmWithRunMode = pmLog.filter(function (entry) {
        var data = JSON.stringify((entry as Record<string, unknown>).data);
        return data.includes('run_mode') || data.includes('passive') || data.includes('hideToolbar');
      });

      return {
        allIframeSrcs: allIframeSrcs,
        runModes: runModes,
        hideToolbars: hideToolbars,
        postMessagesWithRunMode: pmWithRunMode,
      };
    });

    result.passiveCheck = passiveCheck;

    if ((passiveCheck.runModes as string[]).length > 0) {
      log(`run_mode 발견: ${JSON.stringify(passiveCheck.runModes)}`);
    } else {
      log('run_mode가 iframe URL에서 발견되지 않음');
    }

  } catch (error) {
    const err = error as Error;
    log(`에러 발생: ${err.message}`);
    result.error = err.message;
    await screenshot(page, 'ERROR');
  } finally {
    // 최종 인터셉션 데이터 수집
    const finalData = await page.evaluate(function () {
      return {
        pmLog: ((window as unknown as Record<string, unknown[]>).__pmLog || []).slice(-20),
        iframeCreations: (window as unknown as Record<string, unknown[]>).__iframeCreations || [],
        sdkInitCalls: (window as unknown as Record<string, unknown[]>).__sdkInitCalls || [],
      };
    });

    result.networkCaptures = networkCaptures;
    result.consoleMessages = consoleMessages.filter((m) =>
      m.text.startsWith('[SDK') ||
      m.text.startsWith('[PM') ||
      m.text.startsWith('[IFRAME') ||
      m.text.startsWith('[EDITOR') ||
      m.text.startsWith('[BRIDGE') ||
      m.text.startsWith('[CREATE') ||
      m.text.startsWith('[EDICUS') ||
      m.text.includes('run_mode') ||
      m.text.includes('passive') ||
      m.text.includes('RedEditor')
    );
    result.finalIntercepted = finalData;

    // 결과 저장
    const outputPath = path.join(OUT, 'pc-analysis.json');
    fs.writeFileSync(outputPath, JSON.stringify(result, null, 2), 'utf-8');
    log(`\n분석 결과 저장: ${outputPath}`);

    await browser.close();

    // 요약 출력
    log('\n=== 분석 요약 ===');
    log(`RedWidgetSDK 로드: ${result.widgetLoaded ? '성공' : '실패'}`);
    log(`#redWidgetSdk 요소: ${result.widgetElementExists ? '있음' : '없음'}`);
    log(`Shadow DOM: ${(result.shadowDom as Record<string, unknown>)?.hasShadowRoot ? '열림' : '없음/닫힘'}`);
    log(`에디터 버튼: ${(result.editorButtonClick as Record<string, unknown>)?.clicked ? '클릭 성공' : '실패'}`);
    log(`Edicus iframe URL: ${result.edicusIframeUrl || '미감지'}`);
    log(`run_mode: ${JSON.stringify((result.passiveCheck as Record<string, unknown>)?.runModes) || '미감지'}`);
    log(`네트워크 캡처: ${networkCaptures.length}건`);
    log(`Shadow DOM 버튼: ${((result.shadowDom as Record<string, unknown>)?.buttons as unknown[])?.length || 0}개`);
    log(`편집 관련 버튼: ${((result.shadowDom as Record<string, unknown>)?.editButtons as unknown[])?.length || 0}개`);
  }
}

main().catch((err: Error) => {
  log(`치명적 에러: ${err.message}`);
  process.exit(1);
});
