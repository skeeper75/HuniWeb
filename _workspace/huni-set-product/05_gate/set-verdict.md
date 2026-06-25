# 셋트 검증 게이트 판정 — 엽서북(PRD_000094) 셋트 보정 적재본 (S1~S7)

생성: hsp-set-gate (독립 검증·생성≠검증) · 라이브 읽기전용 SELECT 직접 재실측 · DRY-RUN 롤백전용 2회 · **DB 미적재(GO여도 게이트 COMMIT 안 함 — load-executor)**.
대상: `03_design/`(set-composition-design·apply.sql·t_prd_product_sets.csv·t_prd_products.csv·blocked-board.csv) + `04_codex/reconcile.md`(R-1~R-4).
**생성측(set-designer/codex) 주장 비신뢰 — 아래 PASS/FAIL 전부 게이트가 라이브로 직접 재실측한 증거 기반.**

---

## 0. 종합 판정

| 종합 | 결과 |
|---|---|
| **엽서북 셋트 보정 본체(95/96 행 UPSERT + 94 유형 04→01)** | **GO (CONDITIONAL)** |
| 조건 | 적재본은 30P 가격결함을 **건드리지 않으며 포함하지 않는다**(별도 트랙). 단 설계 §0/§3 "가격 사슬 GO" 라벨은 **부정확**(30P 진단 오류) — 문구 정정 후 적재 권고. |
| 적재 GO 행수 | t_prd_product_sets **2행(UPSERT 보정)** + t_prd_products **1행(유형 UPDATE)** = **3 DML** |
| BLOCKED(적재 제외·라우팅) | RM-1 30P 가격결함(★진단 정정: 부재 아님·미바인딩+오청구)·RM-2 면지 자재 수술·RM-3 6셋트 유형정책 |
| 돈크리티컬 S4 재계산 결과값 | **450,000원** (20P·단면·SIZ_000003·100부) — PRICE≠0·이중합산0 입증 |

**단일 FAIL 없음** → 적재본 본체 NO-GO 사유 없음. 30P는 적재본 범위 밖 결함이라 본체 GO를 막지 않되, BLOCKED로 분리·정직 라벨 정정 조건 부과 = **CONDITIONAL GO**.

---

## 1. S1~S7 판정표

| 게이트 | 판정 | 재실측 증거 |
|---|---|---|
| **S1 권위 충실성** | **PASS** | 구성=내지95(몽블랑240)+표지96(스노우300) ↔ set-checklist row20-21·booklet-l1 row61 일치. 내지 가변 20/30/10 = 권위 명시값 verbatim. 날조 0. (`set-authority-spec §2.1·§2.3`) |
| **S2 구성원 유형** | **PASS** | 라이브 실측: 95=PRD_TYPE.02·96=PRD_TYPE.02(반제품)·94=PRD_TYPE.04(현재값). 유형교정 94 **04→01 타당**(셋트 부모=완제품, admin.py:1090 sub_prd_cd=PRD_TYPE.02만 노출 규칙과 정합·구성원 95/96 불변). |
| **S3 무결성** | **PASS** | 복합PK(prd_cd,sub_prd_cd) 실측·94 셋트행 중복 0. FK 고아 0(94·95·96 전부 t_prd_products 실재). 라이브 t_prd_product_sets **semi_role_cd 컬럼 부재 확인**(설계가 옳음·reuse-map "semi_role 있음"이 틀림). 개수규칙 정합(sub_prd_qty=1·min20≤max30·incr10>0). |
| **S4 가격 e2e [HARD]** | **PASS (20P)** | evaluate_set_price 재현 → final=**450,000≠0**(price-e2e-trace.md). 단가행 verbatim·이중합산 0(S1단면/S2양면 print_opt 배타·단면선택 S2 매칭0). **R-1: "20P 한정 GO"가 정확** — 설계 §0 "가격 사슬 GO"는 부정확(30P 오진단 가림). |
| **S5 경쟁사 흡수** | **PASS** | 권위(구성원 합산형) 유지·레드 통합산정형 미이식. 엽서북 적재본에 경쟁사 naming/code 유입 0(전부 후니 코드). (`competitor-set-reference §3`) |
| **S6 적재 가능성** | **PASS** | DRY-RUN 2회(롤백전용): 제약위반 0·ROLLBACK 후 원상복귀(type 04 복원). 멱등=2차 apply 시 유형 UPDATE **0행**·data fingerprint 동일(998232…1차=2차)·행수 2 유지. 예상 DML=UPDATE1+UPSERT2. **R-2: 데이터값 멱등 OK**(upd_dt 갱신은 부작용·오염 아님). |
| **S7 생성≠검증 독립성** | **PASS** | 전 판정 게이트 직접 psql 재실측·apply.sql 직접 DRY-RUN. codex R-1~R-4 전부 종결(아래). **★생성측 30P "부재" 진단을 게이트가 라이브로 정정**(미바인딩+오청구)=생성≠검증 실효 입증. |

