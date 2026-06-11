# 스티커 — 교정 매니페스트 (correction-manifest · round-13 C4)

> **작성** 2026-06-11 · round-13. 각 diff를 CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS로 분류 + why(oracle 근거+적재로직 원인) + how(비파괴 교정) + 심각도 + 라우팅.
> **[HARD] 비파괴:** 교정은 제안까지. COMMIT/DDL/DELETE 없음. EXTRA/REMOVED=논리삭제 제안. search-before-mint(기존 행 재사용 우선 — 카테고리 030~047·PROC_000013/054·MAT_000084 전부 실재 확인).
> **라우팅:** 교정직접(단순 연결행) / ddl-proposer(스키마 부족) / load-execution(적재 실행) / 컨펌(인간 결정).

---

## 1. 분류표 (빈칸 0)

| ID | 상품 | 속성 | 분류 | 라이브 현재값 | 정답값 | why (oracle 근거 + 적재로직 원인) | how (비파괴 교정) | 심각도 | 라우팅 |
|----|------|------|------|---------------|--------|-----------------------------------|-------------------|:--:|------|
| **C-ST-01** | 052·064·066 등 | size | CORRECT | 규격/자유 치수행 | 엑셀 L1 사이즈 | L1 사이즈=라이브 정합(052=3행·064=7행). load_rel_sizes:307 충실 전파 | 유지 | — | 없음 |
| **C-ST-02** | 16상품 | 카테고리 위상 | MIS-LOADED | 전 16상품 CAT_000002(lvl1 root) | 개별 정상 노드: 052→CAT_000030·053→031·054→032·055→034·056→035·057→036·058→038·059→039·060→040·061→041·062→042·063→043·064→033·065→047·066→044·067→046 | 정상 노드 030~047 **전부 실재**(라이브 확인·F-GATE). v03 11시트가 거친 root에만 매핑(L-ST-E) | 상품을 기존 정상 노드로 재연결(`t_prd_product_categories` UPDATE cat_cd, search-before-mint). root 연결도 무효 아니므로 Low | Low | load-execution |
| **C-ST-03** | 066 합판도무송 | size(형상=칼틀) | CORRECT | 37행 siz_nm에 형상+치수(±EA): 정사각/직사각류=`정사각30x30mm(2EA)`(EA 포함)·원형류=`원형10x10`(EA 미포함)[각주①] | 형상=칼틀 1:1·size 유지 | **Q7★ + 가격표 형상×사이즈 격자(live-crosscheck §5)**. round-11 "형상 size 흡수=오모델 의심"은 반증 — Q7이 size 정답으로 종결 | 유지. round-11 G-SK-2 가설 철회 확정 | — | 없음 |
| **C-ST-04** | 052·058·059·060·061·062·064·066 (8) | 코팅 | MIS-LOADED | 무광코팅스티커(MAT_000155)·유광코팅스티커(MAT_000156) 자재 | Q9★=코팅 공정(PROC_000013) + 비코팅 자재(MAT_000084) | **실무진 Q9★=코팅 공정**(round-12 CONFLICT-1). v03 05시트가 코팅을 자재로 인코딩(L-ST-B). PROC_000013 코팅 마스터 실재 | 코팅 공정 PROC_000013을 8상품 `t_prd_product_processes` 연결 + 무광/유광코팅스티커 자재행 정리(비코팅+코팅 분해). **단 가격모델/round-11 자재 variant와 CONFLICT** → CONFIRM-ST-A | High | 컨펌(Q-ST-A)+load-execution |
| **C-ST-05** | 052·055·057·058~064 (~12) | 인쇄옵션(조각수) | MISSING | bundle_qtys 0행(066만 5행) | L1 C25 조각수: 052=*최대20/40·055=5~10·064=*1조각 → bundle_qty + prcs_dtl_opt.조각수(Q8 둘 다) | v03 12시트가 조각수를 066(형상EA)만 전개(L-ST-C). prcs_dtl_opt.조각수의 상품 레벨 저장처 부재(OM-7) | bundle_qty(상한값) `t_prd_product_bundle_qtys` 연결 + 공정 param용 `ref_param_json` 신설(OM-7) | Med | ddl-proposer(param)+컨펌(Q-ST-B)+load-execution |
| **C-ST-06** | 058·059·060·061·062 (5) | 공정(형상) | MISSING | PROC_000055 스티커완칼(모양 param 없음)·형상 size에도 부재 | 형상(원형/정사각/직사각/띠지/팬시)=PROC_000054 반칼(모양 param 보유) + prcs_dtl_opt.모양 | 형상이 size·prcs_dtl_opt·product 어디에도 없음(OM-7/GAP-PARAM 실증·F-ST-5). v03가 PROC_000055(param 없는 공정) 선택 | (a) 058~062를 PROC_000055→PROC_000054 공정 교체 + ref_param_json(모양) (b) 합판도무송식 siz_nm 인코딩 통일 — CONFIRM-ST-C | Med | ddl-proposer(param)+컨펌(Q-ST-C) |
| **C-ST-07** | 063 반칼팬시투명 | 공정(별색) | MISSING | 화이트(PROC_000008) 미연결 | PROC_000008 화이트(투명스티커 underbase) | **G-SK-1 도메인 필수**(투명 베이스 화이트). L1 063 `화이트인쇄(단면)` 실재. v03 15시트 063 화이트 행 누락(L-ST-D). 053/054/056은 연결됨 | PROC_000008을 063 `t_prd_product_processes` 연결(search-before-mint·마스터 실재) | Med | load-execution |
| **C-ST-08** | 16상품 | MES_ITEM_CD | MISSING | 전량 NULL | L1 002-0001~0016(원형 보존·D-05) | load_master.py:261 의도적 NULL(MES 중복 UNIQUE 회피). L1 실값 보유 | MES 중복 정리 후 재적재(인간 정책). 현재 NULL은 의도된 보류 | Low | 컨펌(Q-ST-MES) |
| **C-ST-09** | 비코팅·미색·투명전용·타투전용 (4자재) | 자재유형 | MIS-LOADED | MAT_TYPE.01(종이) | MAT_TYPE.11(스티커) | 스티커 점착지인데 v03 05시트 자재구분이 일부를 "종이"로 라벨(L-ST-F). enum_code:237 충실 변환. 같은 점착물 .01/.11 혼재 | 4자재 mat_typ_cd를 MAT_TYPE.11로 UPDATE(`t_mat_materials`). 단 타투전용지(전사)는 종이 정당할 수도 → 표본 컨펌 | Low | 컨펌+load-execution |
| **C-ST-10** | 055·057 | 자재(명) | MIS-LOADED | "유포지"(MAT_000154) | "유포지+엠보코팅"(실사 점착소재) | v03 05시트 자재명 절단(L-ST-H). 표면사양(엠보코팅) 정보 소실 | 자재명 "유포지+엠보코팅" 복원 또는 별 mat_cd. 단 mat_nm 변경=멱등키 영향 → 컨펌 | Low | 컨펌 |
| **C-ST-11** | 052~066 커팅상품 | 공정(필수성) | MIS-LOADED | 커팅 mand_proc_yn=N(전부) | 커팅=스티커 정체(반칼/완칼 상품명) → mand=Y. 화이트 underbase=Y | 커팅이 스티커 필수 공정인데 N 적재(v03 필수성 미표기). 라이브 mand=N | mand_proc_yn=Y로 UPDATE(커팅·화이트 별색). 단 옵션 인쇄/별색은 N 정당 — 공정별 판정 | Low | 컨펌+load-execution |
| **C-ST-12** | 066 | 옵션그룹 | EXTRA | OPT-000004 "원형"(option_items 0행) | (없어야 — 형상=size로 표현) | round-9 admin/round-6 CPQ 파일럿 잔재(reg_dt 2026-06-10·webadmin 밖·L-ST-G). 빈 껍데기·066 형상은 이미 size(Q7) | 논리삭제 제안(`use_yn='N'`/`del_yn='Y'` — hard-delete 금지) | Low | load-execution |
| **C-ST-13** | 065 스티커팩 | 구성(세트) | MISSING | sets=0 | 여러 스티커 시트째 묶음 세트 구성 | product-bom §14=팩=세트. 세트 구성품(하위 스티커) 미적재. v03 19시트 부재 | 세트 구성 모델 결정 후 `t_prd_product_sets` 연결 — 팩 구성이 무엇인지 불명 | Med | 컨펌(Q-ST-E) |
| **C-ST-14** | 053·054·056 | 공정(별색) | CORRECT | PROC_000008 화이트 연결 | 화이트 underbase | L1 정합. v03 15시트 충실 전파(053/054/056). 063만 누락(C-ST-07) | 유지 | — | 없음 |
| **C-ST-15** | 052 등 | 도수 | CORRECT | 단면·front=CLR_000005(4도)·back=CLR_000001(0도) | 단면·앞 4도·뒤 0도 | L1 C17=단면. load_rel_print_options:374 충실. round-12 "front=무도수" 표기는 부정확(4도가 정답) | 유지 | — | 없음 |
| **C-ST-16** | 052 등 | plate output_paper | AMBIGUOUS | 148x210=NULL·210x297=NULL·105x148=.03 혼재·output_file에 `*아이마크` 메타 침입 | 출력용지유형 일관 코드 + output_file=파일포맷만 | load_rel_plate_sizes:340-346 무조건 .기타/NULL. 라이브 .03은 후속 plate교정 산물(경로불명). `*아이마크`=v03 생산메타 침입 | plate 출력용지유형 일관화 + output_file 메타 텍스트 정리 — 가격엔진(round-2/판형) 트랙 | Low | 컨펌 |
| **C-ST-17** | 067 타투·065 팩 | 공정 | CORRECT | 공정 0행 | 전사=커팅 없음·팩=시트째(커팅 없음) | product-bom §14/§16. L1 C24 빈값. v03 정합 | 유지 | — | 없음 |

