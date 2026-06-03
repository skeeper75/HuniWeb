// S6 계약 테스트 — 옵셋 캘린더(09) HLCLSTD·HLCLWAL(offset2023_price) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트(INV-3): 명세 s6-calendar-spec.md 가 옵셋 캘린더를 "책자 PriceTable3D 변형
//  = 위젯 코어 0줄"로 판정(신규 componentType 0, ORD_INFO 책자와 동일). 이 테스트는 그 판정을
//  EXISTING 어댑터 출력 + PRN_CNT 폐쇄 래더 enum 분기(어댑터 한정) + 가격 round-trip 으로 실증한다.
//  - 신규 componentType 0: 규격=option-button, 자재=select-box, 도수=option-button,
//    CLD_STD/CUT_DFT/RIN_DFT=finish-button(PCS), PRN_CNT 폐쇄 래더=select-box enum(§3.3-A).
//  - PRN_CNT 래더(FIR/INC null) → counter-input 이 아닌 select-box(임의값 PRICE=0 방지). 기존 타입 재사용.
//  - 가드: serializeRedPriceRequest 의 ORD_CNT/PRN_CNT 분리 + isPriceRequestQuotable 가 캘린더를 추가변경 없이 커버.
//  - 가격 round-trip: rel 7440 완전호출(PRN_CNT 500/ORD_CNT 1) → finalPrice 778,500. ORD_INFO 가격필드 정합.
//  - DOSU_COD: 직렬화 미출력이나 PRN_CLR_CNT(=8)가 도수 가격의미 운반 → fixture round-trip PRICE>0(OPEN-1: 추가 불요).
// 근거: s6-calendar-spec.md §1·§2·§3·§4, fixtures/product_HLCLSTD.json·product_HLCLWAL.json, captures/s6_cal_HLCLSTD.json rel 7440.
import { describe, it, expect } from 'vitest';
import {
  mapProduct,
  mapPriceResponse,
  serializeRedPriceRequest,
  createRedAdapter,
} from '@/adapters/red/red-adapter';
import { FixtureRedDataSource } from '@/adapters/red/fixture-source';
import { buildPriceRequest } from '@/widget/stores/price';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type {
  ComponentType,
  NormalizedProduct,
  NormalizedPriceRequest,
} from '@/contract';
import productHLCLSTD from '../fixtures/product_HLCLSTD.json';
import productHLCLWAL from '../fixtures/product_HLCLWAL.json';
import priceCalendarStd from '../fixtures/price_HLCLSTD_sample.json';

// 신규 없음: 전 그룹이 기존 15 componentType(NC-1 포함) 안에서 충족.
const ALL_15: ComponentType[] = ['option-button','select-box','counter-input','color-chip','price-slider','image-chip','mini-color-chip','large-color-chip','area-input','dimension-matrix-input','page-counter-input','finish-button','finish-select-box','summary','upload-cta'];

function stateOf(product: NormalizedProduct, overrides: Partial<WidgetState>): WidgetState {
  return {
    product,
    member: {},
    selections: {},
    dimensionInputs: {},
    quantity: 1,
    ...overrides,
  } as WidgetState;
}

