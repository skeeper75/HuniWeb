// N3 라이브 재현 probe — verify-gate 직접 재실측 (read-only).
// 교정된 buildModelALadder(verbatim deob L15438-15444)를 라이브 TPBLMEO pdt_add_option_info에 적용한
// PRN_CNT 래더를 라이브 get_ajax_price_vTmpl로 가격조회해 단조증가/정합을 확인.
const http = require('http');

function buildModelALadder(a) {
  const u = a.MIN_ORD_PRN_CNT, c = a.ADD_ORD_PRN_CNT, o = [];
  for (let h = 0; h < 10; h++) o.push(u + c * h);
  return o;
}

function post(body) {
  return new Promise((res, rej) => {
    const data = JSON.stringify(body);
    const req = http.request({
      host: 'localhost', port: 3001,
      path: '/rp-api/ko/product_price/get_ajax_price_vTmpl',
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) },
    }, r => { let b = ''; r.on('data', c => b += c); r.on('end', () => { try { res(JSON.parse(b)); } catch (e) { res({ _raw: b.slice(0, 250) }); } }); });
    req.on('error', rej); req.write(data); req.end();
  });
}

function mkBody(ord, pcs) {
  return { dataJson: { ORD_INFO: [ord], PCS_INFO: pcs, price_gbn: 'tmpl_price', mb_cust_cod: '10000000' } };
}

(async () => {
  const live = { MIN_ORD_PRN_CNT: 20, ADD_ORD_PRN_CNT: 10 }; // live PDT_VER_SIZE=10.00
  console.log('LIVE corrected ladder (MIN=20,ADD=10):', JSON.stringify(buildModelALadder(live)));

  // diagnostic: per-line inspection with full essential PCS
  const baseOrd = { PDT_CD: 'TPBLMEO', CUT_WDT: 80, CUT_HGH: 80, WRK_WDT: 84, WRK_HGH: 84, ORD_CNT: 20, PRN_CNT: 20, PRN_CLR_CNT: 4, MTRL_CD: 'RXWMO080', DOSU_COD: 'SID_S' };
  const fullPcs = [
    { PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' },
    { PCS_COD: 'BID_BND', PCS_DTL_COD: 'BPTOP', ATTB: '' },
    { PCS_COD: 'SUB_MTR', PCS_DTL_COD: 'SS001', ATTB: '' },
  ];
  const diag = await post(mkBody(baseOrd, fullPcs));
  console.log('\n[DIAG] full-PCS reqBody PRICE=' + (diag.result_sum && diag.result_sum.PRICE) + ' retCode=' + diag.retCode + ' msg=' + diag.msg);
  console.log('[DIAG] per-line:');
  (diag.result || []).forEach(l => console.log('   ', JSON.stringify({ PCS_CD: l.PCS_CD, PCS_DTL_CD: l.PCS_DTL_CD, PRICE: l.PRICE })));
  if (diag._raw) console.log('[DIAG] raw:', diag._raw);

  // ladder sweep with full PCS
  console.log('\n[LADDER SWEEP] PRN_CNT ∈ ladder, full PCS:');
  for (const prn of [20, 30, 50]) {
    const ord = Object.assign({}, baseOrd, { ORD_CNT: prn, PRN_CNT: prn });
    const r = await post(mkBody(ord, fullPcs));
    console.log('  PRN_CNT/ORD_CNT=' + prn + ' => PRICE=' + (r.result_sum && r.result_sum.PRICE) + ' retCode=' + r.retCode);
    await new Promise(x => setTimeout(x, 300));
  }
})();
