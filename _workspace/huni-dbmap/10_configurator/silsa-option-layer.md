# 일반현수막(PRD_000138) CPQ 옵션 레이어 — 적재본(load-ready) 파일럿 (silsa)

> **상태/이력** 작성 2026-06-07 · **정정 2026-06-08(live-admin-groundtruth LV-1~5 정합)** · **재정합 2026-06-08-B(가격표 B26 + 도메인·경쟁사 리서치 + 사용자 HARD 확정)** · `dbm-option-mapper` 산출 · round-6 파일럿 #2(silsa, master map §6 후보 2). DB 미적재(실 INSERT/코드행/DDL = 인간 승인).
> **[2026-06-08-B 재정합 요지 — 사용자 HARD 권위]** 기존 silsa는 **인쇄상품 가격표(포스터사인 B26)를 미대조**하여 사이즈를 **비치수 연속범위(R-SIZE-NONSPEC)로 오판**했다. 사용자 확정·가격표 권위로 전면 정정: ① **사이즈 = 이산 5×16 매트릭스 규격**(입력 UX=프리셋+자유입력 혼합 / 가격·유효성 권위=이산 매트릭스, 가로 하한 **900**, off-grid=가로·세로 각각 ceiling[앱]). **비치수 연속범위(R-SIZE-NONSPEC)·products nonspec 범위 컬럼(D-5/DD-1) 폐기.** 라이브 sizes 적재 = 가격트랙 결과 참조(4 존재 / 76 미등록 GAP). ② **R-GAKMOK = 각목↔세로변 900 기준**(사용자 확정: 900mm 기준=세로 높이변)으로 재작성 — 이산 사이즈 하에서 표현 가능성 재검토. ③ **옵션 추가가격 = 가격트랙 component 분리**(옵션 레이어는 가격 미보유, 연결만 — `02_mapping/silsa-poster-area-matrix` + 사이드바 옵션가). ④ sel_typ = 가격표 캐스케이드(한 셀=한 값)+Red pcs type 근거 판정.
> **[2026-06-08-A 선행 정정]** 라이브 admin 제약 폼빌더 실측 → §5 constraint var 키 정정: 비표준 var는 라이브 표준 var 7종(차원 코드 기반)으로 표현 검토. 옵션그룹/options/option_items 매핑 정합(LV-4), L2 전 상품 미적재(LV-3), ref_param_json UI 부재(LV-5).
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
| **R7(2026-06-08-A)** | constraint var = 임의 키 `size_mode/width/height/gagong/chuga` · 3행 적재 가정 | **라이브 표준 var = 차원 코드 7종** → 비표준 var 의존 정정(상세 §5) | live-admin-groundtruth §2.2 LV-1 |
| **R8(2026-06-08-B · 사용자 HARD·가격표 권위 — 사이즈 재정합)** | 사이즈 = **비치수 연속범위**(R-SIZE-NONSPEC, 가로500~1750·세로500~5000) | **사이즈 = 이산 5×16 매트릭스 규격**(입력 UX=프리셋+자유입력 혼합 / 가격·유효성=이산 매트릭스, 가로 하한 **900**, off-grid=가로·세로 각각 ceiling[앱]). **R-SIZE-NONSPEC·products `nonspec_*` 범위 컬럼 제안 폐기.** siz 80규격=4 존재/76 미등록 | **가격표 B26**(silsa-price-table-gap §1.1)·banner-domain-competitor-research A·`02_mapping/silsa-poster-area-matrix §3` · 사용자 HARD |
| **R9(2026-06-08-B · 사용자 HARD — 제약 재정합)** | silsa 3 constraint 전부 연속수치 var = LV-2 GAP(표현 불가) | 이산 siz_cd 재정합으로: **R-SIZE-NONSPEC 폐기**(유효성=가격 셀)·**R-BONGJE 불요**(사이즈 필수 공통전제)·**R-GAKMOK=각목↔세로변 900 siz_cd 집합 호환**(세로변 기준·**DB jsonb 저장 가능, 폼빌더 배열-멤버십 입력 미검증** — F-1 → 차원+입력방식 선등록 GAP-DEFER). R-SIZE-NONSPEC분(연속수치)은 일반현수막서 **해소** | 사용자 HARD(각목 세로변 기준) · live-admin var 표 |
| **R10(2026-06-08-B · 사용자 HARD — 옵션가 위임)** | 옵션 추가가격 미반영(0 누락, PG-2) | 옵션 추가가격 = **가격트랙 component 분리**(가공/추가 component, B26 사이드바 J/K·M/N). 옵션 레이어는 가격 미보유·연결만(공정/셋트 환원 유지) | silsa-price-table-gap §1.2/§1.3 · banner-research B.3 · 사용자 HARD |
| **R6** | 거치대 add-on(Step 5, 메쉬배너 거치대 차용 시나리오) | **삭제** — 사용자 제공 캐스케이드에 거치대 없음(L1 일반현수막=끈/큐방/각목만). 추측 add-on 미인스턴스화(scope discipline) | silsa-l1.csv 일반현수막 추가 5값에 거치대 부재 |

