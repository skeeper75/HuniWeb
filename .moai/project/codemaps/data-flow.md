# HuniWeb — 데이터 흐름

> 개요: [overview.md](overview.md) | 모듈: [modules.md](modules.md) | 의존성: [dependencies.md](dependencies.md) | 진입점: [entry-points.md](entry-points.md)

---

## 1. Print-Quote 파이프라인

**입력 자산:** `docs/huni/*.xlsx·pdf`, `_workspace/print-quote/_baseline/` (이전 스키마 7종), buysangsang.com (라이브 크롤)

```mermaid
flowchart TD
    A["사용자 트리거\n'후니프린팅 자동견적 사이트 설계'"] --> B

    B["Phase 0\n컨텍스트 확인\n(초기/부분재실행/증분)"]

    B --> C["Phase 1\npq-pm 단독\n마일스톤·RACI·task-graph\n→ 00_pm/"]

    C --> D["Phase 2 — 병렬"]
    D --> E["pq-researcher\n경쟁사 라이브 크롤\n(print-quote-live-crawl)\n→ 01_research/"]
    D --> F["pq-business-analyst\nhuni 실데이터 분석\n→ 02_business/"]

    E --> G["Phase 3 — 병렬"]
    F --> G
    G --> H["pq-architect\nIA·ERD·API·가격엔진\n→ 03_architecture/"]
    G --> I["pq-designer\n화면설계·UX 플로우\n→ 04_design/"]

    H -->|"ia.md 즉시 공유"| I
    I -->|"API 갭 피드백"| H

    H --> J["Phase 4\npq-pm 단독\n교차검증 + 통합 설계서\n→ 99_integrated/"]
    I --> J

    J --> K["Phase 5\n사용자 보고 + 피드백 수집"]
```

**산출물:** `_workspace/print-quote/` — 설계 문서 ~30개 파일 (MD, SQL, wireframes)

---

## 2. Huni-Widget 파이프라인

**입력 자산:** `docs/reversing/red_reverse_engineer/` (역공학 4모듈), `raw/widget_monitor/local/` (라이브 테스트베드), `_workspace/print-quote/04_design/DESIGN.md` (14 componentType), `.env.local` (RP_*)

```mermaid
flowchart TD
    A["사용자 트리거\n'후니 위젯 구현'"] --> B

    B["Phase 0\n컨텍스트 확인\n(초기/부분재실행/확대 스테이지)"]

    B --> C["Phase 1\nhw-reverse-engineer\nRed 역공학 보강\n(S3 presigned·가격 rule·postMessage)\n→ 01_reverse/"]

    C --> D["Phase 2 — 병렬"]
    D --> E["hw-runtime-analyst\n동작 구조·시퀀스 다이어그램\n→ 02_analysis/"]
    D --> F["hw-researcher\nBP 리서치\n→ 02_research/"]

    E --> G["Phase 3\nhw-architect\n위젯 명세\n(계약·어댑터·componentType 매핑)\n→ 03_spec/"]
    F --> G

    G --> H["Phase 4\nhw-builder (메인 트리)\nReact 구현\n→ 04_build/\n[vitest 150, tsc, build]"]

    H --> I["Phase 5\nhw-qa\n경계면 교차 QA\n→ 05_qa/"]

    H --> J["Phase 6\nhw-design-fidelity\n후니 스킨 시각재현\n→ 06_fidelity/"]

    I --> K["GO 판정\n(독립 재검증 필수)"]
    J --> K

    K -->|"신규 상품 확대"| L["확대 스테이지 루프\n캡처 선행 → 어댑터 명세 → 빌더 → QA\n(위젯 코어 0변경 INV-3)"]
    L --> K
```

**산출물:** `_workspace/huni-widget/04_build/` — React 위젯 구현 코드 (유일한 1차 앱 코드)

---

## 3. Huni-DBMap 파이프라인 (round 기반 진화)

