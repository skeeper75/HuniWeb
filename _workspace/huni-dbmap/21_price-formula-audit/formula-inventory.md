# 가격공식 전수 인벤토리 + 4축 판정 — round-17 (dbm-price-formula-audit)

> 작성 2026-06-13 · **생성자(auditor) 산출 — 자기 GO 판정 금지**(검증은 dbm-validator F1~F5 별도).
> 권위 순서: ① 라이브 information_schema 실측 ② webadmin `price_views.py` 소스 ③ admin 실제 화면(BLOCKED — bun 미설치, 후술) ④ round-16 `20_price-import/`·`18_schema-change/impact-diagnosis.md` 인용.
> 방법: 라이브 `db railway` 읽기전용 SELECT만(비밀번호 비노출). DB 직접 쓰기 0.

---

## 0. frm_typ_cd 결판 (검증 1순위) — **라이브 부재 CONFIRMED**

작업 지시는 "`raw/webadmin/.../price_views.py:234`가 `frm_cd__frm_typ_cd == "FRM_TYPE.01"`(합산형)을 실제 사용하므로 round-16의 'frm_typ_cd 라이브 부재' 전제와 모순"이라 했다. **이 전제는 사실이 아니다.** 라이브 + 소스 양면 실측 결과:

| 결판 경로 | 실측 결과 |
|-----------|-----------|
| **라이브 `t_prc_price_formulas` 컬럼**(information_schema) | `frm_cd · frm_nm · note · use_yn · reg_dt · upd_dt` — **`frm_typ_cd` 컬럼 자체가 라이브에 없음** |
| **`price_views.py` 전수 grep** | `frm_typ_cd`·`frm_cd__frm_typ_cd` **단 1회도 등장 안 함**. `price_views.py:234`(grade_rates 라인)는 `dsc_rate`/`dsc_amt` 처리이지 frm_typ가 아님 |
| **`FRM_TYPE.01` 비교가 실제 쓰이는 곳** | 없음. 화면이 쓰는 유형 축은 **`t_prc_price_components.prc_typ_cd`**(PRICE_TYPE.01 단가형 / .02 합가형) — `price_views.py:44 PRC_TYPE_LABEL`, `:182`, `:293`에서 **component 레벨**로만 사용 |
| **webadmin 소스 DDL 선언** | `sql/01a_tables_master.sql:187`은 `frm_typ_cd varchar(50) NOT NULL` **선언함**(FK→FRM_TYPE enum). `sql/02_foreign_keys.sql:206`·`04_indexes.sql:91`·`07_comments.sql:128`·`05_seed.sql:286`(FRM_TYPE 3행 seed)도 존재 |

### 결판: `frm_typ_cd`는 **소스 DDL에는 선언됐으나 라이브 DB에는 적용 안 된** 컬럼이다.
- round-14 `18_schema-change/impact-diagnosis.md`가 확립한 "**선언(git) ≠ 적용(라이브)**" 패턴의 또 다른 사례. 단, impact-diagnosis §3 표가 다룬 컬럼들(proc_cd·opt_cd·prc_typ_cd·use_dims)은 "DDL 갭 0"이었는데, **frm_typ_cd는 그 표에 없다** → frm_typ_cd는 적용 누락(DDL 갭 1)로 남아있는 별개 케이스.
- round-16 빌더/검증자가 acrylic-gate `:19,:24`에서 "frm_typ_cd 부재" 전제로 작업한 것은 **라이브 기준 정확**(개념설계 11-CONTEXT `frm_typ_cd 2종`은 소스/설계 의도이지 라이브 적용분 아님).
- 화면(`price_views.py`)이 공식유형을 화면에 노출하는 경로는 **공식 레벨(frm_typ_cd) 아니라 구성요소 레벨(prc_typ_cd 단가형/합가형)**이다. 즉 공식 자체에는 "유형 라벨"이 라이브에 없고, 실무진이 보는 유형은 구성요소의 단가형/합가형뿐.

### 함의 (A·B축으로 직결)
공식 인벤토리에 **유형 컬럼이 라이브에 없으므로**, 실무진이 "이 공식이 합산형인지 단순형인지"를 화면의 구조화된 필드로 볼 방법이 없다. 현재는 **`note`(자유텍스트)의 "합산형:"/"단순형:" 접두어**가 유일한 유형 신호다(아래 표 참조). 이는 B축(가독성)의 핵심 개선점이자, frm_typ_cd 백필(인간 승인)의 근거다.

---

## 1. 라이브 스키마 실측 (4테이블)

