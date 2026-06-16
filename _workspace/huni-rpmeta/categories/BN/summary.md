# BN(현수막류) 카테고리 — RP-Meta 파이프라인 요약

> 후니 RP-Meta 하네스. RedPrinting BN(현수막/대형 실사 배너) 카테고리의 역공학→메타모델→갭→그릇 파이프라인 산출 인덱스.

## 산출물
- **역공학(reverse):** `reverse.md` — 대표 6상품(BNBNFBL·BNPTPET·BNSTDFT·BNBNSOD·BNRLSLV·BNPTMAS·BNTNHVY) base-data 렌즈 원자 추출. Vue3 BFF + 레거시 jQuery SSR 이중 런타임·단일 base-data 모델.
- **메타모델(02_metamodel):** `metamodel-dictionary.md`·`discovered-axes.md` — BN+GS 통합 15축(7 정적 + 4 관계/동역학 + 2 횡단 + GS 신축 2).
- **갭(03_gap):** `gap-matrix.md` — 후니 라이브 t_* 대조 PASS 5·WEAK 7·GAP 3(2026-06-17 read-only 실측).
- **심층보강(deepcheck):** `deepcheck.md` — codex-cli second-opinion 갭발굴.

## deepcheck 포인터
- **`deepcheck.md` → 상태: DEEPCHECK PENDING (codex CLI 버전 블로커, 2026-06-17 재실행).**
  직전 "401 OAuth 만료"는 재인증으로 해소됨. 이번 블로커는 별개 — **codex CLI 0.38.0이 너무 낮음**:
  이 CLI의 모델 카탈로그(gpt-5*/gpt-5-codex*)는 ChatGPT 계정에서 `400 "not supported"`로 전수 거부,
  계정이 요구하는 `gpt-5.5`는 `400 "requires a newer version of Codex"`. 모델 지정·MCP off·OSS(ollama 미설치) 전부 우회 실패.
  후보 0건(날조 없음). **해소: codex CLI 최신 업그레이드(예 `@openai/codex@latest`) 후 ping 통과 확인 → rpm-deepcheck 재호출.**
  재실행 컨텍스트·명령 보존: `_tmp/rpm-bn-context.md` + deepcheck.md 내 갱신된 호출 명령(`-c mcp_servers='{}'` 포함).

## 시각화 (viz)

> **renderer: mermaid (codex deadlock)** — codex-image 환경 데드락(codex-cli 0.38.0이 ChatGPT 계정 gpt-5.5 미지원·400, OPENAI_API_KEY 미설정)으로 raster 경로 양쪽 차단. mermaid 텍스트 도해로 폴백(텍스트=분석 그대로·환각0·GitHub/뷰어 렌더). raster 경로 복구 시 PNG로 재생성. 소스 = `viz/*.mmd`.

### 1. 옵션-구성 트리 — `viz/option-tree.mmd`
BN 대표 6상품의 옵션 축(자재·사이즈·도수·수량·후가공 7그룹·거치대)→choices→캐스케이드/disable·가격영향 플래그([P])·필수(ESN)·bundle·SKU. 출처: `reverse.md §1~7`.

```mermaid
%% (전문은 viz/option-tree.mmd)
flowchart LR
  BN["BN 현수막류\nSizeMatrix2D 면적가 · editor=PDF only"]
  BN --> MAT["축: 용지(자재)"] --> M3["텐트천 수성/라텍스 [P]\n(소재×인쇄방식 분기)"]
  BN --> SIZE["축: 규격(mm)"] --> SU["사이즈직접입력 USER [P]\n제약: MIN/MAX_CUT 0~5000"]
  BN --> QTY["축: 수량(이중축)"] --> Q1["ORD_CNT 건수 × PRN_CNT 수량"]
  BN --> PCS["축: 후가공 7그룹"] --> P_ILT["ILT_DFT 아일렛 [bundle][P]"]
  PCS --> P_PKG["PKG_GB 포장(텐트천 강제필수)"]
  BN --> CDL["축: 거치대(X배너/롤업)"] --> C2["RLU 600/850/1000 [SKU]"]
  C2 -. "거치대 폭 ↔ size 1:1 캐스케이드" .-> SIZE
```

