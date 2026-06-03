// F-2 회귀 가드 — serializeRedPriceRequest 출력 reqBody SHAPE 가 라이브 캡처 실측 reqBody 와
//  field-for-field 정합하는지 검증한다. 이전 76 테스트는 직렬화 출력 shape 를 "실 캡처"와 대조한
//  테스트가 전무했기에(fixture 가 HTTP 우회·reqBody 무시) dataJson 래퍼·mb_cust_cod 누락 갭이
//  침묵 통과했다. 이 테스트가 그 latent 갭을 영구 봉인한다.
//
//  AUTHORITY:
//   - captures/b1_AIPPCUT.json reqBody (전 호출이 `{dataJson:{ORD_INFO,...,mb_cust_cod}}` 형태)
//   - data-adapter.md:80-86 (dataJson 래퍼 + mb_cust_cod + 책자 분리필드 CVR_/INN_*/PAGE_CNT)
//
//  [HARD] DOSU_COD 는 의도 omit(OPEN-1) — PRN_CLR_CNT 가 도수 가격의미 운반. shape 대조에서 제외.
//  [HARD] 가드(ORD_CNT && PRN_CNT) 불변 — 별도 cell 로 재확인.
import { describe, it, expect } from 'vitest';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  mapProduct,
  serializeRedPriceRequest,
} from '@/adapters/red/red-adapter';
import { buildPriceRequest } from '@/widget/stores/price';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type { NormalizedPriceRequest } from '@/contract';
import productAIPPCUT from '../fixtures/product_AIPPCUT.json';

// 캡처는 04_build 외부(05_qa/captures). tsconfig include 밖이라 import 대신 런타임 fs 로 실측 로드.
const CAPTURE_PATH = resolve(__dirname, '../../05_qa/captures/b1_AIPPCUT.json');

interface CapturedCall {
  reqBody: string;
}
interface Capture {
  widgetPriceCalls: CapturedCall[];
}

function loadCapturedReqBody(): Record<string, unknown> {
  const cap = JSON.parse(readFileSync(CAPTURE_PATH, 'utf8')) as Capture;
  // rel 2893 = 완전호출(ORD_CNT=1, PRN_CNT=1 둘 다 존재, PCS 3종). 두 번째 호출.
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

describe('F-2 직렬화 shape 정합 — serializeRedPriceRequest ↔ 라이브 캡처 reqBody (b1_AIPPCUT)', () => {
  it('출력 최상위는 `{dataJson:{...}}` 래퍼 (캡처 전 호출 동일) — bare {ORD_INFO,...} 금지', () => {
    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: {
        GRP_SIZE: def.valueId,
        PCS_SUB_MTR: 'EC001',
        PCS_CUT_ZUN: 'ZDFRM',
        PCS_BON_SHT: 'SHECO',
      },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const req: NormalizedPriceRequest = { ...buildPriceRequest(state), printCount: 1 };
    const body = serializeRedPriceRequest(req);

    // 최상위 키 = ['dataJson'] 단일. (이전 F-2: 최상위가 ORD_INFO/PCS_INFO/price_gbn 였음)
    expect(Object.keys(body)).toEqual(['dataJson']);
    expect(body.dataJson).toBeDefined();
    expect(Array.isArray(body.dataJson.ORD_INFO)).toBe(true);
  });

  it('dataJson 내부 키셋 = 캡처 reqBody.dataJson 키셋 (ORD_INFO/PCS_INFO/price_gbn/mb_cust_cod)', () => {
    const captured = loadCapturedReqBody();
    const capturedInner = captured.dataJson as Record<string, unknown>;
    const capturedKeys = Object.keys(capturedInner).sort();

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_SUB_MTR: 'EC001', PCS_CUT_ZUN: 'ZDFRM', PCS_BON_SHT: 'SHECO' },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const ourKeys = Object.keys(body.dataJson).sort();

    // 캡처: ORD_INFO, PCS_INFO, price_gbn, mb_cust_cod. 우리 출력도 동일 키셋.
    expect(ourKeys).toEqual(capturedKeys);
    expect(ourKeys).toEqual(['ORD_INFO', 'PCS_INFO', 'mb_cust_cod', 'price_gbn']);
  });

  it('mb_cust_cod 출력 = customerTier (캡처 "10000000") — 누락 시 Red 침묵0 위험', () => {
    const captured = loadCapturedReqBody();
    const capturedCust = (captured.dataJson as Record<string, unknown>).mb_cust_cod;
    expect(capturedCust).toBe('10000000');

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, { selections: { GRP_SIZE: def.valueId }, member: { tier: '10000000' }, quantity: 1 });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    expect(body.dataJson.mb_cust_cod).toBe('10000000');

    // customerTier 미전달 → 비회원 공개가 '10000000' 기본(data-adapter.md:86).
    const stateNoTier = stateOf(p, { selections: { GRP_SIZE: def.valueId }, quantity: 1 });
    const bodyNoTier = serializeRedPriceRequest({ ...buildPriceRequest(stateNoTier), printCount: 1 });
    expect(bodyNoTier.dataJson.mb_cust_cod).toBe('10000000');
  });

  it('ORD_INFO 가격필드 = 캡처 (PDT_CD/CUT/WRK/ORD_CNT/PRN_CNT/PRN_CLR_CNT/MTRL_CD)', () => {
    const captured = loadCapturedReqBody();
    const capturedOrd = (captured.dataJson as { ORD_INFO: Array<Record<string, unknown>> }).ORD_INFO[0];

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: {
        GRP_SIZE: def.valueId,
        GRP_MTRL_COVER: 'PXPLP001', // 자재(MTRL_CD)
        GRP_DOSU_COVER: 'SID_X', // 도수 SID_X(인쇄없음, priceColorCount=0)
        PCS_SUB_MTR: 'EC001',
        PCS_CUT_ZUN: 'ZDFRM',
        PCS_BON_SHT: 'SHECO',
      },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const ord = body.dataJson.ORD_INFO[0];

    expect(ord.PDT_CD).toBe(capturedOrd.PDT_CD); // AIPPCUT
    expect(ord.CUT_WDT).toBe(capturedOrd.CUT_WDT); // 300
    expect(ord.CUT_HGH).toBe(capturedOrd.CUT_HGH); // 340
    expect(ord.WRK_WDT).toBe(capturedOrd.WRK_WDT); // 300 (CUT_MRG=0)
    expect(ord.WRK_HGH).toBe(capturedOrd.WRK_HGH); // 340
    expect(ord.ORD_CNT).toBe(capturedOrd.ORD_CNT); // 1
    expect(ord.PRN_CNT).toBe(capturedOrd.PRN_CNT); // 1
    expect(ord.PRN_CLR_CNT).toBe(capturedOrd.PRN_CLR_CNT); // 0 (SID_X 인쇄없음)
    expect(ord.MTRL_CD).toBe(capturedOrd.MTRL_CD); // PXPLP001
    // 단일면(에코백)은 책자 분리필드 미출력 — 캡처에도 부재.
    expect(ord.CVR_CLR_CNT).toBeUndefined();
    expect(ord.INN_CLR_CNT).toBeUndefined();
    expect(ord.PAGE_CNT).toBeUndefined();
  });

  it('price_gbn echo = 캡처 (real_price) — 불투명 echo 정합', () => {
    const captured = loadCapturedReqBody();
    const capturedScheme = (captured.dataJson as Record<string, unknown>).price_gbn;
    expect(capturedScheme).toBe('real_price');

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, { selections: { GRP_SIZE: def.valueId }, member: { tier: '10000000' }, quantity: 1 });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    expect(body.dataJson.price_gbn).toBe('real_price');
  });

  it('PCS_INFO 역매핑 (PCS_ prefix 제거) = 캡처 PCS_COD 집합 (SUB_MTR/CUT_ZUN/BON_SHT)', () => {
    const captured = loadCapturedReqBody();
    const capturedCods = (captured.dataJson as { PCS_INFO: Array<{ PCS_COD: string }> }).PCS_INFO
      .map((f) => f.PCS_COD)
      .sort();

    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 300 && r.cutH === 340)!;
    const state = stateOf(p, {
      selections: { GRP_SIZE: def.valueId, PCS_SUB_MTR: 'EC001', PCS_CUT_ZUN: 'ZDFRM', PCS_BON_SHT: 'SHECO' },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const ourCods = body.dataJson.PCS_INFO.map((f) => f.PCS_COD).sort();
    expect(ourCods).toEqual(capturedCods);
  });
});

