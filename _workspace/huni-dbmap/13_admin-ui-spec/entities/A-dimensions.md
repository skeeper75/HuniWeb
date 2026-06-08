# A군 — 차원/구조 엔티티 admin UI 데이터 입력 명세

> round-8 산출물. 목적: admin product-viewer + catalog 화면의 **모든 항목**에 "어떤 값을 넣어야 하는가"를
> 컬럼 단위로 정의하여, round-7에서 미적재로 남은 차원/구조 데이터를 사람이 직접 admin에 입력할 수 있게 한다.
> A군 범위 = product-viewer 상품별 하위 차원 8엔티티 + catalog 마스터 4엔티티 = **12엔티티**.
>
> 권위: 컬럼 스펙 = `docs/huni/table-spec_260608.html`(라이브 컬럼 실측으로 교차확인) · 입력 위젯 =
> `_raw/forms/<model>.json`(catalog change form) · 표시구조 = `_raw/PRD_000016_text.txt`(엽서)·`PRD_000138_text.txt`(현수막) ·
> 코드값 도메인 = 라이브 `t_cod_base_codes`(읽기전용 실측) · 미적재 갭 = `12_coverage/gap-board.md`.
>
> **HARD**: 모든 필드는 table-spec 컬럼 또는 라이브 DB 실측을 인용. 추측 금지. 명세 전용(실 적재는 인간 승인).

## 0. 화면 모델 — 두 종류의 입력 화면

A군 엔티티는 두 화면 중 하나로 입력한다.

| 화면 종류 | 대상 엔티티 | 입력 방식 | 위젯 권위 |
|-----------|------------|----------|-----------|
| **catalog change form** (마스터 단독 등록) | t_mat_materials, t_siz_sizes, t_clr_color_counts, t_proc_processes | Django admin add/change 폼. `_raw/forms/<model>.json` 에 컬럼별 위젯·필수·select 선택지 dump 존재. | forms json (실측) |
| **product-viewer 섹션 pvEdit** (상품에 차원 연결) | t_prd_product_sizes, t_prd_product_materials, t_prd_product_print_options, t_prd_product_processes, t_prd_product_plate_sizes, t_prd_product_bundle_qtys, t_prd_product_page_rules, t_prd_product_sets | product-viewer 상품 상세의 각 섹션 "편집" 버튼 → pvEdit() 팝업 폼. 팝업은 headless 렌더 불가 → 입력 필드는 **table-spec 컬럼 + 섹션 표시컬럼**에서 도출. | table-spec + PRD_000016/138 표시구조 |

> **공통 시스템 컬럼 처리 규칙**: `reg_dt`(등록일시, NOT NULL)·`upd_dt`(수정일시)·`del_yn`(삭제여부)·`del_dt`(삭제일시)는
> 모든 테이블에 존재하나 **사람이 입력하는 항목이 아니다**. admin 저장 시 자동 세팅(reg_dt=now, del_yn='N')된다.
> round-5 메모리의 "reg_dt NOT NULL DEFAULT 함정"에 따라 명시 NULL 금지 — admin이 자동 채운다. 아래 표에서는
> 누락 점검을 위해 행으로 포함하되 "위젯=자동/시스템"으로 표기한다.

---

## A-1. t_mat_materials — 자재정보 (catalog change form)

