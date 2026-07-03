---
id: product-069-perfect-bound-booklet
type: product
anchor: t_prd_products/PRD_000069
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000069 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 부모:PRD_000069 (구성원 290 표지·289 내지·reg 2026-06-30)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리 069·§3.10 가격·§1.1 _FOIL 양면·§4 양면표기", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000006, note: "책자(main)"}
  - {rel: in_category, target: category-CAT_000316, note: "일반책자"}
  - {rel: has_process, target: process-PROC_000051, note: "부가 후가공(옵션·live PRD_000069)"}
  - {rel: has_process, target: process-PROC_000052, note: "부가 후가공(옵션·live PRD_000069)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션·live PRD_000069)"}
  - {rel: has_member, target: product-290-perfect-bound-booklet-cover, qualifier: {role: "SEMI_ROLE.02", disp_seq: 1, sub_prd_qty: 1}, note: "표지=무선 펼침(PRF_BOOK_COVER 3비목)·1권고정·cover_mult=1(펼침 ×1)"}
  - {rel: has_member, target: product-289-perfect-bound-booklet-inner, qualifier: {role: "SEMI_ROLE.01", disp_seq: 2, sub_prd_qty: 1, page_min: 24, page_max: 300, page_incr: 2}, note: "내지=무선내지종이·페이지 가변 24~300/+2(069 page_rule verbatim)·PRF_DGP_INNER"}
  - {rel: priced_by, target: formula-PRF_BIND_MUSEON}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·dflt"}
  - {rel: has_process, target: process-PROC_000019, note: "무선제본(셋트 form 공정)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(표지 코팅 옵션)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(표지 코팅 옵션)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  set_parent: "Y"
  archetype: "원자합산형(셋트조합·제본비+표지+내지)"
  min_qty: 2
  max_qty: 1000
  qty_incr: 1
  구분: "무선책자(셋트 완제품·부품조립형)"
standards: {schema_org: "Product", xjdf: "Product(책자)/BindingIntent(PerfectBound)", config_ont: "component type(assembly)"}
answers_cq: ["셋트 책자 구성 질의(무선책자 구성원·가격 축)", "박 있는 책자 표지"]
tags: ["#셋트", "#책자", "#무선제본", "#원자합산형", "#분해형", "#박분기양면"]
updated: 2026-07-03
---

# 무선책자 (product-069-perfect-bound-booklet)

무선책자(PRD_000069)는 **셋트 완제품**(부품조립형·`t_prd_product_sets` 부모). 표지 반제품
([[product-290-perfect-bound-booklet-cover]])과 내지 반제품([[product-289-perfect-bound-booklet-inner]])을
조립한 소프트커버 책자(면지 없음). 제본 방식 = **무선**(등을 풀로 붙이는 방식·`PROC_000019`). 내지 페이지
가변폭이 커서(24~300쪽/+2) 중철(068)보다 두꺼운 책자를 만든다.

- **정체·구조**: pack §3.1/§3.12 + live `t_prd_product_sets`(부모 069 ← 290 표지·289 내지·reg 2026-06-30·T-2 정정).
- **가격(D-18 경계)**: `evaluate_set_price` = 구성원별 `evaluate_price` 합산 + 부모 공식
  [[formula/set-formulas#formula-PRF_BIND_MUSEON]](제본비 무선·**base 정본·active**) + 할인.
- **★양면(박분기) 정직 표기**: 라이브에 069 부모 바인딩이 두 행 실재 — `PRF_BIND_MUSEON`(apply_bgn
  2026-06-01·**active 정본**) + `PRF_BIND_MUSEON_FOIL`(2026-07-01·note "박 분기 공식으로 재바인딩·인간승인
  후 COMMIT" = **candidate 🟡**). priced_by 정본은 base(PRF_BIND_MUSEON)로 배선했고, 박분기 공식은
  [[formula/set-formulas#formula-PRF_BIND_MUSEON_FOIL]]·정본화 미결 = [[rule/gaps#gap-set-069-070-foil]].
- **C트랙**: 표지 코팅 드롭(셋트경로 저평가·PRICE≠0 무해)·S1/S2 내지인쇄 이중합산 = 코드 C트랙
  [[rule/gaps#gap-set-s1s2-double]].
- **분류·사이즈**: CAT_000316(일반책자) ⊂ CAT_000006(책자)·A4(SIZ_000172) = 축 노드 미민팅(needs_axis).

## 셋트 골든 (권위 = §23 게이트 실호출·copies=100)

<!-- transcribed-by: awk from _workspace/huni-set-product/05_gate/set-price-full-diagnosis-260702.md §0·§1 (라이브 simulate-set 실호출) @ 2026-07-03 -->
| 축 | 값 | 비고 |
|---|---|---|
| 게이트 골든(정답·copies=100) | 138,688 | 표지 88,688 + 제본 50,000 |
| 시뮬레이터 final(copies=100) | 131,072 | 코팅 드롭 C트랙 저평가·PRICE≠0 정상 |
| set_eval(부모 제본비) | 50,000 | PRF_BIND_MUSEON(무선) |
| 표지 290 기여(셋트경로) | 38,688 | print+paper만(코팅 드롭) |
| 내지 289 기여 | 42,384 | PRF_DGP_INNER(page 파생·페이지수 많음) |

수치는 §23 진단 파일 실호출 전사. 게이트 골든이 정답·시뮬 final은 C트랙 저평가.

## 부모 자체 축 (BOM·전사표)

<!-- transcribed-by: awk t_prd_product_processes.csv PRD_000069 from live-snapshot/latest @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 | has_process |
|---|---|---|---|---|
| PROC_000019 | 무선제본 | N | O | O |
| PROC_000015 | 무광라미네이팅 | N | O | O |
| PROC_000014 | 유광라미네이팅 | N | O | O |

라이브 069 부모는 위 3공정 외 다수 후가공/제본 부가공정(PROC_000037~044·051·052·076 등)을 보유하나 해당 축
노드 미민팅(needs_axis). CPQ 옵션그룹은 사이즈·내지종이/인쇄·표지종이/인쇄/코팅·박/형압·제본 = live 8그룹(BOM 관찰).
</content>
