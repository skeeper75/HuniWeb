# 화이트인쇄명함 PRD_000040 — 별색 flat 완제품가 모델 교정 설계 (§18)

생성 2026-07-01 · 설계+dryrun까지 · 실 COMMIT 없음 · DB 미적재 · 생성≠검증(골든 실호출·codex는 후속 hpe-validator 패스) · 라이브 읽기전용 실측 기반
권위: 골든 flat 완제품가(용지포함) 14,500 / 16,000 / 16,000 / 19,000 (qty=100) · 상품마스터(별색 화이트·클리어 = 별색·**코팅 미사용**) · `pricing.py evaluate_price`
입력 진단(재조사 안 함): `diag-whitenamecard-belsaek-260701.md` · `redprinting-whitenamecard-oracle-260701.md`(BCSPWHT)

---

## 0. 한 줄 결론

040 견적0의 실체 = **PRF_DGP_A(원자합산형) 오바인딩 + print_options 0건**. 별색 단가행이 print_opt NO_MATCH로 죽어 용지(6,213)만 청구.
교정 = **PRF_DGP_A 제거 → PRF_NAMECARD_WHITE(flat 완제품가) 재바인딩 + print_opt 선택수단 + 클리어 별색 opt_cd + mat_cd 와일드카드**. 4개 flat comp(이미 적재·미배선, id 3343~3346)가 골든과 정확 일치 → 배선만으로 골든 재현.
**코팅 모델 부활 금지** — 둘째 축 = 클리어 **별색**(상품마스터·RedPrinting BCSPWHT 확증).

---

## 1. 라이브 실측 (스냅샷 latest · 읽기전용)

| 사실 | 실측값 | 함의 |
|---|---|---|
| 040 현 바인딩 | `PRD_000040 → PRF_DGP_A`(2026-06-30 "020 원자모델 복제") | **오바인딩 — 제거 대상** |
| flat comp 단가행 | id 3343~3346: mat_cd=MAT_000137·print_opt 충전·**opt_cd 비어있음**·min_qty 100·14500/16000/16000/19000 | 골든 정확 일치. opt_cd 미충전 = ambiguous 위험 |
| flat comp 정의 | 4건 PRC_COMPONENT_TYPE.06·**PRICE_TYPE.02(합가형)**·use_dims=`[mat_cd,min_qty,print_opt_cd]` | flat 1행 매칭형(원자합산 아님) |
| PRF_NAMECARD_WHITE | **미존재**(price_formulas에 없음)·formula_components 0건 | 신설(mint) 필요 |
| 040 print_options | **0건** | 견적0 지배원인(단/양면 미공급→별색 NO_MATCH) |
| opt_grp 채번 MAX | OPT_000080(=037 박명함 박종류·점유) | 클리어 별색 = **OPT_000081** |
| opt 채번 MAX | OPV_000488(=037 홀로그램) | 클리어 별색 = **OPV_000489/000490** |
| 040 자재 | 활성 MAT_000362~365(색별·가격 동일)·MAT_000361/138~141 = del_yn=Y(소프트삭제됨) | MAT_000137 미등록 → **mat_cd 와일드카드 필연** |
| 040 공정 | PROC_000008(화이트 mand Y)·009(클리어)·027/028 | 클리어 = 공정 잔존(flat 모델에선 가격무해·§17 별 트랙) |

형제 선례(037 박명함 커밋): body use_dims=`[print_opt_cd,opt_cd,min_qty,opt_grp:OPT_000080]`·단가행 **mat_cd=NULL(와일드)**·opt_cd=OPV 충전. → 본 설계는 동형 미러.

---

## 2. 교정 설계

### (1) flat 공식 — PRF_NAMECARD_WHITE 신설 [search-before-mint]
- 검색: 라이브에 화이트명함 flat 공식 없음(PRF_DGP_A=원자합산·골든 구조적 미재현). 형제 PRF_NAMECARD_COAT/PEARL은 상품 전용 → 재사용 부적합.
- mint 정당: 원자합산형으로는 flat 완제품가(용지포함·축당 +1,500)를 무손실 표현 불가(diag §4 권위충돌). flat 1행 매칭 공식 신설.
- 명세: `PRF_NAMECARD_WHITE` / "화이트인쇄명함 면·클리어별색·수량별 단가(용지포함)" / use_yn=Y. **원자합산 아님 — flat comp 1행 매칭형.**

### (2) 배선 — formula_components (addtn_yn=Y)
| seq | comp_cd | id | 골든(q100) |
|---|---|---|---|
| 1 | COMP_NAMECARD_WHITE_S1W_NOCL | 3343 | 14,500 |
| 2 | COMP_NAMECARD_WHITE_S1W_CL | 3344 | 16,000 |
| 3 | COMP_NAMECARD_WHITE_S2W_NOCL | 3345 | 16,000 |
| 4 | COMP_NAMECARD_WHITE_S2W_CL | 3346 | 19,000 |

엔진은 4 comp 전부 평가하나 판별차원(§5)으로 주문당 **정확히 1행만** 매칭(나머지 mismatch=0). 합가형 1행 = flat 완제품가.