**입력 화면**: catalog `tmatmaterials` change form (`_raw/forms/tmatmaterials.json` 실측).
**FK 선행 등록**: `mat_typ_cd`(→t_cod_base_codes MAT_TYPE), `sel_typ_cd`(→SEL_TYPE), `upr_mat_cd`(→자기참조: 상위 자재행이 먼저 존재해야 함).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 자재코드 | mat_cd | input/text | (자동/PK) | varchar(50) PK NOT NULL | — | 신규 채번. 빈칸 두면 시스템 채번(MAT_000xxx 패턴). search-before-mint: 기존 자재 재사용 우선 | catalog form |
| 자재명 | mat_nm | input/text | **Y** | varchar(200) NOT NULL | — | 자재 표시명 입력(예: "현수막천", "각목") | catalog form |
| 자재유형코드 | mat_typ_cd | select/select-one | **Y** | varchar(50) NOT NULL FK→t_cod_base_codes | MAT_TYPE.01 종이·.02 필름·.03 아크릴·.04 금속·.05 원단·.06 가죽·.07 부속·.08 실사소재·.09 파우치·.10 악세사리·.11 스티커 | 드롭다운 선택. 실사 자재=실사소재(.08)·원단=.05·부속=.07 | catalog form |
| 상위자재코드 | upr_mat_cd | select/select-one | N | varchar(50) FK→t_mat_materials(자기참조) | (자재 마스터 행 목록) | 상위 자재가 있을 때만. 없으면 "Select value" 유지 | catalog form |
| 선택유형코드 | sel_typ_cd | select/select-one | N | varchar(50) FK→t_cod_base_codes | SEL_TYPE.01 단일·.02 다중 | 자재가 옵션택일이면 단일, 다중선택이면 다중 | catalog form |
| 최대선택수 | max_sel_cnt | input/number | N | integer | — | sel_typ=다중일 때 최대 개수 | catalog form |
| 가로 | width | input/number | N | numeric(8,2) | — | 규격 자재(파우치/악세사리)의 물리 가로. 비치수 자재는 공란 | catalog form |
| 세로 | height | input/number | N | numeric(8,2) | — | 물리 세로 | catalog form |
| 높이/두께 | depth | input/number | N | numeric(8,2) | — | 입체/원단 자재 두께 | catalog form |
| 무게 | weight | input/number | N | numeric(8,2) | — | 자재 무게 | catalog form |
| 묶음수 | bdl_qty | input/number | N | integer | — | 자재 단위 묶음수 | catalog form |
| 사용여부 | use_yn | select/select-one | N | char(1) NOT NULL | Y / N (폼 고정선택지) | 신규는 Y | catalog form |
| 비고 | note | input/text | N | varchar(500) | — | 자유 메모 | catalog form |
| 삭제여부 | del_yn | select(자동) | (시스템) | char(1) NOT NULL | Y / N | 입력 안 함 — 신규=N 자동 | catalog form |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | 저장 시 now() 자동 | catalog form |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 수정 시 자동 | catalog form |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 삭제 시 자동 | catalog form |

> **round-7 미적재 갭 연결**:
> - 실사 materials 🟡 23/28 (5 미적재, 차단유형 MAT-MINT) — gap-board §4 인용: "실사 materials 🟡 23/28 | 5 | MAT-MINT". round-6 silsa v2가 큐방/각목/봉제사를 mint 대상으로 식별. **채우는 법**: 위 폼에서 mat_nm(예: "각목")·mat_typ_cd=실사소재(.08) 또는 원단(.05)·use_yn=Y 입력 후 저장 → MAT_000xxx 채번 → 이후 A-2 product_materials 로 상품에 연결.
> - 굿즈파우치/상품악세사리 materials 는 DB-ONLY(EXT-LOAD, gap-board §6) — 본체 자재가 이미 존재. master '소재' 컬럼 부재로 권위 대조 후 분류. 신규 입력보다 **기존 행 재사용** 우선.

---

## A-2. t_siz_sizes — 사이즈정보 (catalog change form)

**입력 화면**: catalog `tsizsizes` change form (`_raw/forms/tsizsizes.json` 실측).
**FK 선행 등록**: 없음(마스터, FK 없음).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 사이즈코드 | siz_cd | input/text | (자동/PK) | varchar(50) PK NOT NULL | — | 신규 채번(SIZ_000xxx). search-before-mint: 기존 동일 규격(예: 원형35mm=SIZ_000422) 재사용 | catalog form |
| 사이즈명 | siz_nm | input/text | **Y** | varchar(50) NOT NULL | — | 규격 표시명(예: "5000x900", "148x210") | catalog form |
| 작업가로 | work_width | input/number | N | numeric(8,2) | — | 작업 사이즈 가로(mm) | catalog form |
| 작업세로 | work_height | input/number | N | numeric(8,2) | — | 작업 사이즈 세로(mm) | catalog form |
| 재단가로 | cut_width | input/number | N | numeric(8,2) | — | 재단 후 가로 | catalog form |
| 재단세로 | cut_height | input/number | N | numeric(8,2) | — | 재단 후 세로 | catalog form |
| 여백상 | margin_top | input/number | N | numeric(8,2) | — | 상단 여백 | catalog form |
| 여백하 | margin_bot | input/number | N | numeric(8,2) | — | 하단 여백 | catalog form |
| 여백좌 | margin_lft | input/number | N | numeric(8,2) | — | 좌측 여백 | catalog form |
| 여백우 | margin_rgt | input/number | N | numeric(8,2) | — | 우측 여백 | catalog form |
| 조판판형여부 | impos_yn | select/select-one | N(table-spec NOT NULL) | char(1) NOT NULL | Y / N (폼 고정선택지) | 출력 판형(전지 임포지션) 행이면 Y, 작업사이즈 행이면 N. [[dbmap-platesize-is-output-paper]] | catalog form |
| 사용여부 | use_yn | select/select-one | N | char(1) NOT NULL | Y / N | 신규 Y | catalog form |
| 비고 | note | input/text | N | varchar(500) | — | 판형/원지 메모 | catalog form |
| 삭제여부 | del_yn | select(자동) | (시스템) | char(1) NOT NULL | Y / N | 자동 N | catalog form |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | catalog form |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | catalog form |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | catalog form |

