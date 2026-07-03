# 포토북 — 컬럼 readiness 매트릭스 (round-19 종단 · S0)

> **점검** 2026-07-03 · `dbm-readiness-auditor`(게이트) · 라이브 읽기전용 SELECT + 시뮬레이터 POST(가격계산 전용).
> **권위** 상품마스터 260702 `포토북(가격포함)` 시트(38 의미컬럼) + 인쇄상품 가격표. **라이브=적재 사실 권위.**
> **입력 재사용** `15_domain-spec/photobook/{column-dictionary,mapping-info,product-bom}.md`(round-11) · 메모리 `book-set-page-pricing-inner-member-260629`(PRD_000100 가격 COMMIT 이력).

## 0. 라이브 상품 실측 — 셋트형 1완제품 + 7반제품

포토북은 **셋트 완제품**(PRD_000100, PRD_TYPE.01) + **반제품 구성원 7**로 적재됨(`t_prd_products` 실측):

| prd_cd | prd_nm | 유형 | semi_role | 역할 |
|--------|--------|------|-----------|------|
| PRD_000100 | 포토북 [디자인명] | .01 완제품 | — | 셋트 부모(base 24P 공식·전 basedata 보유) |
| PRD_000101 | …-내지(몽블랑130) | .02 반제품 | SEMI_ROLE.01 | 내지 = per-page 증분 공식 |
| PRD_000102 | …-표지(하드커버) | .02 | SEMI_ROLE.02 | 표지 |
| PRD_000103 | …-표지(아트250+무광코팅) | .02 | SEMI_ROLE.02 | 표지 |
| PRD_000105 | …-표지(레더하드커버) | .02 | SEMI_ROLE.02 | 표지 |
| PRD_000106 | …-표지(레더) | .02 | SEMI_ROLE.02 | 표지 |
| PRD_000107 | …-표지(소프트커버) | .02 | SEMI_ROLE.02 | 표지 |
| PRD_000104 | …-면지(그레이) | .02 | SEMI_ROLE.03 | 면지 |

- **구조:** `t_prd_product_sets` PRD_000100 ← 7 구성원(101~107·sub_prd_qty=1·del_yn=N). `t_prd_product_sizes`·`_materials`·`_print_options`·`_processes`·`_page_rules` **전부 부모(PRD_000100)에 적재**, 구성원 101~107은 basedata 0행(=B 셋트 빈 껍데기 설계, `product-bom.md` §BOM 정합).
- **가격경로 = 셋트형(evaluate_set_price) 2-레이어**: ① 부모 base 24P(사이즈×표지타입) `PRF_PHOTOBOOK_FIXED`→`COMP_PHOTOBOOK_BASE`(11행) ② 내지 구성원 per-page 증분 `PRF_PHOTOBOOK_INNER`→`COMP_PHOTOBOOK_PAGE`(4행, 사이즈별). **직접단가/공식 아님 — 셋트 조합가.**

## 1. 컬럼 × 목표 t_* × 라이브 적재 실태 (38 의미컬럼 전수)

