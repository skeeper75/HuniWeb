# 유형 A 병합 재배선 매니페스트 — 9군 전건 (설계·읽기전용)

> **범위:** 병합 후보 보드 9군(27 comp→9)의 병합 설계 + formula_components 재배선 명세.
> **안전:** 읽기전용 분석. DB 미적재·COMMIT 금지. 실 적용은 **군별 인간 승인 후 별도 단계**(ROLLBACK→COMMIT 교체).
> **입력(읽기전용):** 병합 보드 `component-merge-board.md` · 탐지 `_foundation/batch/component_merge_scan.py` ·
> live-snapshot latest CSV(2026-07-02) · **라이브 Railway DB 읽기전용 SELECT 재실측**(nat_key 인덱스·행 대조·엔진 계약).
> **엔진 계약 권위:** `raw/webadmin/webadmin/catalog/pricing.py`(단일 권위 evaluate_price 알고리즘).
> **날조 0:** comp_cd·unit_price·POPT/OPV/MAT/SIZ·PRF verbatim. 추정은 "(추정)".

---

## 0. 요약표 (9군)

| 군 | 정본 comp_cd | prc_typ | 멤버→정본 | 단가행 이관 | fc 재배선 N→1 | 영향공식(PRF) | 오염가드 | 골든 통과 | 상태 |
|---|---|---|---|---|---|---|---|---|---|
| MC-01 | `COMP_PCB` (라이브 in-place=`COMP_PCB_S1_20P`) | .01 단가형 | 4→1 | 468(S1_20P만·재이관) | 1→1 | PRF_PCB_FIXED | PASS(공식이 정본1개만 배선) | PASS(3) | ★**라이브 이미 병합됨**(2026-07-03)·잔여=정본명 정합+고아3 논리삭제 |
| MC-02 | `COMP_NAMECARD_PREMIUM` | .02 합가형 | 4→1 | 28 | 8→2 | PRF_NAMECARD_PREMIUM · _PREMIUM_FOIL | PASS | PASS(4) | GO(설계) |
| MC-03 | `COMP_NAMECARD_FOIL` | .02 합가형 | 4→1 | 36 | 4→1 | PRF_NAMECARD_FOIL | PASS | PASS(3) | GO(설계) |
| MC-04 | `COMP_NAMECARD_WHITE` | .02 합가형 | 4→1 | 4 | 4→1 | PRF_NAMECARD_WHITE | PASS | PASS(4) | GO(설계) |
| MC-05 | `COMP_NAMECARD_STD` | .02 합가형 | 2→1 | 10 | 4→2 | PRF_NAMECARD_FIXED · _FIXED_FOIL | PASS | PASS(2) | GO(설계) |
| MC-06 | `COMP_NAMECARD_COAT` | .02 합가형 | 2→1 | 4 | 2→1 | PRF_NAMECARD_COAT | PASS | PASS(2) | GO(설계) |
| MC-07 | `COMP_NAMECARD_PEARL` | .02 합가형 | 2→1 | 8 | 4→2 | PRF_NAMECARD_PEARL · _PEARL_FOIL | PASS | PASS(2) | GO(설계) |
| MC-08 | `COMP_NAMECARD_SHAPE` | .02 합가형 | 2→1 | 2 | 2→1 | PRF_NAMECARD_SHAPE | PASS | PASS(2) | GO(설계) |
| MC-09 | `COMP_NAMECARD_MINISHAPE` | .02 합가형 | 2→1 | 2 | 2→1 | PRF_NAMECARD_MINISHAPE | PASS | PASS(2) | GO(설계) |

**합계:** 27 comp→9 · 단가행 재comp_cd **562건**(보드 일치) · formula_components **34행→12행**(보드 일치).
comp_typ_cd = 전군 **PRC_COMPONENT_TYPE.06 완제품비**(멤버 동일 확인).

**BLOCKED/특수 없음(GO 8, 라이브-이미완료 1=MC-01)**. 단, MC-01 재조정·정본명 정책은 컨펌큐 참조(§4).

---

## 1. 결정적 사전검증 (병합 가능성의 뿌리)

### 1.1 라이브 nat_key 인덱스 — 병합 물리 가능성 [HARD 확인]
스냅샷 동봉 DDL(260606)은 **stale**(print_opt_cd·opt_cd 컬럼 이전 시점). 라이브 read-only 재조회 결과 현행 UNIQUE 인덱스는 **15열로 확장**:

```
ux_t_prc_comp_prices_nat_key = (comp_cd, apply_ymd, siz_cd, plt_siz_cd, clr_cd, mat_cd,
    proc_cd, opt_cd, print_opt_cd, coat_side_cnt, bdl_qty, siz_width, siz_height, min_qty,
    ((COALESCE(dim_vals,'{}'::jsonb))::text))
```

→ **분리축 print_opt_cd·opt_cd·mat_cd 가 전부 nat_key 안**. 정본 1개 comp_cd 아래 멤버 행이 공존해도
분리축이 다르면 nat_key 충돌 없음 = 병합 물리 가능. (8열 nat_key 가정하면 전군 충돌이나, 그건 stale 260606 오해.)

### 1.2 엔진 계약(pricing.py) — silent 이중합산 불가 [HARD 확인]
- `NON_QTY_DIMS = (siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty)` — **분리축이 전부 정확매칭 차원**. 엔진이 print_opt_cd·opt_cd·mat_cd 로 행을 정확히 가른다.
- `_row_matches`: 행 차원이 NULL 이면 와일드카드(어떤 선택도 통과). **본 9군 멤버 단가행은 print_opt_cd 전부 NON-NULL**(라이브 재확인: NULL-print_opt 행 = 0/전군) → 와일드카드 과금 누출 없음.
- `match_component`: 한 comp 의 후보행이 **비수량 차원조합 2개 이상 동시매칭이면 `ERR_AMBIGUOUS`(치명오류·차단)** — silent 합산이 아니라 에러. 병합 후 한 주문은 정본에서 정확히 1행 매칭(분리축으로 배타) → 이중합산 구조적 불가.
- `component_subtotal`: .01 단가형=unit_price×수량 · .02 합가형=unit_price÷구간min_qty×수량.

### 1.3 격자 무손실(disjoint) — 라이브 재실측
전 9군 멤버 단가행을 정본으로 이관 시 15열 nat_key 충돌 = **MC-02~09 전부 0**(라이브 확인).
MC-01 은 라이브 특수상황(§4). 스냅샷 기준 disjoint 증명도 동일(0 충돌·0 가격 conflict).

| 군 | 라이브 멤버행 | 이관후 nat_key 충돌 | NULL-print_opt 누출 |
|---|---|---|---|
| MC-01 | 819 | 351 ★(이미 in-place 병합 잔재·§4) | 0 |
| MC-02 | 28 | 0 | 0 |
| MC-03 | 36 | 0 | 0 |
| MC-04 | 4 | 0 | 0 |
| MC-05 | 10 | 0 | 0 |
| MC-06 | 4 | 0 | 0 |
| MC-07 | 8 | 0 | 0 |
| MC-08 | 2 | 0 | 0 |
| MC-09 | 2 | 0 | 0 |

---

## 2. search-before-mint

- 정본 9종 전부 라이브 price_components 에 **미존재**(재사용 가능한 기존 base comp 0). 멤버 comp_cd 는 이름에 분리축(_S1/_S2/_MGA/_20P)이 하드코딩돼 정본으로 무손실 재사용 불가 → 정본 신규 확정 정당(무손실 표현 불가 입증).
- 정본명 = 멤버 공통 base(축 접미사 제거) — 사용자 [확정] 규칙. 임의 채번 아님(결정론 파생).
- **채번 규약:** comp_cd 는 명명 문자열(MAX+1 아님). separator `_`. comp_typ_cd·use_dims 는 멤버값 승계(신규 도메인코드 mint 0).
- 정본 comp_nm = 기존 대표행(단면/S1/MGA/20P) verbatim 승계(표시명 대정비 = 이번 범위 밖). note 에 `[차원통합] 통합축=…` 명시.
  · ⚠️ 대표행 comp_nm 이 "…단면…"이라 병합 후 표시가 실제와 어긋남(예 `COMP_NAMECARD_STD` nm="…단면…"). **cosmetic 결함·load-bearing 아님** → comp_nm 정비는 별도 후속(dbm-price-arbiter/미래 표시명 정리). MC-01 은 라이브가 이미 "…사이즈/양단면/페이지수별…"로 갱신됨(모범).

