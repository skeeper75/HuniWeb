---
name: dbm-excel-parse
description: 후니프린팅 상품마스터·인쇄상품 가격표 xlsx를 파싱·정규화하는 방법론 스킬. openpyxl/pandas 읽기 패턴, 한 시트 내 다중 논리블록 식별, 수량구간 할인표 파싱(범위문자열 "1~49"→min/max, 할인율 단위 판별), 사이즈 매트릭스 언피벗(long form), 출처(provenance) 기록, 모호성 플래깅 표준을 제공한다. '엑셀 파싱', '가격표 분석', '구간할인 추출', '매트릭스 언피벗', '시트 정규화', '엑셀 데이터 추출' 작업 시 반드시 사용.
---

# Excel Parsing & Normalization Methodology

[HARD] Write all deliverable docs (.md) in KOREAN (project documentation language). Keep identifiers, sheet/column names, code values, CSV headers, and cell ranges in English.

This skill turns the human-authored후니프린팅 workbooks into clean normalized data the mapping designer can map field-for-field. Spreadsheets are not databases — one sheet often holds multiple logical blocks, matrices, merged-cell titles, and mixed units. Parse the reality, do not assume a tidy table.

## Source workbooks (read-only)

- `docs/huni/후니프린팅_상품마스터_260527.xlsx` — product master
- `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` — print product price table (19 sheets)

## Why normalization matters

The mapping designer maps columns to DB columns. That requires *long-form* data with explicit keys, not a 2-D matrix or a title-plus-block layout. Normalization also makes the validator's job possible: it diffs normalized rows back against original cells, so every normalized row must carry its source provenance.

## L1 충실추출 (round-3 정합검증 토대, faithful extraction)

round-3 정합검증은 **무손실 충실추출(L1)**을 토대로 한다. 아래 구간할인/매트릭스 파싱이 특정 블록을 long으로 *정규화*하는 것과 달리, L1은 **시트 전체를 무해석·무손실로 떠서 어느 정보축도 버리지 않는다**. 결함의 뿌리가 추출 누락이기 때문(속성별 단일컬럼 평면화 → 행내 관계 손실 → false MISSING. 예: 포맥스 A1 — E칸만 떠서 작업사이즈 공백·행숨김 신호 소실).

**8 정보축 전부 추출 [HARD]**: ①값(data_only 계산값) ②행숨김(`row_dimensions[r].hidden`=비활성/단종) ③열숨김(`column_dimensions[L].hidden`=UI미노출 내부 생산/가격용) ④셀코멘트(openpyxl `cell.comment`가 안내문구만 주면 `xl/threadedComments/*.xml`+`xl/persons/person.xml` 직접 파싱) ⑤배경색fill+글자색font ⑥수식여부(`data_only=False` 병행로드로 식별, 값+수식 둘 다) ⑦하이퍼링크 ⑧병합(`merged_cells`: 가로병합=그룹헤더 row1 forward-fill→`그룹명_하위명` composite, 세로병합=단일컬럼). 미사용 확정(무시): 취소선·아웃라인그룹·자동필터·데이터유효성(전 시트 0).

**무손실 원칙**: 속성별 단일컬럼 평면화 금지(1행1레코드 전컬럼). 빈셀 보존(공백≠없음, 유효0[블리드 0mm] 구분). 숨김 행/열도 제외 말고 hidden 플래그로 보존(비활성 판정은 L2). 고정 컬럼레터 가정 금지 — 작업사이즈 위치 시트별 상이(실사 I·디지털 H·아크릴 J)이니 row2 헤더로 동적 식별. ffill은 화이트리스트(A~D 키컬럼)만.

**의미 코드맵(시트 footnote 근거)**: 노랑배경=신규(MES미등록)·그레이배경 셀=품절/준비중(미출시)·그레이글자/숨김열=내부용·행숨김=사용안함·★빨강=옵션제약·오렌지=개발무시·(포토북)핑크=편집기사양. fill_meaning/font_meaning 메타 라벨(미확정은 RGB+「확인 필요」).

