# 접지옵션 매핑 절차 (folding-mapping-flow) — round-16

> **작성** 2026-06-13 · round-16. 가격표 `접지옵션` 시트 → Phase11 가격엔진 4테이블 그릇 → `evaluate_price` 흐름. 노드 라벨에 실제 comp_cd·proc_cd·use_dims 표기(샘플 날조 금지). **DB 미적재.**

---

## 1. flowchart — 가격표 블록 → 분해 → t_prc_* 그릇

```mermaid
flowchart LR
  subgraph 가격표["접지옵션 시트 (2블록 336셀)"]
    B1["블록1 카드접지 단가<br/>(오시+접지)<br/>3컬럼 × 48구간"]
    B1H["헤더 '/' 복합:<br/>2단가로 / 2단세로<br/>3단가로 / 3단세로<br/>6단오시 / 6단미싱"]
    B2["블록2 리플렛접지 단가<br/>(오시+접지)<br/>4컬럼 × 48구간<br/>반/3단/병풍/대문"]
  end

  subgraph 그릇["t_prc_* 4테이블 그릇"]
    PF["price_formulas<br/>PRF_FOLD_SUM·PRF_DGP_C·PRF_DGP_E"]
    PPF["product_price_formulas<br/>접지카드27/29·배경지43~45·리플렛48"]
    FC["formula_components<br/>배선(disp_seq·addtn_yn)"]
    PC["price_components<br/>CARD_2H/3H/6CR·LEAF_4종<br/>prc_typ_cd=.01 단가형<br/>use_dims=[min_qty]"]
    CPR["component_prices RU<br/>336행·proc_cd=NULL(collapse)"]
    CPD["component_prices DECOMP<br/>480행·proc_cd 개별분해<br/>(2단가로=PROC_000065 등)"]
  end

  B1 -->|언피벗 수량×단가| CPR
  B1H -->|collapse 금지·proc_cd 차원| CPD
  B2 -->|언피벗| CPR
  PF --> PPF
  PF --> FC
  FC --> PC
  PC --> CPR
  PC -.개별분해 제안.-> CPD

  CARD3H["🔴 CARD_3H·CARD_6CR<br/>단가행 적재 O·배선 0"]
  CPR -.단절.-> CARD3H
  CARD3H -.->|"FC 배선 누락=엔진 조회불가"| FC

  classDef warn fill:#FCE4D6,stroke:#C00000;
  classDef new fill:#FFF2CC,stroke:#BF8F00;
  class CARD3H warn;
  class CPD new;
```

- **핵심**: 가격표 단가컬럼 → `component_prices`. 헤더 "/" 개별 접지옵션은 RU(collapse·proc_cd NULL)와 DECOMP(proc_cd 명시) 두 그릇으로 병기(택1 컨펌 Q-FOLD-1).
- **🔴 단절**: CARD_3H·CARD_6CR은 단가행 있으나 `formula_components` 배선 0 → 카드 3/6단 접지 엔진 조회불가.

---

## 2. sequenceDiagram — evaluate_price 계산 흐름 (RU 경로)

```mermaid
sequenceDiagram
  participant U as 손님(위젯)
  participant E as evaluate_price 엔진
  participant PPF as product_price_formulas
  participant FC as formula_components
  participant CP as component_prices

  U->>E: 인쇄배경지(PRD_000043), 2단접지, 수량 500
  E->>PPF: 상품 PRD_000043 → 공식?
  PPF-->>E: PRF_DGP_C
  E->>FC: PRF_DGP_C 구성요소 목록
  FC-->>E: ...접지 COMP_FOLD_CARD_2H(seq4·addtn_yn=Y)...
  E->>CP: CARD_2H, min_qty≤500 최대구간
  CP-->>E: min_qty=500 → unit_price=80(가격표 B34)
  Note over E: 단가형(.01): 80 × 출력수량 = 접지비
  E->>E: Σ(인쇄+용지+접지+...) = 판매가

  rect rgb(252,228,214)
  U->>E: 3단접지카드(PRD_000029), 6단접지, 수량 500
  E->>PPF: PRD_000029 → PRF_DGP_E
  E->>FC: PRF_DGP_E 구성요소
  FC-->>E: LEAF_HALF/3FOLD/4ACC/4GATE만(CARD_6CR 미배선)
  Note over E,CP: 🔴 6단 카드 단가행 존재하나 배선 0 → 조회불가
  end
```

- **단가형 환산**: 셀=장당가 → `unit_price × 주문수량`(합가형 환산 없음).
- **단절 시나리오**(빨강): 카드 6단 선택 시 PRF_DGP_E에 CARD_6CR 미배선이라 엔진이 접지비 0 또는 누락.

---

## 3. 한 줄 현황

접지옵션 매핑 절차 = 가격표 2블록 336셀 → `component_prices`(RU collapse 336 / DECOMP proc_cd 480) → `price_components`(단가형·[min_qty]) → `formula_components` 배선 → `price_formulas`(FOLD_SUM·DGP_C·DGP_E) ← `product_price_formulas` 바인딩. **🔴 CARD_3H/6CR 배선 단절** 시각화. evaluate_price = 단가형 곱셈 합산.
