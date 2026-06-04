# 어색데이터 정정 접근법 — 우선순위·세부방법 제안서 (1단계)

후니프린팅 product-viewer 어색데이터 **366 findings(9 rule)**를 "차원 미분리 데이터"로 재해석하여, 어느 DB 차원으로 분리/재해석할지 + 우리측 처리 가능분 vs 후니 원천정정 필요분 + 정정 난이도를 분석한 제안서다. **실제 정정 CSV는 본 단계에서 만들지 않는다**(우선순위 확정 후 다음 단계). DB 미적재·DB 조회 금지(00_schema 추출본만 사용).

> 핵심 관점(사용자 지정): 어색데이터는 noise/오류가 아니라 **차원 분리가 안 된 데이터**다. 정정 = 올바른 DB 차원으로 재해석·분리.
> HARD: 스키마(DDL) 무변경 — 기존 테이블/컬럼/코드로만 분리. 코드 부족 시 "후니 등록 필요" 또는 "코드행 신설 제안(DDL무변경)".

---

## 0. 차원 슬롯 존재 확증 (00_schema 근거)

본 제안의 모든 분리안은 아래 실재 차원 슬롯에만 귀속한다(추정 아님, columns.csv·code-values.md·price-engine-ddl.md로 확인):

| 차원 슬롯 | 테이블·컬럼 | 근거 파일 | 비고 |
|-----------|-------------|-----------|------|
| 묶음수 `bdl_qty` + `bdl_unit_typ_cd` | `t_prd_product_bundle_qtys(prd_cd, bdl_qty, bdl_unit_typ_cd)` | columns.csv(실컬럼)·code-values.md | `bdl_unit_typ_cd`=QTY_UNIT 재사용(.01 EA·.02 매·.03 권·.04 세트). PK=(prd_cd, bdl_qty) |
| 사이즈 치수 `siz_cd` | `t_siz_sizes(siz_cd, siz_nm, work_width, work_height, cut_width, cut_height)` | ref-sizes.csv(497행) | **SIZE_NAME_NOISE 대상 size는 work/cut 치수 전부 NULL 확인됨** |
| 자재 `mat_cd` | `t_mat_materials(mat_cd, mat_nm, mat_typ_cd, upr_mat_cd)` | ref-materials.csv(336행) | MAT_TYPE 11종. 색상/용량/사이즈가 자재로 등록된 어색 실증 |
| 단/양면 `print_side` | `t_prd_product_print_options(print_side, front_colrcnt_cd, back_colrcnt_cd)` | schema-overview.md(172행)·ddl G-2 | 인쇄면 옵션 슬롯. 단가차이 시 별도 comp_cd |
| 별색 공정 `proc_cd` | `t_proc_processes`(PROC_000007~012 별색, PROC_000033+17 박) | price-engine-ddl.md G-1 | 별색=clr 아님=공정. clr_cd 매핑 금지(FK 위반) |
| 출력용지 `output_paper_typ_cd` | `t_prd_product_plate_sizes.output_paper_typ_cd` | code-values.md(OUTPUT_PAPER_TYPE 3종) | 칼선/아이마크 파일유형은 여기 귀속 부적합 → 후술 |
| 도수 `clr_cd` | `t_clr_color_counts`(5행: 0~4도/CMYK) | price-engine-fk-refs.md | 별색 자리 없음 |

**중대 정정 — crossmap v2 전제 재검토**: crossmap v2는 "후니가 전 size에 work/cut 치수 등록 → SIZE_DIMS_NULL 233 해소"라고 기록했으나, 본 추출본(ref-sizes.csv)에서 **SIZE_NAME_NOISE 대상 size(SIZ_000078 등)는 work/cut 치수가 여전히 전부 NULL**이다. 즉 봉투/굿즈류의 "치수+장수" 합성 siz_nm은 미파싱 상태로 남아있다. 이것이 본 작업이 분리해야 할 핵심 대상이며, SIZE_NAME_NOISE를 "price_impact=NONE(noise)"으로 치부한 기존 분류의 과소평가를 교정하는 지점이다.

