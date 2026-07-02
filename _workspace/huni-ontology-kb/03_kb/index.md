# Huni-Ontology-KB — 진입점 (index)

> LLM이 질의 시 **가장 먼저 읽는 파일**(D-12). 유형별 노드 파일 목록 + 한 줄 훅 + NL 질의 시작점.
> 정본(SOT) = `03_kb/`. 그래프(`04_graph/`)는 이 파일들에서 빌드된 파생물 — 그래프만의 사실 없음.
> 스키마 = `../02_ontology/`(v1.0.1) · 집필 컨벤션 = `.claude/skills/okb-ontology-authoring/SKILL.md`.
>
> **상태(2026-07-03·확장):** Phase 4 상품 노드 집필 완료 — 디지털인쇄 파일럿 **36상품(E1·PRD_000016~051) + 공유 축 + 공식/구성요소 + 용어·규칙·결정·의도·GAP**.
> 36상품 전부 `priced_by`→공식→`has_component`→구성요소 **가격경로 연결**(038 형압명함만 `derived_from`→gap-038-no-price-path 정직 선언·O5 예외). 공유축 통합(260703)으로
> 브로큰링크 해소 공유노드 21종(투명/명함박 자재 4·명함 고정가 공식 5·완제품가 구성요소 12) 일괄 mint(025/035/036/037/039 배선).
> 나머지 needed_shared_nodes(018 자재2·019 PET/화이트공정·박색 8자식 등)는 상품별 GAP으로 정직 지연(rewire 미실행·honest GAP=위반 아님).

---

## 검색 라우팅 시작점 (nl-query-paths §0)

1. **구체 상품 질의**("프리미엄엽서 100장 얼마") → [product/product-016-premium-postcard.md](product/product-016-premium-postcard.md)(프리미엄엽서 시작점) → `priced_by`→[formula/digital-formulas.md](formula/digital-formulas.md) → `has_component`→구성요소. (타 상품 진입점=아래 §상품 노드 E1)
2. **용도 추천**("카페 오픈 나눠줄 것") → [intent/intents.md](intent/intents.md) `INTENT_*` → `references`→카테고리/상품.
3. **조건 탐색**("양면 되는 엽서") → [axis/print-options.md](axis/print-options.md)·[axis/materials.md](axis/materials.md) 역탐색.
4. **옵션 조합·제약**("오시랑 미싱 같이 돼?") → 상품 내 `optgroup-*`·`constraint-*` (예: [product/product-016-premium-postcard.md](product/product-016-premium-postcard.md) `optgroup-016-*` + `constraint-016-demo-exc`=오시↔미싱 상호배제 데모·`constraint-016-demo-vis`=표시조건). [DEMO] 제약은 badge=candidate(§31 거버넌스 확정 대기).
5. **거절형**("언제 배송돼?") → [rule/rules.md](rule/rules.md) `RULE_scope_boundary`(주문·배송·회원·쿠폰=범위 밖·정직 거절).

**가격 경계(D-18):** KB는 "이 상품→이 공식→이 구성요소→이 차원(use_dims)"까지만. **최종 값은 evaluate_price/견적기**.

---

## 유형별 노드 파일 (현재 등재)

### 상품군·분류
- [axis/categories.md](axis/categories.md) — E2 category 8종(엽서 CAT_000307·명함 CAT_000313·접지카드 CAT_000021·쿠폰상품권 CAT_000062·포토카드 CAT_000310·인쇄포장재 CAT_000327·인쇄홍보물 CAT_000003·엽서카드 CAT_000001).
- [_glossary.md](_glossary.md) — E13 term(디지털인쇄·귀돌이·별색·판걸이수·원자합산형·완칼·판형). altLabel→alias_of 투영.

