# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 — P5 (반자동 라운드 루프 + OptionCpqDx 신규 + codex 선택)

**① 반자동 라운드 러너**(`hdx/loop/`): `scan→board→remediate→verify→[인간 승인]→적재→재스냅샷→재scan`
을 한 라운드로 묶고 `board-rounds.csv`(이미 존재) 패턴으로 수렴 추이 기록. 전역 정지 = 전 차원 defect0
+ 전 상품 PRICE≠0. **[HARD] 7·8(적재 COMMIT·webadmin)은 인간 게이트** — 러너는 거기서 정지(완전 무인 금지).
현재 auto_data 파일럿(포스터 use_dims)이 **P4 GO** 상태 → 이 교정이 "인간 승인 후 적재→재스냅샷→
component_merge 처럼 결함 해소 확인"의 첫 라운드 후보.

**② OptionCpqDx 신규**(갭#5·설계 §3): 이번 세션 발견(메쉬 타공 옵션 `dtl_opt` 누락 → 저청구)이 근거.
`t_prd_product_option_items.dtl_opt` 누락·ref_key 불일치·저청구를 전용 스캐너로 검출 → Diagnoser 편입.
(HANDOFF 후속 2번 "옵션 dtl_opt 누락 전수 점검"과 동일 트랙.)

**③ codex 2차(선택)**(`hdx/verify/codex_gate.py`·설계 §6): `codex exec -s read-only` 로 교정본을 독립
판정·reconcile. `hpe-codex-validate` 스킬 로직 훅화. 미가용 시 "Claude 단독" 명시 폴백. 배치가 codex 부르는 최초 지점.

**전파**(파일럿 검증 후): 판형(PlatesizeDx)·가격격자(PriceGridDx 19시트)·수량(QtyRuleDx) 차원 어댑트 → `--scope` 확장.

## 완료 (직전 세션)
- **P4 적대적 재실측** — `hdx/verify/`(base 계약 + overlay + golden) + 진입점 `--verify` 플래그.
  auto_data 교정본을 `foundation/engine.py`(pricing.py verbatim)로 독립 재계산·자체검증(생성≠검증).
  - 3면 판정(전부 통과=GO): ① **가격중립**(engine 재계산 교정 전/후 단가 허용오차 0) ② **결함해소**
    (겨냥 결함 재진단서 소멸) ③ **무회귀**(어떤 차원에도 새 결함 0·적대적).
  - `MutableSnapshot`(overlay): `Fix.mutation`(기계판독 쌍·`models.py` 가산)을 스냅샷 사본에 in-memory 적용(라이브 미변경).
  - **파일럿 GO**: `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd → 가격중립(엔진 siz_cd 하드코딩 매칭)·
    결함해소(UNDECLARED 1→0)·무회귀 실증. **실단가 매칭 검증**(10500/20000/6000·허수 아님).
  - **음성 대조**(항상-GO 버그 배제): 단가행 unit_price 변조 → 검증기가 NO-GO 를 낸다(가격중립 아님).
  - 실행: `python3 …/diagnose_remediate.py --scope price --verify` · 셀프테스트 `verify/_selftest.py`(4검증 GO).
- **P3 교정생성** — `hdx/remediate/`(값 날조 금지 라우팅·입체 근본원인 dedup·327 전건 라우팅). 커밋 `2c6468d`.
- **P3 교정생성** — `hdx/remediate/`(base 계약 + 5 Remediator + plan) + 진입점 `--remediate` 플래그.
  실행 GO(327 결함 전건 라우팅·auto_data 1·blocked_human 10·needs_authority 37·needs_design 21·review 258).
  - **[HARD] 값 날조 금지**: 단가값이 권위/실무진에서 와야 하는 결함(needs_authority/blocked_human/
    needs_design)은 **SQL 안 만들고 worklist 로만**. `auto_data`(값 날조 없는 메타/데이터 교정)만 SQL 트리플.
  - **입체 근본원인 dedup**: wiring 6 + calcability 4(같은 `COMP_ACRYL_PENDING_TBD`) → blocked_human 1건(10결함) 병합.
  - auto_data 파일럿 = `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd → SQL 트리플 생성 → **P4 재실측 GO**(가격중립·결함해소·무회귀).
  - SQL 승계 = `30_component-merge/_commit/`(백업 CREATE TABLE AS·게이트 RAISE·트랜잭션 래핑).
  - `models.py` `Fix` 확장: `remediation_class`·`worklist_note`·`root_comps`·`mutation`·`is_auto`(가산·P1 회귀 GO).
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
- 블로커 없음(P4 독립 완결·전 셀프테스트 GO).
- **스냅샷 신선도**: 현재 latest=snap_20260704_1507(재생성·병합/타공 반영). 정본 검증엔 재생성(`live-snapshot/snapshot.sh`) 후 재실행 또는 게이트 단계 **라이브 재-SELECT**(메모리 H-1).
- **[HARD] 건드리지 말 것**: `foundation/engine.py`는 pricing.py와 verbatim(엔진 변경 시 재이식·드리프트 0). `db.py`는 읽기전용 유지. 원본 스캐너(`batch/*.py`)·`dim_conformance.py`는 미변경(import·call 또는 포팅만). auto_data SQL 도 자동 COMMIT 금지(dryrun→P4→인간 승인). 완전 무인 자기회귀 금지(COMMIT=인간+webadmin).

## 큰 로드맵
~~P2 보드~~ → ~~P3 Remediator~~ → ~~P4 적대적 재실측~~(전부 완료) → **P5 반자동 루프+OptionCpqDx 신규+codex**. 파일럿(가격) 종단 GO → 판형·수량·옵션CPQ 도메인 전파.
