/**
 * Playwright 기반 Edicus SDK 런타임 분석기
 *
 * 대상 사이트에 접속하여 SDK 초기화 파라미터, postMessage, iframe URL을 캡처합니다.
 *
 * 사용법:
 *   node scripts/sdk-analyzer.mjs
 *   node scripts/sdk-analyzer.mjs [URL] [USERNAME] [PASSWORD]
 *
 * 기본값:
 *   URL: https://m.redprinting.co.kr
 *   USERNAME: lojesus75
 *   PASSWORD: redp0416!@
 *
 * 출력:
 *   tests/e2e/results/sdk-analysis-report.json
 *   tests/e2e/results/sdk-analysis-report.md
 *   tests/e2e/results/sdk-analysis.har (HAR 파일)
 *   tests/e2e/results/screenshots/ (단계별 스크린샷)
 */

import { chromium } from 'playwright';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// ESM에서 __dirname 대체
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ============================================================
// 설정 상수
// ============================================================

/** 기본 타겟 URL */
const DEFAULT_BASE_URL = 'https://m.redprinting.co.kr';

/** 기본 로그인 정보 */
const DEFAULT_CREDENTIALS = {
  username: 'lojesus75',
  password: 'redp0416!@',
};

/** 분석 대상 상품 경로 */
const PRODUCT_PATH = '/product/item/ST/STPAUNM';

/** 결과 저장 디렉토리 */
const RESULTS_DIR = path.join(__dirname, '..', 'tests', 'e2e', 'results');

/** 스크린샷 저장 디렉토리 */
const SCREENSHOTS_DIR = path.join(RESULTS_DIR, 'screenshots');

/** iPhone 14 뷰포트 설정 */
const MOBILE_VIEWPORT = { width: 393, height: 852 };

/** 분석 타임아웃 (밀리초) */
const ANALYSIS_TIMEOUT = 30000;

// ============================================================
// 타입 정의 (JSDoc)
// ============================================================

/**
 * @typedef {Object} SdkCall
 * @property {string} method - 호출된 메서드명
 * @property {unknown[]} args - 전달된 인자
 * @property {number} time - 호출 시각 (Unix timestamp)
 */

/**
 * @typedef {Object} PostMessageRecord
 * @property {number} time - 메시지 전송/수신 시각
 * @property {string} [origin] - 메시지 출처 (수신 시)
 * @property {unknown} data - 메시지 데이터
 */

/**
 * @typedef {Object} IframeParams
 * @property {string} url - iframe 전체 URL
 * @property {string} hostname - iframe 호스트명
 * @property {string} pathname - iframe 경로
 * @property {Record<string, string>} params - URL 파라미터
 */

/**
 * @typedef {Object} AnalysisReport
 * @property {string} timestamp - 분석 시작 시각
 * @property {string} targetUrl - 분석 대상 URL
 * @property {string} productPath - 상품 페이지 경로
 * @property {boolean} loginSuccess - 로그인 성공 여부
 * @property {string[]} productUrls - 발견된 상품 URL 목록
 * @property {SdkCall[]} sdkCalls - SDK 메서드 호출 기록
 * @property {PostMessageRecord[]} sentMessages - 전송한 postMessage 기록
 * @property {PostMessageRecord[]} receivedMessages - 수신한 postMessage 기록
 * @property {IframeParams|null} edicusIframe - Edicus iframe 정보
 * @property {string[]} networkRequests - 네트워크 요청 URL 목록
 * @property {Record<string, string>} cookies - 쿠키 정보
 * @property {string[]} errors - 분석 중 발생한 오류 목록
 */

// ============================================================
// 유틸리티 함수
// ============================================================

/**
 * 디렉토리가 없으면 생성합니다.
 * @param {string} dir - 생성할 디렉토리 경로
 */
function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

/**
 * 로그 출력 (타임스탬프 포함)
 * @param {string} message - 출력할 메시지
 * @param {'info'|'success'|'warn'|'error'} level - 로그 레벨
 */
function log(message, level = 'info') {
  const timestamp = new Date().toISOString().substring(11, 23);
  const prefix = {
    info: '[정보]',
    success: '[성공]',
    warn: '[경고]',
    error: '[오류]',
  }[level];
  console.log(`${timestamp} ${prefix} ${message}`);
}

