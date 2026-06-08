# price-211 slice C2 매핑 설계서 — BOOKLET / PHOTOBOOK / POSTCARD-BOOK / 떡메

| 항목 | 값 |
|------|----|
| 작성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 트랙 | price-211 Phase-1, slice C2 (F3 = 하드커버책자/포토북/엽서북/떡메) |
| 성격 | **적재 실행본 (멱등 SQL + DRY-RUN plan). DB 쓰기 없음.** |
| 권위 순서 | 가격표/상품마스터 엑셀 명시값 > `06_extract` L1 > 설계. **라이브 = 권위** |
| 권위 DDL | `00_schema/price-engine-ddl.md` (C-1~C-9) |
| 입력 | `06_extract/{price-binding-l1, booklet-l1, photobook-l1, price-postcard-book-l1}.csv` |

---

## 0. STATUS (read-only 실측, 2026-06-07) — **계획 가정 대거 정정**

본 slice는 `price-211-track-plan.md` F3에서 "33 무가격 상품"으로 잡혔으나, **라이브 직접 조회 결과
33은 부모(orderable PRD_TYPE.04)와 반제품(면지/표지/내지 PRD_TYPE.02 sub-product)을 합산한 prd-count**였고,
가격 적재 단위인 orderable 부모는 훨씬 적다. 또한 **엽서북·떡메·일반책자 제본은 이미 라이브에 적재 완료**되어 있었다.

### 0.1 라이브 ground truth — 카테고리별 부모 vs 반제품

| 카테고리 | leaf | 부모(.04) | 반제품(.02) | 부모 가격상태 |
|----|----|:--:|:--:|----|
| 엽서북 | CAT_000026 | PRD_000094 엽서북 | 095/096 | **이미 PRF_PCB_FIXED + 234행 component_prices ✓** |
| 떡메모지 | CAT_000129 | PRD_000097 떡메모지 | 098 | **이미 PRF_TTEOKME_FIXED + 112행 ✓** |
| 하드커버책자 | CAT_000105 | 072/082/088/077 (4) | 면지·표지 20행 | **hasf=0 (미바인딩) ← 본 slice 대상** |
| 포토북 | CAT_000108 | PRD_000100 포토북 [디자인명] | 101~107 (7) | **hasf=0 (미바인딩) ← 본 slice 대상** |
| (일반책자) | CAT_000006 | 068/069/070/071 | — | **이미 PRF_BIND_SUM ✓** (booklet 시트 상품, F3 밖 카테고리) |

### 0.2 제본비 component_prices — **이미 전부 라이브 적재 완료**

`price-binding-l1.csv`의 제본비 3블록(B01 제본비·B02 하드커버 제본비·B03 캘린더 제본비)은
**이미 `t_prc_component_prices`에 적재되어 있다**(값 verbatim 일치 — 역대조 §6):

| 블록 | 라이브 comp_cd | 행수(min_qty) | 비고 |
|----|----|:--:|----|
| B01 중철 | COMP_BIND_JUNGCHEOL | 8 | 3000/2000/1500/1000/1000/700/700/500 ✓ |
| B01 무선 | COMP_BIND_MUSEON | 8 | ✓ |
| B01 트윈링 | COMP_BIND_TWINRING | 8 | ✓ |
| B01 PUR | COMP_BIND_PUR | 8 | ✓ |
| B02 하드커버무선 | COMP_BIND_HC_MUSEON | 6 | 30000/20000/14000/9000/7000/6000 ✓ |
| B02 하드커버트윈링 | COMP_BIND_HC_TWINRING | 6 | ✓ |
| B02 싸바리바인더 | COMP_BIND_SSABARI | 6 | 30000/25000/20000/15000/9000/7000 ✓ |
| B03 캘린더 4종 | COMP_BIND_CAL_* | 6×4 | F6 캘린더 (slice 밖) |

→ **제본비 단가(component_prices)는 본 slice에서 적재 대상 아님.** 하드커버 책자는
**상품→공식 바인딩(`t_prd_product_price_formulas`)만 추가**하면 된다(F8형 "binding-only").

### 0.3 본 slice의 真 적재 대상 (정정 후)

