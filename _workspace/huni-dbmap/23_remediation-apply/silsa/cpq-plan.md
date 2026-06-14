# 실사 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_options`(opt_cd) → `t_prd_product_option_items`(item_seq·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행(자재/공정) 미선적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM):** .01사이즈·.02판형·.03자재·.04공정·.05묶음수·.06도수·.07셋트.
> **[HARD·트리거] fn_chk_opt_item_ref(sql/10_phase7_ddl.sql:189):** option_items INSERT/UPDATE 시 ref_dim_cd별로 대상 차원행 존재 검증 — .03자재면 `t_prd_product_materials(prd,mat_cd,usage_cd)`·.04공정이면 `t_prd_product_processes(prd,proc_cd)` 존재 필수. **이게 선적재 의존성의 근거.**

---

## 1. 실사 CPQ 선례 — 일반현수막(PRD_000138)이 유일 적재 (2026-06-14 실측)

실사 28상품 중 **일반현수막만** CPQ 적재됨(option_groups 3·option_items 18·나머지 27상품 0). 이 선례가 실사 부속/가공 옵션의 정답 패턴이다.

| 옵션그룹 | sel_typ | 항목 구조(실측) |
|----------|---------|----------------|
| 각목추가(OPT-000002) | 택1(필수) | 각목 = 자재(MAT_000338) + 면끈 자재(MAT_000070) + 부착 공정(PROC_000081) **묶음** |
| 가공(OPT_000003) | 택1(필수) | 타공/봉제 = 공정(PROC_000079/080) |
| 추가(OPT_000004) | 택1(선택) | 양면테입(MAT_000069)+부착, 봉제사(MAT_000340)+봉제, 끈(MAT_000070)+부착 |

> **핵심 = 한 옵션 항목이 자재+공정 BUNDLE**(round-12 교훈: 아일렛=금속링 자재+타공 공정). item_seq로 여러 ref_dim을 묶는다. 이 패턴을 부속 5상품·봉제/족자 5상품에 동형 적용.

---

## 2. 실사 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 | finding |
|------|-----------|------------------|------------|---------|
| 부속(거치대/봉/고리/행거) | 캔버스행잉(133)·린넨우드봉족자(134)·족자포스터(135)·PET배너(136)·메쉬배너(137) | addon=0·sets=0·부속소재 자재슬롯 미연결 | **option_group(택1) + option_items(자재+필요시 공정)** | S-08 |
| 봉제 세부 | 린넨패브릭(124)·캔버스패브릭(125)·캔버스행잉(133)·린넨우드봉족자(134) | 봉제 PROC_000080 1행만(세부 variant 없음) | option_group(택1·오버로크/말아박기/봉미싱+리본끈/면끈) | S-06 |
| 족자 모양 | 족자포스터(135)·린넨우드봉족자(134) | 족자제작 PROC_000082 1행만 | option_group(택1·사각/원형) | S-06 |
| 보드가공 | 폼보드(129)·포맥스보드(130)·미니보드스탠딩(144) | 공정 0행(마스터 부재) | option_group — **공정 마스터 신설 선행** | S-07·BLOCKED |
| 액자 | 프레임리스(131)·레더아트액자(132) | 코팅만/0행 | 공정(액자가공) vs 부속 — **귀속 미정** | S-14·BLOCKED |
| 코팅(유광/무광) | 코팅 8상품 | print 공정 2행 적재됨 | (적재 완료 — CPQ 불요) | S-05 ✅ |

---

## 3. 부속 거치대 — option_items(자재+공정 묶음) (S-08 · Q-SL-4)

**문제:** 캔버스행잉=우드행거, 린넨우드봉족자=우드봉, 족자포스터=천정고리, PET/메쉬배너=우드거치대를 "출력물 + 부속" 세트로 판매. 라이브 addon=0. `t_prd_product_addons`는 tmpl_cd NOT NULL인데 부속 상품 template 0건 → **addon 경로 불가**. 일반현수막 선례대로 **option_items(자재 ref) 경로**가 정답.

**부속 소재 search-before-mint (2026-06-14 실측 — 전수 실재·악세사리 MAT_TYPE.10):**

| 부속 | 소재코드 | 비고 |
|------|----------|------|
| 우드행거 | MAT_000229 | 캔버스행잉(133) |
| 우드봉 | MAT_000225 (+ 270/360/480mm 변형 MAT_000224/226/227/228) | 린넨우드봉족자(134)·길이 variant |
| 천정고리 | MAT_000215 | 족자포스터(135) |
| 우드거치대 | MAT_000223 | PET배너(136)·메쉬배너(137) |

**설계(캔버스행잉 133 기준):**

```
[선행·기초데이터] t_prd_product_materials: (PRD_000133, MAT_000229 우드행거, USAGE.07) INSERT
   ← 트리거 fn_chk_opt_item_ref(CASE .03) 선행조건. 이게 없으면 option_items INSERT가 EXCEPTION.
[option_group] OG-133-MOUNT (거치선택)
   sel_typ_cd=택1(SEL_TYPE.01) · mand_yn=N (출력만=옵션 미선택 기본)
[option] OPT-133-WOODHANGER
[option_items]
   item1: ref_dim_cd=OPT_REF_DIM.03(자재) · ref_key1=MAT_000229 · ref_key2=USAGE.07 · qty=1
```

