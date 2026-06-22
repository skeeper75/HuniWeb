// 모바일 레이아웃
// 하단 탭 바 포함, 사이드바 없음
import type { Metadata } from 'next';
import { MobileBottomTabBar } from '@/components/mobile/MobileBottomTabBar';

export const metadata: Metadata = {
  title: '모바일 주문',
};

export default function MobileLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col min-h-screen bg-gray-50">
      {/* 메인 콘텐츠 영역: 하단 탭 바 높이만큼 패딩 */}
      <main className="flex-1 pb-16 safe-area-inset-bottom">
        {children}
      </main>

      {/* 하단 탭 바 */}
      <MobileBottomTabBar />
    </div>
  );
}
