# rc2-confirm-resolved-load-spec.md — RC-2 CONFIRM 확정 3건 적재 명세 (린넨마감·타공·족자)

> dbm-option-mapper · 2026-06-23 · §21 RC-2. 라이브 읽기전용 SELECT·DB 미적재·단가 verbatim·search-before-mint·날조 0.
> 대상 = **CONFIRM-B 린넨마감(CLOSED)** · **CONFIRM-A 타공(데이터 정리)** · **CONFIRM-C 족자(opt_cd 재배선)**.
> ★**각목(CONFIRM-4)은 본 명세 범위 밖** — 별도 에이전트 재정립 중. 본 명세는 GAKMOK comp/단가행/옵션을 일절 건드리지 않음.
> 권위[HARD]: silsa-l1(260610) · 라이브 t_prc_component_prices verbatim. 엔진[HARD]: pricing.py `_row_matches`(line82-94)·공정 comp eval(line583-589).
> ★생성자(option-mapper)≠검증자 — 본 명세 GO 비준은 dbm-validator 독립 게이트. 실 COMMIT은 인간 승인 후 dbm-load-execution.
> 라이브 실측 일시: 2026-06-23. 단가 전부 verbatim(0 변경). 산출 위치 = `03_cpq_link/`만(04_price_engine 미수정).

---

## 0. 라이브 실측으로 확정된 기준 사실 (근거 SQL 포함)

### 0.1 엔진 가격 메커니즘 (pricing.py 코드 실측·재확인)
- **단가행 매칭 = `_row_matches`**(line82-94): `NON_QTY_DIMS=("siz_cd","plt_siz_cd","print_opt_cd","mat_cd","proc_cd","opt_cd","bdl_qty"…)` 정확매칭 + `dim_vals`(예 `{타공수:N}`) 정확매칭. **행 차원이 None이면 와일드카드(always-match)**(line87-88) — 빈 차원 = silent always-add 결함. **dim_vals 키는 와일드카드 없음**(line92-94 — selections에 그 키가 있어야만 매칭).
- **미선택 0가산 보장 원리**: 단가행 판별차원(proc_cd/opt_cd)을 NULL이 아닌 실제값으로 채우면, 미선택 시 selections에 그 키 부재 → `_norm(None)≠_norm(실제값)` → False → row=None → **가산 0**. 빈 use_dims/NULL 차원 = always-add 제거의 핵심.
- **공정 comp 평가**(line583-589): 호출자 `proc_sels=[{proc_cd, detail}]`마다 `sel["proc_cd"]=proc_cd` + `detail` 키 병합 → 단가행 `proc_cd`+`dim_vals{타공수:N}` 매칭. **타공수는 호출자 detail→단가행 dim_vals 경로로만** 매칭(데이터만으론 미작동·코드 동반).

### 0.2 폴리모픽 트리거 `fn_chk_opt_item_ref` dispatch (라이브 실측 — 함수 본문)
- OPT_REF_DIM.03 자재 → `t_prd_product_materials(mat_cd=ref_key1 AND usage_cd=ref_key2)` 둘 다 검증.
- OPT_REF_DIM.04 공정 → `t_prd_product_processes(proc_cd=ref_key1)`.
- option_item이 **존재하면** ref 차원행이 그 prd_cd에 등록돼 있어야 함(없으면 EXCEPTION). → 환원행은 차원행 등록분만 추가, 미등록=HOLD(가격 무영향·MES 환원 보강).

### 0.3 base codes (라이브 실측)
- `SEL_TYPE.01`=단일(택1) / `SEL_TYPE.02`=다중. `OPT_REF_DIM.03`=자재·`.04`=공정·`.05`=묶음수.

### 0.4 opt_cd 채번 (라이브 실측 MAX+1)
- `SELECT MAX(opt_cd) FROM t_prd_product_options WHERE opt_cd ~ '^OPV_[0-9]{6}$';` → **OPV_000430**(rc2-addon-spec 적재 OPV_000425/426/429/430 실재 확인).
- → 신규 천정고리 = **OPV_000431** (충돌 확인: `SELECT count(*) WHERE opt_cd='OPV_000431'`=0).

---

