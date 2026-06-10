# 실사 — 정답 추출규칙 (extraction-plan · round-13 C2)

> **작성** 2026-06-11 · round-13. 각 상품 × 5 속성축(size·자재·공정·도수·인쇄옵션)을 **상품마스터 원본 L1(정답 권위)에서 어떻게 추출·변환해 어느 t_*.컬럼에 넣어야 정확한지** 확정. C1 실제 적재(loadlogic-notes)와 나란히 대조.
> **권위:** ① 상품 정체(product-identity) ② 엑셀 L1(`silsa-l1.csv`·정답) ③ 스키마 구조(`sql/`) ④ 도메인(round-11). **v03·load_master의 v03 전파 결과는 정답 아님.** 빈칸 0(N/A=사유).

---

## 0. 속성축 적용 매트릭스 (29상품 × 5축 — 커버리지)

| 축 | 적용 상품 | 정답 t_* | N/A 사유 |
|----|-----------|----------|----------|
| **size** | 29 전부 | `t_siz_sizes`(규격행) + `t_prd_product_sizes` + `t_prd_products.nonspec_*`(비규격 범위) | — |
| **자재(소재)** | 24(보드/액자/스탠딩 5 소재 빈값) | `t_mat_materials`(mat_typ 정확) + `t_prd_product_materials`(usage_cd) | 보드/액자/스탠딩=소재 빈값(L1)·보드 자재 별도 |
| **공정** | ~14(코팅/봉제/보드/족자/타공/열재단/화이트) | `t_proc_processes`(param) + `t_prd_product_processes` | 코팅없음·재단만 상품=공정 부재(정당) |
| **도수** | **0 (N/A)** | — | **실사 시트에 도수/인쇄면 컬럼 자체 없음**(L1 헤더 확인). 실사=라텍스/잉크젯 무도수 |
| **인쇄옵션** | 1(접착투명=화이트별색) | `t_prd_product_processes`(PROC_000008 화이트, clr_cd=NULL) | 별색=공정(도수 아님). 나머지 무 별색 |
| **부속(addon/set)** | ~8(액자/족자/행잉/배너/현수막) | `t_prd_product_addons` 또는 `t_prd_product_sets`(별매 부속) | 단품(포스터/보드/시트커팅)=부속 없음 |
| **카테고리** | 29 전부 | `t_prd_product_categories`(정상 노드 067~099) | — |

> **도수축 N/A 확정:** L1 헤더에 도수/앞면/뒷면/인쇄면 컬럼 부재(SELECT 헤더 전수). 실사는 도수 인쇄옵션이 없는 상품군 → 라이브 print_options=0(전부)은 **정답에 정합**(CORRECT). 별색(화이트 underbase)만 공정으로 분리.

---

## 1. size 추출규칙 (29상품)

| 항목 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 |
|------|---------------|----------------|----------|-------------|
| 규격 사이즈 | C5 사이즈(필수) `A3 (297x420)`·`5x5 (127x127)`·`600x1800mm`·`290x90` 등 | 규격명·인치규격·고정값을 이산 SIZ 행으로. `사용자입력`=size 행 생성 안 함(자유입력) | `t_siz_sizes`(cut_w/h) + `t_prd_product_sizes`(prd↔siz) | column-dictionary §2·sql 04 |
| 비규격 범위 | C6/C7 비규격 가로/세로 `200~1200`·`500~5000` | min~max 파싱 → nonspec_yn=Y + nonspec_*_min/max | `t_prd_products.nonspec_width_min/max·height_min/max` | sql 01a·column-dictionary §2 |
| 작업/재단 | C9 작업사이즈·C10 재단사이즈 | 규격행 work_*/cut_* (공백=미정의 정당) | `t_siz_sizes.work_*·cut_*` | column-dictionary §3 |

> **[HARD] 입력 UX ≠ 가격격자(메모리 권위):** 비규격 범위(C6/C7)=입력 UX 한계(nonspec_* 제약). 가격·유효사이즈=포스터사인 면적매트릭스(round-2 별도·분석 제외). **round-9 우려한 "비치수 연속범위 오판"은 라이브에 없음** — 라이브가 이산 규격 SIZ + nonspec 범위로 정확 분리. → live-diff에서 CORRECT 입증.

## 2. 자재(소재) 추출규칙 (24상품)

