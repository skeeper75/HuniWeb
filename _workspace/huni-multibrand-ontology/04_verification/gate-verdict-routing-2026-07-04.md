# 라우팅 층 독립 검증 게이트 판정 — §35 상위 온톨로지 "주문 라우팅/이행" 신규 층

> 판정일: 2026-07-04 · mbo-verify-gate(독립 검증) · 방법론 = `mbo-verify-gate-validation` 스킬.
> **[HARD] 생성≠검증**: mbo-ontology-architect 주장을 신뢰하지 않고 §33 KB grep·표준 URL 1차 재조회·git 무손상 확인·codex 독립 교차로 재실측.
> **검증 대상(신규 라우팅 층 한정)**: `routing-layer-schema.md`(E22~E25·RT-1~RT-6·capability_covers·D-ROUTE·전 노드 GAP)·`nl-query-paths-routing.md`(RQ1~RQ6). 정합 대상: `upper-ontology-schema.md`(E1~E21·폐쇄 23) · 근거: `00_research/structure/*`.
> **종합: GO (7/7 라우팅 특화 게이트 통과).** 결함 = Medium 1 + Low 3(전부 문서 명료화·앵커 무결·지어내기 0). 단일 FAIL 없음.
> codex(codex-cli 0.142.3) 고위험 4문항 독립 교차 수행 — D-ROUTE strict NO-GO 이견 1건은 §33 D-18 선례 대조로 **기각(과엄격 판독)**, gap_ref 누락 1건은 **Low 승격**.

---

## 0. 판정 요약표

| # | 라우팅 특화 게이트 | 판정 | 핵심 재실측 증거 |
|---|--------------------|------|------------------|
| **1** | 전 노드 GAP 정직성 [최중요] | **GO** | 파일럿 노드 supplier-huni(§8.2)·cap-huni-digital-namecard(§8.3) 전부 `anchor=none + badge=candidate + gap_ref=G-ROUTE-1` 3필드 실재. 실 공급자/능력 데이터를 사실로 단정한 노드 0. §7 L-ROUTE-1이 3필드 미동반 단정=FAIL로 기계 강제 |
| **2** | capability_covers 재사용 실재 | **GO** | RT-3 target 5개 중 material-MAT_000074·process-PROC_000004·qty-016 = §33 KB 실 노드 grep 확인. 새 능력 어휘 mint 0. covered_axes 컨테이너일 뿐 축값 어휘 재발명 없음 |
| **3** | 관계 폐쇄목록 정합 | **GO** | 23(§33 19+X-1/3/4/5) → 29(+RT-1~RT-6). RT-1~RT-6 이름 전부 기존 R1~R19·X-1~X-5와 충돌 0(grep). RT-7 brokered_by = fulfillment_order.broker 속성 접기(관계 미추가) |
| **4** | D-ROUTE 경계(D-18 동형) | **GO** | routing_function E25·criterion 5축 전부 anchor=none·값 없음. 스코어/순위/배정값 계산·저장 0. routed_to/quote_from = 관계 타입만(값=엔진·§33 priced_by/D-18 완전 동형). codex strict NO-GO 이견은 D-18 선례로 기각(§4 상술) |
| **5** | 표준 인용 실재 | **GO** | schema.org Offer.deliveryLeadTime·eligibleQuantity **1차 재조회 실재**(정의 문구 일치). CIP4 PrintTalk RFQ/Quotation/PurchaseOrder·Subcontracting(신원 은닉)·다중로케이션 load-balancing **1차 재조회 실재**. GAP(XJDF capability 폐기·schema.org ProductionCapability 부재·MSDL 403) 정직 기록 |
| **6** | 라우팅 질의 경로 성립 | **GO** | RQ1~RQ6 전부 실 그래프 관계(capability_covers⁻¹·has_capability⁻¹·can_produce·references·subcontracts_to·quote_from)로 경로 그려짐. 못 답하는 N-R1~N-R6 = 의도적 경계(배정값·순위·실시간·미적재·은닉), 결함 은폐 아님 |
| **7** | §33 무손상 | **GO** | `git status _workspace/huni-ontology-kb/` = 변경 0. build_graph.py·02_ontology·03_kb 미변경. §35 델타 전량 03_upper_ontology/ 신규 파일에만(untracked) |

**종합: GO** — 단일 FAIL 없음. Med 1 + Low 3은 전량 문서 명료화(지어내기·앵커 무결·경계 위반 아님).

---

## 1. 재실측 증거 상세

### 1.1 focus #1 — 전 노드 GAP 정직성 (지어내기 차단 [최중요]) — GO
- 파일럿 노드 3개 독립 판독: `supplier-huni`(§8.2)·`cap-huni-digital-namecard`(§8.3) = anchor=none + badge=candidate + gap_ref=G-ROUTE-1 3필드 실재. `routefn-huni`(§8.4·E25 경계 노드) = anchor=none + candidate(gap_ref 없음 = L-ROUTE-4 정당 none·E19 quote_function 선례).
- 실 공급자·능력·MOQ·max_qty 값을 사실로 단정한 노드 **0건**. moq/max_qty/homepage 전부 "(능력 실측 후)"·"(레지스트리 확보 후)" 플레이스홀더.
- L-ROUTE-1이 "3필드 미동반 단정 = FAIL"로 기계 검증 가능(§7.1). 지어내기 차단 규약 유지.

