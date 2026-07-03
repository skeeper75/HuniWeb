<!-- product-local sub-nodes: 반칼 자유형 홀로그램스티커 PRD_000054 전용 축·공식·구성요소·연당가 양면·GAP. -->
<!-- ★스티커 파일럿 첫 상품. category(CAT_000002/309)·material(MAT_000163)·process(PROC_000054/008)· -->
<!--   plate(OUTPUT_PAPER_TYPE.02)·formula(PRF_STK_FIXED)·component(COMP_STK_PRINT)은 다상품 공유 성격이나 -->
<!--   공유 축 파일(axis/·formula/) 수정 금지 규칙 때문에 여기 임시 거처(051 썬캡 선례). 2번째 스티커 집필 시 -->
<!--   canonical id 그대로 공유 축으로 승격(needed_shared_nodes로 반환). 승격 전까지 broken link 방지용. -->
<!-- ★수치(치수·평량·수량·연당가)는 전사표(transcribed-by·transcribe_product_054.py)에만. props raw 미기입(D-9·L-12). -->

# 반칼 자유형 홀로그램스티커 (PRD_000054) 하위 노드

[[sticker-halfcut-hologram]]이 쓰는 사이즈 2행·판형 1행·자재(홀로그램)·공정 2·수량규칙·가격공식·완제품가 구성요소,
그리고 ★연당가 양면(defect) 노드 + GAP. 상품→축 연결(has_size·uses_material·has_process 등)은 상품 파일이 건다.

---

## 카테고리 노드 (★공유 노드 — needed_shared·중복 mint 금지)

> ★[category-CAT_000002] 스티커·[category-CAT_000309] 자유형스티커는 스티커 상품군 전체가 공유하는
> 노드다. 병렬 집필된 형제 스티커 상품(052·055·057·060 등 sticker-*-nodes)이 이미 선언 중이므로,
> 이 파일은 **재선언하지 않고 참조만** 한다(L-3 중복 방지·HARD 규칙 "공유 노드는 needed_shared 반환만").
> [[sticker-halfcut-hologram]]의 in_category 엣지가 형제 파일/통합 단계의 canonical 노드로 resolve.
> → needed_shared_nodes 반환: category-CAT_000002·category-CAT_000309(axis/categories.md 승격 대상).

## 사이즈 노드 (product-local — 축 승격 대기)

