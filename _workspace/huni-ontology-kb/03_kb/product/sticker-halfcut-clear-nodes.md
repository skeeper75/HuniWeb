<!-- product-local sub-nodes: E3 size·E4 material(+원가 양면)·E6 process·E7 plate·E8 qty·E11 option_group·gap for PRD_000053 반칼 자유형 투명스티커. -->
<!-- ★공유 노드(category-CAT_000002/309·formula-PRF_STK_FIXED·component-COMP_STK_PRINT·process-PROC_000008·printopt-POPT_000001)는 -->
<!--   이미 존재(sticker-halfcut-hologram-nodes.md·axis/print-options.md)라 재정의 금지 — [[sticker-halfcut-clear]]가 relation으로 재사용. -->
<!-- ★size/material/plate/process 원자는 라이브 마스터 소속이나 공유 축 파일 수정 금지 규칙 때문에 여기 임시 거처(054 선례). -->
<!--   축 소유자가 승격 시 canonical id 그대로 이관 — index_entries/needed_shared로 반환. -->
<!-- ★수치(치수·평량·연당가)는 [[sticker-halfcut-clear]] 본문 전사표(transcribed-by) 또는 아래 양면 노드 field에만. -->

# sticker-halfcut-clear 하위 노드 (반칼 자유형 투명스티커 PRD_000053 전용 축 원자)

반칼 자유형 투명스티커(PRD_000053)가 쓰는 사이즈 3·자재 identity 1(백색후지·투명후지는 056 재사용)·
자재원가 양면 2·판형 1·수량 1·옵션그룹 4·GAP 3. (공정 PROC_000122/008·투명후지 MAT_000372·카테고리·공식·
구성요소·인쇄옵션은 이미 존재해 재사용.) 상품→축 연결(has_size·uses_material·has_process·has_plate_size·
has_qty_rule·has_option_group·references)은 [[sticker-halfcut-clear]]가 건다. 수치 원본은 그 본문 전사표가 권위.

## 사이즈 노드 (product-local — 축 승격 대기)

### [size-053-SIZ_000170] A5 148x210 (투명스티커 주문 사이즈) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000170
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000053,SIZ_000170) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000170(A5 148x210·마스터 del_yn=Y 2026-06-17 논리삭제)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000170", note: "★상품-사이즈 링크 활성(del_yn=N)이나 사이즈 마스터(t_siz_sizes) del_yn=Y — 링크 활성/마스터 삭제 불일치(정직 관찰·단정 아님). 054 홀로그램 size-054-SIZ_000170과 동일 앵커·상이 id(상품별 래퍼)"}
- 본문: A5(148×210) 주문 사이즈. 마스터 논리삭제와 링크 활성 불일치를 정직 표기([[sticker-halfcut-clear]] has_size).

