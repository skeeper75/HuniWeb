# hdx — 후니 통합 진단·교정 배치

실무진이 **한 명령**으로 전 카탈로그를 입체(다차원) 진단 → 통합 결함보드 → 교정본 생성 → 적대적 재실측 → 전역 GO/NO-GO 까지 돌리는 배치. 파편화된 개별 스캐너를 공통 프레임 위로 통합.

- **설계 청사진**: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)
- **[HARD] 라이브 읽기전용**(진단·재실측·DRY-RUN). 실 COMMIT·webadmin 실화면은 **인간 게이트**(완전 무인 자기회귀 금지).

## 진행 상태

| Phase | 내용 | 상태 |
|---|---|---|
| **P1** | `foundation/` 공용 토대(snapshot·db·engine·models·env·sim) | **완료**(셀프테스트 GO) |
| **P2** | 5 스캐너 → `Diagnoser` 계약 어댑트 + 통합 결함보드 | **완료**(가격 파일럿 GO) |
| **P3** | `Remediator` 교정생성 통일(dryrun/fix/undo·백업·게이트·worklist) | **완료**(값 날조 금지 라우팅) |
| **P4** | 적대적 재실측(engine verbatim·가격중립·결함해소·무회귀) | **완료**(파일럿 GO·음성대조 검증) |
| **P5-①** | 반자동 라운드 루프(`hdx/loop/`·인간 게이트 종합·수렴 추이) | **완료**(가격 파일럿 종단) |
| P5-② | OptionCpqDx 신규(옵션 dtl_opt 저청구) + (선택)codex 2차 | 다음 |

파일럿 = **가격 도메인** 종단(진단→교정→재실측→라운드) 후 판형·수량·옵션CPQ 전파.

## foundation/ (P1)

| 모듈 | 역할 | 승계 원본 |
|---|---|---|
| `env.py` | `.env.local` 로딩(비밀 미출력) | lib_huni.load_env |
| `db.py` | 라이브 읽기전용 psql `db(sql)` | lib_huni.db |
| `snapshot.py` | `Snapshot` — live-snapshot/latest CSV 로더·ACTIVE·엔진행 정규화 | wiring_scan/contribution_scan 로더 공통추출 |
| `engine.py` | pricing.py 매칭 verbatim 이식(`match_component`) — 적대검증 코어 | _gate_harness.py 1-88 |
| `models.py` | 공통 `Defect`/`Fix` 스키마(파편 출력 통일) | 설계 §4(신규) |
| `sim.py` | `HuniSim` 시뮬레이터 클라이언트(읽기 POST) | lib_huni.HuniSim |

### 셀프테스트
```bash
python3 _workspace/_foundation/hdx/foundation/_selftest.py
```
검증: 스냅샷 로드·engine_rows 정규화(''→None·dim_vals→dict)·엔진 매칭 로직(dim_vals 필수·proc 정확매칭·None 와일드카드).

### 사용 예
```python
import sys, pathlib
sys.path.insert(0, "_workspace/_foundation")           # hdx 패키지 루트
from hdx.foundation import Snapshot, engine, load_env, db, Defect

snap = Snapshot()                                       # live-snapshot/latest
rows = snap.engine_rows("COMP_NAMECARD_STD")            # 정규화 단가행
m = engine.match_component(rows, {"print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074"}, qty=100, as_of="2026-12-31")
# m["row"]["unit_price"] → 매칭 단가 (없으면 m["error"]/m["reason"])
```

## diagnose/ + board/ (P2)

입체(다차원) 진단 → 통합 결함보드. 파편 스캐너를 공통 `Diagnoser` 계약으로 어댑트.

```bash
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price [--round N --note "..."]
# → board/defect-board.csv (차원×상품·돈영향 정렬)
# → board/defect-board.html (실무진 열람·필터/정렬)
# → 콘솔: 전역 GO/NO-GO + 차원별 결함수 + 돈영향/치명 카운트
```

