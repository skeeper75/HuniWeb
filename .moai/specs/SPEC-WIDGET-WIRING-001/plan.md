---
id: SPEC-WIDGET-WIRING-001
doc: plan
version: "0.1.0"
updated: 2026-08-21
---

# 실행 계획 — SPEC-WIDGET-WIRING-001

> 원칙: **재사용 최대·mint 최소**. 신규 코드는 어댑터/하베스터/조립기/아티팩트 4개뿐(총 ~700줄 [추정]).
> 전 단계 결정론·토큰 0. 라이브·`raw/` 읽기 전용.

## 0. 산출물 트리

```
_workspace/huni-widget-wiring/
├─ CONSULT-DENOMINATOR-260821.md          (기존 입력)
├─ out/
│  ├─ sim-meta/<prd_cd>.json              M3 하베스터 산출(266)
│  ├─ defects/widget-defects.jsonl        M2 어댑터 산출(Defect)
│  ├─ defects/price-defects.jsonl         M1 hdx 보드 산출(승계)
│  ├─ wiring-health/<prd_cd>.json         M4 조립 산출(§5 스키마)
│  ├─ wiring-health-index.json            상품 요약 인덱스(아티팩트 1차 로드)
│  └─ wiring-explorer.html                M5 아티팩트(자족 단일 HTML)
├─ bin/                                    신규 스크립트(4)
└─ HANDOFF.md · CHANGELOG.md
```

`hdx` 쪽 신규 파일 1개: `_workspace/_foundation/hdx/diagnose/widget_wiring_dx.py`.

## 1. 마일스톤

| M | 내용 | 산출 | 신규 코드 |
|---|---|---|---|
| **M0** | 스냅샷 갱신 + 분모 확정 | `live-snapshot/snap_*`(266행) | 0 (`snapshot.sh` 실행) |
| **M1** | hdx 가격 레이어 as-is 재실행 | `hdx/board/defect-board.csv` 갱신 | 0 |
| **M2** | 위젯 어댑터 Diagnoser | `widget_wiring_dx.py` + `widget-defects.jsonl` | ~250줄 |
| **M3** | sim-meta 하베스터 | `out/sim-meta/*.json` | ~120줄 |
| **M4** | wiring-health 조립기 | `out/wiring-health/*.json` + index | ~180줄 |
| **M5** | 인터랙티브 아티팩트 | `wiring-explorer.html` | ~1 파일 |
| **M6** | 결과 요약 + 교정 라우팅 worklist | `REPORT-260821.md` · `worklist.csv` | 조립기 재사용 |

M0→M1→(M2 ∥ M3)→M4→M5→M6. M2 와 M3 는 서로 독립 — 병렬 실행.

## 2. M0 — 스냅샷 갱신

```bash
bash _workspace/_foundation/live-snapshot/snapshot.sh          # .env.local RAILWAY_DB_* 사용
python3 - <<'PY'   # 분모 검증(활성 266)
PY
```
- 게이트: `t_prd_products` 활성 행수 == 라이브 실측. 불일치 시 **정지**.
- 스냅샷 디렉토리명(`snap_YYYYMMDD_HHMM`)을 이후 전 산출물에 각인.

## 3. M1 — 가격 레이어 재실행 (무수정)

```bash
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price --round N --note "widget-wiring t1"
```
- `hdx` 코드 **변경 금지**. 산출 `board/defect-board.csv` 를 M4 입력으로 승계.
- 승계 대상 차원: `wiring`(E1·E2) · `dim_conformance`(E3) · `calcability`(E4) · `option_cpq`(W5) ·
  `contribution` · `qty_rule` · `platesize` · `price_grid` · `component_merge`.

## 4. M2 — `widget_wiring_dx.py` (어댑터)

구조(§spec R3):

| 서브 어댑터 | 원본 | 방식 | 엣지 |
|---|---|---|---|
| `_opt_ref()` | `tools/verify_option_ref_integrity.py --json` | subprocess JSONL | W2(PARENT_DEAD)·W4 |
| `_coverage()` | `tools/verify_price_coverage.py --json` | subprocess JSONL | E3·E4 |
| `_zero()` | `tools/verify_zero_quote.py --json` | subprocess JSONL | E4(치명) |
| `_constraints()` | `tools/audit_constraints.py` | 판정부 verbatim 이식(`foundation.db`) | C1 |
| `_optcode()` | `tools/verify_optcode_integrity.py` [2][3] | 판정부 verbatim 이식(`foundation.db`) | W1·W2·W3·C1 |

