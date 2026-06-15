# POSTER 면적매트릭스 적재 구조 설계 (area-load-design) — round-20

> **작성** 2026-06-15 · round-20. 입력 = `domain-research.md`(선결 4축·PS-A~H) + `20_price-import/poster-sign/{poster-sign-structure,poster-sign-decomposition}.md`(round-16 그릇 분해·재유도 0) + **라이브 t_* read-only 실측(2026-06-15)** + 권위 가격표 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` 포스터사인 시트.
>
> **권위순서 [HARD]:** ① 가격표 명시값 > ② 라이브 t_* 실측(read-only) + 07_domain KB > ③ 경쟁사/표준(보조). **추정 0 · 보정 하드코딩 0 · 복합셀 collapse 금지 · 실무진 정리 존중.**
>
> **비파괴:** 본 문서는 **구조 설계 + 분해 + 적재 순서 + 선결 게이트**까지. **실 COMMIT · siz 채번 · 오염 정정 · DRY-RUN은 인간 승인 / 별 트랙**. DB 쓰기 0.
>
> **그릇 권위(라이브 information_schema 실측, 2026-06-15):**
> ```
> [공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)              ← frm_typ_cd 라이브 부재
> [상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd)
> [배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
> [구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims jsonb, use_yn, note)
> [단가행]     t_prc_component_prices(comp_price_id PK, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd,
>                                     coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd)
> [규격]       t_siz_sizes(siz_cd, siz_nm, work_width, work_height, cut_width, cut_height, ...)
> ```

---

## 0. 한 줄 결론

포스터사인 면적 단가 적재 = **3축 분리 적재**(면적단가 축 + 설치공정 축 + 거치부속 축). 면적 축의 적재는 **소재별 공식 분리(`PRF_POSTER_<소재>` 30개) + 면적좌표 siz 채번(109개)** 이 선결이다. 라이브 실측으로 **siz 채번 범위가 round-16 추정(667)의 1/6인 ~109개**임이 확정됐다(블록 간 좌표 공유 → 거치 좌표는 **112개 distinct**, 그중 3개 실재). 설치/거치는 면적 단가에 합산 금지(엑셀 가공/추가 별 컬럼 + 경쟁사 인쇄비/후가공 분리 권위). 라이브 134/135 옵션 오염은 **현 `t_prd_product_options` 층에서 재현되지 않음**(verify-before-correct: PS-H 가드는 유지하되 구체 오염 부재).

---

## §1. 면적 그릇 분해 (4테이블 · 언피벗)

### 1-1. 면적매트릭스 → component_prices long-form (면적-좌표 회귀 금지 [HARD])

포스터사인 시트의 13개 면적매트릭스 블록을 `(siz_cd, unit_price)` 행으로 언피벗한다. **면적함수(R²) 적합 금지** — 격자 단가를 그대로 행으로 푼다(라이브 실측 적재방식·아크릴 동형).

```
면적매트릭스 셀 (가로 g mm, 세로 s mm) = 단가 p
  → t_prc_component_prices row:
     comp_cd   = COMP_POSTER_<소재>          (소재별 본체 comp)
     siz_cd    = <"{g}x{s}" 규격코드>        (가로×세로 = 1 규격, 채번 §3)
     clr_cd    = NULL   (도수 무관 — 별색=공정 규칙·통가격)
     mat_cd    = NULL   (소재는 comp_cd에 박힘 — mat_cd 차원 미사용)
     proc_cd   = NULL   opt_cd = NULL   coat_side_cnt = NULL   bdl_qty = NULL
     min_qty   = NULL   (면적매트릭스 = 수량 무관)
     unit_price= p
     apply_ymd = '2026-06-01'
```

- **use_dims = `["siz_cd"]`** (라이브 실측 일치 — B01~B11·현수막 본체). 나머지 9차원 NULL(와일드카드).
- **off-grid ceiling = 런타임**: 가로·세로가 격자에 정확히 없으면 각 축 한 단계 큰 규격 가격(앱·위젯 계산). **DB는 격자 단가만 저장**, ceiling 행 생성 금지(과적재 금지).

### 1-2. 라이브 실측 — 매트릭스 13블록 제원 (가격표 권위, 2026-06-15 재계측)

| 블록 | 소재 comp | 가로×세로 | 데이터셀 | 비고 |
|------|-----------|----------|---------|------|
| 아트프린트포스터 | `COMP_POSTER_ARTPRINT_PHOTO` | 13×4 | 52 | 인화지(라이브 유일 배선) |
| 아트페이퍼포스터 | `COMP_POSTER_ARTPAPER_MATTE` | 13×3 | 39 | 매트지 |
| 방수포스터 | `COMP_POSTER_WATERPROOF_PET` | 13×4 | 52 | PET |
| 접착방수포스터 | `COMP_POSTER_ADH_WATERPROOF_PVC` | 13×4 | 52 | PVC |
| 접착투명포스터 | `COMP_POSTER_ADH_CLEAR_PVC` | 13×4 | 52 | 투명PVC·화이트 underbase |
| 아트패브릭포스터 | `COMP_POSTER_ARTFABRIC_GRAPHIC` | 13×4 | 52 | 그래픽천 |
| 린넨패브릭포스터 | `COMP_POSTER_LINEN_FABRIC` | 13×4 | 52 | 린넨 |
| 캔버스패브릭포스터 | `COMP_POSTER_CANVAS_FABRIC` | 13×4 | 52 | 캔버스 |
| 레더아트프린트 | `COMP_POSTER_LEATHER_ARTPRINT` | 13×4 | 52 | 레더 |
| 타이벡프린트 | `COMP_POSTER_TYVEK_PRINT` | 13×4 | 52 | 타이벡(하드/소프트 변형) |
| 메쉬프린트 | `COMP_POSTER_MESH_PRINT` | 13×4 | 52 | 메쉬 |
| 일반현수막 | `COMP_POSTER_BANNER_NORMAL` | 16×5 | 80 | ~5000mm·가공옵션열 별도 |
| 메쉬현수막 | `COMP_POSTER_BANNER_MESH` | 16×3 | 48 | 메쉬현수막 |
| **합계** | — | — | **687** | 셀 총합 |

- **셀 687 = 비-distinct 합산.** 블록들이 동일 축(가로 600~3000 / 세로 600~1200, 현수막 ~5000)을 공유하므로 **distinct (가로,세로) 좌표 = 112개**(라이브 실측 — §3).

### 1-3. 단가형/합가형 판별 (라이브 실측 = 권위)

| 구성요소 군 | prc_typ_cd | 근거 | 엔진 계산 |
|-------------|-----------|------|----------|
| `COMP_POSTER_*` 면적매트릭스 11 | **.01 단가형** | 라이브 실측 전건 `PRICE_TYPE.01`·매트릭스 셀=개당 면적단가(수량축 없음) | `면적단가 × 주문수량` |
| `COMP_POSTER_*` 밴드 9(`[siz_cd,min_qty]`) | **.01 단가형** | 라이브 실측 `.01`·구간별 개당단가(수량 많을수록 개당 ↓) | `구간 개당단가 × 주문수량` |
| `COMP_POSTEROPT_*`·`COMP_POPT_*` 옵션 add-on | **.01 단가형** | 라이브 실측 `.01`·추가옵션 통가격 | `add-on 단가 × 수량` 또는 고정 |

> **합가형(.02) 없음** — 포스터사인 30 material + 20 opt + 3 popt = **53종 전건 라이브 `PRICE_TYPE.01`(단가형)** 실측. 세트 총액 단위 표기 없음(스티커 타투/팩과 다름). **밴드(미니배너 5구간 등)도 단가형** — min_qty 차원 매칭으로 구간별 단가 선택 후 ×수량(구간총액 환산 아님·라이브 권위). 추정 아님.
>
> ⚠️ **돈-크리티컬 주의(round-18+ D-1b 패턴):** 면적 본체 comp는 단가형이 정당하나, **거치/설치 옵션 comp의 prc_typ_cd는 별도 검증 대상**이다. 후가공이 구간고정총액형인데 단가형(.01)으로 오적재된 사례(엽서·상품권 D-1b)가 있었다. 본 round-20 면적 적재는 본체(단가형 정당)만 다루고, 설치/거치 옵션 comp의 prc_typ는 §4에서 별 검증으로 분리(가격표 가공X/추가Z 단위 표기 확인 필요).

### 1-4. 그릇 4테이블 행 산정 (면적 본체만)

| 테이블 | 면적 적재 행 | 멱등 키 |
|--------|------------|---------|
| `t_prc_price_formulas` | 소재별 공식 30행(§2) | `frm_cd` |
| `t_prd_product_price_formulas` | 28 바인딩 교체(소재 공식으로) | `(prd_cd, frm_cd, apply_bgn_ymd)` |
| `t_prc_formula_components` | 30 배선(공식↔소재 comp) + 옵션 add-on 배선 | `(frm_cd, comp_cd)` |
| `t_prc_price_components` | 53 재현(라이브 적재됨·신설 0) | `comp_cd` |
| `t_prc_component_prices` | 면적셀 687(소재별 본체) + 밴드/이산/옵션 | `(comp_cd, apply_ymd, siz_cd, ...10차원)` NULLS DISTINCT |
| `t_siz_sizes` | **신규 109행(면적좌표 채번)** | `siz_nm` |

---

## §2. 소재별 공식 분리 (PS-C — 가격사슬 단절 해소)

### 2-1. 현 단절 (라이브 실측 2026-06-15)

```
라이브 현재:
  PRF_POSTER_FIXED ──배선(formula_components 1행)──▶ COMP_POSTER_ARTPRINT_PHOTO  (인화지만)
  28상품(PRD_000118~145) ──바인딩(28행)──▶ PRF_POSTER_FIXED
```

라이브 확정: **바인딩 28 / 배선 1**. 28상품이 단일 공식에 묶였으나 공식은 인화지 1 comp만 합산 → **인화지 외 27상품은 자기 소재 단가행이 적재돼도 엔진 조회 경로 없음**(공식이 그 comp를 안 봄). 면적 단가를 아무리 채워도 27상품 가격 0/조회불가 = **면적 적재의 본질적 선결 차단**.

### 2-2. 해소 = 소재별 공식 분리 ([[dbmap-price-chain-dwire-per-product-formula]] 상품별 공식·round-18+ BIND 공식분리 원칙)

각 상품(또는 소재변형)이 자기 본체 comp 1개를 보는 공식으로 분리. round-18+ BIND 일반원칙 정합("상품별 1고정 본체 → 공식분리", 멤버십 다중택1이 아님).

| 신규 공식(제안) | 본체 comp | 바인딩 상품 |
|----------------|-----------|------------|
| `PRF_POSTER_ARTPRINT` | `COMP_POSTER_ARTPRINT_PHOTO` | PRD_000118 아트프린트포스터 |
| `PRF_POSTER_ARTPAPER` | `COMP_POSTER_ARTPAPER_MATTE` | PRD_000119 아트페이퍼포스터 |
| `PRF_POSTER_WATERPROOF` | `COMP_POSTER_WATERPROOF_PET` | PRD_000120 방수포스터 |
| `PRF_POSTER_ADH_WATERPROOF` | `COMP_POSTER_ADH_WATERPROOF_PVC` | PRD_000121 접착방수포스터 |
| `PRF_POSTER_ADH_CLEAR` | `COMP_POSTER_ADH_CLEAR_PVC` | PRD_000122 접착투명포스터 |
| `PRF_POSTER_ARTFABRIC` | `COMP_POSTER_ARTFABRIC_GRAPHIC` | PRD_000123 아트패브릭포스터 |
| `PRF_POSTER_LINEN` | `COMP_POSTER_LINEN_FABRIC` | PRD_000124 린넨패브릭포스터 |
| `PRF_POSTER_CANVAS` | `COMP_POSTER_CANVAS_FABRIC` | PRD_000125 캔버스패브릭포스터 |
| `PRF_POSTER_LEATHER_PRINT` | `COMP_POSTER_LEATHER_ARTPRINT` | PRD_000126 레더아트프린트 |
| `PRF_POSTER_TYVEK` | `COMP_POSTER_TYVEK_PRINT` | PRD_000127 타이벡프린트 |
| `PRF_POSTER_MESH` | `COMP_POSTER_MESH_PRINT` | PRD_000128 메쉬프린트 |
| `PRF_POSTER_FOAMBOARD` | `COMP_POSTER_FOAMBOARD_WHITE/BLACK`(2 변형) | PRD_000129 폼보드 |
| `PRF_POSTER_FOMEX` | `COMP_POSTER_FOMEXBOARD_WHITE3MM/5MM`(2) | PRD_000130 포맥스보드 |
| `PRF_POSTER_FRAMELESS_WOOD` | `COMP_POSTER_FRAMELESS_WOOD` | PRD_000131 프레임리스우드액자 |
| `PRF_POSTER_LEATHER_FRAME` | `COMP_POSTER_LEATHER_FRAME` | PRD_000132 레더아트액자 |
| `PRF_POSTER_CANVAS_HANGING` | `COMP_POSTER_CANVAS_HANGING` | PRD_000133 캔버스 행잉포스터 |
| `PRF_POSTER_LINEN_WOODBONG` | `COMP_POSTER_LINEN_WOODBONG` | PRD_000134 린넨 우드봉 족자 |
| `PRF_POSTER_JOKJA` | `COMP_POSTER_JOKJA` | PRD_000135 족자포스터 |
| `PRF_POSTER_PET_BANNER` | `COMP_POSTER_PET_BANNER` | PRD_000136 PET배너 |
| `PRF_POSTER_MESH_BANNER` | `COMP_POSTER_MESH_BANNER` | PRD_000137 메쉬배너 |
| `PRF_POSTER_BANNER_NORMAL` | `COMP_POSTER_BANNER_NORMAL` | PRD_000138 일반현수막 |
| `PRF_POSTER_BANNER_MESH` | `COMP_POSTER_BANNER_MESH` | PRD_000139 메쉬현수막 |
| `PRF_POSTER_SHEETCUT_MATTE` | `COMP_POSTER_SHEETCUT_MATTE` | PRD_000140 무광시트커팅 |
| `PRF_POSTER_SHEETCUT_HOLO` | `COMP_POSTER_SHEETCUT_HOLO` | PRD_000141 홀로그램 시트커팅 |
| `PRF_POSTER_ACRYLSTK_GLOSS` | `COMP_POSTER_ACRYLSTK_GLOSS` | PRD_000142 유광아크릴스티커 |
| `PRF_POSTER_ACRYLSTK_MIRROR` | `COMP_POSTER_ACRYLSTK_MIRROR` | PRD_000143 미러아크릴스티커 |
| `PRF_POSTER_MINI_STANDBOARD` | `COMP_POSTER_MINI_STANDBOARD` | PRD_000144 미니보드스탠딩 |
| `PRF_POSTER_MINI_BANNER` | `COMP_POSTER_MINI_BANNER` | PRD_000145 미니배너 |

- **공식 28~30개**(2변형 상품 폼보드/포맥스/시트커팅/아크릴스티커는 화이트/블랙·매트/홀로 등 소재변형 — 변형도 본체 comp가 다르므로 **변형별 공식** 또는 **단일 공식+소재 택일 옵션** 중 컨펌. 보수적 = 공식 분리. **Q-PS-C2** 신규).
- **바인딩 교체**: `PRF_POSTER_FIXED` → `PRF_POSTER_<소재>`. 멱등 키 `(prd_cd, frm_cd, apply_bgn_ymd)`·기존 FIXED 바인딩은 use_yn=N 논리종료(hard-delete 금지).
- **배선**: 각 신규 공식에 본체 comp 1행(`addtn_yn=N` 본체) + (해당 상품의 설치/거치 옵션 comp는 §4 별 축에서 add-on 배선).

> **Q-PS-1 해소 방향:** 소재별 공식 분리 채택(단일공식+엔진 조건분기는 webadmin evaluate_price 미구현이라 검증 불가·분리가 Phase11 `상품→공식→comp 합산` 모델에 정합). 단 webadmin 엔진 최종 설계 확인은 인간 승인 게이트.

---

## §3. siz 채번 범위 제안 (PS-B · ddl-proposer 라우팅 · search-before-mint)

### 3-1. 🔴 round-16 추정(667) 정정 — 라이브 실측 = distinct 112좌표

round-16 structure는 "687 면적조합 중 667 siz 미실재"로 봤으나, 이는 **블록 간 좌표 중복을 합산한 수치**(셀=687 비-distinct). 라이브 + 가격표 재계측 결과:

| 항목 | 라이브 실측(2026-06-15) |
|------|------------------------|
| 13블록 면적셀 총합 | 687 (비-distinct) |
| **distinct (가로,세로) 좌표** | **112개** |
| 가로 축 값 | 600,800,900,1000,1200,1400,1600,1800,2000,2200,2400,2600,2800,3000,3500,4000,4500,5000 (18종) |
| 세로 축 값 | 600,800,900,1000,1200,1500,1750 (7종) |
| **이미 siz 실재** | **3개** (`900x1200`=SIZ_000320·`900x900`=SIZ_000323·`5000x900`=SIZ_000322) |
| **채번 필요(신규)** | **109개** |
| 현 MAX siz_cd | SIZ_000510 → 채번 시작 **SIZ_000511** |

> **과적재 우려 해소:** 전수 격자(18×7=126 이론조합)가 아니라 **실제 가격표에 단가가 있는 112좌표만** 채번(영구 격자 등록 회피). 이미 실재 3개는 재사용(search-before-mint). → **신규 109 siz**.

### 3-2. 채번 siz 행 스펙 (제안 — ddl-proposer/load 트랙)

```
siz_cd  = SIZ_000511 ~ SIZ_000619 (순차·채번=MAX+1·[[dbmap-code-identifier-strategy]])
siz_nm  = '<가로>x<세로>'           예: '600x600', '800x1000', '5000x1750'
work_width  = 가로(mm)   work_height = 세로(mm)
cut_width/cut_height = 가로/세로(작업=재단 동일·면적출력)
margin_* = 0   impos_yn = N(면적출력·임포지션 아님)
use_yn = Y   note = '포스터사인 면적좌표(round-20)'
```

- **siz_nm 규약 = `WIDTHxHEIGHT`** (라이브 기존 면적좌표 `600x1800`·`900x900` 동일 규약 — 정합 확인). 멱등 키 `siz_nm`(재실행 시 중복 채번 0).
- **실 채번은 인간 승인** — 본 설계는 범위·스펙·정합만. ddl-proposer가 INSERT 산출, validator 검증, 인간 COMMIT.

> **Q-PS-3 해소 방향:** "사용된 매트릭스 셀만 채번"(112) 채택 — 전수 격자(126) 영구등록은 과적재. 단 18종 가로 × 7종 세로의 빈 14조합(126-112)은 가격표에 단가 없음 = off-grid ceiling으로 처리(채번 불요).

---

## §4. 설치/거치 3축 옵션 구조 (PS-A · 돈 · 면적 합산 금지)

### 4-1. 3축 분리 원칙 ([HARD] — 엑셀 W/X·Y/Z 분리 + 경쟁사 인쇄비/후가공 분리 양쪽 권위)

```
PRD(28) ──바인딩──▶ PRF_POSTER_<소재>
                         │ formula_components 합산(addtn_yn)
        ┌────────────────┼──────────────────────┐
   [면적단가 축]      [설치공정 축]          [거치부속 축]
   COMP_POSTER_<소재>  COMP_POSTEROPT_<공정>   추가상품/COMP_POSTEROPT_<부속>
   use_dims=[siz_cd]   option_items .04(공정)  option_items .03(자재) / addon
   ← 면적매트릭스        ← 엑셀 가공(X)단가       ← 엑셀 추가(Z)단가
   addtn_yn=N(본체)     addtn_yn=Y(가산)         addtn_yn=Y(가산)
```

**면적 단가에 설치/거치 합산 금지** — 면적 셀은 "색 입힌 출력물" 단가만. 설치공정·거치부속은 자기 단가 comp로 별 축 가산.

### 4-2. 4분류별 옵션 구조 (domain-research §1-1 권위)

| 분류 | 정의 | 설치공정 축(가공W) | 거치부속 축(추가Y) | 해당 상품 |
|------|------|-------------------|-------------------|-----------|
| **(A) 출력만·재단만** | 거치 옵션 없음 | — | — | 포스터류·시트커팅·아크릴스티커(118~128·140~143·129·130) |
| **(B) 타공만+부속별매** | 타공/아일렛만 후니 수행·거치대/끈 별매 | `타공(4/6/8구)`·`4구타공`·`봉미싱`·`열재단` = option_groups 단일선택 + comp 가산 | `거치대없음`(기본·0)·`끈(4개)`·`각목`·`큐방`·`실내/실외 배너거치대` = addon | PET배너136·메쉬배너137·일반현수막138·메쉬현수막139 |
| **(C) 봉제·봉 완성형** | 봉제+봉 포함·걸기만 | `오버로크`·`말아박기`·`봉미싱(4/7cm)`·`사각/원형족자` = 단일선택 + comp | `우드봉/우드행거+면끈 포함`·`출력만`·`천정형고리` = addon | 패브릭124/125·행잉133·우드봉족자134·족자포스터135 |
| **(D) 완제품 거치(부속동반)** | 액자/스탠딩/거치대 포함or별매 | (액자=소재완성·보드마운팅) | `거치대 별매`·액자프레임 | 액자131/132·미니보드스탠딩144·미니배너145 |

### 4-3. 설치/거치 comp · ref 매핑 (07_domain D-24 재사용 · 라이브 COMP_POSTEROPT_* 20종)

| 설치/거치 | 라이브 comp(실측) | option_items ref_dim | param |
|-----------|------------------|---------------------|-------|
| 타공/아일렛 | `COMP_POSTEROPT_BANNER_*_PROC_*` | `.04` 공정(`PROC_000079` 타공) | 구수(4/6/8) |
| 봉제(오버로크/말아박기/봉미싱) | `COMP_POSTEROPT_*` | `.04` 공정(`PROC_000080` 봉제) | 유형·폭(4/7cm) |
| 족자제작 | `COMP_POSTEROPT_JOKJA_*` | `.04` 공정(`PROC_000082`) | 사각/원형 |
| 열재단 | — | `.04` 공정(`PROC_000084`) | — |
| 거치부속(각목/끈/큐방) | `COMP_POSTEROPT_BANNER_*_ADD_*`·`COMP_POPT_*` | `.03` 자재 / addon | 대상 |
| 우드봉/우드행거 | `COMP_POSTEROPT_*_WOODBONG/WOODHANGER` | `.03` 자재 / addon | — |
| 배너거치대(실내/실외) | `COMP_POSTEROPT_PET_BANNER_STAND_*` | addon(별매 tmpl_cd) | IN/OUT |

- **옵션 = 별 comp(opt_cd 차원 아님)**: 라이브는 포스터 옵션을 `opt_cd` 차원행이 아니라 **별도 component**(`COMP_POSTEROPT_*`)로 모델링. 공식이 본체 comp + 옵션 comp를 **합산**(addtn_yn=Y). 라이브 실측 따름(기계적 통일 금지). **Q-PS-2**(합산이 공식 배선인지 CPQ option add_price인지 webadmin 확인).
- **택일 그룹(PS-D)**: 현수막 가공(봉미싱/열재단/타공) UI 택1이나 라이브 excl_group 부재. → **option_groups 단일선택(`sel_typ_cd` 단일·`max_sel_cnt=1`)** 으로 충분(신규 excl_group 회피). 라이브 `t_prd_product_option_groups.sel_typ_cd` 활용.
- **🔴 설치/거치 comp prc_typ 검증 분리**: 본체(단가형 .01 정당)와 달리 설치/거치 단가가 **구간고정총액형**인지(예 "타공 4구 = 3,000원/건" vs "장당") 가격표 가공X/추가Z 단위 표기로 별 검증 필요(round-18+ D-1b 오적재 패턴 방지). 본 round-20 면적 적재는 본체만·옵션 prc_typ는 후속 게이트.

---

## §5. 오염 정정 선행 의존성 (PS-H · round-13 가드)

### 5-1. 라이브 134/135 옵션 현황 (실측 2026-06-15 — verify-before-correct)

domain-research §4.2는 PRD_000134/135에 "단면/양면 도수·종이류·미싱/오시 혼입(v03 오염)"을 경고했으나, **현 라이브 `t_prd_product_options` 층 실측 결과 오염 미재현**:

| PRD | 가공(W) 옵션 | 추가(Y) 옵션 | 판정 |
|-----|------------|------------|------|
| PRD_000134 린넨우드봉족자 | `오버로크+봉미싱(4cm)` | `출력만` | ✅ 엑셀 가공/추가 명시값과 일치(clean) |
| PRD_000135 족자포스터 | `사각족자`·`원형족자` | `추가없음` | ✅ 일치(clean) |

- **현 `t_prd_product_options` 층은 깨끗**. domain-research가 본 오염은 ① 더 이른 스냅샷 ② `option_items`(값 참조) 층 ③ 이미 정정된 상태 중 하나. **구체 오염이 현 라이브에 부재**.

### 5-2. 의존성 결론

- **PS-H 게이트는 가드로 유지**(round-13 패턴 — 면적/설치 적재 전 28상품 옵션 레이어를 엑셀 가공/추가 명시값 기준으로 1회 대조). 단 **구체 정정 작업은 현재 불요**(134/135 options clean). `option_items`(ref_key) 층의 오염 잔재는 round-13 correctness-audit 트랙에서 별 확인(본 round-20 면적 적재의 직접 차단 아님).
- **직접 정정은 round-13 트랙** — 본 설계는 의존성 명시까지(비파괴). 만약 후속 `option_items` 실측에서 종이/도수 ref가 발견되면 면적/설치 적재 **전** round-13 정정 선행.

---

## §6. 적재 순서 · 선결 게이트 · 인간 승인 큐 (비파괴)

### 6-1. 적재 순서 (FK 위상 + 선결 의존)

```
G0  오염 가드(PS-H)     : 28상품 옵션 엑셀 대조(134/135 clean 확인됨·option_items 잔재만 round-13)
        │ (clean → 통과)
G1  siz 채번(PS-B)      : 109 신규 siz(SIZ_000511~) ── ddl-proposer 산출 ── 인간 승인 COMMIT
        │ (siz 실재 → 면적 단가행 적재 가능)
G2  소재별 공식(PS-C)   : PRF_POSTER_<소재> 28~30 정의 + 배선(formula_components 본체 1행/공식)
        │
G3  바인딩 교체         : 28 product_price_formulas → 소재 공식(FIXED use_yn=N 종료)
        │
G4  면적 단가행 적재    : component_prices 687(소재별 본체·siz_cd long-form·gen_batch_upsert)
        │
G5  설치/거치 옵션(PS-A): option_groups/options 단일선택 + COMP_POSTEROPT 가산 배선
                          + 옵션 comp prc_typ 별 검증(D-1b 가드)
```

### 6-2. 멱등 배치 적재 형태 (gen_batch_upsert 적용 가능 · [[dbmap-live-load-transition-260615]])

```sql
-- 면적 단가행(G4) — 멱등 NOT EXISTS · NULLS DISTINCT · apply_ymd
INSERT INTO t_prc_component_prices(comp_cd, apply_ymd, siz_cd, unit_price, ...)
SELECT 'COMP_POSTER_WATERPROOF_PET', DATE '2026-06-01', s.siz_cd, v.price, NULL...
FROM (VALUES ('600x600',12000), ('800x1000',20000), ...) v(nm, price)
JOIN t_siz_sizes s ON s.siz_nm = v.nm
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_WATERPROOF_PET' AND x.apply_ymd=DATE '2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM s.siz_cd  -- NULLS DISTINCT 10차원 키
    AND x.min_qty IS NULL AND x.clr_cd IS NULL AND ...
);
```

- **선결**: G4 면적 적재는 **G1(siz 채번) + G2/G3(소재 공식·바인딩)** 이 COMMIT돼야 가능. siz 미채번 상태로 단가행 적재 시 FK 위반(siz_cd 부재). → **DRY-RUN도 siz 채번 후 가능**(현재는 설계까지).

### 6-3. 인간 승인 큐 (실 적용 = 인간 결정)

| # | 항목 | 트랙 | 차단 의존 |
|---|------|------|----------|
| **AQ-1** | siz 109행 채번 COMMIT(PS-B) | ddl-proposer/load | G4 면적 적재의 1차 관문 |
| **AQ-2** | 소재별 공식 30 + 바인딩 교체 COMMIT(PS-C) | load-execution | G4 전제·27상품 조회불가 해소 |
| **AQ-3** | 면적 단가행 687 적재 COMMIT(G4) | batch-load | AQ-1·AQ-2 후 |
| **AQ-4** | 설치/거치 옵션 적재 + 옵션 comp prc_typ 검증(PS-A·D-1b) | option-mapper/price-arbiter | 별 게이트 |
| **AQ-5** | webadmin evaluate_price 엔진 최종 설계(공식분리 vs 조건분기·옵션 합산 경로) | 인간/개발 | Q-PS-1·Q-PS-2 |

### 6-4. 미해소 컨펌

| ID | 컨펌 | 가설 |
|----|------|------|
| **PS-A** [🔴·돈] | 설치/거치 면적 합산 vs 별 옵션 단가 | **별 옵션 단가**(엑셀 W/X·Y/Z + 레드 인쇄비/후가공 분리 권위·합산 금지) |
| **PS-B** [🟡] | siz 채번 범위 | **112좌표 중 신규 109**(라이브 실측·전수격자 회피·실재 3 재사용) |
| **PS-C** [🟡] | 소재별 공식 분리 | **분리**(PRF_POSTER_<소재> 28~30·단일공식+1배선=27상품 단절) |
| **Q-PS-C2** [🟡·신규] | 2변형 상품(폼보드 W/B·포맥스 3/5mm·시트커팅 매트/홀로·아크릴스티커 유광/미러) = 변형별 공식 vs 단일공식+소재택일 | 보수적=변형별 공식(본체 comp 다름). webadmin 옵션 모델 확인 |
| **PS-D** [🟡] | 현수막 가공 택일 = excl_group vs option_groups 단일선택 | **option_groups 단일선택**(sel_typ_cd·신규 excl_group 회피) |
| **PS-E** [🟡] | 거치부속 = 추가상품(tmpl) vs option_items 자재 | 추가상품/별매 SKU(SL-4 정합) |
| **PS-H** [🟡·정정] | 134/135 오염 정정 선행 | **현 options 층 clean(미재현)** — 가드 유지·option_items 잔재만 round-13 |
| **Q-PS-1/2** | webadmin 엔진 공식분리·옵션 합산 경로 | 인간/개발 확인(AQ-5) |

---

## §7. 한 줄 현황

POSTER 면적매트릭스 적재 구조 설계 완료 — **3축 분리**(면적단가 `COMP_POSTER_<소재>` use_dims=[siz_cd]·단가형 .01 / 설치공정 `COMP_POSTEROPT_<공정>` option_items .04 / 거치부속 .03·addon). 면적 본체 = 13블록 687셀 `(siz_cd, unit_price)` 언피벗(면적-좌표 회귀 금지). **🔴 선결 3건: ① siz 채번 109개**(distinct 112좌표 중 실재 3 재사용·SIZ_000511~·round-16의 667 추정을 라이브 실측으로 정정) **② 소재별 공식 분리 28~30개**(현 단일공식+1배선=27상품 조회불가 해소·바인딩 교체) **③ 옵션 comp prc_typ 별 검증**(D-1b 오적재 가드). 라이브 134/135 오염 현 options 층 미재현(verify-before-correct·가드 유지). **적재 순서 G0 오염가드→G1 siz채번→G2/G3 소재공식·바인딩→G4 면적단가행→G5 설치옵션**. 멱등 gen_batch_upsert(NOT EXISTS·NULLS DISTINCT·apply_ymd 2026-06-01). **DB 미적재 — 실 COMMIT·siz 채번·오염 정정·DRY-RUN은 인간 승인(AQ-1~5).** 컨펌 8건(신규 Q-PS-C2). → validator P1~P6 인계.
