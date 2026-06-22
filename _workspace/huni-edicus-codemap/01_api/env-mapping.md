# EDICUS_* 환경변수 ↔ 역할 매핑

[HARD 비밀] **값은 절대 출력하지 않는다 — 키 이름과 역할만.** 본 문서 작성 시 `.env.local` 값은 읽지 않았고 키 라인만 확인했다(`grep`으로 키명만).

권위: 역할 매핑은 ① SDK/Server API PDF(계약), ② reference 구현(`docs/edicus.man/src/lib/edicus/*`·`/api/edicus/*` 라우트), ③ `docs/edicus.man/docs/deployment-guide.md`(호스트 기본값·노출 범위) 교차.

## A. `.env.local`에 실재하는 EDICUS_* 키 (값 비노출)

| 키 이름 | 노출 | 대응 역할 | 어디에 쓰이나 (근거) |
|---------|------|-----------|----------------------|
| `EDICUS_PARTNER_CODE` | 서버/식별자 | SDK `partner` (create/open/recycle/preview params) = "부여받은 partner-id" | SDK params.partner (`SDK PDF p.5,8,28,30`). 배포가이드 클라이언트측은 `NEXT_PUBLIC_EDICUS_PARTNER`(default `hunip`)로 별도 노출 (`deployment-guide.md`) |
| `EDICUS_API_KEY` | **서버 전용(절대 클라 노출 금지)** | Server/Resource/Font API 공통 헤더 `edicus-api-key` | 전 Server API Headers (`Server API PDF p.1`). 모션원 발급 인증키 (`deployment-guide.md`) |
| `EDICUS_API_HOST` | 서버 전용 | Server/Order API base URL | `{HOST}/api/auth/*`, `/api/projects/*`, `/api/order/*` 호출 base. 기본값 `https://api-dot-edicusbase.appspot.com` (`Server API PDF p.3`; `server-api.ts`) |
| `EDICUS_RESOURCE_HOST` | 서버 전용 | Resource API base URL | `{HOST}/resapi/*` (product/list·token·package·query) 호출 base. 기본값 `https://resource-dot-edicusbase.appspot.com` (`Server API PDF p.36`; `resource-api.ts`) |
| `EDICUS_ASSET_HOST` | (호스트) | 정적 asset/리소스 자산 호스트 | 역할 분류상 리소스 자산 서빙 호스트. **PDF에 직접 키 명세 없음**(아래 미상) |
| `EDICUS_BASE_HOST` | 클라(추정) | 에디터 iframe base | SDK `init({ base_url })` = "에디쿠스 편집기 base url" (`SDK PDF p.3`). 배포가이드 클라측 등가 = `NEXT_PUBLIC_EDICUS_BASE_URL`(default `https://edicusbase.firebaseapp.com`) (`deployment-guide.md`) |
| `EDICUS_EDITOR_HOST` | 클라(추정) | 편집기 호스트 URL | edicus editor iframe이 로드되는 호스트. BASE_HOST와 역할 중첩 가능 — **PDF에 별도 키 명세 없음**(아래 미상) |
| `EDICUS_RENDER_DPI` | 설정값 | 렌더/프리뷰 DPI 기본값 | Preview Template `dpi`(default 300)·ProductSize refDPI/lowDPI 관련 설정 (`Server API PDF p.20,28`). **단일 키로 PDF 직접 명세 없음**(아래 미상) |
| `EDICUS_FIREBASE_API_KEY` | 클라 공개 가능 | Firebase web config (apiKey) | edicus가 Firebase 기반(base_url default `edicusbase.firebaseapp.com`)이라 클라 Firebase SDK 초기화용. **Edicus API PDF에 직접 명세 없음**(Firebase 표준 키) |
| `EDICUS_FIREBASE_AUTH_DOMAIN` | 클라 공개 가능 | Firebase authDomain | 동상 |
| `EDICUS_FIREBASE_DATABASE_URL` | 클라 공개 가능 | Firebase databaseURL | 동상 |
| `EDICUS_FIREBASE_PROJECT_ID` | 클라 공개 가능 | Firebase projectId | 동상 |
| `EDICUS_FIREBASE_STORAGE_BUCKET` | 클라 공개 가능 | Firebase storageBucket | 동상 (template_dp_url이 firebasestorage 도메인 — `Server API PDF p.25`) |
| `EDICUS_FIREBASE_MESSAGING_SENDER_ID` | 클라 공개 가능 | Firebase messagingSenderId | 동상 |
| `EDICUS_MANAGER_ID` | 서버 전용 | Edicus Manager 로그인 계정(email/staff) | Server API `POST /api/auth/staff/token`의 `edicus-email`에 대응 추정 (`Server API PDF p.3-4`). reference는 `EDICUS_STAFF_EMAIL` 사용 (`auth/staff/route.ts`) |
| `EDICUS_MANAGER_PW` | **서버 전용(비밀)** | Edicus Manager 비밀번호 | `POST /api/auth/staff/token`의 `edicus-pwd`에 대응 추정. reference는 `EDICUS_STAFF_PASSWORD` |
| `EDICUS_MANAGER_URL` | 서버/관리 | Edicus Manager 웹 URL | Manager(상품/리소스/폰트/division 등록) 콘솔 URL. **API 호출 base 아님** — 운영 관리 콘솔 |

