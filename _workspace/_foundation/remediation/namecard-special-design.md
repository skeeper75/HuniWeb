# 명함특수 6 전용 가격공식 설계 (생성·DB 미변경)

작성 2026-06-27 · 생성가 = hpe-engine-designer(§18). **라이브 읽기전용 SELECT만 수행·DB 미적재·생성≠검증.**
권위[HARD] = 인쇄상품 가격표 260527 「명함포토카드」 시트 B04~B09. 라이브·v03·경쟁사는 검증 오라클이지 가격 권위 아님.
입력 = `namecard-special-SCOPE.md`·`namecard-mat-fix.md`(STD 선행 교정)·`price-formula-master.md`·추출 캐시 `06_extract/price-namecard-photocard-l1.csv`·라이브 `pricing.py`/`price_views.py`.
산출 짝 = `namecard-special-fix.sql`(+backup/undo/dryrun).

---

## 0. 결론 한 줄 (★사용자 결정 = print_opt 보강 후 전체 배선)

6 특수명함의 **전용 comp·단가행은 라이브 실재(verbatim)하고 공식 PRF만 미정의**다. 면(단면/양면) 라우팅의 정석 = **STD 패턴 그대로 — 단가행 `print_opt_cd`를 태깅(S1→POPT_000001 단면·S2→POPT_000002 양면) + use_dims에 print_opt_cd 추가**. 이로써 S1+S2를 둘 다 배선해도 면 선택이 한쪽만 매칭(이중합산 0·STD 검증된 패턴). **단가값(unit_price) verbatim 불변** — 차원 컬럼 print_opt_cd만 채움(현재 NULL→태깅, 삭제 0).

> ★초기 설계의 "S1 단독 배선(단면 전용)"은 **양면 과소청구 홀**(S1 NULL 와일드카드가 양면 선택에도 매칭→단면가 청구)이므로 폐기. 메인 독립검증이 적발: SHAPE_S1=18000/S2=19000·MINISHAPE_S1=16000/S2=17000(양면 +1000)·PEARL_S1/S2(+1000). 양면이 더 비싼데 S1만 배선하면 양면 주문이 단면가로 저청구. → **print_opt 보강으로 S1+S2 정식 배선**이 정답.

상품별 처리:
1. **035 모양·036 미니모양** = print_opt 보강 + S1+S2 배선 → **보강 후 GO**(자재 무관·siz_cd 정확매칭). 골든=단면 18000/16000·양면 19000/17000.
2. **037 박** = S1_STD=S2_STD 동일가(라이브 전 수량 확인)·도수0·옵션그룹0 → **등록범위=일반박·단면만**. FOIL_S1_STD+SETUP 배선(보강 불요). 홀로그램/양면은 **CPQ 옵션그룹 선결로 분리**.
3. **039 투명** = S1만 존재 → CLEAR_S1 배선(보강 불요). **보강 후 GO 불요·즉시 GO**.
4. **034 펄·040 화이트** = print_opt 보강 SQL은 포함하되 **자재 collapse(등록 MAT≠단가행 MAT)** 동반 → 자재 미해소면 견적불가. 자재 collapse는 **dbmap `namecard-mat-fix` 위임으로 분리** → 이 둘 GO는 **자재 해소 후**. (화이트는 추가로 코팅 CL/NOCL 차원도 필요 — §4.)

핵심 라이브 사실(§1)이 설계의 토대다.

---

## 1. 라이브 실측 사실 (2026-06-27 읽기전용 SELECT)

