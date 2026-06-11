# 캘린더 + 디자인캘린더 — 라이브 전수 실측 vs 정답 diff (round-13 C3)

> **작성** round-13 Phase 2b. 읽기전용 SELECT만(INSERT/UPDATE/DDL 0). 비밀값 비노출. 각 셀 = 라이브 실측 vs `extraction-plan.md` 정답값 field-for-field 대조. 행 존재만이 아니라 변형 커버리지·코드값·FK 충족 포함(D-1 교훈).
> **접속:** `set -a; source .env.local; set +a; PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "..."` (비밀값 환경변수로만).

---

## 0. 상품 헤더 (5 form factor + 디자인 surface)

```sql
SELECT prd_cd, "MES_ITEM_CD", prd_nm, prd_typ_cd, file_upload_yn, editor_yn,
       min_qty, max_qty, qty_incr, qty_unit_typ_cd
FROM t_prd_products WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112');
```
| prd_cd | MES | prd_typ | upload | editor | min/max/incr | qty_unit | 정답 대조 |
|--------|:---:|---------|:------:|:------:|--------------|----------|-----------|
| 108 탁상 | **NULL** | PRD_TYPE.04 | Y | **N** | 1/10000/1 | QTY_UNIT.01 EA | MES=007-0001 정답·NULL(F-5)·editor 디자인 surface=Y여야(❌) |
| 109 미니 | NULL | .04 | Y | N | 1/10000/1 | .01 | 동일 |
| 110 엽서 | NULL | .04 | Y | N | 1/10000/1 | .01 | 동일 |
| 111 벽걸이 | NULL | .04 | Y | N | 1/10000/1 | .01 | 동일 |
| 112 와이드 | NULL | .04 | Y | N | 1/10000/1 | .01 | 동일 |

**판정:** prd_typ_cd(.04 디자인)·수량(min/max/incr)·qty_unit(.01 EA)·file_upload_yn(Y) = **정합**. MES_ITEM_CD NULL = 정답 007-0001~5 미반영(F-5·교정 후보). editor_yn=N = 디자인캘린더 surface 미반영(C diff).

---

## 1. 하위 t_* 적재 카운트 (5상품)

```sql
SELECT p.prd_cd, p.prd_nm,
  (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd=p.prd_cd) sizes,
  (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd=p.prd_cd) mats,
  (SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd=p.prd_cd) prnt,
  (SELECT count(*) FROM t_prd_product_plate_sizes WHERE prd_cd=p.prd_cd) plate,
  (SELECT count(*) FROM t_prd_product_processes WHERE prd_cd=p.prd_cd) proc,
  (SELECT count(*) FROM t_prd_product_page_rules WHERE prd_cd=p.prd_cd) pgrul,
  (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd=p.prd_cd) ogrp,
  (SELECT count(*) FROM t_prd_product_addons WHERE prd_cd=p.prd_cd) addon,
  (SELECT count(*) FROM t_prd_product_prices WHERE prd_cd=p.prd_cd) price
FROM t_prd_products p WHERE p.prd_cd IN ('PRD_000108'..'PRD_000112');
```
| 상품 | sizes | mats | prnt | plate | proc | pgrul | ogrp | addon | price | 정답 대조 |
|------|:----:|:---:|:---:|:----:|:---:|:----:|:----:|:----:|:----:|-----------|
| 108 탁상 | 2 | 10 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | size/print/plate ✅·proc 거치누락·장수/봉투 MISSING |
| 109 미니 | 2 | 9 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 동일 |
| 110 엽서 | 6 | 10 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | size 6 ✅·우드/봉투/장수 MISSING |
| 111 벽걸이 | 3 | 23 | 2 | 1 | 2 | 0 | 0 | 0 | 0 | mats 23(부속혼입)·proc 2 |
| 112 와이드 | 1 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | 0 | mats 4(종이3+링1) |

**판정:** sizes·print_options·plate·categories = 적재됨. **page_rules·option_groups·addons·prices = 전 상품 0** = 장수·캘린더가공 택일·봉투/우드거치대·디자인 가격 전부 MISSING.

---

## 2. 자재 — 본체 종이 vs 부속(삼각대/링) 혼입 [핵심 오적재]

