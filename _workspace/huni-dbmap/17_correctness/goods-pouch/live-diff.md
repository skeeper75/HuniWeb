# 굿즈파우치 — 라이브 실측 vs 정답 대조 (live-diff · round-13 C3)

> **작성** 2026-06-11 · round-13. 각 대표상품의 라이브 t_* 행을 읽기전용으로 전수 측정하고 extraction-plan(C2) 정답값과 field-for-field 대조. 재현 SELECT 포함(비밀값 없음). 측정 시각 = 2026-06-11.
> **라이브 접속:** `.env.local` RAILWAY_DB_* read-only SELECT only. 굿즈 상품 범위 = `PRD_000183`~`PRD_000290`(약 101 상품).

---

## 0. 굿즈 전체 적재 집계 (횡단 실측)

```sql
SELECT
 (SELECT count(*) FROM t_prd_product_sizes        WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') sizes,
 (SELECT count(*) FROM t_prd_product_materials    WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') mats,
 (SELECT count(*) FROM t_prd_product_processes    WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') procs,
 (SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') printopts,
 (SELECT count(*) FROM t_prd_product_addons       WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') addons,
 (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') optgroups,
 (SELECT count(*) FROM t_prd_product_sets         WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') sets,
 (SELECT count(*) FROM t_prd_product_bundle_qtys  WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290') bundles;
```

| 엔티티 | 라이브 실측 | 정답 기대 | diff |
|--------|:--:|------|------|
| sizes | 28 | 치수형 22 + (옵션형 0 → §7) ≈ 22 | 🟡 치수형 정상·옵션형 부재 |
| materials | 130 | 본체 소재 ~103 + 색 합성 — 폭증·오염 多 | 🔴 색×사이즈 폭증·비소재 자재화 |
| processes | 6 | 인쇄방식+후가공 = 수백 행 기대 | 🔴 거의 전면 누락(봉제/에폭시/맥세이프) |
| print_options | 0 | 만년스탬프 잉크색·면 = 수십 행 | 🔴 전면 미적재 |
| addons | 0 | 볼체인/리필잉크 링크 = 수 행 | 🔴 전면 미적재(대상 PRD는 실재) |
| option_groups | 0(굿즈 183~290) | 옵션형 사이즈 = 58상품×옵션 | 🔴 굿즈 상품군 CPQ 레이어 미적재(굿즈 범위 0행 정확·전역 6행은 001/002 테스트·066·138 = 굿즈 무관) |
| sets | 0 | 0(굿즈=세트 아님) | ✅ CORRECT |
| bundles | 3 | (굿즈 묶음 일부) | 🟡 |

---

## 1. 거울 5상품 (소품)

```sql
SELECT p.prd_nm, pc.cat_cd, c.cat_nm, COALESCE(c.upr_cat_cd,'NULL'), c.cat_lvl
FROM t_prd_product_categories pc JOIN t_prd_products p ON pc.prd_cd=p.prd_cd
JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd WHERE p.prd_nm LIKE '%거울';
```
| 상품 | 라이브 카테고리 | 정답 | diff |
|------|------|------|------|
| 틴/컴팩트/카드/사각손/블랙사각손 거울 | CAT_000301 소품(upr NULL·lvl3 고아) | CAT_000165~169(upr=010 라이프·lvl2 정상) | 🔴 MIS-LOADED(고아 오연결, 정상 노드 실재) |

```sql
SELECT ps.siz_cd, s.siz_nm, s.work_width, s.work_height FROM t_prd_product_sizes ps
JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='사각손거울');
```
| 항목 | 라이브 | 정답 | diff |
|------|------|------|------|
| 사각손거울 size | SIZ_000384 S(75x130mm)·386 M(95x166)·388 L(120x218) | 치수형 S/M/L | ✅ CORRECT(치수형 정상 적재) |

---

## 2. 머그컵 (라이프)

