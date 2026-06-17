# 등록 명세 — ④ 자재 (`t_mat_materials` / MAT_TYPE)

> **하네스** hbg Phase 3 설계가(`hbg-registration-designer`). **작성** 2026-06-18. 1순위 축.
> **입력:** `02_diagnosis/diagnosis-material.md`(4-way 결함·129행 오염·.10 혼재 정정) · `01_authority/axis-authority-material.md`(정답 사전) · `_routing-summary.md`(축이동 90행).
> **재사용:** rpmeta `04_vessel/vessel-material-axis.md`(V-3 MAT_FACET) · dbmap `00_schema/code-identifier-strategy.md`(D1~D5 채번) · `11_ddl_proposals/{shape-axis,goods-pouch-nondim-size}` · huni-admin-manual `01_source_admin-screen-map.md`(적재경로).
> **[HARD] 명세 ≠ 적용.** CREATE/ALTER/COMMIT 0. 실 적재는 dbmap 트랙(`dbm-axis-staged-load`·`dbm-load-execution`) 인간 승인 후 위임.

---

## 0. 채번·멱등·적재경로 공통 규약 (전 항목 적용)

> dbmap `code-identifier-strategy.md` §6 D1~D5 비준 인용(재유도 금지).

| 규약 | 내용 |
|------|------|
| **채번** | `PREFIX_` + lpad(라이브 MAX(suffix)+1, 6, '0'). 자재 mint = `MAT_000337~`(라이브 MAX 000336). 코드행 = `GROUP.NN`(그룹채번). separator `_`(CPQ 하이픈 폐기). |
| **멱등 키** | 이름 기반 — 자재 `(mat_nm, mat_typ_cd)` · 코드행 `(cod_cd)`. NOT EXISTS 가드. 신규 DDL 0 지향. |
| **적재경로(자재)** | ① catalog Django **`tmatmaterials__add/change`**(/admin/catalog/tmatmaterials/) — mat_nm·mat_typ_cd(드롭다운)·upr_mat_cd(트리)·width/height 등. ② BOM link는 product-viewer **`pvEdit(prd_cd, materials)`** 섹션(`section_edit`). |
| **적재경로(MAT_TYPE 코드행)** | catalog Django **`tcodbasecodes__add/change`** — `BaseCodeAdminForm`(빈코드+상위미선택 시 폼오류·upr_cod_cd=루트만)·**GROUP.NN 그룹채번**. |
| **적재경로(축이동 목적지)** | siz=`pvEdit(sizes)` · print_side=`pvEdit(print_options)` · bundle=`pvEdit(bundle_qtys)` · 옵션색=`option_items` 드릴다운 3계층(`pvEdit` options/grp/opt). |
| **reg_dt 함정** | NOT NULL DEFAULT — 명시 NULL 금지(DEFAULT 미발화). admin UI는 자동 처리(reg_dt 폼 제외). |
| **★소프트삭제 권위 [HARD·정정]** | **`del_yn='Y'`(+`del_dt`=now())** = 조회/BOM/가격 선택지 차단 권위(`admin.py:452-461` get_queryset exclude·`cfg_utils logical_delete`·`views.py` 전반 `del_yn='N'` 필터·`sql/10·24`). **use_yn = 부차 활성 토글**(list_filter일 뿐 조회 미차단). 오염행을 "떼어내는" 조치 = **del_yn='Y'**(use_yn='N' 아님). 진단 §del_yn/use_yn 권위 관계 인용. |
| **★멱등 가드 [HARD·정정]** | **`WHERE del_yn='N'`**(이미 'Y'면 skip) + **del_yn·use_yn 둘 다 추적**(단독 추적 금지·B5 blind-spot 재발 방지). |

