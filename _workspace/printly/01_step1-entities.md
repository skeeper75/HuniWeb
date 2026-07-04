# 프린틀리 — PART 1 Step 1: 핵심 엔티티(그릇) 정의 초안

> 작성: 2026-07-04 · Step 0 확정(재사용·업종=intent 확장·마케팅 아키타입) 위에서 진행.
> **[HARD] 이 문서는 엔티티 그릇 + 속성 초안까지다.** 속성 확정은 지니 확인 대상(PART 3). 관계(Step 2)·제약(Step 3) 미진입.
> 원칙: ①온톨로지=유일 진실원본 ④근거 node_id ⑤재사용(재분석 금지). 신규 엔티티는 형(型)만·인스턴스는 데이터 확보 후.

---

## 0. 엔티티 7종 한눈표 (재사용/신규 판정)

| 프린틀리 엔티티 | 기존 그릇(재사용) | 판정 | 파일럿 인스턴스 |
|---|---|---|---|
| ① 업종 | §33 `intent` 확장 | 재사용+확장(키스톤) | 카페·미용실·음식점·학원·꽃집 (소수) |
| ② 홍보물 | §33 `product`·`category`·§35 `product_family` | 재사용(마케팅 부분집합) | 명함·전단·배너·스티커·메뉴판 |
| ③ 사양 | §33 `size`·`print_option`·`process`·`material` | 재사용(4축 완비) | 각 홍보물의 실 사양 |
| ④ 장비 | §35 `production_capability` | 재사용(설비 세분 후속) | 후니 보유 능력 프로파일 |
| ⑤ 인쇄소=**벤더/브랜드** | §35 `supplier`+`brand` | 재사용(다중벤더·§1-C) | **후니·와우·레드**(벤더) |
| ⑥ 파일포맷=**논리/가상 2층** | (신규·특허 C3) | ★신규(가상화·§1-C) | 논리계약+장비프로파일 |
| ⑦ 배송 | (신규) | ★신규(리드타임 축·Q6) | 배송방식×리드타임 |

---

## 1. 엔티티별 그릇·속성 초안

### ① 업종 `industry` (재사용+확장 = §33 intent)
- **그릇**: §33 `intent`(INTENT_*·앵커 none·용어집/경쟁사 근거)를 "업종"으로 확장. 원자 기능 분해(키스톤·AliCoCo).
- **속성 초안**: `id`(INTENT_카페 등)·`label`(표시명)·`atomic_functions`(원자 기능 배열: 예 카페={대면접객·메뉴노출·브랜딩·이벤트})·`badge`(candidate 시작)·`sources`.
- **승격 규칙**(tykimos 차용): 원자 기능은 근거 N개(≥3) 확보 시 verified 승격·미만 candidate·과분해 금지.
- **근거**: §33 `ontology-schema.md` E-intent·§35 구조 리서치 보완-1.

### ② 홍보물 `promo_item` (재사용 = §33 product/family, 마케팅 부분집합)
- **그릇**: §33 `product`(E1)·`category`(E2)·§35 `product_family`(E20). 마케팅 아키타입만 파일럿.
- **속성 초안**: `id`(product-*)·`name`·`category`·`archetype`(명함/전단/배너/스티커/메뉴판)·`prd_typ_cd`(완제품 등)·`badge`·`sources`(t_prd_products 앵커).
- **근거**: §33 275상품·라이브 t_prd_products.

### ③ 사양 `spec` (재사용 = §33 4축)
- **그릇**: 4개 하위 축을 그대로 재사용 — `size`(E3 규격)·`print_option`(E5 색상·도수·인쇄방식)·`process`(E6 후가공)·`material`(E4 용지·소재).
- **속성 초안**: 각 축은 §33 스키마 속성 승계(size=width×height·재단/작업·material=mat_typ/usage·print_option=print_side/colrcnt·process=mand_yn/base). 인쇄방식(합판/독판)은 §35 U-4 print_method 1급 축.
- **근거**: §33 E3~E6·라이브 t_prd_product_* 앵커.

### ④ 장비 `equipment` (재사용 = §35 capability · 세분 후속)
- **그릇**: 파일럿은 §35 `production_capability`(E23) 재사용(설비 1대=1노드 세분은 Q3 후속). capability가 `capability_covers`로 생산축(사양)을 가리킴.
- **속성 초안**: `id`·`capability_profile`(커버하는 사양 축 집합)·`moq`/`max_qty`(능력 실측 후)·`badge=candidate`·`gap_ref`.
- **근거**: §35 `routing-layer-schema.md` E23·CIP4 DeviceCapabilities 이름표.

