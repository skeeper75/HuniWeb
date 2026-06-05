# CPQ 종단 실증 — 프리미엄엽서(PRD_000016) + 봉투 결합 add-on · GAP-1/GAP-3 클로징

> **상태/이력** 작성 2026-06-06 · WIP · `banner-walkthrough.md`와 동일 5절 구조 미러링.
> **목적:** 배너가 못 행사한 GAP을 닫는다 — **GAP-1**(pick-N/SEL_TYPE.02·max_sel_cnt), **GAP-3**(복합 add-on freeze: 봉투+사이즈+수량), **GAP-5**(미적재 차원 vs EXISTS 트리거: 종이 0행).
> **권위 입력(인라인 인용):** `cpq-design.md`(설계 권위·불변) · `banner-walkthrough.md`(구조) · `banner-walkthrough-validation.md`(닫을 GAP 리스트) · `digital-print-l1.csv`(L1 무손실) · `ref-*.csv`(라이브 추출 스냅샷, stale 주의 — 존재 판정 라이브 권위).
> 식별자/코드/SQL/JSON = English, 설명 = Korean. 불확실 코드 `[CONFIRM]`(발명 금지).

---

## 1. 대상 상품 실데이터 (ground truth)

### 1.1 상품 마스터 (라이브 = `ref-products.csv` PRD_000016)

| 컬럼 | 값 | 출처 |
|---|---|---|
| `prd_cd` | `PRD_000016` | ref-products.csv |
| `prd_nm` | 프리미엄엽서 | digital-print-l1.csv row 3~9 |
| `prd_typ_cd` | `PRD_TYPE.04` (디자인상품) | ref-products.csv |
| `nonspec_yn` | `N` | ref-products.csv. (배너와 달리 사용자입력 없음 — 규격 7종 고정) |
| `min_qty / max_qty / qty_incr` | `15 / 10000 / 15` | ref-products.csv. **incr=15 = 73x98 판수와 정합** (L1 row3 판수 15) |
| `qty_unit_typ_cd` | **NULL** | 글로벌 갭 (272 전상품 NULL, silsa.md G-SL-9 동일 패턴) |
| `constraint_json` | NULL (현재) | → §3.6에서 compile 캐시로 채움 |

### 1.2 본체 옵션 캐스케이드 (L1 무손실, 프리미엄엽서 7행 row_seq 3~9)

`digital-print-l1.csv` 프리미엄엽서 7행. **별색인쇄 5컬럼(화이트/클리어/핑크/금색/은색)은 전 7행 공백** — 즉 프리미엄엽서는 별색 미보유(컬럼은 시트에 존재하나 값 없음).

| L1 컬럼(idx) | 추출 값 | 정규화 대상 |
|---|---|---|
| `사이즈(필수)`(11) | 73x98 / 98x98 / 100x150 / 135x135 / 95x210 / 110x170 / 148x210 mm | size (7규격) |
| `판수`(12) | 15 / 12 / 8 / 6 / 6 / 4 / 4 | 사이즈별 **판걸이 수**(가격/판 단위). SIZ note 판걸이와 정합 |
| `종이(필수)`(22) | `*별도설정` (row3) | material → **0행 (GAP-5)** |
| `인쇄(옵션)`(23) | 단면(row3) / 양면(row4) | print_option 도수 |
| `별색인쇄`(24~28) | (전 7행 공백) | — (미보유. 설계상 다중이나 본 상품 미적재) |
| `후가공_모서리`(36) | 직각(row3) / 둥근(row4) | process 택일(PROC_000027/028) |
| `후가공_오시`(37) | 없음 / 1줄 / 2줄 / 3줄 | process PROC_000029 {줄수} |
| `후가공_미싱`(38) | 없음 / 1줄 / 2줄 / 3줄 | process PROC_000030 {줄수} |
| `후가공_가변(텍스트)`(39) | 없음 / 1개 / 2개 / 3개 | process PROC_000031 {개수} |
| `후가공_가변(이미지)`(40) | 없음 / 1개 / 2개 / 3개 | process PROC_000032 {개수} |
| `박/형압 가공`(41) | (값 공백 — 본 상품 미보유) | process PROC_000033 박 / PROC_000050 형압 (composite, 설계상) |
| `추가상품`(44) | OPP비접착110x160 50장 / OPP접착110x160 50장 / 카드봉투화이트165x115 50장 / 카드봉투블랙165x115 50장 / 트레싱지160x110 20장 등 | **addon 템플릿(GAP-3)** |

> **핵심 GAP-1 신호(L1 직접 인용):** row4는 **오시1줄 + 미싱1줄 + 가변텍스트1개 + 가변이미지1개를 동시 선택**(4개 후가공 공정 병렬). row5는 오시2줄+미싱2줄+가변2개+가변2개. → 후가공은 **다중선택(SEL_TYPE.02)** 그룹이어야 함. 배너의 가공(택일 SEL_TYPE.01)이 못 행사한 케이스.

### 1.3 기존 DB 적재 실태 (라이브 = ref-*.csv 스냅샷)

| 차원 | 적재 행 | 코드 / 출처 |
|---|---|---|
| size | **7행** SIZ_000001~007 (전부 dflt_yn=Y) | ref-product-sizes.csv. SIZ_000001=73x98(판걸이18 `[note]`) ~ SIZ_000007=148x210(판걸이4). **주의:** L1 판수(15/12/8/6/6/4/4) vs SIZ note 판걸이(18/12/8/6/6/4/4) — 73x98만 15 vs 18 불일치 `[CONFIRM]` |
| plate_size | 7행 SIZ_000112~118 (SIZ_000112만 OUTPUT_PAPER_TYPE.03+PDF) | ref-product-plate-sizes.csv |
| print_option | **2행** opt_id 1(단면 front=CLR_000005 CMYK/back=CLR_000001 인쇄안함) · opt_id 2(양면 front/back=CLR_000005) | ref-product-print-options.csv + ref-color-counts.csv (CLR_000005=CMYK 4도, CLR_000001=인쇄 안 함) |
| process | **2행** PROC_000027(직각) · PROC_000028(둥근) — 둘 다 모서리(부모 PROC_000026 귀돌이), mand=N, excl 공백 | ref-product-processes.csv + ref-processes.csv |
| material | **0행** | ref-product-materials.csv PRD_000016 부재 — **GAP-5**(종이=*별도설정) |
| excl_groups | 0행 | ref. (배너와 동일 — 마이그레이션 원천 없음, GAP-2 미해당) |
| bundle_qtys / page_rules | 0행 | ref |
| addon | **3행** PRD_000001/002/004 | ref-product-addons.csv (아래 §1.4) |