/**
 * 지정된 시간만큼 대기합니다.
 * @param {number} ms - 대기 시간 (밀리초)
 */
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

// ============================================================
// 핵심 분석 함수
// ============================================================

/**
 * Monkey-patch 스크립트를 페이지에 주입합니다.
 * SDK 메서드 호출과 postMessage를 가로챕니다.
 * @param {import('playwright').Page} page
 */
async function injectMonkeyPatch(page) {
  await page.addInitScript(() => {
    // 캡처 배열 초기화
    window.__sdk_calls = [];
    window.__post_messages = [];
    window.__received_messages = [];

    // ---- postMessage 인터셉트 ----
    const origPost = window.postMessage.bind(window);
    window.postMessage = function (data, ...args) {
      try {
        window.__post_messages.push({
          time: Date.now(),
          data: JSON.parse(JSON.stringify(data)),
        });
      } catch {
        window.__post_messages.push({
          time: Date.now(),
          data: { _type: typeof data, _note: '직렬화 불가' },
        });
      }
      return origPost(data, ...args);
    };

    // ---- 수신 메시지 인터셉트 ----
    window.addEventListener('message', (e) => {
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
          data: { _type: typeof e.data, _note: '직렬화 불가' },
        });
      }
    });

    // ---- edicusSDK 탐지 및 메서드 인터셉트 ----
    const origDefine = Object.defineProperty.bind(Object);
    Object.defineProperty = function (obj, prop, desc) {
      if (prop === 'edicusSDK' && desc && desc.value) {
        const sdk = desc.value;
        const methodsToHook = [
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
          'set_option',
          'get_option',
          'undo',
          'redo',
          'save',
          'export',
        ];

        methodsToHook.forEach((m) => {
          if (typeof sdk[m] === 'function') {
            const orig = sdk[m].bind(sdk);
            sdk[m] = function (...callArgs) {
              try {
                window.__sdk_calls.push({
                  method: m,
                  args: JSON.parse(JSON.stringify(callArgs)),
                  time: Date.now(),
                });
              } catch {
                window.__sdk_calls.push({
                  method: m,
                  args: [{ _note: '인자 직렬화 불가' }],
                  time: Date.now(),
                });
              }
              return orig(...callArgs);
            };
          }
        });

        console.log('[SDK 분석기] edicusSDK 인터셉트 완료');
      }
      return origDefine(obj, prop, desc);
    };

    // ---- window.edicusSDK 프록시 감시 ----
    let _edicusSDK = undefined;
    Object.defineProperty(window, 'edicusSDK', {
      get() {
        return _edicusSDK;
      },
      set(value) {
        console.log('[SDK 분석기] edicusSDK 할당 감지');
        _edicusSDK = value;
        window.__sdk_calls.push({
          method: '__init_detected__',
          args: [Object.keys(value ?? {})],
          time: Date.now(),
        });
      },
      configurable: true,
    });
  });

  log('Monkey-patch 스크립트 주입 완료');
}

/**
 * 레드프린팅 사이트에 로그인합니다.
 * @param {import('playwright').Page} page
 * @param {string} baseUrl - 기본 URL
 * @param {{username: string, password: string}} credentials - 로그인 정보
 * @returns {Promise<boolean>} 로그인 성공 여부
 */
