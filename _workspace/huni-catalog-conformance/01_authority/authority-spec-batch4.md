# authority-spec-batch4.md — 굿즈파우치(goods-pouch) 정합 정답 기준 (동형 클래스 압축)

> 권위[HARD]: 상품마스터(260610) 굿즈파우치(가격포함) 시트 + 인쇄상품 가격표(260527). 라이브·§18 설계=입력/렌즈.
> 산출: hcc-authority-curator · 라이브 읽기전용 SELECT 실측 2026-06-23 · DB 미적재 · v03/STALE 인용 0.
> 누락 0의 자 = `conformance-checklist.csv` 굿즈파우치 1,274행(98 prd × 13축). 본 spec은 클래스 단위 압축.
> 도메인 선행 = `domain-lens-batch4.md`(굿즈=완제 고정가·인쇄물 아님). 가격엔진 설계 재사용 = §18 `engine-design-goods-pouch.md`.

## 0. 모집단 확정 (라이브 1:1 실측·엑셀ID 부정확)

| | 수 | 근거 |
|---|---|------|
| 엑셀 distinct 상품명 | 103 (레더라벨제작 중복 제거 102) | goods-pouch-l1.csv 상품명(D열) 전수 |
| **라이브 모집단(검증 대상)** | **98 prd_cd** | PRD_000183~280 연속·del_yn=N·prd_nm JOIN |
| 엑셀↔라이브 미매칭 | 5 (폰케이스류) | 라이브 미등록 → CONFIRM(아래 C-GP-1) |

★ checklist는 라이브 98 prd × 13축 = **1,274행 append**(기존 1,924 → 3,198 데이터행·중복 prd_cd 0·빈셀 0).

## 1. ★동형 클래스 (옵션구성 × 가격계산방식) — 대표 + 전파

§18 GP-1/GP-2 + CPQ/가공/추가상품 신호를 합쳐 **7 동형 클래스**로 압축(checklist는 전수·spec은 클래스).

| 클래스 | 정의(판별 신호) | 대표 prd_cd | 상품수(98 기준) | 가격계산방식 | 면적/고정가 |
|--------|----------------|-------------|:---:|-------------|------------|
| **GP-1** 단일고정가 | 옵션 0·variant 없음·단일 가격 | PRD_000185 카드거울 | ~52 | product_prices unit×qty | 고정가(단일) |
| **GP-2-SIZE** 사이즈등급 variant | 옵션=S/M/L·variant별 가격 | PRD_000186 사각손거울 | ~10 | FORMULA opt_cd/siz_cd 룩업 | 고정가(variant) |
| **GP-2-VAR** 용량/면 variant | 옵션=용량/단·양면·variant별 가격 | PRD_000193 머그컵 | ~9 | FORMULA opt_cd 룩업 | 고정가(variant) |
| **GP-PROC** 가공보유 | 가공(옵션)_가공 비어있지 않음 | PRD_000227 미니우치와키링 | 8 | 고정가 + 가공 가산(개당/×수량 가드) | 고정가+가산 |
| **GP-ADD** 추가상품보유 | 추가상품(옵션) 비어있지 않음 | PRD_000217 만년스탬프 | 5 | 고정가 + addon SKU | 고정가+addon |
| **GP-COUNT** 구수/팩 | 묶음수 옵션(N구/팩) | PRD_000202 키캡키링 | ~6 | 고정가(구수=variant 또는 동가) | 고정가 |
| **GP-NOPRICE** 가격부재 | 가격·선택가격 둘다 empty | PRD_000199 투명부채 | 5 | 권위 가격 없음 → CONFIRM | (TBD) |

(클래스는 비배타·한 상품이 GP-PROC+GP-2 동시 가능. checklist needed가 셀 단위 정답·spec은 가격축 압축.)

## 2. ★클래스별 판별차원 (가격이 무엇으로 갈리는가) — silent 합산/평탄화 가드 [HARD·돈크리티컬]

`_row_matches`: 단가행 차원 NULL = 와일드카드(항상 매칭). 판별차원을 단가행에 충전하지 않으면 1택 선택해도
전 단가행 silent 합산/오선택 = 과대청구. 클래스별 판별차원 명시:

