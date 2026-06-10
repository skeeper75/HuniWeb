# 굿즈파우치 — 정답 추출규칙 (extraction-plan · round-13 C2)

> **작성** 2026-06-11 · round-13. 대표상품 × 속성축(size·자재·공정·도수·인쇄옵션 + 카테고리·옵션·추가상품)별로 **엑셀 원본(L1)+스키마 의도(OM)+도메인(round-11)에 비춰 어떻게 추출·변환해 어느 t_*.컬럼에 넣어야 정확한지**를 확정. C1(loadlogic-notes)의 실제 적재 규칙과 나란히 둔다(실제 vs 정답).
> **권위:** 정체(product-identity) > L1 `goods-pouch-l1.csv` > webadmin sql/load_master > schema-intent OM-1~7 > round-11 도메인. **빈칸 0**(미저장은 N/A 사유 명기).
> **컨펌 의존 표기:** 🔴=인간 결정 미해소(잠정 권고). 본 plan은 잠정 권고를 명시하되 컨펌 전 적재 금지.

---

## 0. 속성축 커버리지 매트릭스 (대표상품 × 축)

| 대표상품 | size | 자재 | 공정 | 도수 | 인쇄옵션 | 카테고리 | 옵션(CPQ) | 추가상품 |
|------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 거울(5) | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 머그컵 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 핀버튼 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 반팔티셔츠 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 만년스탬프 | §1 | §2 | §3 | §4 | §5 | §6 | §7 | §8(리필잉크) |
| 말랑키링 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 레더 삼각 파우치 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 캔버스에코백 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 폰케이스 | §1 | §2 | §3 | N/A | §5 | §6 | §7 | N/A |
| 키링(볼체인) | §1 | §2 | §3 | N/A | §5 | §6 | §7 | §8(볼체인) |

> **도수(§4) N/A 사유:** 굿즈는 대부분 면(단/양면)/잉크색이 도수 의미를 갖지 않음(전사·패브릭·UV는 도수개념 약함). 예외 = 만년스탬프 잉크색(huni-goods §2.2 → 도수). **추가상품(§8) N/A 사유:** 거울/머그/핀버튼/티셔츠/말랑/파우치는 addon 없음(L1 추가상품 칼럼 빈값). 볼체인=키링·리필잉크=만년스탬프만.

---

## 1. size 축 — 치수형만 size, 옵션형은 §7(CPQ option)

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C5 `사이즈(필수)` + C7 `파일사양_작업사이즈`(L1 `_work_size_value` 평면화) |
| 추출/변환 규칙(정답) | **치수형(NxN, 22행)** → `t_siz_sizes`(work=cut=WxH, fix_size_dims 파싱) + `t_prd_product_sizes(prd_cd,siz_cd)`. **옵션형(폰기종/M·L·XL/방향/구수/면, 202행)** → size 아님, §7로 |
| 목표 t_* | 치수형: `t_siz_sizes.cut_*`/`work_*` + `t_prd_product_sizes` |
| oracle 근거 | column-dictionary C5·C7 · schema-intent **OM-2**(굿즈파우치 size→option) · round-10 변경추적 448셀 재분류 |
| 실제 적재(C1) | load_rel_sizes 무변환 1:1(`:307`). 치수형 정상(사각손거울 S/M/L 실측), 옵션형은 size 미적재 또는 §2로 흡수 |
| 정합 | 🟡 치수형 CORRECT · 옵션형 🔴(F-ID-4 미적재) |
| 비고 | **기계적 size 삭제 금지**(OM-2·가격사슬 파손). 적재된 치수형 22행 보존. 🔴 CONFIRM-GP-1(폰기종/등급=size vs option) |

---

## 2. 자재 축 — 본체색=재질행 합성(색×규격 2축 분리)·자재유형 정정

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C15 `선택(옵션)_선택`(본체색/사이즈등급) + C12 `파일사양_폴더`(소재 라우팅) + 상품명(소재 인코딩) |
| 추출/변환 규칙(정답) | **본체색** → `t_mat_materials` 합성행("블랙 파우치"=파우치원단(블랙) 1행) + `t_prd_product_materials(mat_cd, usage_cd=USAGE.07)`. **색×규격 복합("블랙 XL")=재질(블랙)×규격(XL) 2축 분리**(규격은 §1/§7로, 재질행은 색만). **자재유형** = 소재별 정확 MAT_TYPE(원단=.05·가죽=.06·아크릴=.03·금속=.04·필름=.02·실사=.08; **티셔츠=.05 원단·핀버튼 형상≠자재**) |
| 목표 t_* | `t_mat_materials(mat_typ_cd, mat_nm)` + `t_prd_product_materials(usage_cd=USAGE.07)` |
| oracle 근거 | column-dictionary C15 · huni-goods §2.1(본체색=재질행 합성·과분할 금지) · wowpress 규칙B · schema-intent §394(본체색=재질행 합성) · seed MAT_TYPE.01~.11 |
| 실제 적재(C1) | load_rel_materials 무변환(`:326`)·load_materials MAT_TYPE 라벨변환(`:237`). v03 결함 전파 |
| 정합 | 🔴 F-ID-2(색×사이즈 8행 폭증)·F-ID-3(형상·잉크색·용량 자재행화·MAT_TYPE.09 오염) |
| 비고 | **usage=USAGE.07(공통)이 정답**(USAGE.01=내지 아님 — round-11 CONFIRM-GP-5 정정). 🔴 CONFIRM-GP-2(블랙 XL 2축·글리터/멜란지=본체색) |

