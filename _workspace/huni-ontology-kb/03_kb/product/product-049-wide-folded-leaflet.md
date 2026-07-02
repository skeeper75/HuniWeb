---
id: product-049-wide-folded-leaflet
type: product
anchor: t_prd_products/PRD_000049
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000049 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§0 7구분(인쇄홍보물)·§3 축별 큐레이션·§4-E 3절 라인 미출시 동형처리", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "§1 인쇄홍보물 PRD_000049 와이드 접지리플렛·PRF_DGP_E 힌트", captured_at: "2026-07-03", badge: verified, src_id: SR-worklist-dp}
relations:
  - {rel: in_category, target: category-CAT_000003}
  - {rel: in_category, target: category-CAT_000058, note: "전단지/리플랫 lvl2(신규·product-049-nodes)"}
  - {rel: has_size, target: size-SIZ_000055, note: "640x297 와이드 단일 사이즈(신규)"}
  - {rel: uses_material, target: material-MAT_000083}
  - {rel: uses_material, target: material-MAT_000093}
  - {rel: uses_material, target: material-MAT_000110}
  - {rel: uses_material, target: material-MAT_000111}
  - {rel: uses_material, target: material-MAT_000112}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 고정(라이브 인쇄옵션 1행·front/back CLR_000005)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: Y, note: "디지털인쇄 base(mand_proc_yn=Y·disp_seq -1)"}}
  - {rel: has_process, target: process-PROC_000014, qualifier: {mand: N, note: "유광라미네이팅 옵션"}}
  - {rel: has_process, target: process-PROC_000015, qualifier: {mand: N, note: "무광라미네이팅 옵션"}}
  - {rel: has_process, target: process-PROC_000060, qualifier: {mand: N, note: "3단접지 옵션(신규 공정)"}}
  - {rel: has_process, target: process-PROC_000071, qualifier: {mand: N, note: "병풍접지 옵션(신규 공정)"}}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: N, note: "가변텍스트 옵션"}}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: N, note: "가변이미지 옵션"}}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_03, note: "기타 출력용지(.03)·국전 초과 와이드(신규)"}
  - {rel: priced_by, target: formula-PRF_DGP_E}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 2
  max_qty: 100000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
standards: {schema_org: Product, xjdf: "Product(리플렛)·FoldingIntent(3-panel/accordion)", config_ont: "component type"}
updated: 2026-07-03
---

# product-049 · 와이드 접지리플렛 (PRD_000049)

