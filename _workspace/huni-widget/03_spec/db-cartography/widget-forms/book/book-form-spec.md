# book-form-spec.md — 책자(C5·셋트조립) 위젯 폼 주문가능 종단 명세

> 파이프라인 ③' 컨버전 선행 · 명세까지(코드 0줄·다음 승인).
> **외형·제약 의도 권위** = `docs/design/11가지상품옵션/product-book-option/Configurator.jsx`(20필드·432줄·면별·제본cascade·박/형압).
> **데이터 권위** = 라이브 DB 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + §23 set-product COMMIT분 재사용.
> **가격 권위** = 서버 `pricing.py:evaluate_set_price`(:844) 불투명 결과(구성원별 evaluate_price 합산 + 셋트 제본공식). t_prc_* 위젯 포팅 금지. PRICE=0=결함·이중합산 0.
> **계약 목표** = 위젯 가시 계약 변경 0 — 면별=`ProductSide[default,inner]`(기존 계약)·매핑은 어댑터(`createHuniAdapter`)가 흡수.
> 대표 상품 = **PRD_000069 무선책자** (소프트커버 분해형 셋트·§23 라이브 COMMIT 동작분 138,688원 · cover_mult=1 펼침 · page_rule 24~300/+2 = 디자인 "최소24P~최대300P" 일치).
> 동형 클래스 형제 = 068중철·070PUR(분해형 cover_mult=1·PRF_BOOK_COVER 재사용)·072/077하드커버(통합 COVERBIND)·071트윈링/082(ring·cover_mult ×2 BLOCKED).
> 상위 분석 = `../../widget-forms-approach.md`(11폼·제약6종·주문가능4조건) · 선례 = `../digital-print/print-form-spec.md`(동일 6부 구조).

---

## 0. 대표 상품 선정 근거 (PRD_000069 무선책자)

책자 design JSX는 **20필드 폼**(사이즈·제본·제본방향[좌철/상철]·링컬러·링선택·면지·제작수량·내지[종이·인쇄·페이지]·표지[종이·인쇄·코팅]·투명커버·박표지[on/크기/칼라]·형압[양/음각/크기]·개별포장)이다. 이 폼은 **여러 제본방식의 superset을 한 화면에 합쳐 놓은 디자인 프로토타입**이다 — 무선제본 기본 + 상철 시 링(트윈링) cascade + 면지(하드커버 전용) + 투명커버까지 한 폼에. 라이브 DB는 이를 **제본방식별 독립 상품**으로 분리 적재(068중철·069무선·070PUR·071트윈링·072/077하드커버·082트윈링하드커버·088레더링바인더).

**PRD_000069 무선책자를 대표로 선정한 4가지 이유:**
1. **design JSX 기본 경로** — JSX `bind` 기본값=`wireless`(무선제본). 위젯 첫 렌더 상태가 069에 직접 대응.
2. **§23 라이브 COMMIT 동작분** — 069는 저청구→**138,688원**(표지88,688+제본MUSEON 50,000)으로 evaluate_set_price PRICE≠0 동작 입증됨([[leather-hardcover-077-live-commit-260701]]). 골든 날조 불필요.
3. **셋트 분해형 정석 구조** — 부모(제본비) + 표지 member(PRF_BOOK_COVER 3비목) + 내지 member(PRF_DGP_INNER 인쇄+용지). 면별 분해(ProductSide)와 셋트 구성원(t_prd_product_sets)이 1:1로 드러나는 C5 교과서.
4. **내지 페이지 = 디자인 일치** — 069 page_rule `24~300/+2` = design JSX `QuantityStepper min={24} step={2} max={300}` verbatim 일치(다른 형제는 8~100 등 상이).

**라이브 실측 PRD_000069 셋트 구성(스냅샷·t_prd_product_sets):**
```
부모 PRD_000069 무선책자 (prd_typ=PRD_TYPE.01 완제품·semi_role=∅·file_upload_yn=Y·editor_yn=N
  min_qty=2·max_qty=1000·qty_incr=1·qty_unit=QTY_UNIT.03(권))
  부모공식 PRF_BIND_MUSEON = COMP_BIND_MUSEON (제본비 합산형·수량구간×무선제본 단가)
  ├─ member PRD_000290 무선책자-표지 (prd_typ=PRD_TYPE.02 반제품·sub_prd_qty=1·disp_seq=1·min/max_cnt=1[1권고정])
  │     공식 PRF_BOOK_COVER = COMP_PRINT_DIGITAL_S1(표지인쇄) + COMP_COAT_MATTE(표지코팅) + COMP_PAPER(표지용지)
  │     cover_mult=1(펼침)·판형 SIZ_000499(A3펼침 pansu=1)·S8 오염 가드(굿즈/명함 후가공 comp 무혼입)
  └─ member PRD_000289 무선책자-내지 (prd_typ=PRD_TYPE.02 반제품·sub_prd_qty=1·disp_seq=2·page 24~300/+2)
        공식 PRF_DGP_INNER = COMP_PRINT_DIGITAL_S1(내지인쇄·판수밴드×판수) + COMP_PAPER(내지용지·절가×출력매수)
        위젯 qty = derive_inner_sheets(부수, page, pansu) — 호출자 산출 자유 qty(evaluate_set_price member qty)

사이즈: SIZ_000170 A5(148x210·del_yn=Y 논리삭제) / SIZ_000172 A4(210x297·활성)  → 위젯은 활성 A4만, A5는 §3 갭
내지자재(289 USAGE.07): MAT_000074 백모220g(dflt) + 081/082/091/092/109 (6종)
표지자재(290 USAGE.01): MAT_000073 백모120g(dflt) + 077/087/095/096/104/105 (7종)
내지인쇄(289): POPT_000001단면칼라/002양면칼라/008단면흑백/009양면흑백(dflt) ★4종
표지인쇄(290): POPT_000001단면칼라(dflt)/002양면칼라 ★2종
option_groups(부모 069·8그룹): OPT_000013사이즈 / 014내지종이 / 015내지인쇄 / 016표지종이 /
  017표지인쇄 / 018표지코팅(min0) / 019박형압(SEL_TYPE.02 다중·max10) / 020제본(택1필수)
constraints: 0행(069·289·290 전부 미적재) · addons: 0행
page_rules: 069=24/300/2
면지(endpaper)·투명커버·링: 069 무선엔 set member/옵션그룹 부재(→ §1·§3 갭)
```

