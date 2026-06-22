/**
 * 레드프린팅 모바일 편집기 심층 분석
 * 상품 상세 → 편집기 진입 흐름에서 Edicus SDK 파라미터를 캡처합니다.
 */
import { chromium } from 'playwright';

const USERNAME = 'lojesus75';
const PASSWORD = 'redp0416!@';
// UV 네임스티커 - 모바일 주문 가능한 템플릿 상품
const PRODUCT_URL = 'https://m.redprinting.co.kr/product/item/ST/STPAUNM';

async function analyze() {
  console.log('=== 레드프린팅 편집기 심층 분석 ===\n');

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
  });

  const page = await context.newPage();

  // Edicus 관련 네트워크 요청 캡처
  const allRequests = [];
  page.on('request', (req) => {
    const url = req.url();
    allRequests.push({
      method: req.method(),
      url,
      postData: req.postData()?.substring(0, 500),
      headers: Object.fromEntries(
        Object.entries(req.headers()).filter(([k]) =>
          k.includes('edicus') || k.includes('token') || k.includes('auth') || k.includes('content-type')
        )
      ),
    });
  });

  // 응답 캡처 (edicus, token, css 관련)
  const importantResponses = [];
  page.on('response', async (res) => {
    const url = res.url();
    if (
      url.includes('edicus') || url.includes('token') ||
      url.includes('private_css') || url.includes('custom_css') ||
      (url.includes('edicusbase') && !url.includes('.png') && !url.includes('.jpg'))
    ) {
      let body = '';
      try { body = await res.text(); } catch {}
      importantResponses.push({
        url,
        status: res.status(),
        body: body.substring(0, 2000),
      });
    }
  });

  try {
    // 1. 로그인
    console.log('1. 로그인 중...');
    await page.goto('https://m.redprinting.co.kr/member/login', { waitUntil: 'networkidle', timeout: 30000 });
    await page.fill('#mb_id', USERNAME);
    await page.fill('#password', PASSWORD);
    await page.click('button:has-text("로그인"), .btn-login, [type="submit"]');
    await page.waitForTimeout(3000);
    console.log(`   로그인 후 URL: ${page.url()}\n`);

    // 2. 상품 상세 페이지 이동
    console.log('2. 상품 상세 이동...');
    await page.goto(PRODUCT_URL, { waitUntil: 'networkidle', timeout: 30000 });
    console.log(`   URL: ${page.url()}`);

    // 상세 페이지 분석
    const productDetail = await page.evaluate(() => {
      return {
        title: document.title,
        // 모든 버튼/링크 텍스트
        buttons: Array.from(document.querySelectorAll('button, a.btn, [class*="btn"], [role="button"]'))
          .map(b => ({
            text: b.textContent?.trim().substring(0, 50),
            href: b.getAttribute('href'),
            onclick: b.getAttribute('onclick')?.substring(0, 200),
            class: b.className?.substring(0, 100),
          }))
          .filter(b => b.text),
        // hidden inputs
        hiddenInputs: Array.from(document.querySelectorAll('input[type="hidden"]'))
          .map(i => ({ name: i.name, id: i.id, value: i.value.substring(0, 200) })),
        // data 속성
        dataElements: Array.from(document.querySelectorAll('[data-ps-code], [data-template], [data-edicus], [data-item]'))
          .map(e => ({
            tag: e.tagName,
            dataset: JSON.stringify(e.dataset).substring(0, 300),
          })),
        // 스크립트에서 edicus 관련 코드 추출
        inlineScripts: Array.from(document.querySelectorAll('script:not([src])'))
          .map(s => s.textContent)
          .filter(t => t.includes('edicus') || t.includes('create_project') || t.includes('open_project') || t.includes('ps_code') || t.includes('template_uri') || t.includes('private_css'))
          .map(t => t.substring(0, 2000)),
        // 전역 변수
        globals: Object.keys(window).filter(k =>
          k.includes('edicus') || k.includes('ps_code') || k.includes('template') ||
          k.includes('product') || k.includes('item') || k.includes('design')
        ),
        bodyText: document.body?.innerText?.substring(0, 1000),
      };
    });
    console.log(`   제목: ${productDetail.title}`);
    console.log(`   버튼: ${JSON.stringify(productDetail.buttons.slice(0, 15), null, 2)}`);
    console.log(`   Hidden: ${JSON.stringify(productDetail.hiddenInputs, null, 2)}`);
    console.log(`   Data 속성: ${JSON.stringify(productDetail.dataElements, null, 2)}`);
    console.log(`   Edicus 인라인 스크립트: ${productDetail.inlineScripts.length}개`);
    productDetail.inlineScripts.forEach((s, i) => console.log(`   --- 스크립트 ${i}: ${s.substring(0, 500)}`));
    console.log(`   전역변수: ${JSON.stringify(productDetail.globals)}`);
    console.log();

    await page.screenshot({ path: '/tmp/redprinting-product.png', fullPage: true });

    // 3. "만들기" 또는 "주문하기" 버튼 찾기 및 클릭
    console.log('3. 편집기 진입 버튼 찾기...');
    const editorButton = await page.$('button:has-text("만들기"), a:has-text("만들기"), button:has-text("디자인"), a:has-text("디자인"), button:has-text("주문"), a:has-text("주문하기"), button:has-text("시작"), .btn-order, .btn-design');

    if (editorButton) {
      const btnText = await editorButton.textContent();
      console.log(`   버튼 발견: "${btnText.trim()}"`);
      await editorButton.click();
      await page.waitForTimeout(5000); // 편집기 로딩 대기

      console.log(`   클릭 후 URL: ${page.url()}`);

      // 편집기 iframe 및 SDK 분석
      const editorState = await page.evaluate(() => {
        return {
          url: window.location.href,
          iframes: Array.from(document.querySelectorAll('iframe')).map(f => ({
            src: f.src,
            id: f.id,
            name: f.name,
            width: f.offsetWidth,
            height: f.offsetHeight,
          })),
          hasEdicusSDK: typeof window.edicusSDK !== 'undefined',
          edicusSDKMethods: typeof window.edicusSDK !== 'undefined' ? Object.keys(window.edicusSDK) : [],
          hasEditor: typeof window.editor !== 'undefined',
          editorMethods: typeof window.editor !== 'undefined' ? Object.getOwnPropertyNames(Object.getPrototypeOf(window.editor) || {}) : [],
          globals: Object.keys(window).filter(k =>
            k.toLowerCase().includes('edicus') || k.toLowerCase().includes('editor') ||
            k.toLowerCase().includes('token') || k.toLowerCase().includes('ps_code')
          ),
          // edicus SDK v2 스크립트 찾기
          sdkScript: Array.from(document.querySelectorAll('script[src*="edicus"]')).map(s => s.src),
          // 인라인 스크립트에서 create_project/open_project 파라미터 추출
          edicusScripts: Array.from(document.querySelectorAll('script:not([src])'))
            .map(s => s.textContent)
            .filter(t => t.includes('edicus') || t.includes('create_project') || t.includes('private_css') || t.includes('template_uri'))
            .map(t => t.substring(0, 3000)),
          // 스타일에서 edicus/private 관련
          edicusStyles: Array.from(document.querySelectorAll('style'))
            .map(s => s.textContent)
            .filter(t => t.includes('edicus') || t.includes('private') || t.includes('#edicus'))
            .map(t => t.substring(0, 1000)),
          sentMessages: window.__capturedMessages || [],
          receivedMessages: window.__receivedMessages || [],
        };
      });

      console.log(`   === 편집기 상태 ===`);
      console.log(`   iframes: ${JSON.stringify(editorState.iframes, null, 2)}`);
      console.log(`   edicusSDK: ${editorState.hasEdicusSDK}`);
      console.log(`   edicusSDK methods: ${JSON.stringify(editorState.edicusSDKMethods)}`);
      console.log(`   editor: ${editorState.hasEditor}`);
      console.log(`   editor methods: ${JSON.stringify(editorState.editorMethods)}`);
      console.log(`   전역: ${JSON.stringify(editorState.globals)}`);
      console.log(`   SDK 스크립트: ${JSON.stringify(editorState.sdkScript)}`);
      console.log(`   Edicus 인라인 코드: ${editorState.edicusScripts.length}개`);
      editorState.edicusScripts.forEach((s, i) => console.log(`   --- 코드 ${i}: ${s}`));
      console.log(`   Edicus 스타일: ${editorState.edicusStyles.length}개`);
      editorState.edicusStyles.forEach((s, i) => console.log(`   --- 스타일 ${i}: ${s}`));
      console.log();

      await page.screenshot({ path: '/tmp/redprinting-editor.png', fullPage: true });
    } else {
      console.log('   편집기 진입 버튼을 찾을 수 없습니다.');
      // 페이지의 모든 클릭 가능한 요소 출력
      const clickables = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('a, button, [onclick], [role="button"]'))
          .map(e => ({
            tag: e.tagName,
            text: e.textContent?.trim().substring(0, 60),
            href: e.getAttribute('href')?.substring(0, 100),
            onclick: e.getAttribute('onclick')?.substring(0, 200),
          }))
          .filter(e => e.text && e.text.length > 0)
          .slice(0, 30);
      });
      console.log(`   클릭 가능 요소: ${JSON.stringify(clickables, null, 2)}`);
    }

    // 4. Edicus 네트워크 요청 분석
    console.log('\n4. Edicus 관련 네트워크 요청...');
    const edicusReqs = allRequests.filter(r =>
      r.url.includes('edicus') || r.url.includes('edicusbase') ||
      r.url.includes('token') || r.url.includes('private_css')
    );
    console.log(`   총 ${edicusReqs.length}개:`);
    edicusReqs.forEach(r => {
      console.log(`   ${r.method} ${r.url}`);
      if (r.postData) console.log(`     body: ${r.postData}`);
      if (Object.keys(r.headers).length > 0) console.log(`     headers: ${JSON.stringify(r.headers)}`);
    });

    // 5. 중요 응답
    console.log('\n5. 중요 응답...');
    importantResponses.forEach(r => {
      console.log(`   ${r.status} ${r.url}`);
      if (r.body) console.log(`     body: ${r.body.substring(0, 500)}`);
    });

  } catch (error) {
    console.error(`오류: ${error.message}\n${error.stack}`);
  } finally {
    await browser.close();
  }

  console.log('\n=== 심층 분석 완료 ===');
}

analyze().catch(console.error);
