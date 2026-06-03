# huni-red-matching-methodology.md — 후니 상품마스터/가격 ↔ Red 검증 위젯 매칭 방안 (방안)

> 파이프라인 ③ **통합 방법론(방안)**. 두 전문 분석([RCM]=red-coverage-matrix.md 위젯/Red측 / [HDR]=huni-data-readiness.md 후니측)을
> **하나의 실행 가능한 매칭 플레이북**으로 통합한다. 재분석이 아니라 **운영화(operationalize)** — 미래 세션이 이 문서 + [RCM] 한 쌍만 들고
> 후니 상품/가격을 RedPrinting으로 검증된 위젯에 무손실로 끼워 맞추되 **그 과정에서 임계항목을 절대 누락하지 않게** 한다.
> [HARD] 본 문서는 방법론·체크리스트만. `src/` 무수정, 위젯 코드 0줄. 코드 실증은 §5의 PoC 게이트에서만, 별도 핸드오프.
> [HARD] 사용자에게 질문하지 않는다(분석/방법론 산출만).
> 근거 표기: [RCM]=red-coverage-matrix.md / [HDR]=huni-data-readiness.md / [DC]=data-contract.md / [DA]=data-adapter.md /
> [DBMAP]=huni-db-mapping.md / [EXP]=expansion-strategy.md / [XM]=cross-mapping.md(print-quote).
>
> **수렴 사실(두 분석의 합의 기반 — 이 위에서만 움직인다):**
> 1. Red 전수 479상품 = 46 옵션구조 → 위젯 14(+2) componentType이 **신규 0건**으로 전부 흡수. price_gbn은 위젯에 불투명 echo. **위젯은 증명 완료.** [RCM §2.2]
> 2. 후니 ~240상품, 4 가격모델(단가 룩업표 — Red 가격모델군과 동형), 옵션구조 ~90% 직접 + 잔여 어댑터 흡수 = 무손실 100% 주장. componentType 신규 0건. [HDR §1.3, §2.2]
> 3. **진짜 리스크는 위젯이 아니다.** (a) 어댑터 직렬화 정합(option→PCS_INFO/ORD_INFO 행 shape, hidden-essential, 침묵 PRICE=0), (b) 후니 데이터 결손(제약/disable·가격DB·MES CD 무결성·배송 미작성), (c) 코드체계 3중 불일치 + 단위 불일치. [RCM §4, HDR §4]

---

## 1. 목표·원칙·불변식 (한 줄씩)

**목표:** 후니 상품마스터/가격표를 RedPrinting으로 검증된 위젯에 **위젯 코드 0줄로** 끼워 맞추되, 매칭 과정에서 침묵 오작동(빈 그룹/0원/잘못된 캐스케이드)을 일으키는 임계항목을 하나도 누락하지 않는다.

**원칙 (5):**
- **단일 신뢰경계:** 모든 후니 raw → 정규화 계약 변환은 어댑터(`adapters/huni/`)에서만. 위젯은 어댑터 존재조차 모른다. [DA §0]
- **무손실 컨버전:** Red fixture로 통과한 위젯이 후니 어댑터 출력으로도 동일 동작. 컨버전 = 어댑터+데이터소스 교체, 위젯/계약/컴포넌트 0 변경. [DA §0]
- **서버 권위 가격:** 위젯은 4 가격모델·단가·할인·VAT·배송 산식을 모른다. 8축 입력만 보내고 불투명 finalPrice/lines[]만 받는다. [DC §3]
- **계약 중립:** 계약 타입에 Red/후니/카테고리 고유 필드명 등장 금지. 모두 id/label/도메인 중립명. [DC §8]
- **단순성 강제:** 매칭은 어댑터 매핑 테이블 + 데이터 채움. 위젯에 상품군 특이 로직 하드코딩 금지, 임의 추상화(팩토리/레지스트리) 금지. [EXP §0]

**불변식 (INV — 깨지면 매칭 실패):**
- **INV-1 서버 권위 가격** — 새 가격모델 = BFF 일, 위젯 0. [DC §3][EXP INV-1]
- **INV-2 정규화 계약 중립** — 후니 고유 필드명 계약 침투 0. [DC §8][EXP INV-2]
- **INV-3 위젯 코어 불변** — Red fixture 회귀가 후니 어댑터로도 통과. 확장은 어댑터+데이터(+조건부 componentType)이지 코어 재작성 아님. [DA §0][EXP INV-3]
- **INV-4 Shadow DOM 격리 + Portal** — 호스트 스타일 누수 0, EditorOverlay 최상단. [EXP INV-4]
- **INV-5 componentType 14종 고정 dispatch** — 신규 추가 시 계약 union + 매핑표 + dispatcher switch 동시 갱신(DESIGN 동기). [EXP INV-5]

