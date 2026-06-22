'use client';

// @MX:NOTE: 관리자 사이드바 네비게이션, 반응형 레이아웃 (desktop: 256px fixed, mobile: hamburger overlay)

import { useState } from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import {
  LayoutDashboard,
  FileText,
  Package,
  ShoppingCart,
  Store,
  CreditCard,
  Truck,
  BarChart3,
  TrendingUp,
  ImageIcon,
  MessageSquare,
  Settings,
  User,
  LogOut,
  Menu,
  X,
} from 'lucide-react';

/** 네비게이션 메뉴 아이템 정의 */
const NAV_ITEMS = [
  { href: '/admin', label: '대시보드', icon: LayoutDashboard },
  { href: '/admin/templates', label: '템플릿', icon: FileText },
  { href: '/admin/products', label: '상품', icon: Package },
  { href: '/admin/orders', label: '주문', icon: ShoppingCart },
  { href: '/admin/shop', label: '상점', icon: Store },
  { href: '/admin/billing', label: '결제/정산', icon: CreditCard },
  { href: '/admin/shipping', label: '배송', icon: Truck },
  { href: '/admin/stats', label: '통계', icon: BarChart3 },
  { href: '/admin/insights', label: '인사이트', icon: TrendingUp },
  { href: '/admin/assets', label: '에셋', icon: ImageIcon },
  { href: '/admin/sms', label: 'SMS', icon: MessageSquare },
  { href: '/admin/settings', label: '설정', icon: Settings },
  { href: '/admin/profile', label: '프로필', icon: User },
] as const;

interface SidebarProps {
  userName?: string;
  userEmail?: string;
  onLogout?: () => void;
}

export default function Sidebar({ userName = '관리자', userEmail, onLogout }: SidebarProps) {
  const pathname = usePathname();
  const router = useRouter();
  const [mobileOpen, setMobileOpen] = useState(false);

  /** 현재 경로와 일치하는지 확인 (대시보드는 정확히 일치, 나머지는 prefix 매칭) */
  const isActive = (href: string): boolean => {
    if (href === '/admin') return pathname === '/admin';
    return pathname.startsWith(href);
  };

  const handleLogout = async () => {
    // 세션 쿠키 삭제
    document.cookie = '__session=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT';
    if (onLogout) {
      await onLogout();
    }
    router.push('/login');
    setMobileOpen(false);
  };

  const SidebarContent = () => (
    <div className="flex h-full flex-col">
      {/* 로고/타이틀 */}
      <div className="flex h-16 shrink-0 items-center px-6 border-b border-gray-200">
        <Link
          href="/admin"
          className="flex items-center gap-2 font-bold text-huni-primary hover:text-huni-primary-dark"
          onClick={() => setMobileOpen(false)}
        >
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-huni-primary">
            <svg
              className="h-5 w-5 text-white"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
              />
            </svg>
          </div>
          <span className="text-sm">Edicus Manager</span>
        </Link>
      </div>

      {/* 네비게이션 메뉴 */}
      <nav className="flex-1 overflow-y-auto px-3 py-4" aria-label="관리자 메뉴">
        <ul className="space-y-1">
          {NAV_ITEMS.map(({ href, label, icon: Icon }) => (
            <li key={href}>
              <Link
                href={href}
                onClick={() => setMobileOpen(false)}
                className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
                  isActive(href)
                    ? 'bg-huni-primary-light-3 text-huni-primary-dark'
                    : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'
                }`}
                aria-current={isActive(href) ? 'page' : undefined}
              >
                <Icon
                  className={`h-4 w-4 shrink-0 ${
                    isActive(href) ? 'text-huni-primary' : 'text-gray-400'
                  }`}
                  aria-hidden="true"
                />
                {label}
              </Link>
            </li>
          ))}
        </ul>
      </nav>

      {/* 사용자 정보 및 로그아웃 */}
      <div className="shrink-0 border-t border-gray-200 p-4">
        <div className="mb-3 px-1">
          <p className="text-sm font-medium text-gray-900 truncate">{userName}</p>
          {userEmail && (
            <p className="text-xs text-gray-500 truncate">{userEmail}</p>
          )}
        </div>
        <button
          onClick={handleLogout}
          className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-gray-700 hover:bg-red-50 hover:text-red-700 transition-colors"
        >
          <LogOut className="h-4 w-4 shrink-0 text-gray-400" aria-hidden="true" />
          로그아웃
        </button>
      </div>
    </div>
  );

  return (
    <>
      {/* 모바일 햄버거 버튼 */}
      <button
        type="button"
        onClick={() => setMobileOpen(true)}
        className="fixed top-4 left-4 z-40 flex md:hidden items-center justify-center rounded-lg bg-white p-2 text-gray-700 shadow-md border border-gray-200 hover:bg-gray-50"
        aria-label="메뉴 열기"
      >
        <Menu className="h-5 w-5" aria-hidden="true" />
      </button>

      {/* 모바일 오버레이 백드롭 */}
      {mobileOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 md:hidden"
          onClick={() => setMobileOpen(false)}
          aria-hidden="true"
        />
      )}

      {/* 모바일 사이드바 */}
      <aside
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-white shadow-xl transition-transform duration-300 ease-in-out md:hidden ${
          mobileOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
        aria-label="모바일 관리자 사이드바"
      >
        {/* 닫기 버튼 */}
        <button
          type="button"
          onClick={() => setMobileOpen(false)}
          className="absolute right-3 top-3 flex h-8 w-8 items-center justify-center rounded-lg text-gray-400 hover:bg-gray-100 hover:text-gray-600"
          aria-label="메뉴 닫기"
        >
          <X className="h-4 w-4" aria-hidden="true" />
        </button>
        <SidebarContent />
      </aside>

      {/* 데스크탑 사이드바 */}
      <aside
        className="hidden md:flex md:w-64 md:flex-col md:fixed md:inset-y-0 bg-white border-r border-gray-200"
        aria-label="관리자 사이드바"
      >
        <SidebarContent />
      </aside>
    </>
  );
}
