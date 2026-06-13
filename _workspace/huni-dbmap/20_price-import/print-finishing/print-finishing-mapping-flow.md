# 인쇄후가공 → t_prc_* 매핑 절차 (mermaid)

> round-16. 가격표 시트 → 그릇 4테이블 → Phase11 엔진 흐름. 실제 분해 결과 반영(샘플 날조 금지).
> [전제] 라이브 완전 적재 + 배선 완결 + 216/216 정합. RU=라이브 재현.

---

## 1. 분해 flowchart (가격표 6블록 → 그릇)

```mermaid
flowchart LR
  subgraph 가격표["인쇄후가공 시트 (밴드 6블록·216 가격셀)"]
    B1["B1 모서리(귀돌이,합가)<br/>직각/둥근 × 9수량"]
    B2["B2 오시(합가)<br/>1/2/3줄 × 10수량"]
    B3["B3 미싱(합가)<br/>1/2/3줄 × 10수량"]
    B4["B4 가변텍스트<br/>1/2/3개 × 23수량"]
    B5["B5 가변이미지<br/>1/2/3개 × 23수량"]
    INC["증분룰 3건<br/>A12·A27·F27"]
  end

  subgraph 그릇["t_prc_* 4테이블 (라이브 재현)"]
    PC["price_components<br/>14 comp<br/>prc_typ_cd=.02?(P4)<br/>use_dims=[min_qty]"]
    CP["component_prices<br/>216행<br/>전 차원 NULL·min_qty만"]
    FC["formula_components<br/>28 배선"]
    PF["price_formulas<br/>PRF_DGP_A·D<br/>(디지털인쇄 합산형)"]
  end

  REF["C1_increment_rules_REF<br/>(앱 외삽·DB 미저장)"]

  B1 -->|comp 분리 RIGHT/ROUND| PC
  B2 -->|comp 분리 CREASE_1/2/3L| PC
  B3 -->|comp 분리 PERF_1/2/3L| PC
  B4 -->|comp 분리 VARTEXT_1/2/3EA| PC
  B5 -->|comp 분리 VARIMG_1/2/3EA| PC
  PC -->|언피벗 수량구간| CP
  INC -.->|DB 미저장·앱 책임| REF

  PF --> FC --> PC
  FC -.->|disp_seq 16~29 / 7~20| CP
```

핵심: 줄수/개수는 **opt_cd 차원이 아니라 comp 분리**(가격이 다른 변형 = 별 comp). 후가공은 독립 공식 없이 **디지털인쇄 합산형 공식(PRF_DGP_A·D)의 부품**으로 배선됨.

---

## 2. 엔진 계산 sequenceDiagram (evaluate_price 안에서 후가공 합산)

```mermaid
sequenceDiagram
  participant 손님
  participant 앱 as 앱(런타임)
  participant 엔진 as evaluate_price
  participant CP as component_prices

  손님->>앱: 엽서 + 둥근모서리 + 오시 1줄, 수량 1000
  앱->>엔진: target=엽서(PRF_DGP_A 바인딩), selections, qty=1000
  엔진->>엔진: 합산형 공식 = Σ 활성 구성요소
  Note over 엔진: 인쇄비·용지비 + 후가공(선택분만)
  엔진->>CP: COMP_PP_CORNER_ROUND, min_qty≤1000 매칭
  CP-->>엔진: min_qty=1000 → 11000원 (구간총액)
  엔진->>CP: COMP_PP_CREASE_1L, min_qty≤1000 매칭
  CP-->>엔진: min_qty=1000 → 25000원 (구간총액)
  Note over 엔진: prc_typ_cd=.02 합가형 →<br/>구간총액 그대로 합산(÷min_qty 환산 후 ×qty 아님)<br/>🔴 .01이면 ×1000=과대 (P4 컨펌)
  엔진->>엔진: 후가공 = 11000 + 25000 = 36000 합산
  엔진-->>손님: 인쇄비+용지비+36000(후가공)
```

> **P4 핵심**: 합가형(.02)이면 구간총액(11000)을 그대로 더함. 단가형(.01·라이브 현행)이면 11000을 장당가로 보고 ×1000=1100만원 → 비합리. Q-PF-1 해소가 계산 정확성의 관문.

---

## 3. 가격사슬 완결 검증 (아크릴 단절과 대비)

```mermaid
flowchart LR
  S["손님 선택<br/>둥근모서리"] --> F["PRF_DGP_A<br/>(상품 바인딩 ✅)"]
  F --> W["formula_components<br/>CORNER_ROUND 배선 ✅"]
  W --> D["price_components<br/>CORNER_ROUND 정의 ✅"]
  D --> P["component_prices<br/>216행 적재 ✅"]
  P --> R["엔진 조회 가능 ✅"]
  style R fill:#E2EFDA
```

| 시트 | 가격사슬 상태 |
|------|--------------|
| 인쇄후가공 | **완결** — 공식·배선·구성요소·단가행 전부 실재 + 216/216 정합 |
| 아크릴(round-16) | 단절 — 단가행 적재됐으나 배선 0(엔진 조회 불가) |
| foil-small(round-16) | 전면 미적재 — 신규 구축 필요 |

인쇄후가공은 round-16 시트 중 **유일하게 사슬 완결 + 전건 정합**. 미해소는 단가/합가 백필(P4)뿐.
