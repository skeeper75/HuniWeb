<!-- product-local sub-nodes: E3 size 4·E4 material 2·E8 bundle_qty·E9 price_formula·E10 price_component·E11 option_group·gap 4 for PRD_000142 유광아크릴스티커. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3·재정의 안 함·참조만): -->
<!--   - category-CAT_000005(사인·root) = 병렬 실사 빌더(143 미러아크릴·144 미니보드스탠딩)가 이미 정의 → 142는 in_category로 참조만(재정의 안 함·L-3 회피). needed_shared 반환. -->
<!--   - category-CAT_000092(시트커팅/스티커·leaf) = 140 무광시트커팅이 첫 정의(141 홀로그램·143 미러도) → 142는 참조만(재정의 안 함·L-3 회피). needed_shared 반환. -->
<!-- ★여기 정의(142 고유·타 빌더 미정의 or 첫 정의): size-SIZ_000324~327(아크릴스티커 규격·143 공유 후보 needed_shared)·material 2(화이트/블랙 .08)·qty·formula(PRF_POSTER_ACRYLSTK_GLOSS·needed_shared)·component(COMP_POSTER_ACRYLSTK_GLOSS·needed_shared)·option_group·gap 4. -->
<!-- ★needed_shared 반환: category-CAT_000005·category-CAT_000092(위 재사용)·size-SIZ_000324~327(142/143 아크릴스티커 규격·143 빌드 시 공유)·formula/component(실사 고정가 승격 후보). consolidation이 canonical 선정. -->
<!-- ★수치(사이즈·자재·격자 shape·수량)는 아래 전사표(transcribed-by·transcribe_product_142.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). 고정가 4셀 단가범위는 grid shape 증거만. -->

# product-142 하위 노드 (유광아크릴스티커 전용 축 원자 + 공식/옵션/GAP)

유광아크릴스티커(PRD_000142)가 쓰는 사인/시트커팅 카테고리·아크릴스티커 규격 4종·화이트/블랙 자재 2종·
색상 옵션그룹·가격공식·구성요소·수량규칙·GAP 4. 상품→축 연결(has_size·uses_material·has_option_group·
priced_by·has_qty_rule·in_category)은 [[product-142-glossy-acrylic-sticker]]가 건다. 공식→구성요소
배선(has_component)·옵션→자재 참조(option_refs)는 아래 formula/optgroup 블록.

## 상품 요소 전사표 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_142.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-142-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5)이라 라이브 현재값=권위 정합(값 양면 소재 없음). 단 자재 마스터 del·수량 공백·UV 공정은 GAP 표기.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000142 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | (공백) | (공백) | (공백) | QTY_UNIT.01 | Y | N | Y |

> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 4종만). ★min/max/qty_incr **전부 공백**(GAP-SL-8·제품 레벨 수량 미설정).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000092 | 시트커팅/스티커 | CAT_000005 | 2 | N |
| CAT_000005 | 사인 |  | 1 | Y |

### 사이즈 (전사·전 행·del 표기·nonspec_yn=N 이산 4종)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000324 | 290x90mm | 290x90 | Y | N | N |
| SIZ_000325 | 290x190mm | 290x190 | Y | N | N |
| SIZ_000326 | 390x290mm | 390x290 | Y | N | N |
| SIZ_000327 | 590x390mm | 590x390 | Y | N | N |

### 자재 (전사·화이트/블랙·MAT_TYPE.08 실사소재·★마스터 del_yn=Y 불일치)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|---|---|
| MAT_000255 | 화이트 | MAT_TYPE.08 | (없음) | USAGE.07 | Y | N | Y |
| MAT_000256 | 블랙 | MAT_TYPE.08 | (없음) | USAGE.07 | Y | N | Y |

> ★MAT_000255(화이트)·MAT_000256(블랙) 둘 다 **마스터 del_yn=Y**(06-16 논리삭제)인데 상품링크는 del_yn=N 활성 = 불일치(127 MAT_000188 선례·정직 관찰). 색상 CPQ 옵션이 이 두 자재를 참조.

### 공정 (전사·★0행 — 아크릴 UV PROC_000002 라우팅 미적재 GAP-SL-A)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| 공정 행수 | 0 |
|---|---|

> 아크릴스티커 인쇄방식=UV PROC_000002(레이저커팅 라인·pack §3.7)이나 라이브 공정 행 부재(실사 공통 proc=0·정당). GAP-SL-A(UV 라우팅 공정 행 추가 여부·영향 작음).

