# 포스터사인/실사 면적격자 — 적재 무결성 진단 (load-inspector·생성측)

> 2026-06-29. 권위=인쇄상품가격표 260527 "포스터사인" 시트 [가로(열)×세로(행)] 면적매트릭스(절대)·라이브 읽기전용 SELECT·DB 미적재.
> ★생성측 가설. integrity-gate 독립 재실측·인간 승인 후 COMMIT. codex high 교차 완료(수렴). 기존 추출 재사용(silsa-poster-area-matrix mapping·price-poster-sign-l1·FINDING-silsa-sizcd).
> 아크릴·스티커 §26 면적격자 패턴 동형 적용. off-grid=ceiling(한단계 큰 셀).

## 0. 종합 — 두 결함 (★1순위=transpose)

| # | 결함 | 범위 | 돈영향 | 우선순위 |
|---|---|---|---|---|
| **DEF-1** | ★가로↔세로 transpose 오적재 | 11 포스터 + 2 현수막 = **13 comp** (면적격자 559+셀) | **silent 오가격·과청구·상한초과 견적불가** (대칭셀만 우연히 정확) | **P0(돈크리티컬)** |
| **DEF-2** | silsa siz_cd 오적재 | 9 상품(폼보드/포맥스/액자/족자 등) | 견적0 | P1 (FINDING-silsa-sizcd 진단·dryrun 준비됨) |

## 1. DEF-1 — 가로↔세로 transpose 오적재 (★신규 적발·돈크리티컬)

### 결함 본질
권위 포스터 면적매트릭스 축: **가로(width)≤1200 · 세로(height)≤3000** (포스터는 세로로 긴 형태).
라이브 t_prc_component_prices: **siz_width max=3000 · siz_height max=1800** = ★가로↔세로 뒤바뀜.
권위 (가로600,세로1400)=20000 → 라이브엔 (siz_width=1400,siz_height=600)=20000으로 적재(값은 transpose 일치).

### 엔진 영향 (pricing.py:45-50,157-177)
siz_width·siz_height는 각각 **독립 '이하 상한' ceiling 매칭**(swap 보정 없음·아크릴 no-swap 선례 동형).
상품 PRD_000118 nonspec=Y 자유치수 **w_max=1200·h_max=3000**(권위 축과 정합). 손님은 가로≤1200·세로≤3000 입력.
하지만 단가행 siz_width가 1400~3000이라 손님 입력(세로1400)과 매칭 불가 → 엉뚱한 셀 ceiling.

### swap 검증 (★transpose 확정 증거)
라이브 (siz_width,siz_height)를 swap=(h,w)해서 권위와 대조:

| 블록 | 상품 | 권위셀 | 직접일치 | ★swap후 일치 |
|---|---|---|---|---|
| B01 | 아트프린트포스터 | 52 | 17(33%) | **51(98%)** |
| B02 | 아트페이퍼포스터 | 39 | 6 | 37 |
| B03~B11 | 방수·접착방수·접착투명·아트패브릭·린넨·캔버스·레더·타이벡·메쉬 | 52 각 | 17 각 | 51 각 |
| **전 11 포스터** | | **559** | **176(31%)** | **★547(97%)** |
| B26 | 일반현수막 | 91 | 9 | 78 |
| B27 | 메쉬현수막 | (코팅포함셀) | 9 | 78 |

→ ★swap 후 97% 권위 복원 = transpose 오적재 확정. 직접 31%는 대칭셀(가로=세로)이 우연히 맞은 것.

### 시뮬레이터 실증 (라이브 엔진 실호출)
| 주문(아트프린트포스터 PRD_000118) | 라이브 final | 권위 정답 | 판정 |
|---|---|---|---|
| 가로600×세로1400 | **21,600** | 20,000 | ★과청구(엉뚱한 셀 ceiling) |
| 가로600×세로600(대칭) | 12,000 | 12,000 | 정확(대칭셀 무해) |
| 가로1200×세로600 | 20,000 | (라이브엔 transposed 셀로 존재) | 비대칭 영향권 |
- 세로>1200 포스터(긴 형태)는 전부 부정확. 가로 1200·세로 3000 같은 정상 장변 주문은 라이브 siz_height max=1800이라 **above_max → 견적불가** 가능.

