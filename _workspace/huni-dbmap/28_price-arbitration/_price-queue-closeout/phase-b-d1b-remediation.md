# Phase B — D-1b 후가공 prc_typ 메타 오적재 정정 제안본 (round-19 가격 폐루프)

> 작성 2026-06-15 · round-19 Phase B · `dbm-price-arbiter`. **비파괴**(제안·심의·멱등 SQL/INSERT 제안문까지 · 실 COMMIT/DDL = 인간 승인).
> **권위(HARD) = 가격표 엑셀 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`** + `_price-remediation-queue.md` §1 + Phase A 확정. 라이브 `t_prc_*`·`t_cod_base_codes`는 검증 교차 오라클(2026-06-15 읽기전용 SELECT)이지 권위 아님.
> 입력 재사용(재유도 0): [[phase-a-pricetable-recheck]]·[[26_price-engine-verify/PRF_DGP_A/d1-plate-conversion]] §5(ⓒ 입증·C4 단조성)·[[PRF_DGP_A/remediation-plan]] §3.3·[[_price-remediation-queue]] §1.
> **돈-크리티컬** — 단가행 `unit_price` 절대 불변(값 정확·메타만 오적재). 보정 하드코딩 0. 거짓 RESOLVED 금지.

---

## 0. 제안본 결론 요약

| 항목 | 결론 |
|---|---|
| **정정 방식** | **ⓒ-2 채택** — 신규 `PRICE_TYPE.03 구간고정총액형` base_code 1행 + 그룹① comp prc_typ를 .03으로 + 엔진 .03 분기. ⓒ-1(.02 재사용)은 명세식 ÷mq×qty 충돌(C4 250매 새 오류) → 기각. **라이브 base_code 실측이 ⓒ-2 충돌 0 확인**(.01/.02만 존재·.03 비점유). |
| **정정 대상 comp 최종 카운트** | **13 comp**(CREASE 3 + PERF 3 + VARTEXT 3 + VARIMG 3 + **CORNER_ROUND 1**). CUT_PERF_1H6 제외(Phase A 확정·0원 placeholder)·CORNER_RIGHT 제외(전구간 0원). |
| **돈-영향** | 미싱1줄 100매 엔진 .01 해석 = 10,000×100 = **1,000,000**(과대 990,000) → .03 정정 = **10,000**(1회). 엽서·상품권(핵심)·접지 동시 정상화. |
| **트랙** | prc_typ UPDATE = **round-13 정정 트랙** / base_code 선적재 = **round-13(또는 ddl-proposer 경량)** / 엔진 .03 규칙 = **webadmin Phase11**(우리 밖·명세 제안만). |
| **동시 배포 경고** | prc_typ를 .03으로 바꾸고 엔진이 .03 모르면 **미정의 동작** → prc_typ UPDATE와 엔진 .03 규칙은 **반드시 동시 배포**. |
| **미해소 컨펌** | `C-D1b`(ⓒ-1 vs ⓒ-2·엔진 합가규칙 범위) · `CONFIRM:D1b-06`(그룹② 박/완칼 .06 엔진 해석) — 정직 분리(둘 다 webadmin Phase11 엔진 명세 의존). |

---

## 1. 정정 방식 확정 근거 — ⓒ-2 vs ⓒ-1 (라이브 base_code 실측으로 뒷받침)

### 1-1. 가격표 권위 재확인 (왜 정정이 필요한가)

[[d1-plate-conversion]] §5-1~5-3 재사용(재유도 0):
- 가격표 `인쇄후가공` 시트 헤더 작성자 명시: **A1 `'모서리 (귀돌이, 합가)'`** · **A15 `'오시 (합가)'`** · **F15 `'미싱 (합가)'`** = 셀 값이 장당가 아닌 **수량구간별 고정 총액**.
- 판별 확정 = **ⓒ 구간고정총액형**(수량 무관 1회 부과). ⓐ 단가형·ⓑ 명세식 합가형(÷mq×qty) 모두 기각 — C4 250매 단조성 위반 입증(§5-2).
- 라이브 단가행 값은 가격표 "합가" 총액과 **전건 일치**(216/216, round-16) = **값 손상 0, `prc_typ_cd` 메타만 .01 오적재**.

### 1-2. 라이브 PRICE_TYPE 코드값 실측 (ⓒ-2 충돌 0 확인)

```
t_cod_base_codes WHERE upr_cod_cd='PRICE_TYPE' (2026-06-15 읽기전용):
  cod_cd        | cod_nm    | upr_cod_cd | disp_seq | use_yn
  PRICE_TYPE    | 단가유형  |            |          | Y      ← 그룹 헤더
  PRICE_TYPE.01 | 단가형    | PRICE_TYPE | 1        | Y
  PRICE_TYPE.02 | 합가형    | PRICE_TYPE | 2        | Y
