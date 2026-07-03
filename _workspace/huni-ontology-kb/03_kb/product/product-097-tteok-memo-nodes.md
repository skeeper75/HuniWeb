<!-- 클러스터-로컬 하위 노드: 떡메모지(097) 전용 수량규칙. Stage B set-cluster(094+097) 260703. -->

# 떡메모지(097) 전용 하위 노드 (qty)

### [qty-097] 떡메모지 수량규칙(묶음수) {verified}
- type: bundle_qty
- anchor: t_prd_product_bundle_qtys/PRD_000097
- src: {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_product_bundle_qtys 키:PRD_000097(50 dflt·100)·del_yn=N + t_prd_products PRD_000097 min/max/incr + page_rules PRD_000097", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 6/1000/3)", bdl_unit_typ_cd: "QTY_UNIT.03", bundle_qtys: "50(dflt)·100 장", page_rule: "3/3/+3"}
- 본문: 떡메모지 수량 그릇 = 묶음수(bundle_qtys 50/100장·★셋트 특유 수량축·pack §3.4) + 상품 수량(min 6·max 1000·incr 3). 094(내지 페이지 가변)와 달리 097은 권당 장수(bundle_qty)로 과금. 골든 bdl_qty=50 기준 100부 135,000. 07-02 수량 진단 min 3→6 교정([[qty-system-audit-260702]]).