- 매핑 규약: 원본 코드(`ANCHOR_DELETED` 등) → `Defect(dimension=<엣지ID>, summary, severity, money_impact,
  prd_cd, evidence={원본 레코드 verbatim}, suggested_fix=원본 권고)`.
- severity 승계: `verify_option_ref_integrity.SEV`(`:70-71`) · `FAIL_CODES`/`WARN_CODES`(`:73-78`) 그대로.
- `stop_predicate` = 치명 코드 0(비치명 `PARENT_DEAD` 는 비게이팅 — 원본 정책 승계).
- 실행 전제: `raw/webadmin/../.venv` + `DATABASE_URL`. 부재 시 **명시 FAIL**(묵음 스킵 금지).
- 드리프트 게이트: 어댑터 카운트 == 원본 센서 콘솔 카운트(코드별). 불일치 = FAIL.

## 5. M3 — sim-meta 하베스터 `bin/harvest_sim_meta.py`

- Django 셋업 후 `from catalog import price_views as PV`,
  266 `prd_cd` 루프 → `PV._build_sim_meta(prd_cd, customer=True)` + `PV._set_members_meta(...)`.
- **읽기 전용**: `_build_sim_meta` 는 조회 전용(`price_views.py:1877-1917`). write 경로 호출 금지.
- 예외 상품은 `{"error": "..."}` 로 기록하고 계속(전수 중단 금지).
- 위젯 가시성 태깅: `widget_api._grp_opt`/`_runtime_meta` 화이트리스트 키 집합을 상수로 복사해
  각 노드에 `"visible": true|false` 를 붙인다(내부 필드는 아티팩트에서 별도 색).

## 6. M4 — 조립기 `bin/build_wiring_health.py`

입력: `sim-meta/*.json`(계층) + `widget-defects.jsonl` + `price-defects`(hdx 보드) + 스냅샷 CSV(단가행 수).
처리:
1. 결함을 `(prd_cd, 엣지, 노드키)` 로 인덱싱 → 계층 트리 노드에 **부착**(옵션항목 단위까지).
2. `price_rows` = comp 별 `t_prc_component_prices` 행수(스냅샷 집계).
3. `reachable_ratio` = (단가행 매칭 가능한 등록 차원값 수)/(등록 차원값 수) — `verify_price_coverage`
   의 any-row-exists 판정 결과를 그대로 집계(재계산 금지).
4. verdict 규칙(§spec R5) 적용 → `broken_edges` · `money_impact` 집계.
5. `remediation[]` = `hdx` 교정 라우팅 6클래스로 분류(값 날조 금지 원칙 승계 — SQL 생성 없음).

## 7. M5 — 아티팩트 `wiring-explorer.html`

- 좌: 상품 리스트(검색·verdict/엣지/돈영향 필터·정렬). 우: 선택 상품의 계층 트리 + 가격축 체인.
- 단절 표현: 끊긴 엣지는 점선·경고색 + 결함코드 배지 + 클릭 시 evidence 원문 패널.
- 요약 헤더: 분모/스냅샷/전역 GO·NO-GO/엣지별 결함 히트맵(10 엣지 × 상품군).
- 데이터 인라인 임베드(외부 fetch 0). 후니 DS 톤 준수, 라이트/다크 모두 명시 색.
- 참고 선례: `_workspace/huni-webadmin-load/batch-scan/drift-dashboard.html`,
  `hdx/board/defect-board.html`(실무진 필터/정렬 UI).

## 8. M6 — 보고·교정 라우팅

- `REPORT-260821.md`: 분모·엣지별 결함 수·치명 상품 목록·돈영향 Top·다음 액션.
- `worklist.csv`: 결함 → 교정 클래스 → 담당(권위/설계/실무진) → 근거.
- [HARD] 실 COMMIT·webadmin 반영은 인간 게이트. 본 SPEC 범위는 명세까지.

## 9. 실행 순서 요약

```bash
# M0
bash _workspace/_foundation/live-snapshot/snapshot.sh
# M1
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price
# M2 ∥ M3
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope widget
python3 _workspace/huni-widget-wiring/bin/harvest_sim_meta.py
# M4 → M5
python3 _workspace/huni-widget-wiring/bin/build_wiring_health.py
python3 _workspace/huni-widget-wiring/bin/build_artifact.py
```

## 10. 워크트리 주의 [HARD]

본 SPEC 은 워크트리 `design-viewer` 에서 작성됐다(`.claude/worktrees/design-viewer/.moai/specs/...`).
run 세션이 메인 체크아웃에서 진행된다면 **SPEC 3종을 메인으로 옮기거나 브랜치를 병합**해야 한다.
`_workspace/huni-widget-wiring/**` 는 메인 체크아웃에만 존재한다.
