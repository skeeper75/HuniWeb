# 아크릴 가격표 → DB 매핑 절차 (acrylic-mapping-flow) — round-16 (면적매트릭스형)

> **작성** 2026-06-13 · round-16. 아크릴 시트(면적매트릭스·복합셀)를 webadmin Phase11 가격엔진 `t_prc_*` 4테이블 그릇으로 매핑하는 **절차 시각화**. 산출물 = `acrylic-import.xlsx`(11시트·RU 121행 재현 + GAP 96 + 코롯토 21 + 카라비너 4). **DB 미적재 — 절차/그릇 준비.** mermaid는 실제 분해 결과 반영(샘플 날조 금지).

---

## 1. 전체 매핑 절차 (flowchart) — 가격표 시트 → 그릇 → 엔진

```mermaid
flowchart TB
  subgraph SRC["① 가격표 아크릴 시트 (8블록·면적매트릭스)"]
    M1["B01 투명3T 매트릭스<br/>가로14×세로14"]
    M2["B02 투명1.5T 매트릭스<br/>9×9"]
    M3["B03 미러3T 매트릭스<br/>9×9"]
    M6["B06 코롯토 매트릭스<br/>6×6 (미적재)"]
    C7["B07 카라비너 고정가<br/>4형상 (미적재)"]
    D48["B04·B08 수량구간할인<br/>(t_dsc 영역)"]
    F60["B05 후가공 옵션<br/>키링/뱃지 등 11종"]
  end

  subgraph DEC["② 분해 (엔진 매칭 규칙 기준)"]
    UNPIVOT["매트릭스 언피벗<br/>셀→(siz_cd, unit_price) long-form<br/>※면적함수 회귀 금지"]
    TYP["단가/합가 판별<br/>전건 단가형 .01 (라이브 실측)"]
    SPLIT["자재=구성요소 분기(CLEAR3T/15T/MIRROR3T)<br/>도수=NULL·수량=NULL·min_qty 무관"]
  end

  subgraph GRAIL["③ Phase11 4테이블 그릇 (acrylic-import.xlsx)"]
    F["1_price_formulas_NEW<br/>🔴사슬단절 해소(신규 5)"]
    FC["2_formula_components_NEW<br/>배선 0행→신규"]
    PC["3_price_components<br/>RU 3 + NEW 2 · prc_typ_cd .01 · use_dims=[siz_cd]"]
    CP["4_component_prices_RU<br/>121행 재현(siz_cd 좌표)"]
    GAP["4b_GAP 96 · 5_korotto 21<br/>siz 미채번/신규"]
  end

  subgraph ENG["④ webadmin evaluate_price 엔진"]
    MATCH["siz_cd 매칭<br/>(가로×세로 규격)·NULL=와일드"]
    OFFGRID["off-grid → 한단계 큰 규격<br/>(ceiling·런타임·DB미저장)"]
    CALC["단가형: 면적단가 × 주문수량"]
    DSC["수량구간할인 별단계<br/>(t_dsc·그릇 밖)"]
  end

  M1 --> UNPIVOT
  M2 --> UNPIVOT
  M3 --> UNPIVOT
  M6 --> UNPIVOT
  C7 --> TYP
  UNPIVOT --> SPLIT --> CP
  UNPIVOT --> GAP
  TYP --> PC
  F --> FC --> PC --> CP
  CP --> MATCH --> OFFGRID --> CALC --> DSC
  D48 -.제외(t_dsc).-> DSC
  F60 -.참조(CPQ·round-6).-> ENG
```

---

## 2. 엔진 계산 흐름 (sequenceDiagram) — 면적매트릭스가 어떻게 쓰이나

```mermaid
sequenceDiagram
  participant U as 고객 선택
  participant E as evaluate_price
  participant F as price_formulas
  participant C as component_prices
  participant D as t_dsc(할인)
  U->>E: 상품(아크릴키링·투명3T)+선택(가로30×세로40·수량 100)
  E->>F: 공식 조회 → PRF_ACRYL_CLEAR3T (신규·사슬완결 후)
  E->>C: 본체 단가행 매칭<br/>(comp=COMP_ACRYL_CLEAR3T, siz_cd=30x40)
  C-->>E: unit_price=3400 (PRICE_TYPE.01 단가형·엑셀 D4 일치)
  Note over E: 단가형 → 3400 × 100 = 340,000
  E->>D: 수량 100 → 구간 100~299 할인율 0.2
  D-->>E: 340,000 × (1-0.2) = 272,000
  E-->>U: 최종가 272,000원
```

