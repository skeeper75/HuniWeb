# huni-red-matching-methodology.md — 후니 상품마스터/가격 ↔ Red 검증 위젯 매칭 방안 (방안)

> **버전 1.1** (2026-06-03) — 적대적 독립 감사([AUDIT]=methodology-audit.md, 8 findings + 데이터부재 7) 반영 경화.
> 변경 요지: "위젯 0줄/신규 componentType 0" 무조건 단정 → *현 범위(S0~S2) 한정 + S3 NC-1 불가피* 정밀화 / INV-3 측정기준을
> 파일 diff로 구체화(비반증 loophole 제거) / phaseB ≠ 검증 fixture 명시 + PRICE>0 선결 전제 / 체크리스트 M-14~M-16 신설(VAT 혼재·교차상품 할인·쿠폰/재고/MOQ).
> v1.0 골격(7-Phase·M-1~M-13·4 게이트·정직한 데이터부재 flag)은 감사가 "SOUND" 판정 — 구조 유지, 표현만 경화.
>
> 파이프라인 ③ **통합 방법론(방안)**. 두 전문 분석([RCM]=red-coverage-matrix.md 위젯/Red측 / [HDR]=huni-data-readiness.md 후니측)을
> **하나의 실행 가능한 매칭 플레이북**으로 통합한다. 재분석이 아니라 **운영화(operationalize)** — 미래 세션이 이 문서 + [RCM] 한 쌍만 들고
> 후니 상품/가격을 RedPrinting으로 검증된 위젯에 무손실로 끼워 맞추되 **그 과정에서 임계항목을 절대 누락하지 않게** 한다.
> [HARD] 본 문서는 방법론·체크리스트만. `src/` 무수정. 코드 실증은 §5의 PoC 게이트에서만, 별도 핸드오프.
> [HARD] 사용자에게 질문하지 않는다(분석/방법론 산출만).
> 근거 표기: [RCM]=red-coverage-matrix.md / [HDR]=huni-data-readiness.md / [DC]=data-contract.md / [DA]=data-adapter.md /
> [DBMAP]=huni-db-mapping.md / [EXP]=expansion-strategy.md / [XM]=cross-mapping.md(print-quote) / [AUDIT]=methodology-audit.md.
>
> **수렴 사실(두 분석의 합의 기반 — 이 위에서만 움직인다):**
> 1. Red **캡처된** 479상품 = 46 옵션구조 → 위젯의 **현 16-case dispatcher**(DESIGN 14 + 구현된 NC-1 `dimension-matrix-input` + finish-select-box)가 신규 case 없이 라우팅. price_gbn은 위젯에 불투명 echo. → **componentType *라우팅* 한정 완전성 증명**(주의: sig는 disable/hidden/옵션값 의미를 구조적으로 관측 못 함 — §3.0). [RCM §2.2]
> 2. 후니 ~240상품(상품 단위; 옵션행 기준 수백+, §7 카운트 기준 F-8), 4 가격모델(단가 룩업표 — Red 가격모델군과 동형), 옵션구조 ~90% 직접 + 잔여 어댑터 흡수 = 무손실 100% **주장**(검증은 §4 게이트로). **componentType *추가* 신규 0건은 S0~S2 범위 한정** — S3(포스터/배너/실사) 대형포맷 자유치수는 [EXP L137]상 NC-1 발동(이미 구현된 dispatcher case지만 store 가격조립 분기 추가). [HDR §1.3, §2.2][EXP §3]
> 3. **진짜 리스크는 위젯이 아니다.** (a) 어댑터 직렬화 정합(option→PCS_INFO/ORD_INFO 행 shape, hidden-essential, 침묵 PRICE=0), (b) 후니 데이터 결손(제약/disable·가격DB·MES CD 무결성·배송·VAT기준 혼재 미작성), (c) 코드체계 3중 불일치 + 단위/VAT 불일치. [RCM §4, HDR §4, AUDIT F-3]

---

## 1. 목표·원칙·불변식 (한 줄씩)

**목표:** 후니 상품마스터/가격표를 RedPrinting으로 검증된 위젯에 **위젯 코어 재작성 없이**(S0~S2는 코드 0줄, S3~S5는 신규 leaf componentType + dispatcher union + store 조립 분기로 한정된 위젯 코드 추가 — §1 INV-3) 끼워 맞추되, 매칭 과정에서 침묵 오작동(빈 그룹/0원/잘못된 캐스케이드)을 일으키는 임계항목을 하나도 누락하지 않는다.

