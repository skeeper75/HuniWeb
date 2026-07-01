# goods-form-spec.md — 굿즈(C2·goods) 위젯 폼 주문가능 종단 명세

> 파이프라인 ③' 컨버전 선행 · 명세까지(코드 0줄·다음 승인).
> **외형·제약 의도 권위** = `docs/design/11가지상품옵션/product-goods-option/Configurator.jsx`(200줄·사이즈·옵션색상·가공·제작수량·구간할인 Slider·볼체인 addon).
> **데이터 권위** = 라이브 DB 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + readiness/remediation 산출 재사용.
> **가격 권위** = 서버 `pricing.py:evaluate_price`(:394) 불투명 결과 + 수량구간 할인(`t_dsc_*`). t_prc_* 위젯 포팅 금지. PRICE=0=결함.
> **계약 목표** = 위젯 가시 계약 변경 0 — 매핑은 어댑터(`createHuniAdapter`)가 흡수.
> 대표 상품 = **PRD_000146 아크릴키링** (C2 두 초점 ⓐ구간할인 Slider·ⓑ볼체인 addon 둘 다 라이브 보유 · 자재오염 제거 완료 · PRF_CLR_ACRYL 바인딩·아크릴군 카논 baseline).
> 상위 분석 = `../../widget-forms-approach.md`(11폼·제약6종·주문가능4조건) · 선행 선례 = `../digital-print/print-form-spec.md`(동일 6부 구조).

---

## 0. 대표 상품 선정 근거 (PRD_000146 아크릴키링)

C2 "단순+추가상품" 클래스의 두 차별 초점은 ⓐ **구간할인 Slider**(제작수량별 자동 할인)와 ⓑ **추가상품 addon**(볼체인/고리)이다. 라이브 굿즈 카테고리(아크릴키링·마그넷·뱃지·스마트톡·집게·파우치·키링류 다수)를 전수 스캔한 결과:

- **addon(t_prd_product_addons) 보유 굿즈 = 아크릴류 7상품뿐** — PRD_000146(키링·4템플릿)·147(마그넷)·148(뱃지)·149·150·152·154. 파우치/키링류 대부분은 옵션그룹·addon 0행(반제품/기성 단순).
- 그 중 **PRD_000146 아크릴키링**이 ⓐ구간할인(DSC_ACR_QTY) + ⓑ **볼체인 addon(TMPL-000018 = 디자인 폼의 "볼체인 +1,000원"과 단가 verbatim 일치)** 둘 다 보유하고, ⓒ 자재오염(키링고리 MAT_TYPE.07)이 **2026-06-28 del_yn=Y로 제거되어 본체 자재만(MAT_000042/043 투명아크릴) 남은 클린 상태**, ⓓ PRF_CLR_ACRYL 바인딩·readiness `calc=OK·priced·BOUND_OK`·아크릴 15상품의 **카논 baseline**이다.

→ 대표 = PRD_000146. 같은 클래스 아크릴 굿즈(147·148·149·150·152·154 + bind-only 15건)에 동형 전파.

**★구조적 갭(디자인=외형 / 라이브=데이터, 정직 표기):** 디자인 "굿즈" 폼은 **고정 사이즈 버튼 3종**(73x68·98x98·100x150)과 단순 **색상 칩**(10색)을 가정한다. 그러나 라이브 PRD_000146은 **`nonspec_yn=Y`(직접입력 가능, 20~100mm) + 등록 사이즈 8종(SIZ_000329~335·011, 20x30~)** 이고 색상축은 **인쇄옵션(배면양면/풀빼다/투명테두리)** 으로 적재돼 있다. 즉 라이브 굿즈는 면적입력(C3) 성격을 겸한다. **위젯은 라이브 데이터 권위** — 등록 사이즈 8종을 `option-button`/`select-box`로 렌더하고, nonspec 직접입력은 `area-input`으로 병행 노출(어댑터 흡수, A). 디자인의 고정 3사이즈·10색칩은 일반 굿즈 프리셋 외형이며 라이브 상품 데이터와 불일치(아래 §2에서 행별 명시).

