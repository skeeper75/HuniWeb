# dimension-to-price-trace.md — 종단 골든 e2e 추적 (디지털인쇄)

> **Phase 4 — hcc-price-engine-inspector** · 2026-06-22 · `huni-catalog-conformance/04_price_engine`
> 목적: `옵션 선택값 → polymorphic 차원 환원 → component_prices 단가행 매칭 → evaluate_price → final_price`를
> 대표 상품 1건에 대해 단계별로 추적해 **정합의 정석을 입증**하고, **끊기는 지점 = 가장 비싼 결함**을 표시한다.
> 권위 기준: `engine-contract.md`(evaluate_price 계약 인용·재조사 0)·`engine-design-digitalprint.md`(설계).
> 라이브 읽기전용 SELECT 실측 2026-06-22. 단가값 verbatim(날조 0).

---

## 추적 1 — ✅ 성공 사례: 스탠다드엽서 (PRD_000018, PRF_DGP_A 원자합산형)

원자합산형 디지털인쇄가 옵션→차원→단가행→final_price로 **끊김 없이 환원**되는 정석.

| 단계 | 내용 | 라이브 근거 |
|------|------|-------------|
| **① 옵션 선택** | 출력판형=3절(SIZ_000077)·인쇄=양면(POPT_000002·도수 4도)·용지=몽블랑(MAT_000xxx)·코팅=무광·수량 1,000매 | t_prd_product_option_groups→options→option_items(ref_dim_cd) |
| **② 차원 환원(polymorphic)** | option_item.ref_dim_cd → selections `{plt_siz_cd:SIZ_000077, print_opt_cd:POPT_000002, mat_cd:.., coat_side_cnt:1, min_qty=수량구간}` | NON_QTY_DIMS 매칭 (engine-contract §3.1) |
| **③ 단가행 매칭** | 공식 PRF_DGP_A 구성요소 disp_seq 순 자동매칭(P2-2): 인쇄 COMP_PRINT_DIGITAL_S1(212행) + 용지 COMP_PAPER(56행) + 코팅 COMP_COAT_MATTE(92행). 유광 미선택→COMP_COAT_GLOSSY 자연 제외 | t_prc_component_prices |
| **④ evaluate_price** | source=FORMULA(직접단가 0행·C1) → base = Σ included subtotal. 인쇄=[수량행단가]×출력매수(출력매수=수량/판걸이수=앱계산) + 용지 unit×qty + 코팅 unit×qty (단가형 P4-1) | pricing.py `_evaluate_formula` |
| **⑤ final_price** | round_won(Σ). 수량구간 할인 0건(디지털 미사용·단가가 min_qty 구간에 내장) → 등급할인 0행(C9) → final = base | E0-2 |

- **단가행 실측 verbatim**: 인쇄 SIZ_000077·POPT_000002·min_qty=1 → 4,500원(단면 3,500). 코팅 무광 SIZ_000077·1면·min_qty=1 → 3,000원. 용지 SIZ_000499·MAT_000074 → 70.64원/장.
- **판정: 종단 추적 성공.** 옵션 4축이 전부 단가행으로 환원되어 가격이 나온다. 원자합산 디지털(엽서·접지카드·배경지·전단류 20여 상품)은 이 경로로 견적 가능.

---

## 추적 2 — 🔴 끊긴 지점(가장 비싼 결함): 코팅명함 (PRD_000032, PRF_NAMECARD_FIXED)

고정가형 명함에서 **옵션 선택값이 올바른 단가행으로 환원되지 못하고 STD 단가로 misfire**하는 지점.

| 단계 | 기대(권위) | 라이브 실제 | 끊김 |
|------|-----------|-------------|------|
| **① 옵션 선택** | 코팅명함·단면·MAT_000081·100매 | 동일 | — |
| **② 차원 환원** | selections `{mat_cd:MAT_000081, print_opt_cd:단면, min_qty:100}` | 동일 | — |
| **③ 단가행 매칭** | COMP_NAMECARD_COAT_S1(MAT_000081·100매=**5,500**) 매칭 | 공식 PRF_NAMECARD_FIXED엔 **COAT comp 미배선** → COMP_NAMECARD_STD_S1만 존재 → **STD 단가(MAT_000074=3,500) 매칭** | 🔴 **D-A misfire** |
| **④ evaluate_price** | base=5,500/장 | base=3,500/장 (COAT comp는 orphan·평가에 안 들어옴) | 견적이 **틀린 값으로 성립**(깨지지 않음=더 위험) |
| **⑤ final_price** | 100매=550,000 | 100매=350,000 | **−200,000원 과소청구(회사 손해)** |

