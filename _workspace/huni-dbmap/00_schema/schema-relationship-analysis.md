# 라이브 스키마 관계 심층 분석 — 출력판형 / 사이즈 / 가격 (read-only)

> **목적**: round-2 가격 추출이 만든 `t_prc_component_prices.siz_cd = SIZ_PENDING_*`(2,697행 / 285 placeholder)이 "신규 siz 발명"이 아니라 **라이브가 이미 모델링한 구조(판형·완성품·면적)** 로 해소 가능한지를 증거 기반으로 진단한다. 매핑 최종 결정은 다음 단계(매핑 점검) 몫 — 본 문서는 **후보 라이브 타깃 + 증거 + 불확실 플래그**만 제시한다.
>
> **추출 근거**: railway DB(PostgreSQL 18.4) read-only `SELECT`/`information_schema` 1회(2026-06-06). INSERT/UPDATE/DDL/COMMIT 없음. 비밀번호 stdout 미출력. 식별자/SQL 영어, 해석 한국어.
>
> **search-before-mint 원칙**: 신규 siz를 만들기 전에 라이브 `t_siz_sizes`에서 치수·이름으로 기존 행을 먼저 탐색. 발견 시 재사용 후보로 기록.

---

## 0. 요약 (orchestrator data)

- **판형 ↔ 사이즈 ↔ 가격 관계**: `t_siz_sizes`(500행)는 **완성품 치수와 출력판형 치수를 한 마스터에 함께 보관**한다. `t_prd_product_sizes`(완성품 주문 사이즈, 436행)와 `t_prd_product_plate_sizes`(출력판형/인쇄 절수, 494행)는 둘 다 `t_siz_sizes`를 FK 참조하며 — 즉 **판형은 별도 테이블이 아니라 `t_siz_sizes`의 한 행을 `output_paper_typ_cd`(국전/46/기타)로 분류한 plate 용도 행**이다. `t_prc_component_prices.siz_cd`는 `t_siz_sizes`를 `ON DELETE CASCADE`로 FK 참조하므로 — **완성품이든 판형이든 동일 마스터의 siz_cd면 무엇이든 가리킬 수 있다**(디지털인쇄 가격은 완성품이 아닌 **판형=국4절/3절** 단위가 정상).
- **2,697 블록 진단(7군)**: GUK4·3JEOL = **기존 판형 siz_cd 재사용**(EXISTING-PLATE) / STK = **A4·A3 기존 + 판수 별축 분리**(EXISTING-base + 별축결정) / GP = **직경 일부 기존·대부분 별모델**(PARTIAL) / POSTER·ACRYL = **면적함수 vs 좌표 siz 결정**(면적함수) / ENV = **라이브 부재, 신규 또는 다른 모델**(NEW/uncertain).
- **285 placeholder 중 EXISTING 라이브 구조로 해소 가능 추정**: **확실 EXISTING ≈ 1~2종**(GUK4=SIZ_000499 / 3JEOL 후보) + **STK base 2종(A4/A3)** + **GP 부분 4종** = 약 **7~8종이 즉시 라이브 매핑 후보**. 나머지 ~277종(POSTER 113·ACRYL 149·ENV 4·STK B/판수 4·GP 직경불일치 7)은 **신규 등록 또는 모델링 결정(면적함수/별축)** 이 선결 — 단순 siz 부재가 아니라 **차원 의미 결정** 문제.
- **핵심 반전**: round-4 차단 문서가 "국4절/3절은 출력판형이나 siz_cd 재사용 가능"이라 이미 적었으나, **실제로 라이브에 기존 판형 행이 존재**(GUK4=SIZ_000499)한다는 점을 placeholder가 무시했다 → GUK4 870행 / 3JEOL 304행 = **1,174행(전체의 43.5%)이 "발명"이 아니라 기존 판형 매핑 오류**일 가능성이 높다.

---

## 1. 전체 관계 그래프 (라이브 34 t_* 테이블 + FK)

PostgreSQL 18.4 · `public` · **t_* 34테이블**(+Django 10 = 44). `t_prd_product_process_excl_groups` **제거 확인**(CPQ option_groups 흡수). 전 t_* 테이블에 `del_yn`/`del_dt` 소프트삭제 존재.

### 1.1 클러스터 맵 (FK 엣지, 두 핵심 클러스터 강조)

