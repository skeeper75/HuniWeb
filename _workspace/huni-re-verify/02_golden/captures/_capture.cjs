#!/usr/bin/env node
/**
 * hrev-golden-recorder — 가격 골든 캡처기 (Phase 2)
 * 라이브 RedPrinting을 기준 오라클로, get_ajax_price_vTmpl 가격조회만 record.
 * 읽기전용(주문/결제/폼submit 0). 비밀(쿠키/JWT)은 server.js가 서버측 주입 — reqBody에 미포함.
 *
 * 사용: node _capture.cjs               (전 시나리오)
 *       node _capture.cjs G-ATTB        (특정 시나리오)
 *
 * 산출: 02_golden/captures/<file>.json  (시나리오당 1 파일 — 누적 금지)
 *   각 파일: scenario, productCode, price_gbn, capturedAt, sessionFresh,
 *            calls[]{label, reqBody(object), result_sum, perLine[], priceLog}, oracleSanity
 */
const fs = require('fs');
const path = require('path');
const http = require('http');

const PROXY = 'http://localhost:3001/rp-api/ko/product_price/get_ajax_price_vTmpl';
const OUT = __dirname;

// mb_cust_cod 마스킹: 로그인 고객코드(세션파생, 8자리 비-10000000)는 [REDACTED]. 익명기본 10000000은 공개값 유지.
function maskCustCode(reqObj) {
  try {
    const c = reqObj?.dataJson?.mb_cust_cod;
    if (c && c !== '10000000' && c !== '') reqObj.dataJson.mb_cust_cod = '[REDACTED-session-cust]';
  } catch {}
  return reqObj;
}

function post(dataJson) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({ dataJson });
    const req = http.request(PROXY, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
      timeout: 30000,
    }, (res) => {
      let raw = '';
      res.on('data', (d) => (raw += d));
      res.on('end', () => {
        try { resolve({ status: res.statusCode, json: JSON.parse(raw) }); }
        catch (e) { resolve({ status: res.statusCode, json: null, raw: raw.slice(0, 300) }); }
      });
    });
    req.on('error', reject);
    req.on('timeout', () => { req.destroy(); reject(new Error('timeout')); });
    req.write(body);
    req.end();
  });
}

// 한 호출을 record: reqBody(masked) + result_sum + per-line(PCS_CD/PRICE) + priceLog
async function record(label, dataJson) {
  const r = await post(dataJson);
  const j = r.json || {};
  const rs = j.result_sum || null;
  const perLine = Array.isArray(j.result)
    ? j.result.map((x) => ({ PCS_CD: x.PCS_CD, PRICE: x.PRICE }))
    : [];
  const priceLog = Array.isArray(j.result) && j.result[0] ? j.result[0].PRICE_LOG : undefined;
  // mask cust code in stored reqBody
  const reqStored = maskCustCode(JSON.parse(JSON.stringify({ dataJson })));
  const out = {
    label,
    status: r.status,
    retCode: j.retCode,
    reqBody: reqStored,
    result_sum: rs,
    perLine,
    priceLog,
  };
  if (j.book_info) out.book_info = j.book_info; // 책자 배송비(book2025 전용)
  return out;
}

function save(file, obj) {
  const fp = path.join(OUT, file);
  fs.writeFileSync(fp, JSON.stringify(obj, null, 2));
  console.log(`  saved → ${file}`);
}

