# 검증 리포트 — 수량 구간 할인 매핑 (Round 1)

검증자: `dbm-validator`. 일자: 2026-06-04. 입장: 적대적 (반증되기 전까지 결함을 가정).
방법: 라이브 `railway` DB (읽기 전용), 원본 xlsx 셀, 로컬 제약 계산에 대한 경계 교차 대조. **DB 기록 미수행.**

적용 권위 순서: 라이브 DB 스키마 > 스키마 시트 (`00_schema/*`) > mapping-spec. 원본 xlsx 셀 > `discount-brackets.csv`.

검증 대상 산출물:
- `load/t_dsc_discount_tables.csv` (3행)
- `load/t_dsc_discount_details.csv` (16행)
- `load/t_prd_product_discount_tables.csv` (70행)
- `mapping-spec.md`, `dsc-code-proposals.md`, `01_excel/discount-brackets.csv`
- 소스: `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`

---

## 최종 판정: **GO** (현 상태로 적재 가능)

- **Hard 결함 (수정 필수 blocker): 0**
- **MAJOR: 0** (범위 도출 출처 관련 발견 M1 한 건은 비차단 — 상품은 유효하며 존재함)
- **MINOR: 2** (M2 범위 텍스트 주석, M3 날짜 포맷 선례)
- **사용자 확인이 필요한 설계 결정: 8** (D1–D8 — 검증자의 판단 영역 아님; blocker 아님)
- **prd_cd 존재 여부: 70 / 70이 `t_prd_products`에 존재 (누락 0).**

세 개의 CSV는 모든 적재 핵심 DB 제약 (타입, 길이, NOT NULL, CHECK NAND, FK 존재, PK 유일성)을
충족하며 적재 순서는 FK-safe다. 매핑은 첫 시도에 삽입 가능하다. 유일한 실질적 발견 (M1)은
pouch_eco 범위가 명세가 주장하는 대로 CAT_000011 서브트리에서 재도출될 수 없다는 점이다 — 다만
상품들은 실제로 존재하는 진짜 파우치이므로 적재 blocker가 아닌 출처/범위 확인 항목이다.

---

## BOUNDARY 1 — Excel 정규화본 ↔ 원본 xlsx 셀

**PASS.** `후니프린팅_인쇄상품_가격표_260527.xlsx`에서 16개 소스 셀을 모두 재독해하여
`discount-brackets.csv` 및 적재 CSV와 대조했다.

| Block | xlsx range | xlsx 셀 (range → rate_raw) | discount-brackets.csv | 적재 dsc_rate (×100) | Match |
|-------|-----------|-------------------------------|-----------------------|----------------------|:----:|
| acrylic | 아크릴!A51:B56 | 1~49→0.0, 50~99→0.1, 100~299→0.2, 300~499→0.3, 500~999→0.4, 1000~10000→0.5 | identical | 0/10/20/30/40/50 | ✓ |
| pouch_eco | 굿즈파우치(구간할인)!A3:B7 | 1~49→0.0, 50~99→0.05, 100~499→0.1, 500~999→0.15, 1000~10000→0.2 | identical | 0/5/10/15/20 | ✓ |
| stationery | 굿즈파우치(구간할인)!A12:B16 | pouch와 동일 | identical | 0/5/10/15/20 | ✓ |

발견:
- 누락/오파싱된 구간 없음. 모든 `min~max` 범위가 정수 `min_qty`/`max_qty`로 정확히 분리됨.
- 잡음 라벨 `아크릴!A57='까지'`는 올바르게 제외됨 (7번째 구간 아님). acrylic 스케줄은 pouch/stationery와 정확히 구별됨 (가파른 요율, 다른 중간 구간 100~299/300~499) — "공유 스케줄을 가정하지 말 것" 경고가 준수됨.
- A49/A1/A10의 블록 제목이 헤더 CSV `dsc_tbl_nm`과 그대로 일치.
- **MINOR M2 (출처, 결함 아님):** `discount-brackets.csv`의 pouch_eco `apply_scope_text`는 `"파우치+에코백 전체"`로 적혀 있으나, xlsx 블록 제목 (A1)은 `"파우치상품 수량별 구간할인"`이다. 정규화 과정에서 범위 텍스트를 보강했다 (정당함 — 가시 범위 내에 이 블록의 범위 셀이 없으며, 해당 텍스트는 분석자 주석으로 보임). 헤더 `dsc_tbl_nm`은 원문 제목을 올바르게 그대로 유지한다. 손상된 값 없음. "에코백" 포함의 출처를 추적 가능하도록 표시만 한다 (M1을 유발함).

