# 스티커 — 적재 로직 재구성 (loadlogic-notes · round-13 C1)

> **작성** 2026-06-11 · round-13. `tools/load_master.py`(+`sql/`)에서 스티커 시트의 엑셀 칼럼이 어느 t_*로 어떤 변환을 거쳐 적재되도록 코딩됐는지 재구성하고, 발견된 적재 로직 결함을 file:line 근거로 기록한다.
>
> **[HARD 사용자 directive] v03 프레임:** `load_master.py`의 입력은 **상품마스터 원본 엑셀이 아니라 `data/raw/prdmaster_full_migration_v03_20260518.xlsx`**(load_master.py:39). v03은 상품마스터를 미분석 정규화한 중간 산물로 오류가 多하다(피고원). 따라서 **load_master는 "v03 전파기"** — 라이브 결함의 진원은 대부분 load_master 코드가 아니라 **상류 v03 정규화**다. load_master 코드 결함과 v03 정규화 결함을 구분해 표기한다. **정답 = 상품마스터 원본 L1(`06_extract/sticker-l1.csv`)**.

---

## 0. 적재 아키텍처 (single-pass, surrogate 발급)

`load_master.py --all`(run_all:492)은 한 트랜잭션으로 ① seed 재적재(GROUP.NN 코드) ② 마스터 6종(surrogate 발급) ③ 관계 11종(FK 치환)을 돈다. 멱등성 = 대상 테이블 TRUNCATE 후 재삽입(load_master.py:22).

> **결정적:** 스티커 시트 전용 분기 로직은 **없다.** load_master는 v03의 통합 시트(`05_자재정보`·`06_공정정보`·`10_상품정보`·`14_상품별자재`·`15_상품별공정` 등)를 전 상품 공통으로 처리한다. 스티커 상품(PRD_000052~067)의 라이브 값은 **v03가 그 시트에 무엇을 넣었는가**의 직접 결과다. 따라서 적재 결함의 분류는 "load_master 코드 버그" vs "v03 정규화 오류"로 갈린다.

---

## 1. 스티커 컬럼 → t_* 적재 경로 재구성

