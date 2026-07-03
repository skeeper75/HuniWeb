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

## 실사 계열 GAP 색인 (2026-07-03·118~145 28상품·정직 공백·노드 정의는 각 product/*-nodes.md·여기는 링크만)

> 실사 공통 열린 질문: ①롤 소재→면적매트릭스 셀단가/고정가 통가격 산정 로직=엑셀 미기재 암묵지([[GAP_roll_material_price]]·source-registry §9 GAP-2·실사 전체 영향·값=evaluate_price 권위·가격경로는 연결됨=견적0 아님) ②면적매트릭스 min_qty 차원 선언 vs 단가행 공란(수량축 없음 원칙과 어긋남·검증/개발 레인) ③패브릭/메쉬 자재유형 MAT_TYPE.08 미교정(코드 개편으로 목표라벨 STALE T-2) ④부속(거치대/우드봉/천정고리) 귀속=CPQ 옵션 vs addon/set 미결(pack §3.12 GAP-SL-4) ⑤삭제 마스터 드리프트(자재/공정 del_yn=Y인데 옵션/링크 활성). ★가격모델=면적매트릭스형(118~128·138/139 base)+고정가형(129~137·140~145).
> ★양면 defect 노드(어느 쪽도 삭제 금지·정리 워크리스트·실무진+인간 승인): material-MAT_000181(그래픽천 .08→.05·123)·component-COMP_POSTER_CANVAS_HANGING(use_dims 면적템플릿 vs 셀키 siz_cd·133)·gap-136-coating-optref-stale·gap-136-stand-orphan-components(136)·optgroup-137-standoff(거치대 template 미배선·137)·material-MAT_000069 양면테입·material-MAT_000340 봉제사·process-PROC_000084 열재단(138 삭제 마스터 드리프트)·size-SIZ_000170 A5(axis/sizes 소유·144 활성 참조자). ※SIZ_000293 A1은 gap-119-a1-master-deleted(GAP·authority=마스터 del_yn=Y)로 병기.

