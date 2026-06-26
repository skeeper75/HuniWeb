# 072 하드커버책자 PRF 트랙 설계 — DBLPANSU 해소 + 3 PRF 민팅 + S2 부활 (돈 크리티컬)

생성: hsp-set-designer (생성 패스·**자기승인 금지**) · 2026-06-26 라이브 읽기전용 SELECT 직접 재실측 + `pricing.py`/`price_views.py` 코드 verbatim 실측 · **DB 미적재**(COMMIT/INSERT/UPDATE/DDL 0·설계+멱등 SQL 제안+골든 손계산까지·실 적재는 인간 승인 후 dbmap/§6 위임) · **webadmin 코드 직접수정 0**(정합 명세로 §6/dbmap 위임) · 단가 verbatim·날조 0 · search-before-mint 전수

> ★**목적**: 내지 반제품 승격 그릇(PRD_000284·vessel GO) 위에서 072 내지/표지/제본 가격이 `evaluate_set_price`로 end-to-end 정확히 청구되도록 **3 PRF + S2 부활**을 설계하고, **CFM-INNER-DBLPANSU(이중 ÷pansu·돈 크리티컬)를 해소 또는 정확히 라우팅**한다.
> ★**범위 경계**: 본 명세 = ① DBLPANSU 해소 결론(데이터 vs 코드) ② PRF_HC_INNER(284 바인딩) ③ PRF_HC_COVER(073 바인딩) ④ PRF_HC_BODY(072 바인딩=제본only) ⑤ S2 부활 ⑥ formula_components 배선 + 바인딩 ⑦ 골든 양면 대조. **생성 only — 검증/codex/게이트(S1~S7)는 후속 패스**.

---

## ★0. 결론 요약 (한눈에 · executive)

| 항목 | 결론 |
|---|---|
| **DBLPANSU 해소 가능?** | 🟡 **데이터로는 부분 해소 가능하나 정석 아님 — 정석은 코드 1줄(뷰 계약) 교정**. 두 후보를 분석한 결과 **(a) 뷰 계약 변경이 canonical fix**(데이터 PRF는 표준 comp 재사용·날조 0). (b) 데이터-only는 가능하나 **inner 전용 comp 2종 + 단가행 ~265행 over-mint**(공유 comp 오염 방지 위해)라 search-before-mint 위반·열위. → ★**코드 트랙(§6/dbmap)으로 라우팅**, 데이터 PRF는 (a) 계약 전제로 표준 설계. |
| **DBLPANSU 정확한 진원** | `price_views.py:1707` derive_inner_sheets(50,100,4)=**1,250판**(÷pansu 1회·페이지곱) → `:1709` plt_siz_cd=국4절 주입 → `pricing.py:564` pansu=fn_calc_pansu(국4절,A5)=**4** → `:574-581` plate_qty(1250,4)=**313판**(÷pansu 2회) → S2/COMP_PAPER가 313판으로 평가 = **내지 ~1/2.4 과소청구**. |
| **canonical fix (a)** | 뷰 `:1707` derived 분기에서 member qty = **`copies × pages`(미환산·5,000)** 전달, plt_siz_cd 주입 유지 → `_evaluate_formula`가 plate_qty(5000,4)=**1,250판** ÷pansu **1회**만 = 정확. PRF는 표준 S2/COMP_PAPER plt_siz_cd 그대로(날조 0·재사용). **단 derive_inner_sheets 의도 주석(:697)과 충돌 → 뷰 계약 명시 교정 필요(§6 핸드오프).** |
| **PRF_HC_INNER** | 284 바인딩. 내지인쇄(S2 양면/S1 단면) + 내지용지(COMP_PAPER 7자재). comp **전부 표준 재사용**·신규 0. |
| **PRF_HC_COVER** | 073 바인딩. 표지인쇄 S1 + 표지코팅 무광 단면 + 표지용지 아트150. 표지 펼침 siz(CFM)·qty=copies 계약. |
| **PRF_HC_BODY** | 072 본체 바인딩. **제본만**(COMP_BIND_SSABARI·PROC_000023). 내지/표지 comp 잔류 0(이중평가 가드). |
| **S2 부활** | COMP_PRINT_DIGITAL_S2 del_yn Y→N. **참조 활성공식 0건 실측 확증**(부작용 0)·단가 212행 verbatim 불변. UPDATE 1행 제안. |
| **신규 mint** | PRF 3 + formula_components 8(INNER 2 + COVER 3 + BODY 1 ※INNER는 도수 택1이라 S1/S2 둘 다 배선=2행) + S2 부활 UPDATE 1 + 바인딩 3. **신규 price_components 0·신규 component_prices 0**(전 comp/단가행 재사용). |
| **골든(A5·내지양면칼라100p·표지단면칼라무광·50권)** | 🟢 **정답 PRICE = 968,432.5원** · 🔴 DBLPANSU 함정값 = 695,395.94원(내지 ~273,036원 과소). PRICE≠0·이중합산 0·표지 펼침 1-up 정합. |
| **여전히 NO-GO 잔여** | DBLPANSU 코드 교정(§6 미적용 시 내지 과소청구)·S2 부활 승인·표지 펼침 siz 신설(CFM-COVER-SPREAD-SIZ)·A4 3절 절가/판형(BLOCKED)·CFM-INNER-WORKSIZ(단면150x212/양면213x303 pansu 분기). |

