/**
 * redprinting.co.kr 로그인 → 세션 쿠키 추출 → cookies.json 저장
 */
require('dotenv').config({ path: require('path').join(__dirname, '.env') });
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const USERNAME = process.env.RP_USERNAME;
const PASSWORD = process.env.RP_PASSWORD;

async function run() {
  if (!USERNAME || !PASSWORD) {
    console.error('RP_USERNAME / RP_PASSWORD 환경변수 필요');
    process.exit(1);
  }

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36'
  });
  const page = await context.newPage();

  // ── red-editor-token 캡처: 요청/응답 모두 인터셉트 ──
  let capturedEditorToken = '';
  page.on('request', req => {
    const t = req.headers()['red-editor-token'];
    if (t && t.length > 20) {
      capturedEditorToken = t;
      console.log('[Token] 요청에서 캡처:', t.slice(0, 30) + '...');
    }
  });
  context.on('response', async resp => {
    try {
      const h = resp.headers()['red-editor-token'] || resp.headers()['x-red-editor-token'];
      if (h && h.length > 20) { capturedEditorToken = h; console.log('[Token] 응답헤더에서 캡처'); }
    } catch {}
  });

  console.log('[1] 로그인 페이지 이동...');
  await page.goto('https://www.redprinting.co.kr/ko/member/login', { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.waitForTimeout(2000);

  // 페이지 내 모든 input 확인
  const inputInfo = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('input')).map(el => ({
      name: el.name, id: el.id, type: el.type, visible: el.offsetParent !== null
    }));
  });
  console.log('[2] 페이지 input 목록:', JSON.stringify(inputInfo));

  // 로그인 폼 입력 - 가시적인 텍스트/이메일 입력 필드 선택
  const idInput = await page.$('input[name="mb_id"]:visible, form input[type="text"]:visible, form input[type="email"]:visible');
  const pwInput = await page.$('input[name="mb_password"]:visible, form input[type="password"]:visible');

  if (!idInput || !pwInput) {
    // form-data POST 직접 방식으로 대체
    console.log('[2b] 직접 POST 방식으로 로그인 시도...');
    await page.evaluate(async (creds) => {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '/ko/member/login_check';
      ['mb_id', 'mb_password', 'url'].forEach((name, i) => {
        const input = document.createElement('input');
        input.name = name;
        input.value = [creds.u, creds.p, '/ko/main'][i];
        form.appendChild(input);
      });
      document.body.appendChild(form);
      form.submit();
    }, { u: USERNAME, p: PASSWORD });
    await page.waitForTimeout(4000);
  } else {
    console.log('[2] 폼 입력...');
    await idInput.fill(USERNAME);
    await pwInput.fill(PASSWORD);
    await pwInput.press('Enter');
    await page.waitForTimeout(3000);
  }

  const url = page.url();
  console.log('[3] 로그인 후 URL:', url);

  // 상품 페이지 방문 → SDK가 makers.redprinting.net 쿠키 설정
  console.log('[3b] 위젯 상품 페이지 방문 (makers 쿠키 획득)...');
  await page.goto('https://www.redprinting.co.kr/ko/product/item/GS/GSTGMIC', { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(6000); // SDK 초기화 + makers 쿠키 설정 대기

  // 쿠키 추출
  const cookies = await context.cookies(['https://www.redprinting.co.kr', 'https://makers.redprinting.net', 'https://widget-api.redprinting.co.kr']);
  console.log(`[4] 쿠키 ${cookies.length}개 추출`);

  // cookies.json 저장
  const outPath = path.join(__dirname, 'cookies.json');
  fs.writeFileSync(outPath, JSON.stringify(cookies, null, 2));
  console.log(`[5] 저장: ${outPath}`);

  // ── sessionStorage / localStorage / window 변수에서 토큰 탐색 ──
  if (!capturedEditorToken) {
    capturedEditorToken = await page.evaluate(() => {
      // 1) sessionStorage / localStorage JWT 탐색
      for (const storage of [sessionStorage, localStorage]) {
        for (let i = 0; i < storage.length; i++) {
          const key = storage.key(i);
          const val = storage.getItem(key);
          if (val && val.startsWith('eyJ') && val.length > 50 && val.includes('.')) return val;
        }
      }
      // 2) window 전역 변수 탐색
      for (const key of Object.keys(window)) {
        try {
          const v = window[key];
          if (typeof v === 'string' && v.startsWith('eyJ') && v.length > 50) return v;
          if (typeof v === 'object' && v && v.editorToken) return v.editorToken;
          if (typeof v === 'object' && v && v.token && typeof v.token === 'string' && v.token.startsWith('eyJ')) return v.token;
        } catch {}
      }
      return '';
    }).catch(() => '');
    if (capturedEditorToken) console.log('[Token] Storage/window에서 토큰 발견');
  }

  // ── Shadow DOM 내 Vue 스토어에서 토큰 탐색 ──
  if (!capturedEditorToken) {
    capturedEditorToken = await page.evaluate(() => {
      function scanForToken(root) {
        for (const el of root.querySelectorAll('*')) {
          const app = el.__vue_app__;
          if (app) {
            const pinia = app._context?.provides?.pinia;
            if (pinia?.state?.value) {
              const state = JSON.stringify(pinia.state.value);
              const m = state.match(/"(?:token|editorToken|red-editor-token)"\s*:\s*"(eyJ[^"]{40,})"/);
              if (m) return m[1];
            }
          }
          if (el.shadowRoot) { const r = scanForToken(el.shadowRoot); if (r) return r; }
        }
        return '';
      }
      return scanForToken(document);
    }).catch(() => '');
    if (capturedEditorToken) console.log('[Token] Vue 스토어에서 토큰 발견');
  }

  // ── .env 업데이트 ──
  if (capturedEditorToken) {
    const envPath = path.join(__dirname, '.env');
    let envContent = '';
    try { envContent = fs.readFileSync(envPath, 'utf8'); } catch {}
    if (envContent.includes('RP_EDITOR_TOKEN=')) {
      envContent = envContent.replace(/RP_EDITOR_TOKEN=.*/,`RP_EDITOR_TOKEN=${capturedEditorToken}`);
    } else {
      envContent += `\nRP_EDITOR_TOKEN=${capturedEditorToken}`;
    }
    fs.writeFileSync(envPath, envContent);
    console.log('[6] .env RP_EDITOR_TOKEN 업데이트 완료');
  } else {
    console.warn('[6] red-editor-token 캡처 실패 — .env 미업데이트');
  }

  // 로그인 성공 여부 확인
  const isLoggedIn = !url.includes('/login') && !url.includes('/member/login');
  console.log(`[6] 로그인 상태: ${isLoggedIn ? '성공' : '실패 (URL 확인 필요)'}`);

  if (!isLoggedIn) {
    // 폼 재시도 - 선택자 다르게
    console.log('[7] 재시도...');
    const inputs = await page.$$('input[type="text"], input[type="email"]');
    const pwInputs = await page.$$('input[type="password"]');
    if (inputs.length && pwInputs.length) {
      await inputs[0].fill(USERNAME);
      await pwInputs[0].fill(PASSWORD);
      await pwInputs[0].press('Enter');
      await page.waitForTimeout(3000);
      const cookies2 = await context.cookies();
      fs.writeFileSync(outPath, JSON.stringify(cookies2, null, 2));
      console.log('[7] 재시도 후 URL:', page.url());
    }
  }

  await browser.close();
}

run().catch(e => { console.error(e); process.exit(1); });
