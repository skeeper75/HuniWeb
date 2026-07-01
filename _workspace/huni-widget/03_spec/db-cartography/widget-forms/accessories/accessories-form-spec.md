# accessories-form-spec.md — 악세사리(C1·고정가-단순) 위젯 폼 주문가능 종단 명세

> 파이프라인 ③' 컨버전 선행 · 명세까지(코드 0줄·다음 승인).
> **외형·제약 의도 권위** = `docs/design/11가지상품옵션/product-accessories-option/Configurator.jsx`(76줄·2필드 — 사이즈·수량).
> **데이터 권위** = 라이브 DB 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + readiness/conformance 산출 재사용.
> **가격 권위** = 서버 `pricing.py:evaluate_price`(:394) 불투명 결과. t_prc_* 위젯 포팅 금지. PRICE=0=결함.
> **계약 목표** = 위젯 가시 계약 변경 0 — 매핑은 어댑터(`createHuniAdapter`)가 흡수.
> 대표 상품 = **PRD_000055 낱장 자유형 스티커** (W-FIX·§29 L3·95.5%·frm=PRF_STK_FIXED·calc=OK·pfm=BOUND_OK·구성요소 가장 완비된 고정가-단순).
> 상위 분석 = `../../widget-forms-approach.md`(11폼·제약6종·주문가능4조건) · 선례 = `../digital-print/print-form-spec.md`(동일 6부 구조).

---

## 0. 대표 상품 선정 근거 (C1 = 고정가-단순)

악세사리 design JSX는 **최단 폼(2필드)** — 사이즈(OptionButton·패크입수 "50입")·수량(QuantityStepper)뿐, 후가공·박·별색·면별 분해 일절 없음. 조건부 제약 0(`widget-forms-approach.md §2 — accessories=C1 제약 0`). 가격모델 = **고정가 by siz_cd**(사이즈·수량별 단가표 lookup, 공식·차원매칭 없는 가장 단순한 형태).

라이브 악세사리/스티커 상품군에서 이 형상(고정가 by siz·옵션 사실상 size+qty·제약 0)을 가지면서 **데이터가 가장 완비된** 상품 = **PRD_000055 낱장 자유형 스티커**:
- §29 readiness: 완성률 **95.5%**·등급 **L3**·위젯클래스 **W-FIX**·`calc=OK; frm=PRF_STK_FIXED; OC=60; pfm=BOUND_OK`.
- 가격모델 = `COMP_STK_PRINT` 단일 component(`use_dims=[siz_cd, mat_cd, min_qty]`·PRICE_TYPE.01 단가형·단가행 2,838) = **고정가 by (사이즈×자재×수량밴드)** lookup → 정확히 C1 모델.
- 제약 `t_prd_product_constraints` **0행** = design 의도(제약 0)와 일치.
- 옵션그룹 3개(종이·인쇄·커팅)는 존재하나 **각 1항목뿐**(유포지·단면·완칼) = 손님 실선택은 size+qty뿐 → C1 형상 보존(§1 참고).

> §29 "상품악세사리" 카탈로그 그룹(PRD_000001/002 OPP봉투)은 **W-ADDON(부속·기성 고정가)** 로 design 악세사리 폼(인쇄 패크상품)과 형상이 다름. design 악세사리 폼(사이즈 패크+수량+장바구니)은 **W-FIX 고정가-단순**에 해당하므로 대표를 W-FIX 최상위 PRD_000055로 잡는다. (부록 동형 전파에서 W-ADDON 부속과의 경계 명시.)

**라이브 실측 PRD_000055 구성(스냅샷):**
```
prd_typ=PRD_TYPE.01(완제품)·semi_role=∅·nonspec_yn=N·file_upload_yn=Y·editor_yn=N
min_qty=1·max_qty=10000·qty_incr=1·dflt_qty=∅·qty_unit=QTY_UNIT.02(매)
sizes(5): SIZ_000172 A4(210x297·dflt Y) / SIZ_000174 A3(297x420·dflt Y) / SIZ_000197 A2(420x594·dflt Y)
          / SIZ_000515 B4(257x364·dflt N) / SIZ_000514 B3(364x515·dflt N)   (★dflt_yn=Y 3건 충돌·§3 ⑥)
option_groups(3·전부 택1필수·각 1항목): OPT_000013 종이(유포지 OPV_000029→MAT_000153) /
          OPT_000014 인쇄(단면 OPV_000030→print_opt_id=1) / OPT_000015 커팅(완칼 OPV_000031→PROC_000053)
constraints: 0행 · addons: 0행 · processes: 완칼(PROC_000053) · plate_sizes: (종이류·환산 어댑터)
price_formulas: PRF_STK_FIXED(apply_bgn 2026-06-01·활성) → component COMP_STK_PRINT(use_dims=[siz_cd,mat_cd,min_qty]·PRICE_TYPE.01)
```

