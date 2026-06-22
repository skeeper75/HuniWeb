# price-engine-defects-batch4.md — 굿즈파우치 가격엔진 결함 보드 + 종단 e2e (배치4)

> 생성측: hcc-price-engine-inspector. 라이브 읽기전용 SELECT 실측 2026-06-23. DB 미적재.
> 재사용[HARD]: §13 `engine-contract.md`(권위 계약) · §18 `engine-design-goods-pouch.md`·`golden-cases-goods-pouch.md`(처방). 조사 반복 0.
> 모집단: 라이브 98 prd(PRD_000183~280·del_yn=N). owner=price-engine 98셀 전수 = `price-engine-cells-batch4.csv`.

## 0. 라이브 커버리지 실측 (권위 스펙 0/98 예상 → 확정)

| t_* 축 | 굿즈 98 중 적재 prd | 판정 |
|--------|:---:|------|
| t_prd_product_price_formulas | **0** | ★전건 MISSING(가격산출 불가·source=NONE) |
| t_prd_product_prices | **0** | GP-1 본체 고정가 그릇 전무 → MISSING |
| t_prd_product_discount_tables | 82 | 바인딩 골격 존재하나 **base 0 → 전 82건 고아(할인 무력)** |
| (shared formula 경유) | **0** | 공유공식 간접 바인딩도 0 → 우회 가격경로 없음 |
| (product_prices EXTRA) | **0** | GP-2 PRODUCT_PRICE 선점 위험 행 0(현재 안전·적재 시 가드 필요) |

★ 라이브 실측이 authority-spec-batch4 §4 기준선과 **완전 일치**(formula 0·pp 0·option_groups 0·print_options 0).

## 1. 결함 본질 = 가격 산출 불가 (전건 미바인딩)

evaluate_price 계약(engine-contract): product_prices도 product_price_formulas도 없으면 `source=NONE`
→ **base_amount 산출 불가 → 견적 0원**. 굿즈 98 prd 중 가격 권위 보유 93상품이 전부 이 상태.
이는 [[huni-widget-red-price-never-zero]] 위반 신호(가격 0 = 우리측 결함)와 동류 — **적재 누락 결함**.

| ID | 위치 | 증상 | 권위 정답 | 라이브 | 재현 SQL | 돈영향 | 라우팅 |
|----|------|------|----------|--------|----------|--------|--------|
| **D-GP4-BIND** | 93 prd(NOPRICE 5 제외) | formula 0 + product_prices 0 = source=NONE | §18 GP-1=product_prices INSERT·GP-2=FORMULA 신설 | 전건 0 | `SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280'` → 0 | **차단**(견적 0원·가격산출 불가) | dbm-load-execution(§18 처방 적재·인간승인) |
| **D-GP4-DSC-ORPHAN** | 82 prd | discount_tables 바인딩됐으나 base 가격 0 → 할인 곱할 대상 없음 | base 적재 후 정상 동작 | 82건 고아 | `…discount_tables d WHERE NOT EXISTS(formula) AND NOT EXISTS(product_prices)` → 82 | 차단 부수(base 적재 시 자동 해소) | D-GP4-BIND와 동반 해소 |
| **D-GP4-ACR-MISBIND** | PRD_000203 LED투명키캡키링 | 할인타입 **DSC_ACR_QTY**(아크릴 할인) 굿즈에 오귀속 | 굿즈=GOODSA/B/FABRIC/SQUISHY 4종 중 1 | DSC_ACR_QTY | `SELECT dsc_tbl_cd FROM t_prd_product_discount_tables WHERE prd_cd='PRD_000203'` | 잠재 오청구(base 적재 시 아크릴 구간율 적용=틀린 할인) | dbm-axis-staged-load(할인타입 재바인딩) |

## 2. NO_AUTHORITY 구분 (결함 아님·권위부재)

C-GP-2: 가격·선택가격 둘다 empty인 5상품 = **적재 불가**(결함 아닌 권위부재). MISSING_BIND와 별개 분류.

