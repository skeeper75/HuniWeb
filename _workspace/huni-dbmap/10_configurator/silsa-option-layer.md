# 일반현수막(PRD_000138) CPQ 옵션 레이어 — 적재본(load-ready) 파일럿 (silsa)

> **상태/이력** 작성 2026-06-07 · **정정 2026-06-08(live-admin-groundtruth LV-1~5 정합)** · `dbm-option-mapper` 산출 · round-6 파일럿 #2(silsa, master map §6 후보 2). DB 미적재(실 INSERT/코드행/DDL = 인간 승인).
> **[2026-06-08 정정 요지]** 라이브 admin 제약 폼빌더 실측 → §5 constraint var 키 전면 정정: 종전 비표준 var(`size_mode/width/height/gagong/chuga`)는 라이브 표준 var 7종(차원 코드 기반)으로 표현 **불가** → silsa 3 constraint = **LV-2 GAP**(라이브 적재 constraint 행 0건, 의도는 target spec으로 보존). 정정 요약 = `silsa-live-reconciliation.md`. 옵션그룹/options/option_items 매핑은 정합 유지(LV-4), L2 전 상품 미적재 확증(LV-3), ref_param_json UI 부재 강화(LV-5).
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
| **R7(신규 2026-06-08)** | constraint var = 임의 키 `size_mode/width/height/gagong/chuga` · 3행 적재 가정 | **라이브 표준 var = 차원 코드 7종** → silsa 3 constraint 전부 비표준 var(수치/모드/opt_cd) 의존 = **표현 불가 → LV-2 GAP**. constraints CSV = live 적재 0건(의도는 target spec 보존). 상세 §5 | live-admin-groundtruth §2.2 LV-1·LV-2 |
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

## 5. constraints — 라이브 표준 var 정합 정정 (LV-1/LV-2)

> **[정정 2026-06-08 · live-admin-groundtruth LV-1]** 본 §5는 당초 var 키로 `size_mode/width/height/gagong/chuga`(비표준 임의 키)를 썼다. 라이브 admin 제약 폼빌더(`/PRD_000138/constraints/`) 실측 결과 **표준 var 키 = 차원 코드 기반 7종**(`siz_cd·plt_siz_cd·mat_cd__usage_cd·proc_cd·bdl_qty·opt_id·sub_prd_cd`)이고, 폼빌더는 **"조건 차원·코드값 ↔ 결과 차원·코드값" 2항 코드 관계만** 지원한다(호환/금지/필수동반). 연속 수치(`width`/`height`)·모드 플래그(`size_mode`)·옵션 선택 정체성(`gagong`/`chuga`=opt_cd)에 대응하는 표준 var는 **라이브에 없다**. 따라서 silsa의 3 constraint는 **표준 var 모델로 표현 불가** = **LV-2 GAP**으로 정직 분리하고, **적재 가능한 live constraint 행으로 산출하지 않는다**(억지 변환 금지). 정정 요약·라우팅은 `silsa-live-reconciliation.md`.

### 5.1 정정 전제 — silsa 제약 3건은 전부 비표준 var 의존

라이브 제약 폼빌더의 표현 단위는 **차원의 코드값**(예: `siz_cd=SIZ_000322` ↔ `proc_cd=PROC_xxx`)이다. silsa 3 constraint는 각각 다음 비표준 요소에 의존한다:

| rule_cd | 의도(도메인) | 의존 var | 표준 var 모델 적합? | 판정 |
|---|---|---|---|:--:|
| `R-SIZE-NONSPEC` | 사용자입력 시 가로 500~1750·세로 500~5000 | `size_mode`(모드)·`width`/`height`(**연속 수치**) | 표준 var에 수치/모드 **없음** | **GAP (표현 불가)** |
| `R-GAKMOK-HEIGHT` | 각목(900이하)→세로≤900·(900초과)→세로>900 | `chuga`(opt_cd)·`height`(**연속 수치**) | 결과측이 수치 + 조건측 각목=BLOCKED(sub_prd_cd 미상) | **GAP (이중 불가)** |
| `R-BONGJE-PARAM` | 봉미싱 선택 시 가로·세로>0 | `gagong`(opt_cd→`proc_cd` 환원 가능)·`width`/`height`(**연속 수치**) | 조건 반만 표준화 가능, 결과측 수치 불가 | **GAP (부분 불가)** |

