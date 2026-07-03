<!-- companion nodes for product-119 아트페이퍼포스터 — 공유 축(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(023/051/052 방식). -->
<!-- ★실사(silsa) 첫 상품이라 실사 공유 축(카테고리 포스터/아트포스터·매트지 자재·면적매트릭스 공식 PRF_POSTER_ARTPAPER·구성요소 COMP_POSTER_ARTPAPER_MATTE·A3/A2/A1 사이즈·파일사양 출력규격)은 여기 mint→needed_shared_nodes로 반환(향후 실사 상품군 승격 후보). -->
<!-- ★수치(치수·사양·단가행수·배선)는 전사 스크립트 transcribe_product_119.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-119 전용 노드 (아트페이퍼포스터 — 실사 첫 상품 전용 마스터 축)

[[product-119-artpaper-poster]]가 연결하는 축은 실사 첫 상품이라 디지털/스티커 공유 축(axis/*·
formula/*)에 대응 노드가 없다. 전 축을 여기 상품-local로 신설하고 `needed_shared_nodes`로 반환한다
(실사 2번째 상품 집필 시 이 축들을 공유 축으로 승격·canonical id 그대로).

---

## 카테고리 (category) — 실사 전용 2행 (공유 축 미등재 → 승격 후보)

### [category-CAT_000004] 포스터 (실사 주 카테고리·root) {verified}
- type: category
- anchor: t_cat_categories/CAT_000004
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000004 cat_nm=포스터·cat_lvl=1·upr_cat_cd 공백(root)·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000119,CAT_000004) main_cat_yn=Y·disp_seq=7", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "포스터", cat_lvl: "1", note: "아트페이퍼포스터 주 카테고리(main_cat_yn=Y). round-13 'CAT_000298 고아'는 해소됨(pack §1.1·T-1). 실사 공유 축 미등재 — 단일 소비자 임시 거처·2번째 실사 상품 집필 시 axis/categories.md 승격(needed_shared·owner=architect)"}

### [category-CAT_000314] 아트포스터 (실사 leaf 카테고리·신규 노드) {verified}
- type: category
- anchor: t_cat_categories/CAT_000314
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000314 cat_nm=아트포스터·cat_lvl=2·upr_cat_cd=CAT_000004·reg 06-19·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000119,CAT_000314) main_cat_yn=N·reg 06-19", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "아트포스터", cat_lvl: "2", upr_cat_cd: "CAT_000004", note: "leaf 카테고리(2026-06-19 신규·CAT_000004 포스터 자식). pack §1.1 카테고리 재연결 신규 노드(314/315)와 정합. 단일 소비자·승격 대기"}

---

## 사이즈 (size) — 이산 규격(재단) 3행 (A3/A2/A1)

> ★재사용(중복 mint 금지): A3 `size-SIZ_000174`는 이미 [[product-047-small-flyer]](전단지 A3)가,
> A2 `size-SIZ_000197`은 이미 [[axis/sizes]](스티커 055 승격)가 선언한 **기존 노드**라 여기 재선언하지
> 않고 has_size 엣지로 참조만 한다(같은 anchor t_siz_sizes/SIZ_000174·197·물리 규격 동일). A1
> `size-SIZ_000293`만 실사 전용 신규 선언(마스터 삭제 정합 신호 포함).

### [size-SIZ_000293] A1 594x841 (아트페이퍼포스터 재단·★마스터 삭제) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000293
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000293 siz_nm=A1(594x841mm)·work/cut 594x841·★del_yn=Y(2026-06-17 삭제)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000119,SIZ_000293) dflt_yn=Y·disp_seq=1·del_yn=N(junction 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000293(A1 594x841)", master_del_yn: "Y", note: "★마스터 t_siz_sizes del_yn=Y지만 상품 사이즈 junction은 활성(del_yn=N)·출력측 SIZ_000294(A1 파일사양) 활성. 정합 미상→[[gap-119-a1-master-deleted]]. 노드 자체는 라이브 실재라 verified(정합 판정은 GAP)"}
- rel: {rel: references, target: gap-119-a1-master-deleted, note: "이 사이즈의 마스터 삭제 정합 미상"}

---

## 자재 (material) — 실사 전용 1종 (매트지·MAT_TYPE.08 실사소재)

### [material-MAT_000177] 매트지 (아트페이퍼포스터 본체 소재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000177
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000177 mat_nm=매트지·mat_typ_cd=MAT_TYPE.08(실사소재)·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000119,MAT_000177) usage_cd=USAGE.07·dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 자재(parent+usage_cd·USAGE.07)·T-2(MAT_TYPE 코드 개편·매트지는 교정 목록 밖=.08 유지 정합)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_typ_cd: "MAT_TYPE.08", usage_cd: "USAGE.07", note: "아트페이퍼=매트지 소재(comp도 ..._MATTE). MAT_TYPE.08(실사소재)=현재값·매트지는 자재유형 교정 대상(레더/린넨/캔버스/타이벡→.05) 밖이라 .08 유지 정합(pack §3.5). ★[HARD] IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]). 단일 소비자·승격 대기"}

---

## 판형(파일사양) (plate_size) — 실사=파일 출력규격(★종이류 절수 판형 아님·T-7)

> ★이 3노드는 `output_file_typ=JPG` 파일 출력규격이지 종이류 절수 전지 판형이 아니다
> (`output_paper_typ_cd` 공백·pack §3.8·T-7). 실사=대형 롤 → `fn_best_plate` 절수 자동선택·
> `fn_calc_pansu` 판걸이수 **미적용**([[rule/rules#RULE_plate_paper_only]]). 스티커/디지털 판형 SOT
> 이식 금지. junction 앵커 규약(schema §1.0)=부모 prd_cd 앵커 + sources 복합키 확증.

### [plate-119-SIZ_000052] A3 파일사양 출력(JPG) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000119
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000119,SIZ_000052) output_paper_typ_cd=공백·output_file_typ=JPG·dflt_plt_yn=Y·note=파일사양·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000052", output_paper_typ_cd: "(공백)", output_file_typ: "JPG", note: "★파일 출력규격(A3)·종이류 절수 판형 아님(실사=대형 롤·T-7). output_paper_typ_cd 공백 → fn_best_plate/fn_calc_pansu 미적용(pack §3.8). 승격 대기"}

### [plate-119-SIZ_000198] A2 파일사양 출력(JPG) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000119
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000119,SIZ_000198) output_paper_typ_cd=공백·output_file_typ=JPG·dflt_plt_yn=Y·note=파일사양·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000198", output_paper_typ_cd: "(공백)", output_file_typ: "JPG", note: "★파일 출력규격(A2)·종이류 절수 판형 아님(T-7). 승격 대기"}

### [plate-119-SIZ_000294] A1 파일사양 출력(JPG) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000119
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000119,SIZ_000294) output_paper_typ_cd=공백·output_file_typ=JPG·dflt_plt_yn=Y·note=파일사양·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000294", output_paper_typ_cd: "(공백)", output_file_typ: "JPG", note: "★파일 출력규격(A1·활성)·종이류 절수 판형 아님(T-7). 재단측 A1(SIZ_000293)은 마스터 삭제([[gap-119-a1-master-deleted]])이나 출력측 A1(SIZ_000294)은 활성. 승격 대기"}

---

## 수량규칙 (bundle_qty) — 상품 레벨

### [qty-119] 아트페이퍼포스터 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000119
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000119 min_qty/max_qty/qty_incr(1/1000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 수량(면적매트릭스 13상품 수량축 없음·매트릭스 셀=완제품 통가격)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {min_max_incr_ref: "본문 전사표(min 1·max 1000·incr 1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★상품레벨 수량규칙만(t_prd_product_bundle_qtys 0행). ★면적매트릭스 가격은 수량 무관(셀=완제품 통가격·pack §3.4). pack은 min_qty=NULL을 기대하나 라이브 현재값=1(QTY_UNIT.01)·가격격자에 영향 없음(수량축 아님)"}

---

## 가격공식·구성요소 (실사 첫 상품 — 상품-local mint·needed_shared_node)

> 실사 = 면적매트릭스형(원자합산형/고정룩업과 다른 3번째 아키타입·pack §3.10). 디지털 공유 공식
> (PRF_DGP_*)·스티커 공식(PRF_STK_FIXED)과 다르므로 실사 전용 공식/구성요소를 여기 신설(면적 13상품이
> 향후 공유할 승격 후보).

### [formula-PRF_POSTER_ARTPAPER] 아트페이퍼포스터 완제품가 (면적매트릭스형) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ARTPAPER
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_ARTPAPER frm_nm=아트페이퍼포스터 완제품가(면적/규격 단가)·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000119,PRF_POSTER_ARTPAPER) apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "키:(PRF_POSTER_ARTPAPER,COMP_POSTER_ARTPAPER_MATTE) disp_seq 1·addtn_yn Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 면적매트릭스형 13상품 B02 아트페이퍼119·off-grid=한단계 큰 규격 ceiling·inline price 가격권위 아님", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {archetype: "면적매트릭스형([가로×세로] 셀단가 룩업·off-grid ceiling)", use_yn: "Y", note: "포스터사인 소재/사이즈별 완제품 통가격·도수/자재/코팅면/묶음/수량 무관(코팅포함 통가격). 원자합산형(PRF_DGP_*)·고정룩업(PRF_STK_FIXED)과 다른 3번째 아키타입·값 계산=evaluate_price 권위(D-18)·needed_shared_node"}
- rel: {rel: has_component, target: component-COMP_POSTER_ARTPAPER_MATTE, note: "면적매트릭스 셀단가(disp_seq 1·addtn Y)"}
- 본문: PRF_POSTER_ARTPAPER = 아트페이퍼포스터 완제품가를 [가로×세로] 면적 격자에서 통째 룩업. has_component 1개(COMP_POSTER_ARTPAPER_MATTE) → 고아 공식 아님(O6). off-grid(격자에 없는 치수)는 각 축 한 단계 큰 규격으로 ceiling(앱 계산·pack §3.10). 값은 엔진.

### [component-COMP_POSTER_ARTPAPER_MATTE] 실사 완제품가 (아트페이퍼포스터·면적매트릭스) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_ARTPAPER_MATTE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_ARTPAPER_MATTE comp_nm=실사 완제품가(아트페이퍼포스터)·prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[siz_width,siz_height]·note=가격축 가로×세로 구간(39셀)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices 필터:comp_cd=COMP_POSTER_ARTPAPER_MATTE — 39셀(고유 (siz_width,siz_height) 순서쌍 39·가로 600~900·세로 600~3000·전사표 행수요약·값 미나열 D-22)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.2 B02 아트페이퍼119↔COMP_POSTER_ARTPAPER·매트릭스 비대칭((가로,세로) 순서쌍 고유)·off-grid ceiling", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "전사표 [siz_width, siz_height]", rows_ref: "전사표 행수요약(39셀·D-22 접기·값 나열 아님)", note: "면적매트릭스 완제품가(코팅포함 통가격)·매트릭스 비대칭((600×1000) 셀 ≠ (1000×600) 셀·각 고유)·연당가(원가) 아님·needed_shared_node"}
- 본문: use_dims=[siz_width, siz_height] 차원 선언까지가 온톨로지 경계(값·off-grid ceiling 계산=evaluate_price·[[rule/rules#RULE_price_value_boundary]]). 단가행(39셀)은 노드로 펼치지 않고 이 노드 속성/행수로 접는다(D-22·아크릴 면적매트릭스 적재구조와 동형=`_workspace/huni-dbmap/09_load/_migrate_areamatrix`). 39 (가로,세로) 순서쌍 전부 단가행 실재 → 가격 사슬 충전(견적 산출 가능).

---

## 정직 GAP (원천 부재·정합 미상)

### [gap-119-a1-master-deleted] A1 사이즈 마스터 삭제 정합 미상 {unknown}
- type: gap
- anchor: none  # 사유: SIZ_000293(A1) 마스터 del_yn=Y지만 상품 사이즈 junction 활성·출력측 SIZ_000294(A1) 활성 — 정답 상태(유지/제거/재키잉)를 단정할 권위 원천 없음
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000293 del_yn=Y(2026-06-17 삭제)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000119,SIZ_000293) del_yn=N(junction 활성)·출력측 (PRD_000119,SIZ_000294) 활성(파일사양 A1)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "아트페이퍼포스터 A1 재단 규격 SIZ_000293 마스터가 논리삭제(del_yn=Y·06-17)됐는데 상품 사이즈 junction은 여전히 활성(del_yn=N)이다. 출력측은 별도 SIZ_000294(A1 파일사양)가 활성 → A1이 재키잉 이관 중인지, junction 정리 누락인지, 손님 A1 선택 가능 상태인지 정답 미상(권위 엑셀 260702에 실사 사이즈 정답 격자 원천 부재)"
- gap_fill_from: "① live t_prd_product_sizes junction 정리 여부 개발팀 확인(마스터 삭제 시 junction 동반 논리삭제 규칙) ② 실사 사이즈 정답은 pack §3.2 correction-manifest C-02(size CORRECT) 재실측 + 실무진(A1 출시 규격 여부). 그 전까지 A1 선택가능성 단정 금지"
- gap_owner: dev
- rel: {rel: derived_from, target: size-SIZ_000293, note: "이 A1 사이즈의 마스터 삭제 정합"}

### [gap-119-offgrid-golden] 면적매트릭스 off-grid ceiling + 절대 셀단가 골든 미검증 {unknown}
- type: gap
- anchor: none  # 사유: off-grid ceiling 계산·절대 셀단가는 evaluate_price 소관(KB 밖)이고, 실사 롤 소재 가격 로직은 엑셀 미기재 암묵지 — 대조할 골든 정답 원천 부재
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_ARTPAPER_MATTE 39셀(가로 600~900·세로 600~3000·명시 격자)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 GAP(롤 소재 가격 계산 로직 엑셀 미기재 암묵지·실사 전체 영향)·off-grid=한단계 큰 규격 ceiling(앱)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "① 명시 격자(39셀)에 없는 치수(off-grid·예: 가로 250·세로 1500 등 nonspec 입력)의 ceiling 결과 셀·최종가는 evaluate_price 앱 계산이라 KB 밖(D-18) ② 실사 대형 롤 소재의 가격 계산 로직(면적·롤폭 손실 등)은 권위 엑셀에 미기재된 암묵지(source-registry §9 GAP-2·실사 전체 영향) — 절대 셀단가·off-grid 결과의 골든 대조 원천이 없음"
- gap_fill_from: "① off-grid ceiling·최종가는 예전사이트/시뮬레이터 골든 대조(§27 가격 종단·개발팀) ② 롤 소재 가격 로직 암묵지는 실무진 확인(엑셀 미기재). 그 전까지 절대값 단정 금지(use_dims 차원 선언까지가 KB 경계)"
- gap_owner: dev
- rel: {rel: references, target: component-COMP_POSTER_ARTPAPER_MATTE, note: "이 구성요소의 셀단가·off-grid 골든 미검증"}
