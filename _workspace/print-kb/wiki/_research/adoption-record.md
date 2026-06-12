# Print-KB 위키 — 방법론 권고 채택 기록 (adoption-record)

> 작성 2026-06-12. 입력 = `_research/methodology-recommendations.md`(R-1~R-8).
> 본 문서 = 어느 권고를 위키 스키마/집필에 반영하기로 했는지의 기록.
> **채택 상태: 잠정(暫定)** — 오케스트레이터 권고안을 작가가 채택해 반영하나, **사용자 명시 비준 대기**. 사용자 반박 시 해당 R 롤백.

---

## 채택 결과

| R-ID | 제안 한 줄 | 분류 | 결정 | 반영 위치 |
|---|---|---|---|---|
| R-1 | index.md를 llms.txt 형식(H2+불릿 링크)으로 정렬 | MINOR | **채택** | `index.md`·README §2 |
| R-2 | 레시피·축을 index.md 1급 섹션(RECIPES/AXES)으로 추가 | MINOR | **채택** | `index.md`·README §2 |
| R-3 | base 레이어 토대 페이지를 레시피보다 먼저 집필 | SCHEMA | **채택** | `base/*` 6 신규 페이지 |
| R-4 | base 사실에 [검증]/[단일출처] 신뢰도 badge 도입 | MINOR | **채택** | README §1·§3·base/* |
| R-5 | 레시피 상단에 CQ 헤더(답하는 질문) 추가 | MINOR | **채택** | README 레시피 템플릿 §·recipes/*(차기) |
| R-6 | 레시피 섹션 자기완결성(청킹 경계) 강화 | MINOR | **채택** | README 레시피 템플릿 §·recipes/*(차기) |
| R-7 | 항목ID를 안정 @id로 운용(교차참조 lint 규칙) | MINOR | **채택** | README §3·lint 규칙 |
| R-8 | 라이브 현재값 vs 정답 양면 표기를 7절 필수 슬롯화 | MINOR | **채택** | README 레시피 템플릿 §7·recipes/*(차기) |

**전건 채택(8/8). 기각 0건.**

---

## A-11 (base-verification 권고) 처리

- `base-verification.md` A-11 = "1상품=1인쇄방식·인쇄방식=최상위 분기축"은 **후니 모델링 명제(보편 아님)** → base에서 제거, huni 레이어로 이동.
- **결정: huni 레이어 이동 채택.** `base/printing-methods.md`에는 보편 사실("방식→후가공/소재 종속")만 잔류. 모델링 명제는 `huni/modeling-axioms.md`(신설)에 출처 병기로 이동(삭제 없음).
- 근거: A-11 verdict = SINGLE/모델링 명제(외부 재단 제외). 메모리 `dbmap-print-method-not-absolute-axis`("인쇄방식 절대축 아님·시트=1차 이해단위")와 정합.

---

## 채택 근거 요약

- R-1·R-2: Karpathy 워크플로("updates the index on every ingest") + llms.txt 명세 정합. index가 콘텐츠 전부(레시피·축)를 반영해야 query 진입 성립. 형식 정렬·내용 불변.
- R-3: 본 위키 자체 설계 의도(README §1 "base를 토대로 깔고 그 위에 huni") + 단일 사실 원칙(축/base에 1회·레시피는 링크)의 선결 조건. base 사실은 `base-verification.md`에 외부 표준 교차검증 완료.
- R-4: 본 하네스의 검증 역할 산출(verdict)을 사실 단위로 표기할 슬롯. huni badge(✅🟡🔴⚪)와 별개 축(출처 신뢰도) — 충돌 없음.
- R-5·R-6·R-8: 미래 LLM의 레시피 retrieval 진입·청크 자기완결·라이브 오적재 오인 방지. 차기 레시피 집필 시 발현.
- R-7: 페이지 분할(500줄 근접) 시 교차참조 깨짐 방지. 선제 lint 규칙.

---

## 롤백 조건

- 사용자가 특정 R를 반박하면 해당 R 반영분만 되돌린다(다른 R 보존).
- R-3(SCHEMA)이 반박되면 base 6페이지는 보존하되 index 카탈로그 등재만 보류 가능.
