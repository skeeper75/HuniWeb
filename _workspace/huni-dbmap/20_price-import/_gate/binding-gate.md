# 제본 시트 import 게이트 (binding-gate) — round-16 독립 검증

> **검증자** dbm-validator (생성자 ≠ 검증자) · 2026-06-13
> **대상** `20_price-import/binding/` (structure·decomposition·import.xlsx·mapping-flow)
> **권위** openpyxl `data_only` 제본 시트 전수 스캔 + 라이브 `t_prc_*`/`t_proc_processes` information_schema read-only 실측
> **방법** "맞아 보임" 금지 — 빌더 주장을 의심하고 양 경계를 직접 떠서 대조

---

## 0. 종합 평결 — **CONDITIONAL-GO**

제본 그릇(RU 재현 + 무손실 대조 + 단절 명세)은 **GO**.
단 **BIND-C1(동시매칭/공식모델)은 컨펌(CONDITIONAL)이며 NO-GO 차단 아님** — 빌더가 `8_FIX`/`9_FIX`를 추정 적재하지 않고 `frm_cd 미정`·`prd_cd?`로 정직히 미해소 분리했기 때문. **단, 동시매칭 위험의 "원인 설명"이 부정확하여 보정 필요**(아래 P6).

핵심: 데이터 무손실·그릇 정합·단절 실측은 빌더 주장과 **전부 일치**. 뒤집힌 항목은 **3건의 패턴/원인 진단 부정확**(차단 아님·보정 권고).

---

## 1. P1~P6 게이트 표

| 게이트 | 판정 | 핵심 실측 근거 |
|--------|------|---------------|
| **P1 그릇 정합** | ✅ PASS | `t_prc_price_formulas` 라이브 컬럼=frm_cd/frm_nm/note/use_yn/reg_dt/upd_dt — **frm_typ_cd·prd_cd 부존재** 실측 확인. import.xlsx `1_price_formulas_RU`가 이 컬럼만 재현(부존재 컬럼 0). 상품바인딩=`t_prd_product_price_formulas` 별 테이블 분리 정합. `component_prices`에 proc_cd·opt_cd 실재(10차원). |
| **P2 stale 차단** | ✅ PASS | 10차원(siz/clr/mat/proc/coat_side/opt/bdl/min_qty…)·prc_typ_cd·use_dims 전부 라이브 반영. round-2 BLOCKED NULL 회귀 0 — BLOCKED 별 시트 없이 11종 전건 comp 실재로 수용(NULL 강제 0). |
| **P3 분해 무손실** | ✅ PASS | openpyxl 직접 카운트: B1 4열×8행=**32**, B2 3열×6행=**18**, B3 4열×6행=**24** → **합 74** (빌더 주장 정확 재현). rows 35~232 nonempty=**0**(세트형 미발견). 부유노트 `E14=표지비용 따로 계산`·`F25=삼각대 포함` 보존. 라이브 BIND 단가행 74 ↔ 엑셀 74셀 1:1, 값 대조(JUNGCHEOL 3000/2000/1500/1000/1000/700/700/500·CAL_WALL 5000/4000/3000/2500/2000/2000) 일치. **드롭/날조 0.** |
| **P4 단가/합가 정당** | ✅ PASS | 라이브 11 comp 전건 `PRICE_TYPE.01`(단가형)·use_dims=["min_qty"] 실측. 수량↑단가↓(중철 3000→500)·구간총액 표기 부재 → 단가형 정당. 합가형 회귀 0. |
| **P5 동시매칭 0 + comp_cd 분리 정당성** | 🟡 PASS-with-correction | **자연키 중복 0 실측**(BIND comp별 min_qty 중복 0). proc_cd **전건 NULL**(BIND 74행 0·전체 3481행 0) — 빌더 "proc_cd 0행" 정확. PROC_000017 자식 8종 실재(18~25) 확인. **🔴 뒤집힘: 빌더 "박=opt_cd, 스티커=mat_cd, 제본=comp_cd 세 번째 패턴"의 "박=opt_cd"가 라이브와 불일치** — opt_cd 전체 0행, 박(NAMECARD_FOIL_S1/S2_HOLO/STD)도 **comp_cd 분리**. 즉 comp_cd 분리는 제본 고유 신규 패턴 아님(박도 동일). |
| **P6 엔진 시뮬 + 동시매칭 쟁점** | 🟡 PASS-with-correction | 단절1(배선 PRF_BIND_SUM←JUNGCHEOL 1건만)·단절2(바인딩 PRD_000068~071 책자4종만) **라이브 직접 재확인=빌더 주장 정확**. 빌더가 `8_FIX`/`9_FIX`를 추정 INSERT 안 하고 컨펌 BIND-C1로 정직 분리 ✅. **🔴 단, 동시매칭 위험의 "원인 설명"이 부정확**(아래 §3). |

---

## 2. 빌더 주장 대비 검증 결과 (뒤집힘/보정 표)

