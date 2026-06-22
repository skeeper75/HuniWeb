# engine-design-photobook.md — 포토북(반제품 세트·부품합산형+페이지 선형) 가격엔진 설계

> **핵심 설계가(hpe-engine-designer) 10번째 종단 — §18 directive "반제품 세트상품"의 두 번째 본격 설계(책자 5번째 다음).**
> 디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치]·문구[고정가+매트릭스]·책자[부품합산세트]·굿즈/파우치[inline고정가]·스티커[이산siz단가형+세트]·상품악세사리[inline고정가]·캘린더[원자합산] GO 다음.
>
> cartographer 지도(`formula-map-photobook.md`·`component-inventory-photobook.md`·`gap-board-photobook.md`·`inline-authority-evidence.md`)
> + benchmark 흡수(`competitor-pricing-models-photobook.md`·`absorption-candidates-photobook.md` C-PB1~7·`set-pricing-patterns-photobook.md` P-9)를 종합해,
> 포토북 **세트 부모(PRD_000100) 부품합산형 + 페이지 선형 증분** 가격공식+구성요소+단가행 그릇+세트 조합을
> 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — 데이터 그릇/배선/바인딩 명세.**
>
> 권위[HARD]: ① 상품마스터(260610) `포토북(가격포함)` 시트(inline `가격_기본(24P)`+`가격_추가(2P)당`·row17 명문 산식 `상품단가+페이지당단가적용`) > ② 인쇄상품 가격표(260527 — **포토북 전용시트 부재**·제본/디지털인쇄 시트가 부품 단가 보조) > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학(후보).
> 산출자: hpe-engine-designer · **라이브 읽기전용 SELECT 실측 2026-06-22**(아래 §0.1) · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털·아크릴·실사·문구·책자·굿즈·스티커·악세사리·캘린더 GO 설계와 동일 컨벤션·동일 engine-contract(pricing.py).

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나

### 0.1 라이브 freshness 실측 (2026-06-22·읽기전용 SELECT·본 세션 직접 확인)

| 엔티티 | 실측 | 비고 |
|--------|------|------|
| **포토북 공식**(frm_cd ILIKE %PHOTOBOOK%) | **0행** | ❌ G-PB-1 WIRE 확정(PRF_PHOTOCARD_FIXED=다른 상품) |
| **부모 100 공식 바인딩**(`t_prd_product_price_formulas`) | **0행** | ❌ G-PB-2 WIRE 확정 |
| **부모 100 product_prices** | **0행** | ✅ 공식기반이라 정상(선점 위험 0·G-PB-PRODPRICE 자동충족) |
| **세트 그릇**(`t_prd_product_sets` 100) | **7행 실재**(reg_dt 2026-06-03) | ✅ 구성(BOM)만 적재 |
| **page_rule**(100) | **24/150/2** | ✅ 입력 차원 실재(하드커버 기준) |
| **COMP_BIND_PUR** | **8행**·prc_typ=`.01`·use_dims=`[proc_cd,min_qty,proc_grp:PROC_000017]`·proc_cd=PROC_000020 | ✅ 재사용(5000~1500/부·verbatim) |
| **COMP_PAPER 몽블랑130**(MAT_000105·SIZ_499) | **77.03/판** | ✅ 내지 용지비 재사용 |
| **COMP_PAPER 아트250**(MAT_000081·SIZ_499) | **77.75/판** | ✅ 표지 용지비 재사용 — **cartographer "아트250 0행"은 stale·실재**(G-PB-3 부분해소) |
| **COMP_COAT_MATTE**(무광코팅비) | **실재**·prc_typ=`.01` | ✅ 표지 무광코팅 — **Q-PB-COAT comp 소스 해소**(신규 mint 불요) |
| **표지 자재** MAT_000005/006/007 | 하드커버/레더하드커버/소프트커버 | ✅ benchmark C-PB2 표지타입=mat_cd 확인·★레더(106)는 별 mat(아래 §3.4) |
| **세트 sub_prd** 102~107 | 102 하드/103 아트250+무광/104 면지그레이/105 레더하드/106 레더/107 소프트 | ✅ 표지 6 variant + 면지 택1 |

