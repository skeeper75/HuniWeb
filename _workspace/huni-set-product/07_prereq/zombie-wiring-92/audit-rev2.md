# 좀비 배선 83건 전체 재검토 (W1-2 rev2) — audit-rev2

생성: §23 huni-set-product 07_prereq/zombie-wiring-92 · 라이브 Railway DB **읽기전용 SELECT 실측**(2026-06-25) · **DB 미적재**(분석·명세까지) · 실 COMMIT/UPDATE/DELETE는 인간 승인 후 dbm-load-execution
권위: del_yn 논리삭제 권위([[dbmap-del-yn-soft-delete-authority]]) + 옵션 참조 무결성(option_items.ref_dim_cd=OPT_REF_DIM.03→mat_cd) + 가격사슬(component_prices) + webadmin MAT_TYPE/USAGE 코드
원칙[HARD]: search-before-mint·비파괴·추측 금지(모호=BLOCKED 유지)·돈영향 표기

> **결론 한 줄**: 1차 4건 COMMIT 후 좀비=**83건**(쿼리 일치 확인). 회의적 재검토 결과 **1차 BLOCKED 83건 전부를 재결정** → **REVIVE 9 / OPTIONIZE 67 / BLOCKED-CONFIRM 7**. ★핵심 적발: 8개 좀비(현수막 추가물 5 + 투명커버 2 + 유포지 1)는 **option_items가 활성으로 ref 참조하는데 자재만 삭제된 "옵션 참조 무결성 깨짐"** = BLOCKED가 아니라 REVIVE 대상. 돈영향 여전히 0(83건 전부 component_prices 단가행 0 재확인).

---

## 1. 1차 대비 변경 요약

| rev1 처분 | 건수 | → rev2 | 건수 | 전환 근거 |
|---|---|---|---|---|
| BLOCKED-CONFIRM | 83 | REVIVE | **9** | option_items 활성 ref 참조(무결성 깨짐) 8 + 거울본체 정본부재 1 |
| | | OPTIONIZE | **67** | 색/사이즈/형상 라벨·opt ref 없음(옵션화 미완) — BLOCKED를 실행 방향으로 구체화 |
| | | BLOCKED-CONFIRM | **7** | 여전히 모호(두께 미특정·포토북 옵션화 선행·추가상품 트랙) |

**변경 건수: 76/83** (BLOCKED 유지 7건만 불변). REVIVE/OPTIONIZE 어느 것도 1차 REWIRE 후보로 격상된 것은 없음(아래 §3.4 참조 — REWIRE 후보였던 유포지는 옵션 ref가 154를 직접 가리켜 REVIVE가 맞음).

---

## 2. 재실측 (4건 COMMIT 검증)

- 좀비 자재 수 = **83** (검증 쿼리 결과). 1차의 레더008·아트260·무지내지261·워터북270 모두 좀비 정의에서 이탈(REVIVE/REWIRE COMMIT 정합).
- **돈영향 재검증**: 83건 중 component_prices 단가행 보유 = **0건**. ① 직접 `cp.mat_cd` 0 ② `cp.dim_vals` JSONB에 좀비 mat_cd 0 ③ 간접 차원 0. → 어떤 처분도 evaluate_price 청구 불변(0원).

---

## 3. 케이스별 재결정 근거

### 3.1 ★REVIVE 전환 8건 — option_items 활성 ref 참조 (무결성 깨짐 적발)
```sql
SELECT oi.ref_key1, m.mat_nm, m.mat_typ_cd, count(*)
 FROM t_prd_product_option_items oi
 JOIN t_mat_materials m ON m.mat_cd=oi.ref_key1 AND m.del_yn='Y'
 WHERE oi.ref_dim_cd='OPT_REF_DIM.03' GROUP BY 1,2,3;
```
결과 8건: MAT_000244·245(투명커버 마감)·069(양면테입)·070(끈)·337(큐방)·338(각목)·340(봉제사)·154(유포지).

이들은 **이미 옵션화가 완료된 자재**인데 자재만 del_yn=Y로 삭제됨 → 살아있는 옵션 항목(option_items)이 죽은 자재를 가리키는 **참조 무결성 위반**(fn_chk_opt_item_ref 취지 위반). 1차에서 "옵션화 의존 BLOCKED" 또는 "옵션화 대상"으로 미뤘으나, **옵션화는 이미 됐고 자재 부활만 누락**된 것 → 정답은 **REVIVE**(자재 del_yn Y→N). OPTIONIZE(중복)도 DELINK(옵션이 가리키므로 불가)도 아님.
- 현수막 추가물 5건: 가격은 별도 component(COMP_POPT_BNR_GAKMOK_STR_900_4_*·COMP_POSTEROPT_..._ADD_QBANG_4 등, 각 단가행 실재)로 작동 — 자재 단가행 0과 무관. REVIVE는 옵션 ref 무결성만 복구(돈 불변).
- 투명커버 244·245: 트윈링책자 마감 옵션이 이미 자재 ref 보유.

