# 스티커 — 라이브 diff (live-diff · round-13 C3)

> **작성** 2026-06-11 · round-13. 각 상품의 라이브 t_* 행을 읽기전용 SELECT로 전수 측정하고 extraction-plan 정답값과 field-for-field 대조. 행 존재만이 아니라 변형 커버리지까지(round-7 D-1 교훈). 비밀값 비노출.
>
> **라이브 접속:** `.env.local` `RAILWAY_DB_*` 읽기전용. 스티커 상품 = `PRD_000052`~`PRD_000067`(16상품).

---

## 1. 상품 마스터 행 대조 (t_prd_products)

재현: `SELECT prd_cd,prd_nm,prd_typ_cd,"MES_ITEM_CD",file_upload_yn,use_yn,min_qty,max_qty,qty_unit_typ_cd FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';`

| prd_cd | prd_nm | MES(라이브) | MES(L1 정답) | 도수정합 | use_yn | diff |
|--------|--------|:--:|:--:|:--:|:--:|------|
| 052 | 반칼 자유형 스티커 | NULL | 002-0001 | ✅ | Y | MES MISSING |
| 053 | 반칼 자유형 투명스티커 | NULL | 002-0002 | ✅ | Y | MES MISSING |
| 054 | 반칼 자유형 홀로그램스티커 | NULL | 002-0015 | ✅ | Y | MES MISSING |
| 055 | 낱장 자유형 스티커 | NULL | 002-0003 | ✅ | Y | MES MISSING |
| 056 | 낱장 자유형 투명스티커 | NULL | 002-0004 | ✅ | Y | MES MISSING |
| 057 | 대형 자유형 스티커 | NULL | 002-0005 | ✅ | Y | MES MISSING |
| 058 | 반칼원형스티커 | NULL | 002-0008 | ✅ | Y | MES MISSING |
| 059 | 반칼정사각스티커 | NULL | 002-0009 | ✅ | Y | MES MISSING |
| 060 | 반칼직사각스티커 | NULL | 002-0010 | ✅ | Y | MES MISSING |
| 061 | 반칼띠지스티커 | NULL | 002-0011 | ✅ | Y | MES MISSING |
| 062 | 반칼팬시스티커 | NULL | 002-0012 | ✅ | Y | MES MISSING |
| 063 | 반칼팬시투명스티커 | NULL | 002-0012* | ✅ | **N** | MES MISSING·use_yn=N |
| 064 | 소량자유형스티커 | NULL | 002-0006 | ✅ | **N** | MES MISSING·use_yn=N |
| 065 | 스티커팩 | NULL | 002-0016 | ✅ | Y | MES MISSING |
| 066 | 합판도무송스티커 | NULL | 002-0013 | ✅ | Y | MES MISSING |
| 067 | 타투스티커 | NULL | 002-0014 | ✅ | Y | MES MISSING |

> **MES 전량 NULL** — L1 002-0001~0016 실값 보유(L-ST-A, load_master.py:261 의도적). 063/064 use_yn=N(변형/소량 — L1 정합 가능, 컨펌).

---

## 2. 하위 행수 매트릭스 (변형 커버리지)

재현: `SELECT p.prd_cd, (SELECT count(*) FROM t_prd_product_sizes s WHERE s.prd_cd=p.prd_cd) sizes, ...(materials/processes/bundle/plate/print_opt/cats/optgrp/sets/addons) FROM t_prd_products p WHERE p.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';`

