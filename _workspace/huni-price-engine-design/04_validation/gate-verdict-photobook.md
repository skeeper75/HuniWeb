# gate-verdict-photobook.md — 포토북 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 재실측 — 생성자(hpe-engine-designer) 주장 비신뢰·라이브 직접 SELECT(2026-06-22 읽기전용)·권위 엑셀 절대.**
> 검증 대상: `03_design/engine-design-photobook.md`·`golden-cases-photobook.md`.
> 기준점: `01_formula/{formula-map,component-inventory,gap-board}-photobook.md`·`02_benchmark/absorption-candidates-photobook.md`(C-PB1~7).
> 라이브 권위: `pricing.py`(`raw/webadmin/webadmin/catalog/pricing.py`)·Railway t_prc_*/t_prd_*. 골든 = `photobook-l1.csv` verbatim 직독(순환참조 0). 재계산 상세 = `recompute-log-photobook.md`.

---

## 종합: **GO** (E1~E7 전건 PASS·차단 0·보정 0·LOW 2)

포토북 종단 = 10번째 종단·**반제품 세트(부품합산형 + 페이지 선형)**. designer 설계를 라이브 직접 SELECT + pricing.py 코드 + python 골든 독립 재산출(권위 CSV verbatim·설계값 비사용)로 재실측한 결과, **골든 GC-PB-1~10 허용오차 0 재현·돈크리티컬 가드 전부 입증·BLOCKED 정직 확인**. designer가 §0.1에서 주장한 stale 정정 2건(아트250 단가행 실재 77.75·COMP_COAT_MATTE 실재+92행 충전)을 라이브 직접 SELECT로 독립 확인. 차단 결함 0. LOW 2건(① COMP_BIND_PUR·표지자재 MAT_005/006/007 del_yn=Y 미플래그 ② 소프트 base_min=4 라이브 page_rule 미저장=Q-PB-PAGEBASE 돈크리티컬이나 honest 컨펌큐로 정직 처리).

| 게이트 | verdict | 핵심 근거(라이브 실측) |
|--------|---------|------------------------|
| E1 공식 추출 충실성 | **PASS** | row17 `상품단가+페이지당단가적용` 명문·base24/per2p CSV verbatim 전건 일치·v03 인용 0·stale 정정 2건 라이브 확인 |
| E2 구성요소 분해 정합 | **PASS** | base24[siz,mat] 2차원·per2p[siz] 1차원 차원분리·시트경계 안·세트 sub_prd 가격 비기여(이중계상 가드) |
| E3 경쟁사 흡수 타당성 | **PASS** | naming 유입 0(PHBK/seneca/CVR_MTRL_CD/book2025 흔적 0)·새 가격축 0·페이지폭발 GAP을 합산형 공식으로 흡수(C-PB1) |
| E4 엔진 설계 건전성 | **PASS** | pricing.py 계약 정합·단가형 .01 ×qty·PRODUCT_PRICE 선점 가드·search-before-mint(공식1+comp2만·PRF_BIND_SUM 공유 부결 근거 라이브 확인) |
| E5 세트 조합 정합 | **PASS** | t_prd_product_sets 100=7행 실측(BOM·가격 비기여)·표지 택1·면지 비기여·이중계상 0 |
| E6 골든 재현 | **PASS** | GC-PB-1~10 허용오차 0(권위 CSV verbatim·pricing.py 동치)·GC-PB-11/12 BLOCKED 정당 |
| E7 생성검증 독립성 | **PASS** | 라이브 직접 SELECT·권위 CSV 직독·python 독립 재산출·dodge 0·designer del_yn=Y 미플래그 적발(무비판 수용 없음) |

---

## E1 — 공식 추출 충실성 · **PASS**

**검사**: cartographer 지도가 상품마스터 공식·가격표 차원을 충실히 담았나(셀 재대조·날조/누락·v03 인용).