### 1.1 면 라우팅 메커니즘 (★결정적)
- `price_views.py:1377 _opt_maps` 주석/코드: **`OPT_REF_DIM.06`(도수)는 가격차원으로 변환 안 함** — "인쇄옵션은 별도 드롭다운". 즉 **면(단면/양면) 선택은 print_opt 드롭다운 → `selections["print_opt_cd"]`** (POPT_000001=단면 / POPT_000002=양면)로 evaluate_price에 전달된다.
- `pricing.py:42 NON_QTY_DIMS`에 `print_opt_cd` 포함 → **단가행 print_opt_cd가 NULL이면 와일드카드(면 무관 통과)**, 값이 있으면 선택 면과 정확매칭.
- **STD 기준선이 이중합산 0인 이유**: COMP_NAMECARD_STD_S1 단가행은 전부 print_opt_cd=POPT_000001, STD_S2는 전부 POPT_000002. 단면 주문 → STD_S2 행이 `_row_matches`에서 print_opt 불일치로 미매칭 → S1만 합산. (라이브 실측 확인.)

### 1.2 특수 6 comp 단가행 — print_opt_cd 전부 NULL (★난제 근원)
| 상품 | comp (S1/S2) | use_dims | 단가행 print_opt_cd | 행수 |
|---|---|---|---|---|
| 034 펄 | PEARL_S1/S2 | `[mat_cd,min_qty]` | **NULL** | 각 2 |
| 035 모양 | SHAPE_S1/S2 | `[siz_cd,min_qty]` | **NULL** | 각 1 |
| 036 미니모양 | MINISHAPE_S1/S2 | `[siz_cd,min_qty]` | **NULL** | 각 1 |
| 037 박 | FOIL_S1_STD/HOLO·S2_STD/HOLO | `[min_qty]` | **NULL** | 각 9 |
| 037 박셋업 | FOIL_SETUP_S1_STD·S2_STD | `[min_qty]`·`[]` | **NULL** | 각 1 |
| 039 투명 | CLEAR_S1 | `[min_qty]` | **NULL** | 1 |
| 040 화이트 | WHITE_S1W_CL/NOCL·S2W_CL/NOCL | `[mat_cd,min_qty]` | **NULL** | 각 1 |

→ STD와 달리 면이 **comp 코드(S1/S2)에만** 인코딩되고 단가행 차원엔 없음. S1·S2 동시 배선 시 같은 (mat/siz/qty)에 양쪽 매칭.

### 1.3 권위 가격표 구조 (B04~B09) — 단면/양면=별 **컬럼**(별 행 아님)
- B04 펄·B07 모양·B08 미니모양·B06 화이트: 단면가와 양면가가 같은 데이터행의 **다른 컬럼**에 병존 → 라이브 S1/S2 별 comp 분리가 권위 충실. **면은 가격차원이 맞고, comp 단위로 분리됨.**
- B09 박: 단면가=양면가(동일) — 면 무관, 박종류(일반박/홀로그램)와 수량이 가격축. 동판셋업비 5000 별도 합산.
- B06 화이트: 가격축이 면(단/양) × 클리어코팅(없음/단면/양면) **4조합**, 자재(큐리어스스킨 5색)는 **동일가(가격축 아님)**.

### 1.4 6 상품 등록 현황 (옵션·자재·도수·사이즈)
- **옵션그룹 0건**(6 상품 전부 CPQ 미구성). 면 선택은 print_opt 드롭다운으로만(034/035/036/039 도수 등록 有, 037/040 도수 0건).
- 자재 collapse(§6): 펄 등록 4종(MAT_128/129/240/241) vs 단가행 2종(MAT_127/130) **코드 불일치**. 화이트 등록 4종(MAT_138~141) vs 단가행 1종(MAT_137).
- 사이즈 정합: 035=SIZ_000008·036=SIZ_000011 — SHAPE/MINISHAPE 단가행 siz_cd와 일치(siz_cd는 NON_QTY_DIMS 정확매칭, 안전).

---

## 2. 라우팅 해법 — print_opt 보강 후 S1+S2 정식 배선 (★사용자 결정)

