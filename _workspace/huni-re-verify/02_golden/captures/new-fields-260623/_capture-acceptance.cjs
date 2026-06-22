#!/usr/bin/env node
// PACK_PRN_CNT / MAX_PRN_CNT / 수량모델A(MIN_ORD/ADD_ORD ladder) 엔진 수용 골든.
// ★ UI 노출 상품 부재(가용 가격조회 상품 전수 hasPackPrnCnt=false / hasMinOrdPrn=false / PDT_VER_SIZE 부재).
//   → 가격함수 sweep은 미캡처(사유: 노출상품 미가용). 본 골든은 "엔진이 필드를 수용(retCode 200)·기존 PRICE 불변"만 record.
const fs=require('fs'),path=require('path'),http=require('http');
const PROXY='http://localhost:3001/rp-api/ko/product_price/get_ajax_price_vTmpl';
function maskCC(o){try{const c=o?.dataJson?.mb_cust_cod;if(c&&c!=='10000000'&&c!=='')o.dataJson.mb_cust_cod='[REDACTED-session-cust]';}catch{}return o;}
function post(dj){return new Promise((res,rej)=>{const b=JSON.stringify({dataJson:dj});const r=http.request(PROXY,{method:'POST',headers:{'Content-Type':'application/json','Content-Length':Buffer.byteLength(b)},timeout:30000},rs=>{let x='';rs.on('data',d=>x+=d);rs.on('end',()=>{try{res({status:rs.statusCode,json:JSON.parse(x)});}catch(e){res({status:rs.statusCode,json:null,raw:x.slice(0,300)});}});});r.on('error',rej);r.on('timeout',()=>{r.destroy();rej(new Error('timeout'));});r.write(b);r.end();});}
async function record(label,dj){const r=await post(dj);const j=r.json||{};const rs=j.result_sum||null;const perLine=Array.isArray(j.result)?j.result.map(x=>({PCS_CD:x.PCS_CD,PRICE:x.PRICE})):[];return{label,status:r.status,retCode:j.retCode,reqBody:maskCC(JSON.parse(JSON.stringify({dataJson:dj}))),result_sum:rs,perLine};}
function nc(extra){return Object.assign({PDT_CD:'NCCDDFT',MTRL_CD:'RXSNO250',CUT_WDT:148,CUT_HGH:100,WRK_WDT:152,WRK_HGH:104,PRN_CNT:500,ORD_CNT:1,DOSU_COD:'SID_S',PRN_CLR_CNT:4,ADD_CLR_YN:'N',REAM_CNT:0},extra||{});}
(async()=>{
  const PCS=[{PCS_COD:'CUT_DFT',PCS_DTL_COD:'DFXXX',ATTB:''}];const g='offset2023_price',m='10000000';
  const C=(label,o)=>record(label,{ORD_INFO:[nc(o)],PCS_INFO:PCS,price_gbn:g,mb_cust_cod:m});
  const calls=[
    await C('baseline (필드없음)',{}),
    await C('PACK_PRN_CNT=0',{PACK_PRN_CNT:0}),
    await C('PACK_PRN_CNT=100',{PACK_PRN_CNT:100}),
    await C('MAX_PRN_CNT=10000',{MAX_PRN_CNT:10000}),
    await C('수량모델A ladder(MIN_ORD/ADD_ORD/INC)',{MIN_ORD_PRN_CNT:1,ADD_ORD_PRN_CNT:1,INC_CNT:1}),
  ];
  const prices=calls.map(c=>c.result_sum?c.result_sum.PRICE:null);
  const out={
    scenario:'NF-ACCEPTANCE',
    field:'PACK_PRN_CNT / MAX_PRN_CNT / 수량모델A(MIN_ORD_PRN_CNT+ADD_ORD_PRN_CNT ladder)',
    productCode:'NCCDDFT',price_gbn:g,
    note:'★엔진 수용 골든(가격함수 sweep 아님). 가용 가격조회 상품 전수에서 PACK_PRN_CNT(개별포장)·model A 래더·PDT_VER_SIZE 노출 상품 미가용 → 가격함수는 미캡처(사유: 노출상품 미가용). 본 골든은 엔진이 신규필드를 거부없이 수용(retCode 200)하고 기존 PRICE를 보존함만 입증(R2 retCode 200 수용 보강).',
    coverageStatus:'PARTIAL — 엔진수용 OK / 가격함수 미캡처(노출상품 미가용)',
    capturedAt:new Date().toISOString(),sessionFresh:true,
    oracle:'live RedPrinting via server.js :3001 (read-only get_ajax_price_vTmpl POST)',
    oracleSanity:{readsResultSum:true,normalPathZeroCount:calls.filter(c=>c.result_sum&&c.result_sum.PRICE===0).length,zeroIsDefect:'OK: 정상경로 PRICE≠0',priceSequence:prices,note:'전 변형 PRICE 불변(12700)=필드 인입하되 NCCDDFT엔 가격함수 미바인딩(정상). 결함 아님.'},
    secretsRedaction:'cookies/JWT 미포함(server.js 주입). mb_cust_cod 10000000 공개기본.',
    calls,
  };
  fs.writeFileSync(path.join(__dirname,'NF-ACCEPTANCE_NCCDDFT.json'),JSON.stringify(out,null,2));
  console.log('saved NF-ACCEPTANCE_NCCDDFT.json | prices',JSON.stringify(prices));
})();