```
                          ┌─────────────────────┐
                          │  t_cod_base_codes    │  (코드 사전, 71행, 13 부모그룹)
                          │  cod_cd PK, self-ref │
                          └──────────┬──────────┘
        ┌──────────┬──────────┬──────┼───────┬──────────┬───────────┐
   prd_typ/      mat_typ/   comp_typ/ frm_typ/ output_   sel_typ/   ref_dim/
   qty_unit/     sel_typ    dsc_typ  ...      paper_typ  rule_typ   usage
   semi_role
        │
   ┌────▼─────────────────────────────────────────────────────────────────┐
   │ ★ 상품마스터 클러스터 (PRODUCT-MASTER)                                  │
   │                                                                        │
   │   t_prd_products (275)  prd_cd PK ──┬─< t_prd_product_categories (274) │
   │     ├ prd_typ_cd, semi_role_cd      ├─< t_prd_product_sizes (436) ─────┼──┐
   │     ├ qty_unit_typ_cd               ├─< t_prd_product_plate_sizes(494)─┼──┤
   │     ├ nonspec_*, min/max/incr/dflt  ├─< t_prd_product_materials (402)──┼─→ t_mat_materials(336)
   │     ├ constraint_json (jsonb)       ├─< t_prd_product_print_options(166)┼─→ t_clr_color_counts(5)
   │     └ del_yn                        ├─< t_prd_product_processes (198)──┼─→ t_proc_processes(83, self-ref)
   │                                     ├─< t_prd_product_page_rules (11)   │
   │                                     ├─< t_prd_product_bundle_qtys (4)──┼─→ QTY_UNIT
   │                                     ├─< t_prd_product_sets (28, sub_prd self-ref)
   │                                     ├─< t_prd_product_discount_tables(98)─→ t_dsc_discount_tables(7)
   │                                     └─ [CPQ] option_groups(13)/options(0)/option_items(0)
   │                                              /constraints(0)/templates(11)/template_selections(0)
   └───────────────────────────────────────┬────────────────────────────────┘
                                            │ (siz_cd FK, 공유 마스터)
   ┌────────────────────────────────────────▼────────────────────────────────┐
   │ ★ 사이즈 마스터 (공유 허브)                                                │
   │   t_siz_sizes (500)  siz_cd PK                                            │
   │     work_width/height (작업=출력), cut_width/height (재단=완성),            │
   │     margin_*, impos_yn (조판여부), del_yn                                  │
   │   ← t_prd_product_sizes.siz_cd     (완성품 주문 사이즈)                     │
   │   ← t_prd_product_plate_sizes.siz_cd (출력판형, +output_paper_typ_cd 분류)  │
   │   ← t_prc_component_prices.siz_cd  ★(가격 차원, ON DELETE CASCADE)         │
   └───────────────────────────────────────▲────────────────────────────────┘
                                            │ siz_cd 차원 FK (nullable)
   ┌────────────────────────────────────────┼────────────────────────────────┐
   │ ★ 가격엔진 클러스터 (PRICE-ENGINE, t_prc_* 4테이블, 전부 0행=적재대상)       │
   │                                                                          │
   │   t_prc_price_formulas (0)  frm_cd PK ── frm_typ_cd → FRM_TYPE           │
   │     └─< t_prc_formula_components (0) (frm_cd, comp_cd) ─┐                 │
   │   t_prc_price_components (0) comp_cd PK ── comp_typ_cd → PRC_COMPONENT_TYPE│
   │     ├─< t_prc_formula_components ──────────────────────┘                 │
   │     └─< t_prc_component_prices (0) comp_price_id PK (surrogate)           │
   │            6차원: siz_cd→t_siz_sizes, clr_cd→t_clr(5), mat_cd→t_mat(336),  │
   │                   coat_side_cnt(int), bdl_qty(int), min_qty(int)          │
   │            UNIQUE 자연키 8 = (comp_cd, apply_ymd, siz/clr/mat/coat/bdl/min)│
   │   상품바인딩: t_prd_product_price_formulas(0) (prd_cd,frm_cd)             │
   │              t_prd_product_prices(0) (prd_cd,apply_ymd) — 직접단가         │
   └──────────────────────────────────────────────────────────────────────────┘
```

### 1.2 FK ON DELETE 정책 (적재·운영 영향)

