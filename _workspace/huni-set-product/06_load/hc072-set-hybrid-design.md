# 072 하드커버책자 — 셋트 하이브리드 가격 재설계 (구성원별 공식 + 셋트 제본 공식)

생성: hsp-set-designer · 2026-06-25 라이브 읽기전용 SELECT 직접 재실측 + `evaluate_set_price`(pricing.py:718)/`price_simulate_set`(price_views.py:1649~1733) 코드 실측 · **단가 verbatim·날조 0** · **DB 미적재**(COMMIT/INSERT/DDL 0·설계까지만·실 적재 인간 승인 후 hsp-load-executor/dbmap) · search-before-mint 전수

> ★**아키텍처 교정**: 직전 `hc072-final-design.md`의 단일 번들 공식 `PRF_HC_MUSEON_SUM`(제본+표지+내지를 한 셋트 공식에 전부 internalize)을 **폐기**한다(잘못된 레이어). 코드 실측 확정대로 **셋트 하이브리드**(구성원=반제품 각자 자기 공식 + 셋트 완제품 자기 공식=제본/조립만)로 재설계한다. 단일 번들의 인공 문제(표지 pansu 4-up 과소청구·S1 PK 충돌·내지인쇄 진성 BLOCKED)는 **구성원 분리로 자연 해소**된다(§2.4).

---

## ★0. 결론 요약 (한눈에)

| 항목 | 결론 |
|---|---|
| **모델** | 셋트 하이브리드. `evaluate_set_price` = ① 구성원(반제품) 각자 `evaluate_price`(자기 공식·자기 `selections.siz_cd`) Σ + ② 셋트 완제품(072) 자기 공식(=제본만·qty=부수) + 할인. 구성원 qty는 **뷰 레이어가 산출**(내지=총내지매수·표지=출력매수). |
| **★라이브 구조 실측(직전 미규명)** | 072 sets 구성원 = **표지 073 + 면지 074/075/076**(4종·전부 PRD_TYPE.02). **내지 반제품 구성원은 sets에 없음**(SEMI_ROLE.01 미존재). 내지 속성(sizes A5/A4·도수 POPT_000001/2·page_rule 24~300/2)은 **셋트 본체 072에 통합 등록**. → 하이브리드에서 **내지 = 셋트 본체(072) 자기 공식 담당**. |
| **구성원별 공식(신규 PRF)** | **표지 073** → `PRF_HC_COVER`(표지인쇄 S1 + 표지코팅 무광 + 표지용지 아트150). **면지 074/075/076** → 공식 없음(무료·기여 0). |
| **셋트 본체 072 자기 공식(신규 PRF)** | `PRF_HC_BODY`(내지인쇄 + 내지용지 + 제본). ★내지인쇄는 본체 공식이므로 **표지 S1과 PK 충돌 없음**(다른 frm_cd) → **내지 단면=S1·양면=S2 둘 다 배선 가능**(단일 번들의 진성 BLOCKED 해소). |
| **S2 부활** | COMP_PRINT_DIGITAL_S2 `del_yn` Y→N(양면 내지·단가 verbatim 불변·참조 활성공식 0·부작용 0). 부활 SQL 동봉(인간 승인 후 dbmap). |
| **신규 mint** | PRF 2행(PRF_HC_COVER·PRF_HC_BODY) + formula_components 6행(표지3+본체3) + S2 부활(UPDATE 1) + 바인딩 2행(073→COVER·072→BODY). **신규 price_components 0·신규 component_prices 0**(전 comp/단가행 재사용). |
| **골든 PRICE** | A5·내지 양면칼라 100p·표지 단면칼라·무광단면·50권 → 구성원(표지) + 본체(내지+제본) 합산 **PRICE ≠ 0**·이중합산 0·표지 출력매수 정합(펼침 siz)·내지 양면 정확 청구(S2). §5. |
| **잔여 CFM** | CFM-COVER-SPREAD-SIZ(표지 펼침 siz 코드)·CFM-INNER-PLATE(내지 판형=국4절 매핑)·CFM-S2-REVIVE(부활 승인)·CFM-COVER-A4PLT(A4 3절 절가)·CFM-COVER-MAT(표지 자재코드)·CFM-COVER-SONJI(손지). §7. |

---

## 1. 라이브 구조 실측 (2026-06-25 SELECT) — 하이브리드 레이어 배치

### 1.1 072 sets 구성원 (t_prd_product_sets·실측)

