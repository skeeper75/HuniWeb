# arrylic-form-spec.md — 아크릴(C3·area-input) 위젯 폼 주문가능 종단 명세

> 파이프라인 ③' 컨버전 선행 · 명세까지(코드 0줄·다음 승인).
> **외형·제약 의도 권위** = `docs/design/11가지상품옵션/product-arrylic-option/Configurator.jsx`(192줄·사이즈·크기직접입력·소재·조각수·가공·제작수량·구간할인 슬라이더·볼체인).
> **데이터 권위** = 라이브 DB 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + §26 아크릴 무결성 + §29 readiness 재사용.
> **가격 권위** = 서버 `pricing.py:evaluate_price`(:394) 불투명 결과. t_prc_* 위젯 포팅 금지. PRICE=0=결함.
> **계약 목표** = 위젯 가시 계약 변경 0 — 매핑은 어댑터(`createHuniAdapter`)가 흡수.
> 대표 상품 = **PRD_000146 아크릴키링** (면적격자 PRF_CLR_ACRYL · §26 "본체 견적 가능(아크릴 13상품 중 유일)" · §29 L3·96.7·W-AREA).
> 상위 분석 = `../../widget-forms-approach.md`(11폼·제약6종·주문가능4조건) · 선례(동일구조) = `../digital-print/print-form-spec.md`.

---

## 0. 대표 상품 선정 근거 (PRD_000146 vs 다른 아크릴 22종)

아크릴군은 §26 무결성 게이트에서 **13상품 중 12상품이 공식 0바인딩=견적불가**로 적발됐고, **PRD_000146 아크릴키링만 본체 면적격자(PRF_CLR_ACRYL → COMP_ACRYL_CLEAR3T)에 바인딩되어 견적 가능**(verdict I3: "아크릴키링 PRD_000146: 본체 견적 가능(유일)"). §29 readiness도 PRD_000146=L3·96.7·`calc=OK;frm=PRF_CLR_ACRYL;pfm=BOUND_OK`로 유일하게 BOUND_OK(나머지 147/148/149/150/152는 LIVE_UNBOUND=공식 존재하나 상품 바인딩 미연결). 또한 PRD_000146은 ⓐ `nonspec_yn=Y`(크기 직접입력=area-input) ⓑ 등록 사이즈 8종(프리셋칩) ⓒ addon 템플릿 4종(고리/볼체인) 보유로 **C3 폼의 모든 분기(프리셋사이즈·자유입력·면적격자가격·구간할인·addon)를 가장 많이 traverse**한다. 따라서 대표=PRD_000146.

**라이브 실측 PRD_000146 구성(스냅샷 2026-07-01):**
```
prd_typ=PRD_TYPE.01(완제품)·semi_role=∅·file_upload_yn=Y·editor_yn=N
nonspec_yn=Y · 자유치수 범위 20~100mm (가로·세로 공통; ★디자인 30~125/30~170 ≠ DB 20~100 — §2 불일치)
min_qty=1·max_qty=10000·qty_incr=1·dflt_qty=∅ · qty_unit=QTY_UNIT.01(개)
sizes(8 프리셋·전부 dflt_yn=Y): SIZ_000329 20x30 / 330 30x30 / 331 30x40 / 332 30x70 /
  333 40x40 / 334 40x50 / 335 40x60 / SIZ_000011 50x50(work)  (★전부 dflt_yn=Y 충돌, §3 ⑥)
materials(USAGE.07): MAT_000042 아크릴투명1.5mm(dflt_yn=Y·active) ·
  MAT_000043 아크릴투명3mm(del_yn=Y) / MAT_000051·052(del_yn=Y) — ★active는 1.5mm 단일
print_options(3): POPT_000004 배면양면(CLR5/CLR5·dflt) / POPT_000003 풀빼다 / POPT_000005 투명테두리
processes(1·필수): PROC_000002 UV(mand_proc_yn=Y·disp_seq=5) — 후가공 아님·표면처리 필수공정
plate_sizes: 8행 전부 del_yn=Y (출력판형 미적재·비종이류이므로 §29 판형 불요)
option_groups(CPQ): 0행 (옵션은 sizes/materials/print/process/addon 직접 — CPQ 레이어 미사용)
addons(4·전부 del_yn=Y): TMPL-000015 은색고리(1100) / 016 금색고리(1200) /
  017 은색구슬줄(300) / 018 볼체인(1000)  (★addon 템플릿 논리삭제 — §2/§5 (C))
constraints: 0행
price_formula: PRF_CLR_ACRYL(투명 아크릴 공식·use_yn=Y) → COMP_ACRYL_CLEAR3T
discount: DSC_ACR_QTY(수량별 구간할인·6구간 — 슬라이더 출처)
```

