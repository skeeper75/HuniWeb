# calendar-propagation.md — 캘린더(C4 캐스케이드+추가) 동형 전파 (경량)

> 파이프라인 ③' 컨버전 선행 · **경량 전파**(동형 판정+델타+대표+갭만·전체 재유도 금지·코드 0줄).
> **클래스 대표(동형 기준)** = C4 `../digital-print/print-form-spec.md`(PRD_000042 프리미엄쿠폰·27필드·캐스케이드+박·evaluate_price).
> **외형 권위** = `docs/design/11가지상품옵션/product-calendar-option/Configurator.jsx`(247줄·사이즈·종이·인쇄·장수·삼각대컬러·캘린더가공·링컬러·제작수량·개별포장·캘린더봉투·ColorChip×블랙/그레이 삼각대·블랙/실버/화이트 링).
> **데이터 권위** = 라이브 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + §29 readiness scorecard.
> **가격 권위** = 서버 `pricing.py:evaluate_price`(:394) 불투명 결과. PRICE=0=결함.
> **계약 목표** = 위젯 가시 계약 변경 0 — color-chip(삼각대/링)·area는 기보유 슬롯. 어댑터(`createHuniAdapter`) 흡수.
> **라이브 대표** = **PRD_000108 탁상형캘린더** (design 기본 `process=twinring`=트윈링제본 직대응·삼각대 R1=MAT_000252 싸바리·트윈링 PROC_000021 보유).

---

## ① 동형 판정 (C4 print 대비)

**판정: △ 준동형(C4-cascade) — 폼 구조·캐스케이드·추가상품·가격모델은 C4와 동형, 그러나 라이브 적재 성숙도가 C4보다 더 낮음(가격 미바인딩).**

| 동형 축 | C4 print(PRD_000042) | calendar(PRD_000108) | 동형? |
|---------|---------------------|----------------------|:--:|
| 위젯 렌더 모델 | 단일면 default·option-button/select-box/color-chip/area 조합 | 동일(단일면·내지 없음) | ✅ |
| **캐스케이드** | 박있음→박크기/박칼라 visible(③ 토글) | **가공=트윈링→링컬러 visible**(③ 토글, JSX `{process==="twinring" && 링컬러}`) | ✅ **동형**(같은 토글→하위 visible) |
| 추가상품 | 엽서봉투 addon(SelectBox×2 봉투+수량) | **캘린더봉투 addon**(SelectBox×2 봉투+수량) — 구조 동일 | ✅ **동형** |
| color-chip | 박칼라 7종(ColorChip) | **삼각대컬러 2종 + 링컬러 3종**(ColorChip) — 같은 슬롯 | ✅ 동형(데이터만 다름) |
| 가격모델 | evaluate_price 단일상품·PRICE≠0 | evaluate_price 단일상품 **이어야 하나 라이브 미바인딩**(§델타) | ❌ **깨짐**(가격) |
| CPQ 옵션 적재 | 4그룹 적재(사이즈/종이/인쇄/후가공/박칼라) | **0그룹**(option_groups 전무) | ❌ **깨짐**(C4보다 미성숙) |

→ **위젯/계약/어댑터 관점은 C4와 동형**(매핑 규칙 전파 가능): 토글 캐스케이드=VisibilityRule·color-chip 2슬롯·addon 템플릿·area 전부 print-form-spec 규칙 그대로. **차이는 전부 (C) DB 미적재** — calendar는 print(부분주문가능)보다 **한 단계 더 비어있다**(CPQ 0·가격 미바인딩). 동형 클래스는 유지하되 calendar 대표는 **C4-cascade의 "데이터 미성숙 변종"**으로 분류.

---

## ② 그룹 델타 (calendar 고유 — print 대비)

print-form-spec와 **다른 항목만** 기재(공통 6부 구조·componentType 사상·주문가능 정의는 print 명세 상속).

