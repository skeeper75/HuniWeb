# 실사 견적 CPQ 옵션 레이어(L2) 설계 — round-23 Track C

> **작성** 2026-06-17 · round-23 Track C (dbm-option-mapper / dbm-cpq-option-mapping).
> **범위:** CPQ-1~5(가격영향 비기초코드 차원)를 option_groups/options/option_items + constraints + 선택→가산 배선으로 어떻게 구성할지 **설계까지**. 적재/COMMIT 안 함(이후 단계).
> **권위·안전:** 라이브 `db railway` read-only psql 실측(2026-06-17) + webadmin git read-only + arbiter 인계(dimension-basecode-verification §2·grouping-model). DB 쓰기 0·DDL 0·비밀값 비노출. 생성자≠검증자(GO는 dbm-validator).

---

## 0. 핵심 5줄

1. **L2 옵션 레이어는 라이브에 이미 부분 구현·실증됨.** 현수막(PRD_000138)·PET배너(PRD_000136)에 option_groups/options/option_items가 **BUNDLE 패턴**으로 적재돼 있어 CPQ-1·2·3의 정답 형태를 라이브가 직접 제공한다. 미적재 = 일부 상품·**선택→가산 배선(formula_components)**·제약(constraints 0건).
2. **option_items는 comp를 직접 참조하지 않는다 — 상품 차원행(proc/mat/siz/set)을 polymorphic 참조한다**(트리거 `fn_chk_opt_item_ref` 디스패치가 `t_prd_product_*` 차원테이블만 검사). 가격은 **간접**: 옵션선택 → 어떤 proc_cd/mat_cd가 활성 → 그 proc_grp/proc_cd에 키된 add-on comp(formula_components addtn_yn=Y) → 가산. **option_items에 add_price 컬럼 부재 = 가격은 항상 사슬.**
3. **BUNDLE 패턴(자재+공정) = 라이브 정답.** 한 옵션(예: 큐방추가)이 자재행(MAT+USAGE.07)과 공정행(PROC 부착)을 다중 item_seq로 묶는다. 현수막 OPV_000013(큐방)=item 1 자재.03 + item 2 공정.04. **순수 공정(열재단·타공)은 자재 없이 공정.04 단일 item.** 메모리 [[dbmap-option-material-process-bundle]] 라이브 확정.
4. **제약은 webadmin Phase10 모델 정합.** RULE_TYPE.02(금지)·.03(필수동반) + 합성차원 `sel_opts`/`sel_opt_grps` 배열 `in` 비교(`{"in":[opt_cd,{"var":"sel_opts"}]}`). 거치대 택1은 **sel_typ=SEL_TYPE.01(단일)이 구조로 강제**(별도 제약 불요)·"거치대 선택 시 우드행거 금지" 같은 교차배타만 constraints. 수량구간은 옵션 아닌 엔진(min_qty)·constraint_json(width/height 범위, RULE_001 실재).
5. **공정상세옵션 접점:** G-D1(미싱 줄수 prcs_dtl_opt 누락)·G-D2(포스터 본체 use_dims 후가공 미배선·formula_components 0행)는 **L2 옵션레이어 자체와 별개 트랙(L3 가격사슬·공정메타)**. 단 L2 옵션선택이 dim_vals(줄수)·proc_grp 단가행을 끌어오려면 둘 다 선결. 본 설계는 접점만 명시·해소는 가격트랙(인간 승인).

---

## 1. 라이브 L2 구조 사실 (재현 근거)

### 1.1 엔티티 3층 컬럼 (라이브 실측)

| 테이블 | 키 컬럼 | 핵심 컬럼 |
|--------|---------|----------|
| `t_prd_product_option_groups` | (prd_cd, opt_grp_cd) | `sel_typ_cd`(SEL_TYPE.01단일/.02다중)·`min_sel_cnt`·`max_sel_cnt`·`mand_yn`·`disp_seq`·`usr_def_nm`(표시명 오버라이드) |
| `t_prd_product_options` | (prd_cd, opt_cd) | `opt_grp_cd`·`dflt_yn`·`disp_seq`·`tags`·`usr_def_cd`(외부매핑)·`usr_def_nm` |
| `t_prd_product_option_items` | (prd_cd, opt_cd, item_seq) | **`ref_dim_cd`·`ref_key1`·`ref_key2`·`qty`** (polymorphic) |
| `t_prd_product_constraints` | (prd_cd, rule_cd) | `rule_typ_cd`·**`logic jsonb`(NOT NULL)**·`err_msg`·`disp_seq` |

