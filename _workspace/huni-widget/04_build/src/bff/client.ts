// BFF 클라이언트 인터페이스 (api-contract.md §1). 위젯은 이 6 엔드포인트만 안다.
// [HARD] 위젯은 BFF 정규화 계약만 본다. 데이터소스/커머스 매핑은 BFF 내부(어댑터).
import type {
  NormalizedProduct,
  NormalizedPriceRequest,
  NormalizedPriceBreakdown,
  NormalizedPresignedRequest,
  NormalizedPresigned,
  NormalizedEditorConfig,
  NormalizedCartHandoff,
  NormalizedOrderReadiness,
  SideKey,
} from '@/contract';

export interface BffClient {
  getProduct(code: string): Promise<NormalizedProduct>; // GET /product/{code}
  price(req: NormalizedPriceRequest): Promise<NormalizedPriceBreakdown>; // POST /price
  presigned(req: NormalizedPresignedRequest): Promise<NormalizedPresigned>; // POST /presigned
  fileMeta(storedFileName: string): Promise<{ pageCount?: number; sizeBytes?: number }>; // POST /file-meta
  editorConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig>; // POST /editor-config
  // L-D3-1: 서버 주문가능 판정(isReadyToOrder). goto-cart 핸드오프 전 게이트.
  isReadyToOrder(payload: NormalizedCartHandoff): Promise<NormalizedOrderReadiness>; // POST /order-readiness
  cartHandoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }>; // POST /cart-handoff
}
