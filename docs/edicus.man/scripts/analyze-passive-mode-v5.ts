/**
 * 레드프린팅 Passive Mode 분석 v5
 * 목표:
 * 1. widget-api 응답 캡처 (토큰 생성 API)
 * 2. RedEditorSDK 메서드 및 구조 탐색
 * 3. iframe src 설정 시점 인터셉션 → run_mode 출처 확인
 * 4. 전체 postMessage 프로토콜 양방향 캡처
 * 5. postToEditor 메서드 확인
 */
import { chromium, Page } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

const envContent = fs.readFileSync(path.join(__dirname, '..', '.env.local'), 'utf-8');
const ENV: Record<string, string> = {};
for (const line of envContent.split('\n')) {
  const t = line.trim();
  if (!t || t.startsWith('#')) continue;
  const i = t.indexOf('=');
  if (i > 0) ENV[t.slice(0, i)] = t.slice(i + 1);
}

const OUT = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-PASSIVE-001', 'analysis');
fs.mkdirSync(OUT, { recursive: true });

function log(msg: string) {
  const ts = new Date().toLocaleTimeString('ko-KR');
  console.log(`[${ts}] ${msg}`);
}

async function ss(page: Page, name: string) {
  await page.screenshot({ path: path.join(OUT, `${name}.png`), fullPage: true });
  log(`스크린샷: ${name}.png`);
}

