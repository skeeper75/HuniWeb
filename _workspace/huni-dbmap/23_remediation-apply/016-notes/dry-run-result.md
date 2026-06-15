# 016 note 교정 — 라이브 롤백전용 DRY-RUN 실증 결과

> 실행 2026-06-15 · 라이브 `railway` DB · `BEGIN … <apply> … ROLLBACK` (lead 승인).
> **COMMIT 0 — 아무것도 라이브에 반영되지 않음.** 비밀번호 미출력. note 컬럼만 검증.

## 1. 단일 트랜잭션 2-pass 결과

| 항목 | 결과 | 판정 |
|------|------|:--:|
| PASS1 변경 행수 — 단가행(`t_prc_component_prices`) | 1,403 (regexp 1,354 + 용지비 suffix 49) | ✅ |
| PASS1 변경 행수 — 정의행(`t_prc_price_components`) | 29 | ✅ |
| **합계** | **1,432행** | |
| PASS2 delta (재실행 변경분) — 단가행 | **0** | ✅ 멱등 |
| PASS2 delta — 정의행 | **0** | ✅ 멱등 |
| ROLLBACK 후 라이브 | 무변경 (siz-corrected 마커 1,138행 그대로) | ✅ |

PASS2에서 모든 UPDATE 문이 `UPDATE 0` (정의행 29건 + 단가행 2블록 전부) — `IS DISTINCT FROM` 가드와
no-op regexp로 재실행 delta 0 실증.

## 2. 가격행 불변 보증 (note 컬럼만 변경)

| 검사 | 결과 | 판정 |
|------|------|:--:|
| 단가행 비-note 컬럼 변경 수 (unit_price·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·apply_ymd·proc_cd·opt_cd) | **0** | ✅ |
| 정의행 비-note 컬럼 변경 수 (prc_typ_cd·comp_typ_cd·comp_nm) | **0** | ✅ |
| `sum(unit_price)` 정정 전 | 18,509,572.51 | |
| `sum(unit_price)` 정정 후 | 18,509,572.51 | ✅ 동일 |

→ `prc_typ_cd`·`unit_price`·단가행 어떤 값도 변하지 않음. SET 절은 `note`·`upd_dt` 둘뿐임을 라이브가 실증.

## 3. 전문용어 잔존 0 (전수)

PASS1 후 PRF_DGP_A 사슬 전 note에서:

| 마커 | 단가행 잔존 | 정의행 잔존 |
|------|:--:|:--:|
| `[siz-corrected: ...]` | 0 | 0 |
| `comp_typ` / `comp_typ_cd=` | 0 | 0 |
| `clr=NULL` | 0 | — |
| `별색=공정` | 0 | — |
| `옵션=comp흡수` | 0 | — |
| `(합가 ...)` | 0 | — |
| `round-2 파일럿` | 0 | 0 |
| `mat_cd` / `C-4` / `SIZ_` 식별자 | 0 | 0 |
| `≥` 기호 (축 미한국어화 잔존) | 0 | — |

→ note-map.csv의 `corrected_note` 컬럼도 동일하게 전문용어 0 (python 재검증).

## 4. 교정 예시 (현재 → 교정, 라이브 인용)

| comp_cd | 현재 (라이브) | 교정 |
|---------|--------------|------|
| 정의 COMP_PRINT_DIGITAL_S1 | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01` | `디지털 인쇄비(단면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.` |
| 단가 COMP_PRINT_DIGITAL_S1 | `[siz-corrected: SIZ_PENDING_GUK4→SIZ_000499] 디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수≥1` | `디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1장 이상` |
| 단가 COMP_PP_CREASE_1L | `오시/1줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)` | `오시/1줄 주문수량 1건 이상 / 작업 1건 고정 금액` |
| 단가 COMP_PAPER | `용지비 백색모조지 100g 국4절(316x467) 절가` | `용지비 백색모조지 100g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산` |
| 정의 COMP_PAPER | `신규: 디지털인쇄 용지비. 차원=mat_cd(종이)×siz_cd(출력용지규격)...앱 런타임(C-4)` | `용지비. 선택한 종이·출력규격(국4절/3절)별 절가. 실제 청구는 출력매수만큼 시스템이 자동 계산.` |

## 5. 종합

| 게이트 | 판정 |
|--------|:--:|
| 멱등성 (2-pass delta 0) | ✅ PASS |
| 실행성 (apply.sql/loader 무오류 실행) | ✅ PASS |
| 라이브 DRY-RUN 제약 위반 | ✅ 0 |
| note 컬럼만 변경 (가격행 불변) | ✅ PASS |
| 전문용어 잔존 0 (전수) | ✅ PASS |
| ROLLBACK 후 라이브 무변경 | ✅ PASS |

**빌드 + DRY-RUN 완료.** 실제 COMMIT은 `dbm-validator` 독립 게이트 GO + 인간 승인 후
`./apply_loader.sh commit`. (이 에이전트는 자기승인하지 않음.)
