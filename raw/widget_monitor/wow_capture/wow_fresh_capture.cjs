/**
 * WowPress Fresh Comprehensive Capture
 * Captures 5 products with option cascade interaction + API interception
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT = __dirname;
const PRODUCTS = [
  { prodNo: '40073', name: 'namecard', label: '일반명함' },
  { prodNo: '40026', name: 'flyer', label: '합판전단' },
  { prodNo: '40002', name: 'sticker', label: '스티커' },
  { prodNo: '40004', name: 'booklet', label: '책자' },
  { prodNo: '40520', name: 'goods', label: '굿즈' },
];

async function captureProduct(browser, prod) {
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
    viewport: { width: 1440, height: 900 },
  });
  const page = await context.newPage();

  const apiCalls = [];
  const errors = [];

  // Intercept all XHR/fetch
  page.on('request', req => {
    const rt = req.resourceType();
    if (rt === 'fetch' || rt === 'xhr') {
      apiCalls.push({
        url: req.url(),
        method: req.method(),
        postData: req.postData(),
        timestamp: Date.now(),
        headers: Object.fromEntries(
          Object.entries(req.headers()).filter(([k]) => ['content-type', 'x-requested-with', 'accept'].includes(k))
        ),
      });
    }
  });

  page.on('response', async resp => {
    const entry = apiCalls.find(c => c.url === resp.url() && !c.responseBody);
    if (entry) {
      entry.status = resp.status();
      entry.responseHeaders = Object.fromEntries(
        Object.entries(resp.headers()).filter(([k]) => ['content-type', 'set-cookie'].includes(k))
      );
      try {
        const ct = resp.headers()['content-type'] || '';
        if (ct.includes('json') || ct.includes('javascript')) {
          entry.responseBody = await resp.json();
        } else if (ct.includes('html')) {
          const text = await resp.text();
          entry.responseBody = text.substring(0, 500) + (text.length > 500 ? '...[truncated]' : '');
          entry.responseType = 'html';
        }
      } catch (e) {
        entry.responseError = e.message;
      }
    }
  });

  page.on('pageerror', err => errors.push(err.message));

  const url = `https://wowpress.co.kr/ordr/prod/dets?ProdNo=${prod.prodNo}`;
  console.log(`[${prod.name}] Navigating to ${url}`);

  try {
    await page.goto(url, { waitUntil: 'load', timeout: 30000 });
    await page.waitForTimeout(5000);
  } catch (e) {
    console.log(`[${prod.name}] Navigation error: ${e.message}`);
    await context.close();
    return { ...prod, url, error: e.message, apiCalls: [], pageInfo: null };
  }

  // Screenshot initial state
  await page.screenshot({ path: path.join(OUT, `fresh_${prod.name}_1_initial.png`), fullPage: false });

  // Extract page structure
  const pageInfo = await page.evaluate(() => {
    const selects = Array.from(document.querySelectorAll('select')).map(s => ({
      name: s.name,
      id: s.id,
      optionCount: s.options.length,
      selectedValue: s.value,
      selectedText: s.options[s.selectedIndex]?.text || '',
      allOptions: Array.from(s.options).map(o => ({ value: o.value, text: o.text, disabled: o.disabled })),
    }));

    const buttons = Array.from(document.querySelectorAll('button, a.btn, input[type="button"], input[type="submit"]'))
      .map(b => ({
        tag: b.tagName,
        text: (b.textContent || b.value || '').trim().substring(0, 50),
        id: b.id,
        className: (b.className || '').substring(0, 80),
        onclick: b.getAttribute('onclick')?.substring(0, 100) || null,
      }))
      .filter(b => b.text);

    const priceElements = [];
    document.querySelectorAll('[class*="price"], [id*="price"], [class*="cost"], [id*="cost"], [class*="금액"], [id*="amt"]').forEach(el => {
      priceElements.push({
        tag: el.tagName,
        id: el.id,
        className: (el.className || '').substring(0, 80),
        text: (el.textContent || '').trim().substring(0, 100),
      });
    });

    // Check for editor integration
    const editorLinks = [];
    document.querySelectorAll('a, button').forEach(el => {
      const text = (el.textContent || '').trim();
      const onclick = el.getAttribute('onclick') || '';
      if (text.includes('템플릿') || text.includes('디자인') || text.includes('편집') ||
          onclick.includes('dsgn') || onclick.includes('editor') || onclick.includes('template')) {
        editorLinks.push({
          tag: el.tagName,
          text: text.substring(0, 50),
          href: el.href || null,
          onclick: onclick.substring(0, 100),
        });
      }
    });

    // Quantity inputs
    const qtyInputs = Array.from(document.querySelectorAll('input[name*="qty"], input[name*="Qty"], input[id*="qty"], input[id*="Qty"], select[name*="qty"], select[name*="Qty"]'))
      .map(el => ({
        tag: el.tagName,
        name: el.name,
        id: el.id,
        type: el.type || el.tagName,
        value: el.value,
        options: el.tagName === 'SELECT' ? Array.from(el.options).map(o => ({ value: o.value, text: o.text })) : null,
      }));

    return {
      title: document.title,
      url: location.href,
      framework: window.Vue ? 'vue' : window.__NEXT_DATA__ ? 'next' : window.React ? 'react' : (window.jQuery ? 'jquery' : 'unknown'),
      selectCount: selects.length,
      formCount: document.querySelectorAll('form').length,
      hasEditor: editorLinks.length > 0,
      selects,
      buttons: buttons.slice(0, 30),
      priceElements,
      editorLinks,
      qtyInputs,
    };
  });

  console.log(`[${prod.name}] Page loaded: ${pageInfo.selectCount} selects, ${pageInfo.formCount} forms, editor=${pageInfo.hasEditor}`);

  // Try to interact with option selects to trigger cascade
  const optionSelects = pageInfo.selects.filter(s =>
    s.id && !s.id.startsWith('category') && s.optionCount > 1 && s.name
  );

  const cascadeLog = [];

  for (const sel of optionSelects.slice(0, 5)) {
    if (sel.allOptions.length < 2) continue;
    // Pick second option (first is often default/placeholder)
    const targetOption = sel.allOptions[1];
    if (!targetOption || !targetOption.value) continue;

    const apiCountBefore = apiCalls.length;
    try {
      await page.selectOption(`#${sel.id}`, targetOption.value);
      await page.waitForTimeout(2000);

      const newApis = apiCalls.slice(apiCountBefore);
      cascadeLog.push({
        select: { id: sel.id, name: sel.name },
        selectedOption: targetOption,
        triggeredApiCalls: newApis.length,
        apiUrls: newApis.map(a => a.url),
      });

      if (newApis.length > 0) {
        console.log(`[${prod.name}] Select #${sel.id} → ${newApis.length} API calls triggered`);
      }
    } catch (e) {
      cascadeLog.push({
        select: { id: sel.id, name: sel.name },
        error: e.message,
      });
    }
  }

  // Screenshot after option changes
  await page.screenshot({ path: path.join(OUT, `fresh_${prod.name}_2_options.png`), fullPage: false });

  // Try clicking price/order button to see price calculation
  const priceApisBefore = apiCalls.length;
  try {
    // Look for price calculation or order buttons
    const priceBtn = await page.$('button:has-text("견적"), a:has-text("견적"), button:has-text("가격"), input[value*="견적"]');
    if (priceBtn) {
      await priceBtn.click();
      await page.waitForTimeout(3000);
      console.log(`[${prod.name}] Clicked price button, ${apiCalls.length - priceApisBefore} new APIs`);
    }

    // Also try order/cart button
    const orderBtn = await page.$('button:has-text("장바구니"), a:has-text("장바구니"), button:has-text("주문"), a:has-text("주문하기")');
    if (orderBtn) {
      // Don't actually click order, just note it exists
      const orderText = await orderBtn.textContent();
      console.log(`[${prod.name}] Order button found: "${orderText.trim()}"`);
    }
  } catch (e) {
    console.log(`[${prod.name}] Button interaction error: ${e.message}`);
  }

  // Final screenshot
  await page.screenshot({ path: path.join(OUT, `fresh_${prod.name}_3_final.png`), fullPage: false });

  // Extract final price display
  const priceDisplay = await page.evaluate(() => {
    const priceTexts = [];
    // Common price display patterns
    const selectors = [
      '#totalPrice', '#total_price', '.total-price', '.totalPrice',
      '[id*="totalAmt"]', '[id*="total_amt"]', '[class*="total"]',
      'td:has-text("합계")', 'span:has-text("원")',
    ];
    for (const sel of selectors) {
      try {
        document.querySelectorAll(sel).forEach(el => {
          const t = (el.textContent || '').trim();
          if (t && t.length < 100) priceTexts.push({ selector: sel, text: t });
        });
      } catch {}
    }
    // Also check visible price near order area
    const orderArea = document.querySelector('.order_area, .order-area, #orderForm, .prd_price');
    if (orderArea) {
      priceTexts.push({ selector: 'orderArea', text: orderArea.textContent.trim().substring(0, 300) });
    }
    return priceTexts;
  });

  await context.close();

  return {
    ...prod,
    url,
    capturedAt: new Date().toISOString(),
    pageInfo,
    apiCalls,
    cascadeLog,
    priceDisplay,
    errors,
    screenshots: [
      `fresh_${prod.name}_1_initial.png`,
      `fresh_${prod.name}_2_options.png`,
      `fresh_${prod.name}_3_final.png`,
    ],
  };
}

async function main() {
  console.log('=== WowPress Fresh Capture ===');
  console.log(`Time: ${new Date().toISOString()}`);

  const browser = await chromium.launch({ headless: true });
  const results = [];

  for (const prod of PRODUCTS) {
    try {
      const result = await captureProduct(browser, prod);
      results.push(result);

      // Save individual capture
      fs.writeFileSync(
        path.join(OUT, `fresh_${prod.name}_capture.json`),
        JSON.stringify(result, null, 2)
      );
      console.log(`[${prod.name}] Saved. APIs: ${result.apiCalls?.length || 0}, Cascade: ${result.cascadeLog?.length || 0}`);
    } catch (e) {
      console.error(`[${prod.name}] FATAL: ${e.message}`);
      results.push({ ...prod, error: e.message });
    }
  }

  await browser.close();

  // Generate summary
  const summary = {
    platform: 'wowpress',
    siteUrl: 'https://wowpress.co.kr',
    capturedAt: new Date().toISOString(),
    captureVersion: 'fresh_v2',
    totalProducts: results.length,
    successfulCaptures: results.filter(r => !r.error).length,
    products: results.map(r => ({
      prodNo: r.prodNo,
      name: r.name,
      label: r.label,
      reachable: !r.error,
      framework: r.pageInfo?.framework || 'unknown',
      selectCount: r.pageInfo?.selectCount || 0,
      hasEditor: r.pageInfo?.hasEditor || false,
      apiCallCount: r.apiCalls?.length || 0,
      cascadeTriggered: r.cascadeLog?.filter(c => c.triggeredApiCalls > 0).length || 0,
      priceDisplayFound: (r.priceDisplay?.length || 0) > 0,
      error: r.error || null,
    })),
    apiPatterns: {
      uniqueEndpoints: [...new Set(results.flatMap(r => (r.apiCalls || []).map(a => {
        try { return new URL(a.url).pathname; } catch { return a.url; }
      })))],
      totalApiCalls: results.reduce((sum, r) => sum + (r.apiCalls?.length || 0), 0),
    },
  };

  fs.writeFileSync(path.join(OUT, 'fresh_wow_summary.json'), JSON.stringify(summary, null, 2));
  console.log('\n=== Summary ===');
  console.log(`Products: ${summary.totalProducts}, Success: ${summary.successfulCaptures}`);
  console.log(`Total APIs: ${summary.apiPatterns.totalApiCalls}`);
  console.log(`Unique endpoints: ${summary.apiPatterns.uniqueEndpoints.length}`);
  console.log(`Endpoints: ${summary.apiPatterns.uniqueEndpoints.join(', ')}`);
}

main().catch(e => {
  console.error('FATAL:', e);
  process.exit(1);
});
