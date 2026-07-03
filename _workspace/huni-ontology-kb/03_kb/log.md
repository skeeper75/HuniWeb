# log — Huni-Ontology-KB 연대기 (append-only)

> ingest/build/lint 이벤트만 시간순 append. 사실 원천 아님(역사 기록).

- 2026-07-03 · Phase 3 토대 구축(okb-knowledge-builder) · 디지털인쇄 파일럿 공유 축 노드 신규 집필.
  - axis: categories(8)·sizes(8)·materials(6)·processes(12)·print-options(4)·plate-sizes(1).
  - formula: digital-formulas(9)·digital-components(23) — 배선 스크립트 전사(gen_formula_nodes.py).
  - KB 레이어: _glossary term(7)·intent(3)·rule(7)·decision(7)·gap(6).
  - 전사 스크립트: `_meta/scripts/transcribe_snapshot.py`(사이즈·배선)·`gen_formula_nodes.py`(공식/구성요소).
  - 대표 8상품 선정(prd_cd live-snapshot 20260702_1119 실측): 016·032·033·027·046·024·041·043.
  - build_graph.py 구현 + 1회 빌드(무결성 6검사·멱등).

- 2026-07-03 · Phase 4 상품 노드(okb-knowledge-builder) · 코팅명함 product-032-coated-namecard 신규 집필.
  - product-032(PRD_TYPE.01 완제품·min100/max10000/incr100·QTY_UNIT.02) + 정의 노드: optgroup-032-print/paper/coating/corner(E11)·process-PROC_000014/015(코팅 소유)·DEC_namecard032_wiring_260630·GAP_032_coat_side.
  - 재사용(참조): category-CAT_000003/313·material-MAT_000081/082·printopt-POPT_000001/002·plate-OUTPUT_PAPER_TYPE_01·formula-PRF_NAMECARD_COAT→component-COMP_NAMECARD_COAT_S1/S2·size-SIZ_000008/133(033 정의)·process-PROC_000027/028(033 정의).
  - 전사 스크립트 신규: `_meta/scripts/transcribe_namecard032.py`(명함 사이즈 SIZ_000008/133/499·수량 스칼라). 기존 스크립트 무수정.
  - 빌드 hard=0·멱등 True. O4(index 미등재)는 공유 index.md 수정 금지 → index_entries 반환. 교차상품 공정(014/015/027/028)·명함 사이즈(008/133) 공유 axis 승격 후보로 반환.

- 2026-07-03 · Phase 4 통합·그래프 빌드(okb-knowledge-builder) · 상품 에이전트 5종 산출 통합 + 공유 축 승격 + 빌드.
  - ingest: product-016(13노드)·032·033·027(3파일 34노드)·046 등 대표 8상품 전부 등재. index.md에 `### 상품 노드(E1)` 섹션 신설 + 로드맵 8/8 집필완료·027 각주(2공식 PRF_DGP_E·PRF_DGP_E_FOIL)·라우팅 시작점 1/4 실링크.
  - 공유 축 승격(형제 open_questions·gap-016-process-nodes 해소): 2+상품 공유 마스터를 상품-local→공유 axis 이관. processes.md +6(PROC_000014/015/027/028/031/032)·sizes.md +2(SIZ_000008/133)·materials.md +1(MAT_000109). 상품 파일(033/032/046)의 중복 정의 제거·relations는 축 노드로 resolve. SIZ_000011/047/048(046 단독)은 미승격(승격 대기 노트). 노드 총계 불변(이동만).
  - gaps.md: 상품별 GAP 9종 링크 색인 추가(노드 재정의 아님·[[ ]] 미사용). GAP 15종(횡단6+상품9).
  - build_graph.py 재빌드: nodes=204·edges=425·hard=0·soft(연결대기/index)·멱등 2회 해시 동일(True). 8상품 전부 priced_by→공식→has_component 가격경로 연결(고아 공식 0). 리포트=`_meta/build-report-260703.md`.