### ⑤ 인쇄소 `print_shop` (형만 = §35 supplier · seed 대기)
- **그릇**: §35 `supplier`(E22·roles=[broker,supplier]). 후니=자사+중개.
- **속성 초안**: `id`·`name`·`region`(지역)·`lead_time`(납기)·`quality`(품질 등급)·`roles`·`badge=candidate`·`gap_ref=G-ROUTE-1`.
- **대기**: Q4 파일럿 인쇄소 seed 데이터(후니 자사 1+외주 2~3) 지니 제공.
- **근거**: §35 E22·schema.org seller/broker·MSDL Supplier.

### ⑥ 파일포맷 `file_format` ★신규 (원천 대기 Q5)
- **그릇**: 신규. 장비가 요구하는 입고 파일 사양(RIP-ready).
- **속성 초안**(지니 확정): `id`·`bleed`(재단여백)·`color_profile`(CMYK 프로파일)·`resolution`(해상도)·`pdf_standard`(PDF/X 등)·`imposition_required`(터잡기 전제)·`badge=candidate`·`sources`(장비 매뉴얼/실무 규칙).
- **대기**: Q5 파일포맷 요구사항 원천·범례 지니 제공.

### ⑦ 배송 `delivery` ★신규 (리드타임 축 · Q6)
- **그릇**: 신규. 1차 범위=리드타임 축(실배송 연동 후속).
- **속성 초안**(지니 확정): `id`·`method`(택배/퀵/방문)·`lead_time`·`region`·`cost_axis`(값=엔진 경계)·`badge=candidate`.
- **대기**: Q6 배송 모델 1차 범위 확정.

---

## 1-B. 리서치 근거 반영 (2026-07-04 · 지니 지시 1·2·3)

> 리서치 산출: `research/industry-classification.md`(업종)·`research/print-production-standards.md`(생산·장비·파일포맷)·`research/delivery-research.md`(배송). 생성≠검증 — 채택 전 게이트 재실측 필요.

### ① 업종 — 근거 확정 방향
- **채택 분류**: 소진공(소상공인시장진흥공단) 상권정보 업종분류(대10/중75/소247) 정본 + 통계청 KSIC 백본 + 서울시 100대 생활밀접업종 그룹핑.
- **파일럿 업종 8**: 카페/베이커리·음식점·미용/뷰티·학원/교육·병원/의원·부동산·소매일반·(candidate)꽃집.
- **원자 마케팅 기능 8**(추천 기준): IDENTITY(명함)·ACQUIRE(전단/배너/현수막)·RETAIN(쿠폰/스탬프/상품권)·DISPLAY(메뉴판/포스터/리플렛)·BRAND(스티커/패키징)·EVENT(오픈고지)·SIGN(안내사인)·FORM(봉투/서식).
- **§33 매핑**: `intent` 축에 `intent_kind`(occasion|industry) 속성으로 접기(노드 폭증 방지). `INTENT_BIZ_*` 8후보·badge=candidate·N≥3 승격(미용만 verified 후보). 기존 `INTENT_cafe_opening`=`INTENT_BIZ_cafe`의 EVENT 하위 재배치.

### ⑥ 파일포맷·④ 장비 — 근거 확정 방향
- **표준 기관 5층**(CIP4 외 확장): CIP4(워크플로/능력/상거래) → ISO 15930 PDF/X + ISO 16612 PDF/VT(파일) → Ghent Workgroup GWG(프리플라이트) → ISO 12647/Fogra/GRACoL·G7(색) → Adobe PDF Print Engine(RIP).
- **장비 5종×파일포맷**: 옵셋/윤전=PDF/X-4+CTP+ISO12647색 / 디지털=PDF/X-4+PDF/VT / 실사=PDF·TIFF+타일링 / UV=PDF+화이트·바니시 스팟 채널.
- **장비 그릇**: §35 `capability_covers`(print_method·material·size·bundle_qty) 재사용 + 신규 축 `requires_file_format` 1개만.
- **★신규 경계 노드 2**(원칙3·D-ROUTE 동형·quote_function 동형): `preflight_function`(온톨로지=검사규칙 축·엔진=통과/반려 계산·Ghent) · `imposition_function`(온톨로지=전략 축 n-up/gang/booklet/tiling·엔진=판걸이수/면付·fn_calc_pansu 재사용).

### ⑦ 배송 — 근거 확정 방향 (그릇만)
- **핵심**: 리드타임 2분해 — `deliveryLeadTime`(주문→출고=생산 리드타임·프린틀리 핵심) vs `deliveryTime`(주문→도착=총). §35 criterion-leadtime 정합.
- **그릇**: method(DeliveryMethod/ParcelDelivery)·region·leadtime·cost_axis. 값=`delivery_function` 엔진 경계. 이번엔 스키마/그릇만(지니 지시 3).