| # | 대상 | prd_cd | 형태 | 적재 테이블 | 상태 |
|---|----|----|----|----|----|
| 1 | 하드커버책자 | PRD_000072 | 제본 합산형(바인딩만) | product_price_formulas | INSERTABLE |
| 2 | 레더 하드커버책자 | PRD_000077 | 제본 합산형(바인딩만) | product_price_formulas | INSERTABLE |
| 3 | 하드커버 링책자 | PRD_000082 | 제본 합산형(바인딩만) | product_price_formulas | INSERTABLE |
| 4 | 레더 링바인더 | PRD_000088 | 제본 합산형(바인딩만) | product_price_formulas | **BLOCKED** (제본종류 미상) |
| 5 | 포토북 [디자인명] | PRD_000100 | **page-band 합산형(신규공식)** | formulas/components/component_prices/binding | INSERTABLE (10×10 소프트 1행 BLOCKED) |

---

## 1. 하위구조별 형태(SHAPE) + 공식 정의

### 1.A 하드커버 책자 — 제본 합산형 (바인딩만)

- SHAPE: 라이브 `PRF_BIND_SUM`(제본 합산형, FRM_TYPE.01) 재사용. 제본종류 = 별도 comp_cd
  (라이브 모델링 패턴: 제본종류 1개 = comp_cd 1개, `min_qty` 차원만으로 수량밴드 표현,
  `max_qty` 없음 = 상향개방 C-3). 단가는 이미 적재됨.
- **제본종류 → comp_cd 매핑 (라이브 process link = 권위)**:

  | prd_cd | 상품명 | 라이브 proc link | → 제본 comp_cd |
  |----|----|----|----|
  | PRD_000072 | 하드커버책자 | PROC_000023 하드커버무선제본 | COMP_BIND_HC_MUSEON |
  | PRD_000077 | 레더 하드커버책자 | PROC_000023 하드커버무선제본 | COMP_BIND_HC_MUSEON |
  | PRD_000082 | 하드커버 링책자 | PROC_000024 하드커버트윈링제본 | COMP_BIND_HC_TWINRING |
  | PRD_000088 | 레더 링바인더 | **proc link 없음 + 소스 제본(필수) 공란** | **미상 → BLOCKED** |

- 적재: `t_prd_product_price_formulas(prd_cd, frm_cd='PRF_BIND_SUM', apply_bgn_ymd='2026-06-01', note)`.
  공식 자체가 합산형 컨테이너이고, 실제 제본종류 선택→comp 룩업은 **상품 옵션(공정 link)** 으로
  런타임 해소된다(068~071 일반책자가 동일 PRF_BIND_SUM 1공식을 공유하며 제본종류는 상품별 상이한
  것과 동일 패턴 — note 참조). 따라서 본 slice는 **바인딩 3행 INSERTABLE + 1행 BLOCKED**.
- [근거] 표지비(하드커버 제본비 B02 "표지비용 따로 계산")는 별도 항목 — 본 slice 가격범위 밖.
  제본 합산형은 제본 구성요소만 담당. 표지/내지 가격은 향후 트랙(반제품 .02 가격).

### 1.B 포토북 — **page-band 합산형 (신규공식 PRF_PBK_PAGEBAND)**

- SHAPE: `가격 = 기본가(24P) + ceil((pages − 24) / 2) × 추가2P단가`.
  - `pages` = 내지페이지(편집기), 최소 24·최대 150·증가 2.
  - **[HARD·adversarial] page count는 DB에 baked-in 금지.** DB는 (a) 기본가 lookup행 + (b) 추가2P단가 lookup행
    **2종만** 저장한다. `(pages−24)/2`의 곱셈·ceiling은 **앱 런타임 계산**(메모리
    `dbmap-compute-in-app-db-stores-lookup` · DDL C-4 addtn_yn≠곱셈).
- 공식 구조 (FRM_TYPE.01 합산형, 2 components):

  | comp_cd | comp_typ_cd | 역할 | addtn_yn | 차원 |
  |----|----|----|:--:|----|
  | COMP_PBK_BASE24P | PRC_COMPONENT_TYPE.06 완제품비 | 기본가 @ ≤24P | Y | siz_cd(사이즈) + mat_cd(표지) |
  | COMP_PBK_ADD2P | PRC_COMPONENT_TYPE.06 완제품비 | 추가 2P당 증분단가 | Y | siz_cd + mat_cd |

  > addtn_yn='Y' 둘 다 = "두 구성요소를 합산". 단, ADD2P는 **단위단가**일 뿐이고 실제 합산식의
  > `× ceil((pages-24)/2)` 계수는 앱이 적용한다(공식 note에 명시). 이것이 page-band가
  > round-2 면적형(× 매수)·디지털인쇄(÷ 판걸이수)와 동일한 "DB=lookup, multiply=app" 철학.

