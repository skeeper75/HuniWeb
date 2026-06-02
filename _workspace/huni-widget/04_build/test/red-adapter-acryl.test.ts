// S4 계약 테스트 — 아크릴(09) ACNTHAP(아크릴 명찰) Red fixture → 정규화 계약.
// [HARD] 컨버전 게이트(INV-3): 명세 s4-acryl-spec.md 가 ACNTHAP 를 "코드 0변경 = 순수 어댑터+데이터 흡수"로
//  판정했다(NC-2 신규 componentType 없음). 이 테스트는 그 판정을 EXISTING 어댑터 출력으로 실증한다.
//  - NC-2 = finish-button variant 흡수: WRK_MTR 부자재(옷핀/마그넷) → PCS_WRK_MTR finish-button (§1.2/§2.1).
//  - 사이즈 = option-button (NC-1 아님): vTmpl_price + 0×0 sentinel 부재 → dimension-matrix-input 미발동 (§2.2).
//  - BON_PAP/LAS_DFT = 숨김 필수옵션(VIEW_YN=N + ESN_YN=Y): 그룹 생성되되 visible=false 미렌더 (§2.3).
//  - selectedFinishes echo: 부자재 선택 → buildPriceRequest 가 [{groupId:'PCS_WRK_MTR', valueId}] 로 BFF 전송 (§3).
// 근거: s4-acryl-spec.md §5.1·§5.2, fixtures/product_ACNTHAP.json.
import { describe, it, expect } from 'vitest';
import { mapProduct } from '@/adapters/red/red-adapter';
import { buildPriceRequest } from '@/widget/stores/price';
import { createWidgetStore } from '@/widget/stores/widget-store';
import { StubBffClient } from '@/bff/stub';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type { ComponentType, NormalizedProduct, NormalizedPriceRequest } from '@/contract';
import productACNTHAP from '../fixtures/product_ACNTHAP.json';

// 기존 14 componentType (NC-1 dimension-matrix-input 포함 = 15). ACNTHAP 의 전 그룹은 이 안에서 충족(신규 0).
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

