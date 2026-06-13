# 커팅타공 import 그릇 게이트 (P1~P6) — round-16 독립 검증

> 검증자 = dbm-validator(생성자 아님·빌더 의심·직접 실측). 권위 = 원본 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`>`커팅타공`(openpyxl 전수 재카운트) + 라이브 `t_prc_*`·`t_siz_sizes`·`t_cod_base_codes` information_schema(`.env.local` `RAILWAY_DB_*` 읽기전용 SELECT, `db railway`, 2026-06-13).
> 빌더 산출 = `cutting-drilling/{structure·decomposition·import.xlsx·mapping-flow}`.
> **방법: 빌더 주장을 보지 않고 원본·라이브를 직접 측정한 뒤, 빌더 주장과 대조.**

---

## 종합 평결: **GO** (P1~P6 전건 PASS)

빌더의 4개 핵심 주장(① 무손실 77셀 ② 타공합가 prc_typ_cd .02가 맞음 ③ 가격사슬 단절 ④ min_qty stale)을 **전건 독립 실측으로 입증**. 뒤집힌 주장 0. 검증자 추가 발견 1건(V-1, MINOR·블로커 아님).

| 게이트 | 판정 | 근거(실측) |
|--------|------|-----------|
| P1 그릇=라이브 1:1 | ✅ PASS | import 시트4 컬럼 = 라이브 컬럼 1:1(10차원 반영) |
| P2 stale 차단 | ✅ PASS | prc_typ_cd·proc_cd·opt_cd·use_dims 전부 반영(round-2 8차원 잔재 0) |
| P3 분해 무손실 77 | ✅ PASS | 원본 직접 카운트 36+23+9+9=77 = 라이브 77 = import 77 |
| P4 단가/합가 | ✅ PASS | 라이브 4 comp 전부 .01 실측 → 타공합가 2건 .02 교정제안 정당 |
| P5 동시매칭0 + 차원 | ✅ PASS | siz=SIZ_000499·comp 분리·opt/proc NULL·중복 0. stale-C 시트 권위 확인 |
| P6 가격사슬 | ✅ PASS(결함 정직 보고) | 타공합가 2 comp 배선 0 실측 = 단절 정확 |

---

## P1 — 그릇 = 라이브 1:1 ✅ PASS

라이브 `t_prc_price_components` 컬럼(실측): `comp_cd·comp_nm·comp_typ_cd·note·use_yn·reg_dt·upd_dt·prc_typ_cd·use_dims` — prc_typ_cd·use_dims 실재.
라이브 `t_prc_component_prices` 컬럼(실측, 10 자연키): `comp_price_id·comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·unit_price·note·reg_dt·upd_dt·**proc_cd·opt_cd**`.
import.xlsx `4_component_prices_FIX` 컬럼 행: `comp_cd·siz_cd·clr_cd·mat_cd·proc_cd·coat_side_cnt·opt_cd·bdl_qty·min_qty·apply_ymd·unit_price·note` — **라이브 10차원 1:1**(comp_price_id=IDENTITY 제외 정당). 한국어 라벨 행 병기.

## P2 — stale 차단 ✅ PASS

round-2 산출의 8차원·prc_typ 부재 잔재 없음. import 그릇이 `proc_cd·opt_cd` 차원 컬럼을 명시(둘 다 NULL=와일드카드로 정당 사용), `prc_typ_cd`(라이브/제안 2열)·`use_dims` 반영. PRICE_TYPE 코드 라이브 실측: `.01=단가형 / .02=합가형`(`t_cod_base_codes` upr_cod_cd='PRICE_TYPE').

## P3 — 무손실 77 ✅ PASS (빌더 주장 정확)

**원본 시트 openpyxl 전수 재카운트(검증자 직접):**
| 블록 | 원본 데이터셀 | import 행 | 라이브 행 |
|------|---------------|-----------|-----------|
| B1 완칼 A3:B38 | 36 (수량 1~1000) | 36 | 36 |
| B2 타공단가 A44:B66 | 23 (전부 0.0·C 2구 빈칸) | 23 | 23 |
| B3 타공합가 1구 G44:G52 | 9 | 9 | 9 |
| B3 타공합가 2구 H44:H52 | 9 | 9 | 9 |
| **합계** | **77** | **77** | **77** |

라벨노트 6(C1·C2·A39·D42·F53·F54) → import `N1_increment_rules_REF` 시트 보존. C(2구 단가) 23셀 빈칸 = 미입력 정당.
**병합셀 실측** = `A1:B1·A39:B39·A42:C42·F42:H42·F53:H53·F54:H54` — 빌더 주장과 byte 일치.

## P4 — 단가/합가 ✅ PASS (빌더 주장 정확)

라이브 `t_prc_price_components.prc_typ_cd` 실측: **4 comp 전부 PRICE_TYPE.01(단가형)**.
| comp | 라이브 | 원본 헤더 근거 | 판정 |
|------|--------|----------------|------|
| COMP_CUT_FULL_DIECUT(완칼) | .01 | A39 "1장당 2000원" = 장당가 | .01 정당 ✅ |
| COMP_CUT_PERF_1H6(타공단가) | .01 | "타공(단가)"·전부 0원 | .01 정당 ✅ |
| COMP_CUT_FULL_PERF_1H6(타공합가1구) | **.01** | **헤더 F42 "타공(합가)" + 셀=수량구간 총액** | 🔴 **.02 합가형이 맞음** |
| COMP_CUT_FULL_PERF_2H6(타공합가2구) | **.01** | 동일 | 🔴 **.02 합가형이 맞음** |

원본 직접 확인: G44=2000(1구 100매=2000 총액), G46=4000(300매), G48=11000(1000매) — 장당이 아니라 **수량구간 총액**. 합가형이 맞음. import.xlsx `3_price_components_FIX`가 라이브 .01 / 제안 .02를 2열로 분리·컨펌-A 플래그 = 추정 0·정직. **빌더 주장(헤더 "합가"+총액→.02 맞음, 라이브 .01 오등록) 정확.**

## P5 — 동시매칭0 + 차원 ✅ PASS (stale-C 빌더 주장 정확)

- 완칼 siz_cd 라이브 실측 = **SIZ_000499 단독**("316x467"=국4절). min_qty 유일 → 중복 0.
- 타공단가/합가: comp 분리(1구/2구=별 comp PERF_1H6/2H6), opt_cd/proc_cd NULL, min_qty 유일 → 중복 0. NULL행+전용행 공존 없음.
- **stale-C 직접 실측:**
  - 라이브 B3 min_qty = `1/100/200/300/400/500/600/700/800`
  - 원본 시트(260527) F44:F52 = `1/100/300/500/1000/2000/3000/4000/5000`
  - unit_price 시퀀스는 동일(2000/2000/4000/6000/11000/21000/31000/41000/51000) → **수량 매칭 지점만 다른 버전**. 시트 권위 → 라이브 stale. import 그릇은 시트값(300/500/1000…)으로 작성됨 = 정당.

## P6 — 가격사슬 ✅ PASS (단절 정직 보고·빌더 주장 정확)

라이브 `t_prc_formula_components` 배선 실측:
| comp | 배선(실측) | 가격사슬 |
|------|-----------|----------|
| COMP_CUT_FULL_DIECUT | PRF_DGP_B seq4, PRF_DGP_F seq4 | **완결** ✅ |
| COMP_CUT_PERF_1H6 | PRF_DGP_C seq5, D seq6, E seq10 | **완결** ✅(0원) |
| COMP_CUT_FULL_PERF_1H6 | **(0건)** | 🔴 **단절** |
| COMP_CUT_FULL_PERF_2H6 | **(0건)** | 🔴 **단절** |

타공합가 18행 적재됐으나 어느 공식에도 배선 0 → 엔진 조회 불가. **빌더 주장(가격사슬 단절·아크릴 시트 동형) 정확.** import 그릇이 `2_formula_components_FIX`에 단절 플래그·컨펌-B(헤더택/벽걸이캘린더 배선) = 정직.

---

## 빌더 주장 대조표 (적발 항목 = 4 / 뒤집힘 0 / 보정 0)

| 빌더 주장 | 검증자 실측 | 판정 |
|-----------|-------------|------|
| 무손실 77셀(완칼36+타공0원23+합가1구9+2구9) | 원본 전수 36+23+9+9=77, 라이브 77 | **확정** ✅ |
| 타공합가 prc_typ_cd = .02 합가형이 맞음(라이브 .01 오등록) | 라이브 4 comp 전부 .01·원본 G열=수량구간 총액 | **확정** ✅ |
| 가격사슬 단절(타공합가 2 comp 배선 0) | formula_components 배선 실측: 2 comp = 0건 | **확정** ✅ |
| min_qty stale(시트 300/500/1000 vs 라이브 200/300/400) | 양측 직접 실측 일치 | **확정** ✅ |

→ 빌더의 다른 점 4건 모두 **사실로 입증**. 빌더가 적발한 결함은 모두 실재.

---

## 검증자 추가 발견 (독립성 R6 충족)

**V-1 (MINOR·블로커 아님): 완칼 siz_cd=SIZ_000499 차원은 가격에 무영향 — use_dims 과표기 가능성.**
- 라이브 완칼 36행 전부 siz_cd=SIZ_000499 단독(다른 siz 없음). unit_price = min_qty × 2000(검산 일치).
- 즉 siz_cd가 **단일값 고정**이라 가격 분기에 실제로 기여하지 않음. use_dims=`["siz_cd","min_qty"]`이지만 siz_cd는 매칭 변별력 0(상수).
- **영향:** 가격 계산 결과는 동일(siz_cd 매칭이 항상 SIZ_000499 1행으로 좁혀짐). 결함은 아니나, "완칼은 출력판형 단위 단가"라는 의미 표기 목적이라면 정당하고, 순수 가격 차원으로만 보면 min_qty 단독으로 충분. **import 그릇은 라이브 use_dims를 그대로 보존했으므로 정합** — 교정 불요. 다만 향후 다른 출력판형(3절 등) 완칼이 추가되면 siz_cd가 실변별 차원이 되므로 현 표기 유지가 안전. → 정보성 발견, 교정 제안 아님.

**V-2 확인(빌더 정직성): import `4_component_prices_FIX`의 타공합가 행이 시트 min_qty(300/500/1000…)로 작성**되어 라이브 stale을 그릇에 답습하지 않음. apply_ymd=2026-06-01 일괄. = 시트 권위 준수 정당.

---

## 미해소 컨펌 (인간 승인 — 검증자 의견)

| ID | 항목 | 검증자 의견 |
|----|------|-------------|
| 컨펌-A | 타공합가 prc_typ_cd .01→.02 교정 | **교정 권장**. 현재 배선 0이라 과청구 미발생이나, 컨펌-B로 배선 시 .01이면 1000배 과청구. 배선과 교정은 함께 처리해야 안전 |
| 컨펌-B | 타공합가 comp 헤더택/벽걸이캘린더 배선 | D42 라벨 근거는 있으나 어느 상품(prd_cd)인지 엑셀 명시 부재 → 상품 확정 후 배선. 추정 금지 |
| stale-C | 라이브 B3 min_qty 교정(200/300/400→300/500/1000) | 시트 권위·라이브 stale 확정. 멱등 UPSERT 시 PK(comp_cd,apply_ymd,…,min_qty)가 min_qty 포함이라 **구간경계 변경=신규행 INSERT+구행 잔존** 위험 — 교정 시 구 min_qty 행 삭제 동반 필요(round-5 트랙) |

DB 미적재 — 교정/배선/적재 전부 인간 승인. 검증자는 읽기전용 SELECT만 수행, COMMIT/DDL 0.
