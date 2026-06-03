// S3 계약 테스트 — 포스터·실사·사인·배너(04·05) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트(INV-3): S3는 첫 위젯 가시 변경(NC-1 dimension-matrix-input) 군이지만,
//  이 테스트는 "기존 14 componentType + 계약 슬롯(cutW/cutH, axis2)이 SizeMatrix2D를 담을 준비가 됨"을
//  EXISTING 어댑터로 증명한다. NC-1 leaf/dispatcher 구현은 후속(hw-architect/builder) 범위.
// 라이브 캡처 근거: cutW/cutH 수치 직접전달(가격요청 ORD_INFO.CUT_WDT/CUT_HGH), MIN/MAX_CUT_WDT 슬롯,
//  규격프리셋(A2/900X900) + 사이즈직접입력 이중모드. 근거: 01_reverse/s3-poster-capture.md.
import { describe, it, expect } from 'vitest';
import { mapProduct, mapPriceResponse } from '@/adapters/red/red-adapter';
import { buildPriceRequest } from '@/widget/stores/price';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import type { ComponentType, NormalizedProduct } from '@/contract';
import productBNBNFBL from '../fixtures/product_BNBNFBL.json';
import productBNPTPET from '../fixtures/product_BNPTPET.json';
import priceBanner from '../fixtures/price_BNBNFBL_sample.json';

// NC-1(dimension-matrix-input) 도입 후: real_price(배너/실사) + 자유입력 sentinel 보유 상품은 GRP_SIZE 가
// dimension-matrix-input 으로 라우팅된다. 그 외 그룹은 전부 기존 14 컴포넌트 안.
const ALL_15: ComponentType[] = ['option-button','select-box','counter-input','color-chip','price-slider','image-chip','mini-color-chip','large-color-chip','area-input','dimension-matrix-input','page-counter-input','finish-button','finish-select-box','summary','upload-cta'];

describe('S3 포스터/배너 → 어댑터 매핑 + NC-1 dimension-matrix-input 라우팅 검증', () => {
  for (const [code, fx] of [['BNBNFBL', productBNBNFBL], ['BNPTPET', productBNPTPET]] as const) {
    it(`${code} → 매핑 성공 + GRP_SIZE 가 dimension-matrix-input (real_price + 자유입력)`, () => {
      const p = mapProduct(fx as unknown as RedDigitalProductResponse);
      expect(p.code).toBe(code);
      expect(p.optionGroups.length).toBeGreaterThan(0);
      const types = new Set<string>();
      for (const g of p.optionGroups) {
        expect(ALL_15).toContain(g.componentType);
        types.add(g.componentType);
      }
      const size = p.optionGroups.find((g) => g.id === 'GRP_SIZE');
      expect(size?.componentType).toBe('dimension-matrix-input');
      // inputSpec(자유입력 범위, axis2=세로) 가 채워짐 — 신규 필드 0(기존 InputSpec.axis2 슬롯).
      expect(size?.inputSpec?.max).toBeGreaterThan(0);
      expect(size?.inputSpec?.axis2).toBeDefined();
      console.log(`  ${code} groups=${p.optionGroups.length} types=[${[...types].join(',')}] scheme=${p.priceSchemeKey} unit=${p.unit}`);
      console.log(`    groupIds: ${p.optionGroups.map((g) => g.id + ':' + g.componentType).join(' | ')}`);
    });
  }

  it('현수막(BNBNFBL) → size 그룹 존재 (NC-1 의 2D 단가 차원 후보)', () => {
    const p = mapProduct(productBNBNFBL as unknown as RedDigitalProductResponse);
    const sizeGroup = p.optionGroups.find((g) => g.id === 'GRP_SIZE' || /SIZE|sizes/i.test(g.id));
    // 라이브 캡처상 sizes select 에 "사이즈직접입력" + 규격프리셋(5000X900/900X900) 공존 → NC-1 근거
    console.log('  size group:', sizeGroup ? `${sizeGroup.id}:${sizeGroup.componentType} values=${sizeGroup.values.length}` : 'NONE(자유입력 전용일 수 있음)');
    // sizeRules(규격→cutW/cutH) 가 계약에 존재하는지(이미 슬롯 보유 — 신규 0)
    const rules = p.constraints?.sizeRules ?? [];
    console.log('  sizeRules count:', rules.length, 'e0:', JSON.stringify(rules[0] ?? null));
    expect(p.constraints).toBeDefined();
  });

  it('현수막 가격 응답(real_price, SizeMatrix2D) → 동일 정규화 shape (cutW/cutH BFF 권위)', () => {
    const b = mapPriceResponse(priceBanner as unknown as RedPriceResponse);
    // 비로그인 캡처라 PRICE=0(shape 검증). D-L3: 침묵 0원은 주문불가(ok:false).
    expect(b.ok).toBe(b.finalPrice > 0); // PRICE>0 일 때만 ok:true
    expect(typeof b.finalPrice).toBe('number');
    // INV-1: 위젯은 SizeMatrix2D 좌표/보간을 모른다. 불투명 finalPrice 만 소비.
    console.log(`  real_price finalPrice=${b.finalPrice} ok=${b.ok} lines=${b.lines.length}`);
  });
});

