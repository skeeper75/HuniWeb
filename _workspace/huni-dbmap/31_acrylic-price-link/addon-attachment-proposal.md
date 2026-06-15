# 추가상품·후가공 귀속 제안 (addon-attachment-proposal)

> **작성** 2026-06-15 · `dbm-price-arbiter`(심의자·돈-크리티컬). 입력 = 라이브 2026-06-15 재실측(addons/templates/template_prices/option_items 구조·행수) + 가격표 B05 후가공 11그룹. **DB 미적재·실 COMMIT 0.** 권고는 제안이며 실 적용·경로 선택은 인간 승인.

---

## 0. 심의 대상 — 아크릴 후가공/부속의 가격 귀속

가격표 B05가 규정한 아크릴 후가공·부속(추가단가):

| 옵션그룹(상품) | 옵션값·추가단가(가격표 B05) | 의미(자재/공정) |
|------|------|------|
| 아크릴키링 | 고리없음 0 / 은색구슬줄(군번줄) 300 / 은색고리 1,100 / 금색고리 1,200 | 부속 자재(MAT_000051 은색고리·052 금색고리) + 부착공정 |
| 아크릴뱃지 | 원형핀(20mm) 600 / 1구자석 1,000 | 부속(MAT_000047 원형핀·048 1구자석) |
| 아크릴마그넷 | 네오디움자석(12mm) 800 | 부속(자석) |
| 아크릴집게 | 투명집게 700 | 부속(MAT_000056) |
| 아크릴명찰 | 일자핀 700 / 2구자석 1,700 | 부속(MAT_000046·049) |
| 아크릴스마트톡 | 화이트바디 2,600 / 투명바디 3,000 | 부속(MAT_000053/054 바디) |
| 아크릴볼펜 | 바디칼라 1,000(색6) | 부속+시각옵션 |
| 머리끈 | 블랙머리끈 500 | 부속(MAT_000057) |
| 카라비너(고리) | 실버/골드/블랙/···11색 모두 0 | 시각옵션(추가가 0) |

> **핵심**: 후가공은 **(a) 부속 자재(t_mat_materials MAT_TYPE.07 아크릴부속 13종 실재) + (b) 부착공정 + (c) 추가단가**의 3중성. round-21 메모리 [[dbmap-option-material-process-bundle]]가 확정한 "한 옵션=자재+공정 BUNDLE". 가격 귀속은 (c) 추가단가를 **어느 그릇에 둘 것인가**의 문제.

---

## 1. DB 구조 3경로 비교 (라이브 2026-06-15 실측 그릇)

### 경로 ⓐ addons → templates → template_prices (완제 SKU 묶음)

```
t_prd_product_addons(prd_cd, tmpl_cd, disp_seq, note)
  → t_prd_templates(tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, tags, ...)
    → t_prd_template_prices(tmpl_cd, apply_ymd, unit_price, note)
```

| 항목 | 실측 |
|------|------|
| 라이브 행수 | addons **5**·templates **11**·template_prices **0** |
| 실 사용처 | **봉투류**(PRD_000016 봉투에 TMPL-000005~011 5개 addon·OPP봉투/카드봉투/트레싱지봉투를 dflt_qty 50/20 묶음 SKU로) |
| 단가 그릇 | `template_prices.unit_price`(템플릿당 고정 총액·apply_ymd 시계열) — **단 라이브 0행**(가격 미적재) |
| 성격 | **완제 SKU**(별개 상품처럼 dflt_qty 묶음·base_prd_cd로 모상품 연결) |

### 경로 ⓑ 가격 component 합산 (addtn_yn=Y)

```
t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn=Y)
  → t_prc_price_components(comp_cd, prc_typ_cd, use_dims)
    → t_prc_component_prices(comp_cd, opt_cd, unit_price, ...)
```

| 항목 | 실측 |
|------|------|
| 그릇 | 본체 공식에 후가공 comp를 **addtn_yn=Y**로 추가 배선 → 엔진이 본체+후가공 합산 |
| 단가 차원 | `component_prices.opt_cd`(후가공 선택값별 단가) — opt_cd 차원 컬럼 실재 |
| 성격 | **가격엔진 내부 합산**(본체와 한 공식·한 견적가) |

### 경로 ⓒ CPQ option_items (선택 레이어)

```
t_prd_product_option_groups(prd_cd, opt_grp_cd, sel_typ_cd, mand_yn, ...)
  → t_prd_product_options(prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, ...)
    → t_prd_product_option_items(prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty)
```

