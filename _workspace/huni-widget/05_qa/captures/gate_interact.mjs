import { chromium } from 'playwright';
const BASE='http://localhost:5173';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport:{width:600,height:1200}});

// --- PRBKYPR cascade: open cover-material select, pick a low-weight paper, observe finish disable
await page.goto(`${BASE}/?p=PRBKYPR`,{waitUntil:'networkidle'});
await page.waitForTimeout(800);
const before = await page.evaluate(()=>{
  const sr=document.getElementById('host').shadowRoot;
  // count disabled finish buttons before
  const btns=[...sr.querySelectorAll('button')];
  const disabled=btns.filter(b=>b.disabled||b.getAttribute('aria-disabled')==='true'||/disabled/.test(b.className)).length;
  return { totalBtns:btns.length, disabled };
});
// Try changing material via select. HuniSelect is a combobox; click then pick option containing 모조 if exists
const mtrlChanged = await page.evaluate(()=>{
  const sr=document.getElementById('host').shadowRoot;
  const combos=[...sr.querySelectorAll('[role="combobox"],button')].filter(e=>/아트지|모조|용지/.test(e.textContent||''));
  return combos.map(c=>c.textContent?.trim()).slice(0,5);
});
console.log('PRBKYPR before:', JSON.stringify(before), 'mtrl candidates:', JSON.stringify(mtrlChanged));

// --- BNBNFBL free-input clamp: type oversize value into dimension input
await page.goto(`${BASE}/?p=BNBNFBL`,{waitUntil:'networkidle'});
await page.waitForTimeout(800);
// select 사이즈직접입력 chip first
await page.evaluate(()=>{
  const sr=document.getElementById('host').shadowRoot;
  const chip=[...sr.querySelectorAll('button')].find(b=>/직접입력/.test(b.textContent||''));
  if(chip) chip.click();
});
await page.waitForTimeout(400);
const clampTest = await page.evaluate(()=>{
  const sr=document.getElementById('host').shadowRoot;
  const inputs=[...sr.querySelectorAll('input')];
  const numInputs=inputs.filter(i=>i.type==='number'||i.inputMode==='numeric'||/가로|세로|mm/.test(i.placeholder||''));
  return { totalInputs:inputs.length, numInputs:numInputs.length, placeholders:inputs.map(i=>i.placeholder).filter(Boolean) };
});
console.log('BNBNFBL inputs after 직접입력:', JSON.stringify(clampTest));
await browser.close();
console.log('DONE');
