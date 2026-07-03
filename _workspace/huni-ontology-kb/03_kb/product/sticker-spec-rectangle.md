---
id: sticker-spec-rectangle
type: product
anchor: t_prd_products/PRD_000060
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000060 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N 출시)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§0(3대 특성·형상=size·완제품가 룩업)·§3.1 정체(PRD_TYPE.01 재분류·T-1)·§3.10/§3.11 가격(COMP_STK_PRINT use_dims)·§3.9 코팅 CONFLICT·§4-D 연당가 dual 판정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stk}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000060,PRF_STK_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·disp 10)"}
  - {rel: in_category, target: category-CAT_000037, note: "규격스티커(상위 CAT_000002·main_cat_yn=N 부)"}
  - {rel: has_size, target: size-SIZ_000520, note: "A4(210x297mm) 반칼·dflt=Y·형상=size(규격형·반칼 전용가)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210mm)·dflt=Y·★t_siz_sizes 마스터 del_yn=Y(링크는 활성)→관찰 gap-060-a5-size-master-deleted"}
  - {rel: uses_material, target: material-MAT_000153, note: "유포스티커·MAT_TYPE.11·USAGE.07 단일 슬롯·dflt Y"}
  - {rel: uses_material, target: material-MAT_000084, note: "비코팅스티커·★live mat_typ=MAT_TYPE.13(note는 .11 정정 주장)→관찰 gap-060-mat084-typ"}
  - {rel: uses_material, target: material-MAT_000242, note: "미색스티커·MAT_TYPE.11·6-14 종이(.01)→스티커(.11) 정정 note"}
  - {rel: uses_material, target: material-MAT_000155, note: "무광코팅스티커·MAT_TYPE.11·★코팅=자재(BATCH-3 CONFLICT·gap-060-coating-conflict)"}
  - {rel: uses_material, target: material-MAT_000156, note: "유광코팅스티커·MAT_TYPE.11·★코팅=자재(BATCH-3 CONFLICT·gap-060-coating-conflict)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(앞 CMYK 4도·뒤 인쇄 안 함)·양면 미보유·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000055, qualifier: {mand: "N"}, note: "스티커완칼(Die Cut+조각수)·mand_proc_yn=N·★상품명 '반칼'과 불일치(반칼=PROC_000054 Kiss Cut)→관찰 gap-060-halfcut-process"}
  - {rel: has_plate_size, target: plate-060-SIZ_000521, note: "46전지 330x470(OUTPUT_PAPER_TYPE.02)·반칼 스티커 표준전지·활성(삭제 판형 2행 별도)·fn_best_plate 자동선택"}
  - {rel: has_qty_rule, target: qty-060, note: "상품레벨 min 4·max 10000·incr 4·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "완제품가 고정가 룩업(원자합산형 아님)·COMP_STK_PRINT (siz_cd,mat_cd,min_qty) 격자"}
props:
  prd_typ_cd: PRD_TYPE.01       # 완제품 단일(t_prd_product_sets 부모/구성원 0행 실측·SOT .01)
  archetype: "완제품가 고정가 룩업(형상×치수×코팅 격자·COMP_STK_PRINT)"
  min_qty: 4                    # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"
  editor_yn: "Y"               # ★에디터 지원(스티커 편집기·016류와 달리 editor_yn=Y)
  use_yn: "Y"                  # ★출시(라이브 활성·063/064 use_yn=N과 대비)
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반칼직사각스티커 구성·가격 경로)", "조건 탐색(규격 반칼 스티커·코팅 선택)"]
tags: ["#스티커", "#반칼", "#규격스티커", "#완제품가룩업", "#출시"]
updated: 2026-07-03
---

# product-060 반칼직사각스티커 (PRD_000060)

반칼직사각스티커는 스티커 상품군의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01` · `t_prd_product_sets`에
부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수)이다. 점착지(유포·비코팅·미색 +
무광/유광 코팅)에 칼라 단면 인쇄 후 A4/A5 규격 시트로 만드는 스티커. 카테고리는 **스티커**
(`CAT_000002`·main_cat_yn=Y)와 **규격스티커**(`CAT_000037`·부). 파일 업로드·**에디터 둘 다 지원**
(`file_upload_yn=Y`·`editor_yn=Y`)이며 **출시 상태**(`use_yn=Y`)다(063 반칼팬시투명·064 소량자유형이
`use_yn=N`인 것과 대비·pack §1.1).

가격은 스티커 특유의 **완제품가(시트가격) 고정가 룩업**으로 계산한다 — 원자합산형이 **아니다**
(pack §0-2·§3.10). 공식 `PRF_STK_FIXED`("스티커 규격/소재/수량별 단가")가 단일 구성요소
`COMP_STK_PRINT`(use_dims=`[siz_cd, mat_cd, min_qty]`)로 배선되고, 그 단가행에 (규격×소재×수량구간)별
완제품가가 통째로 저장된다. 값 계산은 `evaluate_price` 권위([[rule/rules#RULE_price_value_boundary]]·D-18 경계).

- **★스티커 3대 특성(pack §0) 적용:**
  1. **형상(칼틀)=size.** 060의 사이즈 축은 A4 반칼(SIZ_000520)·A5(SIZ_000170)로 규격형이며, 반칼
     직사각 형상 자체는 별도 차원이 아니라 상품 정체·규격에 내장된다(규격형 058~061 family·pack §3.2).
     형상을 자재/옵션으로 오판하지 않는다.
  2. **가격=형상×치수×코팅 격자=완제품가 룩업.** 소재 연당가(원자재 원가)는 스티커 가격사슬에 직접
     노드로 존재하지 않는다(pack §0-2·§3.11). 060의 단가행 격자는 10개 (siz,mat) 조합 전부 채워짐
     (각 36 수량구간행·[[product-060-rectangle-sticker-nodes#price-grid]] 전사).
  3. **코팅 자재 오적재(BATCH-3 CONFLICT)가 060에 살아있다.** 무광/유광코팅스티커(MAT_000155/156)가
     자재(MAT_TYPE.11)로 적재됐으나 Q9 권위는 코팅=공정(PROC_000013). 가격표는 비코팅/무광/유광
     3컬럼(코팅=가격축). **양립 곤란·미해소** → 단정하지 않고 [[gap-060-coating-conflict]]로 정직 선언
     (pack §3.9·T-4).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 반칼직사각스티커는 `t_prd_product_sets`
  부모 등록이 없어(셋트 아님·구성원 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님(제조 상품).
  ★pack §1.1·T-1: round-13 product-identity의 "전량 prd_typ_cd=PRD_TYPE.04(디자인상품)" 서술은
  **STALE** — 라이브 재분류로 `PRD_TYPE.01`이 현재값(전사표 실측 확증).
- 카테고리 = 스티커(`CAT_000002` main)·규격스티커(`CAT_000037` 상위 CAT_000002·부). 단일 상품군(스티커)
  이며 인쇄방식 5분기 중 **디지털 토너 계열**(pack §3.1). 형제 규격 반칼 스티커(058~061)와 같은 family
  (SIZ_000520 note "적용=반칼스티커(058~061)").

## 차원 (형상=size·도수·수량규칙)
- **사이즈(형상=size):** 2행 — **SIZ_000520 A4(210x297) 반칼**(반칼 전용가·dflt Y·규격형 058~061 적용)·
  **SIZ_000170 A5(148x210)**(dflt Y). 형상(반칼 직사각)은 규격/상품 정체에 내장(형상=size 1:1·pack §3.2).
  치수·판걸이수 raw는 [[product-060-rectangle-sticker-nodes#size]] 전사표 권위(손전사 금지). 판걸이수(UP수)는
  사이즈 컬럼이 아니라 파생(`fn_calc_pansu` t_siz_pansu lookup→기하 폴백·[[rule/rules#RULE_pansu_db_function]]).
  - ★**SIZ_000170 마스터 논리삭제 관찰:** `t_siz_sizes` SIZ_000170은 `del_yn=Y`(6-17 삭제)이나
    `t_prd_product_sizes` 060 링크는 `del_yn=N`(활성). 마스터-링크 상태 불일치 → [[gap-060-a5-size-master-deleted]]
    로 정직 선언(단정·자동교정 금지). 단가행은 SIZ_000170에 36행 실재(가격은 성립).
- **도수:** 인쇄옵션 코드값(단면 POPT_000001·앞 CMYK 4도 CLR_000005·뒤 인쇄 안 함 CLR_000001). 도수는
  색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]·pack §3.3·T-2). 060은 단면만(양면 미보유).
  화이트 underbase(PROC_000008)는 060 미보유 — 불투명 점착지라 별색 화이트 불요(투명 베이스 063과 대비).
- **수량규칙:** 제품 레벨 min 4 / max 10,000 / incr 4(QTY_UNIT.02 "매") <!-- lint-allow: L-12 src=SR-5-livesnap (수량 스칼라 설명·전사표 권위) -->. `t_prd_product_bundle_qtys`에
  060 행 **0**(제품 레벨 규칙만·전사 실측). 수량 UI 권위=제품/사이즈 수량규칙(가격구간과 역할 분리·
  pack §3.4·[[rule/decisions#DEC_qty_audit_260702]]). 하위 [[qty-060]] 노드.

## 자재·공정
- **자재:** 5종 전부 parent + usage_cd 단일 슬롯(USAGE.07·dflt Y·pack §3.5).
  - 베이스 점착지 3종: 유포스티커 `MAT_000153`(MAT_TYPE.11)·비코팅스티커 `MAT_000084`·미색스티커
    `MAT_000242`(MAT_TYPE.11). MAT_000242는 note "정정 2026-06-14: 종이(.01)→스티커(.11) 점착지"로
    자재유형 오염 교정 실증(pack §3.5·round-13 "혼재" 부분 STALE).
  - ★**MAT_000084 비코팅스티커 유형 불일치:** live `mat_typ_cd=MAT_TYPE.13`인데 note는 "→스티커(.11)
    점착지"로 .11 정정을 주장 — note-값 불일치. 정답 자재유형(pack §3.5=MAT_TYPE.11) 대비 어긋나나
    권위(260702)에 MAT_000084 자재유형 명시가 없어 **단정 불가** → [[gap-060-mat084-typ]] 관찰.
  - ★**코팅 자재 2종(무광 MAT_000155·유광 MAT_000156):** 코팅이 **자재(MAT_TYPE.11)** 로 적재. Q9 권위
    = 코팅=공정(PROC_000013·[[axis/processes#process-PROC_000013]]). round-11 §44=자재 variant 정당,
    가격표=비코팅/무광/유광 3컬럼(코팅=가격축). **CONFLICT 미해소** → [[gap-060-coating-conflict]](단정 금지·
    pack §3.9·T-4). ★[HARD] 실무진 IMPORT 등록 자재는 "배선 안 됐다"고 삭제 금지
    ([[rule/rules#RULE_import_material_no_delete]]).
  - 자재 상세 전사 = [[product-060-rectangle-sticker-nodes#material]].
- **공정:** 라이브 `t_prd_product_processes` = **1행 = PROC_000055 스티커완칼**(Die Cut + 조각수·
  mand_proc_yn=N). ★**상품명 '반칼'과 등록 공정 불일치:** 반칼(Kiss Cut·종이만)은 PROC_000054, 060에
  등록된 것은 PROC_000055 스티커완칼(도무송 Die Cut). pack §3.6은 "디지털=반칼(PROC_000054)". 어느 쪽이
  정답인지 권위가 없어 **단정 불가** → [[gap-060-halfcut-process]] 관찰. 코팅 공정(PROC_000013)·화이트
  underbase(PROC_000008)는 060 미보유(코팅은 자재로 적재됨·위 CONFLICT). base 디지털 인쇄 공정
  (PROC_000004)도 미보유 — 고정가 룩업 모델이라 인쇄비 별도 구성요소 불요(완제품가에 통합·§26 base-proc
  누락 결함과 무관·다른 가격 모델).
  - 공정 상세 전사 = [[product-060-rectangle-sticker-nodes#process]].

## 판형 (plate size) — 종이류 유효
- 스티커 점착지=종이류 → 판형 대상([[rule/rules#RULE_plate_paper_only]]). 활성 판형 = **SIZ_000521
  46전지 330x470**(`output_paper_typ_cd=OUTPUT_PAPER_TYPE.02`·반칼 스티커 표준전지·dflt Y). 고객 미선택
  →`fn_best_plate` 자동선택([[harness-domain-rules-12-260701]]). 판걸이수(UP)는 파생(`fn_calc_pansu`·
  [[rule/rules#RULE_pansu_db_function]]).
- ★삭제 판형 2행: SIZ_000007(OUTPUT_PAPER_TYPE.03·엽서)·SIZ_000050(OUTPUT_PAPER_TYPE.03·A4)은
  `del_yn=Y`(6-30 논리삭제). 현재 유효 판형은 SIZ_000521 단일. 전사 = [[product-060-rectangle-sticker-nodes#plate]].

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원) — ★가격 경로 연결됨
- `product-060 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  단일 구성요소(고정가 룩업·pack §3.10). **끊긴 가격 사슬 아님**(priced_by 1개)·**고아 공식 아님**
  (has_component 1개). 공식·구성요소 노드는 스티커 파일럿 첫 상품이라 [[product-060-rectangle-sticker-nodes]]에
  신설(공유 formula/* 미수정·needed_shared_node로 승격 반환).
- **완제품가 룩업 = 형상×치수×코팅 격자.** COMP_STK_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`
  (PRICE_TYPE.01). 060의 10개 (siz,mat) 조합(2 사이즈 × 5 자재)이 전부 단가행 실재(각 36 수량구간행=
  360행)·격자 완비([[product-060-rectangle-sticker-nodes#price-grid]] 전사·값 아님 행수 집계·D-22 접기).
  면적매트릭스 아님·구간할인(t_dsc_*) 비대상(pack §3.10).
- ★**소재 연당가는 이 격자에 없다** — COMP_PAPER(용지비)에 스티커 소재 mat_cd 0행(pack §3.11). 스티커는
  원가(연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장. **060 자재의 연당가 양면(defect) 노드는
  해당 없음** — 060 소재(유포/비코팅/미색/무광·유광코팅)는 260702 price-diff에서 **N2 라벨 변경만**(가격
  무영향)이고, 연당가 급변 소재(투명 162/홀로 163/크라프트 164/투명후지 372·pack §4-A)를 **060은 쓰지
  않는다**. 즉 연당가 재적재 워크리스트(pack §4-D)는 다른 스티커 상품(예 063 반칼팬시투명) 몫이며 060은
  dual 대상 아님(false-defect 방지·정직 선언). 근거 = [[gap-060-yeondangga-scope]].
- 값 절대치는 KB 밖(evaluate_price)·D-18 경계. §26/§27 배선 수렴에서 스티커 몫 배선 결함 0(round22 잔여는
  전부 아크릴 TBD·[[rule/decisions#DEC_wiring_round22_260702]]·pack §4-C). 절대값 골든은 미검증
  → [[gap-060-golden]] 정직 선언.

## 옵션·제약·추가상품 (라이브 실측 — 전부 0행)
- **옵션그룹/옵션아이템:** `t_prd_product_option_groups` = 060 행 **0**(CPQ 옵션 레이어 미구성·pack §3.9
  BATCH-6 계열). 손님 선택 축(사이즈·소재·코팅)은 상품 차원(has_size·uses_material)으로만 존재.
- **제약규칙:** `t_prd_product_constraints` = 060 행 **0**. 코팅×소재 물리제약 필요 여부는 §31 제약 하네스
  소관(현재 GAP 아님·데모 미착수). 코팅이 자재로 적재된 상태(CONFLICT)라 제약 shape 설계는 CONFLICT 해소 후.
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 060 행 **0**(단품 인쇄물·부품조립 셋트
  아님·완제품 단일 SOT 정합). 스티커팩 065만 세트(pack §3.12·060 무관).

## 승계·freshness 메모
- 정체·형상=size·완제품가 룩업 = pack §0/§3.1/§3.10 FRESH 승계(260702 권위). prd_typ=PRD_TYPE.01
  (T-1 STALE 회피). 위키 `[STK-PRC-001]`(고정가 by siz)·`[STK-DIM-001]`(형상=칼틀)는 REVERIFY 통과 승계
  (pack §3.2·§3.10). 위키 7절 결함표(T-6)는 시점 낡음 → §4/각 축 REVERIFY로 재조준(직접 이관 금지).
- 코팅 CONFLICT(BATCH-3)·반칼/완칼 공정 불일치·A5 마스터 삭제·MAT_000084 유형은 미결 GAP — 단정 금지·
  정직 선언(pack §5·T-4).
- 연당가 재적재(pack §4)는 060 소재 미해당(투명/홀로/크라프트만) — dual 노드 없음(honest N/A).
- 범위 밖 거절: 주문·배송·회원·쿠폰 질의는 KB 범위 밖([[rule/rules#RULE_scope_boundary]]·pack §0·§5-6).

> 상품 전용 하위 노드(전사표·사이즈·자재·공정·판형·카테고리·공식·구성요소·수량·GAP)는
> [[product-060-rectangle-sticker-nodes]] companion에 있다(공유 axis/formula/rule 파일 미수정 원칙·
> 023/051 선례). 공유 축 승격 후보(카테고리·자재·공정·판형·공식·구성요소)는 needed_shared_node로 반환.
