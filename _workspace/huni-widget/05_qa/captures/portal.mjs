// Focused Portal-in-Shadow test: click the real Radix Popover trigger (button[aria-haspopup=listbox]).
import { chromium } from 'playwright';
const URL = 'http://localhost:5173/';
const OUT = '/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/05_qa/captures';
const browser = await chromium.launch({ channel: 'chrome', headless: true, args: ['--no-sandbox'] });
const page = await browser.newContext({ viewport: { width: 800, height: 1400 }, deviceScaleFactor: 2 }).then((c) => c.newPage());
await page.goto(URL, { waitUntil: 'networkidle' });
await page.waitForFunction(() => {
  const h = document.getElementById('host');
  return h?.shadowRoot?.getElementById('huni-widget-root')?.children.length > 0;
}, { timeout: 15000 });
await page.waitForTimeout(1200);

const out = {};
// locate the select trigger via piercing
const triggerInfo = await page.evaluate(() => {
  const sr = document.getElementById('host').shadowRoot;
  const triggers = Array.from(sr.querySelectorAll('button[aria-haspopup="listbox"]'));
  return { count: triggers.length, labels: triggers.map((t) => t.getAttribute('aria-label')) };
});
out.triggers = triggerInfo;

// click first listbox trigger by computing its position and using mouse (Radix needs real pointer)
const clicked = await page.evaluate(() => {
  const sr = document.getElementById('host').shadowRoot;
  const t = sr.querySelector('button[aria-haspopup="listbox"]');
  if (!t) return null;
  const r = t.getBoundingClientRect();
  return { x: r.x + r.width / 2, y: r.y + r.height / 2 };
});
if (clicked) {
  await page.mouse.click(clicked.x, clicked.y);
  await page.waitForTimeout(600);
}

const probe = await page.evaluate(() => {
  const sr = document.getElementById('host').shadowRoot;
  const listInShadow = sr.querySelector('[role="listbox"]');
  const optsInShadow = sr.querySelectorAll('[role="option"]').length;
  const listInBody = document.body.querySelector('[role="listbox"]');
  // detect any radix portal wrapper escaped to body
  const radixInBody = document.body.querySelectorAll('[data-radix-popper-content-wrapper]').length;
  const radixInShadow = sr.querySelectorAll('[data-radix-popper-content-wrapper]').length;
  let styled = null;
  if (listInShadow) {
    const cs = getComputedStyle(listInShadow);
    styled = { bg: cs.backgroundColor, border: cs.borderTopWidth + ' ' + cs.borderStyle, fontFamily: cs.fontFamily, boxShadow: cs.boxShadow.slice(0, 40), maxHeight: cs.maxHeight };
    // first option style
    const opt = listInShadow.querySelector('[role="option"]');
    if (opt) { const oc = getComputedStyle(opt); styled.optFont = oc.fontSize; styled.optFontFamily = oc.fontFamily; }
  }
  return { listInShadow: !!listInShadow, optsInShadow, listInBody: !!listInBody, radixInBody, radixInShadow, styled };
});
out.probe = probe;
out.PASS = probe.listInShadow && !probe.listInBody && probe.radixInBody === 0;

await page.screenshot({ path: `${OUT}/pass1_select_open.png`, fullPage: true });
await browser.close();
console.log('===PORTAL_JSON_START===');
console.log(JSON.stringify(out, null, 2));
console.log('===PORTAL_JSON_END===');
