/**
 * S2 sticker live capture — drives the widget for a sticker productCode and captures
 *  - get_digital_product_info response (option tree)
 *  - get_ajax_price_vTmpl REQUEST BODY + RESPONSE (price model shape)
 *  - option-change → price-recalc (cascade)
 * Output: 05_qa/captures/s2_<CODE>.json  +  s2_<CODE>.png
 *
 * Read-only: only quote/option/price API. No order/payment. Token from running server.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
// [보안] respBody가 Edicus 세션 JWT(refreshToken 등)를 echo할 수 있어 직렬화 출력 전체를 redact (안전규칙 #5)
const redact = s => (s||'').replace(/(token=)[^&"\s]+/gi,'$1[REDACTED]').replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g,'[JWT]');

const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'STTHCIC';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
fs.mkdirSync(OUT, { recursive: true });

const priceCalls = []; // {rel, reqBody, respBody, status}
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
  const context = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
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
      try { respBody = await resp.json(); } catch { try { respBody = (await resp.text()).slice(0, 400); } catch {} }
      try { reqBody = resp.request().postData(); } catch {}
      priceCalls.push({ rel: rel(), status: resp.status(), reqBody, respBody });
    }
  });

  const tok = await page.request.get(`${BASE}/token-status`).then(r => r.json()).catch(() => ({}));
  console.log('[token]', tok);

  await page.goto(BASE, { waitUntil: 'load', timeout: 20000 });
  await page.waitForTimeout(1200);

  // The product list only shows catalog products. Stickers aren't in catalog → drive via the
  // widget's product-load API directly. index.html exposes a loader; fallback: call window loader.
  console.log('[load product]', PRODUCT);
  const loaded = await page.evaluate(async (code) => {
    // index.html exposes selectProduct(pdtCode, name) which mounts RedWidgetSDK by pdtCode.
    // Catalog-independent: the SDK calls get_digital_product_info by pdtCode directly.
    if (typeof window.selectProduct === 'function') { await window.selectProduct(code, code); return 'selectProduct'; }
    if (typeof window.selectProductByCode === 'function') { window.selectProductByCode(code); return 'selectProductByCode'; }
    return 'no-loader';
  }, PRODUCT);
  console.log('[loader]', loaded);
  await page.waitForTimeout(5000); // product_info + initial price

  const storeAfterInit = await snapStore(page);

  // mutate first select (material/size) to trigger cascade + price recalc
  const mutated = await page.evaluate(() => {
    function* walk(root) { for (const el of root.querySelectorAll('*')) { yield el; if (el.shadowRoot) yield* walk(el.shadowRoot); } }
    const host = document.getElementById('redWidgetSdk');
    if (!host || !host.shadowRoot) return { ok: false, reason: 'no shadow' };
    const selects = [], qty = [];
    for (const el of walk(host.shadowRoot)) {
      if (el.tagName === 'SELECT') selects.push(el);
      if (el.tagName === 'INPUT' && (el.type === 'number')) qty.push(el);
    }
    for (const s of selects) {
      if (s.options && s.options.length > 1) {
        const next = (s.selectedIndex + 1) % s.options.length;
        s.selectedIndex = next;
        s.dispatchEvent(new Event('change', { bubbles: true }));
        return { ok: true, kind: 'select', to: next, optCount: s.options.length, label: (s.options[next].textContent||'').trim() };
      }
    }
    if (qty.length) { const q = qty[0]; q.value = (parseInt(q.value||'1',10)+100).toString(); q.dispatchEvent(new Event('input',{bubbles:true})); q.dispatchEvent(new Event('change',{bubbles:true})); return { ok:true, kind:'qty', to:q.value }; }
    return { ok: false, reason: 'no mutable option' };
  });
  console.log('[mutate]', JSON.stringify(mutated));
  await page.waitForTimeout(3000);
  const storeAfterOption = await snapStore(page);

  await page.screenshot({ path: path.join(OUT, `s2_${PRODUCT}.png`) });

  const result = {
    product: PRODUCT,
    capturedAt: new Date().toISOString(),
    token: { ok: !tok.expired, exp: tok.exp },
    loader: loaded,
    optionMutation: mutated,
    storeKeysAfterInit: storeAfterInit ? Object.keys(storeAfterInit) : null,
    priceCallCount: priceCalls.length,
    priceCalls: priceCalls.map(c => ({ rel: c.rel, status: c.status, reqBody: redactStr(c.reqBody), respBody: c.respBody })),
    network: net.map(n => ({ ...n, body: redactStr(n.body) })),
  };
  fs.writeFileSync(path.join(OUT, `s2_${PRODUCT}.json`), redact(JSON.stringify(result, null, 2)));
  console.log('[DONE] priceCalls=', priceCalls.length, 'written', path.join(OUT, `s2_${PRODUCT}.json`));
  await browser.close();
}
run().catch(e => { console.error('CAPTURE ERROR', e); process.exit(1); });
