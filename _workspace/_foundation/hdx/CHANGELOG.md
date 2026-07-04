# hdx — CHANGELOG (최신 위 PREPEND)

## 2026-07-04 — P3 교정생성 (`hdx/remediate/`)

**목표**: 진단 결함(Defect) → 교정본(Fix)을 공통 `Remediator` 계약으로 생성(설계 §2 L4).
자동은 교정본 생성까지 — 적재 COMMIT·webadmin 실화면은 인간 게이트(L7·[HARD]).

**[HARD] 값 날조 금지 라우팅**(핵심 설계): 단가값이 권위(엑셀/실무진)에서 와야 하는 결함은
**SQL 을 만들지 않는다** — `blocked_human`/`needs_authority`/`needs_design`/`review` worklist 로만.
`auto_data`(값 날조 없는 결정론 데이터/메타 교정)만 dryrun/fix/undo SQL 트리플 생성.
`foundation/models.py` `Fix` 확장: `remediation_class`·`worklist_note`·`root_comps`·`is_auto`(가산·P1 회귀 GO).

**5 Remediator**(`hdx/remediate/`) — 각 차원 Defect 를 분류·교정:
- `WiringRmd` — placeholder(PENDING/TBD) 빈배선 → blocked_human · 그 외 → needs_authority · 고아 → review
- `CalcabilityRmd` — placeholder wired → blocked_human(같은 근본원인) · 그 외 → needs_design
- `DimConformanceRmd` — **UNDECLARED → auto_data**(use_dims 선언 추가·메타·값 날조 없음) · MISSING → needs_authority
- `ContributionRmd` — HIGH → needs_design(§18) · 저신뢰/유령 → review
- `ComponentMergeRmd` — A/B → auto_data(실 SQL 은 검증된 `gen_commit_sql.py` 승계)

**plan(`plan.py`)**: Fix 병합(**입체 근본원인 dedup**: 같은 root_comps 가 여러 차원에 걸치면 하나로)
→ `remediation-plan.md`(분류별 worklist·실무진 열람) + `.csv` + `sql/*.{dryrun,fix,undo}.sql`(auto_data 만).

**SQL 패턴 승계**(`base.py`): `30_component-merge/_commit/`의 백업(DROP IF EXISTS + CREATE TABLE AS·멱등)
+ 게이트 하드어서션(DO $$ … RAISE→abort) + 트랜잭션 래핑. dryrun=BEGIN…ROLLBACK·undo=백업 원복.

**실행 결과**(snap_20260704_1507·재생성): 327 결함 **전건 라우팅**(누락 0·no silent caps) —
auto_data 1(1결함)·blocked_human 1(10결함)·needs_authority 4(37)·needs_design 1(21)·review 1(258).
- **입체 근본원인 dedup 실증**: wiring 6 + calcability 4 = 같은 `COMP_ACRYL_PENDING_TBD`(실무진 미확정)
  → blocked_human **1건(10결함·wiring+calcability 교차)**으로 병합. 실무진 한 작업으로 통합.
