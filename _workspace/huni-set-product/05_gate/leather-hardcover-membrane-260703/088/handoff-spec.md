# 088 면지 통합 — 게이트 인계 명세 (COMMIT 승인 대기)

> §23 hsp-set-gate → load-executor · 2026-07-03 · **게이트 GO·DB 미적재(게이트는 COMMIT 안 함).**

## 적재 승인 큐 (GO)

| 항목 | 값 |
|---|---|
| 적재본 | `03_design/leather-hardcover-membrane-redesign-260703/088/apply-088.sql`(8스텝) |
| undo | 동 디렉토리 `undo-088.sql` |
| 대상 t_* | t_prd_products·t_prd_product_materials·t_prd_product_option_groups/options/items·t_prd_product_sets |
| 신규 mint | **0**(전부 라이브 기존 참조 재사용) · 물리 DELETE 0 |
| 돈 영향 | **0**(골든 34,100/159,100/796,900 불변·실엔진 재현) |
| 게이트 | S1~S8 전부 PASS·codex DISAGREE 0·CONDITIONAL GO 수렴 |
| 인간 승인 | **필요**(COMMIT 미실행) |

## COMMIT 실행 조건 [HARD]

1. **순서**: apply 내부 자재[2]→옵션[3~5]→은퇴[6~7]→정리[8] 유지(fn_chk_opt_item_ref 트리거 선행조건).
2. **트랜잭션 래핑**: load-executor가 BEGIN/COMMIT 담당(apply 파일 미내장) + 물리 백업 선행.
3. **★webadmin 실화면**(CLAUDE.md §1): COMMIT 후 제외 0·PRICE≠0·면지색 4택1(자재 드롭다운) 렌더 확인 의무 — 미확인 시 미완료.
4. **불가침**: USAGE.07 D링(MAT_247/248/249)·표지 089·부모공식 배선·9,000 mint 미터치(스코프 밖).

## 088-redesign-260702 조율 (순서 무관 명기)

- 088-redesign(9,000 표지+SSABARI)은 라이브 실측 결과 **미적재(pending)** — COVER_comp 0·088 proc 0·089 formula 0·SSABARI 미배선.
- 본 면지 통합과 **완전 직교**(겹치는 행 0). load-executor는 두 apply를 **어느 순서로도**(전/후/동시·독립) 실행 안전. 보류 불필요.
- 병합 금지 준수: apply-088.sql은 면지 통합분만·재설계분은 `088-redesign-260702/apply.sql` 별도 유지.

## 선존 이슈 (본 재설계 무손상·후속 라우팅)

| 항목 | 상태 | 라우팅 |
|---|---|---|
| 인쇄면지(MAT_385/OPV_447) 인쇄비 0 | 선존·면지 무공식이라 "인쇄" 택해도 인쇄비 0 | §18(D-3) 후속 |
| 090 옵션그룹 시뮬레이터 렌더 휴면(색택1=자재로 발현) | 선존·본 건 무손상 | DEV-REQUEST(D-1) 후속 |
| COMP_HC_MUSEON_COVERBIND 072/077/088 공유(임시 COVERBIND 모델) | 선존·088-redesign 트랙 소관 | §23 088-redesign(SSABARI 재배선) |