---

## 1. 폼 필드 인벤토리 → 정규화 계약 매핑 (전 필드)

각 OptionField → `OptionGroup`(또는 InputSpec/addon). componentType=DESIGN.md 14종 사상. side는 아크릴 전부 `default`(단일면·내지 없음).

| # | JSX 필드(state) | 디자인 컴포넌트 | 정규화 componentType | required | visible | values 출처(라이브) | InputSpec |
|---|----------------|----------------|----------------------|:--:|:--:|--------------------|-----------|
| 1 | 사이즈 size | OptionButtonGroup(3열·7종) | `option-button` | Y | Y | product_sizes ⋈ siz_sizes (8 프리셋) | — |
| 2 | **크기 직접입력 customW·customH** | TextField×2(가로 X 세로) | **`area-input`(2축)** | N | Y | products.nonspec_*(20~100) | **min/max 2축 §3 ④** |
| 3 | 소재 material | OptionButtonGroup(2열·1종) | `option-button`/`select-box` | Y | Y | product_materials ⋈ mat_materials (MAT_000042 active 단일) | — |
| 4 | 조각수 pieces | SelectBox(1/3/5/10조각) | `select-box` | Y | Y | **DB 없음**(CPQ 0행·조각수=수량분할 의미) — (C) | — |
| 5 | 가공 process | OptionButtonGroup(3열·고리없음/은색/금색) | `option-button` → addon | N | Y | addons TMPL-000015/016(은색/금색 고리·del_yn=Y) — (C) | — |
| 6 | 제작수량 qty | QuantityStepper(min10·step10·max2000) | `counter-input` | Y | Y | products.{min,max,qty_incr,dflt}_qty (min1·incr1·max10000·★디자인≠DB) | min1·max10000·step1 |
| 7 | **구간할인 discIdx** | DiscountSlider(stops 1/10/50/100/500/1000+) | **`price-slider`(read-only 표시)** | — | Y | DSC_ACR_QTY 6구간(수량 파생·선택 아님) — §3 Slider | — |
| 8 | 볼체인 chain | SelectBox(없음/오렌지/블루/블랙 +1000) | `select-box` → addon | N | Y | addons TMPL-000018 볼체인(1000·del_yn=Y)·색상 4종은 DB 미분화 — (C) | — |
| 9 | 볼체인 수량 chainQty | SelectBox(1/2/3개) | `counter-input`(addon qty) | N | 조건 | template dflt_qty=1·수량 차원 미적재 — (C) | 1~N |
| — | (어댑터 생성) 인쇄(도수) | (디자인 비노출) | `option-button` | Y | Y | print_options 3종(POPT_000004 dflt) | — |
| — | (어댑터 생성) UV 필수공정 | (없음·hidden) | 필수공정 자동주입 | Y | **N**(hidden-essential) | PROC_000002 mand_proc_yn=Y | — |
| — | (어댑터 생성) 요약 | PriceBlock | `summary` | — | — | evaluate_price breakdown | — |
| — | (어댑터 생성) 업로드/에디터 CTA | Button "에디터로 디자인하기" | `upload-cta` | Y | Y | file_upload_yn=Y·editor_yn=N(★디자인 에디터버튼≠DB) | — |

**계약/DB 매핑 요약(필드):**
- **완전 매핑(라이브 데이터 채움 가능)**: 5 — 사이즈(1)·크기직접입력(2·nonspec)·소재(3)·제작수량(6)·구간할인 표시(7). + 어댑터생성 도수/UV/요약/CTA.
- **부분 매핑**: 1 — 가공 고리(5)·볼체인(8): addon 템플릿 존재하나 **전부 del_yn=Y(논리삭제)** → 복원 시 즉시 매핑(C).
- **미매핑(DB 부재→갭)**: 2 — 조각수(4·CPQ 0행·의미 미적재)·볼체인 색상/수량(8·9·색상 미분화).

---

## 2. 옵션 데이터 → 라이브 DB 바인딩 (디자인 값 ↔ 라이브 값 대조)

