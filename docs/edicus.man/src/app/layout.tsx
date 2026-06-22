import type { Metadata } from 'next';
import { Noto_Sans_KR } from 'next/font/google';
import Link from 'next/link';
import './globals.css';

// Noto Sans KR 폰트 설정
const notoSansKR = Noto_Sans_KR({
  subsets: ['latin'],
  weight: ['400', '500', '600'],
  variable: '--font-noto-sans',
  display: 'swap',
});

export const metadata: Metadata = {
  title: {
    default: '후니프린팅 - 웹 인쇄 서비스',
    template: '%s | 후니프린팅',
  },
  description: '후니프린팅 웹투프린트 서비스입니다. 나만의 디자인으로 인쇄물을 제작하세요.',
};

/** 네비게이션 메뉴 항목 */
const NAV_ITEMS = [
  { href: '/', label: '홈' },
  { href: '/projects', label: '내 프로젝트' },
  { href: '/orders', label: '주문 내역' },
] as const;

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <body className={`${notoSansKR.variable} min-h-screen bg-gray-50 antialiased`}>
        {/* 사이트 헤더 */}
        <header className="sticky top-0 z-50 border-b border-gray-200 bg-white shadow-sm">
          <div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-3 sm:px-6 lg:px-8">
            {/* 로고 */}
            <Link
              href="/"
              className="flex items-center gap-2 text-lg font-bold text-huni-primary hover:text-huni-primary-dark"
              aria-label="후니프린팅 홈으로 이동"
            >
              <svg
                className="h-7 w-7"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"
                />
              </svg>
              후니프린팅
            </Link>

            {/* 네비게이션 */}
            <nav aria-label="주요 메뉴">
              <ul className="flex items-center gap-1 sm:gap-2">
                {NAV_ITEMS.map(({ href, label }) => (
                  <li key={href}>
                    <Link
                      href={href}
                      className="rounded-lg px-3 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-100 hover:text-huni-primary"
                    >
                      {label}
                    </Link>
                  </li>
                ))}
              </ul>
            </nav>
          </div>
        </header>

        {/* 메인 콘텐츠 */}
        <main>{children}</main>

        {/* 푸터 */}
        <footer className="mt-auto border-t border-gray-200 bg-white">
          <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
            <div className="flex flex-col items-center justify-between gap-4 sm:flex-row">
              <p className="text-sm font-semibold text-gray-700">후니프린팅</p>
              <p className="text-xs text-gray-500">
                © {new Date().getFullYear()} 후니프린팅. All rights reserved.
              </p>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
