<!-- product-scoped supplement: PRD_000056(낱장 자유형 투명스티커)이 도입하는 신규 축 항목 + 스티커 전용 공식/구성요소 + 연당가 양면(defect) + GAP. -->
<!-- ★공유 axis/*·formula/*·index.md 수정 금지 제약 하에, 056이 새로 쓰는 축 멤버(스티커 카테고리·규격 사이즈·규격 판형·투명스티커 자재·스티커 완제품가 공식/구성요소)를 -->
<!--    이 상품 전용 하위 노드로 선언한다(중복 아님 — 공유 축에 미등재). 공유 축 승격 제안은 needed_shared_nodes로 반환. -->
<!-- 재사용(신규 아님·target 실재): process-PROC_000053(axis/processes)·process-PROC_000008(product-020-nodes)·printopt-POPT_000001(axis/print-options). -->

# product-056 낱장 자유형 투명스티커 — 전용 하위 노드

> 메인 노드 = [[sticker-sheet-clear-white]]. 아래는 공유 축에 없는 스티커 전용 노드 + 연당가 양면(defect) + GAP.
> 수치는 `_meta/scripts/transcribe_product_056.py`·`transcribe_sticker_material_dual_056.py` 전사(손전사 금지).

---

## 재사용 공유 노드 (중복 mint 금지 — 아래는 참조만·정의는 sibling/축 파일)

> ★병렬 집필로 아래 노드는 이미 sibling 스티커 파일·기존 축에 실재 → **056은 재정의하지 않고 참조만** 한다(L-3 중복 회피·"중복 금지" HARD).
> - `category-CAT_000002`(스티커)·`category-CAT_000309`(자유형스티커) = sibling 스티커 노드 파일 정의(승격 대기·needed_shared, owner=architect).
> - `size-SIZ_000172`(A4)·`size-SIZ_000174`(A3) = [[product-047-small-flyer]] 기정의(공유 규격 사이즈·재사용).
> - `formula-PRF_STK_FIXED`·`component-COMP_STK_PRINT` = sibling 스티커 노드 파일 정의(스티커 전용 완제품가 공식/구성요소·승격 대기·needed_shared).
> - `process-PROC_000053`(완칼)=[[axis/processes]] · `process-PROC_000008`(화이트인쇄)=[[product-020-white-print-postcard-nodes]] · `printopt-POPT_000001`(단면)=[[axis/print-options]].
> 056 메인 노드의 in_category/has_size/priced_by/has_process/has_print_option 엣지가 이들을 가리킨다(끊긴 링크 아님·target 실재).

---

## 사이즈 (056 고유 규격 시트 — 형상 흡수 아님·승격 대기)

> 056은 낱장 자유형이라 형상(칼틀)은 완칼 공정 input이고, size는 규격(A4/A3/A2/B4/B3)으로 저장된다
> (합판도무송 066의 "형상=siz_nm 흡수"와 다른 형태·pack §3.2). A4(SIZ_000172)·A3(SIZ_000174)는
> [[product-047-small-flyer]] 기정의, A2(SIZ_000197)는 sibling 스티커 노드 기정의라 **재사용**(위 재사용 절·중복 mint 금지).
> 여기선 056 소비분 중 sibling 미정의인 B4·B3만 mint(현재 sole 정의자). 치수 전사표는 메인 [[sticker-sheet-clear-white]] §전사표.
> ★규격 사이즈는 다상품 공유 성격 → 통합 시 axis/sizes.md 승격 후보(needed_shared·owner=architect).

---

## 판형 (규격 낱장 출력용지 — 종이류 판형·승격 대기)

### [plate-056-OUTPUT_PAPER_TYPE_03] 규격 낱장 출력용지 (A4/A3/A2·OUTPUT_PAPER_TYPE.03) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000056
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000056,{SIZ_000050,SIZ_000052,SIZ_000198}) output_paper_typ_cd=OUTPUT_PAPER_TYPE.03·dflt_plt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.8 판형(fn_best_plate·종이류만·점착지=종이류)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stk}
- props: {output_paper_typ_cd: "OUTPUT_PAPER_TYPE.03", output_sizes: "SIZ_000050(A4)·SIZ_000052(A3)·SIZ_000198(A2)", note: "★타 디지털 판형=OUTPUT_PAPER_TYPE.01(국전)과 달리 규격 낱장 출력용지(A4/A3/A2). 점착지=종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택(fn_best_plate 자동선택·[[harness-domain-rules-12-260701]]). 판걸이수(UP)=fn_calc_pansu/t_siz_pansu 파생([[rule/rules#RULE_pansu_db_function]])"}
- 본문: 스티커 출력용지는 규격 낱장(A4/A3/A2·OUTPUT_PAPER_TYPE.03). 3행 전부 dflt_plt_yn=Y라 fn_best_plate가 자동선택한다. 단 완제품가 고정가 모델([[component-COMP_STK_PRINT]])에서는 판형 자체가 가격 격자의 축이 아니라 생산 라우팅 메타에 가깝다(가격축=siz_cd·mat_cd·min_qty).

---

## 자재 (★연당가 양면 — defect·재적재 워크리스트 §4-D)

> 아래 두 소재는 260702 권위가 연당가/국4절/평량을 대개편했으나 라이브 미반영 → 양면(현재값 vs 정답).
> 값은 `_meta/scripts/transcribe_sticker_material_dual_056.py` 전사(캐시 transcribed-sticker-mat-dual-056-260703.json).
> ★완제품 retail 격자(COMP_STK_PRINT)는 260702 무변경이라 dual 아님 — 아래는 **소재 원가 축**만 defect(false-defect 방지).

<!-- transcribed-by: _meta/scripts/transcribe_sticker_material_dual_056.py live=live-snapshot/latest (snap_20260702_1119) authority=26_change-tracking-260702/price-diff-260527-260702.csv @ 2026-07-03 -->
| mat_cd | 라이브 현재 명 | 라이브 평량(g) | 라이브 reg | 연당가(라이브) |
|---|---|---|---|---|
| MAT_000162 | 투명스티커 | 105.00 | 2026-06-03 | 미저장(t_mat_materials 가격컬럼 없음) |
| MAT_000371 | 투명스티커(백색후지) |  | 2026-06-27 | 미저장(t_mat_materials 가격컬럼 없음) |
| MAT_000372 | 투명스티커(투명후지) |  | 2026-06-27 | 미저장(t_mat_materials 가격컬럼 없음) |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_material_dual_056.py live=live-snapshot/latest (snap_20260702_1119) authority=26_change-tracking-260702/price-diff-260527-260702.csv @ 2026-07-03 -->
| 권위 소재(260702) | 명 | 평량(g) | 연당가 | 국4절가 |
|---|---|---|---|---|
| 백색후지(MAT_000162/371) | 투명스티커(백색후지) | 50 | 149500 | 499 |
| 투명후지(MAT_000372·신규행) | 투명스티커(투명후지) | 50 | 222000 | 740 |

---

## 가격 (스티커 완제품가 고정가 — 재사용·정의는 sibling·상세 서술만)

> `formula-PRF_STK_FIXED`·`component-COMP_STK_PRINT`는 sibling 스티커 노드 파일에 이미 정의(중복 mint 금지·위 재사용 절).
> 056 메인의 `priced_by → formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT` 사슬은 그 정의를 가리킨다(끊긴 사슬 아님).
> **056 관점 서술(값 아님·D-18 경계):** 스티커 가격 = 형상×치수×소재×수량 격자에서 완제품 시트가격을 통째로 조회하는 **고정가 룩업**
> (COMP_STK_PRINT `use_dims=[siz_cd, mat_cd, min_qty]`·PRC_COMPONENT_TYPE.06·PRICE_TYPE.01). 디지털 원자합산형과 아키타입이 다르다(pack §0 특성2).
> COMP_STK_PRINT 6,498행은 스티커 전 상품 공유 격자이고 056은 A4/A3/A2/B4/B3 각 42행을 쓴다(note "낱장(완칼) 자유형 스티커/…" 실측).
> ★소재 연당가는 이 완제품가 격자에 **없다**(원가≠완제품가·pack §3.11·§4-B)·단가행 접기(D-22)·값 절대치=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).

---

## 수량규칙

### [qty-056] 낱장 자유형 투명스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000056
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000056(min_qty/max_qty/qty_incr/qty_unit_typ_cd)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "메인 전사표(min 1·max 10000·incr 1)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙(pack §3.4). 가격 격자의 min_qty(수량구간)와 역할 분리"}

---

## 정직 GAP (지어내지 않음)

### [gap-056-material-cost-storage] 스티커 소재 연당가(원가) 저장처 부재 {unknown}
- type: gap
- anchor: none  # 사유: 라이브에 소재 연당가/국4절가를 담을 컬럼·구성요소가 없음(t_mat_materials 가격컬럼 없음·COMP_PAPER 스티커 mat_cd 0행) — 저장처 자체가 부재
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "헤더:t_mat_materials(가격컬럼 없음) + t_prc_component_prices COMP_PAPER 스티커 mat_cd(162/371/372) 0행 실측", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "260702 권위 연당가/국4절가(백색후지 149,500/499·투명후지 222,000/740·홀로 253,700/846·크라프 81,500/272)를 담을 라이브 저장처가 없다. 소재 마스터엔 평량만·COMP_PAPER엔 스티커 mat_cd 0행 → [[material-MAT_000162]]·[[material-MAT_000372]] 양면 노드가 재적재 워크리스트인데 적재 대상 테이블/구성요소가 미정"
- gap_fill_from: "실무진+인간 승인 — 소재 원가 저장처 신설 여부(pack §4-D·§5 GAP-ST(연당가) 돈-크리티컬). 그 전까지 연당가 라이브값 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000162, note: "이 소재의 연당가 저장처 부재"}
- rel: {rel: references, target: material-MAT_000372, note: "신규 투명후지 소재도 동일"}

### [gap-056-retail-cost-propagation] 연당가 급락의 완제품가(retail) 전파 여부 {unknown}
- type: gap
- anchor: none  # 사유: 연당가 급변(투명스 국4절 1,300→499·크라프 156k→81.5k)이 스티커 완제품 시트가격으로 전파돼야 하는지 판단할 원천/규칙이 없음
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-D(retail dual 금지·급락 전파는 열린 질문)·§3.11", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "소재 원가(연당가)가 260702에서 급락/급등했는데, 완제품가 격자(COMP_STK_PRINT·260702 무변경)가 그대로여도 되는지. 원가↔완제품가 정합의 열린 질문 — retail은 무변경이라 dual 아니지만 재적재 후속에서 재산정 필요할 수 있음"
- gap_fill_from: "실무진 원가/판가 정책 확인 + §26/§27 재적재 후속(인간 승인). KB는 관찰만 기록, 값 판정은 엔진/권위 소관(D-18)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "완제품가 격자 전파 여부"}
- rel: {rel: references, target: material-MAT_000162, note: "원가 급변 원천"}

### [gap-056-cpq-option-layer] CPQ 옵션 레이어 미적재 (BATCH-6) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_option_groups/options/option_items에 056 행 0개(CPQ 옵션 레이어 전면 미적재) — 손님 선택 축이 상품 차원(has_*)으로만 존재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups/option_items 키:PRD_000056 0행 실측", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "스티커 CPQ 옵션 레이어(사이즈·소재 선택을 option_group/option_items로 노출) 미적재(pack [STK-ST-006] BATCH-6). 056은 사이즈·소재를 상품 차원으로만 가짐 — 위젯/시뮬레이터 손님 선택 UI 배선은 별도 적재 필요"
- gap_fill_from: "CPQ 옵션 레이어 일괄 적재(§7 dbmap·인간 승인) — pack §3.9 GAP-ST-6. 캐스케이드 제약(투명→화이트 requires)은 §31 제약 하네스"
- gap_owner: dev
- rel: {rel: references, target: sticker-sheet-clear-white, note: "이 상품 CPQ 옵션 레이어 미적재"}