★ **핵심 정정 2건(라이브 본 세션 실측이 cartographer/benchmark stale 갱신)**:
1. **아트250 용지 단가행 실재**(MAT_000081=77.75) — gap-board G-PB-3 "0행"은 stale·부분 해소. 표지 용지비=COMP_PAPER 재사용.
2. **COMP_COAT_MATTE 실재** — Q-PB-COAT "코팅 comp 탐색 필요"는 해소. 표지 무광코팅비=COMP_COAT_MATTE 재사용(신규 mint 0). **단 단가행 충전 여부는 검증가 E1 재확인**(comp 존재≠단가행 충전).

### 0.2 ★포토북 = 캘린더와 정반대 (inline 공식화 가능 vs 정찰가 BLOCKED)

| 축 | 디자인캘린더(9번째 종단) | 포토북(10번째) |
|----|--------------------------|----------------|
| 산식 명문 | **없음**(정찰가 스냅샷) | **있음**(row17 `상품단가+페이지당단가적용`·verbatim) |
| inline 분해 | 유효판수 비정수(1.31/0.49/…) → 재현 불가 | base24=variant 고정 상품단가·per2p=cost-driven 선형 → **공식화 가능** |
| 판정 | **(나) 정찰가 → BLOCKED**(추측 INSERT 금지) | **(가) 공식화 — base24+per2p 시트 명시값 권위** |

★ **결정적 분기 기준[HARD·Q-CAL-GOLDEN 결판 §design-decisions]**: **inline 가격이 단가행 산식으로 정수·일관 재현되면 공식화(FORMULA), 안 되면(정찰가 스냅샷) inline 권위·추측 INSERT 금지·BLOCKED.** 캘린더 inline=비정수해→BLOCKED·포토북 inline=시트 명문 산식+per2p cost-driven→공식화. 두 "가격포함" 시트가 결정적으로 갈린다.

### 0.3 핵심 작업 4묶음 (gap-board G-PB-1~PAGE 매핑)

| # | 작업 | 갭 | 우선 | 본 설계 § |
|---|------|----|----|-----------|
| **W1** PRF_PHOTOBOOK_SUM 공식 신설 + 배선 | base24 comp + per2p comp + (표지/내지/제본/면지 부품 분해는 base24에 묶임) | G-PB-1 | 🔴 1 | §2·§3 |
| **W2** 부모 100 바인딩 | 세트 부모 PRD_000100 → PRF_PHOTOBOOK_SUM | G-PB-2 | 🔴 1 | §5 |
| **W3** base24/per2p 단가행 충전 | base24=variant 고정값(siz×표지)·per2p=siz_cd·**verbatim** | G-PB-4 | 🔴 2 | §3·§4 |
| **W4** 세트 sub_prd=BOM 가드 | 102~107 가격 비기여(이중계상) | G-PB-SET | ⚠ | §6 |

**∴ 포토북 설계 핵심 3가지:**
1. **부품합산 세트형 + 페이지 선형** — 표지/내지/제본/면지 부품을 **base24(상품단가)에 묶고**(internalize·benchmark P-9a), 외부=base24 + per2p×페이지증분(책자 full 분해와 결정적 차이).
2. **base24=공식 base comp(고정값·variant별)·per2p=페이지 차원 comp(siz_cd만·앱 증분곱)** — product_prices INSERT 금지(G-PB-PRODPRICE).
3. **★돈크리티컬 해소(라이브 결판)**: 제본비 PUR `.01` 단가형=부당가 정당(책자 DB-3 동형)·per2p는 단가형 ×증분횟수(앱계산)·페이지 곱 누락=내지비 소실(G-PB-PAGE).

---

## 1. 계산방식 분류 — 부품합산 세트형 + 페이지 선형 (frm_typ 미참조)

| 계산방식 | 정의 | 엔진 처리(engine-contract·pricing.py) |
|---------|------|---------------------------------------|
| **부품합산 세트형 + 페이지 선형** | 판매가 = base24[siz_cd,mat_cd(표지)] + ceil((N−base_min)/2) × per2p[siz_cd] (× 부수) | **FORMULA 경로**(:320-326)·합산형 comp Σ(addtn_yn=Y)·base comp + 페이지 comp 2배선 |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·`pricing.py:8`·라이브 frm_typ_cd 컬럼 부재). "부품합산"·"페이지 선형"은 **별 엔진 분기가 아니라 어느 comp 집합을 한 공식에 배선하느냐의 차이**(디지털·캘린더·책자 §1 동형).

