# comp-product-validity-matrix — 구성요소↔상품군 유효성 정합 매트릭스 (U-7)

> **Phase 3 — hped-binding-validity-designer** · 2026-06-18 · `huni-price-engine-diag/04_binding_validity`
> **초점[HARD]:** 코드(트리거/CHECK/FK)가 아니라 **데이터 정합** — "어떤 가격구성요소가 어떤 상품군에 유효한가"의 정답 데이터.
> **권위:** SOT 1(상품마스터 11시트=허용 차원 경계) · SOT 2(결합형/독립형) · authority-golden(가격축). 라이브 읽기전용 실측(2026-06-18).
> **라이브 실측 근거:** 146 comp · 63 wired(formula_components) · 83 unwired · 48 공식 · 76 상품 바인딩(45 공식). 각 귀속에 출처+SQL.

---

## 0. 한 문장 결론

가격구성요소는 **거의 전부 독립형(단일 상품군 귀속)**이다 — comp_nm이 상품군을 직접 명명하고(`...완제품가 (일반현수막)`·`스탠다드명함...`), 그 comp의 단가행 차원이 그 상품군 시트(SOT 1)의 허용 차원과 일치한다. **유효성 위반은 단 7개 "광역 후가공 comp"(오시·귀돌이·미싱·가변텍스트·가변이미지·별색)에 집중**된다 — 이들이 종이상품(엽서·전단지) 후가공인데 **면적매트릭스 포스터/현수막 28공식에 일괄 복사 배선**돼 시트 차원경계를 위반했다. 이것이 D-1/2/3·D-6의 단일 병인(SOT 4 제약부재)을 데이터로 구체화한 것이다.

---

## 1. 귀속 방법론 (SOT 1+2 적용)

각 comp의 **유효 상품군**을 3단계로 귀속:

1. **차원 출처 추적** — comp의 `use_dims` 선언 + 단가행(component_prices) 충전 차원(siz/plt/proc/mat/sw/sh/dim_vals…).
2. **상품군 시트 대조 (SOT 1)** — 그 차원이 어느 상품마스터 시트(상품군)의 허용 차원에 속하는가. comp_nm의 명시 상품군명이 1차 증거, 단가행 차원이 2차 검증.
3. **결합형/독립형 판별 (SOT 2)** —
   - **독립형** = 차원/단가가 한 상품군에만 존재 → 그 상품군에만 유효. (예: `COMP_NAMECARD_STD_S1` = 명함만)
   - **결합형** = 같은 가격테이블 내 같은 차원을 복수 상품군이 공유 → 그 차원 공유 상품군 전체에 유효. (예: `COMP_PRINT_DIGITAL_S1` = 디지털인쇄 종이상품군 공유, `COMP_PAPER` = 종이상품 공유)
   - **결합형 ≠ 무제한** — 차원을 "공유하는" 상품군만. 차원이 없는 상품군(포스터)에 종이 후가공 comp를 묶으면 결합형이 아니라 **오배선**.

**핵심 판별 규칙(정답 데이터의 근간):**
> comp가 어떤 공식에 묶이려면, 그 공식이 바인딩된 상품의 **상품군 시트가 comp의 유효 상품군 목록에 있어야** 한다. 없으면 오배선.

---

## 2. 상품군 정의 (SOT 1 — 11시트 + 라이브 76상품 바인딩 매핑)

라이브 76 바인딩 상품을 comp_nm·prd_nm·공식(frm_cd)으로 상품군에 귀속. 가격산정 구조(authority-golden §1)로 묶음:

