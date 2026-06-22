import { chromium } from 'playwright';
import { writeFileSync } from 'fs';
const BASE = 'http://localhost:5173';
const all = ['BNBNFBL', 'BNPTPET', 'ACNTHAP'];
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 600, height: 1100 } });
const report = {};
for (const code of all) {
  await page.goto(`${BASE}/?p=${code}`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(900);
  const struct = await page.evaluate(() => {
    const sr = document.getElementById('host')?.shadowRoot;
    if (!sr) return { error: 'no sr' };
    const labels = [...sr.querySelectorAll('label, h2, [class*="label"]')].map(e=>e.textContent?.trim()).filter(t=>t&&t.length<40).slice(0,30);
    const hasDimMatrix = !!sr.querySelector('input[type="number"], input[inputmode="numeric"]') || /가로|세로/.test(sr.textContent||'');
    const buttons = sr.querySelectorAll('button').length;
    const inputs = sr.querySelectorAll('input').length;
    return { labels, hasDimMatrix, buttons, inputs };
  });
  report[code] = struct;
  await page.screenshot({ path: `gate_${code}.png`, fullPage: true });
  console.log(`[${code}] buttons=${struct.buttons} inputs=${struct.inputs} dimMatrix=${struct.hasDimMatrix} labels=${JSON.stringify(struct.labels)}`);
}
writeFileSync('gate_structure2.json', JSON.stringify(report, null, 2));
await browser.close();
console.log('DONE');