| 항목 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 |
|------|---------------|----------------|----------|-------------|
| 소재 정체 | C17 소재(필수) `인화지`·`린넨`·`레더(화이트)`·`타이벡(하드/소프트)` 등 | 소재명→자재행. **mat_typ는 재질로 분류**: 인화지/매트지/PET/PVC/투명=`.08 실사소재`·**그래픽천/린넨/캔버스/타이벡/메쉬/현수막천=`.05 원단`·레더=`.06 가죽`** | `t_mat_materials.mat_typ_cd` + `t_prd_product_materials`(usage_cd=USAGE.07 공통) | product-bom §0·BOM 횡단·seed MAT_TYPE |
| 다소재 variant | C17 다행(타이벡=하드+소프트·시트커팅=화이트+블랙·미러=골드+실버) | 상품 1개에 자재 N행(소재 선택지) | `t_prd_product_materials` N행 | L1 r56-57·120-121·133-134 |
| 보드/액자 소재 | C17 빈값(폼보드/포맥스/액자/스탠딩) | 소재 빈값 = 보드/우드 자재 별도(L1 미명시) | (보드 자재 별도 — L1 빈값) | product-bom §6·7·13 |

> **[정답 vs 라이브] mat_typ 정정:** 라이브는 실사 소재 전부 `.08`(평면화·loadlogic L-A). **정답=원단/가죽 분류**(같은 레더가 책자에선 .06으로 적재됨 — SELECT 입증). usage_cd=USAGE.07(공통)은 정당(seed에 "본체" 슬롯 없음, 디지털인쇄 C-03 동형·낱장 단일).

## 3. 공정 추출규칙 (~14상품)

| 공정 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 |
|------|---------------|----------------|----------|-------------|
| **코팅** | C19 코팅 `무광코팅`·`유광코팅`·`코팅없음` | 무광=PROC_000015·유광=PROC_000014(부모 PROC_000013)·코팅없음=공정 부재. param 면(단면/양면) | `t_prd_product_processes` + 마스터 param | column-dictionary §5 Q9·SELECT 공정마스터 |
| **봉제** | C20 가공 `오버로크`·`말아박기`·`봉미싱(7cm)`·`오버로크+리본끈` 등 | PROC_000080 봉제 + param 유형(오버로크/말아박기/봉미싱)·폭(7cm). **다종 옵션** | `t_prd_product_processes`(PROC_000080) + param | product-bom §4·8·SELECT param |
| **보드가공** | C20 `화이트보드`·`블랙보드`·`화이트포맥스(3mm)`·`(5mm)` | 보드마운팅 공정 + param 색/두께. **공정 마스터 부재** → ddl-proposer | (보드 공정 마스터 신설 후) `t_prd_product_processes` | product-bom §6·13·🔴Q-SL-C |
| **족자제작** | C20 `사각족자`·`원형족자` | PROC_000082 족자제작 + param 모양(사각/원형) | `t_prd_product_processes`(PROC_000082) + param | SELECT param·product-bom §8 |
| **타공** | C20 `4구타공`·`타공(4개/6개/8개)` | PROC_000079 타공 + param 구수(1~8) | `t_prd_product_processes`(PROC_000079) + param | SELECT param·product-bom §9·10 |
| **열재단** | C20 `열재단`·`재단만` | PROC_000084 열재단(현수막)·재단만=공정 부재 | `t_prd_product_processes`(PROC_000084) | product-bom §10·round-9 mint |
| **화이트별색** | C18 화이트별색 `단면`(접착투명) | PROC_000008 화이트(부모 PROC_000007 별색·clr_cd=NULL) | `t_prd_product_processes`(PROC_000008) | column-dictionary §5 G-SL-2 |

> **[HARD] 코팅=공정(Q9)·별색=공정(clr_cd=NULL)·param은 마스터 prcs_dtl_opt에 정의됨**(인스턴스 param은 옵션 레이어 또는 자유텍스트). 라이브는 코팅 2행(유광/무광)·봉제 1행·족자 1행만 — **봉제/보드/족자의 옵션 variant 누락**(loadlogic L-B). 코팅 유광+무광 2행은 L1 옵션 나열(무광/유광)과 정합이나 "코팅없음" 상품(아트프린트)에도 코팅 2행 적재됐는지 live-diff 검증.

## 4. 도수 추출규칙 — **N/A (실사 무도수)**

- **N/A 사유:** L1 실사 시트에 도수/앞면도수/뒷면도수/인쇄면 컬럼 **부재**(헤더 SELECT 전수 확인). 실사=대형 잉크젯/라텍스 출력 → 도수 인쇄옵션 없음.
- **정답 t_*:** `t_prd_product_print_options` = 0행(전 상품). 라이브 po=0 = **CORRECT**.

## 5. 인쇄옵션(별색) 추출규칙 (1상품)

| 항목 | 엑셀 출처(L1) | 추출/변환 규칙 | 목표 t_* | oracle 근거 |
|------|---------------|----------------|----------|-------------|
| 화이트 underbase | C18 화이트별색 `단면`(접착투명 r28) | 별색=공정 PROC_000008 화이트(clr_cd=NULL). 도수 아님 | `t_prd_product_processes`(PROC_000008) | column-dictionary §5·G-SL-2 |

