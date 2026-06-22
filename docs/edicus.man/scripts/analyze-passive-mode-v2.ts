/**
 * 레드프린팅 Passive Mode 완전 분석 v2
 * 개선: widget-area 내부 탐색, 에디터 버튼 클릭, 더 긴 대기
 * SPEC-PASSIVE-001 Phase A
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

const networkRequests: Array<{ method: string; url: string; type: string }> = [];
const postMessages: Array<{ origin: string; data: unknown; timestamp: number; direction: string }> = [];

function log(msg: string) {
  const ts = new Date().toLocaleTimeString('ko-KR');
  console.log(`[${ts}] ${msg}`);
}

async function ss(page: Page, name: string) {
  await page.screenshot({ path: path.join(OUT, `${name}.png`), fullPage: true });
  log(`스크린샷: ${name}.png`);
}

async function analyzeWidgetArea(page: Page, label: string) {
  const info = await page.evaluate(() => {
    // widget-area 내부 분석
    const widgetArea = document.querySelector('.widget-area') || document.querySelector('[class*="widget"]');
    if (!widgetArea) return { found: false, html: '' };

    // 내부 모든 요소
    const children = Array.from(widgetArea.querySelectorAll('*')).map(el => ({
      tag: el.tagName,
      id: el.id,
      class: el.className.slice(0, 80),
      text: el.textContent?.trim().slice(0, 80),
      visible: !!(el as HTMLElement).offsetParent,
    }));

    // iframe 목록 (widget 내부 포함 전체)
    const allIframes = Array.from(document.querySelectorAll('iframe')).map(f => ({
      src: f.src.slice(0, 300),
      id: f.id,
      class: f.className,
    }));

    // widget 내부의 버튼/링크
    const widgetBtns = Array.from(widgetArea.querySelectorAll('button, a, [onclick], [role="button"]')).map(el => ({
      tag: el.tagName,
      text: el.textContent?.trim().slice(0, 60),
      class: el.className.slice(0, 60),
      onclick: el.getAttribute('onclick')?.slice(0, 100),
    }));

    // 이미지 목록 (에디터 아이콘 등)
    const widgetImgs = Array.from(widgetArea.querySelectorAll('img')).map(img => ({
      src: img.getAttribute('src')?.slice(0, 200),
      alt: img.getAttribute('alt'),
    }));

    return {
      found: true,
      html: widgetArea.innerHTML.slice(0, 2000),
      childrenCount: children.length,
      children: children.slice(0, 30),
      allIframes,
      widgetBtns,
      widgetImgs,
      bodyClassList: Array.from(document.body.classList),
    };
  });

  log(`\n[${label}] widget-area 분석:`);
  log(`  발견: ${info.found}, 자식 요소 수: ${info.childrenCount}`);
  if (info.found && info.childrenCount > 0) {
    log(`  내부 버튼: ${JSON.stringify(info.widgetBtns, null, 2)}`);
    log(`  내부 이미지: ${JSON.stringify(info.widgetImgs, null, 2)}`);
    log(`  iframe 전체: ${JSON.stringify(info.allIframes, null, 2)}`);
  }
  if (info.html) {
    fs.writeFileSync(path.join(OUT, `${label}-widget-html.html`), info.html);
    log(`  HTML 저장: ${label}-widget-html.html`);
  }
  return info;
}

async function main() {
  log('=== 레드프린팅 Passive Mode 분석 v2 ===');

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

  // postMessage 모니터링 - 모든 페이지에 주입
  await ctx.addInitScript(() => {
    const log: Array<{ origin: string; data: unknown; ts: number; dir: string }> = [];
    (window as any).__pmLog = log;

    window.addEventListener('message', (e) => {
      try { log.push({ origin: e.origin, data: e.data, ts: Date.now(), dir: 'in' }); } catch {}
    });

    const orig = window.postMessage.bind(window);
    window.postMessage = function(msg: unknown, target: unknown, tr?: unknown) {
      try { log.push({ origin: location.origin, data: msg, ts: Date.now(), dir: 'out' }); } catch {}
      return orig(msg, target as string, tr as Transferable[]);
    };

    // SDK 감지 + init() 인터셉션
    ['RedWidgetSDK', 'redWidgetSDK', 'EdicusSDK', 'edicusSDK'].forEach(name => {
      let v: unknown;
      Object.defineProperty(window, name, {
        get() { return v; },
        set(val: unknown) {
          // init() 메서드 래핑으로 호출 파라미터 캡처
          if (typeof val === 'function' && val.prototype && val.prototype.init) {
            const origInit = val.prototype.init;
            val.prototype.init = function(options: unknown, callback: unknown) {
              console.log(`[SDK_INIT] ${name}.init() 호출:`, JSON.stringify(options)?.slice(0, 500));
              (window as any).__sdkInitCalls = (window as any).__sdkInitCalls || [];
              (window as any).__sdkInitCalls.push({ name, options, timestamp: Date.now() });
              return origInit.call(this, options, callback);
            };
          }
          v = val;
          console.log(`[SDK_SET] ${name}`, typeof val);
          (window as any).__sdkLog = (window as any).__sdkLog || {};
          (window as any).__sdkLog[name] = {
            type: typeof val,
            proto: typeof val === 'function' ? Object.getOwnPropertyNames((val as any).prototype || {}) : [],
            src: String(val).slice(0, 500),
          };
        },
        configurable: true,
      });
    });
  });

  // 네트워크 요청 캡처
  ctx.on('request', (req) => {
    const url = req.url();
    if (url.includes('edicus') || url.includes('widget') || url.includes('cloudfront') || url.includes('edicusbase')) {
      networkRequests.push({ method: req.method(), url, type: req.resourceType() });
      log(`네트워크: ${req.method()} ${url.slice(0, 150)}`);
    }
  });

  const page = await ctx.newPage();

  page.on('console', msg => {
    const t = msg.text();
    if (t.includes('SDK') || t.includes('edicus') || t.includes('widget') || t.includes('run_mode') || t.includes('passive')) {
      log(`콘솔[${msg.type()}]: ${t.slice(0, 200)}`);
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
    log(`로그인 후 URL: ${page.url()}`);
    await ss(page, 'v2-01-after-login');

    // 2. 상품 페이지
    log('\n[2] 상품 페이지...');
    await page.goto('https://m.redprinting.co.kr/product/item/ST/STPAUNM', { waitUntil: 'networkidle', timeout: 30000 });
    await ss(page, 'v2-02-product');

    // SDK 상태 확인
    const sdkBefore = await page.evaluate(() => (window as any).__sdkLog || {});
    log(`SDK 로드 상태 (상품페이지): ${JSON.stringify(sdkBefore, null, 2)}`);

    // 3. "주문하기" 클릭
    log('\n[3] 주문하기 클릭...');
    await page.click('button:has-text("주문하기")');

    // widget-area에 콘텐츠 로딩 대기 (최대 20초)
    log('widget-area 콘텐츠 로딩 대기...');
    const widgetLoaded = await page.waitForFunction(() => {
      const wa = document.querySelector('.widget-area');
      if (!wa) return false;
      const children = wa.querySelectorAll('*');
      const hasText = wa.innerText?.trim().length > 10;
      return children.length > 2 || hasText;
    }, { timeout: 20000 }).catch(() => {
      log('widget-area 로딩 타임아웃 (20초)');
      return null;
    });
    log(`widget-area 로딩: ${widgetLoaded ? '성공' : '실패'}`);

    await ss(page, 'v2-03-after-order-widget');

    // SDK init 호출 확인
    const sdkInitCalls = await page.evaluate(() => (window as any).__sdkInitCalls || []);
    log(`SDK init() 호출: ${sdkInitCalls.length}개`);
    if (sdkInitCalls.length > 0) {
      log(`init 파라미터: ${JSON.stringify(sdkInitCalls, null, 2)}`);
    }

    // 추가 대기 및 스크린샷
    for (let i = 1; i <= 3; i++) {
      await page.waitForTimeout(5000);
      await ss(page, `v2-03-after-order-${i * 5}s`);
      log(`추가 대기 ${i * 5}초 경과...`);

      const info = await analyzeWidgetArea(page, `after-order-${i * 5}s`);
      if (info.found && info.widgetBtns.length > 0) {
        log(`위젯 버튼 발견! 중단.`);
        break;
      }
    }

    // 4. widget-area 심층 분석
    log('\n[4] widget-area 심층 HTML 분석...');
    const widgetHtmlFull = await page.evaluate(() => {
      const wa = document.querySelector('.widget-area');
      return wa ? wa.outerHTML : 'NOT FOUND';
    });
    fs.writeFileSync(path.join(OUT, 'widget-area-full.html'), widgetHtmlFull);
    log(`widget-area HTML 저장 (${widgetHtmlFull.length} chars)`);

    // 전체 페이지 HTML 저장 (분석용)
    const fullHTML = await page.content();
    const relevantHTML = fullHTML.includes('widget') ? fullHTML.split('widget-area')[1]?.slice(0, 5000) : 'widget-area not found';
    log(`페이지 내 widget-area 발견: ${fullHTML.includes('widget-area')}`);

    // 5. iframe 전체 확인
    log('\n[5] iframe 전체 목록...');
    const allIframes = await page.evaluate(() =>
      Array.from(document.querySelectorAll('iframe')).map(f => ({
        src: f.src,
        id: f.id,
        class: f.className,
        name: f.name,
        allow: f.getAttribute('allow'),
        sandbox: f.getAttribute('sandbox'),
      }))
    );
    log(`iframe 수: ${allIframes.length}`);
    for (const f of allIframes) {
      log(`  iframe: ${JSON.stringify(f)}`);
    }

    // 6. 에디터 진입 버튼 찾기 (넓은 범위)
    log('\n[6] 에디터 버튼 넓은 탐색...');
    const editorBtnAnalysis = await page.evaluate(() => {
      // 모든 클릭 가능한 요소
      const clickable = Array.from(document.querySelectorAll('button, a, [onclick], [class*="btn"], [role="button"], li[class*="item"]'));

      const editorKeywords = ['에디터', 'editor', '디자인 제작', '직접 제작', '만들기', '제작하기', 'design'];
      const matches = clickable.filter(el => {
        const text = (el.textContent || '').trim().toLowerCase();
        const cls = (el.className || '').toLowerCase();
        const onclick = (el.getAttribute('onclick') || '').toLowerCase();
        return editorKeywords.some(k => text.includes(k) || cls.includes(k) || onclick.includes(k));
      }).map(el => ({
        tag: el.tagName,
        text: el.textContent?.trim().slice(0, 80),
        class: el.className.slice(0, 80),
        onclick: el.getAttribute('onclick')?.slice(0, 100),
        href: el.getAttribute('href'),
        visible: (el as HTMLElement).offsetHeight > 0,
      }));

      // 이미지로 에디터 아이콘 찾기
      const editorImgs = Array.from(document.querySelectorAll('img[src*="editor"], img[alt*="에디터"], img[alt*="editor"]'))
        .map(img => ({
          src: img.getAttribute('src')?.slice(0, 200),
          alt: img.getAttribute('alt'),
          parentTag: img.parentElement?.tagName,
          parentClass: img.parentElement?.className.slice(0, 60),
          parentOnclick: img.parentElement?.getAttribute('onclick')?.slice(0, 100),
        }));

      // 페이지 전체 텍스트에서 에디터 관련 부분 추출
      const bodyText = document.body.innerText;
      const lines = bodyText.split('\n').filter(l => {
        const lower = l.toLowerCase();
        return editorKeywords.some(k => lower.includes(k));
      }).slice(0, 20);

      return { matches, editorImgs, lines };
    });

    log(`에디터 버튼 매칭: ${editorBtnAnalysis.matches.length}개`);
    log(`에디터 버튼 목록: ${JSON.stringify(editorBtnAnalysis.matches, null, 2)}`);
    log(`에디터 이미지: ${JSON.stringify(editorBtnAnalysis.editorImgs, null, 2)}`);
    log(`에디터 텍스트 라인: ${JSON.stringify(editorBtnAnalysis.lines, null, 2)}`);

    // 7. 에디터 버튼 클릭 시도
    log('\n[7] 에디터 버튼 클릭 시도...');
    const clickSelectors = [
      'img[src*="editor"]',
      '[alt*="에디터"]',
      ':has-text("에디터로 디자인")',
      ':has-text("에디터")',
      ':has-text("editor")',
      '[class*="editor-btn"]',
      '[class*="design-btn"]',
    ];

    let clicked = false;
    for (const sel of clickSelectors) {
      const el = await page.$(sel).catch(() => null);
      if (el) {
        const text = await el.textContent().catch(() => '');
        log(`클릭 시도: "${sel}" → "${text?.trim().slice(0, 50)}"`);
        await el.click().catch(e => log(`  클릭 실패: ${e}`));
        await page.waitForTimeout(5000);
        await ss(page, `v2-07-after-editor-click`);
        clicked = true;

        // 클릭 후 iframe 확인
        const framesAfter = page.frames();
        log(`클릭 후 프레임 수: ${framesAfter.length}`);
        for (const f of framesAfter) {
          const fUrl = f.url();
          if (fUrl && fUrl !== 'about:blank') {
            log(`  프레임: ${fUrl.slice(0, 200)}`);
          }
        }
        break;
      }
    }

    if (!clicked) {
      log('에디터 버튼 미발견 - 전체 페이지 HTML 저장');
      fs.writeFileSync(path.join(OUT, 'full-page.html'), await page.content());
    }

    // 8. postMessage 최종 수집
    log('\n[8] postMessage 최종 수집...');
    const msgs = await page.evaluate(() => (window as any).__pmLog || []);
    log(`postMessage 총: ${msgs.length}개`);
    for (const m of msgs) {
      const dataStr = JSON.stringify(m.data)?.slice(0, 150) || '';
      log(`  [${m.dir}] ${m.origin} → ${dataStr}`);
    }

    // 9. SDK 최종 상태
    log('\n[9] SDK 최종 상태...');
    const sdkFinal = await page.evaluate(() => {
      const sdk = (window as any).__sdkLog || {};
      const rw = (window as any).RedWidgetSDK;
      return {
        sdkLog: sdk,
        RedWidgetSDK: rw ? {
          type: typeof rw,
          protoMethods: typeof rw === 'function' ? Object.getOwnPropertyNames(rw.prototype || {}) : [],
          source: String(rw).slice(0, 1000),
        } : null,
      };
    });
    log(`SDK 최종: ${JSON.stringify(sdkFinal, null, 2).slice(0, 2000)}`);

    // 결과 저장
    const report = {
      timestamp: new Date().toISOString(),
      networkRequests,
      postMessages: msgs,
      sdkFinal,
      editorBtnAnalysis,
      allIframes,
    };
    fs.writeFileSync(path.join(OUT, 'v2-analysis.json'), JSON.stringify(report, null, 2));
    log('\n결과 저장 완료');

  } catch (e) {
    log(`오류: ${e}`);
    await ss(page, 'ERROR').catch(() => {});
  } finally {
    await browser.close();
    log('\n=== v2 분석 완료 ===');
  }
}

main().catch(console.error);
