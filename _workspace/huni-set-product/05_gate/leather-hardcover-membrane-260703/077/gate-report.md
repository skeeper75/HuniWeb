# 077 레더 하드커버책자 — 면지 통합 재설계 · 독립 검증 게이트 (S1~S8)

> §23 Huni-Set-Product · hsp-set-gate · 2026-07-03 · **독립 재실측(생성자 주장 비신뢰)**
> 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN(BEGIN…ROLLBACK) + evaluate_set_price 실호출. **DB 미적재(게이트 COMMIT 안 함).**
> 대상: `03_design/leather-hardcover-membrane-redesign-260703/077/apply-077.sql`(8스텝) · 072 파일럿 동형 전파.

## 종합 판정: **GO** (S1~S8 전부 PASS · 단일 FAIL 0)

면지 3멤버(079/080/081)→1멤버(079) 통합 + 면지자재/옵션 부모 077→멤버 079 이관은 **가격 완전 무손상**으로 독립 확증. `evaluate_set_price` 실호출로 BASELINE(5멤버)=REDESIGN(3멤버)=SANITY(2멤버) 전 copies 동일(34,284 / 160,944 / 815,338) 확인. 077 특이점(USAGE.07 자재 없음)까지 라이브 실측으로 072와 완전 동형 확증. COMMIT 승인 준비 완료(인간 승인 후 load-executor).

---

## 게이트별 판정 (직접 재실측 근거)

| 게이트 | 판정 | 재실측 증거 |
|---|---|---|
| S1 권위 충실성 | **PASS** | 077 셋트 구성 = 표지078 + 내지285 + 면지(079) — 상품마스터 셋트 정합. 재설계 **날조 0·신규 mint 0**(전 코드 라이브 기존 참조 실측: 079·MAT_382/383/384·OPT_065·OPV_437/438/439·PRF_HC_MUSEON_SET). "면지 3멤버"는 권위 강제가 아닌 라이브 이중표현 아티팩트(빈 껍데기 080/081) → 1멤버 통합은 권위 셋트 구성(면지 1)에 수렴. |
| S2 구성원 반제품 유형 | **PASS** | 라이브 실측: 077=`PRD_TYPE.01`(셋트 완제품). 078/285/079/080/081 전부 `PRD_TYPE.02`(반제품). semi_role: 078=`SEMI_ROLE.02`(표지)·285(내지·NULL)·079/080/081=`SEMI_ROLE.03`(면지). 완제품/반제품 혼입 0. 079 유지 멤버=반제품·면지. |
| S3 복합PK/FK 무결성 | **PASS** | 077 sets 복합PK 중복 0. 5멤버 전부 `t_prd_products` 실재(FK 고아 0). 079/080/081 삼각 실측=mat/siz/prt/plt 0. **080/081 전역 역참조 스윕**: 오직 077 sub_prd_cd로만 참조(각 1행)·타 셋트 부모 0·option_items ref_key1/2 0·constraint logic 0(077 제약 0행) → 은퇴 안전. sub_prd_qty=1·078 base∈[1,1]·incr 없음(면지 qty1). |
| S4 ★가격 e2e [HARD] | **PASS** | 아래 §S4. `evaluate_set_price` 실호출 BASELINE=REDESIGN=SANITY 전 copies 완전 동일. set_contrib=COVERBIND min_qty 티어(34,100/159,100/796,900) 라이브 재구성 일치. PRICE≠0·이중합산 0·면지 079/080/081 기여 각 0(공식 0행+직접단가 0행 둘 다 실측). |
| S5 ★오차단 0 | **PASS** | 색 택1(화/블/그)=079 멤버 자재 드롭다운으로 발현(MAT_382 dflt·383·384 이관·트리거 통과). 선택지 손실 0. 옵션그룹 OPT_065도 079 이관(시뮬 휴면이나 무해). 빈멤버 3장→1멤버 UX 개선. |
| S6 흡수(최소) | **PASS** | 구조 정리·경쟁사/도메인 유입 0·naming/codes 재사용만(신규 mint 0). |
| S7 적재 가능성 DRY-RUN | **PASS** | 아래 §S6. BEGIN…ROLLBACK 롤백전용 2회 실행: 제약위반 0·트리거 `fn_chk_opt_item_ref` 통과·2회 apply 상태 delta 0(멱등)·ROLLBACK 후 완전 원상복귀(079 mat=0·sets=5·080/081 use_yn=2). |
| S8 구성요소 경계 무오염 [HARD] | **PASS** | 아래 §S8. MAT_382/383/384 = `t_prc_component_prices` 참조 **0행**(순수 descriptor). 셋트공식 PRF_HC_MUSEON_SET → COMP_HC_MUSEON_COVERBIND use_dims=`["min_qty"]`(mat_cd 없음)·apply가 t_prc_* 미변경. 공유공식 silent 적용/누락 0. 079 자기 면지자재만·077 USAGE.07 없음(끌어올 것 0). |
| S8(독립성) 생성≠검증 | **PASS** | 전 수치를 라이브 psql 원자 + evaluate_set_price 실호출로 직접 재구성(설계 시뮬 수치 비신뢰). 072 codex reconcile DISAGREE 0의 per-set 전파 요건 4항을 077에 대해 독립 재실측으로 전부 CLOSE(면지멤버 0·역참조 스윕·USAGE.07 n/a·088 무충돌). |

