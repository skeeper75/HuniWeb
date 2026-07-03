<!-- axis page: E6 process — 디지털인쇄 파일럿 공정 노드(마스터 t_proc_processes). -->
<!-- 상품→공정(R5 has_process·mand/opt)은 상품 노드(Phase 4)가 건다. PROC_000004는 7월 대발견의 근거라 decision이 역방향으로 연결(decided_because). -->

# 축: 공정 (process)

디지털인쇄 공정 라우트 = 디지털출력→별색→코팅→재단→커팅→후가공→포장(팩 §3.6).
1옵션 ≠ 1공정(docs/kb 01). 별색·박·코팅·UV는 전부 "공정"으로 들어온다(도수 아님·팩 §3.3).

### [process-PROC_000004] 디지털인쇄 (base) {verified}
- type: process
- anchor: t_proc_processes/PROC_000004
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000004", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/digital-print-baseproc-260701.md", source_locator: "문서:§4-A base 공정 미바인딩 18건", captured_at: "2026-07-03", badge: verified, src_id: SR-26-baseproc}
- props: {proc_nm: "디지털인쇄", role: "base 인쇄공정", mand_note: "디지털 완제품에 mand_proc_yn=Y로 결합(016 미러)"}
- 본문: 디지털인쇄 base 공정. 이 공정이 상품에 미바인딩이면 인쇄비가 영구 0이 된다(7월 대발견·[[rule/rules#RULE_dataline_neq_wiring]]). 016 등 18건 COMMIT으로 정상화([[rule/decisions#DEC_baseproc_260701]]).

### [process-PROC_000001] 인쇄 {verified}
- type: process
- anchor: t_proc_processes/PROC_000001
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000001", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "인쇄", role: "인쇄 상위공정(proc_grp:PROC_000001 채점 그룹)"}

### [process-PROC_000007] 별색인쇄 {verified}
- type: process
- anchor: t_proc_processes/PROC_000007
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000007", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "별색인쇄", role: "별색(spot)=공정·도수 아님(clr_cd=NULL)"}

### [process-PROC_000013] 라미네이팅 코팅 {verified}
- type: process
- anchor: t_proc_processes/PROC_000013
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000013", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "라미네이팅 코팅", role: "유광/무광 코팅(coat_side_cnt 차원)"}

### [process-PROC_000026] 귀돌이 {verified}
- type: process
- anchor: t_proc_processes/PROC_000026
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000026", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "귀돌이", role: "모서리 라운딩(용어 라운딩·[[_glossary#TERM_corner_round]])"}

### [process-PROC_000029] 오시 {verified}
- type: process
- anchor: t_proc_processes/PROC_000029
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000029", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "오시", role: "접는 자국(crease)"}

### [process-PROC_000030] 미싱 {verified}
- type: process
- anchor: t_proc_processes/PROC_000030
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000030", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "미싱", role: "절취선(perforation)·미싱제본과 이원화 주의(030↔086)"}

### [process-PROC_000033] 박 {verified}
- type: process
- anchor: t_proc_processes/PROC_000033
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000033", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "박", role: "박(foil)·박색 매트릭스·박 부모 vs 박색 8자식 AMBIGUOUS([[rule/gaps#GAP_foil_parent_children]])"}

### [process-PROC_000053] 완칼 {verified}
- type: process
- anchor: t_proc_processes/PROC_000053
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000053", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "완칼", role: "완제품 커팅(die-cut)·모양엽서/라벨택. 단가형×판수 이중적용 교정([[rule/decisions#DEC_diecut_260701]])"}

### [process-PROC_000056] 접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000056
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000056", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "접지", role: "접지(fold)·리플렛/접지카드"}

### [process-PROC_000079] 타공 {verified}
- type: process
- anchor: t_proc_processes/PROC_000079
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000079", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "타공", role: "구멍(6mm 등)·헤더택/배경지"}

### [process-PROC_000085] 가변데이타 {verified}
- type: process
- anchor: t_proc_processes/PROC_000085
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000085", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "가변데이타", role: "가변텍스트/가변이미지(넘버링·개인화)"}

## 명함·후가공 자식 공정 (축 승격 260703)

<!-- 2026-07-03 승격(okb-knowledge-builder): 아래 6공정은 2+ 상품 공유(032/033/024/027/041)라 상품-local 정의를 -->
<!-- 공유 axis로 이관(단일 소유권 확정·L-3 재발 방지). 이 축 노드 공급이 R2 016 has_process 배선 근거(옛 gap-016-process-nodes 대상 소멸). -->
<!-- 치수/상위공정 전사표는 각 상품 파일(transcribe_product_033.py·transcribe_namecard032.py)에 유지(스크립트 산출). -->

### [process-PROC_000014] 유광라미네이팅 {verified}
- type: process
- anchor: t_proc_processes/PROC_000014
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000014", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "유광라미네이팅", role: "코팅 옵션(유광)·PROC_000013 코팅 계열 자식", mand: N, 사용: "032·024(코팅명함/포토카드)"}

### [process-PROC_000015] 무광라미네이팅 {verified}
- type: process
- anchor: t_proc_processes/PROC_000015
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000015", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "무광라미네이팅", role: "코팅 옵션(무광)·PROC_000013 코팅 계열 자식", mand: N, 사용: "032·024"}

### [process-PROC_000027] 직각 (모서리) {verified}
- type: process
- anchor: t_proc_processes/PROC_000027
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000027", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "직각", upr_proc_cd: "PROC_000026", role: "모서리 직각(default 재단)·귀돌이(PROC_000026)의 자식 공정", 사용: "033·032·024"}

### [process-PROC_000028] 둥근 (모서리 라운딩) {verified}
- type: process
- anchor: t_proc_processes/PROC_000028
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000028", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "둥근", upr_proc_cd: "PROC_000026", role: "모서리 둥근(R 라운딩)·귀돌이(PROC_000026)의 자식 공정", 사용: "033·032·024"}

### [process-PROC_000031] 가변텍스트 {verified}
- type: process
- anchor: t_proc_processes/PROC_000031
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000031", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "가변텍스트", upr_proc_cd: "PROC_000085", role: "가변데이타(PROC_000085)의 자식·넘버링/개인화 텍스트", 사용: "033·027·041"}

### [process-PROC_000032] 가변이미지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000032
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000032", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "가변이미지", upr_proc_cd: "PROC_000085", role: "가변데이타(PROC_000085)의 자식·개인화 이미지", 사용: "033·027·041"}


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [process-PROC_000054] 반칼 (Kiss Cut·종이만) {verified}
- type: process
- anchor: t_proc_processes/PROC_000054
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000054(반칼·note 'Kiss Cut, 종이만 (스티커)'·prcs_dtl_opt inputs=모양/조각수)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000054,PROC_000054) mand_proc_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mand_proc_yn: "N", inputs: "모양(string)·조각수(integer 개)", note: "반칼=Kiss Cut(자유형 칼틀·종이만·pack §3.6). 조각수 input은 prcs_dtl_opt에 있으나 상품레벨 저장처 부재([[gap-054-piece-count-storage]]·GAP-ST-2/OM-7). 공유 axis/processes.md 미등재(스티커 커팅 첫 등장)·승격 대기(needed_shared)"}
- 본문: 반칼(kiss cut) = 스티커 정체 공정([[sticker-halfcut-hologram]] has_process·mand=N). 자유형 칼틀 모양대로 점착지만 절개(대지 남김).

### [process-PROC_000055] 스티커완칼 (승격 대기·명칭 관찰) {verified}
- type: process
- anchor: t_proc_processes/PROC_000055
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000055 (proc_nm=스티커완칼·note=Die Cut + 조각수·prcs_dtl_opt inputs=조각수 integer)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:(PRD_000060,PROC_000055) mand_proc_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "스티커완칼", role: "스티커 도무송 Die Cut(조각수 param)", 소비상품: "PRD_000060 등(mand=N)", note: "★상품명 '반칼직사각'인데 등록 공정=스티커완칼(PROC_000055 Die Cut). 반칼(Kiss Cut)=PROC_000054·완칼(종이+후지)=PROC_000053(공유 축)와 별 코드. pack §3.6=디지털은 반칼(PROC_000054) → 불일치 관찰 gap-060-halfcut-process. 스티커 공유 축 승격 후보"}

<!-- [process-PROC_000013] 라미네이팅 코팅 = 공유 축 노드(axis/processes.md) 재사용 — 중복 생성 금지(L-3). 코팅 CONFLICT의 '공정 뷰'가 이 노드로 해소(gap-060-coating-conflict가 references). -->
<!-- [printopt-POPT_000001] 단면 = 공유 축(axis/print-options.md) 재사용 — 위 전사표에 실재 기록·has_print_option 엣지가 그 노드로 해소. -->

### [process-PROC_000114] 쿨코팅 {verified}
- type: process
- anchor: t_proc_processes/PROC_000114
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000114 (upr_proc_cd 없음·2026-06-29 mint)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000055(mand_proc_yn=N·disp 2)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "쿨코팅", upr_proc_cd: "", mand: "N", role: "무광쿨코팅(자재 MAT_000593 내장 코팅의 공정 표현)", note: "코팅=공정 vs 자재 CONFLICT(팩 §3.9·BATCH-3 GAP-ST-1)의 스티커 사례 — 055는 공정(PROC_000114)+자재명 내장 양쪽에 존재. 단정 금지·공유 축 승격 후보"}

### [process-PROC_000122] 반칼커팅 (Kiss Cut) {verified}
- type: process
- anchor: t_proc_processes/PROC_000122
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000122 (upr_proc_cd=PROC_000121 커팅·2026-06-29 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000052(mand Y·disp 1)·구 PROC_000054 반칼은 052에서 del_yn=Y 이관", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "반칼커팅", upr_proc_cd: "PROC_000121", role: "반칼 Kiss Cut(자유형 모양·뒷지 남김)·스티커 정체 공정", note: "★구 PROC_000054(반칼 Kiss Cut·prcs_dtl_opt 모양+조각수)에서 이관·pack §3.6 '반칼=PROC_000054'는 live 재측정 갱신·023 완칼 PROC_000053→123 이관과 동형·승격 후보"}
