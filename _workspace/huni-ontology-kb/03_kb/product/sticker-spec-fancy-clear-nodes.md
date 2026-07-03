<!-- product-local sub-nodes: E7 plate·E8 qty·gap for PRD_000063 반칼팬시투명스티커. -->
<!-- ★공유 노드(category-CAT_000002/037·formula-PRF_STK_FIXED·component-COMP_STK_PRINT·process-PROC_000055/008· -->
<!--   printopt-POPT_000001·material-MAT_000162 dual·size-SIZ_000059/060)는 이미 존재(sibling companion·axis)라 -->
<!--   재정의 금지(L-3) — [[sticker-spec-fancy-clear]]가 relation으로 재사용. needed_shared로 반환. -->
<!-- ★size-SIZ_000058/059/060은 쌍둥이 062(sticker-spec-fancy-nodes.md)가 bare-canonical로 이미 정의 → 참조만. -->
<!-- ★이 파일 단독 소유 = plate-063-SIZ_000521·qty-063·gap-063-*(3). -->
<!-- ★수치(치수·평량·연당가)는 [[sticker-spec-fancy-clear]] 본문 전사표(transcribed-by)가 권위. -->

# sticker-spec-fancy-clear 하위 노드 (반칼팬시투명스티커 PRD_000063 전용 축 원자)

반칼팬시투명스티커(PRD_000063)가 단독 소유하는 판형 1·수량 1·GAP 3. 상품→축 연결(has_size·has_plate_size·
has_qty_rule·references)은 [[sticker-spec-fancy-clear]]가 건다. 수치 원본은 그 본문 전사표가 권위.
사이즈(SIZ_000059/060)·자재(material-MAT_000162)·공정(PROC_000055/008)·카테고리·공식·구성요소는 sibling/axis
정의를 재사용(재정의 없음·L-3).

## 사이즈 노드 (참조 전용 — 쌍둥이 062가 이미 정의·재정의 안 함·needed_shared 반환분)

★**중복 금지(L-3):** 규격 팬시 사이즈 `size-SIZ_000059`(124×186·판걸이4)·`size-SIZ_000060`(90×190·판걸이6)은
쌍둥이 상품 [[sticker-spec-fancy]](PRD_000062 반칼팬시스티커)의 companion [[sticker-spec-fancy-nodes]]가
**bare-canonical id로 이미 정의**했다(062도 같은 사이즈 사용). 063은 이를 **참조만** 한다 —
[[sticker-spec-fancy-clear]]의 `has_size` 엣지가 그 정의를 가리킨다(끊긴 링크 아님). 값(치수·판걸이수)은
그 노드 + 063 본문 전사표가 권위. 공유 `axis/sizes.md` 단일 승격 대상(needed_shared).

