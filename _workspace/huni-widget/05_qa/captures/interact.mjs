import { chromium } from 'playwright';
const URL = 'http://localhost:5173/';
const reqs = [];
const browser = await chromium.launch({ channel: 'chrome', headless: true, args: ['--no-sandbox'] });
const page = await browser.newContext({ viewport: { width: 800, height: 1400 } }).then((c) => c.newPage());
page.on('requestfailed', (r) => reqs.push({ url: r.url(), failure: r.failure()?.errorText }));
page.on('response', (r) => { if (r.status() >= 400) reqs.push({ url: r.url(), status: r.status() }); });
await page.goto(URL, { waitUntil: 'networkidle' });
await page.waitForFunction(() => document.getElementById('host')?.shadowRoot?.getElementById('huni-widget-root')?.children.length > 0, { timeout: 15000 });
await page.waitForTimeout(1200);

// grab total text (합계 line) before
const grabTotal = () => page.evaluate(() => {
  const sr = document.getElementById('host').shadowRoot;
  const spans = Array.from(sr.querySelectorAll('span'));
  const idx = spans.findIndex((s) => s.textContent.trim() === '합계');
  return idx >= 0 ? spans[idx + 1]?.textContent.trim() : null;
});
const before = await grabTotal();

// click '양면' (dosu second option) to trigger a different price
await page.evaluate(() => {
  const sr = document.getElementById('host').shadowRoot;
  const btn = Array.from(sr.querySelectorAll('button')).find((b) => b.textContent.trim() === '양면');
  if (btn) { const r = btn.getBoundingClientRect(); window.__cx = r.x + r.width/2; window.__cy = r.y + r.height/2; }
});
const cx = await page.evaluate(() => window.__cx), cy = await page.evaluate(() => window.__cy);
if (cx) await page.mouse.click(cx, cy);
await page.waitForTimeout(1000);
const after = await grabTotal();

await browser.close();
console.log(JSON.stringify({ failedOrErrorRequests: reqs, totalBefore: before, totalAfter: after, recalcTriggered: before !== after }, null, 2));
