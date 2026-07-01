# pilot-PRD_000041.md — 디지털인쇄 종단 파일럿 (스탠다드 쿠폰/상품권)

> 파이프라인 ③' 컨버전 선행. 라이브 실데이터(스냅샷 2026-07-01)로 `NormalizedProduct` 1건 완전 조립 +
> evaluate_price 골든(PRICE≠0) 종단. 클래스=W-CASCADE 대표. 빈 필드·미매핑 0 확인.
> 가격 = 서버 권위(라이브 시뮬레이터 실측). t_prc_* 포팅 없음.

## 0. 라이브 원천 (실측)

```
t_prd_products: prd_cd=PRD_000041, prd_nm=스탠다드 쿠폰/상품권, prd_typ=PRD_TYPE.01(완제품),
  semi_role=∅, nonspec_yn=N, file_upload_yn=Y, editor_yn=N,
  min_qty=12, max_qty=10000, qty_incr=12, dflt_qty=∅, qty_unit=QTY_UNIT.02(매)
t_prd_product_sizes: SIZ_000013(148x68·dflt) / SIZ_000014(148x75·dflt)
t_prd_product_materials(USAGE.07 공통): MAT_000072 백색모조지100g / MAT_000078 아트지150g /
  MAT_000088 스노우지150g / MAT_000105 몽블랑130g  (전부 MAT_TYPE.01 디지털인쇄용지)
t_prd_product_print_options: opt1 단면 POPT_000001(front CMYK4도/back 인쇄안함) / opt2 양면 POPT_000002(both 4도)
t_prd_product_processes: PROC_000004 인쇄(mand_proc_yn=Y, disp_seq=-1=hidden) +
  PROC_000029 오시 / 000030 미싱 / 000031 가변텍스트 / 000032 가변이미지 (전부 mand=N)
t_prd_product_plate_sizes: SIZ_000499 316x467(dflt·impos_yn=Y·OUTPUT_PAPER_TYPE.01 국전계열)
t_prd_product_option_groups: OPT_000052 인쇄(단일/필수) / OPT_000053 종이(단일/필수) / OPT_000054 후가공(다중/선택)
t_prd_product_option_items: 인쇄→ref_dim.06(도수 print_opt_cd) / 종이→ref_dim.03(자재 mat_cd+USAGE.07) /
  후가공→ref_dim.04(공정 proc_cd)
t_prd_product_price_formulas: frm_cd=PRF_DGP_A (apply_bgn 2026-06-01)
t_prd_product_constraints: (없음·0행)
t_clr_color_counts: CLR_000001 인쇄안함(chnl 0) / CLR_000005 CMYK4도(chnl 4)
```

## 1. 조립된 NormalizedProduct (어댑터 산출 결과·fixture 후보)

```jsonc
{
  "code": "PRD_000041",
  "name": "스탠다드 쿠폰/상품권",
  "unit": "매",                         // QTY_UNIT.02 → t_cod_base_codes.cod_nm
  "priceSchemeKey": "PRF_DGP_A",        // 불투명 echo (frm_cd)
  "itemGroup": "PRD_TYPE.01",           // 완제품 (셋트 부모 미등록)
  "sides": [ { "key": "default", "label": "", "uploadType": "pdf" } ],  // editor_yn=N·file_upload_yn=Y
  "optionGroups": [
    { "id": "size", "side": "default", "label": "사이즈", "componentType": "option-button",
      "required": true, "visible": true,
      "values": [
        { "id": "SIZ_000013", "label": "148x68" },           // dflt
        { "id": "SIZ_000014", "label": "148x75" } ] },
    { "id": "OPT_000052", "side": "default", "label": "인쇄", "componentType": "option-button",
      "required": true, "visible": true,
      "values": [
        { "id": "POPT_000001", "label": "단면", "priceColorCount": 4, "colorSide": "SID_S" },  // dflt
        { "id": "POPT_000002", "label": "양면", "priceColorCount": 4, "colorSide": "SID_D" } ] },
    { "id": "OPT_000053", "side": "default", "label": "종이", "componentType": "select-box",
      "required": true, "visible": true,
      "values": [
        { "id": "MAT_000072", "label": "백색모조지 100g" },   // dflt
        { "id": "MAT_000078", "label": "아트지 150g" },
        { "id": "MAT_000088", "label": "스노우지 150g" },
        { "id": "MAT_000105", "label": "몽블랑 130g" } ] },
    { "id": "OPT_000054", "side": "default", "label": "후가공", "componentType": "finish-button",
      "required": false, "visible": true, "multiple": true,
      "values": [
        { "id": "PROC_000029", "label": "오시", "attb": "" },   // prcs_dtl_opt: {줄수 0~3}
        { "id": "PROC_000030", "label": "미싱", "attb": "" },   // {줄수 0~3}
        { "id": "PROC_000031", "label": "가변텍스트" },
        { "id": "PROC_000032", "label": "가변이미지" } ] }
    // PROC_000004(인쇄 base·mand=Y·disp_seq=-1) → visible=false hidden-essential, 어댑터 자동주입(렌더 안 함)
  ],
  "constraints": {
    "disableRules": [],                 // constraints 0행
    "visibilityRules": [],
    "quantity": { "default": { "min": 12, "first": 12, "increment": 12, "step": 12, "default": 12 } },
    "sizeRules": [
      { "valueId": "SIZ_000013", "cutW": 148, "cutH": 68, "workW": 152, "workH": 72 },
      { "valueId": "SIZ_000014", "cutW": 148, "cutH": 75, "workW": 158, "workH": 77 } ],
    "base": { "unit": "매", "cutMargin": 2, "minCutW": 0, "minCutH": 0, "maxCutW": 0, "maxCutH": 0,
              "nonStandardAllowed": false }  // nonspec_yn=N
  },
  "editors": { "koi": false, "rp": false, "pdf": true },
  "cta": { "pdfUpload": true, "designEditor": false, "cart": true, "estimate": true }
}
```

