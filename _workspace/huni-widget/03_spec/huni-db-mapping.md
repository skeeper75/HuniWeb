# huni-db-mapping.md — 후니 DB ↔ 정규화 위젯 계약 적합성 분석

> 파이프라인 ③ 분석 산출물. 진행 중인 후니 DB(`docs/huni/table-spec_260602.html`, 29테이블/243컬럼)와
> 정규화 위젯 계약(`04_build/src/contract/*` 구현 + `03_spec/data-contract.md`)의 적합성 검증 + 후니 어댑터 방향 설계.
> [HARD] 본 패스는 분석만. 코드·스펙 무수정. 계약 변경은 권고로만 제시 — 채택 결정은 오케스트레이터.
> [HARD] 서버 권위 가격 유지 — 위젯은 가격을 불투명 결과로만 취급.
> 근거 표기: (후니 테이블명) / (계약 파일) / [역공학] / [동작분석].

---

## 0. 결론 요약 (먼저)

| 항목 | 결론 |
|------|------|
| **전체 적합도** | **높음 (~90%)**. 후니 DB는 정규화 계약을 충분히 수용. 위젯 코드 0 변경으로 Red→후니 어댑터 교체 가능 |
| **가격 적합** | **적합**. 후니의 공식+구성요소단가+할인 모델은 `NormalizedPriceBreakdown`으로 표현 가능. 서버 권위 설계 그대로 유지 — BFF가 후니 공식 모델로 계산, 위젯은 `finalPrice`만 수신 |
| **캐스케이드 적합** | **부분 적합 (6종 중 5종 직접 매핑 / 1종은 자재→공정 disable이 DB에 역방향만 존재 → 어댑터 파생 필요)** |
| **ZERO 위젯 변경** | **달성 가능**. 단, 권고 1건(`customerTier` 의미 명시)과 어댑터 내부 작업 다수. 위젯 가시 계약 변경은 **0건 필수 / 1건 선택** |
| **최상위 갭** | ① 자재→공정 disable이 DB에 명시 테이블 없음(파생 규칙 필요) ② 세트/애드온 상품 모델 미사용 ③ 비규격(nonspec) 치수 입력 → 위젯 `area-input` 연결 미명세 ④ 시계열 `apply_ymd` 처리 책임 |

---

## 1. 매핑 매트릭스 (계약 필드 → 후니 테이블·컬럼)

### 1.1 NomalizedProduct (`contract/product.ts`)

| 계약 필드 | 후니 출처 | 변환/비고 |
|-----------|----------|----------|
| `code` | `t_prd_products.prd_cd` | 그대로 (불투명) |
| `name` | `t_prd_products.prd_nm` | 그대로 |
| `unit` | (DB에 상품 단위 컬럼 없음) → `t_prd_product_bundle_qtys.bdl_unit_nm` 또는 `t_cod_base_codes`(prd_typ_cd 파생) | **갭 G6** — Red `PDT_UNIT` 대응 직접 컬럼 없음. 어댑터가 묶음단위명/코드테이블에서 파생 |
| `priceSchemeKey` | `t_prd_product_price_formulas.frm_cd` (현재 apply 공식) | 불투명 echo. 후니는 공식코드가 가격체계 키 역할 |
| `sides` | `t_prd_products.prd_typ_cd`/`semi_role_cd` + `t_prd_product_sets`(표지/내지 분해) | 책자=세트구조면 `[default,inner]`. **갭 G2** 참조 |
| `optionGroups` | size/print_options/materials/processes 테이블군 | §1.2 컴포넌트 매핑 |
| `constraints` | §1.3 | |
| `editors` | `t_prd_products.editor_yn` (단일 플래그) | **부분 갭** — Red는 koi/rp/pdf 3분기. 후니는 `editor_yn`/`file_upload_yn` 2플래그만. 어댑터가 `{koi: editor_yn==='Y', rp:false, pdf: file_upload_yn==='Y'}` 로 매핑(파트너=Edicus 단일 가정) |
| `cta` | `editor_yn`/`file_upload_yn` + DESIGN 부록A | 어댑터 파생 (Red와 동일 방식) |

### 1.2 옵션 그룹 (componentType 매핑)

