# Phase D QA Report — Huni-Widget (PRBKYPR 무선 책자)

- 검증 도구: Playwright + 설치된 Chrome 채널 (headless, 실 브라우저 렌더 — 조작·날조 없음)
- 대상(우리): `http://localhost:5173/` (vite dev, `04_build/index.html` → `init(#host, {productCode:'PRBKYPR'})`)
- 레퍼런스(Red): `http://localhost:3001/` (widget_monitor 라이브 테스트베드). **본 패스 도중 `extract-cookies.cjs`로 토큰 재발급 성공** → Red 라이브 가격 200 응답 확인.
- 호스트 공격 CSS: `body{font-size:12px;font-family:Times}`, `button{background:red;border-radius:9999px}`
- 캡처: `05_qa/captures/{phaseD_counters.png, phaseD_editor_open.png, phaseD_cascade.png, phaseD_red_render.png}`
- 분류: Phase-D 동작 QA (Pass-1 SMOKE 이후 D단계: 카운터·캐스케이드·업로드·에디터·canOrder)
- 데이터소스: 우리=BFF stub(Red 어댑터+fixture). 실 S3/Edicus 토큰체인 미수행(stub 한계 명시).

---

## 요약 판정: GO (F/G + Figma 진행 가능)

Phase D의 6개 검증 포인트 + 10항목 체크리스트 모두 PASS. Pass-1의 치명 결함 **D1(카운터 미렌더)이 해소**됐고, **"Invalid hook call" 경고가 사라짐(dedupe 수정 확인)**. 잔존 결함은 모두 LOW/TRIVIAL(stub 한계 또는 콘솔 청결도). 차단 결함 0건.

---

## 1. D1 — 카운터 렌더 + 재계산 — **PASS**

### 렌더 (Pass-1 D1 해소 확인)
실측(`phaseD_counters.png` + DOM 프로브):

| 항목 | 실측 |
|------|------|
| `button[aria-label="감소"]` | 2개 |
| `button[aria-label="증가"]` | 2개 |
| `input[inputmode="numeric"]` | 2개, 값 `["30","10"]` |
| 라벨 `수량` | 렌더됨 (값 30 = DFT_PRN_CNT) |
| 라벨 `내지 장수` | 렌더됨 (값 10 = MIN_INN_PAGE), border-2 보라 강조(RULE-3 page variant) |

스크린샷에서 두 카운터 모두 223×50 3-part `[− | 값 | +]` 직사각형. 원형/native-number 아님. **Pass-1 D1(`mapOptionGroups`가 quantity/innerPage 그룹 미생성) 해소됨** — `red-adapter.ts:234-273`이 `GRP_QUANTITY`(counter-input)·`GRP_INNER_PAGE`(page-counter-input)를 `inputSpec` 포함하여 push.

### 재계산 (debounced 발화)
- 초기 합계: **56,000원** (quantity=30, q30 fixture)
- 수량 입력 `130` → blur → 합계 **420,900원** (`changed:true`)
- 입력값이 `131`로 스냅(FIR=1, STEP=10 → 1+13×10=131, `widget-store.ts:168-172` snap 로직) — 재계산 + clamp/snap 동시 동작 확인
- `+` 버튼 클릭도 재계산 발화(`schedulePriceQuote` 호출 경로)

근거: `quantity>=120` 시 fixture가 q300으로 분기(`fixture-source.ts:39`)되어 가격이 변동 → **재계산 배선이 실제로 발화함을 가격 변화로 입증**. 디바운스 300ms(`widget-store.ts:95`) 후 BFF.price 호출.

**Red 비교**: Red도 동일 PRBKYPR에서 수량 변경 시 price API 호출(본 패스 토큰 재발급 후 price 200 확인). 우리와 동일한 "옵션/수량 변경→가격 재요청" 형태.

---

## 2. 캐스케이드 — **PASS** (Red와 동일 shape)

### 동작 실측 (`phaseD_cascade.png`)
- **BEFORE**: 코팅(COT_DFT) 3버튼(무광/유광/엠보) 전부 `disabled:false`, `aria-disabled:false`
- 조작: 내지 용지 select 열고 마지막 옵션 **"에스플러스 백색"(RXPLW100)** 선택 — 이 자재는 `disable_pcs_info`의 disable 트리거
- **AFTER**: 코팅 3버튼 전부 `disabled:true`, `aria-disabled:true`, opacity/cursor-not 클래스 적용

