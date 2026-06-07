# CPQ 옵션 레이어(L2) 검증 — 프리미엄엽서(PRD_000016) 파일럿

> **검증자** `dbm-validator` (독립·적대 스탠스 — 본 옵션 레이어를 설계하지 않음. 설계=`dbm-option-mapper`). 이 분리가 곧 게이트.
> **작성** 2026-06-07 · round-6 CPQ 옵션 레이어 L2 검증 · DB 미적재(읽기전용 로컬 대조 only, DRY-RUN 미실행).
> **검증 대상:** `postcard-option-layer.md` + `load/t_prd_product_*.csv` 7종 · 마스터 지도 `attribute-entity-map.md` · GAP `cpq-option-gaps.md`.
> **권위:** Excel 명시값 > 추출 스냅샷(`ref-*.csv` stale — 존재/등록 판정은 라이브 권위) · 라이브 스키마 + 트리거 `fn_chk_opt_item_ref` > 설계 문서 · `cpq-schema.md §1/§2/§4` · `_live-schema-dump-260606.txt`(컬럼 실측).
> 식별자/컬럼/코드/JSONLogic/상태토큰 = English, 설명 = Korean.

---

## 0. 검증 방법 — 무엇을 어떻게 확인했나

L2는 L1과 종류가 다르다 — **새 데이터를 싣지 않고 이미 적재된 차원행을 참조**한다. 따라서 핵심 검증은 값 충실도가 아니라 **참조 해소(reference resolution)**: 9개 option_item의 `(ref_dim_cd, ref_key1[, ref_key2])`가 트리거 `fn_chk_opt_item_ref`가 검사하는 그대로 PRD_000016의 라이브 차원행으로 해소되는가. 모든 판정은 **검증자 자체 ref 조회**로 교차확인했다(파일럿 self-report 신뢰 아님).

**자체 조회한 라이브 스냅샷:** `ref-product-processes.csv`·`ref-product-print-options.csv`·`ref-product-materials.csv`·`ref-product-sizes.csv`·`ref-product-addons.csv`(PRD_000016 필터) + `ref-processes.csv`·`ref-sizes.csv`(마스터) + `_live-schema-dump-260606.txt`(컬럼 NOT NULL/PK/FK 실측).

---

## 1. 경계 1 — option_items ↔ 라이브 차원행 (load-bearing L2 검사) — **PASS**

9개 option_item 각각을 검증자가 직접 ref 스냅샷에 조회해 트리거 디스패치대로 대조:

| opt_cd | ref_dim_cd | ref_key1 | 검증자 라이브 조회 결과 | 파일럿 판정 | 교차확인 |
|---|---|---|---|:--:|:--:|
| OP-DOSU-SINGLE | `OPT_REF_DIM.06` 도수 | `1` (opt_id) | print-options: `PRD_000016, opt_id=1, 단면` **EXISTS** | INSERTABLE | ✅ 일치 |
| OP-DOSU-DOUBLE | `OPT_REF_DIM.06` 도수 | `2` (opt_id) | print-options: `PRD_000016, opt_id=2, 양면` **EXISTS** | INSERTABLE | ✅ 일치 |
| OP-MOSEORI-JIKGAK | `OPT_REF_DIM.04` 공정 | `PROC_000027` | processes: `PRD_000016, PROC_000027` **EXISTS** | INSERTABLE | ✅ 일치 |
| OP-MOSEORI-DUNGEUN | `OPT_REF_DIM.04` 공정 | `PROC_000028` | processes: `PRD_000016, PROC_000028` **EXISTS** | INSERTABLE | ✅ 일치 |
| OP-HUGA-OSI | `OPT_REF_DIM.04` 공정 | `PROC_000029` | processes(PRD_000016): **부재**(027/028만) | BLOCKED | ✅ 일치 |
| OP-HUGA-MISING | `OPT_REF_DIM.04` 공정 | `PROC_000030` | processes(PRD_000016): **부재** | BLOCKED | ✅ 일치 |
| OP-HUGA-VARTEXT | `OPT_REF_DIM.04` 공정 | `PROC_000031` | processes(PRD_000016): **부재** | BLOCKED | ✅ 일치 |
| OP-HUGA-VARIMG | `OPT_REF_DIM.04` 공정 | `PROC_000032` | processes(PRD_000016): **부재** | BLOCKED | ✅ 일치 |
| OP-JONGI-DEFAULT | `OPT_REF_DIM.03` 자재 | `[CONFIRM]` | materials(PRD_000016): **0행** | BLOCKED | ✅ 일치 |

