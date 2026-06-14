# 스티커 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_option_items`(opt_cd·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종 실측):** .01 사이즈·.02 판형·.03 자재·.04 공정·.05 묶음수·.06 도수·.07 셋트.

---

## 1. 스티커 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 | BLOCKER |
|------|-----------|------------------|------------|---------|
| 합판도무송 형상=칼틀 | 066 | size 37행 적재(siz_nm에 형상+치수 인코딩·Q7) | **CPQ 불요 — size가 칼틀 1:1** | 없음(CORRECT) |
| 규격형 형상(원형/정사각/직사각/띠지/팬시) | 058~062 | 공정 1행(스티커완칼·모양 param 없음) | **option_group(택1) + option_items(형상)** | 형상 param 적재처 부재(OM-7) |
| 코팅(무광/유광) | 052·058~062·064·066 (8) | 자재 2종 연결 | **option_group(택1·코팅) OR 자재 유지** | Q9 vs L1/라이브/가격 CONFLICT |
| 화이트 별색(택1) | 063(화이트인쇄 단면/없음) | 공정 0행→S-02로 1행 보충 | **option_group(택1) — 화이트 적용/미적용** | 없음(즉시적용 후) |
| 조각수 | 052·055·056·057·064 | 0행(066만 형상별 EA) | **묶음수(bundle) + 공정 param(Q8 둘 다)** | param 적재처 부재(OM-7) |
| 커팅(반칼/완칼) | 052~066 | 공정 1행(mand=N) | **필수 공정(option 아님) — 정체** | mand 필수성 Q-ST-G |
| 스티커팩 세트 | 065 | sets 0행 | **template/sets(세트 구성)** | 구성품 불명(L1 미명시) |

---

## 2. 합판도무송 형상 = 칼틀 size 1:1 (Q7 — CPQ 불요)

**핵심(메모리 권위·실무진 Q7★):** 합판도무송(066)의 형상은 **size로 표현**(`정사각30x30mm(2EA)`·`직사각35x25mm(2EA)`·`원형30x30` 등 siz_nm 인코딩, 37행). 형상별 칼틀이 size 1:1로 대응하고 칼선은 자동 도출. 공정엔 "도무송(스티커완칼)" 1줄만.

> **CPQ 레이어 불요·CORRECT 유지.** round-11 "형상 size 흡수=오모델 의심"은 round-12 Q7 + 가격표 형상×사이즈 격자로 **반증·종결**. 라이브 size 37행이 정답 — **기계적 size 삭제 절대 금지**(round-10 교훈: size 삭제 시 칼틀·가격사슬 파손). S-03 빈 옵션그룹(OPT-000004 "원형")은 이 size 표현과 **중복**이라 논리삭제(즉시적용).

---

## 3. 규격형 058~062 형상 — option_group(택1) + option_items (Q-ST-C 귀속)

**문제:** 규격형 058~062(반칼원형/정사각/직사각/띠지/팬시)는 PROC_000055 스티커완칼(공정 마스터 `prcs_dtl_opt={조각수}`·모양 param 없음)에 연결. 형상(원형/정사각 등)이 **size에도(058 size=A4/A5 규격뿐) prcs_dtl_opt(공정 마스터 레벨이지 상품 레벨 아님)에도 product 레벨에 없음** → 형상이 어디에도 안 들어감.

**합판도무송(066)과 대조:** 066은 형상을 size로 흡수(칼틀=size·Q7). 규격형은 "같은 형상 family인데 자유 치수 안에서 모양 선택"이라 size로 흡수 불가 → 공정 옵션이 맞음.

**설계(반칼정사각 059 기준):**
```
[기초데이터] t_prd_product_processes: (PRD_000059, PROC_000054 반칼) — 모양 param 보유 공정으로 교체 검토
[option_group] OG-059-SHAPE (모양)
  sel_typ_cd=택1 · mand_yn=Y
  [option_items] ref_dim_cd=OPT_REF_DIM.04(공정) · ref_key1=형상값
    정사각(또는 family에 따라 원형/직사각/띠지/팬시)
```

**적재처 결정(Q-ST-C):**
- (a) **CPQ option_items의 ref_key1에 형상명 문자열** 저장(신규 테이블 0·polymorphic 활용).
- (b) `ref_param_json`/`prcs_dtl_opt` **상품 레벨** 신규 컬럼(ddl) — 공정 세부옵션 정식 모델(OM-7 해소).
- (c) 합판식 siz_nm 인코딩 통일.

