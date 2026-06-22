/**
 * 레드프린팅 편집기 분석 v3 - 로그인 수정 + 주문 플로우 추적
 */
import { chromium } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

const envContent = fs.readFileSync(path.join(__dirname, '..', '.env.local'), 'utf-8');
const env: Record<string, string> = {};
for (const line of envContent.split('\n')) {
  const t = line.trim();
  if (!t || t.startsWith('#')) continue;
  const i = t.indexOf('=');
  if (i > 0) env[t.slice(0, i)] = t.slice(i + 1);
}

const OUT = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-CSS-001', 'analysis');
fs.mkdirSync(OUT, { recursive: true });

const allRequests: { method: string; url: string; type: string }[] = [];

async function main() {
  console.log('=== 레드프린팅 분석 v3 (로그인 + 편집기 추적) ===\n');

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox'],
  });

  const ctx = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15',
    viewport: { width: 390, height: 844 },
    isMobile: true,
  });

  const page = await ctx.newPage();

  // 네트워크 캡처
  page.on('request', (r) => {
    const url = r.url();
    if (url.includes('edicus') || url.includes('edicusbase') || url.includes('firebaseapp') ||
        url.includes('widget') || url.includes('editor') || url.includes('css') && url.includes('api')) {
      allRequests.push({ method: r.method(), url, type: r.resourceType() });
    }
  });

  try {
    // === Phase 1: 로그인 ===
    console.log('Phase 1: 로그인...');
    await page.goto('https://m.redprinting.co.kr/member/login', { waitUntil: 'networkidle', timeout: 30000 });

    // #mb_id 셀렉터 사용 (name이 비어있으므로 id로 접근)
    await page.fill('#mb_id', env.REDPRINTING_USERNAME);
    await page.fill('#password', env.REDPRINTING_PASSWORD);
    await page.screenshot({ path: path.join(OUT, 'v3-01-login-filled.png') });

    // 로그인 버튼 클릭
    await page.click('button:has-text("로그인")');
    await page.waitForTimeout(3000);
    await page.waitForLoadState('networkidle').catch(() => {});

    console.log(`  로그인 후 URL: ${page.url()}`);
    await page.screenshot({ path: path.join(OUT, 'v3-02-after-login.png') });

    // 로그인 확인: 마이페이지 접근 또는 쿠키 확인
    const isLoggedIn = await page.evaluate(() => {
      // 로그인 상태 확인 (마이페이지 링크 또는 로그아웃 버튼 존재)
      const logoutLink = document.querySelector('a[href*="logout"]');
      const mypageLink = document.querySelector('a[href*="mypage"]');
      const loginLink = document.querySelector('.loginBtnBox, .login-btn'); // 로그인 버튼이 아직 보이면 미로그인
      return {
        hasLogout: !!logoutLink,
        hasMypage: !!mypageLink,
        pageTitle: document.title,
        url: window.location.href,
      };
    });
    console.log(`  로그인 상태:`, JSON.stringify(isLoggedIn));

    // === Phase 2: 상품 페이지 → 주문하기 ===
    console.log('\nPhase 2: 상품 상세 → 주문하기 버튼...');

    // UV 네임스티커 상품 접속
    await page.goto('https://m.redprinting.co.kr/product/item/ST/STPAUNM', {
      waitUntil: 'networkidle', timeout: 30000,
    });

    await page.screenshot({ path: path.join(OUT, 'v3-03-product.png') });

    // "주문하기" 버튼 클릭
    console.log('  "주문하기" 버튼 클릭...');
    const orderBtnExists = await page.$('button:has-text("주문하기")');
    if (orderBtnExists) {
      // 새 페이지 열림 감지
      const [newPage] = await Promise.all([
        ctx.waitForEvent('page', { timeout: 15000 }).catch(() => null),
        page.click('button:has-text("주문하기")'),
      ]);

      await page.waitForTimeout(5000);

      // 현재 페이지 또는 새 페이지 확인
      const targetPage = newPage || page;
      console.log(`  이동 URL: ${targetPage.url()}`);
      await targetPage.screenshot({ path: path.join(OUT, 'v3-04-after-order-btn.png') });

      // 페이지 분석
      const pageAnalysis = await targetPage.evaluate(() => {
        return {
          url: window.location.href,
          title: document.title,
          iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
            src: f.src,
            id: f.id,
            class: f.className,
          })),
          allLinks: Array.from(document.querySelectorAll('a, button')).filter(el => {
            const t = el.textContent?.trim() || '';
            return t.includes('편집') || t.includes('에디터') || t.includes('디자인') || t.includes('제작');
          }).map(el => ({
            tag: el.tagName,
            text: el.textContent?.trim().slice(0, 80),
            href: el.getAttribute('href'),
            onclick: el.getAttribute('onclick')?.slice(0, 200),
          })),
          // 전역 SDK 변수
          globals: Object.keys(window).filter(k =>
            k.toLowerCase().includes('edicus') || k.toLowerCase().includes('widget') ||
            k.toLowerCase().includes('sdk') || k.toLowerCase().includes('editor')
          ),
          // 모든 script src
          scripts: Array.from(document.querySelectorAll('script[src]'))
            .map(s => s.getAttribute('src'))
            .filter(s => s && (s.includes('edicus') || s.includes('widget') || s.includes('sdk') || s.includes('editor'))),
        };
      });

      console.log(`  iframes: ${pageAnalysis.iframes.length}개`);
      console.log(`  편집기 관련 링크: ${JSON.stringify(pageAnalysis.allLinks, null, 2)}`);
      console.log(`  전역 SDK 변수: ${JSON.stringify(pageAnalysis.globals)}`);
      console.log(`  SDK 스크립트: ${JSON.stringify(pageAnalysis.scripts)}`);

      // iframe이 있으면 분석
      for (const iframe of pageAnalysis.iframes) {
        console.log(`\n  === iframe 분석: ${iframe.src?.slice(0, 200)} ===`);
        if (iframe.src?.includes('edicus') || iframe.src?.includes('edicusbase') || iframe.src?.includes('firebaseapp')) {
          console.log('  *** Edicus iframe 발견! ***');
          try {
            const url = new URL(iframe.src);
            console.log('  URL 파라미터:', JSON.stringify(Object.fromEntries(url.searchParams.entries()), null, 2));
          } catch {}
        }
      }

      // RedWidgetSDK가 있으면 분석
      if (pageAnalysis.globals.includes('RedWidgetSDK') || pageAnalysis.globals.includes('redWidgetSDK')) {
        console.log('\n  === RedWidgetSDK 분석 ===');
        const widgetInfo = await targetPage.evaluate(() => {
          const sdk = (window as any).RedWidgetSDK || (window as any).redWidgetSDK;
          if (!sdk) return { found: false };
          return {
            found: true,
            type: typeof sdk,
            keys: typeof sdk === 'object' ? Object.keys(sdk).slice(0, 30) : [],
            methods: typeof sdk === 'object' ? Object.keys(sdk).filter(k => typeof sdk[k] === 'function') : [],
          };
        });
        console.log(`  RedWidgetSDK:`, JSON.stringify(widgetInfo, null, 2));
      }

      // 모든 페이지의 프레임 분석
      const frames = targetPage.frames();
      console.log(`\n  전체 프레임 수: ${frames.length}`);
      for (const frame of frames) {
        const fUrl = frame.url();
        if (fUrl !== 'about:blank' && fUrl !== targetPage.url()) {
          console.log(`  프레임: ${fUrl.slice(0, 200)}`);

          if (fUrl.includes('edicus') || fUrl.includes('edicusbase') || fUrl.includes('firebaseapp')) {
            console.log('  *** Edicus 프레임 발견! CSS 추출 시도... ***');
            try {
              const cssData = await frame.evaluate(() => {
                const cssVars: Record<string, string> = {};
                for (const sheet of Array.from(document.styleSheets)) {
                  try {
                    for (const rule of Array.from(sheet.cssRules || [])) {
                      if (rule instanceof CSSStyleRule && rule.selectorText === ':root') {
                        for (let i = 0; i < rule.style.length; i++) {
                          const n = rule.style[i];
                          if (n.startsWith('--')) cssVars[n] = rule.style.getPropertyValue(n).trim();
                        }
                      }
                    }
                  } catch {}
                }

                const styleTags = Array.from(document.querySelectorAll('style'));
                const allClasses = new Set<string>();
                document.querySelectorAll('*').forEach(el => el.classList.forEach(c => allClasses.add(c)));

                return {
                  cssVariables: cssVars,
                  styleTagCount: styleTags.length,
                  styleContent: styleTags.map(s => s.textContent?.slice(0, 3000) || ''),
                  editorClasses: Array.from(allClasses).filter(c =>
                    /panel|toolbar|btn|editor|canvas|header|sidebar|menu|tab|tool|color|font|footer|bottom|top|action|page|layer|template/i.test(c)
                  ).sort(),
                  elementCount: document.querySelectorAll('*').length,
                  bodyClass: document.body?.className,
                  title: document.title,
                };
              });

              console.log('\n  ====== Edicus 편집기 내부 CSS 분석 ======');
              console.log(`  요소 수: ${cssData.elementCount}`);
              console.log(`  body 클래스: ${cssData.bodyClass}`);
              console.log(`  제목: ${cssData.title}`);
              console.log(`  CSS 변수:`, JSON.stringify(cssData.cssVariables, null, 2));
              console.log(`  style 태그: ${cssData.styleTagCount}개`);
              console.log(`  편집기 클래스:`, JSON.stringify(cssData.editorClasses, null, 2));

              if (cssData.styleContent.length > 0) {
                console.log('\n  === style 태그 내용 (첫 3개) ===');
                for (const content of cssData.styleContent.slice(0, 3)) {
                  console.log(content.slice(0, 1000));
                  console.log('---');
                }
              }

              // 결과 저장
              fs.writeFileSync(
                path.join(OUT, 'edicus-iframe-css-extracted.json'),
                JSON.stringify(cssData, null, 2),
              );
              console.log('\n  결과 저장: edicus-iframe-css-extracted.json');
            } catch (e) {
              console.log(`  CSS 추출 실패 (cross-origin): ${e}`);
            }
          }
        }
      }
    } else {
      console.log('  "주문하기" 버튼 없음');
    }

    // === Phase 3: 네트워크 요청 분석 ===
    console.log('\n=== Phase 3: 네트워크 요청 분석 ===');
    console.log(`  캡처된 요청: ${allRequests.length}개`);
    for (const req of allRequests) {
      console.log(`  [${req.method}] ${req.url.slice(0, 200)}`);
    }

  } catch (error) {
    console.error('오류:', error);
  } finally {
    // 전체 결과 저장
    fs.writeFileSync(
      path.join(OUT, 'v3-full-report.json'),
      JSON.stringify({ allRequests, timestamp: new Date().toISOString() }, null, 2),
    );
    await browser.close();
    console.log('\n=== 완료 ===');
  }
}

main().catch(console.error);
