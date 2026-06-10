# 디지털인쇄 — 라이브 실측 대조 (round-12 P3)

> **작성** 2026-06-10 · round-12. 매핑 우변(t_* 코드값·FK·행 존재/미적재)을 라이브 DB 읽기전용 SELECT로 실측. 재현 가능(쿼리 명시·비밀값 없음). 접속=`.env.local` `RAILWAY_DB_*`(읽기전용). **INSERT/UPDATE/DDL 0.**

---

## 0. 접속 패턴 (비밀값 비노출)

```bash
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAF'|' -c "<SELECT>"
```

---

## 1. 공정 마스터 family (별색·박·코팅·접지·완칼·모서리)

```sql
SELECT proc_cd, proc_nm, upr_proc_cd FROM t_proc_processes WHERE upr_proc_cd='PROC_000007';
```
| proc_cd | proc_nm | 비고 |
|---------|---------|------|
| PROC_000007 | 별색인쇄 | root |
| PROC_000008~012 | 화이트·클리어·핑크·금색·은색 | C18~22 별색 family (R12-6) |

```sql
SELECT proc_cd, proc_nm FROM t_proc_processes WHERE upr_proc_cd='PROC_000033';
```
- 박(PROC_000033) 자식 **16종**: 금034·은035·핑크036·홀로그램037·금유광038·은유광039·먹유광040·동박041·적박042·청박043·트윙클044·펄박045·백박046·녹박047·금무광048·은무광049 → **C37 박칼라=공정(박 자식)** (R12-5·CONFIRM-DP-1 RESOLVED).

```sql
SELECT proc_cd, proc_nm, upr_proc_cd FROM t_proc_processes
WHERE proc_cd IN ('PROC_000013','PROC_000014','PROC_000015','PROC_000026','PROC_000027','PROC_000028',
'PROC_000029','PROC_000030','PROC_000031','PROC_000032','PROC_000050','PROC_000053','PROC_000056','PROC_000073');
```
| proc_cd | proc_nm | upr | 매핑 |
|---------|---------|-----|------|
| PROC_000013 | 코팅 | root | C23 |
| PROC_000014/015 | 유광/무광 | 013 | C23 값 |
| PROC_000026 | 귀돌이 | root | C30 모서리 root |
| PROC_000027/028 | 직각/둥근 | 026 | **C30 값(R12-4)** |
| PROC_000029 | 오시 | root | C31 |
| PROC_000030 | 미싱 | root | C32 |
| PROC_000031 | 가변텍스트 | root | C33 |
| PROC_000032 | 가변이미지 | root | C34 |
| PROC_000050 | 형압 | root | C35 |
| PROC_000053 | 완칼 | root | C24 |
| PROC_000056 | 접지 | root | C25 (자식 16종, 073=6단오시접지·074=6단미싱접지) |

**인쇄방식:** `PROC_000001 인쇄` root → 002 UV·004 디지털·006 실사. **디지털=PROC_000004**(C 공통 인쇄방식 ✅).

---

## 2. 코드그룹 실측 (FK 우변)

```sql
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'MAT_TYPE.%';   -- .01 종이 ... .11 스티커
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'USAGE.%';        -- .01 내지 .02 표지 ... .07 공통
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'OUTPUT_PAPER_TYPE.%'; -- .01 국전계열 .02 46계열 .03 기타
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'QTY_UNIT.%';     -- .01 EA .02 매 .03 권 .04 세트 .05 팩
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'PRD_TYPE.%';     -- .01 완제품 ... .04 디자인상품 .05 추가상품
SELECT clr_cd, clr_nm FROM t_clr_color_counts;                                  -- CLR_000001 인쇄안함 ... 005 CMYK4도
```
| 코드그룹 | 멤버(라이브) | 디지털인쇄 사용 |
|----------|--------------|-----------------|
| MAT_TYPE | .01~.11(11종) | **.01 종이** |
| USAGE | .01~.07(7종) | **.07 공통**(R12-2) |
| OUTPUT_PAPER_TYPE | .01 국전계열·.02 46계열·.03 기타 | **.01 국전계열**(엽서 316x467) |
| QTY_UNIT | .01 EA·.02 매·.03 권·.04 세트·.05 팩 | **.02 매**(R12-3) |
| PRD_TYPE | .01~.05(5종) | **.04 디자인상품**(디지털 5상품 전수) |
| t_clr_color_counts | CLR_000001~005 | 단면=001(back)/005(front)·양면=005/005 |

