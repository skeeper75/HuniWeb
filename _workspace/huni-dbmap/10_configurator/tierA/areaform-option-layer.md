# Tier A 면적형 포스터·배너 13상품 — CPQ 옵션 레이어(L2) 설계

> **상태/이력** 작성 2026-06-14 · WIP · `dbm-option-mapper` (round-6 CPQ L2). DB 미적재(실 INSERT/코드행/DDL = 인간 승인). GO 판정 = `dbm-validator`.
> **권위 입력(인라인 인용·발명 금지):** `06_extract/silsa-l1.csv`(13상품 옵션 캐스케이드 L1) · `10_configurator/attribute-entity-map.md §2 패밀리③`(면적형 권위) · `banner-walkthrough.md`+`-validation.md`(일반현수막 138 형제 패턴) · `09_load/_exec_silsa_cpq/`(138 적재 패턴 권위) · `00_schema/cpq-schema.md`(라이브 트리거) · **라이브 read-only 실측 2026-06-14**(`RAILWAY_DB_*`, 차원행/트리거/surrogate).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 = `[CONFIRM]`.

---

## 0. 요약 — 13상품 INSERTABLE/BLOCKED 한눈

> 아래 수치는 **DRY-RUN 실증된 생성 카운트**(2026-06-14, gen_load_sql.py). option 수 = INSERTABLE option(센티넬 포함). BLOCKED option은 별도 열.

| prd_cd | prd_nm | OG 수 | option(INSERTABLE) | item INSERTABLE | BLOCKED option | constraint | 비고 |
|---|---|:--:|:--:|:--:|:--:|:--:|---|
| PRD_000118 | 아트프린트포스터 | 1 (코팅) | 3 | 2 | 0 | R-SIZE-NONSPEC | 코팅없음 센티넬 |
| PRD_000120 | 방수포스터 | 1 (코팅) | 2 | 2 | 0 | R-SIZE-NONSPEC | |
| PRD_000121 | 접착방수포스터 | 1 (코팅) | 2 | 2 | 0 | R-SIZE-NONSPEC | |
| PRD_000122 | 접착투명포스터 | 1 (별색) | 1 | 1 | 0 | R-SIZE-NONSPEC | 화이트단면=공정 008 |
| PRD_000124 | 린넨패브릭포스터 | 1 (가공) | 3 | 3 | 2 | R-SIZE-NONSPEC | +끈 복합 2종 BLOCKED(끈자재 미링크) |
| PRD_000125 | 캔버스패브릭포스터 | 1 (가공) | 1 | 1 | 0 | R-SIZE-NONSPEC | 오버로크=봉제 |
| PRD_000133 | 캔버스행잉포스터 | 2 (가공·추가) | 2 | 1 | 1 | — | 우드행거+면끈 BLOCKED |
| PRD_000134 | 린넨우드봉족자 | 2 (가공·추가) | 2 | 1 | 1 | — | 우드봉+면끈 BLOCKED·복합유형 1 item(GAP-PARAM) |
| PRD_000135 | 족자포스터 | 2 (가공·추가) | 3 | 2 | 1 | — | 천정형고리 BLOCKED |
| PRD_000136 | PET배너 | 3 (코팅·가공·추가) | 4 | 3 | 2 | — | 실내/실외 거치대 BLOCKED(template) |
| PRD_000137 | 메쉬배너 | 2 (가공·추가) | 2 | 1 | 2 | — | 거치대 BLOCKED |
| PRD_000139 | 메쉬현수막 | 2 (가공·추가) | 4 | 3 | 2 | R-SIZE-NONSPEC | 타공4/6/8 INSERTABLE·**재단만/끈추가 L1 LINK 의존 BLOCKED [FINDING-1]** |
| PRD_000145 | 미니배너 | 1 (코팅) | 2 | 2 | 0 | — | nonspec 없음 |

**합계(DRY-RUN 실증·FINDING-1 보정 후): option_groups 20 · options(L2 순수) 31 · option_items INSERTABLE 24 · BLOCKED option 11 · constraints 7. apply.sql INSERT 82. + L1 LINK 선적재 3(별도 `_l1_link_preload.sql`·인간 승인 선행).**

