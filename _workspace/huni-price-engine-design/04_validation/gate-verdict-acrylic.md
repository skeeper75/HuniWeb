# gate-verdict-acrylic.md — 아크릴 면적매트릭스형 가격엔진 설계 E1~E7 게이트 판정

> hpe-validator 독립 검증 (2026-06-20·라이브 읽기전용 SELECT·DB 쓰기 0).
> 검증 대상: `03_design/engine-design-acrylic.md`·`golden-cases-acrylic.md`·`set-product-design.md`(§7)·`design-decisions.md`(아크릴).
> 기준점: `01_formula/formula-map-acrylic.md`·`02_benchmark/absorption-candidates-acrylic.md`.
> **생성자 주장 비신뢰** — 라이브·권위 가격표(260527) 직접 재실측·재계산으로 교차. 재현 SQL/재계산 = `recompute-log-acrylic.md`.
> codex 2차(Phase 5.5) 결과 비참조(독립성).

---

## 종합 판정: **GO (조건부 컨펌큐 동반)** — E1~E7 전건 PASS

7개 게이트 전건 PASS. 본체(투명/코롯토)·골든 8건은 라이브·가격표·코드로 무결 재현. 신규 mint(미러 공식·카라비너 comp/공식·후가공 comp)는 전부 컨펌 대기 상태로 정직 표기되어 설계 GO를 막지 않음(컨펌큐로 분리). 단가 결함·이중합산·×qty 폭발 0.

---

## E1 — 공식 추출 충실성 · **PASS**

| 검사 | 실측 결과 |
|------|----------|
| 면적매트릭스형 분류 | calc-draft 행106 `[면적매트릭스형:아크릴]`·가격표 B01 [가로×세로] 매트릭스 구조 일치. 라이브 use_dims=[siz_width,siz_height,(mat_cd)] 정합. ✅ |
| 카라비너 고정가형 분리 | calc-draft 행116 `[고정가형:카라비너]·외주비용`·가격표 4형상 통가격(5800/5800/6300/6900) verbatim 실재(아래). 면적 아님 분리 정당. ✅ |
| 단가 verbatim(날조 0) | 라이브 3100/2480/3800/3600/5000 = 가격표 260527 셀 trace 일치. CLEAR 30×30=3,100(B01 C-row)·1.5T=2,480(B02)·코롯토 30×30=3,600·미러 20×20=5,000(셀 formula `=B3*2`). **날조 0**. ✅ |
| v03 인용 차단 | 권위=상품마스터260610·가격표260527·라이브. v03 인용 없음. ✅ |

**결함(LOW·비차단) F-A-1 — B-label 원천 불일치**: 추출 파일 `06_extract/price-acrylic-price-l1.csv`에서 카라비너 4형상 고정가는 **블록 B06** 헤더("아크릴카라비너 투명3T+3T 접합"·B103 옵션 단가 5800/6300/6900·B104 사각자물쇠=5800)에 있고, 코롯토는 **B05** 헤더, 카라비너 수량할인은 **B07**. 그러나 dbmap 권위 `31_acrylic-price-link/acrylic-chain-design.md`와 설계/cartographer는 카라비너 고정가=**B07**·코롯토=B06으로 인용. **B-label 매핑이 두 원천 파일 간 어긋남**(추출본 vs 체인설계 doc). 단 **값(5800/5800/6300/6900·3600)은 양쪽 verbatim 동일** → 날조 아님·내용 무결. 컨펌큐: B-label 인용을 권위 원천 한쪽으로 통일(가격 무영향).

---

## E2 — 구성요소 분해 정합 · **PASS**

| 검사 | 실측(라이브 마스터 + component_prices) |
|------|----------------------------------------|
| COMP_ACRYL_CLEAR3T use_dims | `["siz_width","siz_height","mat_cd"]`·prc_typ=.02 → **설계와 정확 일치** ✅ |
| 두께=mat_cd 직교 | CLEAR3T 165행 = MAT_000043(3T) 113 + MAT_000042(1.5T) 52. 같은 1 comp의 mat_cd 정확매칭(NON_QTY_DIMS)으로 두께 1행 선택. 별 두께 comp/축 없음. ✅ |
| silent 이중합산 차단(comp 1배선) | PRF_CLR_ACRYL→CLEAR3T 1 comp(disp_seq=1·addtn_yn=N)·PRF_COROTTO_ACRYL→COROTTO 1 comp. **공식당 합산 대상 1개 = 구조적 이중합산 불가**. ✅ |
| 의미축 이중 인코딩 | 도수(양면9도/단면7도)·레이저커팅(완칼)이 면적 단가에 통합("통용단가")·별 축 없음. siz_cd=NULL·siz_width/height numeric(work사이즈 미사용·전건 165/21/52 확인). ✅ |
| 완제품/반제품 구분 | 입체블럭(169)·쉐이커(170)·입체코롯토(168)는 "입체"여도 단일 면적매트릭스 1 comp(세트조합 아님). calc-draft 세트분해 없음. 구분 정합. ✅ |