| 엑셀 컬럼(L1) | v03 시트 | load_master 함수:line | 변환 규칙 | 라이브 결과 | 결함 원인 |
|--------------|----------|----------------------|-----------|-------------|-----------|
| 상품명(C4) | 10_상품정보 | load_products:250-275 | prd_cd=identity(이미 PRD_NNNNNN) · prd_nm 그대로 | PRD_000052~067 정확 | — (정합) |
| MES ITEM_CD(C3) | 10_상품정보 | load_products:261 | **무조건 None 적재**(하드코딩) | 전량 NULL | **load_master 코드 결정**(주석:261 "MES코드 중복으로 UNIQUE 위반 회피, 향후 재적재"). L1엔 002-0001~0016 실값 → MISSING |
| 상품유형(C—) | 10_상품정보 | load_products:263 | enum PRD_TYPE | 전 상품 PRD_TYPE.04(디자인) | v03 값 전파 |
| 최소/최대/증가(C26~28) | 10_상품정보 | load_products:268 | _int 그대로 | 052=8/10000/8 등 | v03 전파(정합) |
| qty_unit(C—) | 10_상품정보 | load_products:269 | **None 하드코딩**(시트10에 원천 컬럼 없음) | QTY_UNIT.02 매 | **적재 경로 불명** — line 269가 None인데 라이브는 .02 → 후속 보정 산물(webadmin 밖) |
| 종이(C16) | 05_자재정보 + 14_상품별자재 | load_materials:227·load_rel_materials:318 | mat_typ=enum(자재구분)·usage=용도 or '공통' | 코팅=자재·자재유형 .01/.11 혼재 | **v03 정규화 결함** — 자재구분이 v03에서 .01/.11로 갈려 들어옴(아래 §2.2) |
| 코팅(C23) | (14_상품별자재에 흡수) | load_rel_materials | 무광/유광코팅스티커가 자재행으로 | 052 등 8상품에 MAT_000155/156 | **v03 정규화 결함** — 코팅을 자재로 인코딩(Q9는 공정). load_master는 충실 전파 |
| 인쇄(C17) | 16_상품별인쇄옵션 | load_rel_print_options:352-382 | print_side·front/back 도수 | 052=단면/CLR_000005(4도)/CLR_000001(0도) | v03 전파(정합) |
| 별색 화이트(C18) | 15_상품별공정 | load_rel_processes:404-421 | PROC_000008 연결 | 053/054/056만(063 누락) | **v03 정규화 결함** — v03 15시트에 063 화이트 행 부재 → MISSING(F-ST-3) |
| 커팅(C24) | 15_상품별공정 | load_rel_processes:404-421 | PROC_53/54/55 연결·mand_proc_yn | 반칼/완칼/스티커완칼 1줄·전부 mand=N | v03 전파. **형상은 공정에 안 들어감**(prcs_dtl_opt 컬럼 부재) |
| 조각수(C25) | 12_상품별묶음수 | load_rel_bundle_qtys:294-304 | bdl_qty=묶음수·unit=QTY_UNIT | 066만 5행, 나머지 0 | **v03 정규화 결함** — v03 12시트에 조각수 행이 066(형상별 EA)만, 나머지 미전개 → MISSING(F-ST-4) |
| 사이즈/형상(C5) | 04_사이즈정보 + 13_상품별사이즈 | load_sizes:194·load_rel_sizes:307 | siz_nm 그대로 | 066=`정사각30x30mm(2EA)`·058=A4/A5 | v03 전파. **066만 형상을 siz_nm에 인코딩**(Q7 정합)·규격형은 규격만(F-ST-5) |
| 출력용지규격(C10) | 17_상품별판형사이즈 | load_rel_plate_sizes:336-349 | **output_paper=전부 .기타 or NULL**(치수→.기타) | 052: 105x148=.03·나머지 NULL | **load_master 코드 결정**(line 340-346 "용지 치수→OUTPUT_PAPER_TYPE.기타"). 라이브 .03은 후속 plate교정 산물(webadmin 밖) |
| 출력파일(C12) | 17_상품별판형사이즈 | load_rel_plate_sizes:347 | output_file_typ 자유텍스트 | 052: `AI_CS5 (칼선)`·`*아이마크`·`PDF` | v03 전파. `*아이마크`=생산 메타가 파일유형칸 침입(v03 결함) |
| 카테고리(C1=빈값) | 11_상품별카테고리 | load_rel_categories:282-291 | cat_cd 치환 | 전 16상품 CAT_000002(lvl1 root) | **v03 정규화 결함** — v03 11시트가 16상품을 root 노드에만 매핑(개별 노드 030~047 미사용)→F-ST-1 |
| 파일명약어(C11)·폴더(C13) | (v03 미반영) | — | t_* 컬럼 부재 | 미적재 | **적재 경로 부재**(견적 제외, Q1). 정합 — finding 아님 |

---

## 2. 발견된 적재 로직 결함 (file:line)

### L-ST-A [MES_ITEM_CD 전량 NULL — load_master 코드 결정] (load_master.py:261)
```python
None,  # MES_ITEM_CD: 전량 NULL (사용자 결정 2026-06-03) — 원천 MES코드 7건이 상품 14개에 중복돼 부분 UNIQUE 위반
```
- **무엇:** 스티커 전 16상품 MES NULL. L1엔 002-0001(반칼자유형)~002-0016(스티커팩) 실값. 타투(002-0014)·스티커팩(002-0016) 등 명시.
- **원인:** load_master **코드 의도적 결정**(v03 결함 아님). MES 중복 정리 후 재적재 보류. **현재로선 finding(적재 경로 불명 아님 — 의도된 NULL)**. 정답값(L1 MES)은 보존돼 있으나 라이브 미반영.
- **분류:** MISSING(의도된 보류). 교정=중복정리 후 재적재(인간 정책 결정).