| 상품군(그릇) | 가격구조 | 대표 상품(라이브 prd_nm) | 공식 |
|------|------|------|------|
| **G-PAPER 종이인쇄물**(엽서·쿠폰·슬로건·전단지) | 합산형 | 프리미엄/코팅/스탠다드/화이트/핑크별색/금은별색엽서·종이슬로건·쿠폰상품권·소량전단지 | PRF_DGP_A·D |
| **G-PAPER-VAR 종이변형**(모양엽서·라벨·배경지·헤더택·썬캡) | 합산형(완칼/접지) | 모양엽서·라벨/택·인쇄배경지·인쇄헤더택·썬캡 | PRF_DGP_B·C·F |
| **G-FOLD 접지물**(접지카드·리플렛) | 합산형(접지) | 2단/3단/미니접지카드·접지리플렛 | PRF_DGP_E·FOLD_SUM |
| **G-NAMECARD 명함** | 고정가형 | 프리미엄/코팅/스탠다드명함 | PRF_NAMECARD_FIXED |
| **G-BOOKLET 책자** | 합산형(제본) | 중철/무선/PUR/트윈링책자 | PRF_BIND_SUM |
| **G-PCB 엽서북** | 고정가형 | 엽서북 | PRF_PCB_FIXED |
| **G-PHOTOCARD 포토카드** | 고정가형 | 포토카드·투명포토카드 | PRF_PHOTOCARD_FIXED |
| **G-ENV 봉투** | 고정가형 | 봉투제작 | PRF_ENV_MAKING |
| **G-STICKER 스티커**(반칼/낱장/팩/타투) | 고정가형 | 16 스티커 상품 | PRF_STK_FIXED·PACK·TATTOO·GANGPAN_FIXED |
| **G-POSTER 실사/포스터/현수막**(면적매트릭스) | 면적매트릭스(가로×세로) 단가형 | 28 포스터/현수막/실사 상품 | PRF_POSTER_*(FIXED 제외) |
| **G-POSTER-FIX 보드/액자/족자**(고정가) | 고정가형 | 폼보드·포맥스·액자·족자·캔버스행잉·미니배너 등 | PRF_POSTER_FIXED 및 *_FIXED형 |
| **G-ACRYL 아크릴** | 면적매트릭스+두께 | 아크릴키링 | PRF_CLR_ACRYL |
| **G-ACRYLSTK 아크릴스티커** | 고정가형(siz_cd) | 유광/미러아크릴스티커 | PRF_POSTER_ACRYLSTK_* |

> **★SOT 1 핵심:** G-POSTER(면적매트릭스)·G-ACRYL·G-ACRYLSTK·G-NAMECARD·G-STICKER·G-PHOTOCARD 등 **단가형/면적형 상품군은 "완성 단가(코팅·후가공 포함가)" 단일 셀**이다(authority-golden §2 "면적매트릭스 단가형 = 한 셀 = 완성 단가, 합산 아님"). → **종이 후가공(오시·귀돌이·가변데이터·별색)을 별도 합산할 차원이 시트에 없다.** 이것이 위반 판정의 권위 근거.

---

## 3. 결합형 comp 유효 상품군 매트릭스 (복수 상품군 정당)

**결합형 = 차원 공유로 복수 상품군에 정당하게 유효한 comp.** SOT 2 정합.