| prd_cd | 상품 | 판정 | 라우팅 |
|--------|------|------|--------|
| (투명부채) | 투명부채 | NO_AUTHORITY | 가격표260527 별도존재 여부 / 신규준비중 인간확정 |
| (미니CD앨범) | 미니CD앨범 | NO_AUTHORITY | 〃 |
| (극세사타월) | 극세사타월 | NO_AUTHORITY | 〃 |
| (타이벡북커버) | 타이벡북커버 | NO_AUTHORITY | 〃 |
| (말랑증사홀더) | 말랑증사홀더 | NO_AUTHORITY | 〃 |

★ NOPRICE 5는 prd_nm 매칭으로 cells.csv에 NO_AUTHORITY 마킹. 라이브 98 중 가격공란 = 적재 대상 아님.

## 3. ★판별차원 설계 정합 검증 (적재 후 신규 과대청구 가드·§18 처방 대조)

현 라이브는 base 미적재라 silent 합산 0이나, **§18 design이 클래스별 판별차원을 옳게 선언했는지** 검증
(적재 시점에 미충전이면 신규 과대청구 발생). golden-cases §2-1 가드 대조:

| 클래스 | §18 처방 판별차원 | 검증 판정 | 적재 시 미충전 결함 |
|--------|------------------|----------|-------------------|
| GP-1 단일고정가 | product_prices 단일가(차원 0) | ✅ 안전(차원 0=침입 불가) | 없음 |
| GP-2-SIZE | component_prices use_dims=`[siz_cd]` | ✅ 처방 정합(golden GC-GP7/8/9 S/M/L 정확매칭) | 평탄화 시 M주문에 S/L가(G-GP-3 돈크리·과소/과대) |
| GP-2-VAR | use_dims=`[opt_cd]`(용량/면) | ✅ 처방 정합(GC-GP10/11/12 벨벳 양면 16000) | 평탄화 시 단면주문에 양면가 |
| GP-PROC | 가공 comp use_dims=`[opt_cd]`·min_qty | ⚠ Q-GP-FIN1 미해소(개당 vs 1회 정액) | ×수량 과청구(C-GP-4 arbiter 심의 선행) |
| GP-COUNT | 구수 가격축이면 `[opt_cd]`·아니면 동가 | ⚠ C-GP-5 미해소(타공비례 여부) | 구수 보존 누락=오청구(GAP-COUNT) |

★ GP-2 PRODUCT_PRICE 선점 가드: 라이브 product_prices EXTRA 0행 확인 → 현재 선점 위험 없음.
**단 적재 시 GP-2 prd에 product_prices 1행이라도 들어가면 FORMULA 영영 우회**(G-GP-5) → 적재 명세에서
GP-2는 product_prices INSERT 금지·FORMULA 경로만 강제(게이트 재점검 대상).

## 4. 종단 e2e 추적 (대표 골든 GC-GP2 재현 시도·§18 golden-cases)

**케이스 GC-GP2: 틴거울(PRD_000183) qty=100** — GP-1 단일고정가 + DSC_GOODSB 할인.

| 단계 | 권위 기대(§18 적재 후) | 라이브 현 상태 | 정합 |
|------|----------------------|---------------|------|
| ① 옵션 선택 | variant 없음(GP-1 단일) | option_groups 0행 | (옵션 없음·해당없음) |
| ② 차원 환원 | 단일가(차원 0) | — | (차원 0) |
| ③ base 산출 | product_prices.unit=3,000 × qty 100 = 300,000 | **product_prices 0행 → source=NONE** | 🔴 **단절**(base 산출 불가) |
| ④ 할인 적용 | DSC_GOODSB 100~499=5% → ×0.95 | discount_tables 바인딩 O(DSC_GOODSB_QTY)·디테일 verbatim 일치 | (바인딩 OK·base 없어 무력) |
| ⑤ final_price | **285,000** (골든) | **0원(가격산출 불가)** | 🔴 골든 미달 |