## 1. CONFIRM-B 린넨마감 — CLOSED (재배선 0·바인딩만)

### 1.1 라이브 실측 결과 (재배선 불요 확정)
| 측정 | 결과 | 근거 SQL |
|---|---|---|
| LINEN_FINISH 단가행 5행 | opt_cd=OPV_000025(0)·OPV-000024(800)·OPV_000026(1000)·OPV_000424(2000)·OPV_000027(2000), proc_cd=PROC_000080(봉제), siz/mat/bdl/dim_vals 전부 NULL | `t_prc_component_prices WHERE comp_cd LIKE '%LINEN_FINISH%'` (id 22341~22345) |
| comp use_dims | `["opt_cd","min_qty"]` (이미 정합·충전 불요)·prc_typ=PRICE_TYPE.01·use_yn=Y·del_yn=N | `t_prc_price_components` |
| 124 린넨패브릭 옵션 (OPT_000009) | OPV_000025 오버로크·OPV_000026 말아박기·OPV_000027 봉미싱(7cm)·OPV-000024 오버로크+리본끈·OPV_000424 말아박기+면끈 | `t_prd_product_options WHERE prd_cd='PRD_000124'` |
| **opt_cd 1:1 정합** | 단가행 5 opt_cd = 124 옵션 5개와 **정확 일치**(dash형 OPV-000024 포함) → **재배선 0** | 대조 |
| 124 본체 공식 | **PRF_POSTER_LINEN** (기존 바인딩=COMP_POSTER_LINEN_FABRIC disp_seq=1 1건만) | `t_prd_product_price_formulas` / `t_prc_formula_components` |
| LINEN_FINISH 바인딩 | **0건** (미바인딩) → 추가 필요 | `t_prc_formula_components WHERE comp_cd LIKE '%LINEN_FINISH%'` |
| 권위 엑셀(124) | 린넨패브릭(ID 14569): 오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱(7cm) 5종·가공가격 별도행 → 라이브 단가행 5종과 정합 | silsa-l1.csv |

**판정**: 설계 문서의 "단가행 opt_cd가 상품 옵션과 불일치"는 **오판**. 재배선 불필요. 남은 작업 = **공식 바인딩 1건만**.

### 1.2 캔버스패브릭(125) 동형 여부 — 라이브 실측 결과: **비동형**
| 측정 | 결과 | 근거 |
|---|---|---|
| 125 본체 공식 | **PRF_POSTER_CANVAS** (PRF_POSTER_LINEN 아님) | `t_prd_product_price_formulas WHERE prd_cd='PRD_000125'` |
| 125 옵션 (OPT_000010) | **OPV_000028 오버로크 1개뿐** (말아박기·봉미싱 없음) | `t_prd_product_options WHERE prd_cd='PRD_000125'` |
| LINEN_FINISH 단가행에 OPV_000028 | **없음** (단가행 opt_cd 5개에 OPV_000028 미포함) | 대조 |
| 권위 엑셀(125) | 캔버스패브릭(ID 14570): 가공="오버로크"만·가공가격 **공란**(별도 마감비 행 없음) | silsa-l1.csv |

**판정**: 125는 124와 **비동형**. 마감 옵션 1종(오버로크)·LINEN_FINISH 단가행 부재·권위 가공가격 공란 → **125 마감비 적재할 단가 없음**. **125는 본 명세 범위 밖·미적재**(단가 없으면 날조 금지). → §4 HOLD-125.

### 1.3 린넨마감 배선표 (바인딩 1건만)
| comp | 대상 frm_cd | use_dims 충전 | 단가행 충전/재배선 | 공식 바인딩 (addtn_yn·disp_seq) |
|---|---|---|---|---|
| `COMP_POSTEROPT_LINEN_FINISH` | **PRF_POSTER_LINEN** | **유지** `["opt_cd","min_qty"]` (충전 0) | **유지** (opt_cd 5행 124 정합·단가 0/800/1000/2000/2000 verbatim·재배선 0) | **Y · disp_seq=2** (기존 MAX=1) |

> 미선택 0가산: 단가행 opt_cd가 이미 124 옵션 5개로 채워짐 → 마감 미선택(opt_cd 부재) 시 row=None → 가산 0. **always-add 없음**(이미 가드됨).

