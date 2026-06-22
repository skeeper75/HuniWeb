---
name: huni-admin-manual-orchestrator
description: >
  후니 라이브 Django admin 운영자 사용 매뉴얼 작성 하네스 오케스트레이터 — raw/webadmin 소스 분석→라이브 DB 코드값 검증∥
  화면 스크린샷 캡처→step-by-step 매뉴얼 집필(스크린샷 임베드)→전수 커버리지 QA→MkDocs 발행까지 6인 ham-* 팀.
  표준 Django admin·커스텀 상품뷰어 양 레이어 전수. 라이브 읽기 탐색만(저장/삭제 금지). 트리거: admin 매뉴얼,
  관리자/운영자 매뉴얼, webadmin 매뉴얼, 화면 캡처 매뉴얼, 매뉴얼 검증, 문서 사이트 발행/mkdocs/docs-as-code,
  특정 화면만 매뉴얼, 매뉴얼 재실행/업데이트/보완. 단순 질문은 직접 응답.
---

# Huni Admin 매뉴얼 하네스 오케스트레이터

라이브 후니 Django admin의 **운영자 사용 매뉴얼**(전 화면 전수 + 실제 스크린샷 임베드)을 5인 에이전트 팀으로 산출하는 통합 스킬.

## 실행 모드: 에이전트 팀

순차 의존(소스맵=뿌리 → 캡처/DB → 작성 → QA)이 강한 파이프라인이지만, 팀 모드로 구성해 의존성은 `TaskCreate` `depends_on`으로 표현하고, 캡처↔DB↔작가↔QA의 실시간 보정은 `SendMessage`로 처리한다.

## 에이전트 구성

| 팀원 | 역할 | 스킬 | 출력 |
|------|------|------|------|
| ham-source-analyst | Django admin 소스 전수 → 화면 맵 | huni-admin-source-map | `01_source_admin-screen-map.md` |
| ham-db-verifier | 라이브 DB 코드값·제약 실측 | dbm-schema-extract(재사용) | `02_db_value-domains.md` |
| ham-live-capturer | 라이브 화면 gstack 캡처 | huni-admin-live-capture | `captures/*.png`, `03_capture_screen-index.md` |
| ham-manual-writer | 운영자 매뉴얼 집필 | huni-admin-manual-authoring | `MANUAL.md` (또는 `manual/*.md`) |
| ham-manual-qa | 전수 커버리지·정합 검증 | huni-admin-live-capture(재확인) | `04_qa_manual-gate.md` |
| ham-docs-publisher | 매뉴얼→MkDocs 문서 사이트 발행·CI | huni-admin-docs-publish | `site-src/`·`.github/workflows/docs.yml` |

산출물 루트: `_workspace/huni-admin-manual/`

## 워크플로우

### Phase 0: 컨텍스트 확인 (후속 작업 지원)

1. `_workspace/huni-admin-manual/` 존재 여부 확인.
2. 실행 모드 결정:
   - **미존재** → 초기 실행. Phase 1로.
   - **존재 + 부분 수정 요청**(예: "옵션 화면 매뉴얼만 다시", "캡처만 갱신") → 부분 재실행. 해당 에이전트만 재호출, 이전 산출물 중 수정 대상만 덮어쓴다.
   - **존재 + 소스/사이트 변경** → 새 실행. 기존 `_workspace/huni-admin-manual/`을 `_workspace/huni-admin-manual_prev/`로 이동 후 Phase 1.

### Phase 1: 준비

1. 대상 파악: `raw/webadmin/`(소스), 라이브 URL, `.env.local`(`HUNI_ADMIN_*` 캡처·로그인, `RAILWAY_DB_*` DB검증).
2. `_workspace/huni-admin-manual/`와 하위 `captures/`, `scripts/` 생성.
3. 안전 원칙 주지: 라이브 운영 DB — DB는 읽기전용 SELECT만, 라이브 화면은 읽기 탐색만(저장/삭제 클릭 금지), 비밀값 비노출.

### Phase 2: 팀 구성

`TeamCreate(team_name: "huni-admin-manual-team", members: [...])` — 5인을 각자 역할 프롬프트(+`model: "opus"`)로 구성.

`TaskCreate`로 의존성 명시:
- T1 화면 맵 작성 → `ham-source-analyst` (의존 없음, 뿌리)
- T2 DB 코드값 검증 → `ham-db-verifier` (depends_on: T1)
- T3 라이브 캡처 → `ham-live-capturer` (depends_on: T1)
- T4 매뉴얼 집필 → `ham-manual-writer` (depends_on: T2, T3)
- T5 매뉴얼 QA → `ham-manual-qa` (depends_on: T4)

> T2·T3는 T1 완료 후 **병렬**. T5는 작가가 챕터를 낼 때마다 점진 검증(전체 완성 후 일괄 금지).

### Phase 3: 실행 (팀 자체 조율)

1. `ham-source-analyst`가 화면 맵을 먼저 완성하고 팀에 알린다(뿌리).
2. `ham-db-verifier`·`ham-live-capturer`가 화면 맵을 Read해 병렬 진행. 캡처가는 DB검증가에게 "이 드롭다운에 어떤 값이 보여야 하나"를 SendMessage로 질의 가능.
3. `ham-manual-writer`가 세 산출물을 종합해 챕터별 집필. 캡처 누락 화면은 텍스트 묘사+`[스크린샷 추가 예정]`로 막지 않고 진행.
4. `ham-manual-qa`가 챕터 완료분부터 소스맵·캡처·DB와 교차검증, 결함을 작가에 SendMessage 환원.

