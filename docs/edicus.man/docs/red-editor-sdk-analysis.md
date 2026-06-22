# RedEditorSDK 분석 문서

Edicus 에디터 통합을 위한 RedEditorSDK(v6.6.48) 및 EdicusSDK v2 분석 결과입니다.

---

## 1. 모듈 구조 다이어그램

```
RedEditorSDK.js (615KB, 17,957줄)
│
├── 레이어 1: Babel 런타임 헬퍼 (1~90줄)
│   └── src/lib/red-editor/analyzed/babel-helpers.js
│       ├── _slicedToArray()    - 구조분해 할당 지원
│       ├── _extends()          - Object.assign 폴리필
│       ├── _createClass()      - ES5 클래스 메서드 정의
│       ├── _typeof()           - Symbol 지원 typeof
│       ├── _toConsumableArray() - 스프레드 연산자 지원
│       ├── _defineProperty()   - Object.defineProperty 래퍼
│       └── _classCallCheck()   - new 키워드 강제
│
├── 레이어 2: Sentry 유사 오류 보고 (91~800줄)
│   └── src/lib/red-editor/analyzed/error-reporting.js
│       ├── Severity 열거형     - Fatal/Error/Warning/Info/Debug/Critical
│       ├── Status 열거형       - Unknown/Skipped/Success/RateLimit/Invalid/Failed
│       ├── SentryError 클래스  - 커스텀 오류 기반 클래스
│       ├── 타입 체크 유틸리티  - isError, isString, isPlainObject 등
│       ├── uuid4()            - 고유 이벤트 ID 생성
│       ├── htmlTreeAsString()  - DOM 트리를 CSS 선택자로 표현
│       └── getElementSelector() - 엘리먼트 CSS 선택자 생성
│
├── 레이어 3: 핵심 SDK 인프라 (800~3800줄)
│   └── src/lib/red-editor/analyzed/core-utils.js
│       ├── SyncPromise        - 동기 실행 가능한 Promise
│       ├── PromiseBuffer      - 비동기 작업 큐 (동시 처리 수 제한)
│       ├── Scope              - 이벤트 컨텍스트 저장 (user, tags, extras)
│       ├── Hub                - 클라이언트/범위 스택 관리 (싱글턴)
│       ├── BaseTransport      - 이벤트 전송 추상 클래스
│       ├── FetchTransport     - Fetch API 기반 전송
│       ├── XHRTransport       - XMLHttpRequest 기반 전송 (폴백)
│       ├── BaseClient         - 이벤트 처리 파이프라인
│       ├── BrowserClient      - 브라우저 특화 클라이언트
│       └── Integrations       - InboundFilters, TryCatch, Breadcrumbs 등
│
└── 레이어 4: RedEditorSDK 클래스 (14400~17957줄)
    └── src/lib/red-editor/analyzed/red-editor-class.js
        ├── createProject()        - 프로젝트 생성
        ├── openProject()          - 프로젝트 열기
        ├── on()                   - 이벤트 리스너 등록
        ├── editorEventHandler()   - postMessage 이벤트 처리
        ├── getEntities()          - VDP 엔티티 조회
        ├── getNoStocksInfo()      - 재고 없음 정보 조회
        ├── save/close/destroy()   - 에디터 제어
        └── 기타 API 메서드들
```

---

## 2. 퍼블릭 API 레퍼런스

### RedEditorSDK (v6.6.48)

