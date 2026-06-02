// S1 계약 테스트 — 디지털인쇄(명함·엽서) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트: 단일면(내지분리 없음) + 별색 finish + dosu 평면화가 기존 14 componentType 으로 커버됨을 증명.
// 근거: expansion-strategy.md §S1 / §7.2 체크리스트, data-adapter.md §2.
import { describe, it, expect } from 'vitest';
import { mapProduct, mapPriceResponse } from '@/adapters/red/red-adapter';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import type { ComponentType } from '@/contract';
import productBCSPDFT from '../fixtures/product_BCSPDFT.json';
import productBCSPWHT from '../fixtures/product_BCSPWHT.json';
import productPRPOXXX from '../fixtures/product_PRPOXXX.json';
import priceDigital from '../fixtures/price_BCSPDFT_sample.json';

// 기존 14 componentType — S1 은 신규 componentType 0 (전부 이 집합 안).
const EXISTING_14: ComponentType[] = [
  'option-button',
  'select-box',
  'counter-input',
  'color-chip',
  'price-slider',
  'image-chip',
  'mini-color-chip',
  'large-color-chip',
  'area-input',
  'page-counter-input',
  'finish-button',
  'finish-select-box',
  'summary',
  'upload-cta',
];

describe('Red adapter (S1 디지털인쇄) → 정규화 계약', () => {
  it('BCSPDFT 일반 명함 → 단일면(내지분리 없음)', () => {
    const p = mapProduct(productBCSPDFT as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('BCSPDFT');
    expect(p.unit).toBe('장');
    expect(p.priceSchemeKey).toBe('digital_price'); // 불투명 echo (책자 book2025_price 와 구분)

    // [S1 핵심] 단일면 — sides=[default] 만, 책자 표지/내지 분리 없음.
    expect(p.sides.map((s) => s.key)).toEqual(['default']);
    // usePDF=Y → uploadType=pdf (KOI/RP 에디터 미가용 상품).
    expect(p.sides[0].uploadType).toBe('pdf');

    // [S1 핵심] 내지 그룹이 전혀 방출되지 않음.
    expect(p.optionGroups.some((g) => g.side === 'inner')).toBe(false);
    expect(p.optionGroups.some((g) => g.id === 'GRP_INNER_PAGE')).toBe(false);
    expect(p.optionGroups.some((g) => g.id === 'GRP_MTRL_INNER')).toBe(false);
    expect(p.optionGroups.some((g) => g.id === 'GRP_DOSU_INNER')).toBe(false);
  });

  it('BCSPDFT → 옵션 그룹은 기존 14 componentType 으로 100% 커버 (신규 0)', () => {
    const p = mapProduct(productBCSPDFT as unknown as RedDigitalProductResponse);
    expect(p.optionGroups.length).toBeGreaterThan(0);
    for (const g of p.optionGroups) {
      expect(EXISTING_14).toContain(g.componentType);
    }
    // 대표 그룹 존재: 규격(option-button) · 용지(select-box) · 도수(option-button) · 수량(counter-input).
    expect(p.optionGroups.find((g) => g.id === 'GRP_SIZE')?.componentType).toBe('option-button');
    expect(p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER')?.componentType).toBe('select-box');
    expect(p.optionGroups.find((g) => g.id === 'GRP_DOSU_COVER')?.componentType).toBe('option-button');
    expect(p.optionGroups.find((g) => g.id === 'GRP_QUANTITY')?.componentType).toBe('counter-input');
    // 단일면이므로 용지 라벨은 "표지 용지" 가 아니라 "용지".
    expect(p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER')?.label).toBe('용지');
  });

  it('BCSPDFT → dosu 단/양면 priceColorCount 평면화 (단면=4 / 양면=8)', () => {
    const p = mapProduct(productBCSPDFT as unknown as RedDigitalProductResponse);
    const dosu = p.optionGroups.find((g) => g.id === 'GRP_DOSU_COVER');
    expect(dosu?.values.find((v) => v.id === 'SID_S')?.priceColorCount).toBe(4);
    expect(dosu?.values.find((v) => v.id === 'SID_D')?.priceColorCount).toBe(8);
  });

  it('BCSPWHT 화이트인쇄(별색) → 별색이 finish 그룹으로 매핑 (Red-중립 id round-trip)', () => {
    const p = mapProduct(productBCSPWHT as unknown as RedDigitalProductResponse);
    // 별색(화이트인쇄)은 PCS_PRT_WHT 그룹으로. 위젯은 불투명 id 만 보고 echo.
    const white = p.optionGroups.find((g) => g.id === 'PCS_PRT_WHT');
    expect(white).toBeTruthy();
    expect(white?.componentType).toBe('finish-button'); // colorHex 부재 → finish-button (RULE-2)
    expect(white?.values.length).toBeGreaterThan(0);
    // 단일면 유지 (별색 상품도 내지 분리 없음).
    expect(p.sides.map((s) => s.key)).toEqual(['default']);
    expect(p.optionGroups.some((g) => g.side === 'inner')).toBe(false);
    // 별색 상품도 신규 componentType 0.
    for (const g of p.optionGroups) {
      expect(EXISTING_14).toContain(g.componentType);
    }
  });

  it('PRPOXXX 종이 포스터/엽서 → 다수 용지(select-box)·다수 후가공, 단일면', () => {
    const p = mapProduct(productPRPOXXX as unknown as RedDigitalProductResponse);
    expect(p.sides.map((s) => s.key)).toEqual(['default']);
    expect(p.optionGroups.some((g) => g.id === 'GRP_INNER_PAGE')).toBe(false);
    // 45종 용지 → select-box (native select 금지는 컴포넌트 구현이 보장; 계약은 타입만).
    const mtrl = p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER');
    expect(mtrl?.componentType).toBe('select-box');
    expect(mtrl?.values.length).toBeGreaterThan(10);
    // 다수 후가공 finish-button 그룹.
    expect(p.optionGroups.filter((g) => g.componentType === 'finish-button').length).toBeGreaterThan(1);
    for (const g of p.optionGroups) {
      expect(EXISTING_14).toContain(g.componentType);
    }
  });

  it('BCSPDFT disableRules 평면화 (자재→후가공 그룹 비활성, PCS_ prefix round-trip)', () => {
    const p = mapProduct(productBCSPDFT as unknown as RedDigitalProductResponse);
    // RXETP226 → COT_DFT 그룹 전체 비활성 (PCS_DTL_CD null).
    const rule = p.constraints.disableRules.find((r) => r.triggerValueId === 'RXETP226');
    expect(rule).toBeTruthy();
    expect(rule?.disablesGroupId).toBe('PCS_COT_DFT');
    expect(rule?.disablesValueId).toBeUndefined();
  });

  it('디지털인쇄 가격 응답 → NormalizedPriceBreakdown (책자와 동일 워터폴 평면화, shape 검증)', () => {
    const b = mapPriceResponse(priceDigital as unknown as RedPriceResponse);
    // 비로그인 캡처라 PRICE=0 이지만 정규화 shape 는 책자와 동일해야 한다 (어댑터 중립).
    expect(b.ok).toBe(true);
    expect(typeof b.finalPrice).toBe('number');
    expect(typeof b.vat).toBe('number');
    expect(Array.isArray(b.lines)).toBe(true);
    expect(b.lines[0]?.code).toBe('CUT_DFT'); // 공정 코드 round-trip
  });
});
