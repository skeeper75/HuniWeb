# regate-verdict-digitalprint.md — 디지털인쇄 설계 보정 후 재게이트

> **hpe-validator 재게이트.** 이전 NO-GO(E5·E6 FAIL) → 보정 폐루프(설계 보정 + dbm-price-arbiter §9 권위확정/§10 최종 명세 + 사용자 CV-1~4 컨펌) 후 독립 재검증.
> 생성자(engine-designer·arbiter) 주장 비신뢰 — 가격표 원본 CSV 직접 개봉·pricing.py 소스 직접 대조·라이브 read-only SELECT·골든 독립 재계산. 실측 2026-06-20 · DB 쓰기 0.
> 이전 산출: validation-summary.md·gate-verdict-digitalprint.md·recompute-log.md.

---

## 종합 판정: **GO** (조건부 — 컨펌 4건 모두 사용자 권위로 확정됨, 잔여=실 적재 인간 승인뿐)

| 게이트 | 이전 | 현재 | 변화 |
|--------|------|------|------|
| E-권위 (신규) | — | **PASS** | arbiter §9 인용 전건 가격표 원본 verbatim 확인·날조 0 |
| E1 공식 추출 충실성 | PASS | **PASS** | 유지 |
| E2 구성요소 분해 정합 | CONDITIONAL | **PASS** | CV-3 인쇄면 통합 명세가 silent 이중합산 원천 차단·D-2 use_dims 라이브 검증 정확 |
| E3 경쟁사 흡수 타당성 | PASS | **PASS** | 유지 |
| E4 엔진 설계 건전성 | CONDITIONAL | **PASS** | D-3 사유 정정·D-2 가설 라이브 검증·search-before-mint 유지 |
| **E5 세트 조합 정합** | **FAIL** | **PASS** | R-3 BOM 이중계상 0 / 가격축 결함 2열 분리·엽서북 명함 동일 결함군 재분류 정합 |
| **E6 골든 재현** | **FAIL** | **PASS** | 합가형(.02) 전환 시 8/8 골든 허용오차 0 재현·박 동판 정액 합성 29,800 일치 |
| E7 생성-검증 독립성 | PASS | **PASS** | 유지·designer가 codex 사유를 라이브로 반증(맹종 0) |

**전건 PASS → GO.** 단 prc_typ 실 UPDATE·인쇄면 통합·박 정액 처리는 **인간 승인 후 dbmap 위임**(DB 미적재).

---

## 한 줄

이전 NO-GO의 두 진원(E6 골든 ×qty 폭발·E5 엽서북 오판)은 **둘 다 라이브 prc_typ 오적재 + 인쇄면 차원 부재**였고, 설계가 이를 D-10 한 칸으로 과소처리한 게 결함이었다. 보정은 ① 가격표 행축 라벨("제작수량"·"기본가(아연판)")을 **권위로 직접 인용**해 합가형(.02)을 반증불가로 확정 ② 골든을 양면표(설계 기대값 verbatim vs 현 라이브 결함)로 재서술 ③ 엽서북 이중계상을 BOM축(0)/가격축(≠0) 2열로 분리 ④ codex use_dims 가설을 라이브 코드로 검증(결론 채택·사유 반증). 재게이트가 **합가형 전환 골든을 직접 재계산해 8/8 허용오차 0**으로 닫았다.

---

## E-권위 (신규) — arbiter §9 인용 실재성 `PASS`

**검사**: arbiter §9 CV-1 합가형 판정의 가격표 인용이 날조 아닌가. 가격표 원본 CSV(`huni-dbmap/06_extract/price-namecard-photocard-l1.csv`·`price-postcard-book-l1.csv`)를 직접 개봉해 행축 라벨·셀값 confirm.