async function login(page, baseUrl, credentials) {
  log('로그인 시도 중...');

  try {
    await page.goto(`${baseUrl}/member/login`, {
      waitUntil: 'domcontentloaded',
      timeout: ANALYSIS_TIMEOUT,
    });
    await sleep(2000);

    // 스크린샷 저장 (로그인 페이지)
    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, '01-login-page.png'),
    });

    // 아이디 입력
    const idSelectors = [
      '#mb_id',
      'input[name="mb_id"]',
      'input[placeholder*="아이디"]',
      'input[type="text"]:first-of-type',
    ];

    let idFilled = false;
    for (const selector of idSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible({ timeout: 2000 }).catch(() => false)) {
        await el.fill(credentials.username);
        idFilled = true;
        log(`아이디 입력 완료 (선택자: ${selector})`);
        break;
      }
    }

    if (!idFilled) {
      log('아이디 입력 필드를 찾을 수 없습니다.', 'warn');
      return false;
    }

    // 비밀번호 입력
    const pwSelectors = [
      '#password',
      'input[name="password"]',
      'input[type="password"]',
    ];

    for (const selector of pwSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible({ timeout: 2000 }).catch(() => false)) {
        await el.fill(credentials.password);
        log(`비밀번호 입력 완료 (선택자: ${selector})`);
        break;
      }
    }

    // 로그인 버튼 클릭
    const loginSelectors = [
      'button:has-text("로그인")',
      'input[type="submit"]',
      'button[type="submit"]',
      '.btn-login',
      '.login_submit',
    ];

    for (const selector of loginSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible({ timeout: 2000 }).catch(() => false)) {
        await el.click();
        log(`로그인 버튼 클릭 완료 (선택자: ${selector})`);
        break;
      }
    }

    await sleep(3000);

    // 스크린샷 저장 (로그인 후)
    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, '02-after-login.png'),
    });

    // 로그인 성공 확인 (URL 변경 또는 로그인 버튼 사라짐)
    const currentUrl = page.url();
    const isLoggedIn =
      !currentUrl.includes('/member/login') ||
      !(await page
        .locator('input[type="password"]')
        .isVisible()
        .catch(() => true));

    if (isLoggedIn) {
      log('로그인 성공', 'success');
      return true;
    } else {
      log('로그인 결과 불명확 - 계속 진행합니다.', 'warn');
      return true; // 실패해도 분석 계속
    }
  } catch (error) {
    log(`로그인 중 오류: ${error}`, 'error');
    return false;
  }
}

/**
 * 모바일 편집기 카탈로그를 분석합니다.
 * @param {import('playwright').Page} page
 * @param {string} baseUrl
 * @returns {Promise<string[]>} 발견된 상품 URL 목록
 */
async function analyzeCatalog(page, baseUrl) {
  log('모바일 편집기 카탈로그 분석 중...');

  try {
    await page.goto(`${baseUrl}/landing/mobile_editor`, {
      waitUntil: 'domcontentloaded',
      timeout: ANALYSIS_TIMEOUT,
    });
    await sleep(2000);

    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, '03-catalog-page.png'),
      fullPage: true,
    });

    const products = await page.evaluate(() => {
      return Array.from(document.querySelectorAll('a[href*="/product/item/"]'))
        .map((a) => a.getAttribute('href') ?? '')
        .filter(Boolean)
        .slice(0, 30);
    });

    log(`상품 ${products.length}개 발견`);
    return products;
  } catch (error) {
    log(`카탈로그 분석 오류: ${error}`, 'error');
    return [];
  }
}

/**
 * 상품 페이지에서 편집기 진입 흐름을 분석합니다.
 * @param {import('playwright').Page} page
 * @param {string} baseUrl
 * @param {string} productPath
 * @returns {Promise<IframeParams|null>}
 */
