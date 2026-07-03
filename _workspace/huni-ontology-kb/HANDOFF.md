# HANDOFF — Huni-Ontology-KB (§33) · 2026-07-03

## 다음 시작점

**디지털인쇄 36 + 스티커 16 = 52상품 완성(GO)** — 다음 상품군은 **실사(28상품)**. `huni-ontology-kb-orchestrator`로 "실사 상품군 KB 확장".
루프는 `_meta/expansion-plan.md` §1~§4 그대로(팩→구축[자기 파일만·공유축은 반환]→3축 적대검증[결정론 우선]→질의 게이트). 순서=실사→셋트 계열→문구/굿즈.
★스티커 교훈(다음 상품군 착수 전 반영): ① 슬러그/노드ID 명명 정본 미확정 → 빌더마다 product-NNN vs 의미명 분열(D-STK-2 Medium·그래프는 16/16 해결이나 index 라우팅 갭). 팩 단계에서 slug를 product-NNN-kebab로 못박아 넘길 것. ② 스티커 가격 아키타입 3분기(단가형 unit×qty / 합가형 band / 팩 4000×팩수)를 prc_typ로 정확 기록해야 traversal 오차 0.

## 미해결 / 블로커 (전부 비차단)

- 판수 GAP(마스터 15 vs 판걸이수 18, 73×98) — 실무진 확인 대기 · `GAP_pansu_73x98` 노드로 정직 표기
- 016 자재 대표 subset vs 전수 민팅 정책 — architect 상신(`GAP_016_material`)
- 확장 advisory 4건(비차단·게이트 GO): meta orphan GAP 2·log 미기록·use_yn 포맷 편차·042 굿즈 원천컨펌(라이브 오적재 KB가 이미 defect+GAP 표기)
- PROC_000085(상품 미바인딩 공정) 축 노드 지위 — architect 판단
- 봉투/케이스 세트 모델(Q-ID-A)·박색 옵션풀(C-06) — 타 하네스 공통 미결 큐

## 이번 세션 결정 (relitigate 금지)

1. **하네스 §33 신규 구축** — 에이전트 6인(okb-*) + 스킬 3종 + dynamic workflow 실행 모드
2. **§9 위키 승계+재사용**(재병합 금지) · **파일=정본, 그래프=결정론 빌드 파생물**(md→jsonl→SQLite 3층·Kuzu 기각) · **파일럿=디지털인쇄** · **KB 범위=상품+가격만**(주문/배송/회원/쿠폰=거절)
3. 스키마 v1.0.1 **사용자 승인 완료** — 개체 17종·관계 19종·출처 5필드·badge 4종·양면/GAP 노드·가격은 연결까지(값=evaluate_price 권위)
4. 종단 파일럿 **GO** — Phase 1(리서치 5렌즈+큐레이션)→2(스키마+적대 리뷰 9결함 교정)→3(대표 8상품·노드 204·엣지 430)→4(적대 검증 3라운드·14결함 전건 CLOSED)→5(블라인드 31시나리오·가격 오차 0·환각 0·O1~O7 GO)
5. 워크플로 운영 교훈[HARD급]: 서브에이전트 구조화 반환은 초소형(경로+숫자+한 문장)만 — 대형 반환은 필수 필드 누락으로 5회 재시도 실패 재발(3회 실증)

## 건드리지 말 것

- `03_kb/` 정본 노드 204개 + `04_graph/build_graph.py`(하드 위반 0·멱등 확증) — 수정은 반드시 정본 파일 경유 후 재빌드
- `02_ontology/` 스키마 v1.0.1(승인본) — 변경 시 이력 절+마이그레이션 노트 필수
- `00_research/methodology-playbook.md`(7대 원칙·D-1~D-22) · `01_curation/source-registry.md`(STALE 금지 10건·260702 접근 규칙)
- 검증 판정 문서(`05_verification/`·`06_query_gate/gate-verdict-260703.md`) — 재게이트 시 append, 덮어쓰기 금지
