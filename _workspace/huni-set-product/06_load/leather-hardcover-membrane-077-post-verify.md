# 077 레더 하드커버책자 면지 통합 재설계 — 사후검증 (라이브 재실측)

> §23 Huni-Set-Product · hsp-load-executor · 2026-07-03 · COMMIT 후 독립 재실측
> 게이트 S1~S8 GO + codex 합의(072 per-set 전파 4항 독립 CLOSE) + 인간 승인(077) 후 실행. 백업=`bak_*_setbuild077_20260703_0353`.

## 종합: **PASS** — COMMIT 무손상 확증. undo 불필요.

---

## 1) DB 사후 재실측 (COMMIT 후 fresh SELECT)

| 항목 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 079 면지자재(USAGE.03 활성) | 3 | 3 (MAT_382 dflt=Y·383·384) | PASS |
| 079 옵션그룹 OPT_065(활성) | 1 | 1 | PASS |
| 079 옵션 화/블/그(활성) | 3 | 3 | PASS |
| 079 옵션아이템(활성) | 3 | 3 (자재 ref OPT_REF_DIM.03) | PASS |
| 077 면지자재 USAGE.03(활성) | 0 | 0 | PASS (은퇴) |
| 077 OPT_065 그룹(활성) | 0 | 0 | PASS (은퇴) |
| 077 셋트 링크(활성) | 3 (078/285/079) | 078·285·079 del_yn=N / 080·081 del_yn=Y | PASS |
| 080/081 상품마스터 use_yn | N | N/N | PASS (은퇴) |
| 079 prd_nm | 레더 하드커버책자-면지 | 레더 하드커버책자-면지 | PASS (리네이밍) |
| FK 고아(077 활성링크 sub_prd 실재) | 0 | 0 | PASS |
| 복합PK 중복(077 sets) | 0 | 0 | PASS |
| 재-dryrun 멱등 delta | 0 | 2차 apply delta 0 (DRY-RUN 실증) | PASS |

## 2) ★가격 무손상 — evaluate_set_price 라이브 실호출 (돈크리티컬)

webadmin 셋트 시뮬레이터 `POST /admin/price-viewer/PRD_000077/simulate-set/` 실호출(인증 세션):

| 부수(copies) | apply 전 골든 | apply 후(실측) | ok | errors | 판정 |
|---|---|---|---|---|---|
| 1 | 34,100 | **34,100** | true | [] | 불변 |
| 10 | 159,100 | **159,100** | true | [] | 불변 |
| 100 | 796,900 | **796,900** | true | [] | 불변 |

- **PRICE≠0**·**apply 전=후 완전 일치**·**제외 0**(errors:[])·warnings 0.
- set_eval(PRF_HC_MUSEON_SET → COMP_HC_MUSEON_COVERBIND) 단독 = 34,100/159,100/796,900. base_total=set_eval·discounts 없음.
- 멤버 기여: 078 표지·285 내지·079 면지 전부 set_eval에 비배선(base_total=set_eval 단독) → **이중합산 0**.
- 재설계가 건드린 요소(면지멤버 통합/은퇴·면지자재 이관·부모 옵션/자재 은퇴)는 전부 가격 미배선 → 무손상 실증.

## 3) ★webadmin 실화면 4항 [HARD]

| # | 확인 항목 | 근거(sim-meta/simulate-set) | 판정 |
|---|---|---|---|
| ① 제외 0 | simulate-set errors:[] (부수 1/10/100 전부 ok:true) | PASS |
| ② PRICE≠0(골든) | 34,100 / 159,100 / 796,900 실호출 일치 | PASS |
| ③ 079 "용지" 드롭다운 화/블/그(기본 화이트) | sim-meta set_members[079].materials = 화이트면지(MAT_382 dflt=True)·블랙면지(383)·그레이면지(384) | PASS |
| ④ 빈멤버 080/081 미노출 | sim-meta set_members count=3 (078/285/079만) | PASS |

접속=`.env.local HUNI_ADMIN_*`(읽기 탐색만·저장/삭제 클릭 0).

## 4) ★이전 077 동작화 COMMIT 보존 확인

- 셋트공식 COMP_HC_MUSEON_COVERBIND 티어 34,100/15,910/7,969 불변(apply가 t_prc_* 미변경).
- 내지 285 자재 9종(백색모조지 100g dflt 등) sim-meta 정상 노출 — 이전 077 동작화(내지 285 mint·PRF_HC_MUSEON_SET 바인딩) 미변경·보존.

## 5) 계열 무영향 (범위 밖 불변)
- 082 셋트 활성멤버 6 · 088 셋트 활성멤버 5 — 077 COMMIT이 건드리지 않음(별도 승인 대기).

## 6) 백업·undo
- 물리 백업(시점 스냅샷): `bak_t_prd_products_setbuild077_20260703_0353`(4) · `bak_t_prd_product_sets_*`(5) · `bak_t_prd_product_materials_*`(3) · `bak_t_prd_product_option_groups_*`(1) · `bak_t_prd_product_options_*`(3) · `bak_t_prd_product_option_items_*`(3).
- undo: `06_load/leather-hardcover-membrane-077-undo.sql`(=03_design/077/undo-077.sql 역연산). 이상 시 실행하면 이전상태(면지 3멤버·부모 OPT_065·부모 자재 382/383/384) 완전 환원.