**원칙 (5):**
- **단일 신뢰경계:** 모든 후니 raw → 정규화 계약 변환은 어댑터(`adapters/huni/`)에서만. 위젯은 어댑터 존재조차 모른다. [DA §0]
- **무손실 컨버전:** Red fixture로 통과한 위젯이 후니 어댑터 출력으로도 동일 동작. 컨버전 = 어댑터+데이터소스 교체, **위젯 코어/계약 0 변경**(componentType *추가*는 S3+에서 발생 가능하나 dispatcher 확장이지 코어 재작성 아님 — INV-3 측정기준 참조). [DA §0]
- **서버 권위 가격:** 위젯은 4 가격모델·단가·할인·VAT·배송 산식을 모른다. 8축 입력만 보내고 불투명 finalPrice/lines[]만 받는다. [DC §3]
- **계약 중립:** 계약 타입에 Red/후니/카테고리 고유 필드명 등장 금지. 모두 id/label/도메인 중립명. [DC §8]
- **단순성 강제:** 매칭은 어댑터 매핑 테이블 + 데이터 채움. 위젯에 상품군 특이 로직 하드코딩 금지, 임의 추상화(팩토리/레지스트리) 금지. [EXP §0]

**불변식 (INV — 깨지면 매칭 실패):**
- **INV-1 서버 권위 가격** — 새 가격모델 = BFF 일, 위젯 0. [DC §3][EXP INV-1]
- **INV-2 정규화 계약 중립** — 후니 고유 필드명 계약 침투 0. [DC §8][EXP INV-2]
- **INV-3 위젯 코어 불변 (측정기준 명시 — 비반증 loophole 차단, AUDIT F-1):** Red fixture 회귀가 후니 어댑터로도 통과 + **다음 경로의 `git diff` 라인 = 0**: `src/widget/{store,cascade,shadow,dispatcher,price-seam,editor-bridge}` + `src/contract/`.
  - **허용(코어 불변 위배 아님):** `ComponentType` union에 멤버 1줄 추가 + 신규 leaf 컴포넌트 *파일* 추가 + dispatcher switch에 case 1개 추가(exhaustive 강제). 단 **NC-1 같은 2D 입력은 store 가격조립부(`dimensions` 채우기)에 분기가 들어가므로** [EXP L68] **store diff ≠ 0이 될 수 있다 → 이는 INV-3 *위배가 아니라 명시적 NC 결정 항목*으로 격상**(아래 게이트).
  - **escape hatch 차단:** 신규 componentType이 필요하면 "확장으로 통과"가 아니라 **명시적 NC 결정 레코드**(어느 stage·어느 디자인시스템 컴포넌트 근거·계약 union/매핑/dispatcher/store 변경 범위 열거)를 §4 게이트가 요구한다. 근거 없는 componentType 추가 = 게이트 FAIL. [DA §0][EXP INV-3, §3]
- **INV-4 Shadow DOM 격리 + Portal** — 호스트 스타일 누수 0, EditorOverlay 최상단. [EXP INV-4]
- **INV-5 componentType 고정 dispatch (현 16-case)** — 현 dispatcher = DESIGN 14 + 구현된 NC-1(`dimension-matrix-input`) + finish-select-box. 신규 추가 시 계약 union + 매핑표 + dispatcher switch 동시 갱신(DESIGN 동기) + INV-3 NC 결정 레코드. 임의 추상화(팩토리/레지스트리) 금지. [EXP INV-5, §3]

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
- **완료기준:** 후니 모든 옵션 차원이 현 16-case(DESIGN 14 + NC-1 + finish-select-box) 중 하나로 사상되고 **추가 신규 componentType 필요 건수가 명시적으로 0 또는 NC 결정 레코드(INV-3)로 flag**된다. **주의:** NC-1(`dimension-matrix-input`)은 dispatcher case로 이미 구현됨 — S3(포스터/배너/실사) 대형포맷 자유치수 진입 시 **store 가격조립 분기 추가**가 동반되므로 [EXP L68] 단순 "사상"이 아니라 **NC 결정 레코드 대상**(어느 stage·디자인시스템 근거·store/dispatcher 변경범위). S0~S2는 이 분기 불요(추가 0). 미사상 옵션 0건.