---

## 2. 매칭 방법론 — 단계별 절차 (7 Phase)

매칭은 7단계 순차 파이프라인이다. 각 단계는 **입력 → 산출 → 완료기준**을 가지며, 완료기준 미충족 시 다음 단계로 넘어가지 않는다.
순서 원칙: **인벤토리(키 안정성) → 옵션구조 → 가격모델 → 제약/hidden → 어댑터 직렬화 → round-trip 검증**. 키가 흔들리면 이후 전부 무의미하므로 인벤토리가 1번.

### Phase 1 — 상품 인벤토리 정합 (코드체계 통일 + 키 안정성)
- **입력:** 후니 상품마스터(`t_prd_products` ✅AUTHORED + 엑셀 13시트), MES ITEM_CD, 카테고리 prefix(001~012), [XM] 삼각매핑.
- **절차:**
  1. 후니 상품 ~240종을 카테고리 prefix(001~012)로 그룹핑하고 [RCM §1] 46구조 패밀리(F1~F8)에 어느 패밀리로 들어가는지 1차 분류.
  2. **MES CD 무결성 보정(CHK-H1):** PM-DUP-01~04(코드중복 4건) + PM-MISS-01(cat 010/011 미부여 100+종)을 어댑터 **안정 복합키 `(code [+side/variant])`** 발급 규칙으로 흡수. 마이그레이션 전 코드 일괄 보정 권장(D-PM-03).
  3. **코드체계 3중 불일치 매핑표(CHK-H3):** 엑셀 한글라벨 ↔ DB 코드(`t_mat_materials.mat_cd` 등) ↔ Red CD를 1:1 매핑표로 작성. 특히 별색 5종(화이트/클리어/핑크/금/은)이 Red dosu 정의와 코드 정렬되는지 확인.
- **산출:** 통합 cross-mapping 테이블 Phase-1 행(상품코드·패밀리·복합키·코드체계 3열) — §6 산출물 형식.
- **완료기준:** 모든 후니 상품이 (a) 안정 복합키를 가진다 (b) 46 패밀리 중 하나에 배정된다 (c) 옵션 코드가 엑셀/DB/Red 3표현 매핑을 가진다. **round-trip 키 흔들림 0건**(어댑터 계약 테스트로 게이트, CHK-9/CHK-H1).

### Phase 2 — 옵션구조 사상 (후니 옵션 → 46 구조 패밀리 → componentType)
- **입력:** 후니 옵션 마스터 테이블군(size/material/print/process/quantity/page/plate ✅AUTHORED), [RCM §1] 46구조 시그니처, [DA §3] componentType 매핑 규칙, [DBMAP §1.2] 후니 테이블→componentType.
- **절차:**
  1. 각 후니 상품의 옵션 차원을 [RCM §0] 16 토큰(paper/material/dosu/sizes/SUM_MTR/CVR_INN/INN_DFT/r1~r3 등)으로 디코드.
  2. 토큰 → componentType 사상: `{후니 테이블종류 → componentType}` 룩업 테이블 작성(Red의 `DATASET_COMPONENT_TYPE`과 동일 패턴, 키만 후니 테이블명). [DBMAP §1.2 주]
  3. **후니 고유 4종 흡수 확인:** 출력판형(plate_size)→select-box, paper 200종→불투명 id, 별색 5종 분리→priceColorCount 평면화, 비규격(nonspec)→area-input(dimension-matrix). 전부 신규 0. [HDR §1.3-B]
  4. **자재합산형(SUM_MTR) 사상(CHK-6):** 후니 부자재(t_prd_product_addons)를 finish-button + selectedFinishes echo로. [RCM F5][DA §5]
- **산출:** cross-mapping 테이블 Phase-2 행(옵션그룹·토큰·componentType·side).
- **완료기준:** 후니 모든 옵션 차원이 14(+NC-1) componentType 중 하나로 사상되고 **신규 componentType 필요 건수가 명시적으로 0 또는 flag**된다(NC-1 dimension-matrix는 S3 진입 시만, [EXP §3]). 미사상 옵션 0건.

