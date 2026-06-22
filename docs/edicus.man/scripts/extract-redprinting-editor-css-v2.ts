/**
 * 레드프린팅 Edicus 편집기 CSS 추출 v2
 * 상품 상세 → "데이터제작 에디터" 클릭 → 편집기 iframe 분석
 */
import { chromium } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

const OUTPUT_DIR = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-CSS-001');

async function main() {
  console.log('=== 레드프린팅 편집기 CSS 추출 v2 ===\n');

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15',
    viewport: { width: 390, height: 844 },
    isMobile: true,
  });

  const consoleLogs: string[] = [];
  const networkRequests: { url: string; type: string; body?: string }[] = [];

  const page = await context.newPage();

  // 모든 네트워크 요청 모니터링 (edicus/css 관련)
  page.on('request', (req) => {
    const url = req.url();
    if (url.includes('edicus') || url.includes('edicusbase') || url.includes('firebaseapp') ||
        url.includes('private_css') || url.includes('wait_private_css')) {
      networkRequests.push({
        url,
        type: req.resourceType(),
        body: req.postData()?.slice(0, 500),
      });
    }
  });

  // 콘솔 로그 캡처
  page.on('console', (msg) => {
    consoleLogs.push(`[${msg.type()}] ${msg.text()}`);
  });

  try {
    // Step 1: 상품 상세 페이지 접속
    console.log('Step 1: 상품 상세 페이지 접속...');
    await page.goto('https://m.redprinting.co.kr/product/item/GS/GSWTANT', {
      waitUntil: 'networkidle', timeout: 30000,
    });
    console.log(`  URL: ${page.url()}`);

    // Step 2: "데이터제작 - 에디터" 버튼 클릭
    console.log('\nStep 2: "데이터제작 - 에디터" 버튼 클릭...');

    // 새 페이지/팝업 대기
    const [newPage] = await Promise.all([
      context.waitForEvent('page', { timeout: 15000 }).catch(() => null),
      page.click('text=데이터제작 - 에디터', { timeout: 5000 }).catch(async () => {
        // 텍스트 매칭 실패 시 onclick 함수 직접 호출
        console.log('  텍스트 클릭 실패, onclick 함수 직접 실행...');
        await page.evaluate(() => {
          const links = Array.from(document.querySelectorAll('a'));
          const editorLink = links.find(a =>
            a.textContent?.includes('에디터') || a.textContent?.includes('데이터제작')
          );
          if (editorLink) editorLink.click();
        });
      }),
    ]);

    // 모달이 열렸을 수 있음 - 확인
    await page.waitForTimeout(3000);

    // 모달/팝업 내용 확인
    const modalInfo = await page.evaluate(() => {
      // 모달 또는 새로 나타난 요소 확인
      const modals = Array.from(document.querySelectorAll('[class*="modal"], [class*="popup"], [class*="dialog"], [class*="overlay"]'));
      const visibleModals = modals.filter(m => {
        const style = getComputedStyle(m);
        return style.display !== 'none' && style.visibility !== 'hidden';
      });

      // 링크나 버튼 내부 확인
      const modalLinks = visibleModals.flatMap(m =>
        Array.from(m.querySelectorAll('a, button')).map(el => ({
          tag: el.tagName,
          text: el.textContent?.trim().slice(0, 100),
          href: el.getAttribute('href'),
        }))
      );

      // 전체 페이지에서 새로 나타난 iframe 확인
      const iframes = Array.from(document.querySelectorAll('iframe'));

      return {
        modalCount: visibleModals.length,
        modalClasses: visibleModals.map(m => m.className.slice(0, 100)),
        modalLinks,
        iframes: iframes.map(f => ({ src: f.src, id: f.id })),
      };
    });

    console.log(`  모달: ${modalInfo.modalCount}개`);
    console.log(`  모달 클래스: ${JSON.stringify(modalInfo.modalClasses)}`);
    console.log(`  모달 링크: ${JSON.stringify(modalInfo.modalLinks, null, 2)}`);
    console.log(`  iframes: ${JSON.stringify(modalInfo.iframes, null, 2)}`);

    await page.screenshot({ path: path.join(OUTPUT_DIR, 'step2-after-click.png') });

    // Step 3: 새 페이지가 열렸는지 확인
    if (newPage) {
      console.log(`\nStep 3: 새 페이지 열림 - ${newPage.url()}`);
      await newPage.waitForLoadState('networkidle', { timeout: 30000 }).catch(() => {});
      await newPage.screenshot({ path: path.join(OUTPUT_DIR, 'step3-new-page.png') });

      // 새 페이지에서 iframe 분석
      await analyzeEditorPage(newPage, 'new-page');
    } else {
      // 현재 페이지에서 변화 확인 (URL 변경 또는 iframe 추가)
      console.log(`\nStep 3: 현재 페이지 변화 확인... URL: ${page.url()}`);

      // 모달에서 링크 클릭 시도
      if (modalInfo.modalLinks.length > 0) {
        const editorModalLink = modalInfo.modalLinks.find(l =>
          l.text?.includes('에디터') || l.text?.includes('편집') || l.text?.includes('시작') ||
          l.href?.includes('editor') || l.href?.includes('edicus')
        );

        if (editorModalLink) {
          console.log(`  모달 내 편집기 링크 발견: ${editorModalLink.text}`);

          const [popupPage] = await Promise.all([
            context.waitForEvent('page', { timeout: 15000 }).catch(() => null),
            editorModalLink.href && !editorModalLink.href.startsWith('javascript')
              ? page.goto(editorModalLink.href.startsWith('http') ? editorModalLink.href : `https://m.redprinting.co.kr${editorModalLink.href}`, { timeout: 15000 })
              : page.click(`text="${editorModalLink.text}"`, { timeout: 5000 }).catch(() => {}),
          ]);

          if (popupPage) {
            await popupPage.waitForLoadState('networkidle', { timeout: 30000 }).catch(() => {});
            console.log(`  편집기 페이지: ${popupPage.url()}`);
            await popupPage.screenshot({ path: path.join(OUTPUT_DIR, 'step3-editor-popup.png') });
            await analyzeEditorPage(popupPage, 'popup');
          }
        }
      }

      // URL이 변경되었을 수 있음
      if (page.url() !== 'https://m.redprinting.co.kr/product/item/GS/GSWTANT') {
        await analyzeEditorPage(page, 'redirected');
      }
    }

    // Step 4: 네트워크 요청에서 edicus 관련 정보 분석
    console.log('\n=== 캡처된 Edicus 관련 네트워크 요청 ===');
    for (const req of networkRequests) {
      console.log(`  [${req.type}] ${req.url}`);
      if (req.url.includes('wait_private_css')) {
        console.log('  *** private_css 대기 파라미터 발견! ***');
      }
      if (req.body) {
        console.log(`  Body: ${req.body}`);
      }
    }

    console.log('\n=== 캡처된 콘솔 로그 (편집기 관련) ===');
    const edicusLogs = consoleLogs.filter(l =>
      l.includes('edicus') || l.includes('css') || l.includes('private') || l.includes('param')
    );
    for (const log of edicusLogs.slice(0, 20)) {
      console.log(`  ${log}`);
    }

    // 전체 결과 저장
    const report = {
      timestamp: new Date().toISOString(),
      networkRequests,
      consoleLogs: edicusLogs,
      modalInfo,
    };
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'redprinting-editor-v2.json'),
      JSON.stringify(report, null, 2),
    );

  } catch (error) {
    console.error('오류:', error);
  } finally {
    await browser.close();
    console.log('\n=== 분석 완료 ===');
  }
}