- **row17 명문 산식 확인**(CSV row17 셀 직독): `"상품단가+페이지당단가적용"` + `"그레이칼라는 노출안되는 정해진 사양"` + `"핑크는 편집기를 통해 나오는 사양이므로 옵션노출 없음"`. 설계 §3.2 E-3 인용 충실.
- **base24/per2p CSV verbatim 전건 일치**(recompute-log §0): 15,000/23,000/12,000/22,000/32,000/공란/12,000/19,000/10,000/16,000/26,000/13,000 + per2p 500/500/500/1000/1000/공란/300/300/300/600/600/600. 설계 §4.1·§4.2 단가행과 셀 단위 일치(날조 0).
- **포토북 전용 가격표 시트 부재** 확인 — formula-map §5 인용(가격표 260527 19시트 중 포토북 없음). 권위 = 상품마스터 inline. cartographer 충실.
- **★stale 정정 2건 라이브 독립 확인**(designer §0.1 주장 비신뢰·직접 SELECT):
  - 아트250 용지: `COMP_PAPER MAT_000081 SIZ_000499 = 77.75` 실재 → cartographer gap-board G-PB-3 "0행" stale 확정.
  - COMP_COAT_MATTE: 실재(prc_typ=.01·del_yn=N) **+ 단가행 92행 충전**(comp 존재≠단가행 충전 가드 통과) → Q-PB-COAT comp 소스 해소 확인.
- **v03 인용 0·STALE 0**. 권위 순서(상품마스터>가격표>라이브>역공학) 준수.

증거 SQL:
```
SELECT comp_cd,mat_cd,siz_cd,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND mat_cd IN ('MAT_000105','MAT_000081');
  → MAT_000105 SIZ_499 77.03 / MAT_000081 SIZ_499 77.75
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_COAT_MATTE'; → 92
```

---

## E2 — 구성요소 분해 정합 · **PASS**

**검사**: 구성요소가 시트 차원경계(SOT 1) 안인가·silent 합산 오배선·의미축 이중 인코딩·완제품/반제품 오구분.

- **차원 분리(C-PB4·돈크리티컬)**: base24 comp=`[siz_cd, mat_cd]` 2차원(표지타입이 base 가름)·per2p comp=`[siz_cd]` 1차원(표지 무관). CSV 실측 입증: 8x8 per2p=500(하드/레더하드/소프트 전건 동일)·표지 무관. **per2p에 mat_cd 넣으면 단가행 중복·오청구 → 정확히 분리**.
- **silent 이중합산 회피**: base24·per2p = 서로 다른 comp_cd → `_combo_key`(pricing.py:93-95) 다름 → 각자 1행 매칭·ERR_AMBIGUOUS(:136-138) 불가. **단 base24 mat_cd 단가행 충전 필수**(NULL이면 `_row_matches`:81-84 와일드카드로 소프트/하드 모두 매칭=silent flat → G-PB-FLAT 가드 정합).
- **시트 차원경계(U-7)**: PRF_PHOTOBOOK_SUM = base24+per2p 2 comp만. 타 상품군 comp 침입 0. 표지/내지/제본/면지 부품은 base24에 internalize(외부 미배선) → COMP_BIND_PUR이 `t_prc_formula_components` 0행(어느 공식에도 미배선) 라이브 확인 = internalize 정합.
- **완제품/반제품 구분**: 포토북 = 반제품 세트(부모 PRD_000100·PRD_TYPE.04 + 7 sub_prd). 책자 full 분해와 결정적 차이(base24 통합 vs 부품 합산)·benchmark P-9a 흡수 정합.

증거 SQL:
```
SELECT frm_cd FROM t_prc_formula_components WHERE comp_cd='COMP_BIND_PUR'; → 0행(internalize 정합)
SELECT comp_cd FROM t_prc_price_components WHERE comp_cd ILIKE '%PHOTOBOOK%'; → 0행(신규 mint·미배선)
```

---

## E3 — 경쟁사 흡수 타당성 · **PASS**

**검사**: benchmark 흡수가 답습 아닌 흡수인가·naming/codes 유입 0·후니 표현력으로 담김.

