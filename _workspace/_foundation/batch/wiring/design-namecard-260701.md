# 명함류 고아 8건 §18 가격엔진 설계 명세 (NEEDS_FORMULA → 판별차원·공식·옵션·배선)

- 입력: `orphan-classification-260701.md`(표 #1~8) · 권위 단가 = `live-snapshot/latest/t_prc_component_prices.csv`(가격표 260527 적재 verbatim) · 엔진 = `pricing.py`(`_row_matches` L94·`_match_entry` L600·`component_subtotal` L193)
- 작업: **설계 명세까지**. 실 COMMIT 없음·DB 미적재·생성≠검증(codex 교차·골든 재계산·PRICE≠0 실호출은 후속 별도 패스).
- 산출일 2026-07-01. dryrun = `design-namecard-dryrun.sql`(멱등·NOT EXISTS/IS NULL 가드·COMMIT 아님).

---

## 0. 핵심 결론

두 패밀리 모두 **판별차원(print_opt_cd 단/양면 + opt_cd 박종류·코팅)을 단가행+use_dims에 부여한 뒤 배선**하면 silent-sum 없이 해소된다. 근본 함정([HARD]) = `_row_matches`: 단가행에 판별 비수량차원이 없으면(NULL=와일드카드) 형제 변형이 동시매칭→합산 과대청구. 설계 골자 = **각 변형을 disjoint하게 가르는 판별차원 충전**.

| 패밀리 | 상품 | 현 상태 | 판별차원(설계) | 공식 | 선택수단(설계) | 배선 |
|---|---|---|---|---|---|---|
| **A. 오리지널박명함** | PRD_000037 | S1_STD만 배선(와일드카드)→양면·홀로 오산정 | `print_opt_cd`(단/양면)×`opt_cd`(일반박/홀로) | PRF_NAMECARD_FOIL **재사용** | print_options 2 + 박종류 opt_grp 1+옵션 2 | body 4 + setup 2 |
| **B. 화이트인쇄명함** | PRD_000040 | **공식 부재→견적0** | `print_opt_cd`(단/양면)×`opt_cd`(코팅/무코팅)×`mat_cd`(고정 큐리어스스킨) | **PRF_NAMECARD_WHITE 신설** | print_options 2 + 코팅 opt_grp 1+옵션 2 + 자재 1 | body 4 |

**둘 다 BLOCKED 없음** — 판별차원이 단가행을 완전 disjoint하게 가른다(검증 §3·§4). 단, 잔여 의존 2건(아래 §6): ① 화이트 단가행이 **qty=100 단일 tier만 적재**(§26 미적재 셀 — qty≠100 오산정) ② 두 상품 product_materials에 굿즈 자재 오염(§17 정리 대상, 견적엔 default 자재로 무해).

---

## A. 오리지널박명함 PRD_000037 (박명함, 4 body + 2 setup)

### A-1. 권위 단가 (verbatim·합가형 PRICE_TYPE.02 = 구간총액÷min_qty×qty)

`면 동일가`(단면=양면 동일단가), 가격은 `박종류 × 수량` 결정. setup = 동판셋업비 5000 고정(PRICE_TYPE.03, 박종류 무관·수량 무관). 권위 공식 = `판매가 = 동판비 + 오리지널박명함(테이블)`(계산공식집 행38).

| 수량tier | 일반박(STD) | 홀로/트윙클(HOLO) |
|---|---|---|
| 200 | 19,200 | 24,800 |
| 300 | 24,800 | 33,200 |
| 400 | 30,400 | 41,600 |
| 500 | 36,000 | 50,000 |
| 600 | 41,600 | 54,400 |
| 700 | 47,200 | 66,800 |
| 800 | 52,800 | 75,200 |
| 900 | 58,400 | 83,600 |
| 1000 | 64,000 | 92,000 |

(comp_price_id 3353~3388 — 단면/양면 행 값 동일 확인됨. setup S1=S2=5000, id 3351/3352.) **값 무수정 — 판별차원 컬럼만 충전.**

### A-2. 판별차원 설계 (search-before-mint)

- **단/양면 = `print_opt_cd`** — 라이브 POPT_000001(단면)·POPT_000002(양면) **재사용**(mint 0). 형제 명함(PRD_000031/032/033)이 동일 패턴으로 작동 중.
- **박종류 = `opt_cd`** — 라이브에 박종류 opt 부재 → 신규 mint 불가피(무손실 표현 불가). opt_grp `OPT_000080`(박종류) + 옵션 OPV_000487(일반박, dflt)·OPV_000488(홀로그램/트윙클). 채번 = MAX+1(opt_grp OPT_000079→080, opt OPV_000486→487/488). use_dims에 `opt_grp:OPT_000080` 추가(UI 드롭다운 스코핑·엔진 무시). COMP_ACRYL_BADGE 패턴 mirror.

### A-3. 단가행 차원 충전 (UPDATE — 값 불변, 판별 컬럼만)

| comp_cd | print_opt_cd | opt_cd | 비고 |
|---|---|---|---|
| COMP_NAMECARD_FOIL_S1_STD | POPT_000001 | OPV_000487 | 9행 |
| COMP_NAMECARD_FOIL_S1_HOLO | POPT_000001 | OPV_000488 | 9행 |
| COMP_NAMECARD_FOIL_S2_STD | POPT_000002 | OPV_000487 | 9행 |
| COMP_NAMECARD_FOIL_S2_HOLO | POPT_000002 | OPV_000488 | 9행 |
| COMP_NAMECARD_FOIL_SETUP_S1_STD | POPT_000001 | (NULL=와일드카드) | 박종류 무관·setup |
| COMP_NAMECARD_FOIL_SETUP_S2_STD | POPT_000002 | (NULL) | 〃 |

use_dims 갱신:
- body 4 comp: `["min_qty"]` → `["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000080"]`
- SETUP_S1: `["min_qty"]` → `["print_opt_cd","min_qty"]` · SETUP_S2: `[]` → `["print_opt_cd"]`

### A-4. 선택수단 (상품 등록)

- print_options(t_prd_product_print_options): PRD_000037 ← opt_id 1 단면(POPT_000001, dflt Y)·opt_id 2 양면(POPT_000002, dflt N). **[HARD] 현재 0건 — 없으면 배선 무효.** PRD_000033 패턴 mirror.
- option_group + options: OPT_000080(박종류 SEL_TYPE.01 택1 필수) + OPV_000487 일반박(dflt Y)·OPV_000488 홀로/트윙클(dflt N).

### A-5. 배선 (formula_components, PRF_NAMECARD_FOIL 재사용)

기존: S1_STD(seq1)·SETUP_S1(seq2). 추가 INSERT(addtn_yn=Y):

| seq | comp_cd |
|---|---|
| 3 | COMP_NAMECARD_FOIL_S1_HOLO |
| 4 | COMP_NAMECARD_FOIL_S2_STD |
| 5 | COMP_NAMECARD_FOIL_S2_HOLO |
| 6 | COMP_NAMECARD_FOIL_SETUP_S2_STD |

---

## B. 화이트인쇄명함 PRD_000040 (공식 신설, 4 body·견적0 최우선)

### B-1. 권위 단가 (verbatim·합가형 PRICE_TYPE.02)

단일 자재 큐리어스스킨(MAT_000137), 가격 = `단/양면 × 코팅 × 수량`. 권위 공식 = 고정가형(계산공식집 행32, 명함군). **qty=100 tier만 적재(아래 §6 ① 경고).**

| 변형 | comp_cd | qty=100 단가 | print_opt | 코팅 |
|---|---|---|---|---|
| 단면·무코팅 | COMP_NAMECARD_WHITE_S1W_NOCL | 14,500 | POPT_000001 | 무코팅 |
| 단면·코팅 | COMP_NAMECARD_WHITE_S1W_CL | 16,000 | POPT_000001 | 코팅(클리어 단면) |
| 양면·무코팅 | COMP_NAMECARD_WHITE_S2W_NOCL | 16,000 | POPT_000002 | 무코팅 |
| 양면·코팅 | COMP_NAMECARD_WHITE_S2W_CL | 19,000 | POPT_000002 | 코팅(클리어 양면) |

(comp_price_id 3343~3346 — **print_opt_cd 이미 충전됨**. 값 무수정.)

### B-2. 판별차원 설계

- **단/양면 = `print_opt_cd`** — 이미 행에 충전(POPT_000001/000002). use_dims에도 이미 존재. mint 0.
- **코팅 = `opt_cd`** — 라이브 코팅 opt 부재 → mint. opt_grp `OPT_000081`(코팅) + OPV_000489(코팅, dflt N)·OPV_000490(무코팅, dflt Y). use_dims에 `opt_grp:OPT_000081`.
- **자재 = `mat_cd`** — 고정 MAT_000137(단일 substrate). use_dims에 이미 존재(`mat_cd`). 판별 아닌 상수지만 권위 적재 의도 보존.

### B-3. 단가행 차원 충전 (UPDATE)

| comp_cd | opt_cd(추가) | 기보유 |
|---|---|---|
| COMP_NAMECARD_WHITE_S1W_CL | OPV_000489(코팅) | print_opt POPT_000001·mat MAT_000137 |
| COMP_NAMECARD_WHITE_S1W_NOCL | OPV_000490(무코팅) | POPT_000001·MAT_000137 |
| COMP_NAMECARD_WHITE_S2W_CL | OPV_000489 | POPT_000002·MAT_000137 |
| COMP_NAMECARD_WHITE_S2W_NOCL | OPV_000490 | POPT_000002·MAT_000137 |

use_dims 갱신(4 comp): `["mat_cd","min_qty","print_opt_cd"]` → `["mat_cd","print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000081"]`

### B-4. 공식 신설 + 바인딩

- price_formulas INSERT: `PRF_NAMECARD_WHITE`("화이트인쇄명함 면/코팅/수량별 단가(용지포함)", use_yn=Y). 형제 PRF_NAMECARD_COAT/PEARL 네이밍 mirror.
- product_price_formulas INSERT: PRD_000040 ← PRF_NAMECARD_WHITE(apply_bgn_ymd 2026-06-01).

### B-5. 선택수단 (상품 등록)

- print_options: PRD_000040 ← 단면(POPT_000001 dflt Y)·양면(POPT_000002 dflt N). **현재 0건.**
- option_group + options: OPT_000081(코팅 SEL_TYPE.01 택1 필수) + OPV_000489 코팅(dflt N)·OPV_000490 무코팅(dflt Y). **[CONFIRM] 기본=무코팅으로 설정(저가·white toner base). 실무진 확인 큐.**
- product_materials: PRD_000040 ← MAT_000137(큐리어스스킨 USAGE.07 dflt Y). **현재 미등록(굿즈 138~141만 오염) — 없으면 mat_cd no_match로 견적0 잔존.**

### B-6. 배선 (formula_components, 신설 공식에 4 body)

| seq | comp_cd | addtn_yn |
|---|---|---|
| 1 | COMP_NAMECARD_WHITE_S1W_NOCL | Y |
| 2 | COMP_NAMECARD_WHITE_S1W_CL | Y |
| 3 | COMP_NAMECARD_WHITE_S2W_NOCL | Y |
| 4 | COMP_NAMECARD_WHITE_S2W_CL | Y |

---

## §3. 판별차원 disjoint 검증 [HARD] — A. 박명함

엔진은 PRF_NAMECARD_FOIL의 전 comp를 평가·합산. 각 comp 행의 (print_opt_cd, opt_cd) 조합:

| comp | (print_opt, opt) | 단면+일반박 주문 | 양면+홀로 주문 |
|---|---|---|---|
| S1_STD | (POPT1, OPV487) | **매칭** | mismatch |
| S1_HOLO | (POPT1, OPV488) | opt mismatch | mismatch(print) |
| S2_STD | (POPT2, OPV487) | print mismatch | opt mismatch |
| S2_HOLO | (POPT2, OPV488) | mismatch | **매칭** |
| SETUP_S1 | (POPT1, NULL=*) | **매칭**(opt 와일드) | mismatch(print) |
| SETUP_S2 | (POPT2, NULL=*) | print mismatch | **매칭** |

→ 단면+일반박 = S1_STD + SETUP_S1만(body+setup, 의도된 2비목 합산). 양면+홀로 = S2_HOLO + SETUP_S2만. **body 4 변형 상호 disjoint**(2축 조합 모두 distinct). setup의 opt=NULL은 박종류 무관 의도(body와 다른 comp라 동시합산이 정상). ERR_AMBIGUOUS 없음(comp당 단일 조합). **PASS.**

## §4. 판별차원 disjoint 검증 [HARD] — B. 화이트명함

| comp | (print_opt, opt, mat) | 단면+무코팅 | 양면+코팅 |
|---|---|---|---|
| S1W_NOCL | (POPT1, OPV490, MAT137) | **매칭** | mismatch |
| S1W_CL | (POPT1, OPV489, MAT137) | opt mismatch | print mismatch |
| S2W_NOCL | (POPT2, OPV490, MAT137) | print mismatch | opt mismatch |
| S2W_CL | (POPT2, OPV489, MAT137) | mismatch | **매칭** |

→ 각 주문 = 정확히 1 body 매칭. **4 변형 (print_opt × opt_cd) 완전 disjoint. PASS.**(mat_cd 동일 상수 — disjoint 영향 없음, 단 선택수단으로 MAT137 등록 필수.)

---

## §5. 골든 케이스 (검증가 재현 대상 · 권위가)

| # | 상품 | 선택 | 기대 골든(권위) | 현재(결함) | 비목 |
|---|---|---|---|---|---|
| G-A1 | 박명함 037 | 단면·일반박·200 | **24,200** | 24,200(정상경로) | S1_STD 19,200 + setup 5,000 |
| G-A2 | 박명함 037 | 양면·홀로·300 | **38,200** | 29,800(저청구·S1_STD 와일드 24,800+5,000) | S2_HOLO 33,200 + setup 5,000 |
| G-A3 | 박명함 037 | 단면·홀로·500 | **55,000** | 41,000(저청구) | S1_HOLO 50,000 + setup 5,000 |
| G-B1 | 화이트 040 | 단면·무코팅·100 | **14,500** | 0(공식부재) | S1W_NOCL |
| G-B2 | 화이트 040 | 양면·코팅·100 | **19,000** | 0 | S2W_CL |
| G-B3 | 화이트 040 | 단면·코팅·100 | **16,000** | 0 | S1W_CL |

(합가형: tier 단가 ÷ min_qty × qty. G-A1: 19200/200×200=19200. 모두 tier=주문수량이라 정수 일치. 수량구간 할인 t_prd_product_discount_tables 미연결 시 위 값이 final.)

---

## §6. 잔여 의존 / 라우팅 (BLOCKED 아님 — 후속 트랙)

1. **[§26/§7] 화이트명함 단가 tier 미적재** — 라이브에 qty=100 단일 tier만(4행). 박명함은 200~1000 적재. 화이트 권위 가격표(260527)에 100/200/…/1000 tier가 있다면 미적재 셀 = 합가형 프로레이팅으로 qty≠100 **오산정**(예 qty=200 → 14500/100×200=29000, 권위 200tier ≠ 일치 보장 없음). **본 설계는 배선·판별차원까지 정확. tier 충전은 §26 무결성/§7 적재 선행.** 골든은 qty=100 한정 유효.
2. **[§17] product_materials 굿즈 오염** — PRD_000037·040에 MAT_000138(젤리볼펜)/139(지비츠)/140(다이어리내지)/141(미니배너거치대) 오적재(명함과 무관). 견적엔 default(MAT_000137) 사용으로 무해하나 고객이 오염 자재 선택 시 no_match. **138~141 논리삭제 = §17 자재 정리 트랙**(본 순수 배선/설계 범위 밖, dryrun 미포함).
3. **[CONFIRM] 화이트 코팅 기본값** — 무코팅(저가) 가정. 실무진/goods.asp 확인 큐.
4. **[검증]** option_items(SKU 레이어) 미설계 — opt_cd 드롭다운·엔진 매칭은 TPrdProductOptions로 충분(price_views `_opt_cd_options`). 위젯 SKU 단계는 Phase-2(§7/CPQ).

---

## §7. 인간 승인 게이트 요약

- **설계 완결 8건**(박명함 4 body+2 setup·화이트 4 body) — 전부 disjoint 판별차원 확보·BLOCKED 0.
- **신규 mint**: 공식 1(PRF_NAMECARD_WHITE)·opt_grp 2(OPT_000080 박종류·OPT_000081 코팅)·opt 4(OPV_000487~490)·print_options 4행·product_materials 1행. 단가행 = **UPDATE만**(판별 컬럼 충전, 값 0건 변경).
- **예상 회복**: 화이트명함 견적0→14,500~19,000(qty=100) · 박명함 양면/홀로 저청구→정답가(G-A2 +8,400 등).
- **선행 의존**: 화이트 tier 충전(§26)·자재 오염 정리(§17)는 별 트랙. 실 COMMIT = 인간 승인 후 §7 dbmap.
- 검증: 본 설계는 생성측. codex 교차·hpe-validator 골든 재계산·PRICE≠0 실호출 후속.