---

## §1 유형별 정정 접근법 표

| rule | 차원 분리안 | 대상 DB차원/코드 | 우리측/후니 | 난이도 | 건수 | 분리 근거(왜 이 차원) |
|------|-------------|------------------|-------------|--------|------|------------------------|
| **SIZE_NAME_NOISE** | siz_nm 합성문자열을 ① 치수 + ② 묶음수 + ③ 모양으로 분리 | `t_siz_sizes.work/cut_width/height`(치수) + `t_prd_product_bundle_qtys.bdl_qty`/`bdl_unit_typ_cd`(장수·개수) | **우리측(파싱)** + 일부 후니 확인 | 낮음(기계적 정규식) | 81 | "70x200mm(50장)" = 치수(70x200, work/cut 슬롯 NULL→채움) + 50장(=bdl_qty 50, QTY_UNIT.02 매 또는 .04 세트). 모양("원형/사각/하트")은 옵션 또는 siz_nm 정규화. 차원 슬롯 전부 실재 |
| **MAT_SIZE_ONLY** | 자재 슬롯의 용량/개수/치수를 올바른 차원으로 이동 | 파우치 S/M/L/XL→`siz_cd`(product_sizes 링크 기존재) · 용량(11온스/350ml)·개수(2구/2개1세트)→`bdl_qty`/신규 mat_cd 또는 옵션 | **후니 분류 결정 필요** | 중간 | 45 | MAT_000319='M'(MAT_TYPE.09 파우치)이 자재로 등록 확인. 파우치 S/M/L은 사이즈축(siz_cd)이 맞음. 용량/개수는 mat_cd vs bdl_qty 귀속을 후니가 결정해야 함(AWK-5) |
| **MAT_COLOR_IN_NAME** | 색상/마감이 박힌 자재명을 색상 variant(mat_cd) 또는 별색=공정으로 분리 | 순색상→`mat_cd` variant 등록 · 별색/메탈(골드/실버/홀로그램)→공정 `PROC_*` 검토 | **후니 원천등록 필요(D-A)** | 중간~높음 | 68 | 색상=mat_cd variant 축(규칙③). 단 자재 마스터에 해당 색상 미등록(AWK-6) → 후니가 t_mat_materials에 색상자재 추가해야 적재 가능 |
| **MAT_COLOR_ONLY** | 순수 색상 자재명을 mat_cd variant로 정규화 | `mat_cd`(색상 variant) | **후니 원천등록 필요(D-A)** | 중간 | 27 | 자재명이 '실버/화이트/투명'뿐. 색상=mat_cd variant. 미등록 색상자재는 후니 추가 대상 |
| **MAT_PRINTSIDE_ONLY** | 인쇄면(단면/양면)이 자재로 잘못 등록된 것을 상품옵션으로 회수 | `t_prd_product_print_options.print_side` · 단가차이 시 comp_cd | **우리측 회수 + 후니 확인** | 중간 | 19 | 단면/양면은 자재가 아니라 인쇄옵션(G-2 해소). print_options 슬롯 실재. '세로형/가로형'은 레이아웃 옵션 |
| **MAT_ATTR_COMBO** | 색상+크기 복합 자재명을 두 축으로 분해 | 색상→`mat_cd` · 크기→`siz_cd`(의류 결합 variant) | **후니 분류 결정 필요** | 높음 | 10 | '화이트 M'=색상+크기 복합. 의류 결합 variant. 두 차원으로 분해 필요하나 의류 사이즈/색상 자재 미등록 |
| **MAT_SHAPE_ONLY** | 모양(원형/사각/하트)이 자재로 등록된 것을 옵션 또는 siz_cd로 | 옵션값 또는 `siz_cd`(모양별 규격) | **후니 분류 결정 필요** | 중간 | 10 | 모양은 자재가 아닐 가능성 높음(옵션값). 모양별 치수가 다르면 siz_cd, 같으면 단순 옵션. 후니 귀속 결정 |
| **PRINTSIDE_INVALID** | 비표준 인쇄모드(배면양면/투명테두리/풀빼다)를 옵션/공정으로 정규화 | 옵션(`print_side` 확장) 또는 공정 `proc_cd`. 가격축이면 comp_cd | **후니 의미 확인 필요** | 중간~높음 | 63 | 아크릴 특유 인쇄모드. '투명테두리/풀빼다'는 표준 단/양면 enum 밖. 후니가 각 모드의 의미(옵션 vs 공정 vs 가격축)를 확정해야 정규화 가능 |
| **PLATE_FILETYPE_FREEFORM** | 자유서술 파일유형을 별색 마커 vs 입고형식으로 분리 | 별색 마커(+W/+WC/+P/+GS)→공정 `PROC_*` 재확인 · 칼선/아이마크/매수(x3P)=입고형식 메타(가격 무관) | **우리측 분류 + 일부 후니** | 중간 | 43 | 'PDF(+W)'=별색 화이트 마커=공정(G-1). 'AI(칼선)/아이마크'=입고 파일 메타(가격원천 아님). 매수표기(x3P)=주문메타. 출력용지유형 슬롯(OUTPUT_PAPER_TYPE)과는 의미 불일치 → 별색만 공정으로 회수, 나머지는 메타 |

