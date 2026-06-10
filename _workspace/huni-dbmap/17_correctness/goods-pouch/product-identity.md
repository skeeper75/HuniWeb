# 굿즈파우치(가격포함) — 상품 정체 (product-identity · round-13 C-ID)

> **작성** 2026-06-11 · round-13 라이브 정합 교정 확대 #2(디지털인쇄 파일럿 → 굿즈파우치). 권위 0(상품 정체) = 실제 후니 커머스 사이트 + 기존 크롤 + product-master + round-11 BOM.
> **프레임:** 칼럼 추출(C2) 전에 "이 상품이 무엇인가"를 확정. 정체가 틀리면(예: 폰케이스를 파우치 소재로 봄) 모든 속성축 추출이 틀린다.
> **출처 표기:** product-master = `_workspace/print-quote/02_business/product-master.md` · round-11 BOM = `15_domain-spec/goods-pouch/product-bom.md:§` · L1 = `06_extract/goods-pouch-l1.csv` · 라이브 = read-only psql.

---

## 0. 시트 구조 — "103 상품 · 19 구분(상품군) · 색상×사이즈 variant · 혼합 인쇄방식 7종"

굿즈파우치(가격포함) 시트는 **103 distinct 상품**(L1 prd_nm 기준, 829 데이터행 = 색상×사이즈 variant 평면화). 디지털인쇄와 달리 **`구분`(상품군)이 풍부(19종)** 하며 인쇄방식·후가공·구간할인을 가른다.