### (3) 재바인딩 [HARD·핵심]
- **DELETE** `t_prd_product_price_formulas WHERE prd_cd='PRD_000040' AND frm_cd='PRF_DGP_A'`. (원자합산형 제거 — 안 하면 PRF_DGP_A 별색/용지 비목이 flat과 **이중합산**.)
- **INSERT** `PRD_000040 → PRF_NAMECARD_WHITE`(apply_bgn_ymd 2026-06-01).
- 가드: 교정 후 040 바인딩 = PRF_NAMECARD_WHITE **단 1건**(이중배선 0 확인).

### (4) print_opt 선택수단 — t_prd_product_print_options(PRD_000040) [근본]
현 0건 = 견적0 지배원인. PRD_000033/037 패턴 미러:
| opt_id | print_side | front_colrcnt | back_colrcnt | dflt_yn | disp_seq | print_opt_cd |
|---|---|---|---|---|---|---|
| 1 | 단면 | CLR_000002(1도·흰별색) | CLR_000001(인쇄안함) | **Y** | 1 | POPT_000001 |
| 2 | 양면 | CLR_000002 | CLR_000002 | N | 2 | POPT_000002 |

(colrcnt = 화면 표시 메타데이터·엔진은 print_opt_cd만 매칭. 화이트=1도 별색 best-fit → minor CONFIRM. 037은 CMYK4도였으나 화이트명함은 백색토너 1도가 도메인 정합.)

### (5) 클리어 별색 opt_cd [코팅 아님·별색]
- **opt_grp 신설**: `OPT_000081` / "클리어(별색)" / SEL_TYPE.01(택1)·min1·max1·mand_yn=Y·use_yn=Y. (채번 MAX+1=080→081, 박명함 점유 회피.)
- **opt 신설**:
  - `OPV_000489` "클리어 없음" / opt_grp OPT_000081 / **dflt_yn=Y**(기본=없음·저가 가정 → CONFIRM)
  - `OPV_000490` "클리어 있음" / OPT_000081 / dflt_yn=N
- **단가행 opt_cd 충전**(UPDATE·값 불변):
  | id | comp | opt_cd |
  |---|---|---|
  | 3343 | S1W_NOCL | OPV_000489(없음) |
  | 3345 | S2W_NOCL | OPV_000489(없음) |
  | 3344 | S1W_CL | OPV_000490(있음) |
  | 3346 | S2W_CL | OPV_000490(있음) |
- **use_dims 갱신**(4 comp): `[mat_cd,min_qty,print_opt_cd]` → `[print_opt_cd,opt_cd,min_qty,opt_grp:OPT_000081]` (037 미러: mat_cd 드롭=와일드, opt_cd 추가, opt_grp UI 스코핑).
- **★코팅 라벨 금지**: opt_grp_nm·opt_nm 모두 "클리어"(별색)·"코팅" 표기 0. (comp_nm note에 "코팅" 잔존 = cosmetic·가격 무영향·optional 후속 정리·§7 플래그.)

### (6) mat_cd 와일드카드
- 단가행 3343~3346 `mat_cd` MAT_000137 → **NULL**(색 무관 매칭). 040 활성자재 MAT_000362~365(색별·가격 동일) 어느 것을 골라도 매칭. (037 FOIL 동일 선례.)
- use_dims에서 mat_cd 드롭(이미 (5)에 포함). NULL=와일드라 색별 단가차 없음(가격표 verbatim: 색 무관 동일가) → 무손실.

### (7) §17 굿즈 자재 오염 — 플래그만 (dryrun 미포함)
- MAT_000138~141(젤리볼펜·지비츠·다이어리내지·미니배너거치대) = **이미 del_yn=Y**(소프트삭제 완료·견적 무해). 추가 조치 불요.
- PROC_000009(클리어 공정) 잔존: flat 모델은 proc_cd 미매칭 → **가격 무해**(이중과금 0). UX상 클리어가 공정+옵션 이중 노출될 수 있음 → §17/상품기획 정리 별 트랙(본 dryrun 미포함).

---

## 3. 판별차원 disjoint 검증 [HARD] — silent-sum 0

엔진(`_row_matches`): 단가행에 판별 비수량차원 없으면 NULL=와일드→형제 동시매칭 과대. 본 설계는 **모든 주문이 단/양면 택1 + 클리어 택1 = 명시 2축**을 공급 → 각 행 disjoint.

| comp(id) | (print_opt, opt_cd) | 단면·클리어없음 | 양면·클리어있음 | 단면·클리어있음 | 양면·클리어없음 |
|---|---|---|---|---|---|
| S1W_NOCL(3343) | (POPT1, OPV489) | **매칭** | mismatch | opt mismatch | print mismatch |
| S1W_CL(3344) | (POPT1, OPV490) | opt mismatch | print mismatch | **매칭** | mismatch |
| S2W_NOCL(3345) | (POPT2, OPV489) | print mismatch | opt mismatch | mismatch | **매칭** |
| S2W_CL(3346) | (POPT2, OPV490) | mismatch | **매칭** | print mismatch | opt mismatch |

