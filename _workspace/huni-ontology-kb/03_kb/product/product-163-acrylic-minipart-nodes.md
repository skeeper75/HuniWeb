<!-- product-local sub-nodes: E3 size(1)·qty for PRD_000163 아크릴미니파츠. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - formula-PRF_ACRYL_MINIPART·component-COMP_ACRYL_MINIPART_TBD = Stage A 공유(formula/acrylic-formulas.md·acrylic-components.md) → 참조만. main이 priced_by. -->
<!--   - material-MAT_000042(1.5mm)·process-PROC_000002(UV)·gap-acryl-tbd-formula-no-priced-rows = Stage A 공유 → 참조만. -->
<!-- ★여기 정의(163 고유): size 1(SIZ_000365 120x50)·qty. -->
<!-- ★수치(치수)는 아래 전사표(transcribed-by)에만(D-9·L-12). 가격 값은 미전사(evaluate_price 권위·D-18). -->

# product-163 하위 노드 (아크릴미니파츠 전용 사이즈·수량)

아크릴미니파츠(PRD_000163)가 쓰는 규격 사이즈 1행(120x50)·수량규칙. 상품→축 연결
(has_size·has_qty_rule)은 [[product-163-acrylic-minipart]]가 건다.

## 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: awk t_siz_sizes.csv+t_prd_product_sizes.csv PRD_000163 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 | 작업(work mm) | del_yn |
|---|---|---|---|
| SIZ_000365 | 120x50 | 120x50 | N |

## 사이즈 노드 (product-local — 규격 1행)

### [size-SIZ_000365] 120x50 규격 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000365
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000365(siz_nm=120x50·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000163,SIZ_000365) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000365(120x50)", note: "아크릴미니파츠 규격 120x50mm. 고정가형 공식 use_dims의 siz_cd 차원. [[product-163-acrylic-minipart]] has_size 대상"}
- 본문: 아크릴미니파츠 120x50 규격(단일). 공식 [[formula-PRF_ACRYL_MINIPART]]가 이 siz_cd로 단가(placeholder)를 조회.

## 수량규칙 노드 (product-local)

### [qty-163] 아크릴미니파츠 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000163
- src: {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000163 min_qty/max_qty/qty_incr(1/10000/1)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {min_max_incr_ref: "전사(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", note: "수량축은 공식 use_dims의 min_qty로 반영. 값=evaluate_price"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min1/max10000/incr1·QTY_UNIT.01). 고정가형 공식이 min_qty를 가격차원으로 참조.