| arbiter §9 주장 | 가격표 원본 직접 confirm | 판정 |
|-----------------|--------------------------|------|
| 명함 행축 = `소재 / 제작수량`·행값 100·셀 3500 | CSV A3=`소재 / 제작수량`·A4=`100`·B4(단면 백모조)=`3500` | ✅ verbatim |
| 코팅명함 단면 100매 = 5500 | B18(코팅명함·100·단면 아트250)=`5500` | ✅ |
| 박명함 동판 = `기본가(아연판)` 별행 5000 | A60=`기본가(아연판)`(red font FFFF0000)·B60=`5000`·제작수량 행(200/300…)과 **분리** | ✅ CV-4 정액 확정 |
| 박가공 300매 단면 = 24800 | A62=`300`·C62(홀로그램)=33200·**B62(금유광 등 일반박)=`24800`** | ✅ |
| 박명함 헤더 = 종이+동판+박가공비 | F57=`종이+동판+박가공비` | ✅ |
| 포토카드 SET 행축 = `세트제작수량`·1세트=6000 | A75=`세트제작수량`·A76=`1`·B76=`6000` | ✅ |
| 포토카드 BULK 행축 = `총제작수량`·100매=9500 | A83=`총제작수량`·열=`가격`·A88=`100`·B88=`9500` | ✅ |
| 엽서북 행축=제작수량·열=사이즈>인쇄(단면/양면)>페이지(20P/30P)·2부단면20P=11000 | A2=`사이즈`·A3=`인쇄`(단면/양면)·A4=`페이지/수량`(20P/30P)·B5(qty2·단면20P)=`11000` | ✅ CV-3 인쇄면/페이지=열차원 확정 |
| 엽서북 20부 단면20P = 5200 | B10(qty20·100*150단면20P)=`5200` | ✅ |

**판정 PASS** — arbiter §9 인용 **전건 가격표 원본 verbatim 일치·날조 0**. 행축 라벨이 명시적으로 "제작수량"·"세트제작수량"·"총제작수량"·"기본가(아연판)"이므로 **합가형(.02)·동판 정액 판정은 반증불가**(셀 3500이 장당가였다면 행축이 "제작수량 100"이 아니었을 것). CV-1 권위확정은 추측 0.

---

## E6 골든 재현 (이전 FAIL → 현재 PASS)

**검사**: 합가형(.02) 전환 시 엔진계약 `subtotal=(unit_price÷min_qty)×qty`로 골든 직접 재계산 → 권위 골든과 허용오차 0인가. min_qty=NULL 행이 합가형 대상에 남아 ValueError 나는 건 없는가.

### 엔진계약 라이브 소스 직접 확인 (자=尺)
`pricing.py:177-192` (read-only):
- 합가형(.02): `base = tier_min_qty or 0; if base<=0: raise ValueError; per_item = up/base; return per_item*qty` (line 185-190)
- 단가형(.01): `return up*qty` (line 191-192)

### 합가형(.02) 전환 골든 독립 재계산 (허용오차 0)

| 골든 | (unit ÷ min_qty) × qty | 재계산 | 권위 골든 | 판정 |
|------|------------------------|--------|-----------|------|
| GC-1 명함STD 단면 q100 | (3500÷100)×100 | **3,500** | 3,500 | ✅ |
| GC-2 명함STD 양면 q100 | (4500÷100)×100 | **4,500** | 4,500 | ✅ |
| GC-3 코팅명함 단면 q100 | (5500÷100)×100 | **5,500** | 5,500 | ✅ |
| GC-6 포토카드 BULK q100 | (9500÷100)×100 | **9,500** | 9,500 | ✅ |
| GC-7 엽서북 단면20P q2 | (11000÷2)×2 | **11,000** | 11,000 | ✅ |
| GC-8 엽서북 단면20P q20 | (5200÷20)×20 | **5,200** | 5,200 | ✅ |
| GC-5 포토카드 SET q1 | (6000÷1)×1 | **6,000** | 6,000 | ✅ |
| GC-4 박 FOIL 박가공 q300 | (24800÷300)×300 | **24,800** | 24,800 | ✅ |

### 박 SETUP 동판 = 정액 1회 (합가형 격리)
- SETUP 합가형(.02) 전환 시도 → **ValueError 발생**(min_qty=NULL) → 합가형 전환 **금지가 정당**(재계산 직접 확인).
- CV-4 차선A(단가형 .01 + selections qty=1 격리): `5000 × 1 = 5,000`.
- **박명함 GC-4 합성 = 박가공 24,800(합가형) + 동판 5,000(정액) = 29,800 ✅** (권위 골든 29,800 일치).