| 자식 | 컬럼 | 부모 | ON DELETE | 비고 |
|------|------|------|-----------|------|
| `t_prc_component_prices` | siz_cd | t_siz_sizes | **CASCADE** | siz 삭제 시 가격행 동반삭제. **siz_cd는 반드시 t_siz_sizes에 선존재** |
| `t_prc_component_prices` | comp_cd | t_prc_price_components | CASCADE | |
| `t_prc_component_prices` | clr_cd / mat_cd | t_clr / t_mat | CASCADE | |
| `t_prc_formula_components` | frm_cd / comp_cd | formulas / components | RESTRICT | 공식·구성요소 보호 |
| `t_prd_product_plate_sizes` | siz_cd | t_siz_sizes | RESTRICT | 판형 siz 보호 |
| `t_prd_product_plate_sizes` | output_paper_typ_cd | t_cod_base_codes | RESTRICT | |
| `t_prd_product_sizes` | siz_cd | t_siz_sizes | RESTRICT | 완성품 siz 보호 |
| `t_prd_product_prices` | prd_cd | t_prd_products | CASCADE | |
| 기타 prd_cd FK 대부분 | prd_cd | t_prd_products | RESTRICT | |
| `t_prd_product_materials` | dep_proc_cd | t_proc_processes | **SET NULL** | 공정 삭제 시 자재의존 NULL화 |

[HARD] `t_prc_component_prices.siz_cd`는 `t_siz_sizes`를 CASCADE FK로 가리킨다 → **placeholder(`SIZ_PENDING_*`)는 적재 시 100% FK 위반**. 해소는 (a) 기존 siz_cd로 치환, 또는 (b) 신규 siz 등록(인간 승인) 둘 중 하나뿐.

### 1.3 라이브 행수 (count(*) 실측, 2026-06-06)

| 군 | 테이블(행수) |
|----|------|
| 마스터 | t_cod_base_codes(71) · t_siz_sizes(500) · t_mat_materials(336) · t_proc_processes(83) · t_clr_color_counts(5) · t_cat_categories(306) |
| 상품마스터 | t_prd_products(275) · product_categories(274) · product_sizes(436) · **product_plate_sizes(494)** · product_materials(402) · print_options(166) · processes(198) · page_rules(11) · bundle_qtys(4) · sets(28) · addons(34) · discount_tables(98) |
| 가격엔진 | price_formulas(0) · price_components(0) · formula_components(0) · **component_prices(0)** · product_price_formulas(0) · product_prices(0) — **전부 0행(적재 대상)** |
| 할인 | dsc_discount_tables(7) · dsc_discount_details(35) · dsc_grade_discount_rates(0) |
| CPQ | option_groups(13) · options(0) · option_items(0) · constraints(0) · templates(11) · template_selections(0) |
| 고객 | t_cus_customers(0) |

> 이전 스냅샷 대비 변동: cod_base_codes 58→71(+CPQ 코드그룹), plate_sizes 509→494, product_materials 406→402, print_options 172→166, processes 196→198, product_sizes 444→436, siz_sizes 497→500. (소프트삭제·CPQ 마이그레이션 반영). dsc는 round-1 적재본이 들어가 있음(details 35·tables 7).

---

## 2. 판형 vs 사이즈 vs 인쇄옵션 — 의미 구분 (라이브 증거)

세 개념이 모두 `siz_cd`/사이즈 어휘를 쓰지만 **역할이 다르다**. 핵심: **완성품 사이즈와 출력판형 사이즈는 같은 마스터(`t_siz_sizes`)에 공존**하고, **plate를 구별하는 건 `t_prd_product_plate_sizes.output_paper_typ_cd`(국전/46/기타) 분류뿐**이다.

