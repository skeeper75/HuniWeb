<!-- product-local sub-nodes: E7 bundle_qty·E11 option_group·addon 전사 for PRD_000147 아크릴마그넷. -->
<!-- ★공유 노드 재사용(L-3): 면적 프리셋 사이즈(SIZ_000336/330/331/333/334/011/148)=product-146-acrylic-keyring-nodes canonical → 147 main이 has_size 참조만(여기 재정의 안 함). -->
<!--   formula-PRF_ACRYL_MAGNET·component-COMP_ACRYL_CLEAR3T·COMP_ACRYL_MAGNET=Stage A formula/acrylic-formulas·acrylic-components → priced_by 참조. -->
<!--   material-MAT_000043=axis/materials·process-PROC_000002=axis/processes·PROC_000081=product-138-nodes → 재사용. category-CAT_000322=axis/categories. -->
<!-- ★여기 정의: qty-147·optgroup-147-magnet. 자석 addon(TMPL-000014)은 옵션구성요소 COMP_ACRYL_MAGNET와 이중표현(GAP-AC-6·전사표로 접음). -->

# product-147 하위 노드 (아크릴마그넷 전용 — 수량·자석 옵션·addon 이중표현)

아크릴마그넷(PRD_000147)의 수량규칙·자석 옵션그룹·자석부착 addon. 면적 프리셋 사이즈는 CL-2 공유라
[[product-146-acrylic-keyring-nodes]]가 canonical 정의(147 main이 동일 id has_size 참조).

## 자석 부속 전사표 (이중표현·GAP-AC-6)

<!-- transcribed-by: acryl-price-chain-260704.csv + acryl-addon-templates-260704.csv @ 2026-07-04 -->
| 표현 | 코드 | 단가(원) | 배선 |
|---|---|---|---|
| 가격구성요소(priced 우선) | COMP_ACRYL_MAGNET | 800 | PRF_ACRYL_MAGNET has_component·use_dims=[opt_cd,min_qty,opt_grp:OPT_000074] |
| addon 템플릿(병기) | TMPL-000014 자석부착(네오디움12mm) | 800 | t_prd_product_addons(대상 product 노드 없음→has_addon 엣지 미생성) |

> ★자석이 옵션구성요소와 addon 템플릿으로 **이중표현**(GAP-AC-6). 단가 동일(800)이라 값 충돌은 없으나
> 표현 이중성 정합은 §34/§7 대기. priced_by 공식(has_component)이 권위 배선·addon은 문서 접기.

## 수량규칙 노드 (product-local)

### [qty-147] 아크릴마그넷 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000147
- src: {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000147 min_qty/max_qty/qty_incr(1/10000/1)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {min_max_incr: "1/10000/1", bdl_unit_typ_cd: "QTY_UNIT.01", note: "제품레벨 수량규칙·값=evaluate_price"}
- 본문: 수량 그릇(min 1·max 10000·incr 1). [[product-147-acrylic-magnet]] has_qty_rule 대상.

## 옵션그룹 노드 (CPQ)

### [optgroup-147-magnet] 자석 (택1·필수·items 미적재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000147
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "키:PRD_000147 opt_grp_cd:OPT_000074(자석·SEL_TYPE.01·mand_yn=Y·items 0)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "COMP_ACRYL_MAGNET use_dims opt_grp:OPT_000074(공식이 이 옵션그룹 참조)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {opt_grp_cd: "OPT_000074", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", items: 0, note: "자석 선택 옵션그룹(필수 택1). 공식 구성요소 COMP_ACRYL_MAGNET가 opt_grp:OPT_000074 참조하나 option_items 0행=선택지 미적재(GAP-AC-4·양면·§31 대기)"}
- 본문: 손님 자석 선택 CPQ 옵션그룹(SEL_TYPE.01 택1·mand_yn=Y). ★option_items 0행 = 선택지 미충전(GAP-AC-4). 가격구성요소 use_dims는 opt_grp:OPT_000074를 참조하므로 배선 의도는 실재하나 UI item 미적재 → 현재값 정직 표기(§31/§7). [[product-147-acrylic-magnet]] has_option_group 대상.