describe('F-2 책자 분리필드 — 책자(inner side) 요청은 CVR_/INN_*/PAGE_CNT 출력 (data-adapter.md:81-84)', () => {
  // 책자 요청을 직접 구성(inner 자재/색 + pageCount 존재 → 책자 판정).
  function bookRequest(): NormalizedPriceRequest {
    return {
      productCode: 'PRBKYPR',
      priceSchemeKey: 'book2025_price',
      customerTier: '10000000',
      dimensions: [{ side: 'default', cutW: 210, cutH: 297, workW: 216, workH: 303 }],
      colorCounts: { default: 8, inner: 8 }, // 표지/내지 색
      materials: { default: 'CVR_MTRL_X', inner: 'INN_MTRL_X' }, // 표지/내지 자재
      quantity: 1,
      printCount: 30,
      pageCount: 24,
      selectedFinishes: [],
    };
  }

  it('책자 → ORD_INFO 에 PAGE_CNT/CVR_CLR_CNT/INN_CLR_CNT/CVR_MTRL_CD/INN_MTRL_CD 출력', () => {
    const body = serializeRedPriceRequest(bookRequest());
    const ord = body.dataJson.ORD_INFO[0];
    expect(ord.PAGE_CNT).toBe(24);
    expect(ord.CVR_CLR_CNT).toBe(8);
    expect(ord.INN_CLR_CNT).toBe(8);
    expect(ord.CVR_MTRL_CD).toBe('CVR_MTRL_X');
    expect(ord.INN_MTRL_CD).toBe('INN_MTRL_X');
    // 책자도 dataJson 래퍼 + mb_cust_cod 정합.
    expect(Object.keys(body)).toEqual(['dataJson']);
    expect(body.dataJson.mb_cust_cod).toBe('10000000');
  });

  it('단일면(inner 부재) → 책자 분리필드 미출력 (회귀: 굿즈에 CVR_/INN_ 누출 금지)', () => {
    const single: NormalizedPriceRequest = {
      productCode: 'GSPUFBC',
      priceSchemeKey: 'tmpl_price',
      dimensions: [{ side: 'default', cutW: 230, cutH: 288, workW: 250, workH: 308 }],
      colorCounts: { default: 4 },
      materials: { default: 'PXFBW010' },
      quantity: 100,
      selectedFinishes: [],
    };
    const ord = serializeRedPriceRequest(single).dataJson.ORD_INFO[0];
    expect(ord.PAGE_CNT).toBeUndefined();
    expect(ord.CVR_CLR_CNT).toBeUndefined();
    expect(ord.INN_CLR_CNT).toBeUndefined();
    expect(ord.CVR_MTRL_CD).toBeUndefined();
    expect(ord.INN_MTRL_CD).toBeUndefined();
  });
});
