# Huni AI-ready DB Recipe

라이브 PostgreSQL과 권위 Excel을 AI가 안전하게 탐색할 수 있도록 준비하는 **오픈소스 중심 사전작업 설계**입니다. 새 중앙 서비스를 만들거나 라이브 DB를 AI에 직접 연결하지 않고, 현재 권위를 시점 고정한 불변 읽기 번들로 투영하는 방식을 권장합니다.

## 문서

- [상세 레시피](./AI-READY-LIVE-DB-RECIPE.md)
- [AI Read Model 계약](./AI-READ-MODEL-CONTRACT.md)
- [보안·검증 게이트](./SECURITY-AND-ACCEPTANCE-GATES.md)
- [예시 bundle manifest](./manifest.example.json)

## 이번 산출물의 경계

- 설계·분석·오픈소스 선정 문서만 작성했습니다.
- 라이브 DB, `raw/webadmin`, 현재 상품뷰어 구현은 수정하지 않았습니다.
- 현재 라이브 기준값은 2026-09-01에 생성된 기존 `REPEATABLE READ, READ ONLY` snapshot을 관측 근거로 사용했습니다.
- 전체 라이브 `t_*` 수는 과거 문서의 34/35 표기가 서로 달라, 구현 착수 시 `information_schema` 재측정을 필수 게이트로 남겼습니다.

## 한 문장 권고

> **PostgreSQL·Excel·현재 코드는 권위로 유지하고, AI에는 서명된 불변 snapshot bundle만 노출하며, DuckDB/SQLite와 로컬 stdio MCP를 얇은 읽기 계층으로 둔다.**