> **round-7 미적재 갭 연결** (siz 는 SIZ-REG·DOMAIN-UNDECIDED 차단의 핵심):
> - 굿즈파우치 sizes 🟡 11/98 (**87 미적재** — 최대 단일 PARTIAL, gap-board §4 인용: "굿즈파우치 sizes 🟡 11/98 | 87 | DOMAIN-UNDECIDED(기성품 비치수?)"). admin 실측 PRD_000193 머그컵 사이즈 0. **차단 사유**: "기성품 사이즈는 차원행인가 텍스트 표기인가" 도메인 결정 필요 → 발명 금지, 사용자 [CONFIRM] 후 입력. 결정이 "차원행"이면 위 폼에서 siz_nm(머그컵 규격)·작업 치수 입력 후 A-1형 siz 마스터 등록 → A-7(plate)아닌 product_sizes 로 상품 연결.
> - 아크릴 sizes 🟡 23/25 (2 SIZ-REG)·디지털인쇄 sizes 🟡 33/36 (3) — gap-board §4. 누락 규격을 위 폼으로 mint(search-before-mint 후) → product_sizes 연결.
> - 실사 가격용 출력판형 다수 미등록(76 규격, [[dbmap-output-plate-mapping]]) — impos_yn=Y·OUTPUT_PAPER_TYPE 계열로 등록(A-7 plate 와 짝).

---

## A-3. t_clr_color_counts — 도수정보 (catalog change form)

**입력 화면**: catalog `tclrcolorcounts` change form (`_raw/forms/tclrcolorcounts.json` 실측).
**FK 선행 등록**: 없음(마스터).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 도수코드 | clr_cd | input/text | (자동/PK) | varchar(50) PK NOT NULL | — | 신규 채번. 기존 도수(CMYK 4도 등) 재사용 우선 | catalog form |
| 도수명 | clr_nm | input/text | **Y** | varchar(100) NOT NULL | — | 표시명(예: "CMYK 4도", "인쇄 안 함") | catalog form |
| 채널수 | chnl_cnt | input/number | **Y** | integer NOT NULL | — | 잉크 채널수(4도=4, 단면 인쇄안함=0) | catalog form |
| 사용여부 | use_yn | select/select-one | N | char(1) NOT NULL | Y / N | 신규 Y | catalog form |
| 비고 | note | input/text | N | varchar(500) | — | 메모 | catalog form |
| 삭제여부 | del_yn | select(자동) | (시스템) | char(1) NOT NULL | Y / N | 자동 N | catalog form |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | catalog form |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | catalog form |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | catalog form |

> **round-7 미적재 갭 연결**: 도수 마스터 자체는 갭 보드에 단독 미적재 없음. print_options(A-4) 미적재(디지털인쇄 32/36·문구 7/11·아크릴 21/25, gap-board §4)는 도수 **마스터가 아니라 상품-도수 연결** 부족. 신규 도수명이 필요할 때만 여기서 등록(예: 별색 화이트/클리어는 도수가 아닌 공정으로 처리 — clr_cd=NULL [[dbmap-digitalprint-atomic-formula-unbuilt.md]]).

---

## A-4. t_proc_processes — 공정정보 (catalog change form)

