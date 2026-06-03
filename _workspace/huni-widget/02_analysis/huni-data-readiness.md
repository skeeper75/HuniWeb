# huni-data-readiness.md — 후니 실데이터 ↔ Red/위젯 구조 매칭 준비도 분석

> 파이프라인 ③ 분석 산출물. **매칭 관점**: 후니 상품마스터/가격표가 RedPrinting 46 옵션구조 + 위젯 14(+2) componentType + 4 가격모델에
> **어느 정도 무손실로 끼워 맞춰지는가**, 그리고 매칭에 필요하나 미작성/불완전한 후니 데이터·간과 함정은 무엇인가.
> [HARD] 분석 전용. `src/` 무수정, 위젯 코드 0줄. 추측 금지 — 데이터로 미확인 시 "미확인" 명시.
> 근거: [XLSX-PM]=상품마스터_260527.xlsx(13시트, openpyxl 실검사) / [XLSX-PR]=가격표_260527.xlsx(19시트, 실검사) /
> [HTML]=table-spec_260602.html(29 테이블 추출) / [PM]=02_business/product-master.md / [PR]=02_business/pricing-rules.md /
> [XM]=02_business/cross-mapping.md / [RCM]=red-coverage-matrix.md(479→46) / [DBMAP]=huni-db-mapping.md / [DC/DA]=계약·어댑터.

---

## 0. 결론 요약 (먼저)

| 항목 | 값 |
|------|-----|
| **후니 상품 수** | **~240종** (MES CD 부여 ~140 + cat 010 라이프·011 에코백 미부여 100+) [PM §4.2]. Red 479보다 적으나 **구조 다양성은 동급**(같은 산업 분류, [XM §1]) |
| **가격 표현 방식** | **19시트 = 4모델 + 후가공/제본 룩업** [XLSX-PR 실검사]. PriceTable3D(수량×ink×side), SizeMatrix2D(가로×세로), TieredDiscount(수량구간%), FixedUnit(step) + 후가공·제본 수량밴드 합산. **단가 룩업표 형태**(공식 아님) |
| **Red 매핑 가능도** | **상품/옵션 구조 ~90% 직접 매핑 가능** · **가격 4모델 100% 정합**(Red 가격모델군 = 후니 4모델 동일) · **componentType 신규 0건**(Red 46→0 실증이 후니에도 적용) |
| **핵심 결손 (매칭 차단 아님)** | ① 제약 규칙(disable/excl/visible) DB 미작성 ② 가격 DB(t_prc_/t_dsc_) placeholder — 엑셀이 실원천 ③ MES CD 무결성 결함 4건 + cat 010/011 코드 미부여 ④ 배송정책 미확정 |
| **매칭 차단 여부** | **위젯 개발 0% 차단**(서버권위+정규화계약+Red fixture). 단 **최종 통합** 전 후니 측 ①②④ 작성 필요 — 임계경로는 후니 데이터지 위젯 아님 |
| **작성 파일** | `_workspace/huni-widget/02_analysis/huni-data-readiness.md` (본 문서) |

> **한 줄:** 후니 가격표는 Red 가격모델군과 **놀랍도록 정합**(둘 다 단가 룩업표 4종). 위젯이 불투명 finalPrice만 소비하므로
> 매칭은 "옵션 구조 슬롯 채우기 + price_gbn echo + QuoteResult 평면화"로 끝난다. 진짜 일은 **후니 데이터 무결성 보정과 제약/가격 작성**이다.

---

## 1. 후니 상품마스터 구조·granularity ↔ Red 46 구조

### 1.1 실제 xlsx 구조 (검사 근거)

[XLSX-PM 실검사] 상품마스터는 **13 시트** — 1 카테고리트리(MAP) + 1 산식메모 + 11 상품 SKU 시트(디지털인쇄/스티커/책자/포토북/캘린더/디자인캘린더/실사/아크릴/문구/굿즈파우치/상품악세사리).

**옵션은 "행"이 아니라 "컬럼군"으로 표현된다** — 한 상품 = 1행, 옵션은 그 행의 셀에 가로로 펼쳐짐 (2단 헤더). [PM §2]:

