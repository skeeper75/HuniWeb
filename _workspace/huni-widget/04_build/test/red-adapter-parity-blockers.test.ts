// STAGE S3 BLOCKER 회귀 가드 — L-1(ATTB)·L-2(COT_DFT 복합2축)·D-L3(침묵 PRICE=0) 재현 동등성.
//  코드레벨 정합검증(parity-matrix-D1/D4)이 찾은 3 BLOCKER 의 수정을 영구 봉인한다.
//
//  AUTHORITY:
//   - L-1 ATTB: parity-matrix-D1-price.md §2 (ATTB 다형·출처) + captures/b1_AIPPCUT.json reqBody(SUB_MTR ATTB=수량)
//   - L-2 COT_DFT: parity-matrix-D4-internal-cascade.md §2 SPEC-L2 (side=slice(-1)/coating=slice(0,4), 재합성=coating+side)
//   - D-L3: parity-matrix-D1-price.md D1-13/D-L3 (Red `!result_sum.PRICE → 주문불가` mod_06:1167)
import { describe, it, expect } from 'vitest';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  mapProduct,
  mapPriceResponse,
  serializeRedPriceRequest,
} from '@/adapters/red/red-adapter';
import { buildPriceRequest } from '@/widget/stores/price';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import productAIPPCUT from '../fixtures/product_AIPPCUT.json';
import productSTTHCIC from '../fixtures/product_STTHCIC.json';

const CAPTURE_PATH = resolve(__dirname, '../../05_qa/captures/b1_AIPPCUT.json');

interface Capture {
  widgetPriceCalls: Array<{ reqBody: string }>;
}

// 캡처 rel 2893 = 완전호출(ORD_CNT=1, PRN_CNT=1) reqBody.
function loadCapturedReqBody(): Record<string, unknown> {
  const cap = JSON.parse(readFileSync(CAPTURE_PATH, 'utf8')) as Capture;
  const complete = cap.widgetPriceCalls.find((c) => {
    const b = JSON.parse(c.reqBody) as { dataJson?: { ORD_INFO?: Array<Record<string, unknown>> } };
    const ord = b.dataJson?.ORD_INFO?.[0];
    return ord?.ORD_CNT === 1 && ord?.PRN_CNT === 1;
  });
  expect(complete).toBeDefined();
  return JSON.parse(complete!.reqBody) as Record<string, unknown>;
}

function stateOf(product: ReturnType<typeof mapProduct>, overrides: Partial<WidgetState>): WidgetState {
  return {
    product,
    member: {},
    selections: {},
    dimensionInputs: {},
    quantity: 1,
    ...overrides,
  } as WidgetState;
}

