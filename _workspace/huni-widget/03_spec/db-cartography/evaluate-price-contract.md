# evaluate-price-contract.md — 위젯 가격요청 → evaluate_price → breakdown 매핑

> 파이프라인 ③' 컨버전 선행. 가격 **서버 권위 [HARD]**: 위젯은 단가/공식 없음. `pricing.py:evaluate_price`(:394) /
> `evaluate_set_price`(:844) 불투명 결과만. **t_prc_* 공식 위젯 포팅 금지.** PRICE=0 = 결함 신호([[huni-widget-red-price-never-zero]]).
> 골든은 라이브 webadmin 시뮬레이터(읽기전용 POST `/admin/price-viewer/{prd_cd}/simulate/`)로 실측(2026-07-01).

## 1. 경로

```
위젯 선택 상태 (정규화 계약)
  NormalizedPriceRequest {
    productCode, priceSchemeKey(echo), itemGroup(echo), customerTier?,
    dimensions[{side,cutW,cutH,workW,workH}], colorCounts{side:n}, materials{side:matId},
    quantity, printCount?, pageCount?, addColor?, addColorCapable?, colorSide?,
    selectedFinishes[{groupId,valueId,attb?}]
  }
        │ 어댑터 createHuniAdapter — option_items.ref_dim 환원 + priceSchemeKey echo
        ▼
  evaluate_price(target={prd_cd}, selections={siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, ...},
                 qty, grade_cd, mode="lenient")          [pricing.py:394]
    └ 셋트: evaluate_set_price(set_prd_cd, members, set_selections, copies)   [:844]
        │ 내부: 상품 공식(frm_cd) → formula_components → component_prices 다차원 단가 매칭
        │       + 판형 판수환산(fn_calc_pansu) + 수량구간 할인(t_dsc_*)   ← 전부 서버 내부
        ▼
  결과 dict { ok, final_price, base{source,components[{comp_cd,subtotal,included}]}, discounts, warnings, errors }
        │ 어댑터 정규화
        ▼
  NormalizedPriceBreakdown { ok, finalPrice, vat, shipping, lines[{code,label,amount}], priceUnavailableReason? }
```

## 2. 선택값 키 매핑 (위젯 → evaluate_price selections)

| 위젯 계약 | evaluate_price selections 키 | 환원 경로 |
|-----------|------------------------------|-----------|
| `dimensions[side]` (규격 선택) | `siz_cd` | 규격 OptionValue.id 직접 |
| (어댑터 자동) | `plt_siz_cd` | product_plate_sizes.dflt_plt_yn='Y' 또는 종이류 환산. 위젯 비노출 |
| `colorCounts` / 도수 선택 | `print_opt_cd` | 도수 OptionValue.id (clr는 priceColorCount 평면화) |
| `materials[side]` | `mat_cd` | 용지 OptionValue.id |
| `selectedFinishes[]` | `proc_cd` / procs[] | 후가공 valueId. **필수공정(mand_proc_yn=Y)은 어댑터가 자동 주입** |
| `quantity` | `qty` (별도 인자) | snap to qty_incr |
| `pageCount` | `page_*` | 책자 |
| `customerTier` | `grade_cd` | 등급 (미지정=기준가) |

## 3. PRICE≠0 골든 — PRD_000041 스탠다드 쿠폰/상품권 (디지털인쇄 파일럿)

frm_cd=`PRF_DGP_A`(디지털인쇄 원자합산형A). 라이브 시뮬레이터 실측(2026-07-01·읽기전용):

| 케이스 | selections | qty | final_price | 비고 |
|--------|-----------|-----|-------------|------|
| A 기본 | 단면(POPT_000001)+백색모조지100g(MAT_000072)+148x68(SIZ_000013) | 120 | **307** | COMP_PAPER 307.30 |
| A 중간 | 〃 | 1008 | **2,581** | COMP_PAPER 2581.32 |
| A 대량 | 〃 | 5004 | **12,814** | COMP_PAPER 12814.41 |
| B 양면+오시 | 양면(POPT_000002)+아트지150g(MAT_000078)+오시(PROC_000029) | 120 | **467** | COMP_PAPER 466.50 |

✅ **PRICE≠0 게이트 통과** (전 케이스 > 0). 재사용 교차: §29 scoreboard-summary `PRD_000041 calc_status=OK priced=2/2 PR_engine=10177`.

### ⚠ 알려진 (C) 결함 — 위젯에서 발현
`COMP_PRINT_DIGITAL_S1`(디지털인쇄비)·`COMP_PRINT_SPOT_WHITE_S1`(별색)이 **subtotal=0**으로 나온다. 원인=디지털인쇄 base 공정 `PROC_000004`가 product_processes에 mand_proc_yn='Y'로 있으나 단가행/배선 미충전 → 인쇄비 영구 0([[digital-print-base-proc-missing-260701]] §26). 채점 배치는 코드 주입으로 갭 은닉했으나 **위젯은 어댑터가 필수공정 자동선택 시 그대로 발현**. 현재 final_price는 용지비만으로 PRICE≠0이라 게이트는 통과하나, 인쇄비 0은 저청구. **교정=§7/§26 인간 승인 트랙**(위젯/계약 무관, 어댑터는 필수공정 정상 주입만).

## 4. NormalizedPriceBreakdown 매핑

| 계약 필드 | evaluate_price 결과 | 변환 |
|-----------|---------------------|------|
| `ok` | `ok` | 직접 |
| `finalPrice` | `final_price` | 직접 (부가세 별산 전) |
| `vat` | (어댑터/BFF 산정) | final_price × 0.1 등 — 서버/BFF 영역 |
| `shipping` | (어댑터/BFF) | 배송정책 — 위젯 스코프 밖 |
| `lines[]` | `base.components[{comp_cd,subtotal}]` (included만) | comp_cd→한글 label, subtotal→amount |
| `priceUnavailableReason` | `warnings`/`errors` (final_price=0 시) | 어댑터가 진단 사유 채움(침묵 금지) |

## 5. 서버 권위 경계 [HARD]

- 위젯/계약/어댑터는 `t_prc_price_formulas`·`t_prc_formula_components`·`t_prc_price_components`·`t_prc_component_prices`·`t_dsc_*`의 **어떤 값도 보유/계산하지 않는다**. 공식·단가·차원매칭·판수환산·할인은 전부 evaluate_price 내부.
- 어댑터 책임 = (a) 위젯 선택→selections 차원 환원(option_items.ref_dim) (b) 필수공정 자동주입 (c) `final_price`/components→breakdown 정규화 (d) PRICE=0 시 진단 사유.
- PRICE=0은 정상 빈상태 아님 — 어댑터가 `priceUnavailableReason` 채워 위젯 표시(가격 계산은 안 함).
