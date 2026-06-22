---
name: huni-basecode-orchestrator
description: >
  후니프린팅 기초코드 거버넌스 하네스 오케스트레이터. 6축(자재/사이즈/도수/인쇄옵션/공정/기초코드+카테고리)의
  기초코드를 개선/보완/수정하기 위해 rpmeta 그릇 처방(vessel-gap)∩dbmap 데이터 진단(round-13/22)+인쇄 도메인+
  역공학+경쟁사를 종합해 "기초코드 등록 명세 마스터"를 도출. 권위[HARD]=상품마스터(260610)+가격표(260527)(역공학·
  경쟁사=갭헌팅 보강·덮어쓰기 금지). 4인 팀(authority-curator→diagnostician→registration-designer→validator)으로
  권위 정답 사전→4-way 진단→등록 명세→B1~B6 게이트. 분석·명세 전용·실 COMMIT은 dbmap(dbm-load-execution·
  dbm-axis-staged-load) 위임·인간 승인. Phase 5 교정 실행 트랙(remediation-planner)=우선순위 로드맵·가격사슬
  영향·단계별 승인 큐. 트리거: 기초코드 등록, 기초코드 거버넌스, 기초코드 개선/보완/수정, 잘못된 매핑 도출,
  등록 명세 마스터, 4-way 진단, 자재/카테고리 등록명세, 교정 우선순위, 교정 로드맵, 가격사슬 영향, basecode
  하네스 실행/재실행, 특정 축만 등록명세. 단순 질문은 직접 응답.
---

# Huni-Basecode-Governance 오케스트레이터

후니프린팅 **기초코드(자재·사이즈·도수·인쇄옵션·공정·기초코드·카테고리)**를 개선/보완/수정하기 위한 등록 명세
마스터를 산출하는 하네스. rpmeta(그릇 부재 진단)와 dbmap(데이터 교정)의 교집합을 "**무엇을 기초코드로 등록/교정할
것인가**"의 거버넌스 명세로 종합한다.

## 정체성 — 기존 하네스와의 경계 [HARD]

| 하네스 | 목적 | 본 하네스와의 관계 |
|--------|------|-------------------|
| **rpmeta** | RP 거울로 후니 **그릇(스키마)** 부재 판정(vessel-gap) | 입력 인용 — vessel 처방을 등록 명세로 변환 |
| **dbmap round-22** | 라이브 t_* **데이터** 6축 교정 적재 | 입력 인용 — 진단 정합·실 적재 위임 대상 |
| **dbmap round-13** | 라이브 정합 교정 감사 | 입력 인용 — 중복 재진단 금지 |
| **본 하네스** | **기초코드 마스터 등록 의사결정 + 명세** | rpmeta∩dbmap을 등록 명세로 종합 |

본 하네스는 그릇 설계(rpmeta)도 데이터 교정 적재(dbmap)도 **아니다**. 그 둘을 인용해 "**기초코드 마스터에 정확히
무엇을 신규 등록/교정/축이동할 것인가**"의 단일 명세를 만든다. 실 COMMIT은 인간 승인 후 dbmap 적재 트랙 위임.

## 권위 순서 [HARD]

① 상품마스터 + 인쇄상품 가격표 (절대 권위) → ② 라이브 t_* 실측(schema-design-intent-map·ref-*.csv) →
③ 인쇄 도메인 + rpmeta 역공학 → ④ 경쟁사(WowPress/RedPrinting/CIP4). ③④는 권위 빈칸/모호분 보강·갭헌팅만,
권위를 덮어쓰지 못한다.

## 실행 모드 — 에이전트 팀 (하이브리드)

| Phase | 모드 | 에이전트 |
|-------|------|---------|
| 1. 권위 정답 사전 | 단일(서브) | hbg-authority-curator |
| 2. 4-way 진단 | 단일(서브) | hbg-basecode-diagnostician |
| 3. 등록 명세 | 단일(서브) | hbg-registration-designer |
| 4. B1~B6 게이트 | 단일(서브·독립) | hbg-validator |

파이프라인 의존(1→2→3→4)이 강해 각 Phase는 단일 전문가 순차 실행이 자연스럽다. 단 **생성-검증 독립성**[HARD]을
위해 Phase 4 검증가는 Phase 1~3 산출을 **신뢰하지 않고 라이브 직접 재실측**한다. 축을 병렬 확장할 때(6축 전부
회차)는 Phase 1~3을 축 단위로 `TeamCreate` + 병렬화할 수 있다. 모든 Agent 호출에 `model: "opus"` 명시.

## Phase 0: 컨텍스트 확인

1. `_workspace/huni-basecode/` 존재 여부 확인.
   - 미존재 → **초기 실행** (Phase 1부터 전체).
   - 존재 + 부분 수정 요청("자재만 다시"·"카테고리 명세 보완") → **부분 재실행**(해당 축 에이전트만).
   - 존재 + 새 입력(엑셀 버전 갱신·dbmap 신규 COMMIT) → **갱신 실행**(변경 영향 축만).
2. 이번 회차 축 범위 확인(기본 1순위 = 자재·카테고리, 나머지 4축 스캐폴드).
3. dbmap round-22/13 최신 산출·rpmeta vessel 최신본을 입력 레지스트리에 등록.

## Phase 1: 권위 정답 사전 (hbg-authority-curator)