---

## 1. 폼 필드 인벤토리 → 정규화 계약 매핑 (2 필드 전수 + 어댑터 생성)

각 OptionField → `OptionGroup`(또는 InputSpec). componentType=DESIGN.md 14종 사상. side는 악세사리 전부 `default`(단일면·내지 없음).

| # | JSX 필드(state) | 디자인 컴포넌트 | 정규화 componentType | side | required | visible | values 출처(라이브 PRD_000055) | InputSpec |
|---|----------------|----------------|----------------------|------|:--:|:--:|--------------------|-----------|
| 1 | 사이즈 size | OptionButtonGroup(2열·"입수" 라벨) | `option-button` | default | Y | Y | product_sizes ⋈ siz_sizes (A4/A3/A2 + B4/B3) | — |
| 2 | 수량 qty | QuantityStepper(min10·step10·max2000) | `counter-input` | default | Y | Y | products.{min,max,qty_incr,dflt}_qty | min1·max10000·step1 (★디자인≠DB) |
| — | (어댑터 생성) 종이 | (디자인 미노출) | `select-box`(1항목→사실상 고정) | default | Y | Y/N | OPT_000013 유포지(OPV_000029→MAT_000153) | — |
| — | (어댑터 생성) 인쇄 | (디자인 미노출) | `option-button`(1항목→고정) | default | Y | Y/N | OPT_000014 단면(OPV_000030→print_opt) | — |
| — | (어댑터 생성) 커팅 | (디자인 미노출) | `finish-button`(1항목→고정) | default | Y | Y/N | OPT_000015 완칼(OPV_000031→PROC_000053) | — |
| — | (어댑터 생성) 판형 | (없음·hidden) | (비노출·차원환산) | default | — | N | plate_sizes 종이류 환산(A4) — 위젯 비노출 | — |
| — | (어댑터 생성) 요약 | PriceSummary(합계금액) | `summary` | — | — | — | evaluate_price breakdown | — |
| — | (어댑터 생성) 업로드 | (디자인 미노출·장바구니만) | `upload-cta` | default | Y | Y | file_upload_yn=Y → PDF 업로드 | — |

**계약/DB 매핑 요약(2 노출 필드):**
- **완전 매핑(라이브 데이터 채움 가능)**: 2 — 사이즈(1)·수량(2). + 어댑터생성 종이/인쇄/커팅(각 1항목)·요약·업로드.
- **부분/불일치**: 사이즈·수량 값이 디자인 하드코딩≠라이브(§2) → **위젯은 라이브값 권위 렌더**(어댑터 흡수·A).
- **미매핑(DB·CPQ 부재)**: 0 — 악세사리 폼은 부가옵션이 없어 print(18건 미매핑)와 달리 **DB 부재 갭 없음**.

**★C1 핵심 관찰 — 디자인 0 옵션그룹 vs 라이브 3 옵션그룹:** 디자인 폼은 size+qty만 노출(옵션그룹 0)하나, 라이브 PRD_000055는 종이/인쇄/커팅 3 CPQ 그룹을 보유한다. 단 **각 그룹이 정확히 1항목**(유포지·단면·완칼)이라 손님 선택지가 없다 → 기능적으로 고정. 어댑터 처리 2안:
- **(A·권장)** 1항목 택1필수 그룹은 어댑터가 **자동선택(default valueId 고정)** 후 `visible=false`로 숨김(hidden-essential 관례, print A4 disp_seq<0와 동형). 디자인 외형(2필드)과 정합 + 가격 차원(mat_cd/print_opt/proc_cd) 정상 운반.
- (B) 그대로 노출 — 디자인 외형 위배(불필요 1항목 select 노출). 비권장.