**입력 화면**: catalog `tprocprocesses` change form (`_raw/forms/tprocprocesses.json` 실측).
**FK 선행 등록**: `upr_proc_cd`(→t_proc_processes 자기참조: 상위 공정행이 먼저 존재).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 공정코드 | proc_cd | input/text | (자동/PK) | varchar(50) PK NOT NULL | — | 신규 채번(PROC_000xxx). 기존 공정 재사용 우선 | catalog form |
| 공정명 | proc_nm | input/text | **Y** | varchar(200) NOT NULL | — | 표시명(예: "타공", "부착", "봉제", "열재단") | catalog form |
| 상위공정코드 | upr_proc_cd | select/select-one | N | varchar(50) FK→t_proc_processes(자기참조) | 폼 실측 선택지 샘플: 귀돌이·박·별색인쇄·인쇄·접지 (전체는 공정 마스터 목록) | 하위 공정이면 상위 공정 선택. 최상위면 "Select value" | catalog form |
| 공정상세옵션 | prcs_dtl_opt | textarea/textarea | N | jsonb | — | JSON 상세옵션(예: 타공 구멍수). 없으면 공란 | catalog form |
| 표시순서 | disp_seq | input/number | N | integer | — | 정렬 순서 | catalog form |
| 사용여부 | use_yn | select/select-one | N | char(1) NOT NULL | Y / N | 신규 Y | catalog form |
| 비고 | note | input/text | N | varchar(500) | — | 메모 | catalog form |
| 삭제여부 | del_yn | select(자동) | (시스템) | char(1) NOT NULL | Y / N | 자동 N | catalog form |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | catalog form |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | catalog form |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | catalog form |

> **round-7 미적재 갭 연결**: 공정 마스터 신규 채번은 CODE-ROW 차단(코드행 선적재, 인간 승인). gap-board: PROC_000084 placeholder 의도적 제외(메모리). 실사 processes 🟡 17/28·아크릴 14/25·굿즈파우치 6/98 미적재(gap-board §4)는 대부분 **상품-공정 연결**(A-5) 부족이나, 신규 공정명(열재단·말아박기·오버로크)은 여기서 먼저 mint → A-5 로 상품 연결. 순수 공정(타공 bare-hole·열재단)은 자재 없이 공정만([[dbmap-option-material-process-bundle]]).

---

## A-5. t_prd_product_sizes — 상품별사이즈 (product-viewer "사이즈" 섹션)

**입력 화면**: product-viewer 상품 상세 → **사이즈** 섹션 "편집" → pvEdit 팝업.
**표시구조**(PRD_000016 엽서 §사이즈(7) 인용): 헤더 = `사이즈코드 | 기본여부 | 표시순서`, 행 예 `73x98 | Y | 1`.
**FK 선행 등록**: `siz_cd`(→t_siz_sizes: A-2에서 해당 규격이 먼저 등록돼 있어야 선택 가능), `prd_cd`(상품 자체).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 상품 상세 컨텍스트로 자동 세팅 | pvEdit |
| 사이즈코드 | siz_cd | select(siz 마스터) | **Y/PK** | varchar(50) PK NOT NULL FK→t_siz_sizes | (t_siz_sizes 행 목록) | A-2에 등록된 규격을 드롭다운 선택. 미등록이면 A-2 선행 | pvEdit |
| 기본여부 | dflt_yn | select Y/N | **Y** | char(1) NOT NULL | Y / N | 기본 선택 규격 1건만 Y | pvEdit |
| 표시순서 | disp_seq | input/number | N | integer | — | 노출 정렬 순서 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **round-7 미적재 갭 연결**: 굿즈파우치 87·아크릴 2·디지털인쇄 3 사이즈 미적재(gap-board §4). 절차 = ① A-2에서 누락 규격을 siz 마스터로 등록(또는 기존 재사용) → ② 이 섹션에서 해당 siz_cd 추가·dflt_yn 지정. 굿즈파우치는 DOMAIN-UNDECIDED([CONFIRM]) 해소가 선행.

---

## A-6. t_prd_product_materials — 상품별자재 (product-viewer "자재" 섹션)