---

## BOUNDARY 2 — details CSV ↔ 라이브 스키마

**PASS** (적재 핵심). `pg_constraint`에서 가져온 라이브 제약 정의에 대해 검증.

라이브 제약 (권위):
- `ck_t_dsc_discount_details_amt_excl` = `CHECK ((dsc_rate IS NULL) OR (dsc_amt IS NULL))` — NAND 확인 (둘 다 null이면 CHECK 통과).
- NOT NULL: `dsc_tbl_cd`, `apply_ymd`, `min_qty`, `reg_dt`.
- PK `(dsc_tbl_cd, apply_ymd, min_qty)`.
- FK `dsc_typ_cd → t_cod_base_codes(cod_cd)`; FK `dsc_tbl_cd → t_dsc_discount_tables`.

| Check | 결과 | 근거 |
|-------|--------|----------|
| 타입/길이 — `dsc_rate` numeric(5,2) | PASS | 최대값 50.00 ≤ 999.99, 모두 ≤ 소수 2자리 |
| 타입 — `min_qty`/`max_qty` integer | PASS | 최대 10000 ≪ int32 |
| 길이 — `apply_ymd` varchar(10) | PASS | `2026-06-01` = 10자 (D-E 확정 형식) |
| NOT NULL — 필수 컬럼 | PASS | 16행 모두 dsc_tbl_cd, apply_ymd, min_qty 채워짐 |
| CHECK NAND — rate/amt 중 정확히 하나 | PASS | 16행 전부: `dsc_rate` 설정, `dsc_amt` 빈값. **둘-다-null 행 0개** (0% 밴드는 `0.00` 저장, NULL 아님 — 의미상 명시적, D7 참고) |
| FK `dsc_typ_cd` = `DSC_TYPE.01` | PASS | `DSC_TYPE.01` (정률) 존재, use_yn='Y' |
| CSV 내 PK 유일성 | PASS | 16/16 distinct `(tbl,ymd,min_qty)` |
| 구간 커버리지 (빈틈 없음) | PASS | ACR/POUCH/STAT 모두 1→10000 연속, 빈틈/중복 없음 |
| `apply_ymd` 포맷 | MINOR M3 참고 | varchar-date 컬럼에 DB 선례를 세울 기존 행이 없음; 포맷은 순수 설계 선택 (D2) |

**MINOR M3 (해소):** 당초 모든 할인/등급 테이블이 비어 있어 (0행) 포맷 선례가 없었고 잠정 `20260601`(YYYYMMDD, 8자)을 사용했으나, **D-E 확정으로 `2026-06-01`(yyyy-MM-dd, 10자) 채택** — DDL `varchar(10)` 및 comment와 정합. 전 적재 CSV 정정 완료. 설계 결정 D2로 흡수·확정.

---

## BOUNDARY 3 — 상품 링크 CSV ↔ 라이브 DB (최고 위험)

**적재 가능성 PASS; 범위 출처 발견 한 건 (M1, 비차단).**

| Check | 결과 | 근거 |
|-------|--------|----------|
| 70개 prd_cd 전부 `t_prd_products`에 존재 | **PASS — 70/70 존재, 누락 0** | `LEFT JOIN t_prd_products`가 NULL 미반환 |
| `dsc_tbl_cd` ∈ 3개 헤더 코드 | PASS | 모든 링크 행이 DSC_ACR_QTY / DSC_POUCH_QTY / DSC_STAT_QTY 사용 |
| PK 유일성 `(prd_cd,dsc_tbl_cd,apply_bgn_ymd)` | PASS | 70/70 distinct |
| 그룹 간 prd_cd 중복 | PASS | 두 테이블에 동시 등장하는 prd_cd 없음 (서로소 범위) |
| 카테고리 일치 — acrylic (12) 아크릴 CAT_000009 하위 | PASS | 12개 모두 CAT_000009 재귀 서브트리에서 도달 가능 |
| 카테고리 일치 — stationery (8) 문구 CAT_000008 하위 | PASS | 8개 모두 CAT_000008 재귀 서브트리에서 도달 가능 |
| 카테고리 일치 — pouch_eco (50) 에코백 CAT_000011 하위 | **PARTIAL → M1** | 41/50 CAT_000011에서 도달 가능; **9개는 불가** |