- 2026-07-03 · 검증 라운드 1 결함 교정(okb-knowledge-builder·builder 역할) · V1 결함 7건 교정 후 재빌드.
  - lint 교정: V1-01A(016/027/046 source_file 접두사 print-kb/wiki→huni-dbmap·pack §1/§3 경로)·V1-03A(041 옵션그룹 앵커 016 방식 통일)·V1-02B(L-18 하드 구현+L-1/L-12/L-13/L-16/O3 가드)·V1-03B(references 엣지 dedup)·V1-04B(O4 하드→소프트)·V1-05B(리포트 비고)·blocklist.md 실체화(V1-01B·오염 게이트 실작동).
  - 재빌드: nodes=204·edges=**420**(중복 5 dedup)·hard=0·soft=30(L-12 8=산문 raw수치 정당신호)·멱등 True. blocklist 부재 시 하드 FAIL 확인. 스키마 v1.0.2(file-format·graph-build·ontology-schema). 상세=`_meta/fix-log-260703.md` R1.

- 2026-07-03 · 검증 라운드 2 결함 교정(okb-knowledge-builder·builder 역할) · V2 결함 7건(중복 id 병합) 교정 후 재빌드.
  - 지식 배선(builder): V2-01/V2-02(016 has_process 3→7·optgroup corner/vartext/varimg option_refs 배선·라이브 7공정 전수 정합)·V2-03(041 has_process 환각 PROC_000085 제거→라이브 부합 031/032 직접 배선·option_refs 동일)·gap-016-process-nodes 제거(대상 소멸)+GAP_016_material 신설(자재 커버리지 공백 정직 선언).
  - 스키마(architect·v1.0.3): file-format-spec V2-01(updated 필수→선택 강등·유령 L-7 라벨 제거)·graph-build-spec V2-02(§3.1 블록 파싱 서술을 영문키·상속없음 구현대로 정정).
  - 원천(curator): V2-05(pack §3.12 봉투 addon tmpl 010/011→038/039 라이브 부합·STALE 함정 등재). 인간종합 리포트 V2-06(엣지 425→430 동기·§8 해소표기 정정).
  - 재빌드: nodes=204·edges=**430**(has_process 34→39·option_refs 70→75·references 89→84)·hard=0·soft=30·멱등 True(해시 nodes=f116635ef5b55181·edges=da3e882a7272347d). 재실측 스크립트 `05_verification/scripts/verify_r2_wiring_260703.py` PASS(라이브↔그래프 전수 정합·085 환각 0). 상세=`_meta/fix-log-260703.md` R2.

- 2026-07-03 · Phase 4 상품 노드(okb-knowledge-builder) · 스탠다드엽서 product-018-standard-postcard 신규 집필.
  - product-018(PRD_000018·PRD_TYPE.01 완제품 단일·min15/max10000/incr15·QTY_UNIT.02·file_upload_yn=Y·editor_yn=N) + 전용 하위노드 9: qty-018·optgroup-018-print/paper/corner/postpress(E11)·GAP_018_material·gap-018-constraint·gap-018-addon-envelope·gap-018-postpress-param.
  - 형제 016(프리미엄엽서)과 동일 골격(공식 PRF_DGP_A·후가공 라우트·판형) — 사이즈 5행(016은 7)·자재 7종(016은 21)으로 축소. ★강점: 016은 options/option_items 공란이었으나 018은 옵션값 15+옵션아이템 15(ref_dim_cd 다형참조 전량) 라이브 충전 → option_refs ref_key1 한정자로 정확 배선(R11·fn_chk_opt_item_ref 정합).
  - 재사용(참조·직접 mint 없음): category-CAT_000307/001·size-SIZ_000001/002/003/004/007·printopt-POPT_000001/002·material-MAT_000074/081/082/091/092·process-PROC_000004(mand)/027/028/029/030/031/032·plate-OUTPUT_PAPER_TYPE_01·formula-PRF_DGP_A(공유 has_component 배선 재사용). 공유 GAP_pansu_73x98(SIZ_000001) 참조.
  - 가격 경로 연결 완료: product-018 --priced_by--> PRF_DGP_A --has_component--> 구성요소(고아 공식 아님).
  - 전사 스크립트 신규: `_meta/scripts/transcribe_product_018.py`(사이즈·자재·공정·인쇄옵션·판형·옵션그룹·options/option_items·제약0·addon0·공식바인딩). 기존 스크립트 무수정.
  - needed_shared_nodes 반환(직접 mint 금지): material-MAT_000080(아트지200g)·material-MAT_000090(스노우지200g) — 018 종이 7종 중 미민팅 2·live t_mat_materials 실재. GAP_018_material로 커버리지 공백 정직 선언.
  - 격리 검증(YAML 파싱·관계 target 실재·bad rel 0·missing target 0·priced_by formula 실재). 공유 index.md 수정 금지 → index_entries 반환. 전체 그래프 빌드는 통합 단계.

