---
paths:
  - "_workspace/huni-multibrand-ontology/**"
---

# §35 Harness: Huni-Multibrand-Ontology — 다중 브랜드 인쇄 온톨로지

경쟁사(와우프레스·레드) 상품을 정밀 분석해 후니(§33 KB)와 **교차 연관**짓고, 국제 인쇄표준
(CIP4/XJDF·schema.org·구성 온톨로지) 기반 **브랜드-중립 상위 온톨로지**를 설계한다. 목표=자연어
질의→상품 추천→가격→주문 형태 확장. 스킬=`huni-multibrand-ontology-orchestrator`
(트리거: 다중 브랜드 온톨로지·와우프레스 분석·상위 온톨로지·CIP4 표준·교차 브랜드 매핑).
산출=`_workspace/huni-multibrand-ontology/`.

## 핵심 규칙 [HARD]

- **아키텍처 커밋 지연**: "§33 확장(다중브랜드 진화) vs 독립 §35 KB 후 연합"은 분석·표준 산출 뒤
  게이트(MB7)+인간 승인으로 결정. 산출물은 어느 쪽이든 재사용 가능(architecture-neutral)하게 작성.
- **와우 앵커 네임스페이스**(§33 후니 t_* 앵커 [HARD]와 병행): 와우는 DB 없음 → `wowpress-api:<endpoint>#<field>`
  · `catalog:products/<id>.json#<jsonpath>` · `wowpress-pdf:<file>#p<page>` 3유형. **지어내기 차단 유지**
  (모든 노드는 실 앵커 or GAP). LLM 손전사 금지 — 수치는 스크립트 전사(catalog JSON 파싱).
- **가격 경계 동형(§33 D-18)**: 온톨로지는 가격 축·구성요소 연결까지만. 가격 값 권위 = **와우 제품가격조회
  API**(후니 evaluate_price 경계 동형). KB는 값 계산 안 함.
- **브랜드축 + 교차관계**: product/formula/component 노드에 `brand`(huni/wowpress/red). 교차관계
  `same_family_as`·`price_model_differs`·`component_differs` 신설. 상위 온톨로지 노드에 `instance_of`/`mapped_to`.
- **§33 재사용·무손상**: 후니 데이터는 `_workspace/huni-ontology-kb/03_kb/`를 원천 재사용(재조사 금지).
  §33 골든 자산(스키마 v1.0.1·build_graph.py·03_kb 정본)은 아키텍처 결정 전까지 수정 금지.
- **catalog 노후 경계**: `docs/wowpress/catalog/`는 2025-10-14 수집 → 의심분만 devshop.wowpress.co.kr
  라이브(gstack 읽기전용) 재확인. **생성≠검증**·search-before-mint(§33 스키마·표준 이름표 재사용 우선).
- **codex 폴백**(전 하네스 공통 프로토콜 ⑤): 필요 시 verify-gate가 codex 독립 교차, 미가용 시 "Claude 단독" 명시.

변경이력: 최신은 `_workspace/huni-multibrand-ontology/_meta/CHANGELOG.md`(이 파일은 최신 1줄 포인터만). 최신(2026-07-04): Phase 1~5 완주(MB 게이트 GO)·아키텍처=독립 후 통합 확정·북극성 재정의(원자 의미→추천→가격→인쇄소 라우팅)·구조 리서치(후니 방식 정통 검증·과공학 기각)·라우팅 층 E22~E25 설계·검증(GO 7/7·전 노드 GAP).

> 전문 원천: `docs/wowpress/`(OPEN API 문서·products_spec·price_order_spec PDF·catalog JSON 326상품).
> 후니 온톨로지 스키마 승계 원천: `_workspace/huni-ontology-kb/02_ontology/ontology-schema.md`(개체17·관계19·출처5필드·badge4).