> **★FK 위상 load-bearing [HARD·전 축이동 적용·정정]:** 오염 .08/.09/.10 행 BOM link = **177건**(전건 usage_cd=USAGE.07·본체 슬롯). 80/82 상품 본체 BOM이 오염행 의존. 적재순서 = **① 본체 소재 .05/.06 link 선적재(GPM-1/2 41행 설계 GO·미COMMIT) → ② 비소재 목적지 축 적재(siz/print_side/bundle/option) → ③ 오염 .08/.09/.10 BOM link 제거/재배선(GPM-4) → ④ 오염 자재행 `del_yn='Y'`(+del_dt) 마지막.** 순서 위반 시 본체 자재 link 전손. **component_prices.mat_cd 참조 = .08/.09/.10 전건 0 → 가격사슬 안전**(단가행 파손 없음).
>
> **★진짜 미완 = BOM link 제거(GPM-4) [HARD·정정]:** del_yn='Y' 소프트삭제만으로는 **이미 BOM/그리드에 박힌 mat_cd는 런타임 참조 그대로**(`price_views.py:537-538` "그리드는 기존 셀 코드 보존"·BOM JOIN이 mat del_yn 미필터). del_yn='Y'의 효과 = **신규 선택 UI에서 숨김까지만**. → 진짜 정리 = **오염 BOM link 177건(USAGE.07) 제거(GPM-4)가 자재행 del_yn='Y'에 선행**. 라이브 .09 69행은 이미 del_yn='Y'(절반 완료)이나 BOM link 113 여전히 활성 = blind-spot 실증.
>
> **★회귀 경고 + 근본 경로 [HARD·round-22 P-TRUNCATE 가드 인용]:** 라이브 del_yn='Y'(143행)는 load_master 산출이 아니라 **admin UI 논리삭제 흔적**(`load_master.py:233` INSERT 컬럼에 del_yn 미명시→DEFAULT 'N'). → 개발자 v03 재적재(`TRUNCATE CASCADE` 후 재INSERT) 시 **del_yn='Y'가 전부 'N'으로 휘발**(소프트삭제 소멸). **라이브 del_yn='Y'는 임시책** — 근본 교정 = **경로 Y**(v03 오염행 자체 제거·개발자 재적재). round-22 03 P-TRUNCATE 가드 인용.

---

## 1. MAT_TYPE 코드행 — search-before-mint 판정 (사다리 1단)

> 진단 §0: 라이브 MAT_TYPE = **14 자식 코드(`.01~.14`)** 확정(C-MAT-1 해소). 라벨 = 스냅샷 B 일치.

### 1.1 신규 코드행 0건 (라이브 14코드 이미 실재)

**판정: MAT_TYPE 신규 코드행 등록 = 0.** 라이브가 이미 `.01~.14` 14자식 보유(진단 §0 실측). 정답 사전이 "컨펌"으로 남긴 `.01·.02·.05·.12~.14` 라벨은 **라이브 SELECT가 종결**(스냅샷 B = 라이브 실측 일치). → 코드행 mint 불요. **search-before-mint 사다리 1단에서 정지(기존 코드행으로 전부 표현 가능).**

### 1.2 MAT_FACET 분해축 코드행 — vessel V-3 처방 재사용 (조건부·보류)

> rpmeta `vessel-material-axis.md §2.1` 처방 인용(재발명 금지). 자재 *분해축 분류*(이 행이 소재/두께/용량/표면마감인가)를 담는 코드행.

| 대상 t_* + 코드값 | 올바른 의미 | search-before-mint | 권위 | 적재경로 | 라우팅 |
|---|---|---|---|---|---|
| `t_cod_base_codes` `MAT_FACET`(부모) | 자재분해축 그룹 | 사다리 1단(코드행·테이블 0) | vessel V-3 §2.1 | tcodbasecodes add(그룹채번) | **신규(보류)** |
| `MAT_FACET.01` | 소재(PTT) | upr_mat_cd 계층 우선 시도 → 부족 시 코드 | V-3 §2.1 | 동상 | 신규(보류) |
| `MAT_FACET.02` | 두께/무게(WGT) | 값=기존 `weight`/`depth` 컬럼(슬롯 실재) | V-3 §2.1·§10.1 | 동상 | 신규(보류) |

**판정: MAT_FACET 코드행 = 보류(이번 1순위 scope 밖).** 자재 *오염 교정*(.08/.09/.10 축이동)이 1순위이고, MAT_FACET은 *정상 자재의 분해축 분류*(두께/소재 facet)로 별개 트랙. vessel V-3은 "먼저 `upr_mat_cd` 계층 재사용 입증 → 부족 시만 코드행"을 권고(§6 open decision). **1순위에서는 처방만 인용·등록 보류.** 실 등록 = 정상 자재 분해축 정비 회차(다음).