> **부분 분석(R-BONGJE):** 조건측 `봉미싱 선택`은 option_item이 `proc_cd=PROC_000080`을 참조하므로 표준 var `proc_cd`로 `{"==":[{"var":"proc_cd"},"PROC_000080"]}` 표현이 *가능*하다. 그러나 결과측 `width>0 AND height>0`은 연속 수치라 표준 var 부재 → **규칙 전체는 표현 불가**. 조건 반쪽만 표준화돼도 완결 규칙이 못 되므로 GAP으로 둔다(반쪽 변환은 의미 왜곡).

> **R-GAKMOK 이중 불가:** ① 조건측 `각목(900이하/초과)`은 두 opt 모두 셋트 차원(`.07 sub_prd_cd`)이나 sub_prd_cd 미상(BLOCKED, §1·§4) → 표준 var `sub_prd_cd`로도 코드 부재. ② 결과측 `세로≤900`은 연속 수치라 var 부재. 두 측 모두 표준화 불가.

### 5.2 LV-2 GAP — 비치수 사이즈 범위·파라미터 제약의 검증처

silsa 3 constraint가 검증하려는 것은 라이브 제약 메커니즘(차원 코드 2항 관계) **밖**의 입력 유효성이다. 어디서 검증돼야 하는지 후보를 제시하되 **침묵 선택하지 않는다**(도메인/ddl-proposer 결정 라우팅).

| GAP ID | 미표현 규칙 | 후보 검증 메커니즘 | 라우팅 |
|---|---|---|---|
| **R-SIZE-NONSPEC** | 비치수(nonspec) 가로·세로 범위 | (A) `t_prd_products`에 `nonspec_w_min/max·nonspec_h_min/max` 범위 컬럼 신설 + 앱 런타임 검증 / (B) 비표준 var(`width`/`height`) 허용하도록 JSONLogic 평가 컨텍스트 확장 + 고급 JSONLogic 직접입력 | **ddl-proposer**(컬럼 신설) 또는 **도메인 결정**(평가 컨텍스트 확장). 기존 GAP "비치수 size"와 동일 뿌리 |
| **R-GAKMOK-HEIGHT** | 각목 규격 ↔ 세로 수치 정합 | 각목 sub_prd_cd 선등록(BLOCKED 해소) **후에도** 결과측 수치라 표준 불가 → (B) 비표준 var JSONLogic 또는 (C) 앱 런타임 | **도메인 결정** — 각목 set 적재 + 수치 검증처 동시 결정 |
| **R-BONGJE-PARAM** | 봉미싱 시 사이즈 확정 필수 | 조건측 `proc_cd` 표준화 가능하나 결과측 수치 → (B)/(C) | **도메인 결정** |

> **핵심:** 이 셋은 전부 **연속 수치 범위 검증**이라는 한 부류다. 라이브 제약 폼빌더는 "코팅지→박 금지" 류 **차원 호환성** 검증용이지 **수치 범위** 검증용이 아니다. 비치수 사이즈 범위 검증은 별도 메커니즘(products 범위 컬럼+앱 검증 가장 유력)이 정답일 가능성이 높다 — 이는 라운드 누적 GAP "비치수 size"(D-5)와 같은 결정이다.

### 5.3 적재 영향 — constraints CSV = live 행 0건

→ `load_silsa/t_prd_product_constraints_GAP.csv`(정식 테이블명 `t_prd_product_constraints` ≠ 파일명 — 적재 glob 격리, items `_BLOCKED.csv`와 일관)는 **적재 가능한 live constraint 행을 산출하지 않는다**(3건 전부 GAP). 종전 3행(비표준 var)은 라이브 폼빌더로 입력 불가·고급 JSONLogic 직접입력으로도 비표준 var 평가 컨텍스트 미보장 → 적재 대상에서 제외하고 **GAP 참조용으로만** CSV에 보존(컬럼에 `status=GAP`·`gap_reason` 추가, live 적재 SQL 대상 아님 명시). `t_prd_products.constraint_json` compile 캐시도 **현재 silsa 기준 비움**(활성 live 규칙 0건) — 비치수 범위 검증처가 결정되기 전까지 NULL.