**L1 선적재 의존성(BLOCKED 점검):**
- 부속 소재(229/225/215/223)는 마스터 실재(✅). 그러나 **각 상품 t_prd_product_materials 슬롯에 미연결**(현재 자재슬롯엔 본체소재만) → **트리거 무결성상 option_items 적재 전 선행 자재 INSERT 필수**.
- 우드봉 길이 variant(270/360/480mm)는 사이즈 매칭 constraint 가능(아래 §5).

> **결론:** 부속 CPQ는 ① 부속 소재의 상품 자재슬롯 선행 연결(apply.sql 컨펌블록 S-08 §0) ② Q-SL-4 컨펌 후 적재. 선행 미충족 = L1 선적재 BLOCKED(데이터, ddl 아님).

---

## 4. 봉제/족자 세부 — option_group(택1) (S-06 · Q-SL-2)

**문제:** 봉제(PROC_000080)·족자제작(PROC_000082) 부모 공정은 라이브 연결됨(✅). 그러나 세부 variant — 봉제 5종(오버로크/말아박기/봉미싱7cm+리본끈/면끈)·족자 사각/원형 — 가 단일 공정행으로 평면화됨. 세부값을 담을 칸이 부재.

**설계(린넨패브릭 124 기준):**

```
[기초데이터] t_prd_product_processes: (PRD_000124, PROC_000080 봉제) ← 이미 연결됨 ✅
[option_group] OG-124-SEW (봉제방식)
   sel_typ_cd=택1 · mand_yn=Y
[option_items] ref_dim_cd=OPT_REF_DIM.04(공정) · ref_key1=PROC_000080 · (세부값은?)
   오버로크 / 말아박기 / 봉미싱7cm+리본끈 / 면끈
```

**적재처 결정(Q-SL-2):**
- (a) **CPQ option_items의 ref_key2 또는 opt_nm에 세부명 문자열**(권장 — 신규 테이블 0). 단 ref_key2는 자재 usage_cd 용도라 의미 충돌 가능 → opt(t_prd_product_options)의 opt_nm으로 variant 구분.
- (b) 봉미싱+리본끈처럼 부속이 붙는 변형은 **자재+공정 묶음**(리본끈 자재 ref 추가) — 일반현수막 각목 패턴 동형.
- (c) `prcs_dtl_opt` 신규 테이블(ddl) — 정식 공정 세부옵션 모델.

> **L1 선적재 BLOCKED 아님:** 봉제/족자 부모 공정 실재 → 공정 ref 옵션은 즉시 설계 가능. 세부 variant 적재처만 결정 대기(디지털 Q-DP-D와 동형).

---

## 5. 우드봉 길이 매칭 — constraint (선택·Q-SL-4 부속)

린넨우드봉족자(134)는 출력 사이즈에 따라 우드봉 길이(270/360/480mm)가 매칭. 단순 옵션으로는 "어느 사이즈에 어느 봉"인지 표현 못 함 → constraint.

```
[constraint] CON-134-RODMATCH
   rule_typ_cd=캐스케이드(사이즈→우드봉)
   logic: {"==":[{"var":"siz_cd"},{"var":"rod.match_siz"}]}
   err_msg: "선택한 사이즈에 맞는 우드봉 길이만 선택 가능합니다"
```

> **선행:** 우드봉 길이 variant 소재(MAT_000224/226/227/228)를 자재슬롯에 선행 연결해야 option/constraint 적재 가능. 현재 미연결 → BLOCKED. (정확한 사이즈-봉 매핑표는 L1 추가 컬럼 재확인 후·Q-SL-4).

---

## 6. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 봉제 세부(124/125/133/134) | 봉제 PROC_000080 실재 | 부분 | 세부 variant 적재처(Q-SL-2) |
| 족자 모양(134/135) | 족자 PROC_000082 실재 | 부분 | 사각/원형 적재처(Q-SL-2) |
| 부속 거치대(133/134/135/136/137) | 부속소재 마스터 실재·**자재슬롯 미연결** | **BLOCKED** | 부속소재 자재슬롯 선행 INSERT(트리거) + Q-SL-4 |
| 우드봉 길이매칭(134) | 길이 variant 소재 실재·미연결 | **BLOCKED** | 자재슬롯 선행 + 매핑표 확인 |
| 보드가공(129/130/144) | 공정 마스터 0건 | **BLOCKED** | 보드마운팅 공정 신설(Q-SL-3·ddl) |
| 액자(131/132) | 코팅만/0행·귀속 미정 | **BLOCKED** | 액자=공정 vs 부속 결정(Q-SL-4) |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(부속소재 자재슬롯·보드마운팅 공정) 선적재 ② Q-SL-2/3/4 컨펌 후 인간 승인. **트리거 fn_chk_opt_item_ref 무결성상 자재/공정 차원행 선적재가 모든 option_items의 전제** — L1 선적재 BLOCKED 4건(부속·우드봉·보드가공·액자) 정직 표기.