> **[FINDING-1 보정]** L1 차원 LINK(product-materials/processes INSERT)는 `apply.sql`(L2 순수)에서 분리 → `_l1_link_preload.sql`로 격리. 139 재단만(PROC_000084)·끈추가(MAT_000070+PROC_000081)는 L1 LINK 의존이라 124/133/134/135 복합끈과 **동일하게 BLOCKED 격리**(LINK 선적재=인간 승인 후 INSERTABLE 승격). DRY-RUN으로 L2 트랜잭션이 139 product-link 미생성(BEFORE==AFTER) 실증.

> [HARD] prn=0 (13상품 전부 print_option 도수 0행) → **도수 옵션그룹 0개 생성**. 단 122 "화이트단면"·121/120 "코팅"·136 "타공" 등은 라이브 process로 적재돼 있어 그쪽으로 환원(아래 §2). 122 화이트단면은 도수가 아니라 **별색 공정(PROC_000008 화이트)** 으로 라이브 등록됨.

---

## 1. 라이브 차원행 실측 (Step 0 전제 — 2026-06-14 read-only)

옵션 레이어는 *이미 적재된 차원행*만 가리킨다. 13상품 차원행 실측:

### 1.1 sizes (39행 전부 적재 — INSERTABLE 전제 충족)

규격 사이즈는 전부 라이브 적재됨(예 118 = SIZ_000174/197/293, 124 = SIZ_000295~301 6규격, 139 = SIZ_000320/322/323, 145 = SIZ_000028/328). **비규격(사용자입력)은 products 범위(아래 1.4)이지 siz 행 아님** — option_item에 넣지 않는다.

### 1.2 materials (13행 — 각 상품 본 소재 1행)

| prd_cd | mat_cd | mat_nm |
|---|---|---|
| 118 | MAT_000176 | 인화지 |
| 120/135/136/145 | MAT_000178 | PET |
| 121 | MAT_000179 | PVC |
| 122 | MAT_000180 | 투명PVC |
| 124/134 | MAT_000184 | 린넨 |
| 125/133 | MAT_000185 | 캔버스(옥스포드) |
| 137/139 | MAT_000183 | 메쉬 |

> **소재 1행 = 선택지 1개.** 13상품 모두 소재 1행만 보유 → **소재 옵션그룹 미생성**(실제 선택축 아님, 고정값·note 표기). attribute-entity-map §2 면적형 핵심 verdict와 정합. (단 BUNDLE 자재 부속[끈·우드행거]은 별도 §2 BLOCKED.)

### 1.3 processes (라이브 링크 실측 — 가공/코팅/별색 환원처)

| prd_cd | 링크된 proc_cd | proc_nm | 환원 대상 옵션 |
|---|---|---|---|
| 118/120/121/136/145 | PROC_000014·PROC_000015 | 유광·무광 | 코팅(무광코팅/유광코팅) |
| 122 | PROC_000008 | 화이트 | 화이트별색(단면) |
| 124/125/133/134 | PROC_000080 | 봉제 | 가공(오버로크/말아박기/봉미싱) — `prcs_dtl_opt` 유형 enum |
| 135 | PROC_000082 | 족자제작 | 가공(사각족자/원형족자) — `prcs_dtl_opt` 모양 enum [사각/원형] |
| 136/137/139 | PROC_000079 | 타공 | 가공(4구타공/타공4/6/8) — `prcs_dtl_opt` 구수 1~8 |
| 139 | (138과 동형) PROC_000084 | 열재단 | 가공(재단만) — 라이브 PROC_000084 mint 존재 |

**핵심: 가공 옵션값은 별도 공정행이 아니라 동일 공정 1행 + `prcs_dtl_opt` enum/param 재사용**(타공 4/6/8 = PROC_000079 1행 + {구수:N}, 봉제 3종 = PROC_000080 1행 + {유형:X}). 138 silsa 실증 패턴과 동일. ⚠️ **단 `ref_param_json` 컬럼 미구현(GAP-PARAM)** → 구수/유형/모양 보존 불가 → option_item은 공정행만 가리키고 param은 GAP(아래 §4).

### 1.4 products nonspec 범위 (비규격 사이즈 = 옵션 아님)

| prd_cd | nonspec_yn | W_min~max | H_min~max |
|---|:--:|---|---|
| 118/120/121/122/124/125 | Y | 200~1200 | 200~3000 |
| 139 | Y | 500~900 | 500~3000 |
| 133/134/135/136/137/145 | N | — | — |