> ★주의: design JSX `면지`(화이트/그레이/블랙/인쇄)·`투명커버`·`링컬러/링선택`은 069 무선에 **라이브 부재**다(면지=하드커버 077/088 전용 member·링=트윈링 071/082 전용). 이는 design이 superset이라 발생하는 **디자인↔DB 면별 갭**(§3에 분류). 위젯은 DB 권위(069는 면지/투명커버/링 비노출).

---

## 1. 폼 필드 인벤토리 → 정규화 계약 매핑 (20 필드 전수) — ★면별 분해 핵심

각 OptionField → `OptionGroup`(또는 InputSpec/박묶음). componentType=DESIGN.md 14종 사상. **side = 면별 분해(`ProductSide`)** = C5 핵심. 책자는 `sides=[{key:'default',label:'표지',uploadType},{key:'inner',label:'내지',uploadType}]` 2면.

### 1.1 면(side) ↔ 셋트 구성원(member) ↔ semi_role 매핑 [ⓐ 핵심]

| 위젯 side(ProductSide) | label | 셋트 member(t_prd_product_sets) | semi_role(설계의도) | 공식 | 옵션그룹(부모 069에 표면화) |
|------------------------|-------|--------------------------------|---------------------|------|---------------------------|
| `default` | 표지 | PRD_000290 무선책자-표지 (disp_seq=1·1권고정) | 표지(cover) | PRF_BOOK_COVER(3비목) | 표지종이016·표지인쇄017·표지코팅018·박형압019 |
| `inner` | 내지 | PRD_000289 무선책자-내지 (disp_seq=2·page 24~300) | 내지(inner) | PRF_DGP_INNER(인쇄+용지) | 내지종이014·내지인쇄015 + 페이지(page_rules) |
| (면별 아님·부모) | — | PRD_000069 부모 자체 | 완제품(set) | PRF_BIND_MUSEON(제본비) | 사이즈013·제본020·제작수량·개별포장 |
| (069 부재·갭) | 면지 | (077/088 member·069 없음) | 면지(endpaper) | (무료·COVERBIND 흡수) | — (069 미노출·§3 갭) |
| (069 부재·갭) | 투명커버 | (member 부재) | — | — | — (§3 갭) |

> ★`semi_role_cd` 컬럼은 라이브 `t_prd_products`에 **부재**(스냅샷 header에 semi_role_cd 컬럼 존재하나 069 member 전부 공란). 면별 역할 구분은 ⓐ`t_prd_product_sets.note`("표지=…"/"내지=…") + ⓑ member 공식(PRF_BOOK_COVER=표지·PRF_DGP_INNER=내지) + ⓒ disp_seq로 어댑터가 파생(A). semi_role_cd 정식 적재는 (C) 권고이나 현재 note+공식으로 무손실 파생 가능.

### 1.2 20 필드 → componentType 매핑

| # | JSX 필드(state) | 디자인 컴포넌트 | 정규화 componentType | side | required | visible | values 출처(라이브 069) | InputSpec |
|---|----------------|----------------|----------------------|------|:--:|:--:|------------------------|-----------|
| 1 | 사이즈 size | OptionButtonGroup(2열) | `option-button` | default(상품공통) | Y | Y | sizes ⋈ siz_sizes (SIZ_000172 A4·★A5 170 del_yn=Y) | — |
| 2 | 제본 bind | OptionButtonGroup(무선만) | `option-button` | — | Y | Y | OPT_000020 제본 택1필수(069=무선 단일) | — |
| 3 | 제본방향 bindDir | OptionButtonGroup(좌철/상철) | `option-button` | — | Y | Y | **CPQ 부재**(069 무선=좌철고정·상철=링상품 071) — (C/A) | — |
| 4 | 링컬러 ringColor | RingColor(실버/블랙/골드) | `color-chip` | — | 조건 | bindDir==top | **069 부재**(링=트윈링 071/082) — (C) | colorHex=(C) |
| 5 | 링선택 ring | RingSelect(D링×3) | `image-chip` | — | 조건 | bindDir==top | **069 부재** — (C) | imageUrl=(C) |
| 6 | 면지 endpaper | OptionButtonGroup(화이트/그레이/블랙/인쇄) | `option-button` | (면지면) | N | Y | **069 부재**(면지=077/088 member·무료) — (C) | — |
| 7 | 제작수량 qty | QuantityStepper(min10·step10·max2000) | `counter-input` | — | Y | Y | products.{min2,max1000,incr1}_qty (★디자인≠DB) | min2·max1000·step1 |
| 8 | 내지종이 innerPaper | SelectBox(badge추천·+가격) | `select-box` | **inner** | Y | Y | OPT_000014 ⋈ 289 materials USAGE.07 (6종) | — |
| 9 | 내지인쇄 innerPrint | OptionButtonGroup(단/양면) | `option-button` | **inner** | Y | Y | OPT_000015 ⋈ 289 print_opt (4종 칼라/흑백 단양) | — |
| 10 | 내지 페이지 pages | QuantityStepper(min24·step2·max300) | `page-counter-input` | **inner** | Y | Y | page_rules 069 (24/300/2) ✅ 디자인 일치 | min24·max300·step2 |
| 11 | 표지종이 coverPaper | SelectBox(+가격) | `select-box` | **default(표지)** | Y | Y | OPT_000016 ⋈ 290 materials USAGE.01 (7종) | — |
| 12 | 표지인쇄 coverPrint | OptionButtonGroup(단/양면) | `option-button` | **default(표지)** | Y | Y | OPT_000017 ⋈ 290 print_opt (2종) | — |
| 13 | 표지코팅 coverCoat | OptionButtonGroup(없음/무광단/유광단) | `option-button` | **default(표지)** | N | Y | OPT_000018 표지코팅(min0)·공식 COMP_COAT_MATTE 존재 | — |
| 14 | 투명커버 clearCover | OptionButtonGroup(없음/유광/무광) | `option-button` | default(표지) | N | Y | **069 부재**(투명커버 member/옵션 미적재) — (C) | — |
| 15 | 박(표지) on/off foilOn | OptionButtonGroup(있음/없음) | `option-button` | default(표지) | N | Y | OPT_000019 박형압(SEL_TYPE.02 다중)·박없음=미선택으로 표현 | — |
| 16 | 박(표지) 크기 foilW/H | TextField×2(가로30~125/세로30~170) | `area-input` | default(표지) | 조건 | foilOn==on | **DB 없음**(박크기=GAP-PARAM·OPT_000019 note "크기 param=GAP-PARAM 미반영") — (C) | W30~125·H30~170 |
| 17 | 박(표지) 칼라 foilColor | ColorChip×2(먹유광/홀로그램) | `color-chip` | default(표지) | 조건 | foilOn==on | OPT_000019 박옵션(PROC_037~044·먹유광040·홀로37) | colorHex=(C) |
| 18 | 형압 stamp | OptionButtonGroup(없음/양각/음각) | `option-button` | default(표지) | N | Y | OPT_000019 박형압 다중(형압=PROC_045계열)·**형압 항목 미생성** — (C) | — |
| 19 | 형압크기 stampW/H | TextField×2(가로30~125/세로30~170) | `area-input` | default(표지) | 조건 | stamp!=none | **DB 없음**(GAP-PARAM) — (C) | W30~125·H30~170 |
| 20 | 개별포장 pack | SelectBox(없음/수축포장) | `select-box` | — | N | Y | **CPQ 부재**(개별포장 옵션그룹 미생성) — (C) | — |
| — | (어댑터 생성) 내지페이지→inner.qty | (없음) | (계약 pageCount) | inner | Y | hidden | derive_inner_sheets(부수,page,pansu) → member qty | — |
| — | (어댑터 생성) 요약 | PriceSummary | `summary` | — | — | — | evaluate_set_price breakdown | — |

