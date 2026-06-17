# 실사 round-23 Phase C — 롤백전용 라이브 DRY-RUN 리포트 (R1~R6)

> 실행 2026-06-17 · `psql` Railway `railway` read-only 트랜잭션(`BEGIN … ROLLBACK`). 비밀값 비노출.
> 실 COMMIT 0 입증. 생성자(load-builder) 산출 — GO 판정은 dbm-validator 독립 게이트.

## R1 — 멱등 INSERT/가드 (NOT EXISTS / 조건부 UPDATE / proc 필터 DELETE)
- 모든 INSERT = NOT EXISTS 가드, UPDATE = 조건부(`WHERE 현재값<>목표값`), DELETE = 결정적 조건. ON CONFLICT 대신 NOT EXISTS(자연키 인덱스 NULLS DISTINCT 함정 회피).

## R2 — 단일 트랜잭션 + FK 위상정렬 + ROLLBACK 기본
- `apply.sql`: `BEGIN; \i U1 → U3 → U4 → U5 → U6 → U8`. `ON_ERROR_STOP on`. 트랜잭션 종료(ROLLBACK 기본 / COMMIT는 `apply.sh --commit`)는 로더가 주입 — apply.sql 자체 COMMIT 0.
- FK 순서: U1(siz 부모) → U3/U4(comp·배선) → U5(단가행 삭제) → U6(공식→배선→바인딩) → U8.

## R3 — 로더 안전 (rollback DRY-RUN 기본·비밀값 비노출)
- `apply.sh`: `.env.local` source, `PGPASSWORD` env로만 전달(echo 0). 기본 모드 = DRY-RUN(ROLLBACK). `--commit`에서만 COMMIT. U5 백업 SELECT 항상 선행.

## R4 — PASS 1 실측 (전 단위 영향행수 · 단일 ROLLBACK tx)

```
BEGIN
INSERT 0 106      U1 신규 좌표 siz
UPDATE 6          U3 레거시 6 comp use_yn=N
INSERT 0 0        U3 정본 배선 보강(이미 존재)
DELETE 12         U3 레거시 배선 제거(CREASE/VARTEXT/VARIMG 2L·3L/2EA·3EA × PRF_DGP_A+D)
UPDATE 1          U4 PERF_1L prc_typ .02→.01
UPDATE 30         U4 PERF_1L opt_cd→dim_vals.줄수 재정규화
UPDATE 2          U4 PERF 2L/3L use_yn=N
INSERT 0 0        U4 정본 배선 보강(이미 존재)
DELETE 4          U4 레거시 PERF 배선 제거
DELETE 424        U5 WHITE_S1 잉여 4색 proc 단가행
INSERT 0 28       U6 유형별 공식 28
INSERT 0 28       U6 공식→자기 comp 배선 28
DELETE 28         U6 구 PRF_POSTER_FIXED 바인딩 28
INSERT 0 28       U6 신규 바인딩 28
UPDATE 1 ×15      U8 가독성 정비 15 comp
ROLLBACK
```

## R5 — PASS 2 멱등 (2회 적용 · SECOND 블록 전건 0)
- 동일 tx 내 전 SQL 2회 적용 → **SECOND 블록 모든 DML = 0**:
  `INSERT 0 0 · UPDATE 0 · DELETE 0`(전 14 DML + UPDATE 0 ×15). **2-pass delta 0 입증.**

## R6 — 무결성 (post-state, 같은 ROLLBACK tx)
```
orphan_fc_comp        = 0   (formula_components.comp_cd → price_components 고아)
orphan_fc_frm         = 0   (formula_components.frm_cd → price_formulas 고아)
orphan_binding_frm    = 0   (product_price_formulas.frm_cd → price_formulas 고아)
orphan_binding_prd    = 0   (product_price_formulas.prd_cd → products 고아)
orphan_cp_siz         = 0   (component_prices.siz_cd → t_siz_sizes 고아)
U1_new_siz            = 106
U4_perf1L_prc_typ     = PRICE_TYPE.01
U5_white_final        = 106  (proc 1종=PROC_000008 화이트 · print_opt 2종 보존=단가티어 무손실)
U6_28prod_own_formula = 28   · U6_fixed_bindings_left = 0 · U6_27prod_resolvable = 28
```
- 제약 위반 0(NOT NULL apply_bgn_ymd 충족·PK 충돌 해소). **COMMIT 0**(트랜잭션 ROLLBACK 종료).

## 누설 0 검증 (post-ROLLBACK 라이브 재측정)
```
new_siz_count=0(기대0) · white_s1=530(기대530) · perf1L_prc_typ=PRICE_TYPE.02(기대.02)
fixed_bindings=28(기대28) · new_poster_formulas=0(기대0) · crease_2L use_yn=Y(기대Y)
```
→ DRY-RUN 후 라이브 사전상태 그대로. **라이브 무변경 입증.**

## 종합
- R1~R6 전건 통과(생성자 자체 측정). 영향: INSERT 162 · UPDATE 54 · DELETE 468 · COMMIT 0.
- 실 COMMIT·U5 hard-delete·U2/U7 BLOCKED 해소는 인간 승인. GO 판정은 dbm-validator.
