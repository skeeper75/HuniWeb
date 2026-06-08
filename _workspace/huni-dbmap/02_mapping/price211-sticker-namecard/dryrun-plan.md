# DRY-RUN 계획서 (PLAN ONLY — 미실행) — price-211 slice C1

[HARD] 본 문서는 **DRY-RUN 계획(plan)** 이다. 라이브 DRY-RUN(쓰기 트랜잭션→ROLLBACK) **실행은 lead/인간 승인 사항**이며 본 생성 단계에서 실행하지 않았다. 실제 COMMIT 도 금지. 아래는 dbm-validator/lead 가 승인 후 수행할 절차·기대 게이트.

## 1. 적재물 요약

| 테이블 | INSERTABLE 행 | 멱등 키 | 신규/재사용 |
|--------|:--:|---------|------|
| `t_prc_price_formulas` | 1 | PK `frm_cd` | 신규 mint `PRF_STK_PACK_FIXED` |
| `t_prc_formula_components` | 18 | PK `(frm_cd,comp_cd)` | 배선(comp_cd 전부 라이브 선존재) |
| `t_prd_product_price_formulas` | 16 | PK `(prd_cd,frm_cd)` | 바인딩(prd_cd·frm_cd 선존재) |
| `t_prc_component_prices` | **0** | — | **신규 없음(기존 단가 재사용·재적재 금지)** |
| **합계 INSERTABLE** | **35** | | |
| BLOCKED(별도) | 3 | — | `product_price_formulas_BLOCKED.csv` |

## 2. read-only 사전검증 결과 (이미 수행·PASS)

- **FK 부모 선존재**: 배선 comp_cd 18/18 found, 바인딩 prd_cd 16/16 found, 재사용 frm_cd 2/2 존재, 신규 frm_cd 부재(정상). missing 0.
- **멱등 precheck**: 대상 binding/wiring 라이브 0건(전부 신규 35행). 재실행 시 ON CONFLICT DO NOTHING → 0행.
- **코드 부모**: FRM_TYPE.02(단순형), PRC_COMPONENT_TYPE.06(완제품비) 선존재.

## 3. DRY-RUN 실행 절차 (승인 후)

`09_load/_exec_dgp/apply.sh` 패턴 준용:
1. `.env.local` source → `export PGPASSWORD="$RAILWAY_DB_PASSWORD"`(stdout 출력 금지).
2. `psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -X -v ON_ERROR_STOP=1`.
3. **DRY-RUN**: `load.sql` 의 마지막 `COMMIT;` → `ROLLBACK;` 치환 후 실행(`sed 's/^COMMIT;.*$/ROLLBACK;/'`). DB 무변경.
4. **멱등 2-pass**: DRY-RUN 2회 — 2회차 INSERT 영향행 = 0(ON CONFLICT) 확인.
5. 실 COMMIT 은 인간 승인 시에만 별도.

## 4. 기대 게이트 (R1~R6)

| 게이트 | 기대 | 근거 |
|--------|------|------|
| R1 제약위반 0 | PASS | NOT NULL(frm_nm/frm_typ_cd/use_yn) 전부 채움·apply_bgn_ymd nullable·reg_dt OMIT→DEFAULT |
| R2 FK 고아 0 | PASS | §2 부모 선존재 18+16+2/2 |
| R3 PK 중복 0 | PASS | CSV 내 (frm_cd,comp_cd)·(prd_cd,frm_cd) 유일·라이브와 무충돌(precheck 0) |
| R4 멱등 2-pass | PASS | 전 INSERT ON CONFLICT DO NOTHING |
| R5 IDENTITY stale | N/A | component_prices 신규 0 → comp_price_id 시퀀스 미사용 |
| R6 COMMIT 0(DRY-RUN) | PASS | COMMIT→ROLLBACK 치환·DB 무변경 |

## 5. 검증 핸드오프 (dbm-validator)

- **S-gate(도메인 의미)**: 반칼변형 7종이 B01 반칼 매트릭스를 공유함을 라이브 정답(PRD_000052 동일 frm_cd)과 대조. 박명함 FOIL(.06)+SETUP(.05) 합산이 L1 "종이+동판+박가공비" 의미와 일치 확인.
- **역대조**: §7 flag(COMP_STK_PRINT 매트릭스 불완전·펄명함 mat_cd 불일치·투명데드롱≠투명스티커) 판정. 단가 재적재 안 했으므로 셀 역대조는 "기존 단가 재사용 정당성" 확인이 핵심.
- **over/under-block**: BLOCKED 3건(형압명함 DATA-GAP·소량자유형 base구조·타투 번들)이 정당한지, INSERTABLE 16이 누락/과다 없는지 검증.
