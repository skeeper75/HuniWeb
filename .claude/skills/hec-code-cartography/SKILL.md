---
name: hec-code-cartography
description: 후니 Edicus 코드맵 하네스(Huni-Edicus-Codemap)의 edicus.man Next.js 코드베이스 정적 분석 방법론. src/app(App Router 라우트)·src/hooks(useEdicus/useHuniEditor/useAuth/useOrder)·src/components·src/types·middleware·zustand/react-query/firebase를 Read/Grep으로 직접 읽어 모듈 의존 그래프·라우트맵·hook↔Edicus SDK 호출 배선(파일:라인)·데이터 흐름·외부연동 경계를 코드맵으로 추출한다. 코드=권위·라이브 실행 불요·읽기전용. 트리거: 코드맵 분석, Next.js 아키텍처, 훅 분석, 라우트 맵, 모듈 의존성, 데이터 흐름 추출, 상태관리 분석, 코드맵 다시. API 계약은 hec-api-cartography, mermaid 집필은 hec-flow-authoring, 검증은 hec-flow-validation.
---

# hec-code-cartography — edicus.man 코드맵 분석 방법론

## 목적
개발팀이 의존할 **코드맵**을 `docs/edicus.man` Next.js 코드에서 정적 분석으로 추출한다.

## 권위
- `docs/edicus.man/src/**`(코드=권위)·`package.json`·`next.config.ts`·`middleware.ts`.
- `README.md`(기존 아키텍처 목차)·`docs/deployment-guide.md` — 출발점, 코드와 불일치 시 코드 우선(불일치 기록).

## 분석 레이어
1. **라우트 맵** — `src/app/` App Router: projects·admin·vdp·mobile·orders·login·register·editor의 page/layout/error/loading 역할·동적 세그먼트.
2. **hooks** — `useEdicus`·`useHuniEditor`·`useAuth`·`useOrder`: 각 hook의 책임·상태·반환 + 호출하는 SDK 메서드/Server API/Firebase.
3. **components** — ui·products·auth·admin·mobile(PassiveToolbar·MobileEditor)·orders·editor(PCPassiveEditor) 트리·책임.
4. **types** — `src/types/edicus.ts`·`order.ts` 도메인 모델.
5. **상태관리** — zustand store·react-query 쿼리/뮤테이션·firebase 연동 지점.
6. **middleware** — `src/middleware.ts`(인증·라우팅 가드).

## Edicus 호출 배선 식별[핵심]
hook/component에서 Edicus를 호출하는 지점을 grep으로 전수 식별:
```
grep -rn "edicusSDK\|post_to_editor\|create_project\|open_project\|init(\|addEventListener\|postMessage\|access.*token" docs/edicus.man/src
```
각 지점을 {호출 심볼, 대응 SDK 메서드/이벤트, 파일:라인}으로 기록 → flow-author가 코드↔API 배선도를 그리는 근거.

## 외부 연동 경계
Edicus 서버·Firebase·S3·HUNI_BFF 등은 경계 노드(내부 구현 아님)로 표시.

## 핵심 규칙
- 코드 직접 Read/Grep(README 설명만 믿지 말 것).
- 모든 사실에 `파일:라인` 근거.
- 미구현·.gitkeep만 있는 빈 디렉토리(vdp·editor 등)는 "스캐폴드(미구현)"로 정직 표기.

## 산출
`_workspace/huni-edicus-codemap/02_codemap/`: module-map.md·hooks-and-edicus-wiring.md·data-flow.md·code-facts.csv
