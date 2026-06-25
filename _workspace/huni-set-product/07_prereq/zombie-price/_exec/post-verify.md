# 사후검증 — 좀비 자재 2건 부활 (MAT_000159·MAT_000119)

실행일시: 2026-06-24 03:51 UTC (COMMIT) · DB `railway`(읽기전용 외 2 UPDATE 한정)
핵심 판정: **청구 불변 입증 = PASS (6/6).** 불일치 0 → undo 불요.

---

## 6항목 사후검증 결과

| # | 검증 | 기대 | 실측 | 판정 |
|---|---|---|---|---|
| ① | 159·119 del_yn='N' | 둘 다 N | 159=N, 119=N (del_dt 보존·upd_dt 트리거 자동) | **PASS** |
| ② | 단가행 불변 (지문 동일) | before 지문과 동일 | 119=`1765b441ff4b999a3e1316137663ef11`(1행·500) / 159=`6d04122679655aa3f2b4c84d14c6f0e5`(20행·sum 4,894,000) — before와 byte-identical | **PASS** |
| ③ | 배선 불변 | 159=1, 119=4 | 159=1(PRD_000050) / 119=4(031·047·048·111) | **PASS** |
| ④ | 견적 불변 (골든 e2e) | COMMIT 전후 동일 | 골든 행집합 diff 0 — GOLDEN_A·GOLDEN_B 둘 다 IDENTICAL | **PASS** |
| ⑤ | FK 고아 신규발생 0 | delta 0 | prc=3,951(기준선 동일·기존 NULL/코드행 잔존분, delta 0) / pm=0 | **PASS** |
| ⑥ | 재-DRYRUN delta 0 | UPDATE 0 | UPDATE 0 (멱등) | **PASS** |

---

## ④ 견적 불변 — 봉투/전단지 수치 (verbatim, COMMIT 전후 동일)

엔진 근거: `pricing.py:259-262 _component_rows(comp_cd)` = `comp_cd`만 필터, **del_yn 필터·t_mat_materials JOIN 없음**.
→ 자재 del_yn 플립은 가격 매칭 입력집합을 구조적으로 못 바꾼다. 골든 행집합 diff=0이 이를 실증.

### 봉투제작 PRD_000050 (159 = COMP_ENV_MAKING, 20행 불변)
| siz_cd | 규격 | min_qty | unit_price (전·후 동일) |
|---|---|---|---|
| SIZ_000191 | 225x193 | 1,000 | 96,000 |
| SIZ_000191 | 225x193 | 5,000 | 480,000 |
| SIZ_000194 | 510x387 | 1,000 | 134,000 |
| SIZ_000194 | 510x387 | 5,000 | **672,000** |
- 20행 합(sum_unit) = 4,894,000 (전·후 동일).

### 소량전단지 PRD_000047 (119 = COMP_PAPER, 1행 불변)
| plt_siz_cd | unit_price (전·후 동일) |
|---|---|
| SIZ_000499 (316x467 전지) | **500.00 /판** |

---

## 무결성·안전

- **변경면적 = t_mat_materials 2행의 del_yn 컬럼만.** 단가행 0건 변경·배선 0건 변경.
- 제약: `ck_t_mat_materials_del_yn` (Y|N) 위반 0 · FK 5개 무관(플립 컬럼 아님).
- 트리거 `trg_t_mat_materials_upd_dt` → upd_dt 자동(=03:51:54). del_dt는 미변경(부활 후에도 원 삭제이력 보존 — 멱등/감사용).
- 백업 `bak_t_mat_materials_zombie_20260624_1250`(2행·부활 전 del_yn='Y'/del_dt 보존) 존재.

## undo 경로
불일치 0 → **미실행.** 필요 시 `undo.sql`(백업 기준 del_yn='N'→'Y'+del_dt 복원, 멱등 `WHERE del_yn='N'`).

## 범위 외(이번 미실행·확인됨)
- 권고2(죽은 119 배선 031·048·111 정리) — 가격영향 0·UI 잉여, 별건 보류.
- CONFIRM-159(159=073 통합)·CONFIRM-119-root(upr_mat_cd 재지정) — 인간 확인 의존, 미실행.
- GAP: PRD_000050 봉투 169(레자크) COMP_ENV_MAKING 행 0건 — 본 부활과 독립.