**판정: 생성 패스 완료. DBLPANSU는 데이터로 정석 해소 불가 → 코드 트랙(§6) 라우팅 + 표준 PRF 설계. 골든 정답 968,432.5원 확보(코드 교정 전제). 재검증(게이트 S1~S7 + codex) 대기. 자기승인 금지.**

---

## 1. 라이브 재실측 (2026-06-26 읽기전용 SELECT · 코드 verbatim)

### 1.1 선행 상태 (vessel 미적재 확인)

```
PRD_000284(내지 반제품)         = 0행 (vessel apply.sql 미COMMIT·승인 대기)
MAX prd_cd                       = PRD_000283
PRF_HC%                          = 0행 (PRF 미민팅)
MAX frm_cd 류                    = PRF_TTEOKME_FIXED·PRF_STK_* … (PRF_HC_* 신규 정당)
COMP_PRINT_DIGITAL_S2 del_yn     = Y (부활 선행)
COMP_PRINT_DIGITAL_S2 참조 공식  = 0행 (t_prc_formula_components WHERE comp_cd=S2 → 부작용 0)
```

- ★본 PRF 트랙은 **vessel(284 그릇) COMMIT 이후** 적용. 둘은 별 인간 승인 항목(vessel=§8-2단계·PRF=§8-3단계).

### 1.2 comp 헤더 (전부 표준·재사용·실측)

| comp_cd | comp_nm | prc_typ | use_yn | del_yn | use_dims |
|---|---|---|---|---|---|
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 | .01 단가형 | Y | **N** | `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]` |
| COMP_PRINT_DIGITAL_S2 | 디지털인쇄비 | .01 | Y | **Y(부활)** | `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]` |
| COMP_PAPER | 용지비(종이별 절가) | .01 | Y | N | `["plt_siz_cd","mat_cd"]` |
| COMP_COAT_MATTE | 무광코팅비 | .01 | Y | N | `["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]` |
| COMP_BIND_SSABARI | 제본비 싸바리바인더 | .01 | Y | N | `["proc_cd","min_qty","proc_grp:PROC_000017"]` ← ★plt_siz_cd 없음(판수환산 안 함) |

### 1.3 proc 위상 (proc_grp 필터 정합·실측)

```
PROC_000004 디지털  → upr PROC_000001 인쇄  (S1/S2 proc_grp:PROC_000001 매칭)
PROC_000015 무광    → upr PROC_000013 코팅  (COAT proc_grp:PROC_000013 매칭)
PROC_000023 하드커버무선제본 → upr PROC_000017 제본 (SSABARI proc_grp:PROC_000017 매칭)
```

### 1.4 verbatim 단가 (골든 산지·전부 라이브 실측·날조 0)

```
[내지인쇄 S2 국4절 POPT_000002(칼라양면)] 50판=1100·100=700·300=540·1000=330·1200=326  (53행 실재)
[내지인쇄 S1 국4절 POPT_000002(칼라단면)] 50판=550·100=350·1000=165                    (단면 선택 시)
[내지용지 COMP_PAPER 국4절] MAT_000073(백모120)=36.88·077=36.68·087=36.68·095=54.87·096=71.33·104=59.25·105=77.03
[표지인쇄 S1 국4절 POPT_000002] 50판=550
[표지코팅 COMP_COAT_MATTE 국4절 단면(coat_side_cnt=1) PROC_000015] 50판=700
[표지용지 COMP_PAPER 아트150 MAT_000078 국4절] 46.65
[제본 COMP_BIND_SSABARI PROC_000023(하드커버무선)] 50권=9000·100=7000·1000=6000
```

- ★note 텍스트는 S1·S2 모두 "…/양면…"으로 박혀 있으나(가격표 산지 오타), **면 권위 = comp_cd 접미사 S1=단면/S2=양면**(inner-print-comp-arbitration §1.3 컨벤션 확정). print_opt_cd는 도수(흑백 POPT1/칼라 POPT2)축.

---

## 2. ★CFM-INNER-DBLPANSU 해소 — 두 후보 심층 분석 + 결론

### 2.1 진원 코드 사슬 (verbatim·확정)

