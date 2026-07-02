---
id: product-028-mini-folded-card
type: product
anchor: t_prd_products/PRD_000028
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000028", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§0 36 distinct/7구분(접지카드)·§3.4 GAP(미니 028 수량축 컨펌)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§1 접지카드 정체(round-13 승계·재검증 2026-07-03·prd_cd 라이브 실재 확인)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000021}
  - {rel: in_category, target: category-CAT_000001, note: "main_cat_yn=Y 엽서/카드 상위"}
  - {rel: has_size, target: size-SIZ_000008}
  - {rel: has_size, target: size-SIZ_000132}
  - {rel: has_size, target: size-SIZ_000133}
  - {rel: has_size, target: size-SIZ_000135}
  - {rel: uses_material, target: material-MAT_000074}
  - {rel: uses_material, target: material-MAT_000081}
  - {rel: uses_material, target: material-MAT_000082}
  - {rel: uses_material, target: material-MAT_000091}
  - {rel: uses_material, target: material-MAT_000092}
  - {rel: uses_material, target: material-MAT_000101}
  - {rel: uses_material, target: material-MAT_000108}
  - {rel: uses_material, target: material-MAT_000109}
  - {rel: uses_material, target: material-MAT_000113}
  - {rel: uses_material, target: material-MAT_000114}
  - {rel: uses_material, target: material-MAT_000115}
  - {rel: uses_material, target: material-MAT_000116}
  - {rel: uses_material, target: material-MAT_000123}
  - {rel: uses_material, target: material-MAT_000125}
  - {rel: has_print_option, target: printopt-POPT_000002}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: Y, note: "디지털인쇄 base·미바인딩=인쇄비0(팩 §4-A)"}}
  - {rel: has_process, target: process-PROC_000065, qualifier: {mand: N, note: "2단가로접지 옵션"}}
  - {rel: has_process, target: process-PROC_000066, qualifier: {mand: N, note: "2단세로접지 옵션"}}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: N, note: "가변텍스트 옵션"}}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: N, note: "가변이미지 옵션"}}
  - {rel: has_process, target: process-PROC_000037, qualifier: {mand: N, note: "박칼라(홀로그램)·가격경로 미배선=gap-028-foil-price-path"}}
  - {rel: has_process, target: process-PROC_000038, qualifier: {mand: N, note: "박칼라(금유광)·가격경로 미배선"}}
  - {rel: has_process, target: process-PROC_000039, qualifier: {mand: N, note: "박칼라(은유광)·가격경로 미배선"}}
  - {rel: has_process, target: process-PROC_000040, qualifier: {mand: N, note: "박칼라(먹유광)·가격경로 미배선"}}
  - {rel: has_process, target: process-PROC_000041, qualifier: {mand: N, note: "박칼라(동박)·가격경로 미배선"}}
  - {rel: has_process, target: process-PROC_000042, qualifier: {mand: N, note: "박칼라(적박)·가격경로 미배선"}}
  - {rel: has_process, target: process-PROC_000043, qualifier: {mand: N, note: "박칼라(청박)·가격경로 미배선"}}
  - {rel: has_process, target: process-PROC_000044, qualifier: {mand: N, note: "박칼라(트윙클)·가격경로 미배선"}}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01}
  - {rel: priced_by, target: formula-PRF_DGP_E}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 30
  max_qty: 10000
  qty_incr: 30
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
  use_yn: N
standards: {schema_org: Product, xjdf: "Product(접지카드)·FoldingIntent", config_ont: "component type"}
updated: 2026-07-03
---

# product-028 · 미니접지카드 (PRD_000028)

