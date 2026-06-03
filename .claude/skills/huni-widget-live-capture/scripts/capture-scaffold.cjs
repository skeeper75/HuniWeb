/**
 * 공유 캡처 scaffold — 확대 스테이지(S1~Sn)의 신규 상품 라이브 캡처용 단일 출처.
 *
 * 매 스테이지가 near-identical Playwright 캡처(selectProduct → Shadow DOM 옵션스키마 덤프 →
 * get_ajax_price_vTmpl/get_digital_product_info 인터셉트)를 손작성하다 redact 누락(respBody JWT 누출)이
 * 반복됐다. 이 scaffold가 그 공통 패턴 + 안전 redact를 한곳에 고정한다. 스테이지별 차이는 env로 흡수.
 *
 * [보안 핵심] respBody는 Edicus 세션 JWT(refreshToken·customerCode·userId)를 echo할 수 있다.
 * 따라서 직렬화된 출력 "전체"를 쓰기 전에 redact한다 — reqBody만 redact하면 respBody로 누출된다(반복 결함).
 *
 * 사용:
 *   PREFIX=s6_cal PRODUCTS=HLCLSTD,HLCLWAL node capture-scaffold.cjs
 *   (옵션) OUT_DIR/RAW_DIR 절대경로 override, WAIT_MS, BASE 변경 가능
 *
 * 안전 모드: 읽기/견적 조회만(주문·결제 호출 없음), 요청 간 throttle, _workspace 하위 저장.
 * 스테이지 고유 상호작용(자유 W/H 입력, 수량 스윕 등)이 필요하면 이 파일을 복사해 step 블록만 추가하라.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE = process.env.BASE || 'http://localhost:3001';
const PREFIX = process.env.PREFIX || 'cap';
const CODES = (process.env.PRODUCTS || '').split(',').map(s => s.trim()).filter(Boolean);
const WAIT_MS = parseInt(process.env.WAIT_MS || '6000', 10);
// 위치 무관 경로 해석: cwd에서 상향 탐색으로 _workspace/huni-widget를 찾는다 (skill 디렉토리/testbed
// 어디서 실행하든 동작). 못 찾으면 OUT_DIR/RAW_DIR env override 필수.
function findRoot(start) {
  let d = start;
  for (let i = 0; i < 8; i++) {
    const cand = path.join(d, '_workspace/huni-widget');
    if (fs.existsSync(cand)) return cand;
    const up = path.dirname(d); if (up === d) break; d = up;
  }
  return null;
}
const ROOT = findRoot(process.cwd()) || findRoot(__dirname);
if (!ROOT && !(process.env.OUT_DIR && process.env.RAW_DIR)) {
  console.error('_workspace/huni-widget를 찾지 못했다. OUT_DIR/RAW_DIR env로 절대경로를 지정하라.'); process.exit(1);
}
const OUT = process.env.OUT_DIR || path.join(ROOT, '05_qa/captures');
const RAW = process.env.RAW_DIR || path.join(ROOT, '01_reverse/s3_raw_captures');
fs.mkdirSync(OUT, { recursive: true });
fs.mkdirSync(RAW, { recursive: true });

if (!CODES.length) { console.error('PRODUCTS env가 비었다. 예: PRODUCTS=HLCLSTD,HLCLWAL'); process.exit(1); }

// [보안] token= 쿼리값과 3-part JWT(eyJ...)를 모두 치환. 직렬화 출력 전체에 적용한다.
const redact = s => (s || '')
  .replace(/(token=)[^&"\s]+/gi, '$1[REDACTED]')
  .replace(/eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.?[A-Za-z0-9_-]*/g, '[JWT]');