### WebToProduct 교차참조
- 영상 자막 미확보(GAP-PRINTLY-W2P1). §11 rpmeta 레드 역공학 프록시: 레드는 `item_gbn`(생산모델 라우팅)·디자인입력채널·인쇄방식별 pdtCode로 웹→상품→생산 연결·가격 서버 계산. **전부 기존 축 흡수·새 축 불필요** 재확인.

## 1-C. 정체 정정 + 특허 통합 (2026-07-04 · 지니 확정)

### ★프린틀리 정체 = 다중 벤더 소상공인 AI 인쇄 에이전트(브로커)
- 프린틀리는 **후니 내부 시스템이 아니라**, **후니프린팅·와우프레스·레드프린팅 등 여러 벤더의 엔진을 연결하는 소상공인 맞춤 AI 인쇄 에이전트**다. = **§35 다중브랜드 온톨로지 + 라우팅 층의 런타임 실현체**([[huni-multibrand-ontology-harness]]).
- 시사(엔티티 재해석):
  - **⑤ 인쇄소 = 벤더/브랜드**(후니·와우·레드) = §35 `E22 supplier` + `E21 brand`. 인쇄소 라우팅 = **어느 벤더에 주문 넘길지**(§35 라우팅 E22~E25·RT-1~6 재사용).
  - **견적 = 벤더별 엔진**(§35 브랜드별 `quote_function`·D-18): 후니=evaluate_price·와우=jobcost API·레드=레드 견적(+지니 WebToProduct 엔진). 온톨로지는 벤더 무관 축까지·값=각 벤더 엔진.
  - **① 업종·② 홍보물·③ 사양**은 §35 상위 온톨로지(브랜드-중립)로 벤더 무관 추천 → `same_family_as` 교차 → 벤더별 견적 비교(§35 nl-query T3/T4).
- **결론**: 프린틀리 = §35 상위 온톨로지(추천·가격 축) + §35 라우팅(벤더 배정) + 지니 WebToProduct 엔진(생산) + AI 에이전트 오케스트레이션(PART 2 루프).

### ★특허(지니 자산) 반영 — 엔티티/엔진 갱신 (patent-analysis.md)
- **⑥ 파일포맷 = 논리/가상 2층으로 교정**(개선-P1·수정-P1·특허 C3 장비 가상화):
  - `logical_output_contract`(논리·장비무관 출력 계약) + `device_profile`(dpi/회전/방식/포트/변환규칙). 장비 추가 = 가상 드라이버 1개(전 변환 재배선 X). 덱의 N×M 매트릭스는 가상화 엔진 내부 구현.
- **신규 결정론 엔진 경계 노드 2 추가**(전부 §35 quote_function 동형·값=엔진):
  - `production_time_function`(추가-P1·특허 C1): 생산 소요시간 예측(Path 복잡도)→**리드타임** 산출. ⑦ 배송·라우팅에 시간 축 공급(기존 GAP 해소).
  - `preflight_function` **커팅 특화 확장**(확장-P1·특허 C2): 중복/초소형 객체 제거·예각 완화·커팅순 재정렬(도무송/반칼 상품).
- **imposition_function 확장**(추가-P2·특허 C1): 단일 주문 판걸이 → 다중 주문 배치/네스팅 최적화(후니 합판·fn_calc_pansu 연결).
- **라우팅 기준 추가**(보완-P2): routing_criterion에 `production_time`(C1)·`device_capability`(C3) 축.
- **IP**: 지니 본인 특허라 프린틀리 자유 활용. 벤더별 엔진은 각자 소유·지니 WebToProduct 엔진 방법은 지니 것.

## 2. 다음 확인받을 것 (PART 4 규칙 3)

**만든 것:** 프린틀리 7엔티티 그릇 + 속성 초안(재사용 4·형만 1·신규 2). 재사용 4개는 §33/§35 앵커 실재·신규 3개는 형만·데이터 대기.
**다음 확인받을 것:** 위 **속성 초안 교정**(특히 ①업종 원자 기능 목록·⑥파일포맷 속성·⑦배송 범위). 확정 후 Step 2(관계 정의)로 진입.

## 근거 (재사용·읽기)
- §33 `_workspace/huni-ontology-kb/02_ontology/ontology-schema.md`(E1~E12·E-intent)
- §35 `_workspace/huni-multibrand-ontology/03_upper_ontology/routing-layer-schema.md`(E22~E25)·구조 리서치 `structure-recommendations.md`(intent 원자 분해)·`tykimos-onto-projects-extraction.md`(N+ 승격)
- Step 0 `_workspace/printly/00_step0-concept-normalization.md`(게이트 3 확정)
