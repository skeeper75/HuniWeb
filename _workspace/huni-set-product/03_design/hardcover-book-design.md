# 하드커버책자(PRD_000072) 셋트상품 종단 설계 — 처음부터 끝까지

생성: hsp-set-designer · 권위=상품마스터(260610) booklet 시트 절대 · 라이브 읽기전용 실측(2026-06-29) · **DB 미적재**(설계+적재본 CSV/멱등 SQL까지·실 COMMIT은 게이트 GO+인간 승인 후 load-executor).
입력: `01_authority/`(set-authority-spec·set-price-authority·reuse-map) · `raw/webadmin/catalog/pricing.py`(evaluate_set_price·evaluate_price 계약) · 라이브 t_prd_*·t_prc_* 실측.
선례(동형 템플릿): `set-composition-design.md`(엽서북 094 종단·COMMIT됨) · `set-composition-design-ext.md`(6셋트 구조보정·가격 BLOCKED 판정).

> ★이 설계는 ext 설계(구조보정만·가격 BLOCKED)를 **종단 풀 설계로 승격**한다. 라이브 재실측(2026-06-29) 결과 **§18 제본 그릇이 이미 라이브 적재됨**(PRF_BIND_MUSEON·COMP_BIND_HC_MUSEON 단가행 6개·디지털 PRF_DGP_A·COMP_PAPER·COMP_PRINT_DIGITAL_S1) → ext가 "진성 부재 → BLOCKED"라 한 가격은 이제 **대부분 재사용 가능**으로 전환된다.

---

## 0. 결론 요약 (5대 설계 결정)

| # | 결정 | 근거 |
|---|---|---|
| **D1** | **내지 반제품 신설 = PRD_000284**(search-before-mint=미존재 확인) · prd_typ=02 · 디지털인쇄 종이/단·양면/페이지 24~300/+2 | 권위 booklet row38 "내지(필수)·종이 별도설정·페이지 24/300/2"·라이브 내지 member 부재(072→073/074/075/076만) |
| **D2** | **면지 = 권위대로 1 반제품으로 통합 권고**(현 3행→유지 vs 통합 트레이드오프 §3) · 색상=택1 옵션축. 단 **이번 적재본은 라이브 현황(3행) 보존** + GUARD 명시(돈크리티컬 미해소·인간 큐) | 권위=면지 색상 택1 옵션(제본 하위)·라이브=3 별개 sub_prd_cd 평면화. 통합은 손님 선택지(상품뷰어) 손실 위험→인간 확정 필요 |
| **D3** | **반제품 자재 재배선**: 부모(072)에 붙은 **좀비 자재 MAT_000001(면지일반)·MAT_000002(아크릴투명)·MAT_000003(우드거치대)** 제거 → 표지(073)=전용지 MAT_000246, 면지=화이트/블랙/그레이 MAT_000382/383/384, 내지(284)=디지털 종이 set. **공유 마스터 수술→인간 승인 후 dbmap** | 라이브 실측: MAT_000002=아크릴·003=우드거치대는 책자와 무관한 명백 오염. MAT_000246(전용지)만 정상 |
| **D4** | **가격 = 셋트 제본공식(제본비만) + 구성원 evaluate_price**(이중합산 0). 셋트 072→**PRF_BIND_MUSEON 바인딩**(라이브 실재·COMP_BIND_HC_MUSEON 하드커버무선 제본비 단가행 6개 권위 verbatim). 내지(284)→PRF_DGP_A(인쇄+용지+코팅). 표지(073)→PRF_DGP_A 동형(전용지 인쇄+코팅) | set-price-authority §1.1 하드커버무선=내지인쇄+표지인쇄+표지코팅+제본+용지+후가공. 셋트공식=제본비, 인쇄/용지/코팅=구성원 evaluate_price (silent 이중합산 가드) |
| **D5** | **개수규칙**: 표지(073) min1/max1·내지(284) **min24/max300/incr2**(셋트행 UI 미러·★가격 권위는 `t_prd_product_page_rules` 072 행=라이브 실재) · 면지 옵션(NULL=택1). 제작수량 1~1000/+1=부수(copies 인자, 셋트행 아님) | 권위 booklet row38 페이지 24/300/2 · page_rules 072 실재(codex Q1 reconcile) · 엽서북 선례(095 충전·COMMIT)와 동형 |

