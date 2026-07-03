# 082 하드커버 링책자 면지 통합 재설계 — 사후검증 (라이브 재실측)

> §23 Huni-Set-Product · hsp-load-executor · 2026-07-03 · COMMIT 후 독립 재실측
> 게이트 S1~S8 GO + codex reconcile 합의(DISAGREE 0) + 인간 승인(082/088 마저 전파) 후 실행. 백업=`bak_*_setbuild082_20260703_0426`.

## 종합: **PASS** — COMMIT 무손상 확증. undo 불필요. ★USAGE.07 링자재 불가침 확증.

---

## 1) DB 사후 재실측 (COMMIT 후 fresh SELECT)

| 항목 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 084 면지자재(USAGE.03 활성) | 4 | 4 (MAT_382 dflt=Y·383·384·385) | PASS |
| 084 옵션그룹 OPT_066(활성) | 1 | 1 | PASS |
| 084 옵션 화/블/그/인쇄(활성) | 4 | 4 | PASS |
| 084 옵션아이템(활성) | 4 | 4 (자재 ref OPT_REF_DIM.03·OPV_443→MAT_385) | PASS |
| 082 면지자재 USAGE.03(활성) | 0 | 0 | PASS (은퇴) |
| 082 OPT_066 그룹(활성) | 0 | 0 | PASS (은퇴) |
| 082 셋트 링크(활성) | 3 (083/286/084) | 3 / 085·086·087 del_yn=Y | PASS |
| 085/086/087 상품마스터 use_yn | N | N/N/N | PASS (은퇴) |
| 084 prd_nm | 하드커버 링책자-면지 | 하드커버 링책자-면지 | PASS (리네이밍) |
| **★082 USAGE.07 링자재(MAT_013/014/015 활성)** | **3 불변** | **3 (전부 del_yn=N)** | **PASS (불가침)** |
| FK 고아(082 활성링크 sub_prd 실재) | 0 | 0 | PASS |
| 복합PK 중복(082 sets) | 0 | 0 | PASS |
| 재-dryrun 멱등 delta | 0 | 커밋본 상태 재-apply 전 스텝 UPDATE 0·INSERT 신규 0 | PASS |

## 2) ★가격 무손상 — evaluate_set_price 라이브 실호출 (돈크리티컬)

webadmin 셋트 시뮬레이터 `POST /admin/price-viewer/PRD_000082/simulate-set/` 실호출(인증 세션):

| 부수(copies) | apply 전 골든 | apply 후(실측) | errors | 판정 |
|---|---|---|---|---|
| 1 | 30,184 | **30,184** | [] | 불변 |
| 10 | 151,844 | **151,844** | [] | 불변 |
| 100 | **818,438** | **818,438** | [] | 불변 |

- `set_full_scan.py PRD_000082` COPIES=100 골든 **818,438** = set_eval 800,000 (COMP_BIND_HC_TWINRING min_qty=100 → 8,000/권 × 100) + 내지 286 18,438. 면지 084 기여 0.
- **PRICE≠0**·**apply 전=후 완전 일치**·**제외 0**(errors:[])·이중합산 0.
- 멤버 collapse 6→3 (083/286/084/085/086/087 → 083/286/084) 후에도 final 818,438 불변 = 면지 통합/은퇴가 합산에 무영향(면지 4멤버 각 기여 0).
- warns=2([PRD_000083]·[PRD_000084] "가격 소스 없음")=표지/면지 무공식 기여0(072/077 동형·정상·결함 아님).
- **44123 스테일 플래그**: `set_full_scan` GOLDEN 딕셔너리 44123은 qty1·30p 동작화 골든(스캐너 COPIES=100 조건과 상이) → `!=gold` 플래그는 조건 차이이지 결함 아님(077의 51146과 동일 성격).

## 3) ★webadmin 실화면 5항 [HARD]

| # | 확인 항목 | 근거(sim-meta/simulate-set·인증세션) | 판정 |
|---|---|---|---|
| ① 제외 0 | simulate-set errors:[] (부수 1/10/100 전부) | PASS |
| ② PRICE≠0(골든) | 30,184 / 151,844 / **818,438** 실호출 일치 | PASS |
| ③ 084 "용지" 드롭다운 화/블/그/**인쇄** 4종(기본 화이트) | sim-meta set_members[084].materials count=4 · DB MAT_382 dflt=Y(화이트)·383(블랙)·384(그레이)·385(인쇄) | PASS |
| ④ 빈멤버 085/086/087 미노출 | sim-meta set_members = [083, 286, 084]만 (085/086/087 노출 0) | PASS |
| ⑤ 링자재 유지 | 082 USAGE.07 링자재 MAT_013/014/015 활성 3 불변(불가침) | PASS |

접속=`.env.local HUNI_ADMIN_*`(읽기 탐색만·저장/삭제 클릭 0).

## 4) ★USAGE.07 링자재 불가침 실증
- MAT_013(화이트링)/014(블랙링)/015(링메탈링) = 082에 오직 USAGE.07로만 존재·전부 del_yn=N(활성).
- apply-082.sql `usage_cd='USAGE.03'` 가드가 두 조건(mat_cd IN 382..385 AND usage_cd='USAGE.03') 모두로 링자재 배제 → 은퇴/이관 경로 0.
- DRY-RUN 전 구간(PRE/APPLY1/APPLY2/ROLLBACK) + COMMIT 후 fresh SELECT 모두 활성 3 불변. **링 가격(set_eval 800,000 proc 기반·자재 미종속) 보존.**

## 5) 계열 무영향 (범위 밖 불변)
- 072(하드커버책자) 968,119 · 077(레더 하드커버책자) 806,119 · 088(레더 링바인더) 796,900(멤버 5) — 082 COMMIT이 건드리지 않음(별도 트랙).

## 6) 백업·undo
- 물리 백업(시점 스냅샷·`setbuild082_20260703_0426`): products(5)·product_sets(6)·product_materials(7=082 USAGE.03 4+USAGE.07 3+084 0)·option_groups(1)·options(4)·option_items(4).
- undo: `06_load/leather-hardcover-membrane-082-undo.sql`(=03_design/082/undo-082.sql 역연산). 이상 시 실행하면 이전상태(면지 4멤버·부모 OPT_066·부모 자재 382/383/384/385) 완전 환원. ★USAGE.07 링자재 undo 미참조(불가침 일관).