### ValueError 안전성 — 라이브 실측 (decisive)
합가형 전환 대상 comp 전부 min_qty NULL 행 = **0건**·SETUP만 NULL(격리됨):
```sql
SELECT pc.comp_cd, pc.prc_typ_cd,
  COUNT(*) FILTER (WHERE cp.min_qty IS NULL) AS null_minqty, COUNT(*) total
FROM t_prc_price_components pc JOIN t_prc_component_prices cp ON cp.comp_cd=pc.comp_cd
WHERE pc.comp_cd LIKE 'COMP_NAMECARD_STD%' OR pc.comp_cd LIKE 'COMP_PCB%'
   OR pc.comp_cd LIKE 'COMP_PHOTOCARD%' OR pc.comp_cd LIKE 'COMP_NAMECARD_FOIL%'
GROUP BY 1,2;
-- FOIL_SETUP_S1/S2_STD = null_minqty 1/1 (정액·격리 대상)
-- STD/PCB/PHOTOCARD_SET/BULK/FOIL_S1/S2_STD/HOLO = null_minqty 0 (합가형 전환 안전)
```
→ 합가형 전환 대상은 ValueError 위험 0·SETUP만 NULL이라 정액 처리로 구조적 격리됨(R-4/§10-2 정합).

**판정 PASS** — 골든 8/8 허용오차 0 재현. 진원이 라이브 prc_typ 오적재였고, 합가형(.02) 전환이 그대로 verbatim 골든을 복원함을 독립 재계산으로 입증. 단가행 값 무변경(verbatim 보존). 박 동판 정액 격리도 ValueError 없이 정합.

---

## E5 세트 조합 정합 (이전 FAIL → 현재 PASS)

**검사**: 엽서북 R-3 재분류가 정합한가(BOM 이중계상 0 유지 + 가격축 silent 합산·×qty 결함 분리 서술).

**확인** (set-product-design.md §1.2/1.3/§5):
- "이중계상 0" 통판정 철회 → **2열 분리**: ① BOM(내지/표지·template) 이중계상 = **0 유지** ✅ (완제품 통합단가에 부품 별 합산 안 함·가드 유효·codex 합의) ② 가격엔진 축 = **≠ 0** ❌ (S1_20P+S2_20P silent 이중합산 + prc_typ ×qty).
- 엽서북을 **명함과 동일 결함군**(V-DGP-1·D-10 범위)으로 재분류 — recompute §4 라이브 재계산(45,000=22,000+23,000)과 정합.
- §5 요약표가 "BOM 이중계상"·"가격축 결함(R-3)" 2열로 명시 분리.
- 세트 가격 합성 신규 그릇 = 0건(benchmark 신규 가격축 0과 정합).

**판정 PASS** — 이전 거짓 판정("이중계상 0")이 정확히 두 의미로 분해되어 BOM축은 진짜 0, 가격축은 결함으로 분리 서술됨. 무모순.

---

## E2·E4 — 인쇄면 통합(CV-3)·D-2 use_dims 가설 재확인

**검사**: 인쇄면 통합(CV-3)이 silent 이중합산을 실제로 차단하는가. D-2 use_dims 가설(컬럼 충전 + use_dims 등재 둘 다 필요·매칭은 NON_QTY_DIMS 고정상수 순회)이 라이브 코드와 맞는가.

### CV-3 인쇄면 통합 (E2)
- §10-3: PRF_NAMECARD_FIXED 등 S1+S2를 **comp 1개 통합 + print_opt_cd 충전 + use_dims 등재** → 인쇄면 선택이 정확히 1행 매칭. comp가 1개면 합산 대상이 1개 → **silent 이중합산 구조적 불가능**(arbiter §5 "곱의 한 항 제거"). 가격표 권위(CV-3: 단면/양면=열 선택차원·단일 셀=단일 가격)와 정합.

### D-2 use_dims 가설 — pricing.py 소스 직접 대조 (E4)
designer 주장: "결론(둘 다 필요)은 맞다, codex 사유(매칭=use_dims 기준)는 틀렸다." → **라이브 소스로 confirm**:
- `pricing.py:38-39` `NON_QTY_DIMS` = 고정상수(print_opt_cd 포함). `:81-85` `_row_matches`·`:93-95` `_combo_key`가 **NON_QTY_DIMS 순회**(use_dims 아님) → 컬럼 충전만으로 매칭(이중합산 차단) 성립 → **codex "매칭=use_dims 기준" 사유 반증 정확**.
- `:412-414` `_match_entry`가 use_dims로 `non_qty_dims` 계산 → 비면 "판별차원 없음 — 항상 매칭" note. → use_dims 미등재 시 **오경고**(D-2 이유 ①) confirm.
- `:459-462` `_evaluate_formula`가 use_dims로 `is_proc` 판정(공정 분기). → use_dims는 경고/주입 레이어용(D-2 결론) confirm.
- ∴ "컬럼 충전 + use_dims 등재 동시" 무손실 해법 정확. 둘 중 하나만 = 오경고 / 0원 침묵(주입 레이어 연결 시).

