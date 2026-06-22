/**
 * 레드프린팅 Passive Mode 완전 분석 v4
 * 핵심: "편집하기" 버튼 클릭 → Edicus iframe URL 및 파라미터 캡처
 *
 * v3 발견사항:
 * - Shadow DOM 접근 성공 (mode: "open")
 * - "에디터" 버튼(upload-btn active)은 이미 선택된 상태
 * - "편집하기" 버튼(upload-btn edit)이 실제 에디터 열기 버튼
 * - 페이지 로드 시 위젯이 이미 완전히 렌더링되어 있음
 */
import { chromium, Page, BrowserContext } from 'playwright';
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

const edicusUrls: string[] = [];
const allNetworkUrls: Array<{ method: string; url: string; type: string }> = [];

function log(msg: string) {
  const ts = new Date().toLocaleTimeString('ko-KR');
  console.log(`[${ts}] ${msg}`);
}

async function ss(page: Page, name: string) {
  await page.screenshot({ path: path.join(OUT, `${name}.png`), fullPage: true });
  log(`스크린샷: ${name}.png`);
}

async function main() {
  log('=== 레드프린팅 Passive Mode 분석 v4 (편집하기 클릭) ===');

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

  // postMessage + SDK 인터셉션
  await ctx.addInitScript(function() {
    (window as any).__pmLog = [];
    (window as any).__sdkInstance = null;
    (window as any).__sdkInitCalls = [];

    window.addEventListener('message', function(e) {
      try {
        (window as any).__pmLog.push({ origin: e.origin, data: e.data, ts: Date.now(), dir: 'in' });
      } catch {}
    });

    var origPM = window.postMessage;
    window.postMessage = function(msg: any, target: any, tr?: any) {
      try { (window as any).__pmLog.push({ origin: location.origin, data: msg, ts: Date.now(), dir: 'out' }); } catch {}
      return origPM.call(window, msg, target, tr);
    };

    // RedWidgetSDK 래핑
    var _rwSDK: any;
    Object.defineProperty(window, 'RedWidgetSDK', {
      get: function() { return _rwSDK; },
      set: function(val: any) {
        if (val && val.prototype && val.prototype.init) {
          var origInit = val.prototype.init;
          val.prototype.init = function(options: any, callbacks: any) {
            console.log('[SDK_INIT]', JSON.stringify(options ? options : {}).slice(0, 500));
            (window as any).__sdkInitCalls.push({ options: options, ts: Date.now() });
            var result = origInit.call(this, options, callbacks);
            (window as any).__sdkInstance = result;
            console.log('[SDK_INIT_DONE]', typeof result, result && result.constructor ? result.constructor.name : 'unknown');
            // 인스턴스 메서드 탐색
            if (result) {
              var methods = [];
              for (var k in result) {
                if (typeof (result as any)[k] === 'function') methods.push(k);
              }
              var protoMethods = Object.getOwnPropertyNames(Object.getPrototypeOf(result) || {});
              console.log('[SDK_INSTANCE_METHODS]', JSON.stringify(methods.concat(protoMethods)));
            }
            return result;
          };
        }
        _rwSDK = val;
        console.log('[SDK_SET] RedWidgetSDK defined');
      },
      configurable: true,
    });
  });

  // 모든 네트워크 요청 캡처
  ctx.on('request', function(req) {
    const url = req.url();
    allNetworkUrls.push({ method: req.method(), url, type: req.resourceType() });
    if (url.includes('edicus') || url.includes('edicusbase') || url.includes('firebaseapp') ||
        url.includes('widget') || url.includes('firebase')) {
      log(`네트워크: ${req.method()} ${url.slice(0, 200)}`);
    }
  });

  // 새 페이지 감지
  const newPages: string[] = [];
  ctx.on('page', function(newPage) {
    log(`*** 새 페이지 열림: ${newPage.url()}`);
    newPages.push(newPage.url());
    newPage.on('framenavigated', function(frame) {
      log(`  새 페이지 탐색: ${frame.url().slice(0, 200)}`);
    });
  });

  const page = await ctx.newPage();

  // 콘솔 모니터링
  page.on('console', function(msg) {
    const t = msg.text();
    if (t.startsWith('[SDK') || t.includes('edicus') || t.includes('passive') ||
        t.includes('run_mode') || t.includes('CLICK') || t.includes('postMessage')) {
      log(`콘솔: ${t.slice(0, 400)}`);
    }
  });

  // 페이지 탐색 감지
  page.on('framenavigated', function(frame) {
    if (frame === page.mainFrame()) {
      log(`메인 프레임 탐색: ${frame.url().slice(0, 200)}`);
    } else {
      const url = frame.url();
      if (url && url !== 'about:blank') {
        log(`서브 프레임 탐색: ${url.slice(0, 200)}`);
        if (url.includes('edicus') || url.includes('firebaseapp')) {
          edicusUrls.push(url);
          log(`*** Edicus URL 발견! ${url}`);
          try {
            const u = new URL(url);
            const params = Object.fromEntries(u.searchParams.entries());
            log(`Edicus 파라미터: ${JSON.stringify(params, null, 2)}`);
            fs.writeFileSync(path.join(OUT, 'edicus-params-v4.json'), JSON.stringify(params, null, 2));
          } catch {}
        }
      }
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
    log(`로그인 후: ${page.url()}`);

    // 2. 상품 페이지 (RedWidgetSDK 자동 초기화)
    log('\n[2] 상품 페이지 이동...');
    await page.goto('https://m.redprinting.co.kr/product/item/ST/STPAUNM', { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(3000);
    await ss(page, 'v4-01-product');
    log(`상품 페이지: ${page.url()}`);

    // Shadow DOM 상태 확인
    const shadowState = await page.evaluate(function() {
      const w = document.querySelector('#widget') as HTMLElement;
      if (!w) return { found: false, error: '#widget 없음' };
      const sr = w.shadowRoot;
      if (!sr) return { found: false, error: 'shadowRoot 없음' };
      const btns = Array.from(sr.querySelectorAll('button')).map(function(b) {
        return { class: String(b.className), text: (b.textContent || '').trim() };
      });
      return { found: true, buttonCount: btns.length, buttons: btns, htmlLength: sr.innerHTML.length };
    });
    log(`Shadow DOM 상태: ${JSON.stringify(shadowState, null, 2)}`);

    // 3. "편집하기" 버튼 클릭 (shadow DOM 내부)
    log('\n[3] "편집하기" 버튼 클릭...');

    const clickResult = await page.evaluate(function() {
      const w = document.querySelector('#widget') as HTMLElement;
      if (!w || !w.shadowRoot) return { clicked: false, error: 'Shadow DOM 없음' };
      const sr = w.shadowRoot;

      // "편집하기" 텍스트를 가진 버튼 찾기
      const buttons = Array.from(sr.querySelectorAll('button'));
      let found: HTMLElement | null = null;
      for (var i = 0; i < buttons.length; i++) {
        const txt = (buttons[i].textContent || '').trim();
        if (txt === '편집하기' || txt.includes('편집')) {
          found = buttons[i] as HTMLElement;
          break;
        }
      }
      if (!found) {
        // class에 "edit" 포함된 버튼
        for (var j = 0; j < buttons.length; j++) {
          if (String(buttons[j].className).includes('edit')) {
            found = buttons[j] as HTMLElement;
            break;
          }
        }
      }
      if (!found) return { clicked: false, error: '편집하기 버튼 없음', buttonClasses: buttons.map(function(b) { return String(b.className) + ':' + (b.textContent || '').trim(); }) };

      console.log('[CLICK] 편집하기 버튼:', String(found.className), found.textContent?.trim());
      found.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true, view: window }));
      return { clicked: true, btnClass: String(found.className), btnText: (found.textContent || '').trim() };
    });
    log(`클릭 결과: ${JSON.stringify(clickResult)}`);

    // 4. 클릭 후 변화 모니터링 (15초)
    log('\n[4] 클릭 후 변화 모니터링 (15초)...');

    for (let i = 0; i < 5; i++) {
      await page.waitForTimeout(3000);
      const checkTime = i * 3 + 3;
      log(`  ${checkTime}초 경과...`);

      // iframe 체크
      const iframes = await page.evaluate(function() {
        var regular = Array.from(document.querySelectorAll('iframe')).map(function(f) {
          return { src: (f as HTMLIFrameElement).src.slice(0, 300), id: f.id };
        });
        var w = document.querySelector('#widget') as HTMLElement;
        var shadow: any[] = [];
        if (w && w.shadowRoot) {
          shadow = Array.from(w.shadowRoot.querySelectorAll('iframe')).map(function(f) {
            return { src: (f as HTMLIFrameElement).src.slice(0, 300), id: f.id, shadow: true };
          });
        }
        return { regular, shadow };
      });

      if (iframes.regular.length > 0 || iframes.shadow.length > 0) {
        log(`  iframe 발견! ${JSON.stringify(iframes)}`);
        for (const f of iframes.regular.concat(iframes.shadow)) {
          if (f.src.includes('edicus') || f.src.includes('firebaseapp')) {
            edicusUrls.push(f.src);
          }
        }
        break;
      }

      // 프레임 체크
      const frames = page.frames();
      if (frames.length > 1) {
        log(`  프레임 수: ${frames.length}`);
        for (const f of frames) {
          const url = f.url();
          if (url && url !== 'about:blank' && url !== page.url()) {
            log(`  프레임 URL: ${url.slice(0, 200)}`);
            if (url.includes('edicus') || url.includes('firebaseapp')) {
              edicusUrls.push(url);
            }
          }
        }
        break;
      }

      // URL 변화 체크
      if (page.url() !== 'https://m.redprinting.co.kr/product/item/ST/STPAUNM') {
        log(`  *** 페이지 이동! ${page.url()}`);
        break;
      }

      // Shadow DOM 변화 체크
      const newShadow = await page.evaluate(function() {
        const w = document.querySelector('#widget') as HTMLElement;
        if (!w || !w.shadowRoot) return { length: 0 };
        return { length: w.shadowRoot.innerHTML.length };
      });
      log(`  Shadow DOM 크기: ${newShadow.length}자`);
    }

    await ss(page, 'v4-02-after-edit-click');

    // 5. 주문하기 버튼 클릭 (위젯 외부 페이지 버튼)
    log('\n[5] 페이지 레벨 주문하기 버튼 탐색...');
    const pageButtons = await page.evaluate(function() {
      var btns = Array.from(document.querySelectorAll('button, a.btn, .order-btn, .order-wrap button'));
      return btns.map(function(b) {
        return { tag: b.tagName, class: String(b.className).slice(0, 80), text: (b.textContent || '').trim().slice(0, 50), id: b.id };
      }).filter(function(b) { return b.text.length > 0; });
    });
    log(`페이지 버튼들: ${JSON.stringify(pageButtons.slice(0, 10), null, 2)}`);

    // 주문하기 클릭
    const orderBtnSel = 'button:has-text("주문하기"), .order-btn';
    try {
      await page.click(orderBtnSel, { timeout: 5000 });
      log('주문하기 클릭!');
      await page.waitForTimeout(5000);
      await ss(page, 'v4-03-after-order');

      // 이동된 URL 확인
      log(`주문 후 URL: ${page.url()}`);
      const frames = page.frames();
      log(`프레임 수: ${frames.length}`);
      for (const f of frames) {
        const url = f.url();
        if (url && url !== 'about:blank') {
          log(`  프레임: ${url.slice(0, 200)}`);
          if (url.includes('edicus') || url.includes('firebaseapp')) {
            edicusUrls.push(url);
            log(`*** Edicus! ${url}`);
            try {
              const u = new URL(url);
              const params = Object.fromEntries(u.searchParams.entries());
              log(`파라미터: ${JSON.stringify(params, null, 2)}`);
              fs.writeFileSync(path.join(OUT, 'edicus-params-v4.json'), JSON.stringify(params, null, 2));
            } catch {}
          }
        }
      }
    } catch (e) {
      log(`주문하기 버튼 없음: ${e}`);
    }

    // 6. 최종 HTML 덤프
    log('\n[6] 현재 페이지 HTML 구조 분석...');
    await page.waitForTimeout(5000);
    await ss(page, 'v4-04-final');

    const finalAnalysis = await page.evaluate(function() {
      // 페이지 레벨 모든 iframe
      var iframeInfo = Array.from(document.querySelectorAll('iframe')).map(function(f) {
        return { src: (f as HTMLIFrameElement).src, id: f.id, class: String(f.className) };
      });

      // 모든 스크립트 태그 (에디터 관련)
      var scripts = Array.from(document.querySelectorAll('script[src]'))
        .map(function(s) { return (s as HTMLScriptElement).src; })
        .filter(function(src) { return src.includes('edicus') || src.includes('firebase') || src.includes('widget'); });

      // window 객체에서 에디터 관련 키 탐색
      var winKeys: string[] = [];
      try {
        for (var k in window) {
          if (k.toLowerCase().includes('edicus') || k.toLowerCase().includes('red') || k.toLowerCase().includes('sdk')) {
            winKeys.push(k);
          }
        }
      } catch {}

      // postMessage 로그
      var pmLog = (window as any).__pmLog || [];

      return { iframeInfo, scripts, winKeys: winKeys.slice(0, 20), pmLogCount: pmLog.length,
               currentUrl: location.href };
    });
    log(`최종 분석: ${JSON.stringify(finalAnalysis, null, 2)}`);

    // 7. postMessage 수집
    const msgs = await page.evaluate(function() { return (window as any).__pmLog || []; });
    log(`\n[7] postMessage 수집: ${msgs.length}개`);
    for (const m of msgs) {
      const dataStr = typeof m.data === 'object' ? JSON.stringify(m.data)?.slice(0, 300) : String(m.data).slice(0, 300);
      if (dataStr && dataStr !== 'undefined' && dataStr !== '"undefined"') {
        log(`  [${m.dir}] ${m.origin} → ${dataStr}`);
      }
    }

    // 8. 최종 결과 저장
    const report = {
      timestamp: new Date().toISOString(),
      edicusUrlsFound: edicusUrls,
      newPagesOpened: newPages,
      finalAnalysis,
      postMessages: msgs,
      allNetworkCount: allNetworkUrls.length,
      edicusNetworkUrls: allNetworkUrls.filter(r => r.url.includes('edicus') || r.url.includes('firebaseapp')),
    };
    fs.writeFileSync(path.join(OUT, 'v4-analysis.json'), JSON.stringify(report, null, 2));
    log('\n결과 저장 완료: v4-analysis.json');

  } catch (e) {
    log(`오류: ${e}`);
    await ss(page, 'v4-ERROR').catch(() => {});
  } finally {
    await browser.close();
    log('\n=== v4 분석 완료 ===');
    log(`Edicus URL: ${edicusUrls.length}개`);
    for (const url of edicusUrls) log(`  ${url}`);
  }
}

main().catch(console.error);
