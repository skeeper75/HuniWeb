# 프리미엄엽서(PRD_000016) CPQ 옵션 레이어 — 적재본(load-ready) 파일럿

> **상태/이력** 작성 2026-06-07 · `dbm-option-mapper` 산출 · round-6 파일럿 B(리드 선택 상품군). DB 미적재(실 INSERT/코드행/DDL = 인간 승인).
> **목적:** `attribute-entity-map.md`(마스터 지도) + `postcard-walkthrough.md`(설계 초안, CONDITIONAL-GO)를 **마스터 지도 정합·적재 가능** 옵션 레이어로 정련하여 실 행 + 적재 CSV로 산출한다. 워크스루는 설계 초안, 본 문서는 **적재본**.
> **권위 입력(인용·발명 금지):** `attribute-entity-map.md`(verdict) · `00_schema/cpq-schema.md §1/§2/§4`(라이브 컬럼·트리거·design↔live) · `_live-schema-dump-260606.txt`(컬럼 실측) · `postcard-walkthrough.md`+`-validation.md`(설계·검증 MISMATCH-1/GAP-A/B/C) · `06_extract/digital-print-l1.csv`(L1 캐스케이드) · `00_schema/ref-product-*.csv`·`ref-processes.csv`(라이브 차원행 스냅샷, 존재 판정=라이브 권위).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 코드 = `[CONFIRM]`(발명 금지). 적재 CSV = `10_configurator/load/<table>.csv`.

---

## 0. 워크스루 → 적재본 정련 요약 (무엇이 바뀌었나)

본 파일럿이 워크스루(설계 초안)에 가한 **적재 임계 정련 5건** — 전부 라이브 스키마/트리거 권위(`cpq-schema §4`·`_live-schema-dump`)에 근거:

| # | 워크스루(설계 초안) | 적재본(라이브 정합) | 근거 |
|---|---------------------|---------------------|------|
| **R1** | ref_dim_cd = 텍스트 `'color-count'`/`'process'`/`'addon'`/`'size'` | ref_dim_cd = **라이브 코드 FK** `OPT_REF_DIM.06`(도수)·`.04`(공정)·`.01`(사이즈). add-on은 ref_dim 아님(template) | cpq-schema §2 트리거 디스패치·§3 코드값 7종 |
| **R2** | 도수 ref_key1 = `1`/`2`(opt_id) — 단 설계 정본은 `clr_cd`(MISMATCH-1) | 도수 = `OPT_REF_DIM.06`, ref_key1 = **`opt_id::int`(1/2, NOT clr_cd)** | MISMATCH-1 정정 라이브 반영(cpq-schema ✅3) |
| **R3** | option_items에 `ref_param_json {"줄수":2}` 저장 | **`ref_param_json` 컬럼 라이브 부재** → 줄수/개수 미보존. 행은 적재하되 param은 GAP-PARAM 플래그 | `_live-schema-dump` option_items = qty만(§ R3 실측) |
| **R4** | `t_prd_templates.price` 컬럼에 `[CONFIRM 가격]` | **`price` 컬럼 라이브 부재** → 템플릿에 가격 없음(가격엔진 t_prc_* 연계) | cpq-schema §4 🟡9·`_live-schema-dump` templates |
| **R5** | constraint `rule_typ` = 텍스트 `compatible`/`required` | **`rule_typ_cd` 코드 FK** = `RULE_TYPE.01`(호환)/`.03`(필수동반) | cpq-schema §4 ⚠️11·§3 RULE_TYPE |

> **추가 정련:** ① R-QTY-PANSU를 7사이즈 전체 표로 완성(워크스루는 3행 축약). ② BLOCKED 5행(종이·후가공 4종 = 트리거 REJECT 예정)은 적재 CSV에서 분리 격리(`..._BLOCKED.csv`) — 선적재 의존.
> **추가 정련(F-1, dbm-validator):** ③ `t_prd_product_option_items.csv`·`t_prd_template_selections.csv`는 `note` 컬럼이 라이브 부재(나머지 5 CPQ 테이블만 note 실재)라 적재 CSV에서 제거 — 적재 CSV는 라이브 컬럼만(다른 round load CSV 컨벤션 정합). ④ option_items 적재 CSV=INSERTABLE 4행, BLOCKED 5행은 분리 CSV로 격리(round-5 차단행 분리 패턴).