async function analyzeEditorPage(page: any, label: string) {
  console.log(`\n  === ${label}: 편집기 페이지 분석 ===`);
  console.log(`  URL: ${page.url()}`);

  const data = await page.evaluate(() => {
    const result: Record<string, unknown> = {};

    // iframe 분석
    const iframes = Array.from(document.querySelectorAll('iframe'));
    result.iframes = iframes.map((f: HTMLIFrameElement) => {
      const urlStr = f.src;
      let params: Record<string, string> = {};
      try {
        const url = new URL(urlStr);
        params = Object.fromEntries(url.searchParams.entries());
      } catch {}

      return {
        src: urlStr,
        id: f.id,
        className: f.className,
        style: f.getAttribute('style'),
        params,
        hasCssParam: urlStr.includes('private_css') || urlStr.includes('wait_private_css'),
      };
    });

    // CSS 변수
    const cssVars: Record<string, string> = {};
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
      } catch { /* cross-origin */ }
    }
    result.cssVars = cssVars;

    // edicus 관련 스크립트
    const scripts = Array.from(document.querySelectorAll('script'));
    result.edicusScriptContent = scripts
      .map((s: HTMLScriptElement) => s.textContent || '')
      .filter((t: string) => t.includes('edicus') || t.includes('private_css') || t.includes('edicusSDK'))
      .map((t: string) => t.slice(0, 1000));

    result.scriptSrcs = scripts
      .filter((s: HTMLScriptElement) => s.src)
      .map((s: HTMLScriptElement) => s.src)
      .filter((src: string) => src.includes('edicus') || src.includes('sdk'));

    result.pageTitle = document.title;

    return result;
  });

  console.log(`  제목: ${data.pageTitle}`);
  console.log(`  iframes: ${(data.iframes as any[]).length}개`);

  for (const iframe of data.iframes as any[]) {
    console.log(`    src: ${iframe.src?.slice(0, 200)}`);
    if (Object.keys(iframe.params).length > 0) {
      console.log(`    params: ${JSON.stringify(iframe.params, null, 4)}`);
    }
    if (iframe.hasCssParam) {
      console.log(`    *** wait_private_css 발견! ***`);
    }
  }

  if (Object.keys(data.cssVars as Record<string, string>).length > 0) {
    console.log(`  CSS 변수: ${JSON.stringify(data.cssVars, null, 2)}`);
  }

  if ((data.edicusScriptContent as string[]).length > 0) {
    console.log(`  Edicus 스크립트:`);
    for (const script of data.edicusScriptContent as string[]) {
      console.log(`    ${script.slice(0, 300)}`);
    }
  }

  if ((data.scriptSrcs as string[]).length > 0) {
    console.log(`  SDK 스크립트 소스: ${JSON.stringify(data.scriptSrcs, null, 2)}`);
  }

  await page.screenshot({ path: path.join(OUTPUT_DIR, `${label}-analysis.png`) });

  fs.writeFileSync(
    path.join(OUTPUT_DIR, `${label}-data.json`),
    JSON.stringify(data, null, 2),
  );
}

main().catch(console.error);
