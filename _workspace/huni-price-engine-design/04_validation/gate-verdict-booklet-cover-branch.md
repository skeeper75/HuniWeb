# gate-verdict-booklet-cover-branch.md — 책자 표지 펼침/개별 분기 가격공식 E1~E7 독립 검증

> **검증가(hpe-validator) — §18 hpe-design-validation 방법론.** engine-designer 설계
> `03_design/booklet-cover-branch-design.md`를 라이브 t_prc_*·권위 엑셀(260527)로 **독립 재실측**.
> 생성자 주장 비신뢰·단가=권위 verbatim 직접 파싱(designer dict 미사용)·라이브 읽기전용 SELECT만·DB 미적재.
> 실측일 2026-06-30 · PostgreSQL 18.4 railway DB.

---

## 종합 평결: **조건부 GO (CONDITIONAL)** — 분기 모델·단가·결함진단 타당, E4 처리가능성·E6 077/082 골든 전제 보정 필요

| 게이트 | 판정 | 핵심 근거 |
|--------|:----:|-----------|
| **E1** 공식 추출 충실성 | **PASS** | 공식 바인딩·page_rule·단가 전건 라이브/권위 verbatim 일치(날조 0) |
| **E2** 구성요소 분해 정합 | **PASS** | 068~071 부모공식=제본비 comp 1개만 실측 확정·시트경계 내·이중인코딩 0 |
| **E3** 경쟁사 흡수 타당성 | **PASS(N/A)** | 후니 권위 내부 분기·경쟁사 naming 유입 0 |
| **E4** 엔진 설계 건전성 | **CONDITIONAL** | cover_mult ×2 현행 evaluate_price 미지원(C트랙 정직 분류·OK)·단 cover_sheets의 tier 조회 영향 간과·표지 부모공식 직배선 단일 qty 충돌 |
| **E5** 세트 조합 정합 | **PASS** | 이중합산 0(비목 단일귀속)·COMP_PAPER frm_cd 분리 충돌 없음 실측 |
| **E6** 골든 재현 | **PARTIAL** | 068A(158,688)·068B(+85,000)·071 주값(164,665) verbatim 일치 / 077·082 골든 전제 라이브 불일치(공식 0행) |
| **E7** 생성-검증 독립성 | **PASS** | designer가 cover_mult 미구현·C트랙·컨펌큐 정직 표기·self-approve 위장 없음 |

**단일 FAIL 없음 → NO-GO 아님.** E4·E6 보정 요구. 설계 방향 건전하나 077/082 골든 전제 정정·cover_mult tier/qty 영향 명시 후 GO.

---

## E1 — 공식 추출 충실성 [PASS]

### 공식 바인딩 실측 (designer 주장 대조)
`SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN (...);`

| 상품 | 라이브 frm_cd | designer | 판정 |
|------|--------------|----------|:----:|
| 068 | PRF_BIND_SUM | 동 | ✅ |
| 069 | PRF_BIND_MUSEON + _MUSEON_FOIL | 동 | ✅ 박 _FOIL 실재 |
| 070 | PRF_BIND_PUR + _PUR_FOIL | 동 | ✅ |
| 071 | PRF_BIND_TWINRING | 동 | ✅ |
| 072 | PRF_HC_MUSEON_SET | 동 | ✅ |
| 077 | **공식 0행(미바인딩)** | 미바인딩 | ✅ |
| 082 | **공식 0행(미바인딩)** | 미바인딩 | ✅ |
| 094 | PRF_PCB_FIXED | 동 | ✅ |
| 100 | PRF_PHOTOBOOK_FIXED / 101=_INNER | 동 | ✅ |
| 284 | PRF_DGP_INNER | 동 | ✅ |

### page_rule 실측 (byte 대조)
068=4/28/4 · 069=24/300/2 · 070=24/300/2 · **071=8/100/2** · 072=24/300/2 · **077=24/300/2** · **082=8/100/2** · 094=20/30/10 · 100=24/150/2 → designer 전건 일치.

### 단가 verbatim 대조 (권위 엑셀 260527 ↔ 라이브 t_prc_component_prices)
| 항목 | 권위 엑셀 셀 | 라이브 | designer | 판정 |
|------|-------------|--------|---------|:----:|
| 중철제본 1/100/1000 | 제본!B3/B9/B10=3000/700/500 | JUNGCHEOL PROC_000018=3000/700/500 | 동 | ✅ |
| 트윈링제본 50 | 제본!D7=1500 | TWINRING PROC_000021 m=50=1500 | 1500 | ✅ |
| S1 단면 100매 | 디지털 칼라단면 100=350 | SIZ_000499 POPT_000001 m=100=350 | 350 | ✅ |
| S1 양면 100매 | 칼라양면 100=700 | POPT_000002 m=100=700 | 700 | ✅ |
| MATTE 단면 100매 | 코팅!B13=500 | COAT side1 m=100=500 | 500 | ✅ |
| MATTE 양면 100매 | 코팅!C13=1000 | side2 m=100=1000 | 1000 | ✅ |
| 백모120 국4절 | (출력소재) | COMP_PAPER MAT_000073 SIZ_000499=36.88 | 36.88 | ✅ |
| 아트150 | (출력소재) | MAT_000078=46.65 | 46.65 | ✅ |
| COVERBIND(072) 1/100 | 제본 하드커버무선 | COMP_HC_MUSEON_COVERBIND m=1=34100/m=100=7969 | 34100/7969 | ✅ |

