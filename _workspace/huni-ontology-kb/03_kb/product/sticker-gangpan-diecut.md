---
id: sticker-gangpan-diecut
type: product
anchor: t_prd_products/PRD_000066
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000066 (합판도무송스티커·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·editor_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§0~5 스티커 파일럿(형상=size 정본·완제품가·코팅 CONFLICT·연당가 §4)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000066,PRF_GANGPAN_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·disp 4)"}
  - {rel: in_category, target: category-CAT_000037, note: "규격스티커(부·main_cat_yn=N·상위 CAT_000002)"}
  - {rel: has_size, target: size-SIZ_000212, note: "정사각10x10mm(8EA)·dflt·형상=size 정사각 family(12) 대표"}
  - {rel: has_size, target: size-SIZ_000224, note: "직사각35x25mm(2EA)·직사각 family(14) 대표"}
  - {rel: has_size, target: size-SIZ_000501, note: "원형10x10·원형 family(11) 대표(전체 37 형상=companion 전사표)"}
  - {rel: has_plate_size, target: plate-066-SIZ_000203, note: "72x46 작업규격 대표(26행·output_paper_typ 전부 공란·gap-066-plate-otyp)"}
  - {rel: uses_material, target: material-MAT_000153, note: "유포스티커 80g·MAT_TYPE.11·parent 직접참조"}
  - {rel: uses_material, target: material-MAT_000084, note: "비코팅스티커 90g·MAT_TYPE.13 합판스티커용지"}
  - {rel: uses_material, target: material-MAT_000155, note: "무광코팅스티커·★코팅 CONFLICT(자재 vs 공정)"}
  - {rel: uses_material, target: material-MAT_000156, note: "유광코팅스티커·★코팅 CONFLICT"}
  - {rel: uses_material, target: material-MAT_000170, note: "투명데드롱스티커 25g·MAT_TYPE.13"}
  - {rel: uses_material, target: material-MAT_000171, note: "은데드롱스티커 25g·MAT_TYPE.13"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도·back 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000055, note: "스티커완칼(도무송·mand_proc_yn=N·상위 없음)·합판 정체 공정"}
  - {rel: has_qty_rule, target: qty-066, note: "상품 min 1000·incr 1000 + bundle_qtys 5행(EA 8/6/3/2/1)"}
  - {rel: priced_by, target: formula-PRF_GANGPAN_FIXED, note: "합판도무송 완제품가 고정가 룩업(원자합산 아님·COMP_GANGPAN_PRINT)"}
  - {rel: has_option_group, target: optgroup-066-paper, note: "종이=자재 6종(mand·코팅 포함)"}
  - {rel: has_option_group, target: optgroup-066-print, note: "인쇄=단면 도수(mand)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N     # ★파일 업로드 전용(058은 Y)
  min_qty: 1000    # 전사표 권위(손전사 아님) <!-- lint-allow: L-12 src=SR-5-livesnap -->
  qty_incr: 1000   # <!-- lint-allow: L-12 src=SR-5-livesnap -->
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커(합판·도무송·형상=size·완제품 단일)"
  price_archetype: "완제품가 고정가 룩업(COMP_GANGPAN_PRINT·형상=size·소재·수량 3차원)"
  status_note: "라이브 출시(use_yn=Y)·형상=size 아키타입 정본·수량/치수/격자 raw는 companion 전사표 권위"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(합판도무송스티커 구성·가격 경로)", "조건 탐색(합판 도무송 스티커·형상별 EA)"]
tags: ["#스티커", "#합판", "#도무송", "#형상=size", "#완제품가고정가", "#코팅CONFLICT"]
updated: 2026-07-03
---

# sticker-gangpan-diecut 합판도무송스티커 (PRD_000066)

합판도무송스티커는 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 점착지(유포/비코팅/무광코팅/유광코팅/
투명데드롱/은데드롱)에 칼라 단면 인쇄 후 **스티커완칼(도무송·`PROC_000055`)** 로 형상(칼틀)대로 완전히
따내는(백지 제거) **합판(gang-imposition·여러 형상 모아찍기) 스티커**(카테고리 = 스티커 `CAT_000002`·규격스티커
`CAT_000037`). ★**파일 업로드 전용**(`file_upload_yn=Y·editor_yn=N` — 058과 달리 에디터 없음). 최소 1,000매·
증분 1,000매(단위 QTY_UNIT.02 "매")·형상별 시트당 EA는 bundle_qtys(8/6/3/2/1). 수량·치수·가격격자 raw 값은
[[sticker-gangpan-diecut-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·팩 §5-3).

★**스티커 파일럿 3대 특성**(팩 §0)이 이 상품에 **정본 형태로** 나타난다: ① **형상(칼틀)이 곧 사이즈** —
066은 37 형상행(정사각12·직사각14·원형11)을 `siz_nm`으로 흡수(형상=size 1:1·058이 형상을 CPQ 옵션값으로
저장한 것과 대비되는 **정본**·팩 §3.2 C-ST-03·Q7 종결) ② **가격 = 완제품가(시트가격) 고정가 룩업**
(COMP_GANGPAN_PRINT·원자합산 아님) ③ **코팅 자재 오적재 CONFLICT**(무광/유광코팅=자재 vs 공정)가 살아있다.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 066은 `t_prd_product_sets` 부모 등록 없음(셋트 아님)
  → 일반 단일 완제품. 기성/디자인 아님(제조 상품). ★팩 §1.1·T-1: round-13 "전량 디자인상품(.04)" 서술은
  **STALE** — 라이브 재분류로 **PRD_TYPE.01(완제품)**이 현재값(SOT 정합·교정 완료).
- 카테고리 = 스티커(`CAT_000002` main·disp 4) + 규격스티커(`CAT_000037` 부). 규격원형/정사각/직사각/팬시
  (058~062)·합판(066) 같은 family(팩 §3.2).

## 차원
- **사이즈(★형상=size 정본):** t_prd_product_sizes active **37행**이 형상 자체를 size로 흡수 — 정사각 12·직사각 14·
  원형 11(siz_nm에 형상+치수+시트당 EA 인코딩·예 "정사각30x30mm(2EA)"). 손님은 사이즈에서 형상을 고른다
  (058이 형상을 CPQ 커팅 옵션값으로 저장한 것과 **대비되는 정본**·[[sticker-gangpan-diecut#gap-066-shape-model-family]]).
  대표 3 family 노드는 companion·전체 37은 전사표 권위(D-22 접기). 판걸이수(UP수)는 사이즈의 파생값
  (`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001·공유 축 재사용). 도수는 색상코드가 아니다
  ([[rule/rules#RULE_dosu_is_printopt]]). 앞면 CMYK 4도·뒷면 인쇄 안 함.
- **수량규칙(★2층):** ① 상품 레벨 min 1000·incr 1000·max 5000(QTY_UNIT.02 "매") ② bundle_qtys **5행**
  (EA 8/6/3/2/1·QTY_UNIT.01·형상별 시트당 조각수). ★058(bundle_qtys 0행)과 달리 066만 bundle_qtys 실재
  (팩 §3.4 "합판 066만 5행" 정합). per-size min_qty는 전부 공란(수량 UI 권위=상품/bundle 레벨). 하위 [[sticker-gangpan-diecut#qty-066]].

## 자재·공정
- **자재:** active 6종 — 유포 `MAT_000153`·비코팅 `MAT_000084`·무광코팅 `MAT_000155`·유광코팅 `MAT_000156`·
  투명데드롱 `MAT_000170`·은데드롱 `MAT_000171`. ★자재유형 혼재 = 153/155/156=**MAT_TYPE.11(스티커용지)**·
  084/170/171=**MAT_TYPE.13(합판스티커용지·06-16 신설 정당 유형)**. 팩 §3.5 일괄 ".11"은 합판 소재엔 부분 stale
  (정본 = 합판=MAT_TYPE.13·[[sticker-gangpan-diecut#gap-066-mattype-note-skew]]). ★066은 **parent 코드 직접 참조** —
  058 계열의 07-01 재키잉(child variant)이 066엔 미적용([[sticker-gangpan-diecut#gap-066-rekeying-skew]]·grid는
  parent 코드로 완전 충전·silent-0 아님). 자재 마스터 노드 [[sticker-gangpan-diecut-nodes]]. ★IMPORT 등록 자재
  삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
  - ★**코팅 CONFLICT(BATCH-3·GAP-ST-1):** 무광/유광코팅스티커(155/156)는 라이브에서 **자재**(라미네이팅 내장
    스티커)로 적재됐으나 실무진 Q9 권위는 **코팅=공정 PROC_000013**. 가격표가 비코팅/무광/유광 3컬럼(코팅=가격축)
    이라 양립 곤란·미해소 → 단정 금지·[[sticker-gangpan-diecut#gap-066-coating-conflict]] 판단 보류(팩 §3.9·T-4).
- **공정:** active = **PROC_000055 스티커완칼(도무송)**(상위 없음·mand_proc_yn=N) 1행. ★058(반칼 PROC_000122)과
  다른 커팅 정체 = 합판도무송의 완칼(Die Cut). ★**base 인쇄 공정(PROC_000004) 없음** — 스티커는 완제품가 룩업
  (COMP_GANGPAN_PRINT에 출력+도무송 내장)이라 원자합산 base 인쇄 바인딩이 불필요(디지털인쇄와 다른 가격
  모델·결함 아님·팩 §3.10). 공정 마스터 [[sticker-gangpan-diecut-nodes]].

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `sticker-gangpan-diecut --priced_by--> formula-PRF_GANGPAN_FIXED --has_component--> component-COMP_GANGPAN_PRINT`.
  공식/구성요소 노드는 companion [[sticker-gangpan-diecut-nodes]]에 신설(058 COMP_STK_PRINT와 별 구성요소·공유
  축 승격 후보). **고아 공식 아님**(has_component 1개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가(시트가격) 고정가 룩업**(원자합산형 아님·팩 §3.10). COMP_GANGPAN_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`
  (**PRICE_TYPE.02**·058 COMP_STK_PRINT는 .01). 가격 = 형상(=size)×소재×수량 3차원 격자. 면적매트릭스 아님·
  구간할인(t_dsc_*) 비대상. 격자 충전 실측(companion 전사표): COMP_GANGPAN_PRINT 1,110행 = 066 active 6소재×185행
  **완전 충전**(예 정사각10x10 유포 1,000매 26,100·수량 5단 26,100→39,200→52,200→65,300→78,300) → **silent-0 아님**.
  단가 2그룹(유포/투명데드롱/은데드롱 고가·비코팅/무광코팅/유광코팅 저가). 값 raw는 전사표 권위(손전사 금지·D-22).
- ★**소재 연당가(원자재 원가)는 이 완제품가 격자에 직접 없다**(팩 §4-B — COMP_PAPER에 스티커 mat_cd 0행·
  소재 마스터에 가격 컬럼 없음). 066의 완제품 retail 가격표는 260702에서 무변경·066 소재는 260702 연당가 변경
  4소재(투명스/홀로/크라프트/투명후지)와 **교집합 0** → 라이브=권위 일치([[sticker-gangpan-diecut#gap-066-yeondangga]]).
  판걸이수는 DB 함수 계산([[rule/rules#RULE_pansu_db_function]]).
- 완제품가 절대값(예전사이트 골든)은 pcode 미상으로 미대조 → [[sticker-gangpan-diecut#gap-066-price-golden]] 정직 선언.

## 옵션·제약·추가상품
- **CPQ 옵션그룹(2 active):** **종이**(OPT_000016·mand·자재 6종·OPT_REF_DIM.03)·**인쇄**(OPT_000017·mand·단면·
  OPT_REF_DIM.06). 그룹 노드 아래 절 참조. ★058과 달리 **커팅/형상 옵션그룹 없음** — 형상=size라 형상은 사이즈에서
  고름(모델 정합). ★삭제 그룹 = **원형(OPT-000004)·빈 그룹**(옵션값 1개도 del_yn=Y)·**이미 논리삭제**(팩 §3.9 C-ST-12
  "066 빈 옵션그룹 논리삭제 제안" = 라이브 반영 완료·[[sticker-gangpan-diecut#gap-066-empty-optgroup-resolved]]).
- **제약규칙:** `t_prd_product_constraints` = 066 행 **0**(058 RULE_001과 달리 제약 없음).
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 066 행 **없음**(단품 인쇄물·팩 §3.12).

## 승계·freshness 메모
- 형상=size·완제품가·코팅 CONFLICT 의미 = 팩 §0~5 FRESH 승계. ★066은 **형상=size 아키타입의 정본**
  (058 spec-circle이 형상을 옵션값으로 저장한 것과 대비). round-13 "디자인상품(.04)"류는 라이브 재분류로 재조준(T-1).
- MAT_TYPE.13(합판스티커용지) 06-16 신설·07-01 재키잉 066 미적용은 위키에 없던 신사실 — live-snapshot 실측으로
  재조준(팩 §3.5 일괄 ".11" 부분 stale·[[rule/decisions#DEC_wiring_round22_260702]] 배선 원장).
- ★연당가 양면(defect) 판단 = **066은 해당 없음**(아래 GAP): 260702 연당가/국4절 변경은 투명/홀로/크라프트/
  투명후지 4소재 국한(전사표 diff·교집합 0)·066 소재(유포/비코팅/코팅/데드롱)는 **변경분 아님** → false-defect
  방지 위해 dual 노드 미생성(팩 §4-D "retail 무변경 dual 금지"·058 선례 정합).

---

## 이 상품 전용 하위 노드 (qty·plate·CPQ·gap)

> 축 마스터 노드(사이즈·자재·공정·판형·공식·구성요소)는 [[sticker-gangpan-diecut-nodes]] companion에.
> 아래는 상품-local 수량규칙 + 대표 판형 + CPQ 옵션그룹 + 정직 GAP.

### [qty-066] 합판도무송스티커 수량규칙 (2층: 상품 + bundle_qtys) {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000066
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000066 min_qty/qty_incr/qty_unit_typ_cd", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "테이블:t_prd_product_bundle_qtys 키:PRD_000066 (5행·bdl_qty 8/6/3/2/1·QTY_UNIT.01·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_incr_ref: "companion 전사표(상품 min 1000·incr 1000·단위 매)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 5, note: "★058(bundle_qtys 0)과 달리 066만 5행(팩 §3.4)·bdl_qty=형상별 시트당 EA"}
- rel: {rel: derived_from, target: size-SIZ_000212, note: "bdl_qty(시트당 EA)는 형상(=size)의 파생(정사각10x10=8EA)"}
- 본문: 수량 그릇 2층 = ① 상품 마스터(min 1000·incr 1000·max 5000·단위 "매") ② bundle_qtys 5행(EA 8/6/3/2/1·QTY_UNIT.01=형상별 시트당 조각수). per-size min_qty는 공란(수량 UI 권위=상품/bundle 레벨·팩 §3.4). ★058과 달리 066만 bundle_qtys 실재(합판=여러 형상 모아찍기라 시트당 EA가 수량 축).

### [plate-066-SIZ_000203] 72x46 작업규격 (대표·output_paper_typ 공란) {candidate}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000066
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000066,SIZ_000203) output_paper_typ_cd=공란·dflt_plt_yn=Y·del_yn=N (26행 중 대표)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000203(72x46)", output_paper_typ_cd: "(공란)", dflt_plt_yn: "Y", plate_rows: 26, note: "★058(SIZ_000521·OUTPUT_PAPER_TYPE.02 명시)과 달리 066 판형 26행 전부 output_paper_typ_cd 공란 → 판형 유형 미지정·badge=candidate([[sticker-gangpan-diecut#gap-066-plate-otyp]])"}
- 본문: 066 판형(plate_size)은 26행이나 output_paper_typ_cd가 전부 공란(058은 46계열 명시). 종이류=점착지라 판형 대상([[rule/rules#RULE_plate_paper_only]])이나 출력용지 유형 미지정. 대표 1행만 노드화(D-22 접기)·유형 공란은 GAP.

### [optgroup-066-paper] 종이 (자재 6종·mand) {candidate}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000066
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000066,OPT_000016) sel_typ=SEL_TYPE.01·mand_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 그룹 OPT_000016 6값(OPV_000032~037·ref_dim_cd=OPT_REF_DIM.03 자재·ref_key1=MAT_000153/084/155/156/170/171)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01(단일)", mand_yn: "Y", opt_values: 6, note: "★코팅(무광 155·유광 156)을 '종이'(자재) 옵션값으로 노출 = 코팅 CONFLICT(가격축 vs 공정)·badge=candidate"}
- rel: {rel: option_refs, target: material-MAT_000153, ref_key1: "MAT_000153", note: "유포스티커"}
- rel: {rel: option_refs, target: material-MAT_000084, ref_key1: "MAT_000084", note: "비코팅스티커"}
- rel: {rel: option_refs, target: material-MAT_000155, ref_key1: "MAT_000155", note: "무광코팅스티커·코팅 CONFLICT"}
- rel: {rel: option_refs, target: material-MAT_000156, ref_key1: "MAT_000156", note: "유광코팅스티커·코팅 CONFLICT"}
- rel: {rel: option_refs, target: material-MAT_000170, ref_key1: "MAT_000170", note: "투명데드롱스티커"}
- rel: {rel: option_refs, target: material-MAT_000171, ref_key1: "MAT_000171", note: "은데드롱스티커"}
- 본문: 종이 그룹은 자재 6값(OPT_REF_DIM.03·mand). 6 타깃 모두 부모 066 uses_material에 실재(L-18 fn_chk_opt_item_ref 통과). 무광/유광코팅이 '종이'(자재) 축으로 노출됨 = 코팅 CONFLICT([[sticker-gangpan-diecut#gap-066-coating-conflict]]) → 그룹 badge=candidate.

### [optgroup-066-print] 인쇄 (도수·mand) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000066
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000066,OPT_000017) sel_typ=SEL_TYPE.01·mand_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000066,OPV_000038) ref_dim_cd=OPT_REF_DIM.06(도수)·ref_key1=1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01(단일)", mand_yn: "Y", opt_values: 1, note: "단면(OPV_000038)·OPT_REF_DIM.06 도수 참조(ref_key1=1)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, ref_key1: "1", note: "도수 옵션값→인쇄옵션 차원(단면·공유 축)·fn_chk_opt_item_ref 정합(부모 has_print_option 실재)"}
- 본문: 인쇄 그룹은 단면 1값(도수 축·OPT_REF_DIM.06·mand). 옵션참조 타깃=공유 인쇄옵션 [[axis/print-options#printopt-POPT_000001]](부모 066 has_print_option에 실재 → L-18 통과).

### [gap-066-coating-conflict] 코팅=자재 vs 공정 CONFLICT {unknown}
- type: gap
- anchor: none  # 사유: 라이브=자재(MAT_000155/156 스티커 variant) vs Q9 권위=공정(PROC_000013) vs 가격표 3컬럼(코팅=가격축) — 3원천 양립 곤란·미해소(BATCH-3)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 코팅 CONFLICT(BATCH-3·GAP-ST-1)·T-4(단정 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "무광/유광코팅스티커(MAT_000155/156)의 코팅 모델링 — 라이브=자재(라미네이팅 내장), 실무진 Q9=공정(PROC_000013), 가격표=비코팅/무광/유광 3컬럼(코팅=가격축). 어느 것이 정답인지 미확정"
- gap_fill_from: "실무진(Q-ST-A) 확인 + §31 제약/§7 자재 모델 결정 — 코팅=공정 통일 시 155/156 자재 은퇴+공정 바인딩"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000155, note: "코팅 CONFLICT 당사 자재"}
- rel: {rel: references, target: material-MAT_000156, note: "코팅 CONFLICT 당사 자재"}
- 본문: 코팅을 자재로 볼지 공정으로 볼지 3원천이 엇갈린다(팩 §3.9·058 gap-058-coating-conflict와 동류). KB는 양쪽 실재를 기록하되 단정하지 않음(T-4). 양면 노드가 아니라 GAP인 이유 = "현재값 vs 정답"의 정답이 아직 확정 안 됨(권위 미결).

### [gap-066-yeondangga] 소재 연당가 저장처 부재 (066 소재는 260702 변경분 아님) {unknown}
- type: gap
- anchor: none  # 사유: 스티커 소재 연당가(원자재 원가)가 라이브 어디에도 가격노드로 저장 안 됨(§4-B) — 단 066 소재는 260702 연당가 변경 4소재에 미포함(dual 불요)
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/transcribe_sticker_066.py", source_locator: "260702 price-diff 전사(연당가 변경=투명스/홀로/크라프트/투명후지 4소재만·교집합 0·066 소재 무변경)", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-B(연당가 저장처 부재)·§4-D(retail 무변경 dual 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "스티커 소재 연당가(원자재 원가)가 t_mat_materials(가격 컬럼 없음)·COMP_PAPER(스티커 mat_cd 0행) 어디에도 저장 안 됨(systemic·§4-B). 066 소재(유포/비코팅/무광코팅/유광코팅/투명데드롱/은데드롱)는 260702 연당가 변경 4소재(투명스/홀로/크라프트/투명후지)와 교집합 0 → 066 자체는 양면(defect) 노드 불요"
- gap_fill_from: "연당가 저장처 신설·재적재 워크리스트 owner = 투명(053/056/063)·홀로(054) 소재 상품 노드 양면 defect + 크라프트는 라이브 상품 미사용이라 axis material-MAT_000164 양면 노드(owner). 066은 retail 완제품가(무변경)로 가격 성립 → 066 dual 불필요(실무진+인간 승인·팩 §4-D)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_GANGPAN_PRINT, note: "066 가격은 완제품가 격자로 성립(연당가 원가 미참조)"}
- rel: {rel: references, target: material-MAT_000164, note: "크라프트 연당가 재적재 owner(라이브 상품 미사용→axis 소유·허위 위임 교정 D-STK-01)"}
- 본문: ★연당가 양면 노드 판정 = **066은 FALSE(dual 불요)**. 근거(전사 diff): 260702 연당가/국4절 급변은 투명스(130k→149.5k)·홀로(360k→253.7k)·크라프트(156k→81.5k)·투명후지(신규 222k) 4소재 국한 — 066 소재(유포/비코팅/코팅/데드롱)는 교집합 0·무변경. 완제품 retail 가격표도 무변경(팩 §4-D) → false-defect 방지 위해 dual 노드 미생성. 단 "연당가 저장처 부재" systemic 이슈는 스티커 전반에 열림(GAP).

### [gap-066-price-golden] 완제품가 절대값 골든 미검증 {unknown}
- type: gap
- anchor: none  # 사유: COMP_GANGPAN_PRINT 격자 충전은 확정이나 예전사이트 절대값 골든이 pcode 미상으로 미대조(023/051/058과 동류)
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_GANGPAN_PRINT 066 격자 완전 충전(6소재×185행·전사표)·절대값 골든 pcode 미상", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "066 완제품가(COMP_GANGPAN_PRINT·형상×소재×수량) 격자 충전은 실측 확인(1,110행 완전 충전)되나, 예전사이트 견적 절대값(골든)과의 대조가 pcode 미상으로 미검증"
- gap_fill_from: "pcode(예전사이트 상품코드) 매핑 후 골든 대조 — 개발팀/§26 소관"
- gap_owner: 개발
- rel: {rel: references, target: formula-PRF_GANGPAN_FIXED, note: "이 공식의 완제품가 골든 미검증"}
- 본문: 격자 완전 충전(silent-0 아님)으로 가격 계산 가능성은 확인. 절대값 정답 대조는 대기(058 gap-058-price-golden과 동류·지어내지 않고 정직 선언).

### [gap-066-plate-otyp] 판형 output_paper_typ 전부 공란 {unknown}
- type: gap
- anchor: none  # 사유: 066 판형 26행 전부 output_paper_typ_cd 공란(058은 OUTPUT_PAPER_TYPE.02 명시) — 출력용지 유형 미지정
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:PRD_000066 26행 output_paper_typ_cd 전부 공란(전사표)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "066 판형(plate_size) 26행이 output_paper_typ_cd 공란 — 판형=출력용지규격인데 유형 미지정. fn_best_plate 자동선택(종이류)이 유형 없이 정상 작동하는지 미확인"
- gap_fill_from: "실무진/§26 판형 무결성 — output_paper_typ_cd 채움 여부·합판(gang) 판형이 유형 없이 유효한지 확인"
- gap_owner: staff
- rel: {rel: references, target: plate-066-SIZ_000203, note: "output_paper_typ 공란 대표 판형"}
- 본문: 058은 판형에 OUTPUT_PAPER_TYPE.02(46계열) 명시인데 066은 26행 전부 공란. 종이류라 판형 대상([[rule/rules#RULE_plate_paper_only]])이나 유형 미지정 drift. KB는 실재+공란을 기록, 유형 판정은 §26 소관.

### [gap-066-rekeying-skew] 07-01 재키잉 066 미적용 (parent 코드 직접 참조) {unknown}
- type: gap
- anchor: none  # 사유: 052/053/055/058은 07-01 재키잉으로 child variant(584/585/586) 사용, 066은 parent 코드(153/155/156) 직접 참조 — family 내 자재 모델 불일치(단 066 grid 완전 충전·가격 정상)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-C 배선 수렴(스티커 4상품 052/053/058/055 재키잉·066 미포함)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials PRD_000066 자재 6종 전부 parent 코드(153/084/155/156/170/171·del_yn=N)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "052/053/055/058은 07-01 사이즈 재키잉으로 child variant 코드(MAT_000584/585/586 등)를 쓰는데 066은 parent 코드(153/155/156/084/170/171)를 직접 참조 — 같은 스티커 family인데 자재 코드 모델 불일치. 066은 재키잉 배치(§4-C)에 미포함"
- gap_fill_from: "066 자재 모델 통일 필요 여부 — 단 066 grid(COMP_GANGPAN_PRINT)는 parent 코드로 완전 충전·가격 정상이라 즉시 결함 아님. 통일은 §7/§27 배선 소관(인간 승인)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000153, note: "066이 직접 참조하는 parent 코드"}
- 본문: 066은 07-01 재키잉 배치(052/053/055/058)에 미포함 → parent 자재 코드 직접 참조(058은 child variant). 가격 격자는 parent 코드로 완전 충전(silent-0 아님)이라 즉시 결함은 아니나, family 내 자재 코드 모델 불일치는 열림. KB는 실측+skew를 기록.

### [gap-066-mattype-note-skew] MAT_000084 note(.11) vs 현재값(.13 합판스티커용지) {unknown}
- type: gap
- anchor: none  # 사유: 084 마스터 note는 "06-14 종이(.01)→스티커(.11)"인데 현재값=MAT_TYPE.13(합판스티커용지·06-16 신설) — note-vs-value 시점 차이(진화·결함 아님이나 기록)
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000084 note '정정 2026-06-14 종이(.01)→스티커(.11)' + 현재 mat_typ_cd=MAT_TYPE.13", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_cod_base_codes.csv", source_locator: "키:MAT_TYPE.13(합판스티커용지·reg 2026-06-16) — 06-14 note보다 후행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "MAT_000084 비코팅스티커의 note는 06-14 '종이(.01)→스티커(.11)' 정정 이력인데 현재 mat_typ_cd=MAT_TYPE.13(합판스티커용지·06-16 신설). note가 가리키는 .11과 실제 .13이 다름 — 06-16 .13 재분류가 06-14 note 이후라 진화이나 note 미갱신"
- gap_fill_from: "정보성 — 합판 소재는 MAT_TYPE.13(합판스티커용지)이 현재 정답. 팩 §3.5 일괄 '.11' guidance는 06-16 .13 신설 전 작성(부분 stale). note 갱신은 §12 기초코드 소관(결함 아님·이력 기록)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000084, note: "note-vs-value 시점 차이 자재"}
- 본문: 084 note(06-14 .11)와 현재값(.13 합판스티커용지·06-16)의 시점 차이 = 재분류 진화(결함 아님). 팩 §3.5 일괄 ".11"은 06-16 .13 신설 전 작성이라 합판 소재엔 부분 stale. 정본 = 합판=MAT_TYPE.13. KB는 이력을 정직 기록.

### [gap-066-shape-model-family] 형상 저장 모델 family 불일치 (066=size vs 058=옵션값·GAP-ST-3) {unknown}
- type: gap
- anchor: none  # 사유: 066 합판=형상 흡수 size(siz_nm 37행) vs 058 규격원형=CPQ 커팅 옵션값(OPT-000031) — 같은 스티커 family인데 형상 저장 모델 불일치
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.2 GAP-ST-3(규격형 058~062 vs 066 형상 저장처·C-ST-03·Q-ST-C)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "066 합판도무송은 형상(정사각/직사각/원형)을 size(siz_nm 37행)로 흡수(형상=size 정본)하나, 규격형 058~062는 형상을 CPQ 커팅 옵션값(058 OPT-000031)에 저장. 같은 스티커 family인데 형상 저장 모델이 size vs 옵션값으로 불일치"
- gap_fill_from: "실무진(Q-ST-C) 확인 — 형상 모델 통일(size vs 옵션값 vs 공정 param). 066(형상=size)이 Q7 종결 정본이므로 058~062를 066형으로 통일할지 결정 대기"
- gap_owner: staff
- rel: {rel: references, target: size-SIZ_000212, note: "066 형상=size 정본(058은 옵션값)"}
- 본문: 팩 §3.2 GAP-ST-3의 정본측 = 066(형상=size·Q7 종결). 058(형상=CPQ 옵션값)과의 모델 불일치가 family 정합 열린 질문. KB는 066을 정본으로 기록하되 family 통일 미결을 GAP으로.

### [gap-066-empty-optgroup-resolved] 빈 옵션그룹 OPT-000004 논리삭제 (C-ST-12·해소됨) {unknown}
- type: gap
- anchor: none  # 사유: 팩 §3.9 C-ST-12 "066 빈 옵션그룹(OPT-000004) 논리삭제 제안"은 라이브에서 이미 del_yn=Y로 반영됨 — 잔존 여부 추적용(해소 상태 기록)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000066,OPT-000004) 원형·del_yn=Y (옵션값 OPV-000006도 del_yn=Y)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 C-ST-12(066 빈 옵션그룹 논리삭제 제안·hard-delete 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "팩 §3.9 C-ST-12 '066 빈 옵션그룹 OPT-000004(원형) 논리삭제 제안'의 라이브 현재 상태 = 이미 del_yn=Y(옵션값 OPV-000006도 del_yn=Y). 제안이 라이브에 반영 완료된 상태(해소)"
- gap_fill_from: "정보성 — 이미 논리삭제(del_yn=Y)로 해소됨. hard-delete 금지(논리삭제 유지)·추가 조치 불요"
- gap_owner: staff
- 본문: 팩이 제안한 빈 옵션그룹 논리삭제가 라이브에 이미 반영(del_yn=Y). 해소 상태를 정직 기록(잔존 아님). hard-delete 금지 원칙 유지.
