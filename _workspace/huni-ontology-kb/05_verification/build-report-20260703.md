# 그래프 빌드 리포트 — 2026-07-03

> build_graph.py · 정본 /Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb/03_kb → 04_graph. 생성=빌드(검증은 별도 레인·okb-adversarial-gate).

- 판정: **PASS(하드 0)** · 하드 위반 0 · 소프트 경고 30
- 노드 204 · 엣지 430
- 멱등 해시: nodes.jsonl=f116635ef5b55181 · edges.jsonl=da3e882a7272347d

## 노드 수 (타입별)
- bundle_qty: 2
- category: 8
- constraint: 2
- decision: 8
- gap: 15
- intent: 3
- material: 18
- option_group: 29
- plate_size: 1
- price_component: 26
- price_formula: 10
- print_option: 4
- process: 28
- product: 8
- rule: 7
- size: 28
- term: 7

## 엣지 수 (rel별)
- alias_of: 19
- constrains: 3
- decided_because: 11
- derived_from: 2
- has_component: 61
- has_option_group: 29
- has_plate_size: 8
- has_print_option: 15
- has_process: 39
- has_qty_rule: 2
- has_size: 29
- in_category: 12
- option_refs: 75
- priced_by: 9
- references: 84
- uses_material: 32

## badge 분포
- candidate: 5
- unknown: 15
- verified: 184

## 무결성 6검사
- I-1 고아(하드 유형 product/formula/component): 0
- I-2 끊긴 링크: 0
- I-3 타입 위반: 0
- I-4 필수 엣지(O5/O6): 0
- I-5 멱등: nodes/edges 해시 재현(위 해시 — --idem로 자체검사)
- I-6 오염(blocklist): 0 (원천 실재 — hard src_id 5·path 5·advisory src_id 2·path 2 로드)

## 소프트 경고 (빌드 계속·검토용)
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): product-033-standard-namecard :: `evaluate_price` 권위(온톨로지는 배선까지·D-18). 최소 100매·100매 증분·최대 10,
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): product-041-coupon :: 파일 업로드형(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`). 최소 12매·12
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): gap-046-diecut-golden :: - gap_what: "완칼 die-cut 단가 .03 고정 교정(046 1,350,000→50,000) 후
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): product-046-label-tag :: `CAT_000327`). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용). 최소 20
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): product-046-label-tag :: - **수량규칙:** 제품 레벨 min 20 / max 1,000 / incr 20(QTY_UNIT.02).
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): product-046-label-tag :: ([[rule/decisions#DEC_diecut_260701]]·046 1,350,000→50,000).
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): DEC_baseproc_260701 :: - props: {일자: "2026-07-01", 내용: "16상품+019(흰토너008+CMYK004)+02
- L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): DEC_diecut_260701 :: - props: {일자: "2026-07-01", 내용: "COMP_CUT_FULL_DIECUT .01→.0
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-024-photocard -> product-type-classification-sot
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-024-photocard -> harness-domain-rules-12-260701
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-027-bifold-card -> product-type-classification-sot
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-027-bifold-card -> product-027-nodes
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-027-bifold-card -> product-027-nodes
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-027-bifold-card -> product-027-nodes
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-027-bifold-card -> product-027-cpq
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): size-SIZ_000129 -> RULE_import_material_keep
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-046-label-tag -> product-046-label-tag-nodes
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-046-label-tag -> product-046-label-tag-nodes
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-046-label-tag -> product-046-label-tag-nodes
- 본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): product-046-label-tag -> product-046-label-tag-nodes
- I-1 고아 노드(연결 대기·Phase 4): printopt-POPT_000008 (print_option)
- I-1 고아 노드(연결 대기·Phase 4): printopt-POPT_000009 (print_option)
- I-1 고아 노드(연결 대기·Phase 4): process-PROC_000001 (process)
- I-1 고아 노드(연결 대기·Phase 4): process-PROC_000007 (process)
- I-1 고아 노드(연결 대기·Phase 4): process-PROC_000013 (process)
- I-1 고아 노드(연결 대기·Phase 4): process-PROC_000056 (process)
- I-1 고아 노드(연결 대기·Phase 4): size-SIZ_000499 (size)
- I-1 고아 노드(연결 대기·Phase 4): GAP_roll_material_price (gap)
- I-1 고아 노드(연결 대기·Phase 4): GAP_transparent019_pansu (gap)
- I-1 고아 노드(연결 대기·Phase 4): GAP_product_count (gap)

## 비고
- 상품 노드 8개 집필 완료(파일럿 디지털인쇄). 현행 소프트 고아는 ① 파일럿 8상품이 쓰지 않는 축 원자 항목(자재/공정/사이즈/판형/도수/카테고리 일부)과 ② 어떤 노드도 아직 링크하지 않는 floating GAP 노드다 — 'Phase 4 대기'가 아니라 현재 커버리지 경계. floating GAP의 상품 연결 여부는 연결 완전성(축5) 라운드에서 재판정(조용한 고아 gap 방지).
- 고아 하드 유형(product/formula/component)·끊긴 링크·타입 위반·L-18 부모정합·blocklist 오염(HARD)·blocklist 원천 부재 = 0 이어야 PASS.
