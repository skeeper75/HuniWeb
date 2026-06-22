import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright 설정 파일
 * 레드프린팅 모바일 편집기 SDK 런타임 분석을 위한 E2E 테스트 설정
 */
export default defineConfig({
  // 테스트 파일 위치
  testDir: './tests/e2e',

  // 전역 타임아웃 설정 (60초)
  timeout: 60 * 1000,

  // 각 테스트의 기대값 타임아웃
  expect: {
    timeout: 10 * 1000,
  },

  // 전체 테스트 실패 시 중단 여부 (CI 환경에서 유용)
  fullyParallel: false,

  // CI 환경에서 재시도 횟수
  retries: process.env.CI ? 2 : 0,

  // 병렬 워커 수 제한 (모바일 환경 분석이므로 순차 실행)
  workers: 1,

  // 리포터 설정
  reporter: [
    ['html', { outputFolder: 'tests/e2e/results/report', open: 'never' }],
    ['list'],
  ],

  // 출력 디렉토리 (스크린샷, 비디오 등)
  outputDir: 'tests/e2e/results/artifacts',

  // 공통 설정 (모든 프로젝트에 적용)
  use: {
    // 기본 URL 설정
    baseURL: 'https://m.redprinting.co.kr',

    // 실패 시 스크린샷 캡처
    screenshot: 'only-on-failure',

    // 트레이스 설정 (디버깅용)
    trace: 'on-first-retry',

    // 비디오 녹화 (실패 시)
    video: 'on-first-retry',

    // HTTP 헤더
    extraHTTPHeaders: {
      'Accept-Language': 'ko-KR,ko;q=0.9',
    },
  },

  // 프로젝트 정의
  projects: [
    {
      // 모바일 크롬 프로젝트 (iPhone 14 뷰포트)
      name: 'mobile-chrome',
      use: {
        ...devices['iPhone 14'],
        // 실제 모바일 크롬 브라우저 에뮬레이션
        browserName: 'chromium',
        // iPhone 14 뷰포트 (393x852)
        viewport: { width: 393, height: 852 },
        // 모바일 User-Agent
        userAgent:
          'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/116.0.5845.103 Mobile/15E148 Safari/604.1',
        // 기기 픽셀 비율
        deviceScaleFactor: 3,
        // 터치 지원
        hasTouch: true,
        // 모바일 에뮬레이션
        isMobile: true,
      },
    },
  ],
});