- 차원 매핑 (search-before-mint 전부 hit):

  | 축 | 엑셀값 | 라이브 코드 | 비고 |
  |----|----|----|----|
  | 사이즈 | 8×8(200×200) | SIZ_000269 | hit |
  | | 10×10(250×250) | SIZ_000274 | hit |
  | | A5(148×210) | SIZ_000170 | hit |
  | | A4(210×297) | SIZ_000172 | hit |
  | 표지 | 하드커버 | MAT_000005 | hit |
  | | 레더하드커버 | MAT_000006 | hit |
  | | 소프트커버 | MAT_000007 | hit |

- component_prices 행: 11 (size×cover) × 2 (base/add) = **22행** INSERTABLE.
  단 **10×10 소프트커버 = 소스 공란**(photobook r8, base/add 둘 다 blank) → BLOCKED 1조합(base+add 2행 미적재).
- 바인딩: `t_prd_product_price_formulas(PRD_000100, PRF_PBK_PAGEBAND)` 1행.

### 1.C 엽서북 / 떡메 — **이미 적재 완료, 본 slice 적재 없음**

- 엽서북 PRD_000094 = PRF_PCB_FIXED + COMP_PCB_S1_20P/S2_20P (117+117=234행) ✓
  - 라이브 모델: 4축(사이즈×인쇄×페이지×수량)을 siz_cd + min_qty + bdl_qty + coat_side_cnt 차원으로
    이미 평면화. 본 slice는 **재적재 금지**(중복).
- 떡메 PRD_000097 = PRF_TTEOKME_FIXED + COMP_TTEOKME (112행) ✓
  - 라이브 모델: 사이즈×권당장수×수량을 siz_cd + bdl_qty + min_qty로 이미 평면화. **재적재 금지.**
- 본 문서는 이 둘을 **역대조(§6)로 검증만** 하고 적재 CSV/SQL에서 제외한다.

---

## 2. 적재 대상 정리 (테이블별)

| 적재 테이블 | 신규행 | 내용 |
|----|:--:|----|
| `t_prc_price_formulas` | 1 | PRF_PBK_PAGEBAND (포토북 page-band 합산형) |
| `t_prc_price_components` | 2 | COMP_PBK_BASE24P, COMP_PBK_ADD2P |
| `t_prc_formula_components` | 2 | PRF_PBK_PAGEBAND ↔ 2 comps |
| `t_prc_component_prices` | 22 | 포토북 base(11)+add2P(11) — 10×10소프트 제외 |
| `t_prd_product_price_formulas` | 4 | 하드커버 3 (PRF_BIND_SUM) + 포토북 1 (PRF_PBK_PAGEBAND) |
| **합계 INSERTABLE** | **31행** | |
| BLOCKED | 3 | 레더링바인더 바인딩 1 + 10×10소프트 component_prices 2 |

제본비 component_prices·엽서북·떡메 = **이미 적재됨(적재 대상 아님)**.

---

## 3. 적재 순서 (FK 위상정렬, price-engine-ddl §3)

```
[단계 0] 부모 선존재 검증 (적재 아님)
   t_prd_products(072/077/082/100) · t_cod_base_codes(FRM_TYPE.01·.02, PRC_COMPONENT_TYPE.06)
   · t_siz_sizes(269/274/170/172) · t_mat_materials(005/006/007)
   · t_prc_price_components(COMP_BIND_HC_MUSEON·HC_TWINRING 선존재) · PRF_BIND_SUM 선존재
[단계 1] t_prc_price_formulas   ← PRF_PBK_PAGEBAND (frm_typ_cd=FRM_TYPE.01)
[단계 1] t_prc_price_components ← COMP_PBK_BASE24P·ADD2P (comp_typ_cd=.06)  (병렬)
[단계 2] t_prc_formula_components ← PRF_PBK_PAGEBAND × 2 comps
[단계 2] t_prc_component_prices   ← 포토북 22행  (병렬)
[단계 3] t_prd_product_price_formulas ← 하드커버 3 (PRF_BIND_SUM) + 포토북 1 (PRF_PBK_PAGEBAND)
```

---