★ **책자(B)와 포토북의 결정적 차이 (benchmark P-9a)**:
- **책자(B·하드커버 072)**: 표지비 + 내지비 + 제본비를 **각자 별 comp로 외부 합산**(full 분해·표지 단가/내지 단가/제본 단가 권위가 각자 시트).
- **포토북(100)**: 표지/내지/제본/면지를 **base24 상품단가에 묶음**(internalize·외부=base24 + per2p). 권위 가격표가 **완제 base24 통합단가**를 줌(부품 단가 미제공) → 부품 분해 금지·base24 통째.

★ **공식화 가능 vs 정찰가 분기[HARD]**: 포토북 base24/per2p가 **시트 명시값**(권위 verbatim)이고 per2p가 imposition cost-driven(§4)이라 **추측 INSERT 아님**(캘린더 정찰가와 정반대). 단가행 값=상품마스터 verbatim·날조 0.

---

## 2. ★price_formulas — PRF_PHOTOBOOK_SUM (공식 1 신설·search-before-mint)

### 2.1 공식 설계

| frm_cd | 후니 레거시 용어(comp_nm 컨벤션) | frm_typ | 비고 |
|--------|--------------------------------|---------|------|
| **PRF_PHOTOBOOK_SUM** | 포토북 가격(상품단가+페이지당단가) | 합산형(frm_typ 미참조·comp Σ) | base24 comp + per2p comp 2배선·부모 PRD_000100 바인딩 |

★ **search-before-mint (공식 신설 정당성)**:
- 책자 PRF_BIND_SUM 공유 검토 → **부결**(comp 집합 상이): 책자=제본비+표지+내지 full 분해 comp Σ / 포토북=base24(묶음)+per2p 2 comp. comp 집합이 근본적으로 달라 공유 시 `_combo_key` 충돌·misfire → **PRF_PHOTOBOOK_SUM 전용 공식 신설이 무손실**(디지털 D-1 명함 variant 전용 PRF·캘린더 PRF_CAL_* 동형). 채번=MAX+1·separator `_`.
- 신규 mint = **공식 1(PRF_PHOTOBOOK_SUM)뿐**. comp는 base/per2p 2개 신설(아래 §3 search-before-mint)·인쇄/용지/제본/코팅 comp는 전부 재사용(base24에 묶여 직접 배선 안 함).

### 2.2 formula_components 배선

```
PRF_PHOTOBOOK_SUM (합산형·addtn_yn='Y' Σ)
  disp_seq 1: COMP_PHOTOBOOK_BASE   use_dims=[siz_cd, mat_cd]   ← base24 상품단가(variant 고정·표지×사이즈 2차원)
  disp_seq 2: COMP_PHOTOBOOK_PAGE   use_dims=[siz_cd]           ← per2p 페이지당단가(사이즈만·앱 증분횟수 곱)
```

★ **2 comp 차원 분리가 핵심[HARD·benchmark C-PB4]**:
- **base24 comp = `[siz_cd, mat_cd]` 2차원** — 표지타입(mat_cd)이 base를 가름(8x8 하드 15,000 vs 레더하드 23,000 vs 소프트 12,000).
- **per2p comp = `[siz_cd]` 1차원만** — 표지 무관(8x8 전 표지 500·A4 전 표지 600). **per2p에 mat_cd 차원 넣으면 단가행 중복·오청구(돈크리티컬·C-PB4 가드).**
- 두 comp는 **서로 다른 comp_cd**라 `match_component` 내부에서 안 만남 → ERR_AMBIGUOUS 불가. base24는 mat_cd 판별차원 보유·per2p는 siz_cd만 → `_combo_key` 다름 → silent 이중합산 없음(각자 1행 매칭·합산).

---

## 3. ★price_components — base24·per2p comp (search-before-mint·신규 comp 2)

### 3.1 신규 comp 2 (base/per2p)

| comp_cd | comp_nm(레거시 용어) | prc_typ | use_dims | 신규 사유 |
|---------|----------------------|---------|----------|-----------|
| **COMP_PHOTOBOOK_BASE** | 포토북 기본가(24P·표지×사이즈) | PRICE_TYPE.01 단가형 | `[siz_cd, mat_cd]` | base24=완제 상품단가(부품 묶음)·기존 comp 무손실 표현 불가(아래 §3.3) |
| **COMP_PHOTOBOOK_PAGE** | 포토북 페이지당단가(2P당·사이즈) | PRICE_TYPE.01 단가형 | `[siz_cd]` | per2p=페이지 증분 단가·기존 comp 부재 |

