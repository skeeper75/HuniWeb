<!-- formula page: E9 price_formula — 스티커 완제품가 공식(고정가/합가 룩업). 1 파일 = N 블록(### [id]). -->
<!-- 파싱: file-format-spec §1.2·graph-build §3.1. 값 없음(단가행=D-22 접기·구성요소 노드에). -->

# 축: 스티커 가격공식 (price_formula)

스티커 = 완제품가 룩업(원자합산형 아님·팩 §3.10). 디지털 공유공식(PRF_DGP_*)과 별개.
상품→공식(R8 `priced_by`)은 상품 노드가 건다. 여기서는 공식 노드만 단일 선언(16 스티커 공용).
각 공식 has_component(R9)→formula/sticker-components.md 구성요소.


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [formula-PRF_GANGPAN_FIXED] 합판도무송 사이즈/소재/수량별 단가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_GANGPAN_FIXED
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_GANGPAN_FIXED (use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components frm_cd:PRF_GANGPAN_FIXED (1구성요소·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "고정가형(완제품가 룩업)", use_yn: "Y", note: "합판도무송 단가=수량×(사이즈·소재) 표 조회(마스터 note)·원자합산 아님·값=evaluate_price 권위"}
- rel: {rel: has_component, target: component-COMP_GANGPAN_PRINT, note: "완제품가 단일 구성요소(disp_seq 1·addtn Y)"}

### [formula-PRF_STK_FIXED] 스티커 완제품가 고정가 룩업형 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STK_FIXED
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000052,PRF_STK_FIXED) note:반칼 자유형 스티커→규격/소재/수량 단가", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_STK_FIXED,COMP_STK_PRINT) disp_seq 1·addtn_yn Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "완제품가 고정가 룩업(고정가 by siz×mat×qty)", note: "원자합산형 아님·소재 연당가 미포함·값 계산=evaluate_price 권위(D-18)·needed_shared_node"}
- rel: {rel: has_component, target: component-COMP_STK_PRINT, note: "완제품가 격자(disp_seq 1·addtn Y)"}
- 본문: PRF_STK_FIXED = 스티커 완제품가(출력+가공 포함)를 (사이즈·소재·수량) 격자에서 통째 룩업. has_component 1개(COMP_STK_PRINT) → 고아 공식 아님(O6). 값은 엔진.

### [formula-PRF_STK_PACK] 스티커팩 합가형 (54장1세트 4000) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STK_PACK
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STK_PACK(frm_nm=스티커팩 합가형(54장1세트 4000)·use_yn=Y·2026-06-17 mint)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000065,PRF_STK_PACK) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "키:(PRF_STK_PACK,COMP_STK_PACK) disp_seq=1 addtn_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "완제품가 합가형 고정가 룩업", use_yn: "Y", note: "PRF_STK_FIXED(자유형 6,498행 룩업)과 다른 합가형 공식 — 54장1세트를 통째 4,000원에 룩업. 값 계산=evaluate_price 권위(D-18). 공유 formula/ 미등재·승격 대기(needed_shared·팩류 승계 후보)"}
- rel: {rel: has_component, target: component-COMP_STK_PACK, qualifier: {disp_seq: 1, addtn: Y}, note: "팩 완제품가(합가형·유일 구성요소)"}
- 본문: 스티커팩 완제품가를 결정하는 합가형 공식([[sticker-pack]] priced_by). has_component 1개=COMP_STK_PACK(고아 공식 아님·O6 충족). 원자합산 아님 — 세트가를 통째 룩업.

### [formula-PRF_STK_TATTOO] 타투스티커 완제품가 합가형 룩업 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STK_TATTOO
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000067,PRF_STK_TATTOO) apply_bgn_ymd 2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_STK_TATTOO,COMP_STK_TATTOO) disp_seq 1·addtn_yn Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "완제품가 합가형 룩업(3장세트 합산가 by siz×mat×qty)", note: "원자합산형 아님·소재 연당가 미포함·값 계산=evaluate_price 권위(D-18)·needed_shared_node"}
- rel: {rel: has_component, target: component-COMP_STK_TATTOO, note: "완제품가 격자(disp_seq 1·addtn Y)"}
- 본문: PRF_STK_TATTOO = 타투스티커 완제품가(출력 포함)를 (사이즈·소재·수량) 격자에서 통째 룩업. has_component 1개(COMP_STK_TATTOO) → 고아 공식 아님(O6). 값은 엔진.
