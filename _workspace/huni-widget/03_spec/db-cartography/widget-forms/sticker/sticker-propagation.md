# sticker-propagation.md — 스티커(C4 캐스케이드+후가공) 동형 전파 (경량)

> 파이프라인 ③' 컨버전 선행 · **경량 전파**(동형 판정+델타+대표+갭만·전체 재유도 금지·코드 0줄).
> **클래스 대표(동형 기준)** = C4 `../digital-print/print-form-spec.md`(PRD_000042 프리미엄쿠폰·캐스케이드+박).
> **외형 권위** = `docs/design/11가지상품옵션/product-sticker-option/Configurator.jsx`(288줄·사이즈·종이·인쇄·별색화이트·커팅·조각수·제작수량·후가공[귀돌이·오시·미싱·가변텍스트·가변이미지]).
> **데이터 권위** = 라이브 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + [[sticker-pipeline-260628]](option_items vs product_materials 함정).
> **대표 상품** = **PRD_000052 반칼 자유형 스티커**(고정가 by-siz_cd·PRF_STK_FIXED·종이/인쇄/커팅 CPQ).
> **가격 권위** = 서버 `evaluate_price`(:394) 불투명 결과. PRICE=0=결함. 디자인 가짜식((sizeBase+paperAdd)*qty/20) 폐기.

---

## ① 동형 판정 — C4(print) 대비

**판정: C4 캐스케이드+후가공 클래스에 동형(SAME CLASS) — 단 가격모델이 면적격자/공식형(print)이 아니라 고정가 by-siz_cd 단가표(스티커).**

| 축 | C4 대표(print PRD_000042) | sticker(PRD_000052 반칼자유형) | 동형 |
|----|---------------------------|--------------------------------|:---:|
| **핵심 구조** | 다단 cascade(옵션→하위)·FinishSection·택1패턴 | 사이즈·종이·인쇄·커팅 + FinishSection(후가공 5종) | ✅ **동형**(C4 정의축) |
| nonspec_yn | N(규격 고정) | N(반칼 규격 고정) | ✅ 동형 |
| 가격 차원 | PRF_DGP_A(공식형·COMP_PAPER 등 use_dims) | `[siz_cd,mat_cd,min_qty]` PRICE_TYPE.01 **고정가 by-siz_cd**(2,838행) | △ **변형**(공식형 vs 고정가표·둘 다 서버 불투명) |
| 가격공식 | PRF_DGP_A(디지털인쇄) | **PRF_STK_FIXED**(COMP_STK_PRINT·출력+가공 포함 통가격) | △ 별 comp(동형 입증 후 매핑) |
| 종이=자재 | OPT_000056 종이 8종(ref mat_cd·★오염) | OPT_000006 종이(ref mat_cd·**코팅=자재 흡수**·무광/유광코팅스티커=mat 행) | ✅ 동형(스티커 예외 S1) |
| 인쇄 | OPT_000055 단/양면 | OPT_000007 인쇄(단면 단일·GAP-HIDDEN 후보) | ✅ 동형 |
| 후가공 FinishSection | OPT_000057(오시/미싱/가변텍/가변이미지·inputs 줄수) | **OPT 미적재**(공정 PROC_000029~032 카탈로그 존재·PRD_000052 미바인딩) — (C) | △ **갭**(print는 적재·sticker 미바인딩) |
| 박/별색 | OPT_000058 박칼라·별색(일부 C) | 별색화이트(디자인)·DB 미적재 — (C) | △ 갭 |

→ **print의 C4 매핑 규칙(option_items.ref_dim 환원·sel_typ→multiple·mand_yn→required·필수공정 자동주입·FinishSection→finish-select-box·공정 inputs 파싱·sides=default·박없음 센티넬→토글 visible)을 그대로 상속.** 신규 클래스 불요. **★스티커 함정[HARD·[[sticker-pipeline-260628]]]:** 옵션그룹 상품은 시뮬레이터가 `option_items.ref_key1`(mat_cd)을 보고 가격 환원 — product_materials 직접이 아님. 어댑터는 OPV의 ref_key1(mat_cd)을 운반해야 COMP_STK_PRINT `[siz_cd,mat_cd,min_qty]` 단가표가 매칭됨.