**적재 공정 정체 확정(ref-processes.csv):**
- `PROC_000027 직각` (부모 PROC_000026 귀돌이, note "default 재단") + `PROC_000028 둥근` (note "R 라운딩") = **모서리 택일** 2종. (배너의 타공/봉제와 달리 후가공 모서리.)
- 후가공 detail opt: `PROC_000029 오시 {줄수 0~3}` · `PROC_000030 미싱 {줄수 0~3}` · `PROC_000031 가변텍스트 {개수 0~3}` · `PROC_000032 가변이미지 {개수 0~3}`. **단 이 4종은 PRD_000016에 적재 0행** → GAP-5 트리거 충돌(§5).
- 별색(설계상 다중): `PROC_000007 별색인쇄` note **"선택유형=다중"** + 자식 5종 화이트008/클리어009/핑크010/금색011/은색012. **PRD_000016 미적재**(L1 공백과 정합).

### 1.4 추가상품 결합 — GAP-3 핵심 (`ref-product-addons.csv` PRD_000016 = 3행)

| addon_prd_cd | 봉투 상품 | note(freeze 명세) | 봉투 prd_typ | 봉투 보유 siz_cd |
|---|---|---|---|---|
| `PRD_000001` | OPP접착봉투 | `OPP접착봉투 110x160 mm 50장` | PRD_TYPE.03 | **SIZ_000085** (110x160mm(50장)) |
| `PRD_000002` | OPP비접착봉투 | `OPP비접착봉투 110x160 mm 50장` | PRD_TYPE.03 | **SIZ_000085** (110x160mm(50장)) |
| `PRD_000004` | 카드봉투 | `카드봉투(화이트) 165x115 mm 50장` | PRD_TYPE.03 | **SIZ_000104** (화이트165x115mm) |

**봉투 siz_cd 실증(ref-sizes.csv — t_prd_template_selections가 실차원 선택을 운반함의 증거):**
- `SIZ_000085` = `110x160mm(50장)`, 110×160. PRD_000001·PRD_000002 둘 다 보유(ref-product-sizes.csv) → note "110x160"과 정합. **봉투는 각자 11/11/2개 자기 사이즈 보유** → 템플릿이 그 중 1개를 freeze.
- `SIZ_000104` = `화이트165x115mm(10장)`, 165×115. PRD_000004 보유 → note "165x115"와 정합. **단 siz 명칭은 "10장"인데 addon note는 "50장"** → 수량 불일치 `[CONFIRM]`(siz 명칭의 장수 vs addon freeze 장수 권위 충돌).
- L1(row3~8)은 봉투 6종+(트레싱지160x110 20장 등) 언급하나 **DB 적재는 3종뿐** → addon은 DB 3행 권위(L1은 카탈로그 후보). 트레싱지봉투는 ref-products.csv **미등록** → addon 불가.

> **GAP-3 대비 배너:** 배너 거치대 template은 selections가 수량만(qty-only). 봉투는 `base 봉투 + siz_cd 1개 + qty 50장`의 **진짜 복합 freeze** → t_prd_template_selections가 차원 선택(siz_cd)을 실제로 운반.

---

## 2. 관리자 셋업 시나리오 (단계별 — 테이블+실행 행 명시)

**Step 0 — 차원 행 전제.** size(SIZ_000001~007)·print_option(단/양면)·process 모서리(027/028)는 라이브 적재 존재. **단 종이(material) 0행·후가공 오시/미싱/가변 0행** → 옵션 등록 전 차원 적재 선행 필요(GAP-5, §5).

**Step 1 — 옵션 그룹 생성** → `t_prd_product_option_groups`
- 도수(택일, 필수) / 모서리(택일, 선택) / **후가공(다중, 선택, max_sel_cnt=4)** / 종이(택일, 필수 — 단 차원 0행) / 추가상품(택일, 선택). 별색(다중)은 본 상품 미보유라 미생성(설계상 등록 가능 명시).

**Step 2 — 옵션 생성** → `t_prd_product_options`
- 도수: 단면/양면. 모서리: 직각/둥근. 후가공: 오시/미싱/가변텍스트/가변이미지(각 독립 다중). 추가상품: 봉투없음/OPP접착/OPP비접착/카드봉투.

**Step 3 — 옵션 재료(polymorphic) 등록** → `t_prd_product_option_items`
- 도수 → ref_dim_cd='color-count'(opt_id). 모서리 → process(027/028). 후가공 → process(029~032)+param. 박/형압 → composite(설계상).

**Step 4 — 제약 등록** → `t_prd_product_constraints` (JSONLogic)
- 후가공 max 4종, 가변텍스트×가변이미지 동시 상한, 수량=판수 배수 등.

**Step 5 — 봉투 템플릿 등록 (GAP-3 핵심)** → `t_prd_templates` + `t_prd_template_selections` → `t_prd_product_addons`
- 봉투 3종을 각각 SKU(template)로: base=봉투 prd_cd + selection(siz_cd) + qty 50장.

**Step 6 — 제약 compile** → `t_prd_products.constraint_json` 갱신.

---

## 3. 테이블별 실제 행 인스턴스화

> `opt_grp_cd`/`opt_cd`/`tmpl_cd`/`rule_cd`는 본 설계 신규 부여. `prd_cd`/`siz_cd`/`proc_cd`/`clr_cd`/`addon_prd_cd`는 라이브 실코드.