---

## 3. 공정 축 — 인쇄방식(폴더)별 + 후가공(봉제/에폭시/맥세이프)

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C12 `파일사양_폴더`(인쇄방식 7종) + C17 `가공(옵션)_가공`(라벨/에폭시/맥세이프) |
| 추출/변환 규칙(정답) | **인쇄방식**(패브릭/UV/전사/이지굿즈/디지털/만년도장/실사) → `t_proc_processes` 인쇄방식 root + `t_prd_product_processes`. **후가공**: 패브릭류=**봉제 PROC_000080**(D-24·유형/폭)·말랑=**에폭시 PROC_000083**(b.12)·폰케이스=맥세이프(부속+부착 PROC_000081)·라벨부착=PROC_000081 |
| 목표 t_* | `t_proc_processes(proc_cd, prcs_dtl_opt)` + `t_prd_product_processes(prd_cd, proc_cd, mand_proc_yn)` |
| oracle 근거 | product-bom §횡단 공정표 · process-recipe §9(봉제미싱)·§13(전사) · db-domain PROC_000080 D-24·PROC_000083 b.12 |
| 실제 적재(C1) | load_rel_processes 무변환(`:415`). 굿즈 공정 6행뿐(캔버스 PROC_000081 부착) |
| 정합 | 🔴 F-ID-5(봉제→부착 오적재·레더/타이벡/메쉬/말랑/폰케이스 공정 0행) |
| 비고 | 🔴 CONFIRM-GP-3(가공 택일그룹 GRP-GP-가공)·CONFIRM-GP-7(인쇄방식 7종 PROC 트리·외주 표현). `excl_grp_cd` 컬럼은 sql/23에서 삭제됨 |

---

## 4. 도수 축 — 만년스탬프 잉크색만(나머지 N/A)

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C5/C15 면(단/양면)·만년스탬프 잉크색(청보라/빨강/검정 등) |
| 추출/변환 규칙(정답) | **만년스탬프 잉크색** → `t_clr_color_counts`(또는 옵션 차원) **not 자재**. 면(단/양면) → `t_prd_product_print_options.print_side` |
| 목표 t_* | `t_clr_color_counts.clr_cd` / `t_prd_product_print_options(print_side, front_colrcnt_cd)` |
| oracle 근거 | huni-goods §2.2(만년스탬프 잉크색=도수) · column-dictionary C5(면=도수) |
| 실제 적재(C1) | load_rel_print_options(`:352`) — 굿즈 print_options=0. 잉크색은 §2 자재행으로 잘못 감 |
| 정합 | 🔴 F-ID-3(잉크색 자재화)·F-ID-4(print_options=0) |
| 비고 | 도수 N/A(대부분 굿즈) — 잉크색·면만 도수 의미. 별색≠도수(OM 일반 원칙) |

---

## 5. 인쇄옵션 축 — 출력파일타입·면

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C11 `파일사양_출력파일`(JPG/PDF/AI/PNG·X NP) + C5 면 |
| 추출/변환 규칙(정답) | 출력파일타입 → `t_prd_product_plate_sizes.output_file_typ`(굿즈는 출력용지규격 빈값이라 plate 주키는 N/A). 면=양면 → print_options |
| 목표 t_* | `output_file_typ`(plate_sizes 컬럼) |
| oracle 근거 | column-dictionary C11·C9(출력용지규격 전 빈값=굿즈 직인쇄) |
| 실제 적재(C1) | load_rel_plate_sizes(`:336`) — 굿즈는 출력용지규격 빈값이라 plate 행 미생성 가능. `X NP`=다면 임포지션=앱 |
| 정합 | 🟡(굿즈 plate 무의미 — 미적재 정당, N/A 사유 명기) |
| 비고 | 출력용지규격(C9)·블리드(C6)·재단(C8) 전 빈값 = 굿즈 리지드 단품(도련·전지 무의미). 미적재 정당 |

---