> **★끊긴 지점**: ③에서 옵션이 가리키는 variant 단가행(COAT 5,500)이 공식에 배선되지 않아, 엔진이 같은 공식의 STD comp(3,500)를 대신 매긴다. comp는 실재(orphan)하나 공식↔comp 배선이 끊겼다.

### 추가 끊김 — 🔴 D-B silent 이중합산 (같은 명함 공식)

| 단계 | 내용 | 끊김 |
|------|------|------|
| ③' 단가행 매칭 | STD_S1·STD_S2 **둘 다 print_opt_cd=NULL**(라이브 실측) → 단면 선택해도 양쪽 와일드카드 통과(P3-1) | — |
| ④' evaluate_price | 별 comp_cd라 ERR_AMBIGUOUS 안 걸림(P3-8 비해당) → S1(3,500)+S2(4,500) **둘 다 included 합산** | 🔴 **silent 이중합산** |
| ⑤' final_price | 단면 100매 = (3,500+4,500)×100 = **800,000** (정답 단면=350,000) | **+450,000원 과대청구·경고 없음** |

> D-A(과소)와 D-B(과대)가 같은 PRF_NAMECARD_FIXED에 공존. 어느 쪽이 발화하느냐는 옵션→차원 주입 레이어(option_items 매핑) 상태에 달림(현재 명함 옵션→POPT 매핑 0행). **둘 다 라이브 실재 결함** — 명함 견적은 정합 미달.

---

## 종단 추적 종합

| 경로 | 상품군 | 결과 |
|------|--------|------|
| **원자합산형(PRF_DGP_A/B/C/D/E/F)** | 엽서·접지카드·배경지·헤더택·전단·모양엽서·라벨택·상품권 | ✅ 종단 성공(코팅 유광 선택분만 V-4 0원 침묵) |
| **고정가형 명함(PRF_NAMECARD_FIXED)** | 명함류 | 🔴 끊김(D-A misfire 과소 + D-B silent 이중합산 과대) |
| **고정가형 포토카드(PRF_PHOTOCARD_FIXED)** | 포토카드 | ✅ 본체 SET 단가행 실재·종단 가능(BULK orphan은 미발화) |
| **미바인딩 10상품(frm_cd 공란)** | 투명엽서·지그재그엽서·명함7종·와이드접지리플렛 | 🔴 ④에서 source=NONE → final_price=0원/None(견적 자체 불가) |

**가장 비싼 결함 순위**: ① 미바인딩 10상품(견적 0원·아예 안 나옴) → ② 명함 D-A/D-B(틀린 값으로 성립) → ③ COMP_COAT_GLOSSY 0원 침묵(과소).

---

# 배치1 종단 추적 — 포토북 본체(PRD_000100) · 캘린더(PRD_000111 벽걸이)

> **Phase 2 배치1** · 2026-06-22 · 라이브 읽기전용 실측. 권위: `engine-design-photobook.md`·`engine-design-calendar.md`(§18 설계).
> 6 prd 전부 frm_cd 미바인딩(DEF-PE-06) → 종단이 **④ evaluate_price에서 source=NONE으로 차단**. 설계대로 신설·바인딩 시 경로가 어떻게 환원되는지 함께 표기(설계 의도 추적).

## 추적 3 — 🔴 끊긴 지점(차단): 포토북 본체 (PRD_000100, 공식 미신설)

부품합산 세트형+페이지 선형이 **공식 부재로 ④에서 즉시 차단**되는 지점. 설계 신설 후 기대 경로 병기.

