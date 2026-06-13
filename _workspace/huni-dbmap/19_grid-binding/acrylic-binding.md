# 아크릴 — 생산형태 × 그릇 × 선택→견적 binding (round-15 확대 #2)

> **작성** 2026-06-13 · round-15(굿즈파우치 파일럿 A~E 구조 계승). 전 11시트 확대분.
> **목적:** 시트의 각 컬럼이 ① 어떤 생산형태 상품의 ② 어떤 그릇에 담겨 ③ 고객 선택→견적까지 어떻게 이어지는지 + ④ 경쟁사 대조 + ⑤ 현재 고려/GAP을 한 판에.
> **입력 권위(재유도 0·인용):** `15_domain-spec/acrylic/`(mapping-info·column-dictionary·product-bom·domain-research-notes) · `17_correctness/acrylic/`(correction-manifest·extraction-plan·live-diff) · `08_remediation/acrylic.md`(round-3 라이브 권위 G-AC-1~9) · `00_schema/schema-design-intent-map.md`(③ 삼중바인딩·OM-4 두께소실·OM-5 UV print_side) · `production-form-grid-matrix.md`(§완제품) · `_crosscut/accessory-option-research.md`(경쟁사 2축) · 가격 소스 `06_extract/price-acrylic-price-l1.csv`(580행, round-2 추출 완료).
> **DB 미적재 — 조망/목표매핑 전용.**

---

## A. 상품군 성격 (생산형태 + 정체)

> **[보정·독립검증 G1 NO-GO 반영] 도메인 생산형태 ≠ 라이브 `prd_typ_cd`** (`production-form-grid-matrix §1.0`). 둘을 분리 기재 — 불일치 = 오모델로 기록.

| 항목 | 내용 |
|------|------|
| **도메인 생산형태** | **완제품** — 낱장 굿즈 단품. C 완제품/단일 생산(`product-bom §6`, process-recipe §184/§205). 내지/표지 분해 없음. **prd_cd 단위 도메인 판정.** |
| **라이브 `prd_typ_cd` 실측** | **.04 디자인상품** (아크릴 카테고리 .04×11 + 단품형/조합형 .04 — 라이브 전수). **도메인 완제품 ≠ 라이브 .04 = 오모델**(라이브 `prd_typ_cd`는 생산형태 아닌 editor 여부·매입성 혼합 기준, `§1.0`). |
| **정체** | **25 distinct 상품**(단품형 14 + 조합형 11). 라이브 23등록(PRD_000146~169)·★ 2 미등록. |
| **두께=자재 식별자** | **[HARD·G-AC-3/OM-4]** 1.5/3/8/10mm = 별 mat_cd(042/043/044). prd_cd 단위 — 22상품 192 일괄 적재가 두께 소실 결함이었음(round-3 RESOLVED). |
| **에디터 직교** | 카라비너(166)=`editor_yn=Y` — 생산형태 아님, 직교 속성. |
| **인쇄방식 단일** | **UV(PROC_000002) 단일** — 스티커(5분기)·실사(소재정체)와 정반대. 폴더 UV인쇄(직생 18)·루아샵(외주 3) 둘 다 UV 평판 라인. |
| **조각수 variant** | 조합형(자유형스탠드 2~6·미니파츠 10)은 다조각 결합 = 묶음수 + 완칼 조각수 param(entity-semantic §2). |
| **MES** | 단품형/조합형 대부분 `009-*` 부여 · 쉐이커★·지비츠★ 미부여(신규 등록 대상). |
| **가격 소스** | **① 인쇄상품 가격표 엑셀(아크릴 시트)** — `price-acrylic-price-l1.csv`(580행) **면적매트릭스형** [가로][세로]. round-2 추출 완료, 라이브 미적재일 뿐. |

> ⚠️ **정체 미확정 2(★·BATCH-14):** 아크릴쉐이커★·지비츠★ — 라이브 미등록(prd_cd 부재·전행 hidden·MES 미부여). 출시 예정 등록 vs 영구 보류 = CONFIRM-AC-ID-1. 입체코롯토(168)·입체블럭(169)은 라이브 등록됨(정체는 별도 🔴 AC-ID-2).

---

## B. 실무진이 준비한 그릇 (스키마 인벤토리)

`§2 매트릭스 완제품 열` 기준, 아크릴에 실제 쓰이는 그릇 (`§1.0-b` 실무진 표시용 쉬운 라벨 병기):

