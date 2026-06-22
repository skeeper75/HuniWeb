// Gate equivalence render — 4 target products, capture structure + screenshot.
import { chromium } from 'playwright';
import { writeFileSync } from 'fs';

const BASE = process.env.BASE || 'http://localhost:5173';
const products = ['PRBKYPR', 'AIPPCUT', 'STPADPN', 'GSPUFBC']; // GSBGRDY has no fixture; GSPUFBC=tmpl, GSTGMIC=tiered both available
const extra = ['GSTGMIC'];
const all = [...products, ...extra];

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 600, height: 1100 } });
const report = {};

for (const code of all) {
  await page.goto(`${BASE}/?p=${code}`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(900);
  // Pierce shadow root, extract structure.
  const struct = await page.evaluate(() => {
    const host = document.getElementById('host');
    const sr = host && host.shadowRoot;
    if (!sr) return { error: 'no shadowRoot' };
    const text = sr.textContent?.replace(/\s+/g, ' ').slice(0, 400);
    // group labels + control kinds heuristically
    const labels = [...sr.querySelectorAll('label, h2, [class*="label"]')]
      .map((e) => e.textContent?.trim())
      .filter((t) => t && t.length < 40)
      .slice(0, 30);
    const buttons = sr.querySelectorAll('button').length;
    const selects = sr.querySelectorAll('[role="combobox"], select, [class*="elect"]').length;
    const inputs = sr.querySelectorAll('input').length;
    const rootChildren = sr.querySelector('div')?.children?.length ?? 0;
    return { text, labels, buttons, selects, inputs, rootChildren };
  });
  report[code] = struct;
  await page.screenshot({ path: `/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/05_qa/captures/gate_${code}.png`, fullPage: true });
  console.log(`[${code}] buttons=${struct.buttons} inputs=${struct.inputs} labels=${JSON.stringify(struct.labels)}`);
}

writeFileSync('/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/05_qa/captures/gate_structure.json', JSON.stringify(report, null, 2));
await browser.close();
console.log('DONE');
