# 문구(stationery) — 적재 로직 재구성 + 결함 (loadlogic-notes · round-13 C1)

> **작성** 2026-06-11 · round-13. `tools/load_master.py`(+`sql/`)가 문구 칼럼을 t_*로 변환한 규칙을 재구성하고, 그 규칙이 만든 라이브 현재 상태의 **결함을 file:line으로** 기록한다.
> **[HARD] oracle 용도:** `sql/`=스키마 구조 권위. `load_master.py`=적재로직 **진단** 재구성용(정답 아님). v03 데이터값·전파 결과=정답 참조 금지(피고). `models.py`=거울(미사용).
> **핵심:** load_master.py가 읽는 소스는 **v03 마이그레이션 엑셀**(`load_master.py:39` `data/raw/prdmaster_full_migration_v03_20260518.xlsx`) — 사용자 [HARD] directive가 "오류 많음·정답 참조 금지"로 지정한 피고 소스. 결함 다수가 v03 셀 자체 결함의 전파다.

---

## 0. 적재 파이프라인 골격 (load_master.py:461~481)

`--all` 단일 트랜잭션: seed(기초코드 GROUP.NN) → MASTERS(surrogate 발급) → RELATIONS(FK 치환). 모든 대상 TRUNCATE 후 재삽입(멱등). 문구 상품은 **마이그레이션 시트 10/11/13/14/15/16/17/18/21**에서 적재된다.

| 단계 | 함수(load_master.py) | 읽는 v03 시트 | 문구 t_* 산출 |
|------|----------------------|---------------|---------------|
| 카테고리 | `load_categories` :164 | 01_카테고리 | t_cat_categories |
| 자재 | `load_materials` :227 | 05_자재정보 | t_mat_materials |
| 공정 | `load_processes` :210 | 06_공정정보 | t_proc_processes |
| 상품 | `load_products` :250 | 10_상품정보 | t_prd_products |
| 상품별카테고리 | `load_rel_categories` :282 | 11_상품별카테고리 | t_prd_product_categories |
| 상품별사이즈 | `load_rel_sizes` :307 | 13_상품별사이즈 | t_prd_product_sizes |
| 상품별자재 | `load_rel_materials` :318 | 14_상품별자재 | t_prd_product_materials |
| 상품별판형 | `load_rel_plate_sizes` :336 | 17_상품별판형사이즈 | t_prd_product_plate_sizes |
| 상품별인쇄옵션 | `load_rel_print_options` :352 | 16_상품별인쇄옵션 | t_prd_product_print_options |
| 상품별공정 | `load_rel_processes` :404 | 15_상품별공정 | t_prd_product_processes |
| 상품별묶음수 | `load_rel_bundle_qtys` :294 | 12_상품별묶음수 | t_prd_product_bundle_qtys |
| 상품별페이지룰 | `load_rel_page_rules` :447 | 21_상품별페이지룰 | t_prd_product_page_rules |
| 셋트 | `load_rel_sets` :424 | 19_상품셋트정보 | t_prd_product_sets |

> **가격(C29)·구간할인(C36)은 load_master 미관여**(round-2/round-1 별 트랙). 따라서 라이브 문구 가격 0행은 load_master 결함이 아니라 round-2 미실행.

---

## 1. 재구성된 적재 규칙 (문구 관련)

### R-CAT 카테고리 (load_categories:164~178)
- `issue(rows, "카테고리코드", "CAT", "CAT")` — v03의 슬러그 카테고리코드를 엑셀 행순 CAT_NNNNNN surrogate로 발급.
- upr_cat_cd는 v03 `상위카테고리코드`로 2-pass UPDATE(:175~177). **v03에 상위코드가 비면 upr=NULL 고아 노드가 그대로 생성**.
- load_rel_categories(:288)가 상품을 v03 `11_상품별카테고리`의 카테고리코드로 연결 — **v03이 상품을 고아 노드에 연결해 두면 그대로 전파**.

