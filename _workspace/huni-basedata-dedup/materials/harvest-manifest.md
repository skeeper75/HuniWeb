# Harvest Manifest — 자재 축 (t_mat_materials) — Phase 1 추출

추출시각: 2026-06-19 (KST)
추출가: hbd-source-harvester
방법론: hbd-source-harvest (라이브 read-only SELECT + 기존 dbmap 캐시 재사용 — .xlsx Read 0회)

## 출처 / freshness
| 출처 | 행수 / freshness | 용도 | 재사용 vs 신규 |
|------|-----------------|------|----------------|
| 라이브 t_mat_materials (Railway, read-only) | total **340** / del_yn='N' **192** / use_yn='Y' 340 / max upd_dt **2026-06-19 01:48:46** (round-22④ 자재정리분·stale 아님) | live | **신규** (오케스트레이터 착수전 재실측 기준값과 전건 일치) |
| 라이브 t_prd_product_materials | 772행 / 244 distinct mat_cd | product_bindings | 신규 |
| 라이브 t_prc_component_prices (mat_cd non-null) | 3,342행 / 68 distinct mat_cd | price_dependent | 신규 |
| `_workspace/huni-dbmap/24_master-extract-260610/calendar-l1.csv` | 삼각대컬러 컬럼 보유 | authority (삼각대 옵션값 출처) | **재사용** (round-11/12 추출) |
| `_workspace/huni-dbmap/24_master-extract-260610/design-calendar-l1.csv` | 삼각대(그레이/블랙) 옵션값 보유 | authority | **재사용** |
| `_workspace/huni-dbmap/00_schema/ref-materials.csv` | 336행 / mtime 2026-06-04 | (참고만) | **재사용 안 함 — STALE** (라이브 340으로 진화 +4·round-22④ 정리 미반영) |
| `_workspace/huni-dbmap/32_axis-staged-load/04_live-remeasure-260616.md` | 자재오염 진단 | authority(진단) | **재사용**(삼각대=자재→공정 오적재 C-CAL-01) |
| `_workspace/huni-dbmap/23_remediation-apply/calendar/cpq-plan.md` | 삼각대 귀속 분석 | authority(진단) | **재사용** |

★ ref-materials.csv(00_schema) STALE 적발: 336행 mtime 2026-06-04 vs 라이브 340행 max upd 2026-06-19. 사이즈 축(ref-sizes 497→520 stale)·공정 축(ref-processes 84 stale)과 동형 패턴. **권위=라이브 직접 추출**.

## MAT_TYPE 코드 의미 (t_cod_base_codes upr_cod_cd='MAT_TYPE' 실측)
.01 디지털인쇄용지 · .02 링제본부자재 · .03 아크릴부자재 · .04 하드커버부자재 · .05 특수소재 · .06 도장부자재 · .07 포장부자재 · .08 실사소재 · .09 봉제부자재 · .10 악세사리상품(추가상품) · .11 스티커용지 · .12 사입자재 · .13 합판스티커용지 · .14 합판봉투용지

활성 192 분포: .01(75)·.02(7)·.03(7)·.04(11)·.05(5)·.07(37)·.08(11)·.10(15)·.11(14)·.12(5)·.13(3)·.14(2).
★ .08 실사소재·.10 악세사리상품 = round-22④ 자재오염(색/형상/사이즈/구수가 자재행) 흔적·표시중복 본령 밖이나 참고.

## 행수 대조 (D1)
| 산출물 | 행수 | 대조 |
|--------|------|------|
| live.csv | 340 (데이터) | = 라이브 total 340 ✅ |
| live.csv 활성 | 192 | = 라이브 del_yn='N' 192 ✅ |
| index.csv | 192 | = 활성 자재 표준 인덱스 ✅ |
| authority.csv | 4 | 삼각대 그룹 권위 행(dedup-relevant)만 |

## 표시중복 그룹 (활성·mat_nm 동일·mat_cd 다름) — 전수 1그룹
| 그룹 | 멤버 (mat_cd·mat_typ_cd·부모·BOM바인딩·가격종속) | 권위 출처상품 |
|------|------|------|
| **삼각대(그레이)** | MAT_000032 (.02 링제본부자재·부모 MAT_000031 캘린더부자재·BOM **0**·가격 **0**) / MAT_000252 (.07 포장부자재·부모 없음·BOM **1**[PRD_000108 탁상형캘린더 USAGE.07]·가격 **0**) | 상품마스터 캘린더시트 탁상형캘린더(PRD_000108) `캘린더가공_삼각대컬러`=삼각대(그레이) → 라이브 MAT_000252 |

라이브 SELECT 전수 스캔(del_yn='N', mat_nm GROUP BY HAVING count>1) 결과 **표시중복 = 삼각대(그레이) 1그룹뿐** (오케스트레이터 재실측과 일치).

## price_dependent (가격종속 — ★신중 가드)
- t_prc_component_prices.mat_cd = 3,342행 / 68 distinct mat_cd 참조.
- index.csv price_dependent=Y: **66 코드** (활성 중·논리삭제 2 제외).
- ★자재 dedup은 **가격종속 축**(component_prices·t_prd_product_materials BOM 둘 다 참조). 중복그룹 정리 시 가격사슬/BOM CASCADE 위험 → dedup-analyst가 BLOCKED 가드 판정 필요.
- **단, 삼각대(그레이) 두 멤버는 둘 다 component_prices 미참조(가격종속 0)** — 가격사슬 영향 없음(가격무영향). BOM은 MAT_000252만 1건.

## 날조 0 선언
- live.csv·index.csv 모든 행은 라이브 t_mat_materials verbatim. 추론·날조 0.
- authority.csv는 상품마스터 260610 calendar-l1.csv / design-calendar-l1.csv의 실제 셀값 + 출처파일 경로 명시. "부재"(MAT_000032 권위 카운터파트)는 실제 미검출을 명시한 것(추측 아님).

## 토큰절약 노트
- .xlsx 2종 Read 0회. 라이브 SELECT + 기존 dbmap L1 캐시(calendar-l1·design-calendar-l1·round-22④ 진단) 재사용.
- 추출 결과는 집계/샘플만 표시. 전 행은 CSV로만 캐시.
