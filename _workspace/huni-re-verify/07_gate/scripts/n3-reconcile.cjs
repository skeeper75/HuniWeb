// N3 값 정합 reconcile — 538000/1140000/3010000 의 reqBody 조건 역추적.
// 가설: prior gate가 ORD_CNT(주문건수) 곱셈 또는 PACK 단위를 썼다. PRN_CNT vs ORD_CNT 분리 확인.
const http = require('http');
function post(body) {
  return new Promise((res, rej) => {
    const data = JSON.stringify(body);
    const req = http.request({ host: 'localhost', port: 3001, path: '/rp-api/ko/product_price/get_ajax_price_vTmpl', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } },
      r => { let b = ''; r.on('data', c => b += c); r.on('end', () => { try { res(JSON.parse(b)); } catch (e) { res({ _raw: b.slice(0, 200) }); } }); });
    req.on('error', rej); req.write(data); req.end();
  });
}
function mk(o) {
  const ord = Object.assign({ PDT_CD: 'TPBLMEO', CUT_WDT: 80, CUT_HGH: 80, WRK_WDT: 84, WRK_HGH: 84, PRN_CLR_CNT: 4, MTRL_CD: 'RXWMO080', DOSU_COD: 'SID_S' }, o);
  return { dataJson: { ORD_INFO: [ord], PCS_INFO: [{ PCS_COD: 'PRT_SID', PCS_DTL_COD: 'PT001', ATTB: '' }], price_gbn: 'tmpl_price', mb_cust_cod: '10000000' } };
}
(async () => {
  console.log('=== ORD_CNT vs PRN_CNT 분리 (PRN_CNT=20 fixed, ORD_CNT 변동) ===');
  for (const oc of [1, 20, 100]) {
    const r = await post(mk({ ORD_CNT: oc, PRN_CNT: 20 }));
    console.log('ORD_CNT=' + oc + ' PRN_CNT=20 => PRICE=' + (r.result_sum && r.result_sum.PRICE));
    await new Promise(x => setTimeout(x, 300));
  }
  console.log('\n=== PRN_CNT=20 라더 단계별 (ORD_CNT=1) — 단조성/PRICE>0 핵심 검증 ===');
  let prev = null, monotone = true;
  for (const prn of [20, 30, 40, 50, 110]) {
    const r = await post(mk({ ORD_CNT: 1, PRN_CNT: prn }));
    const p = r.result_sum && r.result_sum.PRICE;
    if (prev != null && p < prev) monotone = false;
    console.log('PRN_CNT=' + prn + ' => PRICE=' + p + (p > 0 ? ' [>0 OK]' : ' [ZERO]'));
    prev = p;
    await new Promise(x => setTimeout(x, 300));
  }
  console.log('MONOTONE_NONDECREASING=' + monotone);
})();
