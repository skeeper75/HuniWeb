# D7 — 선행 하네스 자산 수확 (바퀴 재발명 방지)

대상: `_workspace/` 하위 선행 하네스 9종(`huni-ontology-kb`, `huni-multibrand-ontology`, `huni-price-engine-design`, `huni-price-engine-diag`, `huni-constraint-rules`, `huni-widget-flow`, `huni-product-readiness`, `huni-launch-scope`, `print-kb`, `print-story/04_thesis`) + `.claude/rules/harness/` 규칙 4종.
읽기 전용 진단. 파일 수정 없음. 각 하네스 전문이 아니라 HANDOFF/CHANGELOG/최상위 요약 문서 기준(토큰 절약).

---

## 요약

- 이번 월드모델 설계가 **처음부터 만들어야 하는 것은 사실상 없다.** 심볼릭 지식층(개체 17종·관계 19종·노드 1,485·엣지 4,568·상품 275)은 이미 구축·검증 완료돼 있고(`huni-ontology-kb/HANDOFF.md:44`), 그 위의 브랜드-중립 상위 온톨로지(개체 E1~E21+라우팅 E22~E25)까지 게이트 통과 상태다(`huni-multibrand-ontology/HANDOFF.md:22-23`).
- **가장 중요한 수확은 "이미 기각된 접근" 목록이다.** 임베딩·트리플스토어·OWL 추론기·Leiden 자동 커뮤니티 탐지·개방추출(open IE)은 **과공학으로 기각 확정**돼 있다(`huni-multibrand-ontology/HANDOFF.md:29`). 이번 설계에서 이를 다시 제안하면 relitigate다.
- **월드모델(행동→결과 예측)에 해당하는 선행 자산은 가격 축 하나뿐이다.** `evaluate_price`가 유일한 전이함수이고, 온톨로지는 명시적으로 "가격 값은 계산하지 않는다"는 경계(D-18)를 선언해 스스로 예측 책임을 밖으로 밀어냈다(`.claude/rules/harness/huni-multibrand-ontology.md:21-22`).
- **제작가능성(feasibility) 예측은 구조적으로 비어 있다.** 제약 레이어는 존재하지만 "가격·주문 어디에도 연결 안 됨"이 하네스 자체 판정이다(`huni-constraint-rules/CHANGELOG.md:7`). 즉 제약은 선언돼 있으나 **실행 경로가 없다** — 월드모델의 가장 큰 공백.
- 선행 산출물 간 **최소 3건의 실질 모순**을 확인했다: ① 권위 엑셀 버전 불일치(260702/260610/260527 vs SOT 260705/260703) ② 상품 분모 3종(275/283/297) ③ 제약 필요성 판정 상충(제약 하네스 "사실상 없음" vs 가격엔진 하네스의 돈크리티컬 가드 다수).

---

## 실측 사실 (모든 주장에 파일경로:라인 인용)

### 1. 자산 인벤토리