---

## 2. CONFIRM-A 타공 — 데이터만 정리 (코드 트랙 별도·§21 범위 밖)

### 2.1 라이브 실측 결과
| 측정 | 결과 | 근거 SQL |
|---|---|---|
| 일반현수막(138) 타공 단가행 | `COMP_..._PROC_PUNCH_4`: 1 comp·3행·**proc_cd=PROC_000105**·dim_vals{타공수:4/6/8}=3000/4000/8000 (id 38219/38220/38221) | `t_prc_component_prices LIKE 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH%'` |
| 일반 좀비 | `PUNCH_6`(id 4695·4000)·`PUNCH_8`(id 4697·5000): proc_cd/dim_vals 전부 NULL·comp **del_yn=Y** | 동상 + `t_prc_price_components` |
| 일반 PUNCH_4 use_dims | `["proc_cd","min_qty","proc_grp:PROC_000104"]` (이미 부모 104 표시) | `t_prc_price_components` |
| 일반 옵션 환원 | OPV_000007/008/009(타공 4/6/8·OPT_000003 그룹) 전부 `OPT_REF_DIM.04 ref_key1=`**PROC_000104**·ref_key2 NULL·**qty NULL**(타공수 구분 없음) | `t_prd_product_option_items WHERE prd_cd='PRD_000138'` |
| 일반 PUNCH_4 바인딩 | **PRF_POSTER_BANNER_N·addtn_yn=Y·disp_seq=2** (이미 바인딩됨·추가 불요) | `t_prc_formula_components` |
| 메쉬현수막(139) 타공 단가행 | `MESH_PROC_PUNCH_4/6/8`: **3 comp 각 1행**·proc_cd/dim_vals **전부 NULL**·3000/4000/5000 (id 4750/4752/4754) | `t_prc_component_prices LIKE 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH%'` |
| 메쉬 use_dims | PUNCH_4=`[]`·PUNCH_8=`[]`·PUNCH_6=`["proc_cd","min_qty","proc_grp:PROC_000080"]` (셋 다 del_yn=N·좀비 아님) | `t_prc_price_components` |
| 메쉬 옵션 환원 | OPV_000042/043/044(타공 4/6/8·OPT_000022 그룹) 전부 `ref_key1=`**PROC_000079**·qty=1 | `t_prd_product_option_items WHERE prd_cd='PRD_000139'` |
| 메쉬 타공 바인딩 | **0건** (PRF_POSTER_BANNER_M에 메쉬 타공 미바인딩·현재 본체+QBANG+STRING만) | `t_prc_formula_components` |
| 공정 정체 | PROC_000104 현수막타공(부모·prcs_dtl_opt inputs[타공수 min0 max8]·del_yn=N) / PROC_000105(자식 upr=104·inputs 없음·del_yn=N) / PROC_000079 타공(부모·inputs[구수 min1 max8]·del_yn=N) / PROC_000103(자식 upr=079·**del_yn=Y 좀비**) | `t_proc_processes` |

**진단**: ① 일반 단가행 proc_cd=**PROC_000105** ↔ 옵션환원=**PROC_000104** → 어긋남. ② 메쉬 단가행 proc_cd=**NULL**(always-add) ↔ 옵션환원=**PROC_000079**. ③ 일반·메쉬 옵션 모두 타공수 detail(ref_key2/qty)을 안 보냄 → 데이터만으론 타공수별 미작동.

### 2.2 타공 데이터 정리 배선표 (부모 proc_cd 통일 + dim_vals 충전 + 바인딩)

**원칙(결정)**: 단가행 proc_cd를 부모(일반 PROC_000104·메쉬 PROC_000079)로 통일 + use_dims 판별차원(proc_cd+타공수 dim_vals) 충전 + addtn_yn=Y 바인딩. **빈 use_dims always-add 제거(미선택 0가산 보장)**. 실제 타공수별 가산은 위젯 코드 동반 후 작동.

