# C5 — 고정가 셋트(엽서북·떡메) 가격테이블 적재정합 전수 검증

작성 2026-06-26 · A2 전체 가격테이블 적재정합 전수 검증 클러스터 C5 · §23 셋트 하네스 직결 · 라이브 읽기전용 SELECT만 · **DB 미적재**. 생성≠검증 — 모든 주장은 라이브 쿼리/권위 셀 근거(추측 0·날조 0).

**범위:** PRF_PCB_FIXED(엽서북 094)·PRF_TTEOKME_FIXED(떡메모지 097). 단가행 = COMP_PCB_S1_20P/S1_30P/S2_20P/S2_30P(각 117=468)·COMP_TTEOKME(112) = 580행.

---

## 0. 종합 판정

| 항목 | 결과 |
|---|---|
| **C5 종합** | **PARTIAL GO** — 단가행 580행 verbatim 100% 정합(MISMATCH 0)·097 전건 READY·094 20P 정합. 단 094 **30P 고아배선(견적 silent under-charge)** 1건 HIGH 잔존. |
| 단가행 정합(축1) | **GO** — 권위 워크북 580 ↔ 라이브 580 **MISMATCH=0·누락0·잉여0**(전수 대조). |
| 배선 정합(축2) | **PARTIAL** — 097 정상·094 20P 정상(print_opt 배타). **094 30P comp 2종 미배선(고아)** — use_dims에 print_opt 미포함이라 배선 시 이중합산 위험까지 동반. |
| 바인딩 정합(축3) | **GO** — 094·097 둘 다 라이브 바인딩 실재(BIND 2행). |
| ★HIGH 결함 수 | **1건**(094 30P 고아배선 → 30P 선택 시 20P 단가로 silent 저청구·돈크리티컬). |
| 094 상태 | 바인딩·구성원·유형교정 **모두 라이브 적용됨**(현황판 "결함보유"는 부분적 stale). 잔여 결함=30P 1건. |
| 097 상태 | **READY 확정**(드리프트 0). 골든 단가 verbatim·구성 정합·이중합산 0. |

---

## 1. ★현황판/round-16 대비 드리프트 (라이브가 진화함)

검증 입력 문서(현황판·round-16 분해)와 라이브 실측이 **불일치** — 라이브가 그 후 진화했다. 검증은 라이브 권위.

| 항목 | 입력 문서 주장 | 라이브 실측(2026-06-26) | 판정 |
|---|---|---|---|
| 094 가격 바인딩 | "094=결함보유, 097만 COMMIT"(현황판)·"094 바인딩 0행"(round-16 §5 단절2는 떡메지만 094도 0이라 기록) | **PRD_000094→PRF_PCB_FIXED 바인딩 실재**(apply_bgn_ymd=2026-06-01) | 094 바인딩 적재됨 = stale |
| 094 구성원·유형 | set-verdict CONDITIONAL GO(미적재) | 구성원 95(min20/max30/incr10·disp1)·96(disp2) **보정 적용**·094 prd_typ_cd=**PRD_TYPE.01**(04→01 교정 적용) | set 설계 COMMIT됨 = stale |
| S1_20P/S2_20P use_dims | `[siz_cd, min_qty]`(round-16 분해·워크북 print_opt 전건 빈칸) | `[siz_cd, min_qty, **print_opt_cd**]`·단가행 print_opt 채워짐(S1=POPT_000001 전건·S2=POPT_000002 전건) | **20P comp에 print_opt 차원 보강됨**(배타 매칭 성립) = 진화 |
| 094 이중합산(R-3) | "S1·S2 NON_QTY_DIM 동일 매칭→합산"(현황판 R-3) | **20P는 print_opt로 배타** → 이중합산 0(아래 §3 실측) | 20P에 한해 R-3 false-positive = 진술 정정 필요 |

