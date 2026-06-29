/**
 * Red Widget Browser Monitor - Live Capture Script
 * Captures API calls + Pinia store snapshots from RedPrinting new widget products
 * Target: GSTGMIC (굿즈), PRBKORD (책자), ACNTHAP (아크릴)
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUTPUT_DIR = __dirname;

const TARGETS = [
  { code: 'GSTGMIC', category: 'GS', level: 'gs-굿즈-네임택' },
  { code: 'PRBKORD', category: 'PR', level: 'book-토너특가-트윈링' },
  { code: 'ACNTHAP', category: 'AC', level: 'ac-아크릴-명찰' },
];

async function captureProduct(browser, target) {
  const { code, category, level } = target;
  const url = `https://www.redprinting.co.kr/ko/product/item/${category}/${code}`;
  console.log(`\n=== Capturing ${code} (${level}) ===`);
  console.log(`  URL: ${url}`);

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
    viewport: { width: 1440, height: 900 },
  });
  const page = await context.newPage();

  const networkLog = [];

  // Intercept widget API calls
  page.on('response', async (response) => {
    const reqUrl = response.url();
    if (
      reqUrl.includes('get_digital_product_info') ||
      reqUrl.includes('get_ajax_price_vTmpl') ||
      reqUrl.includes('s3GetObjectJson') ||
      reqUrl.includes('guide_product_paper')
    ) {
      try {
        const request = response.request();
        let requestBody = null;
        if (request.method() === 'POST') {
          requestBody = request.postData();
        }
        const responseBody = await response.json();
        networkLog.push({
          timestamp: Date.now(),
          url: reqUrl,
          method: request.method(),
          status: response.status(),
          requestBody,
          response: responseBody,
        });
        console.log(`  [API] ${request.method()} ${reqUrl.split('?')[0].split('/').pop()} => ${response.status()}`);
      } catch (e) {
        console.log(`  [API-ERR] Failed to capture ${reqUrl}: ${e.message}`);
      }
    }
  });

  try {
    // Navigate with load strategy (networkidle causes timeouts)
    await page.goto(url, { waitUntil: 'load', timeout: 30000 });
    console.log(`  Page loaded, waiting 10s for widget init...`);
    await page.waitForTimeout(10000);

    // Check if new widget SDK is loaded
    const sdkCheck = await page.evaluate(() => {
      const sdkScript = document.querySelector('script[src*="productRedWidgetSDK"]');
      const shadowHost = document.querySelector('#redWidgetSdk');
      return {
        sdkScript: !!sdkScript,
        shadowHost: !!shadowHost,
        shadowHostTag: shadowHost ? shadowHost.tagName : null,
      };
    });
    console.log(`  SDK: script=${sdkCheck.sdkScript}, shadowHost=${sdkCheck.shadowHost}`);

    if (!sdkCheck.sdkScript) {
      console.log(`  SKIP: ${code} does not use new widget SDK`);
      await context.close();
      return null;
    }

    // Extract Pinia store snapshot from Shadow DOM
    const storeSnapshot = await page.evaluate(() => {
      const tryGetPinia = (root) => {
        const allEls = root.querySelectorAll('*');
        for (const el of allEls) {
          const vueApp = el.__vue_app__;
          if (vueApp) {
            const pinia =
              vueApp._context?.provides?.pinia ||
              vueApp.config?.globalProperties?.$pinia;
            if (pinia?.state?.value) {
              return Object.fromEntries(
                Object.keys(pinia.state.value).map((k) => [
                  k,
                  JSON.parse(JSON.stringify(pinia.state.value[k])),
                ])
              );
            }
          }
          if (el.shadowRoot) {
            const res = tryGetPinia(el.shadowRoot);
            if (res) return res;
          }
        }
        return null;
      };
      return tryGetPinia(document);
    });

    const storeKeys = storeSnapshot ? Object.keys(storeSnapshot) : [];
    console.log(`  Pinia stores: [${storeKeys.join(', ')}]`);

    // Extract product name from API response or page
    let productName = await page.evaluate(() => {
      const titleEl = document.querySelector('.product-title, h1.title, .prd-name');
      return titleEl ? titleEl.textContent.trim() : null;
    });
    if (!productName && networkLog.length > 0) {
      const infoCall = networkLog.find((n) => n.url.includes('get_digital_product_info'));
      if (infoCall?.response?.result?.product_option?.option?.pdt_nme) {
        productName = infoCall.response.result.product_option.option.pdt_nme;
      }
    }

    const result = {
      pdtCode: code,
      name: productName || code,
      url,
      level,
      capturedAt: new Date().toISOString(),
      networkApiCalls: networkLog.length,
      storeKeys,
      networkLog,
      storeSnapshot,
    };

    // Write capture file
    const outFile = path.join(OUTPUT_DIR, `v2_${code}_capture.json`);
    fs.writeFileSync(outFile, JSON.stringify(result, null, 2));
    console.log(`  Written: ${outFile} (${networkLog.length} API calls, ${storeKeys.length} stores)`);

    await context.close();
    return result;
  } catch (err) {
    console.error(`  ERROR capturing ${code}: ${err.message}`);
    await context.close();
    return null;
  }
}

async function main() {
  console.log('Red Widget Browser Monitor - Live Capture');
  console.log(`Targets: ${TARGETS.map((t) => t.code).join(', ')}`);
  console.log(`Output: ${OUTPUT_DIR}\n`);

  const browser = await chromium.launch({ headless: true });
  const results = [];

  for (const target of TARGETS) {
    const result = await captureProduct(browser, target);
    if (result) {
      results.push({
        pdtCode: result.pdtCode,
        name: result.name,
        level: result.level,
        networkApiCalls: result.networkApiCalls,
        storeKeys: result.storeKeys,
        capturedAt: result.capturedAt,
      });
    }
  }

  await browser.close();

  // Write summary
  const summary = {
    generatedAt: new Date().toISOString(),
    totalTargets: TARGETS.length,
    captured: results.length,
    products: results,
  };
  const summaryFile = path.join(OUTPUT_DIR, 'monitor_summary_v2.json');
  fs.writeFileSync(summaryFile, JSON.stringify(summary, null, 2));
  console.log(`\n=== Summary ===`);
  console.log(`Captured: ${results.length}/${TARGETS.length}`);
  console.log(`Written: ${summaryFile}`);
}

main().catch(console.error);