- 2026-07-03 · Phase 4 상품 노드(okb-knowledge-builder) · 3단접지카드 product-029-trifold-card 신규 집필(3파일).
  - product-029(PRD_000029·PRD_TYPE.01 완제품 단일·셋트 아님 라이브 0행·min8/max10000/incr8·QTY_UNIT.02·file_upload_yn=Y·editor_yn=N) + 전용 하위노드: process-PROC_000067/068(3단 가로/세로접지 ★신규 mint 2)·optgroup-OPT_000034~038(E11 5)·gap-029-addon-envelope. 전체 신규 노드 = 8(상품1+공정2+옵션그룹5)+GAP1.
  - 형제 027(2단접지카드)과 동형 — 접기 단수만 3단. 재사용(참조·직접 mint 없음): category-CAT_000021·size-SIZ_000523/124(027-nodes)/SIZ_000004(axis)·material 14전량(axis 6+027-nodes 108/109/123+023-nodes 113/114/115/116/125)·printopt-POPT_000002·process PROC_000004(mand)/031/032(axis)+037~044(027-nodes 박8)·plate-OUTPUT_PAPER_TYPE_01·formula-PRF_DGP_E(digital-formulas)+PRF_DGP_E_FOIL(027-nodes). ★027이 "?"규격 미기재였던 친환경/특수지를 029는 규격 316×467 기재된 정식 mat_cd 113~116/125로 참조(023-nodes 정의 재사용).
  - 가격 경로 연결 완료: product-029 --priced_by--> PRF_DGP_E(기본·apply 2026-06-01) / PRF_DGP_E_FOIL(박분기·apply 2026-07-01) --has_component--> 구성요소(고아 공식 아님·O5/O6·배선은 공식 노드 소관).
  - CPQ: 옵션그룹 5(인쇄 양면고정·종이14·후가공 가변다중·접지 3단가로/세로 필수·박칼라 8+없음)·option_refs 26(자재14+공정12)·L-18 부모차원 정합(전 타깃 uses_material/has_process/has_print_option 실재). 제약 라이브 0건(§31 소관·결함 아님).
  - 전사 스크립트 신규: `_meta/scripts/transcribe_product_029.py`(정체·사이즈3·자재14·공정13·공식바인딩·옵션그룹→참조차원·addon/print_option/constraint 카운트). 기존 스크립트 무수정. 수치 전부 transcribed-by 마커.
  - needed_shared_nodes 반환(직접 mint 금지·개념 보고): process-PROC_000067/068(3단접지)를 형제 027 PROC_000065/066(2단접지)와 함께 axis/processes 접지공정 축으로 승격 후보(현재는 형제 027 선례대로 상품 로컬 mint·open_question). 023-nodes/027-nodes에 흩어진 재사용 자재·박공정도 향후 축 승격 검토 대상.
  - 격리 검증(YAML·관계 target 실재·L-3 중복0·L-15 missing0·L-14 rel 9종 전부 화이트리스트·priced_by 2). 공유 index.md 수정 금지 → index_entries 반환. 전체 그래프 빌드는 통합 단계.

## 2026-07-03 (build) — 공유축 통합·index·그래프 재빌드 (확장 36상품) · okb-knowledge-builder
- 공유축 통합 mint 21종(브로큰링크 11 해소·단일소유권·중복0): axis/materials 4(MAT_000137/144/147/178)·formula/digital-formulas 5(PRF_PHOTOCARD_CLEAR·NAMECARD_SHAPE/MINISHAPE/FOIL/CLEAR)·formula/digital-components 12. 수치 전사=_meta/scripts/transcribe_shared_axis_260703.py(snap_20260702_1119). 앵커 L-17 전수 통과.
- 카테고리 B needed_shared_nodes(018 자재2·019 PET/화이트공정·박색 8자식 승격 등)는 rewire 미실행 → 상품별 GAP으로 정직 지연(honest GAP=위반 아님·orphan 양산 방지).
- index.md: 상태 8→36상품·E1 목록 36 계열분류·로드맵 표 36행·axis/formula/gaps 카운트 동기화. rule/gaps.md: 확장 상품 GAP 색인(017~051·잔존 GAP만·L-3 재정의 아님).
- 재빌드: 노드 466·엣지 1521·**하드 0**·소프트 120·멱등 True(nodes=11a4c1727614a548·edges=7e02a509a194e2e9). 36/36 가격경로 연결(035 공식배선·038 derived_from→gap O5). 리포트=_meta/build-report-expand-260703.md. 검증은 별도 레인(okb-adversarial-gate).

