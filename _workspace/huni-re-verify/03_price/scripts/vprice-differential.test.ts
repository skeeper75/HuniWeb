// V-PRICE 차등 하네스 — §6 재구성 가격 어댑터(serializeRedPriceRequest/mapPriceResponse)를
//  라이브 골든(02_golden/captures/golden_*.json)을 오라클로 차등 검증한다.
//
// [HARD] 오라클 = 라이브. 재구성이 라이브와 다르면 라이브가 옳다.
// [HARD] fixture 우회 금지 — golden 의 실 reqBody 로 NormalizedPriceRequest 를 역구성해
//        adapter 의 직렬화 출력(emit reqBody)을 골든 reqBody 와 직접 대조(VP-1, N-1 함정 차단).
// [HARD] 무날조 — 모든 비교는 골든 JSON verbatim.
import { describe, it, expect } from 'vitest';
import { readFileSync, readdirSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  serializeRedPriceRequest,
  mapPriceResponse,
} from '@/adapters/red/red-adapter';
import type { NormalizedPriceRequest, SelectedFinish } from '@/contract';
import type { RedPriceResponse } from '@/adapters/red/red-types';

const CAP_DIR = resolve(__dirname, '../../02_golden/captures');

interface GoldenOrdInfo {
  PDT_CD: string;
  MTRL_CD?: string;
  CUT_WDT: number;
  CUT_HGH: number;
  WRK_WDT: number;
  WRK_HGH: number;
  PRN_CNT?: number;
  ORD_CNT?: number;
  DOSU_COD?: string;
  PRN_CLR_CNT?: number;
  PAGE_CNT?: number;
  CVR_CLR_CNT?: number;
  INN_CLR_CNT?: number;
  CVR_MTRL_CD?: string;
  INN_MTRL_CD?: string;
}
interface GoldenPcs {
  PCS_COD: string;
  PCS_DTL_COD: string;
  ATTB?: unknown;
  ATTB_2?: unknown;
  ATTB_3?: unknown;
}
interface GoldenCall {
  label: string;
  retCode: number;
  reqBody: { dataJson: { ORD_INFO: GoldenOrdInfo[]; PCS_INFO: GoldenPcs[]; price_gbn: string; mb_cust_cod: string } };
  result_sum: Record<string, number>;
  perLine: Array<{ PCS_CD: string; PRICE: number }>;
}
interface Golden {
  scenario: string;
  productCode: string;
  price_gbn: string;
  calls: GoldenCall[];
}

function loadGoldens(): Golden[] {
  return readdirSync(CAP_DIR)
    .filter((f) => f.startsWith('golden_') && f.endsWith('.json'))
    .sort()
    .map((f) => JSON.parse(readFileSync(resolve(CAP_DIR, f), 'utf8')) as Golden);
}