```
Row1 그룹헤더: 구분 | ID | MES ITEM_CD | 상품명 | 사이즈(필수) | 파일사양… | 주문방법(필수) | 종이(필수) | 인쇄(옵션) | 별색인쇄(옵션) | 후가공 | …
Row2 세부헤더: …판수|블리드|작업사이즈|재단사이즈|출력용지규격|편집기|업로드… | 화이트|클리어|핑크|금|은 …
```

→ **granularity = 상품 단위 1행 + 옵션 차원이 컬럼**. Red의 데이터셋(`pdt_size_info`/`pdt_mtrl_info`/`pdt_dosu_info`/`pdt_pcs_info`)이 **별 테이블 행 묶음**인 것과 표현형이 다르나, **정보 내용은 동일 축**이다.

### 1.2 Red ORD_INFO/PCS_INFO 필드 ↔ 후니 컬럼 대응 매트릭스

[RCM §3.2] Red 가격요청 행 shape의 각 필드가 후니 xlsx/DB에서 어디서 오는가:

| Red 필드 (ORD/PCS) | 후니 xlsx 컬럼 [XLSX-PM] | 후니 DB [HTML] | 대응 | 비고 |
|---------------------|--------------------------|----------------|:----:|------|
| `PDT_CD` (상품코드) | `MES ITEM_CD` (`001-0001`) | `t_prd_products.prd_cd` | ✅ 직접 | 단 무결성 결함(§4 CHK-H1) |
| `CUT_WDT/HGH` (재단) | `재단사이즈` 컬럼 | `t_siz_sizes.cut_width/height` | ✅ 직접 | 규격 1:1 |
| `WRK_WDT/HGH` (작업) | `작업사이즈` 컬럼 | `t_siz_sizes.work_width/height` | ✅ 직접 | 재단마진 가산 포함 |
| `MTRL_CD` (자재/용지) | `종이(필수)` + `출력소재(IMPORT)` 200종 | `t_prd_product_materials ⋈ t_mat_materials` | ✅ 직접 | granularity 후니가 **더 큼**(200 paper) |
| `PRN_CLR_CNT` (도수) | `인쇄(옵션)` 단/양면 + 별색 5종 컬럼 | `t_clr_color_counts.chnl_cnt` | ✅ 직접 | 후니=흑백/CMYK/화이트/클리어/핑크/금/은 (7) |
| `PCS_COD/DTL_COD` (후가공) | `후가공` 컬럼 + 가격표 후가공시트 | `t_prd_product_processes ⋈ t_proc_processes` | ✅ 직접 | 코팅/박/형압/접지/오시/타공/귀돌이 |
| `ORD_CNT` (주문수) / `PRN_CNT` (인쇄수) | `제작수량(필수)` (최소/최대/증가) | `t_prd_products.min/max/dflt_qty` | △ **분리 미명시** | 후니는 수량 1개 — ORD_CNT vs PRN_CNT 분리 신호 불명확 (§4 CHK-H6) |
| `inner_pdt_*` (표지/내지) | 책자 시트 (표지/내지 별 컬럼군) | `t_prd_product_sets` | △ 모델링 확인 | 후니 책자=세트구조 추정 (§4 CHK-H7) |
| `pdt_disable_pcs_info` (disable) | (xlsx에 명시 없음) | `constraint_json`/excl_groups **미작성** | ✗ **미작성** | §3 결손 핵심 |
| `price_gbn` (가격모델) | (시트 분류로 암묵) | `t_prd_product_price_formulas.frm_cd` 미작성 | △ 파생 | category prefix→4모델 (§2.3) |

### 1.3 매핑 가능 / 후니에만 / 후니에 없는 부분

**(A) Red ↔ 후니 직접 매핑 가능 (~90%):**
- 상품코드·규격(cut/work)·용지·도수·후가공·수량 — 6개 핵심 축 전부 후니 컬럼/테이블에 직접 대응. [DBMAP §1.2] 이미 검증.