→ **계약 변경 0**(어댑터가 1항목 그룹을 흡수). C1은 "옵션 사실상 size+qty" 가 어댑터 자동선택으로 성립.

---

## 2. 옵션 데이터 → 라이브 DB 바인딩 (디자인 값 ↔ 라이브 값 대조)

| 옵션 | 디자인 하드코딩 값 | 라이브 출처(PRD_000055) | 일치/불일치 |
|------|-------------------|------------------------|-------------|
| 사이즈 | 2종(70x200mm 50입 · 80x100mm 50입) | 5종(A4 210x297 / A3 297x420 / A2 420x594 / B4 257x364 / B3 364x515) | ❌ **불일치** — 디자인은 소형 패크 프리셋(악세사리 일반 예시), DB는 A/B 규격 시트. 위젯은 DB값(5종) 렌더. (A 어댑터) |
| 수량 | min10/step10/max2000 | min1/incr1/max10000 | ❌ **불일치** — 위젯은 DB값(1 단위) 권위. (A 어댑터·DB 권위) |
| 종이(자재) | (디자인 미노출) | 유포지 1종(MAT_000153·USAGE.07) | △ 라이브 단일 — 어댑터 자동선택(A) |
| 인쇄(도수) | (디자인 미노출) | 단면 1종(print_opt_id=1) | △ 라이브 단일 — 어댑터 자동선택(A) |
| 커팅(공정) | (디자인 미노출) | 완칼 1종(PROC_000053) | △ 라이브 단일 — 어댑터 자동선택(A) |

**자재오염 점검(돈크리티컬·print에서 (C) 발현분):** PRD_000055 OPT_000013 종이 = `OPV_000029 유포지 → ref_key1 MAT_000153`. `t_mat_materials` 실측상 MAT_000153 = 유포지(스티커 정상 자재·USAGE.07). **print PRD_000042 같은 종이↔굿즈자재 오염(MAT_000128 면끈 등) 없음** — 악세사리 대표는 자재 정합 클린(돈크리티컬 갭 0). 단가행도 COMP_STK_PRINT가 MAT_000153 직접 참조(§4 단가행 검증).

> 디자인 사이즈/수량 ≠ 라이브 — 가격·계약과 무관한 **외형 프리셋 차이**(디자인은 악세사리 일반 예시값). 위젯은 항상 라이브 권위 렌더 → 교정 불필요(C 아님·A 흡수).

---

## 3. 제약 추출·정규화 (★C1은 제약 0 예상 — 디자인↔DB 대조 확인)

악세사리 design JSX는 **조건부 제약 0**(`widget-forms-approach.md §2 accessories 제약=0`). 라이브 `t_prd_product_constraints`도 **PRD_000055 0행**. 따라서 6종 중 차별적 제약(③토글·④범위·⑤택1·①visible·②disable)은 **디자인·DB 양측 모두 부재** = 일치. 남는 것은 ⑥필수·④size·②quantity·⑥base = 직접 데이터로 충족(A).

### 3.1 제약 추출표

| 제약형태 | 트리거 | 악세사리 실례 | 정규화 매핑 | DB 출처(존재여부) | 갭 |
|--------------|--------|------|-------------|-------------------|-----|
| ① visible cascade | (디자인 명시 없음) | — | `visibilityRules[]` | constraints 0행 | **일치(둘 다 없음·A 빈배열)** |
| ② disable | (디자인 명시 없음) | — | `disableRules[]` | constraints 0행·excl_groups 부재 | **일치(둘 다 없음·A 빈배열)** |
| ③ 토글→하위 visible | (없음) | — | — | 박/형압 토글 없음 | **일치(없음)** |
| ④ 범위검증 area | (없음·custom 미노출) | — | — | nonspec_yn=N(비규격 불가)·디자인도 custom 없음 | **일치(없음)** |
| ⑤ 택1 패턴 | 사이즈 size | A4/A3/A2/B4/B3 택1 | `OptionGroup(multiple=false)` | sizes(dflt_yn 일부) | **(A)** 규격 택1 직매핑 |
| ⑤ 택1(어댑터) | 종이·인쇄·커팅(각1) | 유포지·단면·완칼 | `OptionGroup(sel_typ=SEL_TYPE.01·min1/max1)` 자동선택 | OPT_000013/14/15 mand_yn=Y | **(A)** 1항목→default 고정 |
| ⑥ 필수 required | 주문 전 필수 | 사이즈·수량(+자동 종이/인쇄/커팅) | `OptionGroup.required=true` | sizes 항상필수·qty 항상·OPT mand_yn=Y | **(A)** mand_yn→required 직매핑 |
| ⑥ hidden-essential | (디자인 비노출) | 종이/인쇄/커팅 1항목 | `OptionGroup.{required:true,visible:false}` 자동주입 | OPT 3그룹 각 1항목 | **(A)** 1항목→자동선택+숨김(§1) |
| ② quantity clamp | 수량 | min/max/incr | `QuantityRule{min1,first1,increment1}` | products.{min1,max10000,qty_incr1} | **(A)** 직매핑(★디자인 min10/step10≠DB1 — DB 권위) |
| ④ size | 사이즈 선택 | cut/work 치수 | `SizeRule[]` | siz_sizes.{cut,work}_{w,h} 1:1 (A4 210x297…) | **(A)** 직매핑 |
| ⑥ base | — | 단위·재단마진·비규격불가 | `BaseRule{unit:매,cutMargin:0,nonStandardAllowed:false}` | siz_sizes margin(빈값)·nonspec_yn=N | **(A)** 직매핑 |

