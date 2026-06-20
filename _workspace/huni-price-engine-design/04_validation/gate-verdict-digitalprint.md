# gate-verdict-digitalprint.md — 디지털인쇄 설계 E1~E7 독립 검증

> **hpe-validator 게이트 판정.** engine-designer 설계(03_design)를 라이브 재실측으로 독립 검증.
> 생성자 주장 비신뢰 — 셀/단가행/코드 직접 재대조. 라이브 읽기전용 SELECT만 · 실측 2026-06-20.
> 전건 PASS=GO · 단일 FAIL=NO-GO. 각 결함에 재현 SQL/코드 라인.

---

## 판정 요약

| 게이트 | 판정 | 핵심 |
|--------|------|------|
| E1 공식 추출 충실성 | **PASS** | cartographer 지도·설계가 라이브 공식/단가행 충실 반영(셀 재대조 일치·날조 0·v03 인용 0) |
| E2 구성요소 분해 정합 | **CONDITIONAL** | comp 분해는 SOT 안·정합. 단 인쇄면 이중인코딩(S1/S2 comp)이 이중합산 유발(V-DGP-1) — 설계 미인지 |
| E3 경쟁사 흡수 타당성 | **PASS** | C-2/C-4 = data-gap(constraints 그릇 10행 실재)·신규 가격축 0·naming 유입 0·답습 아님 |
| E4 엔진 설계 건전성 | **CONDITIONAL** | search-before-mint 충족(대형박 1건만 신설 정당). 단 D-3 해법이 ERR_AMBIGUOUS 아닌 이중합산을 겨냥해야 정확 |
| E5 세트 조합 정합 | **FAIL** | 엽서북 "이중계상 0" 판정이 라이브에서 거짓 — S1+S2 이중합산 + prc_typ ×qty 미인지 |
| E6 골든 재현 | **FAIL** | 고정가형 골든 6/7 불일치(×qty 과대청구). 단 진원=라이브 결함이지 설계 골든값 오류 아님 |
| E7 생성-검증 독립성 | **PASS** | 검증가 자체 라이브 실측·pricing.py 직접 실행으로 designer 주장 교차(self-approve 0) |

**종합: NO-GO (조건부 — 보정 후 재게이트).** E5·E6 FAIL. 단 FAIL의 본질은 "설계가 만든 값이 틀림"이 아니라
"설계가 라이브 결함의 **범위·메커니즘을 오판**하고 일부를 컨펌큐로만 미뤘다"이다. 보정 가능.

---

## E1 — 공식 추출 충실성 `PASS`

**검사**: 설계/cartographer가 라이브 PRF·comp·단가행을 충실히 인용했나. 날조/v03 인용 없나.

**재실측 대조**:
- PRF_NAMECARD_FIXED 배선 = STD_S1·STD_S2 2 comp (설계 §3.0 주장과 일치).
  ```sql
  SELECT disp_seq, comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED';
  -- 1|COMP_NAMECARD_STD_S1  2|COMP_NAMECARD_STD_S2  ✓
  ```
- 명함 variant 25 comp 전부 실재·use_yn=Y·del_yn=N (설계 §3.1 "orphan comp 실재" 일치).
  COAT 5500/6500·PREMIUM 4500·FOIL 9구간(200~1000) 단가값 verbatim 일치.
- 별색 형제 comp del_yn=Y·정본 WHITE_S1 — component-inventory §2 일치(재대조 생략, 직전 dedup 정합).
- v03 인용 0 — 설계는 라이브 t_prc_* + 가격표260527만 출처.

**판정 PASS** — 추출/인용 충실. 단가값 날조 0. (단 cartographer가 "NAMECARD 단가행 결손"이라 한 부분은
설계가 라이브 재실측으로 "충전됨"으로 정정 — 정정이 옳음, 단가행 실재 확인).

---

## E2 — 구성요소 분해 정합 `CONDITIONAL`

**검사**: 설계 comp가 시트 차원경계(SOT 1) 안인가. silent 합산·의미축 이중 인코딩 없나.

**정합 부분**:
- 명함=완제품 통합단가 comp만(종이 후가공 comp 침입 0·R-4 준수·설계 D-9 일치). ✓
- 별색=단일 comp + 색×면 차원(분할 금지 준수). ✓