### 옵션 레이어 (전사·색상 CPQ 그룹·화이트/블랙→자재 참조)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items @ 2026-07-03 -->

옵션그룹 **OPT_000069** 색상 (sel=SEL_TYPE.01·min/max=1/1·mand=Y)

| opt_cd | 옵션값 | dflt | ref_dim_cd | ref_key1(자재) | ref_key2 | qty |
|---|---|---|---|---|---|---|
| OPV_000450 | 화이트 | Y | OPT_REF_DIM.03 | MAT_000255 | USAGE.07 | 1 |
| OPV_000451 | 블랙 | N | OPT_REF_DIM.03 | MAT_000256 | USAGE.07 | 1 |

> OPT_REF_DIM.03=자재 참조. 색상(화이트/블랙)이 자재 MAT_000255/256을 가리킴(R11 option_refs·부모 142 uses_material 실재). ★색상은 **가격 무관**(구성요소 use_dims=[siz_cd]에 mat_cd 없음·4셀 색상 불문 동일가).

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전부 del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000324 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000325 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000326 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000327 | (공백) | AI | Y | Y | 파일사양 |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 부모) | 0 |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_ACRYLSTK_GLOSS** — 유광아크릴스티커 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_ACRYLSTK_GLOSS | Y | PRICE_TYPE.01 | 유광아크릴스티커 완제품가 | `["siz_cd"]` |

### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)

<!-- transcribed-by: _meta/scripts/transcribe_product_142.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_ACRYLSTK_GLOSS 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 사이즈축(개수) | mat축 | 수량축 | 셀존재 | 단가범위(shape) | use_dims |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_ACRYLSTK_GLOSS | Y | 4 | 4(SIZ_000324/SIZ_000325/SIZ_000326/SIZ_000327) | NULL(색상무관) | NULL(수량무관) | 4/4 | 9000~37000 | `["siz_cd"]` |

> ★use_dims=[siz_cd] **단일축** 룩업: 사이즈 4종 = 4셀(각 규격 1행·색상/수량 무관·mat_cd·min_qty 전부 NULL).
> 격자완전(유효 4/4·규격당 1셀). 총액=셀단가×수량(수량구간 할인 없음·t_dsc 0행).
> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).

## 카테고리 노드 (★재사용 — 재정의 안 함·L-3 회피·needed_shared)

<!-- ★category-CAT_000005(사인·root) = 병렬 실사 빌더 143 미러아크릴스티커·144 미니보드스탠딩이 이미 정의 → 142는 -->
<!-- in_category→category-CAT_000005로 참조만(재정의 금지·L-3 중복 회피). live: (PRD_000142,CAT_000005) main_cat_yn=Y·disp_seq=8(142 주 분류). -->
<!-- ★category-CAT_000092(시트커팅/스티커·leaf·upr=CAT_000005) = 140 무광시트커팅이 첫 정의(141/143도) → 142 참조만. -->
<!-- live: (PRD_000142,CAT_000092) main_cat_yn=N(142 보조 분류). needed_shared 반환(consolidation이 143/144/140 중 canonical 선정·axis/categories.md 승격). -->
<!-- ★142 주 분류가 root 사인(main_cat_yn=Y)임에 유의 — 130 포맥스(포스터 004 하위)와 다른 사인(005) 계열. -->

## 사이즈 노드 (product-local — 아크릴스티커 규격 4종·needed_shared·143 공유 후보)

<!-- ★SIZ_000324~327 = 아크릴스티커 전용 규격(tags=["아크릴스티커"])·142/143 공유 후보 → 142 첫 정의(needed_shared). nonspec_yn=N이라 이산 규격만. 수치는 위 전사표 권위(props raw 치수 미기입·D-9). -->

### [size-SIZ_000324] 290x90mm (아크릴스티커 규격) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000324
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000324(siz_nm=290x90mm·work=cut 290x90·tags=아크릴스티커·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000142,SIZ_000324) dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000324", note: "아크릴스티커 최소 규격·고정가 룩업 (siz_cd) 1셀. needed_shared(143 공유 후보)"}
- 본문: 유광아크릴스티커 규격(290×90mm·작업=재단 동일). 고정가 룩업 use_dims=[siz_cd]의 siz_cd 축 1값. [[product-142-glossy-acrylic-sticker]] has_size 대상.

