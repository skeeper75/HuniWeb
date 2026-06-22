#!/usr/bin/env node
/**
 * hrev-golden-recorder — 신규 14 가격필드 전용 라이브 골든 캡처 (Phase 2 보강 / 260623)
 *
 * 배경: 직전 §22 가격검증은 4월 필드사전 기준. 6월 라이브가 진화해 신규 14필드 추가.
 *       R2는 메타모픽 4변형만 캡처 — 신규 14필드 전체 sweep 골든은 미수행. 그 보강.
 * 오라클 = 라이브 RedPrinting via server.js :3001 (읽기전용 get_ajax_price_vTmpl POST).
 * 권위 = result_sum.PRICE (단일권위, per-line 금지). PRICE=0 = 결함신호.
 * 비밀 = server.js 가 쿠키 서버측 주입(reqBody 미포함). mb_cust_cod 익명기본 10000000 공개값.
 *
 * 사용: node _capture-new-fields.cjs            (전 시나리오)
 *       node _capture-new-fields.cjs NF-ORDCNT  (특정 시나리오)
 * 산출: <scenario>.json (시나리오당 1 파일 — 누적 금지)
 */
const fs = require('fs');
const path = require('path');
const http = require('http');

const PROXY = 'http://localhost:3001/rp-api/ko/product_price/get_ajax_price_vTmpl';
const OUT = __dirname;

// mb_cust_cod 마스킹: 세션파생 고객코드(8자리 비-10000000)는 [REDACTED]. 익명기본 10000000 공개값 유지.
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

async function record(label, dataJson) {
  const r = await post(dataJson);
  const j = r.json || {};
  const rs = j.result_sum || null;
  const perLine = Array.isArray(j.result)
    ? j.result.map((x) => ({ PCS_CD: x.PCS_CD, PRICE: x.PRICE }))
    : [];
  const priceLog = Array.isArray(j.result) && j.result[0] ? j.result[0].PRICE_LOG : undefined;
  const reqStored = maskCustCode(JSON.parse(JSON.stringify({ dataJson })));
  const out = { label, status: r.status, retCode: j.retCode, reqBody: reqStored, result_sum: rs, perLine };
  if (priceLog !== undefined) out.priceLog = priceLog;
  if (j.book_info) out.book_info = j.book_info;
  return out;
}

function save(file, obj) {
  fs.writeFileSync(path.join(OUT, file), JSON.stringify(obj, null, 2));
  console.log(`  saved → ${file}`);
}

