# 디지털인쇄 — 라이브 실측 vs 기대값 대조 (live-diff · round-13 C3)

> **작성** 2026-06-10 · round-13. 각 상품의 라이브 t_* 행을 읽기전용 psql로 전수 측정하고 extraction-plan(C2) 정답값과 field-for-field 대조. 재현 SELECT 포함(비밀값 비노출).
> **측정 대상:** 앵커 대표상품 — 엽서 PRD_000016 · 상품권 PRD_000041/042 · 배경지 PRD_000043/044/045 · 라벨택 PRD_000046.
> **재현 전제:** `set -a; source .env.local; set +a; PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "<SQL>"` (SELECT only).

---

## 1. 엽서 PRD_000016 (프리미엄엽서 · 일반 인쇄물)

| 축 | 라이브 실측 | 기대값(정답) | 대조 |
|----|-------------|--------------|:--:|
| size | 7 행: 73x98·98x98·100x150·135x135·95x210·110x170·148x210 | 엑셀 nonblank 사이즈 **7행**(동일) | ✅ CORRECT (round-12 "13종" 주장은 오류) |
| 자재 | 21 행, 전부 usage=USAGE.07 | 종이 다수 + USAGE.07 공통 | ✅ CORRECT |
| 공정 | 6 행: PROC_000027/028(모서리)·029(오시)·030(미싱)·031/032(가변) | 엑셀: 모서리·오시·미싱·가변(별색/코팅/커팅 **없음**) | ✅ CORRECT(엑셀 빈값 정합) |
| 도수 | opt1 단면(f=CLR_000005 b=CLR_000001)·opt2 양면(both CLR_000005) | 단면/양면 2옵션 | ✅ CORRECT |
| plate | 1 행 OUTPUT_PAPER_TYPE.01 | 316x467→.01 국전계열 | ✅ CORRECT(값 정답·적재경로는 후속 손작업) |
| addon | TMPL-000005 1행(OPP접착봉투) | 엑셀 C38: 엽서봉투·OPP비접착·카드봉투(화이트/블랙)·트레싱지봉투 등 다수 | 🟡 MIS-LOADED(1/다수만) |

재현:
```sql
-- size 7행
SELECT s.cut_width||'x'||s.cut_height FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000016' ORDER BY ps.disp_seq;
-- 공정 6행
SELECT proc_cd FROM t_prd_product_processes WHERE prd_cd='PRD_000016' ORDER BY proc_cd;
-- addon
SELECT tmpl_cd FROM t_prd_product_addons WHERE prd_cd='PRD_000016';
```

---

## 2. 상품권 PRD_000041 / 042 (일반 인쇄물)

| 축 | PRD_000041 실측 | PRD_000042 실측 | 기대값(정답) | 대조 |
|----|------|------|------|:--:|
| size | 2 행 | 2 행 | 엑셀 2종 | ✅ |
| 자재 | 4 행 USAGE.07 | (스타드림 다수) | 종이 12종 | 🟡 부분(자재 일부) |
| 공정 | 029(오시)·030(미싱)·031/032(가변) | 029·030·031·032 + **037~044(박색 8종)** | 041: 오시/미싱/가변 / 042: + 박 | 🟡 042 박색만 적재·부모 박 없음 |
| 도수 | 단/양면 2행 | 단/양면 2행 | 단/양면 | ✅ |
| plate | 1 행 .01 | 1 행 .01 | .01 | ✅ |
| 카테고리 | CAT_000295 상품권(upr=NULL 잉여 고아) | 〃 | 정상 판매 카테고리 노드로 재연결(상품권 정상 노드 확인 필요) | 🟡 오연결(잉여 고아 295에 연결, F-ID-3) |

> **상품권 042 박 구조 이상:** 라이브에 박색 자식(PROC_000037 홀로그램·038 금유광·039 은유광·040 먹유광·041 동박·042 적박·043 청박·044 트윙클 = 8종)이 연결됐으나 **부모 박 공정 PROC_000033은 미연결**. 엑셀은 `박(있음)` 단일 신호 — 8색 전개는 적재원 데이터의 과적재(또는 옵션 풀)일 가능성. 부모 누락은 "박 공정 있음" 성립 구조 결함.

재현:
```sql
SELECT p.proc_cd, pr.proc_nm FROM t_prd_product_processes p JOIN t_proc_processes pr ON p.proc_cd=pr.proc_cd WHERE p.prd_cd='PRD_000042' ORDER BY p.proc_cd;
SELECT cat_cd,cat_nm,COALESCE(upr_cat_cd,'NULL'),cat_lvl FROM t_cat_categories WHERE cat_cd='CAT_000295';  -- 상품권|NULL|3 (잉여 고아)
```

---

## 3. 배경지 PRD_000043 / 044 / 045 (포장 세트 — 핵심 교정거리)