### Phase 3 — 가격모델 사상 (후니 4모델 → 계약 opaque 슬롯)
- **입력:** 후니 가격표 19시트(4모델 단가 룩업표), [HDR §2] 후니↔Red 가격모델 정합표, [DC §3] NormalizedPriceRequest/Breakdown, [DBMAP §2] QuoteResult 평면화.
- **절차:**
  1. 각 상품군을 4모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount) 중 하나로 분류하고 `priceSchemeKey`(category prefix 001~012 echo)를 정한다. 위젯은 의미 모름(불투명). [HDR §2.2]
  2. **단위 환산 정의(CHK-H2, 최고위험):** 시트별 단가 기준 단위(KRW/판·KRW/장·100장=set·세트)를 상품별 `unit` + 환산계수로 명시. BFF가 "판→장""세트→개" 환산 보유. **누락 시 가격 N배 오류.**
  3. **수량 행 shape 정합(CHK-1/CHK-H6, 최고위험):** tmpl/tiered_price는 ORD_INFO[0]에 **ORD_CNT+PRN_CNT 둘 다** 있어야 PRICE>0. 후니 수량 1컬럼을 어댑터가 양쪽 의미로 어느 게 맞는지 상품군별 확정 + 둘 다 직렬화. **한쪽만 직렬화 시 침묵 0원.**
  4. **폐쇄 래더 vs 자유 counter 분기(CHK-7/CHK-H9):** 후니 수량 정의가 자유범위(min/max/incr)인지 enum 목록인지 상품별 판정 → select-box enum vs counter-input. 임의값=0원 방지.
  5. **VAT 기준 상품별 플래그(M-14, 최고위험 — AUDIT F-3):** 시트별 VAT 기준이 혼재한다 — **실사 마스터는 `price`/`price(vat포함)` 컬럼 인라인 공존**(원천에 VAT 포함가 직접 기재), 타 시트는 VAT 별도. **전 상품 일괄 10/110 분리 금지** — vat포함 시트는 이중차감(침묵 N배 오류). 상품별 `vatBasis: included|excluded` 플래그를 어댑터/BFF가 보유.
  6. **SizeMatrix2D 축 방향 + 외삽셀(M-10 보강 — AUDIT F-7):** 포스터사인 매트릭스는 행=세로/열=가로이며 **비대칭 셀**(600×800 ≠ 800×600) 존재 → 어댑터가 가로↔세로 축 배정을 틀리면 비대칭 셀에서 가격 어긋남. 인라인 외삽셀(`1000x1000:20` 메모형)도 정책 필요. 어댑터에 축 매핑 + 외삽 정책 단언.
  7. QuoteResult(8 axis breakdown) → lines[] 평면화 규약 고정(total→finalPrice, vatAmount→vat, deliveryFee→shipping). [DBMAP §2.2]
- **산출:** cross-mapping 테이블 Phase-3 행(가격모델·priceSchemeKey·단위·환산계수·수량 shape·**vatBasis**·**축방향**).
- **완료기준:** 모든 후니 상품이 (a) 4모델 중 하나로 분류 (b) 단위 환산계수 보유 (c) 수량 ORD_CNT/PRN_CNT 분리 의미 확정 (d) 폐쇄래더/자유 분기 판정 (e) **vatBasis 플래그 확정** (f) SizeMatrix2D 상품은 축방향 확정. **단위·수량분리·VAT기준 미정 상품 0건.**

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
- **입력:** Phase 5 어댑터 출력, **검증용 Red fixture(아래 선결조건 충족분)**, 비교 하네스(4173).
- **[HARD] fixture 선결조건 — phaseB ≠ 검증 fixture (AUDIT F-2):** `red-coverage-phaseB.json`은 **price_gbn 구조 프로브**(첫 규격+수량만 선택)이지 **가격 검증 fixture가 아니다**. phaseB 46 대표 중 **11건이 hadPriceCall=true·status=200인데 PRICE=0**이며, 여기에 **최대 패밀리 2개(BCSPDFT 명함 153 + PRPOSTK 포스터 36 = 189상품 ≈ 카탈로그 40%)가 포함**된다. 이는 캡처 결함이 아니라 **digital_price류가 inkType/면/옵션 등 필수필드 미충족 시 0**이기 때문(명함은 실제 가격 존재). → **검증 fixture는 전 필수필드 충족 + 로그인 세션으로 별도 라이브 재캡처(live-capture)해야 PRICE>0**. M-1(PRICE>0 단언)은 이 보강 fixture 위에서만 실행 가능.
- **절차:**
  1. **fixture round-trip:** 후니값 → 어댑터 → 정규화 계약 → 위젯 렌더 → 가격요청 조립 → (mock BFF) → finalPrice 표시까지 전 경로 1상품씩 통과. **단언 전 선결: 해당 fixture가 source에서 PRICE>0**(phaseB price=0 패밀리는 보강 캡처 완료 전 M-1 assert 불가 — 공허 통과 방지).
  2. **불투명 id round-trip:** 옵션 selected id가 가격요청에서 그대로 echo되어 매칭 성공하는지(키 흔들림 0).
  3. **위젯 회귀(INV-3):** Red fixture(PRBKYPR S0 등)가 후니 어댑터 도입 후에도 동일 통과 + INV-3 측정기준(§1) `git diff` 라인 0(또는 NC 결정 레코드로 정당화된 증분만).
