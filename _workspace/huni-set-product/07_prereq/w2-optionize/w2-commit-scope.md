# W2 COMMIT 범위 — 면지(T1) + 굿즈 PET(T2) + T3 즉시옵션화분

> 사용자 결정 반영: T1 면지 + T2 굿즈 PET + T3 즉시분(`fn_chk_opt_item_ref` 통과 입증분만)을 load-ready로 마감.
> **라이브 읽기전용 SELECT만 · COMMIT 금지**. 실 적재는 인간 승인 후 별도 트랙(dbm-load-execution).
> 실측일 2026-06-25 · 권위 = 상품마스터 260610 + 라이브 실측. 식별자/코드/SQL 영문.
> load CSV = `load/t_prd_product_option_groups.csv` · `t_prd_product_options.csv` · `t_prd_product_option_items.csv` (채번 확정·[CONFIRM] 제거).

---

## 1. COMMIT 범위 총괄

| 트랙 | 그룹수 | 옵션수 | 대상상품 | 변형축 |
|---|---|---|---|---|
| T1 면지 | 4 | 14 | PRD_072·077·082·088 | 색축(자재 OPT_REF_DIM.03) |
| T2 굿즈 PET | 1 | 2 | PRD_193 머그컵 | 투명도축(자재) |
| T3 즉시 | 5 | 15 | PRD_140·142·197·198·217 | 색축(실사색·잉크색) |
| **합계** | **10** | **31** | **10 상품** | — |

- option_group 10 / option 31 / option_item 31 (옵션 1개 = item 1개, 단일 자재 ref).
- 채번 (라이브 MAX+1 순차 surrogate, separator `_`):
  - opt_grp_cd: 라이브 MAX `OPT_000063` → **OPT_000064 ~ OPT_000073** (10개)
  - opt_cd: 라이브 MAX `OPV_000433` → **OPV_000434 ~ OPV_000464** (31개)
  - item_seq: 각 옵션 내 1 (단일 ref)

---

## 2. 트리거 통과 근거 (라이브 EXISTS 입증)

`fn_chk_opt_item_ref`(OPT_REF_DIM.03 자재) 요구: `t_prd_product_materials(prd_cd, mat_cd=ref_key1, usage_cd=ref_key2)` EXISTS(del_yn='N').

COMMIT 범위 31 option_item 전건 라이브 검증 (FAIL 0):
```sql
WITH items(prd_cd,mat_cd,usage_cd) AS (VALUES (... 31행 ...))
SELECT count(*) total, count(*) FILTER (WHERE EXISTS(
  SELECT 1 FROM t_prd_product_materials x
  WHERE x.prd_cd=i.prd_cd AND x.mat_cd=i.mat_cd AND x.usage_cd=i.usage_cd AND x.del_yn='N')) trig_pass
FROM items i;
-- 결과: total=31, trig_pass=31  (전건 통과, BLOCKED 0)
```

- T1 면지: ref_key2 = **USAGE.03**(면지). 자재 4종 전부 활성(del_yn=N) · 4상품 배선 확인.
- T2 머그컵: ref_key2 = **USAGE.07**(공통). 투명143·반투명146 EXISTS=t.
- T3 즉시: ref_key2 = **USAGE.07**. 실사색(255/256)·잉크색(297~303) EXISTS=t.

---

## 3. 트랙별 상세

### 3.1 T1 면지 — disp_seq 권위 확정

상품마스터 260610 `booklet-l1.csv` 컬럼 `제본(옵션)_면지(옵션)` **행 등장 순서가 표시순서**(권위):
**화이트(1) → 블랙(2) → 그레이(3) → 인쇄(4)**

> 직전 설계의 "화이트→그레이→블랙" 추정을 권위로 정정 = **화이트→블랙→그레이**. 권위 주석 확인: "★인쇄면지는 하드커버링책자/레더링바인더만 있음" → PRD_082·088만 4번째 옵션(인쇄), PRD_072·077은 3색.

| prd_cd | opt_grp_cd | 옵션(disp_seq·dflt) |
|---|---|---|
| PRD_000072 하드커버책자 | OPT_000064 | 화이트(1·dflt)·블랙(2)·그레이(3) |
| PRD_000077 레더 하드커버책자 | OPT_000065 | 화이트(1·dflt)·블랙(2)·그레이(3) |
| PRD_000082 하드커버 링책자 | OPT_000066 | 화이트(1·dflt)·블랙(2)·그레이(3)·인쇄(4) |
| PRD_000088 레더 링바인더 | OPT_000067 | 화이트(1·dflt)·블랙(2)·그레이(3)·인쇄(4) |