| disp_seq | sub_prd_cd | prd_nm | prd_typ | semi_role | sub_prd_qty | min/max/incr | 공식 바인딩 |
|---|---|---|---|---|---|---|---|
| 1 | PRD_000073 | 하드커버책자-표지(전용지) | PRD_TYPE.02 | SEMI_ROLE.02(표지) | 1 | (NULL 고정) | ❌ 0행 |
| 2 | PRD_000074 | 하드커버책자-면지(화이트면지) | PRD_TYPE.02 | SEMI_ROLE.03(면지) | 1 | (NULL) | ❌ 0행 |
| 3 | PRD_000075 | 하드커버책자-면지(블랙면지) | PRD_TYPE.02 | SEMI_ROLE.03(면지) | 1 | (NULL) | ❌ 0행 |
| 4 | PRD_000076 | 하드커버책자-면지(그레이면지) | PRD_TYPE.02 | SEMI_ROLE.03(면지) | 1 | (NULL) | ❌ 0행 |

- ★**내지 반제품 구성원 없음.** 면지 3색 = 택1(각 sub_prd_qty=1·무료 색 CPQ). 전 구성원·본체 가격공식 바인딩 **0행**.

### 1.2 내지 속성 = 셋트 본체 072에 통합 (t_prd_product_* · 실측)

| 본체 072 설정 | 값 | 의미 |
|---|---|---|
| sizes | SIZ_000170(A5)·SIZ_000172(A4) | **완제(내지) 사이즈** |
| print_options | POPT_000001·POPT_000002 | **내지 도수**(단면/양면 ※디지털단가행에선 흑백/칼라축으로도 쓰임·inner-print arbitration §1) |
| page_rules | page_min24·max300·incr2 | **내지 페이지룰**(내지 전용) |
| materials | MAT_000001/2/3(면지색)·MAT_000246(표지전용지) | 면지 색 + 표지 용지 |
| plate_sizes | SIZ_000250(150x214)·SIZ_000252(213x303) | 본체 판형 후보(★내지 인쇄 단가행 부재·§3.2) |
| 표지(073)/면지(074~076) 상품설정 | **전부 0행** | 빈 껍데기 반제품 |

- → 하이브리드 배치: **내지(인쇄·용지)는 본체 072 자기 공식**(본체가 내지 차원 보유)·**표지는 073 자기 공식**(표지 차원은 셋트 selections로 주입)·**면지는 무료**·**제본은 본체 072 자기 공식**.

### 1.3 핵심 comp 상태 (t_prc_price_components·실측)

| comp_cd | comp_nm | prc_typ | del_yn | use_dims |
|---|---|---|---|---|
| COMP_BIND_SSABARI | 제본비 싸바리바인더 | .01 단가형 | **N(활성)** | `["proc_cd","min_qty","proc_grp:PROC_000017"]` |
| COMP_BIND_HC_MUSEON | 제본비 하드커버무선 | .01 | **Y(삭제)** | (SSABARI로 대체) |
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄비(단면) | .01 | **N** | `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]` |
| COMP_PRINT_DIGITAL_S2 | 디지털인쇄비(양면) | .01 | **Y(삭제→부활)** | (S1과 동일·212행) |
| COMP_COAT_MATTE | 무광코팅비 | .01 | **N** | `["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]` |
| COMP_PAPER | 용지비(종이별 절가) | .01 | **N** | `["plt_siz_cd","mat_cd"]` |

---

## 2. 구성원별 공식 + 셋트 본체 공식 설계 (하이브리드)

> `evaluate_set_price`(pricing.py:759~795): 구성원은 `evaluate_price({"prd_cd":sub_cd}, mb.selections, mb.qty, proc_sels=mb.procs)`로 **각자 자기 공식** 평가. 본체는 `evaluate_price({"prd_cd":set_prd_cd}, set_selections, copies, proc_sels=set_procs)`로 **자기 공식** 평가. 비목 분리 = frm_cd 분리 → PK 충돌·pansu 혼선 자연 해소.

### 2.1 표지 구성원 공식 — PRF_HC_COVER (073 바인딩)