- 2026-07-03 · Phase 4 상품 노드(okb-knowledge-builder) · 반칼원형스티커 sticker-spec-circle 신규 집필(2파일·스티커 파일럿 첫 상품).
  - sticker-spec-circle(PRD_000058·PRD_TYPE.01 완제품 단일·셋트 0행·min4/incr4·QTY_UNIT.02·file_upload_yn=Y·editor_yn=Y·use_yn=Y) + companion sticker-spec-circle-nodes(축 마스터). ★파일명=태스크 지정(sticker-spec-circle.md)·L-1 basename==id 준수(id=sticker-spec-circle).
  - 신규 노드(companion 축 마스터): category-CAT_000002/037(스티커/규격스티커)·size-SIZ_000170/520(A5/A4반칼)·plate-058-SIZ_000521(330x470 OUTPUT_PAPER_TYPE.02 46계열)·material-MAT_000584/609/611/585/586(점착지 5·전부 MAT_TYPE.11)·process-PROC_000122(반칼커팅)·formula-PRF_STK_FIXED(완제품가 고정가)·component-COMP_STK_PRINT. 상품-local: qty-058·optgroup-058-cutting/print/paper(CPQ 3그룹 실재)·constraint-058-a5-cutting(RULE_001)·GAP 5.
  - 재사용(직접 mint 없음·참조): printopt-POPT_000001(공유 단면)·RULE_pansu_db_function/plate_paper_only/dosu_is_printopt/import_material_no_delete/price_value_boundary·DEC_wiring_round22_260702.
  - ★스티커 특성 3(팩 §0): ① 형상(원형 25~90mm)=CPQ 커팅 옵션값(OPT-000031·형상≠size·GAP-ST-3 gap-058-shape-storage) ② 가격=완제품가 고정가 룩업(PRF_STK_FIXED→COMP_STK_PRINT use_dims=[siz_cd,mat_cd,min_qty]·6,498행·058 5소재 격자 충전 실측·silent-0 아님) ③ 코팅 CONFLICT(무광/유광코팅=자재 585/586 vs 공정 PROC_000013·gap-058-coating-conflict·badge=candidate).
  - ★연당가 양면 노드 판정 = **058 FALSE(dual 불요)**: 260702 연당가/국4절 변경=투명/홀로/크라프트/투명후지 4소재 국한(전사 diff 실측)·058 소재(유포/미색/아트/코팅) 무변경·retail 완제품가 무변경 → false-defect 방지(팩 §4-D 정합). "연당가 저장처 부재" systemic은 gap-058-yeondangga로 정직 기록.
  - GAP 5(정직): coating-conflict(코팅 자재vs공정)·shape-storage(형상 저장 모델 불일치)·yeondangga(연당가 저장처 부재·058은 변경분 아님)·price-golden(절대값 골든 미검증)·constraint-stale-size(RULE_001이 삭제 SIZ_000426 참조).
  - 전사 스크립트 신규: `_meta/scripts/transcribe_sticker_058.py`(active/deleted 분리·CPQ 3그룹+옵션값16+참조6·제약 logic·격자 충전 소재별·260702 연당가 diff 대조). 기존 스크립트 무수정. 수치 전부 transcribed-by 마커.
  - needed_shared_nodes 반환(직접 mint 금지): 스티커 첫 등장 축(category 스티커/규격스티커·material 점착지 5·process 반칼커팅·formula PRF_STK_FIXED·component COMP_STK_PRINT·plate .02계열)을 스티커 그룹 통합 시 공유 축 승격 후보. 공유 index.md/axis/formula/rule 수정 금지 → index_entries 반환. 전체 그래프 빌드·index 등재는 통합 단계.

