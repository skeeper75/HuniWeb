# Recompute Log — 라이브 evaluate_price 독립 재계산 내역

> **Phase 3 — hpq-quote-gate-validator** · 2026-06-18 · `huni-price-quote`
> **재계산 방식 = 라이브 엔진 직접 호출.** `raw/webadmin/webadmin/catalog/pricing.py`의 `evaluate_price`를
> 임시 venv(Django 5.2.15 + psycopg3)로 부트스트랩해 라이브 Railway DB(읽기전용 SELECT)에 대해 그대로 호출.
> → **재구현이 아니므로 P1 동치 입증 불요(엔진 자체가 권위).** 모든 값은 라이브 엔진 반환값 verbatim.
> 골든 대조: `02_authority/golden-cases.md`. 허용오차 0.

---

## 0. 환경·바인딩 재실측 (생성측 §0 비준)

| 항목 | 라이브 실측 | 생성측 주장 | 판정 |
|------|------------|------------|:--:|
| PRD_000017→frm | PRF_DGP_A (2026-06-01) | 동일 | ✅ 비준 |
| PRD_000138→frm | PRF_POSTER_BANNER_N (2026-06-01) | 동일 | ✅ 비준 |
| PRD_000146→frm | PRF_CLR_ACRYL (2026-06-15) | 동일 | ✅ 비준 |
| product_prices | 0행 | 0 | ✅ 비준 (C1: 전상품 FORMULA) |
| template_prices | 0행 | 0 | ✅ 비준 (ETP-1) |
| 엔진 호출 가능 | ✅ Django shell evaluate_price 직접 호출 성공 | — | ✅ (메모리 "evaluate_price 미구현" STALE 재확인) |

---

## 1. P1/P2 앵커 — 골든 재현 (허용오차 0)

| 케이스 | target | selections | qty | 엔진 final_price | 골든 | 판정 |
|--------|--------|-----------|:--:|:--:|:--:|:--:|
| 실사 ARTPRINT 1000×1000 | PRD_000118 | siz_width=1000, siz_height=1000 | 1 | **20,000** | 20,000 | ✅ MATCH |
| 실사 off-grid ceiling 600×900 | PRD_000118 | siz_width=600, siz_height=900 | 1 | **20,000** | 20,000 (ceiling) | ✅ MATCH (P3-4 ceiling 발화 입증) |
| 아크릴 30×30 3T | PRD_000146 | siz_width=30, siz_height=30, mat_cd=MAT_000043 | 1 | **3,100** | 3,100 | ✅ MATCH |
| 아크릴 30×30 1.5T | PRD_000146 | siz_width=30, siz_height=30, mat_cd=MAT_000042 | 1 | **2,480** | 2,480 | ✅ MATCH (×0.8 두께축 직교) |

- 단가행 출처(라이브 verbatim): ARTPRINT_PHOTO 1000×1000=20,000 (PRICE_TYPE.01, use_dims=[sw,sh]).
  CLEAR3T 30×30: MAT_000043(3mm)=3,100 / MAT_000042(1.5mm)=2,480, min_qty=1 전건(÷1, P4-3 안전), PRICE_TYPE.02.
- **면적매트릭스(실사·아크릴) 4앵커 전부 라이브=골든 정확 일치.** 면적+두께+off-grid ceiling 동작 입증.

### 케이스2 (실사 600×900) 주의 — 상품 정정
golden-cases는 실사 케이스를 "아트프린트포스터(인화지)"로 명시. 라이브 바인딩 상품은 **PRD_000118**(아트프린트포스터,
COMP_POSTER_ARTPRINT_PHOTO). 파일럿 명목상 현수막(PRD_000138)은 COMP_POSTER_BANNER_NORMAL(최소 900×900=8,000)이라
실사 1000×1000 골든과 무관. **검증은 골든이 가리키는 실제 상품(PRD_000118)으로 수행** — 골든 셀 출처와 일치.

---

## 2. 엽서 인쇄비 앵커(20,000) — ★재현 실패 (갈림 지점 지목)

| 케이스 | target | selections | qty | 엔진 인쇄비 소계 | 골든 | 판정 |
|--------|--------|-----------|:--:|:--:|:--:|:--:|
| 엽서 인쇄 단면 국4절 | PRD_000017 | plt_siz_cd=SIZ_000077, print_opt_cd=POPT_000001, proc_cd=PROC_000004 | 25 | **11,750** (470×25) | 20,000 (800×25) | ❌ MISMATCH |
| 동 qty=200 (원주문수량) | 〃 | 〃 | 200 | 36,000 (180×200) | — | — |