### 2.1 정석 = 단가행 print_opt_cd 태깅 + use_dims 보강 (STD와 동형)
특수 comp 단가행의 print_opt_cd(현재 전부 NULL·라이브 실측)를 채운다: `_S1*` comp 단가행 → POPT_000001(단면), `_S2*` comp 단가행 → POPT_000002(양면). 그리고 comp use_dims(jsonb)에 `"print_opt_cd"` 추가. 그러면 S1·S2 둘 다 addtn_yn=Y 배선해도 면 선택이 한쪽만 매칭(`_row_matches`: 단가행 print_opt_cd가 채워지면 선택 면과 정확매칭, 불일치 시 미매칭).
- **단가값 verbatim 불변**(unit_price 미변경). 변경분 = ① `t_prc_component_prices.print_opt_cd` UPDATE(현재 NULL일 때만·멱등) ② `t_prc_price_components.use_dims` UPDATE(`?` 가드로 이미 포함 시 skip·멱등).
- 이는 **단가행 차원 보강**이지만 라우팅 정합 필수분 → 사용자 결정에 따라 fix.sql에 **포함**(단계 ①②). 단가값·comp 정의·자재 불변.

### 2.2 보강 대상 행수 (라이브 실측 2026-06-27)
| comp | 태깅 print_opt_cd | NULL 행수(태깅 UPDATE) | use_dims UPDATE |
|---|---|---|---|
| SHAPE_S1 | POPT_000001 | 1 | `[siz_cd,min_qty]`→`+print_opt_cd` |
| SHAPE_S2 | POPT_000002 | 1 | 동상 |
| MINISHAPE_S1 | POPT_000001 | 1 | 동상 |
| MINISHAPE_S2 | POPT_000002 | 1 | 동상 |
| PEARL_S1 | POPT_000001 | 2 | `[mat_cd,min_qty]`→`+print_opt_cd` |
| PEARL_S2 | POPT_000002 | 2 | 동상 |
| WHITE_S1W_CL/NOCL·S2W_CL/NOCL | S1*→001·S2*→002 | 4(각1) | `[mat_cd,min_qty]`→`+print_opt_cd` (코팅은 §4 별도) |

→ **태깅 UPDATE = 035/036(4행) + 펄(4행) + 화이트(4행) = 12행. use_dims UPDATE = 035/036 comp 4 + 펄 comp 2 + 화이트 comp 4 = 10 comp.**
→ 035/036만 GO 후보(자재 무관). 펄·화이트의 태깅 12행 중 펄4·화이트4=8행은 **자재 collapse 선결 전엔 배선 보류**(SQL엔 태깅·use_dims 포함하되 바인딩은 자재 해소 후).

### 2.3 보강 불요 상품
- **037 박**: S1_STD=S2_STD 전 수량 동일가(라이브 확인 200~1000 전부 동일)·도수0·옵션그룹0 → 등록범위=일반박·단면만. **FOIL_S1_STD+SETUP만 배선**(면 무관 동일가라 print_opt 태깅 불요). 홀로그램(HOLO)·양면은 박종류 택일 옵션그룹 선결(§3·CPQ dbmap 위임).
- **039 투명**: CLEAR_S1만 존재(S2 없음). **S1 단독 배선**·이중합산 구조불가. 즉시 GO.

### 2.4 채택 (적재 단위)
- **보강 후 GO(fix.sql)**: 035 모양·036 미니모양 — print_opt 태깅(4행)+use_dims(4 comp)+PRF+S1/S2 배선+바인딩.
- **즉시 GO(보강 불요)**: 037 박(FOIL_S1_STD+SETUP)·039 투명(CLEAR_S1).
- **자재 선결(태깅·use_dims는 SQL 포함·바인딩 보류)**: 034 펄·040 화이트 — print_opt 태깅·use_dims는 fix.sql에 넣되 **바인딩은 자재 collapse(dbmap namecard-mat-fix) 해소 후**. 화이트는 코팅 차원(§4)도 선결.

---

## 3. 037 박 — 박종류·면·동판셋업 라우팅 (도수 0)

