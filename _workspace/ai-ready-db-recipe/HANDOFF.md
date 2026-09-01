---
status: in-progress
branch: main
timestamp: 2026-09-01T18:09:34+09:00
session_duration_s: 205
files_modified:
  - _workspace/ai-ready-db-recipe/README.md
  - _workspace/ai-ready-db-recipe/AI-READY-LIVE-DB-RECIPE.md
  - _workspace/ai-ready-db-recipe/HANDOFF.md
---

# AI-ready Live DB Recipe — 작업 체크포인트

> 상태: `IN_PROGRESS / SAFE_TO_RESUME`
>
> 저장일: 2026-09-01 KST
>
> 브랜치: `main`
>
> 범위: 오픈소스 중심 AI Read Model 사전작업 설계
>
> 라이브 DB·`raw/webadmin`: 무수정

## 다음 시작점

새 세션에서 아래 순서로 재개한다.

1. 이 문서와 [현재 초안](./AI-READY-LIVE-DB-RECIPE.md)을 먼저 읽는다.
2. `git status --short -- _workspace/ai-ready-db-recipe`로 이 폴더만 상태를 확인한다.
3. 현재 README가 링크하지만 아직 없는 지원 산출물 3개를 작성한다.
   - `AI-READ-MODEL-CONTRACT.md`
   - `SECURITY-AND-ACCEPTANCE-GATES.md`
   - `manifest.example.json`
4. 본문 887줄의 사실·링크·Mermaid를 별도 reviewer가 검수한다.
5. 보안 reviewer의 `CONDITIONAL NO-GO` 세 항목을 본문·지원문서·manifest에 일관되게 반영한다.
6. 독립 gate가 통과한 뒤 사용자에게 설계안을 제시한다. 구현은 별도 승인 전 시작하지 않는다.

재개용 한 줄:

```text
_workspace/ai-ready-db-recipe/HANDOFF.md부터 읽고, 미완성 지원문서 작성 → 사실/보안/다이어그램 독립검수 → 보정 순서로 재개해줘. raw/webadmin과 라이브 DB는 수정하지 마.
```

## 이번 세션에서 완료한 것

- 기존 라이브 viewer seed 재검증
  - 18개 `t_*`
  - `REPEATABLE READ, READ ONLY`
  - `dbAsOf=2026-09-01 01:06:18.71677Z`
  - export 상품행 309, 활성 상품 269, 가격 단가행 25,090
  - 상품마스터·가격표 `260822_1` SHA-256 `VERIFIED`
- 현재 자산 재사용 seam 확인
  - `product-worldmodel-viewer/tools/export_live.py`
  - `live_snapshot.py`
  - `SPEC-PRICEGRID-001`
  - ontology 17 entity / 19 relation 계약
  - 현재 `evaluate_price`와 제약 API의 권위 경계
- 공식 오픈소스 문서 확인
  - PostgreSQL Repeatable Read
  - Apache Parquet/Arrow
  - DuckDB Parquet·security
  - SQLite FTS5
  - JSON Schema 2020-12 / Pydantic
  - 공식 MCP Python SDK stdio
  - SQLGlot / OpenLineage
- 전문 에이전트 6개 결과 수집 완료
  - 자산 인벤토리
  - export 분리 가능성
  - OSS 조사
  - 참조 아키텍처
  - semantic contract
  - security/threat model
- [README](./README.md) 작성
- [상세 레시피 초안](./AI-READY-LIVE-DB-RECIPE.md) 작성
  - 887줄
  - 권위 분리, 전체 구조, OSS stack, Phase 0~6, MCP, refresh, GO 조건 포함

## 이번 세션 결정

1. **서비스 중심이 아니라 artifact-centered/file-first 구조를 채택한다.**
   - 중심은 특정 DB 제품이 아니라 authority + snapshot + tool contract다.
2. **AI가 라이브 PostgreSQL에 직접 연결하지 않는다.**
   - DB credential은 단일 exporter만 가진다.
3. **기존 18-table viewer snapshot을 교체하지 않는다.**
   - 같은 extract에서 별도 `AI-READ-MODEL-001` assembler를 병렬 생성한다.
4. **PostgreSQL/Excel/현재 코드가 계속 권위다.**
   - snapshot은 시점 관측 증거이고 ontology/FTS/vector는 파생물이다.
