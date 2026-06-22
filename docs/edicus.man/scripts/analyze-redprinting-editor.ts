/**
 * 레드프린팅 실제 편집기 접속 + API/CSS 완전 분석
 * 환경변수의 자격증명으로 로그인 → 상품 선택 → 편집기 로드 → 전체 분석
 */
import { chromium, Page, BrowserContext } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';
// .env.local 수동 파싱 (dotenv 없이)
const envPath = path.join(__dirname, '..', '.env.local');
const envContent = fs.readFileSync(envPath, 'utf-8');
const envVars: Record<string, string> = {};
for (const line of envContent.split('\n')) {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith('#')) continue;
  const eqIdx = trimmed.indexOf('=');
  if (eqIdx > 0) {
    envVars[trimmed.slice(0, eqIdx)] = trimmed.slice(eqIdx + 1);
  }
}

const REDPRINTING_URL = envVars.REDPRINTING_URL || 'https://m.redprinting.co.kr/landing/mobile_editor';
const USERNAME = envVars.REDPRINTING_USERNAME;
const PASSWORD = envVars.REDPRINTING_PASSWORD;
const OUTPUT_DIR = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-CSS-001', 'analysis');

// 전역 캡처 데이터
const apiCalls: { method: string; url: string; type: string; status?: number; body?: string; response?: string }[] = [];
const edicusRequests: { url: string; params: Record<string, string>; type: string }[] = [];
const consoleMessages: string[] = [];
const postMessageData: string[] = [];

async function main() {
  console.log('=== 레드프린팅 편집기 완전 분석 ===\n');
  console.log(`URL: ${REDPRINTING_URL}`);
  console.log(`사용자: ${USERNAME}`);

  if (!USERNAME || !PASSWORD) {
    console.error('환경변수 REDPRINTING_USERNAME, REDPRINTING_PASSWORD가 필요합니다.');
    process.exit(1);
  }

  // 출력 디렉토리 생성
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-web-security'],
  });

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
    viewport: { width: 390, height: 844 },
    isMobile: true,
  });

  const page = await context.newPage();
  setupNetworkCapture(page);
  setupConsoleCapture(page);

  try {
    // Phase 1: 로그인
    await phase1Login(page, context);

    // Phase 2: 모바일 에디터 카탈로그 접속
    await phase2Catalog(page);

    // Phase 3: 상품 선택 → 상세 페이지
    await phase3ProductDetail(page, context);

    // Phase 4: 편집기 접근 시도
    await phase4Editor(page, context);

    // Phase 5: 결과 분석 및 저장
    await phase5SaveResults();

  } catch (error) {
    console.error('\n오류 발생:', error);
  } finally {
    await browser.close();
    console.log('\n=== 분석 완료 ===');
  }
}

function setupNetworkCapture(page: Page) {
  page.on('request', (req) => {
    const url = req.url();
    const method = req.method();

    // 모든 API 호출 캡처
    if (url.includes('/api/') || url.includes('edicus') || url.includes('edicusbase') ||
        url.includes('firebaseapp') || url.includes('appspot') ||
        url.includes('private_css') || url.includes('css') && !url.includes('.css')) {
      apiCalls.push({
        method,
        url: url.slice(0, 500),
        type: req.resourceType(),
        body: req.postData()?.slice(0, 1000),
      });
    }

    // Edicus 관련 요청 특별 캡처
    if (url.includes('edicus') || url.includes('edicusbase') || url.includes('firebaseapp')) {
      try {
        const urlObj = new URL(url);
        edicusRequests.push({
          url: url.slice(0, 300),
          params: Object.fromEntries(urlObj.searchParams.entries()),
          type: req.resourceType(),
        });
      } catch {
        edicusRequests.push({ url: url.slice(0, 300), params: {}, type: req.resourceType() });
      }
    }
  });

  page.on('response', async (resp) => {
    const url = resp.url();
    if (url.includes('edicus') || url.includes('private_css') || url.includes('css') && url.includes('api')) {
      try {
        const body = await resp.text().catch(() => '');
        const entry = apiCalls.find(a => a.url === url.slice(0, 500) && !a.response);
        if (entry) {
          entry.status = resp.status();
          entry.response = body.slice(0, 2000);
        }
      } catch {}
    }
  });
}