**계약/DB 매핑 요약(20필드):**
- **완전 매핑(라이브 데이터 채움 가능·8)**: 사이즈(1)·제본(2)·제작수량(7)·내지종이(8)·내지인쇄(9)·내지페이지(10)·표지종이(11)·표지인쇄(12). + 어댑터 생성 inner.qty/요약.
- **부분 매핑(옵션 있으나 갭·3)**: 표지코팅(13·옵션그룹 있고 공식 COMP_COAT_MATTE 존재)·박on/칼라(15/17·OPT_000019 박옵션 적재·박크기 GAP-PARAM)·형압(18·박형압 그룹에 형압항목 미생성).
- **미매핑(DB·CPQ 부재→갭·9)**: 제본방향(3)·링컬러(4)·링선택(5)·면지(6)·투명커버(14)·박크기(16)·형압크기(19)·개별포장(20). + 박/형압 area 파라미터. design superset의 링/면지/투명커버가 069 무선 범위 밖(다른 상품 적재).

---

## 2. 옵션 데이터 → 라이브 DB 바인딩 (디자인 값 ↔ 라이브 069 값 대조)

| 옵션 | 디자인 하드코딩 값 | 라이브 출처(PRD_000069) | 일치/불일치 |
|------|-------------------|------------------------|-------------|
| 사이즈 | 2종(A5 148x210·A4 210x297) | SIZ_000172 A4(활성) / SIZ_000170 A5(★del_yn=Y 논리삭제) | △ **부분** — 디자인 2종 vs DB 활성 1종(A4). A5는 라이브 논리삭제 → 위젯 A4만(또는 A5 복원=C) |
| 제본 | 무선제본 1종 | OPT_000020 제본 택1(069=무선 단일) | ✅ 일치 |
| 제본방향 | 좌철/상철 2종 | **CPQ 부재**(069 무선=상철=링상품으로 분리) | ❌ **갭(C/A)** — 무선=좌철 고정, 상철 선택 시 071 트윈링으로 가는 cascade는 DB상 별개 상품(§3) |
| 내지종이 | 3종(몽블랑190·랑데뷰250·아트150) | 6종(백모220·아트120 외 4종·MAT USAGE.07) | ❌ **불일치**(상품별 종이 상이). 위젯은 DB 6종 |
| 내지인쇄 | 단/양면 2종 | 4종(단면칼라001/양면칼라002/단면흑백008/양면흑백009·dflt=흑백양면) | △ **DB가 더 많음**(흑백분기 추가)·위젯은 DB 4종 |
| 내지페이지 | min24/step2/max300 | page_rules 24/300/2 | ✅ **완전 일치**(대표 선정 근거) |
| 표지종이 | 3종(몽블랑190·랑데뷰250·아트230) | 7종(백모120 외 6종·MAT USAGE.01) | ❌ **불일치**·위젯은 DB 7종 |
| 표지인쇄 | 단/양면 2종 | POPT_000001단면/002양면(2종) | ✅ 일치 |
| 표지코팅 | 3종(없음/무광단/유광단) | OPT_000018(min0)·공식 COMP_COAT_MATTE | △ 부분 — 옵션그룹 존재·코팅종류 항목 충전도 확인 필요(C) |
| 투명커버 | 3종(없음/유광/무광) | **069 부재**(member/옵션 미적재) | ❌ **갭(C)** |
| 면지 | 4종(화이트/그레이/블랙/인쇄) | **069 부재**(면지=077/088 member·무료) | ❌ **갭(C)** — 소프트커버 면지0(설계의도·077 무료) |
| 박칼라 | 2종(먹유광/홀로그램) | OPT_000019 박옵션 8항(PROC_037~044) | △ **의미 근접**(먹유광=PROC_040·홀로=037)·colorHex 부재(C) |
| 형압 | 없음/양각/음각 | OPT_000019에 형압항목 **미생성** | ❌ **갭(C)** |
| 링컬러/링선택 | 실버/블랙/골드·D링×3 | **069 부재**(링=트윈링 071/082) | ❌ **갭(C)** — 무선책자에 링 없음(상품 분리) |
| 개별포장 | 없음/수축포장 | **CPQ 부재** | ❌ **갭(C)** |
| 수량 | min10/step10/max2000 | min2/incr1/max1000·단위=권 | ❌ **불일치** — 위젯은 DB값(권 단위·증분1) 권위 |