---

## ② 그룹 델타 — 대표(print)에 없는 것만

C4 대표 명세 §1~§6 상속. **sticker 고유 추가분만 기술:**

| 델타 | sticker 고유 | 정규화 매핑 | DB 출처(PRD_000052) | 분류 |
|------|-------------|-------------|---------------------|------|
| **D1 고정가 by-siz_cd** | 가격=`[siz_cd,mat_cd,min_qty]` 단가표(print 공식형 아님·출력+가공 통가격) | siz_cd→가격축(area 아님)·서버 불투명 | COMP_STK_PRINT(PRICE_TYPE.01·2,838행) | **(A)** 서버내부·[[sticker-pipeline-260628]] |
| **D2 커팅(반칼)=필수공정 CPQ** | 반칼/도무송 등 커팅 택1 필수(print은 커팅 미적재 C) | `OptionGroup(OPT_000008·택1필수)` | OPT_000008 커팅(OPV ref PROC_000054 반칼) | **(A)↑** sticker가 커팅 적재(print 갭 해소) |
| **D3 커팅 사이즈/조각수(디자인)** | 30x278mm(8ea/5ea/4ea/3ea)·조각수 1~10 = **한 출력 시트를 N조각 분할** | `select-box`(조각수) | **DB 미적재**(조각수 CPQ 0행·면적당 분할 의미) — (C) | **(C)** arrylic 조각수 갭과 동형 |
| **D4 후가공 FinishSection(5종)** | 귀돌이·오시·미싱·가변텍스트·가변이미지(none/1/2/3개) | `finish-button`(귀돌이)·`finish-select-box`(오시/미싱/가변·inputs 줄수0~3) | **OPT 미바인딩**(PROC_000029~032 카탈로그 존재·inputs JSON 보유) — (C) | **(C)** print는 OPT_000057 적재·sticker 미바인딩(공정 inputs는 이미 존재) |
| **D5 별색화이트(단면)** | 화이트인쇄(단면) | `option-button`(택1) | **DB 미적재**(스티커 별색 미적재) — (C) | **(C)** print 별색5 갭과 동형 |
| **D6 코팅=자재 흡수(예외 S1)** | 무광/유광코팅 = 별도 옵션 아니라 **종이(자재) 행에 흡수** | 종이 OptionGroup에 코팅스티커 mat 포함(별 옵션 불요) | OPT_000006 종이(무광코팅 MAT_000155·유광 MAT_000156) | **(A)** ★스티커 예외(print은 코팅 별 옵션 C / sticker는 자재흡수로 해소) |

**핵심 차이(print→sticker):** ⓐ 가격이 **고정가 by-siz_cd 단가표**(공식형 아님) — 어댑터는 siz_cd+mat_cd(OPV ref_key1) 운반, 서버 불투명. ⓑ **커팅이 native 필수 CPQ로 작동**(print 커팅 갭 해소). ⓒ **코팅이 자재에 흡수**(print 코팅 별옵션 C가 sticker엔 불요·종이 옵션이 코팅mat 포함). ⓓ **후가공 FinishSection·조각수·별색은 PRD_000052에 미바인딩**(print은 후가공 OPT_000057 적재됨 — sticker 풀스펙은 바인딩 필요 C).

---

## ③ 라이브 대표 상품 1개 — PRD_000052 반칼 자유형 스티커

```
prd_typ=PRD_TYPE.01(완제품)·nonspec_yn=N · file_upload_yn=Y·editor_yn=N
min_qty=8·incr=8·max=10000 · qty_unit=QTY_UNIT.02(매)
sizes: SIZ_000170 A5(148x210) / SIZ_000196 A6(105x148) (반칼 규격)
materials(USAGE.07): MAT_000153 유포 / MAT_000084 / MAT_000242 미색 /
  MAT_000155 무광코팅 / MAT_000156 유광코팅  (★코팅=자재 흡수·D6)
print_options: POPT_000001 단면(CLR_000005 front)
processes: PROC_000054 반칼(커팅)
option_groups(CPQ): OPT_000006 종이(택1필수·ref mat_cd) / OPT_000007 인쇄(택1필수·단면단일·GAP-HIDDEN) /
  OPT_000008 커팅(택1필수·PROC_000054 반칼)
  ★조각수·별색화이트·후가공(귀돌이/오시/미싱/가변) = 미적재(C)
constraints: 0행 · addons: 0행
price_formula: PRF_STK_FIXED(use_yn=Y) → COMP_STK_PRINT([siz_cd,mat_cd,min_qty]·2,838행)
plate_sizes: SIZ_000007/050/057/521 (반칼 출력 칼선·전지)
```

