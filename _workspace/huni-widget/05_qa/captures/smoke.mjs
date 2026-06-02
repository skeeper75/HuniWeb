// Pass-1 SMOKE test driver (Playwright + installed Chrome channel).
// Real browser render — no fabrication. Output JSON to stdout.
import { chromium } from 'playwright';

const URL = 'http://localhost:5173/';
const OUT = '/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/05_qa/captures';

const consoleMsgs = [];
const pageErrors = [];

const browser = await chromium.launch({
  channel: 'chrome',
  headless: true,
  args: ['--no-sandbox'],
});
const ctx = await browser.newContext({ viewport: { width: 800, height: 1400 }, deviceScaleFactor: 2 });
const page = await ctx.newPage();

page.on('console', (m) => consoleMsgs.push({ type: m.type(), text: m.text() }));
page.on('pageerror', (e) => pageErrors.push(String(e)));

const result = { url: URL, navigated: false, shadow: {}, render: {}, isolation: {}, portal: {}, price: {}, interaction: {}, console: {}, errors: [] };

try {
  const resp = await page.goto(URL, { waitUntil: 'networkidle', timeout: 30000 });
  result.navigated = true;
  result.status = resp?.status();

  // wait for shadowRoot + widget root to appear
  await page.waitForFunction(() => {
    const h = document.getElementById('host');
    return h && h.shadowRoot && h.shadowRoot.getElementById('huni-widget-root') && h.shadowRoot.getElementById('huni-widget-root').children.length > 0;
  }, { timeout: 15000 }).catch((e) => { result.errors.push('waitForWidget: ' + e.message); });

  await page.waitForTimeout(1500); // let async product/price fetch settle

  await page.screenshot({ path: `${OUT}/pass1_smoke_full.png`, fullPage: true });

  // ---- Shadow DOM + isolation + render probes (run inside page) ----
  const probe = await page.evaluate(() => {
    const out = { shadowRoot: false, mode: null, rootChildren: 0, hostCssLeak: {}, buttons: [], textSample: null, componentMarkers: {}, html: null, priceText: null };
    const host = document.getElementById('host');
    if (!host) return out;
    const sr = host.shadowRoot;
    out.shadowRoot = !!sr;
    if (!sr) return out;
    out.mode = 'open (accessible from JS)';
    const wroot = sr.getElementById('huni-widget-root');
    out.rootChildren = wroot ? wroot.children.length : 0;

    // capture inner HTML (trimmed) for component-type detection
    out.html = wroot ? wroot.innerHTML.slice(0, 20000) : null;

    // ---- isolation: inspect widget buttons computed style ----
    const btns = Array.from(sr.querySelectorAll('button')).slice(0, 8);
    out.buttons = btns.map((b) => {
      const cs = getComputedStyle(b);
      return {
        text: (b.textContent || '').trim().slice(0, 24),
        bg: cs.backgroundColor,
        borderRadius: cs.borderRadius,
        fontFamily: cs.fontFamily,
        fontSize: cs.fontSize,
      };
    });

    // host button for reference (the H1 area / body)
    const bodyCs = getComputedStyle(document.body);
    out.hostCssLeak.bodyFontFamily = bodyCs.fontFamily;
    out.hostCssLeak.bodyFontSize = bodyCs.fontSize;

    // sample widget text element font
    const anyText = sr.querySelector('label, h1, h2, h3, span, p, div');
    if (anyText) {
      const tc = getComputedStyle(anyText);
      out.textSample = { fontFamily: tc.fontFamily, fontSize: tc.fontSize, tag: anyText.tagName };
    }

    // ---- component-type markers via data attributes / role / classes ----
    const markerSel = {
      'option-button': '[data-component="option-button"], [data-ctype="option-button"]',
      'select-box': '[role="combobox"], [data-component="select-box"], button[aria-haspopup]',
      'counter': '[data-component="counter"], [data-ctype="counter"]',
      'color-chip': '[data-component="color-chip"], [data-ctype="color-chip"]',
      'image-chip': '[data-component="image-chip"], [data-ctype="image-chip"]',
      'price-slider': '[data-component="price-slider"], input[type="range"]',
      'area-input': '[data-component="area-input"], input[type="number"]',
    };
    for (const [k, sel] of Object.entries(markerSel)) {
      out.componentMarkers[k] = sr.querySelectorAll(sel).length;
    }
    // generic: count any data-component / data-ctype values
    const typed = Array.from(sr.querySelectorAll('[data-component],[data-ctype]'));
    out.dataComponentValues = {};
    typed.forEach((el) => {
      const v = el.getAttribute('data-component') || el.getAttribute('data-ctype');
      out.dataComponentValues[v] = (out.dataComponentValues[v] || 0) + 1;
    });

    // price area text
    const priceEl = sr.querySelector('[data-component="price-summary"], [class*="price"], [class*="Price"]');
    out.priceText = priceEl ? (priceEl.textContent || '').trim().slice(0, 200) : null;
    // fallback: any element containing 원 or ₩
    if (!out.priceText) {
      const all = Array.from(sr.querySelectorAll('*')).find((e) => /원|₩|\d{1,3}(,\d{3})+/.test(e.childNodes.length === 1 ? e.textContent : ''));
      out.priceText = all ? all.textContent.trim().slice(0, 200) : null;
    }
    return out;
  });

  result.shadow.present = probe.shadowRoot;
  result.shadow.mode = probe.mode;
  result.shadow.rootChildren = probe.rootChildren;
  result.render.buttons = probe.buttons;
  result.render.textSample = probe.textSample;
  result.render.componentMarkers = probe.componentMarkers;
  result.render.dataComponentValues = probe.dataComponentValues;
  result.isolation.bodyFont = probe.hostCssLeak;
  result.price.text = probe.priceText;
  result._htmlLen = probe.html ? probe.html.length : 0;

  // save inner HTML for offline component-type analysis
  if (probe.html) {
    const { writeFileSync } = await import('fs');
    writeFileSync(`${OUT}/pass1_shadow_innerHTML.html`, probe.html);
  }

  // ---- isolation verdict ----
  const leak = { redButton: false, pillButton: false, timesFont: false, font12: false };
  for (const b of probe.buttons) {
    if (/rgb\(255, 0, 0\)|red/.test(b.bg)) leak.redButton = true;
    if (b.borderRadius && (b.borderRadius.includes('9999') || parseFloat(b.borderRadius) > 100)) leak.pillButton = true;
    if (/times/i.test(b.fontFamily)) leak.timesFont = true;
    if (b.fontSize === '12px') leak.font12 = true;
  }
  if (probe.textSample) {
    if (/times/i.test(probe.textSample.fontFamily)) leak.timesFont = true;
  }
  result.isolation.leakFlags = leak;
  result.isolation.PASS = !leak.redButton && !leak.pillButton && !leak.timesFont;

  // ---- Portal-in-Shadow: try to open a select / combobox ----
  try {
    const opener = await page.evaluateHandle(() => {
      const sr = document.getElementById('host').shadowRoot;
      return sr.querySelector('[role="combobox"], button[aria-haspopup], [data-component="select-box"] button, button');
    });
    const el = opener.asElement();
    if (el) {
      await el.click({ force: true }).catch(() => {});
      await page.waitForTimeout(600);
      const portalProbe = await page.evaluate(() => {
        const sr = document.getElementById('host').shadowRoot;
        const inShadowPopup = sr.querySelector('[role="listbox"], [data-radix-popper-content-wrapper], [role="menu"], [data-state="open"][role], [class*="Select"][data-state="open"]');
        const inBodyPopup = document.body.querySelector('[data-radix-popper-content-wrapper], [role="listbox"]');
        let styled = null;
        if (inShadowPopup) {
          const cs = getComputedStyle(inShadowPopup);
          styled = { bg: cs.backgroundColor, fontFamily: cs.fontFamily, display: cs.display };
        }
        return {
          inShadow: !!inShadowPopup,
          escapedToBody: !!inBodyPopup,
          styled,
          shadowOpenCount: sr.querySelectorAll('[data-state="open"]').length,
        };
      });
      result.portal = portalProbe;
      result.portal.PASS = portalProbe.inShadow && !portalProbe.escapedToBody;
      await page.screenshot({ path: `${OUT}/pass1_select_open.png`, fullPage: true });
    } else {
      result.portal.note = 'no opener element found';
    }
  } catch (e) {
    result.portal.error = e.message;
  }

  // ---- light interaction: counter / range / select change ----
  try {
    const before = result.price.text;
    const changed = await page.evaluate(() => {
      const sr = document.getElementById('host').shadowRoot;
      // try range
      const range = sr.querySelector('input[type="range"]');
      if (range) {
        const max = Number(range.max) || 100;
        const nv = String(Math.min(max, Number(range.value || 0) + (Number(range.step) || 1)));
        const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
        setter.call(range, nv);
        range.dispatchEvent(new Event('input', { bubbles: true }));
        range.dispatchEvent(new Event('change', { bubbles: true }));
        return 'range';
      }
      // try +/- counter buttons
      const plus = Array.from(sr.querySelectorAll('button')).find((b) => /\+|증가|plus/i.test(b.textContent || b.getAttribute('aria-label') || ''));
      if (plus) { plus.click(); return 'counter-plus'; }
      // try second option button
      const optBtns = sr.querySelectorAll('button');
      if (optBtns.length > 1) { optBtns[1].click(); return 'button-1'; }
      return 'none';
    });
    await page.waitForTimeout(800);
    const after = await page.evaluate(() => {
      const sr = document.getElementById('host').shadowRoot;
      const priceEl = sr.querySelector('[data-component="price-summary"], [class*="price"], [class*="Price"]');
      return priceEl ? (priceEl.textContent || '').trim().slice(0, 200) : null;
    });
    result.interaction = { action: changed, priceBefore: before, priceAfter: after, changed: before !== after };
  } catch (e) {
    result.interaction.error = e.message;
  }

} catch (e) {
  result.errors.push('FATAL: ' + e.message);
}

result.console.errors = consoleMsgs.filter((m) => m.type === 'error');
result.console.warnings = consoleMsgs.filter((m) => m.type === 'warning');
result.console.all = consoleMsgs.slice(0, 40);
result.errors.push(...pageErrors.map((e) => 'pageerror: ' + e));

await browser.close();
console.log('===SMOKE_JSON_START===');
console.log(JSON.stringify(result, null, 2));
console.log('===SMOKE_JSON_END===');
