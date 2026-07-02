<!-- companion nodes for product-027 2단접지카드 — 공유 축 노드(axis/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/sizes.md·materials.md·processes.md에 없는 것만 여기 신설. -->
<!-- ★master-id(size-SIZ_*·material-MAT_*·process-PROC_*)를 쓴다 — 향후 공유 축(axis/*)으로 이관 가치 있음(open_question). -->
<!-- ★수치(치수·사양·배선)는 전사 스크립트 transcribe_product_027.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-027 전용 노드 (2단접지카드 — 상품 전용 마스터 축)

[[product-027-bifold-card]]가 연결하는 축 중, 디지털 파일럿 공유 축 노드(axis/*)에 아직
없는 것만 신설한다. 공유에 있는 것(백색모조지 등 자재 6종·PROC_000004 base·국전 판형·
POPT_000002 양면·PRF_DGP_E·엽서 사이즈)은 재사용하고 여기 중복 신설하지 않는다.

---

## 사이즈 (size) — 접지카드 전용 6행

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 작업사이즈가 재단의 약 2배인
행(예 SIZ_000523 재단 200×150 / 작업 202×152)은 **펼침(접기 전) 전개 치수**다(2단접지 특성).
판걸이수(UP수)는 사이즈 컬럼이 아니라 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_027.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes prd_cd=PRD_000027 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp_seq |
|---|---|---|---|---|---|
| SIZ_000523 (신규) | 100x150 | 202x152 | 200x150 | Y | 1 |
| SIZ_000124 (신규) | 150x100 | 152x102 | 150x100 | Y | 2 |
| SIZ_000524 (신규) | 135x135 | 274x139 | 270x135 | Y | 3 |
| SIZ_000525 (신규) | 135x135 | 139x274 | 135x270 | N | 4 |
| SIZ_000526 (신규) | 110x170 | 224x174 | 220x170 | Y | 5 |
| SIZ_000129 (신규) | 170x110 | 174x224 | 170x220 | Y | 6 |

### [size-SIZ_000523] 100x150 (재단·펼침 200x150) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000523
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000523", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000523", note: "접힌 100x150·펼침 재단 200x150(disp_seq 1·dflt)"}

### [size-SIZ_000124] 150x100 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000124
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000124", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000124", note: "가로형 150x100"}

### [size-SIZ_000524] 135x135 가로접지 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000524
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000524", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000524", note: "135x135·펼침 재단 270x135(가로접지)"}

### [size-SIZ_000525] 135x135 세로접지 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000525
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000525", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000525", note: "135x135·펼침 재단 135x270(세로접지)·dflt=N. SIZ_000524와 접힌 치수 동일·펼침 방향만 다름(표시중복 후보=§17 소관, KB는 실재 기록)"}

### [size-SIZ_000526] 110x170 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000526
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000526", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000526", note: "110x170·펼침 재단 220x170"}

### [size-SIZ_000129] 170x110 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000129
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000129", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000129", note: "가로형 170x110·펼침 재단 170x220"}

---

## 자재 (material) — 접지카드 전용 8종 (공유 6종 제외)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★[HARD] 실무진이 IMPORT 시트로
등록한 자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_keep]]).
규격/평량이 "?"인 자재(347/348/349/350/356)는 **마스터 t_mat_materials에 사양 미기재**(전사 결과
그대로·날조 금지). 채움은 실무진/자재 마스터 보강 소관.

<!-- transcribed-by: _meta/scripts/transcribe_product_027.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (공유 6종 제외) prd_cd=PRD_000027 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage |
|---|---|---|---|---|---|
| MAT_000108 | 몽블랑 210g | MAT_TYPE.01 | 316x467 | 210 | USAGE.07 |
| MAT_000109 | 몽블랑 240g | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 |
| MAT_000347 | 아코팩 웜화이트 250g | MAT_TYPE.01 | ?x? | ? | USAGE.07 |
| MAT_000348 | 리사이클러스 240g | MAT_TYPE.01 | ?x? | ? | USAGE.07 |
| MAT_000349 | 매쉬멜로우 233g | MAT_TYPE.01 | ?x? | ? | USAGE.07 |
| MAT_000350 | 린넨커버 216g | MAT_TYPE.01 | ?x? | ? | USAGE.07 |
| MAT_000123 | 띤또레또 200g | MAT_TYPE.01 | 464x320 | 200 | USAGE.07 |
| MAT_000356 | 한지 170g | MAT_TYPE.01 | ?x? | ? | USAGE.07 |

### [material-MAT_000108] 몽블랑 210g {verified}
- type: material
- anchor: t_mat_materials/MAT_000108
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000108", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000108"}

<!-- [material-MAT_000109] 몽블랑 240g = 형제 노드 재사용(product-046-label-tag-nodes.md 정의) — 중복 생성 금지(L-3). 위 전사표에 실재 기록·product-027 uses_material 엣지가 그 노드로 해소. -->

### [material-MAT_000347] 아코팩 웜화이트 250g {verified}
- type: material
- anchor: t_mat_materials/MAT_000347
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000347", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000347", note: "규격/평량 마스터 미기재(전사 ?)"}

### [material-MAT_000348] 리사이클러스 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000348
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000348", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000348", note: "규격/평량 마스터 미기재(전사 ?)"}

### [material-MAT_000349] 매쉬멜로우 233g {verified}
- type: material
- anchor: t_mat_materials/MAT_000349
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000349", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000349", note: "규격/평량 마스터 미기재(전사 ?)"}

### [material-MAT_000350] 린넨커버 216g {verified}
- type: material
- anchor: t_mat_materials/MAT_000350
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000350", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000350", note: "규격/평량 마스터 미기재(전사 ?)"}

### [material-MAT_000123] 띤또레또 200g {verified}
- type: material
- anchor: t_mat_materials/MAT_000123
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000123", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000123", note: "규격 464x320(가로 장방향 시트)"}

### [material-MAT_000356] 한지 170g {verified}
- type: material
- anchor: t_mat_materials/MAT_000356
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000356", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000356", note: "규격/평량 마스터 미기재(전사 ?)"}

---

## 공정 (process) — 접지카드 전용 12종 (공유 PROC_000004 base 제외)

접지카드 공정 = 접지(2단 가로/세로) + 박(홀로그램·유광박 3·금속박 4·트윙클) + 가변데이타.
★[HARD] 별색·박·코팅·UV는 도수가 아니라 "공정"으로 들어온다(팩 §3.3·[[rule/rules#RULE_dosu_is_printopt]]).
★이 상품은 [[rule/gaps#GAP_foil_parent_children]](박 부모 PROC_000033 vs 박색 8자식 AMBIGUOUS)의
**구체 실현형**을 보인다 — 박색 8종을 옵션그룹(OPT_000033 박칼라) 값으로 두고 각 값이 개별
공정(PROC_000037~044)을 가리킨다(박 부모 PROC_000033 미사용). 즉 여기서는 "옵션풀+개별 공정"으로
해소돼 있다(GAP은 전 상품 통일 여부가 미결).

### [process-PROC_000065] 2단 가로접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000065
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000065", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "2단가로접지", role: "접지(fold) — 가로 2단"}

### [process-PROC_000066] 2단 세로접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000066
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000066", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "2단세로접지", role: "접지(fold) — 세로 2단"}

<!-- [process-PROC_000031] 가변텍스트 · [process-PROC_000032] 가변이미지 = 형제 노드 재사용(product-033-standard-namecard.md 정의) — 중복 생성 금지(L-3). product-027 has_process 엣지가 그 노드로 해소. -->

### [process-PROC_000037] 홀로그램 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000037
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000037", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "홀로그램", role: "박(foil) 박색 자식 — 박칼라 옵션값(특수박)"}

### [process-PROC_000038] 금유광 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000038
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000038", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "금유광", role: "박(foil) 박색 자식 — 박칼라 옵션값"}

### [process-PROC_000039] 은유광 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000039
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000039", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "은유광", role: "박(foil) 박색 자식 — 박칼라 옵션값"}

### [process-PROC_000040] 먹유광 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000040
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000040", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "먹유광", role: "박(foil) 박색 자식 — 박칼라 옵션값"}

### [process-PROC_000041] 동박 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000041
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000041", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "동박", role: "박(foil) 박색 자식 — 박칼라 옵션값(일반박)"}

### [process-PROC_000042] 적박 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000042
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000042", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "적박", role: "박(foil) 박색 자식 — 박칼라 옵션값(일반박)"}

### [process-PROC_000043] 청박 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000043
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000043", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "청박", role: "박(foil) 박색 자식 — 박칼라 옵션값(일반박)"}

### [process-PROC_000044] 트윙클 (박) {verified}
- type: process
- anchor: t_proc_processes/PROC_000044
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000044", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "트윙클", role: "박(foil) 박색 자식 — 박칼라 옵션값(특수박)"}

---

## 가격공식 (price_formula) — 박 분기 PRF_DGP_E_FOIL

2단접지카드는 **두 공식**에 바인딩된다: [[formula/digital-formulas#formula-PRF_DGP_E]](접지+타공,
박 미선택)와 아래 PRF_DGP_E_FOIL(박 선택 시 재바인딩). 박 분기는 접지카드 공식(E)에 박 3구성요소
(동판셋업+일반박+특수박)를 더한 형태다. ★값 계산은 evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_027.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components+t_prc_price_components frm_cd=PRF_DGP_E_FOIL prd_cd=PRD_000027 @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm |
|---|---|---|---|---|
| 0 | COMP_PRINT_DIGITAL_S1 | Y | PRICE_TYPE.01 | 디지털인쇄비 |
| 1 | COMP_COAT_GLOSSY | Y | PRICE_TYPE.01 | 유광코팅비 |
| 2 | COMP_COAT_MATTE | Y | PRICE_TYPE.01 | 무광코팅비 |
| 3 | COMP_PAPER | Y | PRICE_TYPE.01 | 용지비(종이별 절가) |
| 4 | COMP_FOLD_LEAF_HALF | Y | PRICE_TYPE.01 | 접지비 리플렛 반접지 |
| 5 | COMP_FOLD_LEAF_3FOLD | Y | PRICE_TYPE.01 | 접지비 리플렛 3단 |
| 6 | COMP_FOLD_LEAF_4ACC | Y | PRICE_TYPE.01 | 접지비 리플렛 4단아코디언 |
| 7 | COMP_FOLD_LEAF_4GATE | Y | PRICE_TYPE.01 | 접지비 리플렛 4단게이트 |
| 8 | COMP_CUT_PERF_1H6 | Y | PRICE_TYPE.01 | 타공비 (6mm) |
| 9 | COMP_FOIL_SETUP_LARGE | Y | PRICE_TYPE.03 | 박·형압 동판셋업비(대형) |
| 10 | COMP_FOIL_PROC_LARGE_STD | Y | PRICE_TYPE.03 | 박 가공비(대형·일반박) |
| 11 | COMP_FOIL_PROC_LARGE_SPECIAL | Y | PRICE_TYPE.03 | 박 가공비(대형·특수박) |
| 12 | COMP_PP_VARTEXT_1EA | Y | PRICE_TYPE.03 | 가변텍스트 |
| 13 | COMP_PP_VARIMG_1EA | Y | PRICE_TYPE.03 | 가변이미지 |

### [formula-PRF_DGP_E_FOIL] 원자합산형 접지카드+박 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_E_FOIL
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_DGP_E_FOIL frm_nm:접지카드(디지털인쇄·접지·타공)+박·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_E_FOIL (14 구성요소)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_GLOSSY, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_MATTE, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_HALF, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_3FOLD, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_4ACC, qualifier: {disp_seq: 6, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_4GATE, qualifier: {disp_seq: 7, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_PERF_1H6, qualifier: {disp_seq: 8, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_SETUP_LARGE, qualifier: {disp_seq: 9, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_LARGE_STD, qualifier: {disp_seq: 10, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_LARGE_SPECIAL, qualifier: {disp_seq: 11, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARTEXT_1EA, qualifier: {disp_seq: 12, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARIMG_1EA, qualifier: {disp_seq: 13, addtn: Y}}
- props: {archetype: "원자합산형", note: "027 2단접지카드 박 선택 시 재바인딩(동형전파)·접지카드 E공식 + 박 3구성요소"}

---

## 가격구성요소 (price_component) — 박/형압 3종 (공유 digital-components.md에 없음)

박 분기 공식이 배선하는 박 구성요소. use_dims = 가격이 어떤 축으로 달라지는가(차원 선언)까지만 —
값 계산은 evaluate_price 권위(D-18·단가행은 D-22로 접음). 박은 동판셋업(고정·siz 면적) +
가공비(일반/특수 분기·수량)로 나뉜다.

<!-- transcribed-by: _meta/scripts/transcribe_product_027.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components (박/형압 구성요소) prd_cd=PRD_000027 @ 2026-07-03 -->
| comp_cd | comp_nm | prc_typ | use_dims |
|---|---|---|---|
| COMP_FOIL_SETUP_LARGE | 박·형압 동판셋업비(대형) | PRICE_TYPE.03 | ["proc_cd", "siz_width", "siz_height"] |
| COMP_FOIL_PROC_LARGE_STD | 박 가공비(대형·일반박) | PRICE_TYPE.03 | ["proc_cd", "siz_width", "siz_height", "min_qty"] |
| COMP_FOIL_PROC_LARGE_SPECIAL | 박 가공비(대형·특수박) | PRICE_TYPE.03 | ["proc_cd", "siz_width", "siz_height", "min_qty"] |

### [component-COMP_FOIL_SETUP_LARGE] 박·형압 동판셋업비(대형) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOIL_SETUP_LARGE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOIL_SETUP_LARGE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "siz_width", "siz_height"]', role: "동판 셋업비(1회 고정·박 면적 차원)"}

### [component-COMP_FOIL_PROC_LARGE_STD] 박 가공비(대형·일반박) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOIL_PROC_LARGE_STD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOIL_PROC_LARGE_STD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "siz_width", "siz_height", "min_qty"]', role: "일반박(동/적/청박) 가공비·수량 차원"}

### [component-COMP_FOIL_PROC_LARGE_SPECIAL] 박 가공비(대형·특수박) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOIL_PROC_LARGE_SPECIAL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOIL_PROC_LARGE_SPECIAL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "siz_width", "siz_height", "min_qty"]', role: "특수박(홀로그램/트윙클/유광박) 가공비·수량 차원"}