### 3.1 가격 구조 (권위 B09)
본체가 = 박종류 × 수량(200~1000, min_qty 구간). 면(단/양) 동일가.
- 일반박(금/은/먹유광·청/적/동박): FOIL_S1_STD / FOIL_S2_STD (200=19200 … 1000=63000)
- 홀로그램/트윙클: FOIL_S1_HOLO / FOIL_S2_HOLO (200=24800 … 1000=92000)
- 동판셋업비(아연판 기본): FOIL_SETUP_S1_STD / S2_STD = **5000 고정**(min_qty NULL=항상). 본체가에 **추가 합산**(addtn).

### 3.2 박종류 택일 라우팅 (★STD vs HOLO 동시매칭 위험)
FOIL_S1_STD·FOIL_S1_HOLO 둘 다 배선 + use_dims=`[min_qty]`(박종류 차원 없음) → 같은 수량에 **양쪽 매칭 → ERR_AMBIGUOUS 아님(별 comp라 각자 1행 매칭) → 둘 다 합산(과청구)**.
- 엔진 사실: ERR_AMBIGUOUS는 **한 comp 내** 동시매칭만 잡음. **서로 다른 comp는 각자 매칭되어 전부 합산**(addtn_yn=Y).
- → 박종류 택일은 **comp 선택을 가르는 차원**이 필요. 현재 단가행에 박종류 차원(opt_cd/proc_cd) 없음 → **둘 다 배선하면 STD+HOLO 동시 합산(과청구)**.
- **해법**: 박종류를 단가행 차원으로 태깅(use_dims에 opt_cd 또는 dim_vals `foil_type`) → 선택 시 한 comp만 매칭. **단가행 차원 추가(돈크리티컬·§5)**. 태깅 전에는 **STD만 배선(일반박 견적)** + 홀로그램은 옵션그룹 구성 후.

### 3.3 면 라우팅 (037)
면 무관 동일가 → 면 태깅(2.1)은 동시합산 방지용으로만 필요. 태깅 전 안전 = **S1 comp만 배선**(단면=양면 단가 같으므로 면 선택과 무관하게 정확). → **즉시 적재 가능: FOIL_S1_STD + FOIL_SETUP_S1_STD**(일반박·동판셋업).

### 3.4 037 채택 배선 (PRF_NAMECARD_FOIL)
| disp_seq | comp_cd | addtn_yn | 비고 |
|---|---|---|---|
| 1 | COMP_NAMECARD_FOIL_S1_STD | Y | 일반박 본체(min_qty 구간) |
| 2 | COMP_NAMECARD_FOIL_SETUP_S1_STD | Y | 동판셋업비 5000 추가합산 |

홀로그램(HOLO)·양면(S2)은 박종류 택일 옵션그룹 + print_opt 태깅 GO 후 추가(§5 돈크리티컬). 즉시분은 **일반박·단면/양면 동일가** 정확.

---

## 4. 040 화이트 — 코팅·면 라우팅 (도수 0)

### 4.1 가격 구조 (권위 B06)
가격축 = 면(단/양) × 클리어코팅 4조합. 자재 5색 동일가(가격축 아님).
| 가격표 조합 | 단가(100) | 라이브 comp |
|---|---|---|
| 화이트(단면)+클리어(없음) | 14500 | WHITE_S1W_NOCL |
| 화이트(단면)+클리어(단면) | 16000 | WHITE_S1W_CL |
| 화이트(양면)+클리어(없음) | 16000 | WHITE_S2W_NOCL |
| 화이트(양면)+클리어(양면) | 19000 | WHITE_S2W_CL |

→ comp 4개가 (면 S1/S2) × (코팅 CL/NOCL) 4조합을 1:1 표현. **코팅·면이 comp 코드에만 인코딩, 단가행 차원엔 없음**(mat_cd=MAT_137·min_qty만).

