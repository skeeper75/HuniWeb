# 책자 — 라이브 실측 vs 정답 diff (live-diff · round-13 C3)

> **작성** 2026-06-11. 읽기전용 SELECT만(INSERT/UPDATE/DDL 0). 비밀값 비노출.
> **접속(재현):** `set -a; source .env.local; set +a; PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "<SQL>"`
> **실측 일자:** 2026-06-11. **D-1 교훈:** 행존재만 아닌 변형 커버리지·field-for-field.

---

## 1. 상품 적재 실태 (t_prd_products)

```sql
SELECT prd_cd, prd_nm, prd_typ_cd, semi_role_cd, "MES_ITEM_CD", min_qty, max_qty, qty_incr, qty_unit_typ_cd
FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' ORDER BY prd_cd;
```
- **완제품 10**(PRD_TYPE.04): 068 중철·069 무선·070 PUR·071 트윈링·072 하드커버·077 레더하드·082 하드링·088 레더바인더·094 엽서북·097 떡메모지.
- **반제품 21**(PRD_TYPE.02 SEMI_ROLE.02 표지/.03 면지/.01 내지): 073~076(하드 표지+면지3)·078~081(레더하드 표지+면지3)·083~087(하드링 표지+면지4)·089~093(레더바인더 표지+면지4)·095/096(엽서북 내지/표지)·098(떡메모지 내지) = **21**. **F-GATE-BK-1 보정:** 라이브 `GROUP BY prd_typ_cd` = PRD_TYPE.02|21·.04|10. 직전 "17"은 면지·098을 누락 집계.
- **링바인더(보류중)** = 라이브 없음(L1 R51~53 미완성) = **미적재 정상**.
- **MES_ITEM_CD 전량 NULL** — load_master L261 의도적 NULL(원천 MES 7건이 14상품에 중복돼 부분 UNIQUE 위반 회피). L1엔 006-0001~0008 실재. **정답=엑셀 MES 보존이나 라이브 NULL은 의도적**(CORRECT-by-design, 향후 중복정리 후 적재).
- qty_unit_typ_cd 전부 QTY_UNIT.03(권) — 책자 단위=권 정합.

## 2. 자재 usage 슬롯 (t_prd_product_materials)

```sql
SELECT pm.prd_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd FROM t_prd_product_materials pm
JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000068','PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000094','PRD_000097')
ORDER BY pm.prd_cd, pm.usage_cd, m.mat_nm;
```
| 상품 | usage 슬롯 실측 | 정답 기대 | diff |
|------|-----------------|-----------|:--:|
| 068 중철 | .01×13 + .02×13 (몽블랑/스노우/아트/백모조) | 내지.01 + 표지.02 | ✅ |
| 072 하드커버 | 전용지.02×1 + 면지(화이트/블랙/그레이).03×3 | 전용지.02 + 면지.03×3 | ✅ |
| 077 레더하드 | **레더(화이트) MAT_TYPE.08 .02** + 면지.03×3 | 레더.02(의도 .06 가죽) + 면지 | ⚠️ .08 vs Q4 가죽 |
| 082 하드링 | 전용지.02 + 면지.03×4(인쇄 포함) + **링 MAT_TYPE.04 .07×3** | 전용지+면지4+링.07 | ✅ |
| 088 레더바인더 | **레더(화이트) .08 .02** + 면지.03×4 + **D링 MAT_TYPE.07 .07×3** | 레더.02 + 면지4 + D링.07 | ⚠️ .08 |
| 094 엽서북 | 몽블랑240 .01 + 스노우300 .02 | 내지 몽블랑240 + 표지 스노우300 | ✅ |
| **097 떡메모지** | **백색모조120 .01 + 백색모조120 .07(중복)** | 내지 .01 **1행만** | ⚠️ .07 중복 오적재 |

### 2.1 떡메모지(097) 자재 중복 정밀 실측

