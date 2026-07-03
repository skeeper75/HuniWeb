# 072 하드커버책자 면지 통합 재설계 — 사후검증 (라이브 재실측)

> §23 Huni-Set-Product · hsp-load-executor · 2026-07-03 · COMMIT 후 독립 재실측
> 게이트 S1~S8 GO + codex 합의 + 인간 승인(072만) 후 실행. 백업=`bak_*_setbuild072_20260703_0312`.

## 종합: **PASS** — COMMIT 무손상 확증. undo 불필요.

---

## 1) DB 사후 재실측 (COMMIT 후 fresh SELECT)

| 항목 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 074 면지자재(USAGE.03 활성) | 3 | 3 (MAT_382 dflt=Y·383·384) | PASS |
| 074 옵션그룹 OPT_064(활성) | 1 | 1 | PASS |
| 074 옵션 화/블/그(활성) | 3 | 3 (화이트 dflt=Y·블랙·그레이 use_yn=Y) | PASS |
| 074 옵션아이템(활성) | 3 | 3 (자재 ref OPT_REF_DIM.03) | PASS |
| 072 면지자재 USAGE.03(활성) | 0 | 0 | PASS (은퇴) |
| 072 OPT_064 그룹/옵션/아이템(활성) | 0/0/0 | 0/0/0 | PASS (은퇴) |
| 072 셋트 링크(활성) | 3 (073/074/284) | 073·074·284 del_yn=N / 075·076 del_yn=Y | PASS |
| 075/076 상품마스터 use_yn | N | N/N | PASS (은퇴) |
| 074 prd_nm | 하드커버책자-면지 | 하드커버책자-면지 | PASS (리네이밍) |
| FK 고아(072 활성링크 sub_prd 실재) | 0 | 0 | PASS |
| 복합PK 중복(072 sets) | 0 | 0 | PASS |
| 재-dryrun 멱등 delta | 0 | 2차 apply delta 0 (DRY-RUN 실증) | PASS |

## 2) ★가격 무손상 — evaluate_set_price 라이브 실호출 (돈크리티컬)

webadmin 셋트 시뮬레이터 `POST /admin/price-viewer/PRD_000072/simulate-set/` 실호출 결과(인증 세션):

| 부수(copies) | final_price(실측) | 골든 | ok | errors(제외) |
|---|---|---|---|---|
| 1 | **34,100** | 34,100 | true | [] |
| 10 | **159,100** | 159,100 | true | [] |
| 100 | **796,900** | 796,900 | true | [] |

- **PRICE≠0**·**골든 정확 일치**·**제외 0**(errors:[]).
- 멤버 기여: 073 표지=0(NONE)·284 내지=0(FORMULA→0)·074 면지=0(NONE) → **이중합산 0**.
- set_eval(COVERBIND) 단독 = 34,100/159,100/796,900. 면지 재설계가 건드린 요소(면지멤버·면지자재·면지옵션) 전부 가격 미배선 → 무손상 실증.
- warnings(가격 소스 없음·내지 0원)는 도메인 특성(면지=제본비 포함·표지 base=0 오라클)으로 재설계 전후 동일·에러 아님.

## 3) ★webadmin 실화면 4항 [HARD]

| # | 확인 항목 | 근거 | 판정 |
|---|---|---|---|
| ① 제외 0 | simulate-set errors:[] (부수 1/10/100 전부 ok:true) | PASS |
| ② PRICE≠0(골든) | 34,100 / 159,100 / 796,900 실호출 일치 | PASS |
| ③ 074 "용지" 드롭다운 화/블/그(기본 화이트) | sim-meta set_members[074].materials = 화이트면지(MAT_382 dflt)·블랙면지(383)·그레이면지(384) | PASS |
| ④ 빈멤버 075/076 미노출 | sim-meta set_members count=3 (073/284/074만) | PASS |
| (부가) 부모 072 면지자재/옵션그룹 은퇴 | product-viewer 072 상세: 자재(0)·옵션그룹(0) 실화면 | PASS |

접속=`.env.local HUNI_ADMIN_*`(gstack 읽기 탐색만·저장/삭제 클릭 0).

## 4) 백업·undo
- 물리 백업(시점 스냅샷): `bak_t_prd_products_setbuild072_20260703_0312`(4) · `bak_t_prd_product_sets_*`(5) · `bak_t_prd_product_materials_*`(3) · `bak_t_prd_product_option_groups_*`(1) · `bak_t_prd_product_options_*`(3) · `bak_t_prd_product_option_items_*`(3).
- undo: `06_load/leather-hardcover-membrane-072-undo.sql`(=03_design/undo.sql 역연산). 이상 시 실행하면 이전상태 완전 환원.