**디스패치 슬롯 정확성 (트리거 일치) — 전건 PASS:**
- **도수 = `OPT_REF_DIM.06`, ref_key1 = opt_id::int(1/2), NOT clr_cd** — MISMATCH-1 정정이 올바로 반영됨. 검증자가 `ref-product-print-options.csv`를 직접 조회: PRD_000016에 opt_id 1·2 실재. **clr_cd 오용 없음**(흔한 함정 회피 확인).
- **공정 = `OPT_REF_DIM.04`, ref_key1 = proc_cd, ref_key2 미사용** — 슬롯 정확.
- **자재 = `OPT_REF_DIM.03`, ref_key1 = mat_cd, ref_key2 = usage_cd** — 슬롯 정확(종이=별도설정이라 `[CONFIRM]`, 발명 안 함).
- **봉투 = option_item 0행, template 경유** — 8번째 addon ref_dim 발명 안 함(cpq-schema §3 일치). 정확.

**잘못된 ref_dim_cd·잘못된 테이블 디스패치·잘못된 키 슬롯 = 0건 발견.**

### 1-A. 5개 BLOCKED 행 정직성 검증 (핵심 적대 검사) — **정직(over-block 0 / under-block 0)**

리드 핵심 질문: 5개 BLOCKED가 진짜 차단인가, mapper가 과차단(resolvable인데 BLOCKED)했나?

- **공정 4종(PROC_000029~032):** 검증자가 `grep "PRD_000016,PROC_00002[9]|PRD_000016,PROC_00003[012]"` → **NONE FOUND**. PRD_000016 processes에는 027/028 단 2행뿐. 마스터 `ref-processes.csv`엔 029~032 *정의*는 실재(오시/미싱 `{줄수 0~3}`·가변 `{개수 0~3}`)하나 **PRD_000016에 *연결*된 product_process 행 부재** → 트리거 `fn_chk_opt_item_ref`는 product 차원행을 검사하므로 정당하게 REJECT. **BLOCKED 정직.**
- **종이(material):** `grep "PRD_000016" ref-product-materials.csv` → **0행**. 종이=*별도설정이라 product_material 부재 → 트리거 REJECT. **BLOCKED 정직(invention dodge 아님 — 실제 0행).**
- **결론:** 5개 BLOCKED 전건이 라이브 차원행 *실부재*에 근거. **과차단 없음.** mapper가 발명으로 회피하지 않고 정직하게 BLOCKED 플래그함 → 적대 검사 통과. 동시에 **under-block(라이브 실재인데 INSERTABLE 누락)도 없음** — INSERTABLE 4행(도수2·모서리2)은 전부 라이브 차원행 실재 확인.

---

## 2. 경계 2 — attribute-entity-map 완전성 ↔ 파일럿 인스턴스화 — **PASS**

마스터 지도(패밀리①)의 디지털인쇄 verdict가 파일럿 실 행과 모순 없는지 spot-check:

| 마스터 지도 verdict | 파일럿 인스턴스화 | 정합 |
|---|---|:--:|
| 단/양면 = 도수(opt_id, NOT clr_cd) `.06` | OG-DOSU + OP-DOSU-SINGLE/DOUBLE item ref_key1=1/2 | ✅ |
| 별색 = 공정(PROC_000007 family, clr_cd=NULL) `.04` 다중 | OG-BYEOLSAEK **미인스턴스화**(L1 별색 5컬럼 전 7행 공백=본 상품 미보유, 발명 금지) | ✅(정직 미생성) |
| 봉투 = add-on template(option_items 아님) | OG-CHUGA + TMPL-ENV-* 3종 + addons 3행, option_item 0행 | ✅ |
| 후가공 오시/미싱/가변 = 공정 + param, SEL_TYPE.02 max4, GAP-PARAM | OG-HUGAGONG SEL_TYPE.02 max4 + OP-HUGA-* 4종 + GAP-PARAM 플래그 | ✅ |
| 종이 = 자재(엽서 *별도설정=0행 GAP-DEFER) | OG-JONGI + OP-JONGI-DEFAULT BLOCKED + GAP-DEFER | ✅ |
| 판수 = price engine / R-QTY-PANSU constraint | R-QTY-PANSU constraint 행 | ✅ |