근거(fixture 교차검증): `RXPLW100`/`RXPLW080`(내지 자재)이 `COT_DFT`(코팅)·`MIS_DFT` PCS 그룹을 disable하는 룰 보유(`disable_pcs_info`). 캐스케이드 엔진(`cascade.ts:38-48`)이 **양 면(default+inner)의 자재 선택을 모두 모아** `activeMtrlIds` 산출 → 내지 자재가 표지측 코팅 그룹을 disable. 룰엔진 6종 중 material→pcs disable + UI disable + 선택해제 연쇄가 동작.

### 데이터 정직성 노트 (중요)
PRBKYPR fixture에서 **표지 자재(GRP_MTRL_COVER)는 값이 1종(RXART300)뿐이고, 그 코드는 어떤 disable 트리거도 아님**. 즉 표지 자재 변경으로는 캐스케이드가 안 보인다(값이 1개라 변경 불가 + 트리거 아님). 캐스케이드는 **내지 자재 변경 경로로만** 가시적으로 발화 가능 — 본 패스는 그 경로로 검증했다. 이는 코드 결함이 아니라 fixture 데이터의 구조(표지=고정 아트지, 내지=4종 중 2종이 트리거).

**Red 비교**: Red도 동일 `disable_pcs_info` 계약을 사용(우리 어댑터의 입력원). Red 위젯은 자재 선택 시 동일 종류의 후가공(코팅/미싱 등)을 비활성화하는 동일 패턴 — 우리 캐스케이드 shape이 Red와 일치(같은 disable 룰 테이블에서 파생).

---

## 3. PDF 업로드 진입 + 에디터 진입 분기 — **PASS**

실측(DOM + `phaseD_counters.png`):

| 면 | uploadType | 렌더 UI | 실측 |
|----|-----------|---------|------|
| 표지(default) | editor | "표지 편집하기" 버튼 | 렌더됨 |
| 내지(inner) | pdf | "내지 PDF 파일 업로드" 버튼 + `input[type=file]` | 렌더됨, accept=`application/pdf` |

`exterior.uploadType` 분기(`red-adapter.ts:59-60` 표지=editor/내지=pdf) → `OptionPanel.tsx:14-37 SideInput`이 면별로 다른 컴포넌트 렌더. 두 진입이 시각·동작 모두 distinct.

### presigned→PUT seam (BFF stub)
코드 경로 확인(`widget-store.ts:227-263 uploadPdf`): ① `bff.presigned()` → ② `putToS3()` 직접 PUT → ③ `bff.fileMeta()`. 3단 seam이 배선됨. **실 S3 PUT은 미수행**(stub) — fixture `presigned_response_sample.json` 보유. 플로우 트리거(파일 선택→uploadPdf)는 배선 확인, 실제 S3 왕복은 범위 외(stub 한계, 명시).

---

## 4. Edicus 에디터 진입 + origin 가드 — **PASS** (라이브+코드 혼합 검증)

### 오버레이 마운트 (Shadow 내부 포털) — 라이브 검증
"표지 편집하기" 클릭 → 실측(`phaseD_editor_open.png`):

| 항목 | 실측 |
|------|------|
| `[role="dialog"][aria-modal="true"]` in shadow | **있음** |
| `iframe[title="Edicus 편집기"]` in shadow | **있음** |
| `document.body`로 escape | **없음** (escapedToBody=false) |
| iframe src | `https://edicusbase.firebaseapp.com/ed#/editor_landing?cmd=create&token=…&ps_code=…` |
| sandbox | `allow-scripts allow-same-origin allow-forms allow-popups` |

**실 Edicus iframe이 실제 로드됨**(console: "app component start", "Landing Option {cmd: create, token: [REDACTED], ps_code: EDICUS_STUB@PRBKYPR}", "CONTEXT CREATED", "DIV host LANG ko"). Angular 앱이 부팅까지 진행. iframe URL 조립(`editor-bridge.ts:153-159`)·sandbox·**Shadow 내부 포털**(`EditorOverlay.tsx:50-77 createPortal(container)`)이 라이브로 동작.

### origin 가드 (allowlist) — 라이브 검증 (definitive)
오버레이 열린 상태에서 `from-edicus`/`goto-cart` 메시지를 origin별로 주입:

| 송신 origin | 결과 |
|-------------|------|
| `https://attacker.test` (비허용) | **무시** — 오버레이 그대로 열림, artifact 미생성 |
| `https://edicusbase.firebaseapp.com` (허용) | **처리** — 오버레이 닫힘, "표지 편집 완료 (다시 편집)" 라벨 전환, artifact 생성 |

`editor-bridge.ts:113` `if (!this.isAllowedOrigin(e.origin)) return;` 가 payload 파싱보다 먼저 실행되어 비허용 origin을 거부함을 **상태 변화 유무로 입증**. allowlist는 `EditorOverlay.tsx:35`에서 `[BASE_ORIGIN, EDITOR_HOST]` 주입.

### 라이브 검증 불가 영역 (명시)
- **토큰체인 전체**: iframe token=`FIXTURE_STUB_TOKEN`(stub) → 실 Edicus가 JWT 파싱 단계에서 `parseJwt ... reading 'replace'` 에러(에디터측, 우리 위젯 무관). 실 토큰체인(makers /token,/editor,/template/hit)은 BFF stub이라 미수행 — **에디터 풀 로드/실 프로젝트 생성은 라이브 검증 못함**.
- from-edicus 실 메시지(request-prod-info 핸드셰이크/save-doc-report/실 goto-cart)는 합성 MessageEvent로만 검증(실 Edicus가 토큰 없이 거기까지 못 감). e.source 라우팅은 합성 이벤트에서 source=null이라 origin 단독 검증됨(설계 의도와 일치).

---

## 5. canOrder / OrderCTA — **PASS**

| 상태 | reasons | 장바구니 버튼 |
|------|---------|---------------|
| 클린 초기(캐스케이드 전, 업로드 전) | `주문불가-파일` 만 | disabled(opacity-50 cursor-not-allowed) |
| 캐스케이드로 코팅 그룹 disable 후 | `주문불가-옵션 / 주문불가-파일` | disabled |

`selectCanOrder`(`widget-store.ts:322-345`) 검증:
- 모든 required·visible·非입력 그룹에 기본 선택값 존재(`defaultSelections`) → 클린 상태에서 `주문불가-옵션` 안 뜸(정상).
- 표지=editor면 projectId 필요, 내지=pdf면 storedFileName 필요 → 업로드 전이라 `주문불가-파일`(정상).
- 캐스케이드가 코팅(required+visible) 선택을 해제하면 즉시 `주문불가-옵션` 추가 → **캐스케이드↔canOrder 연동 정확**(결함 아님, 입력 완전성 반영).
- fixture에서 required+visible PCS = COT_DFT(코팅)·BIND_DIRECTION(제본방향) 2종 확인.

---

## 6. Pass-1 회귀 검사 — **PASS**

| 항목 | 결과 |
|------|------|
| Shadow DOM 격리 | 유지 — 호스트 red/pill/Times 누수 0건(`phaseD_counters.png` 시각 확인, 위젯 내부 직각·Noto Sans·보라 선택) |
| shadcn Portal-in-Shadow | 유지 — select Popover + EditorOverlay 모두 shadow 내부 렌더, body escape 없음 |
| **"Invalid hook call" 경고** | **사라짐** — console hookWarning 필터 결과 **0건** (`vite.config.ts:19 dedupe:['react','react-dom']` 수정 확인). Pass-1엔 명시 없었으나 dedupe seam이 React 단일 인스턴스 보장 → Radix가 위젯과 같은 React 사용 |
| Zustand deprecation 경고 | (Pass-1 D3) 본 패스 console.warnings엔 sandbox 경고만, zustand 경고 미관찰 — 개선되었거나 dev 경로 변화 |

---

## 7. 10항목 비교 체크리스트 (compare 하네스 §)

