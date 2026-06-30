# price-e2e-trace-booklet-jungcheol-068.md — S4 셋트 가격 종단 재현 (068 완전 동작화·골든 158,688)

> 검증자: hsp-set-gate 2026-07-01 · 생성자 주장 비신뢰 · 라이브 읽기전용 SELECT 실측 · DB 미적재.
> 방법: Django 미설치(raw/webadmin manage.py 있으나 django/psycopg 패키지 부재·.env 부재) → **evaluate_set_price 알고리즘 정확 재현**(pricing.py:844 로직 그대로 Python 재현 + 라이브 단가행 실측값 주입). 손계산 아님 — match_component/plate_qty/component_subtotal 코드 경로 재현.

---

## 0. evaluate_set_price 알고리즘 (pricing.py:844 실독)

```
evaluate_set_price(set_prd_cd=PRD_000068, members=[표지288, 내지287], set_selections{제본}, copies=100):
  for mb in members:
      res = evaluate_price({prd_cd: mb.sub_prd_cd}, mb.selections, mb.qty)   # ← 호출자 주입 qty (line 904)
      base_total += res.base.amount
  set_eval = evaluate_price({prd_cd: PRD_000068}, set_selections, copies=100) # ← 자기공식 qty=copies (line 920)
  base_total += set_eval.base.amount
  final = base_total - 할인(1회)
```

핵심 코드 사실(실독):
- **member.qty = 호출자 산출 유효수량**(pricing.py:851 주석·:904) — 표지 member에 copies=100 주입 가능.
- **plate comp 환산**(:679-692): use_dims에 `plt_siz_cd` 있으면 `comp_qty = plate_qty(qty, pansu) = ⌈qty/pansu⌉`. pansu = `fn_calc_pansu(selections.plt_siz_cd, selections.siz_cd)`.
- **단가형 PRICE_TYPE.01**(component_subtotal:193) = `unit_price × comp_qty`.
- **tier 매칭**(match_component:157-190): min_qty는 '이상' 하한 — 주문값 이하 최대 임계 min_qty 행 선택.

---

## 1. 라이브 단가행 실측 (2026-07-01·verbatim)

| comp | use_dims (실측) | selection | 매칭행수 | tier(100) | unit_price |
|------|-----------------|-----------|:-------:|:---------:|:----------:|
| COMP_PRINT_DIGITAL_S1 | `[proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001]` | 499·POPT_000001·PROC_000004·m≤100 | **1** | 100 | **350.00** |
| COMP_COAT_MATTE | `[proc_cd, plt_siz_cd, coat_side_cnt, min_qty, proc_grp:PROC_000013]` | 499·coat_side=1·PROC_000015·m≤100 | **1** | 100 | **500.00** |
| COMP_PAPER | `[plt_siz_cd, mat_cd]` | 499·MAT_000073 (단가형 단일행) | **1** | — | **36.88** |
| COMP_BIND_JUNGCHEOL | `[proc_cd, min_qty, proc_grp:PROC_000017]` | PROC_000018·m≤100 | **1** | 100 | **700.00** |

★ 매칭행수 전부 = 1 → ERR_AMBIGUOUS / ERR_DUPLICATE 없음. JUNGCHEOL은 proc_cd 1종(018)만 보유 → 다중매칭 위험 0.

★ fn_calc_pansu 실측: `fn_calc_pansu(SIZ_000499, SIZ_000174) = 1` · `(499,A4=172) = 2` · `(499,자신) = 0`.

---

## 2. 종단 재계산 (알고리즘 재현 — 068·100부·A3펼침 표지/칼라단면/중철)

### 2a. 표지 member (PRD_000288·qty=copies=100·PRF_BOOK_COVER)
- pansu = fn_calc_pansu(499, 174) = **1** → comp_qty(plate) = ⌈100/1⌉ = **100**
- 표지인쇄  = 350.00 × 100 = **35,000**
- 표지코팅  = 500.00 × 100 = **50,000**
- 표지용지  = 36.88  × 100 = **3,688**
- **표지 member 소계 = 88,688** ✓

### 2b. 셋트 자기공식 (PRD_000068·qty=copies=100·PRF_BIND_SUM→JUNGCHEOL)
- JUNGCHEOL: use_dims에 plt_siz_cd 없음 → is_plate=False → comp_qty = copies = 100
- 제본 = 700.00 × 100 = **70,000** ✓

### 2c. 골든 G-CB-068A 도달
```
표지 member 88,688 + 셋트공식 제본 70,000 = 158,688
골든 목표(booklet-cover-branch G-CB-068A·byte) = 158,688
★ 일치: TRUE · 오차 = 0
```

### 2d. 내지 member (PRD_000287·PRF_DGP_INNER=S1+PAPER·page파생)
- 골든 158,688은 **표지+제본만**(내지 별도 가산) — 적재본 line 29·291·명세 §1 표 일관.
- sanity: 내지 용지(MAT072/073 백모) SIZ_000499 단가행 충전 + 내지 흑백양면 POPT_000009 SIZ_000499 단가행 53행 → 내지287도 PRICE≠0 평가 가능(견적0 아님).
- DBLPANSU 코드결함(price_views.py:1707·전 책자 공통)은 내지비 환산에만 영향·표지/제본 무영향(C트랙·BLOCKED 보드 NOTE-DLBPANSU-INNER).

---

## 3. 이중합산 0 증명 (비목 단일 귀속)

| 비목 | 표지 member 288 | 내지 member 287 | 셋트공식 068 | 단일귀속 |
|------|:---:|:---:|:---:|:---:|
| 표지인쇄/코팅/용지 | ● PRF_BOOK_COVER | ✗ | ✗ | ✅ |
| 내지인쇄/용지 | ✗ | ● PRF_DGP_INNER | ✗ | ✅ |
| 제본 | ✗ | ✗ | ● PRF_BIND_SUM→JUNGCHEOL | ✅ |

★ COMP_PAPER 충돌 가드: 표지용지(member288·MAT_000073·USAGE.01·plt499)·내지용지(member287·내지mat·USAGE.07·plt499)는 **다른 frm_cd·다른 mat_cd·다른 evaluate_price 호출(다른 member)** → 같은 비용 두 번 계상 없음. 같은 공식 내 2회 배선 아님(`_combo_key` 충돌 0).

---

## 4. 판정

| 점검 | 결과 |
|------|------|
| 158,688 정확 도달 | ✅ 오차 0 (알고리즘 재현) |
| PRICE≠0 | ✅ 표지 88,688 + 제본 70,000 |
| 표지 member SIZ_000499·pansu=1 → 표지 1매=1판 | ✅ (A4 pansu=2 저청구·499자신=0 부결 라이브 재확인) |
| 이중합산 0 | ✅ 비목 단일귀속 |
| 단가 verbatim (350/500/36.88/700) | ✅ 라이브 실측 byte 일치 |

**S4 = PASS** (단, 158,688 산출에 필요한 PRF_BOOK_COVER 공식·formula_components 3행은 라이브 미적재 = BLOCKED→dbmap/§18. 데이터 정의는 검증 통과·실 평가는 공식 COMMIT 후 가능).
