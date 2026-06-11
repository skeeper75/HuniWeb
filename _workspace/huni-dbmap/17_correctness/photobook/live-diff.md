# 포토북 — 라이브 전수 실측 vs 기대값 diff (live-diff, round-13 C3)

> **작성** 2026-06-11 · round-13. 읽기전용 SELECT만(INSERT/UPDATE/DDL 0·비밀값 비노출). PRD_000100 + 반제품 7 전수 측정 → extraction-plan 정답값과 field-for-field 대조. D-1 교훈(LOADED=행존재만 아님·변형 커버리지까지).
>
> **접속:** `.env.local RAILWAY_DB_*` → `psql -tAc`. 실측 일시 2026-06-11.

---

## 1. 재현 쿼리 (비밀값 없이)

```sql
-- 상품·반제품 전수
SELECT prd_cd, prd_nm, prd_typ_cd, semi_role_cd, editor_yn, file_upload_yn,
       min_qty, max_qty, qty_incr, qty_unit_typ_cd, "MES_ITEM_CD", use_yn
FROM t_prd_products WHERE prd_nm LIKE '%포토북%' ORDER BY prd_cd;
-- sets / categories / sizes / materials / processes / page_rules / print_options
SELECT ... FROM t_prd_product_<dim> WHERE prd_cd='PRD_000100';
-- 레더 3-way 혼재
SELECT mm.mat_cd, mm.mat_nm, mm.mat_typ_cd, COUNT(pm.prd_cd) linked
FROM t_mat_materials mm LEFT JOIN t_prd_product_materials pm ON mm.mat_cd=pm.mat_cd
WHERE mm.mat_nm LIKE '%레더%' GROUP BY 1,2,3 ORDER BY 3,1;
-- 아트250 중복 자재
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_nm LIKE '%아트250%' OR mat_nm LIKE '%무광코팅%';
-- 코팅 공정 family (책자 vs 포토북 대조)
SELECT pp.prd_cd, p.prd_nm, pp.proc_cd, pr.proc_nm FROM t_prd_product_processes pp
JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd JOIN t_prd_products p ON pp.prd_cd=p.prd_cd
WHERE pp.proc_cd IN ('PROC_000013','PROC_000015','PROC_000014');
-- 가격 3 후보
SELECT count(*) FROM t_prd_product_prices WHERE prd_cd='PRD_000100';
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000100';
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_templates';
```

---

## 2. 상품·반제품 (t_prd_products) — 8행 실측

| prd_cd | prd_nm | prd_typ | semi_role | editor | 기대 | diff |
|--------|--------|---------|-----------|:--:|------|------|
| PRD_000100 | 포토북 [디자인명] | .04 디자인 | (완제품) | Y | .04·1상품·editor Y | ✅ |
| PRD_000101 | …-내지(몽블랑130) | .02 반제품 | .01 내지 | N | — | ✅ |
| PRD_000102 | …-표지(하드커버) | .02 | .02 표지 | N | — | ✅ |
| PRD_000103 | …-표지(아트250+무광코팅) | .02 | .02 | N | — | ✅ |
| PRD_000104 | …-면지(그레이) | .02 | .03 면지 | N | — | ✅ |
| PRD_000105 | …-표지(레더하드커버) | .02 | .02 | N | — | ✅ |
| PRD_000106 | …-표지(레더) | .02 | .02 | N | — | ✅ |
| PRD_000107 | …-표지(소프트커버) | .02 | .02 | N | — | ✅ |

→ **8행 전수 정합.** 1상품+반제품7 모델 라이브 확정. min/max/incr=1/1000/1·qty_unit=QTY_UNIT.03 권·MES NULL 전부 정합.

---

## 3. 하위 차원 (PRD_000100) — 속성축 diff

