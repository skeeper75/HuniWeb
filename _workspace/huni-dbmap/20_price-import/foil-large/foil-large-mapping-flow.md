# 후가공_박(대형) → t_prc_* 매핑 절차 (mermaid)

> 박대형 = **2단 룩업**(박소형 동형) + **동판비 면적매트릭스**(박소형과 다름).
> 1단(면적→등급)=앱, 2단(등급×수량→총액)=DB. 동판비=좌표 직접단가(siz_cd 또는 앱).

## 1. 가격표 블록 → 그릇 분해 (flowchart)

```mermaid
flowchart LR
  subgraph 가격표["후가공_박(대형) 시트 (2단 룩업 + 동판매트릭스)"]
    B1["동판비<br/>A1~I10<br/>가로×세로 64좌표<br/>11000~64000"]
    B2a["일반박 면적→등급<br/>A14~I23 (셀=A~E·8×8)"]
    B2b["일반박 등급별 수량가<br/>K14~P28 (5등급×13수량=65)"]
    B3a["특수박 면적→등급<br/>A34~I43 (B2a와 동일)"]
    B3b["특수박 등급별 수량가<br/>K34~P48 (5등급×13수량=65)"]
  end

  subgraph 앱["앱(런타임) — DB 미저장"]
    AREA["면적→등급 룩업<br/>작업 가로×세로 → A~E<br/>off-grid=ceiling"]
    PLATEA["동판가 룩업(경로a 권장)<br/>가로×세로 → 동판가"]
  end

  subgraph 그릇["t_prc_* 4테이블 (신규 NEW)"]
    F["price_formulas<br/>PRF_FOIL_LARGE (합산형)"]
    FC["formula_components<br/>동판비 + 박가공 STD/SPC"]
    PC["price_components<br/>PLATE=.01단가(siz_cd) / PROC=.02합가(opt,min_qty)"]
    CP["component_prices<br/>194행 (동판64 siz_cd + 박가공130 opt_cd·min_qty)"]
  end

  subgraph 선결["선결 차단 (인간 승인)"]
    GC["B1 grade codes<br/>GRADE_A~E 선적재"]
    PS["A2 plate siz<br/>좌표 51개 선적재(경로b)"]
    BD["1b product binding<br/>prd_cd 미확정 BLOCKED"]
  end

  B2a -.앱 입력.-> AREA
  B3a -.앱 입력.-> AREA
  AREA -->|등급 A~E| CP

  B1 -->|경로a 앱룩업| PLATEA
  B1 -->|경로b siz_cd 좌표 64행| CP
  B2b -->|언피벗 opt_cd=등급·min_qty=수량| CP
  B3b -->|언피벗 opt_cd=등급·min_qty=수량| CP

  F --> FC --> PC --> CP
  GC -.코드 선적재.-> CP
  PS -.좌표 선적재(b).-> CP
  BD -.바인딩 컨펌.-> F
```

## 2. 엔진 계산 흐름 (sequenceDiagram) — evaluate_price

```mermaid
sequenceDiagram
  participant U as 손님 선택
  participant APP as 앱(런타임)
  participant E as evaluate_price
  participant CP as component_prices

  U->>APP: 박종(동박) + 작업 90x110mm + 수량 1000
  APP->>APP: 박종→군 결정 (동박=일반박군 STD)
  APP->>APP: 면적→등급 룩업 (A1_area_grade_map)<br/>세로90 가로110 → 등급 C
  APP->>APP: 동판가 룩업 (경로a)<br/>90x110 → 22000원 (또는 경로b: siz_cd 매칭)
  APP->>E: selections={comp=COMP_FOIL_LARGE_PROC_STD,<br/>opt_cd=GRADE_C}, qty=1000
  E->>CP: 매칭 (comp_cd, opt_cd=GRADE_C, min_qty<=1000 최대)
  CP-->>E: min_qty=1000, unit_price=120000 (총액·합가형)
  E->>E: 합가형 → 120000 ÷ 1000(min_qty) = 120원/매<br/>× 1000(주문) = 120000원
  E->>E: + 동판비 22000 (경로a 앱 / 경로b siz_cd 단가형)
  E-->>U: 박가공 합계 = 142000원
```

> [주의 1] 합가형(.02) 환산은 명함박 라이브가 .01로 등록된 것과 충돌 — prc_typ_cd 최종 확정은 P4 컨펌 후.
> [주의 2] 위 시뮬은 가격표 기지값(일반박 GRADE_C 1000매=120,000 총액·동판 90x110=22,000)을 합가형 규칙으로 검산한 것.

## 3. 무손실 round-trip

- 동판 64셀(8×8 면적매트릭스) → 64행 ✅
- 일반박 65셀(5등급×13수량) → 65행 ✅
- 특수박 65셀 → 65행 ✅
- **합계 194 = 194** ✅ (자연키 중복 0 검산 완료)
- 면적→등급 128셀(64×2 일반/특수 동일) → A1_area_grade_map_REF 64행 공통 보존(가격 그릇 외) ✅
- 동판 미등록 좌표 51개 → A2_plate_siz_proposal 51행 보존(경로b 선적재) ✅
```
