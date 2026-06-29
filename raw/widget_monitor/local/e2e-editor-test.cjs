/**
 * E2E: localhost:3001 에디터 동작 검증
 * - 상품 선택 → 위젯 마운트 → 에디터 탭 → 편집하기 → 에디터 DOM 확인
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE = 'http://localhost:3001';
const PRODUCT = 'GSTGMIC';
const SHOTS = __dirname;

async function run() {
  const browser = await chromium.launch({ headless: false, slowMo: 400 });
  const context = await browser.newContext({ viewport: { width: 1440, height: 900 } });

  const networkLog = [];
  context.on('request', req => {
    if (req.url().includes('makers') || req.url().includes('editor') || req.url().includes('widget-api')) {
      networkLog.push({ type: 'req', method: req.method(), url: req.url().split('?')[0] });
    }
  });
  context.on('response', resp => {
    if (resp.url().includes('makers') || resp.url().includes('editor')) {
      networkLog.push({ type: 'resp', status: resp.status(), url: resp.url().split('?')[0] });
    }
  });

  const page = await context.newPage();

  // ── Step 1: 토큰 상태 확인 ─────────────────────────
  console.log('\n[S1] 토큰 상태 확인...');
  const tokenStatus = await page.request.get(`${BASE}/token-status`).then(r => r.json());
  console.log('  토큰:', tokenStatus);
  if (tokenStatus.expired) {
    console.log('  ⚠️  토큰 만료 → 갱신 시도...');
    const refresh = await page.request.post(`${BASE}/refresh-token`).then(r => r.json());
    console.log('  갱신 결과:', refresh);
  }

  // ── Step 2: 시뮬레이터 로딩 ────────────────────────
  console.log('[S2] localhost:3001 로딩...');
  await page.goto(BASE, { waitUntil: 'load', timeout: 15000 });
  await page.waitForTimeout(2000);
  await page.screenshot({ path: path.join(SHOTS, 'e2e_01_loaded.png') });

  // ── Step 3: 상품 선택 클릭 ─────────────────────────
  console.log(`[S3] ${PRODUCT} 상품 선택...`);
  const productItem = await page.$(`[data-code="${PRODUCT}"]`);
  if (!productItem) {
    console.error('  ❌ 상품 아이템을 찾을 수 없음');
    await page.screenshot({ path: path.join(SHOTS, 'e2e_err_no_product.png') });
    await browser.close(); return;
  }
  await productItem.click();
  await page.waitForTimeout(4000);
  await page.screenshot({ path: path.join(SHOTS, 'e2e_02_product_selected.png') });

  // ── Step 4: Shadow DOM 위젯 마운트 확인 ───────────
  console.log('[S4] Shadow DOM 위젯 확인...');
  const widgetInfo = await page.evaluate(() => {
    const host = document.getElementById('redWidgetSdk');
    if (!host || !host.shadowRoot) return { mounted: false };
    const buttons = Array.from(host.shadowRoot.querySelectorAll('button')).map(b => ({
      text: b.textContent.trim(), cls: b.className
    }));
    return { mounted: true, buttonCount: buttons.length, buttons };
  });
  console.log('  위젯:', widgetInfo.mounted ? `마운트됨 (버튼 ${widgetInfo.buttonCount}개)` : '❌ 미마운트');
  if (widgetInfo.buttons) widgetInfo.buttons.forEach(b => console.log(`    - [${b.cls}] ${b.text}`));

  if (!widgetInfo.mounted) {
    await browser.close(); return;
  }

  // ── Step 5: 에디터 탭 클릭 ─────────────────────────
  console.log('[S5] 에디터 탭 클릭...');
  const editorTabClicked = await page.evaluate(() => {
    function findBtn(root, text) {
      for (const el of root.querySelectorAll('button')) {
        if ((el.textContent||'').trim() === text) return el;
      }
      for (const el of root.querySelectorAll('*')) {
        if (el.shadowRoot) { const r = findBtn(el.shadowRoot, text); if (r) return r; }
      }
    }
    const btn = findBtn(document, '에디터');
    if (btn) { btn.click(); return true; }
    return false;
  });
  console.log('  에디터 탭:', editorTabClicked ? '클릭됨' : '❌ 버튼 없음');
  await page.waitForTimeout(1500);

  // ── Step 6: 편집하기 클릭 ──────────────────────────
  console.log('[S6] 편집하기 클릭...');
  const editClicked = await page.evaluate(() => {
    function findBtn(root, text) {
      for (const el of root.querySelectorAll('button')) {
        if ((el.textContent||'').trim() === text) return el;
      }
      for (const el of root.querySelectorAll('*')) {
        if (el.shadowRoot) { const r = findBtn(el.shadowRoot, text); if (r) return r; }
      }
    }
    const btn = findBtn(document, '편집하기');
    if (btn) { btn.click(); return { found: true, cls: btn.className }; }
    return { found: false };
  });
  console.log('  편집하기:', editClicked.found ? `클릭됨 (${editClicked.cls})` : '❌ 버튼 없음');
  await page.waitForTimeout(5000);
  await page.screenshot({ path: path.join(SHOTS, 'e2e_03_after_edit_click.png') });

  // ── Step 7: 에디터 DOM/iframe 감지 ────────────────
  console.log('[S7] 에디터 DOM 감지...');
  const editorInfo = await page.evaluate(() => {
    // iframe 탐색
    const iframes = Array.from(document.querySelectorAll('iframe')).map(f => ({
      src: f.src.slice(0,100), id: f.id, cls: f.className, visible: f.offsetParent !== null
    }));

    // Shadow DOM 내 에디터 요소 탐색
    function scanShadow(root, depth=0) {
      const found = [];
      for (const el of root.querySelectorAll('*')) {
        if (el.shadowRoot) {
          const iframes2 = Array.from(el.shadowRoot.querySelectorAll('iframe'));
          const editorDivs = Array.from(el.shadowRoot.querySelectorAll('[class*="editor"],[id*="editor"],[class*="canvas"]'));
          if (iframes2.length || editorDivs.length) {
            found.push({
              host: el.tagName+'#'+el.id,
              shadowIframes: iframes2.map(f=>f.src.slice(0,80)),
              editorDivs: editorDivs.map(e=>e.tagName+'.'+e.className.slice(0,40))
            });
          }
          found.push(...scanShadow(el.shadowRoot, depth+1));
        }
      }
      return found;
    }

    // 모달 탐색
    const modals = Array.from(document.querySelectorAll('[class*="modal"],[class*="overlay"],[class*="popup"]')).map(m => ({
      tag: m.tagName, cls: m.className.slice(0,60), visible: m.offsetParent !== null
    }));

    return { iframes, shadowElements: scanShadow(document), modals };
  });

  console.log('  iframe수:', editorInfo.iframes.length);
  editorInfo.iframes.forEach(f => console.log('    -', f.src, f.visible ? '(visible)' : '(hidden)'));
  console.log('  Shadow 에디터:', editorInfo.shadowElements.length > 0 ? editorInfo.shadowElements : '없음');
  console.log('  모달:', editorInfo.modals.filter(m=>m.visible).length, '개 visible');

  // ── Step 8: 네트워크 로그 확인 ─────────────────────
  console.log('\n[S8] 에디터 관련 네트워크 요청:');
  networkLog.forEach(l => {
    if (l.type === 'req') console.log(`  → ${l.method} ${l.url}`);
    else console.log(`  ← ${l.status} ${l.url}`);
  });

  // ── Step 9: 콘솔 에러 수집 ─────────────────────────
  const consoleErrors = [];
  page.on('console', msg => { if (msg.type() === 'error') consoleErrors.push(msg.text()); });
  await page.waitForTimeout(1000);

  // ── 최종 스크린샷 ──────────────────────────────────
  await page.screenshot({ path: path.join(SHOTS, 'e2e_04_final.png'), fullPage: false });

  const result = {
    tokenOk: !tokenStatus.expired,
    widgetMounted: widgetInfo.mounted,
    editorTabClicked,
    editBtnFound: editClicked.found,
    iframeCount: editorInfo.iframes.length,
    shadowEditorFound: editorInfo.shadowElements.length > 0,
    visibleModals: editorInfo.modals.filter(m=>m.visible).length,
    networkCalls: networkLog,
    consoleErrors
  };

  fs.writeFileSync(path.join(SHOTS, 'e2e_result.json'), JSON.stringify(result, null, 2));
  console.log('\n[결과]', JSON.stringify({
    token: result.tokenOk ? '✅' : '❌',
    widget: result.widgetMounted ? '✅' : '❌',
    editBtn: result.editBtnFound ? '✅' : '❌',
    iframe: result.iframeCount + '개',
    shadowEditor: result.shadowEditorFound ? '✅' : '❌',
    modals: result.visibleModals + '개',
    networkCalls: result.networkCalls.length + '건',
    errors: result.consoleErrors.length + '건'
  }));

  await page.waitForTimeout(3000);
  await browser.close();
}

run().catch(e => { console.error(e); process.exit(1); });
