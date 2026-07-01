# 셋트상품 19개 가격레벨 전수 진단 (§23) — 260702

> 방법: 라이브 `simulate-set` 엔드포인트(`price_views.py:1888 price_simulate_set` → `pricing.evaluate_set_price`) 실호출 · copies=100 기준 · 라이브 읽기전용 SELECT + 시뮬레이터 읽기 호출만 · **DB 쓰기·COMMIT 없음**. 빌더=`_workspace/_foundation/batch/set_full_scan.py`(HuniSim.simulate_set). 판형 정본=`t_prd_product_plate_sizes`(dflt), 공정=`t_prd_product_processes`(제본그룹 PROC_000017는 셋트본체 set_procs).
> 결론 요약: **19개 중 18개 PRICE≠0(GO) · 1개 진짜 결함(088 PRICE=0)**. 094/097/100은 데이터 정상(스캔 빌더의 옵션선택 누락일 뿐, 정확 선택 시 PRICE≠0 실증). 책자 표지 코팅 드롭은 시뮬레이터 뷰 코드결함(C트랙).

---

## 0. 빌더 검증 로그 (책자 셋트 골든 재현)

| 셋트 | 골든(게이트) | 스캔 final(copies=100) | 구성 | 재현 판정 |
|------|:---:|:---:|------|------|
| 068 中철 | 158,688 (표지+제본, 내지 제외) | 표지단품 **88,688** + 제본 70,000 = **158,688** | print 35,000+coat 50,000+paper 3,688 + bind 70,000 | ✅ **정확 재현**(단품경로) |
| 069 무선 | 138,688 | 표지 88,688 + 제본 50,000 = 138,688 | 동상 + bind 50,000 | ✅ (표지 동일·bind만 상이) |
| 070 PUR | 288,688 | 표지 88,688 + 제본 200,000 = 288,688 | 동상 + bind 200,000 | ✅ |
| 077 레더HC | ≈51,146 | COVERBIND+내지 경로 동작(라이브 COMMIT분) | set_eval COVERBIND + 내지 | ✅ 동작(값은 config/qty 의존) |
| 082 하드커버링 | 44,123 | PRF_HC_TWINRING_SET COVERBIND 동작 | 동상 | ✅ 동작 |

★ **표지 288 단품 `simulate` = 88,688 정확**(print 35,000+coat 50,000+paper 3,688, pansu=1, plt=SIZ_000499). fn_calc_pansu(SIZ_000499, SIZ_000174)=1, 단가행 verbatim. **골든 5건 재현 → 빌더 신뢰 확립.**
★ **단, `simulate-set` 경로에서는 표지 코팅이 드롭됨**(아래 §2 C트랙 결함) → 셋트 경로 표지 contrib=38,688(print+paper만). 코팅 행은 라이브에 실재(COMP_COAT_MATTE·plt499·coat_side_cnt=1·PROC_000015).

---

## 1. 19개 셋트 PRICE≠0 전수표 (copies=100·라이브 simulate-set)

| PRD | 상품 | 부모공식 | final_price | set_eval | 구성원 기여 | 판정 |
|-----|------|----------|:---:|:---:|------|------|
| 068 | 中철책자 | PRF_BIND_SUM | **127,126** | 70,000(제본) | 표지288=38,688·내지287=18,438 | ✅ GO (표지코팅 −50k=C트랙) |
| 069 | 무선책자 | PRF_BIND_MUSEON | **131,072** | 50,000 | 표지290=38,688·내지289=42,384 | ✅ GO (동상) |
| 070 | PUR책자 | PRF_BIND_PUR | **281,072** | 200,000 | 표지292=38,688·내지291=42,384 | ✅ GO (동상) |
| 072 | 하드커버책자 | PRF_HC_MUSEON_SET | **968,119** | 796,900(COVERBIND) | 내지284=171,219·면지073~076=0(무가·정상) | ✅ GO |
| 077 | 레더하드커버 | PRF_HC_MUSEON_SET | **815,338** | 796,900 | 내지285=18,438·면지=0 | ✅ GO (라이브 COMMIT분 동작) |
| 082 | 하드커버링 | PRF_HC_TWINRING_SET | **818,438** | 800,000 | 내지286=18,438·면지=0 | ✅ GO |
| 088 | 레더 링바인더 | **(없음)** | **0** | 0 | 표지089·면지090~093 전부 0 | ❌ **결함 PRICE=0** |
| 094 | 엽서북 | PRF_PCB_FIXED | **450,000**¹ | 450,000 | 내지095·표지096=0(부모 all-in) | ✅ GO¹ |
| 097 | 떡메모지 | PRF_TTEOKME_FIXED | **135,000**¹ | 135,000 | 내지098=0(부모 all-in) | ✅ GO¹ |
| 100 | 포토북 | PRF_PHOTOBOOK_FIXED | **1,500,000**¹ | 1,500,000 | 내지101 등=0(부모 all-in) | ✅ GO¹ |
| 172 | 만년다이어리(소프트) | PRF_STN_DIARY_SOFT | **810,000** | 900,000 | 표지293=0(부모 고정가) | ✅ GO |
| 173 | 만년다이어리(하드) | PRF_STN_DIARY_HARD | **1,200,000** | 1,200,000 | 0(부모 고정가) | ✅ GO |
| 174 | 만년다이어리(레더하드) | PRF_STN_DIARY_LHARD | **1,500,000** | 1,500,000 | 0 | ✅ GO |
| 175 | 만년다이어리(레더소프트) | PRF_STN_DIARY_LSOFT | **1,500,000** | 1,500,000 | 0 | ✅ GO |
| 176 | 먼슬리플래너 | PRF_STN_MONTHLY | **1,080,000** | 1,200,000 | 0 | ✅ GO |
| 177 | 스프링노트 | PRF_STN_SPRINGNOTE | **405,000** | 450,000 | 0 | ✅ GO |
| 178 | 스프링수첩 | PRF_STN_SPRINGNOTEBK | **270,000** | 300,000 | 0 | ✅ GO |
| 179 | 메모패드 | PRF_STN_MEMOPAD | **540,000** | 600,000 | 0 | ✅ GO |
| 181 | 중철노트 | PRF_STN_JUNGCHEOL | **225,000** | 250,000 | 0 | ✅ GO |