| # | 이미 만든 것 | 경로 | 재사용 가능한가 | 상태 (근거) |
|---|---|---|---|---|
| A1 | 후니 단일브랜드 온톨로지 스키마 — 개체 17종(라이브 앵커 12 + KB 전용 5)·관계 19종·출처 5필드·badge 4종 | `_workspace/huni-ontology-kb/02_ontology/ontology-schema.md` | **그대로 재사용(권장)** — 수정 금지 자산 | 승인본 v1.0.1 (`ontology-schema.md:14-17`; 보호 선언 `huni-ontology-kb/HANDOFF.md:60`) |
| A2 | 지식그래프 실물 — 노드 1,485 / 엣지 4,568 / 상품 275 / 하드 lint 0 / 멱등 해시 f4be9775 | `_workspace/huni-ontology-kb/04_graph/{nodes,edges}.jsonl`(실측 1,485행·4,568행) | **그대로 재사용** | 전 상품군 O1~O7 GO (`huni-ontology-kb/HANDOFF.md:44-45`) |
| A3 | 결정론 그래프 빌더(LLM 미개입·멱등 계약) | `_workspace/huni-ontology-kb/04_graph/build_graph.py` | 재사용, **로직 변경 시 graph-build-spec 변경이력 필수** | 보호 자산 (`huni-ontology-kb/HANDOFF.md:59`) |
| A4 | 앵커 강제 3유형(`t_<table>/<CODE>` / `xlsx:파일#시트!셀` / `none`+사유) = 환각 개체 완전 차단 | `ontology-schema.md:29-33` | **그대로 승계(핵심)** | 결정론 스크립트가 검사(lint I-2) (`ontology-schema.md:33`) |
| A5 | 자연어 질의 경로 증명 5유형(구체상품/용도추천/조건탐색/옵션제약/거절형) | `_workspace/huni-ontology-kb/02_ontology/nl-query-paths.md:19-129` | **재사용** — 월드모델 질의 인터페이스 원형 | v1.0.1 교정 반영 (`nl-query-paths.md:180`) |
| A6 | 브랜드-중립 상위 온톨로지(E1~E21+E-U·관계 23) + 브랜드 앵커 규약 + 교차관계 | `_workspace/huni-multibrand-ontology/03_upper_ontology/` | 재사용, **단 정식 등재는 인간 승인 대기** | MB1~7 GO (`huni-multibrand-ontology/HANDOFF.md:22-23,36`) |
| A7 | 주문 라우팅 층 스키마(E22~E25·RT-1~6·폐쇄목록 29) | 동상 `routing-layer-schema` | 형만 재사용 | **전 노드 candidate — 실 데이터 0** (`huni-multibrand-ontology/HANDOFF.md:34`) |
| A8 | 와우프레스 온톨로지 등록(324상품·24군) + 제약 그래프 ~21,000건(엣지 19,927 + 규칙 1,065) | `_workspace/huni-multibrand-ontology/04_wow-registration/wow-constraints.json` | **재사용(대량 제약 코퍼스)** | 전 catalog 앵커 (`.claude/rules/harness/huni-multibrand-ontology.md:33`) |
| A9 | 가격공식 설계 13종단(11 상품군 시트 + 박류 + 책자 표지 분기) — 계산방식 분류·구성요소 분해·골든 케이스 | `_workspace/huni-price-engine-design/{01_formula,03_design,04_validation,05_codex}/` | **재사용** — 가격 전이함수의 명세 원본 | 전건 게이트 GO, **전부 DB 미적재** (`huni-price-engine-design/HANDOFF.md:56-68,70`) |
| A10 | 가격엔진 계약 지식(`.01 단가형=unit×qty`·`prc_typ .03 라이브 부존재`·`del_yn 필터 부재`) | `huni-price-engine-design/HANDOFF.md:86,115,130` | **재사용(HARD 사실)** | relitigate 금지 확정 (`HANDOFF.md:130`) |
| A11 | 가격엔진 5장치 역할 진단 + 코드↔DB 속성 정합 + U-7 배선 유효성 트랙 | `_workspace/huni-price-engine-diag/{01_mechanism,02_code_schema,04_binding_validity}/` | 재사용 | `huni-price-engine-diag/CHANGELOG.md:11-13` |
| A12 | 가격 4하네스 경계 정의(§7 적재 / §13 게이트 / §14 이해 / §15 온디맨드) = **중복 아닌 의도적 상보 레이어·재병합 금지** | `_workspace/_harness-audit/` | **재사용(설계 제약)** | 전수 감사 결론 (`huni-price-engine-diag/CHANGELOG.md:11`) |
| A13 | 제약 필요상황 분류 CN-1~CN-6 + 게이트 CR1~CR7 + 폼빌더 정형 shape 계약 | `_workspace/huni-constraint-rules/{01_scenario,05_gate}/` | 재사용 | `.claude/rules/harness/huni-constraint-rules.md:8` |
| A14 | 라이브 등록된 실제 제약규칙 — 129/130 `R_MATSIZ_*` 8건, 047 `R_EXCL_COATING_THIN_PAPER` | 라이브 `t_prd_product_constraints` (백업/undo `huni-constraint-rules/04_register/`) | **건드리지 말 것** | 실화면 4항 PASS (`huni-constraint-rules/HANDOFF.md:17`) |
| A15 | C-10 패턴(implication `.03`는 폼빌더 RAW-ONLY → 여집합 금지형 `.02`로 뒤집기) | `huni-constraint-rules/HANDOFF.md:12` | **재사용(표현 제약)** | 047 전형 |
| A16 | 위젯 3계층 플로우 역공학(브릿지/로더 → Vue3+Pinia Shadow DOM → Edicus iframe) + 26상품 경로 커버리지 | `_workspace/huni-widget-flow/{01_curation,02_mermaid,04_validation}/` | **재사용** — 행동(사용자 선택) 시퀀스의 실측 원본 | F1~F6 GO(CONDITIONAL) (`huni-widget-flow/04_validation/gate-verdict.md:7-9`) |
| A17 | 상품별 항목단위 BOM — `component_bom`(자재·공정·사이즈·도수·옵션) + `price_bom`(공식→구성요소→단가행) + 인터랙티브 대시보드 | `_workspace/huni-product-readiness/05_gate/dashboard/` | **재사용(상태 표현의 원형)** | 검증 완료 산출 (`huni-product-readiness/HANDOFF.md:25`) |
| A18 | 견적0 100상품 진단 + 자재 price_gap 26항목/8상품 목록 | `huni-product-readiness/02_readiness/list-bom-priced-zero.csv`, `list-bom-material-pricegap.csv` | **재사용(공백 지도)** | `huni-product-readiness/HANDOFF.md:8,10` |
| A19 | 1차 런칭 개발범위·Shopby fit-gap(SOLVED 48 / PARTIAL 53 / CUSTOM 61) + 런칭 전 GATE 4 | `_workspace/huni-launch-scope/05_gate/` + `docs/huni/..._260630.xlsx` | 재사용(범위 제약) | L1~L7 GO(조건부) (`huni-launch-scope/CHANGELOG.md:8-10`) |
| A20 | 역량질문(CQ) 레지스트리 81문 + CommonKADS 맥락모델 7태스크 + 출처 3계층 | `_workspace/print-kb/{cq-registry.md,domain-context-model.md,source-registry.md}` | **재사용(완전성 기준선)** | CQ 커버리지 86% (`print-kb/README.md:50`) |
| A21 | LLM 위키(Karpathy 모델) 정책 도메인 파일럿 57항목 | `_workspace/print-kb/wiki/` | 재사용 | 정책 도메인만 완료 (`print-kb/README.md:50`) |
| A22 | 문제 정의 서사 + 사업 진입점 12종 매트릭스(구획 A 재현 / 구획 B 미개척) | `_workspace/print-story/04_thesis/{thesis-arc.md,business-entry-points.md}` | **재사용(목적 정렬)** | `business-entry-points.md:26,38` |
| A23 | 5대 절벽 ↔ 온톨로지 계층 대응표(3건 온톨로지가 받음 / 1건 미결 / 1건 온톨로지 밖) | `print-story/04_thesis/ontology-layer.md:203-217` | **재사용(범위 판정)** | 자기기록 |

