/**
 * S5-M1 수량구간 할인 스윕 — 캡처한 base reqBody를 읽어 ORD_CNT를 1..1000으로 바꿔
 * localhost:3001/rp-api(쿠키+token 주입 프록시)로 동일 엔드포인트에 POST하고
 * result_sum.PRICE / ORG_PRICE / 개당단가 / 할인율 추이를 표로 출력한다. Read-only.
 *
 * 사용: node s5-tiered-sweep.cjs <captureFile> <priceCallIndex> [PRN_CNT]
 *   captureFile: 05_qa/captures/s3_rp_<CODE>.json
 *   priceCallIndex: 유효 reqBody가 있는 priceCalls 인덱스
 */
const http = require('http');
const fs = require('fs');
const path = require('path');

const QTYS = [1, 2, 5, 10, 30, 50, 100, 300, 1000];
const capFile = process.argv[2];
const callIdx = parseInt(process.argv[3] || '0', 10);
const forcePrn = process.argv[4] ? parseInt(process.argv[4], 10) : null;

const cap = JSON.parse(fs.readFileSync(capFile, 'utf8'));
const base = JSON.parse(cap.priceCalls[callIdx].reqBody);
const code = base.dataJson.ORD_INFO[0].PDT_CD;
const gbn = base.dataJson.price_gbn;

function post(body) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify(body);
    const req = http.request({
      host: 'localhost', port: 3001,
      path: '/rp-api/ko/product_price/get_ajax_price_vTmpl',
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) },
    }, res => {
      let b = ''; res.on('data', c => b += c);
      res.on('end', () => { try { resolve(JSON.parse(b)); } catch (e) { resolve({ _raw: b.slice(0, 200) }); } });
    });
    req.on('error', reject); req.write(data); req.end();
  });
}

(async () => {
  const rows = [];
  for (const q of QTYS) {
    const body = JSON.parse(JSON.stringify(base));
    const o = body.dataJson.ORD_INFO[0];
    o.ORD_CNT = q;
    o.PRN_CNT = forcePrn != null ? forcePrn : (o.PRN_CNT || 1);
    const r = await post(body);
    const rs = (r && r.result_sum) || {};
    const PRICE = rs.PRICE, ORG = rs.ORG_PRICE;
    const unit = PRICE != null ? PRICE / q : null;
    const disc = (PRICE != null && ORG) ? (1 - PRICE / ORG) : null;
    rows.push({ ORD_CNT: q, PRICE, ORG_PRICE: ORG, unit: unit != null ? Math.round(unit * 100) / 100 : null, discPct: disc != null ? Math.round(disc * 1000) / 10 : null });
    await new Promise(r => setTimeout(r, 200));
  }
  console.log('SKU=' + code + ' price_gbn=' + gbn + ' PRN_CNT=' + (forcePrn != null ? forcePrn : (base.dataJson.ORD_INFO[0].PRN_CNT || 1)));
  console.log('ORD_CNT\tPRICE\tORG_PRICE\tunit\tdisc%');
  rows.forEach(x => console.log([x.ORD_CNT, x.PRICE, x.ORG_PRICE, x.unit, x.discPct].join('\t')));
  // detect curve
  const units = rows.filter(r => r.unit != null).map(r => r.unit);
  const flatUnit = units.length && units.every(u => Math.abs(u - units[0]) < 0.5);
  const anyDisc = rows.some(r => r.discPct != null && r.discPct > 0.5);
  console.log('FLAT_UNIT=' + flatUnit + ' ANY_DISCOUNT=' + anyDisc);
  const outDir = path.resolve(__dirname, '../../../_workspace/huni-widget/05_qa/captures');
  fs.writeFileSync(path.join(outDir, 'sweep_' + code + '.json'), JSON.stringify({ code, price_gbn: gbn, rows, flatUnit, anyDisc, capturedAt: new Date().toISOString() }, null, 2));
})();