- [[sticker-spec-fancy-nodes#size-SIZ_000059]] — 124×186(작업 128×190)·판걸이4·규격 팬시(062/063 공유).
- [[sticker-spec-fancy-nodes#size-SIZ_000060]] — 90×190(작업 94×194)·판걸이6·규격 팬시(062/063/067 공유).

> ★삭제 사이즈 SIZ_000058(100x140·판걸이8)은 063 상품행 del_yn=Y(2026-06-27 논리삭제)라 063 노드 미mint —
> 063 전사표(전 행)에만 기록(재키잉 이력 보존). 마스터(t_siz_sizes)는 활성이고 062가 계속 사용
> ([[sticker-spec-fancy-nodes#size-SIZ_000058]] 소유).

## 판형 노드 (종이류=점착지·판형 유효)

### [plate-063-SIZ_000521] 46계열 전지 330x470 (반칼 스티커 표준전지) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000063
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000063,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02 dflt_plt_yn=Y del_yn=N (삭제된 SIZ_000200/201/202 제외)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000521(330x470·tags 46전지·note 전지(46계열)·반칼 스티커 표준전지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000521", output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", dflt_plt_yn: "Y", note: "★46계열 전지(330x470)·11개 스티커 상품 공유 표준전지. 종이류(점착지)라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택 fn_best_plate 자동선택([[harness-domain-rules-12-260701]]). SIZ_000200/201/202(파일사양)은 2026-06-30 논리삭제. 058 plate-058-SIZ_000521·060 plate-060-SIZ_000521과 동일 판형·상이 id(상품별 래퍼). OUTPUT_PAPER_TYPE.02는 공유 axis/plate-sizes.md 미등재·승격 대기(needed_shared)"}
- 본문: 46계열 전지(330×470)를 출력용지로 쓰는 판형([[sticker-spec-fancy-clear]] has_plate_size). 국전 계열과 상이.

## 수량 노드

### [qty-063] 반칼팬시투명스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000063
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000063(min_qty=8·max_qty=10000·qty_incr=8·qty_unit_typ_cd=QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 수량규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 8/10000/8)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙([[rule/decisions#DEC_qty_audit_260702]])·가격 격자의 min_qty(수량구간 36티어)와 역할 분리"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 8·max 10000·incr 8·QTY_UNIT.02). 사이즈별 수량규칙 오버라이드 없음·bundle_qtys 0행 정상([[sticker-spec-fancy-clear]] has_qty_rule).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-063-halfcut-process] 상품명 '반칼' vs 등록 공정 PROC_000055 '완칼' 명칭 불일치 (GAP-ST-3) {unknown}
- type: gap
- anchor: none  # 사유: 상품명 반칼(Kiss Cut)인데 등록 커팅 공정=PROC_000055 스티커완칼(Die Cut) — 규격형 커팅 공정 통일이 정답인지 판정 원천 부재(Q-ST-C)
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:(PRD_000063,PROC_000055) mand_proc_yn=N del_yn=N", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000055(proc_nm=스티커완칼·note=Die Cut + 조각수) vs 상품명 '반칼팬시투명스티커'", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.6 커팅(반칼 PROC_000054·완칼·스티커완칼 PROC_000055)·§3.2 GAP-ST-3(규격형 058~062 형상/커팅 저장처 Q-ST-C)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "반칼팬시투명스티커(상품명 '반칼'=Kiss Cut)가 등록한 커팅 공정은 PROC_000055 '스티커완칼'(Die Cut+조각수). 반칼(PROC_000054)/반칼커팅(PROC_000122)과 다른 코드. 규격형 058~062 family의 커팅 공정을 반칼로 통일해야 하는지(058은 07-01 PROC_000122로 재키잉·063은 PROC_000055 그대로)·명칭이 상품명과 어긋나는지 미확정"
- gap_fill_from: "실무진(Q-ST-C) 확인 + 개발/§31 — 규격형 커팅 공정 통일(PROC_000055→반칼) 여부. 060 rectangle의 gap-060-halfcut-process와 동류. 그 전까지 커팅 공정 정합 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000055, note: "명칭 관찰 대상 커팅 공정(스티커완칼)"}
- 본문: 상품명은 '반칼'인데 공정은 '완칼'(PROC_000055)이다. 058은 07-01 재키잉으로 PROC_000122(반칼커팅)로 갔으나 063(미출시)은 PROC_000055 그대로 — 규격형 커팅 정책 미통일(pack GAP-ST-3). 지어내지 않고 GAP으로 등재(교정은 실무진/§31 소관).

### [gap-063-cpq-option-layer] CPQ 옵션 레이어 전면 미적재 (BATCH-6·use_yn=N) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_option_groups/options/option_items에 063 행 0개(CPQ 옵션 레이어 전면 미적재) — 손님 선택 축이 상품 차원(has_*)으로만 존재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups/options/option_items 키:PRD_000063 0행 실측(전사표)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 [STK-ST-006] CPQ 옵션 레이어 전면 미적재(BATCH-6)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "063 CPQ 옵션 레이어(사이즈·소재·커팅·화이트 선택을 option_group/option_items로 노출) 미적재(pack BATCH-6). 063은 사이즈·소재·공정을 상품 차원(has_size/uses_material/has_process)으로만 가짐 — 위젯/시뮬레이터 손님 선택 UI 배선이 없다. use_yn=N(미출시)와 정합"
- gap_fill_from: "출시 전 CPQ 옵션 레이어 적재(058 07-01 재키잉 방식 — 커팅/인쇄/종이 그룹). 개발/§7 dbmap CPQ 매핑 + 인간 승인. 058은 부분 적재됨(058≠063)"
- gap_owner: staff
- rel: {rel: references, target: sticker-spec-fancy-clear, note: "CPQ 옵션 레이어 미적재 당사 상품"}
- 본문: 058(3그룹 실재)과 달리 063은 CPQ 옵션 레이어가 0행이다(pack BATCH-6). 미출시(use_yn=N) 상품이라 손님 선택 UI 배선이 아직 없음 — 지어내지 않고 GAP으로 등재(출시 전 적재 필요).

### [gap-063-material-unmigrated] 자재 구코드 MAT_000162 미마이그레이션 (053은 371/372 이관) {unknown}
- type: gap
- anchor: none  # 사유: 063은 un-split parent MAT_000162 직결·053은 06-27 재키잉으로 MAT_000371(백색후지)/MAT_000372(투명후지) 자식으로 이관 — 063 이관이 정답인지 판정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000063,MAT_000162) dflt_yn=Y del_yn=N (자식 371/372 링크 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-B(MAT_000371/372 06-27 mint·부모 미갱신)·§3.5 자재 재분류", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "063은 투명스티커 자재를 구코드 부모 MAT_000162(un-split·명 '투명스티커'·평량 105 구값)에 직결한다. 260702 권위는 투명스티커를 백색후지(MAT_000371)/투명후지(MAT_000372)로 split·053은 자식으로 마이그레이션했으나 063은 부모 그대로 — 063도 자식 코드로 이관해야 하는지, 부모 유지가 미출시(use_yn=N)라 지연된 것인지 미확정"
- gap_fill_from: "실무진/§7 dbmap — 규격형 스티커 자재 마이그레이션 정책(부모 유지 vs 자식 split 이관). 연당가 재적재(§4-D)와 함께 판단. 그 전까지 063 자재 코드 정답 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000162, note: "미마이그레이션 구코드 자재(연당가 dual 겸)"}
- 본문: 063이 쓰는 투명스티커 자재가 구코드 부모(MAT_000162)에 묶여 있다(053은 371/372로 이관). 미출시 상품이라 재키잉이 도달 안 한 상태로 보이나(단정 아님), 이관 정책 미확정 → GAP으로 등재. 연당가 defect는 [[material-MAT_000162]]가 이미 보유.