---

## §2 우선순위 랭킹 + [즉시/부분/차단] 분류

랭킹 기준: **(분리 규칙 명확도) × (우리측 처리 가능=비차단) × (건수 효율)**.

| 순위 | rule | 건수 | 분리 명확도 | 우리측 가능 | 분류 | 근거 요약 |
|:----:|------|:----:|------------|------------|:----:|-----------|
| **1** | **SIZE_NAME_NOISE** | **81** | 매우 높음(정규식) | **예(파싱)** | **즉시 가능** | "치수(장수)" 패턴이 기계적. 치수→work/cut 슬롯(현재 NULL 확인), 장수→bdl_qty. 차원 슬롯 전부 실재, 후니 등록 불요(파싱만). 최다 건수·최고 효율 |
| **2** | **PLATE_FILETYPE_FREEFORM** | 43 | 높음(별색 마커 사전) | 예(분류) | **즉시~부분** | +W/+WC/+P/+GS는 G-1 별색 사전과 1:1. 칼선/아이마크/매수는 메타 분리(가격 무관). 우리측 분류 가능. 단 별색 단가는 시트 의존(잔여) |
| **3** | **MAT_PRINTSIDE_ONLY** | 19 | 높음(단/양면 enum) | 예(회수) | **부분 가능** | 단면/양면→print_options 회수는 명확. 단 '세로형/가로형' 레이아웃은 옵션 구조 확인 필요. 후니 단가차이 여부 확인 |
| **4** | **MAT_SIZE_ONLY** | 45 | 중간 | 부분 | **부분 가능** | 파우치 S/M/L→siz_cd는 명확(product_sizes 링크 기존재). 용량/개수는 후니 귀속결정 필요(mat_cd vs bdl_qty) |
| **5** | **MAT_SHAPE_ONLY** | 10 | 중간 | 부분 | **부분~차단** | 모양=옵션 가능성 높으나 후니가 자재/옵션/siz 귀속 확정해야 |
| **6** | **PRINTSIDE_INVALID** | 63 | 낮음(의미 불명) | 아니오 | **후니 차단** | 투명테두리/풀빼다 의미를 후니만 안다. 옵션·공정·가격축 판정 선행 필요 |
| **7** | **MAT_COLOR_IN_NAME** | 68 | 중간 | 아니오 | **후니 차단** | 색상 variant 분리안은 명확하나 색상자재 원천등록(AWK-6/D-A)이 후니 대기 |
| **8** | **MAT_COLOR_ONLY** | 27 | 중간 | 아니오 | **후니 차단** | 동상. 미등록 색상자재 후니 추가 선행 |
| **9** | **MAT_ATTR_COMBO** | 10 | 낮음(복합 분해) | 아니오 | **후니 차단** | 색상+크기 이중축 분해 + 의류 자재 미등록. 최난도·최소건수 |