| 축 | 테이블 | 의미 | siz_cd 출처 | 분류 컬럼 | 라이브 증거 |
|----|--------|------|-------------|-----------|-------------|
| **완성품 주문 사이즈** | `t_prd_product_sizes` (436) | 고객이 고르는 최종 제품 치수 | `t_siz_sizes` | (없음, dflt_yn/disp_seq) | PRD_000016 프리미엄엽서 완성품 7종: 73x98, 98x98, 100x150, 135x135, 95x210, 110x170, 148x210 (SIZ_000001~007) |
| **출력판형(인쇄 절수)** | `t_prd_product_plate_sizes` (494) | 인쇄·생산 시 한 판에 앉히는 출력 치수 | `t_siz_sizes` (동일 마스터) | **`output_paper_typ_cd`** → OUTPUT_PAPER_TYPE.01 국전계열 / .02 46계열 / .03 기타 (+NULL) | PRD_000016 판형 1종: SIZ_000499 316x467, **paper=01 국전계열** (= 국4절 plate). 위 완성품 7종 ≠ 이 판형 1종 |
| **사이즈 마스터** | `t_siz_sizes` (500) | 완성품·판형 치수를 **모두** 보관하는 단일 마스터 | (PK 원천) | `impos_yn`(조판여부) | work_width/height=**출력(작업)**, cut_width/height=**완성(재단)**, margin_*=재단여백. impos_yn='Y'면 조판(여러 장 앉힘)용 |
| **인쇄옵션(단/양면·도수)** | `t_prd_product_print_options` (166) | 단/양면, 앞/뒷면 도수 | (siz 아님) | `print_side`, `front_colrcnt_cd`/`back_colrcnt_cd` → t_clr_color_counts(5) | 단/양면·도수는 사이즈 축이 아니라 별도 상품옵션 |

### 2.1 `output_paper_typ_cd`의 plate 분류 — 라이브 분포

| output_paper_typ_cd | 의미 | plate 행수(del_yn=N) | distinct prd | distinct siz |
|---------------------|------|----------------------|--------------|--------------|
| `OUTPUT_PAPER_TYPE.01` | 국전계열 | **1** | 1 (PRD_000016) | 1 (SIZ_000499 316x467) |
| `OUTPUT_PAPER_TYPE.02` | 46계열 | **0** | 0 | 0 |
| `OUTPUT_PAPER_TYPE.03` | 기타 | 99 | 53 | 65 |
| `(NULL)` | 미분류 | 394 | 167 | 246 |

> **중요**: 판형 분류는 **희소(sparse)** — 394/494(80%)가 `output_paper_typ_cd`=NULL이다. 즉 라이브의 판형 행 대부분은 "국전/46/기타 라벨"이 없고 **치수(siz_cd)로만** 식별된다. 국전계열로 명시 분류된 plate는 **단 1행(SIZ_000499)**. 이것이 "국4절 판형이 라이브에 1번만 명시 등록"의 의미다.

### 2.2 핵심 의미 규칙 (라이브 확증)

1. **완성품 ≠ 판형**. PRD_000016: 완성품 7종(작은 엽서) ↔ 판형 1종(316x467 국4절). 디지털인쇄 가격은 **판형 단위**(한 판에 여러 완성품을 앉혀 인쇄)로 매겨지므로, 가격 siz_cd는 **완성품이 아닌 판형 siz_cd**여야 정상.
2. **판형 치수는 제품마다 다르게 등록**될 수 있다. 전단지(PRD_000047)는 152x214/216x303/**303x426**/**306x446**(SIZ_000171/173/175/177, paper=03 기타)을, 엽서(PRD_000016)는 316x467(SIZ_000499, paper=01)을 판형으로 쓴다. **303x426·306x446·316x467은 전부 "국4절 계열" 치수**지만 bleed/trim 차이로 **서로 다른 siz_cd**다 → "국4절 = 단일 siz_cd"가 아니라 **제품 컨텍스트별로 달라질 수 있음**(매핑 점검에서 결정).
3. **`t_siz_sizes`가 공유 허브**라서 가격 siz_cd는 완성품·판형·면적좌표 중 무엇이든 가리킬 수 있다 — 단 **반드시 그 siz_cd가 마스터에 선존재**해야 한다(CASCADE FK).

---

## 3. 가격엔진 `component_prices.siz_cd` 참조 분석

### 3.1 siz_cd 차원이 가리켜야 하는 대상 (유형별)