### 2. 이미 기각된 접근 — 다시 제안하면 안 되는 것

| # | 기각된 것 | 기각 사유(원문 근거) | 근거 |
|---|---|---|---|
| R1 | **임베딩 기반 검색을 1차 경로로 삼기** | "후니 283상품 규모엔 과공학·결정론 트리+SQLite가 더 감사 가능". 임베딩은 **자연어 진입 fallback으로만 보류** | `huni-multibrand-ontology/HANDOFF.md:29` |
| R2 | **트리플스토어 도입** | 동상(과공학) | `huni-multibrand-ontology/HANDOFF.md:29` |
| R3 | **OWL 추론기 도입** | 동상 | 동상 |
| R4 | **Leiden 등 자동 커뮤니티 탐지** | 동상 | 동상 |
| R5 | **개방추출(open IE)로 노드 생성** | 동상 + 앵커 강제 원칙 위반(앵커 없는 개념 노드는 `gap`으로만 존재 가능) | 동상 + `ontology-schema.md:33` |
| R6 | **범용 GraphRAG 도구로 대체** | "스키마-우선 닫힌세계 앵커가 범용 GraphRAG 도구보다 환각 차단 우위" | `print-story/04_thesis/ontology-layer.md:145` |
| R7 | **RDF / JDF-XML 기술스택 도입** | 표준은 **어휘만 차용**(schema.org·XJDF 이름표), 스택 미도입 | `ontology-schema.md:20`; `ontology-layer.md:149-166` |
| R8 | **온톨로지가 가격 값을 계산하게 하기** | 가격 경계 D-18 — "온톨로지는 가격 축·구성요소 연결까지만. 가격 값 권위 = evaluate_price(와우는 제품가격조회 API)" | `.claude/rules/harness/huni-multibrand-ontology.md:21-23` |
| R9 | **§33과 §35를 지금 단일 그래프로 머지** | 아키텍처=**독립 시작 후 나중에 통합**(옵션 C) 확정, §33 골든 보호 + 와우 노후 격리 | `huni-multibrand-ontology/HANDOFF.md:13,43` |
| R10 | **크기/수량 범위를 제약규칙으로 신설** | 엔진이 ceiling(상한차단)·min_qty(하한)으로 **이미 처리** → 제약 불필요. 자유치수·박크기 27상품을 "제약신설 필요"에서 **제약불필요로 정정**, C-9 수치범위 개발의 가격 정당성 소멸 | `huni-constraint-rules/CHANGELOG.md:5`; `.claude/rules/harness/huni-constraint-rules.md:10` |
| R11 | **implication(`.03`, "X→Y∈리스트") shape로 제약 작성** | 폼빌더 result가 단일 `{dim,val}`만 지원 → RAW-ONLY가 되어 UI 역파싱 불가. 여집합 금지형(`.02`)으로 뒤집을 것 | `huni-constraint-rules/HANDOFF.md:12` |
| R12 | **"옵션그룹 폭발" 문제를 전제로 한 설계** | 실재하지 않음 — 실체는 명명 비일관(§12 라우팅) | `huni-constraint-rules/CHANGELOG.md:7` |
| R13 | **아크릴을 굿즈형 고정가룩업으로 모델링** | 아크릴 = **면적매트릭스(실사 동형)**. `gap-goods-fixed-lookup` 슬러그 금지 | `huni-ontology-kb/HANDOFF.md:20` |
| R14 | **스냅샷/초기 캐시를 신뢰한 가격 판정** | H-1 드리프트 2회 실증(굿즈 33·아크릴 226 false-gap) → 게이트/교정 단계 **라이브 재-SELECT 필수** | `huni-ontology-kb/HANDOFF.md:25,52` |
| R15 | **React Flow 기반 시각화** | React 빌드 필요 → 미채택, Cytoscape.js + product_viewer UX 재사용 | `huni-product-readiness/HANDOFF.md:16` |
| R16 | **inline 가격을 추측으로 공식화** | 비정수 역산 → 정찰가 스냅샷 = BLOCKED. **추측 단가 INSERT 금지** | `huni-price-engine-design/HANDOFF.md:117,128` |
| R17 | **가격 4하네스 재병합** | 중복이 아니라 **의도적 상보 레이어**(이해→게이트→온디맨드→적재) | `huni-price-engine-diag/CHANGELOG.md:11` |
| R18 | **raw/webadmin 직접 수정 / pricing.py 엔진코드 수정** | read-only 확정, 드롭인 패키지로 분리 | `huni-price-engine-design/HANDOFF.md:123`; `huni-product-readiness/HANDOFF.md:16` |