---

## 1. Step 0 — 차원행 전제 (option_item이 참조할 라이브 차원 확인)

[HARD] option_item은 *이미 적재된 차원행*을 가리키는 포인터다. 트리거 `fn_chk_opt_item_ref`가 "그 prd_cd에 등록된 차원행 EXISTS"를 강제하므로, 등록 전 차원행 실재를 확인한다(ref-*.csv 스냅샷, 존재 판정=라이브 권위).

| 차원 | 라이브 적재(PRD_000016) | option_item 참조 가능? | 출처 |
|------|------------------------|:----------------------:|------|
| **size** `OPT_REF_DIM.01` | **7행** SIZ_000001~007 (전부 dflt_yn=Y) | ✅ (단 사이즈 그룹 본 파일럿 미생성 — §2 주) | ref-product-sizes.csv |
| **plate_size** `OPT_REF_DIM.02` | 7행 SIZ_000112~118 (112만 OUTPUT_PAPER_TYPE.03+PDF) | ✅ (보통 미노출 — 판형) | ref-product-plate-sizes.csv |
| **print_option(도수)** `OPT_REF_DIM.06` | **2행** opt_id 1(단면 CLR_000005/CLR_000001) · opt_id 2(양면 CLR_000005/005) | ✅ → OG-DOSU | ref-product-print-options.csv |
| **process(공정)** `OPT_REF_DIM.04` | **2행** PROC_000027(직각)·PROC_000028(둥근) | ✅ 모서리만 / ❌ 후가공 029~032 0행 | ref-product-processes.csv |
| **material(자재)** `OPT_REF_DIM.03` | **0행** | ❌ 종이=*별도설정 → OG-JONGI BLOCKED | ref-product-materials.csv(PRD_000016 부재) |
| **bundle_qty/page_rule/set** | 0행 | (해당 없음) | ref |
| **addon(봉투)** | **3행** PRD_000001/002/004 → template | ✅ (templates 경유) | ref-product-addons.csv |

**Step 0 판정:** 도수(2행)·모서리 공정(027/028)·봉투 addon(3행)은 차원행 실재 → option_item/template 등록 가능. **종이(material 0행)·후가공 4종(process 029~032 0행)은 차원행 부재** → 해당 option_item은 트리거 REJECT 예정 = **BLOCKED(needs L1 pre-load)**. 이것이 GAP-DEFER(별색 0행은 본 상품 미보유라 그룹 자체 미생성).

---

## 2. option_groups (sel_typ_cd 택1/택N · mand_yn)

→ `load/t_prd_product_option_groups.csv` (5행). 라이브 컬럼: `prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note`. `sel_typ_cd` 값 형식 = **`SEL_TYPE.01`/`SEL_TYPE.02`**(라이브 GRP-BOOK 선례 일치, 풀코드).

| opt_grp_cd | opt_grp_nm | sel_typ_cd | min | max | mand_yn | disp_seq | verdict 근거(master map 패밀리①) |
|---|---|---|:--:|:--:|:--:|:--:|---|
| `OG-DOSU` | 인쇄(도수) | SEL_TYPE.01 (택1) | 1 | 1 | **Y** | 1 | 단/양면=도수축(opt_id), 필수 |
| `OG-JONGI` | 종이 | SEL_TYPE.01 (택1) | 1 | 1 | **Y** | 2 | 종이=자재축, 필수 — 단 차원 0행(BLOCKED) |
| `OG-MOSEORI` | 모서리 | SEL_TYPE.01 (택1) | 0 | 1 | N | 3 | 모서리=공정 택일(027/028) |
| **`OG-HUGAGONG`** | 후가공 | **SEL_TYPE.02 (택N)** | **0** | **4** | N | 4 | 후가공 4종 다중(오시·미싱·가변T·가변I) — L1 동시선택 실증 |
| `OG-CHUGA` | 추가상품(봉투) | SEL_TYPE.01 (택1) | 0 | 1 | N | 5 | 봉투=add-on template(option_item 아님) |

