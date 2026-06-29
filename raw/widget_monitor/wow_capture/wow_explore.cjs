const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = path.dirname(__filename);

async function explore() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  });
  const page = await context.newPage();

  const apiCalls = [];
  page.on('request', req => {
    if (req.resourceType() === 'fetch' || req.resourceType() === 'xhr') {
      apiCalls.push({ url: req.url(), method: req.method(), postData: req.postData(), type: req.resourceType() });
    }
  });
  page.on('response', async resp => {
    const entry = apiCalls.find(c => c.url === resp.url() && !c.status);
    if (entry) {
      try { entry.responseBody = await resp.json(); } catch { entry.responseBody = null; }
      entry.status = resp.status();
    }
  });

  // Phase 1: Explore homepage
  console.log('[EXPLORE] Loading wowpress.co.kr ...');
  try {
    await page.goto('https://wowpress.co.kr', { waitUntil: 'load', timeout: 30000 });
    await page.waitForTimeout(6000);
  } catch (e) {
    console.log('[EXPLORE] Homepage load issue:', e.message.split('\n')[0]);
    // Still continue - page may have partially loaded
  }

  await page.screenshot({ path: path.join(OUT_DIR, 'wow_home.png'), fullPage: false });

  const homeInfo = await page.evaluate(() => {
    return {
      title: document.title,
      url: location.href,
      framework: window.Vue ? 'vue' : window.__NEXT_DATA__ ? 'next' : (window.React || window.__REACT_DEVTOOLS_GLOBAL_HOOK__) ? 'react' : window.__NUXT__ ? 'nuxt' : window.angular ? 'angular' : window.jQuery ? 'jquery' : 'unknown',
      allLinks: Array.from(new Set(Array.from(document.querySelectorAll('a[href]')).map(a => a.href)))
        .filter(h => h.startsWith('http'))
        .slice(0, 200),
      navLinks: Array.from(document.querySelectorAll('nav a, .nav a, .menu a, .gnb a, .lnb a, header a, .header a, #header a, .top-menu a, .main-menu a, .category a')).map(a => ({
        href: a.href,
        text: a.textContent.trim().slice(0, 80)
      })).filter(l => l.text.length > 0),
      bodyText: document.body ? document.body.innerText.slice(0, 5000) : '',
      metaDesc: document.querySelector('meta[name="description"]')?.content || '',
      metaKeywords: document.querySelector('meta[name="keywords"]')?.content || '',
      scripts: Array.from(document.querySelectorAll('script[src]')).map(s => s.src).slice(0, 30),
      hasShopby: !!document.querySelector('[class*="shopby"], [id*="shopby"]') || document.body?.innerHTML?.includes('shopby'),
      hasCafe24: document.body?.innerHTML?.includes('cafe24') || false,
      selectCount: document.querySelectorAll('select').length,
      formCount: document.querySelectorAll('form').length,
      iframeCount: document.querySelectorAll('iframe').length,
    };
  });

  console.log('[EXPLORE] Home title:', homeInfo.title);
  console.log('[EXPLORE] Framework:', homeInfo.framework);
  console.log('[EXPLORE] Total links:', homeInfo.allLinks.length);
  console.log('[EXPLORE] Nav links:', homeInfo.navLinks.length);

  // Find product-related links
  const productPatterns = /product|item|goods|detail|order|print|명함|전단|스티커|리플렛|브로슈어|포스터|봉투|책자|카탈로그|봉투|현수막|배너|인쇄/i;
  const productLinks = homeInfo.allLinks.filter(l => productPatterns.test(l));

  console.log('[EXPLORE] Product-like links:', productLinks.length);
  productLinks.slice(0, 20).forEach(l => console.log('  ', l));

  // Phase 2: Try common Cafe24/Shopby product patterns
  const tryPaths = [
    '/', '/index.html',
    '/product/list.html', '/product/search.html',
    '/category/list.html',
    '/board/list.html',
    '/order/list.html',
    '/member/login.html',
    '/main/index',
    // Common Korean printing site paths
    '/bbs/board.php',
    '/sub/namecard.php',
    '/namecard', '/leaflet', '/sticker', '/booklet',
  ];

  const pageResults = [];
  for (const p of tryPaths) {
    try {
      const url = `https://wowpress.co.kr${p}`;
      const resp = await page.goto(url, { waitUntil: 'load', timeout: 10000 });
      const st = resp ? resp.status() : 'no-resp';
      const title = await page.title();
      const finalUrl = page.url();
      if (st < 400) {
        const snippet = await page.evaluate(() => document.body?.innerText?.slice(0, 500) || '');
        pageResults.push({ path: p, status: st, title, finalUrl, snippet });
        console.log(`[EXPLORE] ${p} -> ${st} "${title}"`);
      }
    } catch {}
  }

  // Phase 3: Explore links found on homepage that look product-related
  const linksToVisit = [...new Set([...productLinks, ...homeInfo.navLinks.map(n => n.href)])].slice(0, 15);
  const visitedPages = [];

  for (const link of linksToVisit) {
    if (!link.includes('wowpress.co.kr')) continue;
    try {
      const resp = await page.goto(link, { waitUntil: 'load', timeout: 10000 });
      await page.waitForTimeout(2000);
      const st = resp ? resp.status() : 'no-resp';
      if (st >= 400) continue;
      const info = await page.evaluate(() => ({
        title: document.title,
        url: location.href,
        bodySnippet: document.body?.innerText?.slice(0, 1000) || '',
        links: Array.from(document.querySelectorAll('a[href]')).map(a => ({ href: a.href, text: a.textContent.trim().slice(0, 60) }))
          .filter(l => l.text.length > 0).slice(0, 30),
        selectCount: document.querySelectorAll('select').length,
        formCount: document.querySelectorAll('form').length,
        hasOptionWidget: !!document.querySelector('select, [class*="option"], [class*="widget"], [class*="calculator"], [class*="price"]'),
      }));
      visitedPages.push({ url: link, status: st, ...info });
      console.log(`[EXPLORE] Visited: ${link} -> "${info.title}" (selects: ${info.selectCount}, forms: ${info.formCount})`);

      // Screenshot if it looks like a product page
      if (info.selectCount > 0 || info.formCount > 0 || info.hasOptionWidget) {
        const safeName = link.replace(/[^a-zA-Z0-9]/g, '_').slice(0, 60);
        await page.screenshot({ path: path.join(OUT_DIR, `wow_page_${safeName}.png`), fullPage: false });
      }
    } catch {}
  }

  const result = {
    capturedAt: new Date().toISOString(),
    homeInfo,
    apiCalls,
    productLinks,
    pageResults,
    visitedPages,
  };

  fs.writeFileSync(path.join(OUT_DIR, 'wow_explore.json'), JSON.stringify(result, null, 2));
  console.log('\n[EXPLORE] Complete. API calls:', apiCalls.length);
  await browser.close();
}

explore().catch(e => {
  console.error('[EXPLORE] Fatal:', e.message);
  process.exit(1);
});
