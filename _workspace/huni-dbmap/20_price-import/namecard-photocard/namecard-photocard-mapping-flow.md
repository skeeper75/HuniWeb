# 명함포토카드 매핑 절차 (namecard-photocard-mapping-flow) — round-16

> **작성** 2026-06-13 · round-16. 가격표 시트 → Phase11 가격엔진 `t_prc_*` 4테이블 그릇 → `evaluate_price` 계산 흐름. mermaid는 실제 분해 결과 반영(라이브 실측 comp_cd·use_dims). **DB 미적재.**

---

## 1. flowchart — 가격표 13블록 → 그릇 4테이블

```mermaid
flowchart LR
  subgraph SHEET["명함포토카드 시트 (13블록)"]
    direction TB
    B01["B01 스탠다드<br/>소재5×단/양면×100"]
    B02["B02 프리미엄<br/>소재A7/B7×단/양면"]
    B03["B03 코팅<br/>아트250/300"]
    B04["B04 펄<br/>스타드림4종"]
    B05["B05 투명<br/>PET/반투명·단면"]
    B06["B06 화이트인쇄<br/>화이트/클리어4조합"]
    B07["B07 모양 90x50"]
    B08["B08 미니 50x50"]
    B09["B09 오리지널박<br/>박종류×수량밴드+동판셋업"]
    B10["B10 포토카드<br/>20장1세트"]
    B11["B11 투명포토카드"]
    B12["B12 포토카드 대량<br/>총제작수량 20~3000 밴드"]
    B13["B13 외삽노트<br/>(부유셀·note보존)"]
  end

  subgraph GRID["t_prc_* 4테이블 그릇"]
    direction TB
    F["1 price_formulas<br/>PRF_NAMECARD_*·PRF_PHOTOCARD_*"]
    BIND["1b product_price_formulas<br/>PRD↔공식 바인딩"]
    FC["2 formula_components<br/>공식=comp 배선·disp_seq"]
    PC["3 price_components<br/>comp_typ.06 완제품비<br/>prc_typ_cd·use_dims"]
    CP["4 component_prices<br/>10차원: mat_cd·siz_cd·bdl_qty·min_qty"]
  end

  B01 -->|"mat_cd 개별5·min_qty=100"| CP
  B02 -->|"_MGA/_MGB·소재A7/B7"| CP
  B03 -->|"mat_cd 2"| CP
  B04 -->|"mat_cd 4(로츠쿼츠 정정)"| CP
  B05 -->|"소재2(현 collapse)"| CP
  B06 -->|"화이트/클리어=comp접미사·소재5"| CP
  B07 -->|"siz_cd=90x50"| CP
  B08 -->|"siz_cd=50x50"| CP
  B09 -->|"박단가밴드 + 동판셋업(addtn_yn=Y 합산)"| CP
  B10 -->|"bdl_qty=20·siz=55x86"| CP
  B11 -->|"투명세트"| CP
  B12 -->|"min_qty 밴드 20~3000"| CP
  B13 -.->|"데이터 아님·note 보존"| X[("부유셀")]

  F --> FC --> PC --> CP
  F --> BIND

  classDef ok fill:#d5f5e3,stroke:#27ae60;
  classDef broken fill:#fdedec,stroke:#e74c3c;
  class B01,B10,B11 ok;
  class B02,B03,B04,B05,B06,B07,B08,B09,B12 broken;
```

> 🟢 = 가격사슬 완결(배선+바인딩). 🔴 = **단가행 적재됐으나 미배선/미바인딩**(24 고아 comp·7 미바인딩 상품 — `decomposition §4`).

---

## 2. 인쇄면·소재 분해 매핑 (복합셀 → 차원)

```mermaid
flowchart TB
  subgraph CELL["가격표 복합셀"]
    H1["헤더: 단면 | 양면"]
    H2["소재: 백모조220 / 아트250 / 스노우250"]
    H3["소재그룹: A: 랑데뷰240 / ... B: 린넨 / ..."]
    H4["박종류: 금/은/먹유광·청박·적박·동박 | 홀로그램/트윙클"]
    H5["기본가(아연판) 5000"]
  end
  H1 -->|"차원 컬럼 아님"| S["구성요소 접미사<br/>_S1(단면)/_S2(양면)"]
  H2 -->|"'/' = 개별소재·collapse 금지"| M["mat_cd 개별행<br/>074·081·091..."]
  H3 -->|"그룹=접미사·소재=mat_cd"| MG["_MGA/_MGB<br/>+ 소재7종 each"]
  H4 -->|"박색=가공variant"| FOIL["comp 접미사<br/>_STD/_HOLO"]
  H5 -->|"수량무관 1회비"| SETUP["별 comp _FOIL_SETUP<br/>use_dims=[]·addtn_yn=Y"]
```

---

## 3. sequenceDiagram — evaluate_price 계산 (B01 스탠다드 예·합가형 가정)

```mermaid
sequenceDiagram
  participant U as 손님(위젯)
  participant E as evaluate_price
  participant BIND as product_price_formulas
  participant FC as formula_components
  participant PC as price_components
  participant CP as component_prices

  U->>E: target=PRD_000033(스탠다드)<br/>selections={소재:아트250, 인쇄:단면}<br/>qty=100
  E->>BIND: PRD_000033의 공식?
  BIND-->>E: PRF_NAMECARD_FIXED
  E->>FC: 공식 구성요소?
  FC-->>E: COMP_NAMECARD_STD_S1(단면)
  E->>PC: prc_typ_cd? use_dims?
  PC-->>E: 권고 .02 합가형 · use_dims=[mat_cd,min_qty]
  E->>CP: comp=STD_S1, mat=MAT_000081, min_qty≤100 최대구간
  CP-->>E: unit_price=3500 (100매 총액)
  Note over E: 합가형(.02): 3500 ÷ 100매 = 35/장 × 주문수량<br/>(단가형 .01이면 3500 그대로 = 100매가)
  E-->>U: 가격 = 3500원 (100매 기준)
```

> 🔴 **현행 라이브 결함**: ① STD만 배선이라 PRD_000031(프리미엄)을 골라도 `FC`가 STD_S1 반환 → 스탠다드 단가 오출. ② prc_typ=.01이면 합가형 환산 미발동(decomposition §2 Q-NC-1).

---

## 4. 가격사슬 상태 한눈에

```mermaid
flowchart LR
  STD["STD·PHOTOCARD<br/>✅ 단가행+배선+바인딩"] --> ENGINE1["엔진 조회 가능"]
  ORPHAN["24 comp<br/>(PREMIUM·COAT·PEARL·CLEAR·<br/>WHITE·SHAPE·MINI·FOIL·BULK)<br/>🔴 단가행 O·배선 X"] --> DEAD["엔진 조회 불가<br/>(가격사슬 단절)"]
  NOPRD["펄·모양·미니·박·투명·화이트·형압<br/>🔴 상품 바인딩 X"] --> DEAD
  DEAD --> FIX["복구: 공식분리+배선+바인딩<br/>(decomposition §6·인간 승인)"]
```

---

## 5. 한 줄 현황

매핑 절차 시각화 완료 — flowchart(13블록→4테이블·🟢3완결/🔴9단절)·복합셀 분해(단/양면=접미사·소재=mat_cd 개별·박색=variant·셋업=별comp)·evaluate_price 시퀀스(합가형 환산·오매칭 경고)·가격사슬 상태도. **다음 = validator P1~P6.**