### Phase 3 — 가격모델 사상 (후니 4모델 → 계약 opaque 슬롯)
- **입력:** 후니 가격표 19시트(4모델 단가 룩업표), [HDR §2] 후니↔Red 가격모델 정합표, [DC §3] NormalizedPriceRequest/Breakdown, [DBMAP §2] QuoteResult 평면화.
- **절차:**
  1. 각 상품군을 4모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount) 중 하나로 분류하고 `priceSchemeKey`(category prefix 001~012 echo)를 정한다. 위젯은 의미 모름(불투명). [HDR §2.2]
  2. **단위 환산 정의(CHK-H2, 최고위험):** 시트별 단가 기준 단위(KRW/판·KRW/장·100장=set·세트)를 상품별 `unit` + 환산계수로 명시. BFF가 "판→장""세트→개" 환산 보유. **누락 시 가격 N배 오류.**
  3. **수량 행 shape 정합(CHK-1/CHK-H6, 최고위험):** tmpl/tiered_price는 ORD_INFO[0]에 **ORD_CNT+PRN_CNT 둘 다** 있어야 PRICE>0. 후니 수량 1컬럼을 어댑터가 양쪽 의미로 어느 게 맞는지 상품군별 확정 + 둘 다 직렬화. **한쪽만 직렬화 시 침묵 0원.**
  4. **폐쇄 래더 vs 자유 counter 분기(CHK-7/CHK-H9):** 후니 수량 정의가 자유범위(min/max/incr)인지 enum 목록인지 상품별 판정 → select-box enum vs counter-input. 임의값=0원 방지.
  5. QuoteResult(8 axis breakdown) → lines[] 평면화 규약 고정(total→finalPrice, vatAmount→vat, deliveryFee→shipping). [DBMAP §2.2]
- **산출:** cross-mapping 테이블 Phase-3 행(가격모델·priceSchemeKey·단위·환산계수·수량 shape).
- **완료기준:** 모든 후니 상품이 (a) 4모델 중 하나로 분류 (b) 단위 환산계수 보유 (c) 수량 ORD_CNT/PRN_CNT 분리 의미 확정 (d) 폐쇄래더/자유 분기 판정. **단위 미정·수량 분리 미정 상품 0건.**

### Phase 4 — 제약/캐스케이드/hidden-essential 사상
- **입력:** 후니 제약(constraint_json/excl_groups 🚧미작성), [DC §2] 6종 제약, [DBMAP §1.3] 캐스케이드, [DA §2.3] hidden 평면화.
- **절차:**
  1. **disable 규칙 파생(CHK-4/CHK-H4):** 후니 제약 데이터 미작성 → 종속(`dep_proc_cd`)/택일(`excl_groups`) 그래프 또는 `constraint_json`에서 `DisableRule[]` 파생(R1). **오늘은 Red fixture로 엔진 검증, 후니 작성 후 population 교체.**
  2. **hidden-essential 사상(CHK-2/CHK-H5):** 후니 `mand_proc_yn`(필수)만 있고 VIEW_YN 부재 → 어댑터가 `required:true + visible:false` 그룹의 default value를 selected로 미리 주입(자동공정 가격 누락 방지). 자동공정 분류법을 constraint_json/공정유형코드로 결정.
  3. **defaultSelections 선두 정렬(CHK-3):** 후니 size/dosu에 `dflt_yn` 매핑, dimension-matrix/prnLadder는 기본값을 선두 정렬(빈 자유입력 0원 진입 방지).
  4. **W/H work-size 파생(CHK-5):** nonspec일 때 cutW/cutH→workW/workH 파생(cutW + 2×cutMargin 등). 어댑터가 work 미계산 시 가격 차원 틀어짐.
  5. **면별 분기(CHK-8/CHK-H7):** 책자/CVR_INN의 표지=editor/내지=pdf를 면별 데이터 부재 시 어댑터 규약으로 고정. 책자 세트(t_prd_product_sets) vs side분리 모델링 확정.
  6. **용지 N:M 부분집합(CHK-H10):** 상품별 허용 용지를 `t_prd_product_materials`가 정확히 보유 확인(200종 전부 노출/잘못된 용지 0원 방지). D-PM-13 인기50종 정책.
- **산출:** cross-mapping 테이블 Phase-4 행(disableRules·hidden 그룹·default·work 파생·면 분기).
- **완료기준:** 캐스케이드 엔진이 Red fixture로 완전 구동 검증 + 후니 disable/hidden/default 사상 규칙이 어댑터에 명시(미작성 데이터는 Red fixture 우회로 flag). **불가능 조합 선택 가능 상태로 방치 0건.**