```sql
SELECT pm.prd_cd, m.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd, pm.dflt_yn
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000112') AND m.mat_typ_cd<>'MAT_TYPE.01';
```
| 상품 | mat_cd | mat_nm | mat_typ_cd | usage_cd | dflt_yn | 정답 |
|------|--------|--------|-----------|----------|:-------:|------|
| 108 탁상 | MAT_000252 | 삼각대(그레이) | **MAT_TYPE.07 부속** | USAGE.07 | Y | ❌ 삼각대 거치=**공정**(자재 아님) |
| 108 탁상 | MAT_000253 | 링 블랙 | MAT_TYPE.07 | USAGE.07 | Y | ❌ 링=트윈링제본 **공정 param**(탁상은 트윈링도 아님 — 잉여) |
| 109 미니 | MAT_000254 | 삼각대(블랙) | MAT_TYPE.07 | USAGE.07 | Y | ❌ 삼각대=공정 |
| 109 미니 | MAT_000253 | 링 블랙 | MAT_TYPE.07 | USAGE.07 | Y | ❌ 링 잉여(미니는 트윈링 아님) |
| 112 와이드 | MAT_000253 | 링 블랙 | MAT_TYPE.07 | USAGE.07 | Y | △ 와이드=트윈링이므로 링은 공정 param이어야(자재행=오적재) |

