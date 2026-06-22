# HuniWeb — 모듈(하네스) 상세 카탈로그

> 개요: [overview.md](overview.md) | 의존성: [dependencies.md](dependencies.md) | 진입점: [entry-points.md](entry-points.md) | 데이터 흐름: [data-flow.md](data-flow.md)

---

## 1. Print-Quote — 기획·설계 하네스

**목표:** buysangsang.com·wowpress·RedPrinting 경쟁사 분석 + huni 실데이터 분석을 통합하여, 자동인쇄 견적 사이트의 기획·설계 문서 일체(IA·DB·API·가격엔진·화면설계·통합 설계서)를 산출한다. 설계 전용 하네스 — 구현 코드 없음.

**오케스트레이터 스킬:** `.claude/skills/print-quote-orchestrator/SKILL.md`

**에이전트 로스터**

| 에이전트 | 역할 |
|---------|------|
| `pq-pm` | 마일스톤·RACI·태스크 그래프 수립 + Phase 4 통합 설계서 |
| `pq-researcher` | 경쟁사 라이브 크롤·문서 분석 (buysangsang 7축 역공학) |
| `pq-business-analyst` | huni 실데이터·정책 분석 (xlsx·pdf 5종) |
| `pq-architect` | IA·ERD·API 명세·가격엔진·기술 스택 설계 |
| `pq-designer` | 사이트맵·화면설계·UX 플로우·인터랙션 명세 |

**스킬 로스터**

| 스킬 | 유형 |
|------|------|
| `print-quote-orchestrator` | 오케스트레이터 |
| `print-quote-live-crawl` | 메서드 (buysangsang 라이브 크롤, WP+Woo+Elementor 특화) |

**워크스페이스 산출 구조**

```
_workspace/print-quote/
  00_pm/          milestones, raci, task-graph, status, decisions
  01_research/    competitor-*.md, patterns.md, crawl-evidence/
  02_business/    product-master, pricing-rules, requirements-ears
  03_architecture/ ia, erd, schema.sql, api-spec, pricing-engine, adr/
  04_design/      sitemap, ux-flow, screen-spec, wireframes/, DESIGN.md
  99_integrated/  design-spec, executive-summary, handoff-to-build
  _baseline/      이전 DB 스키마 7종 (read-only 참조)
  CHANGELOG.md
```

**상태:** 설계 완료. To-Be = edicus.man(Next.js 15+Edicus SDK+Huni DS v6.0) 기반.

---

## 2. Huni-Widget — 구현 하네스

**목표:** RedPrinting 위젯 역공학 보강 → 동작 구조 분석 + 리서치 → 위젯 상세 명세 → **React-in-Shadow-DOM 임베드 위젯** 구현 → 경계면 교차 QA → 후니 시각재현 정합. Print-Quote와 별개의 독립 구현 하네스.

**오케스트레이터 스킬:** `.claude/skills/huni-widget-orchestrator/SKILL.md`

**에이전트 로스터**

| 에이전트 | 역할 |
|---------|------|
| `hw-reverse-engineer` | Red 역공학 보강 (미검증 3대 보강: S3 presigned·가격 rule·postMessage) |
| `hw-runtime-analyst` | 라이브 동작 관찰, 시퀀스 다이어그램, 캐스케이드 규칙 |
| `hw-researcher` | 국내외 베스트프랙티스 리서치 (Shadow DOM·embed·가격 UX) |
| `hw-architect` | 위젯 명세 (componentType 매핑·정규화 계약·어댑터 전략) |
| `hw-builder` | React 위젯 구현 (메인 트리 실행, worktree 미사용) |
| `hw-design-fidelity` | 후니 스킨 시각재현 정합 (외형만, 캐스케이드 무변경) |
| `hw-qa` | 경계면 교차 QA + 독립 재검증 (생성자≠검증자 불변) |

**스킬 로스터**

| 스킬 | 유형 |
|------|------|
| `huni-widget-orchestrator` | 오케스트레이터 |
| `huni-widget-spec` | 메서드 (위젯 명세 작성) |
| `huni-widget-build` | 메서드 (React 구현) |
| `huni-widget-live-capture` | 메서드 (Red 라이브 캡처, fixture 생성) |
| `huni-widget-qa` | 메서드 (경계면 QA) |
| `huni-widget-design-fidelity` | 메서드 (시각재현 정합) |

**워크스페이스 산출 구조**

