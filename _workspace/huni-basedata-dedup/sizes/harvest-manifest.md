# Harvest Manifest — 사이즈 축 (t_siz_sizes) — Phase 1 추출

추출시각: 2026-06-19 07:28:20 KST
추출가: hbd-source-harvester
방법론: hbd-source-harvest (스크립트 전용 — .xlsx Read 0회)

## 출처 파일 (스크립트 openpyxl data_only=True 로만 읽음)
| 파일 | mtime(epoch) | 용도 |
|------|-------------|------|
| docs/huni/후니프린팅_상품마스터_260610.xlsx | 1781047427 | authority(master) — 사이즈(필수)/작업·재단/가로·세로 |
| docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx | 1779853150 | authority(pricetable) — 면적매트릭스/판형/규격 축 라벨 |
| 라이브 t_siz_sizes (Railway) | (read-only SELECT) | live — 520행 |
| 라이브 t_prc_component_prices | (read-only SELECT) | price_dependent 집계 |
| 라이브 t_prd_product_sizes / t_prd_product_plate_sizes | (read-only SELECT) | product_bindings |

## 재사용 vs 신규
- **재사용 안 함(stale)**: 00_schema/ref-sizes.csv (497행, mtime 1780582493) — 라이브가 520행으로 진화(+23)·del_yn 컬럼 부재 → **신규 라이브 재추출**(live.csv 520행, del_yn 포함).
- **신규**: authority(master)·authority(pricetable)·price_dependent·bindings 전부 이 트랙에서 신규 추출.
- L1 추출본(24_master-extract-260610/*-l1.csv)은 가로형 전컬럼이라 사이즈 단독 인덱스엔 부적합 → 마스터 직접 재파싱.

## 행수
| 산출물 | 행수 |
|--------|------|
| live.csv | 520 |
| authority.csv | 1039 (master 756 + pricetable 283) |
| index.csv | 520 (라이브 siz_cd 기준 표준 인덱스) |

## price_dependent 분포 (component_prices siz_cd 참조)
- Y(가격종속) = 84  /  N = 436
- ★가격종속 84행은 라이브 직접 교정/삭제 시 가격사슬 CASCADE 위험(경로 Y 필요).

## 부가 사실
- source 크로스워크: index 520 중 both(라이브 siz_nm = 권위 디스플레이 정규화 일치) = 98, live-only = 422.
- del_yn=Y(논리삭제) = 65행.
- component_prices 7288행 중 siz_width/height(비규격 구간축) 사용 = 922행 (면적매트릭스 — 포스터사인/아크릴/실사).

## 토큰절약 노트
- .xlsx 2종을 Read로 컨텍스트 로드했다면 수만 토큰. openpyxl 스크립트 CSV 추출로 헤더+샘플 3줄만 표시 → 수백 토큰.
- 이후 탐색은 4개 CSV(live/authority/index/_집계)에 Grep·집계로 수십 토큰.

## 산출물 경로
- _workspace/huni-basedata-dedup/sizes/live.csv
- _workspace/huni-basedata-dedup/sizes/authority.csv
- _workspace/huni-basedata-dedup/sizes/index.csv
- _workspace/huni-basedata-dedup/sizes/harvest-manifest.md
- (중간) _authority_master.csv · _authority_pricetable.csv · _price_dep.csv · _prd_bind.csv · _plate_bind.csv
