# 굿즈파우치 — 교정 매니페스트 (correction-manifest · round-13 C4)

> **작성** 2026-06-11 · round-13. live-diff(C3) 각 발견을 CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS로 분류하고 why(oracle 근거+적재로직 원인)+how(비파괴 교정 제안)+심각도+라우팅 기록. 🔴 컨펌 질문 분리.
> **[HARD] DB 미적재** — 본 라운드는 교정 제안까지. 실 COMMIT/DDL/논리삭제는 round-5/10/6 + 인간 승인. **비파괴**(COMMIT/DDL/DELETE 0·EXTRA=논리삭제 제안·search-before-mint).

---

## 1. 분류 분포 요약

| 분류 | 건수 | 비고 |
|------|:--:|------|
| **CORRECT** | 4 | 치수형 size·usage USAGE.07·sets 0·정상 카테고리 56상품·addon 대상 PRD 실재 |
| **MIS-LOADED** | 6 | 카테고리 고아·본체색 폭증·비소재 자재화·자재유형 오염·봉제→부착·size→option 미적용 |
| **MISSING** | 4 | 공정(봉제/에폭시/맥세이프)·도수(잉크색/면)·추가상품 링크·CPQ 옵션 레이어 |
| **EXTRA** | 1 | 잉여 고아 카테고리 노드(14개, 굿즈 6개) |
| **AMBIGUOUS** | 2 | 폰기종/등급 size vs option·ROOT 직결(말단 노드 미사용) |
| **합계** | **17** | (빈칸 0) |

---

## 2. 교정 매니페스트 표