**근거**: §2-1 mat_cd 직교·§7 1배선 구조 = 라이브로 무결 확인. 미러 합류(소재옵션) 시에만 두 comp → mat_cd 판별차원 필요(§5-B 가드)·현 설계는 합류 BLOCKED 처리로 위험 0.

---

## E3 — 경쟁사 흡수 타당성 · **PASS**

| 검사 | 결과 |
|------|------|
| 신규 가격축/테이블 mint | **0건** — 두께=mat_cd(C-A1·이미 동형)·면적=매트릭스 ceiling(C-A2·이미 동형)·고정가=opt_cd comp(C-A6·기존 그릇)·제약=round-6 CPQ(C-A5). benchmark 흡수보드 "신규 vessel 0" 라이브 정합. ✅ |
| 권위 덮어쓰기 0 | RedPrinting `acrylic2025_price` 면적함수 흡수 부결(가격표=이산 매트릭스 권위 유지)·8T mat_cd는 마스터 있으나 가격표 단가 부재로 data-gap 정직 기록(덮어쓰기 안 함). ✅ |
| naming/codes 유입 0 | WGT_CD/MTRL_CD/acrylic2025/SUB_MTR/GRP_OPTION_CD 후니 유입 금지 명시·후니 mat_cd/proc_cd/opt_cd 번역. 설계 산출물에 RP 토큰 0. ✅ |
| overfit(엔진 과분화) | 면적/고정가 = frm_typ 분기 아니라 comp 1배선 use_dims 차이로 동일 처리(C-A3 엔진 코드 분기 부결). overfit 0. ✅ |

---

## E4 — 엔진 설계 건전성 + ★min_qty 계약 · **PASS**

### min_qty 라이브 confirm (돈크리티컬·designer 주장 직접 반증 시도)

| comp | designer 주장 | **라이브 SELECT 실측** | 판정 |
|------|--------------|------------------------|------|
| COMP_ACRYL_CLEAR3T | .02·min_qty 전건 1 | 165행·distinct=1·min=max=1·**NULL 0·=1 165** | ✅ **확정** |
| COMP_ACRYL_COROTTO | .01·min_qty 전건 1 | 21행·distinct=1·min=max=1·NULL 0 | ✅ **확정** |
| COMP_ACRYL_MIRROR3T(MIRROR NULL 포함) | .01·min_qty **전건 NULL** | 52행·distinct=0·**NULL 52(전건)** | ✅ **확정** |

- **코드 계약 confirm**(`pricing.py:177-192` 직독): `.02`(PRC_TYPE_TOTAL)는 `per_item = unit ÷ tier_min_qty·× qty`, `base<=0`(NULL)→ValueError. `.01`은 `unit × qty`(÷ 미발생). designer 인용 라인(185-192)은 실제 177-192에 매핑(라인 ±·시맨틱 정확).
- **CLEAR3T .02 + min_qty=1 → ÷1=단가형 수학 동일** = 코드+재계산으로 확정(GC-A1 310,000 재현). **×qty 폭발 위험 없음**.
- **디지털 ×qty와 단가 의미 정반대 confirm**: 디지털 결함=단가가 묶음총액인데 ×수량 폭발. 아크릴=단가가 **개당 완제품가**(가격표 셀 정의)+min_qty=1 → unit×qty가 곧 정답. 재계산 증명(recompute-log §3)으로 designer 주장 **반증 실패=주장 옳음**.
- **off-grid ceiling**(`pricing.py:149-162` TIER_UPPER): 35×35→40×40 ceiling 알고리즘 직접 재실행 일치(GC-A4)·35×35 단가행 0건(위장 룩업 아님).

### 기타 엔진 계약

| 계약 | 결과 |
|------|------|
| C7 frm_typ 미참조 | 면적/고정가 모두 comp 1배선 합산형 표현·frm_typ 무참조. ✅ |
| search-before-mint | 본체 17상품=바인딩만(공식/comp 재사용·신규 0)·COROTTO 실재 재사용·MIRROR3T 단가행 실재. 불필요 mint 0. ✅ |
| 채번 규칙 | 카라비너 형상 opt_cd=OPV_NNNNNN·MAX+1·separator `_`(채번 트랙 위임)·comp_typ=.06 완제품비(dbmap 권위 정합). ✅ |
| FK 위상 | 바인딩 INSERT 대상 product_price_formulas는 기존 PRF_CLR_ACRYL/COROTTO 참조(공식 선존재)·미러/카라비너는 공식 선신설 후 바인딩 순서 명시. ✅ |
| ★신규 .02 면적행 가드 | CLEAR3T .02 신규행 INSERT 시 min_qty=1 명시(NULL→ValueError) 가드 §3-3 정합. ✅ |

**결함(LOW) F-A-2**: comp_typ_cd 라이브 실측 = CLEAR3T/COROTTO/MIRROR3T 전건 **PRC_COMPONENT_TYPE.01**(인쇄비). 설계는 카라비너만 .06(완제품비) 제안 — 본체와 다른 typ. dbmap 권위(.06=접합완제)와 정합하나, 본체 아크릴 완제품(키링 등)이 .01(인쇄비)인 것과 시맨틱 일관성은 개발자 컨펌(가격 무영향·comp_typ는 엔진 계산 미참조).