**핵심 가드(돈크리티컬)**:
- ★이중합산 방지: 셋트공식=제본비만(COMP_BIND_HC_MUSEON). 내지/표지 인쇄·용지·코팅은 구성원 evaluate_price서. 같은 비목 두 곳 금지.
- ★S1/S2 이중합산·prc_typ ×qty = 알려진 코드결함(C트랙·엽서북 094 R-3 동일). 셋트 적재 후 시뮬레이터 골든 검증 필수.
- ★면지 택1 평면합산 금지(GUARD-1): 가격 신설 후 면지 3행이 동시에 members에 들어가면 과대청구. 호출단이 택1 1개만 전달하는 계약을 가격설계가 보증.

---

## 1. 계층 구조 (bottom-up · 부품조립형)

```
PRD_000072 하드커버책자 [셋트 완제품·prd_typ.01]
  ├─ (셋트공식) PRF_BIND_MUSEON → COMP_BIND_HC_MUSEON (하드커버무선 제본비/수량구간)   ← ★제본비만
  │
  ├─ disp_seq 1: PRD_000073 표지(전용지) [반제품.02]
  │     ├─ 자재: MAT_000246 전용지 (or MAT_000172 하드커버전용지+무광코팅)
  │     ├─ 공정: 무광코팅(단면)/유광코팅 — PROC_000015/014
  │     └─ (구성원공식) PRF_DGP_A → 인쇄비(단면)+용지비+코팅비
  │
  ├─ disp_seq 2: PRD_000284 내지 [반제품.02·★신설]                                  ← ★search-before-mint=신규
  │     ├─ 자재: 디지털 내지 종이 set(*별도설정 → 몽블랑/백모조 등)
  │     ├─ 인쇄: 단/양면 (POPT_000001/002)
  │     ├─ 페이지: 24~300/+2 (min_cnt/max_cnt/cnt_incr)
  │     └─ (구성원공식) PRF_DGP_A → 인쇄비+용지비
  │
  └─ disp_seq 3/4/5: PRD_000074/075/076 면지(화이트/블랙/그레이) [반제품.02]        ← ★택1 그룹
        ├─ 자재: MAT_000382/383/384 (화이트/블랙/그레이 면지)
        └─ (구성원공식) 없음(면지=색지·가격 미발생 or 용지비만) — §4.3
```

### 1.1 라이브 실측 vs 권위 갭 (이 설계가 메우는 것)

| 결함(현 라이브) | 권위(booklet) | 이 설계의 처리 |
|---|---|---|
| 내지 member 부재(073/074/075/076만) | 내지=필수·페이지 24~300/+2 | **D1** 내지 PRD_000284 신설·셋트행 추가 |
| 부모 자재 좀비(MAT_000002 아크릴·003 우드거치대) | 표지=전용지·면지=화이트/블랙/그레이 | **D3** 좀비 제거+정자재 재배선(dbmap 위임) |
| 반제품 자재 0개 | 표지=전용지·면지=색지 | **D3** 구성원에 정자재 배선 |
| 가격공식 0(부모·구성원) | 하드커버무선 6비목 합산 | **D4** PRF_BIND_MUSEON 셋트 바인딩+구성원 PRF_DGP_A |
| 면지 3 반제품(권위=택1) | 면지 색상 택1 옵션 | **D2** 통합 권고(인간 큐)·현황 보존+GUARD |
| min/max/incr 빈칸 | 페이지 24~300/+2 | **D5** 내지 member에 충전 |

---

## 2. 셋트 구성원 설계 (t_prd_product_sets)

라이브 실측(`t_prd_product_sets where prd_cd='PRD_000072'`): 4행(표지073 seq1·면지074 seq2·면지075 seq3·면지076 seq4). 전부 sub_prd_qty=1·min/max/incr NULL·del_yn=N. **내지 행 없음**.

### 2.1 목표 구성 (5행 = 기존 4 보정 + 내지 1 신설)

