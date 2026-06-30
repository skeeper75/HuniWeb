# regate-verdict-booklet-cover-branch.md — 책자 표지 펼침/개별 분기 가격공식 2차 재게이트 (E1~E7)

> **검증가(hpe-validator) — §18 hpe-design-validation 방법론·2차 재게이트.**
> 대상 = 폐루프 보정 반영본 `03_design/booklet-cover-branch-design.md`(REV 마커).
> 1차 판정 = `gate-verdict-booklet-cover-branch.md`(조건부 GO·E4/E6 보정) · codex reconcile = `05_codex/codex-reconcile-booklet-cover-branch.md`(NO-GO 격상·N-CB-1).
> **codex 결과 비참조로 자기 실측 판정**(독립성) — 단 1차 verdict/codex가 합의한 사실은 carry-forward 재대조.
> 생성자 주장 비신뢰·단가=권위 verbatim **직접 파싱**(designer dict 미사용)·라이브 읽기전용 SELECT만·DB 미적재.
> 실측일 2026-06-30 · PostgreSQL 18.4 railway DB · 본 세션 직접 SELECT.

---

## 종합 평결 (2트랙 분리)

| 트랙 | 판정 | 1차 대비 변화 |
|------|:----:|---------------|
| **① 데이터 설계 트랙** | ✅ **GO** | 1차 "조건부 GO"의 "보정하면 됨" 뉘앙스 제거. 폐루프 정정 7건 전건 라이브 정합 확인 → 명확한 데이터 GO로 승격. |
| **② cover_mult ×2 실행 트랙** | ❌ **NO-GO · BLOCKED** | 1차 E4 CONDITIONAL("C트랙 정직 분류")을 **BLOCKED로 격상**. 엔진 plate_qty=÷pansu뿐·×2 곱셈 경로 0(pricing.py:674-692 재실측)으로 부모공식 직배선 불가 확정. |

★ **종합 라벨**: **데이터 GO / cover_mult ×2 실행 NO-GO(BLOCKED)**. 단일 게이트 FAIL은 데이터 트랙에 없음 — 실행 트랙은 의도적으로 분리 격상(돈크리티컬 안전·codex N-CB-1 합치). 설계가 이 2트랙을 §0.0에 정직하게 분리·BLOCKED 명문화한 것이 본 재게이트의 핵심 합격 사유.

| 게이트 | 1차 | **2차** | 핵심 근거(라이브 재실측) |
|--------|:---:|:------:|--------------------------|
| **E1** 공식 추출 충실성 | PASS | **PASS** | 공식 바인딩·page_rule·단가 전건 라이브 byte 재일치·날조 0·v03 0 |
| **E2** 구성요소 분해 정합 | PASS | **PASS** | 068~071 부모공식=제본비 comp 1개만 재실측·077/082 부모공식 0행 선행 정정 정합 |
| **E3** 경쟁사 흡수 타당성 | PASS(N/A) | **PASS(N/A)** | 후니 내부 분기·naming 유입 0 |
| **E4** 엔진 설계 건전성 | CONDITIONAL | **PASS(데이터)/BLOCKED(cover_mult ×2 실행)** | member.qty 호출자 주입 실재(:907)·plate_qty ÷pansu뿐(:680)·tier 영향 §1.4 명시·proc_cd 가드 명문화 |
| **E5** 세트 조합 정합 | PASS | **PASS** | COMP_PAPER frm_cd 분리 재실측(같은 frm 2회 0)·double-count 가드 명문화·내지 누락 2차 정합 |
| **E6** 골든 재현 | PARTIAL | **PASS(데이터 주값)** | 068A/068B/071 주값 허용오차 0·077/082 양면 표기 정정·071 비교주석 삭제·도수 라벨 |
| **E7** 생성-검증 독립성 | PASS | **PASS** | BLOCKED 정직 격상·컨펌큐 8건·self-approve 위장 없음 |