### 3.2 제약 6종 디자인↔DB 일치/갭 집계

| 제약축 | 디자인 의도 룰 수 | 라이브 데이터 충족 | 갭 |
|--------|:---:|:---:|-----|
| ① visible cascade | 0 | 0(constraints 0행) | 일치(둘 다 없음) |
| ② disable | 0 | 0(제약/excl 부재) | 일치 |
| ③ 토글→하위 | 0 | 0 | 일치(없음) |
| ④ 범위검증(area) | 0(custom 없음) | 0(nonspec=N) | 일치 |
| ⑤ 택1(사이즈+어댑터3) | 1(사이즈) | 4(사이즈+종이/인쇄/커팅) | **일치(A 직매핑·1항목 자동선택)** |
| ⑥ 필수(사이즈·수량+hidden 3) | 2 | 5(mand_yn·qty·sizes) | **일치(A 직매핑)** |
| **합계** | **3** | **9 충족** | **일치 — 갭 (C) 0건** |

**제약 결론:** **C1 제약 0 예상 확인.** 악세사리 폼은 ⑥필수·④size·②quantity·⑥base만 가지며 전부 라이브 데이터로 완전 강제(A 어댑터 흡수). print의 차별적 제약(박/별색/코팅 11건 (C))이 **악세사리엔 전무** → (C) 0건. 위젯 계약(QuantityRule·SizeRule·BaseRule·OptionGroup.required) 슬롯으로 100% 표현 → **계약 변경 0(B 0건)**.

---

## 4. 가격 결선 (evaluate_price 골든) — 디자인 가짜식 폐기

### 4.1 디자인 가짜 계산식 (폐기 대상)

accessories JSX(:8)는 **하드코딩 상수**:
```
subtotal = 75000, vat = 7500, total = 82500   // 사이즈·수량 무관 고정 더미값
```
→ **폐기.** 사이즈·수량 선택이 가격에 전혀 반영 안 됨(완전 더미). 실 가격은 evaluate_price 권위(고정가 by siz·자재·수량밴드).

### 4.2 위젯 경로 (정규화 계약)

```
NormalizedPriceRequest { productCode:PRD_000055, priceSchemeKey:PRF_STK_FIXED(echo),
  dimensions:[{side:default, cutW,cutH}], materials{default:MAT_000153(어댑터 자동)},
  colorCounts{default}(단면·어댑터 자동), quantity, selectedFinishes:[{완칼 PROC_000053 자동}] }
   │ 어댑터 createHuniAdapter — 1항목 그룹(종이/인쇄/커팅) 자동선택 + 판형 종이류 환산 + priceSchemeKey echo
   ▼
evaluate_price({prd_cd:PRD_000055}, {siz_cd, mat_cd=MAT_000153, print_opt_cd, proc_cd=PROC_000053}, qty)  [pricing.py:394]
   │ 내부: PRF_STK_FIXED → COMP_STK_PRINT 단가행 [siz_cd × mat_cd × min_qty밴드] 매칭
   │       PRICE_TYPE.01 단가형 → unit_price × qty (pricing.py:17·211)
   ▼
NormalizedPriceBreakdown { ok, finalPrice, vat, shipping, lines:[{COMP_STK_PRINT, 스티커 완제품가}] }
```
악세사리는 후가공·박·면별 분기 없음 → 어댑터는 size→siz_cd + 1항목 그룹 자동선택만. 가장 단순한 단일 component 경로.

