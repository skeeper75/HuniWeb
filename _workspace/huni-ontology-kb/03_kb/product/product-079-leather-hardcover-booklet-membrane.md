---
id: product-079-leather-hardcover-booklet-membrane
type: product
anchor: t_prd_products/PRD_000079
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000079 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.03·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-077-post-verify.md", source_locator: "§1 079 면지 통합 재설계(자재 3종 MAT_382/383/384 USAGE.03·OPT_065 3택1·prd_nm '레더 하드커버책자-면지')·§3 실화면", captured_at: "2026-07-03", badge: verified, src_id: SR-23-postverify}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.5/§3.9 면지 통합·색 옵션 멤버 이관·§4 무가격 내부 택1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: uses_material, target: material-MAT_000382, note: "화이트면지(dflt·USAGE.03)"}
  - {rel: uses_material, target: material-MAT_000383, note: "블랙면지(USAGE.03)"}
  - {rel: uses_material, target: material-MAT_000384, note: "그레이면지(USAGE.03)"}
  - {rel: has_option_group, target: optgroup-079-membrane-color, note: "면지색 3택1(OPT_065·용지 드롭다운·기본 화이트)"}
  - {rel: derived_from, target: product-077-leather-hardcover-booklet, note: "면지=무가격(제본비 포함·기여0·component_prices 0행). 가격이 부모 077 셋트에서 파생(기여 0). 구성원 derived_from 타깃=부모 상품 노드 통일(082/088/100 동형·C-5)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.03"
  role: "레더 하드커버책자 면지 구성원(반제품·색 3택1)"
  set_contribution: "NONE(무가격·제본비 포함)"
  구분: "레더 하드커버책자-면지(화/블/그 택1·기본 화이트)"
standards: {schema_org: "Product", xjdf: "Product(면지 component)", config_ont: "component"}
answers_cq: ["레더 하드커버책자 면지 색상 질의"]
tags: ["#셋트구성원", "#면지", "#반제품", "#책자", "#레더", "#무가격"]
updated: 2026-07-03
---

# 레더 하드커버책자-면지 (product-079-leather-hardcover-booklet-membrane)

레더 하드커버책자 면지 구성원(PRD_000079·반제품·SEMI_ROLE.03). 셋트
[[product-077-leather-hardcover-booklet]]의 disp_seq3 멤버·**074 하드커버책자 면지와 동형**(재설계로 면지
3빈멤버 079/080/081 → 1멤버 079 + 색 3택1). 면지 색 자재(화이트 MAT_000382 dflt·블랙 383·그레이 384·
USAGE.03)가 부모 077 → 멤버로 이관·색 옵션그룹
[[product-072-hardcover-booklet-nodes#optgroup-079-membrane-color]](OPT_065)이 멤버에 붙는다.

- **★면지 = 무가격**(제본비 포함·기여 0·component_prices 0행). `derived_from → [[product-077-leather-hardcover-booklet]]`(타깃=부모 상품 노드 통일·C-5)로 O5 만족·삭제 금지(선택지·팩 §3.5 [HARD]).
- **옵션참조 정합**(fn_chk_opt_item_ref): OPT_065 → MAT_382/383/384가 같은 부모 079에 실재(L-18 정합).
- **anchor 주석**: live-snapshot 20260702_1119은 재설계 前(079=빈멤버·자재/옵션 부모 077 귀속)이라 앵커=`t_prd_products/PRD_000079`
  (제품 실재)로 두고 재설계 사실은 077-post-verify §1 전사로 확증(팩 §2 T-3 STALE 회피).
- **구성원 옵션그룹 UI 렌더(D-1)** = [[rule/gaps#gap-set-member-optgroup-ui]].
</content>