```

- **`.03` 코드값 부재 확인** → 신규 `PRICE_TYPE.03` INSERT 시 PK 충돌 0·기존 .02 사용처 무회귀. ⓒ-2의 base_code 1행 추가가 안전함을 라이브로 실증.
- 컬럼 구조: `cod_cd`(PK)·`cod_nm`·`upr_cod_cd`(상위코드)·`disp_seq`·`use_yn`(NOT NULL)·`note`·`reg_dt`(NOT NULL DEFAULT now())·`upd_dt`. → INSERT 시 `reg_dt`는 DEFAULT 발화 주의(메모리 [[dbmap-round5-load-execution]] reg_dt NOT NULL 함정).

### 1-3. ⓒ-1 vs ⓒ-2 트레이드오프 (큐 §1-3 재요약 + 실측 뒷받침)

| 방식 | 무엇 | 장점 | 단점 | 판정 |
|------|------|------|------|:--:|
| **ⓒ-1** | 그룹① prc_typ를 `.02(합가형)`로 변경 + 엔진 합가규칙을 "매칭 구간총액 그대로(÷mq×qty 없음)"로 재정의 | DDL 0(기존 코드 재사용)·UPDATE만 | 라이브 `.02`의 기존 의미(명세식 ÷mq×qty, 11-CONTEXT §16)와 **충돌** → 엔진이 두 합가형을 구분 못 하면 명세식이 적용돼 **C4 250매 새 오류**(÷100×250=25,000 > 300매 15,000 = 단조성 위반·[[d1-plate]] §5-5). 기존 .02 사용 comp 회귀 위험 | **기각** |
| **ⓒ-2** | 신규 `PRICE_TYPE.03(구간고정총액형)` base_code 1행 + 그룹① prc_typ를 .03으로 + 엔진 .03 분기 | 의미 명확 3분리(.01 단가/.02 명세합가/.03 구간총액)·기존 .02 **무회귀**(실측 충돌 0)·엔진 분기 1개로 봉인 | base_code 1행 추가(경량)·엔진 분기 1개 추가 | **○ 채택** |

**채택 = ⓒ-2.** 근거:
1. **ⓒ-1은 .02에 두 거동(명세식 ÷mq×qty / 구간총액 그대로)을 욱여넣어**, 엔진이 분기 못 하면 명세식이 발화돼 **새 돈 오류**를 만든다(C4 250매). 큐 §1-3·d1-plate §5-5와 동일.
2. **ⓒ-2는 라이브 실측(.01/.02만·`.03` 비점유)으로 충돌 0이 확인**돼, 의미를 명시 분리하고 기존 .02 사용처를 건드리지 않는다(무회귀).
3. 단 **ⓒ-1/ⓒ-2 모두 엔진(evaluate_price)이 그 prc_typ를 올바로 해석해야 실효** → webadmin Phase11 범위. DB측 정정(prc_typ 메타 UPDATE)은 round-13 트랙.

> **컨펌 분리**: ⓒ-2가 **권고**이나, ⓒ-1 채택(엔진이 명세식/구간총액을 다른 신호로 분기할 수 있다는 webadmin 판단)도 가능 → `C-D1b`로 실무진/엔진팀 결정에 남김. 본 제안본은 ⓒ-2 형태로 산출하되, ⓒ-1 채택 시 base_code §2를 건너뛰고 §3 UPDATE의 `.03`을 `.02`로 치환하면 됨(거짓 단정 금지).

---

## 2. base_code 선적재 제안 (ⓒ-2·round-13 또는 ddl-proposer 경량·실 적용 인간 승인)

라이브 `.01/.02` 동형 구조로 신규 `PRICE_TYPE.03` 1행 선적재. 멱등(이미 존재 시 no-op).

```sql
-- ⓒ-2: 신규 단가유형 코드 선적재 (그룹① prc_typ UPDATE보다 먼저 — FK/도메인 선행)
-- 라이브 t_cod_base_codes 실측 컬럼·동형(.01/.02) 구조 그대로.
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, note, reg_dt)
VALUES (
  'PRICE_TYPE.03',          -- cod_cd (PK·라이브 .03 비점유 실측 확인)
  '구간고정총액형',          -- cod_nm (수량구간별 고정 총액·수량 무관 1회 부과)
  'PRICE_TYPE',             -- upr_cod_cd (그룹 헤더)
  3,                        -- disp_seq (.01=1·.02=2 다음)
  'Y',                      -- use_yn (NOT NULL)
  '수량구간 매칭 unit_price를 곱셈/나눗셈 없이 1회 합산(후가공 오시/미싱/가변/둥근모서리 등)',  -- note
  now()                     -- reg_dt (NOT NULL DEFAULT now() — 명시 권장, DEFAULT 함정 회피)
)
ON CONFLICT (cod_cd) DO NOTHING;  -- 멱등(이미 .03 존재 시 no-op)
```

> `reg_dt`를 명시(now())해 NOT NULL DEFAULT 미발화 함정([[dbmap-round5-load-execution]]) 회피. `upd_dt`는 INSERT 시 NULL 허용(컬럼 is_nullable=YES).
> **트랙**: base_code는 코드값(기초데이터) → round-13 정정 또는 ddl-proposer 선적재 큐. ALTER/CREATE 아님(행 추가) = 경량.

---

## 3. 그룹① 13 comp 멱등 UPDATE SQL (라이브 실측 IN절 확정)

### 3-1. 정정 대상 카운트 확정 — **13 comp** (CUT_PERF_1H6 제외·카운트 정합 명시)

> **카운트 정합 주의**: 큐 §1-2 그룹①은 "COMP_PP_* 12 + CUT_PERF_1H6 1 = 13"으로 기술했으나, Phase A 확정(CUT_PERF_1H6 제외)을 적용하면 **CUT_PERF_1H6 자리를 빼는 대신 CORNER_ROUND가 정정 대상**이다. 큐 §1-4 IN절은 이미 CORNER_ROUND 포함 13개를 나열(CUT_PERF_1H6은 주석으로 분리)했으므로, **확정 IN절 = CORNER_ROUND 포함 13 comp**가 큐 §1-4와 일관된다. Phase A §4의 "13→12"는 "CUT_PERF_1H6 빼기"를 가리킨 표현이며, **CORNER_ROUND를 빼는 의미가 아님**(둥근모서리는 0원 placeholder가 아니라 누진 총액형·정정 진성 대상).

라이브 실측(2026-06-15)으로 각 comp 실재·현 prc_typ(.01)·단조성 확정:

| comp_cd | comp_nm | 현 prc_typ | comp_typ | 단가행 | 단조성(min_qty↑ unit_price) | 정정 대상 |
|---------|---------|:--:|:--:|:--:|---|:--:|
| COMP_PP_CREASE_1L | 오시 1줄 | .01 | .04 | 10 | 5000→10000→15000…105000 ↑ 누진 | ✅ |
| COMP_PP_CREASE_2L | 오시 2줄 | .01 | .04 | 10 | 누진(동형) | ✅ |
| COMP_PP_CREASE_3L | 오시 3줄 | .01 | .04 | 10 | 누진(동형) | ✅ |
| COMP_PP_PERF_1L | 미싱 1줄 | .01 | .04 | 10 | 5000→10000→15000…105000 ↑ 누진 | ✅ **상품권 핵심** |
| COMP_PP_PERF_2L | 미싱 2줄 | .01 | .04 | 10 | 누진 | ✅ |
| COMP_PP_PERF_3L | 미싱 3줄 | .01 | .04 | 10 | 누진 | ✅ |
| COMP_PP_VARTEXT_1EA | 가변텍스트 1개 | .01 | .04 | 23 | 15000→15000→20000…↑ 누진 | ✅ |
| COMP_PP_VARTEXT_2EA | 가변텍스트 2개 | .01 | .04 | 23 | 누진 | ✅ |
| COMP_PP_VARTEXT_3EA | 가변텍스트 3개 | .01 | .04 | 23 | 누진 | ✅ |
| COMP_PP_VARIMG_1EA | 가변이미지 1개 | .01 | .04 | 23 | 누진 | ✅ |
| COMP_PP_VARIMG_2EA | 가변이미지 2개 | .01 | .04 | 23 | 누진 | ✅ |
| COMP_PP_VARIMG_3EA | 가변이미지 3개 | .01 | .04 | 23 | 누진 | ✅ |
| **COMP_PP_CORNER_ROUND** | 모서리 둥근 | .01 | .04 | 9 | 2000→2000→4000…51000 ↑ 누진 | ✅ |
| ~~COMP_PP_CORNER_RIGHT~~ | 모서리 직각 | .01 | .04 | 9 | **전구간 0.00** | ✗ 제외(무영향) |
| ~~COMP_CUT_PERF_1H6~~ | 타공비(후가공) | .01 | .04 | 23 | **전구간 0.00**(Phase A) | ✗ 제외(0원 placeholder·진짜 타공=CUT_FULL_PERF_*) |

→ **정정 대상 = 13 comp**. CORNER_RIGHT·CUT_PERF_1H6 = 전구간 0.00 실측 → prc_typ가 .01이든 .03이든 **가격 기여 0**(정정 무의미·제외).

### 3-2. 멱등 UPDATE SQL (base_code 선적재 후·단가행 절대 불변)

```sql
-- 전제: §2 base_code PRICE_TYPE.03 선적재 완료 + 엔진 .03 규칙 배포(동시).
-- 그룹① 후가공 .04 comp 13종 prc_typ를 구간고정총액형(.03)으로 정정.
-- 멱등: 이미 .03이면 no-op. unit_price(단가행) 절대 변경 없음(값은 정확).
UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.03', upd_dt = now()
WHERE comp_cd IN (
  'COMP_PP_CREASE_1L','COMP_PP_CREASE_2L','COMP_PP_CREASE_3L',
  'COMP_PP_PERF_1L','COMP_PP_PERF_2L','COMP_PP_PERF_3L',
  'COMP_PP_VARTEXT_1EA','COMP_PP_VARTEXT_2EA','COMP_PP_VARTEXT_3EA',
  'COMP_PP_VARIMG_1EA','COMP_PP_VARIMG_2EA','COMP_PP_VARIMG_3EA',
  'COMP_PP_CORNER_ROUND'   -- 둥근모서리(누진 총액형·진성 정정 대상)
)
AND prc_typ_cd <> 'PRICE_TYPE.03';   -- 멱등 가드
-- 제외 확정: COMP_PP_CORNER_RIGHT(직각·0원)·COMP_CUT_PERF_1H6(타공 placeholder·0원)
-- 그룹② .06/.05(박·완칼)은 [CONFIRM:D1b-06] 해소 후 별도 UPDATE(§5).
```

> **무엇을 바꾸나(돈-크리티컬 명세)**: `t_prc_price_components.prc_typ_cd` 메타 1컬럼만. **`t_prc_component_prices.unit_price`(단가행)는 절대 미변경** — 값은 가격표 전건 일치(round-16 216/216). 정정은 "엔진이 이 값을 어떻게 쓰나"(메타)만 교정.
> **멱등성**: `AND prc_typ_cd <> 'PRICE_TYPE.03'`로 재실행 시 delta 0([[dbmap-tierA-cpq-option-load]] 멱등 실증 패턴).

---

## 4. 엔진 .03 해석 규칙 명세 (webadmin Phase11 범위 — 우리는 제안만 · `C-D1b`)

> **이건 우리 밖**(엔진 evaluate_price 미구현). 명세 초안 제안까지 — 실 구현은 webadmin Phase11. `C-D1b`로 분리.

### 4-1. .03 규칙 초안 (11-CONTEXT §16 합가형 명세에 추가할 케이스)

```
[PRICE_TYPE.03 구간고정총액형]
- 입력: 주문 수량 qty, 해당 comp의 component_prices 행 집합(min_qty 오름차순).
- 매칭: min_qty <= qty 인 행 중 min_qty 최대 행 1개 선택(수량구간 룩업).
- 산출: 그 행의 unit_price를 그대로 1회 합산. (÷min_qty 없음·×qty 없음·곱셈 없음.)
- 차원: siz_cd 등 use_dims가 NULL이면 차원 무관(후가공 13 comp 전부 siz_cd=NULL 실측).
- 대비:
    .01 단가형      → unit_price × qty
    .02 합가형(명세식) → unit_price ÷ min_qty × qty   (11-CONTEXT §16 기존)
    .03 구간고정총액형 → unit_price (1회·수량 무관)     ← 신규
