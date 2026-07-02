# 독립 교차검증 요청 — §27 전수 수렴 round21 교정안 (2026-07-02)

당신은 인쇄 자동견적 시스템 가격 DB의 독립 검증자다. 아래 Claude 1차 판정·교정 SQL을 **적대적으로** 검토하라.
당신의 임무 = ① 잘못된 판정(FP를 결함으로/진짜 결함을 FP로) 적발 ② 교정 SQL의 부작용(이중합산·오청구·회귀) 적발 ③ 놓친 결함 발굴.

## 읽을 파일 (읽기전용)
- 라이브 스냅샷: `_workspace/_foundation/live-snapshot/latest/` (t_prc_price_components.csv, t_prc_formula_components.csv, t_prc_component_prices.csv, t_prd_product_processes.csv, t_prd_product_print_options.csv, t_prd_product_materials.csv, t_prd_product_sizes.csv, t_prd_product_price_formulas.csv)
- 교정 SQL: `_workspace/_foundation/batch/wiring/conv21-260702-fix-dryrun.sql`
- 설계 근거: `_workspace/_foundation/batch/wiring/design-foldcard-260701.md`, `design-foamboard-260701.md`

## 엔진 계약(요지)
evaluate_price: 상품→공식(t_prd_product_price_formulas)→배선(t_prc_formula_components)→구성요소(use_dims 차원 선언)→단가행(t_prc_component_prices) 매칭 합산. 단가행의 NULL 차원=와일드카드. 엔진은 del_yn/use_yn 미필터(스캐너·관리 위생 목적). 상품 공정 선택지=t_prd_product_processes, 도수=t_prd_product_print_options(print_opt_cd), 자재축=t_prd_product_materials.

## Claude 1차 판정 (검증 대상)
1. **삭제오염**: COMP_BIND_HC_TWINRING(del_yn=Y, 6/17 삭제)를 PRF_HC_TWINRING_SET(082 셋트, 6/30 신설)가 참조 → del_yn=N 복원이 정답(엔진 미필터라 가격 무변화·위생 교정).
2. **PRD_000110 엽서캘린더 = 진짜 결함**: PRF_DGP_INNER(인쇄+용지) 바인딩인데 product_processes에 PROC_000004(디지털인쇄 base) 미등록 → 인쇄비 영구0(실측 qty100=1,057원). 108/109 탁상캘린더는 7/1에 PROC_000004(Y,-1) 등록됨·110만 누락. 교정=동형 1행 INSERT.
3. **PRD_000020 화이트인쇄엽서 = 진짜 결함**: 인쇄옵션(print_options) 0건 → COMP_PRINT_SPOT_WHITE_S1(use_dims에 print_opt_cd 포함) 영구 미발현. 권위(상품마스터 디지털인쇄 시트)=별색 화이트/클리어 전용·CMYK 없음. SPOT 단가행 proc008×POPT_000001/2 각 53행 실재·판형 국4절(499) 매핑 실재. 교정=021/022 동형 단면/양면 POPT 등록(단면 dflt Y·양면 N).
   - 따라서 020의 COMP_PRINT_DIGITAL_S1 기여0은 **FP**(상품이 CMYK 미제공).
4. **COMP_FOLD_CARD_3H 고아 = 정당 미사용(중복)**: 카드 3단 단가 = 리플렛 COMP_FOLD_LEAF_3FOLD와 48/48 tier verbatim 동일(가격표 대조)·FOLD_LEAF가 이미 배선·029 접지비 정상 경로 실재. 교정=use_yn=N 은퇴(삭제 금지).
5. **COMP_POSTER_FOAMBOARD_BLACK/WHITE 고아·stale = 대체 은퇴**: 폼보드는 7/1 복구로 COMP_POSTER_FOAMBOARD_BOARD(mat×siz)가 가격 경로(실측 4조합 골든 일치 6000/8500/12000/14000). BLACK(siz단독)·WHITE(구 사이즈 174/197/293 키·현 사이즈 315/198라 영구 NO_MATCH) 둘 다 은퇴 + WHITE stale 배선 DELETE.
6. **포맥스 5mm = 주문완전성 갭 → BOARD 동형 확장**: 권위상 두께(3mm/5mm)는 손님 선택. 실무진 등록 자재 4종(MAT_000022/554/23/555) 재사용(mint 0). 신규 COMP_POSTER_FOMEXBOARD_BOARD(mat×siz)+단가 4행(8500/13000/10000/16000 가격표 verbatim)+배선, 구 WHITE3MM 배선 DELETE(이중합산 차단)+구 comp 2종 은퇴. dryrun disjoint 4/4=1 검증됨.
7. **FP 판정 목록**: 017/026/047/049 코팅(COAT_GLOSSY/MATTE) = coat_side_cnt detail 미전달 스캐너 아티팩트(017 실측: detail 전달 시 7,200/14,400 정상 발현). 040 명함 CL 변형 = OPT_000081 클리어 택1 opt_cd 판별(7/1 커밋 골든 4/4 검증). 셋트 094/097/100 = set_selections 미충전 스캐너 한계(§23 전수진단에서 정상 확정).
8. **잔존 BLOCKED(교정 대상 아님)**: 아크릴 *_TBD 빈배선 6건 = 실무진 단가 확인 대기 시그널(임의 단가 금지).

## 질문
Q1. 판정 1~8 중 잘못된 것이 있는가? (각각 AGREE/DISAGREE + 근거)
Q2. 교정 SQL(conv21-260702-fix-dryrun.sql)에 부작용·회귀 위험이 있는가? (특히: 포맥스 BOARD 확장의 이중합산/오청구, 020 양면 POPT 등록의 과대노출, WHITE 배선 DELETE의 회귀)
Q3. 스냅샷에서 Claude가 놓친 배선·단가·차원 결함이 보이는가? (고아/빈배선/삭제오염/미배선 공식 관점)
간결하게: 판정별 AGREE/DISAGREE 표 + 발견 결함 리스트만.