| comp_cd | comp_nm | 귀속 차원(use_dims) | 결합 근거(SOT 2) | 유효 상품군 | reach | 확신도 |
|---------|---------|--------|--------|--------|:--:|:--:|
| COMP_PRINT_DIGITAL_S1/S2 | 디지털인쇄비 | proc·plt/siz·print_opt·min_qty | 디지털인쇄 = 종이상품 공통 인쇄비(국4절/3절 판형 공유) | G-PAPER·G-PAPER-VAR·G-FOLD | 19 | 높음 |
| COMP_PAPER | 용지비(종이별 절가) | siz·mat | 종이 자재비 = 종이상품 공통 | G-PAPER·G-PAPER-VAR·G-FOLD | 19 | 높음 |
| COMP_COAT_GLOSSY/MATTE | 유광/무광코팅비 | siz·coat·min_qty | 코팅 = 종이상품 공통 후가공(가격표 `코팅` 시트) | G-PAPER·G-FOLD | 13 | 높음 |
| COMP_PP_CREASE_1L/2L/3L | 오시비 | proc·min_qty·dim_vals(줄수) | 오시 = **종이상품** 후가공(`인쇄후가공` 시트) | **G-PAPER만**(엽서·전단지·쿠폰) | 10~38⚠️ | 높음 |
| COMP_PP_PERF_1L | 미싱비 | proc·min_qty·dim_vals(줄수) | 미싱 = **종이상품** 후가공 | **G-PAPER만** | 38⚠️ | 높음 |
| COMP_PP_VARTEXT_1EA/2EA/3EA | 가변텍스트 | proc·min_qty·dim_vals(개수) | 가변데이타 = **종이상품**(쿠폰/상품권/엽서) 후가공 | **G-PAPER만** | 10~38⚠️ | 높음 |
| COMP_PP_VARIMG_1EA/2EA/3EA | 가변이미지 | proc·min_qty·dim_vals(개수) | 가변데이타 = **종이상품** 후가공 | **G-PAPER만** | 10~38⚠️ | 높음 |
| COMP_PP_CORNER_RIGHT/ROUND | 귀돌이비 직각/둥근 | proc·min_qty | 귀돌이 = **종이상품** 후가공(직각/둥근) | **G-PAPER만** | 38⚠️ | 높음 |
| COMP_PRINT_SPOT_WHITE_S1(+색별 S1/S2) | 별색인쇄비 | plt_siz·proc·print_opt·min_qty | 별색 = **국4절 디지털인쇄** 독립 comp(SOT 2 예시·"3절 별색 없음") | **G-PAPER만**(국4절 엽서·쿠폰) | 37⚠️ | 높음 |
| COMP_CUT_PERF_1H6 | 타공비 1구 | min_qty | 타공 = 종이변형(헤더택·배경지·접지카드) | G-PAPER-VAR·G-FOLD | 7 | 높음 |
| COMP_FOLD_CARD_2H | 접지비 카드 2단 | min_qty | 접지 = 접지물·종이변형 | G-FOLD·G-PAPER-VAR | 4 | 높음 |
| COMP_FOLD_LEAF_3FOLD/4ACC/4GATE/HALF | 접지비 리플렛 | min_qty | 리플렛 접지 = 접지물 | G-FOLD | 3 | 높음 |
| COMP_CUT_FULL_DIECUT | 완칼 커팅 | siz·min_qty | 완칼 = 모양엽서·라벨택·썬캡 | G-PAPER-VAR | 3 | 높음 |
| COMP_POSTER_ARTPRINT_PHOTO | 실사 완제품가(아트프린트·접착방수·아트패브릭·방수) | sw·sh | **면적매트릭스 실사 결합**(동형 단가 4상품 — 메모리 [[dbmap-price-component-grouping]] 정합) | G-POSTER(해당 4) | 4 | 높음 |
| COMP_POSTER_CANVAS_FABRIC | 실사 완제품가(캔버스·레더·메쉬·타이벡) | sw·sh | 면적매트릭스 실사 결합(동형 단가 4상품) | G-POSTER(해당 4) | 4 | 높음 |
| COMP_NAMECARD_STD_S1/S2 | 스탠다드명함 완제품가 | mat·min_qty | 명함 고정가 = 코팅/스탠다드/프리미엄명함 공유 공식 | G-NAMECARD | 3 | 높음 |
| COMP_PHOTOCARD_SET/CLEAR_SET | 포토카드 완제품가 | siz·bdl·min_qty | 포토카드 = 일반/투명 공유 | G-PHOTOCARD | 2 | 높음 |
| COMP_BIND_JUNGCHEOL | 제본비 중철 | proc·min_qty | 제본 = 책자 공유(중철/무선/PUR/트윈링) | G-BOOKLET | 4 | 높음 |
| COMP_STK_PRINT | 스티커 완제품가 | siz·mat·min_qty | 스티커 = 13 자유형/반칼 스티커 공유 | G-STICKER | 13 | 높음 |

> **⚠️ 표기 의미:** 후가공 comp(CREASE/PERF/VAR*/CORNER/SPOT)의 reach가 37~38인 것은 **결합형 정당성이 아니라 오배선**이다. 이들의 **진짜 유효 상품군 = G-PAPER만**(reach 10이 정당, 28~38은 포스터 오배선 포함). §4 위반보드 참조.

---

## 4. 독립형 comp (단일 상품군 — 위반 없음)

comp_nm이 상품군을 명명하고 reach=1~4가 그 상품군 내인 comp. **63 wired 중 후가공 7개·결합형 ~18개를 뺀 나머지 ~38개가 독립형 — 전부 정합(위반 0).** 대표:

| 패턴 | 예 comp_cd | 유효 상품군 | reach | 정합 |
|------|-----------|--------|:--:|:--:|
| `COMP_POSTER_<소재>_*` 완제품가 | BANNER_NORMAL·FOAMBOARD_WHITE·FRAMELESS_WOOD·JOKJA·MESH_BANNER·MINI_BANNER·SHEETCUT_*·PET_BANNER 등 | G-POSTER / G-POSTER-FIX (해당 1상품) | 1 | ✅ 본체 면적매트릭스/고정가 정합(dimension-matrix §2) |
| `COMP_POSTER_ACRYLSTK_*` | GLOSS·MIRROR | G-ACRYLSTK(해당 1) | 1 | ✅ |
| `COMP_ACRYL_*` | CLEAR3T | G-ACRYL(아크릴키링) | 1 | ✅ 면적+두께(dimension-matrix §3) |
| `COMP_NAMECARD_*` (STD 외 PEARL/WHITE/FOIL/SHAPE 등) | — | G-NAMECARD | unwired多 | △ 대부분 미배선=data-gap(§6) |
| `COMP_STK_PACK·TATTOO` | — | G-STICKER(팩·타투) | 1 | ✅ |
| `COMP_PCB_S1_20P·S2_20P` | — | G-PCB(엽서북) | 1 | ✅ |
| `COMP_ENV_MAKING` | — | G-ENV(봉투) | 1 | ✅ |
| `COMP_GANGPAN_PRINT` | — | G-STICKER(합판도무송) | 1 | ✅ |
| `COMP_POSTEROPT_LINEN_FINISH` | — | G-POSTER(린넨만·opt_cd) | 1 | ✅ 린넨 마감 정당(opt_cd 차원) |

> **독립형 위반 0 근거:** 각 독립형 comp는 바인딩된 1상품이 comp_nm 명명 상품군과 일치(예: `COMP_POSTER_JOKJA`→족자포스터). 라이브 reach 실측으로 교차 상품군 도달 0건 확인.

---

## 5. ★유효성 위반 후보 = 7 광역 후가공 comp (정답: G-PAPER만)

**SOT 1 권위 판정 — 다음 7 comp는 G-PAPER(종이인쇄물) 후가공이며, 그 외 상품군에 유효하지 않다.**

| comp_cd | comp_nm | 진짜 유효 상품군 | 정당 reach | 실제 reach | 오배선 reach | 근거 |
|---------|---------|--------|:--:|:--:|:--:|------|
| COMP_PP_CREASE_1L | 오시비 | G-PAPER | 10(엽서·전단지·쿠폰) | 38 | **28(포스터)** | 오시=종이 접힘선 후가공·포스터 시트에 오시축 없음(authority §2) |
| COMP_PP_CORNER_RIGHT | 귀돌이비 직각 | G-PAPER | 10 | 38 | 28 | 귀돌이=종이 모서리 후가공 |
| COMP_PP_CORNER_ROUND | 귀돌이비 둥근 | G-PAPER | 10 | 38 | 28 | 동상 |
| COMP_PP_PERF_1L | 미싱비 | G-PAPER | 10 | 38 | 28 | 미싱=종이 절취선 후가공 |
| COMP_PP_VARTEXT_1EA | 가변텍스트 | G-PAPER(쿠폰/상품권/엽서) | 10 | 38 | 28 | 가변데이타=종이 인쇄 후가공 |
| COMP_PP_VARIMG_1EA | 가변이미지 | G-PAPER | 10 | 38 | 28 | 동상 |
| COMP_PRINT_SPOT_WHITE_S1 | 별색인쇄비 | G-PAPER(국4절) | 9 | 37 | **28(포스터)** | 별색=국4절 디지털인쇄 독립 comp(SOT 2 명시·"3절 별색 없음") |

