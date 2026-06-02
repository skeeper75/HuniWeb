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
  SideKey,
} from '@/contract';

export interface BffClient {
  getProduct(code: string): Promise<NormalizedProduct>; // GET /product/{code}
  price(req: NormalizedPriceRequest): Promise<NormalizedPriceBreakdown>; // POST /price
  presigned(req: NormalizedPresignedRequest): Promise<NormalizedPresigned>; // POST /presigned
  fileMeta(storedFileName: string): Promise<{ pageCount?: number; sizeBytes?: number }>; // POST /file-meta
  editorConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig>; // POST /editor-config
  cartHandoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }>; // POST /cart-handoff
}