### 1.2 polymorphic 디스패치 (트리거 `fn_chk_opt_item_ref` 실측)

| ref_dim_cd | 차원 | 검사 테이블 | ref_key1 | ref_key2 |
|------------|------|-------------|----------|----------|
| OPT_REF_DIM.01 | 사이즈 | t_prd_product_sizes | siz_cd | — |
| OPT_REF_DIM.02 | 판형 | t_prd_product_plate_sizes | siz_cd | — |
| **OPT_REF_DIM.03** | **자재** | t_prd_product_materials | **mat_cd** | **usage_cd**(필수) |
| **OPT_REF_DIM.04** | **공정** | t_prd_product_processes | **proc_cd** | — |
| OPT_REF_DIM.05 | 묶음수 | t_prd_product_bundle_qtys | bdl_qty(::int) | — |
| OPT_REF_DIM.06 | 도수 | t_prd_product_print_options | opt_id(::int) | — |
| OPT_REF_DIM.07 | 셋트 | t_prd_product_sets | sub_prd_cd | — |

> **HARD:** ref_key가 가리키는 차원행이 상품에 **선적재돼 있어야** 트리거 통과(FK 위상 = 차원행 먼저). 예: OPV_000013 큐방이 MAT_000337/USAGE.07를 참조하려면 PRD_000138의 t_prd_product_materials에 그 행이 존재해야 함. 부재 시 → BLOCKED(L1 선적재 필요)·코드 날조 금지.

### 1.3 라이브 실증 — 현수막(PRD_000138) L2 (정답 레퍼런스)

```
OPT_000003 가공 [SEL_TYPE.01 단일]              OPT_000004 추가 [SEL_TYPE.01 단일]
 ├ OPV_000006 열재단(Y) → 공정.04 PROC_000084     ├ OPV_000012 추가없음(Y)  → item 없음
 ├ OPV_000007 타공(4개) → 공정.04 PROC_000079      ├ OPV_000013 큐방(4개)  → 자재.03 MAT_000337/U.07 q4 + 공정.04 PROC_000081 q4
 ├ OPV_000008 타공(6개) → 공정.04 PROC_000079      ├ OPV_000014 끈(4개)    → 자재.03 MAT_000070/U.07 q4 + 공정.04 PROC_000081 q4
 ├ OPV_000009 타공(8개) → 공정.04 PROC_000079      ├ OPV_000015 각목(세로)+끈 → 자재 MAT_000338 q1 + 자재 MAT_000070 q4 + 공정 PROC_000081 q4
 ├ OPV_000010 양면테입  → 자재 MAT_000069/U.07 + 공정.04 PROC_000081   └ OPV_000016 각목(가로)+끈 → (동형 3 item)
 └ OPV_000011 봉미싱   → 자재 MAT_000340/U.07 + 공정.04 PROC_000080
```

**관찰:** ① 순수공정(열재단/타공)=공정 단일 item. ② 부속(큐방/끈/각목)=자재+부착공정 BUNDLE(다중 item_seq). ③ 같은 proc_cd(타공 PROC_000079)에 4/6/8개가 **3 옵션으로 분리**(가격이 갯수로 달라 — 단가는 COMP_POSTEROPT_*_PROC_PUNCH_4/6/8 별 comp). ④ qty가 갯수(큐방 4개=q4) 운반.

---

## 2. CPQ-1~5 구성 설계표

> 라이브 add-on 단가 = `COMP_POSTEROPT_*`(PRC_COMPONENT_TYPE.06 통가격·PRICE_TYPE.01·flat unit_price) 이미 적재. 미적재 = ① 일부 상품 option layer ② **선택→가산 배선(formula_components addtn_yn=Y)** ③ constraints.

### CPQ-1 — 배너 거치대 4택1

