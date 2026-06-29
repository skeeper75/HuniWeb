/**
 * S3 MAJOR round capture — probes product option payloads (get_digital_product_info)
 * to harvest baseline data for Wave B/C reproduction:
 *  - ATTB attribute-chip values (BID_SIL / RIN_DFT post-process)
 *  - ROU_DFT radius sourcing (roundingConfigMap factor / DIV_SEQ / ATTB radius)
 *  - apparel_info shape (PRINT_TYPE branches, multi-size, Pantone/color)
 *  - ACC sub-material filter tree (accFilterConfigMap, uiType, GRP_TYPE)
 * Read-only (info GET + maybe one price). No order/payment.
 * Full-output redact per skill HARD rule.
 * Usage: PRODUCT=CODE TAG=attbchip node major-capture.cjs
 * Output: 05_qa/captures/major_<TAG>_<PRODUCT>.json
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'BCSPDFT';
const TAG = process.env.TAG || 'probe';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
fs.mkdirSync(OUT, { recursive: true });
const redact = s => (s||'').replace(/(token=)[^&"\s]+/gi,'$1[REDACTED]')
  .replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g,'[JWT]');

const t0 = Date.now(); const rel = () => Date.now() - t0;

// recursively find keys of interest in product_info
function scanInfo(info) {
  const found = {
    pcsCodesPresent: new Set(),
    attbBearing: [],      // post-process entries that carry ATTB / attbOptions
    rouEntries: [],       // ROU_DFT entries with DIV_SEQ / ATTB radius
    apparel: null,        // apparel_info block
    accFilters: null,     // acc filter config
    sizeCount: 0,
    materialCount: 0,
    topKeys: [],
  };
  if (!info || typeof info !== 'object') return found;
  found.topKeys = Object.keys(info).slice(0, 40);

  // helper to walk arrays of pcs entries
  const walk = (node, depth=0) => {
    if (depth > 6 || node == null) return;
    if (Array.isArray(node)) { node.forEach(n => walk(n, depth+1)); return; }
    if (typeof node !== 'object') return;
    // pcs entry?
    const pc = node.PCS_CD || node.PCS_COD;
    if (pc) {
      found.pcsCodesPresent.add(pc);
      // ATTB-bearing?
      const hasAttb = ('ATTB' in node) || ('ATTB_CD' in node) || ('ATTB_NM' in node) || ('attbOptions' in node) || ('ATTB_VAL' in node);
      if (hasAttb && (pc === 'BID_SIL' || pc === 'RIN_DFT' || /BID|RIN|SIL/.test(pc))) {
        found.attbBearing.push({
          PCS_CD: pc, PCS_DTL_CD: node.PCS_DTL_CD || node.PCS_DTL_COD,
          PCS_DTL_NM: node.PCS_DTL_NM, ATTB: node.ATTB, ATTB_CD: node.ATTB_CD, ATTB_NM: node.ATTB_NM,
          attbOptions: node.attbOptions, DIV_SEQ: node.DIV_SEQ, sample: Object.keys(node).slice(0,16)
        });
      }
      if (pc === 'ROU_DFT') {
        found.rouEntries.push({
          PCS_DTL_CD: node.PCS_DTL_CD || node.PCS_DTL_COD, PCS_DTL_NM: node.PCS_DTL_NM,
          DIV_SEQ: node.DIV_SEQ, ATTB: node.ATTB, WEB_PCS_DTL_GRP: node.WEB_PCS_DTL_GRP,
          keys: Object.keys(node).slice(0,18)
        });
      }
    }
    for (const k of Object.keys(node)) {
      if (/apparel/i.test(k) && !found.apparel) found.apparel = node[k];
      if (/accFilter|filterConfig|acc_filter/i.test(k) && !found.accFilters) found.accFilters = node[k];
      walk(node[k], depth+1);
    }
  };
  walk(info);
  found.pcsCodesPresent = [...found.pcsCodesPresent];
  return found;
}

async function run() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport:{width:1440,height:1100} });
  const page = await context.newPage();
  let infoRaw = null; let infoUrl = null;
  const infoCalls = [];
  context.on('response', async resp => {
    const u = resp.url();
    if (/get_digital_product_info|get_product_info|product\/get/.test(u)) {
      let r=null; try{ r = await resp.json(); }catch{}
      infoCalls.push({ rel: rel(), url: u.replace(BASE,'').split('?')[0], status: resp.status() });
      if (r && !infoRaw) { infoRaw = r; infoUrl = u.replace(BASE,'').split('?')[0]; }
    }
  });

  await page.goto(BASE, { waitUntil:'load', timeout:20000 });
  await page.waitForTimeout(800);
  await page.evaluate(async c => { if(window.selectProduct) await window.selectProduct(c,c); }, PRODUCT);
  await page.waitForTimeout(7000);

  // mount + shadow option dump
  const widgetDump = await page.evaluate(() => {
    function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
    const host=document.getElementById('redWidgetSdk');
    if(!host||!host.shadowRoot) return {mounted:false};
    const sels=[]; const nums=[]; const btns=[]; const checks=[];
    for(const el of walk(host.shadowRoot)){
      if(el.tagName==='SELECT') sels.push({name:el.name, n:el.options.length, opts:[...el.options].slice(0,12).map(o=>({v:o.value,t:(o.textContent||'').trim()}))});
      if(el.tagName==='INPUT'&&el.type==='number') nums.push({name:el.name, value:el.value, ro:el.readOnly});
      if(el.tagName==='INPUT'&&el.type==='checkbox') checks.push({name:el.name, label:(el.closest('label')?.textContent||'').trim().slice(0,30)});
      if(el.tagName==='BUTTON') btns.push((el.textContent||'').trim().slice(0,24));
    }
    return { mounted:true, selects:sels, numInputs:nums, checkboxes:checks.slice(0,30), buttons:btns.slice(0,25) };
  });

  const scan = infoRaw ? scanInfo(infoRaw.product_data || infoRaw.data || infoRaw) : null;

  const out = {
    product: PRODUCT, tag: TAG, capturedAt: new Date().toISOString(),
    purpose: 'S3 MAJOR round baseline harvest',
    infoEndpoint: infoUrl, infoCalls,
    widgetMounted: widgetDump.mounted,
    widgetDump,
    scan,
    // raw product_data kept (redacted), but trimmed to avoid token bloat: keep keys + targeted blocks
    productDataKeys: infoRaw ? Object.keys(infoRaw.product_data || infoRaw.data || infoRaw).slice(0,40) : null,
    rawProductData: infoRaw ? (infoRaw.product_data || infoRaw.data || infoRaw) : null,
  };
  const serialized = redact(JSON.stringify(out,null,2));
  fs.writeFileSync(path.join(OUT, `major_${TAG}_${PRODUCT}.json`), serialized);
  console.log('[DONE]', TAG, PRODUCT, 'mounted=', widgetDump.mounted, 'infoCalls=', infoCalls.length);
  if (scan) {
    console.log('  pcsCodes=', JSON.stringify(scan.pcsCodesPresent));
    console.log('  attbBearing=', scan.attbBearing.length, 'rouEntries=', scan.rouEntries.length,
                'apparel=', !!scan.apparel, 'accFilters=', !!scan.accFilters);
  }
  await browser.close();
}
run().catch(e=>{console.error('ERR',e);process.exit(1);});
