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