**★자재 오염 점검(069):** 069 내지/표지 자재는 백모조지·아트지 계열(MAT_TYPE.01 종이)로 정상 — 디지털인쇄 PRD_000042 같은 굿즈자재(면끈/키링) 오염 **없음**. 책자 셋트는 자재 오염 청정(돈크리티컬 가드 통과). 단 표지/내지 자재축 분리(USAGE.01 표지 vs USAGE.07 내지)가 어댑터의 side 라우팅 키.

---

## 3. 제약 추출·정규화 (★핵심·6종 + ⓑ 제본 cascade) — 디자인 의도 ↔ 라이브 ↔ 갭

069는 `t_prd_product_constraints` **0행**(069·289·290 전부)이다. 책자 폼의 차별적 제약 = **ⓑ 제본방향 cascade(상철→링)** 와 **면별 종이/인쇄 분리** 다.

### 3.1 ⓑ 제본 cascade 제약 (책자 C5 고유) [핵심]

design JSX `{bindDir === "top" && (링컬러/링선택)}` = **상철(top) 선택 시 링컬러·링선택 visible**. 이는 단순 visible cascade가 아니라 **상품 경계를 넘는 cascade** 다:

| cascade 제약 | design JSX | 의미 | 라이브 DB 실재 | 정규화 매핑 | 갭 |
|-------------|-----------|------|---------------|-------------|-----|
| ⓑ-1 상철→링 visible | `bindDir==="top" && 링컬러/링선택` | 상철 선택 시 링 옵션 표시 | **069 무선엔 링 부재**(링=별도 상품 071 트윈링) | (069 단독) 제본방향=무선 단일이면 cascade 무의미. (superset 폼) `VisibilityRule{trigger:상철, shows:[링컬러,링선택]}` | **(C/B)** 069는 상철 분기 자체 없음. design superset을 한 폼으로 쓰려면 제본방식 전환=상품 전환(어댑터/BFF가 069↔071 상품 스위칭) → (B) 잠재 또는 복수상품 폼 |
| ⓑ-2 무선=좌철 고정 | (design 좌철/상철 택1) | 무선제본은 좌철만 | 069=무선·제본방향 옵션 미적재(=좌철 암묵) | `OptionGroup 제본방향(values=[좌철]·single)` 또는 비노출 | **(A/C)** 069 단독은 좌철 고정(비노출 가능)·제본방향 옵션 적재 시 (C) |
| ⓑ-3 링 선택 시 링컬러 required | `ring` state(상철 시) | 링 있으면 링색 필수 | 071 트윈링 영역(069 무관) | `OptionGroup.required=true (visible 조건부)` | **(C)** 071 적재 시 |

> **★C5 cascade 결론:** design 책자 폼의 제본 cascade(상철→링)는 **단일 상품(069) 내 cascade가 아니라 제본방식=상품경계 cascade** 다. 라이브는 무선(069)·트윈링(071)·중철(068)·PUR(070)을 **독립 prd_cd로 분리** 적재했다. 따라서 ⓑ를 한 위젯 폼으로 구현하려면 두 길: (가) **069 단독 폼**(무선=좌철 고정·링 비노출·디자인의 상철/링은 069 범위 밖으로 숨김) = 위젯 계약 0변경(A) / (나) **제본방식 셀렉터를 상품 스위처로**(제본 선택 → 어댑터가 068/069/070/071 NormalizedProduct 재로드) = 위젯 계약 0변경이나 어댑터/BFF 상품전환 로직(A, 단 멀티상품 폼). **권고: (가) 069 단독 우선 파일럿 → (나) 멀티상품 셋트셀렉터는 hw-architect 결정(B 후보)**.

### 3.2 제약 6종 추출표

