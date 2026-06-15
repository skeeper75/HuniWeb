# Huni-DBMap 하네스 구성 — round-21 상품군 동형 효율 파이프라인

> 이 문서만 읽으면 round-21 하네스가 어떻게 구성·작동하는지 한 판에 이해된다.
> 토대 모델 권위 = `.claude/skills/dbm-batch-load/references/product-group-isomorphism-model.md`(9섹션).

## 1. 핵심 아이디어 (3줄)

- 같은 상품군은 옵션 구성과 가격공식이 **동형**(계산공식집초안 권위). 후니 전체 **50개 미만**.
- **대표 1개**(시트 실측 superset)만 주문가능 형태로 **완전종단** 적재 → 동형 나머지는 **스크립트 자동전파**.
- 각 단계는 **이진 게이트**로 자율 검증·보정. 사람 개입은 **인간 승인 큐**(실 COMMIT·도메인 컨펌·권위 부재)만.

## 2. 파이프라인 흐름 (자율 자기개선 폐루프)

```mermaid
flowchart TD
    F["토대 모델<br/>출력소재·판걸이수·가격표 2분류<br/>동형성·적재 §9"]:::base --> Sc
    Sc["Sc 동형 분류 + 대표 선정<br/>계산공식집초안 × 옵션 · 50개 미만<br/>미출시 제외 · 대표 = 시트실측 superset"]:::gate --> S0
    S0["S0~S4 대표 5레이어 완전종단<br/>① 구성요소 BOM ② 옵션 CPQ<br/>③ 템플릿 ④ 제약 ⑤ 가격<br/>= 주문가능 형태 실적재"]:::load --> G
    G{"S5 이진 게이트<br/>가격 골든값 대조 · 견적 Q1~Q6<br/>멱등/제약위반0 · webadmin 가시성"}:::gate
    G -->|GO| Sp["Sp 동형 자동전파<br/>batch-load 스크립트<br/>+ 집계 전수 검증"]:::load
    G -->|NO-GO| R["결함 보정 라우팅<br/>round-13 교정 · 5 적재<br/>6 CPQ · 16/18 가격"]:::fix
    R --> S0
    Sp --> Q["인간 승인 큐<br/>실 COMMIT · 도메인 컨펌<br/>권위/골든값 부재"]:::human
    G -.사람 개입은 여기만.-> Q
    Q -.반복 결함이면.-> F

    classDef base fill:#e8f0fe,stroke:#4285f4
    classDef gate fill:#fef7e0,stroke:#f9ab00
    classDef load fill:#e6f4ea,stroke:#34a853
    classDef fix fill:#fce8e6,stroke:#ea4335
    classDef human fill:#f3e8fd,stroke:#a142f4
```

## 3. 에이전트·스킬 구성

```mermaid
flowchart LR
    O["huni-dbmap-orchestrator<br/>(round-21 등록)"]:::orch
    O --> RA["dbm-readiness-auditor<br/>Sc 분류·대표선정·게이트·조율"]:::lead
    O --> BL["dbm-batch-load<br/>Sp 동형 자동전파"]:::worker

    RA --> DR["dbm-domain-researcher<br/>도메인+경쟁사 리서치<br/>huniprinting.com 레거시 폴백"]:::worker
    RA --> LB["dbm-load-builder<br/>L1 기초·차원 적재"]:::worker
    RA --> OM["dbm-option-mapper<br/>CPQ 옵션·템플릿·제약"]:::worker
    RA --> PR["dbm-price-*<br/>가격 사슬·검증"]:::worker
    RA --> V["dbm-validator<br/>evaluator-active<br/>독립 검증 (생성≠검증)"]:::check

    F["토대 모델 reference"]:::base -.READ FIRST.-> RA
    F -.READ FIRST.-> DR
    F -.READ FIRST.-> BL

    classDef orch fill:#fef7e0,stroke:#f9ab00
    classDef lead fill:#e8f0fe,stroke:#4285f4
    classDef worker fill:#e6f4ea,stroke:#34a853
    classDef check fill:#fce8e6,stroke:#ea4335
    classDef base fill:#f3e8fd,stroke:#a142f4
```

## 4. 인쇄상품 가격구성요소 사슬 (토대 §2~6)

```mermaid
flowchart TD
    CF["계산공식집초안<br/>(상품군 동형 공식 권위)<br/>원자합산형·고정가형·면적매트릭스형"]:::auth
    CF -->|출력매수 = 주문수량 / 판걸이수| PH["판걸이수 시트<br/>작업사이즈→판걸이·인쇄가능영역<br/>사방5mm·완칼/반칼 여백"]:::base
    CF -->|용지비| M["출력소재(IMPORT)<br/>종이=국4절/3절 단가<br/>비종이=가격없음(합가매트릭스로 이동)"]:::base
    CF -->|인쇄·코팅·후가공비| PROC["가공/공정 8종<br/>(추가가)<br/>디지털인쇄비·코팅·박·제본…"]:::proc
    CF -->|상품 포함가| PROD["상품자체 8종<br/>(포함가)<br/>스티커·명함·아크릴·포스터사인…"]:::prod
    PROC --> PRC["t_prc_* 4단<br/>formula → components<br/>→ component_prices"]:::db
    PROD --> PRC
    M --> PRC

    classDef auth fill:#fef7e0,stroke:#f9ab00
    classDef base fill:#e8f0fe,stroke:#4285f4
    classDef proc fill:#e6f4ea,stroke:#34a853
    classDef prod fill:#f3e8fd,stroke:#a142f4
    classDef db fill:#fce8e6,stroke:#ea4335
```

## 5. 적재 산출 기준 (토대 §9 — 실무진 가시성)

| 축 | 컬럼 | 용도 |
|----|------|------|
| 시스템 코드 | `*_cd` (SIZ_000xxx) | 순번 surrogate·FK·정렬 |
| 관리 인식 명칭 | `*_nm`·tags | 실무진 관리화면 식별 |
| 고객 UI 명칭 | disp_nm | 위젯/사이트 표시 |
| 비고 | note | 실무진 쉬운 한국어(전문가 식별자 금지) |

- 명칭 권위 = **후니 용어**(경쟁사 참조만). 사이즈 = 공용/상품군전용/**판형(`impos_yn='Y'`)** 구분 + search-before-mint 중복 금지 + 정규화.
- 적재 후 `raw/webadmin` admin에서 실무진이 알아보는 형태로 보이는지 = webadmin 가시성 게이트.