- **산출:** §4 매칭 추적 매트릭스(상품/가격 단위 PASS/FAIL + fixture PRICE 상태).
- **완료기준:** §4 검증 게이트 전항 통과. **fixture PRICE=0 상태 패밀리는 "보강 캡처 필요" 플래그가 명시되고 M-1 assert가 보류**(미보강 상태로 PASS 처리 금지).

> **Phase 의존성:** Phase 1(키) → 2(구조) → 3(가격) → 4(제약)는 순차. Phase 5(어댑터)는 1~4 산출을 조립. Phase 6은 5를 검증.
> 단 **Phase 2·3·4는 Red fixture 기반으로 후니 실데이터 없이 선행 가능**(임계경로 분리, §5).

---

## 3. 통합 간과 방지 체크리스트 (위젯측 10 + 후니측 11 → 위험도순 통합)

[RCM §4](CHK-1~10) + [HDR §4](CHK-H1~H11)를 **하나의 우선순위 리스트**로 병합한다. 두 분석이 이미 7쌍의 짝 매핑([HDR §4 말미])을 제공하므로, 짝은 **하나의 통합항목(M-x)**으로 합치고, 단독 항목은 그대로 둔다. **최고위험(침묵 PRICE=0 = 수량 단일컬럼/행 shape, 코드중복, 단위/VAT 불일치)을 top에** 둔다.
각 항목: **무엇을 / 왜(누락 시 증상) / 어떻게 확인 / 책임경계(대부분 어댑터·데이터; componentType 추가 항목만 위젯 코드 — INV-3 NC 결정).**

### 3.0 [HARD] 46-sig 완전성의 범위 한정 (AUDIT F-5 — 안도감 함정 차단)
[RCM] "46구조 = 신규 componentType 0 흡수"는 **componentType *라우팅* 한정으로만 참**이고, 정당하다(토큰→입력위젯 매핑은 실제로 닫힘). **그러나 sig는 disable/cascade/옵션값/hidden/VIEW_YN을 구조적으로 관측하지 못한다** — scan 레코드 키에 해당 필드가 아예 없고, 동일 sig 안에서 의미가 다른 후가공(예: white-mode vs COT_DFT)이 r1 하나로 붕괴되며, 46 sig 중 22개가 singleton(n=1)이라 중복검증도 불가하다. **따라서 "46구조 흡수"가 캐스케이드·옵션값 정합까지 보증한다는 안도감은 거짓**이다. disable/hidden/옵션값 의미 정합은 sig 무관측 → **M-5/M-6/M-9 + 후니 데이터로만 보증**된다(§4 게이트 2의 후니 어댑터 단계). [AUDIT F-5]

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

### 🆕 감사 보강 신설 항목 (AUDIT F-3/F-4 — 기존 체크리스트 카테고리 공백)

**M-14 [신설, 🔴 최고위험] VAT 기준 상품별 혼재 (이중차감 침묵 N배 오류)**
- **무엇:** 시트별 VAT 기준 혼재 — 실사 마스터는 `price`/`price(vat포함)` 인라인 공존(VAT 포함가 원천 기재), 타 시트는 VAT 별도. 가격표 19시트 '부가세/VAT' 키워드 매칭 0(대부분 별도).
- **왜:** 어댑터/BFF가 전 상품 일괄 10/110 분리 시 **이미 vat포함인 실사 상품은 VAT 이중차감** → finalPrice 틀어짐(위젯 불투명이라 침묵 통과).
- **어떻게:** 상품별 `vatBasis: included|excluded` 플래그를 어댑터/BFF 보유. vat포함 시트는 **분리 금지** 규칙. round-trip에서 알려진 상품 finalPrice 기대치 일치 단언(M-2와 동급 게이트).
- **책임:** 어댑터/BFF + 후니 데이터(Phase 3). [AUDIT F-3, D-PM-15]