---

## 2. 분류 분포

| 분류 | 건수 | 항목 |
|------|:--:|------|
| CORRECT | 5 | C-ST-01(size)·03(합판형상=size)·14(화이트 053/4/6)·15(도수)·17(타투/팩 공정) |
| MIS-LOADED | 5 | C-ST-02(카테고리)·04(코팅=자재)·09(자재유형)·10(자재명절단)·11(커팅 mand) |
| MISSING | 5 | C-ST-05(조각수)·06(규격형 형상)·07(063 화이트)·08(MES)·13(스티커팩 세트) |
| EXTRA | 1 | C-ST-12(066 빈 옵션그룹) |
| AMBIGUOUS | 1 | C-ST-16(plate output_paper/file) |

> 합계 17건. **EXTRA 1**(빈 옵션그룹 — 논리삭제 제안, hard-delete 금지). MISSING이 5건으로 주 결함(조각수·형상·MES·세트 미적재). round-11/12 기지 이슈 중 **합판형상=size(C-ST-03)는 의심 반증되어 CORRECT** 확정(Q7).

> **[각주① · 게이트 G-ST-V2] 066 siz_nm 형상 인코딩 형태 불균일:** 합판도무송 37 size 중 정사각/직사각류는 `정사각30x30mm(2EA)`·`직사각35x25mm(2EA)`처럼 **형상+치수+EA(조각수)를 siz_nm에 인코딩**하나, 원형류는 `원형10x10`·`원형15x15`처럼 **EA 미포함**(형상+치수만, 별 size행 `원형 NNmm (NEA)`는 미생성). 즉 "siz_nm에 형상+치수+EA 인코딩"은 정사각/직사각류에 한정되고 원형류엔 부분 미적용이다. 단 **형상=size 모델 자체는 양쪽 모두 CORRECT 유지** — 원형류도 형상+치수가 siz_nm에 들어가 칼틀을 식별(Q7 정합)하며, EA(조각수)는 어차피 OM-7/조각수 GAP(C-ST-05) 소관이라 형상=size 판정에 영향 없음. 재현: `SELECT s.siz_nm FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000066' ORDER BY s.siz_nm;`(원형류 EA 없음·정사각류 EA 있음 확인).