| 델타 | calendar 값 | print 대비 | 분류 |
|------|------------|-----------|------|
| **삼각대컬러** ColorChip 블랙/그레이 | 라이브 자재 MAT_000252(삼각대 싸바리·R1) 존재·colorHex 부재 | print 박칼라와 동형 슬롯(`color-chip`)·옵션그룹 미생성 | (A) color-chip 슬롯 / (C) colorHex+CPQ |
| **링컬러** ColorChip 블랙/실버/화이트 | 가공=twinring일 때만 visible(③ 캐스케이드)·라이브 MAT_000253(링 블랙·R1)·PROC_000021 트윈링제본 | print 박칼라+박토글 cascade와 동형 | (A) VisibilityRule+color-chip / (C) CPQ |
| **캘린더 가공** process(가공없음/트윈링/2구타공+끈) | OptionButton=`option-button`·라이브 108=PROC_000076만, 111=PROC_000021+PROC_000079(타공) | print 후가공(option-button)과 동형·**가공값이 캐스케이드 트리거** | (A) option-button / (C) 가공 CPQ 미생성 |
| **장수** sheets(7/13/14장) | `select-box`(SelectBox)·**page-counter 아님**(고정 enum 3종)·라이브 page_rules 부재 | print엔 없음(달력 고유)·셋트 내지페이지(book)와 다름(enum 선택) | (C) 장수 CPQ 미생성 |
| **봉투addon** 캘린더봉투 240x230 10장 | print 엽서봉투와 **구조 동일**(SelectBox 봉투+수량)·라이브 product_addons 0행 | print C-봉투 갭과 동일 | (C) addon 템플릿 미연결 |
| **개별포장** 없음/수축포장 | `select-box`·PROC_000076 수축포장 존재(108 보유) | print엔 미노출·calendar는 PROC_000076 라이브 보유 | (A/C) 옵션그룹 미생성이나 공정 존재 |
| **사이즈** 220x145/130x220 | 라이브 108=SIZ_000069(220x145)/SIZ_000070(130x220) **디자인 2종 = DB 2종 일치** ✅ | print(디자인7 vs DB2 불일치)보다 **일치**(calendar 강점) | (A) 직매핑 |
| **종이** 스노우200/몽블랑190/랑데뷰250 | 라이브 자재축 별도 실측 필요(option_items 0) | print 종이(자재오염)와 달리 **calendar 자재오염 미발견**(R1=삼각대/링은 가공자재·정상) | (A) / (C) CPQ |

**델타 핵심:** calendar는 **삼각대컬러·링컬러 = 2개의 color-chip 축**(print는 박칼라 1축)이고, **가공=트윈링→링컬러 cascade**가 print의 박토글 cascade와 정확히 동형이다. 추가상품(캘린더봉투)도 print 엽서봉투와 1:1. **신규 위젯 슬롯 0**(color-chip·option-button·select-box·VisibilityRule·addon 전부 기보유).

---

## ③ 라이브 대표 상품 1개 — PRD_000108 탁상형캘린더

| 속성 | 라이브 실측값 | 비고 |
|------|--------------|------|
| prd_typ | PRD_TYPE.01 완제품 | semi_role ∅ |
| 업로드 | file_upload_yn=Y · editor_yn=N | CTA=PDF 단독(design "PDF파일 직접 올리기"만·에디터버튼 없음 → DB 일치 ✅) |
| 수량 | min1·max10000·incr1·QTY_UNIT.01 | design min10/step10/max2000 ≠ DB(★DB 권위) |
| 사이즈 | SIZ_000069(220x145)·SIZ_000070(130x220) 2종 | design 2종과 일치 ✅ |
| 가공(process) | PROC_000076 수축포장(108)·트윈링=PROC_000021(라이브 트윈링제본 존재) | design twinring=PROC_000021 |
| 삼각대/링 자재 | MAT_000252 삼각대(싸바리)·MAT_000253 링(블랙) | R1 readiness 근거 |
| option_groups | **0행**(CPQ 전무) | (C) |
| 가격공식 | **미바인딩**(product_price_formulas 0행) | (C) **PRICED-0 BLOCKED** |
| §29 등급 | **L1·완성률 33.0%**·위젯클래스=TBD·`calc=UNBOUND-PRICE-IN-SHEET·pfm=DESIGN_BLOCKED` | 가격 미설계 |

> 대표 선정 근거: ① design 기본 경로 `process=twinring`=트윈링제본이 108/111 라이브 PROC_000021에 직대응 ② 삼각대컬러(R1=MAT_000252)·트윈링제본 라이브 보유로 calendar 폼의 cascade·color-chip 분기를 traverse ③ 형제(109 미니탁상/111 벽걸이/112 와이드/110 엽서) 동형. **단 108은 가격 미바인딩(L1)이라 종단 PRICE≠0 미달** — 대표지만 주문불가(④ 참조).

---

## ④ 가격 골든 (evaluate_price) — ❌ PRICE=0 결함 신호 [HARD]

```
NormalizedPriceRequest { productCode:PRD_000108, priceSchemeKey:(미바인딩),
  dimensions:[{side:default, 220x145}], materials{default:몽블랑190}, quantity:20,
  selectedFinishes:[가공=트윈링·삼각대=블랙·링컬러=블랙] }
   │ 어댑터 createHuniAdapter (print arm 동형)
   ▼
evaluate_price({prd_cd:PRD_000108}, {...}, 20)   [pricing.py:394]
   ▼
❌ final_price = 0  (product_price_formulas 0행 → 공식 미바인딩 → PRICED-0)
```

- **PRICE=0 = 결함 신호 [HARD]** ([[huni-widget-red-price-never-zero]]). calendar 대표 108은 §29 `calc=UNBOUND-PRICE-IN-SHEET·pfm=DESIGN_BLOCKED` — 가격공식이 라이브에 **설계·바인딩 안 됨**. design subtotal 75000은 가짜 정액(폐기 대상).
- **골든 날조 금지**: print(PRD_000042)는 동형 frm(PRF_DGP_A) 상속으로 PRICE≠0 골든이 있었으나, **calendar는 라이브 가격공식 자체가 부재** → PRICE≠0 골든 산출 불가(거짓 수치 날조 금지).
- **해소 경로(C·인간 승인)**: §18 가격엔진 설계(달력 가격공식 PRF_CAL_* 설계: 사이즈×종이×장수×가공) → §7 적재 → 그 후에야 evaluate_price PRICE≠0 가능. **calendar는 가격 종단 미완(§27 가격 파이프라인 BLOCKED)**.

