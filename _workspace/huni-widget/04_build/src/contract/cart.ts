// data-contract.md §6 — 장바구니 핸드오프 계약 (커머스 바인딩 UNDECIDED).
// [HARD 스코프] 위젯은 정규화 페이로드를 BFF로 넘기는 데서 끝난다. 커머스 플랫폼 무지(無知).
import type { SideKey } from './product';

export interface SelectedOption {
  groupId: string;
  valueId: string;
}

export interface NormalizedArtifact {
  side: SideKey;
  kind: 'editor' | 'pdf';
  // editor
  projectId?: string;
  thumbnailUrls?: string[];
  totalPageCount?: number;
  // pdf
  storedFileName?: string;
  originalFileName?: string;
}

export interface NormalizedCartHandoff {
  productCode: string;
  selectedOptions: SelectedOption[]; // 옵션 스냅샷 (id+label 불투명)
  quantity: number;
  pageCount?: number;
  priceSnapshot: { finalPrice: number; vat: number; shipping: number };
  artifacts: NormalizedArtifact[];
}

// L-D3-1: 서버 주문가능 판정(Red isReadyToOrder → can_order/doc_rev). 클라 canOrder(선택/가격/파일)
//  와 별개로 서버측 doc 검수·재고 등을 게이트. 위젯은 불투명 결과만 소비.
export interface NormalizedOrderReadiness {
  canOrder: boolean;
  reasons: string[]; // 불투명 사유 코드/문자열 (서버 권위)
}
