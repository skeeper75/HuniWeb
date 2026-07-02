<!-- rule(RULE_*) — 도메인 규칙·암묵지·안티패턴·범위경계. 앵커=SOT 문서 절/MEMORY 토픽. -->
<!-- rule은 고아 허용(I-1·L-19 예외). RULE_scope_boundary는 거절형 질의(nl-query 유형 5)의 노드 근거. -->

# 축: 규칙 (rule)

후니 인쇄 도메인의 확정 규칙·[HARD]·안티패턴. 질의 게이트가 참조. relitigate 금지 규칙 포함.

### [RULE_scope_boundary] KB 답변 범위 경계 {verified}
- type: rule
- anchor: none  # 사유: KB 전용 범위 선언(사용자 확정·nl-query 유형 5 거절 근거)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§0 KB 답변 범위(사용자 확정·relitigate 금지)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
- props: {in_scope: "상품·구성요소·옵션·가격 차원·제약", out_of_scope: "주문·배송·회원·쿠폰·경쟁사 가격비교·재고", 처리: "범위 밖은 정직 거절(날조 금지)·상품 노드로 라우팅 안 함"}
- 본문: 이 지식베이스는 상품 구성·옵션·가격 구성까지만 답한다. 배송일·회원할인·재고·경쟁사 가격은 범위 밖으로 정직 거절한다(nl-query S13~S16).

### [RULE_plate_paper_only] 판형=종이류 출력소재만 {verified}
- type: rule
- anchor: none  # 사유: KB 전용 규칙(근거 문서는 sources)
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "규칙:종이류만 판형", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- props: {규칙: "판형(plate_size)은 종이류 출력소재에만 유효. 비종이류(아크릴/실사/굿즈)는 판형 불필요", relitigate: 금지}

### [RULE_pansu_db_function] 판걸이수=DB 함수 계산 {verified}
- type: rule
- anchor: none  # 사유: KB 전용 규칙(근거 문서는 sources)
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "규칙:판걸이수 fn_calc_pansu", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md", source_locator: "t_siz_pansu 신설", captured_at: "2026-07-03", badge: verified, src_id: SR-26-pansu}
- props: {규칙: "판걸이수(UP수)=fn_calc_pansu(t_siz_pansu lookup 우선→기하 폴백). ★T-7 반증: 앱 계산·DB 미저장 서술은 DROP", engine_fn: "fn_calc_pansu"}

### [RULE_price_value_boundary] 가격 값=evaluate_price 권위 {verified}
- type: rule
- anchor: none  # 사유: 방법론 D-18 가격 경계 원칙
- src: {source_file: "raw/webadmin/webadmin/catalog/pricing.py", source_locator: "evaluate_price(단일 권위 알고리즘)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-pricingpy}
- props: {규칙: "온톨로지는 상품→공식→구성요소→차원(use_dims)까지만 모델링. 가격 값 계산은 evaluate_price 단일 권위(KB는 값 단정 안 함)", boundary: "D-18"}

### [RULE_dosu_is_printopt] 도수=print_opt_cd (색상코드 아님) {verified}
- type: rule
- anchor: none  # 사유: 도메인 [HARD]·§14 진단
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 도수=print_opt_cd·별색=공정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
- props: {규칙: "도수=인쇄옵션 코드(print_opt_cd)이지 색상코드(clr_cd)가 아니다. 별색은 도수 아니라 공정(clr_cd=NULL). T-4 함정(clr_cd 8차원)=인용 금지"}

### [RULE_import_material_no_delete] IMPORT 등록 자재 삭제 금지 {verified}
- type: rule
- anchor: none  # 사유: 사용자 지적·MEMORY 교훈
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "IMPORT 시트 자재 삭제 금지(배선/단가 채울 갭)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- props: {규칙: "실무진이 IMPORT 시트로 등록한 자재는 '배선 안 됐다'고 삭제 금지 — 배선/단가를 채울 갭이다(사용자 [HARD] 지적)"}

### [RULE_dataline_neq_wiring] 단가행 존재 ≠ 배선 완료 {verified}
- type: rule
- anchor: none  # 사유: §27 배선 교훈
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "단가행 존재≠배선완료(formula_components 확인)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- props: {규칙: "단가행(component_prices)이 적재됐어도 공식에 배선(formula_components) 안 됐으면 견적 0/저청구. 고아 공식=견적 0 신호"}