→ 094 set 설계가 이미 라이브에 적재됐고, 20P comp에 print_opt 차원이 보강돼 R-3 이중합산이 **20P 경로에서는 해소**됐다. 그러나 **30P comp는 그 보강을 못 받아 고아+무차원**으로 남아 다른 종류의 돈결함(silent under-charge)을 만든다(§4).

---

## 2. 축1 — 단가행 값 정합 (verbatim·전수)

권위 = `_workspace/huni-dbmap/20_price-import/postcard-book-memo/postcard-book-memo-import.xlsx` `4_component_prices_RU`(580행·가격표 260527 원천 무손실 재현). 라이브 = `t_prc_component_prices`.

| comp | 권위 행수 | 라이브 행수 | 단가 MISMATCH | 누락 | 잉여 |
|---|---|---|---|---|---|
| COMP_PCB_S1_20P | 117 | 117 | 0 | 0 | 0 |
| COMP_PCB_S1_30P | 117 | 117 | 0 | 0 | 0 |
| COMP_PCB_S2_20P | 117 | 117 | 0 | 0 | 0 |
| COMP_PCB_S2_30P | 117 | 117 | 0 | 0 | 0 |
| COMP_TTEOKME | 112 | 112 | 0 | 0 | 0 |
| **합계** | **580** | **580** | **0** | **0** | **0** |

자연키 (comp,siz,bdl,min) 전수 join 대조 = **MISMATCH 0·auth-only 0·live-only 0**. 단가값 100% verbatim.

**verbatim 표본(라이브 SELECT·권위 셀 대조):**

| comp | siz | print_opt | bdl | min_qty | 권위 단가 | 라이브 단가 | 일치 |
|---|---|---|---|---|---|---|---|
| S1_20P | SIZ_000003(100x150) | POPT_000001(단면) | – | 100 | 4,500 | 4,500 | ✅ |
| S2_20P | SIZ_000003 | POPT_000002(양면) | – | 100 | 4,500 | 4,500 | ✅ |
| S1_30P | SIZ_000003 | (NULL) | – | 100 | 5,100 | 5,100 | ✅ |
| TTEOKME | SIZ_000119(90x90) | – | 50 | 30 | 2,000 | 2,000 | ✅ |
| TTEOKME | SIZ_000266(70x120) | – | 100 | 6 | 3,200 | 3,200 | ✅ |

→ **축1 = GO**(단가 정합 완전).

---

## 3. 축2 — 배선 정합 + ★R-3 이중합산 라이브 재현

### 3.1 배선 실측

```
PRF_PCB_FIXED (use_yn=Y)
 ├─ COMP_PCB_S1_20P  disp_seq=1·addtn_yn=Y  use_dims=[siz_cd,min_qty,print_opt_cd]  단가 117(POPT_000001 전건)
 └─ COMP_PCB_S2_20P  disp_seq=2·addtn_yn=Y  use_dims=[siz_cd,min_qty,print_opt_cd]  단가 117(POPT_000002 전건)
    ─ COMP_PCB_S1_30P  ❌ 미배선(고아)  use_dims=[siz_cd,min_qty]  print_opt NULL 전건
    ─ COMP_PCB_S2_30P  ❌ 미배선(고아)  use_dims=[siz_cd,min_qty]  print_opt NULL 전건

PRF_TTEOKME_FIXED (use_yn=Y)
 └─ COMP_TTEOKME  disp_seq=1·addtn_yn=Y  use_dims=[siz_cd,bdl_qty,min_qty]  단가 112(proc/opt/clr/mat 전건 NULL)
```

### 3.2 ★R-3 이중합산 라이브 재현 (돈크리티컬·`_evaluate_formula` 순회 합산 모델)

엔진(`pricing.py` `_evaluate_formula` L537-600)은 배선된 comp를 순회하며 각각 `match_component`로 매칭 후 `included`면 `total += subtotal`. comp간 배타 선택 장치 없음 → **같은 면(side) 조합이 둘 이상 included되면 silent 합산**. `_row_matches`(L82): use_dims에 있는 차원만 비교, NULL 차원은 와일드카드.