async function captureOne(browser, code) {
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 1100 } });
  const page = await ctx.newPage();
  const priceCalls = [], infoCalls = [];
  const t0 = Date.now(); const rel = () => Date.now() - t0;
  page.context().on('response', async resp => {
    const u = resp.url();
    if (/get_ajax_price_vTmpl/.test(u)) {
      let r = null; try { r = await resp.json(); } catch {}
      let req = null; try { req = resp.request().postData(); } catch {}
      priceCalls.push({ rel: rel(), status: resp.status(), reqBody: req, respBody: r });
    } else if (/get_digital_product_info/.test(u)) {
      let r = null; try { r = await resp.json(); } catch {}
      infoCalls.push({ rel: rel(), status: resp.status(), respBody: r });
    }
  });

  await page.goto(BASE, { waitUntil: 'load', timeout: 20000 });
  await page.waitForTimeout(800);
  await page.evaluate(async c => { if (window.selectProduct) await window.selectProduct(c, c); }, code);
  await page.waitForTimeout(WAIT_MS);

  // Shadow DOM 옵션 스키마 덤프 (select/number/radio/text)
  const schema = await page.evaluate(() => {
    function* walk(r) { for (const e of r.querySelectorAll('*')) { yield e; if (e.shadowRoot) yield* walk(e.shadowRoot); } }
    const host = document.getElementById('redWidgetSdk');
    if (!host || !host.shadowRoot) return { mounted: false };
    const selects = [], numbers = [], radios = new Set(), textInputs = []; let nodeCount = 0;
    for (const el of walk(host.shadowRoot)) {
      nodeCount++;
      if (el.tagName === 'SELECT') selects.push({ name: el.name || el.id || '', options: [...el.options].map(o => (o.textContent || '').trim()).slice(0, 40) });
      if (el.tagName === 'INPUT' && el.type === 'number') numbers.push({ name: el.name || el.id || '', value: el.value });
      if (el.tagName === 'INPUT' && el.type === 'radio') radios.add(el.name || '');
      if (el.tagName === 'INPUT' && el.type === 'text') textInputs.push(el.name || el.id || '');
    }
    const txt = (host.shadowRoot.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 300);
    return { mounted: true, nodeCount, selects, numbers, radioGroups: [...radios], textInputs, textSample: txt };
  });

  // 기본 상호작용: 첫 실규격 프리셋(idx 1) + 수량 100 → PRICE>0 강제
  let action = { ok: false };
  if (schema.mounted) {
    action = await page.evaluate(() => {
      function* walk(r) { for (const e of r.querySelectorAll('*')) { yield e; if (e.shadowRoot) yield* walk(e.shadowRoot); } }
      const host = document.getElementById('redWidgetSdk'); if (!host || !host.shadowRoot) return { ok: false };
      let sizeSel = null, qty = null;
      for (const el of walk(host.shadowRoot)) {
        if (el.tagName === 'SELECT' && /size|규격|사이즈/i.test((el.name || '') + (el.id || ''))) sizeSel = el;
        if (el.tagName === 'INPUT' && el.type === 'number' && /ORD_CNT|수량|qty|cnt/i.test(el.name || '')) qty = el;
      }
      if (!sizeSel) for (const el of walk(host.shadowRoot)) { if (el.tagName === 'SELECT' && el.options.length > 1) { sizeSel = el; break; } }
      if (!qty) for (const el of walk(host.shadowRoot)) { if (el.tagName === 'INPUT' && el.type === 'number') { qty = el; break; } }
      let picked = null;
      if (sizeSel && sizeSel.options.length > 1) { sizeSel.selectedIndex = Math.min(1, sizeSel.options.length - 1); sizeSel.dispatchEvent(new Event('change', { bubbles: true })); picked = (sizeSel.options[sizeSel.selectedIndex].textContent || '').trim(); }
      if (qty) { qty.value = '100'; qty.dispatchEvent(new Event('input', { bubbles: true })); qty.dispatchEvent(new Event('change', { bubbles: true })); }
      return { ok: true, sizePicked: picked, sizeName: sizeSel ? (sizeSel.name || sizeSel.id) : null, qtySet: !!qty };
    });
    await page.waitForTimeout(4000);
  }

  const out = {
    product: code, capturedAt: new Date().toISOString(), schema, action,
    infoCalls: infoCalls.map(c => ({ rel: c.rel, status: c.status, respBody: c.respBody })),
    priceCalls: priceCalls.map(c => ({ rel: c.rel, status: c.status, reqBody: c.reqBody, respBody: c.respBody })),
  };
  // [보안] 직렬화 출력 전체 redact 후 기록 (respBody JWT 누출 방지)
  const serialized = redact(JSON.stringify(out, null, 2));
  fs.writeFileSync(path.join(OUT, `${PREFIX}_${code}.json`), serialized);
  fs.writeFileSync(path.join(RAW, `${PREFIX}_${code}.json`), serialized);
  console.log(`[${code}] mounted=${schema.mounted} nodes=${schema.nodeCount || 0} selects=${schema.selects ? schema.selects.length : 0} priceCalls=${priceCalls.length} info=${infoCalls.length}`);
  await ctx.close();
  return { code, mounted: schema.mounted, priceCalls: priceCalls.length };
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  const summary = [];
  for (const code of CODES) {
    try { summary.push(await captureOne(browser, code)); }
    catch (e) { console.error(`[${code}] ERR`, e.message); summary.push({ code, error: e.message }); }
    await new Promise(r => setTimeout(r, 1500)); // throttle (안전 모드)
  }
  console.log('[SUMMARY]', JSON.stringify(summary));
  await browser.close();
})().catch(e => { console.error('ERR', e); process.exit(1); });
