# 00 — 시스템 아키텍처 & 라우트 맵

> 청중: 개발팀. 권위[HARD]=API 계약 팩(`01_api/`) + 코드맵 팩(`02_codemap/`). 두 팩에 있는 사실만 도해한다.
> 추적성: 각 도해 아래 `파일:라인`·SDK 메서드·`PDF p.N`·env 키를 산문으로 병기(코드/문서로 점프 가능).
> 비밀값 비노출: env는 **키 이름만**(값 금지).

---

## A. 시스템 아키텍처 (경계: 내부 Next.js 앱 / 외부 Edicus·Firebase)

후니 `edicus.man`은 Next.js 15 App Router 앱이며(`02_codemap/module-map.md:6`), 핵심 외부 의존은 세 갈래다:
① 브라우저에 iframe으로 삽입되는 **Edicus SDK**(`window.edicusSDK`, `/edicus-sdk-v2.js`), ② **Edicus 서버/리소스 API**(토큰·프로젝트·주문·상품·템플릿), ③ **Firebase Auth**(로그인). 비밀값(`edicus-api-key`)이 필요한 Server API는 [HARD] 서버에서만 호출하고, 브라우저는 SDK와 Firebase Auth만 직접 접촉한다(`server-api-catalog.md:8`).

```mermaid
flowchart TB
  subgraph internal["내부 — Next.js 앱 (edicus.man)"]
    direction TB
    subgraph browser["브라우저 (Client)"]
      pages["App Router 페이지/컴포넌트<br/>(EdicusEditor·VdpEditor·MobileEditor·PCPassiveEditor)"]
      hooks["훅 4종<br/>useEdicus · useHuniEditor · useAuth · useOrder"]
      clientlib["lib/edicus/client.ts EdicusClient<br/>+ huni-editor-sdk.ts HuniEditorSDK"]
      fbclient["lib/firebase/config.ts (Firebase web SDK)"]
    end
    subgraph server["서버 (Route Handlers / RSC)"]
      apiroutes["app/api/edicus/** (10 route)"]
      serverapi["lib/edicus/server-api.ts<br/>createServerApiClient"]
      resourceapi["lib/edicus/resource-api.ts<br/>createResourceApiClient"]
      mw["middleware.ts (인증 가드)"]
    end
  end

  subgraph external["외부 경계 노드"]
    direction TB
    sdkiframe["Edicus SDK iframe<br/>window.edicusSDK / edicus-sdk-v2.js<br/>origin: edicusbase.firebaseapp.com"]
    edicussrv["Edicus Server/Order API<br/>(EDICUS_API_HOST)"]
    resourcesrv["Edicus Resource API<br/>(EDICUS_RESOURCE_HOST)"]
    fbauth["Firebase Auth<br/>(NEXT_PUBLIC_FIREBASE_*)"]
    s3note["S3 / presigned 업로드<br/>(코드 경계 밖 — SDK 내부 추정)"]
  end

  pages -->|use| hooks
  hooks -->|useEdicus·useHuniEditor| clientlib
  hooks -->|useAuth| fbclient
  hooks -->|useOrder · fetch| apiroutes
  pages -->|RSC/client fetch| apiroutes

  clientlib -->|init/create_project/open_project/post_to_editor| sdkiframe
  fbclient -->|signIn/onAuthStateChanged| fbauth

  apiroutes -->|getToken·projects·orders| serverapi
  apiroutes -->|getProductList·queryTemplates| resourceapi
  apiroutes -.->|직접 fetch 프록시 resource/* · auth/staff| edicussrv
  serverapi -->|edicus-api-key 헤더| edicussrv
  resourceapi -->|edicus-api-key 헤더| resourcesrv
  mw -.->|__session 쿠키 검사| pages

  sdkiframe -.->|업로드는 SDK 내부| s3note

  classDef int fill:#E8E2FB,stroke:#5538B6,color:#1c1340;
  classDef ext fill:#FFF3E0,stroke:#E08A00,color:#5a3a00;
  classDef boundary fill:#FDE2E2,stroke:#C62828,color:#5a0d0d;
  class pages,hooks,clientlib,fbclient,apiroutes,serverapi,resourceapi,mw int;
  class sdkiframe,edicussrv,resourcesrv,fbauth ext;
  class s3note boundary;
```