| disp_seq | sub_prd_cd | 역할 | sub_prd_qty | min_cnt | max_cnt | cnt_incr | note | 처리 |
|---|---|---|---|---|---|---|---|---|
| 1 | PRD_000073 | 표지 | 1 | 1 | 1 | NULL | 표지=전용지·1권고정 | UPDATE(disp_seq 유지·min/max 충전) |
| 2 | **PRD_000284** | **내지** | 1 | **24** | **300** | **2** | 내지=별도설정종이·페이지24~300/+2 | **INSERT(신규 member)** |
| 3 | PRD_000074 | 면지(화이트) | 1 | NULL | NULL | NULL | 면지=화이트·택1그룹 | UPDATE(seq 2→3) |
| 4 | PRD_000075 | 면지(블랙) | 1 | NULL | NULL | NULL | 면지=블랙·택1그룹 | UPDATE(seq 3→4) |
| 5 | PRD_000076 | 면지(그레이) | 1 | NULL | NULL | NULL | 면지=그레이·택1그룹 | UPDATE(seq 4→5) |

- 내지를 disp_seq 2로 삽입(표지 다음·면지 앞) → 기존 면지 seq 2/3/4 → 3/4/5 재배치.
- 내지 페이지 24~300/+2 = member-qty 가변(evaluate_set_price `derive_inner_sheets(copies, pages, pansu)` 입력 차원). 엽서북 선례(095 min20/max30/incr10 COMMIT)와 동형.
- 표지 min1/max1 = 1권당 표지 1장(고정). 면지=택1이라 NULL(수량 의미 없음).

### 2.2 택1 그룹 vs always-add 함정 점검 (CONFIRM-2·§21 교훈)

- 면지 3행(074/075/076)=동일 역할 다중 구성원=**택1 그룹**(손님 1색 선택).
- 현 면지 구성원=가격공식·차원 0 → 동시 합산해도 contribution=0 → **현재 합산 오염 0**. 단 §4.3대로 면지에 용지비 붙으면 즉시 과대청구 위험 → GUARD-1(가격설계 계약).

---

## 3. 면지 정규화 트레이드오프 (D2 · 핵심 해석)

권위는 "면지=제본 하위 색상 택1 옵션"(화이트/블랙/그레이). 라이브는 3 별개 반제품(074/075/076)으로 평면화.

| 옵션 | 통합(1 반제품 + 색상 옵션축) | 유지(3 반제품 현황) |
|---|---|---|
| 권위 정합 | ✅ 권위 "면지=택1 옵션"과 1:1 | △ 평면화(권위 의미는 보존하나 구조 다름) |
| 상품뷰어 손님 선택 | 색상 옵션 드롭다운(SEMI_ROLE.03 + clr 옵션) | 3행이 각각 선택지 노출(현 동작) |
| 가격 위험 | members에 1개만·always-add 함정 원천 차단 | 가격 신설 시 3행 평면합산 위험(GUARD-1 필수) |
| 마이그레이션 비용 | 2 반제품 논리삭제 + 옵션축 신설 + 셋트행 재구성 | 0(현행 유지) |
| 손님 선택지 손실 | 없음(옵션값으로 이전) | 없음 |

**권고 = 장기적으로 통합**(권위 정합·가격 안전). **단 이번 적재본은 현황 3행 보존** — 통합은 ① 상품뷰어 옵션축 설계 ② 손님 선택 UX 영향 ③ 가격 신설과 묶여야 하므로 **인간 확정 필요(CONFIRM-FACE)**. 이번 셋트행 보정에서는 disp_seq/note만 정리하고 GUARD-1로 가격 안전을 봉인.

---

## 4. 반제품↔자재 매칭 (D3 · 계층 bottom-up)

### 4.1 부모 좀비 자재 진단 (라이브 실측 2026-06-29)

`t_prd_product_materials where prd_cd='PRD_000072'` = MAT_000001·002·003·246. 정체:

| mat_cd | mat_nm | mat_typ | 판정 |
|---|---|---|---|
| MAT_000001 | 면지(일반) | TYPE.04 | △ 용도성 자재(면지 슬롯)·정자재 아님 |
| **MAT_000002** | **아크릴(투명)** | TYPE.20 | ❌ **좀비**(책자 무관·아크릴상품 자재 오염) |
| **MAT_000003** | **우드거치대** | TYPE.17 | ❌ **좀비**(책자 무관·거치대 자재 오염) |
| MAT_000246 | 전용지 | TYPE.01 | ✅ 표지 정자재 |