★ **prc_typ = .01 단가형 [HARD·돈크리티컬]**:
- **base24 = 완제 상품단가** — `subtotal = unit_price × qty`(:191-192)·qty=부수. 1부 주문 시 base24 그대로(×1)·N부 시 base24×N(부당 base24가 옳음). min_qty=1 충전(×1 정합).
- **per2p = 페이지당단가** — `subtotal = unit_price × qty`. 단 **qty에 페이지증분횟수가 곱해져야 함**(앱 주입·§4)·min_qty=1.
- **합가형(.02) 절대 금지**(÷min_qty 붕괴·G-PB-BIND01 동형). base24·per2p 둘 다 단가형. min_qty NULL 금지(ValueError 가드).

### 3.2 base24 부품이 base comp에 묶이는 근거 (benchmark P-9a·DT-BIND-SCOPE 결판)

> **질문**: 포토북 가격 = "표지+내지+제본+면지 full 분해 합산"(책자형) vs "base24 통합 + 페이지증분"?
> **결판 기준[HARD·benchmark]**: **권위 가격표가 부품별 단가를 주면 부품 합산·완제 통합단가를 주면 통합**.

| 증거 | 내용 | 함의 |
|------|------|------|
| E-1 상품마스터 = base24 완제 단가만 | `가격_기본(24P)`=15,000(8x8 하드)·부품 단가 컬럼 없음 | 완제 통합단가 권위(책자처럼 표지/내지 별 단가표 부재) |
| E-2 포토북 전용 가격표 시트 부재 | 가격표 260527에 포토북 시트 없음(제본/디지털 보조) | 부품별 단가표가 권위에 없음 → full 분해 불가 |
| E-3 row17 명문 산식 | `상품단가+페이지당단가적용` | 상품단가(base24)=묶음·외부=base24+per2p |
| E-4 per2p cost-driven(§4) | imposition 단조(A5 300<8x8 500<A4 600<10x10 1000) | 페이지 증분은 진짜 비용 기반(공식화 가능) |

★ **본 설계 결판 (DT-PB-SCOPE = base24 통합·부품 base에 묶음)**:
- **포토북 권위 = base24 완제 통합단가 + per2p 페이지 증분**(책자 full 분해와 정반대). 표지/내지/제본/면지 부품 단가는 **base24 안에 internalize**(외부 미노출). 권위 가격표가 부품 단가를 안 주므로(완제 base24만) **부품 합산 금지·base24 통째 적재**.
- `확신도: 높음`(상품마스터 base24 verbatim·per2p cost-driven 입증).

### 3.3 base24를 부품 분해 안 하는 이유 (search-before-mint·무손실 입증)

★ **base24 부품 역산(8x8 하드 15,000) = 참고용·적재 안 함**(benchmark §2.4):
| 부품 | 단가 | 산출 |
|------|------|------|
| 제본 PUR(q1) | 5,000 | COMP_BIND_PUR 라이브 verbatim |
| 내지 24P분(=12장 양면 × per2p 500) | 6,000 | per2p가 내지 1장 단가라면 |
| 잔여(표지+면지) | 4,000 | 15,000 − 5,000 − 6,000(표지 아트250 인쇄+용지+무광코팅+면지 ≈ 4,000·그럴듯) |

★ **그러나 base24를 부품(COMP_BIND_PUR+COMP_PAPER+COMP_PRINT+COMP_COAT) 합산으로 분해하면 안 됨**:
1. **권위 가격표가 부품 단가를 안 줌** — base24=완제 통합값(15,000)이 권위·부품 역산은 추측(표지 코팅/면지 정확 단가행 직매칭 미검·Q-PB-COAT/FACE).
2. **무손실 표현 = base24 통째**(COMP_PHOTOBOOK_BASE 단일 단가행)이 가장 안전·verbatim. 부품 분해 시 ① 추측 단가 INSERT 위험 ② 표지/내지 COMP_PAPER 2회 배선 충돌(책자 AD-BK3 동형) ③ base24 합이 15,000과 안 맞으면 골든 깨짐.
- ∴ **COMP_PHOTOBOOK_BASE 신설(완제 base24 단가행)이 신규 comp이나 무손실·search-before-mint 충족**(기존 comp로 base24를 표현하려면 부품 분해 필수인데 부품 단가 미권위 → 신규 base comp 정당).