> **도메인 의도는 보존(무손실).** 가로 500~1750·세로 500~5000·각목규격↔세로·봉미싱 사이즈필수 라는 **검증 의도 자체는 silsa-l1.csv row109/111/112 권위로 유효**하다. 다만 그 검증의 *구현처*가 라이브 제약 테이블이 아닐 뿐이다. 아래 의도 JSONLogic은 **목표 사양(target spec)** 으로 보존하되, 라이브 적재본이 아니라 GAP 사양임을 명시한다.

**의도 사양(target spec — 라이브 적재 아님, 비표준 var 평가 컨텍스트 가정):**
```jsonc
// R-SIZE-NONSPEC (의도): nonspec 시 가로 500~1750·세로 500~5000
{ "or": [ {"!=":[{"var":"size_mode"},"nonspec"]},
          {"and":[{">=":[{"var":"width"},500]},{"<=":[{"var":"width"},1750]},
                  {">=":[{"var":"height"},500]},{"<=":[{"var":"height"},5000]}]} ] }
// R-GAKMOK-HEIGHT (의도): 각목규격 ↔ 세로 (조건측은 sub_prd_cd 확정 후, 결과측은 수치 — 둘 다 GAP)
// R-BONGJE-PARAM (의도): proc_cd=PROC_000080 선택 시 width·height>0 (조건측만 표준화 가능)
```
> 위 3 사양은 **GAP-NONSPEC-RANGE**로 등록(§9). 검증 손계산(종전 6케이스 PASS/FAIL 표)은 *의도 정확성* 증빙으로 유효하나, **라이브 제약 행으로는 미적재**다 — 평가 컨텍스트가 비표준 var를 수용해야 동작하므로 그 결정(products 범위 컬럼 vs 평가 컨텍스트 확장)이 선행 조건이다.

**[정합 메모 — LV-3/4/5]**
- **LV-3 (전 상품 L2 미적재):** 라이브 admin 실측 결과 일반현수막 포함 **모든 상품의 옵션그룹/제약/SKU = 0행**(중철책자·엽서북·프리미엄엽서/명함 교차확인). `cpq-schema.md`가 인용한 "GRP-BOOK 13행 선례"는 **코드값(SEL_TYPE 등) 선례이지 적재된 옵션그룹 행이 아님**(정정). → silsa 적재 시 **라이브 최초 옵션 레이어 사례**가 된다. 본 §2 option_groups·§3 options·§4 option_items 적재본은 그 최초 사례의 후보다.
- **LV-4 (디스패치 정합 재확인):** 라이브 제약 폼 표준 var 표가 **도수=`opt_id`(NOT clr_cd)** · **자재=`mat_cd__usage_cd` 복합슬롯**을 그대로 확증. silsa §4 디스패치(공정=`.04` ref_key1=proc_cd·셋트=`.07` sub_prd_cd)와 일치 → **보강 불요**.
- **LV-5 (ref_param_json 라이브 UI 부재 강화):** 라이브 admin 옵션그룹 추가 폼·제약 폼빌더·SKU 폼 **어디에도 파라미터(구수·각목규격) 입력 필드 없음**. 옵션아이템 레벨 폼은 그룹 1개+ 저장 후 드릴다운 가능(쓰기 금지로 미확인)이나, 제약 폼조차 param 미수용 → GAP-PARAM(D-1) **강화**(스키마 미구현이 UI에서도 재확증).

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
[4] t_prd_product_constraints (live 적재 0행)  — silsa 3 constraint = LV-2 GAP(비표준 var, §5). 적재 대상 아님(target spec만 보존)
[5] UPDATE t_prd_products.constraint_json     — 활성 live 규칙 0건이라 NULL 유지(비치수 범위 검증처 결정 후 채움)
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
| constraints | 3 | **0** | 0 | **3건 전부 LV-2 GAP**(비표준 var, §5) → live 적재 0건. CSV는 `status=GAP`로 target spec만 보존(적재 SQL 대상 아님) |
| **합계** | **28** | **22** | **3** | 적재 CSV 합 = **22행**(option_groups 2 + options 11 + option_items 9). 3 BLOCKED은 분리 CSV. constraints는 live 적재 0(GAP). constraint_json UPDATE = NULL 유지 |

