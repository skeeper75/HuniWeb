# 봉투제작 (ENV) 가격 매핑 설계서 — round-2 (placeholder siz 해소)

**대상:** 봉투제작(ENV / envelope-making) 40 가격행이 의존하던 placeholder `SIZ_PENDING_ENV_*` 4종을 라이브 실제 siz_cd로 치환하여 ENV 적재 차단(blocker)을 닫는다.
**범위:** 설계 + 적재 CSV 산출만. **DB 쓰기·COMMIT·DDL 없음. 자가검증 없음**(검증은 dbm-validator 별도 책임).
**권위 출처:** 상품마스터 디지털인쇄 시트(`06_extract/digital-print-l1.csv` row_seq 244~248) = 작업사이즈 권위 / 가격표 봉투제작 시트(`06_extract/price-envelope-l1.csv`) = 단가·소재·수량 권위 / 라이브 `t_*` = 등록·존재·FK 권위.

---

## 1. 사용자 지시 검증 (재도출 아님, 확인만)

사용자 지시: "봉투 작업사이즈는 상품마스터 디지털인쇄 시트에 이미 있다 — 그걸로 siz를 등록/매칭하고, 가격표 봉투제작 시트 조건과 매칭하라."

### 1.1 상품마스터 디지털인쇄 시트 — 봉투제작 상품 (검증 완료)
`digital-print-l1.csv` row_seq 244~248, 상품명=**봉투제작**, ID `003-0015`, MES `22940`, 구분=인쇄홍보물.
사이즈(필수) 옵션 = 봉투 4종, 각 `파일사양_작업사이즈`(작업사이즈) 보유:

| 봉투종류 | 사이즈(필수) | 작업사이즈(WxH) | 기본 소재(마스터) | row_seq |
|---------|------------|----------------|------------------|---------|
| 티켓봉투 | 티켓봉투 | **225 x 193** | 모조 120g | 244 |
| 소봉투 | 소봉투 | **238 x 262** | 레자크체크백색 110g | 245 |
| 자켓봉투 | 자켓봉투 | **262 x 238** | 레자크줄무늬백색 110g | 246 |
| 대봉투 | 대봉투 | **510 x 387** | (미기재) | 247 |

row_seq 248 = "*파일재작업 후 주문" 주석행(사이즈 아님 — 제외). → 사용자 제시값과 **완전 일치**.

### 1.2 가격표 봉투제작 시트 (검증 완료)
`price-envelope-l1.csv` 블록 B01. 헤더: 봉투4종 × (모조 120g / 레자크체크백색=줄무늬 동일단가) 2소재 컬럼, 행 = 수량밴드 1000/2000/3000/4000/5000.
= 4 × 2 × 5 = **40 셀**. 앵커 검증: 티켓 1000개 모조 **96000** / 레자크 **111000**, 대봉투 1000개 모조 **134000** / 레자크 **152000** — 모두 일치.

> 주: 가격표 헤더의 `band_header_path`는 모든 봉투종류 열을 "모조 120g"으로 라벨링하나, 실제로는 각 봉투종류마다 모조열 + 레자크열 2컬럼이 존재(C/E/G/I 열이 레자크). 마스터의 봉투별 "기본 소재"와 무관하게 가격표는 **모든 봉투종류에서 두 소재 단가를 모두 제공**한다(작업사이즈는 봉투종류로만 결정, 소재는 단가 차원).

---

## 2. 봉투종류 → siz_cd 해소 (search-before-mint)

라이브 `t_siz_sizes`(500행)에 대해 각 작업사이즈 WxH를 EXACT + REVERSED로 read-only 조회.

### 2.1 결과: 4종 전부 라이브 EXACT 매치 존재 — 신규 mint 0

