/**
 * 레드프린팅 Edicus 편집기 실제 CSS 추출
 * 상품을 선택하여 편집기 iframe까지 접근
 */
import { chromium } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

const OUTPUT_DIR = path.join(__dirname, '..', '.moai', 'specs', 'SPEC-CSS-001');

async function main() {
  console.log('=== 레드프린팅 편집기 CSS 추출 (상품 선택 → 편집기) ===\n');

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15',
    viewport: { width: 390, height: 844 },
    isMobile: true,
  });

  // postMessage 및 네트워크 요청 캡처
  const allRequests: { url: string; type: string }[] = [];
  const consoleLogs: string[] = [];

  const page = await context.newPage();

  page.on('request', (req) => {
    const url = req.url();
    if (url.includes('edicus') || url.includes('private_css') || url.includes('css') && url.includes('edicusbase')) {
      allRequests.push({ url, type: req.resourceType() });
    }
  });

  page.on('console', (msg) => {
    const text = msg.text();
    if (text.includes('css') || text.includes('edicus') || text.includes('private') || text.includes('param')) {
      consoleLogs.push(text);
    }
  });

  try {
    // Step 1: 모바일 에디터 카탈로그 접속
    console.log('Step 1: 카탈로그 접속...');
    await page.goto('https://m.redprinting.co.kr/landing/mobile_editor', {
      waitUntil: 'networkidle', timeout: 30000,
    });

    // Step 2: 상품 목록에서 실제 상품 링크 찾기
    console.log('Step 2: 상품 링크 탐색...');
    const productInfo = await page.evaluate(() => {
      // 모든 a 태그에서 상품 링크 패턴 찾기
      const allLinks = Array.from(document.querySelectorAll('a'));
      const productLinks = allLinks
        .filter(a => {
          const href = a.getAttribute('href') || '';
          // 상품 상세/편집 링크 패턴
          return (
            href.includes('/product/') ||
            href.includes('/item/') ||
            href.includes('/goods/') ||
            href.includes('/detail/') ||
            href.match(/\/\d+$/) || // 숫자 ID로 끝나는 링크
            href.includes('templateId') ||
            href.includes('psCode')
          );
        })
        .map(a => ({
          href: a.getAttribute('href'),
          text: a.textContent?.trim().slice(0, 80),
          classList: a.className.slice(0, 100),
        }));

      // 목록 아이템 찾기 (div/li 기반 상품 카드)
      const items = Array.from(document.querySelectorAll('[class*="product"], [class*="item"], [class*="card"], [class*="goods"]'));
      const itemsInfo = items.slice(0, 5).map(el => ({
        tag: el.tagName,
        class: el.className.slice(0, 100),
        childLinks: Array.from(el.querySelectorAll('a')).map(a => a.getAttribute('href')).filter(Boolean),
        text: el.textContent?.trim().slice(0, 100),
      }));

      // 페이지 전체 링크 중 숫자가 포함된 경로 (상품 ID 패턴)
      const numericLinks = allLinks
        .filter(a => {
          const href = a.getAttribute('href') || '';
          return href.match(/\/\d+/) && !href.includes('landing');
        })
        .map(a => a.getAttribute('href'))
        .filter((v, i, arr) => arr.indexOf(v) === i)
        .slice(0, 20);

      return { productLinks, itemsInfo, numericLinks, totalLinks: allLinks.length };
    });

    console.log(`  전체 링크 수: ${productInfo.totalLinks}`);
    console.log(`  상품 링크: ${JSON.stringify(productInfo.productLinks.slice(0, 5), null, 2)}`);
    console.log(`  아이템 정보: ${JSON.stringify(productInfo.itemsInfo.slice(0, 3), null, 2)}`);
    console.log(`  숫자 포함 링크: ${JSON.stringify(productInfo.numericLinks, null, 2)}`);

    // Step 3: 실제 클릭 가능한 상품 이미지/카드 찾아 클릭
    console.log('\nStep 3: 상품 카드 클릭 시도...');

    // 이미지가 있는 상품 카드를 찾아서 클릭
    const clickResult = await page.evaluate(() => {
      // 상품 이미지나 카드를 포함하는 요소들
      const candidates = Array.from(document.querySelectorAll('a img, a picture, [class*="thumb"], [class*="image"]'));
      const parentLinks = candidates
        .map(el => {
          let parent = el.parentElement;
          while (parent && parent.tagName !== 'A') parent = parent.parentElement;
          return parent as HTMLAnchorElement | null;
        })
        .filter(Boolean)
        .filter(a => {
          const href = a?.getAttribute('href') || '';
          return !href.includes('landing/mobile_editor/') && href !== '/landing/mobile_editor';
        });

      return {
        count: parentLinks.length,
        firstFew: parentLinks.slice(0, 5).map(a => ({
          href: a?.getAttribute('href'),
          text: a?.textContent?.trim().slice(0, 50),
        })),
      };
    });

    console.log(`  이미지 포함 링크: ${clickResult.count}개`);
    console.log(`  처음 5개:`, JSON.stringify(clickResult.firstFew, null, 2));

    // 첫 번째 상품 이미지 링크 클릭
    if (clickResult.firstFew.length > 0 && clickResult.firstFew[0].href) {
      const href = clickResult.firstFew[0].href;
      console.log(`\n  클릭 대상: ${href}`);

      await page.goto(`https://m.redprinting.co.kr${href}`, {
        waitUntil: 'networkidle', timeout: 30000,
      });

      console.log(`  이동 완료: ${page.url()}`);
      await page.screenshot({ path: path.join(OUTPUT_DIR, 'step3-product-detail.png') });

      // Step 4: 상품 상세 페이지에서 "디자인하기"/"만들기" 버튼 찾기
      console.log('\nStep 4: 편집기 진입 버튼 탐색...');

      const editorButtons = await page.evaluate(() => {
        const all = Array.from(document.querySelectorAll('a, button'));
        return all
          .filter(el => {
            const text = el.textContent?.trim() || '';
            const href = el.getAttribute('href') || '';
            return (
              text.includes('디자인') ||
              text.includes('만들기') ||
              text.includes('편집') ||
              text.includes('시작') ||
              text.includes('제작') ||
              href.includes('editor') ||
              href.includes('design') ||
              href.includes('edicus')
            );
          })
          .map(el => ({
            tag: el.tagName,
            text: el.textContent?.trim().slice(0, 80),
            href: el.getAttribute('href'),
            onclick: el.getAttribute('onclick')?.slice(0, 100),
            class: el.className.slice(0, 100),
          }));
      });

      console.log(`  편집기 버튼:`, JSON.stringify(editorButtons, null, 2));

      // "디자인하기" 버튼 클릭
      if (editorButtons.length > 0) {
        const designBtn = editorButtons[0];
        console.log(`\n  클릭: "${designBtn.text}"`);

        // 새 페이지가 열릴 수 있으므로 대기
        const pagePromise = context.waitForEvent('page', { timeout: 15000 }).catch(() => null);

        if (designBtn.href) {
          const fullUrl = designBtn.href.startsWith('http')
            ? designBtn.href
            : `https://m.redprinting.co.kr${designBtn.href}`;
          await page.goto(fullUrl, { waitUntil: 'domcontentloaded', timeout: 30000 });
        } else {
          await page.click(`text="${designBtn.text}"`, { timeout: 5000 }).catch(() => {});
        }

        const newPage = await pagePromise;
        const targetPage = newPage || page;

        await targetPage.waitForTimeout(5000); // 편집기 로드 대기
        console.log(`  현재 URL: ${targetPage.url()}`);
        await targetPage.screenshot({ path: path.join(OUTPUT_DIR, 'step4-editor-page.png') });

        // Step 5: 편집기 페이지에서 iframe 및 CSS 추출
        console.log('\nStep 5: 편집기 iframe 및 CSS 추출...');

        const editorData = await targetPage.evaluate(() => {
          const result: Record<string, unknown> = {};

          // iframe 검색
          const iframes = Array.from(document.querySelectorAll('iframe'));
          result.iframes = iframes.map(f => ({
            src: f.src,
            id: f.id,
            className: f.className,
            style: f.getAttribute('style'),
          }));

          // CSS 변수
          const rootStyles = getComputedStyle(document.documentElement);
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
          result.cssVariables = cssVars;

          // 모든 style 태그의 내용 (edicus 관련만)
          const styleTags = Array.from(document.querySelectorAll('style'));
          result.edicusStyles = styleTags
            .map(s => s.textContent || '')
            .filter(t => t.includes('edicus') || t.includes('editor') || t.includes('theme') || t.includes('private'))
            .slice(0, 5);

          // 스크립트에서 edicus 관련 변수 찾기
          const scripts = Array.from(document.querySelectorAll('script:not([src])'));
          result.edicusScripts = scripts
            .map(s => s.textContent || '')
            .filter(t => t.includes('edicus') || t.includes('private_css') || t.includes('edicusSDK'))
            .map(t => t.slice(0, 500));

          // 페이지 제목 및 URL
          result.pageTitle = document.title;
          result.pageUrl = window.location.href;

          return result;
        });

        console.log(`  페이지 제목: ${editorData.pageTitle}`);
        console.log(`  iframes: ${JSON.stringify(editorData.iframes, null, 2)}`);
        console.log(`  CSS 변수: ${JSON.stringify(editorData.cssVariables, null, 2)}`);
        console.log(`  Edicus 관련 스타일: ${(editorData.edicusStyles as string[])?.length || 0}개`);
        console.log(`  Edicus 관련 스크립트: ${(editorData.edicusScripts as string[])?.length || 0}개`);

        if ((editorData.edicusScripts as string[])?.length > 0) {
          console.log('\n  === Edicus 스크립트 내용 ===');
          for (const script of editorData.edicusScripts as string[]) {
            console.log(script);
          }
        }

        // iframe 내부 접근 시도
        if ((editorData.iframes as any[])?.length > 0) {
          console.log('\n  === iframe 내부 CSS 추출 시도 ===');
          for (const iframe of editorData.iframes as any[]) {
            if (iframe.src?.includes('edicus') || iframe.src?.includes('firebaseapp')) {
              console.log(`  iframe src: ${iframe.src}`);

              // iframe의 URL 파라미터 분석
              try {
                const url = new URL(iframe.src);
                const params = Object.fromEntries(url.searchParams.entries());
                console.log('  iframe URL 파라미터:', JSON.stringify(params, null, 2));

                // wait_private_css 파라미터 확인
                if (params.wait_private_css) {
                  console.log('  *** wait_private_css=true 발견! private_css가 deferred로 전달됨 ***');
                }
              } catch {}
            }
          }
        }

        // 전체 결과 저장
        const fullReport = {
          timestamp: new Date().toISOString(),
          finalUrl: targetPage.url(),
          editorData,
          capturedRequests: allRequests,
          consoleLogs,
        };

        fs.writeFileSync(
          path.join(OUTPUT_DIR, 'redprinting-editor-analysis.json'),
          JSON.stringify(fullReport, null, 2),
        );
        console.log(`\n  전체 결과 저장 완료`);
      }
    }
  } catch (error) {
    console.error('오류:', error);
  } finally {
    await browser.close();
    console.log('\n=== 분석 완료 ===');
  }
}

main().catch(console.error);