**★결함 V-DGP-1 (의미축 이중 인코딩 → silent 이중합산)**:
- 인쇄면(단면/양면)이 **comp_cd에 인코딩**(STD_S1 vs STD_S2)되어 PRF_NAMECARD_FIXED에 **둘 다 배선**.
- 두 comp 모두 `print_opt_cd=NULL`(판별차원 없음) → `_row_matches`(pricing.py:78-90)가 둘 다 통과.
- `_evaluate_formula`(:457-474)가 disp_seq 순으로 **둘 다 합산** → 단면+양면 silent 이중합산.
  ```sql
  SELECT DISTINCT comp_cd, print_opt_cd FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_STD%';
  -- STD_S1|(null)  STD_S2|(null)   ← 인쇄면 차원 비어있음 → 둘 다 항상 매칭
  ```
- 설계는 이를 "ERR_AMBIGUOUS"(D-2b)로 진단했으나 실제는 **조용한 이중합산**(경고 없이 과청구).
  인쇄면은 **차원**(print_opt_cd)으로 인코딩해야 하는데 **comp**로 이중 인코딩한 게 진원.
  엽서북 PCB도 동형(S1_20P/S2_20P 둘 다 배선).

**판정 CONDITIONAL** — 분해는 SOT 안·정합하나, 인쇄면 이중인코딩이 silent 이중합산을 만들고 설계가 이를
ERR_AMBIGUOUS로 오진단. 보정 = 인쇄면을 print_opt_cd 차원으로 통합(comp 1개)하거나 print_opt_cd 충전.

---

## E3 — 경쟁사 흡수 타당성 `PASS`

**검사**: C-2/C-4 흡수가 답습/naming 유입 아닌가. data-gap 판정 타당한가. 신규 가격축 0인가.

**재실측**:
- CPQ constraints 그릇 `t_prd_product_constraints` **실재**(10행·logic 컬럼).
  → C-2(자재×허용수량)·C-4(자재×후가공비활성)는 **vessel-gap 아닌 data-gap** 확정(설계 D-7 일치).
  ```sql
  SELECT COUNT(*) FROM t_prd_product_constraints;  -- 10  (그릇 실재)
  ```
- 신규 테이블 0·신규 가격축 0(설계 흡수 종합판정 일치).
- naming 유입 0 — 설계가 `offset2023_price`·`MTRL_CD` 등 RP 토큰 후니 유입 금지 명시(가드 준수).
- C-1/C-3/C-5는 네이밍/표현력/UX 수준(가격축 아님)으로 정직 분류 — 답습 아님.

**판정 PASS** — 흡수 타당·data-gap 판정 옳음·후니 표현력 초과 mint 0.

---

## E4 — 엔진 설계 건전성 `CONDITIONAL`

**검사**: evaluate_price 계약 정합·search-before-mint·채번·variant별 PRF가 진짜 해소책인가.

**정합 부분**:
- search-before-mint **강하게 충족**: COMP_FOIL_LARGE(대형박) 라이브 부재 재확인 → 신설 정당.
  ```sql
  SELECT comp_cd FROM t_prc_price_components WHERE comp_cd ILIKE '%FOIL%';
  -- COMP_NAMECARD_FOIL_* (소형박만)·대형박 COMP_FOIL_LARGE 없음 ✓
  ```
  나머지 명함/포토카드/엽서북 comp 전부 실재 → orphan 바인딩(신규 mint 0). ✓
- 직접단가/템플릿단가 0행 → 전 상품 FORMULA 경로(C1 정합). ✓
- variant별 전용 PRF(D-1)는 use_dims 상이(STD/COAT=mat_cd·PREMIUM=none·SHAPE=siz_cd) →
  한 공식에 묶으면 ERR_AMBIGUOUS 정당(PREMIUM_MGA/MGB 둘 다 [min_qty]만 → 동일 combo). **이 부분은 D-1 정확**.

**★조건 (E2 연동)**:
- D-3 "print_opt_cd 차원 충전 → ERR_AMBIGUOUS 해소"는 **타깃 오인**. print_opt_cd 충전이 푸는 것은
  S1/S2 이중합산(V-DGP-1)이지 ERR_AMBIGUOUS가 아님(별 comp는 ambiguous 안 됨). 해법 자체는 옳으나
  **사유가 틀림** → 충전이 이중합산을 막는다는 정확한 근거로 재서술 필요.
- print_opt_cd 충전 가능성 확인: `t_prd_product_print_options`에 단면=POPT_000001·양면=POPT_000002 실재.
  ```sql
  SELECT opt_id, print_side, print_opt_cd FROM t_prd_product_print_options WHERE prd_cd='PRD_000033';
  -- 1|단면|POPT_000001  2|양면|POPT_000002  ← 코드 실재, 단가행에 충전 가능
  ```
  단 option_items 매핑 0행(Q15) → 옵션선택→차원 자동주입 경로 미연결(설계 G-7 컨펌큐 정당).