- **C-PB1 핵심 흡수**: 페이지 증분 단가를 **(a) 합산형 공식 + 앱 증분환산**으로 표현(고정가형 product_prices 단독 = 페이지 64단계 SKU 폭발 GAP). 흡수 실질 = 1건. RedPrinting 면당단가×페이지·WowPress 작업량 2단을 후니 단일 evaluate_price + 앱 환산으로 흡수(C-PB7 과분화 부결 정합).
- **C-PB2~5 동형/정합**(흡수 불요): 표지×사이즈 매트릭스=`[siz,mat]` 2차원·에디터=주문채널·추가단가 사이즈 종속·책등=앱 파생. 후니 그릇이 직접 담음.
- **naming 유입 0(라이브 실측)**: 신규 comp_cd = COMP_PHOTOBOOK_BASE/PAGE(후니 컨벤션)·PHBK/PHBKMYB/TPPHSET/seneca/CVR_MTRL_CD/book2025/RXART250 흔적 0. 표지타입=mat_cd(MAT_000005~007)로 번역·RedPrinting codes 미유입.
- 권위 덮어쓰기 0: 상품마스터 base24 verbatim 최종·경쟁사=갭헌팅 보강(C-PB6 제약은 round-6 CPQ 위임).

---

## E4 — 엔진 설계 건전성 · **PASS**

**검사**: evaluate_price 계약 정합·search-before-mint·채번·FK·차원 자동매칭.

### E4-a. 단가형 .01 ×qty (라이브+코드 입증)
- base24·per2p 둘 다 `.01` 단가형 설계. pricing.py `component_subtotal`(:191-192) `return up * q, up` = 단가×수량 = 정답. min_qty=1 전건(단가형 ×qty=부수·×1 정합).
- **G-PB-BIND01**: `.02` 합가형 오적용 시 `if base<=0: raise ValueError`(:185-188) = ÷min_qty 붕괴. base24·per2p=.01·min_qty=1(NULL 금지) → 가드 정당. COMP_BIND_PUR도 .01(라이브 확인)·base24 internalize.

### E4-b. PRODUCT_PRICE 선점 가드 (G-PB-PRODPRICE·코드 입증)
- pricing.py :315-326: `if cur_pp and cur_pp["unit_price"] is not None: source="PRODUCT_PRICE"` → FORMULA 분기(:319-326)는 pp의 else → **product_prices 1건이라도 INSERT하면 FORMULA(per2p 페이지 가산) 통째 우회 silent**. 라이브 PRD_000100 product_prices **0행**(`SELECT count(*) … → 0`)이라 선점 위험 0·자동충족. designer "INSERT 금지·공식 base comp로" 가드 정당.

### E4-c. search-before-mint (라이브 확인)
- 신규 = **공식 1(PRF_PHOTOBOOK_SUM) + comp 2(BASE/PAGE)뿐**. COMP_PHOTOBOOK_* = 라이브 0행(신규 정당).
- **PRF_BIND_SUM 공유 부결 근거 라이브 확인**: `SELECT … WHERE frm_cd ILIKE '%BIND_SUM%'` → comp = `COMP_BIND_JUNGCHEOL` 단일(중철). 포토북 base24+per2p와 comp 집합 근본 상이 → 공유 시 misfire → 전용 공식 신설 무손실 정당.
- 인쇄/용지/제본/코팅 comp 전부 라이브 재사용(COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_BIND_PUR·COMP_COAT_MATTE 실재). search-before-mint 10연속 통과.

### E4-d. 차원 자동매칭
- pricing.py NON_QTY_DIMS(:38)에 siz_cd·mat_cd 포함. base24 = mat_cd 판별·per2p = siz_cd만 → combo_key 다름 → 동시매칭 회피 정합. base24 mat_cd 단가행 충전 시 소프트/하드 정확 1행(G-PB-FLAT).

증거 SQL:
```
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000100'; → 0(WIRE·바인딩 필요)
SELECT count(*) FROM t_prd_product_prices WHERE prd_cd='PRD_000100'; → 0(선점 위험 0)
SELECT frm_cd,comp_cd FROM t_prc_formula_components WHERE frm_cd ILIKE '%BIND_SUM%'; → PRF_BIND_SUM/COMP_BIND_JUNGCHEOL(1행)
SELECT prd_cd,dsc_tbl_cd FROM t_prd_product_discount_tables WHERE prd_cd='PRD_000100'; → 0행(Q-PB-DSC=수량구간할인 미해당 확인)
```

---