### codex high 교차 (수렴)
- false-positive 낮음 확정. "현수막은 원래 가로가 길다" 반론 기각(권위/문서/입력범위 전부 세로가 김).
- 영향=견적0만 아니라 silent 오가격·과청구·미청구·상한초과 혼재.
- ★교정 가드: **일괄 swap 위험** — siz_cd 정본행과 격자행 혼재 시 재오염. → 라이브 실측 결과 **13 comp 전부 siz_cd행 0·wh격자행만**(혼재 없음·일괄 swap 안전 확인됨). codex 우려한 SIZ_000321 등은 이 comp엔 부재(superseded).

### 교정 방향
- **권위 verbatim 재적재**(가장 안전) 또는 **siz_width↔siz_height swap**(13 comp 격자행만·혼재 0 확인). 단가값 verbatim 불변.
- off-grid ceiling은 swap 후 정상축에서 정상 작동.
- 재현 SQL: `SELECT comp_cd,siz_width,siz_height,unit_price FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_POSTER%' AND siz_width>1200 ORDER BY comp_cd;` (권위 width≤1200 위배 행 = transpose).

## 2. DEF-2 — silsa siz_cd 오적재 9상품 (기존 진단 재사용·견적0)

`FINDING-silsa-sizcd-misload-260629.md` + `silsa-sizcd-rekey-260629-dryrun.sql`(35행·ROLLBACK 검증됨) 그대로 인계.
- 상품 옵션 siz_cd(정본 174/197/172/170/293) ≠ 단가행 siz_cd(중복본 315/317/258/426/294) → `_row_matches` no_match → 견적0.
- 교정=단가행 siz_cd 중복본→정본 재키잉 35행(값 불변·충돌0·1상품전용).
- 잔여 2(재키잉 무관·단가행 자체 부재): 레더액자132 소형4(304/306/308/310)·족자135 A1(293) → 권위 단가 추출 후 INSERT.
- 9상품: 폼보드129·포맥스130·프레임리스131·레더액자132·캔버스133·족자135·무광시트140·홀로그램141·미니보드144.

## 3. 차원 누락 점검 (false-positive 가드)
- 포스터/현수막 13 comp use_dims=[siz_width,siz_height(,min_qty)] = 면적축 정상 보유(차원 누락 아님). **결함은 축 값 transpose**이지 차원 부재 아님.
- silsa 9 comp use_dims=[siz_cd] = siz_cd 축 보유. 결함은 siz_cd **값 불일치**(오적재)이지 차원 부재 아님.

## 4. 요약
- **① 미적재 셀 규모**: 면적격자 sparse는 **순수 미적재가 아니라 transpose 오적재**(셀 수는 권위≈라이브, 좌표가 뒤바뀜). 메모리 "97% 미채번"은 round-2 sparse 시점 stale — 라이브는 전건 적재됨(단 축 뒤바뀜). 실제 미적재 셀=swap후 잔차 ~12셀(경계)+silsa 잔여 5셀(레더 소형4·족자 A1).
- **② 견적0 실사 상품**: silsa 9상품(siz_cd 오적재) + 포스터 장변 주문 above_max.
- **③ 차원/오적재 결함**: DEF-1 transpose 13 comp(559+셀)·DEF-2 silsa siz_cd 9상품(35행).
- **④ 우선순위·돈영향**: P0=transpose(13 comp·silent 과청구/오가격·돈크리티컬) → P1=silsa siz_cd(9상품 견적0). codex 합의=transpose 먼저.

## 라우팅
실 교정 = dbm-load-execution/dbm-correctness-audit(인간 승인 후). webadmin 엔진 미변경.
교정 후 시뮬레이터 전수 재실증 필수(아트프린트 600×1400=20,000 등). dryrun=`poster-transpose-dryrun.sql`(ROLLBACK).
★별도 트랜잭션/별도 게이트: transpose(DEF-1)·silsa(DEF-2) 분리 준비(codex 권고).