**갈린 지점 (단계 내역으로 역추적):**
1. **단가값 자체 불일치**: 라이브 DIGITAL_S1 SIZ_000077/POPT_000001/min_qty=25 = **470원**. 골든이 인용한
   `디지털인쇄비:D16`(출력매수25행 칼라단면) = **800원**. 라이브 단가표는 골든이 인용한 셀값과 다르게 적재됨.
   - 추가 대조: 골든 `D4`(출력매수1)=4,000 vs 라이브 min_qty1=3,500(S1)/5,000(S2). 골든 `D6`(출력매수3)=2,500 vs
     라이브 min_qty3=2,000(S1)/2,500(S2-SIZ_000077). → 라이브 단가행이 골든 출처(`디지털인쇄비` 시트)와 체계적 불일치.
2. **엔진에 판걸이수→출력매수 변환 부재**: 골든 도메인 규칙 "출력매수=ceil(주문수량/판걸이수)"(공식집:행5)가
   `pricing.py`·`price_views.py` 어디에도 없음(grep 0건). 엔진은 `selections`의 `qty`를 **그대로** min_qty 티어로 사용.
   → 골든은 주문200/판걸이8=출력매수25를 가정하나, 엔진은 qty=200을 직접 티어로 써 다른 행을 룩업.
3. **결론**: 골든 케이스1(엽서 인쇄비 20,000, full 22,119.2)은 **라이브 PRD_000017으로 재현 불가**.
   값 불일치(단가표) + 구조 불일치(임포지션 변환 미구현)의 이중 원인. → **신규 결함 N-1**(confirmed-defects.md).
   - 단, 용지비 단가는 일치: COMP_PAPER mat_cd=MAT_000074(백색모조지220g)=70.64 = 골든 `출력소재:I6`. 인쇄비만 갈림.

---

## 3. 결함 재계산 (이중합산·침묵0 엔진 발화 실측)

> 라이브 엔진으로 결함 selections를 직접 호출. **per-component subtotal로 이중합산을 정량 확인.**

### D-1 오시 줄수 이중합산 (엽서 PRD_000017, proc_sels=[{PROC_000090, {줄수:2}}], qty100)
```
줄수=2 → COMP_PP_CREASE_1L  subtotal 1,200,000 (per 12,000 × 100)
        COMP_PP_CREASE_2L  subtotal 1,200,000 (per 12,000 × 100)   ← 이중
        FINAL 2,400,000
줄수=1 → COMP_PP_CREASE_1L only  subtotal 1,000,000  (단일, baseline)
```
→ **정확히 2배 과대청구.** CREASE_1L이 줄수1/2/3 단가행 전부 보유(각10행) + CREASE_2L/3L 별도 배선(전부 PRF_DGP_A wired).

### D-2 가변텍스트 개수 이중합산 (엽서, proc_sels=[{PROC_000031,{개수:2}}], qty1)
```
개수=2 → VARTEXT_1EA subtotal 20,000 + VARTEXT_2EA subtotal 20,000 → FINAL 40,000 (2배)
```

### D-3 귀돌이 둥근 이중합산 (엽서, proc_sels=[{PROC_000028}], qty100)
```
둥근(028) → CORNER_RIGHT subtotal 200,000 (오염 028행) + CORNER_ROUND subtotal 200,000 → FINAL 400,000 (2배)
직각(027) → CORNER_RIGHT only subtotal 0 (직각행 unit_price=0 전건) → FINAL 0
```
→ CORNER_RIGHT가 PROC_000027(9행·전부 0원) + PROC_000028(9행·CORNER_ROUND와 동일단가 2000/4000…) 오염 보유.
  둥근 선택 시 RIGHT 오염행 + ROUND 동시 included = 정확히 2배.

### D-4 유광코팅 침묵 0원 (엽서, coat_side_cnt=1, qty100)
```
COMP_COAT_MATTE subtotal 75,000 매칭. COMP_COAT_GLOSSY = 단가행 0건 → no-match 자연제외(무료).
```
→ GLOSSY 0행이라 유광 선택을 표현할 수단 자체가 없고, 매칭돼도 0원. **과소청구(회사 손해).**