function setupConsoleCapture(page: Page) {
  page.on('console', (msg) => {
    const text = msg.text();
    consoleMessages.push(`[${msg.type()}] ${text}`);
  });
}

async function phase1Login(page: Page, context: BrowserContext) {
  console.log('\n=== Phase 1: 로그인 ===');

  // 레드프린팅 로그인 페이지 접속
  await page.goto('https://m.redprinting.co.kr/member/login', {
    waitUntil: 'networkidle', timeout: 30000,
  });
  console.log(`  로그인 페이지: ${page.url()}`);
  await page.screenshot({ path: path.join(OUTPUT_DIR, '01-login-page.png') });

  // 로그인 폼 찾기 및 입력
  const loginResult = await page.evaluate(({ username, password }: { username: string; password: string }) => {
    // 다양한 로그인 폼 패턴 시도
    const idInputs = document.querySelectorAll('input[name="userId"], input[name="id"], input[name="username"], input[type="text"][name*="id"], input[placeholder*="아이디"]');
    const pwInputs = document.querySelectorAll('input[name="userPw"], input[name="password"], input[type="password"]');

    return {
      idInputCount: idInputs.length,
      pwInputCount: pwInputs.length,
      idInputNames: Array.from(idInputs).map(i => ({
        name: i.getAttribute('name'),
        id: i.id,
        placeholder: i.getAttribute('placeholder'),
      })),
      pwInputNames: Array.from(pwInputs).map(i => ({
        name: i.getAttribute('name'),
        id: i.id,
      })),
      allInputs: Array.from(document.querySelectorAll('input')).map(i => ({
        type: i.type,
        name: i.getAttribute('name'),
        id: i.id,
        placeholder: i.getAttribute('placeholder'),
      })),
      submitButtons: Array.from(document.querySelectorAll('button[type="submit"], input[type="submit"], button')).map(b => ({
        type: b.getAttribute('type'),
        text: b.textContent?.trim().slice(0, 50),
        class: b.className.slice(0, 50),
      })),
    };
  }, { username: USERNAME!, password: PASSWORD! });

  console.log(`  입력 필드: ID=${loginResult.idInputCount}, PW=${loginResult.pwInputCount}`);
  console.log(`  모든 input:`, JSON.stringify(loginResult.allInputs, null, 2));
  console.log(`  버튼:`, JSON.stringify(loginResult.submitButtons.slice(0, 5), null, 2));

  // 로그인 시도
  try {
    // ID 입력
    const idSelector = loginResult.idInputNames[0]
      ? `input[name="${loginResult.idInputNames[0].name}"]`
      : 'input[type="text"]';
    await page.fill(idSelector, USERNAME!, { timeout: 5000 });

    // PW 입력
    const pwSelector = loginResult.pwInputNames[0]
      ? `input[name="${loginResult.pwInputNames[0].name}"]`
      : 'input[type="password"]';
    await page.fill(pwSelector, PASSWORD!, { timeout: 5000 });

    console.log('  자격증명 입력 완료');
    await page.screenshot({ path: path.join(OUTPUT_DIR, '02-login-filled.png') });

    // 로그인 버튼 클릭
    const loginBtnSelector = loginResult.submitButtons.find(b =>
      b.text?.includes('로그인') || b.text?.includes('Login') || b.type === 'submit'
    );

    if (loginBtnSelector?.text) {
      await page.click(`text="${loginBtnSelector.text}"`, { timeout: 5000 });
    } else {
      await page.click('button[type="submit"], input[type="submit"]', { timeout: 5000 }).catch(
        () => page.click('button:has-text("로그인")', { timeout: 5000 })
      );
    }

    // 로그인 완료 대기
    await page.waitForNavigation({ timeout: 15000 }).catch(() => {});
    await page.waitForTimeout(3000);

    console.log(`  로그인 후 URL: ${page.url()}`);
    await page.screenshot({ path: path.join(OUTPUT_DIR, '03-after-login.png') });

    // 쿠키 확인
    const cookies = await context.cookies();
    const sessionCookies = cookies.filter(c =>
      c.name.includes('session') || c.name.includes('token') || c.name.includes('login') || c.name.includes('auth')
    );
    console.log(`  세션 쿠키: ${sessionCookies.length}개`);
    console.log(`  전체 쿠키: ${cookies.length}개`);
  } catch (err) {
    console.log(`  로그인 실패: ${err}`);
  }
}

