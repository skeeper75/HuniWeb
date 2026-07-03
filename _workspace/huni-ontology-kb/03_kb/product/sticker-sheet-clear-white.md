---
id: sticker-sheet-clear-white
type: product
anchor: t_prd_products/PRD_000056
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000056 (del_yn=N·use_yn=Y 출시)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§0 3대특성·§3.1 정체·§3.2 형상=size·§3.6 커팅·§3.10 완제품가·§4 연당가 dual", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stk}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000056,PRF_STK_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y 주 카테고리·라이브 실측)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(main_cat_yn=N 부·CAT_000002 자식)"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4(210x297)·dflt Y"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)·dflt Y"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594)·dflt Y"}
  - {rel: has_size, target: size-SIZ_000515, note: "B4(257x364)·dflt N 보조"}
  - {rel: has_size, target: size-SIZ_000514, note: "B3(364x515)·dflt N 보조"}
  - {rel: uses_material, target: material-MAT_000162, note: "투명스티커(점착지 MAT_TYPE.11·USAGE.07)·★연당가 양면 defect(§4-D 재적재 워크리스트)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(앞 CMYK 4도·뒤 인쇄 안 함)·양면 미보유"}
  - {rel: has_process, target: process-PROC_000053, qualifier: {mand: "N"}, note: "완칼(Die Cut·종이+후지 자름)·자유형 칼틀·disp 1(공유 축 재사용)"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: "N"}, note: "화이트인쇄 underbase(투명 베이스 가시화·PROC_000007 별색 자식·clr_cd=NULL)·053/054/056 CORRECT(C-ST-14)·도수 아님"}
  - {rel: has_plate_size, target: plate-056-OUTPUT_PAPER_TYPE_03, note: "규격 낱장 출력용지(A4/A3/A2·OUTPUT_PAPER_TYPE.03)·종이류(점착지)라 판형 유효·fn_best_plate 자동선택"}
  - {rel: has_qty_rule, target: qty-056, note: "상품레벨 min 1·max 10000·incr 1·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "스티커 완제품가 고정가 룩업(형상×치수×수량 격자)·원자합산형 아님(§3.10)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  archetype: "완제품가 고정가 룩업(COMP_STK_PRINT·소재·규격·수량별 단가표)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "N"
  use_yn: "Y"
  del_yn: "N"
  구분: "스티커(자유형·낱장 완칼)"
  price_model_note: "스티커는 원자합산형이 아니라 완제품가(시트가격) 고정가 — 소재 연당가는 이 격자에 직접 노드로 존재하지 않음(§4)"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(투명스티커 구성·가격 축)", "조건 탐색(자유형/완칼 스티커·화이트인쇄 되는 상품)"]
tags: ["#스티커", "#투명스티커", "#완칼", "#화이트인쇄", "#완제품가고정가", "#연당가재적재"]
updated: 2026-07-03
---

# product-056 낱장 자유형 투명스티커 (PRD_000056)

낱장 자유형 투명스티커는 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 투명 점착지에 CMYK 단면
인쇄 + (투명 베이스 가시화용) **화이트인쇄 underbase**를 태우고, **완칼(die-cut)** 로 손님이 준
자유형 칼틀대로 잘라내는 스티커(카테고리 = 스티커 `CAT_000002`·자유형스티커 `CAT_000309`).
파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용). 최소 1매·최대 10,000매·1매 증분(단위
QTY_UNIT.02 "매"). `t_prd_product_sets` 부모/구성원 등록이 없어 셋트 아님(SOT 정합·기성/디자인 아님).
★**출시 상태**(use_yn=Y) — 미출시가 아니므로 현재값=권위 정합(양면 아님·상품 정체 축).

## 정체·유형 (SOT 준수)
- 상품유형 SOT: **완제품(.01)** = 일반 단일 제조상품([[product-type-classification-sot]]). round-13
  product-identity가 스티커 전량 `PRD_TYPE.04(디자인상품)`이라 한 것은 **STALE**(T-1) — 라이브 재분류로
  전량 `PRD_TYPE.01` 확정(pack §1.1). 056도 `PRD_TYPE.01`.
- 구분 = "스티커"(단일 카테고리)·인쇄방식 5분기 중 **디지털/화이트 계열**(완칼+화이트 underbase).
  정체 오분류 없음(명백한 스티커·pack §3.1). 형상=칼틀=size는 합판도무송 066 특유이고, 056(낱장 자유형)은
  A4/A3/A2 **규격 시트에 자유 칼틀**을 얹는 형태라 size는 규격(A4/A3/A2/B4/B3)으로 저장된다(형상 흡수 아님).