★ **추적 단절 지점 = ③ base 산출**(product_prices 0행). 가장 비싼 결함 — 견적 자체가 안 나옴.
진원 = **t_prd_product_prices unit_price 미적재**(단가값 결함 아님·C열 3,000 verbatim 옳음·할인 바인딩·디테일 전부 라이브 실재·정합).
④ 할인 인프라(DSC_GOODSB 디테일 1~99=0%·100~499=5%·500~=10%)는 골든 §0-3과 **허용오차 0 일치** — base만 채우면 ⑤가 자동 성립.

**GP-2 종단(GC-GP7 사각손거울 M):** ③ FORMULA variant 단가행(siz_cd=M=5,500) 룩업 기대 →
라이브 formula 0행·option_groups 0행 → ①variant 선택 불가 + ③단가행 부재 = **이중 단절**(CPQ+가격 동시 미적재).

## 5. 할인 인프라 정합 (verbatim 대조·base 적재 시 즉시 동작)

4종 할인타입 디테일 라이브 실측이 golden-cases §0-3과 **허용오차 0 verbatim 일치**:

| 할인타입 | 라이브 구간 | 골든 §0-3 | 정합 | 굿즈 바인딩 prd수 |
|----------|-----------|----------|------|:---:|
| DSC_GOODSA_QTY | 1~49=0·50~99=5·100~499=10·500~999=15·1000~=20 | 동일 | ✅ | 15 |
| DSC_GOODSB_QTY | 1~99=0·100~499=5·500~=10 | 동일 | ✅ | 11 |
| DSC_FABRIC_QTY | 1~49=0·50~99=5·100~499=10·500~999=15·1000~=20 | 동일 | ✅ | 50 |
| DSC_SQUISHY_QTY | 1~1=0·2~9=10·10~29=15·30~49=20·50~99=25·100~499=30·500~999=40·1000~=50 | 동일 | ✅ | 5 |
| (DSC_ACR_QTY) | — | 굿즈 비해당 | 🔴 D-GP4-ACR-MISBIND | 1(PRD_000203 오바인딩) |

★ A타입 vs B타입 입증(golden §1): 코르크코스터(GOODSA·100=10%) vs 틴거울(GOODSB·100=5%) — 라이브 바인딩 정합 확인.

## 6. 판정 종합

- **MISSING_BIND 93** (가격산출 불가·견적 0·source=NONE) + **NO_AUTHORITY 5** (권위부재·적재불가) = 98 전수.
- 결함 본질 = **전건 미바인딩**(라이브가 권위 미달=round-13 역전·검사 오류 아님). §18 처방 완비·미적재.
- 할인 인프라(82 바인딩 + 4종 디테일)는 verbatim 정합 — base만 적재하면 ⑤ 자동 성립.
- 신규 결함 2건: D-GP4-ACR-MISBIND(LED투명키캡키링 할인타입 오귀속)·판별차원 미해소 2(Q-GP-FIN1·C-GP-5).
- **클래스 A**(즉시 가능): D-GP4-BIND GP-1 product_prices 적재(단가 verbatim·할인 정합)·D-GP4-ACR-MISBIND 재바인딩.
- **클래스 B**(선행 컨펌): GP-2 FORMULA(판별차원 충전·CPQ 옵션레이어 동반)·C-GP-4 가공 개당/1회(arbiter)·C-GP-5 구수.

## 7. 라우팅 (실 COMMIT 인간 승인)

| 라우팅 | 대상 | 선행 |
|--------|------|------|
| dbm-load-execution | GP-1 product_prices INSERT(§18 처방·C열 verbatim) | 클래스A·인간승인 |
| dbm-axis-staged-load | PRD_000203 할인타입 DSC_ACR_QTY→정확한 굿즈 타입 재바인딩 | 클래스A |
| dbm-price-arbiter | C-GP-4 가공 가산 개당 vs ×수량(Q-GP-FIN1)·C-GP-5 구수 가격축 | 클래스B 심의 |
| (인간 확정) | C-GP-2 NOPRICE 5 가격권위 존재 여부 | NO_AUTHORITY |