> **추가 정련(F-1, dbm-validator round-6 교훈):** ① `t_prd_product_option_items.csv`는 `note` 컬럼이 라이브 부재라 적재 CSV에서 제거 — 적재 CSV는 라이브 컬럼만(`prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn`). 프로비넌스는 본 §3·§4·options CSV note·분리 CSV `block_reason`에 보존(무손실). ② option_items 적재 CSV=INSERTABLE 9행, BLOCKED 3행은 분리 CSV(`..._BLOCKED.csv`, `block_reason` 컬럼)로 격리(round-5 차단행 분리 패턴).
> **거치대 제외 사유(R6 보강):** 워크스루는 "template 메커니즘 실증"을 위해 메쉬배너 거치대를 일반현수막에 차용했으나, 이는 실데이터에 없는 가상 시나리오였다(워크스루 §5.2(e)#5도 `[CONFIRM]`으로 자인). 본 적재본은 **사용자 제공 캐스케이드 = 권위**이므로 거치대 템플릿/selections/addons를 산출하지 않는다(엽서 파일럿이 봉투 add-on을 이미 실증함 — 중복 불요). 따라서 templates/template_selections/addons CSV는 본 파일럿에 없음.

---

## 1. Step 0 — 차원행 전제 (option_item이 참조할 라이브 차원 확인)

[HARD] option_item은 *이미 적재된 차원행*을 가리키는 포인터다. 트리거 `fn_chk_opt_item_ref`가 "그 prd_cd에 등록된 차원행 EXISTS"를 강제하므로, 등록 전 차원행 실재를 확인한다(ref-*.csv 스냅샷, 존재 판정=라이브 권위).

| 차원 | 라이브 적재(PRD_000138) | option_item 참조 가능? | 출처 |
|------|------------------------|:----------------------:|------|
| **size** `OPT_REF_DIM.01` | **이산 5×16 매트릭스 = 80규격**(가로{900,1000,1200,1500,1750}×세로{900…5000}, 가격표 B26 권위). 라이브 t_siz_sizes 검색: **4 존재**(SIZ_000320 900×1200·SIZ_000321 600×1800·SIZ_000323 900×900·SIZ_000403 1500×1000) / **76 미등록 = GAP**(가격트랙 제안 SIZ_000538~000618, 인간승인). | △ 4규격만 / **76 BLOCKED**(siz 선등록 대기) | `02_mapping/silsa-poster-area-matrix/mapping.md` §3(siz RESOLUTION) — **가격트랙 권위**, ref-product-sizes.csv |
| **material(소재)** `OPT_REF_DIM.03` | **1행** MAT_000182 (현수막천, MAT_TYPE.08, usage=USAGE.07, dflt=Y) | ✅ (단 소재 그룹 본 파일럿 미생성 — 단일 소재) | ref-product-materials.csv |
| **process(공정)** `OPT_REF_DIM.04` | **3행** PROC_000079(타공)·PROC_000080(봉제)·PROC_000081(부착) — 전부 mand_proc_yn=N·excl_grp_cd 공백 | ✅ 타공/봉제/부착만 / ❌ **PROC_000053(완칼)·기타 0행** | ref-product-processes.csv (silsa.md G-SL-5) |
| **set(셋트)** `OPT_REF_DIM.07` | **0행** | ❌ 각목 sub_prd_cd → 각목 seq2 BLOCKED | ref-product-sets.csv(PRD_000138 부재) |
| **plate_size** `OPT_REF_DIM.02` | 1행(현수막천 출력 JPG, 라이브 plate=작업사이즈 행) | ✅ (보통 미노출 — 판형) | ref-product-plate-sizes.csv |
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

| opt_grp_cd | opt_grp_nm | sel_typ_cd | min | max | mand_yn | disp_seq | sel_typ 판정 근거 |
|---|---|---|:--:|:--:|:--:|:--:|---|
| `OG-GAGONG` | 가공 | **SEL_TYPE.01 (택1)** `[CONFIRM-MULTI]` | 1 | 1 | **Y** | 1 | 가격표 B26 캐스케이드=가공 1컬럼·한 셀=한 값(택1). 필수(열재단 기본, B26 J/K 컬럼에 "추가없음" 미존재=가공 항상 선택). **단** Red 현수막 pcs `type`은 일부 checkbox(복수)도 존재 → 일반현수막 가공이 진짜 택1인지 [CONFIRM](§아래) |
| `OG-CHUGA` | 추가 | **SEL_TYPE.01 (택1)** `[CONFIRM-MULTI]` | 0 | 1 | N | 2 | 가격표 B26 추가=1컬럼·한 셀=한 값(택1)+"추가없음" 센티넬 존재=선택(min=0). 단 큐방+각목 동시 등 복수 거치 가능성 → [CONFIRM] |

> **sel_typ 판정 근거(사용자 확정 권위 — 일률 강제 금지):** ① **1차 권위 = 가격표 B26 캐스케이드.** B26 J/K(가공)·M/N(추가) 컬럼이 **각각 단일 선택 컬럼**(한 행=한 가공값/한 추가값, 조합열 없음) → 캐스케이드 한 셀=한 값 = **택1(SEL_TYPE.01·max=1)**. 가공엔 "추가없음" 항목이 없음=항상 1개 선택=필수(mand_yn=Y). 추가엔 "추가없음=0원" 센티넬 존재=선택(min=0). ② **2차 교차참조 = Red 현수막 pcs `type`**(banner-domain-research D.1·D.3): Red `pdt_pcs_info`는 그룹별 `type`이 radio(필수택1)/select(택1)/checkbox(복수) 혼재 — 즉 현수막 가공이 **상품마다 택1 또는 복수**일 수 있음. 일반현수막은 B26 캐스케이드 기준으로 **택1 1차 판정**하되, "여러 가공(예 타공+봉미싱) 동시 적용 가능한가"는 가격표만으론 불확실 → **`[CONFIRM-MULTI]`**(복수 가능 시 SEL_TYPE.02·max>1로 정정, banner-research Q-5). **옵션그룹 sel_typ이 컨피규레이터의 존재 이유**(사용자 확정) — 일률 강제하지 않고 근거 명시+불확실 [CONFIRM].
> **excl-group 관계:** 이 두 그룹이 기존 `t_prd_product_process_excl_groups`의 일반화 형태 — 일반현수막엔 excl_group 0행(silsa.md §③), 가공 택일=process excl-group의 일반 옵션그룹 표현. **단 "공백에서 신규 표현"이지 기존 excl-group 변환 실증 아님**(GAP-2 미행사, §10).
> **사이즈 그룹 미생성(설계 결정·재정합 2026-06-08-B):** 사이즈 = **이산 5×16 매트릭스 규격**(가로{900,1000,1200,1500,1750}×세로 16규격, 가격표 B26 권위). 입력 UX는 **혼합**(프리셋 5규격 + 자유입력)이나 **가격·유효성 권위는 이산 매트릭스**다. 종전 "하이브리드(규격행+nonspec 연속범위)" 모델은 **폐기** — 자유입력 off-grid 치수는 새 가격을 만들지 않고 **가로·세로 각각 한 단계 큰 규격으로 ceiling**(앱 런타임, DB는 매트릭스 셀단가만, 사용자 확정·B26 G247). 사이즈는 상품 진입 시 1차 선택축으로 UI 상단 고정 → option_group 미노출(80규격을 option_items로 열거하지 않고 size 차원으로 직접 룩업). **유효 사이즈 = 가격 매트릭스 존재 여부**(가로<900 등 매트릭스 밖 = 주문불가, 가격엔진 판정). 가로 하한 900(상품마스터 500~900은 입력 폼 잔재일 뿐 주문불가, 사용자 확정). 사이즈 모드 토글·자유입력 검증은 §5 참조. (`[CONFIRM]` 사이즈 그룹 노출 = UI 정책.)
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

## 5. constraints — 재정합 (R-SIZE-NONSPEC 폐기 · R-GAKMOK 세로변 재작성 · 이산사이즈 하 표현가능성 재검토)

> **[재정합 2026-06-08-B · 사용자 HARD 확정]** 본 §5 전면 재작성. ① **R-SIZE-NONSPEC 폐기** — 사이즈는 비치수 연속범위가 아니라 **이산 5×16 매트릭스 규격**. 유효성은 "범위 검증 constraint"가 아니라 **가격 매트릭스 셀 존재 여부**(가격엔진)로 판정 → constraint 불요(폐기). ② **R-GAKMOK = 각목↔세로변 900 기준**(사용자 확정: 각목 900mm 기준=세로 높이변). ③ **이산 사이즈 하에서 표현가능성 재검토** — 종전 "전부 연속수치 var라 GAP"은 nonspec 전제. 사이즈가 **이산 siz_cd 차원**이 되면 "세로변>900"은 siz_cd **집합 멤버십**으로 환원 가능 → 표준 폼빌더(차원 2항 관계)로 **표현 가능성 재검토**.
> **[선행 2026-06-08-A · LV-1]** 라이브 admin 제약 폼빌더 표준 var = 차원 코드 7종(`siz_cd·plt_siz_cd·mat_cd__usage_cd·proc_cd·bdl_qty·opt_id·sub_prd_cd`), "조건 차원·코드값 ↔ 결과 차원·코드값" 2항 코드 관계만 지원(호환/금지/필수동반).

### 5.1 재정합 후 제약 3건 판정 (이산사이즈 권위)

라이브 제약 폼빌더의 표현 단위는 **차원의 코드값**(예: `siz_cd=SIZ_000320` ↔ `sub_prd_cd=각목`)이다. 사이즈를 **이산 siz_cd 차원**으로 재정합하면 종전 GAP 판정이 다음과 같이 바뀐다:

| rule_cd | 재정합 의도 | 의존 차원 | 이산 siz_cd 하 표현? | 판정 |
|---|---|---|---|:--:|
| ~~`R-SIZE-NONSPEC`~~ **폐기** | (구) 비치수 연속범위 가로500~1750·세로500~5000 | — | **불요** — 사이즈=이산 매트릭스, 유효성=가격 셀 존재(가격엔진). 범위 constraint 자체가 nonspec 오판 산물 | **폐기(DELETED)** |
| `R-GAKMOK-HEIGHT` | **각목(900이하)→세로변≤900인 siz / (900초과)→세로변>900인 siz** (사용자 확정: 900=세로 높이변) | `sub_prd_cd`(각목) ↔ `siz_cd`(세로변 기준 집합) | **DB jsonb(logic) 저장은 가능** — siz_cd 이산 코드라 의도를 jsonb logic으로 표현 가능. **단 라이브 admin 폼빌더의 배열-멤버십(in+75 siz_cd 배열) 입력 지원은 미검증**(LV-1 실측=단일 코드값 2항만). 선행 ① 각목 sub_prd_cd ② siz 76 등록 ③ **폼빌더 입력 방식(배열 1행 vs 75 단일행 분해) 확정** | **GAP-DEFER** |
| `R-BONGJE-PARAM` | 봉미싱 선택 시 사이즈 확정 필수 | `proc_cd=PROC_000080` ↔ siz 선택 존재 | 이산 매트릭스에선 **사이즈 선택이 가격 룩업의 기본 전제** → 봉미싱 전용 제약 불요 가능성 | **재검토 — 불요 가능성** |

> **R-GAKMOK-HEIGHT 재작성(사용자 확정 — 세로변 기준):** 각목은 현수막 상·하변에 끼워 거는 거치 부자재. 사용자 확정에 따라 **각목 900mm 기준 = 세로(높이)변** 길이다. 따라서 각목(900이하)↔세로변≤900인 siz_cd, 각목(900초과)↔세로변>900인 siz_cd 만 호환. 이산 매트릭스(세로 16규격{900,1000,1200,…,5000})에서 "세로변>900인 siz" = {1000,1200,…,5000}×가로5 = 75 siz_cd 집합, "세로변≤900" = {900}×가로5 = 5 siz_cd 집합으로 **열거 가능**.
> **[F-1 정정 2026-06-08 — over-claim 철회]** 종전 본 문단은 "라이브 폼빌더가 이 집합 멤버십을 표현 가능 → 표현 가능"으로 단정했으나 이는 **over-claim**이다. 인용한 live-admin-groundtruth **LV-1 실측은 단일 코드값 2항 관계만** 보여줬고, **라이브 admin 폼빌더가 배열 멤버십(`in` + 75개 siz_cd 배열) 입력을 지원하는지는 미검증**이다(groundtruth LV-2는 R-GAKMOK을 "표준 표현 불가"로 판정 — §5가 "이산화하면 해소"로 봉합한 것을 정정). **정확한 판정**: 의도를 **DB jsonb(`logic`) 컬럼에 직접 저장하는 것은 가능**(연속수치 var 불필요·차원 코드 기반)하나, **라이브 admin 폼빌더의 배열-멤버십 입력 지원은 미검증**이다. 따라서 선행 조건은 셋: **① 각목 sub_prd_cd 선등록, ② siz_cd 76규격 선등록, ③ 폼빌더 입력 방식 확정**(배열 1행 `in`-멤버십을 폼빌더/고급 JSONLogic 직접입력으로 넣는지, 아니면 `sub_prd_cd↔siz_cd` 75 단일행으로 분해 입력하는지). 세 선행이 충족되면 라이브 적재 가능 = **GAP-DEFER**(BLOCKED 사유·분류 유지 — "표현 가능" 단정만 철회, 번복 아님).

> **R-BONGJE 재검토:** 이산 매트릭스에선 사이즈 선택이 가격 룩업 전제(사이즈 미선택=가격 없음)라 "봉미싱 시 사이즈 필수"는 **모든 가공 공통 기본 전제**일 뿐 봉미싱 전용 제약이 아니다 → 별도 constraint **불요 1차 판정**. 봉미싱이 특정 사이즈 범위를 요구하는 도메인 근거는 가격표·리서치에 없음. 봉미싱 전용 사이즈 제약이 실재하면 [CONFIRM].

### 5.2 재정합 후 제약 처리 — R-SIZE-NONSPEC 폐기 · R-GAKMOK 해소조건부

| rule_cd | 재정합 처리 | 선행 조건 | 라우팅 |
|---|---|---|---|
| ~~R-SIZE-NONSPEC~~ | **폐기(DELETED)** — 사이즈=이산 매트릭스, 유효성=가격 셀 존재(가격엔진). 비치수 범위 검증 constraint·products `nonspec_*` 범위 컬럼(종전 D-5/DD-1 제안) 모두 **불요·폐기** | 없음 | **종결** — ddl-proposer "비치수 size" GAP 중 일반현수막분 철회 |
| **R-GAKMOK-HEIGHT** | **DB jsonb(logic) 저장 가능**(siz_cd 집합 멤버십, 세로변 900 기준, 연속수치 var 불필요). **단 라이브 admin 폼빌더의 배열-멤버십 입력 지원은 미검증**(LV-1=단일 코드값 2항만) | ① 각목 sub_prd_cd 선등록(set), ② siz_cd 76규격 선등록(가격트랙), ③ **폼빌더 입력 방식 확정**(배열 1행 vs 75 단일행 분해) | **GAP-DEFER**(차원+입력방식 선행) |
| **R-BONGJE-PARAM** | **불요 1차 판정** — 사이즈 필수 선택이 모든 가공 공통 전제. 봉미싱 전용 사이즈 제약 도메인근거 없음 | 없음 | **종결 후보**([CONFIRM] 봉미싱 전용 제약 실재 여부) |

> **핵심 전환:** 종전 판정 "3건 전부 연속수치 범위 검증이라 라이브 제약 폼빌더로 표현 불가(LV-2 GAP)"는 **사이즈를 nonspec 연속으로 오판한 데서 나온 결론**이었다. 사이즈를 **이산 siz_cd 차원**으로 재정합하면 ① R-SIZE-NONSPEC은 **존재 이유가 사라지고**(가격 셀 존재가 유효성), ② R-GAKMOK은 **연속수치가 아니라 siz_cd 집합 호환성**이 되어 의도를 **DB jsonb(logic)로 표현 가능**(차원 선등록 후 — **단 라이브 폼빌더의 배열-멤버십 입력 지원은 미검증**, F-1), ③ R-BONGJE는 **공통 전제**라 불요. 즉 비치수 size 검증처 GAP 중 **R-SIZE-NONSPEC분(연속수치 범위)은 일반현수막에서 해소**되나, R-GAKMOK은 폼빌더 입력방식 확정이 남은 GAP-DEFER다.

### 5.3 적재 영향 — constraints CSV = live 행 0건(현 시점), R-GAKMOK은 차원 선등록 후 승격

→ `load_silsa/t_prd_product_constraints_GAP.csv`는 **현 시점 라이브 적재 0행**이나 사유가 재정합으로 바뀐다:
> - **R-SIZE-NONSPEC = 폐기**(적재 후보에서 영구 제외, 사이즈=이산 매트릭스라 범위 constraint 불요).
> - **R-GAKMOK-HEIGHT = 해소조건부 GAP-DEFER**. 각목 sub_prd_cd + siz_cd 76규격 선등록 + 폼빌더 입력방식 확정 시 적재 가능. **DB jsonb(logic) 저장은 가능하나 라이브 admin 폼빌더의 배열-멤버십 입력 지원은 미검증**(F-1).
> - **R-BONGJE-PARAM = 불요 1차 판정**(사이즈 필수가 공통 전제).
>
> `t_prd_products.constraint_json` compile 캐시는 **현재 활성 live 규칙 0건이라 NULL**이되, R-GAKMOK이 차원 선등록 후 적재되면 그 1건으로 채워진다(종전 "비치수 범위 검증처 결정 전까지 NULL"에서 "각목·siz 차원 선등록 후 R-GAKMOK 적재"로 변경).
> **[F-2 컬럼 매핑 명시]** `t_prd_product_constraints_GAP.csv`의 헤더 `logic_target_spec`은 **라이브 컬럼 `logic`(jsonb)과 이름이 다르다**(target spec임을 표기하려는 의도적 보조명). **라이브 적재 시 `logic_target_spec` → `logic`(jsonb)로 매핑**해 INSERT한다(현 0행 적재라 무해하나 적재 대비). `status`·`gap_reason`은 보조 추적 컬럼으로 적재 대상 아님(라이브 부재).

> **도메인 의도 보존 + 재정합:** 각목규격↔세로변 정합 검증 의도는 silsa-l1.csv row111/112 권위로 유효. 재정합으로 이 의도는 **연속수치 GAP이 아니라 siz_cd 집합 호환성**으로 **DB jsonb(logic) 표현 가능**해졌다(폼빌더 배열-멤버십 입력 지원은 미검증 — F-1). R-GAKMOK 적재 target spec(차원 선등록 + 입력방식 확정 후 jsonb logic 형태):

**R-GAKMOK-HEIGHT 적재 target spec (각목 sub_prd_cd + siz_cd 76 선등록 가정 — 세로변 900 기준):**
```jsonc
// 각목(900이하) 선택 ↔ 세로변≤900 siz_cd 집합만 호환(RULE_TYPE.01 호환)
// 폼빌더: 조건 차원=셋트(sub_prd_cd=각목900이하코드) → 결과 차원=사이즈(siz_cd ∈ {세로900×가로5규격})
// 각목(900초과) 선택 ↔ 세로변>900 siz_cd 집합(75규격)만 호환
// siz_cd 집합은 라이브 적재 후 실코드로 열거(가격트랙 SIZ_000538~000618 채번 결과 참조)
{ "and": [
  {"if":[{"==":[{"var":"sub_prd_cd"},"[각목900이하 sub_prd_cd]"]},
         {"in":[{"var":"siz_cd"},["[세로900 siz 5규격...]"]]}, true]},
  {"if":[{"==":[{"var":"sub_prd_cd"},"[각목900초과 sub_prd_cd]"]},
         {"in":[{"var":"siz_cd"},["[세로>900 siz 75규격...]"]]}, true]}
] }
```
> 위는 **연속수치 var(width/height)를 쓰지 않는다** — 전부 차원 코드(sub_prd_cd·siz_cd) 기반이라 **DB jsonb(logic) 저장에 적합**. 선행 조건은 셋: 차원행 선등록(각목 set + siz 76) + **폼빌더 입력 방식 확정**(배열 1행 `in`-멤버십을 폼빌더/고급 JSONLogic 직접입력으로 넣는지 vs 75 단일행 분해 — 라이브 폼빌더 배열 입력 지원 미검증, F-1) → **GAP-DEFER**(§9). R-SIZE-NONSPEC·R-BONGJE의 종전 target spec(연속수치 의도)은 **폐기/불요**로 제거.

**[정합 메모 — LV-3/4/5]**
- **LV-3 (전 상품 L2 미적재):** 라이브 admin 실측 결과 일반현수막 포함 **모든 상품의 옵션그룹/제약/SKU = 0행**(중철책자·엽서북·프리미엄엽서/명함 교차확인). `cpq-schema.md`가 인용한 "GRP-BOOK 13행 선례"는 **코드값(SEL_TYPE 등) 선례이지 적재된 옵션그룹 행이 아님**(정정). → silsa 적재 시 **라이브 최초 옵션 레이어 사례**가 된다. 본 §2 option_groups·§3 options·§4 option_items 적재본은 그 최초 사례의 후보다.
- **LV-4 (디스패치 정합 재확인):** 라이브 제약 폼 표준 var 표가 **도수=`opt_id`(NOT clr_cd)** · **자재=`mat_cd__usage_cd` 복합슬롯**을 그대로 확증. silsa §4 디스패치(공정=`.04` ref_key1=proc_cd·셋트=`.07` sub_prd_cd)와 일치 → **보강 불요**.
- **LV-5 (ref_param_json 라이브 UI 부재 강화):** 라이브 admin 옵션그룹 추가 폼·제약 폼빌더·SKU 폼 **어디에도 파라미터(구수·각목규격) 입력 필드 없음**. 옵션아이템 레벨 폼은 그룹 1개+ 저장 후 드릴다운 가능(쓰기 금지로 미확인)이나, 제약 폼조차 param 미수용 → GAP-PARAM(D-1) **강화**(스키마 미구현이 UI에서도 재확증).

---

## 6. 고객 선택 → MES 환원 트레이스 (sample)

**고객 선택:** 일반현수막 / `1500×900`(이산 매트릭스 규격 = SIZ_000403, 가격트랙 라이브 존재 4규격 중 하나) / 타공(6개) / 각목(900이하)+끈(4개) / 제작수량 5장. (세로변=900이라 각목900이하와 정합 — R-GAKMOK PASS 케이스.)

**선택 → 옵션 행 (재정합 — 이산 siz_cd):**
```
siz_cd    = SIZ_000403        (1500×900, 가격 매트릭스 셀 존재 → 유효; off-grid면 가로·세로 각각 ceiling[앱])
gagong    = OP-GAGONG-TAGONG6        (OG-GAGONG 그룹 택1)
chuga     = OP-CHUGA-GAKMOK-LE900    (OG-CHUGA 그룹 택1)
qty       = 5
```

**제약 평가(constraint_json — 재정합):** R-SIZE-NONSPEC **폐기**(유효성=SIZ_000403 가격 셀 존재로 가격엔진 판정)·**R-GAKMOK-HEIGHT**(각목900이하 ↔ SIZ_000403 세로변=900≤900 ∈ 호환 siz 집합 → T, 차원+폼빌더 입력방식 선등록 후 적재 가능·GAP-DEFER)·R-BONGJE **불요**(사이즈 이미 선택). → **유효 ✅**(사이즈 유효성=가격 셀, 각목-세로변 호환=R-GAKMOK).

**환원(option_items → 실엔티티):**

| 선택 | option_items 행 | ref_dim_cd | 환원 결과 |
|---|---|---|---|
| 소재(고정) | (material 차원 직접) | material | MAT_000182 현수막천, usage USAGE.07 |
| 사이즈 | siz 차원 직접(SIZ_000403) | size | 1500×900 (이산 매트릭스 규격, 가격 셀 존재) |
| 타공(6개) | OP-GAGONG-TAGONG6/seq1 | `OPT_REF_DIM.04` | PROC_000079 타공, `{"구수":6}` — **구수 보존 불가(GAP-PARAM)** |
| 끈(4개) | OP-CHUGA-GAKMOK-LE900/seq1 | `OPT_REF_DIM.04` | PROC_000081 부착, `{"대상":"끈"}`, qty=4 |
| 각목 | OP-CHUGA-GAKMOK-LE900/seq2 | `OPT_REF_DIM.07` | 각목(900이하) `[CONFIRM 코드]`, qty=1 — **sub_prd_cd 미상(BLOCKED)** |

> **가격(옵션 추가가격 — 가격트랙 위임):** 본체가 = `component_prices[COMP_POSTER_BANNER_NORMAL, siz_cd=SIZ_000403]` × 5장(가격트랙 `02_mapping/silsa-poster-area-matrix`). 옵션가 = 타공6개 +4,000원 · 각목900이하+끈 +4,000원(B26 사이드바 §1.2/1.3) — **옵션 레이어 미보유, 가격트랙 component로 분리 연결**(§아래 옵션가 위임).

**MES 주문 페이로드(resolved JSON):**
```json
{
  "order_lines": [
    {
      "line_type": "MAIN",
      "prd_cd": "PRD_000138", "prd_nm": "일반현수막", "qty": 5,
      "size": { "siz_cd": "SIZ_000403", "width": 1500, "height": 900, "unit": "mm", "note": "이산 매트릭스 규격(가격 셀 존재)" },
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

### 7.1 옵션 추가가격 위임 (가격트랙 component 분리 — 사용자 확정)

[HARD · 사용자 확정] **옵션 레이어(option_groups/options/option_items)는 가격을 보유하지 않는다.** 각 옵션의 추가가격은 **가격트랙의 가격 component로 분리**되어 연결만 된다. 옵션 선택=가격 변동이지만, 그 값은 옵션 레이어가 아니라 `t_prc_*`(component_prices)에 산다.

| 옵션 값(L1) | 추가가격(B26 실측) | 가격 매핑(가격트랙 위임처) | 옵션 레이어 |
|---|---|---|---|
| 열재단 | 3,000 | 가공 component(flat) | item BLOCKED·가격 미보유 |
| 타공(4/6/8개) | 3,000/4,000/5,000 | **개수 의존** component(구수별 단가) | item INSERTABLE·구수 보존 GAP-PARAM·가격 미보유 |
| 양면테입 | 3,000 | 가공 component(flat) | item·가격 미보유 |
| 봉미싱 | 4,000 | 가공 component(flat) | item·가격 미보유 |
| 큐방(4개) | 3,000 | 추가 component(flat) | item·가격 미보유 |
| 끈(4개) | 4,000 | 추가 component(flat) | item·가격 미보유 |
| 각목(900이하)+끈 | 4,000 | 추가 component(**길이 2단**, 세로변 900 기준) | item BLOCKED·가격 미보유 |
| 각목(900초과)+끈 | 8,000 | 추가 component(길이 2단) | item BLOCKED·가격 미보유 |

> **위임 규약:** 본체가 = `component_prices[COMP_POSTER_BANNER_NORMAL, siz_cd]`(면적 매트릭스, `02_mapping/silsa-poster-area-matrix`). 옵션가 = B26 사이드바(§1.2 가공 J/K·§1.3 추가 M/N)의 추가가격을 **가격트랙이 별 component로 적재**(가공 component·추가 component). 옵션 레이어는 option_item이 가리키는 공정/셋트 차원이 가격 component와 **동일 차원 코드(proc_cd·sub_prd_cd)로 조인**되어 환원 시 가격이 따라온다. 즉 **옵션 레이어=구조(무엇을 고르나), 가격트랙=값(얼마인가)** 분리. option_items CSV엔 가격 컬럼 없음(라이브 스키마도 없음 — 정합). 타공 개수별·각목 길이 2단 가격은 가격트랙이 흡수(옵션가 사이즈무관 flat 기본, 타공/각목만 예외 — banner-research B.3).

---

## 8. FK 위상정렬 적재 순서 (load order)

트리거 `fn_chk_opt_item_ref`는 차원행 부재 시 REJECT → 차원행 선행 필수:
```
[선행 — L1, 일부 라이브 적재됨] dimension rows:
  ✅ materials(MAT_000182)·processes 079/080/081 — 적재됨
  △ sizes 이산 매트릭스 80규격: 4 존재(SIZ_000320/321/323/403) / 76 미등록 — 가격트랙 SIZ_000538~000618 채번 인간승인 대기(siz 선등록 = R-GAKMOK constraint·매트릭스 가격 전제)
  ❌ processes 열재단 전용공정 PROC_000084(신규) 0행 — 신설·적재 인간승인 대기(M-1 ① 확정·완칼 PROC_053 차용 폐기, 제안서 11_ddl_proposals/heat-cut-process-proposal)
  ❌ sets(각목 sub_prd_cd) 0행 + 각목 완제상품 자체 부재 — 상품+sets 선적재 필요([CONFIRM])
[1] t_prd_product_option_groups (2행)         — FK: prd_cd→products, sel_typ_cd→cod (트리거 없음)
[2] t_prd_product_options (11행)              — FK: opt_grp_cd→option_groups (트리거 없음)
[3] t_prd_product_option_items (적재 CSV = INSERTABLE 9행만) — 트리거: ref_dim_cd별 차원행 EXISTS
       적재 CSV(load_silsa/t_prd_product_option_items.csv): 타공4/6/8(079)·양면테입/큐방/끈/각목LE끈/각목GT끈 seq1(081)·봉미싱(080)
       분리 CSV(load_silsa/t_prd_product_option_items_BLOCKED.csv, 적재 대상 아님): 열재단(신규 PROC_000084)·각목 seq2 ×2(set) — 신설/선적재 후 적재 대기
[4] t_prd_product_constraints (현 live 적재 0행)  — R-SIZE-NONSPEC 폐기·R-BONGJE 불요·R-GAKMOK는 각목 set + siz 76 선등록 후 적재 가능(GAP-DEFER, §5). 표현불가 GAP 아님
[5] UPDATE t_prd_products.constraint_json     — 현재 활성 live 규칙 0건이라 NULL. R-GAKMOK 적재 시 그 1건으로 채움
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
| constraints | 1 | **0 (현)** | 1 (DEFER) | **재정합**: R-SIZE-NONSPEC 폐기·R-BONGJE 불요 → 제거. **R-GAKMOK 1건만 잔존**(각목 set + siz 76 + 폼빌더 입력방식 선등록 후 적재 — GAP-DEFER. DB jsonb 저장 가능·폼빌더 배열-멤버십 입력 미검증, F-1). CSV `status=GAP-DEFER` |
| **합계** | **26** | **22** | **4** | 적재 CSV 합 = **22행**(option_groups 2 + options 11 + option_items 9). BLOCKED/DEFER = items 3 + constraint 1. constraint_json UPDATE = NULL(R-GAKMOK 적재 시 채움) |

> 옵션 값 기준: **가공 6 = 5 INSERTABLE + 1 BLOCKED(열재단).** **추가 5 = 5 option INSERTABLE / item 6 INSERTABLE + 2 BLOCKED(각목 seq2).**
> **constraint(재정합 2026-06-08-B):** 종전 "3 GAP(비표준 var 표현불가)" → **R-SIZE-NONSPEC 폐기 + R-BONGJE 불요 + R-GAKMOK 1건 해소조건부**. 사이즈를 이산 siz_cd로 재정합한 결과 비치수 **연속수치 범위 검증 GAP(R-SIZE-NONSPEC분)**의 일반현수막 뿌리가 **해소**. R-GAKMOK은 차원 선등록(각목 set·siz 76) + **폼빌더 입력방식 확정**(배열-멤버십 입력 지원 미검증, F-1) 후 적재 = GAP-DEFER(DB jsonb 저장은 가능).

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
| D-5 | **사이즈 모델(재정합 2026-06-08-B — 종전 이원성 폐기)** | **이산 5×16 매트릭스 규격**(입력 UX=프리셋+자유입력 혼합 / 가격·유효성=이산 매트릭스, 가로 하한 900). off-grid=가로·세로 각각 ceiling(앱). **비치수 연속범위·products `nonspec_*` 범위 컬럼 제안 폐기**(D-5 종전 후보 철회). siz 80규격 = 4 존재 / 76 미등록(가격트랙 SIZ_000538~000618 인간승인) | **GAP-SIZ-REG**(siz 76 등록, High) — 매트릭스 가격·R-GAKMOK 전제 |
| D-6 | **각목 길이 기준 = 세로변(사용자 확정)** | 각목 900mm 기준 = 세로(높이)변. R-GAKMOK = 각목↔세로변 900 siz_cd 집합 호환. **DB jsonb(logic) 저장 가능**(연속수치 GAP 아님)이나 **라이브 폼빌더 배열-멤버십 입력 지원 미검증**(F-1) → 각목 set + siz 76 + **폼빌더 입력방식** 확정 후 적재 = GAP-DEFER | **GAP-DEFER**(차원+입력방식 선행, High) → 종전 GAP-NONSPEC-RANGE 중 R-SIZE-NONSPEC분 **해소** |

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
| `load_silsa/t_prd_product_constraints_GAP.csv` | 1 (GAP-DEFER, live 적재 0 현) | **재정합**: R-SIZE-NONSPEC 폐기·R-BONGJE 불요로 제거, **R-GAKMOK 1건만 잔존**(각목 set+siz 76+폼빌더 입력방식 선등록 후 siz_cd↔sub_prd_cd 호환으로 적재 — DB jsonb 저장 가능, 폼빌더 배열-멤버십 입력 미검증 F-1). `status=GAP-DEFER`. **[F-2] 헤더 `logic_target_spec` → 라이브 `logic`(jsonb) 매핑 후 적재**(현 0행 무해). L1 row111/112 |

| 코드/값 | 출처 |
|---|---|
| PRD_000138 일반현수막 PRD_TYPE.04 | ref-products.csv / silsa.md §① |
| **사이즈 = 이산 5×16 매트릭스(가로{900,1000,1200,1500,1750}×세로 16규격)** / 라이브 siz 4 존재(SIZ_000320/321/323/403)·76 미등록 | **가격표 B26 권위**(silsa-price-table-gap.md §1.1)·`02_mapping/silsa-poster-area-matrix/mapping.md §3` |
| MAT_000182 현수막천 USAGE.07 | ref-product-materials.csv |
| PROC_000079 타공{구수1~8}·080 봉제{유형,폭}·081 부착{대상:라벨/맥세이프/끈/테입} | ref-processes.csv prcs_dtl_opt |
| 열재단 = 신규 PROC_000084 `[CONFIRM-CHANNEL]` (M-1 ① 확정·완칼 PROC_053 차용 폐기) | m1-yeoljaedan-decision.md / 11_ddl_proposals/heat-cut-process-proposal / 06_extract/price-poster-sign-l1.csv(열재단 3,000원) |
| 각목/큐방 완제상품 0행 · PRD_000138 sets/addons 0행 · **각목 900mm 기준=세로변(사용자 확정)** | ref-products.csv · ref-product-sets/addons.csv · 사용자 HARD 확정 |
| 옵션 추가가격(가공6·추가5, B26 사이드바 J/K·M/N) = **가격트랙 component 위임** | silsa-price-table-gap.md §1.2/§1.3 · banner-domain-competitor-research.md B.3 |
| 가공6·추가5 옵션 값 | silsa-l1.csv 일반현수막 row108~113 |
| SEL_TYPE.01/.02 · OPT_REF_DIM.01~07 · RULE_TYPE.01/.02/.03 | cpq-schema.md §2/§3 / code-values.md |