### 4.3 PRICE≠0 골든

`COMP_STK_PRINT` 단가행(라이브 스냅샷 verbatim·`use_dims=[siz_cd, mat_cd, min_qty]`·MAT_000153 유포지·PRICE_TYPE.01 단가형 = unit_price × qty):

| 케이스 | siz_cd | mat_cd | qty(밴드) | unit_price(라이브 verbatim) | final = unit_price×qty | 출처 row |
|--------|--------|--------|-----------|------------------------------|------------------------|----------|
| A4·소량 | SIZ_000172 A4 | MAT_000153 유포지 | 1 (밴드 1) | **4,000.00** | 4,000 | comp_price 2888 |
| A4·중량 | SIZ_000172 A4 | MAT_000153 | 50 (밴드 50) | **3,800.00** | 190,000 | comp_price 2898 |
| A3·소량 | SIZ_000174 A3 | MAT_000153 | 1 (밴드 1) | **8,000.00** | 8,000 | comp_price 2890 |
| A2·소량 | SIZ_000197 A2 | MAT_000153 | 1 (밴드 1) | **16,000.00** | 16,000 | comp_price 2892 |
| A4·20입 | SIZ_000172 A4 | MAT_000153 | 20 (밴드 20) | **3,880.00** | 77,600 | comp_price 2893 |

> 단가행 unit_price는 라이브 스냅샷 verbatim(날조 0). `final = unit_price × qty`는 pricing.py:17/211(단가형) 적용 계산값 — **정확 final_price는 서버 evaluate_price/시뮬레이터가 권위**(수량구간 할인 t_dsc_* 추가 적용 가능). 본 명세는 §29 `PRD_000055 calc=OK·pfm=BOUND_OK·priced` 재사용 + 단가행 verbatim을 권위로 하고, 인증세션 시뮬레이터 직호출은 hw-qa 검증단계로 이관(거짓 final 수치 날조 금지).

✅ **PRICE≠0 게이트 통과** — 전 케이스 unit_price > 0 (4,000~16,000), 단가행 적재 완전. **PRD_000055 대표 PRICE 값 = 단가 4,000~16,000(사이즈별)·qty 적용 final ≥ 4,000.**

### 4.4 디자인 가짜식 vs 실 evaluate_price 차이 + 저청구 점검

- **차이**: 가짜식은 완전 더미 고정(82,500·선택 무관). 실 evaluate_price는 사이즈(A4<A3<A2)·자재·수량밴드별 단가행 lookup. → 가짜식 폐기 정당.
- **저청구 결함 점검**: print 대표의 §26 인쇄비0(PROC_000004 base 미충전) 같은 **저청구 결함이 PRD_000055엔 없음** — COMP_STK_PRINT가 **완제품가(출력+가공 포함)** 단일 component라 base 공정 분리 배선 의존 없음(note "스티커 완제품가(출력+가공 포함)"). 단일 lookup이라 silent 0 위험 없음. 완칼 공정(PROC_000053)은 완제품가에 흡수 → 별도 단가행 누락 무관. **저청구 (C) 0건.**

---

## 5. 주문 페이로드 예시 (NormalizedCartHandoff + CTA 분기)

PRD_000055: file_upload_yn=Y·editor_yn=N → CTA는 **PDF 업로드 단독**(에디터 없음). 디자인 폼은 업로드/에디터 버튼 없이 "장바구니 담기"만 노출 → 어댑터가 file_upload_yn=Y로 PDF 업로드 CTA 부착(디자인 단순화·DB 권위 정합).