| 가격 유형 | 상품 예 | siz_cd가 의미해야 하는 것 | 라이브 권장 타깃 | 근거 |
|-----------|---------|---------------------------|------------------|------|
| **디지털인쇄 (절수가격)** | 전단지·리플렛·엽서 (국4절/3절) | **출력판형(plate)** | `t_prd_product_plate_sizes`가 가리키는 **기존 plate siz_cd** (예 국4절 = SIZ_000499 / SIZ_000175 / SIZ_000177 중 제품 plate) | 가격이 완성품이 아닌 절수(판) 단위. PRD_000016 판형=SIZ_000499 확증 |
| **면적가격** | 포스터·실사·아크릴 | **면적(가로×세로)** | (a) 면적함수[권장] 또는 (b) 좌표 siz_cd 다수 등록 | placeholder가 `POSTER_1000x1200`·`ACRYL_140x160` 처럼 **연속 그리드** — 이산 완성품/판형이 아님 |
| **완성품 고정가** | 굿즈·문구·포토북 `(가격포함)` | 완성품 사이즈 또는 차원무관 | `t_prd_product_prices`(직접단가) 경로, siz 무관 가능 | 공식·차원 미사용 상품 |
| **판수·직경 등 특수축** | 스티커(판수)·합판도무송(직경) | **별도 축**(siz로 환원 부적절) | base siz(A4/A3) + bdl_qty/별축, 또는 직경 신규축 | placeholder가 `STK_A4_2P`(판수)·`GP_원형35mm`(직경) |

### 3.2 round-2가 siz_cd를 채운 방식 vs 의도된 방식

- **round-2 실제**: 라이브 실코드를 선탐색하되 **부재로 판정된 규격을 `SIZ_PENDING_*` placeholder**로 보존(발명 0·dodge 방지 검증 GO). 즉 round-2는 "이 규격이 라이브에 없다"고 판단했다.
- **본 분석의 반전**: GUK4(국4절)는 **라이브에 명백히 존재**(SIZ_000499, paper=01 국전계열, PRD_000016이 실제 사용)한다. round-2의 "부재" 판정은 **"국4절"이라는 추상 라벨로 직검색해서 못 찾은 것**이지, 치수(316x467)나 plate 관계로 탐색하면 존재한다. → **GUK4 placeholder는 매핑 오류**(missing-size 아님).
- **의도된 방식**: 디지털인쇄 가격 siz_cd는 **해당 상품의 `t_prd_product_plate_sizes` 판형 siz_cd를 그대로 재사용**해야 한다. 가격 추출이 엑셀의 "국4절/3절" 라벨을 라이브 plate siz_cd로 **resolve**하지 않고 placeholder로 남긴 것이 근본 결함.

---

## 4. 2,697 블록 진단 (7군 × 후보 라이브 타깃 × 증거 × 신뢰도)

> 분류: **EXISTING-PLATE**(기존 판형 siz 재사용) · **EXISTING-base+별축**(기존 base siz + 판수/직경 별축) · **면적함수**(area function 또는 좌표 siz 결정) · **NEW**(라이브 부재) · **PARTIAL**(일부만 기존). 신뢰도: 🟢확실 / 🟡유력(확인필요) / 🔴불확실.