---

## E1 — 공식 추출 충실성 [PASS] (1차 PASS 유지)

### 공식 바인딩 재실측
```sql
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000068'..'PRD_000284');
```
068=PRF_BIND_SUM · 069=MUSEON(+_FOIL) · 070=PUR(+_FOIL) · 071=TWINRING · 072=PRF_HC_MUSEON_SET · **077=0행** · **082=0행** · 094=PRF_PCB_FIXED · 100=PHOTOBOOK_FIXED · 101=_INNER · 284=PRF_DGP_INNER → designer freshness §0.1 전건 일치.

### 단가 verbatim 재대조 (SIZ_000499 국4절·직접 파싱)
| 항목 | 라이브 m=50 | 라이브 m=100 | 설계 골든값 | 판정 |
|------|:----------:|:-----------:|:----------:|:----:|
| S1 POPT_000001 칼라단면 | 550 | 350 | 350(100)/550(50) | ✅ |
| S1 POPT_000002 칼라양면 | 1100 | 700 | 700(100) | ✅ |
| COAT_MATTE side1 | 700 | 500 | 500(100)/700(50) | ✅ |
| COAT_MATTE side2 | — | 1000 | 1000(100) | ✅ |
| JUNGCHEOL m=100 | — | 700 | 700 | ✅ |
| TWINRING proc021 m=50 | 1500 | — | 1500 | ✅ |
| 백모120/아트150 | 36.88/46.65 | — | 36.88/46.65 | ✅ |
| COVERBIND m=1/100 | 34100/7969 | — | 34100/7969 | ✅ |

★ 단가 전건 라이브 byte 일치(designer dict 미사용 직접 SELECT). 날조·v03 인용 0.
★ **도수 라벨 정정 반영 확인**(설계 §4.3 D-CB-5): POPT_000001=칼라단면/002=칼라양면/008=흑백단면/009=흑백양면 명문화 — 1차 권고사항 해소.

---

## E2 — 구성요소 분해 정합 [PASS] (1차 PASS 유지)

### 부모공식 구성요소 재실측
```sql
SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd IN (...);
```
- PRF_BIND_SUM=COMP_BIND_JUNGCHEOL **1개만** · MUSEON=COMP_BIND_MUSEON 1 · PUR=1 · TWINRING=1
- PRF_DGP_INNER=COMP_PRINT_DIGITAL_S1+COMP_PAPER(2) · PRF_HC_MUSEON_SET=COVERBIND **1개만**

→ 068~071 "제본비만=표지/내지/용지 누락 저청구"·072 통합형(COVERBIND 단일) 재실측 확정.

### ★077/082 부모공식 0행 = 1차 결함 선행 정정 확인 (E2 재게이트 포인트)
```sql
SELECT prd_cd, count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000077','PRD_000082') GROUP BY prd_cd;  -- 빈 결과(0행)
```
설계 §3.1이 "**1차 결함=부모공식 0행(견적 0원)·내지 누락은 2차**"로 순서화. page_rule은 존재(아래 E5)하나 부모공식 미바인딩이 더 선행. 1차 verdict가 요구한 프레이밍 정정 반영. ✅

### use_dims 재실측
COMP_PAPER=`[plt_siz_cd,mat_cd]`·S1=`[proc_cd,plt_siz_cd,print_opt_cd,min_qty,proc_grp]`·COAT_MATTE=`[...,coat_side_cnt,...]`·COVERBIND=`[min_qty]` → 차원 표기 정합·이중인코딩 0.

---

## E3 — 경쟁사 흡수 타당성 [PASS(N/A)] (1차 유지)
후니 내부 책등유무 분기. `book2025`·`seneca`·`오시(별단가)`·`paperno` naming 유입 가드 §386 명시·권위 덮어쓰기 0.

---

## E4 — 엔진 설계 건전성 [PASS(데이터) / BLOCKED(cover_mult ×2 실행)] ★1차 CONDITIONAL→2트랙 격상