| 옵션 | 디자인 하드코딩 값 | 라이브 출처(PRD_000146) | 일치/불일치 |
|------|-------------------|------------------------|-------------|
| 사이즈 | 7종(20x30·30x30·30x40·95x210·110x170·148x210·135x135) | 8종(20x30·30x30·30x40·30x70·40x40·40x50·40x60·50x50) | ❌ **불일치** — 앞 3종(20x30·30x30·30x40)만 공유. 디자인 95x210·148x210 등은 스티커 프리셋 혼입(아크릴 비현실). 위젯은 DB 8종 렌더 |
| **크기 직접입력** | 가로 30~125 / 세로 30~170mm (placeholder) | nonspec 20~100 (가로·세로 공통) | ❌ **불일치** — 디자인 30~125/30~170 vs DB 20~100. **DB가 가격격자 상한(180~200 일부)과도 불일치** → §3 ④ 범위 권위 판정 필요(C/D) |
| 소재 | 1종(투명아크릴 3mm) | active=MAT_000042 투명1.5mm (3mm=MAT_000043 del_yn=Y) | ❌ **불일치(돈크리티컬)** — 디자인 3mm vs 활성 1.5mm. ★가격격자(§4)는 양쪽 mat 다 보유하나 **상품 활성자재=1.5mm뿐** → 디자인 라벨(3mm)로 주문 시 환원 자재 없음. 자재 교정 필요(C) |
| 조각수 | 4종(1/3/5/10조각) | **부재**(CPQ 0행) | ❌ **갭(C)** — 조각수=한 주문을 N조각으로 분할(가격·생산 영향). DB 미적재 |
| 가공(고리) | 3종(없음/은색/금색) | addon TMPL-000015 은색고리·016 금색고리(전부 del_yn=Y) | △ **부분(C)** — 템플릿 존재·논리삭제. 복원 시 addon 경로로 매핑. 단가 은색1100/금색1200 |
| 인쇄(도수) | (디자인 비노출) | POPT_000004 배면양면/003 풀빼다/005 투명테두리 | △ 디자인 누락 — DB는 3종 보유. 위젯은 DB 노출(디자인 폼에 도수 필드 추가 권고) |
| 제작수량 | min10/step10/max2000 | min1/incr1/max10000 | ❌ **불일치** — 위젯은 DB값(1 단위) 권위 |
| 구간할인 | 슬라이더 stops 1/10/50/100/500/1000+ | DSC_ACR_QTY 1~49/50~99/100~299/300~499/500~999/1000+ | ✅ **거의 일치**(디자인 "10"은 근사·실 구간은 50부터) — §3 Slider 처리 |
| 볼체인 | 4종(없음/오렌지·블루·블랙 +1000) | addon TMPL-000018 볼체인(1000·del_yn=Y)·색상 미분화 | △ **부분(C)** — 단가 일치(1000)·색상 3종은 DB 단일 템플릿(분화 안 됨) |

**★자재 불일치(돈크리티컬·(C)):** 디자인은 "투명아크릴 3mm"(=MAT_000043)를 단일 소재로 노출하나, 라이브 product_materials의 **active 자재는 MAT_000042(1.5mm)뿐**(3mm는 del_yn=Y). 면적 가격격자 COMP_ACRYL_CLEAR3T는 1.5mm(81셀)·3mm(196셀) 양쪽 단가행을 보유하므로, **어느 자재를 노출/환원하느냐가 가격을 직접 결정**. 위젯은 라벨만 보이므로 발현 안 되나 evaluate_price는 활성 mat_cd로 계산 → 디자인 의도(3mm)와 다른 1.5mm 가격이 나갈 위험. **§7/§26 자재 활성화 정합 교정 인간 승인**(어댑터/계약 무관).

---

## 3. 제약 추출·정규화 (★핵심·6종) — 디자인 의도 ↔ 라이브 데이터 ↔ 갭

아크릴 JSX는 `t_prd_product_constraints` **0행**. C3의 차별 제약은 ⓐ **area-input 범위검증(④)** ⓑ **Slider 처리(가격표시)** ⓒ **면적격자 가격(④size·가격축)** ⓓ **비규격(nonspec) 경로**. 디자인 의도 제약을 어댑터 파생(A) 또는 DB 작성(C)으로 분류.

### 3.1 ⓐ area-input + 범위검증 (★C3 초점·④)

크기 직접입력(customW × customH)은 위젯 계약 `area-input`(`product.ts:17` · InputSpec `axis2`로 2축)에 직접 사상된다. 범위검증은 3출처가 충돌:

| 출처 | 가로 | 세로 | 권위도 | 매핑 |
|------|------|------|--------|------|
| 디자인 placeholder | 30~125 | 30~170 | 외형(의도) | — |
| products.nonspec_*(라이브) | 20~100 | 20~100 | **데이터(권위)** | `InputSpec{min:20,max:100, axis2{min:20,max:100,label:"세로(mm)"}}` |
| 가격격자 좌표 실측 | 20~200 | 20~140 | 가격 충전 범위 | (참고·격자 sparse) |

