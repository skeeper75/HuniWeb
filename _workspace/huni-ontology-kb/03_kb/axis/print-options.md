<!-- axis page: E5 print_option — 도수·인쇄방식 노드(마스터 t_prt_print_options). -->
<!-- ★[HARD 도메인] 도수 = print_opt_cd(인쇄옵션)이지 색상코드(clr_cd)가 아니다(팩 §3.3·T-4 함정). -->

# 축: 인쇄옵션 (print_option) — 도수·인쇄방식

도수는 인쇄옵션 코드값이다. 칼라 단/양면 = POPT_000001/002, 흑백 1도 = POPT_000008/009.
별색(spot)은 도수가 아니라 공정(PROC_000007)으로 들어온다(clr_cd=NULL). 상품→도수(R4
`has_print_option`)는 상품 노드(Phase 4)가 건다.

### [printopt-POPT_000001] 단면 {verified}
- type: print_option
- anchor: t_prt_print_options/POPT_000001
- src: {source_file: "live-snapshot/latest/t_prt_print_options.csv", source_locator: "키:POPT_000001", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {print_opt_nm: "단면", print_side: "단면", 도수: "칼라"}

### [printopt-POPT_000002] 양면 {verified}
- type: print_option
- anchor: t_prt_print_options/POPT_000002
- src: {source_file: "live-snapshot/latest/t_prt_print_options.csv", source_locator: "키:POPT_000002", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {print_opt_nm: "양면", print_side: "양면", 도수: "칼라"}

### [printopt-POPT_000008] 단면1도 {verified}
- type: print_option
- anchor: t_prt_print_options/POPT_000008
- src: {source_file: "live-snapshot/latest/t_prt_print_options.csv", source_locator: "키:POPT_000008", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {print_opt_nm: "단면1도", 도수: "흑백"}

### [printopt-POPT_000009] 양면1도 {verified}
- type: print_option
- anchor: t_prt_print_options/POPT_000009
- src: {source_file: "live-snapshot/latest/t_prt_print_options.csv", source_locator: "키:POPT_000009", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {print_opt_nm: "양면1도", 도수: "흑백"}
