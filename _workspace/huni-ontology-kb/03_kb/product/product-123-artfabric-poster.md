---
id: product-123-artfabric-poster
type: product
anchor: t_prd_products/PRD_000123
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000123 (del_yn=N·use_yn=Y 출시·nonspec_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.1 정체·§3.10 면적매트릭스 13(B06 아트패브릭123)·§3.8 비종이류 판형없음·§3.5 자재유형", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.1/§1.2 B06 아트패브릭포스터 PRD_000123 (룩업 매트릭스 모델만 승계·좌표회귀 DROP·T-4)", captured_at: "2026-07-03", badge: verified, src_id: SR-map-areamatrix}
  - {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "실사=포스터/사인 면적매트릭스 [가로×세로]·종이류만 판형·off-grid ceiling", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(main_cat_yn=Y·lvl1·disp 8)"}
  - {rel: in_category, target: category-CAT_000314, note: "아트포스터(lvl2·상위 CAT_000004·N)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 297x420(이산 규격·면적매트릭스 아님)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 420x594"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1 594x841(사이즈 마스터 del_yn=Y·링크 활성 — 양면 관찰)"}
  - {rel: uses_material, target: material-MAT_000181, note: "그래픽천·본체 단일 USAGE.07·mat_typ 교정중(.08→.05 dual)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ARTFABRIC, note: "면적매트릭스형(가로×세로 셀단가·코팅포함 통가격)"}
  - {rel: has_qty_rule, target: qty-123, note: "상품레벨 min1/max1000/incr1 — 면적매트릭스는 셀=통가격(수량축 없음)"}
props:
  prd_typ_cd: PRD_TYPE.01
  nonspec_yn: Y
  file_upload_yn: Y
  editor_yn: N
  use_yn: Y
  del_yn: N
  archetype: 면적매트릭스형
  use_dims_ref: "companion 전사표(COMP use_dims=[siz_width, siz_height, min_qty])"
  구분: "실사 포스터(카테고리 004·대형 잉크젯 출력물·소재=그래픽천 패브릭)"
  size_range_note: "비규격 연속범위(가로·세로 raw는 companion 전사표 권위·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(실사 포스터)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아트패브릭포스터 구성·가격 경로)", "조건 탐색(패브릭 실사 포스터·면적 가격)"]
tags: ["#실사", "#포스터", "#면적매트릭스", "#패브릭", "#비종이류"]
updated: 2026-07-03
---

# product-123 아트패브릭포스터 (PRD_000123)

아트패브릭포스터는 **실사(대형 잉크젯 출력물) 완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다.
그래픽천(패브릭) 소재에 실사 대형 잉크젯으로 풀컬러 출력하는 포스터(카테고리 = 포스터
`CAT_000004`·아트포스터 `CAT_000314`). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용).
비규격 연속범위(가로 200~1200mm·세로 200~3000mm·200mm 증분) + 이산 규격 A3/A2/A1을 함께 제공한다.
가로·세로·수량 raw 값은 [[product-123-artfabric-poster-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**실사 파일럿 4대 특성 정합**(pack §0): ① 소재가 정체를 가름(그래픽천 패브릭) ② 가격=면적매트릭스형
(고정가형 아님) ③ **비종이류라 판형(plate_size) 없음** ④ 부속 없음(단품). 종이류(디지털/스티커)의
판형·판걸이수 로직을 이 상품에 이식하면 오모델([[rule/rules#RULE_plate_paper_only]]·pack §3.8·T-7).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 아트패브릭포스터는 `t_prd_product_sets`
  부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님(실사 제조 상품).
- 카테고리 = **포스터(CAT_000004·main)** + **아트포스터(CAT_000314·leaf·2026-06-19 신규 노드)**.
  round-13 "실사 28상품 전부 CAT_000298 고아"(SL-DEF-001)는 **STALE**(T-1) — CAT_000298은
  `del_yn=Y` 논리삭제(06-18)·123은 정상 노드에 재연결됨(pack §1.1·§4). 단 leaf(314)가 신규
  노드라 귀속 정밀도는 "현재값" 라벨([[product-123-artfabric-poster-nodes#category-CAT_000314]]).

## 차원
- **사이즈:** 이산 규격 3행(A3 297×420·A2 420×594·A1 594×841) + **비규격 연속범위**(가로
  200~1200·세로 200~3000·200mm 증분). ★비규격 범위는 **입력 UX 한계일 뿐 가격격자가 아니다**
  — 유효 가격 권위 = 포스터사인 면적매트릭스 셀(pack §3.2·[SL-DIM-001] 승계). off-grid =
  가로·세로 각 **한 단계 큰 규격 ceiling**(앱 계산·pack §3.2·off-grid ceiling).
  치수 전사 = [[product-123-artfabric-poster-nodes#사이즈]]. ★A1(SIZ_000293)은 사이즈 **마스터
  del_yn=Y**(06-17)이나 상품-사이즈 링크는 활성(del_yn=N) — 데이터 관찰([[gap-123-a1-size-deleted]]).
- **도수:** ★실사는 **도수(칼라/흑백) 컬럼 자체가 없다**(대형 잉크젯 풀컬러·정당·pack §3.3).
  `t_prd_product_print_options` = 123 행 **0개**(도수를 색상코드/좌표로 오모델 금지·T-4). 화이트
  underbase(별색 공정)는 투명/반사 소재 전용 — 그래픽천(불투명 패브릭)은 해당 없음.
- **수량규칙:** 상품레벨 min 1 / max 1000 / incr 1(단위 QTY_UNIT.01). ★면적매트릭스는
  **셀=완제품 통가격**이라 수량 단가구간 축이 없다(`t_prd_product_bundle_qtys` 0행·pack §3.4).
  즉 수량은 "몇 장 살지"의 곱셈 승수일 뿐, 가격격자 차원이 아니다. 하위 [[qty-123]].

## 자재·공정 (★비종이류 특성)
- **자재:** 그래픽천 `MAT_000181` 1종(본체 단일·낱장 완제품·표지/내지 없음·usage USAGE.07·pack §3.5).
  ★**자재유형 교정중(양면 노드):** 현재 `mat_typ_cd=MAT_TYPE.08`(실사소재) — 정답 목표 **.05
  특수소재**(라이브 note "정정 06-14 →원단(.05)" + 형제 패브릭 린넨184/캔버스185/타이벡187/188이
  이미 .05로 이동·pack §1.1·§3.5). ★round-13 목표 라벨 "**원단**"은 MAT_TYPE 코드 개편으로 STALE
  (T-2·현재 .05=특수소재·.06=도장부자재). 최종 목표유형 확정은 GAP([[gap-123-graphicfabric-mattype]]).
  상세 = [[product-123-artfabric-poster-nodes#material-MAT_000181]]. ★IMPORT 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** `t_prd_product_processes` = 123 행 **0개**. 면적매트릭스형은 **소재+출력+코팅이 셀
  통가격에 포함**된 완제품가라 별도 공정행이 없다(정당·pack §3.6·§3.10 코팅포함 통가격). 패브릭의
  봉제(PROC_000080) 등 후가공은 마감옵션 상품(린넨124 등)에만 발현 — 아트패브릭포스터는 순수 출력물.
- **판형:** ★**없음(비종이류·[HARD])**. 실사는 대형 롤 출력이라 절수 기반 전지 규격이 무의미
  (`output_paper_typ_cd` 공란). `t_prd_product_plate_sizes` 3행은 **전부 del_yn=Y**(06-30 논리삭제·
  파일사양 JPG 잔재)이므로 `has_plate_size` 엣지를 만들지 않는다. 종이류의 판형(fn_best_plate)·
  판걸이수(fn_calc_pansu·t_siz_pansu) 로직 이식 금지([[rule/rules#RULE_plate_paper_only]]·T-7).
  전사 증거 = [[product-123-artfabric-poster-nodes#판형]].

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-123 --priced_by--> formula-PRF_POSTER_ARTFABRIC --has_component-->
  component-COMP_POSTER_ARTPRINT_PHOTO`. **고아 공식 아님**(has_component 1개)·**끊긴 가격 사슬
  아님**(priced_by 1개). 배선·구성요소 노드 = [[product-123-artfabric-poster-nodes#가격]].
- **면적매트릭스형** = 포스터사인 [가로(siz_width)×세로(siz_height)] 셀단가(코팅포함 통가격).
  구성요소 `COMP_POSTER_ARTPRINT_PHOTO`의 `use_dims=["siz_width","siz_height","min_qty"]`·단가행
  **52셀**·골든 note "600×1800=21,600원" <!-- lint-allow: L-12 src=SR-5-livesnap comp note 골든 --> (값 계산=evaluate_price 권위·KB는 차원 선언까지·[SL-PRC-001]
  승계). 단가행 셀 값은 노드로 펼치지 않는다(D-22 접기).
- ★**round-2 D-WIRE 재판정(pack §3.11):** round-2는 "28상품을 단일 comp에 바인딩·매트릭스 2~6%만
  적재"를 결함(SL-PRC/D-WIRE)으로 봤으나, 라이브 20260702는 `COMP_POSTER_ARTPRINT_PHOTO`가 **의도된
  [동형결합]**(가격표 동일 4소재=아트프린트118·접착방수121·아트패브릭123·방수120 통합·52셀 적재·
  upd 06-18)임을 보인다. 즉 123의 가격 사슬은 sparse 2~6% 상태가 **아니라 완전 배선**이다 — round-2
  결함 서술을 "현재 결함"으로 인용하면 T-5/T-6 오염. 레거시 `COMP_POSTER_ARTFABRIC_GRAPHIC`은 은퇴
  (`use_yn=N`)·mapping.md §1.2 B06가 가리키던 레거시 comp은 라이브 동형결합으로 대체됨(관찰 기록).
- ★가격 권위 경계: 실사 시트 inline price(R/S/V 컬럼)는 가격 권위 아님 — 권위=인쇄상품 가격표
  "포스터사인" 시트([[rule/rules#RULE_price_value_boundary]]·pack §3.10 [HARD]).

## 옵션·제약·추가상품 (라이브 실측 — 전부 미등록)
- **옵션그룹/아이템:** `t_prd_product_option_groups`·`t_prd_product_option_items` = 123 행 **없음**.
  아트패브릭포스터는 순수 출력물이라 손님 선택 옵션(마감·부속)이 없다(정당). CPQ 옵션 일괄 적재는
  27 실사 배치 대기(pack §3.9 GAP-SL-6·123은 옵션 불요 상품이라 결함 아님).
- **제약:** `t_prd_product_constraints` = 123 행 **없음**. round-13 "실사 constraints 전부 0행"은
  이후 7상품(118/120/121/122/124/125/139) 1행씩 신규 발현했으나(pack §1.1·T-3) **123은 그 목록에
  미포함** — 제약 불요 상품(0행=정당).
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 123 행 **없음**. 부속붙는 8상품
  (족자/배너/액자류)에 123 미포함(단품·SOT 완제품 단일 정합).

## 승계·freshness 메모
- 정체·소재·면적/고정 분기 = pack §3.1/§3.10 FRESH 승계(17_correctness/silsa + mapping.md).
- 결함 상태값은 pack §1.1·§4로 재조준: 카테고리 고아(SL-DEF-001)·레더/패브릭 .08(SL-DEF-002)는
  6~7월 라이브 교정으로 변화 — round-13 위키 🔴을 그대로 옮기면 T-6 오염(회피 완료).
- 위키 `recipes/silsa.md` [SL-ID/DIM/BOM/PRC] 블록은 의미 INHERIT, 7절 결함표(SL-DEF-*)는 "현재
  결함"으로 인용 금지(REVERIFY·live-snapshot 재판정·pack §2 T-6).
- 좌표 회귀·FRM_TYPE(price-engine-ddl·prcx01)은 승계 안 함(T-4·blocklist hard/advisory) — 룩업
  매트릭스 모델만 채택(pack §3.10).

---

## 이 상품 전용 하위 노드 (companion)

> 공유 축(axis/·formula/)에 **실사 노드가 아직 없다**(실사=첫 파일럿). 그래서 카테고리·사이즈·자재·
> 공식·구성요소·수량·GAP을 [[product-123-artfabric-poster-nodes]] companion에 상품-local 신설한다
> (023 방식·공유 파일 미수정). master-id를 써서 향후 공유 축(axis/silsa-*·formula/silsa-*) 승격
> 후보로 남긴다(needed_shared_nodes로 반환).
