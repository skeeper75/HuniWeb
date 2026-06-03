/**
 * 구조 커버리지 Phase B — Phase A(red-coverage-scan.json) 구조 시그니처별 대표 1종의 가격모델(price_gbn) 캡처.
 *
 * 목적: 46개 구조 각각이 어느 가격모델(offset2023/vTmpl/tmpl/tiered...)에 매핑되는지 → 커버리지 매트릭스 입력.
 * price_gbn 은 get_ajax_price_vTmpl reqBody 에 항상 실리므로 PRICE>0 강제 없이도(첫 규격+수량만) 추출된다.
 * 대표 1종만 → 답습 전수수집 아님(게이트 준수). 출력: _workspace/huni-widget/02_analysis/red-coverage-phaseB.json
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const A = path.resolve(__dirname, '../../../_workspace/huni-widget/02_analysis/red-coverage-scan.json');
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/02_analysis/red-coverage-phaseB.json');

// Phase A 결과 → 구조별 대표(첫 코드) 선정
const scan = JSON.parse(fs.readFileSync(A, 'utf8'));
const bySig = {};
for (const x of scan.results) if (x.mounted) (bySig[x.sig] = bySig[x.sig] || []).push(x);
const reps = Object.entries(bySig).map(([sig, arr]) => ({ sig, count: arr.length, rep: arr[0].code, cat: arr[0].cat, name: arr[0].name, selects: arr[0].selects, freeWH: arr[0].freeWH }));
console.log(`[phaseB] 구조 ${reps.length}종 대표 캡처`);

const unwrap = (x, n = 0) => {
  if (n > 6) return x;
  if (typeof x === 'string') { try { return unwrap(JSON.parse(x), n + 1); } catch { return x; } }
  if (x && typeof x === 'object' && Object.keys(x).length === 1 && 'dataJson' in x) return unwrap(x.dataJson, n + 1);
  return x;
};
const results = [];
const save = () => fs.writeFileSync(OUT, JSON.stringify({ capturedAt: new Date().toISOString(), structures: reps.length, results }, null, 2));

async function capRep(browser, r) {
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 1000 } });
  const page = await ctx.newPage();
  let priceReq = null, price = null, status = null;
  page.context().on('response', async resp => {
    if (/get_ajax_price_vTmpl/.test(resp.url())) {
      try { priceReq = resp.request().postData(); } catch {}
      status = resp.status();
      try { const j = await resp.json(); price = (j.result_sum || {}).PRICE; } catch {}
    }
  });
  let out = { sig: r.sig, count: r.count, rep: r.rep, cat: r.cat, name: r.name };
  try {
    await page.goto(BASE, { waitUntil: 'load', timeout: 15000 });
    await page.waitForTimeout(600);
    await page.evaluate(async c => { if (window.selectProduct) await window.selectProduct(c, c); }, r.rep);
    await page.waitForTimeout(3500);
    // 첫 실규격 + 수량 100 → 가격 호출 유발
    await page.evaluate(() => {
      function* walk(root) { for (const e of root.querySelectorAll('*')) { yield e; if (e.shadowRoot) yield* walk(e.shadowRoot); } }
      const host = document.getElementById('redWidgetSdk'); if (!host || !host.shadowRoot) return;
      let sizeSel = null, qty = null;
      for (const el of walk(host.shadowRoot)) {
        if (el.tagName === 'SELECT' && /size|규격|사이즈/i.test((el.name || '') + (el.id || ''))) sizeSel = el;
        if (el.tagName === 'INPUT' && el.type === 'number' && /ORD_CNT|수량|qty|cnt/i.test(el.name || '')) qty = el;
      }
      if (!sizeSel) for (const el of walk(host.shadowRoot)) { if (el.tagName === 'SELECT' && el.options.length > 1) { sizeSel = el; break; } }
      if (!qty) for (const el of walk(host.shadowRoot)) { if (el.tagName === 'INPUT' && el.type === 'number') { qty = el; break; } }
      if (sizeSel && sizeSel.options.length > 1) { sizeSel.selectedIndex = Math.min(1, sizeSel.options.length - 1); sizeSel.dispatchEvent(new Event('change', { bubbles: true })); }
      if (qty) { qty.value = '100'; qty.dispatchEvent(new Event('input', { bubbles: true })); qty.dispatchEvent(new Event('change', { bubbles: true })); }
    });
    await page.waitForTimeout(4000);
    let price_gbn = null;
    if (priceReq) { const inner = unwrap(priceReq); if (inner && typeof inner === 'object') price_gbn = inner.price_gbn || null; }
    out = { ...out, price_gbn, price: price ?? null, priceStatus: status, hadPriceCall: !!priceReq };
  } catch (e) { out.error = e.message; }
  await ctx.close();
  return out;
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  for (let i = 0; i < reps.length; i++) {
    const o = await capRep(browser, reps[i]);
    results.push(o);
    console.log(`[${i + 1}/${reps.length}] ${o.rep} (${o.count}개) price_gbn=${o.price_gbn || '?'} PRICE=${o.price ?? '-'}`);
    save();
    await new Promise(res => setTimeout(res, 800));
  }
  const gbns = {}; results.forEach(o => { const g = o.price_gbn || 'unknown'; gbns[g] = (gbns[g] || 0) + 1; });
  console.log('\n[SUMMARY] price_gbn 분포:', JSON.stringify(gbns));
  await browser.close();
})().catch(e => { console.error('ERR', e); save(); process.exit(1); });