---

## 3. 군별 매니페스트 (MC-02~09, 표준 유형 A)

각 군: ① 정본 comp ② 단가행 이관 ③ comp 카탈로그 ④ 재배선 ⑤ 오염가드 ⑥ 골든. DRY-RUN SQL = `_dryrun/<군>-*.sql`.
공통 패턴(hbd-dedup 무손실): 정본 upsert → 단가행 comp_cd 재지정(UPDATE) → fc 멤버행 DELETE + 정본 1행/공식 UPSERT + bystander disp_seq 재정렬 → 멤버 use_yn='N'·del_yn='Y'·del_dt 논리삭제(hard-delete 금지).

### MC-02 · 프리미엄명함 (PRD_000031)
- **정본:** `COMP_NAMECARD_PREMIUM` · typ .06 · prc_typ **.02 합가형** · use_dims `["mat_cd","print_opt_cd","min_qty"]`(멤버 동일).
- **멤버(4):** `_S1_MGA`(POPT_000001·MGA종이 7종) · `_S1_MGB`(POPT_000001·MGB종이 7종) · `_S2_MGA`(POPT_000002·MGA) · `_S2_MGB`(POPT_000002·MGB). 분리축 = print_opt_cd(면) + mat_cd(종이등급 A/B, 값 disjoint).
- **단가행 이관:** 28행(7×4) → 정본. MGA/MGB mat_cd 집합 disjoint(MGA=MAT_000101/102/108/109/113/114/115 · MGB=MAT_000116/117/118/123/124/125/126). print_opt_cd·mat_cd 이미 행 충전 → verbatim 불변.
- **재배선(fc 8→2):** `PRF_NAMECARD_PREMIUM`(멤버 seq1-4 삭제→정본 seq1; bystander PP_VARTEXT_1EA 5→2·PP_VARIMG_1EA 6→3·PP_CORNER_RIGHT 7→4) · `PRF_NAMECARD_PREMIUM_FOIL`(멤버 seq1-4 삭제→정본 seq1; FOIL_SETUP_SMALL 5→2·FOIL_PROC_SMALL_STD 6→3·FOIL_PROC_SMALL_SPECIAL 7→4·PP_VARTEXT_1EA 8→5·PP_VARIMG_1EA 9→6·PP_CORNER_RIGHT 10→7).
- **오염가드 PASS:** 주문이 (면,mat)로 정본에서 1행 매칭. bystander(PP_*·FOIL_*)는 별개 comp·의도적 가산(교차합산 아님). ERR_AMBIGUOUS 불가(disjoint).
- **골든(합가형, min_qty 티어=100, 수량=100):**
  | 선택 | 매칭 unit_price | comp소계 | 병합전=병합후 |
  |---|---|---|---|
  | 단면·MGA(MAT_000101) | 4500.00 | 4500 | S1_MGA→4500, 타 no_match ⇒ 정본 4500 ✓ |
  | 단면·MGB(MAT_000116) | 5000.00 | 5000 | S1_MGB→5000 ⇒ 정본 5000 ✓ |
  | 양면·MGA(MAT_000101) | 5500.00 | 5500 | S2_MGA→5500 ⇒ 정본 5500 ✓ |
  | 양면·MGB(MAT_000116) | 6500.00 | 6500 | S2_MGB→6500 ⇒ 정본 6500 ✓ |

