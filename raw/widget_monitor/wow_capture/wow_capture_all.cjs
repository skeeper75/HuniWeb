const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = path.dirname(__filename);

async function captureAll() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    viewport: { width: 1440, height: 900 }
  });

  // ===== PHASE 1: Discover product URLs from homepage =====
  console.log('===== PHASE 1: HOMEPAGE DISCOVERY =====');
  const page = await context.newPage();

  const allApiCalls = [];
  function attachApiInterceptor(pg, label) {
    pg.on('request', req => {
      if (req.resourceType() === 'fetch' || req.resourceType() === 'xhr') {
        const url = req.url();
        // Skip analytics/tracking
        if (url.includes('google') || url.includes('facebook') || url.includes('daum') || url.includes('naver') || url.includes('sentry') || url.includes('mediacategory') || url.includes('megadata') || url.includes('youtube') || url.includes('firebase') || url.includes('identitytoolkit')) return;
        allApiCalls.push({
          label,
          url,
          method: req.method(),
          postData: req.postData(),
          timestamp: Date.now()
        });
      }
    });
    pg.on('response', async resp => {
      const entry = allApiCalls.find(c => c.url === resp.url() && !c.status);
      if (entry) {
        entry.status = resp.status();
        try {
          const ct = resp.headers()['content-type'] || '';
          if (ct.includes('json')) {
            entry.responseBody = await resp.json();
          } else {
            const text = await resp.text();
            entry.responseBody = text.slice(0, 2000);
            entry.contentType = ct;
          }
        } catch { entry.responseBody = null; }
      }
    });
  }

  attachApiInterceptor(page, 'homepage');

  await page.goto('https://wowpress.co.kr', { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(6000);
  await page.screenshot({ path: path.join(OUT_DIR, 'wow_home.png'), fullPage: false });

  // Extract the product catalog from /main/all/prod response
  const catalogEntry = allApiCalls.find(c => c.url.includes('/main/all/prod'));
  let catalogData = catalogEntry?.responseBody || null;
  console.log('Catalog API found:', !!catalogData);

  // Extract product links from the rendered page - look for onclick handlers and data attributes
  const pageProductInfo = await page.evaluate(() => {
    const results = {
      // Find all elements with onclick containing product-related URLs
      onclickElements: [],
      // Find all data attributes with product codes
      dataElements: [],
      // Find all product-card-like elements
      productCards: [],
      // Raw HTML fragments containing product references
      htmlFragments: [],
      // All script content mentioning products
      scriptData: []
    };

    // Search for onclick handlers
    document.querySelectorAll('[onclick]').forEach(el => {
      const onclick = el.getAttribute('onclick');
      if (onclick.includes('ordr') || onclick.includes('prod') || onclick.includes('pdt') || onclick.includes('item')) {
        results.onclickElements.push({
          tag: el.tagName,
          onclick,
          text: el.textContent.trim().slice(0, 80),
          href: el.href || ''
        });
      }
    });

    // Find data attributes
    document.querySelectorAll('[data-pdt-cd], [data-product-code], [data-pdtcd], [data-code], [data-item]').forEach(el => {
      results.dataElements.push({
        tag: el.tagName,
        data: { ...el.dataset },
        text: el.textContent.trim().slice(0, 80)
      });
    });

    // Find product card elements (common patterns)
    document.querySelectorAll('.product, .prd, .item, .goods, [class*="product"], [class*="prd-"], [class*="item-"]').forEach(el => {
      const links = el.querySelectorAll('a[href]');
      const imgs = el.querySelectorAll('img');
      results.productCards.push({
        className: el.className,
        links: Array.from(links).map(a => a.href),
        imgs: Array.from(imgs).map(i => i.src).slice(0, 2),
        text: el.textContent.trim().slice(0, 200),
        onclick: el.getAttribute('onclick') || ''
      });
    });

    // Search for product URLs in inline scripts
    document.querySelectorAll('script:not([src])').forEach(s => {
      const content = s.textContent;
      if (content.includes('pdtCd') || content.includes('productCode') || content.includes('ordr/prod') || content.includes('prodList') || content.includes('pdt_cd')) {
        results.scriptData.push(content.slice(0, 2000));
      }
    });

    // Find any links that look like product detail pages
    document.querySelectorAll('a[href*="form"], a[href*="detail"], a[href*="view"]').forEach(a => {
      if (a.href.includes('wowpress.co.kr')) {
        results.htmlFragments.push({ href: a.href, text: a.textContent.trim().slice(0, 80) });
      }
    });

    return results;
  });

  console.log('onclick elements:', pageProductInfo.onclickElements.length);
  console.log('data elements:', pageProductInfo.dataElements.length);
  console.log('product cards:', pageProductInfo.productCards.length);
  console.log('script data fragments:', pageProductInfo.scriptData.length);

  // Log some samples
  pageProductInfo.onclickElements.slice(0, 5).forEach(e => console.log('  onclick:', e.onclick.slice(0, 100)));
  pageProductInfo.productCards.slice(0, 5).forEach(c => console.log('  card:', c.className, c.text.slice(0, 50), c.onclick?.slice(0, 100)));

  // ===== PHASE 2: Try to navigate to specific product categories =====
  console.log('\n===== PHASE 2: CATEGORY EXPLORATION =====');

  // Click on category items to find product listing pages
  // From the home page we see categories: 스티커, 명함, 책자, 전단, 홍보물, etc.
  const categoryNames = ['명함', '스티커', '책자', '전단', '굿즈/다꾸', '봉투', '포스터'];
  const discoveredProductUrls = [];

  for (const catName of categoryNames) {
    try {
      // Navigate back to homepage
      await page.goto('https://wowpress.co.kr', { waitUntil: 'load', timeout: 20000 });
      await page.waitForTimeout(3000);

      // Try to find and click on the category
      const found = await page.evaluate((name) => {
        // Look for category links/buttons with exact or containing text
        const els = Array.from(document.querySelectorAll('a, button, span, div, li'));
        for (const el of els) {
          const text = el.textContent.trim();
          if (text === name || text.startsWith(name)) {
            // Check if this element or its parent has an onclick or href
            if (el.tagName === 'A' && el.href && !el.href.endsWith('#')) {
              return { type: 'link', href: el.href };
            }
            if (el.getAttribute('onclick')) {
              el.click();
              return { type: 'clicked', onclick: el.getAttribute('onclick') };
            }
            // Try clicking anyway
            el.click();
            return { type: 'clicked-element', tag: el.tagName, class: el.className };
          }
        }
        return null;
      }, catName);

      if (found) {
        console.log(`Category ${catName}:`, JSON.stringify(found).slice(0, 150));
        await page.waitForTimeout(3000);

        // Check if page changed
        const currentUrl = page.url();
        const pageTitle = await page.title();

        // Look for product links on this page
        const products = await page.evaluate(() => {
          const items = [];
          // Look for any link or clickable that leads to a product form
          document.querySelectorAll('a[href], [onclick]').forEach(el => {
            const href = el.href || '';
            const onclick = el.getAttribute('onclick') || '';
            const text = el.textContent.trim().slice(0, 100);
            if ((href.includes('/ordr/') || href.includes('/prod/') || onclick.includes('/ordr/') || onclick.includes('pdtCd') || onclick.includes('goDetail') || onclick.includes('goOrder'))
                && text.length > 0 && text.length < 100) {
              items.push({ href, onclick: onclick.slice(0, 200), text });
            }
          });
          return items;
        });

        console.log(`  -> URL: ${currentUrl}, Products found: ${products.length}`);
        products.slice(0, 3).forEach(p => console.log(`     ${p.text} | ${p.href || p.onclick?.slice(0, 80)}`));
        discoveredProductUrls.push(...products);

        await page.screenshot({ path: path.join(OUT_DIR, `wow_cat_${catName}.png`), fullPage: false });
      }
    } catch (e) {
      console.log(`Category ${catName}: Error -`, e.message.split('\n')[0]);
    }
  }

  // ===== PHASE 3: Try direct product page URL patterns =====
  console.log('\n===== PHASE 3: DIRECT URL EXPLORATION =====');

  // Try common WowPress URL patterns for product ordering
  const directUrls = [
    // Common printing site product page patterns
    'https://wowpress.co.kr/ordr/prod/form?pdtCd=namecard',
    'https://wowpress.co.kr/ordr/prod/form?pdtCd=sticker',
    'https://wowpress.co.kr/ordr/prod/form?pdtCd=booklet',
    'https://wowpress.co.kr/ordr/prod/form',
    'https://wowpress.co.kr/ordr/prod/list',
    'https://wowpress.co.kr/ordr/prod/main',
    'https://wowpress.co.kr/ordr/main',
    'https://wowpress.co.kr/order',
    'https://wowpress.co.kr/shop',
    // Variations
    'https://wowpress.co.kr/ordr/prod/list?ctgrCd=namecard',
    'https://wowpress.co.kr/ordr/prod/list?ctgrCd=sticker',
    'https://wowpress.co.kr/ordr/prod/list?ctgrCd=booklet',
    // Try numeric category codes
    'https://wowpress.co.kr/ordr/prod/list?ctgrCd=1',
    'https://wowpress.co.kr/ordr/prod/list?ctgrCd=2',
    'https://wowpress.co.kr/ordr/prod/list?ctgrCd=3',
  ];

  const reachablePages = [];
  for (const url of directUrls) {
    try {
      const resp = await page.goto(url, { waitUntil: 'load', timeout: 10000 });
      const st = resp ? resp.status() : 'no-resp';
      const finalUrl = page.url();
      const title = await page.title();
      if (st < 400 && !finalUrl.includes('lgin')) {
        await page.waitForTimeout(2000);
        const bodySnippet = await page.evaluate(() => document.body?.innerText?.slice(0, 500) || '');
        const selectCount = await page.evaluate(() => document.querySelectorAll('select').length);
        const formCount = await page.evaluate(() => document.querySelectorAll('form').length);
        reachablePages.push({ url, finalUrl, title, status: st, bodySnippet, selectCount, formCount });
        console.log(`OK: ${url} -> ${st} "${title}" (selects: ${selectCount})`);
        if (selectCount > 0) {
          await page.screenshot({ path: path.join(OUT_DIR, `wow_direct_${url.split('?')[0].split('/').pop()}.png`), fullPage: false });
        }
      }
    } catch {}
  }

  // ===== PHASE 4: Extract product data from /main/all/prod =====
  console.log('\n===== PHASE 4: PRODUCT CATALOG ANALYSIS =====');

  // Fetch the product catalog API directly
  let catalogProducts = [];
  try {
    await page.goto('https://wowpress.co.kr', { waitUntil: 'load', timeout: 20000 });
    await page.waitForTimeout(4000);

    // Try to call the API directly
    catalogProducts = await page.evaluate(async () => {
      try {
        const resp = await fetch('/main/all/prod', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' }
        });
        return await resp.json();
      } catch {
        try {
          const resp = await fetch('/main/all/prod');
          return await resp.json();
        } catch {
          return null;
        }
      }
    });

    if (catalogProducts) {
      console.log('Catalog API direct call: success');
      console.log('Type:', typeof catalogProducts, Array.isArray(catalogProducts) ? `array(${catalogProducts.length})` : '');
      if (typeof catalogProducts === 'object' && !Array.isArray(catalogProducts)) {
        console.log('Keys:', Object.keys(catalogProducts).join(', '));
        for (const [k, v] of Object.entries(catalogProducts)) {
          if (Array.isArray(v)) {
            console.log(`  ${k}: ${v.length} items`);
            if (v[0]) console.log(`    First keys: ${Object.keys(v[0]).join(', ')}`);
            v.slice(0, 2).forEach(item => console.log(`    `, JSON.stringify(item).slice(0, 250)));
          }
        }
      } else if (Array.isArray(catalogProducts)) {
        if (catalogProducts[0]) console.log('First keys:', Object.keys(catalogProducts[0]).join(', '));
        catalogProducts.slice(0, 3).forEach(item => console.log('  ', JSON.stringify(item).slice(0, 250)));
      }
      fs.writeFileSync(path.join(OUT_DIR, 'wow_catalog_raw.json'), JSON.stringify(catalogProducts, null, 2));
    } else {
      console.log('Catalog API direct call: failed');
    }
  } catch (e) {
    console.log('Catalog fetch error:', e.message.split('\n')[0]);
  }

  // Also try other product-related APIs
  const otherApis = [
    { url: '/ordr/prod/sale/no/list', method: 'GET' },
    { url: '/self/dsgn/gettotpdcnt', method: 'GET' },
    { url: '/self/dsgn/template/group/325', method: 'GET' },
    { url: '/main/favorite', method: 'GET' },
    { url: '/myInfo', method: 'GET' },
  ];

  for (const api of otherApis) {
    try {
      const result = await page.evaluate(async (a) => {
        const resp = await fetch(a.url, { method: a.method });
        const ct = resp.headers.get('content-type') || '';
        if (ct.includes('json')) return await resp.json();
        const text = await resp.text();
        return text.slice(0, 500);
      }, api);
      console.log(`API ${api.url}:`, JSON.stringify(result).slice(0, 300));
    } catch {}
  }

  // ===== PHASE 5: Try to find product form pages via sitemap or robots.txt =====
  console.log('\n===== PHASE 5: SITEMAP/ROBOTS =====');
  for (const path2 of ['/sitemap.xml', '/robots.txt', '/sitemap_index.xml']) {
    try {
      const resp = await page.goto(`https://wowpress.co.kr${path2}`, { waitUntil: 'load', timeout: 10000 });
      if (resp && resp.status() < 400) {
        const text = await page.evaluate(() => document.body?.innerText?.slice(0, 3000) || '');
        console.log(`${path2}: ${resp.status()}`);
        console.log(text.slice(0, 500));

        // Extract URLs from sitemap
        const urls = text.match(/https?:\/\/wowpress\.co\.kr[^\s<>"]+/g) || [];
        const productUrls = urls.filter(u => u.includes('/ordr/') || u.includes('/prod/'));
        console.log(`  Product URLs found: ${productUrls.length}`);
        productUrls.slice(0, 10).forEach(u => console.log(`    ${u}`));
      }
    } catch {}
  }

  // ===== FINAL: Save comprehensive results =====
  const result = {
    capturedAt: new Date().toISOString(),
    platform: 'wowpress',
    siteUrl: 'https://wowpress.co.kr',
    framework: 'jquery',
    catalogData: catalogProducts,
    pageProductInfo,
    discoveredProductUrls,
    reachablePages,
    wowpressApiCalls: allApiCalls.filter(c => c.url.includes('wowpress.co.kr')),
    allApiCallCount: allApiCalls.length
  };

  fs.writeFileSync(path.join(OUT_DIR, 'wow_full_discovery.json'), JSON.stringify(result, null, 2));
  console.log('\n===== DONE =====');
  console.log('Total WowPress API calls:', result.wowpressApiCalls.length);
  console.log('Discovered product URLs:', discoveredProductUrls.length);
  console.log('Reachable pages:', reachablePages.length);

  await browser.close();
}

captureAll().catch(e => {
  console.error('Fatal:', e.message);
  process.exit(1);
});