### (1) member.qty 호출자 주입 = 후보①' 엔진 정합 해법 — 코드 실측 확정
`pricing.py:851` docstring: `members[].qty = 호출자가 산출한 유효수량(총내지매수/출력매수/부수)`.
`:907` `evaluate_price({"prd_cd": sub_cd}, mb.selections, mqty_i, ..., skip_plate=bool(mb.get("skip_plate")))` — **member별 qty를 호출자가 주입해 그대로 평가 qty로 씀** + `skip_plate`도 member별. → 표지를 별 member로 분리하면 `qty=copies×cover_mult` 주입 가능. 설계 후보①'(§1.1·§0.0 해법a)이 **엔진 계약상 실재**(신규 엔진 코드 0). PASS.

### (2) cover_mult ×2 부모공식 직배선 = BLOCKED 확정 — plate_qty 실측
`pricing.py:680` `comp_qty = plate_qty(qty, pansu)` where `plate_qty = ⌈qty ÷ pansu⌉`(:660 per_book = ceil division). **÷pansu(나눗셈) 환산뿐·×2 곱셈 경로 없음.** 표지 S1은 plt_siz_cd 차원(use_dims 실측)이므로 부모공식 직배선 시 자동 ⌈copies/pansu⌉ 환산 → `cover_mult×copies(=copies×2)`를 표현할 경로 없음. 설계 §0.0/§1.1 후보①(직배선) BLOCKED·후보①'(member 분리) 권고가 엔진 사실 정합. ✅ **BLOCKED 정직 분류 확인**(1차 "C트랙 정직 분류"보다 강하게 BLOCKED 명문·codex N-CB-1 합치).

### (3) cover_sheets tier 조회 영향 명시 — 설계 §1.4 확인
설계 §1.4 표 "copies=50→tier 550 / cover_sheets=100→tier 350"이 라이브 S1 POPT_000001 m=50=550·m=100=350과 byte 일치. tier 변동 메커니즘·수치 라이브 정합·"권위 부수 vs 출력매수 대조 필요" 미결(N-CB-TIER) 정직 표기. 1차 보정사항#2 반영. ✅

### (4) proc_cd 다중매칭 가드 — 재실측
```sql
SELECT DISTINCT proc_cd FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_TWINRING';  -- 018/019/020/021
SELECT count(*) ... ;  -- 32행
```
TWINRING=4 proc_cd×8 tier=**32행** 확정. 미주입 시 silent 다중매칭 위험 실재(JUNGCHEOL=단일 proc_cd 018이라 위험 낮음). AD-CB3(071=PROC_000021·082=PROC_000024 고정주입) 명문화·**데이터 트랙 즉시 적용 가능 선결 가드**로 분류 정합. ✅

