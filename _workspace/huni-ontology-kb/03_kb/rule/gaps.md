<!-- gap(GAP_*) — 원천 부재로 못 닫는 공백(1급 지식). gap_what·gap_fill_from·gap_owner 3필드 필수(L-10). -->
<!-- 지어내지 않고 "무엇을 모르는지"를 등재. 판수 GAP은 사이즈의 파생(derived_from). -->

# 축: 공백 (gap) — 원천 부재·미확정

디지털인쇄 파일럿에서 어느 문서에도 정답이 없어 지금 못 닫는 것. badge=unknown(⚪). 정직 노출.

### [GAP_pansu_73x98] 디지털 73×98 판걸이수 충돌 {unknown}
- type: gap
- anchor: none  # 사유: 두 tier A 원천이 서로 다른 값(마스터 15 vs 판걸이수시트 18)
- src: {source_file: "docs/kb/KB_01_엑셀해부_접근방법론.md", source_locator: "§8 #1 판수 불일치", captured_at: "2026-07-03", badge: unknown, src_id: SR-1-kb01}
- gap_what: "디지털 73×98mm 판걸이수(UP수): 상품마스터=15 vs 판걸이수시트=18"
- gap_fill_from: "실무진(신우진) 확인 — 견적 분모 직결(판걸이수=소재 단가 나눗셈 분모)"
- gap_owner: staff
- rel: {rel: derived_from, target: size-SIZ_000001, note: "판걸이수는 이 사이즈(73x98)의 파생값"}

### [GAP_roll_material_price] 롤 소재 가격 계산 로직 {unknown}
- type: gap
- anchor: none  # 사유: 엑셀 미기재 암묵지
- src: {source_file: "docs/kb/02_상품마스터_가격표_구조_가격아키타입.md", source_locator: "§6 #1 롤 계산 로직 미기재", captured_at: "2026-07-03", badge: unknown, src_id: SR-1-kb02}
- gap_what: "롤 소재(현수막 등) 가격 계산 로직 — 엑셀 미기재"
- gap_fill_from: "실무진 + 설계(실사 전체 영향·디지털은 낱장이라 직접 영향은 적으나 경계 기록)"
- gap_owner: staff

### [GAP_envelope_set_model] 봉투/케이스 세트 적재모델 {unknown}
- type: gap
- anchor: none  # 사유: sets vs addons vs CPQ 옵션 미결(Q-ID-A)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.9 GAP·§3.12 봉투세트 모델 미결", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "봉투/케이스 세트를 sets·addons·CPQ 옵션 중 무엇으로 적재할지(016 봉투 addon 5행은 확정, 세트 표현은 미결)"
- gap_fill_from: "인간 승인 — 배경지(043/044) 포장세트 CPQ 표현과 함께 결정"
- gap_owner: 사용자

### [GAP_foil_parent_children] 박 부모 vs 박색 8자식 {unknown}
- type: gap
- anchor: none  # 사유: C-06 AMBIGUOUS 미결
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.6 GAP 박 부모/박색 8자식 옵션풀(Q-DP-C)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "박 부모(PROC_000033) vs 박색 8자식을 옵션풀로 묶을지 — 미결(C-06)"
- gap_fill_from: "실무진 확인(Q-DP-C)"
- gap_owner: staff

### [GAP_transparent019_pansu] 투명엽서019 자재종속 판걸이수 (C트랙) {unknown}
- type: gap
- anchor: none  # 사유: 코드 결함(fn_calc_pansu에 prd_cd 인자 필요)
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md", source_locator: "§투명019 자재종속·prd_cd 컬럼 예약", captured_at: "2026-07-03", badge: unknown, src_id: SR-26-pansu}
- gap_what: "투명엽서(019) 자재종속 판걸이수 — 같은 사이즈라도 자재(투명PET)에 따라 판수 달라짐. fn_calc_pansu 2인자로는 불가"
- gap_fill_from: "개발팀(C트랙) — fn_calc_pansu에 prd_cd 인자·t_siz_pansu에 prd_cd 컬럼 예약됨"
- gap_owner: dev

### [GAP_product_count] 상품 수 집계 기준 미통일 {unknown}
- type: gap
- anchor: none  # 사유: 191/243/280 미통일
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "§9 GAP-6 상품 수 집계 기준", captured_at: "2026-07-03", badge: unknown, src_id: SR-reg9}
- gap_what: "전체 상품 수 분모(191/243/280) 미통일. 디지털 36은 확정이나 전체 분모는 온톨로지 설계 시 정의 필요"
- gap_fill_from: "온톨로지 설계 시 집계 기준 정의(use_yn/del_yn 필터 규칙)"
- gap_owner: 설계

---

## 상품별 GAP (상품 파일에 정의·여기는 링크 목록만)

> 아래 GAP 노드는 각 상품 파일 안에 `### [id] {unknown}`로 정의돼 있다(여기서 재정의하면 L-3 중복).
> gaps.md는 전체 GAP 발견을 한눈에 보게 하는 색인 — 노드 본문은 괄호의 상품 파일에서 Read.

- GAP_016_material (product/product-016-premium-postcard.md) — 016 활성자재 21종 중 17종 공유 axis/materials 미민팅(대표 4종만 배선·그래프 커버리지 공백). owner=설계. ※옛 gap-016-process-nodes(공정 4행 미민팅)는 R2에서 축 노드 민팅+016 배선 완료로 대상 소멸·제거(해소 판정은 검증가).
- gap-016-addon-target (product/product-016-premium-postcard.md) — 봉투 addon 대상 상품·template 노드 미민팅(tmpl live 038/039 vs 팩 서술 010/011 불일치). owner=설계
- gap-024-addon-envelope (product/product-024-photocard.md) — 포토카드 봉투 addon 대상 product 노드 미구축. owner=설계
- gap-027-addon-envelope (product/product-027-cpq.md) — 2단접지카드 봉투 addon 대상 상품 미노드(카드봉투/트레싱지). owner=설계
- GAP_032_coat_side (product/product-032-coated-namecard.md) — 코팅 단면/양면(coat_side_cnt) 파라미터 부재·고정가라 가격무영향. owner=staff/§31
- gap-033-vardata-param (product/product-033-standard-namecard.md) — 가변텍스트/이미지 줄수·개수 파라미터 미보존. owner=위젯/§31
- GAP_finish_param_041 (product/product-041-coupon-axes.md) — 041 후가공 줄수/개수 파라미터 보존불가. owner=위젯/§31
- GAP_043_perf_process (product/product-043-bg-opp.md) — 배경지 타공비 배선 vs 타공 공정 미등록. owner=dev
- gap-046-diecut-golden (product/product-046-label-tag-nodes.md) — 라벨택 완칼 골든 절대값 미검증(.01→.03 교정 후 pcode 미상). owner=dev