| # | 빌더 주장 | 라이브/openpyxl 실측 | 판정 |
|---|----------|---------------------|------|
| 1 | 74 단가행(32+18+24) | openpyxl 전수 74·라이브 74·값 1:1 | ✅ **확인** |
| 2 | rows 33~232 전부 빈칸(세트형 없음) | rows 35~232 nonempty=0 | ✅ **확인** |
| 3 | proc_cd 전건 NULL·0행 | BIND 0·전체 3481행 proc_cd nonnull=0 | ✅ **확인** |
| 4 | 배선 1/11(JUNGCHEOL만)·단절1 | formula_components BIND=1행(JUNGCHEOL) | ✅ **확인** |
| 5 | 바인딩 책자4종만·단절2 | product_price_formulas BIND=PRD_000068~071 | ✅ **확인** |
| 6 | 자연키 중복 0 | (comp_cd,min_qty) 중복 0 | ✅ **확인** |
| 7 | **"박=opt_cd, 제본=comp_cd 세 번째 패턴"** | **opt_cd 전체 0행. 박도 comp_cd 분리(COMP_NAMECARD_FOIL_*)** | 🔴 **보정** — comp_cd 분리는 제본 고유 신규 아님 |
| 8 | **"단일 PRF_BIND_SUM에 11 comp 배선=전 제본방식 addtn 합산 오류"** | **Phase11 line 23: addtn_yn 무시·매칭 자동판정만. 진짜 원인=제본방식이 차원 컬럼 아님→선택 거를 메커니즘 부재** | 🔴 **보정**(원인 부정확·결론 위험은 실재) |
| 9 | PROC_000017 자식 8종(중철18~레이플랫25) | 실측 18 중철/19 무선/20 PUR/21 트윈링/22 떡/23 HC무선/24 HC트윈링/25 레이플랫 | ✅ **확인**(structure §4.1 "떡" 누락 표기는 미세 오기) |

---

## 3. 🔴 동시매칭 쟁점(BIND-C1) — 정밀 평결

**빌더 결론(위험 실재)은 옳으나 원인 설명이 틀렸다. 보정 후에도 CONDITIONAL(컨펌)이며 NO-GO 차단은 아니다.**

### 빌더가 말한 것 vs 실제 Phase11 규칙
- 빌더: "PRF_BIND_SUM에 11 comp를 다 배선하면 11개가 **addtn_yn=Y로 합산**되어 전 제본방식 단가가 더해진다."
- 라이브 권위(11-CONTEXT line 23·price_views.py line 10): **`addtn_yn`은 엔진에서 무시. 합산 대상=선택값 매칭 자동판정.** 미선택 옵션은 "매칭 실패로 자연 제외"(line 15). → addtn 합산이 원인이 아님.

### 진짜 결함 (검증자 발견 — 빌더 미포착)
- BIND comp는 use_dims=["min_qty"]만. **제본방식 자체는 어떤 차원 컬럼으로도 표현되지 않음**(siz/clr/mat/proc/opt 전건 NULL).
- 엔진의 "선택값 매칭"은 차원 컬럼 비교로만 작동. **제본방식 선택값을 비교할 차원이 없으므로**, 손님이 "무선" 선택해도 엔진은 어느 comp가 무선인지 알 수 없음 → 단일 공식에 11 comp 배선 시 11개 모두 min_qty만으로 매칭(차원 무관) → **결과적으로 전 제본방식 합산이 실제 발생**. 위험은 진짜다.
- **동형 결함 횡단성 입증**: COMP_COAT_GLOSSY/MATTE 둘 다 use_dims=["siz_cd","coat_side_cnt","min_qty"]로 **코팅종류 구분 차원 없음** → "무광 선택 시 유광 제외"(11-CONTEXT 약속)가 라이브 데이터로는 미작동. comp_cd 분리 패턴 전반의 구조적 구멍이며 **제본 고유 아님**.

### 정당한 모델 (검증자 평결)
- 빌더 (A)안(상품별 공식 PRF_BIND_<방식> 1:1 바인딩) = **유효**. 상품이 제본방식 1개 고정이면 공식이 comp 1개만 배선 → 차원 부재 무관·동시매칭 0. 빌더 권고 방향 맞음.
- 빌더 (B)안(opt_cd 옵션 차원) = **유효하며 더 근본적**. 제본방식을 opt_cd 차원에 올리면 엔진의 "옵션코드=X 매칭"(11-CONTEXT line 21)이 작동 → 단일 공식·선택값 거름 정상. 단 comp_cd 분리 모델과 충돌(L2 재설계).
- **comp_cd 분리 모델이 동시매칭을 해소하려면**: 반드시 (A) 상품↔제본방식 1:1(공식별 comp 1개) 보장이 필요. 즉 comp_cd 분리는 "한 상품이 한 제본방식만" 전제에서만 안전. 손님이 같은 상품에서 제본방식을 **고를 수 있다면** comp_cd 분리는 부적합하고 opt_cd(B안) 필요.

