# Curation Pack — silsa (실사)

> slug `silsa`(상품마스터 시트8·숨김행8·수식58 VAT파생·댓글9). 가격 = **포스터사인 면적매트릭스**(HARD).
> round-13: size 면적매트릭스 CORRECT(의심 반증)·끈/각목 자재+공정 BUNDLE.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/silsa/product-identity.md` | C13 | FRESH | `06_extract/silsa-l1.csv`·`silsa-l1-report.md`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/silsa/column-dictionary.md`·`product-bom.md`(면적형·화이트underbase) | C11 | FRESH | 메모리 dbmap-l2-requires-l1-price-table |
| **가격공식 사슬** | `02_mapping/silsa-poster-area-matrix/`·`silsa-price-engine/` (**포스터사인 [가로×세로] 면적매트릭스+ceiling**) | C2 | PARTIAL-STALE(I-1·I-3)·면적모델 FRESH | `06_extract/price-poster-sign-l1.csv`(B)·메모리 dbmap-silsa-price-via-poster-sign |
| **CPQ 옵션** | `10_configurator/silsa-option-layer-v2.md`·`silsa-live-reconciliation.md`(43행 COMMIT 파일럿) | C6/A | FRESH | `silsa-coverage-map.md` |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/silsa/loadlogic-notes.md` + `09_load/_exec_silsa_*/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/silsa/correction-manifest.md` + `_gate/silsa-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **가격을 실사 inline price(R/S/V)로 매핑 금지 [HARD].** 정답=포스터사인 [가로×세로] 면적매트릭스+ceiling. round-2 면적-좌표 회귀 오모델 금지(메모리 dbmap-silsa-price-via-poster-sign).
2. **size = 이산 면적매트릭스(가격표 권위), 입력UX≠가격격자(메모리 dbmap-l2-requires-l1-price-table).** silsa v1이 사이즈를 비치수 연속범위로 오판한 전례. round-13이 size 매트릭스 CORRECT로 반증 — 의심 반증분 채택.
3. **끈/각목 = 자재+공정 BUNDLE(메모리 dbmap-option-material-process-bundle).** silsa v1 공정만 반쪽매핑 → v2 자재.03+공정.04 BUNDLE. v1 인용 금지·v2 권위.
4. **`price-engine-ddl.md` 인용 금지(STALE).**
5. **silsa option_items 43행 COMMIT — 라이브 실재.** option_items 0행 표기(ref-csv) stale.

## 미해결 GAP / 🔴 컨펌

- 끈/각목 BUNDLE 적재(v2·라이브 일부 적재). [GAP-SL-1]
- 카테고리 고아 재연결(Q-SL-1·BATCH-1). [GAP-SL-2]
- 화이트 underbase 처리(round-11). [GAP-SL-3]
