<!-- companion nodes for product-029 3단접지카드 — 공유 축/형제 노드에 없는 상품 전용 마스터 노드만 신설. -->
<!-- ★공유 파일(axis/*·formula/*·rule/*·index.md) 수정 금지 규칙에 따라, 기존에 없는 것만 여기 신설. -->
<!-- ★신규 mint = PROC_000067·PROC_000068(3단접지 2종)뿐. 사이즈/자재/박공정/공식은 전부 기존 전역 노드 재사용(L-3). -->
<!-- ★수치(치수·사양·배선)는 전사 스크립트 transcribe_product_029.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-029 전용 노드 (3단접지카드 — 상품 전용 마스터 축)

[[product-029-trifold-card]]가 연결하는 축 중, **기존 전역 노드(공유 축 axis/* · 형제 product-027-nodes
· product-023-shaped-postcard-nodes · formula/digital-formulas)에 아직 없는 것만** 신설한다.
3단접지카드는 형제 2단접지카드(027)와 거의 동형이라, **재사용이 기본**이고 신규 mint는
**3단접지 공정 2종(PROC_000067/068)** 뿐이다.

## 재사용 목록 (신규 mint 아님 — 전역 노드 참조)

전사표(transcribe_product_029.py)로 라이브 실재를 확인하되, 아래는 이미 다른 파일이 정의한
전역 노드이므로 여기서 재정의하지 않는다(L-3 중복 금지). product-029의 relations 엣지가 그 노드로 해소된다.

- **사이즈 3종**: `size-SIZ_000523`·`size-SIZ_000124`([[product-027-nodes]] 정의) · `size-SIZ_000004`
  ([[axis/sizes]] 정의·135×135). 신규 사이즈 없음.
- **자재 14종**: 공유 6([[axis/materials]] MAT_000074/081/082/091/092/101) · 027 3([[product-027-nodes]]
  MAT_000108/109/123) · 023 5([[product-023-shaped-postcard-nodes]] MAT_000113/114/115/116/125). 신규 자재 없음.
- **박 공정 8종·가변 2종**: PROC_000037~044([[product-027-nodes]]) · PROC_000031/032([[axis/processes]]). 신규 없음.
- **base 공정**: PROC_000004([[axis/processes]]·디지털인쇄 mand). 신규 없음.
- **가격공식 2종**: `formula-PRF_DGP_E`([[formula/digital-formulas]]) · `formula-PRF_DGP_E_FOIL`
  ([[product-027-nodes]]·박 3구성요소 포함 14 배선). 형제 027이 정의한 공식을 그대로 재사용
  (라이브 t_prd_product_price_formulas가 029에도 두 공식을 바인딩·전사표 확인). 신규 공식·구성요소 없음.

## 사이즈 (size) — 전사 (재사용 확인용)

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). ★3단접지의 폴딩 기하(펼침 3-panel)는
master(t_siz_sizes) 재단값이 권위이며, 여기서 산식을 재구성(날조)하지 않는다. 판걸이수(UP수)는
사이즈 컬럼이 아니라 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_029.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes prd_cd=PRD_000029 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | 노드 정의처(재사용) |
|---|---|---|---|---|---|
| SIZ_000004 | 135x135 | 137x137 | 135x135 | Y | axis/sizes |
| SIZ_000124 | 150x100 | 152x102 | 150x100 | Y | product-027-nodes |
| SIZ_000523 | 100x150 | 202x152 | 200x150 | Y | product-027-nodes |

## 자재 (material) — 전사 (재사용 확인용)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★[HARD] 실무진이 IMPORT 시트로
등록한 자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_029.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials prd_cd=PRD_000029 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | 노드 정의처(재사용) |
|---|---|---|---|---|---|---|
| MAT_000074 | 백색모조지 220g | MAT_TYPE.01 | 316x467 | 220 | USAGE.07 | axis/materials |
| MAT_000081 | 아트지 250g | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | axis/materials |
| MAT_000082 | 아트지 300g | MAT_TYPE.01 | 316x467 | 300 | USAGE.07 | axis/materials |
| MAT_000091 | 스노우지 250g | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | axis/materials |
| MAT_000092 | 스노우지 300g | MAT_TYPE.01 | 316x467 | 300 | USAGE.07 | axis/materials |
| MAT_000101 | 랑데뷰 WH 240g | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | axis/materials |
| MAT_000108 | 몽블랑 210g | MAT_TYPE.01 | 316x467 | 210 | USAGE.07 | product-027-nodes |
| MAT_000109 | 몽블랑 240g | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | product-027-nodes |
| MAT_000113 | 아코팩 | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | product-023-nodes |
| MAT_000114 | 리사이클러스 | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | product-023-nodes |
| MAT_000115 | 매쉬멜로우 | MAT_TYPE.01 | 316x467 | 233 | USAGE.07 | product-023-nodes |
| MAT_000116 | 린넨커버 | MAT_TYPE.01 | 316x467 | 216 | USAGE.07 | product-023-nodes |
| MAT_000123 | 띤또레또 200g | MAT_TYPE.01 | 464x320 | 200 | USAGE.07 | product-027-nodes |
| MAT_000125 | 한지 | MAT_TYPE.01 | 316x467 | 170 | USAGE.07 | product-023-nodes |

---

## 공정 (process) — ★신규 mint 2종 (3단접지 가로/세로)

접지카드 공정 중 **3단접지 2종만** 형제 027(2단접지 PROC_000065/066)에 없어 새로 필요하다.
★[HARD] 접지·박·가변은 도수가 아니라 "공정"으로 들어온다(팩 §3.3·[[rule/rules#RULE_dosu_is_printopt]]).
아래 2종은 형제 027이 지역 mint한 PROC_000065/066(2단접지)와 동형이며, 향후 공유 축(axis/processes)
승격 대상 후보다(needed_shared_nodes로 통합 단계에 보고·open_question).

<!-- transcribed-by: _meta/scripts/transcribe_product_029.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes prd_cd=PRD_000029 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | disp_seq | 노드 정의처 |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | -1 | axis/processes |
| PROC_000037 | 홀로그램 | N | 1 | product-027-nodes |
| PROC_000038 | 금유광 | N | 1 | product-027-nodes |
| PROC_000039 | 은유광 | N | 1 | product-027-nodes |
| PROC_000040 | 먹유광 | N | 1 | product-027-nodes |
| PROC_000041 | 동박 | N | 1 | product-027-nodes |
| PROC_000042 | 적박 | N | 1 | product-027-nodes |
| PROC_000043 | 청박 | N | 1 | product-027-nodes |
| PROC_000044 | 트윙클 | N | 1 | product-027-nodes |
| PROC_000067 | 3단가로접지 | N | 1 | product-029-nodes (신규) |
| PROC_000068 | 3단세로접지 | N | 1 | product-029-nodes (신규) |
| PROC_000031 | 가변텍스트 | N | 10 | axis/processes |
| PROC_000032 | 가변이미지 | N | 11 | axis/processes |

### [process-PROC_000067] 3단 가로접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000067
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000067", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000029 proc_cd:PROC_000067 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "3단가로접지", role: "접지(fold) — 가로 3단(3-panel)·형제 027 PROC_000065(2단)와 동형"}

### [process-PROC_000068] 3단 세로접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000068
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000068", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000029 proc_cd:PROC_000068 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "3단세로접지", role: "접지(fold) — 세로 3단(3-panel)·형제 027 PROC_000066(2단)와 동형"}

---

## 가격공식 바인딩 (전사·재사용 확인용)

3단접지카드는 형제 027과 동일하게 **두 공식**에 라이브 바인딩된다(신규 공식 노드 없음·재사용):
[[formula/digital-formulas#formula-PRF_DGP_E]](접지+타공·박 미선택 기본)와 [[product-027-nodes]]
`formula-PRF_DGP_E_FOIL`(박 선택 시 재바인딩). ★값 계산은 evaluate_price 권위
([[rule/rules#RULE_price_value_boundary]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_029.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas prd_cd=PRD_000029 @ 2026-07-03 -->
| frm_cd | apply_bgn_ymd | note |
|---|---|---|
| PRF_DGP_E | 2026-06-01 | 3단접지카드 → PRF_DGP_E |
| PRF_DGP_E_FOIL | 2026-07-01 | 박 분기 공식으로 재바인딩(동형전파·인간승인 후 COMMIT) |