**모순 0건.** 파일럿이 마스터 지도를 충실히 실행하고, 미보유 축(별색)은 정직하게 미생성. 사이즈 그룹 미생성은 UI 정책 결정(`[CONFIRM]`)으로 명시 — 차원행은 R-QTY-PANSU·MES 환원에서 참조하므로 누락 아님.

---

## 3. 경계 3 — 옵션 레이어 ↔ 라이브 CPQ 스키마 — **FAIL (MAJOR ×2)**

`_live-schema-dump-260606.txt` 컬럼 실측으로 7개 CSV 헤더를 대조. 검증자가 각 CSV 헤더를 라이브 컬럼 집합과 프로그램으로 비교했다.

### 3-A. 컬럼 정합 — **2개 CSV에서 라이브 부재 컬럼 발견 (MAJOR)**

| CSV | 라이브 부재 컬럼 | 결과 |
|---|---|---|
| `t_prd_product_option_items.csv` | **`note`** | 라이브 `t_prd_product_option_items`에 `note` 컬럼 **없음**. 컬럼 = `prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn,del_dt,reg_dt,upd_dt` |
| `t_prd_template_selections.csv` | **`note`** | 라이브 `t_prd_template_selections`에 `note` 컬럼 **없음**. 컬럼 = `tmpl_cd,sel_seq,ref_dim_cd,ref_key1,ref_key2,opt_cd,sel_val,qty,use_yn,del_yn,del_dt,reg_dt,upd_dt` |

다른 5개 CSV(option_groups·options·templates·addons·constraints)는 헤더가 라이브 컬럼의 부분집합 → OK. (option_groups·options·templates·addons에는 라이브 `note` 실재.)

> **FINDING F-1 (MAJOR):** `t_prd_product_option_items.csv`·`t_prd_template_selections.csv`의 `note` 컬럼은 라이브 테이블에 부재. 헤더 명시 `\copy ... (prd_cd,...,note)` 또는 INSERT 컬럼 리스트에 `note`가 들어가면 **`column "note" does not exist` 에러로 적재 실패**. 행 데이터(ref_key1 등)는 유효하나 CSV가 그대로는 적재 불가.
> **근거:** `_live-schema-dump-260606.txt` 두 테이블 컬럼 목록 + 검증자 헤더 대조 스크립트(EXTRA cols not in live: `['note']` 양 테이블).
> **라우팅:** `dbm-option-mapper`. **수정안:** option_items·template_selections 적재 CSV에서 `note` 컬럼 제거(프로비넌스는 별도 주석/설계문서로 이관), 또는 ddl-proposer에 `note vc500` 추가 제안(다른 6개 CPQ 테이블엔 note 실재하므로 컨벤션상 추가도 정당 후보 — 단 search-before-mint·인간승인). 적재 차단 해소 전까지 두 테이블 적재 불가.

### 3-B. NOT NULL — **PASS (단 GAP-DEFER 행 주의)**

라이브 `t_prd_product_option_items`: `ref_key1` **NOT NULL**. INSERTABLE 4행은 ref_key1 채워짐(1/2/PROC_027/PROC_028) → PASS. **단 OP-JONGI-DEFAULT의 ref_key1 = `[CONFIRM]`(빈값 의도)** — 이 행은 어차피 BLOCKED(material 0행)이라 적재 대상 아님. ref_key1 NOT NULL 제약상으로도 `[CONFIRM]`/NULL은 적재 불가 → BLOCKED 판정과 이중 정합. `sel_typ_cd`는 groups에서 nullable(YES)이나 전 행 SEL_TYPE.01/.02 채움 → PASS. constraints `logic` jsonb NOT NULL → 3행 전부 채움 PASS.

### 3-C. FK — **PASS**