| disp_seq | comp_cd | 비목 | addtn_yn | use_dims(라이브) | 셋트 selections 주입(member.selections) | 상태 |
|---|---|---|---|---|---|---|
| 1 | COMP_PRINT_DIGITAL_S1 | 표지인쇄 | Y | proc_cd·plt_siz_cd·print_opt_cd·min_qty·proc_grp | proc_cd=PROC_000004·plt_siz_cd=SIZ_000499(국4절)·print_opt_cd=표지도수·siz_cd=**표지펼침**(CFM-COVER-SPREAD-SIZ) | 🟢 READY |
| 2 | COMP_COAT_MATTE | 표지코팅 | Y | proc_cd·plt_siz_cd·coat_side_cnt·min_qty·proc_grp | proc_cd=PROC_000015(무광)·plt_siz_cd=SIZ_000499·coat_side_cnt=1(단면) | 🟢 READY |
| 3 | COMP_PAPER | 표지용지 | Y | plt_siz_cd·mat_cd | plt_siz_cd=SIZ_000499·mat_cd=MAT_000078(아트150·46.65) | 🟢 READY |

- **표지 frm_cd = PRF_HC_COVER**. 표지 구성원(073)→PRF_HC_COVER 바인딩. 표지는 manual qty(=copies) 모드. 표지 출력매수 = `plate_qty(copies, pansu)`, pansu = `fn_calc_pansu(plt_siz_cd=국4절, item_siz=표지펼침)` = **1**(펼침 1-up·§3.1) → 출력매수=copies. ★**단일 번들의 표지 pansu 4-up 과소청구가 해소**: 표지가 자기 공식·자기 siz_cd(펼침)로 평가되므로 완제 A5(4-up)를 받지 않는다.

### 2.2 셋트 본체 공식 — PRF_HC_BODY (072 바인딩·내지+제본)

| disp_seq | comp_cd | 비목 | addtn_yn | use_dims | 셋트 set_selections 주입 | 상태 |
|---|---|---|---|---|---|---|
| 1 | COMP_PRINT_DIGITAL_S2 | 내지인쇄(양면) | Y | proc_cd·plt_siz_cd·print_opt_cd·min_qty·proc_grp | proc_cd=PROC_000004·plt_siz_cd=SIZ_000499·print_opt_cd=내지도수·siz_cd=내지1장작업siz | 🟡 S2 부활 선행(§4) |
| 2 | COMP_PAPER | 내지용지 | Y | plt_siz_cd·mat_cd | plt_siz_cd=SIZ_000499·mat_cd=내지종이(택1) | 🟢 READY(내지종이 단가행 기적재) |
| 3 | COMP_BIND_SSABARI | 제본비 | Y | proc_cd·min_qty·proc_grp | proc_cd=PROC_000023(하드커버무선·셋트 고정 주입) | 🟢 READY |

- **본체 frm_cd = PRF_HC_BODY**. 072 본체→PRF_HC_BODY 바인딩. 본체 평가 qty=**copies**(부수). 단 내지인쇄·내지용지는 판형기준 comp → 본체 공식 평가 시 `comp_qty = plate_qty(copies, pansu_inner)` 환산.
- ★**내지 총내지매수 정합**: `evaluate_set_price`는 본체를 `copies`로 평가하나, 내지인쇄비=[총내지매수][도수]×총내지매수(부수×⌈페이지/판걸이⌉). 본체 공식의 plate_qty(copies, pansu_inner)는 **부수÷판수** 1단계만 환산(페이지 곱 미반영). → ★**내지 총내지매수(페이지 곱)는 단일 본체 공식의 plate_qty로는 완전 표현 불가**(pricing.py 본체 공식은 copies 1수량 기준). **CFM-INNER-TOTSHEET**: 내지인쇄를 본체 공식 plate_qty로 둘지, 내지를 별도 반제품 구성원(derive_inner_sheets로 총내지매수 qty 산출)으로 승격할지 결정 필요(§2.4·§7). **하이브리드 정합 모델은 내지=별도 구성원**이 정석(뷰 레이어 derive_inner_sheets가 총내지매수 산출). 현 라이브는 내지가 본체 통합 → 구조 갭.

### 2.3 면지 구성원 — 공식 없음 (무료)

- 074/075/076 = 화이트/블랙/그레이 무지 색 택1(sub_prd_qty=1·disp_seq 2/3/4). 권위 6비목에 면지 비목 없음 + 면지 무지(인쇄/코팅 없음) + COMP_PAPER 면지색(MAT_000001/2/3) 단가행 0행 → **기여 0**. 공식 미민팅. evaluate_set_price에서 면지 구성원은 `qty` 미산출(무료)이거나 has_formula=false → contribution 0.

### 2.4 ★단일 번들 인공 문제의 자연 해소 (아키텍처 교정 핵심)