디지털인쇄 **완제품 단일**(`PRD_TYPE.01`·[[product-type-classification-sot]] 정합·셋트 아님·
`t_prd_product_sets` 부모/구성원 미등록). **인쇄홍보물**(CAT_000003) > 전단지/리플랫(CAT_000058)
구분(팩 §0 7구분 중 "인쇄홍보물"). 파일 업로드로 주문(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`).
형제 접지카드 [[product-027-bifold-card]]·[[product-029-trifold-card]]와 **같은 원자합산형 공식
(PRF_DGP_E)** 을 쓰지만, ① 단일 **와이드 사이즈(640×297)** ② "3절" 지질 5종 ③ 3단/병풍 접지 공정
④ 국전 초과라 **출력용지 "기타"(.03) 판형** ⑤ **CPQ 옵션그룹 미등록**이라는 점이 다르다.

## 정체·수량

<!-- transcribed-by: _meta/scripts/transcribe_product_049.py from live-snapshot/latest (snap_20260702_1119) t_prd_products prd_cd=PRD_000049 @ 2026-07-03 -->
| 필드 | 값 |
|---|---|
| prd_nm | 와이드 접지리플렛 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 2 |
| max_qty | 100000 |
| qty_incr | 1 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | Y |
| del_yn | N |

- **수량 규칙:** 최소 2 · 최대 100000 · 증분 1 (단위 QTY_UNIT.02 "매"). 이 상품은
  `t_prd_product_bundle_qtys`·사이즈 수량규칙 행이 **라이브 0행**이라 수량 규칙 = **상품 스칼라**
  (min/max/incr)로만 표현된다(별도 `bundle_qty` 노드·`has_qty_rule` 엣지 없음 — 결함 아님·팩 §3.4
  "수량 UI 권위=상품/사이즈 규칙"의 상품레벨 케이스·형제 027/029와 동일 패턴, 값만 다름).

## 차원 — 사이즈·도수

- **사이즈 1행**(신규 mint·[[product-049-wide-folded-leaflet-nodes]] 사이즈 절): [[size-SIZ_000055]]
  640×297(재단)·646×303(작업)·와이드 단일. ★디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2).
  접지 전개(펼침)의 3단/병풍 기하는 master(t_siz_sizes) 재단값이 권위이며 이 노드는 전사값만 기록한다
  (접지 폴딩 산식 날조 금지).
- **도수 = 인쇄옵션**([[rule/rules#RULE_dosu_is_printopt]]): [[printopt-POPT_000002]] 양면 전용
  (라이브 인쇄옵션 1행·front/back CLR_000005·opt_id=1). 색상코드가 아니다(T-4 함정 회피).

## 자재/공정 BOM

- **자재 5종**(전부 USAGE.07·낱장 단일 슬롯·신규 4 + 재사용 1·[[product-049-wide-folded-leaflet-nodes]]):
  [[material-MAT_000083]] 아트지150g(3절)·[[material-MAT_000093]] 스노우지250g(3절)·[[material-MAT_000111]]
  몽블랑190g(3절)·[[material-MAT_000112]] 몽블랑240g(3절) 신규 mint + [[material-MAT_000110]] 몽블랑130g(3절)은
  형제 지그재그엽서([[product-030-zigzag-postcard-nodes]]) 정의 **재사용**(L-3). 형제 접지카드 자재와는
  **다른 mat_cd("3절" 변형)**. ★[HARD] IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정 7행**: base [[process-PROC_000004]](디지털인쇄·mand_proc_yn=Y·disp_seq -1) + **접지 2종
  신규([[product-049-wide-folded-leaflet-nodes]] PROC_000060 3단접지/PROC_000071 병풍접지)** + 라미
  2종([[axis/processes]] PROC_000014 유광/PROC_000015 무광) + 가변 2종([[axis/processes]]
  PROC_000031/032). ★접지·라미·가변은 도수 아닌 공정(팩 §3.3). 별색·박 공정은 라이브 부착 없음
  (형제 027/029의 박 8종 대비 049는 박 미부착 — 현재값).
- **판형**: [[plate-OUTPUT_PAPER_TYPE_03]] **기타 출력용지(.03)** — 재단 640mm가 국전(467) 초과라
  국전(.01) 대신 기타(활성 규격 SIZ_000475=330×660)를 쓴다(★.03 판형 노드는 형제 지그재그엽서
  [[product-030-zigzag-postcard-nodes]] 정의 **재사용**·L-3). 종이류만·`fn_best_plate` 자동선택·고객
  미선택([[rule/rules#RULE_plate_paper_only]]). 판걸이수는 파생(`fn_calc_pansu`·
  [[rule/rules#RULE_pansu_db_function]]). 팩 §3.8 "디지털 전 상품 .01 국전"의 와이드 예외(결함 아님).

## 가격 경로 (priced_by → 공식 → has_component)

라이브 단일 바인딩(전사표 "가격공식 바인딩"):
- [[formula/digital-formulas#formula-PRF_DGP_E]] — `frm_nm`이 문자 그대로 "디지털인쇄 원자합산형E
  **접지카드·접지리플렛**"(apply_bgn 2026-07-01·use_yn=Y). 원자합산형 = [출력] + [소재] + [후가공].
  이 공식 노드는 `has_component` 11 구성요소 배선을 이미 보유(고아 공식 아님·O5/O6 충족·배선은 공유
  공식 노드 소관·형제 접지카드와 재사용). 049는 형제 027/029와 달리 박 분기(PRF_DGP_E_FOIL) 미바인딩.

가격 값 계산은 **evaluate_price 단일 권위**([[rule/rules#RULE_price_value_boundary]]·D-18) —
KB는 "어떤 구성요소가 어떤 차원(use_dims)으로 붙나"까지만. 골든 스냅샷은 날짜 라벨로만 참조하며 이
노드에 수치 값을 기록하지 않는다(단가행은 D-22로 접음). **가격 경로 연결 완료:** product-049
`priced_by`→ PRF_DGP_E `has_component`→ 구성요소(공유 공식 노드).

## CPQ 옵션 (has_option_group) — 라이브 0건 → GAP

와이드 리플렛은 `t_prd_product_option_groups` **라이브 0행**이라 손님 선택 옵션그룹이 없다. 부착된
접지/라미/가변 공정을 손님이 고를 CPQ 축이 미등록 → 옵션→차원 환원 경로가 끊긴다. 지어내지 않고
[[gap-049-cpq-optiongroups]]로 정직 선언(형제 027/029 동형 참조로 설계·§31 거버넌스·인간 승인·상세는
[[product-049-wide-folded-leaflet-nodes]]). 제약(constraint)·추가상품(addon)도 라이브 0건(현재값).

## 승계·출처

정체·구분은 팩(`pack-digital-print.md` §0 7구분·§4-E)·워크리스트(`worklist-digitalprint-remaining.md`
§1 인쇄홍보물)·live-snapshot(prd_cd 라이브 실재 확인)에 앵커. 축·판형·배선 수치는 전부
`transcribe_product_049.py` 스크립트 전사(손전사 금지·transcribed-by 마커). 라이브 현재값
(snap_20260702_1119)과 권위 엑셀 260702 충돌 없음(양면 표기 불요·형제 접지카드와 동형 공식·pack §3 축 정합).
