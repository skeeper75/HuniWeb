---
id: product-284-hardcover-booklet-inner
type: product
anchor: t_prd_products/PRD_000284
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000284 (prd_typ_cd=PRD_TYPE.02 반제품·del_yn=N·prd_nm 하드커버책자-내지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:prd_cd=PRD_000284 (SIZ_000170 dflt·380·172)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000284,PRF_DGP_INNER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.2 사이즈(내지=가격 좌표 기준)·§3.4 페이지 가변·§3.10 내지 member 공식", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: uses_material, target: material-MAT_000073, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: uses_material, target: material-MAT_000076, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: uses_material, target: material-MAT_000077, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: uses_material, target: material-MAT_000086, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: uses_material, target: material-MAT_000087, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: uses_material, target: material-MAT_000095, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: uses_material, target: material-MAT_000104, note: "내지 종이(USAGE.07·live PRD_000284)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5 148x210(dflt)"}
  - {rel: has_size, target: size-SIZ_000380, note: "B5 182x257"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005·back CLR_000001)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(dflt·front/back CLR_000005)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·item SIZ_000499·fn_best_plate 자동선택)"}
  - {rel: priced_by, target: formula-PRF_DGP_INNER, note: "내지 구성원 공식(디지털 합가형·page 파생). 셋트 맥락 기여=FORMULA→0(COVERBIND all-in)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  role: "하드커버책자 내지 구성원(반제품)"
  page_rule: "24~300 / +2 (t_prd_product_sets min_cnt/max_cnt/cnt_incr·db_comment '구성원개수'=페이지수 오등록이나 load-bearing)"
  구분: "하드커버책자-내지(별도설정종이)"
standards: {schema_org: "Product", xjdf: "Product(내지 component)", config_ont: "component"}
answers_cq: ["하드커버책자 내지 사양·페이지 질의"]
tags: ["#셋트구성원", "#내지", "#반제품", "#책자"]
updated: 2026-07-03
---

# 하드커버책자-내지 (product-284-hardcover-booklet-inner)

하드커버책자 내지 구성원(PRD_000284·반제품 PRD_TYPE.02·SEMI_ROLE.01). 셋트
[[product-072-hardcover-booklet]]의 disp_seq2 멤버로, **가격 좌표의 기준 사이즈**다(표지는 책등 포함
펼침 사이즈라 가격표 좌표 밖 — 셋트 UI가 가격 낼 때 내지 siz_cd를 써야 함·팩 §3.2 [HARD]). 사이즈
3종(A5 dflt·B5·A4)·칼라 단/양면·국전 출력용지(종이류 판형·[[rule/rules#RULE_plate_paper_only]]). 페이지
가변(24~300/+2·page_rule). 가격은 내지 공식 [[formula/set-formulas#formula-PRF_DGP_INNER]](디지털 합가형).

- **셋트 맥락 기여 0**: 부모 COVERBIND 통가(all-in)라 내지 member는 evaluate_set_price에서 FORMULA→0 기여(072-post-verify §2).
- **★S1/S2 내지인쇄 이중합산**: 양면 주문 시 S1+S2 둘 다 매칭(배타선택 부재)=가격엔진 구조결함(전 책자 공통·코드 C트랙) → [[rule/gaps#gap-set-s1s2-double]].
- **내지 페이지 단가(D-2)** 후속 = [[rule/gaps#gap-set-inner-page-price]].

## 사이즈·인쇄·판형·자재 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_sizes+t_prd_product_print_options+t_prd_product_plate_sizes+t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000284 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨(master) | dflt | 축노드 |
|---|---|---|---|
| SIZ_000170 | A5 148x210 | Y | O(has_size·defect 노드) |
| SIZ_000380 | B5 182x257 | N | O(has_size) |
| SIZ_000172 | A4 210x297 | N | ✗ 축 미민팅(needs_axis) |

#### 인쇄옵션
<!-- transcribed-by: awk t_prd_product_print_options from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000284 @ 2026-07-03 -->
| opt_id | print_side | front_colr | back_colr | dflt | print_opt_cd |
|---|---|---|---|---|---|
| 1 | 단면 | CLR_000005 | CLR_000001 | N | POPT_000001 |
| 2 | 양면 | CLR_000005 | CLR_000005 | Y | POPT_000002 |

#### 판형
<!-- transcribed-by: awk t_prd_product_plate_sizes from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000284 @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | item |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 | PDF | (국전 출력용지·종이류) |

#### 자재 BOM (내지 용지·활성 9종·전부 USAGE.07)
자재 축 노드 미민팅(9종 전부·needs_axis) — `uses_material` 배선 없이 이 BOM 표가 권위(016 GAP_016_material 동류·[[rule/rules#RULE_import_material_no_delete]]).
<!-- transcribed-by: awk t_prd_product_materials+t_mat_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000284 @ 2026-07-03 -->
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

9종 자재·A4(SIZ_000172) 사이즈는 공유 축 노드 미민팅이라 그래프 배선 공백(조용한 누락 아님·정직 선언)
→ needs_axis 반환. 채움=축 소유자(Stage C/architect) 민팅 후 uses_material·has_size 확장.
</content>
