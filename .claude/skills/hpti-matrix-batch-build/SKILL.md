---
name: hpti-matrix-batch-build
description: 후니 인쇄상품 가격표 각 시트의 가격 매트릭스를 AI 토큰이 아닌 결정론 배치 스크립트로 분석·교정 적재하는 방법론(§26 가격테이블 무결성). 권위 CSV(24_master-extract)↔라이브 스냅샷 CSV(live-snapshot)를 grid-diff 스크립트로 비교해 미적재 셀·가로세로 transpose·정합 불일치·prc_typ 오타이핑·차원 누락을 토큰 거의 0으로 검출하고 교정 적재본(UPSERT/dryrun SQL)을 자동 생성한다. 에이전트는 시트별 매트릭스 파서+diff 규칙을 스크립트로 빌드·검수만, 실행은 스크립트. 시트 1개 파일럿→전 19시트 동형 전파. 상품마스터 배치 적재(dbm-batch-load)와 동형. 트리거: 가격테이블 배치 빌드, 매트릭스 결정론 diff, 권위 스냅샷 비교 스크립트, 시트 적재본 자동생성, 토큰 절약 가격 분석, 배치 빌더, 시트 매트릭스 배치, 결정론 diff 다시. AI가 매 셀 분석하는 방식(load-inspector 자연어 대조)은 토큰 폭발이라 이 배치 방식으로 대체한다.
---

# hpti-matrix-batch-build — 가격테이블 결정론 배치 빌드 방법론

목적: 가격테이블 무결성 분석을 **토큰 0에 수렴**시킨다. 권위도 CSV·라이브도 CSV(스냅샷)이므로 **코드 diff**면 충분하다. AI는 시트 1개의 변환 규칙을 코드화하고, 스크립트가 전 셀·전 시트를 처리한다.

## 1. 왜 배치 빌드인가 (토큰 경제)

AI 에이전트가 19시트 × 수천 셀을 자연어로 읽고 대조하면 토큰이 시트마다 폭발한다. 그러나 결함 판정은 **결정론 규칙**(권위 셀 vs 스냅샷 셀의 일치/불일치)이라 AI 추론이 필요 없다. 그래서:
- **AI의 일** = 시트 1개의 매트릭스 구조(차원 축·단가 위치)를 읽고 **파서+diff 규칙을 코드화**(토큰 1회) + 결함보드 요약·예외 판단.
- **스크립트의 일** = 권위 CSV↔스냅샷 CSV를 셀 단위 diff → 결함보드·적재본 생성(토큰 0·재실행 가능).

상품마스터 구성요소를 `dbm-batch-load` 동형 클래스 배치로 적재한 것과 같은 원리를 가격테이블에 적용한다.

## 2. 파이프라인 (시트당)

```
권위 격자 CSV (24_master-extract/<sheet>-l1.csv)
      │  matrix_parse.py  ── 시트 어댑터(차원 축·단가 셀 매핑)
      ▼
정규 격자 (자재 × 차원1 × 차원2 … → 단가·prc_typ)
      │  grid_diff.py  ── vs 스냅샷(live-snapshot/latest/t_prc_component_prices.csv)
      ▼
결함보드 CSV (미적재셀·transpose·불일치·prc_typ·차원누락 + 돈영향)
      │  build_load.py  ── 권위 verbatim UPSERT 생성
      ▼
교정 적재본 (<sheet>-load.sql + -dryrun.sql)  → 게이트·인간 승인 → COMMIT
```

## 3. scripts/ 인터페이스 (빌더가 구현·공용 엔진 + 시트 어댑터)

`_workspace/huni-price-table-integrity/_batch/scripts/`:
- **`matrix_parse.py`** — 입력 시트 L1 CSV → 정규 격자(dict/DataFrame). 공용 코어 + `ADAPTERS[sheet]`(시트별 차원 축·단가 칼럼·prc_typ 규칙). 새 시트 = 어댑터 1개 추가.
- **`grid_diff.py`** — 정규 격자 ↔ 스냅샷 CSV 셀 diff. §검출 규칙(미적재/transpose/불일치/prc_typ/차원누락)을 함수로. transpose는 (w,h)↔(h,w) 매치율 비교. prc_typ은 note 패턴+min_qty.
- **`build_load.py`** — 결함보드 → 권위 verbatim UPSERT/UPDATE SQL + dryrun(BEGIN…ROLLBACK). 단가값 불변.
- **lib 재사용**: `_workspace/_foundation/batch/lib_huni.py`(CSV 로더·코드 헬퍼). 중복 구현 금지.

결정론 [HARD]: 같은 (권위 CSV + 스냅샷 CSV) → 같은 결함보드. 시각·랜덤·외부상태 금지.

## 4. 시트 어댑터 패턴 (전파의 핵심)

시트마다 다른 것은 **차원 축 매핑**뿐이다(면적=가로×세로·밴드=수량구간·고정=siz_cd). 공용 엔진은 그대로 두고 어댑터만 추가:
```python
ADAPTERS = {
  "digital-print": {"dims": ["plt_siz_cd","print_opt_cd","min_qty"], "price_col": "unit_price"},
  "poster-sign":   {"dims": ["siz_width","siz_height"], "grid": "area"},
  # 새 시트 = 여기에 1줄
}
```
파일럿(디지털인쇄비) 완성 → 어댑터 추가로 booklet·silsa·goods-pouch… 전파.

## 5. 스냅샷 신선도 [HARD]

스냅샷은 시점 사진이다. 라이브 COMMIT 후엔 stale. 돈크리티컬 적재본 만들기 전:
- `_workspace/_foundation/live-snapshot/db-check.sh` 행수 ↔ `latest/_manifest.csv` 대조.
- 불일치면 `snapshot.sh` 재생성 후 diff 재실행(토큰 0).

## 6. 위상·안전 [HARD]

권위=엑셀(절대)·라이브=감사대상·스냅샷=거울. 라이브 읽기전용(스냅샷 사용)·DB 미적재. 적재본은 생성측 산출 — 게이트 골든 시뮬 + codex 스냅샷 교차 후 인간 승인 COMMIT(dbmap). webadmin 코드 미변경. 결함보드·적재본 모두 재현 SQL·돈영향 명시.

## 재사용

`24_master-extract-260610/*-l1.csv`(권위)·`live-snapshot/latest/`(라이브)·`batch/lib_huni.py`(로더)·`price-table-formula-structure-map.csv`(차원맵)·`price-dimension-layout-method.md`(off-grid 규칙). 기존 시트별 진단(명함·포스터)을 어댑터 검증 케이스로.