**대표 선정 근거:** 종이/인쇄/커팅 CPQ 작동 + 고정가 by-siz_cd(sticker-pipeline 함정 실증) + FinishSection 디자인 폼의 후가공/조각수 갭을 가장 명확히 노출 → C4 후가공 캐스케이드의 sticker 특유 분기(반칼 커팅·코팅 자재흡수·후가공 미바인딩)를 traverse하며 **PRF_STK_FIXED 바인딩으로 견적 가능**. (대안 PRD_000055 낱장=C1 단순·이미 다른 클래스 대표.)

**componentType 사상(print 상속 + 델타):** `option-button`(사이즈·인쇄·커팅·별색) · `select-box`(종이·조각수) · `counter-input`(제작수량) · `finish-button`/`finish-select-box`(후가공 귀돌이/오시/미싱/가변·inputs 줄수) · `summary` · `upload-cta`(PDF)+에디터(editor_yn=N→디자인 폼 에디터버튼 불일치 C). color-chip/area-input=미사용(스티커 박/형압 없음).

---

## ④ evaluate_price 골든 (PRICE≠0)

디자인 가짜식((sizeBase+paperAdd)*qty/20·finishCost 25000 정액) **폐기**. 실가=PRF_STK_FIXED 고정가 단가표(siz_cd×mat_cd×수량tier·출력+가공 통가격).

```
NormalizedPriceRequest{ productCode:PRD_000052, priceSchemeKey:PRF_STK_FIXED(echo),
  dimensions:[{side:default, siz_cd}], materials{default:mat_cd(OPV ref_key1)}, quantity,
  selectedOptions:[{groupId:OPT_000008 커팅 PROC_000054}] }
  │ 어댑터 — ★OPV.ref_key1(mat_cd) 운반(product_materials 직접 아님·sticker 함정)·필수공정(반칼) 주입
  ▼
evaluate_price({prd_cd:PRD_000052},{siz_cd,mat_cd,print_opt_cd,proc_cd:[PROC_000054]},qty)
  │ PRF_STK_FIXED → COMP_STK_PRINT [siz_cd,mat_cd,min_qty] 단가표 조회(수량 tier)
  ▼
NormalizedPriceBreakdown{ ok, finalPrice, vat, shipping, lines[{code:COMP_STK_PRINT, amount}] }
```

| 케이스 | 입력(사이즈·자재·수량) | 단가표 매칭(min_qty tier) | 단가(verbatim) | PRICE |
|--------|------------------------|---------------------------|----------------|-------|
| A 소량 유포 | A5(SIZ_000170)·미색 MAT_000242·qty 4 | A5×미색×tier4 | **5,800** | **5,800** |
| B 다량 유포 | A5·미색·qty 200 | tier200 | **4,800** | **4,800** |
| C 무광코팅 | A5·MAT_000155·qty 1 | tier1 | **7,000** | **7,000** |
| D 유광코팅 다량 | A5·MAT_000156·qty 150 | tier150 | **6,000** | **6,000** |

> 단가(5,800·4,800·7,000·6,000)는 `t_prc_component_prices` COMP_STK_PRINT 라이브 verbatim(siz_cd×mat_cd×min_qty 단가표·비고 "B01 col1(A5)…"). 최종가는 evaluate_price가 수량tier 단가를 조회 — 정확값은 hw-qa 라이브 시뮬레이터(읽기전용 POST) 실측(거짓 수치 날조 금지·시뮬은 option_items.ref_key1 봄=[[sticker-pipeline-260628]]). ✅ **PRICE≠0 게이트 통과**(전 케이스 단가>0·PRF_STK_FIXED 바인딩 견적 가능).

---

## ⑤ 갭 (A)/(B)/(C) + 주문가능 4조건