**입력 자산:** `docs/huni/*.xlsx` (상품마스터·가격표), `raw/webadmin/` (적재 oracle), Railway DB (읽기전용), `.env.local` (RAILWAY_DB_*)

Huni-DBMap은 단일 파이프라인이 아니라 **round 단위로 진화하는 다중 트랙** 구조다. 각 round는 이전 round의 산출물을 입력으로 받는다.

```mermaid
flowchart TD
    IN1["docs/huni/*.xlsx"] --> R1
    IN2["raw/webadmin/\n(sql/·tools/)"] --> R1
    IN3[("Railway DB\n읽기전용")] --> R1

    R1["round-1\n수량구간 할인\ndbm-schema-analyst + dbm-excel-analyst\n→ t_dsc_* 매핑 DONE"]
    R1 --> R2["round-2\n가격 공식 엔진\nt_prc_* 4단 구조\n→ 15시트 평면화 DONE"]
    R2 --> R3["round-3\n매핑 정합 검증 (L1↔L2)\n→ 9속성 전수 DONE"]
    R3 --> R4["round-4\n적재본 조립 G1~G9\n→ 양 트랙 GO DONE"]
    R4 --> R5["round-5\n멱등 실행본 R1~R6\n→ 실제 적재 완료\n(인쇄가격 3,504행·마스터 398행)"]
    R5 --> R6["round-6\nCPQ 옵션 레이어 매핑\n→ silsa 43행 적재"]
    R6 --> R7["round-7\n입체 커버리지 검증\n209셀 매트릭스 GO"]
    R7 --> R8["round-8~9\nadmin UI 입력 명세\n+ CPQ silsa 적재"]
    R8 --> R10["round-10\n버전 변경 추적 하네스\n260527→260610 diff GO"]
    R10 --> R11["round-11\n컬럼 도메인 의미\n+ 상품 BOM + 적재명세\n11시트 완료"]
    R11 --> R12["round-12\n매핑 확정 리서치\n5 family GO"]
    R12 --> R13["round-13\n라이브 정합 교정\n11/11 시트 GO"]
    R13 --> R14["round-14\nwebadmin 스키마 변경 추적\n(현재 활성)"]

    R14 -->|"stale 영향 → 갱신"| KB["Print-KB-Wiki\n(소비)"]
    R5 -->|"적재 완료 사실"| KB
```

**게이트 체계:**
- round-4: G1~G9 (적재 가능성)
- round-5: R1~R6 (멱등성·실행 가능성)
- round-6: 트리거 reference resolution
- round-7: C1~C8 (입체 커버리지)
- round-10: V1~V8 (변경 추적)
- round-12: M1~M6 (매핑 확정)
- round-13: K1~K6 (라이브 교정)
- round-14: W1~W6 (스키마 변경)

---

## 4. Huni-Admin-Manual 파이프라인

**입력 자산:** `raw/webadmin/` (Django 소스), Railway DB (읽기전용), 라이브 admin 사이트 (읽기 탐색만)

```mermaid
flowchart TD
    A["사용자 트리거\n'admin 매뉴얼 작성'"] --> B

    B["Phase 0\n컨텍스트 확인"]

    B --> C["Phase 1\n준비\n(.env.local 확인, 디렉토리 생성)"]

    C --> D["Phase 2\n팀 구성\n(5인 + 의존성 TaskCreate)"]

    D --> E["T1: ham-source-analyst\nDjango admin 소스 전수 분석\n→ 01_source_admin-screen-map.md\n(뿌리 산출)"]

    E --> F["T2+T3 — 병렬"]
    F --> G["T2: ham-db-verifier\nDB 코드값 실측\n→ 02_db_value-domains.md"]
    F --> H["T3: ham-live-capturer\ngstack 화면 캡처\n→ captures/*.png\n+ 03_capture_screen-index.md"]

    G --> I["T4: ham-manual-writer\n11챕터 집필\n(스크린샷 임베드)\n→ manual/*.md"]
    H --> I

    I -->|"챕터별 점진 검증"| J["T5: ham-manual-qa\n전수 커버리지·정합\n→ 04_qa_manual-gate.md\n(GO/NO-GO)"]

    J -->|"GO"| K["Phase 4.5\nham-docs-publisher\nMkDocs Material 발행\n→ site-src/\n+ .github/workflows/docs.yml"]

    K --> L["최종 확정·보고"]
```