## B. SDK config / Server 헤더 ↔ 키 대응 요약

- SDK `init({ base_url })` ← `EDICUS_BASE_HOST` (또는 `EDICUS_EDITOR_HOST`).
- SDK `partner` ← `EDICUS_PARTNER_CODE` (클라 노출분은 `NEXT_PUBLIC_EDICUS_PARTNER`).
- SDK `token` ← Server API `POST /api/auth/token` 응답(서버에서 발급 후 client 전달; 어느 env 키도 토큰 자체를 담지 않음).
- Server 헤더 `edicus-api-key` ← `EDICUS_API_KEY`.
- Server 헤더 `edicus-email`/`edicus-pwd` ← `EDICUS_MANAGER_ID`/`EDICUS_MANAGER_PW` (staff token 발급용).
- Server/Resource base URL ← `EDICUS_API_HOST` / `EDICUS_RESOURCE_HOST`.

## C. 보안 경계

- 절대 클라 노출 금지: `EDICUS_API_KEY`, `EDICUS_MANAGER_PW`, `EDICUS_MANAGER_ID`(staff 자격), 모든 토큰. Server API는 [HARD] 서버에서만 호출 (`Server API PDF p.1`).
- 클라 공개 가능: `partner`(NEXT_PUBLIC), `base_url`/editor host, Firebase web config(공개키 성격).

## D. 미상 / 정직 표기

- `EDICUS_ASSET_HOST`·`EDICUS_EDITOR_HOST`·`EDICUS_RENDER_DPI`: **PDF에 동명 키 직접 명세 없음** — 역할은 도메인 추론(asset 서빙 / editor iframe host / 렌더 DPI). PDF 권위 매핑은 `API_HOST`·`RESOURCE_HOST`·`base_url`·`dpi`까지.
- `EDICUS_MANAGER_ID`↔`edicus-email`, `EDICUS_MANAGER_PW`↔`edicus-pwd` 대응은 reference 구현이 `EDICUS_STAFF_EMAIL/PASSWORD`를 쓰므로 **명칭 불일치 가능**(같은 staff 계정 역할로 추정). 실제 코드 배선은 flow-author가 코드 호출부로 확정.
- FIREBASE_* 6종은 Edicus API PDF가 아닌 Firebase 표준 web config 키 — Edicus가 Firebase 호스팅(`edicusbase.firebaseapp.com`) 기반이라 필요. 정확한 클라 초기화 배선은 flow-author 코드 추적 대상.