| 단일 번들(폐기) 문제 | 하이브리드 해소 |
|---|---|
| 표지 pansu = fn_calc_pansu(국4절, 완제A5)=4 → 표지 3비목 ~3.8배 과소청구 | 🟢 **해소** — 표지가 자기 공식·자기 siz_cd(표지펼침)로 평가 → pansu=1(펼침 1-up)·출력매수=copies 정확. 내지(완제 siz)와 표지(펼침 siz)가 **다른 frm_cd**라 siz_cd 충돌 없음. |
| 표지인쇄·내지인쇄 둘 다 S1 → 한 공식 PK(frm_cd,comp_cd) 충돌 | 🟢 **해소** — 표지인쇄=PRF_HC_COVER의 S1·내지인쇄=PRF_HC_BODY의 S2 → **다른 frm_cd**라 PK 충돌 없음. |
| 내지인쇄 진성 BLOCKED(2번째 활성 인쇄 comp 부재) | 🟢 **해소** — 내지=본체 공식이므로 표지와 분리. 양면 내지=S2(부활)·단면 내지=S1 둘 다 배선 가능(본체 공식엔 표지 S1 없음). |
| 표지/내지 용지비 한 comp 2번째 평가슬롯 BLOCKED | 🟢 **해소** — 표지용지=PRF_HC_COVER COMP_PAPER·내지용지=PRF_HC_BODY COMP_PAPER → 다른 frm_cd·각자 1회 평가. |
| 잔여(하이브리드도 미해소) | 🟡 **내지 총내지매수(페이지 곱)** — 본체 공식 copies 평가로는 페이지 곱 미반영(CFM-INNER-TOTSHEET·§7). 정석 = 내지를 별도 구성원 승격(derive_inner_sheets). |

---

## 3. 표지/내지 판형·출력매수 정합 (라이브 실측·돈 크리티컬)

### 3.1 표지 출력매수 = 펼침 1-up (fn_calc_pansu 실측)

```
fn_calc_pansu('SIZ_000499'(국4절), 'SIZ_000326'(390x290 펼침근사)) = 1   ← 표지 펼침 1대=1판
fn_calc_pansu('SIZ_000499', 'SIZ_000499')                          = 0   ← 동일 siz는 margin으로 0(주의)
fn_calc_pansu('SIZ_000499', 'SIZ_000170'(완제A5))                  = 4   ← ★완제 siz 주면 4-up(단일번들 결함)
```
- 표지 구성원 member.selections.siz_cd = **표지 펼침 사이즈코드**(390x268). 라이브 미등록(가장 근사 SIZ_000326=390x290) → **CFM-COVER-SPREAD-SIZ**(표지 펼침 siz 신설·dbmap·search-before-mint). 신설 전 임시로 SIZ_000326(390x290)로 pansu=1 동작(돈영향: 펼침 근사·1-up 동일).
- 표지 출력매수 = plate_qty(copies=50, pansu=1) = 50판. (단일번들의 13판 과소 → 50판 정합.)

### 3.2 내지 판형 = 국4절(SIZ_000499) 매핑 필수 (인쇄 단가행 제약)

```
S1/S2 단가행 plt_siz_cd 분포 = {SIZ_000077, SIZ_000499}    ← 인쇄 단가는 국4절(또는 SIZ_000077)만
072 plate_sizes = {SIZ_000250(150x214), SIZ_000252(213x303)} ← 인쇄 단가행 0행(매칭 불가)
```
- ★본체 072 plate_sizes(SIZ_000250/252)는 **인쇄 단가행이 없는 판형** → 내지인쇄를 이 판형으로 평가하면 no-match(0원). 내지인쇄 plt_siz_cd는 **국4절(SIZ_000499) 주입 필수** → **CFM-INNER-PLATE**(내지 판형=국4절로 set_selections 주입·또는 072 plate_sizes에 국4절 추가). 내지 1장(A5 148x210)을 국4절에 fn_calc_pansu → pansu(국4절,A5)=4(내지 4-up) → 판수 환산.

### 3.3 표지용지 verbatim (COMP_PAPER·실측)

```
COMP_PAPER · MAT_000078(아트150) · SIZ_000499(국4절) · min_qty=1 · unit_price = 46.65
COMP_PAPER 면지색 MAT_000001/2/3 = 0행 (면지 무료)
```

---

## 4. S2 부활 명세 (CFM-S2-REVIVE·돈 크리티컬·inner-print arbitration 권고)

