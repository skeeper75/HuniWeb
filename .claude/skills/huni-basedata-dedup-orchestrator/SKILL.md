---
name: huni-basedata-dedup-orchestrator
description: >
  후니프린팅 기초데이터 표시중복 정리·검수·적재 하네스 오케스트레이터. 두 SOT 권위 엑셀(상품마스터
  260610·인쇄상품 가격표 260527)을 토큰효율적으로 탐색해, 6축 기초데이터(사이즈 t_siz_sizes·공정·
  자재·기초코드·인쇄옵션·도수) 중 사용자 화면에 보여지는 표시명/내부값이 중복이거나 표시↔실제가
  불일치(오적재)인 데이터를 4축(권위추출+표시↔실제 정합·표시 중복·내부값 중복·의미구분 보존)으로
  검수하고, 정리/적재할 매핑데이터를 만들어 승인 후 라이브에 안전 적재한다. ★Claude 생성 + codex cli
  2차 교차검증으로 오적재 방지. 정리/적재할 것이 없으면 통과(NO-OP). 4인 팀(hbd-source-harvester→
  hbd-dedup-analyst→hbd-codex-verifier→hbd-load-executor)·D1~D6 게이트·사이즈 파일럿 우선. 라이브
  읽기전용 기본·실 적재는 승인 후·가격종속(component_prices)은 BLOCKED 보류. '기초데이터 중복 정리',
  '사이즈 중복 정리', '표시명 중복', '사이즈정보 검수', '기초데이터 표시중복', 'SOT 엑셀 사이즈 정리',
  'DB 적재 사이즈 매핑', 'codex 교차 적재', '기초데이터 정합 검수', '사이즈 적재', '공정/자재/도수 중복',
  '기초데이터 정리 하네스 실행/재실행/업데이트/보완', '특정 축만 중복 정리', '중복 정리 다시', '검수 다시'
  작업 시 사용. 단순 질문은 직접 응답.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, Agent, AskUserQuestion, Skill
metadata:
  version: "1.0.0"
  category: "workflow"
  status: "active"
  updated: "2026-06-19"
  tags: "basedata, dedup, size, codex, load, huni"
---

# huni-basedata-dedup — 기초데이터 표시중복 정리·검수·적재 오케스트레이터

6축 기초데이터에서 "화면에 같은 게 두 번 보이나(중복)" + "표시값과 실제값이 어긋났나(오적재)"를 권위 엑셀 기준으로 검수하고, 정리/적재할 것을 찾아 **Claude 생성 + codex 2차 검증** 후 안전 적재한다. 정리/적재할 것이 없으면 **통과**한다.

## 정체성과 경계

- **이 하네스 = 표시 레벨(UX) 중복 + 표시↔실제 정합 + codex 안전 적재.** "화면에 중복으로 보이나"가 출발점.
- **huni-basecode(§12)와 다름**: basecode는 데이터 정확성(오염·오매핑·축이동) 거버넌스("무엇이 틀렸나"). 입력 일부 공유하나 목적·산출 다름.
- **huni-dbmap(§7)과 다름**: dbmap은 전체 매핑·적재 트랙. 이 하네스는 기초데이터 표시중복에 특화 + codex 교차 + 토큰효율 탐색.

## 핵심 원칙 [HARD]

1. **토큰효율 탐색**: 엑셀을 컨텍스트로 반복 Read 금지. 1회 스크립트 추출→CSV 캐시→이후 CSV·집계로만. 기존 `_workspace/huni-dbmap/00_schema/ref-*.csv`·`24_master-extract-260610` 재사용.
2. **권위 절대**: 상품마스터 260610 + 인쇄상품 가격표 260527. v03 마이그레이션 인용 금지.
3. **생성≠검증**: dedup-analyst(Claude 생성) ↔ codex-verifier(독립 2nd opinion) ↔ load-executor(사후 라이브 재실측). codex 주장=가설.
4. **적재 안전경계**: 안전분(가격비종속) + 미적재 신규만 실행. 가격종속(component_prices 참조)은 BLOCKED 보류. 백업→DRY-RUN→승인→COMMIT.
5. **통과 인정**: 검수 결과 정리/적재할 것 없으면 NO-OP 명시.

## 실행 모드: 하이브리드 파이프라인