### 차원·자재·공정 축
- [axis/sizes.md](axis/sizes.md) — E3 size 10종(016 엽서 7행+국전 +명함 90x50·86x52 승격 260703). 치수 전사표(fn_calc_pansu 판걸이수는 파생).
- [axis/materials.md](axis/materials.md) — E4 material 11종(백색모조지·아트지·스노우지·랑데뷰 +몽블랑240g 승격 +투명/반투명 PET·큐리어스스킨270g·bare PET 통합 mint 260703). parent+usage_cd 모델. ★상품-local 자재(companion)까지 합 56종(라이브 전체는 상품별 확장).
- [axis/processes.md](axis/processes.md) — E6 process 18종(★PROC_000004 디지털 base·별색·코팅·귀돌이·오시·미싱·박·완칼·접지·타공·가변 +명함/후가공 자식공정 6 승격 260703: 직각·둥근·유광/무광라미·가변텍스트/이미지).
- [axis/print-options.md](axis/print-options.md) — E5 print_option 4종(단면/양면·1도). ★도수=print_opt_cd(색상코드 아님).
- [axis/plate-sizes.md](axis/plate-sizes.md) — E7 plate_size(국전 OUTPUT_PAPER_TYPE.01). 종이류만·fn_best_plate 자동선택.

### 가격
- [formula/digital-formulas.md](formula/digital-formulas.md) — E9 price_formula 14종(PRF_DGP_A~F 원자합산·명함/포토카드 고정가 +투명포토카드/모양/미니모양/박/투명명함 5종 통합 mint 260703). has_component 배선. ★상품-local 공식(031/040/042/048/030 등 companion) 합 23종.
- [formula/digital-components.md](formula/digital-components.md) — E10 price_component 35종(+투명세트/모양명함S1S2/미니모양S1S2/박6/투명명함 12종 통합 mint 260703). use_dims 차원 선언(값=evaluate_price). ★companion 포함 합 53종.

### KB 전용 레이어
- [intent/intents.md](intent/intents.md) — 용도 축 INTENT 3종(카페오픈·웨딩·프리미엄).
- [rule/rules.md](rule/rules.md) — RULE 7종(범위경계·판형 종이류만·판걸이수 DB함수·가격값 경계·도수=printopt·IMPORT자재 삭제금지·단가행≠배선).
- [rule/decisions.md](rule/decisions.md) — DEC 7종(base공정18건·완칼.03·귀돌이.03·판걸이수 t_siz_pansu·통합별색·배선round22·수량교정).
- [rule/gaps.md](rule/gaps.md) — GAP 67종 = 횡단 6(판수 15v18·롤소재·봉투세트·박부모자식·투명019·상품수집계) + 상품별 61(017~051 자재미민팅/봉투addon/코팅면수/가변파라미터/타공/완칼골든/박색선택/제약 등 — 노드는 상품 파일 정의·gaps.md 색인). 정직 GAP=위반 아님.

### 표준
- [standards/README.md](standards/README.md) — schema.org/XJDF/구성 온톨로지 이름표(횡단·standards-mapping 승격 예정).

### 상품 노드 (E1·Phase 4)
> 디지털인쇄 대표 8상품. 각 상품 = `priced_by`→공식→`has_component`→구성요소 **가격경로** + 축 연결
> (`has_size`/`uses_material`/`has_process`/`has_print_option`/`has_plate_size`) + CPQ 옵션그룹 + GAP.
> 상품별 하위 노드는 같은 파일 또는 companion(`-nodes`/`-cpq`/`-axes`/`-sizes`)에.