| 메서드 | 파라미터 | 반환값 | 설명 |
|--------|----------|--------|------|
| `constructor(config)` | `RedEditorSDKConfig` | - | SDK 초기화 |
| `createProject(productInfo, options)` | `{psCode}`, `{container}` | `Promise<void>` | 새 프로젝트 생성 |
| `openProject(projectId, options)` | `string`, `{container}` | `Promise<void>` | 기존 프로젝트 열기 |
| `on(eventType, callback)` | `string`, `Function` | `void` | 이벤트 리스너 등록 |
| `close()` | - | `void` | 에디터 닫기 |
| `save()` | - | `Promise<void>` | 저장 |
| `saveThenClose()` | - | `Promise<void>` | 저장 후 닫기 |
| `destroy()` | - | `void` | SDK 인스턴스 제거 |
| `getEntities(dataMap, templateList)` | `Object`, `Template[]` | `VDPEntity[]` | VDP 엔티티 조회 |
| `getNoStocksInfo(items)` | `Object[]` | `Promise<string[]>` | 재고 없음 정보 |
| `getProjectList()` | - | `Promise<ProjectInfo[]>` | 프로젝트 목록 |
| `getProductInfo(psCode)` | `string` | `Promise<ProductInfo>` | 상품 정보 |
| `prepareOrder(orderInfo)` | `Object` | `Promise<Object>` | 주문 준비 |
| `remoteEditor(action, data)` | `string`, `Object` | `Promise<unknown>` | 원격 명령 전송 |
| `setToken(token)` | `string` | `void` | 토큰 갱신 |
| `setUserId(userId)` | `string` | `Promise<void>` | 사용자 ID 설정 |
| `setPrice(price)` | `number\|string` | `void` | 가격 설정 (VDP) |
| `checkOrderable()` | - | `Promise<boolean>` | 주문 가능 여부 |
| `getCustomTabInfo()` | - | `CustomTabInfo` | 커스텀 탭 정보 |
| `whetherUsePalette()` | - | `boolean` | 팔레트 사용 여부 |

### EdicusSDK v2 (레거시)

| 메서드 | 파라미터 | 반환값 | 설명 |
|--------|----------|--------|------|
| `init(config)` | `{base_url}` | `EdicusContext` | SDK 초기화 |
| `ctx.create_project(params, callback)` | `CreateProjectParams`, `Function` | `void` | 프로젝트 생성 |
| `ctx.open_project(params, callback)` | `OpenProjectParams`, `Function` | `void` | 프로젝트 열기 |
| `ctx.close(params)` | `{parent_element}` | `void` | 에디터 닫기 |
| `ctx.destroy(params)` | `{parent_element}` | `void` | SDK 종료 |
| `ctx.post_to_editor(message)` | `EditorMessage` | `void` | 에디터에 메시지 전송 |

### 지원하는 이벤트 타입

| 이벤트 | 발생 시점 | 콜백 데이터 |
|--------|-----------|-------------|
| `close` | 에디터 닫힐 때 | - |
| `request-user-token` | 토큰 갱신 필요 시 | `{userId}` |
| `goto-cart` | 장바구니 이동 요청 | `{cartData}` |
| `save` | 저장 완료 시 | `{projectId}` |
| `init` | 에디터 초기화 완료 | - |
| `refreshToken` | 토큰 갱신 완료 | `{token}` |

---

## 3. VDP(Variable Data Printing) 기능 설명

### VDP란?

VDP는 **Variable Data Printing(가변 데이터 인쇄)**의 약자입니다. 동일한 인쇄 템플릿에 각기 다른 데이터를 삽입하여 개인화된 인쇄물을 대량으로 생성하는 기능입니다.

예시:
- 명함: 이름, 직함, 연락처가 각기 다른 수백 장의 명함을 한 번에 주문
- 청첩장: 초대받는 사람 이름이 다른 청첩장 대량 인쇄
- 포장지: 상품별로 다른 바코드/QR코드가 인쇄된 포장지

### varMap 구조

`varMap`은 VDP 변수를 실제 데이터 값에 매핑하는 딕셔너리입니다:

```javascript
const varMap = {
  $TMPL: "https://storage.example.com/templates/template-001.json", // 템플릿 URL
  $PSCD: "PROD-NAME-CARD-001",  // 상품 코드
  $PRCE: "15000",                // 가격
  // 사용자 정의 변수...
};
```

### 엔티티 타입

SDK는 두 가지 엔티티 타입을 처리합니다:

