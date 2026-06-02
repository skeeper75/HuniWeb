/**
 * S6 calendar capture — probe Vue3 widget mount + option schema + price model for calendar SKUs.
 * For each code: selectProduct → detect mount → dump shadow option schema (selects/inputs) →
 * pick first real size preset + qty 100 to force PRICE>0 → capture get_ajax_price_vTmpl reqBody/resp.
 * Goal: determine which calendar SKUs mount in Vue3 testbed + their price model (PriceTable3D variant?).
 * Output: 05_qa/captures/s6_cal_<CODE>.json + raw mirror. Read-only (no order/payment).
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const CODES = (process.env.PRODUCTS || 'HLCLSTD,HLCLWAL,TPCLECO,TPCLWLB,GSCLMGN').split(',');
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
const RAW = path.resolve(__dirname, '../../../_workspace/huni-widget/01_reverse/s3_raw_captures');
fs.mkdirSync(OUT, { recursive: true }); fs.mkdirSync(RAW, { recursive: true });
const redact = s => (s||'').replace(/(token=)[^&"\s]+/gi,'$1[REDACTED]').replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g,'[JWT]');

async function captureOne(page, code) {
  const priceCalls = [];
  const infoCalls = [];
  const t0 = Date.now(); const rel = () => Date.now() - t0;
  const onResp = async resp => {
    const u = resp.url();
    if (/get_ajax_price_vTmpl/.test(u)) {
      let r=null; try{r=await resp.json();}catch{}
      let req=null; try{req=resp.request().postData();}catch{}
      priceCalls.push({ rel:rel(), status:resp.status(), reqBody:req, respBody:r });
    } else if (/get_digital_product_info/.test(u)) {
      let r=null; try{r=await resp.json();}catch{}
      infoCalls.push({ rel:rel(), status:resp.status(), respBody:r });
    }
  };
  page.context().on('response', onResp);

  await page.goto(BASE, { waitUntil:'load', timeout:20000 });
  await page.waitForTimeout(800);
  await page.evaluate(async c => { if(window.selectProduct) await window.selectProduct(c,c); }, code);
  await page.waitForTimeout(6000);

  // dump option schema from shadow DOM
  const schema = await page.evaluate(() => {
    function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
    const host=document.getElementById('redWidgetSdk');
    if(!host||!host.shadowRoot) return {mounted:false};
    const selects=[], numbers=[], radios=new Set(), textInputs=[];
    let nodeCount=0;
    for(const el of walk(host.shadowRoot)){
      nodeCount++;
      if(el.tagName==='SELECT') selects.push({ name:el.name||el.id||'', options:[...el.options].map(o=>(o.textContent||'').trim()).slice(0,40) });
      if(el.tagName==='INPUT'&&el.type==='number') numbers.push({ name:el.name||el.id||'', value:el.value });
      if(el.tagName==='INPUT'&&el.type==='radio') radios.add(el.name||'');
      if(el.tagName==='INPUT'&&el.type==='text') textInputs.push(el.name||el.id||'');
    }
    const txt = (host.shadowRoot.textContent||'').replace(/\s+/g,' ').trim().slice(0,300);
    return { mounted:true, nodeCount, selects, numbers, radioGroups:[...radios], textInputs, textSample:txt };
  });

  let action = {ok:false};
  if (schema.mounted) {
    // pick first real size preset (idx 1) + qty 100
    action = await page.evaluate(() => {
      function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
      const host=document.getElementById('redWidgetSdk'); if(!host||!host.shadowRoot) return {ok:false};
      let sizeSel=null, qty=null;
      for(const el of walk(host.shadowRoot)){
        if(el.tagName==='SELECT'&&/size|규격|사이즈/i.test((el.name||'')+(el.id||''))) sizeSel=el;
        if(el.tagName==='INPUT'&&el.type==='number'&&/ORD_CNT|수량|qty|cnt/i.test(el.name||'')) qty=el;
      }
      if(!sizeSel){ for(const el of walk(host.shadowRoot)){ if(el.tagName==='SELECT'&&el.options.length>1){sizeSel=el;break;} } }
      if(!qty){ for(const el of walk(host.shadowRoot)){ if(el.tagName==='INPUT'&&el.type==='number'){qty=el;break;} } }
      let picked=null;
      if(sizeSel&&sizeSel.options.length>1){ sizeSel.selectedIndex=Math.min(1,sizeSel.options.length-1); sizeSel.dispatchEvent(new Event('change',{bubbles:true})); picked=(sizeSel.options[sizeSel.selectedIndex].textContent||'').trim(); }
      if(qty){ qty.value='100'; qty.dispatchEvent(new Event('input',{bubbles:true})); qty.dispatchEvent(new Event('change',{bubbles:true})); }
      return { ok:true, sizePicked:picked, sizeName:sizeSel?(sizeSel.name||sizeSel.id):null, qtySet:!!qty, qtyName:qty?qty.name:null };
    });
    await page.waitForTimeout(4000);
  }

  page.context().off('response', onResp);
  const out = { product:code, capturedAt:new Date().toISOString(), schema, action,
    infoCalls: infoCalls.map(c=>({rel:c.rel,status:c.status,respBody:c.respBody})),
    priceCalls: priceCalls.map(c=>({rel:c.rel,status:c.status,reqBody:c.reqBody,respBody:c.respBody})) };
  // redact JWTs/tokens across the WHOLE serialized output (respBody can echo session tokens — safety rule #5)
  const serialized = redact(JSON.stringify(out,null,2));
  fs.writeFileSync(path.join(OUT,`s6_cal_${code}.json`), serialized);
  fs.writeFileSync(path.join(RAW,`s6_cal_${code}.json`), serialized);
  console.log(`[${code}] mounted=${schema.mounted} nodes=${schema.nodeCount||0} selects=${schema.selects?schema.selects.length:0} priceCalls=${priceCalls.length} info=${infoCalls.length}`);
  return out;
}

async function run() {
  const browser = await chromium.launch({ headless: true });
  const summary = [];
  for (const code of CODES) {
    const ctx = await browser.newContext({ viewport:{width:1440,height:1100} });
    const page = await ctx.newPage();
    try { const o = await captureOne(page, code); summary.push({ code, mounted:o.schema.mounted, priceCalls:o.priceCalls.length }); }
    catch(e){ console.error(`[${code}] ERR`, e.message); summary.push({ code, error:e.message }); }
    await ctx.close();
    await new Promise(r=>setTimeout(r, 1500)); // throttle (safety rule #2)
  }
  console.log('[SUMMARY]', JSON.stringify(summary));
  await browser.close();
}
run().catch(e=>{console.error('ERR',e);process.exit(1);});