| # | 항목 | 우리 | Red 비교 |
|---|------|------|----------|
| 1 | 옵션 그룹 노출(사이즈·종이·도수·후가공·수량) | **PASS** — 14 라벨 전부 렌더 | Red 동일 PRBKYPR 마운트, 동일 그룹군 |
| 2 | 옵션 캐스케이드 | **PASS** — 내지자재→코팅 disable | Red 동일 disable_pcs 계약 사용, 동종 동작 |
| 3 | 가격 재계산 | **PASS** — 56,000→420,900원 | Red price API 200(토큰 재발급) |
| 4 | 수량 입력 3-part | **PASS** — 223×50 [−/값/+] ×2 | Red도 counter 형태 |
| 5 | 후가공 접기/펼치기(FinishTitleBar) | N/A — PRBKYPR은 finish-button 직접 노출(토글 헤더 데이터셋 없음) | Red도 동일 데이터셋 의존 |
| 6 | 가격 요약 분해 | **PASS** — COT/CUT/PRT_DFT + 부가세 + 배송비 + 합계 | Red 동일 line 분해 |
| 7 | 에디터/업로드 진입 3종 | **PASS** — 편집하기/PDF업로드/장바구니(+견적) | Red도 KOI 에디터+PDF |
| 8 | 선택 상태 시각(흰 배경+보라 테두리 RULE-2) | **PASS** — 선택 버튼 보라 테두리(스크린샷) | Red 유사 |
| 9 | 컬러칩 형태 | **PASS** — 면지 칩 렌더(노랑/민트/화이트 등 10종) | Red 면지 동일 |
| 10 | CSS 격리 | **PASS** — 호스트 공격 CSS 누수 0건 | Red는 iframe 격리(다른 방식, 동일 목표) |

*#5는 PRBKYPR에 토글형 후가공 헤더 데이터셋이 없어 N/A(미해당, 결함 아님).*

---

## 결함 목록 (심각도)

### D-D1 [LOW] presigned→S3 PUT 실왕복 미검증 (stub 한계)
- 코드 seam(`widget-store.ts:227-263`)은 배선 확인. 실 S3 PUT은 fixture stub이라 미수행.
- 조치: 실 BFF 연동 시 Content-Type/checksum 헤더(O5 미확정) 라이브 보강 필요.

### D-D2 [LOW] Edicus 토큰체인/풀 에디터 로드 라이브 미검증
- iframe URL·sandbox·포털·origin 가드는 라이브 확인. 단 token=stub이라 실 Edicus가 JWT 파싱서 에러(에디터측). 실 토큰체인(makers 4단)은 BFF stub.
- 조치: 실 Edicus 토큰 발급 BFF 구현 후 full handshake(request-prod-info→send-extra-param→project-id-created→goto-cart) 라이브 검증.

### D-D3 [TRIVIAL] iframe sandbox 경고
- `allow-scripts + allow-same-origin` 동시 → "can escape its sandboxing" 경고(`EditorOverlay.tsx:74`). Edicus postMessage 핸드셰이크에 필요한 최소셋(O3 미확정)이라 의도적. Edicus 운영 sandbox 속성 캡처 후 정합 확인 권장.

### D-D4 [TRIVIAL/관찰] 캐스케이드 가시 경로가 fixture상 내지 자재로 한정
- PRBKYPR 표지 자재 1종+非트리거라 표지 경로 캐스케이드 미가시. 코드 결함 아님(데이터 구조). 다른 상품(자재 다종+트리거)으로 추가 검증 권장.

---

## 라이브 vs 코드-온리 검증 구분 (정직성)

| 검증 | 방식 |
|------|------|
| 카운터 렌더·값·재계산·snap | **라이브** (실 브라우저 DOM+가격 변화) |
| 캐스케이드 disable | **라이브** (실 select 조작→버튼 disabled 전환) |
| 에디터 오버레이 포털·iframe·sandbox·실 Edicus 부팅 | **라이브** |
| origin 가드(허용/비허용 분기) | **라이브** (합성 MessageEvent, 상태 변화로 입증) |
| canOrder 클린/캐스케이드 상태 | **라이브** |
| 회귀(격리·포털·hook 경고 0) | **라이브** |
| presigned→S3 실 PUT | **코드-온리**(stub) |
| Edicus 실 토큰체인/full handshake | **코드-온리**(stub, 실 token 없음) |
| Red 위젯 PRBKYPR 캐스케이드 직접 조작 | 부분 — Red는 동일 disable 계약·동일 상품·price 200 확인. 위젯 내부 iframe 깊이 조작은 미수행 |

## 환경 메모
- Red 토큰 본 패스 도중 `extract-cookies.cjs`로 재발급 성공(만료 갱신). Red 서버 재기동 후 price 200. 토큰은 본 보고서에서 [REDACTED].
- 임시 QA 스크립트(`_phaseD.mjs`,`_phaseD2.mjs`,`_phaseD3.mjs`,`_red.mjs`,`_red2.mjs`)는 실행 후 삭제 완료.
