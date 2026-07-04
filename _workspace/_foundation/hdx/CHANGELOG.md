# hdx — CHANGELOG (최신 위 PREPEND)

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