077/082도 동형 오염(MAT_000001/002/003 공유) — **부모 자재 좀비 배선은 책자 셋트 공통 결함**.

### 4.2 목표 자재 배선 (구성원별)

| 구성원 | 역할 | 정자재 | search-before-mint |
|---|---|---|---|
| PRD_000073 | 표지 | **MAT_000246 전용지** (or MAT_000172 하드커버전용지+무광코팅) | ✅ 라이브 실재 |
| PRD_000284(신설) | 내지 | 디지털 내지 종이 set(*별도설정) — 몽블랑130/240(MAT_000105/109)·백모조120(MAT_000073) 등 | ✅ 라이브 실재(COMP_PAPER 단가행 보유) |
| PRD_000074 | 면지화이트 | **MAT_000382 화이트면지** | ✅ 라이브 실재 |
| PRD_000075 | 면지블랙 | **MAT_000383 블랙면지** | ✅ 라이브 실재 |
| PRD_000076 | 면지그레이 | **MAT_000384 그레이면지** | ✅ 라이브 실재 |

- **신규 mint 자재 = 0**(전부 라이브 실재). 내지 종이 set은 디지털인쇄(016)가 쓰는 21종 종이(MAT_000073~130 등)에서 권위 "별도설정" 해석으로 선택 — 정확한 종이 목록은 booklet 권위 "내지종이" 컬럼이 `*별도설정`(공란)이므로 **CONFIRM-PAPER**(실무진 내지 종이 목록 확정).

### 4.3 면지 가격(용지비) 처리

면지=색지(화이트/블랙/그레이 면지 MAT_000382~384). 권위 하드커버무선 공식(set-price-authority §1.1)은 **면지인쇄비/면지코팅비 없음**(그건 §1.3 하드커버링=082/088만). 하드커버책자(072) 면지는 **용지비만 or 가격 미발생**(제본비에 internalize 가능성). → 면지 구성원 공식 **부여 안 함**(가격 0 contribution 유지·GUARD-1 안전). 면지 용지비가 권위에 별도 있으면 CONFIRM-PAPER에서 확인.

### 4.4 자재 재배선 = 공유 마스터 수술 (인간 승인 후 dbmap)

좀비 제거(부모 072에서 MAT_000002/003 link 제거)·구성원 정자재 추가는 t_prd_product_materials 변경. 좀비 자재 자체(MAT_000002 아크릴)는 다른 상품이 쓰므로 **마스터 삭제 금지**([base-master-code-no-delete])·**link만 제거**. 이번 적재본에 자재 재배선 SQL은 **분리(dbmap 위임·인간 승인)** — 셋트 행/가격 바인딩과 별개 트랙.

---

## 5. 내지 반제품 신설 (D1 · PRD_000284)

search-before-mint: 라이브 t_prd_products MAX=PRD_000283 → 신설=**PRD_000284**. 내지 member 미존재 확인(072 셋트에 내지 역할 행 없음).

> ★페이지 권위 = page_rules (codex Q1 교차검증 반영): `t_prd_product_page_rules`에 **072 페이지룰이 이미 라이브 실재**(min24/max300/incr2·2026-06-03). 즉 페이지 가격/생산 권위는 page_rules다. 셋트행 min/max/incr 24/300/2는 **UI 미러·셋트 member 가변 표시**일 뿐 가격 권위 아님(엔진 derive_inner_sheets는 입력 `pages`를 쓰고 page_rules가 검증). 엽서북 선례(095 충전·COMMIT)와 정합 위해 셋트행에도 넣되, **가격 권위는 page_rules**임을 명시. 이중 권위 충돌 시 page_rules 우선.

### 5.1 t_prd_products 행 (신설)

| 컬럼 | 값 | 근거 |
|---|---|---|
| prd_cd | PRD_000284 | MAX+1 채번 |
| prd_nm | 하드커버책자-내지 | 표지(073) 네이밍 동형 |
| prd_typ_cd | **PRD_TYPE.02** | 반제품(셋트 구성원) |
| nonspec_yn | N | 등록 종이/페이지 |
| file_upload_yn | Y | 내지 파일 업로드(권위 출력파일=PDF) |
| editor_yn | N | 디지털인쇄 동형 |
| use_yn | Y · del_yn | N |