| 클래스 | 판별차원(use_dims) | NULL이면 발생하는 결함 |
|--------|-------------------|----------------------|
| **GP-1** | 차원 없음(product_prices 단일가) | 구조적 침입 불가(차원 0) — 안전 |
| **GP-2-SIZE** | `["siz_cd"]` (S/M/L 등급) | 평탄화 시 M주문에 S가격(G-GP-3·돈크리) |
| **GP-2-VAR** | `["opt_cd"]` (용량/면) | 평탄화 시 단면주문에 양면가(벨벳 15000↔16000) |
| **GP-PROC** | 가공 comp use_dims=[opt_cd]·min_qty | ★개당 가산 vs 1회 정액 판별 누락=×수량 과청구(Q-GP-FIN1) |
| **GP-ADD** | addon은 별 SKU(공식 외) | 본체 공식에 addon 섞이면 이중합산 |
| **GP-COUNT** | 구수가 가격축이면 [opt_cd]·아니면 동가 | 타공개수 비례 시 구수 보존 누락=오청구(GAP-COUNT) |

★ **GP-2 PRODUCT_PRICE 선점 가드[HARD]**: GP-2 상품에 product_prices 1행이라도 있으면 FORMULA 우회 →
variant 단가 영영 안 먹힘. 인스펙터는 GP-2 prd에 product_prices EXTRA 행이 있는지 반드시 점검.

## 3. 13축 정답 기준 (권위 컬럼·대상 t_*·정합 규칙·owner)

| 축 | 권위 컬럼(상품마스터/가격표) | 대상 t_* | 정합 규칙 | owner |
|----|------------------------------|----------|----------|-------|
| 사이즈코드 | 상품(옵션)·파일사양_작업/재단사이즈 | t_prd_product_sizes / t_siz_sizes | 옵션 사이즈등급↔siz 매칭. 단일사이즈=needed N | basedata |
| 도수 | 상품(옵션) 단/양면·주문방법_편집기 | t_prd_product_print_options | 인쇄면 variant. 항상 needed Y | basedata |
| 인쇄옵션 | 가공(옵션)_가공(고주파/승화/UV) | t_prd_product_processes | 가공 보유 8상품만 Y | basedata |
| 판형 | 파일사양_출력용지규격(hidden) | t_prd_product_plate_sizes | ★굿즈=전지 없음·전건 needed N. **라이브 85 plate_sizes=EXTRA 후보**(인스펙터 검증) | basedata |
| 자재 | 상품(옵션) 원단·구분(소재군) | t_prd_product_materials | 본체 소재=BOM·항상 Y. 가격 합산 아님(inline baked-in) | basedata |
| 공정 | 가공(옵션)_가공(고주파/재봉/박) | t_prd_product_processes | 가공 보유 8상품 Y | basedata |
| 묶음수 | 상품(옵션) N구/팩 | t_prd_product_bundle_qtys | 옵션 보유 65상품 Y | basedata |
| 페이지룰 | (굿즈 비해당) | t_prd_product_page_rules | 전건 needed N(완제·비책자) | basedata |
| 옵션그룹 | 상품(옵션)·가공(옵션) 택일 | t_prd_product_option_groups/options/option_items | 옵션/가공 보유 67상품 Y. **라이브 0행=전건 MISSING** | cpq-link |
| 제약규칙 | 제약 별표(★)=폰케이스 신규마커뿐 | t_prd_product_constraints | 전건 needed N. 라이브 EXTRA는 인스펙터 | cpq-link |
| 추가상품 | 추가상품(옵션) | t_prd_product_addons | 보유 5상품 Y. 라이브 0행 | cpq-link |
| 추가상품 템플릿 | 추가상품(옵션)→SKU | t_prd_templates+selections | 추가상품 5상품과 동치 Y | cpq-link |
| **가격엔진** | 가격(C열) + 인쇄상품 가격표(260527) | t_prd_product_price_formulas → t_prc_* → component_prices + t_prd_product_prices + discount_tables | ★**전건 MISSING** — 98/98 product_price_formulas 바인딩 0·product_prices 0행. 가격 권위 93상품 보유 needed Y | price-engine |

## 4. 라이브 커버리지 실측 (인스펙터 기준선·2026-06-23)

