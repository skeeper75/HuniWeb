const { chromium } = require('playwright');

// PRBKY*, PRBKO*, PRBKORD 등 책자 전체 + GS/AC 더 확인
const bookCodes = [
  'PRBKYPR','PRBKYCO','PRBKYRN','PRBKYST','PRBKYSL','PRBKYPB','PRBKYCB','PRBKYRB',
  'PRBKORD','PRBKOCD','PRBKOPR','PRBKOCO','PRBKORN','PRBKOST','PRBKOSL','PRBKOPB','PRBKOCB','PRBKORB'
].map(c=>({cat:'PR',code:c}));

(async () => {
  const browser = await chromium.launch({ headless: true, args: ['--lang=ko-KR','--no-sandbox'] });
  const newW = [], leg = [];
  for (let i = 0; i < bookCodes.length; i += 6) {
    const batch = bookCodes.slice(i, i+6);
    const res = await Promise.all(batch.map(async ({cat, code}) => {
      const page = await browser.newPage();
      try {
        await page.goto(`https://www.redprinting.co.kr/ko/product/item/${cat}/${code}`, {waitUntil:'load', timeout:20000});
        await page.waitForTimeout(1000);
        const hasSDK = await page.evaluate(() => !!document.querySelector('script[src*="productRedWidgetSDK"]'));
        return {code, hasSDK};
      } catch(e) { return {code, error:true}; }
      finally { await page.close(); }
    }));
    res.forEach(r => r.hasSDK ? newW.push(r.code) : (!r.error && leg.push(r.code)));
    process.stdout.write('.');
  }
  await browser.close();
  console.log('\n새 위젯 책자:', newW.join(', '));
  console.log('레거시 책자:', leg.join(', '));
})();