```
[price_views.py price_simulate_set, qty_mode='derived' 분기]
:1704  plate = plt or _fn_best_plate(prd_cd, siz_cd)
:1706  pansu = _fn_calc_pansu(plate, siz_cd)                       # = fn_calc_pansu(국4절, A5) = 4
:1707  eff_qty = derive_inner_sheets(copies, pages, pansu)        # = 50×⌈100/4⌉ = 50×25 = 1,250판  ← ÷pansu 1회
:1708  if plate: sel["plt_siz_cd"] = plate                        # plt_siz_cd=국4절 member.selections 주입

[pricing.py evaluate_set_price → evaluate_price(284, sel, qty=1250)]
:774   evaluate_price({"prd_cd":284}, mb.selections, int(mqty)=1250, ...)

[pricing.py _evaluate_formula]
:561   needs_plate = any plt_siz_cd in use_dims                   # S2·COMP_PAPER True
:564   pansu = _calc_pansu(plate=국4절, item_siz=A5)              # = 4 (AGAIN)
:574   if "plt_siz_cd" in non_qty:
:575       pq = plate_qty(qty=1250, pansu=4) = ⌈1250/4⌉ = 313판   # ★÷pansu 2회 = 이중
:581   comp_qty = 313                                            # S2·COMP_PAPER가 313판으로 평가
```

- ★**의도(pricing.py:695~699 주석)**: "구성원 수량은 호출자가 산출해 넘긴다(내지 총내지매수=부수×⌈페이지수/판걸이수⌉)". 즉 **evaluate_price는 이미 환산된 총판수를 받아 재환산하면 안 된다**. 그러나 `_evaluate_formula`(:574)는 plt_siz_cd comp에 plate_qty를 **무조건** 재적용. → **의도 ↔ 구현 충돌**(주석은 "재분할 금지"·코드는 "재분할 실행"). 이것이 DBLPANSU의 본질이다.

### 2.2 후보 (a) — 뷰 계약 변경 (member qty = copies×pages·미환산) 🟢 canonical

| 항목 | 분석 |
|---|---|
| **변경 위치** | price_views.py:1707 `eff_qty = derive_inner_sheets(...)` → **`eff_qty = copies * pages`**(=5,000). plt_siz_cd 주입(:1708~1709)·pansu 계산(:1706)은 유지. breakdown total_sheets는 표시용으로 derive 유지 가능. |
| **결과** | `_evaluate_formula`가 plate_qty(5000, 4)=⌈5000/4⌉=**1,250판** ÷pansu **1회**만 → S2/COMP_PAPER 정확. |
| **PRF 데이터** | 🟢 **표준 S2·COMP_PAPER plt_siz_cd 그대로**(use_dims 불변·날조 0·전 상품 공유 comp 무손상). search-before-mint 완전 준수. |
| **정합성** | 🟢 `_evaluate_formula`의 plate_qty는 "주문장수→판수" 변환기로 **단일 책임 유지**. 의도 주석(:697)을 "뷰는 미환산 페이지장수를 넘긴다"로 교정하면 의도↔구현 정합 회복. |
| **비용** | 🔴 **webadmin 코드 1줄 변경**(price_views.py) → §6/dbmap 트랙·직접수정 금지. + 주석(:697) 의도 교정. |
| **부작용** | 🟡 derive_inner_sheets를 쓰는 다른 호출처 확인 필요(현재 price_simulate_set 1곳·grep로 검증 후). breakdown.total_sheets 표시는 별도 계산 유지. |

### 2.3 후보 (b) — 데이터-only (inner 전용 comp·plt_siz_cd 제외) 🔴 열위

| 항목 | 분석 |
|---|---|
| **착상** | 내지인쇄/내지용지를 **plt_siz_cd 없는 새 comp**로 만들면 `needs_plate=False`(:561) → `comp_qty=qty=1,250판`(plate_qty 미적용·:574 조건 거짓) → ÷pansu 1회만. |
| **★단가 매칭 영향 (코드 실측·결정적)** | `_row_matches`(:82~90)는 comp의 use_dims가 아니라 **하드코딩 NON_QTY_DIMS 튜플**(:42)을 순회한다. 즉 use_dims에서 plt_siz_cd를 빼도 **매칭은 여전히 row.plt_siz_cd vs selections.plt_siz_cd를 검사** → **단가 매칭 모호 안 생김**(국4절 1행만 통과). use_dims는 (1)plate_qty 트리거 (2)"판별차원없음" 노트에만 영향. → ★**(b)는 기술적으로 동작 가능**. |
| **★over-mint 문제 (치명)** | S2·COMP_PAPER는 **전 상품 공유 comp**. 공유 comp의 use_dims에서 plt_siz_cd를 빼면 plate_qty가 필요한 모든 상품(엽서 등)이 깨진다. → 내지 전용으로 **새 comp 2종**(예 COMP_PRINT_INNER_S1/S2·COMP_PAPER_INNER) mint 필요. `_component_rows`(:259)는 comp_cd로 단가행을 가져오므로 **단가행도 복제**(S1 53 + S2 53 + COMP_PAPER 7·국4절분 = ~113~265행 over-mint). |
| **판정** | 🔴 **search-before-mint 위반**(이미 있는 자원 재창조)·단가행 대량 복제(정합 부담·날조 경계)·내지인쇄가 "판수 비례"라는 물리 의미를 데이터에서 은폐(plate_qty 단일 책임 우회). **(a) 대비 전 항목 열위**. |

### 2.4 ★결론 (canonical fix)