| 그릇 (t_*) | 아크릴에서 담는 것 | 엑셀 컬럼 | **실무진 표시용 쉬운 라벨** | 비고 |
|-----------|-------------------|----------|---------------------------|------|
| `t_prd_products` | 상품정체·수량(min/max/incr 1~10000·1)·editor_yn·nonspec 범위 | C4·C22~24·C16·C6/C7 | PRD_TYPE.04→**"디자인상품(에디터) — 생산형태는 완제품, 단지 에디터로 디자인"** | 멱등키=prd_nm |
| `t_siz_sizes`+`_sizes` | **재단치수+작업>재단(커팅여유)+형상부기** | C5·C8~10 | 원형/사각/하트/자물쇠→**"완칼 모양(칼선)"** | 형상=완칼 param |
| `t_mat_materials`+`_materials` | **본체 아크릴(MAT_TYPE.03)+두께** + **부속(MAT_TYPE.07)** | C17·C20 | MAT_TYPE.03→**"아크릴(두께별)"** · MAT_TYPE.07→**"부속(고리/자석 등)"** | **두께=별 mat_cd**(042/043/044·195/196 골드실버) |
| `t_prd_product_print_options` | (UV 출력 도수 4도 단일/실제 단·양면) | — | (UV는 인쇄옵션 아님 — 공정으로) | **UV변형 담는 곳 아님**(OM-5 오적재) |
| `t_proc_processes`+`_processes` | **UV평판(002)·완칼(053)·완칼조각수(055)·부착(081)·아크릴가공/접합/라미** | C18·C19·C20·C14 | PROC_000002→**"UV인쇄"** · 053→**"완칼(칼선 모양대로 자르기)"** · 081→**"부속 부착"** | UV변형(C18)=PROC_000002 `변형` param |
| `t_prd_product_bundle_qtys` | **조각수**(조합형 2~10) | C19 | →**"조각수(여러 조각 결합)"** | 묶음수 축(공정 param과 이중 귀속) |
| `t_prd_product_plate_sizes` | 출력판형(빈값)·출력파일(PDF/*AI 칼선) | C11·C13 | →**"출력 파일(칼선 포함)"** | UV 평판=전지규격 무의미(숨김열) |
| `t_prd_product_addons`+`t_prd_templates` | 볼체인 9색(키링·포카키링) | C21 | →**"추가상품(볼체인 색)"** | tmpl_cd(Phase7 재구조화) |
| `t_prd_product_prices` / `t_prc_*` | **면적매트릭스 base** + 가공가 + 추가가 | H·V·X | →**"가격(가로×세로 면적표)"** | round-2 면적형(가격표 권위) |
| `t_prd_product_option_*` (CPQ) | UV변형 택1·가공 캐스케이드·조각수 조건부·볼체인 색 | C18·C20·C19·C21 | →**"고객이 고르는 옵션"** | round-6 L2 |
| `t_prd_product_constraints` | 변형 택1·가공 택일 | (도출) | →**"옵션 선택 규칙"** | 택일그룹 별 그룹 불요(정상) |

→ **그릇은 다 갖춰져 있고 마스터도 건전**(완칼053·부착081·UV002·두께042/043/044·부속045~057 전부 존재). 문제는 **상품 연결 결손**(③선택 미적재 + ④가격 **공식 바인딩 충족률 미흡**) + **의미축 오적재**(UV→print_side).

> **[보정·독립검증 NO-GO 반영] ④가격 "라이브 0"은 틀림**(`§1.2`): 라이브 `comp_prices` **3,481행 적재** — **아크릴 단가 실재**(COMP_ACRYL_CLEAR3T/CLEAR15T/MIRROR3T 등, validator 적발). 단 `product_prices`(직접 고정가) 0 · `price_formulas` 63 바인딩 · 전역 `option_items` 25. **정정: 아크릴 단가행은 실재 적재·미흡한 건 상품별 공식 바인딩 충족률.**

---

## C. 선택 → 견적 end-to-end 목표 매핑 (★핵심·가격=가격표 엑셀)

고객이 견적 화면에서 **고르는 순서**대로, 각 선택이 어느 그릇→가격으로 이어지는지:

| 단계 | 고객 선택 | 담기는 그릇 | UI(componentType) | 가격 기여 |
|:--:|----------|-----------|------------------|----------|
| 1 | **상품** | products+categories | (카탈로그) | 면적매트릭스 블록 결정(투명3T/1.5T/미러3T/코롯토/카라비너) |
| 2 | **두께** | `materials`(MAT_TYPE.03, 두께=mat_cd) | `select-box`/`option-button` | base 단가표 키(3T/1.5T/8T별 매트릭스) |
| 3 | **사이즈** (규격 or 사용자입력) | 치수형→`sizes` / 형상부기→완칼 모양 | `option-button`/`counter-input`(비규격) | **면적매트릭스 [가로][세로]** + off-grid ceiling(앱) |
| 4 | **인쇄(UV변형)** | `processes`(PROC_000002 + `변형` param) | `option-button` | 도수 9/7도 통용(가격표 블록명에 내포) |
| 5 | **부속/가공** (자석/핀/끈/맥세이프/고리) | `materials`(.07 부속) + `processes`(PROC_000081 부착) | `finish-button` | 가공가(V) |
| 6 | **추가상품** (볼체인) | `addons`+`templates`(PRD_000006) | (addon 선택) | 추가가(X) |
| 7 | **수량** | products(min/max/incr) | `counter-input` | × 수량 − 구간할인(가격표 B04/B07) |
| → | **견적 = 면적매트릭스[가로][세로] (두께·도수 블록) + 가공가 + 추가가 − 구간할인** | `t_prc_*` 면적매트릭스형 + `t_dsc_*` | `summary` | ④ 가격 사슬 |

**가격 소스 확정(지니 질문 답):** 아크릴 가격은 **인쇄상품 가격표 엑셀의 아크릴 시트**(`price-acrylic-price-l1.csv`, 580행)에 **이미 존재** — 굿즈파우치(상품마스터 내장 고정가)와 다르게 **면적매트릭스형**(실사·포스터사인 동류, schema-intent §가격유형). 추출 블록:
- **B01 투명아크릴3T** (직접입력형) 양면9도/단면7도 통용 단가 — `아크릴 모든 상품에 적용`(가로×세로 [20mm~] 매트릭스)
- **B02 투명아크릴1.5T**, **B03 미러아크릴3T** 전면5도 통용 단가 (두께/소재별 별 매트릭스)
- **B04 아크릴상품 수량별 구간할인** (round-1 구간할인 연동) · **B05 아크릴코롯토** · **B06 아크릴카라비너(3T+3T 접합)** + **B07 카라비너 구간할인**

> **[보정] 가격 단가행은 라이브 실재.** `comp_prices` 라이브 3,481행 중 **아크릴 단가행 실재 적재**(COMP_ACRYL_CLEAR3T/15T/MIRROR3T 등 — validator 적발, `§1.2`·§97). round-2 추출본(`price-acrylic-price-l1.csv` 580행)이 라이브에 광범위 반영됨. **미흡한 건 상품별 공식 바인딩 충족률**(`price_formulas` 63 바인딩이 25상품 전부를 커버하진 못함) + `product_prices`(직접 고정가) 0. **"가격 라이브 0"은 부정확** — 단가행 실재, 충족률만 미흡.

> **2축 도출 적용(셀 내부):** "두께" → ①BOM축: 자재 식별자(mat_cd) · ②판매축: 선택옵션. "UV변형" → ①공정(PROC_000002 param) · ②택1 옵션. "가공(부속)" → ①자재(.07)+공정(081) · ②택일 옵션. 매트릭스 셀이 1차, 2축이 2차.

---

## D. 경쟁사 대조 (생산형태=완제품 굿즈·아크릴 특화)

| 쟁점 | 경쟁사 패턴 | 후니 정합 | 출처 |
|------|-----------|----------|------|
| 두께(소재 blank) | Printful POD: blank 두께/소재=variant own SKU | 후니 두께=별 mat_cd(자재행), 매트릭스 블록도 두께별 분리 — 흡수 | `accessory-option-research §1`(L34) |
| 표면 색입힘(UV/별색) | WowPress colorinfo(도수)+prsjobinfo(인쇄방식)·표면색=공정 | ✅ UV=PROC_000002(자재 아님)·OM-5 정합. **UV변형≠본체색** | 〃 §3(L83) |
| 형상(원형/하트/자물쇠) | POD: 형상=variant 또는 cut option | 형상부기=완칼 `모양` param(siz_nm 흡수·OM-7) | `correction-manifest AC-C7` |
| 색×사이즈 복합 | commercetools: 폭증 시 split / Printful: variant=유효조합만 | 조합=`option_item` 1행(곱집합 폭증 금지·OM-2). 차원행+polymorphic 포인터가 흡수 | `accessory-option-research §6`(L122) |
| 추가상품(볼체인) | Lasso: 조성동일+수량=variant·색=옵션 | addon+template(PRD_000006), 9색=variant vs 옵션 컨펌(가격표 확인 후) | 〃 §3(L88·Q-ACC-4) |
| 개인화(디자인) | Shopify: 각인/텍스트=line item property(재고 무관) | 에디터(카라비너 editor_yn=Y)·UV 출력=풀컬러, SKU 안 만듦 | 〃 §4(L43) |

→ **후니 그릇이 경쟁사 표현력 흡수**(답습 불요). 아크릴 특화 실 GAP은 **카라비너 고리 5색 부속 코드 부재**(051/052 은/금만)·**라미10T 자재 부재**·**부착 대상 enum에 핀/자석/집게 부재** 정도(아래 E).

---

## E. 현재 고려 여부 + GAP (사슬 끊긴 곳)

| 레이어 | 상태(라이브) | GAP/조치 |
|--------|------|---------|
| ①골격 | ✅ 적재(products 28·sizes 28) | ★ 2상품 미등록(쉐이커/지비츠) |
| ②차원그릇 | 🟡 부분(materials 23/28·processes 17/28) | 두께 RESOLVED·부속 부분·완칼 전무 |
| **③선택(CPQ)** | 🟡 **전역 25**(엽서7+현수막18, 아크릴 0) | 아크릴 옵션 미적재 — UV변형 택1·가공 캐스케이드·조각수 조건부 적재(round-6). ※`option_items` 전역 0이 아님(`§1.2` 정정) |
| **④가격** | 🟡 **단가행 실재·충족률 미흡** | `comp_prices` 3,481(아크릴 COMP_ACRYL_CLEAR3T/15T/MIRROR3T 실재)·`price_formulas` 63·`product_prices` 0. **"라이브 0" 아님** — 상품별 공식 바인딩 충족률만 미흡(`§1.2`·§97 정정) |

**의미축 오적재(round-13 correction-manifest — 라이브 교정 대상):**
- **AC-M1 [High] print_side에 UV변형 적재(20상품)** — `배면양면/풀빼다/투명테두리`가 print_side에 도수쌍으로 하드코딩(`load_master.py:357-369`). 정답=PROC_000002 `변형` param(OM-5). **머리끈154·입체코롯토168·입체블럭169 제외**(print_option 0행).
- **AC-X1 [BLOCKER급] 완칼(053) 전 아크릴 0건** — 형상 굿즈 die-cut 필수인데 미연결. 판/입체류(161/168/169) over-reach 제외(G-AC-1).
- **AC-M2/M3·X2~X6·R1·A1~A4** — usage 미분화·상품별 변형 무시·부착 부분·UV 누락3·고리/와이어링·볼체인 소실·라미/입체 정체.

**잔존 컨펌(인간 결정·correction-manifest §6·BATCH 수렴):**
- 🔴 **CONFIRM-AC-1** 완칼(053) 형상 굿즈 묵시 적재? 판/입체 제외 맞나? → **AC-X1**
- 🔴 **CONFIRM-AC-2/OM-4** 두께 별 mat_cd 교정(042/043/044) vs 192 단일+속성축? → **BATCH-13(두께소실)** 수렴. round-3 RESOLVED(라이브 042·044·043 일치 — AC-C1)
- 🔴 **CONFIRM-AC-4/OM-5** UV변형을 print_side→PROC_000002 `변형` 이동, print_side 정정? → **AC-M1/M3**
- 🔴 **CONFIRM-AC-3** 가공 부속=자재(.07)+부착공정(081) 2축 / 볼펜색·지비츠타입·바디=variant 분기? 부착 대상 enum(핀/자석/집게) 확장? → **AC-X2/X4/X5/A3**
- 🟡 **CONFIRM-AC-6** 볼체인 9색=addon 1+색 variant 재연결(Phase7 template 신설)? · **AC-A1** 라미10T 자재 mint? · **AC-ID-1** ★상품 등록? · **AC-ID-2** 입체류 외주 명세?

> **횡단 연결(round-15 목표 입증):** AC-2/OM-4 두께소실 = **BATCH-13(라미·두께)** · AC-3 부속 분리 = **BATCH-2(색·부속 분리)** · 본체색/형상 = **MAT_TYPE.08~10 자재 오염** 횡단 · UV print_side = **OM-5** · size↔option(조합) = **BATCH-6**. **아크릴 케이스 컨펌이 BATCH 원칙으로 수렴.**

---

## 한 줄 현황

**확대 #2 GO 대기:** 아크릴을 A(**도메인 생산형태=완제품 ≠ 라이브 prd_typ_cd .04 디자인상품=오모델**·UV단일·두께=자재·★정체미확정2)·B(그릇 11종+실무진 쉬운 라벨, 마스터 건전·연결 결손)·C(선택→견적 7단계·**가격=면적매트릭스, comp_prices에 아크릴 단가 실재 적재**·충족률만 미흡)·D(경쟁사 흡수, 실GAP=고리5색/라미10T/부착enum)·E(③아크릴 CPQ 미적재[전역 option_items 25는 엽서/현수막]·④가격 단가행 실재·공식 바인딩 충족률 미흡 + 의미축 오적재 AC-M1 UV→print_side·AC-X1 완칼 전무 + 컨펌 AC-1~6/OM-4/OM-5가 BATCH-13/2/6 수렴). **DB 미적재.**