### 3.4 표지타입 mat_cd 매핑 (benchmark C-PB2·★레더 갭)

base24 use_dims `[siz_cd, mat_cd]`의 mat_cd = 표지타입:

| 표지타입(시트) | mat_cd | 라이브 실측 |
|----------------|--------|-------------|
| 하드커버 | MAT_000005 | ✅ 실재(하드커버) |
| 레더하드커버 | MAT_000006 | ✅ 실재(레더하드커버) |
| 소프트커버 | MAT_000007 | ✅ 실재(소프트커버) |
| **레더(106·표지)** | **(미확정)** | ⚠ MAT_5~7에 "레더" 단독 없음·sub_prd 106=레더·**Q-PB-MAT** |
| 아트250+무광코팅(103) | (표지 종이 자재) | 하드커버 표지의 종이=아트250(MAT_000081)·표지타입과 종이 별개 |

★ **컨펌큐 Q-PB-MAT**: 표지타입 mat_cd는 하드/레더하드/소프트=MAT_005/006/007이나 **포토북 시트 표지타입 = {하드커버·레더하드커버·소프트커버} 3종**(레더 106은 레더하드커버 표지의 자재 variant). base24 단가행은 **표지타입 3종**으로 mat_cd 분기(8x8: 하드 15,000/레더하드 23,000/소프트 12,000) → mat_cd={005,006,007}. ★sub_prd 106(레더)은 레더하드커버 표지의 소재이지 별 base24 행 아님(레더하드커버=base24 23,000에 이미 포함). **Q-PB-MAT로 표지타입↔mat_cd 정확 매핑 컨펌**(추측 금지·verbatim).

---

## 4. ★component_prices — base24·per2p 단가행 + 페이지 증분 (G-PB-PAGE 돈크리티컬)

### 4.1 COMP_PHOTOBOOK_BASE 단가행 (siz_cd × mat_cd·상품마스터 verbatim)

> 값=상품마스터 `가격_기본(24P)` verbatim(날조 0)·날조 금지. siz_cd·mat_cd는 라이브 사이즈/자재 코드 매핑(컨펌 후 확정).

| siz(사이즈) | mat_cd(표지타입) | unit_price(base24) | 출처(상품마스터 row) |
|-------------|------------------|-------------------:|----------------------|
| 8x8 (203x203) | 하드커버 | **15,000** | row3 |
| 8x8 | 레더하드커버 | **23,000** | row4 |
| 8x8 | 소프트커버 | **12,000** | row5 |
| 10x10 (254x254) | 하드커버 | **22,000** | row6 |
| 10x10 | 레더하드커버 | **32,000** | row7 |
| 10x10 | 소프트커버 | (공란·**BLOCKED**) | row8(시트 공란·Q-PB-SOFT8) |
| A5 (150x214) | 하드커버 | **12,000** | row9 |
| A5 | 레더하드커버 | **19,000** | row10 |
| A5 | 소프트커버 | **10,000** | row11 |
| A4 (213x303) | 하드커버 | **16,000** | row12 |
| A4 | 레더하드커버 | **26,000** | row13 |
| A4 | 소프트커버 | **13,000** | row14 |

★ **min_qty=1 전건**(단가형 ×qty=부수·×1 정합). 10x10 소프트(row8)=시트 공란 → **단가행 INSERT 안 함·BLOCKED 정직**(추측 금지·Q-PB-SOFT8).

### 4.2 COMP_PHOTOBOOK_PAGE 단가행 (siz_cd만·표지 무관·상품마스터 verbatim)

| siz | unit_price(per2p·2P당) | 출처 |
|-----|----------------------:|------|
| 8x8 | **500** | row3~5(하드/레더하드/소프트 전건 500) |
| 10x10 | **1,000** | row6~7 |
| A5 | **300** | row9~11 |
| A4 | **600** | row12~14 |

★ **siz_cd 4행만**(표지 무관·C-PB4 가드). min_qty=1·단가형. per2p가 imposition cost-driven(§4.3) 입증.

### 4.3 ★페이지 증분 = 앱계산·DB는 per2p 단가만 (G-PB-PAGE 돈크리티컬·캘린더 G-CAL-PAGE 동형) [HARD]

