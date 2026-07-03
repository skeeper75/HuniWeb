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
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000001(upr 공란·note 'Decision 14 v3 — 1상품=1인쇄방식'=그룹 루트·자식 004/003/005…)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "인쇄", role: "인쇄 상위공정(proc_grp:PROC_000001 채점 그룹)·택소노미 그룹 루트(상품은 자식 리프를 직접 소비·t_prd_product_processes 루트 0행 정상)"}
- rel: {rel: references, target: process-PROC_000004, note: "택소노미 그룹 루트 → 대표 자식(디지털인쇄 base·upr_proc_cd=PROC_000001 live). 상품 has_process는 리프(004 등)에 배선·루트 직접 캐리어 없음(C-4 명시 처리·조용한 고아 아님)"}

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
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000056(upr 공란·note '그룹 root'·자식 057~063/106/107 접지 변형)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "접지", role: "접지(fold)·리플렛/접지카드·택소노미 그룹 루트(상품은 자식 리프 소비·루트 t_prd_product_processes 0행 정상)"}
- rel: {rel: references, target: process-PROC_000060, note: "택소노미 그룹 루트 → 대표 자식(3단접지·upr_proc_cd=PROC_000056 live·049 와이드접지리플렛 소비). 루트 직접 캐리어 없음(C-4 명시 처리)"}

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

## 셋트 계열 공유 제본 공정 — Stage A(okb-knowledge-builder 260703)

<!-- 셋트 공유축: 제본 공정이 셋트 form을 만든다(정체 공정·pack §3.6). has_process(product→process·R5)는 상품/구성원 노드(Stage B)가 배선. -->
<!-- ★소비자(Stage B가 배선): 068→중철·069→무선·070→PUR·071→트윈링·094/097→떡·072/077→하드커버무선·082→하드커버트윈링(t_prd_product_processes 실측). -->
<!-- 싸바리 PROC_000098=088 redesign pending(현행 미배선). 캘린더 제본=단품 참고(99/100/102). -->

### [process-PROC_000017] 제본(그룹) {verified}
- type: process
- anchor: t_proc_processes/PROC_000017
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000017 (upr 없음·disp 4·use_yn=Y·note '필수,단일'·inputs=방향/묶음단위/책등mm/고리형)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "제본", upr_proc_cd: "", mand: "필수·단일", role: "셋트 제본 공정 그룹(자식=중철/무선/PUR/트윈링/떡/하드커버 등). proc_grp:PROC_000017=제본 comp use_dims 게이트·택소노미 그룹 루트(상품은 자식 리프 소비·루트 t_prd_product_processes 0행 정상)."}
- rel: {rel: references, target: process-PROC_000018, note: "택소노미 그룹 루트 → 대표 자식(중철제본·upr_proc_cd=PROC_000017 live·068 소비). 루트 직접 캐리어 없음(C-4 명시 처리·조용한 고아 아님)"}

### [process-PROC_000018] 중철제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000018
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000018 (upr PROC_000017·disp 1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000068(중철책자 셋트)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "중철제본", upr_proc_cd: "PROC_000017", role: "068 중철책자 제본(COMP_BIND_JUNGCHEOL·PRF_BIND_SUM)."}

### [process-PROC_000019] 무선제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000019
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000019 (upr PROC_000017·disp 2)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000069(무선책자 셋트)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "무선제본", upr_proc_cd: "PROC_000017", role: "069 무선책자 제본(COMP_BIND_MUSEON·PRF_BIND_MUSEON)."}

### [process-PROC_000020] PUR제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000020
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000020 (upr PROC_000017·disp 3)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000070·PRD_000100(PUR책자·포토북)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "PUR제본", upr_proc_cd: "PROC_000017", role: "070 PUR책자·100 포토북 제본(COMP_BIND_PUR·PRF_BIND_PUR)."}

### [process-PROC_000021] 트윈링제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000021
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000021 (upr PROC_000017·disp 4)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000071(트윈링책자·셋트 미성립)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "트윈링제본", upr_proc_cd: "PROC_000017", role: "071 트윈링책자 제본(COMP_BIND_TWINRING). ★071 셋트 미성립=gaps.md#gap-071-set-notmembered. 캘린더 111/112도 트윈링(단품)."}
- rel: {rel: references, target: gap-071-set-notmembered, note: "범위 내 유일 캐리어 PRD_000071이 셋트 미성립 GAP(t_prd_product_processes 소비=071·177/178은 문구셋트 범위밖 live 재실측). 상품 has_process 배선 불가 사유를 GAP으로 명시 연결(C-4·조용한 고아 아님)"}

### [process-PROC_000022] 떡제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000022
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000022 (upr PROC_000017·disp 5)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000094·PRD_000097(엽서북·떡메모지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "떡제본", upr_proc_cd: "PROC_000017", role: "094 엽서북·097 떡메모지 제본(묶음단위 50/100장1권)."}

