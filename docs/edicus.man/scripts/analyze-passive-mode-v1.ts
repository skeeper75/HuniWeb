/**
 * 레드프린팅 Passive Mode 완전 분석 v1
 * 목표: RedWidgetSDK 팝업 자동화 → Edicus iframe URL 파라미터 캡처
 * SPEC-PASSIVE-001 Phase A
 */
import { chromium, Page, BrowserContext } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

// .env.local 파싱
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

// 전역 수집 데이터
const networkRequests: Array<{ method: string; url: string; type: string; timestamp: number }> = [];
const postMessages: Array<{ origin: string; data: unknown; timestamp: number; direction: string }> = [];
const consoleLogs: string[] = [];
const edicusIframeUrls: string[] = [];

function log(msg: string) {
  const ts = new Date().toLocaleTimeString('ko-KR');
  console.log(`[${ts}] ${msg}`);
}

async function injectMonitoring(page: Page) {
  // 1. postMessage 모니터링 주입
  await page.addInitScript(() => {
    const messageLog: Array<{ origin: string; data: unknown; timestamp: number; direction: string }> = [];
    (window as any).__postMessageLog = messageLog;

    // 수신 메시지 캡처
    window.addEventListener('message', (event) => {
      try {
        messageLog.push({
          origin: event.origin,
          data: event.data,
          timestamp: Date.now(),
          direction: 'incoming',
        });
      } catch {}
    });

    // 발신 메시지 캡처 (window.postMessage 래핑)
    const origPostMessage = window.postMessage.bind(window);
    window.postMessage = function(message: unknown, targetOrigin: unknown, transfer?: unknown) {
      try {
        messageLog.push({
          origin: window.location.origin,
          data: message,
          timestamp: Date.now(),
          direction: 'outgoing',
        });
      } catch {}
      return origPostMessage(message, targetOrigin as string, transfer as Transferable[]);
    };

    // SDK 글로벌 객체 모니터링
    const sdkNames = ['RedWidgetSDK', 'redWidgetSDK', 'EdicusSDK', 'edicusSDK', 'EditorSDK'];
    for (const name of sdkNames) {
      let _val: unknown;
      Object.defineProperty(window, name, {
        get() { return _val; },
        set(value: unknown) {
          _val = value;
          (window as any).__sdkDetected = (window as any).__sdkDetected || {};
          (window as any).__sdkDetected[name] = {
            type: typeof value,
            keys: typeof value === 'object' && value !== null ? Object.keys(value as object).slice(0, 50) : [],
            timestamp: Date.now(),
          };
          console.log(`[SDK_DETECTED] ${name} set:`, typeof value);
        },
        configurable: true,
      });
    }
  });
}

async function setupNetworkMonitoring(page: Page) {
  // 모든 네트워크 요청 캡처
  page.on('request', (req) => {
    const url = req.url();
    networkRequests.push({
      method: req.method(),
      url,
      type: req.resourceType(),
      timestamp: Date.now(),
    });
  });

  // 콘솔 메시지 캡처
  page.on('console', (msg) => {
    const text = msg.text();
    if (text.includes('SDK') || text.includes('edicus') || text.includes('widget') ||
        text.includes('passive') || text.includes('postMessage') || text.includes('iframe') ||
        text.includes('run_mode') || text.includes('private_css') || text.includes('editor')) {
      consoleLogs.push(`[${msg.type().toUpperCase()}] ${text}`);
      log(`콘솔: ${text.slice(0, 200)}`);
    }
  });
}

async function screenshot(page: Page, name: string) {
  const filePath = path.join(OUT, `${name}.png`);
  await page.screenshot({ path: filePath, fullPage: true });
  log(`스크린샷 저장: ${name}.png`);
  return filePath;
}