★ designer 단가 전건 byte 일치. **날조·v03 인용 0.**

### ★designer 정정 권고 (도수 라벨 명시)
라이브 print_opt_cd 실측: **POPT_000001=칼라단면·POPT_000002=칼라양면·POPT_000008=흑백단면·POPT_000009=흑백양면**. designer 골든은 POPT_000001을 "단면=350"으로만 표기=실제 **칼라(CMYK)**. 단가값은 일치하나 흑백/칼라 도수 라벨 명시 필요(흑백 주문 POPT_000008=200 시 저청구 오인 방지).

---

## E2 — 구성요소 분해 정합 [PASS]

### 068~071 부모공식 구성요소 실측 (제본비만=저청구 확정)
- PRF_BIND_SUM(068)=**COMP_BIND_JUNGCHEOL 1개만**·PRF_BIND_MUSEON(069)=COMP_BIND_MUSEON 1개·PRF_BIND_PUR(070)=COMP_BIND_PUR 1개·PRF_BIND_TWINRING(071)=COMP_BIND_TWINRING 1개
- PRF_DGP_INNER(284)=COMP_PRINT_DIGITAL_S1+COMP_PAPER · PRF_HC_MUSEON_SET(072)=COMP_HC_MUSEON_COVERBIND 1개

→ designer "068~071=제본비만·표지/내지/용지 누락=저청구" 실측 확정. 표지 3 comp 별배선=미존재=설계 제안(1순위 결함·정확 인식).

### 차원경계·이중인코딩
COMP_PAPER use_dims=`[plt_siz_cd,mat_cd]`·S1=`[proc_cd,plt_siz_cd,print_opt_cd,min_qty,...]`·COAT=`[proc_cd,plt_siz_cd,coat_side_cnt,min_qty,...]` 실측 → designer 차원 표기 정합. 펼침/개별이 도수축(print_opt)과 독립 주장 정합(다른 use_dims).

---

## E3 — 경쟁사 흡수 타당성 [PASS(N/A)]
후니 내부 책등유무 분기·후니 frm_cd/comp_cd만 사용. `book2025`·`seneca`·`오시(별단가)` naming 유입 0(designer 가드 명시). 권위 덮어쓰기 0.

---

## E4 — 엔진 설계 건전성 [CONDITIONAL] ★보정 요구

### cover_mult 처리가능성 — evaluate_price 계약 실측
- `grep cover_mult|cover_sheets raw/webadmin/` = **0건**=코드 미존재. designer §1.3/§8/§330/§333에서 "앱 런타임 변수·C트랙(price_views.py)"로 정직 분류 → **E7 OK·위장 없음**.
- evaluate_price(pricing.py:394)=단일 qty 받아 component_subtotal(:193)이 모든 comp에 `up*q`. per-comp 다른 qty는 **plt_siz_cd 차원 comp만 plate_qty(⌈qty/pansu⌉)**(:674-692) 분기.

### ★보정사항 (designer 간과)
1. **cover_mult ×2 현행 엔진 미지원** — plate_qty는 ÷pansu(나눗셈)·×2 곱셈 메커니즘 없음. 표지를 부모공식 직배선 시 S1은 자동 plate_qty 환산되어 cover_sheets=⌈copies/pansu⌉가 되지 cover_mult×copies가 안 됨. → "후보① 앱계산"은 evaluate_set_price **호출자가 member.qty=cover_sheets 주입**(:851 "호출자 산출 유효수량")로만 가능. **표지를 가격0 member가 아니라 cover_sheets qty member로 재설계가 엔진 정합** — designer는 표지를 부모공식에 둠(§4.1)→단일 qty 충돌.
2. **cover_sheets가 tier(min_qty) 조회에도 영향** — designer 골든 비교 간과(E6 071). cover_sheets=100 vs 50이면 단가 tier 자체 350 vs 550. "매수만 곱"이 아니라 "tier도 cover_sheets로 조회"임을 명시 필요.

### proc_cd 다중매칭 가드 (PASS)
COMP_BIND_TWINRING 실측=**4 proc_cd(018/019/020/021)×8 tier=32행**(use_dims에 proc_cd). designer §5 "071 미주입 시 silent 다중매칭" **위험 실재 확정**. AD-CB3(PROC_000021 고정주입)·082(PROC_000024) 타당.

---

## E5 — 세트 조합 정합 [PASS]