---

## 2. .08 실사소재 색상 5행 — 축이동 명세 (오염)

> 진단 §1: MAT_000255~259(화이트/블랙/홀로그램/골드/실버) = 색=자재 오염. BOM 5상품 usage=USAGE.07. cp 참조 0.

### 2.1 등록 명세

| 항목 | 내용 |
|------|------|
| **대상 행** | MAT_000255 화이트·256 블랙·257 홀로그램·258 골드·259 실버 (.08 실사소재 mat_typ) |
| **올바른 의미** | 색상 — 자재 아님. 본체색(2~3종 자재유지) vs 선택목록(4종+ → CPQ option) 경계. |
| **목적지 t_*** | **판정 분기(B-MAT-3 컨펌 의존)** — ⓐ 본체색 2~3종이면 `t_mat_materials` 색 합성 행 유지(mat_nm에 색 포함) / ⓑ 선택 팔레트 4종+이면 `t_prd_product_option_items`(ref_dim_cd=OPT_REF_DIM.03 본체색·자재 합성 또는 자유옵션) + BOM link 제거 후 자재행 **del_yn='Y'**(+del_dt). |
| **현 판정** | 5종(화이트/블랙/홀로/골드/실버) → 4종+ 기준이면 **옵션 이동**. 단 상품별 *동시 팔레트*인지 *상품마다 1색 고정*인지 미실측 → **컨펌 큐 B-MAT-3**. |
| **권위 근거** | 정답 사전 §1/§2.1/§3(본체색 경계) · 진단 §1 ★색상 5행 판정 미묘점 |
| **채번** | 옵션 이동 시 신규 자재 mint 0(기존 행 소프트삭제 del_yn='Y'). option_items=자연키 (prd_cd,opt_cd,item_seq) — 채번 불요. |
| **적재경로** | (ⓑ) `option_items` 드릴다운 3계층 `pvEdit(prd_cd, options/<grp>/<opt>)`. 자재행 소프트삭제 = `tmatmaterials change`(admin 삭제 버튼 = **del_yn='Y'+del_dt** logical_delete·use_yn 아님). |
| **FK 위상** | ① 본체색 자재 또는 option_group/option 선적재 → ② BOM link 재배선/제거(5상품·GPM-4) → ③ MAT_000255~259 **del_yn='Y'**(+del_dt) 마지막. |
| **영향분석** | cp 참조 0(가격 안전). BOM 5상품(PRD_000143 등 골드/실버) link 재배선 필요. 롤백=del_yn='N'(+del_dt=NULL) 복원. |

> **컨펌 큐 → B-MAT-3.** 본 5행은 명세를 만들되 목적지(자재 유지 vs 옵션)는 사용자 1색고정/팔레트 결정 후 확정.

---

## 3. .09 파우치 69행 — 축이동 명세 (전수 비소재·5 버킷)

> 진단 §2: shape 18 · size 11 · color/color×size 21 · print_side 14 · count 4 · other 1 = 69. 진짜 소재 0. BOM 113건(52상품) 전건 USAGE.07. cp 참조 0.

### 3.1 shape 18행 → ② 사이즈 (`t_siz_sizes`) + 형상축 SHAPE