### [size-SIZ_000325] 290x190mm (아크릴스티커 규격) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000325
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000325(siz_nm=290x190mm·work=cut 290x190·tags=아크릴스티커·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000142,SIZ_000325) dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000325", note: "고정가 룩업 (siz_cd) 1셀. needed_shared(143 공유 후보)"}
- 본문: 유광아크릴스티커 규격(290×190mm). 고정가 룩업 siz_cd 축 1값. [[product-142-glossy-acrylic-sticker]] has_size 대상.

### [size-SIZ_000326] 390x290mm (아크릴스티커 규격) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000326
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000326(siz_nm=390x290mm·work=cut 390x290·tags=아크릴스티커·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000142,SIZ_000326) dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000326", note: "고정가 룩업 (siz_cd) 1셀. needed_shared(143 공유 후보)"}
- 본문: 유광아크릴스티커 규격(390×290mm). 고정가 룩업 siz_cd 축 1값. [[product-142-glossy-acrylic-sticker]] has_size 대상.

### [size-SIZ_000327] 590x390mm (아크릴스티커 규격·최대) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000327
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000327(siz_nm=590x390mm·work=cut 590x390·tags=아크릴스티커·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000142,SIZ_000327) dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000327", note: "아크릴스티커 최대 규격·고정가 룩업 (siz_cd) 1셀(최고가 37000 shape). needed_shared(143 공유 후보)"}
- 본문: 유광아크릴스티커 최대 규격(590×390mm). 고정가 룩업 siz_cd 축 1값. [[product-142-glossy-acrylic-sticker]] has_size 대상.

## 자재 노드 (product-local — 화이트/블랙·MAT_TYPE.08 실사소재·★마스터 del_yn=Y 불일치)

<!-- ★142 자재=화이트/블랙(MAT_TYPE.08 실사소재·정당·코드개편 후에도 유효). 실사 팩이 경고한 레더 MAT_000186 .08→.05 crosscut과 무관(레더=100/126/296/298 횡단·pack §1.1·T-2). -->
<!-- ★[정직 관찰] 두 자재 마스터 del_yn=Y(06-16)인데 상품링크·색상옵션 참조는 활성 → 불일치(127 MAT_000188 선례). gap-142-color-material-deleted에서 정직 선언. IMPORT 자재 삭제 금지. -->

