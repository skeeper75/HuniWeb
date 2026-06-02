/**
 * S3 poster/banner/실사 live capture — drives the widget for an S3 productCode and captures
 *  - get_digital_product_info response FULL (option tree, size presets, MIN/MAX_CUT_WDT/HGH, materials)
 *  - get_ajax_price_vTmpl REQUEST BODY + RESPONSE (SizeMatrix2D model; cutW/cutH numeric paths)
 *  - option-change → price-recalc (cascade)
 *  - size input mutation (free W/H) to observe 2D unit-price trigger
 * Output: 05_qa/captures/s3_<CODE>.json  +  s3_<CODE>.png   (raw mirror: 01_reverse/s3_raw_captures/)
 *
 * Read-only: only quote/option/price API. No order/payment. Token from running server.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'BNBNFBL';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
const RAW = path.resolve(__dirname, '../../../_workspace/huni-widget/01_reverse/s3_raw_captures');
fs.mkdirSync(OUT, { recursive: true });
fs.mkdirSync(RAW, { recursive: true });

const priceCalls = [];
const productInfo = [];
const net = [];
const t0 = Date.now();
const rel = () => Date.now() - t0;

function redactStr(s) {
  return (s || '')
    .replace(/(token=)[^&"\s]+/gi, '$1[REDACTED-JWT]')
    .replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g, '[REDACTED-JWT]');
}

async function snapStore(page) {
  return page.evaluate(() => (window.getStoreSnapshot ? window.getStoreSnapshot() : null));
}

async function run() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width: 1440, height: 1100 } });
  const page = await context.newPage();

  context.on('request', req => {
    const u = req.url();
    if (/get_ajax_price_vTmpl|get_digital_product_info/.test(u)) {
      let body = null;
      try { body = req.postData(); } catch {}
      net.push({ rel: rel(), dir: 'req', method: req.method(), url: u.split('?')[0].replace(/.*\/rp-api/, '/rp-api'), body });
    }
  });
  context.on('response', async resp => {
    const u = resp.url();
    if (/get_ajax_price_vTmpl/.test(u)) {
      let respBody = null, reqBody = null;
      try { respBody = await resp.json(); } catch { try { respBody = (await resp.text()).slice(0, 800); } catch {} }
      try { reqBody = resp.request().postData(); } catch {}
      priceCalls.push({ rel: rel(), status: resp.status(), reqBody, respBody });
    }
    if (/get_digital_product_info/.test(u)) {
      let respBody = null;
      try { respBody = await resp.json(); } catch { try { respBody = (await resp.text()).slice(0, 2000); } catch {} }
      productInfo.push({ rel: rel(), status: resp.status(), respBody });
    }
  });

  const tok = await page.request.get(`${BASE}/token-status`).then(r => r.json()).catch(() => ({}));
  console.log('[token]', tok);

  await page.goto(BASE, { waitUntil: 'load', timeout: 20000 });
  await page.waitForTimeout(1200);

  console.log('[load product]', PRODUCT);
  const loaded = await page.evaluate(async (code) => {
    if (typeof window.selectProduct === 'function') { await window.selectProduct(code, code); return 'selectProduct'; }
    if (typeof window.selectProductByCode === 'function') { window.selectProductByCode(code); return 'selectProductByCode'; }
    return 'no-loader';
  }, PRODUCT);
  console.log('[loader]', loaded);
  await page.waitForTimeout(6000);

  const storeAfterInit = await snapStore(page);

  const domScan = await page.evaluate(() => {
    function* walk(root) { for (const el of root.querySelectorAll('*')) { yield el; if (el.shadowRoot) yield* walk(el.shadowRoot); } }
    const host = document.getElementById('redWidgetSdk');
    if (!host || !host.shadowRoot) return { ok: false, reason: 'no shadow' };
    const selects = [], numbers = [], texts = [], buttons = [];
    for (const el of walk(host.shadowRoot)) {
      if (el.tagName === 'SELECT') {
        selects.push({ name: el.name || el.id || '', opts: [...el.options].slice(0,40).map(o => (o.textContent||'').trim()) });
      }
      if (el.tagName === 'INPUT' && el.type === 'number') numbers.push({ name: el.name||el.id||'', ph: el.placeholder||'', val: el.value, min: el.min, max: el.max });
      if (el.tagName === 'INPUT' && el.type === 'text') texts.push({ name: el.name||el.id||'', ph: el.placeholder||'', val: el.value });
      if (el.tagName === 'BUTTON') { const t=(el.textContent||'').trim(); if(t && t.length<30) buttons.push(t); }
    }
    return { ok: true, selects, numbers, texts, buttons: [...new Set(buttons)].slice(0,60) };
  });
  console.log('[domScan] selects=', (domScan.selects||[]).length, 'numbers=', (domScan.numbers||[]).length);

  const mutated = await page.evaluate(() => {
    function* walk(root) { for (const el of root.querySelectorAll('*')) { yield el; if (el.shadowRoot) yield* walk(el.shadowRoot); } }
    const host = document.getElementById('redWidgetSdk');
    if (!host || !host.shadowRoot) return { ok: false, reason: 'no shadow' };
    const numbers = [], selects = [];
    for (const el of walk(host.shadowRoot)) {
      if (el.tagName === 'INPUT' && el.type === 'number') numbers.push(el);
      if (el.tagName === 'SELECT') selects.push(el);
    }
    const sizeIn = numbers.find(n => /가로|세로|width|height|wdt|hgh|mm/i.test((n.name||'')+(n.placeholder||'')));
    if (sizeIn) {
      sizeIn.value = (parseInt(sizeIn.value||'0',10) + 200 || 1000).toString();
      sizeIn.dispatchEvent(new Event('input', { bubbles: true }));
      sizeIn.dispatchEvent(new Event('change', { bubbles: true }));
      return { ok: true, kind: 'size-number', name: sizeIn.name||sizeIn.placeholder, to: sizeIn.value };
    }
    for (const s of selects) {
      if (s.options && s.options.length > 1) {
        const next = (s.selectedIndex + 1) % s.options.length;
        s.selectedIndex = next;
        s.dispatchEvent(new Event('change', { bubbles: true }));
        return { ok: true, kind: 'select', to: next, label: (s.options[next].textContent||'').trim() };
      }
    }
    return { ok: false, reason: 'no mutable size/option' };
  });
  console.log('[mutate]', JSON.stringify(mutated));
  await page.waitForTimeout(3500);
  const storeAfterOption = await snapStore(page);

  await page.screenshot({ path: path.join(OUT, `s3_${PRODUCT}.png`), fullPage: true });

  const result = {
    product: PRODUCT,
    capturedAt: new Date().toISOString(),
    token: { ok: !tok.expired, exp: tok.exp },
    loader: loaded,
    domScan,
    optionMutation: mutated,
    storeKeysAfterInit: storeAfterInit ? Object.keys(storeAfterInit) : null,
    storeAfterInit,
    storeAfterOption,
    productInfoCount: productInfo.length,
    productInfo,
    priceCallCount: priceCalls.length,
    priceCalls: priceCalls.map(c => ({ rel: c.rel, status: c.status, reqBody: redactStr(c.reqBody), respBody: c.respBody })),
    network: net.map(n => ({ ...n, body: redactStr(n.body) })),
  };
  fs.writeFileSync(path.join(OUT, `s3_${PRODUCT}.json`), JSON.stringify(result, null, 2));
  fs.writeFileSync(path.join(RAW, `s3_${PRODUCT}.json`), JSON.stringify(result, null, 2));
  console.log('[DONE]', PRODUCT, 'priceCalls=', priceCalls.length, 'productInfo=', productInfo.length, 'numbers=', (domScan.numbers||[]).length);
  await browser.close();
}
run().catch(e => { console.error('CAPTURE ERROR', e); process.exit(1); });