```sql
SELECT mat_cd, usage_cd, dflt_yn, disp_seq FROM t_prd_product_materials WHERE prd_cd='PRD_000097' ORDER BY usage_cd;
```
→ `MAT_000073 | USAGE.01 | Y | 1` · `MAT_000073 | USAGE.07 | Y | 1` — **동일 mat_cd가 내지(.01)+공통(.07) 둘 다, 둘 다 dflt=Y = 같은 자재가 두 슬롯으로 복제.** 떡메모지는 링/부속 없음(표지조차 없음). .07은 **L1 용도 빈 행이 USAGE.공통(LL-1)으로 떨어진 잡음.**

> **F-GATE-BK-3 정밀화:** 이 "`.01↔.07 동일 mat_cd 중복 복제`"는 **전 DB에서 097 단 1건**(validator 실측: `dup_rows=1`). `SELECT count(*) FROM (SELECT prd_cd, mat_cd FROM t_prd_product_materials WHERE usage_cd IN ('USAGE.01','USAGE.07') GROUP BY prd_cd, mat_cd HAVING count(DISTINCT usage_cd)=2)` → **1**. 별개로 "USAGE.07에 종이 자재가 든 행" 324행(016 엽서 등)이 있으나, 그것은 .01 복제가 아니라 **"용도 미지정 자재 → USAGE.공통 풀"**이라는 약한/정당 가능 현상(별 family 소관·BK-1 결함 아님). 책자 family USAGE.07은 **097 1건 중복 외 전부 링/D링(정당)**.

### 2.2 레더 자재 3-way (CONFLICT-1 재확인)

```sql
SELECT m.mat_cd, m.mat_nm, m.mat_typ_cd, count(pm.prd_cd) AS links
FROM t_mat_materials m LEFT JOIN t_prd_product_materials pm ON m.mat_cd=pm.mat_cd
WHERE m.mat_nm LIKE '%레더%' GROUP BY 1,2,3 ORDER BY 1;
```
- `MAT_000186 레더(화이트) MAT_TYPE.08 실사소재` → **6 연결**(077·088·100·126·174·175). 책자 표지 실연결.
- `MAT_000008 레더 MAT_TYPE.06 가죽` → **0 고아** · `MAT_000173/174/175 레더하드커버 A/A5/A4 .06 가죽` → **0 고아**. **Q4 의도 가죽행 실재·미연결.**
- `MAT_000006 레더하드커버 MAT_TYPE.01 종이` → 1(PRD_000100 포토북類·시트 밖).

### 2.3 sub_prd 자재 보유 (빈 껍데기 위반 탐색)

```sql
SELECT pm.prd_cd, p.prd_nm, count(*) FROM t_prd_product_materials pm
JOIN t_prd_products p ON pm.prd_cd=p.prd_cd
WHERE pm.prd_cd BETWEEN 'PRD_000073' AND 'PRD_000098' AND p.prd_typ_cd='PRD_TYPE.02'
GROUP BY 1,2 ORDER BY 1;
```
→ **PRD_000078만 2행**(나머지 16 sub_prd 자재 0행 정상). 078 실측:
```sql
SELECT mat_cd, mat_nm, mat_typ_cd, usage_cd, dflt_yn, disp_seq FROM t_prd_product_materials pm
JOIN t_mat_materials m USING(mat_cd) WHERE prd_cd='PRD_000078';
```
→ `MAT_000105 몽블랑 130g MAT_TYPE.01 | USAGE.01 | N | 2` · `MAT_000105 몽블랑 130g | USAGE.02 | N | 1`. **078="레더 하드커버책자-표지(레더(화이트))" 반제품인데 자재가 레더 아닌 몽블랑130g, sub_prd인데 자재 보유 — 빈 껍데기 모델 위반.**

## 3. 공정 적재 (t_prd_product_processes)