### 3.2 REVIVE 추가 1건 — 거울 본체 정본 부재 (Z-5 해소)
- **MAT_000262 무광 75mm**: 틴거울/컴팩트거울 본체 사입자재(dflt_yn=Y). 활성 정본 동일명 부재(틴케이스 293/341은 별물). opt ref는 없으나 본질 유효 소재·정본 없음 → REVIVE.

### 3.3 OPTIONIZE 67건 — 색/사이즈/형상 라벨 (옵션화 미완)
- **.09 봉제부자재 62건 + .08 실사색 5건**. 전수 `option_items` ref **0건**(미옵션화) 확인. M/L/XL·세로/가로·원형90mm·검정/빨강·양면/단면·2구/3구 등 = 자재가 아니라 옵션값. 활성 정본은 색 아닌 실소재 → 자재 REVIVE는 오염 재생산. 정답 = **W2 옵션화**(option_items 신설 → product_materials 배선 논리삭제). 1차 BLOCKED를 실행 방향(OPTIONIZE)으로 구체화.

### 3.4 BLOCKED-CONFIRM 유지 7건 — 여전히 모호
| mat_cd | 모호 사유 |
|---|---|
| MAT_000192 투명아크릴 | 정본 후보 042/043(아크릴투명 1.5/3mm)이 단가행 52/113행 보유 → REWIRE 시 두께 미특정으로 정본 단일 특정 불가 + 정본은 가격 도달이라 **돈변동 위험**. 두 상품(169/171) 공식 미바인딩(현 미도달). 두께 확인 필요 |
| MAT_000005/007/006/251 | 포토북 표지타입/면지 = USAGE.06 옵션 의미인데 포토북 옵션그룹 0개(옵션화 전혀 안 됨)·opt ref 없음 → OPTIONIZE 선행이 필요하나 옵션 설계가 동반돼야 완결 → 셋트 옵션 설계 트랙 의존 |
| MAT_000214/223 | 추가상품(.10) 묶음/거치대. opt ref 없음·정본 규격 미특정 → 추가상품 옵션 설계 트랙 의존 |

### 3.5 Z-4 / Z-5 처리
- **Z-4(각목338·큐방337 RC-2 중복)**: 해소. RC-2는 각목/큐방을 **component(가격)+option_items(옵션)** 축에서 이미 재구성(GAKMOK_STR_900_4_GT/LE·ADD_QBANG_4 단가행 실재). 그러나 **자재(mat_cd) 축은 정리 안 됨**(자재 del_yn=Y인데 옵션이 참조) → 자재 REVIVE로 무결성 복구. RC-2와 충돌 아님(별 축).
- **Z-5**: 부분 해소. 유포지154=REVIVE(opt ref 직접)·무광75mm262=REVIVE(정본부재 본질소재). 투명아크릴192=BLOCKED 유지(두께·돈변동 위험).

---

## 4. 최종 분포

| 처분 | 건수 | 배선합 | 돈영향 | 실행 형태(인간 승인 후) |
|---|---|---|---|---|
| REVIVE | 9 | 11 | 0원 | `UPDATE t_mat_materials SET del_yn='N',del_dt=NULL WHERE mat_cd=...`(멱등 가드) |
| OPTIONIZE | 67 | 119 | 0원 | W2 트랙: option_items 신설 → product_materials 배선 논리삭제 |
| BLOCKED-CONFIRM | 7 | 9 | 0원(192 REWIRE시 변동위험) | 확인 후 결정 |
| **합계** | **83** | **139** | **0원** | |

---

## 5. 라우팅

- **REVIVE 9건** → 인간 승인 후 dbm-load-execution(멱등 UPDATE). 돈영향 0 → dbm-price-arbiter 심의 불요. 옵션 ref 무결성 복구가 1차 효과.
- **OPTIONIZE 67건** → W2 옵션화 트랙(t_prd_product_option_groups/options/option_items 설계 → 배선 논리삭제). 자재 교정 범위 밖.
- **BLOCKED 7건** → 192=두께 확인·포토북 4=옵션 설계 트랙·추가상품 2=추가상품 트랙.

---

## 6. 🔴 승인/확인 필요

| Q | 항목 | 질문 |
|---|---|---|
| ZR-1 | REVIVE 9 | 옵션 ref 무결성 깨진 8건(현수막추가물5·투명커버2·유포지1)+거울본체1 부활 승인? (돈영향 0·옵션이 가리키는 자재 복구) |
| ZR-2 | OPTIONIZE 67 | 색/사이즈/형상 라벨 67건을 W2 옵션화(자재 부활 금지)로 처리하는 방향 확정? |
| ZR-3 | MAT_000192 투명아크릴 | 정본 두께(1.5mm=042 vs 3mm=043) 어느 것? — REWIRE 시 정본 단가행 보유로 돈변동 발생(현재 미도달→실가). 실무진 확인 |
| ZR-4 | 포토북 표지타입 4 | 005/006/007/251을 USAGE.06 표지타입 옵션화 트랙으로 이관 확정? (포토북 옵션그룹 현재 0개) |
| ZR-5 | 유포지154 | REVIVE만으로는 자유형스티커 가격 미도달 지속(154 COMP_STK_PRINT 단가행 0). 정본 MAT_000153(유포스티커, 단가행504) REWIRE 검토 필요 여부 — 단 돈변동(0→실가) |