> 비규격 = `t_prd_products.nonspec_width/height_min/max`에 **이미 라이브 적재됨**(118~125·139). option_items로 열거 불가(연속수치) → **R-SIZE-NONSPEC constraint**로만 검증(§3). 사이즈 옵션그룹은 [규격행 택1 / 사용자입력 토글]만(규격행은 option_item, 입력은 products+constraint).

### 1.5 sets / addons / templates / option layer (현재 상태)

- **sets**: 13상품 0행. 스키마 = (prd_cd, sub_prd_cd, sub_prd_qty, ...). 천정형고리/우드행거 추가옵션을 set로 등록하려면 sub_prd_cd가 라이브 상품이어야 함.
- **addons**: 13상품 0행. 스키마 = (prd_cd, tmpl_cd, disp_seq, ...) — **tmpl_cd 참조**(addon_prd_cd 아님, 라이브 확인). 거치대 = template 경로.
- **templates**: 라이브 11행(전부 봉투류 TMPL-000005~011). 거치대 template 0행 → 신설 필요(base 상품 [CONFIRM]).
- **option layer**: 13상품 전부 **option_groups/options/items 0행** → 본 설계가 전량 신규 적재 대상.

### 1.6 surrogate MAX (라이브 실측 — 코드 채번)

| 엔티티 | 라이브 MAX | 본 적재 시작 |
|---|---|---|
| opt_grp_cd | `OPT_000004` (138 점유) | `OPT_000005` |
| opt_cd | `OPV_000016` (138 점유) | `OPV_000017` |

> 138 silsa는 **이미 라이브 COMMIT됨**(OPT_000003/004 가공/추가, OPV_000006~016, option_items 18행 — 2026-06-14 실측). 따라서 Tier A는 OPT_000005·OPV_000017부터 채번. `_` separator 통일(D3). 멱등 = 이름기반 NOT EXISTS(코드 재발급 없음).

---

## 2. 상품별 옵션 레이어 (disp_seq = L1 옵션성 컬럼 등장순서)

> L1 컬럼 순서: 사이즈 → 비규격 → 소재 → 화이트별색 → 코팅 → 가공 → 추가. **소재(1행)·비규격(constraint)은 OG 미생성** → OG disp_seq는 별색·코팅·가공·추가 순.

### 2-A. 순수 코팅형 (118/120/121/145) — OG 1개

L1 등장순: 코팅(옵션). 별색·가공·추가 없음.

**OG-COATING (코팅, SEL_TYPE.01, mand=N, disp 1)** — 코팅은 선택, 코팅없음 기본.

| prd_cd | option (disp) | dflt | item: ref_dim / ref_key1 | INSERTABLE |
|---|---|:--:|---|:--:|
| 118 | 코팅없음(1)/무광코팅(2)/유광코팅(3) | 코팅없음 Y | 없음 / .04 PROC_000015 / .04 PROC_000014 | ✅ |
| 120/121/145 | 무광코팅(1)/유광코팅(2) | 무광 Y | .04 PROC_000015 / .04 PROC_000014 | ✅ |

> 118만 "코팅없음" 센티넬 보유(item 0행). 120/121/145는 무광/유광만. 모두 PROC_000014유광·PROC_000015무광 라이브 링크 존재 → INSERTABLE. 145는 nonspec 없음(constraint 미생성).

### 2-B. 별색형 (122) — OG 1개

L1 등장순: 화이트별색(옵션). 122 = 투명PVC라 화이트 underbase.

**OG-BYEOLSAEK (화이트별색, SEL_TYPE.01, mand=N, disp 1)**

| option | dflt | item: ref_dim / ref_key1 | INSERTABLE |
|---|:--:|---|:--:|
| 단면 | N | .04 PROC_000008 (화이트) | ✅ |

> L1 "화이트별색=단면"은 도수(print_option) 아님 — 라이브에 122 print_option 0행(prn=0). 화이트는 **별색 공정 PROC_000008**으로 라이브 링크됨 → .04 환원. attribute-entity-map "별색=공정(clr_cd=NULL)" verdict 정합.

### 2-C. 패브릭 가공형 (124/125) — OG 1개

L1 등장순: 가공(옵션). 봉제 enum 재사용.

**OG-GAGONG (가공, SEL_TYPE.01, mand=N, disp 1)**

