# 명함특수 6 전용공식 설계 — 스코프 브리프 (생성가 입력)

작성 2026-06-27 (main 실측) · 가격만결손 51 중 WIRE_BIND 6(명함특수). 목표 = 전용 comp·단가행이 라이브 실재하는 6 특수명함에 **전용 가격공식(PRF) 정의 + 배선 + 바인딩**을 설계해 견적가능화. **신규 단가 민팅 0(comp/단가행 verbatim 재사용)·DB 미적재(생성)**. 권위=상품마스터260610+가격표260527. SOT=[[product-type-classification-sot]].

## 대상 6 (전부 nonspec_yn='N'·가격공식 바인딩 0)
| prd | 명 | n_mat | n_dosu | n_siz | 전용 comp(라이브 실재·미배선) |
|---|---|---|---|---|---|
| 034 | 펄명함 | 4 | 2 | 1 | COMP_NAMECARD_PEARL_S1/S2 (use_dims=[mat_cd,min_qty]·각 2행) |
| 035 | 모양명함 | 1 | 2 | 1 | COMP_NAMECARD_SHAPE_S1/S2 ([siz_cd,min_qty]·각 1행) |
| 036 | 미니모양명함 | 1 | 2 | 1 | COMP_NAMECARD_MINISHAPE_S1/S2 ([siz_cd,min_qty]·각 1행) |
| 037 | 오리지널박명함 | 5 | 0 | 1 | FOIL_S1_STD/HOLO·S2_STD/HOLO ([min_qty]·각 9행) + FOIL_SETUP_S1_STD/S2_STD(동판셋업비) |
| 039 | 투명명함 | 1 | 1 | 1 | COMP_NAMECARD_CLEAR_S1 ([min_qty]·1행) |
| 040 | 화이트인쇄명함 | 4 | 0 | 1 | WHITE_S1W_CL/NOCL·S2W_CL/NOCL ([mat_cd,min_qty]·각 1행) |

## 기준선 = PRF_NAMECARD_FIXED (031~033 작동·검증된 패턴)
- formula_components: COMP_NAMECARD_STD_S1(disp_seq1·addtn_yn=Y) + STD_S2(disp_seq2·addtn_yn=Y).
- STD comp use_dims=[mat_cd,min_qty,**print_opt_cd**]. 단가행이 print_opt_cd=POPT_000001(단면)/POPT_000002(양면)로 분리 → **면 선택이 S1/S2를 자동 라우팅**(둘 다 배선돼도 단면 선택 시 S2 행 미매칭 → 이중합산 0).

## ★핵심 설계 난제 (반드시 해소)
1. **S1/S2 이중합산**: 특수 comp들의 use_dims에 **print_opt_cd 없음**(PEARL/WHITE=[mat_cd,min_qty]·SHAPE/MINISHAPE=[siz_cd,min_qty]·FOIL/CLEAR=[min_qty]). S1·S2 모두 배선+addtn_yn=Y면 같은 (mat/siz/qty)로 **양쪽 동시 매칭 → S1+S2 합산 과청구**(기존 책자/디지털 S1/S2 구조결함과 동형·CLAUDE.md §23 핸드오프 "S1/S2 이중합산 🔴"). 해법 후보: ① 특수 comp use_dims에 print_opt_cd 추가 + 단가행에 면 태깅(단, 단가행 verbatim 불변 원칙과 충돌 — 면 정보가 단가행에 이미 있나 확인) ② 면 선택을 opt_cd/option_group으로 라우팅 ③ side를 dim_vals/배타선택으로. **권위 가격표에서 단면/양면이 별 행인지 한 행인지 먼저 확인.**
2. **037 박·040 화이트 = 도수 0건**: 면(단면/양면) 선택 경로가 print_opt 아님 → option_group/opt_cd 매핑 규명. 037은 박종류(STD/홀로그램) + 동판셋업비(addtn) 추가 합산 구조. 040은 코팅(CL/NOCL) 변형.
3. **모양/미니모양 = siz_cd 차원**: 모양명함은 사이즈별 단가 → siz_cd 정확매칭(아크릴 면적버그와 무관·siz_cd는 NON_QTY_DIMS 정확매칭이라 안전).

## 산출 요구 (생성가)
1. `namecard-special-design.md` — 6 × {전용 PRF 정의(frm_cd·frm_nm)·배선 comp(disp_seq·addtn_yn)·면/박/코팅 라우팅 해법·이중합산 회피 근거·골든 케이스(권위 verbatim 단가로 기대값)}.
2. `namecard-special-fix.sql`(+backup/undo/dryrun) — PRF INSERT + formula_components 배선 INSERT + 바인딩 INSERT. 멱등(NOT EXISTS/ON CONFLICT)·단일 트랜잭션·DO block. **단가행은 건드리지 않음**(이미 실재·verbatim). use_dims 변경이 필요하면 별도 명시(돈크리티컬·인간 승인).
3. 라우팅이 데이터로 안 풀리고 코드 의존이면 명확히 분리(§6 라우팅·아크릴 CODEBUG 선례처럼).

## 규칙 [HARD]
- 라이브 **읽기전용 SELECT만**. `.env.local RAILWAY_DB_*`: `set -a; . ./.env.local; set +a; export PGHOST=$RAILWAY_DB_HOST ...`. 비밀값 비노출.
- 단가/공식명 verbatim·날조 0. 가격연결 기초데이터 **삭제 금지**(이름수정/추가는 가능).
- ★이중합산 0 입증이 GO 필수조건(골든 재계산으로). search-before-mint(comp 재사용·신규 mint 0 목표).
- 생성≠검증: 이 산출은 생성. 게이트가 골든 재계산·이중합산·use_dims 정합 독립 재실측.