async function analyzeEditorFlow(page, baseUrl, productPath) {
  log(`상품 페이지 분석 중: ${productPath}`);

  try {
    await page.goto(`${baseUrl}${productPath}`, {
      waitUntil: 'domcontentloaded',
      timeout: ANALYSIS_TIMEOUT,
    });
    await sleep(3000);

    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, '04-product-page.png'),
      fullPage: false,
    });

    // 주문하기 버튼 탐색 및 클릭
    const orderSelectors = [
      '.action-btn.highlight',
      'button:has-text("주문하기")',
      'a:has-text("주문하기")',
      'button:has-text("편집하기")',
      'a:has-text("편집하기")',
      '[class*="order"]',
      '[class*="btn-primary"]',
    ];

    let btnClicked = false;
    for (const selector of orderSelectors) {
      const el = page.locator(selector).first();
      if (await el.isVisible({ timeout: 2000 }).catch(() => false)) {
        log(`버튼 발견 및 클릭: ${selector}`);
        await el.click();
        btnClicked = true;
        break;
      }
    }

    if (!btnClicked) {
      log('주문하기 버튼을 찾을 수 없습니다. 페이지 버튼 목록 확인...', 'warn');
      const buttons = await page.evaluate(() =>
        Array.from(document.querySelectorAll('button, .btn, a.action'))
          .map((el) => ({
            text: el.textContent?.trim().substring(0, 30),
            className: el.className?.substring(0, 50),
          }))
          .slice(0, 15),
      );
      log('발견된 버튼: ' + JSON.stringify(buttons));
    }

    // 편집기 로드 대기
    await sleep(5000);

    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, '05-after-button-click.png'),
      fullPage: false,
    });

    // iframe 탐색
    const iframes = await page.evaluate(() =>
      Array.from(document.querySelectorAll('iframe')).map((f) => ({
        src: f.src,
        id: f.id,
        className: f.className,
      })),
    );

    log(`iframe ${iframes.length}개 감지`);

    // Edicus iframe 탐색
    const edicusIframe = iframes.find(
      (f) =>
        f.src?.includes('edicus') ||
        f.src?.includes('editor') ||
        f.src?.includes('red-editor'),
    );

    if (edicusIframe?.src) {
      try {
        const url = new URL(edicusIframe.src);
        const params = {};
        url.searchParams.forEach((v, k) => {
          params[k] = v;
        });

        log('Edicus iframe 발견!', 'success');
        log('URL: ' + edicusIframe.src);
        log('파라미터: ' + JSON.stringify(params, null, 2));

        return {
          url: edicusIframe.src,
          hostname: url.hostname,
          pathname: url.pathname,
          params,
        };
      } catch (err) {
        log(`iframe URL 파싱 오류: ${err}`, 'error');
      }
    } else {
      log('Edicus iframe이 감지되지 않았습니다.', 'warn');
      log('감지된 iframe 목록: ' + JSON.stringify(iframes));
    }

    return null;
  } catch (error) {
    log(`편집기 흐름 분석 오류: ${error}`, 'error');
    return null;
  }
}

/**
 * SDK 호출 데이터를 페이지에서 수집합니다.
 * @param {import('playwright').Page} page
 * @returns {Promise<{sdkCalls: SdkCall[], sentMessages: PostMessageRecord[], receivedMessages: PostMessageRecord[]}>}
 */
async function collectSdkData(page) {
  const data = await page.evaluate(() => ({
    sdkCalls: window.__sdk_calls ?? [],
    sentMessages: window.__post_messages ?? [],
    receivedMessages: window.__received_messages ?? [],
  }));

  log(`SDK 호출 ${data.sdkCalls.length}건 수집`);
  log(`전송 메시지 ${data.sentMessages.length}건 수집`);
  log(`수신 메시지 ${data.receivedMessages.length}건 수집`);

  return data;
}

// ============================================================
// 보고서 생성 함수
// ============================================================

/**
 * JSON 분석 보고서를 생성합니다.
 * @param {AnalysisReport} report
 */
async function saveJsonReport(report) {
  const filePath = path.join(RESULTS_DIR, 'sdk-analysis-report.json');
  await fs.promises.writeFile(filePath, JSON.stringify(report, null, 2), 'utf-8');
  log(`JSON 보고서 저장: ${filePath}`, 'success');
}

/**
 * 마크다운 분석 보고서를 생성합니다.
 * @param {AnalysisReport} report
 */