### MC-03 · 오리지널박명함 (PRD_000037)
- **정본:** `COMP_NAMECARD_FOIL` · typ .06 · prc_typ .02 · use_dims `["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000080"]`.
- **멤버(4):** `_S1_STD`(POPT_000001·OPV_000487 일반박) · `_S1_HOLO`(POPT_000001·OPV_000488 홀로/트윙클) · `_S2_STD`(POPT_000002·OPV_000487) · `_S2_HOLO`(POPT_000002·OPV_000488). 분리축 = print_opt_cd(면)+opt_cd(박종류).
- **단가행 이관:** 36행(9×4)→정본. 각 9 수량구간(min_qty 200,300,…).
- **재배선(fc 4→1):** `PRF_NAMECARD_FOIL` — 멤버 seq1,3,4,5 삭제→정본 seq1; bystander `COMP_NAMECARD_FOIL_SETUP_S1_STD` 2→2·`COMP_NAMECARD_FOIL_SETUP_S2_STD` 6→3(동판셋업비, 병합 대상 아님·유지).
- **관찰(비결함):** S1_STD·S2_STD unit_price 동일(19200…), HOLO 도 동일 — 박완제품가는 면(print_opt_cd) 무관. 정본은 여전히 print_opt_cd 로 정확한 행 선택(무해 잉여축).
- **오염가드 PASS:** 주문 (면,박종류)로 1행. SETUP comp 2종은 면별 별개(의도 가산).
- **골든(합가형, 수량=티어):**
  | 선택 | unit_price | 병합전=병합후 |
  |---|---|---|
  | 단면·일반박(OPV_000487)·qty200 | 19200.00 | S1_STD→19200 ⇒ 정본 19200 ✓ |
  | 단면·홀로(OPV_000488)·qty200 | 24800.00 | S1_HOLO→24800 ⇒ 정본 24800 ✓ |
  | 양면·일반박(OPV_000487)·qty300 | 24800.00 | S2_STD→24800 ⇒ 정본 24800 ✓ |
  · 완제품 총가 = 정본 + SETUP(불변) → merge 무영향.

### MC-04 · 화이트인쇄명함 (PRD_000040)
- **정본:** `COMP_NAMECARD_WHITE` · typ .06 · prc_typ .02 · use_dims `["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000081"]`.
- **멤버(4):** `_S1W_CL`(POPT_000001·OPV_000490 코팅) · `_S1W_NOCL`(POPT_000001·OPV_000489 무코팅) · `_S2W_CL`(POPT_000002·OPV_000490) · `_S2W_NOCL`(POPT_000002·OPV_000489). 분리축 = print_opt_cd(면)+opt_cd(코팅유무).
- **단가행 이관:** 4행(1×4)→정본.
- **재배선(fc 4→1):** `PRF_NAMECARD_WHITE` — 멤버 seq1-4 삭제→정본 seq1(bystander 없음).
- **주의:** PRF_NAMECARD_WHITE frm_nm 은 "…클리어별색…"이라 표기하나 실 분리축=opt_cd(OPV_000489무코팅/000490코팅). opt_cd 값이 권위 — frm_nm 은 loose(비-load-bearing).
- **오염가드 PASS.** 골든(합가형·qty100):
  | 선택 | unit_price | ✓ |
  |---|---|---|
  | 단면·코팅(OPV_000490) | 16000.00 | S1W_CL ⇒ 정본 16000 ✓ |
  | 단면·무코팅(OPV_000489) | 14500.00 | S1W_NOCL ⇒ 정본 14500 ✓ |
  | 양면·코팅(OPV_000490) | 19000.00 | S2W_CL ⇒ 정본 19000 ✓ |
  | 양면·무코팅(OPV_000489) | 16000.00 | S2W_NOCL ⇒ 정본 16000 ✓ |

### MC-05 · 스탠다드명함 (PRD_000033)
- **정본:** `COMP_NAMECARD_STD` · typ .06 · prc_typ .02 · use_dims `["mat_cd","min_qty","print_opt_cd"]`.
- **멤버(2):** `_S1`(POPT_000001) · `_S2`(POPT_000002). 분리축 = print_opt_cd(면). mat_cd 공유(MAT_000074/081/082/091/092).
- **단가행 이관:** 10행(5×2)→정본.
- **재배선(fc 4→2):** `PRF_NAMECARD_FIXED`(멤버 seq1,2 삭제→정본 seq1) · `PRF_NAMECARD_FIXED_FOIL`(멤버 seq1,2 삭제→정본 seq1; FOIL_SETUP_SMALL 3→2·FOIL_PROC_SMALL_STD 4→3·FOIL_PROC_SMALL_SPECIAL 5→4). ※ `PRF_NAMECARD_FIXED_FOIL` 은 현재 바인딩 상품 0(고아 공식)이나 배선 일관성 위해 동일 재배선.
- **오염가드 PASS.** 골든(합가형·MAT_000074·qty100):
  | 선택 | unit_price | ✓ |
  |---|---|---|
  | 단면(POPT_000001) | 3500.00 | S1→3500, S2 no_match ⇒ 정본 3500 ✓ |
  | 양면(POPT_000002) | 4500.00 | S2→4500 ⇒ 정본 4500 ✓ |