### Phase 5 — 어댑터(createHuniAdapter) 직렬화
- **입력:** Phase 1~4 사상 결과, [DA §1] 5개 어댑터 인터페이스(Product/Price/Upload/Editor/Cart), [DA §4] 후니 어댑터 설계.
- **절차:**
  1. `HuniProductAdapter.getProduct(prd_cd)`: Phase 1~4 사상을 NormalizedProduct로 조립(옵션그룹/제약/sides/editors/cta).
  2. `HuniPriceAdapter.quote(req)`: BFF calculateQuote(4모델) → QuoteResult → NormalizedPriceBreakdown 평면화. **quote() 가드(`isPriceRequestQuotable` [DA §2.4 패턴])를 후니에도 반드시 적용**(침묵 0원 방지, CHK-1).
  3. `HuniUploadAdapter`/`EditorAdapter`: 후니 스토리지 presigned / Edicus 파트너 토큰. DB 무관.
  4. `HuniCartAdapter`: [UNDECIDED 커머스] — Shopby 제외, 정규화 페이로드 BFF 전달까지만.
- **산출:** createHuniAdapter 직렬화 명세(어댑터 메서드별 후니 테이블 read + 정규화 출력 shape).
- **완료기준:** 어댑터 출력이 정규화 계약 스키마 일치(계약 테스트). 위젯 가시 계약 변경 0건 확인(grep 게이트, INV-2).

### Phase 6 — round-trip 검증
- **입력:** Phase 5 어댑터 출력, Red fixture, 비교 하네스(4173).
- **절차:**
  1. **fixture round-trip:** 후니값 → 어댑터 → 정규화 계약 → 위젯 렌더 → 가격요청 조립 → (mock BFF) → finalPrice 표시까지 전 경로 1상품씩 통과.
  2. **불투명 id round-trip:** 옵션 selected id가 가격요청에서 그대로 echo되어 매칭 성공하는지(키 흔들림 0).
  3. **위젯 회귀(INV-3):** Red fixture(PRBKYPR S0 등)가 후니 어댑터 도입 후에도 동일 통과.
- **산출:** §4 매칭 추적 매트릭스(상품/가격 단위 PASS/FAIL).
- **완료기준:** §4 검증 게이트 전항 통과.

> **Phase 의존성:** Phase 1(키) → 2(구조) → 3(가격) → 4(제약)는 순차. Phase 5(어댑터)는 1~4 산출을 조립. Phase 6은 5를 검증.
> 단 **Phase 2·3·4는 Red fixture 기반으로 후니 실데이터 없이 선행 가능**(임계경로 분리, §5).

---

## 3. 통합 간과 방지 체크리스트 (위젯측 10 + 후니측 11 → 위험도순 통합)

[RCM §4](CHK-1~10) + [HDR §4](CHK-H1~H11)를 **하나의 우선순위 리스트**로 병합한다. 두 분석이 이미 7쌍의 짝 매핑([HDR §4 말미])을 제공하므로, 짝은 **하나의 통합항목(M-x)**으로 합치고, 단독 항목은 그대로 둔다. **최고위험(침묵 PRICE=0 = 수량 단일컬럼/행 shape, 코드중복, 단위불일치)을 top에** 둔다.
각 항목: **무엇을 / 왜(누락 시 증상) / 어떻게 확인 / 책임경계(전부 어댑터·데이터, 위젯 코드 0).**

### 🔴 최고위험 (침묵 오작동 — 위젯 정상인데 0원/N배 오류)

**M-1 [CHK-1 ∩ CHK-H6] 수량 행 shape 정합 — 침묵 PRICE=0 (최우선)**
- **무엇:** tmpl/tiered_price는 ORD_INFO[0]에 ORD_CNT+PRN_CNT **둘 다** 있어야 PRICE>0. 후니 수량은 단일 컬럼(`제작수량`).
- **왜:** 어댑터가 후니 수량 1개를 한쪽만 직렬화하면 위젯은 정상 렌더되는데 **침묵 0원**. 굿즈(주문수≠인쇄수)에서 특히.
- **어떻게:** 후니 수량을 ORD_CNT/PRN_CNT 양쪽 의미로 상품군별 확정 + **어댑터 quote() 가드(`isPriceRequestQuotable`)를 후니에도 적용**. round-trip에서 PRICE>0 단언.
- **책임:** 어댑터 직렬화(Phase 3·5).

**M-2 [CHK-H2 단독] 가격 단위 불일치 (KRW/판 vs KRW/장 vs 세트)**
- **무엇:** 시트마다 단가 기준 단위가 다름(디지털=KRW/판, 명함=100장 set, 박명함=200장 set, 타투=3장, 스티커팩=54장).
- **왜:** 판→장/세트→개 환산 누락 시 가격이 **N배** 틀어짐. 위젯 수량 입력(장/개)과 가격표 단위(판/세트)가 다른 차원.
- **어떻게:** 상품별 `unit` + 환산계수(판걸이수 매트릭스)를 BFF 보유. round-trip에서 알려진 수량의 finalPrice가 기대치와 일치 단언.
- **책임:** BFF/어댑터(Phase 3).