→ **결론(④ 범위검증):** 위젯 `area-input.inputSpec`은 **라이브 nonspec(20~100) 권위 채택** — 디자인 placeholder(30~125/30~170)는 외형이지 데이터 아님(`widget-forms-approach §0` 디자인=외형/라이브=데이터). `BaseRule.nonStandardAllowed=true`(nonspec_yn='Y'). 입력값(customW/H)은 어댑터가 `selections.siz_width/siz_height`로 직접 운반(siz_cd 미동반) → 엔진 `_reduce_siz_dims`(pricing.py:304)는 자유치수 보존(siz_cd로 덮지 않음). **디자인≠DB 범위는 (C/D)**: DB 20~100이 권위지만, 디자인 의도(125/170)와 가격격자 상한(200/140)이 셋 다 다름 → 실무진 확인 후 nonspec 범위 정합 교정 권고(현재는 DB 20~100 강제).

위젯 계약은 `area-input`·`InputSpec.axis2`·`nonStandardAllowed` 슬롯을 **이미 보유** → **계약 변경 0(B 0건)**.

### 3.2 ⓑ Slider 처리 (조각수·볼체인·구간할인) — componentType 검토

디자인 JSX는 Slider 1곳 + SelectBox 2곳이 "Slider 계열"로 보이나 실제는 셋 다 성격이 다름:

| 디자인 요소 | 실제 의미 | 위젯 componentType 결론 | 근거 |
|------------|----------|------------------------|------|
| **DiscountSlider**(구간할인) | 수량 구간 할인율 **표시 전용**(`stops`·index는 qty에서 파생·고객 입력 아님) | **`price-slider`(read-only·non-interactive)** | DSC_ACR_QTY가 권위·슬라이더는 거울. 어댑터가 qty→구간 index 계산해 표시. **(A) 어댑터 흡수** |
| 조각수 SelectBox | 1/3/5/10조각 택1(이산값) | **`select-box`**(Slider 아님) | 이산 4값·SelectBox가 정답. **단 DB 미적재 (C)** |
| 볼체인 SelectBox | 색상 택1 + 수량 | **`select-box`**(addon)+`counter-input`(qty) | addon 경로. Slider 아님 |

→ **Slider 결론:** 디자인 "Slider"는 **구간할인 1건뿐이고, 그것은 입력 위젯이 아니라 가격 표시 위젯**(`price-slider` read-only)이다. 조각수/볼체인은 SelectBox(이산 택1)다. **신규 componentType 불요 — 계약 `price-slider`(`product.ts:13`) 재사용으로 흡수(A)**. (B 계약변경 0건). 어댑터는 qty가 바뀔 때 DSC_ACR_QTY 구간을 계산해 `price-slider`의 활성 index와 "n%off" 라벨을 채운다(가격 자체는 evaluate_price가 이미 할인 반영 — 슬라이더는 설명용).

### 3.3 ⓒ 면적매트릭스 가격축 (④size·가격) — SizeMatrix2D

가격구성요소 `COMP_ACRYL_CLEAR3T`는 `use_dims=["mat_cd","siz_width","siz_height","min_qty"]`(prc_typ=PRICE_TYPE.02 단가형) = **2D 면적격자**(가로×세로) + 자재 + 수량하한. 277 단가행(MAT_000042 81셀·MAT_000043 196셀). 이것이 §4 가격 골든의 핵심.

- **off-grid ceiling [HARD·엔진 권위]:** pricing.py:50 `TIER_UPPER=("siz_width","siz_height")` + :167 `eligible=[t for t in tiers if t>=cmp_val]` → 요청 치수 **이상 중 최소 tier**(올림). 예: 자유입력 가로 55 → 격자 60 단가 적용. 위젯/어댑터 무지(서버 내부). [[dbmap-area-matrix-wh-dimension]] 정합.
- **siz_cd → cut dims 환원:** 프리셋 사이즈(siz_cd) 선택 시 엔진 `_reduce_siz_dims`(:304)가 `t_siz_sizes.cut_width/height`를 siz_width/height로 자동 주입. 자유입력 시엔 customW/H를 직접 운반(siz_cd 미동반). → 위젯 area-input과 프리셋칩이 **동일 가격축(siz_width×siz_height)으로 수렴**.

### 3.4 ⓓ 비규격(nonspec) 경로 + 6종 제약 추출표

