# 매핑 설계서 — 실사(silsa) / 포스터사인 면적매트릭스 가격 (price-211 Phase-1)

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 트랙 | price-211 Phase-1, 면적매트릭스(area-matrix) 전용 |
| 권위 순서 | 라이브 DDL/존재 > 가격표 엑셀 명시값 > `06_extract` L1 스냅샷 > 설계 |
| 가격 DDL 권위 | `00_schema/price-engine-ddl.md` (컬럼명/타입/C-1~C-9) |
| 검증 | 본 문서는 **생성**. 독립 재검증(dbm-validator)은 별도 단계 |

> ## [HARD · USER RULE 적용 — 절대 준수]
> 상품마스터 **실사** 시트 상품의 가격은 실사 시트 inline price 컬럼
> (`R=price`, `S==SUM(R)*1.1` VAT, `V=가공가`)을 권위로 쓰지 **않았다**.
> 가격 권위 = 인쇄상품 가격표 **"포스터사인"** 시트(`06_extract/price-poster-sign-l1.csv`)의
> **[가로(col) × 세로(row)] 면적매트릭스 셀단가(코팅포함가)**.
>
> **적용 방법(HOW)**:
> 1. 포스터사인 면적매트릭스 블록(B01~B11 포스터 11 + B26~B27 현수막 2)의
>    셀 687개를 long-form `(comp_cd, siz_cd=치수, unit_price)` 으로 평면화.
> 2. 각 (가로,세로) → `siz_cd`(치수조합) 차원. clr/mat/coat/bdl/min = **NULL**(면적매트릭스는
>    도수·자재·코팅면·묶음·수량 무관, 코팅포함 통가격).
> 3. 실사 시트는 **prd_cd 해소(상품명→prd_cd)**에만 사용. 가격값은 실사에서 가져오지 않음.
> 4. off-grid(매트릭스 부재 치수) = 한 단계 큰 치수 ceiling = **앱 런타임 계산, DB는 룩업행만**.
>
> **[round-2 오모델링 전철 금지 — 적발·정정]**: round-2 는 28 포스터상품을 단일 공식
> `PRF_POSTER_FIXED` 에 묶고, 면적매트릭스 11상품 각각을 **1~2개 sparse 대표셀**(예
> 아트프린트포스터=600×1800 한 셀)로만 적재했다. 전체 [가로×세로] 매트릭스(상품당
> 39~80셀)를 잃었다. 본 트랙은 **명시 매트릭스 셀 전건 + ceiling** 으로 정정한다.
> **R² 면적-좌표 회귀 함수 미사용**(후니 권위공식 = 매트릭스 룩업).

---

## 1. SCOPE & STATUS — 실사 ↔ 포스터사인 ↔ 라이브 (read-only 실측)

### 1.1 실사 시트 상품 (29 distinct)
`06_extract/silsa-l1.csv` 115행 → 29 distinct 상품. 그중 **면적매트릭스형 13상품**이 본 트랙
대상(포스터사인 면적매트릭스 블록 보유). 나머지 16상품 = **고정가형(수량×옵션)** → 본 트랙
밖(§5).

### 1.2 면적매트릭스 블록 ↔ 상품 ↔ prd_cd ↔ comp_cd (전수 매핑, 라이브 검증)