```
_workspace/huni-widget/
  01_reverse/       역공학 보강 명세 (widget-runtime-spec, price-engine-reversed 등)
  02_analysis/      동작 구조 (sequence-diagrams, cascade-rules, event-contract)
  02_research/      베스트프랙티스 (bp-embed-widget, bp-react-shadow-dom 등)
  03_spec/          구현 명세 (architecture, component-tree, state-management 등)
  04_build/         ★ 유일한 1차 구현 코드
    src/widget/       Shadow DOM 위젯 코어
    src/adapters/red/ Red 어댑터 (후니 어댑터 교체 예정)
    src/bff/          BFF (가격 API 프록시)
    src/contract/     정규화 계약 (data-contract)
    src/widget-loader/ 임베드 로더
    test/             vitest 150개
    dist/             빌드 산출물
    fixtures/         캡처 기반 fixture
  05_qa/            QA 리포트, captures/
  06_fidelity/      시각재현 정합 리포트
  07_parity/        코드 레벨 구조 정합 산출 (S0~S3)
  HANDOFF.md
  CHANGELOG.md
  README.md
```

**핵심 불변식:**
- 위젯 코어 0변경 원칙: 상품 확대 시 `git diff src/widget/ src/contract/ = 0줄` (INV-3)
- 정규화 계약 의존: 위젯은 후니 DB가 아닌 계약에 의존 → 어댑터 교체로 무손실 컨버전

**상태:** S1~S6 확대 완료. vitest 150개 통과. 후니 DB 어댑터 교체 대기.

---

## 3. Huni-DBMap — DB 데이터 매핑 하네스

**목표:** Railway `railway` DB(PostgreSQL 18.4, t_* 34테이블) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 라이브 `t_*` 스키마에 매핑(매핑 설계서 + 적재용 CSV). DB 직접 파괴적 조작은 반드시 인간 승인.

**오케스트레이터 스킬:** `.claude/skills/huni-dbmap-orchestrator/SKILL.md`

**에이전트 로스터**

| 에이전트 | 역할 |
|---------|------|
| `dbm-schema-analyst` | DB 구조 → 시트 (읽기전용 psql) |
| `dbm-excel-analyst` | 엑셀 파싱 + 정규화 (L1 충실추출) |
| `dbm-mapping-designer` | 매핑 명세 + 적재 CSV |
| `dbm-validator` | 경계면 교차검증 + 게이트 (생성자≠검증자) |
| `dbm-load-builder` | round-4/5: 적재본 조립 + 멱등 SQL/로더 |
| `dbm-domain-researcher` | round-11/12: 컬럼 도메인 의미 + 상품 BOM + 매핑 확정 |
| `dbm-loadspec-extractor` | round-11: webadmin 적재명세 추출 (소스 읽기 전용) |
| `dbm-ddl-proposer` | round-5/6: GAP/BLOCKED → 최소 신규 엔티티 DDL 제안 |
| `dbm-option-mapper` | round-6: CPQ 옵션 레이어 매핑 설계 |
| `dbm-coverage-auditor` | round-7: 입체 커버리지 매트릭스 (상품군×t_* 엔티티) |
| `dbm-change-tracker` | round-10(버전 diff)/round-14(스키마 변경 추적) |
| `dbm-correctness-auditor` | round-13: 라이브 정합 교정 (라이브=교정대상 역전) |

**스킬 로스터**

| 스킬 | 유형 |
|------|------|
| `huni-dbmap-orchestrator` | 오케스트레이터 |
| `dbm-schema-extract` | 메서드 (DB 구조 추출) |
| `dbm-excel-parse` | 메서드 (엑셀 L1 충실추출) |
| `dbm-mapping` | 메서드 (매핑 설계, round-1) |
| `dbm-price-formula` | 메서드 (가격 공식 엔진, round-2) |
| `dbm-mapping-audit` | 메서드 (매핑 정합 검증, round-3) |
| `dbm-load-readiness` | 메서드 (적재 준비 게이트 G1~G9, round-4) |
| `dbm-load-execution` | 메서드 (멱등 실행본 R1~R6, round-5) |
| `dbm-column-domain` | 메서드 (컬럼 도메인 의미, round-11) |
| `dbm-loadspec-extract` | 메서드 (webadmin 적재명세, round-11) |
| `dbm-cpq-option-mapping` | 메서드 (CPQ 옵션 레이어, round-6) |
| `dbm-coverage-matrix` | 메서드 (입체 커버리지, round-7) |
| `dbm-correctness-audit` | 메서드 (라이브 정합 교정, round-13) |
| `dbm-change-tracking` | 메서드 (버전 변경 추적, round-10) |
| `dbm-mapping-research` | 메서드 (매핑 확정 리서치, round-12) |
| `dbm-schema-change-tracking` | 메서드 (webadmin 스키마 변경 추적, round-14) |