async function main() {
  log('=== 레드프린팅 Passive Mode 분석 v5 (API + SDK 메서드) ===');

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-web-security'],
  });

  const ctx = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
  });

  // 전체 postMessage 양방향 캡처 + SDK/iframe 인터셉션
  await ctx.addInitScript(function() {
    (window as any).__pmLog = [];
    (window as any).__sdkInitCalls = [];
    (window as any).__iframeCreations = [];
    (window as any).__redEditorSDK = null;

    // 모든 postMessage 캡처 (in + out)
    var _origPM = window.postMessage;
    window.postMessage = function(msg: any, target: any, tr?: any) {
      try {
        var entry = { origin: location.origin, data: msg, ts: Date.now(), dir: 'out' };
        (window as any).__pmLog.push(entry);
        if (typeof msg === 'object' && msg !== null) {
          console.log('[PM_OUT]', JSON.stringify(msg).slice(0, 500));
        }
      } catch {}
      return _origPM.call(window, msg, target, tr);
    };
    window.addEventListener('message', function(e: MessageEvent) {
      try {
        var entry = { origin: e.origin, data: e.data, ts: Date.now(), dir: 'in' };
        (window as any).__pmLog.push(entry);
        if (typeof e.data === 'object' && e.data !== null) {
          console.log('[PM_IN]', JSON.stringify(e.data).slice(0, 500));
        }
      } catch {}
    });

    // iframe 생성 인터셉션 → src 모니터링
    var OrigIframe = window.HTMLIFrameElement;
    var origCreateElement = document.createElement.bind(document);
    (document as any).createElement = function(tag: string, opts?: any): Element {
      var el = origCreateElement(tag, opts);
      if (tag.toLowerCase() === 'iframe') {
        var origSrcDesc = Object.getOwnPropertyDescriptor(HTMLIFrameElement.prototype, 'src');
        if (origSrcDesc && origSrcDesc.set) {
          var origSet = origSrcDesc.set;
          Object.defineProperty(el, 'src', {
            get: origSrcDesc.get ? function() { return origSrcDesc.get!.call(el); } : undefined,
            set: function(val: string) {
              console.log('[IFRAME_SRC_SET]', val.slice(0, 600));
              (window as any).__iframeCreations.push({ src: val, ts: Date.now() });
              origSet.call(el, val);
            },
            configurable: true,
          });
        }
      }
      return el;
    };

    // setAttribute 인터셉션 (src 설정 감지)
    var origSetAttr = Element.prototype.setAttribute;
    Element.prototype.setAttribute = function(name: string, value: string) {
      if (name === 'src' && this.tagName === 'IFRAME') {
        console.log('[IFRAME_SETATTR_SRC]', value.slice(0, 600));
        (window as any).__iframeCreations.push({ src: value, ts: Date.now() });
      }
      return origSetAttr.call(this, name, value);
    };

    // RedWidgetSDK 인터셉션
    var _rwSDK: any;
    Object.defineProperty(window, 'RedWidgetSDK', {
      get: function() { return _rwSDK; },
      set: function(val: any) {
        _rwSDK = val;
        console.log('[SDK_SET] RedWidgetSDK', typeof val);
        if (val && val.prototype) {
          var origInit = val.prototype.init;
          if (origInit) {
            val.prototype.init = function(options: any, callbacks: any) {
              console.log('[SDK_INIT]', JSON.stringify(options).slice(0, 500));
              (window as any).__sdkInitCalls.push({ options, ts: Date.now() });
              var result = origInit.call(this, options, callbacks);
              (window as any).__sdkInstance = result;
              // 인스턴스 메서드 탐색
              if (result) {
                var ownMethods = Object.keys(result).filter(function(k) { return typeof result[k] === 'function'; });
                var protoMethods = Object.getOwnPropertyNames(Object.getPrototypeOf(result) || {});
                console.log('[SDK_INSTANCE_OWN]', JSON.stringify(ownMethods));
                console.log('[SDK_INSTANCE_PROTO]', JSON.stringify(protoMethods));
              }
              return result;
            };
          }
        }
      },
      configurable: true,
    });

    // RedEditorSDK 인터셉션
    var _reSdk: any;
    Object.defineProperty(window, 'RedEditorSDK', {
      get: function() { return _reSdk; },
      set: function(val: any) {
        _reSdk = val;
        console.log('[EDITOR_SDK_SET] RedEditorSDK', typeof val);
        (window as any).__redEditorSDK = val;
        if (val) {
          var keys = [];
          for (var k in val) { keys.push(k); }
          console.log('[EDITOR_SDK_KEYS]', JSON.stringify(keys));
          // prototype 탐색
          if (val.prototype) {
            var proto = Object.getOwnPropertyNames(val.prototype);
            console.log('[EDITOR_SDK_PROTO]', JSON.stringify(proto));
          }
        }
      },
      configurable: true,
    });
  });

  // widget-api 응답 캡처
  const widgetApiResponses: Array<{ url: string; status: number; body: any }> = [];
  await ctx.route('**/*widget-api*/**', async function(route) {
    const response = await route.fetch();
    try {
      const body = await response.json().catch(() => null);
      const req = route.request();
      widgetApiResponses.push({ url: req.url(), status: response.status(), body });
      log(`widget-api 응답: ${req.url()} → ${JSON.stringify(body)?.slice(0, 500)}`);
    } catch {}
    await route.fulfill({ response });
  });

  const page = await ctx.newPage();

  page.on('console', function(msg) {
    const t = msg.text();
    if (t.startsWith('[SDK') || t.startsWith('[PM') || t.startsWith('[IFRAME') ||
        t.startsWith('[EDITOR') || t.includes('edicus') || t.includes('run_mode') ||
        t.includes('passive') || t.includes('postToEditor') || t.includes('production')) {
      log(`콘솔: ${t.slice(0, 600)}`);
    }
  });

  try {
    // 1. 로그인
    log('\n[1] 로그인...');
    await page.goto('https://m.redprinting.co.kr/member/login', { waitUntil: 'networkidle', timeout: 30000 });
    await page.fill('#mb_id', ENV.REDPRINTING_USERNAME);
    await page.fill('#password', ENV.REDPRINTING_PASSWORD);
    await page.click('button:has-text("로그인")');
    await page.waitForTimeout(3000);
    await page.waitForLoadState('networkidle').catch(() => {});

    // 2. 상품 페이지
    log('\n[2] 상품 페이지...');
    await page.goto('https://m.redprinting.co.kr/product/item/ST/STPAUNM', { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(3000);

    // 3. "편집하기" 클릭
    log('\n[3] "편집하기" 클릭...');
    const clicked = await page.evaluate(function() {
      const w = document.querySelector('#widget') as HTMLElement;
      if (!w || !w.shadowRoot) return false;
      const btns = Array.from(w.shadowRoot.querySelectorAll('button'));
      for (var i = 0; i < btns.length; i++) {
        if (String(btns[i].className).includes('edit')) {
          (btns[i] as HTMLElement).dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true, view: window }));
          return true;
        }
      }
      return false;
    });
    log(`클릭: ${clicked}`);

    // widget-api 응답 대기
    await page.waitForTimeout(3000);

    // 4. RedEditorSDK 메서드 탐색
    log('\n[4] RedEditorSDK 탐색...');
    const sdkInfo = await page.evaluate(function() {
      var sdk = (window as any).RedEditorSDK;
      if (!sdk) return { found: false };

      var result: any = { found: true, type: typeof sdk };

      // 클래스/함수 자체 속성
      result.ownKeys = Object.keys(sdk);
      result.staticMethods = Object.getOwnPropertyNames(sdk).filter(function(k) {
        return typeof sdk[k] === 'function';
      });

      // prototype 메서드
      if (sdk.prototype) {
        result.protoMethods = Object.getOwnPropertyNames(sdk.prototype);
      }

      // 인스턴스가 있으면 탐색
      var instance = (window as any).__sdkInstance;
      if (instance) {
        result.instanceType = typeof instance;
        result.instanceConstructor = instance.constructor ? instance.constructor.name : 'unknown';
        result.instanceOwnKeys = Object.keys(instance);
        var proto = Object.getPrototypeOf(instance);
        result.instanceProtoMethods = proto ? Object.getOwnPropertyNames(proto) : [];

        // postToEditor 메서드가 있는지
        result.hasPostToEditor = typeof instance.postToEditor === 'function';
        result.hasPostMessage = typeof instance.postMessage === 'function';
        result.hasSave = typeof instance.save === 'function';
        result.hasClose = typeof instance.close === 'function';

        // 소스코드 (함수면)
        if (typeof instance.postToEditor === 'function') {
          result.postToEditorSource = instance.postToEditor.toString().slice(0, 500);
        }
      }

      return result;
    });
    log(`RedEditorSDK 정보: ${JSON.stringify(sdkInfo, null, 2)}`);

    // 5. SDK 인스턴스 상세 탐색
    log('\n[5] SDK 인스턴스 상세...');
    const instanceDetail = await page.evaluate(function() {
      var instance = (window as any).__sdkInstance;
      if (!instance) return { found: false };

      var info: any = { found: true };

      // 모든 속성 나열 (함수 포함)
      var allProps: any[] = [];
      var visited: string[] = [];
      var current = instance;
      while (current && current !== Object.prototype) {
        var names = Object.getOwnPropertyNames(current);
        for (var i = 0; i < names.length; i++) {
          var n = names[i];
          if (visited.indexOf(n) === -1) {
            visited.push(n);
            try {
              var v = (instance as any)[n];
              allProps.push({ name: n, type: typeof v, source: typeof v === 'function' ? v.toString().slice(0, 200) : undefined });
            } catch {}
          }
        }
        current = Object.getPrototypeOf(current);
      }
      info.allProps = allProps.slice(0, 50);

      // iframe 레퍼런스 탐색
      var iframeProps = allProps.filter(function(p) {
        return p.type === 'object' || (p.source && (p.source.includes('iframe') || p.source.includes('postMessage')));
      });
      info.possibleIframeRefs = iframeProps.slice(0, 20);

      return info;
    });
    log(`인스턴스 상세: ${JSON.stringify(instanceDetail, null, 2).slice(0, 3000)}`);

    // 6. iframe src에서 run_mode 위치 확인
    log('\n[6] iframe 생성 이벤트 확인...');
    const iframeCreations = await page.evaluate(function() {
      return (window as any).__iframeCreations || [];
    });
    log(`iframe 생성 이벤트: ${iframeCreations.length}개`);
    for (const ic of iframeCreations) {
      log(`  src: ${ic.src?.slice(0, 400)}`);
    }

    // iframe URL에서 run_mode 파싱
    if (iframeCreations.length > 0) {
      for (const ic of iframeCreations) {
        if (ic.src && ic.src.includes('edicusbase')) {
          try {
            const hashPart = ic.src.split('#')[1] || '';
            const queryStart = hashPart.indexOf('?');
            if (queryStart >= 0) {
              const queryStr = hashPart.slice(queryStart + 1);
              const params: Record<string, string> = {};
              for (const pair of queryStr.split('&')) {
                const [k, ...v] = pair.split('=');
                params[decodeURIComponent(k)] = decodeURIComponent(v.join('='));
              }
              log(`iframe URL 파라미터: ${JSON.stringify(params, null, 2)}`);
              fs.writeFileSync(path.join(OUT, 'edicus-iframe-params-full.json'), JSON.stringify({ url: ic.src, params }, null, 2));
            }
          } catch (e) {
            log(`파싱 오류: ${e}`);
          }
          break;
        }
      }
    }

    // 7. 전체 postMessage 캡처 (에디터 로딩 완료 후)
    log('\n[7] 에디터 로딩 후 postMessage 수집 (10초 대기)...');
    await page.waitForTimeout(10000);
    await ss(page, 'v5-editor-loaded');

    const allPMs = await page.evaluate(function() { return (window as any).__pmLog || []; });
    log(`전체 postMessage: ${allPMs.length}개`);

    const pmByAction: Record<string, any[]> = {};
    for (const m of allPMs) {
      if (m.data && typeof m.data === 'object') {
        const action = m.data.type + ':' + m.data.action;
        if (!pmByAction[action]) pmByAction[action] = [];
        pmByAction[action].push({ dir: m.dir, data: m.data });
      }
    }
    log(`postMessage 타입별: ${JSON.stringify(Object.keys(pmByAction))}`);

    for (const [action, msgs] of Object.entries(pmByAction)) {
      log(`  [${action}] x${msgs.length}`);
      if (msgs[0]) log(`    샘플: ${JSON.stringify(msgs[0].data).slice(0, 300)}`);
    }

    // 8. 결과 저장
    const report = {
      timestamp: new Date().toISOString(),
      widgetApiResponses,
      sdkInfo,
      iframeCreations: iframeCreations.map((ic: any) => ({ src: ic.src?.slice(0, 600), ts: ic.ts })),
      postMessages: allPMs,
      pmByAction,
    };
    fs.writeFileSync(path.join(OUT, 'v5-analysis.json'), JSON.stringify(report, null, 2));
    log('\n결과 저장: v5-analysis.json');

  } catch (e) {
    log(`오류: ${e}`);
    await ss(page, 'v5-ERROR').catch(() => {});
  } finally {
    await browser.close();
    log('\n=== v5 분석 완료 ===');
  }
}

main().catch(console.error);