---

## 3. 라우팅 분포

| 라우팅 | 건수 | 항목 |
|--------|:--:|------|
| 없음(유지) | 5 | C-ST-01·03·14·15·17 |
| load-execution | 6 | C-ST-02·04·07·09·11·12(+05/13 일부) |
| ddl-proposer | 2 | C-ST-05(ref_param_json)·C-ST-06(ref_param_json) — OM-7 GAP-PARAM 선결 |
| 컨펌(인간) | 6 | C-ST-04(Q-ST-A)·05(Q-ST-B)·06(Q-ST-C)·08(Q-ST-MES)·10·13(Q-ST-E)·16 |

---

## 4. 🔴 컨펌 질문 (인간 결정 대기)

- **Q-ST-A [🟡·HIGH·CONFLICT-1] 코팅 공정 전환 시 자재행 운명 + 가격 반영** — Q9★=코팅 공정. 라이브=8상품 무광/유광코팅스티커 자재. 가격표는 비코팅/무광/유광 3컬럼(코팅별 단가). round-11 product-bom §44는 "스티커 코팅=점착지 완제 표면사양=자재 variant 정당". (a) 코팅을 PROC_000013 공정으로 전환 + 비코팅 자재로 정정 + 코팅 공정 단가를 가격엔진에 (b) 라이브 자재 유지(round-11 입장·가격모델 단순) — 어느 쪽? **CONFLICT 미해소**(Q9 권위 vs 라이브 현실/가격모델 양립 곤란).
- **Q-ST-B [🟡] 조각수 적재 형태 (Q8 미실현·OM-7)** — 조각수=bundle_qty + prcs_dtl_opt.조각수 둘 다(Q8★). prcs_dtl_opt.조각수 상품 레벨 저장처 부재(`t_prd_product_processes`에 param 컬럼 없음). (a) ref_param_json 신설 후 둘 다 (b) bundle_qty만 — 어느 쪽? `*최대N조각`(상한 범위) 저장 형태(단일값 vs min/max)? **ref_param_json 미구현(OM-7) 선결** → ddl-proposer.
- **Q-ST-C [🟡] 규격형 058~062 형상 저장처** — 형상이 size·공정·product 어디에도 없음. (a) PROC_000055→PROC_000054(모양 param) 교체 + ref_param_json (b) 합판도무송식 siz_nm 인코딩 통일 (c) 현행 유지(형상=상품명 정체) — 어느 쪽? 합판도무송(칼틀=size)과 규격형(자유 형상)의 모델 일관성을 어떻게 둘지.
- **Q-ST-E [🟡] 스티커팩(065) 세트 구성** — 팩=여러 스티커 묶음. 세트 구성품(하위 스티커)이 무엇인지 불명(L1에 구성 명시 없음). (a) `t_prd_product_sets`에 하위 스티커 정의 (b) 세트 아닌 단일 시트 상품으로 둠 — 어느 쪽? 팩 구성 데이터 필요.
- **Q-ST-MES [🟡] MES_ITEM_CD 적재 정책** — 16상품 전량 NULL(load_master 의도·MES 중복). L1 002-0001~0016 실값 보유. 중복 정리 후 재적재할지, 의도된 NULL 유지할지 — 정책 결정.