- **근거**: 내지 양면 단가 = S2에 실재(212행 verbatim·단조 2배 정상). S1(단면) 복제 mint는 양면 과소청구 함정(inner-print-arbitration §3). S2 부활이 정답(search-before-mint·정규화·돈 정합 3중 우위).
- **부작용 0**: S2 참조 활성 공식 0건(실측)·component_prices PK=surrogate → S1/S2 단가행 충돌 없음. 부활해도 기존 가격 무영향.
- **부활 = comp 헤더 del_yn 토글만**(단가행 INSERT/수정 0건).

```sql
-- [제안·미실행] COMP_PRINT_DIGITAL_S2 부활 (양면 내지 단가 복원·verbatim 불변)
UPDATE t_prc_price_components
   SET del_yn = 'N'
 WHERE comp_cd = 'COMP_PRINT_DIGITAL_S2' AND del_yn = 'Y';
-- 멱등: del_yn='Y' 조건부 → 2회 실행해도 1회만. 단가행 212 불변.
```

- S2 단가(국4절 양면칼라 POPT_000002): 1=6000·10=1600·50=1100·100=700·1000=330 …(verbatim 실측). 단면 S1(POPT_000002): 1=4000·10=1000·50=550 → 양면이 단면 ~2배(정상 단조).

---

## 5. 골든 종단 재현 (evaluate_set_price 손계산·PRICE≠0·verbatim 단가)

### 5.1 골든 케이스

| 항목 | 값 | 근거 |
|---|---|---|
| 셋트 | PRD_000072 하드커버책자 | sets 4구성원 |
| 완제(내지)사이즈 | A5(SIZ_000170) | 본체 sizes |
| 표지 펼침 | 390x268(≈SIZ_000326 근사) → 출력판형 국4절(SIZ_000499) | 판걸이수 r64 |
| 내지 도수 | 양면 칼라(POPT_000002·S2) | 본체 print_options·양면 일반 |
| 표지 도수 | 단면 칼라(POPT_000002·S1) | booklet 표지=단면 |
| 페이지 | 100p | page_rule 24~300/2 내 |
| 코팅 | 무광 단면(PROC_000015·coat_side_cnt=1) | booklet 표지코팅 |
| 제본 | 하드커버무선(PROC_000023) | booklet |
| 부수(copies) | 50권 | — |

### 5.2 손계산 (pricing.py:718 evaluate_set_price)

```
호출(price_simulate_set 조립):
evaluate_set_price(
  set_prd_cd='PRD_000072',
  members=[
    {sub_prd_cd:'PRD_000073', role:'SEMI_ROLE.02',
     selections:{siz_cd:표지펼침, plt_siz_cd:SIZ_000499, print_opt_cd:POPT_000002},
     procs:[{proc_cd:PROC_000015, detail:{coat_side_cnt:1}}], qty:50(manual=copies)},
    {sub_prd_cd:'PRD_000074', qty:0/has_formula=false}  # 면지 택1 무료
  ],
  set_selections={plt_siz_cd:SIZ_000499, print_opt_cd:POPT_000002, siz_cd:내지1장(A5),
                  mat_cd:내지종이},
  copies=50,
  set_procs=[{proc_cd:PROC_000023}]   # 제본
)

[A] 구성원 표지 073 → evaluate_price(073, sel, qty=50) → PRF_HC_COVER
    pansu = fn_calc_pansu(plt=국4절, item=표지펼침) = 1
    plate_qty(50, 1) = 50 (표지 출력매수)
    seq1 표지인쇄 S1 POPT_000002 국4절 min_qty tier(50)=550 × 50 = 27,500
    seq2 표지코팅 MATTE PROC_000015 단면 국4절 tier(50)=700 × 50 = 35,000
    seq3 표지용지 PAPER 아트150 국4절 절가 46.65 × 50 = 2,332.5
    표지 contribution = 27,500 + 35,000 + 2,332.5 = 64,832.5

[A'] 구성원 면지 074(택1) → 무료 → contribution 0

[B] 셋트 본체 072 → evaluate_price(072, set_sel, copies=50) → PRF_HC_BODY
    pansu_inner = fn_calc_pansu(국4절, A5) = 4 (내지 4-up)
    plate_qty(50, 4) = ⌈50/4⌉ = 13   ← ★본체 copies 기준 판수(페이지 곱 미반영·CFM-INNER-TOTSHEET)
    seq1 내지인쇄 S2 POPT_000002 국4절 tier(13)=? (10 tier=1600 / 15 tier=1800; min_qty=13→10 tier=1600) × 13 = 20,800
    seq2 내지용지 PAPER 내지종이 절가 × 13
    seq3 제본 SSABARI PROC_000023 — proc_cd 차원만(plt_siz 미사용)·copies=50 tier=9,000 × ??? 
         ★제본 use_dims=[proc_cd,min_qty,proc_grp]·plt_siz 없음 → comp_qty=copies=50? 아니오:
         제본 단가형 .01 = unit_price × comp_qty. 제본 comp_qty = qty(본체 평가수량=copies=50)
         단, plate_qty 미적용(plt_siz 없음) → comp_qty=50 → 9,000 × 50 = 450,000  (제본비 부당9000×50권)
    본체 contribution = 내지인쇄 20,800 + 내지용지 + 제본 450,000

[C] base_total = 표지 64,832.5 + 면지 0 + 본체(내지 20,800+내지용지+제본 450,000)
              ≈ 535,632.5 + 내지용지   ✅ PRICE ≠ 0

[D] 할인: 072 discount_tables 0행(실측) → 할인 없음
[E] final ≈ 535,632원 + 내지용지   ✅
```