**20P 경로 (현재 배선·SIZ_000003·min≤100 매칭행 실측):**

| 선택 | S1_20P 매칭행 | S2_20P 매칭행 | included | 이중합산 |
|---|---|---|---|---|
| 단면(POPT_000001) | **14** | **0** | S1만 | **없음** ✅ |
| 양면(POPT_000002) | **0** | **14** | S2만 | **없음** ✅ |

→ S1_20P·S2_20P는 print_opt_cd가 use_dims에 **포함**되고 단가행이 면별 전건 분리(S1=단면전건·S2=양면전건)라, `_row_matches`가 선택 면과 다른 comp를 0행으로 걸러냄. **20P 경로는 R-3 이중합산이 발생하지 않는다**(현황판 R-3 진술은 20P에 한해 false-positive).

**30P 경로 (★가정검증 — 만약 배선됐다면):**

| 선택 | S1_30P 매칭행 | S2_30P 매칭행 | 이중합산 위험 |
|---|---|---|---|
| 단면/양면 무관 | **14** | **14** | **둘 다 매칭 → S1+S2 silent 합산** ⚠️ |

→ S1_30P/S2_30P는 print_opt_cd가 **NULL 전건이고 use_dims에 미포함**. `_row_matches`가 print_opt를 비교 안 하므로 단면/양면 무관하게 둘 다 매칭 → 만약 PRF_PCB_FIXED에 배선되면 **30P 양면 주문 시 단면+양면 단가가 합산되는 R-3 이중합산이 실재**. **현재는 미배선이라 트리거 안 됨**(잠재 결함). → 30P를 정상 청구하려면 배선과 함께 **반드시 print_opt 차원 보강(20P 패턴 답습)** 필요(단순 배선만 하면 이중합산 활성화).

→ **축2 = PARTIAL**(097·094 20P 정상·094 30P 미배선 고아).

---

## 4. ★HIGH 결함 — 094 30P silent under-charge (돈크리티컬·전 책자 공통 가족)

라이브 동작(`pricing.py` 매칭 모델 + 단가행 실측):

- PRD_000094 등록 사이즈 3종·등록 print_opt 2종(단면·양면). 권위 booklet-l1 row61: 내지 페이지 **20/30 택1**(min_cnt20/max_cnt30/cnt_incr10 — 라이브 구성원 95에 적용됨).
- 그러나 **페이지(20P/30P)는 어떤 comp의 use_dims에도 없다**(round-16 분해 §3·라이브 확인 — page는 comp 식별자 _20P/_30P로만 구분). 그리고 **PRF_PCB_FIXED에는 20P comp 2종만 배선**.
- 결과: 사용자가 **30P를 선택해도 엔진은 30P comp를 모르고(미배선) 20P comp만 매칭** → **30P 가격(비쌈)인데 20P 단가(저렴)로 견적 = silent under-charge**.
- 돈 입증(SIZ_000003 단면 min100): 20P=4,500 vs 30P 정답=5,100 → **장당 600원 저청구**(100부 = 60,000원 손실). 전 사이즈·수량 구간에서 30P가 20P보다 비쌈.
- **이것은 "견적불가(매칭0)"가 아니라 오청구**(set-verdict price-e2e §4 게이트 독립 발견과 동일). silent라 더 위험.

**교정(돈영향·인간 승인·미적재):** 신규 단가 데이터 생성 아님(30P 단가행 234행 이미 라이브 정합 적재). 필요 = ① 30P comp 2종을 PRF_PCB_FIXED에 배선(disp_seq 3·4) **+** ② 페이지 차원을 선택→공식분기 로직에 연결, **+ ③ 30P comp에 print_opt_cd 차원 보강**(안 하면 §3.2 이중합산 활성). → §18 가격엔진설계/dbmap 코드+데이터 트랙. **set 적재본 범위 밖**(094 구성원 행은 이 결함 무관).

---

