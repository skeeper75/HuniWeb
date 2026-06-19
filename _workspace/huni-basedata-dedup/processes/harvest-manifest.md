# Harvest Manifest — 공정 축 (t_proc_processes) — Phase 1 추출

추출시각: 2026-06-19 (KST)
추출가: hbd-source-harvester
방법론: hbd-source-harvest (라이브 read-only SELECT + 기존 dbmap 캐시 재사용 — .xlsx Read 0회)

## 출처 / freshness
| 출처 | 행수 / mtime | 용도 | 재사용 vs 신규 |
|------|-------------|------|----------------|
| 라이브 t_proc_processes (Railway, read-only) | total 102 / del_yn='N' 101 / use_yn='Y' 102 / max upd_dt **2026-06-18 02:10:28** | live | **신규** (오라클 기준값과 전건 일치) |
| 라이브 t_prd_product_processes | (집계) | product_bindings | 신규 |
| 라이브 t_prc_component_prices | proc_cd non-null 1,919행 / 24 distinct | price_dependent | 신규 |
| `_workspace/huni-dbmap/04_audit/v2/process-expected.csv` | 206행 / 34 distinct proc_cd / mtime 2026-06-05 | authority (master 260610 crosswalk) | **재사용** (round-12 검증 GO 산출) |
| `_workspace/huni-dbmap/00_schema/ref-processes.csv` | 84행 / mtime 2026-06-04 | (참고만) | **재사용 안 함 — STALE** (라이브 102로 진화 +18·UV upr_proc_cd 불일치) |
| `_workspace/huni-dbmap/04_audit/excel-process.csv` | 280행 / mtime 2026-06-04 | (참고만) | 재사용 안 함 (정규화 안 된 UI 토큰 soup, 공정명 권위 아님) |

## 스키마 노트 (사이즈 축과의 차이)
- **proc_typ_cd 컬럼 없음.** 공정 유형/파라미터는 `prcs_dtl_opt` (jsonb)에 인코딩 (예 줄수/조각수/구수/유형 enum). raw_value_json에 이 jsonb + upr_proc_cd + disp_seq를 담았다.
- **upr_proc_cd (자기참조 FK)** 가 의미축 핵심. 표시명이 같아도 부모가 다르면 다른 의미 (핑크 사례).

## 행수 대조 (D1)
| 산출물 | 행수 | 대조 |
|--------|------|------|
| live.csv | 102 (데이터) | = 라이브 total 102 ✅ |
| index.csv | 102 | = 라이브 siz_cd 기준 표준 인덱스 ✅ |
| authority.csv | 206 | = process-expected.csv verbatim (master 260610 crosswalk) |

## price_dependent (★레지스트리 정정)
- 레지스트리는 "N: 단가행 proc_cd 없음"이라 했으나 **직접 재확인 결과 거짓** — t_prc_component_prices.proc_cd에 **1,919행 (24 distinct proc_cd)** 이 실재.
- index.csv price_dependent=Y: **25 코드** (component_prices가 그 proc_cd를 참조).
- ★공정 dedup은 **가격종속**이다. 중복그룹 정리 시 가격사슬 CASCADE 위험 → BLOCKED 가드 필요.

## 부가 사실
- 13 중복그룹 중 **11그룹 = 부모(rich)/자식(thin) 쌍** — 자식(PROC_000086~096)은 전부 2026-06-17 00:54 일괄 INSERT·prcs_dtl_opt 공란·note 공란·disp_seq=1·**product_bindings 0**·upr_proc_cd→부모. authority crosswalk에 자식 코드 전무(부모만 존재).
- UV는 3-way (002 root rich + 016 child of 013 + 097 child of 002).
- **핑크(010/036)는 부모/자식 쌍 아님** — 서로 다른 부모(007 vs 033) 아래 형제. 010은 price_cp 212행. → 의미축 분리(2인쇄방식) 가능성, 진짜중복 아닐 수 있음.
- del_yn=Y(논리삭제) = 1행 (live total 102 중).

## 토큰절약 노트
- .xlsx 2종 Read 0회. 라이브 SELECT + 기존 검증 캐시(process-expected) 재사용. 추출 결과는 집계/샘플만 표시.
- 이후 dedup-analyst 탐색은 4 CSV(live/authority/index/_집계)에 Grep·집계로 처리.

## 날조 0 선언
- live.csv·authority.csv는 라이브/캐시 verbatim. index.csv는 그 둘의 결정적 조인(파생 추론 0).

## 산출물 경로
- `_workspace/huni-basedata-dedup/processes/live.csv` (102행, 11컬럼)
- `_workspace/huni-basedata-dedup/processes/authority.csv` (206행, master crosswalk)
- `_workspace/huni-basedata-dedup/processes/index.csv` (102행, 표준 인덱스 9컬럼)
- `_workspace/huni-basedata-dedup/processes/harvest-manifest.md`
- (중간) `_prd_bind.csv` · `_price_dep.csv`
