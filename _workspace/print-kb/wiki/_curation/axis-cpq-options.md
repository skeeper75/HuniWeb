# Axis Pack — cpq-options (CPQ 옵션 레이어)

> freshness 권위: impact-diagnosis I-5(constraint_json 삭제)·I-8(RULE_TYPE 2종)·I-9(옵션 in 비교). round-13 결함축 H(CPQ 전면 미적재).

## 정답 소스

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| CPQ 7테이블 라이브 구조(option_groups/options/option_items·templates/template_selections·constraints) | `00_schema/cpq-schema.md` + 라이브 psql | A/C | PARTIAL-STALE(I-5·I-8·I-11) |
| 속성→4엔티티 마스터 지도(차원/CPQ옵션/가격/제약) | `10_configurator/attribute-entity-map.md` | C(round-6) | PARTIAL-STALE(I-5·I-9) |
| polymorphic ref_dim_cd(OPT_REF_DIM 7종)·검증 트리거 fn_chk_opt_item_ref | `00_schema/cpq-schema.md` + `10_configurator/cpq-design.md` | A/C | FRESH(트리거)·설계는 PARTIAL |
| silsa CPQ 파일럿(43행 COMMIT 실증) | `10_configurator/silsa-option-layer-v2.md`·`silsa-live-reconciliation.md` | C/A | FRESH |
| 엽서 옵션 파일럿 | `10_configurator/postcard-option-layer.md`·`postcard-walkthrough-validation.md` | C | FRESH |
| OTC TEMPLATE(상품악세사리 이중등록=의도) | `10_configurator/all-sheets-otc-extract.md`·`option-vs-template-guide.md` + round-13 product-accessory | C | FRESH |
| admin ground-truth(제약 var 7키·constraints.logic) | `10_configurator/live-admin-groundtruth.md` + 메모리 dbmap-live-admin-product-viewer | A | FRESH |

## 보조 소스

- `10_configurator/wowpress-option-model.md` — WowPress 6축 흡수원칙(형상→규격·본체색→재질 합성·과분할 금지). tier D 보조 FRESH.
- `10_configurator/huni-goods-option-mapping.md` — 굿즈 옵션 매핑. FRESH.
- 메모리 dbmap-cpq-option-layer-mapping(L1≠L2·트리거 reference resolution)·dbmap-l2-requires-l1-price-table(L2는 L1 가격표 대조 필수). FRESH.
- `huni-admin-manual/manual/04_options.md`·`05_sku-templates.md`·`06_constraints.md` — 운영자 입력 step. tier D FRESH.

## stale 함정

1. **constraint_json 적재 타깃 — STALE(I-5, 진단 Top 1).** `cpq-schema.md`(✅5)·`cpq-design.md`·`16_*/digital-print/mapping-final.md`(180g→constraint_json)가 constraint_json을 적재 타깃으로 명시. 컬럼 삭제 → 무효. 제약=`t_prd_product_constraints.logic` 단일경로(즉석병합)로 재서술.
2. **RULE_TYPE.01(호환) 활성 가정 — STALE(I-8).** 현재 금지+필수동반 2종만(.01 비활성). cpq-design JSONLogic 제약유형 enum 2종으로.
3. **7스칼라 차원 === 만 가정 — PARTIAL(I-9).** 옵션그룹/옵션 제약 차원(OPT_GRP/OPT, 배열 in 비교)·POD data 계약(sel_opts/sel_opt_grps) 미반영.
4. **option_items 0행 vs 43행 — 자료 충돌.** ref-csv/schema-relationship=0행, 메모리=silsa 43행 COMMIT(06-09). 라이브 재확인 대상 — 위키는 "대부분 미적재(silsa 파일럿만)" + 정확 행수 라이브 재확인 명시.

## 미해결 GAP

- CPQ 옵션 레이어 전면 미적재(silsa 외) — BATCH-6 일괄 적재 미결(crosscut 추가-H·6+ family). [GAP-CPQ-1]
- ref_param_json/hidden-essential GAP(cpq-option-gaps.md). [GAP-CPQ-2]
- 제약 즉석병합 전환 후 우리 JSONLogic 변환 정합 미검증(I-5·I-9). [GAP-CPQ-3]