| ID | 상품/범위 | 속성 | 분류 | 라이브 현재값 | 정답값 | why(oracle+적재로직) | how(비파괴 교정) | 심각도 | 라우팅 |
|----|------|------|------|------|------|------|------|:--:|------|
| **GP-C-01** | 거울5·레더파우치9·말랑9·데스크9·소품 등 35상품 | 카테고리 | MIS-LOADED | 고아 노드(CAT_000301 소품·305 레더파우치 등·upr NULL·lvl3) | 정상 노드(거울→CAT_000165~169·레더→CAT_000213~221·upr=010/011) | digital-print F-ID-3 동형·load_categories:170/175 빈 상위코드 무추론·v03 전파 | UPDATE `t_prd_product_categories SET cat_cd=<정상노드>` (search-before-mint: 정상 노드 실재). 거울/레더는 개별 정상 노드로 재연결. 군 노드 없는 경우 고아 부모 UPDATE(upr=009/010/011) | High | 교정 직접(round-10 델타) + 일부 ddl |
| **GP-C-02** | 잉여 고아 노드 CAT_000293~306(굿즈 6개: 301/302/303/304/305/306) | 카테고리 | EXTRA | upr NULL·lvl3 고아 노드 잔존 | 재연결 후 잉여 노드 논리삭제 또는 부모 부여 | 시트 `구분` 라벨 파생 중복 노드(추정)·load 무검증 | 재연결 후 잉여 노드 `use_yn='N'` 논리삭제 제안(hard-delete 금지) 또는 upr_cat_cd UPDATE(009/010/011) | Medium | ddl-proposer/컨펌 |
| **GP-C-03** | 반팔티셔츠 등 색×사이즈 다수(8행 폭증) | 자재 | MIS-LOADED | "화이트 M/L/XL/XXL·블랙 M/L/XL/XXL" 8 자재행(MAT_TYPE.09) | 본체색 2행(화이트/블랙) + 규격 M/L/XL/XXL는 §7 옵션. 자재유형=.05 원단 | huni-goods §2.1 본체색=재질행 합성·과분할 금지·OTC C-6·load_rel_materials:326 v03 무변환 전파 | 색×규격 2축 분리: 자재행=색만(2행), 규격→option_items. 자재유형 .09→.05 UPDATE. **CONFIRM-GP-2 의존** | High | 컨펌→교정 |
| **GP-C-04** | 핀버튼·머그(11온스)·만년스탬프(잉크색) | 자재→size/도수 | MIS-LOADED | 형상/용량/잉크색이 자재행(MAT_TYPE.09 파우치) | 형상→t_siz_sizes·용량→비치수 siz(§2.3)·잉크색→t_clr/print_options | wowpress 형상=규격·huni-goods §2.2 잉크색=도수·§2.3 용량=규격·load 무변환 | 비소재 자재행 논리삭제 후 정확 축 신규 적재(형상 size·용량 siz·잉크색 도수). search-before-mint(기존 siz/clr 우선) | High | 교정(round-10/6) |
| **GP-C-05** | 굿즈 자재 자재유형 오염 광범위 | 자재 | MIS-LOADED | MAT_TYPE.09(파우치)가 티셔츠·핀버튼·만년스탬프·머그 등 무차별 | 소재별 정확 MAT_TYPE(.05 원단·.04 금속·.10 악세사리·.02 필름 등) | load_materials:237 라벨변환은 정확하나 v03 `자재구분`이 "파우치"로 잘못 채워짐(v03 진원) | mat_typ_cd UPDATE(소재별 정정). L1 폴더/상품명 권위로 소재 판정 | High | 교정(round-10) |
| **GP-C-06** | 캔버스 파우치/필통/에코백 6상품 | 공정 | MIS-LOADED | PROC_000081 부착 | PROC_000080 봉제(D-24·패브릭→봉제미싱 §9) | product-bom §6·process-recipe §9·load_rel_processes:415 v03 전파(v03가 부착으로) | proc_cd UPDATE(081 부착→080 봉제) 또는 봉제 행 추가. 부착이 별개 의미면 보존 | High | 교정(round-10) |
| **GP-C-07** | 레더/타이벡/메쉬 파우치·말랑·폰케이스 | 공정 | MISSING | 공정 0행 | 봉제(080)·에폭시(083 b.12)·맥세이프(081 부속+부착) | product-bom §2/§5/§7·db-domain PROC_000080/083·v03 `15` 굿즈 공정 부재(load 무도출) | `t_prd_product_processes` 신규 INSERT(상품군별 후가공). search-before-mint(PROC 기존행) | High | load-execution(round-5) |
| **GP-C-08** | 만년스탬프 잉크색·면(단/양면) | 도수 | MISSING | print_options=0(잉크색은 GP-C-04 자재행) | 잉크색→t_clr/print_options·면→print_side | huni-goods §2.2·column-dictionary C5·load print_options v03 입력 부재 | print_options/clr 신규 적재(잉크색 도수·면). GP-C-04와 연동 | Medium | load-execution(round-5) |
| **GP-C-09** | 볼체인(키링)·리필잉크(만년스탬프) | 추가상품 | MISSING | addons=0 | addon 링크(볼체인 PRD_000006·리필잉크 PRD_000015) | column-dictionary C22·load_rel_addons:436 v03 `20` 굿즈 행 부재 | `t_prd_product_addons(prd_cd, addon_prd_cd)` 신규 INSERT. **search-before-mint: 대상 PRD 실재(재연결, mint 불요)** | Medium | load-execution(round-5) |
| **GP-C-10** | 옵션형 사이즈(폰기종·M/L/XL·방향·구수·면) 58상품 | 옵션(CPQ) | MISSING | 굿즈(183~290) option_groups=0행(전역 6행은 001/002 테스트 잔재·066·138 = 굿즈 무관) | option_groups/options/option_items(ref_dim_cd) | schema-intent OM-2·round-10 size→option·load_master CPQ 미적재(범위 밖 RELATIONS:469) | round-6 CPQ 트랙 신규 적재. **CONFIRM-GP-1 의존**(폰기종/등급=size vs option) | High | round-6 옵션 매핑+컨펌 |
| **GP-C-11** | 치수형 사이즈 22행(사각손거울 S/M/L 등) | size | CORRECT | SIZ_000384 S(75x130)·386 M·388 L 등 정상 | 치수형 size | fix_size_dims 파싱 정상·load_rel_sizes 무변환 적절 | (유지) — **기계적 size 삭제 금지**(OM-2 가격사슬 보존) | — | (유지) |
| **GP-C-12** | 굿즈 자재 usage_cd | 자재 | CORRECT | USAGE.07(공통) 전부 | USAGE.07(공통) | load_rel_materials:324 빈용도→공통·USAGE.01=내지 아님 | (유지) — round-11 CONFIRM-GP-5 가정("USAGE.01 본체") 정정: 공통이 정답 | — | (유지) |
| **GP-C-13** | 굿즈 sets | 세트 | CORRECT | sets=0 | 0(굿즈=세트 아님) | load_rel_sets v03 굿즈 세트 부재가 정당 | (유지) | — | (유지) |
| **GP-C-14** | 정상 노드 연결 56상품 | 카테고리 | CORRECT | NORMAL(upr set)·티셔츠 CAT_000206·핀버튼 189·에코백 254 | 정상 노드 | load_rel_categories 정상 전파 | (유지) | — | (유지) |
| **GP-C-15** | 폰기종(아이폰15프로맥스)·사이즈등급(M/L/XL) | size↔option 경계 | AMBIGUOUS | 자재행 흡수 또는 누락 | size vs CPQ option 차원 미정 | OM-2·round-10·CONFIRM-GP-1 미회신 | 인간 결정 전 적재 금지. 잠정 권고=옵션형은 option_items | High | 🔴 컨펌(Q-GP-1) |
| **GP-C-16** | 머그=라이프 ROOT(lvl1)·기타 ROOT 8상품 | 카테고리 | AMBIGUOUS | CAT_000010 라이프(lvl1 ROOT 직결) | 말단 노드(머그=CAT_000170 등) | ROOT 직결은 정상이나 말단 노드 미사용 | 말단 노드 연결로 정밀화(선택). 현 상태도 무결성 위반은 아님 | Low | 컨펌/선택 |
| **GP-C-17** | 굿즈 MES_ITEM_CD | 식별 | CORRECT | NULL 전부 | NULL(신규 등록 대상) | load_products:261 전량 NULL·굿즈 MES 미부여 | (유지) — CONFIRM-GP-8(노랑배경=신규) 정합 | — | (유지) |

