// N3 라이브 재현 probe v2 — PRT_SID/PT001 포함 (538000 line은 PRT_SID/PT001에서 발생, body-log 학습).
const http = require('http');
function buildModelALadder(a) { const u = a.MIN_ORD_PRN_CNT, c = a.ADD_ORD_PRN_CNT, o = []; for (let h = 0; h < 10; h++) o.push(u + c * h); return o; }
function post(body) {
  return new Promise((res, rej) => {
    const data = JSON.stringify(body);
    const req = http.request({ host: 'localhost', port: 3001, path: '/rp-api/ko/product_price/get_ajax_price_vTmpl', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } },
      r => { let b = ''; r.on('data', c => b += c); r.on('end', () => { try { res(JSON.parse(b)); } catch (e) { res({ _raw: b.slice(0, 250) }); } }); });
    req.on('error', rej); req.write(data); req.end();
  });
}
(async () => {
  const live = { MIN_ORD_PRN_CNT: 20, ADD_ORD_PRN_CNT: 10 };
  const ladder = buildModelALadder(live);
  console.log('LIVE corrected ladder (MIN=20,ADD=10):', JSON.stringify(ladder));
  console.log('spec baseline qty 20/30/50 = ladder h=0/1/3\n');
  const pcs = [{ PCS_COD: 'PRT_SID', PCS_DTL_COD: 'PT001', ATTB: '' }];
  for (const prn of [20, 30, 50]) {
    const ord = { PDT_CD: 'TPBLMEO', CUT_WDT: 80, CUT_HGH: 80, WRK_WDT: 84, WRK_HGH: 84, ORD_CNT: 1, PRN_CNT: prn, PRN_CLR_CNT: 4, MTRL_CD: 'RXWMO080', DOSU_COD: 'SID_S' };
    const r = await post({ dataJson: { ORD_INFO: [ord], PCS_INFO: pcs, price_gbn: 'tmpl_price', mb_cust_cod: '10000000' } });
    const lines = (r.result || []).map(l => l.PCS_CD + '/' + l.PCS_DTL_CD + '=' + l.PRICE).join(', ');
    console.log('PRN_CNT=' + prn + ' (h=' + (prn === 20 ? 0 : prn === 30 ? 1 : 3) + ') => PRICE=' + (r.result_sum && r.result_sum.PRICE) + ' retCode=' + r.retCode + ' | lines: ' + lines);
    await new Promise(x => setTimeout(x, 350));
  }
})();