| `구분`(상품군) | 대표 상품(라이브 prd_cd) | 범주(실제) | 인쇄방식(폴더) |
|------|------|----------|----------------|
| 소품(거울) | 틴거울 PRD_000183~ | 굿즈(009 액세서리)·일부 라이프 | UV/디지털/전사 |
| 라이프 | 머그컵 PRD_000193 | 굿즈/생활 | UV/실사/전사/패브릭 |
| 기념품/액세서리 | 핀버튼 PRD_000200 | 굿즈 | UV/디지털/전사 |
| 패션(의류) | 반팔티셔츠 PRD_000206 | 굿즈(의류) | **전사인쇄(외주)** |
| 데스크/사무용품 | 만년스탬프 PRD_000217 | 굿즈 | UV/디지털/**만년도장** |
| 말랑(PVC고주파) | 말랑키링 PRD_000221 | 굿즈 | **이지굿즈(PVC고주파)** |
| 레더파우치 | 레더 삼각 파우치 PRD_000232 | 패션잡화(파우치) | **패브릭인쇄→봉제** |
| 패브릭에코백 | 캔버스에코백 PRD_000270 | 패션잡화(에코백) | **패브릭인쇄→봉제** |
| 폰케이스 | 슬림하드 폰케이스 | 굿즈(폰케이스) | UV/디지털 |

> **라이브 실측(read-only):** 굿즈 상품 범위 = `PRD_000183`~`PRD_000290`(약 101 상품). 전부 `prd_typ_cd=PRD_TYPE.03(기성상품)`·`MES_ITEM_CD=NULL`·`editor_yn=Y`(만년스탬프만 N)·`file_upload_yn=Y`·`use_yn=Y`.
> 재현: `SELECT prd_cd,prd_nm,prd_typ_cd,"MES_ITEM_CD",editor_yn FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290';`

---

## 1. 상품별 정체 확정표 (대표 + 군 일반화)

| 상품 | 라이브 prd_cd | 범주(실제) | 구성 | 생산방식(공정) | 정체 출처 | 라이브 분류 정합 |
|------|------|----------|------|----------------|----------|:--:|
| 틴거울/컴팩트/카드/사각손/블랙사각손 거울 | PRD_000183~187 | **굿즈(소품·거울)** | 단품(거울+프레임) | UV/디지털출력→조립(거울+프레임)→포장 | product-bom §10·L1 구분=소품 | 🔴 카테고리 고아오연결(F-ID-1) |
| 머그컵 | PRD_000193 | **굿즈(라이프)** | 단품 | UV출력→포장 | product-bom §4·huni-goods §2.3 | 🔴 자재유형 오적재(F-ID-3) |
| 핀버튼 | PRD_000200 | **굿즈(기념품/액세서리)** | 단품(형상 variant) | UV/디지털출력→커팅(형상)→조립→포장 | product-bom §11·wowpress 핀버튼 40185 | 🔴 형상=자재행 오적재(F-ID-3) |
| 반팔티셔츠 | PRD_000206 | **굿즈(패션·의류)** | 단품(색×사이즈) | **전사인쇄(외주)→포장** | product-bom §12·process-recipe §13 | 🔴 본체색×사이즈 폭증(F-ID-2)·인쇄방식 미적재 |
| 만년스탬프 | PRD_000217 | **굿즈(데스크·고무도장)** | 단품(잉크색) | 만년도장(고무도장)→포장 | product-bom §3·huni-goods §2.2 | 🔴 잉크색=자재행 오적재(F-ID-3) |
| 말랑키링 외 말랑류 | PRD_000221~ | **굿즈(말랑·PVC고주파)** | 단품(형상/면) | **이지굿즈(PVC고주파 융착)→에폭시(b.12)→포장** | product-bom §2·PROC_000083 | 🔴 에폭시 공정 미적재·고아오연결 |
| 레더 삼각/플랫/볼륨/슬림/원형 파우치 | PRD_000232~ | **패션잡화(레더파우치)** | 단품(형상 variant) | **패브릭인쇄→봉제미싱→(라벨부착)→포장** | product-bom §5·PROC_000080 D-24 | 🔴 봉제 공정 미적재·고아오연결 |
| 캔버스에코백 외 패브릭류 | PRD_000270 | **패션잡화(에코백)** | 단품(사이즈+방향) | **패브릭인쇄→봉제미싱→(라벨)→포장** | product-bom §6·huni-goods §2.5 | 🔴 봉제→부착 오적재(F-ID-5) |
| 슬림하드 폰케이스 외 | 폰케이스류 | **굿즈(폰케이스)** | 단품(폰기종 variant) | UV/디지털출력→(맥세이프 자석링 부착)→포장 | product-bom §1 | 🟡 폰기종=size vs option 미정(CONFIRM-GP-1) |

> **정체 자체는 round-11 BOM에서 이미 확정** — 굿즈파우치는 19 상품군이 인쇄방식·후가공·구간할인을 가르는 **C 완제품/단일(낱장 굿즈)**. 정체 출처는 후니 PDF(공정관리)+07_domain KB+product-master로 충분(비전형 상품 부재 — 거울/머그/티셔츠/파우치 전부 일상 굿즈, 사이트 재크롤 불요). **정체가 틀린 상품 0** — 라이브의 정합 결함은 정체 오분류가 아니라 **속성축 적재 결함**(F-ID-2~5)과 **카테고리 고아 오연결**(F-ID-1)이다.

---

## 2. 핵심 정체/적재 정합 발견

### F-ID-1 [카테고리 고아 오연결 — digital-print F-ID-3의 굿즈 확대] 🔴
- **무엇:** 굿즈 상품 35개가 **고아 카테고리 노드**(`upr_cat_cd=NULL` + `cat_lvl=3`)에 연결됨. 이 노드들은 정상 트리(굿즈 009/라이프 010/에코백 011 하위)에 매달리지 못한 잉여 그룹이다.
- **라이브 실측(read-only):**
  - 굿즈 상품 카테고리 연결 분포: `NORMAL(upr set)=56` · `ORPHAN(lvl>1,upr NULL)=35` · `ROOT(lvl1)=8`.
    재현: `SELECT CASE WHEN c.upr_cat_cd IS NULL AND c.cat_lvl>1 THEN 'ORPHAN' WHEN c.upr_cat_cd IS NULL AND c.cat_lvl=1 THEN 'ROOT' ELSE 'NORMAL' END, count(*) FROM t_prd_product_categories pc JOIN t_prd_products p ON pc.prd_cd=p.prd_cd JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd WHERE p.prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290' GROUP BY 1;`
  - 고아 노드 전수(`upr_cat_cd IS NULL AND cat_lvl>1`): `CAT_000293 상품악세사리`·`294 명함`·`295 상품권`·`296 배경지`·`297 레드프린팅 책자 가이드`·`298 실사`·`299 단품형`·`300 플래너`·`301 소품`·`302 데스크/사무용품`·`303 디지털악세서리`·`304 말랑(PVC고주파)`·`305 레더파우치`·`306 에코백부자재` (14개·전부 lvl3·upr NULL).
  - 굿즈 고아 노드별 연결 상품 수: `소품(301)=5`·`데스크(302)=9`·`말랑(304)=9`·`레더파우치(305)=9`·`디지털악세서리(303)=2`·`에코백부자재(306)=1`.
- **그런데 정상 노드도 실재:** 거울 5상품은 고아 `CAT_000301 소품`에 묶였으나 **개별 정상 노드 `CAT_000165 틴거울`·`166 컴팩트거울`·`167 카드거울`·`168 사각손거울`·`169 블랙사각손거울`(전부 upr=CAT_000010 라이프·lvl2)이 실재**. 레더 파우치도 고아 `CAT_000305 레더파우치`에 묶였으나 **`CAT_000213~221 레더 N 파우치`(upr=CAT_000011 에코백·lvl2)가 실재**.
  재현: `SELECT cat_cd,cat_nm,COALESCE(upr_cat_cd,'NULL'),cat_lvl FROM t_cat_categories WHERE cat_cd IN ('CAT_000165','CAT_000215','CAT_000301','CAT_000305');`
- **함의:** digital-print F-ID-3와 동일 패턴 — 상품이 정상 노드를 두고 잉여 고아 노드(시트 `구분` 라벨 파생 추정)에 묶였다. **교정 = 개별 정상 노드로 재연결(search-before-mint, 기존 행 재사용) + 잉여 고아 논리정리.** 단, 일부 고아(소품 301·데스크 302·말랑 304·레더파우치 305)는 상품군 라벨 자체 — 개별 정상 노드는 있으나 군(group) lvl2 노드가 없는 경우는 부모 UPDATE(upr=009/010/011)도 후보. correction-manifest 참조.

### F-ID-2 [본체색×사이즈 = 재질행 폭증 + 자재유형 오염] 🔴
- **무엇:** 반팔티셔츠 = "화이트 M/L/XL/XXL · 블랙 M/L/XL/XXL" **8개 재질행**으로 폭증 적재. 본체색(블랙/화이트)×사이즈등급(M/L/XL/XXL) 직교가 단일 자재행으로 합성됨.
  - 라이브: `SELECT m.mat_nm,m.mat_typ_cd,pm.usage_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd=(SELECT prd_cd FROM t_prd_products WHERE prd_nm='반팔티셔츠');` → 8행, 전부 `MAT_TYPE.09(파우치)`·`USAGE.07(공통)`.
- **도메인 권위 충돌:** column-dictionary C15·huni-goods §2.1은 "본체색=재질행 합성"이되 **색×규격 2축 분리**(OTC C-6 "화이트 M/L=한덩어리"·CONFIRM-GP-2). 라이브는 8행 직교 폭증 → 과분할(색 2 × 규격 4 = 8). 게다가 티셔츠인데 `mat_typ_cd=MAT_TYPE.09(파우치)` = 자재유형 오염(티셔츠=원단 .05여야).
- **폭증 규모:** `mats>=3` 굿즈 상품 = 반팔티셔츠(8)·아크릴쉐이커코롯토(7)·만년스탬프(7)·말랑키링(5)·머그컵(4) 등.

### F-ID-3 [비-소재 값(형상·잉크색·용량)이 재질행으로 오적재] 🔴
- **핀버튼:** size=0행, 대신 **"원형 58mm·사각 57mm"가 materials(`MAT_TYPE.09 파우치`)** 로 적재. 도메인 권위(wowpress 형상=규격 융합·핀버튼 1행=1 sizeno → `t_siz_sizes`)는 형상=size인데 라이브는 자재행.
- **만년스탬프:** "청보라·빨강·검정·파랑·초록·핑크·노랑" 7색이 materials(`MAT_TYPE.09 파우치`)로 적재. 도메인 권위(huni-goods §2.2)는 잉크색=도수(`t_clr_color_counts`/print_options)인데 자재행.
- **머그컵:** "투명(MAT_TYPE.01 종이)·반투명(.01 종이)·화이트(.08 실사소재)·11온스(.09 파우치)" — 본체색이 종이/실사소재로 제각각, 용량(11온스)이 자재행. 자재유형 무작위 오염.
- **공통 원인:** `MAT_TYPE.09(파우치)`가 비-소재 값(형상·잉크색·사이즈등급)의 만능 쓰레기통이 됨.

### F-ID-4 [size→option 재분류 미적용 — 굿즈 상품군 CPQ 옵션 레이어 미적재] 🔴
- **무엇:** round-10이 굿즈파우치 448셀을 `사이즈(필수)`→`상품(옵션)`으로 재분류(OM-2). 그 목표지 = `t_prd_product_option_groups/options/option_items`.
- **라이브 실측:** **굿즈 상품군(PRD_000183~290) `t_prd_product_option_groups`=0행**(정확). 전역에는 6행 존재하나 굿즈와 무관 — PRD_000001/002(테스트 잔재 "테스트"·"제본방식")·PRD_000066(스티커 도무송 형상)·PRD_000138(현수막 가공)뿐이다. 옵션형 사이즈(폰기종·M/L/XL·방향·구수·면)는 옵션이 아닌 **materials(F-ID-2/3)로 흡수되거나 누락**. round-7 횡단 발견(option_items 거의 전역 0·R7 FAIL)의 굿즈 실증.
  재현: `SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290';` → 0 · `SELECT prd_cd,opt_grp_nm FROM t_prd_product_option_groups ORDER BY prd_cd;` → 전역 6행(001/002 테스트·066·138).
- 치수형(22행)은 정상 size 적재(사각손거울 S/M/L = 75x130/95x166/120x218 실측, F-ID-2 정상 케이스). `t_prd_product_sizes`=28행.

### F-ID-5 [공정 전면 누락 + 봉제→부착 오적재] 🔴
- **라이브 실측:** 굿즈 전체 `t_prd_product_processes`=**6행뿐**, 전부 캔버스 파우치/필통/에코백의 `PROC_000081(부착)`. 도메인 권위(PROC_000080 봉제 D-24·process-recipe §9)는 패브릭=봉제인데 **부착으로 오적재**. 레더/타이벡/메쉬 파우치(봉제)·말랑(에폭시 PROC_000083)·폰케이스(맥세이프)는 **공정 0행**.
- `t_prd_product_print_options`=0·`t_prd_product_addons`=0(볼체인 PRD_000006·리필잉크 PRD_000015는 별 상품 실재하나 addon 링크 미적재)·`t_prd_product_sets`=0.

---

## 3. 정체 → 추출규칙 전제 요약

- 거울·머그·핀버튼·티셔츠·만년스탬프·말랑·폰케이스 = **굿즈 단품**. 5속성축 + 굿즈 고유 축(본체색 재질·형상 규격·잉크색 도수·후가공 봉제/에폭시/맥세이프·추가상품 addon).
- 레더/패브릭/타이벡/메쉬 파우치·에코백·필통 = **패션잡화 단품**(패브릭인쇄→봉제). 봉제(PROC_000080)가 완성 공정.
- 라이브 결함은 **정체 오분류 아님** — 정체는 round-11 BOM이 확정. 결함은 ① 카테고리 고아 오연결(F-ID-1) ② 본체색×사이즈 폭증·자재유형 오염(F-ID-2/3) ③ size→option 미적용(F-ID-4) ④ 공정 누락·봉제 오적재(F-ID-5)이다.
- **🔴 컨펌 Q-ID-GP-1(=CONFIRM-GP-1):** 폰기종(아이폰15프로맥스 등)·사이즈등급(M/L/XL)을 size로 둘지 CPQ option 차원으로 둘지. 본 교정은 (b) 옵션형은 `option_items`(ref_dim_cd), 치수형만 size로 권고하나 인간 결정 필요(기계적 size 삭제는 가격사슬 파손).