### 4.2 라우팅 (★면 + 코팅 둘 다 차원 필요·4중 동시매칭 위험)
4 comp 전부 배선 + 단가행 차원 없음 → 같은 (mat,qty)에 **4개 전부 매칭 → 4배 합산(65500)**. 면 태깅만으로는 부족: 단면 선택 시 S1W_CL+S1W_NOCL **둘 다** 매칭(코팅 미구분) → 여전히 이중합산. **면(print_opt) + 코팅(별 차원) 둘 다** 필요.
- **해법**: ① 면=print_opt_cd 태깅(S1*→001·S2*→002) ② 코팅=opt_cd 또는 dim_vals(`coat:CL`/`NOCL`) 태깅. 둘 다 단가행 차원 추가 → 선택 시 정확히 1 comp 매칭.
- 화이트는 **(a) print_opt 보강 (b) 코팅 차원 보강 (c) 자재 collapse 해소** 3중 선결 → **자재 트랙과 함께 dbmap 위임**. fix.sql엔 print_opt 태깅·use_dims만 포함(코팅·자재·바인딩은 보류).

### 4.3 040 처리 = 보류(자재+코팅+면 3중 선결)
- fix.sql: WHITE_S1*/S2* 4 comp에 print_opt 태깅(4행)+use_dims 보강만. **PRF·배선·바인딩은 미포함**(코팅 차원·자재 collapse 동반 GO).
- 코팅 차원·자재 전개·PRF 배선은 dbmap CPQ+자재 트랙 선결 후 별도. **본 설계는 면 보강 데이터만 선반영.**

---

## 5. 6 × 설계 종합

### 5.1 전용 PRF 정의 (신규 mint — frm_cd·frm_nm)
| frm_cd | frm_nm (실무진 용어·코드 비노출) | 유형 | 바인딩 상품 |
|---|---|---|---|
| PRF_NAMECARD_PEARL | 펄명함(스타드림) 면/소재/수량별 단가(용지포함) | 수량구간·자재축 | PRD_000034 |
| PRF_NAMECARD_SHAPE | 모양명함 면/수량별 단가(용지포함) | 수량구간·사이즈축 | PRD_000035 |
| PRF_NAMECARD_MINISHAPE | 미니모양명함 면/수량별 단가(용지포함) | 수량구간·사이즈축 | PRD_000036 |
| PRF_NAMECARD_FOIL | 오리지널박명함 박종류/수량별 단가 + 동판셋업비 | 수량구간·합산 | PRD_000037 |
| PRF_NAMECARD_CLEAR | 투명명함 수량별 단가(용지포함) | 수량구간 | PRD_000039 |
| PRF_NAMECARD_WHITE | 화이트인쇄명함 면/코팅/수량별 단가(용지포함) | 수량구간·조합 | PRD_000040 |

신규 PRF 6 = 무손실 표현 위해 필수(상품별 1:1, STD/PREMIUM/COAT는 자재만 다른 동형이나 특수는 산정구조 자체가 다름 — 펄=자재축·모양=사이즈축·박=박종류+셋업·화이트=면×코팅·투명=단순구간). search-before-mint: 기존 PRF 재사용 불가 입증(차원·합산구조 상이).

### 5.2 보강 후 배선 (fix.sql — print_opt 태깅으로 S1+S2 정식 배선·단가값 불변)
| frm_cd | disp_seq | comp_cd | addtn_yn | 면 라우팅(태깅 후) | 적재 |
|---|---|---|---|---|---|
| PRF_NAMECARD_SHAPE | 1 | COMP_NAMECARD_SHAPE_S1 | Y | 단면(POPT_000001 태깅) | **GO** |
| PRF_NAMECARD_SHAPE | 2 | COMP_NAMECARD_SHAPE_S2 | Y | 양면(POPT_000002 태깅) | **GO** |
| PRF_NAMECARD_MINISHAPE | 1 | COMP_NAMECARD_MINISHAPE_S1 | Y | 단면 | **GO** |
| PRF_NAMECARD_MINISHAPE | 2 | COMP_NAMECARD_MINISHAPE_S2 | Y | 양면 | **GO** |
| PRF_NAMECARD_FOIL | 1 | COMP_NAMECARD_FOIL_S1_STD | Y | 일반박·면 동일가(태깅 불요) | **GO** |
| PRF_NAMECARD_FOIL | 2 | COMP_NAMECARD_FOIL_SETUP_S1_STD | Y | 동판셋업 5000 추가합산 | **GO** |
| PRF_NAMECARD_CLEAR | 1 | COMP_NAMECARD_CLEAR_S1 | Y | S1만 존재(태깅 불요) | **GO** |
| PRF_NAMECARD_PEARL | 1 | COMP_NAMECARD_PEARL_S1 | Y | 단면 태깅(SQL有) | 자재 선결·**바인딩 보류** |
| PRF_NAMECARD_PEARL | 2 | COMP_NAMECARD_PEARL_S2 | Y | 양면 태깅 | 자재 선결·바인딩 보류 |