| 테이블 | 라이브 컬럼 | 행수 |
|--------|-----------|------|
| `t_prc_price_formulas` | frm_cd, frm_nm, note, use_yn, reg_dt, upd_dt (**frm_typ_cd 없음**) | **16** |
| `t_prc_formula_components` | frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt, upd_dt | **85** |
| `t_prd_product_price_formulas` | prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt, upd_dt | **63** |
| `t_prc_price_components` | comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, upd_dt, **prc_typ_cd**, **use_dims**(jsonb) | **144** |
| (단가행) `t_prc_component_prices` | …10차원… | 3,481 |

- `prc_typ_cd` 144행 중 NULL **0** · `comp_typ_cd` NULL **0** · `use_dims` NULL **2**(2행은 미배선 포스터 add-on comp).
- `t_prd_product_prices`(직접 단가) **0행** — 모든 가격은 공식 경로(63 상품 바인딩)로만 흐름.

---

## 2. 전수 인벤토리 + 4축 판정

배선수 = `formula_components` 조인 · 연결상품 = `product_price_formulas` distinct prd_cd · 단가행유무 = 배선된 comp가 `component_prices` 행 보유 여부.

| frm_cd | frm_nm | use_yn | 배선 | 연결상품 | 단가행완결 | **A 정리** | **B 가독성** | **C 사용성(배선)** | **D 뷰어노출** |
|--------|--------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| PRF_BIND_SUM | 제본 합산형(제본비 구성요소) | Y | 1 | 4 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_DGP_A | 디지털인쇄 원자합산형A 엽서·상품권·슬로건 | Y | 29 | 9 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_DGP_B | 디지털인쇄 원자합산형B 모양엽서·라벨택 | Y | 4 | 2 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_DGP_C | 디지털인쇄 원자합산형C 인쇄배경지·헤더택 | Y | 5 | 3 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_DGP_D | 디지털인쇄 원자합산형D 소량전단지 | Y | 20 | 1 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_DGP_E | 디지털인쇄 원자합산형E 접지카드·접지리플렛 | Y | 10 | 3 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_DGP_F | 디지털인쇄 원자합산형F 썬캡(미출시) | **N** | 4 | 1 | ✅ | ✅ | 🟡 | 🟡 | 🟡 |
| PRF_ENV_MAKING | 봉투제작 소재/수량별 단가 | Y | 1 | 1 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_FOLD_SUM | 접지 합산형(오시+접지 후가공 구성요소) | Y | 1 | 1 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_GANGPAN_FIXED | 합판도무송 사이즈/소재/수량별 단가 | Y | 1 | 1 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_NAMECARD_FIXED | 명함 면/소재/수량별 단가(용지포함) | Y | 2 | 3 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_PCB_FIXED | 엽서북 사이즈/면/페이지/수량별 단가 | Y | 2 | 1 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_PHOTOCARD_FIXED | 포토카드 세트 고정가 | Y | 2 | 2 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_POSTER_FIXED | 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격) | Y | 1 | 28 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| PRF_STK_FIXED | 스티커 규격/소재/수량별 단가 | Y | 1 | 3 | ✅ | ✅ | 🟡 | ✅ | ✅ |
| **PRF_TTEOKME_FIXED** | 떡메모지 사이즈/권당장수/장수별 단가 | Y | 1 | **0** | ✅ | 🟡 | **🔴** | **🔴** | **🔴** |

### 축별 집계
- **A 정리 상태**: 16/16 ✅. frm_nm·note·use_yn 전건 채움, 빈 note 0, 중복 frm_cd 0. **단 frm_typ_cd 컬럼 부재로 "유형" 구조화 필드는 없음**(note 접두어로만 표현) — A는 통과하되 §0 결판이 구조적 한계로 남음.
- **B 가독성**: 16/16 🟡. frm_nm은 한국어로 양호하나 **note 15/16이 "(계산공식집초안 행N)" 내부 행번호를 노출**, 5/16이 "component/comp" 영문 약어 노출. 비개발자가 코드 없이 "무슨 상품·무슨 계산"은 대체로 이해 가능하나, 내부 인용·약어가 끼어 즉시성 저하 → 전건 🟡(결함 🔴은 아님).
- **C 사용성(배선)**: 15/16 ✅, 1 🔴. **PRF_TTEOKME_FIXED 연결상품 0** = 고아 공식(배선 1은 있으나 어떤 상품도 이 공식을 안 가리킴). PRF_DGP_F는 use_yn=N(미출시)이라 🟡.
- **D 뷰어노출**: 15/16 정상, 1 🔴(TTEOKME), 1 🟡(DGP_F). C가 깨지면 D도 깨진다 — 떡메모지는 `price_product_detail`의 `current_source`가 NONE으로 떨어져 뷰어 좌측 트리에서 "가격원천 없음" 배지.