## 5. 축3 — 바인딩 정합

| 상품 | 라이브 바인딩 | 구성원 | 할인 | 유형 |
|---|---|---|---|---|
| PRD_000094(엽서북) | ✅ PRF_PCB_FIXED(2026-06-01) | 95(내지)·96(표지)·구성원가 0(비기여) | discount 0행 | PRD_TYPE.01(교정 적용) |
| PRD_000097(떡메) | ✅ PRF_TTEOKME_FIXED(2026-06-01) | 098(내지)·가격공식 0행(비기여) | discount 0행 | (셋트 완제품) |

- 구성원(95/96/098) 전건 가격공식 0행 → `evaluate_set_price`에서 구성원 합산 기여 0 → 셋트 완제품 자기 공식 단독 견적(고정가형 정합). **구성원↔셋트공식 이중계상 0**.
- 둘 다 apply_bgn_ymd=2026-06-01 = 단가행 apply_ymd 전건과 정합.

→ **축3 = GO**.

### 5.1 097 골든 재현(설계 골든 검산·이중합산 0)

- 골든1 90x90/50장/30권: TTEOKME min30=2,000(verbatim) × 30 = **60,000**. siz/bdl 정확매칭·min 티어 1행(모호성 0).
- 골든2 70x120/100장/6권: TTEOKME min6=3,200(verbatim) × 6 = **19,200**.
- 단일 comp·구성원 비기여·proc/opt/clr/mat 전건 NULL(always-add 와일드카드 다중매칭 0·off-grid는 siz2×bdl2 그리드 밖만·UI 통제 항목) → **이중합산 0**.

### 5.2 094 20P 골든 재현(set-verdict S4 동일)

- 20P/단면/SIZ_000003/100부: S1_20P min100=4,500 × 100 = **450,000**. S2_20P 양면전건 → 단면선택 0행 included=False. **이중합산 0·PRICE≠0**.

---

## 6. 재현 쿼리 (감사용·읽기전용)

```sql
-- 배선·use_dims·바인딩
SELECT frm_cd,comp_cd,disp_seq,addtn_yn FROM t_prc_formula_components WHERE frm_cd IN('PRF_PCB_FIXED','PRF_TTEOKME_FIXED');
SELECT comp_cd,prc_typ_cd,use_dims FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_PCB%' OR comp_cd='COMP_TTEOKME';
SELECT prd_cd,frm_cd,apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd IN('PRD_000094','PRD_000097');
-- R-3 이중합산 재현(양면 선택 시 각 배선 comp 매칭행수)
SELECT 'S1_20P', COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S1_20P' AND siz_cd='SIZ_000003' AND (print_opt_cd='POPT_000002' OR print_opt_cd IS NULL) AND min_qty<=100;  -- 0(배타)
SELECT 'S2_20P', COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S2_20P' AND siz_cd='SIZ_000003' AND (print_opt_cd='POPT_000002' OR print_opt_cd IS NULL) AND min_qty<=100;  -- 14
-- 30P 이중합산 잠재(use_dims에 print_opt 없음·NULL 와일드카드)
SELECT comp_cd, COUNT(*) FROM t_prc_component_prices WHERE comp_cd IN('COMP_PCB_S1_30P','COMP_PCB_S2_30P') AND siz_cd='SIZ_000003' AND min_qty<=100 GROUP BY comp_cd;  -- 각 14 둘다매칭
-- 30P under-charge 돈영향
SELECT comp_cd,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd IN('COMP_PCB_S1_20P','COMP_PCB_S1_30P') AND siz_cd='SIZ_000003' AND min_qty=100;  -- 4500 vs 5100
```

근거: 라이브 읽기전용 SELECT(2026-06-26·`.env.local RAILWAY_DB_*`)·권위 워크북 `4_component_prices_RU` 전수 join·`pricing.py` L82(_row_matches)·L122(match_component)·L181(component_subtotal)·L537(_evaluate_formula 순회합산).
