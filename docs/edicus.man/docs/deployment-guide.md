# Edicus Man - Vercel 배포 가이드

## 개요

이 문서는 Edicus Web-to-Print 프로젝트(Next.js 15 App Router)를 Vercel에 배포하는 전체 절차를 설명합니다.

---

## 1. 사전 준비

배포 전 다음 항목을 준비해야 합니다.

- GitHub 계정 및 저장소에 코드 push 완료
- Vercel 계정 (https://vercel.com 에서 무료 가입 가능)
- Edicus API 키 (모션원에서 발급받은 키)

---

## 2. Vercel 프로젝트 생성

### 2-1. 새 프로젝트 생성

1. [Vercel 대시보드](https://vercel.com/dashboard)에 로그인합니다.
2. 우측 상단 **Add New...** > **Project**를 클릭합니다.
3. **Import Git Repository** 섹션에서 GitHub을 연결하고 `edicus.man` 저장소를 선택합니다.
4. **Import** 버튼을 클릭합니다.

### 2-2. 빌드 설정 확인

Vercel이 Next.js 프로젝트를 자동으로 감지합니다. 기본 설정을 그대로 사용합니다.

| 항목 | 값 |
|------|-----|
| Framework Preset | Next.js |
| Build Command | `next build` |
| Output Directory | `.next` (자동 감지) |
| Install Command | `npm install` |

> Next.js 기본 설정으로 동작하므로 `vercel.json` 파일은 필요하지 않습니다.

---

## 3. 환경 변수 설정

프로젝트 배포 전 반드시 환경 변수를 설정해야 합니다. Vercel 프로젝트 생성 화면의 **Environment Variables** 섹션 또는 이후 **Settings > Environment Variables**에서 추가할 수 있습니다.

### 환경 변수 목록

#### EDICUS_API_KEY

| 항목 | 값 |
|------|-----|
| 필수 여부 | **필수** |
| 노출 범위 | 서버 전용 (클라이언트에 절대 노출 금지) |
| 설명 | 모션원에서 발급받은 Edicus API 인증 키. 서버 사이드 API 라우트(`/api/edicus/*`)에서만 사용됩니다. `NEXT_PUBLIC_` 접두사를 붙이지 않아야 클라이언트 번들에 포함되지 않습니다. |
| 예시 값 | `9eb2c1b6-e1e6-473e-8e8c-072bd5fb40ca` |

#### EDICUS_API_HOST

| 항목 | 값 |
|------|-----|
| 필수 여부 | **필수** |
| 노출 범위 | 서버 전용 |
| 설명 | Edicus 백엔드 API 서버 URL. 템플릿 조회, 주문 생성 등 서버 사이드 API 호출에 사용됩니다. |
| 기본값 | `https://api-dot-edicusbase.appspot.com` |

#### EDICUS_RESOURCE_HOST

| 항목 | 값 |
|------|-----|
| 필수 여부 | **필수** |
| 노출 범위 | 서버 전용 |
| 설명 | Edicus 리소스 서버 URL. 템플릿 썸네일 이미지 및 정적 리소스 조회에 사용됩니다. |
| 기본값 | `https://resource-dot-edicusbase.appspot.com` |

#### NEXT_PUBLIC_EDICUS_PARTNER

| 항목 | 값 |
|------|-----|
| 필수 여부 | **필수** |
| 노출 범위 | 클라이언트 공개 가능 |
| 설명 | Edicus 파트너 코드. Red Editor SDK 초기화 시 파트너 식별에 사용됩니다. `NEXT_PUBLIC_` 접두사로 클라이언트 번들에 포함됩니다. |
| 기본값 | `hunip` |

#### NEXT_PUBLIC_EDICUS_BASE_URL

| 항목 | 값 |
|------|-----|
| 필수 여부 | **필수** |
| 노출 범위 | 클라이언트 공개 가능 |
| 설명 | Edicus 에디터 iframe이 로드되는 기본 URL. Red Editor SDK의 `baseUrl` 옵션으로 사용됩니다. |
| 기본값 | `https://edicusbase.firebaseapp.com` |

### 환경별 설정 권장사항

Vercel에서는 환경 변수를 **Production**, **Preview**, **Development** 세 환경으로 분리하여 관리할 수 있습니다.

| 환경 변수 | Production | Preview | Development |
|-----------|-----------|---------|-------------|
| EDICUS_API_KEY | 실제 키 | 테스트 키 | 테스트 키 |
| EDICUS_API_HOST | 운영 URL | 운영 URL | 운영 URL |
| EDICUS_RESOURCE_HOST | 운영 URL | 운영 URL | 운영 URL |
| NEXT_PUBLIC_EDICUS_PARTNER | `hunip` | `sandbox` | `sandbox` |
| NEXT_PUBLIC_EDICUS_BASE_URL | 운영 URL | 운영 URL | 운영 URL |

---

## 4. 첫 배포 실행

환경 변수 설정 후 **Deploy** 버튼을 클릭합니다.

빌드 로그에서 다음 단계를 확인할 수 있습니다.

1. 의존성 설치 (`npm install`)
2. 타입 체크 및 빌드 (`next build`)
3. 정적 자산 최적화
4. 배포 완료 및 URL 발급

빌드가 성공하면 `https://[project-name].vercel.app` 형태의 URL이 발급됩니다.

---

## 5. 도메인 설정

### 커스텀 도메인 연결

1. Vercel 프로젝트의 **Settings > Domains**으로 이동합니다.
2. **Add** 버튼을 클릭하고 도메인을 입력합니다. (예: `print.example.com`)
3. DNS 제공자에서 안내된 레코드를 추가합니다.
   - CNAME 레코드: `cname.vercel-dns.com`
   - 또는 A 레코드: `76.76.21.21`
4. DNS 전파 후 (최대 48시간) SSL 인증서가 자동으로 발급됩니다.

---

## 6. 자동 배포 설정

Vercel은 GitHub 저장소와 연동 시 다음과 같이 자동 배포됩니다.

- `main` 브랜치에 push → **Production** 환경에 자동 배포
- 기타 브랜치에 push 또는 PR 생성 → **Preview** 환경에 자동 배포 (고유 URL 발급)

---

## 7. 배포 확인 체크리스트

배포 완료 후 아래 항목을 순서대로 확인합니다.

### 기본 동작

- [ ] 메인 페이지(`/`)가 정상적으로 로드된다
- [ ] 템플릿 목록 페이지가 표시된다
- [ ] 브라우저 개발자 도구 콘솔에 에러가 없다

### API 연동

- [ ] `/api/edicus/auth` 엔드포인트가 응답한다 (200 OK)
- [ ] `/api/edicus/templates` 엔드포인트가 템플릿 목록을 반환한다
- [ ] `/api/edicus/products` 엔드포인트가 상품 목록을 반환한다

### 에디터 동작

- [ ] 템플릿 선택 후 Red Editor iframe이 정상 로드된다
- [ ] 에디터 내에서 텍스트/이미지 편집이 가능하다

### 보안 확인

- [ ] 브라우저 Network 탭에서 `EDICUS_API_KEY`가 클라이언트 응답에 포함되지 않는다
- [ ] API 라우트가 서버 사이드에서만 API 키를 사용한다

### 환경 변수

- [ ] Vercel 대시보드에서 모든 필수 환경 변수가 설정되어 있다
- [ ] `NEXT_PUBLIC_` 변수가 클라이언트에서 올바르게 참조된다

---

## 8. 문제 해결

### 빌드 실패 시

빌드 로그의 에러 메시지를 확인합니다. 주요 원인:

- **타입 에러**: `npm run build`를 로컬에서 먼저 실행하여 에러를 확인합니다.
- **환경 변수 누락**: Zod 스키마 검증 에러가 발생하면 필수 환경 변수가 설정되어 있는지 확인합니다.

### 에디터 iframe 로드 실패 시

- `NEXT_PUBLIC_EDICUS_BASE_URL` 값이 올바른지 확인합니다.
- 브라우저 Content Security Policy 에러가 있는지 확인합니다.

### API 응답 실패 시

- `EDICUS_API_KEY`, `EDICUS_API_HOST` 환경 변수가 정확히 설정되었는지 확인합니다.
- Vercel 함수 로그(**Deployments > Functions**)에서 에러를 확인합니다.

---

## 참고 자료

- [Vercel 공식 문서 - Next.js 배포](https://vercel.com/docs/frameworks/nextjs)
- [Next.js 환경 변수 가이드](https://nextjs.org/docs/app/building-your-application/configuring/environment-variables)
- [Vercel 환경 변수 관리](https://vercel.com/docs/projects/environment-variables)