### 가격사슬 완결성 (round-16 "단절"과의 정합)
**16개 라이브 공식 자체는 사슬 단절 0** — 모든 배선 comp가 `component_prices` 행 보유(EMPTY 배선 0건, 실측). round-16이 발견한 "가격사슬 단절"(아크릴·코롯토 등)은 **공식이 아예 없는 상품군**(라이브 `t_prc_price_formulas`에 행 없음)이거나 **배선 안 된 고아 단가행**이지, 위 16공식 내부의 단절이 아니다. 즉 **존재하는 16공식은 내부 완결, 문제는 "필요한데 공식이 없는" 상품군**이다(아래 §3).

---

## 3. 횡단 발견 (공식 인벤토리 밖의 사용성·뷰어 결함의 원천)

| # | 발견 | 실측 | round-16 연결 |
|---|------|------|---------------|
| X-1 | **275 상품 중 212가 가격원천 0**(공식 63·직접가 0·NONE 212) | `price_views.py` build_product_tree 배지 = NONE | round-16 acrylic-gate 🔴 가격사슬 단절(공식 0개·바인딩 0)의 macro 집계 |
| X-2 | **PRF_TTEOKME_FIXED 고아** — 떡메모지(PRD_000097/098) 실재하나 미바인딩 | `product_price_formulas`에 PRF_TTEOKME 0행 | round-16 postcard-book-memo 시트가 떡메 공식 제안했으나 바인딩 미완 |
| X-3 | **2 포스터 add-on comp 미배선**(COMP_POPT_BNR_GAKMOK…, COMP_POSTEROPT_BANNER_MESH…) `use_dims=NULL`·배선 0 | 공식에 안 묶인 고아 component | poster-sign 추가옵션 통가격 add-on, formula_components 미연결 |
| X-4 | **frm_typ_cd 라이브 부재**(§0) — 공식유형 구조화 필드 없음 | information_schema 실측 | round-16 전 시트가 `1_price_formulas`에 frm_typ_cd 안 넣음(정당) |
| X-5 | **PRF_DGP_F(썬캡) use_yn=N인데 PRD_000051 바인딩 유지** | 미출시 공식·미출시 상품 일관 | — (의도된 미출시 보존, 결함 아님) |
| X-6 | **배선 85건 전부 addtn_yn=Y** | 단순형(1 comp)엔 무해, 합산형에선 "전 구성요소 가산" 의미 | 합산형 공식의 base+add 구분 부재 가능성(별색 등) — round-16 digital-print 참조 |

---

## 4. admin 실제 화면 3중 대조 — **BLOCKED (소스+DB로 판정)**

`gstack browse`가 의존하는 `bun` 런타임 미설치로 라이브 admin 가격뷰어 화면 캡처 실패. 방법론대로 **소스(`price_views.py`)+DB 실측 2축으로 노출 경로를 판정**하고 화면 캡처는 블로커로 기록한다.

- **소스 권위 확정**: `price_product_detail`(`price_views.py:146`)이 `frm_cd__frm_nm`을 조인해 공식명을 JSON으로 내보내고(`:244-246`), `components` 배열에 각 배선 comp의 `comp_nm·prc_typ(단가형/합가형 라벨)·dims·row_count`를 노출(`:177-185`). `price_comp_usage`(`:398`)는 comp→공식→연결상품 역추적. `price_select_options`(`:521`)는 전 16공식을 셀렉트 옵션으로 노출. → **공식명·구성요소·연결상품이 화면에 노출되는 쿼리 경로는 소스로 확정**.
- **DB 실측 확정**: 위 쿼리가 집는 데이터(공식 16·배선 85·바인딩 63)가 라이브에 실재. TTEOKME는 바인딩 0이라 `price_product_detail`이 떡메모지 상품에서 `current_source=NONE` 반환(화면 미노출) — 소스 로직으로 결정적 판정 가능.
- **남는 미확정**: 실제 픽셀 렌더(배지 색·레이아웃)만 미확인. 가독성(B축) 판정은 note 텍스트가 DB 권위이므로 화면 없이도 유효.

> 블로커 해소법: `bun` 설치 후 `gstack browse goto .../admin/price-viewer/` 로 대표 3공식(POSTER_FIXED·DGP_A·TTEOKME) 우측 패널 재확인. 인간/다음 세션.

---

## 부록: 증거 쿼리 (재현용)
- 인벤토리: `SELECT f.frm_cd,f.frm_nm,f.note,f.use_yn,(배선),(연결상품) FROM t_prc_price_formulas f ORDER BY frm_cd`
- 사슬 완결: `formula_components fc JOIN price_components c LEFT JOIN (component_prices GROUP BY comp_cd)` — EMPTY 배선 0 실측
- 커버리지: `t_prd_products LEFT JOIN product_price_formulas LEFT JOIN product_prices` → 275/63/0/212
- frm_typ 결판: `information_schema.columns WHERE table_name='t_prc_price_formulas'` + `grep -rn frm_typ_cd raw/webadmin`