```sql
SELECT m.mat_nm, m.mat_typ_cd, bc.cod_nm, pm.usage_cd FROM t_prd_product_materials pm
JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd LEFT JOIN t_cod_base_codes bc ON m.mat_typ_cd=bc.cod_cd
WHERE pm.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='머그컵');
```
| 라이브 자재 | mat_typ | 정답 | diff |
|------|------|------|------|
| 투명 | MAT_TYPE.01 종이 | 머그 본체색(세라믹/.10 악세사리) | 🔴 자재유형 오염(종이) |
| 반투명 | MAT_TYPE.01 종이 | 본체색 | 🔴 오염 |
| 화이트 | MAT_TYPE.08 실사소재 | 본체색 | 🔴 오염 |
| 11온스 | MAT_TYPE.09 파우치 | **용량=규격(siz, huni-goods §2.3) not 자재** | 🔴 MIS-LOADED(용량 자재화) |
| 카테고리 | CAT_000010 라이프(lvl1 ROOT) | 머그컵 정상 노드(CAT_000170, upr=010·lvl3) | 🟡 ROOT 직결(말단 노드 미사용) |

---

## 3. 핀버튼 (기념품/액세서리)

```sql
SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd=p.prd_cd) sz,
       (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd=p.prd_cd) mt
FROM t_prd_products p WHERE p.prd_nm='핀버튼';
-- → sz=0, mt=2
SELECT m.mat_nm, m.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='핀버튼');
```
| 항목 | 라이브 | 정답 | diff |
|------|------|------|------|
| size | 0행 | 형상=규격(원형32/44/58/75·사각57·하트 → t_siz_sizes) | 🔴 형상 size 미적재 |
| 자재 | "원형 58mm·사각 57mm"(MAT_TYPE.09 파우치) | 형상=size·소재(금속.04) | 🔴 MIS-LOADED(형상이 자재행·자재유형 오염) |

---

## 4. 반팔티셔츠 (패션·의류)

```sql
SELECT m.mat_nm, m.mat_typ_cd, pm.usage_cd FROM t_prd_product_materials pm
JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='반팔티셔츠') ORDER BY pm.mat_cd;
```
| 라이브 자재(8행) | mat_typ | 정답 | diff |
|------|------|------|------|
| 화이트 M/L/XL/XXL · 블랙 M/L/XL/XXL | MAT_TYPE.09 파우치·USAGE.07 | 본체색(화이트/블랙) 2행 + 규격(M/L/XL/XXL) §7 옵션. 자재유형=.05 원단 | 🔴 MIS-LOADED(색×사이즈 8행 폭증·자재유형 오염·과분할) |
| 공정 | 0행 | 전사인쇄(외주) | 🔴 인쇄방식 미적재 |
| 카테고리 | CAT_000206 패션(upr=010·lvl2) | 패션 또는 의류 말단 | ✅ NORMAL(정상 노드) |

---

## 5. 만년스탬프 (데스크)

```sql
SELECT m.mat_nm, m.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='만년스탬프') ORDER BY pm.mat_cd;
```
| 라이브 자재(7행) | mat_typ | 정답 | diff |
|------|------|------|------|
| 청보라·빨강·검정·파랑·초록·핑크·노랑 | MAT_TYPE.09 파우치 | **잉크색=도수**(huni-goods §2.2 → t_clr/print_options) not 자재 | 🔴 MIS-LOADED(잉크색 자재화) |
| 추가상품(리필잉크) | 0행 | 리필잉크 PRD_000015 addon 링크 | 🔴 미적재(대상 PRD 실재) |
| 카테고리 | CAT_000302 데스크/사무용품(고아) | 정상 데스크 노드 | 🔴 고아 오연결 |
| editor_yn | N(만년스탬프만 N) | (스탬프=업로드 전용) | ✅ |

---

## 6. 레더 삼각 파우치 (레더파우치)