**완성 선택 상태(예):** A4 · (유포지·단면·완칼 자동) · qty 50
```jsonc
// NormalizedCartHandoff
{
  "productCode": "PRD_000055",
  "selectedOptions": [
    { "groupId": "size",        "valueId": "SIZ_000172" },   // A4
    { "groupId": "OPT_000013",  "valueId": "OPV_000029" },   // 종이 유포지(어댑터 자동·hidden)
    { "groupId": "OPT_000014",  "valueId": "OPV_000030" },   // 인쇄 단면(어댑터 자동·hidden)
    { "groupId": "OPT_000015",  "valueId": "OPV_000031" }    // 커팅 완칼(어댑터 자동·hidden)
  ],
  "quantity": 50,
  "priceSnapshot": { "finalPrice": 190000, "vat": 19000, "shipping": 0 },   // 단가 3800×50 — 서버 final 권위
  "artifacts": [
    { "side": "default", "kind": "pdf",
      "storedFileName": "stored_xxxx.pdf", "originalFileName": "sticker.pdf" }
  ]
}
// CTA 분기: editors={koi:false,rp:false,pdf:true} → cta.pdfUpload=true·designEditor=false
```
- **에디터/PDF 분기**: editor_yn=N → designEditor=false. file_upload_yn=Y → pdfUpload=true → `NormalizedArtifact{kind:'pdf'}`.
- **어댑터 자동선택**: 1항목 그룹(종이/인쇄/커팅)은 페이로드에 default valueId로 포함(가격 차원 운반)되나 위젯 UI엔 비노출(hidden-essential).
- **커머스 바인딩**: `priceSnapshot.vat`/`shipping` 산정·NormalizedPresigned(업로드 URL)·실 카트 전송은 **§24 Shopby UNDECIDED 경계**. 위젯은 NormalizedCartHandoff까지 조립 후 BFF 위임.

---

## 6. componentType / 갭 노트

### 6.1 componentType 사상 (악세사리 폼)
| componentType | 악세사리 폼 사용처 | 데이터 출처 |
|---------------|----------------|-------------|
| `option-button` | 사이즈(·인쇄 1항목 자동) | product_sizes ⋈ siz_sizes |
| `counter-input` | 수량 | products qty(min1/incr1/max10000) |
| `select-box` | (종이 1항목·어댑터 자동·hidden) | option_items OPT_000013 |
| `finish-button` | (커팅 완칼 1항목·어댑터 자동·hidden) | option_items OPT_000015 |
| `summary` | 합계금액 | 어댑터 생성(evaluate_price) |
| `upload-cta` | PDF 업로드 | file_upload_yn=Y |
| `area-input`/`color-chip`/`finish-select-box`/`price-slider`/`image-chip`/`page-counter-input`/`dimension-matrix-input` | **미사용(악세사리)** | — |

> 악세사리는 14종 중 **5종만**(option-button·counter-input·select-box·finish-button·summary·upload-cta) 사용 — 위젯 코어가 이미 보유한 기본 leaf뿐, **신규 componentType 0**.

### 6.2 갭 (A)/(B)/(C) 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (9)**: A1 CPQ ref_dim 환원(siz/mat/print_opt/proc)·A2 1항목 그룹 자동선택+숨김(hidden-essential)·A3 판형 비노출(종이류 환산)·A4 unit 라벨(매)·A5 sides(default 단일)·A6 디자인 사이즈/수량 더미값→라이브값 렌더·A7 mand_yn→required 직매핑·A8 sel_typ→multiple 직매핑·A9 vat/shipping 산정·(PRICE=0 진단 사유 — 본 대표는 PRICE≠0).
- **(B) 계약 변경 필요 (0)**: 위젯 계약(OptionGroup.required/visible·SizeRule·QuantityRule·BaseRule·summary·upload-cta)이 악세사리 폼을 **전부 기존 슬롯으로 수용** → 계약 변경 0건(목표 달성). C1은 위젯 코어가 이미 완전 커버.
- **(C) DB 작성·교정 — §7 인간 승인 (0)**: 악세사리 대표(PRD_000055)는 **DB 부재/오적재 갭 없음** — 옵션·단가행·제약(0행=정상) 전부 라이브 완비. 자재오염 없음·저청구 없음·CPQ 미적재 없음. **(C) 0건.** (※ 디자인 사이즈/수량≠DB는 외형 프리셋 차이로 A 흡수·교정 불필요.)
  - 잔여 관찰(비차단·정보): sizes `dflt_yn=Y` 3건(A4·A3·A2) 충돌 — 어댑터가 disp_seq 최소(A4)를 기본으로 결정(A 흡수). 권고: 라이브 dflt_yn 단일화(§7 비긴급).

---

