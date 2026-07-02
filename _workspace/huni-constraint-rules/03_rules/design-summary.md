# 제약규칙 설계 총괄 (Phase 2 · hcr-rule-designer)

> §31 Huni-Constraint-Rules · 2026-07-02 · 입력=Phase 1 확정 스코프(AMBIG 5·CN-1 0·컨펌큐 제외)
> 라이브 읽기전용 SELECT 만 사용 · DB 쓰기 0 (적재는 승인 후 registrar) · 유도 스냅샷 2026-07-02 13:59:30

---

## wave별 결과

| wave | 대상 | 설계 규칙 수 | 막는 조합 수 | 비고 |
|------|------|-------------|-------------|------|
| **wave-1 파일럿** | 129 폼보드·130 포맥스보드 CN-2 | **8** (상품당 4) | **8 셀** (오프대각) | 단가행 자동유도·전건 폼빌더 역파싱 가능 |
| **wave-2 CN-5** | nonspec 자유치수 High 19건 | **0** | — | 전건 BLOCKED-UI(범위=raw-only) |
| **부수 점검** | 016·058 기존 규칙 | 점검 3건 | — | 016 PASS×2 · 058 FAIL(CONFIRM-QUEUE) |

## wave-1 상세 (설계·산출 GO)

- **유도**: 라이브 `t_prc_component_prices` 실존 (mat_cd, siz_cd) → 자재당 허용 사이즈 **1:1**
  (폼보드·포맥스 모두 자재명에 사이즈 내장). 8자재 → 8단일 implication 규칙.
- **분할 설계**: 구 `R_DEMO_MATSIZ`(상품당 1규칙, AND-of-4-OR)는 폼빌더 역파싱 불가(최상위 `and`)
  → 자재별 8규칙으로 **분할**. 엔진 병합 시 논리 동일(동작 무손상), 각 규칙은 UI 로 열림.
- **정형성 자가검사**: `parse_check.py`(views.py `_parse_logic_to_conditions` verbatim) →
  **8/8 PARSEABLE · 통과재현·막힘재현 모두 True**.
- **search-before-mint**: 구 R_DEMO_MATSIZ(라이브 실재, 129·130 각 1행) 논리삭제(del_yn='Y')
  + 신규 R_MATSIZ_* 8건 mint. 멱등 UPSERT ON CONFLICT(prd_cd, rule_cd).
- **dryrun 실증**: `apply-dryrun.sql` 라이브 실행(BEGIN…ROLLBACK) — UPDATE 2 + INSERT 8,
  JSONB 캐스팅 정상(500 위험 없음), 활성 8+구데모 비활성 확인 후 롤백(순수 무기록).
- 산출: `wave1-pilot/` (rule-spec.md·rules.csv·conformance-check.md·derive_matsiz.py·
  derive-snapshot.csv·derived-rules.json·gen_sql.py·parse_check.py·apply-dryrun.sql·
  apply-fix.sql·undo.sql).

## wave-2 상세 (전건 BLOCKED — 미설계 사유)

- **미설계 사유**: 자유치수 범위는 `width/height` 수치 부등호(`>=`/`<=`)가 필수인데,
  폼빌더는 (1) `>=`/`<=` 연산자 미생성·미역파싱(===/in 만), (2) `width`/`height`/`size_mode` 를
  VAR_KEY_MAP 에 미포함 → **raw escape-hatch 로만 표현 가능** → [HARD] "UI-확인가능 우선" 위반.
  죽은 규칙 mint 금지 원칙에 따라 **BLOCKED-UI 19건**으로 분류.
- **BLOCKED 수 = 19**. (런타임 var 는 width/height 지원=엄밀히 죽은 규칙 아님, 그러나 폼빌더
  관리 불가 → BLOCKED-UI.)
- **해소 경로(하네스 밖)**: ① §6 위젯이 `nonspec_*_min/max/incr` 컬럼으로 입력 직접 강제(규칙 불요·최단),
  ② 폼빌더에 수치범위 조건 타입 추가(개발 요청) 시 19건+기존 7건 UI-관리 가능.
- 산출: `wave2-cn5/rule-spec.md`(판정·목록·라우팅).

## 부수 점검 상세 (016·058 — `wave1-pilot/conformance-check.md`)

- **016 R_DEMO_VIS**(.01): PARSEABLE·명명 정합·err_msg 부재는 가시성 규칙이라 정당 → **PASS(무수정)**.
- **016 R_DEMO_EXC**(.02): PARSEABLE·err_msg 양호(오시/미싱 동시 불가) → **PASS(무수정)**.
- **058 RULE_001**(.03): **FAIL 3중** — type↔shape 불일치(.03 인데 not-and=RAW-ONLY)·부패(조건
  siz SIZ_000426 이 상품 미제공=죽은 규칙)·옵션 미해소·err_msg 부재. 원 의도 불명확
  (규칙명 'A5 커팅' vs 코드 불일치) → **CONFIRM-QUEUE**(apply-fix 미포함·실무진/curator 컨펌 후
  정형 수정 또는 논리삭제). 수정 방향은 conformance-check.md §058 에 제시.

## 미설계·보류 총괄

| 항목 | 수 | 사유 | 처리 |
|------|---:|------|------|
| wave-2 CN-5 범위 | 19 | 폼빌더 raw-only(범위 부등호·width/height 미지원) | BLOCKED-UI · §6 컬럼강제/빌더확장 |
| 058 RULE_001 | 1 | type/shape 불일치+부패+의도 불명 | CONFIRM-QUEUE(curator) |
| AMBIG(스코프 밖) | 5 | 아크릴 TBD 단가(제약 아님) | 실무진 BLOCKED(설계 금지·Phase1 확정) |

## 후속

- **gate(hcr-gate-validator·CR)**: wave-1 8규칙 재검증(역파싱·오차단 0 재확인=유도 스냅샷 이후
  신규 단가행 없는지 `derive_matsiz.py` 재실행)·validate 미리보기 로컬 시뮬. GO 시 **registrar**
  가 `apply-fix.sql` 인간 승인 후 COMMIT + webadmin 실화면(제약 미리보기 막힘/통과) 재현.
- 058 CONFIRM-QUEUE 은 curator 반송.
