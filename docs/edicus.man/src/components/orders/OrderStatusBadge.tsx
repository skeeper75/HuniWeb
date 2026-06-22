/**
 * OrderStatusBadge 컴포넌트
 *
 * 주문/프로젝트 상태를 색상 배지로 표시합니다.
 */

import type { ProjectStatus } from '@/types/edicus';
import type { OrderStatus } from '@/types/order';

type BadgeStatus = ProjectStatus | OrderStatus;

interface OrderStatusBadgeProps {
  status: BadgeStatus;
  className?: string;
}

/** 상태별 표시 설정 */
const STATUS_CONFIG: Record<
  BadgeStatus,
  { label: string; className: string }
> = {
  // 프로젝트 상태
  editing: {
    label: '편집 중',
    className: 'bg-huni-primary-light-2 text-huni-primary-dark',
  },
  ordering: {
    label: '주문 대기',
    className: 'bg-yellow-100 text-yellow-800',
  },
  ordered: {
    label: '주문 완료',
    className: 'bg-green-100 text-green-800',
  },
  // 주문 상태
  tentative: {
    label: '잠정 주문',
    className: 'bg-yellow-100 text-yellow-800',
  },
  definitive: {
    label: '확정 주문',
    className: 'bg-green-100 text-green-800',
  },
  cancelled: {
    label: '취소됨',
    className: 'bg-red-100 text-red-800',
  },
  processing: {
    label: '처리 중',
    className: 'bg-purple-100 text-purple-800',
  },
  completed: {
    label: '완료',
    className: 'bg-gray-100 text-gray-800',
  },
};

/**
 * 주문/프로젝트 상태 배지 컴포넌트
 *
 * @param status - 표시할 상태
 * @param className - 추가 Tailwind 클래스
 */
export function OrderStatusBadge({ status, className = '' }: OrderStatusBadgeProps) {
  const config = STATUS_CONFIG[status] ?? {
    label: status,
    className: 'bg-gray-100 text-gray-800',
  };

  return (
    <span
      className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${config.className} ${className}`}
      role="status"
      aria-label={`상태: ${config.label}`}
    >
      {config.label}
    </span>
  );
}
