<!-- product-local sub-nodes: E3 size(면적 프리셋·CL-2 공유)·E7 bundle_qty·E11 option_group·addon 전사 for PRD_000146 아크릴키링. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - formula-PRF_CLR_ACRYL·component-COMP_ACRYL_CLEAR3T = Stage A formula/acrylic-formulas.md·acrylic-components.md 정의 → 여기서 재정의 안 함(146 main이 priced_by로 참조만). -->
<!--   - material-MAT_000043(3mm substrate)=axis/materials.md·process-PROC_000111/000151=axis/processes.md·PROC_000124=product-143-nodes → 재사용. -->
<!--   - category-CAT_000322(단품형)=axis/categories.md 정의 → 146 main이 in_category 참조. -->
<!-- ★여기 정의(CL-2 공유·아직 미민팅): 면적 프리셋 사이즈 10종(146/147/149/154 공유 canonical)·qty-146·optgroup-146-ring. -->
<!--   ★면적 프리셋 사이즈(SIZ_000011/148/329~336)는 CL-1(148/150/157 등)도 소비하는 shared axis라 향후 axis/sizes.md 승격 필요 → needs_axis 반환(잠정 product-local·146-nodes canonical). -->
<!-- ★수치(치수 라벨)는 아래 전사표(live-snapshot 구조축 FRESH·grep 전사)에만. 가격 값(unit_price)은 미전사(D-18·값=evaluate_price). -->

# product-146 하위 노드 (아크릴키링 전용 축 원자 + 면적 프리셋 공유 + 옵션/addon)

아크릴키링(PRD_000146)이 쓰는 면적 프리셋 사이즈 8종·수량규칙·고리 옵션그룹·볼체인 addon 8종. 상품→축
연결(has_size·uses_material·has_process·priced_by·has_option_group·has_qty_rule)은
[[product-146-acrylic-keyring]]가 건다. ★면적 프리셋 사이즈는 CL-2(146/147/149/154) 공유라 이 파일이
**canonical 정의**(147/149/154는 동일 id를 has_size로 참조·cross-file id 해소).

## 면적 프리셋·판형 전사표 (권위 = 라이브 구조축)

<!-- transcribed-by: grep t_prd_product_sizes.csv + t_siz_sizes.csv from live-snapshot/latest (snap_20260702_1119·구조축 FRESH) PRD_000146 @ 2026-07-04 -->
| siz_cd | 라벨(mm) | dflt_yn | 소비 상품(CL-2) |
|---|---|---|---|
| SIZ_000329 | 20x30 | Y | 146 |
| SIZ_000330 | 30x30 | Y | 146·147·149·154 |
| SIZ_000331 | 30x40 | Y | 146·147 |
| SIZ_000332 | 30x70 | Y | 146 |
| SIZ_000333 | 40x40 | Y | 146·147·149·154 |
| SIZ_000334 | 40x50 | Y | 146·147 |
| SIZ_000335 | 40x60 | Y | 146 |
| SIZ_000011 | 50x50 | Y | 146·147·149 |
| SIZ_000336 | 20x20 | Y | 147·154 |
| SIZ_000148 | 60x60 | Y | 147 |

> ★146 snapshot 8행(위 329~335+011). 07-04 summary=9행(1행 신규 드리프트·병행 세션). 336/148은 147용
> (146 미소비)이나 CL-2 공유 canonical이라 여기 함께 정의. 프리셋은 면적매트릭스 W×H **입력값**이며 유효
> 가격 권위 = `COMP_ACRYL_CLEAR3T` 셀단가(pack §3.2·값=evaluate_price).

<!-- transcribed-by: grep t_prd_product_addons.csv + t_prd_templates.csv from acryl-addon-templates-260704.csv @ 2026-07-04 -->
| tmpl_cd | 부속명 | 단가(원) | disp_seq |
|---|---|---|---|
| TMPL-000056 | 칼라볼체인(오렌지) 3개1팩 | 1,000 | 1 |
| TMPL-000057 | 칼라볼체인(핑크) 3개1팩 | 1,000 | 2 |
| TMPL-000058 | 칼라볼체인(민트그린) 3개1팩 | 1,000 | 3 |
| TMPL-000059 | 칼라볼체인(바이올렛) 3개1팩 | 1,000 | 4 |
| TMPL-000060 | 칼라볼체인(블루) 3개1팩 | 1,000 | 5 |
| TMPL-000061 | 칼라볼체인(핫핑크) 3개1팩 | 1,000 | 6 |
| TMPL-000062 | 칼라볼체인(화이트) 3개1팩 | 1,000 | 7 |
| TMPL-000063 | 칼라볼체인(블랙) 3개1팩 | 1,000 | 8 |

> `has_addon`의 실 배선=product→template(tmpl_cd)→`t_prd_templates`. 볼체인은 판매 universe 상품이 아니라
> 부자재 템플릿이라 대상 product 노드가 없어 `has_addon` 엣지를 걸면 끊긴 링크가 된다(024 선례) → 노드
> 미생성·전사표로 접음(SA-5 카탈로그·[[formula/acrylic-formulas]] 하단 참조). 손님 택1(always-add 아님)·
> 본체 면적가와 별도합산(pack §3.12).

## 면적 프리셋 사이즈 노드 (CL-2 공유 canonical — axis/sizes.md 승격 대기·needs_axis)

<!-- ★이 10종은 146/147/149/154(CL-2) 공유 area preset. CL-1(148/150/157 등)도 일부 소비 예상 → shared axis 후보. -->
<!-- 잠정 product-local(146-nodes canonical). 병렬 CL-1 빌더가 동일 코드 재정의 시 L-3 충돌 → 검증 루프가 axis 승격으로 reconcile(needs_axis 반환). -->

## 수량규칙 노드 (product-local)

### [qty-146] 아크릴키링 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000146
- src: {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000146 min_qty/max_qty/qty_incr(1/10000/1)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {min_max_incr: "1/10000/1", bdl_unit_typ_cd: "QTY_UNIT.01", note: "제품레벨 수량규칙. 면적매트릭스 use_dims에 min_qty 포함(수량 티어)·값=evaluate_price"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). [[product-146-acrylic-keyring]] has_qty_rule 대상.

## 옵션그룹 노드 (CPQ)

### [optgroup-146-ring] 고리 (택1·items 미적재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000146
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "키:PRD_000146 opt_grp_cd:OPT_000157(고리·mand_yn=N·items 0)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {opt_grp_cd: "OPT_000157", mand_yn: "N", items: 0, ref_dim: "미적재(GAP-AC-4)", note: "고리 선택 옵션그룹이나 option_items 0행 — 선택지 미적재(양면·§31 대기). 은/금 고리(MAT_000051/052)·군번줄(MAT_000456)이 실 부속이나 옵션 item으로 미배선"}
- 본문: 손님 고리 선택 CPQ 옵션그룹(택1). ★option_items 0행 = 선택지 미적재(GAP-AC-4). 실 부속(은/금 고리·군번줄)은 자재(dflt_yn=N)로만 존재하고 옵션 item 배선 부재 → 현재값 정직 표기(§31/§7 대기). [[product-146-acrylic-keyring]] has_option_group 대상.
