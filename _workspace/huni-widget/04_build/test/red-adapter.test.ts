// 계약 테스트 — build-plan A2: Red fixture → 정규화 타입 스키마 통과.
// [HARD] 컨버전 게이트: Red 어댑터 출력이 NormalizedProduct/Breakdown 형태를 만족하는가.
import { describe, it, expect } from 'vitest';
import { mapProduct, mapPriceResponse } from '@/adapters/red/red-adapter';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import productPRBKYPR from '../fixtures/product_PRBKYPR.json';
import priceQ30 from '../fixtures/price_q30_p10.json';

describe('Red adapter → 정규화 계약', () => {
  it('PRBKYPR 책자 → NormalizedProduct (표지+내지 2 side)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('PRBKYPR');
    expect(p.unit).toBe('권');
    expect(p.priceSchemeKey).toBe('book2025_price');
    // 책자 = 표지(editor) + 내지(pdf)
    expect(p.sides.map((s) => s.key)).toEqual(['default', 'inner']);
    expect(p.sides.find((s) => s.key === 'default')?.uploadType).toBe('editor');
    expect(p.sides.find((s) => s.key === 'inner')?.uploadType).toBe('pdf');
    // 옵션 그룹은 componentType 만 노출 (Red 데이터셋명 없음)
    expect(p.optionGroups.length).toBeGreaterThan(0);
    for (const g of p.optionGroups) {
      expect(g.id).toBeTruthy();
      expect(typeof g.label).toBe('string');
      expect([
        'option-button',
        'select-box',
        'finish-button',
        'finish-select-box',
        'color-chip',
        'counter-input',
        'page-counter-input',
      ]).toContain(g.componentType);
    }
  });

  it('disableRules 평면화 (RXOMO080 → 그룹 비활성)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const rule = p.constraints.disableRules.find((r) => r.triggerValueId === 'RXOMO080');
    expect(rule).toBeTruthy();
    expect(rule?.disablesGroupId).toBe('PCS_COT_DFT'); // PCS_DTL_CD null → 그룹 비활성
  });

  it('dosu priceColorCount 평면화 (단면=4 / 양면=8)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const dosu = p.optionGroups.find((g) => g.id === 'GRP_DOSU_COVER');
    expect(dosu?.values.find((v) => v.id === 'SID_S')?.priceColorCount).toBe(4);
    expect(dosu?.values.find((v) => v.id === 'SID_D')?.priceColorCount).toBe(8);
  });

  it('sizeRules 매핑 (A4 = cut 210×297)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const a4 = p.constraints.sizeRules.find((r) => r.cutW === 210 && r.cutH === 297);
    expect(a4).toBeTruthy();
    expect(a4?.workW).toBe(220);
  });

  it('가격 응답 → NormalizedPriceBreakdown (워터폴 finalPrice 평면화)', () => {
    const b = mapPriceResponse(priceQ30 as unknown as RedPriceResponse);
    expect(b.ok).toBe(true);
    // result_sum PRICE=56000, PRICE_MALL===PRICE, ORG_PRICE===PRICE → finalPrice=56000
    expect(b.finalPrice).toBe(56000);
    expect(b.vat).toBe(5600);
    expect(b.shipping).toBe(3500); // book_info.DLVR_AMT
    expect(b.lines.length).toBeGreaterThan(0);
  });
});
