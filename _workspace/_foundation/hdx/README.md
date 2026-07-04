# hdx — 후니 통합 진단·교정 배치

실무진이 **한 명령**으로 전 카탈로그를 입체(다차원) 진단 → 통합 결함보드 → 교정본 생성 → 적대적 재실측 → 전역 GO/NO-GO 까지 돌리는 배치. 파편화된 개별 스캐너를 공통 프레임 위로 통합.

- **설계 청사진**: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)
- **[HARD] 라이브 읽기전용**(진단·재실측·DRY-RUN). 실 COMMIT·webadmin 실화면은 **인간 게이트**(완전 무인 자기회귀 금지).

## 진행 상태

| Phase | 내용 | 상태 |
|---|---|---|
| **P1** | `foundation/` 공용 토대(snapshot·db·engine·models·env·sim) | **완료**(셀프테스트 GO) |
| P2 | 기존 6 스캐너 → `Diagnoser` 계약 어댑트 + 통합 결함보드 | 다음 |
| P3 | `Remediator` 교정생성 통일(dryrun/fix/undo·백업·게이트) | — |
| P4 | 적대적 재실측(engine verbatim) 배치 편입 | — |
| P5 | 반자동 라운드 루프 + OptionCpqDx 신규 + (선택)codex | — |

파일럿 = **가격 도메인** 종단 후 판형·수량·옵션CPQ 전파.

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

## [HARD] 규칙
- 라이브 = `RAILWAY_DB_*` 읽기전용 SELECT + 롤백전용 DRY-RUN만. 쓰기는 인간 승인 채널.
- 비밀값 `.env.local`에만·stdout 금지.
- `engine.py`는 pricing.py와 verbatim 유지(엔진 변경 시 재이식·드리프트 0).
- 스냅샷은 시점 사본 — 교정/게이트 단계는 라이브 재-SELECT로 드리프트 재확인.
