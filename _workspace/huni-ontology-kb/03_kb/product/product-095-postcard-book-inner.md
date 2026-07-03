---
id: product-095-postcard-book-inner
type: product
anchor: t_prd_products/PRD_000095
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000095 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.01·del_yn=N)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1(094 구성원 095 내지)·§3.4 내지 페이지 가변·§3.5 자재 멤버 이관", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000026, note: "엽서북(구성원 카테고리·main·live)"}
  - {rel: has_plate_size, target: plate-SIZ_000499-gukc4, note: "국4절(316x467) 내지 판형(live PRD_000095)"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g(USAGE.01 내지종이·현재 DB 멤버 귀속)"}
  - {rel: derived_from, target: product-094-postcard-book, note: "가격이 부모 094 고정가 all-in(PRF_PCB_FIXED)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000095=0행 live 재실측). 082/100 클러스터 동형(083/084/104=derived_from 부모)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  구분: "엽서북 내지(반제품 구성원)"
  parent: "product-094-postcard-book"
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product(반제품)", xjdf: "Component(내지)", config_ont: "assembly member"}
answers_cq: ["엽서북 내지 구성(반제품)"]
tags: ["#셋트", "#반제품", "#엽서북", "#내지"]
updated: 2026-07-03
---

# 엽서북 내지 (product-095-postcard-book-inner)

엽서북 내지(PRD_000095·몽블랑240)는 셋트 [[product-094-postcard-book]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.01 내지). 셋트 관계는 부모의 `has_member`(R13)로 1급 표현되며
(스키마 19관계에 member_of 없음 — 역방향은 빌더 backlinks 파생), 이 노드는 부모를 [[product-094-postcard-book]]로
참조한다.

- **가격(★고정가형 흡수)**: 내지 자체 가격공식 없음. 부모 094가 **고정가형 all-in**(PRF_PCB_FIXED·verbatim
  468셀)으로 구성원 값을 흡수하므로 **구성원 기여 = 0**(pack §3.10·[[postcard-book-sim-convergence-260702]]).
  라이브 `t_prd_product_price_formulas`에 PRD_000095 바인딩 **0행**(재실측)이므로 구성원 자체 `priced_by`는
  두지 않고 `derived_from → [[product-094-postcard-book]]`(가격이 부모 all-in에서 파생)으로 O5 가격사슬을
  만족한다(083/084/104 클러스터 동형·라이브 미실재 앵커 위조 회피). 값 = `evaluate_set_price`(D-18).
- **페이지 가변**: 내지 member의 min/max/incr(20/30/10) = 페이지수(db_comment "구성원 개수" 오등록이나
  load-bearing·pack §3.4 [HARD]). 페이지 단가 후속 = [[rule/gaps#gap-set-inner-page-price]].
- **끊긴 축(정직)**: 카테고리 CAT_000026(엽서북)·판형 SIZ_000499(국4절 내지) 축 노드 미민팅 → 전사표 권위·needs_axis.

## 구성·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_materials/plate_sizes/categories where prd_cd=PRD_000095 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨/usage | 축노드 존재 |
|---|---|---|---|
| material | MAT_000109 | 몽블랑 240g (USAGE.01 내지종이) | O(uses_material 배선) |
| plate_size | SIZ_000499 | 국4절(316x467·output_paper_typ 미기재·260701 교정) | ✗(미민팅·전사표 권위) |
| category | CAT_000026 | 엽서북(main_cat_yn=Y) | ✗(미민팅·needs_axis) |

내지는 종이류라 판형 대상(pack §3.8·종이류만·fn_best_plate). 사이즈·도수·공정 자체 행은 현재 DB 0(고정가 부모
all-in·구성원 빈껍데기·[[postcard-book-sim-convergence-260702]]). live-snapshot 20260702_1119은 자재 멤버 이관
前이라 STALE(pack §4·T-3) — 위는 07-03 재확인값.