| block | 상품 | prd_cd | comp_cd | cells | INSERTABLE | BLOCKED | 가격범위(원) |
|---|---|---|---|--:|--:|--:|---|
| B01 | 아트프린트포스터 | PRD_000118 | `COMP_POSTER_ARTPRINT_PHOTO` | 52 | 1 | 51 | 12,000~72,000 |
| B02 | 아트페이퍼포스터 | PRD_000119 | `COMP_POSTER_ARTPAPER_MATTE` | 39 | 2 | 37 | 12,000~54,000 |
| B03 | 방수포스터 | PRD_000120 | `COMP_POSTER_WATERPROOF_PET` | 52 | 1 | 51 | 12,000~72,000 |
| B04 | 접착방수포스터 | PRD_000121 | `COMP_POSTER_ADH_WATERPROOF_PVC` | 52 | 1 | 51 | 12,000~72,000 |
| B05 | 접착투명포스터 | PRD_000122 | `COMP_POSTER_ADH_CLEAR_PVC` | 52 | 1 | 51 | 16,000~198,000 |
| B06 | 아트패브릭포스터 | PRD_000123 | `COMP_POSTER_ARTFABRIC_GRAPHIC` | 52 | 1 | 51 | 12,000~72,000 |
| B07 | 린넨패브릭포스터 | PRD_000124 | `COMP_POSTER_LINEN_FABRIC` | 52 | 1 | 51 | 17,000~108,000 |
| B08 | 캔버스패브릭포스터 | PRD_000125 | `COMP_POSTER_CANVAS_FABRIC` | 52 | 1 | 51 | 19,000~126,000 |
| B09 | 레더아트프린트 | PRD_000126 | `COMP_POSTER_LEATHER_ARTPRINT` | 52 | 1 | 51 | 19,000~126,000 |
| B10 | 타이벡프린트 | PRD_000127 | `COMP_POSTER_TYVEK_PRINT` | 52 | 1 | 51 | 19,000~126,000 |
| B11 | 메쉬프린트 | PRD_000128 | `COMP_POSTER_MESH_PRINT` | 52 | 1 | 51 | 19,000~126,000 |
| B26 | 일반현수막 | PRD_000138 | `COMP_POSTER_BANNER_NORMAL` | 80 | 3 | 77 | 8,000~72,000 |
| B27 | 메쉬현수막 | PRD_000139 | `COMP_POSTER_BANNER_MESH` | 48 | 2 | 46 | 20,000~120,000 |
| **합계** | **13상품** | | **13 comp** | **687** | **17** | **670** | |

매핑 방식 = **상품명 1:1** (block_title 접두 ↔ 상품명 ↔ 라이브 prd_nm). 동명/변형 충돌 0.

### 1.3 라이브 바인딩 상태 분류 (적대적 점검)

라이브 실측: 13 상품 **전부 `n_formula_bind=1, n_direct_price=0`** — 즉 모두 round-2 에서
`PRF_POSTER_FIXED` 에 바인딩 완료. **UNPRICED 0건.**

| 분류 | 정의 | 본 트랙 해당 | 행동 |
|------|------|:--:|------|
| (i) UNPRICED | 바인딩·단가 둘 다 없음 | **0** | — |
| (ii) ALREADY-PRICED + round-2 면적-좌표 mis-modeled | 바인딩 존재하나 매트릭스 sparse(1~2셀)로 적재 | **13** | **CORRECTION+EXPANSION**(전체 매트릭스 적재) |
| (iii) ALREADY-PRICED correctly | 매트릭스 전건 정확 적재 | **0** | — |

**핵심 적발**: 13상품은 "가격 있음"으로 보이나 실은 매트릭스의 **2~6%만 적재됨**
(예 B01=1/52, B26=3/80). 무가격(211 정의: 바인딩·직접가 0)은 아니지만 **사실상 미가격**
(거의 모든 치수 조회 불가). round-2 의 면적-좌표 sparse 모델링이 그 원인 — USER RULE 이
정정하라는 바로 그 전철. (참고: round-2 면적-좌표 sparse 적재 = `COMP_POSTER_ARTPRINT_PHOTO`
단가행 1개 `SIZ_000321=21600`, comp_price_id=4045.)

---

## 2. MATRIX EXTRACTION → component_prices long-form

