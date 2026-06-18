# Wave 2 경로 Y 백로그 — 개발자 v03 재적재 (근본 교정)

> **하네스** hbg Phase 5 · `dbm-load-builder`. **작성** 2026-06-18.
> **근거:** `_deferred.md`(Wave 2 라이브 직접 부적격) · `dbm-axis-staged-load` v2(load_master=무변환 전파기·진원 ⓐ v03).
> **[HARD] 라이브 직접(경로 X) 부적격 → 근본 교정은 경로 Y(교정 v03 재적재).** webadmin 코드 수정 금지(개발자 GitHub 배포·read-only).

---

## 경로 Y 3조건 (round-22 v2 인용)

1. 시트명/헤더 v03 동일 유지.
2. 행순/surrogate 코드 보존(삭제=use_yn N·신규=말미 append).
3. 개발자가 입력 파일 교체 + 재적재(P-TRUNCATE 가드 후).

---

## R8 — 인쇄면 14 → print_side (v03 재인코딩)

| 항목 | 내용 |
|------|------|
| **진원** | v03 상품마스터에서 인쇄면(단면/양면/가로형/세로형/전면만/배면만/양면유광)을 **자재 컬럼(.09)에 인코딩** → load_master가 t_mat_materials.09로 무변환 전파 → 라이브 오적재. |
| **근본 교정** | v03에서 인쇄면 값을 **상품마스터의 인쇄면 입력 칸(print_options 소스 컬럼: print_side + front/back 도수)으로 재인코딩**. ★도수(front/back colrcnt)는 v03 원본 상품 사양 권위로 채움 — 라이브에 없는 값을 v03이 보유(또는 실무진이 상품별 확정). |
| **대상 상품 16** | PRD_000195·208·220·226·227·228·229·264·267·268·270·271·276·277·278·279 (`_deferred.md §1.2`). |
| **재적재 후 기대** | load_master가 print_options 행을 도수 포함 정상 INSERT → 라이브 print_options 0행 → 정상 채움. .09 인쇄면 자재행은 v03에서 제거(use_yn N) → 재적재 시 소멸. |
| **★주의** | 인쇄면→print_side는 아크릴 가격공식 formula 간접경로 있음 → 재적재 후 `dbm-price-arbiter` 골든 재현 검증 권고(돈 크리티컬 인접·단 cp 직접 0참조). |

## R9 — 구수 5 → bundle (v03 재인코딩 + 결정 선결)

| 항목 | 내용 |
|------|------|
| **진원** | v03에서 구수(1~4구·2개1팩)를 자재 .09에 인코딩 → 라이브 t_mat_materials.09 오적재. |
| **선결 결정(인간/실무진)** | ① 각 상품 기본 구수(`dflt_yn='Y'` 대상) ② "2개1팩"(MAT_000294) bdl_qty 정수 해석 ③ bdl_unit_typ_cd 묶음 단위 코드. |
| **근본 교정** | 결정 확정 후 v03에서 구수를 **묶음수 입력 칸(bundle_qtys 소스: bdl_qty·dflt_yn·unit)으로 재인코딩** → 재적재. |
| **대상 상품 3** | PRD_000202 키캡키링·203 LED투명키캡키링·214 자석북마크. |

## R7 — dtl_opt param 채움 (AX-5 선결 후 라이브 직접 가능)

| 항목 | 내용 |
|------|------|
| **상태** | dtl_opt 컬럼 실재(그릇 PASS) — 경로 Y 아님(option_items는 load_master 적재 단위 외·휘발 위험 낮음). |
| **선결** | ① **AX-5 범위 컨펌**(어느 상품·옵션에 어느 param 값) ② 대상 상품 **option_items 행 선적재**(현 0행). |
| **선결 후 경로** | `dbm-load-execution` 라이브 직접 dtl_opt UPDATE(멱등 가드)·`dbm-cpq-option-mapping` 트랙. **본 회차 미실행(범위 미정).** |

---

## 위임 인터페이스 (escalate 후)

| 항목 | 위임처 | 선결 |
|------|--------|------|
| R8 인쇄면→print_side | `dbm-axis-staged-load`(경로 Y 교정 엑셀) + 재적재 후 `dbm-price-arbiter`(골든) | v03 도수 권위 확정 |
| R9 구수→bundle | 결정 확정 → `dbm-axis-staged-load`(경로 Y) | dflt·2개1팩·unit 결정 |
| R7 dtl_opt | AX-5 컨펌 → `dbm-cpq-option-mapping`/`dbm-load-execution` | option_items 선적재 |

**[HARD] 본 백로그 = 경로·선결·위임까지. 실 재적재/COMMIT은 개발자 협업 + 인간 최종 승인.**
