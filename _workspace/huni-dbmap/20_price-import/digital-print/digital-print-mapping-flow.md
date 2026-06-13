# 디지털인쇄비 매핑 절차 (digital-print-mapping-flow) — round-16

> **작성** 2026-06-13 · round-16. 가격표 `디지털인쇄비` 시트 → Phase11 가격엔진 그릇 → `evaluate_price` 흐름. **mermaid는 실제 분해 결과 반영(샘플 날조 금지·라이브 실측 comp_cd/use_dims 표기).** DB 미적재.

---

## 1. flowchart — 가격표 블록 → 그릇 (합산형)

```mermaid
flowchart LR
  subgraph 가격표["디지털인쇄비 시트 (2블록·954셀)"]
    B01["B01 국4절 매트릭스<br/>수량53 × 도수7 × 면2<br/>= 742셀"]
    B02["B02 3절 매트릭스<br/>수량53 × 도수2 × 면2<br/>= 212셀"]
  end

  subgraph 분해["도수·면·별색 분해 (엔진 매칭 단위)"]
    D1["흑백/CMYK<br/>→ clr_cd 차원"]
    D2["별색 5종<br/>→ 구성요소 분리"]
    D3["단면/양면<br/>→ _S1/_S2 구성요소"]
  end

  subgraph 그릇["t_prc_* 4테이블 (라이브 재현 RU)"]
    F["1 price_formulas<br/>PRF_DGP_A~F (6·합산형)"]
    FC["2 formula_components<br/>72 배선 (addtn_yn=Y)"]
    PC["3 price_components<br/>prc_typ_cd=.01 단가형"]
    CP["4 component_prices<br/>954행·10차원"]
    PB["1b product_price_formulas<br/>19 바인딩"]
  end

  B01 --> D1 & D2 & D3
  B02 --> D1 & D3
  D1 -->|"COMP_PRINT_DIGITAL_S1/S2<br/>use_dims=[siz,clr,min_qty]"| CP
  D2 -->|"COMP_PRINT_SPOT_*_S1/S2<br/>use_dims=[siz,min_qty]·clr=NULL"| CP
  D3 -->|"면=구성요소 접미"| PC

  F --> FC --> PC --> CP
  F --> PB

  classDef ru fill:#E2EFDA,stroke:#548235;
  class F,FC,PC,CP,PB ru;
```

**핵심**: 디지털인쇄비 시트 = 합산형 공식의 **인쇄비 부품**만 공급. 용지비(COMP_PAPER)·코팅(COMP_COAT_*)·후가공(COMP_PP_*) 등은 별 시트/트랙이 같은 공식에 합산됨(아래 §3).

---

## 2. sequenceDiagram — evaluate_price 계산 흐름 (CMYK 양면 국4절 100매)

```mermaid
sequenceDiagram
  participant U as 손님 선택
  participant E as evaluate_price (Phase11)
  participant F as price_formulas
  participant FC as formula_components
  participant CP as component_prices

  U->>E: 상품 016(프리미엄엽서)·CMYK·양면·국4절·수량 100
  E->>F: 상품바인딩 조회 (PRD_000016)
  F-->>E: PRF_DGP_A (합산형)
  E->>FC: PRF_DGP_A 구성요소 목록 (disp_seq)
  FC-->>E: COMP_PRINT_DIGITAL_S2 + 코팅 + 용지 + 후가공 + 별색…

  Note over E: 선택 옵션으로 활성 구성요소 결정 (양면→S2·CMYK·코팅선택)
  E->>CP: COMP_PRINT_DIGITAL_S2[siz=SIZ_000499, clr=CLR_000005, min_qty≤100]
  CP-->>E: unit_price = 700 (가격표 E26 일치)
  Note over E: prc_typ_cd=.01 단가형 → 700 × 출력매수
  E->>CP: COMP_PAPER[mat, siz=SIZ_000499] (용지비·별 시트)
  CP-->>E: 용지 절가 × (출력매수+5 손지율)
  Note over E: Σ 합산 (인쇄+용지+코팅+후가공+별색) = 판매가
  E-->>U: 견적가
```

- **출력매수 = 주문수량 ÷ 판걸이수**(앱 런타임·DB 미저장). **손지율 +5장**(앱). DB는 [수량행단가] lookup만([[dbmap-compute-in-app-db-stores-lookup]]).
- **min_qty 매칭**: 주문수량 100 → min_qty 100 행(상향구간 매칭). 동시매칭 0(자연키 유일).

---

## 3. 디지털인쇄비 위치 (합산형 공식 안에서) — 시트 경계

```mermaid
flowchart TB
  subgraph DGP["PRF_DGP_A 합산형 (판매가 = Σ)"]
    P["인쇄비<br/>(★디지털인쇄비 시트)"]
    PA["용지비<br/>(출력소재 IMPORT 시트)"]
    C["코팅비<br/>(코팅 시트)"]
    PP["후가공비<br/>(인쇄후가공·커팅타공 시트)"]
    SP["별색인쇄비<br/>(★디지털인쇄비 시트 별색5)"]
    FO["박(대형)<br/>(후가공_박 시트·BLOCKED)"]
  end
  P -.합산.-> SUM["판매가"]
  PA -.합산.-> SUM
  C -.합산.-> SUM
  PP -.합산.-> SUM
  SP -.합산.-> SUM
  FO -.BLOCKED.-> SUM

  classDef this fill:#FFF2CC,stroke:#BF9000;
  class P,SP this;
```

> **★ 표시 = 이 round-16 디지털인쇄비 시트 산출 범위**(인쇄비 + 별색인쇄비). 노란색 외 부품(용지·코팅·후가공·박)은 별 시트 산출이 같은 합산형 공식에 합쳐진다. 디지털인쇄비 시트 단독으로는 견적이 안 나오고, 6공식이 부품들을 Σ해야 완성.

---

## 4. 한 줄 현황

매핑 절차 mermaid 3종 완성 — ① 블록→그릇 flowchart(흑백CMYK=차원·별색=구성요소·단양면=_S1_S2) ② evaluate_price sequence(CMYK양면100매·인쇄비700 일치) ③ 합산형 공식 내 시트 경계(인쇄비+별색만 이 시트·용지/코팅/후가공은 별 시트). 라이브 실측 comp_cd·use_dims 반영(날조 0).