| 항목 | 내용 |
|------|------|
| **대상 행** | 원형 90mm·사각 110mm·꽃·별·하트·마카롱·정사각·직사각 등 18행(.09) |
| **올바른 의미** | 형상 — 도무송=칼틀 1:1(Q7). 형상은 size(치수)와 별축(vessel V-12 SHAPE). |
| **목적지 t_*** | **두 그릇 분리** — (a) 치수 있는 형상(원형 90mm·사각 110mm)은 `t_siz_sizes` siz_cd + 형상 분류는 `shape_cd`(SHAPE 코드) / (b) 비치수 명목 형상(하트·별·꽃·마카롱)은 vessel V-12 SHAPE 코드 + 칼틀 게이팅 `t_prd_product_sizes.shape_cd`. |
| **search-before-mint** | shape-axis DDL(`11_ddl_proposals/ddl-proposal-shape-axis.sql`) 재사용 — **신규 테이블 0**(코드행 SHAPE 6 + 기존 junction `t_prd_product_sizes`에 shape_cd 컬럼). siz 자체는 치수 보유 라벨만 등록(비치수는 siz 둔갑 금지·goods-pouch-nondim-size 제안 참조). |
| **권위 근거** | 정답 사전 §2.1(형상→② siz·Q7) · vessel-shape-axis(V-12·1:多 칼틀) · 진단 §2 |
| **채번** | 치수 siz 신규 = `SIZ_NNNNNN`(라이브 MAX+1). SHAPE 코드행 = `SHAPE.01~.06`(shape-axis DDL 사양·코드행 6). |
| **적재경로** | siz=`pvEdit(prd_cd, sizes)` 섹션. SHAPE 코드행=`tcodbasecodes add`(그룹채번). shape_cd 컬럼=DDL 선적용 후 admin 노출(현재 admin 미노출 — **적재경로 미상**, DDL 적용 후 확정). |
| **FK 위상** | ① SHAPE 코드행 + shape_cd 컬럼 DDL(dbm-ddl-proposer) → ② siz 등록 + 형상 분류 → ③ .09 shape 18행 BOM link 제거(GPM-4) → ④ 자재행 **del_yn='Y'**(+del_dt). |
| **영향분석** | cp 참조 0. BOM 재배선. **shape_cd 컬럼은 DDL 필요**(vessel-gap V-12·정당). 비치수 형상(하트 등)은 goods-pouch-nondim-size 신규 마스터 후보(별 트랙). |

### 3.2 size 11행 → ② 사이즈 (`t_siz_sizes` / 비치수)

| 항목 | 내용 |
|------|------|
| **대상 행** | 11인치·13인치·M·L·S·XL·A5용·A4용·미니50mm·일반100mm 등 11행(.09) |
| **올바른 의미** | 치수/용량/사이즈클래스 — 자재 아님. |
| **목적지 t_*** | **분기** — (a) 실치수 보유(미니50mm·일반100mm)는 `t_siz_sizes` siz_cd 신규 / (b) 비치수 등급(M/L/S/XL·A4용·11인치)은 **goods-pouch-nondim-size 신규 마스터**(`t_siz_nonspec_sizes`) 또는 CPQ option. |
| **search-before-mint** | dbmap `ddl-proposal-goods-pouch-nondim-size.md` §2 입증: t_siz_sizes에 work/cut NULL 순수 라벨 행 0건 → 비치수 라벨은 siz 둔갑 불가. **신규 마스터 `t_siz_nonspec_sizes`(사다리 4) 정당**(4개 기존 구조 무손실 실패 입증). |
| **권위 근거** | 정답 사전 §2.1(용량/사이즈→②) · goods-pouch-nondim-size 제안 |
| **채번** | 실치수 siz=`SIZ_NNNNNN`. 비치수=`NSIZ_NNNNNN`(신규 마스터 PK·제안 사양). |
| **적재경로** | 실치수 siz=`pvEdit(sizes)`. 비치수 마스터=**적재경로 미상**(신규 테이블·admin 미구현·DDL 적용 후 catalog 모델 자동등록 가능). |
| **FK 위상** | ① NONDIM_SIZE_KIND 코드행 + t_siz_nonspec_sizes·t_prd_product_nonspec_sizes DDL → ② 라벨/연결 적재 → ③ .09 size 11행 BOM link 제거(GPM-4) → ④ 자재행 **del_yn='Y'**(+del_dt). |
| **영향분석** | cp 참조 0. 비치수 마스터 = **DDL-NEEDED**(vessel/data-gap·dbmap 제안 재사용·인간 승인). |

### 3.3 color/color×size 21행 → CPQ 옵션 (`option_items`)