**라이브 실측 PRD_000146 구성(스냅샷 2026-07-01):**
```
prd_typ=PRD_TYPE.01(완제품)·semi_role=∅·nonspec_yn=Y(20~100mm·incr 미설정)·file_upload_yn=Y·editor_yn=N
min_qty=1·max_qty=10000·qty_incr=1·dflt_qty=∅·qty_unit=QTY_UNIT.01(개)
sizes(등록 8종): SIZ_000329 20x30 / 330 30x30 / 331 30x40 / 332 30x70 / 333 40x40 / 334 40x50 / 335 40x60 / 011  (전부 dflt_yn=Y — 충돌, §3 ⑥)
materials(활성 2·USAGE.07): MAT_000042 아크릴투명1.5mm(dflt Y) / MAT_000043 아크릴투명3mm(dflt Y)  ★MAT_000051/052(키링고리·MAT_TYPE.07)=del_yn=Y(오염제거됨)
print_options(3): POPT_000004 배면양면(dflt Y) / POPT_000003 풀빼다 / POPT_000005 투명테두리
processes(1): PROC_000002 (mand_proc_yn=Y·disp_seq=5)
plate_sizes: SIZ_000329~011 (전부 del_yn=Y·"파일사양" 메모 — 비종이류라 판형 무효, §29 종이류만 HARD)
option_groups: 0행 (post-undo·acryl-146-step2-undo 적용 상태)
constraints: 0행
discount: DSC_ACR_QTY (DSC_TYPE.01 정률·6밴드)
addons(4): TMPL-000015 은색고리1100 / 016 금색고리1200 / 017 은색구슬줄300 / 018 볼체인1000  ★템플릿 del_yn=Y(최근 소프트삭제·template_prices 적재 유지)
price_formula: PRF_CLR_ACRYL(투명아크릴공식·활성) → COMP_ACRYL_CLEAR3T(PRICE_TYPE.02 면적단가·use_dims=[mat_cd,siz_width,siz_height,min_qty]·277행)
```

---

## 1. 폼 필드 인벤토리 → 정규화 계약 매핑 (Configurator.jsx 전수)

각 OptionField → `OptionGroup`(또는 InputSpec/addon). componentType=DESIGN.md 14종 사상. side는 굿즈 전부 `default`(단일면).

