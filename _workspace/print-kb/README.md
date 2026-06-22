# Print-KB — 인쇄 도메인 지식 수집 하네스 (LLM Wiki 전단계)

> 작성 2026-06-05. 설명 한국어, 식별자/코드/SQL 영어.
> 방법론 근거: CommonKADS(Schreiber et al.) · KE 기법(card sort/laddering/repertory grid/protocol) · 역량질문(Grüninger & Fox; METHONTOLOGY/NeOn).

---

## 0. 이 하네스가 하는 일

후니프린팅 인쇄 도메인 지식을 **구조 먼저(모델링)** 방식으로 수집해, LLM Wiki 온톨로지
설계(Phase 0)로 인계할 **전단계 산출물**을 만든다. 원칙: "다 모으기 ✗, 빠뜨릴 수 없게 만들기 ◯".

누락 방지 3겹:
- **맥락**(CommonKADS) — `domain-context-model.md`: 가치사슬 태스크 분해
- **출처**(3계층) — `source-registry.md`: 1차/2차/3차 출처 + provenance
- **검증**(역량질문) — `cq-registry.md`: 위키가 반드시 답해야 할 질문 = 완전성 기준선

---

## 1. ⚠️ 핵심 전제 — 지식은 부재가 아니라 "흩어져 있음"

이 레포에는 이미 인쇄 도메인 지식이 **두 하네스에 풍부하게 축적**돼 있다. 본 하네스는
**재수집이 아니라 CQ 기반 완전성 프레임으로 통합·공백 노출**이 목적이다.

| 기존 자산 | 렌즈 | 위치 | 주 커버 그룹 |
|---|---|---|---|
| **huni-dbmap / 07_domain** | DB 의미축 (L0~L3) | `_workspace/huni-dbmap/07_domain/` | 공정·후가공·용어·제품(생산방식) |
| **huni-dbmap / 06_extract** | 엑셀 L1 충실추출 | `_workspace/huni-dbmap/06_extract/` | 제품(SKU)·가격(이연) |
| **huni-dbmap / 00_schema** | 가격 공식엔진 DDL | `_workspace/huni-dbmap/00_schema/price-engine-*` | 가격/견적 |
| **print-quote / 02_business** | 비즈니스 분석 | `_workspace/print-quote/02_business/` | 가격·주문·파일·정책·카탈로그 |
| **huni-widget / 01_reverse** | 옵션 스키마 역공학 | `_workspace/huni-widget/01_reverse/` | 제품 옵션 캐스케이드 |

전략 H(`huni-dbmap/05_method/H-domain-knowledge-strategy.md`)가 이미 4계층 KB 모델
(L0 인쇄방식 taxonomy / L1 term-bridge / L2 공정레시피 / L3 엔티티의미)·권위순서·confidence
ledger를 설계했다. **본 하네스는 그 dbmap 한정 렌즈를 LLM Wiki용 전(全)도메인 8그룹으로 확장**한다.

---

## 2. 단계 A→F (순서 엄수)

| 단계 | 내용 | 산출 | 상태 |
|:--:|---|---|:--:|
| **A** | 역량질문(CQ) 작성 — 완전성 기준선 | `cq-registry.md` (81 CQ) | ✅ 완료 |
| **B** | 맥락 모델 — 가치사슬 태스크 분해 | `domain-context-model.md` (7태스크) | ✅ 완료 |
| **C** | 문서·하드데이터 수집 (내부 파싱 + 외부 `/deep-research`) | 내부=기존자산 연결 완료 / 외부=대기 | 🟡 내부완료·외부대기 |
| **D** | 암묵지 인터뷰 (Claude=인터뷰어, 지니=전문가) — **병렬화 금지** | `interview-log.md` (세션1: 12 CQ) | 🟡 세션1 완료(83%) |
| **E** | 정규화 → **LLM 위키**(Karpathy 모델) — 엔티티/개념 페이지 | `wiki/` (정책 도메인 파일럿) | 🟡 정책 도메인 완료 |
| **F** | 완전성 검증 — CQ 커버리지·포화·삼각측량·lint | 그룹별 커버리지% + GAP | 🟡 1차 삼각 + 위키 lint 완료 |

**현재 상태(2026-06-05 세션1 종료):** CQ 커버리지 **86%** · ✅60/🟡19/🔴2 · claim 12건 · **위키 정책 도메인 57항목**.
**산출물:** `cq-registry.md` · `domain-context-model.md` · `source-registry.md` · `interview-log.md` · `claims/`(3 yaml) · **`wiki/`**(Karpathy LLM 위키: SCHEMA·index·log + 정책 엔티티 10페이지).

### 🆕 LLM 위키 (`wiki/`) — Karpathy 모델 (gist 442a6bf)
3계층(원천 불변 / LLM 위키 / 스키마) · 특수파일 `index.md`(먼저 읽기)·`log.md`(append-only) ·
워크플로 ingest/query/lint. **정책 도메인 파일럿 완료** — 다음 도메인(taxonomy·process·pricing·terms)은
dbm/pq 자산에서 점진 인계. 빠른 접근 = `wiki/index.md` 카탈로그 → 페이지 지목.

---

## 3. 출처 3계층 (모든 칸 추적 — 미착수 칸=미완성)

- **1차(내부·원천):** 지니 암묵지(26년), 가격표 엑셀, MES/상품마스터, 주문·견적 이력,
  레거시 buysangsang.com, 외주사(비즈하우스·후지필름) 규칙
- **2차(외부 검증):** 경쟁사 옵션·가격 체계, 장비/용지/후가공 공급사 스펙, 산업표준
  (색관리·인쇄용PDF·용지절수 — 카테고리만 고정, 구체 규격은 수집 중 확정)
- **3차(배경):** 인쇄 교과서·용어사전 (정의·표준용어 대조용)

상세 = `source-registry.md`. 출처 1개=`[단일출처]`, 2개 이상 독립=`[검증]`.

---

## 4. claim 수집 포맷 (출처 필수)

```yaml
- claim_id: KC-0001
  statement: <한 문장 = 한 검증가능 사실>
  group: 제품|가격|공정|파일|후가공|용어|정책|외주
  source_type: 1차-암묵지|1차-내부|2차-경쟁사|2차-표준|3차
  source_ref: <파일/행, URL, 인터뷰ID>
  verification: 검증|단일출처|OPEN
  answers_cq: [CQ-012]
```

claim 레지스트리 = `claims/` (그룹별 yaml). CQ와 양방향 추적.

---

## 5. 8 CQ 그룹

제품/카탈로그 · 가격/견적 · 공정/생산 · 파일/입고 · 후가공 · 용어/규격 · 정책/제약 · 외주/정산

입도: **아키타입 3종 · 카테고리 11종** 수준에서 시작 → GAP 보이는 영역만 세분화.

- **아키타입 3종(생산구조, 라이브 권위):** A 통합상품 / B 셋트상품(반제품 분해) / C 완제품·단일
- **카테고리 11종(상품군):** digital-print · sticker · booklet · photobook · calendar ·
  design-calendar · acrylic · silsa · goods-pouch · product-accessory · stationery

---

## 6. 인계 (종료 조건)

CQ 커버리지 목표 도달 + 단일출처 해소/OPEN 정리 →
`cq-registry.md`(요구사항) + `domain-context-model.md`(엔트리 뼈대) + claim 레지스트리(본문·출처)
→ **위키 온톨로지 설계(Phase 0)**.

전체 흐름: 수집 → 구조 설계 → 대량 생성 → 교차검증.