| 항목 | 설계 |
|------|------|
| **option_group** | `거치대구매여부` · `sel_typ_cd=SEL_TYPE.01`(단일=택1) · `mand_yn=Y`(반드시 1택) · `min_sel=1 max_sel=1`. **라이브 실재**(PRD_000136 OPT-000009 거치대구매여부 SEL_TYPE.01) |
| **options(4)** | 거치대없음(dflt_yn=Y) · 실내용거치대 · 실외용거치대(단면) · 실외용거치대(양면) |
| **option_items 참조축** | 거치대없음 → item 없음. 실내용 → **OPT_REF_DIM.03 자재**(MAT_000178/USAGE.07, 라이브 OPV-000019 실증) **또는** OPT_REF_DIM.07 셋트(거치대=완제 부속 SKU면). 실외 S1/S2 동형 |
| **선택→가산 배선** | 거치대 자재행 → 공식에 add-on comp 배선: COMP_POSTEROPT_PET_BANNER_STAND_IN(7000)/OUT_S1(23000)/OUT_S2(25000) `addtn_yn=Y`. 단가는 자재/셋트 선택 따라 분기(flat) |
| **제약(constraints)** | **불요**(SEL_TYPE.01 단일 = 택1을 구조가 강제). "없음"=dflt. 교차배타(거치대↔다른 부속 동시금지) 필요 시만 RULE_TYPE.02 |
| **BLOCKED/컨펌** | 거치대 참조축 = 자재(.03) vs 셋트(.07) — 라이브는 자재(MAT_000178=PET 본체 재사용)로 모델. 실외 S1/S2 거치대의 자재행 라이브 존재 여부 미확인 → **컨펌 C-1**. 4번째(실외양면) 옵션 라이브 부재(현재 2 options만) → 추가 필요 |

### CPQ-2 — 추가 부속(천정고리/우드행거/우드봉/끈/큐방)

| 항목 | 설계 |
|------|------|
| **option_group** | `추가` · `sel_typ_cd=SEL_TYPE.01` 또는 `.02`. 라이브 현수막=**.01 단일**(추가없음 dflt). 복수 부속 동시 가능하면 .02 다중(max_sel=N). **상품별 상이**(컨펌 C-2) |
| **options** | 추가없음(dflt) · 천정고리 · 우드행거(+면끈) · 우드봉(+면끈) · 끈(4개) · 큐방(4개). 상품군별 가용 부속 다름(족자=우드봉, 캔버스=우드행거, 배너=큐방/끈) |
| **option_items 참조축** | **BUNDLE(자재+공정)**: 부속=OPT_REF_DIM.03 자재(MAT/USAGE.07, qty=갯수) + OPT_REF_DIM.04 부착공정(PROC_000081, qty=갯수). 라이브 OPV_000013~016 실증. 우드행거/우드봉처럼 부착공정 없으면 자재 단일 item |
| **선택→가산 배선** | COMP_POSTEROPT_*_ADD_QBANG_4(3000)/ADD_STRING_4(4000)/CANVAS_HANGING_WOODHANGER(siz별 16/18/20k)/LINEN_WOODBONG(siz별 7/9.8/12k)/JOKJA_CEILHOOK(bdl_qty별 6500) `addtn_yn=Y`. **우드행거·우드봉=use_dims siz_cd**(사이즈별 단가)·천정고리=use_dims bdl_qty |
| **제약** | .01 단일이면 구조 강제. .02 다중이면 "추가없음 ↔ 다른 부속 배타"(추가없음 선택 시 나머지 금지) = RULE_TYPE.02(`{"in":["OPV_없음",{"var":"sel_opts"}]}` AND 다른 부속 in → 금지). 또는 추가없음을 옵션 아닌 "미선택"으로 |
| **BLOCKED/컨펌** | sel_typ .01 vs .02(C-2). 우드행거/우드봉의 siz_cd add-on은 본체 siz_cd와 동축이라 별 item 불요(comp use_dims가 siz로 자동 매칭)·단 본체 siz_cd가 add-on comp_prices의 siz와 일치해야(C-3) |

### CPQ-3 — 현수막 가공옵션(타공4/6/8·봉제·재단·양면테이프)

