# round-3 검증용 DB 적재값 fresh 추출 노트

- 추출 일자: 2026-06-04
- 추출 방식: read-only `SELECT * ORDER BY <키>` 1회, psql `--csv`. DB 무변경(INSERT/UPDATE/DDL 없음).
- DB: railway (PostgreSQL 18.4), 접속 `.env.local`의 `RAILWAY_DB_*`.
- 행수는 사전 `count(*)` 실측으로 검증(캐시 아님). 산출 CSV의 데이터 행수 = (파일 줄수 − 헤더 1줄).
- 모든 CSV는 `SELECT *` 전 컬럼 추출(헤더=실제 컬럼명). 기존 부분추출 ref 파일을 fresh 전체추출로 덮어씀.

## 추출 테이블·행수 (라이브 실측)

### 마스터 (Phase 3 마스터 정합용)
| 테이블 | 행수 | CSV |
|---|---|---|
| t_siz_sizes | 497 | ref-sizes.csv |
| t_mat_materials | 336 | ref-materials.csv |
| t_proc_processes | 83 | ref-processes.csv |
| t_cod_base_codes | 58 | ref-base-codes.csv |
| t_clr_color_counts | 5 | ref-color-counts.csv |

### 9속성 상품 연결 (Phase 4용)
| 테이블 | 행수 | CSV |
|---|---|---|
| t_prd_product_sizes | 444 | ref-product-sizes.csv |
| t_prd_product_materials | 406 | ref-product-materials.csv |
| t_prd_product_print_options | 172 | ref-product-print-options.csv |
| t_prd_product_processes | 196 | ref-product-processes.csv |
| t_prd_product_process_excl_groups | 13 | ref-product-process-excl-groups.csv |
| t_prd_product_plate_sizes | 509 | ref-product-plate-sizes.csv |
| t_prd_product_bundle_qtys | 4 | ref-product-bundle-qtys.csv |
| t_prd_product_page_rules | 11 | ref-product-page-rules.csv |
| t_prd_product_addons | 34 | ref-product-addons.csv |

### JOIN KEY 기반
| 테이블 | 행수 | CSV |
|---|---|---|
| t_prd_products | 280 | ref-products.csv |

전 테이블 행수 = 브리프 명시 기대값과 일치.

## 테이블별 컬럼 구조 (JOIN KEY·코드 컬럼 표시)

JOIN KEY는 `prd_cd`(상품코드) 중심. **MES_ITEM_CD는 t_prd_products에 존재하나 NULL 다수**(과거 교훈: JOIN KEY=prd_nm only). prd_nm은 t_prd_products에만 있으므로 9속성 테이블은 prd_cd→t_prd_products로 조인 후 prd_nm 해석.

### t_prd_products (JOIN KEY 원천)
- 키: `prd_cd` (PK 추정, varchar(50))
- 코드 컬럼: `prd_typ_cd`, `semi_role_cd`, `qty_unit_typ_cd` → t_cod_base_codes 참조
- JOIN 보조: `MES_ITEM_CD` varchar(30) **nullable(NULL 다수, JOIN 키로 부적합)**, `prd_nm` varchar(200) NOT NULL
- 기타: nonspec_*(비규격 치수 min/max), min/max/dflt/incr_qty, constraint_json(jsonb), use_yn

### t_prd_product_sizes
- 키: (`prd_cd`, `siz_cd`) 복합
- 코드 컬럼: `siz_cd` → t_siz_sizes 참조
- 속성: dflt_yn, disp_seq

### t_prd_product_materials
- 키: (`prd_cd`, `mat_cd`, `usage_cd`) 복합
- 코드 컬럼: `mat_cd` → t_mat_materials, `usage_cd`·`dep_proc_cd` → 코드/공정 참조
- 속성: dflt_yn, disp_seq

### t_prd_product_print_options
- 키: (`prd_cd`, `opt_id`) — opt_id는 integer 시퀀스
- 코드 컬럼: `front_colrcnt_cd`·`back_colrcnt_cd` → t_clr_color_counts 참조, `print_side` varchar(20)
- 속성: dflt_yn, disp_seq