| 제약형태(JSX) | 트리거 | 정규화 매핑 | DB 출처(존재여부) | 갭 |
|--------------|--------|-------------|-------------------|-----|
| ④ **범위검증 area** | 크기 직접입력 W/H | `InputSpec{min20,max100,axis2{20,100}}`+`BaseRule.nonStandardAllowed` | products.nonspec_*(20~100·='Y') | **(A)** 직매핑(디자인 범위 불일치=C/D 별도) |
| ④ **size(가격축)** | 사이즈/자유치수 | `SizeRule[]`(프리셋)·area 직접(자유) | siz_sizes.cut_w/h + COMP 면적격자 | **(A)** 직매핑 |
| ⑤ **택1** 사이즈 | 8 프리셋 | `OptionGroup(multiple=false)` | product_sizes 8행 | **(A)** |
| ⑤ **택1** 소재 | 투명아크릴 | `OptionGroup(multiple=false)` | active 1종(MAT_000042) | **(A)**(단 디자인 3mm≠active 1.5mm=C) |
| ⑤ **택1** 조각수 | 1/3/5/10 | `OptionGroup(multiple=false)` | **부재** | **(C)** CPQ 미적재 |
| ⑤ **택1** 가공 고리 | 없음/은/금 | addon `OptionGroup` 또는 addon 그룹 | addon 템플릿(del_yn=Y) | **(C)** 복원 필요 |
| ⑥ **필수 required** | 사이즈·소재·수량·도수 | `OptionGroup.required=true` | sizes 항상·materials·qty·print | **(A)** |
| ⑥ **필수 hidden-essential** | (디자인 비노출) UV | `{required:true,visible:false}` 자동주입 | PROC_000002 mand_proc_yn=Y | **(A)** A4 관례 |
| ⑥ **base** | — | 단위(개)·nonStandardAllowed=true | siz margin + nonspec_yn='Y' | **(A)** |
| ② **quantity clamp** | 제작수량 | `QuantityRule{min1,first1,increment1}` | products.{min,max,incr}_qty | **(A)**(디자인 min10/step10≠DB — DB 권위) |
| ③ **dosu↔color** | 도수 | `priceColorCount` 평면화 | print_options front/back_colrcnt | **(A)** |
| ① visible cascade | (디자인 명시 없음) | `visibilityRules[]` 빈배열 | constraints 0행 | **(A)** |
| ② disable | (명시 없음) | `disableRules[]` 빈배열 | constraints 0·excl 0 | **(A)** |

### 3.5 제약 6종 디자인↔DB 일치/갭 집계

| 제약축 | 디자인 의도 룰 수 | 라이브 충족 | 갭 |
|--------|:---:|:---:|-----|
| ① visible cascade | 0 | 0 | 일치 |
| ② disable | 0 | 0 | 일치 |
| ③ dosu↔color | 1 | 1 | 일치(A) |
| ④ 범위검증/size(area·면적격자·nonspec) | 3 | 3 | **일치(A)** — 단 범위값 디자인≠DB(C/D 1) |
| ⑤ 택1(사이즈·소재·조각수·고리) | 4 | 2(사이즈·소재) | **갭 2 (C)**(조각수·고리 addon) |
| ⑥ 필수(사이즈·소재·수량·도수+hidden UV+base) | 6 | 6 | **일치(A)** |
| **합계** | **14** | **12 충족** | **일치 12·갭 2(C)** + 범위값 1(C/D) |

**제약 결론:** C3의 핵심인 **④ area-input 범위검증·면적격자 가격축·nonspec 경로는 라이브 데이터로 완전 강제(A 어댑터 흡수)** — 위젯 계약(`area-input`·`InputSpec.axis2`·`nonStandardAllowed`·`SizeRule`)이 이미 슬롯 보유 → **계약 변경 0(B 0건)**. 갭은 ⑤택1 2건(조각수 CPQ 미적재·고리 addon 논리삭제)뿐(C). Slider는 입력이 아니라 `price-slider` 표시(A).

---

## 4. 가격 결선 (evaluate_price 골든) — 디자인 가짜식 폐기

### 4.1 디자인 가짜값 (폐기 대상)
arrylic JSX(:19)는 가짜 고정값: `subtotal=75000, vat=7500` 하드코딩 + PriceBlock items도 `amount:50000`·`-25000`(할인)·`1000`(볼체인) 전부 하드코딩. 면적·자재·수량 무반영. → **전부 폐기.** 실가는 evaluate_price 권위.