| comp | 대상 frm_cd | proc_cd 통일 | dim_vals 충전(타공수) | use_dims 충전 | 단가 verbatim | 공식 바인딩 |
|---|---|---|---|---|---|---|
| 일반 `COMP_..._PROC_PUNCH_4` (3행) | PRF_POSTER_BANNER_N | id38219/38220/38221: **PROC_000105→PROC_000104** | 유지 {타공수:4/6/8} | 유지 `["proc_cd","min_qty","proc_grp:PROC_000104"]` | 3000/4000/8000 (불변) | **이미 바인딩됨**(disp_seq=2·추가 불요) |
| 메쉬 `MESH_PROC_PUNCH_4` (id 4750) | PRF_POSTER_BANNER_M | **NULL→PROC_000079** | **충전 {타공수:4}** | `[]`→`["proc_cd","min_qty","proc_grp:PROC_000079"]` | 3000 (불변) | **Y·disp_seq=4** (기존 MAX=3) |
| 메쉬 `MESH_PROC_PUNCH_6` (id 4752) | PRF_POSTER_BANNER_M | **NULL→PROC_000079** | **충전 {타공수:6}** | 유지 변경 `proc_grp:PROC_000080`→`PROC_000079` (proc_grp 토큰=표시용·매칭 무관·정합 위해 정정) | 4000 (불변) | **Y·disp_seq=5** |
| 메쉬 `MESH_PROC_PUNCH_8` (id 4754) | PRF_POSTER_BANNER_M | **NULL→PROC_000079** | **충전 {타공수:8}** | `[]`→`["proc_cd","min_qty","proc_grp:PROC_000079"]` | 5000 (불변) | **Y·disp_seq=6** |
| 일반 좀비 `PUNCH_6`/`PUNCH_8` (id 4695/4697) | — | — | — | comp **use_yn=N** (del_yn 이미 Y·always-add 좀비 차단) | — | 바인딩 0 (그대로) |

**메쉬 모델링 주의 (3 comp 유지 vs 1 comp 통합)**:
- 라이브 = 메쉬 PUNCH_4/6/8 **3 comp** 분리(각 1행·단가 다름). 일반 = 1 comp 3행(dim_vals).
- 설계(rc2-silsa-addon-binding-design ②표)는 "메쉬 1 comp 통합" 권고였으나, **본 명세는 데이터 최소 변경 = 3 comp 유지**(comp 삭제/병합은 가격사슬 위험·바인딩 3건). 3 comp 각각 proc_cd+dim_vals 충전으로 동일 결과(선택 타공수만 가산·미선택 0). **1 comp 통합은 별 트랙 권고(comp 병합=공유자원 변경·HOLD)**.
- ★타공수 매칭 키 충돌 주의: 3 comp가 같은 proc_cd(PROC_000079)+다른 dim_vals(4/6/8)를 가지므로, 위젯이 procs=[{proc_cd:PROC_000079, detail:{타공수:N}}] 전송 시 **타공수에 맞는 1 comp의 1행만 매칭**(나머지 comp 행은 dim_vals 타공수 불일치→가산 0). 단일 매칭 보장.

### 2.3 ★타공 데이터 트랙 한계 (정직 명시 — [HARD])
- **데이터만으론 타공수별 미작동**: 단가행에 proc_cd+dim_vals{타공수:N}를 채워도, 옵션 환원(option_item)은 타공수 detail(ref_key2/qty)을 안 보낸다. 엔진은 호출자 `procs=[{proc_cd, detail:{타공수:N}}]`로만 dim_vals 매칭(line583-589·dim_vals 와일드카드 없음).
- **위젯 코드 동반 필요(§6/webadmin·§21 범위 밖)**: 위젯/프론트가 타공 옵션(OPV_000007/8/9·OPV_000042/3/4) 선택→타공수 추출→`procs=[{proc_cd:부모코드, detail:{타공수:4/6/8}}]` 조립 전송. 이게 없으면 데이터만으론 0가산 또는 매칭 실패.
- **미선택 0가산은 데이터로 보장**: 타공 미선택 시 procs에 해당 proc 없음 → row=None → 가산 0. 빈 차원(always-add) 제거가 데이터 트랙의 확정 성과. **과대청구(always-add) 차단 = 데이터로 완결**.
- **부모 proc_cd 통일 근거**: 부모(104/079)는 prcs_dtl_opt inputs(타공수/구수) 보유 → detail 안내 근거 자연스러움. 자식(105/103)은 inputs 없음(105 del_yn=N·103 del_yn=Y). 옵션 환원도 이미 부모(104/079)를 가리킴 → 단가행을 부모로 통일하면 환원-단가행 정렬.

