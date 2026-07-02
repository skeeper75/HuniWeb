---
name: okb-ontology-authoring
description: 후니 온톨로지 지식베이스의 스키마 설계·노드 집필·그래프 빌드 컨벤션 방법론. 개체/관계 유형 사전 작성법, 노드 파일 frontmatter 스키마, 타입드 링크 문법, 출처+badge 강제, 파일 정본→그래프 결정론 빌드(멱등·무결성 검사), 수치 스크립트 전사, §9 위키 승계 표기, GAP/양면(현재값vs정답) 노드 패턴. '온톨로지 스키마 작성', 'KB 노드 집필', '노드 컨벤션', '그래프 빌드 규칙', 'frontmatter 스키마', '타입드 링크', '지식 노드 작성 다시' 작업 시 반드시 사용. 검증·게이트 방법론은 okb-adversarial-gate.
---

# okb-ontology-authoring — 스키마·노드·그래프 컨벤션

Huni-Ontology-KB의 architect·builder가 공유하는 집필 방법론. 확정 스키마 문서(`02_ontology/`)가 존재하면 그것이 이 스킬보다 우선한다(이 스킬은 스키마가 지켜야 할 메타 원칙).

## 1. 노드 파일 구조 (파일 = 정본)

```markdown
---
id: <유형prefix>-<slug>            # 전역 유일. 예: product-088-postcard-book
type: <개체 유형>                   # 스키마 사전에 있는 유형만
anchor: <t_* 테이블/코드>           # 라이브 앵커. 예: t_prd_products/PRD_000088. KB 전용 레이어면 none+사유
badge: verified|candidate|defect|unknown   # ✅🟡🔴⚪
sources:                           # 최소 1개. 셀/쿼리/절 단위로 구체적으로
  - "docs/huni/후니프린팅_상품마스터_260702.xlsx#<시트>!<셀범위> (via <CSV캐시 경로>)"
  - "live: SELECT ... (실행일 260703)"
  - "print-kb wiki recipes/booklet#가격사슬 (승계·재검증 260703)"
relations:                         # 타입드 링크. 스키마 사전의 관계 유형만
  - {rel: uses, target: material-<slug>}
  - {rel: priced-by, target: formula-<slug>}
updated: 2026-07-03
---
본문: 사람이 읽는 설명. 수치 표는 스크립트 전사 마커(<!-- transcribed-by: script.py -->) 필수.
```

## 2. HARD 원칙

- **그래프에만 있는 사실 금지** — 그래프는 `build_graph.py`가 노드 파일에서 추출한 파생물. 그래프를 고치고 싶으면 파일을 고치고 재빌드.
- **출처 없는 사실 금지·badge 없는 사실 금지.** 여러 출처가 충돌하면 권위 순서(260702 엑셀 > evaluate_price 코드 > SOT 문서 > 라이브 현재값 > 하네스 산출 > 역공학/외부)로 판정하되 충돌 자체를 기록.
- **수치는 스크립트 전사** — 단가·치수·수량구간은 CSV 캐시에서 스크립트로 삽입. LLM 손전사 금지(§32 [HARD]). 전사 스크립트는 `04_graph/` 또는 `_meta/scripts/`에 보존.
- **양면 노드** — 라이브 현재값 ≠ 권위 정답이면 둘 다 기록: `current_value`(라이브·날짜)와 `authority_value`(엑셀 셀), badge=defect. 어느 한쪽 삭제 금지.
- **GAP 노드** — 원천이 없어 답 못 하는 것은 지어내지 말고 type=gap 노드로 등록(무엇이 없는지·어디서 채울 수 있는지). GAP도 지식이다.
- **search-before-mint** — 새 유형/관계 추가 전에 스키마 사전·§9 어휘(uses/requires/excludes/priced-by/loaded-via/mapped-to) 재사용 검토. 추가하면 스키마 문서에 등재 후 사용(문서에 없는 유형 사용 금지 — lint가 잡는다).

## 3. 그래프 빌드 규칙

- 입력=`03_kb/**/*.md` 전체 → frontmatter 파싱 → 노드/엣지 추출 → 저장(스키마의 graph-build-spec 형식) → 무결성 리포트.
- 무결성 검사(빌드마다·위반=빌드 FAIL): ① relations의 target id 실재(끊긴 링크 0) ② type/rel이 스키마 사전에 존재 ③ 필수 frontmatter 필드 존재 ④ id 유일 ⑤ 멱등(재실행 동일 해시).
- 빌드 산출·리포트는 `04_graph/`에. 그래프 저장 형식은 methodology-playbook 권고 채택분을 따른다.

## 4. §9 위키 승계 표기

- INHERIT: source에 `(승계)` 라벨. REVERIFY 통과: `(승계·재검증 <날짜>)` + 대조 출처 추가. DROP 분 인용은 lint 위반.

## 5. index.md (진입점)

`03_kb/index.md`는 LLM이 질의 시 가장 먼저 읽는 파일 — 유형별 노드 목록 + 한 줄 훅 + NL 질의 시작점(의도→상품군 진입 노드). 노드 추가/삭제 시 반드시 갱신(끊긴 index = O4 FAIL).