**M-3 [CHK-9 ∩ CHK-H1] 코드 무결성 + round-trip 키 안정성**
- **무엇:** cat 010/011 MES CD 미부여 100+ · 코드중복 4건(PM-DUP-01~04).
- **왜:** 위젯은 불투명 id round-trip이라 무관하나, **어댑터 복합키가 흔들리면** 옵션 selected가 가격요청에서 매칭 실패 → 0원.
- **어떻게:** 어댑터 `(code [+side/variant])` 안정 복합키 + **어댑터 계약 테스트로 게이트**. 마이그레이션 전 코드 일괄 보정(D-PM-03).
- **책임:** 어댑터 키 발급(Phase 1).

**M-4 [CHK-7 ∩ CHK-H9] 폐쇄 래더 vs 자유 counter (PRN_CNT 분기)**
- **무엇:** 옵셋 캘린더(CLD_STD)·일부 상품은 등록값만 단가 보유(폐쇄 래더).
- **왜:** 자유 counter로 렌더하면 임의값=PRICE 0.
- **어떻게:** 후니 수량 정의가 자유범위(min/max/incr)인지 enum 목록인지 상품별 판정 → select-box enum vs counter-input. sentinel(1000000) 처리 BFF 명시.
- **책임:** 어댑터 분기(Phase 3).

### 🟠 고위험 (불가능 조합 / 가격 누락)

**M-5 [CHK-4 ∩ CHK-H4] 캐스케이드 disable 규칙 부재**
- **무엇:** 자재→후가공 disable 규칙 데이터가 후니에 미작성(constraint_json 비어있음, 암묵지).
- **왜:** disable 0개 → 불가능 조합(투명PET에 박 등) 선택 가능 → BFF 0원/에러.
- **어떻게:** 종속/택일 그래프 또는 constraint_json→`DisableRule[]` 파생(R1). 산식메모 시트·운영자 인터뷰로 제약 추출. **오늘은 Red fixture로 엔진 검증.**
- **책임:** 어댑터 파생 + 후니 데이터 작성(Phase 4, B2 임계경로).

**M-6 [CHK-2 ∩ CHK-H5] hidden-essential (자동공정 visible 분류 부재)**
- **무엇:** 재단(CUT_DFT)·내지기본(INN_DFT) 같은 필수·미표시·자동적용 공정. 후니는 VIEW_YN 컬럼 없음.
- **왜:** UI에 안 보이는데 가격요청에서 누락 → 가격 미달.
- **어떻게:** 어댑터가 `required:true + visible:false` 그룹 default를 selected 주입. 자동공정 구분법을 후니가 정의(constraint_json/공정유형코드).
- **책임:** 어댑터 평면화(Phase 4).

**M-7 [CHK-3 ∩ CHK-H10] defaultSelections + 용지 N:M 부분집합**
- **무엇:** 후니 `dflt_yn` 부재 시 dimension-matrix 빈 자유입력 진입 → 0원. 용지 200종 N:M 부정확 시 잘못된 용지 0원.
- **왜:** 첫 진입 상태가 가격불가 조합이면 0원으로 시작. 용지×사이즈×후가공 조합 폭발(10⁴+).
- **어떻게:** 후니 size/dosu에 기본값 플래그 매핑 + 선두 정렬. 상품별 허용 용지 부분집합을 `t_prd_product_materials`가 정확히 보유 확인 + D-PM-13(인기50종) 정책.
- **책임:** 어댑터 default 주입 + 후니 N:M 데이터(Phase 4).

**M-8 [CHK-8 ∩ CHK-H7] 면별 uploadType + 책자 세트 모델링**
- **무엇:** 표지=editor/내지=pdf 면별 분기. 후니는 `editor_yn/file_upload_yn` 상품단위 2플래그(면별 신호 부재). 책자=세트 vs side분리 미확인.
- **왜:** 잘못 고정 시 내지옵션이 표지에 붙거나 누락, UX 오류.
- **어떻게:** 후니 책자/CVR_INN 면별 입력수단 결정 데이터 존재 확인. 없으면 어댑터 규약 고정(표지=editor, 내지=pdf). 세트면 어댑터가 풀어 side 재구성.
- **책임:** 어댑터 규약(Phase 4).

### 🟡 중위험 (개별 항목 — 짝 없음)

**M-9 [CHK-1 보조 / CHK-H3] 옵션 코드체계 3중 불일치 (엑셀 한글 vs DB 코드 vs Red CD)**
- **무엇:** 엑셀=한글텍스트, DB=코드, Red=숫자 CD. 1:1 매핑 안 되면 옵션 오사상.
- **왜:** 별색 5종(화이트/클리어/핑크/금/은)이 Red dosu와 코드 정렬 안 되면 priceColorCount 평면화 오류.
- **어떻게:** 엑셀 한글↔DB코드 매핑표를 후니 작성. 어댑터는 DB코드 기준 불투명 id 사용.
- **책임:** 후니 데이터 + 어댑터(Phase 1).

