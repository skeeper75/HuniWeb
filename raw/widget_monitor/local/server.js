/**
 * RedPrinting Widget Local Simulator — Express Proxy Server
 */
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const fs = require('fs');
const path = require('path');

const app = express();
const LOG_FILE = path.join(__dirname, 'api-log.json');
let logs = [];

// ── env 로딩 ──────────────────────────────────────────
require('dotenv').config({ path: path.join(__dirname, '.env') });

// ── 세션 쿠키 로딩 (cookies.json) ─────────────────────
// [가격 권위] /rp-api 가격 프록시가 주입하는 로그인 세션. extract-cookies 가 cookies.json 을
// 다시 쓰면 이 함수로 메모리(sessionCookieStr)에 재로드해야 가격 단가가 갱신된다.
let sessionCookieStr = '';
function loadSessionCookies() {
  try {
    const cookies = JSON.parse(fs.readFileSync(path.join(__dirname, 'cookies.json'), 'utf8'));
    sessionCookieStr = cookies.map(c => `${c.name}=${c.value}`).join('; ');
    console.log(`[Auth] 쿠키 ${cookies.length}개 로드`);
    return cookies.length;
  } catch {
    console.warn('[Auth] cookies.json 없음 — node extract-cookies.cjs 실행 필요');
    return 0;
  }
}
loadSessionCookies();

// ── 에디터 토큰 관리 ───────────────────────────────────
let editorToken = process.env.RP_EDITOR_TOKEN || '';

function isTokenExpired(jwt) {
  try {
    const payload = JSON.parse(Buffer.from(jwt.split('.')[1], 'base64').toString());
    return payload.exp && payload.exp < Math.floor(Date.now() / 1000) + 60; // 1분 여유
  } catch { return true; }
}

async function refreshEditorToken() {
  console.log('[Auth] 에디터 토큰 갱신 중...');
  const { execSync } = require('child_process');
  try {
    execSync('node extract-cookies.cjs', { cwd: __dirname, stdio: 'pipe', timeout: 90000 });
    // .env 다시 로드 (에디터 토큰)
    const envContent = fs.readFileSync(path.join(__dirname, '.env'), 'utf8');
    const match = envContent.match(/RP_EDITOR_TOKEN=(.+)/);
    if (match) { editorToken = match[1].trim(); console.log('[Auth] 토큰 갱신 완료'); }
    // [BUGFIX] 세션 쿠키도 메모리 재로드 — 누락 시 가격 권위 쿠키가 stale로 남아
    // 구동 중 자동갱신/POST /refresh-token 후에도 /rp-api 가 비로그인 단가(침묵 PRICE=0)로 회귀했다.
    loadSessionCookies();
  } catch (e) { console.error('[Auth] 토큰 갱신 실패:', e.message); }
}

// 토큰 만료 55분 간격 자동 갱신
setInterval(() => { if (isTokenExpired(editorToken)) refreshEditorToken(); }, 55 * 60 * 1000);
if (editorToken && isTokenExpired(editorToken)) {
  console.warn('[Auth] 에디터 토큰 만료됨 — 갱신 필요 (node extract-cookies.cjs)');
} else if (editorToken) {
  const payload = JSON.parse(Buffer.from(editorToken.split('.')[1], 'base64').toString());
  const exp = new Date(payload.exp * 1000).toLocaleTimeString('ko-KR');
  console.log(`[Auth] 에디터 토큰 로드 (만료: ${exp})`);
}

// ── CORS ──────────────────────────────────────────────
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') return res.sendStatus(200);
  next();
});

// ── Response body shape 추출 (depth 2) ───────────────
const BODY_LOG_FILE = path.join(__dirname, 'body-log.json');
const bodyLog = [];

function extractShape(obj, depth = 0, maxDepth = 2) {
  if (obj === null || obj === undefined) return typeof obj;
  if (Array.isArray(obj)) {
    if (obj.length === 0) return '[]';
    return depth < maxDepth ? [`(${obj.length})`, extractShape(obj[0], depth + 1, maxDepth)] : `Array(${obj.length})`;
  }
  if (typeof obj === 'object') {
    if (depth >= maxDepth) return `{${Object.keys(obj).length} keys}`;
    const shape = {};
    for (const [k, v] of Object.entries(obj)) {
      shape[k] = typeof v === 'object' && v !== null ? extractShape(v, depth + 1, maxDepth) : typeof v;
    }
    return shape;
  }
  return typeof obj;
}

