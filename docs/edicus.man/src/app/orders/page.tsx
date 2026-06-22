import type { Metadata } from 'next';
import Link from 'next/link';
import { OrderStatusBadge } from '@/components/orders/OrderStatusBadge';
import type { Order, OrderStatus } from '@/types/order';

export const metadata: Metadata = {
  title: '주문 내역',
};

// @MX:ANCHOR: [AUTO] 주문 목록 서버 데이터 페치 함수 (RSC 전용)
// @MX:REASON: OrdersPage의 단일 서버 데이터 접근 경계. 캐시 정책 변경 시 여기서만 수정
async function fetchOrders(): Promise<Order[]> {
  const baseUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'http://localhost:3000';
  const response = await fetch(`${baseUrl}/api/edicus/orders`, {
    next: { revalidate: 0 }, // 주문 내역은 항상 최신 데이터
  });
  if (!response.ok) return [];
  const data = (await response.json()) as { orders?: Order[] };
  return data.orders ?? [];
}

/** 주문 상태별 한국어 레이블 */
const STATUS_LABEL: Record<OrderStatus, string> = {
  tentative: '잠정주문',
  definitive: '확정주문',
  cancelled: '취소됨',
  processing: '처리 중',
  completed: '완료',
};

/** 날짜 포맷 */
function formatDate(iso: string): string {
  return new Date(iso).toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  });
}

/**
 * 주문 내역 페이지
 *
 * 사용자의 전체 주문 목록과 상태를 표시합니다.
 * 잠정주문 상태의 주문은 확정 또는 취소 액션을 제공합니다.
 */
export default async function OrdersPage() {
  const orders = await fetchOrders();

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      {/* 페이지 헤더 */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900">주문 내역</h1>
        <p className="mt-1 text-sm text-gray-500">
          인쇄 주문 현황과 진행 상태를 확인합니다.
        </p>
      </div>

      {/* 주문 목록 */}
      {orders.length === 0 ? (
        <EmptyState />
      ) : (
        <div className="space-y-4">
          {orders.map((order) => (
            <OrderCard key={order.order_id} order={order} />
          ))}
        </div>
      )}
    </div>
  );
}

/** 주문 카드 컴포넌트 */
function OrderCard({ order }: { order: Order }) {
  const isTentative = order.status === 'tentative';

  return (
    <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
        {/* 주문 정보 */}
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-3">
            <OrderStatusBadge status={order.status} />
            <span className="text-sm font-medium text-gray-700">
              {STATUS_LABEL[order.status]}
            </span>
          </div>
          <dl className="mt-3 grid grid-cols-1 gap-x-4 gap-y-2 text-sm sm:grid-cols-2">
            <div>
              <dt className="text-gray-500">주문 ID</dt>
              <dd className="font-mono text-xs text-gray-900 truncate">{order.order_id}</dd>
            </div>
            <div>
              <dt className="text-gray-500">프로젝트 ID</dt>
              <dd className="font-mono text-xs text-gray-900 truncate">{order.project_id}</dd>
            </div>
            <div>
              <dt className="text-gray-500">주문일시</dt>
              <dd className="text-gray-900">{formatDate(order.created_at)}</dd>
            </div>
            <div>
              <dt className="text-gray-500">업데이트</dt>
              <dd className="text-gray-900">{formatDate(order.updated_at)}</dd>
            </div>
          </dl>
        </div>

        {/* 액션 영역 */}
        {isTentative && (
          <div className="flex flex-shrink-0 flex-col gap-2 sm:items-end">
            <OrderActions
              orderId={order.order_id}
              projectId={order.project_id}
            />
          </div>
        )}
      </div>

      {/* 처리 중 진행 상태 표시 */}
      {order.status === 'processing' && (
        <div className="mt-4 rounded-lg bg-huni-primary-light-3 px-4 py-3">
          <div className="flex items-center gap-2">
            <svg className="h-4 w-4 animate-spin text-huni-primary" fill="none" viewBox="0 0 24 24" aria-hidden="true">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
            </svg>
            <p className="text-sm text-huni-primary-dark">인쇄 파일을 렌더링하고 있습니다. 잠시 후 완료됩니다.</p>
          </div>
        </div>
      )}

      {/* 완료 상태 표시 */}
      {order.status === 'completed' && (
        <div className="mt-4 rounded-lg bg-green-50 px-4 py-3">
          <p className="text-sm text-green-700">주문이 완료되었습니다. 인쇄 준비가 완료된 상태입니다.</p>
        </div>
      )}
    </div>
  );
}

/**
 * 잠정주문 액션 버튼
 *
 * 확정주문과 취소 액션을 제공합니다.
 * 서버 컴포넌트에서 링크로 처리하며, 실제 액션은 해당 페이지에서 처리합니다.
 */
function OrderActions({ orderId, projectId }: { orderId: string; projectId: string }) {
  return (
    <>
      <Link
        href={`/orders/${orderId}/confirm?projectId=${projectId}`}
        className="rounded-lg bg-huni-primary px-4 py-2 text-sm font-semibold text-white hover:bg-huni-primary-dark"
      >
        확정주문
      </Link>
      <Link
        href={`/orders/${orderId}/cancel`}
        className="rounded-lg border border-red-300 px-4 py-2 text-sm font-semibold text-red-600 hover:bg-red-50"
      >
        주문 취소
      </Link>
    </>
  );
}

/** 주문 없음 빈 상태 */
function EmptyState() {
  return (
    <div className="rounded-xl border border-dashed border-gray-300 bg-white py-16 text-center">
      <svg
        className="mx-auto h-12 w-12 text-gray-300"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        aria-hidden="true"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth={1.5}
          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
        />
      </svg>
      <h2 className="mt-4 text-base font-semibold text-gray-900">주문 내역이 없습니다</h2>
      <p className="mt-2 text-sm text-gray-500">
        프로젝트를 완성한 후 주문을 진행해 보세요.
      </p>
      <Link
        href="/projects"
        className="mt-6 inline-block rounded-lg bg-huni-primary px-5 py-2.5 text-sm font-semibold text-white hover:bg-huni-primary-dark"
      >
        내 프로젝트 보기
      </Link>
    </div>
  );
}
