# 교정 명세 + 적재 큐 — 떡메모지(PRD_000097) 가격 바인딩 파일럿

검증: hsp-set-gate · 종합 판정 = **GO**(S1~S7 FAIL 0) · DB 미적재(COMMIT 0).

---

## 1. 확정 결함 — 없음

097 가격공식 바인딩 단독 트랙은 결함 0. 신규 mint 0(PRF·comp·112 단가행·formula_components 전부 라이브 실재)·골든 PRICE≠0·이중합산 0·DRY-RUN 멱등/부작용 0. → 교정 명세 비어 있음(NO-OP).

(무해한 산출물 오기: 설계 문서가 `t_prc_price_formulas.del_yn`을 참조하나 실 스키마는 use_yn만 존재 — 판정 무영향·use_yn=Y 실측으로 대체. 적재 차단 아님.)

---

## 2. 적재 GO 큐 → hsp-load-executor (인간 승인 후 COMMIT)

| # | 대상 t_* | 작업 | 행 | 멱등 키 / 충돌 처리 | 돈 영향 | 인간 승인 |
|---|---|---|---|---|---|---|
| 1 | t_prd_product_price_formulas | INSERT `(PRD_000097, PRF_TTEOKME_FIXED, '2026-06-01', note)` | 1 | (prd_cd, apply_bgn_ymd) · ON CONFLICT DO NOTHING | 097 견적 0원→정상 산출(60,000/19,200) | **필요** |

- 사용 SQL = `06_load/price-pilot-tteokme/apply.sql`(검증 완료·그대로 사용).
- load-executor: 단일 트랜잭션 래핑(BEGIN…COMMIT)·백업·사후검증 SELECT(기대 1행: `PRD_000097|PRF_TTEOKME_FIXED|2026-06-01`).
- 게이트는 COMMIT 안 함 — 인간 승인 후 load-executor COMMIT.

### FK 위상 (선행 충족 — 추가 적재 불요)
- prd_cd → t_prd_products(PRD_000097 실재) ✓
- frm_cd → t_prc_price_formulas(PRF_TTEOKME_FIXED 실재) ✓
- comp/단가행/formula_components 전부 라이브(round-16 적재) ✓

---

## 3. BLOCKED 라우팅 — 본 파일럿 무관(범위 외 이월)

set-price-authority §3 트랙(본 파일럿과 별개·동시 진행 가능):

| set_prd_cd | 상태 | 라우팅 |
|---|---|---|
| PRD_000094 엽서북 | 적재됨(결함) — S1/S2 silent 이중합산·prc_typ ×qty(§18 R-3) | dbm-price-arbiter 심의 후 dbmap 교정 |
| PRD_000072/077/082 책자류 | 적재 대상(권위 원자합산형·라이브 미적재) | §18 PRF_HC_*_SUM 신설 → dbm-ddl-proposer·dbm-load-execution |
| PRD_000100 포토북 | 적재 대상(base24+per2p) | §18 PRF_PHOTOBOOK_SUM → dbmap |
| PRD_000088 레더링바인더 | 진성 미정(권위 "보류중") | CONFIRM(인간 제본방식 확정) 후 바인딩 |

---

## 4. 인간 승인 큐

1. **097 가격 바인딩 COMMIT 승인**(돈 크리티컬) — GO·apply.sql 준비됨. 승인 시 load-executor 적재.
2. (선택) CFM-097 apply_bgn_ymd=2026-06-01 형식 확인 — 라이브 3중 정합(단가행·094 선례·전체 패턴)이므로 적재 차단 사유 아님(권고 수준).