- 2026-07-03 · Phase 4 상품 노드(okb-knowledge-builder) · 반칼 자유형 홀로그램스티커 sticker-halfcut-hologram(PRD_000054) 신규 집필(2파일·스티커 파일럿).
  - 상품(PRD_000054·PRD_TYPE.01 완제품 단일·셋트 0행·min8/max10000/incr8·QTY_UNIT.02·file_upload_yn=Y·editor_yn=N·use_yn=Y) + 054 전용 하위노드: size-054-SIZ_000170(A5·마스터 del_yn=Y vs 링크활성 불일치 관찰)·size-054-SIZ_000520(A4 반칼 래퍼)·plate-054-SIZ_000521(46계열 330x470·국전 아님)·material-MAT_000163(홀로그램 점착지 MAT_TYPE.11·sole)·process-PROC_000054(반칼 Kiss Cut·sole)·qty-054·★matcost-054-hologram(연당가 양면 defect)·gap-054 3종.
  - ★가격 모델=완제품가 고정가 룩업(원자합산형 아님·pack §3.10). priced_by→PRF_STK_FIXED --has_component--> COMP_STK_PRINT(use_dims=[siz_cd,mat_cd,min_qty]). COMP_STK_PRINT×MAT_000163=216행(6 siz×36 수량구간·coat 공백=코팅축 없음). 주문 사이즈(SIZ_000170/520) 격자 실재→가격경로 성립. 값=evaluate_price(D-18).
  - ★연당가 양면 노드 matcost-054-hologram(defect): authority(260702 price-diff)=연당가 253,700(360,000→)·국4절 846(936→)·평량 50 vs current(라이브)=원가 미저장(t_mat_materials 가격컬럼 부재·COMP_PAPER MAT_000163 0행)·평량/명 일치. = 연당가 재적재 워크리스트(§4-D). ★완제품 retail 격자(COMP_STK_PRINT)는 260702 무변경→dual 아님(false-defect 방지).
  - ★공유 노드 재선언 회피(L-3 중복 방지·HARD): 병렬 집필 형제 스티커(052/055/057/060 등)가 이미 선언한 category-CAT_000002/CAT_000309·formula-PRF_STK_FIXED·component-COMP_STK_PRINT + product-020의 process-PROC_000008은 재선언 없이 참조만 → needed_shared_nodes 반환. 격리 검증: 내 파일 하드 위반 0(전체 빌드 47 하드=전부 형제 스티커 파일의 중복/미정의 로컬노드+통합 dedup 소관).
  - GAP 3: gap-054-yeondangga-repricing(연당가 급락→완제품가 전파 여부·돈-크리티컬·staff)·gap-054-white-underbase-price(화이트 underbase PROC_000008 가격배선 불투명·staff)·gap-054-piece-count-storage(반칼 조각수 저장처 부재·OM-7·dev).
  - 전사 스크립트 신규: `_meta/scripts/transcribe_product_054.py`(정체·카테고리·사이즈·자재+자식·★연당가 diff·인쇄옵션·공정·판형·미보유축·가격배선·완제품가 격자 요약). 캐시=cache/transcribed-054-260703.json. 기존 스크립트 무수정. 수치 전부 transcribed-by 마커(D-9). 코팅 CONFLICT(BATCH-3)는 무광/유광 스티커 국한·054(홀로그램·코팅 무)=무관 정직 표기.
  - index.md 수정 금지(HARD·공유 파일)→ index_entries 반환. 전체 그래프 빌드/통합·index 갱신은 통합 단계 소관.