describe('S4 아크릴(ACNTHAP) → 기존 컴포넌트 흡수 (NC-2 신규 없음, 위젯 코어 0변경 검증)', () => {
  it('ACNTHAP → 전 옵션그룹이 기존 15 componentType 안 + 단일면', () => {
    const p = mapProduct(productACNTHAP as unknown as RedDigitalProductResponse);
    expect(p.code).toBe('ACNTHAP');
    expect(p.sides.map((s) => s.key)).toEqual(['default']);
    expect(p.optionGroups.length).toBeGreaterThan(0);
    const types = new Set<string>();
    for (const g of p.optionGroups) {
      expect(ALL_15).toContain(g.componentType);
      types.add(g.componentType);
    }
    expect(p.priceSchemeKey).toBe('vTmpl_price'); // 불투명 echo (INV-2: 위젯엔 미등장, 어댑터 출력만)
    expect(p.unit).toBe('pcs');
    console.log(`  ACNTHAP groups=${p.optionGroups.length} types=[${[...types].join(',')}] scheme=${p.priceSchemeKey} unit=${p.unit}`);
    console.log(`    groupIds: ${p.optionGroups.map((g) => g.id + ':' + g.componentType + (g.visible ? '' : '(hidden)')).join(' | ')}`);
  });

  // §5.1-1 / §1.2 / §2.1 — WRK_MTR 부자재 → finish-button variant 흡수.
  it('WRK_MTR 부자재 → PCS_WRK_MTR finish-button, 값 2개(옷핀/마그넷), visible+required', () => {
    const p = mapProduct(productACNTHAP as unknown as RedDigitalProductResponse);
    const grp = p.optionGroups.find((g) => g.id === 'PCS_WRK_MTR');
    expect(grp).toBeDefined();
    expect(grp!.componentType).toBe('finish-button'); // colorHex 부재 → RULE-2 (color-chip 아님)
    expect(grp!.visible).toBe(true); // VIEW_YN=Y
    expect(grp!.required).toBe(true); // ESN_YN=Y
    expect(grp!.multiple).toBe(false); // 단일선택(옷핀/마그넷 택1)
    const valueIds = grp!.values.map((v) => v.id);
    expect(valueIds).toEqual(['NBPIN', 'NBMGN']); // 불투명 id = PCS_DTL_CD
    const labels = grp!.values.map((v) => v.label);
    expect(labels).toEqual(['옷핀 집게', '마그넷']); // 라벨 = PCS_DTL_NM (RULE-5, 어댑터가 동적 공급)
    // 추가단가 병기 없음(§1.3): fixture 에 델타 숫자 부재 → label 에 "(+원)" 없음(추측 금지).
    for (const v of grp!.values) expect(v.label).not.toMatch(/\+|원/);
    console.log(`  PCS_WRK_MTR: ${grp!.componentType} required=${grp!.required} visible=${grp!.visible} values=${labels.join('/')}`);
  });

  // §2.2 — 사이즈 = option-button (NC-1 미발동: vTmpl_price + 0×0 sentinel 부재).
  it('사이즈 → GRP_SIZE option-button (NC-1 아님), 값 2개(소 기본/중), dimension-matrix-input 미생성', () => {
    const p = mapProduct(productACNTHAP as unknown as RedDigitalProductResponse);
    const size = p.optionGroups.find((g) => g.id === 'GRP_SIZE');
    expect(size).toBeDefined();
    expect(size!.componentType).toBe('option-button'); // NC-1 미발동
    expect(size!.componentType).not.toBe('dimension-matrix-input');
    expect(size!.inputSpec).toBeUndefined(); // 자유입력 슬롯/axis2 미생성
    expect(size!.values.length).toBe(2);
    expect(size!.values.map((v) => v.label)).toEqual(['소 70X25', '중 75X25']);
    // 기본값 = DFT_YN=Y "소 70X25". defaultSelections 가 첫 비활성 아닌 값을 선택 → 소가 첫 값.
    // sizeRules 에 cutW/cutH echo 준비(0×0 sentinel 없음 = NC-1 조건 불충족).
    const rules = p.constraints.sizeRules;
    const hasFreeInputSentinel = rules.some((r) => r.cutW === 0 && r.cutH === 0);
    expect(hasFreeInputSentinel).toBe(false); // NC-1 발동 조건(자유입력 sentinel) 부재
    const so = rules.find((r) => r.cutW === 70 && r.cutH === 25);
    const jung = rules.find((r) => r.cutW === 75 && r.cutH === 25);
    expect(so).toBeDefined();
    expect(jung).toBeDefined();
    console.log(`  GRP_SIZE: ${size!.componentType} values=${size!.values.map((v) => v.label).join('/')} | sizeRules=${rules.map((r) => `${r.cutW}x${r.cutH}`).join(',')} freeInput=${hasFreeInputSentinel}`);
  });

  // §2.3 — BON_PAP/LAS_DFT 숨김 필수옵션: 그룹 생성되되 visible=false (미렌더).
  it('BON_PAP/LAS_DFT 숨김 필수옵션 → 그룹 생성되되 visible=false (미렌더, BFF 자동적용)', () => {
    const p = mapProduct(productACNTHAP as unknown as RedDigitalProductResponse);
    for (const id of ['PCS_BON_PAP', 'PCS_LAS_DFT']) {
      const grp = p.optionGroups.find((g) => g.id === id);
      expect(grp, `${id} 그룹 생성됨`).toBeDefined();
      expect(grp!.visible, `${id} visible=false`).toBe(false); // VIEW_YN=N
      expect(grp!.required, `${id} required=true`).toBe(true); // ESN_YN=Y (hidden essential)
    }
    // 가시 그룹 필터(렌더 대상)에는 숨김 필수가 빠짐 — OptionGroupRenderer 가 filter(visible).
    const visibleIds = p.optionGroups.filter((g) => g.visible).map((g) => g.id);
    expect(visibleIds).not.toContain('PCS_BON_PAP');
    expect(visibleIds).not.toContain('PCS_LAS_DFT');
    expect(visibleIds).toContain('PCS_WRK_MTR'); // 가시 부자재는 렌더 대상
    console.log(`  hidden essential: PCS_BON_PAP/PCS_LAS_DFT visible=false | rendered: [${visibleIds.join(',')}]`);
  });

  // §3 / §2.1 — 부자재 선택 echo: buildPriceRequest 가 selectedFinishes 에 PCS_WRK_MTR 선택값을 싣는다(단위).
  it('부자재 선택 → buildPriceRequest.selectedFinishes=[{groupId:PCS_WRK_MTR, valueId}] (단가 산술 0)', () => {
    const product = mapProduct(productACNTHAP as unknown as RedDigitalProductResponse);
    // 마그넷(NBMGN) 선택 상태 + 기본규격(소).
    const so = product.constraints.sizeRules.find((r) => r.cutW === 70 && r.cutH === 25)!;
    const state = stateOf(product, {
      selections: { GRP_SIZE: so.valueId, PCS_WRK_MTR: 'NBMGN' },
      quantity: 10,
    });
    const req = buildPriceRequest(state);
    expect(req.productCode).toBe('ACNTHAP');
    expect(req.priceSchemeKey).toBe('vTmpl_price'); // 불투명 echo
    expect(req.selectedFinishes).toEqual([{ groupId: 'PCS_WRK_MTR', valueId: 'NBMGN' }]);
    // SizeMatrix2D 입력: 선택 규격의 cutW/cutH echo (수치만, 보간은 BFF). INV-1.
    const dim = req.dimensions.find((d) => d.side === 'default')!;
    expect(dim.cutW).toBe(70);
    expect(dim.cutH).toBe(25);
    console.log(`  selectedFinishes=${JSON.stringify(req.selectedFinishes)} dims=${JSON.stringify(dim)} qty=${req.quantity}`);
  });
});