async function phase2Catalog(page: Page) {
  console.log('\n=== Phase 2: 모바일 에디터 카탈로그 ===');

  await page.goto(REDPRINTING_URL, { waitUntil: 'networkidle', timeout: 30000 });
  console.log(`  URL: ${page.url()}`);
  await page.screenshot({ path: path.join(OUTPUT_DIR, '04-catalog.png') });

  // 상품 목록 확인
  const products = await page.evaluate(() => {
    const items = Array.from(document.querySelectorAll('a[href*="/product/item/"]'));
    return items.slice(0, 10).map(a => ({
      href: a.getAttribute('href'),
      text: a.textContent?.trim().slice(0, 60),
    }));
  });

  console.log(`  상품 ${products.length}개 발견`);
  for (const p of products.slice(0, 5)) {
    console.log(`    ${p.href} → ${p.text}`);
  }
}

async function phase3ProductDetail(page: Page, context: BrowserContext) {
  console.log('\n=== Phase 3: 상품 상세 → 편집기 진입 ===');

  // 명함 등 인쇄물 상품 선택 (편집기 사용 가능한 상품)
  // 물티슈 대신 스티커류 선택
  const productUrl = 'https://m.redprinting.co.kr/product/item/ST/STPAUNM';
  await page.goto(productUrl, { waitUntil: 'networkidle', timeout: 30000 });
  console.log(`  상품 상세: ${page.url()}`);
  await page.screenshot({ path: path.join(OUTPUT_DIR, '05-product-detail.png') });

  // 페이지의 모든 버튼/링크 분석
  const pageElements = await page.evaluate(() => {
    const buttons = Array.from(document.querySelectorAll('a, button'));
    return buttons
      .filter(el => {
        const text = el.textContent?.trim() || '';
        const href = el.getAttribute('href') || '';
        const onclick = el.getAttribute('onclick') || '';
        return text.includes('제작') || text.includes('편집') || text.includes('디자인') ||
               text.includes('시작') || text.includes('에디터') || text.includes('만들기') ||
               text.includes('주문') || text.includes('장바구니') ||
               href.includes('editor') || href.includes('design') ||
               onclick.includes('editor') || onclick.includes('openDesign') || onclick.includes('modal');
      })
      .map(el => ({
        tag: el.tagName,
        text: el.textContent?.trim().slice(0, 80),
        href: el.getAttribute('href'),
        onclick: el.getAttribute('onclick')?.slice(0, 200),
        class: el.className.slice(0, 100),
        id: el.id,
      }));
  });

  console.log(`  관련 버튼/링크:`, JSON.stringify(pageElements, null, 2));

  // 하단 고정 버튼 (주문하기/장바구니) 확인
  const bottomButtons = await page.evaluate(() => {
    const fixed = Array.from(document.querySelectorAll('[class*="fixed"], [class*="bottom"], [class*="sticky"]'));
    return fixed.flatMap(el =>
      Array.from(el.querySelectorAll('a, button')).map(b => ({
        text: b.textContent?.trim().slice(0, 50),
        href: b.getAttribute('href'),
        onclick: b.getAttribute('onclick')?.slice(0, 200),
        class: b.className.slice(0, 100),
      }))
    ).filter(b => b.text);
  });

  console.log(`  하단 버튼:`, JSON.stringify(bottomButtons, null, 2));

  // "디자인 제작하기" 또는 유사 버튼 클릭
  const designBtn = pageElements.find(el =>
    el.text?.includes('제작') || el.text?.includes('디자인') || el.text?.includes('에디터')
  ) || bottomButtons.find(b =>
    b.text?.includes('제작') || b.text?.includes('디자인') || b.text?.includes('주문')
  );

  if (designBtn) {
    console.log(`\n  클릭 시도: "${designBtn.text}"`);

    // 새 페이지 감지
    const [newPage] = await Promise.all([
      context.waitForEvent('page', { timeout: 15000 }).catch(() => null),
      (async () => {
        if (designBtn.onclick) {
          // onclick 함수 직접 실행 대신 요소 클릭
          await page.evaluate((btnText) => {
            const all = Array.from(document.querySelectorAll('a, button'));
            const target = all.find(el => el.textContent?.trim().includes(btnText!));
            if (target) (target as HTMLElement).click();
          }, designBtn.text?.slice(0, 20));
        } else if (designBtn.href && !designBtn.href.includes('javascript')) {
          await page.goto(`https://m.redprinting.co.kr${designBtn.href}`, { timeout: 15000 });
        }
      })(),
    ]);

    await page.waitForTimeout(5000);

    if (newPage) {
      console.log(`  새 페이지: ${newPage.url()}`);
      setupNetworkCapture(newPage);
      setupConsoleCapture(newPage);
      await newPage.waitForLoadState('networkidle', { timeout: 30000 }).catch(() => {});
      await newPage.screenshot({ path: path.join(OUTPUT_DIR, '06-new-page.png') });
      await analyzeEditorPage(newPage, '06-editor');
    } else {
      console.log(`  현재 URL: ${page.url()}`);
      await page.screenshot({ path: path.join(OUTPUT_DIR, '06-after-click.png') });

      // 모달 확인
      const modalCheck = await page.evaluate(() => {
        const modals = Array.from(document.querySelectorAll('[class*="modal"]:not([style*="display: none"]), [class*="popup"]:not([style*="display: none"])'));
        const visibleModals = modals.filter(m => {
          const style = getComputedStyle(m);
          return style.display !== 'none' && style.visibility !== 'hidden' && style.opacity !== '0';
        });
        return {
          count: visibleModals.length,
          content: visibleModals.map(m => ({
            class: m.className.slice(0, 100),
            html: m.innerHTML.slice(0, 500),
            links: Array.from(m.querySelectorAll('a')).map(a => ({
              href: a.getAttribute('href'),
              text: a.textContent?.trim().slice(0, 80),
              onclick: a.getAttribute('onclick')?.slice(0, 200),
            })),
          })),
          iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
            src: f.src,
            id: f.id,
          })),
        };
      });

      console.log(`  모달: ${modalCheck.count}개, iframe: ${modalCheck.iframes.length}개`);
      if (modalCheck.content.length > 0) {
        for (const modal of modalCheck.content) {
          console.log(`    모달 클래스: ${modal.class}`);
          console.log(`    링크:`, JSON.stringify(modal.links.slice(0, 5), null, 2));
        }
      }
      if (modalCheck.iframes.length > 0) {
        console.log(`  iframes:`, JSON.stringify(modalCheck.iframes, null, 2));
      }
    }
  }
}

