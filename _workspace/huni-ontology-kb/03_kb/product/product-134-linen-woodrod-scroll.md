---
id: product-134-linen-woodrod-scroll
type: product
anchor: t_prd_products/PRD_000134
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000134 (린넨 우드봉 족자·del_yn=N·use_yn=Y·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·editor_yn=Y·qty_unit=QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10(고정가형 15상품·린넨우드봉족자134)·§3.1 정체·§3.5 자재(린넨 .05)·§3.6 봉제/족자 공정·§3.8 판형없음·§3.12 부속붙는 8상품(134→우드봉013·addon 0행)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/17_correctness/silsa/product-identity.md", source_locator: "§0~2 실사 28상품 정체·소재 13군·인쇄방식 실사 단일·prd_typ 실측·에디터 상품 3종(132/133/134) (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
  - {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "실사=포스터/사인·차원형vs수량단가·비종이류=판형없음(종이류만 판형)", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
relations:
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(부모 CAT_000004 포스터·lvl2·main_cat_yn=N·라이브 유일 카테고리)"}
  - {rel: has_size, target: size-SIZ_000258, note: "A4(210x297) 이산 규격·가격키 siz_cd·dflt·활성(134 mint)"}
  - {rel: has_size, target: size-SIZ_000315, note: "A3(297x420) 이산 규격·가격키 siz_cd·dflt·활성(★118 canonical 재사용·중복 mint 없음)"}
  - {rel: has_size, target: size-SIZ_000317, note: "A2(420x594) 이산 규격·가격키 siz_cd·dflt·활성(134 mint)"}
  - {rel: uses_material, target: material-MAT_000184, note: "린넨(MAT_TYPE.05 교정됨 2026-06-14·USAGE.07 낱장 단일)·소재가 상품 정체 결정(실사 특성1)"}
  - {rel: has_process, target: process-PROC_000080, qualifier: {mand: "N"}, note: "봉제(린넨 hemming·param 유형/폭·족자제작 PROC_000082 아님·mand N·★125 canonical 재사용)"}
  - {rel: has_qty_rule, target: qty-134, note: "상품레벨 수량규칙(min1·max10000·incr1·QTY_UNIT.01)·bundle_qtys 0행·base comp use_dims에 min_qty 밴드"}
  - {rel: priced_by, target: formula-PRF_POSTER_LINEN_WOODBONG, note: "★고정가 룩업형(규격[siz_cd]×수량 단가·이산 A4/A3/A2·off-grid 없음)+우드봉 옵션 가산"}
  - {rel: has_option_group, target: optgroup-134-OPT_000013, note: "가공(봉제 택1·mand Y·OPV_000031→PROC_000080)"}
  - {rel: has_option_group, target: optgroup-134-OPT_000014, note: "추가(우드봉+면끈·mand N·출력만 기본/우드봉 가산)"}
  - {rel: references, target: gap-134-woodbong-addon, note: "우드봉 가격은 comp로 배선됐으나 물리 부속(우드봉 PRD_000013) addon/set 미연결(0행 잔존·pack §3.12)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  nonspec_yn: "N"
  file_upload_yn: "Y"
  editor_yn: "Y"
  use_yn: "Y"
  archetype: "고정가 룩업형(포스터사인 [규격 siz_cd × 수량 min_qty] 단가·이산 A4/A3/A2·off-grid 없음) + 우드봉 옵션 가산"
  구분: "실사(대형 잉크젯 롤 출력·린넨 소재 우드봉 족자·비종이류·판형 무의미·에디터 상품)"
standards: {schema_org: "Product", xjdf: "Product(실사 대형 출력물·행잉족자)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(린넨 우드봉 족자 구성·가격 축)", "실사 고정가 룩업 상품(규격×수량 단가)", "린넨 소재 대형 출력물·우드봉 행잉족자", "비종이류 판형 없는 상품", "봉제 마감 옵션·우드봉 추가 옵션"]
tags: ["#실사", "#포스터사인", "#고정가룩업", "#린넨", "#족자", "#비종이류", "#우드봉"]
updated: 2026-07-03
---

# 린넨 우드봉 족자 (product-134-linen-woodrod-scroll · PRD_000134)

린넨 우드봉 족자(PRD_000134)는 **실사(대형 잉크젯 롤 출력) 완제품 단일**(prd_typ_cd=`PRD_TYPE.01`·
`t_prd_product_sets`에 부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수·기성/디자인
아님). 린넨 원단에 실사 잉크젯으로 출력하고 가장자리를 봉제(hem)한 뒤 우드봉(나무봉)에 걸어 늘어뜨리는
행잉 족자로, 카테고리 004 포스터 계열(보드액자 CAT_000080) 대형 인쇄물이다. **에디터 상품**(editor_yn=Y·
실사 에디터 3종 132/133/134 중 하나). 가격은 **고정가 룩업 공식** [[formula-PRF_POSTER_LINEN_WOODBONG]]이
**[규격(siz_cd)×수량(min_qty)] 단가**를 조회한다(값 계산=`evaluate_price` 권위·
[[rule/rules#RULE_price_value_boundary]]).

- **★실사 2모델 중 "고정가형"(pack §3.10) — 122/126 면적매트릭스와 다른 아키타입:** 122 접착투명포스터·
  126 레더아트프린트는 **면적매트릭스형**(use_dims=`[siz_width, siz_height]`·[가로×세로] 셀단가·off-grid
  ceiling·nonspec_yn=Y)이었다. 134는 **고정가 룩업형**(use_dims=`[siz_cd, min_qty]`·이산 규격 A4/A3/A2를
  siz_cd로 직접 조회·nonspec_yn=N·자유치수/off-grid 없음). 실사 시트는 이 두 모델이 공존하며(면적 13 +
  고정가 15), 134는 고정가 15의 대표다(pack §3.10·§3.4 고정가형=수량축 보유). "29 실사 전부 면적매트릭스"
  일괄 적용은 round-2 오모델(pack T-5) — 134는 고정가 siz_cd 룩업임을 명시.
- **정체(round-13 승계·재검증):** `17_correctness/silsa/product-identity.md`의 실사 28상품 정체표를 INHERIT —
  134는 라이브 `PRD_TYPE.01`(완제품)·`use_yn=Y`·`del_yn=N`(pack §3.1). 소재가 상품을 가른다(실사 특성1):
  134는 **린넨**(MAT_000184) 소재군으로 캔버스행잉133·족자포스터135 형제와 갈린다.
- **★비종이류라 판형(plate_size)이 없다:** 실사는 대형 롤 출력이라 절수 기반 전지 규격이 무의미
  ([[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]·pack §3.8). 라이브 판형 3행
  (SIZ_000314/316/318·JPG 파일사양)은 **전부 del_yn=Y(2026-06-30 논리삭제)** — 활성 판형 0행이 정상이다.
  ★이 3행의 작업치수(210x347·297x470·420x644)는 각 규격에 **우드봉 hem(약 50mm) 확장**을 더한 생산 작업사이즈로,
  **생산메타이지 가격축·판형이 아니다**(가격키는 A4/A3/A2 siz_cd). 종이류(스티커/디지털)의 `fn_best_plate`·
  `fn_calc_pansu` 판걸이수 로직을 실사에 이식하면 오모델(pack T-7).
- **공정 = 봉제(PROC_000080)이지 족자제작(PROC_000082) 아님:** 134는 린넨 가장자리를 봉제(오버로크/봉미싱)로
  마감한다(mand N·param 유형/폭). pack §3.6이 "족자=족자제작 PROC_000082"를 열거하나, 이는 원형/사각 족자
  **거치 가공**(족자포스터135 등)이고, 린넨 우드봉 족자134는 **린넨 hem 봉제**가 라이브 실측 공정이다(정직
  관찰·양면 아님·권위 충돌 없음). 봉제 노드는 형제 [[product-125-canvas-fabric-poster]]가 mint한 공유
  노드라 `has_process`(mand N)로 재사용한다(중복 mint 없음).
- **★도수 축이 없다(실사 특성):** 실사는 도수(칼라/흑백) 컬럼이 없고(대형 잉크젯 풀컬러·정당·po=0·인쇄옵션
  0행·pack §3.3·§3.7). `has_print_option` 엣지 없음이 정상.
- **CPQ 2옵션그룹(면적매트릭스 122/126은 얕았으나 134는 옵션 보유):** ① **가공**(OPT_000013·mand Y·봉제 택1·
  OPV_000031 오버로크+봉미싱→PROC_000080) ② **추가**(OPT_000014·mand N·출력만 기본 / 우드봉+면끈 추가). 옵션=
  공정 BUNDLE(pack §3.9). 가공 옵션값이 부모 has_process(PROC_000080)를 가리켜 L-18 정합(fn_chk_opt_item_ref).
- **가격 경계(D-18):** 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기
  (evaluate_price)가 권위([[rule/rules#RULE_price_value_boundary]]). 실사 시트 inline price(R/S/V)는 가격 권위
  아님(pack §3.10 [HARD]) — 권위는 인쇄상품 가격표 "포스터사인" 시트.
- **가격 경로 연결 확인(O5/O6):** `priced_by`→PRF_POSTER_LINEN_WOODBONG(✅ 실재·use_yn=Y)→`has_component`→
  ① COMP_POSTER_LINEN_WOODBONG(base·[siz_cd,min_qty]·3행 A4/A3/A2) + ② COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG
  (우드봉+면끈 추가가·[opt_cd,siz_cd]·3행). 끊긴 가격 사슬 아님. ★고정가 룩업이라 면적매트릭스의 off-grid
  ceiling·롤 소재 암묵지(GAP-2) 이슈 없음(이산 규격 직접 룩업으로 사슬 완결).
- **범위 밖 거절:** 주문·배송·회원·쿠폰 축은 KB 범위 밖(pack §0·[[rule/rules#RULE_scope_boundary]]) — 이 노드도 안 만든다.

## 끊긴 경로·미결(정직 선언)

- **우드봉 부속(addon) 미연결(pack §3.12·GAP-SL-4):** 우드봉+면끈 추가의 **가격**은 comp
  [[component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG]](opt_cd OPV_000430 매칭)로 배선돼 견적은 가능하나,
  물리 부속(우드봉 반제품 `PRD_000013`)과의 **addon/set 관계는 미연결**(`t_prd_product_addons`=0·
  `t_prd_product_sets`=0 실측). 옵션값 OPV_000430(우드봉+면끈 추가)도 option_item ref_dim이 없는 bare 값
  (가격은 component_prices의 opt_cd 키로만 결정) → [[gap-134-woodbong-addon]](우드봉013 재연결 대기·인간 승인·
  단정 금지). ★`has_addon`→product-우드봉 엣지는 만들지 않음(부속 PRD 노드 부재·끊긴 링크 회피·정직 GAP).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_134.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9·[HARD]). 캐시=`_meta/scripts/cache/transcribed-134-260703.json`.
> `python3 transcribe_product_134.py` 재실행 시 동일 출력(멱등). 실사 시트는 260702 diff 무영향(pack §5)이라
> 라이브 현재값=권위 정합(양면 소재 없음).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000134 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y | Y |

nonspec_yn=**N**(자유치수 없음·이산 규격 A4/A3/A2만) — 122/126(nonspec_yn=Y·면적매트릭스)와 근본 대비.
editor_yn=**Y**(실사 에디터 상품 3종 132/133/134 중 하나). 수량 단위 QTY_UNIT.01(장)·min/incr 1.

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000080 | 보드액자 | CAT_000004 | 2 | N |

카테고리 = **보드액자(CAT_000080)** 단일·부모 CAT_000004 포스터·lvl2(pack §1.1 CAT_000080에 실사 7상품 귀속).
main_cat_yn=N은 라이브 현재값 그대로 전사(단일 카테고리인데 주 카테고리 미표기·정직 관찰). round-13 "실사 전부
CAT_000298 고아"는 STALE(CAT_000298 del_yn=Y·정상 재연결·pack §1.1·T-1). `in_category`→[[category-CAT_000080]].

### 사이즈 (전사·전 행·del 표기 — 이산 규격 A4/A3/A2·가격키 siz_cd)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000258 | A4 (210x297mm) | 210x297 | Y | N | N |
| SIZ_000315 | A3 (297x420mm) | 297x420 | Y | N | N |
| SIZ_000317 | A2 | 420x594 | Y | N | N |

사이즈 = **이산 규격 3행(A4/A3/A2)** — nonspec_yn=N이라 자유치수 없음(면적매트릭스와 대비). ★이 siz_cd가
**가격키**다(고정가형은 siz_cd로 직접 단가 조회·pack §3.10). SIZ_000315(A3)는 공유 [[axis/sizes]] 계열에서 118
아트프린트포스터가 canonical mint한 노드([[product-118-artprint-poster-nodes#size-SIZ_000315]]·동일 물리규격
297x420)를 **재사용**(중복 mint 없음·L-3). SIZ_000258(A4)/SIZ_000317(A2)는 134가 mint(companion·승격 후보).

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000184 | 린넨 | MAT_TYPE.05 | USAGE.07 | Y |

본체 자재 단일 = **린넨**(parent+usage_cd 단일 슬롯·낱장 완제품·pack §3.5). mat_typ_cd=**MAT_TYPE.05**(2026-06-14
교정·구 `.08 실사소재`에서 이동)는 현재값이자 개편 후 정답 — round-13 목표 라벨 ".05 원단"은 MAT_TYPE 코드
개편(현재 .05=**특수소재**·.06=도장부자재)으로 라벨 의미만 바뀐 것이라 **자재유형 양면 아님**(pack T-2·§1.1).
★MAT_000184 린넨은 라이브 7상품(124/134/191/243/265/266/267) 횡단(형제 124는 자식 MAT_000607로 교체·134는 부모
MAT_000184 직결). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

### 공정 (전사 — 봉제·족자제작 아님)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand |
|---|---|---|---|
| PROC_000080 | 봉제 |  | N |

공정 **1행 = 봉제(PROC_000080·mand N)** — 린넨 가장자리 hem 마감(param 유형 오버로크/말아박기/봉미싱·폭).
★pack §3.6의 족자제작(PROC_000082·원형/사각)은 다른 족자상품(족자포스터135) 거치가공이고, 린넨 우드봉 족자134
라이브 실측 공정은 봉제다(정직 관찰). PROC_000080은 형제 [[product-125-canvas-fabric-poster-nodes#process-PROC_000080]]
가 mint한 공유 노드라 `has_process`(mand N)로 재사용(중복 mint 없음). 후가공은 봉제만(우드봉 부착은 옵션·가격 comp).

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·작업사이즈=우드봉 hem 생산메타)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | 작업(mm) | dflt | del | note |
|---|---|---|---|---|---|---|
| SIZ_000314 | (공백) | JPG | 210x347 | Y | Y | 파일사양 |
| SIZ_000316 | (공백) | JPG | 297x470 | Y | Y | 파일사양 |
| SIZ_000318 | (공백) | JPG | 420x644 | Y | Y | 파일사양 |

활성 판형(del_yn=N) **0행** — `has_plate_size` 엣지 없음. ★비종이류(린넨 대형 롤)라 판형 무의미(pack §3.8·
T-7·[[rule/rules#RULE_plate_paper_only]]). output_paper_typ 공백(=`.기타`)·output_file=JPG만 유효. ★이 3행의
작업치수(210x347/297x470/420x644)는 각 규격(A4 210x297·A3 297x420·A2 420x594)에 **우드봉 hem 약 50mm 확장**을
더한 생산 작업사이즈로 **생산메타이지 가격축·판형이 아니다**(088 레더링바인더 작업사이즈=생산메타 선례와 동형).
3행 전부 2026-06-30 파일사양 논리삭제. 종이류의 `fn_best_plate`/`fn_calc_pansu` 판걸이수 로직을 여기 이식 금지.

### CPQ 옵션그룹·옵션·아이템 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items @ 2026-07-03 -->

**OPT_000013 가공** (sel=SEL_TYPE.01·min/max=1/1·mand=Y·disp=1·note:오버로크+봉미싱 봉제 필수 (복합유형=2 item))
| opt_cd | opt_nm | dflt | disp | ref_dim_cd | ref_key1 | qty |
|---|---|---|---|---|---|---|
| OPV_000031 | 오버로크+봉미싱(4cm) | Y | 1 | OPT_REF_DIM.04 | PROC_000080 | 1 |

**OPT_000014 추가** (sel=SEL_TYPE.01·min/max=0/1·mand=N·disp=2·note:우드봉 추가 선택)
| opt_cd | opt_nm | dflt | disp | ref_dim_cd | ref_key1 | qty |
|---|---|---|---|---|---|---|
| OPV_000032 | 출력만 | Y | 1 | (없음) | (없음) | - |
| OPV_000430 | 우드봉+면끈 추가 | N | 2 | (없음) | (없음) | - |

CPQ **2그룹**: ① **가공**(OPT_000013·mand Y·택1)의 옵션값 OPV_000031이 OPT_REF_DIM.04(공정)로 **PROC_000080**
(봉제)을 가리킨다 — 부모 has_process에 실재하므로 `option_refs`→process-PROC_000080(ref_key1=PROC_000080)을 청정
배선(L-18 정합·fn_chk_opt_item_ref). ② **추가**(OPT_000014·mand N·택1)의 OPV_000032(출력만)/OPV_000430(우드봉+면끈
추가)은 option_item ref_dim이 **없는 bare 옵션값** — 우드봉 가격은 component_prices의 opt_cd 키(COMP_POSTEROPT)로만
결정된다(물리 부속 미연결=[[gap-134-woodbong-addon]]). companion optgroup-134-OPT_000013/014로 선언.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 부모) | 0 |

도수 0행(실사 대형 잉크젯 풀컬러·정당·pack §3.3). bundle_qtys 0행(상품레벨 수량규칙만·min1/incr1·[[qty-134]]).
addons 0행·sets 0행(우드봉 부속 미연결·[[gap-134-woodbong-addon]]). constraints 0행 — 실사 constraints 신규 발현
7상품(118/120/121/122/124/125/139)에 134 미포함(pack §1.1·§3.9·nonspec 없어 치수범위 제약 불필요·정합).
`has_print_option`/`has_addon`/`constrains`/`has_member` 엣지 없음이 정상.

### 가격 배선 (전사·priced_by→공식→구성요소·★고정가 룩업형)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_LINEN_WOODBONG** — 린넨 우드봉 족자 완제품가(면적/규격 단가) (use_yn=Y)
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_LINEN_WOODBONG | Y | PRICE_TYPE.01 | 린넨 우드봉 족자 완제품가 | `["siz_cd", "min_qty"]` |
| 2 | COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG | Y | PRICE_TYPE.01 | 린넨우드봉족자 우드봉+면끈 추가가격 | `["opt_cd", "siz_cd", "opt_grp:OPT_000014"]` |

`priced_by`→[[formula-PRF_POSTER_LINEN_WOODBONG]](★고정가 룩업형)·2구성요소 가산(addtn Y):
① [[component-COMP_POSTER_LINEN_WOODBONG]] = base 완제품 통가격(출력+소재+가공 포함)을 **[규격 siz_cd × 수량
min_qty]** 로 룩업(면적매트릭스의 siz_width×siz_height와 다름). ② [[component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG]]
= 우드봉+면끈 추가가를 [opt_cd, siz_cd]로 매칭 가산. 값은 evaluate_price(D-18 경계).

### 고정가 단가행 요약 (전사·D-22 접기 — 값 나열 금지·행수/축/범위/골든만)

<!-- transcribed-by: _meta/scripts/transcribe_product_134.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_LINEN_WOODBONG / COMP_POSTEROPT_..._WOODBONG 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | siz set | min_qty | opt set | 단가범위 | 골든(A2) |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_LINEN_WOODBONG | Y | 3 | SIZ_000258/SIZ_000315/SIZ_000317 | 1 | - | 6000~16000 | SIZ_000317=16000 |
| COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG | Y | 3 | SIZ_000258/SIZ_000315/SIZ_000317 | (공란) | OPV_000430 | 7000~12000 | SIZ_000317=12000 |

> ★단가행은 **이산 규격 룩업**(base=3행·규격당 단일 수량밴드 min_qty=1·면적매트릭스 687셀류와 달리 격자 아님).
> 값 전건은 KB에 나열하지 않고 행수·siz set·단가범위·골든으로 접는다(D-22·pack §3.11). 골든(A2 최대규격)=base
> 16000·우드봉 추가 12000은 master 실측(값 계산은 evaluate_price·D-18). off-grid·롤 소재 암묵지 이슈 없음
> (고정가 이산 룩업으로 사슬 완결).

---

## 이 상품 전용 하위 노드

> **134 전용 mint**(companion [[product-134-linen-woodrod-scroll-nodes]]): category-CAT_000080(보드액자)·
> size-SIZ_000258(A4)/size-SIZ_000317(A2)·material-MAT_000184(린넨)·formula-PRF_POSTER_LINEN_WOODBONG·
> component-COMP_POSTER_LINEN_WOODBONG(base 규격×수량)·component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG(우드봉
> 옵션가)·optgroup-134-OPT_000013(가공/봉제)·optgroup-134-OPT_000014(추가/우드봉)·qty-134·gap-134-woodbong-addon.
> ★**재사용(중복 mint 금지·L-3)**: size-SIZ_000315(A3)=118 canonical·process-PROC_000080(봉제)=125 canonical·
> 공유 규칙(RULE_plate_paper_only·RULE_price_value_boundary·RULE_scope_boundary·RULE_dosu_is_printopt·
> RULE_import_material_no_delete). ★실사 **첫 고정가 룩업형** 계열이라 고정가 공식/구성요소·실사 공유 축
> (보드액자 카테고리/A4·A2 사이즈/린넨 자재)은 통합 단계 승격 후보=needed_shared_nodes(formula/silsa-formulas·
> axis/* — consolidate 스크립트가 단일 소유권 이관·스티커/면적 실사 선례). 끊긴 가격 사슬 없음(O5/O6 충족)·정직
> GAP 1건(우드봉 부속 미연결·gap-134-woodbong-addon).
