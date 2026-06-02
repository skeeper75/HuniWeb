// state-management.md — 단일 Zustand store + slice. [HARD] 인스턴스 스코프 팩토리(전역 싱글톤 금지).
import { createStore, type StoreApi } from 'zustand/vanilla';
import type {
  NormalizedProduct,
  NormalizedPriceBreakdown,
  NormalizedArtifact,
  NormalizedCartHandoff,
  NormalizedPriceRequest,
  NormalizedEditorConfig,
  NormalizedEditorResult,
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
  editorConfig: NormalizedEditorConfig | null; // 열린 에디터 세션 config (오버레이 렌더용)
  uploadingSide: SideKey | null; // PDF 업로드 진행 중인 면
  errors: string[];

  // actions
  loadProduct(code: string): Promise<void>;
  selectOption(groupId: string, valueId: SelectionValue): void;
  setQuantity(n: number): void;
  setPageCount(n: number): void;
  setArtifact(side: SideKey, a: NormalizedArtifact): void;
  schedulePriceQuote(): void;
  cartHandoff(): NormalizedCartHandoff;
  // 에디터 (editor-integration §1·3)
  openEditor(side: SideKey): Promise<void>;
  applyEditorResult(r: NormalizedEditorResult): void;
  closeEditor(): void;
  // 업로드 (api-contract #3·4, s3-upload-flow): presigned → S3 직접 PUT → file-meta.
  uploadPdf(side: SideKey, file: File): Promise<void>;
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
  // S3 직접 PUT 수행자 — 기본은 fetch PUT(s3-upload-flow §2). 테스트는 stub 주입.
  // @MX:NOTE [O5] presigned 쿼리에 checksum 헤더 포함 가능 — 운영 SDK 실 PUT 헤더 미캡처.
  // Content-Type:application/pdf + UNSIGNED-PAYLOAD 조합은 라이브 검증됨. checksum 강제 시 빌드타임 보강.
  putToS3?: (uploadUrl: string, file: File) => Promise<void>;
}

async function defaultPutToS3(uploadUrl: string, file: File): Promise<void> {
  const res = await fetch(uploadUrl, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/pdf' },
    body: file,
  });
  if (!res.ok) throw new Error(`S3 업로드 실패: HTTP ${res.status}`);
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
    editorConfig: null,
    uploadingSide: null,
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

    async openEditor(side) {
      const code = get().product?.code;
      if (!code) return;
      set({ status: 'designing', editorSide: side });
      try {
        // BFF/어댑터가 토큰체인(makers /token,/editor,/template/hit)을 수행하고 최종 config 만 반환.
        // 위젯은 token 을 보관하지 않고 즉시 SDK(iframe URL)로 전달(보안 — editor-integration §1).
        const config = await deps.bff.editorConfig(code, side);
        set({ editorConfig: config });
      } catch (e) {
        set({ status: 'error', editorSide: null, errors: [`에디터 로드 실패: ${String(e)}`] });
      }
    },

    applyEditorResult(r) {
      // goto-cart 정규화 결과 → artifacts[side]=editor. 가격 재계산(페이지수 변동 가능).
      const artifact: NormalizedArtifact = {
        side: r.side,
        kind: 'editor',
        projectId: r.projectId,
        thumbnailUrls: r.thumbnailUrls,
        totalPageCount: r.totalPageCount,
      };
      set({
        artifacts: { ...get().artifacts, [r.side]: artifact },
        editorConfig: null,
        editorSide: null,
        status: 'ready',
      });
      get().schedulePriceQuote();
    },

    closeEditor() {
      set({ editorConfig: null, editorSide: null, status: 'ready' });
    },

    async uploadPdf(side, file) {
      const product = get().product;
      if (!product) return;
      // 파일 유효성(application/pdf) — s3-upload-flow §3 step 2.
      if (file.type !== 'application/pdf') {
        set({ errors: ['PDF 파일만 업로드할 수 있습니다.'] });
        return;
      }
      set({ uploadingSide: side });
      try {
        // ① presigned 발급(직전 1회, 60분 만료 — 미리 발급 금지).
        const presigned = await deps.bff.presigned({
          fileName: file.name,
          productCode: product.code,
          contentType: 'application/pdf',
          side,
        });
        // ② S3 직접 PUT(BFF 경유 안 함).
        await (deps.putToS3 ?? defaultPutToS3)(presigned.uploadUrl, file);
        // ③ file-meta 조회(페이지수/크기 — canOrder 입력).
        const meta = await deps.bff.fileMeta(presigned.storedFileName);
        const artifact: NormalizedArtifact = {
          side,
          kind: 'pdf',
          storedFileName: presigned.storedFileName,
          originalFileName: file.name,
          totalPageCount: meta.pageCount,
        };
        set({
          artifacts: { ...get().artifacts, [side]: artifact }, // == fileUploadInfo[side]
          uploadingSide: null,
        });
        get().schedulePriceQuote();
      } catch (e) {
        set({ uploadingSide: null, errors: [`업로드 실패: ${String(e)}`] });
      }
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