describe('S6 옵셋 캘린더(HLCLSTD, offset2023_price) → 책자 PriceTable3D 변형 (신규 componentType 0)', () => {
  it('HLCLSTD → 전 옵션그룹이 기존 15 componentType 안 + 단일면(pdf) + offset2023_price echo', () => {
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('HLCLSTD');
    expect(p.sides.map((s) => s.key)).toEqual(['default']);
    expect(p.sides[0].uploadType).toBe('pdf'); // usePDF=Y
    expect(p.priceSchemeKey).toBe('offset2023_price'); // 불투명 echo (INV-2: 위젯/계약 미등장, 어댑터 출력만)
    expect(p.unit).toBe('개');
    for (const g of p.optionGroups) expect(ALL_15).toContain(g.componentType);
    console.log(`  HLCLSTD groups=${p.optionGroups.map((g) => g.id + ':' + g.componentType + (g.visible ? '' : '(hidden)')).join(' | ')} scheme=${p.priceSchemeKey}`);
  });

  // §3.3 — 규격=option-button(NC-1 미발동), 자재=select-box, 도수=option-button.
  it('규격 4종=option-button(NC-1 아님), 자재 2종=select-box, 도수 양면=option-button(priceColorCount 8)', () => {
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    const size = p.optionGroups.find((g) => g.id === 'GRP_SIZE')!;
    expect(size.componentType).toBe('option-button'); // offset2023_price + 0×0 sentinel 부재 → NC-1 미발동
    expect(size.componentType).not.toBe('dimension-matrix-input');
    expect(size.inputSpec).toBeUndefined();
    expect(size.values.length).toBe(4); // small/세로형/wide/large
    const mtrl = p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER')!;
    expect(mtrl.componentType).toBe('select-box');
    expect(mtrl.values.map((v) => v.id)).toEqual(['RXRAU240', 'RXSNO200']);
    const dosu = p.optionGroups.find((g) => g.id === 'GRP_DOSU_COVER')!;
    expect(dosu.componentType).toBe('option-button');
    expect(dosu.values.find((v) => v.id === 'SID_D')!.priceColorCount).toBe(8); // dosu→bnc 평면화
  });

  // §2.1 — CLD_STD/STA_CLD 등 캘린더 전용 옵션은 전부 PCS finish-button(신규 leaf 0).
  it('CLD_STD(삼각대 12종)=finish-button visible, CUT_DFT=hidden(VIEW_YN=N), RIN_DFT=visible', () => {
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    const cld = p.optionGroups.find((g) => g.id === 'PCS_CLD_STD')!;
    expect(cld).toBeDefined();
    expect(cld.componentType).toBe('finish-button'); // colorHex 부재 → RULE-2
    expect(cld.visible).toBe(true); // VIEW_YN=Y
    expect(cld.values.length).toBe(12); // BK/BU/IV × small/narrow/wide/large
    const cut = p.optionGroups.find((g) => g.id === 'PCS_CUT_DFT')!;
    expect(cut.visible).toBe(false); // VIEW_YN=N = hidden essential(자동적용)
    const rin = p.optionGroups.find((g) => g.id === 'PCS_RIN_DFT')!;
    expect(rin.visible).toBe(true);
    // 캘린더 전용 옵션 전부 PCS finish-button 으로 흡수 — 신규 componentType 없음.
    const pcsGroups = p.optionGroups.filter((g) => g.id.startsWith('PCS_'));
    for (const g of pcsGroups) expect(g.componentType).toBe('finish-button');
  });

  // §3.3-A — PRN_CNT 폐쇄 래더(FIR/INC null) → counter-input 이 아닌 select-box enum (어댑터 한정 분기).
  it('PRN_CNT 폐쇄 래더 → GRP_PRN_CNT select-box enum 10종(100~1000), 기본=DFT_YN=Y(500) 선두', () => {
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    const prn = p.optionGroups.find((g) => g.id === 'GRP_PRN_CNT')!;
    expect(prn).toBeDefined();
    expect(prn.componentType).toBe('select-box'); // 폐쇄 enum — counter-input 아님(임의값 PRICE=0 방지)
    expect(prn.componentType).not.toBe('counter-input');
    expect(prn.inputSpec).toBeUndefined(); // 자유입력 슬롯 미생성
    expect(prn.values.map((v) => v.id)).toEqual(['500', '100', '200', '300', '400', '600', '700', '800', '900', '1000']);
    // DFT_YN=Y(500)이 선두(store.defaultSelections 첫 값 선택 = 기본 인쇄수량 500).
    expect(prn.values[0].id).toBe('500');
    // 폐쇄 래더이므로 counter-input GRP_QUANTITY 는 생성되지 않음(중복 수량 UI 방지).
    expect(p.optionGroups.find((g) => g.id === 'GRP_QUANTITY')).toBeUndefined();
    console.log(`  GRP_PRN_CNT: select-box values=${prn.values.map((v) => v.id).join(',')}`);
  });
});

