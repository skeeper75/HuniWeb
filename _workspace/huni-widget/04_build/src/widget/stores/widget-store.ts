// state-management.md — 단일 Zustand store + slice. [HARD] 인스턴스 스코프 팩토리(전역 싱글톤 금지).
import { createStore, type StoreApi } from 'zustand/vanilla';
import type {
  NormalizedProduct,
  NormalizedPriceBreakdown,
  NormalizedArtifact,
  NormalizedCartHandoff,
  NormalizedPriceRequest,
  SideKey,
  OptionGroup,
} from '@/contract';
import type { BffClient } from '@/bff/client';
import { applyCascade } from './cascade';
import { buildPriceRequest, hashRequest } from './price';

export type WidgetStatus =
  | 'idle'
  | 'loading'
  | 'ready'
  | 'pricing'
  | 'designing'
  | 'submitting'
  | 'error';

export type SelectionValue = string | string[];

export interface WidgetState {
  // config
  locale: string;
  deviceType: 'pc' | 'mobile';
  member: { tier?: string };
  // product (정규화, 로드 후 불변 — disabled 런타임 토글 제외)
  product: NormalizedProduct | null;
  // order — 사용자 선택 상태
  selections: Record<string, SelectionValue>;
  quantity: number;
  pageCount?: number;
  // exterior — 면별 입력 결과
  artifacts: Partial<Record<SideKey, NormalizedArtifact>>;
  // price — 서버 권위 결과 (위젯은 저장만)
  price: NormalizedPriceBreakdown | null;
  priceCache: Map<string, { value: NormalizedPriceBreakdown; ts: number }>;
  // ui
  status: WidgetStatus;
  editorSide: SideKey | null;
  errors: string[];

  // actions
  loadProduct(code: string): Promise<void>;
  selectOption(groupId: string, valueId: SelectionValue): void;
  setQuantity(n: number): void;
  setPageCount(n: number): void;
  setArtifact(side: SideKey, a: NormalizedArtifact): void;
  schedulePriceQuote(): void;
  cartHandoff(): NormalizedCartHandoff;
}

export interface WidgetStoreDeps {
  bff: BffClient;
  productCode: string;
  locale?: string;
  deviceType?: 'pc' | 'mobile';
  memberTier?: string;
  onPriceChange?: (b: NormalizedPriceBreakdown) => void;
  // price-engine.md §3 파라미터 (테스트에서 0 으로 즉시 실행 가능)
  debounceMs?: number;
  cacheTtlMs?: number;
}

export type WidgetStore = StoreApi<WidgetState>;

const DEFAULT_DEBOUNCE = 300; // price-engine §3
const DEFAULT_TTL = 30_000; // 30s

// 기본 선택값 세팅: 각 visible·required 그룹의 첫 값(또는 default size). hidden essential 은 첫 값 자동.
function defaultSelections(product: NormalizedProduct): Record<string, SelectionValue> {
  const sel: Record<string, SelectionValue> = {};
  for (const g of product.optionGroups) {
    if (g.inputSpec) continue; // 입력형은 별도 수량/페이지 상태
    const first = g.values.find((v) => !v.disabled);
    if (first) sel[g.id] = first.id;
  }
  return sel;
}