// ── 시나리오 정의 ────────────────────────────────────────
const SCENARIOS = {
  // G-RP SizeMatrix2D / real_price (AIPPCUT 에코백) — golden baseline PRICE=3300
  'G-RP': {
    file: 'golden_AIPPCUT_real.json', productCode: 'AIPPCUT', price_gbn: 'real_price',
    note: 'SizeMatrix2D real_price baseline. SUB_MTR ATTB=1 고정. result_sum.PRICE=3300 검증 베이스라인.',
    calls: [
      ['base ORD1 PRN1', { ORD_INFO: [{ PDT_CD: 'AIPPCUT', MTRL_CD: 'PXPLP001', CUT_WDT: 300, CUT_HGH: 340, WRK_WDT: 300, WRK_HGH: 340, PRN_CNT: 1, ORD_CNT: 1, DOSU_COD: 'SID_X', PRN_CLR_CNT: 0 }], PCS_INFO: [{ PCS_COD: 'SUB_MTR', PCS_DTL_COD: 'EC001', ATTB: 1, ATTB_2: '', ATTB_3: '' }, { PCS_COD: 'CUT_ZUN', PCS_DTL_COD: 'ZDFRM', ATTB: '' }, { PCS_COD: 'BON_SHT', PCS_DTL_COD: 'SHECO', ATTB: '' }], price_gbn: 'real_price', mb_cust_cod: '10000000' }],
      ['mtrl variant EC002 (차등)', { ORD_INFO: [{ PDT_CD: 'AIPPCUT', MTRL_CD: 'PXPLP001', CUT_WDT: 300, CUT_HGH: 340, WRK_WDT: 300, WRK_HGH: 340, PRN_CNT: 1, ORD_CNT: 1, DOSU_COD: 'SID_X', PRN_CLR_CNT: 0 }], PCS_INFO: [{ PCS_COD: 'SUB_MTR', PCS_DTL_COD: 'EC002', ATTB: 1, ATTB_2: '', ATTB_3: '' }, { PCS_COD: 'CUT_ZUN', PCS_DTL_COD: 'ZDFRM', ATTB: '' }, { PCS_COD: 'BON_SHT', PCS_DTL_COD: 'SHECO', ATTB: '' }], price_gbn: 'real_price', mb_cust_cod: '10000000' }],
    ],
  },

  // G-FU FixedUnit / vTmpl_price (STPADPN 스티커) — PRICE=4000
  'G-FU': {
    file: 'golden_STPADPN_fixed.json', productCode: 'STPADPN', price_gbn: 'vTmpl_price',
    note: 'FixedUnit vTmpl_price. A4(140x200) PRICE=4000, A3급(210x297) PRICE=8000. ORD_CNT/PRN_CNT 필수(부재→0).',
    calls: [
      ['A4 ORD1 PRN1', { ORD_INFO: [{ PDT_CD: 'STPADPN', MTRL_CD: 'PXPUF003', CUT_WDT: 140, CUT_HGH: 200, WRK_WDT: 144, WRK_HGH: 204, PRN_CNT: 1, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }], PCS_INFO: [{ PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'PRT_WHT', PCS_DTL_COD: 'DFXXX', ATTB: '' }], price_gbn: 'vTmpl_price', mb_cust_cod: '10000000' }],
      ['bigger size 210x297 (차등)', { ORD_INFO: [{ PDT_CD: 'STPADPN', MTRL_CD: 'PXPUF003', CUT_WDT: 210, CUT_HGH: 297, WRK_WDT: 214, WRK_HGH: 301, PRN_CNT: 1, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }], PCS_INFO: [{ PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'PRT_WHT', PCS_DTL_COD: 'DFXXX', ATTB: '' }], price_gbn: 'vTmpl_price', mb_cust_cod: '10000000' }],
      ['incomplete (ORD_CNT/PRN_CNT 부재) — 결함재현가드', { ORD_INFO: [{ PDT_CD: 'STPADPN', MTRL_CD: 'PXPUF003', CUT_WDT: 140, CUT_HGH: 200, WRK_WDT: 144, WRK_HGH: 204, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }], PCS_INFO: [{ PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'PRT_WHT', PCS_DTL_COD: 'DFXXX', ATTB: '' }], price_gbn: 'vTmpl_price', mb_cust_cod: '10000000' }],
    ],
  },

  // G-TD TieredDiscount / tiered_price (GSTGMIC 네임택) — PRN_CNT 스윕 단조증가
  'G-TD': {
    file: 'golden_GSTGMIC_tiered.json', productCode: 'GSTGMIC', price_gbn: 'tiered_price',
    note: 'TieredDiscount tiered_price. 삼각 마이크 네임택L. PRN_CNT 스윕 → result_sum.PRICE 단조증가(메타모픽). WRK_MTR ATTB=PRN_CNT 추종(다형). per-line=PRT_DFT 외 0.',
    calls: [
      ['PRN_CNT=1', mkGstgmic(1)],
      ['PRN_CNT=2', mkGstgmic(2)],
      ['PRN_CNT=5', mkGstgmic(5)],
      ['PRN_CNT=10', mkGstgmic(10)],
      ['PRN_CNT=30', mkGstgmic(30)],
      ['PRN_CNT=100', mkGstgmic(100)],
    ],
  },

  // G-TM tmpl_price (GSPUFBC 파우치) — complete vs incomplete 대조쌍 + qty sweep
  'G-TM': {
    file: 'golden_GSPUFBC_tmpl.json', productCode: 'GSPUFBC', price_gbn: 'tmpl_price',
    note: 'tmpl_price. 11in세로 230x288. complete(ORD_CNT100·PRN_CNT1)=2,850,000 / incomplete(부재)=0(결함재현). ORD_CNT 선형(할인0).',
    calls: [
      ['complete ORD100 PRN1', mkPouch(100, 1, true)],
      ['ORD_CNT=1 (단가확인)', mkPouch(1, 1, true)],
      ['ORD_CNT=10 (선형)', mkPouch(10, 1, true)],
      ['incomplete (ORD/PRN 부재) — 결함재현가드', mkPouch(null, null, false)],
    ],
  },

  // G-BK PriceTable3D / book2025_price (PRBKYPR 무선책자) — 표지/내지 분리필드 + PAGE_CNT 메타모픽
  'G-BK': {
    file: 'golden_PRBKYPR_book.json', productCode: 'PRBKYPR', price_gbn: 'book2025_price',
    note: 'PriceTable3D book2025_price. 표지/내지 분리(CVR_/INN_CLR_CNT·CVR/INN_MTRL_CD)+PAGE_CNT. PAGE_CNT↑⇒PRICE↑ 메타모픽. book_info.DLVR_AMT(배송비) 책자 전용. reqBody shape은 라이브 응답으로 검증(PRICE≠0).',
    calls: [
      ['A5 PAGE24 INN_CLR1', mkBook(148, 210, 24, 4, 1)],
      ['A5 PAGE48 (페이지↑ 차등)', mkBook(148, 210, 48, 4, 1)],
      ['A5 PAGE100 INN_CLR4 (차등)', mkBook(148, 210, 100, 4, 4)],
    ],
  },

  // ★G-ATTB 갭검증: GSNTSPR(RIN_DFT 링색 + ROU_DFT 반경 ATTB) qty 스윕 + ATTB 다값 차등
  'G-ATTB': {
    file: 'golden_GSNTSPR_attb.json', productCode: 'GSNTSPR', price_gbn: 'tmpl_price',
    note: '★D-L1 ATTB 단가영향 입증. (a) RIN_DFT 링색 ATTB(BLK/WHT/GLD/SIL)·ROU_DFT 반경 ATTB(0/4/8) 차등 (b) ORD_CNT/PRN_CNT qty 스윕. ATTB는 가격 불변·가격은 ORD_CNT/PRN_CNT가 운반 — 이 차등이 qty=1 단일캡처의 ORD_CNT/상수/material-qty 모호성을 해소(crossverify-round2 D-1).',
    calls: [
      // qty 스윕 (ATTB 고정 RIN_BLK/rou4) — PRICE는 qty에 비례
      ['ATTB고정 ORD1 PRN1', mkGsntspr('RIN_BLK', '4', 1, 1)],
      ['ATTB고정 ORD1 PRN5 (PRN↑)', mkGsntspr('RIN_BLK', '4', 1, 5)],
      ['ATTB고정 ORD5 PRN1 (ORD↑)', mkGsntspr('RIN_BLK', '4', 5, 1)],
      ['ATTB고정 ORD10 PRN1', mkGsntspr('RIN_BLK', '4', 10, 1)],
      // ATTB 차등 (qty 고정 ORD1 PRN1) — PRICE는 ATTB에 불변
      ['링색 RIN_WHT (ATTB차등)', mkGsntspr('RIN_WHT', '4', 1, 1)],
      ['링색 RIN_GLD (ATTB차등)', mkGsntspr('RIN_GLD', '4', 1, 1)],
      ['링색 RIN_SIL (ATTB차등)', mkGsntspr('RIN_SIL', '4', 1, 1)],
      ['반경 rou8 (ATTB차등)', mkGsntspr('RIN_BLK', '8', 1, 1)],
      ['반경 rou0 (ATTB차등)', mkGsntspr('RIN_BLK', '0', 1, 1)],
    ],
  },
};