### [material-MAT_000255] 화이트 (아크릴스티커 색상·실사소재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000255
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000255(mat_nm=화이트·mat_typ_cd=MAT_TYPE.08·upr_mat_cd=(없음)·★del_yn=Y 06-16 논리삭제)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000142,MAT_000255) USAGE.07·dflt_yn=Y·disp_seq=1·del_yn=N(링크 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", upr_mat_cd: null, 색상: "화이트", 사용: "142 본체 색상 자재(USAGE.07)", master_del_yn: "Y", link_del_yn: "N", note: "실사소재 아크릴스티커 화이트(정당·레더 crosscut 아님·pack §3.5). ★마스터 del_yn=Y·상품링크 활성 불일치(gap-142-color-material-deleted). 색상 옵션 OPV_000450 참조. 가격 무관(use_dims=[siz_cd])"}
- 본문: 유광아크릴스티커 화이트 색상 자재(MAT_TYPE.08 실사소재·낱장 단일 슬롯 USAGE.07). 색상 옵션그룹 OPT_000069의 option_refs 타깃(OPV_000450→이 자재). ★마스터 논리삭제(del_yn=Y)인데 링크·옵션 참조는 활성=불일치(정직 관찰). 가격 무관(구성요소 use_dims=[siz_cd]에 mat_cd 없음). [[product-142-glossy-acrylic-sticker]] uses_material 대상.

### [material-MAT_000256] 블랙 (아크릴스티커 색상·실사소재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000256
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000256(mat_nm=블랙·mat_typ_cd=MAT_TYPE.08·upr_mat_cd=(없음)·★del_yn=Y 06-16 논리삭제)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000142,MAT_000256) USAGE.07·dflt_yn=Y·disp_seq=1·del_yn=N(링크 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", upr_mat_cd: null, 색상: "블랙", 사용: "142 본체 색상 자재(USAGE.07)", master_del_yn: "Y", link_del_yn: "N", note: "실사소재 아크릴스티커 블랙(정당). ★마스터 del_yn=Y·상품링크 활성 불일치(gap-142-color-material-deleted). 색상 옵션 OPV_000451 참조. 가격 무관(use_dims=[siz_cd])"}
- 본문: 유광아크릴스티커 블랙 색상 자재(MAT_TYPE.08 실사소재·USAGE.07). 색상 옵션그룹 OPT_000069의 option_refs 타깃(OPV_000451→이 자재). ★마스터 논리삭제인데 링크·옵션 참조 활성=불일치(정직 관찰). 가격 무관. [[product-142-glossy-acrylic-sticker]] uses_material 대상.

## 수량규칙 노드 (product-local — ★수량 공백 GAP-SL-8)

### [qty-142] 유광아크릴스티커 수량규칙 (★제품레벨 공백) {unknown}
- type: bundle_qty
- anchor: t_prd_products/PRD_000142
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000142 min_qty/max_qty/qty_incr=전부 공백·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: unknown, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(★전부 공백)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★130(1/10000/1)과 달리 142는 제품 레벨 수량 미설정(공백)=GAP-SL-8. 고정가 룩업형이라 수량축이 가격 차원 아님(use_dims=[siz_cd]·수량무관). 값 미상 정직 선언"}
- 본문: 수량 그릇 = 상품 마스터 컬럼이나 min/max/incr **전부 공백**(pack §3.4 GAP-SL-8). bundle_qtys 0행. 수량 UI 권위=상품/사이즈 규칙([[rule/decisions#DEC_qty_audit_260702]])이나 142는 미설정 상태 → [[product-142-glossy-acrylic-sticker-nodes#gap-142-qty-blank]]. 가격은 수량 무관 통가격(총액=셀단가×수량).

## 옵션그룹 노드 (product-local — 색상 택1·화이트/블랙→자재 참조)

<!-- ★OPT_000069 색상 = 142 CPQ 축(130과 달리 옵션그룹 보유). 화이트/블랙 item이 자재 MAT_000255/256을 OPT_REF_DIM.03으로 가리킴(R11 option_refs·L-18 부모 142 uses_material 실재). 색상은 가격 무관(use_dims=[siz_cd]). -->

### [optgroup-142-color] 색상 (화이트/블랙) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000142
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000142 opt_grp_cd:OPT_000069(색상·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000142 OPT_000069 (OPV_000450 화이트 dflt_yn=Y / OPV_000451 블랙)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000142 (OPV_000450→MAT_000255·OPV_000451→MAT_000256·전부 OPT_REF_DIM.03=자재·ref_key2=USAGE.07)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000255, ref_key1: MAT_000255, note: "화이트(OPV_000450)→자재"}
- rel: {rel: option_refs, target: material-MAT_000256, ref_key1: MAT_000256, note: "블랙(OPV_000451)→자재"}
- props: {opt_grp_cd: "OPT_000069", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "화이트(dflt)/블랙(택1)", ref_dim: "OPT_REF_DIM.03=자재(색상→자재축·★가격 무관·use_dims=[siz_cd]에 mat_cd 없음)"}
- 본문: 손님이 색상을 고르는 CPQ 옵션(택1·화이트 기본). 화이트/블랙 item이 각각 자재(MAT_000255/256)를 가리켜(R11 option_refs·OPT_REF_DIM.03) uses_material 차원으로 환원(L-18 통과·부모 142 uses_material 실재). ★색상 선택은 **가격을 바꾸지 않는다**(구성요소 use_dims=[siz_cd]에 mat_cd 없음·4셀 색상 불문 동일가·comp note "화이트/블랙" 동일). ★참조 자재 마스터 del_yn=Y 불일치는 [[product-142-glossy-acrylic-sticker-nodes#gap-142-color-material-deleted]].

## 가격공식 노드 (product-local — silsa formula 축 승격 대기·needed_shared)

<!-- ★고정가 룩업형(단일축·면적매트릭스·원자합산·2축고정가와 다른 아키타입). 단일 구성요소(완제품가)를 (siz_cd) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_ACRYLSTK_GLOSS = 아래 142 canonical 정의(142 전용·143 미러는 별도 comp). -->

### [formula-PRF_POSTER_ACRYLSTK_GLOSS] 유광아크릴스티커 완제품가 (고정가 룩업·규격 단일축) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ACRYLSTK_GLOSS
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_ACRYLSTK_GLOSS(frm_nm=유광아크릴스티커 완제품가(면적/규격 단가)·note=포스터사인 유광아크릴스티커 소재/사이즈/수량별 완제품 통가격·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_ACRYLSTK_GLOSS(comp COMP_POSTER_ACRYLSTK_GLOSS·disp_seq 1·addtn_yn Y·1행·06-18 배선)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000142,PRF_POSTER_ACRYLSTK_GLOSS) 바인딩·apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_ACRYLSTK_GLOSS, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가 룩업형(fixed·통가격·단일축)", use_yn: Y, note: "142 바인딩 전용 공식. 단일 구성요소(완제품가)를 (siz_cd) 4셀에서 조회(evaluate_price). frm_nm '(면적/규격 단가)'는 명명일 뿐·실 use_dims=[siz_cd] 규격 직접 룩업(면적매트릭스 아님·전사표 검증). note '수량별'도 명명일 뿐·min_qty NULL(수량무관)"}
- 본문: 유광아크릴스티커 가격공식. 단일 구성요소(완제품가) 1건 배선 — 인쇄·용지·UV 커팅을 원자 합산하지 않고 (규격 siz_cd) 고정 룩업에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_ACRYLSTK_GLOSS]](아래 142 canonical 정의). 고아 공식 아님(has_component 1건·06-18 배선·pack §27 정합). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local canonical — 고정가 룩업·silsa component 축 승격 대기·needed_shared)

<!-- ★COMP_POSTER_ACRYLSTK_GLOSS = 유광아크릴스티커 완제품가(규격 단일축). 142 전용(143 미러는 COMP_POSTER_ACRYLSTK_MIRROR 별도). -->
<!-- ★단가행(4셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price·단가범위 9000~37000)은 grid shape 증거로만·개별 셀단가 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_ACRYLSTK_GLOSS] 유광아크릴스티커 완제품가 (규격·고정 룩업) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_ACRYLSTK_GLOSS
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_ACRYLSTK_GLOSS(comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd]·note=포스터·사인 완제품가(소재+출력+가공 포함 통가격)·사이즈·수량별 단가표·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cache/transcribed-142-260703.json", source_locator: "grid.COMP_POSTER_ACRYLSTK_GLOSS(행4·사이즈4·mat NULL·수량 NULL·셀 4/4 유효·단가범위 shape 9000~37000)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd"]', role: "유광아크릴스티커 완제품 통가격(소재+출력+가공 포함)", 단가행_ref: "전사표 고정가 shape(4행=규격4×1·유효격자 4/4·수량·색상축 미충전 min_qty·mat_cd NULL)", archetype: "고정가 룩업(fixed·단일축·면적매트릭스 아님)", note: "색상(화이트/블랙) 무관 동일가(comp note '화이트/블랙')·143 미러는 COMP_POSTER_ACRYLSTK_MIRROR 별도"}
- 본문: 유광아크릴스티커 완제품가 구성요소(canonical·142 전용). use_dims **1축**(사이즈 siz_cd)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 규격 4종 = 유효 4셀(전사표 SHAPE·색상/수량 무관). 값=evaluate_price(개별 셀단가 미전사·단가범위는 grid shape 증거만·D-18·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527/comp note verbatim.

## GAP 노드 (원천 부재·정직 선언)

### [gap-142-qty-blank] 제품 레벨 수량 미설정 (min/max/qty_incr 공백) {unknown}
- type: gap
- anchor: none  # 사유: min_qty/max_qty/qty_incr 라이브 공백 — 권위(L1) 원본 미명시라 목표값 미상(GAP-SL-8)
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000142 min_qty/max_qty/qty_incr=공백 · t_prd_product_bundle_qtys PRD_000142 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "유광아크릴스티커 제품 레벨 수량 규칙(min/max/qty_incr)이 전부 공백. 130(1/10000/1 명시)과 달리 142는 미설정. pack §3.4 GAP-SL-8(메쉬현수막/홀로그램/유광아크릴 수량 L1 빈값·원본 미명시 정합) 대상 — 유지 vs 동류값 보완 미확정"
- gap_fill_from: "실무진(Q-SL-5) + pack §3.4 GAP-SL-8. 가격은 수량 무관(use_dims=[siz_cd])이라 견적 무손상이나 최소주문수량 UX는 미상"
- gap_owner: staff
- relations:
  - {rel: derived_from, target: qty-142}
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_ACRYLSTK_GLOSS]]→[[component-COMP_POSTER_ACRYLSTK_GLOSS]]·유효 4/4셀)이라 견적 0 위험 없음(수량 무관 통가격). 다만 최소/최대 주문수량·증분이 공백이라 손님 수량 UI 규칙이 미상(정직 선언·GAP-SL-8).