6축 각각의 "후니 정답"을 권위에서 추출 → `01_authority/`. 1순위 = 자재·카테고리 정답 사전, 나머지 스캐폴드.
삼중 바인딩(UI/생산BOM/가격엔진) 인용·추정 0·경쟁사 갭헌팅 보드.

## Phase 2: 4-way 진단 (hbg-basecode-diagnostician)

정답 사전 기준으로 라이브 t_*를 ①권위 ②라이브 ③역공학 ④경쟁사 4-way 대조 → 오염/누락/오매칭/고아 결함 보드 +
라우팅 집계 → `02_diagnosis/`. dbmap 진단 인용·정합(중복 재진단 금지)·라이브 읽기전용 재실측.

## Phase 3: 등록 명세 (hbg-registration-designer)

결함 라우팅을 실행 가능한 등록 명세로 → `03_registration/_registration-master.md`(최종 산출). search-before-mint·
FK 위상·webadmin 적재경로·코드 채번 규칙·영향분석. vessel/DDL 재사용.

## Phase 4: B1~B6 게이트 (hbg-validator)

등록 명세 마스터를 라이브 직접 재실측으로 독립 검증 → `04_gate/gate-verdict.md`. GO/NO-GO. FAIL 시 해당 Phase 재산출.

## Phase 5: 교정 실행 우선순위 (hbg-remediation-planner) — 실 라이브 교정 트랙

Phase 1~4로 GO된 등록 명세를 **라이브에서 실제 교정**하기 위한 트랙. 트리거 = "교정 우선순위/라이브 실제 교정/
교정 로드맵/우선순위로 교정" 등. 등록 명세 GO가 선행 조건(없으면 Phase 1~4 먼저).

1. **로드맵 설계** (hbg-remediation-planner): 전 교정 항목을 5축 스코어링(가역성·위험·효과·FK 의존·돈 크리티컬) → **안전·가역성 우선** 정렬 → wave 그룹핑 → 교정 경로 혼합(가역=라이브 직접 / 근본=경로 Y) → `05_remediation/remediation-roadmap.md`.
2. **가격사슬 영향 분석** [HARD]: 6축 기초코드 교정이 가격공식/구성요소(t_prc_*)에 미칠 영향 라이브 실측 → `05_remediation/price-chain-impact.md`. 깊은 정합은 `dbm-price-arbiter` 협업.
3. **단계별 승인 큐**: wave 단위 인간 승인 카드 → `05_remediation/_approval-queue.md`. 사용자가 wave 단위 GO/STOP.
4. **GO분 실 적재 위임**: 승인 wave를 dbmap 트랙에 위임 — 경로 Y=`dbm-axis-staged-load`, 라이브 직접 멱등 UPSERT=`dbm-load-execution`, 검증=`dbm-validator`+`hbg-validator`, DDL=`dbm-ddl-proposer`. 백업·롤백전용 DRY-RUN 선행.

[HARD] 실 라이브 COMMIT은 wave 단위 인간 승인 후에만. 돈 크리티컬(가격사슬)은 특히 신중. del_yn 권위·P-TRUNCATE 가드 준수.

## 데이터 전달 프로토콜

- **파일 기반**(주 산출): `_workspace/huni-basecode/{01_authority,02_diagnosis,03_registration,04_gate}/`. 중간 산출 보존(감사 추적).
- **반환값 기반**: 각 서브 에이전트가 완료 경로·요약을 리더에 반환.
- 최종 산출 = `03_registration/_registration-master.md`(등록 명세 마스터) + `04_gate/gate-verdict.md`(GO/NO-GO).

## 에러 핸들링

- 1회 재시도 후 재실패 시 해당 결과 없이 진행하되 보고서에 누락 명시.
- 권위 충돌/모호는 삭제하지 않고 출처 병기, 컨펌 필요분은 AskUserQuestion으로 사용자에 확인(오케스트레이터만).
- 라이브 DB는 읽기전용 — 어떤 에이전트도 INSERT/UPDATE/DELETE 금지. 실 적재는 인간 승인 + dbmap 위임.
- `.env.local` `RAILWAY_DB_*`만 자격증명 사용, `_workspace`(git 추적)에 비밀값 금지.

## 보안/안전 [HARD]

- 라이브 운영 DB — 읽기전용 SELECT만. 파괴적 쓰기 0.
- 권위 엑셀·라이브는 읽기, 산출은 명세(md). 실 COMMIT은 인간 승인 후 dbmap 적재 트랙.
- 비밀값을 `_workspace`·stdout·산출물에 노출 금지.

## 테스트 시나리오

**정상 흐름:** "자재 기초코드 등록명세 도출" → Phase 0(초기) → Phase 1 자재 정답 사전 → Phase 2 자재 오염 4-way 진단(.08/.09/.10) → Phase 3 색→본체색/CPQ·형상→siz·구수→bundle 등록 명세 → Phase 4 B1~B6 GO → `_registration-master.md` 산출.

**에러 흐름:** Phase 2에서 정답 사전이 모호해 진단 막힘 → 진단가가 큐레이터에 되돌림 + 리더 escalate → 리더가 AskUserQuestion으로 사용자 컨펌 → 큐레이터 정답 사전 갱신 → 진단 재개.

**부분 재실행:** "카테고리 명세만 보완" → Phase 0(부분) → 카테고리 축만 Phase 1~4 재실행, 자재 산출 보존.
