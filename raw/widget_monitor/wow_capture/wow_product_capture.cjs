const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT_DIR = path.dirname(__filename);

// Target products to capture - based on discovery
// movePage onclick patterns found: ProdNo=40073 (일반명함), plus sitemap URLs
const PRODUCTS = [
  { code: '40073', name: 'namecard', label: '일반명함', listUrl: '/ordr/prod/list?ProdNo=30001&linkProdNo=40073&ldtype=pp' },
  { code: '40002', name: 'sticker', label: '스티커(sitemap)', listUrl: null },
  { code: '40004', name: 'booklet', label: '책자(sitemap)', listUrl: null },
  { code: '40070', name: 'goods1', label: '상품40070', listUrl: null },
  { code: '40064', name: 'goods2', label: '상품40064', listUrl: null },
];

async function captureProduct(browser, product) {
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    viewport: { width: 1440, height: 900 }
  });
  const page = await context.newPage();

  const apiCalls = [];
  page.on('request', req => {
    if (req.resourceType() === 'fetch' || req.resourceType() === 'xhr') {
      const url = req.url();
      if (url.includes('google') || url.includes('facebook') || url.includes('daum') || url.includes('naver.com') || url.includes('sentry') || url.includes('mediacategory') || url.includes('megadata') || url.includes('youtube') || url.includes('firebase') || url.includes('identitytoolkit') || url.includes('doubleclick') || url.includes('googletagmanager')) return;
      apiCalls.push({
        url,
        method: req.method(),
        postData: req.postData(),
        timestamp: Date.now()
      });
    }
  });
  page.on('response', async resp => {
    const entry = apiCalls.find(c => c.url === resp.url() && !c.status);
    if (entry) {
      entry.status = resp.status();
      try {
        const ct = resp.headers()['content-type'] || '';
        if (ct.includes('json')) {
          entry.responseBody = await resp.json();
        } else {
          const text = await resp.text();
          if (text.length < 5000) entry.responseBody = text;
          else entry.responseBody = text.slice(0, 2000) + '...[truncated]';
          entry.contentType = ct;
        }
      } catch { entry.responseBody = null; }
    }
  });

  console.log(`\n--- Capturing ${product.name} (ProdNo=${product.code}) ---`);

  // Step 1: Navigate to product detail page
  const detsUrl = `https://wowpress.co.kr/ordr/prod/dets?ProdNo=${product.code}`;
  console.log(`[1] Loading detail page: ${detsUrl}`);

  let pageReachable = true;
  try {
    const resp = await page.goto(detsUrl, { waitUntil: 'load', timeout: 30000 });
    if (resp && resp.status() >= 400) {
      console.log(`  Detail page returned ${resp.status()}, trying list page...`);
      pageReachable = false;
    }
  } catch (e) {
    console.log(`  Detail page error: ${e.message.split('\n')[0]}`);
    pageReachable = false;
  }

  // If detail page failed, try list page
  if (!pageReachable && product.listUrl) {
    try {
      await page.goto(`https://wowpress.co.kr${product.listUrl}`, { waitUntil: 'load', timeout: 30000 });
      pageReachable = true;
    } catch {}
  }

  // Also try /ordr/prod/form pattern
  if (!pageReachable) {
    try {
      await page.goto(`https://wowpress.co.kr/ordr/prod/form?ProdNo=${product.code}`, { waitUntil: 'load', timeout: 20000 });
      pageReachable = true;
    } catch {}
  }

  await page.waitForTimeout(6000);
  const finalUrl = page.url();
  console.log(`  Final URL: ${finalUrl}`);

  // Screenshot step 1
  await page.screenshot({ path: path.join(OUT_DIR, `wow_${product.name}_1_initial.png`), fullPage: false });

  // Step 2: Extract page structure
  const pageInfo = await page.evaluate(() => {
    return {
      title: document.title,
      url: location.href,
      framework: window.Vue ? 'vue' : window.__NEXT_DATA__ ? 'next' : window.React ? 'react' : window.jQuery ? 'jquery' : 'unknown',
      forms: Array.from(document.querySelectorAll('form')).map(f => ({
        id: f.id,
        action: f.action,
        method: f.method,
        inputs: Array.from(f.querySelectorAll('input, select, textarea')).map(i => ({
          tag: i.tagName,
          type: i.type,
          name: i.name,
          id: i.id,
          value: i.value?.slice(0, 100),
          options: i.tagName === 'SELECT' ? Array.from(i.options).map(o => ({ value: o.value, text: o.text.trim() })) : undefined
        }))
      })),
      selects: Array.from(document.querySelectorAll('select')).map(s => ({
        name: s.name,
        id: s.id,
        className: s.className,
        options: Array.from(s.options).map(o => ({ value: o.value, text: o.text.trim() })),
        parentText: s.parentElement?.textContent?.trim()?.slice(0, 50) || ''
      })),
      buttons: Array.from(document.querySelectorAll('button, input[type="submit"], [class*="btn"], a[class*="btn"]')).map(b => ({
        tag: b.tagName,
        text: b.textContent.trim().slice(0, 50),
        type: b.type,
        className: b.className?.slice(0, 100),
        onclick: b.getAttribute('onclick')?.slice(0, 100) || ''
      })).filter(b => b.text.length > 0),
      bodyText: document.body?.innerText?.slice(0, 5000) || '',
      hasEditor: !!document.querySelector('[class*="editor"], [id*="editor"], iframe[src*="editor"], [class*="template"], [class*="design"]'),
      editorElements: Array.from(document.querySelectorAll('[class*="editor"], [class*="template"], [class*="design"], [class*="dsgn"], [class*="easytemplate"]')).map(el => ({
        tag: el.tagName,
        class: el.className?.slice(0, 100),
        id: el.id,
        text: el.textContent?.trim()?.slice(0, 50)
      })),
      priceElements: Array.from(document.querySelectorAll('[class*="price"], [class*="cost"], [class*="amount"], [class*="total"], [id*="price"], [id*="total"]')).map(el => ({
        class: el.className?.slice(0, 100),
        id: el.id,
        text: el.textContent?.trim()?.slice(0, 100)
      })),
      iframes: Array.from(document.querySelectorAll('iframe')).map(i => ({ src: i.src, id: i.id, class: i.className })),
      selectCount: document.querySelectorAll('select').length,
      formCount: document.querySelectorAll('form').length,
    };
  });

  console.log(`  Selects: ${pageInfo.selectCount}, Forms: ${pageInfo.formCount}`);
  console.log(`  Buttons: ${pageInfo.buttons.map(b => b.text).join(', ')}`);
  console.log(`  Has editor: ${pageInfo.hasEditor}`);
  console.log(`  Price elements: ${pageInfo.priceElements.length}`);

  // Step 3: If there are selects (options), try interacting with them
  let optionInteractions = [];
  if (pageInfo.selects.length > 0) {
    console.log(`[3] Interacting with ${pageInfo.selects.length} option selects...`);
    for (let i = 0; i < Math.min(pageInfo.selects.length, 5); i++) {
      const sel = pageInfo.selects[i];
      console.log(`  Select "${sel.name || sel.id}": ${sel.options.length} options`);
      sel.options.slice(0, 3).forEach(o => console.log(`    - ${o.text} (${o.value})`));

      if (sel.options.length > 1) {
        // Select the second option (first non-default) and capture API response
        const preApiCount = apiCalls.length;
        try {
          const selector = sel.id ? `#${sel.id}` : sel.name ? `select[name="${sel.name}"]` : `select:nth-of-type(${i + 1})`;
          const targetValue = sel.options[1]?.value || sel.options[0]?.value;
          if (targetValue) {
            await page.selectOption(selector, targetValue);
            await page.waitForTimeout(2000);
          }
        } catch (e) {
          console.log(`    Select interaction failed: ${e.message.split('\n')[0]}`);
        }
        const newApis = apiCalls.slice(preApiCount);
        if (newApis.length > 0) {
          console.log(`    -> Triggered ${newApis.length} API calls`);
          newApis.forEach(a => console.log(`       ${a.method} ${a.url.replace('https://wowpress.co.kr', '')}`));
        }
        optionInteractions.push({
          selectName: sel.name || sel.id,
          selectedValue: sel.options[1]?.value,
          triggeredApis: newApis.map(a => ({ url: a.url, method: a.method }))
        });
      }
    }

    // Screenshot after option selections
    await page.screenshot({ path: path.join(OUT_DIR, `wow_${product.name}_2_options.png`), fullPage: false });
  }

  // Step 4: Look for price calculation trigger
  console.log(`[4] Checking price calculation...`);
  const priceInfo = await page.evaluate(() => {
    const priceEls = document.querySelectorAll('[class*="price"], [class*="cost"], [class*="amount"], [class*="total"], [id*="price"], [id*="total"], [id*="amt"]');
    return Array.from(priceEls).map(el => ({
      class: el.className?.slice(0, 100),
      id: el.id,
      text: el.textContent?.trim()?.slice(0, 100),
      value: el.value || el.innerText?.trim()?.slice(0, 50)
    }));
  });
  console.log(`  Price elements: ${priceInfo.length}`);
  priceInfo.slice(0, 5).forEach(p => console.log(`    ${p.id || p.class?.slice(0, 30)}: ${p.text?.slice(0, 50)}`));

  // Step 5: Look for order/cart buttons
  console.log(`[5] Checking order flow...`);
  const orderButtons = pageInfo.buttons.filter(b =>
    /장바구니|주문|견적|담기|cart|order|바로주문|디자인|템플릿|이지/.test(b.text + b.onclick)
  );
  console.log(`  Order buttons: ${orderButtons.map(b => `${b.text}(${b.onclick?.slice(0, 30)})`).join(', ')}`);

  // Step 6: Check for editor/template integration
  console.log(`[6] Editor/template check...`);
  const editorInfo = await page.evaluate(() => {
    const info = {
      easyTemplate: !!document.querySelector('[class*="easy"], [class*="eazy"], [onclick*="dsgn"], [onclick*="template"], [onclick*="editor"]'),
      templateButtons: [],
      editorIframes: [],
      designLinks: []
    };

    document.querySelectorAll('[onclick*="dsgn"], [onclick*="template"], [onclick*="editor"], [onclick*="design"]').forEach(el => {
      info.templateButtons.push({
        tag: el.tagName,
        text: el.textContent.trim().slice(0, 50),
        onclick: el.getAttribute('onclick')?.slice(0, 150)
      });
    });

    document.querySelectorAll('a[href*="dsgn"], a[href*="template"], a[href*="editor"], a[href*="design"]').forEach(el => {
      info.designLinks.push({ href: el.href, text: el.textContent.trim().slice(0, 50) });
    });

    return info;
  });
  console.log(`  Easy template: ${editorInfo.easyTemplate}`);
  console.log(`  Template buttons: ${editorInfo.templateButtons.map(b => b.text).join(', ')}`);
  editorInfo.templateButtons.forEach(b => console.log(`    ${b.text}: ${b.onclick}`));

  // Step 7: Full page screenshot
  try {
    await page.screenshot({ path: path.join(OUT_DIR, `wow_${product.name}_3_full.png`), fullPage: true });
  } catch {
    // fullPage might fail for very long pages
    await page.screenshot({ path: path.join(OUT_DIR, `wow_${product.name}_3_full.png`), fullPage: false });
  }

  // Compile result
  const result = {
    pdtCode: product.code,
    name: product.name,
    label: product.label,
    url: finalUrl,
    capturedAt: new Date().toISOString(),
    pageReachable,
    pageInfo: {
      title: pageInfo.title,
      framework: pageInfo.framework,
      selectCount: pageInfo.selectCount,
      formCount: pageInfo.formCount,
      hasEditor: pageInfo.hasEditor,
    },
    selects: pageInfo.selects,
    forms: pageInfo.forms,
    buttons: pageInfo.buttons,
    priceElements: priceInfo,
    editorInfo,
    optionInteractions,
    orderButtons,
    apiCalls: apiCalls.filter(c => c.url.includes('wowpress.co.kr')),
    allApiCalls: apiCalls,
    screenshots: [
      `wow_${product.name}_1_initial.png`,
      `wow_${product.name}_2_options.png`,
      `wow_${product.name}_3_full.png`
    ]
  };

  fs.writeFileSync(path.join(OUT_DIR, `wow_${product.name}_capture.json`), JSON.stringify(result, null, 2));
  console.log(`  Saved: wow_${product.name}_capture.json (${apiCalls.length} API calls)`);

  await context.close();
  return result;
}