**워크스페이스 산출 구조**

```
_workspace/huni-dbmap/
  00_schema/      DB 구조 시트, CPQ 스키마, schema-design-intent-map
  01_excel/       엑셀 L1 추출 (product-info-foundation, price-info)
  02_mapping/     매핑 명세, 가격 fit-gap
  03_validation/  검증 리포트 (G1~G9, R1~R6, V1~V8, M1~M6, K1~K6, W1~W6)
  04_audit/       속성별 정합 parity
  05_method/      방법론 (A~G)
  06_extract/     L1 충실추출 CSV
  07_domain/      도메인 KB (의미축 L2)
  09_load/        적재본 (_assembled/, _exec/, _exec_price/)
  10_configurator/ CPQ 컨피규레이터 설계
  11_ddl_proposals/ 신규 엔티티 DDL 제안
  12_coverage/    커버리지 (209셀 매트릭스)
  13_admin-ui-spec/ admin UI 입력 명세 (34 t_* 엔티티 332컬럼)
  14_change-tracking/ 버전 diff 산출
  15_domain-spec/ 도메인 명세
  16_mapping-research/ 시트별 매핑 확정 (11 family)
  17_correctness/ 라이브 정합 교정 (11 family)
  18_schema-change/ webadmin 스키마 변경 추적
  HANDOFF.md
  CHANGELOG.md
```

**상태:** round-14 완료. 실제 COMMIT/CPQ L2 적재/오적재 교정은 인간 승인 대기. 가장 큰 하네스.

---

## 4. Huni-Admin-Manual — 운영자 매뉴얼 하네스

**목표:** 라이브 후니 Django admin(`huni-admin-production.up.railway.app/admin/`)을 소스·라이브 DB·실제 화면 3중 대조로 전수 분석하여, 비개발자 운영자가 상품·가격·옵션을 등록/수정하기 위한 상세 사용 매뉴얼(전 화면 전수 + 실제 스크린샷 임베드 + step-by-step)을 산출한다.

**오케스트레이터 스킬:** `.claude/skills/huni-admin-manual-orchestrator/SKILL.md`

**에이전트 로스터**

| 에이전트 | 역할 |
|---------|------|
| `ham-source-analyst` | Django admin 소스 전수 → 화면 맵 (뿌리 산출) |
| `ham-db-verifier` | 라이브 DB 코드값·제약 실측 (읽기전용 SELECT) |
| `ham-live-capturer` | 라이브 화면 gstack 캡처 |
| `ham-manual-writer` | 운영자 매뉴얼 집필 (스크린샷 임베드) |
| `ham-manual-qa` | 전수 커버리지·정합 검증 (게이트 26/26) |
| `ham-docs-publisher` | MkDocs Material 문서 사이트 발행 (docs-as-code) |

**스킬 로스터**

| 스킬 | 유형 |
|------|------|
| `huni-admin-manual-orchestrator` | 오케스트레이터 |
| `huni-admin-source-map` | 메서드 (Django 소스 분석) |
| `huni-admin-live-capture` | 메서드 (gstack 라이브 캡처) |
| `huni-admin-manual-authoring` | 메서드 (매뉴얼 집필) |
| `huni-admin-docs-publish` | 메서드 (MkDocs 발행) |

**워크스페이스 산출 구조**

```
_workspace/huni-admin-manual/
  01_source_admin-screen-map.md   화면 맵 (뿌리)
  02_db_value-domains.md          DB 코드값 도메인
  03_capture_screen-index.md      캡처 인덱스
  captures/                       실제 스크린샷 PNG (~41개)
  04_qa_manual-gate.md            QA 게이트 (GO/NO-GO)
  05_reverify_*/                  라이브 재대조 보고
  manual/                         매뉴얼 11챕터
  site-src/                       MkDocs Material 사이트
    mkdocs.yml
    build_docs.py
    requirements-docs.txt
    docs/ (빌드 생성물, gitignore)
    site/ (빌드 생성물, gitignore)
  scripts/
```

