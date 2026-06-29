/**
 * hw-runtime-analyst Phase 2 LIVE capture
 * Drives the widget end-to-end and captures:
 *  - init API sequence (product_info)
 *  - option-change → price-recalc timeline (debounce, store diffs)
 *  - editor open: editor/config → makers token/editor/template + REAL from-edicus postMessage timeline
 * Output: 02_analysis/captures/runtime_capture_{PRODUCT}.json
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'GSTGMIC';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/02_analysis/captures');
fs.mkdirSync(OUT, { recursive: true });

const net = [];           // network with timestamps
const consoleMsgs = [];   // page console (for [postMessage], [Editor], [RedEditorSDK] logs)
const t0 = Date.now();
const rel = () => Date.now() - t0;

async function snapStore(page) {
  return page.evaluate(() => (window.getStoreSnapshot ? window.getStoreSnapshot() : null));
}

async function run() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width: 1440, height: 1000 } });
  const page = await context.newPage();

  page.on('console', msg => {
    const t = msg.text();
    if (/\[postMessage\]|\[Editor\]|\[RedEditorSDK\]|\[onOpenEditor\]/.test(t)) {
      consoleMsgs.push({ rel: rel(), text: t.slice(0, 600) });
    }
  });
  context.on('request', req => {
    const u = req.url();
    if (/makers|editor|widget-api|get_ajax_price|get_digital_product|presigned|s3GetObject/.test(u)) {
      net.push({ rel: rel(), dir: 'req', method: req.method(), url: u.split('?')[0] });
    }
  });
  context.on('response', resp => {
    const u = resp.url();
    if (/makers|editor|widget-api|get_ajax_price|get_digital_product|presigned|s3GetObject/.test(u)) {
      net.push({ rel: rel(), dir: 'resp', status: resp.status(), url: u.split('?')[0] });
    }
  });

  const tokenStatus = await page.request.get(`${BASE}/token-status`).then(r => r.json());
  console.log('[S1] token', tokenStatus);
  if (tokenStatus.expired) {
    await page.request.post(`${BASE}/refresh-token`).then(r => r.json()).catch(()=>{});
  }

  console.log('[S2] load', BASE);
  await page.goto(BASE, { waitUntil: 'load', timeout: 20000 });
  await page.waitForTimeout(1500);
  const tInitStart = rel();

  console.log('[S3] select product', PRODUCT);
  const item = await page.$(`[data-code="${PRODUCT}"]`);
  if (!item) { console.error('product not found'); await browser.close(); return; }
  await item.click();
  await page.waitForTimeout(4500); // allow product_info + initial render + initial price
  const tInitEnd = rel();
  const storeAfterInit = await snapStore(page);

  // ── option-change → price-recalc capture ──
  // Find an option control in shadow DOM (select / input) and mutate it to trigger price recalc.
  console.log('[S4] mutate first option to trigger price recalc');
  const optBefore = rel();
  const mutated = await page.evaluate(() => {
    function* walk(root) {
      for (const el of root.querySelectorAll('*')) {
        yield el;
        if (el.shadowRoot) yield* walk(el.shadowRoot);
      }
    }
    const host = document.getElementById('redWidgetSdk');
    if (!host || !host.shadowRoot) return { ok: false, reason: 'no shadow' };
    const selects = [], radios = [], qty = [];
    for (const el of walk(host.shadowRoot)) {
      if (el.tagName === 'SELECT') selects.push(el);
      if (el.tagName === 'INPUT' && el.type === 'radio') radios.push(el);
      if (el.tagName === 'INPUT' && (el.type === 'number' || /qty|cnt|prn/i.test(el.name||el.id||el.className))) qty.push(el);
    }
    // prefer a select with >1 option (e.g., material / size), else a qty input
    const log = [];
    for (const s of selects) {
      if (s.options && s.options.length > 1) {
        const cur = s.selectedIndex;
        const next = (cur + 1) % s.options.length;
        s.selectedIndex = next;
        s.dispatchEvent(new Event('change', { bubbles: true }));
        log.push({ kind: 'select', from: cur, to: next, optCount: s.options.length });
        return { ok: true, action: log };
      }
    }
    if (qty.length) {
      const q = qty[0];
      const old = q.value;
      q.value = (parseInt(q.value || '1', 10) + 10).toString();
      q.dispatchEvent(new Event('input', { bubbles: true }));
      q.dispatchEvent(new Event('change', { bubbles: true }));
      log.push({ kind: 'qty', from: old, to: q.value });
      return { ok: true, action: log };
    }
    if (radios.length > 1) {
      radios[1].click();
      log.push({ kind: 'radio', clicked: radios[1].value || radios[1].id });
      return { ok: true, action: log };
    }
    return { ok: false, reason: 'no mutable option', counts: { selects: selects.length, radios: radios.length, qty: qty.length } };
  });
  console.log('  mutated:', JSON.stringify(mutated));
  await page.waitForTimeout(2500); // capture debounce + price API
  const storeAfterOption = await snapStore(page);
  const tOptEnd = rel();

  // ── editor open ──
  console.log('[S5] editor tab + 편집하기');
  const tEditorClick = rel();
  await page.evaluate(() => {
    function findBtn(root, text) {
      for (const el of root.querySelectorAll('button')) if ((el.textContent||'').trim() === text) return el;
      for (const el of root.querySelectorAll('*')) if (el.shadowRoot) { const r = findBtn(el.shadowRoot, text); if (r) return r; }
    }
    const tab = findBtn(document, '에디터'); if (tab) tab.click();
  });
  await page.waitForTimeout(1500);
  await page.evaluate(() => {
    function findBtn(root, text) {
      for (const el of root.querySelectorAll('button')) if ((el.textContent||'').trim() === text) return el;
      for (const el of root.querySelectorAll('*')) if (el.shadowRoot) { const r = findBtn(el.shadowRoot, text); if (r) return r; }
    }
    const ed = findBtn(document, '편집하기'); if (ed) ed.click();
  });
  // wait long for editor iframe init → ready-to-listen → from-edicus messages
  await page.waitForTimeout(12000);

  const editorState = await page.evaluate(() => ({
    lifecycleState: window.__editorLifecycleState || null,
    eventTimeline: (window.__eventTimeline || []).map(e => ({
      ts: e.ts, tsISO: e.tsISO, action: e.action,
      info: e.info ? JSON.parse(JSON.stringify(e.info)) : null, origin: e.origin
    })),
    editorPayloadShape: (() => {
      try {
        const cfg = window.__lastEditorDocInfo;
        return cfg ? Object.keys(cfg) : null;
      } catch { return null; }
    })(),
    iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({ src: (f.src||'').slice(0,160), id: f.id, visible: f.offsetParent !== null }))
  }));

  // capture the KOI editorPayload config (REDACT token)
  const editorPayloadRedacted = await page.evaluate(() => {
    const txt = document.getElementById('editorPayload')?.textContent || '';
    try {
      const o = JSON.parse(txt);
      const redact = (obj) => {
        if (!obj || typeof obj !== 'object') return obj;
        for (const k of Object.keys(obj)) {
          if (/token|signature|jwt|presigned/i.test(k) && typeof obj[k] === 'string') obj[k] = '[REDACTED]';
          else if (typeof obj[k] === 'object') redact(obj[k]);
        }
        return obj;
      };
      return redact(o);
    } catch { return txt.slice(0, 200); }
  });

  await page.screenshot({ path: path.join(OUT, `runtime_${PRODUCT}_editor.png`) });

  // Redact tokens/signatures everywhere (network, console, iframe src, store)
  const redactStr = s => (s||'')
    .replace(/(token=)[^&"\s]+/gi, '$1[REDACTED-JWT]')
    .replace(/(red-editor-token|X-Amz-Signature=|X-Amz-Credential=)[^&"\s]+/gi, '$1[REDACTED]')
    .replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g, '[REDACTED-JWT]');
  const scrubDeep = (o) => {
    if (Array.isArray(o)) return o.map(scrubDeep);
    if (o && typeof o === 'object') {
      const r = {};
      for (const [k, v] of Object.entries(o)) {
        if (/token|signature|jwt|presigned|secret|koiAccess|rpAccess/i.test(k) && typeof v === 'string' && v.length > 20) r[k] = '[REDACTED]';
        else r[k] = scrubDeep(v);
      }
      return r;
    }
    if (typeof o === 'string') return redactStr(o);
    return o;
  };
  editorState.iframes = editorState.iframes.map(f => ({ ...f, src: redactStr(f.src) }));
  const result = {
    product: PRODUCT,
    capturedAt: new Date().toISOString(),
    token: { ok: !tokenStatus.expired },
    timing: { initStart: tInitStart, initEnd: tInitEnd, initDurationMs: tInitEnd - tInitStart,
              optionChangeAt: optBefore, optionSettleMs: tOptEnd - optBefore, editorClickAt: tEditorClick },
    optionMutation: mutated,
    storeKeys: { afterInit: storeAfterInit ? Object.keys(storeAfterInit) : null,
                 afterOption: storeAfterOption ? Object.keys(storeAfterOption) : null },
    storeAfterInit: scrubDeep(storeAfterInit), storeAfterOption: scrubDeep(storeAfterOption),
    editor: scrubDeep(editorState),
    editorPayloadConfig: scrubDeep(editorPayloadRedacted),
    network: net.map(n => ({ ...n, url: redactStr(n.url) })),
    consoleMsgs: consoleMsgs.map(c => ({ rel: c.rel, text: redactStr(c.text) }))
  };
  fs.writeFileSync(path.join(OUT, `runtime_capture_${PRODUCT}.json`), JSON.stringify(result, null, 2));
  console.log('\n[DONE] lifecycle=', editorState.lifecycleState, 'fromEdicusEvents=', editorState.eventTimeline.length, 'netCalls=', net.length);
  console.log('  written:', path.join(OUT, `runtime_capture_${PRODUCT}.json`));
  await browser.close();
}
run().catch(e => { console.error('CAPTURE ERROR', e); process.exit(1); });