### 5.2 내지 가격공식 = PRF_DGP_A (재사용)

내지 = 디지털인쇄 페이지기반 원자합산. **PRF_DGP_A 라이브 실재**(COMP_PRINT_DIGITAL_S1 인쇄비 + COMP_PAPER 용지비 + 코팅/후가공). 내지에 PRF_DGP_A 바인딩 → 종이별 용지비×출력매수 + 단/양면 인쇄비.

- 차원 충전 필요(구성원 단위): 내지 사이즈(작업 150x214→판형 SIZ_000250 or 국4절 SIZ_000499 임포지션)·종이 mat_cd·면 print_opt_cd·수량 min_qty.
- 총내지매수 = 부수 × ⌈페이지/판걸이수⌉ (evaluate_set_price `derive_inner_sheets`). 페이지 24~300이 member-qty(min_cnt~max_cnt).
- **BLOCKED-INNER-DIM**: 신설 내지(284)는 사이즈/공정/판형 차원이 0(신설 직후) → 적재 시 차원 충전 필요(dbmap). 이번 설계는 PRF 바인딩 명세까지·차원행 적재는 dbmap 위임.

---

## 6. 셋트 제본공식 (D4 · evaluate_set_price 정합)

### 6.1 셋트 072 → PRF_BIND_MUSEON 바인딩

라이브 실측: `PRF_BIND_MUSEON`(제본 합산형 무선·use_yn=Y) 존재. 구성요소=**COMP_BIND_MUSEON 1개**(제본비만). 단 책자 069(무선)가 이걸 쓴다 — 하드커버무선은 **COMP_BIND_HC_MUSEON**(하드커버 전용 제본비)이 별도 단가행 보유.

→ **설계 선택**: 셋트 072 제본공식은 **COMP_BIND_HC_MUSEON 단가행**(PROC_000023 하드커버무선제본)을 써야 함. 두 경로:
- (A) 신규 PRF_BIND_HC_MUSEON 공식 신설 → COMP_BIND_HC_MUSEON 배선. (search-before-mint: 라이브 미존재 → 신설 1건·dbmap 위임)
- (B) PRF_BIND_MUSEON 재사용하되 proc_cd 분기로 COMP_BIND_HC_MUSEON 매칭. (현 PRF_BIND_MUSEON은 COMP_BIND_MUSEON만 배선 → HC 제본비 미포함 → 부적합)

→ **권고 = (A) PRF_BIND_HC_MUSEON 신설**(set-price-authority §2 "PRF_HC_MUSEON_SUM" 설계와 정합·단 SUM이 아니라 제본비만이므로 명칭 PRF_BIND_HC_MUSEON). **이는 가격공식 신설** → set-designer 범위 밖 → **BLOCKED-FORMULA**(§18/dbmap 위임). 단 그릇(COMP_BIND_HC_MUSEON 단가행 6개)은 이미 라이브 적재 verbatim.

### 6.2 COMP_BIND_HC_MUSEON 단가행 (라이브 실측 · 권위 verbatim)

| proc_cd | min_qty | unit_price | note |
|---|---|---|---|
| PROC_000023 | 1 | 30,000 | 하드커버무선 수량 1 이상 |
| PROC_000023 | 4 | 20,000 | 수량 4 이상 |
| PROC_000023 | 10 | 14,000 | 수량 10 이상 |
| PROC_000023 | 50 | 9,000 | 수량 50 이상 |
| PROC_000023 | 100 | 7,000 | 수량 100 이상 |
| PROC_000023 | 1000 | 6,000 | 수량 1000 이상 |

→ 단가는 권위 verbatim·날조 0. 셋트공식 신설만 하면 즉시 제본비 견적 가능.