### [size-053-SIZ_000057] A6 105x148 (투명스티커 주문 사이즈·판걸이8) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000057
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000053,SIZ_000057) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000057(A6 105x148·마스터 del_yn=N·note 판걸이=8.0·tags 스티커)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000057", note: "A6(105×148) 주문 사이즈·마스터 활성. note 판걸이=8.0(판걸이수는 사이즈 파생 fn_calc_pansu·[[rule/rules#RULE_pansu_db_function]]). 2026-07-01 재키잉으로 상품 활성화"}
- 본문: A6(105×148) 반칼스티커 주문 사이즈([[sticker-halfcut-clear]] has_size). 판걸이=8 파생.

### [size-053-SIZ_000520] A4 반칼 (규격 래퍼·판걸이2) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000520
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000053,SIZ_000520) 링크 del_yn=N dflt_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000520(A4 210x297 반칼·work/cut 컬럼 공백·note 판걸이=2.0·적용 반칼스티커058~061)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000520", note: "A4(210×297) 반칼 규격 래퍼(라벨에 치수 인코딩·work/cut 마스터 컬럼 공백). note='판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가)'. 054 홀로그램과 공용 사이즈(054도 SIZ_000520)"}
- 본문: A4 반칼 전용 사이즈·낱장 사이즈와 분리된 반칼 전용가 래퍼([[sticker-halfcut-clear]] has_size).

## 자재 identity 노드 (투명 점착지·MAT_TYPE.11)

## ★연당가 양면(defect) 노드 — 소재 원가 재적재 워크리스트 (§4-D 돈-크리티컬)

### [matcost-053-white-backing] 투명스티커(백색후지) 연당가/국4절 (현재값 vs 260702 정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000371
- current_value: "라이브 원가 미저장 — t_mat_materials에 가격 컬럼 없음 + COMP_PAPER(용지비)에 MAT_000162/371/372 0행(실측). MAT_000371 weight 공란·부모 MAT_000162 평량 105·명 '투명스티커'(구값). 즉 백색후지 소재 원가는 라이브 스티커 가격사슬에 노드로 부재(live-snapshot 20260702_1119)"
- authority_value: "260702 권위(price-diff 전사): 종이명 '투명스티커(백색후지)'·평량 50(105→50)·연당가 149500(130000→149500)·가격(국4절) 499(1300→499)·구매정보 '점착 투명데드롱 50mic 후지 백색박리지150g / 1박스당 300매'. (docs/huni/후니프린팅_상품마스터_260702.xlsx#출력소재(IMPORT)!투명스 via 26_change-tracking-260702/price-diff-260527-260702.csv L26~30)"
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "sheet:출력소재(IMPORT) key:투명스 연당가H(130000→149500)·국4절I(1300→499)·평량D(105→50)·종이명C", captured_at: "2026-07-03", badge: defect, src_id: SR-2.2-diff}
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000371(가격 컬럼 부재·weight 공란) + COMP_PAPER에 MAT_000371 0행(t_prc_component_prices)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {note: "★연당가 재적재 워크리스트(§4-D). 260702 기준 소재 원가가 급변(국4절 1300→499·연당가 상향)했으나 라이브 미반영(저장처 부재). 어느 쪽도 삭제 금지 — current(미저장/구값)·authority(260702) 둘 다 보존해 재적재 추적. ★이 원가 변화가 완제품 retail 격자(COMP_STK_PRINT)로 전파돼야 하는지는 열린 질문([[gap-053-yeondangga-repricing]]) — retail 격자는 260702 무변경이라 [[component-COMP_STK_PRINT]]는 dual 아님(false-defect 방지)"}
- rel: {rel: references, target: material-MAT_000371, note: "이 원가 defect가 가리키는 소재 identity 노드"}
- 본문: 백색후지 소재의 연당가/국4절 원가가 260702 권위와 라이브 사이에서 어긋난다(라이브=원가 미저장). 스티커는 완제품가 룩업이라 소재 원가를 절가 노드로 안 펼침(§3.11) — 이 양면 노드가 재적재 워크리스트의 정직한 기록. High 재적재 대기.

### [matcost-053-clear-backing] 투명스티커(투명후지) 연당가/국4절 (현재값 vs 260702 정답·신규) {defect}
- type: material
- anchor: t_mat_materials/MAT_000372
- current_value: "라이브 원가 미저장 — MAT_000372(2026-06-27 mint)는 코드만 존재·weight 공란·연당가/국4절 어디에도 미반영. COMP_PAPER에 MAT_000372 0행(t_prc_component_prices 실측). 즉 투명후지 신규 소재의 원가가 라이브에 저장처 없이 비어 있음(live-snapshot 20260702_1119)"
- authority_value: "260702 권위(price-diff ADDED row 86 전사): 종이명 '투명스티커(투명후지)'·평량 50·연당가 222000·가격(국4절) 740·규격 330x480·구매정보 '점착 투명데드롱 50mic 후지 투명 PET 100mic / 1박스당 300매'. (docs/huni/후니프린팅_상품마스터_260702.xlsx#출력소재(IMPORT)!투명투 신규행 via 26_change-tracking-260702/price-diff-260527-260702.csv L19)"
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "sheet:출력소재(IMPORT) key:투명투 (ADDED row 86) H=222000 I=740 D=50 G=330*480", captured_at: "2026-07-03", badge: defect, src_id: SR-2.2-diff}
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000372(가격 컬럼 부재·weight 공란) + COMP_PAPER에 MAT_000372 0행", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {note: "★연당가 재적재 워크리스트(§4-D·신규행). 260702 신규 소재 연당가 222000/국4절 740이 라이브에 전혀 미반영(코드만 mint). 어느 쪽도 삭제 금지. 완제품가 전파 여부=[[gap-053-yeondangga-repricing]]"}
- rel: {rel: references, target: material-MAT_000372, note: "이 원가 defect가 가리키는 소재 identity 노드"}
- 본문: 투명후지(260702 신규 소재)의 연당가/국4절 원가가 라이브에 저장처 없이 비어 있다. 코드는 발급됐으나 원가 미충전 — 양면 노드로 재적재 대기(§4-D). High.