> **GAP-1 행사:** `OG-HUGAGONG` = SEL_TYPE.02 + max_sel_cnt=4. L1 프리미엄엽서 row2(오시1+미싱1+가변T1+가변I1)·row3(2/2/2/2)·row4(3/3/3/3)가 4종 **동시선택**을 직접 입증(digital-print-l1.csv col38~41). 배너 가공(택일)이 못 쓴 다중선택.
> **사이즈 그룹 미생성(설계 결정):** 사이즈(SIZ_000001~007)는 차원행 존재하나, 본 파일럿은 사이즈를 별도 option_group으로 노출하지 않는다(워크스루도 미생성). 사이즈는 보통 상품 진입 시 1차 선택축으로 UI 상단 고정 — option_group 노출 여부는 UI 정책 결정([CONFIRM] 사이즈 그룹 노출). 차원행은 R-QTY-PANSU constraint·MES 환원에서 직접 참조.
> **별색 그룹 미생성:** L1 별색 5컬럼(화이트~은색) 전 7행 공백 = 본 상품 미보유. 설계상 `OG-BYEOLSAEK`=SEL_TYPE.02+max5(PROC_000007 "선택유형=다중" 권위)이나 발명 금지로 미인스턴스화.

---

## 3. options (opt_grp_cd · dflt_yn)

→ `load/t_prd_product_options.csv` (13행). 라이브 컬럼: `prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note`.

- **OG-DOSU(2):** OP-DOSU-SINGLE(단면, dflt) · OP-DOSU-DOUBLE(양면)
- **OG-JONGI(1):** OP-JONGI-DEFAULT(별도설정, dflt) — 차원 0행 BLOCKED
- **OG-MOSEORI(2):** OP-MOSEORI-JIKGAK(직각, dflt) · OP-MOSEORI-DUNGEUN(둥근)
- **OG-HUGAGONG(4):** OP-HUGA-OSI(오시) · OP-HUGA-MISING(미싱) · OP-HUGA-VARTEXT(가변텍스트) · OP-HUGA-VARIMG(가변이미지) — 각 독립 다중, 전부 차원 0행 BLOCKED
- **OG-CHUGA(4):** OP-CHUGA-NONE(봉투없음, dflt 센티넬) · OP-CHUGA-OPP-JEOPCHAK · OP-CHUGA-OPP-BIJEOPCHAK · OP-CHUGA-CARD-WHITE

> 출처: digital-print-l1.csv row1~7 + ref-product-addons.csv 3행. **카드봉투(블랙)·트레싱지봉투는 L1 언급되나 ref-products.csv 미등록 → 옵션 미생성**(발명 금지). `OP-*` opt_cd는 본 설계 신규 부여.

---

## 4. option_items (polymorphic ref_dim_cd → 라이브 차원행 · 트리거 디스패치 정확)

→ `load/t_prd_product_option_items.csv` (9행). 라이브 컬럼: `prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, note`. **`ref_param_json` 컬럼 없음(R3·GAP-PARAM).**

| opt_cd | ref_dim_cd | ref_key1 | ref_key2 | 트리거 검사 | 판정 |
|---|---|---|---|---|:--:|
| OP-DOSU-SINGLE | `OPT_REF_DIM.06` 도수 | `1`(opt_id) | — | print_options(opt_id=1) EXISTS | ✅ INSERTABLE |
| OP-DOSU-DOUBLE | `OPT_REF_DIM.06` 도수 | `2`(opt_id) | — | print_options(opt_id=2) EXISTS | ✅ INSERTABLE |
| OP-MOSEORI-JIKGAK | `OPT_REF_DIM.04` 공정 | `PROC_000027` | — | processes(027) EXISTS | ✅ INSERTABLE |
| OP-MOSEORI-DUNGEUN | `OPT_REF_DIM.04` 공정 | `PROC_000028` | — | processes(028) EXISTS | ✅ INSERTABLE |
| OP-HUGA-OSI | `OPT_REF_DIM.04` 공정 | `PROC_000029` | — | processes(029) **부재** | ❌ BLOCKED(GAP-DEFER) |
| OP-HUGA-MISING | `OPT_REF_DIM.04` 공정 | `PROC_000030` | — | processes(030) **부재** | ❌ BLOCKED(GAP-DEFER) |
| OP-HUGA-VARTEXT | `OPT_REF_DIM.04` 공정 | `PROC_000031` | — | processes(031) **부재** | ❌ BLOCKED(GAP-DEFER) |
| OP-HUGA-VARIMG | `OPT_REF_DIM.04` 공정 | `PROC_000032` | — | processes(032) **부재** | ❌ BLOCKED(GAP-DEFER) |
| OP-JONGI-DEFAULT | `OPT_REF_DIM.03` 자재 | `[CONFIRM]` | `[CONFIRM]` usage_cd | materials **0행** | ❌ BLOCKED(GAP-DEFER) |