> 🟢 **canonical = (a) 뷰 계약 변경(코드 트랙)**. 데이터로는 (b)로 우회 가능하나 over-mint·공유 comp 오염 회피 비용·의미 은폐로 **열위**. DBLPANSU는 **데이터 결함이 아니라 뷰↔엔진 계약 결함**이므로 데이터(PRF)에서 고치는 것은 우회일 뿐.
>
> → ★**본 PRF 트랙은 (a) 계약을 전제로 표준 comp 재사용 PRF를 설계**한다(아래 §3). DBLPANSU 코드 교정 자체는 **§6 핸드오프(webadmin price_views.py·인간 승인·§6 위임)**. **코드 교정 전 072→PRF 바인딩 금지**(내지 ~1/2.4 과소청구 가드).

---

## 3. 3 PRF 설계 (하이브리드·표준 comp 재사용·날조 0)

> `evaluate_set_price`(pricing.py:718): ① 구성원(반제품) 각자 `evaluate_price`(자기 frm·자기 selections) Σ + ② 셋트 완제품(072) 자기 frm(제본만·qty=copies) + 할인 1회. frm_cd 분리 → PK(frm_cd,comp_cd) 충돌·pansu 혼선 자연 해소.

### 3.1 PRF_HC_INNER — 내지 반제품(PRD_000284) 바인딩 ★DBLPANSU 핵심

| disp_seq | comp_cd | 비목 | addtn_yn | member.selections 주입(뷰 derived) | 상태 |
|---|---|---|---|---|---|
| 1 | COMP_PRINT_DIGITAL_S1 | 내지인쇄(단면) | Y | proc_cd=PROC_000004·plt_siz_cd=SIZ_000499·print_opt_cd=내지도수·siz_cd=A5 | 🟢 단면 선택 시 |
| 2 | COMP_PRINT_DIGITAL_S2 | 내지인쇄(양면) | Y | 〃(S2·양면) | 🟡 S2 부활 선행(§4) |
| 3 | COMP_PAPER | 내지용지 | Y | plt_siz_cd=SIZ_000499·mat_cd=내지종이7택1 | 🟢 READY |

- ★**S1·S2 둘 다 배선 가능**(comp_cd 상이 → PK 충돌 없음). 단면 주문=S1 매칭·S2 no-match(0)·양면 주문=S2 매칭·S1 no-match(0). `_match_entry`가 print_opt_cd + comp 접미사로 자연 택일(한쪽만 단가 매칭).
- ★**내지 qty 계약**: 뷰가 derived qty 전달. **(a) 적용 시 qty=copies×pages=5,000** → plate_qty(5000, pansu=4)=1,250판 ÷pansu 1회 → 정확. **(a) 미적용 시 qty=1,250(total_sheets)** → plate_qty(1250,4)=313판 = DBLPANSU 함정.
- ★**이중평가 0**: 내지인쇄·내지용지는 PRF_HC_INNER에만. 본체(072 PRF_HC_BODY)·표지(073 PRF_HC_COVER)엔 미배선.
- ★**CFM-INNER-WORKSIZ**: 내지 단면 작업siz=150x212(SIZ_000007 work)·양면=213x303. fn_calc_pansu(국4절, A5 SIZ_000007)=**4** 실측 확증(단면/양면 동일 코드 사용 시). 도수별 작업siz 분기는 뷰가 siz_cd로 주입(현 vessel은 정본 SIZ_000007/050 등록·pansu=4 정합).

### 3.2 PRF_HC_COVER — 표지(PRD_000073) 바인딩

| disp_seq | comp_cd | 비목 | addtn_yn | member.selections 주입(manual qty=copies) | 상태 |
|---|---|---|---|---|---|
| 1 | COMP_PRINT_DIGITAL_S1 | 표지인쇄(단면) | Y | proc_cd=PROC_000004·plt_siz_cd=SIZ_000499·print_opt_cd=표지도수·siz_cd=**표지펼침**(CFM-COVER-SPREAD-SIZ) | 🟢 READY(siz 신설 선결) |
| 2 | COMP_COAT_MATTE | 표지코팅(무광 단면) | Y | proc_cd=PROC_000015·plt_siz_cd=SIZ_000499·coat_side_cnt=1 | 🟢 READY |
| 3 | COMP_PAPER | 표지용지 | Y | plt_siz_cd=SIZ_000499·mat_cd=MAT_000078(아트150·46.65) | 🟢 READY(A5 국4절)·A4 3절 BLOCKED |

- ★**표지 출력매수 = 펼침 1-up**: member.selections.siz_cd=표지펼침(390x268)·pansu=fn_calc_pansu(국4절, 표지펼침)=**1** → plate_qty(copies=50, 1)=50판 정합. 완제 A5(4-up)를 주면 13판으로 ~3.8배 과소(CFM-HC-COVER-PANSU). **표지 펼침 siz 라이브 미등록 → CFM-COVER-SPREAD-SIZ(dbmap siz 신설·임시 SIZ_000326 390x290 근사 pansu=1 동일)**.
- ★표지는 manual qty 모드(뷰 :1714~1721 분기·qty=copies). plate_qty 환산은 표지 펼침 pansu=1이라 출력매수=copies 직결(DBLPANSU 무관·표지는 페이지곱 없음).