// PRBKYPR book2025: 표지/내지 분리 + PAGE_CNT
function mkBook(w, h, page, cvrClr, innClr) {
  return {
    ORD_INFO: [{ PDT_CD: 'PRBKYPR', CUT_WDT: w, CUT_HGH: h, WRK_WDT: w, WRK_HGH: h, PRN_CNT: 1, ORD_CNT: 1, PAGE_CNT: page, CVR_CLR_CNT: cvrClr, INN_CLR_CNT: innClr, CVR_MTRL_CD: 'RXART300', INN_MTRL_CD: 'RXYWM080' }],
    PCS_INFO: [],
    price_gbn: 'book2025_price', mb_cust_cod: '10000000',
  };
}

// GSTGMIC tiered: PRN_CNT 스윕. WRK_MTR ATTB=PRN_CNT 추종(라이브 실측 패턴 재현).
function mkGstgmic(prn) {
  return {
    ORD_INFO: [{ PDT_CD: 'GSTGMIC', MTRL_CD: 'RXBVW300', CUT_WDT: 351, CUT_HGH: 291, WRK_WDT: 355, WRK_HGH: 295, PRN_CNT: prn, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }],
    PCS_INFO: [
      { PCS_COD: 'WRK_MTR', PCS_DTL_COD: 'TG003', ATTB: prn, ATTB_2: '', ATTB_3: '' },
      { PCS_COD: 'COT_DFT', PCS_DTL_COD: 'TCGLS', ATTB: '' },
      { PCS_COD: 'PDT_WRK', PCS_DTL_COD: 'PKT01', ATTB: '' },
      { PCS_COD: 'PAK_POL', PCS_DTL_COD: 'DFXXX', ATTB: '' },
      { PCS_COD: 'THO_CUT', PCS_DTL_COD: 'TG003', ATTB: '' },
    ],
    price_gbn: 'tiered_price', mb_cust_cod: '10000000',
  };
}

