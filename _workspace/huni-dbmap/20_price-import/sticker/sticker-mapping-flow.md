# 스티커 가격표 → DB 매핑 절차 (sticker-mapping-flow) — round-16 파일럿

> **작성** 2026-06-13 · round-16. 가격표 스티커 시트(다차원)를 webadmin Phase11 가격엔진 `t_prc_*` 4테이블 그릇으로 매핑하는 **절차 시각화**. 산출물 = `sticker-import.xlsx`(716 단가행). **DB 미적재 — 절차/그릇 준비.**

---

## 1. 전체 매핑 절차 (flowchart) — 가격표 시트 → 그릇 → 엔진

```mermaid
flowchart TB
  subgraph SRC["① 가격표 스티커 시트 (다차원·복합셀)"]
    B01["B01 반칼/규격<br/>3D: 수량×사이즈6×소재3"]
    B0204["B02~B04 낱장/대형<br/>2D: 수량×사이즈"]
    B05["B05 타투<br/>3장마다 4000"]
    B06["B06 스티커팩<br/>54장 1세트 4000"]
  end

  subgraph DEC["② 분해 (엔진 매칭 규칙 기준)"]
    UNPIVOT["매트릭스 언피벗<br/>셀→(siz,mat,min_qty) long-form"]
    SPLIT["복합셀 분리<br/>판수→앱계산 / 소재묶음→mat_cd / 코팅→proc_cd(컨펌)"]
    TYP["단가/합가 판별<br/>B01~04=단가형.01 / B05·06=합가형.02"]
  end

  subgraph GRAIL["③ Phase11 4테이블 그릇 (sticker-import.xlsx)"]
    F["1_price_formulas<br/>PRF_STK_FIXED/TATTOO/PACK"]
    FC["2_formula_components<br/>공식→구성요소 배선"]
    PC["3_price_components<br/>prc_typ_cd · use_dims"]
    CP["4_component_prices<br/>716행·10차원"]
  end

  subgraph ENG["④ webadmin evaluate_price 엔진"]
    MATCH["선택값↔차원 매칭<br/>NULL=와일드카드"]
    CALC["단가형: 단가×수량<br/>합가형: 총액÷min_qty×수량"]
    SUM["구성요소 합산 → 최종가"]
  end

  B01 --> UNPIVOT
  B0204 --> UNPIVOT
  B05 --> TYP
  B06 --> TYP
  UNPIVOT --> SPLIT --> CP
  TYP --> PC
  F --> FC --> PC --> CP
  CP --> MATCH --> CALC --> SUM
```

---

## 2. 엔진 계산 흐름 (sequenceDiagram) — 그릇이 어떻게 쓰이나

```mermaid
sequenceDiagram
  participant U as 고객 선택
  participant E as evaluate_price
  participant F as price_formulas
  participant C as component_prices
  U->>E: 상품(PRD_000058)+선택(siz=A4·mat=유포·수량 100)
  E->>F: 공식 조회 → PRF_STK_FIXED (.02 단순형)
  E->>C: 구성요소 단가행 매칭<br/>(comp=STK_PRINT, siz=A4, mat=유포, min_qty≤100 최대)
  C-->>E: unit_price=3600 (PRICE_TYPE.01 단가형)
  Note over E: 단가형 → 3600 × 100 = 360,000
  E-->>U: 최종가 360,000원 (+ 수량할인 단계)
```

타투(합가형) 예시: 선택 수량 9 → `min_qty=3·unit=4000·PRICE_TYPE.02` → `4000÷3=1333/장 × 9 = 12,000원`.

---

## 3. 분해 매핑 표 (시트 블록 → 그릇 컬럼)

| 가격표 요소 | → 그릇 컬럼 | 변환 |
|------------|-----------|------|
| A열 수량 | `component_prices.min_qty` | 정수·상향구간 |
| 행2 사이즈(병합) | `component_prices.siz_cd` | 규격코드(임포지션 키) |
| 행3 소재그룹 | `component_prices.mat_cd` | 대표 소재코드(코팅=proc_cd 전환 컨펌) |
| 셀 단가 | `component_prices.unit_price` | numeric |
| T3 "종이+인쇄+커팅" | `formula_components`(comp 1개) | 단순형 통합단가 |
| "3장마다 4000"(타투) | `prc_typ_cd=.02` + `bdl_qty=3` | 합가형 환산 |
| 판수(4판 등) | (DB 미저장) | 앱 임포지션 계산 |

---

## 4. webadmin 복붙 사용법 (실무진용)

`sticker-import.xlsx`는 4시트 = webadmin/DB 4테이블과 1:1. 각 시트:
- **1행 = DB 컬럼명**(영문) — 복붙 타깃과 정확히 일치
- **2행 = 한국어 설명**(회색) — 복붙 시 제외
- **3행~ = 데이터** — 이 범위를 복사해 DB/적재 도구에 붙여넣기

적재 순서(FK): `1_price_formulas` → `2_formula_components` → `3_price_components` → `4_component_prices`. `[참고]` 열(siz_label·mat_label)은 사람 확인용(DB 적재 시 제외).

---

## 5. 한 줄 현황

스티커 매핑 절차 mermaid(flowchart 시트→분해→그릇→엔진 + sequence 계산흐름) + 분해 매핑 표 + 복붙 사용법 완료. 그릇 `sticker-import.xlsx` 716행. **다음 = validator P1~P6 독립검증.**