| 단계 | 설계 기대(권위·신설 후) | 라이브 실제(현재) | 끊김 |
|------|------------------------|-------------------|------|
| **① 옵션 선택** | 8x8·하드커버·150P·1부 | 표지타입/페이지 옵션그룹 0행(option_groups=0) | ⚠ 옵션 레이어 부재(DEF-PE-07) |
| **② 차원 환원** | selections `{siz_cd:8x8, mat_cd:하드(MAT_000005), page:150}` → base_min=24·증분=ceil((150-24)/2)=63 | option_items 0행 → mat_cd 자동주입 끊김 | ⚠ 종단 미연결 |
| **③ 단가행 매칭** | COMP_PHOTOBOOK_BASE(8x8·하드=15,000) + COMP_PHOTOBOOK_PAGE(8x8=500)×63 | 두 comp 라이브 0행(미신설) | 🔴 comp 부재 |
| **④ evaluate_price** | source=FORMULA(PRF_PHOTOBOOK_SUM) → base = 15,000 + 500×63 = 46,500 | **공식 바인딩 0행 → source=NONE → 0원/None** | 🔴 **DEF-PE-06 차단** |
| **⑤ final_price** | 46,500(1부)·×부수 | **0원(견적 안 나옴)** | 🔴 차단 |

> **★끊긴 지점**: ④에서 PRF_PHOTOBOOK_SUM이 라이브에 없어 source=NONE. 설계가 신설·바인딩하면 base24+per2p×63 경로로 46,500 산출. **페이지 곱 누락 시 150P가 15,000(3.1배 과소·G-PB-PAGE)** — 신설 시 per2p×증분횟수 곱이 돈크리티컬.
> **재사용 사슬은 준비됨**: 제본 COMP_BIND_PUR(8행)·용지 COMP_PAPER(56행)·코팅 COMP_COAT_MATTE(92행) 실재(base24에 internalize)·세트 BOM 7행·page_rule 24/150/2 실재. **공식·base/per2p comp만 신설하면 종단 연결 가능**.

## 추적 4 — 🔴 끊긴 지점(차단): 벽걸이캘린더 (PRD_000111, 공식 미신설)

원자합산형(인쇄+용지+제본)이 공식 부재로 차단. 제본비 단가행은 실재하나 공식이 없어 환원 끊김.

| 단계 | 설계 기대(권위·신설 후) | 라이브 실제 | 끊김 |
|------|------------------------|-------------|------|
| **① 옵션 선택** | 벽걸이·12장·트윈링제본·수량N | 옵션그룹 0행 | ⚠ DEF-PE-07 |
| **② 차원 환원** | `{print_opt_cd, siz_cd, proc_cd:PROC_000099(벽걸이제본), min_qty:N}` + 장수12 곱 | proc_cd 자동주입 끊김(option_items 0) | ⚠ 종단 미연결 |
| **③ 단가행 매칭** | COMP_PRINT_DIGITAL_S1(212행)+COMP_PAPER(56행)+COMP_BIND_CAL_WALL(proc99·tier) | 제본비 comp **실재**(WALL 24행·del_yn=N)·인쇄/용지 실재 | ✅ 단가행 준비됨 |
| **④ evaluate_price** | source=FORMULA(PRF_CAL_WALL) → 인쇄비×(장수12 곱)+용지비+제본비(부당가×qty) | **공식 0행 → source=NONE → 0원** | 🔴 **DEF-PE-06 차단** |
| **⑤ final_price** | Σ(설계 골든) | **0원** | 🔴 차단 |

> **★끊긴 지점**: ③ 단가행은 전부 실재(제본비 COMP_BIND_CAL_WALL=24행 verbatim·인쇄/용지 재사용)인데 ④ 공식이 없어 합산 진입 자체 불가. **공식 신설+바인딩만 하면 종단 가능**(캘린더는 포토북보다 신설 깊이 작음 — comp 재사용율 높음·신규=CALOPT만). ★페이지(장수) 곱 누락 시 인쇄/용지비 4~16배 과소(G-CAL-PAGE)·제본비 ÷min_qty 오적용 시 1/N 붕괴(G-CAL-BIND).

## 배치1 종단 종합

| 경로 | 상품 | 결과 |
|------|------|------|
| 부품합산 세트형+페이지(PRF_PHOTOBOOK_SUM 신설예정) | 포토북 100 | 🔴 ④ source=NONE 차단(공식·base/per2p comp 미신설)·재사용 사슬+세트BOM+page_rule 준비됨 |
| 원자합산형(PRF_CAL_* 신설예정) | 캘린더 108~112 | 🔴 ④ source=NONE 차단(공식 미신설)·제본비 단가행+인쇄/용지 재사용 준비됨 |