| 차원 | 라이브 실측 | 기대(extraction-plan) | diff |
|------|------------|----------------------|------|
| **categories** | CAT_000108(상위 CAT_000006 책자), main=Y | CAT_000108 | ✅ **고아 없음** |
| **sizes** | SIZ_000170(A5)·172(A4)·269(8x8)·274(10x10), cut=work, impos=N | 4 variant | ✅ |
| **materials** | (§4 자재 슬롯표) | 7 usage 슬롯 | ⚠ 자재유형 3건 불일치 |
| **processes** | PROC_000020 PUR, **mand=N** | PUR mand=Y + 코팅 PROC_000015 | ❌ mand=N·코팅 미연결 |
| **page_rules** | 24/150/2 (1행) | **엑셀: 하드 행만 24/150/2·소프트/레더 행 공란** | ⚠ **[F-PB-1] 엑셀 공란 GAP**(라이브 하드 기준 적재=오적재 아님). "소프트 4~14"는 엑셀에 없는 추정값·삭제 |
| **print_options** | opt1 양면(CLR5/CLR5)·opt2 단면(CLR5/CLR1) | 양/단면 2 | ✅ |
| **prices** | **0행** | base 24P + per-page | ❌ MISSING |
| **price_formulas** | **0행** | (고정가형) | ❌ MISSING |

---

## 4. 자재 슬롯 전수 diff (PRD_000100 materials 7행) — 핵심

| usage | mat_cd | mat_nm(라이브) | mat_typ(라이브) | 기대 mat_typ | diff |
|-------|--------|----------------|-----------------|--------------|------|
| .01 내지 | MAT_000105 | 몽블랑 130g | .01 종이 | .01 종이 | ✅ |
| .02 표지 | MAT_000005 | 하드커버 | .01 종이 | .01 종이 | ✅ |
| .02 표지 | MAT_000007 | 소프트커버 | .01 종이 | .01 종이 | ✅ |
| .02 표지 | MAT_000250 | 아트250+무광코팅 | .01 종이 | .01 종이 + 코팅 분리 | ❌ 코팅 평면화 |
| .02 표지 | MAT_000006 | 레더하드커버 | **.01 종이** | **.06 가죽** | ❌ 자재유형 |
| .02 표지 | MAT_000186 | 레더(화이트) | **.08 실사소재** | **.06 가죽** | ❌ 자재유형 |
| .03 면지 | MAT_000251 | 그레이 | .01 종이 | .01 종이 | ✅ |

---

## 5. 레더 3-way 혼재 전수 (mat_nm LIKE 레더) — 재현 확정

| mat_cd | mat_nm | mat_typ | 연결수 | 비고 |
|--------|--------|---------|:--:|------|
| MAT_000006 | 레더하드커버 | .01 종이 | **1** | PRD_000100 연결·note "포토북 표지 자재"(오분류 .01→정답 .06) |
| MAT_000008 | 레더 | .06 가죽 | 0 | 고아·**note "책자 표지 자재"(포토북용 아님)** |
| MAT_000173 | 레더하드커버 A | .06 가죽 | 0 | 고아·**note "IMPORT 약어/base root"(base·포토북용 아님)** |
| MAT_000174 | 레더하드커버 A5 | .06 가죽 | 0 | 고아 |
| MAT_000175 | 레더하드커버 A4 | .06 가죽 | 0 | 고아 |
| MAT_000186 | 레더(화이트) | .08 실사소재 | **6** | PRD_000100 포함(오분류 .08→정답 .06) |

> **PRD_000100은 레더를 .01(MAT_000006)+.08(MAT_000186) 2건 동시 연결.** **[F-PB-2 보정]** 두 연결행 모두 **이미 포토북 전용**(006 note "포토북 표지 자재")이고 틀린 건 mat_typ뿐 → **교정=연결행 mat_typ만 .06으로(prd_cd 재연결 아님)**. 별도 .06 가죽 고아행(008/173~175)은 note상 책자/base — **끌어오기 금지**(이름만 정합). MAT_000186 .08은 6상품 횡단 오염(§7).

---

## 6. 아트250 무광코팅 중복 자재 + 코팅 공정 family 대조

### 6.1 아트250/무광코팅 자재 중복 (3 슬러그)

| mat_cd | mat_nm | mat_typ | 연결수 | 연결 상품 |
|--------|--------|---------|:--:|----------|
| MAT_000172 | 하드커버전용지+무광코팅 | .01 | 0 | (고아) |
| MAT_000250 | 아트250+무광코팅 | .01 | 1 | PRD_000100 |
| MAT_000260 | 아트250 + 무광코팅 (공백차) | .01 | 7 | 만년다이어리류 PRD_000172~181 |

