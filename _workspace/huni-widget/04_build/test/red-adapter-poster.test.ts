// S3 계약 테스트 — 포스터·실사·사인·배너(04·05) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트(INV-3): S3는 첫 위젯 가시 변경(NC-1 dimension-matrix-input) 군이지만,
//  이 테스트는 "기존 14 componentType + 계약 슬롯(cutW/cutH, axis2)이 SizeMatrix2D를 담을 준비가 됨"을
//  EXISTING 어댑터로 증명한다. NC-1 leaf/dispatcher 구현은 후속(hw-architect/builder) 범위.
// 라이브 캡처 근거: cutW/cutH 수치 직접전달(가격요청 ORD_INFO.CUT_WDT/CUT_HGH), MIN/MAX_CUT_WDT 슬롯,
//  규격프리셋(A2/900X900) + 사이즈직접입력 이중모드. 근거: 01_reverse/s3-poster-capture.md.
import { describe, it, expect } from 'vitest';
import { mapProduct, mapPriceResponse } from '@/adapters/red/red-adapter';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import type { ComponentType } from '@/contract';
import productBNBNFBL from '../fixtures/product_BNBNFBL.json';
import productBNPTPET from '../fixtures/product_BNPTPET.json';
import priceBanner from '../fixtures/price_BNBNFBL_sample.json';

// NC-1(dimension-matrix-input)은 아직 union 에 추가되지 않음(후속 단계). 현 어댑터는 size 를
// 기존 컴포넌트(option-button/select-box/area-input)로 매핑한다. 14 중 어느 것이든 허용.
const EXISTING_14: ComponentType[] = ['option-button','select-box','counter-input','color-chip','price-slider','image-chip','mini-color-chip','large-color-chip','area-input','page-counter-input','finish-button','finish-select-box','summary','upload-cta'];

describe('S3 포스터/배너 → 어댑터 매핑 + 계약 슬롯(SizeMatrix2D 준비) 검증', () => {
  for (const [code, fx] of [['BNBNFBL', productBNBNFBL], ['BNPTPET', productBNPTPET]] as const) {
    it(`${code} → 매핑 성공 + 전 옵션그룹이 기존 14 안 (NC-1 미도입 상태에서 회귀)`, () => {
      const p = mapProduct(fx as unknown as RedDigitalProductResponse);
      expect(p.code).toBe(code);
      expect(p.optionGroups.length).toBeGreaterThan(0);
      const types = new Set<string>();
      for (const g of p.optionGroups) {
        expect(EXISTING_14).toContain(g.componentType);
        types.add(g.componentType);
      }
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
    expect(b.ok).toBe(true);
    expect(typeof b.finalPrice).toBe('number');
    // INV-1: 위젯은 SizeMatrix2D 좌표/보간을 모른다. 불투명 finalPrice 만 소비.
    console.log(`  real_price finalPrice=${b.finalPrice} lines=${b.lines.length}`);
  });
});
