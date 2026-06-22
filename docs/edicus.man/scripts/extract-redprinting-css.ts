/**
 * 레드프린팅 Edicus 편집기 Custom CSS 추출 스크립트
 *
 * Playwright로 m.redprinting.co.kr 모바일 에디터에 접근하여
 * Edicus iframe에 전달되는 private_css와 내부 CSS를 추출합니다.
 *
 * 실행: npx playwright test scripts/extract-redprinting-css.ts --headed
 */
import { chromium } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

const TARGET_URL = 'https://m.redprinting.co.kr/landing/mobile_editor';
const OUTPUT_DIR = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-CSS-001');

async function extractRedprintingCSS() {
  console.log('=== 레드프린팅 Edicus Custom CSS 추출 시작 ===\n');

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
    viewport: { width: 390, height: 844 },
    isMobile: true,
  });

  // 네트워크 요청에서 CSS 관련 정보 캡처
  const capturedCSS: string[] = [];
  const capturedRequests: { url: string; type: string }[] = [];
  const postMessages: string[] = [];

  const page = await context.newPage();

  // 모든 네트워크 요청 모니터링
  page.on('request', (req) => {
    const url = req.url();
    if (url.includes('css') || url.includes('style') || url.includes('edicus') || url.includes('private_css')) {
      capturedRequests.push({ url, type: req.resourceType() });
    }
  });

  // 콘솔 로그 캡처 (SDK가 detect_private_css를 로그함)
  page.on('console', (msg) => {
    const text = msg.text();
    if (text.includes('css') || text.includes('CSS') || text.includes('private') || text.includes('edicus') || text.includes('style')) {
      capturedCSS.push(`[console] ${text}`);
    }
  });

  try {
    // Step 1: 모바일 에디터 랜딩 페이지 접속
    console.log('Step 1: 레드프린팅 모바일 에디터 페이지 접속...');
    await page.goto(TARGET_URL, { waitUntil: 'networkidle', timeout: 30000 });
    console.log(`  현재 URL: ${page.url()}`);

    // 페이지 스크린샷
    await page.screenshot({ path: path.join(OUTPUT_DIR, 'step1-landing.png'), fullPage: false });

    // Step 2: 페이지 HTML에서 edicus/CSS 관련 정보 추출
    console.log('\nStep 2: 페이지 소스에서 CSS/Edicus 관련 정보 추출...');

    const pageData = await page.evaluate(() => {
      const result: Record<string, unknown> = {};

      // CSS 변수 추출
      const rootStyles = getComputedStyle(document.documentElement);
      const cssVars: Record<string, string> = {};
      for (const prop of Array.from(document.styleSheets)) {
        try {
          for (const rule of Array.from(prop.cssRules || [])) {
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
      result.cssVariables = cssVars;

      // 모든 style 태그 내용
      const styleTags = Array.from(document.querySelectorAll('style'));
      result.inlineStyleCount = styleTags.length;

      // edicus 관련 스크립트 찾기
      const scripts = Array.from(document.querySelectorAll('script[src]'));
      result.scriptSrcs = scripts.map(s => s.getAttribute('src')).filter(s =>
        s && (s.includes('edicus') || s.includes('editor') || s.includes('sdk'))
      );

      // iframe 찾기
      const iframes = Array.from(document.querySelectorAll('iframe'));
      result.iframes = iframes.map(f => ({
        src: f.src,
        id: f.id,
        className: f.className,
        width: f.width,
        height: f.height,
      }));

      // window.__NUXT__ 에서 edicus 관련 데이터 찾기
      const nuxt = (window as any).__NUXT__;
      if (nuxt) {
        const nuxtStr = JSON.stringify(nuxt);
        const edicusMatches = nuxtStr.match(/edicus[^"]{0,200}/gi);
        const cssMatches = nuxtStr.match(/private_css[^"]{0,200}/gi);
        const themeMatches = nuxtStr.match(/theme[_-]color[^"]{0,200}/gi);
        result.nuxtEdicusRefs = edicusMatches?.slice(0, 10) || [];
        result.nuxtCssRefs = cssMatches?.slice(0, 10) || [];
        result.nuxtThemeRefs = themeMatches?.slice(0, 10) || [];
      }

      // 링크된 CSS 파일
      const linkTags = Array.from(document.querySelectorAll('link[rel="stylesheet"]'));
      result.linkedCSS = linkTags.map(l => l.getAttribute('href'));

      return result;
    });

    console.log('  CSS 변수:', JSON.stringify(pageData.cssVariables, null, 2));
    console.log('  인라인 스타일 수:', pageData.inlineStyleCount);
    console.log('  Edicus 스크립트:', pageData.scriptSrcs);
    console.log('  iframes:', JSON.stringify(pageData.iframes, null, 2));
    console.log('  Nuxt Edicus 참조:', pageData.nuxtEdicusRefs);
    console.log('  Nuxt CSS 참조:', pageData.nuxtCssRefs);

    // Step 3: 상품 클릭하여 편집기 열기 시도
    console.log('\nStep 3: 상품 클릭하여 편집기 접근 시도...');

    // 상품 카드/링크 찾기
    const productLinks = await page.evaluate(() => {
      const links = Array.from(document.querySelectorAll('a[href*="editor"], a[href*="edit"], a[href*="design"], a[href*="template"]'));
      const buttons = Array.from(document.querySelectorAll('button, [role="button"], .product-card, .item'));
      const allClickable = Array.from(document.querySelectorAll('[onclick], a[href]'));

      return {
        editorLinks: links.map(a => ({ href: a.getAttribute('href'), text: a.textContent?.trim().slice(0, 50) })),
        buttonCount: buttons.length,
        clickableWithEditor: allClickable
          .filter(el => {
            const text = (el.getAttribute('href') || '') + (el.getAttribute('onclick') || '');
            return text.includes('editor') || text.includes('edit') || text.includes('design');
          })
          .map(el => ({ tag: el.tagName, href: el.getAttribute('href'), text: el.textContent?.trim().slice(0, 50) }))
          .slice(0, 10),
      };
    });

    console.log('  편집기 링크:', JSON.stringify(productLinks.editorLinks.slice(0, 5), null, 2));
    console.log('  클릭 가능한 편집기 요소:', JSON.stringify(productLinks.clickableWithEditor, null, 2));

    // 첫 번째 상품 카드 클릭 시도
    const firstProduct = await page.$('.product-card, .item-card, [class*="product"], [class*="item"]');
    if (firstProduct) {
      console.log('  상품 카드 발견, 클릭 시도...');

      // 새 페이지 열림 대기
      const [newPage] = await Promise.all([
        context.waitForEvent('page', { timeout: 10000 }).catch(() => null),
        firstProduct.click().catch(() => null),
      ]);

      if (newPage) {
        await newPage.waitForLoadState('networkidle', { timeout: 15000 }).catch(() => {});
        console.log(`  새 페이지 URL: ${newPage.url()}`);
        await newPage.screenshot({ path: path.join(OUTPUT_DIR, 'step3-editor.png'), fullPage: false });
      }
    }

    // Step 4: 네비게이션으로 직접 편집기 URL 패턴 시도
    console.log('\nStep 4: 편집기 URL 패턴 직접 접근...');

    // 레드프린팅 편집기 URL 패턴들
    const editorUrls = [
      'https://m.redprinting.co.kr/editor',
      'https://m.redprinting.co.kr/design',
      'https://m.redprinting.co.kr/mobile/editor',
    ];

    for (const url of editorUrls) {
      try {
        const resp = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 10000 });
        if (resp && resp.status() < 400) {
          console.log(`  ${url} → ${resp.status()} (${page.url()})`);

          // 이 페이지에서 iframe/edicus 확인
          const editorCheck = await page.evaluate(() => {
            const iframes = Array.from(document.querySelectorAll('iframe'));
            return {
              url: window.location.href,
              iframes: iframes.map(f => ({ src: f.src, id: f.id })),
              hasEdicus: !!document.querySelector('[class*="edicus"], [id*="edicus"]'),
            };
          });

          if (editorCheck.iframes.length > 0 || editorCheck.hasEdicus) {
            console.log('  편집기 발견!', JSON.stringify(editorCheck, null, 2));
            await page.screenshot({ path: path.join(OUTPUT_DIR, 'step4-editor-found.png'), fullPage: false });
          }
        }
      } catch (e) {
        console.log(`  ${url} → 접근 실패`);
      }
    }

    // Step 5: 전체 결과 저장
    console.log('\nStep 5: 결과 저장...');

    const report = {
      timestamp: new Date().toISOString(),
      targetUrl: TARGET_URL,
      pageData,
      productLinks,
      capturedRequests,
      capturedCSS,
      postMessages,
    };

    const reportPath = path.join(OUTPUT_DIR, 'redprinting-css-analysis.json');
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
    console.log(`  결과 저장: ${reportPath}`);

  } catch (error) {
    console.error('오류 발생:', error);
  } finally {
    await browser.close();
    console.log('\n=== 분석 완료 ===');
  }
}

extractRedprintingCSS().catch(console.error);