1. **`uniform-select`**: 모든 아이템이 동일한 옵션을 선택
   - 예: 전체 명함이 동일한 용지 종류

2. **`individual-select`**: 아이템별로 다른 옵션 선택
   - 예: 각 담당자가 자신의 직급에 맞는 템플릿 선택

### 재고 없음(No Stock) 처리

`getNoStocksInfo()` 메서드는 `HIDE_YN: "Y"` 표시된 품절/숨김 상품을 처리합니다:

```javascript
// 재고 없음 태그 문자열 형식
// "변수1:값1/변수2:값2"
const noStockTags = await sdk.getNoStocksInfo(productItems);
// 예: ["color:red/size:M", "color:blue/size:L"]
```

예외 조건(exceptions)에 해당하는 항목은 재고 없음으로 분류하지 않습니다.

---

## 4. Next.js 통합 가이드

### 4.1 설치 및 설정

```typescript
// src/lib/red-editor/index.ts
export { RedEditorWrapper, getOrCreateWrapper, waitForEvent } from './wrapper';
export type {
  RedEditorWrapperOptions,
  EditorEventHandlers,
  CreateProjectOptions,
} from './wrapper';
```

### 4.2 React 컴포넌트에서 사용

```typescript
// app/components/EditorContainer.tsx
"use client";

import { useEffect, useRef, useCallback } from "react";
import { RedEditorWrapper } from "@/lib/red-editor/wrapper";
import { useRouter } from "next/navigation";

interface EditorContainerProps {
  projectId?: string;       // 기존 프로젝트 열기용
  productCode?: string;     // 새 프로젝트 생성용
  accessToken: string;
  userId: string;
}

export default function EditorContainer({
  projectId,
  productCode,
  accessToken,
  userId,
}: EditorContainerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const wrapperRef = useRef<RedEditorWrapper | null>(null);
  const router = useRouter();

  useEffect(() => {
    if (!containerRef.current) return;

    // SDK 래퍼 초기화
    const wrapper = new RedEditorWrapper({
      accessToken,
      userId,
      sandboxMode: process.env.NODE_ENV !== "production",
      // scriptUrl: "https://cdn.example.com/RedEditorSDK.js", // 외부 CDN 사용 시
    });

    wrapperRef.current = wrapper;

    (async () => {
      try {
        await wrapper.initSDK();

        // 이벤트 핸들러 설정
        wrapper.setupEventHandlers({
          onClose: () => {
            router.push("/");
          },
          onGotoCart: (data) => {
            console.log("장바구니 이동:", data);
            router.push("/cart");
          },
          onSave: ({ projectId: savedId }) => {
            console.log("저장 완료:", savedId);
          },
        });

        // 에디터 열기
        if (projectId) {
          await wrapper.openProject(projectId, {
            container: containerRef.current!,
          });
        } else if (productCode) {
          await wrapper.createProject(
            { psCode: productCode },
            { container: containerRef.current! },
          );
        }
      } catch (error) {
        console.error("에디터 초기화 실패:", error);
      }
    })();

    return () => {
      wrapper.destroy();
    };
  }, []);

  return (
    <div
      ref={containerRef}
      style={{ width: "100%", height: "100vh" }}
    />
  );
}
```

### 4.3 환경변수 설정

```bash
# .env.local
NEXT_PUBLIC_EDICUS_ACCESS_TOKEN=your-access-token
NEXT_PUBLIC_EDICUS_SANDBOX=true  # 개발 환경
```

### 4.4 Server Component에서 토큰 가져오기

```typescript
// app/editor/page.tsx (Server Component)
import EditorContainer from "@/components/EditorContainer";
import { getServerSession } from "next-auth";

export default async function EditorPage({
  searchParams,
}: {
  searchParams: { projectId?: string; productCode?: string };
}) {
  const session = await getServerSession();

  // 서버에서 안전하게 토큰 발급
  const accessToken = await issueEditorToken(session.user.id);

  return (
    <EditorContainer
      projectId={searchParams.projectId}
      productCode={searchParams.productCode}
      accessToken={accessToken}
      userId={session.user.id}
    />
  );
}
```

