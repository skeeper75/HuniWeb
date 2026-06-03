// 팀 교차검증 결함 회귀 가드 — C-B/G-1/G-2/PRICE=0 진단.
//  CRITERION: 책임/로직/분기 재현 동등. 근거: crossverify-findings.md + mod_05/mod_06 권위.
//  [HARD 도메인] RedPrinting 위젯은 PRICE=0 을 정상 반환하지 않는다 — 0 은 항상 우리측 요청/세션/스펙 결함.
import { describe, it, expect, vi } from 'vitest';
import { mapProduct, serializeRedPriceRequest, mapPriceResponse } from '@/adapters/red/red-adapter';
import { applyCascade } from '@/widget/stores/cascade';
import { createWidgetStore } from '@/widget/stores/widget-store';
import { StubBffClient } from '@/bff/stub';
import { EditorBridge, type EditorBridgeCallbacks, type MessageTarget } from '@/widget/editor/editor-bridge';
import type { RedDigitalProductResponse, RedPriceResponse } from '@/adapters/red/red-types';
import type { NormalizedPriceRequest, NormalizedEditorConfig } from '@/contract';
import type { SelectionValue, WidgetStore } from '@/widget/stores/widget-store';
import productPRBKYPR from '../fixtures/product_PRBKYPR.json';
import productACPDSTD from '../fixtures/product_ACPDSTD.json';
import productAIPPCUT from '../fixtures/product_AIPPCUT.json'; // W2-a 회귀: 단일 add-on SUB_MTR(MTRL_CD="")