| 정규화 OptionGroup | 후니 출처 테이블 | componentType | 비고 |
|-------------------|----------------|---------------|------|
| 규격(size) | `t_prd_product_sizes` ⋈ `t_siz_sizes` | `option-button` | `dflt_yn`→기본선택, `disp_seq`→순서. 비규격은 §1.4 |
| 판형(plate) | `t_prd_product_plate_sizes` ⋈ `t_siz_sizes` | `select-box`/`option-button` | 출력판형 선택(있으면). Red엔 없던 차원 — 어댑터가 별도 그룹화 |
| 용지(material) | `t_prd_product_materials` ⋈ `t_mat_materials` | `select-box` (값多) / `image-chip`(이미지有) | `use_loc`로 표지/내지 side 분기. `sel_typ`/`max_sel_cnt`→`multiple` |
| 인쇄도수(print) | `t_prd_product_print_options` ⋈ `t_clr_color_counts` | `option-button` | front/back 도수. `chnl_cnt`→`priceColorCount`(평면화). §1.3-③ |
| 후가공(process) | `t_prd_product_processes` ⋈ `t_proc_processes` | `finish-button` / `color-chip`(색상有) | `t_proc_processes.prcs_dtl_opt`(text)에 색상값 있으면 color-chip. 택일그룹 §1.3-① |
| 수량(quantity) | `t_prd_products.min/max/dflt_qty,qty_incr` + `t_prd_product_bundle_qtys` | `counter-input` | InputSpec. 묶음수 별도 그룹 가능 |
| 내지페이지 | `t_prd_product_page_rules.page_min/max/incr` | `page-counter-input` | 책자 InputSpec |
| 박/형압 크기 | `t_proc_processes.prcs_dtl_opt`(JSON) | `area-input` | **미명세 G3** — 가로×세로 mm 입력 파라미터의 위치 불명확 |

> 후니 옵션 마스터는 데이터셋 "이름"이 아니라 **테이블 종류**로 구분된다 → 어댑터 룩업 테이블은
> `{테이블종류 → componentType}` 로 작성(Red의 `DATASET_COMPONENT_TYPE`과 동일 패턴, 키만 후니 테이블명).
> 색상 분기(`pcsComponentType(hasColor)`)는 `t_proc_processes.prcs_dtl_opt`에 색상값 존재 여부로 동일 판정.

### 1.3 캐스케이드 제약 (6종)

| 계약 (cascade §0 6종) | 후니 출처 | 적합 |
|----------------------|----------|------|
| ① material→pcs disable (`disableRules`) | **DB에 직접 테이블 없음**. 역방향만 존재: `t_prd_product_materials.dep_proc_cd`(자재→종속공정) | △ **파생 필요 G1** |
| ② quantity (`quantity`) | `t_prd_products.min/max/dflt_qty,qty_incr` + `t_prd_product_page_rules` | ○ 직접 |
| ③ dosu↔bnc → `priceColorCount` 평면화 | `t_clr_color_counts.chnl_cnt`(채널수=색상수) | ○ 직접. 표지/내지는 print_options front/back로 분리 |
| ④ size (`sizeRules`) | `t_siz_sizes.cut_width/height,work_width/height` | ○ 직접 (Red CUT/WRK 1:1) |
| ⑤ pcs essential/hidden → `required/visible` 평면화 | `t_prd_product_processes.mand_proc_yn`(필수) + 택일그룹 `mand_yn` | ○ 필수=mand. **단 hidden(VIEW_YN=N) 대응 컬럼 없음** → §1.3-주2 |
| ⑥ base (`base`) | `t_siz_sizes`(여백/마진) + `t_prd_products.nonspec_*` | ○ 직접 (cutMargin은 size 여백 합산 파생) |

**주1 — ① disable 파생 (G1, 가장 중요):**
후니는 "자재 선택 시 특정 후가공 비활성"을 명시한 테이블이 없다. 대신 두 메커니즘이 있다:
- `t_prd_product_materials.dep_proc_cd` = "이 자재는 이 공정에 **종속**" (자재↔공정 의존)
- `t_prd_product_process_excl_groups` = "이 공정들은 **택일**(mutual-exclusion)"