→ 각 주문 = 정확히 **1행** 매칭. mat_cd=NULL은 4행 공통 와일드(disjoint 영향 0). opt_grp 필수(mand_yn=Y)·dflt OPV_000489 → 미선택 주문도 explicit 없음값 공급(silent NULL 방지). **ERR_AMBIGUOUS 0 · 이중합산 0. PASS.**

핵심: 클리어를 공정(PROC_000009)이 아닌 **2값 택1 opt_grp**로 둔 이유 = 공정은 "있음/없음"의 없음을 NULL=와일드로밖에 표현 못해(형제 NOCL 동시매칭) disjoint 불가. opt_grp 택1만 명시 "없음"값을 공급 → mint 정당(search-before-mint: PROC_000009 재사용 시 무손실 disjoint 불가 입증).

---

## 4. 골든 케이스 (검증가 재현 대상 · qty=100)

합가형 PRICE_TYPE.02 = tier ÷ min_qty × qty. tier·min_qty 모두 100 → 정수 일치.

| # | 선택 | 매칭 행 | 기대 골든 | 현재(결함) |
|---|---|---|---|---|
| G1 | 단면·클리어없음·100 | 3343 | **14,500** | 6,213(별색0·용지만) |
| G2 | 단면·클리어있음·100 | 3344 | **16,000** | 6,213 |
| G3 | 양면·클리어없음·100 | 3345 | **16,000** | 6,213 |
| G4 | 양면·클리어있음·100 | 3346 | **19,000** | 6,213 |

재현 조건: 재바인딩(PRF_DGP_A 제거) + 4 comp 배선 + print_opt 2 + opt_cd 충전 + mat 와일드. **PRF_DGP_A 잔존 시 골든 깨짐(이중합산).**
**qty≠100 = §26 선행** — flat comp는 qty=100 단일 tier만 적재. PRICE_TYPE.02 프로레이팅이라 q200=14500/100×200=29000(권위 200tier 보장 없음). 골든은 **qty=100 한정 유효**. tier 충전 = §26 무결성/§7 적재 선행(명시).

---

## 5. search-before-mint 정리

| 항목 | 검색결과 | 판정 |
|---|---|---|
| flat 공식 | 화이트명함 flat 공식 부재·PRF_DGP_A=원자(미재현) | **mint PRF_NAMECARD_WHITE**(무손실 불가 입증) |
| flat comp 4 | 이미 적재(3343~3346·골든 일치) | **재사용**(신규 0) |
| 단/양면 | POPT_000001/000002 라이브 | **재사용**(mint 0) |
| 클리어 판별 | PROC_000009 공정 존재하나 "없음" disjoint 표현 불가 | **mint OPT_000081 택1**(정당) |
| 클리어 opt | 부재 | **mint OPV_000489/490**(MAX+1) |
| mat_cd | MAT_000137 미등록·활성 색별 동일가 | **와일드(NULL)** — 037 선례 |

신규 mint 총계: 공식 1(PRF_NAMECARD_WHITE)·opt_grp 1(OPT_000081)·opt 2(OPV_000489/490)·print_options 2행. UPDATE: 단가행 8셀(opt_cd 4 + mat_cd→NULL 4·값 불변)·use_dims 4. DELETE+INSERT: 재바인딩 1.

---

## 6. 잔여 CONFIRM 큐

| # | 항목 | 가정 | 영향 |
|---|---|---|---|
| C1 | 클리어 기본값 | **클리어 없음**(저가·dflt OPV_000489) | 가격 직접(기본 견적가) · goods.asp/실무진 확인 |
| C2 | 색별 동일가 | 가격표 verbatim = 색 무관 동일(와일드 안전) | mat 와일드로 해소·재확인만 |
| C3 | qty≠100 tier | 100장만 적재 | §26 선행·골든 q100 한정 |
| C4 | white colrcnt | CLR_000002(1도 별색) best-fit | 표시 메타·가격 무영향(minor) |
| C5 | PROC_000009 잔존 | flat에선 가격무해·UX 이중노출 | §17 별 트랙(minor) |
| C6 | comp_nm "코팅" 라벨 | cosmetic·opt naming=별색 우선 | 후속 정리(가격 무영향) |

---

## 7. 인간 승인 게이트 / 라우팅

- 설계 완결: 재바인딩(★) + 4 body 배선 + print_opt 2 + 클리어 별색 opt + mat 와일드 = **disjoint·골든 재현(q100)·BLOCKED 0**.
- 실 COMMIT = 인간 승인 후 §7 dbmap 트랙(`dbm-load-execution`·`hsp-load-execution` 아님). webadmin 코드 직접수정 금지(C-track 아님 — 데이터/모델 교정).
- 선행 의존: qty≠100 tier(§26). 미진행해도 q100 골든은 유효.
- 검증: 본 설계=생성측. hpe-validator(E1~E7 골든 실호출 PRICE≠0)·codex Phase5.5 후속(독립).
</content>
</invoke>