`hbd-source-harvester`(추출) → `hbd-dedup-analyst`(4축 판정·매핑) → `hbd-codex-verifier`(codex 교차) → [사용자 승인] → `hbd-load-executor`(안전 적재). 각 단계 `Agent(model: "opus")`로 호출(서브 에이전트 패턴, 결과는 파일+반환). 동시 다축이면 축별 파이프라인 병렬.

## 워크플로우

### Phase 0: 컨텍스트 확인
`_workspace/huni-basedata-dedup/<axis>/` 존재 여부로 초기/부분재실행/새실행 판별. 부분 수정 요청이면 해당 단계 에이전트만 재호출.

### Phase 1: 추출 (hbd-source-harvester)
대상 축(파일럿=사이즈)을 1회 추출→`index.csv`·`authority.csv`·`live.csv`·`harvest-manifest.md`. 기존 캐시 재사용 우선. → **D1 게이트**.

### Phase 2: 4축 검수·매핑 (hbd-dedup-analyst)
canonical 도출→환원→충돌(②③)·불일치(①) 검출, ④로 정당구분 보존. `mapping.csv`·`dedup-report.md`·`apply-plan.md`. 정리/적재 0건이면 PASS 보고. → **D2·D3 게이트**.

### Phase 3: codex 2차 교차검증 (hbd-codex-verifier)
`codex-review.sh`로 매핑·적재명세 독립 검토→`reconcile.md`. divergence는 Phase 2로 반려. codex 미가용 시 Claude 단독 폴백 명시. → **D4 게이트**.

### Phase 4: 사용자 승인 (오케스트레이터)
`AskUserQuestion`으로 정리/적재 매핑데이터 요약 + BLOCKED 목록 + divergence 처리안을 제시하고 실행 승인을 받는다. 적재할 것이 없으면 "통과" 보고로 종료.

### Phase 5: 안전 적재 (hbd-load-executor)
승인+합의+가격비종속 행만 백업→DRY-RUN→COMMIT→사후 재실측. → **D5·D6 게이트**.

### Phase 6: 진화·확장
사이즈 파일럿 검증 후, 동일 파이프라인으로 5축(공정·자재·기초코드·인쇄옵션·도수) 전파. CLAUDE.md §17 변경 이력 갱신.

## 게이트 D1~D6

| 게이트 | 판정 |
|---|---|
| D1 추출 충실성 | 캐시=엑셀/라이브 verbatim·freshness 기록·날조 0 |
| D2 중복판정 정확성 | ②③ 충돌이 진짜 중복·④ false-positive(작업/재단/단위) 0 |
| D3 정리 무손실 | 통합 시 단가행·바인딩 보존·물리삭제 0·search-before-mint |
| D4 codex 교차 합의 | Claude↔codex reconcile·divergence 해소(미해소 적재 금지)·미가용 폴백 명시 |
| D5 적재 안전성 | 멱등·BLOCKED 미실행·백업·DRY-RUN·사후 delta 일치·FK고아 0 |
| D6 생성-검증 독립성 | codex 독립 + executor 라이브 재실측·생성자 주장 비신뢰 |

## 데이터 전달

파일 기반(`_workspace/huni-basedata-dedup/<axis>/`) + 반환값. 파일명 컨벤션: 단계별 표준 산출물(위 Phase 참조). 자격증명은 `.env.local RAILWAY_DB_*`(SELECT)·codex는 ChatGPT OAuth.

## 에러 핸들링

- 에이전트 실패 1회 재시도, 재실패 시 누락 명시하고 진행(필수 단계는 중단·보고).
- codex 미가용 → Claude 단독 + 보수적 적재(고확신·가격비종속·표시정규화 한정).
- 상충 데이터 삭제 금지·출처 병기. BLOCKED는 보류 큐.

## 테스트 시나리오

- 정상: 사이즈 추출(캐시 재사용)→4축 검수에서 표시중복 N건·오적재 M건 발견→codex 합의→승인→안전분 적재→사후검증 GO.
- 통과: 검수 결과 중복·오적재·미적재 0건 → "통과(NO-OP)" 보고로 종료.
- 에러: codex 데드락 → preflight가 UNAVAILABLE → Claude 단독 폴백 명시 → 보수적 적재 권고.

ARGUMENTS: $ARGUMENTS
