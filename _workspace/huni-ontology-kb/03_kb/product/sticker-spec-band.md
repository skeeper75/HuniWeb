<!-- namespace file: sticker-spec-band (반칼띠지스티커 PRD_000061) — 스티커 파일럿 규격형 family(058~061). -->
<!-- ★블록-노드 파일(frontmatter 아님) — L-1 파일명↔id 검사 예외(is_file_node=False). 축/formula 파일과 동형(square 059 선례). -->
<!-- ★공유 파일(index/axis/*/formula/*/rule/*) 미수정 — 스티커 공유 원자는 재사용(재민팅 금지·L-3 회피)·needed_shared_nodes 반환. -->
<!--   061 전용 축 원자(plate-061·qty-061·gap-061-*)는 sticker-spec-band-nodes.md에. 수치는 전사표(transcribe_product_061.py)에만. -->

# 스티커 파일럿 — 반칼띠지스티커 (PRD_000061)

반칼띠지스티커는 스티커 상품군의 **규격형 스티커**(상품마스터 260702 스티커 시트·라이브 `PRD_000061`)다.
규격(띠지형) 점착지에 CMYK 4도 단면 인쇄 후 **커팅**으로 시트 위에 낱장을 따는 규격스티커로, 규격형
family(058 원형·059 정사각·060 직사각·**061 띠지**)에 속한다. 상세 축 원자·가격공식·GAP은
[[sticker-spec-band-nodes]]가 담는다(스티커 전용 신규 축 = 공유축 승격 대기). ★061 라이브 shape는 형제
060(반칼직사각)과 **완전히 동일**(같은 카테고리·규격 사이즈·5소재·1공정·1판형·완제품가 격자 10조합)임을
전사표가 실증한다.

★스티커 파일럿 3대 특성(디지털인쇄 상품군과 다른 점·pack §0):
1. **가격 = 완제품가(시트가격) 고정가 룩업** — 원자합산형(인쇄비+용지비+공정비)이 **아니다**.
   `PRF_STK_FIXED`가 `COMP_STK_PRINT`(소재·규격·수량별 완제품가) 하나만 배선한다.
2. **소재 연당가(원자재 원가)는 이 상품 가격사슬에 노드로 없다** — 완제품가로 통째 저장(pack §4).
   061의 5개 소재는 260702 연당가 재적재 대상(투명/홀로/크라프트/투명후지)에 **해당 없음**(아래 연당가 절).
3. **코팅이 자재로 적재된 CONFLICT가 살아있다**(무광/유광코팅스티커=자재 vs Q9 코팅=공정·[[gap-061-coating-conflict]]).

## product 노드 (정체·유형 SOT)

### [product-061-band-sticker] 반칼띠지스티커 (PRD_000061) {verified}
- type: product
- anchor: t_prd_products/PRD_000061
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000061 (prd_nm=반칼띠지스티커·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§0(3대 특성·형상=size·완제품가 룩업)·§3.1 정체(PRD_TYPE.01 재분류·T-1)·§3.2 규격형 058~062 family·§3.10/§3.11 가격·§3.9 코팅 CONFLICT·§4-D 연당가 dual 판정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stk}
- src: {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "문서:§1 16상품 정체확정표(규격스티커 058~062 family)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
- rel: {rel: in_category, target: category-CAT_000002, note: "스티커(root·main_cat_yn=Y). 공유 재사용 노드(rectangle-nodes 등재)"}
- rel: {rel: in_category, target: category-CAT_000037, note: "규격스티커(상위 CAT_000002·main_cat_yn=N 부). 공유 재사용 노드"}
- rel: {rel: has_size, target: size-SIZ_000520, note: "A4(210x297) 반칼 전용가·활성·형제 060과 공유 규격 노드(적용=058~061). 공유 재사용 노드"}
- rel: {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·링크 활성이나 master del_yn=Y(6-17)→[[gap-061-a5-size-master-deleted]]. 047 정의 공유 재사용 노드"}
- rel: {rel: uses_material, target: material-MAT_000153, note: "유포스티커·MAT_TYPE.11·dflt. 공유 재사용 노드(rectangle-nodes)"}
- rel: {rel: uses_material, target: material-MAT_000084, note: "비코팅스티커·live MAT_TYPE.13(note는 .11 주장·불일치→[[gap-061-mat084-typ]]). 공유 재사용 노드(candidate)"}
- rel: {rel: uses_material, target: material-MAT_000242, note: "미색스티커·MAT_TYPE.11·6-14 종이(.01)→스티커(.11) 정정 note. 공유 재사용 노드"}
- rel: {rel: uses_material, target: material-MAT_000155, note: "무광코팅스티커·MAT_TYPE.11·★코팅=자재(BATCH-3 CONFLICT·[[gap-061-coating-conflict]]). 공유 재사용 노드"}
- rel: {rel: uses_material, target: material-MAT_000156, note: "유광코팅스티커·MAT_TYPE.11·★코팅=자재(BATCH-3 CONFLICT·[[gap-061-coating-conflict]]). 공유 재사용 노드"}
- rel: {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(앞 CMYK 4도·뒤 인쇄 안 함)·양면 미보유. 공유 축 재사용"}
- rel: {rel: has_process, target: process-PROC_000055, note: "스티커완칼(Die Cut+조각수)·mand_proc_yn=N·★상품명 '반칼'과 불일치→[[gap-061-halfcut-process]]. 공유 재사용 노드"}
- rel: {rel: has_plate_size, target: plate-061-SIZ_000521, note: "46전지 330x470(OUTPUT_PAPER_TYPE.02)·반칼 스티커 표준전지·활성·fn_best_plate 자동선택. 061 전용 노드([[sticker-spec-band-nodes#plate]])"}
- rel: {rel: has_qty_rule, target: qty-061, note: "상품레벨 min 4·max 10000·incr 4·QTY_UNIT.02(bundle_qtys 0행). 061 전용 노드"}
- rel: {rel: priced_by, target: formula-PRF_STK_FIXED, note: "완제품가 고정가 룩업(원자합산형 아님)·COMP_STK_PRINT (siz_cd,mat_cd,min_qty) 격자. 공유 재사용 노드"}
- props: {prd_typ_cd: "PRD_TYPE.01", archetype: "완제품가 고정가 룩업(형상×치수×코팅 격자·COMP_STK_PRINT)", file_upload_yn: "Y", editor_yn: "Y", use_yn: "Y", del_yn: "N", qty_src: "전사표(transcribe_product_061.py)·raw 손전사 아님"}
- standards: {schema_org: "Product", xjdf: "Product(스티커/라벨)", config_ont: "component type"}
- answers_cq: ["구체 상품 질의(반칼띠지스티커 구성·가격 경로)", "조건 탐색(규격 반칼 스티커·코팅 선택)"]
- 본문: 반칼띠지스티커는 스티커 **완제품 단일**(prd_typ_cd=PRD_TYPE.01·SOT 정합·[[product-type-classification-sot]]). t_prd_product_sets 부모/구성원 등록이 없어 셋트 아님(일반 단일 완제품). 기성/디자인 아님(제조 상품). 규격스티커 family(058~062) 소속·정체 오분류 0(pack §3.1). round-13 "전량 prd_typ.04 디자인상품"은 STALE — 라이브 재분류로 .01 완제품이 현재값(pack §1.1·T-1·전사표 실측 확증). file_upload·editor 양쪽 Y. 카테고리=스티커(CAT_000002 main)>규격스티커(CAT_000037 부).

## 차원 (형상=size·도수·수량규칙)

- **사이즈(형상=size):** 주문 사이즈 2행 = **SIZ_000520 A4(210x297) 반칼**(반칼 전용가·B02 낱장 SIZ_172와
  분리·규격형 058~061 적용)·**SIZ_000170 A5(148x210)**. 치수·판걸이수 raw는 [[sticker-spec-band-nodes#price-grid]]
  전사표 권위(손전사 금지). 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생(`fn_calc_pansu` t_siz_pansu lookup→기하
  폴백·[[rule/rules#RULE_pansu_db_function]]). SIZ_000170(A5)은 **master del_yn=Y(06-17 폐지)** 이나 상품-사이즈
  링크는 활성 → 상태 불일치([[gap-061-a5-size-master-deleted]]·단가행 36행 실재해 가격은 성립).
- **형상(칼틀):** 상품명은 "띠지"(가로로 긴 밴드형 규격)이나 **띠지 형상이 size에도 옵션에도 별도 저장되지
  않는다** — 규격형 058~062 형상 저장처 미결(pack GAP-ST-3·Q-ST-C). 066 합판도무송처럼 형상=siz_nm으로 흡수되지
  않고 규격/상품 정체에 내장(형상=size 1:1·pack §3.2). 형상을 자재/옵션으로 오판 금지(pack §0).
- **도수:** 단면 CMYK 4도(printopt-POPT_000001·앞 CLR_000005 4도·뒤 CLR_000001 인쇄 안 함). 도수는 인쇄옵션
  코드값이지 색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]·pack §3.3·T-2). 061은 단면만(양면 미보유).
  화이트 underbase(PROC_000008)는 061 미보유 — 불투명 규격 점착지라 별색 화이트 불요(투명 베이스 063과 대비).
- **수량규칙:** 제품 레벨 min 4 / max 10,000 / incr 4(QTY_UNIT.02 "매") <!-- lint-allow: L-12 src=SR-5-livesnap (수량 스칼라 설명·전사표 권위) -->. `t_prd_product_bundle_qtys`에
  061 행 **0**(제품 레벨 규칙만·전사 실측). 수량 UI 권위=제품/사이즈 수량규칙(가격구간과 역할 분리·pack §3.4·
  [[rule/decisions#DEC_qty_audit_260702]]). 하위 [[qty-061]] 노드.

## 자재·공정

- **자재:** 5종 전부 parent + usage_cd 단일 슬롯(USAGE.07·dflt Y·pack §3.5)·정답 자재유형 MAT_TYPE.11(스티커).
  - 베이스 점착지 3종: 유포스티커 `MAT_000153`(MAT_TYPE.11)·비코팅스티커 `MAT_000084`·미색스티커 `MAT_000242`
    (MAT_TYPE.11·6-14 종이(.01)→스티커(.11) 정정 note 실증·round-13 "혼재" 부분 STALE).
  - ★**MAT_000084 비코팅스티커 유형 불일치:** live `mat_typ_cd=MAT_TYPE.13`인데 note는 "→스티커(.11)"로 .11
    정정을 주장(note-값 불일치). 권위(260702) 자재유형 명시 부재로 단정 불가 → [[gap-061-mat084-typ]] 관찰
    (공유 재사용 노드 material-MAT_000084가 candidate로 보유).
  - ★**코팅 자재 2종(무광 MAT_000155·유광 MAT_000156):** 코팅이 **자재(MAT_TYPE.11)** 로 적재. Q9 권위=코팅=공정
    (PROC_000013·[[axis/processes#process-PROC_000013]]). round-11 §44=자재 variant 정당·가격표=비코팅/무광/유광
    3컬럼(코팅=가격축). **CONFLICT 미해소** → [[gap-061-coating-conflict]](단정 금지·pack §3.9·T-4). ★[HARD]
    실무진 IMPORT 등록 자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
  - 자재 전사·상세 = [[sticker-spec-band-nodes#reused]](재사용 원자)·전사표.
- **공정:** 라이브 `t_prd_product_processes` = **1행 = PROC_000055 스티커완칼**(Die Cut + 조각수·mand_proc_yn=N).
  ★**상품명 '반칼'과 등록 공정 불일치:** 반칼(Kiss Cut·종이만)은 PROC_000054, 061에 등록된 것은 PROC_000055
  스티커완칼(도무송 Die Cut). pack §3.6은 "디지털=반칼(PROC_000054)". 단 규격 family 058~061 전부 PROC_000055라
  family 관례일 수 있어 단정 불가 → [[gap-061-halfcut-process]] 관찰. 코팅 공정(PROC_000013)·화이트 underbase
  (PROC_000008)는 061 미보유(코팅은 자재로 적재됨·위 CONFLICT). ★**base 디지털 인쇄 공정(PROC_000004) 미보유는
  결함 아님** — 고정가 룩업 모델이라 인쇄비 별도 원자 구성요소 불요(완제품가에 통합·디지털 원자합산형의 인쇄비0
  결함과 다름·false-defect 회피·[[rule/rules#RULE_dataline_neq_wiring]] 반대사례).

## 판형 (plate size) — 종이류 유효

- 스티커 점착지=종이류 → 판형 대상([[rule/rules#RULE_plate_paper_only]]). 활성 판형 = **SIZ_000521 46전지
  330x470**(`output_paper_typ_cd=OUTPUT_PAPER_TYPE.02`·반칼 스티커 표준전지·dflt Y). 고객 미선택→`fn_best_plate`
  자동선택([[harness-domain-rules-12-260701]]). 판걸이수(UP)는 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).
  삭제 판형 2행(SIZ_000007/050·OUTPUT_PAPER_TYPE.03·6-30 del_yn=Y)은 유효 판형 아님. 061 전용 판형 노드
  = [[sticker-spec-band-nodes#plate]]([[plate-061-SIZ_000521]]).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원) — ★가격 경로 연결됨

- `product-061 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  단일 구성요소(고정가 룩업·pack §3.10). **끊긴 가격 사슬 아님**(priced_by 1개)·**고아 공식 아님**(has_component
  1개). 공식·구성요소 노드는 이미 등재된 공유 노드(formula-PRF_STK_FIXED·component-COMP_STK_PRINT)를 재사용
  (재민팅 금지·L-3 회피·[[sticker-spec-band-nodes#reused]]). 공유축 승격은 needed_shared_node.
- **완제품가 룩업 = 형상×치수×코팅 격자.** COMP_STK_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`(PRICE_TYPE.01).
  061의 10개 (siz,mat) 조합(2 사이즈 × 5 자재)이 전부 단가행 실재(각 36 수량구간행=360행)·격자 완비
  ([[sticker-spec-band-nodes#price-grid]] 전사·값 아님 행수 집계·D-22 접기). 면적매트릭스 아님·구간할인(t_dsc_*)
  비대상(pack §3.10). 소재축(비코팅/무광/유광)이 코팅 가격축을 흡수(pack §3.11).
- ★**소재 연당가는 이 격자에 없다** — COMP_PAPER(용지비)에 스티커 소재 mat_cd 0행(pack §3.11). 스티커는 원가
  (연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장. 값 절대치는 KB 밖(evaluate_price)·D-18 경계. §26/§27
  배선 수렴에서 스티커 몫 배선 결함 0(round22 잔여는 전부 아크릴 TBD·[[rule/decisions#DEC_wiring_round22_260702]]·
  pack §4-C). 절대값 골든은 미검증 → [[gap-061-golden]] 정직 선언.

## ★연당가 (돈-크리티컬) — 061은 재적재 워크리스트 대상 아님

- pack §4 연당가 양면(defect) 재적재 워크리스트 = **투명스티커(백색후지 MAT_000162/371)·홀로그램(163/590)·
  크라프트(164/591)·투명후지(372)**. **061의 5소재(153/084/242/155/156)는 이 목록에 없다** → 061에는 연당가 양면
  노드가 없다(정직·[[gap-061-yeondangga-scope]]).
- 근거: ① COMP_PAPER(용지비 절가)에 061 소재 mat_cd **0행**(실측) — 스티커는 원가를 절가로 펼치지 않고 완제품가로
  저장. ② 스티커 완제품 가격표(COMP_STK_PRINT)는 260702에서 **무변경**(pack §4-B·N2 라벨만) → retail=권위 일치
  → **retail 노드 dual 금지**(false-defect 회피). 따라서 061의 dual_nodes=∅. 원가 급락(투명/크라프트 등)의
  완제품가 전파 여부는 타 소재(투명/홀로/크라프트) 상품 소관의 열린 질문(061 무관·pack §4-D 후속).

## 옵션·제약·추가상품 (라이브 실측 — 전부 0행)

- **옵션그룹/옵션아이템:** `t_prd_product_option_groups` = 061 행 **0**(CPQ 옵션 레이어 미구성·pack §3.9 BATCH-6).
  손님 선택 축(사이즈·소재·코팅)은 상품 차원(has_size·uses_material)으로만 존재.
- **제약규칙:** `t_prd_product_constraints` = 061 행 **0**. 코팅×소재 물리제약 필요 여부는 §31 제약 하네스 소관
  (현재 GAP 아님·데모 미착수). 코팅이 자재로 적재된 상태(CONFLICT)라 제약 shape 설계는 CONFLICT 해소 후.
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 061 행 **0**(단품 인쇄물·부품조립 셋트 아님·
  완제품 단일 SOT 정합). 스티커팩 065만 세트(pack §3.12·061 무관).

## 승계·freshness 메모

- 정체·형상=size·완제품가 룩업 = pack §0/§3.1/§3.10 FRESH 승계(260702 권위). prd_typ=PRD_TYPE.01(T-1 STALE
  회피). 위키 `[STK-PRC-001]`(고정가 by siz)·`[STK-DIM-001]`(형상=칼틀)는 REVERIFY 통과 승계(pack §3.2·§3.10).
  위키 7절 결함표(T-6)는 시점 낡음 → §4/각 축 REVERIFY로 재조준(직접 이관 금지).
- 코팅 CONFLICT(BATCH-3)·반칼/완칼 공정 불일치·A5 마스터 삭제·MAT_000084 유형은 미결 GAP — 단정 금지·정직 선언
  (pack §5·T-4). 연당가 재적재(pack §4)는 061 소재 미해당(투명/홀로/크라프트만) — dual 노드 없음(honest N/A).
- STALE 회피: price-engine-ddl 8차원(T-2)·constraint_json(T-3)·판수=앱계산(T-7)·구 연당가 무대조(T-8) 미인용.
- 범위 밖 거절: 주문·배송·회원·쿠폰 질의는 KB 범위 밖([[rule/rules#RULE_scope_boundary]]·pack §0·§5-6).

> 상품 전용 하위 노드(전사표·판형·수량·GAP)는 [[sticker-spec-band-nodes]] companion에 있다(공유 axis/formula/rule
> 파일 미수정 원칙·square 059 선례). 공유 축 승격 후보(카테고리·규격 사이즈·점착지 5자재·스티커완칼·완제품가
> 공식/구성요소)는 needed_shared_node로 반환(재민팅 금지·L-3 회피).