- gap-118-* (118 artprint-poster) — roll-price-logic·small-size-price-floor(A3/A2 최소셀 미만 off-grid 수렴). owner=staff
- gap-119-* (119 artpaper-poster) — a1-master-deleted(SIZ_000293 junction 활성 vs 마스터 del_yn=Y)·offgrid-golden. owner=dev
- gap-120-* (120 waterproof-poster) — coating-price-verify·nonspec-range-authority(GAP-SL-7)·roll-material-pricing-logic. owner=staff
- gap-121: 공유 참조(gap-119-a1-master-deleted·[[GAP_roll_material_price]])·레거시 comp COMP_POSTER_ADH_WATERPROOF_PVC(use_yn=N) 은퇴 추적=§12/§26 소관(노드 미민팅). owner=staff
- gap-123-* (123 artfabric-poster) — graphicfabric-mattype(그래픽천 자재유형 목표코드·양면 아님)·a1-size-deleted. +양면 defect material-MAT_000181. owner=staff
- gap-124-finish-process (124 linen-fabric) — 활성공정 PROC_000130 vs 마감옵션 5variant가 구 PROC_000080 참조(GAP-SL-2). owner=staff
- gap-125-* (125 canvas-fabric) — roll-price-logic·seam-variant-location(봉제 5variant 적재 위치 CPQ vs prcs_dtl_opt). owner=staff
- gap-126-* (126 leather-artprint) — roll-material-pricing·minqty-axis(use_dims min_qty 선언 vs 단가행 공란). owner=staff/dev
- gap-127-* (127 tyvek-print) — roll-material-pricing·minqty-axis(126 동형). owner=staff/dev
- gap-128-mesh-mattype-correction (128 mesh-print) — 메쉬 MAT_000183 .08 미교정·정정 목표유형 미확정(양면 아님=원천 부재)+공유 gap-126-roll/minqty 참조. owner=staff
- gap-129-* (129 foam-board) — matsize-mismatch(CN-2 엇갈림 대각선 4셀·견적0 위험·§31)·qty-band-absent·glossy-coating-optref·board-price-logic. owner=staff
- gap-130-* (130 formax-board) — lamination-no-optiongroup·cpq-option-layer(BATCH-6)·fixedprice-basis. owner=staff
- gap-131-* (131 frameless-wood-frame) — material-absent(우드 소재 baked)·lamination-no-option·frame-attribution(공정 vs 부속 AMBIGUOUS)·price-basis. owner=staff
- gap-132-* (132 leather-art-frame) — material-unwired(레더 미배선 AMBIGUOUS)·frame-attribution·qty-tier+공유 [[GAP_roll_material_price]]. owner=staff/dev
- gap-133-* (133 canvas-hanging-poster) — woodhanger-addon-reconnect(SL-DEF-005)·usedims-cellkey-mismatch. +양면 defect component-COMP_POSTER_CANVAS_HANGING. owner=staff/dev
- gap-134-woodbong-addon (134 linen-woodrod-scroll) — 우드봉 가격 배선됨·물리 부속 PRD_000013 addon/set 미연결(SL-DEF-005·GAP-SL-4). owner=staff
- gap-135-* (135 scroll-poster) — jokja-shape-param(사각/원형 param)·ceilhook-addon-path·jokja-material-partial·price-basis. owner=staff
- gap-136-* (136 pet-banner) — punch-param·stand-attribution·roll-price-logic. +양면 defect gap-136-coating-optref-stale·gap-136-stand-orphan-components. owner=staff
- gap-137-* (137 mesh-banner) — holepunch-param·standoff-addon-blocked(배너거치대 template BLOCKED)·fixedprice-basis. +양면 defect optgroup-137-standoff. owner=staff
- gap-138-* (138 standard-hanging-banner) — roll-price-logic·nonspec-no-constraint(★REVERIFY: 138은 여전히 0행이 사실·GAP-SL-7)·gakmok-gt-material(MAT_000339 삭제 드리프트). +양면 defect material-MAT_000069·material-MAT_000340·process-PROC_000084. owner=staff
- gap-139-* (139 mesh-hanging-banner) — add-option-unwired(큐방/끈 option_items 미배선)·qty-null·wide-size-grid-coverage(5000x900 격자 밖). owner=staff/dev
- gap-140-fixedprice-basis (140 matte-sheet-cutting) — 고정가 3셀 통가격 산정 근거 암묵지(130 동형). owner=staff
- gap-141-* (141 hologram-sheet-cutting) — white-underbase(PROC_000008 도메인필수 라이브 부재)·qty-empty·material-master-mismatch(MAT_000257 del_yn=Y)·price-basis. owner=staff
- gap-142-* (142 glossy-acrylic-sticker) — qty-blank·uv-process(PROC_000002 미적재 GAP-SL-A)·color-material-deleted(MAT_000255/256 del_yn=Y)·fixedprice-basis. owner=staff
- gap-143-* (143 mirror-acrylic-sticker) — uv-print-routing(레이저커팅만·UV 부재)·fixedprice-basis. owner=staff
- gap-144-* (144 mini-board-standing) — material-absent(baked)·stand-attribution·qty-band-floor(min_qty 1 vs 격자 하한 4)·price-basis. +공유 참조 size-SIZ_000170 A5 양면. owner=staff
- gap-145-* (145 mini-banner) — qtytier-floor(min_qty 1 vs 격자 최저 tier 4)·fixedprice-basis. owner=staff

## 셋트 계열 GAP (2026-07-03·Stage A okb-knowledge-builder·정직 공백)

<!-- 셋트 계열 원천 부재·미COMMIT·코드 C트랙. badge=unknown(⚪). 라우팅 대상 하네스 명기. -->
<!-- ★"가격 있는 것처럼" 넣지 않는다(pack §5). rel은 Stage A 실재 노드(공식/구성요소)만 참조. -->