---

## 3. CONFIRM-C 족자 천정고리 — opt_cd 재배선

### 3.1 라이브 실측 결과
| 측정 | 결과 | 근거 SQL |
|---|---|---|
| 천정고리 단가행 | `COMP_POSTEROPT_JOKJA_CEILHOOK`: **1행**(id 4594)·**bdl_qty=2**·opt_cd/siz/mat/proc/dim_vals NULL·**6500원** | `t_prc_component_prices LIKE '%CEILHOOK%'` |
| comp use_dims | `["bdl_qty","min_qty"]`·prc_typ=PRICE_TYPE.01·use_yn=Y·del_yn=N | `t_prc_price_components` |
| 천정고리 바인딩 | **0건** | `t_prc_formula_components` |
| 135 족자포스터 본체 공식 | **PRF_POSTER_JOKJA** (기존 바인딩=COMP_POSTER_JOKJA disp_seq=1) | `t_prd_product_price_formulas` / `t_prc_formula_components` |
| 135 옵션 | OPT_000015 가공(사각족자 OPV_000033·원형족자 OPV_000034)·OPT_000016 추가(**"추가없음" OPV_000035만**) → **천정고리 옵션 미등록** | `t_prd_product_options WHERE prd_cd='PRD_000135'` |
| OPT_000016 그룹 | "추가"·**SEL_TYPE.01(택1)**·min=0·max=1·mand_yn=N·disp_seq=2·기존 옵션 disp_seq MAX=1 | `t_prd_product_option_groups` |
| 권위 엑셀(135) | 족자포스터(ID 19311): 추가="추가없음"(0.0)/"천정형고리 포함"(**"4000?"** 미확정 표기) | silsa-l1.csv |
| 135 등록 자재/공정 | 자재 MAT_000178(USAGE.07)만·공정 PROC_000082(족자가공)만. 천정고리 자재 **MAT_000215**(글로벌存) **135 미등록** | `t_prd_product_materials`/`t_prd_product_processes`/`t_mat_materials` |

**진단**: 권위는 "천정형고리 있음/없음"(OPT_000016 택1 추가물) — 묶음수 개념 없음. 라이브 bdl_qty=2는 의미 오용. 옵션 자체 미등록. 다른 추가물(우드행거·우드봉·끈·큐방)이 전부 opt_cd 판별 동형 → 족자만 bdl_qty면 동형 깨짐 → opt_cd 재배선.

**단가 충돌 정직 표기**: 권위 엑셀 "천정형고리 포함" 가격 = **"4000?"**(물음표=실무 미확정). 라이브 단가행 = **6500**. **결정 지침은 "6500 verbatim"** → 라이브 6500 보존(날조 금지). 권위 "4000?"는 미확정이므로 verbatim 우선·단 **§4 HOLD-C-PRICE로 정직 surface**(6500 vs 4000? 실무 확정 필요).

### 3.2 CPQ 옵션 등록표 (신규 천정고리 — 기존 그룹 OPT_000016 재사용)
신규 그룹 0건(기존 추가 그룹 재사용·search-before-mint 충족). opt_cd MAX+1=OPV_000431.

| # | 상품(prd_cd) | option_group (기존·근거) | 신규 opt_cd | opt_nm | dflt_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|---|
| 1 | 족자포스터(PRD_000135) | **OPT_000016 추가** (실측: "추가없음" OPV_000035만·SEL_TYPE.01 택1) | **OPV_000431** | 천정형고리 포함 | N | **2** (기존 MAX=1) | Y |

> opt_nm = 권위 엑셀 텍스트 "천정형고리 포함" verbatim.

