'use client';

/**
 * useOrder 훅
 *
 * 주문 프로세스(잠정주문 → 확정주문 → 취소)를 관리합니다.
 * 내부 API 라우트(/api/edicus/orders)를 호출합니다.
 */

import { useCallback, useState } from 'react';
import type { Order, OrderResponse } from '@/types/order';

/** 주문 작업 로딩 상태 */
interface OrderLoadingState {
  tentative: boolean;
  definitive: boolean;
  cancel: boolean;
}

/** useOrder 반환 타입 */
export interface UseOrderReturn {
  /** 현재 주문 정보 */
  order: Order | null;
  /** 각 작업별 로딩 상태 */
  loading: OrderLoadingState;
  /** 오류 메시지 */
  error: string | null;
  /**
   * 잠정 주문을 생성합니다.
   * 프로젝트 상태: editing → ordering
   *
   * @param projectId - 주문할 프로젝트 ID
   */
  tentativeOrder: (projectId: string) => Promise<OrderResponse | null>;
  /**
   * 확정 주문을 생성합니다.
   * 프로젝트 상태: ordering → ordered (인쇄파일 렌더링 시작)
   *
   * @param projectId - 확정할 프로젝트 ID
   */
  definitiveOrder: (projectId: string) => Promise<OrderResponse | null>;
  /**
   * 주문을 취소합니다.
   * 잠정주문(tentative) 상태에서만 가능합니다.
   *
   * @param orderId - 취소할 주문 ID
   */
  cancelOrder: (orderId: string) => Promise<OrderResponse | null>;
  /** 오류 상태를 초기화합니다. */
  clearError: () => void;
}

/**
 * 주문 프로세스 관리 훅
 *
 * @example
 * ```tsx
 * const { tentativeOrder, definitiveOrder, loading } = useOrder();
 *
 * const handleOrder = async () => {
 *   const result = await tentativeOrder(projectId);
 *   if (result) {
 *     // 잠정주문 성공 처리
 *   }
 * };
 * ```
 */
export function useOrder(): UseOrderReturn {
  const [order, setOrder] = useState<Order | null>(null);
  const [loading, setLoading] = useState<OrderLoadingState>({
    tentative: false,
    definitive: false,
    cancel: false,
  });
  const [error, setError] = useState<string | null>(null);

  /**
   * API 요청 공통 처리 함수
   */
  const fetchOrder = useCallback(
    async (
      url: string,
      body: Record<string, string>,
      loadingKey: keyof OrderLoadingState,
    ): Promise<OrderResponse | null> => {
      setLoading((prev) => ({ ...prev, [loadingKey]: true }));
      setError(null);

      try {
        const response = await fetch(url, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body),
        });

        if (!response.ok) {
          const errorData = (await response.json().catch(() => ({}))) as {
            error?: string;
          };
          throw new Error(errorData.error ?? `HTTP 오류: ${response.status}`);
        }

        const data = (await response.json()) as OrderResponse;

        // 주문 상태 업데이트
        setOrder((prev) => {
          if (!prev) {
            return {
              order_id: data.order_id,
              project_id: data.project_id,
              status: data.status,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            };
          }
          return { ...prev, status: data.status, updated_at: new Date().toISOString() };
        });

        return data;
      } catch (err: unknown) {
        const message = err instanceof Error ? err.message : '주문 처리 중 오류가 발생했습니다.';
        setError(message);
        return null;
      } finally {
        setLoading((prev) => ({ ...prev, [loadingKey]: false }));
      }
    },
    [],
  );

  // @MX:NOTE: 잠정주문 - POST /api/edicus/orders/tentative
  const tentativeOrder = useCallback(
    (projectId: string) =>
      fetchOrder(
        '/api/edicus/orders/tentative',
        { project_id: projectId },
        'tentative',
      ),
    [fetchOrder],
  );

  // @MX:NOTE: 확정주문 - POST /api/edicus/orders/definitive
  const definitiveOrder = useCallback(
    (projectId: string) =>
      fetchOrder(
        '/api/edicus/orders/definitive',
        { project_id: projectId },
        'definitive',
      ),
    [fetchOrder],
  );

  // @MX:NOTE: 주문취소 - POST /api/edicus/orders/cancel (잠정주문 상태에서만 가능)
  const cancelOrder = useCallback(
    (orderId: string) =>
      fetchOrder(
        '/api/edicus/orders/cancel',
        { order_id: orderId },
        'cancel',
      ),
    [fetchOrder],
  );

  const clearError = useCallback(() => setError(null), []);

  return {
    order,
    loading,
    error,
    tentativeOrder,
    definitiveOrder,
    cancelOrder,
    clearError,
  };
}