## E5 — 세트(반제품) 조합 정합 · **PASS**

**검사**: 세트 합성 무모순·이중계상·구성품 누락·번들 할인.

- 라이브 실측: `t_prd_product_sets WHERE prd_cd='PRD_000100'` → **정확히 7행**(reg_dt 2026-06-03·전건 del_yn=N·sub_prd_qty=1). note = 내지=몽블랑130(101)/표지=하드커버(102)/표지=아트250+무광코팅(103)/면지=그레이(104)/표지=레더하드커버(105)/표지=레더(106)/표지=소프트커버(107). 설계 §5·§0.1 verbatim 일치.
- **이중계상 가드(G-PB-SET)**: 표지 5 variant(102/103/105/106/107)는 **택1**(base24가 선택 표지 mat_cd 1행만 매칭)이지 5표지 합산 아님. 면지(104 그레이)=base24 internalize·비기여. sub_prd 가격 바인딩 0(가격=base24+per2p 공식 Σ만). 정합.
- **이질 assortment 오해 가드(P-9c)**: 세트 = 한 책 부품 구성(생산 BOM)이지 여러 완제품 묶음 아님. 묶음수=부수(qty)·별개. 정확.
- evaluate_set_price(pricing.py:597) 경로 미사용(base24 통합 단일 공식)·designer가 책자 full 분해(evaluate_set_price member 평가)와 분기 정합.

---

## E6 — 골든 재현 (허용오차 0) · **PASS**

**검사**: 설계 공식으로 골든 실제 재계산(권위 CSV verbatim·pricing.py 동치). 상세 = `recompute-log-photobook.md`.

- **GC-PB-1~10 전건 PASS(허용오차 0)** — python 독립 재산출(권위 CSV에서 base24/per2p 직독·설계값 비사용·순환참조 0):
  - base24 ×1(증분0): 15,000/23,000/10,000/16,000 ✅
  - 페이지 증분 산식: 19,000/33,800/46,500/30,000/14,400 ✅(증분=앱 ceil)
  - 부수 곱: 190,000 ✅(base24·per2p 둘 다 ×부수)
- **GC-PB-3(소프트)만 조건부 PASS** — base_min=4 가정 의존(라이브 page_rule 부모 24/150/2만·소프트 4 미저장). 24P 오적용 시 페이지 시작점 오류(LOW-2·Q-PB-PAGEBASE).
- **GC-PB-11 BLOCKED 정당**: CSV row8 공란 실측·보간 후보 비단조(8x8 12,000/A5 10,000/A4 13,000) → 추측 INSERT 금지.
- **GC-PB-12 부분 BLOCKED 정당**: base24=완제 통합값 권위·부품 정확 역산 미권위·통째 적재로 골든 재현되므로 부품 분해 불요.

---

## E7 — 생성-검증 독립성 · **PASS**

- 본 검증 = designer 산출값 비신뢰·**라이브 직접 SELECT·권위 CSV 직독(설계값 비사용)·pricing.py 코드 읽기·python 독립 재산출**로 교차. self-approve 0.
- **dodge-hunt 결과**: 골든 = 권위 CSV verbatim에서 직독(설계가 만든 값으로 골든 만들지 않음=순환참조 0). 증분횟수=앱 ceil 런타임 계산을 단가행 위장 안 함(per2p 단가만 룩업). BLOCKED 회피 결함 0(GC-PB-11/12 독립 확인=정당).
- **designer 무비판 수용 안 함**: §0.1 표가 미플래그한 2건 라이브 적발 — ① COMP_BIND_PUR del_yn=Y(설계 "8행 실재"만 기재) ② 표지자재 MAT_000005/006/007 전건 del_yn=Y(설계 "실재"만 기재). 아래 LOW-1.

---

## 결함 보드

