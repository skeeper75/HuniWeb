<!-- companion nodes for product-023 모양엽서 — 공유 축 노드(axis/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/sizes.md·materials.md·processes.md에 없는 것만 여기 신설(027 방식). -->
<!-- ★master-id(size-SIZ_*·material-MAT_*·process-PROC_*)를 쓴다 — 향후 공유 축(axis/*)으로 이관 후보(needed_shared_nodes로 반환·통합 단계 일괄 mint). -->
<!-- ★수치(치수·사양·배선)는 전사 스크립트 transcribe_product_023.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-023 전용 노드 (모양엽서 — 상품 전용 마스터 축)

[[product-023-shaped-postcard]]가 연결하는 축 중, 디지털 파일럿 공유 축 노드(axis/*)에 아직
없는 것만 신설한다. 공유에 있는 것(몽블랑 240g MAT_000109·PROC_000004 base·국전 판형
plate-OUTPUT_PAPER_TYPE_01·POPT_000001/002·PRF_DGP_B·카테고리 CAT_000307/001)은 재사용하고
여기 중복 신설하지 않는다(L-3).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_023.py`가 live-snapshot에서 결정론 전사(손전사 아님).

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000023 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp |
|---|---|---|---|---|---|
| SIZ_000119 | 90x90 | 92x92 | 90x90 | Y | 1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000023 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage |
|---|---|---|---|---|---|---|
| MAT_000107 | 몽블랑 190g | MAT_TYPE.01 | MAT_000103 | 316x467 | 190 | USAGE.07 |
| MAT_000109 | 몽블랑 240g | MAT_TYPE.01 | MAT_000103 | 316x467 | 240 | USAGE.07 |
| MAT_000113 | 아코팩 | MAT_TYPE.01 |  | 316x467 | 250 | USAGE.07 |

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000023 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000123 | 완칼커팅 | PROC_000121 | Y | 1 |
| PROC_000004 | 디지털인쇄 | PROC_000001 | Y | -1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000023 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005(CMYK 4도) | CLR_000001(인쇄 안 함) |
| 2 | 양면 | POPT_000002 | CLR_000005(CMYK 4도) | CLR_000005(CMYK 4도) |

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000023 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | dflt_plt | item_siz_cd |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 | Y |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000023 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_DGP_B | COMP_PAPER | 1 | Y |
| PRF_DGP_B | COMP_CUT_FULL_DIECUT | 2 | Y |
| PRF_DGP_B | COMP_PRINT_DIGITAL_S1 | 0 |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (수량·상태) PRD_000023 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|
| 12 | 10000 | 12 | QTY_UNIT.02 | PRD_TYPE.01 | N | N | Y | N |

---

## 사이즈 (size) — 모양엽서 전용 1행

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 완칼 상품은 대개 사이즈 소수.
판걸이수(UP수)는 사이즈 컬럼이 아니라 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

### [size-SIZ_000119] 90x90 (완칼 정사각) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000119
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000119", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000119", note: "90x90 정사각(작업 92x92·재단 90x90)·dflt=Y. 공유 axis/sizes 미등재 → 승격 후보(needed_shared_node)"}

---

## 자재 (material) — 모양엽서 전용 2종 (공유 MAT_000109 제외)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★[HARD] 실무진이 IMPORT 시트로
등록한 자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

### [material-MAT_000107] 몽블랑 190g {verified}
- type: material
- anchor: t_mat_materials/MAT_000107
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000107", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000103", 사양_ref: "전사표 MAT_000107(316x467·190g)", note: "몽블랑 계열(상위 MAT_000103)·공유 축 승격 후보"}

<!-- [material-MAT_000109] 몽블랑 240g = 공유 축 노드 재사용(axis/materials.md 정의) — 중복 생성 금지(L-3). 위 전사표에 실재 기록·product-023 uses_material 엣지가 그 노드로 해소. -->

### [material-MAT_000113] 아코팩 250g {verified}
- type: material
- anchor: t_mat_materials/MAT_000113
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000113", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000113(316x467·250g)", note: "아코팩(상위 미기재)·공유 축 승격 후보"}

---

## 공정 (process) — 모양엽서 전용 1종 (공유 PROC_000004 base 제외)

완칼 상품 라우트 = 디지털출력(PROC_000004·base) + 완칼커팅(PROC_000123). 두 공정 모두 mand.
★완칼커팅(PROC_000123)은 공유 축의 완칼(PROC_000053·상위 미상)과 **다른 코드·다른 상위**
(PROC_000123 상위=PROC_000121 커팅). 라이브에서 023·055 **2개 상품이 소비**하므로 공유 축
승격 우선 후보(needed_shared_node). 완칼은 가격측에서 구성요소 COMP_CUT_FULL_DIECUT로도 표현됨
(공정행=생산 라우팅·구성요소=가격·역할 분리·[[product-023-shaped-postcard]] 가격 경로 절 참조).

### [process-PROC_000123] 완칼커팅 {verified}
- type: process
- anchor: t_proc_processes/PROC_000123
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000123 (upr_proc_cd=PROC_000121 커팅)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000023(mand Y)·PRD_000055(mand N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "완칼커팅", upr_proc_cd: "PROC_000121", role: "완제품 모양 커팅(die-cut)·모양엽서/썬캡류", 소비상품: "023·055(2소비=공유 축 승격 후보)", note: "공유 axis/processes의 완칼(PROC_000053)과 별 코드·별 상위(모델링 주의·§17 표시중복 소관 아님·실재 기록)"}
