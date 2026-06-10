# 책자 — 라이브 실측 대조 (round-12 P3)

> **작성** 2026-06-10. 읽기전용 SELECT만 수행(INSERT/UPDATE/DDL 0). 비밀값 비노출.
>
> **접속 패턴(재현):** `set -a; source .env.local; set +a; PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "<SQL>"`
>
> **목적:** mapping-final 우변(t_* 행·코드값·FK)을 라이브에서 실측. D-1 교훈(행존재만이 아닌 변형 커버리지) 적용.

---

## 1. 책자 상품 적재 실태 (t_prd_products)

```sql
SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products
WHERE prd_nm ~ '책자|떡메모지|엽서북|바인더|하드커버|트윈링|중철|무선|PUR' ORDER BY prd_cd;
```
- **완제품(PRD_TYPE.04 디자인상품):** PRD_000068 중철책자·069 무선책자·070 PUR책자·071 트윈링책자·072 하드커버책자·077 레더 하드커버책자·082 하드커버 링책자·088 레더 링바인더·094 엽서북·097 떡메모지 = **11 완제품**.
- **반제품(PRD_TYPE.02):** 073~076(하드커버 표지/면지)·078~081(레더 표지/면지)·083~087(하드링 표지/면지+인쇄면지)·089~093(레더바인더 표지/면지+인쇄)·095/096(엽서북 내지/표지)·098(떡메모지 내지) = **17 sub_prd**.
- **발견:** 완제품이 전부 PRD_TYPE.04(디자인상품) — Q6 에디터 템플릿 정합 가능. 반제품 표지/면지는 별 상품행으로 실재(round-11 "sub_prd 빈 껍데기" 모델 = 라이브 사실).

## 2. 제본 공정 family (t_proc_processes)

```sql
SELECT proc_cd, proc_nm, upr_proc_cd FROM t_proc_processes
WHERE upr_proc_cd='PROC_000017' OR proc_cd='PROC_000017' ORDER BY proc_cd;
```
- PROC_000017 제본(root) — prcs_dtl_opt = `{방향:좌철/상철, 묶음단위, 책등(mm), 고리형:bool}`.
- 자식 9종: 018 중철·019 무선·020 PUR·021 트윈링·022 떡·023 하드커버무선·024 하드커버트윈링·**025 레이플랫제본**.
- **발견:** 레이플랫제본 PROC_000025 **코드 존재**(round-11 "미운영=코드 부재" 가설 정정 → 코드 존재·상품 미연결). Q10 PUR만 정합.

## 3. 박/형압/코팅/포장 공정 트리

```sql
SELECT proc_cd, proc_nm, upr_proc_cd FROM t_proc_processes
WHERE proc_cd IN ('PROC_000014','PROC_000015','PROC_000037','PROC_000038','PROC_000051','PROC_000052','PROC_000076');
```
| 공정 root | 자식 | 비고 |
|-----------|------|------|
| PROC_000013 코팅 | 014 유광·015 무광 | C26 표지코팅 |
| PROC_000033 박 | **037 홀로그램·038 금유광·039 은유광·040 먹유광·041 동박·042 적박·043 청박·044 트윙클** | **C30 박칼라=공정 자식**(Q2 ★ 실측 확정). prcs_dtl_opt=`{크기 mm}` |
| PROC_000050 형압 | 051 양각·052 음각 | C28. 양각도 크기 param |
| PROC_000075 포장 | 076 수축포장 | C42 |

## 4. 상품별 공정 적재 (t_prd_product_processes) — 변형 커버리지

```sql
SELECT pp.prd_cd, pp.proc_cd, pr.proc_nm, pp.mand_proc_yn FROM t_prd_product_processes pp
JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd WHERE pp.prd_cd IN (...) ORDER BY 1,2;
```
- 중철책자(068): 014/015 코팅 + 018 중철 + (포장). **무선책자(069): 코팅+019 무선+박8종(037~044)+양각051+음각052+수축076** = 박/형압 풀 변형 적재.
- PUR(070): 코팅+020 PUR+박8종+형압+포장. 트윈링(071): 코팅+021 트윈링+포장.
- 하드커버(072): 코팅+023. 레더하드(077): 023+포장(코팅 없음). 하드링(082): 코팅+024.
- 엽서북(094): 015 무광+022 떡+076. 떡메모지(097): 022 떡만.
- **레더 링바인더(088): 제본 family(PROC_000017 자식) 미연결** — C4/CONFIRM-BK-2 확정(바인더=제본 없음).
- **mand_proc_yn:** 책자 제본 9행 **전부 N**(round-11 "제본 mand=Y" 정정).

```sql
SELECT pp.mand_proc_yn, count(*) FROM t_prd_product_processes pp
JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd
WHERE pr.upr_proc_cd='PROC_000017' AND pp.prd_cd LIKE 'PRD_0000%' GROUP BY 1;
```
→ `N | 9`