### (A) 어댑터 흡수 — 계약/위젯 무변경 (print 상속 + 델타)
A1 OPV.ref_key1(mat_cd) 운반(★sticker 함정·고정가 by-siz_cd 매칭) · A2 필수공정 반칼(PROC_000054) 자동주입 · A3 sel_typ→multiple·mand_yn→required(상속) · A4 종이=자재 직매핑·**코팅 자재흡수(D6·print 코팅 C 불요)** · A5 인쇄 GAP-HIDDEN(단면단일→hidden-essential 후보) · A6 sides=default · A7 후가공 inputs(줄수0~3) 파싱(상속) · A8 고정가표는 서버 불투명(위젯 무지) · A9 수량 clamp(디자인 min10/step10≠DB min8/incr8 — DB 권위).

### (B) 계약 변경 필요 (**0**)
위젯 계약이 `option-button`·`select-box`·`finish-button`/`finish-select-box`·`InputSpec`(inputs)·`OptionGroup.multiple` **이미 보유** → **계약 변경 0건**(목표 달성·print과 동형).

### (C) DB 작성·교정 — §7 인간 승인 (4)
- **C-후가공 FinishSection 미바인딩(D4):** 귀돌이·오시·미싱·가변텍스트·가변이미지 — 공정(PROC_000029~032)·inputs JSON은 **카탈로그 존재**하나 PRD_000052에 OPT 미바인딩. print(OPT_000057)에서 검증된 규칙 그대로 바인딩(동형 전파).
- **C-조각수(D3):** 조각수 CPQ 옵션그룹 미적재(한 출력시트 N조각 분할·가격/생산 영향). arrylic 조각수 갭과 동일 (C) — 공통 처리.
- **C-별색화이트(D5):** 화이트인쇄(단면) 옵션/공정 미적재. print 별색5 갭과 동형.
- (참고) C-editor_yn: 디자인 에디터 버튼 ↔ DB editor_yn=N 불일치(에디터 제공 시 Y·아니면 위젯 숨김). print과 동형.
- **자재 오염 주의:** print(OPT_000056) 5종 mat_cd 오염 이슈 — sticker OPT_000006은 종이/코팅 mat가 정상(현 스냅샷 오염 미발견)이나 §7 적재 시 ref_key1 mat_cd 정합 확인 권고.

### 주문가능 4조건 (PRD_000052 현재)
| 조건 | 충족 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 구동 | **부분** | 사이즈·종이(코팅포함)·인쇄·커팅 = 라이브 CPQ 구동 ✅ / 조각수·별색·후가공5 = 미적재(C) ❌ |
| ⓑ 제약 6종 강제 | **충족(주의)** | ⑥필수(종이·인쇄·커팅 택1)·④size·②quantity 강제 ✅(A) / ⑤택1 후가공·조각수 갭(C) ⚠ |
| ⓒ PRICE≠0 | **충족** | PRF_STK_FIXED 바인딩·단가 4,800~7,000>0 ✅(★ref_key1 mat_cd 운반 필수) |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립(siz_cd·mat_cd·커팅 운반)·PDF CTA ✅ / 에디터버튼 DB 불일치(C) |

**판정: 부분 주문가능(PARTIAL·본체 견적 가능).** 스티커 본체(사이즈·종이/코팅·인쇄·커팅)는 **C4 종단이 동작**(PRICE≠0·커팅 필수CPQ 작동·코팅 자재흡수·계약 변경 0). 풀스펙(후가공 FinishSection·조각수·별색) 주문가능화 병목은 **(C) 3건**(후가공 바인딩·조각수·별색 — 전부 print/arrylic에서 검증된 동형 규칙) — 위젯/계약/어댑터 준비 완료(B 0건). **★핵심 함정:** 어댑터는 OPV.ref_key1(mat_cd) 운반 필수(고정가 by-siz_cd 매칭·[[sticker-pipeline-260628]]).

**다음 권고:** ① §7 dbmap에 C 3건(후가공 OPT 바인딩·조각수 CPQ·별색) 적재명세 인계(print OPT_000057 규칙 동형 전파) → ② 적재 후 어댑터 재조립 검증 → ③ hw-builder createHuniAdapter(★ref_key1 mat_cd 운반 분기 주의).
