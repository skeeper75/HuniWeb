<!-- companion nodes for product-123 아트패브릭포스터(PRD_000123·실사 area-matrix). -->
<!-- ★공유 파일 수정 금지(axis/*·formula/*·index.md·rule/*). 실사 병렬 파일럿이라 공유 실사 코드(카테고리·사이즈·동형결합 comp)는 형제 실사 상품 companion 또는 공유 axis가 이미 소유 → 여기서 재정의하지 않고 재사용(L-3 중복 회피). 단일 소유권 통합은 consolidation 단계(needed_shared_nodes로 반환). -->
<!-- ★여기서 신규 소유하는 것 = 123 고유 노드만: material-MAT_000181(그래픽천 dual)·formula-PRF_POSTER_ARTFABRIC·qty-123·gap-123-*. -->
<!-- ★수치(치수·범위·배선·행수)는 전사 스크립트 _meta/scripts/transcribe_product_123.py 출력만(transcribed-by 마커). LLM 손전사 금지(§32 [HARD]). -->

# product-123 전용 노드 (아트패브릭포스터 — 상품 전용 마스터 축)

[[product-123-artfabric-poster]]가 연결하는 축 중, **공유 축·형제 실사 상품이 이미 소유한 노드는
재사용**하고(중복 정의 금지·L-3), **123 고유 노드만** 여기서 신설한다. 면적매트릭스(가로×세로)
아키타입은 원자합산형·고정룩업과 다른 세 번째 아키타입(pack §0·§3.10).

## 재사용 노드 (다른 파일이 소유 — 여기서 정의 안 함·엣지만 해소)

> 실사 병렬 파일럿이라 아래 공유 실사 코드는 형제 실사 상품 companion(118/119/121/122/125 등) 또는
> 공유 `axis/sizes.md`가 이미 노드를 소유한다. product-123의 frontmatter relations가 이 id로 엣지를
> 걸어 해소하되, 여기 **중복 정의하지 않는다**(L-3). ★단일 소유권 통합(→ 공유 `axis/silsa-*`·
> `formula/silsa-*`)은 consolidation 단계 몫(스티커 260703 방식·needed_shared_nodes로 반환).

| 재사용 id | 소유(추정) | 근거 |
|---|---|---|
| category-CAT_000004 (포스터) | 형제 실사 companion(119/121/122/125) | 라이브 t_cat_categories/CAT_000004(lvl1·root·use_yn=Y) |
| category-CAT_000314 (아트포스터·leaf) | 형제 실사 companion(119/121/122) | 라이브 t_cat_categories/CAT_000314(lvl2·상위 CAT_000004·reg 06-19) |
| size-SIZ_000174 (A3) | product-047 / 형제 실사 | 라이브 t_siz_sizes/SIZ_000174(297x420·del_yn=N) |
| size-SIZ_000197 (A2) | 공유 axis/sizes.md | 라이브 t_siz_sizes/SIZ_000197(420x594·del_yn=N) |
| size-SIZ_000293 (A1) | 형제 실사 companion(119/122) | 라이브 t_siz_sizes/SIZ_000293(594x841·★마스터 del_yn=Y·링크 활성 → [[gap-123-a1-size-deleted]]) |
★component-COMP_POSTER_ARTPRINT_PHOTO(동형결합 4소재)는 **여기서 소유**한다(아래 정의) — 라이브
실측 시점 이 노드를 소유한 파일이 없어(118 아트프린트·120 방수·121 접착방수 formula가 전부 이 comp에
끊긴 링크) 아트패브릭 빌더가 owner로 신설한다. 형제 118/120/121도 이 정의를 재사용(브로큰링크 해소).
단일 소유권은 향후 `formula/silsa-components.md` 통합 시 이관(needed_shared_nodes).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사·손전사 아님)

> 아래 표는 `_meta/scripts/transcribe_product_123.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(멱등). 셀 단가 값은 D-22 접기(구성요소 요약 행수·골든만·전 셀 미전사).

### 상품 마스터 (비규격 범위·수량·상태)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_products PRD_000123 -->
| prd_typ | nonspec | 가로(min~max·incr) | 세로(min~max·incr) | min_qty | max_qty | qty_incr | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 200.00~1200.00·200.00 | 200.00~3000.00·200.00 | 1 | 1000 | 1 | Y | N | Y | N |

### 카테고리
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_product_categories + t_cat_categories PRD_000123 -->
| cat_cd | cat_nm | 상위 | lvl | main_cat | disp |
|---|---|---|---|---|---|
| CAT_000314 | 아트포스터 | CAT_000004 | 2 | N |  |
| CAT_000004 | 포스터 | root | 1 | Y | 8 |

### 사이즈 (이산 규격 · 면적매트릭스 아님)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_product_sizes + t_siz_sizes PRD_000123 -->
| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt | 링크 del_yn | 마스터 del_yn |
|---|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297.00x420.00 | 297.00x420.00 | Y | N | N |
| SIZ_000197 | A2(420x594mm) | 420.00x594.00 | 420.00x594.00 | Y | N | N |
| SIZ_000293 | A1(594x841mm) | 594.00x841.00 | 594.00x841.00 | Y | N | Y |

### 자재 (소재별 본체 단일 · mat_typ 현재값)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_product_materials + t_mat_materials PRD_000123 -->
| mat_cd | 자재명 | mat_typ(현재) | usage | dflt | 링크 del_yn |
|---|---|---|---|---|---|
| MAT_000181 | 그래픽천 | MAT_TYPE.08 | USAGE.07 | Y | N |

### 판형 (★비종이류 실사 → 전부 논리삭제·output_paper_typ 공란)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_product_plate_sizes PRD_000123 -->
| siz_cd | output_paper_typ | output_file_typ | note | del_yn |
|---|---|---|---|---|
| SIZ_000052 | (공란) | JPG | 파일사양 | Y |
| SIZ_000198 | (공란) | JPG | 파일사양 | Y |
| SIZ_000294 | (공란) | JPG | 파일사양 | Y |

### 가격공식 바인딩 (product→formula) + 배선 (formula→component)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_product_price_formulas + t_prc_formula_components PRD_000123 -->
| frm_cd | frm_nm | use_yn | → comp_cd | disp | addtn |
|---|---|---|---|---|---|
| PRF_POSTER_ARTFABRIC | 아트패브릭포스터 완제품가(면적/규격 단가) | Y | COMP_POSTER_ARTPRINT_PHOTO | 1 | Y |

### 가격구성요소 요약 (단가행 접기 D-22 · 셀 값 미전사·행수/차원만)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prc_price_components + t_prc_component_prices PRD_000123 -->
| comp_cd | comp_nm | prc_typ | use_dims | use_yn | 단가행 수 | 골든(note) |
|---|---|---|---|---|---|---|
| COMP_POSTER_ARTPRINT_PHOTO | 실사 완제품가 (아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터) | PRICE_TYPE.01 | ["siz_width", "siz_height", "min_qty"] | Y | 52 | 600×1800=21,600원 (comp note·값=evaluate_price 권위) |

### 미등록·미배선 축 (0행 정직 기록)
<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest (snap_20260702_1119 @ 2026-07-03) t_prd_product_processes/print_options/bundle_qtys/option_groups/constraints/addons/sets PRD_000123 -->
| 축 | 라이브 행수 | 해석 |
|---|---|---|
| 공정 t_prd_product_processes | 0 | 면적매트릭스=코팅포함 통가격·공정행 없음(정당) |
| 인쇄옵션 t_prd_product_print_options | 0 | 실사=도수 컬럼 없음(대형 잉크젯 풀컬러·정당·pack §3.3) |
| 수량규칙 t_prd_product_bundle_qtys | 0 | 면적매트릭스=수량축 없음(상품레벨 min/max만·pack §3.4) |
| 옵션그룹 t_prd_product_option_groups | 0 | CPQ 옵션 미등록(27 실사 잔존·BATCH-6·pack §3.9) |
| 제약 t_prd_product_constraints | 0 | 123은 제약 0행(constraints 7상품=118/120/121/122/124/125/139에 123 미포함·pack §1.1) |
| 추가상품 t_prd_product_addons | 0 | 부속 없음(부속붙는 8상품에 123 미포함) |
| 셋트 t_prd_product_sets | 0 | 완제품 단일(셋트 아님·SOT 정합) |

---

## 자재 (material) — 그래픽천 1종 (★123 고유·양면 노드·자재유형 교정중)

자재 모델 = parent + usage_cd 단일 슬롯(본체 단일·낱장 완제품·pack §3.5). 그래픽천은 아트패브릭
포스터 고유 소재라 여기서 소유. ★[HARD] IMPORT 시트 등록 자재 삭제 금지
([[rule/rules#RULE_import_material_no_delete]]).

### [material-MAT_000181] 그래픽천 (mat_typ 교정중 .08→.05) {defect}
- type: material
- anchor: t_mat_materials/MAT_000181
- badge: defect
- current_value: "MAT_000181 mat_typ_cd=MAT_TYPE.08 (실사소재·live-snapshot 20260702_1119)"
- authority_value: ".05 특수소재 (목표 — 라이브 note '정정 2026-06-14 →원단(.05)' + 형제 패브릭 린넨184/캔버스185/타이벡187/188 이미 .05로 이동·pack §1.1·§3.5). ★round-13 라벨 '원단'은 코드 개편으로 STALE(현재 .05=특수소재)·최종 목표유형 확정은 [[gap-123-graphicfabric-mattype]]"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000181 (mat_typ_cd=MAT_TYPE.08·note='정정 2026-06-14 실사소재(.08)→원단(.05)')", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1(레더/패브릭 .08→.05 교정·그래픽천/현수막천/메쉬 잔존 .08)·§3.5·T-2·§4 SL-DEF-002 부분해소", captured_at: "2026-07-03", badge: defect, src_id: SR-pack-silsa}
- props: {usage_cd: "USAGE.07", crosscut_note: "그래픽천은 아트패브릭포스터123 본체 소재·형제 패브릭과 동류 교정 축", note: "본체 단일 소재(표지/내지 없음)"}
- 본문: 아트패브릭포스터 본체 소재(패브릭). ★자재유형이 아직 `.08 실사소재`(구 v03 평면화 잔재)로, 형제 패브릭(린넨/캔버스/타이벡)은 이미 `.05`로 교정됐으나 그래픽천/현수막천/메쉬는 잔존(pack §1.1). 라이브 note가 교정 방향(→.05)을 명기하나 round-13의 라벨 "원단"은 MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재)으로 무효(T-2). 현재값·목표 둘 다 보존(어느 한쪽 삭제 금지)·최종 목표유형 확정은 GAP.

---

## 수량규칙 (bundle_qty) — 상품레벨 1행 (123 고유)

### [qty-123] 아트패브릭포스터 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000123
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000123 min_qty=1/max_qty=1000/qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4(면적매트릭스=수량축 없음·셀=완제품 통가격·bundle_qtys 0행)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {min_max_incr_ref: "전사표(상품 1/1000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 1000·incr 1). `t_prd_product_bundle_qtys` 0행은 정상 — 면적매트릭스는 셀 자체가 완제품 통가격이라 수량 단가구간 축이 없다(수량은 곱셈 승수·가격격자 차원 아님·pack §3.4). 사이즈별 수량규칙(per-size min/max)도 미설정.

---

## 가격공식 (formula) — PRF_POSTER_ARTFABRIC (123 고유·면적매트릭스형)

가격 경로 = `product-123 --priced_by--> formula-PRF_POSTER_ARTFABRIC --has_component-->
component-COMP_POSTER_ARTPRINT_PHOTO`(comp은 형제 소유·재사용). 값 계산은 evaluate_price 권위
(D-18·KB는 차원 선언·배선까지).

### [formula-PRF_POSTER_ARTFABRIC] 아트패브릭포스터 완제품가 (면적매트릭스형) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ARTFABRIC
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000123,PRF_POSTER_ARTFABRIC)·apply 2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_ARTFABRIC,COMP_POSTER_ARTPRINT_PHOTO·disp 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.2 B06(아트패브릭123)·룩업 매트릭스 모델만 승계(좌표회귀 DROP·T-4)·레거시 comp COMP_POSTER_ARTFABRIC_GRAPHIC(use_yn=N) 대체 관찰", captured_at: "2026-07-03", badge: verified, src_id: SR-map-areamatrix}
- rel: {rel: has_component, target: component-COMP_POSTER_ARTPRINT_PHOTO, note: "면적셀 단가(코팅포함 통가격)·동형결합 4소재 comp 재사용·disp 1·addtn Y"}
- rel: {rel: references, target: GAP_roll_material_price, note: "롤 소재 가격 계산 로직 미기재 횡단 GAP(실사 전체 영향)"}
- props: {archetype: "면적매트릭스형", use_yn: Y, frm_nm_ref: "전사표(아트패브릭포스터 완제품가·면적/규격 단가)", comp_ref: "COMP_POSTER_ARTPRINT_PHOTO(use_dims=[siz_width,siz_height,min_qty]·52셀·형제 소유)"}
- 본문: 면적매트릭스형 = 포스터사인 [가로×세로] 셀단가 룩업(코팅포함 통가격). **고아 공식 아님**(has_component 1개=동형결합 comp 재사용). 좌표 회귀·FRM_TYPE 구설계(price-engine-ddl)는 승계 안 함(T-4) — 룩업 매트릭스 모델만(pack §3.10). 값=evaluate_price([[rule/rules#RULE_price_value_boundary]]). 롤 소재 가격 로직 자체는 엑셀 미기재 횡단 GAP([[GAP_roll_material_price]]).

> ★component-COMP_POSTER_ARTPRINT_PHOTO(동형결합 4소재)는 형제 실사 상품
> `product-118-artprint-poster-nodes.md`가 소유(라이브 실측 시점 118이 mint) — 123 formula의
> has_component가 그 노드로 해소된다. 여기 **중복 정의하지 않는다**(L-3 회피). 이 comp은 4소재
> (118/120/121/123) 공유라 어느 단일 상품 companion도 장기 소유가 부적절 → 단일 소유권 통합은
> `formula/silsa-components.md`로의 consolidation 몫(needed_shared_nodes). 라이브 앵커·차원·골든은
> 위 "가격구성요소 요약" 전사표에 기록(전사 권위).

---

## 정직 GAP (원천 부재·못 닫는 공백)

> gap은 지어내지 않고 "무엇을 모르는지"를 1급 지식으로 등재(L-10 3필드). 상품-local GAP은 공유
> rule/gaps.md에 색인 미등재(공유 파일 미수정) → needed_shared_nodes로 색인 승격 반환.

### [gap-123-graphicfabric-mattype] 그래픽천 자재유형 최종 목표 미확정 {unknown}
- type: gap
- anchor: none  # 사유: 그래픽천 .08→교정 방향은 있으나(→.05) MAT_TYPE 코드 개편으로 round-13 라벨 '원단' 무효·개편코드 기준 최종 목표유형 미확정(실무진 확인 대기)
- badge: unknown
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 GAP(그래픽천/현수막천/메쉬 잔여 .08 정정 목표유형 확정·개편 코드 도메인 기준)·T-2", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "그래픽천(MAT_000181) 자재유형 최종 목표 코드 — 현재 .08 실사소재, 형제 패브릭은 .05(특수소재)로 이동했으나 그래픽천/현수막천/메쉬는 잔존. round-13 목표 '.05 원단'은 코드 개편으로 라벨 무효(현재 .05=특수소재)"
- gap_fill_from: "실무진 확인 — 개편된 MAT_TYPE 코드 도메인(.05 특수소재/.06 도장부자재/.08 실사소재) 기준 그래픽천의 최종 유형 확정(형제 .05 일관성 vs 실사소재 유지)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000181, note: "이 자재의 유형 교정 목표 미확정"}
- 본문: 교정 방향(.08→.05)은 라이브 note+형제 패턴으로 강하나, 개편코드 기준 최종 목표유형은 실무진 확정 대기. 양면 노드 material-MAT_000181의 authority_value 후보(.05 특수소재)의 잔여 불확실성을 정직 선언(지어내지 않음).

### [gap-123-a1-size-deleted] A1 사이즈 마스터 논리삭제 vs 상품링크 활성 불일치 {unknown}
- type: gap
- anchor: none  # 사유: SIZ_000293 A1 마스터 del_yn=Y(논리삭제)인데 상품-사이즈 링크는 del_yn=N(활성) — 정합 판정 원천(의도된 은퇴인지 링크 잔재인지) 미상
- badge: unknown
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000293 del_yn=Y(06-17) vs t_prd_product_sizes (PRD_000123,SIZ_000293) del_yn=N", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "A1(SIZ_000293) 사이즈 마스터는 논리삭제(del_yn=Y)됐으나 아트패브릭포스터 상품-사이즈 링크는 활성(del_yn=N) — A1 규격이 UI에 노출되는지·의도된 은퇴인지 미상"
- gap_fill_from: "실무진/설계 — 사이즈 은퇴 시 상품 링크 동반 논리삭제 정책 확인(면적매트릭스라 실 가격은 가로×세로 룩업이라 직접 견적 영향은 낮으나 링크 정합 확인 대상)"
- gap_owner: staff
- rel: {rel: references, target: size-SIZ_000293, note: "마스터 삭제 vs 링크 활성 불일치(형제 소유 노드 참조)"}
- 본문: 이산 A1 규격의 마스터/링크 del_yn 불일치 관찰. 면적매트릭스 상품이라 실 가격은 셀 룩업이 권위(이산 SIZ는 프리셋)이므로 견적 직접 단절은 아니나, 데이터 정합 확인 대상으로 정직 선언.
