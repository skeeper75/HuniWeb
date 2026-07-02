<!-- intent(INTENT_*) — 용도·의도 KB 전용 레이어(E special·앵커 none). nl-query 유형 2(용도 추천) 진입점. -->
<!-- intent→상품(군) 연결은 R19 references(any→any). Phase 3에서는 카테고리로 연결(상품 노드는 Phase 4에서 보강). -->

# 축: 용도·의도 (intent) — KB 전용 추천 레이어

라이브 t_*에 대응 테이블이 없는 축(고객이 "카페 오픈 기념"이라 말할 때 상품군으로 잇는 축).
용어집·경쟁사 코퍼스에서 유도(anchor=none+사유). 이 축이 없으면 "용도 추천" 질의를 못 답한다
(nl-query-paths S4~S6). Phase 3에서는 카테고리로 시드 연결, 상품 노드 references는 Phase 4에서 보강.

### [INTENT_cafe_opening] 카페 오픈 기념 {candidate}
- type: intent
- anchor: none  # 사유: KB 전용 용도 축(라이브 대응 테이블 없음)·용어집/경쟁사 근거
- src: {source_file: "docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md", source_locator: "§경쟁사 옵션 코퍼스→용도 매핑", captured_at: "2026-07-03", badge: candidate, src_id: SR-1-kb03}
- rel: {rel: references, target: category-CAT_000307, note: "엽서(오픈 안내·쿠폰)"}
- rel: {rel: references, target: category-CAT_000062, note: "쿠폰/상품권"}
- props: {customer_phrase: "카페 오픈 기념으로 나눠줄 것", status: "후보(집필 층 유도·상품 references는 Phase 4 확정)"}

### [INTENT_wedding] 청첩·웨딩 {candidate}
- type: intent
- anchor: none  # 사유: KB 전용 용도 축·용어집/경쟁사 근거
- src: {source_file: "docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md", source_locator: "§용도 코퍼스", captured_at: "2026-07-03", badge: candidate, src_id: SR-1-kb03}
- rel: {rel: references, target: category-CAT_000307, note: "엽서/청첩 카드"}
- rel: {rel: references, target: category-CAT_000001, note: "엽서/카드 계열"}
- props: {customer_phrase: "청첩장·웨딩 관련", status: "후보"}

### [INTENT_premium] 고급·프리미엄 {candidate}
- type: intent
- anchor: none  # 사유: KB 전용 용도 축(품질 형용 표현)
- src: {source_file: "docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md", source_locator: "§품질 형용→상품 매핑", captured_at: "2026-07-03", badge: candidate, src_id: SR-1-kb03}
- rel: {rel: references, target: category-CAT_000313, note: "명함(프리미엄·펄·박)"}
- rel: {rel: references, target: category-CAT_000307, note: "프리미엄엽서"}
- props: {customer_phrase: "고급스러운 것", status: "후보(intent∩category 교집합·nl-query S5)"}
