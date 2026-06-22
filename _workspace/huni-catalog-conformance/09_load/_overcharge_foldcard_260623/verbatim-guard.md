# verbatim-guard.md — 단가값 불변 게이트 (돈 크리티컬)

> §21 접지카드 V2 교정 · 2026-06-23. **unit_price 변경 0**이 절대 조건.

---

## 1. 게이트 정의

교정은 **판별축(proc_cd) 충전 + use_dims 토큰 등재**만 한다. 단가값(unit_price)은 한 글자도 안 바꾼다.
"둘/넷 중 하나만 매칭"을 만들 뿐, 매칭된 단가 숫자 자체는 verbatim.

## 2. 기준선 (교정 전 라이브 실측)

| comp | 단가행 수 | unit_price 합 | min_qty=1 단가 |
|------|:---:|:---:|:---:|
| COMP_FOLD_LEAF_3FOLD | 48 | **31,965.00** | 6,000 |
| COMP_FOLD_LEAF_4ACC | 48 | **41,110.00** | 7,000 |
| COMP_FOLD_LEAF_4GATE | 48 | **41,110.00** | 7,000 |
| COMP_FOLD_LEAF_HALF | 48 | **24,421.00** | 5,000 |
| **계** | 192 | **138,606.00** | — |

## 3. 자동 가드 (apply.sql 내장)

- **G-0**: 적재 전 `_verbatim_before` TEMP에 comp별 (행수, 합) 캡처.
- **G-1**: 교정 후 동일 집계와 비교 → 행수 또는 합이 다르면 `RAISE EXCEPTION 'VERBATIM GUARD FAILED'`로
  트랜잭션 중단. DRY-RUN에서 **"VERBATIM GUARD PASSED"** 확인됨.
- 교정 SQL에 `SET unit_price` 구문 **0개** (정적 보장). proc_cd·use_dims만 SET.

## 4. DRY-RUN 검증 결과

| 항목 | 기대 | 실측 | 통과 |
|------|------|------|:---:|
| 3FOLD 단가행 합(교정 후) | 31,965.00 | 31,965.00 | ✅ |
| 4 comp 합 총계 | 138,606.00 | 138,606.00 | ✅ |
| unit_price SET 구문 수 | 0 | 0 | ✅ |
| G-1 가드 | PASS | PASS | ✅ |

→ **verbatim 게이트 통과.** 실 COMMIT 시에도 G-1이 트랜잭션 내에서 재검증(실패 시 자동 ROLLBACK).

## 5. 되돌리기 (가역성)

- proc_cd 충전 복원: `UPDATE t_prc_component_prices SET proc_cd=NULL WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%';`
- use_dims 복원: `UPDATE t_prc_price_components SET use_dims='["min_qty"]'::jsonb WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%';`
- 단가행 자체는 무변경이라 복원 불필요. **난이도 하**(가역).
- ※ §12 신규 등록 코드를 썼다면 그 코드 롤백은 §12 트랙 별도.
