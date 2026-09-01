---
status: design-package-complete
branch: main
timestamp: 2026-09-01T20:18:08+09:00
scope: open-source AI-ready live DB design package
operating_connection: CONDITIONAL_NO_GO
---

# AI-ready Live DB Recipe — 재개 포인터

> 현재 상태: `DESIGN_PACKAGE_COMPLETE / OPERATING_CONDITIONAL_NO_GO`
>
> 라이브 DB·`raw/webadmin`·기존 `SPEC-PRICEGRID-001`: 무수정

## 다음 시작점

1. [README](./README.md)와 아래 4개 산출물을 읽는다.
2. 구현 승인을 별도로 받기 전에는 `_workspace/ai-access/`를 만들거나 라이브 DB/MCP를 연결하지 않는다.
3. 구현이 승인되면 첫 작업은 R0 현재 `information_schema` 재측정과 column classification이다.
4. R1 이후에도 세 운영 차단점의 실행 evidence가 없으면 `current`를 운영 AI에 연결하지 않는다.

재개용 한 줄:

```text
_workspace/ai-ready-db-recipe/HANDOFF.md와 README.md부터 읽고, 구현 승인 여부부터 확인해줘. 설계 패키지는 완료됐지만 운영 연결은 CONDITIONAL NO-GO이며 raw/webadmin·라이브 DB·기존 viewer는 수정하지 마.
```

## 현재 산출물

- [상세 레시피](./AI-READY-LIVE-DB-RECIPE.md)
- [AI Read Model 계약](./AI-READ-MODEL-CONTRACT.md)
- [보안·수용 게이트](./SECURITY-AND-ACCEPTANCE-GATES.md)
- [예시 manifest](./manifest.example.json)
- [README](./README.md)

## 이번 작업에서 완료한 것

- 기존 18-table read-only viewer seed와 현재 코드·ontology·Excel hash를 다시 대조했다.
- 서비스 중심이 아닌 `authority → signed immutable artifact → embedded query → local stdio MCP` 구조를 설계했다.
- Discovery와 Internal Diagnostic projection을 분리했다.
- 가격의 단가, 사용자 정의 합가(`PRE_SUMMED_AS_IS+USE_AS_IS`), 구간총액 환산, 고정금액형, 수기값 의미를 분리한 `price_row` 계약을 작성했다.
- `comp_price_id`와 전체 자연키(`comp_cd`·적용일·고정 차원·canonical `dim_vals`) ID 규칙을 고정했다.
- 현재 제약 endpoint가 missing/error 규칙을 skip하는 한계를 사실로 기록하고, R4 `validate_spec`을 fail-closed completeness adapter 목표 계약으로 분리했다.
- RFC 8785 manifest bytes의 Ed25519 detached signature, signed monotonic promotion record, bundle 영역 밖 OS-protected WORM trusted head를 분리했다.
- local stdio launch identity와 미래 HTTP token profile을 분리했다.
- `SELECT *` 검증을 grep-only가 아니라 SQL AST·projection·`information_schema`·Parquet schema 집합 비교와 민감 canary 시험으로 강화했다.
- JSON·Markdown·링크·snapshot 수치·secret pattern을 검증했다.

## 이번 작업의 결정

1. 라이브 PostgreSQL, Excel, 현재 코드는 질문 종류별 권위를 계속 가진다.
2. AI는 라이브 DB credential이나 임의 SQL을 받지 않는다.
3. 기존 viewer `SPEC-PRICEGRID-001`은 유지하고 같은 extract에서 `AI-READ-MODEL-001`을 형제 산출물로 만든다.
4. MVP는 Parquet + DuckDB in-process + SQLite FTS5 + local stdio MCP다.
5. vector/graph server는 필수가 아니며, 검색 품질 필요성이 측정된 뒤에만 추가한다.
6. Discovery는 가격 구조·유형·적용 차원만 반환한다. 내부 원천 가격행의 금액 tool 노출은 별도 승인이다.
7. `quote_spec`은 고객용 현재 strict 견적 결과를 반환하며 내부 가격행 원문을 자동 공개하지 않는다.
8. current constraint endpoint의 binary `ok=true`는 completeness 증거 없이 `PASS`가 아니다.
9. valid old bundle prefix replay를 막기 위해 publish와 rollback 모두 signed promotion generation을 증가시키고, 분리 WORM trusted head의 generation/digest와 대조한다.

## 운영 연결 전 차단점

현재 판정은 `CONDITIONAL NO-GO`다.

1. 기존 exporter의 `SELECT *` 제거·명시적 table/column projection과 sibling-projection 회귀(`SPEC-PRICEGRID-001` bytes/hash 불변)가 구현·검증되지 않았다.
2. 전용 DB role의 physical SELECT-only 권한이 독립적으로 증명되지 않았다.
3. private ACL, manifest/promotion signature, 분리 WORM trusted head, freshness gate가 구현·실행되지 않았다.

R4 추가 차단점:

- 현재 제약 endpoint는 missing variable·평가 예외 규칙을 skip하고 rule ID·`evaluatedAt`을 반환하지 않는다. 대상/실행/skip/missing/error 계측과 parity gate 전에는 `validate_spec`을 열 수 없다.

## 인간 결정 대기

- Discovery에 공개할 고객 가격 값의 정확 범위
- Internal Diagnostic 원천 금액 tool이 실제로 필요한지와 승인 role/purpose
- snapshot TTL·bundle/audit 보존기간
- signing key custody·rotation·revocation 정책
- local launcher가 per-user role/scope를 증명할 수 있는지
- Korean FTS5 tokenizer 품질과 vector rerank 필요성

## 검증 상태

- 기존 seed 관측: `dbAsOf=2026-09-01 01:06:18.71677Z`, `repeatable read`, `readOnly=true`
- 18 tables, 상품행 309, 활성 상품 269, 구성요소 가격행 25,090, 공식 121, 구성요소 219, 제약 101
- graph occurrence/unique: node 3,493/1,814, edge 3,289/3,009
- 상품·가격 workbook 260822_1 SHA-256: `VERIFIED`
- manifest JSON과 문서 내 JSON 예시: parse PASS
- Markdown fence·local link·`git diff --check`: PASS
- viewer 독립 unit test: 9/9 PASS
- Mermaid 11개: 정적 의미 검토 PASS, 실제 parser/render는 `mmdc` 미설치로 `NOT_RUN`
- 독립 fact/code review: `APPROVE`
- 독립 security gate: `APPROVE`
- 독립 document/diagram static QA: `PASS`
- 최종 통합 terminal gate: `APPROVE`
- 현재 전체 라이브 `information_schema`: 미재측정
- 운영 보안 gate·adversarial evidence: 설계만 완료, 실행 `NOT_RUN`

## 건드리지 말 것

- `raw/webadmin` tracked 파일
- 라이브 DB write·DDL·COMMIT
- `_workspace/product-worldmodel-viewer` 기존 코드·snapshot·`SPEC-PRICEGRID-001`
- 저장소의 다른 dirty 변경
- generic SQL·filesystem·URL·write·order·payment·production MCP tool
- vector/LLM으로 가격·제약·주문 권위를 대체하는 설계
- 승인 없는 gstack upgrade
