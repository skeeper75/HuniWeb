/**
 * 구조 커버리지 스캔 (Phase A) — RedPrinting 카탈로그 전수를 마운트여부 + 옵션구조 시그니처로 분류.
 *
 * 목적: 위젯의 14 componentType + 4 가격모델이 Red 전 구조를 덮는지(완전성 검증), 숨은 NC 리스크가 있는지.
 * 답습용 전수수집이 아니라 "구조 커버리지 맵" — 가격 호출 없이 옵션 스키마 시그니처만 수집(가벼움).
 * Phase B(구조별 대표 1종 price_gbn 캡처)는 이 결과로 대표 선정 후 별도 수행.
 *
 * 출력(증분): _workspace/huni-widget/02_analysis/red-coverage-scan.json  (부분 완료도 활용 가능)
 * 안전: 읽기/옵션조회만(주문·결제·가격 호출 없음), throttle, 소유자 본인 시스템.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');
const BASE = 'http://localhost:3001';
const WAIT = parseInt(process.env.WAIT_MS || '3000', 10);
const LIMIT = parseInt(process.env.LIMIT || '0', 10); // 0 = 전체
const OUT = path.resolve(__dirname, '../../../_workspace/huni-widget/02_analysis/red-coverage-scan.json');
fs.mkdirSync(path.dirname(OUT), { recursive: true });

// 카탈로그 상품 추출
const cat = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../redprinting_catalog.json'), 'utf8'));
const prods = [];
(function walk(o) {
  if (Array.isArray(o)) return o.forEach(walk);
  if (o && typeof o === 'object') { if (o.pdtCode) prods.push({ cat: o.category, code: o.pdtCode, name: o.name || '' }); Object.values(o).forEach(walk); }
})(cat);
const LIST = LIMIT ? prods.slice(0, LIMIT) : prods;
console.log(`[scan] 대상 ${LIST.length} (전체 ${prods.length})`);

const results = [];
const save = () => fs.writeFileSync(OUT, JSON.stringify({ scannedAt: new Date().toISOString(), total: LIST.length, done: results.length, results }, null, 2));

async function probe(browser, p) {
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 1000 } });
  const page = await ctx.newPage();
  let r = { cat: p.cat, code: p.code, name: p.name, mounted: false };
  try {
    await page.goto(BASE, { waitUntil: 'load', timeout: 15000 });
    await page.waitForTimeout(500);
    await page.evaluate(async c => { if (window.selectProduct) await window.selectProduct(c, c); }, p.code);
    await page.waitForTimeout(WAIT);
    r = await page.evaluate((meta) => {
      function* walk(root) { for (const e of root.querySelectorAll('*')) { yield e; if (e.shadowRoot) yield* walk(e.shadowRoot); } }
      const host = document.getElementById('redWidgetSdk');
      if (!host || !host.shadowRoot) return { ...meta, mounted: false };
      const selects = [], nums = []; const radios = new Set(); let nodes = 0; let freeWH = false;
      for (const el of walk(host.shadowRoot)) {
        nodes++;
        if (el.tagName === 'SELECT') selects.push(el.name || el.id || '');
        if (el.tagName === 'INPUT' && el.type === 'number') { const n = el.name || el.id || ''; nums.push(n); if (/재단|작업|^w|^h|WDT|HGH/i.test(n)) freeWH = true; }
        if (el.tagName === 'INPUT' && el.type === 'radio') radios.add(el.name || '');
      }
      const txt = (host.shadowRoot.textContent || '').replace(/\s+/g, ' ').trim();
      const orderable = !/생성할 수 없|설정이 필요/.test(txt);
      // 옵션구조 시그니처: 정렬된 select 이름 + number 수 + freeWH + radio 그룹 수
      const sig = selects.slice().sort().join(',') + '|n' + nums.length + (freeWH ? '|WH' : '') + '|r' + radios.size;
      return { ...meta, mounted: true, orderable, nodes, selects, numCount: nums.length, freeWH, radioGroups: [...radios], sig, textHint: txt.slice(0, 80) };
    }, { cat: p.cat, code: p.code, name: p.name });
  } catch (e) { r.error = e.message; }
  await ctx.close();
  return r;
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  for (let i = 0; i < LIST.length; i++) {
    const r = await probe(browser, LIST[i]);
    results.push(r);
    if (r.mounted) console.log(`[${i + 1}/${LIST.length}] ${r.code} MOUNT sel=${r.selects.length} WH=${!!r.freeWH} sig=${r.sig}`);
    else console.log(`[${i + 1}/${LIST.length}] ${r.code} ${r.error ? 'ERR' : 'legacy/none'}`);
    if ((i + 1) % 10 === 0) save();
    await new Promise(res => setTimeout(res, 800)); // throttle
  }
  save();
  // 요약
  const mounted = results.filter(r => r.mounted);
  const sigs = {}; mounted.forEach(r => { sigs[r.sig] = sigs[r.sig] || []; sigs[r.sig].push(r.code); });
  console.log(`\n[SUMMARY] mounted ${mounted.length}/${results.length} | distinct structures ${Object.keys(sigs).length}`);
  await browser.close();
})().catch(e => { console.error('ERR', e); save(); process.exit(1); });