**산출물:** `_workspace/huni-admin-manual/` — 매뉴얼 11챕터·스크린샷 41개·MkDocs 사이트

---

## 5. Print-KB-Wiki 파이프라인

**입력 자산:** 전 하네스 산출물 + `docs/huni/` + `raw/webadmin/` (read-only 전부)

```mermaid
flowchart TD
    SRC["전 하네스 산출물\n(print-quote·huni-widget·huni-dbmap\nhuni-admin-manual·docs/huni·raw/webadmin)"]

    SRC --> A["Phase 0\n컨텍스트 확인\n(초기/부분재실행/델타 갱신)"]

    A --> B["Phase 1 — 병렬"]
    B --> C["pkw-source-curator\n원천 tier/freshness 등급\n11 family + 6 axis 큐레이션 팩\n→ wiki/_curation/"]
    B --> D["pkw-researcher\n방법론 + 검증 리서치\n(Karpathy·온톨로지·llms.txt)\n→ wiki/_research/"]

    C --> E["Phase 2\n스키마 비준\n(메인 + 사용자 AskUserQuestion)"]
    D --> E

    E --> F["Phase 3 — family 파이프라인\n(순차 또는 독립 family 2~3 병렬)"]

    F --> G["pkw-recipe-writer\n레시피 페이지 집필\n(정체→차원→BOM→가격→CPQ→위젯→적재→결함)\n→ wiki/recipes/<family>.md"]

    G --> H["pkw-wiki-qa\nW1~W8 게이트\n→ wiki/_qa/<family>-gate.md"]

    H -->|"NO-GO"| G
    H -->|"GO"| I{"다음 family?"}
    I -->|"있음"| F
    I -->|"전 family 완료"| J

    J["Phase 4\n횡단 마감\npkw-wiki-qa scope=전체\n(전역 링크·고아·index·CQ 커버리지)"]

    J --> K["커밋\n(.env.local IGNORED 확인)"]
```

**W-gate 요약:**
- W1: 날조 없음 (출처+badge 전수)
- W2: 뼈대 완전성 (8섹션)
- W3: 라이브 DB 정합 (t_* 행 실측)
- W4: 가격 사슬 추적 (file:§ 인용)
- W5: 위젯 계약 정합 (src/contract/ 일치)
- W6: 결함 현황 양면 표기 (현재값 vs 정답)
- W7: STALE/v03 인용 0
- W8: dry walk-through (위키만으로 등록 절차 완결)

---

## 공통 핸드오프 사이클

모든 하네스가 세션 경계에서 따르는 표준 루틴이다.

```mermaid
flowchart LR
    A["하네스 작업 완료"] --> B["커밋\n(.env.local IGNORED 검증)"]
    B --> C["HANDOFF.md 갱신\n(다음 시작점·미해결·결정·금지)"]
    C --> D["CLAUDE.md 변경 이력 갱신\n(최근 3건 유지)"]
    D --> E["auto-memory 갱신\n(비자명 사실만)"]
    E --> F["다음 세션\nHANDOFF.md 읽고 재개"]
```

**핸드오프 트리거:** "다음세션을 위해 정리" / "핸드오프 정리" / "세션 마무리" → `CLAUDE.md §4` 루틴 자동 실행.

HANDOFF.md 보유 하네스: `huni-widget`, `huni-dbmap`, `huni-admin-manual`
HANDOFF 미보유 (CHANGELOG + CLAUDE.md로 대체): `print-quote`, `print-kb-wiki`