후니의 의도는 Red의 "disable"과 **방향이 다르다**. Red는 명시적 disable 목록, 후니는 종속·택일 그래프.
→ 어댑터가 후니 종속/택일 그래프를 Red식 `DisableRule[]`로 **파생**해야 한다.
예: 자재 A가 공정 X에 종속(`dep_proc_cd=X`)인데 자재 B는 종속 아님 → B 선택 시 X 비활성 규칙 생성.
또는 `t_prd_products.constraint_json`(text)에 명시적 disable 규칙을 담는 것이 가장 단순 — **권고 R1**.
위젯 계약(`DisableRule`)은 변경 불필요 — 어댑터 내부 파생으로 흡수.

**주2 — ⑤ hidden essential (VIEW_YN=N):**
Red는 `ESN_YN=Y & VIEW_YN=N` = "필수이나 UI 미표시, 자동적용"(예: 재단 CUT_DFT). 후니에는
`mand_proc_yn`(필수)만 있고 "표시여부" 컬럼이 없다. 후니의 의도는 모든 공정을 사용자에게 노출하거나,
필수공정은 항상 자동포함일 수 있다. → 어댑터가 `visible`를 `mand_proc_yn==='Y' && (자동공정 분류)`로
결정. 자동공정 분류 근거가 DB에 없으면 `constraint_json` 또는 `t_cod_base_codes`(공정유형)로 판정.
**갭 G5** — DB가 visible 플래그를 제공하지 않음. 계약은 변경 불필요(어댑터가 visible 계산).

### 1.4 비규격(nonspec) 치수 (G3)

`t_prd_products.nonspec_yn='Y'` + `nonspec_width_min/max,nonspec_height_min/max` 는 자유치수 입력 상품.
계약의 `BaseRule.{minCutW,minCutH,maxCutW,maxCutH,nonStandardAllowed}` + `OptionGroup.inputSpec(axis2)`
(area-input)로 표현 가능. **단 현재 어댑터/계약에 "nonspec → area-input 그룹 생성" 경로가 명세되어
있지 않다**(Red 캡처에 nonspec 상품이 없었음). 위젯 계약(`InputSpec.axis2`, `BaseRule`)은 이미 존재 →
어댑터가 nonspec 상품일 때 area-input OptionGroup을 1개 생성하면 됨. 위젯 변경 0.

### 1.5 가격 (`contract/price.ts`)

| 계약 필드 | 후니 출처 | 비고 |
|-----------|----------|------|
| (Request) `productCode` | `prd_cd` | echo |
| (Request) `priceSchemeKey` | `t_prd_product_price_formulas.frm_cd` | 불투명 echo. BFF가 공식 조회 키로 사용 |
| (Request) `customerTier` | `t_cus_customers.grade_cd` | 불투명. 후니 등급할인 입력 |
| (Request) `dimensions/colorCounts/materials/quantity/pageCount/selectedFinishes` | 위젯 선택 상태 그대로 | 후니 공식 계산 입력 |
| (Response) `finalPrice` | **후니 공식 계산 결과** (§2 참조) | BFF 계산, 위젯 불투명 |
| (Response) `vat` | finalPrice × 0.1 (후니 BFF 산정) | |
| (Response) `shipping` | (후니 배송정책 — DB에 배송 테이블 없음) | **갭 G7** — 배송비 출처 미정. 어댑터가 0 또는 별도 정책 |
| (Response) `lines[]` | `t_prc_formula_components` ⋈ `t_prc_price_components` 별 분해 | 공정/구성요소별 분해 행 (투명성). 후니 공식 모델이 자연스럽게 제공 |

---

## 2. 가격 적합성 (핵심 검증)

### 2.1 후니 가격 모델 구조 (Red과 구조적으로 다름)

후니 가격은 **공식(formula) + 구성요소 다차원 단가 + 할인** 3층 모델이다:

```
상품 → t_prd_product_price_formulas (어떤 공식 쓰나, frm_cd, apply_bgn_ymd)
공식 → t_prc_price_formulas (frm_typ: 공식 유형/계산 방식)
     → t_prc_formula_components (공식 구성요소 목록, addtn_yn 가산여부, disp_seq)
구성요소 → t_prc_price_components (구성요소 정의)
        → t_prc_component_prices (다차원 단가: siz_cd×clr_cd×mat_cd×coat_side_cnt
                                  ×bdl_qty×min_qty(수량구간) × apply_ymd, unit_price)
할인 → t_dsc_discount_tables/details (수량구간 할인율, apply_ymd)
     → t_dsc_grade_discount_rates (등급별 할인율, cat_cd × grade_cd × apply_ymd)
```

Red의 `ORD_INFO + PCS_INFO + price_gbn` → `get_ajax_price_vTmpl` → 3단 워터폴(정가/할인가/몰가)과
**완전히 다른 모델**이다. Red는 서버가 블랙박스로 단일 금액을 반환했고, 후니는 BFF가 공식을 조립·계산한다.

### 2.2 적합 결론: NormalizedPriceBreakdown은 후니 모델을 표현할 수 있다

서버 권위 설계가 정확히 이 차이를 흡수한다:

- 위젯은 `NormalizedPriceRequest`(옵션 선택 상태)만 보낸다 — 후니 공식 모델을 전혀 모름. ✅
- **BFF(후니 어댑터)**가 공식 모델로 계산한다:
  1. `t_prd_product_price_formulas`로 적용 공식 조회 (apply_bgn_ymd ≤ 오늘 중 최신)
  2. `t_prc_formula_components`로 구성요소 목록 + 가산여부
  3. 각 구성요소에 대해 `t_prc_component_prices`에서 요청의 (siz/clr/mat/coat/bdl/qty-band) 차원으로
     `unit_price` 룩업 (apply_ymd 시계열 최신)
  4. 가산(`addtn_yn`)에 따라 합산/곱 → base price
  5. `t_dsc_discount_details`(수량구간 할인) + `t_dsc_grade_discount_rates`(등급 할인) 적용
  6. → 최종 `finalPrice` 단일값 + 구성요소별 `lines[]`
- 위젯은 결과 `finalPrice`/`vat`/`shipping`/`lines[]`만 표시. ✅

**`lines[]`는 오히려 후니에서 더 자연스럽다** — `t_prc_formula_components`의 각 구성요소가 분해 행이
되므로(DESIGN 7.13 가격 투명성), Red보다 풍부한 분해를 제공할 수 있다. 어댑터가
`lines.push({code: comp_cd, label: comp_nm, amount: 해당 구성요소 소계})`.

### 2.3 Red 가정 누수 검사 (계약 필드별)

| 계약 필드 | Red 누수 여부 | 판정 |
|-----------|--------------|------|
| `priceSchemeKey` | Red `price_gbn` 주석이 있으나 **필드명 자체는 중립** | ✅ 누수 없음 (후니 frm_cd 수용) |
| `colorCounts: Record<SideKey, number>` | 도수→색상수 평면화. 후니 `chnl_cnt`로 동일 채움 | ✅ |
| `materials: Record<SideKey, string>` | 불투명 자재 id. 후니 mat_cd 수용 | ✅ |
| `selectedFinishes: {groupId,valueId}[]` | 후가공 평면화. 후니 proc_cd/excl_grp 수용 | ✅ |
| `dimensions: PriceDimension[]` | cut/work 4치수. 후니 `t_siz_sizes` 동일 4치수 | ✅ |
| `NormalizedPriceBreakdown.finalPrice/vat/shipping/lines` | 단일 금액 + 분해. 후니 공식 출력 평면화 가능 | ✅ |

**누수 없음 결론**: `price.ts` 계약은 Red 3단 워터폴 구조를 노출하지 않는다(`finalPrice` 단일값). 후니
공식 모델 출력도 동일 형태로 평면화 가능. **계약 변경 불필요.** 다차원 단가 차원(`coat_side_cnt`,
`bdl_qty`)은 모두 위젯 선택 상태(`selectedFinishes`/materials/quantity)에서 어댑터가 파생하므로 위젯에
추가 필드 노출 불필요. **단 1건 주의 — §2.4.**

### 2.4 다차원 단가 차원 vs 정규화 요청 (잠재 미스매치 점검)

`t_prc_component_prices`의 가격 차원: `siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty(수량구간)`.
정규화 요청이 이 차원을 모두 어댑터에 전달 가능한지:

| 단가 차원 | 정규화 요청 출처 | 가능? |
|-----------|-----------------|-------|
| `siz_cd` | `dimensions[].side` → 어댑터가 선택 size id 보유? | △ **요청에 size valueId가 명시 없음** — dimensions는 cut/work 수치만. 어댑터가 수치→siz_cd 역매핑 필요 또는 selectedOptions에서 size id 확보 |
| `clr_cd` | `colorCounts[side]`(숫자) | △ 색상수→clr_cd 역매핑. 후니 clr_cd가 채널수와 1:1이면 OK |
| `mat_cd` | `materials[side]` | ✅ 불투명 id 그대로 |
| `coat_side_cnt` | `selectedFinishes`(코팅 후가공) | ✅ 어댑터 파생 |
| `bdl_qty` | (묶음수 옵션) | △ 묶음수가 별도 옵션 그룹이면 selectedFinishes/quantity에 포함 |
| `min_qty` 수량구간 | `quantity` | ✅ |

**점검 결과 — 권고 R2 (선택적, 위젯 가시):** size/도수 단가 룩업을 위해 어댑터가 size **id**와 색상 **clr_cd**를
필요로 할 수 있다. 현재 `NormalizedPriceRequest`는 size를 cut/work **수치**로만, 색상을 **숫자**로만 보낸다.
- 옵션 A (권장, 위젯 무변경): 어댑터가 수치→siz_cd, 숫자→clr_cd 역매핑 테이블 보유(BFF 내부). 위젯 변경 0.
- 옵션 B (위젯 가시 변경): 요청에 `selectedOptions: SelectedOption[]`(이미 cart.ts에 존재하는 타입) 추가하여
  size/도수 id를 명시 echo. 어댑터 역매핑 제거. → **위젯 가시 계약 1필드 추가**.

→ **단순성 우선 옵션 A 권장.** 역매핑은 어댑터가 흡수(BFF는 product 마스터를 이미 보유). 위젯 0 변경.

---

## 3. 캐스케이드 적합 결론

- **5/6 직접 매핑**: quantity, dosu↔color, size, base, essential(필수)은 후니 테이블에 직접 대응.
- **1/6 파생 필요(G1)**: material→pcs disable. 후니는 종속(`dep_proc_cd`)+택일(`excl_groups`) 그래프로
  표현 — Red식 명시 disable 목록이 없다. 어댑터가 그래프→`DisableRule[]` 파생, 또는 `constraint_json`에
  명시적 disable 규칙 적재(권고 R1).
- **택일그룹은 보너스**: `t_prd_product_process_excl_groups`(sel_typ, max_sel_cnt, mand_yn)는 Red에 없던
  "후가공 mutual-exclusion" 1급 모델. 현재 계약은 `DisableRule`(disable)만 있고 **택일(라디오식 상호배제)**을
  1급 표현하지 않는다. → **권고 R3**: 택일그룹은 `OptionGroup.multiple=false` + 동일 그룹으로 묶어
  표현하면 위젯이 자연히 단일선택 처리 → 어댑터가 excl_group의 공정들을 1개 OptionGroup으로 그룹화.
  **위젯 계약 변경 불필요**(이미 `multiple` 플래그 존재, `product.ts:58`).

**캐스케이드 위젯 코드 변경: 0건.** 모든 차이는 어댑터 파생/그룹화로 흡수.

---

## 4. 후니 어댑터 설계 (`adapters/huni/` — 구체화)

5개 인터페이스(`adapters/types.ts`) 각 메서드가 읽는 후니 테이블:

```
HuniProductAdapter.getProduct(prd_cd):
  t_prd_products                      → code/name/unit(파생)/editors/cta/nonspec(BaseRule)
  t_prd_product_categories ⋈ t_cat_categories → (분류 메타, 선택)
  t_prd_product_sizes ⋈ t_siz_sizes   → 규격 OptionGroup + sizeRules(cut/work)
  t_prd_product_plate_sizes ⋈ t_siz_sizes → 판형 OptionGroup(있으면)
  t_prd_product_materials ⋈ t_mat_materials → 용지 OptionGroup(use_loc로 side분기, sel_typ→multiple)
  t_prd_product_print_options ⋈ t_clr_color_counts → 도수 OptionGroup(chnl_cnt→priceColorCount)
  t_prd_product_processes ⋈ t_proc_processes → 후가공 OptionGroup(finish/color-chip)
  t_prd_product_process_excl_groups   → 택일그룹 → 동일 OptionGroup 묶기(R3) + required(mand_yn)
  t_prd_product_materials.dep_proc_cd → DisableRule[] 파생(G1/R1)
  t_prd_product_page_rules            → 내지 page-counter InputSpec
  t_prd_product_bundle_qtys           → 묶음수 OptionGroup/단위
  t_prd_products.constraint_json      → 보조 제약(disable 명시 시 우선)

HuniPriceAdapter.quote(NormalizedPriceRequest):
  t_prd_product_price_formulas(apply 최신) → frm_cd
  t_prc_price_formulas(frm_typ)            → 계산 방식
  t_prc_formula_components(addtn_yn,disp_seq) → 구성요소 목록
  t_prc_price_components                   → 구성요소 정의(comp_nm→line label)
  t_prc_component_prices(다차원,apply_ymd 최신) → unit_price 룩업
  t_prd_product_prices(apply_ymd 최신)     → 상품 기본단가(공식이 참조 시)
  t_dsc_discount_details(수량구간,apply_ymd) → 수량할인
  t_dsc_grade_discount_rates(cat×grade,apply_ymd) + t_cus_customers.grade_cd → 등급할인
  → finalPrice + lines[] + vat. shipping: 정책미정(G7)

HuniUploadAdapter.issuePresigned: 후니 스토리지(S3/GCS) presigned. DB 무관(인프라 설정)
HuniEditorAdapter.getConfig: .env.local EDICUS_PARTNER_CODE → 토큰발급 → NormalizedEditorConfig. DB 무관
HuniCartAdapter.handoff: [UNDECIDED] — Shopby 제외. 커머스 확정 시 내부만 구현. 위젯·계약 무관
```

**시계열(`apply_ymd`) 처리는 전적으로 어댑터 책임(G8):** 모든 `*_prices`/`discount_details`/
`grade_discount_rates`는 `apply_ymd` 시계열. 어댑터가 "오늘(또는 주문일) ≤ apply_ymd 중 최신" 행을 선택.
위젯은 시점을 모름 → 계약 변경 불필요.

---

## 5. 위젯 코드 변경 평가 (ZERO 목표)

| 영역 | 위젯 가시 계약 변경 | 어댑터 내부 작업 |
|------|---------------------|-----------------|
| Product/옵션 그룹 | **0** (componentType·OptionGroup 그대로) | 후니 테이블→OptionGroup 매퍼 작성, componentType 룩업(후니 테이블명 키) |
| 캐스케이드 6종 | **0** (DisableRule/Quantity/Size/Base 그대로, multiple 기존 필드) | disable 파생(G1), 택일 그룹화(R3), visible 계산(G5) |
| 가격 | **0** (NormalizedPriceRequest/Breakdown 그대로) | 공식 모델 계산 엔진(R2 옵션A: 수치→id 역매핑) |
| 업로드/에디터 | **0** | presigned/토큰 인프라 교체 |
| 장바구니 | **0** (UNDECIDED 유지) | 커머스 확정 시 handoff 내부 |

**ZERO 위젯 변경 = 달성 가능 (확정).** 필수 위젯 가시 계약 변경 **0건**.

선택적 위젯 가시 변경 후보(**채택 불요, 단순성 우선 미채택 권장**):
- R2 옵션B: `NormalizedPriceRequest`에 `selectedOptions?` 추가(어댑터 역매핑 회피용). → **미권장**. 어댑터가
  product 마스터 보유하므로 역매핑은 서버측에서 무비용. 위젯 계약 오염 회피가 더 가치 있음.

→ **결론: 정규화 계약은 후니 DB를 위젯 무변경으로 수용한다. 키스톤(계약+어댑터) 가설 검증 성공.**

---

## 6. 갭 & 오픈 퀘스천 (사용자 확인 필요)