- ✅ **PRICE ≠ 0**(제본 450,000 + 표지 64,832.5 + 내지인쇄 20,800).
- ✅ **이중합산 0**: 표지(PRF_HC_COVER)·본체(PRF_HC_BODY) frm_cd 분리·comp 상이·코팅 1회(표지만)·제본 1회(본체만).
- ✅ **표지 출력매수 정합**: pansu=1(펼침)·출력매수=50(단일번들 13 과소 해소).
- ✅ **내지 양면 정확 청구**: S2(양면 1600 tier)·단면 S1(1000) 대비 정확.
- 🟡 **CFM-INNER-TOTSHEET**: 본체 plate_qty(50,4)=13판은 **부수 기준 판수**(페이지 곱 미반영). 권위 내지인쇄비=총내지매수(부수×⌈100/판걸이⌉)×단가. 정석은 내지를 별도 구성원으로 승격해 derive_inner_sheets(50,100,pansu)=총내지매수를 qty로 평가. 현 라이브 구조(내지=본체)로는 페이지 곱 미반영 → **내지인쇄 과소청구 잔존**. §7 라우팅.

---

## 6. 뷰 레이어 정합 (price_simulate_set·price_views.py:1649~1733)

| 뷰 레이어 동작(실측) | 본 설계 정합 |
|---|---|
| `_set_members_meta`(1501) 구성원 순회=sets 4종(표지+면지3) | 🟢 표지=PRF_HC_COVER 평가·면지=무료 |
| 구성원 내지(qty_mode=derived·derive_inner_sheets) | ⚠️ **내지가 sets 구성원이 아님** → 뷰가 내지 derived qty를 산출할 슬롯 없음. 내지=본체 공식이라 본체 copies로만 평가(페이지 곱 누락)·CFM-INNER-TOTSHEET |
| 표지(manual·qty=copies)·plt_siz_cd 주입 | 🟢 표지 manual qty=50·plt_siz_cd=국4절(member.selections) |
| `fn_best_plate(072, A5)`=SIZ_000250 | ⚠️ 본체 내지인쇄는 국4절 필요(S1/S2 단가 국4절만)·SIZ_000250 인쇄단가 0행 → set_selections.plt_siz_cd=국4절 명시 주입(CFM-INNER-PLATE) |
| `fn_best_plate(073, A5)`=NULL(표지 plate_sizes 0행) | ⚠️ 표지 자동판형 도출 불가 → member.selections.plt_siz_cd=국4절 명시 주입 필수 |
| semi_role_cd 사용(SEMI_ROLE.01~05 실재) | 🟢 표지=02·면지=03·내지=01(본체 내포·구성원 미존재) |
| set_procs(제본)·set_selections | 🟢 본체 제본 proc_cd=PROC_000023·set_selections=내지차원 |

- ★**뷰 레이어 갭**: 하이브리드 정석(내지=별도 구성원·derive_inner_sheets)과 현 라이브(내지=본체 통합)의 불일치. 본 설계는 **현 라이브 구조 그대로** 내지를 본체 공식으로 두되, 총내지매수 페이지 곱 미반영을 CFM-INNER-TOTSHEET로 정직 명시(돈 크리티컬·잔존).

---

## 7. search-before-mint + 신규 mint 목록 + CFM/BLOCKED

### 7.1 search-before-mint 전수 (전 comp/단가행 재사용·신규 0)