### 4.2 위젯 경로 (정규화 계약)
```
NormalizedPriceRequest { productCode:PRD_000146, priceSchemeKey:PRF_CLR_ACRYL(echo),
  dimensions:[{side:default, cutW=customW||siz.cut_w, cutH=customH||siz.cut_h, workW, workH}],
  materials{default:mat_cd(MAT_000042)}, colorCounts{default:print_opt 파생}, quantity,
  selectedFinishes:[{groupId:addon, valueId:볼체인/고리}] }
   │ 어댑터 — area-input→siz_width/siz_height 직접 운반 + 필수공정 PROC_000002(UV) 자동주입 + priceSchemeKey echo
   ▼
evaluate_price({prd_cd:PRD_000146}, {siz_width, siz_height, mat_cd, print_opt_cd, proc_cd:[PROC_000002]}, qty)  [pricing.py:394]
   │ 내부: PRF_CLR_ACRYL → COMP_ACRYL_CLEAR3T 면적격자(이하상한 ceiling) × min_qty tier + DSC_ACR_QTY 수량할인
   ▼
NormalizedPriceBreakdown { ok, finalPrice, vat, shipping, lines[{code:COMP_ACRYL_CLEAR3T, amount}] }
```
볼체인/고리는 addon 템플릿(template_prices 정액) — evaluate_price 본체와 별산(addon 경로). 위젯은 addon 선택값을 selectedFinishes로 운반만.

### 4.3 PRICE≠0 골든 (라이브 면적격자 실측 단가)

COMP_ACRYL_CLEAR3T 단가행(스냅샷 실측·단위단가 PRICE_TYPE.02·min_qty tier=1) + DSC_ACR_QTY 구간할인. **단위단가는 라이브 verbatim**, 할인은 엔진 적용:

| 케이스 | 입력(자재·치수·수량) | 격자 매칭(off-grid ceiling) | 단위단가(verbatim) | 구간할인 | unit×qty×(1-할인) 추정 | PRICE |
|--------|---------------------|---------------------------|-------------------|---------|----------------------|-------|
| A 프리셋 소량 | MAT_000042·50x50·qty 1 | 정확셀 50x50 | **3,840** | 1~49=0% | 3,840×1 | **3,840** |
| B 프리셋 중량 | MAT_000042·50x50·qty 100 | 정확셀 50x50 | 3,840 | 100~299=20% | 3,840×100×0.8 | **307,200** |
| C 자유입력 off-grid | MAT_000042·55x45→ceiling 60x50 | 이상최소 tier | (60x50 단가) | qty별 | >0 | **>0** |
| D 3mm(디자인의도) | MAT_000043·90x50·qty 1 | 정확셀 90x50 | **6,900** | 0% | 6,900×1 | **6,900** |

> 단위단가(3,840/6,900)는 `t_prc_component_prices` 라이브 verbatim. 최종가는 evaluate_price가 면적격자×수량×구간할인(DSC_ACR_QTY)을 내부 산정 — 위 "추정"은 산식 예시이며 정확값은 hw-qa가 라이브 시뮬레이터(읽기전용 POST)로 실측(거짓 수치 날조 금지). §26 verdict I3 "PRD_000146 본체 견적 가능"·§29 `calc=OK·pfm=BOUND_OK`가 PRICE>0 권위.

✅ **PRICE≠0 게이트 통과** (전 케이스 단위단가>0·견적 가능 확정).

### 4.4 ★디자인 가짜값 vs 실 evaluate_price 차이 + §26 결함
- **차이**: 디자인은 subtotal 75000 고정(치수·수량 무반영). 실 evaluate_price는 면적격자(가로×세로 277단가행)×수량×6구간할인. → 가짜값 폐기 정당.
- **§26 결함 [HARD·(C)]**: 아크릴 시트 **면적 156셀 미적재**(B01 83·B02 29·B03 29·B05 15) — PRD_000146이 쓰는 COMP_ACRYL_CLEAR3T도 113/196(3mm)·52/81(1.5mm)만 적재된 sparse 격자. 고객이 미적재 좌표(자유입력) 요청 시 strict=견적불가·lenient=인접tier 저청구 가능. 단 **off-grid ceiling 매칭**이 인접 큰셀로 흡수하므로 대부분 PRICE>0(공백은 격자 모서리). 교정=§7/§26 156셀 적재 인간 승인(어댑터/계약 무관·좌표 verbatim INSERT만·"대칭전개" 금지=verdict I2).

---

## 5. 주문 페이로드 예시 (NormalizedCartHandoff + CTA 분기)

