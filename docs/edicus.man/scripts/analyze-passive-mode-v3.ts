/**
 * 레드프린팅 Passive Mode 완전 분석 v3
 * 핵심: Shadow DOM 접근 + 에디터 버튼 클릭 + Edicus iframe 파라미터 캡처
 * SPEC-PASSIVE-001 Phase A
 *
 * 발견사항:
 * - RedWidgetSDK.init()이 attachShadow({mode: "open"})으로 Shadow DOM 생성
 * - Shadow DOM 내부에 #red-widget-root 마운트
 * - init() 파라미터: {target: "#widget", pdtCode: "STPAUNM", locale: "ko", deviceType: "mobile"}
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

const networkRequests: Array<{ method: string; url: string; type: string; timestamp: number }> = [];
const postMessages: Array<{ origin: string; data: unknown; ts: number; dir: string }> = [];
const edicusIframeUrls: string[] = [];

function log(msg: string) {
  const ts = new Date().toLocaleTimeString('ko-KR');
  console.log(`[${ts}] ${msg}`);
}

async function ss(page: Page, name: string) {
  await page.screenshot({ path: path.join(OUT, `${name}.png`), fullPage: true });
  log(`스크린샷: ${name}.png`);
}

async function analyzeShadowDOM(page: Page, label: string) {
  const shadowInfo = await page.evaluate(() => {
    // #widget 엘리먼트의 shadowRoot 접근
    const widgetEl = document.querySelector('#widget') as HTMLElement;
    if (!widgetEl) return { found: false, error: '#widget 없음' };

    const sr = widgetEl.shadowRoot;
    if (!sr) return { found: false, error: 'shadowRoot 없음 (mode closed?)' };

    // Shadow DOM 내부 HTML
    const html = sr.innerHTML;

    // SVG className은 SVGAnimatedString이므로 String()으로 변환
    // Shadow DOM 내부 모든 요소
    const allElements = Array.from(sr.querySelectorAll('*')).map(function(el) {
      return {
        tag: el.tagName,
        id: el.id,
        class: String(el.className).slice(0, 100),
        text: (el.textContent || '').trim().slice(0, 80),
        visible: !!(el as HTMLElement).offsetParent || (el as HTMLElement).offsetHeight > 0,
      };
    });

    // 버튼/링크/클릭가능 요소
    const clickable = Array.from(sr.querySelectorAll('button, a, [onclick], [role="button"], li')).map(function(el) {
      return {
        tag: el.tagName,
        id: el.id,
        class: String(el.className).slice(0, 100),
        text: (el.textContent || '').trim().slice(0, 80),
        ariaLabel: el.getAttribute('aria-label'),
        dataKey: el.getAttribute('data-key') || el.getAttribute('data-type'),
      };
    });

    // 이미지 목록
    const images = Array.from(sr.querySelectorAll('img')).map(function(img) {
      return {
        src: (img as HTMLImageElement).getAttribute('src')?.slice(0, 200),
        alt: img.getAttribute('alt'),
      };
    });

    // iframe 목록
    const iframes = Array.from(sr.querySelectorAll('iframe')).map(function(f) {
      return {
        src: (f as HTMLIFrameElement).src.slice(0, 300),
        id: f.id,
        class: String(f.className).slice(0, 100),
      };
    });

    // 에디터 관련 요소 탐색
    const editorElements = Array.from(sr.querySelectorAll('*')).filter(function(el) {
      const text = (el.textContent || '').toLowerCase();
      const elcls = String(el.className).toLowerCase();
      return text.includes('에디터') || text.includes('editor') || text.includes('디자인') ||
             elcls.includes('editor') || elcls.includes('design');
    }).map(function(el) {
      return {
        tag: el.tagName,
        id: el.id,
        class: String(el.className).slice(0, 80),
        text: (el.textContent || '').trim().slice(0, 100),
      };
    }).slice(0, 20);

    return {
      found: true,
      htmlLength: html.length,
      html: html.slice(0, 3000),
      elementCount: allElements.length,
      clickable,
      images,
      iframes,
      editorElements,
    };
  });

  log(`\n[${label}] Shadow DOM 분석:`);
  log(`  찾음: ${shadowInfo.found}, HTML 길이: ${(shadowInfo as any).htmlLength || 0}`);
  log(`  요소 수: ${(shadowInfo as any).elementCount || 0}`);
  if ((shadowInfo as any).found) {
    log(`  클릭가능 요소: ${JSON.stringify((shadowInfo as any).clickable, null, 2)}`);
    log(`  이미지: ${JSON.stringify((shadowInfo as any).images, null, 2)}`);
    log(`  iframe: ${JSON.stringify((shadowInfo as any).iframes, null, 2)}`);
    log(`  에디터 요소: ${JSON.stringify((shadowInfo as any).editorElements, null, 2)}`);

    if ((shadowInfo as any).htmlLength > 0) {
      fs.writeFileSync(path.join(OUT, `${label}-shadow-dom.html`), (shadowInfo as any).html);
      log(`  Shadow DOM HTML 저장: ${label}-shadow-dom.html`);
    }
  } else {
    log(`  오류: ${(shadowInfo as any).error}`);
  }

  return shadowInfo;
}

async function main() {
  log('=== 레드프린팅 Passive Mode 분석 v3 (Shadow DOM) ===');

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

  // postMessage 모니터링 + SDK 인터셉션
  await ctx.addInitScript(() => {
    (window as any).__pmLog = [];
    (window as any).__sdkInitCalls = [];
    (window as any).__sdkCallLog = [];

    window.addEventListener('message', (e) => {
      try {
        (window as any).__pmLog.push({ origin: e.origin, data: e.data, ts: Date.now(), dir: 'in' });
      } catch {}
    });

    const origPM = window.postMessage.bind(window);
    window.postMessage = function(msg: unknown, target: unknown, tr?: unknown) {
      try { (window as any).__pmLog.push({ origin: location.origin, data: msg, ts: Date.now(), dir: 'out' }); } catch {}
      return origPM(msg, target as string, tr as Transferable[]);
    };

    // RedWidgetSDK 인터셉션
    let _rwSDK: unknown;
    Object.defineProperty(window, 'RedWidgetSDK', {
      get() { return _rwSDK; },
      set(val: unknown) {
        if (typeof val === 'function' && val.prototype) {
          // init() 래핑
          const origInit = val.prototype.init;
          if (origInit) {
            val.prototype.init = function(options: unknown, callbacks: unknown) {
              console.log('[SDK_INIT]', JSON.stringify(options)?.slice(0, 500));
              (window as any).__sdkInitCalls.push({ options, callbacks: typeof callbacks, ts: Date.now() });
              const result = origInit.call(this, options, callbacks);
              console.log('[SDK_INIT_DONE] result type:', typeof result);
              (window as any).__sdkInstance = result;
              return result;
            };
          }
        }
        _rwSDK = val;
        console.log('[SDK_SET] RedWidgetSDK');
      },
      configurable: true,
    });
  });

  // 네트워크 캡처 (Edicus 관련)
  ctx.on('request', (req) => {
    const url = req.url();
    if (url.includes('edicus') || url.includes('edicusbase') || url.includes('firebaseapp') ||
        url.includes('widget.js') || url.includes('widget.css')) {
      networkRequests.push({ method: req.method(), url, type: req.resourceType(), timestamp: Date.now() });
      log(`네트워크: ${req.method()} ${url.slice(0, 150)}`);
    }
  });

  const page = await ctx.newPage();

  page.on('console', msg => {
    const t = msg.text();
    if (t.startsWith('[SDK') || t.includes('edicus') || t.includes('passive') || t.includes('run_mode')) {
      log(`콘솔: ${t.slice(0, 300)}`);
    }
  });

  // 새 페이지/프레임 감지
  ctx.on('page', async (newPage) => {
    log(`새 페이지: ${newPage.url()}`);
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
    log(`로그인 후 URL: ${page.url()}`);

    // 2. 상품 페이지 (RedWidgetSDK init 자동 호출됨)
    log('\n[2] 상품 페이지...');
    await page.goto('https://m.redprinting.co.kr/product/item/ST/STPAUNM', { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(3000); // SDK 초기화 대기
    await ss(page, 'v3-01-product');

    // SDK init() 호출 확인
    const initCalls = await page.evaluate(() => (window as any).__sdkInitCalls || []);
    log(`SDK init 호출: ${JSON.stringify(initCalls, null, 2)}`);

    // 3. Shadow DOM 분석 (페이지 로드 시 widget이 이미 렌더링됨)
    log('\n[3] Shadow DOM 초기 분석...');
    const shadowBefore = await analyzeShadowDOM(page, 'v3-before-click');

    // 4. 주문하기 클릭
    log('\n[4] 주문하기 클릭...');
    const orderBtn = await page.$('button:has-text("주문하기")');
    if (orderBtn) {
      await orderBtn.click();
      log('주문하기 클릭 완료');
    }

    // Shadow DOM 로딩 대기 (더 강력한 방법)
    log('Shadow DOM 콘텐츠 로딩 대기...');
    const shadowLoaded = await page.waitForFunction(() => {
      const widgetEl = document.querySelector('#widget') as HTMLElement;
      if (!widgetEl || !widgetEl.shadowRoot) return false;
      const sr = widgetEl.shadowRoot;
      const elements = sr.querySelectorAll('*');
      const text = sr.textContent?.trim() || '';
      log(`Shadow DOM: ${elements.length}개 요소, ${text.length}자`);
      return elements.length > 5 && text.length > 10;
    }, { timeout: 20000 }).catch(() => null);

    log(`Shadow DOM 로딩: ${shadowLoaded ? '성공' : '타임아웃'}`);
    await ss(page, 'v3-02-after-order-click');

    // 5. Shadow DOM 심층 분석
    log('\n[5] Shadow DOM 심층 분석...');
    await page.waitForTimeout(3000);
    const shadowAfter = await analyzeShadowDOM(page, 'v3-after-click');

    // 6. Shadow DOM에서 에디터 버튼 클릭
    log('\n[6] Shadow DOM에서 에디터 버튼 탐색 및 클릭...');

    // Playwright의 pierce (Shadow DOM 관통) 셀렉터 사용
    const editorKeywords = ['에디터', '에디터로', '에디터 - 무료', 'editor', '디자인 제작'];

    let editorClicked = false;
    for (const keyword of editorKeywords) {
      try {
        // pierce 셀렉터: Shadow DOM 내부까지 탐색
        const el = await page.locator(`text="${keyword}"`).first();
        if (await el.count() > 0) {
          log(`에디터 텍스트 발견: "${keyword}"`);
          await el.click({ timeout: 5000 });
          log('에디터 요소 클릭 완료');
          editorClicked = true;
          break;
        }
      } catch (e) {
        log(`  "${keyword}" 클릭 실패: ${e}`);
      }
    }

    // Shadow DOM 직접 JavaScript 클릭
    if (!editorClicked) {
      log('JavaScript로 Shadow DOM 직접 클릭 시도...');
      const clicked = await page.evaluate(() => {
        const widgetEl = document.querySelector('#widget') as HTMLElement;
        if (!widgetEl || !widgetEl.shadowRoot) return false;
        const sr = widgetEl.shadowRoot;

        // 에디터 관련 요소 찾기
        const editorKeywords = ['에디터', 'editor', '디자인'];
        for (const kw of editorKeywords) {
          const elements = Array.from(sr.querySelectorAll('button, a, li, [role="button"]'));
          for (const el of elements) {
            if ((el.textContent || '').toLowerCase().includes(kw)) {
              console.log('[CLICK_ATTEMPT]', el.tagName, el.textContent?.trim().slice(0, 50));
              (el as HTMLElement).click();
              return true;
            }
          }
        }

        // 이미지 ALT로 탐색
        for (const img of Array.from(sr.querySelectorAll('img'))) {
          const alt = img.getAttribute('alt') || '';
          if (alt.includes('에디터') || alt.includes('editor')) {
            const parent = img.closest('button, a, li, [role="button"]') || img.parentElement;
            if (parent) {
              console.log('[CLICK_IMG_PARENT]', parent.tagName, alt);
              (parent as HTMLElement).click();
              return true;
            }
          }
        }

        return false;
      });
      log(`JavaScript 클릭: ${clicked}`);
      editorClicked = clicked;
    }

    await page.waitForTimeout(5000);
    await ss(page, 'v3-03-after-editor-click');

    // 7. 에디터 클릭 후 iframe 탐색
    log('\n[7] Edicus iframe 탐색...');

    // 일반 iframe
    const iframes = await page.evaluate(() =>
      Array.from(document.querySelectorAll('iframe')).map(f => ({
        src: f.src,
        id: f.id,
        class: f.className,
      }))
    );
    log(`일반 iframe: ${iframes.length}개`);
    for (const f of iframes) {
      log(`  ${JSON.stringify(f)}`);
      if (f.src.includes('edicus') || f.src.includes('firebaseapp')) {
        edicusIframeUrls.push(f.src);
        log(`*** Edicus iframe! URL: ${f.src}`);
      }
    }

    // Shadow DOM 내부 iframe도 확인
    const shadowIframes = await page.evaluate(() => {
      const wa = document.querySelector('#widget') as HTMLElement;
      if (!wa || !wa.shadowRoot) return [];
      return Array.from(wa.shadowRoot.querySelectorAll('iframe')).map(f => ({
        src: f.src,
        id: f.id,
        class: f.className,
      }));
    });
    log(`Shadow DOM 내부 iframe: ${shadowIframes.length}개`);
    for (const f of shadowIframes) {
      log(`  Shadow iframe: ${JSON.stringify(f)}`);
      if (f.src.includes('edicus') || f.src.includes('firebaseapp')) {
        edicusIframeUrls.push(f.src);
        log(`*** Shadow DOM Edicus iframe! URL: ${f.src}`);
      }
    }

    // Playwright frames()
    const frames = page.frames();
    log(`Playwright 프레임 수: ${frames.length}`);
    for (const f of frames) {
      const url = f.url();
      if (url && url !== 'about:blank' && url !== page.url()) {
        log(`  프레임: ${url.slice(0, 200)}`);
        if (url.includes('edicus') || url.includes('firebaseapp')) {
          edicusIframeUrls.push(url);
          log(`*** Edicus 프레임! URL: ${url}`);
          // URL 파라미터 파싱
          try {
            const u = new URL(url);
            const params = Object.fromEntries(u.searchParams.entries());
            log(`  파라미터: ${JSON.stringify(params, null, 2)}`);
          } catch {}
        }
      }
    }

    // 8. postMessage 최종 수집
    log('\n[8] postMessage 수집...');
    const msgs = await page.evaluate(() => (window as any).__pmLog || []);
    log(`postMessage: ${msgs.length}개`);
    for (const m of msgs) {
      const dataStr = typeof m.data === 'object' ? JSON.stringify(m.data)?.slice(0, 200) : String(m.data).slice(0, 200);
      if (dataStr && dataStr !== '"undefined"' && dataStr !== '""') {
        log(`  [${m.dir}] ${m.origin} → ${dataStr}`);
      }
    }

    // 9. 추가 대기 후 재확인 (에디터 로딩 시간 확보)
    log('\n[9] 추가 대기 후 재확인 (10초)...');
    await page.waitForTimeout(10000);
    await ss(page, 'v3-04-final');

    const finalFrames = page.frames();
    log(`최종 프레임 수: ${finalFrames.length}`);
    for (const f of finalFrames) {
      const url = f.url();
      if (url && url !== 'about:blank' && url !== page.url()) {
        log(`  최종 프레임: ${url.slice(0, 300)}`);
        if (url.includes('edicus') || url.includes('firebaseapp')) {
          if (!edicusIframeUrls.includes(url)) edicusIframeUrls.push(url);
          log(`  *** Edicus URL 파라미터: ***`);
          try {
            const u = new URL(url);
            const params = Object.fromEntries(u.searchParams.entries());
            log(JSON.stringify(params, null, 2));
            fs.writeFileSync(path.join(OUT, 'edicus-iframe-params.json'), JSON.stringify(params, null, 2));
          } catch {}
        }
      }
    }

    // 결과 저장
    const report = {
      timestamp: new Date().toISOString(),
      summary: {
        edicusIframesFound: edicusIframeUrls.length,
        totalNetworkRequests: networkRequests.length,
        postMessagesCapured: msgs.length,
      },
      sdkInitCalls: initCalls,
      edicusIframeUrls,
      networkRequests,
      postMessages: msgs.filter((m: any) => m.data && m.data !== 'undefined' && m.data !== ''),
      shadowDOMBefore: shadowBefore,
      shadowDOMAfter: shadowAfter,
    };
    fs.writeFileSync(path.join(OUT, 'v3-analysis.json'), JSON.stringify(report, null, 2));
    log('\n결과 저장 완료: v3-analysis.json');

  } catch (e) {
    log(`오류: ${e}`);
    await ss(page, 'v3-ERROR').catch(() => {});
  } finally {
    await browser.close();
    log('\n=== v3 분석 완료 ===');
    log(`Edicus iframe: ${edicusIframeUrls.length}개`);
    for (const url of edicusIframeUrls) log(`  ${url}`);
  }
}

main().catch(console.error);