### 3.1 `t_prd_product_option_groups` (옵션 그룹) — **GAP-1: SEL_TYPE.02 + max_sel_cnt 행사**

| prd_cd | opt_grp_cd | opt_grp_nm | sel_typ_cd | min_sel_cnt | max_sel_cnt | mand_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_000016 | `OG-DOSU` | 인쇄(도수) | SEL_TYPE.01 (단일/택일) | 1 | 1 | Y | 1 | Y |
| PRD_000016 | `OG-JONGI` | 종이 | SEL_TYPE.01 (단일/택일) | 1 | 1 | Y | 2 | Y |
| PRD_000016 | `OG-MOSEORI` | 모서리 | SEL_TYPE.01 (단일/택일) | 0 | 1 | N | 3 | Y |
| PRD_000016 | **`OG-HUGAGONG`** | **후가공** | **SEL_TYPE.02 (다중/pick-N)** | **0** | **4** | N | 4 | Y |
| PRD_000016 | `OG-CHUGA` | 추가상품(봉투) | SEL_TYPE.01 (단일/택일) | 0 | 1 | N | 5 | Y |

> **GAP-1 클로징:** `OG-HUGAGONG` = **SEL_TYPE.02 + max_sel_cnt=4** — 오시·미싱·가변텍스트·가변이미지 중 0~4개 동시 선택. L1 row4(4종 동시)·row5(4종 동시)가 직접 입증. 배너가 한 번도 못 쓴 pick-N/max-N을 비로소 행사. 출처: digital-print-l1.csv row 4 후가공 4컬럼 동시값.
> (참고: 별색 그룹은 본 상품 미보유로 미생성. 설계상 `OG-BYEOLSAEK` = SEL_TYPE.02 + max_sel_cnt=5 (화이트~은색)가 별색 보유 상품에서 동일 패턴 — PROC_000007 "선택유형=다중"이 마스터 권위.)

### 3.2 `t_prd_product_options` (옵션)

| prd_cd | opt_cd | opt_grp_cd | opt_nm | dflt_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|
| PRD_000016 | `OP-DOSU-SINGLE` | OG-DOSU | 단면 | Y | 1 | Y |
| PRD_000016 | `OP-DOSU-DOUBLE` | OG-DOSU | 양면 | N | 2 | Y |
| PRD_000016 | `OP-JONGI-DEFAULT` | OG-JONGI | 별도설정 `[CONFIRM 차원 0행]` | Y | 1 | Y |
| PRD_000016 | `OP-MOSEORI-JIKGAK` | OG-MOSEORI | 직각 | Y | 1 | Y |
| PRD_000016 | `OP-MOSEORI-DUNGEUN` | OG-MOSEORI | 둥근 | N | 2 | Y |
| PRD_000016 | `OP-HUGA-OSI` | OG-HUGAGONG | 오시 | N | 1 | Y |
| PRD_000016 | `OP-HUGA-MISING` | OG-HUGAGONG | 미싱 | N | 2 | Y |
| PRD_000016 | `OP-HUGA-VARTEXT` | OG-HUGAGONG | 가변텍스트 | N | 3 | Y |
| PRD_000016 | `OP-HUGA-VARIMG` | OG-HUGAGONG | 가변이미지 | N | 4 | Y |
| PRD_000016 | `OP-CHUGA-NONE` | OG-CHUGA | 봉투없음 | Y | 1 | Y |
| PRD_000016 | `OP-CHUGA-OPP-JEOPCHAK` | OG-CHUGA | OPP접착봉투 110x160 50장 | N | 2 | Y |
| PRD_000016 | `OP-CHUGA-OPP-BIJEOPCHAK` | OG-CHUGA | OPP비접착봉투 110x160 50장 | N | 3 | Y |
| PRD_000016 | `OP-CHUGA-CARD-WHITE` | OG-CHUGA | 카드봉투(화이트) 165x115 50장 | N | 4 | Y |

> 출처: digital-print-l1.csv row3~9 + ref-product-addons.csv 3행. (카드봉투 블랙·트레싱지는 L1 언급되나 DB addon 미적재 → 옵션 미생성.)

### 3.3 `t_prd_product_option_items` (옵션 재료 — polymorphic)

> **도수=color-count, 모서리·후가공=process(+param), 봉투=addon(template).** 후가공은 각 옵션 1행이나 그룹이 다중이라 여러 행이 동시 선택됨.

| prd_cd | opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | ref_param_json | qty |
|---|---|---|---|---|---|---|---|
| PRD_000016 | OP-DOSU-SINGLE | 1 | `color-count` | `1` (opt_id 단면) | — | `{"print_side":"단면","front":"CLR_000005","back":"CLR_000001"}` | 1 |
| PRD_000016 | OP-DOSU-DOUBLE | 1 | `color-count` | `2` (opt_id 양면) | — | `{"print_side":"양면","front":"CLR_000005","back":"CLR_000005"}` | 1 |
| PRD_000016 | OP-MOSEORI-JIKGAK | 1 | `process` | `PROC_000027` | — | `{}` (직각=default 재단) | 1 |
| PRD_000016 | OP-MOSEORI-DUNGEUN | 1 | `process` | `PROC_000028` | — | `{}` (둥근=R 라운딩) | 1 |
| PRD_000016 | OP-HUGA-OSI | 1 | `process` | `PROC_000029` `[CONFIRM 차원 0행]` | — | `{"줄수":2}` (값 가변 1~3) | 1 |
| PRD_000016 | OP-HUGA-MISING | 1 | `process` | `PROC_000030` `[CONFIRM 차원 0행]` | — | `{"줄수":2}` | 1 |
| PRD_000016 | OP-HUGA-VARTEXT | 1 | `process` | `PROC_000031` `[CONFIRM 차원 0행]` | — | `{"개수":2}` | 1 |
| PRD_000016 | OP-HUGA-VARIMG | 1 | `process` | `PROC_000032` `[CONFIRM 차원 0행]` | — | `{"개수":2}` | 1 |
| PRD_000016 | OP-CHUGA-NONE | 1 | (재료 0행 — "선택안함" 센티넬) | — | — | — | — |
| PRD_000016 | OP-CHUGA-OPP-JEOPCHAK | 1 | `addon` (template) | `TMPL-ENV-OPP-JEOPCHAK` | — | — | 1 |
| PRD_000016 | OP-CHUGA-OPP-BIJEOPCHAK | 1 | `addon` (template) | `TMPL-ENV-OPP-BIJEOPCHAK` | — | — | 1 |
| PRD_000016 | OP-CHUGA-CARD-WHITE | 1 | `addon` (template) | `TMPL-ENV-CARD-WHITE` | — | — | 1 |

