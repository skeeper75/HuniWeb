---
id: product-047-small-flyer
type: product
anchor: t_prd_products/PRD_000047
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000047", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "§1 인쇄홍보물 PRD_000047 소량전단지·가격모델 PRF_DGP_D(전단지형)", captured_at: "2026-07-03", badge: verified, src_id: SR-worklist-dp}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.9 047 코팅×종이두께 제약 COMMIT(§31 wave-3)·§3.10 원자합산형", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(lvl1). ★main leaf=CAT_000058 전단지/리플랫(공유 축 미민팅→needed_shared_nodes)·본 엣지는 실재 상위축으로 배선"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210) 전단지 표준 재단"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4(210x297)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)"}
  - {rel: has_size, target: size-SIZ_000176, note: "A3+(300x440)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "종이류라 판형 유효·국전 SIZ_000499·fn_best_plate 자동선택"}
  - {rel: uses_material, target: material-MAT_000074, note: "대표(활성 46종 중)·백색모조지 220g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000081, note: "아트지 250g"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g"}
  - {rel: uses_material, target: material-MAT_000091, note: "스노우지 250g"}
  - {rel: uses_material, target: material-MAT_000092, note: "스노우지 300g"}
  - {rel: uses_material, target: material-MAT_000101, note: "랑데뷰 WH 240g"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(앞 CMYK4도·뒤 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(앞뒤 CMYK4도)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: "Y"}, note: "디지털인쇄 base(disp_seq=-1·인쇄비 원천·DEC_baseproc_260701)"}
  - {rel: has_process, target: process-PROC_000014, qualifier: {mand: "N"}, note: "유광라미네이팅(코팅옵션)"}
  - {rel: has_process, target: process-PROC_000015, qualifier: {mand: "N"}, note: "무광라미네이팅(코팅옵션)"}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: "N"}, note: "가변텍스트(후가공 다중)"}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: "N"}, note: "가변이미지(후가공 다중)"}
  - {rel: has_qty_rule, target: qty-047, note: "상품레벨 min 2·incr 1·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_DGP_D, note: "원자합산형D(전단지형)·인쇄비+코팅비+용지비+후가공비 합산"}
  - {rel: has_option_group, target: optgroup-OPT_000059, note: "인쇄(도수) 필수 1/1"}
  - {rel: has_option_group, target: optgroup-OPT_000060, note: "종이(자재) 필수 1/1·46종"}
  - {rel: has_option_group, target: optgroup-OPT_000061, note: "코팅 선택 0/1"}
  - {rel: has_option_group, target: optgroup-OPT_000062, note: "후가공 다중 0/2(SEL_TYPE.02)"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측)
  archetype: "원자합산형(PRF_DGP_D·인쇄비+코팅비+용지비+후가공비 합산)"
  min_qty: 2                # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"
  editor_yn: "N"
  use_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(전단지/Flyer)", config_ont: "component type"}
tags: [디지털인쇄, 소량전단지, 인쇄홍보물, 원자합산형]
updated: 2026-07-03
---

# product-047-small-flyer — 소량전단지 (PRD_000047)

디지털인쇄 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원
등록 없음 — [[product-type-classification-sot]] 준수). 인쇄홍보물(전단지/리플랫) 군의 낱장
전단지로, A5/A4/A3/A3+ 표준 규격에 단면/양면 칼라 인쇄, **종이 46종** 중 택1, 코팅(유광/무광)
선택, 후가공(가변텍스트·가변이미지) 다중 선택이 가능하다. 가격은 원자합산형 공식
`PRF_DGP_D`(전단지형)가 **인쇄비 + 코팅비 + 용지비(COMP_PAPER) + 후가공비**를 더해 계산한다
(값 계산=`evaluate_price` 권위·D-18 경계).