// ─────────────────────────────────────────────────────────────────────────────
// C-B — 자재 왕복 시 required 합성그룹 self-heal (visible/hidden 대칭)
// ─────────────────────────────────────────────────────────────────────────────
describe('C-B 자재 왕복 — required 합성그룹(COT) re-enable 시 첫 활성값 재적재', () => {
  it('RXOMO080(COT disable) → RXART300(re-enable) 왕복 후 coating selection 복구(빈값 아님)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const coat = p.optionGroups.find((g) => g.id === 'PCS_COT_DFT__coating')!;
    expect(coat.visible).toBe(true); // 책자 코팅은 visible+required (hidden essential 아님)
    expect(coat.required).toBe(true);

    // 코팅 선택 상태에서 저평량지(RXOMO080) 선택 → COT disable + 선택 해제.
    const sel0: Record<string, SelectionValue> = {
      GRP_MTRL_COVER: 'RXART300',
      PCS_COT_DFT__side: 'S',
      PCS_COT_DFT__coating: coat.values[0].id,
    };
    const disabled = applyCascade(p, { ...sel0, GRP_MTRL_COVER: 'RXOMO080' }, 'GRP_MTRL_COVER');
    expect(disabled.selections.PCS_COT_DFT__coating).toBeUndefined(); // disable 시 해제(정상)

    // 자재 복귀(RXART300, COT 비-disable) → re-enable. 이전엔 undefined 영구 잔존(C-B 버그).
    const restored = applyCascade(disabled.product, { ...disabled.selections, GRP_MTRL_COVER: 'RXART300' }, 'GRP_MTRL_COVER');
    expect(restored.selections.PCS_COT_DFT__coating).toBe(coat.values[0].id); // 첫 활성값 자가복구
  });

  it('전체 disable 상태(활성값 0)면 self-heal skip — 빈 채로 둠(과잉선택 0)', () => {
    // 합성 product: 자재 M_X 가 PCS_F 전체 disable. required 지만 활성값 없으면 채우지 않음.
    const product = {
      code: 'T', name: 'T', unit: '개', priceSchemeKey: 'x', itemGroup: 'vDigital_item',
      sides: [{ key: 'default', label: '기본', uploadType: 'editor' }],
      optionGroups: [
        { id: 'GRP_MTRL_COVER', side: 'default', label: '자재', componentType: 'select-box', required: true, visible: true, multiple: false,
          values: [{ id: 'M_X', label: 'X', disabled: false }] },
        { id: 'PCS_F', side: 'default', label: '후가공', componentType: 'finish-button', required: true, visible: true, multiple: false,
          values: [{ id: 'V1', label: 'V1', disabled: false }] },
      ],
      constraints: {
        disableRules: [{ triggerValueId: 'M_X', disablesGroupId: 'PCS_F' }], // 그룹 전체 disable
        sizeRules: [], base: { unit: '개', cutMargin: 0, minCutW: 0, minCutH: 0, maxCutW: 0, maxCutH: 0, nonStandardAllowed: false },
        quantity: {},
      },
      editors: { koi: true, rp: false, pdf: false },
      cta: { pdfUpload: false, designEditor: true, cart: true, estimate: true },
    } as unknown as Parameters<typeof applyCascade>[0];
    const next = applyCascade(product, { GRP_MTRL_COVER: 'M_X' }, 'GRP_MTRL_COVER');
    expect(next.selections.PCS_F).toBeUndefined(); // 전체 disable → 채울 활성값 없음 → 빈 채로
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// [Round-2 교차검증 정정] 구 "G-1 ATTB=orderQty" 는 권위 날조였음(07_parity/crossverify-round2-findings §2).
//  인용 mod_07:2597/2954/2470/3572 는 deob 부존재(deob_07=2607줄/deob_06=1392줄). 실 deob ATTB 대입
//  4곳(1008 size장수/2162 ""/2387 속성값/06:1250 prnCnt) 중 ORD_CNT 0건. 캡처 실측도 ORD_CNT=1 뿐.
//  처방: PDT_WRK 4/4 ATTB=""(W1-b 제거) / ACPDSTD SUB_MTR 권위 ""(deob_07:2162, W2-a 엔트리-shape 이연)
//   / WRK_MTR·DIR_MTR 은 ATTB=사용자 건수(N) echo — qty-sweep 라이브 검증(D-1 RESOLVED, Red 값 일치).
//  아래는 현 동작 characterization + 정직 표기(권위 입증 아님).
// ─────────────────────────────────────────────────────────────────────────────
function priceReqWith(productCode: string, groupId: string, quantity: number): NormalizedPriceRequest {
  return {
    productCode,
    priceSchemeKey: 'tmpl_price',
    itemGroup: 'vDigital_item',
    dimensions: [{ side: 'default', cutW: 100, cutH: 100, workW: 100, workH: 100 }],
    colorCounts: { default: 4 },
    materials: { default: 'PXX' },
    quantity,
    selectedFinishes: [{ groupId, valueId: 'X001' }],
  };
}

describe('자재연결 ATTB — Round-2 정정 (현 동작 characterization + 정직표기)', () => {
  it('WRK_MTR(GSTGMIC) → ATTB=건수 echo (D-1 RESOLVED: qty-sweep 라이브 검증)', () => {
    const entry = serializeRedPriceRequest(priceReqWith('GSTGMIC', 'PCS_WRK_MTR', 500)).dataJson.PCS_INFO
      .find((e) => e.PCS_COD === 'WRK_MTR')!;
    // [D-1 RESOLVED] qty-sweep(GSTGMIC/ACNTHAP) ATTB가 {2,10}로 건수 따라 변함·PRICE 선형 → ATTB=String(건수) 정당.
    //  Red 는 건수를 PRN_CNT 축에 싣고 우리는 ORD_CNT 축(G-6, 잠복/컨버전 게이트) — 값은 일치, 필드축만 별건.
    expect(entry.ATTB).toBe('500');
    expect(entry.ATTB_2).toBe(''); // 빈슬롯 운용
  });

  it('DIR_MTR → ATTB=건수 echo (D-1 RESOLVED: GSPDLNG/GSTBMWM 라이브 검증)', () => {
    const entry = serializeRedPriceRequest(priceReqWith('GSBKLAP', 'PCS_DIR_MTR', 12)).dataJson.PCS_INFO
      .find((e) => e.PCS_COD === 'DIR_MTR')!;
    // [D-1 RESOLVED] GSPDLNG/GSTBMWM(DIR_MTR) qty-sweep ATTB {2,10}·PRICE 선형 → ATTB=String(건수) 값 정당.
    //  (이 테스트는 GBKLAP serializer-단위지만 값 권위는 실 DIR_MTR 상품 라이브로 확보.) 의류 DIR_MTR 유지=G-5 확정.
    expect(entry.ATTB).toBe('12');
  });

  it('PDT_WRK → ATTB="" (W1-b: 캡처 GSPUFBC×2·GSTGMIC 4/4 ATTB="", ORD_CNT=1 에도 "")', () => {
    const pdt = serializeRedPriceRequest(priceReqWith('GSTGMIC', 'PCS_PDT_WRK', 500)).dataJson.PCS_INFO
      .find((e) => e.PCS_COD === 'PDT_WRK')!;
    expect(pdt.ATTB).toBe(''); // 수량 echo 아님 확정 — QUANTITY_ECHO_PCS 에서 제거됨
  });

  it('[W2-a 해소] ACPDSTD material-multi SUB_MTR → ATTB="" (권위 deob_07:2162, quantity echo 차단)', () => {
    // A-2 해소: SUB_MTR 이중의미 평면화 보정. 다종 자재선택형(ACPDSTD: MTRL_CD 12종 distinct·ATTB_CD None)은
    //  Red 권위(deob_07:2162 material-multi)상 ATTB="" — String(qty) 오echo 제거.
    //  구현: 어댑터 isMaterialMultiSubMtr 가 엔트리-shape(MTRL_CD 보유·다종·ATTB_CD 부재)로 판정해 OptionValue.attb=''
    //  적재 → serialize 의 `f.attb ?? echo` 가 '' 로 단락. INV-3: store/계약 무변경(코어 0줄), 어댑터 전용.
    //  [신뢰등급] ACPDSTD 가격경로 캡처 0건 → "올바른 값"은 deob 권위("")에만 의존(캡처 반증 부재).
    const p = mapProduct(productACPDSTD as unknown as RedDigitalProductResponse);
    const sub = p.optionGroups.find((g) => g.id === 'PCS_SUB_MTR')!;
    // 어댑터가 material-multi 엔트리 OptionValue 에 attb='' 를 명시 적재했는지(직렬화 전 확인).
    expect(sub.values[0].attb).toBe('');
    const subEntry = serializeRedPriceRequest({
      ...priceReqWith('ACPDSTD', 'PCS_SUB_MTR', 50),
      selectedFinishes: [{ groupId: 'PCS_SUB_MTR', valueId: sub.values[0].id, attb: sub.values[0].attb }],
    }).dataJson.PCS_INFO.find((e) => e.PCS_COD === 'SUB_MTR')!;
    expect(subEntry.ATTB).toBe(''); // [W2-a 해소] 권위 ""(deob_07:2162) — quantity("50") 오echo 아님
  });

  it('[W2-a 회귀] AIPPCUT 단일 add-on SUB_MTR → ATTB=quantity echo 보존(MTRL_CD="" → material-multi 아님)', () => {
    // 단일 add-on(에코백 EC001, MTRL_CD 전부 "")은 isMaterialMultiSubMtr=false → attb=undefined 유지.
    //  serialize 가 echo 경로(String(quantity))로 직렬화 → 라이브 캡처(b1_AIPPCUT.json) ATTB=1/ATTB_2=""/ATTB_3="" shape 보존.
    //  여기선 quantity=1 로 캡처 동등(ATTB="1") + 어댑터가 attb 슬롯을 부여하지 않음(undefined)을 단언.
    const p = mapProduct(productAIPPCUT as unknown as RedDigitalProductResponse);
    const sub = p.optionGroups.find((g) => g.id === 'PCS_SUB_MTR')!;
    expect(sub.values[0].attb).toBeUndefined(); // material-multi 아님 → '' 미적재(echo 경로 유지)
    const subEntry = serializeRedPriceRequest({
      ...priceReqWith('AIPPCUT', 'PCS_SUB_MTR', 1),
      priceSchemeKey: 'real_price',
      selectedFinishes: [{ groupId: 'PCS_SUB_MTR', valueId: sub.values[0].id }],
    }).dataJson.PCS_INFO.find((e) => e.PCS_COD === 'SUB_MTR')!;
    expect(subEntry.ATTB).toBe('1'); // 캡처 ATTB=1(quantity echo) — D-4 타입(int vs str)은 별건, 값 동등
    expect(subEntry.ATTB_2).toBe(''); // 캡처 ATTB_2="" 빈슬롯 보존
    expect(subEntry.ATTB_3).toBe(''); // 캡처 ATTB_3="" 빈슬롯 보존
  });

  it('비-자재연결 후가공(CUT_DFT 등)은 ATTB 빈 echo 유지(과잉 echo 0)', () => {
    const entry = serializeRedPriceRequest(priceReqWith('PRBKYPR', 'PCS_CUT_DFT', 30)).dataJson.PCS_INFO
      .find((e) => e.PCS_COD === 'CUT_DFT')!;
    expect(entry.ATTB).toBe(''); // 자재연결 아님 → 빈 echo
    expect('ATTB_2' in entry).toBe(false);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// PRICE=0 진단 (D-L3 재정의) — 0 은 정상 빈상태 아님, 결함 신호
// ─────────────────────────────────────────────────────────────────────────────
describe('PRICE=0 진단 — Red 는 0 을 정상 반환 안 함(우리측 결함 신호)', () => {
  function priceRes(price: number, retCode = 200): RedPriceResponse {
    return {
      retCode, result: [],
      result_sum: { PRICE: price, PRICE_VAT: 0, PRICE_MALL: price, PRICE_MALL_VAT: 0, ORG_PRICE: price, ORG_PRICE_VAT: 0 },
    } as RedPriceResponse;
  }

  it('PRICE=0 → ok:false + priceUnavailableReason 진단(침묵 정상 0 아님)', () => {
    const warn = vi.spyOn(console, 'warn').mockImplementation(() => {});
    const b = mapPriceResponse(priceRes(0));
    expect(b.ok).toBe(false);
    expect(b.finalPrice).toBe(0);
    expect(b.priceUnavailableReason).toBeDefined(); // 진단 사유 명시
    expect(b.priceUnavailableReason).toMatch(/Red.*0|결함|세션|필드/);
    expect(warn).toHaveBeenCalled(); // 비치명적 진단 경고
    warn.mockRestore();
  });

  it('PRICE>0 → ok:true, priceUnavailableReason 없음', () => {
    const b = mapPriceResponse(priceRes(3300));
    expect(b.ok).toBe(true);
    expect(b.priceUnavailableReason).toBeUndefined();
  });

  it('0 에 throw 하지 않음(미캡처 fixture 렌더 보존)', () => {
    const warn = vi.spyOn(console, 'warn').mockImplementation(() => {});
    expect(() => mapPriceResponse(priceRes(0))).not.toThrow();
    warn.mockRestore();
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// G-2 — 에디터 가격콜백 배선(EditorOverlay → bridge → store). 이전 no-op = stale-price 벡터.
//  prod-var-changed(MAJOR)=재계산 / page-count-changed(MINOR)=면수반영 / request-user-token=토큰갱신.
// ─────────────────────────────────────────────────────────────────────────────
function settle(): Promise<void> {
  return new Promise((r) => setTimeout(r, 0));
}
// EditorOverlay 의 콜백 배선을 그대로 재현(store 액션 연결) — bridge 에 주입할 콜백.
function overlayCallbacks(store: WidgetStore): EditorBridgeCallbacks {
  return {
    buildProdInfo: () => ({}),
    onProjectId: () => {},
    onResult: () => {},
    onClose: () => {},
    onProdVarChanged: () => store.getState().schedulePriceQuote(), // MAJOR: 재계산
    onPageCountChanged: (_s, n) => { if (n > 0) store.getState().setPageCount(n); },
    onRequestUserToken: (s) => void store.getState().refreshEditorToken(s),
  };
}
function makeBridge(store: WidgetStore): { send: (action: string, info: Record<string, unknown>) => void } {
  const config: NormalizedEditorConfig = {
    side: 'default', psCode: 'PS@PRBKYPR', templateUrl: 'gcs://x', resourceId: 0, token: 'T', pluginCustomData: {},
  };
  const ORIGIN = 'https://edicusbase.firebaseapp.com';
  let listener: ((e: MessageEvent) => void) | null = null;
  const target: MessageTarget = {
    addEventListener: (_t, l) => { listener = l; },
    removeEventListener: () => { listener = null; },
  };
  const bridge = new EditorBridge(config, overlayCallbacks(store), { allowedOrigins: [ORIGIN], messageTarget: target });
  bridge.attach({ contentWindow: null } as unknown as HTMLIFrameElement);
  return {
    send: (action, info) =>
      listener?.({ origin: ORIGIN, source: null, data: JSON.stringify({ type: 'from-edicus', action, info }) } as MessageEvent),
  };
}

describe('G-2 에디터 가격콜백 배선 — stale-price 벡터 해소', () => {
  it('prod-var-changed(MAJOR) → 재계산 트리거(store price 재호출, 콜백 no-op 아님)', async () => {
    let priceCalls = 0;
    const store = createWidgetStore({ bff: new StubBffClient(), productCode: 'PRBKYPR', debounceMs: 0, onPriceChange: () => { priceCalls++; } });
    await settle(); await settle();
    const before = priceCalls;
    makeBridge(store).send('prod-var-changed', { foo: 'bar' });
    await settle();
    expect(priceCalls).toBeGreaterThan(before); // 변수변경 → 재계산(이전엔 no-op)
  });

  it('page-count-changed → setPageCount 반영(면수 라이브 갱신)', async () => {
    const store = createWidgetStore({ bff: new StubBffClient(), productCode: 'PRBKYPR', debounceMs: 0 });
    await settle(); await settle();
    makeBridge(store).send('page-count-changed', { totalPageCount: 40 });
    await settle();
    // 책자 pageMin/pageMax clamp 내라면 40 반영(범위 밖이면 clamp). 0 아님 = 콜백 발화 확인.
    expect(store.getState().pageCount).toBeGreaterThan(0);
  });

  it('request-user-token → editorConfig 재발급(토큰 갱신)', async () => {
    let editorConfigCalls = 0;
    const base = new StubBffClient();
    const bff = {
      getProduct: (c: string) => base.getProduct(c),
      price: (r: NormalizedPriceRequest) => base.price(r),
      presigned: (r: Parameters<typeof base.presigned>[0]) => base.presigned(r),
      fileMeta: (n: string) => base.fileMeta(n),
      editorConfig: (c: string, s: Parameters<typeof base.editorConfig>[1]) => { editorConfigCalls++; return base.editorConfig(c, s); },
      isReadyToOrder: (p: Parameters<typeof base.isReadyToOrder>[0]) => base.isReadyToOrder(p),
      cartHandoff: (p: Parameters<typeof base.cartHandoff>[0]) => base.cartHandoff(p),
    };
    const store = createWidgetStore({ bff, productCode: 'PRBKYPR', debounceMs: 0 });
    await settle(); await settle();
    // 에디터 열기(editorConfig 1차 발급) → 토큰 갱신 요청 → 재발급(2차).
    await store.getState().openEditor('default');
    const afterOpen = editorConfigCalls;
    makeBridge(store).send('request-user-token', {});
    await settle();
    expect(editorConfigCalls).toBeGreaterThan(afterOpen); // 토큰 갱신 = config 재발급(이전엔 no-op)
  });
});