| 항목 | 설계 |
|------|------|
| **option_group** | `가공` · `sel_typ_cd=SEL_TYPE.01`(라이브 현수막=단일·열재단 dflt). 다중가공 허용 시 .02 — 라이브는 단일 |
| **options** | 열재단(dflt) · 타공(4개) · 타공(6개) · 타공(8개) · 봉미싱 · 양면테입. 메쉬/일반 상품별 가용 상이 |
| **option_items 참조축** | 순수공정 = OPT_REF_DIM.04(열재단 PROC_000084·타공 PROC_000079). 자재동반공정 = BUNDLE(양면테입=자재 MAT_000069 + 부착 PROC_000081 · 봉미싱=자재 MAT_000340 + 봉제 PROC_000080). 라이브 OPV_000006~011 실증 |
| **선택→가산 배선** | COMP_POSTEROPT_BANNER_{NORMAL,MESH}_PROC_PUNCH_4/6/8(3/4/5k)·PROC_BONGSEW(4k)·PROC_CUTEDGE(3k)·PROC_DTAPE(3k) `addtn_yn=Y`. 타공 갯수=별 comp(use_dims proc_grp:PROC_000080 — 단 PROC_PUNCH_6만 use_dims 채워짐·나머지 `[]` → **배선/차원 정합 필요 G-3 동근**) |
| **제약(JSONLogic)** | 단일(.01)이면 구조 강제. 다중 허용 시 가공 양립 제약 = RULE_TYPE.02 금지(예: 봉미싱 ↔ 타공 동시 금지): `{"!":{"and":[{"in":["OPV_봉미싱",{"var":"sel_opts"}]},{"in":["OPV_타공4",{"var":"sel_opts"}]}]}}`. 컨펌 Q-D4 |
| **BLOCKED/컨펌** | 가공 단일/다중(Q-D4)·타공 comp use_dims 불균질([] vs proc_grp) → 단가 매칭 비결정 위험(가격트랙) |

### CPQ-4 — 타이벡 하드/소프트 변형

| 항목 | 설계 |
|------|------|
| **분기 판정** | **가격 동일** → option(가격무관 택1·option_items=자재변형 OPT_REF_DIM.03 mat_cd 2종). **가격 상이** → 본체 자재 분기(별 mat_cd 또는 별 comp). 컨펌 Q-D2(가격 실측 선행) |
| **option_group** | (가격동일 가정) `재질` · sel_typ=SEL_TYPE.01 · 하드(dflt)/소프트 |
| **option_items 참조축** | OPT_REF_DIM.03 자재 — 하드 mat_cd / 소프트 mat_cd 각 1 item(USAGE 본체). **단 하드/소프트 별 자재행이 상품에 선적재돼야**(없으면 BLOCKED) |
| **선택→가산 배선** | 가격동일이면 배선 0(본체가격 불변)·가격상이면 본체 면적매트릭스 comp가 자재별 분기(COMP_POSTER_<MAT> 패턴) |
| **제약** | 불요(단일 택1) |
| **BLOCKED/컨펌** | 🔴 **타이벡 하드/소프트 자재 미등록 가능성** — 메모리 round-22 "타이벡11(하드/소프트) BLOCKED·ddl-proposer". 자재행 선적재 안 되면 option_item BLOCKED. Q-D2 가격 동일/상이 미확정 |

### CPQ-5 — 수량구간 종속(밴드)

| 항목 | 설계 |
|------|------|
| **엔티티** | **option 아님 — 엔진 + constraint_json.** 수량은 UI 자유입력(또는 구간선택)·단가행 차원 `min_qty`(상향개방)가 구간 매칭. 엔진(evaluate_price)이 qty→min_qty 등급 선택 |
| **참조축** | 없음(option_items 아님). min_qty는 component_prices 차원 |
| **선택→가산** | 직접 — 본체/add-on comp 모두 (siz_cd, min_qty) 키로 단가 조회. 수량↑ → 구간 단가↓(라이브 미니류 5구간 4/19/49/99/10000) |
| **제약(constraints)** | 수량 하한/상한/증분 = `constraint_json`. 라이브 실재 패턴(RULE_TYPE.01 PRD_000118): `{"or":[{"!=":[{"var":"size_mode"},"nonspec"]},{"and":[{">=":[{"var":"width"},200]},...]}]}`. 수량은 min/max/incr를 동형 JSONLogic으로 |
| **BLOCKED/컨펌** | 없음(엔진 기처리). 단 RULE_TYPE.01(호환)은 Phase10에서 use_yn=N으로 폐지 → **신규 제약은 RULE_TYPE.02/.03로**(기존 RULE_001 행은 .01 잔존이나 신규는 금지/필수동반 2종 + 옵션차원). 수량범위는 "필수동반"보다 엔진/UI validation이 본령 |

---

## 3. 실사 견적 L2 옵션 레이어 전체 지도 (L1 기초코드 + L2 옵션/템플릿/제약 결합)

