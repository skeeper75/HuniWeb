# 일반현수막(PRD_000138) CPQ 옵션 레이어 — 적재본(load-ready) 파일럿 (silsa)

> **상태/이력** 작성 2026-06-07 · `dbm-option-mapper` 산출 · round-6 파일럿 #2(silsa, master map §6 후보 2). DB 미적재(실 INSERT/코드행/DDL = 인간 승인).
> **목적:** `attribute-entity-map.md`(마스터 지도 패밀리③) + `banner-walkthrough.md`(설계 초안, CONDITIONAL-GO)를 **마스터 지도 정합·적재 가능** 옵션 레이어로 정련하여 실 행 + 적재 CSV로 산출한다. 워크스루는 설계 초안, 본 문서는 **적재본**. 사용자 제공 캐스케이드(가공6·추가5)가 본 런의 권위.
> **권위 입력(인용·발명 금지):** `attribute-entity-map.md`(verdict 패밀리③) · `00_schema/cpq-schema.md §1/§2/§4`(라이브 컬럼·트리거·design↔live) · `banner-walkthrough.md`+`-validation.md`(설계·검증 CONDITIONAL-GO·GAP-1/2/5) · `06_extract/silsa-l1.csv`(L1 캐스케이드 row108~113) · `00_schema/ref-product-*.csv`·`ref-processes.csv`(라이브 차원행 스냅샷, 존재 판정=라이브 권위).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 코드 = `[CONFIRM]`(발명 금지). 적재 CSV = `10_configurator/load_silsa/<table>.csv`(엽서 파일럿 `load/`와 분리).

---

## 0. 워크스루 → 적재본 정련 요약 (무엇이 바뀌었나)

본 파일럿이 워크스루(설계 초안, `banner-walkthrough.md`)에 가한 **적재 임계 정련 6건** — 전부 라이브 스키마/트리거 권위(`cpq-schema §2/§4`·`ref-product-processes.csv` 실측)에 근거. 핵심은 **워크스루가 `[CONFIRM]`으로 미뤘던 두 코드(열재단·각목 set)가 검증 결과 BLOCKED로 확정**된다는 것이다. 그 중 **열재단은 M-1 ① 확정**(`m1-yeoljaedan-decision.md`: 가격표 권위 3,000원 → 실제 가공 공정)에 따라 완칼 PROC_053 차용을 폐기하고 **신규 열재단 전용 공정 PROC_000084 신설 제안**(`11_ddl_proposals/heat-cut-process-proposal`)으로 정정한다 — 여전히 BLOCKED이나 사유는 "공정 신설·적재 인간승인 대기"다.

| # | 워크스루(설계 초안) | 적재본(라이브 정합) | 근거 |
|---|---------------------|---------------------|------|
| **R1** | ref_dim_cd = 텍스트 `'process'`/`'set'`/`'addon'`/`'size'` | ref_dim_cd = **라이브 코드 FK** `OPT_REF_DIM.04`(공정)·`.07`(셋트). add-on은 ref_dim 아님(template) | cpq-schema §2 트리거 디스패치·§3 코드값 7종 |
| **R2** | 열재단 → `PROC_000053` 완칼 차용 `[CONFIRM]`(미해소) | **M-1 ① 확정 — 완칼 차용 폐기**(천 매질 부적합), 열재단 = 실제 가공 공정(가격표 3,000원) → **신규 PROC_000084 신설 제안**. 열재단 item 여전히 **BLOCKED**(공정 신설·적재 인간승인 대기) | m1-yeoljaedan-decision.md · 11_ddl_proposals/heat-cut-process-proposal · price-poster-sign-l1.csv(3,000원) |
| **R3** | option_items에 `ref_param_json {"구수":N}` 저장 | **`ref_param_json` 컬럼 라이브 부재** → 구수/규격 미보존. 타공 4/6/8행은 적재하되 param은 GAP-PARAM 플래그. **qty에 구수 smear 금지** | `_live-schema-dump` option_items = qty만(cpq-schema §4 🔴8) |
| **R4** | 각목 = `set` or `addon` `[CONFIRM 코드]`(미해소) | **각목 상품 ref-products 0행 + PRD_000138 sets 0행 확정** → 각목 seq2 item **BLOCKED**(sub_prd_cd 미상·트리거 REJECT) | ref-products.csv(각목 0행)·ref-product-sets.csv(PRD_000138 0행) |
| **R5** | constraint `rule_typ` = 텍스트 `compatible`/`forbidden`/`required` | **`rule_typ_cd` 코드 FK** = `RULE_TYPE.01`(호환)/`.02`(금지)/`.03`(필수동반) | cpq-schema §4 ⚠️11·§3 RULE_TYPE |
| **R6** | 거치대 add-on(Step 5, 메쉬배너 거치대 차용 시나리오) | **삭제** — 사용자 제공 캐스케이드에 거치대 없음(L1 일반현수막=끈/큐방/각목만). 추측 add-on 미인스턴스화(scope discipline) | silsa-l1.csv 일반현수막 추가 5값에 거치대 부재 |