| # | JSX 필드(state) | 디자인 컴포넌트 | 정규화 componentType | side | required | visible | values 출처(라이브 PRD_000146) | InputSpec |
|---|----------------|----------------|----------------------|------|:--:|:--:|--------------------------------|-----------|
| 1 | 사이즈 size | OptionButtonGroup(3열·3종) | `option-button`(값≤6) | default | Y | Y | product_sizes ⋈ siz_sizes (등록 8종 SIZ_000329~335·011) — ★디자인 3종≠DB 8종 | — |
| 1b | (없음·DB만) 직접입력 | — | `area-input` | default | N | 조건 | nonspec_yn=Y·W/H 20~100mm | min20·max100(양축) |
| 2 | 옵션(색상) color | GoodsColor 칩×10(2행) | `option-button` 또는 `color-chip` | default | Y | Y | **의미 갭** — DB 색상축 부재. 인쇄옵션(POPT_000004/003/005)이 가장 근접(배면양면/풀빼다/투명테두리) — (B/C) | — |
| 3 | 가공 process | OptionButtonGroup(2열·미방없음/라벨부착) | `option-button` | default | N | Y | **CPQ 부재**(라벨부착 옵션그룹 미생성·공정 PROC_000002만 mand) — (C) | — |
| 4 | 제작수량 qty | QuantityStepper(min10·step10·max2000) | `counter-input` | default | Y | Y | products.{min1,max10000,qty_incr1} — ★디자인 min10/step10≠DB min1/incr1 | min1·max10000·step1 |
| 5 | 구간할인 discIdx | **DiscountSlider**(stops 1/10/50/100/500/1000+) | **`summary` 정보표시(읽기전용)** — 입력값 아님 | — | — | Y | DSC_ACR_QTY 6밴드(0/10/20/30/40/50%) | — (★Slider 결론 §6.3) |
| 6 | 볼체인 chain | SelectBox(선택안함+4색·+1,000원) | addon(W-ADDON) `select-box` | default | N | Y | product_addons ⋈ templates → TMPL-000015~018(고리/구슬줄/**볼체인1000**) ★template del_yn=Y | — |
| 7 | 볼체인 수량 chainQty | SelectBox(1/2/3개) | addon 수량 `counter-input`/`select-box` | default | 조건 | chain!=none | template dflt_qty=1·수량 미적재(파라미터) — (C) GAP-PARAM | min1·max? |
| — | (어댑터 생성) 필수공정 | (없음·hidden) | hidden-essential | default | Y | **N** | PROC_000002 mand_proc_yn=Y 자동주입 | — |
| — | (어댑터 생성) 요약 | PriceBlock | `summary` | — | — | — | evaluate_price breakdown + addon + 할인 | — |
| — | (어댑터 생성) 업로드/에디터 | Button×2 | `upload-cta`(+designEditor) | default | Y | — | file_upload_yn=Y / editor_yn=N(디자인 폼 에디터 버튼과 불일치) | — |

**계약/DB 매핑 요약(7 폼필드):**
- **완전 매핑(라이브 데이터 채움 가능) 3** — 사이즈(1, 8종)·제작수량(4)·볼체인 addon(6, 템플릿). + 어댑터생성 필수공정/요약/업로드.
- **부분 매핑 1** — 볼체인 수량(7): addon 템플릿은 있으나 수량 파라미터 미적재(GAP-PARAM·C).
- **미매핑/의미갭 2** — 색상(2): DB 색상축 부재(인쇄옵션 근접·B/C) / 가공 라벨부착(3): 옵션그룹 미생성(C).
- **정보표시(입력 아님) 1** — 구간할인 Slider(5): evaluate_price 내부 할인의 시각화일 뿐 위젯 입력축 아님(§6.3 Slider 결론).

---

## 2. 옵션 데이터 → 라이브 DB 바인딩 (디자인 값 ↔ 라이브 값 대조)

| 옵션 | 디자인 하드코딩 값 | 라이브 출처(PRD_000146) | 일치/불일치 |
|------|-------------------|------------------------|-------------|
| 사이즈 | 3종(73x68·98x98·100x150 mm) | 등록 8종(20x30·30x30·30x40·30x70·40x40·40x50·40x60·SIZ_011) + nonspec 20~100mm | ❌ **불일치** — 디자인 3종(일반 굿즈 프리셋·73~150mm) vs DB 8종(아크릴키링 소형 20~60mm). 위젯은 DB 8종 렌더 + 직접입력 병행 |
| 옵션(색상) | 10색칩(화이트~옐로) | **부재** — 색상축 DB 미적재. 인쇄옵션 3종(배면양면/풀빼다/투명테두리)이 가장 근접 | ❌ **의미 갭(B/C)** — 디자인 "색상"은 칩 UI지만 라이브는 색상 차원 없음. 아크릴=투명소재라 "색상"보다 인쇄방식(배면/풀빼다/테두리) 선택이 실제 축 |
| 가공 | 2종(미방없음/라벨부착) | **CPQ 부재**(라벨부착 옵션그룹 미생성·공정 PROC_000002 1개만 mand) | ❌ **갭(C)** — 라벨부착 옵션 미적재 |
| 제작수량 | min10/step10/max2000 | min1/incr1/max10000 | ❌ **불일치** — 위젯은 DB값(1 단위) 권위 |
| 구간할인 | stops 1/10/50/100/500/1000+ · "6%off" placeholder | DSC_ACR_QTY 6밴드: 1-49=0%·50-99=10%·100-299=20%·300-499=30%·500-999=40%·1000+=50% | △ **밴드 경계 근접·할인율 상이** — 디자인 stops와 DB 밴드 하한(1/50/100/300/500/1000)이 거의 일치. "6%off"는 디자인 더미값(실 DB=구간별 0~50%) |
| 볼체인 | 4색(오렌지/블루/핑크/블랙) 3개1팩 +1,000원 | TMPL-000018 볼체인 unit_price=**1000**(+ 은색고리1100·금색고리1200·은색구슬줄300) | △ **단가 verbatim 일치(1000)** · 색상 라벨 상이(DB=재질/고리종류·디자인=색상). DB는 색상분기 없음·고리종류 분기 |
| 볼체인 수량 | 1/2/3개 | template dflt_qty=1·수량 차원 미적재 | ❌ **갭(C)** — addon 수량 파라미터 부재(GAP-PARAM) |

**★자재오염(이미 교정됨·정합 확인):** print 명세(PRD_000042)에서 발견된 종이↔굿즈자재 오염과 달리, PRD_000146은 **2026-06-28 키링고리 자재(MAT_000051/052·MAT_TYPE.07)가 del_yn=Y로 정리되고 고리는 addon 템플릿(TMPL-000015/016)으로 이관**됐다([[goods-material-contamination-260630]] 후속 교정 반영). 현재 활성 자재는 본체 투명아크릴 2종(MAT_000042/043·MAT_TYPE.03)뿐 → **오염 없음(클린 baseline)**. evaluate_price는 본체 면적단가만 계산하고 고리/볼체인은 addon 정액 가산 → silent 합산 위험 없음.

---

## 3. 제약 추출·정규화 (★핵심·6종) — 디자인 의도 ↔ 라이브 데이터 ↔ 갭

PRD_000146은 `t_prd_product_constraints` **0행**이다. C2 굿즈는 print(C4)·book(C5) 대비 제약이 적다(디자인 조건부 2건: 볼체인 선택 시 수량 노출·가공 토글). 6종 분류:

### 3.1 제약 추출표

| 제약형태(JSX) | 트리거 | 실례 | 정규화 매핑 | DB 출처(존재여부) | 갭 |
|--------------|--------|------|-------------|-------------------|-----|
| ③ **토글→하위필드 visible** | `chain!=="none"` | 볼체인 선택 → 볼체인 수량 노출 | `VisibilityRule{trigger:볼체인선택, shows:[볼체인수량]}` | addon 템플릿 존재·수량 파라미터 부재 | **(A)** addon 선택 시 수량 노출=어댑터 파생(수량 차원은 C GAP-PARAM) |
| ④ **범위검증 area** | (디자인 미노출·DB만) 직접입력 | nonspec W/H 20~100mm | `InputSpec{min20,max100,axis2{20,100}} + BaseRule.nonStandardAllowed=true` | products.nonspec_yn=Y·min/max 적재(incr 미설정) | **(A)** nonspec→area-input 직매핑(incr 기본1 보완) |
| ⑤ **택1 패턴** | 사이즈 size | 8종 택1 | `OptionGroup(multiple=false)` | product_sizes 8행 | **(A)** 단일선택 직매핑 |
| ⑤ **택1 패턴** | 옵션(색상) color | 10색 택1 | `OptionGroup(multiple=false)` | 색상축 부재(인쇄옵션 근접) | **(B/C)** 색상 의미갭 |
| ⑤ **택1 패턴** | 가공 process | 2종 택1 | `OptionGroup(multiple=false)` | 라벨부착 옵션 부재 | **(C)** |
| ⑥ **필수 required** | 주문 전 필수 | 사이즈·수량(·색상·가공) | `OptionGroup.required=true` | sizes 항상필수·qty 항상 / 색상·가공=옵션 부재 | **(A)** sizes/qty 직매핑 (색상·가공은 부재라 강제 불가) |
| ⑥ **필수 hidden-essential** | (디자인 비노출) | 본체 인쇄가공 공정 | `OptionGroup.{required:true,visible:false}` 자동주입 | PROC_000002 mand_proc_yn=Y | **(A)** 필수공정 자동주입 |
| ② **quantity clamp** | 제작수량 | min/max/incr | `QuantityRule{min1,first1,increment1}` | products.{min1,max10000,qty_incr1} | **(A)** 직매핑(★디자인 min10/step10≠DB — DB 권위) |
| ② **quantity tier(할인)** | 구간할인 Slider | 1/50/100/300/500/1000 밴드 | (입력 아님) 어댑터가 evaluate_price 응답의 할인율을 `summary`에 표시 | DSC_ACR_QTY 6밴드(서버 내부 적용) | **(A)** 서버 권위·위젯 입력축 아님 |
| ④ **size** | 사이즈 선택 | cut/work 치수 | `SizeRule[]` | siz_sizes.{cut,work}_{w,h} 1:1 | **(A)** 직매핑 |
| ⑥ **base** | — | 단위·재단마진·비규격허용 | `BaseRule{unit:개,nonStandardAllowed:true}` | siz_sizes(마진 미설정)·nonspec_yn=Y | **(A)** 직매핑 |
| ① visible cascade(add/remove) | (디자인 명시 없음) | — | `visibilityRules[]` | constraints 0행 | **(A)** 빈 배열 |
| ② disable | (디자인 명시 없음) | — | `disableRules[]` | constraints 0행·excl 부재 | **(A)** 빈 배열 |

### 3.2 제약 6종 디자인↔DB 일치/갭 집계

| 제약축 | 디자인 의도 룰 수 | 라이브 데이터 충족 | 갭 |
|--------|:---:|:---:|-----|
| ① visible cascade | 0 | 0 | 일치(둘 다 없음) |
| ② disable | 0 | 0 | 일치 |
| ③ 토글→하위(볼체인 수량) | 1 | 1(addon 존재→어댑터 파생) | **일치(A)** — 단 수량 파라미터 GAP-PARAM(C) |
| ④ 범위검증(area·size) | 2(직접입력·사이즈치수) | 2(nonspec·siz_sizes) | **일치(A)** |
| ⑤ 택1(사이즈·색상·가공) | 3 | 1(사이즈만 옵션 존재) | **갭 2 (C)**(색상 의미갭 B/C·가공 미적재 C) |
| ⑥ 필수(사이즈·수량+hidden base) | 3 | 3(sizes·qty·PROC_000002 mand) | **일치(A)** |
| **합계** | **9** | **7 충족** | **일치 7·갭 2**(색상·가공 CPQ 미적재 — 색상은 B/C 의미갭) |

**제약 결론:** C2 굿즈는 제약이 적어 ⑥필수·④size/area·②quantity·③addon토글이 **라이브 데이터로 완전 강제(A 어댑터 흡수)**. 갭은 단 2건 — **색상 축(의미갭·아크릴은 투명소재라 색상보다 인쇄방식 축이 적합)·가공(라벨부착) 옵션 미적재(C)**. 위젯 계약(OptionGroup.multiple·VisibilityRule·InputSpec·BaseRule.nonStandardAllowed)은 이미 표현 슬롯 보유 → **계약 변경 0(B 0건, 단 색상칩 의미는 B 후보)**.

---

## 4. 가격 결선 (evaluate_price 골든) — 디자인 가짜식 폐기

### 4.1 디자인 가짜 계산식 (폐기 대상)

goods JSX(:16,:120~125)는 **상수 하드코딩**: `subtotal=75000`·`vat=7500`·할인 `-25000`(6%off 더미)·추가상품 `+1000`. 선택값과 무관한 고정 더미값 → **전부 폐기.** 실 가격은 면적단가×수량×구간할인 + addon 정액. evaluate_price 권위.

### 4.2 위젯 경로 (정규화 계약)

```
NormalizedPriceRequest { productCode:PRD_000146, priceSchemeKey:PRF_CLR_ACRYL(echo),
  dimensions:[{side:default, cutW,cutH,workW,workH}](등록 siz_cd 또는 nonspec 직접입력),
  materials{default:mat_cd}(MAT_000042/043), quantity,
  selectedFinishes:[{groupId:인쇄, valueId:print_opt_cd}],  // 색상 대용
  addons:[{tmplCd:TMPL-000018, qty}] }  // 볼체인
   │ 어댑터 createHuniAdapter — siz_cd/nonspec→siz_width/height 환원 + 필수공정(PROC_000002) 자동주입 + priceSchemeKey echo
   ▼
evaluate_price({prd_cd:PRD_000146}, {mat_cd, siz_width, siz_height, ...}, qty)  [pricing.py:394]
   │ 내부: COMP_ACRYL_CLEAR3T 면적격자 매칭(unit_price/장) × qty + DSC_ACR_QTY 구간할인 자동적용
   ▼
NormalizedPriceBreakdown { ok, finalPrice, vat, shipping, lines[{본체면적단가, 할인}] }
   + addon(볼체인 template_price 1000×수량) ← 어댑터/BFF 합산(서버 addon 가산 또는 위젯 정액)
```
구간할인은 서버가 DSC_ACR_QTY로 내부 적용 — **위젯 무지**(Slider는 결과 표시만). addon(볼체인)은 template_prices 정액(1000원) → 어댑터가 selectedOptions에 운반 + 가격 합산은 BFF/서버 책임.

### 4.3 PRICE≠0 골든 (스냅샷 결정론 도출 · 라이브 단가행 verbatim)

PRD_000146은 PRF_CLR_ACRYL → COMP_ACRYL_CLEAR3T(PRICE_TYPE.02·use_dims=[mat_cd,siz_width,siz_height,min_qty]) 바인딩. 단가행은 스냅샷 `t_prc_component_prices`에서 verbatim 추출(MAT_000043=3mm dflt). 면적단가=장당가 → × qty → DSC_ACR_QTY 구간율 적용:

| 케이스 | 사이즈(siz_cd) | mat | 장당단가(라이브 행) | qty | 할인밴드 | 산식 | final_price |
|--------|---------------|-----|--------------------:|----:|---------|------|------------:|
| A 소형 단건 | 20x30 (SIZ_000329) | MAT_000043 | 2,700 (#5270) | 1 | 1-49=0% | 2700×1×1.0 | **2,700** |
| B 소형 100개 | 20x30 (SIZ_000329) | MAT_000043 | 2,700 | 100 | 100-299=20% | 2700×100×0.8 | **216,000** |
| C 30x40 단건 | 30x40 (SIZ_000331) | MAT_000043 | 3,400 (#5272) | 1 | 1-49=0% | 3400×1×1.0 | **3,400** |
| D 30x40 500개 | 30x40 (SIZ_000331) | MAT_000043 | 3,400 | 500 | 500-999=40% | 3400×500×0.6 | **1,020,000** |
| E +볼체인 addon | 30x40·MAT_000043·볼체인×1 | — | 3,400 | 100 | 100-299=20% | 3400×100×0.8 + 1000 | **272,000 + 1,000 = 273,000** |

> ★도출 출처: 단가행은 라이브 스냅샷 verbatim(#row id 명시). 구간율은 DSC_ACR_QTY verbatim. 곱셈·할인 결합은 pricing.py:19(`총액÷구간 환산 후 ×수량`)·DSC_TYPE.01(정률) 알고리즘에 따른 **결정론 산출**(POST 미실행 — 읽기전용 원칙). 1원 단위 라운딩·VAT 별산은 서버 책임. 실 시뮬레이터 직호출(인증세션 CSRF 필요)은 **hw-qa 검증단계로 이관**(거짓 수치 날조 금지·동형 알고리즘이므로 골든 신뢰 가능). MAT_000042(1.5mm) 선택 시 단가≈×0.8(예: 30x40=2,720).

✅ **PRICE≠0 게이트 통과**(전 케이스 >0).

### 4.4 ★알려진 (C) 결함 — sparse grid 홀 (저청구/0원 위험)

- **35% 홀**([[bind-only-GATE]]·remediation): COMP_ACRYL_CLEAR3T 면적격자는 PRD_000146 등록/직접입력 차원의 약 **65%만 단가행 보유**. nonspec 직접입력으로 단가행 없는 (W,H) 조합 선택 시 `no_tier_row` → **PRICE=0(0원 견적)**. 이는 라이브 기존 리스크(신규 회귀 아님)이나 **위젯에서 손님이 0원 주문 가능** — 어댑터는 `priceUnavailableReason="no_tier_row"`를 채워 위젯에 "견적 불가" 표시(0원 주문 차단). **격자 충전 교정=§7/§26 인간 승인**(어댑터/계약 무관).
- **addon 가격 경로 미확정**: 볼체인 등 template_prices는 정액이나, evaluate_price가 addon을 합산하는지/위젯·BFF가 별도 합산하는지 **경로 미정**(§24 Shopby 카트 동적가 주입과 연계). 현재는 위젯이 template_price를 라인아이템으로 표시·서버 최종합산 권위.

---

## 5. 주문 페이로드 예시 (NormalizedCartHandoff + CTA 분기)

PRD_000146: file_upload_yn=Y·editor_yn=N → CTA는 **PDF 업로드 단독**. ★디자인 폼은 "에디터로 디자인하기" primary 버튼 노출(JSX:133) → DB(editor_yn=N) **불일치** → 위젯은 DB 권위(에디터 버튼 숨김/비활성) 또는 editor_yn 교정(C).

**완성 선택 상태(예):** 30x40(SIZ_000331) · 투명3mm(MAT_000043) · 배면양면 · 볼체인×1 · qty 100
```jsonc
// NormalizedCartHandoff
{
  "productCode": "PRD_000146",
  "selectedOptions": [
    { "groupId": "size",     "valueId": "SIZ_000331" },
    { "groupId": "material", "valueId": "MAT_000043" },
    { "groupId": "print",    "valueId": "POPT_000004" },   // 배면양면(색상 대용)
    { "groupId": "addon",    "valueId": "TMPL-000018", "qty": 1 }  // 볼체인 1000원
  ],
  "quantity": 100,
  "priceSnapshot": { "finalPrice": 273000, "vat": 27300, "shipping": 0 },  // 본체 272,000 + 볼체인 1,000
  "artifacts": [
    { "side": "default", "kind": "pdf",
      "storedFileName": "stored_xxxx.pdf", "originalFileName": "keyring.pdf" }
  ]
}
// CTA 분기: editors={koi:false,rp:false,pdf:true} → cta.pdfUpload=true·designEditor=false(디자인 폼 에디터 버튼은 DB 불일치·(C))
```
- **에디터/PDF 분기**: editor_yn=N → designEditor=false / file_upload_yn=Y → pdfUpload=true → `NormalizedArtifact{kind:'pdf'}`.
- **addon 운반**: 볼체인=addon 라인(tmplCd round-trip). 가격합산 권위=서버/BFF(§4.4).
- **커머스 바인딩**: vat/shipping 산정·presigned URL·실 카트 전송은 **§24 Shopby UNDECIDED 경계**. 위젯은 NormalizedCartHandoff까지 조립 후 BFF 위임.

---

## 6. componentType / 갭 노트

### 6.1 componentType 사상 (goods 폼)
| componentType | goods 폼 사용처 | 데이터 출처 |
|---------------|----------------|-------------|
| `option-button` | 사이즈(8종)·인쇄(색상 대용)·가공(C) | sizes·print_options / (가공=C) |
| `select-box` | 볼체인 addon·볼체인 수량 | product_addons ⋈ templates / (수량=C GAP-PARAM) |
| `color-chip` | 옵션(색상 10칩) — **의미갭** | DB 색상축 부재(B/C·인쇄옵션 근접) |
| `area-input` | 직접입력(nonspec) | products.nonspec_*(20~100mm) |
| `counter-input` | 제작수량 | products qty (min1·incr1) |
| `summary` | 가격요약 + **구간할인 표시** | 어댑터 생성(evaluate_price + DSC_ACR_QTY) |
| `upload-cta` | PDF 업로드 | file_upload_yn=Y |
| `price-slider` | **DiscountSlider 후보 — 결론 §6.3** | DSC_ACR_QTY(읽기전용 표시) |
| `image-chip`/`mini`/`finish-button`/`page-counter-input`/`dimension-matrix-input` 등 | 미사용(goods) | — |

### 6.2 ★ⓐ Slider componentType 처리 결론 (price-slider 재사용 vs 신규)

**결론: 신규 componentType 불필요. `price-slider` 재사용도 불필요. 어댑터 흡수(A) — Slider는 입력축이 아니라 `summary`의 시각 표현.**

근거:
- 디자인 `DiscountSlider`(JSX:140~150)는 `index` state를 갖지만 **가격 계산에 입력으로 쓰이지 않는다**(가짜식은 상수 -25000). 실 구간할인은 **수량(qty)에 의해 서버가 DSC_ACR_QTY로 자동 결정** — Slider의 stops(1/10/50/100/500/1000+)는 qty 밴드의 **시각화**일 뿐 독립 선택축이 아니다.
- 즉 손님이 조작하는 입력은 **제작수량 `counter-input` 하나**이고, Slider는 "현재 수량이 어느 할인밴드인지 + 할인적용단가"를 보여주는 **읽기전용 인디케이터**. → 정규화 계약의 `summary`(또는 counter-input에 종속된 할인밴드 표시 메타)로 흡수.
- 따라서 ⓐ 계약 14종에 **count-slider 신규 추가 불필요**(B 0건). `price-slider`(가격 구간 선택용)와도 의미가 달라 재사용 부적합. 외형(슬라이더 트랙·stops)은 hw-design-fidelity가 `summary` 영역의 시각 표현으로 렌더(어댑터가 evaluate_price 응답의 할인율/단가를 주입).
- (참고) stationery·arrylic의 Slider(조각수·볼체인 길이)는 **입력 의미가 다를 수 있음**(실 선택축) — 해당 클래스 파일럿에서 재판정. goods의 Slider는 할인표시 전용으로 확정.

### 6.3 ⓑ 추가상품(볼체인) 경로 결론

**경로: `t_prd_product_addons` ⋈ `t_prd_templates` ⋈ `t_prd_template_prices` (W-ADDON 템플릿 경로) — print 명세 §27 봉투 addon과 동형.**
- PRD_000146 addons 4행 → 각 tmpl_cd(TMPL-000015~018) → templates(은색고리/금색고리/은색구슬줄/볼체인) → template_prices(1100/1200/300/**1000**). 디자인 "볼체인 +1,000원"과 **단가 verbatim 일치**.
- 정규화: addon 그룹(componentType=`select-box`·multiple=false·required=false)·OptionValue.id=tmpl_cd·label=tmpl_nm·가격=template_price(라인 표시). 선택 시 볼체인 수량(`counter-input`) 노출(VisibilityRule·A).
- **갭(C):** ⓐ template del_yn=Y(4템플릿 모두 최근 소프트삭제 — 복원/재등록 필요·§7) ⓑ addon 수량 차원 미적재(GAP-PARAM) ⓒ 디자인의 볼체인 "색상 4종"은 DB에 없음(DB는 고리종류 분기) ⓓ addon 가격이 evaluate_price 합산인지 위젯/BFF 합산인지 경로 미정.

### 6.4 갭 (A)/(B)/(C) 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (10)**: A1 면적격자 차원 환원(siz_cd/nonspec→width/height)·A2 필수공정 자동주입(PROC_000002)·A3 판형 비노출(비종이류)·A4 hidden-essential·A5 unit 라벨(개)·A6 nonspec→area-input·A7 sides(default)·A8 addon 토글→수량 visible·A9 구간할인 summary 표시(Slider 입력 아님)·A10 PRICE=0(no_tier_row) 진단 + sel_typ→multiple/mand_yn→required 직매핑.
- **(B) 계약 변경 필요 (0, 단 색상칩 1 후보)**: 위젯 계약(color-chip·VisibilityRule·InputSpec·OptionGroup.multiple·addon)이 goods 폼을 OPTIONAL 슬롯으로 수용 → **계약 변경 0건(목표 달성)**. 잠재 B 후보 = 색상칩(디자인 색상 의미 ↔ DB 인쇄옵션) 1건(현재는 인쇄옵션을 option-button으로 흡수 → A 우선).
- **(C) DB 작성·교정 — §7/§26 인간 승인 (7)**:
  - C-볼체인 템플릿 복원: TMPL-000015~018 del_yn=Y → 복원/재등록.
  - C-addon 수량: template 수량 차원(GAP-PARAM) 적재.
  - C-색상축: 굿즈 색상 옵션그룹 적재 또는 인쇄옵션 매핑 확정(아크릴은 투명소재라 색상 의미 재정의).
  - C-가공(라벨부착): 라벨부착 옵션그룹 적재.
  - C-sparse grid 홀: COMP_ACRYL_CLEAR3T 면적격자 35% 미적재 셀 충전(0원 견적 방지·§26).
  - C-editor_yn: 디자인 에디터 버튼 vs DB editor_yn=N 불일치(에디터 제공 시 Y 교정·아니면 위젯 숨김).
  - C-addon 가격합산 경로: evaluate_price addon 합산 여부 확정(§24 연계).
  - (디자인≠DB 사이즈3/수량min10·할인6%off 더미는 DB 권위 — 교정 불필요·위젯 DB값 렌더)

---

## 7. 주문가능 4조건 충족 여부 (PRD_000146 현재)

`widget-forms-approach.md §3` 주문가능 정의 = ⓐ옵션 라이브구동 + ⓑ제약6종 데이터강제 + ⓒPRICE≠0 + ⓓ유효 페이로드.

| 조건 | 현재 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | **부분** | 사이즈(8종)·인쇄·제작수량·볼체인 addon = 라이브 구동 ✅ / 색상축·가공(라벨부착) = **CPQ 미적재(C)** ❌ · 볼체인 템플릿 del_yn=Y(복원 필요) ⚠ |
| ⓑ 제약 6종 데이터 강제 | **대체로 충족** | ⑥필수·④size/area·②quantity·③addon토글 강제 ✅(갭 2: 색상·가공 C) — C2는 제약 적어 print(C4·갭11)보다 양호 |
| ⓒ PRICE≠0 | **충족(주의)** | golden 2700/216000/3400/1020000/273000 >0 ✅ / 단 nonspec 직접입력 35% 홀 → no_tier_row PRICE=0 위험(어댑터 진단·§26 격자충전 C) ⚠ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립 가능 ✅ / addon 라인 포함 · 커머스 바인딩 §24 UNDECIDED · PDF CTA only(에디터 불일치 C) |

**판정: 부분 주문가능(PARTIAL·C4 print보다 양호).** 라이브 적재분(사이즈·인쇄·수량·볼체인 addon·구간할인)만으로 **클린 아크릴키링 주문 가능(PRICE≠0)** — 자재오염 제거·할인밴드·addon 단가까지 verbatim 정합. 잔여 병목은 ⓐ 색상축·가공 옵션 미적재 ⓑ 볼체인 템플릿 복원 ⓒ sparse grid 35% 홀(0원 방지) — **전부 (C) DB 작성/교정 7건**(위젯/계약/어댑터 준비 완료·B 0건).

**다음 권고:** ① §7 dbmap에 C 7건(볼체인 템플릿 복원·addon 수량·색상축·라벨부착·격자홀 충전·editor_yn·addon합산경로) 적재명세 인계 → ② §26 COMP_ACRYL_CLEAR3T 격자 충전(0원 방지) → ③ 적재 후 어댑터 NormalizedProduct 재조립 + 실 시뮬레이터 골든 hw-qa 검증 → ④ hw-builder createHuniAdapter 구현. 코드 구현은 본 명세 승인 후.

---

## 부록: 동형 전파 노트

PRD_000146(아크릴키링·C2 대표) 매핑 규칙은 같은 클래스 아크릴 굿즈에 전파:
- **addon 보유 동형**: 147 마그넷(자석부착 TMPL-000014)·148 뱃지(원형핀/1구자석)·149 집게·150 스마트톡(화이트/투명바디)·152·154 — addon 템플릿 경로·구간할인(DSC_ACR_QTY) 공통. 단 147/148/150/151은 nonspec(직접입력)·일부 mat 오염 잔존 여부 재확인.
- **PRF_CLR_ACRYL 공유 15건**(bind-only): 면적격자·sparse hole 동형(35% 공통 갭). 골든 단가행만 상품별 재확인.
- **fixed-size 굿즈(파우치/키링류)**: 옵션그룹·addon 0행 → C2가 아니라 **C1(고정가-단순)** 또는 반제품/기성 — goods C2 동형 아님. 별도 분류(isomorphism-classes.md 갱신 권고).
- **Slider=할인표시 흡수 규칙**은 구간할인 보유 전 상품군 공통(어댑터 summary 표시·입력축 아님).