// GSPUFBC tmpl: complete=ORD+PRN, incomplete=둘 다 부재
function mkPouch(ord, prn, complete) {
  const ordInfo = { PDT_CD: 'GSPUFBC', MTRL_CD: 'PXFBW010', CUT_WDT: 230, CUT_HGH: 288, WRK_WDT: 250, WRK_HGH: 308, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 };
  if (complete) { ordInfo.ORD_CNT = ord; ordInfo.PRN_CNT = prn; }
  return {
    ORD_INFO: [ordInfo],
    PCS_INFO: [{ PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }, { PCS_COD: 'PDT_WRK', PCS_DTL_COD: 'PUBOK', ATTB: '' }, { PCS_COD: 'FLX_ZIP', PCS_DTL_COD: 'ZPH01', ATTB: '' }],
    price_gbn: 'tmpl_price', mb_cust_cod: '10000000',
  };
}

// GSNTSPR: RIN_DFT ATTB(링색) + ROU_DFT ATTB(반경) + qty(ORD/PRN). 나머지 PCS는 seed 재현.
function mkGsntspr(ringColor, rou, ord, prn) {
  return {
    ORD_INFO: [{ PDT_CD: 'GSNTSPR', MTRL_CD: 'RIBVW350', CUT_WDT: 182, CUT_HGH: 257, WRK_WDT: 187, WRK_HGH: 262, PRN_CNT: prn, ORD_CNT: ord, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }],
    PCS_INFO: [
      { PCS_COD: 'COT_DFT', PCS_DTL_COD: 'TCGLS', ATTB: '' },
      { PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' },
      { PCS_COD: 'INN_DFT', PCS_DTL_COD: 'INNON', ATTB: 1, ATTB_2: '', ATTB_3: '' },
      { PCS_COD: 'RIN_DFT', PCS_DTL_COD: 'BPLFT', ATTB: ringColor },
      { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXLT', ATTB: String(rou) },
      { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXRT', ATTB: String(rou) },
      { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXLB', ATTB: String(rou) },
      { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXRB', ATTB: String(rou) },
    ],
    price_gbn: 'tmpl_price', mb_cust_cod: '10000000',
  };
}

async function runScenario(key) {
  const s = SCENARIOS[key];
  if (!s) { console.error(`unknown scenario ${key}`); return; }
  console.log(`\n[${key}] ${s.productCode} (${s.price_gbn})`);
  const calls = [];
  for (const [label, dataJson] of s.calls) {
    const rec = await record(label, dataJson);
    const p = rec.result_sum ? rec.result_sum.PRICE : 'NULL';
    console.log(`  ${label} → PRICE=${p} (retCode ${rec.retCode})`);
    calls.push(rec);
  }
  // oracle sanity: 정상 호출(라벨에 'incomplete'/'결함'/'attempt' 미포함)에 PRICE==0 없어야 함
  const normalZeros = calls.filter((c) => !/incomplete|결함|attempt/.test(c.label) && c.result_sum && c.result_sum.PRICE === 0);
  const out = {
    scenario: key,
    productCode: s.productCode,
    price_gbn: s.price_gbn,
    note: s.note,
    capturedAt: new Date().toISOString(),
    sessionFresh: true,
    oracle: 'live RedPrinting via server.js :3001 (read-only get_ajax_price_vTmpl)',
    oracleSanity: {
      readsResultSum: true,
      perLineMayBeZero: 'legal (bundle components); result_sum.PRICE is authority',
      normalPathZeroCount: normalZeros.length,
      zeroIsDefect: normalZeros.length > 0 ? 'WARN: 정상경로 PRICE=0 검출 — 세션/필드 결함 의심' : 'OK: 정상경로 PRICE≠0',
    },
    secretsRedaction: 'cookies/JWT/presigned 미포함(server.js 서버측 쿠키주입). mb_cust_cod 세션파생값 [REDACTED], 익명기본 10000000 유지(공개값).',
    calls,
  };
  save(s.file, out);
  return out;
}

(async () => {
  const target = process.argv[2];
  const keys = target ? [target] : Object.keys(SCENARIOS);
  for (const k of keys) await runScenario(k);
  console.log('\n캡처 완료.');
})();
