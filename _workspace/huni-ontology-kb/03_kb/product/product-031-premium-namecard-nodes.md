<!-- companion nodes for product-031 프리미엄명함 — 공유 축(axis/*·formula/*)에 아직 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일(axis/*·formula/*·rule/*) 수정 금지 규칙에 따라, 거기 없는 것만 여기(자기 네임스페이스) 신설. -->
<!-- ★master-id(size-SIZ_*·material-MAT_*·formula-PRF_*·component-COMP_*)를 쓴다 — 공유 축 승격 가치 있음(needed_shared_nodes 반환). -->
<!-- ★수치(치수·사양·배선)는 전사 스크립트 transcribe_product_031.py 출력만(transcribed-by 마커). LLM 손전사 금지(D-9). -->

# product-031 전용 노드 (프리미엄명함 — 상품 전용 마스터 축·공식·구성요소)

[[product-031-premium-namecard]]가 연결하는 축·공식·구성요소 중, 디지털 파일럿 공유 축(axis/*·
formula/*)에도 형제 상품 companion(027-nodes 등)에도 **아직 없는 것만** 신설한다. 이미 있는 것
(명함 사이즈 008/133·자재 101/109·박색 자식공정 037~044·모서리/가변 공정·COMP_PP_VARTEXT/VARIMG/
CORNER_RIGHT 등)은 재사용하고 여기 중복 신설하지 않는다(L-3). 신설분은 `needed_shared_nodes`로
반환해 통합 단계가 공유 축(axis/materials·sizes·formula/digital-formulas·digital-components)으로 일괄 승격한다.

---

## 사이즈 (size) — 명함 전용 1행 신규 (008/133은 공유 축 재사용)

<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000009 | 90x55mm | 92x57 | 90x55 |

### [size-SIZ_000009] 90x55mm (명함) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000009
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000009", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000009", note: "명함 규격 90x55(작업 92x57·재단 90x55)·dflt_yn=Y. 판걸이수는 파생(fn_calc_pansu). 031 신규(008/133은 032/033 공용 승격분)"}

---

## 자재 (material) — 프리미엄 지질 5종 신규 (공유·형제 companion 정의분 제외)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★[HARD] 실무진이 IMPORT 시트로 등록한
자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]). 규격/평량이 "미기재"인
자재(351/353/357)는 **마스터 t_mat_materials에 사양 공란**(전사 결과 그대로·날조 0). 아래 5종은
공유 axis/materials.md에도 027 companion(108/347/348/349/350/123/356)에도 없어 신설한다. ★upr_mat_cd =
프리미엄 지질 부모 코드(제품은 무게-특정 child를 재고) — 옵션 참조(부모)↔상품 재고(child) 관계는
[[product-031-premium-namecard#GAP_031_paper_parent_child]]에 정직 기록.

<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | upr(부모) |
|---|---|---|---|---|---|
| MAT_000102 | 랑데뷰 WH 310g | MAT_TYPE.01 | 316x467 | 310 | MAT_000100 |
| MAT_000124 | 띤또레또 250g | MAT_TYPE.01 | 464x320 | 250 | MAT_000122 |
| MAT_000351 | 스타화이트(하이테크) 238g | MAT_TYPE.01 | 미기재 | 미기재 | MAT_000117 |
| MAT_000353 | 클래식 크래스트 스티플 270g | MAT_TYPE.01 | 미기재 | 미기재 | MAT_000118 |
| MAT_000357 | 스코트랜드 220g | MAT_TYPE.01 | 미기재 | 미기재 | MAT_000126 |

### [material-MAT_000102] 랑데뷰 WH 310g {verified}
- type: material
- anchor: t_mat_materials/MAT_000102
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000102", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000102", upr_mat_cd: "MAT_000100", note: "랑데뷰 WH 계열 310g(부모 MAT_000100)"}

### [material-MAT_000124] 띤또레또 250g {verified}
- type: material
- anchor: t_mat_materials/MAT_000124
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000124", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000124", upr_mat_cd: "MAT_000122", note: "띤또레또 250g(규격 464x320 가로 장방향·부모 MAT_000122)"}

### [material-MAT_000351] 스타화이트(하이테크) 238g {verified}
- type: material
- anchor: t_mat_materials/MAT_000351
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000351", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000351", upr_mat_cd: "MAT_000117", note: "규격/평량 마스터 미기재(전사 공란). 옵션 참조는 부모 MAT_000117(스타화이트)"}

### [material-MAT_000353] 클래식 크래스트 스티플 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000353
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000353", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000353", upr_mat_cd: "MAT_000118", note: "규격/평량 마스터 미기재. 옵션 참조는 부모 MAT_000118(클래식 크래스트)"}

### [material-MAT_000357] 스코트랜드 220g {verified}
- type: material
- anchor: t_mat_materials/MAT_000357
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000357", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000357", upr_mat_cd: "MAT_000126", note: "규격/평량 마스터 미기재. 옵션 참조는 부모 MAT_000126(스코트랜드)"}

<!-- 재사용(중복 신설 금지·L-3): MAT_000101/109=axis/materials.md · MAT_000108/347/348/349/350/123/356=product-027-nodes.md · 위 상품의 uses_material 엣지가 그 노드로 해소. -->

---

## 가격공식 (price_formula) — 프리미엄명함 등급가 + 박 분기

프리미엄명함은 **두 공식**에 바인딩된다(라이브 t_prd_product_price_formulas 실측): 박 미선택 시
[[#formula-PRF_NAMECARD_PREMIUM]](등급가 A/B × 단/양면 + 가변 + 귀돌이), 박(박칼라) 선택 시
[[#formula-PRF_NAMECARD_PREMIUM_FOIL]](등급가에 소형 동판셋업+일반박/특수박 3구성요소 추가).
등급가는 고정가(용지포함·use_dims mat_cd/print_opt_cd/min_qty)로, 지질 등급(A/B)·단/양면별 단가표다.
★값 계산은 evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 배선까지(D-18).

<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components frm_cd=PRF_NAMECARD_PREMIUM(_FOIL) @ 2026-07-03 -->
| 공식 | disp_seq | comp_cd | addtn | prc_typ |
|---|---|---|---|---|
| PRF_NAMECARD_PREMIUM | 1 | COMP_NAMECARD_PREMIUM_S1_MGA | Y | PRICE_TYPE.02 |
| PRF_NAMECARD_PREMIUM | 2 | COMP_NAMECARD_PREMIUM_S1_MGB | Y | PRICE_TYPE.02 |
| PRF_NAMECARD_PREMIUM | 3 | COMP_NAMECARD_PREMIUM_S2_MGA | Y | PRICE_TYPE.02 |
| PRF_NAMECARD_PREMIUM | 4 | COMP_NAMECARD_PREMIUM_S2_MGB | Y | PRICE_TYPE.02 |
| PRF_NAMECARD_PREMIUM | 5 | COMP_PP_VARTEXT_1EA | Y | PRICE_TYPE.03 |
| PRF_NAMECARD_PREMIUM | 6 | COMP_PP_VARIMG_1EA | Y | PRICE_TYPE.03 |
| PRF_NAMECARD_PREMIUM | 7 | COMP_PP_CORNER_RIGHT | Y | PRICE_TYPE.03 |
| PRF_NAMECARD_PREMIUM_FOIL | 1~4 | COMP_NAMECARD_PREMIUM_S{1,2}_MG{A,B} | Y | PRICE_TYPE.02 |
| PRF_NAMECARD_PREMIUM_FOIL | 5 | COMP_FOIL_SETUP_SMALL | Y | PRICE_TYPE.03 |
| PRF_NAMECARD_PREMIUM_FOIL | 6 | COMP_FOIL_PROC_SMALL_STD | Y | PRICE_TYPE.03 |
| PRF_NAMECARD_PREMIUM_FOIL | 7 | COMP_FOIL_PROC_SMALL_SPECIAL | Y | PRICE_TYPE.03 |
| PRF_NAMECARD_PREMIUM_FOIL | 8~10 | COMP_PP_VARTEXT/VARIMG/CORNER_RIGHT | Y | — |

### [formula-PRF_NAMECARD_PREMIUM] 프리미엄명함 등급가(용지포함·박 미선택) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_PREMIUM
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_PREMIUM (7 구성요소)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000031,PRF_NAMECARD_PREMIUM) note:'§29 배선교정 260630 — 프리미엄 등급가(견적0 해소)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S1_MGA, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S1_MGB, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S2_MGA, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S2_MGB, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARTEXT_1EA, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARIMG_1EA, qualifier: {disp_seq: 6, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_CORNER_RIGHT, qualifier: {disp_seq: 7, addtn: Y}}
- props: {archetype: "고정가(등급가)", note: "031 프리미엄명함 기본 바인딩·등급 A/B×단/양면 4단가표 + 가변2 + 귀돌이. 배선교정 260630(견적0 해소)"}

### [formula-PRF_NAMECARD_PREMIUM_FOIL] 프리미엄명함 등급가+박 분기 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_PREMIUM_FOIL
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_PREMIUM_FOIL (10 구성요소)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000031,PRF_NAMECARD_PREMIUM_FOIL) note:'§29 배선교정 260630 — 프리미엄 박분기'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S1_MGA, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S1_MGB, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S2_MGA, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PREMIUM_S2_MGB, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_SETUP_SMALL, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_SMALL_STD, qualifier: {disp_seq: 6, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_SMALL_SPECIAL, qualifier: {disp_seq: 7, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARTEXT_1EA, qualifier: {disp_seq: 8, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARIMG_1EA, qualifier: {disp_seq: 9, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_CORNER_RIGHT, qualifier: {disp_seq: 10, addtn: Y}}
- props: {archetype: "고정가(등급가)+박", note: "031 박(박칼라) 선택 시 재바인딩·등급가 4 + 소형 동판셋업/일반박/특수박 3 + 가변2 + 귀돌이. 027 대형박(FOIL_*_LARGE)과 달리 명함=소형박(FOIL_*_SMALL)"}

---

## 가격구성요소 (price_component) — 프리미엄 등급가 4 + 소형박 3 (공유 digital-components.md에 없음)

use_dims = 가격이 어떤 축으로 달라지는가(차원 선언)까지만 — 값 계산은 evaluate_price 권위(D-18·
단가행은 D-22로 접음). 등급가(S1/S2 × MGA/MGB)는 소재·인쇄면·수량 단가표(용지포함·PRC_COMPONENT_TYPE.06).
소형박은 동판셋업(1회 고정) + 가공비(일반박/특수박 분기·면적×수량).

<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components @ 2026-07-03 -->
| comp_cd | comp_nm | prc_typ | use_dims |
|---|---|---|---|
| COMP_NAMECARD_PREMIUM_S1_MGA | 프리미엄명함A 완제품가 단면(용지포함) | PRICE_TYPE.02 | ["mat_cd","print_opt_cd","min_qty"] |
| COMP_NAMECARD_PREMIUM_S1_MGB | 프리미엄명함B 완제품가 단면(용지포함) | PRICE_TYPE.02 | ["mat_cd","print_opt_cd","min_qty"] |
| COMP_NAMECARD_PREMIUM_S2_MGA | 프리미엄명함A 완제품가 양면(용지포함) | PRICE_TYPE.02 | ["mat_cd","print_opt_cd","min_qty"] |
| COMP_NAMECARD_PREMIUM_S2_MGB | 프리미엄명함B 완제품가 양면(용지포함) | PRICE_TYPE.02 | ["mat_cd","print_opt_cd","min_qty"] |
| COMP_FOIL_SETUP_SMALL | 박·형압 동판셋업비(소형) | PRICE_TYPE.03 | ["proc_cd"] |
| COMP_FOIL_PROC_SMALL_STD | 박 가공비(소형·일반박) | PRICE_TYPE.03 | ["proc_cd","siz_width","siz_height","min_qty"] |
| COMP_FOIL_PROC_SMALL_SPECIAL | 박 가공비(소형·특수박) | PRICE_TYPE.03 | ["proc_cd","siz_width","siz_height","min_qty"] |

### [component-COMP_NAMECARD_PREMIUM_S1_MGA] 프리미엄명함A 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_PREMIUM_S1_MGA
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_PREMIUM_S1_MGA", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "print_opt_cd", "min_qty"]', role: "등급 A 지질·단면 완제품가(용지포함) 단가표"}

### [component-COMP_NAMECARD_PREMIUM_S1_MGB] 프리미엄명함B 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_PREMIUM_S1_MGB
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_PREMIUM_S1_MGB", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "print_opt_cd", "min_qty"]', role: "등급 B 지질·단면 완제품가(용지포함) 단가표"}

### [component-COMP_NAMECARD_PREMIUM_S2_MGA] 프리미엄명함A 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_PREMIUM_S2_MGA
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_PREMIUM_S2_MGA", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "print_opt_cd", "min_qty"]', role: "등급 A 지질·양면 완제품가(용지포함) 단가표"}

### [component-COMP_NAMECARD_PREMIUM_S2_MGB] 프리미엄명함B 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_PREMIUM_S2_MGB
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_PREMIUM_S2_MGB", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "print_opt_cd", "min_qty"]', role: "등급 B 지질·양면 완제품가(용지포함) 단가표"}

### [component-COMP_FOIL_SETUP_SMALL] 박·형압 동판셋업비(소형) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOIL_SETUP_SMALL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOIL_SETUP_SMALL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd"]', role: "소형 동판비 5000 고정·proc_cd 박선택 게이트(미선택 0)·.03 FLAT ×qty0·1회성"}

### [component-COMP_FOIL_PROC_SMALL_STD] 박 가공비(소형·일반박) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOIL_PROC_SMALL_STD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOIL_PROC_SMALL_STD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "siz_width", "siz_height", "min_qty"]', role: "소형 일반박(금/은/먹유광·동/적/청박) 가공비·면적×수량 매트릭스"}

### [component-COMP_FOIL_PROC_SMALL_SPECIAL] 박 가공비(소형·특수박) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOIL_PROC_SMALL_SPECIAL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOIL_PROC_SMALL_SPECIAL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "siz_width", "siz_height", "min_qty"]', role: "소형 특수박(백/홀로그램/트윙클) 가공비·면적×수량 매트릭스"}

<!-- 재사용(중복 신설 금지·L-3): component-COMP_PP_VARTEXT_1EA·COMP_PP_VARIMG_1EA·COMP_PP_CORNER_RIGHT = axis/../formula/digital-components.md 정의 · 위 두 공식의 has_component 엣지가 그 노드로 해소. -->

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): t_siz_sizes(SIZ_000009)·t_mat_materials(MAT_000102/124/351/353/357 +upr)·t_prc_price_formulas(PRF_NAMECARD_PREMIUM·_FOIL)·t_prc_formula_components(7+10 배선)·t_prc_price_components(등급가4·소형박3)·t_prd_product_price_formulas(PRD_000031 2공식 바인딩).
- 전사 스크립트: `_meta/scripts/transcribe_product_031.py`(cache/transcribed-031-260703.json) — 치수·자재사양·공식배선 전사(LLM 손전사 0).
- 형제 상품 companion 재사용: `product-027-nodes.md`(MAT_000108/347/348/349/350/123/356·PROC_000037~044)·`axis/materials.md`(MAT_000101/109)·`formula/digital-components.md`(COMP_PP_*).
