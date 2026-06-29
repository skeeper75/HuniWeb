const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = path.dirname(__filename);

async function discovery() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  });
  const page = await context.newPage();

  const apiCalls = [];
  page.on('request', req => {
    if (req.resourceType() === 'fetch' || req.resourceType() === 'xhr') {
      apiCalls.push({ url: req.url(), method: req.method(), postData: req.postData() });
    }
  });
  page.on('response', async resp => {
    const entry = apiCalls.find(c => c.url === resp.url() && !c.status);
    if (entry) {
      try { entry.responseBody = await resp.json(); } catch { entry.responseBody = null; }
      entry.status = resp.status();
    }
  });

  console.log('[DISCOVERY] Navigating to https://print.wowpress.co.kr ...');
  let homepageError = null;
  try {
    await page.goto('https://print.wowpress.co.kr', { waitUntil: 'load', timeout: 30000 });
    await page.waitForTimeout(6000);
  } catch (e) {
    homepageError = e.message;
    console.log('[DISCOVERY] Homepage error:', e.message);
  }

  // Screenshot homepage
  try {
    await page.screenshot({ path: path.join(OUT_DIR, 'wow_homepage.png'), fullPage: false });
  } catch {}

  // Extract homepage info
  let homeInfo = {};
  try {
    homeInfo = await page.evaluate(() => {
      return {
        title: document.title,
        url: location.href,
        framework: window.Vue ? 'vue' : window.__NEXT_DATA__ ? 'next' : window.React ? 'react' : window.__NUXT__ ? 'nuxt' : 'unknown',
        allLinks: Array.from(document.querySelectorAll('a[href]')).map(a => ({
          href: a.href,
          text: a.textContent.trim().slice(0, 80)
        })).filter(l => l.href.includes('print.wowpress.co.kr') || l.href.startsWith('/')),
        navItems: Array.from(document.querySelectorAll('nav a, .nav a, .menu a, .gnb a, .lnb a, header a')).map(a => ({
          href: a.href,
          text: a.textContent.trim().slice(0, 80)
        })),
        bodyText: document.body ? document.body.innerText.slice(0, 3000) : '',
        metaDescription: document.querySelector('meta[name="description"]')?.content || '',
        selectCount: document.querySelectorAll('select').length,
        formCount: document.querySelectorAll('form').length,
        hasEditor: !!document.querySelector('[class*="editor"], [id*="editor"], iframe[src*="editor"]')
      };
    });
  } catch (e) {
    homeInfo.error = e.message;
  }

  // Try to find product categories by exploring common URL patterns
  const categoryUrls = [
    '/product', '/products', '/shop', '/category',
    '/namecard', '/businesscard', '/leaflet', '/flyer',
    '/sticker', '/goods', '/booklet', '/brochure',
    '/poster', '/banner', '/envelope', '/printing'
  ];

  const foundPages = [];
  for (const catUrl of categoryUrls) {
    try {
      const fullUrl = `https://print.wowpress.co.kr${catUrl}`;
      const resp = await page.goto(fullUrl, { waitUntil: 'load', timeout: 15000 });
      if (resp && resp.status() < 400) {
        await page.waitForTimeout(2000);
        const info = await page.evaluate(() => ({
          title: document.title,
          url: location.href,
          links: Array.from(document.querySelectorAll('a[href]')).map(a => ({
            href: a.href,
            text: a.textContent.trim().slice(0, 80)
          })).filter(l => l.text.length > 0).slice(0, 50),
          bodySnippet: document.body ? document.body.innerText.slice(0, 1000) : ''
        }));
        foundPages.push({ attempted: catUrl, status: resp.status(), ...info });
        console.log(`[DISCOVERY] Found: ${catUrl} -> ${info.title} (status ${resp.status()})`);
      }
    } catch {}
  }

  // Also extract all product-like links from homepage
  const productLinks = (homeInfo.allLinks || []).filter(l =>
    /product|shop|category|item|goods|print|명함|전단|스티커|리플렛|브로슈어|포스터|봉투|책자/.test(l.href + l.text)
  );

  const result = {
    capturedAt: new Date().toISOString(),
    homepageError,
    homeInfo,
    apiCalls,
    foundPages,
    productLinks,
    totalLinksOnHomepage: (homeInfo.allLinks || []).length
  };

  fs.writeFileSync(path.join(OUT_DIR, 'wow_discovery.json'), JSON.stringify(result, null, 2));
  console.log('[DISCOVERY] Done. Found', foundPages.length, 'category pages,', productLinks.length, 'product links');
  console.log('[DISCOVERY] API calls captured:', apiCalls.length);

  await browser.close();
}

discovery().catch(e => {
  console.error('[DISCOVERY] Fatal:', e.message);
  fs.writeFileSync(path.join(OUT_DIR, 'wow_discovery.json'), JSON.stringify({ error: e.message, capturedAt: new Date().toISOString() }, null, 2));
  process.exit(1);
});
