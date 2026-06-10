# 포토북 — 라이브 DB 실측 대조 (round-12 P3)

> **작성** 2026-06-10. 읽기전용 SELECT만(INSERT/UPDATE/DDL 0). 비밀값 비노출. 재현 가능하도록 쿼리·결과 요약. 접속: `.env.local` `RAILWAY_DB_*` → `psql -tAc`.
>
> **D-1 교훈 적용:** "LOADED=행존재만"이 아니라 변형 커버리지(자재 usage 슬롯·인쇄옵션 양/단면·page_rule·반제품 sets)까지 실측.

---

## 1. 실측 쿼리 (재현용 — 비밀값 없이)

```sql
-- 포토북 상품·반제품
SELECT prd_cd, prd_nm, prd_typ_cd, semi_role_cd FROM t_prd_products WHERE prd_nm LIKE '%포토북%' ORDER BY prd_cd;
-- 반제품 셋트
SELECT prd_cd, sub_prd_cd, note FROM t_prd_product_sets WHERE prd_cd IN (포토북 prd_cd) ;
-- 하위 차원(sizes/materials/processes/page_rules/print_options/categories)
SELECT ... FROM t_prd_product_<dim> WHERE prd_cd='PRD_000100';
-- 마스터(자재·사이즈·공정·코드그룹)
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_cd IN (...);
SELECT siz_cd, siz_nm, cut_*, work_*, impos_yn FROM t_siz_sizes WHERE siz_cd IN (...);
-- 가격 적재 여부
SELECT count(*) FROM t_prd_product_prices WHERE prd_cd='PRD_000100';
-- 레더 자재 3-way 혼재 + 고아 여부(D-PB-1 재실측)
SELECT mm.mat_cd, mm.mat_nm, mm.mat_typ_cd, COUNT(pm.prd_cd) AS linked
FROM t_mat_materials mm LEFT JOIN t_prd_product_materials pm ON mm.mat_cd=pm.mat_cd
WHERE mm.mat_nm LIKE '%레더%' GROUP BY mm.mat_cd, mm.mat_nm, mm.mat_typ_cd ORDER BY mm.mat_typ_cd, mm.mat_cd;
-- PRD_000100 자재 링크 전수(usage 슬롯·mat_typ_cd)
SELECT m.mat_cd, mm.mat_nm, mm.mat_typ_cd, m.usage_cd
FROM t_prd_product_materials m JOIN t_mat_materials mm ON m.mat_cd=mm.mat_cd
WHERE m.prd_cd='PRD_000100' ORDER BY m.usage_cd, m.mat_cd;
```

---

## 2. 실측 결과 요약

### 2.1 상품·반제품 (t_prd_products) — ✅ 적재

| prd_cd | prd_nm | prd_typ_cd | semi_role_cd |
|--------|--------|-----------|--------------|
| PRD_000100 | 포토북 [디자인명] | PRD_TYPE.04 디자인 | (없음·완제품) |
| PRD_000101 | 포토북…-내지(몽블랑130) | PRD_TYPE.02 반제품 | SEMI_ROLE.01 내지 |
| PRD_000102 | 포토북…-표지(하드커버) | PRD_TYPE.02 | SEMI_ROLE.02 표지 |
| PRD_000103 | 포토북…-표지(아트250+무광코팅) | PRD_TYPE.02 | SEMI_ROLE.02 |
| PRD_000104 | 포토북…-면지(그레이) | PRD_TYPE.02 | SEMI_ROLE.03 면지 |
| PRD_000105 | 포토북…-표지(레더하드커버) | PRD_TYPE.02 | SEMI_ROLE.02 |
| PRD_000106 | 포토북…-표지(레더) | PRD_TYPE.02 | SEMI_ROLE.02 |
| PRD_000107 | 포토북…-표지(소프트커버) | PRD_TYPE.02 | SEMI_ROLE.02 |

> **확정:** round-11 "1상품+표지타입 variant 가설"이 **라이브 실재로 확정**. 디자인상품 1 + 반제품 7(내지1·표지5·면지1). Q3(반제품=제본 전체관점)·Q6(1상품) 정합.

### 2.2 반제품 셋트 (t_prd_product_sets) — ✅ 7행

PRD_000100 ← {101 내지·102 하드·103 아트250무광·104 면지·105 레더하드·106 레더·107 소프트}. note에 용도 라벨. del_yn=N.

### 2.3 하위 차원 (PRD_000100)

| 차원 | 라이브 값 | 엑셀 정합 |
|------|----------|----------|
| sizes | SIZ_000269(8x8)·SIZ_000274(10x10)·SIZ_000170(A5)·SIZ_000172(A4) | ✅ C5 4종 일치 |
| materials | MAT_000105/USAGE.01(몽블랑130 내지)·005/186/250/006/007 USAGE.02(표지5)·251/USAGE.03(그레이 면지) | ✅ usage 슬롯 정합 |
| processes | PROC_000020(PUR), **mand_proc_yn=N** | 🟡 PUR 정합·mand=N 보완대상 |
| page_rules | 24 / 150 / 2 | ✅ C15~17(하드 기준) |
| print_options | opt1 양면(front=back=CMYK4)·opt2 단면(front=CMYK4·back=인쇄안함) | ✅ C14 내지양면·C27 표지단면 |
| categories | CAT_000108 | ✅ C1 |
| **prices / price_formulas** | **0행** | ❌ 미적재(C37/38 적재대상) |

