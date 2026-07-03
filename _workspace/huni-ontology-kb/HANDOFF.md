# HANDOFF — Huni-Ontology-KB (§33) · 2026-07-04

## 다음 시작점

**디지털36+스티커16+실사28+셋트42+문구셋트25+굿즈파우치봉투103 = 250상품 완성(GO)** — 문구/굿즈 그룹(순번 5) 전체 완료. 다음은 **아크릴 146~171(26·순번 6)** — 별도 `pack-acrylic` 필요(면적매트릭스·전용 recipe·226 쉐이커코롯토 등 TBD 포함·226은 이미 gap-226-acryl-tbd로 정직 표기됨). `huni-ontology-kb-orchestrator`로 "아크릴 KB 확장".

**고정 루프**(`_meta/expansion-plan.md` §1~§4): 팩[slug=product-NNN-kebab 강제] → Stage A 공유 스캐폴드 선민팅 → Stage B 클러스터 팬아웃[자기 파일만·미민팅축은 needs_axis 반환] → Stage C1 축민팅 + C2 엣지배선/index → 3축 적대검증(→교정 루프) → 질의 게이트.
★실측 워크플로 재사용(복사·수정): `_meta/workflows/okb-{set,stn,goods}-build-stageB.js`(클러스터 팬아웃)·`okb-{set,stn,goods}-verify.js`(3축 검증).

## 핵심 교훈 (누적·재발 방지·다음 확장에 그대로 적용)

**스키마·구조**
- **스키마 `member_of` 없음** — 셋트 관계 = `has_member`(부모→구성원·R13) 단방향만. 구성원→부모 = `references [[부모]]` + props(엣지 아님).
- **product(프론트매터) 노드 badge=defect 불가**(L-9는 블록노드 current/authority만 파싱). 양면 = **badge=verified/candidate + gap 노드 references**(088 선례).
- **구성원 slug = 자기 prd_cd**[HARD]: 구성원 id/파일명은 자기 prd_cd(product-305-… not 부모 product-179-…). 부모 prd_cd 오사용=slug 위반(Phase4 개명).

**가격 표현(O5)**
- **O5(끊긴 가격사슬) = `priced_by`/`derived_from` 또는 가격류 gap 선언**(build_graph.py·graph-build-spec v1.0.5·2026-07-04). 가격 gap id 힌트 `PRICE_GAP_HINTS`=neither/fixed-lookup/price-unloaded/sparse-grid/redesign-pending/fixedprice/price-pending/tbd. **비가격 gap**(sewing/오염/empty-shell/UI)로는 O5 우회 불가.
- **고정가룩업**(직접 t_prd_product_prices unit_price·공식 없음) → `references gap-goods-fixed-lookup-no-formula`(가격 gap) + **props에 값 기재**(그래프-only 질의)·verified. **NEITHER-gap**(prices AND formulas 0행·진짜 부재) → gap-goods-neither·candidate.
- 구성원 자체공식 0행 = `derived_from → 부모`(priced_by 위조 금지).
- **sparse grid 정직**: 단가행 1~2셀=등록 사이즈가 적을 뿐·등록 사이즈는 PRICE≠0(off-grid만 견적0). "전 사이즈 견적0" 과대 기술 금지.

**데이터 정직성**
- ★**live-snapshot(20260702_1119) 노후 — 가격 확장 시 신규 라이브 SELECT 필수**: 병행 세션(dbmap)이 굿즈/악세사리 가격을 라이브 적재 중(07-03/04). 스냅샷 기반 빌드가 33상품을 "가격 부재" 오표기(H-1). **스냅샷 재캡처가 후속 필요**.
- **latest-wins**: readiness-master·구 스냅샷 상태값 STALE 주의(§23 post-verify 실호출·신규 라이브가 정본).
- **색상값(화이트/블랙 MAT_TYPE.08)≠substrate**(uses_material 금지·오염). 비종이(굿즈/파우치/봉투) 판형없음·봉투 001/002/005 라이브=기성(.03).
- **공유축 동시 mint 충돌 방지** = Stage A 선민팅 + Stage B는 needs_axis 반환 + Stage C 일괄 민팅/배선(클러스터는 상품 파일만).
- 캘린더 108~112 = 단품(셋트 아님·has_member 금지·PRF_DGP_CAL_*).

