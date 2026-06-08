# DRY-RUN 계획 — D-WIRE BIND/NAMECARD/PHOTOCARD 가격공식 재모델 (plan only, 미실행)

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07 |
| 상태 | **DRY-RUN 계획만**(plan). 라이브 실행 안 함(HARD: no live DRY-RUN exec). |
| 권위 | `00_schema/price-engine-ddl.md` (FK·C-1~C-9) + 라이브 read-only 실측 |

> [HARD] 본 트랙은 **라이브 쓰기 0건**(INSERT/UPDATE/DELETE/DDL/COMMIT 미실행). DRY-RUN(`BEGIN; … ROLLBACK;`) **실행조차 하지 않는다** — 아래는 인간 승인 후 실행할 **계획**일 뿐. FK 부모 선존재·충돌·컬럼 정합·사슬무결성은 read-only SELECT 로 사전 확인 완료(증거 §1).

---

## 1. 설계자 사전점검 (read-only 실측 증거 — 실행 전 확인 완료)

| 점검 | 방법 | 결과 |
|------|------|------|
| 신규 9 frm_cd 충돌 | `SELECT frm_cd … WHERE frm_cd IN (9 신규)` | **0행**(충돌 없음) |
| FRM_TYPE.01/.02 부모 | `SELECT cod_cd FROM t_cod_base_codes WHERE cod_cd IN ('FRM_TYPE.01','FRM_TYPE.02')` | **둘 다 존재** |
| 14 comp_cd 부모 | `SELECT count(*) FROM t_prc_price_components WHERE comp_cd IN (14종)` | **14**(전건 존재) |
| 9 prd_cd 부모 | `SELECT count(*) FROM t_prd_products WHERE prd_cd IN (9종)` | **9**(전건 존재) |
| 14 comp 단가 존재 | `n_prices` per comp | BIND 8×4·STD/COAT 2·PREMIUM 1·SET/CLEAR_SET 1 — **전건 n_prices≥1** |
| 기존 바인딩 수 | 9상품 각 n_bindings | 전건 **1**(DELETE 후 0, INSERT 후 1 — 누락/중복 0) |
| C1 미적재 확증 | PRF_NAMECARD_FIXED 라이브 배선 2·바인딩 3 | C1 18배선·7바인딩 **미적재**(생성-only). 본 트랙이 supersede |
| 사슬무결성 시뮬 | 9상품 plan → comp → n_prices SELECT(쓰기0) | **9상품 전건 RESOLVES**(n_prices>0), BLOCKED-DATA 0 |

---

## 2. FK 위상정렬 적재순서 (load.sql 단계)

```
[단계 0] FK 부모 선존재 assert (DO $$ … RAISE EXCEPTION)
            t_cod_base_codes(FRM_TYPE.01·.02), t_prd_products(9), t_prc_price_components(14)
[단계 1] t_prc_price_formulas      INSERT 9   (frm_typ_cd FK → FRM_TYPE.01/.02 선존재)
[단계 2] t_prc_formula_components  INSERT 14  (frm_cd FK → 단계1, comp_cd FK → 라이브 선존재)
[단계 3] t_prd_product_price_formulas
            DELETE (prd, 공유공식) 9    (멱등 — 없으면 0행)
            INSERT (prd, PRF_<X>)   9   (frm_cd FK → 단계1 선존재)
[단계 4] t_prc_price_formulas      UPDATE use_yn='N' (공유 3공식 은퇴)
[검증]   DO $$ 사슬 무결성 (9 배선완료·공유공식 0바인딩) RAISE EXCEPTION 시 전체 abort
```

### FK 안전성 증명 (rebind 한 건씩)
- **단계1이 단계3보다 먼저** → `product_price_formulas.frm_cd` FK(→`price_formulas.frm_cd`) 충족.
- **DELETE-old↔INSERT-new PK 독립**: 같은 prd_cd 이나 frm_cd 상이(공유 vs PRF_<X>) → PK `(prd_cd, frm_cd)` 충돌 없음. DELETE 가 INSERT 선행조건 아님.
- **DELETE 의 FK 영향 0**: `product_price_formulas` 는 말단 바인딩(자식 없음). 깰 하위 FK 없음.
- **단계4 UPDATE 안전**: use_yn 변경은 FK 무관(플래그). 배선·바인딩 미삭제(FK RESTRICT 회피).