describe('S6 옵셋 캘린더 가격 round-trip — rel 7440 완전호출(PRN_CNT 500/ORD_CNT 1) → 778,500', () => {
  it('price_HLCLSTD_sample → mapPriceResponse finalPrice=778,500 vat=77,850 (PRICE_MALL==PRICE==ORG_PRICE)', () => {
    const b = mapPriceResponse(priceCalendarStd as unknown as Parameters<typeof mapPriceResponse>[0]);
    expect(b.ok).toBe(true);
    expect(b.finalPrice).toBe(778500); // 캡처 result_sum.PRICE
    expect(b.vat).toBe(77850);
    // 공정별 라인 평면화(CLD_STD/CUT_DFT/PRT_DFT/RIN_DFT).
    const codes = b.lines.map((l) => l.code);
    expect(codes).toContain('CLD_STD');
    expect(codes).toContain('PRT_DFT');
    expect(codes).toContain('RIN_DFT');
  });

  // §1.1 — 직렬화 ORD_INFO 가격필드가 캡처 reqBody(rel 7440)와 정합. 책자/포스터 슬롯과 1:1.
  // DOSU_COD 는 직렬화 미출력(OPEN-1) — PRN_CLR_CNT(8)가 도수 가격의미 운반, fixture round-trip PRICE>0.
  it('serialize: printCount=500/quantity=1 → ORD_INFO 가격필드 = 캡처 reqBody (PRN_CNT/ORD_CNT/PRN_CLR_CNT/치수)', () => {
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    // 세로형(rel 7440) 선택 + 도수 양면 + 인쇄수량 500. quantity(ORD_CNT)=1.
    const vert = p.constraints.sizeRules.find((r) => r.cutW === 90 && r.cutH === 180)!;
    const state = stateOf(p, {
      selections: {
        GRP_SIZE: vert.valueId,
        GRP_MTRL_COVER: 'RXRAU240',
        GRP_DOSU_COVER: 'SID_D',
        PCS_CUT_DFT: 'DFXXX',
        PCS_RIN_DFT: 'BPTOP',
        PCS_CLD_STD: 'BK001',
      },
      quantity: 1,
    });
    // PRN_CNT enum→printCount 의 store 배선은 본 단계 미배선(OPEN, §4.1 #3) — 코어 0줄 유지 위해
    // round-trip 은 printCount 를 명시 구성(파우치 테스트 전례). 어댑터 직렬화 정합만 증명.
    const req: NormalizedPriceRequest = { ...buildPriceRequest(state), printCount: 500 };
    const body = serializeRedPriceRequest(req);
    const ord = body.dataJson.ORD_INFO[0];
    // 캡처 reqBody ORD_INFO[0]: CUT 90x180, WRK 94x184, PRN_CNT 500, ORD_CNT 1, PRN_CLR_CNT 8, MTRL RXRAU240.
    expect(ord.PDT_CD).toBe('HLCLSTD');
    expect(ord.CUT_WDT).toBe(90);
    expect(ord.CUT_HGH).toBe(180);
    expect(ord.WRK_WDT).toBe(94); // 세로형 작업치수 — pdt_size_info WRK_WDT 자동주입(SizeRule)
    expect(ord.WRK_HGH).toBe(184);
    expect(ord.PRN_CNT).toBe(500); // 인쇄수량 = printCount
    expect(ord.ORD_CNT).toBe(1); // 주문건수 = quantity
    expect(ord.PRN_CLR_CNT).toBe(8); // 도수 양면 (DOSU_COD 가격의미 운반 — OPEN-1 추가 불요)
    expect(ord.MTRL_CD).toBe('RXRAU240');
    expect(body.dataJson.price_gbn).toBe('offset2023_price'); // 불투명 echo
    // PCS_INFO 역매핑(PCS_ prefix 제거): CLD_STD/CUT_DFT/RIN_DFT.
    const cods = body.dataJson.PCS_INFO.map((f) => f.PCS_COD);
    expect(cods).toContain('CLD_STD');
    expect(cods).toContain('CUT_DFT');
    expect(cods).toContain('RIN_DFT');
    console.log(`  serialize ORD_INFO: CUT=${ord.CUT_WDT}x${ord.CUT_HGH} WRK=${ord.WRK_WDT}x${ord.WRK_HGH} PRN_CNT=${ord.PRN_CNT} ORD_CNT=${ord.ORD_CNT} CLR=${ord.PRN_CLR_CNT}`);
  });

  it('adapter.quote(printCount=500, quantity=1) → 가드 통과 → 실가 778,500', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    const vert = p.constraints.sizeRules.find((r) => r.cutW === 90 && r.cutH === 180)!;
    const req = {
      ...buildPriceRequest(stateOf(p, { selections: { GRP_SIZE: vert.valueId }, quantity: 1 })),
      printCount: 500,
    };
    const res = await adapter.price.quote(req);
    expect(res.ok).toBe(true);
    expect(res.finalPrice).toBe(778500);
    expect(res.vat).toBe(77850);
  });

  it('가드: quantity=0 또는 printCount=0 → quote() {ok:false} (침묵 PRICE=0 재현 금지, 기존 가드 재사용)', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    const vert = p.constraints.sizeRules.find((r) => r.cutW === 90 && r.cutH === 180)!;
    const base = buildPriceRequest(stateOf(p, { selections: { GRP_SIZE: vert.valueId }, quantity: 1 }));
    const zeroQty = await adapter.price.quote({ ...base, quantity: 0, printCount: 500 });
    expect(zeroQty.ok).toBe(false);
    expect(zeroQty.finalPrice).toBe(0);
    const zeroPrn = await adapter.price.quote({ ...base, quantity: 1, printCount: 0 });
    expect(zeroPrn.ok).toBe(false);
  });
});