export function createWidgetStore(deps: WidgetStoreDeps): WidgetStore {
  const debounceMs = deps.debounceMs ?? DEFAULT_DEBOUNCE;
  const ttlMs = deps.cacheTtlMs ?? DEFAULT_TTL;
  let debounceTimer: ReturnType<typeof setTimeout> | null = null;

  const store = createStore<WidgetState>((set, get) => ({
    locale: deps.locale ?? 'ko',
    deviceType: deps.deviceType ?? 'pc',
    member: { tier: deps.memberTier },
    product: null,
    selections: {},
    quantity: 0,
    pageCount: undefined,
    artifacts: {},
    price: null,
    priceCache: new Map(),
    status: 'idle',
    editorSide: null,
    errors: [],

    async loadProduct(code: string) {
      set({ status: 'loading' });
      try {
        const product = await deps.bff.getProduct(code);
        const q = product.constraints.quantity.default;
        const sides = product.sides;
        set({
          product,
          selections: defaultSelections(product),
          quantity: q?.default ?? 1,
          pageCount: sides.some((s) => s.key === 'inner') ? q?.pageMin : undefined,
          status: 'ready',
        });
        // 초기 자동 가격 (price-engine §6)
        get().schedulePriceQuote();
      } catch (e) {
        set({ status: 'error', errors: [`상품 로드 실패: ${String(e)}`] });
      }
    },

    selectOption(groupId, valueId) {
      const selections = { ...get().selections, [groupId]: valueId };
      set({ selections });
      // 캐스케이드(자재→disable→해제→재계산 순서 보존) — state-management §4
      const product = get().product;
      if (product) {
        const next = applyCascade(product, selections, groupId);
        set({ product: next.product, selections: next.selections });
      }
      get().schedulePriceQuote();
    },

    setQuantity(n) {
      const q = get().product?.constraints.quantity.default;
      let v = n;
      if (q) {
        if (v < q.min) v = q.min;
        // FIR/STEP snap: first 부터 step 단위 (cascade-rules §2)
        const k = Math.max(0, Math.round((v - q.first) / q.step));
        v = q.first + k * q.step;
        if (v < q.min) v = q.min;
      }
      set({ quantity: v });
      get().schedulePriceQuote();
    },

    setPageCount(n) {
      const q = get().product?.constraints.quantity.default;
      let v = n;
      if (q?.pageMin != null && q?.pageMax != null) {
        v = Math.min(Math.max(v, q.pageMin), q.pageMax);
      }
      set({ pageCount: v });
      get().schedulePriceQuote();
    },

    setArtifact(side, a) {
      set({ artifacts: { ...get().artifacts, [side]: a } });
    },

    schedulePriceQuote() {
      const run = () => {
        const s = get();
        if (!s.product) return;
        const req: NormalizedPriceRequest = buildPriceRequest(s);
        const key = hashRequest(req);
        const cached = s.priceCache.get(key);
        if (cached && Date.now() - cached.ts < ttlMs) {
          set({ price: cached.value });
          deps.onPriceChange?.(cached.value);
          return;
        }
        set({ status: 'pricing' });
        deps.bff
          .price(req)
          .then((res) => {
            const cache = new Map(get().priceCache);
            cache.set(key, { value: res, ts: Date.now() });
            set({ price: res, priceCache: cache, status: 'ready' });
            deps.onPriceChange?.(res);
          })
          .catch((e) => set({ status: 'error', errors: [`가격 산정 실패: ${String(e)}`] }));
      };
      if (debounceMs <= 0) {
        run();
        return;
      }
      if (debounceTimer) clearTimeout(debounceTimer);
      debounceTimer = setTimeout(run, debounceMs);
    },

    cartHandoff() {
      const s = get();
      const product = s.product!;
      const selectedOptions = Object.entries(s.selections).flatMap(([groupId, v]) =>
        (Array.isArray(v) ? v : [v]).map((valueId) => ({ groupId, valueId })),
      );
      return {
        productCode: product.code,
        selectedOptions,
        quantity: s.quantity,
        pageCount: s.pageCount,
        priceSnapshot: {
          finalPrice: s.price?.finalPrice ?? 0,
          vat: s.price?.vat ?? 0,
          shipping: s.price?.shipping ?? 0,
        },
        artifacts: Object.values(s.artifacts).filter(Boolean) as NormalizedArtifact[],
      };
    },
  }));

  // 즉시 상품 로드
  void store.getState().loadProduct(deps.productCode);
  return store;
}

// canOrder 셀렉터 — state-management §5 (서버 왕복 없는 클라이언트 판정)
export function selectCanOrder(s: WidgetState): { ok: boolean; reasons: string[] } {
  const r: string[] = [];
  const product = s.product;
  if (!product) return { ok: false, reasons: ['주문불가-로딩'] };
  product.optionGroups
    .filter((g: OptionGroup) => g.required && g.visible && !g.inputSpec)
    .forEach((g) => {
      if (!s.selections[g.id]) r.push('주문불가-옵션');
    });
  const q = product.constraints.quantity.default;
  if (q && s.quantity < q.min) r.push('주문불가-수량');
  product.sides.forEach((side) => {
    const a = s.artifacts[side.key];
    if (side.uploadType === 'editor' && !a?.projectId) r.push('주문불가-파일');
    if (side.uploadType === 'pdf' && !a?.storedFileName) r.push('주문불가-파일');
  });
  const names = Object.values(s.artifacts)
    .map((a) => a?.originalFileName)
    .filter(Boolean);
  if (new Set(names).size !== names.length) r.push('주문불가-파일명중복');
  if (!s.price?.ok || (s.price?.finalPrice ?? 0) <= 0) r.push('주문불가-가격');
  return { ok: r.length === 0, reasons: Array.from(new Set(r)) };
}
