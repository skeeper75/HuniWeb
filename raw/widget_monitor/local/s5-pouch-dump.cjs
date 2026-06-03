/**
 * S5 Pouch GSPUFBC — full Shadow DOM option dump + progressive selection to force PRICE>0.
 * Read-only: only interacts with the live widget UI, captures price API req/resp.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const PRODUCT = process.env.PRODUCT || 'GSPUFBC';
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
const redact = s => (s||'').replace(/(token=)[^&"\s]+/gi,'$1[REDACTED]').replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g,'[JWT]');

const priceCalls = [];
const t0 = Date.now(); const rel = () => Date.now() - t0;

async function dumpControls(page) {
  return await page.evaluate(() => {
    function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
    const host=document.getElementById('redWidgetSdk');
    if(!host||!host.shadowRoot) return {ok:false};
    const controls=[];
    for(const el of walk(host.shadowRoot)){
      const tag=el.tagName;
      if(tag==='SELECT'){
        controls.push({tag:'SELECT', name:el.name||'', id:el.id||'',
          value:el.value, selectedIndex:el.selectedIndex,
          options:[...el.options].map((o,i)=>({i, val:o.value, text:(o.textContent||'').trim().slice(0,40), sel:o.selected}))});
      } else if(tag==='INPUT'){
        controls.push({tag:'INPUT', type:el.type, name:el.name||'', id:el.id||'',
          value:el.value, checked:el.checked, placeholder:el.placeholder||''});
      } else if(tag==='BUTTON'){
        const txt=(el.textContent||'').trim().slice(0,30);
        if(txt) controls.push({tag:'BUTTON', name:el.name||'', text:txt,
          ariaPressed:el.getAttribute('aria-pressed'), cls:(el.className||'').slice(0,40), disabled:el.disabled});
      }
    }
    const labels=[];
    for(const el of walk(host.shadowRoot)){
      if(/option|label|title/i.test(el.className||'') && el.children.length===0){
        const t=(el.textContent||'').trim(); if(t&&t.length<40) labels.push(t);
      }
    }
    return {ok:true, controls, labelsSample:labels.slice(0,60)};
  });
}

async function run() {
  const browser = await chromium.launch({ headless: true });
  const page = await (await browser.newContext({ viewport:{width:1440,height:1400} })).newPage();
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
  await page.waitForTimeout(7000);

  const dump0 = await dumpControls(page);
  console.log('[DUMP0 controls]', dump0.controls ? dump0.controls.length : 'none');

  const actions = await page.evaluate(() => {
    function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
    const host=document.getElementById('redWidgetSdk');
    const done=[];
    const fire=(el,evts)=>evts.forEach(t=>el.dispatchEvent(new Event(t,{bubbles:true})));
    for(const el of walk(host.shadowRoot)){
      if(el.tagName==='SELECT' && el.options.length>1){
        let idx=-1;
        for(let i=0;i<el.options.length;i++){const o=el.options[i];const tx=(o.textContent||'');if(o.value&&!/직접입력|선택|please|choose/i.test(tx)){idx=i;break;}}
        if(idx<0) idx=el.options.length-1;
        el.selectedIndex=idx; fire(el,['change']);
        done.push({sel:el.name||el.id, pickedIdx:idx, pickedText:(el.options[idx].textContent||'').trim().slice(0,30)});
      }
      if(el.tagName==='INPUT'&&el.type==='number'){
        if(/ORD_CNT|수량|qty|cnt/i.test(el.name||el.id||'')){el.value='100'; fire(el,['input','change']);done.push({qtyInput:el.name||el.id,set:100});}
      }
    }
    return done;
  });
  console.log('[ACTIONS]', JSON.stringify(actions).slice(0,500));
  await page.waitForTimeout(4000);

  const dump1 = await dumpControls(page);

  const out = { product:PRODUCT, capturedAt:new Date().toISOString(),
    dump0, actions, dump1,
    priceCalls: priceCalls.map(c=>({rel:c.rel,status:c.status,reqBody:redact(c.reqBody),respBody:c.respBody})) };
  fs.mkdirSync(OUT,{recursive:true});
  // [보안] respBody가 Edicus 세션 JWT를 echo할 수 있어 직렬화 출력 전체를 redact (안전규칙 #5)
  fs.writeFileSync(path.join(OUT,`s5_pouch_${PRODUCT}_raw.json`), redact(JSON.stringify(out,null,2)));
  const lastWithPrice = [...priceCalls].reverse().find(c=>c.respBody&&c.respBody.result_sum&&c.respBody.result_sum.PRICE>0);
  const lastAny = priceCalls[priceCalls.length-1];
  if(lastAny&&lastAny.reqBody){fs.writeFileSync(`/tmp/pouch_full_req.json`, redact(lastAny.reqBody));}
  console.log('[DONE] priceCalls=', priceCalls.length, '| anyPRICE>0:', !!lastWithPrice);
  priceCalls.forEach((c,i)=>{const s=c.respBody&&c.respBody.result_sum;console.log(`  call#${i} status=${c.status} PRICE=${s?s.PRICE:'?'} msg=${c.respBody?c.respBody.msg||'':''}`);});
  await browser.close();
}
run().catch(e=>{console.error('ERR',e);process.exit(1);});
