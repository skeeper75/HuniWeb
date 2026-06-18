# 후가공_박(소형) import 그릇 — 독립 검증 게이트 (round-16)

> 검증자: dbm-validator (생성자≠검증자). 빌더 산출을 의심·라이브 information_schema + openpyxl 원본 직접 실측.
> 일시: 2026-06-13. 라이브 read-only(`-d railway` @ __RAILWAY_DB_HOST__:45948). 원본 openpyxl data_only.
> 대상: `20_price-import/foil-small/` (structure·decomposition·grade-axis·import.xlsx·mapping-flow)
> 검증점: P1~P6 + 박 시트 최대 쟁점(단가/합가·등급 A~E·181 카운트·면적→등급 앱분리·세트형 여부)

---

## 0. 직접 실측 인용 (권위)

### openpyxl 전수 스캔 — `후가공_박(소형)` 시트
- 격자 954×26 = **빈 아티팩트**(실데이터 1~50행·A~M열). non-empty 셀 284개. 추가 박종/면적구간 0 → 빌더 "954 가설 반증·실데이터 50행" **확인**.
- 동판비: `B3=5000`(1셀), 노트 `A4='*아연판'`.
- 일반박 면적→등급: A9~F12 (가로 헤더 10/20/40/60/80mm × 세로 10/20/40mm), `B10` 공란, `F12='E '`(공백).
- 일반박 가격: `I10~M27` = 등급 I9~M9=**A·B·C·D·E(5등급)** × 수량 H10~H27=**18구간**(200·300·400·500·600·700·800·900·1000·2000·3000·4000·5000·6000·7000·8000·9000·10000) = **90셀**.
- 특수박 면적→등급: A33~F35(B2a와 동일 매핑), `F35='E '`.
- 특수박 가격: `I33~M50` = 5등급 × 18구간 = **90셀**.
- **가격셀 합계 = 동판 1 + 일반박 90 + 특수박 90 = 181** (직접 재카운트로 빌더 주장 일치).

### 라이브 information_schema + 데이터 실측
- `t_prc_price_formulas` 컬럼 = `frm_cd·frm_nm·note·use_yn·reg_dt·upd_dt` → **frm_typ_cd/prd_cd 부재 확인**.
- `t_prd_product_price_formulas` = `prd_cd·frm_cd·apply_bgn_ymd·note·reg_dt·upd_dt`(상품바인딩 별 테이블).
- `t_prc_price_components` = `comp_cd·comp_nm·comp_typ_cd·note·use_yn·reg_dt·upd_dt·prc_typ_cd·use_dims`.
- `t_prc_component_prices` 차원 컬럼 = `siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·proc_cd·opt_cd`(+comp_cd·apply_ymd·unit_price·note·comp_price_id·reg_dt·upd_dt = 총 15컬럼).
- 명함박 comp 6종 실측: `COMP_NAMECARD_FOIL_S1/S2_STD/HOLO`(=오리지널박 합가, prc_typ_cd=**PRICE_TYPE.01**·use_dims=["min_qty"]) + `COMP_NAMECARD_FOIL_SETUP_S1/S2_STD`(동판셋업비·.01·use_dims=[]·단가 5000).
- 명함박 거동: `COMP_NAMECARD_FOIL_S1_STD` 200매=19200 / 300매=24800 / ... 장당 96→82.7원 하락 = **수량할인=총액(합가) 거동인데 prc_typ_cd=.01 단가형으로 등록**.
- 박 가격사슬: `frm_nm LIKE '%박%'` 공식 **0행** / 박종 proc 단가행(component_prices) **0행** / 명함박 formula_components 배선 **0행** / opt_cd 전역 비NULL **0행**.
- 박종 proc(t_proc_processes): PROC_000033=박·41=동박·42=적박·43=청박·44=**트윙클**·45=펄박·46=백박·47=녹박.
- 등급 코드: `FOIL_GRADE` 코드그룹 **0행**, GRADE 검색 결과는 `CUS_GRADE.01/02`(VIP/일반 고객등급·박과 무관) → **GRADE_A~E·FOIL_GRADE 미등록 확인**.
- 신규 코드 충돌: `PRF_FOIL_SMALL`·`COMP_FOIL_SETUP`·`COMP_FOIL_SMALL_PROC_STD/SPC` 라이브 부재 = 채번 충돌 0.