**035/036/037/039 = 보강 후 GO** (4 PRF·배선 = SHAPE 2 + MINISHAPE 2 + FOIL 2 + CLEAR 1 = 7행). 034 펄 PRF·배선은 SQL 작성하되 **바인딩만 보류**(자재 collapse 해소 후 GO). 040 화이트 = PRF/배선 미포함(코팅+자재 3중 선결).
이중합산 0 입증: S1+S2 둘 다 배선이나 단가행 print_opt_cd 태깅으로 면 선택 시 한쪽만 매칭(§7 GD).

### 5.3 fix.sql 보강 단계 (① 태깅 → ② use_dims → ③ PRF → ④ 배선 → ⑤ 바인딩)
| 단계 | 대상 t_* | 035/036(GO) | 펄(자재선결) | 화이트(보류) | 단가값 |
|---|---|---|---|---|---|
| ① print_opt 태깅 | component_prices.print_opt_cd | 4행(NULL→태깅) | 4행 | 4행 | 불변 |
| ② use_dims 보강 | price_components.use_dims(jsonb) | 4 comp | 2 comp | 4 comp | — |
| ③ PRF | price_formulas | 2(SHAPE/MINISHAPE)+FOIL+CLEAR=4 | PEARL 1 | (미포함) | — |
| ④ 배선 | formula_components | 4(S1+S2 각2)+FOIL 2+CLEAR 1=7 | PEARL 2 | (미포함) | — |
| ⑤ 바인딩 | product_price_formulas | 035·036·037·039=4 | (보류) | (보류) | — |

→ **태깅 UPDATE = 12행**(035/036 4 + 펄 4 + 화이트 4), 단 035/036만 GO. **use_dims UPDATE = 10 comp**. 펄·화이트 태깅/use_dims는 자재 트랙과 정합 위해 선반영하되 **바인딩은 보류**.

### 5.4 §6 코드/dbmap 위임분
- **자재 collapse(펄·화이트)**: 단가행 mat_cd가 등록자재와 코드 불일치 → mat_cd 정확매칭 견적불가. 권위대로 단가행 mat 전개(STD namecard-mat-fix 동형). **단가행 신규 행 추가 = SCOPE 밖** → dbmap 위임(`namecard-mat-fix` 패턴 확장). 펄·화이트 GO는 자재 해소 후.
- **박종류(HOLO)·양면·코팅 옵션그룹**: 6 상품 CPQ 옵션그룹 0건 → 박 홀로그램/양면·화이트 코팅 택일 UI 옵션·차원은 dbmap CPQ 트랙 위임. 037 즉시분 = 일반박·단면(등록범위 내)만.

---

## 6. 자재 collapse 상세 (§6 분리·돈크리티컬)