// NC-1 핵심 결함 해소 단위테스트 — dimsFromSelection(자유입력 경로) via buildPriceRequest.
// §2.1 결함: "사이즈직접입력"(SIZE_0) 선택 시 정적 sizeRule 룩업이 {cutW:0,cutH:0} → 가격요청 빈값(retCode 999).
// NC-1 해소: numeric slot(dimensionInputs) 의 사용자 수치를 dimensions.cutW/cutH 에 직접 공급.
describe('NC-1 결함 해소 — 자유입력 cutW/cutH 직접전달(0 폴백 제거)', () => {
  function stateOf(
    product: NormalizedProduct,
    overrides: Partial<WidgetState>,
  ): WidgetState {
    return {
      product,
      member: {},
      selections: {},
      dimensionInputs: {},
      quantity: 1,
      ...overrides,
    } as WidgetState;
  }

  it('자유입력 모드(SIZE_0 + W/H 입력) → cutW/cutH 가 입력수치로 채워짐 (작업=재단+CUT_MRG)', () => {
    const product = mapProduct(productBNBNFBL as unknown as RedDigitalProductResponse);
    // 자유입력 sentinel 식별: sizeRules 의 0×0 룰.
    const freeRule = product.constraints.sizeRules.find((r) => r.cutW === 0 && r.cutH === 0)!;
    expect(freeRule).toBeDefined();
    const state = stateOf(product, {
      selections: { GRP_SIZE: freeRule.valueId },
      dimensionInputs: { GRP_SIZE: { w: 5000, h: 900 } },
    });
    const req = buildPriceRequest(state);
    const dim = req.dimensions[0];
    const mrg = product.constraints.base.cutMargin; // 4
    // 결함 해소 증명: 이전엔 {cutW:0,cutH:0}. 이제 입력수치 직접전달 + 작업=재단+마진.
    expect(dim.cutW).toBe(5000);
    expect(dim.cutH).toBe(900);
    expect(dim.workW).toBe(5000 + mrg); // 5004
    expect(dim.workH).toBe(900 + mrg); // 904
    console.log(`  free-input dims: ${JSON.stringify(dim)} (이전 폴백 {cutW:0,cutH:0} 해소)`);
  });

  it('자유입력 미입력(W/H=0) → 0 폴백 유지(검증 단계가 차단) — 가격요청 빈값 방어', () => {
    const product = mapProduct(productBNBNFBL as unknown as RedDigitalProductResponse);
    const freeRule = product.constraints.sizeRules.find((r) => r.cutW === 0 && r.cutH === 0)!;
    const state = stateOf(product, { selections: { GRP_SIZE: freeRule.valueId } });
    const dim = buildPriceRequest(state).dimensions[0];
    expect(dim.cutW).toBe(0); // 입력 전 — canOrder/검증이 차단(가격은 BFF 권위)
  });

  it('규격프리셋 선택(5000X900) → 기존 sizeRule 경로 정상(회귀 없음)', () => {
    const product = mapProduct(productBNBNFBL as unknown as RedDigitalProductResponse);
    const preset = product.constraints.sizeRules.find((r) => r.cutW === 5000 && r.cutH === 900)!;
    expect(preset).toBeDefined();
    const state = stateOf(product, {
      selections: { GRP_SIZE: preset.valueId },
      // 자유입력 수치가 있어도 프리셋 선택 시엔 sizeRule 룩업 우선(0×0 sentinel 아님).
      dimensionInputs: { GRP_SIZE: { w: 111, h: 222 } },
    });
    const dim = buildPriceRequest(state).dimensions[0];
    expect(dim.cutW).toBe(5000);
    expect(dim.cutH).toBe(900);
    expect(dim.workW).toBe(preset.workW); // 5004 (sizeRule 권위)
    console.log(`  preset dims: ${JSON.stringify(dim)} (sizeRule 경로 유지)`);
  });
});