#### 3.2.1 option_item 환원행 (MES 생산정보·가격 독립·트리거 통과 가능분만)
| 신규 opt_cd | 환원 가능 차원행 (라이브 실측) | option_item (가능분) | 비고 |
|---|---|---|---|
| OPV_000431 천정고리 | 자재 MAT_000215(천정고리·글로벌存) **135 미등록**·천정고리 공정 부재(135 등록=PROC_000082 족자가공만) | **(HOLD — §4 HOLD-C-ITEM)** | 자재 MAT_000215 135 product_materials 미등록 → OPT_REF_DIM.03 환원 시 트리거 REJECT. **가격 무영향**(가격=단가행 opt_cd). 환원행은 자재행 선등록 후 후속. |

> ★[HARD] option_item HOLD = 가격 무영향. 옵션 등록·use_dims·단가행 opt_cd 재배선·바인딩만으로 가격 정합 달성(rc2-addon-spec HOLD-3 동형).

### 3.3 족자 천정고리 배선표 (bdl_qty→opt_cd 재배선)
| comp | 대상 frm_cd | use_dims 재배선 | 단가행 재배선 (단가 verbatim) | 공식 바인딩 (addtn_yn·disp_seq) |
|---|---|---|---|---|
| `COMP_POSTEROPT_JOKJA_CEILHOOK` | **PRF_POSTER_JOKJA** | `["bdl_qty","min_qty"]` → **`["opt_cd","min_qty"]`** (bdl_qty 제거·opt_cd 추가) | id 4594: **bdl_qty=2→NULL** + **opt_cd=OPV_000431 충전**·6500 verbatim | **Y · disp_seq=2** (기존 MAX=1) |

> 미선택 0가산: 단가행 opt_cd=OPV_000431 채움 → "추가없음"(OPV_000035) 선택 시 opt_cd 불일치 → row=None → 가산 0. bdl_qty NULL화로 always-add 차단(현재 bdl_qty=2는 호출자가 bdl_qty=2 안 보내면 매칭 실패였으나, opt_cd 판별로 동형 정리).
> always-add 가드 확인: 재배선 후 단가행 차원 = opt_cd만(min_qty는 수량차원). opt_cd NULL 행 없음(1행만·OPV_000431 충전) → 미선택 시 와일드카드 없음.

---

## 4. FK 위상 적재순서 + 잔여 HOLD (정직 표기)

### 4.1 적재순서 (FK 위상·멱등 — 전부 인간 승인·DB 미적재·dbm-load-execution 입력)

1. **CPQ 옵션 선행** (`t_prd_product_options`): OPV_000431(족자 천정고리) INSERT (기존 OPT_000016 그룹·disp_seq=2). [린넨·타공은 옵션 이미 완비·신규 0]
2. **option_item 환원** (`t_prd_product_option_items`): 트리거 통과 가능분만. **본 3건 = 전부 HOLD**(린넨=이미 옵션 단순·환원 불요 / 타공=공정 환원 이미 존재 OPV_000007/8/9·OPV_000042/3/4 / 족자=HOLD-C-ITEM 자재 미등록). 신규 환원행 0.
3. **comp use_dims 충전/재배선** (`t_prc_price_components`): 메쉬 PUNCH_4/8 `[]`→proc_cd 차원·PUNCH_6 proc_grp 토큰 정정 / 족자 bdl_qty→opt_cd. [린넨 use_dims 이미 정합·충전 0]. IS DISTINCT FROM 가드.
4. **단가행 판별값 충전/재배선** (`t_prc_component_prices`): 일반 타공 proc_cd 105→104(3행) / 메쉬 타공 proc_cd NULL→079 + dim_vals{타공수} 충전(3행) / 족자 bdl_qty=2→NULL + opt_cd=OPV_000431(1행). **단가 verbatim 불변**(UPDATE WHERE에 unit_price 검증값 가드). [린넨 단가행 정합·충전 0]
5. **공식 바인딩** (`t_prc_formula_components`): 린넨 LINEN_FINISH→PRF_POSTER_LINEN(disp_seq=2) / 메쉬 타공 3 comp→PRF_POSTER_BANNER_M(disp_seq=4/5/6) / 족자 천정고리→PRF_POSTER_JOKJA(disp_seq=2) addtn_yn=Y UPSERT. [일반 타공 PUNCH_4 이미 바인딩·추가 0]
6. **좀비 정리** (`t_prc_price_components`): 일반 PUNCH_6/8(del_yn 이미 Y) **use_yn=N** 확정(always-add 좀비 차단).