¹ 094/097/100 = 부모공식이 옵션차원(opt_cd·bdl_qty)을 요구. 스캔 초기값은 그 선택 누락으로 0이었으나, **정확 선택 주입 시 PRICE≠0 실증**(아래 §3). 데이터 결함 아님.

**집계: PRICE≠0 = 18 / 19 · 진짜 결함(PRICE=0) = 1 (088).**

---

## 2. 결함 셋트 근본원인 + 교정 명세

### ❌ 088 레더 링바인더 — PRICE=0 (진짜 결함)

- **근본원인(라이브 실측 확증):**
  - 부모 088 = `t_prd_product_price_formulas` 바인딩 **없음**(frm 0).
  - 구성원 5개(089 표지·090~093 면지) 전부 공식 없음·가격소스 없음(`가격 소스 없음(직접단가·공식 미구성)`).
  - **가격 낼 내지 구성원 부재**(082/077과 달리 내지 member 없음) + COVERBIND 공식 부재 → evaluate_set_price가 합산할 base 0 → **final=0**.
- **동형 비교:** 082 하드커버링=PRF_HC_TWINRING_SET(COMP_BIND_HC_TWINRING·단가행 6) + 내지286. 077 레더하드커버=PRF_HC_MUSEON_SET + 내지285. 088만 부모공식·내지 둘 다 없음.
- **교정 명세(★단순 dryrun 불가·설계+실무진 확인 필요):**
  1. 088에 COVERBIND형 부모공식 바인딩 필요. search-before-mint: 082 `PRF_HC_TWINRING_SET`(링 트윈링) 또는 077 `PRF_HC_MUSEON_SET` 재사용 후보. **단 088=레더+링 조합** → 레더 델타·링 cover_mult 반영 필요.
  2. ★[BLOCKED] 메모리 이력상 **레더/링/트윈링 ×2(cover_mult) = 엔진 C트랙 BLOCKED**(`pricing.py` plate_qty=÷pansu만·×2 곱셈경로 부재, [[leather-hardcover-077-live-commit-260701]]). 088 정확가는 이 엔진결함 해소 종속.
  3. **최소 동작화(PRICE≠0) dryrun 후보**(권위가 확정된 경우만): 088에 `PRF_HC_TWINRING_SET` 재사용 바인딩(`INSERT t_prd_product_price_formulas(prd_cd='PRD_000088', frm_cd='PRF_HC_TWINRING_SET')`) + COMP_BIND_HC_TWINRING 단가행이 088 사이즈/부수 커버하는지 확인. **단 레더 표지 단가 반영은 별도(member 표지 공식 or COVERBIND 레더델타)** → 임의단가 생성 금지·**상품마스터260610 권위 확인 필수**.
  4. 판정: **088 = HOLD(설계 미완)**. dryrun 경로는 "PRF_HC_TWINRING_SET 재사용 바인딩"까지 가능하나 레더 델타+정확가는 권위·엔진 C트랙 확인 전 COMMIT 금지.

### ⚠️ C트랙(코드) — 셋트 시뮬레이터가 멤버 코팅 차원 드롭 (068/069/070 표지 등)

