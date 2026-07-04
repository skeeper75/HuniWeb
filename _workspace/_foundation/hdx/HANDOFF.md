# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 — P5-②c (codex 2차 선택 + PriceGridDx 19시트 어댑터)

**① PriceGridDx(19시트 가격격자)** — 유일 남은 전파 차원. 원본=§26 `huni-price-table-integrity/_batch/
scripts/grid_diff.py`+`run_all.py`. **규모 큼**(권위 CSV 24_master-extract + 시트별 매트릭스 파서 + live-snapshot
대조)이라 단일 Diagnoser 어댑트는 조립 수준 초과 → **별도 어댑터**로 §26 배치를 호출해 산출을 `Defect` 로
변환하는 얇은 브릿지 권장(§26 배치 자체는 재구현 금지·재사용).

**② codex 2차(선택)**(`hdx/verify/codex_gate.py`·설계 §6): `codex exec -s read-only` 로 교정본 독립
판정·reconcile. `hpe-codex-validate` 로직 훅화. 미가용 시 "Claude 단독" 폴백. 현재 auto_data 0 이면 NO-OP.

**③ 실무진 액션 대기(배치 적발 저청구)**: (a) 메쉬배너(PRD_000137) 타공 dtl_opt 누락(OptionCpqDx) (b) 수량
함정 TRAP_MIN 8상품(2/3단접지카드·프리미엄/펄명함·무선/PUR책자·미니보드/배너·QtyRuleDx) — 전부 needs_authority
(올바른 값=권위/실무진). 실무진 확인 후 값 채움→라운드 재실행 결함 감소 확인.

## 완료 (직전 세션)
- **P5-②b 도메인 전파(수량·판형)** — `QtyRuleDx`(←`qty_rule_audit_260702.py` Snapshot 포팅·TRAP_MIN/NO_RULES/
  INFO_MAX·드리프트0 TRAP_MIN 8) + `PlatesizeDx`(←`diagnose_all.py` verbatim + 상시게이트 impos_yn·미스매치0·
  오배선0=판형 GO) + 각 Remediator(needs_authority/review). 라운드7 = 8 Diagnoser·총 407·qty_rule 52(TRAP_MIN 8
  저청구)·platesize GO. `diagnose/_selftest.py` 확장(QtyRule/Platesize 가드 + 전 Dx 스모크). 전 레이어 5/5 GO.
- **P5-②a OptionCpqDx 신규**(갭#5) — `hdx/diagnose/option_cpq_dx.py`(+`PRICE_DIAGNOSERS`) + `OptionCpqRmd`.
  옵션 dtl_opt↔단가행 dim_vals 연결 끊김(저청구) 검출. ★신뢰도 모델(오탐 가드): HIGH=형제 dtl_opt 가
  param 채움(옵션선택형 확정)·REVIEW=형제 미충전(개수/줄수 수치입력 가능성). 실적: option_cpq 29건
  (HIGH 1=메쉬배너 타공 저청구·REVIEW 28=개수). 라운드5 총 326→355(신규 표면화·전건 라우팅). 셀프테스트
  `diagnose/_selftest.py`(HIGH/REVIEW 판별 가드). 전 레이어 5/5 GO.
- **★첫 실적재** — 포스터 `use_dims += siz_cd`(auto_data) 라이브 COMMIT(인간 승인). 라운드4 결함 해소.
- **★첫 실적재** — 포스터 `use_dims += siz_cd`(auto_data) 라이브 COMMIT(인간 승인). 검증 체인 전 게이트 GO:
  드리프트0 재-SELECT → dryrun → P4 재실측 → **webadmin 라이브 시뮬(A4/A3/A2 PRICE≠0)** → COMMIT →
  사후 시뮬 전 사이즈 불변(가격중립 실서비스 확증) → 스냅샷 재생성 → 라운드4(dim_conformance 38→37·
  총 327→326·UNDECLARED siz_cd 0). 백업 `z_bak_dimconf_usedims_comp_poster_canvas_hanging`·undo 보유.
  기록 `remediate/COMMITTED-260704-poster-usedims.md`.
- **P5-① 반자동 라운드 러너** — `hdx/loop/`(runner) + 진입점 `--loop` 플래그. scan→board→remediate→verify 를
  한 라운드로 묶어 **인간 게이트용 `round-report.md`**(적재 후보[P4 GO]·재실측 NO-GO·인간 입력 대기·다음 액션)
  + `loop-rounds.csv`(수렴 추이) 산출 후 **인간 승인 지점서 정지**([HARD] 완전 무인 금지·적재/webadmin=인간).
  실행 GO(라운드3: 적재 후보 1·인간 입력 326·전역 NO-GO). 셀프테스트 `loop/_selftest.py`(4검증 GO).
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
- 블로커 없음(P5-① 독립 완결·전 셀프테스트 4/4 GO).
- **스냅샷 신선도**: 현재 latest=snap_20260704_1507(재생성·병합/타공 반영). 정본 검증엔 재생성(`live-snapshot/snapshot.sh`) 후 재실행 또는 게이트 단계 **라이브 재-SELECT**(메모리 H-1).
- **[HARD] 건드리지 말 것**: `foundation/engine.py`는 pricing.py와 verbatim(엔진 변경 시 재이식·드리프트 0). `db.py`는 읽기전용 유지. 원본 스캐너(`batch/*.py`)·`dim_conformance.py`는 미변경(import·call 또는 포팅만). auto_data SQL 도 자동 COMMIT 금지(dryrun→P4→인간 승인). 완전 무인 자기회귀 금지(COMMIT=인간+webadmin).

## 큰 로드맵
~~P2 보드~~ → ~~P3 Remediator~~ → ~~P4 재실측~~ → ~~P5-① 루프~~ → ~~P5-②a OptionCpqDx~~ → ~~P5-②b 전파 수량·판형~~(전부 완료·첫 실적재 포함) → **P5-②c PriceGridDx 19시트 어댑터 + codex 2차 선택**. 진단 8차원 커버·가격 파일럿 종단 실증.