### 4.5 VDP 기능 통합 예시

```typescript
// VDP 상품 커스텀 탭 처리 예시
async function handleCustomTab(wrapper: RedEditorWrapper) {
  const customTabInfo = wrapper.getCustomTabInfo();

  // 팔레트 사용 여부 확인
  if (wrapper.getSDK().whetherUsePalette()) {
    // 색상 선택 UI 표시
  }

  // 재고 없음 항목 확인
  if (customTabInfo.entities) {
    const productItems = customTabInfo.entities.map(e => ({
      HIDE_YN: e.varMap?.$PSCD ? "N" : "Y",
      // ... 기타 상품 속성
    }));

    const noStockTags = await wrapper.getNoStocksInfo(productItems);
    console.log("품절 항목:", noStockTags);
  }

  // VDP 엔티티 목록 가져오기
  const entities = wrapper.getEntities(
    dataMap,     // 상품 데이터 맵
    templateList // 사용 가능한 템플릿 목록
  );
}
```

---

## 5. 아키텍처 고려사항

### SSR 안전성

RedEditorSDK는 `window` 객체에 의존하는 브라우저 전용 라이브러리입니다. Next.js에서는 반드시 다음 방법 중 하나를 사용하세요:

1. **`"use client"` 지시어** + `useEffect` 내에서 초기화
2. **동적 import** 사용: `import dynamic from 'next/dynamic'`
3. **wrapper.ts**의 `isBrowser()` 검사 활용

### 스크립트 로딩 전략

SDK가 외부 CDN에서 로드되는 경우 `loadScript()` 유틸리티를 사용합니다:

```typescript
// 중복 로드 방지 (캐시 기반)
await loadScript("https://cdn.example.com/RedEditorSDK.js");
```

### Sentry 모니터링

SDK는 내부적으로 Sentry 유사 오류 보고 시스템을 사용합니다:

- DSN: `https://d574a33afd6c41cfb5f1afddc2110603@logging.betterwaysystems.com/1`
- 릴리즈: `v6.6.48`
- 오류 이벤트를 자동으로 캡처하여 개발팀에 보고합니다

---

## 6. 분석 파일 목록

| 파일 | 설명 |
|------|------|
| `src/lib/red-editor/analyzed/formatted.js` | Prettier로 포맷된 원본 SDK |
| `src/lib/red-editor/analyzed/es6-converted.js` | lebab으로 ES6+ 변환 시도 결과 |
| `src/lib/red-editor/analyzed/babel-helpers.js` | 레이어 1: Babel 헬퍼 함수 (한국어 JSDoc) |
| `src/lib/red-editor/analyzed/error-reporting.js` | 레이어 2: 오류 보고 시스템 (한국어 JSDoc) |
| `src/lib/red-editor/analyzed/core-utils.js` | 레이어 3: 핵심 유틸리티 (한국어 JSDoc) |
| `src/lib/red-editor/analyzed/red-editor-class.js` | 레이어 4: SDK 메인 클래스 (한국어 JSDoc) |
| `src/lib/red-editor/red-editor-sdk.d.ts` | TypeScript 타입 선언 |
| `src/lib/red-editor/wrapper.ts` | Next.js 안전 래퍼 |

### lebab 변환 결과

성공한 변환:
- `arrow`: 일부 화살표 함수 변환 (arguments 사용 없는 경우)
- `obj-method`: 객체 메서드 단축 표기
- `obj-shorthand`: 객체 속성 단축 표기
- `no-strict`: `"use strict"` 제거
- `template`: 템플릿 리터럴 변환 가능한 경우

실패한 변환:
- `let`: 내부 라이브러리 오류로 실패 (`variable.markModified is not a function`)
- `for-of`: `let/const` 변환 없이 적용 불가
- `class`: 원본 이미 ES5 클래스 패턴이라 복잡한 변환 필요