| prd_cd | sizes | mats | procs | bundle | plate | prnopt | cats | optgrp | sets | addons | 정답 기대 | diff 요약 |
|--------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|-----------|-----------|
| 052 | 3 | 5 | **1** | **0** | 3 | 1 | 1 | 0 | 0 | 0 | procs≥2(반칼+코팅), bundle≥2 | 코팅공정·조각수 MISSING·mand=N |
| 053 | 3 | 1 | 2 | 0 | 3 | 1 | 1 | 0 | 0 | 0 | procs=2(화이트+반칼) | 정합(mand=N) |
| 054 | 3 | 1 | 2 | 0 | 3 | 1 | 1 | 0 | 0 | 0 | procs=2 | 정합(mand=N) |
| 055 | 3 | 1 | 1 | **0** | 3 | 1 | 1 | 0 | 0 | 0 | bundle≥1(5~10조각) | 조각수 MISSING·자재명 절단 |
| 056 | 3 | 1 | 2 | 0 | 3 | 1 | 1 | 0 | 0 | 0 | procs=2(화이트+완칼) | 정합·자재 .01 오염 |
| 057 | 1 | 1 | 1 | **0** | 1 | 1 | 1 | 0 | 0 | 0 | bundle≥1 | 조각수 MISSING·자재명 절단 |
| 058 | 2 | 5 | 1 | **0** | 0 | 1 | 1 | 0 | 0 | 0 | 형상저장·코팅분리·조각수 | 형상 부재·코팅 자재·조각수 MISSING |
| 059 | 2 | 5 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | (동상) | 형상 부재·코팅·조각수 |
| 060 | 2 | 5 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | (동상) | 형상 부재·코팅·조각수 |
| 061 | 2 | 5 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | (동상) | 형상 부재·코팅·조각수 |
| 062 | 3 | 5 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | (동상) | 형상 부재·코팅·조각수 |
| 063 | 3 | 1 | **1** | 0 | 0 | 1 | 1 | 0 | 0 | 0 | procs≥2(화이트+커팅) | **화이트 MISSING(F-ST-3)** |
| 064 | 7 | 5 | 1 | **0** | 0 | 1 | 1 | 0 | 0 | 0 | bundle=1(*1조각)·코팅분리 | 조각수·코팅 MISSING |
| 065 | 1 | 2 | 0 | 0 | 1 | 1 | 1 | 0 | **0** | 0 | sets 구성 | **세트 MISSING(F-ST-E)** |
| 066 | **37** | 6 | 1 | **5** | 26 | 1 | 1 | **1** | 0 | 0 | 형상=size(Q7)·조각수·옵션그룹 잔재 | 형상=size 정합·옵션그룹 EXTRA |
| 067 | 1 | 1 | 0 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 커팅 없음 | 정합 |

---

## 3. 속성축별 정밀 대조

### 3.1 코팅 자재 (F-ST-2 · CONFLICT-1) — MIS-LOADED
재현: `SELECT pm.prd_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE m.mat_nm IN ('무광코팅스티커','유광코팅스티커') AND pm.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';`
- 결과: **052·058·059·060·061·062·064·066 (8상품)** 에 MAT_000155(무광)·MAT_000156(유광) 자재 연결.
- 정답(Q9★): 코팅=공정(PROC_000013). 라이브=자재. → 8상품 코팅 공정 미적재 + 자재 정리(컨펌).

### 3.2 화이트 별색 (F-ST-3) — MISSING
재현: `SELECT prd_cd FROM t_prd_product_processes WHERE proc_cd='PROC_000008' AND prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';`
- 결과: **053·054·056만** 화이트 연결. **063(투명스티커 베이스) 누락.**
- 정답(G-SK-1): 투명/홀로그램 베이스 화이트 underbase 필수. 063은 L1 `화이트인쇄(단면)` 실재.

### 3.3 규격형 형상 저장처 (F-ST-5) — MISSING
재현: `SELECT s.siz_nm FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000058';` → `A4(210x297mm)`·`A5(148x210mm)`(규격사이즈만, 형상 없음).
재현: `SELECT pr.proc_nm,pr.prcs_dtl_opt FROM t_prd_product_processes pp JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd WHERE pp.prd_cd='PRD_000058';` → 스티커완칼·`{조각수}`(모양 param 없음).
- 결과: 058~062 형상(원형/정사각/직사각 등)이 size에도 공정 prcs_dtl_opt에도 product 레벨에 **없음**.
- L1 C24엔 `원형 25mm (24ea)` 등 형상 실재. → OM-7/GAP-PARAM 실증.

### 3.4 합판도무송 형상=size (Q7 정합) — CORRECT
재현: `SELECT s.siz_nm,s.cut_width,s.cut_height FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000066' ORDER BY s.siz_nm;`
- 결과: 37행, `정사각30x30mm(2EA)`·`직사각35x25mm(2EA)`·`원형30x30` 등 siz_nm에 형상+치수+EA 인코딩. 공정=스티커완칼 1줄(형상 중복 입력 없음).
- 정답(Q7★): 형상=칼틀 1:1·size 유지. **라이브 정합** — round-12 가격격자(형상×사이즈) 입증. round-11 "C24 빈값·형상이 size로 흡수=오모델 의심"은 **반증**(C24엔 형상 실재이고 라이브 size 흡수가 Q7 정답).

