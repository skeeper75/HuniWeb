---
id: product-285-leather-hardcover-booklet-inner
type: product
anchor: t_prd_products/PRD_000285
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000285 (prd_typ_cd=PRD_TYPE.02 반제품·reg 2026-06-30·prd_nm 레더 하드커버책자-내지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:prd_cd=PRD_000285 (SIZ_000170 dflt·380·172·284 동형)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000285,PRF_DGP_INNER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.2/§3.4/§3.10 내지 축(285=284 동형)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: uses_material, target: material-MAT_000073, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: uses_material, target: material-MAT_000076, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: uses_material, target: material-MAT_000077, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: uses_material, target: material-MAT_000086, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: uses_material, target: material-MAT_000087, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: uses_material, target: material-MAT_000095, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: uses_material, target: material-MAT_000104, note: "내지 종이(USAGE.07·live PRD_000285)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5 148x210(dflt)"}
  - {rel: has_size, target: size-SIZ_000380, note: "B5 182x257"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005·back CLR_000001)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(dflt·front/back CLR_000005)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·item SIZ_000499)"}
  - {rel: priced_by, target: formula-PRF_DGP_INNER, note: "내지 구성원 공식(디지털 합가형). 셋트 맥락 기여=FORMULA→0(COVERBIND all-in)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  role: "레더 하드커버책자 내지 구성원(반제품)"
  page_rule: "24~300 / +2 (t_prd_product_sets·284 동형)"
  구분: "레더 하드커버책자-내지(별도설정종이)"
standards: {schema_org: "Product", xjdf: "Product(내지 component)", config_ont: "component"}
answers_cq: ["레더 하드커버책자 내지 사양·페이지 질의"]
tags: ["#셋트구성원", "#내지", "#반제품", "#책자", "#레더"]
updated: 2026-07-03
---

# 레더 하드커버책자-내지 (product-285-leather-hardcover-booklet-inner)

레더 하드커버책자 내지 구성원(PRD_000285·반제품·SEMI_ROLE.01). 셋트
[[product-077-leather-hardcover-booklet]]의 disp_seq2 멤버·**284 하드커버책자 내지와 완전 동형**(사이즈
A5/B5/A4·단/양면·국전 출력용지·페이지 24~300/+2·자재 9종 동일·PRF_DGP_INNER). 내지가 가격 좌표
기준 사이즈다(팩 §3.2 [HARD]).

- **셋트 맥락 기여 0**: COVERBIND all-in → evaluate_set_price FORMULA→0(077-post-verify §2).
- **S1/S2 이중합산** = [[rule/gaps#gap-set-s1s2-double]] · 내지 페이지 단가 = [[rule/gaps#gap-set-inner-page-price]].

## 사이즈·인쇄·판형·자재 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_sizes+t_prd_product_print_options+t_prd_product_plate_sizes+t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000285 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨(master) | dflt | 축노드 |
|---|---|---|---|
| SIZ_000170 | A5 148x210 | Y | O(has_size) |
| SIZ_000380 | B5 182x257 | N | O(has_size) |
| SIZ_000172 | A4 210x297 | N | ✗ 축 미민팅(needs_axis) |

#### 인쇄옵션
<!-- transcribed-by: awk t_prd_product_print_options from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000285 @ 2026-07-03 -->
| opt_id | print_side | front_colr | back_colr | dflt | print_opt_cd |
|---|---|---|---|---|---|
| 1 | 단면 | CLR_000005 | CLR_000001 | N | POPT_000001 |
| 2 | 양면 | CLR_000005 | CLR_000005 | Y | POPT_000002 |

#### 판형
<!-- transcribed-by: awk t_prd_product_plate_sizes from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000285 @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | item |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 | PDF | (국전 출력용지·종이류) |

#### 자재 BOM (내지 용지·활성 9종·전부 USAGE.07·284 동형)
자재 축 노드 미민팅(9종·needs_axis) — `uses_material` 배선 없이 이 BOM 표가 권위.
<!-- transcribed-by: awk t_prd_product_materials+t_mat_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000285 @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt |
|---|---|---|---|
| MAT_000072 | 백색모조지 100g | USAGE.07 | Y |
| MAT_000073 | 백색모조지 120g | USAGE.07 | N |
| MAT_000086 | 스노우지 100g | USAGE.07 | N |
| MAT_000087 | 스노우지 120g | USAGE.07 | N |
| MAT_000076 | 아트지 100g | USAGE.07 | N |
| MAT_000077 | 아트지 120g | USAGE.07 | N |
| MAT_000104 | 몽블랑 100g | USAGE.07 | N |
| MAT_000105 | 몽블랑 130g | USAGE.07 | N |
| MAT_000095 | 앙상블 100g | USAGE.07 | N |

9종 자재·A4는 공유 축 미민팅 → needs_axis 반환(그래프 배선 공백·정직 선언).
</content>
