<!-- decision(DEC_*) — 확정 결정·7월 교정 이력. decided_because(R15)로 노드 상태의 근거를 잇는다. -->
<!-- 각 DEC는 §26/§27 원장 문서 앵커. 교정 "현재값"은 live-snapshot 대조(양면 원칙). -->

# 축: 확정 결정 (decision) — 7월 교정 이력

디지털인쇄 7월 초 라이브 COMMIT 원장. 각 결정이 어떤 구성요소·공정 상태의 근거인지를
`decided_because`로 잇는다(가격사슬 교정 계보를 그래프로 추적).

### [DEC_baseproc_260701] base 공정 PROC_000004 미바인딩→18건 COMMIT {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거 문서는 sources)
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/digital-print-baseproc-260701.md", source_locator: "문서:§4-A + load/undo/backup SQL", captured_at: "2026-07-03", badge: verified, src_id: SR-26-baseproc}
- rel: {rel: decided_because, target: process-PROC_000004, note: "디지털인쇄 base 공정 mand 바인딩 추가"}
- rel: {rel: decided_because, target: component-COMP_PRINT_DIGITAL_S1, note: "미바인딩=인쇄비 영구 0 → 정상화"}
- props: {일자: "2026-07-01", 내용: "16상품+019(흰토너008+CMYK004)+023(완칼123+CMYK004)=총 18건에 PROC_000004 결합. 인쇄비 27,000~71,200원/800매 정상화", 근거: "016 미러(기준점만 mand 보유)"}

### [DEC_diecut_260701] 완칼 die-cut 단가형×판수 이중적용→.03 고정 {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거 문서는 sources)
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/diecut-flat-fix-260701-load.sql", source_locator: "문서:§4-B + dryrun/undo/backup", captured_at: "2026-07-03", badge: verified, src_id: SR-26-diecut}
- rel: {rel: decided_because, target: component-COMP_CUT_FULL_DIECUT, note: "prc_typ .01→.03 고정(이중적용 과대청구 해소)"}
- rel: {rel: decided_because, target: process-PROC_000053, note: "완칼 공정"}
- props: {일자: "2026-07-01", 내용: "COMP_CUT_FULL_DIECUT .01→.03. 023 8,040,000→120,000·046 1,350,000→50,000", 잔여: "절대값 골든 pcode 미상으로 미검증(대기)"}

### [DEC_corner_260702] 귀돌이비 1건고정×수량 과대청구→.03 교정 {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거 문서는 sources)
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "모서리비 COMP_PP_CORNER_RIGHT .01→.03", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- rel: {rel: decided_because, target: component-COMP_PP_CORNER_RIGHT, note: "1건 고정금액 ×수량 100~1000배 과대청구 해소"}
- props: {일자: "2026-07-02", 내용: "COMP_PP_CORNER_RIGHT .01→.03 고정(PRF_DGP_A/D 8+상품). 3번째 반복 유형(명함·봉투·합판)"}

### [DEC_pansu_260701] fn_calc_pansu 저청구→t_siz_pansu 신설 {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거 문서는 sources)
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md", source_locator: "문서:§4-C + pansu-fix schema/data/undo", captured_at: "2026-07-03", badge: verified, src_id: SR-26-pansu}
- rel: {rel: decided_because, target: plate-OUTPUT_PAPER_TYPE_01, note: "출력용지 판걸이수 계산 정본화"}
- props: {일자: "2026-07-01", 내용: "t_siz_pansu 신설(2인자 시그니처 유지·pricing.py 무수정·lookup 우선→기하 폴백·11행)+판걸이수 11건 forward 교정. 커밋 fef11a7", 반증: "T-7 '판수=앱 계산' DROP"}

### [DEC_spotwhite_260630] 통합별색 component(개별 CLEAR/GOLD use=N) {verified}
- type: decision
- anchor: t_prc_price_components/COMP_PRINT_SPOT_WHITE_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "COMP_PRINT_SPOT_WHITE_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "화이트인쇄 통합별색·020 SPOT 발현", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- rel: {rel: decided_because, target: component-COMP_PRINT_SPOT_WHITE_S1, note: "5별색×단면양면 통합 1 component(개별 CLEAR/GOLD use=N)·이중과금 가드"}
- props: {일자: "2026-06-30", 내용: "COMP_PRINT_SPOT_WHITE_S1=5별색×단면양면 통합. 020 화이트인쇄 인쇄옵션 0건→SPOT 발현(07-02)"}

### [DEC_wiring_round22_260702] 배선 결함 0 달성(데이터로 닫을 수 있는 분) {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거 문서는 sources)
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "round22 — 데이터 배선 결함 0·잔여 6=아크릴 TBD", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- rel: {rel: decided_because, target: component-COMP_PAPER, note: "배선 수렴 종료척도=결함 0+PRICE≠0"}
- props: {일자: "2026-07-02", 내용: "7세션 전수 수렴. 디지털인쇄 몫 배선 결함 0(고아 0·삭제오염 0). 잔여 6건은 전부 아크릴 *_TBD(실무진 BLOCKED)", 측도: "wiring_scan.py·contribution_sim_scan.py(재측정 시 재실행·새 코드 금지)"}

### [DEC_qty_audit_260702] 전 상품 수량 체계 진단·교정 {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거 문서는 sources)
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 수량규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- rel: {rel: decided_because, target: size-SIZ_000001, note: "사이즈별 수량규칙 49행 충전(판형별 min 상이)"}
- props: {일자: "2026-07-02", 내용: "016 프리미엄엽서 수량 max 2행 교정·사이즈 수량규칙 49행 충전. 제안 min=max(권위,가격표구간). 신규 TRAP 0", 권위: "260702 채택(★스티커 소재 연당가 변경=High 재적재 후속)"}
