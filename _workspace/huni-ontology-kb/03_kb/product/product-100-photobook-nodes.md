<!-- companion nodes for product-100 포토북 셋트 — 구성원 반제품(PRD_TYPE.02) 상품 노드 + 부모 표지타입 옵션그룹. -->
<!-- ★공유 파일(axis/*·formula/*) 수정 금지 — 여기는 클러스터 로컬(구성원 product 노드·optgroup)만. -->
<!-- ★셋트 관계: 부모 100이 has_member로 잇는다(product-100-photobook.md). 구성원 역방향=backlink 파생(schema에 member_of 없음). -->
<!-- ★고정가형: 표지 5종·면지는 자체 priced_by 없음(부모 all-in 귀속) → derived_from(부모 상품 product-100)으로 O5 충족(any→any·C-5 타깃 통일). -->
<!-- ★수치=awk live-snapshot 전사(손전사 금지). 자재/사이즈 축 노드 미민팅분은 상위 파일 전사표+needs_axis 권위. -->

# product-100 포토북 셋트 — 구성원 노드 (반제품 7 + 표지 옵션그룹)

[[product-100-photobook]] 셋트의 구성원 반제품(SEMI_ROLE.01 내지·.02 표지 택1·.03 면지)과
부모의 표지타입 택1 옵션그룹을 클러스터 로컬로 선언한다. 은퇴 구성원 없음(포토북 계열은 면지
재설계 대상 아님·전 구성원 del_yn=N). 표지 5종은 `has_member`로 부모에 매달리고, 가격은
부모 all-in(고정가형)이 표지 선택별로 담으므로 각 구성원은 `derived_from → [[product-100-photobook]]`(부모 상품 노드로 타깃 통일·C-5)으로만 가격 사슬을 잇는다.

---

### [product-101-photobook-inner] 포토북 내지(몽블랑130) {verified}
- type: product
- anchor: t_prd_products/PRD_000101
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000101 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.01·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000101) disp_seq=1 note '내지=몽블랑130'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: priced_by, target: formula-PRF_PHOTOBOOK_INNER, note: "추가2P당 내지 member 공식(base24P 초과·사이즈별)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.01", 역할: "내지", 자재: "MAT_000105 몽블랑 130g(USAGE.01·축 미민팅)", 판형: "SIZ_000499 국4절(316x467·활성·종이류)", note: "포토북 페이지 가변=base24P+추가2P당(page_rule). S1/S2 이중합산=전 책자 C트랙(gap-set-s1s2-double 인접)."}
- 본문: 포토북 내지 반제품(몽블랑130g). 유일하게 자체 가격공식(PRF_PHOTOBOOK_INNER·추가 페이지 단가)과 판형(국4절)을 보유. 부모 all-in의 base24P 위에 추가 페이지분을 얹는다([[book-set-page-pricing-inner-member]]).

### [product-102-photobook-cover-hardcover] 포토북 표지(하드커버) {verified}
- type: product
- anchor: t_prd_products/PRD_000102
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000102 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000102) disp_seq=2 note '표지=하드커버'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-100-photobook, note: "고정가형 부모 all-in에 표지 가격 귀속·자체 priced_by 없음(O5 충족·verbatim)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", 역할: "표지(택1)", 자재: "MAT_000005 하드커버(USAGE.02·축 미민팅)", 상태: "빈 껍데기(자체 축 0행)", 골든표지: "OPV_000484 하드커버=100부 1,500,000 기준선택"}
- 본문: 포토북 표지 반제품(하드커버). 자체 축·가격공식 없는 빈 껍데기 — 표지 선택별 가격은 부모 고정가공식(PRF_PHOTOBOOK_FIXED verbatim)이 담는다.

### [product-103-photobook-cover-art-matte] 포토북 표지(아트250+무광코팅) {verified}
- type: product
- anchor: t_prd_products/PRD_000103
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000103 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000103) disp_seq=3 note '표지=아트250+무광코팅'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-100-photobook, note: "고정가형 부모 all-in 귀속·자체 priced_by 없음(O5)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", 역할: "표지(택1)", 자재: "MAT_000250 아트250+무광코팅(USAGE.02·축 미민팅)", 상태: "빈 껍데기"}
- 본문: 포토북 표지 반제품(아트지 250g + 무광코팅). 빈 껍데기·부모 all-in 귀속.

### [product-104-photobook-membrane] 포토북 면지(그레이) {verified}
- type: product
- anchor: t_prd_products/PRD_000104
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000104 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.03·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000104) disp_seq=7 note '면지=그레이'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-100-photobook, note: "면지 무가격(기여0·제본비 포함)·부모 all-in 귀속으로 O5 충족"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.03", 역할: "면지", 자재: "MAT_000251 그레이(USAGE.03·축 미민팅)", 가격: "무가격(기여0·선택지 보존·삭제 금지)", note: "★100 포토북 면지=단일 그레이(1색). 072/082/088 계열의 '면지 1멤버 색 내부 택1'과 다름(그쪽만 재설계 대상)."}
- 본문: 포토북 면지 반제품(그레이·무가격). 제본비에 포함되어 가격 기여 0이나 선택지로 보존([HARD] 면지 자재 삭제 금지).

### [product-105-photobook-cover-leather-hardcover] 포토북 표지(레더하드커버) {verified}
- type: product
- anchor: t_prd_products/PRD_000105
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000105 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000105) disp_seq=4 note '표지=레더하드커버'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-100-photobook, note: "고정가형 부모 all-in 귀속·자체 priced_by 없음(O5)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", 역할: "표지(택1)", 자재: "MAT_000006 레더하드커버(USAGE.02·축 미민팅)", 상태: "빈 껍데기", note: "CPQ 표지타입 OPV_000485 레더하드커버 대응(3 CPQ 항목 중)"}
- 본문: 포토북 표지 반제품(레더하드커버). 빈 껍데기·부모 all-in 귀속.

### [product-106-photobook-cover-leather] 포토북 표지(레더) {verified}
- type: product
- anchor: t_prd_products/PRD_000106
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000106 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000106) disp_seq=5 note '표지=레더'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-100-photobook, note: "고정가형 부모 all-in 귀속·자체 priced_by 없음(O5)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", 역할: "표지(택1)", 자재: "MAT_000186 레더(USAGE.02·축 미민팅)", 상태: "빈 껍데기"}
- 본문: 포토북 표지 반제품(레더). 빈 껍데기·부모 all-in 귀속.

### [product-107-photobook-cover-softcover] 포토북 표지(소프트커버) {verified}
- type: product
- anchor: t_prd_products/PRD_000107
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000107 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000100,PRD_000107) disp_seq=6 note '표지=소프트커버'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-100-photobook, note: "고정가형 부모 all-in 귀속·자체 priced_by 없음(O5)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", 역할: "표지(택1)", 자재: "MAT_000007 소프트커버(USAGE.02·축 미민팅)", 상태: "빈 껍데기", note: "CPQ 표지타입 OPV_000486 소프트커버 대응"}
- 본문: 포토북 표지 반제품(소프트커버). 빈 껍데기·부모 all-in 귀속.

### [optgroup-100-cover] 표지타입 택1 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000100
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000100,OPT_000079) opt_grp_nm=표지타입·sel_typ=SEL_TYPE.01·min/max_sel=1·mand=Y·use=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options opt_grp_cd:OPT_000079 (OPV_000484 하드커버 dflt·OPV_000485 레더하드커버·OPV_000486 소프트커버)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000079", opt_grp_nm: "표지타입", sel_typ_cd: "SEL_TYPE.01", 선택: "손님 택1(mand)", items: "3(OPV_000484 하드커버 dflt·OPV_000485 레더하드커버·OPV_000486 소프트커버)", 주의: "★CPQ 표지타입 3종 vs has_member 표지 5종 불일치(102/103/105/106/107) — CPQ는 상위 3타입만 노출·골든 opt=OPV_000484. option_items ref_dim 없음(표지 자재는 부모 usage 슬롯)."}
- 본문: 포토북 표지타입 택1 CPQ 옵션그룹. option_items에 ref_dim 배선 없음(표지 자재는 부모 USAGE.02 슬롯에 적재)이라 option_refs 엣지 없음. CPQ 3항목(하드/레더하드/소프트) vs 셋트 구성원 표지 5종은 라이브 불일치 관찰(레더·아트무광이 CPQ 상위 타입에 미노출) — 골든 기준선택=OPV_000484 하드커버.