async function main() {
  log('=== 레드프린팅 Passive Mode 완전 분석 v1 ===');
  log(`URL: ${ENV.REDPRINTING_URL}`);
  log(`사용자: ${ENV.REDPRINTING_USERNAME}`);

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-web-security', '--disable-features=VizDisplayCompositor'],
  });

  const ctx: BrowserContext = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
  });

  // 새 페이지 이벤트 감지
  ctx.on('page', async (newPage) => {
    log(`새 페이지 열림: ${newPage.url()}`);
    await setupNetworkMonitoring(newPage);
    await injectMonitoring(newPage);
  });

  const page = await ctx.newPage();
  await setupNetworkMonitoring(page);
  await injectMonitoring(page);

  try {
    // ===== Phase 1: 로그인 =====
    log('\n[Phase 1] 로그인...');
    await page.goto('https://m.redprinting.co.kr/member/login', {
      waitUntil: 'networkidle',
      timeout: 30000,
    });

    await screenshot(page, '01-login-page');

    await page.fill('#mb_id', ENV.REDPRINTING_USERNAME);
    await page.fill('#password', ENV.REDPRINTING_PASSWORD);
    await screenshot(page, '02-login-filled');

    await page.click('button:has-text("로그인")');
    await page.waitForTimeout(3000);
    await page.waitForLoadState('networkidle').catch(() => {});

    log(`로그인 후 URL: ${page.url()}`);
    await screenshot(page, '03-after-login');

    const loginState = await page.evaluate(() => ({
      url: window.location.href,
      hasLogout: !!document.querySelector('a[href*="logout"]'),
      hasMypage: !!document.querySelector('a[href*="mypage"]'),
    }));
    log(`로그인 상태: ${JSON.stringify(loginState)}`);

    // ===== Phase 2: 상품 페이지 =====
    log('\n[Phase 2] 상품 페이지 접속...');
    // 네임스티커 상품
    await page.goto('https://m.redprinting.co.kr/product/item/ST/STPAUNM', {
      waitUntil: 'networkidle',
      timeout: 30000,
    });
    await screenshot(page, '04-product-page');

    // 상품 페이지 구조 분석
    const productInfo = await page.evaluate(() => ({
      url: window.location.href,
      title: document.title,
      buttons: Array.from(document.querySelectorAll('button, a')).map(el => ({
        tag: el.tagName,
        text: el.textContent?.trim().slice(0, 60),
        class: el.className?.slice(0, 60),
        href: el.getAttribute('href'),
      })).filter(b => b.text && b.text.length > 0).slice(0, 30),
      scripts: Array.from(document.querySelectorAll('script[src]'))
        .map(s => s.getAttribute('src'))
        .filter(Boolean),
    }));
    log(`상품 페이지 버튼: ${JSON.stringify(productInfo.buttons.filter(b =>
      b.text && (b.text.includes('주문') || b.text.includes('제작') || b.text.includes('편집') || b.text.includes('디자인'))
    ), null, 2)}`);

    // ===== Phase 3: 주문하기 클릭 =====
    log('\n[Phase 3] 주문하기 버튼 클릭...');

    // "주문하기" 버튼 찾기 (다양한 셀렉터 시도)
    const orderSelectors = [
      'button:has-text("주문하기")',
      'a:has-text("주문하기")',
      '[class*="order"]:has-text("주문")',
      'button:has-text("주문")',
      '.btn-order',
      '#btn-order',
    ];

    let orderBtnFound = false;
    for (const sel of orderSelectors) {
      const btn = await page.$(sel);
      if (btn) {
        log(`주문 버튼 발견: "${sel}"`);
        orderBtnFound = true;

        // 클릭 전 상태 저장
        await screenshot(page, '05-before-order-click');

        // 네트워크 요청 초기화 (클릭 후 새 요청만 추적)
        const requestsBeforeClick = networkRequests.length;

        // 클릭
        await btn.click();
        log('주문 버튼 클릭 완료, 5초 대기...');
        await page.waitForTimeout(5000);

        await screenshot(page, '06-after-order-click');
        log(`클릭 후 URL: ${page.url()}`);
        log(`새 네트워크 요청: ${networkRequests.length - requestsBeforeClick}개`);

        // 새 요청 중 widget/editor 관련 URL 출력
        const newRequests = networkRequests.slice(requestsBeforeClick);
        for (const req of newRequests) {
          if (req.url.includes('widget') || req.url.includes('edicus') || req.url.includes('editor')) {
            log(`  → ${req.method} ${req.url.slice(0, 200)}`);
          }
        }

        break;
      }
    }

    if (!orderBtnFound) {
      log('주문 버튼 없음, 버튼 목록 재확인...');
      const allBtns = await page.evaluate(() =>
        Array.from(document.querySelectorAll('button')).map(b => ({
          text: b.textContent?.trim().slice(0, 50),
          class: b.className?.slice(0, 50),
          id: b.id,
        }))
      );
      log(`모든 버튼: ${JSON.stringify(allBtns, null, 2)}`);
    }

    // ===== Phase 4: RedWidgetSDK 팝업 분석 =====
    log('\n[Phase 4] RedWidgetSDK 팝업 분석...');

    // 팝업/모달 찾기
    const popupInfo = await page.evaluate(() => {
      // 1. iframe 목록
      const iframes = Array.from(document.querySelectorAll('iframe')).map(f => ({
        src: f.src,
        id: f.id,
        class: f.className,
        width: f.width,
        height: f.height,
      }));

      // 2. 팝업/모달 찾기
      const popups = Array.from(document.querySelectorAll('[class*="popup"], [class*="modal"], [class*="overlay"], [class*="layer"], [class*="widget"]'))
        .filter(el => {
          const style = window.getComputedStyle(el);
          return style.display !== 'none' && style.visibility !== 'hidden';
        })
        .map(el => ({
          tag: el.tagName,
          id: el.id,
          class: el.className.slice(0, 100),
          text: el.textContent?.trim().slice(0, 100),
          childCount: el.children.length,
        })).slice(0, 10);

      // 3. SDK 글로벌 변수 확인
      const sdkKeys = Object.keys(window).filter(k =>
        k.toLowerCase().includes('widget') || k.toLowerCase().includes('edicus') ||
        k.toLowerCase().includes('sdk') || k.toLowerCase().includes('editor') || k.toLowerCase().includes('red')
      );

      // 4. 에디터 관련 버튼/링크 재탐색
      const editorLinks = Array.from(document.querySelectorAll('button, a, [onclick], [class*="btn"]'))
        .filter(el => {
          const text = el.textContent?.trim() || '';
          const cls = el.className || '';
          return text.includes('에디터') || text.includes('editor') || text.includes('디자인 제작') ||
                 text.includes('만들기') || cls.includes('editor') || el.getAttribute('onclick')?.includes('editor');
        })
        .map(el => ({
          tag: el.tagName,
          text: el.textContent?.trim().slice(0, 80),
          class: el.className.slice(0, 80),
          href: el.getAttribute('href'),
          onclick: el.getAttribute('onclick')?.slice(0, 200),
        })).slice(0, 10);

      // 5. 페이지 전체 텍스트에서 "에디터" 포함 요소
      const editorTextElements = Array.from(document.querySelectorAll('*'))
        .filter(el => {
          const text = el.textContent?.trim() || '';
          return text.includes('에디터로') || text.includes('에디터 제작') || text.includes('에디터 디자인');
        })
        .map(el => ({
          tag: el.tagName,
          text: el.textContent?.trim().slice(0, 80),
          class: el.className.slice(0, 60),
        })).slice(0, 10);

      return {
        iframes,
        popups,
        sdkKeys: sdkKeys.slice(0, 20),
        sdkDetected: (window as any).__sdkDetected || {},
        editorLinks,
        editorTextElements,
        postMessageCount: ((window as any).__postMessageLog || []).length,
        pageUrl: window.location.href,
        totalElements: document.querySelectorAll('*').length,
      };
    });

    log(`iframes: ${popupInfo.iframes.length}개`);
    if (popupInfo.iframes.length > 0) {
      log(`iframe 목록: ${JSON.stringify(popupInfo.iframes, null, 2)}`);
    }
    log(`팝업/모달: ${popupInfo.popups.length}개`);
    if (popupInfo.popups.length > 0) {
      log(`팝업 목록: ${JSON.stringify(popupInfo.popups, null, 2)}`);
    }
    log(`SDK 글로벌 변수: ${JSON.stringify(popupInfo.sdkKeys)}`);
    log(`SDK 감지 결과: ${JSON.stringify(popupInfo.sdkDetected, null, 2)}`);
    log(`에디터 관련 링크: ${JSON.stringify(popupInfo.editorLinks, null, 2)}`);
    log(`에디터 텍스트 요소: ${JSON.stringify(popupInfo.editorTextElements, null, 2)}`);
    log(`postMessage 이벤트: ${popupInfo.postMessageCount}개`);

    // ===== Phase 5: Edicus iframe 탐색 =====
    log('\n[Phase 5] Edicus iframe 탐색...');

    // iframes 중 Edicus 관련 찾기
    for (const iframe of popupInfo.iframes) {
      if (iframe.src.includes('edicus') || iframe.src.includes('edicusbase') || iframe.src.includes('firebaseapp')) {
        log(`*** Edicus iframe 발견! ***`);
        log(`URL: ${iframe.src}`);
        edicusIframeUrls.push(iframe.src);

        // URL 파라미터 파싱
        try {
          const url = new URL(iframe.src);
          const params = Object.fromEntries(url.searchParams.entries());
          log(`Edicus iframe 파라미터: ${JSON.stringify(params, null, 2)}`);
        } catch {}
      }
    }

    // 프레임 목록 확인
    const frames = page.frames();
    log(`\n프레임 수: ${frames.length}`);
    for (const frame of frames) {
      const frameUrl = frame.url();
      if (frameUrl && frameUrl !== 'about:blank' && frameUrl !== page.url()) {
        log(`프레임 URL: ${frameUrl.slice(0, 200)}`);
        if (frameUrl.includes('edicus') || frameUrl.includes('edicusbase') || frameUrl.includes('firebaseapp')) {
          log(`*** Edicus 프레임 발견! ***`);
          edicusIframeUrls.push(frameUrl);
        }
      }
    }

    // ===== Phase 6: 에디터 버튼 클릭 시도 =====
    log('\n[Phase 6] 에디터 진입 버튼 클릭 시도...');

    if (popupInfo.editorLinks.length > 0 || popupInfo.editorTextElements.length > 0) {
      const editorSelectors = [
        ':has-text("에디터로 디자인")',
        ':has-text("에디터로 제작")',
        ':has-text("에디터 디자인")',
        ':has-text("에디터로")',
        '[class*="editor"]',
        'img[src*="editor"]',
        'button:has-text("에디터")',
      ];

      for (const sel of editorSelectors) {
        const el = await page.$(sel);
        if (el) {
          const text = await el.textContent();
          log(`에디터 버튼 발견: "${sel}" → "${text?.trim().slice(0, 50)}"`);
          await el.click();
          log('에디터 버튼 클릭, 5초 대기...');
          await page.waitForTimeout(5000);
          await screenshot(page, '07-after-editor-click');

          // 새 iframes 확인
          const newFrames = page.frames();
          for (const f of newFrames) {
            const fUrl = f.url();
            if (fUrl.includes('edicus') || fUrl.includes('firebaseapp')) {
              log(`*** 에디터 클릭 후 Edicus 프레임 발견! ***`);
              log(`URL: ${fUrl}`);
              edicusIframeUrls.push(fUrl);
            }
          }
          break;
        }
      }
    }

    // ===== Phase 7: postMessage 이벤트 수집 =====
    log('\n[Phase 7] postMessage 이벤트 수집...');
    const capturedMessages = await page.evaluate(() => (window as any).__postMessageLog || []);
    log(`총 postMessage 이벤트: ${capturedMessages.length}개`);
    for (const msg of capturedMessages.slice(0, 20)) {
      log(`  [${msg.direction}] origin=${msg.origin} data=${JSON.stringify(msg.data)?.slice(0, 100)}`);
    }

    // ===== Phase 8: RedWidgetSDK API 분석 =====
    log('\n[Phase 8] SDK 글로벌 상태 분석...');
    const sdkState = await page.evaluate(() => {
      const result: Record<string, unknown> = {};

      // RedWidgetSDK 분석
      for (const name of ['RedWidgetSDK', 'redWidgetSDK', 'EdicusSDK', 'edicusSDK']) {
        const sdk = (window as any)[name];
        if (sdk) {
          result[name] = {
            type: typeof sdk,
            isFunction: typeof sdk === 'function',
            keys: typeof sdk === 'object' ? Object.getOwnPropertyNames(sdk).slice(0, 50) : [],
            prototype: typeof sdk === 'function' ?
              Object.getOwnPropertyNames(sdk.prototype || {}).slice(0, 30) : [],
            toString: String(sdk).slice(0, 200),
          };
        }
      }

      // 레드프린팅 Nuxt 앱 데이터
      const nuxt = (window as any).__NUXT__;
      if (nuxt) {
        result.__NUXT_KEYS__ = Object.keys(nuxt).slice(0, 20);
      }

      return result;
    });
    log(`SDK 상태: ${JSON.stringify(sdkState, null, 2)}`);

    // ===== Phase 9: 최종 네트워크 분석 =====
    log('\n[Phase 9] 네트워크 분석...');
    const edicusRequests = networkRequests.filter(r =>
      r.url.includes('edicus') || r.url.includes('edicusbase') || r.url.includes('firebaseapp') ||
      r.url.includes('widget.js') || r.url.includes('widget.css')
    );
    log(`Edicus/Widget 관련 요청: ${edicusRequests.length}개`);
    for (const req of edicusRequests) {
      log(`  [${req.method}] ${req.url.slice(0, 200)}`);
    }

    // ===== 결과 저장 =====
    log('\n결과 저장 중...');
    const report = {
      timestamp: new Date().toISOString(),
      summary: {
        loginSuccess: loginState.hasLogout || loginState.hasMypage,
        edicusIframesFound: edicusIframeUrls.length,
        totalNetworkRequests: networkRequests.length,
        edicusNetworkRequests: edicusRequests.length,
        postMessagesCapured: capturedMessages.length,
        consoleLogs: consoleLogs.length,
      },
      edicusIframeUrls,
      edicusNetworkRequests: edicusRequests,
      postMessages: capturedMessages.slice(0, 50),
      consoleLogs,
      sdkState,
      popupInfo,
      allNetworkRequests: networkRequests,
    };

    fs.writeFileSync(
      path.join(OUT, 'passive-mode-analysis.json'),
      JSON.stringify(report, null, 2),
    );
    log(`분석 결과 저장: ${path.join(OUT, 'passive-mode-analysis.json')}`);

  } catch (error) {
    log(`오류 발생: ${error}`);
    await screenshot(page, 'ERROR-state').catch(() => {});
  } finally {
    await browser.close();
    log('\n=== 분석 완료 ===');
    log(`Edicus iframe URLs: ${edicusIframeUrls.length}개`);
    if (edicusIframeUrls.length > 0) {
      for (const url of edicusIframeUrls) {
        log(`  ${url}`);
      }
    }
  }
}

main().catch(console.error);
