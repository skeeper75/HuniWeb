# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 — P4 (적대적 재실측·engine verbatim)

P3 이 낸 `auto_data` 교정본(dryrun SQL)을 적재 **전**, `foundation/engine.py`(pricing.py verbatim)로
교정 전/후를 독립 재계산해 **골든 재현 허용오차 0·silent 합산 0·저청구 0**을 배치가 스스로 검증한다
(생성≠검증·다른 코드경로). 이게 auto_data 게이트의 "★P4 재실측" 술어를 실제로 채운다.

**P4 파일럿 대상**(현재 auto_data 1건): `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd.
- 검증 질문: 이 use_dims 선언이 **가격을 바꾸는가?** 엔진은 NON_QTY_DIMS(siz_cd 포함)를 use_dims
  무관하게 하드코딩 매칭 → **가격중립 예상**. P4 = 그 상품(PRD_000133) 골든가를 교정 전/후 engine 재계산해
  변동 0 확인 → GO(순수 정합 개선). 변동 시 NO-GO(예상과 다름 = 재조사).

**계약**(신규 `hdx/verify/base.py`): `Verifier.verify(fix, snap) -> Verdict`.
- dryrun SQL 을 스냅샷 사본에 적용(또는 교정 후 값 시뮬)한 뒤 engine.match_component 재계산.
- 골든 케이스 = 해당 comp 사용 상품의 대표 선택×수량. 허용오차 0.
- (선택 P5) codex 2차: `codex exec -s read-only` 독립 판정·reconcile. 미가용 시 "Claude 단독" 폴백.

**주의**: engine 재계산엔 골든 입력(상품 선택 조합)이 필요 — `score_batch.py`의 대표 케이스 도출/
`golden_fetch.py` 승계 검토. auto_data 가 0건이면 P4 는 NO-OP(현재는 1건).

## 완료 (직전 세션)
- **P3 교정생성** — `hdx/remediate/`(base 계약 + 5 Remediator + plan) + 진입점 `--remediate` 플래그.
  실행 GO(327 결함 전건 라우팅·auto_data 1·blocked_human 10·needs_authority 37·needs_design 21·review 258).
  - **[HARD] 값 날조 금지**: 단가값이 권위/실무진에서 와야 하는 결함(needs_authority/blocked_human/
    needs_design)은 **SQL 안 만들고 worklist 로만**. `auto_data`(값 날조 없는 메타/데이터 교정)만 SQL 트리플.
  - **입체 근본원인 dedup**: wiring 6 + calcability 4(같은 `COMP_ACRYL_PENDING_TBD`) → blocked_human 1건(10결함) 병합.
  - auto_data 파일럿 = `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd → SQL 트리플(백업·사전/사후 게이트·undo·dryrun) 생성. **P4 재실측 게이트 미충족 상태**(다음).
  - SQL 승계 = `30_component-merge/_commit/`(백업 CREATE TABLE AS·게이트 RAISE·트랜잭션 래핑).
  - `models.py` `Fix` 확장: `remediation_class`·`worklist_note`·`root_comps`·`is_auto`(가산·P1 회귀 GO).
  - 실행: `python3 …/diagnose_remediate.py --scope price --remediate` · 셀프테스트 `remediate/_selftest.py`(4검증 GO).
- **P2 진단·보드** — `hdx/diagnose/`(5 Diagnoser) + `hdx/board/`. 드리프트 0(원본 카운트 일치). 커밋 `8f2e876`.
- **P1 foundation** — `hdx/foundation/`(6모듈). 셀프테스트 GO. 커밋 `401436e`.
- **스냅샷 재생성**: snap_20260704_1507(병합/타공 반영) → component_merge 9→0 GO 전환 실증(드리프트 재확인).

## 확정 결정 (사용자 260704)
1. 위치 = `_workspace/_foundation/hdx/`
2. **순수 배치(python·실무진 직접) + 얇은 오케스트레이터 스킬 1개**(인간게이트·codex·조율만). 새 하네스 아님.
3. 적대검증 = **엔진 verbatim 재실측 먼저**(결정론·토큰0), codex 배치호출은 **P5 선택**.
4. **가격 도메인 파일럿** 종단 → 판형·수량·옵션CPQ 전파.

## 블로커·주의
- 블로커 없음(P3 독립 완결).
- **스냅샷 신선도**: 현재 latest=snap_20260704_1507(재생성·병합/타공 반영). 정본 검증엔 재생성(`live-snapshot/snapshot.sh`) 후 재실행 또는 게이트 단계 **라이브 재-SELECT**(메모리 H-1).
- **[HARD] 건드리지 말 것**: `foundation/engine.py`는 pricing.py와 verbatim(엔진 변경 시 재이식·드리프트 0). `db.py`는 읽기전용 유지. 원본 스캐너(`batch/*.py`)·`dim_conformance.py`는 미변경(import·call 또는 포팅만). auto_data SQL 도 자동 COMMIT 금지(dryrun→P4→인간 승인). 완전 무인 자기회귀 금지(COMMIT=인간+webadmin).

## 큰 로드맵
~~P2 스캐너 어댑트+보드~~(완료) → ~~P3 Remediator 통일~~(완료) → **P4 적대적 재실측(engine verbatim)** → P5 반자동 루프+OptionCpqDx 신규+codex. 파일럿 검증 후 판형·수량·옵션CPQ 도메인 전파.