### 3. 하네스 규칙 파일 4종의 지시 요약

| 규칙 파일 | 스코프(paths) | 핵심 지시 |
|---|---|---|
| `huni-ontology-kb.md` | `_workspace/huni-ontology-kb/**` (`:2-3`) | 자연어→상품 추천→가격, 파일=정본/그래프=파생, O1~O7 게이트 (`:8`). **권위=260702 엑셀·가격값 권위=evaluate_price** (`:10`) |
| `huni-multibrand-ontology.md` | `_workspace/huni-multibrand-ontology/**` (`:2-3`) | 아키텍처 커밋 지연(`:16`)·와우 앵커 3유형·LLM 손전사 금지(`:18-20`)·가격 경계 D-18(`:21-23`)·§33 무손상(`:25-26`) |
| `huni-constraint-rules.md` | `_workspace/huni-constraint-rules/**` (`:2-3`) | CN-1~CN-6 규정 먼저 → 폼빌더 정형 shape만, raw JSONLogic 금지, 오차단 0 (`:8`). 엔진이 크기/수량 구간차원 이미 처리 (`:10`) |
| `huni-price-engine-design.md` | `_workspace/huni-price-engine-design/**` (`:2-3`) | 역공학+경쟁사 흡수로 공식 설계, E1~E7 + codex Phase5.5, **DB 미적재** (`:8`) |

