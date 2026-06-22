import { chromium } from 'playwright';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport:{width:600,height:1400}});
await page.goto('http://localhost:5173/?p=PRBKYPR',{waitUntil:'networkidle'});
await page.waitForTimeout(1000);
const r = await page.evaluate(()=>{
  const sr=document.getElementById('host')?.shadowRoot;
  if(!sr) return {error:'no sr'};
  // find 면지 (END_PAP) section — look for the LargeColorChip grid
  const txt=sr.textContent||'';
  const hasEndPap=/면지/.test(txt);
  // collect chips with computed background-color
  const chips=[...sr.querySelectorAll('button')].filter(b=>{
    const bg=getComputedStyle(b).backgroundColor;
    // chip-like: has a non-white/non-transparent bg OR is in 면지 area; gather all with rounded-full circle
    return b.style.backgroundColor || /rounded-full/.test(b.className);
  });
  const chipStyles=chips.slice(0,14).map(b=>({inlineBg:b.style.backgroundColor, computedBg:getComputedStyle(b).backgroundColor, br:getComputedStyle(b).borderRadius}));
  // is 면지 rendered as select (combobox) instead of chips? count comboboxes near 면지
  const selects=sr.querySelectorAll('[role="combobox"]').length;
  return { hasEndPap, chipCount:chips.length, chipStyles, selects };
});
await page.screenshot({path:'wave_a_L4_PRBKYPR.png',fullPage:true});
console.log(JSON.stringify(r,null,1));
await browser.close();