---

## §S4 가격 e2e 종단 재현 (독립 · 돈크리티컬)

**엔진 계약**(pricing.py): `evaluate_set_price = Σ 구성원 evaluate_price(base) + 셋트공식 evaluate_price(base) + 할인`. 구성원 base = ① 직접단가(t_prd_product_prices) ② 공식(t_prd_product_price_formulas) 순 — 둘 다 없으면 base=0.

### 구성원 기여 (라이브 실측 · evaluate_set_price 실호출)
| 멤버 | 공식행 | 직접단가행 | 기여(copies 1/10/100) |
|---|---|---|---|
| 078 표지 | 0 | 0 | **0 / 0 / 0** (자재 보유하나 무공식·무직접단가 → base=0) |
| 285 내지 | PRF_DGP_INNER | 0 | 184.38 / 1,843.80 / 18,438.00 (page-derived·재설계 미변경) |
| 079/080/081 면지 | 0/0/0 | 0/0/0 | **0 / 0 / 0** (공식+직접단가 둘 다 부재) |

### 셋트공식 단독 = 골든 (COVERBIND min_qty 티어 · 라이브 원자)
| copies | 티어 min_qty | 단가/권 | ×copies = set_contrib | final(=set_contrib+내지) |
|---|---|---|---|---|
| 1 | 1 | 34,100.00 | 34,100 | **34,284** |
| 10 | 10 | 15,910.00 | 159,100 | **160,944** |
| 100 | 100 | 7,969.00 | 796,900 | **815,338** |

### 무손상 삼각확인 (evaluate_set_price 실호출 결과)
| copies | BASELINE(면지3) | REDESIGN(면지1=079) | SANITY(면지0) | 판정 |
|---|---|---|---|---|
| 1 | 34,284 | **34,284** | 34,284 | 불변 ✓ |
| 10 | 160,944 | **160,944** | 160,944 | 불변 ✓ |
| 100 | 815,338 | **815,338** | 815,338 | 불변 ✓ |

- **재설계 무손상**: (a) 079/080/081 전부 공식0+직접단가0 → 통합/은퇴가 합산에 무영향. (b) MAT_382/383/384=component_prices 0행 → 부모→멤버 이관/부모 은퇴가 어떤 공식 매칭에도 무영향. (c) COVERBIND use_dims=`["min_qty"]`(mat_cd 없음) → 부모 면지자재 은퇴 가격중립. → **가격은 셋트공식이 단독 결정하며 재설계가 건드리는 요소(면지 멤버·자재·옵션)는 전부 가격 미배선.**
- **이중합산 0**: 면지비 어디에도 이중 계상 없음(면지=제본비 포함 도메인·멤버 기여 0). **PRICE≠0**(전 케이스). 허용오차 0.
- ※ 스펙 806,119(set_full_scan 하네스·set_procs 포함 조건)과 본 815,338(qty100·24p derived)는 시뮬 파라미터 차이(조건 상이)이지 결함 아님 — 무손상 자=동일 조건 내 BASELINE=REDESIGN=SANITY 동일성(전 조건 성립). 이전 077 동작화 COMMIT(PRF_HC_MUSEON_SET 바인딩·내지 285·COVERBIND)은 미변경·보존.