**디스패치 정확성(트리거 슬롯 일치):**
- **도수 = `OPT_REF_DIM.06`, ref_key1 = opt_id::int(1/2)** — NOT clr_cd. MISMATCH-1 정정 라이브 반영. 단/양면 식별은 opt_id 권위(ref-product-print-options.csv).
- **공정 = `OPT_REF_DIM.04`, ref_key1 = proc_cd** — ref_key2 미사용.
- **자재 = `OPT_REF_DIM.03`, ref_key1 = mat_cd, ref_key2 = usage_cd**(USAGE 코드, 예 .07 공통) — 단 종이=별도설정이라 mat_cd `[CONFIRM]`(발명 금지).
- **OP-CHUGA-* 는 option_item 0행** — 봉투는 ref_dim_cd가 아니라 template 경유(addon에 8번째 ref_dim 없음, cpq-schema §3). OP-CHUGA-NONE은 센티넬(item 없음).

> **R3·GAP-PARAM 정직 표기:** OP-HUGA-OSI 등은 본래 `{"줄수":2}` 파라미터를 가지나 라이브 option_items에 `ref_param_json` 부재 → **줄수/개수 보존 불가**. 적재 CSV는 행만 싣고(어차피 차원 0행으로 BLOCKED), param은 GAP-PARAM으로 등록. **qty에 줄수 smear 금지**(qty는 소비수량, 줄수≠qty). 공정 *스키마*는 `ref-processes.csv prcs_dtl_opt`에 실재(PROC_000029 `{"inputs":[{"key":"줄수","max":3,"min":0,...}]}`) — 즉 파라미터 *정의*는 마스터에 있고, *선택값* 보존처만 부재.

---

## 5. constraints (JSONLogic rule 행 + compile)

→ `load/t_prd_product_constraints.csv` (3행). 라이브 컬럼: `prd_cd, rule_cd, rule_nm, rule_typ_cd, logic(jsonb NN), err_msg, disp_seq, use_yn`. **`rule_typ_cd` = 코드 FK**(R5).

| rule_cd | rule_nm | rule_typ_cd | 의미 |
|---|---|---|---|
| `R-HUGA-MAXN` | 후가공 최대 4종 | RULE_TYPE.01 (호환) | hugagong 배열길이 ≤ 4 (reduce idiom) |
| `R-HUGA-PARAM` | 후가공 파라미터 범위 | RULE_TYPE.01 (호환) | 오시/미싱 줄수·가변 개수 0~3 (PROC prcs_dtl_opt 정합) |
| `R-QTY-PANSU` | 수량 판수 배수 | RULE_TYPE.03 (필수동반) | qty가 선택 사이즈 판수의 배수 — **7사이즈 전체**(15/12/8/6/6/4/4) |

**JSONLogic 검증(본 파일럿 손계산·python json-logic 평가):**
- 3 logic 셀 전부 **well-formed JSON**(파싱 PASS).
- 샘플 선택(100x150 SIZ_000003·양면·둥근·오시2+미싱2·qty80): R-HUGA-MAXN=True(2≤4)·R-HUGA-PARAM=True(2∈[0,3])·R-QTY-PANSU=True(80%8==0) → **constraint_json AND = True ✅**.
- 적대 케이스 전건 의도대로: qty81→R-QTY-PANSU **False**, 후가공 5종→R-HUGA-MAXN **False**, osi4→R-HUGA-PARAM **False**, SIZ_000001 qty30(15배수)→**True**, SIZ_000001 qty80(15배수 아님)→**False**.