**엽서/카드 계열**
- [product/product-016-premium-postcard.md](product/product-016-premium-postcard.md) — 프리미엄엽서(PRD_000016) 파일럿 앵커. 완제품 단일·사이즈 7·단/양면·자재 21·공정(base+오시+미싱)·PRF_DGP_A 원자합산·봉투 addon 5행·옵션그룹 7·제약 데모 2.
- [product/product-017-coated-postcard.md](product/product-017-coated-postcard.md) — 코팅엽서(PRD_000017·엽서·완제품 PRD_TYPE.01). PRF_DGP_A 원자합산·사이즈 7·단/양면·자재 2(아트지 250/300g)·공정 5(base+유광/무광 라미+직각/둥근)·옵션그룹 4·신규 공유노드 0.
- [product/product-018-standard-postcard.md](product/product-018-standard-postcard.md) — 스탠다드엽서(PRD_000018·엽서). 016 동일 골격(PRF_DGP_A·국전판형)·사이즈 5·자재 7·CPQ 완전배선(옵션값15+옵션아이템15). 하위 9(qty-018·optgroup-print/paper/corner/postpress·GAP 4). 미민팅 자재 2종(080/090)=GAP_018_material.
- [product/product-019-transparent-postcard.md](product/product-019-transparent-postcard.md) — 투명엽서(PRD_000019·엽서). PRF_DGP_A 공유·투명/반투명 PET+화이트인쇄(PROC_000008 mand) 차별·단면만·사이즈 4·옵션그룹 4. GAP: gap-019-material·gap-019-white-process·GAP_transparent019_pansu(C트랙).
- [product/product-020-white-print-postcard.md](product/product-020-white-print-postcard.md) — 화이트인쇄엽서(PRD_000020·엽서). 어두운 색지(큐리어스스킨 4색)+흰/투명 토너 별색·PRF_DGP_A(SPOT_WHITE_S1+용지비)·PROC_000008 mand+009 opt. 하위=[product/product-020-white-print-postcard-nodes.md](product/product-020-white-print-postcard-nodes.md)(자재4·공정2·수량1·옵션그룹3·gap2). 색지/별색공정 040과 공유(product-local·승격 후보).
- [product/product-021-pink-spot-postcard.md](product/product-021-pink-spot-postcard.md) — 핑크별색엽서(PRD_000021·엽서·★use_yn=N 미출시). 핑크 별색=공정 PROC_000010(별색 자식·도수 아님)·PRF_DGP_A·핑크 별색가=통합별색 COMP_PRINT_SPOT_WHITE_S1(PROC_000007 환원)·봉투 addon 5행. 하위 8(qty·optgroup·gap).
- [product/product-022-gold-silver-spot-postcard.md](product/product-022-gold-silver-spot-postcard.md) — 금은별색엽서(PRD_000022·엽서·★use_yn=N). PRF_DGP_A·★정체(금/은 별색)이 별색공정 PROC_000007 미배선→가격 미기여(gap-022-spotcolor-unwired). 하위 3(qty·gap·GAP_022_material).
- [product/product-023-shaped-postcard.md](product/product-023-shaped-postcard.md) — 모양엽서(PRD_000023·엽서·★use_yn=N). 완칼 die-cut 90×90 단일·PRF_DGP_B(인쇄+용지+완칼)·공정 base+완칼 PROC_000123 mand. companion=[product/product-023-shaped-postcard-nodes.md](product/product-023-shaped-postcard-nodes.md)(사이즈1·자재2·공정1 local). 046과 PRF_DGP_B 공유.
- [product/product-024-photocard.md](product/product-024-photocard.md) — 포토카드(PRD_000024)·완제품 단일·고정가 PRF_PHOTOCARD_NORMAL·opt_grp 차원·봉투 addon GAP(gap-024-addon-envelope).
- [product/product-025-transparent-photocard.md](product/product-025-transparent-photocard.md) — 투명포토카드(PRD_000025)·완제품 단일·고정가 PRF_PHOTOCARD_CLEAR(투명세트·V3 공식분리)·투명/반투명 PET 260g·단면만·화이트인쇄(가격 미배선)·CPQ 4그룹·GAP 3. (통합 mint 260703: MAT_000144/147·PRF_PHOTOCARD_CLEAR·COMP_PHOTOCARD_CLEAR_SET)
- [product/product-026-paper-slogan.md](product/product-026-paper-slogan.md) — 종이슬로건(PRD_000026·포토카드 구분)·완제품 단일·PRF_DGP_A(엽서·상품권 공유)·슬로건 2종·아트지300g·코팅·editor_yn=N(파일업로드만)·코팅면수 GAP(gap-026-coat-side).

