# 072 PRF 트랙 — codex 독립 2차 교차검증 reconcile

생성: hsp-codex-verifier · 2026-06-26 · codex-cli **gpt-5.5 reasoning=high** `-s read-only` 독립 호출(보정본 3파일 + 엔진 코드 직접 read) + Claude 라이브 SELECT/코드 verbatim 재실측(읽기전용·COMMIT/UPDATE/INSERT 0)
헬퍼: `hqv-codex-cross-verify/scripts/codex-review.sh ... high`
방법: **Claude/게이트 판정 비노출.** 엔진 코드 모델 + 권위 + 설계 claim만 codex에 제공 → codex 독립 처분 → Claude 라이브 코드/DB 확증 → reconcile. codex 주장=가설 → 라이브 확증 전 사실 아님(환각 가드). 각 주장 사실/기각 분류.

> ★**codex 종합 = PRF-track NO-GO.** Claude 라이브 확증 = **NO-GO 수렴.** 불일치 0.
> ★**codex availability = AVAILABLE**(gpt-5.5·preflight 통과·미가용 폴백 불요). 단 codex 샌드박스서 Railway DB DNS 미해석(읽기 불가) → codex는 설계 실측기록+SQL+엔진코드로 대조. **DB 확증은 Claude가 전담 수행**(아래).
> ★**핵심 신규 적발**: codex가 **PRF_HC_INNER에 S1·S2 동시 배선 = 내지인쇄 이중합산(돈 크리티컬)**을 독립 적발 — 설계 §3.1의 "comp 접미사 자연 택일" 주장을 엔진 코드로 **반증**. Claude 라이브 단가행으로 **확증(사실)**.

---

## 0. 한눈 요약 (설계 4 claim + codex 신규 × Claude 확증)

| 항목 | codex 처분 | Claude 라이브/코드 확증 | reconcile |
|---|---|---|---|
| **Claim 1 DBLPANSU = 코드 트랙** | **CONFIRMED** | pricing.py:42/82(_row_matches=NON_QTY_DIMS 하드코딩)·561/574(use_dims plt_siz_cd→plate_qty)·697/702(의도 주석) | **합의·사실** — DBLPANSU=뷰↔엔진 계약 결함·데이터 트랙 아님 |
| **Claim 2 골든 968,432.5** | **PARTIAL** (산술 일치·반올림 caveat) | **확증** — Claude 독립 재계산 968,432.5=일치·함정 695,395.94=일치 | **합의·사실 + codex 보강**(final_price=원단위 반올림 968,433) |
| **Claim 3 3 PRF + S2 + S1/S2 배선** | **PARTIAL·Critical Refutation** | **★확증** — S1·S2 동일 NON_QTY_DIM 행 실재 → 양면주문 시 둘 다 매칭·합산=이중청구 | **★codex 신규·사실** — S1/S2 자연택일 주장 반증·NO-GO 핵심 |
| **Claim 4 잔여 NO-GO(SPREAD-SIZ·A4PLT)** | **CONFIRMED** | pricing.py:562(siz_cd→pansu)·cover 조사문서 13판 vs 50판 | **합의·사실** — blocking 정당 |
| codex 신규: dryrun이 골든 미실행 | 신규 | dryrun:87 단가행 존재만 smoke·evaluate_set_price 미호출 | **합의** — S1/S2·DBLPANSU 미적발 |
| codex 신규: P0 NOTICE(hard-fail 아님) | 신규 | dryrun:8~13 RAISE NOTICE(EXCEPTION 아님) | **합의** — 게이트면 EXCEPTION |
| codex 신규: fc "8"≠7 불일치 | 신규 | design §0 "8" vs apply.sql 7행 | **합의**(문서 정합·돈영향 0) |

**불일치(Claude↔codex 상이) = 0.** codex가 DB 직접 읽기 불가분(S1/S2 행 동일성)을 **Claude가 라이브로 확증**(상보).

---

## 1. ★codex 신규 적발 (Critical·돈 크리티컬) — 본 패스 핵심

### 1.1 [Critical·사실] PRF_HC_INNER S1·S2 동시 배선 = 내지인쇄 이중합산