★ **공식 (후니 권위·row17 명문)**:
```
포토북 가격(N pages, Q부) = base24[siz, 표지] × Q                              [부수 곱]
                          + per2p[siz] × ceil((N − base_min) / 2) × Q          [페이지 증분 × 부수]
```
- **base_min = page_rule 최소**(하드/레더하드 = 24·소프트 = 4·§4.4 Q-PB-PAGEBASE).
- **증분횟수 = ceil((N − base_min) / 2)** = **앱 런타임 계산**(off-grid ceiling·판수·책등 동류·[[dbmap-compute-in-app-db-stores-lookup]]).
- **DB는 base24·per2p 단가만 룩업**·증분횟수·부수 곱은 앱(SKU 폭발 금지·페이지 64단계를 siz_cd/product_prices 행으로 베이크 금지·benchmark C-PB1 GAP).

★ **G-PB-PAGE 돈크리티컬 가드 [HARD·양방향]**:
- **페이지 곱은 per2p(내지비)에만 적용** — base24엔 페이지 곱 금지(base24=이미 24P 포함 통합값). 부수(Q)는 base24·per2p 둘 다 곱(둘 다 ×부수).
- **누락 시**: per2p×증분횟수 항이 소실되면 24P→150P 차이 소실. 8x8 하드 24P=15,000 vs 150P=15,000+((150-24)/2)×500=15,000+31,500=**46,500**(3.1배). **누락 시 150P를 15,000원에 과소청구**(돈크리티컬).
- **반대 오류(전역 qty 곱)**: 페이지증분횟수를 base24에도 곱하면 base 과대청구(캘린더 CX-CAL-A 양방향 동형). **base24=×부수만·per2p=×증분횟수×부수.**
- **음수 가드**: N ≤ base_min이면 증분횟수=0(per2p 항 0·base24만). N<base_min 주문은 page_rule이 차단(min=24/4).

### 4.4 ★base_min 페이지 기준 — 하드 24 vs 소프트 4 (Q-PB-PAGEBASE·돈크리티컬) [HARD]

★ **시트 실측(CSV verbatim)**:
- **하드커버·레더하드커버**: page `24/150/2`(min 24·incr 2). base24=**24P 기준** 상품단가.
- **소프트커버**: page `4/—/2`(min 4·시트 표기 `4 / 6 / 8 / 10 / 12 / 14`·max 미표기). **소프트 base는 4P 기준일 가능성**(base_min=4).

★ **문제**: cartographer 산식 `ceil((N−24)/2)`는 하드 전제. 소프트는 base_min=4면 `ceil((N−4)/2)`. 소프트 base24가 "12,000원이 4P 기준인지 24P 기준인지" 시트 불명확.
- **소프트 page_min=4** → base가 4P 상품단가일 개연(소프트는 페이지 적게 시작).
- **★컨펌큐 Q-PB-PAGEBASE [HARD·돈크리티컬]**: 소프트커버 base24(8x8=12,000)가 **4P 기준**이면 증분 시작점=4(per2p 적용이 6P부터), **24P 기준**이면 24부터. 잘못하면 소프트 페이지 증분 10단계(4→24) 과소/과대청구. 시트 `가격_추가(2P)당`이 소프트에도 500(8x8)이므로 산식은 동일·base_min만 다름. **per2p comp use_dims에 base_min은 차원 아님 → page_rule(소프트 page_min=4) + 앱 산식이 base_min 주입**(상품별 page_rule 권위). 인간 컨펌 후 확정.

### 4.5 표지/내지/제본/면지 부품 단가 (base24에 묶임·재사용 comp·참고)

> base24에 internalize되므로 **직접 배선 안 함**(외부 노출 0). 단 base24가 부품합산 근사임을 보이는 재사용 comp 인벤토리(검증가 참고·실 배선 아님):

| 부품 | 재사용 comp | 라이브 단가(verbatim) | base24 묶임 |
|------|-------------|----------------------|-------------|
| 제본 PUR | COMP_BIND_PUR | 5,000/부(q1·PROC_000020) | base24 안 |
| 내지 용지(몽블랑130) | COMP_PAPER | 77.03/판(MAT_000105·SIZ_499) | base24·per2p 안 |
| 표지 용지(아트250) | COMP_PAPER | 77.75/판(MAT_000081·SIZ_499) | base24 안 |
| 표지/내지 인쇄 | COMP_PRINT_DIGITAL_S1 | 단/양면 tier | base24·per2p 안 |
| 표지 무광코팅 | COMP_COAT_MATTE | (단가행 충전 확인 Q-PB-COAT) | base24 안 |
| 면지(그레이) | (가격기여 BLOCKED·Q-PB-FACE) | — | base24 안(택1 색·비기여 추정) |