### [size-054-SIZ_000170] A5 148x210 (홀로스티커 주문 사이즈) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000170
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000054,SIZ_000170) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000170(A5 148x210·마스터 del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000170", note: "★주의: 상품-사이즈 링크는 활성(del_yn=N)이나 사이즈 마스터(t_siz_sizes)는 del_yn=Y(2026-06-17 논리삭제) — 링크 활성/마스터 삭제 불일치. 그럼에도 완제품가 격자(COMP_STK_PRINT×MAT_000163)에 SIZ_000170 36행 실재 → 가격 경로는 성립. 데이터 정합 관찰(단정 아님)"}
- 본문: A5(148×210) 주문 사이즈. 마스터 논리삭제와 링크 활성 불일치를 정직 표기([[sticker-halfcut-hologram]] has_size).

### [size-054-SIZ_000520] A4 반칼 (홀로스티커 규격 래퍼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000520
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000054,SIZ_000520) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000520(A4 반칼·work/cut 컬럼 공백·note 판걸이=2.0)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000520", note: "A4(210×297) 반칼 규격 래퍼(라벨에 치수 인코딩·work/cut 마스터 컬럼 공백). note='판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가)'. 판걸이수 2는 사이즈 파생([[rule/rules#RULE_pansu_db_function]])"}
- 본문: A4 반칼 전용 사이즈. 낱장 사이즈와 분리된 반칼 전용가 래퍼([[sticker-halfcut-hologram]] has_size).

## 판형 노드 (종이류=점착지·판형 유효)

### [plate-054-SIZ_000521] 46계열 전지 330x470 (반칼스티커 표준전지) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000054
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000054,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02 dflt_plt_yn=Y (삭제된 SIZ_000007/050/057 제외)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000521(330x470·tags=46전지·note 전지(46계열)·반칼 스티커 표준전지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_cod_base_codes.csv", source_locator: "키:OUTPUT_PAPER_TYPE.02(46계열)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000521", output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", note: "★타 디지털 판형=OUTPUT_PAPER_TYPE.01(국전 316x467·[[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])과 달리 46계열(330x470 46전지). 반칼 스티커 표준전지. 종이류(점착지)라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택 fn_best_plate 자동선택(dflt Y·[[harness-domain-rules-12-260701]]). OUTPUT_PAPER_TYPE.02는 공유 axis/plate-sizes.md 미등재 — 승격 대기(needed_shared)"}
- 본문: 46계열 전지(330×470)를 출력용지로 쓰는 판형. 국전 계열과 상이·46전지 표준([[sticker-halfcut-hologram]] has_plate_size).

## 자재 노드 (홀로그램 점착지)

## ★연당가 양면(defect) 노드 — 소재 원가 재적재 워크리스트 (§4-D 돈-크리티컬)

### [matcost-054-hologram] 홀로그램 소재 연당가/국4절 (현재값 vs 260702 정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000163
- badge: defect
- current_value: "연당가/국4절 원가 라이브 미저장 — t_mat_materials에 가격 컬럼 없음 + COMP_PAPER(용지비)에 MAT_000163 0행(실측). 즉 홀로그램 소재 원가는 라이브 스티커 가격사슬에 노드로 존재하지 않음. 평량 50·명 '홀로그램스티커'는 260702와 일치(live-snapshot 20260702_1119)"
- authority_value: "260702 권위(price-diff 전사): 연당가 253,700(360,000→253,700)·국4절가 846(936→846)·평량 50(무변)·1박스당 300매(500→300). (docs/huni/후니프린팅_상품마스터_260702.xlsx#출력소재(IMPORT)!홀로스 via 26_change-tracking-260702/price-diff-260527-260702.csv L31~33)"
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "sheet:출력소재(IMPORT) key:홀로스 연당가H(360000→253700)·국4절I(936→846)·구매정보F(500→300매)", captured_at: "2026-07-03", badge: defect, src_id: SR-2.2-diff}
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000163(가격 컬럼 부재) + COMP_PAPER에 MAT_000163 0행(t_prc_component_prices)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {note: "★연당가 재적재 워크리스트(§4-D). 260702 연당가 급락(360k→253.7k·국4절 936→846)이 라이브에 미반영(저장처 부재). 어느 쪽도 삭제 금지 — current(미저장)·authority(260702) 둘 다 보존해 재적재 추적. ★단 이 원가 변화가 완제품 retail 격자(COMP_STK_PRINT)로 전파돼야 하는지는 열린 질문([[gap-054-yeondangga-repricing]]) — retail 격자는 260702 무변경이라 [[component-COMP_STK_PRINT]]는 dual 아님(false-defect 방지)"}
- rel: {rel: references, target: material-MAT_000163, note: "이 원가 defect가 가리키는 소재 identity 노드"}
- 본문: 홀로그램 소재의 연당가/국4절 원가가 260702 권위와 라이브 사이에서 어긋난다(라이브=원가 미저장). 스티커는 완제품가(시트가격) 룩업이라 소재 원가를 절가 노드로 펼치지 않음(§3.11) — 그래서 이 양면 노드가 "재적재 워크리스트"의 정직한 기록이다. High 재적재 대기.

## 공정 노드 (스티커 정체 공정)

### 화이트인쇄 (PROC_000008·underbase·별색 자식) — ★공유 노드 참조만

> [process-PROC_000008] 화이트인쇄(underbase)는 이미 [[product-020-white-print-postcard-nodes]]가
> 선언한 공유 공정 노드다(019/020/025/054 공용). 이 파일은 **재선언하지 않고 참조만** 한다(L-3 중복 방지).
> [[sticker-halfcut-hologram]]의 has_process 엣지가 그 canonical 노드로 resolve.
> 의미: 화이트 underbase=별색인쇄(PROC_000007) 자식·홀로그램 베이스 위 인쇄 가시화용·도수 아님
> (clr_cd=NULL·[[rule/rules#RULE_dosu_is_printopt]]·pack §3.3). ★054에서 mand=N(선택)·가격 배선 불투명
> ([[gap-054-white-underbase-price]]). 063과 달리 054는 화이트 공정 실재(pack §3.3 GAP-ST(화이트)는 063만).
> → needed_shared_nodes 반환: process-PROC_000008(axis/processes.md 승격 대상·현재 product-020-nodes 거처).

## 가격공식·구성요소 노드 (★공유 노드 — needed_shared·중복 mint 금지)

> ★[formula-PRF_STK_FIXED] 스티커 규격/소재/수량별 단가·[component-COMP_STK_PRINT] 스티커 완제품가는
> **스티커 16상품 전체가 공유**하는 가격 인프라다(PRF_STK_FIXED→COMP_STK_PRINT 단일 배선). 병렬 집필된
> 형제 스티커 상품이 이미 선언 중이므로 이 파일은 **재선언하지 않고 참조만** 한다(L-3 중복 방지·HARD 규칙).
> [[sticker-halfcut-hologram]] priced_by → formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT.
> - **공식(PRF_STK_FIXED):** 완제품가 고정가 룩업(원자합산형 아님·pack §3.10). frm_nm='스티커 규격/소재/수량별
>   단가'·use_yn=Y·note '수량×(출력매수·소재) 표에서 단가 조회'. (live t_prc_price_formulas)
> - **구성요소(COMP_STK_PRINT):** prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd, mat_cd, min_qty]·
>   PRC_COMPONENT_TYPE.06. 완제품가(출력+가공 포함) 룩업 격자. 단가행은 노드로 안 펼침(D-22 접기). 값=엔진(D-18).
> - ★홀로그램 054는 **코팅 축 없음** → 격자 (siz_cd, mat_cd, min_qty) 3키. COMP_STK_PRINT×MAT_000163=216행
>   (본문 전사표). 260702 완제품 가격표 무변경 → retail 노드 dual 아님(연당가 급락은 원가축 [[matcost-054-hologram]]만 defect).
> → needed_shared_nodes 반환: formula-PRF_STK_FIXED·component-COMP_STK_PRINT(formula/sticker-formulas.md 승격 대상).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-054-yeondangga-repricing] 연당가 급락→완제품가 전파 여부 (돈-크리티컬) {unknown}
- type: gap
- anchor: none  # 사유: 소재 원가(연당가) 급락이 완제품 retail 시트가격에 전파돼야 하는지 정답 원천 부재(실무진·인간 승인 대기)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-D·§5 미확정 [GAP-ST(연당가)] 돈-크리티컬", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "260702 홀로그램 연당가 360,000→253,700(국4절 936→846) 급락이 완제품 시트가격(COMP_STK_PRINT) retail 격자로 전파돼야 하는가. retail 격자는 260702 무변경(원가↔완제품가 정합 미확인)"
- gap_fill_from: "실무진 답변 + 인간 승인 — 소재 원가 저장처 신설 여부·완제품가 재산정 여부(§4-D). 그 전까지 retail 재적재 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: matcost-054-hologram, note: "연당가 양면 노드가 이 미해결의 대상"}
- 본문: 연당가 재적재 워크리스트([[matcost-054-hologram]])는 확정이나, 그 급락이 완제품가로 전파돼야 하는지는 열린 질문. 지어내지 않고 GAP으로 등재.

### [gap-054-white-underbase-price] 화이트 underbase 가격 배선 여부 {unknown}
- type: gap
- anchor: none  # 사유: PROC_000008 화이트인쇄가 등록됐으나 가격공식(PRF_STK_FIXED)에 별도 배선 없음 — 완제품가 포함인지 무료인지 원천 불명
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000054,PROC_000008) mand=N + PRF_STK_FIXED 구성요소=COMP_STK_PRINT 단일(별색/화이트 구성요소 미배선)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "화이트 underbase(PROC_000008·mand=N)가 가격에 어떻게 반영되나 — PRF_STK_FIXED는 COMP_STK_PRINT 단일 배선이라 화이트가 완제품가에 포함인지(격자에 흡수) 별도 가산인지 무료인지 미상. 코팅 격자와 달리 화이트는 격자 컬럼도 없음"
- gap_fill_from: "실무진/가격표 확인 — 화이트 underbase가 완제품 시트가격에 포함되는지(pack §3.3 화이트=공정) 또는 별색 구성요소 배선 필요한지. §27 배선 서브트랙 재측정"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000008, note: "이 공정의 가격 반영이 미해결"}
- 본문: 화이트 underbase는 공정으로 등록됐으나 가격 배선이 불투명. 단정 없이 GAP으로 등재(063 화이트 MISSING과는 다른 축 — 054는 공정 실재).

### [gap-054-piece-count-storage] 반칼 조각수 상품레벨 저장처 부재 {unknown}
- type: gap
- anchor: none  # 사유: PROC_000054 prcs_dtl_opt에 조각수 input이 정의됐으나 상품레벨 저장처(prcs_dtl_opt.조각수 ref_param_json) 스키마 부재(OM-7)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.4 [GAP-ST-2]·§5 미확정 Q-ST-B·OM-7", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "반칼(PROC_000054)의 조각수(판당 개수+제한) input이 공정 정의엔 있으나 상품레벨 저장처가 스키마에 없음(prcs_dtl_opt.조각수·ref_param_json 미구현). 자유형은 모양+조각수가 생산·가격 파라미터인데 저장 불가"
- gap_fill_from: "실무진 + 개발팀 — prcs_dtl_opt 조각수 저장처(ref_param_json) 스키마 신설 선결(Q-ST-B·OM-7)"
- gap_owner: dev
- rel: {rel: references, target: process-PROC_000054, note: "이 공정의 조각수 param 저장처가 부재"}
- 본문: 반칼 조각수 파라미터의 상품레벨 저장처가 없다(스키마 GAP). 자유형 스티커 공통 미결(GAP-ST-2). 지어내지 않고 등재.
