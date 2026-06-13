# 출력소재(IMPORT) → 가격엔진 그릇 매핑 절차 (paper-import-mapping-flow) — round-16

> **작성** 2026-06-13 · round-16. 입력 = `paper-import-decomposition.md` + 라이브 실측. mermaid는 **실제 분해 결과 반영**(샘플 날조 금지·실제 comp_cd·use_dims 표기). **DB 미적재.**

---

## 1. flowchart — 시트 3목적 분기 → 가격 그릇(COMP_PAPER)

```mermaid
flowchart LR
  subgraph 시트["출력소재(IMPORT) 시트 (120 소재행)"]
    A["A 대분류·B 중분류"]
    C["C 종이명·D 평량·E 약어<br/>G 전지·K 종이사이즈"]
    H["I 가격(국4절)<br/>= 절가(장당가)"]
    J["J 가격(3절)"]
    F["H 연당가<br/>(전지 원가)"]
    L["L~Y 상품 적용 ●<br/>(25 상품)"]
  end

  subgraph 그릇["가격엔진 그릇 (t_*)"]
    MAT["t_mat_materials<br/>MAT_TYPE.01 용지<br/>mat_nm·weight"]
    PCMP["t_prc_price_components<br/>COMP_PAPER<br/>prc_typ_cd=01 단가형<br/>use_dims=siz_cd,mat_cd"]
    CP["t_prc_component_prices<br/>COMP_PAPER 단가행<br/>siz_cd × mat_cd → unit_price<br/>(8차원 NULL)"]
    FC["t_prc_formula_components<br/>PRF_DGP_A~F 배선<br/>(기존·신규 0)"]
  end

  subgraph 별트랙["가격 그릇 밖"]
    CPQ["CPQ 자재 제약<br/>(round-6 옵션 트랙)"]
    OTHER["실사=포스터사인 매트릭스<br/>아크릴=면적매트릭스<br/>합판=합판도무송 시트"]
  end

  C -->|"소재 정체"| MAT
  H -->|"I열 국4절 절가·siz=SIZ_000499"| CP
  J -->|"3절 절가·siz=SIZ_000077"| CP
  F -.->|"H열 연당가 DB 미저장(원가관리)"| X1["✗ 버림(note)"]
  L -.->|"용지×상품 허용"| CPQ
  A -.->|"합판/실사/아크릴=가격없음"| OTHER

  MAT -->|"FK 전제"| CP
  PCMP --> CP
  FC --> CP
```

**핵심 분기**:
- **I 가격(국4절) → COMP_PAPER 단가행**(가격 그릇의 유일한 가격 입력·연당가는 H열). siz_cd=SIZ_000499.
- **J 가격(3절) → COMP_PAPER 단가행**, siz_cd=SIZ_000077(현재 GAP).
- **F 연당가 → 버림**(전지 원가관리용·국4절 환산가가 권위).
- **L~Y ● 매트릭스 → CPQ 자재 제약**(가격 그릇 아님·별 트랙).
- **합판/실사/아크릴 → 소재 마스터만**(가격은 각 트랙).

---

## 2. flowchart — RU / GAP / BLOCKED 상태 분기 (디지털 85 종이명행)

```mermaid
flowchart TD
  P["디지털인쇄 용지<br/>(국4절가 보유) 85행"] --> CHK{"라이브 대조"}
  CHK -->|"COMP_PAPER 단가 있음"| RU["49 RU<br/>재현·재적재 금지<br/>unit_price=I열 전건 일치"]
  CHK -->|"자재 있음·단가 없음"| GAP["15 PRICE-GAP<br/>채움후보·배선불요<br/>인간 승인(아이보리 1 재분류)"]
  CHK -->|"자재 정체 미해소"| BLK["8 BLOCKED<br/>소재 정체 컨펌<br/>백색모조지1+스티커7"]
  CHK -->|"Roll 단위"| ROLL["2 SPECIAL<br/>단위 불명·컨펌"]
  P2["3절 용지 5행"] --> J3["3절 GAP<br/>SIZ_000077 단가행<br/>mat_cd 컨펌"]

  GAP -->|"가격사슬 즉시 완결"| OK["PRF_DGP_A~F 배선 기존"]
  BLK -->|"NULL/오타입 강제 금지"| HOLD["정체 컨펌 선행"]
```

---

## 3. sequenceDiagram — evaluate_price에서 용지비가 쓰이는 흐름

```mermaid
sequenceDiagram
  participant U as 손님(주문)
  participant E as evaluate_price
  participant FC as formula_components
  participant CP as component_prices
  participant APP as 앱(임포지션)

  U->>E: 프리미엄엽서·백모조120g·100매
  E->>FC: PRF_DGP_A 구성요소 조회
  FC-->>E: [인쇄비, ..., COMP_PAPER(seq15), ...]
  Note over E,CP: 용지비 매칭 (use_dims=siz_cd,mat_cd)
  E->>CP: COMP_PAPER[siz=SIZ_000499, mat=MAT_000073]
  CP-->>E: unit_price=36.88 (단가형)
  E->>APP: 출력매수 = 주문수량/판걸이수
  APP-->>E: 출력매수(예 7매)
  Note over E: 용지비 = 36.88 × 출력매수 (단가형 곱셈)
  E->>E: Σ(인쇄비+용지비+코팅+후가공)
  E-->>U: 판매가
```

> **검증 포인트**: 용지비 단가행은 **min_qty NULL**(수량구간 없음·절가 고정) → 어떤 수량이든 동일 절가 매칭. 동시매칭 0(같은 siz·mat 조합당 1행). 단가형이므로 `절가 × 출력매수`. 출력매수=앱 계산(DB 미저장).

---

## 4. 그릇 엑셀 시트 ↔ mermaid 노드 대응

| mermaid 노드 | 그릇 엑셀 시트 | 행수 |
|--------------|---------------|------|
| `t_prc_price_components COMP_PAPER` | `1_price_components_RU` | 1 (RU) |
| `t_prc_formula_components PRF_DGP_A~F` | `2_formula_components_RU` | 6 (RU·배선 정상) |
| `t_mat_materials 용지` | `3_materials_paper_RU` | 107 (RU) |
| `COMP_PAPER 단가행 RU` | `4_component_prices_RU` | 49 (RU·일치) |
| `15 PRICE-GAP` | `4b_component_prices_GAP` | 15 (채움후보·아이보리 1 재분류) |
| `3절 GAP` | `4c_component_prices_3jeol_GAP` | 5 (컨펌) |
| `8 BLOCKED` | `9_BLOCKED_material` | 8 (백색모조지1+스티커7·정체컨펌) |
| `2 Roll SPECIAL` | `9b_SPECIAL_roll` | 2 (컨펌) |

---

## 5. 한 줄 현황

매핑 절차 mermaid 완료 — flowchart 2종(시트 3목적 분기·RU/GAP/BLOCKED 상태) + sequenceDiagram(용지비가 PRF_DGP_A 합산에서 절가×출력매수로 쓰이는 흐름). 노드 라벨=실제 comp_cd(COMP_PAPER)·use_dims(siz_cd,mat_cd)·frm_cd(PRF_DGP_A~F). 가격사슬 정상(배선 기존·GAP 채우면 즉시 조회). **다음 = validator P1~P6.**