| ID | 갭/질문 | 영향 | 권고 |
|----|---------|------|------|
| **G1** | 자재→공정 disable이 후니 DB에 명시 테이블 없음(종속/택일 그래프만) | 캐스케이드 ① | **R1**: `t_prd_products.constraint_json`에 명시적 disable 규칙 적재(가장 단순), 또는 어댑터가 `dep_proc_cd`+`excl_groups`로 파생. 어느 쪽이 후니 의도인지 확인 필요 |
| **G2** | 책자 표지/내지 구조가 `t_prd_product_sets`(세트)인지, 단일 상품 내 side 분리인지 불명확 | sides/내지 옵션 | 책자 모델링 방식 확인. 세트면 어댑터가 sub_prd 분해, 단일이면 print_options front/back + page_rules |
| **G3** | 박/형압 가로×세로 mm 입력 파라미터가 `prcs_dtl_opt`(text) 어디에 있는지, area-input 연결 미명세 | area-input 옵션 | `prcs_dtl_opt` JSON 스키마 확인 |
| **G4** | nonspec(비규격) 상품의 자유치수→area-input 그룹 생성 경로 미명세(Red 캡처에 nonspec 부재) | 비규격 상품 | 어댑터에 nonspec→area-input 생성 규칙 추가(위젯 계약은 이미 지원). 후니 nonspec 샘플 상품 1건 필요 |
| **G5** | 공정 "표시여부(VIEW_YN)" 컬럼이 후니 DB에 없음(필수여부만) | hidden essential 자동적용 | 후니가 자동공정을 어떻게 구분하는지 확인. `constraint_json` 또는 공정유형코드로 판정 가능한지 |
| **G6** | 상품 단위(`unit`, Red PDT_UNIT) 직접 컬럼 없음 | 표시용 unit | `bdl_unit_nm`/`prd_typ_cd` 파생으로 충분한지 확인 |
| **G7** | 배송비(`shipping`) 출처 테이블 없음 | PriceBreakdown.shipping | 후니 배송정책/테이블 확인. 없으면 0 또는 BFF 별도 정책 |
| **G8** | 시계열 `apply_ymd` 기준일(주문일 vs 견적일) 정책 | 가격 정확성 | 어댑터 기준일 정책 확정(통상 견적 시점). 위젯 무관 |
| **G9** | 세트(`t_prd_product_sets`)·애드온(`t_prd_product_addons`) 상품을 위젯이 다루는가 | 상품 범위 | 현재 계약은 단일 상품 견적. 세트/애드온 견적이 위젯 범위면 추가 설계 필요(현 미스코프) |

---

## 7. 권고 요약 (오케스트레이터 결정 대상)

| 권고 | 내용 | 위젯 가시? | 단순성 판정 |
|------|------|-----------|------------|
| **R1** | 자재→공정 disable을 `constraint_json`에 명시 적재(어댑터 파생보다 명료·단순) | No (어댑터/DB) | ✅ 권장 |
| **R2** | 가격 단가 차원의 size/색상 id 확보 — **옵션A(어댑터 역매핑, 위젯 무변경)** 채택 | No | ✅ 옵션A 권장 |
| **R3** | 택일그룹을 단일 OptionGroup(`multiple=false`)으로 그룹화 — 위젯 계약 이미 지원 | No | ✅ 권장 |
| (미채택) | `NormalizedPriceRequest.selectedOptions` 추가(R2 옵션B) | Yes | ✗ 미권장 (계약 오염) |

---

## 8. 다음 단계 권고

1. **G1/G2/G5 사용자 확인** (캐스케이드·책자·hidden 모델링 방식) — 어댑터 파생 로직 확정의 선결.
2. 확인 후 `data-adapter.md §4`(후니 어댑터 stub)를 본 문서 §4 구체안으로 갱신 + `adapters/huni/` 스켈레톤
   작성(인터페이스 5개 구현, DB 쿼리는 G 해소 후).
3. **계약 테스트 게이트**: 후니 어댑터 출력이 정규화 스키마 일치 → Red fixture 회귀테스트가 후니 어댑터로도
   동일 통과(위젯 불변 증명).
4. 위젯 코드·계약은 **본 분석 결과 무변경 확정** — hw-builder 재작업 불필요.
