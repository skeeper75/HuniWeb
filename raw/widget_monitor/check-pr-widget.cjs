const { chromium } = require('playwright');

// PR 책자군 + 다른 카테고리 신규 후보
const toCheck = [
  {cat:'PR', code:'PRBKYPR'}, {cat:'PR', code:'PRBKCTL'}, {cat:'PR', code:'PRBKPSN'},
  {cat:'PR', code:'PRCAXXX'}, {cat:'PR', code:'PRTTXXX'}, {cat:'PR', code:'PRIDPRT'},
  {cat:'GS', code:'GSTGMIC'}, {cat:'AC', code:'ACNTHAP'},
  // GS 카테고리 더 많은 상품
];

(async () => {
  const browser = await chromium.launch({ headless: true, args: ['--lang=ko-KR','--no-sandbox'] });
  const results = [];
  for (let i = 0; i < toCheck.length; i += 4) {
    const batch = toCheck.slice(i, i+4);
    const batchRes = await Promise.all(batch.map(async ({cat, code}) => {
      const page = await browser.newPage();
      try {
        await page.goto(`https://www.redprinting.co.kr/ko/product/item/${cat}/${code}`, {waitUntil:'load', timeout:20000});
        await page.waitForTimeout(1500);
        const hasSDK = await page.evaluate(() => !!document.querySelector('script[src*="productRedWidgetSDK"]'));
        return {cat, code, hasSDK};
      } catch(e) { return {cat, code, error: true}; }
      finally { await page.close(); }
    }));
    results.push(...batchRes);
  }
  await browser.close();
  const newW = results.filter(r=>r.hasSDK).map(r=>`${r.cat}:${r.code}`);
  const leg = results.filter(r=>!r.hasSDK && !r.error).map(r=>`${r.cat}:${r.code}`);
  console.log('새 위젯:', newW.join(', '));
  console.log('레거시:', leg.join(', '));
})();