## 4. 코드/제약 준수 (C-1~C-9)

- **C-1 apply_ymd**: component_prices.apply_ymd = `'2026-06-01'`(yyyy-MM-dd, NOT NULL).
  product_price_formulas.apply_bgn_ymd = `'2026-06-01'`(nullable 메모).
- **C-2 자연키 UNIQUE 8**: 포토북 component_prices는 (comp_cd, apply_ymd, siz_cd, mat_cd) 조합이 유일
  (clr/coat/bdl/min_qty 모두 NULL). CSV 내 중복 0 (사전 확인). NULLS NOT DISTINCT가 아니므로
  멱등 가드 = `INSERT … SELECT … WHERE NOT EXISTS (… IS NOT DISTINCT FROM …)` (DGP 패턴 답습).
- **C-3 max_qty 부재**: 포토북은 수량밴드 없음(min_qty=NULL). 하드커버 제본 단가는 기존행(min_qty 보유).
- **C-4 addtn_yn ≠ 곱셈**: page-band의 ×ceil((pages-24)/2)는 addtn_yn으로 표현 불가 → 앱 런타임. addtn_yn='Y'는 합산 플래그만.
- **C-5 FRM_TYPE 2종**: PRF_PBK_PAGEBAND = FRM_TYPE.01(합산형). NOT NULL.
- **C-6 PRC_COMPONENT_TYPE.06 완제품비**: 포토북 base/add 단가는 인쇄/코팅/용지로 분해 안 되는
  통가격(완제품가) → .06. (엽서북/떡메/포스터/명함 등 라이브 선례와 동일.)
- **C-8 use_yn**: PRF_PBK_PAGEBAND.use_yn='Y'; COMP_PBK_*.use_yn='Y'.
- **C-9 NULL=NULL 비차원**: component_prices의 clr_cd/coat_side_cnt/bdl_qty/min_qty = NULL(빈문자열 금지).
- **reg_dt NOT NULL DEFAULT**: 모든 INSERT에서 reg_dt **omit**(DEFAULT now() 발화 — round-5 라이브 적발 교훈).

---

## 5. 설계 결정 / 모호 / GAP (사용자 컨펌 필요)

| ID | 분류 | 내용 | 처리 |
|----|----|----|----|
| D-1 | DECISION | 포토북 page-band 신규공식 PRF_PBK_PAGEBAND 명명 + 2 comps(.06). | INSERTABLE (mint) |
| D-2 | DECISION | 표지타입을 mat_cd(005/006/007)로 차원화 (라이브 mat 선존재). 별도 comp 분할 아님 → 과분할 방지. | INSERTABLE |
| B-1 | BLOCKED | **레더 링바인더 PRD_000088**: 소스 제본(필수) 공란 + 라이브 proc link 없음 → 제본종류 미상. 싸바리 추정 = 발명(금지). | BLOCKED — 후니 input |
| B-2 | BLOCKED | **포토북 10×10 소프트커버**: 소스 base/add 공란(품절/미출시 추정). | BLOCKED — 후니 input |
| A-1 | 모호 | 포토북 PUR제본(PROC_000020)이 별도 제본비를 더하는지 — 가격표 page-band가 통가격(완제품비)이면 제본 포함. 본 설계 = **통가격 가정**(제본 별도합산 안 함, .06 완제품비). | 통가격 처리 (계획 §F3 "기본가+증분") |
| A-2 | 모호 | 표지비(B02 "표지비용 따로 계산") — 하드커버 책자 가격의 표지분. 본 slice는 제본분만 바인딩. | 표지/내지 가격 별도 트랙 |

---

## 6. 역대조 (엑셀 ↔ 라이브, 권위 대조)

- B01 제본비 4종 × min_qty 8: 라이브 COMP_BIND_* 단가 = 엑셀 셀 verbatim 일치(중철 3000/2000/1500/1000/1000/700/700/500 등). ✓
- B02 하드커버 제본비 3종 × min_qty 6: 라이브 = 엑셀 일치(HC무선 30000~6000, 싸바리 30000~7000). ✓
- 포토북 base/add: 적재 CSV ↔ photobook-l1 셀 11조합 일치(8×8 하드 15000/+500, A4 하드 16000/+600 등). ✓
- 엽서북/떡메: 라이브 234·112행이 엽서북/떡메 매트릭스와 일치(셀 단위 검증은 dbm-validator 역대조 권장).
