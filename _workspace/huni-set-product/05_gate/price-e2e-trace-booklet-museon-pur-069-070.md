# price-e2e-trace-booklet-museon-pur-069-070.md — S4 셋트 가격 종단 재현 (069 무선=138,688·070 PUR=288,688)

> 검증자: hsp-set-gate 2026-07-01 · 생성자(set-designer) 주장 비신뢰 · 라이브 읽기전용 SELECT 실측 · DB 미적재.
> 방법: Django 런타임 미구동 → **evaluate_set_price 알고리즘 정확 재현**(pricing.py:844 로직 그대로 + 라이브 단가행 실측값 주입). 손계산 아님 — match_component(:134)/_row_matches(:94)/plate_qty(:215)/component_subtotal(:193)/_evaluate_formula(:643) 코드 경로 재현.

---

## 0. evaluate_set_price 알고리즘 (pricing.py:844 실독·068 동형)

```
evaluate_set_price(set_prd_cd, members=[표지member, 내지member], set_selections{제본}, copies=100):
  for mb in members:
      res = evaluate_price({prd_cd: mb.sub_prd_cd}, mb.selections, mb.qty)   # 호출자 주입 qty(:851·:904)
      base_total += res.base.amount
  set_eval = evaluate_price({prd_cd: set_prd_cd}, set_selections, copies=100) # 자기공식 qty=copies(:920)
  base_total += set_eval.base.amount
  final = base_total − 할인(셋트 1회·:937)
```

핵심 코드 사실(실독):
- **member.qty = 호출자 산출 유효수량**(:851·:904) — 표지 member에 `copies × cover_mult`(069/070=×1=copies=100) 주입.
- **plate comp 환산**(:677-708): use_dims에 `plt_siz_cd` 있으면 `comp_qty = plate_qty(qty, pansu) = ⌈qty/pansu⌉`. pansu = `fn_calc_pansu(sel.plt_siz_cd, sel.siz_cd)`.
- **_row_matches**(:94): 행 차원이 NOT NULL이면 sel과 일치해야 통과. proc_cd 행값 있는 comp는 sel.proc_cd 주입 필수.
- **단가형 PRICE_TYPE.01**(:193) = `unit_price × comp_qty`.
- **제본공식은 plt_siz_cd 차원 없음** → is_plate=False → comp_qty = copies(:678) — 제본=단가 × 부수.

---

## 1. 라이브 단가행 실측 (2026-07-01·verbatim·SIZ_000499 판형)

| comp | use_dims (실측) | selection | 매칭행수(라이브) | tier(100) | unit_price |
|------|-----------------|-----------|:---------------:|:---------:|:----------:|
| COMP_PRINT_DIGITAL_S1 | `[proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001]` | 499·POPT_000001·PROC_000004·m≤100 | **1** | 100 | **350.00** |
| COMP_COAT_MATTE | `[proc_cd, plt_siz_cd, coat_side_cnt, min_qty, proc_grp:PROC_000013]` | 499·coat_side=1·PROC_000015·m≤100 | **1** | 100 | **500.00** |
| COMP_PAPER (표지) | `[plt_siz_cd, mat_cd]` | 499·MAT_000073(백모120) 단가형 단일행 | **1** | — | **36.88** |
| COMP_BIND_MUSEON (069 제본) | `[proc_cd, min_qty, proc_grp:PROC_000017]` | PROC_000019·m≤100 | **1** | 100 | **500.00** |
| COMP_BIND_PUR (070 제본) | `[proc_cd, min_qty, proc_grp:PROC_000017]` | PROC_000020·m≤100 | **1** | 100 | **2000.00** |
| COMP_PAPER (내지) | `[plt_siz_cd, mat_cd]` | 499·MAT_000074 단가형 단일행 | **1** | — | **70.64** |

★ 매칭행수 전부 **1** → ERR_AMBIGUOUS/ERR_DUPLICATE 없음. **MUSEON(019만)·PUR(020만) 각 단일 proc_cd** → proc_cd 미주입이어도 _combo_key 1개·silent 다중매칭 위험 0(대조: TWINRING=4 proc_cd → 071 위험·069/070 무관).
★ `fn_calc_pansu(SIZ_000499, SIZ_000174) = 1` 실측 → 표지 1매=1판. `(499,A4=172)=2`·`(499,A5=170)=4` — A3펼침(174)이라야 pansu=1 정확(A4/A5면 저청구).

---

## 2. 종단 재계산 (알고리즘 재현·100부·A3펼침 표지/칼라단면/백모120 무광)

