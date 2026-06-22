// Next.js 미들웨어 - 라우트 보호
// __session 쿠키를 기반으로 인증 상태를 확인하고 접근을 제어합니다
// @MX:NOTE: Firebase 클라이언트 SDK는 미들웨어(Edge Runtime)에서 동작하지 않습니다
// 대신 클라이언트에서 ID 토큰을 __session 쿠키에 저장하여 미들웨어에서 확인합니다
import { NextRequest, NextResponse } from 'next/server';

// 보호된 라우트 패턴 정의
// /admin/* 및 /editor/* 라우트는 인증이 필요합니다
const PROTECTED_PATTERNS = [
  /^\/admin(\/.*)?$/,
  /^\/editor(\/.*)?$/,
];

// 인증된 사용자를 리디렉션할 라우트 (로그인 페이지 등)
const AUTH_ROUTES = ['/login', '/register'];

// __session 쿠키에서 인증 토큰 추출
function getSessionToken(request: NextRequest): string | undefined {
  return request.cookies.get('__session')?.value;
}

// @MX:NOTE: 미들웨어는 Edge Runtime에서 실행되므로 Node.js API 사용 불가
// Firebase Admin SDK 검증 대신 토큰 존재 여부로 간단히 인증 상태를 판단합니다
// 실제 토큰 유효성 검증은 API 라우트에서 수행합니다
export function middleware(request: NextRequest): NextResponse {
  const { pathname } = request.nextUrl;
  const sessionToken = getSessionToken(request);
  const isAuthenticated = Boolean(sessionToken);

  // 보호된 라우트 접근 시 미인증 사용자를 로그인 페이지로 리디렉션
  const isProtectedRoute = PROTECTED_PATTERNS.some((pattern) => pattern.test(pathname));
  if (isProtectedRoute && !isAuthenticated) {
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('redirect', pathname);
    return NextResponse.redirect(loginUrl);
  }

  // 인증 라우트 접근 시 이미 로그인된 사용자를 관리자 페이지로 리디렉션
  const isAuthRoute = AUTH_ROUTES.includes(pathname);
  if (isAuthRoute && isAuthenticated) {
    return NextResponse.redirect(new URL('/admin', request.url));
  }

  return NextResponse.next();
}

// 미들웨어 적용 경로 설정
// API 라우트, 정적 파일, Next.js 내부 경로는 제외
export const config = {
  matcher: [
    /*
     * 다음 경로를 제외한 모든 요청에 미들웨어 적용:
     * - api/ (API 라우트)
     * - _next/static (정적 파일)
     * - _next/image (이미지 최적화)
     * - favicon.ico, robots.txt 등 정적 파일
     */
    '/((?!api|_next/static|_next/image|favicon.ico|robots.txt).*)',
  ],
};