**M-10 [CHK-5 단독] W/H work-size 공식 (재단마진 가산)**
- **무엇:** 비규격(nonspec)은 work 산출 공식(cutW + 2×cutMargin 등) 필요.
- **왜:** 어댑터가 nonspec work 미계산 시 가격 차원 틀어짐.
- **어떻게:** dimension-matrix(NC-1) 자유입력 시 cutW/cutH→workW/workH 파생 경로 확인.
- **책임:** 어댑터(Phase 4).

**M-11 [CHK-6 단독] SUM_MTR add-on selectedFinishes echo**
- **무엇:** 자재합산형(21 SKU) 부자재를 finish-button echo. 후니 별 테이블(t_prd_product_addons)이면 selectedFinishes로 사상.
- **왜:** 잘못 두면 가격합산에서 부자재 누락.
- **어떻게:** 후니 addon→OptionGroup(finish-button)+selectedFinishes 직렬화 일치.
- **책임:** 어댑터(Phase 2).

**M-12 [CHK-10 단독] 빈 옵션/미가격 상품 (F8)**
- **무엇:** 무지/세트구성품(price_gbn=null) 옵션 0~1개 + 가격 미연동.
- **왜:** 위젯이 빈 optionGroups 안전 렌더하나 가격영역 0원 표시 위험.
- **어떻게:** 후니 미가격 상품에 BFF `ok:false` + 위젯 가격영역 미표시 경로.
- **책임:** 어댑터/BFF(Phase 5).

**M-13 [CHK-H11 단독] 중복 정의 source-of-truth (시트 간 같은 상품)**
- **무엇:** 탁상형캘린더가 캘린더+디자인캘린더 양 시트 중복. 포토북도 마스터+가격 분리.
- **왜:** 두 곳 사양/가격 충돌 → 마이그레이션 충돌.
- **어떻게:** 상품별 single source-of-truth 시트 지정(D-PM-03 연계).
- **책임:** 후니 데이터(Phase 1).

> **체크리스트 사용법:** Phase 1~6 진행 중 각 항목의 책임경계(괄호 Phase)에서 해당 M-x를 확인. 통합 cross-mapping 테이블(§6)의 각 행에 적용 M-x ID를 기록하여 **누락 추적**. M-1~M-4(최고위험)는 round-trip(Phase 6)에서 **반드시 단언(assert) 테스트**로 게이트.

---

## 4. 검증 게이트 + 추적성

각 후니 상품/가격이 위젯에서 올바로 동작함을 어떻게 증명하나. **증거 없는 "맞을 것" 금지(INV verify).**

### 4.1 검증 게이트 (4단)
1. **fixture round-trip** (상품 단위): 후니값 → 어댑터 → 정규화 계약 → 위젯 렌더 → 가격요청 조립 → mock BFF → finalPrice. **PRICE>0 단언**(M-1), **알려진 수량의 finalPrice 기대치 일치 단언**(M-2).
2. **경계면 교차 QA** (비교 하네스 4173): 동일 옵션 선택 시 정규화 요청 페이로드가 Red와 **동등한 의미**(불투명 id round-trip 일치). 캐스케이드 disable 집합 일치. componentType DESIGN 8 Critical Rules 준수.
   - **한계:** 후니 가격은 Red와 별개 공식 → 가격 *수치* 일치는 Red 어댑터 단계만. 후니 어댑터 단계는 "정규화 스키마 일치 + BFF 4모델 결과 합리성"으로 전환. [EXP §5.2]
3. **INV-3 위젯 코어 0줄:** Red fixture(PRBKYPR S0 등) 회귀가 후니 어댑터 도입 후에도 통과. 빌드/타입/테스트 green(tsc noEmit, vitest, dispatcher exhaustive).
4. **계약 중립(INV-2):** 계약 타입에 Red/후니 고유명 0(grep 게이트).

### 4.2 매칭 추적 매트릭스 (형식 제안)
매칭 단위(상품 또는 가격모델)별 1행. 미래 세션이 "어디까지 검증됐나"를 한눈에.