## 공정 노드 (재사용 — 재정의 금지)

> ★활성 커팅 공정 **process-PROC_000122(반칼커팅)** 는 이미 product-052-sticker-halfcut-freeform-nodes.md가 정의 — 재정의 금지·재사용.
> [[sticker-halfcut-clear]] has_process→process-PROC_000122(mand=N). 화이트 underbase **process-PROC_000008** 도 이미
> sticker-halfcut-hologram-nodes.md 정의라 재사용([[sticker-halfcut-hologram-nodes#process-PROC_000008]]). ★구 반칼 PROC_000054
> (del_yn=Y)를 커팅 옵션참조가 여전히 지목 → 재키잉 불일치 [[gap-053-cutting-rekey]].

## 판형 노드 (종이류=점착지·판형 유효)

### [plate-053-SIZ_000521] 46계열 전지 330x470 (반칼스티커 표준전지) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000053
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000053,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02 dflt_plt_yn=Y del_yn=N (삭제된 SIZ_000007/050/057 제외)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000521(330x470·tags 46전지·note 전지(46계열)·반칼 스티커 표준전지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000521", output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", note: "★타 디지털 판형=OUTPUT_PAPER_TYPE.01(국전 316x467·[[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])과 달리 46계열(330x470). 반칼 스티커 표준전지. 종이류(점착지)라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택 fn_best_plate 자동선택(dflt Y·[[harness-domain-rules-12-260701]]). SIZ_000007/050/057은 2026-06-30 논리삭제. 054 홀로그램 plate-054-SIZ_000521과 동일 판형·상이 id(상품별 래퍼). OUTPUT_PAPER_TYPE.02는 공유 axis/plate-sizes.md 미등재·승격 대기(needed_shared)"}
- 본문: 46계열 전지(330×470)를 출력용지로 쓰는 판형([[sticker-halfcut-clear]] has_plate_size). 국전 계열과 상이.

## 수량 노드

### [qty-053] 반칼 자유형 투명스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000053
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000053(min_qty=8·max_qty=10000·qty_incr=8·qty_unit_typ_cd=QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 수량규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "본문 전사표 수량규칙(상품 8/10000/8)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙([[rule/decisions#DEC_qty_audit_260702]])"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 8·max 10000·incr 8·QTY_UNIT.02). 사이즈별 수량규칙 오버라이드 없음·bundle_qtys 0행 정상([[sticker-halfcut-clear]] has_qty_rule).

## 옵션그룹 노드 (CPQ·옵션=자재+공정 BUNDLE)

### [optgroup-053-paper] 종이 (투명스티커 백색후지/투명후지) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000053
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000053 키:(PRD_000053,OPT_000009) opt_grp_nm=종이 sel_typ=SEL_TYPE.01 min~max=1~1 mand=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000053,OPV_000024) OPT_REF_DIM.03 ref_key1=MAT_000371(seq1)·MAT_000372(seq2)·OPV-000059(투명후지) ref 미보유", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000009", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "백색후지(OPV_000024·dflt)·투명후지(OPV-000059)", ref상태: "★OPV_000024가 두 자재(MAT_000371 seq1·MAT_000372 seq2) 동시 참조·OPV-000059는 ref 미보유(소재↔옵션 매핑 어긋남·관찰)"}
- rel: {rel: option_refs, target: material-MAT_000371, ref_key1: "MAT_000371", note: "백색후지(option_item OPV_000024 seq1·OPT_REF_DIM.03)"}
- rel: {rel: option_refs, target: material-MAT_000372, ref_key1: "MAT_000372", note: "투명후지(option_item OPV_000024 seq2·OPT_REF_DIM.03)"}
- 본문: 종이(자재) 택1 필수 그룹. 옵션→자재(OPT_REF_DIM.03) 환원·부모 053 uses_material 정합(fn_chk_opt_item_ref). ★옵션값↔자재 item 매핑이 어긋남(백색후지 옵션이 두 자재 참조·투명후지 옵션 ref 부재)=검증 레인 관찰(값은 전사표 권위).

### [optgroup-053-print] 인쇄 (도수·단면) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000053
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000053 키:(PRD_000053,OPT_000010) opt_grp_nm=인쇄 sel_typ=SEL_TYPE.01 mand=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000053,OPV_000025) OPT_REF_DIM.06 ref_key1=1(opt_id=1=POPT_000001)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000010", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "단면(OPV_000025·dflt·OPT_REF_DIM.06 ref_key1=1=print_opt)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, ref_key1: "1", note: "단면(option_item OPV_000025→opt_id=1=POPT_000001)"}
- 본문: 도수·단면 택1 필수 그룹(양면 없음). 도수=print_opt_cd(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]). option_item OPV_000025가 OPT_REF_DIM.06으로 opt_id=1(=POPT_000001) 참조·부모 053 has_print_option 정합.

