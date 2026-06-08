# DRY-RUN 계획 — D-WIRE 포스터 가격공식 재모델 (plan only, 미실행)

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07 |
| 상태 | **DRY-RUN 계획만**(plan). 라이브 실행 안 함(HARD: no live DRY-RUN exec). |
| 권위 | `00_schema/price-engine-ddl.md` (FK·C-1~C-9) + 라이브 read-only 실측 |

> [HARD] 본 트랙은 **라이브 쓰기 0건**(INSERT/UPDATE/DELETE/DDL/COMMIT 미실행). DRY-RUN(`BEGIN; … ROLLBACK;`) **실행조차 하지 않는다** — 아래는 인간 승인 후 실행할 **계획**일 뿐. FK 부모 선존재·충돌·컬럼 정합은 read-only SELECT 로 사전 확인 완료(증거 §1).

---

## 1. 설계자 사전점검 (read-only 실측 증거 — 실행 전 확인 완료)

| 점검 | 방법 | 결과 |
|------|------|------|
| 신규 28 frm_cd 충돌 | `SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF\_POSTER\_%' ESCAPE '\' AND frm_cd<>'PRF_POSTER_FIXED'` | **0행**(충돌 없음) |
| FRM_TYPE.02 부모 | `SELECT cod_cd FROM t_cod_base_codes WHERE cod_cd='FRM_TYPE.02'` | **존재** |
| 30 comp_cd 부모 | `SELECT count(*) FROM t_prc_price_components WHERE comp_cd IN (30종)` | **30**(전건 존재) |
| 28 prd_cd 부모 | `SELECT count(*) FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145'` | **28**(전건 존재) |
| 컬럼·DEFAULT | `information_schema.columns` 3테이블 | reg_dt NOT NULL DEFAULT now() 확인 → INSERT 목록 omit |
| 기존 바인딩 수 | 28상품 각 `n_total_bindings` | 전건 **1**(DELETE 후 0, INSERT 후 1 — 누락/중복 0) |

---

## 2. FK 위상정렬 적재순서 (load.sql 단계)

```
[단계 0] FK 부모 선존재 assert (DO $$ … RAISE EXCEPTION)
            t_cod_base_codes(FRM_TYPE.02), t_prd_products(28)
[단계 1] t_prc_price_formulas      INSERT 28  (frm_typ_cd FK → FRM_TYPE.02 선존재)
[단계 2] t_prc_formula_components  INSERT 30  (frm_cd FK → 단계1, comp_cd FK → 라이브 선존재)
[단계 3] t_prd_product_price_formulas
            DELETE (prd, PRF_POSTER_FIXED) 28   (멱등 — 없으면 0행)
            INSERT (prd, PRF_POSTER_<X>)   28   (frm_cd FK → 단계1 선존재)
[단계 4] t_prc_price_formulas      UPDATE use_yn='N' (PRF_POSTER_FIXED 은퇴)
[검증]   DO $$ 사슬 무결성 (28 배선완료·FIXED 0바인딩) RAISE EXCEPTION 시 전체 abort
```

### FK 안전성 증명 (rebind 한 건씩)
- **단계1이 단계3보다 먼저** → `product_price_formulas.frm_cd` FK(→`price_formulas.frm_cd`) 충족. 새 공식이 존재한 뒤에만 새 바인딩 INSERT.
- **DELETE-old 와 INSERT-new 는 PK 독립**: 같은 prd_cd 이나 frm_cd 가 다름(`PRF_POSTER_FIXED` vs `PRF_POSTER_<X>`) → PK `(prd_cd, frm_cd)` 충돌 없음. DELETE 가 INSERT 의 선행조건 아님(서로 다른 행).
- **DELETE 의 FK 영향 0**: `product_price_formulas` 는 자식이 없음(말단 바인딩). DELETE 가 깰 하위 FK 없음.
- **단계4 UPDATE 안전**: `PRF_POSTER_FIXED` 의 use_yn 변경은 FK 무관(코드값 아닌 플래그). 배선·바인딩 미삭제(FK RESTRICT 회피).