**추적 메모**
- 브라우저→SDK iframe: `EdicusClient`가 `window.edicusSDK.init({base_url})`을 호출(`client.ts:158`). iframe origin은 `edicusbase.firebaseapp.com`(`huni-editor-sdk.ts:17`; `data-flow.md:99`). `base_url`은 SDK config 키(`SDK PDF p.3`).
- 서버→Edicus Server API: `createServerApiClient`(`server-api.ts:35`)가 `EDICUS_API_HOST` 기반으로 `/api/auth/token`·`/api/projects/*`·`/api/order/*` 호출. 공통 헤더 `edicus-api-key`(`Server API PDF p.1`).
- 서버→Resource API: `createResourceApiClient`(`resource-api.ts:27`)가 `EDICUS_RESOURCE_HOST` 기반 `/resapi/product/list`·`/resapi/query`(`Resource PDF p.18, p.28`).
- Firebase: 클라 web SDK 직접 초기화(`config.ts:21`), env=`NEXT_PUBLIC_FIREBASE_*`. (env-mapping.md의 `EDICUS_FIREBASE_*` 6종은 Edicus가 Firebase 호스팅 기반이라 별도 존재 — `env-mapping.md:19-24`.)
- env 키: `EDICUS_API_HOST`·`EDICUS_RESOURCE_HOST`·`EDICUS_API_KEY`·`EDICUS_PARTNER_CODE`·`EDICUS_BASE_HOST`(=base_url) — `env-mapping.md:11-18`. `EDICUS_API_KEY`는 **서버 전용·절대 클라 노출 금지**(`env-mapping.md:12,40`).
- `%% 불일치` 성격: S3/presigned 업로드는 본 코드에서 직접 참조 없음 — Edicus iframe SDK 내부 책임으로 추정되며 코드 경계 밖(`data-flow.md:105`). 따라서 점선 boundary 노드로만 표기(없는 화살표 창작 금지).

---

## B. 라우트 맵 (App Router · 보호 라우트 표시)

전 라우트는 `RootLayout`(`layout.tsx:29`, html lang=ko)을 공유한다. **루트에 QueryClientProvider·zustand Provider 없음**(`module-map.md:50`). 미들웨어는 `/admin/*`·`/editor/*`를 `__session` 쿠키 **존재 여부만**으로 보호한다(`middleware.ts:9-12,23-28`). 페이지 21종 + API route 10종.

```mermaid
flowchart TD
  root["RootLayout (layout.tsx:29)"]

  subgraph public["공개 페이지"]
    home["/ 홈 RSC<br/>page.tsx:26 · category 필터"]
    login["/login (client)<br/>login/page.tsx:9"]
    register["/register (client)<br/>register/page.tsx:10"]
    projects["/projects 내 프로젝트 RSC<br/>projects/page.tsx:44"]
    orders["/orders 주문내역 RSC<br/>orders/page.tsx:48"]
  end

  subgraph protected["보호 라우트 (middleware.ts:9-12)"]
    editor["/editor/[templateId] RSC<br/>EdicusEditor · page.tsx:22"]
    adminroot["/admin 대시보드 (client)<br/>admin/page.tsx:49"]
    adminsub["/admin/{orders,products,templates,<br/>templates/[id],settings,assets,billing,<br/>insights,profile,shipping,shop,sms,stats}"]
  end

  subgraph editors["편집기 (동적)"]
    vdp["/vdp/[templateId] RSC<br/>VdpEditor · vdp/page.tsx:21"]
  end

  subgraph mobile["모바일 (mobile/layout.tsx)"]
    mcatalog["/mobile 카탈로그 (client)<br/>mobile/page.tsx:23"]
    mdetail["/mobile/[productId] (client)<br/>MobileEditor · :27"]
  end

  root --> home & login & register & projects & orders
  root --> editor & vdp
  root --> adminroot --> adminsub
  root --> mcatalog --> mdetail

  classDef pub fill:#E3F2FD,stroke:#1565C0,color:#0d2b4d;
  classDef prot fill:#FDE2E2,stroke:#C62828,color:#5a0d0d;
  classDef edit fill:#E8E2FB,stroke:#5538B6,color:#1c1340;
  classDef mob fill:#E8F5E9,stroke:#2E7D32,color:#13340d;
  class home,login,register,projects,orders pub;
  class editor,adminroot,adminsub prot;
  class vdp edit;
  class mcatalog,mdetail mob;
```