### [optgroup-053-white] 화이트별색 (화이트인쇄/화이트없음) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000053
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000053 키:(PRD_000053,OPT_000011) opt_grp_nm=화이트별색 sel_typ=SEL_TYPE.01 min~max=0~1 mand=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000053,OPV_000027) OPT_REF_DIM.04 ref_key1=PROC_000008(화이트인쇄)·OPV_000026(화이트없음) ref 미보유=센티넬", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000011", opt_grp_nm: "화이트별색", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "화이트없음(OPV_000026·dflt·센티넬)·화이트인쇄(OPV_000027→OPT_REF_DIM.04 ref_key1=PROC_000008)"}
- rel: {rel: option_refs, target: process-PROC_000008, ref_key1: "PROC_000008", note: "화이트인쇄(option_item OPV_000027·OPT_REF_DIM.04·process)"}
- 본문: 화이트별색(underbase) 택1 선택 그룹(0~1). 화이트인쇄(OPV_000027)는 OPT_REF_DIM.04로 PROC_000008 참조(부모 has_process 실재→배선). 별색=공정 정합([[rule/rules#RULE_dosu_is_printopt]]·pack §3.3). '화이트없음'(OPV_000026)은 ref 미보유 센티넬(정상).

### [optgroup-053-cutting] 커팅 (반칼 자유형·★재키잉 불일치) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000053
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000053 키:(PRD_000053,OPT_000012) opt_grp_nm=커팅 sel_typ=SEL_TYPE.01 min~max=1~1 mand=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000053,OPV_000028) OPT_REF_DIM.04 ref_key1=PROC_000054(★삭제된 공정·활성은 PROC_000122)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000012", opt_grp_nm: "커팅", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "반칼(자유형)(OPV_000028·dflt)", ref상태: "★option_item이 PROC_000054(del_yn=Y·상품행 삭제)를 지목·활성 공정은 PROC_000122 → option_refs 그래프 배선 보류(부모 has_process에 PROC_000054 부재=L-18 위반 회피)·[[gap-053-cutting-rekey]]"}
- 본문: 커팅(공정) 택1 필수 그룹. ★option_item OPV_000028의 참조 대상 PROC_000054가 삭제되고 활성 커팅은 PROC_000122로 재발급됐으나 옵션참조는 갱신 안 됨 → fn_chk_opt_item_ref 불일치. 정당 배선(활성 공정)이 부재하므로 option_refs 엣지를 만들지 않고 [[gap-053-cutting-rekey]]로 정직 선언(오배선 방지). 값은 전사표 권위·교정은 검증/개발 레인.

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-053-cutting-rekey] 커팅 옵션참조 재키잉 불일치 (PROC_000054 삭제·PROC_000122 활성) {unknown}
- type: gap
- anchor: none  # 사유: 옵션참조 갱신이 정답인지·개발 교정 대상인지 판정 원천 부재(검증/개발 레인·인간 승인 대기)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000053,OPV_000028) ref_dim=OPT_REF_DIM.04 ref_key1=PROC_000054(삭제) vs t_prd_product_processes 활성 PROC_000122", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 옵션참조(ref_dim_cd)는 같은 부모 prd_cd에 실재 필수(fn_chk_opt_item_ref)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "커팅 옵션 OPV_000028의 option_item이 삭제된 공정 PROC_000054(반칼 Kiss Cut)를 참조하나, 상품 활성 커팅 공정은 PROC_000122(반칼커팅·2026-06-29 재발급). fn_chk_opt_item_ref 정합 위반 소지 — 옵션참조를 PROC_000122로 갱신해야 하는지, 손님 커팅 선택이 견적/생산에 정상 반영되는지 미검증"
- gap_fill_from: "검증 레인(§21 hcc-cpq-link)에서 fn_chk_opt_item_ref 실측 + 개발팀 교정(옵션참조 PROC_000054→PROC_000122). 그 전까지 커팅 배선 정합 단정 금지"
- gap_owner: dev
- rel: {rel: references, target: process-PROC_000122, note: "옵션참조가 가리켜야 할 활성 커팅 공정"}
- 본문: 054 홀로그램과 달리 053은 커팅 공정 코드가 PROC_000054→PROC_000122로 재발급됐는데 옵션참조가 구 코드에 묶여 있다. 지어내지 않고 GAP으로 등재(교정은 검증/개발 레인).

### [gap-053-yeondangga-repricing] 연당가 급변→완제품가 전파 여부 (돈-크리티컬) {unknown}
- type: gap
- anchor: none  # 사유: 소재 원가(연당가) 급변이 완제품 retail 시트가격에 전파돼야 하는지 정답 원천 부재(실무진·인간 승인 대기)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-D·§5 미확정 [GAP-ST(연당가)] 돈-크리티컬", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/change-manifest-260702.md", source_locator: "§1 스티커 완제품 가격표 무변경(라벨만)", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- gap_what: "260702 투명스티커 백색후지 국4절 1300→499(원가 급락)·투명후지 신규 연당가 222000이 완제품 시트가격(COMP_STK_PRINT) retail 격자로 전파돼야 하는가. retail 격자는 260702 무변경(원가↔완제품가 정합 미확인)"
- gap_fill_from: "실무진 답변 + 인간 승인 — 소재 원가 저장처 신설 여부·완제품가 재산정 여부(§4-D). 그 전까지 retail 재적재 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "전파 대상이 될 완제품가 격자(현재 260702 무변경=dual 아님)"}
- 본문: 소재 원가 양면 노드([[matcost-053-white-backing]]·[[matcost-053-clear-backing]])의 급변이 완제품가로 흘러야 하는지 열린 질문. retail은 260702 무변경이라 지금은 dual 아님 — 재적재 후속에서 판정.

### [gap-053-piece-count-storage] 반칼 조각수 상품레벨 저장처 부재 (GAP-ST-2/OM-7) {unknown}
- type: gap
- anchor: none  # 사유: prcs_dtl_opt.조각수 상품레벨 저장처·ref_param_json 미구현(스키마 부재)
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000054(prcs_dtl_opt inputs=모양/조각수)·PROC_000122(prcs_dtl_opt 공백)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.4 조각수·§5 [GAP-ST-2] Q-ST-B·OM-7", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "반칼(kiss cut)의 조각수(판당 개수) input이 공정 prcs_dtl_opt에는 있으나 상품레벨 저장처(prcs_dtl_opt.조각수·ref_param_json) 부재 — 053 반칼 자유형이 손님 조각수 지정을 저장/가격반영할 그릇이 없음"
- gap_fill_from: "실무진 확정(Q-ST-B) + 스키마 선결(ref_param_json 구현·OM-7). 그 전까지 조각수 저장/가격반영 단정 금지"
- gap_owner: staff
- 본문: 조각수(판당 개수+제한)는 반칼 스티커의 핵심 생산 파라미터이나 상품레벨 저장처가 스키마에 없다(pack §3.4). 지어내지 않고 GAP으로 등재(053·054 공통 미결).