**리더 모니터링:** TaskGet으로 진행 확인. 팀원이 막히면(자격증명·라이브 접속·복합PK 등) SendMessage로 지시 또는 재할당.

### Phase 4: 통합·판정

1. 모든 작업 완료 대기.
2. `04_qa_manual-gate.md`의 GO/NO-GO 확인. NO-GO면 결함을 작가에 재할당해 Phase 3 일부 반복.
3. GO면 최종 매뉴얼(`MANUAL.md` 또는 `manual/00_index.md`) 확정.
4. 커버리지 요약(화면 N개 중 매뉴얼 수록 N개·캡처 N개)을 리더가 사용자에 보고.

### Phase 4.5: 문서 사이트 발행 (선택 — docs-as-code)

매뉴얼이 QA GO면, `ham-docs-publisher`로 Material for MkDocs 사이트를 발행한다(`huni-admin-docs-publish` 스킬). 원본 매뉴얼 불가침 — `site-src/`에 mkdocs.yml·정규화 빌드 스크립트(`build_docs.py`)·`requirements-docs.txt`·`README.md`와 `.github/workflows/docs.yml`(빌드·배포만 자동, 매뉴얼 재생성은 사람이 트리거) 산출, `mkdocs build --strict`로 깨진 링크·이미지 0 검증. 호스팅 연결(GitHub Pages 활성화·cross-repo 시크릿)은 인간 승인. webadmin(별도 레포 HuniProductPrice2) 코드 변경 시 매뉴얼 갱신은 사람이 하네스로 트리거 → 갱신 push → CI 자동 발행.

### Phase 5: 정리

1. 팀원 종료(SendMessage), `TeamDelete`.
2. `_workspace/huni-admin-manual/` 보존(중간 산출물 감사 추적).
3. CLAUDE.md §8 변경 이력 갱신 + 사용자 보고.

## 데이터 흐름

```
[리더] TeamCreate + TaskCreate
   │
   ▼
ham-source-analyst ── 01_source_admin-screen-map.md (뿌리)
   │                         │
   ├──────────┬──────────────┘
   ▼          ▼
ham-db-     ham-live-       (병렬, T1 의존)
verifier    capturer
02_db_*     03_capture_* + captures/*.png
   │          │
   └────┬─────┘
        ▼
  ham-manual-writer ── MANUAL.md
        │
        ▼
  ham-manual-qa ── 04_qa_manual-gate.md (GO/NO-GO)
        │
        ▼
   [리더: 최종 확정·보고]
```

## 에러 핸들링

| 상황 | 전략 |
|------|------|
| gstack 라이브 접속 실패 | 캡처가 1회 재시도. 재실패면 텍스트 화면 묘사로 폴백(매뉴얼에 `[스크린샷 미수집]` 명시), 리더 보고 |
| DB 접속 실패 | DB검증가가 소스 선언 choices만으로 채우고 "(라이브 미검증)" 플래그 |
| 한 화면 진입 실패(권한·404) | 인덱스에 사유 기록, 다음 화면 진행(한 화면이 전체를 막지 않음) |
| 소스↔라이브 불일치 | 삭제하지 않고 출처 병기, 라이브를 시각 권위로 기록·QA 검토 |
| QA NO-GO 반복(2회+) | 근본원인(입력 산출물 결함 vs 작가 누락) 진단 후 리더 에스컬레이션 |
| 복합PK 모델 단독 화면 없음 | 부모 인라인 절차로 기술(독립 화면 아님 — 화면 맵의 인라인 매핑 사용) |

## 안전 수칙 [HARD]

- **라이브 운영 DB**: DB는 읽기전용 SELECT만. 라이브 화면은 읽기 탐색만 — **저장/추가/삭제/논리삭제/제출 버튼 클릭 금지**.
- 자격증명(`HUNI_ADMIN_*`, `RAILWAY_DB_*`)은 `.env.local`에서만 읽고 산출물·stdout·스크린샷에 비노출.
- `_workspace/`(git 추적)에 비밀값 금지.

## 테스트 시나리오

### 정상 흐름
1. 사용자가 "admin 매뉴얼 작성" 요청.
2. Phase 1에서 `_workspace/huni-admin-manual/` 생성.
3. Phase 2에서 5인 팀 + 5작업(의존성) 구성.
4. 화면 맵 완성 → DB검증·캡처 병렬 → 집필 → QA 점진 검증.
5. Phase 4에서 QA GO, 최종 매뉴얼 확정.
6. 예상 결과: `_workspace/huni-admin-manual/MANUAL.md`(또는 `manual/`) + `captures/*.png` + 전수 커버리지.

### 에러 흐름
1. Phase 3에서 캡처가가 라이브 로그인 실패.
2. 리더가 유휴 알림 수신, SendMessage로 자격증명 재확인 지시.
3. 재실패 시 작가가 해당 화면을 텍스트 묘사로 작성, 매뉴얼에 `[스크린샷 미수집]` 표시.
4. QA가 미수집 화면을 게이트에 기록, 나머지로 GO.
5. 최종 보고에 "캡처 N건 미수집(라이브 접속 이슈)" 명시.