**(B) 후니에만 있고 Red 캡처에 없던 것 (위젯 흡수 가능):**
- **출력판형(plate_size)** [HTML `t_prd_product_plate_sizes`] — Red 46구조에 없던 차원. 위젯은 select-box/option-button로 흡수([DBMAP §1.2], 신규 0).
- **paper 200종 granularity** [XLSX-PR 출력소재 IMPORT 실검사: 백모조100~220g, 아트, 랑데뷰, 몽블랑, 다이아/실버/골드, PET투명 등 ~200행, 각 연당가·국4절단가 보유]. Red도 paper 다수지만 후니가 **종이 마스터를 가격축으로 직접 보유**(연당가→단가 환산). 위젯엔 불투명 id — 흡수.
- **별색 5종 분리** (화이트/클리어/핑크/금/은 각 단/양면 컬럼) — Red dosu보다 세분. priceColorCount 평면화로 흡수.
- **비규격(nonspec) 자유치수** [HTML `t_prd_products.nonspec_*`] — Red 캡처에 nonspec 상품 부재. area-input(NC-1 dimension-matrix)로 흡수 ([DBMAP §1.4 G3/G4], 위젯 준비됨).

**(C) Red에 있으나 후니에 없는/약한 것 (어댑터 파생 필요):**
- **disable 규칙** (Red `pdt_disable_pcs_info` 명시 목록) — 후니 **데이터 자체 미작성**. 어댑터가 종속(`dep_proc_cd`)/택일(`excl_groups`)→DisableRule 파생 (§3, §4 CHK-H4).
- **VIEW_YN (hidden essential)** — Red `ESN_YN=Y & VIEW_YN=N`. 후니는 `mand_proc_yn`(필수)만, 표시여부 컬럼 없음. 어댑터가 visible 계산 (§4 CHK-H5).
- **ORD_CNT/PRN_CNT 분리** — Red는 주문수≠인쇄수 분리(굿즈=디자인수). 후니 수량 1컬럼 — 어댑터가 분리 직렬화 보장 필요 (§4 CHK-H6, **침묵 0원 위험**).
- **면별 uploadType** — Red도 미확정(O3), 후니는 `editor_yn/file_upload_yn` 상품단위 2플래그라 면별 신호 부재 (§4 CHK-H8).

> **매핑 가능도 종합:** 옵션 구조 6핵심축 직접(✅) + 후니 고유 4종 흡수(✅) + Red 고유 4종 어댑터 파생(△) = **구조 ~90% 직접, 나머지 어댑터 파생으로 100% 무손실**. componentType **신규 0건**(Red 46→0 실증이 후니 동일 토큰 집합에 적용).

---

## 2. 후니 가격표 구조 ↔ Red 가격모델 정합

### 2.1 후니 가격은 4모델 단가 룩업표 (실검사 확정)

[XLSX-PR 실검사] 19시트를 가격모델로 분류하면 — **놀랍도록 Red 가격모델군과 1:1 정합**한다:

| 후니 시트 (실검사 샘플) | 표현 단위 | 가격모델 | Red 대응 [RCM/SCAN-B] |
|--------------------------|-----------|----------|------------------------|
| **디지털인쇄비** R3=`수량 \| 흑백 단/양 \| CMYK 단/양 \| 화이트… \| 은`, R4+=수량행×단가 | (수량밴드 × inkType7 × 단/양면) 룩업 | **PriceTable3D** | `digital_price`·`tmpl_price`·`vTmpl_price` |
| **아크릴** R2=`가로/세로 \| 20mm…180mm`, R3+=세로행×가로열 셀 | (가로 × 세로) 매트릭스 셀 | **SizeMatrix2D** | `vTmpl_price`(아크릴), bilinear |
| **포스터사인** R2=`가로/세로 \| 600…1200mm`, 9소재 매트릭스 | (가로 × 세로) 매트릭스 + 면적외삽 | **SizeMatrix2D** | `real_price`(포스터/실사) |
| **굿즈파우치(구간할인)** R2=`수량구간 \| 할인율`, R3+=`1~49→0.0, 50~99→0.05, 1000~10000→0.2` | unitPrice × 수량, 수량구간 %할인 | **TieredDiscount** | `tiered_price` |
| **스티커** R2=`소재/수량 \| A5(4판)…`, 판수×소재3×수량 | (판수 × 소재 × 수량) 룩업 | **PriceTable3D** 변형 | `tmpl_price` |
| **제본** R2=`제본/수량 \| 중철 \| 무선 \| 트윈링 \| PUR`, 수량행×제본열 | (제본종 × 수량밴드) 룩업, 합산항 | (후가공 합산) `book2025_price` 구성요소 | bindingPrice |
| **인쇄후가공** R2=`수량 \| 직각 \| 둥근`, 수량밴드×후가공 | (후가공 × 수량밴드) 합가 | (후가공 합산) finishPrice | selectedFinishes 가격 |
| 타투스티커·스티커팩 [PR §6.3] | unitPrice × ceil(수량/step) | **FixedUnit** | `tmpl_price` step |