### [gap-071-set-notmembered] 071 트윈링책자 셋트 미성립 {unknown}
- type: gap
- anchor: none  # 사유: 구성원 미mint(t_prd_product_sets 0행)·cover_mult ×2 엔진 BLOCKED
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1.1 [잔존 GAP] 071·§4 071 GAP·§5 GAP-SET-1", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "071 트윈링책자 = 셋트 미성립(t_prd_product_sets 0행·구성원 미mint). 부모 071은 PRF_BIND_TWINRING 바인딩(제본비만)이나 셋트로 성립 안 함"
- gap_fill_from: "개발팀 엔진 수정(CODEBUG-cover-mult-x2-undercharge·표지 개별×2 곱셈경로) 후 082 동형 구성원 mint(dbmap 위임·search-before-mint)"
- gap_owner: dev
- rel: {rel: references, target: formula-PRF_BIND_TWINRING, note: "071 부모공식(제본비만·셋트 미성립)"}

### [gap-set-088-redesign-pending] 088 레더링바인더 재설계 적재 승인 대기 {unknown}
- type: gap
- anchor: none  # 사유: 088-redesign 표지 9,000·싸바리 = S1~S8 GO·codex 13/13이나 인간 승인 대기(COMMIT 미실행)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1.1 [양면·미COMMIT]·§4 088 양면·§5 GAP-SET-8", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "088 현재값 100부 796,900(COVERBIND·live) vs 088-redesign-260702 100부 1,800,000(표지 9,000/부·싸바리 제본)=적재 승인 대기. 두 워크스트림 직교(088-post-verify §5)"
- gap_fill_from: "인간 승인 → §23 load-executor COMMIT(COMP_BIND_SSABARI@PROC_000098 배선·COVERBIND 폐기)·승인 시 796,900→1,800,000"
- gap_owner: 사용자
- rel: {rel: references, target: formula-PRF_LEATHER_RINGBINDER_SET, note: "현재값 COVERBIND 부모공식(재설계 시 싸바리 전환)"}
- rel: {rel: references, target: component-COMP_BIND_SSABARI, note: "재설계 배선 예정 제본 comp(현행 미배선)"}

### [gap-set-069-070-foil] 069/070 _FOIL 박분기 공식 정본화 {unknown}
- type: gap
- anchor: none  # 사유: base(active) vs _FOIL(candidate) 활성 정본 미확정
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1.1 [불변·양면] 069/070·§4 069/070·§5 GAP-SET-6", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "069/070 라이브에 base 공식(PRF_BIND_MUSEON/PUR·active) + _FOIL 박분기 공식(PRF_BIND_MUSEON_FOIL/PUR_FOIL·note '인간승인 후 COMMIT') 이중 바인딩 행 실재. 박 선택 시 활성 정본 미확정"
- gap_fill_from: "인간 승인 — base vs _FOIL 활성 정본 확정(박분기 조건부 발현 규약)"
- gap_owner: 사용자
- rel: {rel: references, target: formula-PRF_BIND_MUSEON_FOIL, note: "069 박분기 candidate"}
- rel: {rel: references, target: formula-PRF_BIND_PUR_FOIL, note: "070 박분기 candidate"}

### [gap-set-simulate-sizcd] 094/097/100 화면 0원 = 셋트 UI siz_cd 미전파 {unknown}
- type: gap
- anchor: none  # 사유: 코드 C트랙(엔진 골든 PRICE≠0·화면만 0원·가격사실 아님)
- src: {source_file: "_workspace/_foundation/remediation/DEV-REQUEST-set-sim-sizcd-260702.md", source_locator: "셋트 UI set_selections siz_cd 미전파·백필 원천=내지[HARD]·094/097/100 동시 해소", captured_at: "2026-07-03", badge: unknown, src_id: SR-set-devreq}
- gap_what: "094/097/100 엔진골든 PRICE≠0(450k/135k/1.5M)이나 셋트 화면 final=0원. 원인=셋트 UI가 set_selections에 siz_cd 미전파(코드 1점). 가격사실 아님"
- gap_fill_from: "개발팀(C트랙·DEV-REQUEST-set-sim-sizcd·백필 원천=내지 SEMI_ROLE.01[HARD]·094/097/100 동시 해소)"
- gap_owner: dev