| placeholder | 봉투종류 | 작업사이즈 | 라이브 siz_cd | siz_nm | work_width×height | 판정 |
|-------------|---------|-----------|--------------|--------|-------------------|------|
| `SIZ_PENDING_ENV_TICKET` | 티켓봉투 | 225×193 | **`SIZ_000191`** | `225x193` | 225.00 × 193.00 | EXACT 재사용 |
| `SIZ_PENDING_ENV_SMALL`  | 소봉투 | 238×262 | **`SIZ_000192`** | `238x262` | 238.00 × 262.00 | EXACT 재사용 |
| `SIZ_PENDING_ENV_JACKET` | 자켓봉투 | 262×238 | **`SIZ_000193`** | `262x238` | 262.00 × 238.00 | EXACT 재사용 |
| `SIZ_PENDING_ENV_LARGE`  | 대봉투 | 510×387 | **`SIZ_000194`** | `510x387` | 510.00 × 387.00 | EXACT 재사용 |

조회 SQL(read-only, 비밀번호 미출력):
```sql
SELECT siz_cd, siz_nm, work_width, work_height, impos_yn, use_yn, del_yn
FROM t_siz_sizes
WHERE (work_width, work_height) IN ((225,193),(193,225),(238,262),(262,238),(510,387),(387,510))
   OR siz_nm IN ('225x193','238x262','262x238','510x387', ...);
```
→ 4종 모두 `impos_yn=N, use_yn=Y, del_yn=N`. **mint 불요. siz 채번(`SIZ_000775`+) 미발생** → 면적매트릭스(`SIZ_000511~721`)·박(`SIZ_000722~774`)과의 충돌 가능성 원천 부재.

### 2.2 자켓봉투(262×238) vs 소봉투(238×262) WxH 역전 결정 — **distinct 유지 (FLAG-A)**

두 봉투의 작업사이즈는 정확히 W×H 역전 관계다. 그러나 **라이브 DB 자체가 이미 두 사이즈를 별도 siz로 보유**한다: `SIZ_000192`(238×262, 소봉투) ≠ `SIZ_000193`(262×238, 자켓봉투). 즉 후니 마스터데이터가 봉투의 방향성(가로형/세로형)을 의미축으로 보존하고 있으며, 봉투는 단가도 동일하지만 **봉투종류라는 고유 제품 정체성**(소봉투 ≠ 자켓봉투)이 있어 collapse가 부적절하다.

- **결정: 역전 두 사이즈를 각각 distinct siz로 매핑(SIZ_000192 / SIZ_000193). collapse 안 함.**
- **근거:** 라이브 권위가 이미 distinct. 박(foil) 면적형이 방향무관으로 REVERSED siz를 수렴시킨 것(FLAG-1)과 대조적 — 봉투는 면적함수가 아니라 봉투종류 식별이 1차이므로 별칭 수렴이 의미를 훼손한다. 발명 없이 라이브 그대로 채택.

---

## 3. 40행 치환 결과 (G7 무손실)

`02_mapping/load_price/t_prc_component_prices.csv` 내 `siz_cd LIKE 'SIZ_PENDING_ENV_%'` 40행(comp_price_id 1713~1752)에 대해:
- `siz_cd`: placeholder → 위 §2.1 실제 siz_cd로 치환.
- `note`: 접두 `[siz: ENV_종류→SIZ_xxx] ` 추가(추적성). 기존 노트(레자크=줄무늬 동일단가 등) 보존.
- `comp_cd`(COMP_ENV_MAKING)·`mat_cd`·`min_qty`·`unit_price`·`apply_ymd`(2026-06-01)·`comp_price_id` = **verbatim 보존**.

산출: `02_mapping/load_price/t_prc_component_prices_ENV.csv` (40행, 헤더=DB 컬럼명).

무손실 집계:
- siz별: SIZ_000191 / 192 / 193 / 194 각 10행 (= 2소재 × 5수량).
- 소재별: MAT_000159 20행 / MAT_000168 20행.
- 수량밴드별: 1000/2000/3000/4000/5000 각 8행 (= 4봉투 × 2소재).
- distinct 자연키(comp_cd, apply_ymd, siz_cd, mat_cd, min_qty) = **40** (중복 0).
- residual placeholder = **0**.

