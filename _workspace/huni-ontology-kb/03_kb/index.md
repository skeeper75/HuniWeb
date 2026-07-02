# Huni-Ontology-KB — 진입점 (index)

> LLM이 질의 시 **가장 먼저 읽는 파일**(D-12). 유형별 노드 파일 목록 + 한 줄 훅 + NL 질의 시작점.
> 정본(SOT) = `03_kb/`. 그래프(`04_graph/`)는 이 파일들에서 빌드된 파생물 — 그래프만의 사실 없음.
> 스키마 = `../02_ontology/`(v1.0.1) · 집필 컨벤션 = `.claude/skills/okb-ontology-authoring/SKILL.md`.
>
> **상태(2026-07-03):** Phase 4 상품 노드 집필 완료 — 디지털인쇄 파일럿 **대표 8상품(E1) + 공유 축 + 공식/구성요소 + 용어·규칙·결정·의도·GAP**.
> 8상품 전부 `priced_by`→공식→`has_component`→구성요소 **가격경로 연결 완료**(고아 공식 0). 공유 축 노드
> (모서리·라미네이팅·명함사이즈·몽블랑 240g) **축 승격(260703)**으로 상품-local 중복(L-3) 해소. 일부 축 노드
> (별색·타공 등)는 아직 연결 대기(소프트 경고) — 미집필 상품군 확장 시 채워진다.

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
- [axis/materials.md](axis/materials.md) — E4 material 7종(백색모조지·아트지·스노우지·랑데뷰 +몽블랑240g 승격). parent+usage_cd 모델.
- [axis/processes.md](axis/processes.md) — E6 process 18종(★PROC_000004 디지털 base·별색·코팅·귀돌이·오시·미싱·박·완칼·접지·타공·가변 +명함/후가공 자식공정 6 승격 260703: 직각·둥근·유광/무광라미·가변텍스트/이미지).
- [axis/print-options.md](axis/print-options.md) — E5 print_option 4종(단면/양면·1도). ★도수=print_opt_cd(색상코드 아님).
- [axis/plate-sizes.md](axis/plate-sizes.md) — E7 plate_size(국전 OUTPUT_PAPER_TYPE.01). 종이류만·fn_best_plate 자동선택.

### 가격
- [formula/digital-formulas.md](formula/digital-formulas.md) — E9 price_formula 9종(PRF_DGP_A~F 원자합산·명함/포토카드 고정가). has_component 배선.
- [formula/digital-components.md](formula/digital-components.md) — E10 price_component 23종. use_dims 차원 선언(값=evaluate_price).

### KB 전용 레이어
- [intent/intents.md](intent/intents.md) — 용도 축 INTENT 3종(카페오픈·웨딩·프리미엄).
- [rule/rules.md](rule/rules.md) — RULE 7종(범위경계·판형 종이류만·판걸이수 DB함수·가격값 경계·도수=printopt·IMPORT자재 삭제금지·단가행≠배선).
- [rule/decisions.md](rule/decisions.md) — DEC 7종(base공정18건·완칼.03·귀돌이.03·판걸이수 t_siz_pansu·통합별색·배선round22·수량교정).
- [rule/gaps.md](rule/gaps.md) — GAP 15종 = 횡단 6(판수 15v18·롤소재·봉투세트·박부모자식·투명019·상품수집계) + 상품별 9(016 공정미민팅/봉투addon·024/027 봉투·032 코팅면수·033/041 가변파라미터·043 타공·046 완칼골든 — 노드는 상품 파일 정의·gaps.md 하단 링크).

### 표준
- [standards/README.md](standards/README.md) — schema.org/XJDF/구성 온톨로지 이름표(횡단·standards-mapping 승격 예정).

### 상품 노드 (E1·Phase 4)
> 디지털인쇄 대표 8상품. 각 상품 = `priced_by`→공식→`has_component`→구성요소 **가격경로** + 축 연결
> (`has_size`/`uses_material`/`has_process`/`has_print_option`/`has_plate_size`) + CPQ 옵션그룹 + GAP.
> 상품별 하위 노드는 같은 파일 또는 companion(`-nodes`/`-cpq`/`-axes`/`-sizes`)에.

