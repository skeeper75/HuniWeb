# exec-report.md — RC-2 일반현수막 가공/추가 옵션 바인딩 적재 준비본

> 2026-06-23 · §21 RC-2 파일럿 · dbm-load-builder(load-execution 트랙). 라이브 읽기전용+롤백 DRY-RUN.
> ★COMMIT 안 함 — DRY-RUN까지. 실 적재는 인간 승인 후 별도. 단가 verbatim·DB 영구쓰기 0.
> 권위: rc2-silsa-addon-binding-design.md + 라이브 실측. 엔진: pricing.py evaluate_price.
> 생성자(builder)≠검증자 — 본 준비본 GO 비준은 dbm-validator 독립 게이트(R1~R6).

## 스코프 = 일반현수막(PRD_000138)만 — CPQ 완비 유일 상품
공식 `PRF_POSTER_BANNER_N`(라이브 바인딩 확인). 가공그룹(OPT_000003)·추가그룹(OPT_000004) 옵션 완비.

## 대상 comp 6개 (배선 종단)
| comp | 충전 use_dims | 단가행 충전(verbatim) | 바인딩 |
|---|---|---|---|
| PUNCH_4(타공) | 유지 `[proc_cd,min_qty,proc_grp:PROC_000104]` | 유지(PROC_000105+타공수 3000/4000/8000) | addtn_yn=Y·seq2 충전 |
| CUTEDGE(열재단) | `[opt_cd, opt_grp:OPT_000003]` | opt_cd=OPV_000006 (3000) | 신규 seq3 |
| DTAPE(양면테입) | `[opt_cd, opt_grp:OPT_000003]` | opt_cd=OPV_000010 (3000) | 신규 seq4 |
| BONGSEW(봉미싱) | `[opt_cd, opt_grp:OPT_000003]` | opt_cd=OPV_000011 (4000) | 신규 seq5 |
| QBANG(큐방) | `[opt_cd, opt_grp:OPT_000004]`(018→004 정정) | opt_cd=OPV_000013 (3000) | 신규 seq6 |
| STRING(끈) | `[opt_cd, opt_grp:OPT_000004]` | opt_cd=OPV_000014 (4000) | 신규 seq7 |

- use_dims 충전: **5건**(PUNCH_4 유지). 단가행 opt_cd 충전: **5건**. 공식 바인딩: **6건**(PUNCH_4 포함).
- comp는 전부 상품 1:1 전용(공유 0)·각 comp 자기 상품 공식 1개에만 바인딩.

## CONFIRM-A (타공 proc_cd) — 선택·근거
**실측 발견**: 타공 option_item은 `ref_dim_cd=OPT_REF_DIM.04 → ref_key1=PROC_000104` + `dtl_opt={타공수:N}`.
`_opt_maps`(price_views:1390)는 **dtl_opt를 무시하고 ref_key1(PROC_000104)만** procs에 담음. 단가행은
PROC_000105(하위 실공정)+dim_vals 타공수. PROC_000105 upr=PROC_000104(현수막타공 상·하위).

**선택 = 단가행 proc_cd=PROC_000105 유지**(설계 doc CONFIRM-A 방향). 근거:
- 시뮬레이터 경로(§21 초점)는 _opt_maps 미동작·호출자가 procs 직접 구성 → procs=[{proc_cd:**PROC_000105**, detail:{타공수:N}}] 전송 시 정확 매칭(재계산 ⓑ 입증).
- 단가행 PROC_000105는 하위 실공정으로 의미상 정확·이미 verbatim 적재됨(미터치).
- ★위젯 경로(_opt_maps 104만+dtl_opt 누락)는 데이터로 못 고침 → **코드 트랙 BLOCKED**(price_views 환원에 dtl_opt+하위공정 반영 필요·§21 범위 밖). 모호 아님·정지 불요.

## DRY-RUN 결과 (라이브 BEGIN…ROLLBACK·COMMIT 안 함)
- PASS1: UPDATE 10(use_dims 5·opt_cd 5) + UPSERT 6 = **0 제약위반**.
- PASS2(멱등): UPDATE 0·INSERT 0 = **2회차 0행(멱등 입증)**.
- 단가 verbatim 불변·ROLLBACK 완료(라이브 미변경). 상세=`dryrun-log.md`.

## evaluate_price 종단 재계산 (엔진 순수함수 verbatim·`evaluate-trace.md`)
- ⓐ 미선택 = **0가산**(현재 결함 17000 always-add + PUNCH_4 duplicate ERR 해소 입증).
- ⓑ 타공4/6/8 = **3000/4000/8000** 정확. ⓒ 끈/봉미싱/큐방/열재단/양면테입 = 각 단가만(4000/4000/3000/3000/3000).
- ⓓ 타공4+끈 동시 = **7000** 정확. **ERR_AMBIGUOUS/DUPLICATE 0**·단가 verbatim 전부 일치.

## BLOCKED (파일럿 제외·정지 말고 나머지 진행)
| 항목 | 사유 | 트랙 |
|---|---|---|
| 각목 LE/GT (4000+8000=12000 이중) | CONFIRM-4: CPQ "각목(세로)/각목(가로)" ≠ 권위 "900이하/900초과"·의미축 상이 | 실무진 컨펌 후 데이터 |
| opt 경로 가공+추가 동시선택 | selections opt_cd 단일키 → 그룹별 selection 분리 필요 | 코드 트랙(price_views) |
| 위젯 경로 타공 매칭 | _opt_maps 104만·dtl_opt 누락 환원 | 코드 트랙(price_views) |
| 나머지 6상품(메쉬·PET·캔버스·린넨·족자) | CPQ 옵션 미등록 | CPQ 선행 후 후속 RC |

## 산출 파일
- `mapping.csv`·`gen_load_sql.py`(생성기) → `01_use_dims.sql`·`02_opt_fill.sql`·`03_formula_components.sql`·`apply.sql`
- `apply.sh`(기본 DRY-RUN)·`backup.sql`(라이브 현재값 롤백)·`load.provenance.csv`
- `verbatim-guard.md`·`dryrun-log.md`·`evaluate-trace.md`(+`evaluate_trace.py`·`_pricing_pure.py`)

## 판정
적재 준비본 GO 후보(R1 멱등·R2 원자·R3 실행·R5 제약위반0·종단 정확 입증). **COMMIT 대기**(인간 승인).
dbm-validator 독립 R1~R6 게이트 후 인간 승인 시 `./apply.sh commit`. 단가 verbatim·DB 미적재.