```sql
SELECT pp.prd_cd, string_agg(pr.proc_nm, ', ' ORDER BY pp.proc_cd) FROM t_prd_product_processes pp
JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd WHERE pp.prd_cd BETWEEN 'PRD_000068' AND 'PRD_000097' GROUP BY 1 ORDER BY 1;
```
| 상품 | 공정 실측 | 정답 | diff |
|------|-----------|------|:--:|
| 068 중철 | 유광·무광·중철제본 | 코팅2+중철+(포장) | ✅(068 개별포장 L1 빈값) |
| 069 무선 | 유광·무광·무선·박8(037~044)·양각·음각·수축포장 | 코팅+무선+박8+형압+수축 | ✅ 변형 풀 |
| 070 PUR | 유광·무광·PUR·박8·양각·음각·수축 | 〃 PUR | ✅ |
| 071 트윈링 | 유광·무광·트윈링·수축 | 코팅+트윈링+수축 | ✅ |
| 072 하드커버 | 유광·무광·하드커버무선·수축 | 코팅+하드커버무선+수축 | ✅ |
| 077 레더하드 | 하드커버무선·수축 (**코팅 0행**) | 코팅 0(L1 R42 빈값)+하드커버무선+수축 | ✅(round-11 코팅 가설 반증) |
| 082 하드링 | 유광·무광·하드커버트윈링·수축 | 〃 | ✅ |
| **088 레더바인더** | **(0행)** | 제본 없음(정당) + 후공정 컨펌 | 🟡 수축포장도 없음 |
| 094 엽서북 | 무광·떡제본·수축 | 무광+떡+수축 | ✅ |
| 097 떡메모지 | 떡제본 (코팅/박 없음·포장 없음) | 떡제본 | ✅ |

```sql
SELECT count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000088';  -- → 0
SELECT pp.mand_proc_yn, count(*) FROM t_prd_product_processes pp JOIN t_proc_processes pr ON pp.proc_cd=pr.proc_cd
WHERE pr.upr_proc_cd='PROC_000017' AND pp.prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' GROUP BY 1;  -- → N|9
```
- 제본 9행 전부 mand_proc_yn=N(round-11 Y 정정). 박색 8종=PROC_000037~044 자식(Q2 ★ 공정 정합).

## 4. page_rule / bundle (t_prd_product_page_rules · t_prd_product_bundle_qtys)

```sql
SELECT prd_cd, page_min, page_max, page_incr FROM t_prd_product_page_rules WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' ORDER BY 1;
SELECT prd_cd, bdl_qty, bdl_unit_typ_cd FROM t_prd_product_bundle_qtys WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' ORDER BY 1;
```
| 상품 | page_rule | bundle | diff |
|------|-----------|--------|:--:|
| 068 중철 | 4/28/4 | — | ✅ 4배수 |
| 069/070/072/077 | 24/300/2 | — | ✅ |
| 071/082 | 8/100/2 | — | ✅ |
| 094 엽서북 | 20/30/10 | — | ✅ 엽서장수 |
| **097 떡메모지** | **3/3/3** | **50·100 QTY_UNIT.03** | ⚠️ page_rule 3/3/3 잡음(묶음수가 진짜 축) |
| 088 레더바인더 | (없음) | — | ✅ 빈 바인더 |

## 5. sizes / plate (t_prd_product_sizes · t_prd_product_plate_sizes)

```sql
SELECT prd_cd, string_agg(s.siz_nm, ', ' ORDER BY ps.disp_seq) FROM t_prd_product_sizes ps
JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd IN ('PRD_000068','PRD_000071','PRD_000088','PRD_000094','PRD_000097') GROUP BY 1;
SELECT count(*) total, count(output_paper_typ_cd) opt_nn, count(output_file_typ) oft_nn FROM t_prd_product_plate_sizes WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098';
```
- sizes: 068 A5/A4 · 071 A5×2/A4×2 · 088 A4 · 094 100x150/150x100/135x135 · 097 90x90/70x120 — 전부 L1 정합 ✅.
- **plate: total 32 · output_paper_typ_cd 0(전량 NULL) · output_file_typ 12**(PDF 일부) → **GAP-PAPER**(C12/C23 폴더 미적재) + output_file_typ 부분 적재.
- **책등 두께 size("A4 두께A 31mm" 등)** 라이브 미실재(보류중 링바인더 R51~53만 해당, 보류라 정상). 088은 "A4"만 + D링 자재로 책등 표현 — 두께 size 인코딩 미적재(정답 모델은 D링 mm가 책등이라 정합 가능, Q-BK-E).

## 6. 카테고리 / option_groups / sets