```

### 4-2. 규칙 검증 (가격표 단조성)

- 미싱1줄 250매 → 매칭 구간 = 100구간(min_qty≤250 최대) → unit_price 10,000 **그대로 1회** = 10,000.
- 비교: .01이면 10,000×250=2,500,000(과대) / .02 명세식이면 10,000÷100×250=25,000(300매=15,000 초과 = 단조성 위반).
- → **.03만 가격표 단조 정합**(250매 ≤ 300매 총액). C4 비경계 입증과 일치([[d1-plate]] §5-5).

> **동시 배포 경고(재강조)**: prc_typ를 .03으로 UPDATE했는데 엔진이 .03 분기를 모르면 **미정의 동작**(폴백이 .01이면 또 과대청구·NULL이면 가격 침묵 누락). → §3 UPDATE와 §4 엔진 규칙은 **반드시 동시 배포**. 분리 배포 금지.

---

## 5. 그룹② 박/완칼 .06/.05 9 comp — `CONFIRM:D1b-06` 분리 (거짓 RESOLVED 금지)

> 본 Phase B는 **그룹①(후가공 .04) prc_typ 정정에 한정**. 그룹②는 prc_typ 관점만 다루고 **`CONFIRM:D1b-06`로 분리**.

### 5-1. 사실 (큐 §1-2 그룹② + 각주 재사용)

| comp_cd | comp_typ | 단가행 | 배선 | 비고 |
|---------|:--:|:--:|---|---|
| COMP_NAMECARD_FOIL_S1/S2_STD·HOLO (박) | .06 | 9 each | 미배선 | 명함 박·**종이포함 완제품가**(Phase A WIRE-3 확정) |
| COMP_NAMECARD_FOIL_SETUP_S1/S2_STD (동판셋업) | .05 | 1(5,000) | 미배선 | 셋업비 |
| COMP_CUT_FULL_DIECUT (완칼 도무송) | .06 | 36 | PRF_DGP_B/F | 스티커·굿즈 완칼 |
| COMP_CUT_FULL_PERF_1H6/2H6 (완칼 타공·진짜 타공) | .06 | 9 each | 미배선 | Phase A: F42 "타공(합가)" 블록 권위 |

### 5-2. 왜 분리하나 (정직)

- .06(완제품가)/.05(셋업비)는 **comp_typ 자체가 "완제품 총액/셋업 정액"을 의미** → 단조성상 총액형이 맞다(그룹①과 거동 유사).
- 그러나 **정정 대상인지(현 엔진이 .06을 ×수량 하는지)는 엔진 명세 확인 필요**. .06이 정당하게 "수량구간 총액"으로 해석되도록 엔진이 이미 설계됐다면 **D-1b 오적재가 아니라 정상 설계**일 수 있다 → 추측 정정 금지.
- 그룹②는 **Phase C(WIRE 박 배선)와도 연결**(명함 박 미배선·042 박 comp 부재·박 공용 comp 신설) → 박 배선·042 신설은 **Phase C 소관**. 본 Phase B에서 박 prc_typ를 단정 정정하면 Phase C와 **중복/충돌**.
- → **그룹② prc_typ는 `CONFIRM:D1b-06`(엔진 .06 해석) + Phase C(배선·신설)에서 통합 결정**. 본 제안본은 그룹② UPDATE를 **발행하지 않음**(거짓 RESOLVED 금지).

> **Phase C 라우팅 명시**: 명함031 박 배선·042 박 공용 comp 신설·박 면적등급 차원·`CONFIRM:WIRE-3b`(소형/대형 시트) = **Phase C 소관**. 본 Phase B는 이를 다루지 않음(중복 작업 금지).

---

## 6. 재검증 게이트 (폐루프·RESOLVED 판정 기준)

### 6-1. 정정 적용 후(엔진 .03 + §3 prc_typ UPDATE) 기대값

| 케이스 | 현 거동(.01×qty) | **ⓒ-2 정정(.03)** | 가격표 정합 | 가격사슬 |
|---|--:|--:|:--:|---|
| **엽서 C3**(016·오시1줄·무광코팅단면·100매) | 1,094,330 🔴 | **104,330** | ✅ | PRF_DGP_A → COMP_PP_CREASE_1L(.03) → cp[min_qty=100]=10,000(1회) |
| **상품권 C2**(041·미싱1줄·100매) | 후가공분 1,000,000 🔴 (총 ~1,038,073) | 후가공분 **10,000** → 총 **48,073** | ✅ | PRF_DGP_A → COMP_PP_PERF_1L(.03) → cp[min_qty=100]=10,000(1회) |
| **C4 비경계**(250매·오시1줄·무코팅) | 2,595,825 🔴 | ⓒ=**10,000** (≠ ⓑ명세식=25,000) | ✅ ⓒ만 단조 정합 | COMP_PP_CREASE_1L(.03) → cp[min_qty=100]=10,000(≤250 최대구간) |

### 6-2. 가격사슬 추적 (어느 공식 → 어느 comp → 어느 component_prices 단가행) — 라이브 실측

| 케이스 | 공식(frm_cd) | comp_cd | component_prices 룩업(실측) | 정정 후 산출 |
|---|---|---|---|--:|
| 엽서 C3 후가공분 | **PRF_DGP_A** (formula_components 실측) | COMP_PP_CREASE_1L | min_qty=100·siz_cd=NULL·unit_price=**10,000** | 10,000 (1회·.03) |
| 상품권 C2 후가공분 | **PRF_DGP_A** (실측 배선) | COMP_PP_PERF_1L | min_qty=100·siz_cd=NULL·unit_price=**10,000**(라이브 직접 확인) | 10,000 (1회·.03) |
| 접지카드(공유) | **PRF_DGP_D** (CREASE/PERF/VAR 양쪽 배선 실측) | 동상 13 comp | 동상 | 동일 정정 자동 반영 |

> **ROI 실증(라이브 배선)**: CREASE/PERF/VARTEXT가 **PRF_DGP_A + PRF_DGP_D 양쪽 배선** 확인 → D-1b 1건 정정(comp.prc_typ)으로 **PRF_DGP_A(엽서·상품권)+PRF_DGP_D(접지) 동시 해소**. comp 단위 정정이라 배선된 모든 공식에 자동 전파 = 최고 ROI.

### 6-3. RESOLVED 판정 규칙

- [ ] 위 3 케이스가 **보정 하드코딩 0**으로 라이브 단가(component_prices)만으로 재현([HARD]). [[d1-recompute.py]]가 `compute_corrected` 없이 .03 규칙으로 산출.
- [ ] 엽서 C3 = 104,330 · 상품권 C2 총 48,073 · C4 = 10,000(ⓒ만) 가격표 정합.
- [ ] 단가행 `unit_price` 미변경 검증(정정 전후 component_prices byte-identical).
- 충족 시 **D-1b 그룹① RESOLVED**. 그룹②는 `CONFIRM:D1b-06` 해소 + Phase C 박 배선 후 별도 폐루프(본 게이트 범위 밖).

> **거짓 RESOLVED 차단**: 엔진 미구현 상태에서 재시뮬은 검증용 계산기(.03 규칙 구현)로만 — 그 계산기가 라이브 단가만 읽어 가격표 known과 일치할 때만 RESOLVED. 보정값 주입 시 무효.

---

## 7. 트랙 라우팅 · 동시 배포 경고 · 실 적용 인간 승인

| 산출물 | 트랙 | 실 적용 |
|---|---|---|
| §2 base_code `PRICE_TYPE.03` INSERT | round-13 정정(또는 ddl-proposer 경량·행 추가) | 인간 승인 |
| §3 그룹① 13 comp prc_typ UPDATE | **round-13 정정 트랙**(prc_typ 메타) | 인간 승인 |
| §4 엔진 .03 해석 규칙 | **webadmin Phase11**(evaluate_price·우리 밖·명세 제안만) | webadmin 구현 |
| §5 그룹② 박/완칼 prc_typ | `CONFIRM:D1b-06` 해소 후 + **Phase C** 박 배선 통합 | 보류 |

> **⚠ 동시 배포 필수 경고**: §3 prc_typ UPDATE(.03)와 §4 엔진 .03 규칙은 **반드시 동시 배포**. 메타만 .03 바꾸고 엔진이 .03 모르면 미정의 동작(폴백 .01=과대청구 / NULL=가격 침묵 누락). 분리 배포 금지.
> **비파괴 준수**: 본 제안본은 SQL/INSERT **제안문**까지. 실 COMMIT/DDL 없음. round-13/webadmin 인계 후 인간 승인.

---

## 8. 미해소 컨펌 (정직 분리)

| 컨펌ID | 무엇 | 누가 결정 | 미해소 시 |
|--------|------|----------|----------|
| **C-D1b** | 정정 방식 ⓒ-2(신규 .03·권고) vs ⓒ-1(.02 재사용) + 엔진 합가규칙 범위 | webadmin Phase11(엔진) + 실무진 | prc_typ 정정 보류(엔진 미구현=실청구 0·안전). ⓒ-1 채택 시 §2 생략·§3 `.03`→`.02` 치환 |
| **CONFIRM:D1b-06** | 그룹② 박/완칼 .06/.05(9 comp)가 D-1b 오적재인지 정상 완제품가형인지(엔진이 .06을 ×수량 하는지) | webadmin Phase11 엔진 명세 | 그룹② 정정 보류(본 Phase B 미발행)·Phase C와 통합 결정 |

> 두 컨펌 모두 **webadmin Phase11 엔진 명세에 의존** — 본 Phase B(가격표 권위 + 라이브 메타 정정)로 닫을 수 없음(정직). 엔진 미구현이라 실청구 위험 0(큐 적재 유지·적용 시점 유예 안전).
> **본 제안본 비파괴 — 분석·심의·SQL/INSERT 제안문까지. 실 COMMIT/DDL/엔진구현은 인간 승인.**