### 3.3 PRF_HC_BODY — 셋트 본체(PRD_000072) 바인딩 ★제본만

| disp_seq | comp_cd | 비목 | addtn_yn | set_selections / set_procs 주입(qty=copies) | 상태 |
|---|---|---|---|---|---|
| 1 | COMP_BIND_SSABARI | 제본비 | Y | set_procs=[{proc_cd:PROC_000023}](하드커버무선) | 🟢 READY |

- ★**제본만**. 내지인쇄/내지용지(→PRF_HC_INNER)·표지(→PRF_HC_COVER) 잔류 0 = **이중평가 가드 CFM-BODY-INNER-RESIDUAL 해소**. 본체 072 dims에 내지 sizes/print_opts가 통합 잔류해도, PRF_HC_BODY엔 그 dims를 쓰는 comp가 없으므로 **평가 기여 0**(copy 그릇 비파괴 정합).
- ★**제본 qty**: COMP_BIND_SSABARI use_dims에 plt_siz_cd 없음 → `needs_plate`(이 공식 단독)=False → comp_qty=qty=copies=50. 단가형 = 9000(50권 tier) × 50 = **450,000**. (하드커버 제본 9,000/권은 정상 도메인가·중철 1,000/권 대비.)
- ★**할인**: 072 discount_tables 0행(실측) → 할인 없음.

---

## 4. S2 부활 (CFM-S2-REVIVE·돈 크리티컬·부작용 0 확증)

- **근거**: 내지 양면 단가 = S2 53행 verbatim 실재(단조 ~2배 정상). S1(단면) 복제 mint는 양면 ~50% 과소청구 함정(arbitration §3 폐기). **S2 부활 = search-before-mint·돈 정합·정규화 3중 우위**.
- **부작용 0 (2026-06-26 실측)**: `t_prc_formula_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2'` = **0행**(참조 활성 공식 없음). component_prices PK=surrogate(comp_price_id)·S1/S2 단가행 별개 → 충돌 0. 부활해도 기존 가격 무영향.
- **부활 = comp 헤더 del_yn 토글만**(단가행 INSERT/수정 0건·212행 불변).

```sql
-- [제안·미실행] COMP_PRINT_DIGITAL_S2 부활 (양면 내지 단가 복원·verbatim 불변)
UPDATE t_prc_price_components SET del_yn='N', upd_dt=now()
 WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND del_yn='Y';
-- 멱등: del_yn='Y' 조건부 → 2회 실행해도 1회만. 단가행 불변.
```

---

## 5. 골든 종단 재현 (evaluate_set_price 손계산·verbatim·양면 대조)

### 5.1 골든 케이스

| 항목 | 값 |
|---|---|
| 셋트 | PRD_000072 하드커버책자·부수 50권 |
| 내지(284) | A5(SIZ_000007)·양면칼라(POPT_000002·S2)·100p·내지종이=백모120(MAT_000073) |
| 표지(073) | 펼침siz·단면칼라(POPT_000002·S1)·무광코팅 단면·아트150(MAT_000078) |
| 면지(074~076) | 택1 무료(기여 0) |
| 제본 | 하드커버무선(PROC_000023) |
| pansu | 내지 fn_calc_pansu(국4절,A5)=4 · 표지 fn_calc_pansu(국4절,펼침)=1 |
| total_sheets | derive_inner_sheets(50,100,4)=50×⌈100/4⌉=50×25=**1,250판** |

### 5.2 손계산 — 정답 vs DBLPANSU 함정 (verbatim 단가)

```
[A] 표지 구성원 073 → evaluate_price(073, sel, qty=50) → PRF_HC_COVER (manual·펼침 pansu=1·plate_qty(50,1)=50판)
    seq1 표지인쇄 S1 국4절 POPT_000002 tier(50)=550 × 50 = 27,500
    seq2 표지코팅 MATTE 국4절 단면 tier(50)=700 × 50 = 35,000
    seq3 표지용지 PAPER 아트150 국4절 절가 46.65 × 50 = 2,332.5
    표지 contribution = 64,832.5

[A'] 면지 074 → 무료 → 0

[B] 내지 구성원 284 → evaluate_price(284, sel, qty=?) → PRF_HC_INNER
    🟢 정답 (a 계약: qty=copies×pages=5,000 → plate_qty(5000,4)=1,250판):
       seq2 내지인쇄 S2 국4절 POPT_000002 tier(1250→1200)=326 × 1,250 = 407,500
       seq3 내지용지 PAPER 백모120 국4절 36.88 × 1,250 = 46,100
       내지 contribution = 453,600
    🔴 DBLPANSU 함정 (qty=1,250 전달 → plate_qty(1250,4)=313판):
       seq2 내지인쇄 S2 tier(313→300)=540 × 313 = 169,020
       seq3 내지용지 36.88 × 313 = 11,543.44
       내지 contribution(함정) = 180,563.44

[C] 셋트 본체 072 → evaluate_price(072, set_sel, copies=50) → PRF_HC_BODY (제본만)
    seq1 제본 SSABARI PROC_000023 tier(50)=9,000 × 50 = 450,000

[D] base_total:
    🟢 정답   = 표지 64,832.5 + 면지 0 + 내지 453,600 + 제본 450,000 = 968,432.5
    🔴 함정   = 64,832.5 + 0 + 180,563.44 + 450,000 = 695,395.94

[E] 할인: 072 discount 0행 → 없음.
[F] final:
    🟢 정답 PRICE = 968,432.5원   ✅ PRICE≠0·이중합산 0·표지 1-up·내지 총판수 정확
    🔴 함정 PRICE = 695,395.94원  (내지 ~273,036.56원 과소 = 내지인쇄+용지 453,600 → 180,563.44, ratio 0.398)
```

