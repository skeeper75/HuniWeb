# Curation Pack — calendar (캘린더 + 디자인캘린더)

> slug `calendar`(상품마스터 시트6·별도설정 4건) + `design-calendar`(시트7·가격포함·1상품+에디터템플릿).
> **design-calendar 분리 결정:** 별도 pack 분리하지 않는다. 이유: round-13/12 산출이 calendar 디렉토리에 design-calendar를 합산 처리(`17_correctness/calendar/`·`16_*/calendar/`에 통합), 실무진 Q(디자인=1상품+에디터템플릿)로 캘린더 본체와 동일 가격/공정 사슬·디자인캘린더는 에디터템플릿 축만 추가. → **본 pack 내 §디자인캘린더 하위절로 다룬다.**

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/calendar/product-identity.md`(캘린더+디자인캘린더) | C13 | FRESH | `06_extract/calendar-l1.csv`·`design-calendar-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/calendar/column-dictionary.md`·`product-bom.md` | C11 | FRESH | `16_*/calendar/mapping-final.md`(C12) |
| **가격공식 사슬** | `02_mapping/price211-booklet-photobook/`(제본·캘린더) + `06_extract/price-binding-l1.csv` | C2/B | PARTIAL-STALE(I-1·I-3) | 메모리 dbmap-process-select-group(다중공정 택일) |
| **CPQ 옵션** | `16_*/calendar/mapping-final.md` 옵션부 | C12 | PARTIAL-STALE(I-5·I-9) | — |
| **위젯 계약** | `huni-widget/03_spec/s6-calendar-spec.md` | D | FRESH | `data-contract.md` |
| **webadmin 적재 경로** | `17_correctness/calendar/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/calendar/correction-manifest.md` + `_gate/calendar-gate.md` | C13 | FRESH | `live-diff.md` |

## 디자인캘린더 (하위절)

- 정체: 1상품 + 에디터템플릿(실무진 Q·메모리 round-11). 가격포함 시트(`design-calendar-l1.csv`).
- 가격/공정: 캘린더 본체와 동일 사슬. 디자인=에디터템플릿 축(Edicus 연동·`huni-widget/03_spec/editor-integration.md`).
- 결함: `17_correctness/calendar/` 통합 처리(CL-F 미니 카테고리 등).

## stale 함정

1. **삼각대/링 자재 오적재(round-13·②).** 캘린더 삼각대·링이 자재 오적재 → 자재 분리/공정 검토. 라이브 자재값 인용 시 correction-manifest 대조.
2. **plate .01↔load_master .03 재적재 퇴행(round-13·추가-C).** plate output_paper 값정답이나 적재경로 퇴행 위험(.01↔.03). live-crosscheck 인용 주의.
3. **다중공정 UI택일(메모리 dbmap-process-select-group).** 인쇄방식별 레시피로 해석. N/A를 원천부재로 닫지 말 것.
4. **`price-engine-ddl.md` 인용 금지(STALE).**
5. **CL-F 미니 카테고리 고아(횡단①).**

## 미해결 GAP / 🔴 컨펌

- 🔴 삼각대/링 자재 분리(BATCH-2/13·신규 공정 삼각대거치). [GAP-CL-1]
- plate .01↔.03 적재경로 정정(BATCH-10). [GAP-CL-2]
- 미니 카테고리 재연결(BATCH-1·CL-F). [GAP-CL-3]
