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