**접지카드 계열**
- [product/product-027-bifold-card.md](product/product-027-bifold-card.md) — 2단접지카드(PRD_000027)·PRF_DGP_E(+박분기 PRF_DGP_E_FOIL)·박칼라 옵션풀·봉투 addon GAP. 마스터=[product/product-027-nodes.md](product/product-027-nodes.md), CPQ=[product/product-027-cpq.md](product/product-027-cpq.md).
- [product/product-028-mini-folded-card.md](product/product-028-mini-folded-card.md) — 미니접지카드(PRD_000028·★use_yn=N). PRF_DGP_E(base)·박 8공정 붙었으나 박분기공식/옵션 부재=gap-028-foil-price-path. min30/incr30. 마스터=[product/product-028-mini-folded-card-nodes.md](product/product-028-mini-folded-card-nodes.md)(사이즈2·자재4·GAP2).
- [product/product-029-trifold-card.md](product/product-029-trifold-card.md) — 3단접지카드(PRD_000029)·PRF_DGP_E(+박분기)·박칼라 옵션풀·봉투 addon GAP. min8/incr8. 형제 027 동형. 마스터=[product/product-029-trifold-card-nodes.md](product/product-029-trifold-card-nodes.md)(신규 공정 PROC_000067/068), CPQ=[product/product-029-trifold-card-cpq.md](product/product-029-trifold-card-cpq.md).
- [product/product-030-zigzag-postcard.md](product/product-030-zigzag-postcard.md) — 지그재그엽서(PRD_000030·접지카드·출시). 6단접지(오시/미싱)·양면·3절 판형이관·PRF_DGP_C_6CR(07-01 신설). 마스터=[product/product-030-zigzag-postcard-nodes.md](product/product-030-zigzag-postcard-nodes.md)(사이즈2·자재1·공정2·판형(3절)1·6단접지비 구성요소1·공식1·옵션그룹3). GAP 3.

**명함 계열**
- [product/product-031-premium-namecard.md](product/product-031-premium-namecard.md) — 프리미엄명함(PRD_000031·명함). 고정가 등급가 PRF_NAMECARD_PREMIUM(+박분기 _FOIL)·프리미엄 지질 14·박칼라 8·CPQ 5그룹·배선교정. 하위=[product/product-031-premium-namecard-nodes.md](product/product-031-premium-namecard-nodes.md). GAP: GAP_031_paper_parent_child·gap-031-vardata-param.
- [product/product-032-coated-namecard.md](product/product-032-coated-namecard.md) — 코팅명함(PRD_000032·명함). 고정가 PRF_NAMECARD_COAT·코팅(유광/무광)·모서리 CPQ 4그룹·배선교정·코팅면수 GAP(GAP_032_coat_side).
- [product/product-033-standard-namecard.md](product/product-033-standard-namecard.md) — 스탠다드명함(PRD_000033·고정가 PRF_NAMECARD_FIXED). CPQ 4그룹·gap-033-vardata-param. 명함 사이즈(008/133)·모서리/가변 공정 공유 축 승격(260703).
- [product/product-034-pearl-namecard.md](product/product-034-pearl-namecard.md) — 펄명함(PRD_000034·명함). 펄지(스타드림 4종)+박 고정가 2공식(PRF_NAMECARD_PEARL·_FOIL)·사이즈 90x50·박색 8공정(027 재사용)·자재오염 정리 이력·GAP_034_foil_optgroup. companion=[product/product-034-pearl-namecard-nodes.md](product/product-034-pearl-namecard-nodes.md).
- [product/product-035-shaped-namecard.md](product/product-035-shaped-namecard.md) — 모양명함(PRD_000035·고정가 PRF_NAMECARD_SHAPE 용지포함·siz_cd 키). 사이즈 SIZ_000008·몽블랑240g·칼라 단/양면. GAP 2(gap-035-diecut-process·gap-035-cpq-option-layer). (통합 mint 260703: PRF_NAMECARD_SHAPE·S1/S2)
- [product/product-036-mini-shaped-namecard.md](product/product-036-mini-shaped-namecard.md) — 미니모양명함(PRD_000036·명함). 고정가 PRF_NAMECARD_MINISHAPE(용지포함·S1단면/S2양면)·50x50(046 공용)·몽블랑240g·CPQ 옵션그룹 0·gap-036-diecut-process-absent. (통합 mint 260703: PRF_NAMECARD_MINISHAPE·S1/S2)
- [product/product-037-original-foil-namecard.md](product/product-037-original-foil-namecard.md) — 오리지널박명함(PRD_000037·명함). 고정가 PRF_NAMECARD_FOIL(박 본체+동판셋업)·박종류 CPQ 1그룹·박색 8자식 공정(027 재사용)·배선 이력·GAP 2(gap-037-foil-color-select·gap-037-plate-output-paper). 자재=큐리어스스킨(MAT_000137). (통합 mint 260703: MAT_000137·PRF_NAMECARD_FOIL·6구성요소)
- [product/product-038-emboss-namecard.md](product/product-038-emboss-namecard.md) — 형압명함(PRD_000038·명함·★use_yn=N). 스켈레톤 바인딩(사이즈1·단/양면·모서리2·국전판형). 자재0·공식0·옵션그룹0. 가격사슬 부재→derived_from→[[gap-038-no-price-path]](O5 예외)·형압 PROC_000050 미바인딩→[[gap-038-emboss-unbound]]·[[gap-038-skeleton-bindings]].
- [product/product-039-transparent-namecard.md](product/product-039-transparent-namecard.md) — 투명명함(PRD_000039·명함). 고정가 PRF_NAMECARD_CLEAR(용지포함·자재무관·단면 단독)·투명 PET(MAT_000178 MAT_TYPE.08)·모서리·CPQ 0·gap-039-white-print-absent. (통합 mint 260703: MAT_000178·PRF_NAMECARD_CLEAR·COMP_NAMECARD_CLEAR_S1)
- [product/product-040-white-print-namecard.md](product/product-040-white-print-namecard.md) — 화이트인쇄명함(PRD_000040·명함). 020 색지4+032/033 명함 고정가 하이브리드·flat PRF_NAMECARD_WHITE(4구성요소=단/양면×클리어별색)·클리어별색 CPQ 1그룹·재바인딩 견적0 교정. 전용=[product/product-040-white-print-namecard-nodes.md](product/product-040-white-print-namecard-nodes.md)(색지4·별색공정은 020-nodes 재사용).

