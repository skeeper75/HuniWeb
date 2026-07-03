# HANDOFF — Huni-Ontology-KB (§33) · 2026-07-04

## 다음 시작점

**★전 상품군(순번1~6) 완주 — 275상품 O1~O7 GO.** 디지털36+스티커16+실사28+셋트42+문구셋트25+굿즈파우치봉투103+**아크릴25**. 상품군 확장은 종료됐다. 다음 세션의 시작점은 **KB 인프라 후속**(아래 미해결 큐) 중 하나이거나, 라이브 미결(088·siz_cd·굿즈/아크릴 TBD 등)이 승인/적재 완료됐을 때의 **양면/GAP 노드 승격**이다. 신규 상품군 요청이 없으면 새 확장 없음.

**고정 루프(참고·재사용)**(`_meta/expansion-plan.md` §1): 팩[slug=product-NNN-kebab 강제] → Stage A 공유 스캐폴드 선민팅 → Stage B 클러스터 팬아웃[자기 파일만·미민팅축은 needs_axis 반환] → Stage C 축민팅+엣지배선/index+재빌드 → 3축 적대검증(→교정 루프) → 질의 게이트.
★실측 워크플로 정본(복사·수정): `_meta/workflows/okb-{set,stn,goods,acryl}-build-stageB.js`(구축)·`okb-{set,stn,goods,acryl}-verify.js`(3축 검증). 아크릴 워크플로=`okb-acryl-build.js`(Stage A~C 통합)·`okb-acryl-verify.js`.

## 핵심 교훈 (누적·재발 방지·다음 확장/유지보수에 그대로 적용)

**스키마·구조**
- **스키마 `member_of` 없음** — 셋트 관계 = `has_member`(부모→구성원·R13) 단방향만. 구성원→부모 = `references [[부모]]` + props(엣지 아님).
- **product(프론트매터) 노드 badge=defect 불가**(L-9는 블록노드 current/authority만 파싱). 양면 = **badge=verified/candidate + gap 노드 references**. 미출시(use_yn=N)는 **badge=candidate 통일**(활성 견적가능이어도).
- **구성원 slug = 자기 prd_cd**[HARD]. 단품 상품군(굿즈/아크릴)은 has_member 없음.

**가격 표현(O5)·아키타입**
- **O5(끊긴 가격사슬) = `priced_by`/`derived_from` 또는 가격류 gap 선언**(build_graph.py·graph-build-spec v1.0.5). 가격 gap id 힌트 `PRICE_GAP_HINTS`. **비가격 gap**(sewing/오염/empty-shell/UI)로는 O5 우회 불가.
- **가격 아키타입은 상품군마다 다름 — 라이브로 판정(추정 금지)**: 디지털=원자합산 / 스티커=고정룩업+band / 실사·**아크릴=면적매트릭스**([가로×세로] off-grid ceiling·공유 COMP) / 셋트=evaluate_set_price / 굿즈=고정가룩업(직접 unit_price·공식없음→gap-goods-fixed-lookup).
- **★아크릴 = 면적매트릭스(silsa 동형)·굿즈 고정가룩업 아님(T-7)**: COMP_ACRYL_CLEAR3T([mat_cd,siz_width,siz_height,min_qty]·277셀) 13상품 공유. t_prd_product_prices 0행 → gap-goods-fixed-lookup 슬러그 금지. "고정가형"(M3/M4)도 공식기반([siz_cd,min_qty]).
- **고정가룩업**(굿즈)=직접 t_prd_product_prices unit_price·공식없음→gap-goods-fixed-lookup-no-formula(값 props)·verified. NEITHER-gap=prices AND formulas 0행·candidate.
- **sparse grid 정직**: 단가행 1~2셀=등록 사이즈가 적을 뿐·등록 사이즈는 PRICE≠0.

**데이터 정직성·드리프트**
- ★**H-1 드리프트 2회 실증(굿즈 33상품·아크릴 226) — 가격 확장/검증/교정 단계 재-SELECT 필수**: 병행 세션(dbmap §7)이 굿즈·아크릴 가격을 라이브 적재 중(07-03/04). 큐레이터/구축가 초기 SELECT 이후 적재분이 KB를 "가격 부재/견적불가" 오표기시킴(226 false-gap이 Phase4에서 적발). **live-snapshot·초기 캐시 모두 노후 가능 → 게이트/교정 단계에서 라이브 재-SELECT로 확정.**
- **latest-wins**: readiness-master·구 스냅샷 상태값 STALE 주의.
- **색상값≠substrate**(uses_material 금지·오염). 아크릴 substrate=투명 두께(1.5/3/8mm)·부속=has_addon. 비종이=판형 비가격축(has_plate_size 미배선·fn_calc_pansu 금지).
- **공유축 동시 mint 충돌 방지** = Stage A 선민팅 + Stage B는 needs_axis 반환 + Stage C 일괄 민팅/배선. L-3 사이즈 중복은 Stage C 단일소유(L-20) 통합.

