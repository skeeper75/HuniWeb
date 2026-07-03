# HANDOFF — Huni-Ontology-KB (§33) · 2026-07-03

## 다음 시작점

**디지털36+스티커16+실사28+셋트계열42 = 122상품 완성(GO)** — 다음 상품군은 **문구·굿즈파우치·악세사리**(확장계획 순번 5·Low·원천 결함 잔존 많음→양면 표기 비중 높을 것). `huni-ontology-kb-orchestrator`로 "<상품군> KB 확장".
루프는 `_meta/expansion-plan.md` §1~§4 그대로(팩[slug=product-NNN-kebab 강제]→Stage A 공유 스캐폴드 선민팅→Stage B 클러스터 팬아웃[자기 파일만·미민팅축은 needs_axis 반환]→Stage C1 축민팅+C2 엣지배선/index→3축 적대검증→질의 게이트).
★셋트 확장 실측 워크플로 재사용: `_meta/workflows/okb-set-build-stageB.js`(클러스터 팬아웃)·`okb-set-verify.js`(3축 검증) 복사·수정.

## 이번 세션(셋트 계열) 교훈 (반영됨)

- ★**스키마 `member_of` 없음** — 셋트 관계는 **has_member(부모→구성원·R13) 단방향**만. 구성원→부모는 `references [[부모]]` backlink + props. 구성원(자체 공식 0행)의 O5 충족 = **`derived_from → 부모 product`**(priced_by 위조 금지 — 095/096/098이 Phase 4에서 적발·교정). 고정가형 셋트 구성원 규약 = derived_from 부모.
- ★**product(프론트매터) 노드는 badge=defect 불가**(L-9는 블록노드 current/authority만 파싱). 양면은 **badge=verified + gap 노드 references**로(088 선례: 현재값 796,900 verified + gap-set-088-redesign-pending).
- ★**공유축 동시 mint 충돌 방지 = Stage A 선민팅 + Stage B는 needs_axis 반환(직접 mint 금지) + Stage C 일괄 민팅/배선.** 클러스터 병렬이 shared 파일(materials/processes/index) 동시편집하면 충돌 — 상품 파일만 쓰게 격리.
- ★**latest-wins 필수**: readiness-master(06-26)·live-snapshot(20260702_1119)은 셋트 면지 재설계(2026-07-03)·068~070 mint(06-30)·캘린더 공식 바인딩(07-01) 前이라 STALE. §23 post-verify 실호출이 정본.
- ★**캘린더 108~112 = 셋트 아님(단품·PRF_DGP_CAL_*)** — has_member 금지. design-calendar 고정가만 GAP.

## 미해결 / 블로커 (전부 비차단·KB는 정직 표기)

- **088-redesign-260702** 적재 승인 대기(표지9,000·싸바리·100부 1,800,000) → 승인 시 현재값 796,900 교체. `gap-set-088-redesign-pending`.
- **셋트 UI siz_cd 미전파**(094/097/100 화면0원·코드 C트랙 `_foundation/remediation/DEV-REQUEST-set-sim-sizcd-260702.md`) — 엔진골든은 정상·화면 실견적의 선행. `gap-set-simulate-sizcd`.
- **071 트윈링책자** 셋트 미성립(구성원 미mint·cover_mult ×2 엔진 C트랙 BLOCKED). `gap-071-set-notmembered`.
- **069/070 _FOIL 박분기** 정본화 인간 승인 대기·**S1/S2 내지인쇄 이중합산·068~070 코팅드롭** 코드 C트랙(전 책자 공통).
- 용도 추천형 커버리지 GAP(앨범/포토 전용 INTENT 미등재) — 후속 확장 시 intent 노드 보강.
- 이전 세션 잔여(비차단): 판수 GAP 73×98·016 자재 subset 정책·PROC_000085 축 지위.

## 현재 상태 (2026-07-03 종료 시점)

- **122상품 완성 GO** = 디지털36 + 스티커16 + 실사28 + 셋트계열42(부모10: 068/069/070/072/077/082/088/094/097/100 + 구성원27 + 캘린더5 108~112). 그래프 노드 1141·엣지 3534·하드 0·소프트 524·멱등(재빌드 해시 동일 37aa87c6…). product 파일 180.
- 셋트 계열 O1~O7 전 게이트 GO(`06_query_gate/gate-verdict-set-series-260703.md`·14시나리오·라이브 EXACT 오차0 9건·거절형 4/4 정직·양면 정직).
- Phase 4 적대검증 1라운드 수렴(High 0·Medium 4·Low 2 전부 교정·I-1 고아 6→0).
- 셋트 공유 스캐폴드: `formula/set-formulas.md`(공식17)·`set-components.md`(구성요소15)·축 58 신규·GAP 9.

## 이번 세션 결정 (relitigate 금지)

1. 셋트 계열 확장 = 검증된 4단 루프에 **Stage A(공유 스캐폴드 선민팅)·Stage C(축민팅+엣지배선 분리)** 추가(공유축 동시 mint 충돌 방지). 워크플로 스크립트 `_meta/workflows/okb-set-*.js` 정본.
2. 셋트 가격 = evaluate_set_price(구성원 evaluate_price 합산+부모공식+할인). 구성원 자체공식 0행 = derived_from 부모(O5 충족·priced_by 위조 금지).
3. 캘린더 = 단품 완제품(셋트 아님)·has_member 금지. 별도 캘린더 전용 팩은 미작성(§0.1 판정으로 단품 5개 흡수).
4. 088·094/097/100·069/070 = 양면 정직 표기(현재값 verified + pending/코드결함 gap). 라이브 미결과 얽힘을 현재값/GAP로 정직 분리.

## 건드리지 말 것

- `03_kb/` 정본 노드(product 122 + 축·공식·용어·규칙·GAP) + `04_graph/build_graph.py`(하드0·멱등·L-20) — 수정은 정본 파일 경유 후 재빌드.
- `01_curation/pack-set-series.md`(셋트 정답소스·STALE함정·양면표기)·`02_ontology/` 스키마 v1.0.1(승인본).
- 검증/게이트 판정 문서(`05_verification/defect-setseries-*`·`06_query_gate/gate-verdict-set-series-260703.md`) — 재게이트 시 append, 덮어쓰기 금지.
- 양면/GAP 노드(088 pending·071·design-calendar·siz_cd·_FOIL·s1s2) = 라이브 재적재/승인/C트랙 완료 시 현재값=정답 승격 입력 — 삭제 금지.
