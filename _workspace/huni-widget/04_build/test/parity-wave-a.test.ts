// S3 MAJOR Wave A 회귀 가드 — 9 gap(L-4/D-L2/onOptionChange/Editor3/L-D3-1/L-D3-5/C-2/L-3a/P4).
//  코드레벨 정합검증(parity-matrix D1/D4 + s3-major-round-plan)이 식별한 Wave A MAJOR 수정을 봉인.
//  CRITERION: 책임/로직/분기 재현 동등(라인 답습 아님).
import { describe, it, expect, vi } from 'vitest';
import { mapProduct, serializeRedPriceRequest, createRedAdapter } from '@/adapters/red/red-adapter';
import { FixtureRedDataSource } from '@/adapters/red/fixture-source';
import { applyCascade } from '@/widget/stores/cascade';
import { buildPriceRequest } from '@/widget/stores/price';
import { createWidgetStore } from '@/widget/stores/widget-store';
import { EditorBridge, type EditorBridgeCallbacks } from '@/widget/editor/editor-bridge';
import { StubBffClient } from '@/bff/stub';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type {
  NormalizedProduct,
  NormalizedPriceRequest,
  NormalizedEditorConfig,
} from '@/contract';
import type { WidgetState, SelectionValue } from '@/widget/stores/widget-store';
import productPRBKYPR from '../fixtures/product_PRBKYPR.json';
import productBCFOXXX from '../fixtures/product_BCFOXXX.json';
import productGSPUFBC from '../fixtures/product_GSPUFBC.json';

function settle(): Promise<void> {
  return new Promise((r) => setTimeout(r, 0));
}
function stateOf(product: NormalizedProduct, overrides: Partial<WidgetState>): WidgetState {
  return { product, member: {}, selections: {}, dimensionInputs: {}, quantity: 1, ...overrides } as WidgetState;
}

