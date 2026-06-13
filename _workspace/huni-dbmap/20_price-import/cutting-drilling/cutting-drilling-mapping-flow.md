# 커팅타공 → t_prc_* 매핑 절차 mermaid — round-16

> 실제 분해 결과 반영(샘플 날조 0). 노드 라벨 = 실제 comp_cd·use_dims·siz_cd.

## 1. 분해 flowchart — 가격표 블록 → 그릇 → 엔진

```mermaid
flowchart LR
  subgraph 가격표["커팅타공 시트 (3블록)"]
    B1["B1 커팅(완칼)<br/>A1:B38<br/>수량(국4절)×단면<br/>가격=수량×2000"]
    B2["B2 타공(단가)<br/>A42:C66<br/>전부 0원<br/>미사용 placeholder"]
    B3["B3 타공(합가)<br/>F42:H54<br/>1구/2구×제작수량<br/>수량구간 총액"]
    N["증분룰 A39·F53·F54<br/>+ 라벨 C1·C2·D42"]
  end

  subgraph 그릇["t_prc_* (라이브 실재·재사용)"]
    PC1["price_components<br/>COMP_CUT_FULL_DIECUT<br/>.01 단가형·use_dims=[siz_cd,min_qty]"]
    PC2["price_components<br/>COMP_CUT_PERF_1H6<br/>.01·use_dims=[min_qty]·0원"]
    PC3["price_components<br/>COMP_CUT_FULL_PERF_1H6/_2H6<br/>🔴.01→.02 교정·use_dims=[min_qty]"]
    CP["component_prices (77행)<br/>완칼36 siz=SIZ_000499<br/>타공단가23 + 타공합가18"]
  end

  subgraph 공식["디지털인쇄 합산형 공식 (배선)"]
    F["PRF_DGP_B/C/D/E/F"]
    FC["formula_components<br/>완칼 seq4·타공0원 seq5/6/10"]
  end

  B1 -->|언피벗·siz_cd=국4절·단가형| PC1 --> CP
  B2 -->|언피벗·0원 보존| PC2 --> CP
  B3 -->|언피벗·1구/2구 comp분리·합가형| PC3 --> CP
  N -.노트 보존(가격행 아님).-> NREF["N1_increment_rules_REF"]

  PC1 --> FC
  PC2 --> FC
  PC3 -.🔴 배선 0 = 가격사슬 단절.-> FC
  F --> FC --> CP
```

## 2. evaluate_price 계산 흐름 (sequence) — 완칼 + 타공 예시

```mermaid
sequenceDiagram
  participant U as 손님 선택
  participant APP as 앱(런타임)
  participant E as evaluate_price
  participant CP as component_prices

  Note over U: 모양엽서 200매 + 완칼 + 1구 타공(6mm)
  U->>APP: 작업사이즈·수량 200·후가공 선택
  APP->>E: target=PRD(라벨택)·selections·qty=200

  Note over E: 공식경로 PRF_DGP_B (합산형)
  E->>CP: 완칼 매칭 comp=COMP_CUT_FULL_DIECUT<br/>siz=SIZ_000499·min_qty≤200 최대=200
  CP-->>E: unit_price=400000 (단가형 .01)
  Note over E: 단가형: 200매=400,000원 (장당 2000×200)

  Note over E: 🔴 타공합가 COMP_CUT_FULL_PERF_1H6<br/>현재 어느 공식에도 미배선 → 조회 안 됨
  E--xCP: 타공 가격 미합산 (가격사슬 단절·컨펌-B)

  Note over E: 만약 배선+합가형(.02) 교정 시:<br/>min_qty≤200 최대=100 → 총액 2000÷100=장당20<br/>×200 = 4,000원 합산
  E-->>U: 합산가 (완칼 400,000 + 타공 ?) + 할인
```

## 3. 차원 매핑 핵심 (엔진 매칭 규칙 §2)

```mermaid
flowchart TD
  A["커팅타공 복합 요소"] --> B{"엔진 매칭 단위?"}
  B -->|국4절 출력판형| C["siz_cd = SIZ_000499<br/>(완칼만·use_dims 일치)"]
  B -->|수량/제작수량| D["min_qty (구간 매칭)"]
  B -->|1구 vs 2구| E["comp_cd 분리<br/>PERF_1H6 / _2H6<br/>(opt_cd 아님·과분할 방지)"]
  B -->|커팅 vs 타공| F["comp_cd 분리<br/>DIECUT vs PERF"]
  B -->|단면·공정·박종| G["차원 비사용 = NULL<br/>(opt_cd 0·proc_cd 0)"]
```

## 4. 그릇 권위 메모

- price_formulas 라이브 컬럼 = `frm_cd·frm_nm·note·use_yn·reg_dt·upd_dt` (frm_typ_cd·prd_cd **부존재** — 개념설계와 다름).
- component_prices 10차원 = `comp_cd·siz_cd·clr_cd·mat_cd·proc_cd·coat_side_cnt·opt_cd·bdl_qty·min_qty·apply_ymd` + unit_price.
- 커팅타공은 **proc_cd·opt_cd 둘 다 NULL**(라이브 0행 유지) — 1구/2구는 comp 분리, 완칼/타공 공정도 comp 분리로 처리.
- 🔴 **가격사슬 단절** = 타공합가 18행 적재됨 + 배선 0(아크릴 시트 동형 결함).