---

## 5. 방법론 입증 소견

- **round-11/12 기지 이슈 인용 검증 — 양방향 정정:**
  - **합판도무송 형상(round-11 G-SK-2 "형상 size 흡수=오모델 의심")** → round-12 Q7이 이미 종결했으나 round-13 라이브 실측이 **형상=size가 정답임을 재확증**(siz_nm 인코딩·가격격자·CORRECT C-ST-03). round-11의 "오모델 의심"은 반증.
  - **타투 924행** → L1 실측 = 2행. 924는 가격표 전개행이지 상품마스터 시트 아님. **정답=상품마스터 L1(154행)** 원칙으로 16상품·154행 확정.
  - **round-12 "front=CLR_000005=무도수"** → 실측 CLR_000005=CMYK 4도. 단면 정합이나 코드 의미 표기 정정(C-ST-15).
- **v03 전파기 프레임이 진원을 갈랐다:** 스티커 결함 8건 중 5건이 v03 정규화 결함(코팅=자재·조각수 미전개·063 화이트 누락·카테고리 root·자재유형 혼재·자재명 절단)이고 load_master 코드 결함은 MES NULL 1건뿐. **교정의 진원=상류 v03, 정답 기준=상품마스터 L1** — load_master를 고칠 게 아니다.
- **search-before-mint 전건 충족:** 카테고리 노드 030~047·PROC_000013 코팅·PROC_000054 반칼(모양 param)·MAT_000084 비코팅 **전부 라이브 실재** 확인 → 교정에 신규 mint 0(ddl은 ref_param_json만, OM-7 알려진 미구현).
- **정체 선행의 가치(스티커는 정체 오분류 0):** 굿즈파우치/배경지와 달리 스티커는 정체가 명확(전 16상품 일반 인쇄물 스티커). 따라서 결함이 정체 레벨이 아니라 **속성축 레벨**(코팅·형상·조각수·별색·MES)에 집중 — product-identity가 이를 선제 확정해 5속성축 감사가 정밀했다.