**해설 (composite 박/형압 — 설계상, 본 상품 미보유):** 박/형압이 보유 상품이면 한 옵션이 2~3행 composite —
```
OP-BAK-FRONT  seq1: process PROC_000033 박, ref_param_json {"크기":10}, qty 1   (박 가공)
OP-BAK-FRONT  seq2: process PROC_000034 금   (박색상 — PROC_000033 자식 16종 중)
OP-BAK-FRONT  seq3: process PROC_000050 형압  (형압 동반 시)
```
프리미엄엽서는 L1 박/형압 컬럼 공백 → 미인스턴스화(발명 금지). 단 박/형압이 **박가공+박색상+형압 = 3차원 composite**임을 설계상 명시(배너 각목+끈 2행보다 깊은 composite).

### 3.4 `t_prd_templates` + `t_prd_template_selections` (봉투 add-on — **GAP-3 핵심 증명**)

**`t_prd_templates`** (봉투 3종 = SKU. base=봉투 prd_cd):

| tmpl_cd | base_prd_cd | tmpl_nm | dflt_qty | price | use_yn | note |
|---|---|---|---|---|---|---|
| `TMPL-ENV-OPP-JEOPCHAK` | `PRD_000001` | OPP접착봉투 110x160 50장 | 50 | `[CONFIRM 가격]` | Y | ref-product-addons note "OPP접착봉투 110x160 mm 50장" |
| `TMPL-ENV-OPP-BIJEOPCHAK` | `PRD_000002` | OPP비접착봉투 110x160 50장 | 50 | `[CONFIRM 가격]` | Y | note "OPP비접착봉투 110x160 mm 50장" |
| `TMPL-ENV-CARD-WHITE` | `PRD_000004` | 카드봉투(화이트) 165x115 50장 | 50 | `[CONFIRM 가격]` | Y | note "카드봉투(화이트) 165x115 mm 50장" |

**`t_prd_template_selections`** (봉투의 **자기 사이즈(siz_cd) 1개를 freeze** — 실차원 선택 운반):

| tmpl_cd | seq | ref_dim_cd | ref_key1 | value | qty |
|---|---|---|---|---|---|
| TMPL-ENV-OPP-JEOPCHAK | 1 | `size` | `SIZ_000085` | 110x160mm | 50 |
| TMPL-ENV-OPP-BIJEOPCHAK | 1 | `size` | `SIZ_000085` | 110x160mm | 50 |
| TMPL-ENV-CARD-WHITE | 1 | `size` | `SIZ_000104` | 화이트165x115mm | 50 |

> **GAP-3 클로징:** template_selections가 **base 봉투의 차원 행(siz_cd)을 실제로 선택**한다. SIZ_000085는 PRD_000001/002가 라이브 보유(ref-product-sizes.csv), SIZ_000104는 PRD_000004 보유 → **검증 트리거(EXISTS in 봉투의 sizes)가 통과**. 배너 거치대는 selections가 qty-only였으나, 봉투는 `base + siz_cd + qty=50`의 진짜 복합 freeze.
> **충돌 노출 `[CONFIRM]`:** SIZ_000104 명칭은 "(10장)"인데 selection qty=50 (addon note 권위). siz 명칭 장수 vs freeze 장수 불일치 — 마스터 데이터 정합 필요.

### 3.5 `t_prd_product_addons` (변경: addon_prd_cd → tmpl_cd)

| prd_cd | tmpl_cd | disp_seq | note |
|---|---|---|---|
| PRD_000016 | TMPL-ENV-OPP-JEOPCHAK | 1 | OPP접착봉투 50장 (AS-IS: PRD_000016→PRD_000001) |
| PRD_000016 | TMPL-ENV-OPP-BIJEOPCHAK | 2 | OPP비접착봉투 50장 (AS-IS: →PRD_000002) |
| PRD_000016 | TMPL-ENV-CARD-WHITE | 3 | 카드봉투화이트 50장 (AS-IS: →PRD_000004) |

> **AS-IS→TO-BE 마이그레이션:** 기존 `(PRD_000016, PRD_000001, note "110x160 50장")` 직접링크 → `(PRD_000016, TMPL-ENV-OPP-JEOPCHAK)`. note의 "110x160 50장" freeze 정보가 **note 문자열에서 구조화된 template_selections로 승격**(siz_cd=SIZ_000085, qty=50). **이것이 add-on 변경의 핵심 가치** — 배너에선 note가 빈약했으나, 봉투 note는 실제 차원 freeze를 담고 있어 구조화 이득이 큼.

### 3.6 `t_prd_product_constraints` (JSONLogic rule 행)

> data 키: `{ "dosu": opt_cd, "moseori": opt_cd, "hugagong": [opt_cd...], "osi_julsu": int, "mising_julsu": int, "vartext_cnt": int, "varimg_cnt": int, "chuga": opt_cd, "siz_cd": str, "qty": int }`. 후가공은 **배열**(다중선택).

**Rule 1 — 후가공 다중선택 최대 4종 (GAP-1 max-N 검증)**

| prd_cd | rule_cd | rule_nm | rule_typ | err_msg | use_yn | disp_seq |
|---|---|---|---|---|---|---|
| PRD_000016 | `R-HUGA-MAXN` | 후가공 최대 4종 | compatible | 후가공은 최대 4종까지 선택 가능합니다 | Y | 1 |