| 제약형태(JSX) | 트리거 | 실례 | 정규화 매핑 | DB 출처(069) | 갭 |
|--------------|--------|------|-------------|--------------|-----|
| ① visible cascade | `bindDir==="top"` | 상철→링컬러/링선택 | `VisibilityRule` | constraints 0행·링 부재 | **(C/B)** §3.1 ⓑ |
| ③ 토글→하위 visible | `foilOn==="on"` | 박있음→박크기/박칼라 | `VisibilityRule{trigger:박있음, shows:[박크기,박칼라]}` | OPT_000019 박옵션 존재·토글룰 미적재 | **(A)** 박옵션 선택여부→어댑터 파생 visible |
| ③ 토글→하위 visible | `stamp!=="none"` | 형압→형압크기 | `VisibilityRule` | 형압항목 미생성 | **(C)** 형압 그룹 부재 |
| ④ 범위검증 area | 박크기 | 가로30~125·세로30~170mm | `InputSpec{min30,max125,axis2{30,170}}` | GAP-PARAM(OPT_000019 note 명시) | **(C)** 범위 DB 부재(디자인 placeholder 유일출처) |
| ④ 범위검증 area | 형압크기 | 가로30~125·세로30~170 | `InputSpec{...}` | 부재 | **(C)** |
| ⑤ 택1 패턴 | 사이즈/제본/내지종이/내지인쇄/표지종이/표지인쇄 | 각 택1 | `OptionGroup(SEL_TYPE.01→multiple=false)` 6개 | ✅ OPT_000013~017,020 sel_typ=SEL_TYPE.01 존재 | **(A)** sel_typ→multiple 직매핑 |
| ⑤ 택1(min0) | 표지코팅 | 코팅없음 포함 택1 | `OptionGroup(min0/max1·multiple=false)` | ✅ OPT_000018 min0 | **(A)** |
| ⑤ 택N | 박/형압 | 박+형압 동시 가능 | `OptionGroup(SEL_TYPE.02→multiple=true·max10)` | ✅ OPT_000019 SEL_TYPE.02 | **(A)** sel_typ→multiple=true |
| ⑥ 필수 required | 주문 전 필수 | 사이즈·제본·내지종이·내지인쇄·페이지·표지종이·표지인쇄·수량 | `OptionGroup.required=true` | OPT_000013~017,020 mand_yn=Y · page 항상 · qty 항상 | **(A)** mand_yn→required 직매핑 |
| ⑥ 페이지 clamp | 내지페이지 | 24~300/+2 | `InputSpec{min24,max300,step2}`(page-counter) | ✅ page_rules 069 | **(A)** 직매핑 |
| ② disable | (명시 약) | 자재↔후가공 | `disableRules[]` | constraints 0행·excl_groups 부재 | **(A)** 빈 배열 |
| ② quantity clamp | 제작수량 | min/max/incr·권 단위 | `QuantityRule{min2,increment1,max1000}` | products qty | **(A)** 직매핑(★디자인 min10/step10≠DB 권단위 — DB 권위) |
| ④ size | 사이즈 선택 | cut/work 치수 | `SizeRule[]` | siz_sizes.{cut,work}_{w,h} 1:1 | **(A)** 직매핑 |
| ⑥ base | — | 단위·재단마진 | `BaseRule{unit:권,nonStandardAllowed:false}` | products nonspec_yn=N·qty_unit=권 | **(A)** |
| ① 면별 분리 (cascade) | 내지/표지 각 종이·인쇄 | 면별 독립 옵션축 | side='inner'/'default'로 OptionGroup 분리 | USAGE.07(내지)/USAGE.01(표지)·member 공식 분리 | **(A)** 어댑터 side 라우팅 |

### 3.3 제약 6종 디자인↔DB 일치/갭 집계

| 제약축 | 디자인 의도 룰 수 | 라이브 데이터 충족 | 갭 |
|--------|:---:|:---:|-----|
| ① visible cascade (상철→링·면별분리) | 2 | 1(면별분리 A) | **갭 1 (C/B)** 상철→링=상품경계 |
| ② disable | 0 | 0 | 일치 |
| ③ 토글→하위(박·형압) | 2 | 1(박옵션 존재→A 파생) | **갭 1 (C)** 형압 |
| ④ 범위검증(박크기·형압크기) | 2 | 0(GAP-PARAM) | **갭 2 (C)** |
| ⑤ 택1/택N(사이즈·제본·내지종이·내지인쇄·표지종이·표지인쇄·표지코팅·박형압) | 8 | 8(전부 옵션그룹 존재) | **일치 8(A)** ★책자 강점 |
| ⑥ 필수(8옵션+페이지+수량+base) | 11 | 11(mand_yn·page_rules·products) | **일치 11(A)** |
| **합계** | **25** | **21 충족** | **일치 21·갭 4**(상철링 1·형압 1·박크기 1·형압크기 1·전부 C/B) |

**제약 결론:** 책자(069)는 디지털인쇄(print)와 **정반대로 옵션/제약 충전도가 높다** — ⑤택1/택N 8건·⑥필수 11건이 전부 라이브 옵션그룹으로 강제됨(A 직매핑). print 폼의 최대 병목(별색/코팅/박 옵션 미생성)이 책자엔 거의 없다(셋트 적재가 완료된 §23 성과). **차별 갭은 4건뿐**: ⓑ상철→링(상품경계·B 후보)·형압 항목·박/형압 크기(GAP-PARAM·C). 위젯 계약은 VisibilityRule·InputSpec·OptionGroup.multiple·**ProductSide(면별)** 슬롯을 이미 보유 → **계약 변경 0 목표 달성**(상철링 멀티상품만 B 잠재).

---

## 4. 가격 결선 (★evaluate_set_price 골든) — 디자인 가짜식 폐기 [ⓓ 핵심]

### 4.1 디자인 가짜 계산식 (폐기 대상)

book JSX(:43~52)는 로컬 가짜식:
```
sizeBase = {a5:42000, a4:50000}[size]
innerAdd = {montblanc:0, rendezvous:5000, art:3000}[innerPaper]
innerCost = round((sizeBase+innerAdd)*qty/20*(pages/8))   // ÷20·×(pages/8) 임의식
coverCost = 25000 + coverAdd                               // 표지 정액 25000
bindCost  = 1100                                           // 제본 정액 1100
packCost  = pack==="shrink" ? 500 : (foilOpen ? 25000 : 0) // ★박=25000 정액(버그성)
total = (innerCost+coverCost+bindCost+packCost)*1.1
```
→ **전부 폐기.** 제본비가 1100 정액(실제 무선 50,000)·표지 25000 정액(실제 88,688)·페이지 선형식이 임의(÷20). **이중합산 위험 신호**: 가짜식은 박=25000을 packCost에 묶어 개별포장과 혼입(버그). 실 가격은 evaluate_set_price 권위.

### 4.2 위젯 경로 (셋트 = evaluate_set_price)