**입력 화면**: product-viewer 상품 상세 → **자재** 섹션 "편집" → pvEdit 팝업.
**표시구조**(PRD_000016 §자재(21) 인용): 헤더 = `자재코드 | 용도 | 종속공정코드 | 기본여부 | 표시순서`, 행 예 `백색모조지 220g | 공통 | (공정) | Y | 1`.
**FK 선행 등록**: `mat_cd`(→A-1 자재 마스터), `usage_cd`(→t_cod_base_codes USAGE), `dep_proc_cd`(→A-4 공정 마스터, 선택).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅 | pvEdit |
| 자재코드 | mat_cd | select(자재 마스터) | **Y/PK** | varchar(50) PK NOT NULL FK→t_mat_materials | (t_mat_materials 행) | A-1에 등록된 자재 선택. 미등록이면 A-1 선행 | pvEdit |
| 용도 | usage_cd | select(USAGE) | **Y/PK** | varchar(50) PK NOT NULL FK→t_cod_base_codes | USAGE.01 내지·.02 표지·.03 면지·.04 간지·.05 투명커버·.06 표지타입·.07 공통 (라이브 사용=01/02/03/05/07) | 단순 상품=공통(.07). 책자=내지/표지 구분 | pvEdit |
| 종속공정코드 | dep_proc_cd | select(공정 마스터) | N | varchar(50) FK→t_proc_processes | (t_proc_processes 행) | 자재가 특정 공정에 종속될 때만(예: 봉제사→봉제). 없으면 공란 | pvEdit |
| 기본여부 | dflt_yn | select Y/N | **Y** | char(1) NOT NULL | Y / N | 기본 자재 1건 Y | pvEdit |
| 표시순서 | disp_seq | input/number | N | integer | — | 정렬 순서 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **PK 주의**: PK = (prd_cd, mat_cd, **usage_cd**). 같은 자재를 다른 용도로 2회 연결 가능. 동일 (prd,mat,usage) 중복 입력 시 충돌.
> **round-7 미적재 갭 연결**: 실사 materials 5 미적재(MAT-MINT) — A-1에서 각목/큐방/봉제사 mint 후 이 섹션에서 usage_cd(공통 또는 자재의미)·dep_proc_cd(봉제사→봉제 공정) 연결. round-6 silsa v2 "옵션=자재+공정 BUNDLE"([[dbmap-option-material-process-bundle]]) — 자재(.03)는 여기서, 공정(.04)은 A-7 처리.

---

## A-7. t_prd_product_print_options — 상품별인쇄옵션 (product-viewer "도수/인쇄옵션" 섹션)

**입력 화면**: product-viewer 상품 상세 → **도수 / 인쇄옵션** 섹션 "편집" → pvEdit 팝업.
**표시구조**(PRD_000016 §도수/인쇄옵션(2) 인용): 헤더 = `옵션ID | 인쇄면 | 앞면도수코드 | 뒷면도수코드 | 기본여부 | 표시순서`, 행 예 `1 | 단면 | CMYK 4도 | 인쇄 안 함 | Y | 1`.
**FK 선행 등록**: `front_colrcnt_cd`·`back_colrcnt_cd`(→A-3 도수 마스터).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅 | pvEdit |
| 옵션ID | opt_id | input/number | **Y/PK** | integer PK NOT NULL | — | 상품 내 1부터 순번. 같은 상품 내 유일 | pvEdit |
| 인쇄면 | print_side | input/select | **Y** | varchar(20) NOT NULL | (표시값: 단면 / 양면 — 라이브 실측 라벨) | 단면/양면 입력 | pvEdit |
| 앞면도수코드 | front_colrcnt_cd | select(도수 마스터) | **Y** | varchar(50) NOT NULL FK→t_clr_color_counts | (t_clr_color_counts 행: CMYK 4도·인쇄 안 함 등) | 앞면 도수 선택 | pvEdit |
| 뒷면도수코드 | back_colrcnt_cd | select(도수 마스터) | **Y** | varchar(50) NOT NULL FK→t_clr_color_counts | (동일) | 단면이면 "인쇄 안 함" 도수 선택(NOT NULL이므로 0도 도수행 필요) | pvEdit |
| 기본여부 | dflt_yn | select Y/N | **Y** | char(1) NOT NULL | Y / N | 기본 옵션 1건 Y | pvEdit |
| 표시순서 | disp_seq | input/number | N | integer | — | 정렬 순서 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **back_colrcnt_cd NOT NULL 주의**: 단면 인쇄도 뒷면 도수가 NOT NULL → "인쇄 안 함"(chnl_cnt=0) 도수행을 A-3에 등록해 선택해야 한다(엽서 1단면 예가 back="인쇄 안 함").
> **round-7 미적재 갭 연결**: 디지털인쇄 32/36·문구 7/11·아크릴 21/25 print_options 미적재(gap-board §4, MAPPING-DEFECT). 별색(화이트/클리어)은 도수가 아닌 공정([[dbmap-digitalprint-atomic-formula-unbuilt]] clr_cd=NULL) — 여기 입력 금지, A-8 공정으로.