- sel_typ_cd=SEL_TYPE.01(택1)·min=max=1·mand_yn=Y. 인쇄면지(MAT_000004)는 자재 stock 유지하며 옵션값으로도 노출(이중역할 양립).

### 3.2 T2 굿즈 PET — 머그컵 투명도

| prd_cd | opt_grp_cd | 옵션(disp_seq·dflt) | ref |
|---|---|---|---|
| PRD_000193 머그컵 | OPT_000068 (투명도) | 투명(1·dflt)·반투명(2) | MAT_000143/146 · USAGE.07 |

- 머그컵엔 투명/반투명 2종 + 화이트(.08 색1종) + 화이트머그(.12 본체). 투명도 2종은 택1 성립 → 옵션화. 화이트(.08)는 단독(택1 불성립)이라 색옵션 미생성(본체 dflt 고정).
- **미니우치와키링(PRD_227)은 제외**: 반투명146 단독 배선(투명 대안 부재) = 택1 불성립 → CONFIRM(deferred).

### 3.3 T3 즉시옵션화분 — 색축(택1 성립·트리거 t)

67건 중 ★라이브 EXISTS로 트리거 통과 + 같은 상품에 색 2종 이상(택1 성립)인 항목만:

| prd_cd | opt_grp_cd | 옵션 | ref usage |
|---|---|---|---|
| PRD_000140 무광시트커팅 | OPT_000069 (색상) | 화이트(dflt)·블랙 | USAGE.07 |
| PRD_000142 유광아크릴스티커 | OPT_000070 (색상) | 화이트(dflt)·블랙 | USAGE.07 |
| PRD_000197 미니매트 | OPT_000071 (색상) | 화이트(dflt)·블랙 | USAGE.07 |
| PRD_000198 피크닉매트 | OPT_000072 (색상) | 화이트(dflt)·블랙 | USAGE.07 |
| PRD_000217 만년스탬프 | OPT_000073 (잉크색) | 청보라(dflt)·빨강·검정·파랑·초록·핑크·노랑 | USAGE.07 |

> **T3 즉시분 = 5그룹 / 15옵션 (자재 7종: 255·256·297~303).**
> 67건 중 나머지는 deferred: BLOCKED-needs-L1(siz/print_options 차원행 0) + CONFIRM(소재효과·구수·복합축·단독배선). w2-deferred.md 참조.
> T3 즉시분이 0건이 아님을 명시 — 색축 5상품이 트리거 통과로 즉시 가능.

---

## 4. 돈영향 재확인 = 0

COMMIT 범위 전 자재(MAT_000001~004·143·146·255·256·297~303)의 `t_prc_component_prices` 단가행 = **0**(실측). 옵션 선택이 가격을 바꾸지 않음(옵션가 미발생). → **W2 COMMIT 범위 돈영향 0.**

---

## 5. 멱등 키 (재적재 안전)

- option_groups PK (prd_cd, opt_grp_cd) — 이름기반 멱등: 같은 (prd_cd, opt_grp_nm) 중복 신설 방지. 적재 전 search: `SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd=? AND opt_grp_nm=?` (현재 10상품 전부 0행 = 중복 없음, 라이브 확인).
- options PK (prd_cd, opt_cd) — (prd_cd, opt_grp_cd, opt_nm) 이름기반 멱등.
- option_items PK (prd_cd, opt_cd, item_seq).
- surrogate 채번은 적재 시점 라이브 MAX+1 재확인 권장(다른 트랙 동시 적재 시 충돌 회피). 본 CSV 값은 2026-06-25 MAX 기준.

---

## 6. FK 위상 적재 순서

1. (선행 완료) `t_prd_product_materials` — COMMIT 범위 자재 전부 이미 라이브(추가 적재 0).
2. `t_prd_product_option_groups` (10행).
3. `t_prd_product_options` (31행).
4. `t_prd_product_option_items` (31행) — 트리거 발화 지점, §2에서 전건 통과 입증.

> constraint/template 불필요(단순 택1·본체 구성요소). 단가행 0.