| 군 (placeholder) | 행수 | distinct siz | 진단 | 후보 라이브 타깃 | 증거 | 신뢰도 |
|------------------|-----:|-----:|------|------------------|------|--------|
| **GUK4** (국4절) | 870 | 1 | **EXISTING-PLATE** | `SIZ_000499` 316x467 (paper=01 국전계열, impos_yn=Y) — 또는 제품별 SIZ_000175(303x426)/SIZ_000177(306x446) | SIZ_000499는 라이브 유일 국전계열 plate, PRD_000016 프리미엄엽서가 실제 판형으로 사용. 국4절 표준치수(~318x468)와 정합 | 🟢 (단일 vs 제품별 선택은 매핑결정) |
| **3JEOL** (3절) | 304 | 1 | **EXISTING-PLATE(후보)** | `SIZ_000475` 330x640 (가장 근접) | 국3절 표준 ~318x636. 330x640이 유일 근접행이나 이름이 "330x640"(절수 라벨 아님)이라 동일성 미확정 | 🟡 (치수 근접, plate 분류 NULL — 확인필요) |
| **STK** (스티커 판수) | 456 | 6 | **EXISTING-base + 별축결정** | base: A4=SIZ_000050(210x297)·A3=SIZ_000052(297x420) **기존**. 판수(1P/2P)·B3/B4는 별도 | 스티커 제품(PRD_000052~062)이 A4/A3/420x594/400x600을 plate로 실사용. `STK_A4_2P`의 "2P"=한 판 2판걸이=**판수 축**(siz 아님, bdl_qty/별차원 후보). B3(364x515)/B4(257x364)는 라이브 부재 | 🟡 (base 기존·판수축은 모델결정) |
| **POSTER** (대형포스터) | 680 | 113 | **면적함수** | (a) 면적함수[권장] 또는 (b) 좌표 siz 다수등록 | placeholder가 1000x1000~1200x5000 **연속 그리드 113종**. 라이브에 일부 대형 이산행 존재(900x1200=SIZ_000320, 1500x1000=SIZ_000403 등)이나 그리드 전체 부재. 이산 완성품이 아닌 **면적 가격표** | 🟢 (면적 성격 확실, 모델방식은 결정) |
| **ACRYL** (아크릴 면적) | 237 | 149 | **면적함수 + 원형 PARTIAL** | 면적함수[권장]; 원형 일부=기존(원형35x35=SIZ_000422 등 4종) | placeholder 100x20~200x200 **연속 그리드 149종**. 라이브 원형 4종(13/19/24/35mm=SIZ_000419~422) 존재하나 사각 그리드 전체 부재. round-4 G9가 원형35mm=SIZ_000422 search-before-mint 적발 | 🟢 (면적 성격 확실, 원형 부분매칭) |
| **GP** (합판도무송 직경) | 110 | 11 | **PARTIAL / 별축(직경)** | 일부 기존(원형35x35=SIZ_000422), 대부분 부재 | placeholder=원형10~60mm step5(11종). 라이브 원형=13/19/24/35x35(SIZ_000419~422)만 → **그리드 불일치**(10/15/20/25/30 등 부재). 직경 축은 siz로 환원 가능하나 후니 등록 필요 | 🟡 (4종 근접·7종 부재, 직경모델 결정) |
| **ENV** (봉투종류) | 40 | 4 | **NEW / 다른모델** | 라이브 봉투 siz **0건** | `siz_nm ~ 봉투\|티켓\|자켓\|대봉\|소봉` 검색 결과 0행. 봉투(티켓/소/자켓/대봉투)는 siz_cd 부재 = 신규 등록 또는 봉투전용 모델 | 🟡 (라이브 부재 확실, 모델방식 미정) |
| **소계** | **2,697** | **285** | — | — | — | — |

### 4.1 285 distinct siz 해소 추정 (EXISTING vs 결정필요)

| 구분 | distinct siz 수 | 행수 추정 | 비고 |
|------|---------------:|---------:|------|
| 🟢 **기존 라이브 구조로 즉시 매핑 후보** | **~7~8종** | **~1,200행** | GUK4(SIZ_000499 등 1~3) + STK base A4/A3(2) + GP 원형근접(최대 4) — **행 비중 큼(GUK4+3JEOL=1,174행=43.5%)** |
| 🟡 **유력 but 확인필요** | ~3종 | ~344행 | 3JEOL(SIZ_000475 동일성) + STK 판수축 + ENV 모델 |
| 🔴 **모델링 결정 선결(면적함수)** | **~262종** | **~917행** | POSTER 113 + ACRYL 149 — 면적함수면 등록규모 급감, 좌표 siz면 262종 등록 |
| **별축/신규(직경·판수·B규격·봉투)** | ~13종 | ~236행 | GP 직경 7 + STK B3/B4·판수 4 + ENV 4 |

> **결론(행 기준)**: 2,697행 중 **약 1,174행(GUK4+3JEOL)이 기존 판형 매핑으로 해소될 가능성이 가장 높다**(전체 43.5%, distinct siz 단 2종). POSTER+ACRYL 917행(34%)은 **면적함수 vs 좌표 결정**이 본질 — 단순 siz 부재가 아니다. 즉 **"285종 신규 siz 발명"이라는 placeholder의 전제는 과대**하며, 실제로는 **소수의 판형 재사용 + 면적 모델 결정 + 소수 신규**로 분해된다.

---

## 5. 다음 단계(매핑 점검)에서 결정할 항목 (open questions)