5. **MVP stack은 PostgreSQL → Parquet → DuckDB/SQLite FTS5 → local stdio MCP다.**
   - Neo4j, 중앙 vector DB, Kafka, Airflow, Kubernetes, 공용 HTTP MCP는 초기 중심에서 제외한다.
6. **Discovery Bundle과 Internal Diagnostic Bundle을 분리한다.**
   - 고객·주문·PII·정확 내부 가격의 노출면을 분리한다.
7. **가격·제약은 LLM이 계산·판정하지 않는다.**
   - `quote_spec`은 `evaluate_price(..., mode="strict")`, `validate_spec`은 현재 deterministic evaluator adapter다.
8. **상태 축을 분리한다.**
   - `authorityStatus`, `dataStatus`, `evaluationStatus`를 한 필드로 합치지 않는다.

## 미해결·블로커

### 운영 연결 전 필수 3건

1. `SELECT *` 제거와 명시적 column allowlist
2. DB role 자체의 physical SELECT-only 증명
3. private ACL, manifest signature, freshness gate

이 셋이 닫히기 전 운영 AI/MCP 연결 판정은 `CONDITIONAL NO-GO`다.

### 추가 미결정

- 현재 live `t_*` 전체 수: 과거 문서가 34→35로 변했으므로 `information_schema` 재측정 필요
- Discovery Bundle에 노출할 가격 정보의 정확 범위
- Korean FTS5 품질과 tokenizer 방식
- snapshot TTL·보존기간·감사로그 보존기간의 운영 승인
- MCP host 구현 언어 최종 선택. 현재 Python stdio를 권장
- Ed25519 서명키의 보관·회전 방식
- 임베딩 검색의 실제 필요성. 초기에는 미도입

## 미완성 산출물

README에 아래 링크가 있으나 파일은 아직 없다. 이는 의도적으로 중단된 상태다.

- `AI-READ-MODEL-CONTRACT.md`
- `SECURITY-AND-ACCEPTANCE-GATES.md`
- `manifest.example.json`

상세 레시피도 독립 review 전 초안이다. 완성·승인 문서로 표기하지 않는다.

## 검증 상태

- 라이브 DB 재접속·재추출: 수행하지 않음. 2026-09-01 기존 read-only snapshot을 사용함.
- 현재 전체 `information_schema`: 미재측정.
- 코드·테스트 변경: 없음.
- Markdown/Mermaid 독립 gate: 미수행.
- 보안 reviewer: `DONE_WITH_CONCERNS`, 운영 연결은 `CONDITIONAL NO-GO`.
- `.env.local`: `.gitignore`의 `.env.*` 규칙으로 ignored, 권한 `600` 확인.

## 건드리지 말 것

- `raw/webadmin` tracked 파일
- 라이브 DB 쓰기·DDL·COMMIT
- 현재 `SPEC-PRICEGRID-001` viewer output 계약
- `_workspace/product-worldmodel-viewer`의 기존 동작과 snapshot
- 사용자의 다른 dirty worktree 변경 366개
- 상품/가격/제약 권위를 vector나 LLM으로 대체하는 설계
- generic SQL·write·order·payment·production MCP tool

## 작업환경 주의

- 저장소 전체가 매우 dirty하다. 다른 변경을 stage, revert, format, cleanup하지 않는다.
- 현재 작업은 `_workspace/ai-ready-db-recipe/`만 소유한다.
- `raw/webadmin`은 읽기 권위로만 사용한다.
- gstack 자동 업그레이드는 원격 코드 실행·홈 설치본 교체 위험으로 승인 단계에서 거절됐다. 기존 gstack 설치본은 변경되지 않았다. 체크포인트 재개와 무관하므로 별도 사용자 승인 없이는 재시도하지 않는다.

## 현재 계획 상태

| 단계 | 상태 |
|---|---|
| 라이브 snapshot·schema·ontology·price·constraint 재검증 | 완료 |
| OSS 공식 문서·라이선스·복잡도 조사 | 완료 |
| 참조 아키텍처·semantic/security contract 설계 | 완료 |
| 상세 레시피·다이어그램 | 초안 작성, 지원문서 미완성 |
| 독립 fact/security/diagram gate | 미시작 |

## 현재 파일

- [README.md](./README.md)
- [AI-READY-LIVE-DB-RECIPE.md](./AI-READY-LIVE-DB-RECIPE.md)
- [HANDOFF.md](./HANDOFF.md)