> ★prc_typ 확정 (codex Q4 PASS 합의·라이브 확증 2026-06-29): COMP_BIND_HC_MUSEON `prc_typ_cd = PRICE_TYPE.01`(단가형). 무선책자(069) COMP_BIND_MUSEON도 .01로 동일. 따라서 **제본비 = 권당 단가 × 부수**(수량 50권 → 9,000×50 = 450,000). band-total ×qty 결함(메모리 bandtotal-x-qty-overcharge)과 달리 제본비는 "권당 제본비"가 의미상 맞으므로 .01 정상(false-positive 가드). 단 시뮬레이터 골든으로 ×qty 적용 실측 확인 필수.
> ★HC_MUSEON 활성 확증 (codex Q5 가설 반증·라이브 확증): codex는 "COMP_BIND_HC_MUSEON 논리삭제·활성 동형=COMP_BIND_SSABARI"를 가설했으나, 라이브 실측 `COMP_BIND_HC_MUSEON use_yn=Y`(활성)·SSABARI는 별개(싸바리바인더). codex 가설은 stale 정보 기반 **반증**. PRF_BIND_HC_MUSEON 신설 시 COMP_BIND_HC_MUSEON(활성) 배선이 정답.

### 6.3 evaluate_set_price 적용 (pricing.py:718)

```
evaluate_set_price(072, selections, copies) =
    Σ 구성원 evaluate_price                              ← 내지(284)+표지(073) [면지=0]
      ├─ 내지(284): PRF_DGP_A → 인쇄비(단/양면×총내지매수) + 용지비(종이×출력매수)
      └─ 표지(073): PRF_DGP_A → 인쇄비(단면) + 용지비(전용지) + 코팅비(무광/유광)
  + 셋트공식 evaluate_price(072)                          ← PRF_BIND_HC_MUSEON → 제본비[수량구간]
  + 할인(셋트 기준 1회)
```

→ **이중합산 0**: 제본비는 셋트공식에만, 인쇄/용지/코팅은 구성원에만. 권위 하드커버무선 6비목(내지인쇄·표지인쇄·표지코팅·제본·용지·후가공)이 정확히 분담됨.

---

## 7. 가격 사슬 판정 (가격 구성 가능성)

| 항목 | 현 라이브 | 이 설계 후 | 비고 |
|---|---|---|---|
| 셋트공식(제본비) | 0 | PRF_BIND_HC_MUSEON(신설·단가행 6개 실재) | **BLOCKED-FORMULA**(공식 신설·dbmap) |
| 내지 인쇄/용지 | member 없음 | 내지284+PRF_DGP_A(공식 실재·차원 충전 필요) | **BLOCKED-INNER-DIM**(차원·dbmap) |
| 표지 인쇄/용지/코팅 | 0 | 표지073+PRF_DGP_A | 차원 충전 필요(dbmap) |
| 면지 | 0 | 0(용지비 미발생 or CONFIRM-PAPER) | 안전 |
| **PRICE≠0 가능?** | ❌ 0 | ✅ **가능**(공식 신설+차원 충전 후) | 그릇 전부 라이브 실재(verbatim) |

**판정 = 가격 구성 가능**(엽서북 094와 달리 셋트공식 단독이 아니라 구성원 합산형). 단 ① PRF_BIND_HC_MUSEON 셋트공식 신설 ② 내지/표지 구성원 PRF_DGP_A 바인딩+차원 충전이 **dbmap 적재 트랙**(인간 승인) 필요. set-designer는 셋트 행 보정+공식 바인딩 명세까지.

---

## 8. 골든 케이스 (게이트 evaluate_set_price 재계산용)

> 차원 충전·공식 신설 후 검증할 케이스. 단가 verbatim 기반 손계산.

**케이스 G1**: A5·내지 100p·단면·몽블랑130·표지 전용지 무광코팅·부수 50권
- 제본비 = COMP_BIND_HC_MUSEON[PROC_000023, min_qty 50] = 9,000/권(prc_typ=PRICE_TYPE.01 확정) → **×50권 = 450,000**
- 내지 인쇄비 = COMP_PRINT_DIGITAL_S1[판형, 단면, 수량] × 총내지매수(derive_inner_sheets: 50권×⌈100p/판걸이수⌉)
- 내지 용지비 = COMP_PAPER[몽블랑130] 77.03/절 × 출력매수
- 표지 = 인쇄비 + 전용지 용지비 + 무광코팅비
- **검증 포인트**: prc_typ=.01 라이브 확증됨(codex Q4 PASS). 제본비 ×qty(권당) 적용이 시뮬레이터에서 실제 ×50으로 곱해지는지 골든 실측. 책등 두께(10/18mm)는 페이지수 파생(C트랙 책등 by 페이지).