## 차원 (★스티커 형상·사이즈·도수·수량)
- **사이즈:** 5행 — A4(SIZ_000172)·A3(SIZ_000174)·A2(SIZ_000197)가 기본(dflt Y), B4(SIZ_000515)·
  B3(SIZ_000514)이 보조(dflt N). 이산 규격 사이즈(면적매트릭스 아님). 치수 전사는 아래 §전사표·
  하위 [[sticker-sheet-clear-white-nodes]]. 판걸이수(UP)는 사이즈의 파생([[rule/rules#RULE_pansu_db_function]]).
- **형상(칼틀):** "자유형" = 손님이 준 자유 칼틀을 **완칼(PROC_000053)** 로 자름. 완칼 공정 input에
  "모양"(string)만 있고 조각수 없음(반칼 PROC_000054와 대비). 낱장 단일 조각이라 조각수축이 얕다.
- **도수:** 인쇄옵션 코드값(단면 POPT_000001). 도수는 색상코드가 아님([[rule/rules#RULE_dosu_is_printopt]]).
  앞면 CLR_000005(CMYK 4도)·뒷면 CLR_000001(인쇄 안 함). ★**화이트는 도수가 아니라 공정**(PROC_000008
  underbase·투명 베이스 위 인쇄 가시화·`clr_cd=NULL`·pack §3.3 [HARD]). 053/054/056 화이트 CORRECT(C-ST-14).
- **수량규칙:** 제품 레벨 min 1 / max 10,000 / incr 1(QTY_UNIT.02). `t_prd_product_bundle_qtys` 0행
  (제품 레벨 규칙만·수량 UI 권위=상품/사이즈 규칙·pack §3.4). 하위 [[qty-056]].

## 자재·공정
- **자재:** 1종 링크 — **투명스티커 `MAT_000162`**(점착지 MAT_TYPE.11·USAGE.07 단일 슬롯·정당·pack §3.5).
  자재유형 정답 = MAT_TYPE.11(스티커)·라이브 재분류 완료(C-ST-09 "종이(.01)→스티커(.11)" 06-14 정정 note 계열).
  ★**연당가 양면 defect**: 260702 권위가 이 소재를 백색후지(MAT_000371)/투명후지(MAT_000372)로 split하고
  연당가/국4절/평량을 대개편했으나 라이브에 미반영 → [[sticker-sheet-clear-white-nodes#material-MAT_000162]]
  ·[[sticker-sheet-clear-white-nodes#material-MAT_000372]] 양면 노드(§4·재적재 워크리스트).
  ★IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = **2행** — PROC_000053(완칼·disp 1·mand=N) +
  PROC_000008(화이트인쇄·disp 2·mand=N·PROC_000007 별색 자식). 둘 다 옵션 공정.
  - ★**base 인쇄공정(PROC_000004) 없음:** 디지털 원자합산형과 달리 스티커는 **완제품가 고정가 룩업**
    (COMP_STK_PRINT에 출력+가공 포함 시트가격)이라 인쇄비를 원자 공정으로 분리하지 않는다. 따라서
    PROC_000004 부재는 결함이 아니라 완제품가 모델의 정상 귀결(pack §3.10·§0 특성2). 완칼·화이트는
    생산 라우팅/투명 처리 메타로 존재.
  - ★**코팅 CONFLICT(BATCH-3) 비해당:** 코팅=자재 오적재 논쟁(052·058~062·064·066)은 056에 없음
    (056 자재=투명스티커 단일·코팅 자재 미보유). 단정 금지 대상 아님(pack §3.9·T-4).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-056 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  공식·구성요소는 스티커 전용이라 [[sticker-sheet-clear-white-nodes#formula-PRF_STK_FIXED]]·
  [[sticker-sheet-clear-white-nodes#component-COMP_STK_PRINT]]에 mint(공유 formula/digital-* 미수정).
  **고아 공식 아님**(has_component 1)·**끊긴 가격 사슬 아님**(priced_by 1·O5/O6 충족).
- **완제품가 고정가 룩업:** COMP_STK_PRINT `use_dims=[siz_cd, mat_cd, min_qty]`(PRC_COMPONENT_TYPE.06·
  PRICE_TYPE.01). 가격 = **형상×치수×소재×수량 격자**에서 시트가격을 통째로 조회(원자합산 아님·구간할인
  t_dsc_* 비대상·pack §3.10). 라이브 COMP_STK_PRINT 6,498행(스티커 전 상품 공유 격자). 056 사이즈
  5종 각 42행씩 실재(A4/A3/A2/B4/B3·note "낱장(완칼) 자유형 스티커/…" 실측).
- ★**소재 연당가는 이 완제품가 격자에 없다**(pack §3.11·§4-B). t_mat_materials에 가격컬럼 없음 +
  COMP_PAPER에 스티커 mat_cd(162/371/372) **0행**(실측 확인). 즉 스티커는 원가(연당가)를 절가 노드로
  펼치지 않고 완제품가로 통째 저장. 완제품 retail 격자는 260702 무변경 → **retail 노드는 dual 아님**
  (false-defect 방지). 단 연당가 급락이 retail로 전파돼야 하는지는 열린 질문([[gap-056-retail-cost-propagation]]).

## 옵션·제약·추가상품 (라이브 실측 — 전부 0행)
- **CPQ 옵션그룹/아이템:** `t_prd_product_option_groups`·`t_prd_product_option_items` = 056 행 **없음**
  (CPQ 옵션 레이어 미적재·pack [STK-ST-006] BATCH-6). 손님 선택 축(사이즈·소재)은 상품 차원(has_*)으로만
  존재. 일괄 적재 대기 → [[gap-056-cpq-option-layer]].
- **제약규칙:** `t_prd_product_constraints` = 056 행 **없음**. 투명 베이스→화이트 requires 같은 캐스케이드
  제약은 미등록(§31 제약 하네스 소관·현재 데모 미착수·지어내지 않음).
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 056 행 **없음**(단품 스티커·셋트 아님).

## 승계·freshness 메모
- 정체·형상·인쇄방식 의미 = pack §3.1/§3.2 FRESH 승계. prd_typ은 PRD_TYPE.01로 갱신(§1.1·T-1).
- 화이트 underbase=공정(도수 아님)·053/054/056 CORRECT = pack §3.3 [HARD] 승계(C-ST-14).
- 완제품가 고정가 모델 = pack §3.10 승계. 위키 결함표(STK-ST-*) 시점 인용 금지(T-6)·연당가 무대조 인용 금지(T-8).
- 연당가 양면 = pack §4-A(price-diff 전사)·§4-D 지침 정합. 완제품 retail dual 금지(가격표 무변경).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사·손전사 금지)

> 아래 표는 `_meta/scripts/transcribe_product_056.py`가 live-snapshot에서 뽑은 값이다(D-9·[HARD]).
> 캐시=`_meta/scripts/cache/transcribed-056-260703.json`.

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000056 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp |
|---|---|---|---|---|---|
| SIZ_000172 | A4(210x297mm) | 210x297 | 210x297 | Y | 1 |
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | Y | 1 |
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | Y | 1 |
| SIZ_000515 | B4 (257X364) | ?x? | 257x364 | N | 2 |
| SIZ_000514 | B3 (364X515) | ?x? | 364x515 | N | 3 |

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000056 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage |
|---|---|---|---|---|---|---|
| MAT_000162 | 투명스티커 | MAT_TYPE.11 |  | 330x480 | 105 | USAGE.07 |

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000056 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000053 | 완칼 |  | N | 1 |
| PROC_000008 | 화이트인쇄 | PROC_000007 | N | 2 |

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000056 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005(CMYK 4도) | CLR_000001(인쇄 안 함) |

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000056 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | dflt_plt | item_siz_cd |
|---|---|---|---|
| SIZ_000050 | OUTPUT_PAPER_TYPE.03 | Y |  |
| SIZ_000052 | OUTPUT_PAPER_TYPE.03 | Y |  |
| SIZ_000198 | OUTPUT_PAPER_TYPE.03 | Y |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000056 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_STK_FIXED | COMP_STK_PRINT | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_056.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (수량·상태) PRD_000056 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|
| 1 | 10000 | 1 | QTY_UNIT.02 | PRD_TYPE.01 | Y | N | Y | N |

> 미보유 축(0행 실측): bundle_qtys·option_groups·option_items·constraints·addons·sets 전부 0행
> (`transcribe_product_056.py` + §CPQ 실측 awk). 없는 것을 지어내지 않는다.