✅ 동형 경로(어댑터/계약)는 print와 동일하게 준비 / ❌ **PRICE≠0 게이트 미통과**(가격 미바인딩).

---

## ⑤ 갭 (A)/(B)/(C) + 주문가능 4조건

### 갭 분류
- **(A) 어댑터 흡수 — 계약/위젯 무변경**: A1 사이즈 직매핑(DB 2종=design 2종 ✅)·A2 수량 DB 권위(min1/incr1)·A3 가공→트윈링 cascade(VisibilityRule)·A4 삼각대/링 color-chip 2슬롯·A5 봉투 addon 템플릿 경로(print 동형)·A6 PDF CTA(editor_yn=N·design 일치)·A7 PRICE=0 진단·A8 vat/shipping. (print-form-spec A1~A12 전파)
- **(B) 계약 변경 필요 = 0**: color-chip(삼각대/링)·VisibilityRule(가공 cascade)·addon 슬롯 모두 기보유 → **계약 변경 0(목표 달성)**.
- **(C) DB 작성·교정 — §18/§7 인간 승인 (핵심·print보다 1단계 더)**:
  - **C-가격 🔴 [최우선]**: 108/109/111/112 **가격공식 미바인딩**(PRICED-0·DESIGN_BLOCKED) — §18 달력 가격공식 설계→§7 적재. **주문가능화 절대 선행 조건**.
  - C-CPQ 옵션그룹 0: 사이즈·종이·인쇄·장수·가공·삼각대·링 = 전 옵션 CPQ 미생성(§7).
  - C-콜로헥스: 삼각대/링 colorHex 컬럼 적용(print C-colorHex 동형·added-schema §7).
  - C-봉투 addon: 캘린더봉투 product_addons⋈템플릿 연결(0행·print C-봉투 동형).
  - C-장수 enum: 7/13/14장 옵션그룹(page_rules 부재·고정 enum).
  - C-개별포장: 수축포장 옵션그룹(PROC_000076 라이브 존재·연결만).

### 주문가능 4조건 (PRD_000108 현재)
| 조건 | 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | ❌ **미충족** | option_groups 0행(CPQ 전무)·사이즈/자재만 차원행 존재 |
| ⓑ 제약 6종 데이터 강제 | ❌ **미충족** | constraints 0행·가공cascade/필수 미적재 |
| ⓒ PRICE≠0 | ❌ **미충족** | 가격공식 미바인딩 → final=0(PRICED-0·DESIGN_BLOCKED) |
| ⓓ 유효 페이로드 | △ 부분 | NormalizedCartHandoff 구조 조립 가능(PDF CTA)·priceSnapshot 0 무효 |

**판정: 주문불가(NOT ORDER-CAPABLE) — 가격 미바인딩 BLOCKED.** calendar는 위젯/계약/어댑터는 C4 print와 **완전 동형으로 준비**(B=0·color-chip/cascade/addon 기보유)이나, 라이브 데이터가 **print보다 한 단계 더 비어** 있다 — CPQ 0그룹 + **가격공식 자체 미설계(L1·33%)**. **병목 = §18 달력 가격공식 설계→§7 적재(C·돈크리티컬 최우선)**. 그 선행 없이는 PRICE≠0 불가하여 주문 불가능.

**다음 권고:** ① §18에 달력 가격공식(사이즈×종이×장수×가공 PRF_CAL_*) 설계 인계 → §7 적재 → ② CPQ 옵션그룹 7종 적재(사이즈/종이/인쇄/장수/가공/삼각대/링) → ③ 적재 후 어댑터 print arm 동형 전파(VisibilityRule·color-chip 2슬롯·봉투 addon)로 NormalizedProduct 재조립 → PRICE≠0 재검증 → ④ 형제 109/111/112/110 전파. 코드 구현은 가격 적재 후.

---

## 부록: 동형 전파 노트 (calendar 형제)
| 형제 | 차이 | 동형 |
|------|------|:--:|
| PRD_000109 미니탁상형 | 사이즈만 상이·L1 동일 가격 BLOCKED | ✅ 108 규칙 그대로 |
| PRD_000111 벽걸이 | 가공=트윈링(PROC_000021)+타공(PROC_000079)·삼각대 없음(벽걸이) | △ 삼각대 미노출·링/타공만 |
| PRD_000112 와이드벽걸이 | 111 동형·사이즈 큼 | △ |
| PRD_000110 엽서캘린더 | editor_yn=N·사이즈 상이 | △ 종이형(삼각대/링 없음) |
**전파 원칙:** 전 calendar 형제가 **가격 미바인딩(L1 BLOCKED)** 공통 → §18 가격설계가 클래스 전체 선행. 벽걸이류는 삼각대 미노출(탁상만 삼각대), 트윈링/타공만 cascade.
