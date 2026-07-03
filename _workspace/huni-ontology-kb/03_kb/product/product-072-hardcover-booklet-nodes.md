<!-- cluster-local sub-nodes: E11 option_group(면지색 074/079)·gap for 072/077 하드커버책자 계열(COVERBIND 동형). -->
<!-- Stage B(072+077 클러스터). 공유 축(material-MAT_000382/383/384·formula-PRF_HC_MUSEON_SET·rule/gaps set-*)은 이미 존재(Stage A)라 재정의 금지 — 상품 노드가 relation으로 재사용. -->
<!-- ★anchor 주석: 면지 옵션그룹(OPT_064/065)은 2026-07-03 면지 재설계로 부모→멤버(074/079) 이관됐으나 live-snapshot 20260702_1119(재설계 前)엔 -->
<!--   junction (PRD_000074,OPT_064)이 없다. L-17 닫힌세계(t_prd_product_option_groups/PRD_000074 미실재 FAIL) 회피 위해 -->
<!--   앵커=t_prd_products/<멤버 prd_cd>(제품 실재)로 두고, 재설계 사실은 post-verify(§1) 전사로 확증(팩 §2 T-3 STALE 회피). -->

# 하드커버책자 계열(072/077) 하위 노드 — 면지색 옵션그룹·계열 GAP

072/077 셋트 계열이 쓰는 **면지색 옵션그룹 2개**(074·079 멤버·색 3택1)와 **계열 GAP 1개**(레더
COVERBIND 델타)의 클러스터-로컬 원자. 면지 자재(화이트 MAT_000382·블랙 383·그레이 384)는 공유
[[axis/materials]] 축(Stage A)이라 재정의하지 않고 option_refs로 재사용한다. 상품→옵션그룹 연결
(has_option_group)은 [[product-074-hardcover-booklet-membrane]]·[[product-079-leather-hardcover-booklet-membrane]]가 건다.

## 면지색 옵션그룹 (면지 통합 재설계·색 내부 택1)

### [optgroup-074-membrane-color] 면지색(화/블/그 3택1) {verified}
- type: option_group
- anchor: t_prd_products/PRD_000074
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-072-post-verify.md", source_locator: "§1 074 옵션그룹 OPT_064(활성 1)·옵션 화/블/그(활성 3·화이트 dflt)·옵션아이템(자재 ref OPT_REF_DIM.03)·§3 실화면 용지 드롭다운. junction 복합키:(PRD_000074,OPT_000064)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-postverify}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.9 면지 색=면지 멤버 옵션그룹(부모→멤버 이관·fn_chk_opt_item_ref 정합)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
- props: {opt_grp_cd: "OPT_000064", opt_grp_nm: "면지색", sel_typ_cd: "SEL_TYPE.01", mand: "손님 택1(기본 화이트)", 재설계: "부모 072→멤버 074 이관(부모 OPT_064 은퇴)"}
- rel: {rel: option_refs, target: material-MAT_000382, ref_key1: MAT_000382, note: "화이트면지(기본 dflt·OPT_REF_DIM.03 자재)"}
- rel: {rel: option_refs, target: material-MAT_000383, ref_key1: MAT_000383, note: "블랙면지"}
- rel: {rel: option_refs, target: material-MAT_000384, ref_key1: MAT_000384, note: "그레이면지"}
- 본문: 074 면지 멤버의 색 선택 그룹(용지 드롭다운·기본 화이트). 자재 3종을 가리키며(OPT_REF_DIM.03), 그 자재는 같은 부모 074에 uses_material로 실재(L-18·fn_chk_opt_item_ref 정합). 면지=무가격이라 색 선택은 가격 미영향(제본비 포함). 폼빌더 정형 shape(§31·raw JSONLogic 금지). anchor는 위 파일 머리 주석 참조(재설계 junction·post-verify 확증).

### [optgroup-079-membrane-color] 면지색(화/블/그 3택1·레더 계열) {verified}
- type: option_group
- anchor: t_prd_products/PRD_000079
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-077-post-verify.md", source_locator: "§1 079 옵션그룹 OPT_065(활성 1)·옵션 화/블/그(활성 3)·옵션아이템(자재 ref OPT_REF_DIM.03)·§3 실화면. junction 복합키:(PRD_000079,OPT_000065)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-postverify}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.9 면지 색 옵션 멤버 이관(074 동형)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
- props: {opt_grp_cd: "OPT_000065", opt_grp_nm: "면지색", sel_typ_cd: "SEL_TYPE.01", mand: "손님 택1(기본 화이트)", 재설계: "부모 077→멤버 079 이관(부모 OPT_065 은퇴)"}
- rel: {rel: option_refs, target: material-MAT_000382, ref_key1: MAT_000382, note: "화이트면지(기본 dflt)"}
- rel: {rel: option_refs, target: material-MAT_000383, ref_key1: MAT_000383, note: "블랙면지"}
- rel: {rel: option_refs, target: material-MAT_000384, ref_key1: MAT_000384, note: "그레이면지"}
- 본문: 079 면지 멤버의 색 선택 그룹(074 동형). 자재 3종(MAT_382/383/384)이 같은 부모 079에 실재(L-18 정합). 면지=무가격(가격 미영향). anchor는 파일 머리 주석 참조.

## 계열 GAP

### [gap-set-leather-coverbind-delta] 레더/전용지 표지 자재 델타 미반영(COVERBIND use_dims 한계) {unknown}
- type: gap
- anchor: none  # 사유: 코드/엔진 한계(use_dims=[min_qty])라 t_*/xlsx 좌표 아님 — C트랙 결함 성격
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.5/§3.10/§5 레더 프리미엄·cover_mult ×2·COVERBIND use_dims=[min_qty] 한계(저청구 잔존·동작은 됨)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-077-post-verify.md", source_locator: "§2 077 apply 전=후 796,900(072와 동일 골든=표지 자재 델타 미반영 실증)", captured_at: "2026-07-03", badge: unknown, src_id: SR-23-postverify}
- gap_what: "072(전용지 표지)와 077(레더 표지)의 셋트 골든이 동일(34,100/159,100/796,900) — COMP_HC_MUSEON_COVERBIND의 use_dims=[min_qty]라 표지 자재(레더 vs 전용지) 델타가 가격에 반영 안 됨(레더 프리미엄 저청구·cover_mult ×2 인접)"
- gap_fill_from: "가격엔진 use_dims 확장(표지 자재 축 추가) 또는 표지 자재별 티어 분기 — 개발팀 C트랙([[rule/gaps#gap-set-088-redesign-pending]] 인접·redesign 계열). 동작은 됨(PRICE≠0)·저청구만"
- gap_owner: dev
- rel: {rel: derived_from, target: formula-PRF_HC_MUSEON_SET, note: "이 GAP은 COVERBIND 공식의 use_dims 한계에서 파생"}
- 본문: 하드커버/레더 계열이 COVERBIND 통가(use_dims=[min_qty]·자재 미종속)라 표지 자재 프리미엄이 가격에 안 실린다. 072/077 골든이 같은 근본 이유(무손상 실증=077-post-verify §2). 가격사실이 아니라 엔진 한계(C트랙)로 정직 표기 — 077/078 표지 노드가 derived_from 맥락에서 참조.
</content>