| ID | 등급 | 내용 | 라이브 실측 | 처리 |
|----|------|------|-------------|------|
| **LOW-1** | LOW | designer §0.1이 미플래그: ① COMP_BIND_PUR **del_yn=Y**(논리삭제) ② 표지자재 MAT_000005/006/007 **전건 del_yn=Y** | `SELECT del_yn …` → BIND_PUR=Y·표지자재 5/6/7=Y | **가격 결과 무관**(base24=완제 통합값·BIND_PUR internalize 미배선·엔진 `_row_matches`는 del_yn 미검). 단 base24 use_dims `[siz,mat_cd]` 판별차원이 논리삭제 자재를 가리킴 → 적재 시 ① 표지자재 활성화 재검 or ② mat_cd 대신 활성 코드 매핑 컨펌(Q-PB-MAT에 흡수). 차단 아님 |
| **LOW-2** | LOW | 소프트 base_min=4 라이브 page_rule 미저장(부모 PRD_000100만 24/150/2) | `t_prd_product_page_rules WHERE prd_cd IN (101..107)` → 0행 | Q-PB-PAGEBASE 돈크리티컬이나 designer가 honest 컨펌큐로 정직 처리(GC-PB-3 조건부 PASS). 적재 전 소프트 base_min 인간 컨펌 필수(1,500원~ 차이) |

**차단(NO-GO) 결함 0 · 보정 폐루프 항목 0.**

---

## 돈크리티컬 가드 실재성 (라이브+코드 입증 종합)

| 가드 | 실재성 | 입증 |
|------|--------|------|
| **G-PB-PAGE**(페이지 곱) | ✅ 실재 | GC-PB-7 정답 46,500 vs 누락 15,000(3.1배 과소)·row17 명문·per2p×증분횟수×부수 |
| **G-PB-PRODPRICE**(선점) | ✅ 실재 | pricing.py :315-326 product_prices 선점→FORMULA 우회 silent·라이브 0행 자동충족 |
| **G-PB-FLAT**(평탄화) | ✅ 실재 | base24 mat_cd NULL→`_row_matches`:81-84 와일드카드 silent flat·GC-PB-1(하드15,000) vs 2(레더하드23,000) |
| **G-PB-SET**(이중계상) | ✅ 실재 | t_prd_product_sets 7행=BOM·가격 비기여·표지 택1·sub_prd 가격 0행 |
| **G-PB-BIND01**(.01 유지) | ✅ 실재 | pricing.py :185-188 .02 ValueError·base24/per2p=.01·min_qty=1 |
| **G-PB-PAGEBASE**(소프트 base_min) | ✅ 실재(미해소) | 소프트 base_min=4 vs 24 → 1,500원~ 차이·라이브 page_rule 미저장(LOW-2·컨펌큐) |

---

## 컨펌큐 (차단 아님·인간/designer 라우팅)

designer 정직 표기 + 검증가 동의:
- **Q-PB-PAGEBASE**[돈크리티컬·LOW-2]: 소프트 base_min=4 vs 24(라이브 미저장·적재 전 컨펌 필수).
- **Q-PB-MAT**[+LOW-1]: 표지타입 mat_cd 정확 매핑(MAT_005/006/007 del_yn=Y → 활성화 or 재매핑·레더 106 vs 레더하드 표지 소재 구분).
- **Q-PB-SOFT8**: 10x10 소프트(row8 공란·GC-PB-11 BLOCKED 정당).
- **Q-PB-COAT/FACE**: 표지 무광코팅(COMP_COAT_MATTE 92행 실재로 comp 소스 해소·base24 internalize라 직매칭 불요)·면지 비기여(GC-PB-12 부분 BLOCKED).
- **Q-PB-DSC**: 수량구간할인 미해당(t_prd_product_discount_tables 0행 라이브 확인).
- 포토북 siz_cd 매핑(8x8/10x10/A5/A4 라이브 복수 후보·base24/per2p 적재 전 확정).

---

## 다음 단계 권고

- **codex Phase 5.5(hpe-codex-validator) 독립 2차 교차검증** 진행 — 본 E게이트 결론 비노출(독립성). 특히 ① GC-PB-7 페이지 곱 3.1배 독립 검산 ② 소프트 base_min=4 골든 GC-PB-3 독립 판정 ③ PRF_BIND_SUM 공유 부결 근거 독립 재확인 권고.
- 실 적용(공식 신설·comp 2·단가행 충전·바인딩) = **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer). 적재 전 Q-PB-PAGEBASE·Q-PB-MAT(del_yn=Y 자재) 인간 컨펌 선결.