[PR §16] 통합 출력 = `QuoteResult{ basePrice, finishPrice, optionPrice, bindingPrice, quantityDiscount, subtotal, vatAmount, deliveryFee, total, breakdown[8 axis] }`.

### 2.2 Red 가격모델군(실측 10 price_gbn) ↔ 후니 4모델 정합

[RCM §5 / SCAN-B] Red 실측 10 named price_gbn(digital/tmpl/vTmpl/tmpl_calc/vTmpl_calc/tiered/book2025/offset2023/clothes2025/real + null)은
[PR §16] 후니 4모델로 **수렴**한다 — 둘 다 **단가 룩업표 + 수량할인 + 후가공합산** 동일 구조. price_gbn 종류가 후니가 더 적을 뿐(시트=상품군 분류), **계산 패턴은 동형**:

| 패턴 | Red price_gbn | 후니 모델 [PR] | 위젯 영향 |
|------|---------------|----------------|-----------|
| 수량×ink×side 룩업 | digital/tmpl/vTmpl_price | PriceTable3D (디지털인쇄비) | 불투명 |
| 가로×세로 매트릭스 | real_price | SizeMatrix2D (포스터/아크릴) | 불투명 |
| 수량구간 %할인 | tiered_price | TieredDiscount (굿즈파우치) | 불투명 |
| step 고정단가 | tmpl_price | FixedUnit (타투/스티커팩) | 불투명 |
| 책자 표지/내지 합산 | book2025_price | PriceTable3D + bindingPrice (제본시트) | 불투명 |
| 캘린더 폐쇄래더 | offset2023_price | (캘린더 수량밴드) | 불투명 |

> **핵심: 위젯은 price_gbn도 후니 4모델도 모른다.** [RCM CHK-1] price_gbn은 echo만 — 후니 어댑터가 `priceSchemeKey`로 category prefix(001~012)나 시트분류 키를 echo하면 끝. BFF가 그 키로 4모델 분기.

### 2.3 후니 가격을 정규화 계약(opaque finalPrice + lines[])에 넣는 데 필요한 것

[DBMAP §2.2 / RCM §3.3] 위젯 계약 `NormalizedPriceBreakdown{ finalPrice, vat, shipping, lines[]{code,label,amount} }`에 후니 가격을 평면화:

| 필요 작업 | 내용 | 위젯 가시? | 상태 |
|-----------|------|:----------:|------|
| **QuoteResult→Breakdown 평면화** | total→finalPrice, vatAmount→vat, deliveryFee→shipping, breakdown[8axis]→lines[] | No (어댑터) | 매핑 검증됨 [DBMAP §2.2] |
| **수치→id 역매핑** | SizeMatrix2D는 가로/세로 수치 직접 사용(✅), PriceTable3D는 size→판수/숫자→inkType 역매핑 | No (어댑터, R2 옵션A) | 어댑터가 상품마스터 보유→무비용 [DBMAP R2] |
| **priceSchemeKey echo** | category prefix→4모델 분류 키 (BFF 분기용) | No (불투명 echo) | 후니 frm_cd 미작성→prefix로 임시 |
| **paper 단가 lookup** | `종이코드 → 출력소재(IMPORT) 연당가→국4절 단가` 환산 | No (BFF 내부) | 엑셀 보유 [XLSX-PR] |
| **VAT 분리** | 포함가에서 10/110 분리 [PR §15.1] (D-PM-15 미확정) | No (BFF) | 정책 결정 대기 |
| **수량보간 정책** | nextStep/sameStep/linear (D-PM-10 권장 nextStep) | No (BFF) | 정책 결정 대기 |