### [gap-142-uv-process] 아크릴 UV 커팅 공정 행 미적재 {unknown}
- type: gap
- anchor: none  # 사유: 아크릴스티커 인쇄방식=UV PROC_000002이나 라이브 t_prd_product_processes 0행 — 공정 라우팅 행 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:PRD_000142 0행(live 실측)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.7 아크릴스티커 UV PROC_000002 라우팅 기대(팩 기준)·F-ID-4", captured_at: "2026-07-03", badge: candidate, src_id: SR-pack-silsa}
- gap_what: "유광아크릴스티커는 UV PROC_000002(레이저커팅 라인·pack §3.7·F-ID-4)로 라우팅돼야 하나 라이브 공정 행이 0(실사 공통 proc=0). UV 커팅 공정 행 추가 여부 미확정(pack GAP-SL-A·영향 작음)"
- gap_fill_from: "실무진(Q-SL-A) + pack §3.7. 가격은 완제품 통가격(출력+가공 포함)이라 견적 무손상이나 공정 라우팅/생산 메타는 미표현"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_ACRYLSTK_GLOSS]]→[[component-COMP_POSTER_ACRYLSTK_GLOSS]])이라 견적 0 위험 없음(UV 커팅이 통가격에 포함 추정). 다만 인쇄방식/커팅 공정(UV PROC_000002) 라우팅 행이 라이브에 없어 공정 축이 얕음(정직 선언·GAP-SL-A·영향 작음).

