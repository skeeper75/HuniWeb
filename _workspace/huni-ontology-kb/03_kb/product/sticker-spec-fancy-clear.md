---
id: sticker-spec-fancy-clear
type: product
anchor: t_prd_products/PRD_000063
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000063 (반칼팬시투명스티커·prd_typ_cd=PRD_TYPE.01·use_yn=N 미출시·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§0~5 스티커 파일럿(정체·형상=size·완제품가·§3.3 GAP-ST(화이트) 063·§3.9 CPQ BATCH-6·§4 연당가)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "§0 시트구조·§1 16상품 정체(063 반칼팬시투명·자재 투명스티커·인쇄방식 디지털) (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000063,PRF_STK_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·disp 13)·공유 축 재사용"}
  - {rel: in_category, target: category-CAT_000037, note: "규격스티커(부·main_cat_yn=N·상위 CAT_000002)·058 circle이 정의한 축 재사용"}
  - {rel: has_size, target: size-SIZ_000059, note: "124x186(작업 128x190)·판걸이4·규격 팬시 사이즈·dflt"}
  - {rel: has_size, target: size-SIZ_000060, note: "90x190(작업 94x194)·판걸이6·규격 팬시 사이즈·dflt"}
  - {rel: has_plate_size, target: plate-063-SIZ_000521, note: "330x470·OUTPUT_PAPER_TYPE.02(46계열)·종이류=점착지 판형 유효·fn_best_plate 자동선택"}
  - {rel: uses_material, target: material-MAT_000162, note: "투명스티커(구코드 parent·MAT_TYPE.11·USAGE.07·dflt)·★056 companion의 dual(defect) 노드 재사용=063 연당가 워크리스트"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(앞 CMYK 4도 CLR_000005·뒤 인쇄안함 CLR_000001)·양면 미보유·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000055, qualifier: {mand: "N"}, note: "스티커완칼(Die Cut+조각수)·★상품명 '반칼'과 명칭 관찰 불일치([[sticker-spec-fancy-clear#gap-063-halfcut-process]])·060 rectangle이 정의한 공정 재사용"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: "N"}, note: "화이트인쇄(별색 PROC_000007 자식·투명 베이스 위 가시화)·2026-06-13 추가 실재→pack GAP-ST(화이트) MISSING은 REVERIFY로 해소·홀로 054가 정의한 공정 재사용"}
  - {rel: has_qty_rule, target: qty-063, note: "상품레벨 min 8·max 10000·incr 8·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "스티커 완제품가 고정가 룩업(형상×치수×수량 격자)·원자합산형 아님(§3.10)·공유 공식 재사용"}
  - {rel: references, target: material-MAT_000162, note: "★연당가 양면(defect) 재적재 워크리스트(투명스 백색후지 국4절 1300→499·연당가 130000→149500)·056 companion 재사용"}
  - {rel: references, target: gap-063-halfcut-process, note: "상품명 반칼 vs 등록 공정 PROC_000055 완칼 명칭 불일치(GAP-ST-3 Q-ST-C)"}
  - {rel: references, target: gap-063-cpq-option-layer, note: "CPQ 옵션 레이어 전면 미적재(option_groups 0행·BATCH-6·use_yn=N 미출시와 정합)"}
  - {rel: references, target: gap-063-material-unmigrated, note: "063은 구코드 MAT_000162 직결(053은 371/372로 마이그레이션)·미마이그레이션 관찰"}
  - {rel: references, target: gap-056-material-cost-storage, note: "스티커 소재 연당가 저장처 부재 systemic GAP(056 companion 재사용)"}
  - {rel: references, target: gap-056-retail-cost-propagation, note: "연당가 급변→완제품가 전파 여부 열린 질문(056 companion 재사용)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  semi_role_cd: null
  min_qty: 8
  max_qty: 10000
  qty_incr: 8
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "Y"
  use_yn: "N"
  del_yn: "N"
  archetype: "완제품가 고정가 룩업(PRF_STK_FIXED·형상×치수×수량 격자)"
  구분: "스티커(디지털 토너 인쇄·규격 팬시 투명 점착지·완제품 단일·미출시 use_yn=N)"
  status_note: "★use_yn=N(미출시)·구코드 MAT_000162 미마이그레이션·CPQ 옵션 레이어 0행·화이트 PROC_000008는 재키잉으로 실재(pack GAP 해소). 수량/치수/격자 raw는 companion 전사표 권위"
standards: {schema_org: "Product", xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반칼팬시투명스티커 구성·가격 축)", "투명 소재 규격 스티커(조건 탐색)", "규격(팬시) 투명 스티커", "미출시(use_yn=N) 스티커 준비 상태"]
tags: ["#스티커", "#투명스티커", "#규격팬시", "#완제품가고정가", "#미출시", "#미마이그레이션", "#연당가재적재"]
updated: 2026-07-03
---

# 반칼팬시투명스티커 (sticker-spec-fancy-clear · PRD_000063)

반칼팬시투명스티커(PRD_000063)는 **스티커 완제품 단일**(prd_typ_cd=`PRD_TYPE.01`·
`t_prd_product_sets`에 부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수·기성/디자인
아님). 투명 점착지에 CMYK 디지털 토너로 인쇄하고 **규격 팬시 치수**(124×186·90×190 등)로 재단하는
스티커다. 주 카테고리는 **스티커**(CAT_000002·main_cat_yn=Y), 부가 **규격스티커**(CAT_000037·058~062
family). 가격은 스티커 공유 공식 [[formula-PRF_STK_FIXED]]가 **완제품가(시트가격) 고정가**를
(siz_cd, mat_cd, min_qty) 격자에서 통째로 조회한다(원자합산형 아님·값 계산=`evaluate_price` 권위·
[[rule/rules#RULE_price_value_boundary]]).

**★063의 정체 = "미출시·미마이그레이션" 스티커.** 형제 [[sticker-spec-circle]](058)·
[[sticker-spec-rectangle]](060)와 같은 규격스티커 family·같은 PRF_STK_FIXED 공식을 공유하되,
063은 **`use_yn=N`(미출시)** 이라 6월말~7월초 재키잉이 아직 도달하지 않은 상태다: ① 자재가 **구코드
MAT_000162(un-split parent)** 에 묶여 있고(053은 371/372로 마이그레이션·[[gap-063-material-unmigrated]])
② **CPQ 옵션 레이어가 0행**(option_groups/items 전면 미적재·BATCH-6·[[gap-063-cpq-option-layer]])
③ 커팅 공정이 **PROC_000055 스티커완칼(Die Cut)** 인데 상품명은 '반칼'(Kiss Cut)이라 명칭이 어긋난다
([[gap-063-halfcut-process]]). editor_yn=Y·file_upload_yn=Y.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 063은 `t_prd_product_sets` 부모 등록 없음
  → 일반 단일 완제품. ★pack §1.1·T-1: round-13 "전량 디자인상품(.04)" 서술은 **STALE** — 라이브
  재분류로 **PRD_TYPE.01(완제품)** 이 현재값(SOT 정합·교정 완료·전사표 실측).
- 카테고리 = 스티커(`CAT_000002` main·disp 13) + 규격스티커(`CAT_000037` 부·상위 CAT_000002).
  규격원형/정사각/직사각/띠지/팬시(058~062) family(pack §3.2 GAP-ST-3).

## 차원
- **사이즈 (형상=치수):** t_prd_product_sizes active = **124×186(SIZ_000059·판걸이4·dflt)** +
  **90×190(SIZ_000060·판걸이6·dflt)** 규격 팬시 사이즈 2행. 삭제=100×140(SIZ_000058·2026-06-27 상품행
  논리삭제). 규격 팬시 스티커는 형상(칼틀)이 고정 치수로 흡수돼 **형상=size**(pack §3.2). 판걸이수(UP)는
  사이즈 파생 `fn_calc_pansu`([[rule/rules#RULE_pansu_db_function]]·note 판걸이=4/6). 치수 전사=[[sticker-spec-fancy-clear-nodes]].
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001·공유 축 재사용). 도수는 색상코드가 아니다
  ([[rule/rules#RULE_dosu_is_printopt]]). 앞면 CLR_000005(CMYK 4도)·뒷면 CLR_000001(인쇄 안 함)·양면 미보유.
- **수량규칙:** 상품 레벨 min 8·incr 8(QTY_UNIT.02). `t_prd_product_bundle_qtys` 063 행 **없음**(상품
  레벨 규칙만). 수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·pack §3.4). 하위 [[sticker-spec-fancy-clear#qty-063]].

## 자재·공정
- **자재:** active = **투명스티커 `MAT_000162`**(MAT_TYPE.11·USAGE.07·dflt·평량 105) 1종. 정답 자재유형
  MAT_TYPE.11(스티커·점착지·pack §3.5 C-ST-09). ★**063은 구코드 MAT_000162(un-split parent)** 에 직결 —
  053은 06-27 재키잉으로 MAT_000371(백색후지)/MAT_000372(투명후지) 자식으로 마이그레이션했으나 063은
  **미마이그레이션**([[gap-063-material-unmigrated]]). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
  - ★**연당가 양면(defect·돈-크리티컬):** MAT_000162의 연당가/국4절가는 260702 권위와 라이브가 어긋난다
    (라이브 명 "투명스티커"·평량 105·연당가 미저장 vs 260702 "투명스티커(백색후지)"·평량 50·연당가 149,500·
    국4절 499). 이 defect는 **이미 [[material-MAT_000162]](056 companion)** 에 양면 노드로 존재 —
    063은 그 노드를 **재사용**(중복 mint 금지·search-before-mint). 이 양면 노드가 곧 063의 **연당가 재적재
    워크리스트**(pack §4-D). 완제품 retail 격자(COMP_STK_PRINT)는 260702 무변경이라 dual 아님(false-defect 방지).
- **공정:** active 2행 — **PROC_000055 스티커완칼**(Die Cut+조각수·mand_proc_yn=N)·**PROC_000008 화이트인쇄**
  (별색 PROC_000007 자식·mand=N·2026-06-13 추가). ★**base 인쇄 공정(PROC_000004) 없음** — 스티커는 완제품가
  룩업(COMP_STK_PRINT에 출력+가공 내장)이라 원자합산 base 인쇄 바인딩 불필요(결함 아님·pack §3.10).
  - ★**커팅 명칭 관찰:** 상품명 '반칼'(Kiss Cut) vs 등록 공정 PROC_000055 '스티커완칼'(Die Cut) 불일치 →
    단정 금지·[[gap-063-halfcut-process]](060 rectangle의 gap-060-halfcut-process와 동류·pack §3.6·GAP-ST-3).
  - ★**화이트 REVERIFY 해소:** pack §3.3 GAP-ST(화이트)는 "063 화이트 underbase PROC_000008 MISSING"이라
    했으나(053/054/056만), **live 재측정(pack이 지시한 확인 방법)에서 063도 PROC_000008 실재**(2026-06-13
    추가·del_yn=N). → GAP-ST(화이트)는 **해소**(REVERIFY 후 갱신·양면/gap 노드 불요·정직 관찰).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `sticker-spec-fancy-clear --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  공식/구성요소 노드는 sibling 스티커 노드에 이미 정의(중복 mint 금지·재사용). **고아 공식 아님**
  (has_component 1개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가(시트가격) 고정가 룩업**(원자합산형 아님·pack §3.10). COMP_STK_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`
  (PRICE_TYPE.01). 격자 충전 실측(companion 전사표): COMP_STK_PRINT 6,498행 중 063 소재 MAT_000162 커버
  **246행**·활성 사이즈 SIZ_000059=36행·SIZ_000060=36행(각 수량구간 36티어) → **silent-0 아님**(격자 실재).
  삭제 SIZ_000058=0행(상품행 del_yn=Y 정합). coat_side_cnt 공백(코팅축 없음=투명 무코팅·058 코팅 CONFLICT
  해당 없음). 값 raw는 전사표 권위(손전사 금지).
- ★**소재 연당가(원자재 원가)는 이 완제품가 격자에 직접 없다**(pack §4-B — COMP_PAPER에 MAT_000162 0행·
  소재 마스터에 가격 컬럼 없음). 063 완제품 retail 가격표는 260702 무변경 → 라이브=권위 일치·급변한 원가가
  완제품가로 전파돼야 하는지는 열린 질문([[gap-056-retail-cost-propagation]] 재사용).
- 완제품가 절대값(예전사이트 골든)은 use_yn=N(미출시)+pcode 미상으로 미대조 — 격자 실재로 계산 가능성만 확인
  (058 [[sticker-spec-circle#gap-058-price-golden]]와 동류·지어내지 않음).

## 옵션·제약·추가상품
- **CPQ 옵션그룹(★0행):** `t_prd_product_option_groups/options/option_items` 063 행 **전부 0**(전사표 실측).
  058(07-01 재키잉으로 커팅/인쇄/종이 3그룹 배선)과 달리 063은 **CPQ 옵션 레이어 전면 미적재**
  ([[gap-063-cpq-option-layer]]·pack §3.9 [STK-ST-006] BATCH-6). use_yn=N(미출시)와 정합 — 손님 선택
  UI 배선은 출시 전 별도 적재 필요. 사이즈·소재는 상품 차원(has_size/uses_material)으로만 존재.
- **제약규칙:** `t_prd_product_constraints` 063 행 **없음**(0). 투명 베이스→화이트 requires 등 제약은 §31
  거버넌스 범위(미등록·지어내지 않음).
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 063 행 **없음**(단품 인쇄물·pack §3.12).

## 승계·freshness 메모
- 정체·형상=size·완제품가 의미 = pack §0~5 FRESH 승계. round-13 "디자인상품(.04)"·"CPQ 전면 미적재"류는
  라이브 재분류/재측정으로 재조준(T-1·T-6 오염 회피).
- ★**REVERIFY 3건(위키/pack 대조):** ① prd_typ .04→**.01**(T-1) ② 화이트 GAP-ST(화이트) "MISSING"→
  **해소**(PROC_000008 실재·2026-06-13) ③ CPQ BATCH-6 "전면 미적재"는 063엔 **여전히 TRUE**(058과 달리
  옵션 레이어 부재) → [[gap-063-cpq-option-layer]].
- ★연당가 양면(defect) 판단 = **063은 TRUE**(투명스티커=260702 연당가 변경 4소재 중 하나). 단 dual 노드는
  [[material-MAT_000162]](056 companion)에 이미 존재 → 재사용(중복 mint 금지·pack §4-D 정합). 신규 dual mint 아님.

---

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_sticker_063.py`가 live-snapshot·260702 권위 diff에서
> 결정론 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-sticker063-260703.json`.
> 사이즈/자재/공정/판형은 **전 행(del 표기 포함)** — 재키잉 이력을 침묵으로 버리지 않는다.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000063 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 8 | 10000 | 8 | QTY_UNIT.02 | Y | Y | N | N |

use_yn=**N**(미출시)·editor_yn=Y(053은 N)·file_upload_yn=Y. 최소 8매·증분 8매(QTY_UNIT.02 "매").

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | main_cat_yn |
|---|---|---|
| CAT_000002 | 스티커 | Y |
| CAT_000037 | 규격스티커 | N |

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000063 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 상품행 del | 마스터 del | note |
|---|---|---|---|---|---|---|
| SIZ_000059 | 124x186 | 128x190 | Y | N | N | 판걸이=4.0 / 전지=미지정 / 적용=반칼스티커 |
| SIZ_000060 | 90x190 | 94x194 | Y | N | N | 판걸이=6.0 / 전지=미지정 / 적용=반칼스티커 |
| SIZ_000058 | 100x140 | 104x144 | Y | Y | N | 판걸이=8.0 / 전지=미지정 / 적용=반칼스티커 |

활성(상품행 del_yn=N) 사이즈 2행 = SIZ_000059(124×186·판걸이4)·SIZ_000060(90×190·판걸이6). SIZ_000058
(100×140)은 2026-06-27 상품행 논리삭제(마스터 활성). 규격 팬시 = 형상이 고정 치수로 흡수(형상=size·pack §3.2).

### 자재 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000063 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 부모 | 평량(g) | usage | dflt | del |
|---|---|---|---|---|---|---|---|
| MAT_000162 | 투명스티커 | MAT_TYPE.11 |  | 105 | USAGE.07 | Y | N |

active 자재 1종 = MAT_000162(투명스티커·구코드 parent). ★053이 마이그레이션한 자식 MAT_000371/372를
063은 **쓰지 않고 부모 MAT_000162 직결**(미마이그레이션·[[gap-063-material-unmigrated]]). 자재명/평량은
구값("투명스티커"·105)이고 연당가는 미저장 → 정답은 양면 [[material-MAT_000162]](재사용). MAT_TYPE.11
정답(pack §3.5). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | opt_id | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|---|
| POPT_000001 | 1 | 단면 | CMYK 4도 | 인쇄 안 함 |

단면 1행(앞 CMYK 4도 CLR_000005·뒤 인쇄안함 CLR_000001)·양면 미보유. 도수=인쇄옵션 코드
([[rule/rules#RULE_dosu_is_printopt]]). `has_print_option`→[[axis/print-options#printopt-POPT_000001]](공유 축 재사용).

### 공정 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000063 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 | mand | del |
|---|---|---|---|---|
| PROC_000055 | 스티커완칼 |  | N | N |
| PROC_000008 | 화이트인쇄 | PROC_000007 | N | N |

active 공정 2행 = **PROC_000055 스티커완칼**(Die Cut+조각수·060 rectangle이 정의한 [[process-PROC_000055]]
재사용)·**PROC_000008 화이트인쇄**(별색 PROC_000007 자식·홀로 054가 정의한 [[sticker-halfcut-hologram-nodes#process-PROC_000008]]
재사용). ★상품명 '반칼' vs 공정 '완칼' 명칭 불일치=[[gap-063-halfcut-process]]. ★화이트 PROC_000008 실재
= pack GAP-ST(화이트) "MISSING" 반증(2026-06-13 추가·REVERIFY 해소).

### 판형 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000063 @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000200 | OUTPUT_PAPER_TYPE.03 | PDF | Y | Y | 파일사양 |
| SIZ_000201 | (공백) |  | Y | Y | 파일사양 |
| SIZ_000202 | (공백) |  | Y | Y | 파일사양 |
| SIZ_000521 | OUTPUT_PAPER_TYPE.02 |  | Y | N |  |

활성 판형 1행 = **SIZ_000521**(330×470·OUTPUT_PAPER_TYPE.02=46계열 전지·dflt Y·11개 스티커 공유 전지).
`has_plate_size`→[[plate-063-SIZ_000521]]. SIZ_000200/201/202(파일사양)은 2026-06-30 논리삭제(판형 오적재 정리).
종이류(점착지)라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택 fn_best_plate 자동선택.

### CPQ 옵션 레이어 + 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups/options/option_items/bundle_qtys/addons/constraints/sets PRD_000063 @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| option_groups(CPQ 옵션그룹) | 0 |
| options(옵션값) | 0 |
| option_items(옵션아이템 ref_dim) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 구성원) | 0 |

★CPQ 옵션 레이어 전면 0행(pack §3.9 BATCH-6·[[gap-063-cpq-option-layer]])·058(3그룹 실재)과 대비. bundle_qtys/
addons/constraints/sets 0행은 정직 표기(`has_option_group`/`has_addon`/`constrains`/`has_member` 엣지 없음).
수량 UI 권위=상품 규칙(min 8·incr 8·[[rule/decisions#DEC_qty_audit_260702]]).

### 가격 배선 PRF_STK_FIXED (전사·완제품가 격자)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_STK_PRINT | Y | PRICE_TYPE.01 | 스티커 완제품가(소재·규격) | `["siz_cd", "mat_cd", "min_qty"]` |

`sticker-spec-fancy-clear` --priced_by--> [[formula-PRF_STK_FIXED]] --has_component--> [[component-COMP_STK_PRINT]]
(공유 스티커 공식·중복 mint 없음). COMP_STK_PRINT 단가행(완제품가) 총 6,498행 중 063 소재 MAT_000162 커버
**246행** · 활성 사이즈 SIZ_000059=36행·SIZ_000060=36행(수량구간 36티어)·삭제 SIZ_000058=0행(정합). coat_side_cnt
공백(코팅축 없음). use_dims=`[siz_cd, mat_cd, min_qty]`가 063 가격이 사이즈·소재·수량으로 달라짐을 선언. 값 절대치는
KB 밖(evaluate_price·D-18). ★COMP_PAPER(용지비/연당가)에 MAT_000162 = 0행(원가 미저장) → 연당가는 완제품가 격자에
없음(§4·pack §3.11).

### ★260702 권위 연당가 diff (전사·재사용 dual material-MAT_000162 authority_value 근거)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_063.py from huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv 출력소재(IMPORT) 투명스(백색후지) — 063이 쓰는 소재만 @ 2026-07-03 -->
| 소재키 | 컬럼 | 260527(before) | 260702(after) |
|---|---|---|---|
| 투명스 | 종이명 | 투명스티커 | 투명스티커(백색후지) |
| 투명스 | 평량 | 105 | 50 |
| 투명스 | 구매정보 | 점착 투명105g pet/ 1박스당 100매 | 점착 투명데드롱 50mic (후지:백색박리지150g) / 1박스당 300매 |
| 투명스 | 연당가 | 130000 | 149500 |
| 투명스 | 가격 (국4절) | 1300 | 499 |

위 diff가 재사용 양면 노드 [[material-MAT_000162]](056 companion)의 authority_value 근거다. 063은 투명스티커
(MAT_000162)만 쓰므로 투명후지(MAT_000372) diff는 063 무관(053/056 소관). 완제품 시트가격(COMP_STK_PRINT)은
260702 무변경(change-manifest §1)이라 retail 노드는 dual 아님 — 급락한 원가가 완제품가로 전파돼야 하는지는
열린 질문([[gap-056-retail-cost-propagation]]).

## 끊긴 경로·미결(정직 선언)

- **연당가 재적재 미완(★돈-크리티컬·양면 재사용):** 260702 권위 연당가/국4절이 라이브에 미반영(원가 저장처
  부재). 063 소재 defect는 [[material-MAT_000162]](current_value 라이브 구값/미저장 vs authority_value 260702
  백색후지 149,500/499·badge=defect)에 이미 존재 → **재사용**(중복 mint 금지). 이것이 063 재적재 워크리스트.
- **미마이그레이션(구코드 직결):** 063이 MAT_000162(부모)에 직결·053은 371/372로 이관 → 마이그레이션 정책
  미확정([[gap-063-material-unmigrated]]). use_yn=N(미출시)라 이관 지연 가능성(단정 아님).
- **CPQ 옵션 레이어 0행:** 손님 선택 UI 배선 미적재([[gap-063-cpq-option-layer]]·BATCH-6). 출시 전 적재 필요.
- **커팅 명칭 불일치:** 상품명 반칼(Kiss Cut) vs 공정 PROC_000055 완칼(Die Cut)([[gap-063-halfcut-process]]).
- **범위 밖 거절:** 주문·배송·회원·쿠폰 축은 KB 범위 밖(pack §0·[[rule/rules#RULE_scope_boundary]]) — 이 노드도 안 만든다.

---

## 재사용한 공유 노드 (중복 mint 없음)

이 상품이 **재사용**하는 이미 존재하는 노드(내가 정의하지 않음·needed_shared로 반환):
- [[sticker-halfcut-hologram-nodes#category-CAT_000002]]·[[sticker-spec-circle-nodes#category-CAT_000037]] (스티커/규격스티커 카테고리).
- [[formula-PRF_STK_FIXED]]·[[component-COMP_STK_PRINT]] (스티커 완제품가 공유 공식·구성요소).
- [[axis/print-options#printopt-POPT_000001]] (단면·공유 인쇄옵션 축).
- [[sticker-spec-rectangle-nodes#process-PROC_000055]] (스티커완칼·060이 먼저 정의)·[[sticker-halfcut-hologram-nodes#process-PROC_000008]] (화이트인쇄·홀로 054 정의).
- [[sticker-spec-fancy-nodes#size-SIZ_000059]]·[[sticker-spec-fancy-nodes#size-SIZ_000060]] (★규격 팬시 사이즈·쌍둥이 062가 bare-canonical로 정의·063 재사용).
- [[material-MAT_000162]] (★투명스티커 연당가 양면 defect·056 companion 정의·063 연당가 워크리스트 = 재사용).
- [[gap-056-material-cost-storage]]·[[gap-056-retail-cost-propagation]] (스티커 소재 원가 systemic GAP·056 정의).

이 상품 **전용 하위 노드**(판형 1·수량 1·GAP 3)는 companion [[sticker-spec-fancy-clear-nodes]]에
정의한다(사이즈는 쌍둥이 062 재사용·공유 axis/formula 파일 미수정 원칙·053/058 선례). 공유 축 승격 후보는 build-report의 needed_shared로 반환.