---

## A-8. t_prd_product_processes — 상품별공정 (product-viewer "공정" 섹션)

**입력 화면**: product-viewer 상품 상세 → **공정** 섹션 "편집" → pvEdit 팝업.
**표시구조**(PRD_000016 §공정(6) 인용): 헤더 = `공정코드 | 필수공정여부 | 표시순서`, 행 예 `직각 | N | 1`.
**FK 선행 등록**: `proc_cd`(→A-4 공정 마스터).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅 | pvEdit |
| 공정코드 | proc_cd | select(공정 마스터) | **Y/PK** | varchar(50) PK NOT NULL FK→t_proc_processes | (t_proc_processes 행) | A-4에 등록된 공정 선택. 미등록이면 A-4 선행 | pvEdit |
| 필수공정여부 | mand_proc_yn | select Y/N | **Y** | char(1) NOT NULL | Y / N | 필수 공정이면 Y, 선택 공정이면 N | pvEdit |
| 표시순서 | disp_seq | input/number | N | integer | — | 정렬 순서 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **round-7 미적재 갭 연결**: 실사 17/28·아크릴 14/25·굿즈파우치 6/98·문구 9/11 processes 미적재(gap-board §4, MAPPING-DEFECT). 절차 = A-4에서 공정 mint(타공/부착/봉제/열재단) → 이 섹션에서 proc_cd 추가·mand_proc_yn 지정. round-6 일반현수막(PRD_000138)이 타공/부착/봉제 3공정을 이렇게 표시(N|N|N).

---

## A-9. t_prd_product_plate_sizes — 상품별판형사이즈 (product-viewer "판형" 섹션)

**입력 화면**: product-viewer 상품 상세 → **판형** 섹션 "편집" → pvEdit 팝업.
**표시구조**(PRD_000016 §판형(1) 인용): 헤더 = `사이즈코드 | 출력파일유형 | 출력용지유형코드 | 기본판형여부`, 행 예 `316x467 | 국전계열 | N`(엽서)·`5000x900 | JPG | Y`(현수막 PRD_000138).
**FK 선행 등록**: `siz_cd`(→A-2 siz 마스터, **출력용지 규격**), `output_paper_typ_cd`(→t_cod_base_codes OUTPUT_PAPER_TYPE).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅 | pvEdit |
| 사이즈코드 | siz_cd | select(siz 마스터) | **Y/PK** | varchar(50) PK NOT NULL FK→t_siz_sizes | (t_siz_sizes 행, impos_yn=Y 출력판형) | 출력용지 규격(전지) 선택. [[dbmap-platesize-is-output-paper]] | pvEdit |
| 기본판형여부 | dflt_plt_yn | select Y/N | **Y** | char(1) NOT NULL | Y / N | 기본 판형 1건 Y | pvEdit |
| 출력용지유형코드 | output_paper_typ_cd | select(OUTPUT_PAPER_TYPE) | N | varchar(50) FK→t_cod_base_codes | OUTPUT_PAPER_TYPE.01 국전계열·.02 46계열·.03 기타 | 용지 계열 선택. 권위=master '출력용지규격' [[dbmap-platesize-is-output-paper]] | pvEdit |
| 출력파일유형 | output_file_typ | input/text | N | varchar(30) | (표시값: 국전계열·JPG 등 자유) | 파일 유형(예: JPG, PDF). 현수막=JPG | pvEdit |
| 비고 | note | input/text | N | varchar(500) | — | 메모 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **GAP 주의**: 엽서 표시행 `316x467 | 국전계열 | N`은 컬럼 4개(사이즈·출력파일유형·출력용지유형·기본판형)인데 표시상 출력파일유형 값이 비어 보임 — 라이브 행은 output_file_typ 공란 가능(N). 표시구조와 컬럼 매핑은 일치(siz_cd=316x467, output_paper_typ_cd=국전계열, dflt_plt_yn=N).
> **round-7 미적재 갭 연결**: plate_sizes 는 DB-ONLY/EXT-LOAD(gap-board §6) — 가격표 판걸이수 권위로 이미 다수 적재(국4절 32상품 완료, [[dbmap-platesize-is-output-paper]]). 미등록 출력판형은 A-2에서 impos_yn=Y siz 등록 후 이 섹션 연결.