| 매칭단위 | 패밀리 | componentType 사상 | 가격모델 | 적용 M-x | round-trip | 교차QA | INV-3 회귀 | 상태 |
|---------|--------|---------------------|----------|----------|:----------:|:------:|:----------:|------|
| 후니 프리미엄명함(003) | F1 | size·paper·dosu·finish·qty | PriceTable3D | M-1,M-2,M-3,M-7 | PASS/FAIL | PASS/FAIL | PASS | ⬜/✅ |
| 후니 아크릴키링(009) | F2 | size·material·dosu·addon·qty | SizeMatrix2D+Tiered | M-1,M-8,M-11 | … | … | … | ⬜ |
| 후니 굿즈파우치(010/011) | F5 | type·color·qty | TieredDiscount | M-1,M-3,M-4 | … | … | … | ⬜ |

- **상태 정의:** 4단 게이트 전부 PASS = ✅. 하나라도 미통과 = ⬜ + FAIL 사유.
- **누락 방지:** 적용 M-x 열이 비어있으면 체크리스트 미적용 = 검증 불완전. 최고위험 M-1~M-4가 적용 목록에 없으면 round-trip 게이트 자동 FAIL.

---

## 5. 단계화·우선순위·의존성

### 5.1 임계경로 = 후니 데이터, 위젯 아님 (핵심 인식)
두 분석 공통 결론: **위젯 개발은 0% 차단.** 임계경로는 후니 측 데이터 작성/보정이다. [HDR §0, DBMAP §8]

| 구분 | 항목 | 데이터 소스 | 임계경로? |
|------|------|------------|:---------:|
| **위젯 무차단 (NOW 진행)** | NormalizedProduct·옵션차원·14 componentType·캐스케이드 UI 셸·가격표시 UI | 후니 상품마스터(✅) + Red fixture + mock BFF | No |
| **후니 작성 대기 (최종통합 임계경로)** | B1 가격(엑셀 4모델→BFF) · B2 제약(disable/excl/visible) · B3 배송정책 · M-1·M-2·M-3 무결성/단위/수량 보정 | 후니 엑셀→DB, 운영자 인터뷰 | **Yes** |

### 5.2 우선순위 (무엇부터)
- **우선순위 High:** Phase 1(인벤토리 키 안정성) + M-1·M-2·M-3 보정 설계. 키·단위·수량이 흔들리면 이후 전부 무효.
- **우선순위 High:** createHuniAdapter **PoC 1개**(예: S1 디지털인쇄 프리미엄명함 또는 굿즈파우치 1상품)로 Phase 1~6 전 경로를 **코드로 실증** — 키스톤 가설(어댑터 교체=위젯 0변경)을 1상품으로 증명. [EXP §7 S1 착수와 정합]
- **우선순위 Medium:** Phase 2~4를 Red fixture 기반으로 패밀리별 일괄 사상(후니 실데이터 없이 선행).
- **우선순위 Low:** B1·B2·B3 후니 작성 완료 후 어댑터 가격/제약 arm을 mock→실 교체(최종통합).

### 5.3 Red fixture 무차단 vs 후니 실데이터 필요 지점 (명확 구분)
- **Red fixture로 무차단 진행:** 옵션구조 사상(Phase 2), componentType 라우팅, 캐스케이드 엔진 검증(Phase 4 disable/hidden 엔진), 가격표시 UI(mock BFF), 위젯 회귀(INV-3). **S3/S6는 Red fixture 미보유 → live-capture 선행이 그 stage 임계경로** [EXP §6.3].
- **후니 실데이터 필수:** 실가격 수치(M-1·M-2 검증의 기대치), disable 규칙 population(M-5), 용지 N:M 부분집합(M-7), 면별/세트 모델링(M-8), 단위 환산계수(M-2), 코드 보정(M-3).

### 5.4 createHuniAdapter PoC 권장 시점
- **시점:** Phase 1(키) + Phase 3(M-1·M-2·M-4 수량/단위/래더 설계) 완료 직후.
- **범위:** 1상품 end-to-end. 가격은 mock BFF(후니 4모델 1개 stub) + Red fixture 제약. 이 PoC가 §4 4단 게이트를 통과하면 **컨버전 가설 코드 실증 완료** → 나머지 패밀리는 어댑터 매핑 테이블 + 데이터 확장으로 반복.

---

## 6. 산출물·도구

매칭을 누락 없이 기록하는 산출물 형식 + 재사용 방법.

### 6.1 통합 cross-mapping 테이블 (매칭의 단일 기록부)
Phase 1~4 산출을 누적하는 하나의 테이블. 상품(또는 옵션그룹) 1행 = 매칭의 완전한 궤적.