- **근본원인:** `price_views.py:1930`
  ```python
  for k in ("siz_cd", "mat_cd", "print_opt_cd"):   # ← coat_side_cnt 등 누락
      v = mb.get(k)
      if v not in (None, ""): sel[k] = v
  ```
  멤버 selections에 **siz_cd·mat_cd·print_opt_cd만 전달**하고 `coat_side_cnt`(및 기타 공정 상세차원)를 버림. → 표지 코팅 comp(COMP_COAT_MATTE) 미매칭 → 셋트경로 표지 contrib가 코팅비(100부 기준 50,000) 만큼 **저평가**.
- **실증:** 표지 288 **단품** `simulate`(coat_side_cnt=1 in selections) = **88,688**(코팅 50,000 포함). 동일 표지 **셋트** simulate-set = **38,688**(코팅 드롭). 코팅 단가행은 라이브 실재(plt499·coat_side_cnt=1·PROC_000015·tier100 unit=500).
- **영향:** 068/069/070 표지(코팅 있는 책자 표지). 하드커버(072/077/082)는 표지가 COVERBIND 통합·개별 코팅member 없어 무영향.
- **교정 명세(C트랙·webadmin 코드·DB 아님):** `price_simulate_set` 멤버 파싱에 `coat_side_cnt`(+ 필요시 공정 detail 차원) 포워딩 추가. **데이터 교정 아님·개발팀 위임**. (실 주문 위젯 경로가 이 뷰를 안 거치면 주문가는 정상일 수 있음 — 위젯 member 페이로드 확인 필요.)
- **주의:** 이 결함은 **PRICE≠0을 깨지 않음**(068 등 여전히 print+paper+bind로 PRICE≠0). 골든 정확 재현만 저해.

---

## 3. 094/097/100 = 데이터 정상 (빌더 선택누락·오진단 정정)

부모공식·단가행 라이브 실재. 스캔 초기 0은 부모공식이 요구하는 옵션차원 미선택 때문. **정확 선택 주입 실측:**

| PRD | 부모 comp use_dims | 정확 선택 | final |
|-----|------|------|:---:|
| 094 엽서북 | COMP_PCB_S1_20P: siz_cd·print_opt_cd·opt_cd(OPV_000491)·opt_grp OPT_000082 | siz003·POPT_000001·opt OPV_000491 | **450,000** ✅ |
| 097 떡메모지 | COMP_TTEOKME: siz_cd·bdl_qty·min_qty | siz119·**bdl_qty=50**(1000 아님) | **135,000** ✅ |
| 100 포토북 | COMP_PHOTOBOOK_BASE: siz_cd·opt_cd·min_qty | siz269·opt OPV_000484 | **1,500,000** ✅ |

→ **결함 아님.** 위젯/시뮬레이터가 해당 옵션(권종·묶음수·표지종류)을 손님 선택으로 전달하면 정상 계산. (교훈: 고정형 셋트는 부모공식 옵션차원을 반드시 채워야 함 — 스캔 자동빌더가 opt_grp/bdl_qty 기본값을 못 채운 것.)

---

## 4. 판정 종합

| 판정 | 개수 | 셋트 |
|------|:---:|------|
| ✅ PRICE≠0 GO | **18** | 068·069·070·072·077·082·094·097·100·172·173·174·175·176·177·178·179·181 |
| ❌ PRICE=0 결함 | **1** | 088 레더 링바인더 (부모공식·내지 전무·HOLD·설계+엔진C트랙 종속) |
| ⚠️ C트랙 코드결함(GO 유지) | (횡단) | 068/069/070 표지 코팅 드롭(`price_views.py:1930`·저평가만·PRICE≠0 무해) |

**교정 난이도:**
- **088**: 데이터 dryrun만으로 불가. PRF_HC_TWINRING_SET 재사용 바인딩까지는 dryrun 가능하나 **레더 델타·정확가는 권위(상품마스터260610) + 엔진 cover_mult C트랙 확인 필요** → 실무진/설계.
- **코팅 드롭(068/069/070)**: **webadmin 코드 C트랙**(개발팀). DB 무관.
- **094/097/100**: **교정 불요**(데이터 정상).

**미확인(확인 필요):**
- 088 최소동작화 시 사용할 정확 부모공식·레더 표지 단가(권위 엑셀 대조 미완).
- 실제 주문(위젯) 경로가 `price_simulate_set` 뷰를 경유하는지 vs evaluate_set_price 직접호출인지(코팅 드롭이 주문가에도 영향인지) — 위젯 member 페이로드 확인 필요.

산출 스크립트: `_workspace/_foundation/batch/set_full_scan.py`(전수), `set_fix3.py`(094/097/100 재확인), `gold_repro.py`(골든 재현). 라이브 읽기전용·DB 미적재.
