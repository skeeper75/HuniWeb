const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const TARGETS = JSON.parse(fs.readFileSync(path.join(__dirname, 'monitor_targets.json'), 'utf8'));
const OUT_DIR = __dirname;

async function monitorProduct(target, browser) {
  const { pdtCode, name, url, level } = target;
  console.log(`\n[${level}] ${name} (${pdtCode})`);

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
      const req = response.request();
      networkLog.push({
        timestamp: Date.now(),
        url: u,
        method: req.method(),
        status: response.status(),
        requestBody: req.postData(),
        response: body
      });
      process.stdout.write('.');
    } catch {}
  });

  try {
    // load 이벤트 후 추가 대기 (networkidle 타임아웃 방지)
    await page.goto(url, { waitUntil: 'load', timeout: 30000 });
    await page.waitForTimeout(5000); // 위젯 JS 초기화 대기

    // Shadow DOM에서 Pinia 스토어 추출
    const storeSnapshot = await page.evaluate(() => {
      // 방법 1: Shadow host 찾기
      const tryGetPinia = (root) => {
        try {
          const allEls = root.querySelectorAll('*');
          for (const el of allEls) {
            // Vue 앱 인스턴스 확인
            const vueApp = el.__vue_app__;
            if (vueApp) {
              const pinia = vueApp._context?.provides?.pinia ||
                            vueApp.config?.globalProperties?.$pinia;
              if (pinia?.state?.value) {
                return Object.fromEntries(
                  Object.keys(pinia.state.value).map(k => [
                    k, JSON.parse(JSON.stringify(pinia.state.value[k]))
                  ])
                );
              }
            }
            // Shadow DOM 안쪽 재귀
            if (el.shadowRoot) {
              const res = tryGetPinia(el.shadowRoot);
              if (res) return res;
            }
          }
        } catch(e) { return { error: e.message }; }
        return null;
      };

      // window.__pinia 직접 시도
      if (window.__pinia?.state?.value) {
        return Object.fromEntries(
          Object.keys(window.__pinia.state.value).map(k => [
            k, JSON.parse(JSON.stringify(window.__pinia.state.value[k]))
          ])
        );
      }

      // Shadow DOM 탐색
      return tryGetPinia(document);
    });

    // 위젯 마운트 포인트 + SDK 인스턴스 정보
    const widgetInfo = await page.evaluate(() => {
      const mounts = [...document.querySelectorAll('[id*="prs"],[id*="widget"],[class*="prs-widget"]')];
      const sdkScript = document.querySelector('script[src*="productRedWidgetSDK"]');
      const widgetScript = document.querySelector('script[src*="widget.js"]');
      const shadowHosts = [...document.querySelectorAll('*')].filter(el => el.shadowRoot);
      return {
        mountPoints: mounts.map(el => ({ id: el.id, class: el.className, tag: el.tagName })),
        sdkScriptUrl: sdkScript?.src,
        widgetScriptUrl: widgetScript?.src,
        shadowHostCount: shadowHosts.length,
        shadowHostIds: shadowHosts.map(el => el.id || el.className).slice(0, 5),
      };
    });

    console.log(`\n  API: ${networkLog.length} | Store: ${storeSnapshot ? Object.keys(storeSnapshot).join(',') : 'null'} | ShadowHosts: ${widgetInfo.shadowHostCount}`);

    const result = {
      pdtCode, name, url, level,
      capturedAt: new Date().toISOString(),
      widgetInfo,
      networkApiCalls: networkLog.length,
      storeKeys: storeSnapshot ? Object.keys(storeSnapshot) : [],
      networkLog,
      storeSnapshot
    };

    fs.writeFileSync(path.join(OUT_DIR, `${pdtCode}_capture.json`), JSON.stringify(result, null, 2));
    return result;

  } catch (err) {
    console.log(`\n  ✗ Error: ${err.message.slice(0, 100)}`);
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
    results.push({ pdtCode: result.pdtCode, name: result.name, level: result.level,
                   apiCalls: result.networkApiCalls || 0, storeKeys: result.storeKeys || [], error: result.error || null });
    await new Promise(r => setTimeout(r, 1500));
  }
  await browser.close();
  fs.writeFileSync(path.join(OUT_DIR, 'monitor_summary.json'), JSON.stringify({ total: results.length, results }, null, 2));
  console.log('\n=== 완료 ===');
  console.log(JSON.stringify(results, null, 2));
})();
