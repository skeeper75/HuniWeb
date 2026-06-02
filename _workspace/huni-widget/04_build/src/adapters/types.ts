// data-adapter.md §1 — 어댑터 인터페이스 (Red/후니 어댑터가 구현하는 동일 시그니처).
// 어댑터는 유일한 신뢰 경계. 외부 raw 데이터는 여기서만 정규화 타입으로 변환된다.
import type {
  NormalizedProduct,
  NormalizedPriceRequest,
  NormalizedPriceBreakdown,
  NormalizedPresignedRequest,
  NormalizedPresigned,
  NormalizedUploadResult,
  NormalizedEditorConfig,
  NormalizedCartHandoff,
  SideKey,
} from '@/contract';

export interface ProductAdapter {
  getProduct(code: string): Promise<NormalizedProduct>;
}

export interface PriceAdapter {
  quote(req: NormalizedPriceRequest): Promise<NormalizedPriceBreakdown>;
}

export interface UploadAdapter {
  issuePresigned(req: NormalizedPresignedRequest): Promise<NormalizedPresigned>;
  getFileMeta(
    storedFileName: string,
  ): Promise<Pick<NormalizedUploadResult, 'pageCount' | 'sizeBytes'>>;
}

export interface EditorAdapter {
  getConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig>;
}

export interface CartAdapter {
  // [UNDECIDED] 내부에서 커머스 플랫폼 호출. 위젯·계약과 무관.
  handoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }>;
}

export interface DataAdapter {
  product: ProductAdapter;
  price: PriceAdapter;
  upload: UploadAdapter;
  editor: EditorAdapter;
  cart: CartAdapter;
}