### 4. 선행 산출물 간 모순

| # | 모순 | A측 | B측 | 영향 |
|---|---|---|---|---|
| **C1** | **권위 엑셀 버전** | 프로젝트 SOT: "최신 권위(절대) = 가격표 260705 · 상품마스터 260703. **260702/260610/260527=stale**" (`_workspace/_foundation/PRICE-SHEET-SOT-260705.md:4,52`) | §33 규칙은 "권위=**260702** 엑셀"(`.claude/rules/harness/huni-ontology-kb.md:10`), §18 HANDOFF는 상품마스터 **260610**·가격표 **260527** 기준(`huni-price-engine-design/HANDOFF.md:3` 및 `:25` 골든 권위) | **높음** — 온톨로지 앵커의 `xlsx:` 좌표와 가격 골든값이 stale 버전을 가리킬 수 있음. 월드모델이 이 앵커를 신뢰하면 오래된 권위를 예측 근거로 삼는다 |
| **C2** | **상품 분모 3종** | §33 = **275**상품 완주(`huni-ontology-kb/HANDOFF.md:44`) | §29 = 분모 **283** 실상품(`huni-product-readiness/HANDOFF.md:15`), §31 = **297** 활성상품 전수 CN 체크(`huni-constraint-rules/CHANGELOG.md:7`), §35는 "후니 283상품 규모"(`huni-multibrand-ontology/HANDOFF.md:29`) | **중간** — 커버리지·완전성 주장의 분모가 하네스마다 다르다. "전 상품 완주"가 어느 분모인지 명시 없이는 검증 불가 |
| **C3** | **제약규칙이 더 필요한가** | §31: "새로 설계·등록할 **가격영향 제약 사실상 없음**"(`.claude/rules/harness/huni-constraint-rules.md:11`, `huni-constraint-rules/CHANGELOG.md:5`) | §18: 돈크리티컬 가드 다수가 사실상 제약 — 동판비 `use_dims`에 `proc_cd` 없으면 NULL 와일드카드로 **박 미선택 주문에도 5,000~64,000 상시과금**(`huni-price-engine-design/HANDOFF.md:27`), `G-CAL-PAGE`·`G-PB-PAGE` 페이지수 곱 범위 제한(`:102,109`), GP-2 `product_prices` INSERT 금지 가드(`:95`) | **높음** — §31은 "고객 선택 조합"만 제약으로 봤고, §18의 가드는 "데이터 배선 제약"이다. **두 종류의 제약이 서로 다른 레지스트리에 흩어져 있다** |
| **C4** | **커버리지 비율의 의미** | §29: "`적재셀수/전역셀수`=라이브 내부 coverage 비율(권위 분모 아님)·**sparse 비율≠갭**"(`huni-product-readiness/HANDOFF.md:19`) | §26 트랙은 권위 격자 셀 단위 완전성(동상). §33은 "sparse grid 정직 — 단가행 1~2셀=등록 사이즈가 적을 뿐"(`huni-ontology-kb/HANDOFF.md:22`) | **중간** — 같은 sparse 신호를 세 하네스가 다르게 읽는다. 월드모델이 "가격 가능/불가"를 판정할 때 어느 분모를 쓸지 미정 |
| **C5** | **제약 레이어의 실효성** | §31은 라이브 COMMIT까지 완료하고 실화면 4항 PASS(`huni-constraint-rules/CHANGELOG.md:7`) | 같은 하네스 자체 결론: "**제약 레이어는 가격·주문 어디에도 연결 안 됨**"(동상), High=강제 지점 부재(`huni-constraint-rules/HANDOFF.md:7`) | **높음** — 제약이 등록돼 있으나 **집행되지 않는다**. "제약 있음"을 feasibility 예측의 근거로 쓰면 안 됨 |

---

## 구조 해설

### 선행 자산의 4층 구조