```
[실사·배너·포스터 상품] PRD_xxx
│
├─ L1 차원행(선적재·트리거 참조 대상)
│   ├ t_prd_product_sizes        ← 가로×세로 면적매트릭스 siz_cd (A안·106 신규 채번)
│   ├ t_prd_product_processes    ← 후가공/가공 proc_cd (열재단/타공/봉제/부착/오시/미싱/귀돌이/가변/별색)
│   ├ t_prd_product_materials    ← 부속 자재 mat_cd+usage_cd (끈/큐방/각목/거치대/우드봉/우드행거)
│   ├ t_prd_product_print_options← 인쇄면/도수 opt_id (단/양면·POPT)
│   ├ t_prd_product_bundle_qtys  ← 묶음수 bdl_qty (천정고리 단가축)
│   └ t_prd_product_sets         ← 완제 부속 sub_prd_cd (거치대=SKU면)
│
├─ L2 옵션 레이어 (본 설계)
│   ├ option_groups   택1(SEL_TYPE.01): 거치대·가공·재질(타이벡) / 택N(.02): 추가부속(상품별)
│   ├ options         거치대4·가공6·추가부속N
│   ├ option_items    polymorphic ref → L1 차원행 (.03 자재 / .04 공정 / .01 사이즈 / .07 셋트)
│   │                 ★BUNDLE: 부속=자재(.03)+부착공정(.04) 다중 item_seq
│   └ constraints     RULE_TYPE.02 금지 / .03 필수동반 / 수량 constraint_json(width/height/qty 범위)
│
├─ L3 가격사슬 (별트랙·G-D2 해소 대상)
│   ├ formula_components  본체 면적매트릭스 comp + add-on comp(addtn_yn=Y) ← ★현재 POSTEROPT 0행 배선
│   └ component_prices    COMP_POSTEROPT_*(flat) + COMP_POSTER_<MAT>(siz_cd 면적) + 후가공 dim_vals
│
└─ 엔진 evaluate_price(prd, selections, qty)
    selections = {siz_cd, sel_opts[], sel_opt_grps[], proc_cd, ...} → 단가 조회 → 합산 → 최종가
```

**옵션선택 → 가격 흐름(핵심):** UI에서 옵션 선택 → 그 옵션의 option_items가 가리키는 proc_cd/mat_cd가 "활성 차원"으로 selections에 들어감 → 엔진이 그 proc_cd/proc_grp/mat에 키된 add-on comp(addtn_yn=Y)를 본체가격에 합산. **option_items 자체는 가격을 모름(add_price 부재)** — 활성차원만 운반, 가격은 comp 사슬이 결정.

---

## 4. 공정상세옵션 접점(G-D1/G-D2) 해소 방향

### G-D1 — 미싱 줄수 prcs_dtl_opt 누락 (옵션레이어 접점)

- **현상:** 오시(PROC_000029)=`{줄수 max3}` 보유·미싱(PROC_000030) EMPTY. 미싱 통합 시(grouping C-4) dim_vals.줄수 입력 UI·검증이 prcs_dtl_opt에 의존.
- **L2 접점:** 미싱이 옵션으로 노출되면(가공 그룹) option은 proc_cd(.04)를 참조하나, **줄수는 option_items가 운반 못 함**(qty는 갯수용). 줄수=dim_vals(단가행 차원). 따라서 미싱 줄수 1/2/3은 ① 옵션 3개 분리(타공 4/6/8 패턴·각 줄수가 별 옵션) **또는** ② 단일 옵션 + 별도 줄수 입력(prcs_dtl_opt 메타가 UI 그림).
- **해소 방향:** 오시와 동형 — **미싱 부모(PROC_000030)에 `{"inputs":[{"key":"줄수","max":3,"min":1,"type":"integer","unit":"줄"}]}` 설정**(상속으로 자식 086 자동). 그래야 dim_vals.줄수 입력 UI 성립. **L2 설계상 타공 패턴(줄수별 옵션 분리)이 더 단순·라이브 정합**(현수막 타공 4/6/8 = 3 옵션). 컨펌 Q-D1.

### G-D2 — 포스터 본체 comp 후가공 미배선 (가격사슬 접점)