| 상품 | 등록 자재 | 단가행 mat_cd | 정합 | 처리 |
|---|---|---|---|---|
| 034 펄 | MAT_128 실버·129 골드·240 다이아·241 로츠쿼츠 | MAT_127(스타드림 대표)·MAT_130(로즈쿼츠) | **불일치**(코드 다름) | 권위 B04 그룹1(다이아/실버/골드=9000/10000)→MAT_240/128/129, 그룹2(로츠쿼츠=10000/11000)→MAT_241 전개. **단가 verbatim 복제** |
| 040 화이트 | MAT_138~141(화이트색 누락) | MAT_137(큐리어스스킨 대표) | 자재 무관(동일가) | 권위 B06 "5색 동일가" → mat_cd=NULL 와일드카드가 정합(STD와 달리 동일가라 안전) or 5색 전개. 화이트색 등록 누락 별도 |

→ 펄은 **견적불가**(현 단가행 mat 선택 불가), 화이트는 mat 무관이라 **현 1행이 mat_cd=MAT_137 명시면 등록자재 선택 시 미매칭→견적불가**. 둘 다 돈크리티컬. **본 설계 fix.sql은 배선/바인딩만**, 자재 전개는 dbmap `namecard-mat-fix` 확장으로 분리(단가행 추가 = SCOPE 밖).

> ★주의: 펄/화이트는 **자재 collapse 미해소 시 등록자재 선택 견적불가**(no_match). GO 확정 = 035 모양·036 미니모양·039 투명·037 박(자재 무관). 034 펄·040 화이트는 print_opt 태깅·use_dims는 SQL 선반영하되 **바인딩 보류**(자재 전개 §6 후 GO).

---

## 7. 골든 케이스 (권위 verbatim·단면/양면 둘 다·게이트 재현 대상)

엔진 = 단가형(PRICE_TYPE.01) → `unit_price × qty`. min_qty=100 단일 구간(100 미만=ERR_BELOW_MIN, 권위 정책). 박은 min_qty 200~1000 구간. **print_opt 태깅 후 단면=POPT_000001/양면=POPT_000002로 S1/S2 자동 라우팅.**

| # | 상품 | 선택 | qty | comp 매칭 | unit_price | 기대 final | 근거 |
|---|---|---|---|---|---|---|---|
| G1 | 035 모양 | siz=SIZ_000008·**단면** | 100 | SHAPE_S1(opt=001) | 18000 | **18000** | B07 단면 18000 |
| G1b | 035 모양 | siz=SIZ_000008·**양면** | 100 | SHAPE_S2(opt=002) | 19000 | **19000** | B07 양면 19000 |
| G2 | 035 모양 | 단면 | 200 | SHAPE_S1 | 18000 | **36000** | 18000×200 |
| G3 | 036 미니모양 | siz=SIZ_000011·**단면** | 100 | MINISHAPE_S1(opt=001) | 16000 | **16000** | B08 단면 16000 |
| G3b | 036 미니모양 | siz=SIZ_000011·**양면** | 100 | MINISHAPE_S2(opt=002) | 17000 | **17000** | B08 양면 17000 |
| G4 | 039 투명 | (자재무관)·단면 | 100 | CLEAR_S1 | 13500 | **13500** | B05 13500 |
| G5 | 037 박 | 일반박·단면 | 200 | FOIL_S1_STD(19200)+SETUP(5000) | — | **24200** | B09 200=19200 + 동판 5000 |
| G6 | 037 박 | 일반박·단면 | 500 | FOIL_S1_STD(36000)+SETUP(5000) | — | **41000** | B09 500=36000 |
| G7 | 037 박 | 일반박·양면 | 200 | FOIL_S1_STD(면 동일가)+SETUP | — | **24200** | B09 양면=단면 동일가 |
| G8 | 040 화이트 | 단면·무코팅·(자재 정합 시) | 100 | WHITE_S1W_NOCL | 14500 | **14500** | B06 화이트단면+클리어없음(자재 선결) |