### 차단 vs 컨펌 판정 → **CONDITIONAL(컨펌)**
- 빌더가 위험을 **추정 적재로 닫지 않고**(`8_FIX` frm_cd 미정·"그대로 INSERT 금지" 명시, `9_FIX` prd_cd? 추정 명시) **컨펌 BIND-C1로 정직 분리** → 게이트 통과 가능.
- 단 decomposition §6·mapping-flow §3의 **"11 comp 합산=동시매칭"의 원인을 "addtn 합산"이 아니라 "제본방식 차원 부재"로 보정**하고, BIND-C1 선택지에 "comp_cd 분리는 상품당 제본방식 1개 전제에서만 성립" 단서를 추가 권고.

---

## 4. 구조 평결 (요청 명시 질문)

- **MATRIX 동형인가?** ✅ 예. 제본방식(열)×수량구간(행) 단가 매트릭스 — 스티커·엽서북떡메와 동형. 면적매트릭스(size×size) 아님. 빌더 "세트형 신규 구조 아님" 평결 정확.
- **세트형 미발견인가?** ✅ 예. rows 35~232 nonempty=0 실측.
- **comp_cd 분리가 신규 패턴인가?** 🔴 **아니오**. opt_cd 전체 0행·박도 comp_cd 분리 → comp_cd 분리는 라이브 가격엔진의 일반 패턴(박·코팅·별색 다수 동일). "제본=세 번째 신규 패턴"은 보정 대상.

---

## 5. 라우팅 (dbm-price-import-builder 회신)

| 항목 | 보정 요청 | 우선도 |
|------|----------|--------|
| 패턴 진단 | "박=opt_cd, 제본=comp_cd 세 번째 패턴" → 라이브 opt_cd 0행·박도 comp_cd 분리. comp_cd 분리=일반 패턴으로 정정 | Medium |
| 동시매칭 원인 | "addtn 합산" → "제본방식이 차원 컬럼 아님(use_dims=min_qty만)→선택 거를 메커니즘 부재"로 보정. addtn_yn은 엔진 무시(11-CONTEXT line 23) | Medium |
| BIND-C1 단서 | comp_cd 분리 모델은 "상품당 제본방식 1개 고정" 전제에서만 동시매칭 0. 손님 선택형이면 opt_cd(B안) 필요 명시 | Medium |
| structure §4.1 | PROC_000017 자식 표기에 "떡제본(PROC_000022)" 누락 — 실측 8종 모두 자식 | Low |

**차단(NO-GO) 항목 0.** 전부 진단/문구 보정(Medium 이하).

---

## 6. insertable / BLOCKED / 컨펌 집계

| 분류 | 행수 | 비고 |
|------|------|------|
| **RU 재현(기존 적재·대조용)** | formula 1·바인딩 4·배선 1·comp 11·단가행 74 | 무손실 검증 완료·신규 적재 0 |
| **🔴 단절1 교정후보(배선 +10)** | 10 | `8_FIX`·frm_cd 미정·BIND-C1 선결 |
| **🔴 단절2 교정후보(바인딩 +5?)** | 5? | `9_FIX`·prd_cd 추정·BIND-C2 선결 |
| **컨펌(미해소·정직 분리)** | 3 | BIND-C1(공식모델)·BIND-C2(상품↔제본방식)·BIND-C3(표지비 그릇) |

---

## 7. 검증 인용 (직접 실측 근거)

```
# openpyxl 제본 시트 (data_only)
DIMS 232x25 · MERGED A1:E1,A14:D14,A25:E25 · rows35..232 nonempty=0
B1 32 / B2 18 / B3 24 = 74 데이터셀
E14='표지비용 따로 계산' F25='삼각대 포함'

# 라이브 t_prc_component_prices (BIND)
11 comp · 74행 (JUNGCHEOL/MUSEON/PUR/TWINRING=8, 나머지 7=6)
proc_cd nonnull=0 / opt_cd nonnull=0 / 전체 3481행 proc·opt 둘 다 0
자연키 (comp_cd,min_qty) 중복=0
JUNGCHEOL: 1→3000 4→2000 10→1500 30→1000 50→1000 70→700 100→700 1000→500  (엑셀 일치)
CAL_WALL:  1→5000 4→4000 10→3000 50→2500 100→2000 1000→2000              (엑셀 일치)

# 배선/바인딩
formula_components: PRF_BIND_SUM ← COMP_BIND_JUNGCHEOL (1건만)
product_price_formulas: PRD_000068~071 ← PRF_BIND_SUM (4건만)

# Phase11 엔진 규칙 (권위 반증)
11-CONTEXT line15: 합산 대상=선택값 매칭 자동판정·미선택 자연 제외
11-CONTEXT line23: addtn_yn=엔진 무시
price_views.py line10/396: 동시매칭=한 comp 내 차원조합 2행 이상=데이터오류

# comp_cd 분리 = 일반 패턴 (박 반증)
박: COMP_NAMECARD_FOIL_S1_HOLO/S1_STD/S2_HOLO/S2_STD/SETUP (comp_cd 분리·opt_cd NULL)
코팅: GLOSSY/MATTE 둘 다 use_dims=[siz,coat_side,min_qty] — 코팅종류 차원 없음(횡단 결함)
```