**가장 비싼 결함 순위(배치1)**: ① 6 prd 미바인딩(견적 0원·아예 안 나옴=차단 DEF-PE-06) → ② 옵션→차원 주입 레이어 부재(공식 신설 후에도 종단 미연결·DEF-PE-07). 신설 시 ③ 페이지/장수 곱 누락(G-PB-PAGE·G-CAL-PAGE 3~16배 과소)·④ 평탄화(G-PB-FLAT·G-CAL-1)가 돈크리티컬 잠재.

---

# 배치2 종단 추적 — 책자 무선책자(069) · 엽서북(094) · 문구 만년다이어리(172)

> **Phase 2 배치2** · 2026-06-23 · 라이브 읽기전용 실측. 권위: `engine-design-booklet.md`·`engine-design-stationery.md`·`engine-design-accessory.md`(§18 설계).
> 책자·문구·악세는 3 경로(FORMULA stale배선·FORMULA silent이중합산·PRODUCT_PRICE 미가격)로 끊긴다. 끊긴 지점=가장 비싼 결함.

## 추적 5 — 🔴 끊긴 지점(과소/미완성): 무선책자 (PRD_000069, PRF_BIND_SUM stale 배선)

제본방식 misfire + 표지/내지 누락이 합쳐진 미완성가. 바인딩은 있으나 정합 미달.

| 단계 | 기대(권위) | 라이브 실제 | 끊김 |
|------|-----------|-------------|------|
| **① 옵션 선택** | 무선책자·A5·내지150P·표지아트지·100부 | 옵션그룹 일부(cpq-link 영역) | — |
| **② 차원 환원** | selections `{proc_cd:PROC_000019(무선), min_qty:100, …페이지/표지축}` | proc_cd 주입 레이어 상태 의존(미주입 시 silent 다중매칭 위험) | ⚠ proc_cd 주입 |
| **③ 단가행 매칭** | 무선제본 COMP_BIND_MUSEON(또는 통합 TWINRING proc=019) + 표지비 + 내지비×페이지 | 공식엔 **COMP_BIND_JUNGCHEOL(중철·del_yn=Y) 1개뿐** → 중철 단가행만 매칭·표지/내지 comp 0행 | 🔴 **제본 misfire + 표지내지 누락** |
| **④ evaluate_price** | base = 무선제본비 + 표지비 + 내지비(페이지) | base = 중철제본비만(del 필터 부재로 합산됨)·표지내지 0 | 견적이 **미완성가로 성립**(깨지지 않음) |
| **⑤ final_price** | Σ(설계 골든·완성가) | 중철제본비만(저가·미완성) | **과소/미완성가** |

> **★끊긴 지점**: ③에서 무선책자가 가리켜야 할 무선 제본비 단가행 대신 stale 배선된 삭제 comp(중철)가 매겨지고, 표지/내지 인쇄·용지 comp가 아예 0행이라 다부품 완성가가 안 나온다. **단가행은 실재(JUNGCHEOL 중철 B01 정답·TWINRING 활성)** — 배선 교정(W1)+표지내지 신설(W3)이면 종단 가능.

## 추적 6 — 🔴 끊긴 지점(과대 silent): 엽서북 (PRD_000094, PRF_PCB_FIXED 이중합산)

바인딩·단가행 충전 모두 정상이나 print_opt_cd 판별차원 부재로 단/양면이 둘 다 매칭.

| 단계 | 기대(권위·단면 선택) | 라이브 실제 | 끊김 |
|------|---------------------|-------------|------|
| **① 옵션 선택** | 엽서북·SIZ_000003·단면·20p·2부 | 동일 | — |
| **② 차원 환원** | selections `{siz_cd:SIZ_000003, print_opt_cd:단면, min_qty:2}` | print_opt_cd가 selections에 와도 **단가행이 NULL이라 무시됨** | ⚠ |
| **③ 단가행 매칭** | COMP_PCB_S1_20P(단면)만 매칭=11,000 | S1_20P·S2_20P **둘 다 print_opt_cd=NULL**→와일드카드 통과(P3-1)·별 comp_cd라 ERR_AMBIGUOUS 비해당(P3-8) | 🔴 **둘 다 매칭** |
| **④ evaluate_price** | base=11,000/권 | base=S1(11,000)+S2(11,500)=**22,500/권**(silent 합산·경고 없음) | 🔴 **silent 이중합산** |
| **⑤ final_price** | 2부=22,000 | 2부=45,000 | **+11,500/권 과대청구** |

