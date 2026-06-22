// 발산 최소반례 추출기 — VP-1 emit reqBody ↔ 골든 reqBody 차이를 행 단위로 출력(보고용).
//  테스트가 아니라 리포터(전부 통과). console 출력이 divergence-cases.md 증거.
import { describe, it } from 'vitest';
import { readFileSync, readdirSync } from 'node:fs';
import { resolve } from 'node:path';
import { serializeRedPriceRequest } from '@/adapters/red/red-adapter';
import type { NormalizedPriceRequest, SelectedFinish } from '@/contract';

const CAP_DIR = resolve(__dirname, '../../02_golden/captures');

function reqFromGolden(g: any, call: any): NormalizedPriceRequest {
  const ord = call.reqBody.dataJson.ORD_INFO[0];
  const isBook = ord.PAGE_CNT !== undefined || ord.CVR_MTRL_CD !== undefined;
  const finishes: SelectedFinish[] = call.reqBody.dataJson.PCS_INFO.map((p: any) => {
    const f: SelectedFinish = { groupId: `PCS_${p.PCS_COD}`, valueId: p.PCS_DTL_COD };
    if (p.ATTB !== undefined && p.ATTB !== '') f.attb = String(p.ATTB);
    if (p.ATTB_2 !== undefined && p.ATTB_2 !== '') f.attb2 = String(p.ATTB_2);
    if (p.ATTB_3 !== undefined && p.ATTB_3 !== '') f.attb3 = String(p.ATTB_3);
    return f;
  });
  return {
    productCode: ord.PDT_CD,
    priceSchemeKey: call.reqBody.dataJson.price_gbn,
    itemGroup: isBook ? 'book2025_item' : 'vDigital_item',
    customerTier: call.reqBody.dataJson.mb_cust_cod,
    dimensions: [{ side: 'default', cutW: ord.CUT_WDT, cutH: ord.CUT_HGH, workW: ord.WRK_WDT, workH: ord.WRK_HGH }],
    colorCounts: isBook ? { default: ord.CVR_CLR_CNT, inner: ord.INN_CLR_CNT } : { default: ord.PRN_CLR_CNT },
    materials: isBook ? { default: ord.CVR_MTRL_CD, inner: ord.INN_MTRL_CD } : { default: ord.MTRL_CD },
    quantity: ord.ORD_CNT ?? 0,
    printCount: ord.PRN_CNT,
    pageCount: ord.PAGE_CNT,
    selectedFinishes: finishes,
  };
}

// 골든 reqBody 와 emit reqBody 의 ORD_INFO/PCS_INFO 키 단위 diff(값+타입).
function diffRows(label: string, emit: any, gold: any): string[] {
  const rows: string[] = [];
  const eo = emit.ORD_INFO[0], go = gold.ORD_INFO[0];
  const keys = new Set([...Object.keys(eo), ...Object.keys(go)]);
  for (const k of keys) {
    const ev = eo[k], gv = go[k];
    if (k === 'DOSU_COD') continue; // 의도 omit, 별도
    if (ev !== gv || typeof ev !== typeof gv) {
      // undefined 양쪽이면 skip
      if (ev === undefined && gv === undefined) continue;
      rows.push(`  ORD.${k}: emit=${JSON.stringify(ev)}(${typeof ev}) live=${JSON.stringify(gv)}(${typeof gv})`);
    }
  }
  const ep = emit.PCS_INFO, gp = gold.PCS_INFO;
  for (let i = 0; i < Math.max(ep.length, gp.length); i++) {
    const e = ep[i] ?? {}, gg = gp[i] ?? {};
    for (const k of ['ATTB', 'ATTB_2', 'ATTB_3']) {
      const ev = (e as any)[k], gv = (gg as any)[k];
      const en = ev === undefined ? '' : ev, gn = gv === undefined ? '' : gv;
      if (en !== gn || typeof ev !== typeof gv) {
        if ((en === '' && gn === '')) continue;
        rows.push(`  PCS[${i}].${k} (${e.PCS_COD ?? gg.PCS_COD}): emit=${JSON.stringify(ev)}(${typeof ev}) live=${JSON.stringify(gv)}(${typeof gv})`);
      }
    }
  }
  return rows.length ? [`[${label}]`, ...rows] : [];
}

describe('divergence extract (리포터)', () => {
  it('dump', () => {
    const files = readdirSync(CAP_DIR).filter((f) => f.startsWith('golden_') && f.endsWith('.json')).sort();
    const all: string[] = [];
    for (const f of files) {
      const g = JSON.parse(readFileSync(resolve(CAP_DIR, f), 'utf8'));
      for (const call of g.calls) {
        if (String(call.label).includes('incomplete')) continue;
        const emit = serializeRedPriceRequest(reqFromGolden(g, call)).dataJson;
        const rows = diffRows(`${g.scenario}/${g.productCode} :: ${call.label}`, emit, call.reqBody.dataJson);
        all.push(...rows);
      }
    }
    console.log('\n===VPRICE-DIVERGENCE-BEGIN===');
    console.log(all.length ? all.join('\n') : '(no divergence)');
    console.log('===VPRICE-DIVERGENCE-END===');
  });
});