CSV 컬럼별 매핑:

| 컬럼 | 값 | 출처/근거 |
|------|-----|----------|
| `comp_price_id` | 1713~1752 | 기존 placeholder 행 ID 보존(라이브 max=4805와 무충돌) |
| `comp_cd` | `COMP_ENV_MAKING` | 라이브 선존재(§4) |
| `apply_ymd` | `2026-06-01` | 규칙7 표준 go-live 일자 |
| `siz_cd` | `SIZ_000191~194` | §2.1 EXACT 재사용 |
| `clr_cd` | (공란=NULL) | 봉투제작=완제품가, 도수 차원 없음 |
| `mat_cd` | `MAT_000159` / `MAT_000168` | 소재 차원(모조 / 레자크 대표) |
| `coat_side_cnt` | (공란=NULL) | 코팅 차원 없음 |
| `bdl_qty` | (공란=NULL) | 묶음 차원 없음 |
| `min_qty` | 1000/2000/3000/4000/5000 | 수량밴드(가격표 행) |
| `unit_price` | 가격표 셀값 verbatim | 가격표 봉투제작 시트 |
| `note` | `[siz: ENV_종류→SIZ_xxx]` + 원노트 | 추적성 |

> 공란=NULL 규약(round-2 표준). `unit_price`는 DB scale 정수 그대로.

---

## 4. 공식·바인딩·코드행 상태 (라이브 검증 결과)

봉투제작은 완제품가(`PRC_COMPONENT_TYPE.06`) 단일 구성요소 룩업형이다. 엔진 4단이 이미 라이브에 전부 배선되어 있으며, **유일한 미적재 구간이 component_prices의 siz 채움**이었다.

| 엔진 요소 | 라이브 상태 | 조치 |
|----------|------------|------|
| `t_prc_price_components.COMP_ENV_MAKING` | **선존재** (comp_nm=`봉투제작 완제품가`, comp_typ_cd=`PRC_COMPONENT_TYPE.06`, use_yn=Y) | 없음 (FK 부모 확인) |
| `t_cod_base_codes.PRC_COMPONENT_TYPE.06` | **선존재** (cod_nm=완제품비, use_yn=Y) | 없음 (**코드행 INSERT 불요**) |
| `t_prc_price_formulas.PRF_ENV_MAKING` | **선존재** (frm_nm=`봉투제작 소재/수량별 단가`, frm_typ_cd=`FRM_TYPE.02`) | 없음 |
| `t_prc_formula_components` (PRF_ENV_MAKING ↔ COMP_ENV_MAKING) | **선존재** | 없음 |
| `t_prd_products.봉투제작` | **선존재** = `PRD_000050` (prd_typ_cd=`PRD_TYPE.04`, use_yn=Y) | 없음 (실 prd_cd 발견, 발명 아님) |
| `t_prd_product_price_formulas` (PRD_000050 → PRF_ENV_MAKING) | **선존재** (apply_bgn_ymd=2026-06-01) | **없음 (바인딩 INSERT 불요)** |
| `t_mat_materials.MAT_000159` / `MAT_000168` | **선존재** (모조 120g / 레자크체크백색 110g, use_yn=Y) | 없음 (FK 부모 확인) |
| `t_prc_component_prices` (COMP_ENV_MAKING 단가) | **라이브 0행** | **본 트랙 40행 적재 대상** |

### 4.1 바인딩 상태 = FOUND (FLAG 아님)
라이브 `t_prd_product_price_formulas`의 PRD_000050 행 note가 명시:
> "봉투제작→소재/수량별 단가 공식. **봉투종류(티켓/소/자켓/대) siz_cd 후니 등록 후 component_prices siz 채움**"

즉 바인딩은 이미 걸려 있고, 라이브 노트가 정확히 본 트랙(siz 채움)을 예고하고 있었다. **신규 바인딩 행 불요.** → `t_prd_product_price_formulas_ENV.csv`는 의도적으로 비움(설명 주석만).

