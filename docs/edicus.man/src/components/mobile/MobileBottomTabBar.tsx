'use client';

// 모바일 하단 탭 바 컴포넌트
// 4개 탭: 홈, 편집기, 프로젝트, 마이
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Home, PenTool, FolderOpen, User } from 'lucide-react';

// 탭 항목 정의
const TAB_ITEMS = [
  { href: '/mobile', icon: Home, label: '홈' },
  { href: '/editor', icon: PenTool, label: '편집기' },
  { href: '/projects', icon: FolderOpen, label: '프로젝트' },
  { href: '/admin/profile', icon: User, label: '마이' },
] as const;

export function MobileBottomTabBar() {
  const pathname = usePathname();

  return (
    // @MX:NOTE: 하단 탭 바는 safe-area-inset-bottom으로 노치 대응
    <nav
      className="fixed bottom-0 left-0 right-0 z-50 bg-white border-t border-gray-200"
      aria-label="하단 탭 내비게이션"
      style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}
    >
      <div className="flex items-center justify-around h-16">
        {TAB_ITEMS.map(({ href, icon: Icon, label }) => {
          // 현재 경로와 일치하는지 확인 (mobile은 정확히 일치, 나머지는 시작 일치)
          const isActive = href === '/mobile'
            ? pathname === href || pathname.startsWith('/mobile/')
            : pathname.startsWith(href);

          return (
            <Link
              key={href}
              href={href}
              className={[
                'flex flex-col items-center justify-center gap-1',
                'min-w-[44px] min-h-[44px] px-3 py-2 rounded-lg',
                'transition-colors',
                isActive
                  ? 'text-huni-primary'
                  : 'text-gray-400 active:text-gray-600',
              ].join(' ')}
              aria-current={isActive ? 'page' : undefined}
            >
              <Icon className="h-5 w-5" aria-hidden="true" />
              <span className="text-[10px] font-medium leading-none">{label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
