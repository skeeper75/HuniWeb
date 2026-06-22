import { chromium } from 'playwright';
const BASE='http://localhost:5173';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport:{width:600,height:1100}});
const errors=[];
page.on('console', m=>{ if(m.type()==='error') errors.push(m.text()); });
page.on('pageerror', e=>errors.push('PAGEERR: '+e.message));

// 1) AIPPCUT — must be ECOBAG (SizeMatrix2D), NOT a book
await page.goto(`${BASE}/?p=AIPPCUT`,{waitUntil:'networkidle'});
await page.waitForTimeout(900);
const aip = await page.evaluate(()=>{
  const sr=document.getElementById('host')?.shadowRoot;
  if(!sr) return {error:'no shadowRoot'};
  const labels=[...sr.querySelectorAll('label,h2,[class*="label"]')].map(e=>e.textContent?.trim()).filter(t=>t&&t.length<40).slice(0,30);
  const txt=(sr.textContent||'');
  return { labels, isBook:/표지|내지|면지|제본/.test(txt), hasDim:/가로|세로|직접입력/.test(txt), bodyLen:txt.length };
});
await page.screenshot({path:'gate_reverify_AIPPCUT.png',fullPage:true});
console.log('AIPPCUT:', JSON.stringify(aip));

// 2) Unknown product — must surface explicit error, NOT silently become a book
await page.goto(`${BASE}/?p=ZZUNKNOWN9`,{waitUntil:'networkidle'}).catch(e=>console.log('nav err(ok):',e.message));
await page.waitForTimeout(900);
const unk = await page.evaluate(()=>{
  const sr=document.getElementById('host')?.shadowRoot;
  const txt=sr?.textContent||'';
  return { hasShadow:!!sr, isBook:/표지|내지|면지|제본방향/.test(txt), bodyLen:txt.length, snippet:txt.slice(0,120) };
});
console.log('UNKNOWN ZZUNKNOWN9:', JSON.stringify(unk));
console.log('CONSOLE ERRORS:', JSON.stringify(errors.slice(0,6)));
await browser.close();
console.log('DONE');