| 항목 | 내용 |
|------|------|
| **대상 행** | 화이트 M/L/XL/XXL·블랙 M~XXL·핑크글리터·청보라·빨강·검정 등 21행(.09·색 또는 색×사이즈 복합) |
| **올바른 의미** | 선택 색 목록(4종+) — CPQ option. 단 색×사이즈 복합은 색=옵션·사이즈=② 분해. |
| **목적지 t_*** | `t_prd_product_option_items`(ref_dim_cd=OPT_REF_DIM.03 색·또는 자유옵션) + BOM link 제거 후 자재행 **del_yn='Y'**(+del_dt). 색×사이즈 복합은 사이즈 부분 §3.2로 분리·색만 옵션. |
| **search-before-mint** | 색 4종+ = 정답 사전 §3 "선택 색 목록→CPQ option"(확정). 자재 합성 아님(과분할 회피). 신규 자재 mint 0. |
| **권위 근거** | 정답 사전 §2.1/§3(선택색 4종+→옵션) · 진단 §2 |
| **채번** | option_items 자연키 — 채번 불요. ref가 가리키는 차원(색)이 선존재해야(트리거 fn_chk_opt_item_ref). |
| **적재경로** | `option_items` 드릴다운 3계층 `pvEdit(prd_cd, options/<grp>/<opt>)`. |
| **FK 위상** | ① option_group(색·택1) + option + 색 차원행 선존재 → ② item 적재 → ③ .09 color 21행 BOM link 제거(GPM-4) → ④ 자재행 **del_yn='Y'**(+del_dt). **트리거 무결성**(ref 차원 선존재 강제). |
| **영향분석** | cp 참조 0. round-6 CPQ 트랙과 정합(색→option). **★컨펌 일부**(색×사이즈 복합 분해 경계는 B-MAT-3 인접). |

### 3.4 print_side 14행 → 인쇄옵션 (`t_prd_product_print_options.print_side`)

| 항목 | 내용 |
|------|------|
| **대상 행** | 단면·양면·양면 가로형·양면 세로형·전면만/배면만 인쇄·양면유광 등 14행(.09) |
| **올바른 의미** | 인쇄면 — 자재 아님. |
| **목적지 t_*** | `t_prd_product_print_options`(print_side 5종 도메인). |
| **search-before-mint** | print_side 칼럼 실재(166행·5종)·기존 그릇 PASS. 신규 0. 단 "양면유광"의 유광은 코팅(공정) 분해 검토. |
| **권위 근거** | 정답 사전 §2.1(인쇄면→print_side) · 진단 §2 · scaffold 인쇄옵션 보드 |
| **채번** | print_options opt_id — 기존 도메인 재사용. 신규 자재 0. |
| **적재경로** | `pvEdit(prd_cd, print_options)` 섹션. |
| **FK 위상** | ① print_option 등록 → ② BOM link 제거(GPM-4) → ③ .09 print_side 14행 자재행 **del_yn='Y'**(+del_dt). |
| **영향분석** | cp 참조 0. OM-5 주의(UV/별색은 print_side 금지·round-13 인용). 즉시 가능분(컨펌 무관). |

### 3.5 count(구수) 4행 + other 1행 → 묶음수 (`t_prd_product_bundle_qtys`)

| 항목 | 내용 |
|------|------|
| **대상 행** | 1구·2구·3구·4구(4) + 2개1팩(MAT_000294, other 1) = 5행(.09) |
| **올바른 의미** | 묶음 단위/구수 — 자재 아님. |
| **목적지 t_*** | `t_prd_product_bundle_qtys`(묶음수) 또는 옵션. other(2개1팩)는 묶음으로 판정보강. |
| **search-before-mint** | bundle_qtys 그릇 실재(라이브). 신규 0. |
| **권위 근거** | 정답 사전 §2.1(구수→묶음수·Q8) · 진단 §2 |
| **채번** | bundle 행 — 기존 그릇. 신규 자재 0. |
| **적재경로** | `pvEdit(prd_cd, bundle_qtys)` 섹션. |
| **FK 위상** | ① bundle 등록 → ② BOM link 제거(GPM-4) → ③ .09 count 4 + other 1 자재행 **del_yn='Y'**(+del_dt). |
| **영향분석** | cp 참조 0. 즉시 가능분(컨펌 무관). |

**.09 소계:** shape 18(②siz+SHAPE) · size 11(②siz/nondim) · color 21(옵션) · print_side 14(print_side) · count 5(bundle) = **69행 전수 축이동.** 즉시 가능 = print_side 14 + count 5 = **19행**(+치수 보유 shape/size 일부). 컨펌/DDL 대기 = 비치수 shape/size·색 복합.

---