### R-MAT 자재 (load_materials:227~247)
- 자재유형 = `enum_code("MAT_TYPE", r["자재구분"])`(:239). v03 `자재구분` 라벨→MAT_TYPE.NN.
- **MAT_TYP_OVERRIDE(:116~121)**: 4개 슬러그만 하드코드 override(하드커버전용지→종이·레더하드커버 A/A4/A5→가죽). 그 외 레더는 v03 `자재구분` 그대로.
- 코팅 분해 로직 **전무** — `아트250 + 무광코팅`이 한 자재명이면 한 행으로 그대로 적재(공정 분해 안 함).

### R-PMAT 상품별자재 usage (load_rel_materials:318~333) ★핵심 결함원
- **`usage = enum_code("USAGE", r["용도"] or "공통", ...)`(:324)** — v03 `용도` 셀이 비면 **USAGE.공통(=USAGE.07)으로 fallback**.
- 즉 라이브에서 종이가 USAGE.07로 적재된 것 = **v03 14_상품별자재의 용도 셀이 비어 있어 공통 fallback** 된 결과(도메인 정답=내지 USAGE.01).

### R-PROC 상품별공정 (load_rel_processes:404~421)
- v03 `15_상품별공정`의 공정코드 슬러그→PROC surrogate. mand_proc_yn=v03 `필수공정여부`.
- **excl_grp_cd**(:412) — 라이브 스키마에서 컬럼 삭제됨(Phase11, round-14 진단 정합). 현재 라이브 t_prd_product_processes에 excl_grp_cd 컬럼 부재. 택일그룹 미적재.
- 공정 행 자체가 v03 15시트에 없으면 라이브에 없음(미싱제본·내지출력 등 v03 누락 시 전파).

### R-PAGE 페이지룰 (load_rel_page_rules:447~456)
- v03 `21_상품별페이지룰`의 page_min/max/incr 그대로. **잡음 검증 없음** — v03이 떡메모지에 3/3/3을 넣어 두면 그대로 적재(떡제본 page 무의미 원칙 무시).

### R-PRICE 가격 — load_master 미관여
- 시트 10~21에 가격 컬럼 없음(load_products:250~275에 price 미적재). 문구 가격(C29)은 round-2 트랙 책임. 라이브 0행=round-2 미실행.

---

## 2. 발견된 적재 결함 (file:line 근거)

| ID | 결함 | 원인(load_master file:line + v03) | 영향 상품 | 분류 연계 |
|----|------|-----------------------------------|-----------|-----------|
| **L-ST-A** | **종이 usage=USAGE.07 공통 fallback** | `load_rel_materials:324` `r["용도"] or "공통"` — v03 14시트 종이 용도 셀 공란 → 내지(.01)/표지(.02) 대신 공통(.07) | 먼슬리(176)·스프링노트(177)·수첩(178)·메모패드(179)·중철노트(181) 백모조100·떡메모지(097) 백모조120 중복 | ST-02 |
| **L-ST-B** | **코팅 분해 부재 → 자재명 평면화** | load_materials에 복합표기 분해 로직 없음(:236 자재명 그대로). v03 05시트 `아트250 + 무광코팅`을 한 자재행으로 정의 | MAT_000260/MAT_000250(중복 2개)·172~179/181 표지 | ST-03 |
| **L-ST-C** | **카테고리 고아 노드 연결** | `load_categories:175`(v03 상위코드 공란→upr=NULL 고아)+`load_rel_categories:288`(상품을 고아노드에 연결) — v03이 플래너 상품을 CAT_000300(upr=NULL)에 연결 | 만년다이어리 4종(172~175)·먼슬리(176)→고아 플래너 300 | ST-01 |
| **L-ST-D** | **레더 자재유형 3-way 혼재** | MAT_TYP_OVERRIDE(:116~121)는 "레더하드커버 A/A4/A5"만 가죽 지정. v03 `자재구분`이 레더(화이트)를 실사소재(.08)로 정의·load_master 그대로 적재(:239) | 만년다이어리 레더하드(174)·레더소프트(175)=MAT_000186 .08 | ST-04 |
| **L-ST-E** | **제본 mand_proc_yn 혼재** | `load_rel_processes:415` v03 `필수공정여부` 그대로 — v03이 떡메모지(097) 떡제본=N·메모패드(179) 떡제본=Y로 비일관 정의 | 떡메모지(097) N vs 메모패드(179) Y(같은 떡제본) | ST-05 |
| **L-ST-F** | **미싱제본 공정 누락** | 제본 PROC_000017 자식 9종에 미싱제본 부재(seed). v03 15시트가 소프트/레더소프트/먼슬리 제본행 없음(빈 제본 컬럼) → 라이브 제본 공정 0행 | 만년다이어리 소프트(172)·레더소프트(175)·먼슬리(176) | ST-06 |
| **L-ST-G** | **page_rule 3/3/3 잡음** | `load_rel_page_rules:453` 잡음 검증 없이 v03 21시트 떡메모지 page 3/3/3 그대로 적재. 떡제본 page 무의미(intent-map L358) | 떡메모지(097) page_rule 3/3/3 | ST-07 |
| **L-ST-H** | **면지/실버링/PVC/합지보드 자재 미연결** | v03 14시트에 면지(하드커버)·실버링(트윈링)·PVC(소프트)·합지보드 자재 행 없음 → load_rel_materials 적재 안 함(L1 C27/C37 힌트 미반영) | 만년다이어리 하드/레더하드 면지·스프링 실버링·소프트 PVC | ST-08~11 |
| **L-ST-I** | **B 셋트 sub_prd/sets 미적재** | v03 19시트(셋트)에 만년다이어리 하드/레더하드 표지 sub_prd 행 없음 → load_rel_sets:424 적재 안 함(booklet은 하드커버 sub_prd 보유=비대칭) | 만년다이어리 하드(173)·레더하드(174) | ST-12 |
| **L-ST-J** | **가격 전무** | load_master 미관여(:469~481 RELATIONS에 가격 없음). round-2 트랙 문구 미실행 | 전 상품 t_prd_product_prices 0행 | ST-13 |
| **L-ST-K** | **레더소프트(175) 공정 완전 0행** | v03 15시트가 175 공정행 전무(제본/코팅/포장 모두 누락). 레더 특수인쇄+미싱 모두 미정의 | 만년다이어리 레더소프트(175) | ST-06·ST-14 |