선행 하네스들은 우연이 아니라 서로 다른 층에 놓여 있고, `print-story/04_thesis/ontology-layer.md:22`가 그 층 구분을 이미 명문화했다("C가 도메인 이해 → A가 형식 온톨로지 → B가 브랜드 중립").

```
[L4] 목적·범위 판정   print-story/04_thesis (진입점 12종·5대 절벽 대응표)
                      huni-launch-scope   (1차 런칭 범위·GATE 4)
        ↑
[L3] 브랜드 중립 상위  huni-multibrand-ontology (E1~E21 + 라우팅 E22~E25 · 표준 어휘)
        ↑
[L2] 형식 온톨로지     huni-ontology-kb (개체17·관계19·앵커강제·그래프 1,485/4,568)
        ↑
[L1] 도메인 이해       print-kb (CQ 81 · CommonKADS 맥락모델 · LLM 위키)
        ↑
[L0] 라이브 실측·명세   huni-price-engine-design/-diag (가격 13종단)
                      huni-constraint-rules (CN 분류·라이브 규칙)
                      huni-product-readiness (항목단위 BOM·견적0 목록)
                      huni-widget-flow (사용자 행동 시퀀스)
```

### 각 층이 월드모델에 제공하는 것

- **L0**은 `s`(상태)와 부분적인 `f(s,a)`(전이)를 준다. 특히 `huni-product-readiness`의 `component_bom` + `price_bom`(`HANDOFF.md:18`)은 **상태 벡터의 실물 스키마**다.
- **L1**의 CQ 81문(`print-kb/README.md:50`)은 월드모델의 **평가 문항 은행**으로 그대로 전용 가능하다. 완전성 기준선을 새로 만들 필요가 없다.
- **L2**의 앵커 강제(`ontology-schema.md:29-33`)는 월드모델이 "존재하지 않는 상태를 상상하는 것"을 구조적으로 막는 장치다. 이것이 학습형 월드모델과 결정적으로 다른 지점 — 이 프로젝트의 월드모델은 **닫힌 세계 위에서만 시뮬레이션한다**.
- **L3**의 `intent`(용도) 축은 라이브 DB에 대응 테이블이 **없다**(`ontology-schema.md:71`). 고객 의도가 진입하는 유일한 노드이며, 그 **원자 분해는 미완이고 다중브랜드의 키스톤으로 지목**돼 있다(`huni-multibrand-ontology/HANDOFF.md:7,35`).
- **L4**는 "무엇을 만들면 돈이 되는가"의 판정을 이미 내려 놓았다. 특히 `business-entry-points.md:115`는 제약 엔진(E4)을 **해자 최상**으로 판정했다.

---

## 결함·공백

| # | 공백 | 근거 | 월드모델에 미치는 영향 |
|---|---|---|---|
| G1 | **제약의 집행 경로 부재** — 등록된 제약이 가격·주문 어디에도 연결되지 않음 | `huni-constraint-rules/CHANGELOG.md:7`; `HANDOFF.md:7` | 치명. "이 조합이 생산 가능한가"를 시스템이 답할 수 없음 = feasibility 전이함수 부재 |
| G2 | **가격 설계 13종단이 전부 DB 미적재** | `huni-price-engine-design/HANDOFF.md:70`, 규칙 `huni-price-engine-design.md:8` | 설계상 예측 가능한 가격과 실제 라이브 계산 결과가 다르다. 월드모델의 예측이 라이브와 어긋남 |
| G3 | **견적0 100상품 / 자재 price_gap 26항목** | `huni-product-readiness/HANDOFF.md:8,10` | 상태 공간의 3분의 1 이상이 "행동해도 결과가 안 나오는" 영역 |
| G4 | **골든 전수대조 미수행** — L3+ 83상품은 `PRICE≠0`이나 예전사이트 정답가 일치는 미검증 | `huni-product-readiness/HANDOFF.md:12` | 전이함수의 **정확도가 측정되지 않았다**. "계산이 된다"≠"맞다" |
| G5 | **`intent` 원자 분해 미완 + 용도 커버리지 GAP(앨범·포토)** | `huni-multibrand-ontology/HANDOFF.md:35`; `huni-ontology-kb/HANDOFF.md:35` | 의도→명세 환원의 진입 노드가 비어 있음 |
| G6 | **라우팅 층 실 데이터 0** — E22~E25 전 노드 candidate | `huni-multibrand-ontology/HANDOFF.md:34` | "어느 인쇄소에 넘길지"는 형만 있고 예측 불가 |
| G7 | **코팅이 자재인가 공정인가 — 모델링 미결** | `print-story/04_thesis/ontology-layer.md:227` | 상태 표현의 축이 상품군마다 흔들림 |
| G8 | **live-snapshot 노후(20260702)** + H-1 드리프트 2회 실증 | `huni-ontology-kb/HANDOFF.md:25,33` | 월드모델의 입력 상태가 라이브와 어긋날 상시 위험 |
| G9 | **가격 브리지 견적형 무손실 경로 미확정**(Shopby 카트 동적가격 직접주입 스펙상 불가) | `huni-launch-scope/CHANGELOG.md:10,13` | 예측한 가격을 주문으로 흘려보내는 경로가 미확정 |
| G10 | **파일 규격 검사는 온톨로지 밖** — 프리플라이트 파이프라인이 담당 | `print-story/04_thesis/ontology-layer.md:217` | 월드모델이 "이 파일로 생산 가능한가"를 답하려면 별도 실행층 필요(단, 그 실행층은 이미 결정론으로 구현된 재현 대상) |

