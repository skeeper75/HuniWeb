import type { Metadata } from 'next';
import Sidebar from '@/components/admin/Sidebar';

export const metadata: Metadata = {
  title: {
    default: '관리자 | Edicus Manager',
    template: '%s | Edicus Manager',
  },
  description: 'Edicus Manager 관리자 페이지',
};

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* 사이드바 */}
      <Sidebar />

      {/* 메인 콘텐츠 영역 (데스크탑에서 사이드바 너비만큼 왼쪽 여백) */}
      <div className="md:pl-64">
        {/* 모바일 상단 여백 (햄버거 버튼 공간) */}
        <div className="md:hidden h-14" />

        {/* 페이지 콘텐츠 */}
        <main className="min-h-screen">
          {children}
        </main>
      </div>
    </div>
  );
}