**완전성 검증(누락0 기계보증)**: 컬럼커버리지(원본 비어있지않은 컬럼수==추출 필드수)·non-empty 셀 보존율 100%·행카운트·round-trip diff 0. 미통과 시 L2 진입 차단.

**검증된 스크립트(재사용)**: `06_extract/scripts/extract_l1.py`(`--sheet` 파라미터화, 전수 확장)·`verify_l1.py`(9게이트). 토대 범위 = 상품마스터 13시트 + 가격표 `판걸이수`(사이즈 마진/작업/블리드/전지 권위) + `출력소재(IMPORT)`(`*별도설정` 자재 권위). 산출 = 시트별 `<slug>-l1.csv`+meta·`product-info-foundation.md`(정합검증 대상)·`price-info-deferred.md`(단가=round-2 이연).

## openpyxl practical rules

- Use `load_workbook(f, read_only=True, data_only=True)` — `data_only` reads computed values, not formula strings.
- Read-only worksheets have NO `.dimensions`; iterate with `ws.iter_rows(min_row=.., max_row=.., values_only=True)` and compute width from the rows.
- Merged cells: the value lives only in the top-left cell of the merge; block titles and apply-scope text are often merged — read from the anchor cell.
- A sheet can contain several blocks stacked vertically. Scan the full sheet for block markers (titles containing "구간", "할인", size headers) before deciding its structure.

## Block types to recognize

| Block type | Shape | Normalize to |
|-----------|-------|--------------|
| bracket-discount | `수량구간 | 할인율` rows under a title | `(min_qty, max_qty, rate)` long rows |
| size matrix | `가로/세로` header row + size column, price cells | `(width, height, price)` long rows (unpivot) |
| option cascade | option headers + sub-option rows + qty rows | `(option, sub_option, qty, price)` long rows |
| flat list | simple key/value table | rows as-is |

## Quantity-bracket discount parsing (primary focus)

Three confirmed discount blocks in the price workbook:
- Sheet `아크릴`, block starts ~row 49: "아크릴상품 수량별 구간할인" → category 아크릴
- Sheet `굿즈파우치(구간할인)`, row 1: "파우치상품 수량별 구간할인" → 파우치 + 에코백
- Sheet `굿즈파우치(구간할인)`, row 10: "문구상품 수량별 구간할인" → category 문구

### Range string parsing
- `"1~49"` → `min_qty=1, max_qty=49`
- `"1000~10000"` → `min_qty=1000, max_qty=10000` — but FLAG whether 10000 is a real cap or an open-ended sentinel (the validator/user must confirm; an open bracket may need `max_qty = NULL`).
- Normalize the separator: it may be `~`, `-`, `〜`, or a unicode variant.

### Rate unit detection
- Values like `0.0, 0.05, 0.1, 0.15, 0.2` are fractions. The DB `dsc_rate` is `numeric(5,2)` — confirm with the schema sheet whether it stores percent (`5.00`) or fraction (`0.05`). Record `rate_raw` (as in sheet) AND `rate_pct` (×100) so the mapping designer picks the right one; do not pre-decide.

## Provenance (mandatory)

Every normalized row records: `source_file`, `source_sheet`, `source_range` (e.g. `A50:B54`). The validator re-reads these exact cells to verify faithful extraction.

## Ambiguity flagging (do not resolve silently)

Surface these in `extraction-notes.md` as explicit open questions:
- Bracket bounds inclusive or exclusive? (1~49 then 50~99 implies inclusive contiguous.)
- Last bracket cap real or sentinel?
- Rate fraction vs percent.
- Apply-scope text → which exact categories/products?

## Output standard

Write to `_workspace/huni-dbmap/01_excel/`:
- **workbook-structure.md** — per workbook → per sheet → blocks found (title, range, type).
- **discount-brackets.csv** — header: `source_sheet,source_range,discount_group,min_qty,max_qty,rate_raw,rate_pct,apply_scope_text`.
- **extraction-notes.md** — ambiguities, parsing decisions, open questions.

## Hygiene

If you write a throwaway parsing script, place it under `_workspace/huni-dbmap/_meta/` and remove it when done, or inline it with `python3 -c`. Do not leave scratch scripts in the repo root.