- `opt_grp_cd`(options→option_groups, CSV 내): OP-* 13행의 opt_grp_cd(OG-DOSU/JONGI/MOSEORI/HUGAGONG/CHUGA) 전건이 groups CSV 5행에 실재 → CSV 내 FK PASS.
- `sel_typ_cd`/`ref_dim_cd`/`rule_typ_cd`(→`t_cod_base_codes`): SEL_TYPE.01/.02·OPT_REF_DIM.01/.03/.04/.06·RULE_TYPE.01/.03 — 전건 `cpq-schema §3` 라이브 코드 카탈로그 내(SEL_TYPE 2종·OPT_REF_DIM 7종·RULE_TYPE 3종) → PASS.
- `base_prd_cd`(templates→products): PRD_000001/002/004 — addons 라이브 실재 상품 → PASS.
- `tmpl_cd`(addons→templates): TMPL-ENV-* 3종이 templates CSV에 실재 → CSV 내 FK PASS.

### 3-D. PK 유일성 (CSV 내) — **PASS**

- option_groups (prd_cd, opt_grp_cd): 5행 전건 유일.
- options (prd_cd, opt_cd): 13행 전건 유일.
- option_items (prd_cd, opt_cd, item_seq): 9행 전건 유일(각 opt_cd당 item_seq=1).
- templates (tmpl_cd): 3행 유일. template_selections (tmpl_cd, sel_seq): 3행 유일.
- addons (prd_cd, tmpl_cd): 3행 유일. constraints (prd_cd, rule_cd): 3행 유일.
- **중복 0건.**

### 3-E. 적재 순서 ↔ FK + 트리거 — **PASS**

파일럿 §8 load order(차원행 선행 → groups → options → items → templates → template_selections → addons → constraints → constraint_json UPDATE)가 FK 위상 + 트리거 행단위 검사와 정합. option_items BLOCKED 5행은 차원 선적재(또는 GAP-DEFER 센티넬 규약) 전 적재 불가를 정확히 명시.

---

## 4. 경계 4 — constraints ↔ JSONLogic — **PASS**

3개 `logic` 셀을 검증자가 직접 파싱·손계산:
- **well-formed JSON 3/3** — `t_prd_product_constraints.csv`의 CSV 이스케이프(`""`) 정상, python `json.loads` 파싱 PASS(검증자 실행 확인).
- **R-HUGA-MAXN** (`reduce` idiom): `{var:hugagong}` 배열을 `{+:[acc,1]}`로 누적, 초기값 0 → `len(hugagong)`. `<= 4`. accumulator 변수명 정확(json-logic reduce 규약 일치).
- **샘플 선택 손계산** (100x150 SIZ_000003·양면·둥근·오시2+미싱2·qty80):
  - R-HUGA-MAXN: hugagong=[osi,mising] → reduce=2, `2<=4` = **True** ✅
  - R-HUGA-PARAM: osi_julsu=2·mising_julsu=2·vartext=0·varimg=0, 전부 `0~3` = **True** ✅
  - R-QTY-PANSU: siz_cd=SIZ_000003 분기 활성, `80 % 8 == 0` = **True** ✅
  - **constraint_json AND = True** → 주문 가능 의도와 일치.
- **적대 케이스 손계산:** qty81→PANSU `81%8=1≠0` **False** ✅ · osi4→PARAM `4>3` **False** ✅ · 후가공 5종→MAXN `5<=4` **False** ✅ · SIZ_000001 qty80(15 비배수)→PANSU **False** ✅. 전건 의도대로.
- **compile 캐시** (`t_prd_products.constraint_json` = 활성 3 rule AND): 파일럿 §5 JSON이 3 rule의 정확한 AND 결합. POD `json-logic-js`·백엔드 `json-logic-py` 동일평가 전제 타당.

> **주의(MINOR, 비차단):** R-HUGA-PARAM·R-HUGA-MAXN은 `hugagong`/`osi_julsu` 등 런타임 입력변수에 의존하나, 이 변수를 채울 **줄수/개수 보존처(ref_param_json)가 라이브 부재**(GAP-PARAM). 즉 constraint는 평가 가능하나 그 입력을 MES로 환원할 수 없음 → constraint 검증 자체는 PASS, 보존 GAP은 §6에서 다룸.

---

## 5. 경계 5 — GAP 정직성 — **PASS**

리드 핵심: GAP을 qty에 smear하거나 발명하지 않고 ddl-proposer로 정직히 플래그했나?