### [process-PROC_000023] 하드커버무선제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000023
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000023 (upr PROC_000017·disp 6)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000072·PRD_000077(하드커버·레더하드커버)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "하드커버무선제본", upr_proc_cd: "PROC_000017", role: "072/077 하드커버책자 제본(COMP_HC_MUSEON_COVERBIND 통가·PRF_HC_MUSEON_SET)."}

### [process-PROC_000024] 하드커버트윈링제본 {verified}
- type: process
- anchor: t_proc_processes/PROC_000024
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000024 (upr PROC_000017·disp 7)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000082(하드커버링책자)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "하드커버트윈링제본", upr_proc_cd: "PROC_000017", role: "082 하드커버 링책자 제본(COMP_BIND_HC_TWINRING·PRF_HC_TWINRING_SET)."}

### [process-PROC_000098] 싸바리바인더 {candidate}
- type: process
- anchor: t_proc_processes/PROC_000098
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000098 (upr PROC_000017·disp 9·use_yn=Y)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {proc_nm: "싸바리바인더", upr_proc_cd: "PROC_000017", role: "088 레더 링바인더 싸바리 제본. ★live 실재(use_yn=Y)이나 t_prd_product_processes 소비 0행(현행 미배선)·088-redesign pending에서 COMP_BIND_SSABARI@PROC_000098 배선 예정(인간승인 후). gaps.md#gap-set-088-redesign-pending."}
- rel: {rel: references, target: gap-set-088-redesign-pending, note: "t_prd_product_processes 소비 0행(live 재실측)=상품 has_process 배선 불가. 088-redesign(인간 승인 대기·미COMMIT)에서 배선 예정이므로 pending GAP으로 명시 연결(C-4·조용한 고아 아님)"}

### [process-PROC_000099] 벽걸이캘린더제본(참고) {verified}
- type: process
- anchor: t_proc_processes/PROC_000099
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000099 (upr PROC_000017·disp 10)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000111·PRD_000112(벽걸이/와이드캘린더·단품)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "벽걸이캘린더제본", upr_proc_cd: "PROC_000017", role: "캘린더 단품(참고·셋트 아님). 111/112 벽걸이 제본(PRF_DGP_CAL_WIDE)."}

### [process-PROC_000100] 탁상형캘린더제본(220·참고) {verified}
- type: process
- anchor: t_proc_processes/PROC_000100
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000100 (upr PROC_000017·disp 11)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000108(탁상형캘린더·단품)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "탁상형캘린더제본(220)", upr_proc_cd: "PROC_000017", role: "캘린더 단품(참고). 108 탁상형 제본(PRF_DGP_CAL_DESK)."}

### [process-PROC_000102] 탁상형캘린더제본(미니·참고) {verified}
- type: process
- anchor: t_proc_processes/PROC_000102
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000102 (upr PROC_000017·disp 13)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000109(미니탁상캘린더·단품)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "탁상형캘린더제본(미니)", upr_proc_cd: "PROC_000017", role: "캘린더 단품(참고). 109 미니탁상 제본(PRF_DGP_CAL_DESK)."}

## 셋트 부가공정·포장 — Stage C1(okb-knowledge-builder 260703)

<!-- 무선/PUR 부가 후가공(양각/음각)·수축포장. Stage B가 프로즈로만 기록·엣지 미배선. -->
<!-- Stage C1=노드 mint·Stage C2=상품→공정(R5 has_process·mand/opt) 엣지 배선. -->
<!-- ★박 자식 공정(PROC_000037~044)은 product-027(product-027-nodes.md)에 이미 존재=재사용(중복 mint 금지·L-3). -->

### [process-PROC_000051] 양각 {verified}
- type: process
- anchor: t_proc_processes/PROC_000051
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000051 (upr PROC_000050·disp 1·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "양각", upr_proc_cd: "PROC_000050", role: "무선/PUR 책자 부가 후가공(양각 엠보싱). 069/070 부모 보유(has_process opt)."}

### [process-PROC_000052] 음각 {verified}
- type: process
- anchor: t_proc_processes/PROC_000052
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000052 (upr PROC_000050·disp 2·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "음각", upr_proc_cd: "PROC_000050", role: "무선/PUR 책자 부가 후가공(음각 디보싱). 069/070 부모 보유(has_process opt)."}

### [process-PROC_000076] 수축포장 {verified}
- type: process
- anchor: t_proc_processes/PROC_000076
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000076 (upr PROC_000075·disp 1·use_yn=Y·note 기본)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "소비:PRD_000094(수축포장 mand)·PRD_000108/109(탁상캘린더)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "수축포장", upr_proc_cd: "PROC_000075", role: "094 엽서북 수축포장(mand)·108/109 캘린더 포장 공정. has_process는 상품 노드(Stage B)."}