분류 집계: **즉시 가능 = SIZE_NAME_NOISE 81** · **즉시~부분 = PLATE_FILETYPE 43** · **부분 가능 = MAT_PRINTSIDE 19 + MAT_SIZE 45 + MAT_SHAPE 10** · **후니 차단 = PRINTSIDE_INVALID 63 + MAT_COLOR_IN_NAME 68 + MAT_COLOR_ONLY 27 + MAT_ATTR_COMBO 10 = 168**.

---

## §3 권장 착수 유형 1~2개 + 구체적 정정 매핑 방법

### 권장 착수 1순위: **SIZE_NAME_NOISE (81건)**

이유: ① 분리 규칙이 정규식으로 기계화 가능(최고 명확도) ② 우리측 파싱만으로 완결(후니 등록 불요=비차단) ③ 최다 건수(81)로 효율 최고 ④ 차원 슬롯(work/cut 치수 + bdl_qty)이 모두 실재 확증 ⑤ 현재 ref-sizes.csv에서 대상 치수가 전부 NULL이라 분리 효과가 즉시 가시화됨.

**정정 매핑 방법** — siz_nm을 3성분으로 토큰 분리:
- 패턴 A `{치수}({수량}{단위})`: 치수→`work_width/work_height/cut_width/cut_height`(현재 NULL→채움), 수량→`t_prd_product_bundle_qtys.bdl_qty`, 단위(장/EA/개/인용)→`bdl_unit_typ_cd`(QTY_UNIT)
- 패턴 B `{모양}{치수}` 또는 `{치수}{모양}`: 치수→work/cut 슬롯, 모양→옵션 또는 siz_nm 정규화(자재/옵션 귀속은 후니 확인)
- 패턴 C 색상/자재 접두("화이트165x115mm", "레더15x30"): 색상/자재→mat_cd variant(후니 등록 연계), 치수→work/cut 슬롯

샘플 5건(실제 어색명칭 → 분리결과):

| siz_cd | 원본 siz_nm | → 치수(work/cut W×H) | → bdl_qty(unit) | → 기타 | 비고 |
|--------|-------------|----------------------|------------------|--------|------|
| SIZ_000078 | `70x200mm(50장)` | 70 × 200 (mm) | bdl_qty=50, QTY_UNIT.02(매) | — | OPP접착봉투. 순수 패턴 A, 우리측 완결 |
| SIZ_000089 | `60x90mm(20장)` | 60 × 90 | bdl_qty=20, QTY_UNIT.02 | — | OPP비접착봉투. 동상 |
| SIZ_000212 | `정사각10x10mm(8EA)` | 10 × 10 | bdl_qty=8, QTY_UNIT.01(EA) | 모양=정사각(옵션 확인) | 합판도무송. A+B 혼합 |
| SIZ_000355 | `100x100mm원형` | 100 × 100 | (없음) | 모양=원형(옵션 확인) | 아크릴코스터. 패턴 B만 |
| SIZ_000399 | `100x70cm(1인용)` | 1000 × 700 (cm→mm 환산 확인) | bdl_qty=1, QTY_UNIT.04(세트) | 인용=세트 단위 해석 | 피크닉매트. 단위 환산·인용 해석 후니 확인 |

> 우리측 즉시 완결분 = 패턴 A 순수형(봉투류 대부분). 패턴 B 모양·패턴 C 색상/자재는 "치수 분리는 우리측, 모양/색상 귀속은 후니 확인" 으로 분할.

### 권장 착수 2순위: **PLATE_FILETYPE_FREEFORM (43건)**

이유: ① 별색 마커(+W/+WC/+P/+GS)가 G-1 별색 공정 사전과 1:1 결정적 매핑 ② 칼선/아이마크/매수는 가격 무관 입고 메타로 명확 분리 ③ 우리측 분류 가능. 단 별색 단가 자체는 디지털인쇄비 시트 의존(잔여).

