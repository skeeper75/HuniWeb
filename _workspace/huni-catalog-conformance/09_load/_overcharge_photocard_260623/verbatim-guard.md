# verbatim-guard.md — 포토카드 V3 교정 단가값 불변 증명

> §21 카탈로그 정합 · 2026-06-23 · ★[HARD] 단가값 verbatim 불변(unit_price SET 0건).

## 1. 교정의 본질 = 단가행 미접촉

V3 공식분리 교정은 **단가행(t_prc_component_prices)을 전혀 손대지 않는다.** 교정 = 공식 그릇 분리:
- 신규 공식 2개 INSERT (FRM)
- formula_components 배선 2건 INSERT (FC — 기존 comp 재사용)
- 상품-공식 바인딩 frm_cd 재배선 2건 UPDATE (BIND)
- 고아 공식 use_yn='N' 1건 UPDATE (FRM)

→ **t_prc_component_prices를 SET하는 구문 0개.** 단가 숫자(6,000·8,500)는 물리적으로 미접촉.

## 2. apply.sql 정적 보장

| 검증 | 결과 |
|------|------|
| `t_prc_component_prices` SET 구문 수 | **0** (apply.sql 전체에 단가행 UPDATE 없음) |
| comp use_dims 변경 | **0** (V3는 use_dims 미변경 — V1/V2와 다름) |
| 신규 단가행 INSERT | **0** (comp/단가행 전부 기존 재사용) |
| 내장 G-0/G-1 가드 | 적재 전후 SET/CLEAR_SET 행수·합 동일성 검증 → **PASSED** |

## 3. DRY-RUN 단가행 합 불변 실측 (라이브 트랜잭션 내)

| comp_cd | 행수 | 단가합 (교정 전=후) |
|---------|:--:|:--:|
| COMP_PHOTOCARD_SET | 1 | **6,000.00** (불변) |
| COMP_PHOTOCARD_CLEAR_SET | 1 | **8,500.00** (불변) |

- DRY-RUN NOTICE: `verbatim: SET 합=6000.00 · CLEAR_SET 합=8500.00` → 기대치 일치.
- apply.sql 내장 `VERBATIM GUARD PASSED` NOTICE 발화.

## 4. 결론

**verbatim 게이트 통과.** 가격이 14,500→6,000/8,500으로 바뀌는 것은 단가 변경이 아니라
**공식이 어느 comp를 보는지(그릇 분리)**가 바뀐 결과. 각 comp의 단가 숫자는 0변경.
