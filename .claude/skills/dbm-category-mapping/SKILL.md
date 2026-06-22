---
name: dbm-category-mapping
description: >
  후니프린팅 카테고리(t_cat_categories)↔실상품(t_prd_products) 매핑 설계 방법론(round-24 2단계).
  dbm-category-audit의 매칭 매트릭스·출시상태 3분류를 입력으로 MAP IA→cat_cd 노드 매핑(search-before-mint)
  + prd_cd→cat_cd 귀속(다중분류·별칭)을 FK 위상·채번 규칙대로 명세까지만. DB 미적재·실 적재 인간 승인.
  트리거: 카테고리 매핑, 카테고리 상품 매핑, 상품 카테고리 귀속, cat_cd 매핑, 다중분류 매핑, round-24 2단계, 매핑 설계, 카테고리 매핑 다시.
  MAP 검증·출시상태 분류(1단계)는 dbm-category-audit, CPQ 옵션은 dbm-cpq-option-mapping, 실 적재는 dbm-load-execution.
---

# dbm-category-mapping — 카테고리↔상품 매핑 설계 방법론 (round-24 2단계)

1단계(`dbm-category-audit`)에서 검증된 카테고리 분류와 상품 매칭·출시상태를 받아, **라이브
카테고리 노드(t_cat_categories)와 실상품(t_prd_products)의 실제 매핑 명세**를 설계한다.

## 1. 입력 (1단계 산출 재사용·재유도 금지)

- `35_category-map/02_matching-matrix.md` — MAP 엔트리 × 데이터시트 × 라이브 prd_cd.
- `35_category-map/03_release-status.md` — 출시상태 3분류(✅/🟡/❌).
- `35_category-map/04_unmatched-board.md` — 미매칭 양방향 보드.
- 라이브 `t_cat_categories` 현재 트리(read-only).

## 2. 두 레이어 매핑

**레이어 A — 카테고리 노드 매핑 (MAP IA → t_cat_categories)**
- MAP 1차 카테고리(11) + `▶︎`하위분류 → 라이브 `t_cat_categories` 노드에 대응.
- 기존 노드로 표현 가능하면 재사용(**search-before-mint**). 부족분만 신규 노드 제안.
- round-22 ⑥ 고아 노드 진단([[dbmap-axis-staged-load-round22]])과 정합 — 고아/중복 노드는 정리 라우팅(여기서 삭제 안 함).
- 다중분류: 한 상품이 여러 MAP 위치(`→`별칭)에 노출되면 다대다 귀속 허용.

**레이어 B — 상품 귀속 (prd_cd → cat_cd)**
- 각 실상품을 올바른 카테고리 노드에 귀속.
- **✅정상등록가능 우선** 매핑. 🟡옵션부족은 "매핑 가능하나 출시 전 옵션보완 필요"로 표기, ❌미출시는 보류(노드만 예약).
- 별칭(`→`)은 본체 prd_cd를 추가 카테고리에 연결(중복 상품 생성 금지).

## 3. 설계 규칙

1. **search-before-mint** — 신규 cat_cd 제안 전, 기존 노드/트리로 무손실 표현 불가임을 입증.
2. **FK 위상** — 카테고리 노드 선적재 → 상품 귀속(cat_cd FK) 후적재. 적재순서 명시.
3. **코드 채번** — `t_cat_categories` 컨벤션(MAX+1·separator `_`) 준수([[dbmap-code-identifier-strategy]]).
4. **출시상태 게이팅** — 매핑 명세에 상태별 적재 우선순위(✅ 즉시 / 🟡 옵션보완 후 / ❌ 보류) 부여.
5. **DB 미적재** — 매핑 명세 + 적재순서 + 영향분석(기존 귀속·FK·롤백)까지만. 실 COMMIT은 인간 승인.

## 4. 산출물 (`_workspace/huni-dbmap/35_category-map/`)

- `05_category-node-mapping.md` — MAP IA ↔ t_cat_categories 노드 매핑(재사용/신규/정리).
- `06_product-category-mapping.md` + `product-cat.csv` — prd_cd → cat_cd 귀속(다중분류·별칭·출시상태).
- `07_mapping-load-plan.md` — FK 위상 적재순서 + 상태별 우선순위 + 영향분석.

## 5. 검증 연계

설계 후 `dbm-validator`로 경계면 교차검증(카테고리 노드 실재·prd_cd 실재·FK 무모순·search-before-mint
준수·다중분류 무결성). 생성자≠검증자([[dbmap-correctness-audit-round13]]).

## 6. 적재본 SQL 안전 규칙 [HARD]

라이브 적재본을 만들 때 다음을 지킨다 — round-24 green2에서 apply SQL의 내장 `BEGIN;…COMMIT;`이
검증 단계 `psql \i` 포함 실행 중 **의도치 않은 라이브 COMMIT**을 일으킨 사고가 있었다:

- **DRY-RUN과 apply를 별도 파일로 분리.** DRY-RUN(`dryrun-*.sql`)은 `BEGIN…ROLLBACK`, apply(`apply-*.sql`)는
  실행자 전용. 검증자(dbm-validator)는 **dryrun 파일만** 실행하고 apply는 절대 `\i` 포함하지 않는다.
- **apply에 트랜잭션을 내장할 경우** 파일 첫 줄에 "실행자 전용·검증 단계 포함 실행 금지" 경고를 명시하거나,
  트랜잭션 래핑을 실행 커맨드 측(`psql -1 -f`)으로 옮겨 파일 자체엔 BEGIN/COMMIT을 넣지 않는다.
- **실 COMMIT 전 물리 백업 필수**(`CREATE TABLE bak_… AS SELECT …`) — SELECT형 백업은 undo 근거가 되지 못한다.