function createLoggingMiddleware(prefix, pathPrefix) {
  return (req, res, next) => {
    const entry = {
      timestamp: new Date().toISOString(),
      method: req.method,
      path: pathPrefix ? pathPrefix + req.path : req.path,
      query: req.query
    };
    // Buffer response body chunks
    const chunks = [];
    const origWrite = res.write.bind(res);
    const origEnd = res.end.bind(res);

    res.write = (chunk, ...args) => {
      if (chunk) chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
      return origWrite(chunk, ...args);
    };

    res.end = (chunk, ...args) => {
      if (chunk) chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
      entry.status = res.statusCode;

      // Parse and log response body shape
      const bodyEntry = { timestamp: entry.timestamp, method: entry.method, path: entry.path, status: entry.status };
      try {
        const raw = Buffer.concat(chunks).toString('utf8');
        const parsed = JSON.parse(raw);
        bodyEntry.responseShape = extractShape(parsed);
        // Keep full body for price API responses (critical for G3 verification)
        if (entry.path.includes('get_ajax_price_vTmpl') || entry.path.includes('get_digital_product_info')) {
          bodyEntry.responseBody = parsed;
        }
      } catch {
        bodyEntry.responseShape = { _raw: 'non-JSON', byteLength: Buffer.concat(chunks).length };
      }
      bodyLog.push(bodyEntry);
      if (bodyLog.length > 200) bodyLog.splice(0, bodyLog.length - 200);
      try { fs.writeFileSync(BODY_LOG_FILE, JSON.stringify(bodyLog.slice(-50), null, 2)); } catch {}

      // Original api-log entry (metadata only, backwards-compatible)
      logs.push(entry);
      try { fs.writeFileSync(LOG_FILE, JSON.stringify(logs.slice(-100), null, 2)); } catch {}
      process.stdout.write(`[${prefix}] ${entry.method} ${entry.path} → ${entry.status}\n`);
      return origEnd(...args);
    };
    next();
  };
}

// ── 요청 로깅 (응답 body shape 캡처 포함) ────────────
app.use('/rp-api', createLoggingMiddleware('API', ''));
app.use('/makers-api', createLoggingMiddleware('MAPI', '/makers-api'));
app.use('/widget-api', createLoggingMiddleware('WAPI', '/widget-api'));

// ── body 파싱 + body 재작성 프록시 ───────────────────
function bodyProxy(target, pathRewrite) {
  app.use(Object.keys(pathRewrite)[0].replace(/\^/, '').replace(/\$/, ''),
    express.json({ limit: '20mb', strict: false })
  );
  return createProxyMiddleware({
    target,
    changeOrigin: true,
    pathRewrite,
    on: {
      proxyReq: (proxyReq, req) => {
        proxyReq.setHeader('Referer', 'https://www.redprinting.co.kr/');
        proxyReq.setHeader('Origin', 'https://www.redprinting.co.kr');
        proxyReq.setHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36');
        // 로그인 세션 주입 — get_ajax_price_vTmpl 등 가격 API가 로그인 고객 단가표를 반환하도록
        // (widget-api/makers 프록시와 동일 패턴; 이전엔 /rp-api만 누락되어 자재단가 0 반환)
        if (sessionCookieStr) proxyReq.setHeader('Cookie', sessionCookieStr);
        if (editorToken && !req.headers['red-editor-token']) proxyReq.setHeader('red-editor-token', editorToken);
        // JSON body 재작성
        if (req.body && Object.keys(req.body).length > 0) {
          const buf = Buffer.from(JSON.stringify(req.body), 'utf8');
          proxyReq.setHeader('Content-Type', 'application/json');
          proxyReq.setHeader('Content-Length', buf.length);
          proxyReq.write(buf);
        }
      },
      error: (err, req, res) => {
        console.error('[Proxy Error]', err.message);
        if (!res.headersSent) res.status(502).json({ error: err.message });
      }
    }
  });
}

app.use('/rp-api', bodyProxy('https://www.redprinting.co.kr', { '^/rp-api': '' }));