| GAP | 파일럿 처리 | 정직성 |
|---|---|:--:|
| **GAP-PARAM** (후가공 줄수/개수) | option_items에 param 미저장, `qty`엔 소비수량 1만(줄수 인코딩 안 함), `cpq-option-gaps.md`에 등록 + ddl-proposer 라우팅. note에 "qty smear 금지" 명시 | ✅ 정직 |
| **GAP-DEFER** (별도설정 종이·미적재 후가공) | 발명 안 하고 `[CONFIRM]`/BLOCKED 플래그, 차원 선적재 vs 센티넬 규약을 D-2 결정으로 에스컬레이션 | ✅ 정직 |
| **`price` 미구현** | 봉투 template 가격 발명 안 하고 `[CONFIRM]`, 가격엔진 연계로 라우팅 | ✅ 정직 |
| **GAP-C** (SIZ_000104 장수충돌) | siz 명칭 "(10장)" vs freeze qty=50 충돌을 `[CONFIRM]`로 노출(검증자 ref-sizes.csv 직접 확인: `SIZ_000104=화이트165x115mm(10장)` 실재 → 충돌 실재) | ✅ 정직 |
| **GAP-COMPOSITE·GAP-A** | 본 상품 L1 박 공백이라 미인스턴스화(발명 금지), 범위 밖으로 정직 기록 | ✅ 정직 |

**qty smear 0건 · 발명 0건.** BLOCKED인데 실은 resolvable(차원행 라이브 실재)인 행 = **0건**(§1-A에서 5행 전수 라이브 부재 확인). 정직성 적대 검사 통과.

---

## 6. 발견 종합 (severity + 라우팅)

| ID | severity | 발견 | 근거 | 라우팅 | 수정안 |
|---|:--:|---|---|---|---|
| **F-1** | **MAJOR** | option_items·template_selections 적재 CSV에 라이브 부재 컬럼 `note` 존재 → `\copy`/INSERT 컬럼 리스트 사용 시 적재 실패 | `_live-schema-dump` 양 테이블 컬럼 + 헤더 대조 | `dbm-option-mapper` | CSV에서 `note` 제거(프로비넌스 별도) 또는 ddl-proposer에 `note vc500` 추가 제안(타 6 CPQ 테이블 컨벤션 정합·인간승인) |
| F-2 | MINOR | GAP-PARAM: constraint 입력변수(osi_julsu 등) 보존처 부재 — constraint는 평가되나 MES 환원 불가 | cpq-schema §4 🔴8 · 라이브 option_items=qty만 | `dbm-ddl-proposer` (이미 등록) | `ref_param_json jsonb` 컬럼(search-before-mint) |
| F-3 | MINOR | SIZ_000104 siz 명칭 baked-in "(10장)" vs template freeze qty=50 충돌 | ref-sizes.csv 직접 조회 | `dbm-mapping-designer`(마스터 정합) | siz 명칭 치수만, 장수 제거 |
| F-4 | MINOR(관찰) | 라이브 print-options PRD_000016 opt_id 1·2 **둘 다 dflt_yn=Y**(L1 차원). L2 options CSV는 SINGLE만 dflt — L1 차원 dflt와 L2 옵션 dflt는 독립 레이어라 모순 아님이나, L1 차원에 dflt 2행은 별개 관찰 | ref-product-print-options.csv | (L1 — 정보용, 본 L2 검증 범위 밖) | L1 트랙 확인(옵션) |

> **F-4 보충:** OP-DOSU-SINGLE note "front CLR_000005 / back CLR_000001" — 단면인데 back 색상 기재는 L1 print-options 행(opt_id=1)의 back_colrcnt_cd=CLR_000001 verbatim 인용이므로 파일럿 결함 아님(차원행 충실 인용). 비차단.

---

## 7. 적재 가능성 집계 (검증자 자체 ref 조회 교차확인 — 파일럿 self-report 아님)

