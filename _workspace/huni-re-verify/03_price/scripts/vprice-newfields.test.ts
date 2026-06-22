// V-PRICE 신규필드(6월 드리프트) 차등 하네스 — Phase 3.
//  §6 재구성 가격 어댑터(serializeRedPriceRequest/mapPriceResponse)가 6월 신규 14필드를
//  처리하는가를, 신규필드 라이브 골든(02_golden/captures/new-fields-260623/*.json)을 오라클로 차등 검증.
//
// [HARD] 오라클 = 라이브. 재구성이 라이브와 다르면 라이브가 옳다.
// [HARD] fixture 우회 금지 — golden 의 실 reqBody 로 NormalizedPriceRequest 를 역구성해
//        adapter 직렬화 출력(emit reqBody)을 골든 reqBody 와 field-for-field 대조(VP-1, VP-6).
// [HARD] 무날조 — 모든 비교는 골든 JSON verbatim. 신규필드 누락은 "재구성이 못 보냄"으로 정량화.
import { describe, it, expect } from 'vitest';
import { readFileSync, readdirSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  serializeRedPriceRequest,
  mapPriceResponse,
} from '@/adapters/red/red-adapter';
import type { NormalizedPriceRequest, SelectedFinish } from '@/contract';
import type { RedPriceResponse } from '@/adapters/red/red-types';

const NF_DIR = resolve(__dirname, '../../02_golden/captures/new-fields-260623');

interface NfCall {
  label: string;
  retCode: number;
  reqBody: { dataJson: { ORD_INFO: any[]; PCS_INFO: any[]; price_gbn: string; mb_cust_cod: string } };
  result_sum: Record<string, number>;
  perLine: Array<{ PRICE: number }>;
}
interface NfGolden {
  scenario: string;
  field: string;
  productCode: string;
  price_gbn: string;
  calls: NfCall[];
}

function loadNfGoldens(): NfGolden[] {
  return readdirSync(NF_DIR)
    .filter((f) => f.startsWith('NF-') && f.endsWith('.json'))
    .sort()
    .map((f) => JSON.parse(readFileSync(resolve(NF_DIR, f), 'utf8')) as NfGolden);
}

// 골든 reqBody → NormalizedPriceRequest 역구성. (4월 테스트 reqFromGolden 과 동일 경로 — 신규필드는
//  계약/어댑터에 슬롯이 없으므로 의도적으로 운반 불가. 이것이 검사 대상이다.)
function reqFromNfCall(g: NfGolden, call: NfCall): NormalizedPriceRequest {
  const ord = call.reqBody.dataJson.ORD_INFO[0];
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
    itemGroup: 'vDigital_item',
    customerTier: call.reqBody.dataJson.mb_cust_cod,
    dimensions: [{ side: 'default', cutW: ord.CUT_WDT, cutH: ord.CUT_HGH, workW: ord.WRK_WDT, workH: ord.WRK_HGH }],
    colorCounts: { default: ord.PRN_CLR_CNT },
    materials: { default: ord.MTRL_CD },
    quantity: ord.ORD_CNT ?? 0,
    printCount: ord.PRN_CNT ?? 1,
    selectedFinishes: finishes,
  };
}

// 신규 ORD_INFO 필드 집합 (price-engine-additions.md 사전 + 실 골든 reqBody).
const NEW_ORD_FIELDS = [
  'DOSU_COD', 'ADD_CLR_YN', 'REAM_CNT', 'MAX_PRN_CNT', 'PACK_PRN_CNT',
  'PDT_SIZE_INFO', 'PRINT_TYPE', 'TMPL_IDX', 'MIN_ORD_PRN_CNT', 'ADD_ORD_PRN_CNT',
];

const goldens = loadNfGoldens();

describe('VP-1/VP-6 신규필드 reqBody field-for-field 정합', () => {
  for (const g of goldens) {
    for (const call of g.calls) {
      it(`${g.scenario} [${call.label}] emit reqBody ⊇ golden 신규필드`, () => {
        const req = reqFromNfCall(g, call);
        const emit = serializeRedPriceRequest(req);
        const goldenOrd = call.reqBody.dataJson.ORD_INFO[0];
        const emitOrd = emit.dataJson.ORD_INFO[0] as Record<string, unknown>;

        // 골든 ORD_INFO 에 존재하는 신규필드 중, 재구성이 emit 하지 못한 것을 수집.
        const missing: Array<{ field: string; golden: unknown; emit: unknown }> = [];
        for (const k of NEW_ORD_FIELDS) {
          if (k in goldenOrd) {
            const gv = (goldenOrd as Record<string, unknown>)[k];
            const ev = emitOrd[k];
            if (ev === undefined || ev !== gv) {
              missing.push({ field: k, golden: gv, emit: ev });
            }
          }
        }
        // 이 assertion 은 신규필드 처리 여부를 정량화한다. FAIL = 재구성이 신규필드를 못 보냄.
        expect(missing, `재구성 미전송 신규 ORD_INFO 필드: ${JSON.stringify(missing)}`).toEqual([]);
      });
    }
  }
});

describe('VP-2 신규필드 result_sum.PRICE 차등 (오라클=라이브)', () => {
  for (const g of goldens) {
    for (const call of g.calls) {
      it(`${g.scenario} [${call.label}] mapPriceResponse.finalPrice == golden.result_sum.PRICE`, () => {
        // result_sum 응답 매핑 차등: 어댑터가 응답을 정확히 평면화하는지(요청 발산과 별개).
        const fakeRes: RedPriceResponse = {
          retCode: call.retCode,
          result_sum: call.result_sum as any,
          result: call.perLine.map((p) => ({ PCS_CD: 'X', PRICE: p.PRICE })) as any,
        } as RedPriceResponse;
        const out = mapPriceResponse(fakeRes);
        expect(out.finalPrice).toBe(call.result_sum.PRICE);
        expect(out.vat).toBe(call.result_sum.PRICE_VAT);
      });
    }
  }
});

describe('VP-3 신규필드 경로 PRICE≠0 sanity', () => {
  for (const g of goldens) {
    for (const call of g.calls) {
      it(`${g.scenario} [${call.label}] golden PRICE>0`, () => {
        // 신규필드 정상 경로(retCode 200)에서 라이브 PRICE 가 0 이 아님(0=결함신호).
        expect(call.result_sum.PRICE).toBeGreaterThan(0);
      });
    }
  }
});

describe('VP-5 신규필드 메타모픽 (수량↑⇒비감소·+후가공⇒증가)', () => {
  const mr = JSON.parse(readFileSync(resolve(NF_DIR, 'metamorphic-relations.json'), 'utf8'));
  for (const rel of mr.relations) {
    if (rel.holds === true) {
      it(`${rel.id} 단조 비감소 (라이브 시퀀스)`, () => {
        const seq = rel.sequence.map((s: any) => s.PRICE);
        for (let i = 1; i < seq.length; i++) {
          expect(seq[i]).toBeGreaterThanOrEqual(seq[i - 1]);
        }
      });
    }
  }
});