### 이중합산 0 입증 골든 (★GO 필수 — print_opt 태깅 후 면 라우팅)
| # | 케이스 | 배선(S1+S2) | 기대 | 태깅 없으면(거짓 결과) |
|---|---|---|---|---|
| GD1 | 035 모양 단면 100 | SHAPE_S1+S2 둘 다 배선 | **18000**(S1만 매칭) | 태깅 전: S1·S2 단가행 print_opt NULL 와일드 → 둘 다 매칭 18000+19000=**37000 과청구**. 태깅 후 단면=001이라 S2(002) 미매칭 |
| GD2 | 035 모양 양면 100 | SHAPE_S1+S2 | **19000**(S2만 매칭) | 태깅 전: 둘 다 매칭 37000. 태깅 후 양면=002라 S1(001) 미매칭 |
| GD3 | 036 미니모양 양면 100 | MINISHAPE_S1+S2 | **17000**(S2만) | 태깅 전 33000. 태깅 후 002로 S2만 |
| GD4 | 037 박 단면 200 | FOIL_S1_STD+SETUP(HOLO 미배선) | **24200** | HOLO 배선 시 +24800=49000. 즉시분은 일반박만 배선이라 발생 안 함(HOLO=CPQ 선결) |

→ **print_opt 태깅이 이중합산 0의 핵심**: 035/036은 S1+S2 둘 다 배선해도 단가행 print_opt_cd(태깅 후)가 면 선택과 정확매칭하여 한쪽만 합산. 게이트가 GD1~GD3을 **태깅 전(37000 과청구) vs 태깅 후(18000/19000 정상)** delta로 재현 검증.

---

## 8. search-before-mint 집계

| 항목 | 신규/변경 | 재사용·불변 |
|---|---|---|
| price_components (comp 정의) | **0 신규** · use_dims UPDATE 10 comp(print_opt_cd 추가) | comp 14종 재사용·comp 신규 0 |
| component_prices (단가행) | **0 신규** · print_opt_cd 태깅 UPDATE 12행(NULL→코드) | **unit_price·자재·삭제 0 변경** |
| price_formulas (PRF) | **5 신규**(SHAPE·MINISHAPE·FOIL·CLEAR·PEARL) | 화이트 PRF는 미포함(보류) |
| formula_components (배선) | **9행**(SHAPE 2·MINISHAPE 2·FOIL 2·CLEAR 1·PEARL 2) | — |
| product_price_formulas (바인딩) | **4 GO**(035·036·037·039) · 펄/화이트 보류 | — |

**fix.sql = 태깅 12행 UPDATE + use_dims 10 comp UPDATE + PRF 5 + 배선 9 + 바인딩 4(GO). unit_price·comp 정의·자재·삭제 0 변경**(단가행 차원 컬럼 print_opt_cd만 채움). 채번 = frm_cd 이름기반·멱등(태깅은 print_opt_cd IS NULL 가드·use_dims는 `?` 가드).

---

## 9. 컨펌 큐 (게이트·인간 판단)

1. **GO 범위**: 035/036/037/039 보강 후 GO(자재 무관). 034 펄·040 화이트는 자재 collapse(§6) 선결 — print_opt 태깅·use_dims는 SQL 선반영하되 바인딩 보류. 자재 해소 후 GO.
2. **펄·화이트 태깅 선반영 가부**: 펄/화이트 태깅(8행)을 GO분과 함께 라이브 반영할지(라우팅만 준비) vs 자재 트랙과 한꺼번에 할지 인간 결정. 본 설계 SQL은 선반영(태깅·use_dims) + 바인딩 보류로 작성.
3. **037 동판셋업 양면**: SETUP_S2_STD use_dims=[]·min_qty NULL → 항상매칭. 즉시분은 S1_STD 단면만 배선(SETUP_S1_STD 1회)이라 셋업 중복 없음. 양면·HOLO 확장 시 셋업 단일성 재검토.
4. **화이트 코팅 차원·자재 등록 누락**: 040 면 보강만으로 불충분(코팅 CL/NOCL 미구분 시 동면 2 comp 동시매칭)·등록 4색에 화이트 누락 → dbmap CPQ+자재 트랙.