**PRD_000125 (캔버스):**
| option | dflt | item | INSERTABLE |
|---|:--:|---|:--:|
| 오버로크 | Y | .04 PROC_000080 봉제 {유형:오버로크}(param=GAP) | ✅ |

**PRD_000124 (린넨, 5종):**
| option | dflt | item(s) | INSERTABLE |
|---|:--:|---|:--:|
| 오버로크 | Y | .04 PROC_000080 {유형:오버로크} | ✅ |
| 말아박기 | N | .04 PROC_000080 {유형:말아박기} | ✅ |
| 봉미싱(7cm) | N | .04 PROC_000080 {유형:봉미싱,폭:70} | ✅ |
| 오버로크+리본끈 | N | seq1 .04 PROC_000080 + **seq2 .03 리본끈 mat** | ❌ BLOCKED (리본끈 자재 미존재·미링크) |
| 말아박기+면끈 | N | seq1 .04 PROC_000080 + **seq2 .03 면끈 mat** | ❌ BLOCKED (면끈 자재 124 미링크) |

> **BLOCKED 사유:** "+리본끈"/"+면끈"은 봉제(공정) + 끈(자재) BUNDLE. 리본끈 자재 라이브 0행(실측), 면끈 자재(MAT_000224 등 MAT_TYPE.10)는 존재하나 124에 product_material 미링크 → 트리거 .03 EXISTS 위반. **L1 선적재 필요**(끈 자재 mint/링크 = 인간 승인) → BLOCKED 격리.

### 2-D. 족자/행잉형 (133/134/135) — OG 2개 (가공·추가)

L1 등장순: 가공 → 추가.

**PRD_000135 (족자포스터):**
- **OG-GAGONG (가공, SEL_TYPE.01, mand=Y, disp 1)** — 족자제작 필수
  | option | dflt | item | INSERTABLE |
  |---|:--:|---|:--:|
  | 사각족자 | Y | .04 PROC_000082 {모양:사각} | ✅ |
  | 원형족자 | N | .04 PROC_000082 {모양:원형} | ✅ |
- **OG-CHUGA (추가, SEL_TYPE.01, mand=N, disp 2)**
  | option | dflt | item | INSERTABLE |
  |---|:--:|---|:--:|
  | 추가없음 | Y | (센티넬 item 0행) | ✅ |
  | 천정형고리 포함 | N | .03 천정고리 자재 [CONFIRM: MAT_000215 천정고리 vs PRD_000008 천정고리 set] | ❌ BLOCKED (135 미링크) |

**PRD_000133 (캔버스행잉) / PRD_000134 (린넨우드봉족자):**
- **OG-GAGONG (가공, mand=Y, disp 1)**: 133 오버로크(.04 PROC_000080) ✅ / 134 오버로크+봉미싱(.04 PROC_000080, 복합유형=GAP-PARAM) ✅
- **OG-CHUGA (추가, mand=N, disp 2)**:
  | prd | option | item | INSERTABLE |
  |---|---|---|:--:|
  | 133 | 출력만(센티넬)/우드행거+면끈 포함 | 우드행거+면끈 = .03 MAT_000229 우드행거 + 면끈 mat | ❌ BLOCKED (133 미링크) |
  | 134 | 출력만(센티넬)/우드봉+면끈 포함 | 우드봉+면끈 = .03 MAT_000225 우드봉 + 면끈 mat | ❌ BLOCKED (134 미링크) |

> 우드행거 MAT_000229·우드봉 MAT_000225·면끈(MAT_000224 등) = 라이브 자재 **존재**하나 해당 상품에 product_material 미링크 → BLOCKED. "출력만"=센티넬(item 0행, INSERTABLE). 천정고리는 자재(MAT_000215) vs set(PRD_000008) 귀속 [CONFIRM](§5).

### 2-E. 배너 거치대형 (136/137) — OG 2~3개

L1 등장순: (136만)코팅 → 가공 → 추가.

**PRD_000136 (PET배너):**
- **OG-COATING (코팅, SEL_TYPE.01, mand=N, disp 1)**: 무광코팅/유광코팅 → .04 PROC_000015/000014 ✅
- **OG-GAGONG (가공, SEL_TYPE.01, mand=Y, disp 2)**: 4구타공 → .04 PROC_000079 {구수:4} ✅
- **OG-CHUGA (추가, SEL_TYPE.01, mand=N, disp 3)**: 거치대없음(센티넬)✅ / 실내용배너거치대 / 실외용배너거치대 → **template** ❌ BLOCKED