★ **E4 판정**: 데이터 산식(copies×cover_mult)·단가·tier 명시·proc_cd 가드 = PASS. cover_mult ×2 부모공식 직배선 실행 = **BLOCKED**(Q-CB-COVERMULT-ENGINE 인간 결정). 표지 member 분리(후보①')가 엔진 정합 해법임을 코드로 입증.

---

## E5 — 세트 조합 정합 [PASS] (1차 PASS 유지·double-count 가드 명문화 확인)

### 셋트 구성원 재실측
```sql
SELECT prd_cd, sub_prd_cd, sub_prd_qty, disp_seq FROM t_prd_product_sets WHERE prd_cd IN (...);
```
- 072=5(표지073+**내지284**+면지074~076) 정답 템플릿 ✅
- 077=4(표지078+면지079~081·**내지 0행**) / 082=5(표지083+면지084~087·**내지 0행**) → 내지 누락 2차 결함 정합
- 068~071=셋트 구성원 0행(미등록) / 094=2 / 100=7

### COMP_PAPER 충돌·double-count 가드 재실측
```sql
SELECT frm_cd, count(*) FROM t_prc_formula_components WHERE comp_cd='COMP_PAPER' GROUP BY frm_cd HAVING count(*)>1;  -- 빈 결과
SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_HC_MUSEON_SET';  -- COMP_HC_MUSEON_COVERBIND 1개만
```
- COMP_PAPER가 **같은 frm_cd에 2회 배선된 공식 0건**·각 frm_cd(PRF_DGP_INNER 등)에 1회씩 → frm_cd 분리로 combo_key 충돌 없음. codex B1 일반론 위험은 라이브 사실에 반박(자동 flip 금지)·설계 §4.2/§9.2 가드 유지 정합. ✅
- PRF_HC_MUSEON_SET=COVERBIND 단일 배선(분해형 표지 comp 미배선) → 설계 §2.2 REV "통합형(072/077/082)에 분해형 표지 comp 추가배선 절대 금지" double-count 가드가 라이브 현실과 정합(현 072=추가배선 0). 설계가 codex B2 우려를 명문 흡수. ✅

★ 이중합산 0(비목 단일귀속 §4.2)·제본 1회·할인 1회. **자동 flip 금지** 유지가 타당(라이브 frm_cd 분리 = 사실).

---

## E6 — 골든 재현 [PASS(데이터 주값)] ★1차 PARTIAL→데이터 주값 PASS

> 라이브 verbatim 손계산(designer dict 미사용)·동치 재구현(component_subtotal: unit_price×qty·min_qty tier 조회).

| 골든 | designer | 2차 독립 재계산 | 판정 |
|------|---------|----------------|:----:|
| **G-CB-068A** 부모소계 | 158,688 | 350×100+500×100+36.88×100+700×100 = **158,688.00** | ✅ 오차 0 |
| **G-CB-068B** Δ(표지양면) | +85,000 | (700+1000−350−500)×100 = **+85,000** | ✅ |
| **G-CB-071** 부모소계 | 164,665 | 350×100+500×100+46.65×100+1500×50 = **164,665.00** | ✅ 주값 오차 0 |
| **071 "×1이면 17,500" 비교주석** | **삭제됨**(설계 §4.3) | tier 무시 오류(실제 ×1=27,500/35,000) 해소 | ✅ 정정 |
| **G-CB-077** | 현행 0원 vs 정답(COVERBIND+내지) **양면 표기** | 077 공식 0행=견적 0원 재실측·정답은 바인딩 후 재현 | ✅ 양면 정정 |
| **G-CB-082** | 현행 0원 vs 정답 + Q-CB-082 ×2 결판 | 082 공식 0행·내지 0행 재실측 | ✅ 양면 정정 |

★ **E6 판정**: 데이터 트랙 주값(068A/068B/071) = 허용오차 0 재현 PASS. 077/082 = "현행 0원 vs 정답" 양면 표기로 정정 반영(1차 보정 요구 해소)·결함 자체(부모공식 0행)는 실재·더 심각으로 선행 순서화. 도수 칼라/흑백 라벨 명시. → 1차 PARTIAL 사유(077/082 골든 전제 불일치) 전건 해소.

---

## E7 — 생성-검증 독립성 [PASS] (1차 PASS 유지)
- 단가 전건 라이브 직접 SELECT 재파싱(designer dict 미사용)·골든 손계산 독립.
- 설계가 cover_mult ×2를 "보정 가능"이 아니라 **BLOCKED로 정직 격상**(§0.0 2트랙)·컨펌큐 8건(Q-CB-COVERMULT-ENGINE·N-CB-TIER 신규 2건 포함)·GO 위장 없음.
- dodge-hunt: 1차가 적발한 "071 ×1 비교주석 tier 무시"를 설계가 삭제·골든 순환참조 없음(라이브 단가→손계산→대조).

---

## 잔여 결함 목록 (carry-forward·1차 D-CB 상태 갱신)

| ID | 심각도 | 결함 | 2차 상태 | 라우팅 |
|----|:------:|------|---------|--------|
| D-CB-1 | High | 068~071 부모공식=제본비만(표지/내지/용지 누락 저청구) | open·068~070 cover_mult=1이라 직배선 정확 | dbmap mint(부모공식 신설)·인간 승인 |
| D-CB-2 | **Critical** | 077/082 부모공식 0행=견적 0원(1차)+내지 누락(2차) | open·선행순 정정 확인 | dbmap mint(공식 바인딩 072 동형 + 내지 member)·인간 승인 |
| D-CB-3 | **Critical** | cover_mult ×2 부모공식 직배선 현행 엔진 미지원 | **BLOCKED 격상** | Q-CB-COVERMULT-ENGINE 인간 결정(후보①' or C트랙) |
| D-CB-4 | Med | 071/082 TWINRING 4 proc_cd 다중매칭 silent 위험 | open·데이터 트랙 즉시 적용 가능 | proc_cd 고정주입(AD-CB3) |
| D-CB-5 | Med | 골든 도수 라벨·071 ×1 비교 부정확 | **CLOSED**(설계 §4.3 라벨 명시·비교주석 삭제) | — |
| D-CB-6 | Low | 082 COVERBIND ×2 여부 미결 | open | Q-CB-082 권위 표지단가 1면/2면 대조 |
| D-CB-7 | Low | 통합형 double-count 가드 | **CLOSED**(설계 §2.2 REV 명문) | — |

## 컨펌큐 (설계 §389 유지·검증가 추가 이의 없음)
- **Q-CB-COVERMULT-ENGINE**(Critical·인간 결정): cover_mult ×2(071/082)를 (a)표지 member.qty=cover_sheets 주입 vs (b)price_views.py C트랙 — 코드 실측상 (a)가 신규 엔진 코드 0·표지 반제품 mint 필요(dbmap)로 우선 권고.
- **N-CB-TIER**(돈크리티컬): 표지 comp 단가 tier 기준 = 주문부수(copies) vs 출력매수(cover_sheets) — 권위 표지단가 verbatim 대조로 확정. 수량↑→단가↓ 구조라 오선택 시 저청구.
- Q-CB-082 / Q-CB-PROC / Q-CB-LEATHER / Q-CB-MYUNJI / Q-CB-DSC / CFM-COVER-SPREAD-SIZ / CFM-INNER-DBLPANSU — 설계 표기 유지.

## 다음 단계 권고
1. **데이터 트랙 GO** → 인간 승인 큐: 068~071 부모공식 표지/내지/용지 배선·077/082 부모공식 바인딩(072 동형)+내지 member mint → dbmap(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer). cover_mult=1(068~070)은 직배선으로 정확하므로 우선 적재 가능.
2. **cover_mult ×2 실행 트랙 BLOCKED** → Q-CB-COVERMULT-ENGINE 인간 결정 후: (a)표지 member 분리=표지 반제품 mint(dbmap) / (b)price_views.py C트랙(개발팀). webadmin 코드 직접수정 금지.
3. **선결 가드**: 071/082 proc_cd 고정주입(AD-CB3)·DBLPANSU 코드교정(C트랙·072/068~071/077/082 동시 해소·CFM-INNER-DBLPANSU)은 데이터 트랙 적재 전 선결.
4. **확정 결함**(D-CB-1/2/4/6) → dbm-price-arbiter 라우팅(돈크리티컬 정립).
5. N-CB-TIER·Q-CB-082는 게이트(권위 표지단가) 대조 후 fix — 적재 전 tier 기준 확정 필수(저청구 가드).

## 안전
라이브 읽기전용 SELECT만·DB 쓰기 0·각 결함 재현 SQL/셀 명시·단가 권위 verbatim 직접 파싱·designer 주장 직접 재실측·비밀값 비노출. 실 적용 인간 승인 후 dbmap/§18/개발팀 위임.
