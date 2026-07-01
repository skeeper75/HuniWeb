# 공정 커버리지 스캔 결과 — silent-0 전수 (2026-07-01·§27 F층 최초)

> 도구: `contribution_scan.py`(결정론·스냅샷만·토큰0). 측도=배선 서브트랙 F층(런타임 기여).
> wiring_scan(정적)·dim_conformance(차원)가 못 본 "상품 공정을 어느 비목도 가격 안 매기는"
> silent-0(과소청구)를 전수 적발. [HARD] 후보 적발까지(확정·교정은 §18/§7 인간 승인).

## 결과 요약 (snap 20260701, 바인딩 122상품)

| 결함 | 건수 | 의미 |
|------|-----|------|
| **UNCOVERED-HIGH(확정 이원화)** | 16 | 상품이 바인딩한 공정을 어느 비목도 proc로 가격 안 매김 + 같은 작업의 유령(고아) proc-단가행 존재 = 코드 이원화 |
| **MISMATCH-HIGH(base-proc)** | 10 | 디지털인쇄비(COMP_PRINT_DIGITAL_S1) 단가행 proc=PROC_000004를 상품이 미바인딩 → 인쇄비 0 |
| ORPHAN_PROC_VALUE | 12 | 유령 proc-단가행(어떤 상품도 그 proc 미바인딩) |
| UNCOVERED-REVIEW | 159 | 후보 — 박/라미/UV/모서리 등(면적·옵션 차원으로 가격되는 공정·proc-coverage 무관 가능) |
| **HIGH 영향 상품** | **22** | |

## 1. 확정 silent-0 — 공정 proc 코드 이원화 (근본원인)

상품은 손님에게 공정을 **실 proc 코드**로 제공하는데, 가격 단가행은 **다른(유령) proc 코드**로 적재됨 → 손님이 그 공정 선택 시 매칭 실패 → **무료(과소청구)**. 캘린더 트윈링제본과 동일 근본원인이 후가공 전반에 systemic.

| 작업 | 상품 바인딩 proc | 가격 단가행 proc(고아) | 영향 |
|------|------------------|------------------------|------|
| 오시 | PROC_000029 | PROC_000090 (COMP_PP_CREASE_1L) | 4 |
| 미싱 | PROC_000030 | PROC_000086 (COMP_PP_PERF_1L) | 4 |
| 타공 | (제품 proc) | PROC_000092 (COMP_CUT_PERF_1H6) | 2 |
| 제본(트윈링·하드커버무선·중철·떡) | 021 등 | 캘린더제본 099~102·싸바리 098 등 | 6 |

→ 오시·미싱은 엔진 스모크(simulate)로도 ABSENT 확증. 제본은 캘린더 검증(트윈링 099≠021)과 동형.

## 2. 확정 silent-0 — base 인쇄공정 미바인딩 (10상품)

`COMP_PRINT_DIGITAL_S1`(디지털인쇄비) 단가행 424행 전부 proc_cd=PROC_000004인데, PRD_000020·051·책자 member 285~292 등이 product_processes에 PROC_000004 미바인딩 → 인쇄비 silent 0. [[digital-print-base-proc-missing-260701]] 동형(일부 미해소분 + 책자 member 신규 발견).

## 3. 후보(REVIEW) — proc 아닌 차원으로 가격되는 공정 (오탐 가드)

박(동/적/청박)·라미네이팅·UV·모서리(직각/둥근)·홀로그램은 UNCOVERED로 떴으나 **면적(siz_width)·옵션(opt_cd) 차원 비목으로 가격**된다(예: 박=COMP_FOIL_PROC_SMALL siz_width·COMP_NAMECARD_FOIL opt_cd). 상품이 박 proc를 바인딩하는 건 "선택" 신호이고 가격은 면적/옵션 → proc-coverage로 보면 FP. REVIEW로 분리. (단 멀티공식 상품에서 FOIL 공식 미바인딩 시 진짜 누락 가능 → 표본 확인 대상.)

## 4. 메타 교정 (파이프라인 보강)

1. **§18/§13 골든 재계산은 상품 실제 product_processes로 selection 구성** — 손으로 proc 고르기 금지(매칭 불일치가 골든에서 드러나도록). 이것이 캘린더·오시·미싱을 통과시킨 근본 구멍.
2. **§27 배선 종료척도에 F층 추가** — wiring_scan(정적) GO + contribution_scan(런타임 커버리지) HIGH 0 까지.
3. dim_conformance 보완: proc_cd 이원화는 REVIEW 노이즈에 묻혀 있었음 — 본 F층이 orphan 상관으로 확정.

## 5. 다음 (교정·인간 승인)

- 확정 16(이원화)+10(base-proc) → §18 설계 정정(올바른 proc로 배선 or proc 통일) → §7 적재.
- REVIEW 159 → 표본 engine-confirm(특히 멀티공식 FOIL 미바인딩) 후 분류.
- 산출: `wiring/contribution-defects.csv`·`contribution-summary.json`·`contribution-rounds.csv`(수렴 추적).
