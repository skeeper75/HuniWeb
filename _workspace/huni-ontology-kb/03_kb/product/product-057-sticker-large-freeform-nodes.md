<!-- product-scoped supplement: PRD_000057(대형 자유형 스티커) 전용 신규 축 + GAP. -->
<!-- ★공유 axis/*·formula/*·index.md 수정 금지. 여기서는 057-고유 노드만 선언한다. -->
<!-- ★공유 스티커 노드(category-CAT_000002 스티커·category-CAT_000309 자유형스티커·material-MAT_000153 유포· -->
<!--    formula-PRF_STK_FIXED·component-COMP_STK_PRINT)는 스티커 16종이 공유하므로 여기서 선언하지 않고 -->
<!--    상품 노드가 참조만 한다(final-state=architect가 단일 공유 파일로 승격). needed_shared_nodes로 반환. -->
<!--    ★이 5개를 상품마다 재선언하면 L-3 중복 id 충돌(병렬 스티커 에이전트 공통) — 통합 단계에서 단일화. -->
<!-- 이미 공유 축에 있는 노드도 재사용: printopt-POPT_000001(axis/print-options)·process-PROC_000053(axis/processes). -->
<!-- ★수치·연결은 _meta/scripts/transcribe_product_057.py 전사(transcribed-by 마커)·LLM 손전사 금지(D-9). -->

# product-057-sticker-large-freeform 축 보강 (PRD_000057 전용 신규 축 · GAP)

057이 도입하는 **057-고유** 축 항목만 여기 선언한다. 공유 스티커 노드(스티커 카테고리 2·유포 자재·
스티커 완제품가 공식/구성요소)는 다른 스티커 상품과 공유하므로 **선언하지 않고 상품 노드가 참조**하며,
공유 축 승격은 needed_shared_nodes로 반환한다(중복 선언 시 L-3 충돌 — 통합 단계에서 단일화). 이미 있는
공유 축(단면 [[axis/print-options#printopt-POPT_000001]]·완칼 [[axis/processes#process-PROC_000053]])도 재사용한다.

## 신규 사이즈 (E3 size) — 자유형 최대 바운딩

## 신규 판형 (E7 plate_size) — 파일사양(free-form)

### [plate-057-SIZ_000199] 자유형 파일사양 판형 400x600 {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000057
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000057,SIZ_000199) output_paper_typ_cd=OUTPUT_PAPER_TYPE.03 dflt_plt_yn=Y note=파일사양", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "규칙:종이류만 판형·fn_best_plate 자동선택", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- props: {siz_cd: "SIZ_000199", output_paper_typ_cd: "OUTPUT_PAPER_TYPE.03", note: "★자유형 스티커 판형=기타(.03)·note 파일사양 — 물리 전지가 아니라 고객 업로드 파일 최대규격(400x600). 국전(.01)/46(.02) 아님. dflt_plt_yn=Y라 fn_best_plate 자동선택. 종이류(점착지)라 판형 유효([[rule/rules#RULE_plate_paper_only]])·057 전용 local(id 상품 스코프)"}

## 신규 수량규칙 (E8 bundle_qty)

### [qty-057] 자유형 스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000057
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000057(min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min 1·max 10000·incr 1)", bdl_unit_typ_cd: "QTY_UNIT.02", note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙([[rule/decisions#DEC_qty_audit_260702]]). 단, 완제품가 격자 min_qty 구간(1/20/50/100/200/300)이 실제 가격 분기(가격구간 vs 수량UI 역할 분리)"}

## GAP (원천 부재·정직 선언)

### [gap-057-material-cost] 스티커 소재 연당가(원가) 저장처 부재 {unknown}
- type: gap
- anchor: none  # 사유: 소재 원가(연당가)를 담을 라이브 가격노드가 없음 — t_mat_materials 가격컬럼 부재·COMP_PAPER 스티커 mat_cd 0행
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000153(가격 컬럼 없음·평량80만)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_PAPER mat_cd=MAT_000153 0행(실측)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-B 연당가 저장처 부재·§4-D 재적재 워크리스트·§5 GAP-ST(연당가)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "스티커 소재 연당가(원자재 원가)는 라이브 가격 사슬에 노드로 존재하지 않는다. 057 유포스티커(MAT_000153)의 권위 연당가 417,000/국4절 219(IMPORT row76)는 어디에도 저장 안 됨(완제품가 COMP_STK_PRINT에는 retail 시트가격만·원가 아님). ★057 유포는 260702 연당가 diff 미변경이라 재적재 High 아님 — 그러나 변경 4소재(투명스티커 백색후지 MAT_000162·홀로그램 163·크라프트 164·투명후지 372·pack §4-A)는 연당가 급변이 라이브 미반영=재적재 워크리스트(그 소재를 쓰는 다른 스티커 상품 몫·needed_shared dual). 열린 질문: 원가 급변(예 크라프 156k→81.5k)이 완제품 시트가격으로 전파돼야 하나(§4-D)."
- gap_fill_from: "실무진 확인(소재 원가 저장처 신설 여부·원가→완제품가 전파 정책) + §26 가격테이블 무결성/§27 배선 후속. 그 전까지 057 완제품 retail은 정상(견적 성립)이므로 가격 답변 가능·원가 축만 미상."
- gap_owner: staff
- rel: {rel: derived_from, target: material-MAT_000153, note: "연당가(원가)는 소재(유포스티커)의 파생 속성 — 저장처 부재로 노드화 못함. material 노드는 공유 축(needed_shared)에서 단일 선언"}