| 항목 | 실측 |
|------|------|
| 그릇 | 손님 화면 선택 구조(group 택1/택N → option → item) |
| **add_price 컬럼** | **부재** — option_items엔 `ref_dim_cd·ref_key1·ref_key2`(polymorphic 참조)만. **추가단가 컬럼 없음** |
| ref_dim_cd 종류(실측) | .01 사이즈·.02 판형·.03 자재·.04 공정·.05 묶음수·.06 도수·.07 셋트 |
| 가격 무는 법 | option_item이 **자재(.03)/공정(.04) 마스터를 참조** → 그 자재/공정 단가가 가격사슬로 들어감(**선택→가격 연결**, item 자체는 가격 안 가짐) |

---

## 2. ★ 경로 비교 종합 (그릇·장단점·언제)

| 축 | ⓐ addons/templates | ⓑ component 합산 | ⓒ CPQ option_items |
|----|------|------|------|
| **단가 그릇** | template_prices.unit_price(템플릿 총액) | component_prices(opt_cd 차원 단가) | **없음**(자재/공정 마스터 참조로 간접) |
| **추가단가 직접 저장** | ✅(템플릿당 1값) | ✅(opt_cd별 단가행) | ❌(참조만·add_price 컬럼 부재) |
| **손님 선택 노출** | △(addon=별 SKU로) | ❌(가격 내부·선택 UI 아님) | ✅(group/option 선택 레이어) |
| **본체와 합산** | ✗(별 SKU·별 주문) | ✅(한 공식 합산가) | ⓑ와 연동돼야 합산 |
| **생산 BOM 환원** | △ | ✅(comp가 자재/공정) | ✅(ref_dim_cd .03/.04로 자재/공정) |
| **언제 쓰나** | **완제 묶음 SKU**(봉투 50장 세트처럼 독립 판매단위) | **본체 가격에 더해지는 가공비**(코팅·후가공 추가단가) | **손님이 고르는 옵션**(자재/도수/사이즈 선택) |
| **라이브 선례** | 봉투류 5 addon | 디지털·엽서 후가공 comp | 전역 items 455(자재254·공정143·도수45) |

> **핵심 통찰**: 세 경로는 **배타가 아니라 역할 분담**. ⓒ(CPQ)는 **선택 노출**, ⓑ(component)는 **선택→가격 합산**, ⓐ(addon)는 **독립 SKU 묶음**. 후니 베스트프랙티스(라이브 선례) = **손님이 고르는 후가공 = ⓒ로 노출 + ⓑ로 가격 합산**(option_item이 후가공 공정/자재 참조 → 그 단가가 component 합산). add_price 컬럼이 CPQ에 없는 것 = **설계 의도상 가격은 항상 가격사슬(t_prc)에서 나오고 CPQ는 참조만** 하라는 것([[dbmap-schema-design-intent-first]]).

---

## 3. 아크릴 후가공별 권고 경로

| 후가공 유형 | 예 | 권고 경로 | 근거 |
|------|----|---------|------|
| **부속+추가단가(손님 선택)** | 은색고리1,100·금색고리1,200·원형핀600·자석·바디 | **ⓒ CPQ 노출 + ⓑ component 합산** | 손님이 화면서 고르고(ⓒ option_group "고리 선택" 택1) 그 선택이 후가공 comp 추가단가를 가격에 합산(ⓑ addtn_yn=Y). 부속 자재(MAT_TYPE.07)·부착공정은 ref_dim_cd .03/.04로 BUNDLE 환원([[dbmap-option-material-process-bundle]]) |
| **추가단가 0 시각옵션** | 카라비너 고리색11·볼펜 바디칼라 | **ⓒ CPQ만**(가격 영향 0) | 추가단가 0 → 가격사슬 불필요. 색 선택만 노출(시각옵션). qty/ref만 |
| **카라비너 본체(3T+3T)** | 자물쇠5,800·하트6,300·원형6,900 | **본체 comp(고정가 .06)** — 후가공 아님 | 카라비너는 후가공이 아니라 **완제 본체**(형상별 고정가). §acrylic-chain-design §3-2 `COMP_ACRYL_CARABINER` opt_cd 차원. ⓒ로 형상 선택 노출 |
| **UV(평판인쇄)** | PROC_000002 UV | **본체 공정**(가격 포함·comp 내부) | UV는 투명아크릴 인쇄공정의 일부(통용단가에 포함) → 별 추가단가 아님. ref_dim .04 공정으로 노출하되 가격 0(이미 본체단가 포함) |

