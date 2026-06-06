# 적재 매니페스트 — round-4 가격(price, t_prc_*) (실행=인간 승인 대상, 본 하네스는 산출까지)

> 가격 매핑(round-2)의 검증 GO 산출물을 라이브 `railway` DB 적재용 t_prc_* 번들로 조립한 결과.
> 본 문서는 "이 파일들을 이 순서로 실행하라"는 실행계획이다. **실제 INSERT·DDL은 인간 승인 대상**(권위 `docs/goal-2026-06-06-01.md`).
> 검증 인계용 — `dbm-load-builder`가 조립, `dbm-validator`가 G1~G9 + DRY-RUN으로 게이트(자기승인 금지).

작성: dbm-load-builder · 입력 권위: `03_validation/price-load-validation-final.md`(GO) · `02_mapping/load_price/*.csv` · `02_mapping/scripts/transform_price_sheets.py`(평면화) · `09_load/_assembled_price/assemble_price_bundle.py`(조립·재현 G8) · 라이브 DB read-only(FK 확증). 식별자/컬럼/SQL 영어, 설명 한국어.

---

## 0. 한 줄 현황

가격 6테이블 중 **t_prc_* 5테이블 + 코드행 1**을 FK 위상정렬로 조립. **즉시 적재가능 2,320행**(코드행 1 + 공식 10 + 구성요소 143 + 배선 13 + 단가 **2,108** + 상품바인딩 45) / **차단 2,697행**(component_prices placeholder siz_cd, 후니 siz 등록 대기) / **GAP 1건**(박 시트 2단 룩업). 침묵드롭 0 — (적재 2,108 + 차단 2,697 = 원본 4,805) 정확 재구성.

---

## 1. t_* 화이트리스트 검증 (G1)

조립 대상 6테이블 전건 화이트리스트 내. 비-t_* 적재행 **0건**.

| 대상 테이블 | 화이트리스트 분류 | 판정 |
|------------|------------------|------|
| `t_cod_base_codes` | master-reference (코드행 선적재만) | OK |
| `t_prc_price_formulas` | price (t_prc_*) | OK |
| `t_prc_price_components` | price (t_prc_*) | OK |
| `t_prc_formula_components` | price (t_prc_*) | OK |
| `t_prc_component_prices` | price (t_prc_*) | OK |
| `t_prd_product_price_formulas` | price-product link (t_prd_*) | OK |

`t_prd_product_prices`(상품직접단가)는 round-2에서 **미신설 정당**(사이즈/수량 변동 → component 차원, 규칙④ — HANDOFF §3) → 본 번들 미산출. Django/비-t_* 대상 없음.

---

## 2. 적재 순서 (FK 위상정렬)

라이브 FK 엣지를 read-only로 조회해 위상정렬(부모→자식). 확인된 FK 엣지(라이브):
`t_prc_price_components.comp_typ_cd → t_cod_base_codes` · `t_prc_price_formulas.frm_typ_cd → t_cod_base_codes` · `t_prc_formula_components.{frm_cd→price_formulas, comp_cd→price_components}` · `t_prc_component_prices.{comp_cd→price_components, siz_cd→t_siz_sizes, clr_cd→t_clr_color_counts, mat_cd→t_mat_materials}` · `t_prd_product_price_formulas.{prd_cd→t_prd_products, frm_cd→price_formulas}`.