### 2.4 반제품 sub_prd 빈 껍데기 검증 (PRD_000102 표지) — ✅ 정상

sizes 0 · materials 0 · processes 0 — **설계의도 line 360 정합**(B 셋트 sub_prd 9속성 0행=정상, 자재 권위는 parent+usage_cd).

### 2.5 마스터 코드·자재·사이즈 실측

| 항목 | 라이브 실측 | round-11 가설 대비 |
|------|------------|-------------------|
| **레더 자재 3-way 혼재** (mat_nm LIKE '레더' 전수) | **.01 종이: MAT_000006 레더하드커버(PRD_000100 연결 1행)** · **.06 가죽: MAT_000008 레더·MAT_000173 레더하드커버 A·174 A5·175 A4(4행 전부 고아, 연결 0)** · **.08 실사소재: MAT_000186 레더(화이트)(6상품 연결)** | 🔴 PB-3 가설(레더=.06 가죽)과 **혼재 불일치**. **Q4 의도(.06 가죽) 행은 이미 라이브에 고아로 실재**(MAT_000008/173~175) → CONFLICT-PB-1. search-before-mint: 신규 mint 불요·고아 .06 재연결이 제3 선택지 |
| PRD_000100 레더 자재 링크 | **2건 모두 연결: MAT_000006(.01 종이·USAGE.02) + MAT_000186(.08 실사소재·USAGE.02)** | 🔴 단일 .08 아님 — 포토북은 레더를 **2 자재행(.01+.08)으로 동시 연결** 중. .06 가죽 고아행은 PRD_000100 미연결 |
| MAT_000250 아트250+무광코팅 | **MAT_TYPE.01 종이 (단일 자재명·코팅 미분리)** | 🔴 G-PB-3 가설(자재+공정 분해)과 **불일치** → CONFLICT-PB-2 |
| MAT_000251 그레이 | MAT_TYPE.01 종이 | ✅ 면지 D-29 정합 |
| SIZ_000272 460x235·SIZ_000277 556x285 | 표지 작업사이즈 **마스터 적재·상품 미연결** | 🟡 표지 펼침 siz 생산용(견적 미노출) CONFLICT-PB-3 |
| SIZ_000269/274/170/172 | 완성품 cut=work, impos_yn=N | ✅ C5 정합 |
| PRD_TYPE | .01 완제품·.02 반제품·.03 기성·.04 디자인·.05 추가 | ✅ |
| USAGE | .01 내지·.02 표지·.03 면지·.04 간지·.05 투명커버·**.06 표지타입**·.07 공통 | ✅ **.06 표지타입 실재**(round-11 미인지·C18 귀속 보강) |
| SEMI_ROLE | .01 내지·.02 표지·.03 면지·.04 간지·.05 투명커버 | ✅ |
| PROC_000020 PUR · PROC_000025 레이플랫 | 둘 다 존재(use_yn=Y), 포토북 연결=PUR만 | ✅ Q10(PUR만·레이플랫 미운영) |
| PROC_000013 코팅 | 존재(family root) | 🟡 표지 코팅 분리 시 사용처 |
| FRM_TYPE | .01 합산형·.02 단순형 | 가격 적재용(round-2) |
| PRC_COMPONENT_TYPE | .01 인쇄·.02 코팅·.03 용지·.04 후가공·.05 박형압·.06 완제품 | 가격 적재용(round-2) |
| QTY_UNIT | .01 EA·.02 매·.03 권·.04 세트·.05 팩 | PRD_000100 qty_unit=.03 권 |

---

## 3. 실측 결산 (M5)

| 분류 | 건수 | 항목 |
|------|:--:|------|
| **존재(적재 확인)** | 9 엔티티 | products(8)·sets(7)·sizes(4)·materials(7)·processes(1)·page_rules(1)·print_options(2)·categories(1)·반제품 빈껍데기 정상 |
| **미적재(적재 대상)** | 1 | 가격 t_prd_product_prices/price_formulas(0행) — C37/38 |
| **충돌(CONFLICT)** | 3 | 레더 자재유형 **3-way 혼재**(.01 종이 MAT_000006 연결·.06 가죽 4행 고아·.08 실사 MAT_000186 연결) + PRD_000100 레더 2건(.01+.08) 동시 연결·표지코팅 평면화(자재 vs 공정)·표지 작업사이즈 미연결 |
| **보완 권고** | 2 | PUR mand_proc_yn N→Y · 소프트 page_rule(4~14) 미반영 |

> **권위:** 매핑 우변(코드값·FK·행 존재/부재)을 전부 라이브에서 실측. 추출본 의존 0. 가격은 **미적재 = 적재 대상**으로 분류(round-2 트랙). 적재는 인간 승인.