## 4. .10 악세사리 43행 — 혼재 명세 (교정 + 축이동 분리)

> 진단 §3 정정: 정답 사전 "43행 전수 오염"을 실측이 정정 — **진짜 부속자재 ~26 + 비소재 오염 ~16.** cp 참조 0. BOM 30(9상품).

### 4.1 진짜 부속자재 ~26행 → mat_typ 교정 (.10→.07) [자재 유지]

| 항목 | 내용 |
|------|------|
| **대상 행** | 봉투 5(OPP접착/비접착·트래싱지/일반/캘린더 카드봉투 197~201) · 볼체인본체/와이어링/천정고리/투명케이스/행택끈/자석고무판 8 · 우드거치대 120mm/우드봉 270~480mm+면끈/우드행거 13 = ~26행 |
| **올바른 의미** | **진짜 부속자재**(Q13 우드거치대=자재·봉투지=자재·와이어링=부속). 자재 유지. 단 mat_typ_cd ".10 악세사리"가 부자재에 어색 — .07 부자재가 적합. |
| **목적지 t_*** | `t_mat_materials` **유지**(축이동 아님). mat_typ_cd만 `.10`→`.07` 교정 검토. |
| **search-before-mint** | 자재 유지·신규 mint 0(기존 행 mat_typ 값만 UPDATE). |
| **권위 근거** | 정답 사전 §2(MAT_TYPE.07 부속·Q13) · 진단 §3(혼재 정정) · §8 판정불가 |
| **채번** | 신규 0(기존 ~26행 mat_typ_cd UPDATE). |
| **적재경로** | `tmatmaterials change`(mat_typ_cd 드롭다운 .10→.07). |
| **FK 위상** | 자재 유지라 BOM 재배선 불요. mat_typ 값만 변경(FK→base_codes .07 선존재). |
| **영향분석** | cp 참조 0. BOM 9상품 무영향(mat_cd 불변·typ만 변경). 단 봉투지는 .14 합판봉투용지 후보도 검토(진단). 롤백=typ 복원. |

> **컨펌 큐 → 부속 typ.** ".10 악세사리"의 진짜 부속을 `.07 부자재`로 통합할지 vs `.10` 유지할지 = 실무진/설계 결정. 봉투지는 `.14 합판봉투용지` 별도 검토. 정답 사전 §2는 .10=오라벨이나 부속은 자재 → 통합 여부 컨펌.

### 4.2 볼체인 색 8행 → CPQ 옵션 (색)

| 항목 | 내용 |
|------|------|
| **대상 행** | 볼체인 오렌지/핑크/핫핑크/민트/블루/바이올렛/블랙/화이트 (3개1팩) MAT_000202~209 |
| **올바른 의미** | 선택색 variant(8종) — CPQ option. |
| **목적지 t_*** | `t_prd_product_option_items`(색) + BOM link 제거 후 자재행 **del_yn='Y'**(+del_dt). |
| **search-before-mint** | 정답 사전 §3 "선택 색 목록 4종+→옵션"(확정·8종). 신규 자재 0. |
| **권위 근거** | 정답 사전 §3 · 진단 §3 · round-6 CPQ 색→option |
| **채번** | option_items 자연키. ref 차원 선존재. |
| **적재경로** | `option_items` 드릴다운 `pvEdit(prd_cd, options/<grp>/<opt>)`. |
| **FK 위상** | ① option_group/option + 색 차원 → ② item → ③ MAT_000202~209 BOM link 제거(GPM-4) → ④ 자재행 **del_yn='Y'**(+del_dt). |
| **영향분석** | cp 참조 0. 본체 볼체인 자재(§4.1 부속)와 분리(색만 옵션·본체는 .07 자재). |

### 4.3 만년스탬프 잉크색 8행 → ③ 도수 / 별색 / 자유옵션 (컨펌 AX-1)