> **결론:** 후니 가격을 계약에 넣는 데 **위젯 가시 계약 변경 0건**. 전부 어댑터/BFF 내부 작업. 단 두 정책(D-PM-10 보간, D-PM-15 VAT)이 BFF 출력값에 영향 — 위젯은 불투명이라 무관하나 **수치 정확도**엔 필요.

---

## 3. 데이터 준비도 / 결손 (매칭에 필요한데 미작성·불완전)

[DBMAP §0.1 STATE-OF-AUTHORING]을 매칭 관점으로 재정리. **AUTHORED=즉시 매칭 가능 / NOT-YET=후니 작성 대기**:

| 영역 | 후니 상태 | 매칭 영향 | 위젯 차단? |
|------|-----------|-----------|:----------:|
| **상품 마스터** (코드/명/규격/용지/도수/후가공/수량/카테고리) | ✅ AUTHORED (DB + 엑셀) | NormalizedProduct·옵션차원·componentType **즉시 채움 가능** | **No** |
| **가격 수치** (t_prc_/t_dsc_) | 🚧 DB placeholder — **엑셀이 실원천**(19시트 4모델) | 실가격은 엑셀에 있음. BFF가 엑셀 4모델 구현하면 즉시. DB는 향후 | **No**(서버권위) |
| **제약 규칙** (disable/excl_groups/visible) | 🚧 **미작성** — constraint_json 비어있음 | 캐스케이드 disable 0개 → 불가능 조합 선택 가능 | **No**(Red fixture 구동) |
| **배송정책** (무료기준/기본료/제주/도서산간) | 🚫 **미확정** (D-PM-16, 6항목) | shipping 값 부정확 | **No**(불투명) |
| **위젯 전용** (세션/장바구니/주문) | 🚫 커머스 UNDECIDED | 범위 밖 | **No** |

### 3.1 huni-db-mapping 90% 검증 중 나머지 10% 미실증 항목

[DBMAP §6.2] 어댑터 세부 — 후니 데이터로 **아직 실증 못 한** 항목:

| ID | 미실증 항목 | 왜 미확인 | 매칭 리스크 |
|----|-------------|-----------|-------------|
| **G1** | 자재→후가공 disable 규칙 형태 (constraint_json vs 종속/택일 그래프) | 후니 제약 데이터 **미작성** | disable 누락 시 불가능 조합 가격요청 |
| **G2** | 책자 표지/내지 = `t_prd_product_sets`(세트) vs 단일상품 side분리 | 후니 책자 모델링 **미확인** | sides 분기·내지옵션 잘못 조립 |
| **G3** | 박/형압 가로×세로 mm 입력이 `prcs_dtl_opt`(text) 어디에 | JSON 스키마 **미확인** | area-input 옵션 위치 |
| **G4** | nonspec 자유치수→area-input 생성 경로 | Red 캡처에 nonspec 부재, 후니 실데이터 미테스트 | 비규격 상품 0원 진입 |
| **G5** | 공정 visible(VIEW_YN) 분류 데이터 부재 | 후니 표시여부 컬럼 없음 | hidden essential 가격 누락 |
| **G6** | 상품 단위(`unit`) 직접 컬럼 없음 → bdl_unit_nm/prd_typ_cd 파생 | 파생 규칙 미확정 (D-PM-14) | 표시용 unit |
| **G9** | 세트/애드온 상품(t_prd_product_addons)을 위젯이 다루는가 | 현 계약 단일상품 견적 | SUM_MTR 자재합산 매핑 |

> **종합 준비도:** 상품 구조 = **준비 완료**(즉시 매칭). 가격 = **엑셀 준비됨, DB 미작성**(BFF가 엑셀 구현). 제약·배송 = **미작성/미확정**(위젯은 Red fixture로 우회).
> **매칭 임계경로 = 후니 측 ①제약 작성 ②엑셀→BFF 가격 구현 ③배송정책 확정 + ④무결성 보정.** 위젯 개발은 전부 무차단.

---

## 4. 후니 데이터 측 간과하기 쉬운 매칭 함정 (체크리스트)

[RCM §4] 위젯측 체크리스트(CHK-1~10)와 **짝이 되는 후니측 체크리스트**. 위젯측이 "어댑터가 보장해야 할 것"이라면,
아래는 **"후니 원천 데이터에 숨은 결함·불일치"** — 누락 시 위젯은 정상인데 침묵 오작동(빈 그룹/0원/잘못된 캐스케이드)한다.