- **현상:** COMP_POSTER_*·BANNER_NORMAL use_dims=`["siz_cd"]`만 + **POSTEROPT formula_components 0행** → 후가공/부속 add-on을 본체에 합산할 경로 부재. 실측: `t_prc_formula_components WHERE comp_cd LIKE 'COMP_POSTEROPT%'` = 0행, PRD_000136 product_price_formulas = 0행.
- **L2 접점:** L2 옵션은 잘 구성돼 있어도(현수막처럼), **선택→가산이 배선 없으면 가격 0 가산**. 즉 옵션 UI는 보이나 가격 무변동(반쪽).
- **해소 방향(가격트랙·인간 승인):** ① 배너/포스터 상품에 본체 면적매트릭스 공식(PRF_<X>) 바인딩(product_price_formulas) ② 그 공식에 POSTEROPT add-on comp들을 `formula_components addtn_yn=Y`로 배선 ③ add-on comp use_dims/proc_grp 정합(타공 comp `[]` → proc_grp 채움). 메모리 [[dbmap-price-chain-dwire-per-product-formula]] 동근(상품별 공식 PRF_<X> 1:1).
- **L2와의 순서:** option_items(차원참조)는 L1 차원행만 있으면 적재 가능(가격사슬 독립). **L2 적재 ↔ G-D2 배선은 병렬 가능하나, 견적 실효는 G-D2 선결**. L2만 적재하면 "선택 가능·가격 0가산" 상태.

---

## 5. BLOCKED / 컨펌 정직 분류

### 5.1 BLOCKED (L1 선적재·가격트랙 선결 — L2 단독 진행 불가)

| ID | 차원 | 차단 사유 | 해소 선행 |
|----|------|----------|-----------|
| B-1 | CPQ-4 타이벡 하드/소프트 자재 | 하드/소프트 별 mat_cd 라이브 미등록 가능성(round-22 BLOCKED) | t_prd_product_materials 선적재(ddl/load) |
| B-2 | CPQ-1 실외양면 거치대 옵션 | 라이브 PRD_000136 거치대 2 options만(실내·실외)·4택1 미완 | 실외 S1/S2 자재행+옵션 추가 |
| B-3 | 전 CPQ 선택→가산 | POSTEROPT formula_components 0행(G-D2) → 옵션선택해도 가격 0가산 | 본체공식 바인딩+add-on 배선(가격트랙·인간 승인) |
| B-4 | CPQ-3 미싱 줄수 | prcs_dtl_opt 부재(G-D1) → dim_vals.줄수 입력 메타 없음 | 미싱 부모 prcs_dtl_opt 설정(또는 줄수별 옵션 분리) |

### 5.2 컨펌 (설계 결정 — lead→사용자)

| ID | 컨펌 | 권고 |
|----|------|------|
| C-1 | 거치대 참조축 = 자재(.03·라이브 현행) vs 셋트(.07·완제 SKU) | 자재(.03) 유지(라이브 OPV-000019 실증·본체 PET 재사용) |
| C-2 | 추가부속 그룹 sel_typ = 단일(.01·현수막 현행) vs 다중(.02·복수부속) | 상품별 — 배너=단일(현행)·복수 동시 필요시만 .02 |
| C-3 | 우드행거/우드봉 siz_cd add-on 단가 = 본체 siz 동축 자동매칭 | comp use_dims siz_cd가 본체 siz와 일치 검증(별 item 불요) |
| Q-D1 | 미싱 줄수 = 줄수별 옵션 분리(타공 패턴) vs prcs_dtl_opt+dim_vals | 옵션 분리(라이브 타공 정합·단순) |
| Q-D2 | 타이벡 하드/소프트 가격 동일/상이 | 가격 실측 후 분기(동일→option·상이→자재/comp) |
| Q-D4 | 가공 그룹 단일/다중 + 양립 제약 | 단일(현수막 현행)·다중시 RULE_TYPE.02 금지 |

### 5.3 즉시 설계 가능 (BLOCKED 아님)

- CPQ-1·2·3의 **option_groups/options/option_items 구조**는 라이브 현수막/배너 패턴 복제로 즉시 설계(L1 차원행 존재 상품 한정). 미적재 상품(메쉬현수막 139 등)에 동형 확장.
- 제약 JSONLogic 템플릿(RULE_TYPE.02/.03·sel_opts in)은 webadmin Phase10 계약·라이브 RULE 행으로 즉시 작성 가능.

---

## 6. read-only 준수

- 라이브 SELECT만(option 3층 컬럼·트리거 디스패치·SEL_TYPE/RULE_TYPE/OPT_REF_DIM 코드값·POSTEROPT 20 comp·현수막/배너 L2 실증·formula_components 0행·proc/mat 명·constraints RULE 행). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- webadmin Phase10 SUMMARY(데이터계약 sel_opts/sel_opt_grps·RULE_TYPE.01 폐지) read-only.
- **설계까지** — option/template/constraint 실 적재·formula 배선·prcs_dtl_opt 설정은 이후 단계(인간 승인). GO는 dbm-validator 독립 게이트.
```