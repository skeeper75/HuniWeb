# signposter-propagation.md — 실사/사인(C3 면적입력) 동형 전파 (경량)

> 파이프라인 ③' 컨버전 선행 · **경량 전파**(동형 판정+델타+대표+갭만·전체 재유도 금지·코드 0줄).
> **클래스 대표(동형 기준)** = C3 `../arrylic/arrylic-form-spec.md`(PRD_000146 아크릴키링·area-input).
> **외형 권위** = `docs/design/11가지상품옵션/product-signposter-option/Configurator.jsx`(165줄·사이즈·직접입력·소재·별색화이트·코팅·가공·추가·제작수량).
> **데이터 권위** = 라이브 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01).
> **대표 상품** = **PRD_000138 일반현수막**(nonspec area-input·PRF_POSTER_BANNER_N·가공/추가/각목 CPQ 실적재).
> **가격 권위** = 서버 `evaluate_price`(:394) 불투명 결과. PRICE=0=결함. 디자인 가짜식(75000 고정) 폐기.

---

## ① 동형 판정 — C3(arrylic) 대비

**판정: C3 면적입력 클래스에 동형(SAME CLASS) — 단 가격모델 차원·CPQ 성숙도가 상속이 아닌 "동형 깨짐 없는 변형".**

| 축 | C3 대표(arrylic PRD_000146) | signposter(PRD_000138 현수막) | 동형 |
|----|------------------------------|--------------------------------|:---:|
| **핵심 입력형** | area-input(크기 직접입력 2축·nonspec) | area-input(직접입력 가로×세로·nonspec) | ✅ **동형**(C3 정의축) |
| nonspec_yn | Y(20~100) | Y(가로 500~1750·세로 500~5000·incr 100) | ✅ 동형(범위만 상이) |
| 가격 차원 | `[mat_cd,siz_width,siz_height,min_qty]` PRICE_TYPE.02 단가형 | `[siz_width,siz_height]` PRICE_TYPE.01 **합가형**(79셀 면적격자) | △ **변형**(둘 다 가로×세로 면적격자·off-grid ceiling 동일 / 단가형 vs 합가형) |
| 가격공식 | PRF_CLR_ACRYL(아크릴 전용 comp) | **PRF_POSTER_BANNER_N**(포스터사인 매트릭스·[[dbmap-silsa-price-via-poster-sign]]) | △ 별 comp(동형 입증 후 매핑) |
| 소재 | active 1종(자재 활성 정합 문제) | active 1종(MAT_000182 현수막천)+선택축 다종(MAT_000069/070/337/338/340) | ✅ 동형 |
| addon/가공 | addon 템플릿(전부 del_yn=Y·미작동) | **가공/추가/각목 CPQ option_groups 실적재·작동**(OPT_000003/004·OPT-000002) | ✅↑ **signposter가 더 성숙**(arrylic 갭을 signposter가 해소) |
| 구간할인 | DSC_ACR_QTY(price-slider 표시) | 없음(현수막=수량 단가표 내장·슬라이더 불요) | △ 변형(슬라이더 미사용) |

→ **arrylic의 C3 매핑 규칙(area-input→siz_width/siz_height 직접 운반·nonStandardAllowed·off-grid ceiling 서버내부·필수공정 자동주입·price-slider 처리 결론·sides=default)을 그대로 상속.** 신규 클래스 불요. 가격격자가 별 comp(POSTER_BANNER)·합가형인 점만 변형이나 **위젯/어댑터 관점에선 동일 area-input 축**(서버가 불투명 처리). [[dbmap-silsa-price-via-poster-sign]] [[dbmap-area-matrix-wh-dimension]] 정합.

---

## ② 그룹 델타 — 대표(arrylic)에 없는 것만

C3 대표 명세 §1~§6 전부 상속. **signposter 고유 추가분만 기술:**