### import.xlsx 그릇 실측
- 시트 8개. _NEW 시트 ROW2 DB컬럼이 라이브 information_schema와 **1:1 일치**.
- `4_component_prices_NEW` 실데이터 = COMP_FOIL_SETUP 1 + PROC_STD 90 + PROC_SPC 90 = **181행**(ROW3 한글헤더 1행 제외). grade=GRADE_A~E. min_qty distinct=18. **자연키 (comp_cd,opt_cd,min_qty) 중복 0**.
- `2_formula_components_NEW` = **3배선**(SETUP seq1 + STD seq2 + SPC seq3, addtn_yn=Y).

---

## 1. P1~P6 게이트 표

| 게이트 | 판정 | 근거(직접 실측) |
|--------|------|-----------------|
| **P1 그릇 정합** | ✅ PASS | _NEW 시트 ROW2 DB컬럼 = 라이브 information_schema 1:1. price_formulas에 frm_typ_cd/prd_cd 부존재 명시·실측 일치. 상품바인딩 `1b_product_formulas_BLOCK` 별 테이블 분리. component_prices 차원 컬럼 12개 표기 모두 라이브 실재. |
| **P2 stale 차단** | ✅ PASS | prc_typ_cd(.01/.02)·use_dims(jsonb)·opt_cd 차원 반영. round-2 BLOCKED NULL 회귀 0(BLOCKED는 NULL 강제 대신 별 시트 1b·B1로 분리). Phase11 단가/합가 구조 정합. |
| **P3 분해 무손실** | ✅ PASS | openpyxl 직접 재카운트: 동판1+일반박90+특수박90=**181** = import 181행 일치. 드롭/날조 0. 면적→등급 28셀(일반14+특수14)은 A1_area_grade_map_REF 별 시트(16행, 비대칭 격자)로 보존. 노트(A4·B10·F12·F35·헤더 박종) 보존. |
| **P4 단가/합가 정당** 🔴 | ⚠️ PASS-with-CONFIRM | 거동 직접 판정: 셀=수량구간 **총액**(A등급 200매 12,200→10000매 218,000, 장당 61.0→21.8원 수량할인) = 합가형(.02)이 거동상 정당. **라이브 충돌 실재 확인**: 명함박 동형 데이터(200매 19,200 총액)가 comp_nm "합가(완제품가)"인데 prc_typ_cd=**.01 단가형**으로 등록됨. 빌더의 컨펌-A 플래그가 라이브 실재 충돌 위에 서 있음 — **추정 금지·인간 컨펌 필수** 처리 정당. |
| **P5 동시매칭 0 + 등급차원** | ✅ PASS | 자연키 (comp_cd,opt_cd,min_qty) 중복 **0**(181건 유니크). 등급=opt_cd 처리 정당(opt_cd 전역 0행=첫 실사용·라이브 grade 차원 부재 확인). siz_cd=NULL 강제 안 함·등급은 사이즈 아님(면적→등급 앱 변환). GRADE_A~E·FOIL_GRADE 미등록 → B1_grade_codes_proposal 선적재 분리 = NULL강제 회피 정당. |
| **P6 엔진 시뮬 + 가격사슬 + 면적→등급** 🔴 | ✅ PASS | 박 공식·박종 단가행·명함박 배선 모두 라이브 **0행** 실측 = 전면 미적재(아크릴/떡메의 "적재됐으나 배선0" 단절과 달리 **아예 없음**). 신규 사슬(formula→3배선→2 comp→181 단가행) 완결 설계. 면적→등급 앱 분리 = 메모리 권위 `dbmap-compute-in-app-db-stores-lookup`(박 면적→등급=앱·DB=등급별가격) **정합**. round-5 DDL GAP "박 2단룩업" 정체 = 등급 opt_cd 차원 + 면적→등급 앱룩업으로 규명 **타당**. |

---

## 2. 빌더 주장 대비 검증 결과 (뒤집힘/보정/확인)

