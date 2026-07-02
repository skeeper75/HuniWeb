---
name: huni-ontology-kb-orchestrator
description: 후니 온톨로지 지식베이스 하네스(Huni-Ontology-KB) 오케스트레이터. docs/kb·권위 엑셀 260702·§9 print-kb 위키(승계)·전 하네스 산출물·라이브 DB를 원천으로, 자연어 질의→상품 추천→가격 제시가 가능한 온톨로지 기반 지식베이스(파일 정본 SOT + 그래프 DB 파생 빌드)를 구축한다. 6인 팀(okb-methodology-researcher ∥ okb-source-curator 기준점 팬아웃 → okb-ontology-architect 스키마[인간 승인] → okb-knowledge-builder 구축 → okb-adversarial-verifier 적대 검증 루프 → okb-query-gate O1~O7 종단 게이트). ★실행 모드=dynamic workflow(Workflow 툴·게이트 통과까지 루프). '온톨로지 지식베이스', '온톨로지 KB', '지식데이터베이스 구축', '자연어 상품 추천', '지식그래프 구축', 'KB 구축/확장/재실행/업데이트/보완', '적대적 검증 실행', '질의 게이트 실행', '특정 상품군만 KB', '그래프 재빌드', '위키 승계' 등 본 도메인 요청 시 반드시 이 스킬을 사용. 단순 질문(KB 내용 조회)은 03_kb/index.md 직접. §9 위키 집필 자체는 print-kb-wiki-orchestrator.
---

# Huni-Ontology-KB 오케스트레이터

**목표:** 후니의 전 분석 자산을 온톨로지 기반 지식베이스로 재구성해, 자연어 질의 → 상품 추천 → 가격 제시를 KB 탐색만으로 가능하게 한다. 적대적 검증으로 오염/오해석 데이터를 필터링한다.

**핵심 결정(사용자 확정 · relitigate 금지):**
1. §9 print-kb 위키 **승계+재사용 신규 하네스** (위키 페이지를 원천 입력으로 흡수·재검증, §9와 상보·재병합 금지)
2. **파일 = 정본(SOT), 그래프 DB = 결정론 빌드 파생물** (그래프에만 존재하는 사실 금지·언제든 재빌드)
3. **대표 상품군 1개 종단 파일럿** → 검증된 방법을 동형 전파
4. 실행 모드 = **dynamic workflow** (Workflow 툴로 phase 구동·게이트 NO-GO 시 해당 단계 루프)

**권위[HARD]:** 상품마스터 260702 + 인쇄상품 가격표 260702(구 260610/260527 대체). 가격값 권위=라이브 evaluate_price. 분류=product-type-classification-sot. 도메인 규칙=HARNESS-DOMAIN-RULES-260701. 라이브 읽기전용 SELECT만·DB 미적재·LLM 숫자 손전사 금지.

## 팀 구성

| 에이전트 | 역할 | Phase |
|---|---|---|
| okb-methodology-researcher | 방법론 리서치(5렌즈: 제품 온톨로지·KG 구축·GraphRAG·자기개선·적대 검증) | 1 |
| okb-source-curator | 원천 레지스트리·§9 위키 승계 맵·파일럿 큐레이션 팩 | 1 |
| okb-ontology-architect | 온톨로지 스키마·파일 포맷·그래프 빌드 명세·NL 질의 경로 | 2 |
| okb-knowledge-builder | 파일럿 지식 노드/엣지 구축·그래프 빌드 스크립트 | 3 |
| okb-adversarial-verifier | 6축 적대 검증·결함 보드·오염 필터 | 4 (3과 루프) |
| okb-query-gate | 블라인드 NL 시나리오 실측·O1~O7 GO/NO-GO | 5 |

모든 Agent/workflow agent 호출에 `model: opus` 이상(기본=세션 모델 상속). 생성≠검증 — builder 산출을 verifier/gate가 자기 확인 없이 독립 재실측.

## Phase 0: 컨텍스트 확인 (매 실행)

1. `_workspace/huni-ontology-kb/` 산출물 존재 확인:
   - 없음 → 초기 실행(Phase 1부터)
   - 있음 + 부분 요청("검증만 다시"·"특정 상품군만") → 해당 Phase만 재실행
   - 있음 + 새 권위 엑셀 버전 → 큐레이터 델타 갱신 → 영향 노드만 재구축·재검증
