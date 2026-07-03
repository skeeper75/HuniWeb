# 072 하드커버책자 면지 통합 재설계 — 독립 검증 게이트 (S1~S8)

> §23 Huni-Set-Product · hsp-set-gate · 2026-07-03 · **독립 재실측(생성자 주장 비신뢰)**
> 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN(BEGIN…ROLLBACK). **DB 미적재(게이트 COMMIT 안 함).**
> 대상: `03_design/leather-hardcover-membrane-redesign-260703/apply.sql`(8스텝) · 파일럿 072.

## 종합 판정: **GO** (S1~S8 전부 PASS · 단일 FAIL 0)

면지 3멤버(074/075/076)→1멤버(074) 통합 + 면지자재/옵션 부모→멤버 이관은 **가격 완전 무손상**으로 독립 확증. 골든 34,100/159,100/796,900을 라이브 원자 데이터로 재구성해 일치. COMMIT 승인 준비 완료(인간 승인 후 load-executor).

---

## 게이트별 판정 (직접 재실측 근거)

| 게이트 | 판정 | 재실측 증거 |
|---|---|---|
| S1 권위 충실성 | **PASS** | 072 셋트 구성 = 표지073 + 내지284 + 면지(074) — 상품마스터 셋트 정합. 재설계는 **날조 0·신규 mint 0**(전 코드 라이브 기존 참조). "면지 3멤버"는 권위가 강제한 것이 아니라 라이브 이중표현 아티팩트(빈 껍데기 075/076) → 1멤버 통합은 권위 셋트 구성(면지 1)에 수렴. |
| S2 구성원 반제품 유형 | **PASS** | 라이브 실측: 072=`PRD_TYPE.01`(셋트 완제품). 073/284/074/075/076 전부 `PRD_TYPE.02`(반제품). 역할=073 `SEMI_ROLE.02`(표지)·284 (내지, semi_role 없음)·074/075/076 `SEMI_ROLE.03`(면지). 완제품/반제품 혼입 0. |
| S3 복합PK/FK 무결성 | **PASS** | 072 sets 복합PK 중복 0. 5멤버 전부 `t_prd_products` 실재(FK 고아 0). **075/076 전역 역참조 스윕**: 오직 072 sub_prd_cd로만 참조(2행)·타 셋트 부모 0·option_items ref_key1 0·소유 자재행 0 → 은퇴 안전(고아·댕글링 0). sub_prd_qty=1·073 base∈[1,1]. |
| S4 ★가격 e2e [HARD] | **PASS** | 아래 §S4 상세. COVERBIND 티어 × copies = **34,100 / 159,100 / 796,900** 라이브 원자 재구성 일치. PRICE≠0·이중합산 0·면지 기여 0(공식 0행+직접단가 0행 둘 다 실측). |
| S5 ★오차단 0 | **PASS** | 색 택1(화/블/그) = 074 멤버 자재 드롭다운으로 발현(자재 3종 이관·dflt=화이트). 선택지 손실 0. 옵션그룹도 074 이관(휴면이나 무해). 이관 후 손님 택1 가능·오히려 빈멤버 3장→1멤버 UX 개선. |
| S6 경쟁사/도메인 흡수 | **PASS(최소)** | 해당 없음(구조 정리·경쟁사 유입 0·naming/codes 재사용만). |
| S7 적재 가능성 DRY-RUN | **PASS** | 아래 §S6 상세. BEGIN…ROLLBACK 롤백전용 실행: 제약위반 0·트리거 `fn_chk_opt_item_ref` 통과·2회 apply delta 0(멱등)·롤백 후 074 원상복귀. |
| S8 구성요소 경계 무오염 [HARD] | **PASS** | 면지자재 MAT_382/383/384는 `t_prc_component_prices` 참조 **0행**(순수 descriptor·가격 미배선). 셋트공식 PRF_HC_MUSEON_SET use_dims=`["min_qty"]`(mat_cd 없음)·재설계 미변경 → silent 적용/누락 0. 074 바인딩 공식 0. 오염 유입 0. |
| S8(독립성) 생성≠검증 | **PASS** | 전 수치를 라이브 psql 원자 데이터로 직접 재구성(설계 시뮬 수치 비신뢰). codex reconcile DISAGREE 0·UNCERTAIN 전부 라이브로 닫힘 확인. |

---

## §S4 가격 e2e 종단 재현 (독립 · 돈크리티컬)

**엔진 계약**(pricing.py 실측): `evaluate_set_price = Σ 구성원 evaluate_price(base.amount) + 셋트공식 evaluate_price(base.amount) + 할인`. 구성원 base_amount = ① 직접단가(TPrdProductPrices) ② 공식(TPrdProductPriceFormulas) 순 — **둘 다 없으면 `NONE`→base=0**(pricing.py:490-496). **자재는 base_amount에 직접 기여하지 않음**(공식 comp 경유만).