| 항목 | 빌더 주장 | 검증자 실측 | 평결 |
|------|-----------|-------------|------|
| 단가/합가 | 가격표=합가형(.02), 라이브 명함박=.01 충돌 컨펌 | 거동 확인(총액·수량할인) + 라이브 명함박 .01 "합가" 등록 **실재** | **확인(CONFIRM 필수)** — 박 시트 최대 쟁점, 인간 컨펌 정당 |
| 등급 수 | 메인 실측 A~D 오차 → 실제 **A~E 5등급** | I9~M9 = A·B·C·D·E openpyxl 직접 확인 | **빌더 정정이 옳음**(A~E 5등급 확정) |
| 181 단가행 | 동판1+일반90+특수90=181 | openpyxl 재카운트 181 = import 181행 일치 | **확인**(빌더 카운트 정확) |
| 954행 가설 | 빈 아티팩트·실데이터 50행 | non-empty 284셀·max data row 50 | **확인** |
| GRADE 코드 미등록 | GRADE_A~E·FOIL_GRADE 미등록→선적재 | FOIL_GRADE 0행·기존 GRADE=CUS_GRADE(고객등급 무관) | **확인** |
| opt_cd 첫 실사용 | 라이브 0행 | opt_cd 비NULL 전역 0행 | **확인** |
| 박 가격사슬 | 전면 미적재(공식·단가행·배선 0) | 모두 0행 실측 | **확인** |
| 면적→등급 거처 | 앱 책임 + 별 참조시트(REF) | 메모리 권위 정합 | **확인** |
| formula_components 배선수 | structure/decomp §0·§1 "2배선" ↔ import "3배선" | import = SETUP+STD+SPC **3배선** 실재 | **보정(import가 정합)** — decomposition §1 표 "2 배선"은 내부 stale(경미) |
| 박종 proc 나열 | structure §3 "박/동박/적박/청박/펄박/백박/녹박 7종(PROC_000033·41~47)" | PROC_000044=**트윙클**(청박=43). 41~47에 트윙클 포함·문서 나열은 트윙클 누락 | **경미 오기** — 코드 범위는 맞으나 44 라벨 트윙클 명시 누락(특수박 홀로그램/트윙클 군과 연관) |
| 10차원 | component_prices "10차원" | 실제 차원성 컬럼 8개(+comp_cd·apply_ymd 포함 시 10) | **명목 표기**(round-14 차원 수 명칭) — 자연키 검사 무영향 |

---

## 3. 종합 평결

### 박 = 제3구조 "2단 룩업" 신규성 평결
- **YES(부분)**: 박은 MATRIX(스티커)·합산형(디지털)과 구별되는 **2단 룩업**(면적→등급→가격) 구조로 검증됨.
- DB 그릇 관점 신규성의 본질 = ① **등급(opt_cd) 차원 첫 실사용**(라이브 0행) + ② **면적→등급 앱 계산 분리**(DB 미저장 룩업). round-5 DDL GAP "박 2단룩업"의 정체 규명 타당.
- **세트형 아님**: 박은 후가공 1요소(동판셋업 + 등급별 가공비 합산)이지 "여러 구성품 1세트 고정가"가 아님. **세트형 신규구조는 여전히 미발견**(다음 후보=제본·봉투결합) — 빌더 평결 동의.

### GO / NO-GO
**조건부 GO (CONDITIONAL-GO)** — 그릇 분해는 무손실·정합·동시매칭0로 **구조적으로 GO**. 단 실 적재 전 **2개 선결 차단 + 1개 컨펌**이 인간 승인 대기:
1. **차단1(코드 선적재)**: GRADE_A~E·FOIL_GRADE 코드 미등록 → B1 제안 선적재 후 opt_cd 적재.
2. **차단2(상품 바인딩)**: 박이 붙는 prd_cd 미확정 → 1b BLOCKED, NULL 강제 금지(준수 확인).
3. **컨펌(P4 단가/합가)**: 가격표 거동=합가형(.02)이나 라이브 명함박 동형이 .01 단가형 등록 = 충돌 실재. prc_typ_cd 최종 확정은 인간 컨펌 후(명함박 등록이 의도적 관례인지 vs 오등록인지).

### 검증자 권고
- decomposition §1 표 "2 배선" → "3 배선"으로 보정(import.xlsx가 정합·산출 내부 일관성).
- structure §3 박종 proc 나열에 PROC_000044=트윙클 명시(특수박 군 구성과 직결·누락 보정).
- P4 컨펌은 박 시트 단독이 아니라 **명함박 라이브 .01 등록의 정합 감사**로 확대 권고(round-13 교정 트랙 연계 — "합가(완제품가)"라 적힌 comp가 .01인 것이 전사 관례인지).
- 이상 3건 모두 경미·구조 무손상 → 게이트 GO 유지(보정은 산출 일관성 차원).