**M-15 [신설, 🟠 고위험] 교차상품 합산할인 vs 단일견적 계약 충돌**
- **무엇:** 굿즈파우치 TieredDiscount는 **"파우치+에코백 전체"** 합산 할인 — 상품 경계를 넘는 할인 스코프.
- **왜:** 현 계약은 단일상품 견적([DBMAP §3.1 G9 단일상품 가정])이라 교차상품 합산할인을 표현 못 함 → 할인율 오적용 또는 미적용.
- **어떻게:** 교차상품 할인이 **위젯 단일견적 범위 밖**임을 명시(BFF 장바구니 합산 단계로 위임) 또는 단일상품 내 수량할인으로 근사. 범위 결정 후 cross-mapping에 기록. **현 계약 미스코프 후보로 flag.**
- **책임:** 계약 범위 결정 + BFF(Phase 3). [AUDIT F-4, DBMAP G9]

**M-16 [신설, 🟡 중위험 — 데이터부재] 쿠폰/재고/품절/MOQ/최소주문수량**
- **무엇:** 현 체크리스트 0회 언급. 봉투(`봉투제작` 시트: 봉투타입×소재×수량)·합판도무송(임포지션 단가)은 4모델 흡수 가능성 있으나 체크리스트 미매핑 → 누락추적 키 공백.
- **왜:** 쿠폰/적립/재고/품절/MOQ/i18n은 **source 데이터 자체 부재**(범위 밖 미결, §데이터부재). 봉투/합판은 매핑 미명시 시 §6.1 적용 M-x 비어 누락방지 메커니즘이 이 군에서 미작동.
- **어떻게:** (a) 봉투/합판/대형포맷마감 = cross-mapping에 "적용 M-x 미정 → 보강대상" 명시. (b) 쿠폰/재고/MOQ = **범위 밖(out-of-scope) 명시 flag**(데이터 부재로 현 단계 비검증, 커머스 확정 시 재검토). 가짜 검증 금지.
- **책임:** 어댑터/데이터 + 범위 결정(Phase 1·2). [AUDIT F-4, R-g]

> **체크리스트 사용법:** Phase 1~6 진행 중 각 항목의 책임경계(괄호 Phase)에서 해당 M-x를 확인. 통합 cross-mapping 테이블(§6)의 각 행에 적용 M-x ID를 기록하여 **누락 추적**(봉투/합판/대형포맷 행은 적용 M-x 미정 시 "보강대상" 명시 — M-16). **최고위험 M-1·M-2·M-3·M-4·M-14**는 round-trip(Phase 6)에서 **반드시 단언(assert) 테스트**로 게이트 — 단 M-1·M-14의 가격 기대치 단언은 **fixture PRICE>0 선결조건(§Phase 6) + 후니 실가격 데이터**가 있어야 실행 가능(데이터부재 시 게이트 보류로 명시, 공허 PASS 금지).

---

## 4. 검증 게이트 + 추적성

각 후니 상품/가격이 위젯에서 올바로 동작함을 어떻게 증명하나. **증거 없는 "맞을 것" 금지(INV verify).**

### 4.1 검증 게이트 (4단)
1. **fixture round-trip** (상품 단위): 후니값 → 어댑터 → 정규화 계약 → 위젯 렌더 → 가격요청 조립 → mock BFF → finalPrice. **PRICE>0 단언**(M-1), **알려진 수량의 finalPrice 기대치 일치 단언**(M-2).
2. **경계면 교차 QA** (비교 하네스 4173): 동일 옵션 선택 시 정규화 요청 페이로드가 Red와 **동등한 의미**(불투명 id round-trip 일치). 캐스케이드 disable 집합 일치. componentType DESIGN 8 Critical Rules 준수.
   - **한계:** 후니 가격은 Red와 별개 공식 → 가격 *수치* 일치는 Red 어댑터 단계만. 후니 어댑터 단계는 "정규화 스키마 일치 + BFF 4모델 결과 합리성"으로 전환. [EXP §5.2]
3. **INV-3 위젯 코어 불변(측정기준 명시):** Red fixture(PRBKYPR S0 등) 회귀가 후니 어댑터 도입 후에도 통과 + **`git diff` 라인 = 0** on `src/widget/{store,cascade,shadow,dispatcher,price-seam,editor-bridge}` + `src/contract/`. 빌드/타입/테스트 green(tsc noEmit, vitest, dispatcher exhaustive). **단 NC 결정 레코드(아래 게이트 5)로 정당화된 증분(union 1줄·leaf 파일·store 조립 분기)은 위배 아님.**
4. **계약 중립(INV-2):** 계약 타입에 Red/후니 고유명 0(grep 게이트).
5. **NC 결정 게이트(신규 componentType 발생 시 — AUDIT F-1):** componentType 추가가 필요하면 "확장으로 통과" 금지 → **NC 결정 레코드 필수**: (a) 어느 stage (b) 어느 디자인시스템 컴포넌트 근거 (c) 계약 union/매핑표/dispatcher/store 변경 범위 열거. 근거 없는 추가 = FAIL. S3 NC-1(`dimension-matrix-input` + store 가격조립 분기)이 대표 사례 — [EXP L137]상 불가피하므로 S3 진입 시 레코드 작성. S0~S2는 해당 없음(증분 0).

