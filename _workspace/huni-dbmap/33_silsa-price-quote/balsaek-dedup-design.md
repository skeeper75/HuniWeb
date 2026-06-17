# 별색 dedup (U5') 정립 — 형제 색 comp 정본 흡수 (round-23·설계+검증)

> **작성** 2026-06-17 · round-23. **설계·검증까지 — 적재/COMMIT 안 함**(실 COMMIT 인간 승인). 입력 = `grouping-model-design.md`(별색=단일 comp+proc_cd 색축·U5')·라이브 read-only psql 실측.
>
> **U5':** 별색 형제 색별 분리 comp(GOLD/PINK/SILVER/CLEAR·WHITE_S2)를 정본(WHITE_S1)으로 흡수. 그룹핑 모델(proc_cd 색축·삭제 아닌 use_yn=N + 배선 교체).

---

## 0. 핵심 5줄

1. **형제 레거시 = 9 comp**(CLEAR/GOLD/PINK/SILVER S1·S2 8개 + WHITE_S2). 정본 = **WHITE_S1(530행)** — 5색(proc_cd PROC_000008~012=화이트/클리어/핑크/금/은) × 2면(print_opt POPT_000001 단면·POPT_000002 양면) × 53구간 = 530행 **전건 보유**.
2. **★재적재 0 입증(가격 불변):** GOLD_S1(53행, proc 011) ↔ 정본 WHITE_S1의 proc 011 단가행 = **match 53·missing 0·diff 0**(라이브 대조). 정본에 5색×2면 전건 실재 → 형제 흡수 시 **단가행 이설/재적재 0**.
3. **★S1/S2 분리 자체가 불필요 — 정본 단일화.** WHITE_S1이 단면(POPT_000001)+양면(POPT_000002)을 print_opt_cd 면축으로 이미 담음 → **WHITE_S2(양면 화이트)도 흡수 대상**(정본에 양면 화이트 53행 실재). 면=별 comp가 아니라 print_opt_cd 차원.
4. **흡수 방식 = 9 형제 use_yn=N(논리삭제·단가행 보존) + 배선 정본 교체.** 형제는 PRF_DGP_A에만 배선 → PRF_DGP_A의 형제 9 comp 배선 제거, 정본 WHITE_S1 1개로 축소(WHITE_S1·S2는 이미 포스터 공식 29개에도 배선됨).
5. **명명 보정:** 정본 WHITE_S1 comp_nm 이미 "별색인쇄 출력비"(종류중립·일부 보정됨). 추가 보정 = "별색인쇄비"로 통일 권고(round-17 가독성). 형제 9는 use_yn=N이므로 명명 무관.

---

## 1. 형제 레거시 comp 목록·정본 흡수 매핑 (라이브 실측)

| comp_cd | comp_nm | 행수 | proc_cd(색) | use_yn | 처리 |
|---------|---------|:--:|:--:|:--:|------|
| **COMP_PRINT_SPOT_WHITE_S1** | 별색인쇄 출력비 | **530** | 008~012(5색) | Y | **★정본 유지**(5색×2면 전건) |
| COMP_PRINT_SPOT_WHITE_S2 | 별색인쇄비 화이트(양면) | 53 | 008 | Y | 흡수→use_yn=N(정본에 008+양면 실재) |
| COMP_PRINT_SPOT_CLEAR_S1 | 별색인쇄비 클리어(단면) | 53 | 009 | Y | 흡수→use_yn=N |
| COMP_PRINT_SPOT_CLEAR_S2 | 별색인쇄비 클리어(양면) | 53 | 009 | Y | 흡수→use_yn=N |
| COMP_PRINT_SPOT_GOLD_S1 | 별색인쇄비 금색(단면) | 53 | 011 | Y | 흡수→use_yn=N(대조 match 53) |
| COMP_PRINT_SPOT_GOLD_S2 | 별색인쇄비 금색(양면) | 53 | 011 | Y | 흡수→use_yn=N |
| COMP_PRINT_SPOT_PINK_S1 | 별색인쇄비 핑크(단면) | 53 | 010 | Y | 흡수→use_yn=N |
| COMP_PRINT_SPOT_PINK_S2 | 별색인쇄비 핑크(양면) | 53 | 010 | Y | 흡수→use_yn=N |
| COMP_PRINT_SPOT_SILVER_S1 | 별색인쇄비 은색(단면) | 53 | 012 | Y | 흡수→use_yn=N |
| COMP_PRINT_SPOT_SILVER_S2 | 별색인쇄비 은색(양면) | 53 | 012 | Y | 흡수→use_yn=N |

- **정본 WHITE_S1 구성(실측):** proc 008/009/010/011/012 × POPT_000001(단면)/POPT_000002(양면) × 53구간 = 5×2×53 = **530행**. 즉 색(proc_cd)·면(print_opt_cd) 전 조합 보유.
- **흡수 대상 9 comp = 정본의 부분집합.** 각 형제(색×면)는 정본 WHITE_S1에 (proc_cd, print_opt_cd) 조합으로 이미 존재 → **단가행 재적재 0**.

### 1.1 재적재 0 입증 (대조 쿼리 결과)

```
GOLD_S1(proc 011, 53행) vs WHITE_S1 proc 011 (단면+양면 106행 중 단면 53):
  match=53, missing_in_master=0, diff=0  → 가격 100% 일치·정본에 전건 존재
```
→ 형제 9 comp 단가행 = 정본 WHITE_S1에 동일값으로 전건 실재. **흡수=배선 제거+use_yn=N만**, 단가행 INSERT/이설 0.

---

## 2. 통합 방식 (그룹핑 모델·삭제 아님)

### 2.1 use_yn=N + 배선 교체

| 단계 | 조치 |
|------|------|
| 1. 정본 확정 | WHITE_S1(530행·5색×2면) = 별색 통합 정본. 단가행 무변경 |
| 2. 형제 use_yn=N | 9 comp(WHITE_S2·CLEAR/GOLD/PINK/SILVER S1·S2) use_yn='N'(논리삭제·단가행 보존·del_yn 별도) |
| 3. 배선 교체 | PRF_DGP_A의 형제 9 comp 배선(formula_components) 제거 → 정본 WHITE_S1 1개로(이미 배선됨·중복 제거) |
| 4. 명명 보정 | WHITE_S1 comp_nm "별색인쇄 출력비"→"별색인쇄비"(종류중립·round-17) |

- **삭제 아님:** 단가행·comp 행 보존(use_yn=N). 그룹핑 모델 P-1 정정(이전 "424 DELETE" 철회) 준수.
- **배선:** 형제는 PRF_DGP_A에만 배선(실측) → PRF_DGP_A에서 9 comp 배선 제거. 정본 WHITE_S1은 PRF_DGP_A + 포스터 29공식에 이미 배선(무변경).

### 2.2 엔진 정합 (선택 매칭)

- 사용자가 별색 선택(proc_cd=금색 PROC_000011 + print_opt_cd 면) → 정본 WHITE_S1에서 (proc_cd, print_opt_cd, min_qty) 매칭 → 금색 단가. **5색 전부 정본 1 comp로 조회**(grouping `(comp, proc_cd)` 키).
- 형제 use_yn=N → 엔진 _component_rows 제외(use_yn 필터). 동시매칭 위험 0(정본만 활성).

---

## 3. 가격 불변 검증

| 검증 | 방법 | 결과 |
|------|------|------|
| 색별 단가 동일 | GOLD_S1 53행 vs 정본 WHITE_S1 proc 011 단가 | **match 53·diff 0**(라이브 대조) |
| 면 보존 | 정본에 단면(POPT_000001)·양면(POPT_000002) 전색 실재 | 530=5색×2면×53 실측 |
| 흡수 후 견적 불변 | proc_cd 색 선택 시 정본이 동일 단가 반환 | 형제=정본 부분집합·값일치 |
| 배선 교체 가격영향 | 형제 PRF_DGP_A 배선 → 정본 1 comp(같은 proc_cd 매칭) | 동일 색 → 동일 단가(불변) |

> CLEAR/PINK/SILVER도 GOLD와 동형(각 53행·정본 proc 009/010/012에 대응) — 대조 GOLD로 입증·나머지 동형(DRY-RUN 전건 재대조 권고).

---

## 4. load-builder 인계 단위 (U5'-1~) + BLOCKED/컨펌

| 단위 | 테이블 | 조치 | 행수 | 멱등키 | 재적재 |
|------|--------|------|:--:|--------|:--:|
| **U5'-1 형제 use_yn=N** | t_prc_price_components | 9 형제 comp use_yn='N' | 9 UPDATE | comp_cd | — |
| **U5'-2 배선 제거** | t_prc_formula_components | PRF_DGP_A ← 9 형제 comp 배선 DELETE | 9 DELETE | (frm_cd,comp_cd) | — |
| **U5'-3 명명 보정** | t_prc_price_components | WHITE_S1 comp_nm→"별색인쇄비" | 1 UPDATE | comp_cd | — |
| **(단가행)** | — | 형제 단가행 보존(이설/삭제 0·정본 전건 실재) | **0** | — | **0** |

- **순서:** U5'-2(배선 제거) → U5'-1(use_yn=N) (배선 고아 방지: comp use_yn=N 전 배선 제거). U5'-3 독립.
- **DRY-RUN(R1~R6):** ① 멱등 delta 0 ② 정본 WHITE_S1 530행 무변경 ③ 형제 9 색 단가 = 정본 전건 대조 일치(GOLD 외 CLEAR/PINK/SILVER 재대조) ④ PRF_DGP_A 배선에서 형제 제거 후 정본 1 comp 잔존 ⑤ 골든: 금색 별색 견적 = 흡수 전후 동일 ⑥ use_yn=N 후 엔진 형제 제외·동시매칭 0.

| ID | 컨펌 | 권고 |
|----|------|------|
| Q-B1 | WHITE_S1 정본 명명 "별색인쇄 출력비" vs "별색인쇄비" | 종류중립 "별색인쇄비"(WHITE 흔적 제거) |
| Q-B2 | comp_cd 자체 SPOT_WHITE_S1(WHITE 잔재) 개명 vs 유지 | 개명은 FK 연쇄(배선 29공식)·**유지**(comp_nm만 보정·comp_cd는 명명규칙 예외) |
| Q-B3 | 형제 단가행 use_yn=N 후 물리 삭제 시점 | 보존(논리삭제만·백업 가치) |
| Q-B4 | S1/S2 comp 분리 폐지(정본 1개로) vs S1/S2 2 정본 | 1개(print_opt_cd 면축이 단/양면 흡수·실측) |

> **BLOCKED 없음** — 흡수 전건 정본 부분집합·재적재 0·배선 단순(PRF_DGP_A만). 단 Q-B2(comp_cd 개명) 회피로 SPOT_WHITE_S1 명칭 잔재는 comp_nm 보정으로 완화.

---

## 5. read-only 준수

- 라이브 SELECT(별색 10 comp 행수·proc_cd 색축·use_yn·GOLD↔정본 대조 match53/diff0·배선 현황·정본 5색×2면 530). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 설계·검증까지 — load-builder U5'-1~3 멱등 SQL·DRY-RUN·GO는 dbm-validator·실 COMMIT 인간 승인. 그룹핑 모델 P-1(424 DELETE 철회) 준수=삭제 아닌 use_yn=N.