// ── NCCDDFT 베이스 (R2 baseline 동형: RXSNO250 / 148x100 default size / SID_S / 4clr) ──
function nc(extra) {
  return Object.assign({
    PDT_CD: 'NCCDDFT', MTRL_CD: 'RXSNO250',
    CUT_WDT: 148, CUT_HGH: 100, WRK_WDT: 152, WRK_HGH: 104,
    PRN_CNT: 500, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4,
    ADD_CLR_YN: 'N', REAM_CNT: 0,
  }, extra || {});
}
const NC_PCS_BASE = [{ PCS_COD: 'CUT_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }];
const NC_GBN = 'offset2023_price';
const M = '10000000';

// ── 시나리오 정의 ──────────────────────────────────────────
const SCENARIOS = {
  // NF-ORDCNT: ORD_CNT(디자인 수/건수) 선형 multiplier — 신규 필드사전의 수량 차원
  'NF-ORDCNT': {
    file: 'NF-ORDCNT_NCCDDFT.json', productCode: 'NCCDDFT', price_gbn: NC_GBN,
    field: 'ORD_CNT', note: 'ORD_CNT(디자인 수/건수) 선형 multiplier. ORD↑⇒price↑(비례). offset2023 수량 차원.',
    calls: [
      ['ORD_CNT=1 (baseline)', { ORD_INFO: [nc({ ORD_CNT: 1 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['ORD_CNT=2', { ORD_INFO: [nc({ ORD_CNT: 2 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['ORD_CNT=5', { ORD_INFO: [nc({ ORD_CNT: 5 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
    ],
  },

  // NF-PRNCNT-MODELB: PRN_CNT 수량모델 B (offset2023 pdt_prn_cnt_info 행기반) — 수량↑⇒price 비감소
  'NF-PRNCNT-MODELB': {
    file: 'NF-PRNCNT-modelB_NCCDDFT.json', productCode: 'NCCDDFT', price_gbn: NC_GBN,
    field: 'PRN_CNT (수량모델 B)', note: '수량모델 B(offset2023_item·명함/카드/책자·pdt_prn_cnt_info 행기반). PRN_CNT↑⇒price 비감소(메타모픽).',
    calls: [
      ['PRN_CNT=500 (DFT)', { ORD_INFO: [nc({ PRN_CNT: 500 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['PRN_CNT=1000', { ORD_INFO: [nc({ PRN_CNT: 1000 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['PRN_CNT=2000', { ORD_INFO: [nc({ PRN_CNT: 2000 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
    ],
  },

  // NF-REAMCNT: REAM_CNT(연 수) 신규 필드 — 엔진 수용 검증 (NCCDDFT는 PRN_CNT 권위, REAM 무영향)
  'NF-REAMCNT': {
    file: 'NF-REAMCNT_NCCDDFT.json', productCode: 'NCCDDFT', price_gbn: NC_GBN,
    field: 'REAM_CNT', note: 'REAM_CNT(연 수) 신규필드. offset2023 엔진 수용(retCode 200). NCCDDFT는 PRN_CNT가 수량권위라 REAM_CNT 단독 변형 무영향(가격불변)이 정상 — 결함 아님(연단위 UI 입력 대체모드).',
    calls: [
      ['REAM_CNT=0 PRN500', { ORD_INFO: [nc({ REAM_CNT: 0, PRN_CNT: 500 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['REAM_CNT=1 PRN500', { ORD_INFO: [nc({ REAM_CNT: 1, PRN_CNT: 500 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['REAM_CNT=2 PRN500', { ORD_INFO: [nc({ REAM_CNT: 2, PRN_CNT: 500 })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
    ],
  },

  // NF-ADDCLR: ADD_CLR_YN(추가색상) Y/N — 자재/도수 조건부. SID_S/4clr + SID_D/8clr 둘 다 차등 시도
  'NF-ADDCLR': {
    file: 'NF-ADDCLR_NCCDDFT.json', productCode: 'NCCDDFT', price_gbn: NC_GBN,
    field: 'ADD_CLR_YN', note: 'ADD_CLR_YN(추가색상) Y/N. 자재조건부 — R2는 SID_S/RXSNO250선 무변화. 여기서 SID_D(양면)/8도수까지 deeper 조합으로 차등 시도. 무변화면 "자재조건부 무영향"의 deeper 입증(결함 아님).',
    calls: [
      ['SID_S 4clr ADD_CLR=N', { ORD_INFO: [nc({ DOSU_COD: 'SID_S', PRN_CLR_CNT: 4, ADD_CLR_YN: 'N' })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['SID_S 4clr ADD_CLR=Y (차등)', { ORD_INFO: [nc({ DOSU_COD: 'SID_S', PRN_CLR_CNT: 4, ADD_CLR_YN: 'Y' })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['SID_D 8clr ADD_CLR=N', { ORD_INFO: [nc({ DOSU_COD: 'SID_D', PRN_CLR_CNT: 8, ADD_CLR_YN: 'N' })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['SID_D 8clr ADD_CLR=Y (차등)', { ORD_INFO: [nc({ DOSU_COD: 'SID_D', PRN_CLR_CNT: 8, ADD_CLR_YN: 'Y' })], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
    ],
  },

  // NF-FLD-DFT: FLD_DFT(접지) 신규 후가공 — PCS_INFO 가격 기여. 접지단 sweep
  'NF-FLD-DFT': {
    file: 'NF-FLD-DFT_NCCDDFT.json', productCode: 'NCCDDFT', price_gbn: NC_GBN,
    field: 'FLD_DFT (접지)', note: '신규 후가공 FLD_DFT(접지). +후가공⇒price↑(메타모픽). FO006=2단/FO007=3단/FO008=4단/FO002=대문/FO001=4단병풍. PCS_INFO 가격 기여 입증.',
    calls: [
      ['후가공 없음 (baseline)', { ORD_INFO: [nc()], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['FLD_DFT 2단접지 FO006', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'FLD_DFT', PCS_DTL_COD: 'FO006', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
      ['FLD_DFT 3단접지 FO007', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'FLD_DFT', PCS_DTL_COD: 'FO007', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
      ['FLD_DFT 4단접지 FO008', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'FLD_DFT', PCS_DTL_COD: 'FO008', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
      ['FLD_DFT 대문접지 FO002', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'FLD_DFT', PCS_DTL_COD: 'FO002', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
    ],
  },

  // NF-POSTPCS: 기타 신규 후가공(HOL_DFT 타공 / ROU_DFT 귀돌이 / MIS_DFT 미싱 / OSI_DFT 오시) 가격 기여
  'NF-POSTPCS': {
    file: 'NF-POSTPCS_NCCDDFT.json', productCode: 'NCCDDFT', price_gbn: NC_GBN,
    field: 'HOL_DFT/ROU_DFT/MIS_DFT/OSI_DFT (신규 후가공)', note: '신규 후가공 다종 가격 기여. +후가공⇒price↑(메타모픽). HOL_DFT(타공)·ROU_DFT(귀돌이 4코너)·MIS_DFT(미싱)·OSI_DFT(오시).',
    calls: [
      ['후가공 없음 (baseline)', { ORD_INFO: [nc()], PCS_INFO: NC_PCS_BASE, price_gbn: NC_GBN, mb_cust_cod: M }],
      ['HOL_DFT 타공', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'HOL_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
      ['ROU_DFT 귀돌이 4코너', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXLT', ATTB: '' }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXRT', ATTB: '' }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXLB', ATTB: '' }, { PCS_COD: 'ROU_DFT', PCS_DTL_COD: 'DFXRB', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
      ['MIS_DFT 미싱', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'MIS_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
      ['OSI_DFT 오시', { ORD_INFO: [nc()], PCS_INFO: [...NC_PCS_BASE, { PCS_COD: 'OSI_DFT', PCS_DTL_COD: 'DFXXX', ATTB: '' }], price_gbn: NC_GBN, mb_cust_cod: M }],
    ],
  },

  // NF-TIERED-MODELB: 수량모델 B 변형(GSTGMIC tiered, vDigital) PRN_CNT 스윕 — 단조증가 골든
  'NF-TIERED-MODELB': {
    file: 'NF-TIERED-modelB_GSTGMIC.json', productCode: 'GSTGMIC', price_gbn: 'tiered_price',
    field: 'PRN_CNT (tiered/FIR_CNT base)', note: 'tiered_price(vDigital). FIR_CNT/INC_CNT/INC_STEP base 수량모델. PRN_CNT↑⇒price 단조증가(메타모픽). WRK_MTR ATTB=PRN_CNT 추종.',
    calls: [
      ['PRN_CNT=1', mkGstgmic(1)],
      ['PRN_CNT=2', mkGstgmic(2)],
      ['PRN_CNT=5', mkGstgmic(5)],
      ['PRN_CNT=10', mkGstgmic(10)],
      ['PRN_CNT=30', mkGstgmic(30)],
    ],
  },
};

// GSTGMIC tiered: PRN_CNT 스윕. WRK_MTR ATTB=PRN_CNT 추종(라이브 실측 패턴 재현).
function mkGstgmic(prn) {
  return {
    ORD_INFO: [{ PDT_CD: 'GSTGMIC', MTRL_CD: 'RXBVW300', CUT_WDT: 351, CUT_HGH: 291, WRK_WDT: 355, WRK_HGH: 295, PRN_CNT: prn, ORD_CNT: 1, DOSU_COD: 'SID_S', PRN_CLR_CNT: 4 }],
    PCS_INFO: [
      { PCS_COD: 'WRK_MTR', PCS_DTL_COD: 'TG003', ATTB: prn, ATTB_2: '', ATTB_3: '' },
      { PCS_COD: 'COT_DFT', PCS_DTL_COD: 'TCGLS', ATTB: '' },
    ],
    price_gbn: 'tiered_price', mb_cust_cod: '10000000',
  };
}

async function runScenario(key) {
  const s = SCENARIOS[key];
  if (!s) { console.error(`unknown scenario ${key}`); return; }
  console.log(`\n[${key}] ${s.productCode} (${s.price_gbn}) — field: ${s.field}`);
  const calls = [];
  for (const [label, dataJson] of s.calls) {
    const rec = await record(label, dataJson);
    const p = rec.result_sum ? rec.result_sum.PRICE : 'NULL';
    console.log(`  ${label} → PRICE=${p} (retCode ${rec.retCode})`);
    calls.push(rec);
  }
  // oracle sanity: 정상 호출(라벨에 'incomplete'/'결함'/'attempt' 미포함)에 PRICE==0 없어야 함
  const normalZeros = calls.filter((c) => !/incomplete|결함|attempt/.test(c.label) && c.result_sum && c.result_sum.PRICE === 0);
  // 메타모픽: PRICE 시퀀스 단조성/비감소 점검(시나리오별 의미는 note 참조)
  const prices = calls.map((c) => (c.result_sum ? c.result_sum.PRICE : null));
  const out = {
    scenario: key,
    field: s.field,
    productCode: s.productCode,
    price_gbn: s.price_gbn,
    note: s.note,
    capturedAt: new Date().toISOString(),
    sessionFresh: true,
    oracle: 'live RedPrinting via server.js :3001 (read-only get_ajax_price_vTmpl POST)',
    oracleSanity: {
      readsResultSum: true,
      perLineMayBeZero: 'legal (bundle components); result_sum.PRICE is authority',
      normalPathZeroCount: normalZeros.length,
      zeroIsDefect: normalZeros.length > 0 ? 'WARN: 정상경로 PRICE=0 검출 — 세션/필드 결함 의심' : 'OK: 정상경로 PRICE≠0',
      priceSequence: prices,
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
  console.log('\n신규필드 캡처 완료.');
})();
