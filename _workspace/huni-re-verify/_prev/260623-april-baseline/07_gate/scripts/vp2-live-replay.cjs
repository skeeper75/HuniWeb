#!/usr/bin/env node
/**
 * vp2-live-replay.cjs — Phase 5 verify-gate 독립 라이브 재실측 (VP-2 strict 재생)
 * [HARD] 골든 미수정(별도 산출). 읽기전용 get_ajax_price_vTmpl only(주문/결제/폼submit 0).
 * 능동 변형 reqBody(string ATTB·잉여필드) POST 금지 — 정상 shape 만 라이브 재요청.
 * 목적: 인스펙터 VP-2 PASS 를 verify-gate 가 직접 재현(생성≠검증). 골든 result_sum.PRICE 대조.
 */
const http = require('http');
const PROXY = 'http://localhost:3001/rp-api/ko/product_price/get_ajax_price_vTmpl';

function post(dataJson) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({ dataJson });
    const req = http.request(PROXY, { method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) }, timeout: 30000 }, (res) => {
      let raw = ''; res.on('data', (d) => (raw += d));
      res.on('end', () => { try { resolve({ status: res.statusCode, json: JSON.parse(raw) }); } catch (e) { resolve({ status: res.statusCode, json: null, raw: raw.slice(0, 200) }); } });
    });
    req.on('error', reject); req.on('timeout', () => { req.destroy(); reject(new Error('timeout')); });
    req.write(body); req.end();
  });
}

// 대표 케이스 — 골든과 동일 옵션(정상 shape, ATTB 골든 타입대로 number/string 유지). 골든 PRICE 권위와 대조.
const CASES = [
  // [label, dataJson, expectedPRICE(골든 권위)]
  ['G-RP/AIPPCUT base (세션 sanity)', { ORD_INFO: [{ PDT_CD: 'AIPPCUT', MTRL_CD: 'PXPLP001', CUT_WDT: 300, CUT_HGH: 340, WRK_WDT: 300, WRK_HGH: 340, PRN_CNT: 1, ORD_CNT: 1, DOSU_COD: 'SID_X', PRN_CLR_CNT: 0 }], PCS_INFO: [{ PCS_COD: 'SUB_MTR', PCS_DTL_COD: 'EC001', ATTB: 1, ATTB_2: '', ATTB_3: '' }, { PCS_COD: 'CUT_ZUN', PCS_DTL_COD: 'ZDFRM', ATTB: '' }, { PCS_COD: 'BON_SHT', PCS_DTL_COD: 'SHECO', ATTB: '' }], price_gbn: 'real_price', mb_cust_cod: '10000000' }, 3300],
  ['G-TD/GSTGMIC PRN=2', { ORD_INFO: [{ PDT_CD: 'GSTGMIC', MTRL_CD: 'RXBVW300', CUT_WDT: 351, CUT_HGH: 291, WRK_WDT: 355, WRK_HGH: 295, PRN_CNT: 2, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }], PCS_INFO: [{ PCS_COD: 'WRK_MTR', PCS_DTL_COD: 'TG003', ATTB: 2, ATTB_2: '', ATTB_3: '' }, { PCS_COD: 'COT_DFT', PCS_DTL_COD: 'TCGLS', ATTB: '' }, { PCS_COD: 'PDT_WRK', PCS_DTL_COD: 'PKT01', ATTB: '' }, { PCS_COD: 'PAK_POL', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'THO_CUT', PCS_DTL_COD: 'TG003', ATTB: '' }], price_gbn: 'tiered_price', mb_cust_cod: '10000000' }, 13600],
  ['G-TD/GSTGMIC PRN=100', { ORD_INFO: [{ PDT_CD: 'GSTGMIC', MTRL_CD: 'RXBVW300', CUT_WDT: 351, CUT_HGH: 291, WRK_WDT: 355, WRK_HGH: 295, PRN_CNT: 100, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }], PCS_INFO: [{ PCS_COD: 'WRK_MTR', PCS_DTL_COD: 'TG003', ATTB: 100, ATTB_2: '', ATTB_3: '' }, { PCS_COD: 'COT_DFT', PCS_DTL_COD: 'TCGLS', ATTB: '' }, { PCS_COD: 'PDT_WRK', PCS_DTL_COD: 'PKT01', ATTB: '' }, { PCS_COD: 'PAK_POL', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'THO_CUT', PCS_DTL_COD: 'TG003', ATTB: '' }], price_gbn: 'tiered_price', mb_cust_cod: '10000000' }, 631800],
  ['G-ATTB/GSNTSPR ORD1 PRN1', mkGsntspr('RIN_BLK', '4', 1, 1), 6300],
  ['G-ATTB/GSNTSPR ORD10 PRN1', mkGsntspr('RIN_BLK', '4', 10, 1), 63000],
  // ATTB 불변 재실측: 링색 변경해도 가격 불변(6300) 이어야 함(D-L1 독립 재현)
  ['G-ATTB/GSNTSPR RIN_GLD(ATTB불변검증)', mkGsntspr('RIN_GLD', '4', 1, 1), 6300],
  ['G-BK/PRBKYPR PAGE24', mkBook(148, 210, 24, 4, 1), 6100],
  ['G-BK/PRBKYPR PAGE100', mkBook(148, 210, 100, 4, 4), 8300],
];

function mkGsntspr(ringColor, rou, ord, prn) {
  return { ORD_INFO: [{ PDT_CD: 'GSNTSPR', MTRL_CD: 'RIBVW350', CUT_WDT: 182, CUT_HGH: 257, WRK_WDT: 187, WRK_HGH: 262, PRN_CNT: prn, ORD_CNT: ord, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }], PCS_INFO: [{ PCS_COD: 'COT_DFT', PCS_DTL_COD: 'TCGLS', ATTB: '' }, { PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'INN_DFT', PCS_DTL_COD: 'INNON', ATTB: 1, ATTB_2: '', ATTB_3: '' }, { PCS_COD: 'RIN_DFT', PCS_DTL_COD: 'BPLFT', ATTB: ringColor }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXLT', ATTB: String(rou) }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXRT', ATTB: String(rou) }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXLB', ATTB: String(rou) }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXRB', ATTB: String(rou) }], price_gbn: 'tmpl_price', mb_cust_cod: '10000000' };
}
function mkBook(w, h, page, cvrClr, innClr) {
  return { ORD_INFO: [{ PDT_CD: 'PRBKYPR', CUT_WDT: w, CUT_HGH: h, WRK_WDT: w, WRK_HGH: h, PRN_CNT: 1, ORD_CNT: 1, PAGE_CNT: page, CVR_CLR_CNT: cvrClr, INN_CLR_CNT: innClr, CVR_MTRL_CD: 'RXART300', INN_MTRL_CD: 'RXYWM080' }], PCS_INFO: [], price_gbn: 'book2025_price', mb_cust_cod: '10000000' };
}

(async () => {
  let pass = 0, fail = 0;
  for (const [label, dataJson, expected] of CASES) {
    try {
      const r = await post(dataJson);
      const live = r.json && r.json.result_sum ? r.json.result_sum.PRICE : 'NULL';
      const ok = live === expected;
      console.log(`${ok ? 'PASS' : 'FAIL'} | ${label} | live=${live} expected(golden)=${expected} | retCode=${r.json && r.json.retCode}`);
      ok ? pass++ : fail++;
    } catch (e) {
      console.log(`ERROR | ${label} | ${e.message}`); fail++;
    }
  }
  console.log(`\nVP-2 라이브 재실측: ${pass} PASS / ${fail} FAIL (${CASES.length} cases)`);
})();
