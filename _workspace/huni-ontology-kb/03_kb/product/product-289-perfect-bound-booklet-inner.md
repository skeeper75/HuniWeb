---
id: product-289-perfect-bound-booklet-inner
type: product
anchor: t_prd_products/PRD_000289
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000289 (prd_nm=무선책자-내지·prd_typ_cd=PRD_TYPE.02·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000289,PRF_DGP_INNER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.4 내지 페이지 가변·§3.12 구성원 역할·§1 인벤토리 069", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(live PRD_000289)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(live PRD_000289)"}
  - {rel: has_print_option, target: printopt-POPT_000008, note: "단면 흑백(live PRD_000289)"}
  - {rel: has_print_option, target: printopt-POPT_000009, note: "양면 흑백(live PRD_000289)"}
  - {rel: priced_by, target: formula-PRF_DGP_INNER}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·dflt"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택·SIZ_000499)"}
  - {rel: uses_material, target: material-MAT_000074, note: "백색모조지 220g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000081, note: "아트지 250g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000091, note: "스노우지 250g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000092, note: "스노우지 300g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g·USAGE.07"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  member_of: "product-069-perfect-bound-booklet"
  page_min: 24
  page_max: 300
  page_incr: 2
  구분: "무선책자 내지(반제품 구성원·페이지 가변)"
standards: {schema_org: "Product(부품)", xjdf: "Component(BookBlock)", config_ont: "component instance"}
tags: ["#셋트구성원", "#내지", "#무선제본", "#반제품", "#page파생"]
updated: 2026-07-03
---

# 무선책자 내지 (product-289-perfect-bound-booklet-inner)

무선책자 내지(PRD_000289)는 **반제품 구성원**(`PRD_TYPE.02`·역할 `SEMI_ROLE.01 내지`)으로, 셋트 부모
[[product-069-perfect-bound-booklet]]의 has_member(disp_seq=2)로 조립된다. 내지 기여 =
`evaluate_price(PRF_DGP_INNER)` → 부모 `evaluate_set_price` 합산.

- **가격(D-18 경계)**: [[formula/set-formulas#formula-PRF_DGP_INNER]](page 파생). 페이지 폭이 커서(24~300)
  내지 기여가 중철(287)보다 크다(100부 42,384 vs 18,438).
- **★페이지 가변([HARD])**: 셋트행 `min/max/incr = 24/300/2`(069 page_rule verbatim). db_comment "구성원 개수"는
  페이지수 오등록·load-bearing(§23-inner)·페이지 단가는 후속 [[rule/gaps#gap-set-inner-page-price]].
- **판형**: 종이류 → `plate-OUTPUT_PAPER_TYPE_01`(국전·SIZ_000499). 셋트 가격 기준 사이즈 = 내지(pack §3.2).
- **자재 배선**: 내지 자재 6종(MAT_000074/081/082/091/092/109·USAGE.07) 전부 공유 axis 노드 실재 →
  uses_material 전수 배선(형제 291과 동일 자재군). fn_chk_opt_item_ref 정합(전부 같은 부모 289 실재).

## 구성원 축 (BOM·전사표)

<!-- transcribed-by: awk t_prd_product_sizes.csv PRD_000289 from live-snapshot/latest @ 2026-07-03 -->
| siz_cd | dflt | 라벨 |
|---|---|---|
| SIZ_000170 | Y | A5(148x210) |
| SIZ_000172 | N | A4(210x297)·축 노드 미민팅 |

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000289 (USAGE.07) from live-snapshot/latest @ 2026-07-03 -->
| mat_cd | 자재명 | usage_cd | uses_material |
|---|---|---|---|
| MAT_000074 | 백색모조지 220g | USAGE.07 | O |
| MAT_000081 | 아트지 250g | USAGE.07 | O |
| MAT_000082 | 아트지 300g | USAGE.07 | O |
| MAT_000091 | 스노우지 250g | USAGE.07 | O |
| MAT_000092 | 스노우지 300g | USAGE.07 | O |
| MAT_000109 | 몽블랑 240g | USAGE.07 | O |

인쇄옵션 = 단면/양면 × CLR_000005(CMYK 4도)/CLR_000001(인쇄 안 함). CLR 기반이라 축 배선 없이 BOM 관찰.
</content>