| 비목 | comp | 재사용 입증(실측) | 판정 |
|---|---|---|---|
| 표지인쇄 | COMP_PRINT_DIGITAL_S1 | del_yn=N·국4절 POPT_000002 verbatim | 재사용(신규 0) |
| 표지코팅 | COMP_COAT_MATTE | del_yn=N·국4절 단면 verbatim | 재사용(신규 0) |
| 표지용지 | COMP_PAPER | del_yn=N·아트150 국4절 46.65 | 재사용(신규 0) |
| 내지인쇄 | COMP_PRINT_DIGITAL_S2 | del_yn=Y→부활(212행 verbatim) | 재사용(부활·신규 0) |
| 내지용지 | COMP_PAPER | 내지종이 국4절 절가 기적재 | 재사용(신규 0) |
| 제본 | COMP_BIND_SSABARI | del_yn=N·PROC_000023 verbatim | 재사용(신규 0) |
| 면지 | (없음) | 무료 | mint 0 |

### 7.2 신규 mint 목록 (set-designer 범위)

| mint 항목 | 테이블 | 행 | 사유 |
|---|---|---|---|
| PRF_HC_COVER | t_prc_price_formulas | 1 | 표지 구성원 공식(라이브 PRF_HC% 0행) |
| PRF_HC_BODY | t_prc_price_formulas | 1 | 셋트 본체 공식(내지+제본) |
| formula_components | t_prc_formula_components | 6 | COVER 3(인쇄S1·코팅·용지)+BODY 3(인쇄S2·용지·제본) |
| S2 부활 | t_prc_price_components(UPDATE) | 1 | del_yn Y→N |
| 바인딩 | t_prd_product_price_formulas | 2 | 073→PRF_HC_COVER·072→PRF_HC_BODY |
| 신규 price_components | — | 0 | 전 comp 재사용 |
| 신규 component_prices | — | 0 | 전 단가행 재사용·S2 부활은 토글 |

### 7.3 CFM / BLOCKED 라우팅

| ID | 항목 | 상태 | 라우팅 | 영향 |
|---|---|---|---|---|
| **CFM-S2-REVIVE** | S2 부활 del_yn Y→N | 🟡 권고(부작용0·verbatim) | dbmap(인간 승인 UPDATE) | 양면 내지 정확청구 |
| **CFM-INNER-TOTSHEET** | 내지 총내지매수(페이지 곱) | 🔴 잔존(돈 크리티컬) | 내지=별도 구성원 승격(dbmap·sets 행 + 내지 반제품 등록) or 본체 공식 plate_qty 한계 수용 | 내지인쇄 페이지 곱 미반영=과소청구 |
| **CFM-INNER-PLATE** | 내지 판형=국4절 매핑 | 🟡 CONFIRM | set_selections.plt_siz_cd=국4절 주입 or 072 plate_sizes에 국4절 추가 | 내지인쇄 0원(판형 단가 부재) 가드 |
| **CFM-COVER-SPREAD-SIZ** | 표지 펼침 siz 코드(390x268) | 🟡 CONFIRM | dbmap siz 신설(임시 SIZ_000326 390x290 근사) | 표지 pansu=1 정합 |
| **CFM-COVER-A4PLT** | A4 표지 3절 절가 | 🔴 BLOCKED | dbmap(아트150 3절 89.54 적재·verbatim) | A4 표지용지 미산출 |
| **CFM-COVER-MAT** | 표지 자재(MAT_000078 vs 246) | 🟡 CONFIRM(돈영향0) | 적재 시 택1 | 단가 동일 46.65 |
| **CFM-COVER-COAT** | 코팅 이중계상 | 🟢 해소 | — | 용지=순수절가·코팅=별 comp |
| **CFM-COVER-SONJI** | 손지 +5장 | 🟡 CONFIRM(소액) | 앱 임포지션 | 출력매수±5 |
| **CFM-HC-DSC** | 072 할인 | 🟢 해소(0행) | — | 할인 없음 |

---

## 8. 077/082/100 전파 노트