### [gap-142-color-material-deleted] 색상 옵션이 마스터 논리삭제된 자재 참조 {unknown}
- type: gap
- anchor: none  # 사유: 색상 옵션(OPT_000069)이 참조하는 자재 MAT_000255/256 마스터 del_yn=Y인데 상품링크·옵션 참조는 활성 — 의도 vs 결함 미확정
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000255/256 del_yn=Y(06-16) vs t_prd_product_materials del_yn=N·t_prd_product_option_items OPT_REF_DIM.03 참조 활성", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "색상 옵션그룹(OPT_000069·화이트/블랙)이 OPT_REF_DIM.03으로 참조하는 자재 MAT_000255(화이트)·MAT_000256(블랙)이 마스터에서 del_yn=Y(06-16 논리삭제)됐으나 상품링크(product_materials)·옵션 참조(option_items)는 del_yn=N 활성 = 불일치. (1) 논리삭제 후 링크 의도 보존인지 (2) 참조 정합 결함(삭제 자재를 가리킴)인지 미확정. fn_chk_opt_item_ref는 product_materials 활성 링크로 충족(트리거 미위반)"
- gap_fill_from: "실무진 + webadmin 실화면(142 색상 옵션 UI에 화이트/블랙 노출 여부)·권위 엑셀(화이트/블랙 자재 존폐). 127 MAT_000188 동형 이슈"
- gap_owner: staff
- 본문: 색상 옵션 경로는 연결됨([[optgroup-142-color]]→[[material-MAT_000255]]/[[material-MAT_000256]]·부모 uses_material 실재)이나 참조 자재의 마스터가 논리삭제 상태. 색상은 가격 무관이라 견적 무손상이나 삭제 자재 참조는 정합 관찰 대상(정직 선언·의도/결함 미판정·127 선례). ★IMPORT 자재 삭제 금지 원칙([[rule/rules#RULE_import_material_no_delete]])과 함께 재검토 대상.

### [gap-142-fixedprice-basis] 아크릴스티커 완제품 통가격 산정 근거 문서 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 4셀 완제품 통가격(소재+출력+가공)이 어떤 규칙으로 산정됐는지 엑셀 미기재 암묵지
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "고정가 4셀(규격별) 완제품 통가격이 아크릴 원가+UV 출력비+커팅 가공비를 어떤 규칙으로 통합해 산출됐는지 — 값은 라이브에 적재됐고(가격표 verbatim·9000~37000) 라이브 셀단가=가격표 원본이나 산정식 자체는 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 공통). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식은 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_ACRYLSTK_GLOSS]]→[[component-COMP_POSTER_ACRYLSTK_GLOSS]]·유효 4/4셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
