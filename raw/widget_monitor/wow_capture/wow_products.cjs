const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = path.dirname(__filename);

async function findProducts() {
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
      try {
        const ct = resp.headers()['content-type'] || '';
        if (ct.includes('json') || ct.includes('javascript')) {
          entry.responseBody = await resp.json();
        } else {
          entry.responseBody = null;
          entry.contentType = ct;
        }
      } catch { entry.responseBody = null; }
      entry.status = resp.status();
    }
  });

  // Load homepage to get product catalog
  console.log('[PRODUCTS] Loading homepage...');
  await page.goto('https://wowpress.co.kr', { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(6000);

  // Find the main product catalog API response
  const prodApi = apiCalls.find(c => c.url.includes('/main/all/prod'));
  if (prodApi && prodApi.responseBody) {
    console.log('[PRODUCTS] Found /main/all/prod response');
    fs.writeFileSync(path.join(OUT_DIR, 'wow_product_catalog_api.json'), JSON.stringify(prodApi.responseBody, null, 2));
  }

  // Extract category menu structure via clicking/hovering
  const menuStructure = await page.evaluate(() => {
    // Try to find category/menu items
    const menuItems = [];
    // Look for category navigation elements
    const catElements = document.querySelectorAll('.category-menu a, .gnb a, .lnb a, .sub-menu a, .depth a, nav a, .nav-item a, [class*="cate"] a, [class*="menu"] a, [class*="depth"] a');
    catElements.forEach(el => {
      menuItems.push({
        href: el.href,
        text: el.textContent.trim().slice(0, 80),
        className: el.className,
        parentClass: el.parentElement?.className || ''
      });
    });

    // Also look for product card links
    const productCards = document.querySelectorAll('[class*="product"] a, [class*="item"] a, [class*="prd"] a, [class*="goods"] a, .card a');
    productCards.forEach(el => {
      menuItems.push({
        href: el.href,
        text: el.textContent.trim().slice(0, 80),
        className: el.className,
        type: 'product-card'
      });
    });

    return menuItems;
  });

  console.log('[PRODUCTS] Menu items found:', menuStructure.length);

  // Now explore the category menu by looking for expandable menus
  // First check the categories shown on homepage
  const categories = await page.evaluate(() => {
    const cats = [];
    // Look for the main category tabs (상업인쇄소, 힙지로디지털, 책공방, etc.)
    const tabEls = document.querySelectorAll('[class*="tab"], [class*="category"], [role="tab"], .swiper-slide a, .menu-item a');
    tabEls.forEach(el => {
      cats.push({
        href: el.href || '',
        text: el.textContent.trim().slice(0, 80),
        id: el.id,
        dataAttr: Object.keys(el.dataset || {}).reduce((acc, k) => { acc[k] = el.dataset[k]; return acc; }, {})
      });
    });
    return cats;
  });

  console.log('[PRODUCTS] Categories found:', categories.length);
  categories.filter(c => c.text.length > 0).forEach(c => console.log(`  ${c.text} -> ${c.href}`));

  // Try to click on each main category tab to reveal sub-products
  const categoryTabs = ['상업인쇄소', '힙지로디지털', '책공방', '가게용품', '문구점', '어패럴'];
  const categoryProducts = {};

  for (const catName of categoryTabs) {
    try {
      // Click the category tab
      const clicked = await page.evaluate((name) => {
        const els = Array.from(document.querySelectorAll('a, button, [role="tab"], span, div'));
        const el = els.find(e => e.textContent.trim() === name);
        if (el) { el.click(); return true; }
        return false;
      }, catName);

      if (clicked) {
        await page.waitForTimeout(2000);
        // Capture products shown under this category
        const prods = await page.evaluate(() => {
          const items = [];
          // Look for product links/cards visible now
          document.querySelectorAll('a[href*="ordr"], a[href*="prod"], a[href*="item"], .product-item a, .prd-item a, [class*="prod"] a').forEach(el => {
            if (el.href && el.textContent.trim().length > 0) {
              items.push({
                href: el.href,
                text: el.textContent.trim().slice(0, 100),
                img: el.querySelector('img')?.src || ''
              });
            }
          });
          return items;
        });
        categoryProducts[catName] = prods;
        console.log(`[PRODUCTS] ${catName}: ${prods.length} products`);
        prods.slice(0, 5).forEach(p => console.log(`    ${p.text.slice(0, 40)} -> ${p.href}`));
      }
    } catch (e) {
      console.log(`[PRODUCTS] Error clicking ${catName}:`, e.message.split('\n')[0]);
    }
  }

  // Also try directly fetching product URLs we know about
  // From API: /ordr/prod/newest, /ordr/prod/sale/no/list
  console.log('\n[PRODUCTS] Checking /ordr/prod/newest page...');
  apiCalls.length = 0; // Reset to capture new calls
  await page.goto('https://wowpress.co.kr/ordr/prod/newest', { waitUntil: 'load', timeout: 15000 });
  await page.waitForTimeout(3000);

  const newestProducts = await page.evaluate(() => {
    const items = [];
    document.querySelectorAll('a[href]').forEach(el => {
      const href = el.href;
      if (href.includes('/ordr/') && !href.includes('/cart/') && el.textContent.trim().length > 0) {
        items.push({ href, text: el.textContent.trim().slice(0, 100) });
      }
    });
    return items;
  });
  console.log('[PRODUCTS] Newest products page links:', newestProducts.length);
  newestProducts.slice(0, 10).forEach(p => console.log(`  ${p.text.slice(0, 50)} -> ${p.href}`));

  await page.screenshot({ path: path.join(OUT_DIR, 'wow_newest_products.png'), fullPage: false });

  // Try common product page patterns
  const productPagePatterns = [
    '/ordr/prod/form?pdtCd=', // likely product form page
    '/ordr/item/',
    '/ordr/prod/view',
    '/ordr/prod/detail',
  ];

  // Check if any API response contains product codes
  const allApiWithProdCodes = apiCalls.filter(c =>
    c.responseBody && JSON.stringify(c.responseBody).includes('pdtCd')
  );
  console.log('\n[PRODUCTS] APIs with pdtCd:', allApiWithProdCodes.length);
  allApiWithProdCodes.forEach(a => console.log(`  ${a.method} ${a.url}`));

  // Look at the /main/all/prod response structure
  if (prodApi?.responseBody) {
    const body = prodApi.responseBody;
    console.log('\n[PRODUCTS] Catalog API structure:');
    console.log('  Type:', typeof body);
    if (Array.isArray(body)) {
      console.log('  Array length:', body.length);
      if (body[0]) console.log('  First item keys:', Object.keys(body[0]).join(', '));
      body.slice(0, 3).forEach(item => console.log('  Item:', JSON.stringify(item).slice(0, 200)));
    } else if (body && typeof body === 'object') {
      console.log('  Keys:', Object.keys(body).join(', '));
      const flatStr = JSON.stringify(body).slice(0, 500);
      console.log('  Preview:', flatStr);
    }
  }

  // Extract all links with ordr pattern from the full body
  const allPageLinks = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('a[href]'))
      .map(a => ({ href: a.href, text: a.textContent.trim().slice(0, 60) }))
      .filter(l => l.text.length > 0);
  });

  const result = {
    capturedAt: new Date().toISOString(),
    catalogApi: prodApi?.responseBody || null,
    menuStructure,
    categories,
    categoryProducts,
    newestProducts,
    allPageLinks,
    apiCalls: apiCalls.map(c => ({ url: c.url, method: c.method, status: c.status, postData: c.postData }))
  };

  fs.writeFileSync(path.join(OUT_DIR, 'wow_products.json'), JSON.stringify(result, null, 2));
  console.log('\n[PRODUCTS] Done.');
  await browser.close();
}

findProducts().catch(e => {
  console.error('[PRODUCTS] Fatal:', e.message);
  process.exit(1);
});
