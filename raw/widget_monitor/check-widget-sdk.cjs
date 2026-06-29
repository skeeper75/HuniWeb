const { chromium } = require('playwright');

const samples = [
  {cat:'BC', code:'BCSPDFT'}, {cat:'TP', code:'TPBCDFT'}, {cat:'GS', code:'GSTGMIC'},
  {cat:'PR', code:'PRLFXXX'}, {cat:'LF', code:'LFXXXXX'}, {cat:'PH', code:'PHPTPRM'},
  {cat:'ST', code:'STDRCAD'}, {cat:'FB', code:'FBDCMOS'}, {cat:'BT', code:'BTPNXXX'},
  {cat:'OT', code:'OTPOCLP'}, {cat:'ET', code:'WBXXXXX'}, {cat:'PV', code:'PVCAPRM'},
  {cat:'AC', code:'ACNTHAP'}, {cat:'EN', code:'ENDFBIG'}, {cat:'PM', code:'PMPOBOK'},
  {cat:'FS', code:'FSSHCOS'}, {cat:'ME', code:'MEPKDFT'}, {cat:'PD', code:'PDCHSTL'},
  {cat:'CL', code:'CLAPDFT'}, {cat:'AI', code:'AIECMNP'}, {cat:'NC', code:'NCDFDFT'},
  {cat:'HL', code:'HLDFSUM'}, {cat:'SK', code:'SKTHDFT'}, {cat:'BN', code:'BNSTPED'},
  {cat:'AH', code:'AHDFXXX'}, {cat:'PO', code:'POMXHAP'}
];

(async () => {
  const browser = await chromium.launch({ headless: true, args: ['--lang=ko-KR','--no-sandbox'] });
  const results = [];

  // 5개씩 병렬 처리
  for (let i = 0; i < samples.length; i += 5) {
    const batch = samples.slice(i, i + 5);
    const batch_results = await Promise.all(batch.map(async ({cat, code}) => {
      const page = await browser.newPage();
      try {
        await page.goto(`https://www.redprinting.co.kr/ko/product/item/${cat}/${code}`, {waitUntil:'load', timeout:20000});
        await page.waitForTimeout(2000);
        const {hasSDK, hasShadow, mountId} = await page.evaluate(() => ({
          hasSDK: !!document.querySelector('script[src*="productRedWidgetSDK"]'),
          hasShadow: document.querySelectorAll('*').length > 0 && [...document.querySelectorAll('*')].some(el => el.shadowRoot),
          mountId: document.querySelector('[id*="redWidget"]')?.id || null
        }));
        return {cat, code, hasSDK, hasShadow, mountId};
      } catch(e) {
        return {cat, code, error: e.message.slice(0,50)};
      } finally {
        await page.close();
      }
    }));
    results.push(...batch_results);
    process.stdout.write('.');
  }

  await browser.close();
  console.log('\n\n=== 결과 ===');
  const newWidget = results.filter(r => r.hasSDK);
  const legacy = results.filter(r => !r.hasSDK && !r.error);
  const errors = results.filter(r => r.error);
  console.log(`새 위젯 (${newWidget.length}개):`, newWidget.map(r=>`${r.cat}:${r.code}`).join(', '));
  console.log(`레거시 (${legacy.length}개):`, legacy.map(r=>`${r.cat}:${r.code}`).join(', '));
  if(errors.length) console.log(`에러 (${errors.length}개):`, errors.map(r=>`${r.cat}:${r.error}`).join(', '));
})();