| 단계 | 대상 t_* 테이블 | 소스 CSV | 적재 행수 | 이 위치를 강제하는 FK 엣지 |
|------|----------------|----------|----------|---------------------------|
| 00 | `t_cod_base_codes` | `load/00_prc_component_type.csv` | 1 | 코드 선적재 — `price_components.comp_typ_cd → t_cod_base_codes`(.06 완제품비 91 comp가 의존) |
| 01 | `t_prc_price_formulas` | `load/01_prc_price_formulas.csv` | 10 | `frm_typ_cd → t_cod_base_codes`(FRM_TYPE .01/.02 라이브 실존) — 공식 헤더, 자식보다 선행 |
| 02 | `t_prc_price_components` | `load/02_prc_price_components.csv` | 143 | `comp_typ_cd → t_cod_base_codes`(.01~.05 라이브 + .06 단계00) — 구성요소 카탈로그 |
| 03 | `t_prc_formula_components` | `load/03_prc_formula_components.csv` | 13 | `frm_cd → price_formulas`(01) · `comp_cd → price_components`(02) |
| 04 | `t_prc_component_prices` | `load/04_prc_component_prices.csv` | 2,108 | `comp_cd → price_components`(02) · `siz_cd → t_siz_sizes` · `clr_cd → t_clr_color_counts` · `mat_cd → t_mat_materials`(전건 라이브 실존) |
| 05 | `t_prd_product_price_formulas` | `load/05_prd_product_price_formulas.csv` | 45 | `prd_cd → t_prd_products`(45/45 라이브) · `frm_cd → price_formulas`(01) |

순서 정합: 00 → 01 → 02 → 03 → 04 → 05 가 모든 FK 의존을 충족(사이클·미해결 부모 0). 단계 01·02는 상호 독립(둘 다 단계00 코드만 의존)이라 병렬 가능하나, 매니페스트는 결정적 순서로 직렬화.

### FK 부모 라이브 확증 (read-only SELECT)

| FK 부모 | 적재본 distinct | 라이브 실존 | 판정 |
|---------|----------------|------------|------|
| `t_siz_sizes.siz_cd` (실코드) | 99 | 99/99 | OK |
| `t_mat_materials.mat_cd` (insertable) | 10 | 10/10 | OK |
| `t_clr_color_counts.clr_cd` | 2 (CLR_000002·000005) | 2/2 | OK (단 insertable distinct 0 — 전건 clr 공란, CLR_000002/000005는 **차단 행에만** 출현 → 차단 해소 후 적용) |
| `t_prd_products.prd_cd` (상품바인딩) | 45 | 45/45 | OK |
| `t_cod_base_codes` PRC_COMPONENT_TYPE.01~.05 | — | 5/5 실존 | OK |
| `t_cod_base_codes` PRC_COMPONENT_TYPE.06 | 1 | **0 (부재)** | 단계00 코드 선적재 대상 |
| `t_cod_base_codes` FRM_TYPE.01/.02 | — | 라이브 실존 | OK |

---

## 3. 적재 분류 집계 (G7 — 침묵드롭 0)

### 3-1. 테이블별 즉시 적재가능 행수

| 단계 | 테이블 | 즉시 적재가능 | 차단 | GAP |
|------|--------|--------------|------|-----|
| 00 | t_cod_base_codes (코드행 선적재 제안) | 1 | — | — |
| 01 | t_prc_price_formulas | 10 | 0 | — |
| 02 | t_prc_price_components | 143 | 0 | — |
| 03 | t_prc_formula_components | 13 | 0 | — |
| 04 | t_prc_component_prices | **2,108** | **2,697** | 박 시트(별도, 미산출) |
| 05 | t_prd_product_price_formulas | 45 | 0 | — |
| **합계** | — | **2,320** | **2,697** | 1건 |

### 3-2. component_prices 4,805행 분류 (재구성 정합)

- **즉시 적재가능: 2,108행** = 실코드 siz_cd 1,313 + NULL(공란) siz_cd 795. FK siz/mat/clr 전건 라이브 실존 확증.
- **차단(후니 siz 등록 대기): 2,697행** = siz_cd가 `SIZ_PENDING%` placeholder → `blocked-and-gaps.md` §A(7군).
- **GAP(무손실 표현 불가): 1건** = 박(소형/대형) 시트 2단 룩업 → `blocked-and-gaps.md` §B. component_prices 4,805행에 **미포함**(박 시트 자체 0행 산출 — 억지평면화 0).
- **재구성**: 2,108 + 2,697 = **4,805** (정확). 침묵드롭·발명 0.