- **codex 주장(가설)**: 설계 §3.1은 "S1·S2 둘 다 배선 가능·단면주문=S1 매칭/S2 no-match·양면주문=S2 매칭/S1 no-match·`_match_entry`가 comp 접미사로 자연 택일"이라 주장. **그러나 엔진엔 comp 접미사(S1/S2)로 배타 선택하는 로직이 없다.** `_evaluate_formula`(pricing.py:551/566/593)는 formula_components를 **전부 순회·각각 매칭·합산**. `_match_entry`(491)도 row의 print_opt_cd/plt_siz_cd/proc_cd 값 비교뿐·side 구분 없음. 설계가 S1·S2 둘 다 POPT_000002(칼라) 행을 전제(design:65~66)하므로 **양면칼라 주문 시 S1·S2 둘 다 매칭 → 내지인쇄 이중청구**. → NO-GO.

- **Claude 라이브 코드+DB 확증 = 사실(환각 아님)**:
  - 코드: `_evaluate_formula` line 566 `for c in comps:` 전 comp 순회·line 592/595 `total += entry["subtotal"]` 무조건 합산. comp 간 배타 선택 부재 확증. `print_opt_cd`(POPT_000001/002)=**색상축(흑백/칼라)**·**면(단면/양면)축 아님**. 면 구분은 오직 comp_cd(S1 vs S2)인데 엔진은 comp를 골라내지 않음.
  - ★**라이브 단가행 결정적 확증**: 양면칼라 주문(proc_cd=PROC_000004·plt=SIZ_000499·print_opt_cd=POPT_000002)에 대해
    - `COMP_PRINT_DIGITAL_S1` 행 실재: (PROC_000004·SIZ_000499·POPT_000002·min1=4000·min2=2800…)
    - `COMP_PRINT_DIGITAL_S2` 행 실재: (PROC_000004·SIZ_000499·POPT_000002·min1=6000·min2=4600…)
    - **두 행의 NON_QTY_DIMS(proc/plt/print_opt) 완전 동일** → `_row_matches`가 S1·S2 양쪽 다 통과 → **S1(4000) + S2(6000) 둘 다 합산**.
  - ∴ 양면칼라 골든서 내지인쇄가 S2(326×1250=407,500)만이 아니라 **S1(165×1250 등)까지 가산** → 내지인쇄 **이중청구**. 설계 §3.1 "자연 택일"은 **반증(거짓)**.

- **돈영향**: 🔴 내지인쇄 이중청구(양면 주문 시 S1+S2 합산). 단면 주문 시도 S1+S2 둘 다 POPT_000002 행 매칭 시 동일 문제.
- **라우팅**: PRF_HC_INNER를 **도수/면 단일 매칭**으로 재설계 필수. 후보:
  - (i) **PRF를 면별로 분리**(PRF_HC_INNER_S1 단면 / PRF_HC_INNER_S2 양면) + 뷰가 print_side로 PRF 선택.
  - (ii) `only_comps`(evaluate_price only 인자)로 선택 comp만 평가.
  - (iii) S1/S2를 print_side 차원으로 구분하는 단가행 모델 보정(dim_vals에 side).
  - **현 단일 PRF에 S1·S2 동시 배선은 그대로 적용 불가(NO-GO).**

---

## 2. 합의분 (Claude↔codex 독립 수렴·고신뢰)

### 2.1 [사실·합의] Claim 1 — DBLPANSU = CODE 트랙(데이터 아님)
- codex CONFIRMED: `_row_matches`(pricing.py:82)는 comp use_dims가 아니라 **하드코딩 NON_QTY_DIMS**(line 42·plt_siz_cd 포함) 순회 → use_dims에서 plt_siz_cd 빼도 **단가 매칭은 여전히 plt_siz_cd 검사**. plate_qty 트리거(561/574)만 use_dims 의존. → 데이터-only(b)는 inner 전용 comp + 단가행 복제(over-mint)로만 가능·열위. **canonical = 뷰 계약 변경(price_views.py:1707 → copies×pages)**.
- **Claude 코드 확증**: line 42 NON_QTY_DIMS 튜플(plt_siz_cd 포함)·line 85 `for d in NON_QTY_DIMS` 확증. derive_inner_sheets 호출처 = price_views.py:1707 1곳(codex rg + Claude grep 일치) → 변경 범위 작음. 의도 주석(697/702)="호출자가 총내지매수 넘긴다"는 **코드(plate_qty 재적용)와 충돌** → 주석도 함께 교정 필요.
- **reconcile**: DBLPANSU **데이터로 정석 해소 불가·코드 트랙(§6 webadmin price_views.py·인간 승인) 라우팅이 정답**. 설계 결론 정당.