★ **이 부품 comp들은 전부 라이브 실재(재사용·신규 mint 0)** — base24가 완제 통합값이라 직접 배선하지 않고 base24 단가행 하나로 표현. **search-before-mint 10연속**(인쇄/용지/제본/코팅 전부 재사용·신규=공식1+base/per2p comp 2뿐).

---

## 5. ★product_price_formulas — 부모 PRD_000100 바인딩 (W2·G-PB-2)

```
PRD_000100 포토북 [디자인명] (세트 부모·PRD_TYPE.04)
  → product_price_formulas: frm_cd = PRF_PHOTOBOOK_SUM  (신규 바인딩)

  sub_prd(t_prd_product_sets·7행·가격 비기여):
    PRD_000101 내지(몽블랑130)    ← BOM(가격 0)
    PRD_000102 표지(하드커버)      ← BOM·표지타입 택1 선택지
    PRD_000103 표지(아트250+무광)  ← BOM
    PRD_000104 면지(그레이)        ← BOM(택1 색·가격 비기여)
    PRD_000105 표지(레더하드커버)  ← BOM
    PRD_000106 표지(레더)          ← BOM
    PRD_000107 표지(소프트커버)    ← BOM
```

★ **바인딩 1건뿐**(세트 부모 100). sub_prd 101~107은 **가격 바인딩 안 함**(가격 비기여·§6 이중계상 가드). 견적 시 손님 표지타입 선택 → mat_cd 주입 → base24 단가행 매칭(Q-PB-OPT·option_items→mat_cd 주입 선결).

★ **D-PB-MODEL [HARD]**: PRD_TYPE.04(고정가형 디폴트)이나 **공식기반(FORMULA)으로 바인딩**(페이지 차원이 product_prices에 없으므로). product_prices INSERT 금지(G-PB-PRODPRICE·아래 §7). `schema-design-intent-map` 고정가형 분류는 페이지 차원 추가 전 stale(design-decisions D-PB-MODEL).

---

## 6. ★세트 "구성"(sets) ≠ 세트 "가격"(공식 Σ) — 이중계상 가드 (W4·G-PB-SET) [HARD]

| 구분 | 포토북 요소 | 가격 처리 |
|------|------------|-----------|
| **세트 "구성"(생산 BOM·MES)** | sub_prd 7행(내지 101·표지 102/103/105/106/107·면지 104) | `t_prd_product_sets`·**가격 비기여**(주문/생산 단위 묶음·표지/면지 택1 선택지) |
| **세트 "가격"(공식 Σ)** | base24(표지/내지/제본/면지 묶음) + per2p×페이지증분 | PRF_PHOTOBOOK_SUM의 base24·per2p comp Σ(가격 권위) |

★ **이중계상 가드 [HARD·책자 G-BK-5·디지털 D-5·캘린더 13-5 동형]**:
- **표지 5 variant(102/103/105/106/107)를 "부품 5개 합산"하면 이중계상** — 표지는 **택1**(손님이 1표지 선택)이지 5표지 전부 합산 아님. base24가 선택된 표지타입(mat_cd) 1행만 매칭.
- **면지(104 그레이)에 단가행 두고 합산 금지** — 면지는 base24에 묶임(택1 색·가격 비기여 추정·Q-PB-FACE). sub_prd_qty=1·min/max_cnt NULL(택1 의미).
- **sub_prd를 가격 합산 항에 끌어들이지 말 것**(benchmark P-9b). 가격=base24+per2p comp Σ로만. sets는 어떤 표지/내지/면지를 쓰는지 **구성(BOM) 정보**.
- **★"이질 N장 assortment" 오해 가드(benchmark P-9c·RP REFUTED)**: 포토북 세트(parent+표지/내지/면지)는 **한 책을 만드는 부품 구성**(생산 BOM)이지 "여러 완제품 묶음 판매"가 아니다. 묶음수(여러 권 발주)=부수(qty)·별개 차원. 1권=parent 1개·페이지=그 권 면수.

---

