// hashRequest 캐시 키 버그 재현 + 회귀 테스트 — price-engine.md §3 캐시 키.
// [버그] JSON.stringify(req, Object.keys(req).sort()) 의 두번째 인자(replacer 배열)가
//  모든 중첩 레벨에 적용되어 dimensions/selectedFinishes/colorCounts/materials 의 내부 키가 누락된다.
//  → 옵션만 다른 두 요청이 동일 캐시 키 → cache hit 으로 가격 재요청이 막힘(실사용 영향 大).
// [수정 후] 중첩 키까지 안정 직렬화 → 옵션이 다르면 키가 달라야 한다(miss). 동일 조합은 동일 키(hit).
import { describe, it, expect } from 'vitest';
import { hashRequest, buildPriceRequest } from '@/widget/stores/price';
import { createWidgetStore } from '@/widget/stores/widget-store';
import { StubBffClient } from '@/bff/stub';
import { mapProduct } from '@/adapters/red/red-adapter';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type { NormalizedPriceRequest, NormalizedProduct } from '@/contract';
import productACNTHAP from '../fixtures/product_ACNTHAP.json';

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

const baseReq = (): NormalizedPriceRequest => ({
  productCode: 'ACNTHAP',
  priceSchemeKey: 'vTmpl_price',
  customerTier: undefined,
  dimensions: [{ side: 'default', cutW: 70, cutH: 25, workW: 72, workH: 27 }],
  colorCounts: { default: 4 },
  materials: { default: 'RXIGC075' },
  quantity: 10,
  pageCount: undefined,
  selectedFinishes: [{ groupId: 'PCS_WRK_MTR', valueId: 'NBPIN' }],
});

describe('hashRequest — 중첩 키까지 안정 직렬화 (옵션 변경 = 다른 캐시 키)', () => {
  it('selectedFinishes valueId 만 다름(NBPIN vs NBMGN) → 다른 키', () => {
    const a = baseReq();
    const b = baseReq();
    b.selectedFinishes = [{ groupId: 'PCS_WRK_MTR', valueId: 'NBMGN' }];
    expect(hashRequest(a)).not.toBe(hashRequest(b));
  });

  it('dimensions cutW 만 다름(70 vs 75) → 다른 키', () => {
    const a = baseReq();
    const b = baseReq();
    b.dimensions = [{ side: 'default', cutW: 75, cutH: 25, workW: 77, workH: 27 }];
    expect(hashRequest(a)).not.toBe(hashRequest(b));
  });

  it('quantity 만 다름(10 vs 20) → 다른 키', () => {
    const a = baseReq();
    const b = baseReq();
    b.quantity = 20;
    expect(hashRequest(a)).not.toBe(hashRequest(b));
  });

  it('materials 만 다름 → 다른 키', () => {
    const a = baseReq();
    const b = baseReq();
    b.materials = { default: 'RXIGC076' };
    expect(hashRequest(a)).not.toBe(hashRequest(b));
  });

  it('colorCounts 만 다름(4 vs 8) → 다른 키', () => {
    const a = baseReq();
    const b = baseReq();
    b.colorCounts = { default: 8 };
    expect(hashRequest(a)).not.toBe(hashRequest(b));
  });

  it('완전히 동일한 조합 → 동일 키 (cache hit 보존)', () => {
    expect(hashRequest(baseReq())).toBe(hashRequest(baseReq()));
  });

  it('키 입력 순서만 다르고 값이 같으면 → 동일 키 (안정 직렬화)', () => {
    const a = baseReq();
    // 같은 값을 다른 객체 리터럴 순서로 구성.
    const b: NormalizedPriceRequest = {
      selectedFinishes: [{ valueId: 'NBPIN', groupId: 'PCS_WRK_MTR' }],
      quantity: 10,
      pageCount: undefined,
      materials: { default: 'RXIGC075' },
      colorCounts: { default: 4 },
      dimensions: [{ workH: 27, workW: 72, cutH: 25, cutW: 70, side: 'default' }],
      customerTier: undefined,
      priceSchemeKey: 'vTmpl_price',
      productCode: 'ACNTHAP',
    };
    expect(hashRequest(a)).toBe(hashRequest(b));
  });
});

// 라이브 통합 — 캐시 ON(기본 TTL)에서도 옵션 변경 시 cache miss → 가격 재요청이 실제로 나가는지.
// 수정 전이면 부자재 변경이 동일 키로 cache hit 되어 두번째 price() 가 호출되지 않는다.
describe('hashRequest 수정 — 캐시 ON에서 옵션 변경이 재요청을 유발(cacheTtlMs:0 우회 불요)', () => {
  it('ACNTHAP 부자재 NBPIN→NBMGN 변경 → 캐시 ON이어도 price() 재호출(miss)', async () => {
    const captured: NormalizedPriceRequest[] = [];
    const bff = new StubBffClient();
    const origPrice = bff.price.bind(bff);
    bff.price = (req: NormalizedPriceRequest) => {
      captured.push(req);
      return origPrice(req);
    };
    // cacheTtlMs 미지정 = 기본 30s 캐시 ON. 옵션 변경이 다른 키면 miss → 재요청.
    const store = createWidgetStore({ bff, productCode: 'ACNTHAP', debounceMs: 0 });
    await settle();
    const before = captured.length;

    store.getState().selectOption('PCS_WRK_MTR', 'NBMGN');
    await settle();

    expect(captured.length).toBeGreaterThan(before); // 재요청 발생(miss)
    expect(captured[captured.length - 1].selectedFinishes).toContainEqual({
      groupId: 'PCS_WRK_MTR',
      valueId: 'NBMGN',
    });
  });

  it('동일 조합 재선택 → cache hit (price() 재호출 없음)', async () => {
    const captured: NormalizedPriceRequest[] = [];
    const bff = new StubBffClient();
    const origPrice = bff.price.bind(bff);
    bff.price = (req: NormalizedPriceRequest) => {
      captured.push(req);
      return origPrice(req);
    };
    const store = createWidgetStore({ bff, productCode: 'ACNTHAP', debounceMs: 0 });
    await settle();

    const product = store.getState().product!;
    const so = product.constraints.sizeRules.find((r) => r.cutW === 70 && r.cutH === 25)!;
    // 기본 진입 상태의 규격(소)을 그대로 재선택 → 동일 조합 → hit.
    store.getState().selectOption('GRP_SIZE', so.valueId);
    await settle();
    const afterSame = captured.length;

    store.getState().selectOption('GRP_SIZE', so.valueId);
    await settle();
    expect(captured.length).toBe(afterSame); // 동일 조합 = cache hit, 재호출 없음

    // 단위 확인: buildPriceRequest 동일성.
    const s = stateOf(product, { selections: { GRP_SIZE: so.valueId, PCS_WRK_MTR: 'NBPIN' }, quantity: 1 });
    expect(hashRequest(buildPriceRequest(s))).toBe(hashRequest(buildPriceRequest(s)));
    expect(mapProduct(productACNTHAP as unknown as RedDigitalProductResponse).code).toBe('ACNTHAP');
  });
});