---

## 3. 디지털인쇄 7상품 적재 상태

```sql
SELECT prd_cd, prd_nm, prd_typ_cd, file_upload_yn, editor_yn, min_qty, max_qty, qty_incr, qty_unit_typ_cd
FROM t_prd_products WHERE prd_nm ~ '프리미엄엽서|포토카드|접지카드|프리미엄명함|쿠폰/상품권|배경지|소량전단지';
```
| prd_cd | prd_nm | prd_typ | upload | editor | min | max | incr | qty_unit |
|--------|--------|---------|:--:|:--:|----:|----:|----:|----------|
| PRD_000016 | 프리미엄엽서 | .04 | Y | N | 15 | 10000 | 15 | QTY_UNIT.02 |
| PRD_000024 | 포토카드 | .04 | Y | Y | 20 | 10000 | 20 | QTY_UNIT.02 |
| PRD_000027 | 2단접지카드 | .04 | Y | N | 8 | 10000 | 8 | QTY_UNIT.02 |
| PRD_000031 | 프리미엄명함 | .04 | Y | N | 100 | 10000 | 100 | QTY_UNIT.02 |
| PRD_000041 | 스탠다드 쿠폰/상품권 | .04 | — | — | — | — | — | — |
| PRD_000043 | 인쇄배경지(OPP봉투타입) | .04 | — | — | — | — | — | — |
| PRD_000047 | 소량전단지 | .04 | Y | N | 2 | 100000 | 1 | QTY_UNIT.02 |

> 7상품 family 전수 라이브 실재(상품권=041/042·배경지=043/044). **C26 건수=QTY_UNIT.02 매** 전수 실측 — round-11 "건" 가설 폐기(R12-3).

---

## 4. MES 컬럼명 실측 (R12-1 — 정정 근거)

```sql
SELECT column_name, data_type FROM information_schema.columns WHERE table_name='t_prd_products';
-- 결과: mes_item_cd(소문자) 부재. 대문자 quoted "MES_ITEM_CD" 만 존재.
SELECT table_name, column_name FROM information_schema.columns WHERE column_name ~* 'mes';
-- 결과: t_prd_products | MES_ITEM_CD (유일)
SELECT prd_cd, prd_nm, "MES_ITEM_CD" FROM t_prd_products WHERE prd_cd='PRD_000016';
-- 결과: PRD_000016|프리미엄엽서| (값 NULL — MES 미연동, 정상)
```
- **소문자 `mes_item_cd` SELECT 시 `ERROR: column "mes_item_cd" does not exist`**(실증). → 적재 SQL은 `"MES_ITEM_CD"`(대문자·쌍따옴표) 필수. round-11·loadspec 소문자 표기 **정정**.

---

## 5. 엽서(PRD_000016) 하위 적재 — D-1 변형 커버리지 점검

```sql
SELECT 'sizes', count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000016'  -- 7
UNION ALL SELECT 'plate', count(*) FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000016'  -- 1
UNION ALL SELECT 'materials', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000016'  -- 21
UNION ALL SELECT 'print_options', count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000016'  -- 2
UNION ALL SELECT 'processes', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000016'  -- 6
UNION ALL SELECT 'addons', count(*) FROM t_prd_product_addons WHERE prd_cd='PRD_000016'  -- 1
UNION ALL SELECT 'price_formulas', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000016'  -- 1
UNION ALL SELECT 'bundle_qtys', count(*) FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000016';  -- 0
```
| 하위 | 행수 | 엑셀 기대 | 판정 |
|------|----:|-----------|------|
| sizes | 7 | 13(엽서) | **변형 미적재**(D-1) |
| plate | 1 | 1 | OK |
| materials | 21 | 11~ | OK(usage 전수 USAGE.07) |
| print_options | 2 | 단/양면 | OK |
| processes | **6** | 별색5+코팅+커팅+모서리+오시+미싱+가변2+박/형압 | **미적재 다수**(별색/코팅/커팅/박 부재) |
| addons | 1 | 봉투 4종 | 부분 적재 |
| price_formulas | 1 | PRF_DGP_A | OK |
| bundle_qtys | 0 | 0(낱장) | OK |