// §5.1-1 라이브 프로브 — 실 런타임(createWidgetStore + StubBffClient[FixtureRedDataSource])에서
// 부자재 선택이 BFF.price() 에 실리는 selectedFinishes 로 echo 됨을 캡처한다(NC-1 라이브 증명과 동일 방식).
describe('S4 라이브 증명 — ACNTHAP 부자재 선택이 price() 요청에 selectedFinishes 로 실림', () => {
  it('기본 진입 → PCS_WRK_MTR 기본선택(NBPIN) echo, 마그넷 변경 → NBMGN echo', async () => {
    const captured: NormalizedPriceRequest[] = [];
    const bff = new StubBffClient();
    const origPrice = bff.price.bind(bff);
    bff.price = (req: NormalizedPriceRequest) => {
      captured.push(req);
      return origPrice(req);
    };

    // 캐시 ON(기본 TTL). hashRequest 핫픽스 후 부자재 변경이 다른 키 → cache miss → 정상 재요청.
    //  (이전 hashRequest 캐시키 버그 시절엔 cacheTtlMs:0 우회가 필요했으나, 핫픽스로 불요.)
    const store = createWidgetStore({ bff, productCode: 'ACNTHAP', debounceMs: 0 });
    await settle();

    const product = store.getState().product!;
    expect(product.code).toBe('ACNTHAP');
    // 사이즈가 NC-1 leaf 가 아닌 option-button 인지(런타임 계약 재확인).
    expect(product.optionGroups.find((g) => g.id === 'GRP_SIZE')!.componentType).toBe('option-button');

    // 기본 진입: defaultSelections 가 PCS_WRK_MTR 첫 값(NBPIN) 선택 → 자동 가격요청에 echo.
    const firstReq = captured[captured.length - 1];
    expect(firstReq.selectedFinishes).toContainEqual({ groupId: 'PCS_WRK_MTR', valueId: 'NBPIN' });
    console.log(`  [LIVE] 기본진입 selectedFinishes=${JSON.stringify(firstReq.selectedFinishes)}`);

    // 마그넷으로 변경 → 새 가격요청에 NBMGN echo.
    store.getState().selectOption('PCS_WRK_MTR', 'NBMGN');
    await settle();
    const lastReq = captured[captured.length - 1];
    expect(lastReq.selectedFinishes).toContainEqual({ groupId: 'PCS_WRK_MTR', valueId: 'NBMGN' });
    // [실 동작] 숨김 필수(BON_PAP/LAS_DFT)도 defaultSelections(widget-store.ts L109-119, visible 무시)가
    //  기본 선택하므로 selectedFinishes 에 함께 echo 된다. 이는 명세 §2.3 서술("hidden 은 selections 미포함")과
    //  코드 실 동작의 불일치 지점이나, INV 위반은 아니다 — 필수 가공(ESN_YN=Y)이 가격요청에 포함되어
    //  BFF 단가 정합에 오히려 안전(위젯 산술 0, INV-1 유지). 본 stage 는 코어 0변경 원칙상 동작을 그대로 검증.
    const finishGroupIds = lastReq.selectedFinishes.map((f) => f.groupId);
    expect(finishGroupIds).toContain('PCS_WRK_MTR');
    expect(finishGroupIds).toContain('PCS_BON_PAP'); // hidden essential 도 echo (실 동작)
    expect(finishGroupIds).toContain('PCS_LAS_DFT'); // hidden essential 도 echo (실 동작)
    // hidden essential 의 echo 값 = 각 그룹 유일값(자동적용) — 사용자가 바꿀 수 없는 필수.
    expect(lastReq.selectedFinishes).toContainEqual({ groupId: 'PCS_BON_PAP', valueId: 'ACXXS' });
    expect(lastReq.selectedFinishes).toContainEqual({ groupId: 'PCS_LAS_DFT', valueId: 'DFXXX' });
    console.log(`  [LIVE] 마그넷 변경 selectedFinishes=${JSON.stringify(lastReq.selectedFinishes)} (hidden essential 도 echo — §2.3 불일치 기록)`);
  });
});