---

## §S6 적재 가능성 DRY-RUN (롤백전용 실측 · 2026-07-03)

`BEGIN; \i apply-077.sql; (검증); \i apply-077.sql; (멱등); ROLLBACK;` 실행 결과:

**1차 apply — 예상 카운트·트리거 통과:**
- [1] 079 리네이밍 UPDATE 1 · [2] 079 면지자재 INSERT 3 (MAT_382/383/384 USAGE.03) — 옵션아이템 [5] 선행조건 충족
- [3~5] 079 옵션그룹1 + 옵션3 + 옵션아이템3 INSERT — **`fn_chk_opt_item_ref` OPT_REF_DIM.03(prd_cd+mat_cd+usage_cd 실재) 통과**(자재 [2] 선삽입)
- [6] 부모 077 OPT_065 은퇴: 아이템3 + 옵션3 + 그룹1 UPDATE · [7] 부모 077 USAGE.03 자재 은퇴 UPDATE 3 · [8] 080/081 셋트링크 UPDATE 2 + [8b] use_yn=N UPDATE 2

**적재 후 상태(실측):** 079_mat=3·079_optgrp=1·079_opt=3·079_optitem=3 / 077_USAGE.03_active=0·077_OPT065_active=0·077_sets_active=**3**(078/285/079) / 080_081_useY=0.

**2차 apply(멱등):** 리네이밍 UPDATE 0·INSERT는 ON CONFLICT DO UPDATE(신규행 0)·은퇴 UPDATE 0 → **상태 delta 0**(079_mat=3·077_sets_active=3 불변). **ROLLBACK 후** 079_mat=0·077_sets_active=5·080_081_useY=2(원상복귀·비영속).

→ 제약위반 0·트리거 위반 0·멱등·롤백 안전. **S7 PASS.**

---

## §S8 구성요소 경계 무오염 (독립 실측)

1. **경계 안**: 079엔 자기 면지자재(USAGE.03 MAT_382/383/384)만 이관. 077 부모엔 표지/바인딩 자재(USAGE.07) **없음**(라이브 실측 — 077 materials 전부 USAGE.03) → 끌어올 것 0. 경계 밖 유입 0.
2. **공유공식 오염/누락**: 셋트공식 PRF_HC_MUSEON_SET은 072·077 공유·COMP_HC_MUSEON_COVERBIND는 PRF_LEATHER_RINGBINDER_SET에도 사용되나 **use_dims=`["min_qty"]` 자재 미종속** + apply-077.sql이 t_prc_* 테이블 **일절 미변경**(t_prd_product_* 만 조작) → 다른 상품 견적에 silent 적용/누락 0. B-4 패턴(제본 comp 오청구/누락) 해당 없음(min_qty만 매칭 → 분기 skip 불가·전 copies set_contrib 발현 확인).
3. **자재 가격배선**: MAT_382/383/384는 `t_prc_component_prices` 참조 0행 → 부모 은퇴/멤버 이관이 가격 매칭에 무영향(순수 descriptor).

→ 오염 유입 0·silent 적용/누락 0. **S8 PASS.**

---

## codex reconcile 수렴 (독립성)
- 077 전용 codex 파일 없음(072 reconcile C-5가 077/082/088 per-set 전파를 계획). 072 codex DISAGREE 0. per-set 전파 요건 4항을 077에 대해 **본 게이트가 독립 재실측**: ① 079/080/081 직접단가+공식 0 ✓ ② 080/081 전역 역참조 스윕 0 ✓ ③ USAGE.07 불가침 — **077 해당 없음(자재 0)** ✓ ④ 088 표지 재설계와 무충돌(077은 088 미참조) ✓ → 미해결 0.

## 적재 GO 큐
- **077 면지 통합** → load-executor COMMIT 승인 대기(apply-077.sql 8스텝·undo-077.sql 보유·`handoff-spec.md` 참조).
- 내지 285 개수필드 정정(선택 주석 블록)은 **파일럿 미포함**(가격중립이나 §23-inner와 묶어야 코히런트) — 활성화 금지 유지.
</content>
</invoke>