| 항목 | 내용 |
|------|------|
| **대상 행** | 리필잉크 청보라/빨강/검정/파랑/초록/핑크/노랑 (5cc) MAT_000232~239 |
| **올바른 의미** | 잉크색 — **절대 자재 아님**(정답 사전 §3). 도수 vs 별색공정 vs 자유옵션 미확정. |
| **목적지 t_*** | **컨펌 분기(AX-1)** — ⓐ `t_clr_color_counts`(도수·단 도수=CMYK 채널 SEED 5폐쇄·잉크색 ≠ 채널수 → 부적합 가능) / ⓑ 별색 공정 `t_proc_processes`(PROC_000007 family) / ⓒ 자유옵션 `option_items`. |
| **현 판정** | 도수 SEED는 채널수(0~4)라 잉크색 7종 부적합. **별색 공정 또는 자유옵션이 유력**(설계 판단)이나 사용자 결정 필요. |
| **권위 근거** | 정답 사전 §2.1/§3(잉크색 AX-1) · 진단 §3 · scaffold ③도수 보드(잉크색=도수인지 컨펌) |
| **채번** | 분기 따라 — 별색공정 proc=`PROC_NNNNNN` / 옵션 자연키. |
| **적재경로** | ⓑ 공정=`pvEdit(prd_cd, processes)` · ⓒ 옵션=`option_items` 드릴다운. |
| **FK 위상** | 목적지 확정 후 — ① 목적지 행 선적재 → ② BOM link 7건 제거/재배선(233 헤더 0·GPM-4) → ③ MAT_000232~239 자재행 **del_yn='Y'**(+del_dt). |
| **영향분석** | cp 참조 0. round-22 ③도수축 "④잉크색 유입 목적지" 인용. |

> **컨펌 큐 → AX-1.** 잉크색 귀속(도수/별색/옵션) 사용자 결정 후 목적지 확정.

**.10 소계:** 진짜 부속 ~26(mat_typ 교정·자재 유지·컨펌) + 볼체인색 8(옵션) + 잉크색 8(AX-1 컨펌) = 42(+헤더 placeholder 1). 즉시 가능 = 0(전부 컨펌). 

---

## 5. 추가 오염 — 자재명 공정 흡수 · 두께 평면화 (인용·다음 회차)

> 진단 §5: .08/.09/.10 외(종이축·아크릴축). 본 1순위는 인용만(실측 다음 회차).

| 항목 | 정답 | 목적지 | 라우팅 | 컨펌 |
|------|------|--------|--------|------|
| `아트250+무광코팅` 등 자재명에 코팅 흡수 | 자재(아트250)+⑤공정(무광 PROC_000015) 분해·자재명 정정 | `t_mat_materials`(자재명) + `t_proc_processes`(공정) | 교정+축이동(→⑤) | — (정답 확정·실 분해는 ⑤ 공정 회차) |
| 아크릴 두께 평면화(22상품→MAT_000192 단일) | 1.5/3/8mm = MAT_000042/043/044 별 mat_cd | `t_mat_materials`(두께별 행) | 교정(분리·신규 두께행) | **AC-2**(교정방향 확정·실행 컨펌) |

> **AC-2 컨펌 큐.** 아크릴 두께 분리 교정방향은 확정(OM-4·두께=자재 식별자)이나 실행은 라이브 .03 아크릴 22상품 재실측 후(다음 회차). 두께값 슬롯=기존 mat_cd 분리(CLEAR3T 동형·vessel V-3 §10.1).

---

## 6. 신규 등록 (보류) — GAP-MAT-3 신소재 코드행

| 항목 | 내용 |
|------|------|
| **대상** | 우드/코르크/규조토/벨벳/세라믹 MAT_TYPE 코드 또는 자재 행(GAP-MAT-3) |
| **search-before-mint** | 정답 사전 §6·진단 §6: **.05 특수소재 흡수 우선·mint 0 권장.** 신규 MAT_TYPE 코드행은 .05로 흡수 가능하면 불요. |
| **판정** | **보류** — 신소재 자재 *행*은 .05 mat_typ로 등록(코드행 mint 0). 별도 신소재 MAT_TYPE 코드는 후니 상품군이 별 분류·가격 분기 필요해질 때만(YAGNI). 설계가 결정 = .05 흡수. |
| **라우팅** | 신규 자재 행 등록은 굿즈/파우치 본체 BOM 회차(round-22 GPM 신규 mint ~25 BLOCKED)와 정합. 코드행 신규 = 0. |

