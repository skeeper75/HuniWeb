# 077 면지 통합 재설계 — 적재 인계 명세 (COMMIT 승인 대기)

> §23 · 2026-07-03 · 게이트 **GO**(S1~S8 전부 PASS) → 인간 승인 후 load-executor COMMIT.
> **DB 미적재** — 본 게이트는 COMMIT 안 함. 라이브 읽기전용 + 롤백전용 DRY-RUN만 수행.

## 1. COMMIT 승인 준비 여부: **준비 완료 (GO)**

- 단일 FAIL 0. 오차단(S5) 0·가격 파손(S4) 0. 신규 mint 0.
- 가격 무손상 = `evaluate_set_price` 실호출 확증(BASELINE=REDESIGN=SANITY 전 copies 동일·허용오차 0).
- 적재본 멱등·트리거 통과·롤백 안전 = 롤백전용 DRY-RUN 실증.

## 2. 적재 대상 (apply-077.sql · 8스텝 · 전부 멱등)

| 스텝 | 조작 | 대상 t_* | 카운트(DRY-RUN 실측) |
|---|---|---|---|
| [1] | 079 리네이밍 '레더 하드커버책자-면지' | t_prd_products | UPDATE 1 |
| [2] | 면지자재 MAT_382/383/384 → 079(USAGE.03·dflt=382) | t_prd_product_materials | INSERT 3 |
| [3] | 면지색 옵션그룹 OPT_065 → 079 | t_prd_product_option_groups | INSERT 1 |
| [4] | 옵션 OPV_437/438/439(화/블/그) → 079 | t_prd_product_options | INSERT 3 |
| [5] | 옵션아이템(자재 ref) → 079 [트리거 선행조건=자재 [2]] | t_prd_product_option_items | INSERT 3 |
| [6] | 부모 077 OPT_065 은퇴(items→options→group) | t_prd_product_option_* | UPDATE 3/3/1 |
| [7] | 부모 077 면지자재 USAGE.03 은퇴 | t_prd_product_materials | UPDATE 3 |
| [8] | 빈멤버 080/081 셋트링크 은퇴 + [8b] use_yn=N | t_prd_product_sets / t_prd_products | UPDATE 2 / 2 |

- **적재 순서 [HARD]**: 자재[2] → 옵션[3~5] → 부모은퇴[6~7] → 셋트정리[8]. 트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.03: 같은 prd_cd에 mat_cd+usage_cd 실재) 때문에 [2] 선행 필수.
- **트랜잭션 래핑(BEGIN/COMMIT)은 load-executor**가 담당(apply-077.sql 미내장). undo=`undo-077.sql`(역순 복원).
- **선택 블록(내지 285 개수필드 정정)은 주석 유지 — 활성화 금지**(§23-inner 트랙).

## 3. 돈영향 / 라우팅

- **돈영향 0** — 재설계 요소(면지 멤버·자재·옵션) 전부 가격 미배선(공식0·직접단가0·component_prices 0행). 셋트공식 COVERBIND 단독 결정·자재 미종속. 골든 34,284/160,944/815,338 불변.
- **인간 승인 필요**: 예(라이브 COMMIT 8스텝). NO-GO/BLOCKED 행 0.
- **차단분 0** — blocked-board-077.csv 후속트랙(D-1 구성원 옵션그룹 렌더·D-2 내지 페이지가격)은 면지통합 블로커 아님. 077은 D-3(인쇄면지) 해당 없음.

## 4. COMMIT 후 검증 [HARD]

1. **사후 재실측**: FK 고아 0·`evaluate_set_price` 무손상(34,284/160,944/815,338 재확인)·활성멤버 078/285/079·080/081 use_yn=N.
2. **★webadmin 실화면 [HARD]**: product-viewer/가격시뮬레이터에서 077 — 제외 0·PRICE≠0·079 면지 드롭다운 화/블/그 발현(기본 화이트)·080/081 미노출·판형 자동선택. (`.env.local HUNI_ADMIN_*` 읽기 탐색만·저장/삭제 금지.) DB DRY-RUN만으로 COMMIT 완료 판정 금지.
3. undo-077.sql 보유(이상 시 역순 복원).

## 5. 동형 전파 상태
- 072 파일럿 COMMIT 완료 → 077 GO(본 게이트). 잔여: 082(USAGE.07 불가침 MAT_013/14/15)·088(표지 재설계 089/싸바리 적재 승인과 조율·MAT_385 인쇄면지 D-3). 077은 USAGE.07 없음 → 072와 완전 동형·불가침 이슈 0.
</content>