### 5.1 엽서 processes 실제 6행
```sql
SELECT pp.proc_cd, p.proc_nm, pp.mand_proc_yn FROM t_prd_product_processes pp
JOIN t_proc_processes p ON pp.proc_cd=p.proc_cd WHERE pp.prd_cd='PRD_000016';
```
- PROC_000027 직각·028 둥근·029 오시·030 미싱·031 가변텍스트·032 가변이미지 (전부 mand=N).
- **부재(적재 대상):** 별색(008~012)·코팅(013~015)·완칼(053)·박(033)·형압(050). 마스터는 전부 실재 → round-4/5 상품 연결 적재 대상.

### 5.2 엽서 print_options / plate / materials usage / addon
```sql
SELECT opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd FROM t_prd_product_print_options WHERE prd_cd='PRD_000016';
-- 1|단면|CLR_000005|CLR_000001    2|양면|CLR_000005|CLR_000005
SELECT siz_cd, output_paper_typ_cd, output_file_typ FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000016';
-- SIZ_000499|OUTPUT_PAPER_TYPE.01|(빈값)
SELECT usage_cd, count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000016' GROUP BY usage_cd;
-- USAGE.07|21
SELECT tmpl_cd FROM t_prd_product_addons WHERE prd_cd='PRD_000016';
-- TMPL-000005
```
- C17 도수 매핑 검증 ✅(단면 back=인쇄안함·양면 both CMYK).
- C10 출력판형=OUTPUT_PAPER_TYPE.01 국전계열 ✅(316x467→코드).
- C16 usage=USAGE.07 공통 ✅(R12-2).
- C38 addon=TMPL-000005(하이픈, OPP접착봉투·base PRD_000001) — CONFLICT-1.

---

## 6. 가격공식·템플릿 실측

```sql
SELECT frm_cd, frm_nm, frm_typ_cd FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_DGP%';
```
- PRF_DGP_A(엽서·상품권·슬로건)·B(모양엽서·라벨택)·C(배경지·헤더택)·D(소량전단지)·E(접지카드·접지리플렛)·F(썬캡 미출시) — 전수 FRM_TYPE.01·라이브 실재(round-2 308행 COMMIT 정합). 엽서=PRF_DGP_A.

```sql
SELECT tmpl_cd, tmpl_nm, base_prd_cd FROM t_prd_templates ORDER BY tmpl_cd LIMIT 20;
```
- TMPL-000004~009 봉투류(OPP접착·OPP비접착·카드봉투 화이트/블랙·트레싱지) 실재. separator=**하이픈**(코드전략 `_`와 CONFLICT-1).

---

## 7. 실측 종합

| 검증 항목 | 결과 |
|-----------|------|
| 매핑 우변 코드값/FK 실재 | **전수 실재**(별색·박·코팅·접지·완칼 family·5 코드그룹·CLR·PRF_DGP·TMPL) — 신규 mint 불요 |
| 상품 행 존재 | 7상품 family 전수 실재(5 직접 조회 + 상품권/배경지 2 family) |
| 변형 커버리지(D-1) | **미달** — 엽서 사이즈 7/13·process 6(별색/코팅/커팅/박 부재) = round-4/5 적재 대상 |
| round-11 초안 정정 | R12-1(MES 대문자)·R12-2(usage.07)·R12-3(QTY_UNIT.02)·R12-4(모서리 family)·R12-5(박칼라=공정)·R12-6(별색 family)·R12-7(tmpl 하이픈) |
| 쓰기 작업 | **0**(SELECT only) |
