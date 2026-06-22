---
name: huni-price-engine-design-orchestrator
description: >
  후니프린팅 가격계산 엔진 설계·구축 하네스 오케스트레이터. 역공학 자료+상품마스터(260610) 가격계산공식+인쇄상품
  가격표(260527)+경쟁사(와우프레스·레드프린팅)를 종합해, 모든 상품군 완제품·반제품(세트상품)의 가격공식+가격구성요소를
  라이브 evaluate_price가 먹는 t_prc_* 그릇 설계 명세로 산출(아직 없는/불완전한 가격공식을 새로 설계). 5인 팀(formula-cartographer·
  benchmark-analyst 기준점 → engine-designer 설계 → validator E1~E7 게이트 → codex-validator Phase5.5). 대표 파일럿→동형 전파·
  생성≠검증·codex 주장=가설·권위 엑셀 절대권위·라이브 읽기전용·DB 미적재(실 COMMIT/DDL 인간 승인). 트리거: 가격계산 엔진 설계,
  가격공식/가격구성요소 설계, 완제품 반제품 세트 가격, 경쟁사 가격계산 흡수, t_prc 그릇 설계, codex 설계 검증, 엔진 설계
  하네스 실행/재실행, 특정 상품군만 엔진 설계. 이미 적재된 가격 검증·게이트는 huni-price-quote(§13), 5장치 이해·진단은
  huni-price-engine-diag(§14), 단일 상품 온디맨드 검증은 huni-quote-verify(§15), 시각화는 huni-recipe-viz(§16)가 담당.
---

# huni-price-engine-design-orchestrator — 가격계산 엔진 설계 하네스

역공학 + 상품마스터 가격공식 + 경쟁사 벤치마크를 종합해 전 상품군 완제품·반제품의 **가격공식+가격구성요소를 설계**한다.

## 정체성 (기존 가격 하네스와 경계 [HARD])

이미 가격 관련 하네스가 5개 있다 — 전부 **검증·진단·이해·시각화**다(메모리: "가격 4하네스=중복 아닌 상보 레이어·재병합 금지"):
- §7 dbmap(적재) · §13 price-quote(게이트) · §14 engine-diag(이해) · §15 quote-verify(온디맨드 검증) · §16 recipe-viz(시각화).

본 하네스(§18)는 그것들과 달리 **설계·구축** 각도다 — *아직 없는/불완전한 가격공식*을 상품마스터 권위 + 경쟁사 흡수 + 역공학으로 **새로 설계**한다(완제품 + 반제품 세트상품). 그 5개 산출을 입력으로 재사용한다. 산출=**라이브 evaluate_price가 먹는 t_prc_* 설계 명세**(새 엔진 코드 아님·webadmin 코드 직접수정 금지)·**DB 미적재**(실 적용 인간 승인).

## 실행 모드: 하이브리드 (기준점 팬아웃 → 설계 → 검증 → codex 교차)

- Phase 1 기준점: `hpe-formula-cartographer`(후니 내부+역공학) + `hpe-benchmark-analyst`(경쟁사) **병렬 팬아웃**.
- Phase 2 설계: `hpe-engine-designer` 단일(생성).
- Phase 3 검증: `hpe-validator` E1~E7(Claude 독립 게이트).
- Phase 3.5(=Phase 5.5) codex 교차: `hpe-codex-validator`(codex gpt-5.5 독립 2nd opinion·reconcile).
- Phase 4 정립: 확정 결함/개선 → `dbm-price-arbiter` 심의 + 인간 승인 큐.
- 모든 Agent 호출 `model: "opus"`. 신규 hpe-* 에이전트가 레지스트리 미로드면 general-purpose로 정의파일 읽혀 실행(생성 세션엔 미반영·다음 호출부터 가용).

## 워크플로

### Phase 0: 컨텍스트 확인
1. `_workspace/huni-price-engine-design/` 존재로 모드 판별: 미존재=초기, 존재+부분요청=부분 재실행(해당 에이전트만), 존재+새 입력=새 실행(이전 `_prev`).
2. 대표 상품군(파일럿) 확정 — 사용자 미지정 시 디지털인쇄(가장 단순·기존 설계 多) 또는 사용자 AskUserQuestion. 완제품 먼저 → 반제품(세트) 확장은 같은 파일럿 안에서.

### Phase 1: 기준점 팬아웃 (병렬·독립)
- `hpe-formula-cartographer` → `01_formula/`: formula-map·component-inventory·reverse-price-contracts·gap-board.
- `hpe-benchmark-analyst` → `02_benchmark/`: competitor-pricing-models·absorption-candidates·set-pricing-patterns.
- 단일 메시지 2 Agent 병렬(독립 수집).

