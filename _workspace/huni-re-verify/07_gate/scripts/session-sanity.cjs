// 세션 신선도 sanity — 알려진 baseline로 PRICE>0 확인 (read-only).
const http = require('http');
function post(path, body) {
  return new Promise((res, rej) => {
    const data = JSON.stringify(body);
    const req = http.request({ host: 'localhost', port: 3001, path, method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } },
      r => { let b = ''; r.on('data', c => b += c); r.on('end', () => { try { res(JSON.parse(b)); } catch (e) { res({ _raw: b.slice(0, 250) }); } }); });
    req.on('error', rej); req.write(data); req.end();
  });
}
function get(path) {
  return new Promise((res, rej) => {
    http.get({ host: 'localhost', port: 3001, path }, r => { let b = ''; r.on('data', c => b += c); r.on('end', () => { try { res(JSON.parse(b)); } catch (e) { res({ _raw: b.slice(0, 250) }); } }); }).on('error', rej);
  });
}
(async () => {
  // GSTGMIC tiered baseline known from capture-log: 1->7000, 5->33400, 10->66200
  const info = await get('/rp-api/ko/product/get_digital_product_info?pdt_cod=GSTGMIC');
  const pd = info.result && info.result.product_data;
  const mtrl = pd && pd.pdt_mtrl_info && pd.pdt_mtrl_info[0];
  const size = pd && pd.pdt_size_info && pd.pdt_size_info.find(s => s.DFT_YN === 'Y') || (pd && pd.pdt_size_info && pd.pdt_size_info[0]);
  const dosu = pd && pd.pdt_dosu_info && pd.pdt_dosu_info[0];
  const gbn = info.result.product_option.option.price_gbn;
  console.log('GSTGMIC price_gbn=' + gbn + ' mtrl=' + (mtrl && mtrl.MTRL_CD) + ' size=' + (size && size.DIV_NM) + ' dosu=' + (dosu && dosu.COD) + ':' + (dosu && dosu.PRN_CLR_CNT));
  for (const prn of [1, 5, 10]) {
    const ord = { PDT_CD: 'GSTGMIC', CUT_WDT: Number(size.CUT_WDT), CUT_HGH: Number(size.CUT_HGH), WRK_WDT: Number(size.WRK_WDT), WRK_HGH: Number(size.WRK_HGH), ORD_CNT: 1, PRN_CNT: prn, PRN_CLR_CNT: dosu.PRN_CLR_CNT, MTRL_CD: mtrl.MTRL_CD, DOSU_COD: dosu.COD };
    const r = await post('/rp-api/ko/product_price/get_ajax_price_vTmpl', { dataJson: { ORD_INFO: [ord], PCS_INFO: [], price_gbn: gbn, mb_cust_cod: '10000000' } });
    console.log('  PRN_CNT=' + prn + ' => PRICE=' + (r.result_sum && r.result_sum.PRICE) + ' retCode=' + r.retCode);
    await new Promise(x => setTimeout(x, 250));
  }
})();