### 5.3 검증 포인트 충족

- ✅ **PRICE ≠ 0** (정답 968,432.5 / 함정도 ≠0이나 과소).
- ✅ **이중합산 0**: 표지(PRF_HC_COVER)·내지(PRF_HC_INNER)·제본(PRF_HC_BODY) frm_cd 분리·comp 상이. 제본 1회(본체만)·코팅 1회(표지만)·내지인쇄 1회(내지만).
- ✅ **내지 총판수 정확**(a 적용 시): 1,250판 = 50권 × 25판/권(⌈100p/4판걸이⌉).
- ✅ **표지 출력매수 정확**: 펼침 1-up·50판(완제 4-up 13판 함정 회피·펼침 siz 신설 선결).
- 🔴 **DBLPANSU 미해소 시 내지 ~0.4배 과소** → 코드 교정(§6) 전 바인딩 금지.

---

## 6. ★§6/dbmap 핸드오프 — DBLPANSU 코드 교정 정합 명세 (webadmin·인간 승인)

> 본 하네스는 webadmin 코드 직접수정 금지. 아래는 **§6(huni-widget)/dbmap이 적용할 정합 명세**(설계 only).

| 항목 | 명세 |
|---|---|
| **파일·위치** | `raw/webadmin/webadmin/catalog/price_views.py` price_simulate_set, qty_mode='derived' 분기(line 1707). |
| **변경** | `eff_qty = pricing.derive_inner_sheets(copies, pages, pansu)` → **`eff_qty = copies * pages`** (미환산 페이지장수). plt_siz_cd 주입(:1708~1709)·pansu(:1706) 유지. breakdown.total_sheets 표시는 derive_inner_sheets로 별도 계산 유지(표시 정합). |
| **의도 교정** | pricing.py:697 주석 "구성원 수량은 호출자가 산출해 넘긴다(총내지매수)" → **"호출자는 미환산 페이지장수(copies×pages)를 넘기고, plt_siz_cd comp의 판수 환산은 _evaluate_formula의 plate_qty가 단일 수행한다"**로 교정. |
| **부작용 검증** | `grep -rn "derive_inner_sheets" raw/webadmin` → 호출처 전수 확인(현재 price_views.py 1곳·pricing.py 정의). breakdown만 쓰는 곳과 eff_qty로 쓰는 곳 분리. |
| **검증(코드 교정 후)** | evaluate_set_price 골든 재계산 = 내지 453,600·final 968,432.5 재현(§5.2 정답). |
| **대안(코드 변경 불가 시)** | (b) 데이터-only(inner 전용 comp + 단가행 복제)로 폴백 가능하나 over-mint·열위(§2.3) — 차선. |

---

## 7. search-before-mint + 신규 mint 목록

### 7.1 search-before-mint 전수 (전 comp/단가행 재사용·신규 0)

| 비목 | comp | 재사용 입증(실측) | 판정 |
|---|---|---|---|
| 내지인쇄 단면 | COMP_PRINT_DIGITAL_S1 | del_yn=N·국4절 POPT verbatim | 재사용(신규 0) |
| 내지인쇄 양면 | COMP_PRINT_DIGITAL_S2 | del_yn=Y→부활(53행 verbatim·참조 0) | 재사용(부활·신규 0) |
| 내지용지 | COMP_PAPER | 내지종이 7종 국4절 절가 기적재 | 재사용(신규 0) |
| 표지인쇄 | COMP_PRINT_DIGITAL_S1 | 국4절 550 | 재사용(신규 0) |
| 표지코팅 | COMP_COAT_MATTE | 국4절 단면 700 | 재사용(신규 0) |
| 표지용지 | COMP_PAPER | 아트150 국4절 46.65 | 재사용(신규 0) |
| 제본 | COMP_BIND_SSABARI | PROC_000023 50권=9000 | 재사용(신규 0) |
| 면지 | (없음) | 무료 | mint 0 |

### 7.2 신규 mint 목록 (set-designer 범위·DB 미적재)