```sql
SELECT p.prd_nm, pc.cat_cd, c.cat_nm, COALESCE(c.upr_cat_cd,'NULL'), c.cat_lvl
FROM t_prd_product_categories pc JOIN t_prd_products p ON pc.prd_cd=p.prd_cd JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd
WHERE p.prd_nm LIKE '레더%파우치';
```
| 항목 | 라이브 | 정답 | diff |
|------|------|------|------|
| 카테고리(레더 N 파우치 6+) | CAT_000305 레더파우치(upr NULL·lvl3 고아) | CAT_000213~221 레더 N 파우치(upr=011 에코백·lvl2 정상) | 🔴 MIS-LOADED(고아 오연결·정상 노드 실재) |
| 자재 | 2행 | 가죽(.06) 본체 | 🟡 부분(형상 variant 처리 확인 필요) |
| 공정(봉제) | 0행 | 봉제 PROC_000080(D-24) | 🔴 봉제 미적재 |

---

## 7. 캔버스에코백 (패브릭에코백)

```sql
SELECT pp.proc_cd, pr.proc_nm, pr.upr_proc_cd, pp.mand_proc_yn
FROM t_prd_product_processes pp JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd
WHERE pp.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='캔버스에코백');
```
| 항목 | 라이브 | 정답 | diff |
|------|------|------|------|
| 공정 | PROC_000081 부착(mand=N) | **봉제 PROC_000080**(패브릭→봉제미싱 §9) | 🔴 MIS-LOADED(봉제→부착 오적재) |
| 자재 | 1행·proc 1행 | 캔버스(.05 원단)·봉제 | 🟡 |
| 카테고리 | CAT_000254 패브릭에코백(upr=011·lvl2) | 패브릭에코백 | ✅ NORMAL |

> 굿즈 공정 6행 전수(`SELECT p.prd_nm,pr.proc_cd,pc.proc_nm FROM t_prd_product_processes pr JOIN ... WHERE pr.prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290';`) = 캔버스 플랫/삼각 파우치·플랫/삼각 필통·심플백·에코백 6개, **전부 PROC_000081 부착**. 봉제 정답인데 부착으로 오적재.

---

## 8. 추가상품 대상 PRD 실재 확인 (search-before-mint)

```sql
SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_nm LIKE '%볼체인%' OR prd_nm LIKE '%리필잉크%';
```
| 라이브 | 정답 활용 | diff |
|------|------|------|
| PRD_000006 볼체인(PRD_TYPE.03) | 키링 addon 링크 대상 | ✅ 실재(재연결, mint 불요) |
| PRD_000015 만년스탬프 리필잉크(PRD_TYPE.03) | 만년스탬프 addon 링크 대상 | ✅ 실재(재연결) |

> **굿즈 addons=0** — addon 대상 상품(볼체인·리필잉크)은 별 PRD로 실재하나 `t_prd_product_addons` 링크가 0행. search-before-mint 재연결로 교정(레더 .06 고아 재연결 패턴 동형).

---

## 9. 카테고리 고아 노드 전수 + 굿즈 연결 분포 (재현)

```sql
SELECT cat_cd, cat_nm, cat_lvl FROM t_cat_categories WHERE upr_cat_cd IS NULL AND cat_lvl>1 ORDER BY cat_cd;
-- → CAT_000293~306 (14개·전부 lvl3 고아)
SELECT CASE WHEN c.upr_cat_cd IS NULL AND c.cat_lvl>1 THEN 'ORPHAN' WHEN c.upr_cat_cd IS NULL AND c.cat_lvl=1 THEN 'ROOT' ELSE 'NORMAL' END, count(*)
FROM t_prd_product_categories pc JOIN t_prd_products p ON pc.prd_cd=p.prd_cd JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd
WHERE p.prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290' GROUP BY 1;
-- → NORMAL 56 · ORPHAN 35 · ROOT 8
```
| status | 굿즈 상품 수 | diff |
|--------|:--:|------|
| NORMAL(upr set·정상 노드) | 56 | ✅ |
| ORPHAN(lvl3·upr NULL 고아) | 35 | 🔴 MIS-LOADED(재연결 대상) |
| ROOT(lvl1 직결·말단 미사용) | 8 | 🟡 AMBIGUOUS(머그=라이프 ROOT 등) |

> 굿즈 고아 노드별 상품: 소품(301)=5·데스크(302)=9·말랑(304)=9·레더파우치(305)=9·디지털악세서리(303)=2·에코백부자재(306)=1 = 35.