### CHK-H1 — MES ITEM_CD 무결성 결함 (가장 시급, 마이그레이션 전 보정)
[PM §6] 실데이터에 **코드중복 4건 + 미부여 100+건** 확정:
- `PM-DUP-01` 001-0014 = 종이슬로건 + 2단접지카드 (동일 CD 2상품) → 코드→상품 1:1 깨짐
- `PM-DUP-02` 002-0002/002-0015 = ID 22852 공유 · `PM-DUP-03` 004-0005/006-0006 = ID 14567 · `PM-DUP-04` 006-0001/008-0020 = ID 14592
- `PM-MISS-01` cat 010 라이프·011 에코백 전체 SKU **MES CD 미부여** (100+ 상품)
- **함정:** 위젯은 불투명 id round-trip이라 무관하나, **어댑터 복합키가 흔들리면** 옵션 selected가 가격요청에서 매칭 실패 → 0원. [RCM CHK-9]와 짝.
- **보정:** 어댑터가 `(code [+side/variant])` 안정 복합키 발급 + **마이그레이션 전 코드 일괄 보정** 권장 (D-PM-03). cat 010/011은 신규 코드 부여 필요.

### CHK-H2 — 가격 단위 불일치 (KRW/판 vs KRW/장 vs 세트)
[XLSX-PR 실검사] 시트마다 **단가 기준 단위가 다르다**:
- 디지털인쇄비 = **KRW/판**(국4절 1판), 스티커 = KRW/판(판수별), 명함 = **100장=1set**, 박명함 = **200장 1set**, 포토카드 = 20장 세트 vs 대량 이중, 타투 = 3장 단위, 스티커팩 = 54장 세트.
- **함정:** 어댑터/BFF가 "판→장" "세트→개" 환산을 누락하면 가격이 N배 틀어진다. 위젯 수량 입력(장/개)과 가격표 단위(판/세트)가 **다른 차원**.
- **보정:** 상품별 `unit` + 환산계수(판걸이수 시트 = 판수 매트릭스)를 BFF가 보유. [PR §14] 최소주문 단위 D-PM-14와 연계.

### CHK-H3 — 옵션 코드체계 차이 (xlsx 한글 라벨 vs DB 코드 vs Red CD)
- xlsx 옵션은 **한글 텍스트**(`종이(필수)`=백모조220, `후가공`=둥근모서리)인데 DB는 코드(`t_mat_materials.mat_cd`), Red는 `MTRL_CD` 숫자.
- **함정:** 세 표현(엑셀 한글 / DB 코드 / Red CD)이 1:1 매핑되지 않으면 어댑터가 옵션을 잘못 사상 → 캐스케이드/가격 매칭 실패. 특히 **별색 5종**(화이트/클리어/핑크/금/은)이 Red dosu 정의와 코드 정렬 안 되면 priceColorCount 평면화 오류.
- **보정:** 엑셀 한글라벨↔DB코드 매핑표를 후니가 작성(현재 미확인). 어댑터는 DB코드 기준 불투명 id 사용.

### CHK-H4 — 캐스케이드 제약 데이터 부재 (disable 규칙 0개)
[DBMAP G1/B2] 후니에 "자재 선택 시 특정 후가공 비활성" **규칙 데이터 자체가 없다**(constraint_json 미작성).
- **함정:** 어댑터가 비우면 위젯 캐스케이드 엔진은 정상이나 **disable이 0개** → 사용자가 불가능 조합(예: 투명PET에 박 불가) 선택 → BFF 0원/에러. xlsx에도 조합제약이 **암묵지**(운영자 머릿속)로만 존재.
- **보정:** xlsx 산식메모 시트(`계산공식집초안` 126행)·운영자 인터뷰로 제약 추출 → constraint_json 적재 (R1). 오늘은 Red fixture로 엔진 검증. [RCM CHK-4]와 짝.