**`t_prd_products.constraint_json` (compile 캐시 = 활성 3 rule AND 결합):**
```json
{ "and": [
  { "<=": [ { "reduce": [ {"var":"hugagong"}, {"+":[{"var":"accumulator"},1]}, 0 ] }, 4 ] },
  { "and": [ {">=":[{"var":"osi_julsu"},0]},{"<=":[{"var":"osi_julsu"},3]},
             {">=":[{"var":"mising_julsu"},0]},{"<=":[{"var":"mising_julsu"},3]},
             {">=":[{"var":"vartext_cnt"},0]},{"<=":[{"var":"vartext_cnt"},3]},
             {">=":[{"var":"varimg_cnt"},0]},{"<=":[{"var":"varimg_cnt"},3]} ] },
  { "or": [ {"and":[{"==":[{"var":"siz_cd"},"SIZ_000001"]},{"==":[{"%":[{"var":"qty"},15]},0]}]},
            {"and":[{"==":[{"var":"siz_cd"},"SIZ_000002"]},{"==":[{"%":[{"var":"qty"},12]},0]}]},
            {"and":[{"==":[{"var":"siz_cd"},"SIZ_000003"]},{"==":[{"%":[{"var":"qty"},8]},0]}]},
            {"and":[{"==":[{"var":"siz_cd"},"SIZ_000004"]},{"==":[{"%":[{"var":"qty"},6]},0]}]},
            {"and":[{"==":[{"var":"siz_cd"},"SIZ_000005"]},{"==":[{"%":[{"var":"qty"},6]},0]}]},
            {"and":[{"==":[{"var":"siz_cd"},"SIZ_000006"]},{"==":[{"%":[{"var":"qty"},4]},0]}]},
            {"and":[{"==":[{"var":"siz_cd"},"SIZ_000007"]},{"==":[{"%":[{"var":"qty"},4]},0]}]} ] }
] }
```
> compile = `t_prd_products.constraint_json` 컬럼(jsonb)에 직접 갱신(별도 CSV 아님 — products UPDATE). POD `json-logic-js`·백엔드 `json-logic-py` 동일 평가.

---

## 6. templates / template_selections + addons (봉투 add-on)

→ `load/t_prd_templates.csv`(3행) · `load/t_prd_template_selections.csv`(3행) · `load/t_prd_product_addons.csv`(3행).

**`t_prd_templates`** (봉투 3종 SKU. 라이브 컬럼: `tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, note` — **price 없음 R4**):

| tmpl_cd | base_prd_cd | tmpl_nm | dflt_qty |
|---|---|---|:--:|
| TMPL-ENV-OPP-JEOPCHAK | PRD_000001 | OPP접착봉투 110x160 50장 | 50 |
| TMPL-ENV-OPP-BIJEOPCHAK | PRD_000002 | OPP비접착봉투 110x160 50장 | 50 |
| TMPL-ENV-CARD-WHITE | PRD_000004 | 카드봉투(화이트) 165x115 50장 | 50 |

**`t_prd_template_selections`** (봉투 자기 siz_cd 1개 freeze. 라이브 컬럼: `tmpl_cd, sel_seq, ref_dim_cd, ref_key1, ref_key2, opt_cd, sel_val, qty`):

| tmpl_cd | sel_seq | ref_dim_cd | ref_key1 | sel_val | qty | base 보유 검증 |
|---|:--:|---|---|---|:--:|---|
| TMPL-ENV-OPP-JEOPCHAK | 1 | `OPT_REF_DIM.01` | SIZ_000085 | 110x160mm | 50 | PRD_000001 보유 SIZ_000085 ✅ |
| TMPL-ENV-OPP-BIJEOPCHAK | 1 | `OPT_REF_DIM.01` | SIZ_000085 | 110x160mm | 50 | PRD_000002 보유 SIZ_000085 ✅ |
| TMPL-ENV-CARD-WHITE | 1 | `OPT_REF_DIM.01` | SIZ_000104 | 화이트165x115mm | 50 | PRD_000004 보유 SIZ_000104 ✅ |