// 골든 reqBody(라이브 실측) → NormalizedPriceRequest 역구성.
//  itemGroup 은 책자 분리필드 존재 여부로 명시(D-L2 권위 경로 사용 — book2025).
function reqFromGolden(g: Golden, call: GoldenCall): NormalizedPriceRequest {
  const ord = call.reqBody.dataJson.ORD_INFO[0];
  const isBook = ord.PAGE_CNT !== undefined || ord.CVR_MTRL_CD !== undefined;
  const finishes: SelectedFinish[] = call.reqBody.dataJson.PCS_INFO.map((p) => {
    const f: SelectedFinish = { groupId: `PCS_${p.PCS_COD}`, valueId: p.PCS_DTL_COD };
    // ATTB 가 빈문자열이면 미보유(undefined). 그 외(속성칩/수량형)는 echo 운반값으로 전달.
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
    colorCounts: isBook
      ? { default: ord.CVR_CLR_CNT, inner: ord.INN_CLR_CNT }
      : { default: ord.PRN_CLR_CNT },
    materials: isBook
      ? { default: ord.CVR_MTRL_CD, inner: ord.INN_MTRL_CD }
      : { default: ord.MTRL_CD },
    quantity: ord.ORD_CNT ?? 0, // incomplete 가드(ORD_CNT 부재)는 0 으로 역구성
    printCount: ord.PRN_CNT, // 부재 시 undefined → 가드/PRN_CNT=1
    pageCount: ord.PAGE_CNT,
    selectedFinishes: finishes,
  };
}

// 응답 골든 → RedPriceResponse(어댑터 mapPriceResponse 입력 shape).
function resFromGolden(call: GoldenCall): RedPriceResponse {
  return {
    retCode: call.retCode,
    result: call.perLine.map((l) => ({
      PCS_CD: l.PCS_CD,
      PRICE: l.PRICE,
      PRICE_VAT: 0,
      PRICE_MALL: l.PRICE,
      PRICE_MALL_VAT: 0,
      ORG_PRICE: l.PRICE,
      ORG_PRICE_VAT: 0,
    })) as RedPriceResponse['result'],
    result_sum: call.result_sum as unknown as RedPriceResponse['result_sum'],
  } as RedPriceResponse;
}

// 골든 reqBody 의 가격필드(직렬화 비교 대상) — DOSU_COD 는 어댑터 의도 omit(D-L4 MINOR) 이므로
//  비교에서 분리(별도 보고). 키 존재/값/타입 모두 대조.
const ORD_PRICE_FIELDS = [
  'PDT_CD', 'CUT_WDT', 'CUT_HGH', 'WRK_WDT', 'WRK_HGH',
  'ORD_CNT', 'PRN_CNT', 'PRN_CLR_CNT', 'MTRL_CD',
  'PAGE_CNT', 'CVR_CLR_CNT', 'INN_CLR_CNT', 'CVR_MTRL_CD', 'INN_MTRL_CD',
] as const;

const goldens = loadGoldens();

describe('V-PRICE 차등 하네스 (오라클=라이브 골든)', () => {
  it('골든 6종 로드', () => {
    expect(goldens.length).toBe(6);
  });

  // ─────────────────────────── VP-1 골든 strict 재생 (reqBody 직렬화 정합) ───────────────────────────
  describe('VP-1 emit reqBody ↔ 골든 reqBody', () => {
    for (const g of goldens) {
      for (const call of g.calls) {
        // incomplete 가드 케이스는 직렬화 재생 대상 아님(역구성 시 가드가 다른 경로) — VP-3 에서 별도 검사.
        if (call.label.includes('incomplete')) continue;
        it(`${g.scenario}/${g.productCode} [${call.label}] ORD_INFO 가격필드 정합`, () => {
          const emitted = serializeRedPriceRequest(reqFromGolden(g, call));
          const eo = emitted.dataJson.ORD_INFO[0] as Record<string, unknown>;
          const go = call.reqBody.dataJson.ORD_INFO[0] as unknown as Record<string, unknown>;
          for (const k of ORD_PRICE_FIELDS) {
            // 골든에 없는 필드는 어댑터도 미출력(undefined) 이어야 함(발명 금지).
            if (go[k] === undefined) {
              expect(eo[k], `${k} 발명 금지(골든 부재)`).toBeUndefined();
            } else {
              expect(eo[k], `${k} 값·타입 정합`).toStrictEqual(go[k]);
            }
          }
        });

        it(`${g.scenario}/${g.productCode} [${call.label}] price_gbn/mb_cust_cod/PCS_INFO 정합`, () => {
          const emitted = serializeRedPriceRequest(reqFromGolden(g, call));
          const dj = emitted.dataJson;
          const gj = call.reqBody.dataJson;
          expect(dj.price_gbn).toBe(gj.price_gbn);
          expect(dj.mb_cust_cod).toBe(gj.mb_cust_cod);
          // PCS_COD/PCS_DTL_COD 순서·값 정합
          expect(dj.PCS_INFO.map((p) => `${p.PCS_COD}:${p.PCS_DTL_COD}`)).toStrictEqual(
            gj.PCS_INFO.map((p) => `${p.PCS_COD}:${p.PCS_DTL_COD}`),
          );
          // ATTB 값·타입 정합 (다형 echo) — 타입까지 strict.
          dj.PCS_INFO.forEach((p, i) => {
            const gp = gj.PCS_INFO[i];
            const eAttb = (p as Record<string, unknown>).ATTB;
            const gAttb = (gp as unknown as Record<string, unknown>).ATTB;
            // 골든 ATTB '' ↔ 어댑터 '' 정합; 비'' 는 값·타입 대조.
            expect(eAttb ?? '', `PCS[${i}] ${p.PCS_COD} ATTB`).toStrictEqual(gAttb ?? '');
          });
        });
      }
    }
  });

  // ─────────────────────────── VP-2 라이브 차등 (result_sum.PRICE/PRICE_VAT) ───────────────────────────
  describe('VP-2 mapPriceResponse finalPrice/vat ↔ 골든 result_sum', () => {
    for (const g of goldens) {
      for (const call of g.calls) {
        if (call.label.includes('incomplete')) continue;
        it(`${g.scenario}/${g.productCode} [${call.label}] finalPrice=${call.result_sum.PRICE}`, () => {
          const out = mapPriceResponse(resFromGolden(call));
          // result_sum 권위(PRICE_MALL==PRICE==ORG_PRICE 동일군 → finalPrice=PRICE).
          expect(out.finalPrice).toBe(call.result_sum.PRICE);
          expect(out.vat).toBe(call.result_sum.PRICE_VAT);
        });
      }
    }
  });

  // ─────────────────────────── VP-3 PRICE≠0 sanity + incomplete 가드 ───────────────────────────
  describe('VP-3 정상경로 PRICE≠0; incomplete=ok:false 차단', () => {
    for (const g of goldens) {
      for (const call of g.calls) {
        const isIncomplete = call.label.includes('incomplete');
        it(`${g.scenario}/${g.productCode} [${call.label}] ${isIncomplete ? 'incomplete→ok:false' : 'PRICE>0'}`, () => {
          const out = mapPriceResponse(resFromGolden(call));
          if (isIncomplete) {
            // 라이브가 0 을 반환한 incomplete reqBody → 어댑터는 ok:false 로 차단(침묵 0 금지).
            expect(call.result_sum.PRICE).toBe(0); // 골든 사실
            expect(out.ok).toBe(false);
            expect(out.priceUnavailableReason).toBeDefined();
          } else {
            // 정상경로는 라이브 PRICE>0 이고 어댑터 ok:true.
            expect(call.result_sum.PRICE).toBeGreaterThan(0);
            expect(out.ok).toBe(true);
            expect(out.finalPrice).toBeGreaterThan(0);
          }
        });
      }
    }
  });

  // ─────────────────────────── VP-4 result_sum 권위 (per-line 0 무시) ───────────────────────────
  describe('VP-4 가격은 result_sum 에서만 — per-line 0 합법', () => {
    // GSTGMIC: PRT_DFT 외 전 per-line=0, sum=13600. 어댑터가 per-line 합산하지 않고 result_sum 읽음.
    const gtd = goldens.find((g) => g.productCode === 'GSTGMIC')!;
    const call = gtd.calls.find((c) => c.label === 'PRN_CNT=2')!;
    it('GSTGMIC per-line(PRT_DFT 외 0)에도 finalPrice=result_sum.PRICE=13600', () => {
      const perLineSum = call.perLine.reduce((a, l) => a + l.PRICE, 0);
      const out = mapPriceResponse(resFromGolden(call));
      expect(call.perLine.filter((l) => l.PRICE === 0).length).toBeGreaterThan(0); // per-line 0 존재
      expect(out.finalPrice).toBe(call.result_sum.PRICE); // 13600
      expect(out.finalPrice).toBe(perLineSum); // 본 케이스는 우연히 동일(PRT_DFT 단독) — 권위는 result_sum
    });
  });

  // ─────────────────────────── VP-5 메타모픽 (단조성·정확배수) ───────────────────────────
  describe('VP-5 메타모픽 — 골든 sweep 단조증가·배수', () => {
    it('GSTGMIC tiered: PRN_CNT↑ ⇒ finalPrice 단조증가', () => {
      const g = goldens.find((x) => x.productCode === 'GSTGMIC')!;
      const seq = g.calls
        .filter((c) => !c.label.includes('incomplete'))
        .map((c) => ({ prn: c.reqBody.dataJson.ORD_INFO[0].PRN_CNT!, price: mapPriceResponse(resFromGolden(c)).finalPrice }))
        .sort((a, b) => a.prn - b.prn);
      for (let i = 1; i < seq.length; i++) {
        expect(seq[i].price, `PRN_CNT ${seq[i].prn} > ${seq[i - 1].prn}`).toBeGreaterThan(seq[i - 1].price);
      }
    });

    it('GSPUFBC tmpl: ORD_CNT 선형 — ORD1 단가 × N = ORDN', () => {
      const g = goldens.find((x) => x.productCode === 'GSPUFBC')!;
      const byOrd = new Map<number, number>();
      for (const c of g.calls) {
        if (c.label.includes('incomplete')) continue;
        byOrd.set(c.reqBody.dataJson.ORD_INFO[0].ORD_CNT!, mapPriceResponse(resFromGolden(c)).finalPrice);
      }
      const unit = byOrd.get(1)!;
      expect(byOrd.get(10)).toBe(unit * 10);
      expect(byOrd.get(100)).toBe(unit * 100);
    });

    it('PRBKYPR book: PAGE_CNT↑ ⇒ finalPrice 단조증가', () => {
      const g = goldens.find((x) => x.productCode === 'PRBKYPR')!;
      const seq = g.calls
        .map((c) => ({ page: c.reqBody.dataJson.ORD_INFO[0].PAGE_CNT!, price: mapPriceResponse(resFromGolden(c)).finalPrice }))
        .sort((a, b) => a.page - b.page);
      for (let i = 1; i < seq.length; i++) {
        expect(seq[i].price, `PAGE ${seq[i].page}`).toBeGreaterThan(seq[i - 1].price);
      }
    });

    it('STPADPN fixed: size↑(140x200→210x297) ⇒ finalPrice 증가', () => {
      const g = goldens.find((x) => x.productCode === 'STPADPN')!;
      const small = g.calls.find((c) => c.reqBody.dataJson.ORD_INFO[0].CUT_WDT === 140)!;
      const big = g.calls.find((c) => c.reqBody.dataJson.ORD_INFO[0].CUT_WDT === 210)!;
      expect(mapPriceResponse(resFromGolden(big)).finalPrice).toBeGreaterThan(mapPriceResponse(resFromGolden(small)).finalPrice);
    });

    it('동일입력 ⇒ 동일출력 (직렬화 결정성) — 전 골든 케이스', () => {
      for (const g of goldens) {
        for (const call of g.calls) {
          if (call.label.includes('incomplete')) continue;
          const a = JSON.stringify(serializeRedPriceRequest(reqFromGolden(g, call)));
          const b = JSON.stringify(serializeRedPriceRequest(reqFromGolden(g, call)));
          expect(a).toBe(b);
        }
      }
    });
  });

  // ─────────────────────────── VP-6 필드사전 정합 (발명 필드 0) ───────────────────────────
  describe('VP-6 어댑터 emit 필드 ⊆ 필드사전 ∧ 골든 reqBody', () => {
    // re-contract-price.md §1 ORD_INFO 사전 + §1c 최상위. DOSU_COD 는 사전에 있으나 어댑터 omit(허용).
    const DICT_ORD = new Set([
      'PDT_CD', 'CUT_WDT', 'CUT_HGH', 'WRK_WDT', 'WRK_HGH', 'ORD_CNT', 'PRN_CNT',
      'PRN_CLR_CNT', 'MTRL_CD', 'DOSU_COD', 'PAGE_CNT', 'CVR_CLR_CNT', 'INN_CLR_CNT',
      'CVR_MTRL_CD', 'INN_MTRL_CD',
    ]);
    const DICT_PCS = new Set(['PCS_COD', 'PCS_DTL_COD', 'ATTB', 'ATTB_2', 'ATTB_3']);
    const DICT_TOP = new Set(['ORD_INFO', 'PCS_INFO', 'price_gbn', 'mb_cust_cod']);

    for (const g of goldens) {
      for (const call of g.calls) {
        if (call.label.includes('incomplete')) continue;
        it(`${g.scenario}/${g.productCode} [${call.label}] 발명 필드 0`, () => {
          const dj = serializeRedPriceRequest(reqFromGolden(g, call)).dataJson;
          for (const k of Object.keys(dj)) expect(DICT_TOP.has(k), `top ${k}`).toBe(true);
          for (const k of Object.keys(dj.ORD_INFO[0])) expect(DICT_ORD.has(k), `ord ${k}`).toBe(true);
          for (const p of dj.PCS_INFO) {
            for (const k of Object.keys(p)) expect(DICT_PCS.has(k), `pcs ${k}`).toBe(true);
          }
        });
      }
    }
  });
});