### 4.2 매칭 추적 매트릭스 (형식 제안)
매칭 단위(상품 또는 가격모델)별 1행. 미래 세션이 "어디까지 검증됐나"를 한눈에.

| 매칭단위 | 패밀리 | componentType 사상 | 가격모델 | 적용 M-x | fixture PRICE | round-trip | 교차QA | INV-3/NC | 상태 |
|---------|--------|---------------------|----------|----------|:-------------:|:----------:|:------:|:--------:|------|
| 후니 프리미엄명함(003) | F1 | size·paper·dosu·finish·qty | PriceTable3D | M-1,M-2,M-3,M-7,M-14 | **phaseB=0 → 보강캡처 필요** | (보강 전 M-1 보류) | PASS/FAIL | diff 0 | ⬜ |
| 후니 포스터(004) | F1/F3 | dimension-matrix·material·qty | SizeMatrix2D | M-1,M-10,M-14 | **phaseB=0(PRPOSTK) → 보강** | 보류 | … | **NC-1 레코드(S3)** | ⬜ |
| 후니 아크릴키링(009) | F2 | size·material·dosu·addon·qty | SizeMatrix2D+Tiered | M-1,M-8,M-11,M-15 | 확인 필요 | … | … | diff 0 | ⬜ |
| 후니 굿즈파우치(010/011) | F5 | type·color·qty | TieredDiscount | M-1,M-3,M-4,M-15 | 확인 필요 | … | … | diff 0 | ⬜ |

- **상태 정의:** 게이트 전부 PASS = ✅. 하나라도 미통과 = ⬜ + FAIL 사유. **fixture PRICE=0 패밀리는 보강 캡처 전 M-1/M-14 assert 보류**(공허 PASS 금지, §Phase 6).
- **누락 방지:** 적용 M-x 열이 비어있으면 체크리스트 미적용 = 검증 불완전. 최고위험 M-1~M-4·M-14가 적용 목록에 없으면 round-trip 게이트 자동 FAIL.
- **NC열:** componentType 증분이 있으면 NC 결정 레코드 ID 기재(예: S3 포스터=NC-1). 증분 없으면 `diff 0`.

---

## 5. 단계화·우선순위·의존성

### 5.1 임계경로 = 후니 데이터(주) + 위젯 코드(S3+ 한정) (핵심 인식 — 범위 정밀화 AUDIT F-6)
**현 stage(S0~S2) 한정 위젯 무차단**이 사실이다. 그러나 "전 범위 0% 차단"은 거짓 — **S3~S5는 신규 componentType + store 가격조립 분기로 위젯 코드 작업이 발생**(차단). 임계경로는 (주) 후니 데이터 작성/보정 + (S3+) 위젯 코드 작업이다. [HDR §0, DBMAP §8, EXP L68, AUDIT F-6]

| 구분 | 항목 | 데이터 소스 | 임계경로? |
|------|------|------------|:---------:|
| **위젯 무차단 (S0~S2 NOW 진행)** | NormalizedProduct·옵션차원·현 16-case componentType·캐스케이드 UI 셸·가격표시 UI | 후니 상품마스터(✅) + Red fixture + mock BFF | No |
| **위젯 코드 작업 (S3~S5)** | NC-1 store 가격조립 분기(S3) + NC 결정 레코드 + 디자인시스템 시각 확정 | [EXP §3], 디자인시스템 | **Yes(stage별)** |
| **후니 작성 대기 (최종통합 임계경로)** | B1 가격(엑셀 4모델→BFF) · B2 제약(disable/excl/visible) · B3 배송정책 · B4 VAT기준 플래그 · M-1·M-2·M-3·M-14 무결성/단위/수량/VAT 보정 | 후니 엑셀→DB, 운영자 인터뷰 | **Yes** |