### D-5 디지털 인쇄비 S1/S2 이중경로 (엽서, qty25)
```
plt_siz_cd=SIZ_000077만(S1)      → 11,750
siz_cd=SIZ_000077만(S2)          → 23,750
plt+siz 동시 SIZ_000077 (둘다)   → 35,500  (= 11,750 + 23,750 이중)
```
→ **엔진 레벨 이중합산 발화 실재.** 단 price_simulate(:1270)는 클라이언트 selections를 그대로 통과(판형별 단일키
  가드 없음). 엽서 옵션에 사이즈 그룹(ref_dim .01/.02) 0건 → 옵션 경로로는 무발화. **위험은 위젯/UI가 두 키를
  직접 보낼 때만 발화 → 호출측 단일키 보장에 의존.** CONFIRM→조건부 결함(엔진 가드 부재 사실).

### EOP-1 인쇄 도수(.06)가 가격을 가르지만 옵션이 못 채움 (엽서)
```
print_opt_cd=POPT_000001(단면) → 인쇄비 11,750
print_opt_cd=POPT_000002(양면) → 인쇄비 27,000   ← print_opt_cd가 가격축
print_opt_cd 미설정             → 매칭 0건 → 0원 (lenient) / ok=False (strict)
```
→ 옵션 OPT_000009(인쇄)는 `.06`(도수)로 풀리는데 _opt_maps(:1171)가 `.06`을 가격차원에 미매핑 →
  print_opt_cd 안 채워짐 → 단/양면 선택이 가격에 도달 못 함. **진짜 결함.**

### EOP-2 코팅(.04 proc) ↔ coat comp(coat_side_cnt) 불일치 (엽서)
```
coat_side_cnt 미설정 (옵션 .04는 proc_cd만 보냄) → COAT_MATTE 매칭 0건 → 0원 (strict ok=False)
coat_side_cnt=1 (정상)                          → COAT_MATTE 30,000
```
→ 옵션이 coat_side_cnt를 안 채워 코팅비 미반영. **진짜 결함.**
  ※생성측은 "ERR_AMBIGUOUS 또는 0원"이라 했으나 실측은 **0원(매칭0건)** 쪽 — coat_side_cnt non-NULL 행이
   NULL-선택과 불일치 탈락이라 동시매칭(AMBIGUOUS) 아닌 no-match. 결함 본질 동일, 메커니즘 정정.

### EPJ-1 린넨 봉제 마감유형 dim_vals 누락 (린넨 PRD_000124, 파일럿 외)
```
LINEN_FINISH 5행 = proc=PROC_000080·dim_vals 전부 NULL·min_qty NULL·unit_price 0/800/1000/2000/2000.
detail {유형:말아박기} 병합해도 행에 '유형' key 없어 와일드카드 → 5행 같은 combo_key 1그룹.
match_component → row=None (tier 충돌·no-match). 마감유형별 단가 선택 불가.
```
→ 결함 비준(마감유형이 가격에 도달 못 함). ※생성측 "ERR_AMBIGUOUS" 메커니즘은 부정확(실제 단일 combo·no-match).

---

## 4. 무결성 위생·축 정합 재실측 (생성측 주장 비준)

| 검사 | 라이브 실측 | 생성측 | 판정 |
|------|------------|--------|:--:|
| 고아 옵션(그룹 없는 options) | 0 | 0 | ✅ |
| 고아 아이템(옵션 없는 items) | 0 | 0 | ✅ |
| 이산축↔구간축 혼동 comp | 0 | 0 | ✅ |
| 사이즈 동의어 중복(del_yn=N) | SIZ_000104/105 1건 | 1건 | ✅ (파일럿 가격사슬 참조 0 — 영향 없음) |
| CPQ option_groups/options/items | 135 / 497 / 477 | 135/497/477 | ✅ |
| 활성 제약 | 8건(.01×7 nonspec + .03×1 junk) | 8건(.01×7 + junk×2) | ⚠️ 구성 정정 (§confirmed-defects N-2) |
| MIRROR3T / COROTTO wired | MIRROR3T=0 / **COROTTO=1**(PRF_COROTTO_ACRYL) | 둘다 0 | ⚠️ COROTTO 정정 (N-3) |