---

## 3. DRY-RUN 게이트 R1~R6 (실행 시 통과해야 할 기준 — 계획)

| 게이트 | 기준 | 본 트랙 사전판정(설계 근거) |
|------|------|------|
| **R1 멱등성** | 2-pass 재실행 시 2회차 행변경 0 | 전 INSERT `WHERE NOT EXISTS`; DELETE 멱등(2회차 대상 0); UPDATE `IS DISTINCT FROM`. → **PASS 예상** |
| **R2 원자성** | 임의 문 실패 시 전체 롤백 | ON_ERROR_STOP=1 + 단일 tx(apply.sh BEGIN/ROLLBACK 주입). → **PASS 예상** |
| **R3 제약위반 0** | NOT NULL/CHECK/FK/PK/UNIQUE 위반 0 | frm_typ_cd NOT NULL=FRM_TYPE.01/.02; use_yn CHECK Y/N; addtn_yn CHECK Y/N; FK 14comp·9prd·FRM_TYPE; PK(frm_cd)·(frm_cd,comp_cd)·(prd_cd,frm_cd) CSV 내 중복 0(assert 완료). → **PASS 예상** |
| **R4 FK 고아 0** | 적재행의 FK 부모 전건 존재 | 단계0 assert + per-INSERT EXISTS 가드. → **PASS 예상** |
| **R5 COMMIT 0** | DRY-RUN 은 ROLLBACK 만 | apply.sh 기본 dryrun=ROLLBACK. 본 하네스 COMMIT 미호출. → **PASS(불변)** |
| **R6 사슬 무결성**(트랙특화) | 적재 후 9상품 전부 자기 공식+자기 comp 배선; 공유공식 3 = 0바인딩 | load.sql 말미 검증 DO 블록이 같은 tx 에서 assert(미충족 시 RAISE→전체 abort). read-only 시뮬로 9상품 RESOLVES 사전 실증. → **PASS 예상** |

---

## 4. 실행 절차 (인간 승인 시)

```bash
# DRY-RUN (롤백 — 아무것도 영구 적재 안 됨). apply.sh 패턴 재사용(09_load/_exec 구조).
#   apply.sh 가 BEGIN; SET LOCAL …; <load.sql>; ROLLBACK; 주입.
./apply.sh                 # DRY-RUN: INSERT/UPDATE/DELETE 시도 후 무조건 ROLLBACK + NOTICE 확인
# 2-pass 멱등 확인: 위를 2회 → 2회차 "INSERT 0"·"UPDATE 0"·"DELETE 0" 기대
./apply.sh commit <runts>  # 영구 적재 (인간 승인 시에만). 본 하네스 자동 미호출.
```

- DRY-RUN 출력 기대: **단계1 `INSERT 0 9`·단계2 `INSERT 0 14`·단계3 `DELETE 9`+`INSERT 0 9`·단계4 `UPDATE 3`** + 검증 `NOTICE: D-WIRE BIND/NAMECARD/PHOTOCARD 사슬 검증 PASS`.
- 2-pass: 2회차는 NOT EXISTS 가드로 `INSERT 0 0`, DELETE 0(이미 공유 바인딩 없음), UPDATE 0(이미 'N') → 멱등.

---

## 5. 적용 순서 (POSTER 트랙·후속 트랙과의 관계)

- 본 트랙은 **POSTER 트랙(`dwire-poster-formula-remodel`)과 직교**(다른 공식·다른 상품). 선후 무관.
- 본 트랙은 **component_prices 미적재**(단가 본체 = 라이브 선존재, 14 comp 전건 n_prices≥1). → POSTER 의 Slice A/C3 같은 단가 보충 트랙 **불요**(BIND/NAMECARD/PHOTOCARD 단가는 이미 적재됨, 사슬 시뮬 RESOLVES 실증).
- component_prices 미적재 → IDENTITY 시퀀스 무관(surrogate id 미생성).
- **후속 트랙**(본 번들 밖): C1 의 7 무가격 명함 상품별 모델(`PRF_NAMECARD_PEARL` 등) — 인간 우선순위 결정. C1 공유공식 설계는 폐기·상품별 분리로 통일.