---

## 3. 🔴 컨펌 질문 (인간 결정 대기)

| ID | 질문 | 영향 교정 | round-11 대응 |
|----|------|------|------|
| **Q-GP-1** | 폰기종(아이폰15프로맥스 등)·사이즈등급(M/L/XL)을 `t_prd_product_sizes`(size)로 둘지, CPQ `option_items`(별도 옵션 차원)로 둘지? (기계적 size 삭제는 가격사슬 파손) | GP-C-10·GP-C-15 | CONFIRM-GP-1(미회신) |
| **Q-GP-2** | 본체색×규격 복합("블랙 XL")을 재질(블랙)×규격(XL) 2축으로 분리할지? 글리터/멜란지=본체색 맞는지? (현 라이브=8행 직교 폭증) | GP-C-03 | CONFIRM-GP-2(미회신) |
| **Q-GP-3** | 굿즈 가공(라벨/에폭시/맥세이프)을 신규 택일그룹(GRP-GP-가공)으로 둘지 상품별 단순공정으로 둘지? (`excl_grp_cd` 컬럼은 sql/23에서 삭제됨 — 택일그룹 표현 방식 재검토 필요) | GP-C-06/07 | CONFIRM-GP-3(미회신) |
| **Q-GP-4** | 잉여 고아 카테고리 노드(CAT_000293~306)를 (a) 재연결 후 논리삭제 (b) 부모 부여(upr=009/010/011)로 정상화 (c) 보존 중 무엇? | GP-C-01/02 | digital-print Q-ID 동형 |
| **Q-GP-5** | 인쇄방식 7종(특히 이지굿즈 PVC고주파·만년도장·전사 외주·패브릭인쇄)을 어느 PROC root에 둘지? 외주를 신규 PROC로 mint할지 기존 트리 흡수할지? | GP-C-07 | CONFIRM-GP-7(미회신) |

---

## 4. BLOCKED / 미해소

- **적재 경로 부분 불명** — load_master가 읽는 v03 마이그레이션 xlsx(`data/raw/prdmaster_full_migration_v03_20260518.xlsx`)가 레포 미동봉(`.venv`도 부재). F-ID-2/3/1의 v03 단계 vs load 단계 진원 구분은 v03 코드 변환 부재로 "v03 진원·load 전파"로 판정(loadlogic-notes §0). v03 원본 확보 시 재검증 가능.
- **CPQ 옵션 레이어(GP-C-10)** — load_master 범위 밖(애초 미적재). round-6 신규 적재 트랙이며 Q-GP-1 선결 필요.
- **가격(C23 고정가형)** — round-2 트랙·본 round-13 범위 밖(가격포함 시트 분석 제외).

---

## 5. 교정 라우팅 분포

| 라우팅 | 건수 | ID |
|--------|:--:|------|
| 교정 직접(round-10 델타 UPDATE) | 5 | GP-C-01·03·04·05·06 |
| load-execution(round-5 신규 INSERT) | 3 | GP-C-07·08·09 |
| round-6 옵션 매핑 + 컨펌 | 1 | GP-C-10 |
| ddl-proposer/컨펌(EXTRA·고아 정리) | 1 | GP-C-02 |
| 🔴 컨펌 선결 | 2 | GP-C-15·16 |
| 유지(CORRECT) | 5 | GP-C-11·12·13·14·17 |

> **핵심 비파괴 원칙 준수:** 모든 교정은 UPDATE/INSERT 제안 또는 논리삭제(use_yn='N') 제안. hard-delete·DDL 적용·COMMIT 0. search-before-mint 적용(GP-C-01 정상 노드·GP-C-04 기존 siz/clr·GP-C-09 볼체인/리필잉크 별 상품 재사용).