**상품권/포장/홍보물 계열**
- [product/product-041-coupon.md](product/product-041-coupon.md) — 스탠다드 쿠폰/상품권(PRD_000041)·PRF_DGP_A 공유·후가공 파라미터 GAP. 마스터=[product/product-041-coupon-axes.md](product/product-041-coupon-axes.md).
- [product/product-042-premium-coupon-voucher.md](product/product-042-premium-coupon-voucher.md) — 프리미엄 쿠폰/상품권(PRD_000042)·041 형제+박(FOIL) 분기·PRF_DGP_A(+_FOIL)·★종이 4종 굿즈 오적재 잔존(defect). 마스터=[product/product-042-premium-coupon-voucher-nodes.md](product/product-042-premium-coupon-voucher-nodes.md)(청정2·오염4 defect·GAP3).
- [product/product-043-bg-opp.md](product/product-043-bg-opp.md) — 인쇄배경지 OPP봉투타입(PRD_000043)·PRF_DGP_C·포장세트·접지+타공·타공비 배선 GAP. 사이즈=[product/product-043-bg-opp-sizes.md](product/product-043-bg-opp-sizes.md).
- [product/product-044-backing-card-clear-case.md](product/product-044-backing-card-clear-case.md) — 인쇄배경지 투명케이스타입(PRD_000044·인쇄포장재)·043 형제·PRF_DGP_C·타공비 배선 GAP(GAP_044_perf_process). 사이즈=[product/product-044-backing-card-clear-case-sizes.md](product/product-044-backing-card-clear-case-sizes.md)(SIZ_000039/041).
- [product/product-045-header-tag.md](product/product-045-header-tag.md) — 인쇄헤더택(PRD_000045·인쇄포장재)·PRF_DGP_C·단면만·043 형제·타공비 배선 GAP(GAP_045_perf_process). 사이즈=[product/product-045-header-tag-sizes.md](product/product-045-header-tag-sizes.md)(SIZ_000043~046).
- [product/product-046-label-tag.md](product/product-046-label-tag.md) — 라벨/택(PRD_000046·인쇄포장재·완칼 die-cut·PRF_DGP_B·.03 고정 교정). 하위=[product/product-046-label-tag-nodes.md](product/product-046-label-tag-nodes.md).
- [product/product-047-small-flyer.md](product/product-047-small-flyer.md) — 소량전단지(PRD_000047·인쇄홍보물·use_yn=Y). PRF_DGP_D(인쇄+코팅+용지+후가공)·A5/A4/A3/A3+·자재 46(대표 7 배선)·CPQ 4그룹·GAP 4(제약 스냅샷지연·코팅면수·가변파라미터·매달린 옵션참조 MAT_000129).
- [product/product-048-folded-leaflet.md](product/product-048-folded-leaflet.md) — 접지리플렛(PRD_000048·인쇄홍보물). 양면 칼라·자재 46(14 배선·30 미민팅·2 오염의심)·priced_by PRF_FOLD_SUM. ★가격 경로 불완전(접지비만)·사이즈 0행→GAP 3. 마스터=[product/product-048-folded-leaflet-nodes.md](product/product-048-folded-leaflet-nodes.md)(PRF_FOLD_SUM local mint).
- [product/product-049-wide-folded-leaflet.md](product/product-049-wide-folded-leaflet.md) — 와이드 접지리플렛(PRD_000049·인쇄홍보물). 640×297·양면·자재 5(3절)·공정 7(base+3단/병풍접지+라미+가변)·PRF_DGP_E·CPQ 0행 GAP. 전용=[product/product-049-wide-folded-leaflet-nodes.md](product/product-049-wide-folded-leaflet-nodes.md).
- [product/product-050-envelope-making.md](product/product-050-envelope-making.md) — 봉투제작(PRD_000050·인쇄홍보물). ★완제품가 매트릭스형 PRF_ENV_MAKING→COMP_ENV_MAKING(봉투종류×소재×수량·60행 격자완전)·봉투옵션→사이즈 환원. 하위=[product/product-050-envelope-making-nodes.md](product/product-050-envelope-making-nodes.md).
- [product/product-051-suncap.md](product/product-051-suncap.md) — 썬캡(PRD_000051·인쇄홍보물/여행아웃도어·★use_yn=N). 전용 3절 판형(SIZ_000535·fn_best_plate)·완칼 die-cut·PRF_DGP_F(인쇄+용지+완칼). 하위 6(category-CAT_000181·size·plate·material·qty·gap-051-golden).