| mint 항목 | 테이블 | 행 | 사유 |
|---|---|---|---|
| PRF_HC_INNER | t_prc_price_formulas | 1 | 내지 반제품 공식(PRF_HC% 0행) |
| PRF_HC_COVER | t_prc_price_formulas | 1 | 표지 구성원 공식 |
| PRF_HC_BODY | t_prc_price_formulas | 1 | 셋트 본체 공식(제본만) |
| formula_components | t_prc_formula_components | 6 | INNER 2(S1+S2)+COVER 3(S1·코팅·용지)+BODY 1(제본) ※용지 INNER 1행 포함 시 총 6+1=내지용지 별행 → INNER 3·COVER 3·BODY 1 = **7행** |
| S2 부활 | t_prc_price_components(UPDATE) | 1 | del_yn Y→N |
| 바인딩 | t_prd_product_price_formulas | 3 | 284→INNER·073→COVER·072→BODY |
| 신규 price_components | — | 0 | 전 comp 재사용 |
| 신규 component_prices | — | 0 | 전 단가행 재사용·S2=토글 |

- ★정정: formula_components 총 = INNER 3(S1·S2·COMP_PAPER) + COVER 3(S1·COAT·COMP_PAPER) + BODY 1(SSABARI) = **7행**.

---

## 8. 잔여 CFM / BLOCKED 보드

| ID | 항목 | 상태 | 라우팅 | 돈영향 |
|---|---|---|---|---|
| **CFM-INNER-DBLPANSU** | 이중 ÷pansu | 🔴 **코드 트랙 선결**(데이터로 정석해소 불가) | §6 price_views.py:1707 교정(인간 승인) | 내지 ~0.4배 과소 |
| **CFM-S2-REVIVE** | S2 del_yn Y→N | 🟢 권고(부작용 0·참조 0·verbatim) | dbmap UPDATE(인간 승인) | 양면 내지 정확청구 |
| **CFM-COVER-SPREAD-SIZ** | 표지 펼침 siz(390x268) 미등록 | 🟡 CONFIRM | dbmap siz 신설(임시 SIZ_000326 근사 pansu=1) | 표지 3비목 ~3.8배 과소 가드 |
| **CFM-COVER-A4PLT** | A4 표지 3절 절가 89.54 단가행 부재·3절 impos_yn=N | 🔴 BLOCKED | dbmap(3절 절가 적재 verbatim·3절 판형 정합) | A4 표지용지 미산출 |
| **CFM-INNER-WORKSIZ** | 내지 단면150x212/양면213x303 pansu 분기 | 🟡 CONFIRM | 뷰 siz_cd 주입 정합(set-product/§6) | pansu 정합(현 SIZ_000007 pansu=4) |
| **CFM-BODY-INNER-RESIDUAL** | 본체 PRF에 내지 comp 잔류 | 🟢 **해소** — BODY=제본only 설계 | PRF 게이트 검증SQL(072 최신 comp=제본만) | 내지비 이중계상 가드 |
| **CFM-COVER-MAT** | 표지자재 MAT_000078 vs 246 | 🟡 CONFIRM(돈영향 0) | 적재 시 택1(단가 동일 46.65) | 0 |
| **CFM-COVER-COAT** | "+무광코팅" 용지비 포함 여부 | 🟡 CONFIRM | 6비목 구조상 코팅 별도(정합)·실무진 1줄 | 이중계상 가드 |
| **CFM-VESSEL-ZERO** | vessel COMMIT 시 내지=0원 침묵합산(PRF 전) | 🟡 High | 072 노출 가드(use_yn) until PRF 바인딩 | 0원 구성원 합산 |
| **CFM-HC-DSC** | 072 할인 | 🟢 해소(0행) | — | 없음 |

---

## 9. 인간 승인 큐 (순서·돈영향)

| 순서 | 승인 항목 | 파일 | 돈영향 | 전제 |
|---|---|---|---|---|
| **1** | (vessel) 072 내지 승격 COMMIT(PRD_000284·dims·sets) | vessel apply.sql | 간접(그릇만) | inner-promotion 게이트 GO |
| **2** | S2 부활(del_yn Y→N) | apply.sql §A | 간접(토글·참조 0) | 부작용 0 확증 ✅ |
| **3** | 3 PRF + formula_components 7 민팅 | apply.sql §B/§C | 간접(공식 정의·미바인딩) | vessel COMMIT 후 |
| **4** | ★**DBLPANSU 코드 교정**(price_views.py:1707) | §6 핸드오프(webadmin) | 🔴 직접(내지 정확청구 선결) | 인간 승인·grep 부작용 검증 |
| **5** | 표지 펼침 siz 신설(CFM-COVER-SPREAD-SIZ) | dbmap | 🔴 직접(표지 정확청구) | siz 신설 |
| **6** | 바인딩 3행(284→INNER·073→COVER·072→BODY) COMMIT | apply.sql §D | 🔴 직접(가격 활성화) | 4·5 완료 후(과소청구 가드) |
| **7** | 077/082 동형 전파 | (후속) | 간접 | 072 검증 후 |

- ★**바인딩(6단계)은 4(DBLPANSU 코드)·5(표지 펼침 siz) 완료 후에만**. 미완 시 내지 ~0.4배·표지 ~0.26배 과소청구. **그 전까지 072 손님 견적 미노출 가드(use_yn·CFM-VESSEL-ZERO)**.

---

## 10. 077 / 082 전파 노트