async function main() {
  const browser = await chromium.launch({ headless: true });
  const results = [];

  for (const product of PRODUCTS) {
    try {
      const result = await captureProduct(browser, product);
      results.push(result);
    } catch (e) {
      console.error(`Error capturing ${product.name}:`, e.message);
      results.push({ pdtCode: product.code, name: product.name, error: e.message });
    }
  }

  // Generate summary
  const summary = {
    platform: 'wowpress',
    siteUrl: 'https://wowpress.co.kr',
    capturedAt: new Date().toISOString(),
    products: results.map(r => ({
      pdtCode: r.pdtCode,
      name: r.name,
      label: r.label,
      url: r.url,
      framework: r.pageInfo?.framework || 'unknown',
      optionCascadeApiCalls: r.apiCalls?.filter(c => c.url.includes('wowpress') && !c.url.includes('myInfo') && !c.url.includes('favorite')) || [],
      priceApiCalls: r.apiCalls?.filter(c => c.url.includes('price') || c.url.includes('calc') || c.url.includes('cost')) || [],
      uiFlow: {
        steps: r.orderButtons?.length > 0 ? (r.pageInfo?.hasEditor ? 4 : 3) : 0,
        hasEditor: r.pageInfo?.hasEditor || false,
        optionCount: r.pageInfo?.selectCount || 0,
        priceDisplayType: r.priceElements?.length > 0 ? 'inline' : 'unknown',
      },
      editorInfo: r.editorInfo || null,
      screenshots: r.screenshots || [],
      error: r.error || null
    })),
    summary: {
      totalProducts: results.length,
      successfulCaptures: results.filter(r => !r.error).length,
      withEditor: results.filter(r => r.pageInfo?.hasEditor).length,
      avgOptionCount: Math.round(results.filter(r => r.pageInfo).reduce((s, r) => s + (r.pageInfo.selectCount || 0), 0) / Math.max(results.filter(r => r.pageInfo).length, 1)),
      uniqueApiPatterns: [...new Set(results.flatMap(r => (r.apiCalls || []).filter(c => c.url.includes('wowpress')).map(c => `${c.method} ${new URL(c.url).pathname}`)))],
      templateCount: 58906, // from /self/dsgn/gettotpdcnt
      framework: 'jquery',
      urlPattern: '/ordr/prod/dets?ProdNo={code}',
    }
  };

  fs.writeFileSync(path.join(OUT_DIR, 'wow_summary.json'), JSON.stringify(summary, null, 2));
  console.log('\n===== SUMMARY =====');
  console.log(`Captured: ${summary.summary.successfulCaptures}/${summary.summary.totalProducts}`);
  console.log(`With editor: ${summary.summary.withEditor}`);
  console.log(`Avg options: ${summary.summary.avgOptionCount}`);
  console.log(`API patterns: ${summary.summary.uniqueApiPatterns.join(', ')}`);

  await browser.close();
}

main().catch(e => {
  console.error('Fatal:', e.message);
  process.exit(1);
});
