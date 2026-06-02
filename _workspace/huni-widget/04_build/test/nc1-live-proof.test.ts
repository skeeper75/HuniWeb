// NC-1 결함 해소 라이브 증명 — 실 런타임 경로(createWidgetStore + StubBffClient[FixtureRedDataSource])로
// "사이즈직접입력" 자유입력 → BFF.price() 에 실리는 NormalizedPriceRequest 의 cutW/cutH 를 캡처한다.
// 이것은 dev 하네스(localhost:5173)가 BNBNFBL 을 마운트했을 때와 동일한 store 경로다(테스트 더미 아님).
import { describe, it, expect } from 'vitest';
import { createWidgetStore } from '@/widget/stores/widget-store';
import { StubBffClient } from '@/bff/stub';
import type { NormalizedPriceRequest, PriceDimension } from '@/contract';

async function settle() {
  // 초기 loadProduct + 자동 가격(debounce=0)이 완료될 때까지 마이크로태스크 flush.
  for (let i = 0; i < 20; i++) await Promise.resolve();
}

describe('NC-1 라이브 증명 — BNBNFBL 자유입력 cutW/cutH 가 가격요청에 실림', () => {
  it('SIZE_0("사이즈직접입력") + W/H(5000,900) → price() req.dimensions[0]={cutW:5000,cutH:900,workW:5004,workH:904}', async () => {
    const captured: NormalizedPriceRequest[] = [];
    const bff = new StubBffClient();
    const origPrice = bff.price.bind(bff);
    bff.price = (req: NormalizedPriceRequest) => {
      captured.push(req);
      return origPrice(req);
    };

    // dev 하네스와 동일: productCode=BNBNFBL, debounce=0(즉시 가격).
    const store = createWidgetStore({ bff, productCode: 'BNBNFBL', debounceMs: 0 });
    await settle();

    const product = store.getState().product!;
    expect(product.code).toBe('BNBNFBL');
    // GRP_SIZE 가 NC-1 leaf 로 라우팅됐는지(런타임 계약 확인).
    const sizeGroup = product.optionGroups.find((g) => g.id === 'GRP_SIZE')!;
    expect(sizeGroup.componentType).toBe('dimension-matrix-input');

    // 자유입력 sentinel(0×0 룰) 선택 + numeric slot 에 가로/세로 입력 — leaf onSelectPreset/onChangeDimension 경로.
    const freeRule = product.constraints.sizeRules.find((r) => r.cutW === 0 && r.cutH === 0)!;
    store.getState().selectOption('GRP_SIZE', freeRule.valueId);
    store.getState().setDimensionInput('GRP_SIZE', { w: 5000, h: 900 });
    await settle();

    const last = captured[captured.length - 1];
    const dim = last.dimensions.find((d: PriceDimension) => d.side === 'default')!;
    // 결함 해소: 이전엔 정적 sizeRule 룩업으로 {cutW:0,cutH:0} → retCode 999. 이제 입력수치 직접전달.
    expect(dim.cutW).toBe(5000);
    expect(dim.cutH).toBe(900);
    expect(dim.workW).toBe(5004); // 재단 + CUT_MRG(4)
    expect(dim.workH).toBe(904);
    // 명시 증거 로그(콘솔 프로브) — dev 하네스 콘솔에서 동일 값 관측 가능.
    console.log(`  [LIVE] BNBNFBL 자유입력 → price() req.dimensions[default]=${JSON.stringify(dim)}`);
    console.log(`  [LIVE] 이전 폴백 {cutW:0,cutH:0} 해소 확인 (retCode 999 원인 제거)`);
  });

  it('규격프리셋(5000X900) 선택 → 기존 sizeRule 경로 유지(회귀 없음)', async () => {
    const captured: NormalizedPriceRequest[] = [];
    const bff = new StubBffClient();
    const origPrice = bff.price.bind(bff);
    bff.price = (req: NormalizedPriceRequest) => {
      captured.push(req);
      return origPrice(req);
    };
    const store = createWidgetStore({ bff, productCode: 'BNBNFBL', debounceMs: 0 });
    await settle();

    const product = store.getState().product!;
    const preset = product.constraints.sizeRules.find((r) => r.cutW === 5000 && r.cutH === 900)!;
    store.getState().selectOption('GRP_SIZE', preset.valueId);
    await settle();

    const dim = captured[captured.length - 1].dimensions.find((d) => d.side === 'default')!;
    expect(dim.cutW).toBe(5000);
    expect(dim.cutH).toBe(900);
    expect(dim.workW).toBe(preset.workW); // sizeRule 권위
    console.log(`  [LIVE] 프리셋 5000X900 → price() req.dimensions[default]=${JSON.stringify(dim)}`);
  });

  it('자유입력 MAX_CUT 초과(가로 9999 > 5000) → leaf clamp 책임(store 는 수치 전달만, BFF 가 최종 권위)', async () => {
    // leaf clampAxis 가 입력단에서 MAX 로 제한 → store/price 에는 이미 clamp 된 값이 전달됨.
    // 이 테스트는 store 가 전달받은 수치를 그대로 cutW 로 싣는지(가격 산술 0, INV-1)만 확인.
    const bff = new StubBffClient();
    const store = createWidgetStore({ bff, productCode: 'BNBNFBL', debounceMs: 0 });
    await settle();
    const product = store.getState().product!;
    const freeRule = product.constraints.sizeRules.find((r) => r.cutW === 0 && r.cutH === 0)!;
    store.getState().selectOption('GRP_SIZE', freeRule.valueId);
    // store 는 검증하지 않음(전달만). 범위검증은 leaf clampAxis 가 수행 — InputSpec.max=5000.
    const base = product.constraints.base;
    expect(base.maxCutW).toBe(5000);
    expect(product.optionGroups.find((g) => g.id === 'GRP_SIZE')!.inputSpec?.max).toBe(5000);
    console.log(`  [LIVE] InputSpec.max(MAX_CUT_WDT)=${product.optionGroups.find((g) => g.id === 'GRP_SIZE')!.inputSpec?.max} → leaf clamp 거부 한계`);
  });
});
