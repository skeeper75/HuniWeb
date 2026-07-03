# HANDOFF — Huni-Ontology-KB (§33) · 2026-07-03

## 다음 시작점

**디지털36+스티커16+실사28 = 80상품 완성(GO)** — 다음 상품군은 **셋트 계열(책자/포토북/캘린더·§23 연계)** 또는 **문구/굿즈파우치/악세사리**. `huni-ontology-kb-orchestrator`로 "<상품군> KB 확장".
루프는 `_meta/expansion-plan.md` §1~§4 그대로(팩[slug=product-NNN-kebab 강제]→구축[자기 파일만·공유축은 반환]→3축 적대검증[결정론 우선]→질의 게이트).
★확장 교훈(반영됨): ① slug 정본=product-NNN-kebab(실사에서 팩이 강제→dead-link 0·명명분열 0, 스티커 D-STK-2 재발 안 함). ② 가격 아키타입을 prc_typ로 정확 기록(디지털=원자합산 / 스티커=고정룩업+band+팩 / 실사=면적매트릭스 [가로×세로]·off-grid ceiling·가로세로 스왑 비대칭 주의). ③ 셋트 계열은 §23 산출(member_of·evaluate_set_price) 재사용·라이브 미결(088 적재 승인 대기 등)과 얽힘 주의.

## 미해결 / 블로커 (전부 비차단)

- 판수 GAP(마스터 15 vs 판걸이수 18, 73×98) — 실무진 확인 대기 · `GAP_pansu_73x98` 노드로 정직 표기
- 016 자재 대표 subset vs 전수 민팅 정책 — architect 상신(`GAP_016_material`)
- 확장 advisory 4건(비차단·게이트 GO): meta orphan GAP 2·log 미기록·use_yn 포맷 편차·042 굿즈 원천컨펌(라이브 오적재 KB가 이미 defect+GAP 표기)
- PROC_000085(상품 미바인딩 공정) 축 노드 지위 — architect 판단
- 봉투/케이스 세트 모델(Q-ID-A)·박색 옵션풀(C-06) — 타 하네스 공통 미결 큐

## 현재 상태 (2026-07-03 종료 시점)

- **80상품 완성 GO** = 디지털인쇄 36 + 스티커 16 + 실사 28. 그래프 노드 963·엣지 3047·하드 위반 0·멱등(직접 재빌드 확인). product 노드 정확히 80.
- 전 상품군 O1~O7 게이트 GO(라이브 evaluate_price 대조 오차 0·환각 0·미출시 정직). 커밋 4건(`ce29002`→`9b3ccd9`→`65936c9`→`7a62395`).
- 4단 확장 루프 검증 완료: 팩 → 구축(자기 파일만) → 3축 적대검증(결정론 우선) → 질의 게이트. `_meta/expansion-plan.md` §1~§4.
- 재개 방법: `huni-ontology-kb-orchestrator` 스킬에 "<상품군> KB 확장". 워크플로 스크립트 선례 = `.claude/.../workflows/scripts/okb-expand-silsa-*.js`(팩+구축+통합) + `okb-silsa-verify-gate-*.js`(검증+게이트) 복사·수정.

## 이번 세션 결정 (relitigate 금지)

1. **하네스 §33 신규 구축** — 에이전트 6인(okb-*) + 스킬 3종 + dynamic workflow 실행 모드
2. **§9 위키 승계+재사용**(재병합 금지) · **파일=정본, 그래프=결정론 빌드 파생물**(md→jsonl→SQLite 3층·Kuzu 기각) · **파일럿=디지털인쇄** · **KB 범위=상품+가격만**(주문/배송/회원/쿠폰=거절)
3. 스키마 v1.0.1 **사용자 승인 완료** — 개체 17종·관계 19종·출처 5필드·badge 4종·양면/GAP 노드·가격은 연결까지(값=evaluate_price 권위). 실사에서 L-20 lint(size 앵커 중복 방지) 추가.
4. **가격 아키타입 3종 확정**(prc_typ로 기록): 디지털=원자합산 / 스티커=고정룩업+band+팩 / 실사=면적매트릭스 [가로×세로]·off-grid ceiling·가로세로 스왑 비대칭.
5. **slug 정본 = product-NNN-kebab**[HARD] — 팩 단계에서 강제해 넘긴다(스티커 명명 분열 재발 방지·실사에서 dead-link 0 실증).
6. 워크플로 운영 교훈[HARD급]: 서브에이전트 구조화 반환은 초소형(경로+숫자+한 문장)만 — 대형 반환은 필수 필드 누락으로 5회 재시도 실패 재발(3회 실증). 실패해도 작업 파일은 디스크에 남으므로 진단은 파일 실측부터.

## 건드리지 말 것

- `03_kb/` 정본 노드(product 80 + 축·공식·용어·규칙·GAP) + `04_graph/build_graph.py`(하드 위반 0·멱등·L-20 포함) — 수정은 반드시 정본 파일 경유 후 재빌드
- `02_ontology/` 스키마 v1.0.1(승인본) — 변경 시 이력 절+마이그레이션 노트 필수
- `00_research/methodology-playbook.md`(7대 원칙·D-1~D-22) · `01_curation/`(source-registry STALE 금지·pack-digital-print·pack-sticker·pack-silsa)
- 검증 판정 문서(`05_verification/`·`06_query_gate/gate-verdict-*.md`) — 재게이트 시 append, 덮어쓰기 금지
- 연당가 양면 노드(스티커 6+SIZ_170·실사 원천결함 2) = §23 재적재 워크리스트 입력 — 삭제 금지(라이브 재적재 완료 시 현재값=정답으로 승격)
