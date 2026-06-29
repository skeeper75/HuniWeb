const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const TARGETS = JSON.parse(fs.readFileSync(path.join(__dirname, 'monitor_targets_v2.json'), 'utf8'));
const OUT_DIR = __dirname;

async function monitorProduct(target, browser) {
  const { pdtCode, name, url, level } = target;
  process.stdout.write(`\n[${level}] ${pdtCode}...`);

  const page = await browser.newPage();
  const networkLog = [];

  page.on('response', async (response) => {
    const u = response.url();
    const isWidgetApi = u.includes('get_digital_product_info') ||
                        u.includes('get_ajax_price_vTmpl') ||
                        u.includes('s3GetObjectJson') ||
                        u.includes('guide_product_paper') ||
                        u.includes('widget-api.redprinting');
    if (!isWidgetApi) return;
    try {
      const body = await response.json().catch(() => null);
      networkLog.push({
        timestamp: Date.now(), url: u,
        method: response.request().method(),
        status: response.status(),
        requestBody: response.request().postData(),
        response: body
      });
      process.stdout.write('.');
    } catch {}
  });

  try {
    await page.goto(url, { waitUntil: 'load', timeout: 30000 });
    await page.waitForTimeout(6000);

    const storeSnapshot = await page.evaluate(() => {
      const tryGetPinia = (root) => {
        try {
          const allEls = root.querySelectorAll('*');
          for (const el of allEls) {
            const vueApp = el.__vue_app__;
            if (vueApp) {
              const pinia = vueApp._context?.provides?.pinia || vueApp.config?.globalProperties?.$pinia;
              if (pinia?.state?.value) {
                return Object.fromEntries(Object.keys(pinia.state.value).map(k => [k, JSON.parse(JSON.stringify(pinia.state.value[k]))]));
              }
            }
            if (el.shadowRoot) { const r = tryGetPinia(el.shadowRoot); if (r) return r; }
          }
        } catch(e) { return { error: e.message }; }
        return null;
      };
      if (window.__pinia?.state?.value) {
        return Object.fromEntries(Object.keys(window.__pinia.state.value).map(k => [k, JSON.parse(JSON.stringify(window.__pinia.state.value[k]))]));
      }
      return tryGetPinia(document);
    });

    process.stdout.write(` API:${networkLog.length} Store:${storeSnapshot ? Object.keys(storeSnapshot).join(',') : 'null'}`);

    const result = { pdtCode, name, url, level, capturedAt: new Date().toISOString(),
      networkApiCalls: networkLog.length, storeKeys: storeSnapshot ? Object.keys(storeSnapshot) : [],
      networkLog, storeSnapshot };

    fs.writeFileSync(path.join(OUT_DIR, `v2_${pdtCode}_capture.json`), JSON.stringify(result, null, 2));
    return result;
  } catch (err) {
    process.stdout.write(` ✗ ${err.message.slice(0, 60)}`);
    return { pdtCode, name, url, level, error: err.message };
  } finally {
    await page.close();
  }
}

(async () => {
  const browser = await chromium.launch({ headless: true, args: ['--lang=ko-KR', '--no-sandbox'] });
  const results = [];
  for (const target of TARGETS) {
    const result = await monitorProduct(target, browser);
    results.push({ pdtCode: result.pdtCode, level: result.level,
                   apiCalls: result.networkApiCalls || 0, storeKeys: result.storeKeys || [], error: result.error || null });
    await new Promise(r => setTimeout(r, 2000));
  }
  await browser.close();
  fs.writeFileSync(path.join(OUT_DIR, 'monitor_summary_v2.json'), JSON.stringify({ total: results.length, results }, null, 2));
  console.log('\n\n=== 완료 ===');
  results.forEach(r => console.log(`${r.pdtCode} (${r.level}): API=${r.apiCalls}, stores=[${r.storeKeys.join(',')}]${r.error ? ' ERR' : ''}`));
})();