### 3-3. 코드행 선적재 제안: 1건

- `PRC_COMPONENT_TYPE.06 완제품비` → `code-row-preload.md` + `load/00_prc_component_type.csv`. 라이브 미등록(.05까지만), **후니 등록 대상**(DDL 무변경 코드행 INSERT).

---

## 4. 제약·무결성 점검 (조립 시점 self-check, 게이트는 validator)

| 점검 | 결과 | 근거 |
|------|------|------|
| comp_cd varchar(50) 초과 | **0건** | 적재본 component_prices·price_components 최장 **41자**. round-2 검증-final의 B-FINAL-1(55자 2종)은 **현 CSV에서 해소 확증**(HANDOFF §1 단축 반영, `..._GAKMOK_*` 계열). |
| 고아 comp_cd (적재본 component_prices) | **0건** | 적재본 141 distinct comp_cd 전건 price_components(143) 정의 내 |
| t_* 화이트리스트 외 대상 | **0건** | §1 |
| FK 부모 부재 (실코드 차원) | **0건** | §2 라이브 확증 |
| 차단/적재 행수 재구성 | **정합** | 2,108 + 2,697 = 4,805 |

> [정직 표기] B-FINAL-1 길이초과는 round-2 검증 시점 BLOCKER였으나 현 CSV에는 부재(maxlen 41). validator는 이 사실(검증-final 2,106 vs 현 적재본 2,108 = +2 길이초과 해소분)을 G4에서 독립 확인 요망.

> [G4 스키마 권위 주석] G4 스키마 적합 검증의 권위는 **라이브 DDL**(`00_schema/price-engine-ddl-raw.txt`)이다. `00_schema/columns.csv`는 가격엔진 신설 이전 12 t_테이블 스냅샷이라 **t_prc_* 미수록(stale)** — 차후 재추출 권장(본 트랙에서는 재추출하지 않음, 별도 작업).

---

## 5. 재현·프로비넌스 (G8)

- **추출(L1)**: `06_extract/scripts/{profile_price_sheets,extract_price_sheets}.py` → `06_extract/price-<slug>-l1.csv`(15종, 무손실 9게이트 PASS).
- **변환(평면화)**: `02_mapping/scripts/transform_price_sheets.py` → `02_mapping/load_price/*.csv`.
- **조립(본 번들)**: `09_load/_assembled_price/assemble_price_bundle.py` → `load/<NN>_*.csv`. 동일 입력 → 동일 출력(idempotent). 적재본 각 행은 `02_mapping/load_price/` 동명 CSV의 해당 행에서 **컬럼·값 무변환 복사**(조립=순서/분류/제외만, 매핑 재도출 없음).
- **행 단위 프로비넌스**: component_prices 적재본 2,108행 = 원본 4,805행 중 `siz_cd NOT LIKE 'SIZ_PENDING%'`인 행. 차단 2,697행 = 원본 중 `SIZ_PENDING%`. 원본↔적재본은 `comp_price_id`(surrogate PK)로 1:1 추적 가능.

---

## 6. 검증 인계

- **입력**: 본 매니페스트 + `load/00~05_*.csv` + `code-row-preload.md` + `blocked-and-gaps.md`.
- **게이트**: dbm-validator가 G1~G9 + (lead 승인 시) 롤백전용 DRY-RUN → `03_validation/load-readiness-gate.md`에 PASS/FAIL + GO/NO-GO.
- **에스컬레이션 대상**(사용자 결정 — 본 하네스 권한 밖): ① 코드행 선적재 1건(후니 등록) ② 차단 2,697행 siz 등록 7군(후니 등록) ③ 박 GAP 모델링(후니 결정) ④ 실제 INSERT 실행(인간 승인).