### 4.2 잔여 HOLD (라이브로 못 닫은 것 — 정직 표기)
- **HOLD-125 (캔버스패브릭 마감비·미적재)**: 125는 124와 비동형(옵션 오버로크 1개·LINEN_FINISH 단가행 부재·권위 가공가격 공란). 마감비 적재할 단가 없음 → **미적재**(날조 금지). 125 마감 가격 권위 확정 시 별 트랙.
- **HOLD-C-PRICE (족자 천정고리 단가 6500 vs 권위 4000?)**: 권위 엑셀 "천정형고리 포함"="4000?"(물음표=실무 미확정), 라이브=6500. 지침대로 6500 verbatim 보존하되, **6500이 맞는지(또는 권위 4000이 정답인지) 실무 확정 필요**. verbatim 적재는 진행 가능·단가 정정은 별 결정.
- **HOLD-C-ITEM (족자 천정고리 자재 환원)**: 천정고리 자재 MAT_000215(글로벌存)이 135 product_materials 미등록 → option_item OPT_REF_DIM.03 환원 시 트리거 REJECT. 자재행 선등록(별 트랙·기초데이터) 선결. **가격 무영향**(가격=단가행 opt_cd).
- **HOLD-MESH-MERGE (메쉬 타공 1 comp 통합 보류)**: 설계는 1 comp 통합 권고였으나 comp 병합=가격사슬/바인딩 위험·공유자원 변경 → 본 명세=3 comp 유지(데이터 최소 변경). 통합은 별 결정.
- **타공 코드 트랙(§2.3)**: 위젯이 타공수 detail 전송해야 타공수별 작동. §21 범위 밖 코드 트랙. 데이터 트랙은 미선택 0가산(always-add 제거)까지 보장.
- **각목(CONFIRM-4)**: 본 명세 일절 미접촉(별도 에이전트 재정립 중). GAKMOK comp/단가행/옵션 0건 변경.

### 4.3 본 명세로 닫힌 것 (GO 범위)
- ✅ **CONFIRM-B 린넨마감 CLOSED**: opt_cd 124 정합 확정(재배선 0)·use_dims 정합·PRF_POSTER_LINEN addtn_yn=Y disp_seq=2 바인딩만. 125 비동형 확정(HOLD-125).
- ✅ **CONFIRM-A 타공 데이터 정리**: 일반 proc_cd 105→104 통일(dim_vals verbatim)·메쉬 proc_cd NULL→079+dim_vals{타공수} 충전·use_dims 충전·바인딩(메쉬 disp_seq 4/5/6)·좀비 use_yn=N·미선택 0가산 데이터 보장. 한계(위젯 코드 동반)·1 comp 통합 보류 명시.
- ✅ **CONFIRM-C 족자**: 신규 opt_cd OPV_000431(MAX+1·충돌 0)·bdl_qty→opt_cd 재배선(6500 verbatim)·use_dims=`["opt_cd","min_qty"]`·PRF_POSTER_JOKJA 바인딩 disp_seq=2·always-add 가드. HOLD-C-PRICE/ITEM 정직 표기.

---

## 판정

**분석·명세까지 GO** (라이브 실측 SQL 근거 전수·단가 verbatim·search-before-mint(신규 opt_cd OPV_000431 MAX+1·신규 그룹 0)·날조 0). 핵심:
① **린넨마감=CLOSED** — 재배선 불요(124 정합 확정)·바인딩 1건만. 125 비동형·미적재.
② **타공=데이터만 정리** — 부모 proc_cd 통일+dim_vals/use_dims 충전+바인딩. always-add(과대청구) 제거=데이터로 완결, 타공수별 작동=위젯 코드 동반(한계 명시).
③ **족자=opt_cd 재배선** — bdl_qty 의미 오용 교정·6500 verbatim·동형 정리. 단가 6500 vs 권위 4000? HOLD-C-PRICE.
④ **각목 일절 미접촉**.
**DB 미적재·단가 verbatim·라이브 읽기전용 SELECT·생성자(option-mapper)≠검증자.** 본 명세 = dbm-load-builder 적재본 입력 / dbm-validator 독립 게이트 비준 대상.