```sql
-- 068~071 실제 연결 레벨 (F-GATE-BK-2)
SELECT pc.prd_cd, cc.cat_cd, cc.cat_nm, cc.cat_lvl FROM t_prd_product_categories pc
JOIN t_cat_categories cc ON pc.cat_cd=cc.cat_cd WHERE pc.prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071') ORDER BY 1;
-- 전용 잎노드 상품 연결 수
SELECT cc.cat_cd, cc.cat_nm, count(pc.prd_cd) links FROM t_cat_categories cc
LEFT JOIN t_prd_product_categories pc ON cc.cat_cd=pc.cat_cd
WHERE cc.cat_cd IN ('CAT_000100','CAT_000101','CAT_000102','CAT_000103','CAT_000105','CAT_000106','CAT_000107') GROUP BY 1,2 ORDER BY 1;
SELECT pc.cat_cd, cc.cat_nm, cc.cat_lvl, pc.main_cat_yn FROM t_prd_product_categories pc JOIN t_cat_categories cc ON pc.cat_cd=cc.cat_cd WHERE pc.prd_cd='PRD_000097';
SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098';  -- → 0
```
- **068~071 = `CAT_000006 책자(lvl1)` 직결**(전용 잎노드 아님). 전용노드 실측: **CAT_000100 중철·101 무선·102 PUR·103 트윈링·106 레더하드·107 하드링 = 상품 0(고아)** · **CAT_000105 하드커버책자 = 22 연결**(077·082 등이 여기 묶임). **BK-CAT** — F-GATE-BK-2 신규(전용 잎노드 6개 고아·상품 상위노드 직결, digital-print F-GATE-1 동형 횡단).
- **떡메모지(097)**: `CAT_000129 떡메모지(upr 노트·lvl3) main=Y` + `CAT_000124 노트(upr CAT_000008·lvl2) main=Y` → **2중 연결·main 둘 다 Y(모순).** 다른 책자는 2중 연결 0(097만).
- **CAT_000297 레드프린팅 책자 가이드**(upr=NULL·lvl3 고아) 실재 — 책자 상품 연결 없음(잉여 고아 노드, L1 R85 URL행 파생).
- **option_groups 0행** — 책자 CPQ 옵션 레이어 전면 미적재(OM-6). 상품=제본 1:1이라 현 모델 불요(GAP-OG).
- sets 21행: 072→면지3+표지·077→면지3+표지·082→면지4+표지·088→면지4+표지·094→내지+표지·097→내지. parent 자재 병행(Q3 정합).

## 7. 가격사슬 (Phase11 스키마 — 참고)

```sql
SELECT comp_cd, comp_nm FROM t_prc_price_components WHERE comp_nm ~ '제본|엽서북|떡메모|중철|무선|PUR|하드커버' LIMIT 20;
```
- COMP_BIND_*(제본비)·COMP_PCB_S*(엽서북 단가)·COMP_TTEOKME(떡메모지 단가) 실재 = 책자 가격 일부 적재됨. price_components에 prd_cd 컬럼 없음(상품 연결=별 경로, round-13 책자 핵심 아님 — 존재 확인만).
- Phase11: t_prc_component_prices에 proc_cd·opt_cd 차원 신설, prc_typ_cd(단가/합가형) 신설(sql/21). 책자 가격 매핑은 round-2/6 stale 가능(round-14 경고) — 본 감사 범위 외.

---

## 실측 결론
- **존재·정합(CORRECT):** 상품 31(완제품10+sub_prd21)·제본 자식·박색 공정 자식·코팅(077 코팅 0=L1 정합)·page_rule·bundle·sizes·sets·자재 usage 대부분.
- **오적재(MIS-LOADED):** 떡메모지 USAGE.07 종이 중복(.01 복제, 전 DB 1건)·078 sub_prd 몽블랑130g 자재(빈 껍데기 위반)·레더 표지 .08(Q4 의도 가죽).
- **미적재(MISSING/GAP):** plate output_paper_typ_cd 전량 NULL(폴더 C12/23)·option_groups 0행(1:1이라 불요)·088 후공정(컨펌).
- **잉여(EXTRA):** **CAT_000100~103·106·107 전용 잎노드 고아·068~071 상위노드 직결(BK-CAT)**·CAT_000297 고아 노드·떡메모지 카테고리 2중연결(main Y×2)·떡메모지 page_rule 3/3/3.