> **GAP-3 닫힘:** freeze siz_cd가 base 봉투 자기 차원에 실재(ref-product-sizes.csv) → 차원 무결성 통과. `sel_val`(라이브 컬럼)에 사람 읽는 라벨, 차원 선택은 ref_dim_cd+ref_key1. 워크스루의 `value` 컬럼명은 라이브 `sel_val`로 정정.
> **`[CONFIRM]`:** SIZ_000104 명칭 "화이트165x115mm**(10장)**" vs selection qty=50(addon note 권위) — siz 명칭에 baked-in 장수 vs freeze 장수 충돌. addon note가 권위이나 마스터 정합 필요(siz 명칭은 치수만 가야 함).

**`t_prd_product_addons`** (AS-IS addon_prd_cd 직접링크 → TO-BE tmpl_cd. 라이브 컬럼: `prd_cd, tmpl_cd, disp_seq, note`):

| prd_cd | tmpl_cd | disp_seq | AS-IS(마이그 원천) |
|---|---|:--:|---|
| PRD_000016 | TMPL-ENV-OPP-JEOPCHAK | 1 | addon_prd_cd=PRD_000001, note "110x160 50장" |
| PRD_000016 | TMPL-ENV-OPP-BIJEOPCHAK | 2 | addon_prd_cd=PRD_000002 |
| PRD_000016 | TMPL-ENV-CARD-WHITE | 3 | addon_prd_cd=PRD_000004 |

> **마이그레이션 가치:** note 문자열 "110x160 50장" freeze 정보가 구조화된 template_selections(siz_cd=SIZ_000085, qty=50)로 승격. **단 GAP-B/GAP-C:** L1 row1 추가상품 = "엽서봉투 ★사이즈선택 : 100x150" = **본체 사이즈 연동 동적 freeze** → 현 template 고정 freeze 모델 미지원(GAP-B). note→siz_cd 매핑 규칙(명칭 문자열 파싱 의존)은 자동 마이그 시 오매칭 위험(GAP-C). 둘 다 설계 한계로 기록.

---

## 7. 고객 선택 → MES 환원 트레이스

**고객 선택:** 프리미엄엽서 / 100x150(SIZ_000003, 8판) / 양면 / 모서리 둥근 / 후가공 오시2줄+미싱2줄(2종 동시) / 봉투 OPP접착(TMPL-ENV-OPP-JEOPCHAK) / 제작수량 80장(8판×10).

**제약 평가(constraint_json):** R-HUGA-MAXN(2≤4)·R-HUGA-PARAM(2∈[0,3])·R-QTY-PANSU(80%8==0) → **전체 PASS ✅**(본 파일럿 손계산·python 검증 일치).

**환원(option_items → 실엔티티):**

| 선택 | ref_dim_cd | 환원 결과 |
|---|---|---|
| 100x150 | (size 차원행 직접) | SIZ_000003 (work 102x152, cut 100x150, 판수 8) |
| 양면 | OPT_REF_DIM.06 opt_id 2 | print_option opt_id=2, front/back CLR_000005 CMYK |
| 모서리 둥근 | OPT_REF_DIM.04 | PROC_000028 (R 라운딩) |
| 오시2줄 | OPT_REF_DIM.04 | PROC_000029 — **줄수=2 보존 불가(GAP-PARAM)** |
| 미싱2줄 | OPT_REF_DIM.04 | PROC_000030 — 줄수=2 보존 불가(GAP-PARAM) |
| 봉투 | (template) | 별도 주문라인: base PRD_000001, siz SIZ_000085, qty 50 |
| 종이 | OPT_REF_DIM.03 | **[CONFIRM] 별도설정 — mat_cd 미상, 환원 미완(GAP-DEFER)** |

**MES 페이로드(2 라인):** MAIN(PRD_000016 qty80 + 양면 print_option + PROC_000028/029/030, 단 종이 mat_cd=[CONFIRM]·오시/미싱 줄수 미보존) + ADDON(TMPL-ENV-OPP-JEOPCHAK → PRD_000001 SIZ_000085 qty50 별도 생산라인). **봉투는 엽서 옵션이 아니라 함께 주문되는 별개 완제품**(코드까지 환원 완결, 가격만 가격엔진).

---

## 8. FK 위상정렬 적재 순서 (load order)

