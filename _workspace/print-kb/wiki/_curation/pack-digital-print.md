# Curation Pack — digital-print (디지털인쇄)

> slug `digital-print` · 상품마스터 시트2(가장 복잡·별도설정 9건). 엽서·명함·상품권·배경지·라벨택 등.
> freshness 권위: impact-diagnosis. round-13 결함 18건(C-01~C-18).

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/digital-print/product-identity.md`(실제 사이트 대조) | C13 | FRESH | `06_extract/digital-print-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/digital-print/column-dictionary.md`·`product-bom.md`(44컬럼·BOM) | C11 | FRESH | `16_*/digital-print/mapping-final.md`(C12) |
| **가격공식 사슬** | `02_mapping/digital-print-engine/`(원자합산형 PRF_DGP_A~F+용지비) | C2 | PARTIAL-STALE(I-1·I-2) — 공식사슬 FRESH | `06_extract/price-digital-print-price-l1.csv`(B) |
| **CPQ 옵션** | `10_configurator/postcard-option-layer.md`(엽서 파일럿) | C6 | FRESH | `attribute-entity-map.md` |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md`·`component-tree.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/digital-print/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | `_loadspec/loadspec.md`(PARTIAL I-4·5·6) |
| **결함 현황** | `17_correctness/digital-print/correction-manifest.md`(C-01~C-18) + `_gate/digital-print-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **`16_*/digital-print/mapping-final.md` "180g 코팅→constraint_json" — STALE(I-5).** 적재 타깃 무효. 제약=constraints.logic.
2. **`17_correctness/digital-print/extraction-plan.md` L56 dep_proc_cd oracle — STALE(I-6).** oracle 재생성 필요.
3. **`price-engine-ddl.md` 인용 금지(STALE).** 디지털 가격은 02_mapping/digital-print-engine + sql/21·22.
4. **라이브 카테고리값 = 오적재 다수(round-13).** 상품권 041/042→CAT_000295 고아·배경지 043/044/045→CAT_000296 고아·라벨택 046→CAT_000296. 정답=정상노드(273/274/275/283). "현재값 vs 정답" 양면 표기.

## 결함 현황 요약 (round-13 C-01~18)

- CORRECT 5(엽서 size/공정/usage·라벨택 size + qty_unit/plate 값정답).
- MIS-LOADED 4(엽서 addon 일부·상품권/배경지/라벨택 카테고리 고아).
- MISSING 5(배경지/라벨택 전용 커팅 PROC_000053·배경지 접지 PROC_000056·봉투/케이스 세트).
- AMBIGUOUS 3(박 부모 PROC_000033·separator 하이픈/_·배경지 자재 재확인).

## 미해결 GAP / 🔴 컨펌

- 🔴 봉투/케이스 세트 모델(Q-ID-A·BATCH-5) — addon vs sets. [GAP-DP-1]
- 🔴 배경지/상품권 카테고리 재연결(Q-ID-B·BATCH-1). [GAP-DP-2]
- 🔴 박색 8자식 = 옵션풀 vs 부모 박 누락(C-06). [GAP-DP-3]
- separator 하이픈/_ 통일(C-17·BATCH). [GAP-DP-4]