---

## 3. DRY-RUN 게이트 R1~R6 (실행 시 통과해야 할 기준 — 계획)

| 게이트 | 기준 | 본 트랙 사전판정(설계 근거) |
|------|------|------|
| **R1 멱등성** | 2-pass 재실행 시 2회차 행변경 0 | 전 INSERT `WHERE NOT EXISTS`; DELETE 멱등(2회차 대상 0); UPDATE `IS DISTINCT FROM`. → **PASS 예상** |
| **R2 원자성** | 임의 문 실패 시 전체 롤백 | ON_ERROR_STOP=1 + 단일 tx(apply.sh BEGIN/ROLLBACK 주입). → **PASS 예상** |
| **R3 제약위반 0** | NOT NULL/CHECK/FK/PK/UNIQUE 위반 0 | frm_typ_cd NOT NULL=FRM_TYPE.02; use_yn CHECK 'Y'/'N'; addtn_yn CHECK Y/N; FK 30comp·28prd·FRM_TYPE.02 선존재; PK(frm_cd)·(frm_cd,comp_cd)·(prd_cd,frm_cd) CSV 내 중복 0(assert 완료). → **PASS 예상** |
| **R4 FK 고아 0** | 적재행의 FK 부모 전건 존재 | 단계0 assert + per-INSERT EXISTS 가드. → **PASS 예상** |
| **R5 COMMIT 0** | DRY-RUN 은 ROLLBACK 만 | apply.sh 기본 dryrun=ROLLBACK. 본 하네스 COMMIT 미호출. → **PASS(불변)** |
| **R6 사슬 무결성**(트랙특화) | 적재 후 28상품 전부 자기 공식+자기 comp 배선; PRF_POSTER_FIXED 0바인딩 | load.sql 말미 검증 DO 블록이 같은 tx 에서 assert(미충족 시 RAISE→전체 abort). → **PASS 예상** |

---

## 4. 실행 절차 (인간 승인 시)

```bash
# DRY-RUN (롤백 — 아무것도 영구 적재 안 됨). apply.sh 패턴 재사용.
#   apply.sh 가 BEGIN; SET LOCAL …; <load.sql>; ROLLBACK; 주입.
#   본 트랙 전용 러너가 없으면 09_load/_exec/apply.sh 와 동일 구조로 load.sql 경로만 교체.
./apply.sh                 # DRY-RUN: INSERT/UPDATE/DELETE 시도 후 무조건 ROLLBACK + NOTICE 확인
# 2-pass 멱등 확인: 위를 2회 → 2회차 "INSERT 0"·"UPDATE 0"·"DELETE 0" 기대
./apply.sh commit <runts>  # 영구 적재 (인간 승인 시에만). 본 하네스 자동 미호출.
```

- DRY-RUN 출력에서 **단계1 `INSERT 0 28`·단계2 `INSERT 0 30`·단계3 `DELETE 28`+`INSERT 0 28`·단계4 `UPDATE 1`** + 검증 `NOTICE: D-WIRE 사슬 검증 PASS` 확인.
- 2-pass: 2회차는 NOT EXISTS 가드로 `INSERT 0 0` ×, DELETE 0(이미 FIXED 바인딩 없음), UPDATE 0(이미 'N') → 멱등.

---

## 5. 적용 순서 (Slice A / C3 와의 결합 — README §5 / mapping §5 참조)

본 트랙(배선/공식/바인딩) **+** Slice C3(component_prices 73) **+** Slice A(siz 108 승인 후 component_prices 670) = 셋 다 적용돼야 포스터/실사 가격이 실제 조회된다. 본 트랙 단독으로는 **사슬 구조만 복구**(단가 sparse). 순서는 직교(본 트랙 ↔ Slice A/C3 선후 무관)이나 **셋 다 필수**.
