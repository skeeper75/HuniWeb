# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 — P2 (가격 파일럿)

기존 결정론 스캐너를 **공통 `Diagnoser` 계약**으로 어댑트하고 **통합 결함보드**를 만든다.

**계약** (신규 `hdx/diagnose/base.py`):
```python
class Diagnoser:
    dimension: str
    def scan(self, snap: Snapshot) -> list[Defect]: ...
    def stop_predicate(self, defects: list[Defect]) -> bool: ...   # 이 차원 결함 0?
```

**가격 파일럿 대상 5 스캐너 → Diagnoser 래핑** (각 원본을 import/이식, 산출을 `Defect`로 변환):
| Diagnoser | 원본 | 결함 차원 |
|---|---|---|
| `WiringDx` | `_foundation/batch/wiring_scan.py` | 배선 고아/빈배선/오염/미바인딩 |
| `DimConformanceDx` | `huni-price-table-integrity/_batch/scripts/dim_conformance.py` | use_dims↔단가행↔선택수단 |
| `ContributionDx` | `_foundation/batch/contribution_scan.py` | 공정 저청구(silent-0) |
| `ComponentMergeDx` | `_foundation/batch/component_merge_scan.py` | 같은차원 분리 comp |
| `CalcabilityDx` | `_foundation/batch/score_batch.py`(PRICED-0/CALC) | 계산가능성 PRICE≠0 |

**통합 결함보드** (`hdx/board/`): 전 Diagnoser 결함을 `Defect` 하나로 병합 →
`defect-board.csv`(차원×상품·돈영향 정렬) + `defect-board.html`(실무진 열람). 전역 verdict = Σ stop_predicate.

**진입점 초안** `hdx/diagnose_remediate.py --scope price --round N` → snap 로드 → 5 Diagnoser.scan → board → verdict 출력(교정생성 P3·재실측 P4·루프 P5).

## 완료 (이번 세션)
- **P1 foundation** — `hdx/foundation/`(env·db·snapshot·engine·models·sim). 셀프테스트 GO. 커밋 `401436e`.
  - `snapshot.py`: live-snapshot/latest CSV·ACTIVE·`engine_rows()`(''→None·dim_vals→dict 정규화)
  - `engine.py`: pricing.py `match_component` verbatim 이식(_gate_harness 1-88 범용화)
  - `models.py`: 공통 `Defect`/`Fix` 스키마 — P2 산출 형식이 이미 정의됨
- 셀프테스트: `python3 _workspace/_foundation/hdx/foundation/_selftest.py`

## 확정 결정 (사용자 260704)
1. 위치 = `_workspace/_foundation/hdx/`
2. **순수 배치(python·실무진 직접) + 얇은 오케스트레이터 스킬 1개**(인간게이트·codex·조율만). 새 하네스 아님.
3. 적대검증 = **엔진 verbatim 재실측 먼저**(결정론·토큰0), codex 배치호출은 **P5 선택**.
4. **가격 도메인 파일럿** 종단 → 판형·수량·옵션CPQ 전파.

## 블로커·주의
- 블로커 없음(P1 독립 완결).
- **스냅샷 시점 주의**: `live-snapshot/latest`는 시점 사본(현재 snap_20260702·이번 세션 병합/타공 교정 이전). 정본 comp(예 병합 결과)를 스냅샷으로 검증하려면 스냅샷 재생성 필요. 교정/게이트 단계는 **라이브 재-SELECT**로 드리프트 재확인(메모리 H-1).
- **[HARD] 건드리지 말 것**: `foundation/engine.py`는 pricing.py와 verbatim(엔진 변경 시 재이식·드리프트 0). `db.py`는 읽기전용 유지. 완전 무인 자기회귀 금지(COMMIT=인간+webadmin).

## 큰 로드맵
P2 스캐너 어댑트+보드 → P3 Remediator 통일 → P4 적대적 재실측 → P5 반자동 루프+OptionCpqDx 신규+codex. 파일럿 검증 후 타 도메인 전파.