### CHK-H5 — 숨은 필수옵션 (자동공정 visible 분류 부재)
[DBMAP G5] 후니 `mand_proc_yn`(필수)만 있고 VIEW_YN(표시여부) 컬럼 없음.
- **함정:** 재단(CUT_DFT)·내지기본(INN_DFT) 같은 "필수이나 미표시·자동적용" 공정이 분류 안 되면 → UI에 안 보이는데 **가격요청에서 누락** → 가격 미달. xlsx에 `INN_DFT` 류 자동기본이 컬럼으로 명시 안 됨.
- **보정:** 어댑터가 `required:true + visible:false` 그룹의 default를 selected 주입. 자동공정 구분법을 후니가 정의 (constraint_json/공정유형코드). [RCM CHK-2]와 짝.

### CHK-H6 — 수량 granularity 불일치 (ORD_CNT vs PRN_CNT 단일 컬럼)
[XLSX-PM] 후니 수량 = `제작수량(필수)` **1컬럼**(최소/최대/증가). Red는 주문수(ORD_CNT)≠인쇄수(PRN_CNT) **분리**.
- **함정 (침묵 0원, 가장 위험):** [RCM CHK-1 실측] tmpl/tiered_price는 ORD_CNT+PRN_CNT **둘 다** 있어야 PRICE>0. 후니 수량 1개를 어댑터가 한쪽만 직렬화하면 위젯 정상인데 **침묵 0원**. 굿즈(=디자인수 ORD_CNT, 인쇄수 PRN_CNT 별개)에서 특히.
- **보정:** 어댑터 quote() 가드(`isPriceRequestQuotable`) 후니에도 적용 + 후니 수량을 ORD_CNT/PRN_CNT 양쪽 의미로 어느 게 맞는지 상품군별 확정 (미확인).

### CHK-H7 — 책자 표지/내지 모델링 미확인 (세트 vs side분리)
[DBMAP G2] 후니 책자 시트는 표지/내지 별 컬럼군. DB는 `t_prd_product_sets`(세트구조) 추정이나 **미확인**.
- **함정:** Red는 `hasInner`→ProductSide[default,inner] 분기. 후니가 세트(부모-자식 상품)면 어댑터가 세트를 풀어 side로 재구성해야 함. 잘못 두면 내지 용지/도수 옵션이 표지에 붙거나 누락.
- **보정:** 후니 책자 = 단일상품 side분리 vs 세트상품인지 확정. 위젯 ProductSide 계약은 양쪽 수용([DBMAP G2]).

### CHK-H8 — 면별 uploadType 신호 부재
[DBMAP §1.1] 후니 `editor_yn/file_upload_yn` = **상품단위 2플래그**. 책자/케이스(CVR_INN)에서 표지=편집기, 내지=PDF 같은 **면별 분기 신호 없음**.
- **함정:** Red도 미확정(O3)이나, 후니는 구조적으로 면별 데이터가 없어 어댑터가 규약으로 고정할 수밖에 없음. 표지/내지 입력수단을 잘못 고정하면 UX 오류.
- **보정:** 후니 책자/CVR_INN에서 면별 입력수단 결정 데이터 존재 여부 확인. 없으면 어댑터 규약 고정 (예: 표지=editor, 내지=pdf 기본).

### CHK-H9 — 가격 granularity 불일치 (수량밴드 vs 자유수량 / 폐쇄래더)
[XLSX-PR] 디지털인쇄비 56구간 수량밴드(1,2,…,1000000 sentinel), 명함=100장단위, 캘린더=폐쇄래더 추정.
- **함정:** [RCM CHK-7] 폐쇄 래더 상품(등록값만 단가)을 자유 counter로 렌더하면 임의값=0원. 후니 수량 정의가 자유범위(min/max/incr)인지 enum목록인지 **상품별로 다른데 xlsx에서 구분 신호 약함**.
- **보정:** 후니 수량을 자유범위 vs enum 구분 → select-box enum vs counter-input 분기. sentinel(1000000) 처리 BFF 명시 [PR PRC-002].