### 1.2 focus #2 — capability_covers 재사용 실재 (재발명 0) — GO
- Example C(§8.3) RT-3 target 5개 재실측:
  - `material-MAT_000074` → §33 KB 실 노드(product-047 등 다수 참조) ✅
  - `process-PROC_000004` → §33 KB 실 노드(디지털 base 공정) ✅
  - `qty-016` → §33 KB 실 노드(product-016-premium-postcard) ✅
  - `printmethod-huni-digital` → §35 E18 투영 노드(anchor=none candidate·§33 아님) — E18은 upper-ontology 정의 개체·투영 노드로 수용
  - `size-016-90x50` → **§33 실 노드 미존재**(§33 규약 = `size-SIZ_*`·`size-<prd>-SIZ_*`) — 예시 id 불일치(D-2·Low)
- 새 능력 열거 어휘 mint **0**. covered_axes는 기존 축 노드를 묶는 컨테이너일 뿐(§2·§8.3). L-ROUTE-2가 신규 축 mint=FAIL 강제. 핵심 재사용 원칙 성립.

### 1.3 focus #3 — 관계 폐쇄목록 정합 — GO
- 현행 23종 = §33 19 + X-1 instance_of + X-3 same_family_as + X-4 price_model_differs + X-5 component_differs(X-2 mapped_to는 §33 승계·신규 아님). 재확인 일치.
- RT-1~RT-6(has_capability·can_produce·capability_covers·routed_to·quote_from·subcontracts_to) 이름 전부 R1~R19·X-1~X-5와 충돌 0. 23+6 = **29 정합**.
- RT-7 brokered_by 접기 타당: research proposal §5 권고(후니=고정 단일 중개)를 architect 채택. 다중 중개 실증 시 승격(G-ROUTE-4). 이름표 schema.org Order.broker 실재.

### 1.4 focus #4 — D-ROUTE 경계(D-18 동형) — GO (codex 이견 기각)
- routing_function E25 = anchor=none(값=엔진 권위·§1·§8.4) ✅ 경계 노드. criterion 5축 = 축 이름만·값 없음(§4.1) ✅.
- 스키마 어디에도 스코어링·가중·순위·최종 배정값 계산/저장 **없음**. RQ6 다목적은 명시적으로 엔진(multi-objective optimization)에 위임(§6 D-ROUTE 표).
- **codex 이견(strict NO-GO)**: "routed_to가 폐쇄관계로 있어 최종 supplier 저장 가능 → strict boundary 충돌." → **기각**. 근거: §33 D-18에서 `priced_by`(R8·product→price_formula)가 온톨로지 관계로 존재하되 값은 evaluate_price 엔진 권위 — 이는 이미 MB 게이트 통과. `routed_to`(값=엔진·layer="경계(엣지 존재까지)") = priced_by와 완전 동형이므로 동일 기준으로 허용. codex 판독 채택 시 이미 승인된 D-18도 무효가 되는 자기모순. 단, "runtime 인스턴스 전까지 엣지 미단정·엔진 저작" 명시 주석은 오구현 방지 권고(D-1·Med).

### 1.5 focus #5 — 표준 인용 실재 — GO (1차 출처 독립 재조회)
- **schema.org/Offer 재조회**: `deliveryLeadTime`("typical delay between the receipt of the order and the goods leaving the warehouse")·`eligibleQuantity`("interval and unit of ordering quantities for which the offer or price specification is valid") **실재·정의 문구 일치**. U-26.2/U-26.4 앵커 건전.
- **CIP4 PrintTalk 재조회**: RFQ·Quotation·PurchaseOrder 거래 객체 실재. Subcontracting("obscuring the identity of the subcontractor from the end-customer if desired") 실재. "load-balancing across multiple printing locations" 실재. RT-6·§1.1 인용 건전.
- schema.org Order.broker/seller = 잘 정립된 실 속성(WebFetch가 Offer 페이지만 조회해 Order 미포함이나 반증 아님·research §3.1 정의 인용 정확).
- 정직 GAP 3종 확인: XJDF device capability 구문 폐기(GAP-ROUTE-1)·schema.org ProductionCapability 타입 부재(GAP-ROUTE-2)·MSDL 원문 403(GAP-ROUTE-5) 전부 정직 기록. 환각 개념 0. 어휘만 차용(기술스택 미도입) 준수.

