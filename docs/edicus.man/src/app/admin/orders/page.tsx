'use client';

import { useState, useEffect } from 'react';
import { ShoppingCart, CheckCircle, XCircle } from 'lucide-react';

// @MX:NOTE: 주문 관리 페이지, /api/edicus/projects 엔드포인트에서 주문 정보를 가져옴
// ordering 상태의 주문에 대해 확정/취소 액션을 제공

/** 주문 상태 타입 */
type OrderStatus = 'editing' | 'ordering' | 'ordered' | 'processing' | 'completed' | 'all';

interface Order {
  id: string;
  projectName?: string;
  status: string;
  createdAt?: string;
  amount?: number;
}

/** 주문 상태 표시 배지 */
function StatusBadge({ status }: { status: string }) {
  const statusConfig: Record<string, { label: string; className: string }> = {
    editing: { label: '편집중', className: 'bg-gray-100 text-gray-600' },
    ordering: { label: '주문중', className: 'bg-yellow-100 text-yellow-700' },
    ordered: { label: '주문완료', className: 'bg-huni-primary-light-2 text-huni-primary-dark' },
    processing: { label: '처리중', className: 'bg-orange-100 text-orange-700' },
    completed: { label: '완료', className: 'bg-green-100 text-green-700' },
  };

  const config = statusConfig[status] ?? { label: status, className: 'bg-gray-100 text-gray-600' };

  return (
    <span
      className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${config.className}`}
    >
      {config.label}
    </span>
  );
}

const STATUS_TABS: { value: OrderStatus; label: string }[] = [
  { value: 'all', label: '전체' },
  { value: 'editing', label: '편집중' },
  { value: 'ordering', label: '주문중' },
  { value: 'ordered', label: '주문완료' },
  { value: 'processing', label: '처리중' },
  { value: 'completed', label: '완료' },
];

function OrderSkeleton() {
  return (
    <tr className="animate-pulse">
      {[...Array(6)].map((_, i) => (
        <td key={i} className="px-4 py-3">
          <div className="h-4 bg-gray-200 rounded w-full" />
        </td>
      ))}
    </tr>
  );
}

export default function OrdersPage() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<OrderStatus>('all');
  const [actionLoading, setActionLoading] = useState<string | null>(null);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/edicus/projects', { cache: 'no-store' });
      if (!response.ok) {
        throw new Error(`데이터를 불러오는데 실패했습니다. (${response.status})`);
      }
      const data: Order[] = await response.json();
      setOrders(Array.isArray(data) ? data : []);
    } catch (err) {
      setError(err instanceof Error ? err.message : '알 수 없는 오류가 발생했습니다.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void fetchOrders();
  }, []);

  const filteredOrders =
    activeTab === 'all' ? orders : orders.filter((o) => o.status === activeTab);

  /** 주문 확정 처리 */
  const handleConfirm = async (orderId: string) => {
    setActionLoading(orderId);
    try {
      const response = await fetch(`/api/edicus/orders`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ orderId, action: 'confirm' }),
      });
      if (!response.ok) throw new Error('주문 확정에 실패했습니다.');
      await fetchOrders();
    } catch (err) {
      alert(err instanceof Error ? err.message : '오류가 발생했습니다.');
    } finally {
      setActionLoading(null);
    }
  };

  /** 주문 취소 처리 */
  const handleCancel = async (orderId: string) => {
    if (!confirm('주문을 취소하시겠습니까?')) return;
    setActionLoading(orderId);
    try {
      const response = await fetch(`/api/edicus/orders`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ orderId, action: 'cancel' }),
      });
      if (!response.ok) throw new Error('주문 취소에 실패했습니다.');
      await fetchOrders();
    } catch (err) {
      alert(err instanceof Error ? err.message : '오류가 발생했습니다.');
    } finally {
      setActionLoading(null);
    }
  };

  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">주문 관리</h1>
        <p className="mt-1 text-sm text-gray-500">고객 주문을 조회하고 관리합니다.</p>
      </div>

      {/* 오류 메시지 */}
      {error && (
        <div
          role="alert"
          className="mb-5 rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700"
        >
          {error}
        </div>
      )}

      {/* 상태 필터 탭 */}
      <div className="mb-5 flex flex-wrap gap-1 border-b border-gray-200">
        {STATUS_TABS.map(({ value, label }) => {
          const count = value === 'all' ? orders.length : orders.filter((o) => o.status === value).length;
          return (
            <button
              key={value}
              onClick={() => setActiveTab(value)}
              className={`flex items-center gap-1.5 px-4 py-2.5 text-sm font-medium border-b-2 -mb-px transition-colors ${
                activeTab === value
                  ? 'border-huni-primary text-huni-primary'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              {label}
              {!loading && (
                <span
                  className={`inline-flex items-center justify-center rounded-full px-1.5 text-xs ${
                    activeTab === value
                      ? 'bg-huni-primary-light-2 text-huni-primary-dark'
                      : 'bg-gray-100 text-gray-500'
                  }`}
                >
                  {count}
                </span>
              )}
            </button>
          );
        })}
      </div>

      {/* 테이블 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-200 bg-gray-50">
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  주문 ID
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  프로젝트
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  상태
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  날짜
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  금액
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  액션
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {loading ? (
                <>
                  <OrderSkeleton />
                  <OrderSkeleton />
                  <OrderSkeleton />
                </>
              ) : filteredOrders.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-4 py-12 text-center">
                    <ShoppingCart
                      className="mx-auto h-10 w-10 text-gray-300 mb-3"
                      aria-hidden="true"
                    />
                    <p className="text-sm text-gray-400">주문이 없습니다.</p>
                  </td>
                </tr>
              ) : (
                filteredOrders.map((order) => (
                  <tr key={order.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-mono text-xs text-gray-500">{order.id}</td>
                    <td className="px-4 py-3 font-medium text-gray-900">
                      {order.projectName ?? '—'}
                    </td>
                    <td className="px-4 py-3">
                      <StatusBadge status={order.status} />
                    </td>
                    <td className="px-4 py-3 text-gray-500 text-xs">
                      {order.createdAt
                        ? new Date(order.createdAt).toLocaleDateString('ko-KR')
                        : '—'}
                    </td>
                    <td className="px-4 py-3 text-gray-900">
                      {order.amount != null
                        ? `${order.amount.toLocaleString('ko-KR')}원`
                        : '—'}
                    </td>
                    <td className="px-4 py-3">
                      {order.status === 'ordering' && (
                        <div className="flex items-center gap-2">
                          <button
                            onClick={() => void handleConfirm(order.id)}
                            disabled={actionLoading === order.id}
                            className="inline-flex items-center gap-1 rounded px-2.5 py-1 text-xs font-medium bg-green-50 text-green-700 hover:bg-green-100 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                            aria-label={`주문 ${order.id} 확정`}
                          >
                            <CheckCircle className="h-3.5 w-3.5" aria-hidden="true" />
                            확정
                          </button>
                          <button
                            onClick={() => void handleCancel(order.id)}
                            disabled={actionLoading === order.id}
                            className="inline-flex items-center gap-1 rounded px-2.5 py-1 text-xs font-medium bg-red-50 text-red-700 hover:bg-red-100 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                            aria-label={`주문 ${order.id} 취소`}
                          >
                            <XCircle className="h-3.5 w-3.5" aria-hidden="true" />
                            취소
                          </button>
                        </div>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {!loading && !error && (
        <p className="mt-3 text-xs text-gray-400">총 {filteredOrders.length}개 주문</p>
      )}
    </div>
  );
}