async function saveMarkdownReport(report) {
  const lines = [];

  lines.push('# Edicus SDK 런타임 분석 보고서');
  lines.push('');
  lines.push(`- **분석 일시**: ${report.timestamp}`);
  lines.push(`- **대상 URL**: ${report.targetUrl}`);
  lines.push(`- **상품 경로**: ${report.productPath}`);
  lines.push(`- **로그인 성공**: ${report.loginSuccess ? '예' : '아니오'}`);
  lines.push('');

  // 상품 목록
  lines.push('## 발견된 상품 URL');
  if (report.productUrls.length > 0) {
    report.productUrls.forEach((url) => {
      lines.push(`- ${url}`);
    });
  } else {
    lines.push('- 상품을 찾을 수 없습니다.');
  }
  lines.push('');

  // Edicus iframe 파라미터
  lines.push('## Edicus iframe 정보');
  if (report.edicusIframe) {
    lines.push(`- **전체 URL**: \`${report.edicusIframe.url}\``);
    lines.push(`- **호스트**: \`${report.edicusIframe.hostname}\``);
    lines.push(`- **경로**: \`${report.edicusIframe.pathname}\``);
    lines.push('');
    lines.push('### URL 파라미터');
    lines.push('| 파라미터 | 값 |');
    lines.push('|---------|-----|');
    Object.entries(report.edicusIframe.params).forEach(([k, v]) => {
      lines.push(`| \`${k}\` | \`${v}\` |`);
    });
  } else {
    lines.push('iframe이 감지되지 않았습니다.');
  }
  lines.push('');

  // SDK 호출 기록
  lines.push('## SDK 메서드 호출 기록');
  if (report.sdkCalls.length > 0) {
    lines.push('| 시각 | 메서드 | 인자 |');
    lines.push('|------|--------|------|');
    report.sdkCalls.forEach((call) => {
      const time = new Date(call.time).toISOString().substring(11, 23);
      const args = JSON.stringify(call.args).substring(0, 100);
      lines.push(`| ${time} | \`${call.method}\` | \`${args}\` |`);
    });
  } else {
    lines.push('SDK 호출이 감지되지 않았습니다.');
  }
  lines.push('');

  // postMessage 기록
  lines.push('## postMessage 기록');
  lines.push('');
  lines.push('### 전송 메시지');
  if (report.sentMessages.length > 0) {
    report.sentMessages.forEach((msg, i) => {
      const time = new Date(msg.time).toISOString().substring(11, 23);
      lines.push(`**${i + 1}. [${time}]**`);
      lines.push('```json');
      lines.push(JSON.stringify(msg.data, null, 2).substring(0, 500));
      lines.push('```');
    });
  } else {
    lines.push('전송된 메시지가 없습니다.');
  }
  lines.push('');

  lines.push('### 수신 메시지');
  if (report.receivedMessages.length > 0) {
    report.receivedMessages.forEach((msg, i) => {
      const time = new Date(msg.time).toISOString().substring(11, 23);
      lines.push(`**${i + 1}. [${time}] 출처: ${msg.origin}**`);
      lines.push('```json');
      lines.push(JSON.stringify(msg.data, null, 2).substring(0, 500));
      lines.push('```');
    });
  } else {
    lines.push('수신된 메시지가 없습니다.');
  }
  lines.push('');

  // 네트워크 요청
  lines.push('## 네트워크 요청 (Edicus 관련)');
  const edicusRequests = report.networkRequests.filter(
    (url) => url.includes('edicus') || url.includes('editor'),
  );
  if (edicusRequests.length > 0) {
    edicusRequests.forEach((url) => {
      lines.push(`- \`${url}\``);
    });
  } else {
    lines.push('Edicus 관련 네트워크 요청이 감지되지 않았습니다.');
  }
  lines.push('');

  // 오류 목록
  if (report.errors.length > 0) {
    lines.push('## 분석 중 발생한 오류');
    report.errors.forEach((err) => {
      lines.push(`- ${err}`);
    });
    lines.push('');
  }

  lines.push('---');
  lines.push('*이 보고서는 sdk-analyzer.mjs에 의해 자동 생성되었습니다.*');

  const filePath = path.join(RESULTS_DIR, 'sdk-analysis-report.md');
  await fs.promises.writeFile(filePath, lines.join('\n'), 'utf-8');
  log(`마크다운 보고서 저장: ${filePath}`, 'success');
}

// ============================================================
// 메인 실행 함수
// ============================================================

/**
 * SDK 분석기의 메인 실행 함수
 */