**빈 필드·미매핑 점검**: 모든 계약 필수 필드 채워짐. label 미상(sides.label="")은 단일면이라 빈 라벨 정상. colorHex/imageUrl/badge는 OPTIONAL이고 DB 부재(added-schema 대상)이므로 미주입=정상.

## 2. 가격요청 → evaluate_price → breakdown (골든·PRICE≠0)

위젯 선택(기본): 규격 148x68 · 단면 · 백색모조지100g · 수량 120

```jsonc
// NormalizedPriceRequest
{ "productCode": "PRD_000041", "priceSchemeKey": "PRF_DGP_A",
  "dimensions": [{ "side": "default", "cutW": 148, "cutH": 68, "workW": 152, "workH": 72 }],
  "colorCounts": { "default": 4 }, "materials": { "default": "MAT_000072" },
  "quantity": 120, "selectedFinishes": [] }
```
어댑터 환원 → `evaluate_price({prd_cd:PRD_000041}, {siz_cd:SIZ_000013, print_opt_cd:POPT_000001, mat_cd:MAT_000072, proc_cd:PROC_000004(자동)}, 120)`

라이브 실측 결과(2026-07-01·읽기전용 시뮬레이터):

| qty | final_price | 주요 line |
|-----|-------------|-----------|
| 120 | **307** | COMP_PAPER 307.30 |
| 1008 | **2,581** | COMP_PAPER 2581.32 |
| 5004 | **12,814** | COMP_PAPER 12814.41 |
| 120 (양면+오시·아트지) | **467** | COMP_PAPER 466.50 |

```jsonc
// NormalizedPriceBreakdown (qty=120)
{ "ok": true, "finalPrice": 307, "vat": 0, "shipping": 0,
  "lines": [ { "code": "COMP_PAPER", "label": "용지비(종이별 절가)", "amount": 307.30 } ] }
```

✅ **PRICE≠0 게이트 통과.**

## 3. 적발된 갭 (이 파일럿에서)

- **(C) 디지털인쇄비 0**: COMP_PRINT_DIGITAL_S1·COMP_PRINT_SPOT_WHITE_S1 subtotal=0. base 공정 PROC_000004 단가행/배선 미충전([[digital-print-base-proc-missing-260701]] §26). final_price는 용지비로 PRICE≠0이나 인쇄비 저청구. 교정=§7/§26 인간 승인(어댑터/계약 무관).
- **(C) colorHex/imageUrl/badge 부재**: 용지 select-box·도수 option-button은 라벨만으로 충분(파일럿 영향 0), 그러나 color-chip/image-chip 렌더가 필요한 상품(색지·악세서리)은 added-schema 필요.
- **(D/관례) hidden-essential 표현**: PROC_000004의 visible=false를 disp_seq 음수(-1) 관례로 도출. 전용 VIEW_YN 컬럼 부재(added-schema 검토).

## 4. fixture 후보

본 NormalizedProduct(§1) + golden(§2)을 `04_build` 후니 어댑터 fixture 후보로 hw-builder에 인계. round-trip echo 검증 대상: opt_cd/mat_cd/proc_cd/siz_cd/print_opt_cd 불투명 보존.
