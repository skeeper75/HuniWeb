import { test, expect, type Page, type BrowserContext } from '@playwright/test';

/**
 * 목적: 레드프린팅 사이트에서 Edicus SDK 런타임 동작을 캡처
 * 대상 URL: https://m.redprinting.co.kr/landing/mobile_editor
 * 인증 정보: lojesus75 / redp0416!@
 */

// 전역 타입 선언 - window 객체 확장
declare global {
  interface Window {
    __sdk_calls: Array<{
      method: string;
      args: unknown[];
      time: number;
    }>;
    __post_messages: Array<{
      time: number;
      data: unknown;
    }>;
    __received_messages: Array<{
      time: number;
      origin: string;
      data: unknown;
    }>;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    edicusSDK: any;
  }
}

/**
 * 로그인 헬퍼 함수
 * 레드프린팅 사이트에 로그인하고 성공 여부를 반환
 */
async function performLogin(page: Page): Promise<boolean> {
  try {
    await page.goto('/member/login', { waitUntil: 'domcontentloaded' });
    await page.waitForTimeout(2000);

    // 아이디 입력 필드 탐색 (여러 선택자 시도)
    const idSelectors = ['#mb_id', 'input[name="mb_id"]', 'input[type="text"]'];
    let idFilled = false;
    for (const selector of idSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible().catch(() => false)) {
        await el.fill('lojesus75');
        idFilled = true;
        break;
      }
    }

    if (!idFilled) {
      console.log('아이디 입력 필드를 찾을 수 없습니다.');
      return false;
    }

    // 비밀번호 입력
    const pwSelectors = ['#password', 'input[name="password"]', 'input[type="password"]'];
    for (const selector of pwSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible().catch(() => false)) {
        await el.fill('redp0416!@');
        break;
      }
    }

    // 로그인 버튼 클릭
    const loginSelectors = [
      'button:has-text("로그인")',
      'input[type="submit"]',
      'button[type="submit"]',
      '.login-btn',
    ];
    for (const selector of loginSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible().catch(() => false)) {
        await el.click();
        break;
      }
    }

    await page.waitForTimeout(3000);
    return true;
  } catch (error) {
    console.log('로그인 중 오류 발생:', error);
    return false;
  }
}

/**
 * SDK 인터셉터 monkey-patch 설정
 * postMessage, edicusSDK 메서드 등을 가로채 기록
 */
async function setupSdkInterceptor(page: Page): Promise<void> {
  await page.addInitScript(() => {
    // 배열 초기화
    window.__sdk_calls = [];
    window.__post_messages = [];
    window.__received_messages = [];

    // postMessage 인터셉트
    const origPost = window.postMessage.bind(window);
    window.postMessage = function (data: unknown, ...args: unknown[]) {
      try {
        window.__post_messages.push({
          time: Date.now(),
          data: JSON.parse(JSON.stringify(data)),
        });
      } catch {
        // 직렬화 불가 데이터는 타입 정보만 기록
        window.__post_messages.push({
          time: Date.now(),
          data: { _type: typeof data, _error: '직렬화 불가' },
        });
      }
      // @ts-expect-error - 원본 함수 호출
      return origPost(data, ...args);
    };

    // 수신 메시지 인터셉트
    window.addEventListener('message', (e: MessageEvent) => {
      try {
        window.__received_messages.push({
          time: Date.now(),
          origin: e.origin,
          data: JSON.parse(JSON.stringify(e.data)),
        });
      } catch {
        window.__received_messages.push({
          time: Date.now(),
          origin: e.origin,
          data: { _type: typeof e.data, _error: '직렬화 불가' },
        });
      }
    });

    // Object.defineProperty 후킹으로 edicusSDK 탐지
    const origDefine = Object.defineProperty.bind(Object);
    // @ts-expect-error - prototype 수정
    Object.defineProperty = function (
      obj: object,
      prop: string,
      desc: PropertyDescriptor,
    ) {
      if (prop === 'edicusSDK' && desc.value) {
        const sdk = desc.value as Record<string, unknown>;
        const methods = [
          'init',
          'create_project',
          'open_project',
          'close',
          'destroy',
          'post_to_editor',
          'get_from_editor',
          'set_language',
          'set_page',
          'get_page_count',
        ];

        methods.forEach((m) => {
          if (typeof sdk[m] === 'function') {
            const orig = (sdk[m] as (...args: unknown[]) => unknown).bind(sdk);
            sdk[m] = function (...args: unknown[]) {
              try {
                window.__sdk_calls.push({
                  method: m,
                  args: JSON.parse(JSON.stringify(args)),
                  time: Date.now(),
                });
              } catch {
                window.__sdk_calls.push({
                  method: m,
                  args: [{ _error: '인자 직렬화 불가' }],
                  time: Date.now(),
                });
              }
              return orig(...args);
            };
          }
        });
      }
      return origDefine(obj, prop, desc);
    };

    console.log('[SDK 인터셉터] 초기화 완료');
  });
}