| 셋트 | 072 대비 | PRF 전파 |
|---|---|---|
| **PRD_000077 레더 HC책자** | 표지=레더 **정액**(가격표 row99=4000/row100=7000·"계산식" 아님) | PRF_HC_INNER·PRF_HC_BODY는 072 동형(내지 285 승격·제본 PROC_000023). **PRF_HC_COVER만 상이** — 표지용지=COMP_PAPER 절가모델 부적합 → **표지 전용 정액 comp**(use_dims=[siz_cd]·1장당 4000/7000) 검토(§18/dbm-ddl-proposer). 077 표지자재 오등록(078=몽블랑130) CONFIRM-077-MAT 별건. DBLPANSU 동일(내지 공유) → §6 코드 교정이 077도 동시 해소. |
| **PRD_000082 HC링책자** | 제본=하드커버트윈링(PROC_000024)·**면지인쇄+면지코팅 2비목(8비목)**·087 인쇄면지 별 구성원 존재 | PRF_HC_INNER 동형(내지 286 승격)·**PRF_HC_BODY 제본=PROC_000024**(트윈링). 표지=PRF_HC_COVER 동형. ★082 면지인쇄/코팅 ×2는 **087 인쇄면지가 이미 별 구성원**(SEMI_ROLE.03)이라 087 자기 공식(PRF_HC_LINING 신규)으로 자연 표현(multiplier 불요). 내지 작업siz·페이지룰은 082 본체 실측 재확인(트윈링 페이지룰 상이 가능). DBLPANSU 동일 → §6 동시 해소. |

- ★전파 원칙: PRF_HC_INNER + DBLPANSU 코드 교정은 **전 책자 공통**(§6 1회 교정이 072/077/082 동시 해소). PRF_HC_BODY는 제본 proc만 차이(023/024). PRF_HC_COVER는 072=절가/077=정액으로 분기.

---

## 11. 출처 (날조 0)

- **코드 verbatim 실측(2026-06-26)**: pricing.py:561~581(_evaluate_formula needs_plate·pansu=_calc_pansu(plate,item_siz)·plt_siz_cd→plate_qty(qty,pansu))·:181~196(component_subtotal 단가형=unit_price×qty)·:199~213(plate_qty ⌈qty/pansu⌉)·:82~94(_row_matches NON_QTY_DIMS 하드코딩 순회·use_dims 무관)·:42(NON_QTY_DIMS 튜플)·:122~178(match_component combos/tier)·:259~262(_component_rows comp_cd 필터)·:695~715(derive_inner_sheets=copies×⌈pages/pansu⌉·의도 주석)·:718~809(evaluate_set_price 구성원별 evaluate_price+본체+할인). price_views.py:1696~1726(price_simulate_set qty_mode derived eff_qty=derive_inner_sheets·plt_siz_cd 주입·manual qty=copies).
- **라이브 실측(2026-06-26 읽기전용 SELECT)**: PRD_000284=0행·MAX PRD_000283·PRF_HC%=0행·COMP_PRINT_DIGITAL_S2 del_yn=Y/참조 formula_components 0행·S1/S2/COMP_PAPER/COMP_COAT_MATTE/COMP_BIND_SSABARI use_dims·prc_typ PRICE_TYPE.01. 단가 verbatim: S2 국4절 POPT2(50=1100·100=700·300=540·1000=330·1200=326)·S1 국4절 POPT2(50=550·100=350·1000=165)·COMP_PAPER 내지7종(MAT_000073=36.88·077=36.68·087=36.68·095=54.87·096=71.33·104=59.25·105=77.03)·아트150 MAT_000078=46.65·COAT 국4절 단면(50=700)·SSABARI PROC_000023(50=9000·100=7000·1000=6000). proc 위상 PROC_000004→001·015→013·023→017. fn_calc_pansu(국4절,SIZ_000007 A5)=4. PRF_BIND_SUM(069~071 바인딩·COMP_BIND_JUNGCHEOL addtn_yn Y). 스키마: formula_components(frm_cd,comp_cd,disp_seq,addtn_yn,reg_dt,upd_dt) PK(frm_cd,comp_cd)·price_formulas(frm_cd,frm_nm,note,use_yn·del_yn 없음)·product_price_formulas(prd_cd,frm_cd,apply_bgn_ymd,note) PK(prd_cd,frm_cd,apply_bgn_ymd).
- **입력 설계**: inner-promotion-design.md(vessel GO·PRD_000284·정본 SIZ_000007/050·핸드오프 §3.5 가드②)·hc072-set-hybrid-design.md(하이브리드·PRF 초안·S2 부활)·inner-print-comp-arbitration.md(S1단면/S2양면·S2 부활 권고·S1복제 함정)·cover-paper-calc-derivation.md(아트150 46.65)·cover-pansu-a4plt-investigation.md(표지 펼침 1-up·A4 3절 89.54 BLOCKED)·set-price-authority.md §1.1(072 6비목).
- **골든 손계산**: §5.2 verbatim 단가 기반 Python 재계산(정답 968,432.5·함정 695,395.94·내지 ratio 0.398).