```
NormalizedPriceRequest { productCode:PRD_000069, priceSchemeKey:PRF_BIND_MUSEON(echo·부모),
  itemGroup:book2025(echo·책자 분리필드 분기),
  dimensions:[{side:default(표지), ...},{side:inner(내지), ...}],
  colorCounts{default:표지도수, inner:내지도수}, materials{default:표지mat, inner:내지mat},
  quantity:부수(권), pageCount:내지페이지, selectedFinishes:[표지코팅·박·형압] }
   │ 어댑터 createHuniAdapter:
   │   · 면별 selections → 셋트 member 매핑(표지→290·내지→289)
   │   · 내지 member qty = derive_inner_sheets(부수, pageCount, pansu)  ← page→sheet 환산(계약 pageCount)
   │   · cover_mult=1(무선 펼침·서버 파생·위젯 무지)
   ▼
evaluate_set_price(set_prd_cd=PRD_000069,
   members=[{290:표지sel, qty=copies×cover_mult}, {289:내지sel, qty=derive_inner_sheets}],
   set_selections={제본=무선}, copies=부수)   [pricing.py:844]
   │  → 부모 PRF_BIND_MUSEON(COMP_BIND_MUSEON 제본비) + Σ member evaluate_price
   │       · 290 PRF_BOOK_COVER = 표지인쇄+표지코팅+표지용지
   │       · 289 PRF_DGP_INNER  = 내지인쇄+내지용지
   ▼
NormalizedPriceBreakdown { ok, finalPrice, vat, shipping,
   lines:[{COMP_BIND_MUSEON 제본}, {표지 3비목}, {내지 2비목}] }
```
박/형압 분기는 서버가 PRF_BIND_MUSEON_FOIL(박바인딩·미활성·인간승인 대기)로 라우팅 예정 — **위젯 무지**. 어댑터는 박칼라 선택값(proc_cd)을 selectedFinishes로 운반만.

### 4.3 ★이중합산 0 보장 [HARD]

셋트의 핵심 위험 = **표지/제본 이중계상**. 069 적재는 이를 가드함([[book-set-page-pricing-inner-member-260629]]·[[leather-hardcover-077-live-commit-260701]]):
- **부모공식 PRF_BIND_MUSEON = 제본비(COMP_BIND_MUSEON) 단일 비목만** — 표지/내지 가격을 부모에 넣지 않음.
- **표지가 = 290 member(PRF_BOOK_COVER)에만**·**내지가 = 289 member(PRF_DGP_INNER)에만**.
- 따라서 final = 제본(부모) + 표지(member) + 내지(member) = 각 1회. **이중합산 0**(072 통합 COVERBIND와 달리 069는 표지를 member로 분리해도 부모가 제본만 → 무중복).
- ★S8 제본 오염 가드: COMP_BIND_MUSEON proc_cd=PROC_000019 단독(무선)·use_dims에 proc_cd 포함 → PUR(PROC_000020)/중철과 silent 다중매칭 0.

### 4.4 PRICE≠0 골든 (§23 라이브 COMMIT 동작분 상속)

069는 §23 set-product에서 라이브 COMMIT으로 **저청구→138,688원 동작 입증**됨([[leather-hardcover-077-live-commit-260701]]). evaluate_set_price 재계산 골든:

| 케이스 | selections | copies×page | final_price | 주요 line | 출처 |
|--------|-----------|-------------|-------------|-----------|------|
| A 기본 | A4·표지 백모120 단면칼라 코팅없음·내지 백모220 양면흑백 | 부수×page(068 동형 기준) | **138,688** | 표지 88,688 + 제본 MUSEON 50,000 | §23 069 COMMIT(검증분) |
| 비교 070 PUR | 〃·제본=PUR | 〃 | **288,688** | 표지 88,688 + 제본 PUR 200,000 | §23 070 COMMIT(동형) |
| 비교 068 중철 | 〃·제본=중철 | 〃 | **158,688** | 표지 88,688 + 제본 70,000 | §23 068 COMMIT(동형) |

> 069 자체 라이브 시뮬레이터 직호출은 인증세션(CSRF) 필요 — 읽기전용 원칙상 본 명세는 §23 라이브 COMMIT 사후검증값(138,688·표지88,688+제본50,000·오차0)을 권위로 재사용한다. 거짓 수치 날조 금지.

✅ **PRICE≠0 게이트 통과**(138,688>0·이중합산 0).

### 4.5 ★디자인 가짜식 vs 실 evaluate_set_price 차이 + 잔존 결함

- **차이**: 가짜식 total≈(50000+0)*20/20*(8/8)+25000+1100+25000 ≈ 101,100*1.1 ≈ 111,210 (제본 1100·표지 25000 정액). 실 evaluate_set_price=138,688(제본 50,000·표지 88,688). 가짜식은 제본비를 1/45로·표지를 1/3.5로 저평가 + 박을 packCost에 혼입. → **가짜식 폐기 정당**.
- **잔존 결함(인간 승인·어댑터/계약 무관)**:
  - **(C) cover_mult ×2 = 071 트윈링 영역**([[booklet-cover-branch-design-260630]]) — 069 무선=cover_mult=1 펼침이라 **069는 영향 없음**(정확). 071/082 ring만 ×2 BLOCKED.
  - **(C) DBLPANSU 내지 이중÷pansu** — 내지 페이지가 환산 잔존(표지/제본 무영향·C트랙 개발팀).
  - **(C) 박 분기 활성화** — 박 선택 시 PRF_BIND_MUSEON_FOIL 바인딩 활성화 인간 승인 대기(현재 박칼라 운반만·가산 미반영).
  - **(C) 면지 유료/무료** — 069 무선=면지 부재(소프트커버 면지0 설계의도). 082는 면지 유료 BLOCKED-CONFIRM(069 무관).

---

## 5. 주문 페이로드 예시 (NormalizedCartHandoff + 면별 CTA 분기) [ⓔ 박/형압 포함]

PRD_000069: file_upload_yn=Y·editor_yn=N → CTA는 **PDF 업로드 단독**(에디터 없음). 단 design JSX는 "에디터로 디자인하기" 버튼도 노출 → 디자인 의도 vs DB(editor_yn=N) **불일치** → 위젯은 DB 권위(에디터 버튼 비활성/숨김) 또는 editor_yn 교정(C). **면별 artifact**: 책자는 표지/내지 면별 업로드 → `ProductSide` 2면 각 artifact.