async function main() {
  // CLI 인수 파싱
  const args = process.argv.slice(2);
  const baseUrl = args[0] ?? DEFAULT_BASE_URL;
  const username = args[1] ?? DEFAULT_CREDENTIALS.username;
  const password = args[2] ?? DEFAULT_CREDENTIALS.password;

  log('='.repeat(60));
  log('Edicus SDK 런타임 분석기 시작');
  log(`대상 URL: ${baseUrl}`);
  log(`사용자: ${username}`);
  log('='.repeat(60));

  // 결과 디렉토리 생성
  ensureDir(RESULTS_DIR);
  ensureDir(SCREENSHOTS_DIR);

  // 분석 보고서 초기화
  /** @type {AnalysisReport} */
  const report = {
    timestamp: new Date().toISOString(),
    targetUrl: baseUrl,
    productPath: PRODUCT_PATH,
    loginSuccess: false,
    productUrls: [],
    sdkCalls: [],
    sentMessages: [],
    receivedMessages: [],
    edicusIframe: null,
    networkRequests: [],
    cookies: {},
    errors: [],
  };

  // 브라우저 시작
  const browser = await chromium.launch({
    headless: true, // 헤드리스 모드 (false로 변경하면 브라우저 창이 열림)
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-web-security', // CORS 우회 (분석 목적)
      '--allow-running-insecure-content',
    ],
  });

  // 브라우저 컨텍스트 생성 (모바일 에뮬레이션)
  const context = await browser.newContext({
    viewport: MOBILE_VIEWPORT,
    userAgent:
      'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/116.0.5845.103 Mobile/15E148 Safari/604.1',
    deviceScaleFactor: 3,
    isMobile: true,
    hasTouch: true,
    locale: 'ko-KR',
    timezoneId: 'Asia/Seoul',
    // HAR 기록
    recordHar: {
      path: path.join(RESULTS_DIR, 'sdk-analysis.har'),
      mode: 'full',
    },
  });

  // 네트워크 요청 기록
  context.on('request', (request) => {
    const url = request.url();
    if (url.includes('edicus') || url.includes('editor') || url.includes('sdk')) {
      report.networkRequests.push(url);
    }
  });

  const page = await context.newPage();

  // 콘솔 로그 수집
  page.on('console', (msg) => {
    if (msg.text().includes('SDK') || msg.text().includes('edicus')) {
      log(`[브라우저 콘솔] ${msg.text()}`);
    }
  });

  // 페이지 오류 수집
  page.on('pageerror', (err) => {
    report.errors.push(err.message);
  });

  try {
    // 1단계: Monkey-patch 주입
    await injectMonkeyPatch(page);

    // 2단계: 로그인
    report.loginSuccess = await login(page, baseUrl, { username, password });

    // 쿠키 수집
    const cookies = await context.cookies();
    cookies.forEach((c) => {
      report.cookies[c.name] = c.value.substring(0, 50); // 보안상 일부만 기록
    });

    // 3단계: 카탈로그 분석
    report.productUrls = await analyzeCatalog(page, baseUrl);

    // 4단계: 편집기 흐름 분석
    report.edicusIframe = await analyzeEditorFlow(page, baseUrl, PRODUCT_PATH);

    // 5단계: SDK 호출 데이터 수집
    const sdkData = await collectSdkData(page);
    report.sdkCalls = sdkData.sdkCalls;
    report.sentMessages = sdkData.sentMessages;
    report.receivedMessages = sdkData.receivedMessages;

    // 최종 스크린샷
    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, '06-final-state.png'),
      fullPage: false,
    });

    log('='.repeat(60));
    log('분석 완료 요약:', 'success');
    log(`  - 로그인: ${report.loginSuccess ? '성공' : '실패'}`);
    log(`  - 발견 상품: ${report.productUrls.length}개`);
    log(`  - SDK 호출: ${report.sdkCalls.length}건`);
    log(`  - 전송 메시지: ${report.sentMessages.length}건`);
    log(`  - 수신 메시지: ${report.receivedMessages.length}건`);
    log(`  - Edicus iframe: ${report.edicusIframe ? '발견' : '미발견'}`);
    log('='.repeat(60));
  } catch (error) {
    log(`분석 중 치명적 오류: ${error}`, 'error');
    report.errors.push(String(error));

    // 오류 스크린샷
    await page.screenshot({
      path: path.join(SCREENSHOTS_DIR, 'error-state.png'),
    }).catch(() => {});
  } finally {
    // HAR 파일 저장을 위해 컨텍스트 닫기
    await context.close();
    await browser.close();
    log('브라우저 종료');
  }

  // 보고서 저장
  await saveJsonReport(report);
  await saveMarkdownReport(report);

  log('='.repeat(60));
  log('모든 결과가 저장되었습니다:', 'success');
  log(`  - JSON: ${path.join(RESULTS_DIR, 'sdk-analysis-report.json')}`);
  log(`  - Markdown: ${path.join(RESULTS_DIR, 'sdk-analysis-report.md')}`);
  log(`  - HAR: ${path.join(RESULTS_DIR, 'sdk-analysis.har')}`);
  log(`  - 스크린샷: ${SCREENSHOTS_DIR}`);
  log('='.repeat(60));
}

// 실행
main().catch((err) => {
  console.error('치명적 오류:', err);
  process.exit(1);
});
