# 후가공_박(소형) → t_prc_* 매핑 절차 (mermaid)

> 박 = **2단 룩업** 구조. 1단(면적→등급)은 앱, 2단(등급×수량→총액)은 DB.

## 1. 가격표 블록 → 그릇 분해 (flowchart)

```mermaid
flowchart LR
  subgraph 가격표["후가공_박(소형) 시트 (2단 룩업)"]
    B1["동판비<br/>A1~B3<br/>80x40mm=5000 고정"]
    B2a["일반박 면적→등급<br/>A8~F12 (셀=A~E)"]
    B2b["일반박 등급별 수량가<br/>H8~M27 (5등급×18수량)"]
    B3a["특수박 면적→등급<br/>A31~F35 (B2a와 동일)"]
    B3b["특수박 등급별 수량가<br/>H31~M50 (5등급×18수량)"]
  end

  subgraph 앱["앱(런타임) — DB 미저장"]
    AREA["면적→등급 룩업<br/>작업 가로×세로 → A~E<br/>off-grid=ceiling"]
  end

  subgraph 그릇["t_prc_* 4테이블 (신규 NEW)"]
    F["price_formulas<br/>PRF_FOIL_SMALL (합산형)"]
    FC["formula_components<br/>동판셋업 + 박가공 STD/SPC"]
    PC["price_components<br/>SETUP=.01단가 / PROC=.02합가"]
    CP["component_prices<br/>181행 (opt_cd=등급·min_qty=수량)"]
  end

  subgraph 선결["선결 차단 (인간 승인)"]
    GC["B1 grade codes<br/>GRADE_A~E 선적재"]
    BD["1b product binding<br/>prd_cd 미확정 BLOCKED"]
  end

  B2a -.앱 입력.-> AREA
  B3a -.앱 입력.-> AREA
  AREA -->|등급 A~E| CP

  B1 -->|고정 단가| CP
  B2b -->|언피벗 opt_cd=등급·min_qty=수량| CP
  B3b -->|언피벗 opt_cd=등급·min_qty=수량| CP

  F --> FC --> PC --> CP
  GC -.코드 선적재.-> CP
  BD -.바인딩 컨펌.-> F
```

## 2. 엔진 계산 흐름 (sequenceDiagram) — evaluate_price

```mermaid
sequenceDiagram
  participant U as 손님 선택
  participant APP as 앱(런타임)
  participant E as evaluate_price
  participant CP as component_prices

  U->>APP: 박종(동박) + 작업 30x50mm + 수량 1000 + 박 면적
  APP->>APP: 박종→군 결정 (동박=일반박군 STD)
  APP->>APP: 면적→등급 룩업 (A1_area_grade_map)<br/>30x50 → off-grid → ceiling → 등급 D(예)
  APP->>E: selections={comp=COMP_FOIL_SMALL_PROC_STD,<br/>opt_cd=GRADE_D}, qty=1000
  E->>CP: 매칭 (comp_cd, opt_cd=GRADE_D, min_qty<=1000 최대)
  CP-->>E: min_qty=1000, unit_price=57000 (총액·합가형)
  E->>E: 합가형 → 57000 ÷ 1000(min_qty) = 57원/매<br/>× 1000(주문) = 57000원
  E->>E: + 동판셋업 5000 (고정·단가형)
  E-->>U: 박가공 합계 = 62000원
```

> [주의] 합가형(.02) 환산은 명함박 라이브가 .01로 등록된 것과 충돌 — prc_typ_cd 최종 확정은 P4 컨펌 후.
> 위 시뮬은 가격표 기지값(GRADE_D 1000매=57,000 총액)을 합가형 규칙으로 검산한 것.

## 3. 무손실 round-trip

- 동판 1셀(5000) → 1행 ✅
- 일반박 90셀(5등급×18수량) → 90행 ✅
- 특수박 90셀 → 90행 ✅
- **합계 181 = 181** ✅
- 면적→등급 28셀 → A1_area_grade_map_REF 별 시트 보존(가격 그릇 외) ✅