### 5.2 우선순위 (무엇부터)
- **우선순위 High:** Phase 1(인벤토리 키 안정성) + M-1·M-2·M-3 보정 설계. 키·단위·수량이 흔들리면 이후 전부 무효.
- **우선순위 High:** createHuniAdapter **PoC 1개**(예: S1 디지털인쇄 프리미엄명함 또는 굿즈파우치 1상품)로 Phase 1~6 전 경로를 **코드로 실증** — 키스톤 가설(어댑터 교체=위젯 0변경)을 1상품으로 증명. [EXP §7 S1 착수와 정합]
- **우선순위 Medium:** Phase 2~4를 Red fixture 기반으로 패밀리별 일괄 사상(후니 실데이터 없이 선행).
- **우선순위 Low:** B1·B2·B3 후니 작성 완료 후 어댑터 가격/제약 arm을 mock→실 교체(최종통합).

### 5.3 Red fixture 무차단 vs 후니 실데이터 필요 지점 (명확 구분)
- **Red fixture로 무차단 진행:** 옵션구조 사상(Phase 2), componentType 라우팅, 캐스케이드 엔진 검증(Phase 4 disable/hidden 엔진), 가격표시 UI(mock BFF), 위젯 회귀(INV-3). **S3/S6는 Red fixture 미보유 + phaseB price=0 패밀리(명함/포스터)는 검증 fixture 보강 캡처 필요 → live-capture 선행이 그 stage 임계경로** [EXP §6.3, AUDIT F-2].
- **후니 실데이터 필수 (게이트가 데이터-차단임을 명시 — AUDIT R-e):** M-1·M-2·M-14의 **가격 기대치 단언은 후니 실가격 부재 시 산출 불가** → 해당 게이트는 "실행 가능"이 아니라 **데이터 도착 전 보류**(공허 PASS 금지). 그 외 데이터 의존: disable 규칙 population(M-5), 용지 N:M 부분집합(M-7), 면별/세트 모델링(M-8), 단위 환산계수(M-2), VAT기준 플래그(M-14), 코드 보정(M-3).

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
| 가격모델 / priceSchemeKey / 단위 / 환산계수 / 수량 shape / **vatBasis** / **축방향** | P3 | 4모델, M-1·M-2·M-4·M-14·M-10 |
| disableRules / hidden 그룹 / default / work파생 / 면분기 | P4 | M-5·M-6·M-7·M-8·M-10 |
| **적용 M-x 목록** | 전 Phase | 누락 추적 키 — **비어있으면(봉투/합판/대형포맷마감 등) "보강대상" 명시(M-16)** |
| **NC 결정 / fixture PRICE 상태** | P2·P6 | componentType 증분 레코드 ID + phaseB price=0 여부 |

> **[HARD] 누락추적 메커니즘 보강(AUDIT F-4):** 봉투제작·합판도무송·대형포맷마감·교차상품할인 행은 4모델 흡수 가능성이 있어도 **적용 M-x가 자동으로 채워지지 않는다** → 해당 행은 반드시 "적용 M-x 미정 → 보강대상(M-16)" 또는 "범위 밖(쿠폰/재고/MOQ)"으로 명시. 빈칸 방치 시 방법론 자신의 누락방지가 이 군에서 미작동.

### 6.2 매칭 추적 매트릭스 (검증 기록부)
§4.2 형식. 매칭단위별 4단 게이트 PASS/FAIL + 적용 M-x. cross-mapping 테이블이 "무엇을 사상했나"라면 추적 매트릭스는 "검증됐나".

### 6.3 재사용 방법 (미래 세션 플레이북)
후니 위젯 작업(상품 확대, 신규 상품 추가, 특정 패밀리 재매칭) 시:
1. **이 문서(방안) + [RCM] 한 쌍을 먼저 로드.** [RCM]은 46구조 레퍼런스(위젯 완전성 증명), 본 문서는 매칭 절차.
2. 대상 후니 상품을 [RCM §1] 패밀리에 배정([§2 Phase 1]) → 해당 패밀리의 componentType 분해를 [RCM §1] 표에서 그대로 차용.
3. §3 통합 체크리스트의 적용 M-x를 cross-mapping 테이블 행에 기록. **M-1~M-4(최고위험)는 무조건 검토.**
4. §4 4단 게이트로 검증, 추적 매트릭스 갱신.
5. 신규 componentType 의심 시 → [RCM §2.2] 현 16-case 라우팅 흡수 여부 판정 + [EXP §3] NC-1/2/3 규칙 적용(기본 흡수, 불가피할 때만 **§4 게이트 5 NC 결정 레코드 작성** — "확장으로 통과" 금지). 대형포맷 자유치수(S3)는 NC-1 + store 분기 불가피이므로 레코드 대상.
- **stage 단위 진행:** [EXP §1.2] S1(디지털인쇄)→S2→S3→S4→S5→S6 순서로 본 방법론을 패밀리별 반복. 각 stage는 [EXP §5] QA 게이트 통과 후 다음.