> **L1 선적재 부분 BLOCKED:** PROC_000054 반칼(모양 param 보유) 마스터 실재 → 공정 교체는 가능. 단 **형상 param 적재처(상품 레벨)가 부재**(OM-7) → ddl-proposer 선결. Q-ST-C 컨펌 대기.

---

## 4. 코팅 — option_group(택1) vs 자재 유지 (Q-ST-A·CONFLICT-1 귀속)

**문제:** 코팅 쓰는 8상품(052·058~062·064·066)에 무광/유광코팅스티커가 **자재**로 연결. 실무진 Q9★=코팅 공정. 그러나 **L1 원본도 코팅을 종이칸의 자재 variant로 인코딩(코팅 옵션칸 전 행 빈값·2026-06-14 실측)**·가격표는 비코팅/무광/유광 3컬럼(코팅별 단가)·round-11 §44=자재 variant 정당. → **3소스(L1/라이브/가격) vs Q9 충돌·미해소.**

**설계(2안 — 컨펌):**
- **(a) 코팅=공정(Q9):** PROC_000013 코팅을 8상품 공정 연결 + 비코팅 자재로 정정 + 코팅 공정 단가를 가격엔진에. CPQ option_group(택1: 비코팅/무광/유광)으로 표면처리 선택.
- **(b) 코팅=자재 유지:** L1/가격모델 일치. CPQ option_group(택1)이 코팅 자재 variant를 ref_dim_cd=OPT_REF_DIM.03(자재)로 참조.

```
[option_group] OG-052-COAT (표면처리)
  sel_typ_cd=택1 · mand_yn=N
  [option_items] ref_dim_cd=자재(.03) 또는 공정(.04) — Q-ST-A 결과에 따라
    비코팅 / 무광코팅 / 유광코팅
```

> **권장 보류:** Q9 권위(권위순서 1위)이나 L1·가격·라이브 3중 일치가 강함 → **CONFLICT 정직 표기·컨펌(Q-ST-A).** 어느 안이든 CPQ는 택1 option_group으로 동일하게 표현 가능(ref_dim_cd만 .03/.04 차이) — 그릇은 준비됨, 귀속만 미결.

---

## 5. 스티커팩(065) 세트 — template/sets (Q-ST-E 귀속)

**문제:** 스티커팩=여러 스티커 시트째 묶음 세트(product-bom §14). 라이브 sets 0행. **구성품(어떤 스티커가 몇 장)이 L1에 명시 없음.**

**설계:**
```
[기초데이터] t_prd_product_sets: (PRD_000065, sub_prd_cd=구성 스티커, qty) — 구성 데이터 필요
```

> **L1 선적재 BLOCKED:** 팩 구성품 데이터 부재 → 세트 적재 불가. Q-ST-E(구성품 정의 vs 단일 시트 상품) 컨펌 대기.

---

## 6. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 합판형상=size(066) | size 37행 실재 | ✅ CPQ 불요 | 없음(CORRECT·Q7) |
| 화이트 별색(063) | S-02로 공정 1행 보충(즉시적용) | ✅ 가능 | 없음 |
| 규격형 형상(058~062) | 반칼 모양 param 공정 실재 | 부분 | 형상 param 적재처(OM-7)·Q-ST-C |
| 코팅(8상품) | 자재 2종 실재(공정 PROC_000013도 실재) | ✅ 그릇 준비 | 귀속 CONFLICT·Q-ST-A |
| 조각수 | 0행(066만) | 부분 | param 적재처(OM-7)·Q-ST-B |
| 스티커팩 세트(065) | sets 0행 | **BLOCKED** | 팩 구성품 데이터·Q-ST-E |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(공정·형상 param) 선적재 ② Q-ST-A/B/C/E 컨펌 후 인간 승인. L1 선적재 BLOCKED 1건(스티커팩 세트 구성)·부분 BLOCKED 2건(규격형 형상·조각수 param=OM-7) 정직 표기. 합판형상=size(Q7)는 CPQ 불요로 CORRECT 유지 — 트리거(fn_chk_opt_item_ref 무결성)는 형상 옵션 적재 시 ref_dim_cd=.04(공정) FK 정합 준수.