**정정 매핑 방법** — 파일유형 문자열을 3종으로 분류:
- 별색 마커: `PDF(+W)`→별색 화이트(PROC_000008), `+WC`→화이트+클리어, `+P`→핑크(PROC), `+GS`→금은(PROC). **공정 선택 신호**로 회수, clr_cd 매핑 금지
- 입고 파일형식: `AI(칼선)`, `*아이마크`, `AI_CS5(칼선)` = 칼선/마크 입고 메타(가격원천 아님, 출력메타로 분리)
- 주문 매수: `JPG x 3P`, `JPG X 4P` = 디자인 매수(주문옵션 메타)

샘플 3건:

| siz_cd | 원본 값 | → 분리결과 | 귀속 |
|--------|---------|-----------|------|
| (PRD_000019 투명엽서) | `PDF(+W)` | 별색=화이트 | `t_prd_product_processes` proc_cd=PROC_000008(화이트). clr_cd NULL |
| (PRD_000022 금은별색엽서) | `PDF(+GS)` | 별색=금+은 | proc_cd 금(PROC)·은(PROC). 단가=별색 시트 |
| (PRD_000052 반칼스티커) | `AI_CS5 (칼선)` | 입고형식=AI 칼선 | 가격 무관 입고 메타(파일유형 필드 의미 재정의 대상) |

---

## §4 잔여·후니 의존 항목 목록

| 항목 | 건수 | 후니 의존 내용 | 기존 결정 연계 |
|------|:----:|----------------|----------------|
| MAT_COLOR_IN_NAME 색상자재 등록 | 68 | t_mat_materials에 색상 variant 자재 미등록 → 후니 원천등록 후 mat_cd 분리 가능 | D-A(색상자재 mat_cd 등록 대기) |
| MAT_COLOR_ONLY 색상자재 등록 | 27 | 동상(순색상 자재) | D-A |
| MAT_ATTR_COMBO 의류 결합 variant | 10 | 색상+크기 이중축 분해 + 의류 색상/사이즈 자재 미등록 | D-A + D-B(variant 귀속) |
| MAT_SIZE_ONLY 용량/개수 귀속결정 | 45 중 일부 | 11온스/350ml/2구/2개1세트를 mat_cd vs bdl_qty 중 어디로 귀속할지 후니 결정 | AWK-5 |
| MAT_SHAPE_ONLY 모양 귀속결정 | 10 | 원형/사각/하트가 자재인지 옵션인지 siz인지 후니 확정 | AWK-5 |
| PRINTSIDE_INVALID 인쇄모드 의미 | 63 | 배면양면/투명테두리/풀빼다의 의미(옵션 vs 공정 vs 가격축)를 후니만 판정 가능 | N-2(신규 패턴) |
| 별색 단가 시트 연계 | (PLATE 일부) | 별색 공정 회수는 우리측, 단가는 디지털인쇄비 F~O 시트에서 round-2 매핑 | G-1·AWK |
| 모양/단위 환산 확인 | (SIZE_NAME 일부) | 패턴 B 모양 귀속·cm→mm 환산·'인용=세트' 해석 후니 확인 | 신규 |
| MAT_PRINTSIDE 세로형/가로형 | (19 일부) | 레이아웃 옵션 구조·단가차이 여부 후니 확인 | N-4 |

> **DDL 무변경 재확인**: 위 모든 분리안은 기존 테이블/컬럼/코드로 흡수된다. bdl_qty/work·cut 치수/siz_cd/mat_cd/print_side/proc_cd 슬롯 전부 실재. 색상·의류 자재 등 결손분은 후니 데이터 등록(스키마 무변경)으로 처리. 신규 코드행 신설 제안은 현재 불요(QTY_UNIT 4종으로 장/EA/세트/인용 단위 충분 — 단 '인용' 해석만 후니 확인).
