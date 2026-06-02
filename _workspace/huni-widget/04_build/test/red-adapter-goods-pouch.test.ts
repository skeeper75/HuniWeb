// S5 계약 테스트 — 굿즈/파우치(11) GSTGMIC(tiered_price)·GSPUFBC(tmpl_price) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트(INV-3): 명세 s5-goods-pouch-spec.md 가 굿즈/파우치를 "위젯 코어 0줄 = 계약 optional 1필드
//  + 어댑터 직렬화 분기"로 판정(NC-3 신규 componentType 없음, s5-nc3-decision.md). 이 테스트는 그 판정을
//  EXISTING 어댑터 출력 + 신규 직렬화 함수로 실증한다.
//  - NC-3 = 신규 없음: 규격=option-button, 자재=select-box, 수량=counter-input(64×64 image-option-selector 미발동).
//  - printCount(optional) → 어댑터 serializeRedPriceRequest 가 ORD_CNT/PRN_CNT 분리 직렬화(s5 §2.3).
//  - 가드: ORD_CNT≥1 && PRN_CNT≥1 위반 시 quote()가 {ok:false} 명시 반환(Red 침묵 PRICE=0 재현 금지, s5 §2.4).
//  - 규격 폐쇄 enum + 치수 자동주입: nonStandardAllowed=false → dimension-matrix-input(NC-1) 미발동(s5 §2.5).
// 근거: s5-goods-pouch-spec.md §1·§2·§4, fixtures/product_GSTGMIC.json·product_GSPUFBC.json, captures/s5_pouch_GSPUFBC.json.
import { describe, it, expect } from 'vitest';
import {
  mapProduct,
  mapPriceResponse,
  serializeRedPriceRequest,
  createRedAdapter,
} from '@/adapters/red/red-adapter';
import { FixtureRedDataSource } from '@/adapters/red/fixture-source';
import { buildPriceRequest } from '@/widget/stores/price';
import { createWidgetStore } from '@/widget/stores/widget-store';
import { StubBffClient } from '@/bff/stub';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type {
  ComponentType,
  NormalizedProduct,
  NormalizedPriceRequest,
} from '@/contract';
import productGSTGMIC from '../fixtures/product_GSTGMIC.json';
import productGSPUFBC from '../fixtures/product_GSPUFBC.json';
import pricePouch from '../fixtures/price_GSPUFBC_sample.json';

// NC-3 신규 없음: 전 그룹이 기존 15 componentType(NC-1 포함) 안에서 충족.
const ALL_15: ComponentType[] = ['option-button','select-box','counter-input','color-chip','price-slider','image-chip','mini-color-chip','large-color-chip','area-input','dimension-matrix-input','page-counter-input','finish-button','finish-select-box','summary','upload-cta'];

async function settle() {
  for (let i = 0; i < 20; i++) await Promise.resolve();
}

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

describe('S5 파우치(GSPUFBC, tmpl_price) → 기존 컴포넌트 흡수 (NC-3 신규 없음)', () => {
  it('GSPUFBC → 전 옵션그룹이 기존 15 componentType 안 + 단일면 + tmpl_price echo', () => {
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('GSPUFBC');
    expect(p.sides.map((s) => s.key)).toEqual(['default']);
    expect(p.priceSchemeKey).toBe('tmpl_price'); // 불투명 echo (INV-2: 위젯엔 미등장, 어댑터 출력만)
    expect(p.unit).toBe('개');
    for (const g of p.optionGroups) expect(ALL_15).toContain(g.componentType);
    console.log(`  GSPUFBC groups=${p.optionGroups.map((g) => g.id + ':' + g.componentType + (g.visible ? '' : '(hidden)')).join(' | ')} scheme=${p.priceSchemeKey}`);
  });

  // §2.5 — 규격 폐쇄 enum(option-button) + NC-1(dimension-matrix-input) 미발동.
  it('규격 → GRP_SIZE option-button (NC-1 아님: tmpl_price + 0×0 sentinel 부재), 값 5종 + 치수 자동주입', () => {
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const size = p.optionGroups.find((g) => g.id === 'GRP_SIZE');
    expect(size).toBeDefined();
    expect(size!.componentType).toBe('option-button'); // NC-1 미발동
    expect(size!.componentType).not.toBe('dimension-matrix-input');
    expect(size!.inputSpec).toBeUndefined(); // 자유입력 슬롯 미생성
    expect(size!.values.length).toBe(5); // 등록 템플릿 5종(폐쇄 enum)
    // 자유입력 sentinel(0×0) 부재 → NC-1 조건 불충족.
    const rules = p.constraints.sizeRules;
    expect(rules.some((r) => r.cutW === 0 && r.cutH === 0)).toBe(false);
    // nonStandardAllowed=false(NO_STD_ABL_YN=N) → 자유입력 비활성.
    expect(p.constraints.base.nonStandardAllowed).toBe(false);
    // 치수 자동주입: 11in세로 기본(DFT_YN=Y) 재단 230x288, 작업=재단+CUT_MRG(20) 각변.
    const def = rules.find((r) => r.cutW === 230 && r.cutH === 288);
    expect(def).toBeDefined();
    expect(def!.workW).toBe(250); // 230 + 20
    expect(def!.workH).toBe(308); // 288 + 20
    console.log(`  GRP_SIZE: option-button values=${size!.values.length} | sizeRules=${rules.map((r) => `${r.cutW}x${r.cutH}`).join(',')} nonStd=${p.constraints.base.nonStandardAllowed}`);
  });

  it('자재=select-box(단일), 도수=option-button(단면), 수량=counter-input(FIR/STEP)', () => {
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const mtrl = p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER');
    expect(mtrl?.componentType).toBe('select-box');
    expect(mtrl?.values.map((v) => v.id)).toEqual(['PXFBW010']); // 단일 자재
    const dosu = p.optionGroups.find((g) => g.id === 'GRP_DOSU_COVER');
    expect(dosu?.componentType).toBe('option-button');
    const qty = p.optionGroups.find((g) => g.id === 'GRP_QUANTITY');
    expect(qty?.componentType).toBe('counter-input');
    expect(qty?.inputSpec?.min).toBe(1); // MIN_PRN_CNT
    expect(qty?.inputSpec?.first).toBe(1); // FIR_CNT
  });
});