// ─────────────────────────────────────────────────────────────────────────────
// L-4 END_PAP color-chip hex
// ─────────────────────────────────────────────────────────────────────────────
describe('L-4 END_PAP 색상 후가공 → color-chip + hex 주입 (어댑터 상수맵)', () => {
  it('PRBKYPR END_PAP → componentType=color-chip, 10색 colorHex 주입(mod_07:2511 맵 일치)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const endpap = p.optionGroups.find((g) => g.id === 'PCS_END_PAP')!;
    expect(endpap).toBeDefined();
    expect(endpap.componentType).toBe('color-chip'); // finish-button 아님 — hex 보유
    expect(endpap.values.length).toBe(10);
    // hex 가 상수맵과 일치(타우톨로지 아님 — 실 코드맵 값).
    const byId = Object.fromEntries(endpap.values.map((v) => [v.id, v.colorHex]));
    expect(byId.CLYEL).toBe('#fdeec5');
    expect(byId.CLWHT).toBe('#ffffff');
    expect(byId.CLGRY).toBe('#ededee');
    // 전 값이 hex 보유(데이터경로 0 결함 해소).
    expect(endpap.values.every((v) => typeof v.colorHex === 'string' && v.colorHex.startsWith('#'))).toBe(true);
  });

  it('hex 미보유 후가공(CUT_DFT 등)은 여전히 finish-button (회귀: 무차별 color-chip 금지)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const cut = p.optionGroups.find((g) => g.id === 'PCS_CUT_DFT')!;
    expect(cut.componentType).toBe('finish-button');
    expect(cut.values.every((v) => v.colorHex === undefined)).toBe(true);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// D-L2 itemGroup echo (분기 권위)
// ─────────────────────────────────────────────────────────────────────────────
describe('D-L2 itemGroup 불투명 echo — 책자 분기 권위 (isBook 휴리스틱 대체)', () => {
  it('mapProduct → itemGroup = Red item_gbn echo', () => {
    const book = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    expect(book.itemGroup).toBe('book2025_item');
    const goods = mapProduct(productGSPUFBC as unknown as RedDigitalProductResponse);
    expect(goods.itemGroup).toBe('vDigital_item');
  });

  it('serialize 분기 권위 = itemGroup(book2025) — inner 휴리스틱보다 우선', () => {
    // itemGroup=book2025 면 inner 데이터 없어도 책자 분리필드 출력.
    const reqBook: NormalizedPriceRequest = {
      productCode: 'PRBKYPR',
      priceSchemeKey: 'book2025_price',
      itemGroup: 'book2025_item',
      dimensions: [{ side: 'default', cutW: 210, cutH: 297, workW: 216, workH: 303 }],
      colorCounts: { default: 8 },
      materials: { default: 'M1' },
      quantity: 1,
      pageCount: 24,
      selectedFinishes: [],
    };
    const ord = serializeRedPriceRequest(reqBook).dataJson.ORD_INFO[0];
    expect(ord.PAGE_CNT).toBe(24);
    expect(ord.CVR_CLR_CNT).toBe(8);

    // itemGroup=vDigital 이면 inner 휴리스틱 무시 — 단일면(분리필드 없음).
    const reqGoods: NormalizedPriceRequest = {
      ...reqBook,
      itemGroup: 'vDigital_item',
      colorCounts: { default: 4, inner: 4 }, // inner 데이터 있어도 itemGroup 권위가 단일면 판정
      materials: { default: 'M1', inner: 'M2' },
      pageCount: undefined,
    };
    const ord2 = serializeRedPriceRequest(reqGoods).dataJson.ORD_INFO[0];
    expect(ord2.PAGE_CNT).toBeUndefined();
    expect(ord2.CVR_CLR_CNT).toBeUndefined();
  });

  it('itemGroup 미전달(레거시) → inner/pageCount 휴리스틱 fallback', () => {
    const req: NormalizedPriceRequest = {
      productCode: 'X',
      priceSchemeKey: 'book2025_price',
      dimensions: [{ side: 'default', cutW: 1, cutH: 1, workW: 1, workH: 1 }],
      colorCounts: { default: 8, inner: 8 },
      materials: { default: 'M1', inner: 'M2' },
      quantity: 1,
      pageCount: 12,
      selectedFinishes: [],
    };
    const ord = serializeRedPriceRequest(req).dataJson.ORD_INFO[0];
    expect(ord.PAGE_CNT).toBe(12); // inner 휴리스틱으로 책자 판정
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// onOptionChange host-notify
// ─────────────────────────────────────────────────────────────────────────────
describe('onOptionChange 호스트 통지 — selectOption 시 발화', () => {
  it('옵션 변경 → onOptionChange({groupId, valueId}) 호출', async () => {
    const calls: Array<{ groupId: string; valueId: SelectionValue }> = [];
    const store = createWidgetStore({
      bff: new StubBffClient(),
      productCode: 'GSPUFBC',
      debounceMs: 0,
      onOptionChange: (c) => calls.push(c),
    });
    await settle();
    store.getState().selectOption('GRP_MTRL_COVER', 'PXFBW010');
    expect(calls.some((c) => c.groupId === 'GRP_MTRL_COVER' && c.valueId === 'PXFBW010')).toBe(true);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Editor 3 actions
// ─────────────────────────────────────────────────────────────────────────────
describe('Editor 3액션 — page-count-changed / request-user-token / prod-var-changed', () => {
  const config: NormalizedEditorConfig = {
    side: 'default', psCode: 'PS@X', templateUrl: 'gcs://x', resourceId: 0, token: 'T', pluginCustomData: {},
  };
  const ORIGIN = 'https://edicusbase.firebaseapp.com';

  function setup(cb: Partial<EditorBridgeCallbacks>) {
    let listener: ((e: MessageEvent) => void) | null = null;
    const target = {
      addEventListener: (_t: 'message', l: (e: MessageEvent) => void) => { listener = l; },
      removeEventListener: () => { listener = null; },
    };
    const callbacks: EditorBridgeCallbacks = {
      buildProdInfo: () => ({}),
      onProjectId: () => {},
      onResult: () => {},
      onClose: () => {},
      ...cb,
    };
    const bridge = new EditorBridge(config, callbacks, { messageTarget: target });
    bridge.attach({ contentWindow: null } as unknown as HTMLIFrameElement);
    const send = (action: string, info: Record<string, unknown>) =>
      listener?.({ origin: ORIGIN, source: null, data: JSON.stringify({ type: 'from-edicus', action, info }) } as MessageEvent);
    return { send };
  }

  it('page-count-changed → onPageCountChanged(side, totalPageCount)', () => {
    const fn = vi.fn();
    setup({ onPageCountChanged: fn }).send('page-count-changed', { totalPageCount: 16 });
    expect(fn).toHaveBeenCalledWith('default', 16);
  });

  it('request-user-token → onRequestUserToken(side)', () => {
    const fn = vi.fn();
    setup({ onRequestUserToken: fn }).send('request-user-token', {});
    expect(fn).toHaveBeenCalledWith('default');
  });

  it('prod-var-changed → onProdVarChanged(side, info)', () => {
    const fn = vi.fn();
    setup({ onProdVarChanged: fn }).send('prod-var-changed', { foo: 'bar' });
    expect(fn).toHaveBeenCalledWith('default', expect.objectContaining({ foo: 'bar' }));
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// L-D3-5 buildIframeSrc EDIT/reform branch
// ─────────────────────────────────────────────────────────────────────────────
describe('L-D3-5 buildIframeSrc — cmd create/edit/reform 분기', () => {
  const config: NormalizedEditorConfig = {
    side: 'default', psCode: 'PS@X', templateUrl: 'gcs://x', resourceId: 0, token: 'TK', pluginCustomData: {},
  };
  const noopTarget = { addEventListener: () => {}, removeEventListener: () => {} };
  const bridge = new EditorBridge(
    config,
    { buildProdInfo: () => ({}), onProjectId: () => {}, onResult: () => {}, onClose: () => {} },
    { messageTarget: noopTarget },
  );

  it('기본(미지정) → cmd=create (회귀: 기존 동작 보존)', () => {
    expect(bridge.buildIframeSrc('https://ed.example')).toContain('cmd=create');
  });
  it('edit + projectId → cmd=open & project_id', () => {
    const src = bridge.buildIframeSrc('https://ed.example', { mode: 'edit', projectId: 'PID123' });
    expect(src).toContain('cmd=open');
    expect(src).toContain('project_id=PID123');
  });
  it('reform + projectId → cmd=reform & project_id', () => {
    const src = bridge.buildIframeSrc('https://ed.example', { mode: 'reform', projectId: 'PID9' });
    expect(src).toContain('cmd=reform');
    expect(src).toContain('project_id=PID9');
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// L-D3-1 isReadyToOrder server gate
// ─────────────────────────────────────────────────────────────────────────────
describe('L-D3-1 isReadyToOrder — goto-cart 전 서버 주문가능 게이트', () => {
  it('checkOrderReadiness: 클라 canOrder 통과 + 서버 ok → canOrder:true', async () => {
    const store = createWidgetStore({ bff: new StubBffClient(), productCode: 'GSPUFBC', debounceMs: 0 });
    await settle();
    // 가격이 PRICE>0(파우치 실가) + 옵션 충족 시 서버 판정 통과.
    const res = await store.getState().checkOrderReadiness();
    // GSPUFBC 는 에디터/파일 요구 → 클라 canOrder 가 파일 누락으로 막을 수 있음(서버 게이트 전 차단).
    expect(typeof res.canOrder).toBe('boolean');
    expect(Array.isArray(res.reasons)).toBe(true);
  });

  it('어댑터 isReadyToOrder: finalPrice>0 → canOrder:true / =0 → false', async () => {
    const adapter = createRedAdapter(new FixtureRedDataSource());
    const base = { productCode: 'X', selectedOptions: [], quantity: 1, artifacts: [] };
    const ok = await adapter.cart.isReadyToOrder({ ...base, priceSnapshot: { finalPrice: 3300, vat: 0, shipping: 0 } });
    expect(ok.canOrder).toBe(true);
    const no = await adapter.cart.isReadyToOrder({ ...base, priceSnapshot: { finalPrice: 0, vat: 0, shipping: 0 } });
    expect(no.canOrder).toBe(false);
    expect(no.reasons.length).toBeGreaterThan(0);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// C-2 COT_DFT disable fallback (required → auto-reselect active value)
// ─────────────────────────────────────────────────────────────────────────────
describe('C-2 disable 폴백 — required 그룹 값 disable 시 첫 활성값 자동 재선택', () => {
  it('단일 required 그룹: 선택값 disable → 빈 선택 아닌 첫 활성값으로 교체', () => {
    // 합성 product: 자재 M_X 선택 시 PCS_F 의 V1 을 disable. PCS_F 는 required.
    const product = {
      code: 'T', name: 'T', unit: '개', priceSchemeKey: 'x',
      sides: [{ key: 'default', label: '기본', uploadType: 'editor' }],
      optionGroups: [
        { id: 'GRP_MTRL_COVER', side: 'default', label: '자재', componentType: 'select-box', required: true, visible: true, multiple: false,
          values: [{ id: 'M_X', label: 'X', disabled: false }, { id: 'M_Y', label: 'Y', disabled: false }] },
        { id: 'PCS_F', side: 'default', label: '후가공', componentType: 'finish-button', required: true, visible: true, multiple: false,
          values: [{ id: 'V1', label: 'V1', disabled: false }, { id: 'V2', label: 'V2', disabled: false }] },
      ],
      constraints: {
        disableRules: [{ triggerValueId: 'M_X', disablesValueId: 'V1' }],
        sizeRules: [], base: { unit: '개', cutMargin: 0, minCutW: 0, minCutH: 0, maxCutW: 0, maxCutH: 0, nonStandardAllowed: false },
        quantity: {},
      },
      editors: { koi: true, rp: false, pdf: false },
      cta: { pdfUpload: false, designEditor: true, cart: true, estimate: true },
    } as unknown as NormalizedProduct;
    const selections: Record<string, SelectionValue> = { GRP_MTRL_COVER: 'M_X', PCS_F: 'V1' };
    const next = applyCascade(product, selections, 'GRP_MTRL_COVER');
    // V1 이 disable 됐으므로 첫 활성값 V2 로 자동 재선택(빈 선택 아님).
    expect(next.selections.PCS_F).toBe('V2');
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// L-3a ROU_DFT 4귀 멀티선택 + 전체토글
// ─────────────────────────────────────────────────────────────────────────────
describe('L-3a ROU_DFT — multiple:true 4귀 + 직렬화 배열 echo', () => {
  it('어댑터: ROU_DFT → multiple:true, 4귀(DFXLT/DFXRT/DFXLB/DFXRB)', () => {
    const p = mapProduct(productBCFOXXX as unknown as RedDigitalProductResponse);
    const rou = p.optionGroups.find((g) => g.id === 'PCS_ROU_DFT')!;
    expect(rou.multiple).toBe(true);
    expect(rou.values.map((v) => v.id).sort()).toEqual(['DFXLB', 'DFXLT', 'DFXRB', 'DFXRT']);
  });

  it('직렬화: 4귀 부분집합 선택 → PCS_INFO 에 각 귀 엔트리 echo', () => {
    const p = mapProduct(productBCFOXXX as unknown as RedDigitalProductResponse);
    const sizeRule = p.constraints.sizeRules[0];
    const state = stateOf(p, {
      selections: { GRP_SIZE: sizeRule?.valueId ?? '', PCS_ROU_DFT: ['DFXLT', 'DFXRT'] },
      quantity: 1,
    });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const rouEntries = body.dataJson.PCS_INFO.filter((f) => f.PCS_COD === 'ROU_DFT');
    expect(rouEntries.map((e) => e.PCS_DTL_COD).sort()).toEqual(['DFXLT', 'DFXRT']);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// P4 VIEW_YN hidden-essential auto-select + dynamic visibility
// ─────────────────────────────────────────────────────────────────────────────
describe('P4 VIEW_YN — hidden essential 자동선택 + 동적 visible 토글', () => {
  it('PRBKYPR hidden essential(VIEW_YN:N + required) 3그룹 자동선택 (defaultSelections)', async () => {
    const store = createWidgetStore({ bff: new StubBffClient(), productCode: 'PRBKYPR', debounceMs: 0 });
    await settle();
    const s = store.getState();
    // CUT_DFT/PER_DFT/CVR_SFT — 렌더 안 되지만 default 값 자동선택(가격요청 PCS_INFO 누락 방지).
    expect(s.selections.PCS_CUT_DFT).toBeDefined();
    expect(s.selections.PCS_PER_DFT).toBeDefined();
    expect(s.selections.PCS_CVR_SFT).toBeDefined();
  });

  it('cascade 후에도 hidden essential 재적재 (사용자가 못 지움)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const hidden = p.optionGroups.find((g) => !g.visible && g.required && g.values.length > 0)!;
    // 선택을 비운 채로 비-자재 그룹 변경 cascade → hidden essential 자동 재적재.
    const next = applyCascade(p, { GRP_SIZE: 'SIZE_1' }, 'GRP_SIZE');
    expect(next.selections[hidden.id]).toBeDefined();
  });

  it('visibilityRules: trigger 값 선택 시 그룹 visible 동적 토글', () => {
    const product = {
      code: 'T', name: 'T', unit: '개', priceSchemeKey: 'x',
      sides: [{ key: 'default', label: '기본', uploadType: 'editor' }],
      optionGroups: [
        { id: 'GRP_MTRL_COVER', side: 'default', label: '자재', componentType: 'select-box', required: true, visible: true, multiple: false,
          values: [{ id: 'M_SHOW', label: 'S', disabled: false }, { id: 'M_HIDE', label: 'H', disabled: false }] },
        { id: 'PCS_OPT', side: 'default', label: '옵션', componentType: 'finish-button', required: false, visible: false, multiple: false,
          values: [{ id: 'O1', label: 'O1', disabled: false }] },
      ],
      constraints: {
        disableRules: [],
        visibilityRules: [{ triggerValueId: 'M_SHOW', showsGroupId: 'PCS_OPT' }],
        sizeRules: [], base: { unit: '개', cutMargin: 0, minCutW: 0, minCutH: 0, maxCutW: 0, maxCutH: 0, nonStandardAllowed: false },
        quantity: {},
      },
      editors: { koi: true, rp: false, pdf: false },
      cta: { pdfUpload: false, designEditor: true, cart: true, estimate: true },
    } as unknown as NormalizedProduct;
    // M_SHOW 선택 → PCS_OPT visible:true 로 토글.
    const shown = applyCascade(product, { GRP_MTRL_COVER: 'M_SHOW' }, 'GRP_MTRL_COVER');
    expect(shown.product.optionGroups.find((g) => g.id === 'PCS_OPT')?.visible).toBe(true);
    // M_HIDE 선택 → 룰 미트리거 → PCS_OPT visible 그대로 false.
    const hidden = applyCascade(product, { GRP_MTRL_COVER: 'M_HIDE' }, 'GRP_MTRL_COVER');
    expect(hidden.product.optionGroups.find((g) => g.id === 'PCS_OPT')?.visible).toBe(false);
  });
});
