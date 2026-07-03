---
id: product-068-saddle-stitch-booklet
type: product
anchor: t_prd_products/PRD_000068
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000068 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 부모:PRD_000068 (구성원 288 표지·287 내지·reg 2026-06-30)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리 068·§3.10 가격·§3.12 셋트구성·§4 양면표기", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000006, note: "책자(main·live main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000316, note: "일반책자(sub CAT_000006)"}
  - {rel: uses_material, target: material-MAT_000106, note: "표지 자재(USAGE.01/02·부모 레거시 슬롯·live PRD_000068)"}
  - {rel: has_member, target: product-288-saddle-stitch-booklet-cover, qualifier: {role: "SEMI_ROLE.02", disp_seq: 1, sub_prd_qty: 1}, note: "표지=중철 펼침(PRF_BOOK_COVER 3비목)·1권고정·cover_mult=1(펼침 ×1)"}
  - {rel: has_member, target: product-287-saddle-stitch-booklet-inner, qualifier: {role: "SEMI_ROLE.01", disp_seq: 2, sub_prd_qty: 1, page_min: 4, page_max: 28, page_incr: 4}, note: "내지=중철내지종이·페이지 가변 4~28/+4(068 page_rule verbatim)·PRF_DGP_INNER"}
  - {rel: priced_by, target: formula-PRF_BIND_SUM}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·dflt"}
  - {rel: has_process, target: process-PROC_000018, note: "중철제본(셋트 form 공정)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(표지 코팅 옵션)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(표지 코팅 옵션)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  set_parent: "Y"
  archetype: "원자합산형(셋트조합·제본비+표지+내지)"
  min_qty: 2
  max_qty: 1000
  qty_incr: 1
  구분: "중철책자(셋트 완제품·부품조립형)"
standards: {schema_org: "Product", xjdf: "Product(책자)/BindingIntent(SaddleStitch)", config_ont: "component type(assembly)"}
answers_cq: ["셋트 책자 구성 질의(중철책자 구성원·가격 축)", "제본 방식별 책자 가격"]
tags: ["#셋트", "#책자", "#중철", "#원자합산형", "#분해형"]
updated: 2026-07-03
---

# 중철책자 (product-068-saddle-stitch-booklet)

중철책자(PRD_000068)는 **셋트 완제품**(부품조립형·`t_prd_product_sets` 부모로 등록·상품유형 분류 SOT
정합 = 셋트 완제품). 표지 반제품([[product-288-saddle-stitch-booklet-cover]])과 내지 반제품
([[product-287-saddle-stitch-booklet-inner]])을 조립해 하나의 책자를 이룬다. 면지는 없다(하드커버
계열과 달리 소프트커버). 제본 방식 = **중철**(가운데를 철심으로 매는 방식·`PROC_000018`).

- **정체·구조**: pack §3.1/§3.12 + live `t_prd_product_sets`(부모 068 ← 288 표지·287 내지·reg 2026-06-30).
  068/069/070은 06-26 readiness-master가 "🔴 BLOCKED·구성원 미구성"으로 적었으나 2026-06-30 구성원 mint로
  셋트 성립(pack §1.1 T-2 STALE 정정).
- **가격(D-18 경계)**: `evaluate_set_price`(pricing.py:718) = 구성원별 `evaluate_price` 합산 + 셋트 부모
  공식([[formula/set-formulas#formula-PRF_BIND_SUM]]·제본비 중철) + 할인. 단일 `evaluate_price` 아님(pack
  §3.10 T-9). 온톨로지는 priced_by(부모공식)·has_member(구성원)·차원 선언까지만, 값 계산은 견적 엔진 권위.
  ★라이브 실측 부모 frm_cd = **PRF_BIND_SUM**(태스크 라벨 `PRF_BIND_JUNGCHEOL_SET`는 라벨 오류·live 우선).
- **양면/C트랙 정직 표기**: 셋트 시뮬레이터 경로(`price_views.py:1930`)가 멤버 selections에 `coat_side_cnt`를
  미전달해 표지 코팅비(100부 50,000)를 드롭 → 셋트경로 final은 게이트 골든보다 저평가된다. **PRICE≠0은
  깨지지 않음(정상)·골든만 저평가 = 코드 C트랙**([[rule/gaps#gap-set-s1s2-double]]). 데이터 결함 아님.
- **분류**: live `t_prd_product_categories` = CAT_000316(일반책자) ⊂ CAT_000006(책자). 두 category 축 노드
  미민팅 → `in_category` 배선 대기(needs_axis 반환). 사이즈 A4(SIZ_000172)도 축 노드 미민팅(A5 SIZ_000170만 배선).

## 셋트 골든 (권위 = §23 게이트 실호출·copies=100)

<!-- transcribed-by: awk from _workspace/huni-set-product/05_gate/set-price-full-diagnosis-260702.md §0·§1 (라이브 simulate-set 실호출) @ 2026-07-03 -->
| 축 | 값 | 비고 |
|---|---|---|
| 게이트 골든(정답·copies=100) | 158,688 | 표지 단품 88,688(print 35,000+coat 50,000+paper 3,688) + 제본 70,000 |
| 시뮬레이터 final(copies=100) | 127,126 | 코팅 드롭 C트랙만큼 저평가(−50,000)·PRICE≠0 정상 |
| set_eval(부모 제본비) | 70,000 | PRF_BIND_SUM(중철 JUNGCHEOL) |
| 표지 288 기여(셋트경로) | 38,688 | print+paper만(코팅 드롭) |
| 내지 287 기여 | 18,438 | PRF_DGP_INNER(page 파생) |

수치는 §23 진단 파일 실호출 전사(손전사 아님). 게이트 골든이 정답·시뮬 final은 C트랙 저평가([[rule/gaps#gap-set-s1s2-double]]).

## 부모 자체 축 (BOM·전사표)

<!-- transcribed-by: awk t_prd_product_processes.csv PRD_000068 from live-snapshot/latest @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 | has_process |
|---|---|---|---|---|
| PROC_000018 | 중철제본 | N | O | O |
| PROC_000015 | 무광라미네이팅 | N | O | O |
| PROC_000014 | 유광라미네이팅 | N | O | O |

부모 068의 CPQ 옵션그룹(사이즈·내지종이·내지인쇄·표지종이·표지인쇄·표지코팅·제본 = live 7그룹)은
손님 선택 축이며, 실제 가격은 구성원 공식으로 계산된다. 옵션그룹 노드는 이 라운드 미민팅(BOM 관찰 기록만).
</content>
</invoke>
