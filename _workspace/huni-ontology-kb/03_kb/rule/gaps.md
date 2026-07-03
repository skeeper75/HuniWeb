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

### 확장 상품 GAP 색인 (017~051·공유축 통합 260703)

> 아래 GAP 노드도 각 상품 파일에 `### [id] {unknown}`로 정의됨(gaps.md는 색인·재정의 금지 L-3).
> 통합축 mint(21종)으로 025/035/036/037/039의 자재/공식 브로큰링크는 해소 — 아래는 **잔존 GAP**만.

- GAP_018_material (018) — 활성자재 7종 중 MAT_000080/090 공유 axis 미민팅(rewire 미실행·정직 지연). owner=설계
- gap-018-constraint (018) — 오시·미싱 물리 상호배제(CN-4) 라이브 미등록·환각 constraint 금지. owner=staff/§31
- gap-018-addon-envelope (018) — 봉투 addon 0행(016은 5행)·has_addon 미배선. owner=staff
- gap-018-postpress-param (018) — 후가공 줄수·개수 파라미터 CPQ 미보존(033 동형). owner=설계
- gap-019-material (019) — 투명/반투명 PET(MAT_000144/147 공유 mint 완료)이나 019 uses_material rewire 미실행. owner=설계
- gap-019-white-process (019) — 화이트인쇄 PROC_000008 공유 axis 미민팅·has_process 미배선. owner=설계
- gap-020-addon-target·gap-020-paper-optitem-ref (020) — 봉투 addon 대상 미노드·종이 옵션 ref 레이어 공백. owner=설계
- gap-021-pink-process·gap-021-material·gap-021-addon-target (021) — 핑크 별색공정 PROC_000010 미민팅·자재 2종·봉투 addon(가격경로는 PROC_000007 환원 연결). owner=설계/staff
- gap-022-spotcolor-unwired·GAP_022_material (022) — 금/은 별색공정 PROC_000007 미배선→가격 미기여·자재 2종 미민팅. owner=staff/설계
- gap-023-diecut-golden·gap-023-diecut-combined-doublecount (023) — 완칼 골든 미검증·이중합산 관찰(엔진 재계산 소관). owner=dev
- gap-025-white-spot·gap-025-option-material-stale·gap-025-addon-envelope (025) — 화이트별색 미배선(BLOCKED)·소프트삭제 자재 참조·봉투 addon. owner=staff/dbmap
- gap-026-coat-side (026) — 코팅 면수 옵션 파라미터 미보존(GAP_032 동형). owner=설계
- gap-028-foil-price-path·gap-028-qty-confirm (028) — 박분기 공식/옵션 부재·수량축 컨펌 대기(use_yn=N). owner=설계/staff
- gap-029-addon-envelope (029) — 3단접지카드 봉투 addon 대상 미노드. owner=설계
- gap-030-paper-optref-mismatch·gap-030-addon-envelope (030) — 종이옵션이 논리삭제 자재 참조·봉투 addon. owner=staff/설계
- GAP_031_paper_parent_child·gap-031-vardata-param (031) — 종이 부모참조 vs child 단가행 환원 미확인·가변 파라미터. owner=staff/위젯
- GAP_034_foil_optgroup (034) — 박색 CPQ 옵션그룹 0행(가격경로는 proc_cd 게이트로 연결). owner=staff/§31
- gap-035-diecut-process·gap-035-cpq-option-layer (035) — 모양 die-cut 공정 0행·CPQ 옵션 레이어 0행. owner=staff
- gap-036-diecut-process-absent (036) — 완칼 표현 전무(고정가 흡수·견적 차단 아님). owner=staff
- gap-037-foil-color-select·gap-037-plate-output-paper (037) — 박색 택1 옵션 미표현·output_paper_typ 공란(가격 무영향). owner=staff
- gap-038-no-price-path·gap-038-emboss-unbound·gap-038-skeleton-bindings (038) — priced_by 0행(derived_from→gap·O5 예외)·형압 PROC_000050 미바인딩·자재/CPQ 0행. owner=설계/staff
- gap-039-white-print-absent (039) — 투명명함 화이트인쇄 공정/구성요소 부재(가격경로 미끊김). owner=staff
- gap-040-clear-optitem-ref·gap-040-paper-optgroup (040) — 클리어별색 opt ref 0건·색지 옵션그룹 부재(가격 무영향). owner=설계
- GAP_paper_material_042·GAP_finish_param_042·GAP_foil_param_042 (042) — 종이 옵션 굿즈 오적재 잔존(defect)·후가공/박 파라미터 미보존. owner=실무진/§17/설계
- GAP_044_perf_process (044) — 투명케이스 타공비 배선 vs 타공 공정 미등록(043 동형). owner=staff
- GAP_045_perf_process (045) — 헤더택 타공비 silent 0 위험(043 동형). owner=staff
- gap-047-coating-constraint·gap-047-coat-side·gap-047-vardata-param·gap-047-optref-mat129 (047) — 제약 스냅샷지연(L-17)·코팅면수·가변파라미터·매달린 옵션참조 MAT_000129. owner=설계/staff/dev
- gap-048-price-path-incomplete·gap-048-no-size·gap-048-material (048) — ★가격경로 불완전(접지비만·인쇄/용지 미배선)·사이즈 0행·자재 30 미민팅+2 오염의심. owner=설계
- gap-049-cpq-optiongroups (049) — 접지/라미/가변 has_process 있으나 CPQ 옵션그룹 0행(027/029 동형 참조). owner=설계
- gap-051-golden (051) — 썬캡 완칼 골든 미검증+미출시(대조 정답 부재). owner=dev