트리거 `fn_chk_opt_item_ref`는 차원행 부재 시 REJECT → 차원행 선행 필수:

```
[선행 — L1, 대부분 라이브 적재됨] dimension rows:
  ✅ sizes(7)·print_options(2)·processes 027/028(2) — 적재됨
  ❌ materials(종이) 0행 · processes 029~032(후가공) 0행 — 선적재 필요(GAP-DEFER)
  ✅ 봉투 base sizes(SIZ_000085/104) — 봉투 상품에 적재됨
[1] t_prd_product_option_groups (5행)        — FK: prd_cd→products, sel_typ_cd→cod
[2] t_prd_product_options (13행)              — FK: opt_grp_cd→option_groups
[3] t_prd_product_option_items (적재 CSV = INSERTABLE 4행만) — 트리거: ref_dim_cd별 차원행 EXISTS
       적재 CSV(load/t_prd_product_option_items.csv): OP-DOSU-SINGLE/DOUBLE, OP-MOSEORI-JIKGAK/DUNGEUN
       분리 CSV(load/t_prd_product_option_items_BLOCKED.csv, 적재 대상 아님): OP-HUGA-OSI/MISING/VARTEXT/VARIMG, OP-JONGI-DEFAULT (GAP-DEFER 해소 후 적재 대기)
[4] t_prd_templates (3행)                     — FK: base_prd_cd→products
[5] t_prd_template_selections (3행)           — FK: tmpl_cd→templates, ref_dim_cd→cod
[6] t_prd_product_addons (3행)                — FK: prd_cd→products, tmpl_cd→templates
[7] t_prd_product_constraints (3행)           — FK: prd_cd→products, rule_typ_cd→cod
[8] UPDATE t_prd_products.constraint_json     — §5 compile 캐시
```
> [HARD] option_items는 **트리거가 행단위 검사** → BLOCKED 5행은 차원 선적재(또는 GAP-DEFER 센티넬 규약) 확정 전 적재 불가. 따라서 **적재 CSV(`t_prd_product_option_items.csv`)에는 INSERTABLE 4행만**, BLOCKED 5행은 분리 CSV(`t_prd_product_option_items_BLOCKED.csv`)로 격리(적재 대상 아님 — round-5 차단행 분리 패턴 정합). options/option_groups는 트리거 없음(헤더만이라 13/5행 전부 적재 가능 — BLOCKED은 items 레벨).
> **F-1 정정(2026-06-07, dbm-validator):** `t_prd_product_option_items.csv`·`t_prd_template_selections.csv`의 `note` 컬럼은 라이브 테이블 부재(`_live-schema-dump` 확인) → 적재 CSV에서 제거(라이브 컬럼만). 프로비넌스는 본 §4/§9·분리 CSV `block_reason`에 보존(무손실). 나머지 5 CSV(groups/options/templates/addons/constraints)는 `note` 라이브 실재라 유지.

---

## 9. 적재 가능성 집계 (insertable / BLOCKED / GAP)

| 테이블 (적재 CSV) | 총행 | INSERTABLE | BLOCKED(needs L1) | 비고 |
|---|:--:|:--:|:--:|---|
| option_groups | 5 | 5 | 0 | 트리거 없음 |
| options | 13 | 13 | 0 | 트리거 없음(헤더) |
| **option_items** (`t_prd_product_option_items.csv`) | **4** | **4** | **0** | 적재 CSV = INSERTABLE 4행만(도수2+모서리2). note 컬럼 제거(F-1) |
| **option_items 분리** (`..._BLOCKED.csv`) | **5** | **0** | **5** | 후가공4+종이1, 적재 대상 아님 — GAP-DEFER 해소 후 적재 대기. block_reason 컬럼 보유 |
| templates | 3 | 3 | 0 | base 봉투 실재 |
| template_selections | 3 | 3 | 0 | freeze siz 봉투 보유. note 컬럼 제거(F-1) |
| product_addons | 3 | 3 | 0 | tmpl_cd 마이그 |
| constraints | 3 | 3 | 0 | JSONLogic 검증 PASS |
| **합계** | **39** | **34** | **5** | 적재 CSV 합 = 34행(5 BLOCKED은 분리 CSV로 격리) + constraint_json UPDATE 1건 |

