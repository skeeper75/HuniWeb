<!-- product-local sub-nodes: E7 bundle_qty·E11 option_group·addon 전사 for PRD_000154 아크릴 머리끈. -->
<!-- ★공유 노드 재사용(L-3): 면적 프리셋 사이즈(SIZ_000336/330/333)=product-146-acrylic-keyring-nodes canonical → 154 main이 has_size 참조. -->
<!--   formula-PRF_ACRYL_HAIRBAND·COMP_ACRYL_CLEAR3T·COMP_ACRYL_BLACK_HAIR_BAND=Stage A. material-MAT_000043=axis. category-CAT_000322=axis. -->
<!--   ★154 공정 0행(MISSING·GAP-AC-2) → process 노드 참조 없음(154 main has_process 미배선). -->
<!-- ★여기 정의: qty-154·optgroup-154-hairband. 헤어끈 addon(TMPL-000026)은 COMP_ACRYL_BLACK_HAIR_BAND와 이중표현(GAP-AC-6·전사표). -->

# product-154 하위 노드 (아크릴 머리끈 전용 — 수량·헤어끈 옵션·addon 이중표현)

아크릴 머리끈(PRD_000154)의 수량규칙·헤어끈 옵션그룹·블랙머리끈 addon. 면적 프리셋 사이즈는 CL-2 공유라
[[product-146-acrylic-keyring-nodes]] canonical(154 main이 has_size 참조).

## 헤어끈 부속 전사표 (이중표현·GAP-AC-6)

<!-- transcribed-by: acryl-price-chain-260704.csv + acryl-addon-templates-260704.csv @ 2026-07-04 -->
| 표현 | 코드 | 단가(원) | 배선 |
|---|---|---|---|
| 가격구성요소(priced 우선) | COMP_ACRYL_BLACK_HAIR_BAND | 500 | PRF_ACRYL_HAIRBAND has_component·use_dims=[opt_cd,min_qty,opt_grp:OPT-000014] |
| addon 템플릿(병기) | TMPL-000026 블랙머리끈 | 500 | t_prd_product_addons(대상 product 노드 없음→has_addon 엣지 미생성) |

> ★헤어끈 이중표현(GAP-AC-6·단가 500 동일·값 충돌 없음). priced_by 공식이 권위 배선·addon은 문서 접기.

## 수량규칙 노드 (product-local)

### [qty-154] 아크릴 머리끈 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000154
- src: {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000154 min_qty/max_qty/qty_incr(1/10000/1)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {min_max_incr: "1/10000/1", bdl_unit_typ_cd: "QTY_UNIT.01", note: "제품레벨 수량규칙·값=evaluate_price"}
- 본문: 수량 그릇(min 1·max 10000·incr 1). [[product-154-acrylic-hairband]] has_qty_rule 대상.

## 옵션그룹 노드 (CPQ)

### [optgroup-154-hairband] 헤어끈 (택1·필수·items 미적재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000154
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "키:PRD_000154 opt_grp_cd:OPT-000014(헤어끈·SEL_TYPE.01·mand_yn=Y·items 0)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "COMP_ACRYL_BLACK_HAIR_BAND use_dims opt_grp:OPT-000014(공식이 이 옵션그룹 참조)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {opt_grp_cd: "OPT-000014", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", items: 0, note: "헤어끈 선택 옵션그룹(필수 택1). 공식 COMP_ACRYL_BLACK_HAIR_BAND가 opt_grp:OPT-000014 참조하나 option_items 0행=선택지 미적재(GAP-AC-4·양면·§31)"}
- 본문: 손님 헤어끈 선택 CPQ 옵션그룹(SEL_TYPE.01 택1·mand_yn=Y). ★option_items 0행=미충전(GAP-AC-4). 배선 의도는 use_dims에 실재하나 UI item 미적재 → 현재값 정직 표기(§31/§7). [[product-154-acrylic-hairband]] has_option_group 대상.
