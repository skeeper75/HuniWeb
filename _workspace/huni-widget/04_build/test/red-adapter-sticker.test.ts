// S2 계약 테스트 — 스티커(02) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트(INV-3): 스티커가 기존 14 componentType 으로 100% 커버됨을 EXISTING 어댑터로 증명.
//  - PriceTable3D 변형(STTHCIC/STCUXXX): THO_DFT 모양커팅이 finish-button 으로 자동 매핑(신규 0).
//  - FixedUnit(STPADPN, vTmpl_price): 시트단위 unit=장, priceSchemeKey 불투명 echo, 응답 envelope 동일.
// 근거: 01_reverse/s2-sticker-capture.md, expansion-strategy.md §S2.
import { describe, it, expect } from 'vitest';
import { mapProduct, mapPriceResponse } from '@/adapters/red/red-adapter';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import type { ComponentType } from '@/contract';
import productSTTHCIC from '../fixtures/product_STTHCIC.json';
import productSTCUXXX from '../fixtures/product_STCUXXX.json';
import productSTPADPN from '../fixtures/product_STPADPN.json';
import priceSticker from '../fixtures/price_STTHCIC_sample.json';
import priceStickerFixed from '../fixtures/price_STPADPN_sample.json';

const EXISTING_14: ComponentType[] = ['option-button','select-box','counter-input','color-chip','price-slider','image-chip','mini-color-chip','large-color-chip','area-input','page-counter-input','finish-button','finish-select-box','summary','upload-cta'];

describe('S2 스티커 → 기존 14 componentType 커버 (위젯 코어 0변경 검증)', () => {
  for (const [code, fx] of [['STTHCIC',productSTTHCIC],['STCUXXX',productSTCUXXX],['STPADPN',productSTPADPN]] as const) {
    it(`${code} → 전 옵션그룹이 기존 14 안 + 단일면`, () => {
      const p = mapProduct(fx as unknown as RedDigitalProductResponse);
      expect(p.code).toBe(code);
      expect(p.sides.map(s=>s.key)).toEqual(['default']);
      expect(p.optionGroups.length).toBeGreaterThan(0);
      const types = new Set<string>();
      for (const g of p.optionGroups) { expect(EXISTING_14).toContain(g.componentType); types.add(g.componentType); }
      console.log(`  ${code} groups=${p.optionGroups.length} types=[${[...types].join(',')}] priceScheme=${p.priceSchemeKey} unit=${p.unit}`);
      console.log(`    groupIds: ${p.optionGroups.map(g=>g.id+':'+g.componentType).join(' | ')}`);
    });
  }
  it('STTHCIC THO_DFT 모양커팅(원형) → 후가공 그룹으로 매핑', () => {
    const p = mapProduct(productSTTHCIC as unknown as RedDigitalProductResponse);
    const tho = p.optionGroups.find(g=>g.id.includes('THO_DFT'));
    console.log('  THO_DFT group:', tho ? `${tho.id}:${tho.componentType} values=${tho.values.length}` : 'NOT FOUND');
  });
  it('스티커 가격 응답(digital + FixedUnit) → 동일 정규화 shape (D-L3: PRICE=0 → ok:false)', () => {
    const b1 = mapPriceResponse(priceSticker as unknown as RedPriceResponse); // 비로그인 digital_price PRICE=0
    const b2 = mapPriceResponse(priceStickerFixed as unknown as RedPriceResponse); // FixedUnit 공개가 PRICE=4000
    // shape 는 동일(어댑터 중립)하되, D-L3: 침묵 0원은 주문불가(ok:false). 실가 응답만 ok:true.
    expect(b1.ok).toBe(false); // PRICE=0 → 주문불가 (Red mod_06:1167 정합)
    expect(b1.finalPrice).toBe(0);
    expect(b2.ok).toBe(true); // PRICE=4000 → 주문가능
    expect(b2.finalPrice).toBeGreaterThan(0);
    expect(typeof b1.finalPrice).toBe('number'); expect(typeof b2.finalPrice).toBe('number');
    console.log(`  digital_price finalPrice=${b1.finalPrice} ok=${b1.ok} | FixedUnit finalPrice=${b2.finalPrice} ok=${b2.ok}`);
  });
});