| 축 | PRD_000043 실측 | PRD_000044 실측 | 기대값(정답) | 대조 |
|----|------|------|------|:--:|
| size | 6 행(76x100·76x120·86x120·94x94·62x180·105x160) | 2 행(74x74·74x109) | 엑셀 OPP 6종·케이스 2종 | ✅ CORRECT |
| 자재 | 1 행 USAGE.07(스노우250) | 1 행 USAGE.07 | 스노우250·몽블랑240 | 🟡 부분(스노우만, 몽블랑240 누락 가능) |
| 공정(커팅/접지) | **0 행** | **0 행** | OPP: 커팅 형상 ~13종(기본형/타공형/핀고정형/북마크/스마트톡형/카드고정형/키링형/폰스트랩형)·케이스: 접지(기본형/상하접지) | 🔴 **MISSING — 전용 커팅/접지 전면 미적재** |
| 도수 | 단/양면 2행 | 단/양면 2행 | 단/양면 | ✅ |
| plate | 1 행 .01 | 1 행 .01 | .01 | ✅ |
| **봉투 세트(축⑥)** | **addon=0·sets=0** | **addon=0·sets=0** | OPP: 6 사이즈×매칭 봉투 / 케이스: 2 사이즈×PP투명케이스 | 🔴 **MISSING — 봉투/케이스 세트 전면 미적재** |
| 카테고리 | 043→CAT_000296(NULL 잉여 고아) | 044→CAT_000296(〃) | 정상 노드 043→CAT_000273·044→CAT_000274(둘 다 upr=CAT_000012 포장, **이미 실재**) | 🔴 오연결(정상 노드 273/274 두고 잉여 고아 296에 연결, F-ID-3 정정) |
| 가격공식 | PRF_DGP_C | PRF_DGP_C | PRF_DGP_C(배경/헤더택) | ✅ |

재현:
```sql
SELECT count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000043';     -- 0
SELECT count(*) FROM t_prd_product_addons WHERE prd_cd IN ('PRD_000043','PRD_000044','PRD_000045');  -- 0
SELECT count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000043';          -- 0
SELECT c.cat_cd, cc.cat_nm FROM t_prd_product_categories c JOIN t_cat_categories cc ON c.cat_cd=cc.cat_cd WHERE c.prd_cd='PRD_000043';  -- CAT_000296 배경지 (잉여 고아)
-- F-GATE-1 재측정: 잉여 고아 296/295 + 이미 실재하는 정상 노드 273/274/275 한 판 대조
SELECT cat_cd,cat_nm,COALESCE(upr_cat_cd,'NULL'),cat_lvl FROM t_cat_categories WHERE cat_cd IN ('CAT_000012','CAT_000273','CAT_000274','CAT_000275','CAT_000295','CAT_000296') ORDER BY cat_cd;
--  CAT_000012 포장|NULL|1 · CAT_000273 인쇄배경지(OPP봉투타입)|CAT_000012|2 · CAT_000274 인쇄배경지(투명케이스타입)|CAT_000012|2
--  CAT_000275 인쇄헤더택|CAT_000012|2 · CAT_000295 상품권|NULL|3 · CAT_000296 배경지|NULL|3
-- 포장(012) 하위 정상 노드 전수:
SELECT cat_cd,cat_nm,cat_lvl FROM t_cat_categories WHERE upr_cat_cd='CAT_000012' ORDER BY cat_cd;  -- 273·274·275·276 봉투/케이스·283 라벨/포장스티커·285 포장부자재·287 상품액세서리
-- 봉투 template 재사용 가능(search-before-mint):
SELECT tmpl_cd, base_prd_cd, tmpl_nm FROM t_prd_templates WHERE tmpl_nm LIKE '%봉투%' OR tmpl_nm LIKE '%케이스%';
```

> **배경지 핵심 진단:** size·도수·plate·가격은 CORRECT지만, **정체(포장 세트)를 구성하는 (1) 전용 커팅 형상 (2) 봉투/케이스 세트 (3) 포장 카테고리 연결** 3가지가 전면 미적재/오연결. 특히 카테고리는 정상 포장 노드(273/274/275/283)가 **이미 실재**하는데 잉여 고아 노드(296/295)에 묶인 것(F-GATE-1 정정) — 교정은 기존 정상 노드로 재연결(search-before-mint). 일반 인쇄물로 봤다면 보이지 않을 결함 — C-ID 정체 선행이 잡아냄.

---

## 4. 라벨/택 PRD_000046 (포장 단품)

| 축 | 라이브 실측 | 기대값 | 대조 |
|----|------|------|:--:|
| size | **3 행** | 엑셀 3종(40x80·50x50·25x110) | ✅ |
| 공정(커팅 형상) | **0 행** | 사각/라운딩/삼각/팔각/원형/사각리본/삼각리본/리본 형상(완칼 param) | 🔴 MISSING |
| 카테고리 | **CAT_000296 배경지(upr=NULL 잉여 고아)** | **CAT_000283 라벨/포장스티커**(upr=CAT_000012 포장, 이미 실재) | 🔴 오연결(정상 노드 283 두고 고아 296에 연결) |

> 라벨/택은 봉투 세트 없는 단품이나 형상 커팅(완칼 param)이 핵심. 동형 배경지 커팅 미적재 패턴과 같은 결함군.

---

## 5. 대조 요약

| 상품 | CORRECT 축 | 결함 축 |
|------|-----------|---------|
| 엽서 016 | size·자재·공정·도수·plate | addon(1/다수 MIS-LOADED) |
| 상품권 041 | size·도수·plate | 자재 부분·카테고리 orphan |
| 상품권 042 | size·도수·plate | 박 부모 누락·카테고리 orphan |
| 배경지 043 | size·도수·plate·가격 | **커팅 MISSING·봉투세트 MISSING·카테고리 오분류** |
| 배경지 044 | size·도수·plate·가격 | **접지 MISSING·케이스세트 MISSING·카테고리 오분류** |
| 라벨택 046 | (plate) | 커팅 형상·카테고리 |

> **D-1 교훈 재확인:** "적재됨"=행 존재만 아님. 엽서는 변형 커버리지 완전(size 7/7 CORRECT)이나, 배경지는 size만 적재되고 정체 구성요소(세트/커팅/카테고리)는 미적재 = 행은 있으나 상품이 불완전.