describe('S5 어댑터 직렬화 — quantity↔ORD_CNT / printCount↔PRN_CNT 분리 (s5 §2.3)', () => {
  it('printCount 지정 → ORD_INFO[0].PRN_CNT, quantity → ORD_CNT 분리 직렬화', () => {
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 230 && r.cutH === 288)!;
    const state = stateOf(p, { selections: { GRP_SIZE: def.valueId }, quantity: 100 });
    const req: NormalizedPriceRequest = buildPriceRequest(state);
    // 위젯 buildPriceRequest 는 printCount 를 설정하지 않음(현 stage UI 미노출) → undefined.
    expect(req.printCount).toBeUndefined();
    expect(req.quantity).toBe(100);
    // 어댑터가 직렬화: printCount 미전달 → PRN_CNT=1(하위호환), quantity → ORD_CNT.
    const body = serializeRedPriceRequest(req);
    expect(body.ORD_INFO[0].ORD_CNT).toBe(100);
    expect(body.ORD_INFO[0].PRN_CNT).toBe(1); // 미전달 기본값
    expect(body.ORD_INFO[0].CUT_WDT).toBe(230);
    expect(body.ORD_INFO[0].CUT_HGH).toBe(288);
    expect(body.price_gbn).toBe('tmpl_price'); // 불투명 echo
    // printCount 명시 전달(미래 후니/파우치 PRN_CNT 옵션) → PRN_CNT 로 분리 직렬화.
    const body2 = serializeRedPriceRequest({ ...req, printCount: 6 });
    expect(body2.ORD_INFO[0].ORD_CNT).toBe(100); // 불변
    expect(body2.ORD_INFO[0].PRN_CNT).toBe(6); // printCount 반영
    console.log(`  serialize: ORD_CNT=${body.ORD_INFO[0].ORD_CNT} PRN_CNT=${body.ORD_INFO[0].PRN_CNT}(미전달) → printCount=6 시 PRN_CNT=${body2.ORD_INFO[0].PRN_CNT}`);
  });

  it('selectedFinishes → PCS_INFO 직렬화 (PCS_ prefix 역매핑)', () => {
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 230 && r.cutH === 288)!;
    const state = stateOf(p, {
      selections: {
        GRP_SIZE: def.valueId,
        PCS_CUT_DFT: 'DFXXX',
        PCS_PDT_WRK: 'PUBOK',
        PCS_FLX_ZIP: 'ZPH01',
      },
      quantity: 100,
    });
    const body = serializeRedPriceRequest(buildPriceRequest(state));
    const cods = body.PCS_INFO.map((p2) => p2.PCS_COD);
    expect(cods).toContain('CUT_DFT'); // PCS_ prefix 제거 역매핑
    expect(cods).toContain('PDT_WRK');
    expect(cods).toContain('FLX_ZIP');
  });
});