## 미해결 / 블로커 (전부 비차단·KB는 정직 GAP/양면 표기)

**KB 인프라 후속(architect/foundation)**
- **live-snapshot 재캡처**(20260702→최신): 병행 세션 굿즈·아크릴 적재 반영·240/226 등 `anchor:none` → t_prc_* 앵커 승격 대기.
- **O5 `PRICE_GAP_HINTS` 화이트리스트 → 필드 마커(`price_slot`) 강화**(architect 판단·현재 영향 0).
- 용도 추천형 커버리지 GAP(앨범/포토 전용 INTENT 미등재) — 확장 시 intent 노드 보강.

**라이브 미결(승인/C트랙·KB는 gap/양면으로 보존)**
- 088-redesign 적재 승인 대기(`gap-set-088-redesign-pending`)·셋트 UI siz_cd 미전파(094/097/100·`gap-set-simulate-sizcd`)·071 트윈링(`gap-071-set-notmembered`)·069/070 _FOIL 정본화·068~070 코팅드롭.
- **아크릴 TBD 4상품(165/168/169/170)** 단가행 부재(실무진 대기)·163 placeholder 10,000·226 출시 승인(미출시·견적가능)·아크릴 글리터 mat_typ.09 오타이핑(§7)·공정 MISSING·옵션 items 0행(§7/§31).
- 문구 sparse grid 충전·무지내지 min/max·177 재분류·굿즈 NEITHER-gap 가격 적재(dbmap/실무진).

## 현재 상태 (2026-07-04 종료 시점)

- **275상품 완성 GO — 전 상품군(순번1~6) 완주** = 디지털36 + 스티커16 + 실사28 + 셋트42 + 문구셋트25 + 굿즈파우치봉투103 + 아크릴25. 그래프 노드 1485·하드 0·소프트 720·멱등(재빌드 해시 f4be9775…). product 파일 333(main·-nodes 별도).
- 전 상품군 O1~O7 게이트 GO — 아크릴 판정: `06_query_gate/gate-verdict-acryl-260704.md`(15시나리오·가격오차0·거절5/5·미출시7 정직).
- 아크릴 결함 보드: `05_verification/defect-acryl-{prov,integrity,pricepath}-260704.md`(High0·Medium1[226 false-gap·교정완료]·Low3[격리]).
- 아크릴 가격 캐시: `01_curation/_cache/acryl-*-260704.csv` + `acryl-226-reselect-260704.csv`(H-1 정정 정본).

## 이번 세션 결정 (relitigate 금지)

1. **아크릴 = 면적매트릭스 아키타입(silsa 동형)** — 굿즈 고정가룩업(gap-goods-fixed-lookup)과 다른 정본 패턴(T-7·t_prd_product_prices 0행). "고정가형"도 공식기반.
2. **H-1 드리프트 대응 = 게이트/교정 단계 라이브 재-SELECT** — 병행 세션 적재로 226 false-gap 발생→재-SELECT로 정정. 스냅샷/초기 캐시 불신.
3. 미출시(use_yn=N) badge=candidate 통일·팬텀 가격 금지·추천 제외. TBD 단가행0=gap-acryl-tbd(O5 priced_by 충족). 171 del/167 결번 미생성.
4. 상품군 확장 6/6 완료 — 새 확장 없음(신규 상품군 요청 시에만). 후속=KB 인프라·양면 승격.

## 건드리지 말 것

- `03_kb/` 정본 노드(product 275 + 축·공식·용어·규칙·GAP) — 수정은 정본 파일 경유 후 재빌드.
- `04_graph/build_graph.py`(하드0·멱등·L-20·O5 v1.0.5) — O5/스키마 로직 변경은 graph-build-spec 변경이력 기록 필수.
- `01_curation/pack-*.md`(정답소스·STALE 함정) + `_cache/*.csv`(라이브 전사 정본·acryl-226-reselect 포함)·`02_ontology/` 스키마 v1.0.1(승인본).
- 검증/게이트 판정 문서(`05_verification/defect-*`·`06_query_gate/gate-verdict-*`) — 재게이트 시 append, 덮어쓰기 금지.
- 양면/GAP 노드(088 pending·071·siz_cd·_FOIL·문구 sparse/177·굿즈 fixed-lookup/neither·연당가·아크릴 TBD4/mat_typ) = 라이브 재적재/승인/C트랙 완료 시 승격 입력 — 삭제 금지.