### [gap-set-s1s2-double] S1/S2 내지인쇄 이중합산 + 068~070 코팅 드롭 {unknown}
- type: gap
- anchor: none  # 사유: 가격엔진 구조결함(전 책자 공통·엔진 use_dims·배타선택 부재)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.3 GAP-SET-3·§3.6 표지 코팅드롭 C트랙", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "① 내지 양면 주문 시 S1(단면)+S2(양면) 둘 다 매칭·배타선택 부재(전 책자·094 포함) ② 068~070 셋트경로 시뮬(price_views.py:1930)이 표지 coat_side_cnt 미전달→표지 코팅비(100부 50,000) 저평가. 둘 다 PRICE≠0 무해·골든만 영향"
- gap_fill_from: "개발팀(C트랙·엔진 use_dims 배타선택·member selections coat_side_cnt 전달)"
- gap_owner: dev

### [gap-set-inner-page-price] 내지 페이지 단가(D-2) {unknown}
- type: gap
- anchor: none  # 사유: hlg O-1 후속·내지 페이지 단가 배선 후속
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.4 GAP-SET-4·§5 D-2", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "셋트 내지 페이지 단가(D-2) 후속 설계. 내지 member min/max/incr=페이지 가변(엽서북 20~30/+10·중철 4~28/+4·무선/PUR 24~300/+2)·db_comment는 '구성원 개수' 오등록이나 load-bearing(페이지수)"
- gap_fill_from: "§34 hlg O-1 후속(내지 페이지가격)·페이지 단가 무손상[HARD]·라벨 정정은 표시만"
- gap_owner: 설계

### [gap-set-print-membrane] 인쇄면지(385) 인쇄비 배선(D-3) {unknown}
- type: gap
- anchor: none  # 사유: hlg O-1 후속·인쇄면지 인쇄비 배선 미결(기여 0)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.5 GAP-SET-5·§5 D-3", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "인쇄면지(MAT_000385·082/088 4번째 면지색) 인쇄비 배선(D-3). 현재 기여 0(면지 무가격)이나 인쇄면지는 인쇄 대상"
- gap_fill_from: "§34 hlg O-1 후속(인쇄면지 인쇄비)·선택지 보존"
- gap_owner: 설계
- rel: {rel: references, target: material-MAT_000385, note: "인쇄면지 자재(인쇄비 배선 대상)"}

### [gap-set-member-optgroup-ui] 구성원 옵션그룹 UI 렌더(D-1) {unknown}
- type: gap
- anchor: none  # 사유: hlg O-1 후속·구성원(면지 등) 옵션그룹 UI 렌더 미결
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.9 GAP-SET-7·§5 D-1", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "셋트 구성원(면지 멤버 색 택1 등) 옵션그룹 UI 렌더(D-1). 면지 색=면지멤버 옵션그룹(OPT_064/067)으로 이관됐으나 위젯/화면 렌더 후속"
- gap_fill_from: "§34 hlg O-1 후속·§6 위젯(구성원 옵션 UI)"
- gap_owner: 설계

### [gap-design-calendar-fixedprice] design-calendar 고정가 미적재 {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_prices 캘린더 0행(고정가 직접단가 미적재)·110 editor_yn=N
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§0.1 [GAP-CAL]·§5 GAP-CAL", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-set}
- gap_what: "design-calendar 고정가 미적재(t_prd_product_prices 캘린더=0행·110 엽서캘린더 editor_yn=N 디자인 surface 미구성). ★업로드 캘린더 가격공식(PRF_DGP_CAL_*)은 바인딩됨(별개)·design surface 고정가만 GAP"
- gap_fill_from: "실무진·§26(원천 부재). 위키 [CAL-DC-001] 🔴 여전"
- gap_owner: staff
