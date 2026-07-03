---
id: product-132-leather-art-frame
type: product
anchor: t_prd_products/PRD_000132
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000132 (prd_nm=레더아트액자·del_yn=N·use_yn=Y·PRD_TYPE.01 완제품·nonspec_yn=N·editor_yn=Y·min_qty=1·max_qty=1000·qty_incr=1·qty_unit=QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.2(고정가형 15상품 B-block 레더아트액자132)·§3.1 정체(edit=Y 에디터 상품)·§3.5 자재(보드/우드 소재 L1 빈값 AMBIGUOUS)·§3.8 판형없음·§3.10 가격 고정가형([수량×규격])·§3.12 액자 귀속 AMBIGUOUS(공정 vs 부속)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/17_correctness/silsa/product-identity.md", source_locator: "§0~2 실사 28상품 정체·소재 13군·인쇄방식 실사 단일·prd_typ 실측·C-14 액자 귀속 AMBIGUOUS (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
  - {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "실사=포스터/사인·차원형vs수량단가(고정가형=[수량×규격] 룩업)·비종이류=판형없음", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
relations:
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(부모 CAT_000004 포스터·lvl2·main_cat_yn=N·라이브 등록 1행)"}
  - {rel: has_size, target: size-132-SIZ_000304, note: "5x5(127x127) 액자 규격 preset·dflt·활성(work=cut·무여백)"}
  - {rel: has_size, target: size-132-SIZ_000306, note: "5x7(127x178) 액자 규격 preset·dflt·활성"}
  - {rel: has_size, target: size-132-SIZ_000308, note: "8x8(203x203) 액자 규격 preset·dflt·활성"}
  - {rel: has_size, target: size-132-SIZ_000310, note: "8x10(203x254) 액자 규격 preset·dflt·활성"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4(210x297) 규격 preset·dflt·활성"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420) 규격 preset·dflt·활성"}
  - {rel: priced_by, target: formula-PRF_POSTER_LEATHER_FRAME, note: "고정가형 완제품 통가격 공식(규격(siz_cd)별 단가 룩업·면적매트릭스 아님)"}
  - {rel: references, target: gap-132-material-unwired, note: "레더 소재(MAT_000186) 미배선(자재 0행)·통가격 흡수 vs 결함=AMBIGUOUS"}
  - {rel: references, target: gap-132-frame-attribution, note: "액자 귀속 미결(공정 액자가공 vs 부속 프레임 별매·pack §3.12 C-14)"}
  - {rel: references, target: gap-132-qty-tier, note: "use_dims에 min_qty 선언·격자는 min_qty=1 단일 tier(수량 tier 역할 미확정)"}
  - {rel: references, target: GAP_roll_material_price, note: "실사 소재 완제품 단가 산정 로직 암묵지(엑셀 미기재·실사 전체 영향·GAP-2)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  nonspec_yn: "N"
  file_upload_yn: "Y"
  editor_yn: "Y"
  use_yn: "Y"
  archetype: "고정가형(실사·규격(siz_cd)별 완제품 단가 룩업·[수량×규격] 블록·면적매트릭스 아님·통가격)"
  구분: "실사(대형 잉크젯 출력물·레더 소재 아트액자·비종이류·판형 무의미·에디터 상품)"
standards: {schema_org: "Product", xjdf: "Product(실사 대형 출력물·액자)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(레더아트액자 구성·가격 축)", "실사 고정가형 가격(규격별 단가 룩업)", "레더 소재 액자 출력물", "비종이류 판형 없는 상품", "에디터 편집 상품"]
tags: ["#실사", "#포스터사인", "#고정가형", "#레더", "#액자", "#비종이류", "#통가격", "#에디터상품"]
updated: 2026-07-03
---

# 레더아트액자 (product-132-leather-art-frame · PRD_000132)

레더아트액자(PRD_000132)는 **실사(대형 잉크젯 출력) 완제품 단일**(prd_typ_cd=`PRD_TYPE.01`·
`t_prd_product_sets`에 부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수·기성/디자인
아님). 레더(가죽 질감) 소재의 실사 출력물을 액자 규격으로 만드는 카테고리 004 포스터 계열 상품이다.
주 상위 분류는 **보드액자**(CAT_000080·부모 CAT_000004 포스터). 가격은 실사 **고정가형** 공식
[[formula-PRF_POSTER_LEATHER_FRAME]]이 **규격(siz_cd)별 단가(완제품 통가격)** 를 조회한다(면적매트릭스형
아님·값 계산=`evaluate_price` 권위·[[rule/rules#RULE_price_value_boundary]]). ★형제 126 레더아트프린트가
**면적매트릭스형**([가로×세로] 셀단가)인 것과 달리, 132 액자는 **고정 규격 6종(5x5/5x7/8x8/8x10/A4/A3)의
룩업 단가**라는 다른 아키타입이다(pack §3.10 실사 2 모델 공존).

- **정체(round-13 승계·재검증):** `17_correctness/silsa/product-identity.md`의 실사 28상품 정체표를
  INHERIT — 132는 라이브 `PRD_TYPE.01`(완제품)·`use_yn=Y`·`del_yn=N`(pack §3.1). **에디터 상품**
  (editor_yn=Y·pack §3.1 에디터 3종 132/133/134 중 하나)·파일업로드도 가능(file_upload_yn=Y). 소재가
  상품을 가른다(실사 특성1): 132는 **레더 액자** 계열로 폼보드129·포맥스보드130·프레임리스우드액자131
  형제(고정가형 15상품)와 갈린다.
- **★고정가형 vs 면적매트릭스형(§3.10 — 형제 126과 구분):** 132는 **nonspec_yn=N**(규격 preset 전용·
  손님 자유입력 없음)이라 손님이 고정 규격 6종 중 하나만 고른다. 가격격자 = **[siz_cd × min_qty] 룩업**
  (COMP_POSTER_LEATHER_FRAME use_dims=`["siz_cd","min_qty"]`)·규격별 단가 6행(min_qty=1 단일 tier·9000~
  21000). 126(nonspec=Y·[siz_width,siz_height] 면적셀·off-grid ceiling)과 근본이 다르다 — "실사=전부
  면적매트릭스"로 뭉뚱그리면 오모델(pack T-5·§3.10 고정가 15 별도).
- **★자재 = 0행(레더 소재 미배선·정직 관찰):** 상품명이 "레더"인데 `t_prd_product_materials` 0행 —
  레더 자재(MAT_000186)가 132에 **배선되지 않았다**(MAT_000186 레더 crosscut 라이브 4상품 100/126/296/298에
  132 미포함·pack §1.1). 고정가 통가격(comp note="소재+출력+가공 포함")에 소재비가 흡수된 것인지, 아니면
  BOM 미배선 결함인지 **AMBIGUOUS** → [[gap-132-material-unwired]](pack §3.5 보드/우드 5상품 소재 L1 빈값
  AMBIGUOUS와 동류). ★IMPORT 등록 자재 삭제 금지 원칙([[rule/rules#RULE_import_material_no_delete]])과 별개
  이슈(여기는 배선 부재).
- **★실사 특성 — 비종이류라 판형(plate_size)이 없다:** 실사는 대형 출력이라 절수 기반 전지 규격이
  무의미([[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]·pack §3.8). 라이브 판형 6행
  (SIZ_000305/307/309/311/312/313·JPG 파일사양)은 **전부 del_yn=Y(2026-06-30 논리삭제·판형 오적재 정리)** —
  활성 판형 0행이 정상. 종이류(스티커/디지털)의 판형(fn_best_plate)·판걸이수(fn_calc_pansu·t_siz_pansu)
  로직을 실사에 이식하면 오모델(pack T-7).
- **★도수·공정 축이 얕다(실사 특성):** 실사는 도수(칼라/흑백) 컬럼이 없고(대형 잉크젯 풀컬러·정당·
  [[rule/rules#RULE_dosu_is_printopt]]), 인쇄방식 공정 행도 라이브 부재(po=0·process 0행·pack §3.3·§3.7).
  액자가공·마운팅은 고정가 통가격에 포함(별도 공정 행 없음·단 "공정 vs 부속" 귀속은 미결·아래 GAP).
  CPQ 옵션그룹·추가상품·제약·묶음수·구간할인·셋트 전부 0행.
- **수량 규칙:** 상품 레벨 수량축 = min 1·max 1000·incr 1(QTY_UNIT.01). 단가행 격자는 min_qty=1 단일 tier
  라 수량 tier가 가격에 실제 계단식 영향을 주는지 미확정([[gap-132-qty-tier]]·pack §3.4 고정가형은 수량축
  보유가 원칙이나 132 격자는 단일 tier). t_prd_product_bundle_qtys·t_prd_product_discount_tables 0행.
- **가격 경로 연결 확인(O5/O6):** `priced_by`→PRF_POSTER_LEATHER_FRAME(✅ 실재·use_yn=Y)→`has_component`→
  COMP_POSTER_LEATHER_FRAME(6행·규격별 단가 9000~21000·활성). 끊긴 가격 사슬 아님. 단가값 절대치는 KB
  밖(evaluate_price·[[rule/rules#RULE_price_value_boundary]]).
- **범위 밖 거절:** 주문·배송·회원·쿠폰 축은 KB 범위 밖(pack §0·[[rule/rules#RULE_scope_boundary]]) — 이 노드도 안 만든다.

## 끊긴 경로·미결(정직 선언)

- **레더 소재 미배선(자재 0행)·귀속 AMBIGUOUS:** 상품명 "레더"인데 product_materials 0행 — 통가격 흡수 vs
  BOM 미배선 결함이 미결 → [[gap-132-material-unwired]].
- **액자 귀속 미결(공정 vs 부속):** 131/132 액자가 "액자가공 공정"인지 "프레임 별매 부속(addon/set)"인지
  round-13이 AMBIGUOUS로 남김(C-14) → [[gap-132-frame-attribution]](pack §3.12·GAP-SL-4·라이브 addon=0·set=0).
- **min_qty 차원 선언 vs 단가행 단일 tier:** use_dims가 min_qty를 선언하나 격자는 min_qty=1 한 tier뿐 →
  수량 tier 역할 미확정 [[gap-132-qty-tier]].
- **실사 소재 단가 산정 로직 암묵지(GAP-2·실사 전체 영향):** 규격별 고정 단가(9000~21000)가 소재원가·
  출력·가공에서 어떤 규칙으로 산정됐는지는 엑셀 미기재 실무 암묵지 → 공유 [[GAP_roll_material_price]]
  (source-registry §9 GAP-2·재발명 없이 공유 GAP 재사용).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_132.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-132-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000132 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 1000 | 1 | QTY_UNIT.01 | Y | Y | Y |

★nonspec_yn=N — 규격 preset 전용(손님 자유입력 없음·126 nonspec=Y와 다름). 고정가형 실사·에디터 상품(editor_yn=Y).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000080 | 보드액자 | CAT_000004 | 2 | N |

CAT_000080(보드액자)은 CAT_000004(포스터) 하위 leaf. round-13 "실사 전부 CAT_000298 고아"는 STALE
(CAT_000298 del_yn=Y·28상품 정상 재연결·pack §1.1·T-1). `in_category`→category-CAT_000080(★형제 실사 빌더 130/131
소유·132는 재사용·재정의 안 함·단일 canonical 승격은 needed_shared).

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000304 | 5x5(127x127mm) | 127x127 | Y | N | N |
| SIZ_000306 | 5x7(127x178mm) | 127x178 | Y | N | N |
| SIZ_000308 | 8x8(203x203mm) | 203x203 | Y | N | N |
| SIZ_000310 | 8x10(203x254mm) | 203x254 | Y | N | N |
| SIZ_000172 | A4(210x297mm) | 210x297 | Y | N | N |
| SIZ_000174 | A3(297x420mm) | 297x420 | Y | N | N |

고정 규격 preset 6종·전부 상품링크 활성·마스터 활성(del_yn=N). work=cut(무여백·impos_yn=N). ★nonspec_yn=N이라
손님 자유입력 없음 — 이 6 규격이 곧 가격격자 축(siz_cd 룩업). 형제 126(A3/A2/A1 + nonspec 연속범위)과 다르다.

### 자재 (전사·★0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 행수 |
|---|---|
| (없음) | 0 |

★자재 0행 — 레더 소재(MAT_000186)가 132에 미배선(레더 crosscut 4상품 100/126/296/298에 132 미포함·pack §1.1).
고정가 통가격(comp note="소재+출력+가공 포함")에 소재비 흡수 vs BOM 미배선 결함 = **AMBIGUOUS** → [[gap-132-material-unwired]].
`uses_material` 엣지 없음(0행이 현재값). 레더 자재 노드 자체는 형제 126이 정의([[product-126-leather-artprint-nodes#material-MAT_000186]]) — 132는 참조만·재정의 안 함.

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000305 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000307 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000309 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000311 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000312 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000313 | (공백) | JPG | Y | Y | 파일사양 |

활성 판형 0행(6행 전부 2026-06-30 논리삭제). output_paper_typ 전부 공백(=대형 출력·`.기타`)·output_file=JPG만 유효.
실사는 비종이류라 판형 무의미([[rule/rules#RULE_plate_paper_only]]·pack §3.8) — `has_plate_size` 엣지 없음이 정상.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) print_options/processes/bundle_qtys/addons/constraints/option_groups/discount_tables/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| processes(공정) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |
| discount_tables(구간할인) | 0 |
| sets(셋트 부모) | 0 |
| sets(셋트 구성원) | 0 |

전 축 0행. 도수/인쇄방식 공정 부재는 실사 정당(대형 잉크젯 풀컬러·통가격·pack §3.3·§3.7). CPQ 옵션·추가상품·
제약·구간할인·셋트 미보유. ★단 부속(addon/set) 0행은 "액자=부속 프레임 별매" 가능성 하 **미교정 잔존**일 수
있음(pack §3.12 SL-DEF-005·GAP-SL-4·[[gap-132-frame-attribution]]) — 단정 아닌 AMBIGUOUS. `has_print_option`/
`has_process`/`has_plate_size`/`has_qty_rule`/`has_option_group`/`constrains`/`has_addon`/`has_member` 엣지 전부 없음.

### 가격 배선 (전사·priced_by → 공식 → 구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_LEATHER_FRAME | Y | PRICE_TYPE.01 | 레더아트액자 완제품가 | `["siz_cd", "min_qty"]` |

`product-132-leather-art-frame` --priced_by--> [[formula-PRF_POSTER_LEATHER_FRAME]] --has_component-->
[[component-COMP_POSTER_LEATHER_FRAME]](132 전용·재사용 아님·다른 상품 미바인딩 실측). use_dims=`[siz_cd, min_qty]`가
132 가격이 규격(·수량 tier)로 달라짐을 선언. 값 절대치는 KB 밖(evaluate_price·D-18).

### 고정가 단가행 요약 (전사·D-22 접기 — 전개 금지·집계만·siz_cd 룩업)

<!-- transcribed-by: _meta/scripts/transcribe_product_132.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_LEATHER_FRAME 집계) @ 2026-07-03 -->
| comp_cd | use_yn | prc_typ | 행수 | siz_cd 축 | min_qty tier | 단가범위 | comp_nm |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_LEATHER_FRAME | Y | PRICE_TYPE.01 | 6 | SIZ_000172/SIZ_000174/SIZ_000304/SIZ_000306/SIZ_000308/SIZ_000310 | 1 | 9000~21000 | 레더아트액자 완제품가 |

★단가행 6개(규격당 1행·min_qty=1 단일 tier). 규격 6종(A4/A3/5x5/5x7/8x8/8x10) 전부 격자 충전(siz_cd 룩업 완전).
면적매트릭스가 아니라 **규격별 고정 단가**(126의 52셀 면적격자와 대비). 단가행은 D-22로 전개 안 함(집계만·값=evaluate_price).

---

## 재사용한 공유 노드 (중복 mint 없음)

이 상품이 **재사용**하는 이미 존재하는 노드(내가 정의하지 않음):
- [[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_price_value_boundary]]·[[rule/rules#RULE_scope_boundary]]·
  [[rule/rules#RULE_dosu_is_printopt]]·[[rule/rules#RULE_import_material_no_delete]] (공유 규칙 축).
- [[product-type-classification-sot]]·[[harness-domain-rules-12-260701]] (외부 SOT 메모리 참조).
- [[GAP_roll_material_price]] (공유 GAP 축·rule/gaps.md — 실사 소재 단가 산정 암묵지·126은 product-local mint했으나
  132는 공유 GAP 재사용으로 재발명 회피).
- [[product-126-leather-artprint-nodes#material-MAT_000186]] (레더 자재 노드·형제 126 소유·132는 배선 안 함·참조만).
- category-CAT_000080 (보드액자·형제 실사 빌더 130 포맥스보드·131 프레임리스우드액자 소유·132는 in_category 재사용·
  재정의 안 함·L-3 중복 회피). 단일 canonical 승격은 needed_shared.

이 상품이 **처음 mint하는 실사 노드**(레더아트액자 전용 — 공유 축 파일 미수정 원칙으로 companion에 임시 거처):
size-132-SIZ_000304/306/308/310/172/174·formula-PRF_POSTER_LEATHER_FRAME·
component-COMP_POSTER_LEATHER_FRAME·gap 3종(material-unwired·frame-attribution·qty-tier)
→ [product-132-leather-art-frame-nodes.md](product-132-leather-art-frame-nodes.md). 공유 축(axis/categories·axis/sizes·
formula/·component/) 승격 후보는 build-report의 needed_shared로 반환(축 소유자가 canonical id 그대로 이관·126/122 선례).
