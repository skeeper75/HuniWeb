/**
 * 재현 테스트 — refreshEditorToken 경로가 세션 쿠키를 메모리에 재로드하는가 (Rule 4: 버그 재현 우선)
 *
 * 버그: server.js 가 sessionCookieStr 을 시작 시 1회만 로드하고, refreshEditorToken(자동갱신/POST
 * /refresh-token)은 에디터 토큰만 메모리 갱신 → 가격 권위 쿠키가 stale → /rp-api 비로그인 단가(침묵 PRICE=0).
 *
 * 검증 2종:
 *  A) loadSessionCookies()가 cookies.json 변경분을 메모리에 재로드한다 (수정된 재로드 능력).
 *  B) refreshEditorToken 소스가 loadSessionCookies() 호출을 포함한다 (배선 — 이게 빠졌던 게 버그).
 *
 * 실행: node test-cookie-reload.cjs  (실제 cookies.json 은 백업/복원, 네트워크 호출 없음)
 */
const fs = require('fs');
const path = require('path');
const COOKIES = path.join(__dirname, 'cookies.json');
const BAK = COOKIES + '.testbak';
let failed = 0;
const assert = (cond, msg) => { console.log((cond ? 'PASS' : 'FAIL') + ': ' + msg); if (!cond) failed++; };

const hadReal = fs.existsSync(COOKIES);
if (hadReal) fs.copyFileSync(COOKIES, BAK);
try {
  // 시작 상태: 쿠키 AAA
  fs.writeFileSync(COOKIES, JSON.stringify([{ name: 'PHPSESSID', value: 'AAA' }]));
  const srv = require('./server.js'); // 로드 시 loadSessionCookies() 실행됨
  assert(srv.getSessionCookieStr().includes('PHPSESSID=AAA'), 'A1 시작 시 cookies.json 메모리 로드');

  // extract-cookies 가 cookies.json 을 BBB 로 다시 썼다고 가정 → refreshEditorToken 이 호출하는 재로드 경로
  fs.writeFileSync(COOKIES, JSON.stringify([{ name: 'PHPSESSID', value: 'BBB' }]));
  srv.loadSessionCookies();
  assert(srv.getSessionCookieStr().includes('PHPSESSID=BBB'), 'A2 갱신 후 sessionCookieStr 재로드 (버그 핵심)');
  assert(!srv.getSessionCookieStr().includes('AAA'), 'A3 stale 쿠키 제거됨');

  // 배선 회귀 가드: refreshEditorToken 이 loadSessionCookies 를 호출하는가
  const src = fs.readFileSync(path.join(__dirname, 'server.js'), 'utf8');
  const fnBody = src.slice(src.indexOf('async function refreshEditorToken'), src.indexOf('// 토큰 만료 55분'));
  // 주석 라인 제외 — 주석 처리된 호출은 배선이 아니다
  const codeLines = fnBody.split('\n').filter(l => !l.trim().startsWith('//'));
  assert(codeLines.some(l => /loadSessionCookies\(\)/.test(l)), 'B1 refreshEditorToken 이 loadSessionCookies() 호출 (누락이 버그였음)');
} finally {
  if (hadReal) { fs.copyFileSync(BAK, COOKIES); fs.unlinkSync(BAK); }
  else if (fs.existsSync(COOKIES)) fs.unlinkSync(COOKIES);
}
console.log(failed ? `\n${failed} FAILED` : '\nALL PASS');
process.exit(failed ? 1 : 0);