### ERR_AMBIGUOUS 비발생 (R-2) — 소스 confirm
- `:136-138` ERR_AMBIGUOUS는 `len(combos)>1`일 때만(한 comp 내부 단가행 조합). S1/S2는 별 comp_cd → match_component 내부서 안 만남 → ERR_AMBIGUOUS 발생 안 함 → R-2 "silent 이중합산이지 ambiguous 아님" **소스로 confirm**.

**판정 E2 PASS·E4 PASS** — CV-3 통합이 이중합산을 구조적 차단·D-2 가설이 라이브 코드와 정확히 일치(designer가 codex를 맹종 않고 라이브로 검증·사유 반증). G-7 옵션→차원 자동주입 미연결(option_items 0행)은 컨펌큐로 정직 유지(주입 레이어 연결 시점에 use_dims 효과 발현).

---

## E1·E3·E7 — 유지 확인

- **E1 PASS**: 보정은 메커니즘/범위/판정 정정 + 골든 양면표기뿐·단가값 verbatim 불변. 추출 충실성 무변·v03 인용 0 유지.
- **E3 PASS**: 흡수 판정(C-2/C-4 data-gap·신규 가격축 0·naming 유입 0) 무변. 보정이 흡수 영역 미접촉.
- **E7 PASS**: 재게이트가 designer/arbiter 주장을 **재유도 않고** 가격표 원본 직접 개봉·pricing.py 소스 직접 대조·골든 독립 재계산·라이브 min_qty 실측으로 교차. self-approve 0·dodge-hunt(순환참조 0: 골든=가격표 verbatim·재계산=엔진계약 적용).

---

## 잔여 항목 (GO지만 적재 전 인간 승인 필요)

| # | 항목 | 상태 | 비고 |
|---|------|------|------|
| 실 적재 | prc_typ .01→.02 (전 고정가형·§10-1) | 컨펌 완료·**적재 인간 승인 대기** | 단가행 값 불변·멱등·백업·롤백 DRY-RUN(round-23 스티커 동형 저위험) → dbm-axis-staged-load/dbm-load-execution |
| 실 적재 | 박 동판 정액(§10-2 차선A) | 컨펌 완료·**처리 방식 개발자 협의** | 차선A=selections qty=1 격리(엔진 무변경)·차선B=정액 prc_typ 신설(개발자 백로그·webadmin read-only) |
| 실 적재 | 인쇄면/페이지/소재 통합(§10-3) | designer 명세 완료·**단가행 병합 적재 인간 승인** | comp 통합 시 단가행 S1/S2→print_opt_cd 차원 병합·use_dims UPDATE·라이브 재확인 |
| 컨펌 잔존 | G-7 옵션→차원 자동주입(option_items 0행) | 미연결(정직 표기) | 주입 레이어 실연결 시 use_dims 효과 발현·현재 충전 단독으로 매칭은 됨 |
| designer 큐 | 형압명함 comp·봉투류 경계(G-6b)·엽서북 페이지수(30P orphan 배선) | open carry-forward | 바인딩 확정 후속 |

**★ GO 근거**: 이전 NO-GO 사유였던 E5·E6가 보정으로 닫혔고(골든 8/8 허용오차 0·세트 판정 분해 정합), E-권위 신규 게이트가 arbiter §9 인용을 전건 가격표 원본 verbatim으로 confirm(날조 0). 잔여는 전부 **실 적재(인간 승인)·후속 바인딩**이지 설계 정합 결함이 아니다.

## DB 미적재 [HARD]
본 재게이트는 가격표 원본 CSV·pricing.py 소스·라이브 read-only SELECT만 수행·DB 쓰기 0. 모든 교정(prc_typ UPDATE·comp 통합·박 정액)은 인간 승인 후 dbmap 위임. webadmin pricing.py(엔진)=개발자 GitHub·read-only(정액 prc_typ 등 개발자 백로그).