## 5. 자재 usage 슬롯 (t_prd_product_materials) + 자재유형 (t_mat_materials)

```sql
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_cd IN
('MAT_000001','MAT_000002','MAT_000003','MAT_000004','MAT_000246','MAT_000186','MAT_000247','MAT_000244','MAT_000013');
```
| 자재 | mat_cd | mat_typ_cd | usage(상품적재) | 비고 |
|------|--------|-----------|-----------------|------|
| 화이트/블랙/그레이/인쇄면지 | 001~004 | **MAT_TYPE.01 종이** | USAGE.03 면지 | C33. D-29 정합 |
| 전용지 | 246 | MAT_TYPE.01 종이 | USAGE.02 표지 | C24 하드커버 |
| 레더(화이트) | 186 | **MAT_TYPE.08 실사소재** | USAGE.02 표지 | **CONFLICT-1** 3-way(아래 §5.1) |
| 링 화이트/블랙/메탈 | 013~015 | MAT_TYPE.04 금속 | USAGE.07 공통 | C34. Q5 자재 |
| D링 31/42/56mm | 247~249 | MAT_TYPE.07 부속 | USAGE.07 공통 | C35. 책등 두께 |
| 투명커버 유광/무광 | 244/245 | MAT_TYPE.02 필름 | USAGE.05 투명커버 | C27. Q5 자재 |
- **발견:** 내지/표지 종이(`*별도설정`)는 parent에 usage.01/.02로 다수 적재(중철책자 내지 13종·표지 13종). 면지/링/D링/투명커버 usage 라이브 권위.

### 5.1 레더 자재 3-way 전수 실측 (D-BK-1 보정 — search-before-mint)

> 직전 단일 인용("레더=MAT_TYPE.08")이 부분실측이었음(M5 FAIL). 라이브 레더류 자재는 **3개 mat_typ_cd에 6행 혼재**하며, Q4가 의도한 가죽(.06) 자재행이 **이미 라이브에 실재(전부 고아)**한다.

```sql
-- 레더류 자재 전수 + 상품 연결 수(고아 여부)
SELECT m.mat_cd, m.mat_nm, m.mat_typ_cd, count(pm.prd_cd) AS prd_links,
       string_agg(DISTINCT pm.prd_cd, ',' ORDER BY pm.prd_cd) AS prds
FROM t_mat_materials m
LEFT JOIN t_prd_product_materials pm ON m.mat_cd=pm.mat_cd
WHERE m.mat_nm LIKE '%레더%'
GROUP BY m.mat_cd, m.mat_nm, m.mat_typ_cd ORDER BY m.mat_cd;
```

| mat_cd | mat_nm | mat_typ_cd | 연결 상품수 | 연결 상품 | 비고 |
|--------|--------|-----------|:--:|-----------|------|
| MAT_000006 | 레더하드커버 | **MAT_TYPE.01 종이** | 1 | PRD_000100 | 책자 시트 밖(포토북類 PRD_000100). "종이"로 분류된 레더 |
| MAT_000008 | 레더 | **MAT_TYPE.06 가죽** | **0(고아)** | — | Q4 의도 가죽행 실재·미연결 |
| MAT_000173 | 레더하드커버 A | **MAT_TYPE.06 가죽** | **0(고아)** | — | 가죽·고아 |
| MAT_000174 | 레더하드커버 A5 | **MAT_TYPE.06 가죽** | **0(고아)** | — | 가죽·고아 |
| MAT_000175 | 레더하드커버 A4 | **MAT_TYPE.06 가죽** | **0(고아)** | — | 가죽·고아 |
| MAT_000186 | 레더(화이트) | **MAT_TYPE.08 실사소재** | 6 | PRD_000077,088,100,126,174,175 | 실제 연결 자재(.08) |

```sql
-- 책자 in-scope 레더 상품의 실제 표지 자재 연결
SELECT pm.prd_cd, p.prd_nm, pm.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd
FROM t_prd_product_materials pm
JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
JOIN t_prd_products p ON pm.prd_cd=p.prd_cd
WHERE pm.prd_cd IN ('PRD_000077','PRD_000078','PRD_000088','PRD_000089')
  AND m.mat_nm LIKE '%레더%' ORDER BY pm.prd_cd;
```
- **PRD_000077 레더 하드커버책자** → MAT_000186 레더(화이트) **MAT_TYPE.08 실사소재** · USAGE.02 표지.
- **PRD_000088 레더 링바인더** → MAT_000186 레더(화이트) **MAT_TYPE.08 실사소재** · USAGE.02 표지.
- 표지 sub_prd(PRD_000078/089)는 레더 자재 직접 연결 0행(자재 권위=parent usage_cd, sub_prd 빈 껍데기 정상).