### 2. 15축 메타모델 맵 — `viz/axis-map.mmd`
BN이 15축 중 어느 축을 행사하나(행사 ✅ / 부분 △ / GS 신축 미행사 ✖ / D-8 facet 거부 ❌)·distinct vs facet. 출처: `02_metamodel/discovered-axes.md(D-1~D-10)`+`metamodel-dictionary.md`.

```mermaid
%% (전문은 viz/axis-map.mmd)
flowchart TB
  A8["#8 부속물 distinct(D-1) — BN 거치대 행사 ✅ ★BN발굴원"]
  A9["#9 공정파라미터 distinct(D-4) — BN 로프수량/구수 ✅ ★BN발굴원"]
  A10["#10 수량모델 distinct(D-5) — 건수×수량 이중축 ✅ ★BN발굴원"]
  A11["#11 가격기여역할 distinct(D-6) — SizeMatrix2D ✅ ★BN발굴원"]
  A14["#14 본체형태가공(GS) — BN 평면 substrate 미행사 ✖"]
  A15["#15 생산형태(GS) — BN 전부 C형 단일값 미발굴 ✖"]
  REJ["D-8 UI런타임 Vue/jQuery = facet 거부 ❌"]
```

### 3. 갭 히트맵 — `viz/gap-heatmap.mmd`
BN 13축 축별 PASS/WEAK/GAP(🟢 5·🟡 6·🔴 2) + GS 라이브 정정(④·⑬ 완화). 출처: `03_gap/gap-matrix.md (v1.0 BN 보존 + §VI 델타)`.

```mermaid
%% (전문은 viz/gap-heatmap.mmd) — 🟢 PASS · 🟡 WEAK · 🔴 GAP(vessel-gap)
flowchart TB
  G2["② 공정 🟢"]; G3["③ 옵션 🟢"]; G6["⑥ 기초코드 🟢"]; G7["⑦ 카테고리 🟢"]; G8["⑧ 부속물 🟢"]
  G1["① 자재 🟡 합성분해축 부재+오염"]; G4["④ 템플릿 🟡 price 미구현"]; G5["⑤ 제약 🟡 RULE_TYPE 3종뿐"]
  G10["⑩ 수량모델 🟡"]; G11["⑪ 가격기여역할 🟡"]; G13["⑬ 사이즈 🟡 nonspec·plate혼재"]
  G9["⑨ 공정파라미터 🔴 ref_param_json 미구현"]; G12["⑫ 인쇄방식레시피 🔴 게이팅 그릇부재"]
  G4 -. "GS정정: template_prices 발견→data-gap화" .-> FIX4["④완화"]
  G13 -. "GS정정: nonspec_min/max 실측→부분PASS" .-> FIX13["⑬완화"]
```

### 4. 자재/공정 BOM — `viz/bom.mmd`
BN 본체자재(MTRL_CD 4축 합성코드 TYPE+PTT+CLR+WGT)·usage 슬롯(BN 단일 substrate)·후가공 공정(순수공정 vs SUB_MTRL_YN=Y 자재+공정 bundle)·별개 거치대 SKU. 출처: `reverse.md §1~8`.

```mermaid
%% (전문은 viz/bom.mmd)
flowchart TB
  ROOT["BN 본체(단일 substrate)"]
  ROOT --> MAT["본체자재 MTRL_CD=TYPE+PTT+CLR+WGT"]
  MAT --> PTT["PTT 소재: BFC/PET/BOP/TFC·TFL/MAS/VGP"]
  MAT --> PM["인쇄방식 수성C/라텍스L 분기"]
  ROOT --> PURE["순수공정(SUB_MTRL_N): 재단/코팅/봉제/포장"]
  ROOT --> BUND["자재+공정 bundle(SUB_MTRL_Y): 아일렛/각목/큐방/로프/부자재"]
  ROOT -. "별개 완제 SKU" .-> ADD["거치대 CDL_DFT [SKU]"]
```

> 4종 모두 분석 출처 섹션과 1:1 대응(노드/엣지/라벨/색 = 분석이 말한 것). 임베드는 요약 발췌이며 전문은 `.mmd` 파일.