### 4.2 코드행 필요 = 없음
`.06 완제품비`·`FRM_TYPE.02`·`COMP_ENV_MAKING` 전부 라이브 선존재 → **코드행 INSERT 0건**. (과거 schema-fitgap의 ".06 신설 필요"는 stale — 이미 등록됨.)

### 4.3 소재 매핑 보존
레자크체크백색 110g(MAT_000168) = 레자크줄무늬백색 110g 동일단가 → 가격표가 두 소재를 한 컬럼으로 묶었고, 기 평면화에서 **MAT_000168 대표로 collapse** 완료. 본 트랙은 그 결정을 verbatim 보존(note의 `[레자크체크=줄무늬 동일단가, mat=MAT_000168 대표]` 유지).

---

## 5. 적재 순서 (FK 위상정렬) — 참고

```
[0] (검증만, 선존재) t_siz_sizes(SIZ_000191~194) · t_mat_materials(MAT_000159/168)
    · t_prc_price_components(COMP_ENV_MAKING) · t_prc_price_formulas(PRF_ENV_MAKING)
    · t_prc_formula_components · t_prd_products(PRD_000050)
    · t_prd_product_price_formulas(PRD_000050→PRF_ENV_MAKING) · t_cod_base_codes(.06)
[1] t_prc_component_prices  ← 본 트랙 40행 (모든 FK 부모 선존재)
```
ENV는 FK 부모가 전부 라이브에 있어 **자식 1테이블(component_prices)만 적재**하면 닫힌다.

---

## 6. FLAG — 결정/확인 필요 (침묵 처리 금지)

| # | 항목 | 내용 | 권고 |
|---|------|------|------|
| **FLAG-A** | 자켓/소봉투 WxH 역전 | 238×262(소봉투, SIZ_000192) vs 262×238(자켓봉투, SIZ_000193) = W×H 역전. 라이브가 이미 distinct siz로 보유 → distinct 유지 채택. 봉투종류 정체성 보존 목적. | distinct 채택. 후니가 두 봉투를 한 siz로 통합하길 원하면 재논의(단가 동일이라 통합해도 가격 영향 0) |
| **FLAG-B** | 봉투별 기본소재 vs 가격표 2소재 | 마스터는 봉투마다 기본소재 1개(티켓=모조 / 소·자켓=레자크) 제시하나 가격표는 전 봉투에 2소재 단가 제공. component_prices는 가격표 권위로 2소재 전건 적재(40행). | 가격표 권위 채택(엑셀 명시값). 마스터 기본소재는 옵션 기본값일 뿐 단가 제약 아님 |

> 두 FLAG 모두 **적재 차단 아님** — 데이터는 라이브 권위/엑셀 권위로 결정 완료. 후니 도메인 의미 재확인용 surface일 뿐.

---

## 7. 적재 준비 진술 (검증 아님)

봉투제작 ENV 가격 매핑은 **적재 준비 완료** 상태다: placeholder siz 4종 → 라이브 EXACT siz(SIZ_000191~194) 전건 해소, 40 component_prices 행 무손실 치환(4×2×5, residual 0), 모든 FK 부모(siz·mat·comp·formula·product·바인딩·코드행) 라이브 선존재 확인, 신규 mint·신규 바인딩·신규 코드행 **0건**. 자연키 중복 0, comp_price_id 라이브 max(4805) 무충돌.

**무손실·정합·적재가능성의 독립 재계산 검증은 dbm-validator 책임이며 본 설계는 자가검증하지 않는다.**

---

## 산출물

| 파일 | 내용 |
|------|------|
| `02_mapping/price-envelope-mapping.md` | 본 설계서 |
| `02_mapping/load_price/t_prc_component_prices_ENV.csv` | 40 ENV 단가행(siz 해소 완료, 헤더=DB 컬럼명) |
| `02_mapping/load_price/t_prd_product_price_formulas_ENV.csv` | 빈 CSV(바인딩 라이브 선존재 — 주석으로 설명) |