---

## 월드모델 관점 판정

**판정: 선행 하네스 자산 전체는 압도적으로 (3) 지식/온톨로지이며, 일부 (2) 심볼릭이고, (4) 월드모델은 가격 축 하나에서만 부분 성립한다. (1) 뉴로는 0이며, 그것도 의도적 기각의 결과다.**

| 축 | 판정 | 증거 |
|---|---|---|
| **(1) 뉴로** | **없음 — 그리고 의도적으로 기각됨** | 임베딩·개방추출 기각 확정(`huni-multibrand-ontology/HANDOFF.md:29`). 빌드 파이프라인에 LLM이 개입하지 않음(`ontology-layer.md:65`, 멱등 계약). 임베딩은 자연어 진입 fallback으로만 보류 |
| **(2) 심볼릭** | **부분 성립 — 선언은 있으나 집행이 없다** | 제약이 1급 개체(`ontology-layer.md:45`), CN-1~CN-6 분류·JSONLogic 규칙 라이브 등록(`huni-constraint-rules/HANDOFF.md:17`). **그러나 "가격·주문 어디에도 연결 안 됨"**(`CHANGELOG.md:7`) — 심볼릭 추론기가 실행 경로에 꽂혀 있지 않다 |
| **(3) 지식/온톨로지** | **강하게 성립 — 이 프로젝트의 최대 자산** | 개체17·관계19·출처5필드·badge4(`ontology-schema.md:14-17`), 노드 1,485/엣지 4,568 실측, 하드 lint 0, 멱등 빌드(`huni-ontology-kb/HANDOFF.md:44`), CQ 81문 완전성 기준선(`print-kb/README.md:50`), 표준 어휘 매핑(`ontology-layer.md:149-166`) |
| **(4) 월드모델(행동→결과 예측)** | **가격 축에서만 부분 성립. 그 외 전무** | 성립: `evaluate_price`가 (옵션 선택 → 금액) 전이함수이고, 13종단이 그 구조를 명세했다(`huni-price-engine-design/HANDOFF.md:56-68`). 위젯 플로우가 행동 시퀀스를 실측했다(`huni-widget-flow/04_validation/gate-verdict.md:7`). **미성립**: 제작가능성(G1)·납기·수율·품질은 어느 하네스에도 예측 모델이 없다. 온톨로지는 스스로 "가격 값은 계산하지 않는다"를 HARD 경계로 선언해(`.claude/rules/harness/huni-multibrand-ontology.md:21-23`) 예측 책임을 밖으로 밀어냈다 |

**무엇이 비어 있는가 — 증거 기반 3항**

