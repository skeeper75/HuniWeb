# 인쇄옵션(print_option) 속성 연결 정합 — round-3 Phase 4

권위: **엑셀=원천**, DB 적재값이 엑셀과 정합하는지 검증. DB 재조회 없음(`00_schema/` 추출본). JOIN KEY=`prd_nm`. 분모=245 공통.

근거: `00_schema/ref-product-print-options.csv`(172행, print_side·front/back_colrcnt_cd)·`ref-color-counts.csv`(5) / `04_audit/excel-print-option.csv`(94상품). 불일치: `print-option-mismatches.csv`.

## 별색 이중성 분기 (HARD)
- 엑셀 인쇄영역의 별색5(화이트인쇄/클리어인쇄/핑크인쇄/금색인쇄/은색인쇄)는 round-2 확정상 **공정(PROC_000007 별색인쇄 + PROC_000008~012)**. 인쇄옵션 대조에서 **제외하고 공정축으로 이관** → `process-parity.md`에서 대조.
- **별색 분기 건수**: 31 토큰을 12개 상품에서 인쇄옵션→공정축으로 이동. 이동 안 했으면 12상품 거짓 MISSING 발생할 뻔.
- 인쇄옵션 본 대조 = `print_side`(단면/양면/배면양면 등) + 도수(front/back_colrcnt_cd→`t_clr_color_counts`)만.

## 4분류 (공통 91 + 엑셀-only 3)
| 분류 | 카운트 | 의미 |
|------|:-----:|------|
| **MATCH** | **91** | 공통상품 print_side 정합(별색 제외 후) |
| **MISSING** (엑셀O DB X) | **1** | 접착투명포스터(단면) — 인쇄면 DB 미연결 |
| **EXTRA** (DB O 엑셀 X) | **0** | DB-only 인쇄옵션 상품 없음 |
| **MISMATCH** (상충) | **0** | print_side 충돌 없음 |
| (별색전용) | 2 | 화이트인쇄명함·화이트인쇄엽서 = 별색만, 공정축 정합 |

## 명세

### MATCH 91 (별색 제외 후 print_side 정합)
- 공통 91상품 print_side(단면/양면/배면양면) 집합이 DB와 일치/부분집합. 예: 프리미엄엽서 `단면|양면`↔DB `단면·양면`.
- DB print_side에 `배면양면`·`풀빼다`·`투명테두리`(아크릴 인쇄변형)도 존재 → 엑셀 아크릴 토큰(배면양면 등)과 정합.

### 별색 분기 처리 내역 (31토큰/12상품)
화이트/클리어/핑크/금색/은색 인쇄가 인쇄옵션 컬럼에 있던 12상품(투명엽서·화이트인쇄엽서/명함·핑크별색엽서·금은별색엽서·포토카드·투명포토카드·투명명함·스티커류 등)에서 별색을 공정축으로 이관. 이관 후 print_side만 대조 → 거짓 MISSING 회피.

### 별색전용 2 (MATCH로 처리)
- `화이트인쇄명함`·`화이트인쇄엽서`: 인쇄옵션이 **별색뿐**(일반 단면/양면 없음). 별색 이관 후 print_side 공란 → 이 상품의 인쇄 자체가 별색공정. DB print-option 미연결이 **정당**(별색은 공정축). MISSING 아님.

### MISSING 1
- `접착투명포스터`(단면): 실사 상품, DB print-option 미연결. 인쇄면 적재 대상.

### 도수(color count) 정합
- DB front_colrcnt_cd={CLR_000005(CMYK 4도)}, back_colrcnt_cd={CLR_000001(인쇄안함/단면 뒷면)·CLR_000005}. 전건 `t_clr_color_counts` 유효 FK. 단면=뒷면 CLR_000001, 양면=양면 CLR_000005로 정합.

## 판정: **GO (인쇄옵션 정합)**
- 별색 공정축 분기 후 공통 91상품 print_side 전건 MATCH, MISMATCH 0, EXTRA 0. MISSING 1(접착투명포스터)만 잔여.
- **별색 분기가 핵심**: 분기 없으면 12상품 거짓 MISSING. 분기 정당성=round-2 확정 + DB 공정 PROC_000008~012 실재(마스터 정합 §2.3).

## 후니 확인항목
1. 접착투명포스터 인쇄면(단면) 적재.
2. 별색전용 2상품(화이트인쇄명함/엽서)의 인쇄가 공정축 별색으로만 표현되는 게 의도인지 확인(일반 인쇄면 행 불요).
3. 별색 12상품의 공정축 적재 여부는 `process-parity.md` 별색 MISSING 참조(현재 공정에도 미적재 — 연계 결손).