**추적 메모**
- 보호 패턴: `/admin/*`·`/editor/*`(`middleware.ts:9-12`). 미인증 시 `/login?redirect=`로 리다이렉트(`middleware.ts:32-35`). 인증 라우트(`/login`·`/register`)에 로그인 사용자 접근 시 `/admin`으로(`middleware.ts:15,40-42`). **`/vdp/*`·`/mobile/*`는 matcher 보호 대상 아님**(matcher는 `/admin`·`/editor`만; `middleware.ts:9-12,50-58`) — 위 그래프에서 vdp/mobile을 보호 박스 밖에 둔 이유.
- 인증 판정은 Edge Runtime이라 토큰 유효성 검증 없이 쿠키 존재만 본다 — 실제 검증은 API 라우트 책임(`middleware.ts:23-28`).
- 관리자 페이지 14종은 `admin/layout.tsx`(+Sidebar) 공유(`module-map.md:84-94`). `/admin/templates/[id]`는 동적 세그먼트.
- `/projects`·`/orders`·`/editor/[templateId]`·`/vdp/[templateId]`는 각각 `error.tsx`·`loading.tsx` 동봉(`module-map.md:62,71`).
- 페이지 수 집계: 공개 5 + 편집기 2 + 모바일 2 + admin 14(대시보드 1 + 서브 13) = 23 라우트(이 중 admin 14·동적 세그먼트 3개 포함). README 명세 "페이지 21+"와 정합 범위.

---

## API route 인벤토리 (10종 · `module-map.md:103-118`)

| 라우트 | 메서드 | 위임 | 근거 |
|---|---|---|---|
| `/api/edicus/auth` | POST | `server-api.getToken(uid)` | `auth/route.ts:29-30` |
| `/api/edicus/auth/staff` | POST | 직접 fetch `EDICUS_API_HOST/api/auth/staff/token` | `auth/staff/route.ts:34-41` |
| `/api/edicus/projects` | GET/POST/DELETE | `server-api.getProjects` 등 | `projects/route.ts:42,65,89` |
| `/api/edicus/orders` | POST/DELETE | `tentativeOrder`/`definitiveOrder`/`cancelOrder` | `orders/route.ts:41-42,66` |
| `/api/edicus/products` | GET | `resource-api.getProductList` | `products/route.ts:30` |
| `/api/edicus/templates` | GET | `resource-api.queryTemplates` | `templates/route.ts:37` |
| `/api/edicus/css` | GET/POST | `getCssForPartner` (POST=미저장 stub) | `css/route.ts:35,61-63` |
| `/api/edicus/resource/[id]` | GET | 직접 fetch `RESOURCE_HOST/resapi/resource/:id` | `resource/[id]/route.ts:50` |
| `/api/edicus/resource/products` | GET | 직접 fetch `/resapi/product/list` | `resource/products/route.ts:53` |
| `/api/edicus/resource/query` | POST | 직접 fetch `/resapi/query` | `resource/query/route.ts:53` |

비밀값 경계: `EDICUS_API_KEY`·스태프 자격증명은 서버 라우트 내에서만 사용, 응답 비포함(`module-map.md:120`).