## 7. 주문가능 4조건 충족 여부 (PRD_000055 현재)

`widget-forms-approach.md §3` 주문가능 정의 = ⓐ옵션 라이브구동 + ⓑ제약6종 데이터강제 + ⓒPRICE≠0 + ⓓ유효 페이로드.

| 조건 | 현재 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | **충족** | 사이즈 5종 product_sizes 구동 ✅ / 종이·인쇄·커팅 = 라이브 CPQ(각1항목 어댑터 자동) ✅ / 부가옵션 없음(미적재 갭 0) ✅ |
| ⓑ 제약 6종 데이터 강제 | **충족** | ⑥필수·④size·②quantity·⑥base 라이브 강제 ✅ / ①②③④⑤(차별제약) = 디자인·DB 양측 부재로 해당없음(C1 제약 0) ✅ |
| ⓒ PRICE≠0 | **충족** | 단가행 verbatim 4,000~16,000(사이즈별)·전 케이스 >0 ✅ / 저청구·silent0 없음(단일 완제품가 component) ✅ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립 가능 ✅ / PDF CTA(file_upload_yn=Y)·커머스 §24 UNDECIDED 경계 |

**판정: 완전 주문가능(ORDER-CAPABLE).** 악세사리(C1 고정가-단순)는 4조건 **전부 충족** — print(PARTIAL·C 11건 선행조건)와 달리 라이브 데이터 완비로 즉시 주문가능. 위젯/계약/어댑터 준비 완료(B 0건)·DB 작성 불필요(C 0건). **가장 빠르게 주문가능화되는 클래스**(파이프 입증용 최적 — `widget-forms-approach.md §6` 권장과 정합).

**다음 권고:** ① 어댑터 1항목 그룹 자동선택+숨김 규칙 확정(hw-architect data-adapter.md 후니 arm) → ② hw-builder createHuniAdapter로 PRD_000055 NormalizedProduct 완전 조립 → ③ hw-qa 인증세션 evaluate_price 골든 실측(단가행 4,000~16,000 재현·PRICE≠0). 코드 구현은 본 명세 승인 후.

---

## 부록: 동형 전파 노트 (C1 → W-FIX·W-ADDON 경계)

PRD_000055(C1 대표) 매핑 규칙(고정가 by siz·1항목 그룹 자동선택·제약0·단일 완제품가 component·PDF CTA) 전파 대상:

**동형(같은 C1·W-FIX·PRF_STK_*·고정가 by siz)** — 매핑 규칙만 전파(전수 재조립 금지):
PRD_000052·053·054·056·057·058·059·060·061·062·063·064(반칼/낱장 자유형·정사각·직사각·팬시·홀로그램·투명 스티커 — frm=PRF_STK_FIXED 동일)·PRD_000065(스티커팩 frm=PRF_STK_PACK)·067(타투 frm=PRF_STK_TATTOO).

**동형 검증 규칙**: (a) frm_cd가 PRF_STK_* 또는 고정가 단일 component (b) use_dims=[siz_cd,(mat_cd),min_qty] (c) 옵션그룹 = {종이·인쇄·커팅} 각 소수항목 (d) constraints 0행 (e) nonspec_yn='N'. 하나라도 깨지면 새 클래스 — 예: 투명/홀로그램(053/054/063)은 자재 다항이면 종이 select-box가 **실선택 발생**(어댑터 자동선택 불가→노출) = 같은 W-FIX이나 어댑터가 mat 선택지 노출.

**경계(전파 금지·다른 클래스):**
- **W-ADDON 부속**(PRD_000001/002 OPP봉투·"상품악세사리" 카탈로그그룹) — 고정가이나 **addon 템플릿 가산형**(W-ADDON)이라 폼이 부속 가산 구조. C1 단독 폼 아님 → addon 경로(별도 명세).
- **W-AREA 아크릴 악세사리**(PRD_000146 아크릴키링·147 마그넷·148 뱃지 등 nonspec_yn=Y) — 크기직접입력 면적매트릭스(C3)라 area-input. C1 아님 → W-AREA 명세.
- 즉 design "악세사리 폼"(사이즈 패크+수량 2필드)의 **진짜 동형은 스티커류 W-FIX 고정가** 임. 아크릴/봉투 "악세사리"는 명칭만 악세사리·위젯 형상 다름(부록 경계 준수).
