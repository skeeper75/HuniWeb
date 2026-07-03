---
id: product-001-opp-adhesive-envelope
type: product
anchor: t_prd_products/PRD_000001
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000001 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.4 봉투류 001 OPP접착봉투(NEITHER-gap)·§0.1 기성.03·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(t_prd_product_price_formulas 0행·t_prd_product_prices 0행)=NEITHER-gap. O5 충족(priced_by 없음)"}
props:
  prd_typ_cd: "PRD_TYPE.03"
  archetype: "기성(제조없음)·NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 100
  qty_incr: 1
  file_upload_yn: "N"
  editor_yn: "N"
  addon_target_of: "016 프리미엄엽서(TMPL-000005)·엽서 계열 봉투 추가상품 base_prd"
standards: {schema_org: "Product", xjdf: "Product(봉투/Envelope)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(OPP접착봉투 규격)", "봉투 추가상품 대상 확인"]
tags: ["#봉투", "#기성상품", "#NEITHER-gap", "#addon대상"]
updated: 2026-07-04
---

# OPP접착봉투 (product-001-opp-adhesive-envelope)

OPP접착봉투(PRD_000001)는 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음·
[[product-type-classification-sot]]). 라이브 실측상 `t_prd_product_sets` 부모/구성원 등록이 없어
셋트가 아니고, 디자인상품도 아니다. 파일 업로드·에디터 모두 미사용(`file_upload_yn=N`·`editor_yn=N`).
최소 1·최대 100·증분 1(낱봉투/묶음 단위). 규격 SKU는 미리 정해진 봉투 사이즈(70x200~230x350mm)로만
고른다 — 인쇄·제작 공정이 없는 **완성 기성품**이다.

- **정체:** 라이브 `t_prd_products`(prd_cd 실재·기성.03) + 팩 §1.4/§0.1(기성=제조없음). ★팩 §1.4 초기
  서술은 001을 `.01`로 표기했으나 라이브 실측은 `PRD_TYPE.03`(기성) — 라이브 정직 표기(권위 순서상
  라이브 현재값 채택, gap-goods-neither §gap_what와 정합).
- **가격 경계(D-18)/NEITHER-gap:** 이 상품은 가격공식(`t_prd_product_price_formulas`)도 고정가
  (`t_prd_product_prices`)도 **둘 다 0행** = 견적 원천 부재(NEITHER-gap). 값 계산 이전에 원천 자체가
  없으므로 "가격 있는 것처럼" 표기하지 않는다 → [[gap-goods-neither]](공유 GAP·정직 선언).
- **판형 없음:** OPP(비종이·필름) + 완성 기성품이라 판형(plate_size)·판걸이수 해당 없음
  ([[rule/rules#RULE_plate_paper_only]] 종이류만 판형·라이브 `t_prd_product_plate_sizes` 0행).

## 규격(사이즈) — 관찰 전사 (기성 SKU·가격 미연결)

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv (del_yn≠Y) PRD_000001 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 |
|---|---|
| SIZ_000078 | 70x200mm |
| SIZ_000079 | 80x100mm |
| SIZ_000080 | 80x120mm |
| SIZ_000081 | 80x180mm |
| SIZ_000082 | 90x120mm |
| SIZ_000083 | 100x100mm |
| SIZ_000084 | 100x200mm |
| SIZ_000085 | 110x160mm |
| SIZ_000086 | 130x200mm |
| SIZ_000087 | 160x230mm |
| SIZ_000088 | 230x350mm |

활성 11행. 사이즈 축 노드([[axis/sizes]])는 이 봉투 규격 SKU를 미민팅 → `has_size` 그래프 배선은 대기
(위 전사표가 관찰 권위). 이 규격은 봉투 완성품의 물리 크기이지 인쇄 조판 사이즈가 아니다(impos 개념 없음).

## 자재(BOM) — 관찰 전사 (자기참조 변형 SKU)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000001 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
활성 11행 · 전부 usage_cd=USAGE.07 단일 슬롯. 자재명이 곧 봉투 규격 변형("OPP접착봉투 NN x NN mm")
= 기성품 자기참조 SKU(외부 substrate 자재가 아님). 대표: MAT_000497(70x200) ~ MAT_000507(230x350).
`uses_material` 그래프 배선은 이 변형 SKU를 자재 축에 미민팅이라 대기(관찰 권위=전사).

## 옵션·제약·추가상품

- **CPQ 옵션그룹:** 라이브 `t_prd_product_option_groups` = 001 행 1개(OPT-000003 "테스트")이나
  **del_yn=Y**(삭제된 테스트 스캐폴딩) → 활성 옵션 없음. 노드 미등재(정직 기록).
- **제약규칙:** `t_prd_product_constraints` = 001 행 3개(RULE_001/002/003 "금지테스트"·err_msg "앵앵앵앵")
  전부 **del_yn=Y**(삭제된 테스트 잔재) → 활성 제약 없음. 환각 제약 금지(노드 미등재).
- **추가상품(피참조):** 001은 다른 상품의 봉투 **추가상품 대상**(base_prd)이다 — 프리미엄엽서(016)의
  `TMPL-000005`(OPP접착봉투 110x160 50장)이 이 상품을 가리킨다. `has_addon`은 엽서 쪽(016)에서 이
  노드로 배선한다(product→product·R14). 이 노드 생성으로 [[gap-016-addon-target]] 대상 상품 부재가
  일부 해소 가능(엣지 배선·라벨 갱신은 Stage C/검증가 소관).