```json
{ "<=": [ { "reduce": [ { "var": "hugagong" }, { "+": [ { "var": "accumulator" }, 1 ] }, 0 ] }, 4 ] }
```
> hugagong 배열 길이 ≤ 4. 출처: OG-HUGAGONG max_sel_cnt=4 (오시/미싱/가변텍스트/가변이미지 4종).

**Rule 2 — 후가공 줄수/개수 범위 (공정 detail opt 정합)** — 오시/미싱 줄수 0~3, 가변 개수 0~3 (ref-processes PROC_000029~032 max=3)

| prd_cd | rule_cd | rule_nm | rule_typ | err_msg | use_yn | disp_seq |
|---|---|---|---|---|---|---|
| PRD_000016 | `R-HUGA-PARAM` | 후가공 파라미터 범위 | compatible | 오시/미싱 줄수·가변 개수는 0~3 범위입니다 | Y | 2 |

```json
{ "and": [
    { ">=": [ { "var": "osi_julsu" },   0 ] }, { "<=": [ { "var": "osi_julsu" },   3 ] },
    { ">=": [ { "var": "mising_julsu" },0 ] }, { "<=": [ { "var": "mising_julsu" },3 ] },
    { ">=": [ { "var": "vartext_cnt" }, 0 ] }, { "<=": [ { "var": "vartext_cnt" }, 3 ] },
    { ">=": [ { "var": "varimg_cnt" },  0 ] }, { "<=": [ { "var": "varimg_cnt" },  3 ] }
] }
```
> 출처: ref-processes.csv PROC_000029 오시 `{줄수 min:0 max:3}`, PROC_000030 미싱 동일, PROC_000031/032 가변 `{개수 min:0 max:3}`.

**Rule 3 — 제작수량 = 판수 배수 (사이즈별 판걸이 정합)** — L1 incr=판수 (73x98→15, 100x150→8)

| prd_cd | rule_cd | rule_nm | rule_typ | err_msg | use_yn |
|---|---|---|---|---|---|
| PRD_000016 | `R-QTY-PANSU` | 수량 판수 배수 | required | 제작수량은 선택 사이즈의 판수 배수여야 합니다 | Y |

```json
{ "or": [
    { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000001" ] }, { "==": [ { "%": [ { "var": "qty" }, 15 ] }, 0 ] } ] },
    { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000003" ] }, { "==": [ { "%": [ { "var": "qty" }, 8  ] }, 0 ] } ] },
    { "and": [ { "!=": [ { "var": "siz_cd" }, "SIZ_000001" ] }, { "!=": [ { "var": "siz_cd" }, "SIZ_000003" ] } ] }
] }
```
> 73x98=15판 배수, 100x150=8판 배수 예시. 출처: digital-print-l1.csv row3 incr 15 / row5 incr 8. (전 7사이즈 완전 표는 생략 — 패턴 동일.)

**`t_prd_products.constraint_json` (compile 캐시 — 활성 rule AND 결합):**

```json
{ "and": [
    { "<=": [ { "reduce": [ {"var":"hugagong"}, {"+":[{"var":"accumulator"},1]}, 0 ] }, 4 ] },
    { "and": [ {">=":[{"var":"osi_julsu"},0]},{"<=":[{"var":"osi_julsu"},3]},
               {">=":[{"var":"mising_julsu"},0]},{"<=":[{"var":"mising_julsu"},3]},
               {">=":[{"var":"vartext_cnt"},0]},{"<=":[{"var":"vartext_cnt"},3]},
               {">=":[{"var":"varimg_cnt"},0]},{"<=":[{"var":"varimg_cnt"},3]} ] },
    { "or": [ {"and":[{"==":[{"var":"siz_cd"},"SIZ_000001"]},{"==":[{"%":[{"var":"qty"},15]},0]}]},
              {"and":[{"==":[{"var":"siz_cd"},"SIZ_000003"]},{"==":[{"%":[{"var":"qty"},8]},0]}]},
              {"and":[{"!=":[{"var":"siz_cd"},"SIZ_000001"]},{"!=":[{"var":"siz_cd"},"SIZ_000003"]}]} ] }
] }
```

---

## 4. 고객 선택 → MES 환원 트레이스 (봉투 결합 = 2 주문라인)

**고객 선택 (구체):** 프리미엄엽서 / `100x150`(SIZ_000003, 8판) / 양면 / 모서리 둥근 / 후가공: 오시2줄+미싱2줄(2종 동시) / 봉투: OPP접착봉투(TMPL-ENV-OPP-JEOPCHAK) ×1 / 제작수량 80장(8판 ×10).

**선택 → 옵션 행:**
```
siz_cd       = SIZ_000003 (100x150)
dosu         = OP-DOSU-DOUBLE       (OG-DOSU 택1)
moseori      = OP-MOSEORI-DUNGEUN   (OG-MOSEORI 택1)
hugagong     = [OP-HUGA-OSI, OP-HUGA-MISING]   ← 다중선택 2종
  osi_julsu=2, mising_julsu=2, vartext_cnt=0, varimg_cnt=0
chuga        = OP-CHUGA-OPP-JEOPCHAK  (addon template)
qty          = 80
```

**제약 평가 (constraint_json, json-logic-js):**
- R-HUGA-MAXN: hugagong 길이 2 ≤ 4 → **TRUE**
- R-HUGA-PARAM: osi 2·mising 2 ∈ [0,3] → **TRUE**
- R-QTY-PANSU: SIZ_000003 → 80 % 8 == 0 → **TRUE**
- 전체 PASS ✅

**환원 (resolve) — option_items → material+process+addon:**

