const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = path.dirname(__filename);

const candidates = [
  'https://print.wowpress.co.kr',
  'https://www.wowpress.co.kr',
  'https://wowpress.co.kr',
  'https://print.wowpress.kr',
  'https://wowpress.kr',
  'https://www.wowpress.kr',
  'https://wowpress.com',
  'https://www.wowpress.com',
  'https://print.wowpress.com',
  // Maybe it's a Cafe24/Shopby mall
  'https://wowpress.cafe24.com',
  'https://wowpress.co.kr/product',
  'https://wowpress.co.kr/shop',
];

async function probe() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  });
  const page = await context.newPage();
  const results = [];

  for (const url of candidates) {
    console.log(`[PROBE] Trying ${url} ...`);
    try {
      const resp = await page.goto(url, { waitUntil: 'load', timeout: 10000 });
      const finalUrl = page.url();
      const title = await page.title();
      const status = resp ? resp.status() : 'no-response';
      results.push({ url, finalUrl, title, status, reachable: true });
      console.log(`  -> OK: ${status} "${title}" (${finalUrl})`);

      // If we found a working site, take screenshot
      if (status < 400) {
        const safeName = url.replace(/[^a-zA-Z0-9]/g, '_');
        await page.screenshot({ path: path.join(OUT_DIR, `probe_${safeName}.png`), fullPage: false });
      }
    } catch (e) {
      results.push({ url, error: e.message.split('\n')[0], reachable: false });
      console.log(`  -> FAIL: ${e.message.split('\n')[0]}`);
    }
  }

  // Also try a Google search for "wowpress printing" to find the real URL
  console.log('\n[PROBE] Searching Google for "와우프레스 인쇄" ...');
  try {
    await page.goto('https://www.google.com/search?q=%EC%99%80%EC%9A%B0%ED%94%84%EB%A0%88%EC%8A%A4+%EC%9D%B8%EC%87%84+wowpress', { waitUntil: 'load', timeout: 15000 });
    await page.waitForTimeout(3000);
    const searchResults = await page.evaluate(() => {
      return Array.from(document.querySelectorAll('a[href]')).map(a => ({
        href: a.href,
        text: a.textContent.trim().slice(0, 100)
      })).filter(l => l.href.includes('wowpress') || l.text.toLowerCase().includes('wowpress') || l.text.includes('와우프레스'));
    });
    results.push({ type: 'google_search', results: searchResults });
    console.log(`  -> Found ${searchResults.length} relevant links`);
    searchResults.slice(0, 5).forEach(r => console.log(`    ${r.href} - ${r.text}`));
    await page.screenshot({ path: path.join(OUT_DIR, 'probe_google_search.png'), fullPage: false });
  } catch (e) {
    console.log(`  -> Google search failed: ${e.message.split('\n')[0]}`);
  }

  fs.writeFileSync(path.join(OUT_DIR, 'wow_dns_probe.json'), JSON.stringify(results, null, 2));
  console.log('\n[PROBE] Complete. Results saved.');
  await browser.close();
}

probe().catch(e => {
  console.error('[PROBE] Fatal:', e.message);
  process.exit(1);
});
