# RedPrinting Widget Local Simulator — 실행 가이드

`raw/widget_monitor/local`은 RedPrinting 위젯(Shadow DOM) + Edicus 에디터를 **로컬에서 라이브로 구동**하는 테스트베드다. Express 프록시 서버가 redprinting.co.kr·makers.redprinting.net 등에 로그인 세션을 주입해, 실제 가격 단가·에디터·옵션 캐스케이드를 로컬 브라우저에서 재현한다.

- 진입 화면: `index.html` (RedPrinting Widget Precision Analyzer)
- 서버: `server.js` (Express, **포트 3001**)
- 진실 소스: 라이브 RedPrinting API (읽기 프록시)

---

## 1. 사전 요구사항
- Node.js 20.x 이상
- 의존성: `express`, `http-proxy-middleware`, `playwright`, `dotenv` (package.json)
- Playwright 크로미움 (쿠키 추출 시 헤드리스 로그인에 필요)

## 2. 자격증명 설정 — `local/.env` (필수)
이 테스트베드의 자격증명은 **`raw/widget_monitor/local/.env`** 에 둔다 (루트 `.env.local`과 별개). 키 3종:

| 키 | 용도 | 사용처 |
|----|------|--------|
| `RP_USERNAME` | redprinting.co.kr 로그인 아이디 | `extract-cookies.cjs` |
| `RP_PASSWORD` | redprinting.co.kr 로그인 비밀번호 | `extract-cookies.cjs` |
| `RP_EDITOR_TOKEN` | Edicus 에디터 access token | `server.js`(에디터 프록시) |

`.env` 예시(값은 본인 계정으로 채울 것):
```
RP_USERNAME=your_id
RP_PASSWORD=your_pw
RP_EDITOR_TOKEN=
```
> `RP_EDITOR_TOKEN`은 비워둬도 서버 구동 중 자동 갱신 경로(`POST /refresh-token` + `extract-cookies` 재실행)가 채운다.

## 3. 설치
```bash
cd raw/widget_monitor/local
npm install
npx playwright install chromium   # 최초 1회
```

## 4. 실행 절차
```bash
# (1) 로그인 세션 쿠키 추출 — RP_USERNAME/RP_PASSWORD로 헤드리스 로그인 → cookies.json 생성
node extract-cookies.cjs

# (2) 프록시 서버 기동 (포트 3001)
node server.js
```
실행되면 콘솔에 `RedPrinting Widget Simulator: http://localhost:3001` 가 뜬다. 브라우저로 **http://localhost:3001** 접속.

> `[Auth] cookies.json 없음` 경고가 뜨면 (1)을 먼저 실행. 가격이 0(침묵 PRICE=0)으로 나오면 세션 만료이므로 (1) 재실행 후 서버 재기동.

## 5. 프록시 매핑 (server.js)
| 로컬 경로 | 타겟 | 비고 |
|-----------|------|------|
| `/rp-api/*` | `https://www.redprinting.co.kr` | 가격 API — **로그인 세션 쿠키 주입**(비로그인 시 단가 0) |
| `/widget-api/*` | `https://widget-api.redprinting.co.kr` | 위젯 API |
| `/makers-api/*` | `https://makers.redprinting.net` | Edicus 에디터/리소스 |
| (wowpress) | `https://print.wowpress.co.kr` | 경쟁사 비교용 |
| `POST /refresh-token` | — | 에디터 토큰 갱신 |

모든 프록시는 `Referer`/`Origin`을 `redprinting.co.kr`로 설정해 CORS·세션을 우회한다.

## 6. 캡처 스크립트 (선택)
서버와 별개로, 런타임 동작을 자동 캡처하는 Playwright 스크립트들:
```bash
PRODUCT=GSTGMIC node hw-runtime-capture.cjs   # 에디터 open → from-edicus 이벤트 타임라인
PRODUCT=GSTGMIC node qtysweep.cjs             # 수량 스윕 가격 캡처
LIMIT=0 node coverage-scan.cjs                # 카탈로그 전수 마운트/옵션구조 분류
```
환경변수: `PRODUCT`(상품코드), `WAIT_MS`, `LIMIT`. 캡처 결과 JSON은 상위 `raw/widget_monitor/`에 누적된다.

## 7. 자격증명 처리 요약 (보안)
- **저장 위치**: `local/.env` 한 곳. `RP_*` 3종.
- **git 보호**: `local/.gitignore`가 `.env`·`cookies.json`·`api-log.json`·`node_modules/`를 제외 → **git 추적 0개**(검증됨). 비밀값은 절대 커밋되지 않는다.
- **세션 흐름**: `.env`(아이디/비번) → `extract-cookies.cjs`(playwright 로그인) → `cookies.json`(세션 쿠키) → `server.js`가 메모리 로드 → `/rp-api` 프록시에 주입.
- **민감정보 마스킹**: 캡처 스크립트는 응답의 `token`/`jwt`/`presigned`/`signature`를 `[REDACTED]`로 가린다.
- 새 머신에서 받을 때 `.env`·`cookies.json`은 동기화되지 않으므로 **직접 `.env`를 채우고 (1)을 재실행**해야 한다.

## 8. 트러블슈팅
| 증상 | 원인 / 해결 |
|------|-------------|
| 가격이 0 / 단가 안 나옴 | 세션 만료·쿠키 누락 → `node extract-cookies.cjs` 후 서버 재기동 (RedPrinting은 정상 시 PRICE=0을 반환하지 않음 — 0은 항상 세션 결함 신호) |
| `RP_USERNAME / RP_PASSWORD 환경변수 필요` | `.env` 미작성 → 2절대로 작성 |
| 에디터(iframe) 안 뜸 | `RP_EDITOR_TOKEN` 만료 → 비우고 서버 재기동(자동 갱신) 또는 `/refresh-token` 호출 |
| 포트 충돌 | 3001 사용 중 → 기존 프로세스 종료 후 재기동 |