## 스티커 계열 GAP 색인 (2026-07-03·16상품·정직 공백·노드 정의는 각 product/*-nodes.md·여기는 링크만)

> 스티커 공통 열린 질문: ①코팅=자재 vs 공정 vs 가격축 3원천 CONFLICT(BATCH-3·GAP-ST-1·owner=staff) ②소재 연당가(원가) 저장처 부재(systemic·§4-B·owner=staff) ③규격형 형상 저장 모델 불일치(058 옵션값 vs 066 siz_nm·GAP-ST-3) ④조각수 저장처 부재(OM-7). ★연당가 재적재 워크리스트(돈-크리티컬)=양면 defect 노드(matcost-053-white/clear-backing·matcost-054-hologram·material-MAT_000162/372)+size-SIZ_000170(A5 사이즈 재키잉)=실무진+인간 승인 대기.

- gap-052-* (052 halfcut-freeform) — coating-conflict·cut-optref-dangling(OPV_000023→삭제 PROC_000054·fn_chk_opt_item_ref)·liandan-out-of-scope. owner=staff/dev
- gap-053-* (053 halfcut-clear) — cutting-rekey·yeondangga-repricing·piece-count-storage. +양면 defect matcost-053-white/clear-backing. owner=dev/staff
- gap-054-* (054 halfcut-hologram) — yeondangga-repricing·white-underbase-price·piece-count-storage. +양면 defect matcost-054-hologram. owner=staff/dev
- gap-055-* (055 sheet-freeform) — cutting-optref-stale·jogaksu-storage·material-name-cst10·material-cost-storage. owner=staff/dev
- gap-056-* (056 sheet-clear-white) — material-cost-storage·retail-cost-propagation·cpq-option-layer. +양면 defect material-MAT_000162/372. owner=staff/dev
- gap-057-material-cost (057 large-freeform) — 유포 원가 저장처 부재(057 retail 정상·원가 축만 미상). owner=staff
- gap-058-* (058 spec-circle) — coating-conflict·shape-storage·yeondangga·price-golden·constraint-stale-size(RULE_001 삭제 SIZ_000426). owner=staff/dev/§31
- gap-059-* (059 spec-square) — coating-conflict·spec-shape-cut(형상·커팅공정 명칭 불일치). owner=staff
- gap-060-* (060 spec-rectangle) — coating-conflict·halfcut-process·a5-size-master-deleted·mat084-typ·yeondangga-scope·golden. owner=staff/dev
- gap-061-* (061 spec-band) — coating-conflict·halfcut-process·a5-size-master-deleted·mat084-typ·yeondangga-scope·golden. owner=staff/dev
- gap-062-* (062 spec-fancy) — siz058-price-missing(silent-0)·paper-unwired(OPT_000041 미배선)·shape-storage·coating-conflict·yeondangga·price-golden. owner=staff/dev
- gap-063-* (063 spec-fancy-clear·use_yn=N) — halfcut-process·cpq-option-layer·material-unmigrated(구코드 MAT_000162 직결). owner=staff
- gap-064-* (064 smallqty-freeform·use_yn=N) — cpq-missing(CPQ 0행)·coating-conflict·liandan-out-of-scope. owner=dev/staff
- gap-065-* (065 sticker-pack) — set-composition(sets 0행·Q-ST-E)·material-type-label(084 .13 vs .11)·pack-qty-band·cpq-option-layer·liandan-out-of-scope. owner=staff/dev
- gap-066-* (066 gangpan-diecut) — coating-conflict·yeondangga·price-golden·plate-otyp·rekeying-skew·mattype-note-skew·shape-model-family·empty-optgroup-resolved(해소). owner=staff/dev
- gap-067-* (067 tattoo) — mattype-transfer-paper(.11 vs .01 표본 컨펌)·liandan-out-of-scope. owner=staff