> 접착투명포스터(PRD_000122)만 L1 명시(단면). 라이브 PROC_000008 화이트 1행 적재됨(SELECT) = **CORRECT**. 투명포스터★·홀로그램은 L1 빈값 → 도메인 강제(전 투명/홀로그램) 여부는 🔴Q-SL-B(round-11 CONFIRM-SL-2 인계, 도메인 강제 아닌 엑셀 명시분만 적재가 보수적).

## 6. 부속(addon/set) 추출규칙 (~8상품)

| 부속 | 엑셀 출처(L1·C21 추가) | 추출/변환 규칙 | 목표 t_* | oracle 근거 |
|------|------------------------|----------------|----------|-------------|
| 우드행거 | 캔버스행잉 `우드행거+면끈 포함` | 별매 부속 상품(PRD)→addon | `t_prd_product_addons` 또는 sets | product-bom §8·🔴Q-SL-D |
| 우드봉 | 린넨우드봉족자 `우드봉+면끈 포함` | 별매 부속→addon | `t_prd_product_addons` | product-bom §8 |
| 천정형고리 | 족자포스터 `천정형고리 포함` | 부속→addon | `t_prd_product_addons` | L1 r95 |
| 배너거치대 | PET/메쉬배너 `실내용/실외용배너거치대` | 별매 거치대(2종)→addon | `t_prd_product_addons` | L1 r101-106·product-bom §9 |
| 현수막 부속 | 일반/메쉬현수막 `큐방/끈/각목` | 부속→**round-9 CPQ 옵션으로 적재됨**(PRD_000138) | `t_prd_product_option_*`(round-9) | round-9 CPQ·SELECT og=3 |

> **[정답 vs 라이브] 부속 대량 누락:** L1 C21에 풍부한 부속(우드행거/우드봉/고리/거치대)이 라이브 addon=0·set=0(일반현수막만 CPQ). **"출력만"=부속 미선택 기본**(addon 0개 상태). 귀속(addon vs set vs CPQ) = 🔴Q-SL-D(round-11 CONFIRM-SL-4 인계).

## 7. 카테고리 추출규칙 (29상품)

| 항목 | 엑셀 출처 | 추출/변환 규칙 | 목표 t_* | oracle 근거 |
|------|----------|----------------|----------|-------------|
| 카테고리 연결 | C1 구분 + 상품명 | **상품명별 정상 노드**(아트프린트→CAT_000067·PET배너→CAT_000088 등) | `t_prd_product_categories.cat_cd` | SELECT 정상 트리 067~099 실재 |

> **[정답 vs 라이브] 카테고리 고아:** 라이브 28상품 전부 CAT_000298 실사(고아)에 연결. **정답=정상 노드 067~099**(전수 실재). loadlogic L-C·correction C1.

---

## 8. 정답 추출규칙 vs 라이브 실제 적재 (요약 대조)

| 축 | 정답 추출규칙 | 라이브 실제(C1 적재) | 판정 |
|----|---------------|---------------------|------|
| size 규격 | 이산 SIZ 행 + nonspec 분리 | 정확 일치(SELECT) | ✅ CORRECT |
| size 비규격 | nonspec_* min/max | L1 비규격과 일치 | ✅ CORRECT |
| 자재 소재명 | 정확 | 정확(인화지/린넨/레더...) | ✅ CORRECT |
| 자재 mat_typ | 원단(.05)/가죽(.06)/실사(.08) | **전부 .08 평면화** | ❌ MIS-LOADED |
| 자재 usage | USAGE.07 공통 | USAGE.07 | ✅ CORRECT |
| 코팅 공정 | 유광/무광 PROC + 코팅없음=무 | 유광+무광 2행 | 🟡 검증(코팅없음 상품에도?) |
| 봉제 공정 | PROC_000080 + 옵션 variant | 봉제 1행만 | ❌ MISSING(variant) |
| 보드가공 | 보드 공정(마스터 부재) | 코팅만(보드 0) | ❌ MISSING+ddl |
| 족자 공정 | PROC_000082 + 모양 param | 족자 1행 param 없음 | 🟡 MISSING(param) |
| 도수 | N/A(무도수) | po=0 | ✅ CORRECT |
| 화이트별색 | PROC_000008(접착투명) | PROC_000008 1행 | ✅ CORRECT |
| 부속 addon/set | 우드봉/거치대/고리 등 | addon=0·set=0(현수막 CPQ만) | ❌ MISSING |
| 카테고리 | 정상 노드 067~099 | CAT_000298 고아 | ❌ MIS-LOADED |
| 수량 | L1 빈값(3상품) | NULL(3상품) | 🟡 AMBIGUOUS(원본 빈값) |