### L-ST-B [코팅=자재 — v03 정규화 결함이 load_master로 전파] (load_master.py:227·318)
- **무엇:** v03 `05_자재정보`에 무광코팅스티커·유광코팅스티커가 **자재**로 정의됨. load_master:227(load_materials)·318(load_rel_materials)이 이를 충실히 자재로 적재. Q9★=코팅 공정.
- **원인:** **v03 정규화 결함**(코팅을 자재로 인코딩). load_master는 전파기 — 코드 버그 아님. 진원=상류 v03이 코팅 공정을 자재 variant로 평면화.
- **단, 반론 존재:** round-11 product-bom §44는 "스티커 코팅=점착지 완제 표면사양=자재 variant가 정당"(라미네이팅 별도 공정 아님). 가격표가 비코팅/무광/유광 3컬럼(live-crosscheck §5). → CONFLICT 미해소(CONFIRM-ST-A).

### L-ST-C [조각수 미전개 — v03 12시트 결함] (load_rel_bundle_qtys:294)
- **무엇:** load_rel_bundle_qtys는 v03 `12_상품별묶음수`를 충실히 적재. 라이브 결과=066만 5행 → **v03 12시트에 조각수 행이 066(형상별 EA)만 있고 나머지 15상품 조각수 행 부재**.
- **원인:** **v03 정규화 결함** — 상품마스터 L1 C25 조각수(*최대20조각 등)를 v03가 묶음수 시트로 전개하지 않음. load_master 코드는 정상.
- **추가:** prcs_dtl_opt.조각수의 상품 레벨 저장처 자체가 스키마에 없음(sql/01b:123 t_prd_product_processes에 prcs_dtl_opt 컬럼 부재) = OM-7/GAP-PARAM. 조각수를 공정 param으로 두려면 ddl 필요.

### L-ST-D [063 화이트 별색 미적재 — v03 15시트 결함] (load_rel_processes:404)
- **무엇:** load_rel_processes는 v03 `15_상품별공정`을 충실히 적재. 053/054/056엔 PROC_000008 화이트 행 존재, **063엔 부재** → v03 15시트에 063 화이트 행 누락.
- **원인:** **v03 정규화 결함**. L1 063 `별색인쇄(옵션)_화이트`=`화이트인쇄(단면)` 실재. 정답 미전파.

### L-ST-E [카테고리 root만 — v03 11시트 결함] (load_rel_categories:282)
- **무엇:** load_rel_categories는 v03 `11_상품별카테고리`를 충실히 적재. 라이브=16상품 전부 CAT_000002(lvl1 root). 정상 노드 030~047 실재하나 미사용.
- **원인:** **v03 정규화 결함** — v03 11시트가 상품을 거친 root 노드에 매핑. load_master:285-289 코드는 정상(주카테고리여부·표시순서까지 전파). 단 load_categories:164-178이 만든 카테고리 마스터엔 개별 노드(030~047)가 존재 → 11시트가 그 노드를 안 쓴 것.