> **신규 그릇 정당성:** rpmeta vessel-gap 3건(V-10/11/12)만 신규 테이블 정당. 자재 축 신규 테이블 = V-12 형상축(shape-axis·기존 junction 재사용으로 테이블 0) + goods-pouch-nondim-size(비치수 size 마스터·data-gap 입증). MAT_TYPE 코드행 신규 = 0(.05 흡수). **자재 오염은 대부분 축이동/교정 — 신규 그릇 아님.**

---

## 7. 자재 등록 명세 집계

| 라우팅 | 대상 | 행수 | 신규 mint | 즉시/컨펌 | 적재경로 |
|--------|------|:--:|:--:|------|----------|
| 축이동 ④→②siz+SHAPE | .09 shape 18 + size 11 | 29 | siz 일부·SHAPE 코드6·nondim 마스터(DDL) | 치수보유 즉시·비치수 DDL | pvEdit(sizes)+tcodbasecodes |
| 축이동 ④→옵션(색) | .08 색 5 + .09 color 21 + .10 볼체인색 8 | 34 | 0(자재 del_yn='Y') | 색 4종+ 즉시·.08 경계 컨펌 | option_items 드릴다운 |
| 축이동 ④→print_side | .09 print_side 14 | 14 | 0 | **즉시** | pvEdit(print_options) |
| 축이동 ④→bundle | .09 count 4 + other 1 | 5 | 0 | **즉시** | pvEdit(bundle_qtys) |
| 축이동 ④→③/별색/옵션 | .10 잉크색 8 | 8 | 분기 | 컨펌 AX-1 | pvEdit(processes/options) |
| **★BOM link 제거(GPM-4)** | 오염 .08/.09/.10 link | **177** | — | 본체 .05/.06 선적재 후·축이동 후 | product_materials link 정리(pvEdit materials) |
| **★오염 자재행 소프트삭제** | .08/.09/.10 비소재행 | (축이동분) | — | **del_yn='Y'(+del_dt)** 마지막 | tmatmaterials change(logical_delete) |
| 교정 mat_typ .10→.07 | .10 진짜 부속 | ~26 | 0(UPDATE) | 컨펌(부속 typ) | tmatmaterials change |
| 교정 두께 분리 | 아크릴 22상품 | (22) | 두께별 mat_cd | 컨펌 AC-2 | tmatmaterials change |
| 신규 코드행 | MAT_TYPE·MAT_FACET·신소재 | **0** | 0 | 보류 | — |

**즉시 등록명세 가능분(컨펌 무관·재배선 순서 준수):** print_side 14 + bundle 5 + 색 4종+ 다수(.09 color 21·.10 볼체인색 8) + 치수보유 shape/size = **약 48행**(routing-summary §5 정합). **컨펌 대기:** .08 색 5(B-MAT-3)·잉크색 8(AX-1)·부속 typ ~26·AC-2.

> **★삭제 라우팅 권위 정정(2026-06-18·B5 blind-spot):** 위 모든 축이동의 "오염행 떼어냄" = **BOM link 제거(GPM-4) → del_yn='Y'(+del_dt) 마지막**(use_yn='N' 아님). del_yn = 조회/BOM/가격 선택지 차단 권위(§0). **진짜 미완 = BOM link 177건 제거** — 소프트삭제만으로는 기존 BOM/그리드 셀의 mat_cd 런타임 참조 잔존. 라이브 del_yn='Y'는 임시책(load_master TRUNCATE 재적재 시 휘발) → 근본 = 경로 Y(v03 오염행 제거·개발자 재적재).

---

## 8. dbmap 위임 / 인간 승인 큐

- **실 적재 위임:** 축이동·교정 실행 = `dbm-axis-staged-load`(경로 Y 교정 엑셀 재적재 우선) 또는 `dbm-load-execution`(라이브 멱등 UPSERT). 본 명세는 등록 단위·FK 위상·적재경로까지.
- **DDL 위임:** SHAPE 형상 컬럼(shape-axis DDL)·비치수 size 마스터(goods-pouch-nondim-size DDL)·MAT_FACET 컬럼(채택 시) = `dbm-ddl-proposer` 기제안 재사용·인간 승인.
- **재진단 금지(인용):** round-22 ⑥ 카테고리 COMMIT·레더 .06·GPM-1/2 본체자재 41행 설계 GO.