// ─────────────────────────────────────────────────────────────────────────────
// L-1 ATTB — 전손실(ATTB:'' 하드코딩) 해소: 직렬화 ATTB 가 캡처 실측값과 정합.
// ─────────────────────────────────────────────────────────────────────────────
describe('L-1 ATTB 정합 — serializeRedPriceRequest ATTB ↔ 캡처 reqBody (수량형 SUB_MTR)', () => {
  it('SUB_MTR(수량형) → ATTB = 주문수량 echo + ATTB_2/3 빈슬롯 (캡처 정합, ATTB:\'\' 하드코딩 제거)', () => {
    const captured = loadCapturedReqBody();
    const capturedSub = (captured.dataJson as { PCS_INFO: Array<Record<string, unknown>> }).PCS_INFO.find(
      (p) => p.PCS_COD === 'SUB_MTR',
    )!;
    // 캡처 실측: SUB_MTR ATTB=1(수량), ATTB_2='', ATTB_3=''.
    expect(capturedSub.ATTB).toBe(1);
    expect(capturedSub.ATTB_2).toBe('');
    expect(capturedSub.ATTB_3).toBe('');

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_SUB_MTR: 'EC001', PCS_CUT_ZUN: 'ZDFRM', PCS_BON_SHT: 'SHECO' },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const sub = body.dataJson.PCS_INFO.find((f) => f.PCS_COD === 'SUB_MTR')!;
    // 우리 ATTB 는 수량 echo(quantity=1) → 캡처값과 동치(숫자 vs 문자열은 직렬화 echo 차이, 값 동일).
    expect(sub.ATTB).toBe('1'); // 이전 결함: '' (속성 없음 단가 → 오산)
    expect(String(sub.ATTB)).toBe(String(capturedSub.ATTB));
    expect(sub.ATTB_2).toBe('');
    expect(sub.ATTB_3).toBe('');
  });

  it('비수량형 후가공(CUT_ZUN/BON_SHT)은 ATTB:\'\' + ATTB_2/3 키 부재 (캡처 정합)', () => {
    const captured = loadCapturedReqBody();
    const capturedCut = (captured.dataJson as { PCS_INFO: Array<Record<string, unknown>> }).PCS_INFO.find(
      (p) => p.PCS_COD === 'CUT_ZUN',
    )!;
    // 캡처: CUT_ZUN 은 ATTB='' 만, ATTB_2/3 키 없음.
    expect(capturedCut.ATTB).toBe('');
    expect('ATTB_2' in capturedCut).toBe(false);

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_SUB_MTR: 'EC001', PCS_CUT_ZUN: 'ZDFRM', PCS_BON_SHT: 'SHECO' },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const cut = body.dataJson.PCS_INFO.find((f) => f.PCS_COD === 'CUT_ZUN')!;
    expect(cut.ATTB).toBe('');
    expect('ATTB_2' in cut).toBe(false); // 비수량형은 ATTB_2/3 슬롯 미출력
    expect('ATTB_3' in cut).toBe(false);
  });

  it('ATTB 수량 echo 는 주문수량을 따른다 (quantity=5 → ATTB=\'5\')', () => {
    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_SUB_MTR: 'EC001' },
      member: { tier: '10000000' },
      quantity: 5,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const sub = body.dataJson.PCS_INFO.find((f) => f.PCS_COD === 'SUB_MTR')!;
    expect(sub.ATTB).toBe('5');
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// L-2 COT_DFT/SCO_DFT — 복합 2축 분해→재합성 round-trip.
// ─────────────────────────────────────────────────────────────────────────────
describe('L-2 COT_DFT/SCO_DFT 복합 2축 — 어댑터 분해 + 직렬화 재합성 round-trip', () => {
  it('어댑터: COT_DFT → side(option-button) + coating(finish-button) 2그룹 분해', () => {
    const p = mapProduct(productSTTHCIC as unknown as RedDigitalProductResponse);
    const sideG = p.optionGroups.find((g) => g.id === 'PCS_COT_DFT__side')!;
    const coatG = p.optionGroups.find((g) => g.id === 'PCS_COT_DFT__coating')!;
    expect(sideG).toBeDefined();
    expect(coatG).toBeDefined();
    expect(sideG.componentType).toBe('option-button');
    expect(coatG.componentType).toBe('finish-button');
    // side 값 = distinct slice(-1) (단면 S), coating 값 = distinct slice(0,4) (TCMA/TCGL).
    expect(sideG.values.map((v) => v.id)).toContain('S');
    expect(coatG.values.map((v) => v.id)).toEqual(expect.arrayContaining(['TCMA', 'TCGL']));
    // 평면 단일 PCS_COT_DFT 그룹은 더 이상 존재하지 않음(분해됨).
    expect(p.optionGroups.find((g) => g.id === 'PCS_COT_DFT')).toBeUndefined();
  });

  it('직렬화 재합성: coating(TCMA)+side(S) → 단일 PCS_DTL_COD=TCMAS (Red 합성코드 복원)', () => {
    const p = mapProduct(productSTTHCIC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules[0]!;
    const state = stateOf(p, {
      selections: {
        GRP_SIZE: def.valueId,
        PCS_COT_DFT__side: 'S', // 단면
        PCS_COT_DFT__coating: 'TCMA', // 무광코팅
      },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    // 2개 별도 엔트리가 아니라 1개 재합성 엔트리(PCS_COD=COT_DFT, PCS_DTL_COD=TCMAS).
    const cot = body.dataJson.PCS_INFO.filter((f) => f.PCS_COD === 'COT_DFT');
    expect(cot.length).toBe(1);
    expect(cot[0].PCS_DTL_COD).toBe('TCMAS'); // coating+side = 원본 PCS_DTL_CD round-trip
    // 반쪽코드(S 또는 TCMA 단독)가 새어나가지 않음.
    expect(body.dataJson.PCS_INFO.some((f) => f.PCS_DTL_COD === 'S' || f.PCS_DTL_COD === 'TCMA')).toBe(false);
  });

  it('한 축만 선택되면 재합성 안 함 (불완전 조합 누출 방지)', () => {
    const p = mapProduct(productSTTHCIC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules[0]!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_COT_DFT__coating: 'TCGL' }, // side 미선택
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    expect(body.dataJson.PCS_INFO.some((f) => f.PCS_COD === 'COT_DFT')).toBe(false);
  });

  it('SCO_DFT 도 동일 재합성 (DFXX+S → DFXXS)', () => {
    const p = mapProduct(productSTTHCIC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules[0]!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_SCO_DFT__side: 'S', PCS_SCO_DFT__coating: 'DFXX' },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const sco = body.dataJson.PCS_INFO.filter((f) => f.PCS_COD === 'SCO_DFT');
    expect(sco.length).toBe(1);
    expect(sco[0].PCS_DTL_COD).toBe('DFXXS');
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// D-L3 침묵 PRICE=0 차단 — mapPriceResponse ok 게이트.
// ─────────────────────────────────────────────────────────────────────────────
describe('D-L3 침묵 PRICE=0 차단 — mapPriceResponse ok = retCode===200 && finalPrice>0', () => {
  function priceRes(price: number, retCode = 200): RedPriceResponse {
    return {
      retCode,
      result: [],
      result_sum: {
        PRICE: price, PRICE_VAT: 0, PRICE_MALL: price, PRICE_MALL_VAT: 0, ORG_PRICE: price, ORG_PRICE_VAT: 0,
      },
    } as RedPriceResponse;
  }

  it('PRICE=0 (retCode 200) → ok:false (침묵 0원 주문 차단, Red mod_06:1167)', () => {
    const b = mapPriceResponse(priceRes(0));
    expect(b.ok).toBe(false);
    expect(b.finalPrice).toBe(0);
  });

  it('PRICE>0 (retCode 200) → ok:true (정상 견적)', () => {
    const b = mapPriceResponse(priceRes(3300));
    expect(b.ok).toBe(true);
    expect(b.finalPrice).toBe(3300);
  });

  it('retCode!==200 → ok:false (가격 양수여도)', () => {
    const b = mapPriceResponse(priceRes(3300, 999));
    expect(b.ok).toBe(false);
  });
});