## 6. 카테고리 축 — 정상 트리 노드로 연결(고아 금지)

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C1 `구분`(상품군) + 상품명 |
| 추출/변환 규칙(정답) | 상품 → **정상 카테고리 노드**(`upr_cat_cd` 설정된 lvl2 노드) 연결. 거울→CAT_000165~169(upr=010 라이프)·레더파우치→CAT_000213~221(upr=011 에코백)·티셔츠→CAT_000206(패션, upr=010)·핀버튼→CAT_000189(기념품/액세서리, upr=010). **고아 노드(upr NULL·lvl3) 연결 금지** |
| 목표 t_* | `t_prd_product_categories(prd_cd, cat_cd, main_cat_yn)` |
| oracle 근거 | product-master 카테고리 트리 · 라이브 정상 노드 실측(CAT_000165/215/206/189) · digital-print F-ID-3 동형 |
| 실제 적재(C1) | load_rel_categories 무변환(`:288`). 35상품 고아 연결 |
| 정합 | 🔴 F-ID-1(고아 35상품). 거울/레더는 개별 정상 노드 실재 → 재연결 가능(search-before-mint) |
| 비고 | 일부 고아(소품 301·데스크 302·말랑 304·레더파우치 305)는 군 라벨 — 개별 정상 노드 매핑 또는 부모 UPDATE(upr=009/010/011) 후보 |

---

## 7. 옵션 축(CPQ) — 옵션형 사이즈(폰기종·등급·방향·구수·면) 🔴

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C5 `사이즈(필수)` 옵션형 202행 + C15 사이즈등급 |
| 추출/변환 규칙(정답) | 폰기종(아이폰/갤럭시)·사이즈등급(M/L/XL)·방향(세로/가로형)·구수(2/3/4구)·면(단/양면) → `t_prd_product_option_groups`(택1) → `options` → `option_items`(ref_dim_cd=OPT_REF_DIM 적정). 형상(원형/사각/하트)=규격 융합(§1 size 또는 옵션) |
| 목표 t_* | `t_prd_product_option_groups/options/option_items` |
| oracle 근거 | schema-intent OM-2 · round-10 size→option 재분류 · round-6 CPQ 옵션 레이어(dbm-cpq-option-mapping) |
| 실제 적재(C1) | **load_master CPQ 옵션 미적재**(RELATIONS 부재 `:469`). 굿즈 상품군(183~290) option_groups=0행(전역에는 001/002 테스트 잔재·066·138 = 6행 존재하나 굿즈 무관) |
| 정합 | 🔴 F-ID-4(전면 미적재). round-6 트랙 신규 적재 필요 |
| 비고 | 🔴 CONFIRM-GP-1 미해소 — 폰기종/등급=size vs CPQ option 결정 의존. 본 round-13은 갭만 보고, 적재는 round-6+인간승인 |

---

## 8. 추가상품 축 — 볼체인·리필잉크(별 상품 재연결)

| 항목 | 내용 |
|------|------|
| 엑셀 출처 | C22 `추가상품(옵션)_추가상품`(볼체인 9색·잉크 5cc·아크릴스탠드) |
| 추출/변환 규칙(정답) | 볼체인(키링)·리필잉크(만년스탬프)·아크릴스탠드(거치) → `t_prd_product_addons(prd_cd, addon_prd_cd)` 링크. **addon 대상 상품 = 별 PRD 실재**(볼체인 PRD_000006·리필잉크 PRD_000015 — search-before-mint 재사용) |
| 목표 t_* | `t_prd_product_addons` |
| oracle 근거 | column-dictionary C22 · load_rel_addons(`:436`) · 라이브 실측(볼체인·리필잉크 별 상품 실재) |
| 실제 적재(C1) | 굿즈 addons=0(v03 `20` 시트 굿즈 행 부재) |
| 정합 | 🔴 F-ID-5(addon 링크 미적재·대상 PRD는 실재) |
| 비고 | search-before-mint — 볼체인 PRD_000006·리필잉크 PRD_000015 재연결(신규 mint 불요) |

---

## 9. 미저장(앱 런타임)·N/A 명시

| 항목 | 사유 |
|------|------|
| 가격(C23 고정가형) | round-2 트랙 — 본 round-13 범위 밖(가격포함 시트, 분석 제외) |
| 다면 임포지션(`JPG X NP`) | 앱 런타임 계산(DB 미저장, dbmap-compute-in-app-db-stores-lookup) |
| 파일명약어(C10)·Z토큰(C26) | 생산메타 견적 밖(CONFIRM-GP-6 전 시트 일괄) |
| MES_ITEM_CD | 굿즈 미부여(신규 등록 대상)·NULL 적재 정당(CONFIRM-GP-8) |
| 블리드/재단/출력용지규격(C6/C8/C9) | 굿즈 리지드 단품 — 도련·전지 무의미·전 빈값. 미적재 정당 |