### 2.1 매트릭스 셀 구조 (B01 예시, 검증됨)
포스터사인 면적매트릭스 블록 = `[가로(열) × 세로(행)]` 2D 격자.
- **열 헤더(row 2)**: 가로(width) = 600/800/1000/1200mm (B02 는 600/800/900).
- **행 헤더(col A, row 3+)**: 세로(height) = 600/800/.../3000mm.
- **본문 셀**: 해당 (가로, 세로)의 단가 = `value` 컬럼 (예 B3=12000, D3=20000, E15=72000).
  **코팅포함가**(코팅비 별도 분해 불요, 규칙④ 합가 그대로).

### 2.2 band_header_path vs value (권위 판정)
L1 추출의 `band_header_path` 는 각 열의 **전체 가격 사다리**(예
`600mm > 12000.0 > 20000.0 > ...`)를 중복 echo 한다. **권위 셀단가 = `value` 컬럼**이며,
band ladder 첫 단가와 일치함을 검증(B3 value=12000 == ladder `600mm > 12000.0 ...`). 본
매핑은 `value` 만 사용.

### 2.3 비대칭성 (가로≠세로 주의)
매트릭스는 **대칭이 아니다** — (600,1000)≠(1000,600). 따라서 (가로, 세로)를 단일 "면적"
스칼라로 합치면 안 된다(round-2 의 면적-좌표 오모델 함정). 각 **순서쌍 (가로, 세로)이
고유 셀**이며 고유 siz_cd 차원으로 적재. (예 B01 B5=20000[가600×세1000] vs D3=20000[가1000×세600]
은 우연 동일이나 다른 셀.)

### 2.4 평면화 결과
687 본문 셀 → 687 long-form `(comp_cd, 가로, 세로, unit_price)` 행. provenance =
`price-poster-sign-l1.csv:{block_id}:{cell_ref}`. 자연키 중복 0(C-2).
F1/F5/G247 등 stray 주석셀(`1000x1000 : 20000`)·현수막 사이드바(J~N 가공/추가옵션)는
**매트릭스 셀 아님 → 제외**(가공/추가옵션은 round-6 CPQ 옵션레이어 소관).

---

## 3. siz_cd RESOLUTION (search-before-mint)

각 (가로, 세로) 셀은 `siz_cd` 차원 필요. **라이브 t_siz_sizes 우선 검색**(cut 또는 work
치수 일치). 미존재 시 **발명 금지 → BLOCKED 선적재 후보**.

| 구분 | dim 수 | 처리 |
|------|:--:|------|
| 라이브 siz 존재 | **4** | INSERTABLE (SIZ_000320 900×1200 · SIZ_000321 600×1800 · SIZ_000323 900×900 · SIZ_000403 1500×1000) |
| 라이브 siz 부재 | **108** | BLOCKED → `load/t_siz_sizes_BLOCKED.csv` (제안 SIZ_000511~000618) |

검색 결과: **112 dim 중 4만 존재**(round-2 가 sparse 적재 때 등록한 그 4). 나머지 108
(600×600 ~ 1750×5000)은 대형 출력 치수로 미등록. **siz 채번은 후니 인간승인 사항** — 제안
코드는 `{가로}x{세로}` 명명(round-2 선례 `600x1800`/`900x1200` 와 동일 컨벤션). max siz =
SIZ_000510 → 제안 SIZ_000511+.

> [HARD] siz 발명 금지. BLOCKED 670 component_price 행은 siz 적재 전 적재 불가.
> 침묵 드롭하지 않고 `_BLOCKED.csv` 로 명시 분리(over/under-block 0).

---

## 4. FORMULA + BINDING 설계

### 4.1 공식 (라이브 선존재 — 신규 mint 불요)
- `frm_cd = PRF_POSTER_FIXED` (라이브 존재). `frm_typ_cd = FRM_TYPE.02`(단순형).
- 의미 = "포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)".
- **면적매트릭스는 FRM_TYPE.01/.02 + siz_cd 차원으로 흡수**(price-engine-ddl §6 G-3:
  신규 FRM 코드 불요). 판매가 = `component_prices[comp_cd, siz_cd=치수]` 단일 룩업
  (코팅포함 통가격) → 단순형 1-component 구조로 표현 가능.