- 2026-07-03 ingest product-064 소량자유형스티커(PRD_000064·스티커 파일럿) — 정본 sticker-smallqty-freeform.md(+companion). 전사=transcribe_product_064.py(멱등·md5 검증·손전사 0). 신설 노드=product1·size5(SIZ_000061~065·064 전용)·bundle_qty1(qty-064)·gap3(cpq-missing·coating-conflict·liandan-out-of-scope). 재사용(재-mint 없음·053 패턴)=category2·material5(153/084/242/155/156)·process-PROC_000054·plate-OUTPUT_PAPER_TYPE_02·printopt-POPT_000001·formula-PRF_STK_FIXED·component-COMP_STK_PRINT·size-SIZ_000043/036. 가격경로 연결(priced_by→PRF_STK_FIXED→has_component→COMP_STK_PRINT·35/35 조합 충전). ★use_yn=N 미출시·CPQ 0/0/0(BATCH-6 GAP)·코팅 material-only·연당가 dual 0(064 소재 clean·false-defect 방지)·MAT_000084 유형 드리프트 관찰(공유 노드). index.md 갱신.
- 2026-07-03 ingest sticker-pack 스티커팩(PRD_000065·스티커 파일럿) — 정본 sticker-pack.md(+companion sticker-pack-nodes.md). 전사=transcribe_sticker_065.py(멱등·손전사 0·transcribed-by 마커). 신설 노드=product1(sticker-pack)·category1(CAT_000312 스티커팩)·size1(SIZ_000068 75x110·판걸이16·065 전용)·formula1(PRF_STK_PACK 합가형)·component1(COMP_STK_PACK 54장1세트·use_dims=[siz_cd,min_qty]·소재무관)·bundle_qty1(qty-065)·gap5(set-composition·liandan-out-of-scope·material-type-label·pack-qty-band·cpq-option-layer). 재사용(재-mint 없음): category-CAT_000002·material-MAT_000084/242·printopt-POPT_000001·plate-OUTPUT_PAPER_TYPE_02. 가격경로 연결(priced_by→PRF_STK_PACK→has_component→COMP_STK_PACK·격자 1행 실측 54장 4,000 합가형). ★공정/옵션그룹/제약/셋트 0행=순수 인쇄물. ★연당가 dual 0(065 소재 비코팅/미색=260702 substantive 변경 아님·clean·false-defect 방지·052 선례). ★MAT_000084 mat_typ .13 vs note .11=gap-065-material-type-label(§12 basecode·단정 금지·공유 노드 미수정). ★팩=세트 미결(sets 0행·Q-ST-E)=gap-065-set-composition. 빌드 멱등 해시 nodes=d80d9a53635e7f2c edges=a7c283893854aa37·sticker-pack 관련 하드위반 0(끊긴링크0·중복id0·O5/O6 충족). index.md 갱신.
- 2026-07-03 ingest sticker-tattoo 타투스티커(PRD_000067·스티커 파일럿·전사=열전사 계열) — 정본 sticker-tattoo.md(+companion sticker-tattoo-nodes.md). 전사=transcribe_sticker_tattoo.py(멱등·손전사 0·transcribed-by 마커·cache/transcribed-sticker-tattoo-260703.json). 신설 노드=product1(sticker-tattoo·PRD_TYPE.01 완제품 단일·셋트0·min3/max1000/incr3·file_upload_yn=Y)·category1(CAT_000311 특수스티커)·size1(SIZ_000060 90x190·판걸이6·단일)·material1(MAT_000594 타투스티커 MAT_TYPE.11·상위 MAT_000167 재키잉 07-01)·qty1(qty-067)·formula1(PRF_STK_TATTOO)·component1(COMP_STK_TATTOO 완제품가 합가형 PRICE_TYPE.02·3장세트·use_dims=[siz_cd,mat_cd,min_qty])·optgroup1(067-paper 용지 mand=N→MAT_000594 clean 참조)·gap2(mattype-transfer-paper·liandan-out-of-scope). 재사용(재-mint 없음·L-3): category-CAT_000002·printopt-POPT_000001·plate-OUTPUT_PAPER_TYPE_03·RULE_pansu_db_function/dosu_is_printopt/price_value_boundary/import_material_no_delete. ★가격경로 연결(priced_by→PRF_STK_TATTOO→has_component→COMP_STK_TATTOO·활성 룩업 SIZ_000060×MAT_000594=333행 실측·구 167 격자 333행=레거시 옵션 미노출). ★공정/제약/추가/셋트 0행=순수 인쇄물(전사·잘라내지 않음·팩 §3.1). ★"3장세트"=가격 번들(min_qty 3장 단위)이지 t_prd_product_sets 셋트 아님(067 sets 0행·혼동 금지). ★연당가 dual 0(067 타투 소재=260702 substantive 변경 아님·price-diff에 '타투' 0행·052 선례 clean·false-defect 방지)=gap-067-liandan-out-of-scope 포인터. ★자재유형 .11 vs 팩 §3.5 .01 정당가능=gap-067-mattype-transfer-paper(firm authority 부재→양면 아님·GAP·현재값 .11 채택). 빌드 멱등(edges 해시 200415e309deaf0c 안정)·sticker-tattoo 관련 하드위반=size-SIZ_000060 sibling-dup 1건(형제 fancy 병렬정의·통합 dedup 소관·needed_shared_node)·끊긴링크0·O5/O6 충족. index.md는 통합 단계 소관(index_entries 반환).