### 발견 M1 — MAJOR 심각도, NON-BLOCKING (범위 출처 / 카테고리 트리 무결성)

**pouch_eco 50개 상품 집합은 `mapping-spec.md §3`와 `target-keys.md`의 주장대로 CAT_000011 서브트리에서 재도출될 수 없다.**

근거:
- `CAT_000011` (에코백)의 재귀 순회 결과 정확히 **41개 distinct 상품 = PRD_000239–PRD_000279** (서브트리에 대한 `count(DISTINCT prd_cd)`)를 산출한다. 이는 파우치 = `PRD_000230..255`가 "에코백 CAT_000011 아래 중첩"이라고 단언하는 `target-keys.md`와 모순된다.
- 누락된 9개 상품 **PRD_000230–PRD_000238** (모두 "레더 … 파우치/클러치")는 카테고리 **`CAT_000305` (레더파우치)**에 붙어 있으며, 이 카테고리의 `upr_cat_cd IS NULL`이다 (고아 level-3 노드, `use_yn='Y'`). CAT_000305에 부모가 없으므로 CAT_000011 재귀 하강에서 — 그리고 어떤 level-1 루트에서도 — 도달할 수 없다.

이것이 **hard blocker가 아닌** 이유:
1. `t_prd_product_discount_tables`에는 **카테고리 FK가 없다** — `prd_cd → t_prd_products`와 `dsc_tbl_cd → t_dsc_discount_tables`뿐이다. 둘 다 50행 전부 충족 (모든 prd_cd 존재). 행은 삽입 가능하다.
2. 9개 상품은 실제 파우치이며 (`레더파우치` 카테고리, 이름 "레더 플랫 파우치" 등) `DSC_POUCH_QTY` 아래 포함하는 것이 "파우치+에코백 전체" 의도와 그럴듯하게 부합한다.

그럼에도 **MAJOR (사용자 확인 필요, D5와 연계)인** 이유:
- 명세가 명시한 도출 과정은 데이터로부터 검증 불가능하다. 설계자는 실제 서브트리 쿼리가 아닌 **조밀한 연속 범위**로 `PRD_000230..279`를 전개했다 (D5.1). 50개가 모두 존재하고 추가 9개가 전부 파우치라는 점에서 우연히 맞았을 뿐 — (연속이라 가정한) 방법이 도출이 아닌 운으로 정답을 만든 것이다. 만약 무관한 상품이 230–279 사이의 빈자리를 차지했다면 조용히 오연결되었을 것이다.
- 그 배후에 **스키마 데이터 품질 결함**이 있다: `CAT_000305 (레더파우치)`가 고아 (`upr_cat_cd` 없음)이므로, 공식 파우치 leaf 카테고리 `CAT_000213..221` (CAT_000011 아래 레더 플랫/슬림/삼각…)과 CAT_000305가 **중복/경쟁**하는 것처럼 보인다. 9개 레더 상품은 CAT_000011-부모 leaf가 아니라 고아 노드에 붙는다. 이는 할인 적재와 무관한 카테고리 트리 무결성 문제다 (스키마 소유자에게 라우팅).

권장 해소 (사용자/리드 결정, D5):
- **(a)** 9개 레더파우치 상품 (PRD_000230–238)이 파우치 할인 범위에 의도된 것인지 확인. 그렇다면 → 70개 링크 행 모두 유지 (현 CSV 그대로 OK). 아니라면 → 그 9행 제거 (→ 61개 링크 행).
- **(b)** 별도로, CAT_000305의 누락된 `upr_cat_cd`를 스키마 소유자에게 표시하여 향후 서브트리 기반 범위 해소가 신뢰 가능하도록 함. (할인 적재 작업 아님.)

---

## BOUNDARY 4 — 적재 순서 ↔ FK 그래프

**PASS.**

