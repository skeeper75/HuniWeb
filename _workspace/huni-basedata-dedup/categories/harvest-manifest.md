# Harvest Manifest — 카테고리 축 (t_cat_categories) — Phase 1 추출

추출시각: 2026-06-19 (KST)
추출가: hbd-source-harvester
방법론: hbd-source-harvest (라이브 read-only SELECT + round-24 35_category-map 캐시 재사용 — .xlsx Read 0회)

## 출처 / freshness
| 출처 | 행수 / freshness | 용도 | 재사용 vs 신규 |
|------|------------------|------|----------------|
| 라이브 t_cat_categories (Railway, read-only) | total **326** / del_yn='N' **79** / use_yn='Y' 315 / max upd_dt **2026-06-19 01:22:53** (round-24 정리 후 상태·stale 아님) | live | **신규** (오라클 기준값과 전건 일치) |
| 라이브 t_prd_product_categories (junction) | links **364** / distinct cat **55** / distinct prd **273** | product_bindings | 신규 |
| 라이브 t_dsc_grade_discount_rates (cat_cd 데이터) | **0행** | price_dependent 근거 | 신규 |
| `_workspace/huni-dbmap/35_category-map/map-entries.csv` | 321행 / mtime 2026-06-18 11:59 | authority (MAP 시트 = 고객 카테고리 IA) | **재사용** (round-24 검증 GO 산출) |
| `_workspace/huni-dbmap/35_category-map/_meta/alias-dict.csv` | 21행 / 2026-06-18 | 별칭 crosswalk (참고) | 재사용 |

## 스키마 노트 (사이즈·공정 축과의 차이)
- **proc_typ_cd / note / 유형 컬럼 없음.** 카테고리의 의미축 = **계층 (upr_cat_cd 자기참조 FK + cat_lvl)**. 표시명이 같아도 부모·레벨이 다르면 다른 IA 위치 (디자인캘린더 분기 사례).
- raw_value_json에 upr_cat_cd + parent_nm + cat_lvl + child_cnt(del_yn='N') + disp_seq + use_yn 인코딩.

## 행수 대조 (D1 게이트)
| 산출물 | 행수 | 대조 |
|--------|------|------|
| live.csv | 326 (데이터) + active 플래그 | = 라이브 total 326 ✅ (active='Y' 79 = del_yn='N' 79 ✅) |
| index.csv | **79** | = 라이브 del_yn='N' 활성 79 ✅ |
| authority.csv | 321 | = map-entries.csv verbatim (round-24 MAP IA) |

## price_dependent = N (확정)
- t_prc_component_prices에 **cat_cd 컬럼 없음** (information_schema 실측 0).
- t_dsc_grade_discount_rates.cat_cd **데이터 0행**.
- → 카테고리는 가격 비종속 (공정과 다름). index.csv 전 79행 price_dependent='N'.
- 단 junction `t_prd_product_categories` (364 links / 55 distinct cat / 273 prd) 에 상품귀속 존재 → **논리삭제 시 무손실 재배선 고려 대상** (가격사슬 CASCADE는 아님).

## 3 표시중복 그룹 (del_yn='N', cat_nm 동일·cat_cd 다름) — 전수 (활성 79 중 추가 그룹 없음 확인)
| 그룹 | 멤버 (cat_cd·lvl·부모) | 계층경로 | 자식수(N) | 상품귀속 | MAP 권위 매칭 |
|------|------------------------|----------|-----------|----------|---------------|
| 벽걸이캘린더 | CAT_000115 (L2·부모007 캘린더) | 캘린더 > 벽걸이캘린더 | 0 | **2** | MAP §07 G7 section ▶︎벽걸이캘린더 + G8 product |
|  | CAT_000319 (L3·부모118 디자인캘린더) | 디자인캘린더 > 벽걸이캘린더 | 0 | **0** (빈노드) | MAP §07 G16 ▶︎디자인캘린더 → G19 벽걸이캘린더 재리스트 |
| 탁상형캘린더 | CAT_000112 (L2·부모007 캘린더) | 캘린더 > 탁상형캘린더 | 0 | **3** | MAP §07 G2 section ▶︎탁상형캘린더 + G3 product |
|  | CAT_000318 (L3·부모118 디자인캘린더) | 디자인캘린더 > 탁상형캘린더 | 0 | **0** (빈노드·★라이브 재측정 정정: 기준값 1 → 실측 0) | MAP §07 G16 ▶︎디자인캘린더 → G17 탁상형캘린더 재리스트 |
| 하드커버책자 | CAT_000104 (L2·부모006 책자) | 책자 > 하드커버책자 | **3** | **0** (컨테이너) | MAP §06 F8 section ▶︎하드커버 |
|  | CAT_000105 (L3·부모104 자기동명) | 하드커버책자 > 하드커버책자 | 0 | **22** (잎노드) | MAP §06 F9 product 하드커버책자 |

## ★1순위 의심 (dedup-analyst 주목)
- **빈노드 318/319** (디자인캘린더 분기·자식0·상품0): MAP IA 권위에서 `▶︎디자인캘린더`(G16) 섹션이 탁상형/벽걸이캘린더를 **재리스트**한 것. 즉 의미축(IA 위치)은 정당히 다름(캘린더 직속 vs 디자인캘린더 하위)이나, **라이브 실데이터가 비어 있어** 표시중복으로만 보이는지 / 진짜 false-positive 가드 대상인지 = dedup-analyst 1차 판정점. round-24가 240노드 논리삭제 후 잔존한 빈노드일 가능성.
- **동명 컨테이너/잎 104·105** (하드커버책자 L2 컨테이너 자식3 vs L3 잎 상품22): MAP의 `▶︎하드커버`(섹션) → `하드커버책자`(상품) 구조 그대로. 부모-자식 동명 (CAT_000105 부모=CAT_000104 동명). **컨테이너/잎 분리는 정당 의미축 분리로 보이나** 표시명이 화면에서 양쪽 다 "하드커버책자"로 노출되면 사용자 혼란 → 표시중복 후보. (사이즈 SIZ_104/105 byte-identical 진짜중복과 구조 유사 — 주의.)

## 토큰절약 노트
- .xlsx 2종 Read 0회. 라이브 SELECT + round-24 검증 캐시(map-entries) 재사용. 추출 결과는 집계/샘플만 표시.
- 이후 dedup-analyst 탐색은 live.csv / index.csv / authority.csv + `_childcnt`/`_bindcnt`/`_live_raw` 중간파일에 Grep·집계로 처리 (엑셀 재오픈 불요).

## 날조 0 선언
- live.csv·authority.csv는 라이브/round-24 캐시 verbatim. index.csv는 그 둘의 결정적 조인 (파생 추론 0·child/bind 카운트는 라이브 GROUP BY 실측).
- ★기준값 1건 정정: CAT_000318 상품귀속 기준값 1 → 라이브 직접 재측정 **0** (junction에 행 없음·근거: `SELECT prd_cd FROM t_prd_product_categories WHERE cat_cd='CAT_000318'` = 0행).

## 산출물 경로
- `_workspace/huni-basedata-dedup/categories/live.csv` (326행, 11컬럼 + active 플래그)
- `_workspace/huni-basedata-dedup/categories/index.csv` (79행, 표준 인덱스 9컬럼)
- `_workspace/huni-basedata-dedup/categories/authority.csv` (321행, MAP IA verbatim 재사용)
- `_workspace/huni-basedata-dedup/categories/harvest-manifest.md`
- (중간) `_live_raw.tsv` (326 전건) · `_childcnt.tsv` · `_bindcnt.tsv`
