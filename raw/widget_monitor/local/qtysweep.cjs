/**
 * Mission 1 — material-PCS ATTB scaling sweep (D-1/W2-b).
 * For one product: load → select first real size → sweep the quantity control over a
 * range → capture get_ajax_price_vTmpl reqBody at each step → extract material-PCS
 * (WRK_MTR/DIR_MTR/INN_DFT) ATTB + ORD_CNT/PRN_CNT echo + PRICE per step.
 *
 * Quantity control varies by product: PRN_CNT select (디자인수/건수), `qty` select,
 * or ORD_CNT number input. We detect & sweep whichever exists, recording which field
 * the material ATTB tracks. Read-only. Full-output redact (respBody may echo Edicus JWT).
 *
 * Usage: PRODUCT=GSTGMIC node qtysweep.cjs
 * Output: 05_qa/captures/qtysweep_<CODE>.json
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'GSTGMIC';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
fs.mkdirSync(OUT, { recursive: true });
const MATERIAL_PCS = ['WRK_MTR', 'DIR_MTR', 'INN_DFT'];
const redact = s => (s || '').replace(/(token=)[^&"\s]+/gi, '$1[REDACTED]').replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g, '[JWT]');

function extractFromReq(reqBody) {
  try {
    const o = JSON.parse(reqBody); const dj = o.dataJson || o;
    const ord = (dj.ORD_INFO || [])[0] || {}; const pcs = dj.PCS_INFO || [];
    const mats = pcs.filter(p => MATERIAL_PCS.includes(p.PCS_COD)).map(p => ({ PCS_COD: p.PCS_COD, PCS_DTL_COD: p.PCS_DTL_COD, ATTB: p.ATTB, ATTB_2: p.ATTB_2, ATTB_3: p.ATTB_3 }));
    return { ORD_CNT: ord.ORD_CNT, PRN_CNT: ord.PRN_CNT, price_gbn: dj.price_gbn, materials: mats, allPcsCods: pcs.map(p => p.PCS_COD) };
  } catch (e) { return { parseError: e.message }; }
}
// AUTHORITATIVE price = result_sum.PRICE. Per-PCS result[].PRICE can be 0 (bundled
// components) while the real total lives in result_sum — reading a per-line 0 would be
// a false PRICE=0 (Red never returns a legit 0 total). result_sum is the single source.
function extractPrice(respBody) {
  if (!respBody) return null; const r = respBody;
  if (r.result_sum && r.result_sum.PRICE != null) return r.result_sum.PRICE;        // primary (vTmpl/tiered)
  if (r.result_sum && r.result_sum.PRICE_VAT != null) return r.result_sum.PRICE_VAT;
  const direct = r.PRICE ?? r.price ?? r.totalPrice ?? r.TOT_AMT ?? (r.data && (r.data.PRICE ?? r.data.price));
  if (direct != null) return direct;
  return null;
}
// also surface per-PCS price lines so a 0 sum can be diagnosed (which component is 0)
function pcsPrices(respBody) {
  if (!respBody || !Array.isArray(respBody.result)) return null;
  return respBody.result.map(x => ({ PCS_CD: x.PCS_CD, PRICE: x.PRICE, LOG: (x.PRICE_LOG || '').slice(0, 80) }));
}

async function run() {
  const browser = await chromium.launch({ headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 1100 } });
  const page = await ctx.newPage();
  const allPriceCalls = []; let mark = 'init';
  page.context().on('response', async resp => {
    if (/get_ajax_price_vTmpl/.test(resp.url())) {
      let r = null; try { r = await resp.json(); } catch {}
      let req = null; try { req = resp.request().postData(); } catch {}
      allPriceCalls.push({ mark, status: resp.status(), reqBody: req, respBody: r });
    }
  });
  await page.goto(BASE, { waitUntil: 'load', timeout: 20000 });
  await page.waitForTimeout(800);
  await page.evaluate(async c => { if (window.selectProduct) await window.selectProduct(c, c); }, PRODUCT);
  await page.waitForTimeout(6000);

  // select first real size preset
  const sz = await page.evaluate(() => {
    function* walk(r) { for (const e of r.querySelectorAll('*')) { yield e; if (e.shadowRoot) yield* walk(e.shadowRoot); } }
    const host = document.getElementById('redWidgetSdk'); if (!host || !host.shadowRoot) return { mounted: false };
    let sizeSel = null;
    for (const el of walk(host.shadowRoot)) { if (el.tagName === 'SELECT' && el.name === 'sizes' && el.options.length > 1) { sizeSel = el; break; } }
    let picked = null;
    if (sizeSel) { sizeSel.selectedIndex = 1; sizeSel.dispatchEvent(new Event('change', { bubbles: true })); picked = (sizeSel.options[1].textContent || '').trim(); }
    // detect quantity control present
    let qtyCtl = null, qtyMax = null;
    for (const el of walk(host.shadowRoot)) {
      if (el.tagName === 'SELECT' && el.name === 'PRN_CNT') { qtyCtl = 'PRN_CNT'; qtyMax = el.options.length; }
    }
    if (!qtyCtl) for (const el of walk(host.shadowRoot)) { if (el.tagName === 'SELECT' && el.name === 'qty') { qtyCtl = 'qty'; qtyMax = el.options.length; } }
    let hasOrdInput = false;
    for (const el of walk(host.shadowRoot)) { if (el.tagName === 'INPUT' && el.name === 'ORD_CNT') hasOrdInput = true; }
    return { mounted: true, sizePicked: picked, qtyCtl, qtyMax, hasOrdInput };
  });
  await page.waitForTimeout(4000);

  // Determine sweep values. If qty select exists, use its in-range values; always include a high value via ORD_CNT input.
  let sweepSteps = [];
  if (sz.qtyCtl) {
    const vals = sz.qtyMax >= 10 ? [1, 2, 10] : [1, 2, Math.min(sz.qtyMax, 5)];
    sweepSteps = vals.map(v => ({ via: sz.qtyCtl, value: v }));
  }
  // try ORD_CNT free input for a large value (100) regardless
  if (sz.hasOrdInput) sweepSteps.push({ via: 'ORD_CNT', value: 100 });
  // if no qty select and only ORD_CNT input, sweep ORD_CNT over full range
  if (!sz.qtyCtl && sz.hasOrdInput) sweepSteps = [1, 2, 10, 100].map(v => ({ via: 'ORD_CNT', value: v }));

  for (const step of sweepSteps) {
    mark = `${step.via}=${step.value}`;
    const r = await page.evaluate((s) => {
      function* walk(r) { for (const e of r.querySelectorAll('*')) { yield e; if (e.shadowRoot) yield* walk(e.shadowRoot); } }
      const host = document.getElementById('redWidgetSdk'); if (!host || !host.shadowRoot) return { ok: false };
      if (s.via === 'ORD_CNT') {
        let ord = null;
        for (const el of walk(host.shadowRoot)) { if (el.tagName === 'INPUT' && el.name === 'ORD_CNT') ord = el; }
        if (!ord) return { ok: false, reason: 'no ORD_CNT input' };
        ord.value = String(s.value); ord.dispatchEvent(new Event('input', { bubbles: true })); ord.dispatchEvent(new Event('change', { bubbles: true }));
        return { ok: true, set: ord.value };
      } else {
        let sel = null;
        for (const el of walk(host.shadowRoot)) { if (el.tagName === 'SELECT' && el.name === s.via) sel = el; }
        if (!sel) return { ok: false, reason: 'no ' + s.via };
        sel.value = String(s.value); sel.dispatchEvent(new Event('change', { bubbles: true }));
        return { ok: true, set: sel.value };
      }
    }, step);
    step.applied = r;
    await page.waitForTimeout(3500); // recalc + throttle
  }

  // build summary
  const sweep = sweepSteps.map(step => {
    const calls = allPriceCalls.filter(c => c.mark === `${step.via}=${step.value}` && c.status === 200 && c.reqBody);
    const last = calls[calls.length - 1];
    if (!last) return { via: step.via, requested: step.value, applied: step.applied, captured: false };
    const ex = extractFromReq(last.reqBody);
    return { via: step.via, requested: step.value, applied: step.applied, captured: true, ORD_CNT_echo: ex.ORD_CNT, PRN_CNT_echo: ex.PRN_CNT, price_gbn: ex.price_gbn, materials: ex.materials, allPcsCods: ex.allPcsCods, PRICE: extractPrice(last.respBody), pcsPrices: pcsPrices(last.respBody) };
  });

  const out = {
    product: PRODUCT, mission: 'D-1/W2-b material-PCS ATTB scaling', capturedAt: new Date().toISOString(),
    sizePicked: sz.sizePicked, qtyCtl: sz.qtyCtl, qtyMax: sz.qtyMax, hasOrdInput: sz.hasOrdInput, sweep,
    rawPriceCalls: allPriceCalls.map(c => ({ mark: c.mark, status: c.status, reqBody: c.reqBody, respBody: c.respBody })),
  };
  fs.writeFileSync(path.join(OUT, `qtysweep_${PRODUCT}.json`), redact(JSON.stringify(out, null, 2)));
  console.log(`=== ${PRODUCT} size=${sz.sizePicked} qtyCtl=${sz.qtyCtl} qtyMax=${sz.qtyMax} ordInput=${sz.hasOrdInput}`);
  for (const s of sweep) console.log(`  ${s.via}=${s.requested} cap=${s.captured} ORD_CNT=${s.ORD_CNT_echo} PRN_CNT=${s.PRN_CNT_echo} PRICE=${s.PRICE} mats=${JSON.stringify((s.materials || []).map(m => m.PCS_COD + ':' + m.ATTB))}`);
  await browser.close();
}
run().catch(e => { console.error('ERR', e); process.exit(1); });