> **ⓐ addon은 아크릴 후가공에 부적합**: addon/template은 **독립 SKU 묶음**(봉투 50장 세트처럼) 용도. 아크릴 후가공(고리·자석)은 본체에 부착되는 부속이지 별 주문단위가 아님 → ⓐ 쓰면 본체와 분리돼 견적 합산이 깨짐. **권고 = ⓐ 사용 안 함**.

---

## 4. ★ 후가공 추가단가의 가격사슬 합산 설계 (ⓑ 상세 — 돈-크리티컬)

손님이 "은색고리(1,100)" 선택 시 견적가 = 본체 면적단가 + 1,100. 이걸 DB로:

```
[CPQ 선택]  option_group "고리"(택1·mand) → option "은색고리"
              → option_item ref_dim_cd=.04(공정 부착) + ref_dim_cd=.03(자재 은색고리 MAT_000051)
[가격 합산]  PRF_CLR_ACRYL 에 후가공 comp 배선:
              formula_components(PRF_CLR_ACRYL, COMP_ACRYL_FINISH, disp_seq=2, addtn_yn=Y)
              COMP_ACRYL_FINISH: prc_typ .01·use_dims=["opt_cd"]
              component_prices(COMP_ACRYL_FINISH, opt_cd=은색고리, unit_price=1100)
                                                  opt_cd=금색고리, unit_price=1200 ...
```

| 결정 | 권고 | 대안·트레이드오프 |
|------|------|------|
| **후가공 comp 단일 vs 그룹별** | **단일 `COMP_ACRYL_FINISH`**(opt_cd 차원으로 전 후가공 단가) | 대안=상품군별 comp(키링고리/뱃지핀 별). 단일이 단순·재사용 우수. opt_cd 한 차원으로 11그룹 30값 커버 |
| **option_item이 가격 어떻게 무나** | option 선택값 = opt_cd 키 → component_prices opt_cd 룩업 | CPQ엔 add_price 없으므로 **opt_cd가 CPQ 선택과 가격행을 잇는 키**. ref_key가 opt_cd면 연결(컨펌 Q-ACR-1) |
| **addtn_yn** | **Y**(본체에 더함) | 본체 disp_seq=1 addtn_yn=N + 후가공 disp_seq=2 addtn_yn=Y |

> **🔴 미해소 핵심(Q-ACR-1)**: CPQ option_item에 add_price 컬럼이 없으므로, "은색고리 선택"이 component_prices의 어느 행을 룩업할지 = **opt_cd 키 정합**이 명확해야 함. ref_dim_cd .04(공정)로 참조하면 공정 단가를, 별 opt_cd 차원이면 후가공 comp opt_cd를 룩업. **엔진 evaluate_price가 CPQ 선택→component opt_cd 매칭을 어떻게 하는지** 미구현이라 계약 미정. → **컨펌 후 배선**(추측 금지).

---

## 5. 일반 원칙 도출 (본체·추가상품 귀속)

| 가격구성 | 그릇 | 원칙 |
|---------|------|------|
| **본체 매트릭스 상품**(스티커·포스터사인·아크릴·엽서북떡메·명함포토카드) | **가격공식 ← component 사슬**(price_formulas → formula_components → price_components → component_prices) | 사용자 directive 1. 본체 = 면적/고정/합산 매트릭스를 comp 단가행으로·공식 바인딩 |
| **후가공·부속**(손님 선택·추가단가>0) | **ⓒ CPQ 노출 + ⓑ component 합산**(addtn_yn=Y·opt_cd 차원) | 선택은 CPQ·가격은 t_prc. add_price 컬럼 부재 = 가격은 항상 가격사슬 |
| **시각옵션**(추가단가=0) | **ⓒ CPQ만** | 가격 영향 0·색/형상 선택만 |
| **완제 묶음 SKU**(봉투 세트 등 독립 주문단위) | **ⓐ addons → templates → template_prices** | 별 SKU·dflt_qty 묶음. 아크릴 후가공엔 부적합 |

> **결론**: 아크릴 후가공 = **ⓒ+ⓑ 조합**(ⓐ 아님). 본체 = component 사슬(directive 1 그대로). 이 원칙이 다른 본체매트릭스 상품군에도 동형 적용 가능.