디지털인쇄 **완제품 단일**(`PRD_TYPE.01`·[[product-type-classification-sot]] 정합·셋트 아님·
`t_prd_product_sets` 부모/구성원 미등록). 접지카드 구분 그룹(팩 §0 7구분 중 하나)의 명함 크기
소형 판형. 파일 업로드로 주문(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`). 2단접지카드
[[product-027-bifold-card]]의 미니(명함) 버전으로 자재·공정 골격이 거의 동일하다(동형 상품).

> ★**라이브 현재값(미출시):** `use_yn=N`(del_yn=N). 이 상품은 스냅샷 20260702_1119 시점에
> **미출시 상태**로, 손님에게 노출되지 않는다. 가격공식 바인딩 노트도 "use_yn=N 미출시"로 명기돼
> 있다. 이는 라이브 **현재값**이며 결함 단정이 아니다(260702 권위가 "출시돼야 함"을 주장하지
> 않으므로 양면 노드로 만들지 않는다). 아래 CPQ 부재·박 가격경로 미배선은 이 미출시 상태와
> 정합하는 **미완 구축**이다.

## 정체·수량

<!-- transcribed-by: _meta/scripts/transcribe_product_028.py from live-snapshot/latest (snap_20260702_1119) t_prd_products prd_cd=PRD_000028 @ 2026-07-03 -->
| 필드 | 값 |
|---|---|
| prd_nm | 미니접지카드 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 30 |
| max_qty | 10000 |
| qty_incr | 30 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | N |
| del_yn | N |

- **수량 규칙:** 최소 30 · 최대 10000 · 증분 30 (단위 QTY_UNIT.02 "매"). 명함 크기(90×50 등)라
  한 판에 여러 컷이 앉아 30의 배수(multi-up)로 묶인다. 이 상품은 `t_prd_product_bundle_qtys`
  **0행**·사이즈 수량규칙 행 없음 → **수량 규칙 = 상품 스칼라(min/max/incr)** 로만 표현된다(별도
  `bundle_qty` 노드·`has_qty_rule` 엣지 없음 — 결함 아님·팩 §3.4 "수량 UI 권위=상품/사이즈
  규칙"의 상품레벨 케이스). ★팩 §3.4 GAP: 미니 상품(028류) 수량축 실무진 컨펌 대기 →
  [[gap-028-qty-confirm]].

## 차원 — 사이즈·도수

- **사이즈 4행**(미니접지카드·[[product-028-mini-folded-card-nodes]] 사이즈 절): SIZ_000008(90×50·재사용)·
  SIZ_000132(50×90·신규)·SIZ_000133(86×52·재사용)·SIZ_000135(52×86·신규). 가로형(008/133)과
  세로형(132/135) 쌍. 디지털 사이즈 = 이산(離散) 사이즈 행(면적매트릭스 아님·팩 §3.2).
  ★027(2단접지카드)이 100×150급 카드였다면 028은 **명함 크기**(재단 90×50·86×52)로, 접힌 후
  명함 지갑에 들어가는 미니 접지카드다.
- **도수 = 인쇄옵션**([[rule/rules#RULE_dosu_is_printopt]]): [[printopt-POPT_000002]] 양면 전용
  (front/back CLR_000005). 색상코드가 아니다(T-4 함정 회피).

## 자재/공정 BOM

- **자재 14종**(전부 USAGE.07·낱장 단일 슬롯·parent+usage_cd 모델·팩 §3.5): 공유 축 7종
  (백색모조지220 등·[[axis/materials]]) + 형제 재사용 3종(몽블랑210 [[product-027-nodes]]·아코팩
  [[product-023-shaped-postcard-nodes]]·띤또레또 [[product-027-nodes]]) + 미니 전용 신규 4종
  ([[product-028-mini-folded-card-nodes]] 자재 절 — 리사이클러스/매쉬멜로우/린넨커버/한지). 기본 =
  백색모조지 220g([[material-MAT_000074]]).
  - ★**자재코드 관찰(§17 소관·relitigate 아님):** 028의 아코팩/리사이클러스/매쉬멜로우/린넨커버/한지는
    `MAT_000113/114/115/116/125`인데, 형제 027은 같은 이름 자재를 `MAT_000347/348/349/350/356`으로
    쓴다. **같은 표시명·다른 코드**(표시중복 후보)로, 정리는 §17(기초데이터 표시중복) 트랙 소관이다.
    KB는 라이브 실재(028=113계열)를 그대로 기록한다.
- **공정 13종**: base [[process-PROC_000004]](디지털인쇄·mand·seq -1) + 접지 2(가로/세로
  PROC_000065/066) + 가변 2(PROC_000031/032) + **박 8종**(PROC_000037~044). ★별색·박·코팅은
  도수 아닌 공정(팩 §3.3·[[rule/rules#RULE_dosu_is_printopt]]). ★박 8종은
  [[rule/gaps#GAP_foil_parent_children]]의 실현형이나, **028은 027과 달리 박 옵션그룹도 박 분기
  공식도 없다**(아래 CPQ·GAP 참조).
- **판형**: [[plate-OUTPUT_PAPER_TYPE_01]] 국전계열(종이류만·`fn_best_plate` 자동선택·고객 미선택·
  SIZ_000499 출력용지). 판걸이수는 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

## 가격 경로 (priced_by → 공식 → has_component)

**base 가격 경로 연결됨**: product-028 → `priced_by` → [[formula/digital-formulas#formula-PRF_DGP_E]]
(원자합산형E·접지카드/접지리플렛) → `has_component` → 구성요소(인쇄비·용지비·접지비·타공비 등, 공유
공식 노드에 배선 완료). 값 계산은 **evaluate_price 단일 권위**([[rule/rules#RULE_price_value_boundary]]·D-18)
— KB는 "어떤 구성요소가 어떤 차원(use_dims)으로 붙나"까지만. 골든 스냅샷은 날짜 라벨로만 참조하고
이 노드에 수치 값을 기록하지 않는다(단가행은 D-22로 접음).

<!-- transcribed-by: _meta/scripts/transcribe_product_028.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas prd_cd=PRD_000028 @ 2026-07-03 -->
| frm_cd | note |
|---|---|
| PRF_DGP_E | 미니접지카드 → PRF_DGP_E (use_yn=N 미출시) |

- ★**박 가격 경로 미배선(GAP):** 028은 박 8종 공정을 상품에 붙였으나 **PRF_DGP_E_FOIL(박 분기
  공식)에 바인딩되지 않았고**(라이브 바인딩 행은 PRF_DGP_E 1개뿐), **박칼라 옵션그룹도 없다**.
  즉 손님이 박을 고를 수단도, 박비를 태울 공식도 없다 → 박 선택 시 가격 경로가 끊긴다.
  027은 두 공식(E + E_FOIL)에 바인딩되고 박칼라 옵션그룹(OPT_000033)을 갖는 것과 대비된다.
  정직 선언 → [[gap-028-foil-price-path]].

## CPQ 옵션 (has_option_group) — 현재 0건 (미구축·현재값)

live-snapshot 20260702_1119 실측: PRD_000028의 `t_prd_product_option_groups`·`t_prd_product_options`·
`t_prd_product_option_items` **전부 0행**. 즉 손님 선택 축(종이·접지·박칼라·후가공)이 CPQ 레이어로
**아직 구축되지 않았다**. 상품 레벨(t_prd_product_materials/processes/sizes)에는 자재·공정·사이즈가
붙어 있으나, 그것을 손님이 고르게 하는 옵션그룹이 없다. 이는 **미출시(use_yn=N) 상태와 정합하는
미완 구축**이며, 형제 027은 옵션그룹 5종을 갖는다(동형 전파 시 채워질 후보). `has_option_group`
엣지는 만들지 않는다(라이브 사실=옵션그룹 없음). 필요 옵션·제약 도출은 §31(제약규칙)·CPQ 매핑
트랙 소관.

## 제약 (constraint) — 현재 0건

`t_prd_product_constraints`에서 PRD_000028 활성 제약 **0건**(라이브 현재값). 결함이 아니며, 필요
제약(박칼라×지질 발색 물리제약 등) 도출은 §31 거버넌스 소관. 여기서는 제약 노드를 만들지 않는다.

## 추가상품 (has_addon) — 현재 0건

`t_prd_product_addons`에서 PRD_000028 **0행**(라이브 현재값). 027은 봉투 3템플릿 addon을 갖지만
028은 addon이 없다. `has_addon` 엣지 없음(라이브 사실).

## 승계·출처

정체·구분은 `_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md`(round-13 결함진단
문서·승계·재검증 2026-07-03·prd_cd 라이브 실재 확인). 축·배선 수치는 전부 `transcribe_product_028.py`
스크립트 전사(손전사 금지·transcribed-by 마커). 라이브 현재값(snap_20260702_1119)과 권위 엑셀 260702
간 값 충돌은 없음(양면 표기 불요) — 단 `use_yn=N`(미출시)·CPQ 0건·박 가격경로 미배선은 라이브
**현재값(미완 구축)** 으로 기록하며, 출시 시 채워야 할 항목은 GAP으로 분리 선언했다.