### 셋트 구성원 실측 (del_yn=N)
- **072**: 표지073+**내지284**+면지074/075/076(5)=정답 템플릿 ✅
- **077**: 표지078+면지079/080/081(4)=**내지 0행**(누락 확정)
- **082**: 표지083+면지084~087(5)=**내지 0행**(누락 확정)
- **068~071**: **셋트 구성원 0행**(t_prd_product_sets 미등록)
- 094: 내지095+표지096(2) ✅ / 100: 내지101+표지6+면지104(7) ✅

### 이중합산 0 (실측 정합)
COMP_PAPER가 표지용지/내지용지 같은 comp지만 **frm_cd 분리(PRF_BIND_*_SET vs PRF_DGP_INNER)** 실측 → 같은 공식 내 2회 배선 아님 → `_combo_key` 충돌 없음. designer §4.2 정합. 제본 1회·할인 1회.

---

## E6 — 골든 재현 [PARTIAL] (허용오차 0·라이브 verbatim 손계산)

| 골든 | designer | 독립 재계산 | 판정 |
|------|---------|------------|:----:|
| **G-CB-068A** 부모소계 | 158,688 | 350×100+500×100+36.88×100+700×100 = **158,688.00** | ✅ |
| **G-CB-068B** Δ | +85,000 | (700+1000−350−500)×100 = **+85,000** | ✅ |
| **G-CB-071** 부모소계 | 164,665 | 350×100+500×100+46.65×100+1500×50 = **164,665.00**(cover_sheets=100 tier) | ✅ 주값 |
| G-CB-071 "×1이면" 비교 | 17,500/25,000 | **실제 ×1=27,500/35,000**(tier 50매=550/700) | ⚠️ 비교주석 부정확(주값 무영향) |
| **G-CB-077** | 796,900(COVERBIND 가정) | **재현 불가** — 077 공식 0행(PRF_HC_MUSEON_SET 미바인딩) | ❌ 전제 불일치 |
| **G-CB-082** | Q-CB-082 열림 | 재현 불가 — 082 공식 0행 | ❌ 전제 불일치 |

### ★E6 보정 (077/082 골든 전제 정정)
designer G-CB-077은 "PRF_HC_MUSEON_SET COVERBIND ×100=796,900"을 부모로 가정했으나 **라이브 077에 그 공식 미바인딩(0행)**. 077/082는 내지뿐 아니라 **표지+제본 전액 미산정(견적 0원 가능)**. designer §3.1은 "내지 누락"만 강조→**부모공식 미바인딩(표지/제본 0)이 더 선행 결함**. 077/082 골든은 "현행=0원(전액 누락) vs 정답=COVERBIND+내지" 양면 표기 정정 권고. 068A/068B/071 주값은 **허용오차 0 PASS**.

---

## E7 — 생성-검증 독립성 [PASS]
- 단가 전건 라이브/권위 직접 파싱(designer dict 미사용)·골든 손계산 독립.
- designer가 cover_mult 미구현·plate_qty 한계·077/082 미바인딩·컨펌큐 6건을 GO 위장 없이 정직 표기. self-approve·dodge 없음.
- 검증가 적발(dodge-hunt): designer 071 "×1이면 17,500"이 tier 의미 무시 → E6 보정 기록(주값 무영향).

---

## 결함 목록 (carry-forward)
| ID | 심각도 | 결함 | 라우팅 |
|----|:------:|------|--------|
| D-CB-1 | High | 068~071 부모공식=제본비만(표지/내지/용지 누락=저청구) | dbmap mint(부모공식 신설)·인간승인 |
| D-CB-2 | **Critical** | 077/082 부모공식 0행=표지/제본/내지 전액 미산정(견적 0원) | dbmap mint(공식 바인딩+내지 member) |
| D-CB-3 | High | cover_mult ×2 현행 엔진 미지원·표지 부모직배선 단일 qty 충돌 | C트랙(price_views.py)·or 표지 member 재설계 |
| D-CB-4 | Med | 071/082 TWINRING comp 4 proc_cd 다중매칭 위험 | proc_cd 고정주입(AD-CB3) |
| D-CB-5 | Med | designer 골든 도수 칼라/흑백 라벨 미명시·071 ×1 비교 부정확 | 설계 골든 정정 |
| D-CB-6 | Low | 082 COVERBIND ×2 여부 미결(Q-CB-082) | 권위 표지단가 1면/2면 대조 |

## 컨펌큐
Q-CB-082/PROC/LEATHER/MYUNJI/DSC — designer 표기 유지(검증가 추가 이의 없음).
★신규 **Q-CB-COVERMULT-ENGINE**: cover_mult를 (a)표지 member.qty 주입 (b)price_views.py C트랙 중 어디로 구현할지 — evaluate_price 단일 qty 제약상 부모공식 직배선 불가.

## 안전
라이브 읽기전용 SELECT만·DB 쓰기 0·각 결함 재현 SQL/셀 명시·단가 권위 verbatim·designer 주장 직접 재실측. 실 적용 인간 승인 후 dbmap/§18/개발팀 위임.