- **auto_data 파일럿**: `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd(사이즈별 가격 6000/10500/20000
  실재하나 use_dims 미선언) → SQL 트리플 생성. 기존 use_dims 보존하며 siz_cd 추가·백업·사전/사후 게이트·undo.
  ★가격중립 예상(엔진은 siz_cd 하드코딩 매칭) → **P4 재실측이 확인**(게이트 술어).

**셀프테스트**(`remediate/_selftest.py`): 전 결함 라우팅·auto_data SQL 건전성(BEGIN/COMMIT·백업·게이트·
dryrun·undo)·근본원인 dedup(차원 교차)·값 날조 금지(worklist SQL 없음) 4검증 GO.

**다음**: P4 적대적 재실측(engine verbatim) — auto_data 게이트의 "★P4 재실측(가격중립 확인)" 술어 충전.

## 2026-07-04 — 스냅샷 재생성 (snap_20260704_1507)

이번 세션 병합/타공 교정이 라이브 반영됨 확인(`db-check` prc_comp 183→197 드리프트) → `snapshot.sh` 재생성.
재진단 결과 **component_merge 9→0(GO 전환)** — 병합 라이브 COMMIT 반영 실증(드리프트 재확인·메모리 H-1).

## 2026-07-04 — P2 진단·보드 (`hdx/diagnose/` + `hdx/board/`)

**목표**: 파편화된 결정론 스캐너를 공통 `Diagnoser` 계약으로 어댑트하고, 제각각이던 출력을
공통 `Defect` 하나로 병합한 **통합 결함보드**를 산출(설계 §2 L2·L3·갭#1·갭#2 해소).

**계약** (`hdx/diagnose/base.py`): `Diagnoser.scan(snap)->list[Defect]` + `stop_predicate(defects)->bool`.
차원별 종료술어가 다르면 override(HIGH만 blocking 등).

**가격 파일럿 5 Diagnoser** — 각 원본 알고리즘 verbatim, 산출을 `Defect`로 통일:
- `WiringDx` ← `batch/wiring_scan.py` (순수함수 `scan_from_snapshot` import·call — 재구현 0)
- `ContributionDx` ← `batch/contribution_scan.py` (순수함수 `scan` import·call)
- `ComponentMergeDx` ← `batch/component_merge_scan.py` (검증된 헬퍼·상수 import + 분류루프 Snapshot 재바인딩)
- `DimConformanceDx` ← `huni-price-table-integrity/…/dim_conformance.py` (라이브 psql 원본을 **Snapshot 포팅**·결정론화·갭#2)
- `CalcabilityDx` ← `batch/score_batch.py` PRICED-0 (**구조 프록시**: 공식 바인딩 있으나 wired comp 단가행 총합 0=PRICE 반드시 0)

**통합 결함보드** (`hdx/board/board.py`): 전 Diagnoser 결함 병합 → `defect-board.csv`(돈영향 정렬)
+ `defect-board.html`(실무진 열람·필터/정렬·차원별 GO 배지·전역 verdict). 전역 verdict = Σ stop_predicate(AND).

**진입점** `hdx/diagnose_remediate.py --scope price [--round N --note]` → snap 로드 → 5 scan → board → 콘솔 GO/NO-GO.

**실행 결과**(snap_20260702): 총 331건 — wiring 6·dim_conformance 37·contribution 274·component_merge 9·calcability 5.
돈영향(저/과청구) 33·치명 5. 전역 NO-GO(결함 잔존·정상).
- **CalcabilityDx 5건** = 아크릴 `COMP_ACRYL_PENDING_TBD`(실무진 미확정·단가행0) 상품 → 정확한 계산불가 신호.

**충실성 검증(드리프트 0)**: 원본 스캐너 카운트와 완전 일치 — wiring 6(dead 6)·contribution 274
(UNCOVERED 169+MISMATCH 96+ORPHAN_PROC 9)·component_merge 9(유형 A 9+B 0). foundation 셀프테스트 회귀 GO. 멱등(재실행 331 동일).

**스코프 명시(no silent caps)**: CalcabilityDx 는 결정론·토큰0 **구조 프록시**만 — simulate 기반 정밀
PRICED-0(선택조합별 0원)은 **P4 적대적 재실측**으로 이관(HANDOFF '엔진 재실측 먼저' 결정). WiringDx 는
스냅샷 3종만(NO_FORMULA=이전사이트 분모 필요 → details 폴백 전용·스캔 범위 밖·CalcabilityDx 가 상품롤업으로 보완).

**주의**: `latest`=snap_20260702(이번 세션 병합/타공 교정 이전) → 보드는 그 시점 상태. 정본 검증엔
스냅샷 재생성 후 재실행(P3 착수 전 권장) 또는 게이트 단계 라이브 재-SELECT(메모리 H-1 드리프트).

**미변경**: 원본 스캐너 `batch/*.py`·`dim_conformance.py`는 손대지 않음(import·call 또는 포팅만).

**다음**: P3 Remediator 통일(교정본 dryrun/fix/undo·백업·게이트) — `foundation/models.py` `Fix` 스키마 재사용.

---

## 2026-07-04 — P1 foundation (`hdx/foundation/`)

공용 토대 6모듈(env·db·snapshot·engine·models·sim) — 파편 스캐너의 복붙 로더·엔진매칭을 공통추출.
`engine.py` = pricing.py `match_component` verbatim 이식. `models.py` = 공통 `Defect`/`Fix`. 셀프테스트 GO. 커밋 `401436e`.
