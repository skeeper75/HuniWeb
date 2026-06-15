# papergap8_260615 독립 게이트 — round-19 첫 실제 적재 (COMMIT 직전)

> 작성 2026-06-15 · `dbm-validator`(생성자 `dbm-load-builder`와 독립 2-pass) · 라이브 read-only 재실측 + 권위 가격표 openpyxl 직접 대조 + 라이브 BEGIN…ROLLBACK 재실행. 실 COMMIT 안 함.
> 대상 = 디지털 국4절 종이비 GAP **7행**(8→7 정정) · `t_prc_component_prices` · COMP_PAPER · apply_ymd=2026-06-01 · siz=SIZ_000499.

## 종합 verdict — **GO (COMMIT 승인)**

R1~R7 전건 PASS. 생성자 산출(8→7 정정·NOT EXISTS NULL-safe 멱등·round-half-up·단일 세대 배선)이 라이브·엑셀 양면 권위와 독립 재실측에서 전건 일치. **돈-크리티컬 거짓 GO 위험 없음. 생성자 결함 0건.**

| 게이트 | 판정 | 증거 |
|---|:---:|---|
| **R1 멱등성** | PASS | 라이브 BEGIN…ROLLBACK 2-pass 재실행: 49→pass1 `INSERT 0 1`×7=56→pass2 `INSERT 0 0`×7=56(delta 0). 자연키 인덱스 `ux_t_prc_comp_prices_nat_key.indnullsnotdistinct=f`(NULLS DISTINCT) 라이브 확인→ON CONFLICT 미발화 사실→NOT EXISTS NULL-safe 가드가 옳은 선택. |
| **R2 트랜잭션 원자성** | PASS | apply.sql 단일 BEGIN·ON_ERROR_STOP on·mid-COMMIT 없음. COMMIT/ROLLBACK은 apply.sh `-c`로만 주입(기본 ROLLBACK). |
| **R3 실행가능성** | PASS | psql 파싱·실행 정상. reg_dt 컬럼 생략(라이브 column_default=now() 확인·NOT NULL 함정 회피). comp_price_id IDENTITY 비명시(max=4954). |
| **R4 7행 GAP 정당성(8→7)** | PASS | 라이브 실측: 7 mat_cd(096/097/098/099/119/123/124) COMP_PAPER 전건 0(GAP). MAT_000118(클래식스티플270g) 1행 실재(480.00=가격표 R39 I39) → 8→7 정정 옳음(dodge 아님). |
| **R5 단가 권위 일치** | PASS | 가격표 출력소재(IMPORT) R22=71.33·R23=87.795·R24=104.24·R25=115.23·R40=500·R43=245·R44=306 전 7행 저장값 일치. 87.795→87.80 round-half-up=라이브 49 RU 전건 scale≤2 관례(MAT_000073=round(36.875)·scale>2 행 0건). |
| **R6 가격사슬·적용일·동시매칭** | PASS | COMP_PAPER가 formula_components에서 PRF_DGP_A~F 6공식 전부 배선+각 9/2/3/1/3/1 실상품 바인딩→신규 7행 룩업 도달. apply_ymd=2026-06-01 단일 세대(49행 동일·분기 0). 동시매칭 0. |
| **R7 백업 충분성** | PASS | backup.sql=`CREATE TABLE bak_papergap8_260615 AS SELECT * FROM t_prc_component_prices`(3,481행 스냅샷)·롤백 복원 충분. pre_comp_paper baseline 49행 CSV 정합. |

## 부수 검증 (dodge 사냥 — 전건 무혐의)
- **띤또레또 native-size**: 가격표 464×320이나 라이브 COMP_PAPER 49행 전건 SIZ_000499 동형(국4절 정규화 종이비 그릇)·적재값=I열 → SIZ_000499 적재 정당(결함 아님).
- siz_cd=SIZ_000499(316×467) 실재·FK 고아 0.

## COMMIT 전 필수 순서 (잔여 리스크)
1. **backup.sql 선행 필수** — apply.sh commit 모드가 backup 자동 호출 안 함. 운영자가 backup.sql 먼저 실행.
2. **comp_price_id 시퀀스 확인** — last_value ≥ 4955인지 commit 직전 1회(round-5 IDENTITY stale setval 교훈). 충돌 시 ON_ERROR_STOP 즉시 에러(침묵 위험 0).
3. **범위 밖**: 3절(330×660)·PET 투명(315×467) GAP=siz 신규 채번 선결(별 트랙).