**케이스 G2(면지 택1 가드)**: 면지 화이트 1색 선택 → members에 074만(075/076 제외). 3행 동시 합산 시 과대청구 = GUARD-1 위반 검출 케이스.

**케이스 G3(이중합산 가드)**: 제본비가 셋트공식+구성원 양쪽에 없는지 — 구성원 PRF_DGP_A에 제본 comp 미포함 확인(라이브 PRF_DGP_A comp 목록=인쇄/용지/코팅/후가공만·제본 없음 ✅).

---

## 9. 적재본 (search-before-mint·복합PK·멱등)

### 9.1 이번 적재본 스코프 (셋트 행 + 내지 신설)

- **t_prd_products**: 내지 PRD_000284 INSERT 1행.
- **t_prd_product_sets**: 내지 member INSERT 1행 + 기존 4행 disp_seq/min_max UPDATE.
- **분리(dbmap 위임·인간 승인)**: 자재 재배선(§4.4)·셋트공식 신설(§6.1)·구성원 PRF_DGP_A 바인딩+차원(§5.2)·면지 통합(§3).

> 이유: 셋트 구조(member·개수규칙)는 set-designer 범위. 가격공식/구성요소/차원/자재 마스터는 §18/dbmap 범위([base-master-code-no-delete]·공유 마스터 수술 인간 승인).

### 9.2 CSV·SQL = `t_prd_product_sets.csv`·`t_prd_products.csv`·`apply.sql`(별 파일 산출)

상세는 동명 파일. apply.sql = INSERT … ON CONFLICT(prd_cd, sub_prd_cd) DO UPDATE(셋트행)·내지 products INSERT ON CONFLICT(prd_cd) DO NOTHING. BEGIN/COMMIT 미내장(load-executor 트랜잭션 래핑).

---

## 10. BLOCKED / 인간 큐 보드

| ID | 트랙 | 사안 | 라우팅 |
|---|---|---|---|
| **BLOCKED-FORMULA** | price | 셋트 072 제본공식 PRF_BIND_HC_MUSEON 신설(라이브 미존재·단가행 COMP_BIND_HC_MUSEON은 실재) | §18/dbmap 공식 신설·인간 승인 |
| **BLOCKED-INNER-DIM** | dimension | 신설 내지(284) 사이즈/공정/판형 차원 0 → PRF_DGP_A 충전 필요 | dbmap 차원 적재·인간 승인 |
| **BLOCKED-COVER-DIM** | dimension | 표지(073) PRF_DGP_A 바인딩+차원 충전 | dbmap·인간 승인 |
| **BLOCKED-MAT-REWIRE** | material | 부모 좀비 자재 제거(MAT_000002 아크릴·003 우드거치대 link)+구성원 정자재 배선(공유 마스터 수술·삭제금지·link만) | dbmap/basecode·인간 승인 |
| **CONFIRM-PAPER** | authority | 내지 종이=`*별도설정`(권위 공란) → 실무진 내지 종이 목록 확정 | 인간(실무진) |
| **CONFIRM-FACE** | structure | 면지 3행→1 반제품+색상옵션 통합 여부(상품뷰어 옵션축·손님 UX·가격 묶음) | 인간 정책 확정 |
| **C트랙(코드결함)** | engine | S1/S2 silent 이중합산·prc_typ band-total ×qty(엽서북 R-3 동형·책등 by 페이지) | 개발팀(webadmin 코드)·설계 외 |
| **HUMAN-CUE(통화§6)** | spec | 제본 세부(방향/링컬러/D링)=하드커버무선엔 비해당이나 권위 "10/18mm" 책등 두께 확인 | 인간 큐 |

---

## 11. search-before-mint 증거 (날조 0)