1. **전이함수가 하나뿐이다.** 라이브에서 실제로 "행동 → 결과"를 계산하는 것은 `evaluate_price` 단일 함수다. 이 판단의 근거는 두 개다 — (a) 온톨로지·다중브랜드 양쪽이 가격 값 권위를 이 함수(및 와우 API)로 명시 위임한 D-18 경계(`.claude/rules/harness/huni-multibrand-ontology.md:21-23`), (b) 제약 레이어가 어떤 실행 경로에도 연결돼 있지 않다는 §31 자체 판정(`huni-constraint-rules/CHANGELOG.md:7`).
2. **그 유일한 전이함수의 정확도가 미측정이다.** `PRICE≠0`(계산 성립)은 83상품에서 확인됐으나 정답가 일치는 미검증(`huni-product-readiness/HANDOFF.md:12`). 월드모델 관점에서는 **전이함수는 있으나 오차가 모른다**는 상태다.
3. **의도(intent) 진입 노드가 비어 있다.** `intent`는 라이브 DB에 대응 테이블이 없는 KB 전용 축으로 명시 선언됐고(`ontology-schema.md:71`), 그 원자 분해는 미완이며 키스톤으로 지목됐다(`huni-multibrand-ontology/HANDOFF.md:7,35`). 즉 **월드모델의 입력 쪽(고객 의도 → 상태)이 출력 쪽(상태 → 가격)보다 훨씬 덜 만들어져 있다.**

**[추정] 이번 월드모델 설계가 얹혀야 할 지점 (판단 근거를 함께 표기)**

- **[추정] 새 그래프를 만들지 말고 `huni-ontology-kb` 그래프를 상태 표현으로 채택한다.** 근거: 보호 자산이며 멱등·lint 0이 검증됨(`huni-ontology-kb/HANDOFF.md:44,58-62`). 다만 이는 설계 선택이지 기존 문서가 지시한 바는 아니므로 추정.
- **[추정] 새로 만들어야 하는 유일한 층은 "행동 → 결과" 전이함수의 명시적 선언(feasibility 축)이다.** 근거: G1(제약 미집행) + 판정표 (4)행. 가격 축은 이미 있으므로 재발명 금지.
- **[추정] 그 feasibility 전이함수의 규칙 원천은 새로 수집할 필요가 없다** — §31의 CN 분류(`huni-constraint-rules/01_scenario/`), §35의 와우 제약 그래프 ~21,000건(`.claude/rules/harness/huni-multibrand-ontology.md:33`), §18의 돈크리티컬 가드(`huni-price-engine-design/HANDOFF.md:27,95,102,109`)를 **하나의 레지스트리로 병합**하는 것이 C3 모순의 해소이자 설계 착지점이다.
- **[추정] 시뮬레이션 루프의 입력 신선도 규율은 R14(라이브 재-SELECT)를 그대로 승계해야 한다.** 근거: H-1 드리프트 2회 실증(`huni-ontology-kb/HANDOFF.md:25`).

---

## 미확인

- 각 하네스의 **전문(全文)을 읽지 않았다.** HANDOFF/CHANGELOG/최상위 요약 문서만 읽었으므로, 본문 안에 기록된 추가 결정·기각 항목이 더 있을 수 있다. 특히 `huni-ontology-kb/00_research/methodology-playbook.md`(7대 원칙·D-1~D-22)와 `_workspace/_harness-audit/` 전문은 미독.
- `huni-widget-flow`에는 HANDOFF/CHANGELOG가 **존재하지 않는다**(`ls` 결과: `01_curation`/`02_mermaid`/`03_visual`/`04_validation` 4디렉터리만). 따라서 이 하네스의 미해결 큐·기각 항목은 이 문서에 반영되지 않았다.
- **C1(권위 엑셀 버전 모순)이 실제로 앵커 오염을 일으켰는지는 미검증.** 온톨로지 노드의 `xlsx:` 앵커가 실제 어느 파일명을 가리키는지 `nodes.jsonl`을 전수 조회하지 않았다. 판정에는 도메인 도구(앵커 lint 재실행)가 필요하다.
- **C2(분모 275/283/297)가 단순 시점 차이인지 실질 불일치인지 미판정.** 각 하네스의 분모 정의 문서를 대조하지 않았다.
- **라이브 DB를 조회하지 않았다.** 이 문서의 모든 수치는 선행 산출물이 기록한 값의 인용이며, 현재 라이브 상태와 일치하는지는 미확인(R14가 경고하는 바로 그 위험).
- **웹 검색을 사용하지 않았다** — 전부 저장소 내부 파일 근거이므로 `Sources:` 절 없음.