## 미해결 / 블로커 (전부 비차단·KB는 정직 GAP/양면 표기)

**KB 인프라 후속(architect/foundation)**
- **live-snapshot 재캡처**(20260702→최신): 병행 세션 굿즈 적재 반영·240 신규 공식 등 `anchor:none` → t_prc_* 앵커 승격 대기.
- **O5 `PRICE_GAP_HINTS` 화이트리스트 → 필드 마커(`price_slot`) 강화**(더 견고·현재 영향 0·architect 판단).
- 용도 추천형 커버리지 GAP(앨범/포토 전용 INTENT 미등재) — 확장 시 intent 노드 보강.

**라이브 미결(승인/C트랙·KB는 gap/양면으로 보존)**
- 088-redesign(표지9,000·싸바리·100부 1,800,000) 적재 승인 대기(`gap-set-088-redesign-pending`).
- 셋트 UI siz_cd 미전파(094/097/100 화면0원·코드 C트랙 DEV-REQUEST-set-sim-sizcd·`gap-set-simulate-sizcd`).
- 071 트윈링책자 셋트 미성립(구성원 미mint·cover_mult ×2 C트랙·`gap-071-set-notmembered`).
- 069/070 _FOIL 정본화 승인 대기·S1/S2 이중합산·068~070 코팅드롭(전 책자 공통 C트랙).
- 문구 sparse grid 충전·무지내지 min/max·177 재분류·굿즈 NEITHER-gap 가격 적재(dbmap/실무진).
- 이전 세션 잔여: 판수 GAP 73×98·016 자재 subset 정책·PROC_000085 축 지위.

## 현재 상태 (2026-07-04 종료 시점)

- **250상품 완성 GO** = 디지털36 + 스티커16 + 실사28 + 셋트42 + 문구셋트25 + 굿즈파우치봉투103. 그래프 노드 1361·하드 0·소프트 640·멱등(재빌드 해시 동일 8e5cc7c6…). product 파일 308.
- 전 상품군 O1~O7 게이트 GO — 게이트 판정: `06_query_gate/gate-verdict-{set-series,stnset,goods}-260703~04.md`. 굿즈: 14시나리오·가격오차0(고정가룩업 59/59 라이브 verbatim)·NEITHER-gap 정직·거절 4/4.
- 커밋: 셋트=`221d5ae`·문구셋트=`a1ea993`·굿즈=`50ecd6b`(+병행 세션 dbmap 커밋들).

## 이번 세션 결정 (relitigate 금지)

1. 확장 루프에 **Stage A(공유 스캐폴드 선민팅)·Stage C1/C2(축민팅·엣지배선 분리)** 정착(공유축 동시 mint 충돌 방지). 워크플로 정본=`_meta/workflows/okb-*.js`.
2. **O5 코드 spec §151 정렬 + 가격 gap 화이트리스트**(build_graph.py·graph-build-spec v1.0.5). 가격 표현의 정본 계약.
3. 셋트 가격=evaluate_set_price·구성원=derived_from 부모. 캘린더=단품. 문구 셋트=고정가형 sparse.
4. 굿즈=고정가룩업(gap-goods-fixed-lookup·값 props) / NEITHER-gap(진짜 부재) 이분·미출시 정직·색상값≠substrate.
5. 라이브 미결(088·siz_cd·071·_FOIL·굿즈 미적재)은 현재값/GAP로 정직 분리(팬텀 금지).

## 건드리지 말 것

- `03_kb/` 정본 노드(product 250 + 축·공식·용어·규칙·GAP) — 수정은 정본 파일 경유 후 재빌드.
- `04_graph/build_graph.py`(하드0·멱등·L-20·O5 v1.0.5) — O5/스키마 로직 변경은 graph-build-spec 변경이력 기록 필수.
- `01_curation/pack-*.md`(정답소스·STALE함정)·`02_ontology/` 스키마 v1.0.1(승인본).
- 검증/게이트 판정 문서(`05_verification/defect-*`·`06_query_gate/gate-verdict-*`) — 재게이트 시 append, 덮어쓰기 금지.
- 양면/GAP 노드(088 pending·071·siz_cd·_FOIL·문구 sparse/177·굿즈 fixed-lookup/neither·연당가) = 라이브 재적재/승인/C트랙 완료 시 승격 입력 — 삭제 금지.
