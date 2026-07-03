<!-- 082 하드커버 링책자 클러스터-로컬 노드: 면지멤버 옵션그룹(OPT_066)·내지 페이지 수량규칙. -->
<!-- 부모/구성원 product 노드는 product-082-hardcover-ring-booklet.md. 공유 축(materials/formula)은 참조만. -->

# 082 하드커버 링책자 — 클러스터-로컬 노드

면지멤버(084) 색 택1 옵션그룹 + 내지(286) 페이지 수량규칙. 셋트 특유의 로컬 CPQ·수량 축.

### [optgroup-084-membrane] 면지 색(용지 드롭다운·4택1) {verified}
- type: option_group
- anchor: t_prd_products/PRD_000084
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-082-post-verify.md", source_locator: "§1 084 옵션그룹 복합키:(PRD_000084,OPT_066)(활성 1)·옵션 화/블/그/인쇄(활성 4)·옵션아이템 4(자재 ref OPT_REF_DIM.03·OPV_443→MAT_385). ★부모측 앵커 t_prd_products/PRD_000084(면지 재설계 2026-07-03·20260702_1119 스냅샷 이후·junction 복합키는 이 locator로 확증)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-membrane}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000084,OPT_066) (면지 재설계 2026-07-03 COMMIT·부모 082 OPT_066 은퇴)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_066", opt_grp_nm: "면지(용지)", sel_typ: "SEL_TYPE.01(택1)", mand: "손님 택1(기본 화이트)", 참조: "자재 4종(OPT_REF_DIM.03)"}
- rel: {rel: option_refs, target: material-MAT_000382, ref_key1: MAT_000382, note: "화이트면지(dflt)"}
- rel: {rel: option_refs, target: material-MAT_000383, ref_key1: MAT_000383, note: "블랙면지"}
- rel: {rel: option_refs, target: material-MAT_000384, ref_key1: MAT_000384, note: "그레이면지"}
- rel: {rel: option_refs, target: material-MAT_000385, ref_key1: MAT_000385, note: "인쇄면지(OPV_443→MAT_385)"}
- 본문: 면지 색 택1 그룹(재설계로 부모 082→면지멤버 084로 이관). option_refs 4종은 부모(084) uses_material에 실재(fn_chk_opt_item_ref·L-18 정합). 면지 = 무가격(기여0·색 선택만). 부모 멤버=[[product-082-hardcover-ring-booklet-membrane]]. ★부모 082의 OPT_066은 은퇴(활성 0·082-post-verify §1).

### [qty-286-inner-page] 내지 페이지 수량규칙(8~100/+2) {verified}
- type: bundle_qty
- anchor: t_prd_product_sets/PRD_000082
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000082,PRD_000286) min_cnt=8·max_cnt=100·cnt_incr=2·note '내지=별도설정종이·페이지8~100/+2'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.4 내지 페이지 가변(★db_comment '구성원 개수'이나 실은 페이지수·load-bearing)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
- props: {min_cnt: 8, max_cnt: 100, cnt_incr: 2, unit: "페이지(내지)", note: "★db_comment '구성원 개수' 오등록이나 실제=페이지수·memberMulti 수량입력=페이지 선택·load-bearing(미변경·페이지 단가 무손상 [HARD])·pack §3.4"}
- 본문: 내지(286) 페이지 가변 수량규칙(8~100·2 증분). 셋트행(t_prd_product_sets) min/max/incr 컬럼이 페이지 가변을 담는다(★072/077 24~300과 다름·pack §1). db_comment 라벨은 "구성원 개수"이나 실은 페이지수(오등록·but 작동에 물림·미변경). 내지 페이지 단가(D-2·후속)=[[rule/gaps#gap-set-inner-page-price]]. 사용처(내지 member)=[[product-082-hardcover-ring-booklet-inner]].
