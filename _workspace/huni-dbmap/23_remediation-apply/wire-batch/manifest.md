# WIRE 통합 배선 실행본 — 매니페스트 (round-21 시스템 결함 일괄 배선)

> 작성 2026-06-15 · `dbm-load-builder` · 권위 = round-21 6사이클 GO 제안본 4종.
> **돈-크리티컬·비파괴**(빌드 + 롤백전용 DRY-RUN까지). 실 COMMIT = 인간 승인 + 엔진 동시배포 선결.
> 라이브 PK/제약 실측 2026-06-15. 단가행 `unit_price` 절대 불변·보정 하드코딩 0.

---

## 1. 무엇을 배선하나 (FK 위상정렬 순)

| step | 파일 | 대상 테이블 | 변경 | DRY-RUN 행수 | FK 위치 근거 |
|------|------|-------------|------|:--:|------|
| 00 | `00_formulas.sql` | `t_prc_price_formulas` | 공식분리 신규 PRF_* INSERT | **3행** | 부모(배선·바인딩이 FK 참조) |
| 01 | `01_formula_components.sql` | `t_prc_formula_components` | 공식↔comp 배선 INSERT | **14행** | FK→공식(00 선행)·FK→comp(라이브 실재) |
| 02 | `02_bindings.sql` | `t_prd_product_price_formulas` | 상품 바인딩 frm_cd UPDATE | **3행** | FK→공식(00 선행·ON UPDATE CASCADE) |
| 03 | `03_matgroup_copy.sql` | `t_prc_component_prices` | 033 STD 단가행 verbatim 복제 | **6행** | FK→comp(STD 실재)·독립(공식 무관) |

**합계 = 공식 3 신설 + 배선 14 + 바인딩 3 교체 + 단가행 6 복제.**

---

## 2. 배선 INSERT 건수 (상품군별)

| 상품군 | WIRE | 공식신설 | 배선(formula_components) | 바인딩 | 단가행복제 | 닫는 결함 |
|--------|------|:--:|:--:|:--:|:--:|------|
| **명함** | NAMECARD-WIRE + MATGROUP | 2(PREMIUM·COAT) | **12**(PREMIUM 본체4+박6·COAT 2) | 2(031·032) | 6(081/091/092) | 031/032 단절·박 누락·033 소재 키부재 |
| **실사** | SILSA-WIRE(대표) | 1(BANNER_NORMAL) | **1** | 1(138) | 0 | 대표 현수막 미도달(인화지만) |
| **포토카드** | PHOTOCARD-BULK-WIRE | 0 | **1**(BULK) | 0 | 0 | 대량주문 견적 단절 |
| **합계** | | **3** | **14** | **3** | **6** | |

---

## 3. 단가행 불변 보증 [HARD·돈-크리티컬]

- `00`/`01`/`02`는 `t_prc_component_prices`를 **건드리지 않음**(공식·배선·바인딩만).
- `03` MATGROUP 복제 = 기존 074/082 행을 **verbatim 복제**(`unit_price` SELECT로 원본에서 그대로·신값 0). 기존 행 UPDATE/DELETE 0 — **신규 IDENTITY 행만 추가**.
- DRY-RUN 실증: 적용 전 기존 3,488행 체크섬 `3547b5e34b3734f08e7dc141605a5660` = 적용 후 기존 3,488행 체크섬 `3547b5e34b3734f08e7dc141605a5660`(byte-identical·기존 max id 5161 이하 전건). 복제 6행은 5161 초과 신규.
- 보정 하드코딩 0 — 값 주입 SQL 없음(전부 SELECT 복제·룩업).

---

## 4. 멱등 가드 (라이브 PK 실측 충돌키)

| step | 충돌키(라이브 PK) | 멱등 가드 | 재실행 거동 |
|------|------|------|------|
| 00 | `frm_cd` | `ON CONFLICT (frm_cd) DO NOTHING` | 이미 존재→0 |
| 01 | `(frm_cd, comp_cd)` | `ON CONFLICT (frm_cd, comp_cd) DO NOTHING` | 이미 배선→0 |
| 02 | `(prd_cd, apply_bgn_ymd)`·frm_cd PK아님 | `WHERE frm_cd=<구공식>` | 이미 신공식→0행 매칭 |
| 03 | PK=comp_price_id(IDENTITY)·자연키 UNIQUE **없음** | `INSERT … WHERE NOT EXISTS`(comp+mat+min_qty+siz·NULL-safe) | 이미 복제→0 |

→ DRY-RUN 2-pass: PASS1 = 공식3·배선14·바인딩3·복제6 / PASS2 = 전부 0(delta 0) 실증.

---

## 5. FK 위상정렬 + 원자성

`apply.sql` = `BEGIN; \i 00 → 01 → 02 → 03; (로더 ROLLBACK/COMMIT 주입)`.
- **00 공식 먼저** — 01 배선·02 바인딩이 `t_prc_price_formulas(frm_cd)` FK 참조. 공식 없이 배선/바인딩 = FK 고아.
- 01/02 comp·prd FK = 라이브 실재 확인(14 comp·031/032/033/138 전건 실재).
- 단일 트랜잭션·`ON_ERROR_STOP on` → 임의 문 실패 시 전체 롤백(원자성). 중간 COMMIT 0.

---

## 6. D-1b 순서 의존 + 동시배포 [HARD]

- **D-1b(`d1b-prctyp/`) 중복 빌드 0**: 본 트랙은 후가공 13 comp의 prc_typ 메타를 건드리지 않음(배선만).
- **명함 박 comp(COMP_NAMECARD_FOIL_*)** = D-1b 그룹②(`.06/.05`) prc_typ 정정 후보 — 본 트랙은 **배선만**(`01` step B), 메타 무관(중복 0).
- **동시배포 [HARD]**: 배선·신규공식과 **엔진 룩업/합산 해석 규칙(webadmin Phase11 evaluate_price)** 분리 배포 금지. 배선만 적용·엔진이 공식분리/모드분기를 모르면 미정의 동작. + D-1b의 `.03` 엔진 규칙과 동시. → 실 COMMIT은 엔진 동시배포 선결(인간 승인 큐 Q1/Q2).

---

## 7. 인간 승인 게이트

- 실 COMMIT(`./apply_loader.sh --commit`) = 인간 승인 너머 + 엔진 동시배포 선결. 본 실행본은 DRY-RUN까지(비파괴).
- R1~R6 게이트 = `dbm-validator`(별도 에이전트) 수행 — 자기승인 금지.
- 미해소 컨펌: **WIRE-1**(명함 ⓐ단일공식 vs ⓑ공식분리[본 빌드 가정]) · **WIRE-3b**(명함 박 동판 명함단가 흡수 여부=SETUP 별배선 이중계상 우려) · **Q-SL-PS-1**(실사 단일공식 조건분기 vs 소재별분리[대표만 분리]).
- **SILSA 완전 RESOLVED 아님**: 대표 138만 도달. 27상품 전파 = 별트랙(round-16 import.xlsx·동형 자동전파).