FK 그래프 (라이브 `pg_constraint` 기준):
- `t_dsc_discount_details.dsc_tbl_cd → t_dsc_discount_tables` (ON DELETE CASCADE)
- `t_dsc_discount_details.dsc_typ_cd → t_cod_base_codes` (존재: DSC_TYPE.01)
- `t_prd_product_discount_tables.dsc_tbl_cd → t_dsc_discount_tables`
- `t_prd_product_discount_tables.prd_cd → t_prd_products` (70개 전부 존재)

Mapping-spec §4 적재 순서 = `tables` (헤더) → `details` → `product_discount_tables`. 헤더는 두 자식보다 반드시 선행해야 한다 (둘 다 헤더로 FK); `t_cod_base_codes`와 `t_prd_products`는 사전 존재한다. 순서 정확. 테이블 2와 3 사이에는 FK가 없다 (어느 쪽이든 헤더 뒤에 올 수 있음).

---

## 테이블별 요약

| 대상 테이블 | B1 (xlsx) | B2 (schema) | B3 (live DB) | B4 (order) | 판정 |
|--------------|:---------:|:-----------:|:------------:|:----------:|:-------:|
| `t_dsc_discount_tables` (3) | n/a | PASS | PASS (PK/use_yn/len) | PASS | GO |
| `t_dsc_discount_details` (16) | PASS | PASS | PASS (FK/NAND/PK) | PASS | GO |
| `t_prd_product_discount_tables` (70) | n/a | PASS | PASS load / M1 scope | PASS | GO (D5 확인) |

---

## 분리: 설계 결정 (사용자 판단) vs 결함 (검증자 판단)

### 발견된 결함 (검증자 권한) — hard blocker
**없음.** FK 위반 0, 타입 오버플로 0, NOT NULL 위반 0, CHECK 위반 0, PK 충돌 0, 누락 prd_cd 0.

### 비차단 발견 (검증자 제기, 결정 필요)
- **M1 (MAJOR):** pouch_eco 범위 = 50에 고아 카테고리 CAT_000305 아래 9개 상품 포함; CAT_000011 서브트리에서 재도출 불가 (41 산출). 적재 가능; 의도된 범위 확인 (D5) + 카테고리 고아를 스키마 소유자에게 표시.
- **M2 (MINOR):** pouch_eco 범위 텍스트가 xlsx 제목을 넘어 보강됨. 출처 비고만.
- **M3 (MINOR):** `apply_ymd` 문자열 포맷에 대한 라이브 데이터 선례 없음 (모든 테이블 비어 있음). D2로 흡수.

### 설계 결정 — 검증자 판단 아님 (mapping-spec §5에서 이관, 미해소)
사용자에게 미루는 것이 옳음; 어느 것도 결함이 아님:
- **D1 — 요율 단위 PERCENT vs FRACTION** (적재는 퍼센트 `10.00` 저장). 최고 영향 확인 항목; 단위가 틀리면 조용히 100× 오가격.
- **D2 — 적용일 `2026-06-01`** ✅ 확정(D-E: yyyy-MM-dd). 전 CSV 정정 완료.
- **D3 — 최상위 구간 `max_qty=10000` 리터럴 vs 개방형 NULL** (`까지` 라벨은 sentinel/개방형 근거로 약함).
- **D4 — 구간 경계 포함** (런타임 의미; 변경할 저장값 없음).
- **D5 — pouch_eco 범위 = 50 (합집합)** — 위 M1과 직접 연계.
- **D6 — `dsc_tbl_cd` 자체 생성 코드** (`DSC_ACR_QTY` 등).
- **D7 — 0% 구간을 `dsc_rate=0.00`으로 저장** (NULL 아님).
- **D8 — note/name 범위 주석** (경미).

---

## 적재 가능성 결론

**GO.** 세 개 적재 CSV 모두 라이브 스키마에 대해 제약 무결하며 명시된 순서로 FK-safe하다; 70개 상품 전부 존재한다. 사용자가 8개 설계 결정을 확인한 **후** 적재 진행 (D1 요율 단위와 D5 파우치 범위가 출력을 실질적으로 바꾸는 두 항목). M1의 카테고리 고아 관찰은 스키마 소유자에게 라우팅해야 하지만 이번 적재를 차단하지는 않는다.
