# Curation Pack — acrylic (아크릴)

> slug `acrylic`(상품마스터 시트9·숨김행10·댓글8). 가격 `acrylic-price`(7블록·면적매트릭스+구간할인·미러=투명×2).
> round-13: print_side에 UV변형 20상품 오적재(정답 PROC_000002)·완칼 묵시.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/acrylic/product-identity.md` | C13 | FRESH | `06_extract/acrylic-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/acrylic/column-dictionary.md`·`product-bom.md`(두께자재·UV) | C11 | FRESH | 메모리 round-11(round-3 G-AC-1~9) |
| **가격공식 사슬** | `02_mapping/silsa-poster-area-matrix/`(면적매트릭스 동형) + `09_load/_migrate_areamatrix/` + `06_extract/price-acrylic-price-l1.csv` | C2/B | PARTIAL-STALE(I-1·I-3)·면적모델 FRESH | 메모리 dbmap-price-formula-types-authority |
| **CPQ 옵션** | `10_configurator/attribute-entity-map.md` 아크릴부 | C6 | PARTIAL-STALE(I-5·I-9) | `huni-widget/03_spec/s4-acryl-spec.md`(D) |
| **위젯 계약** | `huni-widget/03_spec/s4-acryl-spec.md` | D | FRESH | `data-contract.md` |
| **webadmin 적재 경로** | `17_correctness/acrylic/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/acrylic/correction-manifest.md` + `_gate/acrylic-gate.md`(F-AC-G1/G2 보정) | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **print_side에 UV변형 오적재(round-13·F-AC-G2 보정).** 20상품 print_side·14 UV → 정답 PROC_000002(UV 공정). 라이브 print_side값 인용 시 correction-manifest 대조. 검증된 카운트=print_side 20·UV 14(crosscut §7).
2. **완칼 묵시(round-11).** 아크릴 완칼은 묵시 — 명시 안 돼도 적용. 형상 siz_cd.
3. **미러=투명×2(가격 수식81).** 미러 가격은 투명×2 면적매트릭스. 가격 인용 시 면적매트릭스 권위.
4. **`price-engine-ddl.md` 인용 금지(STALE).** 면적매트릭스는 silsa-poster-area-matrix.
5. **round-3 G-AC-1~9(메모리 round-11).** 아크릴미니파츠 변형행(round-10 델타 −16).

## 미해결 GAP / 🔴 컨펌

- 🔴 print_side UV 일괄 교정 PROC_000002(round-13 acrylic). [GAP-AC-1]
- 두께=자재 차원 확정(round-11). [GAP-AC-2]
- CPQ 옵션 미적재(BATCH-6). [GAP-AC-3]
