---
id: product-040-white-print-namecard
type: product
anchor: t_prd_products/PRD_000040
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000040 (del_yn=N·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(명함=인쇄홍보물)·§3.3 도수·별색=공정·§3.7 인쇄옵션(화이트인쇄 SPOT 발현)·§3.11 명함 배선교정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "MEMORY/whiteprint-material-4color-unified-spot-component-260630.md", source_locator: "§1 화이트인쇄 자재=색지4색(화이트 제외·020=040 동형)·§2 통합별색·이중과금가드", captured_at: "2026-07-03", badge: candidate, src_id: SR-mem-whiteprint}
  - {source_file: "MEMORY/goods-material-contamination-260630.md", source_locator: "굿즈 자재 오염(젤리볼펜/지비츠/거치대 등)이 용지성 상품에 오적재→정리 COMMIT", captured_at: "2026-07-03", badge: candidate, src_id: SR-mem-goodscontam}
relations:
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(main_cat_yn=Y·라이브 실측)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(2차·main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000008, note: "90x50(공유 명함 사이즈·033/032 정의 재사용·단일 사이즈)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(칼라)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(칼라)"}
  - {rel: uses_material, target: material-MAT_000362, note: "큐리어스스킨 레드 270g(색지·USAGE.07·020 정의 재사용)"}
  - {rel: uses_material, target: material-MAT_000363, note: "큐리어스스킨 다크블루 270g(020 정의 재사용)"}
  - {rel: uses_material, target: material-MAT_000364, note: "큐리어스스킨 바이올렛 270g(020 정의 재사용)"}
  - {rel: uses_material, target: material-MAT_000365, note: "큐리어스스킨 블랙 270g(020 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: Y}, note: "화이트인쇄(별색·mand_proc_yn=Y·인쇄비 원천·020 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000009, qualifier: {mand: N}, note: "클리어인쇄(별색·옵션·020 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각(모서리·공유 축)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근(모서리·공유 축)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택)"}
  - {rel: has_qty_rule, target: qty-040}
  - {rel: priced_by, target: formula-PRF_NAMECARD_WHITE}
  - {rel: has_option_group, target: optgroup-040-clear}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 100
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  archetype_price: "고정가(용지포함·flat 1행 매칭·단/양면×클리어별색×수량)"
  구분: "명함(디지털인쇄 완제품 단일·화이트인쇄 별색)"
standards: {schema_org: "Product", xjdf: "Product(명함·SpotColorIntent)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(화이트인쇄명함 구성·가격 축)", "조건 탐색(색지에 흰색 인쇄 되는 명함)"]
tags: ["#디지털인쇄", "#명함", "#화이트인쇄", "#별색", "#고정가"]
updated: 2026-07-03
---

# 화이트인쇄명함 (product-040-white-print-namecard)

화이트인쇄명함(PRD_000040)은 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000313]]
명함 / 상위 [[axis/categories#category-CAT_000003]] 인쇄홍보물). 상품유형 분류 SOT 정합 = 셋트 부모 아님
(`t_prd_product_sets` 미등록)·기성/디자인 아님(제조 상품). **어두운/유색 색지(큐리어스스킨 4색) 위에 불투명 흰
토너(화이트인쇄)를 올리는 별색 인쇄 명함**이다 — 흰 종이에 흰 토너는 대비 0이라 무의미하므로 자재가 유색 색지로
한정된다([[rule/rules#RULE_dosu_is_printopt]] 별색=공정 정합·MEMORY 화이트인쇄 색지4색). 파일 업로드형
(file_upload_yn=Y·editor_yn=N). 사이즈 **1종**(90×50)·칼라 단/양면·클리어별색 유/무·직각/둥근 모서리.

**하이브리드 정체**: 040은 **020 화이트인쇄엽서의 명함 버전**(색지 4종·별색 공정 008/009 공유) + **032/033
명함 고정가 골격**(단일 명함 사이즈·모서리 공정 027/028·flat 완제품가 공식)의 교차다. 가격 아키타입 =
**고정가(용지포함) flat 1행 매칭형** [[formula/digital-formulas#formula-PRF_NAMECARD_WHITE]](PRF_NAMECARD_WHITE)
로 계산한다 — 원자합산형(020의 PRF_DGP_A)이 아니다. 값 차원(use_dims)은 `[print_opt_cd, opt_cd, min_qty]`
즉 **단/양면 × 클리어별색 유무 × 수량**으로 가격이 갈리며 소재(색지)는 용지포함(가격 차원 아님). 값 계산은
evaluate_price 단일 권위([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 연결까지만(D-18). 골든
스냅샷 = live 20260702_1119 기준(값 미기록).

**배선·재바인딩 이력**: 040은 원래 PRF_DGP_A(원자합산) 바인딩이었으나 화이트인쇄 명함가(용지포함) 단가행 매칭이
안 맞아 **견적 0**이었고, 2026-06-30 flat 명함 공식 PRF_NAMECARD_WHITE로 재바인딩 COMMIT(라이브 note
"PRF_DGP_A 원자→flat. 견적0 교정")으로 해소([[#DEC_namecard040_flat_260630]]·[[rule/rules#RULE_dataline_neq_wiring]]).
같은 날 굿즈 자재 오염(젤리볼펜·지비츠부속·만년다이어리내지·미니배너거치대 MAT_000138~141)과 화이트 색지
(MAT_000361·대비 0 무효)를 `del_yn=Y` 정리해 활성 BOM=유색 색지 4종만 남았다(MEMORY 굿즈 오염·화이트인쇄 색지4색).

- **정체**: live-snapshot(prd_cd·prd_nm 실재) + 팩 §3.1(명함=인쇄홍보물)/§3.3(화이트인쇄=별색·SPOT 발현).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **화이트인쇄 = 별색 공정**: 인쇄비는 CMYK base(PROC_000004 — 040 미바인딩)가 아니라 **별색 화이트/클리어**
  (PROC_000008/009)에서 나온다. flat 명함가 4구성요소가 이 별색 인쇄를 용지포함 완제품가로 흡수(§가격공식 사슬).
- **끊긴 경로(정직 선언)**: 클리어별색 옵션이 라이브 `t_prd_product_option_items`에 ref_dim 행이 없어 CPQ
  ref 레이어가 형식화 안 됨 → [[product-040-white-print-namecard-nodes#gap-040-clear-optitem-ref]]. 색지 4종
  선택이 옵션그룹(종이)으로 노출되지 않음(가격 무영향·flat 용지포함) → [[product-040-white-print-namecard-nodes#gap-040-paper-optgroup]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_040.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님·D-9).
> 단가값(unit_price)은 전사하지 않는다(D-18 가격 경계·값=evaluate_price 권위) — 차원키(print_opt/opt)만.

#### 정체

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000040 @ 2026-07-03 -->
| 컬럼 | 값 |
|---|---|
| prd_cd | PRD_000040 |
| prd_nm | 화이트인쇄명함 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 100 |
| max_qty | 10000 |
| qty_incr | 100 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | Y |
| del_yn | N |

수량 min/incr = 100(명함 표준·032/033과 동일·엽서 020의 12와 다름). 파일 업로드형(editor_yn=N).

#### 카테고리

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000040 @ 2026-07-03 -->
| cat_cd | 분류명 | main_cat_yn |
|---|---|---|
| CAT_000313 | 명함 | N |
| CAT_000003 | 인쇄홍보물 | Y |

인쇄홍보물(CAT_000003·main) + 명함(CAT_000313·2차) 2분류 = 032 코팅명함과 동일 분류 구조([[axis/categories]] 공유 축 재사용).

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000040 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000008 | 90x50mm | Y |  |  |  |

**단일 사이즈** SIZ_000008(90×50) = 공유 [[axis/sizes#size-SIZ_000008]] 재사용(033/032가 이미 민팅·중복 생성 없음).
032(90×50+86×52 2종)와 달리 040은 90×50 1종만. 치수(작업 92×52/재단 90×50)는 축 전사표 권위.

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000040 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 100 | 10000 | 100 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품 마스터 스칼라(min 100·max 10000·incr 100·단위 QTY_UNIT.02 "매"·[[rule/decisions#DEC_qty_audit_260702]]).
`t_prd_product_bundle_qtys` 0행은 정상(묶음수 미적재≠결함·팩 §3.4). 수량규칙 노드=[[product-040-white-print-namecard-nodes#qty-040]].

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000040 @ 2026-07-03 -->
활성 자재 4행 · 화이트인쇄=유색 색지(흰 색지·화이트 용지 제외·도메인 필터). del_yn=Y 5행(굿즈 자재 오염 + 화이트 대비0 정리·2026-06-30).

| mat_cd | 자재명 | mat_typ | usage_cd | 상태 |
|---|---|---|---|---|
| MAT_000362 | 큐리어스스킨 레드 270g | MAT_TYPE.01 | USAGE.07 | 활성 |
| MAT_000363 | 큐리어스스킨 다크블루 270g | MAT_TYPE.01 | USAGE.07 | 활성 |
| MAT_000364 | 큐리어스스킨 바이올렛 270g | MAT_TYPE.01 | USAGE.07 | 활성 |
| MAT_000365 | 큐리어스스킨 블랙 270g | MAT_TYPE.01 | USAGE.07 | 활성 |
| MAT_000138 | 젤리볼펜(가칭) | MAT_TYPE.03 | USAGE.07 | del_yn=Y(정리) |
| MAT_000139 | 지비츠부속 | MAT_TYPE.03 | USAGE.07 | del_yn=Y(정리) |
| MAT_000140 | 만년다이어리내지 | MAT_TYPE.21 | USAGE.07 | del_yn=Y(정리) |
| MAT_000141 | 미니배너 거치대 | MAT_TYPE.16 | USAGE.07 | del_yn=Y(정리) |
| MAT_000361 | 큐리어스스킨 화이트 270g | MAT_TYPE.01 | USAGE.07 | del_yn=Y(정리) |

활성 4행 = 020 화이트인쇄엽서와 **동일 색지 4종**(큐리어스스킨 레드/다크블루/바이올렛/블랙·전부 USAGE.07). 이 4 자재는
공유 [[axis/materials]] 미등재이나 [[product-020-white-print-postcard-nodes]]가 이미 product-local 민팅했으므로
**재사용(중복 생성 금지)**하고 `uses_material` 엣지가 그리로 resolve. 근본 해법=공유 축 승격(needed_shared_nodes 반환).
del_yn=Y 5행: 굿즈 자재 오염(젤리볼펜·지비츠·만년다이어리내지·미니배너거치대·MEMORY 굿즈 오염) + 화이트 색지
(MAT_000361·흰 위 흰=대비 0 무효·020 동형). 정리는 이미 COMMIT됨(현재 상태=활성 4종만) — 양면 결함 아님.

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000040 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 존재 | 정의 위치 |
|---|---|---|---|---|
| PROC_000008 | 화이트인쇄 | Y | O | 020-nodes |
| PROC_000027 | 직각 | N | O | axis |
| PROC_000028 | 둥근 | N | O | axis |
| PROC_000009 | 클리어인쇄 | N | O | 020-nodes |

공정 4행 = 별색 인쇄 2(화이트 mand·클리어 opt·도수 아님·[[_glossary#TERM_spot_color]]) + 모서리 2(직각/둥근 opt·
[[_glossary#TERM_corner_round]]). 별색 008/009는 [[product-020-white-print-postcard-nodes]] 정의 재사용, 모서리
027/028은 공유 [[axis/processes#process-PROC_000027]]/[[axis/processes#process-PROC_000028]] 재사용(032 승격분).
★016/032의 CMYK base 인쇄(PROC_000004)는 **없음** — 화이트인쇄는 흰/투명 토너 별색이라 CMYK 층 없음(가격은 별색을
흡수한 flat 명함가에서·§가격공식 사슬).

#### 인쇄옵션(도수·인쇄 방식)

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options PRD_000040 @ 2026-07-03 -->
| print_opt_cd | 인쇄옵션명 | print_side | front_clr | back_clr |
|---|---|---|---|---|
| POPT_000001 | 단면 | 단면 | CLR_000002 | CLR_000001 |
| POPT_000002 | 양면 | 양면 | CLR_000002 | CLR_000002 |

단/양면 = 공유 [[axis/print-options#printopt-POPT_000001]]/[[axis/print-options#printopt-POPT_000002]] 재사용
(`has_print_option`). 도수=print_opt_cd([[rule/rules#RULE_dosu_is_printopt]]). 별색(화이트/클리어)은 여기 도수가
아니라 위 공정으로 들어온다(팩 §3.3). print_opt_cd는 flat 명함가의 핵심 판별 차원(단면 S1W / 양면 S2W).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000040 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | Y |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선(dflt_plt=Y). 판형=종이류만·
고객 미선택·fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]).

#### 추가상품(템플릿)

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates PRD_000040 @ 2026-07-03 -->
| disp | tmpl_cd | 템플릿명 | base_prd_cd |
|---|---|---|---|
| (행 없음) | | | |

추가상품 **0행** = 명함은 봉투 addon 없음(엽서 016/020과 다름·정상·GAP 아님). `has_addon` 엣지 없음(정직 표기).

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000040 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | mand | min/max | use | del |
|---|---|---|---|---|---|---|
| OPT_000081 | 클리어(별색) | SEL_TYPE.01 | Y | 1/1 | Y | N |

활성 **1그룹**(클리어별색 택1 필수·없음/있음). 020(화이트/종이/클리어 3그룹)·032(인쇄/종이/코팅/모서리 4그룹)과 달리
040은 클리어별색 1그룹만 노출. 화이트인쇄는 mand 공정(항상 적용·옵션 아님)·색지 선택은 옵션그룹 부재(§GAP)·모서리는
공정만 있고 옵션그룹 미구성. 이 그룹은 [[product-040-white-print-namecard-nodes#optgroup-040-clear]] 노드로 선언.

#### 옵션(OPV)

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options PRD_000040 @ 2026-07-03 -->
| opt_cd | opt_grp_cd | 옵션명 | dflt |
|---|---|---|---|
| OPV_000489 | OPT_000081 | 클리어 없음 | Y |
| OPV_000490 | OPT_000081 | 클리어 있음 | N |

클리어별색 2 옵션(OPV_000489 없음=dflt/OPV_000490 있음). 이 opt_cd 값이 flat 명함가 4구성요소의 판별 차원
(`opt_cd`·use_dims): 없음→*_NOCL, 있음→*_CL 구성요소로 가격 갈림(§가격공식 사슬).

#### 옵션아이템(ref_dim)

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items PRD_000040 @ 2026-07-03 -->
| opt_cd | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|
| (행 없음 — CPQ ref_dim 레이어 부재·GAP) | | | |

`t_prd_product_option_items` **0행** — 클리어별색 옵션이 물리 차원(process PROC_000009)을 ref_dim으로 가리키지
않는다(020 클리어 그룹은 OPT_REF_DIM.04→PROC_000009 행 보유와 대조). 옵션은 가격 판별 차원(opt_cd)으로만 작동 →
[[product-040-white-print-namecard-nodes#gap-040-clear-optitem-ref]].

#### 제약

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000040 @ 2026-07-03 -->
| rule_cd | 규칙명 | rule_typ | use |
|---|---|---|---|
| (행 없음) | | | |

라이브 제약규칙 **0행**(§31 제약 거버넌스 미착수 상품). 제약 노드 없음 — 정직 표기.

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000040 @ 2026-07-03 -->
| frm_cd | apply_bgn_ymd |
|---|---|
| PRF_NAMECARD_WHITE | 2026-06-01 |

`priced_by` → [[formula/digital-formulas#formula-PRF_NAMECARD_WHITE]] (flat 고정가·4구성요소·040 신규 mint).

#### 가격공식 구성요소 배선

<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components+t_prc_price_components (frm_cd:PRF_NAMECARD_WHITE) PRD_000040 @ 2026-07-03 -->
| disp | comp_cd | prc_typ | use_dims | 차원키(print_opt·opt) |
|---|---|---|---|---|
| 1 | COMP_NAMECARD_WHITE_S1W_NOCL | PRICE_TYPE.02 | ["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"] | POPT_000001/OPV_000489 |
| 2 | COMP_NAMECARD_WHITE_S1W_CL | PRICE_TYPE.02 | ["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"] | POPT_000001/OPV_000490 |
| 3 | COMP_NAMECARD_WHITE_S2W_NOCL | PRICE_TYPE.02 | ["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"] | POPT_000002/OPV_000489 |
| 4 | COMP_NAMECARD_WHITE_S2W_CL | PRICE_TYPE.02 | ["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"] | POPT_000002/OPV_000490 |

4구성요소 전부 addtn_yn=Y·PRICE_TYPE.02(완제품가)·용지포함. 판별 = 단/양면(print_opt_cd) × 클리어별색 유무
(opt_cd OPV_000489/490) × 수량(min_qty). 구성요소 정의=[[product-040-white-print-namecard-nodes]].

## 가격공식 사슬 (연결만·값=evaluate_price)

040 → **PRF_NAMECARD_WHITE**(priced_by·flat 고정가) → `has_component`로 배선된 4구성요소:

> 아래는 수치(가격) 전사표가 아니라 손집필 연결 맵(구성요소↔차원키↔선택 조합)이다. 값은 evaluate_price(D-18).
> L-16(transcribed-by) 비대상(연결 서술).

| 구성요소 | 선택 조합 | 판별 차원(use_dims) |
|---|---|---|
| [[product-040-white-print-namecard-nodes#component-COMP_NAMECARD_WHITE_S1W_NOCL]] 단면·클리어없음 | 단면(POPT_000001) + 클리어없음(OPV_000489) | print_opt_cd·opt_cd·min_qty |
| [[product-040-white-print-namecard-nodes#component-COMP_NAMECARD_WHITE_S1W_CL]] 단면·클리어있음 | 단면(POPT_000001) + 클리어있음(OPV_000490) | print_opt_cd·opt_cd·min_qty |
| [[product-040-white-print-namecard-nodes#component-COMP_NAMECARD_WHITE_S2W_NOCL]] 양면·클리어없음 | 양면(POPT_000002) + 클리어없음(OPV_000489) | print_opt_cd·opt_cd·min_qty |
| [[product-040-white-print-namecard-nodes#component-COMP_NAMECARD_WHITE_S2W_CL]] 양면·클리어있음 | 양면(POPT_000002) + 클리어있음(OPV_000490) | print_opt_cd·opt_cd·min_qty |

**가격 경로 연결됨**: 040 → PRF_NAMECARD_WHITE → 4구성요소(flat 완제품가·용지포함·live formula_components 실측 4행 배선).
손님의 (단/양면 × 클리어별색) 조합이 정확히 1구성요소를 지목하고, 각 구성요소의 단가표가 수량(min_qty)별 완제품가를
연다. 소재(색지 4종)는 가격 차원 아님(용지포함·flat) — 어느 색지를 골라도 같은 값. 별색 화이트/클리어 인쇄비는 이
완제품가에 이미 흡수(별도 별색 component 배선 금지·이중과금·[[rule/rules#RULE_dataline_neq_wiring]] 계보).
골든값은 미기록(값=evaluate_price 권위·D-18) — 검증 레인(okb-adversarial-verifier)이 골든 재계산.

## 결정 (교정 이력)

### [DEC_namecard040_flat_260630] 040 견적0 → PRF_NAMECARD_WHITE flat 재바인딩 COMMIT {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거=라이브 바인딩 note + 배선 원장)
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000040,PRF_NAMECARD_WHITE) note:'040 화이트인쇄명함 flat 재바인딩(PRF_DGP_A 원자→flat). 견적0 교정.'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "MEMORY/whiteprint-material-4color-unified-spot-component-260630.md", source_locator: "화이트인쇄 자재4색·통합별색·이중과금가드", captured_at: "2026-07-03", badge: candidate, src_id: SR-mem-whiteprint}
- rel: {rel: decided_because, target: formula-PRF_NAMECARD_WHITE, note: "원자합산 PRF_DGP_A(용지포함 단가행 미매칭→견적0)를 flat 명함가 공식으로 대체(search-before-mint: 무손실 불가 입증)"}
- props: {일자: "2026-06-30", 내용: "040이 PRF_DGP_A(원자합산) 바인딩이었으나 화이트인쇄 명함 완제품가(용지포함) 단가행 매칭 실패로 견적 0. flat 1행 매칭형 PRF_NAMECARD_WHITE(4구성요소=단/양면×클리어) 신설·재바인딩으로 해소. 동시 굿즈 자재 오염·화이트 색지 del_yn=Y 정리."}

## 이 상품 전용 하위 노드

product-local 민팅 노드(공식 PRF_NAMECARD_WHITE·구성요소 4·수량 1·옵션그룹 1·GAP 2)는 companion 파일
[[product-040-white-print-namecard-nodes]]에 정의(자기 네임스페이스·공유 축 미수정). 색지 4·별색 공정 008/009는
[[product-020-white-print-postcard-nodes]] 정의 재사용(중복 생성 금지·공유 축 승격은 needed_shared_nodes 반환).

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): t_prd_products(PRD_000040)·t_prd_product_categories(2행)·t_prd_product_sizes(1행 SIZ_000008)·t_prd_product_materials(활성 4행 USAGE.07·del 5행)·t_prd_product_processes(4행 008 mand/009/027/028)·t_prd_product_print_options(2행 POPT_000001/002)·t_prd_product_plate_sizes(1행 SIZ_000499 OUTPUT_PAPER_TYPE.01)·t_prd_product_option_groups(1행 OPT_000081)·t_prd_product_options(2행 OPV_000489/490)·t_prd_product_option_items(0행)·t_prd_product_price_formulas(PRF_NAMECARD_WHITE)·t_prc_formula_components(4행)·t_prd_product_bundle_qtys(0행)·t_prd_product_addons(0행)·t_prd_product_constraints(0행)·t_prd_product_sets(부모 아님).
- `_workspace/huni-ontology-kb/01_curation/pack-digital-print.md` (§3.1 정체·§3.3 도수=printopt·별색=공정·§3.7 인쇄옵션·§3.11 명함 배선교정·§3.4 수량규칙).
- MEMORY: whiteprint-material-4color-unified-spot-component-260630(020=040 동형·이중과금가드)·goods-material-contamination-260630(자재 오염 정리)·namecard-orphan-component-wiring-260630(단가행≠배선).
- 수치 전사: `_meta/scripts/transcribe_product_040.py`(정체·차원·BOM·옵션·배선·단가값 제외).