async function phase4Editor(page: Page, context: BrowserContext) {
  console.log('\n=== Phase 4: Edicus 편집기 iframe 분석 ===');

  // 모든 페이지에서 iframe 검색
  const pages = context.pages();
  console.log(`  열린 페이지: ${pages.length}개`);

  for (let i = 0; i < pages.length; i++) {
    const p = pages[i];
    console.log(`\n  --- Page ${i + 1}: ${p.url().slice(0, 100)} ---`);

    const frameData = await p.evaluate(() => {
      const iframes = Array.from(document.querySelectorAll('iframe'));
      return {
        iframeCount: iframes.length,
        iframes: iframes.map(f => ({
          src: f.src,
          id: f.id,
          className: f.className,
          width: f.width,
          height: f.height,
          style: f.getAttribute('style')?.slice(0, 200),
        })),
        // edicus 관련 전역 변수 확인
        hasEdicusSDK: typeof (window as any).edicusSDK !== 'undefined',
        hasEdicus: typeof (window as any).edicus !== 'undefined',
        windowKeys: Object.keys(window).filter(k =>
          k.toLowerCase().includes('edicus') || k.toLowerCase().includes('editor') || k.toLowerCase().includes('sdk')
        ),
      };
    });

    console.log(`  iframe: ${frameData.iframeCount}개`);
    console.log(`  edicusSDK: ${frameData.hasEdicusSDK}`);
    console.log(`  edicus 관련 전역 변수: ${JSON.stringify(frameData.windowKeys)}`);

    for (const iframe of frameData.iframes) {
      console.log(`    iframe: ${iframe.src?.slice(0, 200)}`);
      if (iframe.src?.includes('edicus') || iframe.src?.includes('edicusbase') || iframe.src?.includes('firebaseapp')) {
        console.log('    *** Edicus 편집기 iframe 발견! ***');

        // URL 파라미터 분석
        try {
          const url = new URL(iframe.src);
          const params = Object.fromEntries(url.searchParams.entries());
          console.log('    파라미터:', JSON.stringify(params, null, 4));

          if (params.wait_private_css === 'true') {
            console.log('    *** wait_private_css=true → Custom CSS가 deferred로 전달됨 ***');
          }
        } catch {}

        // iframe 내부 접근 시도
        const frames = p.frames();
        for (const frame of frames) {
          if (frame.url().includes('edicus') || frame.url().includes('edicusbase')) {
            console.log(`    iframe URL: ${frame.url().slice(0, 200)}`);

            try {
              const innerCSS = await frame.evaluate(() => {
                const result: Record<string, unknown> = {};

                // CSS 변수 추출
                const cssVars: Record<string, string> = {};
                try {
                  const rootStyle = getComputedStyle(document.documentElement);
                  for (const sheet of Array.from(document.styleSheets)) {
                    try {
                      for (const rule of Array.from(sheet.cssRules || [])) {
                        if (rule instanceof CSSStyleRule && rule.selectorText === ':root') {
                          for (let i = 0; i < rule.style.length; i++) {
                            const name = rule.style[i];
                            if (name.startsWith('--')) {
                              cssVars[name] = rule.style.getPropertyValue(name).trim();
                            }
                          }
                        }
                      }
                    } catch { /* cross-origin stylesheet */ }
                  }
                } catch {}
                result.cssVariables = cssVars;

                // 모든 <style> 태그 내용
                const styleTags = Array.from(document.querySelectorAll('style'));
                result.styleTags = styleTags.map(s => s.textContent?.slice(0, 2000) || '');

                // 주요 DOM 요소 클래스
                const elements = Array.from(document.querySelectorAll('*'));
                const uniqueClasses = new Set<string>();
                elements.forEach(el => {
                  el.classList.forEach(c => uniqueClasses.add(c));
                });
                result.topClasses = Array.from(uniqueClasses).filter(c =>
                  c.includes('panel') || c.includes('toolbar') || c.includes('btn') ||
                  c.includes('editor') || c.includes('canvas') || c.includes('header') ||
                  c.includes('sidebar') || c.includes('menu') || c.includes('tab') ||
                  c.includes('tool') || c.includes('color') || c.includes('font') ||
                  c.includes('footer') || c.includes('bottom') || c.includes('top')
                ).sort();

                result.bodyClasses = document.body?.className || '';
                result.title = document.title;
                result.elementCount = elements.length;

                return result;
              }).catch(() => ({ error: 'cross-origin 접근 불가' }));

              console.log('    === iframe 내부 분석 결과 ===');
              console.log(JSON.stringify(innerCSS, null, 2));

              // 결과 저장
              fs.writeFileSync(
                path.join(OUTPUT_DIR, 'editor-iframe-css.json'),
                JSON.stringify(innerCSS, null, 2),
              );
            } catch (e) {
              console.log(`    iframe 내부 접근 실패: ${e}`);
            }
          }
        }
      }
    }
  }
}