---

## 10. 설계 결정 필요 / `[CONFIRM]` (리드 에스컬레이션)

### 미해결 `[CONFIRM]` (라이브 실부재/실충돌 — 발명 금지)
1. **`[CONFIRM]` 종이 mat_cd/usage_cd** — 종이=*별도설정, material 0행. OP-JONGI-DEFAULT의 ref_key1(mat_cd)·ref_key2(usage_cd) 미상. **해소=종이 차원 선적재 vs deferred 센티넬(mat_cd=NULL)** 규약 확정(GAP-DEFER).
2. **`[CONFIRM]` SIZ_000104 장수 충돌** — siz 명칭 "(10장)" vs template_selections.qty=50(addon note 권위). siz 명칭의 baked-in 장수 제거(마스터 정합) 필요(GAP-C 연계).
3. **`[CONFIRM]` 봉투 가격** — `t_prd_templates.price` 컬럼 라이브 부재(R4). 봉투 추가가격 보관처 미정(가격엔진 t_prc_* 연계 vs 컬럼 추가 — cpq-schema §4 🟡9).

### 설계 결정 필요 (침묵 선택 안 함)
| # | 결정 사항 | 후보 | 종속 GAP |
|---|---|---|---|
| D-1 | **후가공 줄수/개수 보존처** | option_items `ref_param_json` 컬럼 추가 vs qty 재사용(단일정수만) | **GAP-PARAM**(High) |
| D-2 | **별도설정 종이·미적재 후가공 처리** | 차원 선적재(정석) vs deferred 센티넬(mat_cd=NULL+트리거 EXISTS 면제) | **GAP-DEFER**(High) — BLOCKED 5행 직결 |
| D-3 | **사이즈 option_group 노출 여부** | UI 상단 고정(미노출, 본 파일럿 채택) vs OG-SIZE 명시 생성 | (UI 정책) |
| D-4 | **★사이즈선택 동적 addon** | template 고정 freeze 한계 인정 vs 본체연동 동적 selection 메커니즘 신설 | GAP-B(MINOR) |
| D-5 | **note→siz_cd 마이그 규칙** | 명칭 문자열 파싱(현재·오매칭 위험) vs 명시 매핑표 | GAP-C(MINOR) |

### 워크스루 검증 승계 잔존(본 파일럿 범위 밖)
- **GAP-A(MAJOR)** 진짜 max-N(전체>상한) 미실증 — 후가공 max4=전체4라 상한 무의미. 박색상 16종 중 N 같은 케이스 필요(별색/박 보유 상품).
- **GAP-2** excl-group 마이그레이션 — 엽서 excl_grp_cd 0행 → 미해당. 책자/캘린더(GRP-BOOK/CAL)로만 실증 가능.
- **GAP-COMPOSITE** 박/형압 계층종속(박색상⊂박) — 본 상품 L1 박 공백이라 미인스턴스화.

---

## 부록 — 적재 CSV 인덱스

| CSV | 행 | 권위 출처 |
|---|:--:|---|
| `load/t_prd_product_option_groups.csv` | 5 | L1 캐스케이드 + master map 패밀리① verdict |
| `load/t_prd_product_options.csv` | 13 | digital-print-l1.csv row1~7 + addons 3행 |
| `load/t_prd_product_option_items.csv` | 4 (INSERTABLE) | ref-product-print-options/processes + 트리거 §2. note 컬럼 제거(F-1) |
| `load/t_prd_product_option_items_BLOCKED.csv` | 5 (BLOCKED, 적재 대상 아님) | 후가공 029~032·종이 — GAP-DEFER 해소 후 적재 대기. block_reason 컬럼 |
| `load/t_prd_templates.csv` | 3 | ref-product-addons.csv PRD_000016 |
| `load/t_prd_template_selections.csv` | 3 | ref-product-sizes.csv 봉투 보유 SIZ_000085/104. note 컬럼 제거(F-1) |
| `load/t_prd_product_addons.csv` | 3 | AS-IS addons 마이그 |
| `load/t_prd_product_constraints.csv` | 3 | JSONLogic(python 검증 PASS) + PROC prcs_dtl_opt 범위 |