> 동일 자재가 **공백 차이로 250/260 중복 슬러그** + 172 미사용. v03 정규화 결함(directive 정합).

### 6.2 코팅 공정 family 불일치 (책자 vs 포토북)

| 상품 | 코팅 공정 연결 | diff |
|------|----------------|------|
| 중철책자(68)·무선책자(69)·PUR책자(70)·트윈링책자(71)·하드커버책자(72)·하드커버링책자(82) | **PROC_000015 무광 + PROC_000014 유광** | 코팅=공정 분리(Q9 정합) |
| 만년다이어리(하드커버)(173) | PROC_000015 무광 | 분리 정합 |
| **포토북 PRD_000100** | **코팅 공정 미연결**(자재명에 평면화) | ❌ family 이탈 |

→ **책자류는 코팅을 공정으로 올바로 분리했으나 포토북만 자재명에 묻음.** Q9 통일 위반 결정적 증거.

---

## 7. MAT_000186 레더(화이트) .08 오염 전파 (횡단 — 6상품)

| prd_cd | prd_nm | usage |
|--------|--------|-------|
| PRD_000077 | 레더 하드커버책자 | .02 표지 |
| PRD_000088 | 레더 링바인더 | .02 |
| **PRD_000100** | **포토북 [디자인명]** | .02 |
| PRD_000126 | 레더아트프린트 | .07 공통 |
| PRD_000174 | 만년다이어리(레더하드커버) | .02 |
| PRD_000175 | 만년다이어리(레더소프트커버) | .02 |

> MAT_000186 "레더(화이트)"가 .08 실사소재로 잘못 분류돼 **6 상품(책자·문구·포스터·포토북 횡단)** 에 레더 표지로 연결. 포토북만의 문제가 아닌 **family 횡단 오염**(교정 시 통합 결정 — 단 본 라운드는 포토북 귀속분만 매니페스트, 횡단은 컨펌으로 표기).

---

## 8. 표지 펼침 작업사이즈 마스터 (미연결 확인)

| siz_cd | siz_nm | work | cut | impos | 표지타입/size |
|--------|--------|------|-----|:--:|---------------|
| SIZ_000272 | 460x235 | 460x235 | (빈) | N | 하드 8x8 |
| SIZ_000273 | 420x213 | 420x213 | (빈) | N | 소프트 8x8 |
| SIZ_000277 | 556x285 | 556x285 | (빈) | N | 하드/레더 10x10 |
| SIZ_000278 | 352x248 | 352x248 | (빈) | N | A5 |
| SIZ_000279 | 314x224 | 314x224 | (빈) | N | 소프트 A5 |
| SIZ_000280 | 472x334 | 472x334 | (빈) | N | A4 |
| SIZ_000281 | 440x313 | 440x313 | (빈) | N | 소프트 A4 |

> 7 펼침 siz 마스터 **실재**(work만·cut 빈값) — `t_prd_product_sizes`엔 **미연결**(완성품 4종만). 생산 작업지시용. AMBIGUOUS(견적 미노출이 정상일 수 있음).

---

## 9. diff 결산표

| 항목 | 분류 | 건수 |
|------|------|:--:|
| CORRECT(정합) | products8·sets7·categories(고아0)·sizes4·내지/면지/하드/소프트 자재·도수·인쇄옵션2·수량·주문·책등미저장·반제품빈껍데기 | 다수 |
| MIS-LOADED | 레더 자재유형(MAT_000006 .01·MAT_000186 .08 — **연결행 mat_typ만 교정**)·아트250 코팅평면화+중복·PUR mand=N | 4 |
| MISSING | 코팅 공정 미분리·가격 전체 | 2 |
| AMBIGUOUS/GAP | 표지 펼침 siz 미연결·**소프트/레더 page 엑셀 공란(F-PB-1)** | 2 |
| EXTRA | (없음 — 잉여 적재 없음) | 0 |

> **권위:** 우변(코드값·mat_typ·연결수·행 존재/부재) 전부 라이브 실측. 추출본 의존 0. 가격=미적재=적재 대상. **[F-PB-1] 소프트 page는 엑셀 공란(GAP)이라 라이브 24/150/2는 오적재 아님** — MISSING 아닌 AMBIGUOUS. 교정은 인간 승인.