### 2.2 [사실·합의+보강] Claim 2 — 골든 968,432.5 산술 정확
- codex PARTIAL: 산술 일치(codex 독립 재계산 동일)·tier 규칙 일치(match_component min_qty≤qty 최대·pricing.py:160)·plate_qty(5000,4)=1250·(1250,4)=313 일치.
- **Claude 독립 재계산 확증**: cover 64,832.5 + inner 453,600(407,500+46,100) + bind 450,000 = **968,432.5**(정답)·함정 695,395.94(내지 180,563.44) — **완전 일치**. 라이브 단가 verbatim 확증: S2@1200=326·S2@300=540·paper M73=36.88·cover S1@50=550·coat@50=700·art150=46.65·bind@50=9000.
- **★codex 보강(수용)**: `final_price`는 `round_won`(원단위 반올림·pricing.py:67/816) → API 최종값은 968,432.5가 아니라 **968,433**. 968,432.5는 base_total(반올림 전 Decimal) 기준. → 골든 표기를 "base_total 968,432.5 / final_price 968,433"으로 명확화 권고(돈영향 0·표기 정밀).
- **단, codex 정확 지적**: Claim 2 골든은 **"S2-only 의도" 기준**으로만 정확 — Claim 3(S1/S2 이중배선) 미해소 시 실제 엔진은 골든을 **재현 못 함**(S1 가산). → 골든은 **S1/S2 배타 해소가 전제**.

### 2.3 [사실·합의] Claim 4 — 잔여 NO-GO 정당
- CFM-COVER-SPREAD-SIZ: 표지 comp는 plt_siz_cd 판수환산 대상·표지엔 완제 A5(4-up·13판) 아닌 펼침siz(1-up·50판) 필요. pricing.py:562 siz_cd→pansu 확증·cover 조사문서 13판 vs 50판. **blocking 정당**.
- CFM-COVER-A4PLT: A4 3절 아트150 89.54 원천 가격표 존재하나 live COMP_PAPER 단가행 부재 + 3절 impos_yn=N → A4 표지 미산출. **blocking 정당**.
- **reconcile**: 둘 다 정당 blocking·바인딩 보류(§D 주석처리) 정합.

### 2.4 [사실·합의] 3 PRF 구조·S2 부활·BODY 가드 (S1/S2 배선 제외)
- over-mint 작음: prf-apply.sql 신규 price_components/component_prices 0·PRF 3 + fc 7 추가만(codex 확인·Claude apply.sql 확증).
- BODY=제본only = 이중평가 가드 타당(prf-apply.sql:54~57 COMP_BIND_SSABARI만).
- S2 부활 부작용 0: codex는 dryrun assert로 일관 확인(DB 직접 미확인). **Claude 라이브 확증**: `t_prc_formula_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2'`=**0행**·S2 del_yn=Y → 부활 안전 사실. COMP_BIND_SSABARI use_dims=[proc_cd,min_qty,proc_grp]=plt_siz_cd 없음(제본 판수환산 안 함·qty=copies) 확증.

---

## 3. codex 신규 (minor·정합·돈영향 0)

| # | codex 신규 | Claude 확증 | 라우팅 |
|---|---|---|---|
| 2 | dryrun이 evaluate_set_price 미호출(단가행 존재만 smoke) | 사실(dryrun:87 단가행 SELECT만) — **그래서 S1/S2 이중합산·DBLPANSU를 dryrun이 못 잡음** | 게이트(S 게이트)에서 evaluate_set_price 실호출 골든 재현 필수 |
| 3 | P0(PRD_000284 선행) NOTICE·hard-fail 아님 | 사실(dryrun:9~13 RAISE NOTICE) | GO 게이트면 EXCEPTION으로 격상 |
| 4 | design §0 fc "8" ≠ apply.sql 7행 | 사실(design §0 "formula_components 8" vs §7.2/SQL 7) | 문서 정합(7로 통일·돈영향 0) |

---

## 4. 불일치 (Claude↔codex 상이) — 없음
- 실질 불일치 0. codex DB 직접 미확인분(S1/S2 행 동일성·S2 참조 0·골든 단가)을 **Claude 라이브로 전부 확증**(상보). codex NO-GO와 Claude 확증 방향 완전 일치.

---

## 5. ★종합 판정 (codex 독립 + Claude reconcile)