> **확신도 높음** — authority-golden §2가 "실사/현수막/포스터 = 면적매트릭스 단가형, **소재·가로·세로뿐**, 완성단가(코팅포함가), 합산 아님, 수량 무관"을 권위로 명시. 종이 후가공축은 포스터 시트에 부재. SOT 2가 별색을 "국4절 독립 comp"로 명시. → 7 comp의 포스터 도달은 전부 SOT 1 차원경계 위반.
>
> **단, "정당 reach=10"의 미세 컨펌(SOT 7 오염검증 큐):** G-PAPER 내에서도 어느 종이상품이 어느 후가공을 실제 허용하는지(예: 쿠폰에 귀돌이?)는 상품마스터 종이시트 후가공 컬럼 전수 대조로 더 좁힐 수 있음 — 본 매트릭스는 "상품군 레벨"까지 확정, "상품 레벨" 정밀화는 후속(authority 종이시트 후가공 컬럼 컨펌).

---

## 6. unwired comp (83개) = data-gap, 유효성 위반 아님

`t_prc_price_components`에 있으나 `t_prc_formula_components` 미배선 83 comp. 대부분 **per-product 완제품가·addon·박셋업** — 상품군 귀속은 comp_nm으로 명확(`COMP_NAMECARD_PEARL_S1`→명함, `COMP_TTEOKME`→떡메모지, `COMP_POSTEROPT_BANNER_*`→현수막 add-on). **미배선 = 가격사슬 미완성(data-gap·dbmap 적재 트랙)이지 오배선(binding violation) 아님.** 본 트랙 범위 밖(가격사슬 완성은 dbm-price-* / round-21 위임). 단 향후 배선 시 §3·§4 유효 상품군 목록을 준수해야 함.

대표 unwired 상품군 귀속(향후 배선 시 정답):
- `COMP_NAMECARD_{PEARL,WHITE,FOIL,SHAPE,MINISHAPE,PREMIUM,CLEAR,COAT}_*` → **G-NAMECARD만**
- `COMP_POSTEROPT_BANNER_*`(큐방/끈/타공/봉미싱/열재단), `COMP_POPT_BNR_GAKMOK_*`(각목+끈), `COMP_POSTEROPT_{CANVAS_HANGING,JOKJA,PET_BANNER,LINEN_WOODBONG}_*` → **G-POSTER 해당 상품만**(현수막 add-on은 현수막에만)
- `COMP_BIND_{CAL_*,HC_*,MUSEON,PUR,SSABARI,TWINRING}` → **G-BOOKLET / 캘린더만**
- `COMP_FOLD_*`(미배선분), `COMP_CUT_FULL_PERF_*` → 종이/접지군
- `COMP_TTEOKME` → 떡메모지(문구), `COMP_PHOTOCARD_BULK` → 포토카드

---

## 7. 출처·재현 SQL 색인

| 주장 | 출처/SQL |
|------|---------|
| 146 comp·63 wired·83 unwired·301 배선·76 바인딩 | 라이브 count (§probe) |
| comp 광역 reach(7개 37~38, 나머지 ≤19) | `WITH reach AS (SELECT fc.comp_cd, count(DISTINCT b.prd_cd) FROM t_prc_formula_components fc LEFT JOIN t_prd_product_price_formulas b ON b.frm_cd=fc.frm_cd GROUP BY 1)` |
| comp_nm 상품군 명명 | `SELECT comp_cd,comp_nm,use_dims FROM t_prc_price_components` |
| 7 후가공 comp가 28 포스터공식 배선 | `SELECT comp_cd,count(DISTINCT frm_cd) FROM t_prc_formula_components WHERE frm_cd LIKE 'PRF_POSTER_%' AND comp_cd IN(...) GROUP BY 1` → 각 28 |
| 후가공 comp 단가행 size차원 NULL(wildcard) | `SELECT comp_cd,count(*) FILTER(WHERE plt_siz_cd IS NULL AND siz_cd IS NULL AND siz_width IS NULL AND siz_height IS NULL) FROM t_prc_component_prices WHERE comp_cd IN(...) GROUP BY 1` → CREASE/CORNER/PERF/VAR* 전부 NULL, SPOT 0 |
| 면적매트릭스=완성단가 합산아님 | authority-golden.md:86 (`huni-price-quote/02_authority`) |
| 별색=국4절 독립 comp | sot-definitions.md:37(SOT 2) · authority-golden.md:54 "3절 별색 없음" |
| PRF_POSTER_FIXED만 후가공블록 0 | `SELECT frm_cd ... HAVING count(*) FILTER(...)=0` → PRF_POSTER_FIXED |