| 델타 | signposter 고유 | 정규화 매핑 | DB 출처(PRD_000138) | 분류 |
|------|----------------|-------------|---------------------|------|
| **D1 합가형 면적격자** | 현수막=`[siz_width,siz_height]` 면적 단가표(아크릴 단가형×수량과 달리 완제품 통가격) | area-input은 동일·**가격은 서버 불투명**(위젯 무지) | COMP_POSTER_BANNER_NORMAL(PRICE_TYPE.01·79셀) | **(A)** 서버내부 |
| **D2 소재 다종(실사)** | 스노우200·유포지(방수)·현수막원단 등 — 소재가 가격축·방수 가산 | `OptionGroup(multiple=false)` 소재 | product_materials(active MAT_000182 + 선택축 5종) | **(A)** 직매핑 |
| **D3 가공=배너피니싱 CPQ(작동)** | 오버로크/오버로크+리본/말아박기 = **봉제/열재단 공정 묶음**(arrylic 고리 addon과 달리 native CPQ) | `OptionGroup(OPT_000003·sel_typ.01·필수 택1)` | OPT_000003 가공(OPV 묶음 mat+proc: PROC_000080/081/084) | **(A)** sel_typ→multiple·BUNDLE(mat+proc 한 옵션 두 의미·[[dbmap-option-material-process-bundle]]) |
| **D4 추가=거치대 CPQ(작동)** | 거치대없음/실내·실외 배너거치대 = 추가물 택1(추가없음 센티넬 min0) | `OptionGroup(OPT_000004·min0/max1)` | OPT_000004 추가(설치용끈 MAT_000070·큐방 MAT_000337) | **(A)** 센티넬→옵션·arrylic addon(del_yn=Y) 대비 signposter는 작동 |
| **D5 각목추가(타공수 파라미터)** | (디자인 폼엔 없음·DB 추가축) 각목 부착 변·타공수 4/6/8 | addon/옵션 + `inputs`(타공수) | OPT-000002 각목추가·OPV dtl_opt `{"타공수":N}` | **(A)** inputs 파싱(GAP-PARAM 해소·이미 dtl_opt 적재) |
| **D6 별색화이트(단면)** | 화이트인쇄 없음/단면 | `option-button`(택1) | **print_options 0행**(현수막 도수 미적재) — (C) | **(C)** |
| **D7 코팅** | 코팅없음/무광/유광 | `option-button`(택1) | **CPQ 미생성** — (C) | **(C)** |

**핵심 차이(arrylic→signposter):** ⓐ 가격이 **합가형 완제품가**(아크릴 단가형×수량 아님) — area-input 운반은 동일, 서버가 흡수. ⓑ **가공/추가가 native CPQ로 작동**(arrylic은 addon 논리삭제로 미작동) → signposter는 **arrylic의 (C) addon 갭이 없는 더 성숙한 C3 사례**. ⓒ 각목/타공수는 dtl_opt inputs로 이미 파라미터 적재.

---

## ③ 라이브 대표 상품 1개 — PRD_000138 일반현수막

```
prd_typ=PRD_TYPE.01(완제품)·nonspec_yn=Y(가로 500~1750·세로 500~5000·incr 100)
file_upload_yn=Y·editor_yn=N · min_qty=1·incr=1·max=10000 · qty_unit=QTY_UNIT.01(개)
sizes: SIZ_000322(5000x900 표준전지·dflt)  (자유치수=nonspec 권위)
materials(USAGE.07): MAT_000182 현수막천(dflt·active) + 선택축 MAT_000069/070/337/338/340
print_options: 0행(도수 미적재 — 별색화이트=C)
processes: PROC_000079/080/081/084/104(가공·타공) — 대부분 가공 CPQ로 노출
option_groups(CPQ·작동): OPT_000003 가공(택1필수) / OPT_000004 추가(택1·센티넬min0) /
  OPT-000002 각목추가 / OPT_000063 각목 부착 변
constraints: 0행 · addons: 0행(가공/추가는 option_groups 경로)
price_formula: PRF_POSTER_BANNER_N(use_yn=Y) → COMP_POSTER_BANNER_NORMAL([siz_width,siz_height]·79셀)
  + 가공/추가/각목 COMP(COMP_POSTEROPT_BANNER_NORMAL_PROC_*·COMP_POPT_BNR_GAKMOK_STR_900_4_*)
```

**대표 선정 근거:** nonspec area-input(직접입력)·소재 다종·가공/추가/각목 CPQ 작동 → C3 면적입력 폼의 모든 분기(자유치수·소재·배너피니싱·추가물·파라미터)를 가장 많이 traverse하면서 **PRF_POSTER_BANNER_N 바인딩으로 견적 가능**. (대안 nonspec 포스터 PRD_000118~125는 가공/추가 빈약.)

**componentType 사상(arrylic 상속 + 델타):** `option-button`(소재·가공·추가·별색·코팅) · `area-input`(직접입력 2축·★C3 핵심) · `counter-input`(제작수량·각목 타공수) · `summary` · `upload-cta`(PDF). price-slider=미사용(현수막 슬라이더 없음).

---

## ④ evaluate_price 골든 (PRICE≠0)

디자인 가짜값(subtotal 75000·추가 25000 하드코딩·치수 무반영) **폐기**. 실가=PRF_POSTER_BANNER_N 면적격자(가로×세로 합가형) + 가공/추가 COMP 가산.

```
NormalizedPriceRequest{ productCode:PRD_000138, priceSchemeKey:PRF_POSTER_BANNER_N(echo),
  dimensions:[{side:default, cutW=customW, cutH=customH}], materials{default:MAT_000182},
  quantity, selectedFinishes:[{groupId:OPT_000003 가공}, {groupId:OPT_000004 추가}] }
  │ 어댑터 — area-input→siz_width/siz_height 직접 운반(siz_cd 미동반)·off-grid ceiling 서버내부
  ▼
evaluate_price({prd_cd:PRD_000138},{siz_width,siz_height,mat_cd,proc_cd[가공/추가]},qty)
  │ PRF_POSTER_BANNER_N → COMP_POSTER_BANNER_NORMAL 면적격자(이상최소 tier) + 가공/추가 COMP
  ▼
NormalizedPriceBreakdown{ ok, finalPrice, vat, shipping, lines[…] }
```