**대상 구조 이중 레이어:**
- 표준 Django admin (Unfold 테마) — `catalog/admin.py` 제너릭 ModelAdmin
- 커스텀 상품 뷰어 — `admin/` 홈·옵션 드릴다운·SKU 템플릿·제약 폼빌더

**상태:** 매뉴얼 11챕터 완료. MkDocs 빌드 통과(11페이지·41이미지). GitHub Pages 호스팅 연결은 인간 승인 대기.

---

## 5. Print-KB-Wiki — LLM 레시피 위키 하네스

**목표:** 전 하네스 산출물을 원천으로, `_workspace/print-kb/wiki/`에 **상품군(11시트) 단위 레시피 페이지**와 횡단 축 페이지 6종을 집필한다. 목적: 미래 LLM 세션이 위키만 읽고 인쇄상품을 빠르게 조립(정의→DB 등록→가격→위젯).

**오케스트레이터 스킬:** `.claude/skills/print-kb-wiki-orchestrator/SKILL.md`

**에이전트 로스터**

| 에이전트 | 역할 |
|---------|------|
| `pkw-source-curator` | 전 원천 인벤토리 + tier/freshness 등급 + 11 family/6 axis 큐레이션 팩 |
| `pkw-researcher` | Karpathy 모델·온톨로지·llms.txt·RAG 문서설계 방법론 + 검증 리서치 |
| `pkw-recipe-writer` | 레시피 페이지 집필 (정체→차원→BOM→가격공식→CPQ→위젯 계약→적재 경로→결함) |
| `pkw-wiki-qa` | W1~W8 엄밀 게이트 (생성자≠검증자) |

**스킬 로스터**

| 스킬 | 유형 |
|------|------|
| `print-kb-wiki-orchestrator` | 오케스트레이터 |
| `pkw-recipe-authoring` | 메서드 (레시피 집필 기준) |
| `pkw-wiki-evaluation` | 메서드 (W1~W8 게이트) |

**워크스페이스 산출 구조**

```
_workspace/print-kb/
  wiki/
    index.md              위키 홈
    recipes/              상품군 11 family 레시피 페이지
    base/                 기반 축 페이지 (스키마·용어·도메인)
    huni/                 후니 특화 횡단 페이지
    sources/              원천 등록부
    policy/               정책 페이지
    _research/            방법론 리서치 산출
    _curation/            큐레이션 팩 (tier/freshness 등급)
    _qa/                  W-gate 판정서
    log.md                마일스톤 기록
  source-registry.md      원천 레지스트리
  cq-registry.md          CQ 레지스트리
  domain-context-model.md 도메인 컨텍스트 모델
```

**핵심 규칙:**
- STALE/v03 인용 금지 (freshness 권위 = round-14 진단)
- 라이브 오적재(round-13)는 "현재값 vs 정답" 양면 표기
- 생성자≠검증자 (writer→qa 분리)
- 모든 블록 출처+badge 필수

**상태:** 전체 11 family 레시피 배치3 완료. round-14 스키마 변경 반영 갱신 필요.

---

## MoAI 프레임워크 코어 (gated)

**주의:** 이 리포지토리에서는 거의 사용하지 않는다. 세부 규칙은 `globs:` frontmatter로 게이팅되어 특정 경로에서만 자동 로드된다.

**구성:** 22 에이전트 + ~50 moai-* 스킬

**에이전트 그룹:**
- 매니저 (8): `manager-spec`, `manager-strategy`, `manager-ddd`, `manager-tdd`, `manager-docs`, `manager-quality`, `manager-project`, `manager-git`
- 전문가 (8): `expert-backend`, `expert-frontend`, `expert-security`, `expert-devops`, `expert-performance`, `expert-debug`, `expert-testing`, `expert-refactoring`
- 빌더 (3): `builder-agent`, `builder-skill`, `builder-plugin`
- QA/평가 (3): `evaluator-active`, `plan-auditor`, `researcher`

**스킬:** 7 오케스트레이터 + ~43 메서드 스킬 (`user-invocable: false` — 배경 지식으로 자동 로드). 사용자가 직접 구동하려면 `moai` 스킬로 진입 (`/moai plan|run|sync|...`).

**gated 규칙 파일 위치:**
- `.claude/rules/moai/core/moai-constitution.md`
- `.claude/rules/moai/core/agent-common-protocol.md`
- `.claude/rules/moai/design/constitution.md`
- `.claude/rules/moai/workflow/*`

**원본 전문:** `.moai/_archive/CLAUDE-full-moai-2026-06-05.md`