### MC-06 · 코팅명함 (PRD_000032)
- **정본:** `COMP_NAMECARD_COAT` · .06 · .02 · use_dims `["mat_cd","min_qty","print_opt_cd"]`. 멤버 `_S1`/`_S2`(print_opt_cd). mat_cd 공유(MAT_000081/082).
- **이관:** 4행. **재배선(fc 2→1):** `PRF_NAMECARD_COAT` 멤버 seq1,2→정본 seq1. **오염가드 PASS.**
- **골든:** 단면·MAT_000081 =5500 · 양면·MAT_000082 =6800 (병합전=후 ✓).

### MC-07 · 펄명함 스타드림 (PRD_000034)
- **정본:** `COMP_NAMECARD_PEARL` · .06 · .02 · use_dims `["mat_cd","min_qty","print_opt_cd"]`. 멤버 `_S1`/`_S2`. mat_cd 공유(MAT_000352/358/359/360).
- **이관:** 8행. **재배선(fc 4→2):** `PRF_NAMECARD_PEARL`(멤버→정본 seq1) · `PRF_NAMECARD_PEARL_FOIL`(멤버→정본 seq1; FOIL_SETUP_SMALL 3→2·PROC_SMALL_STD 4→3·PROC_SMALL_SPECIAL 5→4). **오염가드 PASS.**
- **골든(MAT_000352·qty100):** 단면=9000 · 양면=10000 (✓).

### MC-08 · 모양명함 (PRD_000035)
- **정본:** `COMP_NAMECARD_SHAPE` · .06 · .02 · use_dims `["siz_cd","min_qty","print_opt_cd"]`. 멤버 `_S1`/`_S2`. siz_cd 공유(SIZ_000008).
- **이관:** 2행. **재배선(fc 2→1):** `PRF_NAMECARD_SHAPE` 멤버→정본 seq1. **오염가드 PASS.**
- **골든(SIZ_000008·qty100):** 단면=18000 · 양면=19000 (✓).

### MC-09 · 미니모양명함 (PRD_000036)
- **정본:** `COMP_NAMECARD_MINISHAPE` · .06 · .02 · use_dims `["siz_cd","min_qty","print_opt_cd"]`. 멤버 `_S1`/`_S2`. siz_cd 공유(SIZ_000011).
- **이관:** 2행. **재배선(fc 2→1):** `PRF_NAMECARD_MINISHAPE` 멤버→정본 seq1. **오염가드 PASS.**
- **골든(SIZ_000011·qty100):** 단면=16000 · 양면=17000 (✓).

---

## 4. MC-01 · 엽서북 PCB — ★라이브 이미 병합됨(특수)

**발견(라이브 read-only 재실측, 2026-07-04):** 스냅샷(2026-07-02) 이후 **2026-07-03 라이브에서 이미 IN-PLACE 병합 실행됨**.
- `COMP_PCB_S1_20P` = 전 격자 **468행**(4콤보 POPT_000001/2 × OPV_000491/492 × 117) 보유. use_dims·comp_nm 갱신됨("엽서북 완제품가 사이즈/양단면/페이지수별 단가").
- `PRF_PCB_FIXED` = **`COMP_PCB_S1_20P` 단일 배선**(disp_seq=1). 나머지 3 멤버(S1_30P/S2_20P/S2_30P)는 **고아**(배선 0)·각 117행 중복본 잔존.
- **이중합산 없음:** 공식이 정본 1개만 배선 → 엔진이 정본에서 (면,페이지,사이즈,수량)로 1행 매칭. 고아 3멤버 데이터는 참조 안 됨.

**해석:** 보드가 계획한 "새 COMP_PCB 로 4멤버 재이관"은 **현행 라이브에 부적합**(S1_20P 가 이미 S2 데이터 포함 → 4멤버 일괄 재이관 시 nat_key 충돌 351, 가드0가 차단). 잔여 작업은 **정합/정리**:
- (a) 정본명 규칙 정합: `COMP_PCB_S1_20P`(468행·내부 유일·0충돌) → `COMP_PCB` 재이관 + PRF_PCB_FIXED 재배선 + 4 멤버명 논리삭제.
- (b) 최소안: 재명명 생략, 고아 3멤버만 논리삭제(S1_20P 를 정본으로 수용).