- **결론(D-BK-1):** 책자 in-scope 레더 상품 2종은 **둘 다 MAT_000186(.08 실사소재)**를 연결. 가죽(.06) 자재행 4개(MAT_000008/173/174/175)는 **실재하나 전부 고아** → Q4가 의도한 가죽 자재가 이미 마스터에 있으므로 컨펌은 양자택일(가죽 신설 vs .08 유지)이 아니라 **3선택지**(.08 유지 / 기존 .06 고아행 재연결 / .06 신설)다. search-before-mint = .06 신설 불요(고아행 재사용 가능).

## 6. page_rule / bundle_qtys (변형 커버리지)

```sql
SELECT prd_cd, page_min, page_max, page_incr FROM t_prd_product_page_rules WHERE prd_cd IN (...);
SELECT prd_cd, bdl_qty, bdl_unit_typ_cd FROM t_prd_product_bundle_qtys WHERE prd_cd IN (...);
```
| 상품 | page_rule | bundle | 비고 |
|------|-----------|--------|------|
| 중철책자 068 | 4/28/4 | — | 중철 4배수 ✅ |
| 무선/PUR/하드 069/070/072/077 | 24/300/2 | — | ✅ |
| 트윈링/하드링 071/082 | 8/100/2 | — | ✅ |
| 엽서북 094 | 20/30/10 | — | 엽서 장수 ✅ |
| 떡메모지 097 | **3/3/3** | **50·100 권(QTY_UNIT.03)** | **CONFLICT-2**(page_rule 3/3/3 잡음 의심+묶음수 둘 다) |

## 7. sets (반제품 연결) — 21행 실재

```sql
SELECT * FROM t_prd_product_sets WHERE prd_cd IN (...) ORDER BY prd_cd;
```
- 하드커버(072)→표지(073)+면지3(074~076). 레더(077)→표지(078)+면지3. 하드링(082)→표지(083)+면지4(인쇄포함). 레더바인더(088)→표지(089)+면지4. 엽서북(094)→내지(095)+표지(096). 떡메모지(097)→내지(098).
- ref_nm에 `표지=전용지`·`면지=화이트면지` 등 의미 라벨 보유.
- **발견:** sets는 적재됨 + parent에 자재도 usage_cd로 동시 적재 → **자재 권위=parent+usage_cd, sets는 생산 BOM 연결**(병행, 모순 아님). Q3 "제본 전체관점" 정합.

## 8. plate_sizes (C8/C9/C11/C12/C20/C22/C23)

```sql
SELECT prd_cd, siz_cd, output_paper_typ_cd, output_file_typ FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000069';
SELECT count(*) total, count(output_paper_typ_cd) non_null FROM t_prd_product_plate_sizes WHERE prd_cd IN (...);
```
- PRD_000069: SIZ_000250(150x214) output_file_typ=PDF·SIZ_000252(213x303) NULL.
- **output_paper_typ_cd 전부 NULL(total 19 / non_null 0)** → C12/C23 폴더(출력용지규격) 미적재 = **GAP-PAPER**.
- output_file_typ(C11/C22) 일부만 'PDF' 적재(나머지 NULL) → 🟡.

## 9. option_groups (C31 택일그룹)

```sql
SELECT prd_cd, opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd IN (책자 11);
```
→ **0행**(책자 option_groups 전면 미적재 = OM-6). GRP-BOOK-제본 택일그룹 미적재. 단 상품=제본 1:1이라 현 모델에선 불요(GAP-OG 처분 참조).

## 10. 코드값 검증 (t_cod_base_codes, upr_cod_cd 트리)

```sql
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE upr_cod_cd='<GRP>' ORDER BY cod_cd;
```
- USAGE: .01 내지·.02 표지·.03 면지·.04 간지·.05 투명커버·.06 표지타입·.07 공통.
- MAT_TYPE: .01 종이·.02 필름·.04 금속·.06 가죽·.07 부속·.08 실사소재(11종).
- QTY_UNIT.03=권. SEL_TYPE.01=단일. PRD_TYPE.02=반제품·.04=디자인상품. SEMI_ROLE.02 표지·.03 면지.
- **간지 USAGE.04:** 책자 미사용(t_prd_product_materials usage_cd='USAGE.04' 0행).

---

## 실측 결론
- **존재(적재됨):** 상품 28(완제품11+sub_prd17)·제본 자식·박색 공정·코팅·형압·포장·자재 usage 슬롯·page_rule·bundle·sets·plate siz·print_options → mapping-final ✅ 우변 검증 완료.
- **미적재(GAP):** option_groups(택일그룹) 0행·output_paper_typ_cd 0행(폴더).
- **CONFLICT:** 레더 자재유형(.08 vs Q4 가죽)·떡메모지 page_rule 3/3/3(잡음 의심).
- **정정:** 레이플랫 코드 존재(미운영=상품 미연결)·제본 mand_proc_yn=N·박색=공정 자식.