| t_* 축 | 굿즈 98 중 적재 prd 수 | 정합 판정 방향 |
|--------|:---:|----------------|
| t_prd_product_price_formulas | **0** | ★전건 MISSING(돈크리·가격계산 불가) |
| t_prd_product_prices | **0** | GP-1 본체 고정가 그릇 전무 → MISSING |
| t_prd_product_sizes | 11 | 옵션 보유 대비 미달 |
| t_prd_product_materials | 78 | round-22 적재분(레더/캔버스/타이벡/메쉬) |
| t_prd_product_plate_sizes | 85 | ★**EXTRA 의심**(굿즈=전지 없어야 함·판형 needed 전건 N) |
| t_prd_product_discount_tables | 82 | 구간할인 4타입 골격(base 0이라 현재 0원) |
| t_prd_product_processes | 6 | 가공 8상품 대비 |
| t_prd_product_print_options | **0** | 도수 needed 98 대비 전건 MISSING |
| t_prd_product_option_groups/options/items | **0** | CPQ 옵션레이어 전무(GP-2 룩업 불가) |
| t_prd_product_addons/constraints/page_rules/sets | 0 | addon 5·나머지 N/A |
| t_prd_product_bundle_qtys | 1 | 묶음수 65 대비 미달 |

## 5. 과대청구 후보 (전 카탈로그 스캔 재사용·2026-06-23)

★ 전 카탈로그 과대청구 스캔(`04_price_engine/overcharge-scan-catalog`)에서 **굿즈파우치 적출 0** 확인됨
(돈 새는 면 전부 차단·미검증 4시트=sticker·acrylic·silsa·goods-pouch 적출 0). 단 본 배치는 **가격 미바인딩
(전건 MISSING)** 상태라 현재는 과대청구가 발생할 base 자체가 없음 — **적재 시점에 G-GP-3 평탄화/G-GP-5
PRODUCT_PRICE 선점 가드 미준수하면 과대청구 신규 발생** 위험. 인스펙터·게이트는 적재 명세 검증 시 판별차원
충전을 강제 점검(GP-2 9상품·GP-PROC 8상품 1순위).

## 6. CONFIRM 큐 (권위 충돌·인간 확인)

| ID | 쟁점 | 권위 상태 | 라우팅 |
|----|------|----------|--------|
| **C-GP-1** 폰케이스 5종 미등록 | 슬림하드/블랙젤리/임팩트젤하드/에어팟/버즈=엑셀 "준비해야함"·라이브 0 | 상품 등록 선행(round-24) | 검증 제외(미존재)·등록 후 GP-2 바인딩 |
| **C-GP-2** GP-NOPRICE 5상품 | 투명부채·미니CD앨범·극세사타월·타이벡북커버·말랑증사홀더 = 가격·선택가격 둘다 empty | 상품마스터 가격 권위 부재 | 가격표 260527 별도 존재 여부 확인 / 신규 준비중인지 인간 확정 |
| **C-GP-3** 판형 85 EXTRA | 굿즈=전지 없어야 하나 라이브 plate_sizes 85 적재 | round-22 잔재 의심 | 인스펙터 EXTRA 판정 → dbm-axis-staged-load 정리 |
| **C-GP-4** 가공 가산 개당 vs ×수량 | 라벨/맥세이프/에폭시 가산이 개당인지 1회인지 | 라이브 미적재 | 적재 전 dbm-price-arbiter 심의(Q-GP-FIN1) |
| **C-GP-5** 구수 가격축 여부 | 키캡 1~4구가 타공비례인지 동가인지 | 상품마스터 명시 부재 | GAP-COUNT·dbm-ddl-proposer |

## 7. 동형 전파 규칙 (대표→나머지)

- GP-1 대표(카드거울 PRD_000185) 종단 검증 결과를 GP-1 ~52상품에 전파(product_prices 단일가 MISSING 동일).
- GP-2-SIZE 대표(사각손거울 PRD_000186)·GP-2-VAR 대표(머그컵 PRD_000193) 종단을 variant 그룹에 전파
  (FORMULA 미바인딩+CPQ 미연결 동일·평탄화 가드 동일).
- GP-PROC 대표(미니우치와키링 PRD_000227)·GP-ADD 대표(만년스탬프 PRD_000217)는 가공/addon 축만 추가 검증.
- ★전파는 "동일 결함 동형"을 압축할 뿐 checklist 셀은 전수(98×13 누락 0). 게이트는 대표+무작위 스팟 재실측.