**PRD_000137 (메쉬배너):**
- **OG-GAGONG (가공, mand=Y, disp 1)**: 4구타공 → .04 PROC_000079 {구수:4} ✅
- **OG-CHUGA (추가, mand=N, disp 2)**: 거치대없음(센티넬)✅ / 실내/실외 거치대 → template ❌ BLOCKED

> **거치대 = add-on template** (option_item 아님). 실내용/실외용배너거치대 라이브 상품 **미발견**(실측 0행) → template base_prd_cd [CONFIRM] → BLOCKED. 138 banner-walkthrough §3.4와 동일 미해결(실내 +10000/실외 +23000 가격은 L1 메쉬배너 row 105/106).

### 2-F. 메쉬현수막 (139) — OG 2개 (138 형제 패턴 · 일부 L1 LINK 의존 BLOCKED [FINDING-1])

L1 등장순: 가공 → 추가. 138 일반현수막과 동형.

- **OG-GAGONG (가공, SEL_TYPE.01, mand=Y, disp 1)**:
  | option | dflt | item | INSERTABLE |
  |---|:--:|---|:--:|
  | 타공(4개) | **Y** | .04 PROC_000079 {구수:4} | ✅ (PROC_000079 라이브 기존 링크) |
  | 타공(6개) | N | .04 PROC_000079 {구수:6} | ✅ |
  | 타공(8개) | N | .04 PROC_000079 {구수:8} | ✅ |
  | 재단만 | — | .04 PROC_000084 열재단 | ❌ **BLOCKED (PROC_000084 139 미링크·L1 LINK 의존)** |
- **OG-CHUGA (추가, SEL_TYPE.01, mand=N, disp 2)**:
  | option | dflt | item | INSERTABLE |
  |---|:--:|---|:--:|
  | 추가없음 | Y | (센티넬) | ✅ |
  | 끈추가 | — | .03 MAT_000070 끈 + .04 PROC_000081 부착 | ❌ **BLOCKED (MAT_000070+PROC_000081 139 미링크·L1 LINK 의존)** |

> **[FINDING-1 보정]** 139 재단만(PROC_000084)·끈추가(MAT_000070+PROC_000081)는 라이브 차원 **존재**하나 139에 product-link **미링크** → 이 LINK INSERT는 **L1 차원행 생성**(L2 경계 밖). 124/133/134/135 복합끈과 **동일하게 BLOCKED 격리** — `_l1_link_preload.sql`(인간 승인) 적재 후 INSERTABLE 승격. 타공(4/6/8)은 PROC_000079 **기존 링크** → INSERTABLE 유지. 재단만 BLOCKED로 dflt를 타공(4개)로 승격. (보정 전: 139 LINK를 L2 트랜잭션에 묶음 = 경계 위반 + 139만 LINK·타 상품은 BLOCKED 불일치 → 해소.)

---

## 3. Constraints — R-SIZE-NONSPEC (7상품)

비규격 입력 7상품(118/120/121/122/124/125/139). 규격 선택이면 통과, 사용자입력이면 범위 검사.

`rule_typ_cd = RULE_TYPE.01` (compatible). `rule_cd = RULE_001` (상품별 카운터·D5). `logic` jsonb NOT NULL.

**일반형 (118~125, W 200~1200 / H 200~3000):**
```json
{ "or": [
    { "!=": [ { "var": "size_mode" }, "nonspec" ] },
    { "and": [
        { ">=": [ { "var": "width" },  200  ] }, { "<=": [ { "var": "width" },  1200 ] },
        { ">=": [ { "var": "height" }, 200  ] }, { "<=": [ { "var": "height" }, 3000 ] }
    ] }
] }
```
**139 (W 500~900 / H 500~3000):** 동형, 경계만 500/900/500/3000.

> 출처: L1 비규격_가로/세로 = products.nonspec_width/height_min/max 라이브 실측. 각목↔세로 정합(138 R-GAKMOK)은 Tier A 13상품엔 각목 옵션 부재 → 미생성. compile 캐시(`t_prd_products.constraint_json`) = 활성 rule AND.

---

## 4. GAP (→ `cpq-option-gaps.md` / dbm-ddl-proposer)