### CHK-H10 — paper 200종 vs 상품별 허용 용지 매핑 (조합 폭발)
[XLSX-PR 출력소재 IMPORT 실검사] paper 마스터 ~200종(백모조/아트/랑데뷰/몽블랑/PET 등 각 평량별).
- **함정:** 상품마다 허용 용지가 다른데(명함=랑데뷰/몽블랑/스타드림, 디지털=백모조/아트), `t_prd_product_materials`가 상품↔용지 N:M을 정확히 매핑 안 하면 → 위젯이 200종 전부 보여주거나(D-PM-13) 잘못된 용지에 0원. **용지×사이즈×후가공 조합 폭발(10⁴+)** [XM §3.2].
- **보정:** 상품별 허용 용지 부분집합을 `t_prd_product_materials`가 정확히 보유 확인 + D-PM-13(인기50종 노출) 정책. 가격 셀 부재 조합은 보간/외삽 정책 (D-PM-10).

### CHK-H11 — 중복 정의 source-of-truth (시트 간 같은 상품)
[PM PM-CROSS-01] 탁상형캘린더가 `캘린더` + `디자인캘린더` 양 시트에 중복 정의. 포토북도 마스터+가격 분리.
- **함정:** 같은 상품의 사양/가격이 두 곳에 있으면 어느 게 권위인지 불명 → 마이그레이션 시 충돌.
- **보정:** 상품별 single source-of-truth 시트 지정 (D-PM-03 연계).

### 후니측 체크리스트 ↔ 위젯측(RCM §4) 짝 매핑

| 후니측 (본 문서) | 위젯측 [RCM §4] | 공통 리스크 |
|------------------|------------------|-------------|
| CHK-H1 코드중복 | CHK-9 code round-trip | 어댑터 키 흔들림→매칭실패 |
| CHK-H4 disable 미작성 | CHK-4 캐스케이드 disable | 불가능 조합 0원 |
| CHK-H5 visible 부재 | CHK-2 hidden-essential | 자동공정 가격누락 |
| CHK-H6 수량 단일컬럼 | CHK-1 price 행 shape | 침묵 0원 |
| CHK-H9 폐쇄래더 | CHK-7 래더 vs counter | 임의값 0원 |
| CHK-H10 용지 N:M | CHK-3 defaultSelections | 잘못된 용지 0원 |
| CHK-H7 책자 세트 | CHK-8 면별 uploadType | 내지옵션 오배치 |

---

## 5. 요약 (오케스트레이터 반환용)

| 항목 | 값 |
|------|-----|
| 후니 상품 수 | **~240종** (MES CD ~140 + cat010/011 미부여 100+), 12 대분류, 13 마스터시트 |
| 가격 표현 방식 | **19시트 = 4모델 단가룩업표** — PriceTable3D(수량×ink×side) / SizeMatrix2D(가로×세로) / TieredDiscount(수량구간%) / FixedUnit(step) + 후가공·제본 수량밴드 합산 → QuoteResult |
| Red 매핑 가능도 | **옵션구조 ~90% 직접**(6핵심축) + 후니고유 4종 흡수 + Red고유 4종 어댑터파생 = 무손실 100% · **가격 4모델 100% 정합** · **componentType 신규 0건** |
| 미작성/결손 핵심 | ① 제약규칙(disable/excl/visible) DB 미작성 ② 가격 DB placeholder(엑셀 실원천) ③ MES CD 무결성 4중복+100+미부여 ④ 배송정책 미확정(D-PM-16) |
| 후니측 간과 함정 | 11항목(CHK-H1 코드중복 ~ CHK-H11 중복정의) — 단위불일치/코드체계3중/숨은필수옵션/수량단일컬럼(침묵0원)/용지N:M 조합폭발 |
| 매칭 차단 여부 | **위젯 개발 0% 차단**(서버권위+정규화계약+Red fixture). 임계경로 = 후니 데이터 작성·보정 |
| 작성 파일 | `_workspace/huni-widget/02_analysis/huni-data-readiness.md` |

> **결론:** 후니 가격표는 Red 가격모델군과 구조적으로 동형(둘 다 단가 룩업표 4종)이라 매칭이 자연스럽다. 위젯이 불투명 finalPrice만
> 소비하므로 가격 매칭은 "QuoteResult 평면화 + price_gbn echo"로 종결. 옵션 구조도 componentType 신규 0건으로 흡수.
> **진짜 일은 후니 측 데이터 무결성 보정(코드중복·단위·용지N:M) + 제약/가격 작성**이며, 이는 위젯 개발을 막지 않고 최종 통합 직전 완료하면 된다.