---

## 디지털인쇄 파일럿 36상품 로드맵 (확장 완료 — 36/36 집필·가격경로 연결·prd_cd 라이브 실측)

| slug | prd_cd | 상품명 | 구분 | 공식 | 상태 |
|---|---|---|---|---|---|
| product-016-premium-postcard | PRD_000016 | 프리미엄엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03) |
| product-017-coated-postcard | PRD_000017 | 코팅엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·코팅 가격경로) |
| product-018-standard-postcard | PRD_000018 | 스탠다드엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·CPQ 완전배선) |
| product-019-transparent-postcard | PRD_000019 | 투명엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·PET+화이트인쇄) |
| product-020-white-print-postcard | PRD_000020 | 화이트인쇄엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·별색 화이트/클리어) |
| product-021-pink-spot-postcard | PRD_000021 | 핑크별색엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·use_yn=N·핑크별색=공정) |
| product-022-gold-silver-spot-postcard | PRD_000022 | 금은별색엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·use_yn=N·별색 미배선 GAP) |
| product-023-shaped-postcard | PRD_000023 | 모양엽서 | 엽서 | PRF_DGP_B | 집필 완료(2026-07-03·use_yn=N·완칼) |
| product-024-photocard | PRD_000024 | 포토카드 | 포토카드 | PRF_PHOTOCARD_NORMAL | 집필 완료(2026-07-03) |
| product-025-transparent-photocard | PRD_000025 | 투명포토카드 | 포토카드 | PRF_PHOTOCARD_CLEAR | 집필 완료(2026-07-03·통합 mint) |
| product-026-paper-slogan | PRD_000026 | 종이슬로건 | 포토카드(구분) | PRF_DGP_A | 집필 완료(2026-07-03) |
| product-027-bifold-card | PRD_000027 | 2단접지카드 | 접지카드 | PRF_DGP_E(+FOIL) † | 집필 완료(2026-07-03·3파일) |
| product-028-mini-folded-card | PRD_000028 | 미니접지카드 | 접지카드 | PRF_DGP_E(base·박분기=GAP) | 집필 완료(2026-07-03·use_yn=N) |
| product-029-trifold-card | PRD_000029 | 3단접지카드 | 접지카드 | PRF_DGP_E(+FOIL) † | 집필 완료(2026-07-03·3파일) |
| product-030-zigzag-postcard | PRD_000030 | 지그재그엽서 | 접지카드 | PRF_DGP_C_6CR | 집필 완료(2026-07-03·6단접지) |
| product-031-premium-namecard | PRD_000031 | 프리미엄명함 | 명함 | PRF_NAMECARD_PREMIUM(+_FOIL) | 집필 완료(2026-07-03) |
| product-032-coated-namecard | PRD_000032 | 코팅명함 | 명함 | PRF_NAMECARD_COAT | 집필 완료(2026-07-03) |
| product-033-standard-namecard | PRD_000033 | 스탠다드명함 | 명함 | PRF_NAMECARD_FIXED | 집필 완료(2026-07-03) |
| product-034-pearl-namecard | PRD_000034 | 펄명함 | 명함 | PRF_NAMECARD_PEARL(+_FOIL) | 집필 완료(2026-07-03·박분기) |
| product-035-shaped-namecard | PRD_000035 | 모양명함 | 명함 | PRF_NAMECARD_SHAPE | 집필 완료(2026-07-03·통합 mint) |
| product-036-mini-shaped-namecard | PRD_000036 | 미니모양명함 | 명함 | PRF_NAMECARD_MINISHAPE | 집필 완료(2026-07-03·통합 mint) |
| product-037-original-foil-namecard | PRD_000037 | 오리지널박명함 | 명함 | PRF_NAMECARD_FOIL | 집필 완료(2026-07-03·통합 mint) |
| product-038-emboss-namecard | PRD_000038 | 형압명함 | 명함 | (미배선·GAP) | 구축 완료(260703·스켈레톤·use_yn=N·가격사슬 GAP) |
| product-039-transparent-namecard | PRD_000039 | 투명명함 | 명함 | PRF_NAMECARD_CLEAR | 집필 완료(2026-07-03·통합 mint) |
| product-040-white-print-namecard | PRD_000040 | 화이트인쇄명함 | 명함 | PRF_NAMECARD_WHITE | 집필 완료(2026-07-03) |
| product-041-coupon | PRD_000041 | 스탠다드 쿠폰/상품권 | 상품권 | PRF_DGP_A | 집필 완료(2026-07-03) |
| product-042-premium-coupon-voucher | PRD_000042 | 프리미엄 쿠폰/상품권 | 상품권 | PRF_DGP_A(+_FOIL) | 집필 완료(2026-07-03·defect4·GAP3) |
| product-043-bg-opp | PRD_000043 | 인쇄배경지(OPP봉투타입) | 배경지(포장) | PRF_DGP_C | 집필 완료(2026-07-03) |
| product-044-backing-card-clear-case | PRD_000044 | 인쇄배경지(투명케이스타입) | 배경지(포장) | PRF_DGP_C | 집필 완료(2026-07-03) |
| product-045-header-tag | PRD_000045 | 인쇄헤더택 | 배경지(포장) | PRF_DGP_C | 구축 완료(2026-07-03·단면만) |
| product-046-label-tag | PRD_000046 | 라벨/택 | 라벨택 | PRF_DGP_B | 구축 완료(2026-07-03) |
| product-047-small-flyer | PRD_000047 | 소량전단지 | 인쇄홍보물 | PRF_DGP_D | 집필 완료(2026-07-03·GAP 4) |
| product-048-folded-leaflet | PRD_000048 | 접지리플렛 | 인쇄홍보물 | PRF_FOLD_SUM(★불완전) | 구축 완료(2026-07-03·가격경로 GAP 선언) |
| product-049-wide-folded-leaflet | PRD_000049 | 와이드 접지리플렛 | 인쇄홍보물 | PRF_DGP_E | 집필 완료(2026-07-03) |
| product-050-envelope-making | PRD_000050 | 봉투제작 | 인쇄홍보물 | PRF_ENV_MAKING | 구축 완료(2026-07-03·격자완전 60행) |
| product-051-suncap | PRD_000051 | 썬캡 | 인쇄홍보물 | PRF_DGP_F | 구축 완료(2026-07-03·use_yn=N) |

† 027/029 실 바인딩 = 2공식(PRF_DGP_E 기본·PRF_DGP_E_FOIL 박 분기). 038 형압명함은 priced_by 0행 → `derived_from`→gap-038-no-price-path(O5 예외·가격사슬 GAP 정직 선언).
전 36상품 `prd_typ_cd=PRD_TYPE.01`(완제품 단일)·live-snapshot 20260702_1119 실측. 상세 근거=`_meta/build-report-expand-260703.md`. 공유축 통합 mint 21종(브로큰링크 해소)·나머지 needed_shared_nodes는 상품별 GAP(정직 지연).

---

## log
연대기(ingest/build) = [log.md](log.md)(append-only).
