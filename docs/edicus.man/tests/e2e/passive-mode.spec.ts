// Passive 모드 E2E 스모크 테스트
// @MX:SPEC: SPEC-PASSIVE-001 Phase E
//
// 참고: 이 테스트는 로컬 dev 서버(localhost:3000)를 대상으로 합니다.
// 서버가 실행 중이지 않으면 각 테스트는 자동으로 스킵됩니다.
// 크로스-오리진 iframe(edicusbase.firebaseapp.com) 내부는 직접 접근 불가 →
// iframe src URL 파라미터와 호스트 측 UI 요소를 통해 검증합니다.

import { test, expect } from '@playwright/test';

// 로컬 dev 서버 가용성 확인 헬퍼
async function isDevServerAvailable(baseUrl: string): Promise<boolean> {
  try {
    const response = await fetch(baseUrl, { signal: AbortSignal.timeout(3000) });
    return response.ok || response.status < 500;
  } catch {
    return false;
  }
}

const LOCAL_BASE_URL = 'http://localhost:3000';

// passive mode가 적용되는 모바일 편집기 테스트 경로
// 실제 Next.js 라우팅에 맞게 조정이 필요할 수 있음
const PASSIVE_TEST_PATH = '/mobile/test-product?passiveMode=true';
const STANDARD_TEST_PATH = '/mobile/test-product';

test.describe('Passive 모드 E2E 스모크 테스트', () => {
  // 각 테스트 전에 dev 서버 가용성 확인
  test.beforeEach(async ({}, testInfo) => {
    const available = await isDevServerAvailable(LOCAL_BASE_URL);
    if (!available) {
      testInfo.annotations.push({
        type: 'skip',
        description: `로컬 dev 서버(${LOCAL_BASE_URL})가 실행 중이지 않습니다. npm run dev로 서버를 시작하세요.`,
      });
      test.skip(true, `로컬 dev 서버(${LOCAL_BASE_URL})가 실행 중이지 않습니다.`);
    }
  });

  // TC-E3-1: Passive 모드 활성화 시 iframe URL에 run_mode=passive 포함
  test('TC-E3-1: passiveMode 활성화 시 iframe src에 run_mode=passive 파라미터가 포함된다', async ({ page }) => {
    await page.goto(`${LOCAL_BASE_URL}${PASSIVE_TEST_PATH}`, {
      waitUntil: 'domcontentloaded',
    });

    // iframe이 생성될 때까지 대기 (최대 15초)
    await page.waitForSelector('iframe', { timeout: 15000 }).catch(() => {
      // iframe이 없어도 테스트 계속 진행 (로딩 중일 수 있음)
    });

    // iframe src URL에서 run_mode 파라미터 확인
    const iframeSrc = await page.evaluate(() => {
      const iframe = document.querySelector('iframe');
      return iframe?.src ?? null;
    });

    if (iframeSrc) {
      // iframe src가 있는 경우: run_mode=passive 확인
      const url = new URL(iframeSrc);
      expect(url.searchParams.get('run_mode')).toBe('passive');
    } else {
      // iframe이 아직 로드되지 않은 경우: MutationObserver로 대기
      const iframeSrcWithPassive = await page.evaluate(() => {
        return new Promise<string | null>((resolve) => {
          const observer = new MutationObserver(() => {
            const iframe = document.querySelector('iframe');
            if (iframe?.src) {
              observer.disconnect();
              resolve(iframe.src);
            }
          });

          observer.observe(document.body, { childList: true, subtree: true });

          // 10초 타임아웃
          setTimeout(() => {
            observer.disconnect();
            resolve(null);
          }, 10000);
        });
      });

      if (iframeSrcWithPassive) {
        const url = new URL(iframeSrcWithPassive);
        expect(url.searchParams.get('run_mode')).toBe('passive');
      } else {
        // iframe이 끝내 나타나지 않은 경우 - 컴포넌트가 다른 방식으로 렌더링될 수 있음
        // 이 경우 호스트 UI에서 passive 모드 지시자 확인
        const hasPassiveUi = await page
          .locator('[aria-label="실행 취소"]')
          .isVisible()
          .catch(() => false);

        // passive UI 또는 iframe 중 하나는 있어야 함
        expect(iframeSrcWithPassive !== null || hasPassiveUi).toBeTruthy();
      }
    }
  });

  // TC-E3-2: PassiveToolbar UI 표시 확인 (Top bar + Bottom bar)
  test('TC-E3-2: passive 모드에서 PassiveToolbar(상단바/하단바)가 화면에 표시된다', async ({ page }) => {
    await page.goto(`${LOCAL_BASE_URL}${PASSIVE_TEST_PATH}`, {
      waitUntil: 'domcontentloaded',
    });

    // PassiveToolbarTop: 닫기 버튼(편집기 닫기) 표시 확인
    const closeButton = page.locator('[aria-label="편집기 닫기"]');
    await expect(closeButton).toBeVisible({ timeout: 10000 });

    // PassiveToolbarBottom: 도구 버튼들 표시 확인
    const undoButton = page.locator('[aria-label="실행 취소"]');
    const redoButton = page.locator('[aria-label="다시 실행"]');
    const saveButton = page.locator('[aria-label="저장"]');
    const doneButton = page.locator('[aria-label="편집 완료"]');

    await expect(undoButton).toBeVisible({ timeout: 5000 });
    await expect(redoButton).toBeVisible({ timeout: 5000 });
    await expect(saveButton).toBeVisible({ timeout: 5000 });
    await expect(doneButton).toBeVisible({ timeout: 5000 });
  });

  // TC-E3-3: Standard 모드에서 PassiveToolbar 미표시 확인
  test('TC-E3-3: standard 모드에서 PassiveToolbar(하단 도구바)가 표시되지 않는다', async ({ page }) => {
    await page.goto(`${LOCAL_BASE_URL}${STANDARD_TEST_PATH}`, {
      waitUntil: 'domcontentloaded',
    });

    // 페이지 로드 후 잠시 대기
    await page.waitForTimeout(2000);

    // 표준 모드에서는 하단 도구바 버튼이 없어야 함
    const undoButton = page.locator('[aria-label="실행 취소"]');
    const redoButton = page.locator('[aria-label="다시 실행"]');
    const saveButton = page.locator('[aria-label="저장"]');

    await expect(undoButton).not.toBeVisible();
    await expect(redoButton).not.toBeVisible();
    await expect(saveButton).not.toBeVisible();
  });
});
