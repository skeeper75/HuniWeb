---
id: sticker-halfcut-clear
type: product
anchor: t_prd_products/PRD_000053
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000053 (del_yn=N·use_yn=Y·반칼 자유형 투명스티커)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(정답소스)·§3.1 정체·§3.2 형상=size·§3.6 커팅·§3.10 완제품가·§4-D 연당가 양면", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "§0 시트구조·§1 16상품 정체(반칼 자유형 투명스티커·인쇄방식 디지털 토너) (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y 주 카테고리·라이브 실측)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(main_cat_yn=N 부·CAT_000002 자식)"}
  - {rel: has_size, target: size-053-SIZ_000170, note: "A5(148x210)·상품행 활성/마스터 삭제 불일치 관찰"}
  - {rel: has_size, target: size-053-SIZ_000057, note: "A6(105x148)·판걸이=8.0"}
  - {rel: has_size, target: size-053-SIZ_000520, note: "A4(210x297) 반칼 규격 래퍼·판걸이=2.0"}
  - {rel: uses_material, target: material-MAT_000371, note: "투명스티커(백색후지)·MAT_TYPE.11·dflt·원가는 양면 matcost-053-white-backing"}
  - {rel: uses_material, target: material-MAT_000372, note: "투명스티커(투명후지)·MAT_TYPE.11·260702 신규행·원가는 양면 matcost-053-clear-backing"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(앞 CMYK4도 CLR_000005·뒤 인쇄안함 CLR_000001)·양면 미보유"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: "N"}, note: "화이트 underbase(별색 자식·선택)·투명 베이스 위 가시화·도수 아님"}
  - {rel: has_process, target: process-PROC_000122, qualifier: {mand: "N"}, note: "반칼커팅(active·upr PROC_000121·2026-06-29 재발급)·구 반칼 PROC_000054는 del_yn=Y"}
  - {rel: has_plate_size, target: plate-053-SIZ_000521, note: "46계열 전지(330x470·OUTPUT_PAPER_TYPE.02)·종이류(점착지) 판형 유효·fn_best_plate 자동선택"}
  - {rel: has_qty_rule, target: qty-053, note: "상품레벨 min 8·max 10000·incr 8·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "스티커 완제품가 고정가 룩업(형상×치수×수량 격자)·원자합산형 아님(§3.10)"}
  - {rel: has_option_group, target: optgroup-053-paper, note: "종이(자재) 택1 필수 — 백색후지/투명후지"}
  - {rel: has_option_group, target: optgroup-053-print, note: "인쇄(도수) 택1 필수 — 단면 단일"}
  - {rel: has_option_group, target: optgroup-053-white, note: "화이트별색(공정) 택1 선택 — 화이트인쇄/화이트없음"}
  - {rel: has_option_group, target: optgroup-053-cutting, note: "커팅(공정) 택1 필수 — 반칼(자유형)·★ref 재키잉 불일치"}
  - {rel: references, target: matcost-053-white-backing, note: "백색후지 소재 연당가 현재값 vs 260702 정답(재적재 워크리스트)"}
  - {rel: references, target: matcost-053-clear-backing, note: "투명후지 소재 연당가 현재값 vs 260702 정답(신규행·재적재 워크리스트)"}
  - {rel: references, target: gap-053-cutting-rekey, note: "커팅 옵션참조가 삭제된 PROC_000054 지목(fn_chk_opt_item_ref 위험)"}
  - {rel: references, target: gap-053-yeondangga-repricing, note: "연당가 급변→완제품가 전파 여부 열린 질문"}
  - {rel: references, target: gap-053-piece-count-storage, note: "반칼 조각수 상품레벨 저장처 부재(GAP-ST-2/OM-7)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 8
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  use_yn: "Y"
  archetype: "완제품가 고정가 룩업(PRF_STK_FIXED·형상×치수×수량 격자)"
  구분: "스티커(디지털 토너 인쇄·반칼 Kiss Cut·투명 점착지 완제품 단일)"
standards: {schema_org: "Product", xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반칼 자유형 투명스티커 구성·가격 축)", "투명 소재 스티커(조건 탐색)", "반칼(kiss cut) 자유형 스티커", "화이트인쇄 되는 스티커"]
tags: ["#스티커", "#투명스티커", "#반칼", "#kisscut", "#완제품가고정가", "#화이트인쇄"]
updated: 2026-07-03
---

# 반칼 자유형 투명스티커 (sticker-halfcut-clear · PRD_000053)

반칼 자유형 투명스티커(PRD_000053)는 **스티커 완제품 단일**(prd_typ_cd=`PRD_TYPE.01`·
`t_prd_product_sets`에 부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수·기성/디자인
아님). 투명 점착지(투명데드롱)에 CMYK 디지털 토너로 인쇄하고, 손님이 올린 자유 칼틀 모양대로
**반칼(Kiss Cut)** 하여 대지를 남긴 채 절개하는 스티커다. 주 카테고리는 **스티커**(CAT_000002·
main_cat_yn=Y), 부가 **자유형스티커**(CAT_000309). 가격은 스티커 공유 공식
[[formula-PRF_STK_FIXED]]가 **완제품가(시트가격) 고정가**를 (siz_cd, mat_cd,
min_qty) 격자에서 통째로 조회한다(원자합산형 아님·값 계산=`evaluate_price` 권위·[[rule/rules#RULE_price_value_boundary]]).

- **정체(round-13 승계·재검증):** `17_correctness/sticker/product-identity.md`의 16상품 정체표를
  INHERIT하되 **prd_typ_cd는 라이브 재분류로 PRD_TYPE.01**(구 서술 .04 디자인상품은 STALE·pack §1.1·T-1).
  형제 [[sticker-halfcut-hologram]](홀로그램·MAT_000163)과 같은 스티커 root·같은 PRF_STK_FIXED 공식을
  공유하되, **소재가 투명 점착지(백색후지/투명후지)** 라는 점에서 갈린다.
- **★스티커 특유 — 형상(칼틀)=size:** 스티커는 형상이 곧 사이즈로 흡수된다(pack §3.2·Q7). 053은
  A6/A5/A4 규격 사이즈(SIZ_000057/170/520)로 주문하며, "반칼(자유형)"은 커팅 옵션이 담당한다.
- **★가격 모델 = 완제품가 고정가 룩업(§3.10):** [[formula-PRF_STK_FIXED]] →
  `has_component` → [[component-COMP_STK_PRINT]](use_dims=`[siz_cd, mat_cd, min_qty]`).
  단가행(완제품 시트가격)은 노드로 펼치지 않고 구성요소 속성으로 접는다(D-22). **소재 연당가(원자재 원가)는
  이 완제품가 격자에 직접 들어가지 않는다** — 연당가는 별개 원가 축(§4·양면 노드).
- **화이트별색 = 공정(도수 아님):** 투명 베이스 위 흰색 밑판(underbase)은 화이트인쇄 공정 PROC_000008
  (별색 PROC_000007 자식·clr_cd=NULL·[[rule/rules#RULE_dosu_is_printopt]]·pack §3.3). 053은 mand=N(선택).
  063(반칼팬시투명)과 달리 053은 화이트 공정이 실재한다(pack §3.3 GAP-ST(화이트)는 063만).
- **판형(has_plate_size):** 점착지=종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택
  fn_best_plate 자동선택([[harness-domain-rules-12-260701]]). 053은 국전(OUTPUT_PAPER_TYPE.01)이 **아니라**
  46계열 전지 330×470(SIZ_000521·OUTPUT_PAPER_TYPE.02)을 쓴다. 판걸이수(UP)는 사이즈 파생·`fn_calc_pansu`
  ([[rule/rules#RULE_pansu_db_function]]·SIZ_000057 판걸이=8·SIZ_000520 판걸이=2).
- **가격 경로 연결 확인(O5/O6):** `priced_by`→PRF_STK_FIXED(✅ 실재·완제품가 고정가)→`has_component`→
  COMP_STK_PRINT(6498행 중 053 소재 MAT_000371=282행·MAT_000372=282행 실재). 끊긴 가격 사슬 아님.
- **6월말~7월초 교정 계보:** 사이즈 재키잉 파손 복구 COMMIT(052/053/058/055·pack §4-C·[[rule/decisions#DEC_wiring_round22_260702]])·
  자재 코드 재발급(MAT_000162 부모 논리삭제→MAT_000371/372 자식 mint·pack §4-B).

## 끊긴 경로·미결(정직 선언)

- **연당가 재적재 미완(★돈-크리티컬·양면):** 260702 권위 연당가/국4절이 라이브에 미반영(원가 저장처 부재).
  053 소재 2종을 양면 노드 [[matcost-053-white-backing]]·[[matcost-053-clear-backing]](current_value 라이브 vs
  authority_value 260702·badge=defect)로 — **이 둘이 재적재 워크리스트**(§4). 완제품 retail 격자(COMP_STK_PRINT)는
  260702 무변경이라 dual 아님(false-defect 방지·pack §4-D).
- **커팅 옵션참조 재키잉 불일치:** 커팅 옵션(OPV_000028 반칼)의 option_item이 **삭제된 PROC_000054**를 지목하나
  상품 활성 공정은 **PROC_000122(반칼커팅)** 다 → `fn_chk_opt_item_ref` 위험 → [[gap-053-cutting-rekey]](단정 아님·관찰).
- **반칼 조각수 저장처 부재:** 반칼(모양+조각수 input)의 조각수가 상품레벨 저장처 없음([[gap-053-piece-count-storage]]·GAP-ST-2/OM-7).
- **범위 밖 거절:** 주문·배송·회원·쿠폰 축은 KB 범위 밖(pack §0·[[rule/rules#RULE_scope_boundary]]) — 이 노드도 안 만든다.

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_sticker_halfcut_clear.py`가 live-snapshot·260702 권위 diff에서
> 결정론 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-sticker053-260703.json`.
> 사이즈/자재/공정/판형은 **전 행(del 표기 포함)** — 6월말~7월초 재키잉 이력을 침묵으로 버리지 않는다.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000053 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 8 | 10000 | 8 | QTY_UNIT.02 | Y | N | Y |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | main_cat_yn |
|---|---|---|
| CAT_000002 | 스티커 | Y |
| CAT_000309 | 자유형스티커 | N |

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000053 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 상품행 del | 마스터 del | note |
|---|---|---|---|---|---|---|
| SIZ_000196 | A6(105x148mm) | 105x148 | Y | Y | Y |  |
| SIZ_000170 | A5(148x210mm) | 148x210 | Y | N | Y |  |
| SIZ_000057 | A6 (105X148) | 105x148 | Y | N | N | 판걸이=8.0 / 전지=미지정 / 적용=반칼스티커 |
| SIZ_000520 | A4(210x297mm) 반칼 | x | N | N | N | 판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가) |
| SIZ_000426 | A5 (148x210) | 148x210 | Y | Y | N |  |
| SIZ_000258 | A4 (210x297mm) | 210x297 | N | Y | N |  |

활성(상품행 del_yn=N) 사이즈 3행 = SIZ_000170(A5)·SIZ_000057(A6)·SIZ_000520(A4 반칼). ★SIZ_000170은
상품행 활성이나 마스터(t_siz_sizes) del_yn=Y(2026-06-17 논리삭제) — 링크 활성/마스터 삭제 불일치(정직 관찰·단정 아님).
재키잉으로 SIZ_000426(A5)·SIZ_000258(A4)은 상품행 삭제됨(pack §4-C 복구 계보).

### 자재 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000053 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 부모 | 평량(g) | usage | dflt | del |
|---|---|---|---|---|---|---|---|
| MAT_000162 | 투명스티커 | MAT_TYPE.11 |  | 105 | USAGE.07 | Y | Y |
| MAT_000371 | 투명스티커(백색후지) | MAT_TYPE.11 | MAT_000162 |  | USAGE.07 | Y | N |
| MAT_000372 | 투명스티커(투명후지) | MAT_TYPE.11 | MAT_000162 |  | USAGE.07 | N | N |

활성 자재 2종 = MAT_000371(백색후지·dflt)·MAT_000372(투명후지). 부모 MAT_000162(구 "투명스티커")는 상품행
논리삭제(del_yn=Y·2026-07-01). 정답 자재유형 = **MAT_TYPE.11(스티커·점착지)**(pack §3.5). ★자식 371/372는
`weight` 공란(부모 162만 평량 105=구값) — 평량/연당가 정답은 양면 노드([[matcost-053-white-backing]]·
[[matcost-053-clear-backing]]). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | opt_id | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|---|
| POPT_000001 | 1 | 단면 | CMYK 4도 | 인쇄 안 함 |

인쇄옵션 단면 1행(POPT_000001·앞 CMYK 4도 CLR_000005·뒤 인쇄안함 CLR_000001)·양면 미보유. 도수=인쇄옵션 코드
([[rule/rules#RULE_dosu_is_printopt]]·색상코드 아님). `has_print_option`→[[axis/print-options#printopt-POPT_000001]](공유 축 재사용).

### 공정 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000053 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 | mand | del |
|---|---|---|---|---|
| PROC_000054 | 반칼 |  | N | Y |
| PROC_000008 | 화이트인쇄 | PROC_000007 | N | N |
| PROC_000122 | 반칼커팅 | PROC_000121 | N | N |

활성(del_yn=N) 공정 2행 = **PROC_000008 화이트인쇄**(별색 PROC_000007 자식·선택·재사용 [[sticker-halfcut-hologram-nodes#process-PROC_000008]])·
**PROC_000122 반칼커팅**(상위 PROC_000121·2026-06-29 재발급·[[process-PROC_000122]]). 구 반칼 **PROC_000054는 del_yn=Y**
(Kiss Cut·종이만)이나 커팅 옵션참조는 여전히 이걸 지목 → 재키잉 불일치([[gap-053-cutting-rekey]]).

### 판형 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000053 @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000007 | (공백) | AI (칼선) | Y | Y | 파일사양 |
| SIZ_000050 | (공백) | *아이마크 | Y | Y | 파일사양 |
| SIZ_000057 | OUTPUT_PAPER_TYPE.03 | PDF(W) | Y | Y | 파일사양 |
| SIZ_000521 | OUTPUT_PAPER_TYPE.02 |  | Y | N |  |

활성 판형 1행 = **SIZ_000521**(330×470·OUTPUT_PAPER_TYPE.02=46계열 전지)·dflt Y. `has_plate_size`→[[plate-053-SIZ_000521]].
SIZ_000007/050/057(파일사양 AI/아이마크/PDF)은 2026-06-30 논리삭제(판형 오적재 정리)—현재값 아님.

### 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000053 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min~max | mand | use | note |
|---|---|---|---|---|---|---|
| OPT_000009 | 종이 | SEL_TYPE.01 | 1~1 | Y | Y | 종이(자재) 택1 필수. 투명스티커 1종. |
| OPT_000010 | 인쇄 | SEL_TYPE.01 | 1~1 | Y | Y | 인쇄(도수) 택1 필수. 단면 단일(opt_id=1). |
| OPT_000011 | 화이트별색 | SEL_TYPE.01 | 0~1 | N | Y | 화이트별색(공정) 택1 선택. 화이트 PROC_000008(L1 화이트인쇄(단면))·화이트없음 센티넬. 별색=공정 정합(C-S5). |
| OPT_000012 | 커팅 | SEL_TYPE.01 | 1~1 | Y | Y | 커팅(공정) 택1 필수. 반칼 PROC_000054. |

활성 4그룹(전부 SEL_TYPE.01 단일선택·2026-06-14 생성). 아래 optgroup 노드로 각각 선언(companion). 옵션=자재+공정 BUNDLE(pack §3.9).

### 옵션값·옵션아이템(ref_dim) (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options+t_prd_product_option_items PRD_000053 @ 2026-07-03 -->
| opt_grp | opt_cd | 옵션명 | dflt | item_seq | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|---|---|
| OPT_000009 | OPV-000059 | 투명스티커 (투명후지) | N | (없음) | | | |
| OPT_000010 | OPV_000025 | 단면 | Y | 1 | OPT_REF_DIM.06 | 1 |  |
| OPT_000011 | OPV_000026 | 화이트없음 | Y | (없음) | | | |
| OPT_000011 | OPV_000027 | 화이트인쇄 | N | 1 | OPT_REF_DIM.04 | PROC_000008 |  |
| OPT_000012 | OPV_000028 | 반칼(자유형) | Y | 1 | OPT_REF_DIM.04 | PROC_000054 |  |
| OPT_000009 | OPV_000024 | 투명스티커 (백색후지) | Y | 1 | OPT_REF_DIM.03 | MAT_000371 | USAGE.07 |
| OPT_000009 | OPV_000024 | 투명스티커 (백색후지) | Y | 2 | OPT_REF_DIM.03 | MAT_000372 | USAGE.07 |

★옵션아이템 정합 관찰(단정 아님·검증 레인 몫): ① 백색후지 옵션 OPV_000024가 **두 자재(MAT_000371·MAT_000372)를
동시 참조**하고, 투명후지 옵션 OPV-000059는 **ref 행 미보유** — 소재↔옵션 매핑 어긋남. ② 커팅 OPV_000028은
**삭제된 PROC_000054**를 참조(활성 공정 PROC_000122와 불일치·[[gap-053-cutting-rekey]]). 값은 위 전사표가 권위.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints/sets PRD_000053 @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 구성원) | 0 |

수량 UI 권위 = 상품레벨 수량규칙(min 8·incr 8·QTY_UNIT.02)·bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈 규칙·
[[rule/decisions#DEC_qty_audit_260702]]). 추가상품·제약규칙·셋트 미보유(정직 표기·`has_addon`/`constrains`/`has_member` 없음).
제약(투명 베이스→화이트 requires 등)은 §31 거버넌스 범위(미등록·지어내지 않음).

### 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_STK_PRINT | Y | PRICE_TYPE.01 | 스티커 완제품가(소재·규격) | `["siz_cd", "mat_cd", "min_qty"]` |

`sticker-halfcut-clear` --priced_by--> [[formula-PRF_STK_FIXED]] --has_component-->
[[component-COMP_STK_PRINT]](공유 스티커 공식·hologram 054가 먼저 mint·중복 mint 없음). COMP_STK_PRINT
단가행(완제품가) 총 6498행 중 053 소재 커버 = MAT_000371(백색후지) 282행·MAT_000372(투명후지) 282행. use_dims=
`[siz_cd, mat_cd, min_qty]`가 053 가격이 사이즈·소재·수량으로 달라짐을 선언(코팅 축 없음·053은 코팅 미보유). 값 절대치는
KB 밖(evaluate_price·D-18). ★COMP_PAPER(용지비/연당가)에 162/371/372 = 0행(원가 미저장) → 연당가는 완제품가 격자에
없음(§4·pack §3.11).

### ★260702 권위 연당가 diff (전사·양면 authority_value 근거)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_halfcut_clear.py from huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv 출력소재(IMPORT) 투명스(백색후지)·투명투(투명후지 신규행) @ 2026-07-03 -->
| 소재키 | 컬럼 | 260527(before) | 260702(after) |
|---|---|---|---|
| 투명스 | 종이명 | 투명스티커 | 투명스티커(백색후지) |
| 투명스 | 평량 | 105 | 50 |
| 투명스 | 구매정보 | 점착 투명105g pet/ 1박스당 100매 | 점착 투명데드롱 50mic (후지:백색박리지150g) / 1박스당 300매 |
| 투명스 | 연당가 | 130000 | 149500 |
| 투명스 | 가격 (국4절) | 1300 | 499 |
| 투명투 | (ADDED row) | (신규) | C=투명스티커(투명후지)  ⁄  D=50  ⁄  E=투명투  ⁄  F=점착 투명데드롱 50mic (후지:투명 PET 100mic) / 1박스당 300매  ⁄  G=330*480  ⁄  H=222000  ⁄  I=740  ⁄  K=330x480 |

위 diff가 양면 노드([[matcost-053-white-backing]]·[[matcost-053-clear-backing]])의 authority_value 근거다. 완제품 시트가격
(COMP_STK_PRINT)은 260702 무변경(change-manifest §1)이라 retail 노드는 dual 아님 — 급락한 원가가 완제품가로 전파돼야
하는지는 열린 질문([[gap-053-yeondangga-repricing]]).

---

## 재사용한 공유 노드 (중복 mint 없음)

이 상품이 **재사용**하는 이미 존재하는 노드(내가 정의하지 않음):
- [[axis/print-options#printopt-POPT_000001]] (단면·공유 인쇄옵션 축).
- [[sticker-halfcut-hologram-nodes#category-CAT_000002]]·[[sticker-halfcut-hologram-nodes#category-CAT_000309]] (스티커 카테고리·홀로그램 054가 먼저 임시 거처로 정의).
- [[formula-PRF_STK_FIXED]]·[[component-COMP_STK_PRINT]] (스티커 완제품가 공유 공식·구성요소).
- [[sticker-halfcut-hologram-nodes#process-PROC_000008]] (화이트인쇄·별색 자식).
- `material-MAT_000372` (투명후지 identity·056 sticker-sheet-clear-white가 먼저 정의)·`process-PROC_000122` (반칼커팅·052가 먼저 정의).

이 상품 **전용 하위 노드**(사이즈 3·자재 identity 1(백색후지)·자재원가 양면 2·판형 1·수량 1·옵션그룹 4·GAP 3)는
companion [sticker-halfcut-clear-nodes.md](sticker-halfcut-clear-nodes.md)에 정의한다(공유 axis/formula 파일 미수정 원칙·051/054 선례). 공유 축 승격
후보는 build-report의 needed_shared로 반환.
