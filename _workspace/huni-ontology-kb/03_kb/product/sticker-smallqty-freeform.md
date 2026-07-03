---
id: sticker-smallqty-freeform
type: product
anchor: t_prd_products/PRD_000064
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000064 (소량자유형스티커·prd_typ_cd=PRD_TYPE.01·use_yn=N(미출시)·del_yn=N·file_upload_yn=Y·editor_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(스티커 16상품 5분기)·§1.1(064 use_yn=N)·§3.1 정체·§3.6 커팅 반칼·§3.9 CPQ/BATCH-6·§3.10 완제품가 룩업·§4-D 연당가 판정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "문서:§0~1 스티커 정체(승계·재검증 2026-07-03 — prd_typ은 live PRD_TYPE.01로 갱신·T-1)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-sticker-identity}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000064,PRF_STK_FIXED) apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(root·main_cat_yn=Y·cat_lvl 1)·공유 재사용(052 companion 정의)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(cat_lvl 2·상위 CAT_000002)·공유 재사용"}
  - {rel: has_size, target: size-SIZ_000061, note: "50x70 소형반칼(판걸이 32.0·064 전용 신설)"}
  - {rel: has_size, target: size-SIZ_000062, note: "70x50 소형반칼(판걸이 32.0·064 전용 신설)"}
  - {rel: has_size, target: size-SIZ_000063, note: "50x94 소형반칼(판걸이 24.0·064 전용 신설)"}
  - {rel: has_size, target: size-SIZ_000064, note: "94x50 소형반칼(판걸이 24.0·064 전용 신설)"}
  - {rel: has_size, target: size-SIZ_000065, note: "65x65 소형반칼(판걸이 24.0·064 전용 신설)"}
  - {rel: has_size, target: size-SIZ_000043, note: "80x80(판걸이 15.0·재단 80·작업 84)·공유 재사용(product-045 header-tag 정의)"}
  - {rel: has_size, target: size-SIZ_000036, note: "94x94(판걸이 12.0·재단 94·작업 98)·공유 재사용(product-043 bg-opp 정의)"}
  - {rel: uses_material, target: material-MAT_000153, note: "유포스티커 80g(parent 코드·dflt)·공유 재사용(spec-rectangle 정의)"}
  - {rel: uses_material, target: material-MAT_000084, note: "비코팅스티커 90g·★mat_typ_cd=MAT_TYPE.13(note는 .11 선언·유형 드리프트 관찰)·공유 재사용"}
  - {rel: uses_material, target: material-MAT_000242, note: "미색스티커·공유 재사용(note '정정 종이(.01)→스티커(.11)')"}
  - {rel: uses_material, target: material-MAT_000155, note: "무광코팅스티커 90g·★코팅=자재 흡수(BATCH-3 CONFLICT 자재측)·공유 재사용"}
  - {rel: uses_material, target: material-MAT_000156, note: "유광코팅스티커 90g·★코팅=자재 흡수(BATCH-3 CONFLICT 자재측)·공유 재사용"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(front CMYK 4도·back 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000054, note: "반칼(Kiss Cut·종이만·opt disp 1·모양+조각수 param)·★052는 PROC_000122로 이관했으나 064는 구 PROC_000054 그대로 활성·공유 재사용(halfcut-hologram 정의)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_02, note: "46계열 출력용지(SIZ_000521 330x470)·점착지=종이류라 판형 유효·fn_best_plate 자동선택·공유 재사용(052 companion 정의)"}
  - {rel: has_qty_rule, target: qty-064}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "완제품가 고정가 룩업형(COMP_STK_PRINT·siz×mat×수량 격자)·공유 재사용"}
  - {rel: references, target: gap-064-cpq-missing, note: "CPQ 옵션 레이어 전면 부재(BATCH-6)"}
  - {rel: references, target: gap-064-coating-conflict, note: "코팅=자재(155/156)만·Q9 공정 권위와 상충(material-only·052보다 단일)"}
  - {rel: references, target: gap-064-liandan-out-of-scope, note: "064 소재 연당가 clean·워크리스트 포인터"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 32
  max_qty: 1000
  qty_incr: 32
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: N
  del_yn: N
  구분: "스티커(소량 자유형·완제품 단일·5분기 중 디지털 토너 반칼 계열·미출시 use_yn=N)"
  price_archetype: "완제품가 고정가 룩업(원자합산형 아님·소재 연당가 직접 노드 없음)"
  status_note: "미출시 상태(use_yn=N·063과 함께 비활성·pack §1.1). 값 raw는 companion 전사표 권위(스크립트 전사·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(소량 자유형 스티커 구성·가격 경로)", "조건 탐색(소량·자유형 반칼 스티커)", "미출시 상품 준비도(CPQ 부재)"]
tags: ["#스티커", "#반칼", "#자유형", "#소량", "#완제품가룩업", "#코팅CONFLICT", "#미출시", "#CPQ부재"]
updated: 2026-07-03
---

# product-064 소량자유형스티커 (PRD_000064)

소량자유형스티커는 스티커 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이며, 형제 052(반칼
자유형 스티커)의 **소량·소형 사이즈 변형**이다. 점착지(유포·비코팅·미색·무광코팅·유광코팅)에 칼라
단면 인쇄 후 **반칼(Kiss Cut·`PROC_000054`)** 로 자유형 모양대로 반만 잘라 떼어 쓴다. 파일 업로드
**및 에디터** 방식(`file_upload_yn=Y·editor_yn=Y` — 052는 에디터 미사용). 소량 수량대(최소 32매·최대 1,000매·32매 증분·단위 QTY_UNIT.02 "매"·전사표 권위). <!-- lint-allow: L-12 src=SR-5-livesnap 전사표(수량·상태) -->
카테고리 = 스티커 root(`CAT_000002`·main)·
자유형스티커(`CAT_000309`). ★**미출시 상태**(`use_yn=N` — 063 반칼팬시투명과 함께 비활성·pack §1.1).
수량·치수·단가행 raw 값은 [[sticker-smallqty-freeform-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**스티커 가격 = 완제품가(시트가격) 고정가 룩업**(원자합산형 아님·팩 §3.10). 소재 연당가(원자재
원가)는 이 상품 가격사슬에 **직접 노드로 존재하지 않는다**(완제품가로 통째 저장·§4-B). 아래 "가격
경로" 절 참조.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 소량자유형스티커는 `t_prd_product_sets`
  부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합·live sets 0행). 기성/디자인 아님.
- ★**prd_typ_cd 재분류 승계:** round-13 product-identity §0은 스티커 16상품 전량 `PRD_TYPE.04(디자인상품)`
  이라 했으나 live 실측 = `PRD_TYPE.01(완제품)`(SOT .04 폐기→재분류 교정 완료·팩 §1.1·T-1). 온톨로지는
  현재값 `PRD_TYPE.01` 채택. round-13 .04 서술은 STALE 인용 금지.
- 스티커 16상품 **인쇄방식 5분기** 중 064는 **디지털 토너 반칼 계열**(052와 동일 라우트, 사이즈·수량대만
  소형·소량). 형제 052와 달리 **커팅 공정을 이관하지 않고 구 `PROC_000054`(반칼)를 그대로 활성** 유지.
- ★**미출시(use_yn=N):** 준비 중 상품. 가격 격자는 충전(아래)됐으나 손님 선택 UI(CPQ)가 없어(§옵션 절)
  실판매 전 상태. 063과 함께 스티커 16상품 중 유일한 비활성 2종.

## 차원
- **사이즈:** 활성 7행 — 소형 5(50x70 `SIZ_000061`·70x50 `SIZ_000062`·50x94 `SIZ_000063`·94x50
  `SIZ_000064`·65x65 `SIZ_000065`·전부 판걸이 note 실재) + 80x80(`SIZ_000043`)·94x94(`SIZ_000036`).
  이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 소형 5행(061~065)은 **064 전용**(live에서 PRD_000064만
  사용) → companion 신설. 043/036은 헤더택·배경지가 공유하는 사이즈 → 기존 노드 재사용(중복 mint 없음).
  ★사이즈 master del_yn 전행 N(052의 A5 dangling 같은 양면 defect 없음). 판걸이수(UP수)는 사이즈의
  파생값(`fn_calc_pansu` t_siz_pansu lookup→기하 폴백·[[rule/rules#RULE_pansu_db_function]]). 치수 전사=
  [[sticker-smallqty-freeform-nodes#전사표-권위-라이브-스냅샷스크립트-전사]].
- **도수:** 단면 단일(POPT_000001·front CLR_000005 CMYK 4도·back CLR_000001 인쇄 안 함). 도수는
  색상코드가 아니라 인쇄옵션 코드([[rule/rules#RULE_dosu_is_printopt]]). 화이트 underbase(PROC_000008)는
  064에 없음(투명/홀로 베이스 상품군 몫·063 등).
- **수량규칙:** 제품 레벨 min 32 / max 1,000 / incr 32(QTY_UNIT.02·전사표 권위). `t_prd_product_bundle_qtys`에 <!-- lint-allow: L-12 src=SR-5-livesnap 전사표(수량·상태) -->
  064 행 **없음**(제품 레벨 규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·팩 §3.4).
  ★052(min 8·max 10,000)보다 좁은 소량대 = "소량" 상품명 정합. 하위 [[qty-064]]. <!-- lint-allow: L-12 src=SR-5-livesnap 052 대비 수량대 -->

## 자재·공정
- **자재:** 활성 5종(유포 `MAT_000153`·비코팅 `MAT_000084`·미색 `MAT_000242`·무광코팅 `MAT_000155`·
  유광코팅 `MAT_000156`) — parent+usage_cd 단일 슬롯(USAGE.07). 정답 자재유형 = MAT_TYPE.11(스티커·팩
  §3.5). ★**064는 052와 달리 PARENT 코드(153/084/242/155/156)를 그대로 사용**(052는 06-30~07-01
  자식코드 584/585/586/609/611로 재키잉). 064 미출시라 재키잉이 아직 반영 안 된 것으로 관찰(양면 defect가
  아니라 라이브 진행상태 관찰 — 재적재 시 자식코드 정합 확인 필요). ★IMPORT 시트 등록 자재는 "배선
  안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- ★**MAT_000084 자재유형 드리프트(관찰):** 비코팅스티커(084)의 `mat_typ_cd=MAT_TYPE.13`인데 note는
  "정정 2026-06-14 종이(.01)→스티커(.11) 점착지"로 **.11을 선언**(필드값 .13 ≠ note .11). 팩 §3.5 정답
  = MAT_TYPE.11. spec-rectangle companion에서 이미 `{candidate} (유형 관찰)`로 표기된 공유 노드라 여기서
  재정의하지 않고 관찰만 인계(재적재 시 유형 정합 대상). 064 밖 공유 자재 속성 결함.
- ★**코팅 CONFLICT(BATCH-3·material-only):** 무광/유광코팅스티커(155/156)가 **자재(점착지)** 로 흡수돼
  있고, **064에는 라미네이팅 공정(014/015)이 없다**(공정 1행=반칼 PROC_000054뿐). 즉 052(자재+공정 이중
  표현)와 달리 **064 코팅은 자재측 단일 표현** → 이중가산 위험은 낮으나, 실무진 Q9 권위=코팅=공정
  (PROC_000013)과는 여전히 상충. 260702 가격표=코팅을 가격컬럼축(비코팅/무광/유광)으로 취급(자재 흡수
  지지). **미해소** → 단정 금지·[[gap-064-coating-conflict]](양면 기록·Q-ST-A). 팩 §3.9·T-4.
- **공정:** 라이브 `t_prd_product_processes` 활성 **1행 — 반칼(PROC_000054·opt·disp 1·상위 없음)**.
  `PROC_000054` = Kiss Cut(종이만·스티커)·prcs_dtl_opt inputs=모양(string)+조각수(integer). ★052가 구
  PROC_000054에서 PROC_000122로 이관한 것과 달리 **064는 PROC_000054를 그대로 유지**(미출시라 이관 미반영
  관찰). mand_proc_yn=N(팩 §3.6은 반칼을 정체 공정으로 보나 064 라이브는 opt 표기 — 관찰). 화이트
  underbase·라미 코팅 공정 없음(064 라우트 단순).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-064 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  **고아 공식 아님**(has_component 1개=COMP_STK_PRINT)·**끊긴 가격 사슬 아님**(priced_by 1개). 공식/구성요소는
  스티커 공유 노드(052/053/spec-* 정의) 재사용 — 중복 mint 없음.
- ★**완제품가 룩업형(원자합산 아님):** COMP_STK_PRINT(PRICE_TYPE.01·`comp_typ_cd=PRC_COMPONENT_TYPE.06`)
  use_dims=`[siz_cd, mat_cd, min_qty]` — 스티커 완제품가(출력+가공 포함)를 (사이즈·소재·수량구간) 격자로
  통째 저장. ★**064 활성 (siz×mat) 35조합 전부 단가행 실재**(7사이즈 × 5소재 = 35, 조합당 36 수량구간행·
  [[sticker-smallqty-freeform-nodes#가격구성요소-완제품가-룩업]] 전사표 행수요약 35/35). 미출시(use_yn=N)
  임에도 **가격 격자는 완전 충전** — 견적 산출 자체는 가능(막는 것은 CPQ UI 부재·아래 옵션 절). 값 나열
  아님(단가행 접기·D-22)·값 계산=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).
- ★**소재 연당가는 이 사슬에 없다:** COMP_PAPER(용지비)에 064 소재(153/084/242/155/156) **0행**(실측)·
  t_mat_materials에 가격 컬럼 없음. 스티커는 원가(연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장
  (팩 §4-B). 연당가 재적재 판정은 [[gap-064-liandan-out-of-scope]] 참조(064 clean·false-defect 방지).

## 옵션·제약·추가상품 (라이브 실측)
- ★**옵션그룹 0 — CPQ 옵션 레이어 전면 부재(BATCH-6·GAP-ST-6):** `t_prd_product_option_groups`/
  `options`/`option_items` **전부 064 행 없음**(전사표 부재 확인 0/0/0). 052(종이/인쇄/커팅 3그룹)와 달리
  064는 손님이 소재·도수·커팅을 CPQ로 고를 수단이 아직 없다. 미출시(use_yn=N)와 정합(준비 미완). →
  [[gap-064-cpq-missing]](정직 GAP·BATCH-6 일괄 적재 대기). 자재/공정/도수 차원은 상품에 붙어 있으나
  (has_material/has_process/has_print_option) 옵션 레이어로 노출되지 않은 상태.
- **제약규칙:** `t_prd_product_constraints` = 064 행 **없음**(코팅×종이두께 등 물리제약 미등록). §31 제약
  하네스 소관(064 미출시·데모 미착수·GAP 아님).
- **추가상품:** `t_prd_product_addons` = 064 행 **없음**.
- **셋트:** `t_prd_product_sets` = 064 부모/자식 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).

## 판형 (출력용지규격·정리 이력 관찰)
- 활성 판형 = **46계열(`OUTPUT_PAPER_TYPE.02`·SIZ_000521 330x470 표준전지·dflt)** 단일. 판형=출력용지규격
  (작업사이즈 아님·고객 미선택·`fn_best_plate` 자동선택·종이류만 유효·[[rule/rules#RULE_plate_paper_only]]).
- ★**파일사양 7행 정리(관찰):** 2026-06-30 각 사이즈별 "파일사양" plate 행 7개(036/043/061~065·대개
  output_paper_typ 공란, 061만 OUTPUT_PAPER_TYPE.03/PDF)가 **논리삭제(del_yn=Y)** 되고 SIZ_000521 전지
  단일 활성으로 정리됨. 전사표 "삭제분" 참조. 판형 축은 052와 동일(46전지)이라 plate-OUTPUT_PAPER_TYPE_02
  공유 재사용.

## 승계·freshness 메모
- 정체·5분기·형상 의미 = 팩 §3.1/§3.6 FRESH 승계 + round-13 product-identity(승계·재검증 2026-07-03·
  prd_typ은 live로 갱신). round-13 결함 상태값(T-6)·prd_typ .04(T-1)은 STALE 인용 금지.
- 완제품가 룩업·연당가 별개 축 = 팩 §3.10/§4-B FRESH. CPQ 부재(BATCH-6) = 팩 §3.9 REVERIFY→live 실측
  0/0/0 확정.
- ★064 신사실(위키/round-13에 없던 live 실측): use_yn=N 미출시·PARENT 자재코드 유지(052 재키잉 미반영)·
  커팅 PROC_000054 미이관·CPQ 0행·plate 파일사양 7행 정리·소량 수량대(32/1000/32). live-snapshot
  20260702_1119.
- **연당가 재적재(§4-D):** 064 소재(유포/비코팅/미색/무광코팅/유광코팅)는 260702 substantive 연당가 변경
  대상 아님(전사표 "연당가 대조" 전행 NO·N2 라벨/무변). 팩 §4-A 돈-크리티컬 연당가 대개편(권위 단가값은
  팩 §4-A 표·`price-diff-260527-260702.csv` 전사 권위)은 **투명·홀로·크라프트·투명후지** 4소재 몫이라
  064 밖(053 반칼투명·063 반칼팬시투명 등). ⇒ 064 완제품가 retail 노드 dual 금지(false-defect 방지)·연당가 워크리스트는
  [[gap-064-liandan-out-of-scope]]로 정직 지연(진짜 양면 노드는 matcost-053-* 등에서 관리).

---

> 상품 전용 하위 노드(사이즈 5·수량·GAP 3)는 [[sticker-smallqty-freeform-nodes]] companion에 신설.
> 공유 재사용 노드(category-CAT_000002/309·material-MAT_000153/084/242/155/156·process-PROC_000054·
> plate-OUTPUT_PAPER_TYPE_02·printopt-POPT_000001·formula-PRF_STK_FIXED·component-COMP_STK_PRINT·
> size-SIZ_000043/036)는 피어 companion/axis에 이미 실재 → 중복 신설하지 않는다(L-3·053 패턴).
