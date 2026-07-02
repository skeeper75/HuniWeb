<!-- companion nodes for product-034 펄명함 — 공유 축 노드(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(master-id 사용). -->
<!-- ★박색 8자식 공정(PROC_000037~044)은 product-027-nodes.md가 이미 노드화 → 여기 중복 신설 금지(L-3). 034는 참조만. -->
<!-- ★수치(사양·use_dims·배선)는 전사 스크립트 transcribe_product_034.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->
<!-- ★향후 공유 축(axis/materials.md·formula/*)으로 이관 가치 있음 → needed_shared_nodes로 반환(통합 단계 승격). -->

# product-034 전용 노드 (펄명함 — 상품 전용 마스터 축)

[[product-034-pearl-namecard]]가 연결하는 축 중, 디지털 파일럿 공유 축(axis/*·formula/*)에 아직
없는 것만 신설한다. 공유에 있는 것(명함 사이즈 SIZ_000008·국전 판형·POPT_000001/002·모서리
PROC_000027/028·박색 8자식 PROC_000037~044[027-nodes 정의])은 재사용하고 여기 중복 신설하지 않는다.

---

## 자재 (material) — 스타드림 펄 4종 (공유 axis/materials.md에 없음)

자재 모델 = parent(MAT_000127 스타드림 계열) + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). 규격/평량이
"?"인 것은 **마스터 t_mat_materials에 사양 미기재**(전사 결과 그대로·날조 금지·채움은 실무진 소관).
평량 240g은 자재명에만 있고 weight 컬럼은 공란이다. ★이 4종은 2026-06-26 "자재 collapse 해소
(4종 전개)"로 등록된 펄 완제품 가격 차원(use_dims mat_cd)의 실제 값이다([[#DEC_pearl034_material_260630]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | upr | 규격(mm) | 평량(g) |
|---|---|---|---|---|---|
| MAT_000352 | 스타드림(다이아몬드) 240g | MAT_TYPE.01 | MAT_000127 | ?x? | ? |
| MAT_000358 | 스타드림(실버) 240g | MAT_TYPE.01 | MAT_000127 | ?x? | ? |
| MAT_000359 | 스타드림(골드) 240g | MAT_TYPE.01 | MAT_000127 | ?x? | ? |
| MAT_000360 | 스타드림(로즈쿼츠) 240g | MAT_TYPE.01 | MAT_000127 | ?x? | ? |

### [material-MAT_000352] 스타드림(다이아몬드) 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000352
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000352", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000127", 사양_ref: "전사표 MAT_000352", note: "펄지(스타드림)·규격/평량 마스터 미기재(전사 ?)·평량 240g은 자재명 기재"}

### [material-MAT_000358] 스타드림(실버) 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000358
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000358", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000127", 사양_ref: "전사표 MAT_000358", note: "펄지(스타드림)·규격/평량 마스터 미기재(전사 ?)"}

### [material-MAT_000359] 스타드림(골드) 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000359
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000359", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000127", 사양_ref: "전사표 MAT_000359", note: "펄지(스타드림)·규격/평량 마스터 미기재(전사 ?)"}

### [material-MAT_000360] 스타드림(로즈쿼츠) 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000360
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000360", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000127", 사양_ref: "전사표 MAT_000360", note: "펄지(스타드림)·규격/평량 마스터 미기재(전사 ?)"}

---

## 가격구성요소 (price_component) — 펄 완제품가 2종 신설 (+박 소형 3종=031 재사용)

펄 완제품가(S1 단면·S2 양면)는 **고정가(용지포함)** — use_dims=`[mat_cd, min_qty, print_opt_cd]`
(자재·수량·단/양면). 박 소형 구성요소는 박 분기 공식이 배선하며 proc_cd 게이트(박 미선택 0)로
동작한다. ★use_dims 차원 선언까지만 — 값 계산은 evaluate_price 권위(D-18·단가행은 D-22로 접음).
027 접지카드는 **대형**(FOIL_*_LARGE)을 쓰고, 명함은 **소형**(FOIL_*_SMALL)을 쓴다(별개 노드).

<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components @ 2026-07-03 -->
| comp_cd | comp_nm | prc_typ | use_dims |
|---|---|---|---|
| COMP_NAMECARD_PEARL_S1 | 펄명함(스타드림) 완제품가 단면(용지포함) | PRICE_TYPE.02 | ["mat_cd", "min_qty", "print_opt_cd"] |
| COMP_NAMECARD_PEARL_S2 | 펄명함(스타드림) 완제품가 양면(용지포함) | PRICE_TYPE.02 | ["mat_cd", "min_qty", "print_opt_cd"] |
| COMP_FOIL_SETUP_SMALL | 박·형압 동판셋업비(소형) | PRICE_TYPE.03 | ["proc_cd"] |
| COMP_FOIL_PROC_SMALL_STD | 박 가공비(소형·일반박) | PRICE_TYPE.03 | ["proc_cd", "siz_width", "siz_height", "min_qty"] |
| COMP_FOIL_PROC_SMALL_SPECIAL | 박 가공비(소형·특수박) | PRICE_TYPE.03 | ["proc_cd", "siz_width", "siz_height", "min_qty"] |

### [component-COMP_NAMECARD_PEARL_S1] 펄명함 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_PEARL_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_PEARL_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "min_qty", "print_opt_cd"]', role: "단면 펄명함 완제품가(용지 포함)·소재·수량 합산 1건당 단가표"}

### [component-COMP_NAMECARD_PEARL_S2] 펄명함 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_PEARL_S2
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_PEARL_S2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "min_qty", "print_opt_cd"]', role: "양면 펄명함 완제품가(용지 포함)"}

<!-- ★박 소형 3종(COMP_FOIL_SETUP_SMALL·COMP_FOIL_PROC_SMALL_STD·COMP_FOIL_PROC_SMALL_SPECIAL)은
     형제 상품 product-031-premium-namecard-nodes.md가 이미 노드화(소형 명함+박 공유) → 중복 신설 금지(L-3).
     034 PRF_NAMECARD_PEARL_FOIL의 has_component 엣지가 그 노드로 resolve. 위 전사표는 use_dims 참조용(문서).
     ★이 3종은 031/034 공유 → 향후 공유 formula/digital-components.md로 승격 가치(needed_shared_nodes 반환). -->

---

## 가격공식 (price_formula) — 펄명함 고정가 + 박 분기

펄명함은 **두 공식**에 바인딩된다: PRF_NAMECARD_PEARL(박 미선택·펄 완제품가 단/양면)와
PRF_NAMECARD_PEARL_FOIL(박 선택 시 재바인딩). FOIL 분기는 펄 공식에 박 소형 3구성요소
(동판셋업 소형 + 일반박 + 특수박)를 더한 형태다(027 대형 박 분기와 동형·소형 변형).
★값 계산은 evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]). 골든은 날짜 라벨로만.

<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components @ 2026-07-03 -->
| frm_cd | disp_seq | comp_cd | addtn |
|---|---|---|---|
| PRF_NAMECARD_PEARL | 1 | COMP_NAMECARD_PEARL_S1 | Y |
| PRF_NAMECARD_PEARL | 2 | COMP_NAMECARD_PEARL_S2 | Y |
| PRF_NAMECARD_PEARL_FOIL | 1 | COMP_NAMECARD_PEARL_S1 | Y |
| PRF_NAMECARD_PEARL_FOIL | 2 | COMP_NAMECARD_PEARL_S2 | Y |
| PRF_NAMECARD_PEARL_FOIL | 3 | COMP_FOIL_SETUP_SMALL | Y |
| PRF_NAMECARD_PEARL_FOIL | 4 | COMP_FOIL_PROC_SMALL_STD | Y |
| PRF_NAMECARD_PEARL_FOIL | 5 | COMP_FOIL_PROC_SMALL_SPECIAL | Y |

### [formula-PRF_NAMECARD_PEARL] 펄명함 고정가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_PEARL
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_NAMECARD_PEARL frm_nm:펄명함(스타드림) 면/소재/수량별 단가(용지포함)·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_PEARL (2 구성요소 S1/S2)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PEARL_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PEARL_S2, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가(용지포함)", note: "가격표260527 B04. 자재 collapse 해소(4종 전개) 후 바인딩. 단/양면 완제품가 단가표(값=evaluate_price)"}

### [formula-PRF_NAMECARD_PEARL_FOIL] 펄명함 고정가+박 분기 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_PEARL_FOIL
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_NAMECARD_PEARL_FOIL frm_nm:펄명함 면/소재/수량별 단가(용지포함)+박·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_PEARL_FOIL (5 구성요소)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PEARL_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_PEARL_S2, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_SETUP_SMALL, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_SMALL_STD, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_SMALL_SPECIAL, qualifier: {disp_seq: 5, addtn: Y}}
- props: {archetype: "고정가+박 분기", note: "PRF_NAMECARD_PEARL 클론+박 소형 3comp 분기(034 전용·공유공식 형제 미영향·search-before-mint). 박 미선택 시 소형 comp proc_cd 게이트로 0"}

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): t_mat_materials(MAT_000352/358/359/360)·t_prc_price_components(COMP_NAMECARD_PEARL_S1/S2·COMP_FOIL_*_SMALL 3)·t_prc_price_formulas(PRF_NAMECARD_PEARL·_FOIL)·t_prc_formula_components(PEARL 2행·PEARL_FOIL 5행).
- 수치 전사: `_meta/scripts/transcribe_product_034.py`(cache/transcribed-034-260703.json).
- 형제 재사용(중복 신설 안 함): 박색 8자식 공정 process-PROC_000037~044 = product-027-nodes.md 정의.