> **벽걸이(111) 23행** = 종이 22종(MAT_TYPE.01) + MAT_000253 링 블랙(MAT_TYPE.07). 종이 22종은 본체 자재(정합), 링=공정이어야.
> **결정적:** 삼각대(그레이/블랙)·링 블랙이 **MAT_TYPE.07 부속 자재**로 적재 + usage=USAGE.07(본체 종이와 동일 슬롯) + dflt_yn=Y. 거치/제본 = 공정(schema-intent §3 #6/#7·bom.md). **삼각대 거치 공정은 마스터·상품에 부재**(아래 §3).

---

## 3. 공정 — 캘린더가공 (거치/제본/타공/포장)

```sql
SELECT pp.prd_cd, pp.proc_cd, pr.proc_nm, pp.mand_proc_yn
FROM t_prd_product_processes pp JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd
WHERE pp.prd_cd IN ('PRD_000108'..'PRD_000112') ORDER BY pp.prd_cd;
```
| 상품 | proc_cd | proc_nm | mand | 정답 대조 |
|------|---------|---------|:----:|-----------|
| 108 탁상 | PROC_000076 | 수축포장 | N | 🟡 포장만·**삼각대 거치 공정 누락**(삼각대는 자재로) |
| 109 미니 | PROC_000076 | 수축포장 | N | 동일·거치 누락 |
| 110 엽서 | PROC_000079 | 타공 | N | 🟡 타공만·**우드거치/재단만 택일 미모델**(option_groups 0) |
| 111 벽걸이 | PROC_000021 | 트윈링제본 | N | ✅ 트윈링 정합 |
| 111 벽걸이 | PROC_000079 | 타공 | N | ✅ 2구타공 정합 |
| 112 와이드 | PROC_000021 | 트윈링제본 | N | ✅ |

```sql
SELECT proc_cd, proc_nm FROM t_proc_processes WHERE proc_nm LIKE '%삼각대%' OR proc_nm LIKE '%거치%';
```
**결과: 0행.** "삼각대 거치"·"거치대" 공정이 **마스터에 부재** → 삼각대를 공정으로 교정하려면 거치 공정 mint 필요(search-before-mint: 트윈링021·타공079·포장075/076·하드커버트윈링024는 존재, 삼각대거치는 없음).

**판정:** 벽걸이/와이드 트윈링·타공 = 정합. **탁상/미니 삼각대 거치 공정 누락**(삼각대=자재 오적재의 이면). **캘린더가공 택일그룹(GRP-CAL-가공) 전 상품 미적재**(option_groups 0).

---

## 4. 출력판형 — output_paper_typ_cd [F-1 코드↔라이브 충돌]

```sql
SELECT ps.prd_cd, ps.siz_cd, s.siz_nm, ps.output_paper_typ_cd, ps.output_file_typ
FROM t_prd_product_plate_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd
WHERE ps.prd_cd IN ('PRD_000108'..'PRD_000112');
-- 전역 분포
SELECT output_paper_typ_cd, count(*) FROM t_prd_product_plate_sizes GROUP BY 1;
```
| 상품 | siz_cd | siz_nm | output_paper_typ | 정답 | load_master 코드 산출 |
|------|--------|--------|------------------|------|----------------------|
| 108 탁상 | SIZ_000499 | 316x467 | **.01 국전계열** | ✅ 국전계열(국4절) | ❌ 코드=.03 기타 |
| 110 엽서 | SIZ_000499 | 316x467 | .01 국전계열 | ✅ | ❌ .03 |
| 111 벽걸이 | SIZ_000499 | 316x467 | .01 국전계열 | ✅ | ❌ .03 |
| 112 와이드 | SIZ_000292 | 304x629 | **.03 기타** | ✅ 기타(3절) | ✅ .03 |

전역: `.01=32 · .03=33 · NULL=359`.

**판정:** **값은 정답**(국4절=국전계열·3절=기타). 그러나 `load_rel_plate_sizes`(L338,346)는 **전부 .03 기타**로 적재하는 코드 → 라이브 `.01`은 현 코드가 재현 못함 = **적재 경로 불명**(이전 plate 교정 적재 c722c24 추정). **재적재 시 .01→.03 퇴행 위험**(F-1).

---

## 5. 사이즈 변형 커버리지 (엽서 — D-1 교훈)

```sql
SELECT s.siz_cd, s.siz_nm FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd
WHERE ps.prd_cd='PRD_000110' ORDER BY s.siz_cd;
```
| siz_cd | siz_nm | 엑셀 엽서 distinct(L1 재단) | 정합 |
|--------|--------|---------------------------|:--:|
| SIZ_000007 | 148x210 | row16 재단 148x210 ✅ | ✅ |
| SIZ_000069 | 220x145 | row13 220x145 ✅ | ✅ |
| SIZ_000070 | 130x220 | row15 130x220 ✅ | ✅ |
| SIZ_000072 | 145x145 | row11 145x145 ✅ | ✅ |
| SIZ_000073 | 220x130 | row12 220x130 ✅ | ✅ |
| SIZ_000074 | 145x300 | row17 145x300 ✅ | ✅ |

**판정 (round-12 정정):** round-12 live-crosscheck §5가 "SIZ_000007(148x210)이 엑셀 엽서 distinct에 없음=변형 불일치"라 했으나, **엑셀 엽서캘린더 row16(작업 152x214/재단 148x210)에 실재** → SIZ_000007=정합. **round-12 D-1 flag는 오탐**(엑셀 distinct 누락 집계). 변형 커버리지 6/6 정합 ✅.

---

## 6. 카테고리 (고아 여부 + 미니 카테고리)

```sql
SELECT pc.prd_cd, pc.cat_cd, c.cat_nm, c.upr_cat_cd, c.cat_lvl FROM t_prd_product_categories pc
JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd WHERE pc.prd_cd IN ('PRD_000108'..'PRD_000112');
SELECT cat_cd, cat_nm FROM t_cat_categories WHERE cat_cd IN ('CAT_000112'..'CAT_000115');
```
| 상품 | cat_cd | cat_nm | upr/lvl | 정답 대조 |
|------|--------|--------|---------|-----------|
| 108 탁상 | CAT_000112 | 탁상형캘린더 | CAT_000007/2 | ✅ 정상 노드 |
| 109 미니 | **CAT_000112** | 탁상형캘린더 | /2 | △ 마스터에 **CAT_000113 미니탁상형캘린더** 존재하나 미연결 |
| 110 엽서 | CAT_000114 | 엽서캘린더 | /2 | ✅ |
| 111 벽걸이 | CAT_000115 | 벽걸이캘린더 | /2 | ✅ |
| 112 와이드 | CAT_000115 | 벽걸이캘린더 | /2 | ✅ |

**판정:** **카테고리 고아 0**(디지털인쇄 043~046→CAT_000296 같은 고아 없음·전부 lvl2 정상 노드). **미니(109)** = CAT_000113(미니탁상형캘린더 전용 노드)이 마스터에 있으나 미니가 CAT_000112(탁상형)에 묶임 → 엑셀 구분(`탁상형캘린더`) 따름 vs 전용 노드 = AMBIGUOUS.

---

## 7. addon + template (봉투/우드거치대)

```sql
SELECT prd_cd, tmpl_cd FROM t_prd_product_addons;
SELECT tmpl_cd, base_prd_cd, tmpl_nm FROM t_prd_templates ORDER BY tmpl_cd;
SELECT count(*) FROM t_prd_product_prices;  -- 전역
```
- **addons: PRD_000016→TMPL-000005 1행만**(캘린더 봉투/우드거치대 0). addons 컬럼=`tmpl_cd`(addon_prd_cd 아님·Phase7 전환).
- **templates 9행** = 봉투류(PRD_000001/002/281/282/283 기준 SKU). **캘린더봉투(PRD_000005) 기준 template 0** → 캘린더 addon 연결 불가(SKU 부재).
- **prices 전역 0행** → 디자인캘린더 고정가(4000~24000) 전부 미적재.

**판정:** 봉투 addon·우드거치대 자재·디자인 고정가 = **전 상품 MISSING**.

---

## 재현 노트
- 전 쿼리 읽기전용 SELECT. 쓰기 0. 비밀값 비노출(.env.local 환경변수).
- round-14 스키마 반영 확인: `t_prd_product_processes.excl_grp_cd` 컬럼 부재(Phase11 삭제)·`t_prd_product_addons.addon_prd_cd`→`tmpl_cd`(Phase7). load_master는 이 drift 미반영.