- [설계결정 D-FRM] round-2 가 FRM_TYPE.02(단순형)을 썼다. 면적매트릭스는 "단일 셀 룩업"
  이라 단순형이 의미상 정합(합산 항목 없음, 통가격). USER RULE 이 언급한 "FRM_TYPE.01
  합산형 + siz 차원"도 가능하나, **라이브 공식 변경은 본 트랙 범위 밖**(공식 신규 mint 없음).
  → 라이브 FRM_TYPE.02 유지(권위 = 라이브). 검증단계에서 .01 vs .02 의미 확정 권고.

### 4.2 구성요소 (라이브 선존재)
- comp_cd 13종 모두 라이브 존재. `comp_typ_cd = PRC_COMPONENT_TYPE.06 완제품비`
  (코팅·인쇄로 분해 안 되는 통가격, C-6/규칙⑩). clr_cd 미사용(별색=공정, G-1 무관).

### 4.3 공식↔구성요소 배선 — **[정정 2026-06-07 D-WIRE: 과잉주장 적발]**
- ~~`t_prc_formula_components` (PRF_POSTER_FIXED ↔ 13 comp_cd) 라이브 확인됨. 신규 INSERT 불요.~~
  **틀림(over-claim).** 라이브 실측: `PRF_POSTER_FIXED`에 배선된 comp은 **단 1개**
  (`COMP_POSTER_ARTPRINT_PHOTO`)인데 **상품 28개가 바인딩**됨. 나머지 27상품(본 13 면적형 중
  12 + 고정가 다수)은 자기 comp_cd가 공식에 미배선 → **가격조회 사슬 단절(D-WIRE GAP)**.
- **함의:** 본 트랙이 component_prices 단가를 적재해도 **배선 없이는 가격이 조회되지 않는다.**
  근본원인 = 28상품이 1개 공유공식(PRF_POSTER_FIXED)에 묶여 상품별 comp 분기 불가
  (formula_components는 공식당이지 상품당 아님). → **상품별 공식 모델**(PRF_POSTER_<상품> 각자
  자기 comp 배선)로 재모델하는 **설계 결정 필요**(D-WIRE 트랙). 슬라이스 C3가 독립 적발.

### 4.4 상품 바인딩 (라이브 선존재)
- `t_prd_product_price_formulas` (13 prd_cd ↔ PRF_POSTER_FIXED). 라이브 13/13 존재.
  신규 INSERT 불요.

> **결론**: 본 트랙이 적재하는 것은 `t_prc_component_prices` 단가 차원 행 **단 하나**.
> 공식/구성요소/배선/바인딩은 모두 라이브 선존재. 이는 round-2 가 "골격은 깔고 데이터는
> sparse 로 채운" 상태이기 때문 — 본 트랙은 **데이터 본체(매트릭스 셀)를 채우는 정정**.

---

## 5. 본 트랙 밖 (고정가형 16상품 — round-2 정정 권위 일관)

실사 29 - 면적매트릭스 13 = **16상품이 고정가형(수량×옵션)**. 포스터사인에서 이들은
**title 블록 + `사이즈 / 수량` 블록 쌍**(B12~B25, B28~B31) = `[수량(행) × 규격(A3/A2/A1, 열)]`
구조이지 [가로×세로] 면적매트릭스가 아니다.

`dbmap-price-formula-types-authority` 권위: 폼보드·포맥스보드·프레임리스액자·레더아트액자·
캔버스행잉·린넨우드봉족자·족자포스터·PET배너·메쉬배너·(무광/홀로그램)시트커팅·(유광/미러)
아크릴스티커·미니보드스탠딩·미니배너 = **고정가형**. round-2 가 이 15(+1)를 면적-좌표로
오모델한 것도 정정 대상이나 **모델이 다르므로(수량×규격) 본 면적매트릭스 트랙에 강제
편입 금지**(round-2 트랩 재발 방지). → 별도 고정가형 트랙으로 처리 권고.