| 열 | 출처 Phase | 내용 |
|----|:----------:|------|
| 후니 상품코드 / 안정 복합키 | P1 | MES CD + `(code[+side/variant])` |
| 패밀리 (F1~F8) | P1 | [RCM §1] 배정 |
| 코드체계 3열 (엑셀한글/DB코드/Red CD) | P1 | M-9 매핑 |
| 옵션 토큰 → componentType → side | P2 | [RCM §0] 16토큰, [DA §3] 매핑 |
| 가격모델 / priceSchemeKey / 단위 / 환산계수 / 수량 shape | P3 | 4모델, M-1·M-2·M-4 |
| disableRules / hidden 그룹 / default / work파생 / 면분기 | P4 | M-5·M-6·M-7·M-8·M-10 |
| **적용 M-x 목록** | 전 Phase | 누락 추적 키 |

### 6.2 매칭 추적 매트릭스 (검증 기록부)
§4.2 형식. 매칭단위별 4단 게이트 PASS/FAIL + 적용 M-x. cross-mapping 테이블이 "무엇을 사상했나"라면 추적 매트릭스는 "검증됐나".

### 6.3 재사용 방법 (미래 세션 플레이북)
후니 위젯 작업(상품 확대, 신규 상품 추가, 특정 패밀리 재매칭) 시:
1. **이 문서(방안) + [RCM] 한 쌍을 먼저 로드.** [RCM]은 46구조 레퍼런스(위젯 완전성 증명), 본 문서는 매칭 절차.
2. 대상 후니 상품을 [RCM §1] 패밀리에 배정([§2 Phase 1]) → 해당 패밀리의 componentType 분해를 [RCM §1] 표에서 그대로 차용.
3. §3 통합 체크리스트의 적용 M-x를 cross-mapping 테이블 행에 기록. **M-1~M-4(최고위험)는 무조건 검토.**
4. §4 4단 게이트로 검증, 추적 매트릭스 갱신.
5. 신규 componentType 의심 시 → [RCM §2.2] "신규 0건" 판정 + [EXP §3] NC-1/2/3 flag 규칙 적용(기본 흡수, 불가피할 때만 flag).
- **stage 단위 진행:** [EXP §1.2] S1(디지털인쇄)→S2→S3→S4→S5→S6 순서로 본 방법론을 패밀리별 반복. 각 stage는 [EXP §5] QA 게이트 통과 후 다음.

### 6.4 도구
- **비교 하네스(4173):** 경계면 교차 QA(§4 게이트 2). 우리 위젯 vs Red 레퍼런스 대조.
- **live-capture 스킬:** S3/S6 등 Red fixture 미보유 상품 라이브 캡처 선행.
- **어댑터 계약 테스트:** 정규화 스키마 일치 게이트(M-3 키 안정성, INV-2 중립).
- **grep 게이트:** 계약 타입에 Red/후니 고유명 0 단언(INV-2).

---

## 7. 요약 (오케스트레이터 반환용)

| 항목 | 값 |
|------|-----|
| 방법론 Phase 수 | **7** (P1 인벤토리 → P2 옵션구조 → P3 가격모델 → P4 제약/hidden → P5 어댑터 직렬화 → P6 round-trip / 단 P5는 1~4 조립, P6은 5 검증) |
| 통합 체크리스트 | 위젯측 10(CHK-1~10) + 후니측 11(CHK-H1~H11) → **13 통합항목(M-1~M-13)** 위험도순(7쌍 짝 병합 + 단독 6) |
| 최고위험 top-3 | **M-1 수량 행 shape 침묵 PRICE=0** · **M-2 가격 단위 불일치(판/장/세트 N배 오류)** · **M-3 코드 무결성+round-trip 키 안정성** |
| 검증 게이트 | 4단(fixture round-trip / 경계면 교차 QA / INV-3 코어 0줄 회귀 / 계약 중립 grep) + 매칭 추적 매트릭스 |
| 임계경로 | **후니 데이터(B1 가격·B2 제약·B3 배송·무결성 보정), 위젯 아님.** 위젯은 Red fixture+mock BFF로 무차단. createHuniAdapter PoC 1상품으로 코드 실증 권장 |
| 산출물 | 통합 cross-mapping 테이블(사상 기록) + 매칭 추적 매트릭스(검증 기록). 재사용 = 본 문서 + [RCM] 한 쌍 |

> **결론:** 위젯은 증명됐다(46구조 신규 componentType 0). 매칭의 본질은 **어댑터 직렬화 정합 + 후니 데이터 결손 보정**이며, 그 위험은 §3 13개 통합항목(특히 M-1~M-4 침묵 0원/N배 오류)에 집약된다. 7-Phase 절차로 사상하고 4단 게이트로 증명하며, 통합 cross-mapping + 추적 매트릭스로 누락을 막는다. 위젯 코드는 0줄 변경된다(INV-3).
</content>
</invoke>
