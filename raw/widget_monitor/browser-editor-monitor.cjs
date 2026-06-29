/**
 * RedPrinting Editor API Monitor
 * - 새 위젯 상품 페이지에서 에디터 버튼 클릭
 * - 모든 네트워크 요청(URL, method, body, response) 캡처
 * - Shadow DOM 내 에디터 관련 DOM 구조 분석
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = __dirname;
const TARGET_PRODUCT = process.argv[2] || 'GSTGMIC';

// 카탈로그에서 실제 URL 조회
let PAGE_URL;
try {
  const catalog = JSON.parse(require('fs').readFileSync(path.join(__dirname, 'redprinting_catalog.json'), 'utf8'));
  const found = (catalog.products || catalog).find(p => p.pdtCode === TARGET_PRODUCT);
  PAGE_URL = found ? found.url : `https://www.redprinting.co.kr/ko/product/item/GS/${TARGET_PRODUCT}`;
} catch {
  PAGE_URL = `https://www.redprinting.co.kr/ko/product/item/GS/${TARGET_PRODUCT}`;
}
console.log(`URL: ${PAGE_URL}`);

async function run() {
  const browser = await chromium.launch({ headless: false, slowMo: 300 });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36',
    viewport: { width: 1440, height: 900 }
  });

  const allRequests = [];

  // ── 모든 네트워크 요청 캡처 ──────────────────────────
  context.on('request', req => {
    allRequests.push({
      ts: Date.now(),
      method: req.method(),
      url: req.url(),
      headers: req.headers(),
      postData: req.postData() || null
    });
  });

  context.on('response', async resp => {
    const url = resp.url();
    const entry = allRequests.find(r => r.url === url && !r.status);
    if (entry) {
      entry.status = resp.status();
      // editor/iframe 관련 응답은 body 캡처
      if (url.includes('editor') || url.includes('Editor') || url.includes('iframe') ||
          url.includes('token') || url.includes('auth') || url.includes('template') ||
          url.includes('project') || url.includes('init')) {
        try { entry.responseBody = await resp.text(); } catch {}
      }
    }
  });

  const page = await context.newPage();

  console.log(`\n[1] 페이지 이동: ${PAGE_URL}`);
  await page.goto(PAGE_URL, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(6000);

  // ── 위젯 + SDK 감지 ────────────────────────────────
  const sdkLoaded = await page.evaluate(() => {
    return !!document.querySelector('script[src*="productRedWidgetSDK"]') ||
           !!document.querySelector('script[src*="RedEditorSDK"]') ||
           !!document.getElementById('redWidgetSdk');
  });
  console.log(`[2] SDK 감지: ${sdkLoaded}`);

  // ── Shadow DOM 구조 분석 ───────────────────────────
  const shadowInfo = await page.evaluate(() => {
    function scanShadow(root, depth = 0) {
      const info = [];
      root.querySelectorAll('*').forEach(el => {
        if (el.shadowRoot) {
          const buttons = [];
          el.shadowRoot.querySelectorAll('button, a, [role=button]').forEach(btn => {
            const txt = (btn.textContent || '').trim().slice(0, 60);
            const cls = btn.className || '';
            if (txt) buttons.push({ tag: btn.tagName, text: txt, cls });
          });
          info.push({
            host: el.tagName + '#' + el.id,
            depth,
            buttonsFound: buttons.length,
            buttons: buttons.slice(0, 20)
          });
        }
      });
      return info;
    }
    return scanShadow(document);
  });
  console.log('[3] Shadow DOM 버튼:', JSON.stringify(shadowInfo, null, 2));

  // ── 에디터 버튼 탐색 ──────────────────────────────
  const editorBtn = await page.evaluate(() => {
    const keywords = ['에디터', '편집', 'editor', 'Editor', '디자인', 'design'];
    function findInRoot(root) {
      const all = root.querySelectorAll('button, a, [role=button], div[onclick]');
      for (const el of all) {
        const txt = (el.textContent || '').trim();
        const aria = el.getAttribute('aria-label') || '';
        const cls = el.className || '';
        if (keywords.some(k => txt.includes(k) || aria.includes(k) || cls.includes(k.toLowerCase()))) {
          return { found: true, tag: el.tagName, text: txt.slice(0, 80), cls };
        }
      }
      for (const el of root.querySelectorAll('*')) {
        if (el.shadowRoot) {
          const r = findInRoot(el.shadowRoot);
          if (r && r.found) return r;
        }
      }
      return { found: false };
    }
    return findInRoot(document);
  });
  console.log('[4] 에디터 버튼 탐색:', editorBtn);

  // ── 에디터 버튼 클릭 시도 ────────────────────────
  let clickedEditor = false;
  if (editorBtn.found) {
    console.log('[5] 에디터 버튼 클릭 시도...');
    clickedEditor = await page.evaluate(() => {
      const keywords = ['에디터', '편집', 'editor', 'Editor', '디자인'];
      function clickInRoot(root) {
        const all = root.querySelectorAll('button, a, [role=button]');
        for (const el of all) {
          const txt = (el.textContent || '').trim();
          if (keywords.some(k => txt.includes(k))) {
            el.click();
            return true;
          }
        }
        for (const el of root.querySelectorAll('*')) {
          if (el.shadowRoot && clickInRoot(el.shadowRoot)) return true;
        }
        return false;
      }
      return clickInRoot(document);
    });
    console.log(`[5] 클릭 결과: ${clickedEditor}`);
    await page.waitForTimeout(5000);
  } else {
    console.log('[5] 에디터 버튼 없음 → 옵션 먼저 선택 후 재시도...');
    // 첫번째 옵션들을 클릭해보기
    await page.evaluate(() => {
      function clickFirstOptions(root) {
        const options = root.querySelectorAll('li.option-item, .option-btn, [class*="option"]');
        options.forEach((el, i) => { if (i < 3) el.click(); });
        root.querySelectorAll('*').forEach(el => { if (el.shadowRoot) clickFirstOptions(el.shadowRoot); });
      }
      clickFirstOptions(document);
    });
    await page.waitForTimeout(3000);

    clickedEditor = await page.evaluate(() => {
      const keywords = ['에디터', '편집', 'editor', 'Editor', '디자인', '시작', '만들기'];
      function clickInRoot(root) {
        const all = root.querySelectorAll('button, a, [role=button]');
        for (const el of all) {
          const txt = (el.textContent || '').trim();
          if (keywords.some(k => txt.includes(k))) {
            el.click();
            return true;
          }
        }
        for (const el of root.querySelectorAll('*')) {
          if (el.shadowRoot && clickInRoot(el.shadowRoot)) return true;
        }
        return false;
      }
      return clickInRoot(document);
    });
    console.log(`[5b] 재시도 클릭: ${clickedEditor}`);
    await page.waitForTimeout(5000);
  }

  // ── iframe / 팝업 감지 ───────────────────────────
  const iframes = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('iframe')).map(f => ({
      src: f.src, id: f.id, cls: f.className
    }));
  });
  console.log('[6] iframes:', iframes);

  // ── 스크린샷 ────────────────────────────────────
  await page.screenshot({ path: path.join(OUT_DIR, `editor_${TARGET_PRODUCT}_after_click.png`), fullPage: false });
  console.log(`[7] 스크린샷 저장: editor_${TARGET_PRODUCT}_after_click.png`);

  // ── 팝업 페이지 감지 ─────────────────────────────
  const pages = context.pages();
  console.log(`[8] 열린 페이지 수: ${pages.length}`);
  for (let i = 1; i < pages.length; i++) {
    const p2 = pages[i];
    console.log(`  - 팝업 URL: ${p2.url()}`);
    await p2.waitForTimeout(3000);
    await p2.screenshot({ path: path.join(OUT_DIR, `editor_popup_${i}.png`) });

    // 팝업 네트워크 추가 캡처
    p2.on('request', req => {
      allRequests.push({
        ts: Date.now(), source: 'popup',
        method: req.method(), url: req.url(),
        postData: req.postData() || null
      });
    });
  }

  // 결과 정리
  const editorRelated = allRequests.filter(r =>
    r.url.includes('editor') || r.url.includes('Editor') ||
    r.url.includes('token') || r.url.includes('template') ||
    r.url.includes('project') || r.url.includes('auth') ||
    r.url.includes('iframe') || r.url.includes('init') ||
    r.url.includes('edicus') || r.url.includes('design') ||
    (r.source === 'popup')
  );

  const widgetApiCalls = allRequests.filter(r =>
    r.url.includes('widget-api') || r.url.includes('get_digital') ||
    r.url.includes('get_ajax_price') || r.url.includes('redprinting')
  );

  const result = {
    product: TARGET_PRODUCT,
    pageUrl: PAGE_URL,
    sdkLoaded,
    shadowDomInfo: shadowInfo,
    editorButtonFound: editorBtn,
    clickedEditor,
    iframes,
    popupPages: pages.length - 1,
    editorRelatedRequests: editorRelated,
    widgetApiCalls: widgetApiCalls.slice(-30),
    allRequestCount: allRequests.length,
    allRequestUrls: [...new Set(allRequests.map(r => r.url))].slice(0, 80)
  };

  const outFile = path.join(OUT_DIR, `editor_monitor_${TARGET_PRODUCT}.json`);
  fs.writeFileSync(outFile, JSON.stringify(result, null, 2));
  console.log(`\n[완료] 저장: ${outFile}`);
  console.log(`  - 에디터 관련 요청: ${editorRelated.length}건`);
  console.log(`  - 위젯 API 호출: ${widgetApiCalls.length}건`);
  console.log(`  - 전체 요청: ${allRequests.length}건`);

  await browser.close();
}

run().catch(e => { console.error(e); process.exit(1); });