### 2a. 표지 member (069=PRD_000290·070=PRD_000292·qty=copies×1=100·PRF_BOOK_COVER) — 069/070 동일
- pansu = fn_calc_pansu(499,174) = **1** → comp_qty(plate) = ⌈100/1⌉ = **100**
- 표지인쇄 COMP_PRINT_DIGITAL_S1 = 350.00 × 100 = **35,000**
- 표지코팅 COMP_COAT_MATTE      = 500.00 × 100 = **50,000**
- 표지용지 COMP_PAPER(백모120)   = 36.88  × 100 = **3,688**
- **표지 member 소계 = 88,688** ✓ (069·070 동일 — 같은 표지 comp·같은 SIZ_000499·같은 mat)

### 2b. 셋트 자기공식 — 제본 (qty=copies=100·plt_siz_cd 차원 없음)
- 069 제본 COMP_BIND_MUSEON(PROC_000019) = 500.00 × 100 = **50,000**
- 070 제본 COMP_BIND_PUR(PROC_000020)    = 2000.00 × 100 = **200,000**

### 2c. 골든 도달
```
069 무선: 표지 88,688 + 제본 50,000  = 138,688   골든(spec §1)=138,688  → 일치 TRUE·오차 0
070 PUR : 표지 88,688 + 제본 200,000 = 288,688   골든(spec §1)=288,688  → 일치 TRUE·오차 0
```
(라이브 SQL 직접 산식 재확인: `350*100+500*100+round(36.88*100)+500*100=138688`·`...+2000*100=288688`)

### 2d. 내지 member (069=PRD_000289·070=PRD_000291·PRF_DGP_INNER=S1+PAPER·page파생)
- 골든 138,688/288,688은 **표지+제본만** 정의(spec §1 표·적재본 line 29·30). 내지는 page파생 별도 가산.
- sanity: 내지용지 MAT_000074@499=70.64 충전·내지 인쇄옵션 4종(POPT 001/002/008/009) 적재 → 내지 member PRICE≠0(견적0 아님).
- **DBLPANSU 코드결함**(price_views.py:1707·내지 이중÷pansu·전 책자 공통)은 내지비 환산에만 영향·표지/제본 무영향 → C트랙(BLOCKED 보드 C-TRACK-ENGINE-DBLPANSU).

---

## 3. 이중합산 0 증명 (비목 단일 귀속)

| 비목 | 표지 member(290/292) | 내지 member(289/291) | 셋트공식(069/070) | 단일귀속 |
|------|:---:|:---:|:---:|:---:|
| 표지인쇄/코팅/용지 | ● PRF_BOOK_COVER | ✗ | ✗ | ✅ |
| 내지인쇄/용지 | ✗ | ● PRF_DGP_INNER | ✗ | ✅ |
| 제본 | ✗ | ✗ | ● 069 PRF_BIND_MUSEON / 070 PRF_BIND_PUR | ✅ |

★ COMP_PAPER 충돌 가드: 표지용지(member290/292·MAT_000073·plt499)·내지용지(member289/291·MAT_000074·plt499)는 **다른 frm_cd(BOOK_COVER vs DGP_INNER)·다른 mat_cd·다른 evaluate_price 호출(다른 member)** → 같은 비용 2회 계상 없음. 같은 공식 내 2회 배선 아님 → `_combo_key` 충돌 0.
★ 제본 1회만: 069=MUSEON·070=PUR 셋트공식에서만 1회 평가(표지/내지 member에 제본 comp 없음).

---

## 4. 판정

| 점검 | 069 무선 | 070 PUR |
|------|:--------:|:-------:|
| 골든 정확 도달 | ✅ 138,688 (오차 0) | ✅ 288,688 (오차 0) |
| PRICE≠0 | ✅ 표지 88,688 + 제본 50,000 | ✅ 표지 88,688 + 제본 200,000 |
| 표지 member SIZ_000499·pansu=1 → 표지 1매=1판 | ✅ (A4=2·A5=4 저청구 부결) | ✅ |
| 이중합산 0 | ✅ 비목 단일귀속 | ✅ |
| 단가 verbatim (350/500/36.88 + 제본) | ✅ 라이브 byte 일치 (제본 500) | ✅ (제본 2000) |
| 제본 silent 다중매칭 | ✅ MUSEON 단일 proc(019) | ✅ PUR 단일 proc(020) |

**S4 = PASS (069·070 모두).** ★068과 달리 **신규 공식 0** — PRF_BOOK_COVER·PRF_DGP_INNER·PRF_BIND_MUSEON·PRF_BIND_PUR 전부 라이브 실재(use_yn=Y·바인딩 보유). 따라서 t_prc_* 신규 COMMIT 불요·평가 즉시 가능(068의 BLOCKED ②트랙 없음). 셋트행+반제품(t_prd_*)만 적재하면 138,688/288,688 즉시 산출.