1. **[GUK4 판형 확정 — High]** 국4절 가격 siz_cd를 **단일 SIZ_000499**로 통일할지, **제품 plate별**(SIZ_000175/177/499 등 bleed차이)로 분기할지. → 디지털인쇄 상품들의 `t_prd_product_plate_sizes`를 전수 조회해 "국4절 계열" 판형 siz_cd 집합을 확정하고, 가격행을 제품 plate에 join할지 단일 plate로 통일할지 결정. (본 분석: 870행이 단일 placeholder이므로 **단일 plate 의도** 추정되나, 제품별 plate 차이 존재 → 확인 필수)
2. **[3JEOL 동일성 — High]** `SIZ_000475`(330x640)가 국3절 출력판형과 동일한가, 아니면 3절 plate가 라이브 미등록(신규)인가. 치수 근접(330x640 vs 표준 318x636)이나 이름이 절수 라벨이 아님 → 후니 확인 또는 신규 등록 판단.
3. **[POSTER/ACRYL 면적 모델 — High]** 면적가격을 **(a) 면적함수**(단가/㎡ + 함수, siz 차원 NULL 또는 base siz)로 모델링할지, **(b) 좌표 siz**(가로×세로 조합 = siz_cd, 262종 등록)로 할지. 면적함수면 등록·적재 규모 급감(917행 → 함수 파라미터 소수). **이 결정이 ACRYL 149 + POSTER 113 = 262 placeholder의 운명을 좌우**.
4. **[STK 판수축 — Medium]** `STK_A4_2P`/`A3_1P`의 "1P/2P"(판걸이수/판수)를 **siz가 아닌 별도 차원**(bdl_qty 또는 신규축)으로 분리. base A4/A3는 기존 siz 재사용. B3(364x515)/B4(257x364)는 라이브 부재 → 신규 등록 또는 미사용 판정.
5. **[GP 직경축 — Medium]** 합판도무송 직경(10~60mm step5)을 **직경 전용 의미축**으로 둘지(siz 환원 부적절 가능성). 라이브 원형 4종(13/19/24/35)과 그리드 불일치 → 신규 직경 siz 11종 등록 vs 별축 모델 결정.
6. **[ENV 봉투 모델 — Medium]** 봉투(티켓/소/자켓/대봉투 4종)는 라이브 siz 완전 부재 → 신규 siz 등록 vs 봉투전용 차원 결정.
7. **[박 GAP 유지 — 참고]** 박 가공비 2단 룩업(면적→등급A~E→가격)은 본 분석 범위 밖(siz 문제 아님). round-4 §B 에스컬레이션 유지 — component_prices 6차원에 중간키(등급) 슬롯 부재.
8. **[siz_cd 의미 일관성 — High]** 가격 siz_cd가 유형별로 **완성품/판형/면적좌표**를 혼용하면 가격조회 로직이 유형을 알아야 한다. 매핑 점검에서 "가격 siz_cd는 항상 판형 우선, 면적형만 좌표/함수" 같은 **유형별 규칙**을 명문화할 것.

---

## 부록 A. 핵심 라이브 증거 쿼리 결과 (재현용)

- `OUTPUT_PAPER_TYPE`: .01 국전계열 / .02 46계열 / .03 기타 (부모 1 + 자식 3).
- 국전계열 plate(del_yn=N): **1행** = SIZ_000499 316x467 (PRD_000016 프리미엄엽서).
- 46계열 plate: **0행**.
- GUK4 치수검색(work 305~330 × 455~475 또는 cut 300~320 × 450~465): **SIZ_000499 단일**.
- 3JEOL 치수검색(~318x636 / 636x318): **SIZ_000475 330x640 단일 근접**.
- STK base: A4=SIZ_000050(210x297)·SIZ_000172·SIZ_000258 / A3=SIZ_000052(297x420)·SIZ_000174·SIZ_000315. B3/B4=**부재**.
- POSTER 대형 이산행 존재(900x1200=SIZ_000320, 1500x1000=SIZ_000403, A1=SIZ_000293 등)이나 1000x/1200x **그리드 부재**.
- ACRYL/GP 원형: SIZ_000419(13)·420(19)·421(24)·422(35x35) + 68x70mm원형(SIZ_000369)·100x100mm원형(SIZ_000355). step5 그리드(10/15/20/25/30/40~60) **부재**.
- ENV 봉투: 검색 **0행**.
- 전단지 plate 모델(PRD_000047 소량전단지): SIZ_000171(152x214)/173(216x303)/175(303x426)/177(306x446), 전부 paper=03 기타.

## 부록 B. read-only 준수
- 실행: `SELECT` / `information_schema` / `count(*)`만. INSERT/UPDATE/DELETE/DDL/COMMIT **없음**.
- 비밀번호: `PGPASSWORD` env 경유, stdout 미출력(host/port/user만 노출).
- 산출: 본 .md 1종(한국어, 식별자/SQL 영어). siz 발명·매핑 확정 **없음**(다음 단계 몫).
