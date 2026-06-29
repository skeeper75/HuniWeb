const { chromium } = require('playwright');
const fs=require('fs'); const path=require('path');
const BASE='http://localhost:3001'; const PRODUCT='GSPUFBC';
const redact=s=>(s||'').replace(/(token=)[^&"\s]+/gi,'$1[REDACTED]').replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g,'[JWT]');
const calls=[];
(async()=>{
  const b=await chromium.launch({headless:true});
  const page=await(await b.newContext({viewport:{width:1440,height:1400}})).newPage();
  page.context().on('response',async r=>{if(/get_ajax_price_vTmpl/.test(r.url())){let j=null;try{j=await r.json();}catch{} let q=null;try{q=r.request().postData();}catch{} calls.push({reqBody:q,respBody:j});}});
  await page.goto(BASE,{waitUntil:'load',timeout:20000}); await page.waitForTimeout(1000);
  await page.evaluate(async c=>{if(window.selectProduct)await window.selectProduct(c,c);},PRODUCT);
  await page.waitForTimeout(7000);
  // set ORD_CNT first via the widget's quantity input (unnamed number val=1)
  const sizeResults=[];
  for(let si=0; si<5; si++){
    await page.evaluate((idx)=>{
      function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
      const host=document.getElementById('redWidgetSdk');
      const fire=(el,ev)=>ev.forEach(t=>el.dispatchEvent(new Event(t,{bubbles:true})));
      for(const el of walk(host.shadowRoot)){
        if(el.tagName==='SELECT'&&el.name==='sizes'){el.selectedIndex=idx;fire(el,['change']);}
      }
    }, si);
    await page.waitForTimeout(2500);
    const dims=await page.evaluate(()=>{
      function* walk(r){for(const e of r.querySelectorAll('*')){yield e;if(e.shadowRoot)yield* walk(e.shadowRoot);}}
      const host=document.getElementById('redWidgetSdk'); const nums=[];let sizeText='';
      for(const el of walk(host.shadowRoot)){
        if(el.tagName==='INPUT'&&el.type==='number')nums.push(el.value);
        if(el.tagName==='SELECT'&&el.name==='sizes')sizeText=(el.options[el.selectedIndex].textContent||'').trim();
      }
      return {sizeText, nums};
    });
    sizeResults.push({idx:si, ...dims, lastReq:calls.length?calls[calls.length-1].reqBody:null, lastPrice:calls.length?(calls[calls.length-1].respBody?.result_sum?.PRICE):null});
  }
  fs.writeFileSync('/tmp/pouch_sizes.json', JSON.stringify({sizeResults,calls:calls.map(c=>({reqBody:redact(c.reqBody),PRICE:c.respBody?.result_sum?.PRICE}))},null,2));
  sizeResults.forEach(s=>console.log(`idx${s.idx} "${s.sizeText}" nums=[${s.nums.join(',')}] price=${s.lastPrice}`));
  await b.close();
})().catch(e=>{console.error(e);process.exit(1);});
