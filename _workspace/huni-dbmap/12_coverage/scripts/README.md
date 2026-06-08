# 재현 스크립트 — round-7 입체 커버리지 (C8)

결정적 파이프라인. 같은 입력(06_extract L1 CSV + 라이브 DB) → 같은 매트릭스.

## 실행 순서

```bash
cd _workspace/huni-dbmap/12_coverage/scripts

# 1) 엑셀 권위 → 상품군별 필요요소 (라이브 DB 불필요, 결정적)
python3 extract_excel_requirements.py        # → ../excel-requirements.csv

# 2) 라이브 DB 실측 행수 (읽기전용 SELECT, .env.local RAILWAY_DB_* 필요)
bash probe_db_coverage.sh                     # → ../db-coverage-raw.csv

# 3) 조립 → 매트릭스 + 셀 CSV
python3 build_matrix.py                       # → ../coverage-matrix.md, ../coverage-cells.csv
```

## 입력

| 입력 | 경로 | 권위 |
|------|------|------|
| 상품군 L1 충실추출 | `06_extract/<slug>-l1.csv` (11 상품군) | 엑셀 명시값 = 필요요소 정답 |
| family↔prd_cd 해소 | `scripts/family-prd-map.csv` (prd_nm 조인, 250행) | 라이브 prd_nm 조인 산출 |
| 라이브 DB | `.env.local` `RAILWAY_DB_*` | 적재 사실(읽기전용) |

## family-prd-map.csv 재생성 (해소 키 변경 시만)

`prd_nm` 조인(MES_ITEM_CD 전부 NULL — 유일 가능 키). 11 상품군 L1 의 distinct 상품명을 라이브
`t_prd_products.prd_nm` 에 LEFT JOIN. 264 (family,prd_nm) 중 250 해소·14 미해소(★신규·보류·코멘트).
재생성 절차는 `../coverage-matrix.md` 해소 캐비엇 참조.

## 산출 (모두 `../` = 12_coverage/)

- `excel-requirements.csv` — (family, entity, required, evidence_columns)
- `db-coverage-raw.csv` — (family, entity, prds_in_family, prds_with_rows, total_rows)
- `coverage-cells.csv` — (family, entity, required, state, n, wr, tr, source_cell, note) 1행/셀
- `coverage-matrix.md` — 행=엔티티 × 열=상품군 매트릭스 + 범례 + 집계 + 3원대조 + 캐비엇

## 판정 규칙 (build_matrix.py state_of)

| 조건 | 상태 |
|------|------|
| required=Y & wr=n>0 | ✅ LOADED |
| required=Y & 0<wr<n | 🟡 PARTIAL |
| required=Y & tr=0 | ❌ MISSING |
| required=N & tr>0 | ◆ DB-ONLY (엑셀 미요구·DB 행존재) |
| required=N & tr=0 | ➖ N/A |

## 필요요소 도출 정교화 (C2 — 추측 0)

- plate_sizes: `출력용지규격` 컬럼이 **실제 치수값**(316x467 등)일 때만 필요. silsa 처럼 노트
  ("*후가공에따라...")만 있으면 N (`has_dimension_values` 가드).
- bundle_qtys: `개별포장`만. `판수`(=판걸이수/임포지션)는 앱 계산이므로 제외.
- templates: `주문방법(필수)_편집기`=Y 상품이 있을 때만(범용 '편집기' substring·페이지(편집기) 오매칭 방지).
- 가격: 마스터 inline 가격 컬럼 OR 전용 가격표 단가시트(`PRICE_TABLE_FAMILIES`) 존재 시 필요.
- DB-ONLY 후보(외부 권위 적재)는 required=Y 자동전환 안 함 → gap-board 가 권위 대조 라우팅.