| 선택 | option_items 행 | ref_dim_cd | 환원 결과 |
|---|---|---|---|
| 사이즈 | SIZ_000003 | size | 100x150 (work=102x152, cut=100x150) |
| 종이 | OP-JONGI-DEFAULT (차원 0행) | material | **`[CONFIRM]` 별도설정 — 환원 미완(GAP-5)** |
| 양면 | OP-DOSU-DOUBLE | color-count | print_option opt_id 2, front/back=CLR_000005 CMYK |
| 모서리 둥근 | OP-MOSEORI-DUNGEUN | process | PROC_000028 둥근(R 라운딩) |
| 오시2줄 | OP-HUGA-OSI | process | PROC_000029 오시 `{"줄수":2}` |
| 미싱2줄 | OP-HUGA-MISING | process | PROC_000030 미싱 `{"줄수":2}` |
| 봉투 | OP-CHUGA-OPP-JEOPCHAK → TMPL-ENV-OPP-JEOPCHAK | addon | **별도 주문라인**: base=PRD_000001, siz=SIZ_000085, qty=50 |

**MES 주문 페이로드 (resolved JSON — 2 라인):**
```json
{
  "order_lines": [
    {
      "line_type": "MAIN",
      "prd_cd": "PRD_000016",
      "prd_nm": "프리미엄엽서",
      "qty": 80,
      "size": { "siz_cd": "SIZ_000003", "name": "100x150", "work": "102x152", "cut": "100x150", "pansu": 8 },
      "materials": [ { "mat_cd": "[CONFIRM]", "note": "종이=별도설정, 차원 0행 → 환원 미완 (GAP-5)" } ],
      "print_option": { "opt_id": 2, "print_side": "양면", "front_clr": "CLR_000005", "back_clr": "CLR_000005" },
      "processes": [
        { "proc_cd": "PROC_000028", "proc_nm": "둥근", "params": {}, "consume_qty": 1 },
        { "proc_cd": "PROC_000029", "proc_nm": "오시", "params": { "줄수": 2 }, "consume_qty": 1 },
        { "proc_cd": "PROC_000030", "proc_nm": "미싱", "params": { "줄수": 2 }, "consume_qty": 1 }
      ]
    },
    {
      "line_type": "ADDON",
      "tmpl_cd": "TMPL-ENV-OPP-JEOPCHAK",
      "tmpl_nm": "OPP접착봉투 110x160 50장",
      "resolved_product": {
        "prd_cd": "PRD_000001",
        "prd_nm": "OPP접착봉투",
        "size": { "siz_cd": "SIZ_000085", "name": "110x160mm" },
        "qty": 50
      },
      "addon_price": "[CONFIRM 가격]"
    }
  ]
}
```