> 옵션 값 기준: **가공 6 = 5 INSERTABLE + 1 BLOCKED(열재단).** **추가 5 = 5 option INSERTABLE / item 6 INSERTABLE + 2 BLOCKED(각목 seq2).**
> **constraint(LV-1/2 정정):** 종전 "3 INSERTABLE" → **0 INSERTABLE**(비표준 var로 라이브 표현 불가). 적재 가능 행수 25→**22**. 비치수 범위·파라미터 검증은 별도 메커니즘(products 범위 컬럼+앱 vs 비표준 var JSONLogic) 결정 후 닫힘 = GAP-NONSPEC-RANGE.

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
| D-5 | **사이즈 이원성 표현 + 비치수 범위 검증처(LV-2 정정)** | 규격=차원 / 사용자입력=**라이브 제약 폼빌더 표현 불가**(수치 var 부재). 후보: (A) `t_prd_products.nonspec_w_min/max·nonspec_h_min/max` 컬럼 신설+앱 런타임 검증(유력) (B) JSONLogic 평가 컨텍스트에 비표준 var(width/height) 허용+고급 직접입력 | **GAP-NONSPEC-RANGE**(High) — R-SIZE/GAKMOK/BONGJE 3건 직결 |
| D-6 | **silsa 3 constraint 검증처(신규, LV-2)** | R-SIZE-NONSPEC·R-GAKMOK-HEIGHT·R-BONGJE-PARAM = 전부 연속수치 범위 검증 → 라이브 제약 테이블 부적합. products 범위 컬럼+앱 검증 vs 비표준 var JSONLogic 평가 컨텍스트 확장 | **GAP-NONSPEC-RANGE**(High) → ddl-proposer/도메인 결정 |

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
| `load_silsa/t_prd_product_constraints_GAP.csv` | 3 (GAP, live 적재 0) | **LV-2 GAP**(비표준 var) — `_GAP.csv` 접미로 적재 glob 격리(items `_BLOCKED.csv`와 일관·F-silsa-1 해소). `status=GAP`·`gap_reason` 컬럼, target spec 보존. 적재 SQL 대상 아님. L1 row109/111/112 |

| 코드/값 | 출처 |
|---|---|
| PRD_000138 일반현수막 PRD_TYPE.04 nonspec_yn=Y | ref-products.csv / silsa.md §① |
| SIZ_000322 5000x900 / MAT_000182 현수막천 USAGE.07 | ref-product-sizes/materials.csv |
| PROC_000079 타공{구수1~8}·080 봉제{유형,폭}·081 부착{대상:라벨/맥세이프/끈/테입} | ref-processes.csv prcs_dtl_opt |
| 열재단 = 신규 PROC_000084 `[CONFIRM-CHANNEL]` (M-1 ① 확정·완칼 PROC_053 차용 폐기) | m1-yeoljaedan-decision.md / 11_ddl_proposals/heat-cut-process-proposal / 06_extract/price-poster-sign-l1.csv(열재단 3,000원) |
| 각목/큐방 완제상품 0행 · PRD_000138 sets/addons 0행 | ref-products.csv · ref-product-sets/addons.csv |
| nonspec 가로 500~1750·세로 500~5000 / 가공6·추가5 값 | silsa-l1.csv 일반현수막 row108~113 |
| SEL_TYPE.01/.02 · OPT_REF_DIM.01~07 · RULE_TYPE.01/.02/.03 | cpq-schema.md §2/§3 / code-values.md |