- **codex = PRF-track NO-GO.** **Claude 라이브 확증 = NO-GO 수렴. 불일치 0.**
- **NO-GO 핵심(돈 크리티컬·신규)**: ★**PRF_HC_INNER S1·S2 동시 배선 = 내지인쇄 이중합산**(codex 적발·Claude 라이브 단가행 확증). 설계 §3.1 "자연 택일" 반증. **현 prf-apply.sql §C(INNER S1+S2 둘 다 배선) 그대로 적용 불가.**
- **합의 잔여 NO-GO/선결**:
  1. 🔴 **S1/S2 배타 매칭 모델 재설계**(PRF 면별 분리 or only_comps or side 차원) — 본 패스 신규·최우선.
  2. 🔴 **DBLPANSU 코드 교정**(price_views.py:1707 copies×pages + 의도 주석·§6 webadmin·인간 승인) — 데이터 트랙 불가 확정.
  3. 🔴 **CFM-COVER-SPREAD-SIZ**(표지 펼침 siz 신설) — 미해소 시 표지 ~3.8배 과소.
  4. 🔴 **CFM-COVER-A4PLT**(A4 3절 절가/판형) BLOCKED.
  5. 바인딩(§D)은 1~4 전부 해소 후에만 해제(현 주석처리 정당).
- **GO 방향(확증)**: DBLPANSU 라우팅(코드 트랙) 정확·골든 산술 정확(S2-only 의도 기준·final 968,433)·S2 부활 안전(참조 0)·BODY=제본only 가드 타당·over-mint 작음·잔여 blocking 정당.
- **게이트(S 게이트)**: dryrun이 evaluate_set_price를 **실호출**해 골든 재현(S1/S2 이중합산·DBLPANSU를 실값으로 적발)하도록 강화 필수(codex 신규 #2). P0 hard-fail 격상.
- **set-designer 보정 라우팅**: PRF_HC_INNER S1/S2 배타 매칭 재설계 + dryrun 골든 실호출 + 문서 fc 7 정합.

> ★본 산출 = 검증/reconcile까지. 실 COMMIT/UPDATE/INSERT·바인딩 해제·webadmin 코드 교정은 인간 승인 후 dbmap/§6/hsp-load-executor 위임. **codex 주장 전건 라이브 코드/DB 확증 거쳐 사실 분류**(환각 가드·기각 0건). codex DB 미해석분은 Claude가 라이브로 전담 확증(상보·codex 단독 미확증 주장 채택 0).

---

## 6. 출처 (날조 0)
- codex: gpt-5.5 reasoning=high `-s read-only` 새 session · 입력=Claude/게이트 판정 비노출·설계 3파일+엔진 코드 codex 직접 read 후 라인 인용. ★codex 샌드박스 Railway DB DNS 미해석 → DB 값은 설계 실측기록/SQL/코드로 대조(codex 자인)·**DB 확증은 Claude 전담**.
- Claude 라이브 코드 확증(읽기전용): pricing.py:42(NON_QTY_DIMS plt_siz_cd 포함)·82~94(_row_matches NON_QTY_DIMS 순회)·160(match_component tier max)·181~196(component_subtotal unit×qty)·199~213(plate_qty ceil)·551/566/592~595(_evaluate_formula 전 comp 순회·합산·배타선택 부재)·561/574~581(use_dims plt_siz_cd→plate_qty)·562~564(siz_cd→pansu)·67/816(round_won final_price)·697/702(derive_inner_sheets 의도 주석). price_views.py:1706~1709(derived eff_qty+plt_siz_cd 주입).
- Claude 라이브 DB 확증(2026-06-26 읽기전용 SELECT): ★**S1·S2 양면칼라(PROC_000004·SIZ_000499·POPT_000002) 행 둘 다 실재·NON_QTY_DIM 동일**(S1 min1=4000·S2 min1=6000)=이중매칭 사실·S1/S2 둘 다 POPT_000001/002 보유. S2 참조 formula_components 0행·S2 del_yn=Y·PRF_HC% 0행. 골든 단가 verbatim: S2@1200=326·@300=540·paper M73=36.88·cover S1@50=550·coat@50=700·art150 M78=46.65·bind PROC_000023@50=9000·COMP_BIND_SSABARI use_dims=[proc_cd,min_qty,proc_grp](plt_siz_cd 없음).
- Claude 독립 골든 재계산: 정답 968,432.5(base_total)/968,433(final round_won)·함정 695,395.94 — 설계·codex와 3자 일치.
- 설계: prf-track-design.md(§2 DBLPANSU·§3 3PRF·§5 골든·§6 핸드오프)·prf-apply.sql(§A S2부활·§B/§C PRF/fc·§D 바인딩 주석)·prf-dryrun.sql. 입력: inner-promotion-design.md(vessel GO)·codex-reconcile.md(vessel rev2 GO). 엔진: pricing.py·price_views.py.