| 항목 | 라이브 실재(2026-06-29) | 처리 |
|---|---|---|
| 셋트 부모 PRD_000072 | ✅ prd_typ.01(이미 교정됨)·del_yn=N | 참조(유형 교정 불요·이미 01) |
| 표지 PRD_000073 | ✅ PRD_TYPE.02 | 기존 참조·자재 재배선(dbmap) |
| 면지 PRD_000074/075/076 | ✅ PRD_TYPE.02 | 기존 참조·현황 보존 |
| 내지 member | ❌ 부재 | **신설 PRD_000284**(MAX+1·미존재 확인) |
| 전용지 MAT_000246·면지 MAT_000382~384 | ✅ 실재 | 참조(신규 mint 0) |
| 제본 PRF_BIND_MUSEON·COMP_BIND_HC_MUSEON 단가행 6 | ✅ 실재(verbatim) | 셋트공식 신설 시 참조(그릇 재사용) |
| 디지털 PRF_DGP_A·COMP_PAPER·COMP_PRINT_DIGITAL_S1 | ✅ 실재 | 내지/표지 공식 재사용 |
| 셋트공식 PRF_BIND_HC_MUSEON | ❌ 부재 | **BLOCKED-FORMULA**(신설·dbmap·set-designer 범위 밖) |

**신규 mint = 1**(내지 PRD_000284 반제품 행). 가격공식·자재·단가행 신규 mint = 0(전부 기존 참조 or dbmap 위임).

---

## 11.5 codex 독립 2차 교차검증 reconcile (2026-06-29 · gpt-5 high)

생성≠검증. codex가 같은 설계를 독립 검토. codex 주장=가설 → 라이브 확증 후 채택.

| Q | 사안 | codex 판정 | 라이브 reconcile | 최종 |
|---|---|---|---|---|
| Q1 | 내지 페이지 24~300을 셋트행 min/max에 넣는 게 맞나 | CONCERN: 페이지 권위는 page_rules·셋트행은 UI 미러 | ✅ `t_prd_product_page_rules` 072 행 실재(24/300/2) | **반영**: §5 page_rules가 가격 권위·셋트행은 미러 명시 |
| Q2 | 이중합산: 셋트=제본비·구성원=PRF_DGP_A(제본 없음) | PASS | PRF_DGP_A comp=인쇄/용지/코팅/후가공만(제본 없음 확인) | **합의 PASS** |
| Q3 | 면지 택1 3행 동시 members 과대청구 위험 | CONCERN: 현 0원 무해·향후 위험·SEMI_ROLE.03 택1 가드 필요 | 면지 가격공식·차원 0 확인 | **합의**: GUARD-1·CONFIRM-FACE 유지 |
| Q4 | 제본비 9,000 권당(.01) vs 총액(.02) | PASS: 권당 .01·×qty | ✅ COMP_BIND_HC_MUSEON prc_typ=PRICE_TYPE.01 확증 | **합의 PASS**(돈크리티컬 확정) |
| Q5 | 셋트공식 신설 BLOCKED→dbmap 분리가 맞나 | CONCERN: 경계 맞음·단 HC_MUSEON 논리삭제·활성=SSABARI 재확인 | ✅ HC_MUSEON use_yn=Y(활성)·SSABARI=별개 → codex 가설 **반증** | **반영**: §6.2 HC_MUSEON 활성 확증·codex 가설 반증 명시 |

**reconcile 결론**: 합의 2(Q2·Q4 PASS·돈크리티컬 안전 확정)·codex 보강 채택 1(Q1 page_rules 권위)·codex 가설 반증 1(Q5 HC_MUSEON 활성)·잔여 가드 유지 1(Q3 면지 택1). 설계 무결성 GO 방향(최종 GO/NO-GO는 hsp-set-gate S1~S7).

## 12. 스키마 주의 (엽서북·6셋트 선례 계승)

- t_prd_product_sets 컬럼: prd_cd·sub_prd_cd·sub_prd_qty·disp_seq·note·reg_dt·upd_dt·del_yn·del_dt·min_cnt·max_cnt·cnt_incr. **semi_role_cd 부재** → 역할은 note로만.
- PK=복합(prd_cd, sub_prd_cd) → ON CONFLICT 멱등.
- t_prd_products 필수 NOT NULL: prd_cd·prd_nm·prd_typ_cd·nonspec_yn·file_upload_yn·editor_yn·use_yn·reg_dt(default now)·del_yn(default N).
- t_prd_product_price_formulas에 use_yn/del_yn 없음(apply_bgn_ymd만).