describe('S5 가격 가드 — ORD_CNT≥1 && PRN_CNT≥1 위반 시 명시적 미견적 (s5 §2.4)', () => {
  it('quantity=0 → quote() {ok:false, finalPrice:0} (침묵 0 아님)', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 230 && r.cutH === 288)!;
    const reqZeroQty = buildPriceRequest(stateOf(p, { selections: { GRP_SIZE: def.valueId }, quantity: 0 }));
    const res = await adapter.price.quote(reqZeroQty);
    expect(res.ok).toBe(false);
    expect(res.finalPrice).toBe(0);
    expect(res.lines).toEqual([]);
  });

  it('printCount=0 명시 → quote() {ok:false} (PRN_CNT 가드)', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 230 && r.cutH === 288)!;
    const req = { ...buildPriceRequest(stateOf(p, { selections: { GRP_SIZE: def.valueId }, quantity: 100 })), printCount: 0 };
    const res = await adapter.price.quote(req);
    expect(res.ok).toBe(false);
    expect(res.finalPrice).toBe(0);
  });

  it('quantity≥1 (printCount 미전달=1) → 가드 통과 → tmpl_price 실가 PRICE>0', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const p = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    const def = p.constraints.sizeRules.find((r) => r.cutW === 230 && r.cutH === 288)!;
    const req = buildPriceRequest(stateOf(p, { selections: { GRP_SIZE: def.valueId }, quantity: 100 }));
    const res = await adapter.price.quote(req);
    expect(res.ok).toBe(true);
    expect(res.finalPrice).toBe(2850000); // 캡처 completeReqBody 실가(평탄단가)
    expect(res.vat).toBe(285000);
  });
});

describe('S5 굿즈(GSTGMIC, tiered_price) → NC-3 신규 없음 실증', () => {
  it('GSTGMIC → 전 옵션그룹 기존 15 componentType 안 + tiered_price echo (color/image-chip 미사용)', () => {
    const p = mapProduct(productGSTGMIC as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('GSTGMIC');
    expect(p.priceSchemeKey).toBe('tiered_price');
    for (const g of p.optionGroups) expect(ALL_15).toContain(g.componentType);
    // 실측 GSTGMIC 에는 색상/이미지 셀렉터 부재(s5-nc3-decision §4) — color/image-chip 그룹 0.
    const chipGroups = p.optionGroups.filter((g) => g.componentType === 'color-chip' || g.componentType === 'image-chip' || g.componentType === 'large-color-chip');
    expect(chipGroups.length).toBe(0);
    // 사이즈 4종 = option-button(NC-1 아님), 자재 1종, 수량.
    expect(p.optionGroups.find((g) => g.id === 'GRP_SIZE')!.componentType).toBe('option-button');
    console.log(`  GSTGMIC types=[${[...new Set(p.optionGroups.map((g) => g.componentType))].join(',')}] scheme=${p.priceSchemeKey} chipGroups=${chipGroups.length}`);
  });
});

describe('S5 라이브 증명 — 파우치 런타임(createWidgetStore + StubBffClient) PRICE>0', () => {
  it('GSPUFBC 기본 진입 → 기본규격(11in세로) 선택 + 가드 통과 → finalPrice=2,850,000', async () => {
    const bff = new StubBffClient();
    let lastPrice = 0;
    const store = createWidgetStore({
      bff,
      productCode: 'GSPUFBC',
      debounceMs: 0,
      onPriceChange: (b) => { lastPrice = b.finalPrice; },
    });
    await settle();
    const s = store.getState();
    expect(s.product?.code).toBe('GSPUFBC');
    // 기본 진입: defaultSelections 가 GRP_SIZE 첫 값(DFT_YN=Y 정렬 아님 — option-button 첫 비활성값) 선택,
    //  quantity = DFT_PRN_CNT(=1) → 가드 통과(quantity≥1, printCount 미전달=1).
    expect(s.quantity).toBeGreaterThanOrEqual(1);
    expect(s.price?.ok).toBe(true);
    expect(lastPrice).toBe(2850000);
    console.log(`  [LIVE] GSPUFBC quantity=${s.quantity} finalPrice=${lastPrice} ok=${s.price?.ok}`);
  });
});

// 응답 fixture 자체가 워터폴 평면화를 통과하는지(직접 단위).
describe('S5 파우치 price fixture → NormalizedPriceBreakdown 평면화', () => {
  it('price_GSPUFBC_sample → finalPrice=2,850,000 (PRICE_MALL==PRICE==ORG_PRICE)', () => {
    const b = mapPriceResponse(pricePouch as unknown as Parameters<typeof mapPriceResponse>[0]);
    expect(b.ok).toBe(true);
    expect(b.finalPrice).toBe(2850000);
    expect(b.vat).toBe(285000);
  });
});