| C | 엑셀 컬럼 | 목표 t_* 축 | 라이브 적재 실태(실측) | 준비도 | 갭/처리 |
|---|----------|-------------|------------------------|:--:|--------|
| 1 | 구분 | t_cat_categories | 포토북 단일 그룹 | ✅ | — |
| 2 | ID | (매핑 보조키) | prd_cd 아님·견적 무관 | ✅ | 제외 확정 |
| 3 | MES ITEM_CD(상품) | products.MES_ITEM_CD | 빈값(미부여) | ✅ | 생산메타·견적 무관 제외 |
| 4 | 상품명 | products.prd_nm | `포토북 [디자인명]` PRD_000100 | ✅ | 멱등 키 |
| 5 | 사이즈(필수) | siz_sizes + product_sizes | 4행(부모): A5=SIZ_000170·A4=SIZ_000172·8x8=SIZ_000269·10x10=SIZ_000274 | ✅ | prod_dims fk(선택가능) |
| 6 | 내지 MES | (sub_prd MES) | 빈값 | ✅ | 생산메타 제외 |
| 7 | 내지 블리드 | siz_sizes.margin(내지) | 부모 siz에 흡수 | 🟡 | 재단여유·견적 무관 |
| 8 | 내지 작업사이즈 | siz_sizes.work(내지) | 부모 siz 실재 | ✅ | — |
| 9 | 내지 재단사이즈 | siz_sizes.cut(내지) | 부모 siz 실재 | ✅ | — |
| 10 | 내지 파일명약어 | GAP/note | 미적재 | ✅ | 견적밖 생산메타 제외 확정 |
| 11 | 내지 출력파일 | plate_sizes.output_file_typ | PDF(생산메타) | ✅ | 견적 무관 제외 |
| 12 | 내지 폴더(인쇄방식) | 공정 root | 디지털인쇄(내지) | ✅ | 생산 라우팅 제외 |
| 13 | 내지종이(필수) | mat + product_materials(USAGE.01) | MAT_000105 몽블랑130g·usage.01 부모 | ✅ | — |
| 14 | 내지인쇄(필수) | print_options.print_side | 양면 POPT_000002(CLR_000005/005) 부모 | ✅ | — |
| 15 | 내지페이지 최소 | page_rules.page_min | 24 (부모) | 🟡 | 소프트 4~14 미차등(§갭4) |
| 16 | 내지페이지 최대 | page_rules.page_max | 150 (부모) | ✅ | — |
| 17 | 내지페이지 증가 | page_rules.page_incr | 2 (부모)·per-page 2P당 정합 | ✅ | — |
| 18 | 표지타입(필수) | option_groups/options + 표지 sub_prd | **OPT_000079 표지타입(SEL_TYPE.01 택1·mand=Y) + OPV_000484 하드/485 레더하드/486 소프트** | ✅ | ①UI 선택가능. 단 option_items 미배선(§갭1) |
| 19 | 표지 MES | (sub_prd MES) | 빈값 | ✅ | 생산메타 제외 |
| 20 | 표지 블리드 | siz_sizes.margin(표지) | 부모 흡수 | 🟡 | 재단여유·견적 무관 |
| 21 | 표지 작업사이즈 | siz_sizes.work(표지) | 부모 siz | 🟡 | 책등 포함 펼침·생산메타 |
| 22 | 표지 재단사이즈 | siz_sizes.cut(표지) | 빈값(반제품) | ✅ | 정상(작업=완성) |
| 23 | 표지 파일명약어 | GAP/note | 미적재 | ✅ | 견적밖 제외 확정 |
| 24 | 표지 출력파일 | output_file_typ | PDF | ✅ | 제외 |
| 25 | 표지 폴더(인쇄방식) | 공정 root | 디지털/특수출력(레더) | ✅ | 생산 라우팅 제외 |
| 26 | 표지종이사양(필수) | mat + product_materials(USAGE.02) + proc(코팅) | **표지자재 5행 부모(005 하드/006 레더하드/007 소프트/250 아트250+무광코팅/186 레더)** + PROC_000015(코팅 non-mand) | ✅ | 자재+공정 분해 적재. 코팅=아트250 자재명에 흡수 |
| 27 | 표지인쇄사양(필수) | print_options.print_side | 단면 POPT_000001(CLR_000005/001) 부모 | ✅ | — |
| 28 | 제본사양 제본 | proc_processes(PUR) + product_processes | **PROC_000020 PUR(mand_proc_yn=Y) 부모** | ✅ | PUR 단일·정합 |
| 29 | 제본사양 면지 | mat + product_materials(USAGE.03) | MAT_000251 그레이·usage.03 부모 + 멤버 PRD_000104 | ✅ | — |
| 30 | 제본사양 책등 | prcs_dtl_opt(PUR 책등mm) | 10/12/14/16mm=페이지수 앱 계산 | 🟡 | 미저장(런타임 계산)·가격 무관 |
| 31 | 수량 최소 | products.min_qty | 1 | ✅ | — |
| 32 | 수량 최대 | products.max_qty | 1000 | ✅ | — |
| 33 | 수량 증가 | products.qty_incr | 1 | ✅ | — |
| 34 | 업로드 | products.file_upload_yn | N | ✅ | 편집기 중심 정합 |
| 35 | 편집기 | products.editor_yn | Y | ✅ | 에디터 중심 |
| 36 | 가이드파일 | GAP/note | AI/PSD 생산메타 | ✅ | 견적밖 제외 |
| 37 | 가격 기본(24P) | prc_* base | **COMP_PHOTOBOOK_BASE 11행(siz×opt·10000~32000)·권위 verbatim** | ✅ | §2 대조표 |
| 38 | 가격 추가(2P)당 | prc_* per-page 증분 | **COMP_PHOTOBOOK_PAGE 4행(siz별·300~1000)·권위 verbatim** | ✅ | §2 |

**집계:** ✅ 32 · 🟡 6(C7·C15·C20·C21·C30 = 생산메타/미저장·가격무관 + C15 소프트 page_rule) · ❌ 0.

## 2. 가격 데이터 ↔ 권위 대조 (verbatim)

**COMP_PHOTOBOOK_BASE (기본 24P · use_dims=[siz_cd,opt_cd,min_qty] · PRICE_TYPE.01):** 11행 = 4사이즈 × 3표지타입 − (10x10 소프트 비활성 1).

| 사이즈 | 하드(OPV_484) | 레더하드(485) | 소프트(486) | 권위(product-bom §0) |
|--------|------|--------|--------|------|
| 8x8 (SIZ_269) | 15000 | 23000 | 12000 | 15000/23000/12000 ✅ |
| 10x10 (SIZ_274) | 22000 | 32000 | **(없음)** | 22000/32000/비활성 ✅ |
| A5 (SIZ_170) | 12000 | 19000 | 10000 | 12000/19000/10000 ✅ |
| A4 (SIZ_172) | 16000 | 26000 | 13000 | 16000/26000/13000 ✅ |

**COMP_PHOTOBOOK_PAGE (추가 2P당 · use_dims=[siz_cd,min_qty]):** 8x8=500·10x10=1000·A5=300·A4=600 — 권위(product-bom §BOM) verbatim ✅.

## 3. ❌/🟡 갭 (상세 = gap-board.md)

- ❌ 없음. 🟡 6컬럼은 전부 **생산메타·미저장(런타임)·가격 무관**(C7·C20·C21·C30) + **소프트 page_rule 미차등**(C15) → 견적 blocker 아님.
- **가격 데이터 = 완전 적재·verbatim.** 가격으로 닫을 COMMIT 없음.
- 견적가능 미달은 **컬럼 적재가 아니라** ② 차원환원(표지타입 option_items 미배선)·코드트랙(셋트 siz_cd 전파·위젯 page 계약)에 있음 → gap-board.