// widget-api: 세션 쿠키 + host JWT 주입 (KOI config가 유효한 토큰 반환하도록)
app.use('/widget-api',
  express.json({ limit: '20mb', strict: false }),
  createProxyMiddleware({
    target: 'https://widget-api.redprinting.co.kr',
    changeOrigin: true,
    pathRewrite: { '^/widget-api': '' },
    on: {
      proxyReq: (proxyReq, req) => {
        proxyReq.setHeader('Referer', 'https://www.redprinting.co.kr/');
        proxyReq.setHeader('Origin', 'https://www.redprinting.co.kr');
        proxyReq.setHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36');
        if (sessionCookieStr) proxyReq.setHeader('Cookie', sessionCookieStr);
        if (editorToken && !req.headers['red-editor-token']) proxyReq.setHeader('red-editor-token', editorToken);
        if (req.body && Object.keys(req.body).length > 0) {
          const buf = Buffer.from(JSON.stringify(req.body), 'utf8');
          proxyReq.setHeader('Content-Type', 'application/json');
          proxyReq.setHeader('Content-Length', buf.length);
          proxyReq.write(buf);
        }
      },
      error: (err, req, res) => {
        console.error('[Widget Proxy Error]', err.message);
        if (!res.headersSent) res.status(502).json({ error: err.message });
      }
    }
  })
);
// makers-api: 세션 쿠키 주입
app.use('/makers-api',
  express.json({ limit: '20mb', strict: false }),
  createProxyMiddleware({
    target: 'https://makers.redprinting.net',
    changeOrigin: true,
    pathRewrite: { '^/makers-api': '' },
    on: {
      proxyReq: (proxyReq, req) => {
        proxyReq.setHeader('Referer', 'https://www.redprinting.co.kr/');
        proxyReq.setHeader('Origin', 'https://www.redprinting.co.kr');
        proxyReq.setHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36');
        if (sessionCookieStr) proxyReq.setHeader('Cookie', sessionCookieStr);
        // 클라이언트(SDK)가 직접 설정한 토큰 우선, 없을 때만 env 토큰 주입
        if (editorToken && !req.headers['red-editor-token']) proxyReq.setHeader('red-editor-token', editorToken);
        if (req.body && Object.keys(req.body).length > 0) {
          const buf = Buffer.from(JSON.stringify(req.body), 'utf8');
          proxyReq.setHeader('Content-Type', 'application/json');
          proxyReq.setHeader('Content-Length', buf.length);
          proxyReq.write(buf);
        }
      },
      error: (err, req, res) => {
        console.error('[Makers Proxy Error]', err.message);
        if (!res.headersSent) res.status(502).json({ error: err.message });
      }
    }
  })
);

// ── api-log.json 직접 서빙 ────────────────────────────
app.get('/api-log.json', (req, res) => {
  res.json(logs.slice(-100));
});

// ── body log endpoint (populated by logging middleware above) ──
app.get('/body-log.json', (req, res) => res.json(bodyLog.slice(-50)));

// ── 현재 토큰 값 반환 (로컬 개발용) ──────────────────
app.get('/get-editor-token', (req, res) => {
  res.json({ token: editorToken, expired: isTokenExpired(editorToken) });
});

// ── 토큰 상태 조회 ────────────────────────────────────
app.get('/token-status', (req, res) => {
  if (!editorToken) return res.json({ status: 'none', expired: true });
  try {
    const payload = JSON.parse(Buffer.from(editorToken.split('.')[1], 'base64').toString());
    const expired = isTokenExpired(editorToken);
    res.json({ status: expired ? 'expired' : 'ok', exp: payload.exp, expired });
  } catch { res.json({ status: 'invalid', expired: true }); }
});

// ── 토큰 갱신 (Playwright 로그인) ─────────────────────
app.post('/refresh-token', async (req, res) => {
  try {
    await refreshEditorToken();
    const payload = JSON.parse(Buffer.from(editorToken.split('.')[1], 'base64').toString());
    res.json({ ok: true, exp: payload.exp });
  } catch (e) {
    res.status(500).json({ ok: false, error: e.message });
  }
});

// ── wow-proxy: WowPress comparison captures ──────────
app.use('/wow-proxy',
  createProxyMiddleware({
    target: 'https://print.wowpress.co.kr',
    changeOrigin: true,
    pathRewrite: { '^/wow-proxy': '' },
    on: {
      proxyReq: (proxyReq) => {
        proxyReq.setHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36');
      },
      error: (err, req, res) => {
        if (!res.headersSent) res.status(502).json({ error: err.message });
      }
    }
  })
);

// ── serve parent directory captures for comparison tab ──
app.use('/captures', express.static(path.join(__dirname, '..')));

// ── 정적 파일 ──────────────────────────────────────────
app.use(express.static(__dirname));

// 직접 실행 시에만 listen — require 시(테스트)엔 함수만 노출
if (require.main === module) {
  app.listen(3001, () => {
    console.log('\nRedPrinting Widget Simulator: http://localhost:3001');
    console.log('  /rp-api/*     → https://www.redprinting.co.kr');
    console.log('  /widget-api/* → https://widget-api.redprinting.co.kr\n');
  });
}

module.exports = {
  loadSessionCookies,
  isTokenExpired,
  getSessionCookieStr: () => sessionCookieStr,
  getEditorToken: () => editorToken,
};
