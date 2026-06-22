# validation-verdict.md — 019 묶음 교정(A5-plate + A2-bind) R1~R6 독립 게이트

> 검증자: `dbm-validator`(생성≠검증). 라이브 `railway` 직접 read-only 재실측 + 롤백전용 DRY-RUN(BEGIN…ROLLBACK).
> 일시: 2026-06-22. **NEVER COMMIT** — 본 검증은 쓰기 0·커밋 0. 생성자(load-builder) 주장은 인용이 아닌 **직접 재실측**으로 재현·검증.
> 대상: `apply.sql`(STEP1 plate UPDATE SIZ_000522→SIZ_000499 / STEP2 bind UPSERT PRD_000019↔PRF_DGP_A).
> 권위: 사용자 확정 — 019 출력판형 정답=316x467(SIZ_000499), SIZ_000522(315x467)=오적재.

## 종합 판정: **GO** (R1~R6 전건 PASS · 실 COMMIT 안전)

| 게이트 | 판정 | 직접 재실측 증거 |
|---|:---:|---|
| R1 타입/도메인 | **PASS** | apply_bgn_ymd='2026-06-01' len=10 ≤ varchar(10); siz_cd/frm_cd/otyp 전부 varchar(50) 내; dflt_plt_yn 보존(UPDATE 미접근). 코드값 정합. |
| R2 제약(NOT NULL/CHECK) | **PASS** | 양 테이블 `reg_dt` = NOT NULL **DEFAULT now()** → INSERT 미지정 안전(round-5 reg_dt 함정 회피 확인). frm_cd NOT NULL → SQL이 'PRF_DGP_A' 명시. NULL 위반 0. |
| R3 FK | **PASS** | 부모 전수 실재 — SIZ_000499(316x467·use_yn=Y·del_yn=N)·OUTPUT_PAPER_TYPE.01(t_cod_base_codes 1건)·PRF_DGP_A(use_yn=Y)·PRD_000019(del_yn=N·use_yn=Y). FK 위반 0. |
| R4 PK/멱등 | **PASS** | plate PK=(prd_cd,siz_cd)·bind PK=(prd_cd,apply_bgn_ymd) 스키마 확인. 019에 SIZ_000499 행 부재(has_499=0)→충돌 없음. **2회 재실행 델타 0**(STEP1 0행·STEP2 0행, 라이브 DRY-RUN PASS2 직접 재현). |
| R5 DRY-RUN 트랜잭션 | **PASS** | BEGIN…ROLLBACK 직접 재실행. PASS1: UPDATE 1·INSERT 1. ROLLBACK 후 fresh read: **still_522=1·has_499=0·bind=0** → 라이브 불변 확인(아무것도 커밋 안 됨). |
| R6 목표 달성(가격 환원) | **PASS** | 0원→정상 전환 **독립 재계산 77,064원** 재현(아래). 형제 016/017/018 경로 동치 확인. |

## R6 — 019 가격 독립 재계산 (생성자 77,064 주장을 검증자가 직접 재현)

**단가행 매칭(라이브 verbatim, plt_siz_cd 차원):**

| 구성요소 | SIZ_000522(오적재 전) | SIZ_000499(정정 후) |
|---|:---:|:---:|
| COMP_PRINT_DIGITAL_S1 tiers | **0** | **106** |
| COMP_PAPER rows | **0** | **56** |

→ SIZ_000522는 전 구성요소 no-match(0행) → 합계 0 → 0원 차단. 정정으로 SIZ_000499 단가행 환원.

**골든 재계산(plt=SIZ_000499·mat=MAT_000074·단면 POPT_000001·무광1면·qty=100, subtotal=unit×qty):**

| 구성요소 | unit_price(라이브) | qty | subtotal |
|---|---:|---:|---:|
| COMP_PRINT_DIGITAL_S1 (min_qty=100·POPT_000001) | 200.00 | 100 | 20,000 |
| COMP_PAPER (MAT_000074·min_qty=1) | 70.64 | 100 | 7,064 |
| COMP_COAT_MATTE (1면·min_qty=100) | 500.00 | 100 | 50,000 |
| **Σ** | | | **77,064** |

→ **검증자 독립 재계산 = 77,064원** = 생성자 주장과 일치. 비-0 전환 입증. 단가값 전부 라이브 SELECT verbatim·날조 0.

**형제 경로 동치:** 정정 후 PRD_000016/017/018/019 모두 plt_siz_cd=SIZ_000499·COMP_PRINT 106 tier 동일 경로 — 라이브 DRY-RUN 내 직접 SELECT로 4건 확인.

## 추가 독립 안전 확인

- **공유 마스터 무수정 [HARD PASS]:** apply.sql write 문 2건 전수 = `t_prd_product_plate_sizes`(019 1행 UPDATE)·`t_prd_product_price_formulas`(019 1행 INSERT). t_siz_sizes·t_prc_*(공식/comp/단가행) 접근 **0건**(grep + 라이브 미접근 확인). SIZ_000522/499 마스터 자체 무수정(UPDATE는 junction의 siz_cd 포인터만 변경).
- **신규 mint 0:** SIZ_000499·PRF_DGP_A·OUTPUT_PAPER_TYPE.01·단가행 전부 사전 실재.
- **공유 사용처 미접근:** SIZ_000522는 019/025/039 공유 — WHERE가 `prd_cd='PRD_000019'`로 스코프되어 025/039 junction 행 미접근(이번 범위 019 1행만). 라이브 DRY-RUN 내 025/039 불변(WHERE 매칭 안 됨).
- **자식 FK cascade 위험 0:** t_prd_product_plate_sizes 참조 자식 FK 0건 → siz_cd 키 변경 안전.
- **트랜잭션 원자성:** apply.sh 기본 ROLLBACK·단일 BEGIN…ROLLBACK·ON_ERROR_STOP=1·중간 COMMIT 없음·PGPASSWORD 미노출.

## COMMIT 안전성

**실 COMMIT 안전.** R1~R6 전건 PASS·멱등(재실행 델타 0)·원자(all-or-nothing)·공유 마스터 무손상·신규 mint 0·롤백 무손상 입증. `./apply.sh --commit`은 **사용자 최종 승인 후에만** 실행(인간 게이트 유지). 본 검증은 커밋 0.

> minor(비차단): apply.sh 검증 SELECT(line25)가 `output_paper_typ_cd='OUTPUT_PAPER_TYPE.01'`로만 필터 — 표시용이며 교정 정확성에 무영향. 권장: prd_cd+siz_cd로 좁힘.