**가격 파일럿 5 Diagnoser** (`hdx/diagnose/`) — 각 원본 알고리즘 verbatim, 산출을 공통 `Defect`로 통일:

| Diagnoser | 원본 | 어댑트 | 결함 차원 | stop_predicate |
|---|---|---|---|---|
| `WiringDx` | `batch/wiring_scan.py` | import·call(scan_from_snapshot) | 고아·빈배선·오염 | 결함 0 |
| `DimConformanceDx` | `…/dim_conformance.py`(라이브 psql) | **Snapshot 포팅**(갭#2) | MISSING·UNDECLARED | HIGH 0 |
| `ContributionDx` | `batch/contribution_scan.py` | import·call(scan) | 공정 저청구 silent-0 | HIGH 0 |
| `ComponentMergeDx` | `batch/component_merge_scan.py` | 헬퍼 import + 분류루프 재바인딩 | 같은차원 분리 comp | A/B 후보 0 |
| `CalcabilityDx` | `batch/score_batch.py`(PRICED-0) | **구조 프록시**(결정론) | 전 상품 PRICE≠0 | PRICED-0 0 |

- 전역 verdict = Σ stop_predicate(AND). 정렬 = 돈영향(저/과청구 상단) → 심각도 → 차원 → 상품.
- **충실성 검증(드리프트 0)**: wiring 6·contribution 274·component_merge 9 = 원본 카운트와 완전 일치.
- **CalcabilityDx 스코프 명시**(no silent caps): 결정론·토큰0 **구조 프록시**만(공식 바인딩 있으나
  wired comp 단가행 총합 0 = PRICE 반드시 0). simulate 기반 정밀 PRICED-0(선택조합별 0원)은 **P4 재실측**으로 이관.
- **스냅샷 시점 주의**: 라이브 반영 재확인은 스냅샷 재생성(`live-snapshot/snapshot.sh`) 후 재실행 또는
  게이트 단계 라이브 재-SELECT(메모리 H-1). 최신 재생성 snap_20260704_1507 = 이번 세션 병합/타공 반영
  → component_merge 9→0(GO 전환·드리프트 재확인 실증).

## remediate/ (P3)

진단 결함 → 교정본. **[HARD] 값 날조 금지** = 단가값이 권위(엑셀/실무진)에서 와야 하는 결함은
SQL 을 만들지 않고 **worklist** 로만 라우팅. `auto_data`(값 날조 없는 결정론 데이터/메타 교정)만
dryrun/fix/undo SQL 트리플 생성. auto_data 라도 자동 COMMIT 금지(dryrun→P4 재실측→인간 승인).

```bash
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price --remediate
# → remediate/remediation-plan.md (분류별 worklist·실무진 열람)
# → remediate/remediation-plan.csv
# → remediate/sql/*.{dryrun,fix,undo}.sql (auto_data 만·인간 승인 전 실행 금지)
```

**교정 분류**(`foundation/models.py` `REMEDIATION_CLASS`):

| 분류 | 의미 | 산출 |
|---|---|---|
| `auto_data` | 값 날조 없는 결정론 데이터/메타 교정 | dryrun/fix/undo SQL(백업+게이트) |
| `blocked_human` | placeholder(PENDING/TBD) 실무진 단가·구성 입력 대기 | worklist |
| `needs_authority` | 누락 단가값이 권위 엑셀/실무진에서 와야 함 | worklist |
| `needs_design` | §18 가격설계 필요(공정 comp 신규 등) | worklist |
| `needs_engine` | C트랙 엔진 코드변경 | worklist |
| `review` | 저신뢰(오탐 가능) 수동 검토 | worklist |

- **입체 근본원인 dedup**: 한 근본원인(예 `COMP_ACRYL_PENDING_TBD`)이 여러 차원(wiring+calcability)에
  걸치면 `plan.py` 가 `root_comps` 로 병합 → 실무진 한 작업으로 통합(가격 파일럿: 6+4=10결함 1건).
- **전 결함 라우팅**(no silent caps): Σ Fix.defects == 진단 결함 총수(누락 0).
- 셀프테스트: `python3 _workspace/_foundation/hdx/remediate/_selftest.py`
  (전 결함 라우팅·SQL 건전성·근본원인 dedup·값 날조 금지 4검증).

## verify/ (P4)

`auto_data` 교정본을 적재 **전**, `foundation/engine.py`(pricing.py verbatim)로 독립 재계산해
자체 검증(생성≠검증). 교정본 `mutation`(기계판독 쌍)을 스냅샷 사본에 **in-memory 적용**(라이브 미변경).

```bash
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price --verify
# → verify/verify-report.md (교정본별 GO/NO-GO·가격중립·결함해소·무회귀)
```

각 auto_data Fix 를 3면으로 판정(전부 통과=GO):
1. **가격중립** — engine 재계산이 교정 전/후 단가 동일(허용오차 0). 영향 comp 를 mutation 에서 해석.
2. **결함해소** — 교정이 겨냥한 결함(fix.defects)이 재진단에서 사라짐.
3. **무회귀** — 어떤 차원에도 새 결함 0(적대적: 교정이 다른 곳을 깨지 않는가).

- **파일럿 결과**: `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd = **GO**(가격중립·결함해소·무회귀).
  엔진은 siz_cd 를 use_dims 무관하게 하드코딩 매칭 → 순수 정합 개선(가격 안 바뀜) 실증.
- **음성 대조**(항상-GO 버그 배제): 단가행 unit_price 변조 mutation → 가격중립 아님·NO-GO 를 검증기가 낸다.
- worklist 계열(값 날조 대상)은 SKIP(verifiable=False). codex 2차는 P5(선택).
- 셀프테스트: `python3 _workspace/_foundation/hdx/verify/_selftest.py`
  (재실측 실질성·파일럿 GO·음성대조 NO-GO·worklist SKIP 4검증).

## loop/ (P5-①·반자동 라운드)

`scan→board→remediate→verify` 를 한 라운드로 묶고 **인간 게이트용 종합 리포트** + 수렴 추이를 낸 뒤
**인간 승인 지점에서 정지**한다. **[HARD] 완전 무인 금지** — 적재 COMMIT·webadmin 실화면(7·8)은 인간.

```bash
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price --loop --round N --note "..."
# → loop/round-report.md  (전역 verdict·차원별·적재 후보[P4 GO]·인간 입력 대기·다음 액션 단계)
# → loop/loop-rounds.csv  (수렴 추이 append: round·결함·분류별·auto GO/NO-GO·verdict)
```

한 라운드 = "돌린다→검토→승인→재실행". 러너는 6단계(진단·교정생성·재실측·종합)까지 자동, 7·8(적재·
webadmin)은 인간. 인간이 승인·적재·`snapshot.sh` 재생성 후 재실행하면 다음 라운드(N+1)가 돈다.
전역 정지 = `board.global_go`(전 차원 stop_predicate·전 상품 PRICE≠0) — 코드가 계산·정지 판단은 인간.

- `round-report.md` = 인간이 게이트에서 읽는 단일 산출물: **적재 후보**(P4 GO auto_data·승인 대상) /
  **재실측 NO-GO**(재조사) / **인간 입력 대기**(worklist·값 날조 금지) / **다음 액션**(번호 단계).
- 셀프테스트: `python3 _workspace/_foundation/hdx/loop/_selftest.py`
  (종합 무손실·적재 후보=P4 GO만·전 결함 회계 누락 0·산출물 4검증).

## [HARD] 규칙
- 라이브 = `RAILWAY_DB_*` 읽기전용 SELECT + 롤백전용 DRY-RUN만. 쓰기는 인간 승인 채널.
- 비밀값 `.env.local`에만·stdout 금지.
- `engine.py`는 pricing.py와 verbatim 유지(엔진 변경 시 재이식·드리프트 0).
- 스냅샷은 시점 사본 — 교정/게이트 단계는 라이브 재-SELECT로 드리프트 재확인.