---

## E5 — 세트/바인딩 + ★G-A1 · **PASS**

| 검사 | 라이브 실측 |
|------|------------|
| G-A1 미바인딩 실재 | `t_prd_product_price_formulas`에서 본체 아크릴 = **PRD_000146→PRF_CLR_ACRYL 1건뿐** confirm(142/143은 별 poster-sign 트랙·정당 제외). ✅ designer "1건뿐" 정확 |
| 바인딩 대상 17상품 활성 | 146~170 영역 17상품 전건 use_yn=Y·del_yn=N(활성)·기바인딩 1(146) → **16 미바인딩**. ✅ |
| 바인딩 해소 실효성 | 투명 본체 16상품→PRF_CLR_ACRYL 재사용(소재=mat_cd 흡수·신규 0)·168→PRF_COROTTO_ACRYL. INSERT만으로 source=NONE→FORMULA 전환(가격계산 가능). 신규 mint 0. ✅ |
| 미러 BLOCKED 정당성 | 라이브 미러 본체 상품 **0개** confirm(바인딩 대상 부재). 별 공식 단독 신설=orphan 무의미. 소재옵션 합류는 mat_cd 판별차원 선결 → BLOCKED 정당. ✅ |
| 세트 이중계상/누락 | 아크릴 명시 세트조합 부재(calc-draft 세트분해 없음)·입체류=단일 면적매트릭스. 이중계상·구성품 누락·번들할인 오류 대상 없음. ✅ |

**미세 표기 주의(비결함)**: gap-board(formula-map §7)는 "29상품 미바인딩"(비활성 포함), 설계 §4는 "활성 17"·"16 미바인딩"으로 정제. 라이브로 **활성 17 중 16 미바인딩** 확정 — 설계 §4 수치가 정확(gap-board는 비활성 포함 광역). 표현 차이일 뿐 substance 일치.

---

## E6 — 골든 재현(허용오차 0) · **PASS**

골든 8건 **engine 충실 재구현 재계산 전건 일치**(recompute-log-acrylic §2):

| 골든 | 재계산 | 기대 | 판정 |
|------|--------|------|------|
| GC-A1 키링30×30 3T ×100 | 310,000 | 310,000 | ✅ |
| GC-A1 ×1 | 3,100 | 3,100 | ✅ |
| GC-A2 1.5T ×1 | 2,480 | 2,480 | ✅ |
| GC-A3 비대칭 50×30 ×1 | 3,800 | 3,800 | ✅ |
| GC-A4 off-grid 35×35→40×40 | 3,800 | 3,800 | ✅ |
| GC-A5 코롯토 30×30 | 3,600 | 3,600 | ✅ |
| GC-A6 미러 20×20 | 5,000 | 5,000 | ✅ |
| GC-A6b 미러 20×20 ×10 | 50,000 | 50,000 | ✅ |

- **순환참조 0**: 기대값=가격표 셀 verbatim·재계산=라이브 단가행+엔진 알고리즘(설계 산출값 비참조).
- **dodge 0**: off-grid 35×35 단가행 0건 → ceiling은 런타임 TIER_UPPER 계산(위장 룩업 아님).
- 미러 ×10 scaling(.01·NULL min_qty)으로 ÷min_qty 미발생 추가 확인.

---

## E7 — 생성-검증 독립성 · **PASS**

| 검사 | 결과 |
|------|------|
| 자기 재유도(self-approve) 없음 | designer 산출물 비참조로 라이브 SELECT 8종+엔진 충실 재구현으로 독립 재계산. 설계 골든값을 그대로 쓰지 않음(가격표 셀 독립 trace). ✅ |
| 생성자 주장 라이브 반증 시도 | min_qty(MIRROR NULL 포함)·바인딩 1건·comp use_dims·off-grid·×qty 계약 전부 직접 SELECT/재계산으로 교차 → 반증 실패=주장 옳음 확인. ✅ |
| dodge-hunt | 골든 순환참조·off-grid 위장 룩업·판걸이수 단가행 위장 적극 추적 → 없음. ✅ |
| codex 결과 비참조 | Phase 5.5 codex 미확인(독립 자기 판정). ✅ |

---

## 결함 요약

| ID | 게이트 | 심각도 | 내용 | 차단? |
|----|--------|--------|------|-------|
| F-A-1 | E1 | LOW | 카라비너/코롯토 B-label이 추출본(B06/B05) vs 체인설계 doc(B07/B06) 간 불일치(값은 verbatim 동일·날조 아님) | 비차단 |
| F-A-2 | E4 | LOW | comp_typ 본체 .01(인쇄비) vs 카라비너 제안 .06(완제품비) 시맨틱 일관성(엔진 미참조·가격 무영향) | 비차단 |

확정 결함(차단·NO-GO) **0건**. 양 LOW는 컨펌큐(가격 무영향).
