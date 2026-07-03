---
id: product-126-leather-artprint
type: product
anchor: t_prd_products/PRD_000126
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000126 (del_yn=N·use_yn=Y·PRD_TYPE.01 완제품·nonspec_yn=Y·qty_unit=QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.2(면적매트릭스 B09 레더126)·§3.1 정체·§3.2 size·§3.5 자재(레더 .05)·§3.8 판형없음·§3.10 가격 면적매트릭스", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/17_correctness/silsa/product-identity.md", source_locator: "§0~2 실사 28상품 정체·소재 13군·인쇄방식 실사 단일·prd_typ 실측 (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
  - {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "실사=포스터/사인 면적매트릭스 [가로×세로]·off-grid=한 단계 큰 규격 ceiling·비종이류=판형없음", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
relations:
  - {rel: in_category, target: category-CAT_000076, note: "아트프린트(부모 CAT_000004 포스터·lvl2·main_cat_yn=N·라이브 등록 1행)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420) 이산 규격 preset·dflt·활성. 면적매트릭스 셀축(600/800/1000/1200) 직접일치 안 함→off-grid ceiling(앱)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594) 이산 규격 preset·dflt·활성"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1(594x841) 이산 규격 preset·상품링크 활성/마스터 del_yn=Y 불일치(정직 관찰·단정 아님·검증 레인 몫)"}
  - {rel: uses_material, target: material-MAT_000186, note: "레더(MAT_TYPE.05 교정됨 2026-06-27·USAGE.07 낱장 단일)·소재가 상품 정체 결정(실사 특성1)"}
  - {rel: priced_by, target: formula-PRF_POSTER_LEATHER_AP, note: "면적매트릭스형 완제품 통가격 공식(포스터사인 [가로×세로] 셀단가)"}
  - {rel: references, target: gap-126-roll-material-pricing, note: "롤 소재 가격 계산 로직 암묵지(엑셀 미기재·실사 전체 영향·GAP-2)"}
  - {rel: references, target: gap-126-minqty-axis, note: "merged comp use_dims에 min_qty 선언되나 단가행 min_qty 공란(수량축 역할 미확정)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  nonspec_yn: "Y"
  file_upload_yn: "Y"
  editor_yn: "N"
  use_yn: "Y"
  archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·off-grid=한 단계 큰 규격 ceiling·통가격)"
  구분: "실사(대형 잉크젯 롤 출력·레더 소재 아트프린트·비종이류·판형 무의미)"
standards: {schema_org: "Product", xjdf: "Product(실사 대형 출력물)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(레더아트프린트 구성·가격 축)", "실사 면적매트릭스 가격(가로×세로 셀단가)", "레더 소재 대형 출력물", "비종이류 판형 없는 상품"]
tags: ["#실사", "#포스터사인", "#면적매트릭스", "#레더", "#비종이류", "#통가격"]
updated: 2026-07-03
---

# 레더아트프린트 (product-126-leather-artprint · PRD_000126)

레더아트프린트(PRD_000126)는 **실사(대형 잉크젯 롤 출력) 완제품 단일**(prd_typ_cd=`PRD_TYPE.01`·
`t_prd_product_sets`에 부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수·기성/디자인
아님). 레더(가죽 질감) 소재에 실사 잉크젯으로 출력하는 카테고리 004 포스터 계열 대형 인쇄물이다.
주 상위 분류는 **아트프린트**(CAT_000076·부모 CAT_000004 포스터). 가격은 실사 면적매트릭스 공식
[[formula-PRF_POSTER_LEATHER_AP]]이 **[가로×세로] 셀단가(완제품 통가격)** 를 조회한다(원자합산형 아님·
off-grid=한 단계 큰 규격 ceiling·값 계산=`evaluate_price` 권위·[[rule/rules#RULE_price_value_boundary]]).

- **정체(round-13 승계·재검증):** `17_correctness/silsa/product-identity.md`의 실사 28상품 정체표를
  INHERIT — 126은 라이브 `PRD_TYPE.01`(완제품)·`use_yn=Y`·`del_yn=N`(pack §3.1). 소재가 상품을 가른다
  (실사 특성1): 126은 **레더**(MAT_000186) 소재군으로 캔버스패브릭·메쉬·타이벡 형제와 갈린다.
- **★실사 특성 — 비종이류라 판형(plate_size)이 없다:** 실사는 대형 롤 출력이라 절수 기반 전지 규격이
  무의미([[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]·pack §3.8). 라이브 판형 3행
  (SIZ_000052/198/294·JPG 파일사양)은 **전부 del_yn=Y(2026-06-30 논리삭제·판형 오적재 정리)** — 활성 판형 0행이
  정상이다. 종이류(스티커/디지털)의 판형(fn_best_plate)·판걸이수(fn_calc_pansu·t_siz_pansu) 로직을 실사에
  이식하면 오모델(pack T-7).
- **★가격 모델 = 면적매트릭스형(§3.10):** [[formula-PRF_POSTER_LEATHER_AP]] → `has_component` →
  [[component-COMP_POSTER_CANVAS_FABRIC]](use_dims=`[siz_width, siz_height, min_qty]`). 매트릭스 셀단가는
  노드로 펼치지 않고 구성요소 속성으로 접는다(D-22). ★단가행 comp가 **[동형결합]** — 가격표 동일한 4소재
  (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트)를 한 구성요소로 통합했다(구 per-leather
  COMP_POSTER_LEATHER_ARTPRINT는 use_yn=N 레거시 은퇴). 실사 시트 inline price(R/S/V)는 가격 권위 아님
  [HARD]·권위=포스터사인 시트(pack §3.10).
- **★도수·공정 축이 얕다(실사 특성):** 실사는 도수(칼라/흑백) 컬럼이 없고(대형 잉크젯 풀컬러·정당),
  인쇄방식 공정 행도 라이브 부재(po=0·process 0행·pack §3.3·§3.7). 코팅·가공은 면적매트릭스 통가격에
  포함(별도 공정 행 없음). CPQ 옵션그룹·추가상품·제약·묶음수·셋트 전부 0행(레더126은 부속 안 붙는 단품·
  pack §3.12 부속 8상품에 미포함).
- **비규격(nonspec) 연속범위:** 이산 규격 preset(A3/A2/A1) 외에 손님 자유입력(가로 200~600·세로 200~3000·
  incr 200)을 받는다(nonspec_yn=Y). ★비규격 범위는 입력 UX일 뿐 가격격자가 아니다 — 유효 가격 권위는
  면적매트릭스 셀(pack §3.2 SL-DIM-001·로컬 size 노드는 companion 참조).
- **가격 경로 연결 확인(O5/O6):** `priced_by`→PRF_POSTER_LEATHER_AP(✅ 실재·use_yn=Y)→`has_component`→
  COMP_POSTER_CANVAS_FABRIC(52셀·가로 600/800/1000/1200 × 세로 600~3000·단가 19000~126000·활성). 끊긴 가격
  사슬 아님.
- **범위 밖 거절:** 주문·배송·회원·쿠폰 축은 KB 범위 밖(pack §0·[[rule/rules#RULE_scope_boundary]]) — 이 노드도 안 만든다.

## 끊긴 경로·미결(정직 선언)

- **롤 소재 가격 계산 로직 암묵지(GAP-2·실사 전체 영향):** 실사 롤 소재의 최종 단가가 어떤 규칙으로
  면적매트릭스 셀에 산정됐는지는 엑셀에 미기재된 실무 암묵지 → [[gap-126-roll-material-pricing]](source-registry §9 GAP-2).
- **min_qty 차원 역할 미확정:** merged comp use_dims가 `[siz_width, siz_height, min_qty]`로 min_qty를 선언하나
  라이브 단가행의 min_qty 컬럼은 공란(단일 tier). 면적매트릭스는 "수량축 없음"(pack §3.4)이 원칙인데 차원
  선언과 격자가 어긋난다 → [[gap-126-minqty-axis]](수량축 실재/역할 검증 레인 몫·단정 아님).
- **A1 사이즈 마스터/링크 삭제 불일치:** SIZ_000293(A1) 상품링크는 활성(del_yn=N)이나 사이즈 마스터
  (t_siz_sizes) del_yn=Y(2026-06-17 논리삭제) — 링크활성/마스터삭제 불일치(정직 관찰·단정 아님·size 노드 note).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_126.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-126-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음).

### 상품 정체·수량·비규격 범위 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000126 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

| 비규격축 | width_min | width_max | width_incr | height_min | height_max | height_incr |
|---|---|---|---|---|---|---|
| nonspec | 200 | 600 | 200 | 200 | 3000 | 200 |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000076 | 아트프린트 | CAT_000004 | 2 | N |

CAT_000076(아트프린트)은 CAT_000004(포스터) 하위 leaf. round-13 "실사 전부 CAT_000298 고아"는 STALE
(CAT_000298 del_yn=Y·28상품 정상 재연결·pack §1.1·T-1). `in_category`→[[product-126-leather-artprint-nodes#category-CAT_000076]].

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | Y | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | Y | N | N |
| SIZ_000293 | A1(594x841mm) | 594x841 | Y | N | Y |

이산 규격 preset 3종(A3/A2/A1)·전부 상품링크 활성. ★SIZ_000293(A1)은 상품링크 활성이나 마스터 del_yn=Y
(2026-06-17 논리삭제) — 링크활성/마스터삭제 불일치(정직 관찰). 비규격 연속범위는 위 정체표 nonspec축(입력 UX·
가격격자 아님·pack §3.2). 면적매트릭스 가격은 (가로,세로) 셀단가로 조회(A3=297×420 등은 셀 축 600/800/1000/1200과
직접 일치하지 않아 off-grid ceiling 적용·앱 계산·[[harness-domain-rules-12-260701]]).

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000186 | 레더 | MAT_TYPE.05 | USAGE.07 | Y |

레더 소재 단일(낱장 완제품·USAGE.07). ★자재유형 = **MAT_TYPE.05**(2026-06-27 교정·구 `.08 실사소재`에서 이동·
pack §1.1). round-13 목표 라벨 ".06 가죽"은 MAT_TYPE 코드 개편(현재 .06=도장부자재)으로 **STALE**(pack T-2) —
현재값 .05가 정답이며 양면 아님. ★MAT_000186 레더는 라이브 4상품(100/126/296/298) 횡단(MAT_TYPE 오염축·
pack §1.1) — 126은 그 중 실사 상품. IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000052 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000198 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000294 | (공백) | JPG | Y | Y | 파일사양 |

활성 판형 0행(3행 전부 2026-06-30 논리삭제). output_paper_typ 전부 공백(=대형 롤·`.기타`)·output_file=JPG만 유효.
실사는 비종이류라 판형 무의미([[rule/rules#RULE_plate_paper_only]]·pack §3.8) — `has_plate_size` 엣지 없음이 정상.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) print_options/processes/bundle_qtys/addons/constraints/option_groups/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| processes(공정) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |
| sets(셋트 부모) | 0 |

전 축 0행. 도수/인쇄방식 공정 부재는 실사 정당(대형 잉크젯 풀컬러·통가격·pack §3.3·§3.7). CPQ 옵션·추가상품·
제약·셋트 미보유(레더126은 부속 안 붙는 단품·pack §3.12). constraints 0행은 정합 — 실사 constraints 신규 발현
7상품(118/120/121/122/124/125/139)에 126 미포함(pack §1.1·§3.9). `has_print_option`/`has_process`/`has_plate_size`/
`has_qty_rule`/`has_option_group`/`has_addon`/`constrains`/`has_member` 엣지 전부 없음이 정상.

### 가격 배선 (전사·priced_by → 공식 → 구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_CANVAS_FABRIC | Y | PRICE_TYPE.01 | 실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트) | `["siz_width", "siz_height", "min_qty"]` |

`product-126-leather-artprint` --priced_by--> [[formula-PRF_POSTER_LEATHER_AP]] --has_component-->
[[component-COMP_POSTER_CANVAS_FABRIC]](★[동형결합] 4소재 통합·구 per-leather COMP_POSTER_LEATHER_ARTPRINT는
use_yn=N 은퇴). use_dims=`[siz_width, siz_height, min_qty]`가 126 가격이 가로·세로(·수량)로 달라짐을 선언. 값
절대치는 KB 밖(evaluate_price·D-18).

### 면적매트릭스 셀 요약 (전사·D-22 접기 — 전개 금지·집계만)

<!-- transcribed-by: _meta/scripts/transcribe_product_126.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_CANVAS_FABRIC/LEATHER_ARTPRINT 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 가로축(mm) | 세로축(mm) | 단가범위 | comp_nm |
|---|---|---|---|---|---|---|
| COMP_POSTER_CANVAS_FABRIC | Y | 52 | 600/800/1000/1200 | 600/800/1000/1200/1400/1600/1800/2000/2200/2400/2600/2800/3000 | 19000~126000 | 실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트) |
| COMP_POSTER_LEATHER_ARTPRINT | N | 52 | 600/800/1000/1200 | 600/800/1000/1200/1400/1600/1800/2000/2200/2400/2600/2800/3000 | 19000~126000 | 레더아트프린트 완제품가[레거시] |

★두 comp 행수·격자·단가범위 동일(활성 canvas_fabric = 은퇴 leather_artprint) → [동형결합]이 격자를 손실 없이
승계했음을 실측 확인. 활성 격자(52셀)는 권위 포스터사인 시트 B09(600/800/1000/1200 × 세로·19000~126000)와
일치(mapping.md §1.2 silsa-poster-area-matrix·pack §3.10). 단가행은 D-22로 전개 안 함(집계만).

---

## 재사용한 공유 노드 (중복 mint 없음)

이 상품이 **재사용**하는 이미 존재하는 노드(내가 정의하지 않음):
- [[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_price_value_boundary]]·[[rule/rules#RULE_scope_boundary]]·
  [[rule/rules#RULE_dosu_is_printopt]]·[[rule/rules#RULE_import_material_no_delete]] (공유 규칙 축).
- [[product-type-classification-sot]]·[[harness-domain-rules-12-260701]] (외부 SOT 메모리 참조).
- [[product-125-canvas-fabric-poster-nodes#component-COMP_POSTER_CANVAS_FABRIC]] (★[동형결합] 4소재 통합 가격구성요소·
  캔버스=namesake·병렬 실사 빌더 125가 canonical 소유·재정의 금지·중복 mint 없음).

이 상품이 **처음 mint하는 실사 노드**(레더 전용 — 공유 축 파일 미수정 원칙으로 companion에 임시 거처):
category-CAT_000076·material-MAT_000186·formula-PRF_POSTER_LEATHER_AP·gap 2종
→ [product-126-leather-artprint-nodes.md](product-126-leather-artprint-nodes.md). (★사이즈 A3/A2/A1은 정본
size-SIZ_000174/197/293 재사용으로 재지향·구 로컬 preset size-126-* 은퇴 — 단일소유권 교정 D-SILSA-INT-1·fix-log-silsa-260703.
component-COMP_POSTER_CANVAS_FABRIC은
125 재사용·mint 안 함.) 공유 축(axis/materials·axis/categories·formula/·axis/sizes) 승격 후보는 build-report의
needed_shared로 반환(축 소유자가 canonical id 그대로 이관·051/054/125 선례).