---

## A-10. t_prd_product_bundle_qtys — 상품별묶음수 (product-viewer "묶음수" 섹션)

**입력 화면**: product-viewer 상품 상세 → **묶음수** 섹션 "편집" → pvEdit 팝업. (PRD_000016·138 모두 0건 → "없음" 표시)
**FK 선행 등록**: `bdl_unit_typ_cd`(→t_cod_base_codes QTY_UNIT).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅 | pvEdit |
| 묶음수 | bdl_qty | input/number | **Y/PK** | integer PK NOT NULL | — | 묶음 수량(예: 50, 100). 상품 내 유일 | pvEdit |
| 묶음단위유형코드 | bdl_unit_typ_cd | select(QTY_UNIT) | N | varchar(50) FK→t_cod_base_codes | QTY_UNIT.01 EA·.02 매·.03 권·.04 세트 | 단위 선택 | pvEdit |
| 기본여부 | dflt_yn | select Y/N | **Y** | char(1) NOT NULL | Y / N | 기본 묶음 1건 Y | pvEdit |
| 표시순서 | disp_seq | input/number | N | integer | — | 정렬 순서 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **round-7 미적재 갭 연결**: 캘린더 bundle_qtys ❌ MISSING(gap-board §5, 증거=master '개별포장(옵션)'). 절차 = 이 섹션에서 bdl_qty·bdl_unit_typ_cd(EA/세트) 입력. sticker/acrylic/goods-pouch bundle_qtys 는 DB-ONLY(OVER-LOAD? gap-board §6) — 신규 입력 전 round-1 잔재 여부 확인.

---

## A-11. t_prd_product_page_rules — 상품별페이지룰 (product-viewer "페이지룰" 섹션)

**입력 화면**: product-viewer 상품 상세 → **페이지룰** 섹션 "편집" → pvEdit 팝업. (catalog form `tprdproductpagerules.json` 도 존재 — 단독 등록 가능.)
**라이브 컬럼 실측**: prd_cd·page_min·page_max·page_incr·note·reg_dt·upd_dt (**del_yn/del_dt 없음** — 라이브 7컬럼 확인. table-spec 도 reg_dt 까지만 표시. PK=prd_cd 단일).
**FK 선행 등록**: `prd_cd` 만(다른 FK 없음).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec/라이브) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅. 상품당 1행(PK 단일) | pvEdit / catalog form |
| 페이지최소 | page_min | input/number | **Y** | integer NOT NULL | — | 최소 페이지수(예: 24) | pvEdit |
| 페이지최대 | page_max | input/number | **Y** | integer NOT NULL | — | 최대 페이지수 | pvEdit |
| 페이지증가단위 | page_incr | input/number | **Y** | integer NOT NULL | — | 증가 단위(예: 2P당) | pvEdit |
| 비고 | note | input/text | N | varchar(500) | — | 메모 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **컬럼 수 주의**: page_rules 는 다른 product-viewer 테이블과 달리 **del_yn/del_dt·disp_seq 없음**(라이브 실측 7컬럼). table-spec 도 동일. 누락 점검 시 7컬럼 기준.
> **round-7 미적재 갭 연결**: 캘린더/디자인캘린더 page_rules ❌ MISSING(gap-board §5, 증거=master '장수(필수)'·'페이지사양'). 책자/문구 page_rules 부분(§4). 절차 = 이 섹션에서 page_min/max/incr 입력(책자=24~ +2P단위).

---

## A-12. t_prd_product_sets — 상품셋트정보 (product-viewer "추가상품/구성" 섹션)