**판정 CONDITIONAL** — 설계 골격 건전(search-before-mint·variant PRF·채번). 단 D-3 사유 오기(ambiguous→이중합산).

---

## E5 — 세트(반제품) 조합 정합 `FAIL`

**검사**: 엽서북/포토카드 세트 가격 합성 무모순인가. 이중계상 0인가.

**★결함 (설계 §set-product 거짓 판정)**:
설계 §1.2/D-5는 "엽서북=고정가 단일·이중계상 0·완제품 통합단가"라 판정. **라이브 재계산이 반증**:
- PRF_PCB_FIXED = [S1_20P, S2_20P] 둘 다 배선 → **단면+양면 이중합산**(GC-7 q2: 22,000+23,000=45,000).
  설계가 "이중계상 금지 가드"라 강조한 그 이중계상이 **인쇄면 축에서 실제로 발생**.
- 게다가 PCB도 단가형(prc_typ=01)·단가=묶음총액 → ×qty 과대청구(D-10 동형). 설계는 PCB의 prc_typ 결함을
  **전혀 언급 안 함**(명함 D-10만 다룸).
  ```sql
  SELECT comp_cd, prc_typ_cd FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_PCB%';
  -- 전부 PRICE_TYPE.01(단가형)  +  단가행 2매=11000(=묶음총액)  → ×qty 폭발
  ```
- 포토카드 SET/BULK 판별(bdl_qty)은 정합하나, BULK도 단가형 ×qty 결함(GC-6 950,000).

**판정 FAIL** — 엽서북 "이중계상 0" 판정이 라이브에서 거짓. PCB의 두 결함(이중합산·prc_typ ×qty)을 설계가 누락.
보정 = 엽서북/포토카드BULK를 명함과 동일 결함군(D-10 범위)에 포함시키고 인쇄면 차원 통합.

---

## E6 — 골든 재현 `FAIL`

**검사**: 설계 golden-cases를 라이브 실호출/동치재계산해 권위 골든값과 대조(허용오차 0).

`recompute-log.md` 전체 참조. 고정가형 7 케이스 중 **6 불일치**(SET만 우연 정합):

| 골든 | 설계 기대 | 재계산 | 판정 |
|------|-----------|--------|------|
| GC-1 명함 q100 | 3,500 | 350,000 / 800,000 | ❌ |
| GC-3 코팅명함 | 5,500 | STD misfire(350,000+) | ❌(D-2a) |
| GC-4 박 q300 | 29,800 | 8,940,000 | ❌ |
| GC-5 포토카드 SET | 6,000 | 6,000 | ✅ |
| GC-6 포토카드 BULK | 9,500 | 950,000 | ❌ |
| GC-7 엽서북 q2 | 11,000 | 45,000 | ❌ |
| GC-8 엽서북 q20 | 5,200 | 212,000 | ❌ |

**dodge-hunt**: 순환참조 0 확인 — 설계 골든값(3500 등)은 가격표 verbatim으로 옳고, 재계산값은 라이브 단가행
×엔진 환산. 불일치 진원 = **라이브 prc_typ 단가형 오적재(묶음총액에 ×qty) + 인쇄면 차원 부재**(이중합산),
설계 골든값 오류 아님. 즉 **"설계 골든은 맞고 라이브가 틀렸다"** — 단 설계가 이 결함 범위를 D-10 컨펌큐로만 미뤄
"GO처럼 보이는 골든"을 제시한 게 문제.

**판정 FAIL** — 골든 재현 허용오차 0 미충족. 결함은 라이브측이나, 설계가 골든을 "정합 기대값"으로 제시하면서
실제 라이브 산출(×qty 폭발)과의 간극을 D-10 한 칸으로만 처리 → 골든 테이블 자체가 라이브 미반영.

---

## E7 — 생성-검증 독립성 `PASS`

- 검증가는 designer 주장(D-2a/D-2b/D-10)을 **재유도하지 않고 라이브로 직접 교차**:
  pricing.py 순수 헬퍼를 소스에서 import해 실제 실행·단가행 psql 직접 주입.
- designer "D-2b=ERR_AMBIGUOUS" 주장을 **반증**(실제는 이중합산) — 무비판 수용 0.
- designer "엽서북 이중계상 0" 주장을 **반증**(실제 이중합산) — self-approve 0.
- 라이브 읽기전용 SELECT만·DB 쓰기 0.

**판정 PASS**.