### 3.5 조각수 (F-ST-4 · Q8 미실현) — MISSING
재현: `SELECT prd_cd,count(*) FROM t_prd_product_bundle_qtys WHERE prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067' GROUP BY prd_cd;` → **066만(5행: 1/2/3/6/8·QTY_UNIT.01 EA).**
- L1 조각수 실재 상품: 052(*최대20/40)·055/056/057(5~10)·064(*1조각). 전부 0행.
- 066 5행도 실은 형상별 EA(조각수)가 bundle_qty로 들어간 것 — 묶음수≠조각수 의미 혼입.

### 3.6 자재유형 혼재 (F-ST-F) — MIS-LOADED
재현: `SELECT DISTINCT m.mat_cd,m.mat_nm,m.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067' ORDER BY m.mat_typ_cd;`
- MAT_TYPE.01(종이): 비코팅(084)·타투전용지(167)·미색(242)·투명전용지(243)
- MAT_TYPE.11(스티커): 유포(153)·유포지(154)·무광코팅(155)·유광코팅(156)·투명(162)·홀로그램(163)·투명데드롱(170)·은데드롱(171)
- 정답: 스티커 점착지 전부 MAT_TYPE.11. 4종(.01)이 오분류.

### 3.7 자재명 절단 (L-ST-H) — MIS-LOADED
재현: `SELECT pm.prd_cd,m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000055','PRD_000057');`
- 결과: 055·057 자재 = "유포지"(MAT_000154). L1 = "유포지+엠보코팅". "+엠보코팅" 소실.

### 3.8 066 빈 옵션그룹 (L-ST-G) — EXTRA
재현: `SELECT prd_cd,opt_grp_cd,opt_grp_nm,reg_dt::date FROM t_prd_product_option_groups ORDER BY prd_cd;`
- 결과: PRD_000066 `OPT-000004 원형`(2026-06-10). option_items = **0행**(빈 껍데기).
- 전역 옵션그룹: 001(테스트)·002(제본방식)·066(원형)·138(현수막×3). 전부 파일럿/테스트 잔재.

### 3.9 커팅 필수성 (C-ST-11) — MIS-LOADED
재현: `SELECT pp.prd_cd,pr.proc_nm,pp.mand_proc_yn FROM t_prd_product_processes pp JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd WHERE pp.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';`
- 결과: 커팅 공정(반칼/완칼/스티커완칼) **전 상품 mand_proc_yn=N**. 화이트 별색도 N.
- 정답: 커팅=스티커 정체(반칼/완칼이 상품명에 인코딩) → mand=Y. 화이트=투명 베이스 필수 → mand=Y. 라이브 N은 v03 필수성 미표기.

### 3.10 도수 (CORRECT)
재현: `SELECT print_side,front_colrcnt_cd,back_colrcnt_cd FROM t_prd_product_print_options WHERE prd_cd='PRD_000052';` → `단면·CLR_000005(CMYK 4도)·CLR_000001(인쇄 안 함)`.
- 정답: 단면·앞 4도·뒤 0도. **라이브 정합.** (round-12 "front=CLR_000005=무도수" 표기는 부정확 — CLR_000005=4도, 정정.)

---

## 4. 재현용 쿼리 모음 (비밀값 없이)

```sql
-- 상품 마스터
SELECT prd_cd,prd_nm,"MES_ITEM_CD",use_yn FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';
-- 코팅 자재 연결 상품 (CONFLICT)
SELECT pm.prd_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
  WHERE m.mat_nm IN ('무광코팅스티커','유광코팅스티커') AND pm.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';
-- 화이트 별색
SELECT prd_cd FROM t_prd_product_processes WHERE proc_cd='PROC_000008' AND prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';
-- 규격형 형상 (058 size vs 공정 param)
SELECT s.siz_nm FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000058';
SELECT pr.prcs_dtl_opt FROM t_prd_product_processes pp JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd WHERE pp.prd_cd='PRD_000058';
-- 조각수 (bundle)
SELECT prd_cd,count(*) FROM t_prd_product_bundle_qtys WHERE prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067' GROUP BY prd_cd;
-- 자재유형 혼재
SELECT DISTINCT m.mat_cd,m.mat_nm,m.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
  WHERE pm.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067' ORDER BY m.mat_typ_cd;
-- 카테고리 위상
SELECT pc.prd_cd,c.cat_cd,c.cat_nm,c.cat_lvl FROM t_prd_product_categories pc JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd
  WHERE pc.prd_cd BETWEEN 'PRD_000052' AND 'PRD_000067';
-- 빈 옵션그룹
SELECT prd_cd,opt_grp_cd,opt_grp_nm FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066';
SELECT count(*) FROM t_prd_product_option_items WHERE opt_cd='OPV-000006';
```