### 1.6 focus #6 — 라우팅 질의 경로 성립 — GO
- RQ1(R1·R2 최단납기)·RQ2(cost)·RQ3(하도급 subcontracts_to+broker)·RQ4(교차 quote_from+price_model_differs 재사용)·RQ5(MOQ bundle_qty)·RQ6(다목적 경계) 전부 실 관계로 경로 그려짐(§1 nl-query-paths-routing).
- 못 답하는 6종(N-R1 배정값·N-R2 순위·N-R3 실 데이터0·N-R4 실시간용량·N-R5 레드미포함·N-R6 하도급은닉) = 전부 의도적 경계, 결함 은폐 아님. G-ROUTE-1/D-ROUTE 이중성 정직.

### 1.7 focus #7 — §33 무손상 — GO
- `git status --short _workspace/huni-ontology-kb/` = **출력 없음**(변경 0). §35 03_upper_ontology/ = untracked(신규).
- build_graph.py·02_ontology/ontology-schema.md·03_kb/ 정본 미변경. 델타 전량 신규 파일 격리(파괴 0).

---

## 2. 결함 보드

| id | 심각도 | 게이트 | 내용 | 귀속 | 게이트 영향 |
|----|--------|--------|------|------|-------------|
| **D-1** | **Medium** | #4 | routed_to/quote_from이 폐쇄관계로 등재돼 "최종 배정값 저장 가능"으로 오구현될 여지(codex 제기). 현행 완화: layer="경계"·값=엔진 명시. 권고: runtime 인스턴스 전까지 엣지 미단정·엔진 저작임을 스키마에 명시 주석(D-18/priced_by 동형이라 게이트 통과이나 오구현 방지) | architect | 비차단(GO·D-18 선례 동형) |
| **D-2** | Low | #2 | Example C(§8.3) capability_covers target `size-016-90x50`가 §33 size 규약(`size-SIZ_*`) 불일치·실 노드 미존재. 나머지 4개는 실 id인데 size만 예시 id. "전부 기존 노드" 주장 정밀도 저하 | architect | 비차단(파일럿=candidate·지어내기 아님) |
| **D-3** | Low | #1 | E24 fulfillment_order = §1 타입표 앵커정책 행에 gap_ref 미표기(anchor=none+candidate만)·전용 파일럿 노드 부재. L-ROUTE-1 3필드 규약과 문서 일관성 보강 필요(codex 동의) | architect | 비차단(정책 행≠인스턴스·단정 노드 0) |
| **D-4** | Low | #2 | `printmethod-huni-digital`은 §35 E18 투영 노드(anchor=none candidate)로 §33 실 노드 아님 — §35 내 수용되나 "실 앵커" 아닌 투영임을 명시 권고 | architect | 비차단 |

**HIGH 결함: 없음.** 모든 결함은 문서 명료화·예시 id 정합(지어내기·경계 위반·앵커 날조 아님).

---

## 3. codex 독립 교차 기록 (codex-cli 0.142.3·read-only)

- 수행: 고위험 4문항 독립 판독(GAP 정직성·capability_covers 재사용·D-ROUTE 경계·폐쇄목록).
- codex 판정: #1 GO(+E24 gap_ref 지적)·#2 GO·#3 GO·**#4 NO-GO(strict)**.
- verify-gate 재판정: codex #4 NO-GO는 **가설**로 접수 후 §33 D-18(priced_by 온톨로지 관계·값=엔진·기 승인) 대조로 **기각**(과엄격 판독·채택 시 D-18 자기모순). codex의 E24 gap_ref 지적은 D-3(Low)로 채택. codex 주장 = 검증 전 사실 아님 원칙 준수.
- 독립성: codex에 verify-gate 사전 판정 비노출·생성자 산출 복사 아닌 원문 재판독 지시.

---

## 4. 종합 및 인간 승인 대기

- **종합 판정: GO** (라우팅 특화 게이트 7/7 통과·단일 FAIL 없음).
- 라우팅 층은 **스키마(형)만·전 실물 노드 GAP/candidate·지어내기 0·§33 무손상·표준 인용 1차 실재**. 안전.
- **비차단 권고**(architecture 게이트/실 시드 전 반영 권장): D-1(routed_to/quote_from runtime·엔진 저작 명시)·D-2(size 예시 id 실 노드로 교정)·D-3(E24 gap_ref/파일럿 보강)·D-4(투영 노드 명시).
- **경계 재확인**: 관계 폐쇄목록 정식 등재(RT-1~RT-6)·개체 승격(E22~E25)은 **아키텍처 게이트(MB7)+인간 승인** 후 확정(§33 확장이면 스키마 v1.1 머지·독립이면 §35 시드). 이 층은 DB 미적재. 실 공급자 레지스트리 확보 = 별도 도메인·인간 결정(G-ROUTE-1).
- 아키텍처 권고 자체는 기존 `architecture-recommendation.md`(Phase 4) 소관·본 판정은 라우팅 층 건전성만 확인. 라우팅 층이 두 아키텍처 경로 어느 쪽이든 재사용 가능(architecture-neutral)함을 재확인.

> 재게이트 시 이 파일에 append(덮어쓰기 금지).