## 7. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| 가격 소스 우선순위(TEMPLATE→PRODUCT_PRICE→FORMULA·:296-326) | ✅ 포토북=FORMULA 경로(base24+per2p comp Σ)·세트 sub_prd 가격 비기여 |
| C7 frm_typ 미참조·공식=합산 | ✅ 부품합산+페이지 선형 둘 다 합산형 comp Σ(frm_typ 무참조)·페이지=앱 곱 |
| P3-8 ERR_AMBIGUOUS / silent 이중합산 | ✅ base24·per2p **서로 다른 comp_cd**(ambiguous 불가)·base24=mat_cd 판별·per2p=siz_cd → combo_key 다름(이중합산 없음). **단 base24 mat_cd 단가행 충전 필수**(NULL→소프트/하드 모두 와일드 매칭→silent 합산·G-PB-FLAT) |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ base24·per2p `.01` 단가형·unit×qty·min_qty=1 전건 충전(NULL 금지·ValueError 가드) |
| TIER min_qty '이상' 하한(:42·144) | ✅ base24/per2p min_qty=1(전 주문 매칭)·제본 PUR은 base24에 묶여 외부 미노출 |
| **★G-PB-PRODPRICE 선점 가드(:315-330)** | ✅ **product_prices INSERT 금지** — base24를 product_prices에 박으면 PRODUCT_PRICE 선점으로 FORMULA(per2p 페이지 가산) 통째 우회 silent → 페이지 가산 소실. 현 product_prices 0행=자동충족·적재 시 박제(캘린더 G-CAL-2·GP-2 G-GP-3·악세사리 G-AC-3 동형) |
| U-7 시트 차원경계(SOT 1) | ✅ 포토북 공식에 시트 밖 comp 침입 금지·base24/per2p는 포토북 시트 경계 내·부품 comp는 base24에 묶여 외부 미배선 |
| 수량구간할인 연결(:478-504) | ⚠️ 포토북 t_prd_product_discount_tables 링크 점검(부수=수량구간·미점검·Q-PB-DSC·악세사리 D-AC-2 동형=부자재 미해당 가능성) |
| search-before-mint | ✅ 인쇄/용지/제본/코팅 comp 재사용(신규 0)·세트 그릇·page_rule 실재. **신규 = 공식 1(PRF_PHOTOBOOK_SUM)+comp 2(BASE/PAGE)뿐** |

★ **G-PB-FLAT 평탄화 가드 [HARD·돈크리티컬]**: base24를 표지타입 무관 단일 unit_price로 평탄 적재 금지(소프트 12,000 주문에 하드 15,000 오청구 or 역). base24 단가행 mat_cd 판별차원 충전 필수(굿즈 G-GP-3·캘린더 G-CAL-1·악세사리 G-AC-1 동형). per2p도 siz_cd 충전(8x8 500 vs A4 600 정확 매칭).

---

## 8. designer 큐 잔여 (golden-cases·design-decisions로 이관)

- **W1 PRF_PHOTOBOOK_SUM 공식 신설 + base24/per2p comp 2 배선** = 1순위(WIRE 폐쇄).
- **W2 부모 100 바인딩**(FORMULA·product_prices 금지) = 1순위.
- **W3 base24(12행·1 BLOCKED)·per2p(4행) 단가행 verbatim 충전** = 2순위(mat_cd/siz_cd 판별차원 필수).
- **G-PB-PAGE 페이지 증분 앱 곱**(base_min=하드24/소프트4·증분횟수=앱) + **G-PB-PRODPRICE/SET/FLAT 가드** = 돈크리티컬.

실 적용(공식 신설·comp 신설·단가행 충전·바인딩)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·dbm-price-arbiter·webadmin 코드 직접수정 금지).

## naming 유입 가드 [HARD]
`digital_price`·`tmpl_price`·`book2025`·`INN_PAGE`·`PHBK*`·`PHBKMYB`·`TPPHSET`·`seneca`·`MTRL_CD`·`CVR_MTRL_CD`·`COV_MIN_WGT`·`jobqty0`/`jobcost0` 후니 유입 금지. 후니 `frm_cd`(PRF_PHOTOBOOK_SUM)·`comp_cd`(COMP_PHOTOBOOK_BASE/PAGE·COMP_BIND_PUR·COMP_PAPER·COMP_COAT_MATTE)·`siz_cd`·`mat_cd`·`page_rules`·`t_prd_product_sets` 컨벤션으로 번역([[dbmap-naming-standardization]] 권위순서: 후니 레거시→라이브 DB→rpmeta→인쇄표준).
