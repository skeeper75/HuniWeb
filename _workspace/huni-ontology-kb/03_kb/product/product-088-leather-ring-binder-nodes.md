<!-- 088 레더 링바인더 클러스터-로컬 노드: 면지멤버 옵션그룹(OPT_067). -->
<!-- 부모/구성원 product 노드는 product-088-leather-ring-binder.md. 공유 축(materials/formula)은 참조만. 내지 없음(빈 바인더). -->

# 088 레더 링바인더 — 클러스터-로컬 노드

면지멤버(090) 색 택1 옵션그룹. 내지 없음(빈 바인더)이라 내지 수량규칙 없음.

### [optgroup-090-membrane] 면지 색(용지 드롭다운·4택1) {verified}
- type: option_group
- anchor: t_prd_products/PRD_000090
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-088-post-verify.md", source_locator: "§1 090 옵션그룹 복합키:(PRD_000090,OPT_067)(활성 1)·옵션 화/블/그/인쇄(활성 4)·옵션아이템 4(자재 ref OPT_REF_DIM.03·OPV_447→MAT_385)·§3③ sim-meta materials 4종. ★부모측 앵커 t_prd_products/PRD_000090(면지 재설계 2026-07-03·스냅샷 이후·junction 복합키는 이 locator로 확증)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-membrane}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000090,OPT_067) (면지 재설계 2026-07-03 COMMIT·부모 088 OPT_067 은퇴)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_067", opt_grp_nm: "면지(용지)", sel_typ: "SEL_TYPE.01(택1)", mand: "손님 택1(기본 화이트)", 참조: "자재 4종(OPT_REF_DIM.03)"}
- rel: {rel: option_refs, target: material-MAT_000382, ref_key1: MAT_000382, note: "화이트면지(dflt)"}
- rel: {rel: option_refs, target: material-MAT_000383, ref_key1: MAT_000383, note: "블랙면지"}
- rel: {rel: option_refs, target: material-MAT_000384, ref_key1: MAT_000384, note: "그레이면지"}
- rel: {rel: option_refs, target: material-MAT_000385, ref_key1: MAT_000385, note: "인쇄면지(OPV_447→MAT_385)"}
- 본문: 면지 색 택1 그룹(재설계로 부모 088→면지멤버 090으로 이관). option_refs 4종은 부모(090) uses_material에 실재(fn_chk_opt_item_ref·L-18 정합). 면지 = 무가격(기여0·색 선택만). 부모 멤버=[[product-090-leather-ring-binder-membrane]]. ★부모 088의 OPT_067은 은퇴(활성 0·088-post-verify §1).