- [product/product-016-premium-postcard.md](product/product-016-premium-postcard.md) — 프리미엄엽서(PRD_000016) 파일럿 앵커. 완제품 단일·사이즈 7·단/양면·자재 21·공정(base+오시+미싱)·PRF_DGP_A 원자합산·봉투 addon 5행·옵션그룹 7·제약 데모 2. 전용 하위노드 12(qty-016·optgroup-016-*·constraint-016-*·gap-016-*).
- [product/product-032-coated-namecard.md](product/product-032-coated-namecard.md) — 코팅명함(PRD_000032·명함·완제품 PRD_TYPE.01). 고정가 PRF_NAMECARD_COAT(용지포함·use_dims mat_cd/min_qty/print_opt_cd)·코팅(유광/무광)·모서리(직각/둥근) CPQ 4그룹·배선교정 이력(DEC_namecard032_wiring_260630)·코팅면수 GAP(GAP_032_coat_side).
- [product/product-033-standard-namecard.md](product/product-033-standard-namecard.md) — 스탠다드명함(PRD_000033·완제품 단일·고정가 PRF_NAMECARD_FIXED). CPQ 옵션그룹 4(print/paper/corner/postpress)·gap-033-vardata-param(줄수·개수 미보존). 명함 사이즈(008/133)·모서리/가변 공정은 공유 축 승격(260703).
- [product/product-027-bifold-card.md](product/product-027-bifold-card.md) — 2단접지카드(PRD_000027)·완제품 단일·PRF_DGP_E(+박분기 PRF_DGP_E_FOIL)·박칼라 옵션풀·봉투 addon GAP. min8/incr8(2-up). 마스터=[product/product-027-nodes.md](product/product-027-nodes.md)(사이즈6·자재7·공정10·박구성요소3), CPQ=[product/product-027-cpq.md](product/product-027-cpq.md)(옵션그룹5·option_refs 27·addon GAP).
- [product/product-024-photocard.md](product/product-024-photocard.md) — 포토카드(PRD_000024)·완제품 단일·고정가 PRF_PHOTOCARD_NORMAL·opt_grp 차원·봉투 addon GAP(gap-024-addon-envelope).
- [product/product-041-coupon.md](product/product-041-coupon.md) — 스탠다드 쿠폰/상품권(PRD_000041)·완제품 단일·PRF_DGP_A 공유·후가공 파라미터 GAP. 마스터=[product/product-041-coupon-axes.md](product/product-041-coupon-axes.md)(사이즈2·자재4·옵션그룹3).
- [product/product-043-bg-opp.md](product/product-043-bg-opp.md) — 인쇄배경지 OPP봉투타입(PRD_000043)·완제품 단일·PRF_DGP_C·포장세트·접지+타공·타공비 배선 GAP(GAP_043_perf_process). 사이즈=[product/product-043-bg-opp-sizes.md](product/product-043-bg-opp-sizes.md)(6행).
- [product/product-046-label-tag.md](product/product-046-label-tag.md) — 라벨/택(PRD_000046·인쇄포장재 CAT_000327·완칼 die-cut·PRF_DGP_B·.03 고정 교정). 하위 축·GAP=[product/product-046-label-tag-nodes.md](product/product-046-label-tag-nodes.md)(사이즈3·커팅모양 옵션·gap-046-diecut-golden).

---

## 대표 8상품 로드맵 (Phase 4 완료 — 8/8 집필·가격경로 연결·prd_cd 라이브 실측)

| slug | prd_cd | 상품명 | 구분 | 공식 | 상태 |
|---|---|---|---|---|---|
| product-016-premium-postcard | PRD_000016 | 프리미엄엽서 | 엽서 | PRF_DGP_A | 집필 완료(2026-07-03·13노드·39엣지) |
| product-032-coated-namecard | PRD_000032 | 코팅명함 | 명함 | PRF_NAMECARD_COAT | 집필 완료(2026-07-03) |
| product-033-standard-namecard | PRD_000033 | 스탠다드명함 | 명함 | PRF_NAMECARD_FIXED | 집필 완료(2026-07-03·11 하위 노드) |
| product-027-bifold-card | PRD_000027 | 2단접지카드 | 접지카드 | PRF_DGP_E·PRF_DGP_E_FOIL † | 집필 완료(2026-07-03·3파일 34노드) |
| product-046-label-tag | PRD_000046 | 라벨/택 | 라벨택 | PRF_DGP_B | 구축 완료(260703) |
| product-024-photocard | PRD_000024 | 포토카드 | 포토카드 | PRF_PHOTOCARD_NORMAL | 집필 완료(2026-07-03) |
| product-041-coupon | PRD_000041 | 스탠다드 쿠폰/상품권 | 상품권 | PRF_DGP_A | 집필 완료(2026-07-03) |
| product-043-bg-opp | PRD_000043 | 인쇄배경지(OPP봉투타입) | 배경지(포장) | PRF_DGP_C | 집필 완료(2026-07-03) |

† product-027 실 바인딩 = 2공식(PRF_DGP_E 기본·PRF_DGP_E_FOIL 박 분기)로 확정(로드맵 표기 'PRF_DGP_E(+FOIL)' 각주 갱신).
전 8상품 `prd_typ_cd=PRD_TYPE.01`(완제품 단일)·live-snapshot 20260702_1119 실측(del_yn=N). 상세 근거=`_meta/build-report-260703.md`.

---

## log
연대기(ingest/build) = [log.md](log.md)(append-only).