> [적대적 주의] "29 실사를 전부 면적매트릭스로" 라고 일괄 처리하면 round-2 오모델을
> 반복한다. USER RULE 의 "[가로×세로] 면적매트릭스"는 그 구조를 **실제 가진** 13상품에만
> 적용. 16 고정가형은 BLOCKED-OUT-OF-SCOPE 로 명시 분리.

---

## 6. 제약 준수 (C-1~C-9, price-engine-ddl §7)

| 제약 | 준수 방법 |
|------|-----------|
| C-1 apply_ymd | varchar(10) `'2026-06-01'` 전건 (round-1/2 통일) |
| C-2 자연키 8 dedup | (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty) 사전 중복제거. CSV 내 중복 0 |
| C-3 max_qty 부재 | 면적매트릭스는 수량축 없음(min_qty=NULL). 상향개방 무관 |
| C-5 FRM_TYPE | 신규 공식 mint 없음. 라이브 PRF_POSTER_FIXED(FRM_TYPE.02) 유지 |
| C-6 comp_typ_cd | comp 신규 mint 없음. 라이브 .06 완제품비 유지 |
| C-9 NULL≠'' | 미사용 차원(clr/mat/coat/bdl/min)은 SQL NULL, CSV 공란→NULL 변환(헤더 주석 명문화) |
| reg_dt NOT NULL | `now()` 명시(round-5 적발 함정: 명시 NULL 은 DEFAULT 미발화) |
| IDENTITY stale | comp_price_id setval 재동기화 가드(메모리 lesson) |

---

## 7. 산출 파일

| 파일 | 내용 | 행수 |
|------|------|:--:|
| `load/t_prc_component_prices_INSERTABLE.csv` | siz 선존재(4 siz) 셀 | 17 |
| `load/t_prc_component_prices_BLOCKED.csv` | siz 미등록(108 siz) 셀 = 매트릭스 본체 | 670 |
| `load/t_siz_sizes_BLOCKED.csv` | 신규 siz 선적재 제안(인간승인) | 108 |
| `load.sql` | 멱등 INSERT(INSERTABLE 17 한정) + 단계0 부모검증 + setval 가드 | — |
| `dryrun-plan.md` | DRY-RUN 게이트 + 설계자 사전점검 결과(R1~R6) | — |

CSV 공란 = NULL 규약. 헤더 = DB 컬럼명. `_provenance` 는 추적용 보조컬럼(적재 시 제외).

---

## 8. 설계결정 — 인간 확인 필요

| ID | 결정사항 | 권고 |
|----|----------|------|
| D-SIZ | 108 면적치수 siz 신규등록 (제안 SIZ_000511~000618, `{가로}x{세로}` 명명) | **승인 필요** — 매트릭스 본체 670행의 차단 해소 전제 |
| D-FRM | 면적매트릭스 공식유형 = 라이브 FRM_TYPE.02(단순형) 유지 vs USER RULE 언급 .01(합산형) | 라이브 권위 유지(공식 변경 본 트랙 밖). 검증단계 의미확정 권고 |
| D-R2CLEAN | round-2 sparse 셀(SIZ_320/321/323/403 등 17행)을 정정본에 흡수 | 동일 값이라 **흡수=no-op**(멱등). 단 round-2 가 일부에 min_qty=1 을 넣은 변칙행(BANNER/JOKJA/PET)은 본 매트릭스 자연키(min_qty=NULL)와 별개 → 잔존. 정리는 별도 CORRECTION 라운드 |
| D-OOS | 고정가형 16상품(수량×규격)을 별도 트랙으로 | 본 면적매트릭스 트랙 강제편입 금지(round-2 트랩) |
