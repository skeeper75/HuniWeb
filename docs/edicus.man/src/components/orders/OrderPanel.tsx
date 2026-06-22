'use client';

/**
 * OrderPanel 컴포넌트
 *
 * 주문 패널을 표시합니다. 잠정주문 → 확정주문 워크플로우를 제공합니다.
 * useOrder 훅을 사용하여 주문 상태를 관리합니다.
 */

import { useOrder } from '@/hooks/useOrder';
import { OrderStatusBadge } from './OrderStatusBadge';
import type { ProjectStatus } from '@/types/edicus';

interface OrderPanelProps {
  /** 주문할 프로젝트 ID */
  projectId: string;
  /** 현재 프로젝트 상태 */
  projectStatus: ProjectStatus;
  /** 주문 완료 후 콜백 */
  onOrderComplete?: (orderId: string) => void;
  /** 패널 닫기 콜백 */
  onClose?: () => void;
}

/**
 * 주문 패널 컴포넌트
 *
 * 잠정주문과 확정주문 단계를 제공합니다.
 * - editing 상태: 잠정주문 버튼 표시
 * - ordering 상태: 확정주문 및 취소 버튼 표시
 * - ordered 상태: 주문 완료 메시지 표시
 *
 * @example
 * ```tsx
 * <OrderPanel
 *   projectId="proj_123"
 *   projectStatus="editing"
 *   onOrderComplete={(orderId) => router.push(`/orders/${orderId}`)}
 * />
 * ```
 */
export function OrderPanel({
  projectId,
  projectStatus,
  onOrderComplete,
  onClose,
}: OrderPanelProps) {
  const { order, loading, error, tentativeOrder, definitiveOrder, cancelOrder, clearError } =
    useOrder();

  /** 현재 표시할 상태 (order가 있으면 order status 기준) */
  const currentStatus = order?.status === 'tentative' ? 'ordering' : projectStatus;

  const handleTentativeOrder = async () => {
    const result = await tentativeOrder(projectId);
    if (result) {
      // 잠정주문 성공 - 상태 업데이트는 useOrder 내부에서 처리
    }
  };

  const handleDefinitiveOrder = async () => {
    const result = await definitiveOrder(projectId);
    if (result) {
      onOrderComplete?.(result.order_id);
    }
  };

  const handleCancelOrder = async () => {
    if (!order?.order_id) return;
    await cancelOrder(order.order_id);
  };

  return (
    <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
      {/* 헤더 */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-900">주문하기</h2>
        <div className="flex items-center gap-2">
          <OrderStatusBadge status={currentStatus} />
          {onClose && (
            <button
              onClick={onClose}
              className="rounded-lg p-1 text-gray-400 hover:bg-gray-100 hover:text-gray-600"
              aria-label="패널 닫기"
            >
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          )}
        </div>
      </div>

      {/* 오류 메시지 */}
      {error && (
        <div className="mt-4 flex items-start gap-2 rounded-lg bg-red-50 p-3 text-sm text-red-800">
          <svg className="mt-0.5 h-4 w-4 shrink-0" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
            <path
              fillRule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
              clipRule="evenodd"
            />
          </svg>
          <div className="flex-1">
            <p>{error}</p>
          </div>
          <button onClick={clearError} className="shrink-0 text-red-600 hover:text-red-800" aria-label="오류 닫기">
            <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      )}

      {/* 주문 단계별 UI */}
      <div className="mt-6">
        {/* editing 상태: 잠정주문 안내 */}
        {currentStatus === 'editing' && (
          <div>
            <p className="text-sm text-gray-600">
              디자인 편집이 완료되었으면 잠정 주문을 진행하세요.
              잠정 주문 후에도 취소가 가능합니다.
            </p>
            <button
              onClick={handleTentativeOrder}
              disabled={loading.tentative}
              className="mt-4 w-full rounded-lg bg-huni-primary px-4 py-3 text-sm font-semibold text-white transition-colors hover:bg-huni-primary-dark focus:outline-none focus:ring-2 focus:ring-huni-primary focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
            >
              {loading.tentative ? (
                <span className="flex items-center justify-center gap-2">
                  <svg className="h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24" aria-hidden="true">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  처리 중...
                </span>
              ) : (
                '잠정 주문하기'
              )}
            </button>
          </div>
        )}

        {/* ordering 상태: 확정주문 또는 취소 */}
        {currentStatus === 'ordering' && (
          <div>
            <div className="rounded-lg bg-yellow-50 p-4 text-sm text-yellow-800">
              <p className="font-medium">잠정 주문이 완료되었습니다.</p>
              <p className="mt-1">확정 주문 시 인쇄 파일 렌더링이 시작되며 취소가 불가능합니다.</p>
            </div>
            <div className="mt-4 flex gap-3">
              <button
                onClick={handleCancelOrder}
                disabled={loading.cancel}
                className="flex-1 rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm font-semibold text-gray-700 transition-colors hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              >
                {loading.cancel ? '취소 중...' : '주문 취소'}
              </button>
              <button
                onClick={handleDefinitiveOrder}
                disabled={loading.definitive}
                className="flex-1 rounded-lg bg-green-600 px-4 py-3 text-sm font-semibold text-white transition-colors hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              >
                {loading.definitive ? (
                  <span className="flex items-center justify-center gap-2">
                    <svg className="h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24" aria-hidden="true">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                    </svg>
                    처리 중...
                  </span>
                ) : (
                  '확정 주문하기'
                )}
              </button>
            </div>
          </div>
        )}

        {/* ordered 상태: 완료 */}
        {currentStatus === 'ordered' && (
          <div className="text-center">
            <div className="flex justify-center">
              <svg className="h-12 w-12 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <p className="mt-3 text-sm font-semibold text-gray-900">주문이 완료되었습니다!</p>
            <p className="mt-1 text-xs text-gray-500">인쇄 파일 렌더링이 시작되었습니다.</p>
          </div>
        )}
      </div>

      {/* 프로젝트 ID 표시 */}
      <div className="mt-4 border-t border-gray-100 pt-4">
        <p className="text-xs text-gray-400">프로젝트 ID: {projectId}</p>
      </div>
    </div>
  );
}
