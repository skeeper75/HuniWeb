/**
 * 레드프린팅 모바일 편집기 분석 스크립트
 * Playwright로 m.redprinting.co.kr/landing/mobile_editor 페이지를 분석하여
 * Edicus SDK 초기화 파라미터, custom CSS, 네트워크 요청 등을 캡처합니다.
 */
import { chromium } from 'playwright';

const TARGET_URL = 'https://m.redprinting.co.kr/landing/mobile_editor';
const USERNAME = 'lojesus75';
const PASSWORD = 'redp0416!@';

async function analyze() {
  console.log('=== 레드프린팅 모바일 편집기 분석 시작 ===\n');

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
  });

  const page = await context.newPage();

  // 네트워크 요청 캡처
  const networkRequests = [];
  const edicusRequests = [];
  const cssRequests = [];

  page.on('request', (req) => {
    const url = req.url();
    if (url.includes('edicus') || url.includes('edicusbase')) {
      edicusRequests.push({ method: req.method(), url, headers: req.headers() });
    }
    if (url.endsWith('.css') || url.includes('private_css') || url.includes('custom')) {
      cssRequests.push({ url });
    }
    if (!url.includes('gtm') && !url.includes('google') && !url.includes('analytics') && !url.includes('.png') && !url.includes('.jpg') && !url.includes('.webp') && !url.includes('.svg') && !url.includes('.woff')) {
      networkRequests.push({ method: req.method(), url: url.substring(0, 200) });
    }
  });

  // Console 메시지 캡처
  const consoleLogs = [];
  page.on('console', (msg) => {
    const text = msg.text();
    if (text.includes('edicus') || text.includes('token') || text.includes('sdk') || text.includes('project') || text.includes('iframe')) {
      consoleLogs.push({ type: msg.type(), text: text.substring(0, 500) });
    }
  });

  // postMessage 캡처
  const postMessages = [];
  await page.addInitScript(() => {
    const origPostMessage = window.postMessage.bind(window);
    window.postMessage = function(data, ...args) {
      if (typeof data === 'object' || (typeof data === 'string' && data.includes('edicus'))) {
        window.__capturedMessages = window.__capturedMessages || [];
        window.__capturedMessages.push(JSON.parse(JSON.stringify(data)));
      }
      return origPostMessage(data, ...args);
    };

    window.addEventListener('message', (e) => {
      if (e.data && (typeof e.data === 'string' ? e.data.includes('edicus') : JSON.stringify(e.data).includes('edicus'))) {
        window.__receivedMessages = window.__receivedMessages || [];
        window.__receivedMessages.push(typeof e.data === 'object' ? JSON.parse(JSON.stringify(e.data)) : e.data);
      }
    });
  });

  try {
    // 1. 페이지 로드
    console.log('1. 페이지 로드 중...');
    await page.goto(TARGET_URL, { waitUntil: 'networkidle', timeout: 30000 });
    console.log(`   현재 URL: ${page.url()}\n`);

    // 2. 페이지 HTML 구조 분석
    console.log('2. 페이지 HTML 구조 분석...');
    const pageInfo = await page.evaluate(() => {
      return {
        title: document.title,
        url: window.location.href,
        iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
          src: f.src,
          id: f.id,
          className: f.className,
          width: f.width,
          height: f.height,
        })),
        scripts: Array.from(document.querySelectorAll('script[src]')).map(s => s.src).filter(s => !s.includes('gtm') && !s.includes('google')),
        links: Array.from(document.querySelectorAll('link[rel="stylesheet"]')).map(l => l.href),
        metas: Array.from(document.querySelectorAll('meta')).map(m => ({ name: m.name || m.getAttribute('property'), content: m.content })).filter(m => m.name),
        // Edicus 관련 요소
        edicusElements: Array.from(document.querySelectorAll('[id*="edicus"], [class*="edicus"], [data-edicus]')).map(e => ({
          tag: e.tagName,
          id: e.id,
          className: e.className,
          innerHTML: e.innerHTML.substring(0, 200),
        })),
        // hidden inputs
        hiddenInputs: Array.from(document.querySelectorAll('input[type="hidden"]')).map(i => ({
          name: i.name,
          id: i.id,
          value: i.value.substring(0, 100),
        })),
        // Nuxt 상태 (edicus 관련만)
        nuxtState: window.__NUXT__ ? JSON.stringify(window.__NUXT__).substring(0, 2000) : 'N/A',
      };
    });
    console.log(`   제목: ${pageInfo.title}`);
    console.log(`   iframes: ${JSON.stringify(pageInfo.iframes, null, 2)}`);
    console.log(`   외부 스크립트: ${JSON.stringify(pageInfo.scripts, null, 2)}`);
    console.log(`   스타일시트: ${JSON.stringify(pageInfo.links, null, 2)}`);
    console.log(`   Edicus 요소: ${JSON.stringify(pageInfo.edicusElements, null, 2)}`);
    console.log(`   Hidden 입력: ${JSON.stringify(pageInfo.hiddenInputs, null, 2)}`);
    console.log();

    // 3. 로그인 필요 여부 확인
    console.log('3. 로그인 상태 확인...');
    const needsLogin = await page.evaluate(() => {
      const loginForm = document.querySelector('form[action*="login"], input[type="password"], .login-form, [class*="login"]');
      const loginLink = document.querySelector('a[href*="login"]');
      return {
        hasLoginForm: !!loginForm,
        hasLoginLink: !!loginLink,
        loginLinkHref: loginLink?.href || null,
        bodyText: document.body?.innerText?.substring(0, 500) || '',
      };
    });
    console.log(`   로그인 필요: ${needsLogin.hasLoginForm || needsLogin.hasLoginLink}`);
    console.log(`   로그인 링크: ${needsLogin.loginLinkHref}`);
    console.log(`   페이지 텍스트: ${needsLogin.bodyText.substring(0, 300)}\n`);

    // 4. 로그인 시도 (필요한 경우)
    if (needsLogin.hasLoginForm || needsLogin.hasLoginLink) {
      console.log('4. 로그인 시도...');
      if (needsLogin.loginLinkHref) {
        await page.goto(needsLogin.loginLinkHref, { waitUntil: 'networkidle', timeout: 15000 });
      }
      // 로그인 폼 찾기
      const loginInputs = await page.evaluate(() => {
        const inputs = Array.from(document.querySelectorAll('input'));
        return inputs.map(i => ({ type: i.type, name: i.name, id: i.id, placeholder: i.placeholder }));
      });
      console.log(`   입력 필드: ${JSON.stringify(loginInputs, null, 2)}`);

      // ID/PW 입력
      try {
        const idInput = await page.$('input[name*="id"], input[name*="user"], input[name*="login"], input[type="text"]:first-of-type');
        const pwInput = await page.$('input[type="password"]');
        if (idInput && pwInput) {
          await idInput.fill(USERNAME);
          await pwInput.fill(PASSWORD);
          const submitBtn = await page.$('button[type="submit"], input[type="submit"], .btn-login, button:has-text("로그인")');
          if (submitBtn) {
            await submitBtn.click();
            await page.waitForNavigation({ waitUntil: 'networkidle', timeout: 10000 }).catch(() => {});
            console.log(`   로그인 후 URL: ${page.url()}`);
          }
        }
      } catch (e) {
        console.log(`   로그인 실패: ${e.message}`);
      }

      // 다시 편집기 페이지로
      await page.goto(TARGET_URL, { waitUntil: 'networkidle', timeout: 30000 });
      console.log(`   편집기 페이지 재로드: ${page.url()}\n`);
    }

    // 5. 편집기 로드 분석
    console.log('5. 편집기 환경 분석...');
    await page.waitForTimeout(3000); // 동적 로딩 대기

    const editorInfo = await page.evaluate(() => {
      return {
        // edicusSDK 전역 객체
        hasEdicusSDK: typeof window.edicusSDK !== 'undefined',
        edicusSDKKeys: typeof window.edicusSDK !== 'undefined' ? Object.keys(window.edicusSDK) : [],
        // editor 전역 객체
        hasEditor: typeof window.editor !== 'undefined',
        // 모든 전역 변수 중 edicus 관련
        edicusGlobals: Object.keys(window).filter(k =>
          k.toLowerCase().includes('edicus') ||
          k.toLowerCase().includes('editor') ||
          k.toLowerCase().includes('token') ||
          k.toLowerCase().includes('ps_code') ||
          k.toLowerCase().includes('template')
        ),
        // iframe 분석 (편집기)
        iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
          src: f.src,
          id: f.id,
          name: f.name,
          width: f.offsetWidth,
          height: f.offsetHeight,
          srcdoc: f.srcdoc?.substring(0, 200),
        })),
        // postMessage 캡처
        sentMessages: window.__capturedMessages || [],
        receivedMessages: window.__receivedMessages || [],
        // CSS 링크
        allStyles: Array.from(document.querySelectorAll('style, link[rel="stylesheet"]')).map(s => {
          if (s.tagName === 'LINK') return { type: 'link', href: s.href };
          const text = s.textContent || '';
          if (text.includes('edicus') || text.includes('private') || text.includes('custom')) {
            return { type: 'inline-style', content: text.substring(0, 500) };
          }
          return null;
        }).filter(Boolean),
      };
    });
    console.log(`   edicusSDK 존재: ${editorInfo.hasEdicusSDK}`);
    console.log(`   edicusSDK keys: ${JSON.stringify(editorInfo.edicusSDKKeys)}`);
    console.log(`   editor 존재: ${editorInfo.hasEditor}`);
    console.log(`   Edicus 전역변수: ${JSON.stringify(editorInfo.edicusGlobals)}`);
    console.log(`   iframes: ${JSON.stringify(editorInfo.iframes, null, 2)}`);
    console.log(`   postMessage 전송: ${JSON.stringify(editorInfo.sentMessages, null, 2)}`);
    console.log(`   postMessage 수신: ${JSON.stringify(editorInfo.receivedMessages, null, 2)}`);
    console.log();

    // 6. 상품 목록 및 편집기 진입점 분석
    console.log('6. 상품 목록 및 편집기 진입점 분석...');
    const productInfo = await page.evaluate(() => {
      // 상품 링크 패턴 찾기
      const links = Array.from(document.querySelectorAll('a[href]'));
      const productLinks = links
        .filter(l => l.href.includes('/product/') || l.href.includes('/editor') || l.href.includes('/design') || l.href.includes('ps_code'))
        .map(l => ({ text: l.textContent?.trim().substring(0, 50), href: l.href }));

      // 버튼/클릭 요소 중 편집기 관련
      const editorButtons = Array.from(document.querySelectorAll('button, [onclick], [data-action]'))
        .filter(b => {
          const text = (b.textContent || '') + (b.getAttribute('onclick') || '') + (b.getAttribute('data-action') || '');
          return text.includes('편집') || text.includes('만들기') || text.includes('디자인') || text.includes('주문') || text.includes('editor');
        })
        .map(b => ({
          tag: b.tagName,
          text: b.textContent?.trim().substring(0, 50),
          onclick: b.getAttribute('onclick')?.substring(0, 200),
          dataAction: b.getAttribute('data-action'),
          href: b.getAttribute('href'),
        }));

      return { productLinks: productLinks.slice(0, 20), editorButtons };
    });
    console.log(`   상품 링크: ${JSON.stringify(productInfo.productLinks, null, 2)}`);
    console.log(`   편집기 버튼: ${JSON.stringify(productInfo.editorButtons, null, 2)}`);
    console.log();

    // 7. 네트워크 요청 요약
    console.log('7. 네트워크 요청 요약...');
    console.log(`   총 요청: ${networkRequests.length}`);
    console.log(`   Edicus 관련 요청: ${edicusRequests.length}`);
    edicusRequests.forEach(r => console.log(`     ${r.method} ${r.url}`));
    console.log(`   CSS 요청: ${cssRequests.length}`);
    cssRequests.forEach(r => console.log(`     ${r.url}`));
    console.log();

    // 8. 콘솔 로그
    console.log('8. Edicus 관련 콘솔 로그...');
    consoleLogs.forEach(l => console.log(`   [${l.type}] ${l.text}`));
    console.log();

    // 9. 스크린샷
    await page.screenshot({ path: '/tmp/redprinting-mobile-editor.png', fullPage: true });
    console.log('9. 스크린샷 저장: /tmp/redprinting-mobile-editor.png\n');

    // 10. 상품 클릭하여 편집기 진입 시도
    console.log('10. 첫 번째 상품 클릭하여 편집기 진입 시도...');
    const firstProduct = await page.$('a[href*="/product/"], .product-item, .item-card');
    if (firstProduct) {
      await firstProduct.click();
      await page.waitForTimeout(3000);
      console.log(`    현재 URL: ${page.url()}`);

      // 편집기 iframe 확인
      const afterClickInfo = await page.evaluate(() => {
        return {
          iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
            src: f.src,
            id: f.id,
          })),
          hasEdicusSDK: typeof window.edicusSDK !== 'undefined',
          editorGlobals: Object.keys(window).filter(k => k.toLowerCase().includes('edicus')),
        };
      });
      console.log(`    iframes: ${JSON.stringify(afterClickInfo.iframes, null, 2)}`);
      console.log(`    edicusSDK: ${afterClickInfo.hasEdicusSDK}`);
      console.log(`    edicus 전역: ${JSON.stringify(afterClickInfo.editorGlobals)}`);

      await page.screenshot({ path: '/tmp/redprinting-product-detail.png', fullPage: true });
      console.log('    스크린샷: /tmp/redprinting-product-detail.png');
    } else {
      console.log('    상품 요소를 찾을 수 없습니다.');
    }

  } catch (error) {
    console.error(`오류: ${error.message}`);
  } finally {
    await browser.close();
  }

  console.log('\n=== 분석 완료 ===');
}

analyze().catch(console.error);