### L-ST-F [자재유형 .01/.11 혼재 — v03 05시트 결함] (load_materials:236-239, 스티커는 line 239 else 경로)
```python
# load_master.py:236-239
[(m[_norm(r["자재코드"])], _norm(r["자재명"]),
  (enum_code("MAT_TYPE", MAT_TYP_OVERRIDE[_norm(r["자재코드"])])      # 237: OVERRIDE 분기 — 레더하드커버 등 4건 전용(load_master.py:116-121)
   if _norm(r["자재코드"]) in MAT_TYP_OVERRIDE                        # 238
   else enum_code("MAT_TYPE", r["자재구분"], ref=...)),              # 239: 스티커 자재 경로 — v03 자재구분 라벨 → MAT_TYPE.NN
```
- **무엇:** 스티커 점착지가 라이브에서 MAT_TYPE.01(종이: 비코팅·미색·투명전용·타투전용)과 .11(스티커: 유포·코팅·투명·홀로그램·데드롱)로 갈림. 같은 스티커 점착물인데 자재유형 불일치.
- **인용 정밀화(게이트 G-ST-V1):** 자재유형 결정은 line 237-239 분기다. line 237-238의 `MAT_TYP_OVERRIDE`는 **레더하드커버/하드커버전용지 4건 전용**(load_master.py:116-121)이고 **스티커 자재는 전부 OVERRIDE 비대상** → 전부 line 239의 `else enum_code("MAT_TYPE", r["자재구분"])` 경로를 탄다. 즉 스티커 자재유형 = v03 `자재구분` 라벨을 그대로 enum 변환한 결과.
- **원인:** **v03 정규화 결함** — v03 `05_자재정보`의 `자재구분` 컬럼이 일부 점착지를 "종이"로, 일부를 "스티커"로 라벨링. load_materials:239 enum_code가 그 라벨을 충실히 변환(코드 정상). 진원=v03 자재구분 분류 불일치. "v03 정규화 결함" 분류는 정합 — 인용 정밀도만 보강.

### L-ST-G [066 빈 옵션그룹 — webadmin 밖 잔재] (적재 경로 불명)
- **무엇:** PRD_000066에 `OPT-000004 원형` 옵션그룹(reg_dt 2026-06-10)이 option_items 0행으로 존재. load_master는 옵션그룹을 적재하지 않음(option layer는 migrate_phase7/admin 트랙).
- **원인:** **적재 경로 불명** — load_master 소관 밖. round-9 admin 또는 round-6 CPQ 파일럿 잔재로 추정. EXTRA(논리삭제 후보).

### L-ST-H [055/057 자재명 절단 — v03 정규화 결함] (load_materials:236)
- **무엇:** L1 낱장/대형 자유형 자재 = "유포지+엠보코팅". 라이브 055/057 자재 = "유포지"(MAT_000154). "+엠보코팅" 소실.
- **원인:** **v03 정규화 결함** — v03 05시트 자재명이 이미 절단된 채 들어옴. load_materials:236(`_norm(r["자재명"])`)은 그대로 전파. 실사 점착소재 표면사양(엠보코팅) 정보 소실.

---

## 3. 적재 로직 결함 분포 요약

| 결함 | 원인 분류 | 영향 t_* | 라이브 증상 |
|------|-----------|----------|-------------|
| L-ST-A MES NULL | load_master 코드 결정(의도) | t_prd_products.MES_ITEM_CD | 16상품 NULL |
| L-ST-B 코팅=자재 | v03 정규화(CONFLICT) | t_prd_product_materials | 8상품 코팅 자재행 |
| L-ST-C 조각수 미전개 | v03 12시트 + 스키마 GAP | bundle_qtys + (OM-7) | 066만 5행 |
| L-ST-D 063 화이트 누락 | v03 15시트 | t_prd_product_processes | 063 별색 0 |
| L-ST-E 카테고리 root | v03 11시트 | t_prd_product_categories | root만 |
| L-ST-F 자재유형 혼재 | v03 05시트 | t_mat_materials.mat_typ_cd | .01/.11 혼재 |
| L-ST-G 빈 옵션그룹 | webadmin 밖(경로불명) | option_groups | 066 빈 껍데기 |
| L-ST-H 자재명 절단 | v03 05시트 | t_mat_materials.mat_nm | 유포지(엠보 소실) |

> **핵심 통찰:** 스티커 결함 8건 중 **5건(L-ST-B/C/D/E/F/H)이 v03 정규화 결함**(load_master는 충실 전파). load_master 코드 자체 결함은 L-ST-A(MES NULL 의도)뿐. 1건(L-ST-G)은 webadmin 밖. **사용자 directive대로 진원은 상류 v03이며, 교정의 정답 기준은 상품마스터 L1.** load_master를 고칠 게 아니라 v03 정규화(또는 직접 라이브 교정)를 바로잡아야 한다.