### t_prd_product_processes
- 키: (`prd_cd`, `proc_cd`) 복합
- 코드 컬럼: `proc_cd` → t_proc_processes, `excl_grp_cd` → 동상품 excl_groups 참조
- 속성: mand_proc_yn, disp_seq

### t_prd_product_process_excl_groups
- 키: (`prd_cd`, `excl_grp_cd`) 복합
- 코드 컬럼: `sel_typ_cd` → t_cod_base_codes 참조
- 속성: excl_grp_nm, max_sel_cnt, mand_yn, note

### t_prd_product_plate_sizes
- 키: (`prd_cd`, `siz_cd`) 복합
- 코드 컬럼: `siz_cd` → t_siz_sizes, `output_paper_typ_cd` → 코드 참조
- 속성: dflt_plt_yn, output_file_typ varchar(30), note

### t_prd_product_bundle_qtys
- 키: (`prd_cd`, `bdl_qty`) 복합
- 코드 컬럼: `bdl_unit_typ_cd` → t_cod_base_codes 참조(nullable)
- 속성: dflt_yn, disp_seq

### t_prd_product_page_rules
- 키: `prd_cd` (상품당 1행 추정, 11행)
- 코드 컬럼: 없음
- 속성: page_min, page_max, page_incr(전부 integer NOT NULL), note

### t_prd_product_addons
- 키: (`prd_cd`, `addon_prd_cd`) 복합 — addon_prd_cd는 상품 자기참조(t_prd_products.prd_cd)
- 코드 컬럼: 없음
- 속성: disp_seq, note

### 마스터 테이블 키·코드
- t_siz_sizes: 키 `siz_cd`. 전 컬럼(work_width/height, cut_width/height, margin_top/bot/lft/rgt, impos_yn, use_yn, note) 추출됨.
- t_mat_materials: 키 `mat_cd`. 코드 `mat_typ_cd`·`sel_typ_cd`, 자기참조 `upr_mat_cd`. 치수(width/height/depth/weight), bdl_qty.
- t_proc_processes: 키 `proc_cd`. 자기참조 `upr_proc_cd`, `prcs_dtl_opt`(jsonb), disp_seq.
- t_cod_base_codes: 키 `cod_cd`. 자기참조 `upr_cod_cd`(코드 카테고리). code-values.md와 병행 참조.
- t_clr_color_counts: 키 `clr_cd`. `chnl_cnt`(채널수 integer), clr_nm.

## 기존 ref 파일 stale 여부 (권위반전 검증)

기존 git 추적 ref 5종은 **부분 컬럼 추출(curated projection)**이었음 — 전체추출 아님. 따라서 검증 권위로 부적합, fresh 전체추출로 교체 완료.

| 파일 | 기존 컬럼수 | fresh 컬럼수 | 차이 |
|---|---|---|---|
| ref-sizes | 6 | 15 | margin_*·impos_yn·use_yn·note·reg/upd_dt 누락분 복원 |
| ref-materials | 4 | 15 | sel_typ_cd·치수·bdl_qty·use_yn 등 누락분 복원 |
| ref-products | 3 | 21 | MES_ITEM_CD·nonspec_*·qty 범위·constraint_json 등 누락분 복원 |
| ref-product-sizes | 5 (prd_nm·siz_nm 조인 포함) | 6 | 조인 컬럼 제거, disp_seq·reg/upd_dt 복원 (원시 테이블 shape) |
| ref-product-processes | 4 (prd_nm·proc_nm 조인 포함) | 7 | 조인 컬럼 제거, excl_grp_cd·mand_proc_yn·disp_seq 복원 |

- 정렬 무시 content 비교에서도 5종 전부 상이 → 기존 ref는 stale(부분추출). round-3 검증은 fresh 전체추출 기준.
- 신규 추출 10종(processes·base-codes·color-counts·print-options·excl-groups·plate-sizes·bundle-qtys·page-rules·addons)은 이번이 최초 전체추출.

## HARD 제약 준수
- read-only(SELECT/count)만 실행. INSERT/UPDATE/DDL 없음.
- 비밀번호 stdout 미출력(PGPASSWORD env 경유).
- 산출 .md 한국어, 식별자/컬럼명 영어.