### Phase 2: 설계 (생성)
- `hpe-engine-designer` → `03_design/`: engine-design-<sheet>·set-product-design·design-decisions·golden-cases.
- 입력 충돌 시 권위 엑셀 우선(경쟁사=갭헌팅). search-before-mint 강제.

### Phase 3: 검증 (Claude 독립 게이트)
- `hpe-validator` → `04_validation/`: gate-verdict(E1~E7)·recompute-log·validation-summary.
- NO-GO/보정 → designer 폐루프(Phase 2 재호출, 변경분만).

### Phase 5.5: codex 독립 2차 교차검증
- `hpe-codex-validator` → `05_codex/`: codex-verdict·codex-reconcile.
- ★독립성: codex 프롬프트엔 설계·지도·골든만(hpe-validator 판정 비노출). codex 미가용 시 "Claude 단독" 명시 폴백(중단 없음).
- 메인이 hpe-validator ↔ codex reconcile 종합: 합의=고신뢰 확정·불일치=조사(라이브 재실측 또는 라우팅).

### Phase 4: 정립 + 동형 전파
- 종합 판정(이 상품군 가격계산 설계 GO/조건부/NO-GO) + 확정 결함 → `dbm-price-arbiter` 심의(정립안·트랙·trade-off).
- 파일럿 GO 후 동형 클래스(공식 frm_cd 기준·시트 아님)로 나머지 상품군 자동 전파(대표 설계 superset 일반화 금지·상품군마다 재확인).
- 진행 보드 갱신 + 인간 승인 큐(실 COMMIT/DDL은 dbmap 위임).

## 데이터 전달 프로토콜
- 파일 기반: `_workspace/huni-price-engine-design/{_meta,01_formula,02_benchmark,03_design,04_validation,05_codex}/`.
- 반환값 기반: 서브 에이전트 결과 메인 수집. 각 블록에 출처(셀/file:line/SQL)·확신도.
- 파일명 컨벤션: `<artifact>-<sheet>.md`.

## 에러 핸들링
- 에이전트 1회 재시도 후 재실패 시 결과 없이 진행(누락 명시). 상충 데이터는 삭제 않고 출처 병기.
- codex 데드락/인증만료 → "codex 미가용·Claude 단독" 폴백(pending 금지). 분해/식별 실패 → 컨펌큐 AskUserQuestion 후 재개(서브 에이전트는 질문 금지).

## 권위·안전 규칙 [HARD]
- 권위: 상품마스터(260610) 가격계산공식 + 인쇄상품 가격표(260527) 절대 권위. evaluate_price=단일 권위 알고리즘. 역공학·경쟁사=흡수·갭헌팅(naming/codes 후니 유입 금지·권위 덮어쓰기 금지). v03/STALE 인용 금지.
- 라이브 DB `.env.local RAILWAY_DB_*` 읽기전용 SELECT만. 경쟁사=읽기전용 가격조회(주문/결제/POST 금지). codex `-s read-only`. 비밀값(_workspace·stdout·codex 프롬프트) 비노출.
- **생성≠검증**: designer ↔ validator ↔ codex-validator 독립. codex 주장=가설(환각 경계·라이브 검증 전 채택 금지).
- **DB 미적재**: 설계·명세 전용. 실 COMMIT/교정/DDL은 인간 승인 후 dbmap 트랙(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer) 위임. webadmin 코드 직접수정 금지(개발자 GitHub·read-only).

## 기존 자산 재사용
- 입력(권위 아님·인용): `_workspace/huni-price-quote/{01_engine,02_authority}/`(engine-contract·골든)·`huni-price-engine-diag/{03_synthesis,04_binding_validity}/`(5장치·SOT·10차원·U-7)·`huni-rpmeta/02_metamodel/`(옵션 메타모델)·`huni-dbmap/`(t_prc_* 적재 산출).
- 스킬: `dbm-schema-extract`·`dbm-excel-parse`·`dbm-price-arbiter`·`dbm-ddl-proposer`. codex: `hqv-codex-cross-verify/scripts/codex-review.sh`(내부에서 `rpm-visualize/scripts/codex-preflight.sh` 호출).

## 테스트 시나리오
- **정상**: "디지털인쇄 가격엔진 설계" → Phase1 cartographer(공식지도·역공학계약) ∥ benchmark(경쟁사 흡수) → Phase2 designer(공식+구성요소+세트 설계) → Phase3 validator E1~E7(골든 재현) → Phase5.5 codex 독립 reconcile → Phase4 arbiter 정립 + 동형 전파. 산출: `_workspace/huni-price-engine-design/`.
- **에러**: codex 데드락 → codex-validator "미가용·Claude 단독" 폴백·E게이트 단독 마감(pending 금지). 또는 골든 재현 E6 FAIL → designer 폐루프 재설계 → 재게이트.