### 구성원 기여 = 0 (라이브 실측)
| 멤버 | 직접단가 행 | 공식 행 | 기여 |
|---|---|---|---|
| 073 표지 | 0 | 0 | **0** (자재 보유하나 무공식 → base=0 실증 오라클) |
| 284 내지 | — | PRF_DGP_INNER | **0** (semi_role.01 없음→실 시뮬 manual→0·재설계 미변경으로 전후 동일) |
| 074/075/076 면지 | **0 / 0 / 0** | **0 / 0 / 0** | **0** (공식+직접단가 둘 다 부재) |

### 셋트공식 단독 = 골든 (라이브 원자 재구성)
셋트공식 PRF_HC_MUSEON_SET → 단일 comp `COMP_HC_MUSEON_COVERBIND`(표지+제본 합산·권당), use_dims=`["min_qty"]`, PRICE_TYPE.01. **072에 결합된 할인테이블 0행**(무할인). COVERBIND min_qty 티어(라이브 `t_prc_component_prices`):

| copies | 적용 티어(min_qty≤copies) | 단가/권 | × copies | = final | 골든 |
|---|---|---|---|---|---|
| 1 | 1 | 34,100.00 | ×1 | **34,100** | 34,100 ✓ |
| 10 | 10 | 15,910.00 | ×10 | **159,100** | 159,100 ✓ |
| 100 | 100 | 7,969.00 | ×100 | **796,900** | 796,900 ✓ |

- **재설계 무손상 삼각확인**: (a) 면지 멤버 3종 전부 공식0+직접단가0 → 통합/은퇴가 합산에 무영향. (b) 면지자재 382/383/384 = component_prices 0행 → 부모→멤버 이관/부모 은퇴가 어떤 공식 매칭에도 무영향. (c) 셋트공식에 mat_cd 차원 없음 → 부모 면지자재 은퇴 가격중립. → **가격은 셋트공식(COVERBIND)이 단독 결정하며 재설계가 건드리는 요소(면지 멤버·면지 자재·면지 옵션)는 전부 가격 미배선.**
- **이중합산 0**: 면지비가 어디에도 이중 계상 안 됨(면지=제본비 포함 도메인·멤버 기여 0). PRICE≠0(전 케이스).

---

## §S6 적재 가능성 DRY-RUN (롤백전용 실측)

`BEGIN; \i apply.sql; (검증); \i apply.sql; (멱등 검증); ROLLBACK;` 실행 결과:

**1차 apply — 예상 카운트·트리거 통과:**
- [1] 074 리네이밍 UPDATE 1
- [2] 074 면지자재 INSERT 3 (MAT_382/383/384 USAGE.03) — **옵션아이템 [5] 선행조건 충족**
- [3~5] 074 옵션그룹1 + 옵션3 + 옵션아이템3 INSERT — **`fn_chk_opt_item_ref` OPT_REF_DIM.03(prd_cd+mat_cd+usage_cd 실재) 통과**(자재 [2] 선삽입 덕)
- [6] 부모 072 OPT_064 은퇴: 아이템3 + 옵션3 + 그룹1 UPDATE
- [7] 부모 072 면지자재 USAGE.03 은퇴 UPDATE 3
- [8] 075/076 셋트링크 은퇴 UPDATE 2 + [8b] use_yn=N UPDATE 2

**적재 후 상태(실측):** 074_mat=3·074_opt=3·074_optgrp=1·074_optitem=3 / 072_USAGE.03_active=0·072_OPT_064_active=0·072_sets_active=**3**(073/284/074) / 075_076_use_yn=Y count=0.

**2차 apply(멱등):** 리네이밍 UPDATE 0·INSERT는 ON CONFLICT DO UPDATE(신규행 0)·은퇴 UPDATE 0 → **상태 delta 0**(074_mat=3·072_sets_active=3 불변). **롤백 후** 074_mat=0(원상복귀·비영속).

→ 제약위반 0·트리거 위반 0·멱등·롤백 안전. **S7 PASS.**

---

## codex reconcile 수렴 (S8 독립성)
- codex DISAGREE 0. UNCERTAIN 2건(직접단가0·075/076 역참조)·완결성 갭 3건 → **본 게이트가 라이브로 독립 재확인 전부 CLOSED**.
- C-4(spec 문구 "공식없어 0"→"공식+직접단가 없어 0") = 정정 권고·**비차단**(결론 동일·본 게이트 §S4가 정밀 표현 채택).
- C-3(위젯/주문 경로 materials/opt 보존)·C-5(077/082/088 전파) = 후속 트랙·비차단.

## 적재 GO 큐
- **072 파일럿** → load-executor COMMIT 승인 대기(apply.sql 8스텝·undo.sql 보유).
- 내지 개수필드 정정(§5·선택 주석 블록)은 **파일럿 미포함**(가격중립이나 §23-inner와 묶어야 코히런트) — 활성화 금지 유지.