**완성 선택 상태(예):** A4 · 무선제본 · 표지[백모120·단면칼라·코팅없음·박먹유광] · 내지[백모220·양면흑백·48p] · 부수 20
```jsonc
// NormalizedCartHandoff
{
  "productCode": "PRD_000069",
  "itemGroup": "book2025",
  "selectedOptions": [
    { "groupId": "OPT_000013", "valueId": "SIZ_000172", "side": "default" },   // A4
    { "groupId": "OPT_000020", "valueId": "<무선>",     "side": "default" },   // 제본
    { "groupId": "OPT_000016", "valueId": "<백모120>",  "side": "default" },   // 표지종이
    { "groupId": "OPT_000017", "valueId": "POPT_000001","side": "default" },   // 표지 단면칼라
    { "groupId": "OPT_000018", "valueId": "<코팅없음>", "side": "default" },   // 표지코팅
    { "groupId": "OPT_000019", "valueId": "<박먹유광PROC_040>", "side": "default", "attb": "박크기=GAP-PARAM" }, // ⓔ 박(표지)
    { "groupId": "OPT_000014", "valueId": "<백모220>",  "side": "inner" },     // 내지종이
    { "groupId": "OPT_000015", "valueId": "POPT_000009","side": "inner" }      // 내지 양면흑백
  ],
  "pageCount": 48,            // 내지페이지 (어댑터가 inner member qty 환산)
  "quantity": 20,            // 부수(권)
  "priceSnapshot": { "finalPrice": 138688, "vat": 13869, "shipping": 0 },  // evaluate_set_price 권위
  "artifacts": [
    { "side": "default", "kind": "pdf", "storedFileName": "stored_cover.pdf",  "originalFileName": "cover.pdf" },
    { "side": "inner",   "kind": "pdf", "storedFileName": "stored_inner.pdf",  "originalFileName": "inner.pdf" }
  ]
}
// CTA 분기: editors={koi:false,rp:false,pdf:true} → cta.pdfUpload=true·designEditor=false
```
- **면별 artifact**: `ProductSide[{default:표지},{inner:내지}]` 각 PDF 업로드 → `NormalizedArtifact{side,kind:'pdf'}` 2건. uploadType=pdf(editor_yn=N).
- **에디터/PDF 분기**: editor_yn=N → designEditor=false(디자인 폼 에디터 버튼은 DB 불일치·(C) editor_yn 교정 또는 위젯 숨김). file_upload_yn=Y → pdfUpload=true.
- **커머스 바인딩**: `priceSnapshot.vat`/`shipping`·NormalizedPresigned·실 카트 전송은 **§24 Shopby UNDECIDED 경계**. 위젯은 NormalizedCartHandoff까지 조립 후 BFF로 위임.

---

## 6. componentType / 갭 노트

### 6.1 componentType 사상 (book 폼)
| componentType | book 폼 사용처 | 데이터 출처 |
|---------------|----------------|-------------|
| `option-button` | 사이즈·제본·제본방향·내지인쇄·표지인쇄·표지코팅·투명커버·박on/형압 | sizes·print_opt·(투명커버/형압=C) |
| `select-box` | 내지종이·표지종이·개별포장 | option_items 자재(USAGE.07/.01) / (개별포장=C) |
| `counter-input` | 제작수량 | products qty(권 단위) |
| `page-counter-input` | **내지 페이지** | page_rules 069(24/300/2) ✅ |
| `color-chip` | 링컬러·박칼라 | (링=C) / OPT_000019 박옵션 + colorHex(C) |
| `image-chip` | 링선택(D링) | (069 부재=C) |
| `area-input` | 박크기·형압크기 | **GAP-PARAM 전부(C)** |
| `summary` | 가격요약 | 어댑터 생성(evaluate_set_price) |
| `upload-cta` | PDF 업로드(면별 표지/내지) | file_upload_yn=Y · ProductSide 2면 |
| `finish-button`/`finish-select-box` | (책자 박/형압은 option-button로 충분) | — |
| `price-slider`/`mini`/`large-color-chip`/`acc-panel`/`dimension-matrix-input` | 미사용(book) | — |

### 6.2 갭 (A)/(B)/(C) 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (15)**: A1 CPQ ref_dim 환원·A2 셋트 member 라우팅(표지290/내지289)·A3 면별 side 매핑(USAGE→ProductSide)·A4 semi_role 파생(note+공식+disp_seq)·A5 내지 qty 환산(derive_inner_sheets·pageCount)·A6 cover_mult 서버파생(069=1·위젯무지)·A7 이중합산 가드(부모=제본만)·A8 박옵션→토글 visible 파생·A9 sel_typ→multiple·A10 mand_yn→required·A11 page_rules→InputSpec·A12 무선=좌철 비노출·A13 unit=권·A14 PRICE=0 진단·A15 vat/shipping.
- **(B) 계약 변경 필요 (0~1)**: 위젯 계약(ProductSide·SideKey inner·pageCount·VisibilityRule·InputSpec·OptionGroup.multiple·colorHex)이 이미 책자 면별·페이지·박을 OPTIONAL 슬롯으로 수용 → **계약 변경 0건(목표 달성)**. 단 **ⓑ제본방식=상품경계 cascade(상철→링=069↔071 상품전환)**가 잠재 B(멀티상품 폼이 필요하면) — 현재는 069 단독 폼(A)로 흡수, hw-architect 결정.
- **(C) DB 작성·교정 — §7/§23 인간 승인 (8)**:
  - C-상철/링: 제본방향 옵션 + 링컬러/링선택은 069 무선 범위 밖(트윈링 071 적재됨) — 멀티상품 폼 채택 시 상품전환(코드) / 단일폼이면 비노출(불필요).
  - C-면지: 069 무선=면지 부재(소프트커버 면지0 설계의도). design 면지4종은 069에 무의미 → 위젯 비노출(교정 불필요·설계의도).
  - C-투명커버: 069 투명커버 member/옵션 미적재(적재 필요 시 §23).
  - C-형압 항목: OPT_000019 박형압 그룹에 형압(양각/음각) 항목 미생성(공정 PROC_045계열 바인딩).
  - C-박크기/형압크기: GAP-PARAM(OPT_000019 note 명시·area 파라미터 컬럼/적재).
  - C-colorHex: 박칼라 color_hex(added-schema-260701 — .sql 부재·문서만·§7 재작성).
  - C-개별포장: 개별포장 옵션그룹 미생성(수축포장 단가행 연결).
  - C-editor_yn: 디자인 폼 에디터 버튼 vs DB editor_yn=N 불일치(에디터 제공 시 Y 교정·아니면 위젯 숨김).
  - C-A5 사이즈: SIZ_000170 A5 del_yn=Y(논리삭제) — 복원 필요 시 §23(현재 A4만 정상).
  - C-semi_role_cd: member semi_role_cd 공란(note+공식 파생 가능하나 정식 적재 권고).

