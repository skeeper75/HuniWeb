// 주문 관련 타입 정의
// 주문 프로세스: 잠정주문 → 확정주문 → (선택) 취소

// 주문 상태
// - tentative: 잠정주문 (취소 가능, 편집 불가)
// - definitive: 확정주문 (취소 불가, 인쇄파일 렌더링 시작)
// - cancelled: 취소됨
// - processing: 처리 중 (렌더링/인쇄 진행)
// - completed: 완료
export type OrderStatus =
  | 'tentative'
  | 'definitive'
  | 'cancelled'
  | 'processing'
  | 'completed';

// 주문 모델
export interface Order {
  order_id: string;
  project_id: string;
  status: OrderStatus;
  created_at: string;         // ISO 8601
  updated_at: string;
}

// 잠정주문 요청 바디 (POST /api/projects/:id/order/tentative)
export interface TentativeOrderRequest {
  project_id: string;
}

// 확정주문 요청 바디 (POST /api/projects/:id/order/definitive)
export interface DefinitiveOrderRequest {
  project_id: string;
}

// 주문 취소 요청 바디 (POST /api/orders/:id/cancel)
export interface CancelOrderRequest {
  order_id: string;
}

// 주문 API 응답 (잠정/확정 공통)
export interface OrderResponse {
  order_id: string;
  project_id: string;
  status: OrderStatus;
}