> **★끊긴 지점**: ③에서 print_opt_cd 판별차원이 단가행에 NULL이라 단면 선택이 양면 단가행을 못 거른다. 명함 D-B와 동형. 추가로 30p variant(S1/S2_30P)는 orphan(미배선)이라 30p 주문이 20p 단가로 매겨짐(11,000≠11,500 페이지 판별불가). **단가값은 verbatim 정합 — print_opt_cd 충전+30p 배선만 하면 종단 정합**.

## 추적 7 — 🔴 끊긴 지점(차단): 만년다이어리 (PRD_000172, PRODUCT_PRICE 미가격)

고정가형이 공식이 아니라 product_prices 그릇이 비어 ④에서 source=NONE 차단. 수량할인은 base=0에 dead.

| 단계 | 설계 기대(권위) | 라이브 실제 | 끊김 |
|------|----------------|-------------|------|
| **① 옵션 선택** | 만년다이어리(소프트)·100부 | 단일 상품(차원 없음·AC열 고정가) | — |
| **② 차원 환원** | selections 불요(고정가 1종 1가) | — | — |
| **③ 가격 소스** | PRODUCT_PRICE: t_prd_product_prices.unit_price | **product_prices 0행** | 🔴 가격 부재 |
| **④ evaluate_price** | base = 고정가 × 100부 → DSC_STAT_QTY 100개=10% 곱 | **source=NONE → 0원**. DSC 링크 실재하나 base=0→P6-4 할인 스킵(dead) | 🔴 **차단 + 할인 dead** |
| **⑤ final_price** | 고정가×100×0.9 | **0원** | 🔴 차단 |

> **★끊긴 지점**: ③에서 고정가 그릇(product_prices)이 비어 source=NONE. **공식·comp 불요 — AC열 고정가 1행 INSERT만 하면 PRODUCT_PRICE 경로로 종단 가능**(문구 본체 9·악세 AC-1 동형). 수량구간할인(DSC_STAT_QTY)은 base가 채워지는 즉시 순차 곱으로 발화(Q-ST-PRICE2WAY=충돌 아닌 의도).

## 배치2 종단 종합

| 경로 | 상품 | 결과 |
|------|------|------|
| FORMULA stale배선+표지내지 누락 | 책자 068~071 | 🔴 ③ 제본 misfire+표지내지 0(과소/미완성)·단가행 실재(배선 교정) |
| FORMULA full WIRE | 책자 072/077/082/088 | 🔴 ④ source=NONE(공식+표지내지 comp+단가+바인딩 전무) |
| FORMULA silent이중합산 | 엽서북 094 | 🔴 ④ S1+S2 둘 다 매칭(+11,500/권 과대)·단가값 정합(print_opt_cd 충전) |
| FORMULA 바인딩만 | 떡메모 097 | 🔴 ④ source=NONE(공식·comp·단가행 실재·바인딩만 필요) |
| PRODUCT_PRICE 미가격 | 문구 본체9·악세 AC-1(3) | 🔴 ③ product_prices 0(고정가 INSERT만) |
| FORMULA full mint | 악세 AC-2(11) | 🔴 가격사슬 전무(comp 신규 mint+평탄화 가드) |

**가장 비싼 결함 순위(배치2)**: ① 엽서북 094 silent 이중합산(틀린 값으로 성립·과대 검출 어려움) → ② MISSING 28(견적0원·차단) → ③ 책자 068~071 stale배선(과소/미완성). ★교정 시 돈크리티컬 잠재: 엽서북 print_opt_cd 충전(이중합산 해소)·악세 G-AC-2 묶음 .01 팩단가(합가형 오적용 시 1100원 봉투 22원/장 붕괴)·책자 표지내지 신설(미완성가).