---

## 7. 주문가능 4조건 충족 여부 (PRD_000069 현재)

`widget-forms-approach.md §3` 주문가능 정의 = ⓐ옵션 라이브구동 + ⓑ제약6종 데이터강제 + ⓒPRICE≠0 + ⓓ유효 페이로드.

| 조건 | 현재 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | **충족(주의)** | 사이즈·제본·내지[종이/인쇄/페이지]·표지[종이/인쇄/코팅]·박칼라 = 라이브 CPQ 8그룹 구동 ✅ / 제본방향·링·면지·투명커버·형압·개별포장 = 069 범위 밖 또는 미적재(C) ⚠ (단 069 무선 주문엔 불요) |
| ⓑ 제약 6종 데이터 강제 | **충족(주의)** | ⑤택1/택N 8건·⑥필수 11건·④size·②quantity·①면별분리 강제 ✅(책자 강점) / 상철링cascade·형압·박크기 = 갭 4(C/B) ⚠ |
| ⓒ PRICE≠0 | **충족** | evaluate_set_price golden 138,688 >0 ✅ · 이중합산 0(부모=제본만)·S8 격리 ✅ / 박가산 미반영·DBLPANSU 잔존(C·069 final>0 무손상) ⚠ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립 가능(면별 표지/내지 artifact 2건) ✅ / 커머스 바인딩 §24 UNDECIDED·PDF CTA only(에디터 버튼 DB불일치) |

**판정: 주문가능(ORDER-CAPABLE, 069 무선 단독 경로).** 책자(069)는 §23 셋트 동작화 COMMIT 덕에 **8 옵션그룹·21 제약룰·evaluate_set_price 138,688(이중합산0)** 가 라이브로 강제되어 **무선책자 주문이 실제 가능**하다. print 폼(부분주문가능)과 달리 책자는 셋트 적재 완료로 **풀 주문가능에 근접**. 잔여 갭 4건(상철링·형압·박크기·형압크기)은 design superset의 타 제본방식/장식 영역이라 069 무선 주문엔 불요. **위젯/계약/어댑터 준비 완료(B 0건·면별=ProductSide 기존 계약)**, 병목은 design superset의 멀티상품 폼 결정(B 후보·hw-architect) + 박/형압 장식 적재(C·§23/§7).

**다음 권고:** ① 069 무선 단독 폼으로 createHuniAdapter 셋트 arm(evaluate_set_price·면별 member 라우팅·내지 qty 환산) 구현 → ② hw-architect에 ⓑ제본방식=멀티상품 폼 vs 상품별 분리 폼 결정 요청(B 후보) → ③ 동형 형제(068/070 분해형·072/077 통합) 전파 → ④ 박/형압 장식·colorHex 적재는 §7/§23 인간 승인. 코드 구현은 본 명세 승인 후.

---

## 부록: 동형 전파 노트 (C5 클래스)

PRD_000069(무선·분해형) 매핑 규칙 전파 대상·동형 판정:

| 형제 상품 | 제본방식 | 동형 여부 | 차이(전파 시 조정) |
|-----------|----------|:--:|-------------------|
| PRD_000068 중철책자 | 중철(분해형) | ✅ 동형 | 부모공식 PRF_BIND_*(중철)·page_rule 4~28/+4·cover_mult=1 |
| PRD_000070 PUR책자 | PUR(분해형) | ✅ 동형 | 부모공식 PUR(200,000)·page_rule 24~300/+2·cover_mult=1·PRF_BOOK_COVER 재사용 |
| PRD_000072/077 하드커버 | 하드커버무선(통합) | △ 준동형 | 표지+제본=통합 COMP_HC_MUSEON_COVERBIND(member 분리 안 함)·이중합산 가드 다름(부모가 표지+제본) |
| PRD_000071 트윈링 | 트윈링(ring) | ❌ 분리 | **cover_mult ×2 BLOCKED**(엔진 미지원·C트랙)·상철→링 cascade 발현·새 대표 |
| PRD_000082 하드커버링 | 트윈링하드커버 | ❌ 분리 | cover_mult ×2 + 면지 유료 CONFIRM·새 대표 |
| PRD_000094 엽서북 | (페이지북) | △ 준동형 | 내지095 무공식 점검·page 20~30/+10 |
| PRD_000100 포토북 | (에디터북) | △ 준동형 | editor_yn=Y·file_upload_yn=N(CTA 분기 반대)·2-레이어 페이지가 |

**전파 원칙**: 분해형(068/069/070)은 069 규칙(면별 member 라우팅·PRF_BOOK_COVER·이중합산 가드) 그대로. 통합형(072/077)은 부모가 표지+제본 흡수라 이중합산 가드 별도. ring형(071/082)은 cover_mult ×2 BLOCKED라 **동형 깨짐 → 새 클래스(C5-ring)·새 대표**. 포토북(100)은 CTA가 에디터 우선이라 ⓔ 분기 반대(별도 점검).