off-grid 예시: 선택 25×25mm → 매트릭스 부재 → **ceiling 30×30(3100원)** 적용(런타임·DB 미저장).

---

## 3. 분해 매핑 표 (시트 블록 → 그릇 컬럼)

| 가격표 요소 | → 그릇 컬럼 | 변환 |
|------------|-----------|------|
| 매트릭스 제목 자재(투명3T/1.5T/미러) | `comp_cd`(별 구성요소) | CLEAR3T/CLEAR15T/MIRROR3T 분기(mat_cd 미사용) |
| 좌표 (가로 g, 세로 s) | `component_prices.siz_cd` | 가로×세로 규격코드(예 30x40→siz_cd) |
| 셀 단가 | `component_prices.unit_price` | numeric(개당 면적단가) |
| 제목 "양면9도/단면7도 통용" | `clr_cd=NULL` | 도수 무관(통용 단가) |
| (수량축 없음) | `min_qty=NULL` | 면적매트릭스 특성 |
| 후가공 추가단가(키링고리 등) | (컨펌 Q-ACR-1) | component 합산 vs CPQ add_price |
| 카라비너 형상(자물쇠/하트 등) | `opt_cd`(고정가) | 형상별 고정단가 |
| 수량구간할인(0~50%) | (제외·t_dsc) | round-1 영역 |

---

## 4. webadmin 복붙 사용법 (실무진용)

`acrylic-import.xlsx`는 11시트. 각 시트:
- **1행 = 빨강 안내(note)** — 시트 성격(_RU 재현 / _NEW 신규 / _GAP 미적재 / 제외·참조)
- **2행 = DB 컬럼명**(영문·파랑) — 복붙 타깃과 정확히 일치
- **3행 = 한국어 설명**(연파랑) — 복붙 시 제외
- **4행~ = 데이터** — 이 범위를 복사해 DB/적재 도구에 붙여넣기

적재 순서(FK·사슬완결): `1_price_formulas_NEW` → `2_formula_components_NEW` → `3_price_components` → `4_component_prices` → `1b_바인딩`.

**색 범례**:
- 🟩 초록(_RU) = 라이브 기존 121행 재현(**재적재 금지**·대조용)
- 🟨 노랑(_NEW) = 코롯토/카라비너/공식 신규 후보(컨펌 후 적재)
- 🟧 주황(_GAP/제외/참조) = siz 미채번·t_dsc·CPQ 영역(별 트랙)

---

## 5. 🔴 가격사슬 단절 해소 (이 시트의 결정적 발견)

```mermaid
flowchart LR
  subgraph BEFORE["라이브 현재(round-2 적재)"]
    CPa["component_prices<br/>COMP_ACRYL_* 121행 ✅"]
    FCa["formula_components<br/>배선 0행 ❌"]
    Fa["price_formulas<br/>아크릴 공식 0개 ❌"]
    CPa -.단절.- FCa
  end
  subgraph AFTER["round-16 그릇(사슬 완결)"]
    Fb["price_formulas<br/>PRF_ACRYL_* 5 신규"]
    FCb["formula_components<br/>배선 5 신규"]
    PCb["price_components RU"]
    CPb["component_prices RU(보존)"]
    Fb-->FCb-->PCb-->CPb
  end
  BEFORE ==>|"공식+배선+바인딩 신규"| AFTER
```

> 라이브는 아크릴 단가행만 있고 **공식·배선이 없어 엔진이 가격을 조회할 수 없는 상태**(가격사슬 단절·메모리 [[dbmap-price-chain-dwire-per-product-formula]]). round-16 그릇이 공식 정의/배선/상품바인딩을 신규 제안해 사슬을 완결한다. **단가행은 재현만(재적재 금지)**.

---

## 6. 한 줄 현황

아크릴 매핑 절차 mermaid(flowchart 시트→분해→그릇→엔진 + sequence 면적매트릭스 계산흐름 + 가격사슬 단절 해소 diagram) + 분해 매핑 표 + 복붙 사용법 완료. 그릇 `acrylic-import.xlsx` 11시트(RU 121·GAP 96·코롯토 21·카라비너 4). **다음 = validator P1~P6 독립검증.**