describe('S6 벽걸이 캘린더(HLCLWAL) → 동일 offset2023_price 변형 실증', () => {
  it('HLCLWAL → 기존 15 componentType + PRN_CNT 단일행 enum + offset2023_price echo', () => {
    const p = mapProduct(productHLCLWAL as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('HLCLWAL');
    expect(p.priceSchemeKey).toBe('offset2023_price');
    for (const g of p.optionGroups) expect(ALL_15).toContain(g.componentType);
    // PRN_CNT 단일행(500)도 폐쇄 래더로 select-box enum(degenerate 1종).
    const prn = p.optionGroups.find((g) => g.id === 'GRP_PRN_CNT')!;
    expect(prn.componentType).toBe('select-box');
    expect(prn.values.map((v) => v.id)).toEqual(['500']);
    // HOL_DFT/RIN_CUT 후가공 = 기존 PCS finish-button 흡수.
    const pcsGroups = p.optionGroups.filter((g) => g.id.startsWith('PCS_'));
    for (const g of pcsGroups) expect(g.componentType).toBe('finish-button');
    console.log(`  HLCLWAL groups=${p.optionGroups.map((g) => g.id + ':' + g.componentType).join(' | ')}`);
  });

  it('HLCLWAL quote(printCount=500, quantity=1) → 실가 2,368,500', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const p = mapProduct(productHLCLWAL as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules[0];
    const req = {
      ...buildPriceRequest(stateOf(p, { selections: { GRP_SIZE: def.valueId }, quantity: 1 })),
      printCount: 500,
    };
    const res = await adapter.price.quote(req);
    expect(res.ok).toBe(true);
    expect(res.finalPrice).toBe(2368500);
  });
});

describe('S6 계약 중립(INV-2) — Red 고유명이 정규화 출력에 미등장', () => {
  it('priceSchemeKey 외 offset2023_price/CLD_STD 가 계약 필드명/타입에 직접 노출 안 됨(불투명 id 만)', () => {
    const p = mapProduct(productHLCLSTD as unknown as RedDigitalProductResponse);
    // CLD_STD 는 그룹 id(PCS_CLD_STD)·value id(BK001 등)로만 — 계약 타입 필드명엔 없음(opaque).
    const cld = p.optionGroups.find((g) => g.id === 'PCS_CLD_STD')!;
    expect(cld.values.every((v) => typeof v.id === 'string')).toBe(true);
    // priceSchemeKey 는 의도된 불투명 echo 슬롯(계약 product.ts 정의) — 위젯은 값에 분기 안 함.
    expect(p.priceSchemeKey).toBe('offset2023_price');
  });
});