| GAP | 내용 | 영향 상품 | 상태 |
|---|---|---|---|
| **GAP-PARAM** | `ref_param_json` 미구현 → 가공 param(타공 구수 4/6/8·봉제 유형·족자 모양·봉미싱 폭) 보존 불가. option_item은 공정행만 가리킴 | 124/134/135/136/137/139 전반 | 공정 1행 + param vs 공정 N행 복제 — ddl-proposer |
| **GAP-ADDON-STAND** | 실내용/실외용배너거치대 라이브 상품 미존재 → template base_prd_cd 미정 | 136/137 | 거치대 상품 선등록 vs 가격만 template |
| **GAP-BUNDLE-LINK** | +끈/+면끈/+우드행거/+천정고리 BUNDLE 자재가 해당 상품에 product_material 미링크 → 트리거 .03 위반 | 124/133/134/135/139 | L1 자재 링크 선적재(인간 승인) |
| **GAP-RIBBON** | 리본끈 자재 라이브 0행(124 오버로크+리본끈) | 124 | 자재 mint vs 면끈 통합 [CONFIRM] |

> [HARD] 발명 금지·플래그만. 본 적재는 BLOCKED 격리(차원행 재적재 안 함).

---

## 5. 설계 결정 필요 / [CONFIRM]

1. **천정형고리(135) = 자재(MAT_000215) vs 셋트(PRD_000008 천정고리)** — 둘 다 라이브 존재. attribute-entity-map §5(면지·바인더링류) 동형 모호. set(.07)면 sub_prd_cd=PRD_000008, 자재(.03)면 mat_cd=MAT_000215+135 링크. → **DESIGN DECISION**.
2. **실내/실외 배너거치대 base 상품** — 라이브 미발견. 거치대 상품(PRD_000012 우드거치대 등)과 동일물인지, 신규 상품인지 → **[CONFIRM]** (136/137 거치대 template).
3. **+면끈 자재 귀속** — MAT_000224~231(270mm+면끈 등 MAT_TYPE.10)은 복합 자재명. 행잉/족자 우드행거+면끈을 한 자재(우드행거 MAT_000229)로 볼지, 우드행거+면끈 2자재 BUNDLE로 볼지 → **[CONFIRM]**.
4. **리본끈(124)** — 라이브 0행. mint vs 면끈 통합 → **GAP-RIBBON**.
5. **134 오버로크+봉미싱 복합유형** — 봉제 PROC_000080 유형 enum은 [오버로크/말아박기/봉미싱] 단일값. "오버로크+봉미싱"은 2공정 동반 → param 표현 불가(GAP-PARAM) or 봉제 item 2행 {유형:오버로크}+{유형:봉미싱}. 후자 채택(공정 1행 재사용 2 item_seq).

---

## 6. FK 위상 적재 순서 (L1/L2 경계 분리 — FINDING-1 보정)

**[L1] 차원/LINK 선적재 — 인간 승인 선행 (apply.sql 비포함):**
- sizes/materials/processes 본 소재·공정은 대부분 라이브 존재.
- `_l1_link_preload.sql` = 139 열재단(PROC_000084)·끈(MAT_000070)·부착(PROC_000081) product-link 3행 (L1 차원행 생성). 이 패키지 적재 후 139 재단만/끈추가 BLOCKED 해소.
- BUNDLE 자재 링크(끈/우드행거/면끈 등 124/133/134/135)·거치대 상품(136/137)·리본끈 mint = 별도 인간 승인.

**[L2] 순수 옵션레이어 — `apply.sql` 단일 트랜잭션 (L1 차원행 미생성):**
1. `t_prd_product_option_groups` (OPT_000005~OPT_000024, 20) → `t_prd_product_options` (OPV_000017~OPV_000047, 31) → `t_prd_product_option_items` (.03 자재 + .04 공정, 24).
2. `t_prd_product_constraints` (R-SIZE-NONSPEC × 7) → compile → `t_prd_products.constraint_json` (compile=인간 승인 COMMIT 후).

> **[HARD·FINDING-1]** L1 차원행 생성(product-link INSERT)은 L2 옵션 트랜잭션과 분리. `apply.sql`은 L1 차원행을 생성하지 않음을 DRY-RUN으로 실증(139 product-link BEFORE 1/1 == AFTER 1/1). 적재본 = `09_load/_exec_tierA_areaform/` (silsa 구조 모방·멱등 NOT EXISTS·DRY-RUN 기본·NEVER COMMIT).