> **추가 정련(F-1, dbm-validator round-6 교훈):** ① `t_prd_product_option_items.csv`는 `note` 컬럼이 라이브 부재라 적재 CSV에서 제거 — 적재 CSV는 라이브 컬럼만(`prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn`). 프로비넌스는 본 §3·§4·options CSV note·분리 CSV `block_reason`에 보존(무손실). ② option_items 적재 CSV=INSERTABLE 9행, BLOCKED 3행은 분리 CSV(`..._BLOCKED.csv`, `block_reason` 컬럼)로 격리(round-5 차단행 분리 패턴).
> **거치대 제외 사유(R6 보강):** 워크스루는 "template 메커니즘 실증"을 위해 메쉬배너 거치대를 일반현수막에 차용했으나, 이는 실데이터에 없는 가상 시나리오였다(워크스루 §5.2(e)#5도 `[CONFIRM]`으로 자인). 본 적재본은 **사용자 제공 캐스케이드 = 권위**이므로 거치대 템플릿/selections/addons를 산출하지 않는다(엽서 파일럿이 봉투 add-on을 이미 실증함 — 중복 불요). 따라서 templates/template_selections/addons CSV는 본 파일럿에 없음.

---

## 1. Step 0 — 차원행 전제 (option_item이 참조할 라이브 차원 확인)

[HARD] option_item은 *이미 적재된 차원행*을 가리키는 포인터다. 트리거 `fn_chk_opt_item_ref`가 "그 prd_cd에 등록된 차원행 EXISTS"를 강제하므로, 등록 전 차원행 실재를 확인한다(ref-*.csv 스냅샷, 존재 판정=라이브 권위).

| 차원 | 라이브 적재(PRD_000138) | option_item 참조 가능? | 출처 |
|------|------------------------|:----------------------:|------|
| **size** `OPT_REF_DIM.01` | **1행** SIZ_000322 (5000x900, work=cut=5000×900, dflt=Y) | ✅ (단 사이즈 그룹 본 파일럿 미생성 — §2 주) | ref-product-sizes.csv |
| **material(소재)** `OPT_REF_DIM.03` | **1행** MAT_000182 (현수막천, MAT_TYPE.08, usage=USAGE.07, dflt=Y) | ✅ (단 소재 그룹 본 파일럿 미생성 — 단일 소재) | ref-product-materials.csv |
| **process(공정)** `OPT_REF_DIM.04` | **3행** PROC_000079(타공)·PROC_000080(봉제)·PROC_000081(부착) — 전부 mand_proc_yn=N·excl_grp_cd 공백 | ✅ 타공/봉제/부착만 / ❌ **PROC_000053(완칼)·기타 0행** | ref-product-processes.csv (silsa.md G-SL-5) |
| **set(셋트)** `OPT_REF_DIM.07` | **0행** | ❌ 각목 sub_prd_cd → 각목 seq2 BLOCKED | ref-product-sets.csv(PRD_000138 부재) |
| **plate_size** `OPT_REF_DIM.02` | 1행 SIZ_000322(output JPG) | ✅ (보통 미노출 — 판형) | ref-product-plate-sizes.csv |
| **print_option/bundle_qty/page_rule** | 0행 | (해당 없음 — 현수막 도수·묶음 미보유) | silsa.md §③ |
| **addon** | **0행** (일반현수막) | (사용자 캐스케이드에 거치대 없음 — 미해당, R6) | ref-product-addons.csv(PRD_000138 부재) |

**공정 detail opt 스키마(`ref-processes.csv prcs_dtl_opt` — option_items 파라미터의 정의 권위):**
- `PROC_000079 타공`: `{"inputs":[{"key":"구수","max":8,"min":1,"type":"integer","unit":"개"}]}`
- `PROC_000080 봉제`: `{"inputs":[{"key":"유형","type":"enum","values":["오버로크","말아박기","봉미싱"]},{"key":"폭","type":"number","unit":"mm"}]}` ← **봉미싱 ∈ 유형 enum**
- `PROC_000081 부착`: `{"inputs":[{"key":"대상","type":"enum","values":["라벨","맥세이프","끈","테입"]}]}` ← **끈·테입 ∈ 대상 enum**, **큐방 ∉ enum**
- `PROC_000053 완칼`: `{"inputs":[{"key":"모양","type":"string","required":false}]}` — 종이 다이컷 공정(천 매질 부적합). **열재단 환원 차용 폐기**(M-1 ① 확정) → 열재단은 신규 PROC_000084로 분리. 053 자체는 PRD_000138 무관

**Step 0 판정:** 타공(079)·봉제(080)·부착(081)은 차원행 실재 → 해당 option_item 등록 가능(INSERTABLE). **열재단=신규 PROC_000084(공정 마스터 미신설)** → 트리거 REJECT = **BLOCKED**(M-1 ① 확정·완칼 차용 폐기, 공정 신설·적재 인간승인 대기, 제안서 `11_ddl_proposals/heat-cut-process-proposal`). **각목=set은 PRD_000138 sets 0행 + 각목 완제상품 자체 부재** → 트리거 REJECT = **BLOCKED**(sub_prd_cd 미상, `[CONFIRM]`). 이 두 BLOCKED가 워크스루 `[CONFIRM]`의 확정 결과다(R2·R4).

---

## 2. option_groups (sel_typ_cd 택1/택N · mand_yn)

→ `load_silsa/t_prd_product_option_groups.csv` (2행). 라이브 컬럼: `prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note`. `sel_typ_cd` 값 형식 = **`SEL_TYPE.01`**(라이브 GRP-BOOK 선례 일치, 풀코드).

| opt_grp_cd | opt_grp_nm | sel_typ_cd | min | max | mand_yn | disp_seq | verdict 근거(master map 패밀리③) |
|---|---|---|:--:|:--:|:--:|:--:|---|
| `OG-GAGONG` | 가공 | SEL_TYPE.01 (택1) | 1 | 1 | **Y** | 1 | 가공=택일그룹(L1 1셀=1값), 필수(열재단 기본) |
| `OG-CHUGA` | 추가 | SEL_TYPE.01 (택1) | 0 | 1 | N | 2 | 추가=택일그룹, 선택(추가없음 기본) |

> 출처: silsa-l1.csv row108~113 가공은 1셀당 1값(택1) → SEL_TYPE.01·max=1. 가공=필수(mand_yn=Y, 열재단 dflt), 추가=선택(min=0, 추가없음 dflt 센티넬). **이 두 그룹이 기존 `t_prd_product_process_excl_groups`의 일반화 형태** — 일반현수막엔 excl_group 0행이었으나(silsa.md §③), 가공 택일이 곧 process excl-group의 일반 옵션그룹 표현. **단 이는 "공백에서 신규 표현"이지 기존 excl-group 변환 실증이 아님**(GAP-2 미행사 — 워크스루 검증 승계, §10).
> **사이즈 그룹 미생성(설계 결정):** 사이즈(SIZ_000322 규격 + 사용자입력 nonspec)는 **하이브리드** — 규격행=차원, 사용자입력=products 범위+constraint(연속수치라 option_item 열거 불가, §5.2(c)·banner). 사이즈는 보통 상품 진입 시 1차 선택축으로 UI 상단 고정 → option_group 미노출(워크스루도 미생성). 사이즈 모드(규격/사용자입력 토글)·범위 검증은 R-SIZE-NONSPEC constraint·MES 환원에서 직접 참조. (`[CONFIRM]` 사이즈 그룹 노출 = UI 정책.)
> **소재 그룹 미생성:** 일반현수막 소재=현수막천 단일(MAT_000182 1행). 택일 의미 없는 단일값이라 option_group 미생성(고정 차원). 다소재 상품이면 OG-SOJAE 생성 대상.

---

## 3. options (opt_grp_cd · dflt_yn)

→ `load_silsa/t_prd_product_options.csv` (11행). 라이브 컬럼: `prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note`.

- **OG-GAGONG(6):** OP-GAGONG-YEOLJAEDAN(열재단, dflt) · OP-GAGONG-TAGONG4(타공4) · OP-GAGONG-TAGONG6(타공6) · OP-GAGONG-TAGONG8(타공8) · OP-GAGONG-YANGMYEONTAPE(양면테입) · OP-GAGONG-BONGMISING(봉미싱)
- **OG-CHUGA(5):** OP-CHUGA-NONE(추가없음, dflt 센티넬) · OP-CHUGA-QBANG4(큐방4) · OP-CHUGA-STRING4(끈4) · OP-CHUGA-GAKMOK-LE900(각목900이하+끈) · OP-CHUGA-GAKMOK-GT900(각목900초과+끈)

> 출처: silsa-l1.csv row108~113 가공/추가 값 1:1(char-단위 일치, validation §0.2). 열재단=가공 dflt(row108), 추가없음=추가 dflt(row108). `OP-*` opt_cd는 본 설계 신규 부여. **옵션(헤더) 레벨엔 트리거 없음** → 11행 전부 적재 가능(BLOCKED은 item 레벨 — §4).

---

## 4. option_items (polymorphic ref_dim_cd → 라이브 차원행 · 트리거 디스패치 정확)

→ `load_silsa/t_prd_product_option_items.csv` (INSERTABLE 9행) + `load_silsa/t_prd_product_option_items_BLOCKED.csv` (BLOCKED 3행). 라이브 컬럼: `prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn`. **`ref_param_json` 컬럼 없음(R3·GAP-PARAM).**

### 4.1 각 옵션 값 → 엔티티/ref_dim_cd/ref_key 매핑 + 적재 판정 (사용자 핵심 질문의 답)

**가공 그룹 (6값):**

| 옵션 값 | 타깃 엔티티 | ref_dim_cd | ref_key1 | param(정의만, 미보존) | 트리거 검사 | 판정 |
|---|---|---|---|---|---|:--:|
| 열재단 | 공정 **열재단(신규 PROC_000084)** | `OPT_REF_DIM.04` | `PROC_000084` `[CONFIRM-CHANNEL]` | 없음(flat 3,000원) | processes(084) **신설 대기** | ❌ **BLOCKED**(신설·적재 인간승인 대기) |
| 타공(4개) | 공정 PROC_000079 타공 | `OPT_REF_DIM.04` | `PROC_000079` | `{"구수":4}` | processes(079) EXISTS | ✅ INSERTABLE |
| 타공(6개) | 공정 PROC_000079 타공 | `OPT_REF_DIM.04` | `PROC_000079` | `{"구수":6}` | processes(079) EXISTS | ✅ INSERTABLE |
| 타공(8개) | 공정 PROC_000079 타공 | `OPT_REF_DIM.04` | `PROC_000079` | `{"구수":8}` | processes(079) EXISTS | ✅ INSERTABLE |
| 양면테입 | 공정 PROC_000081 부착 | `OPT_REF_DIM.04` | `PROC_000081` | `{"대상":"테입"}` `[CONFIRM]` | processes(081) EXISTS | ✅ INSERTABLE |
| 봉미싱 | 공정 PROC_000080 봉제 | `OPT_REF_DIM.04` | `PROC_000080` | `{"유형":"봉미싱"}` | processes(080) EXISTS | ✅ INSERTABLE |

**추가 그룹 (5값):**

| 옵션 값 | 타깃 엔티티 | ref_dim_cd | ref_key1 | param(정의만) | 트리거 검사 | 판정 |
|---|---|---|---|---|---|:--:|
| 추가없음 | (센티넬 — item 0행) | — | — | — | (item 없음) | ✅ INSERTABLE(option only) |
| 큐방(4개)추가 | 공정 PROC_000081 부착 | `OPT_REF_DIM.04` | `PROC_000081` | `{"대상":"큐방"}` `[CONFIRM]` | processes(081) EXISTS | ✅ INSERTABLE(큐방 enum 확장 별건) |
| 끈(4개)추가 | 공정 PROC_000081 부착 | `OPT_REF_DIM.04` | `PROC_000081` | `{"대상":"끈"}` | processes(081) EXISTS | ✅ INSERTABLE |
| 각목(900이하)+끈(4개) | **복합 2행** seq1 끈=공정 / seq2 각목=셋트 | `.04` / `.07` | `PROC_000081` / `[CONFIRM]` | seq1 081 EXISTS / seq2 sets **부재** | seq1 ✅ / seq2 ❌ **BLOCKED** |
| 각목(900초과)+끈(4개) | **복합 2행** seq1 끈=공정 / seq2 각목=셋트 | `.04` / `.07` | `PROC_000081` / `[CONFIRM]` | seq1 081 EXISTS / seq2 sets **부재** | seq1 ✅ / seq2 ❌ **BLOCKED** |

### 4.2 디스패치 정확성(트리거 슬롯 일치)

- **공정 = `OPT_REF_DIM.04`, ref_key1 = proc_cd** — ref_key2 미사용. 타공/봉제/부착이 전부 이 디스패치.
- **타공 4/6/8개 = 동일 PROC_000079 + `{"구수":N}` 파라미터 차이** → 공정 마스터 1행을 옵션 3개가 재사용. **이것이 polymorphic+ref_param_json의 핵심 이득** — 단 라이브 ref_param_json 부재라 구수 N **보존 불가**(R3·GAP-PARAM). **qty에 구수 smear 금지**(qty=소비수량 1, 구수≠qty). 공정 1행 분리 복제(타공4용/6용/8용 별 proc_cd)는 **마스터 오염이므로 금지** — 행은 동일 ref_key1로 적재하고 param은 GAP-PARAM 플래그.
- **끈/테입/큐방 = 부착 공정(081)으로 환원** — `대상` enum에 `끈`·`테입`이 이미 존재(ref-processes.csv). G-SL-4 모호성의 process측은 **이미 마스터 지원**. `큐방`은 enum 미존재 → param `[CONFIRM]`(enum 확장 별건이나 ref_key1=081은 INSERTABLE — item은 proc_cd EXISTS만 검사, param은 트리거 미검사).
- **양면테입→`{"대상":"테입"}`은 도메인 해석** — L1값 `양면테입` ≠ enum값 `테입`. 합리적 추론이나 엑셀 명시 매핑 아님 → `[CONFIRM]` 표기(validation GAP-4 보정: 큐방엔 `[CONFIRM]`하고 양면테입엔 안 한 비대칭 해소).
- **복합 각목+끈 = item_seq 2행:** seq1=끈(부착 공정 081, qty=4), seq2=각목(셋트 `OPT_REF_DIM.07`, sub_prd_cd `[CONFIRM]`). **같은 옵션 안에 process+set 두 차원이 공존** → polymorphic이 typed FK로는 불가능한 이종 결합을 자연 표현. seq1(끈)은 081 EXISTS라 INSERTABLE, **seq2(각목)는 sets 0행 + 각목 완제상품 부재라 BLOCKED**(R4).
- **각목 = `set`(`OPT_REF_DIM.07`) 귀속 근거:** 각목은 완제 부속(나무 막대) = 물리 부품 → 셋트/addon 성격. 부착 enum(081)에 없음(끈/테입/라벨/맥세이프만) → process 아님. master map 규약 "부착 enum에 있으면 process, 물리 부품이면 set/addon"에 따라 **set**. 단 각목 sub_prd_cd 코드 미존재 → 발명 금지(`[CONFIRM]`).

> **R3·GAP-PARAM 정직 표기:** 타공 4/6/8·각목 900이하/초과는 본래 `{"구수":N}`·`{"규격":"..."}` 파라미터를 가지나 라이브 option_items에 `ref_param_json` 부재 → **구수/규격 보존 불가**. 공정 *스키마*는 `ref-processes.csv prcs_dtl_opt`에 실재(PROC_000079 `{"구수":int 1~8}`) — 즉 파라미터 *정의*는 마스터에 있고, *선택값* 보존처만 부재. 적재 CSV는 INSERTABLE 행만 싣고 param은 GAP-PARAM으로 등록(§9).

---

## 5. constraints (JSONLogic rule 행 + compile)

→ `load_silsa/t_prd_product_constraints.csv` (3행). 라이브 컬럼: `prd_cd, rule_cd, rule_nm, rule_typ_cd, logic(jsonb NN), err_msg, disp_seq, use_yn`. **`rule_typ_cd` = 코드 FK**(R5). data 키 규약: 고객 선택을 `{ "size_mode": "spec|nonspec", "width": int, "height": int, "gagong": opt_cd, "chuga": opt_cd }` 형태로 평가에 전달.

| rule_cd | rule_nm | rule_typ_cd | 의미 |
|---|---|---|---|
| `R-SIZE-NONSPEC` | 사용자입력 치수 범위 | RULE_TYPE.01 (호환) | 규격이면 통과, 사용자입력이면 가로 500~1750·세로 500~5000 (L1 row109) |
| `R-GAKMOK-HEIGHT` | 각목 규격×세로 정합 | RULE_TYPE.02 (금지) | 각목(900이하)→세로≤900, 각목(900초과)→세로>900 (L1 row111/112) |
| `R-BONGJE-PARAM` | 봉미싱 선택 시 사이즈 필수 | RULE_TYPE.03 (필수동반) | 봉미싱이면 width·height>0 (PROC_000080 폭 파라미터 정합) |

**Rule 1 — R-SIZE-NONSPEC** (출처 silsa-l1.csv row109 `비규격_가로=500~1750`·`_세로=500~5000`):
```json
{ "or": [
    { "!=": [ { "var": "size_mode" }, "nonspec" ] },
    { "and": [
        { ">=": [ { "var": "width" },  500  ] }, { "<=": [ { "var": "width" },  1750 ] },
        { ">=": [ { "var": "height" }, 500  ] }, { "<=": [ { "var": "height" }, 5000 ] }
    ] }
] }
```

**Rule 2 — R-GAKMOK-HEIGHT** (출처 row111/112 각목 900이하/초과 = 세로 의존. 도메인: 각목은 현수막 폭=세로변에 맞춰 절단):
```json
{ "and": [
    { "if": [ { "==": [ { "var": "chuga" }, "OP-CHUGA-GAKMOK-LE900" ] }, { "<=": [ { "var": "height" }, 900 ] }, true ] },
    { "if": [ { "==": [ { "var": "chuga" }, "OP-CHUGA-GAKMOK-GT900" ] }, { ">":  [ { "var": "height" }, 900 ] }, true ] }
] }
```

**Rule 3 — R-BONGJE-PARAM** (봉제 공정 `폭` 파라미터, PROC_000080):
```json
{ "if": [ { "==": [ { "var": "gagong" }, "OP-GAGONG-BONGMISING" ] },
          { "and": [ { ">": [ { "var": "width" }, 0 ] }, { ">": [ { "var": "height" }, 0 ] } ] }, true ] }
```

**JSONLogic 검증(본 파일럿 손계산·python 평가, 전건 PASS):**

| 입력 | R-SIZE | R-GAKMOK | R-BONGJE | compiled | 의도 |
|---|:--:|:--:|:--:|:--:|---|
| 규격 5000×900, 추가없음 | T(spec) | T | T | **PASS** | 규격 무조건 통과 |
| nonspec 1500×900, 각목LE900, 봉미싱 | T | T(900≤900) | T(>0) | **PASS** | 정상 |
| nonspec 4000×900, 추가없음 | **F**(4000>1750) | T | T | **FAIL** | 가로 상한 위반 노출 |
| nonspec 1500×1200, 각목LE900 | T | **F**(1200>900) | T | **FAIL** | 각목 규격↔세로 불일치 |
| nonspec 1500×1200, 각목GT900 | T | T(1200>900) | T | **PASS** | 각목 규격 정합 |
| nonspec 1500×900, 각목GT900 | T | **F**(900 not>900) | T | **FAIL** | GT900인데 세로 900 |

**`t_prd_products.constraint_json` (compile 캐시 = 활성 3 rule AND 결합 — products UPDATE, 별도 CSV 아님):**
```json
{ "and": [
  { "or": [ {"!=":[{"var":"size_mode"},"nonspec"]},
            {"and":[{">=":[{"var":"width"},500]},{"<=":[{"var":"width"},1750]},
                    {">=":[{"var":"height"},500]},{"<=":[{"var":"height"},5000]}]} ] },
  { "and": [ {"if":[{"==":[{"var":"chuga"},"OP-CHUGA-GAKMOK-LE900"]},{"<=":[{"var":"height"},900]},true]},
             {"if":[{"==":[{"var":"chuga"},"OP-CHUGA-GAKMOK-GT900"]},{">":[{"var":"height"},900]},true]} ] },
  { "if": [ {"==":[{"var":"gagong"},"OP-GAGONG-BONGMISING"]},
            {"and":[{">":[{"var":"width"},0]},{">":[{"var":"height"},0]}]}, true ] }
] }
```
> POD `json-logic-js`·백엔드 `json-logic-py` 동일 평가. 관리자 rule on/off 시 재compile. **최종 가격유효성 = 가격엔진**(면적매트릭스형, 비가격조합=주문불가) — constraint는 입력 유효성만.

---

## 6. 고객 선택 → MES 환원 트레이스 (sample)

**고객 선택:** 일반현수막 / 사용자입력 `1500×900` / 타공(6개) / 각목(900이하)+끈(4개) / 제작수량 5장. (워크스루 §4의 4000×900은 R-SIZE FAIL 케이스라 트레이스용으로 1500×900 채택.)

**선택 → 옵션 행:**
```
size_mode = nonspec, width=1500, height=900
gagong    = OP-GAGONG-TAGONG6        (OG-GAGONG 그룹 택1)
chuga     = OP-CHUGA-GAKMOK-LE900    (OG-CHUGA 그룹 택1)
qty       = 5
```

**제약 평가(constraint_json):** R-SIZE-NONSPEC(1500∈[500,1750]·900∈[500,5000] → T)·R-GAKMOK-HEIGHT(LE900·900≤900 → T)·R-BONGJE-PARAM(gagong≠봉미싱 → T) → **전체 PASS ✅**(본 파일럿 손계산·python 검증 일치).

**환원(option_items → 실엔티티):**

| 선택 | option_items 행 | ref_dim_cd | 환원 결과 |
|---|---|---|---|
| 소재(고정) | (material 차원 직접) | material | MAT_000182 현수막천, usage USAGE.07 |
| 사이즈 | nonspec(products 범위) | size | 1500×900 (work=cut) |
| 타공(6개) | OP-GAGONG-TAGONG6/seq1 | `OPT_REF_DIM.04` | PROC_000079 타공, `{"구수":6}` — **구수 보존 불가(GAP-PARAM)** |
| 끈(4개) | OP-CHUGA-GAKMOK-LE900/seq1 | `OPT_REF_DIM.04` | PROC_000081 부착, `{"대상":"끈"}`, qty=4 |
| 각목 | OP-CHUGA-GAKMOK-LE900/seq2 | `OPT_REF_DIM.07` | 각목(900이하) `[CONFIRM 코드]`, qty=1 — **sub_prd_cd 미상(BLOCKED)** |

**MES 주문 페이로드(resolved JSON):**
```json
{
  "order_lines": [
    {
      "line_type": "MAIN",
      "prd_cd": "PRD_000138", "prd_nm": "일반현수막", "qty": 5,
      "size": { "mode": "nonspec", "width": 1500, "height": 900, "unit": "mm" },
      "materials": [ { "mat_cd": "MAT_000182", "mat_nm": "현수막천", "usage_cd": "USAGE.07" } ],
      "processes": [
        { "proc_cd": "PROC_000079", "proc_nm": "타공", "params": { "구수": 6 }, "consume_qty": 1, "note": "구수 보존 불가 GAP-PARAM" },
        { "proc_cd": "PROC_000081", "proc_nm": "부착", "params": { "대상": "끈" }, "consume_qty": 4 }
      ],
      "parts": [
        { "ref_dim_cd": "OPT_REF_DIM.07", "ref_key1": "[CONFIRM 각목코드]", "params": { "규격": "900이하" }, "consume_qty": 1, "note": "set 차원·각목 sub_prd_cd 미상 BLOCKED" }
      ]
    }
  ]
}
```

**환원 완전성:** 소재·타공·끈은 **material(MAT_000182) + process(079/081)** 로 100% 환원. **각목(set)·타공 구수는 미완** — 각목 sub_prd_cd `[CONFIRM]`(마스터 적재 의존)·구수 param(ref_param_json 부재). `ref_dim_cd`가 환원 라우터(process→processes[], set→parts[]). 거치대 ADDON 라인은 본 캐스케이드에 없음(R6).

---

## 7. 각 옵션 값 → 엔티티 매핑 종합표 (사용자 핵심 질문의 단일 답)

| # | 옵션 값(L1) | 그룹 | 타깃 엔티티 | ref_dim_cd | ref_key1 | param | 판정 |
|:--:|---|---|---|---|---|---|:--:|
| 1 | 열재단 | OG-GAGONG | 공정 열재단(신규) | OPT_REF_DIM.04 | PROC_000084 `[CONFIRM-CHANNEL]` | 없음 | **BLOCKED**(신설대기) |
| 2 | 타공(4개) | OG-GAGONG | 공정 타공 | OPT_REF_DIM.04 | PROC_000079 | {구수:4} GAP-PARAM | INSERTABLE |
| 3 | 타공(6개) | OG-GAGONG | 공정 타공 | OPT_REF_DIM.04 | PROC_000079 | {구수:6} GAP-PARAM | INSERTABLE |
| 4 | 타공(8개) | OG-GAGONG | 공정 타공 | OPT_REF_DIM.04 | PROC_000079 | {구수:8} GAP-PARAM | INSERTABLE |
| 5 | 양면테입 | OG-GAGONG | 공정 부착 | OPT_REF_DIM.04 | PROC_000081 | {대상:테입} `[CONFIRM]` | INSERTABLE |
| 6 | 봉미싱 | OG-GAGONG | 공정 봉제 | OPT_REF_DIM.04 | PROC_000080 | {유형:봉미싱} | INSERTABLE |
| 7 | 추가없음 | OG-CHUGA | 센티넬(item 0행) | — | — | — | INSERTABLE(option) |
| 8 | 큐방(4개)추가 | OG-CHUGA | 공정 부착 | OPT_REF_DIM.04 | PROC_000081 | {대상:큐방} `[CONFIRM]` | INSERTABLE |
| 9 | 끈(4개)추가 | OG-CHUGA | 공정 부착 | OPT_REF_DIM.04 | PROC_000081 | {대상:끈} | INSERTABLE |
| 10a | 각목(900이하)+끈 seq1 | OG-CHUGA | 공정 부착(끈) | OPT_REF_DIM.04 | PROC_000081 | {대상:끈} | INSERTABLE |
| 10b | 각목(900이하)+끈 seq2 | OG-CHUGA | 셋트(각목) | OPT_REF_DIM.07 | `[CONFIRM]` | {규격:900이하} | **BLOCKED** |
| 11a | 각목(900초과)+끈 seq1 | OG-CHUGA | 공정 부착(끈) | OPT_REF_DIM.04 | PROC_000081 | {대상:끈} | INSERTABLE |
| 11b | 각목(900초과)+끈 seq2 | OG-CHUGA | 셋트(각목) | OPT_REF_DIM.07 | `[CONFIRM]` | {규격:900초과} | **BLOCKED** |

> **가공 6값 = 5 INSERTABLE + 1 BLOCKED(열재단).** **추가 5값 = option 5개 모두 INSERTABLE(추가없음 센티넬 포함), item은 6 INSERTABLE(큐방·끈·각목LE끈·각목GT끈 seq1) + 2 BLOCKED(각목 seq2 ×2).** 복합옵션이 polymorphic 이종 차원(process+set)을 한 옵션에 담는 핵심 이득을 행사한다.

---

## 8. FK 위상정렬 적재 순서 (load order)

트리거 `fn_chk_opt_item_ref`는 차원행 부재 시 REJECT → 차원행 선행 필수:
```
[선행 — L1, 대부분 라이브 적재됨] dimension rows:
  ✅ sizes(SIZ_000322)·materials(MAT_000182)·processes 079/080/081 — 적재됨
  ❌ processes 열재단 전용공정 PROC_000084(신규) 0행 — 신설·적재 인간승인 대기(M-1 ① 확정·완칼 PROC_053 차용 폐기, 제안서 11_ddl_proposals/heat-cut-process-proposal)
  ❌ sets(각목 sub_prd_cd) 0행 + 각목 완제상품 자체 부재 — 상품+sets 선적재 필요([CONFIRM])
[1] t_prd_product_option_groups (2행)         — FK: prd_cd→products, sel_typ_cd→cod (트리거 없음)
[2] t_prd_product_options (11행)              — FK: opt_grp_cd→option_groups (트리거 없음)
[3] t_prd_product_option_items (적재 CSV = INSERTABLE 9행만) — 트리거: ref_dim_cd별 차원행 EXISTS
       적재 CSV(load_silsa/t_prd_product_option_items.csv): 타공4/6/8(079)·양면테입/큐방/끈/각목LE끈/각목GT끈 seq1(081)·봉미싱(080)
       분리 CSV(load_silsa/t_prd_product_option_items_BLOCKED.csv, 적재 대상 아님): 열재단(신규 PROC_000084)·각목 seq2 ×2(set) — 신설/선적재 후 적재 대기
[4] t_prd_product_constraints (3행)           — FK: prd_cd→products, rule_typ_cd→cod
[5] UPDATE t_prd_products.constraint_json     — §5 compile 캐시
```
> [HARD] option_items는 **트리거가 행단위 검사** → BLOCKED 3행은 차원 선적재(또는 GAP-DEFER 센티넬 규약) 확정 전 적재 불가. 따라서 **적재 CSV에는 INSERTABLE 9행만**, BLOCKED 3행은 분리 CSV로 격리. options/option_groups는 트리거 없음(헤더만이라 11/2행 전부 적재 가능 — BLOCKED은 items 레벨).
> **F-1(2026-06-07):** `t_prd_product_option_items.csv`의 `note` 컬럼은 라이브 부재 → 적재 CSV에서 제거(라이브 컬럼만). 프로비넌스는 본 §3/§4·options CSV note·분리 CSV `block_reason`에 보존(무손실). groups/options/constraints는 `note` 라이브 실재라 유지.
> **templates/template_selections/addons 없음:** 본 캐스케이드에 거치대 add-on 부재(R6). 엽서 파일럿이 봉투 add-on/template_selections를 이미 실증 — 중복 불요.

---

## 9. 적재 가능성 집계 (insertable / BLOCKED / GAP)

| 테이블 (적재 CSV) | 총행 | INSERTABLE | BLOCKED(needs L1) | 비고 |
|---|:--:|:--:|:--:|---|
| option_groups | 2 | 2 | 0 | 트리거 없음 (OG-GAGONG·OG-CHUGA) |
| options | 11 | 11 | 0 | 트리거 없음(헤더). 가공6+추가5 |
| **option_items** (`...option_items.csv`) | **9** | **9** | **0** | 적재 CSV = INSERTABLE 9행(타공3·081계열5·봉미싱1). note 컬럼 제거(F-1) |
| **option_items 분리** (`..._BLOCKED.csv`) | **3** | **0** | **3** | 열재단(신규 PROC_000084 신설대기)·각목 seq2 ×2(set). 적재 대상 아님 — 신설/선적재 후 적재 대기. block_reason 컬럼 보유 |
| constraints | 3 | 3 | 0 | JSONLogic 손계산·python 검증 PASS |
| **합계** | **28** | **25** | **3** | 적재 CSV 합 = 25행(3 BLOCKED은 분리 CSV로 격리) + constraint_json UPDATE 1건 |

> 옵션 값 기준: **가공 6 = 5 INSERTABLE + 1 BLOCKED(열재단).** **추가 5 = 5 option INSERTABLE / item 6 INSERTABLE + 2 BLOCKED(각목 seq2).**

---

## 10. 설계 결정 필요 / `[CONFIRM]` (리드 에스컬레이션)

### 미해결 `[CONFIRM]` (라이브 실부재/실해석 — 발명 금지)
1. **`[CONFIRM-CHANNEL]` 열재단 = 신규 PROC_000084** — **M-1 ① 확정**(`m1-yeoljaedan-decision.md`): 열재단 = 실제 가공 공정(가격표 권위 3,000원, 0원 "추가없음"과 구분). 완칼 PROC_053 차용은 **폐기**(종이 다이컷, 천 매질 부적합). 열재단 전용 공정 신설 제안 = `11_ddl_proposals/heat-cut-process-proposal`(proc_cd=PROC_000084 채번=라이브 MAX 확인 후 후니 배정·인간 승인). param 없음(flat). 현재 OP-GAGONG-YEOLJAEDAN은 dflt이나 item BLOCKED(공정 신설 대기) → 기본 가공이 적재 불가 → 공정 신설·적재 인간승인 시 해소. **High** 우선.
2. **`[CONFIRM]` 각목 sub_prd_cd** — 각목 완제상품 ref-products 0행 + PRD_000138 sets 0행. **해소 = 각목 완제상품 등록(PRD_000xxx) + t_prd_product_sets 적재**. 발명 금지. 복합옵션 2종(LE900/GT900)의 seq2 직결.
3. **`[CONFIRM]` 양면테입 → {대상:테입}** — L1 `양면테입` ≠ enum `테입`. 합리적 추론이나 엑셀 명시 매핑 아님(validation GAP-4). ref_key1=081은 INSERTABLE이나 param 의미 확정 필요.
4. **`[CONFIRM]` 큐방 enum 확장** — 부착(081) `대상` enum=`라벨/맥세이프/끈/테입`에 `큐방` 없음. ref_key1=081 EXISTS라 item INSERTABLE이나, param `{대상:큐방}`은 enum 외 값 → **enum 확장 vs 별도 처리** 결정 필요.

### 설계 결정 필요 (침묵 선택 안 함)
| # | 결정 사항 | 후보 | 종속 GAP |
|---|---|---|---|
| D-1 | **타공 구수·각목 규격 보존처** | option_items `ref_param_json` 컬럼 추가 vs qty 재사용(불가-구수≠소비량) | **GAP-PARAM**(High) |
| D-2 | **열재단·각목(set) 미적재 처리** | **열재단: M-1 ① 확정 — 열재단 전용 공정 신설 제안 `11_ddl_proposals/heat-cut-process-proposal`(완칼 차용 폐기, 신설·적재 인간승인)** / 각목: 차원 선적재 vs deferred 센티넬 | **GAP-DEFER**(High) — BLOCKED 3행 직결 |
| D-3 | **복합옵션 항목 결합 의미** | `item_combine_typ`(AND동반) 플래그 vs "한 옵션 내 전 item 동반필수" 암묵 규약 | **GAP-COMPOSITE** — 각목+끈 동반 |
| D-4 | **각목 귀속(set vs addon)** | set(`.07` 옵션재료) vs addon(template, 별 주문라인) | (각목=부속이므로 set 1차 권고) |
| D-5 | **사이즈 이원성 표현** | 규격=차원 / 사용자입력=products nonspec 범위+constraint (본 파일럿 채택, products.nonspec_w/h_min/max 현재 NULL → 적재 필요) | size 제약 |

### 워크스루 검증 승계 잔존(본 파일럿 범위 밖)
- **GAP-1(MAJOR)** pick-N/max-N(SEL_TYPE.02) 미행사 — 가공/추가 둘 다 택1(SEL_TYPE.01). 엽서 파일럿 OG-HUGAGONG(SEL_TYPE.02 max4)가 이미 행사 → silsa는 미해당.
- **GAP-2(MAJOR)** excl-group 마이그레이션 — 일반현수막 excl_grp_cd 0행 → 미해당(공백 신규생성이지 변환 아님). 책자/캘린더(GRP-BOOK/CAL)로만 실증 가능.
- **GAP-6(참고)** "종단 실증"은 본 silsa 1종 한정 — 비치수 굿즈·도수 다중 등은 별 상품군 필요.

---

## 부록 — 적재 CSV 인덱스 + 인용 출처

| CSV | 행 | 권위 출처 |
|---|:--:|---|
| `load_silsa/t_prd_product_option_groups.csv` | 2 | silsa-l1 가공/추가 캐스케이드 + master map 패밀리③ verdict |
| `load_silsa/t_prd_product_options.csv` | 11 | silsa-l1.csv row108~113 가공6+추가5 |
| `load_silsa/t_prd_product_option_items.csv` | 9 (INSERTABLE) | ref-product-processes(079/080/081) + ref-processes prcs_dtl_opt + 트리거 §2. note 컬럼 제거(F-1) |
| `load_silsa/t_prd_product_option_items_BLOCKED.csv` | 3 (BLOCKED) | 열재단(신규 PROC_000084 신설대기·M-1 ①)·각목 seq2(set 0행) — 신설/선적재 후 적재 대기. block_reason 컬럼 |
| `load_silsa/t_prd_product_constraints.csv` | 3 | JSONLogic(python 검증 PASS) + L1 row109/111/112 |

| 코드/값 | 출처 |
|---|---|
| PRD_000138 일반현수막 PRD_TYPE.04 nonspec_yn=Y | ref-products.csv / silsa.md §① |
| SIZ_000322 5000x900 / MAT_000182 현수막천 USAGE.07 | ref-product-sizes/materials.csv |
| PROC_000079 타공{구수1~8}·080 봉제{유형,폭}·081 부착{대상:라벨/맥세이프/끈/테입} | ref-processes.csv prcs_dtl_opt |
| 열재단 = 신규 PROC_000084 `[CONFIRM-CHANNEL]` (M-1 ① 확정·완칼 PROC_053 차용 폐기) | m1-yeoljaedan-decision.md / 11_ddl_proposals/heat-cut-process-proposal / 06_extract/price-poster-sign-l1.csv(열재단 3,000원) |
| 각목/큐방 완제상품 0행 · PRD_000138 sets/addons 0행 | ref-products.csv · ref-product-sets/addons.csv |
| nonspec 가로 500~1750·세로 500~5000 / 가공6·추가5 값 | silsa-l1.csv 일반현수막 row108~113 |
| SEL_TYPE.01/.02 · OPT_REF_DIM.01~07 · RULE_TYPE.01/.02/.03 | cpq-schema.md §2/§3 / code-values.md |