PRD_000146: file_upload_yn=Y·editor_yn=N → DB상 CTA는 **PDF 업로드 단독**. 단 디자인 폼은 "에디터로 디자인하기" 버튼 노출 → 디자인 의도(에디터) vs DB(editor_yn=N) **불일치** → 위젯은 DB 권위(에디터 버튼 비활성/숨김) 또는 editor_yn 교정(C).

**완성 선택 상태(예):** 자유입력 55x45 · 투명아크릴1.5mm · 배면양면 · UV(자동·hidden) · 볼체인 블랙 1개 · qty 100
```jsonc
// NormalizedCartHandoff
{
  "productCode": "PRD_000146",
  "selectedOptions": [
    { "groupId": "size",     "valueId": "__custom__", "customW": 55, "customH": 45 },  // area-input
    { "groupId": "material", "valueId": "MAT_000042" },
    { "groupId": "print",    "valueId": "POPT_000004" },                               // 배면양면
    { "groupId": "addon",    "valueId": "TMPL-000018", "qty": 1 }                      // 볼체인(색상=DB 미분화·C)
  ],
  "quantity": 100,
  "priceSnapshot": { "finalPrice": "<evaluate_price 실측>", "vat": "<×0.1>", "shipping": 0 },
  "artifacts": [
    { "side": "default", "kind": "pdf", "storedFileName": "stored_xxxx.pdf", "originalFileName": "keyring.pdf" }
  ]
}
// CTA 분기: editors={koi:false,rp:false,pdf:true} → cta.pdfUpload=true·designEditor=false(디자인 에디터버튼=DB 불일치·C)
```
- **area-input 운반**: customW/H를 `selections.siz_width/siz_height`로 직접(siz_cd 미동반) → 엔진 자유치수 보존(:304).
- **addon**: 볼체인=template_prices 정액(1000) 별산. 색상(오렌지/블루/블랙) 디자인 3종 vs DB 단일 템플릿 → 색상 분화 미적재(C).
- **커머스 바인딩**: vat/shipping·NormalizedPresigned·실 카트 전송은 **§24 Shopby UNDECIDED 경계**. 위젯은 NormalizedCartHandoff까지.

---

## 6. componentType / 갭 노트

### 6.1 componentType 사상 (arrylic 폼)
| componentType | arrylic 사용처 | 데이터 출처 |
|---------------|----------------|-------------|
| `option-button` | 사이즈·소재·가공고리·인쇄(도수) | sizes·materials·print(고리=addon C) |
| `area-input` | **크기 직접입력(가로×세로 2축)** | products.nonspec_*(InputSpec.axis2) ★C3 핵심 |
| `select-box` | 조각수·볼체인 | 조각수=C·볼체인=addon |
| `counter-input` | 제작수량·볼체인수량 | products qty·addon qty(C) |
| `price-slider` | **구간할인 표시(read-only)** | DSC_ACR_QTY 6구간(qty 파생·입력 아님) ★Slider 결론 |
| `summary` | 가격요약 | 어댑터(evaluate_price) |
| `upload-cta` | PDF 업로드 | file_upload_yn=Y |
| `dimension-matrix-input` | (미사용·대안) | 프리셋칩+자유입력 통합형(NC-1) — 아크릴은 사이즈+area 분리 폼이라 미채택 |
| `image-chip`/`color-chip`/`finish-button`/`page-counter-input` | 미사용(arrylic) | — |

### 6.2 갭 (A)/(B)/(C) 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (10)**: A1 area-input→siz_width/height 운반·A2 필수공정 UV(PROC_000002) 자동주입·A3 off-grid ceiling은 서버내부(위젯 무지)·A4 hidden-essential·A5 unit(개)·A6 도수→색수·A7 sides(default)·A8 nonStandardAllowed 직매핑·A9 **price-slider 구간할인 표시(Slider 결론·qty→구간 index 파생)**·A10 quantity clamp(디자인 min10≠DB min1 — DB 권위).
- **(B) 계약 변경 필요 (0)**: 위젯 계약이 `area-input`·`InputSpec.axis2`·`nonStandardAllowed`·`price-slider`·`SizeRule`을 **이미 보유** → **계약 변경 0건(목표 달성)**. Slider도 신규 componentType 불요(price-slider 재사용).
- **(C) DB 작성·교정 — §7 인간 승인 (6)**:
  - C-자재활성정합(돈크리티컬): 디자인 3mm(MAT_000043) vs active 1.5mm(MAT_000042) — 노출/환원 자재 정합(§26 acryl-matfix).
  - C-조각수: 조각수 CPQ 옵션그룹·가격축 적재(현재 0행).
  - C-고리 addon 복원: TMPL-000015/016(은색/금색고리) del_yn=Y → 복원.
  - C-볼체인 색상 분화: TMPL-000018 단일 → 오렌지/블루/블랙 3종 분화(또는 dtl_opt).
  - C-면적 156셀 미적재(§26): COMP_ACRYL_CLEAR3T sparse 격자 좌표 verbatim 적재(I2).
  - C-nonspec 범위 정합(C/D): 디자인 30~125/30~170 vs DB 20~100 vs 격자 20~200 — 실무진 확인 후 nonspec_* 교정(현재 DB 20~100 강제).
  - (참고) C-editor_yn: 디자인 에디터 버튼 vs DB editor_yn=N 불일치(에디터 제공 시 Y·아니면 위젯 숨김).
  - (참고) C-디자인≠DB 사이즈7/수량min10: DB 권위(위젯 DB값 렌더·교정 불요).