| 셋트 | 072 대비 차이 | 전파 |
|---|---|---|
| **PRD_000077 레더 HC책자** | 표지=레더 **정액** 소재비(가격표 row99=4000/row100=7000·"계산식" 아님) | PRF_HC_COVER 동형이나 **표지용지=정액 comp**(COMP_PAPER 절가모델 부적합·표지전용 정액 comp 검토·dbmap). 본체 PRF_HC_BODY는 072 동형(제본·내지). 077 표지자재 오등록(078=몽블랑130g) CONFIRM-077-MAT(dbmap) |
| **PRD_000082 HC링책자** | 제본=하드커버트윈링(별 proc)·**면지인쇄+면지코팅 2비목 추가(8비목)**·표지/면지 ×2 | 별 PRF·★**multiplier 부재**(formula_components에 계수 컬럼 없음·§스키마 실측) → ×2는 면지를 **별 구성원**(083 표지·087 인쇄면지)으로 분리해 각자 자기 공식 평가가 정석(하이브리드 강점). 면지인쇄=COMP_PRINT_DIGITAL_S1/S2 재사용 |
| **PRD_000100 포토북** | base24 통합형(상품단가+페이지당단가)·표지 5 variant | base24/per2p comp 별도 트랙(§18 photobook)·하이브리드 구성원 분해와 별 모델(고정가형) |

- ★하이브리드 강점: 082의 ×2(표지/면지 양면)는 **면지를 별 구성원으로 분리**하면 multiplier 없이 자연 표현(각 구성원 자기 공식 1회 평가). 단일 번들의 ×2 계수 필요가 구성원 분리로 해소.

---

## 9. 적재 경계 (DB 미적재)

- 본 산출 = PRF 2정의 + formula_components 6배선 + S2 부활 UPDATE + 바인딩 2행 설계 + verbatim 단가 재사용 입증 + 골든 + 하이브리드 정합 + CFM/BLOCKED 분리. **실 INSERT/UPDATE/COMMIT·바인딩은 게이트 GO + 인간 승인 후 hsp-load-executor / dbmap 위임**.
- ★**바인딩 가드**: CFM-INNER-TOTSHEET(내지 페이지 곱 미반영=과소청구) 미해소 시 072→PRF_HC_BODY 바인딩 보류 권고(돈 크리티컬). 표지 PRF_HC_COVER는 출력매수 정합이라 상대적 안전하나, CFM-COVER-SPREAD-SIZ(펼침 siz) 선결.
- load CSV/apply.sql = PRF 2 + fc 6 + S2 부활 + 바인딩 2(주석·CFM 해소 후 해제). 신규 단가행 0.

---

## 10. 출처 (날조 0)

- 라이브 실측(2026-06-25 읽기전용 SELECT): 072 sets={073표지·074/075/076면지·전부 PRD_TYPE.02·SEMI_ROLE.02/03}·내지 구성원 없음·전 구성원·본체 바인딩 0행·072 본체 sizes{A5·A4}/print_opt{POPT_000001/2}/page_rule{24-300-2}/materials{면지001~003·MAT_000246}/plate_sizes{SIZ_000250·252}·SEMI_ROLE.01~05·COMP_BIND_SSABARI del_yn=N(PROC_000023 50권=9000)·HC_MUSEON del_yn=Y·S1 del_yn=N(국4절 POPT_000002 50=550)·S2 del_yn=Y(212행·국4절 POPT_000002 50=1100·10=1600)·COMP_COAT_MATTE 국4절 단면(50=700)·COMP_PAPER 아트150 국4절=46.65·면지색 0행·PRF_HC% 0행·072 discount 0행·fn_calc_pansu(국4절,SIZ_000326)=1·(국4절,A5)=4·(국4절,국4절)=0·fn_best_plate(072,A5)=SIZ_000250·(073,A5)=NULL·S1/S2 plt_siz={SIZ_000077,SIZ_000499}·formula_components PK=(frm_cd,comp_cd)·컬럼{frm_cd,comp_cd,disp_seq,addtn_yn}(multiplier 없음).
- 엔진 계약: pricing.py:718(evaluate_set_price 구성원별 evaluate_price+본체 공식+할인)·:702(derive_inner_sheets)·:551~596(_evaluate_formula·:559~564 pansu=fn_calc_pansu(plt,siz_cd)·공식별 1회)·:199(plate_qty ⌈qty/pansu⌉). price_views.py:1472(_fn_calc_pansu)·:1501(_set_members_meta semi_role/derive)·:1649~1733(price_simulate_set 구성원 조립·내지 derived·표지 manual).
- 권위/직전: set-price-authority.md §1.1·hc072-final-design.md(폐기·비목 사실 참고)·inner-print-comp-arbitration.md(S1단면/S2양면·S2 부활)·cover-paper-calc-derivation.md(아트150 46.65)·lining-price-derivation-method.md(면지 무료)·cover-pansu-a4plt-investigation.md(표지 펼침·A4 3절 89.54)·price-pilot-hc072-gate.md(SSABARI 대체·구성원 PRD_TYPE.02).
