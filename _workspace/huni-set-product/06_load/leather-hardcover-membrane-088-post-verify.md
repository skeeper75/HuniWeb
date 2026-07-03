# 088 레더 링바인더 면지 통합 재설계 — 사후검증 (라이브 재실측)

> §23 Huni-Set-Product · hsp-load-executor · 2026-07-03 · COMMIT 후 독립 재실측
> 게이트 S1~S8 GO + codex reconcile 합의(DISAGREE 0) + 인간 승인(082/088 마저 전파) 후 실행. 백업=`bak_*_setbuild088_20260703_1025`.

## 종합: **PASS** — COMMIT 무손상 확증. undo 불필요. ★USAGE.07 D링자재 불가침 확증. ★088-redesign 직교 무변경 확증.

---

## 1) DB 사후 재실측 (COMMIT 후 fresh SELECT)

| 항목 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 090 면지자재(USAGE.03 활성) | 4 | 4 (MAT_382 dflt=Y·383·384·385) | PASS |
| 090 옵션그룹 OPT_067(활성) | 1 | 1 | PASS |
| 090 옵션 화/블/그/인쇄(활성) | 4 | 4 | PASS |
| 090 옵션아이템(활성) | 4 | 4 (자재 ref OPT_REF_DIM.03·OPV_447→MAT_385) | PASS |
| 088 면지자재 USAGE.03(활성) | 0 | 0 | PASS (은퇴) |
| 088 OPT_067 그룹(활성) | 0 | 0 | PASS (은퇴) |
| 088 셋트 링크(활성) | 2 (089 표지 + 090 면지) | 2 / 091·092·093 del_yn=Y | PASS |
| 091/092/093 상품마스터 use_yn | N | N/N/N | PASS (은퇴) |
| 090 prd_nm | 레더 링바인더-면지 | 레더 링바인더-면지 | PASS (리네이밍) |
| **★088 USAGE.07 D링자재(MAT_247/248/249 활성)** | **3 불변** | **3 (전부 del_yn=N)** | **PASS (불가침)** |
| FK 고아(088 활성링크 sub_prd 실재) | 0 | 0 (089=t·090=t) | PASS |
| 복합PK 중복(088 sets) | 0 | 0 | PASS |
| 재-dryrun 멱등 delta | 0 | 커밋본 상태 재-apply 전 스텝 UPDATE 0·INSERT 신규 0 | PASS |

## 2) ★가격 무손상 — 골든 재측정 (돈크리티컬)

### 2a) 실엔진 재현 (real pricing.py · COVERBIND 현행 모델)
| 부수(copies) | apply 전 골든 | apply 후(실측) | 판정 |
|---|---|---|---|
| 1 | 34,100 | **34,100** | 불변 |
| 10 | 159,100 | **159,100** | 불변 |
| 100 | **796,900** | **796,900** | 불변 |

- 부모공식 배선(라이브 실측): `PRF_LEATHER_RINGBINDER_SET → COMP_HC_MUSEON_COVERBIND`(prc_typ PRICE_TYPE.01·use_dims=`["min_qty"]`·자재 미종속).
- 멤버 기여 0 = 2층 독립 확증: `t_prd_product_prices WHERE prd_cd IN(089~093)`=**0건** · `t_prd_product_price_formulas` 동일=**0건**.
- COVERBIND 6티어(1→34100·4→22425·10→15910·50→10170·100→7969·1000→6368.4) 불변(apply=t_prc_* 미터치·가드가 골든 3티어 COMMIT 조건으로 강제).

### 2b) webadmin 셋트 시뮬레이터 실호출 (인증 세션 POST /simulate-set/)
| 부수(copies) | final | errors | 판정 |
|---|---|---|---|
| 1 | **34,100** | 0 | PASS |
| 10 | **159,100** | 0 | PASS |
| 100 | **796,900** | 0 | PASS |

- **PRICE≠0**·**apply 전=후 완전 일치**·**제외 0**(errors:[])·이중합산 0.
- 멤버 collapse 4→1 면지(090) + 091/092/093 은퇴 후에도 final 불변 = 면지 통합/은퇴가 합산에 무영향(면지 각 기여 0).

## 3) ★webadmin 실화면 5항 [HARD]

| # | 확인 항목 | 근거(sim-meta/simulate-set·인증세션) | 판정 |
|---|---|---|---|
| ① 제외 0 | simulate-set errors:[] (부수 1/10/100 전부) | PASS |
| ② PRICE≠0(골든) | 34,100 / 159,100 / **796,900** 실호출 일치 | PASS |
| ③ 면지 090 "용지" 드롭다운 화/블/그/**인쇄** 4종(기본 화이트) | sim-meta 090.materials=`[{화이트면지 MAT_382 dflt=true},{블랙면지 383},{그레이면지 384},{인쇄면지 385}]` | PASS |
| ④ 빈멤버 091/092/093 미노출 | sim-meta set_members = [089 표지, 090 면지]만 (091/092/093 노출 0) | PASS |
| ⑤ D링자재 유지 | 088 USAGE.07 D링자재 MAT_247/248/249 활성 3 불변(불가침) | PASS |

접속=`.env.local HUNI_ADMIN_*`(읽기 탐색만·저장/삭제 클릭 0).

## 4) ★USAGE.07 D링자재 불가침 실증
- MAT_247/248/249 = 088에 오직 USAGE.07로만 존재·전부 del_yn=N(활성)·전부 dflt_yn=Y.
- apply-088.sql [7] `usage_cd='USAGE.03'` + mat_cd IN(382~385) 두 조건 격리 → D링(USAGE.07) 은퇴/이관 경로 0.
- DRY-RUN 전 구간(PRE/APPLY1/APPLY2/ROLLBACK) + COMMIT 후 fresh SELECT 모두 활성 3 불변. **D링 가격 보존.**

## 5) ★088-redesign-260702 직교 무변경 실증
- 089 표지 멤버: PRD_TYPE.02·use_yn=Y·`t_prd_product_prices WHERE prd_cd='PRD_000089'`=**0건**(9,000/부 mint 미적재 불변) — apply 미터치.
- COMP_BIND_SSABARI: 088에 미배선(부모 여전히 COVERBIND)·apply DML SSABARI 참조 0(위험어 전부 주석).
- apply DML 비주석 라인에 089/SSABARI/COVERBIND/9,000 mint 등장 0 → 겹치는 행 0·순서 무관.

## 6) 계열 무영향 (범위 밖 불변)
- 072(하드커버책자) · 077(레더 하드커버책자) · 082(하드커버 링책자) — 088 COMMIT이 건드리지 않음(별도 트랙·전건 COMMIT 완료).

## 7) 백업·undo
- 물리 백업(시점 스냅샷·`setbuild088_20260703_1025`): products(5)·product_sets(5)·product_materials(7=088 USAGE.03 4+USAGE.07 D링 3+090 0)·option_groups(1)·options(4)·option_items(4).
- undo: `06_load/leather-hardcover-membrane-088-undo.sql`(=03_design/088/undo-088.sql 역연산). 이상 시 실행하면 이전상태(면지 4멤버·부모 OPT_067·부모 자재 382/383/384/385) 완전 환원. ★USAGE.07 D링자재 undo 미참조(불가침 일관).