### 6.4 도구
- **비교 하네스(4173):** 경계면 교차 QA(§4 게이트 2). 우리 위젯 vs Red 레퍼런스 대조.
- **live-capture 스킬:** S3/S6 등 Red fixture 미보유 상품 + **phaseB price=0 패밀리(명함 BCSPDFT·포스터 PRPOSTK 등 9건) 검증 fixture 보강 캡처**(전 필수필드 충족 + 로그인 세션) 선행. [AUDIT F-2]
- **어댑터 계약 테스트:** 정규화 스키마 일치 게이트(M-3 키 안정성, INV-2 중립).
- **grep 게이트:** 계약 타입에 Red/후니 고유명 0 단언(INV-2) + INV-3 `git diff` 라인 0 측정.

---

## 7. 요약 (오케스트레이터 반환용)

| 항목 | 값 |
|------|-----|
| 방법론 Phase 수 | **7** (P1 인벤토리 → P2 옵션구조 → P3 가격모델 → P4 제약/hidden → P5 어댑터 직렬화 → P6 round-trip / 단 P5는 1~4 조립, P6은 5 검증) |
| 통합 체크리스트 | 위젯측 10(CHK-1~10) + 후니측 11(CHK-H1~H11) → **13 통합항목(M-1~M-13)** + **감사 보강 3종(M-14 VAT혼재·M-15 교차상품할인·M-16 쿠폰/재고/MOQ·봉투/합판)** = **16 항목** 위험도순 |
| 최고위험 top-3 | **M-1 수량 행 shape 침묵 PRICE=0** · **M-2 가격 단위 불일치(판/장/세트 N배 오류)** · **M-3 코드 무결성+round-trip 키 안정성** (+ M-14 VAT 이중차감 동급 추가) |
| 검증 게이트 | 5단(fixture round-trip / 경계면 교차 QA / INV-3 코어 `git diff` 0 회귀 / 계약 중립 grep / **NC 결정 레코드**) + 매칭 추적 매트릭스. **phaseB ≠ 검증 fixture — PRICE>0 선결조건 + 데이터-차단 게이트는 보류** |
| 임계경로 | **(주) 후니 데이터(B1 가격·B2 제약·B3 배송·B4 VAT기준·무결성 보정) + (S3+) 위젯 코드(NC-1 store 분기).** S0~S2 위젯 무차단; S3~S5 위젯 코드 작업 발생. createHuniAdapter PoC 1상품으로 코드 실증 권장 |
| 산출물 | 통합 cross-mapping 테이블(사상 기록, vatBasis·축방향·NC열 포함) + 매칭 추적 매트릭스(검증 기록, fixture PRICE 상태). 재사용 = 본 문서 + [RCM] 한 쌍 |
| 카운트 기준(F-8) | "~240"은 **상품 단위**. 옵션 granularity는 **행 단위 수백+**(디지털134·실사101·굿즈파우치164 등 비-빈 행 ≈ 681 느슨 추정) — 매핑 공수는 행 단위로 추정 |

> **결론(v1.1 경화):** 위젯은 **componentType 라우팅 한정으로** 증명됐다(현 16-case dispatcher가 Red 46구조를 신규 case 없이 흡수). 단 이는 disable/hidden/옵션값 정합까지 보증하지 않으며(§3.0), **후니 전체 범위에서 S3 NC-1 + store 가격조립 분기는 불가피**하다 — "위젯 0줄"은 S0~S2 한정 참이고, INV-3은 *코어 재작성 없음*이지 *증분 0*이 아니다(측정기준=`git diff` 라인 0 on 코어경로, NC 결정 레코드로 정당화된 증분만 허용). 매칭의 본질은 **어댑터 직렬화 정합 + 후니 데이터 결손 보정**이며, 그 위험은 §3 16개 통합항목(특히 M-1·M-2·M-3·M-4·M-14 침묵 0원/N배오류/이중차감)에 집약된다. 7-Phase로 사상하고 5단 게이트로 증명하되 **phaseB는 검증 fixture가 아니므로 PRICE>0 보강 캡처가 선결**이고 가격 기대치 게이트는 후니 실데이터 부재 시 **보류(공허 PASS 금지)**한다. 통합 cross-mapping + 추적 매트릭스로 누락을 막는다.