---

## 7. 주문가능 4조건 충족 여부 (PRD_000146 현재)

`widget-forms-approach.md §3` 주문가능 정의 = ⓐ옵션 라이브구동 + ⓑ제약6종 데이터강제 + ⓒPRICE≠0 + ⓓ유효 페이로드.

| 조건 | 현재 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | **부분** | 사이즈·크기직접입력(area)·소재·도수·제작수량 = 라이브 구동 ✅ / 조각수·고리·볼체인색상 = **DB 미적재/논리삭제(C)** ❌ |
| ⓑ 제약 6종 데이터 강제 | **충족(주의)** | ④area범위·면적격자·nonspec·⑥필수·②quantity·③도수 강제 ✅(A) / ⑤택1 조각수·고리 갭 2(C)·범위값 디자인≠DB(C/D) ⚠ |
| ⓒ PRICE≠0 | **충족(주의)** | §26 "본체 견적 가능(유일)"·§29 BOUND_OK·단위단가 3840/6900>0 ✅ / 단 156셀 미적재 sparse(off-grid ceiling이 대부분 흡수)·자재 1.5mm/3mm 혼선(§26·C) ⚠ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립 가능(area-input customW/H 운반·addon) ✅ / 커머스 §24 UNDECIDED·PDF CTA only(에디터 불일치 C) |

**판정: 부분 주문가능(PARTIAL·본체는 견적 가능).** 아크릴 본체(사이즈/자유치수·소재·수량)는 **C3 area-input 종단이 동작**(PRICE≠0·area-input·면적격자·구간할인 슬라이더 표시 전부 어댑터 흡수, 계약 변경 0). 풀 스펙 주문가능화의 병목은 ⓐ조각수 CPQ 미적재·고리/볼체인 addon 논리삭제·ⓑ자재 활성정합·156셀 sparse = (C) 6건 — 위젯/계약/어댑터는 준비 완료(B 0건).

**다음 권고:** ① §7 dbmap에 C 6건(자재활성정합·조각수 CPQ·고리addon복원·볼체인색상분화·156셀적재·nonspec범위) 적재명세 인계 → ② 적재 후 어댑터로 NormalizedProduct 재조립 검증 → ③ hw-builder createHuniAdapter 구현(area-input·price-slider read-only·addon 경로). 코드 구현은 본 명세 승인 후.

---

## 부록: 동형 전파 노트 (C3 클래스)

PRD_000146(아크릴키링·area-input 대표) 매핑 규칙은 **C3 면적입력 클래스**에 전파:
- **같은 면적격자형(PRF_CLR_ACRYL 동형)**: 아크릴마그넷147·뱃지148·집게149·스마트톡150·명찰152·머리끈154(전부 W-AREA·`frm=PRF_CLR_ACRYL`) — 단 §29 `pfm=LIVE_UNBOUND`(상품 바인딩 미연결) = **(C) 바인딩 적재 후 동형 전파**(PRD_000146에서 검증된 규칙 그대로).
- **다른 가격모델로 동형 깨짐(새 대표 필요)**: 아크릴명찰GS153·볼펜155(고정가 by-siz_cd `PRF_ACRYL_*`)·코롯토164(`PRF_COROTTO_ACRYL` 면적격자 별 comp) → C3 하위 분기(고정가형은 사실상 C1에 가까움).
- **signposter 실사/사인(C3 동급)**: area-input 동형이나 가격=포스터사인 매트릭스([[dbmap-silsa-price-via-poster-sign]])·소재 다종 → area-input/nonspec/price-slider 규칙은 전파, 자재·가격격자는 별 comp(동형 입증 후 매핑만).
- **공통 갭(동형)**: nonspec 범위 디자인≠DB·addon 색상 미분화·자재 활성정합은 아크릴군 공통(C).