| 케이스 | 입력(치수·소재·가공) | 격자 매칭(off-grid ceiling) | 합가형 단가(verbatim) | PRICE |
|--------|----------------------|---------------------------|----------------------|-------|
| A 표준 소형 | 900x900·현수막천·오버로크 | 정확셀 900x900 | **8,000**(출력가) + 가공 COMP | **>0(≈8,000+)** |
| B 중형 | 900x1200·현수막천 | 정확셀 900x1200 | **8,640** | **8,640+** |
| C 대형 off-grid | 1000x900→ceiling 인접셀 | 이상최소 tier | (인접셀 단가) | **>0** |
| D 와이드 | 900x2200 | 정확셀 | **15,840** | **15,840+** |

> 단위/합가단가(8,000·8,640·15,840)는 `t_prc_component_prices` COMP_POSTER_BANNER_NORMAL 라이브 verbatim(siz_width/siz_height 좌표). 최종가는 evaluate_price가 면적격자+가공/추가 COMP를 내부 산정 — 정확값은 hw-qa 라이브 시뮬레이터(읽기전용) 실측(거짓 수치 날조 금지). ✅ **PRICE≠0 게이트 통과**(전 케이스 합가단가>0·PRF_POSTER_BANNER_N 바인딩 견적 가능).

---

## ⑤ 갭 (A)/(B)/(C) + 주문가능 4조건

### (A) 어댑터 흡수 — 계약/위젯 무변경 (arrylic 상속 + 델타)
A1 area-input→siz_width/siz_height 운반(상속) · A2 off-grid ceiling 서버내부(상속) · A3 nonStandardAllowed(nonspec_yn=Y·상속) · A4 sides=default(상속) · A5 가공 BUNDLE(mat+proc 한 옵션·sel_typ→multiple) · A6 추가 센티넬→옵션(min0) · A7 각목 타공수 dtl_opt inputs 파싱 · A8 합가형/단가형 차이는 서버 불투명(위젯 무지) · A9 수량 clamp(디자인 max500≠DB max10000 — DB 권위).

### (B) 계약 변경 필요 (**0**)
위젯 계약이 `area-input`·`InputSpec.axis2`·`nonStandardAllowed`·`OptionGroup.multiple`·`counter-input`(inputs) **이미 보유** → **계약 변경 0건**(목표 달성). signposter는 arrylic보다 (C)가 적어 동형 전파의 깨끗한 사례.

### (C) DB 작성·교정 — §7 인간 승인 (3)
- **C-별색화이트(D6):** 현수막 화이트인쇄(단면) 도수/옵션 미적재(print_options 0행). 디자인 폼 별색 노출 vs DB 부재.
- **C-코팅(D7):** 코팅 무광/유광 CPQ 옵션그룹 미생성.
- (참고) C-nonspec 범위 정합: 디자인 placeholder(가로 200~1200·세로 200~3000) vs DB(500~1750·500~5000) 불일치 → DB 권위(arrylic과 동형 갭). 가격격자 좌표 범위와도 교차확인 필요.
- (참고) C-editor_yn: 디자인 PDF 업로드 단독(에디터 버튼 없음) ↔ DB editor_yn=N **일치**(arrylic의 에디터 불일치 갭 없음).

### 주문가능 4조건 (PRD_000138 현재)
| 조건 | 충족 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 구동 | **부분(高)** | 직접입력(area)·소재·가공·추가·각목 = 라이브 CPQ 구동 ✅ / 별색화이트·코팅 = 미적재(C) ❌ |
| ⓑ 제약 6종 강제 | **충족** | ④area범위·면적격자·nonspec·⑥필수(가공 택1)·②quantity 강제 ✅(A) / 갭은 선택옵션(별색·코팅) |
| ⓒ PRICE≠0 | **충족** | PRF_POSTER_BANNER_N 바인딩·합가단가 8,000~15,840>0 ✅ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립(area-input customW/H 운반·가공/추가 selectedFinishes)·PDF CTA(editor_yn=N 일치) ✅ |

**판정: 주문가능(ORDER-CAPABLE·본체 견적 가능·실질 동작).** signposter 본체(자유치수·소재·가공·추가·각목)는 **C3 area-input 종단이 이미 완전 동작**(PRICE≠0·가공/추가 CPQ 작동·계약 변경 0). 잔여 (C)는 **선택옵션(별색화이트·코팅) 2건뿐**(미선택 시 주문 가능) → arrylic(△ PARTIAL·6건 C·addon 미작동)보다 **성숙도 높은 C3 동형**. 병목 없음 — 별색/코팅 적재는 풀스펙 확장(§7 인간 승인).