**입력 화면**: product-viewer 상품 상세 → **추가상품**(또는 셋트) 섹션 "편집" → pvEdit 팝업.
**표시구조**(PRD_000016 §추가상품(1) 인용): 헤더 = `템플릿코드 | 표시순서 | 비고`, 행 예 `OPP접착봉투 110x160 mm 50장 | 1`. (추가상품 섹션은 t_prd_templates 와 t_prd_product_sets 양쪽을 쓸 수 있음 — sets 는 하위상품 결합용.)
**FK 선행 등록**: `sub_prd_cd`(→t_prd_products: 하위 상품이 먼저 존재), `prd_cd`(셋트 최종상품).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|--------|----------|------|:---:|----------------------|--------------------------|------------------|----------|
| 셋트 최종상품코드 | prd_cd | (컨텍스트 고정) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (현재 상품) | 자동 세팅 | pvEdit |
| 하위상품코드 | sub_prd_cd | select(상품 마스터) | **Y/PK** | varchar(50) PK NOT NULL FK→t_prd_products | (t_prd_products 행) | 결합할 하위 상품 선택 | pvEdit |
| 하위상품수량 | sub_prd_qty | input/number | **Y** | integer NOT NULL | — | 하위상품 수량(예: 1) | pvEdit |
| 표시순서 | disp_seq | input/number | N | integer | — | 정렬 순서 | pvEdit |
| 비고 | note | input/text | N | varchar(500) | — | 메모 | pvEdit |
| 등록일시 | reg_dt | 자동/시스템 | (시스템) | timestamp NOT NULL | — | now() 자동 | pvEdit |
| 수정일시 | upd_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |
| 삭제여부 | del_yn | 자동/시스템 | (시스템) | char(1) NOT NULL | Y / N | 자동 N | pvEdit |
| 삭제일시 | del_dt | 자동/시스템 | (시스템) | timestamp | — | 자동 | pvEdit |

> **GAP 주의**: 엽서 "추가상품" 섹션 표시는 **t_prd_templates**(템플릿코드)로 보이고 t_prd_product_sets(하위상품 결합)는 책자 셋트(gap-board §6 booklet sets 21행)에서 사용. 즉 "추가상품" 섹션 UI 는 templates 와 sets 두 엔티티를 모두 호스트할 수 있음 — sets 입력 경로(셋트 구성 vs 단순 추가상품 템플릿)는 product-viewer 에서 엔티티 구분 라벨이 명확히 분리돼 있지 않아 **입력 경로 GAP**으로 표기(B군 t_prd_templates 와 경계 조율 필요).
> **round-7 미적재 갭 연결**: 책자 sets 는 DB-ONLY/EXT-LOAD(gap-board §6, "booklet sets 21 | 정당 가능(책자=내지+표지 셋트)"). 캘린더/아크릴/굿즈파우치 addons ❌ MISSING(§5) — 다만 addons 는 주로 templates(B군) 영역.

---

## 누락 점검 (table-spec 컬럼 수 vs 명세 행 수)

각 엔티티의 table-spec(=라이브 실측) 전 컬럼이 위 표에 1행씩 빠짐없이 등장하는지 대조. **시스템 컬럼(reg_dt/upd_dt/del_yn/del_dt)도 행으로 포함.**

| 엔티티 | table-spec 컬럼 수 | 명세 행 수 | 일치 |
|--------|:---:|:---:|:---:|
| A-1 t_mat_materials | 17 | 17 | ✅ |
| A-2 t_siz_sizes | 17 | 17 | ✅ |
| A-3 t_clr_color_counts | 9 | 9 | ✅ |
| A-4 t_proc_processes | 11 | 11 | ✅ |
| A-5 t_prd_product_sizes | 8 | 8 | ✅ |
| A-6 t_prd_product_materials | 10 | 10 | ✅ |
| A-7 t_prd_product_print_options | 11 | 11 | ✅ |
| A-8 t_prd_product_processes | 8 | 8 | ✅ |
| A-9 t_prd_product_plate_sizes | 10 | 10 | ✅ |
| A-10 t_prd_product_bundle_qtys | 9 | 9 | ✅ |
| A-11 t_prd_product_page_rules | **7**(del_yn/del_dt 없음, 라이브 실측) | 7 | ✅ |
| A-12 t_prd_product_sets | 9 | 9 | ✅ |

**합계: 12엔티티 / table-spec 컬럼 126개 / 명세 행 126개 — 누락 0 확인.**

> 검증 근거: A-11 page_rules 의 컬럼 수(7)는 라이브 `information_schema.columns` 실측으로 del_yn/del_dt 부재 확인(다른
> product-viewer 테이블은 10/8/9컬럼, del_yn/del_dt 보유). 나머지 11엔티티는 table-spec HTML 파싱 = 라이브 컬럼 실측과 1:1 일치.
