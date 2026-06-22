---
name: huni-quote-verify-orchestrator
description: >
  후니프린팅 상품 가격계산 검증 하네스 오케스트레이터(Claude+Codex 병행). "상품군+상품명"(예: "프린트엽서
  가격계산 검증") 한 줄을 받아 그 상품이 자기 가격공식으로 가격계산 되는지 3축[HARD] 검증(① SOT 일치 상품마스터
  260610↔가격표 260527 ② 공식↔구성요소 매핑 정합 ③ 가격구성요소 차원↔가격테이블 차원 매칭) + 개선안 도출. 흐름:
  분해(product-decomposer) → 병행 검증(quote-verifier 라이브 실측 + codex-cross-verifier gpt-5.5 독립 2nd
  opinion·같은 work-spec) → reconcile → 개선(dbm-price-arbiter). codex 주장=가설(환각 경계)·생성≠검증·라이브
  읽기전용·DB 미적재(실 교정 인간 승인). 트리거: 가격계산 검증, 상품 가격 검증, 프린트엽서 가격검증, SOT 일치
  검증, 공식 구성요소 매핑 검증, 차원 매칭 검증, codex 병행 검증, 특정 상품만 검증, 검증 다시, 개선 수정 보완.
  5장치 이해·진단은 huni-price-engine-diag, 대표 상품군 냉철 게이트는 huni-price-quote가 담당.
---

# huni-quote-verify-orchestrator — 상품 가격계산 검증 하네스 (Claude+Codex 병행)

"상품군+상품명" 한 줄을 받아, 그 상품이 자기 가격공식으로 **가격계산이 되는지** 검증하고 개선/수정/보완안을 도출한다.

## 정체성

기존 huni-price-quote(대표 상품군 파일럿 냉철 게이트)·huni-price-engine-diag(5장치 이해·진단)와 달리, 본 하네스는 **단일 상품 온디맨드 검증+개선** 트랙이다. 그 둘의 산출(engine-contract·골든·SOT·10차원·U-7 유효성)을 입력으로 재사용한다. 차별점:
1. **명령 해독** — "프린트엽서 검증해줘" 한 줄을 상품 요소 전수+공식사슬+골든 work-spec으로 분해.
2. **3축 검증** — SOT 일치 / 공식↔구성요소 매핑 / 차원 매칭.
3. **Claude+Codex 병행** — 라이브 실측(Claude) + 독립 2nd opinion(Codex gpt-5.5), reconcile로 고신뢰.
4. **개선/수정/보완** — 확정 결함을 dbm-price-arbiter 심의로 정립안 도출.

## 실행 모드: 하이브리드 (분해 → 병행 검증 팬아웃 → reconcile → 개선)

- Phase 1 분해: `hqv-product-decomposer` 단일(서브).
- Phase 2 병행 검증: `hqv-quote-verifier`(라이브 실측) + `hqv-codex-cross-verifier`(codex 독립) **병렬 팬아웃**(같은 work-spec·다른 모델·서로 결과 안 봄=독립성).
- Phase 3 reconcile: 메인이 양측 종합(합의/불일치).
- Phase 4 개선: 확정 결함 → `dbm-price-arbiter` 심의(서브).
- 모든 Agent 호출 `model: "opus"`. 신규 hqv-* 에이전트가 레지스트리 미로드면 general-purpose로 정의파일 읽혀 실행.

## 워크플로

### Phase 0: 명령 파싱 + 컨텍스트
1. 사용자 명령에서 **상품군(카테고리)+상품명** 추출. 불명확하면(상품명만 있고 카테고리 모호 등) AskUserQuestion으로 확정(서브 에이전트는 질문 금지).
2. `_workspace/huni-quote-verify/<product>/` 존재로 모드 판별: 미존재=초기, 존재+부분요청=부분 재실행, 존재+재검증=새 실행(이전 `_prev`).
3. `<product>` = 상품명 슬러그(예: `print-postcard`).

### Phase 1: 분해 (명령 해독)
- `hqv-product-decomposer` → `01_decompose/`: product-spec·golden-cases·verify-workspec.
- 분해 실패(상품 식별 불가·골든 부재)면 컨펌큐로 사용자 확인 후 진행.

### Phase 2: 병행 검증 (팬아웃, 독립)
- `hqv-quote-verifier` → `02_verify/`: 3축 라이브 실측 + evaluate_price 골든 재계산 + verdict-claude.
- `hqv-codex-cross-verifier` → `03_codex/`: codex gpt-5.5 독립 2nd opinion + reconciliation.
- 단일 메시지 2 Agent 병렬. codex 미가용 시 cross-verifier가 "Claude 단독" 명시 폴백(중단 없음).
- ★독립성: codex 프롬프트엔 work-spec만(Claude 판정 비노출).

### Phase 3: reconcile (메인)
- 메인이 verdict-claude ↔ codex reconciliation 종합: 합의(고신뢰 확정)·불일치(divergence 조사·라이브 재실측 또는 컨펌큐).
- 종합 판정: 이 상품 가격계산 되는가 → GO / 조건부 / NO-GO + 확정 결함 목록.

### Phase 4: 개선/수정/보완
- 확정 결함을 `dbm-price-arbiter`로 심의 → 정립안(어느 t_*·무엇·어떻게·트랙·트레이드오프·컨펌). DB 미적재(실 교정은 인간 승인 후 dbmap 위임).
- 진행 보드 갱신 + 인간 승인 큐.

## 데이터 전달 프로토콜
- 파일 기반: `_workspace/huni-quote-verify/<product>/{01_decompose,02_verify,03_codex,04_remediation}/`.
- 반환값 기반: 서브 에이전트 결과 메인 수집.
- 각 결함/골든에 재현 SQL/셀 출처·확신도.

## 권위·안전 규칙 [HARD]
- 권위: 상품마스터(260610)+인쇄상품 가격표(260527) 절대 권위. 라이브·역공학·경쟁사=갭헌팅. v03/STALE 인용 금지.
- 라이브 DB `.env.local RAILWAY_DB_*` 읽기전용 SELECT만. Codex `-s read-only`. 비밀값(_workspace·stdout·codex 프롬프트) 비노출.
- **생성≠검증**: Claude 검증가와 codex 교차검증가 독립. Codex 주장=가설(환각 경계·라이브 검증 전 채택 금지).
- **DB 미적재**: 검증·명세 전용. 실 COMMIT/교정/DDL은 인간 승인 후 dbmap 트랙(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer) 위임.

## 기존 자산 재사용
- 입력(권위 아님·인용): `_workspace/huni-price-quote/{01_engine,02_authority}/`·`_workspace/huni-price-engine-diag/{03_synthesis,04_binding_validity}/`.
- 스킬: `dbm-schema-extract`·`dbm-excel-parse`·`dbm-price-arbiter`. codex: `rpm-visualize/scripts/codex-preflight.sh`·`hqv-codex-cross-verify/scripts/codex-review.sh`.

## 테스트 시나리오
- **정상**: "프린트엽서 가격계산 검증해줘" → Phase1 분해(프린트엽서 prd_cd·요소·PRF·골든) → Phase2 Claude 실측(3축+재계산) ∥ codex 독립 → Phase3 reconcile(합의/불일치) → Phase4 결함 개선 심의. 산출: `_workspace/huni-quote-verify/print-postcard/`.
- **에러**: codex 데드락/인증만료 → cross-verifier가 "codex 미가용·Claude 단독" 명시 폴백 → Phase3 reconcile을 Claude 단독 판정으로 마감(pending 금지). 또는 분해가 상품 식별 실패 → 컨펌큐 AskUserQuestion 후 재개.
