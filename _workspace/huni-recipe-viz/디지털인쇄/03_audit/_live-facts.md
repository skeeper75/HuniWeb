# 디지털인쇄 연결검증 — 라이브 t_* 실측 근거 (Claude 큐레이션·2026-06-18 읽기전용 SELECT)

> 이 문서 = codex의 사실 근거. 모든 수치는 라이브 psql 실측(추정 0). codex는 라이브 접속 없음.
> 권위 = 상품마스터 260610 + 인쇄상품 가격표 260527(디지털인쇄비 매트릭스: 도수×면×출력매수).

## L1. 상품→공식 바인딩 (PRD_000016~050) — 레시피와 일치 확인
바인딩 존재 21상품 / 미바인딩 10상품(견적불가):
- 미바인딩(frm_cd NULL): PRD_000019 투명엽서, 000030 지그재그엽서, 000034 펄명함, 000035 모양명함, 000036 미니모양명함, 000037 오리지널박명함, 000038 형압명함, 000039 투명명함, 000040 화이트인쇄명함, 000049 와이드접지리플렛.
- 바인딩 존재: 016~018·020~029·031~033·041~048·050 (PRF_DGP_A/B/C/D/E·PHOTOCARD/NAMECARD_FIXED·FOLD_SUM·ENV_MAKING).

## L2. 가격공식↔구성요소 배선 (formula_components, 실측)
전 comp prc_typ_cd=PRICE_TYPE.01(단가형 ×수량). use_yn=Y.

### PRF_DGP_A (016·017·018·020·021·022·026·041·042) — 배선 9 comp
| disp_seq | comp_cd | use_dims | addtn_yn | del_yn(comp) |
|---|---|---|---|---|
| (NULL) | COMP_PRINT_DIGITAL_S1 | proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001 | (NULL) | N |
| 3 | COMP_PRINT_SPOT_WHITE_S1 | plt_siz_cd, proc_cd, print_opt_cd, min_qty, proc_grp:PROC_000007 | Y | N |
| 13 | COMP_COAT_GLOSSY | siz_cd, coat_side_cnt, min_qty | Y | N |
| 14 | COMP_COAT_MATTE | siz_cd, coat_side_cnt, min_qty | Y | N |
| 15 | COMP_PAPER | siz_cd, mat_cd | Y | N |
| 16 | COMP_PP_CREASE_1L | proc_cd, min_qty, proc_grp:PROC_000029 | Y | N |
| 19 | COMP_PP_PERF_1L | proc_cd, min_qty, proc_grp:PROC_000030 | Y | N |
| 22 | COMP_PP_VARTEXT_1EA | proc_cd, min_qty, proc_grp:PROC_000085 | Y | N |
| 25 | COMP_PP_VARIMG_1EA | proc_cd, min_qty, proc_grp:PROC_000085 | Y | N |
★ COMP_PRINT_DIGITAL_S2(양면키)는 PRF_DGP_A에 **미배선**(레시피 F-2 "S1+S2 이중배선"은 PRF_DGP_A에선 부정 — S1만 배선). COMP_PP_CORNER(귀돌이)·CREASE_2L/3L·PERF 형제·VARTEXT/IMG_2EA/3EA 미배선.

### PRF_DGP_B (023 모양엽서·046 라벨택): S1·S2·PAPER·CUT_FULL_DIECUT.  ★COMP_PRINT_DIGITAL_S2 del_yn=Y(논리삭제됐으나 배선 잔존).
### PRF_DGP_C (043·044·045 배경지/헤더택): S1·S2(del_yn=Y)·PAPER·FOLD_CARD_2H·CUT_PERF_1H6.
### PRF_DGP_D (047 소량전단지): S1(disp_seq 0)·COAT_GLOSSY·MATTE·PAPER·CUT_PERF_1H6·CREASE_1L·PERF_1L·VARTEXT·VARIMG·CORNER_RIGHT. ★S2 미배선.
### PRF_DGP_E (027·028·029 접지카드): S1(disp_seq 0)·COAT_GLOSSY·MATTE·PAPER·FOLD_LEAF_HALF/3FOLD/4ACC/4GATE·CUT_PERF_1H6. ★S2 미배선.
### PRF_DGP_F (썬캡 미출시): PAPER·S2·CUT_FULL_DIECUT. ★S1 미배선(S2만).
### PRF_FOLD_SUM (048 접지리플렛): **COMP_FOLD_CARD_2H 1개만 배선**. 디지털인쇄비·용지비·코팅·접지(리플렛) 전무 → 견적시 접지비만 나옴 = 사실상 견적불가.
### PRF_ENV_MAKING (050 봉투제작): COMP_ENV_MAKING(siz_cd, mat_cd, min_qty) 1개. 완제품가형. 정상.
### PRF_PHOTOCARD_FIXED (024·025): COMP_PHOTOCARD_SET·CLEAR_SET (siz_cd, bdl_qty, min_qty). 완제품가.
### PRF_NAMECARD_FIXED (031·032·033): COMP_NAMECARD_STD_S1·S2 (mat_cd, min_qty). 완제품가.

