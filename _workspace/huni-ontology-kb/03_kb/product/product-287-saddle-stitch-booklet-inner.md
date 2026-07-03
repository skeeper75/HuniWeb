---
id: product-287-saddle-stitch-booklet-inner
type: product
anchor: t_prd_products/PRD_000287
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000287 (prd_nm=중철책자-내지·prd_typ_cd=PRD_TYPE.02·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000287,PRF_DGP_INNER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.4 내지 페이지 가변·§3.12 구성원 역할·§1 인벤토리 068", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: uses_material, target: material-MAT_000073, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: uses_material, target: material-MAT_000076, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: uses_material, target: material-MAT_000077, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: uses_material, target: material-MAT_000086, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: uses_material, target: material-MAT_000087, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: uses_material, target: material-MAT_000095, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: uses_material, target: material-MAT_000104, note: "중철내지 종이(USAGE.07·live PRD_000287)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(live PRD_000287)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(live PRD_000287)"}
  - {rel: has_print_option, target: printopt-POPT_000008, note: "단면 흑백(live PRD_000287)"}
  - {rel: has_print_option, target: printopt-POPT_000009, note: "양면 흑백(live PRD_000287)"}
  - {rel: priced_by, target: formula-PRF_DGP_INNER}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·dflt"}
  - {rel: has_size, target: size-SIZ_000380, note: "B5(182x257)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택·SIZ_000499)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  member_of: "product-068-saddle-stitch-booklet"
  page_min: 4
  page_max: 28
  page_incr: 4
  구분: "중철책자 내지(반제품 구성원·페이지 가변)"
standards: {schema_org: "Product(부품)", xjdf: "Component(BookBlock)", config_ont: "component instance"}
tags: ["#셋트구성원", "#내지", "#중철", "#반제품", "#page파생"]
updated: 2026-07-03
---

# 중철책자 내지 (product-287-saddle-stitch-booklet-inner)

중철책자 내지(PRD_000287)는 **반제품 구성원**(`prd_typ_cd=PRD_TYPE.02`·역할 `SEMI_ROLE.01 내지`)으로,
셋트 부모 [[product-068-saddle-stitch-booklet]]의 has_member(disp_seq=2)로 조립된다. 셋트 가격에서 내지
기여는 `evaluate_price(PRF_DGP_INNER)`로 계산되어 부모 `evaluate_set_price`에 합산된다.

- **가격(D-18 경계)**: [[formula/set-formulas#formula-PRF_DGP_INNER]](page 파생·디지털 계열). 내지 가격 =
  부수 × ⌈page/판걸이수⌉ 구조(page 파생·pack §3.4). 값 계산은 견적 엔진 권위.
- **★페이지 가변([HARD])**: 셋트행 `min_cnt/max_cnt/cnt_incr = 4/28/4`(068 page_rule verbatim). db_comment상
  "구성원 개수"이나 실제 = **페이지수 오등록·but load-bearing**(memberMulti 수량입력 = 페이지 선택). 표시 라벨
  정정은 가격 무손상(§23-inner)·내지 페이지 단가는 후속 [[rule/gaps#gap-set-inner-page-price]].
- **판형**: 종이류 → `plate-OUTPUT_PAPER_TYPE_01`(국전·fn_best_plate 자동선택·SIZ_000499). 셋트 가격 좌표의
  기준 사이즈 = 내지(표지 펼침 siz는 가격표 좌표 밖·pack §3.2).
- **자재 커버리지**: 내지 자재 9종(백색모조지120/앙상블100 등 USAGE.07)은 공유 axis 미민팅 → 아래 BOM 표가
  권위(needs_axis 반환). 형제 289/291 내지는 자재 6종 전부 축 노드 실재라 uses_material 배선됨(이 287만 자재군 상이).

## 구성원 축 (BOM·전사표)

<!-- transcribed-by: awk t_prd_product_sizes.csv PRD_000287 from live-snapshot/latest @ 2026-07-03 -->
| siz_cd | dflt | 라벨 |
|---|---|---|
| SIZ_000170 | Y | A5(148x210) |
| SIZ_000380 | N | B5(182x257) |
| SIZ_000172 | N | A4(210x297)·축 노드 미민팅 |

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000287 (USAGE.07·del_yn≠Y) from live-snapshot/latest @ 2026-07-03 -->
| mat_cd | usage_cd | 비고 |
|---|---|---|
| MAT_000072 | USAGE.07 | 백색모조지 100g 계열(중철내지·축 미민팅) |
| MAT_000073 | USAGE.07 | 백색모조지 120g |
| MAT_000076 | USAGE.07 | 아트지 100g 계열 |
| MAT_000077 | USAGE.07 | 아트지 120g |
| MAT_000086 | USAGE.07 | 스노우지 100g 계열 |
| MAT_000087 | USAGE.07 | 스노우지 120g |
| MAT_000095 | USAGE.07 | 앙상블 100g |
| MAT_000104 | USAGE.07 | 몽블랑 100g |
| MAT_000105 | USAGE.07 | 몽블랑 130g |

인쇄옵션 = 단면/양면 × CLR_000005(CMYK 4도)/CLR_000001(인쇄 안 함=뒷면 도수코드). POPT 매핑 아닌 CLR 기반이라
축 배선 없이 BOM 관찰만.
</content>