---

## 3. 적재 경로 불명 (finding 자체)

- **plate_sizes output_paper_typ_cd 전부 NULL**: load_rel_plate_sizes:340~347이 출력용지유형코드를 "전부 OUTPUT_PAPER_TYPE.기타 또는 NULL"로 적재. 문구 내지/표지 폴더(C12/C24 디지털인쇄/특수인쇄)=인쇄방식 라우팅이 출력용지규격으로 적재 안 됨(booklet GAP-PAPER 동형). **폴더→출력용지규격 vs 견적밖 라우팅 메타** 미결(Q-ST-C).
- **MES_ITEM_CD 전량 NULL 적재**(load_products:261 무조건 None) — 그러나 라이브 문구 상품은 MES 컬럼 측정 시 일부 채워질 수 있음(product-accessory PA-14 패턴 = 후속 손작업). 문구 MES는 본 감사 측정 범위에서 prd 식별만 사용(MES 값 자체 정답 판정은 round-2 밖).

---

## 4. 적재로직 정합(결함 아님) — 라이브가 정답과 일치하는 부분

- **상품 12행·prd_cd 채번**: load_products:252 identity(PRD surrogate 보존). 만년다이어리 4 별상품 적재=L1 별 MES 정합(ST2-2 별상품 모델).
- **min/max/qty_incr**: load_products:268 v03 그대로 — L1과 정합(다이어리 1/500/1·수첩/중철 4/500/4·떡메모 3/1000/3).
- **무지내지 usage=USAGE.01**: 스프링/메모/중철 무지내지(MAT_000261)는 USAGE.01 정상(v03 14시트 용도 채워짐 — 종이만 공란이었음). L-ST-A는 종이(백모조)에 국한.
- **트윈링/중철/떡/하드커버무선 제본 enum→PROC 변환**: 정합(좌철/상철은 prcs_dtl_opt param, PROC_000017 9자식 정상).
- **page_rule 먼슬리 28/28/0·bundle 떡메모 50/100권**: 정합(먼슬리 고정 28P·떡메모 권 단위).
- **print_side 단/양면**: 정합(먼슬리 양면+단면 2행·나머지 단면).
- **떡메모지 sub_prd(098)·sets(097→098)**: 정합(내지 반제품·자재 권위=parent).
