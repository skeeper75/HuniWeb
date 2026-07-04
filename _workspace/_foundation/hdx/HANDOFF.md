# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 — P3 (Remediator 교정생성 통일)

P2 통합 결함보드가 낸 `Defect`(가격 파일럿 331건·돈영향 33·치명 5)를 입력으로,
**공통 `Remediator` 계약**으로 교정본(dryrun/fix/undo SQL + 백업 + 게이트)을 생성한다.
`Fix` 스키마는 이미 `foundation/models.py`에 정의됨(P3 산출 형식 확정).

**계약** (신규 `hdx/remediate/base.py`):
```python
class Remediator:
    dimension: str
    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]: ...
    # Fix.dryrun_sql(롤백전용 멱등 실증) · fix_sql(백업+게이트 하드어서션 내장) · undo_sql
```

**승계 원본** (이번 세션 COMMIT SQL 패턴 = `z_bak_*` 백업 + 게이트 하드어서션):
`30_component-merge/_commit/*.sql`(병합 undo)·`z_bak_tagong8_fix`·`z_bak_mesh_tagong_dtlopt`(타공).
★자동은 여기까지(dryrun/fix/undo 생성). **적재 COMMIT·webadmin 실화면은 인간 게이트**(L7·설계 [HARD]).

**파일럿 교정 대상 우선순위**(돈영향순): ① CalcabilityDx 5건(아크릴 `COMP_ACRYL_PENDING_TBD`
미확정 — 실무진 단가 입력 필요·데이터로 못 닫음 → **needs_engine_change/실무진 입력** 플래그)
② ContributionDx HIGH(공정 저청구) ③ DimConformanceDx MISSING-HIGH.

## 완료 (직전 세션)
- **P2 진단·보드** — `hdx/diagnose/`(5 Diagnoser) + `hdx/board/`(CSV+HTML+전역 verdict) + 진입점
  `diagnose_remediate.py --scope price`. 실행 GO(331건·차원별 배지·돈영향 정렬).
  - **충실성 드리프트 0**: wiring 6·contribution 274·component_merge 9 = 원본 카운트 완전 일치.
  - `WiringDx`·`ContributionDx` = 원본 순수함수 import·call(재구현 0). `DimConformanceDx` =
    라이브 psql 원본을 **Snapshot 포팅**(결정론화·갭#2). `ComponentMergeDx` = 헬퍼 import+분류루프 재바인딩.
  - `CalcabilityDx` = **구조 프록시**(공식 바인딩 있으나 wired 단가행 총합 0). simulate 정밀 PRICED-0은 P4.
  - 실행: `python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price --round N`
- **P1 foundation** — `hdx/foundation/`(env·db·snapshot·engine·models·sim). 셀프테스트 GO. 커밋 `401436e`.

## 확정 결정 (사용자 260704)
1. 위치 = `_workspace/_foundation/hdx/`
2. **순수 배치(python·실무진 직접) + 얇은 오케스트레이터 스킬 1개**(인간게이트·codex·조율만). 새 하네스 아님.
3. 적대검증 = **엔진 verbatim 재실측 먼저**(결정론·토큰0), codex 배치호출은 **P5 선택**.
4. **가격 도메인 파일럿** 종단 → 판형·수량·옵션CPQ 전파.

## 블로커·주의
- 블로커 없음(P2 독립 완결).
- **스냅샷 시점 주의**: `live-snapshot/latest`=snap_20260702(이번 세션 병합/타공 교정 이전). **보드 331건은 그 시점 상태** — component_merge 9·일부 contribution/dim 은 라이브에 이미 반영됐을 수 있음. 정본 검증엔 **스냅샷 재생성 후 재실행**(권장 P3 착수 전) 또는 게이트 단계 **라이브 재-SELECT**(메모리 H-1).
- **[HARD] 건드리지 말 것**: `foundation/engine.py`는 pricing.py와 verbatim(엔진 변경 시 재이식·드리프트 0). `db.py`는 읽기전용 유지. 원본 스캐너(`batch/*.py`)는 미변경(import·call 또는 포팅만). 완전 무인 자기회귀 금지(COMMIT=인간+webadmin).

## 큰 로드맵
~~P2 스캐너 어댑트+보드~~(완료) → **P3 Remediator 통일** → P4 적대적 재실측(engine verbatim) → P5 반자동 루프+OptionCpqDx 신규+codex. 파일럿 검증 후 판형·수량·옵션CPQ 도메인 전파.