2. 게이트 이력(`06_query_gate/gate-verdict-*.md`) 확인 — 직전 NO-GO 라우팅이 있으면 그 단계부터.

## Phase 1: 기준점 팬아웃 (research ∥ curation)

**실행:** Workflow 툴 — 리서치 5렌즈 병렬 + 큐레이션 3작업(원천 레지스트리 / 위키 승계 맵 / 파일럿 팩) 병렬, 이후 종합 2 agent.
파일럿 상품군 미확정이면 큐레이터 산출(원천 밀도·§9 레시피 성숙도·가격사슬 완결성 기준 추천)을 근거로 AskUserQuestion으로 확정.
산출: `00_research/methodology-playbook.md` + `01_curation/{source-registry,wiki-inheritance-map,pack-*}.md`

## Phase 2: 온톨로지 스키마 설계 → ★인간 승인 게이트

architect가 4산출(schema·file-format·graph-build·nl-query-paths) 설계 → verifier가 **스키마 단계 적대 리뷰**(NL 경로 증명 구멍·t_* 앵커 오류·§9 어휘 불필요 재발명) → 사용자에게 스키마 요약+리뷰 결과 보고 후 **AskUserQuestion 승인**. 스키마 미승인 상태로 Phase 3 진입 금지(스키마 결함이 전 노드로 오염되는 것 차단).

## Phase 3: 파일럿 지식 구축

**실행:** Workflow 툴 — builder가 상품 단위로 파이프라인 구축(승계 흡수→노드 작성→수치 스크립트 전사), 마지막에 그래프 빌드+무결성 리포트. 상품 수가 많으면 상품별 agent 팬아웃(같은 스키마·같은 팩 입력).

## Phase 4: 적대적 검증 루프

verifier 6축 검증 → 결함 보드 → builder 교정 → 재검증. **루프 종료 조건: 결함 0 또는 남은 결함 전부가 "원천 자체 결함(실무진 컨펌 필요)"으로 분류·격리됨.** 3회 루프에도 수렴 안 하면 중단하고 사용자 보고(스키마/원천 문제 신호).

## Phase 5: 종단 질의 게이트

query-gate가 블라인드 조건으로 시나리오 ≥12 실측 → O1~O7 판정. GO → Phase 6. NO-GO → 원인 단계로 라우팅 루프(Phase 2/3/4 중).

## Phase 6: 동형 전파 계획 + 핸드오프

파일럿 GO 시: 나머지 상품군 전파 순서(원천 성숙도순)·상품군당 예상 작업량·자기개선 루프 운영안(신규 엑셀 버전 → 델타 재검증 절차)을 `_meta/expansion-plan.md`로. CLAUDE.md §33 변경이력 갱신 + 커밋(§4 핸드오프 루틴 준수).

## 데이터 전달 프로토콜

파일 기반(`_workspace/huni-ontology-kb/` 하위 phase별 디렉토리) + Workflow 반환값(요약·구조화 판정). 중간 산출물 보존(감사 추적). Phase 간 입력은 반드시 이전 phase 산출 파일 경로로 명시.

## 에러 핸들링

- workflow agent 실패 → 1회 재시도 → 재실패 시 해당 항목 누락 명시하고 진행(침묵 누락 금지).
- 원천 충돌(엑셀↔라이브↔위키) → 삭제하지 않고 양면 표기 + 출처 병기, High면 사용자 컨펌 큐.
- codex 미가용 → "Claude 단독" 명시 폴백(pending 금지).
- 권위 엑셀 갱신 감지(파일명 날짜 변경) → 전면 재실행 금지, 셀 diff 델타만(§32 원칙).

## 테스트 시나리오

- **정상:** "온톨로지 KB 구축 시작" → Phase 0(초기)→1→2(승인)→3→4(루프 1회)→5 GO→6 핸드오프.
- **에러:** Phase 5에서 가격 대조 오차 발생 → O2/O6 FAIL → 결함이 KB 오염(builder 라우팅)인지 라이브 결함(양면 분리·§26/§27 큐)인지 판별 → 교정 후 재게이트.
- **후속:** "스티커 상품군도 KB에 추가" → Phase 0(부분)→큐레이터 팩 추가→Phase 3~5만 실행.