---

## 2. R-1 ~ R-4 종결 (codex reconcile 큐)

| ID | 사안 | 게이트 라이브 재실측 판정 | 종결 |
|---|---|---|---|
| **R-1** | "가격 사슬 GO" 라벨 ↔ 30P | **codex 방향 인용·단 진단 자체도 정정**: 설계 "GO"는 부정확. 실측=20P 한정 PRICE≠0 GO. **그러나 30P는 "부재"가 아니라 "comp/단가행 존재·미바인딩→20P로 오청구"**(price-e2e §4). → 설계·codex 둘 다 "30P 부재"는 틀림. **정정**: "20P 한정 GO·30P 오청구 BLOCKED(RM-1)". | **CLOSED** — 적재본 데이터 불변·설계 문구 정정 권고 |
| **R-2** | UPSERT upd_dt 멱등 가드 비대칭 | **사실**: ON CONFLICT에 WHERE 가드 없음. DRY-RUN 2회 실증 = **데이터값 완전 멱등**(fingerprint 동일·동일 txn upd_dt 동일). 별도 txn 재실행 시 upd_dt만 갱신(데이터 오염 0). 멱등성=결과 동일성 충족. | **CLOSED** — 결과값 멱등 인정(가드 추가는 선택·강제 아님) |
| **R-3** | sub_prd_qty=1 vs min/max=20/30 충돌? | **codex false-positive 확정·기각**: 라이브 스키마 실측 — `sub_prd_qty`(하위상품수량 NOT NULL)와 `min_cnt/max_cnt/cnt_incr`(구성최소/최대/증가단위)는 **서로 다른 컬럼·다른 축**(models.py L468-471). base=sub_prd_qty 아님. min/max는 내지 페이지 가변(derive_inner_sheets 입력). **충돌 아님**. | **CLOSED — codex 가설 기각** |
| **R-4** | "mint 0/UPDATE" ↔ INSERT…ON CONFLICT 어법 | **정보성**: 라이브 94 셋트행 2개 실재(95·96) → 실행 시 항상 ON CONFLICT DO UPDATE 분기. DRY-RUN에서 행수 2 유지·신규행 0 확인. 표현차일 뿐 결함 아님. | **CLOSED** |

**codex reconcile 미해결 = 0** (R-1~R-4 전부 종결).

---

## 3. 적재 GO 큐 (load-executor 위임·인간 승인 후 COMMIT)

승인 대상 = 엽서북 셋트 보정 본체 3 DML (apply.sql 그대로, 신규 mint 0):

| # | 대상 t_* | DML | 키 | 내용 | 멱등 |
|---|---|---|---|---|---|
| 1 | t_prd_products | UPDATE | PRD_000094 | prd_typ_cd 04→01 | `IS DISTINCT FROM` 가드(no-op 멱등) |
| 2 | t_prd_product_sets | UPSERT | (94,95) | 내지: min/max/incr=20/30/10·disp_seq=1 | ON CONFLICT DO UPDATE(데이터값 멱등) |
| 3 | t_prd_product_sets | UPSERT | (94,96) | 표지: disp_seq 1→2·가변 NULL 유지 | ON CONFLICT DO UPDATE(데이터값 멱등) |

**조건**: 적재 전 설계 §0/§3 "가격 사슬 GO" 문구를 "20P 한정 GO·30P=RM-1 BLOCKED(오청구·미바인딩)"로 정정(데이터 변경 0). RM-1~RM-3은 적재본에서 제외·별도 트랙.

---

## 4. 라이브 실측 재현 쿼리 (감사용·읽기전용)

```sql
-- S2 유형·존재
SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_cd IN ('PRD_000094','PRD_000095','PRD_000096');
-- S3 스키마(semi_role_cd 부재 확인)
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_sets';
-- S3 PK·FK
SELECT conname, pg_get_constraintdef(oid) FROM pg_constraint WHERE conrelid='t_prd_product_sets'::regclass AND contype IN ('p','f');
-- S4 공식·구성요소·단가행
SELECT comp_cd, use_dims FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_PCB%';
SELECT frm_cd, comp_cd, addtn_yn FROM t_prc_formula_components WHERE comp_cd LIKE 'COMP_PCB%';   -- 30P=0행(고아)
SELECT comp_cd, siz_cd, print_opt_cd, min_qty, unit_price, note FROM t_prc_component_prices
  WHERE comp_cd='COMP_PCB_S1_20P' AND siz_cd='SIZ_000003' AND print_opt_cd='POPT_000001' AND min_qty=100;  -- 4,500
-- S6 DRY-RUN: BEGIN; \i apply.sql; (측정); ROLLBACK;  (2회 멱등 실증)
```