| 테이블 | 총행 | INSERTABLE | BLOCKED(needs L1) | 검증자 교차확인 |
|---|:--:|:--:|:--:|---|
| option_groups | 5 | 5 | 0 | 트리거 없음, 헤더 OK |
| options | 13 | 13 | 0 | 트리거 없음, CSV내 FK PASS |
| **option_items** | **9** | **4** | **5** | 도수2(opt_id 1·2 라이브 실재)+모서리2(027·028 라이브 실재) INSERTABLE / 후가공4(029~032 라이브 0행)+종이1(material 0행) BLOCKED — **전수 라이브 조회 일치** |
| templates | 3 | 3 | 0 | base PRD_000001/002/004 실재 |
| template_selections | 3 | 3 | 0 | SIZ_000085(001·002 보유)·SIZ_000104(004 보유) 라이브 조회 일치 |
| product_addons | 3 | 3 | 0 | tmpl_cd CSV내 FK PASS |
| constraints | 3 | 3 | 0 | JSONLogic 손계산 PASS |
| **합계** | **39** | **34** | **5** | + constraint_json UPDATE 1건 |

> **단 F-1 적용:** option_items·template_selections는 행 *데이터*는 위 집계대로(items 4 INSERTABLE / sel 3)이나, **현 CSV 헤더가 `note` 포함이라 그대로는 적재 불가** — F-1 수정 후 적재 가능. 즉 "데이터상 INSERTABLE 34 / BLOCKED 5"는 맞으나, **CSV 적재본 자체는 F-1 해소 전 NOT-LOADABLE(2 테이블)**.

**GAP 집계:** GAP-PARAM(High)·GAP-DEFER(High, BLOCKED 5행 직결)·`price`미구현·GAP-C·GAP-B·GAP-COMPOSITE·GAP-A — 전건 정직 플래그·발명 0.

---

## 8. 최종 판정 — **CONDITIONAL-GO (F-1 수정 시 GO)**

### 검증 결과 요약
- **경계 1 (참조 해소, load-bearing): PASS** — 9 option_item 전건 트리거 디스패치 정확, 4 INSERTABLE/5 BLOCKED 검증자 자체 조회 일치. 잘못된 키 슬롯(도수≠clr_cd)·잘못된 테이블·존재하지 않는 ref_dim_cd = 0.
- **경계 2 (마스터 지도 완전성): PASS** — 파일럿이 지도 verdict 충실 실행, 모순 0.
- **경계 3 (라이브 스키마 정합): FAIL** — F-1(MAJOR) `note` 컬럼 라이브 부재 2 테이블. NOT NULL/FK/PK/적재순서는 PASS.
- **경계 4 (JSONLogic): PASS** — 3 rule well-formed, 샘플·적대 손계산 전건 의도대로.
- **경계 5 (GAP 정직성): PASS** — qty smear 0·발명 0·과차단 0.

### 5개 BLOCKED 행 정직성 (리드 핵심 답)
**5개 BLOCKED 전건이 올바로 차단됨.** 검증자가 PROC_000029~032·종이 material을 라이브 스냅샷에서 직접 조회 → PRD_000016에 전부 부재 확정. **과차단(over-block) 0건 · 과허용(under-block) 0건.** mapper가 발명으로 회피하지 않고 정직하게 BLOCKED·`[CONFIRM]` 플래그함.

### GO 조건
- **BLOCKER 0건.** 유일 차단성 발견 F-1은 **MAJOR이나 사소·기계적 수정**(CSV 2개에서 `note` 컬럼 제거 또는 ddl 추가 제안). 매핑 로직·참조 해소·제약은 전건 건전.
- **F-1 해소 후 GO** — option_items·template_selections CSV의 `note` 제거 후 재게이트(경계 3-A만). 나머지 6 경계 PASS는 승계.

### 권고 다음 단계
1. **F-1 → `dbm-option-mapper`:** option_items·template_selections 적재 CSV에서 `note` 제거(또는 ddl-proposer에 `note vc500` 추가 제안).
2. **GAP-DEFER 결정(D-2) → 리드/사용자 에스컬레이션:** BLOCKED 5행은 차원 선적재 vs deferred 센티넬 규약 확정 전 적재 불가 — 인간 결정 사항.
3. **라이브 DRY-RUN(리드 승인 시):** `BEGIN … INSERT 옵션레이어 … ROLLBACK`으로 트리거 `fn_chk_opt_item_ref` 실발화 검증이 최강 증명(특히 INSERTABLE 4행이 트리거 PASS, BLOCKED 5행이 REJECT 실증). **리드 승인 필수·NEVER COMMIT.** 현재는 로컬 ref 조회로 대체(트리거 디스패치 로직과 동형).
4. `[CONFIRM]` 3건(종이 mat_cd·SIZ_000104 장수·봉투 price) 인간 확정.