async function phase5SaveResults() {
  console.log('\n=== Phase 5: 전체 결과 저장 ===');

  const report = {
    timestamp: new Date().toISOString(),
    apiCalls: apiCalls.filter(a => !a.url.includes('google') && !a.url.includes('analytics')),
    edicusRequests,
    consoleMessages: consoleMessages.filter(m =>
      m.includes('edicus') || m.includes('css') || m.includes('private') ||
      m.includes('param') || m.includes('sdk') || m.includes('editor')
    ),
    summary: {
      totalApiCalls: apiCalls.length,
      edicusApiCalls: edicusRequests.length,
      relevantConsoleLogs: consoleMessages.filter(m =>
        m.includes('edicus') || m.includes('css')
      ).length,
    },
  };

  const reportPath = path.join(OUTPUT_DIR, 'full-analysis-report.json');
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
  console.log(`  보고서 저장: ${reportPath}`);

  // 요약 출력
  console.log(`\n  === API 호출 요약 ===`);
  console.log(`  전체 API 호출: ${report.summary.totalApiCalls}개`);
  console.log(`  Edicus 관련: ${report.summary.edicusApiCalls}개`);

  console.log(`\n  === Edicus 관련 네트워크 요청 ===`);
  for (const req of edicusRequests.slice(0, 30)) {
    console.log(`  [${req.type}] ${req.url.slice(0, 150)}`);
    if (Object.keys(req.params).length > 0) {
      const importantParams = ['private_css', 'wait_private_css', 'mobile', 'lang', 'partner', 'ps_code', 'ui_style'];
      const filtered = Object.entries(req.params)
        .filter(([k]) => importantParams.includes(k) || k.includes('css'))
        .reduce((acc, [k, v]) => ({ ...acc, [k]: v }), {});
      if (Object.keys(filtered).length > 0) {
        console.log(`    중요 파라미터: ${JSON.stringify(filtered)}`);
      }
    }
  }

  console.log(`\n  === 관련 콘솔 로그 ===`);
  for (const msg of report.consoleMessages.slice(0, 20)) {
    console.log(`  ${msg}`);
  }
}

async function analyzeEditorPage(page: Page, label: string) {
  console.log(`\n  === ${label}: 편집기 페이지 분석 ===`);
  console.log(`  URL: ${page.url()}`);

  await page.waitForTimeout(5000);

  const data = await page.evaluate(() => {
    return {
      title: document.title,
      iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
        src: f.src,
        id: f.id,
        className: f.className,
      })),
      scripts: Array.from(document.querySelectorAll('script[src]'))
        .map(s => s.getAttribute('src'))
        .filter(s => s && (s.includes('edicus') || s.includes('sdk'))),
      edicusGlobals: Object.keys(window).filter(k =>
        k.toLowerCase().includes('edicus')
      ),
    };
  });

  console.log(`  제목: ${data.title}`);
  console.log(`  iframes: ${JSON.stringify(data.iframes, null, 2)}`);
  console.log(`  SDK 스크립트: ${JSON.stringify(data.scripts)}`);
  console.log(`  전역 변수: ${JSON.stringify(data.edicusGlobals)}`);

  await page.screenshot({ path: path.join(OUTPUT_DIR, `${label}.png`) });
}

main().catch(console.error);