- 최소 2부·1부 단위 증분(min 2·incr 1·`QTY_UNIT.02` 매) — 소량 주문 지향(상품명 "소량"). 파일 업로드만(`file_upload_yn=Y`·`editor_yn=N`).
- 판형: 종이류라 판형 유효 — 국전계열 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])·`fn_best_plate` 자동선택([[harness-domain-rules-12-260701]]). 판걸이수(UP)는 `fn_calc_pansu`/`t_siz_pansu` DB함수 파생([[rule/rules#RULE_pansu_db_function]]).
- 도수는 인쇄옵션(POPT)이지 색상코드가 아님([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]). 앞/뒤 도수(CMYK4도·인쇄안함)는 인쇄옵션의 속성.
- **디지털 base 공정 PROC_000004**(mand=Y·disp_seq=-1)는 인쇄비 0 해소 COMMIT(18건) 대상([[rule/decisions#DEC_baseproc_260701]]·pack §4-A). 소량전단지도 그 18건 목록(017/018/…/047/284)에 포함.
- 자재는 낱장 단일 본문 → parent + `usage_cd` 단일 슬롯(전 46행 USAGE.07·[[axis/materials]] 모델). `uses_material`은 공유 축 노드가 있는 **대표 7종**만 배선(016 선례)하고, 46종 전수는 아래 전사표가 유일 원천.
- **★자재 오염 후보(candidate):** 종이(OPT_000060) 옵션그룹에 `MAT_000128 면끈`(MAT_TYPE.17)·`MAT_000130 네오디움자석`(MAT_TYPE.03)·`MAT_000129 아크릴키링고리`(MAT_TYPE.03) 등 **비종이 자재**가 섞여 있다(전사표 mat_typ 열). 이는 굿즈 자재 오염([[goods-material-contamination-260630]] 동형) 신호일 수 있어 후보로 표기 — 확정 판정은 검증/실무진 몫(정리 여부는 KB 밖).
- 끊긴/미해결 경로 4건: 제약 스냅샷 지연([[gap-047-coating-constraint]])·코팅 면수 파라미터([[gap-047-coat-side]])·가변 줄수/개수 파라미터([[gap-047-vardata-param]])·매달린 옵션참조([[gap-047-optref-mat129]]) — 지어내지 않고 GAP로 정직 선언.

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_047.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-047-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000047 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 2 | 100000 | 1 | QTY_UNIT.02 | Y | N | Y |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | main_cat_yn |
|---|---|---|
| CAT_000003 | 인쇄홍보물 | N |
| CAT_000058 | 전단지/리플랫 | Y |

> main_cat_yn=Y인 리프 카테고리 `CAT_000058 전단지/리플랫`(lvl2·상위 CAT_000003)는 공유 축(axis/categories)에 아직 노드가 없다 → `in_category` 1급 엣지는 실재하는 상위축 `category-CAT_000003`으로 배선하고 CAT_000058은 통합 단계 mint 대상으로 반환(needed_shared_nodes).

### 사이즈 치수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | note |
|---|---|---|---|---|
| SIZ_000170 | A5(148x210mm) | 148x210 | 148x210 |  |
| SIZ_000172 | A4(210x297mm) | 210x297 | 210x297 |  |
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 |  |
| SIZ_000176 | A3+(300x440mm) | 300x440 | 300x440 |  |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |  |

> SIZ_000170/172/174/176 = 전단지 표준 A규격(재단=작업 동일)·SIZ_000499 = 국전 출력용지(판형).

### 자재 (전사·46종 USAGE.07 단일 슬롯)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| disp_seq | mat_cd | 자재명 | mat_typ | usage | dflt |
|---|---|---|---|---|---|
| 1 | MAT_000072 | 백색모조지 100g | MAT_TYPE.01 | USAGE.07 | Y |
| 2 | MAT_000073 | 백색모조지 120g | MAT_TYPE.01 | USAGE.07 | N |
| 3 | MAT_000074 | 백색모조지 220g | MAT_TYPE.01 | USAGE.07 | N |
| 4 | MAT_000076 | 아트지 100g | MAT_TYPE.01 | USAGE.07 | N |
| 5 | MAT_000077 | 아트지 120g | MAT_TYPE.01 | USAGE.07 | N |
| 6 | MAT_000078 | 아트지 150g | MAT_TYPE.01 | USAGE.07 | N |
| 7 | MAT_000079 | 아트지 180g | MAT_TYPE.01 | USAGE.07 | N |
| 8 | MAT_000080 | 아트지 200g | MAT_TYPE.01 | USAGE.07 | N |
| 9 | MAT_000081 | 아트지 250g | MAT_TYPE.01 | USAGE.07 | N |
| 10 | MAT_000082 | 아트지 300g | MAT_TYPE.01 | USAGE.07 | N |
| 11 | MAT_000086 | 스노우지 100g | MAT_TYPE.01 | USAGE.07 | N |
| 12 | MAT_000087 | 스노우지 120g | MAT_TYPE.01 | USAGE.07 | N |
| 13 | MAT_000088 | 스노우지 150g | MAT_TYPE.01 | USAGE.07 | N |
| 14 | MAT_000089 | 스노우지 180g | MAT_TYPE.01 | USAGE.07 | N |
| 15 | MAT_000090 | 스노우지 200g | MAT_TYPE.01 | USAGE.07 | N |
| 16 | MAT_000091 | 스노우지 250g | MAT_TYPE.01 | USAGE.07 | N |
| 17 | MAT_000092 | 스노우지 300g | MAT_TYPE.01 | USAGE.07 | N |
| 18 | MAT_000095 | 앙상블 100g | MAT_TYPE.01 | USAGE.07 | N |
| 19 | MAT_000096 | 앙상블 130g | MAT_TYPE.01 | USAGE.07 | N |
| 20 | MAT_000097 | 앙상블 160g | MAT_TYPE.01 | USAGE.07 | N |
| 21 | MAT_000098 | 앙상블 190g | MAT_TYPE.01 | USAGE.07 | N |
| 22 | MAT_000099 | 앙상블 210g | MAT_TYPE.01 | USAGE.07 | N |
| 23 | MAT_000101 | 랑데뷰 WH 240g | MAT_TYPE.01 | USAGE.07 | N |
| 24 | MAT_000102 | 랑데뷰 WH 310g | MAT_TYPE.01 | USAGE.07 | N |
| 25 | MAT_000104 | 몽블랑 100g | MAT_TYPE.01 | USAGE.07 | N |
| 26 | MAT_000105 | 몽블랑 130g | MAT_TYPE.01 | USAGE.07 | N |
| 27 | MAT_000106 | 몽블랑 160g | MAT_TYPE.01 | USAGE.07 | N |
| 28 | MAT_000107 | 몽블랑 190g | MAT_TYPE.01 | USAGE.07 | N |
| 29 | MAT_000108 | 몽블랑 210g | MAT_TYPE.01 | USAGE.07 | N |
| 30 | MAT_000109 | 몽블랑 240g | MAT_TYPE.01 | USAGE.07 | N |
| 31 | MAT_000113 | 아코팩 | MAT_TYPE.01 | USAGE.07 | N |
| 32 | MAT_000114 | 리사이클러스 | MAT_TYPE.01 | USAGE.07 | N |
| 33 | MAT_000115 | 매쉬멜로우 | MAT_TYPE.01 | USAGE.07 | N |
| 34 | MAT_000116 | 린넨커버 | MAT_TYPE.01 | USAGE.07 | N |
| 35 | MAT_000117 | 스타화이트 | MAT_TYPE.01 | USAGE.07 | N |
| 36 | MAT_000118 | 클래식 크래스트 | MAT_TYPE.01 | USAGE.07 | N |
| 37 | MAT_000119 | 리브스디자인 250g | MAT_TYPE.01 | USAGE.07 | N |
| 38 | MAT_000120 | 매직터치 | MAT_TYPE.01 | USAGE.07 | N |
| 39 | MAT_000121 | 켄도 | MAT_TYPE.01 | USAGE.07 | N |
| 40 | MAT_000123 | 띤또레또 200g | MAT_TYPE.01 | USAGE.07 | N |
| 41 | MAT_000124 | 띤또레또 250g | MAT_TYPE.01 | USAGE.07 | N |
| 42 | MAT_000125 | 한지 | MAT_TYPE.01 | USAGE.07 | N |
| 43 | MAT_000126 | 스코트랜드 | MAT_TYPE.01 | USAGE.07 | N |
| 44 | MAT_000127 | 스타드림 | MAT_TYPE.01 | USAGE.07 | N |
| 45 | MAT_000128 | 면끈 | MAT_TYPE.17 | USAGE.07 | N |
| 47 | MAT_000130 | 네오디움자석 | MAT_TYPE.03 | USAGE.07 | N |

> ★46종 전수(disp_seq 46은 MAT_000129 아크릴키링고리로 상품자재행 del_yn=Y 논리삭제 07-01 이전 06-30 처리 → 활성 목록에서 빠짐·아래 broken ref 참조). 대부분 `MAT_TYPE.01`(종이)이나 면끈/자석은 비종이(오염 후보).

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |
| POPT_000002 | 양면 | CMYK 4도 | CMYK 4도 |

> 도수는 인쇄옵션(print_opt_cd) — 앞/뒤 색상수(clr)는 인쇄옵션의 속성이지 별도 도수축이 아니다(pack §3.3·T-4 함정).

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| disp_seq | proc_cd | 공정명 | mand |
|---|---|---|---|
| -1 | PROC_000004 | 디지털인쇄 | Y |
| 1 | PROC_000015 | 무광라미네이팅 | N |
| 1 | PROC_000014 | 유광라미네이팅 | N |
| 10 | PROC_000031 | 가변텍스트 | N |
| 11 | PROC_000032 | 가변이미지 | N |

> PROC_000004(디지털인쇄 base·disp_seq=-1)=필수 공정(인쇄비 원천). 코팅(유광/무광)·가변(텍스트/이미지)은 선택(mand=N)·CPQ 코팅/후가공 옵션그룹으로 노출.

### 판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | dflt |
|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 | Y |

### CPQ 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max | mand |
|---|---|---|---|---|
| OPT_000059 | 인쇄 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000060 | 종이 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000061 | 코팅 | SEL_TYPE.01 | 0/1 | N |
| OPT_000062 | 후가공 | SEL_TYPE.02 | 0/2 | N |

> ★OPT_000062 후가공 = `SEL_TYPE.02` 다중선택(max 2) — 가변텍스트·가변이미지 동시 선택 가능(L1 실증). 나머지 3그룹은 단일선택(SEL_TYPE.01).

### CPQ 옵션 아이템 → 차원 참조 (전사·비-자재 참조 전개)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPT_000059 | OPV_000230 | 단면 | OPT_REF_DIM.06 | 1 |  |
| OPT_000059 | OPV_000231 | 양면 | OPT_REF_DIM.06 | 2 |  |
| OPT_000061 | OPV_000280 | 유광 | OPT_REF_DIM.04 | PROC_000014 |  |
| OPT_000061 | OPV_000281 | 무광 | OPT_REF_DIM.04 | PROC_000015 |  |
| OPT_000062 | OPV_000282 | 가변텍스트 | OPT_REF_DIM.04 | PROC_000031 |  |
| OPT_000062 | OPV_000283 | 가변이미지 | OPT_REF_DIM.04 | PROC_000032 |  |
| OPT_000060 | (자재참조) | 종이 옵션 | OPT_REF_DIM.03 | mat_cd | USAGE.07 |

> `ref_dim_cd`: `.06`=인쇄옵션(ref_key1=opt_id·1단면/2양면), `.03`=자재(ref_key1=mat_cd·ref_key2=usage_cd),
> `.04`=공정(ref_key1=proc_cd). 코팅없음(OPV_000279)·후가공 미선택은 min_sel=0 센티넬이라 옵션참조 없음.
> 종이(OPT_000060) 옵션아이템 = **47행**(OPT_REF_DIM.03) vs 활성 materials **46행**.
> ★L-18 결정론 실측: 활성 옵션아이템 중 상품 활성 materials에 **없는** 참조 = **1건**(아래).

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items×t_prd_product_materials L-18 diff @ 2026-07-03 -->
| 매달린 옵션아이템(broken ref) | 옵션 라벨 | ref mat_cd | 자재마스터 이름 | mat_typ |
|---|---|---|---|---|
| OPV_000277 | 스타드림(골드) 240g | MAT_000129 | 아크릴키링고리 | MAT_TYPE.03 |

> ★위 broken ref = `fn_chk_opt_item_ref` 정합 위반 후보(L-18). 활성 옵션아이템(use_yn=Y)이 상품 활성
> materials에 없는 `MAT_000129`를 가리킨다(상품자재행 del_yn=Y 06-30 논리삭제). 게다가 옵션 라벨은
> "스타드림(골드) 240g 종이"인데 자재마스터명은 "아크릴키링고리"(MAT_TYPE.03) — 라벨↔마스터 불일치.
> → [[gap-047-optref-mat129]]로 정직 선언(정리/재활성 판정은 실무진/개발).

### 미보유·현재값 축 (전사·실측 행수)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints @ 2026-07-03 -->
| 축 | 행수(스냅샷 20260702_1119) |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |

> ★제약규칙 0행 = **스냅샷 11:19 시점의 현재값**. §31 wave-3(코팅×종이두께 `R_EXCL_COATING_THIN_PAPER`)는
> 같은 날 **17:21 COMMIT**(스냅샷 이후)이라 이 스냅샷에 없음 → [[gap-047-coating-constraint]]로 정직 선언(재촬영 필요).
> 수량은 상품레벨 규칙(min 2·incr 1·QTY_UNIT.02)만 — 별도 묶음수 행 없음. 추가상품 미등록(정직 표기).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-047-small-flyer` --priced_by--> [[formula/digital-formulas#formula-PRF_DGP_D]]
--has_component--> `COMP_PRINT_DIGITAL_S1`·`COMP_COAT_GLOSSY/MATTE`·`COMP_PAPER`·후가공 구성요소
([[formula/digital-components]]). PRF_DGP_D는 소량전단지 전용 원자합산형 공식이며 구성요소 노드는
기존 축을 재사용한다(중복 mint 없음). 각 구성요소의 `use_dims`가 이 상품 가격이 어떤 축으로
달라지는지 선언한다(값 계산은 엔진·D-18 경계). **가격 경로 연결됨**(priced_by ≥1·공식 has_component ≥1).

### 가격 배선 PRF_DGP_D (전사·골든 스냅샷 20260702_1119)

<!-- transcribed-by: _meta/scripts/transcribe_product_047.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 0 | COMP_PRINT_DIGITAL_S1 | Y | PRICE_TYPE.01 | 디지털인쇄비 | `["proc_cd", "plt_siz_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000001"]` |
| 1 | COMP_COAT_GLOSSY | Y | PRICE_TYPE.01 | 유광코팅비 | `["proc_cd", "plt_siz_cd", "coat_side_cnt", "min_qty", "proc_grp:PROC_000013"]` |
| 2 | COMP_COAT_MATTE | Y | PRICE_TYPE.01 | 무광코팅비 | `["proc_cd", "plt_siz_cd", "coat_side_cnt", "min_qty", "proc_grp:PROC_000013"]` |
| 3 | COMP_PAPER | Y | PRICE_TYPE.01 | 용지비(종이별 절가) | `["plt_siz_cd", "mat_cd"]` |
| 4 | COMP_CUT_PERF_1H6 | Y | PRICE_TYPE.01 | 타공비 (6mm) | `["proc_cd", "min_qty", "proc_grp:PROC_000079"]` |
| 5 | COMP_PP_CREASE_1L | Y | PRICE_TYPE.01 | 오시비 | `["proc_cd", "min_qty", "proc_grp:PROC_000029"]` |
| 6 | COMP_PP_PERF_1L | Y | PRICE_TYPE.01 | 미싱비 | `["proc_cd", "min_qty", "proc_grp:PROC_000030"]` |
| 7 | COMP_PP_VARTEXT_1EA | Y | PRICE_TYPE.03 | 가변텍스트 | `["proc_cd", "min_qty", "proc_grp:PROC_000085"]` |
| 8 | COMP_PP_VARIMG_1EA | Y | PRICE_TYPE.03 | 가변이미지 | `["proc_cd", "min_qty", "proc_grp:PROC_000085"]` |
| 9 | COMP_PP_CORNER_RIGHT | Y | PRICE_TYPE.03 | 귀돌이비 | `["proc_cd", "min_qty", "proc_grp:PROC_000026"]` |

> 골든 라벨: 위 배선은 live-snapshot 20260702_1119 기준. 소량전단지가 실 사용하는 항목은
> 디지털인쇄비·용지비(COMP_PAPER)·코팅비(선택 시)·가변(선택 시). 타공/오시/미싱/귀돌이는 PRF_DGP_D
> 공유 슬롯이며 이 상품 공정(PROC_000004/014/015/031/032)에 없으면 해당 항목은 0(차원 미매칭·엔진 판정).
> 값 절대치는 KB 밖(evaluate_price)·D-18 경계.

---

## 이 상품 전용 하위 노드

> SIZ_000170/172/174/176(A5/A4/A3/A3+ 표준 전단지 규격)는 이 파일이 선언한다(공유 axis 미수정 원칙·
> 종이슬로건 SIZ_000015/016 선례). ★표준 A규격이라 다른 상품과 공유될 여지가 커 **공유 축 승격 후보**로
> needed_shared_nodes에 반환한다. 자재·공정·인쇄옵션·판형·공식은 공유 축의 기존 노드로 해소(중복 금지).

### [size-SIZ_000170] A5 148x210 (전단지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000170
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000170", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000170", note: "A5(148x210)·재단=작업 동일·전단지 표준"}

### [size-SIZ_000172] A4 210x297 (전단지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000172
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000172", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000172", note: "A4(210x297)·재단=작업 동일·전단지 표준"}

### [size-SIZ_000174] A3 297x420 (전단지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000174
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000174", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000174", note: "A3(297x420)·재단=작업 동일·전단지 표준"}

### [size-SIZ_000176] A3+ 300x440 (전단지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000176
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000176", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000176", note: "A3+(300x440)·재단=작업 동일·전단지 표준(A3 여백형)"}

### [qty-047] 소량전단지 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000047
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000047(min_qty/qty_incr/qty_unit_typ_cd)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min 2·max 100000·incr 1)", bdl_unit_typ_cd: "QTY_UNIT.02", note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙(pack §3.4). 소량 지향(min 2·1부 증분)"}

### [optgroup-OPT_000059] 인쇄 (도수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000047
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000047,OPT_000059)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000059", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택·단면/양면"}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}, note: "단면(ref_key1=opt_id 1)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "2"}, note: "양면(ref_key1=opt_id 2)"}

### [optgroup-OPT_000060] 종이 (자재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000047
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000047,OPT_000060)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000060", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택·활성 자재 46종(USAGE.07). 옵션참조 대표 배선만(전수는 전사표)·1건 broken ref(MAT_000129)는 gap-047-optref-mat129"}
- rel: {rel: option_refs, target: material-MAT_000074, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000074", ref_key2: "USAGE.07"}, note: "대표(공유 축 노드 有)·백색모조지 220g"}
- rel: {rel: option_refs, target: material-MAT_000082, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000082", ref_key2: "USAGE.07"}, note: "아트지 300g"}
- rel: {rel: option_refs, target: material-MAT_000092, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000092", ref_key2: "USAGE.07"}, note: "스노우지 300g"}
- rel: {rel: option_refs, target: material-MAT_000109, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000109", ref_key2: "USAGE.07"}, note: "몽블랑 240g"}

### [optgroup-OPT_000061] 코팅 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000047
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000047,OPT_000061)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000061", opt_grp_nm: "코팅", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "min/max 0/1 선택·코팅없음(OPV_000279)은 min_sel=0 센티넬"}
- rel: {rel: option_refs, target: process-PROC_000014, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000014"}, note: "유광→유광라미네이팅"}
- rel: {rel: option_refs, target: process-PROC_000015, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000015"}, note: "무광→무광라미네이팅"}

### [optgroup-OPT_000062] 후가공 (다중) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000047
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000047,OPT_000062)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000062", opt_grp_nm: "후가공", sel_typ_cd: "SEL_TYPE.02", mand_yn: "N", note: "★min/max 0/2 다중선택(SEL_TYPE.02)·가변텍스트+가변이미지 동시 가능. 줄수/개수 파라미터 미보존=gap-047-vardata-param"}
- rel: {rel: option_refs, target: process-PROC_000031, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000031"}, note: "가변텍스트→PROC_000031"}
- rel: {rel: option_refs, target: process-PROC_000032, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000032"}, note: "가변이미지→PROC_000032"}

### [gap-047-coating-constraint] 코팅×종이두께 제약 — 스냅샷 지연 {unknown}
- type: gap
- anchor: none  # 사유: §31 wave-3 제약(17:21 COMMIT)이 내 권위 스냅샷(11:19)보다 뒤라 닫힌세계에 부재 — 있는 것을 아직 앵커 못 함
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints 키:PRD_000047(0행·snap_20260702_1119)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "코팅×종이두께 제약 `R_EXCL_COATING_THIN_PAPER`(코팅은 180g 이상 종이에서만·RULE_TYPE.02 금지형·30조합)가 §31 wave-3에서 2026-07-02 17:21 라이브 COMMIT됐으나(register-log), 이 KB 권위 스냅샷(11:19)에는 constraints=0행 → 제약 노드를 t_prd_product_constraints 앵커로 확정·L-17 검사 통과시킬 수 없음"
- gap_fill_from: "17:21 이후 시점 live-snapshot 재촬영(읽기전용 snapshot.sh) 후 constraint 노드(E12) mint. 원장=_workspace/huni-constraint-rules/04_register/wave3/register-log.md·03_rules/wave3-dgp/rule-spec.md"
- gap_owner: 설계

### [gap-047-coat-side] 코팅 면수(coat_side_cnt) 옵션 파라미터 미보존 {unknown}
- type: gap
- anchor: none  # 사유: 코팅 면수 축이 t_prd_product_option_* 어디에도 없음 — 라이브에 부재하는 것을 앵커 못 함
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000047,OPT_000061)(note: '단/양면 면구분=GAP-PARAM')", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "코팅 구성요소 COMP_COAT_GLOSSY/MATTE의 use_dims에 `coat_side_cnt`(코팅 면수)가 있으나, 코팅 옵션그룹(OPT_000061)은 유광/무광만 고르고 면수(단면/양면 코팅)를 옵션 파라미터로 잡지 않는다 → 견적 시 coat_side_cnt 차원 환원에 별도 detail 필요"
- gap_fill_from: "코팅명함 032 코팅면수 GAP(GAP_032_coat_side)와 동형 — §31 제약/옵션 파라미터 거버넌스로 면수 옵션 신설 또는 위젯 detail 전달 규약 확정(실무진/개발팀)"
- gap_owner: 설계

### [gap-047-vardata-param] 가변텍스트/이미지 줄수·개수 파라미터 미보존 {unknown}
- type: gap
- anchor: none  # 사유: 가변데이타 줄수/개수 파라미터 축이 t_prd_product_option_* 어디에도 없음
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000047,OPT_000062)(note: '줄수/개수=GAP-PARAM(보존불가)')", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "후가공 가변텍스트(PROC_000031)/가변이미지(PROC_000032)의 가격 구성요소 COMP_PP_VARTEXT_1EA/VARIMG_1EA는 개당(1EA) 단가형이나, 후가공 옵션그룹(OPT_000062)은 종류만 고르고 줄수/개수를 옵션 파라미터로 보존하지 않는다 → 견적 시 수량 detail 별도 전달 필요"
- gap_fill_from: "033/041 동형 GAP(gap-033-vardata-param·GAP_finish_param_041)과 함께 §31/위젯 detail 전달 규약으로 파라미터 축 정의(위젯/실무진)"
- gap_owner: 위젯/§31

### [gap-047-optref-mat129] 매달린 옵션참조 — 삭제·오라벨 자재(MAT_000129) {unknown}
- type: gap
- anchor: none  # 사유: 정합 이상(활성 옵션아이템이 삭제된 상품자재를 가리킴) — 정답 상태가 실무진 판정 대기라 단정 앵커 부적절
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000047,OPV_000277) ref_key1=MAT_000129(use_yn=Y·del_yn=N) vs t_prd_product_materials(PRD_000047,MAT_000129) del_yn=Y 2026-06-30", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "종이 옵션그룹(OPT_000060)의 활성 옵션아이템 OPV_000277이 상품 활성 materials에 없는 MAT_000129를 참조(상품자재행 06-30 논리삭제). 또 옵션 라벨='스타드림(골드) 240g 종이'인데 자재마스터명='아크릴키링고리'(MAT_TYPE.03) — 라벨↔마스터 불일치. fn_chk_opt_item_ref/L-18 정합 위반 후보(옵션엔 뜨나 자재 없음→선택 시 견적 환원 오류 가능)"
- gap_fill_from: "실무진/개발 — ① 옵션아이템 OPV_000277 정리(논리삭제) 또는 ② 자재 재활성+라벨 교정. 자재 오염 문맥=[[goods-material-contamination-260630]]. 실 교정은 KB 밖(§7/§17 위임·인간 승인)"
- gap_owner: staff/dev