**설계 원칙 #1 증명 (본체 + 결합상품 둘 다):**
- **MAIN 라인:** 양면(color-count)·모서리(PROC_000028)·후가공 2종(PROC_000029/030)이 전부 process/print_option으로 환원. **단 종이가 material 0행이라 `mat_cd=[CONFIRM]` — 환원 미완** (GAP-5가 원칙 #1을 부분 위반: 별도설정 종이는 MES가 무엇을 생산할지 미결).
- **ADDON 라인:** 봉투가 **자기 prd_cd(PRD_000001) + 자기 siz_cd(SIZ_000085) + qty 50** 으로 완전 환원 → **별도 주문상세 라인**으로 MES에 넘어가 봉투가 독립 생산. 이것이 "추가상품 결합"의 본질 — 봉투는 엽서의 옵션이 아니라 **함께 주문되는 별개 완제품**.
- template이 freeze한 siz_cd가 봉투 자기 차원에 실재(트리거 통과)하므로, 배너 거치대(`[CONFIRM]` base_prd_cd)와 달리 **환원이 코드까지 완결**(가격만 `[CONFIRM]`).

---

## 5. 설계 검증 — GAP 클로징 + 신규 긴장 + 정직한 한계

### 5.1 닫힌 GAP (배너 검증 must-fix 대비) ✅

**GAP-1 (pick-N / max-N, SEL_TYPE.02) — CLOSED.**
- `OG-HUGAGONG` = **SEL_TYPE.02 + max_sel_cnt=4**. L1 row4/row5가 오시·미싱·가변텍스트·가변이미지 **4종 동시 선택**을 실데이터로 입증(digital-print-l1.csv). 배너가 한 번도 못 쓴 다중선택·max-N을 비로소 행사. R-HUGA-MAXN JSONLogic이 max-N 검증.
- 보강: 별색(PROC_000007 "선택유형=다중") 5종도 동일 SEL_TYPE.02 패턴이나 **본 상품 미보유**(L1 별색 5컬럼 전 공백) → 별색 보유 상품에서 추가 실증 필요(과대주장 회피).
- **단서(검증 GAP-A):** max_sel_cnt=4=후가공 전체 4종 → 상한이 항상 만족(위반 불가)이라 **진짜 max-N(전체>상한)은 미실증**. SEL_TYPE.02 '다중선택'은 완전히 닫혔으나, max_sel_cnt<옵션수인 진짜 상한(예: 박색상 16종 중 N종)은 별도 케이스 필요.

**GAP-3 (composite add-on freeze) — CLOSED.**
- 봉투 3종 template이 **base 봉투 prd_cd + siz_cd 1개 + qty 50장** 의 진짜 복합 freeze. SIZ_000085(110x160)·SIZ_000104(165x115)가 봉투 자기 차원에 실재(ref-product-sizes.csv) → template_selections가 실차원 선택을 운반. 배너 거치대(qty-only)가 못 행사한 "OPP봉투+사이즈+50장"을 실증. AS-IS note 문자열 freeze가 구조화 selections로 승격.

**GAP-2 (excl-group 마이그레이션) — 미해당(N/A).**
- 프리미엄엽서도 excl_grp_cd 0행(배너와 동일) → 마이그레이션 원천 없음. 이 GAP은 GRP-BOOK류(제본 택일, silsa 밖) 상품으로만 실증 가능 — 본 워크스루 범위 밖임을 정직히 명시(배너 검증 GAP-2와 동일 상태).

**GAP-5 (미적재 차원 vs EXISTS 트리거) — RE-TESTED, 충돌 확인.**
- 종이=`*별도설정` → material 0행(ref-product-materials.csv PRD_000016 부재 확인). 후가공 오시/미싱/가변(029~032)도 PRD_000016 process 0행(적재는 모서리 027/028 2행뿐).
- **트리거 충돌 실재:** 설계 §4 EXISTS 트리거는 "그 상품에 등록된 차원 행만 참조" 강제. 그러나 OP-JONGI-DEFAULT(material)·OP-HUGA-OSI(PROC_000029) 옵션은 **참조할 차원 행이 없다** → 트리거 위반 → 옵션 등록 불가. 배너 검증 GAP-5(열재단 PROC_000053 미적재)와 **동일 구조 결함**이 프리미엄엽서에서 더 광범위(종이 전체 + 후가공 4종).
- **해소 방향(§5.3 권고):** ① material/process 차원 선적재 후 옵션 등록(정석), ② "별도설정"은 차원 행 없는 **deferred 센티넬**로 특별 처리(material_cd=NULL 허용 + MES 단계 수기 지정), ③ 후가공 029~032를 PRD_000016 process로 선적재.

### 5.2 프리미엄엽서가 드러낸 신규 설계 긴장 ⚠️

**(a) 별색 5종 multi-select vs 2행 print_option — 도수와 별색의 모델 분리.**
- 도수(단/양면)는 `t_prd_product_print_options`(2행, opt_id) 차원이고, 별색(화이트~은색)은 `process`(PROC_000007 family) 차원이다 — **둘 다 "인쇄 색상"인데 모델이 다름**. 옵션 레이어에서 도수=ref_dim_cd 'color-count', 별색=ref_dim_cd 'process'로 갈림. 사용자에겐 둘 다 "색상 옵션"이나 환원 경로가 print_option vs process로 분기. 설계는 이를 표현 가능하나, **"색상" UX 그룹 ≠ 단일 차원**임이 드러남(배너엔 없던 긴장).

**(b) 판수(pansu) = 사이즈별 가격/수량 축 — 차원에 없는 숨은 축.**
- 판수(15/12/8/6/6/4/4)는 사이즈마다 다르고 제작수량 증가단위(incr)와 결합. CPQ 차원 7종(size/material/process/도수/판형/bundle/set) 어디에도 "판수" 전용 축이 없다 → **size 행의 부속 속성(SIZ note 판걸이)** 으로만 존재. R-QTY-PANSU constraint가 우회 검증하나, 판수는 가격엔진(범위 밖)의 핵심 입력 → **옵션 레이어가 가격축을 표현 못 함**(설계 경계의 정당한 한계이나, size×set-count 시대엔 없던 "수량 증가가 사이즈 의존" 케이스).

**(c) 박/형압 = 3차원 composite (박가공+박색상+형압) — 배너 각목+끈(2행)보다 깊음.**
- 박 1개 옵션 = process(PROC_000033 박)+{크기}+박색상(16종 자식 중)+형압(PROC_000050) 동반 가능 = item_seq 2~3행. composite의 깊이가 증가 → §5.2(배너) "복합 항목 결합 의미(AND동반)" 명문화 필요성이 더 강해짐. 박색상은 박가공의 **하위 종속**(박 없이 박색상 무의미)이라 단순 AND가 아닌 **계층 종속** → item 간 관계 표현 부족 재확인.
- **(검증 정정):** 형압 PROC_000050은 박 PROC_000033과 **별개 트리**(형압 자식 051양각/052음각)다. 정확히는 "박(가공+박색상 1트리, 박색상이 계층 종속) + 형압(별트리)" = **2 독립축**이며, 계층 종속은 박색상⊂박에만 해당. "3차원 단일 composite"가 아니라 "2 독립축 + 박 내부 종속".

**(d) 봉투 template이 봉투 자기 옵션을 상속하는가? — template 깊이의 한계.**
- 봉투(PRD_000001)는 자기 사이즈 11종 보유. template은 그 중 1개(SIZ_000085)를 freeze. 그러나 봉투가 *자기 옵션(인쇄/색상 등)* 을 가지면 template_selections가 그것도 freeze해야 함. 현 봉투는 단순(PRD_TYPE.03 기성, 옵션 빈약)이라 siz 1개로 충분하나, **옵션 풍부한 상품을 add-on으로 freeze하면 selections가 base 상품의 전 옵션 트리를 복제**해야 함 → template_selections 폭발 위험. 봉투는 운 좋게 단순했을 뿐.

**(e) addon note의 "50장" vs siz 명칭 "10장" 불일치 (SIZ_000104).**
- ref-product-addons note는 "165x115 50장"인데 SIZ_000104 명칭은 "화이트165x115mm(10장)". **장수가 siz 명칭에 baked-in** + addon note에 또 명시 → 이중 출처 충돌. template_selections.qty(50, addon 권위)가 정답이나, siz 명칭의 (10장)이 혼란 야기 → **siz 명칭에 수량을 넣은 마스터 설계 자체가 안티패턴**(siz는 치수만, 수량은 별도 축). `[CONFIRM]` 마스터 정합 필요.

### 5.3 개선 권고 (concrete)
1. **GAP-5 해소 정책 확정** — "별도설정" 종이를 deferred 센티넬(material_cd=NULL + MES 수기지정)로 명문화하거나, 종이 차원 선적재 의무화. 트리거에 "센티넬 옵션은 EXISTS 면제" 예외 추가.
2. **후가공 029~032 + 모서리 027/028을 한 옵션그룹으로 묶되, 적재 선행** — 현재 process 0행(029~032)이라 옵션 등록 시 트리거 위반. process 적재 → 옵션 등록 순서 강제.
3. **도수/별색 "색상" UX 그룹 ↔ print_option/process 이중 차원 매핑 명문화** — 옵션그룹은 UX 단위(색상), ref_dim_cd는 차원 단위(color-count/process)로 분리 표현 규약.
4. **박/형압 계층 종속(박색상⊂박가공) 표현** — item_combine_typ에 "AND동반" 외 "하위종속(parent_item_seq)" 추가 권고. 배너 §5.2(b) 권고의 강화.
5. **판수=size 부속속성 명시** — size 차원 행에 pansu 컬럼(또는 note 구조화). 가격엔진 입력으로 직결되나 옵션 레이어 밖.
6. **siz 명칭의 수량 baked-in 제거** — SIZ_000104 "화이트165x115mm(10장)" → 치수만(165x115), 수량은 template/addon 축. 마스터 데이터 정합.
7. **template_selections 깊이 한계 인지** — 옵션 풍부한 상품을 add-on으로 freeze 시 selections 폭발 위험. 단순 기성품(PRD_TYPE.03) 위주로 add-on 권장 또는 "base 상품 옵션 상속" 메커니즘 별도 설계.

### 5.4 정직한 한계
- **별색 multi-select은 설계상 가능 입증이지 본 상품 실증 아님** — L1 별색 5컬럼 전 공백. GAP-1은 후가공으로 실증했고 별색은 마스터 권위(PROC_000007 다중)로만 뒷받침.
- **박/형압 composite는 미인스턴스화** — L1 박/형압 컬럼 공백 → 발명 금지로 설계상 기술만.
- **봉투 가격 전부 `[CONFIRM]`** — ref-product-addons에 가격 컬럼 없음(addon 추가가격은 L1 col45나 봉투 자체 단가는 별도). 환원이 코드까지는 완결되나 가격은 미완(가격엔진 범위 밖).
- **GAP-2(마이그레이션)는 여전히 미실증** — 엽서도 excl-group 0행. 배너 검증 must-fix #1 그대로 남음.

### 5.5 독립 적대검증 반영 (`postcard-walkthrough-validation.md` · 판정 CONDITIONAL-GO)

dbm-validator 독립 검증: 고위험 7체크 전건 VERIFIED, **INVENTED 0 · OVERSTATED 0**, JSONLogic(reduce 배열길이 포함) 손계산 일치. **GAP-1·GAP-3 진짜 닫힘**(구조·실데이터·JSONLogic 3중 입증) 확정. 단 다음 보정:

| 항목 | 등급 | 내용 | 처리 |
|---|---|---|---|
| MISMATCH-1 | 설계버그 | `color-count` ref_key1 = clr_cd(설계)는 단/양면 식별 불가 → opt_id가 맞음 | `cpq-design.md` §3.1 매핑표 정정 완료 |
| GAP-A | MAJOR | max_sel_cnt=4=전체4 → 진짜 max-N(전체>상한) 미실증. '다중선택'만 닫힘 | §5.1 단서 반영. 박색상 등 max<전체 케이스 필요 |
| GAP-B | MINOR | L1 row3 ★사이즈선택(본체연동 가변 봉투) → template 고정 freeze 미지원 | 설계 한계로 기록(cpq-design §6) |
| GAP-C | MINOR | note 문자열→siz_cd 마이그레이션 결정규칙 미정 | 명문화 필요(cpq-design §6) |
| 차원명 | 비차단 | ref_dim_cd `addon`(엽서) vs `set`(배너) 미통일 → 설계 OPT_REF_DIM에 addon 누락 | `cpq-design.md` OPT_REF_DIM에 addon 추가 완료 |

**종합:** 프리미엄엽서는 배너가 못 메운 **GAP-1(다중선택)·GAP-3(복합 add-on freeze)를 실증으로 닫았다**. 잔존: 진짜 max-N(GAP-A)·동적 freeze(GAP-B)·excl-group 마이그레이션(GAP-2, 배너서 승계)은 여전히 별도 케이스 필요.

---

## 부록 — 인용 출처 색인 (검증용)

| 코드/값 | 출처 |
|---|---|
| PRD_000016 프리미엄엽서 qty 15/10000/15 nonspec=N | ref-products.csv |
| SIZ_000001~007 (73x98~148x210, 판걸이 18/12/8/6/6/4/4) | ref-product-sizes.csv / ref-sizes.csv |
| 판수 15/12/8/6/6/4/4 | digital-print-l1.csv row3~9 col12 |
| material 0행 (종이=별도설정) | ref-product-materials.csv (PRD_000016 부재) / L1 col22 `*별도설정` |
| print_option 2행 (단면 CMYK/인쇄안함, 양면 CMYK/CMYK) | ref-product-print-options.csv |
| CLR_000005 CMYK 4도 / CLR_000001 인쇄 안 함 | ref-color-counts.csv |
| PROC_000027 직각 / PROC_000028 둥근 (부모 PROC_000026 귀돌이) | ref-processes.csv / ref-product-processes.csv |
| PROC_000029 오시{줄수0~3}/030 미싱{줄수0~3}/031 가변텍스트{개수0~3}/032 가변이미지{개수0~3} | ref-processes.csv (미적재 차원 — GAP-5) |
| PROC_000007 별색인쇄 "선택유형=다중" + 008~012 화이트/클리어/핑크/금색/은색 | ref-processes.csv (본 상품 미보유) |
| PROC_000033 박{크기mm}+색상16종 / PROC_000050 형압 | ref-processes.csv (composite, 미인스턴스화) |
| 후가공 동시선택 (row4: 오시1+미싱1+가변텍스트1+가변이미지1) | digital-print-l1.csv row4 col37~40 — GAP-1 핵심 |
| addon 3행 PRD_000001/002/004 | ref-product-addons.csv PRD_000016 |
| 봉투 siz SIZ_000085(110x160 50장)/SIZ_000104(화이트165x115) | ref-sizes.csv / ref-product-sizes.csv (PRD_000001/002 보유 085, PRD_000004 보유 104) |
| 봉투 prd_typ PRD_TYPE.03 | ref-products.csv PRD_000001/002/004 |
| SIZ_000104 명칭 "(10장)" vs note "50장" 불일치 | ref-sizes.csv vs ref-product-addons.csv `[CONFIRM]` |
| 트레싱지봉투 미등록 | ref-products.csv (검색 0건) |
| SEL_TYPE.01 단일/.02 다중 | code-values.md |
</content>