**DRY-RUN** `_dryrun/mc-01-pcb-merge-dryrun.sql` = (a) 채택(정본명 규칙 정합). S1_20P 만 재이관(468·0충돌)·고아 3멤버는 중복본이라 재이관 제외·4종 논리삭제.

**골든(단가형 .01, unit_price×수량, SIZ_000003):**
| 선택 | 티어 min_qty | unit_price | comp소계 | ✓ |
|---|---|---|---|---|
| 단면·20p(OPV_000491)·qty2 | 2 | 11000.00 | 22000 | 정본(=S1_20P) 11000 ⇒ 22000 ✓ |
| 양면·30p(OPV_000492)·qty2 | 2 | 12500.00 | 25000 | 정본 12500 ⇒ 25000 ✓ |
| 단면·20p(OPV_000491)·qty2500 | 2500 | 2230.00 | 5,575,000 | 정본 2230 ⇒ ✓ |

---

## 5. 오염가드 종합 [HARD]

전 9군 공통 — 라이브 엔진(pricing.py) 계약으로 구조 증명:
1. **자기 comp 1개만 가산(교차합산 0):** 각 공식은 재배선 후 정본 1행 + 무관 bystander(별개 comp). 정본은 주문 선택으로 1행 매칭. bystander 는 별개 원가항(의도적 가산·교차 아님).
2. **silent 이중합산 불가:** 정본 후보행이 비수량 차원조합 2개 동시매칭이면 `ERR_AMBIGUOUS`(치명·차단). 멤버는 print_opt_cd(전군)·opt_cd/mat_cd(해당군)로 배타 타일링 → 단일 선택은 정확히 1조합 → 에러 없이 1행.
3. **NULL 와일드카드 과금 없음:** 9군 멤버 단가행 print_opt_cd 전부 NON-NULL(라이브 확인·NULL 0). opt_cd/mat_cd 도 해당 행에 충전. 와일드카드 누출 경로 없음.
4. **격자 무손실:** 이관 후 15열 nat_key 충돌 0(MC-02~09 라이브 확인·MC-01 은 S1_20P 내부 유일 0). 병합 전/후 각 축조합 unit_price 동일(골든 대조).

---

## 6. evaluate_price 계약 정합 체크리스트

| 계약 | 상태 | 근거 |
|---|---|---|
| 차원 자동매칭(NON_QTY_DIMS) | ✓ | print_opt_cd·opt_cd·mat_cd·siz_cd ∈ NON_QTY_DIMS(pricing.py L42) |
| 시트 차원경계(use_dims) 내 배선 | ✓ | 정본 use_dims=멤버 승계(분리축 등재). 시트 밖 축 신설 0 |
| 단가/합가/고정 구분 | ✓ | MC-01=.01 단가형·MC-02~09=.02 합가형(멤버 동일 승계) |
| 이중합산 방지 | ✓ | ERR_AMBIGUOUS 가드 + disjoint 타일링 |
| 엔진코드 무변경 | ✓ | 분리축 이미 use_dims·nat_key·NON_QTY_DIMS 등재. 코드 변경 0 |
| 물리 적재 가능성(nat_key) | ✓ | 15열 nat_key 충돌 0(라이브 확인) |

---

## 7. 실행 순서·안전 (인간 승인 후 별도)

1. 군별 DRY-RUN(`_dryrun/*.sql`) 라이브 실행 → 가드0(nat_key 충돌 0)·검증 SELECT 확인 → **ROLLBACK 로 마무리**(영속화 없음).
2. 인간 승인·webadmin 시뮬레이터 실화면(PRICE≠0·제외0·병합 전후 동일가) 확인 후, ROLLBACK→COMMIT 교체·물리 백업·undo 보유(dbm-load-execution/hbd-load-execution 트랙 위임).
3. 우선순위: MC-01(라이브 정합·최소위험) → MC-05/06/08/09(단순 print_opt_cd만·소규모) → MC-02/07(2공식) → MC-03/04(opt_cd 다축) → MC-01(a) 재명명은 별도 승인.
4. **DDL 불요**(nat_key 이미 확장·엔진 무변경). comp_nm 표시명 정비는 후속(dbm-price-arbiter).