test.describe('Edicus SDK 런타임 분석', () => {
  test.beforeEach(async ({ page }) => {
    // 1. SDK 인터셉터 monkey-patch 설정
    await setupSdkInterceptor(page);

    // 2. 로그인
    const loginSuccess = await performLogin(page);
    if (!loginSuccess) {
      console.log('로그인 실패 - 테스트를 비로그인 상태로 계속 진행합니다.');
    }
  });

  test('모바일 편집기 카탈로그 분석', async ({ page }) => {
    // 모바일 편집기 랜딩 페이지 접속
    await page.goto('/landing/mobile_editor', { waitUntil: 'domcontentloaded' });
    await page.waitForTimeout(2000);

    // 네트워크 유휴 상태 대기 (최대 10초)
    await page.waitForLoadState('networkidle').catch(() => {
      console.log('networkidle 대기 타임아웃 - 계속 진행합니다.');
    });

    // 현재 URL 기록
    console.log('현재 URL:', page.url());

    // 상품 목록 추출
    const products = await page.evaluate(() => {
      return Array.from(document.querySelectorAll('a[href*="/product/item/"]'))
        .map((a) => ({
          text: a.textContent?.trim().substring(0, 50),
          href: a.getAttribute('href'),
        }))
        .slice(0, 20);
    });

    console.log('=== 상품 목록 ===');
    console.log(JSON.stringify(products, null, 2));

    // 페이지 전체 링크 수집 (상품 링크가 없는 경우 대비)
    if (products.length === 0) {
      const allLinks = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('a[href]'))
          .filter((a) => a.getAttribute('href')?.includes('product'))
          .map((a) => ({
            text: a.textContent?.trim().substring(0, 50),
            href: a.getAttribute('href'),
          }))
          .slice(0, 20);
      });
      console.log('=== 대체 상품 링크 ===');
      console.log(JSON.stringify(allLinks, null, 2));
    }

    // 페이지 타이틀 출력
    const title = await page.title();
    console.log('페이지 타이틀:', title);

    // 스크린샷 저장
    await page.screenshot({
      path: 'tests/e2e/results/mobile-editor-catalog.png',
      fullPage: true,
    });

    // 페이지가 정상적으로 로드되었는지 확인
    expect(page.url()).toContain('redprinting.co.kr');
  });

  test('상품 상세 → 편집기 진입 흐름 분석', async ({ page }) => {
    // 상품 상세 페이지로 이동
    await page.goto('/product/item/ST/STPAUNM', {
      waitUntil: 'domcontentloaded',
    });
    await page.waitForTimeout(3000);

    // 현재 URL 확인
    console.log('상품 페이지 URL:', page.url());

    // 스크린샷 저장 (상품 페이지)
    await page.screenshot({
      path: 'tests/e2e/results/product-page.png',
      fullPage: false,
    });

    // 주문하기 버튼 탐색
    const orderSelectors = [
      '.action-btn.highlight',
      'button:has-text("주문하기")',
      'a:has-text("주문하기")',
      '.order-btn',
      '[class*="order"]',
    ];

    let orderBtn = null;
    for (const selector of orderSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible().catch(() => false)) {
        orderBtn = el;
        console.log('주문하기 버튼 발견:', selector);
        break;
      }
    }

    if (orderBtn) {
      await orderBtn.click();
      console.log('주문하기 버튼 클릭 완료');

      // 편집기 로드 대기
      await page.waitForTimeout(5000);

      // 스크린샷 저장 (편집기 진입 후)
      await page.screenshot({
        path: 'tests/e2e/results/after-order-click.png',
        fullPage: false,
      });

      // iframe 감지
      const iframes = await page.evaluate(() =>
        Array.from(document.querySelectorAll('iframe')).map((f) => ({
          src: f.src,
          id: f.id,
          className: f.className,
          width: f.width,
          height: f.height,
        })),
      );
      console.log('=== iframe 감지 결과 ===');
      console.log(JSON.stringify(iframes, null, 2));

      // SDK 호출 캡처
      const sdkCalls = await page.evaluate(() => window.__sdk_calls || []);
      console.log('=== SDK 호출 기록 ===');
      console.log(JSON.stringify(sdkCalls, null, 2));

      // postMessage 캡처
      const messages = await page.evaluate(() => ({
        sent: window.__post_messages || [],
        received: window.__received_messages || [],
      }));
      console.log('=== postMessage 기록 ===');
      console.log('전송:', JSON.stringify(messages.sent, null, 2));
      console.log('수신:', JSON.stringify(messages.received, null, 2));

      // Edicus iframe이 있으면 추가 분석
      const edicusIframe = iframes.find(
        (f) => f.src?.includes('edicus') || f.src?.includes('editor'),
      );
      if (edicusIframe) {
        console.log('=== Edicus iframe 발견 ===');
        const url = new URL(edicusIframe.src);
        const params: Record<string, string> = {};
        url.searchParams.forEach((v, k) => {
          params[k] = v;
        });
        console.log('iframe 파라미터:', JSON.stringify(params, null, 2));
      }
    } else {
      console.log('주문하기 버튼을 찾을 수 없습니다. 페이지 구조를 분석합니다.');

      // 버튼 목록 출력
      const buttons = await page.evaluate(() =>
        Array.from(document.querySelectorAll('button, a.btn, .action-btn'))
          .map((el) => ({
            tag: el.tagName,
            text: el.textContent?.trim().substring(0, 30),
            className: el.className,
          }))
          .slice(0, 20),
      );
      console.log('페이지 내 버튼 목록:', JSON.stringify(buttons, null, 2));
    }

    // 기본 검증: 페이지가 로드되었는지 확인
    expect(page.url()).toContain('redprinting.co.kr');
  });

  test('iframe URL 파라미터 추출', async ({ page }) => {
    await page.goto('/product/item/ST/STPAUNM', {
      waitUntil: 'domcontentloaded',
    });
    await page.waitForTimeout(2000);

    // DOM 변경 감시 + 주문하기 클릭으로 iframe 생성 유도
    const iframeSrc = await page.evaluate(() => {
      return new Promise<string | null>((resolve) => {
        const observer = new MutationObserver((mutations) => {
          for (const mutation of mutations) {
            for (const node of mutation.addedNodes) {
              if (node instanceof HTMLIFrameElement && node.src) {
                // edicus 또는 editor 포함 URL 탐지
                if (
                  node.src.includes('edicus') ||
                  node.src.includes('editor') ||
                  node.src.includes('redprinting')
                ) {
                  observer.disconnect();
                  resolve(node.src);
                }
              }
            }
          }
        });

        // body 전체 감시
        observer.observe(document.body, { childList: true, subtree: true });

        // 10초 타임아웃
        setTimeout(() => {
          observer.disconnect();
          // 이미 존재하는 iframe 확인
          const existing = document.querySelector('iframe');
          resolve(existing?.src ?? null);
        }, 10000);

        // 주문하기 버튼 클릭 시도
        const btn =
          document.querySelector<HTMLElement>('.action-btn.highlight') ??
          document.querySelector<HTMLElement>('button[class*="order"]') ??
          [...document.querySelectorAll<HTMLElement>('button, a')].find(
            (el) => el.textContent?.includes('주문하기'),
          ) ??
          null;

        if (btn) {
          btn.click();
        }
      });
    });

    if (iframeSrc) {
      try {
        const url = new URL(iframeSrc);
        const params: Record<string, string> = {};
        url.searchParams.forEach((v, k) => {
          params[k] = v;
        });

        console.log('=== Edicus iframe 파라미터 ===');
        console.log('전체 URL:', iframeSrc);
        console.log('호스트:', url.hostname);
        console.log('경로:', url.pathname);
        console.log('파라미터:', JSON.stringify(params, null, 2));

        // private_css 파라미터 확인
        if (params['private_css']) {
          console.log('Custom CSS URL:', params['private_css']);
        }
        // mobile 파라미터 확인
        if (params['mobile']) {
          console.log('Mobile mode:', params['mobile']);
        }
        // ps_code 파라미터 확인
        if (params['ps_code']) {
          console.log('Product/Service Code:', params['ps_code']);
        }

        // 파라미터 파일 저장
        const fs = await import('fs');
        await fs.promises.writeFile(
          'tests/e2e/results/iframe-params.json',
          JSON.stringify({ url: iframeSrc, params }, null, 2),
          'utf-8',
        );
        console.log('파라미터가 tests/e2e/results/iframe-params.json에 저장되었습니다.');
      } catch (error) {
        console.log('URL 파싱 오류:', error);
      }
    } else {
      console.log('Edicus iframe이 감지되지 않았습니다.');
      console.log('현재 페이지 URL:', page.url());

      // 현재 iframe 목록 확인
      const iframes = await page.evaluate(() =>
        Array.from(document.querySelectorAll('iframe')).map((f) => ({
          src: f.src,
          id: f.id,
        })),
      );
      console.log('현재 iframe 목록:', JSON.stringify(iframes));
    }

    // 기본 검증
    expect(page.url()).toContain('redprinting.co.kr');
  });
});