## L3. 단가행 충전 (component_prices 실측 — 견적 결과값 존재 검사)
| comp_cd | rows | n_print_opt | n_plt | n_siz | n_clr | n_minqty | 비고 |
|---|---|---|---|---|---|---|---|
| COMP_PRINT_DIGITAL_S1 | 212 | 2 | 2 | 0 | 0 | 53 | print_opt=POPT_000001/2(=면 단/양)만. plt_siz=SIZ_000077/000499 2종. **도수(colrcnt) 차원 없음** |
| COMP_PRINT_DIGITAL_S2 | 212 | 2 | 0 | 2 | 0 | 53 | siz_cd 키. 도수 차원 없음 |
| COMP_PRINT_SPOT_WHITE_S1 | 530 | 2 | 1 | 0 | 0 | 53 | proc_cd 5종(별색 5종=공정)·clr_cd 0(NULL). 별색 경로 실재 |
| COMP_PAPER | 56 | 0 | 0 | 1 | 0 | 1 | mat_cd 56종·flat 절가(수량차원 없음·정상) |
| COMP_COAT_GLOSSY/MATTE | 92 | - | - | 2 | - | 23 | 정상 |
| COMP_CUT_FULL_DIECUT | 36 | - | - | 1 | - | 36 | 정상 |
| COMP_FOLD_CARD_2H | 48 | - | - | 0 | - | 48 | min_qty만 |
| COMP_FOLD_LEAF_HALF/3FOLD/4ACC/4GATE | 48 each | - | - | 0 | - | 48 | min_qty만 |
| COMP_CUT_PERF_1H6 | 18 | - | - | 0 | - | 9 | 정상 |
| COMP_PP_CORNER_RIGHT | 18 | - | - | 0 | - | 9 | |
| COMP_PP_CREASE_1L / PERF_1L | 30 / 30 | - | - | 0 | - | 10 | |
| COMP_PP_VARTEXT_1EA / VARIMG_1EA | 69 / 69 | - | - | 0 | - | 23 | |
| COMP_ENV_MAKING | 40 | - | - | 4 | - | 5 | siz×mat×qty 실재·정상 |
| COMP_PHOTOCARD_SET / CLEAR_SET | 1 / 1 | - | - | 1 | - | 1 | SIZ_000012·bdl_qty 20·단일행(6000/8500) |
| COMP_NAMECARD_STD_S1 / S2 | 2 / 2 | - | - | 0 | - | 1 | **mat_cd 2종만(MAT_000074·MAT_000082)·min_qty 100 단일** |

## L4. ★F-1 도수/면 충돌 — 라이브 2-fact 입증
- 상품층 `t_prd_product_print_options`: print_opt_cd=POPT_000001(단면)·POPT_000002(양면) = **면**. 도수는 front_colrcnt_cd/back_colrcnt_cd(예 CLR_000005 칼라)로 별도 보유.
- 가격층 S1/S2 use_dims = print_opt_cd(=면) + plt_siz_cd/siz_cd + min_qty. **colrcnt(도수) 차원 없음.**
- ∴ 권위 가격표(디지털인쇄비)는 흑백/칼라 단가가 다른데(예 칼라단 qty1=4000 vs 흑백단 3000), 라이브 S1 단면(POPT_000001) qty1=3500 **단일값** → 도수 선택이 가격에 반영 불가(축 소실). [라이브-결함 CONFIRMED]
- POPT_000003~007(풀빼다·배면양면·투명테두리·양면9도·단면7도) 추가 존재하나 S1/S2 단가행엔 POPT_000001/2만 충전.

## L5. 별색 형제(021 핑크별색·022 금은별색) — SPOT 경로
- 021/022 print_options: 단면/양면(POPT_000001/2), front_colrcnt=CLR_000005. PRF_DGP_A 바인딩 → COMP_PRINT_SPOT_WHITE_S1 배선됨(proc_cd 5종=별색공정).
- 레시피 시드 "별색 clr_cd NULL=경로 없음"은 **부분 반증**: 별색 경로는 proc_cd로 실재(clr_cd가 아니라 proc_cd가 별색종류 운반). 단 SPOT comp가 어느 별색 proc를 021/022에 매칭하는지(상품별 proc 바인딩)는 제약/옵션층 검사 필요.
