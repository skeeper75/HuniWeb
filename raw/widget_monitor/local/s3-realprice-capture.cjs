/**
 * S3 real-price capture — fixes a size preset + sets quantity to force PRICE>0,
 * then ALSO sets free W/H (사이즈직접입력) to observe 2D unit-price delta.
 * Goal: SizeMatrix2D evidence — same product, two different (cutW,cutH) → two prices.
 * Output: 05_qa/captures/s3_rp_<CODE>.json  (raw mirror too). Read-only.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'PRPOXXX';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
const RAW = path.resolve(__dirname, '../../../_workspace/huni-widget/01_reverse/s3_raw_captures');
fs.mkdirSync(OUT, { recursive: true }); fs.mkdirSync(RAW, { recursive: true });
const priceCalls = [];
const t0 = Date.now(); const rel = () => Date.now() - t0;
const redact = s => (s||'').replace(/(token=)[^&"\s]+/gi,'$1[REDACTED]').replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g,'[JWT]');

async function run() {
  const browser = await chromium.launch({ headless: true });
  const page = await (await browser.newContext({ viewport:{width:1440,height:1100} })).newPage();
  page.context().on('response', async resp => {
    if (/get_ajax_price_vTmpl/.test(resp.url())) {
      let r=null; try{r=await resp.json();}catch{}
      let req=null; try{req=resp.request().postData();}catch{}
      priceCalls.push({ rel:rel(), status:resp.status(), reqBody:req, respBody:r });
    }
  });
  await page.goto(BASE, { waitUntil:'load', timeout:20000 });
  await page.waitForTimeout(1000);
  await page.evaluate(async c => { if(window.selectProduct) await window.selectProduct(c,c); }, PRODUCT);
  await page.waitForTimeout(6000);

  // Step 1: pick a real size preset (index 1, first non-direct-input) + set qty 100
  const step1 = await page.evaluate(() => {
    function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
    const host=document.getElementById('redWidgetSdk'); if(!host||!host.shadowRoot) return {ok:false};
    let sizeSel=null, qty=null;
    for(const el of walk(host.shadowRoot)){
      if(el.tagName==='SELECT'&&(el.name==='sizes'||/size/i.test(el.name||''))) sizeSel=el;
      if(el.tagName==='INPUT'&&el.type==='number'&&(el.name==='ORD_CNT'||/ORD_CNT|수량|qty/i.test(el.name||''))) qty=el;
    }
    let picked=null;
    if(sizeSel&&sizeSel.options.length>1){ sizeSel.selectedIndex=1; sizeSel.dispatchEvent(new Event('change',{bubbles:true})); picked=(sizeSel.options[1].textContent||'').trim(); }
    if(qty){ qty.value='100'; qty.dispatchEvent(new Event('input',{bubbles:true})); qty.dispatchEvent(new Event('change',{bubbles:true})); }
    return { ok:true, sizePicked:picked, qtySet: !!qty, qtyName: qty?qty.name:null };
  });
  console.log('[step1]', JSON.stringify(step1));
  await page.waitForTimeout(3500);

  // Step 2: switch to 사이즈직접입력 (index 0) and set free W/H to a DIFFERENT 2D point
  const step2 = await page.evaluate(() => {
    function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
    const host=document.getElementById('redWidgetSdk'); if(!host||!host.shadowRoot) return {ok:false};
    let sizeSel=null; const nums=[];
    for(const el of walk(host.shadowRoot)){
      if(el.tagName==='SELECT'&&/size/i.test(el.name||'')) sizeSel=el;
      if(el.tagName==='INPUT'&&el.type==='number') nums.push(el);
    }
    if(sizeSel){ sizeSel.selectedIndex=0; sizeSel.dispatchEvent(new Event('change',{bubbles:true})); }
    const wIn=nums.find(n=>n.name==='w-재단사이즈') || nums.find(n=>(n.name||'').startsWith('w-재단')) || nums.find(n=>(n.name||'').startsWith('w'));
    const hIn=nums.find(n=>n.name==='h-재단사이즈') || nums.find(n=>(n.name||'').startsWith('h-재단')) || nums.find(n=>(n.name||'').startsWith('h'));
    if(wIn){ wIn.value='600'; wIn.dispatchEvent(new Event('input',{bubbles:true})); wIn.dispatchEvent(new Event('change',{bubbles:true})); }
    if(hIn){ hIn.value='900'; hIn.dispatchEvent(new Event('input',{bubbles:true})); hIn.dispatchEvent(new Event('change',{bubbles:true})); }
    return { ok:true, wSet:wIn?wIn.name:null, hSet:hIn?hIn.name:null, numCount:nums.length };
  });
  console.log('[step2]', JSON.stringify(step2));
  await page.waitForTimeout(3500);

  const out = { product:PRODUCT, capturedAt:new Date().toISOString(), step1, step2,
    priceCalls: priceCalls.map(c=>({rel:c.rel,status:c.status,reqBody:redact(c.reqBody),respBody:c.respBody})) };
  fs.writeFileSync(path.join(OUT,`s3_rp_${PRODUCT}.json`), JSON.stringify(out,null,2));
  fs.writeFileSync(path.join(RAW,`s3_rp_${PRODUCT}.json`), JSON.stringify(out,null,2));
  console.log('[DONE]', PRODUCT, 'priceCalls=', priceCalls.length);
  await browser.close();
}
run().catch(e=>{console.error('ERR',e);process.exit(1);});
