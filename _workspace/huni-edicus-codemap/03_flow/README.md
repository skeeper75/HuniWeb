# Edicus 코드맵 — 개발팀 기술 문서 (03_flow)

후니 `edicus.man`(Next.js 15 App Router 앱)이 **Edicus 편집기 SDK·Edicus 서버 API·Firebase**와 어떻게 배선되는지를, **코드(`02_codemap/`) ↔ API 계약(`01_api/`)** 두 팩을 종합해 mermaid로 도해한 개발팀용 문서다. 핵심 가치=**어느 코드가 어느 SDK 메서드/Server API를 호출하는가**(코드↔API 배선).

> 권위[HARD]: 두 팩에 있는 사실만. 코드↔계약 불일치는 `%% 불일치:` 주석으로 명시. 모든 도해에 `파일:라인`·SDK 메서드·`PDF p.N`·env 키 병기. 비밀값은 키 이름만(값 비노출).

---

## 목차 / 다이어그램 링크

### [00_architecture.md](./00_architecture.md) — 아키텍처 & 라우트 맵
- **A. 시스템 아키텍처** `flowchart` — 내부(Next 앱: 브라우저/서버) vs 외부 경계(Edicus SDK iframe·Server/Resource API·Firebase·S3). subgraph + classDef.
- **B. 라우트 맵** `flowchart TD` — 페이지 21+ / API route 10, 보호 라우트(`/admin`·`/editor`) 표시.
- API route 인벤토리 표(10종).

### [01_flows.md](./01_flows.md) — 플로우
- **A. end-to-end** `sequenceDiagram` — 인증→상품선택→편집→주문 (User·NextApp·useEdicus/EdicusClient·EdicusSDK iframe·EdicusServer·Firebase).
- **B. 패시브 모드 라이프사이클** `stateDiagram-v2` — ready-to-listen→load-project-report→doc-changed→editing→save-doc-report→close.
- **C. 주문 상태머신** `stateDiagram-v2` — editing→ordering→ordered(+cancel·render).

### [02_code-api-wiring.md](./02_code-api-wiring.md) — 코드↔API 배선도 (핵심)
- **A. 클라 배선** `flowchart LR` — 4 hook + 편집기 3변형 → SDK 메서드.
- **B. 서버 배선** `flowchart LR` — API route → server-api/resource-api → Edicus 서버.
- **C. 인증 배선** `flowchart LR` — useAuth → Firebase + Edicus 토큰.
- **D-pre. 패시브 채널 배선** `flowchart LR` — 공식 from-edicus 실배선 vs KOI-Passive 잔재.
- **D. 코드↔계약 불일치 종합표**(10건).

### [03_passive-layers.md](./03_passive-layers.md) — 두 패시브 레이어 & 후니 채택 (역공학 양면)
- **A. 두 레이어 비교** `flowchart` — Edicus 공식 from-edicus **14 action** vs RedEditorSDK KOI-Passive **4 type**(load/save/error/close), 14→4 N:1 매핑 엣지.
- **B. KOI-Passive 트리거 체인** `flowchart` + `sequenceDiagram` — `fromKOIPassive`/`hideToolbar`→`K.mode=passive`→`run_mode=passive`→`From-KOI-Passive`→load/save/error/close.
- **C. 후니 채택 경로** `flowchart` — **후니=공식 from-edicus 14 action**(전 모듈 `data.action ?? data.type`), KOI는 `src/lib/red-editor/` **잔재**(점선).

> **두 패시브 레이어 요약**: ① **Edicus 공식**(`from-edicus`, 14 action·세밀 상태머신) ② **RedEditorSDK KOI-Passive**(`From-KOI-Passive`, 4 type·게이트웨이가 14를 N:1 재포장). **후니 edicus.man 런타임은 ①을 직접 사용**(식별 키 `data.action ?? data.type`, passive 진입 `run_mode='passive'`); ②는 `src/lib/red-editor/analyzed/*`에만 존재하는 **역공학 잔재**(import 0건).

---

## 개발팀 온보딩 — 어디부터 읽나

1. **전체 그림**: `00_architecture.md` A를 먼저 본다. 우리 코드(내부)와 손댈 수 없는 외부(Edicus·Firebase)의 경계를 먼저 머리에 넣는다. 비밀값(`EDICUS_API_KEY`)은 **서버에서만** 쓴다는 [HARD] 규칙이 출발점.
2. **요청 한 번의 여정**: `01_flows.md` A 시퀀스로 로그인→상품→편집→주문의 한 흐름을 따라간다. 편집기는 `useEdicus`→`EdicusClient`→`window.edicusSDK`(iframe)로 수렴한다.
3. **편집기 기능을 만질 때**: `01_flows.md` B(패시브 라이프사이클)로 콜백 action enum과 save/token 전이를 본다. 코드 진입점은 `MobileEditor`·`PCPassiveEditor`·`HuniEditorSDK`. **패시브가 두 레이어(공식 14 action vs KOI 4 type)임을 먼저 알아야 한다** — `03_passive-layers.md`에서 후니가 공식 from-edicus를 따른다는 결론과 KOI는 잔재임을 확인한다(역공학 레퍼런스에서 4 type을 보고 후니 코드에서 못 찾는 함정 방지).
4. **API를 호출/추가할 때**: `02_code-api-wiring.md` A·B에서 hook↔route↔Edicus 엔드포인트 사슬을 확인한다. 모든 노드에 `파일:라인`이 있어 코드로 바로 점프 가능.
5. **버그를 만나면**: `02_code-api-wiring.md` D 불일치표를 먼저 본다. 토큰 발급 400 위험(#2)·useOrder 서브경로 부재(#3)·css POST stub(#5)·zustand/react-query 미사용(#1) 등 이미 알려진 함정이 정리돼 있다.

## 입력 출처
- API 계약: `01_api/sdk-method-catalog.md`·`server-api-catalog.md`·`passive-mode-events.md`·`env-mapping.md` (권위=Edicus JS SDK / Server API PDF).
- 코드맵: `02_codemap/module-map.md`·`hooks-and-edicus-wiring.md`·`data-flow.md`·`code-facts.csv` (권위=`docs/edicus.man/src/**` 직접 분석).

## 주의 (불일치 빠른 참조)
- **README(edicus.man) ≠ 실코드**: zustand/react-query는 미사용(로컬 useState+RSC/fetch). NextAuth 미도입(Firebase 직접).
- **토큰 발급 body**: 4개 편집기는 body 없이 POST → `uid` 필수 라우트와 충돌(400 위험). `useAuth`만 `{uid}` 전달.
- **RedEditorWrapper**: 미배선(역공학 잔재). 런타임=`window.edicusSDK`.
- **패시브 두 레이어**: 후니=**공식 from-edicus 14 action**(`data.action ?? data.type`·`run_mode='passive'`). RedEditorSDK **KOI-Passive 4 type**(`From-KOI-Passive` load/save/error/close)은 `src/lib/red-editor/analyzed/*`에만 — **잔재**. 4 type을 후니 코드에서 찾지 말 것(→ `03_passive-layers.md`).
- **S3/presigned**: 본 코드 경계 밖(Edicus SDK 내부 추정).

전체 상세·라인 근거는 각 문서 본문 참조.
