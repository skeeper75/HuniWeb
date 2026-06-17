# 스티커 BLOCKED 마무리 (_exec_sticker2) — 독립 검증 verdict (R1~R6) — round-23 항목 7

> **검증자** dbm-validator · 2026-06-17 · 생성자(load-builder)와 **독립**. self-approve 금지·생성자 주장 비신뢰.
> **방법** 라이브 `railway` DB read-only psql 직접 실측 + `sticker-import.xlsx` verbatim 직접 추출 + 롤백전용 라이브 DRY-RUN 2-pass(BEGIN…ROLLBACK·COMMIT 0). 날조 금지.
> **결론 = GO** (R1~R6 전건 PASS). 실 COMMIT·BLOCKED 해소는 인간 승인.

---

## 0. 핵심 5줄

1. **GO** — R1~R6 전건 PASS. 라이브 독립 DRY-RUN 2-pass에서 영향행 **518**(INSERT 515+UPDATE 1+DELETE 2)·재실행 delta **0**·COMMIT 0 실증.
2. **min_qty 가드 PASS** — 엔진 `pricing.py:188 if base<=0 raise ValueError` 직접 확인. SB1 타투(.02 min_qty=3)·SB2 팩(.02 min_qty=54) 둘 다 NOT NULL. 라이브 `.02 단가행 min_qty NULL/<=0 = 0` 실측.
3. **verbatim PASS** — B01 504행=14(siz,mat)×36mq xlsx `4b_component_prices_BLOCKED` verbatim·gen_load_sql.py byte-identical 재현. 타투 4000(A81)·팩 4000(B88)·6700/7700(@mq1) 전부 가격표 일치.
4. **골든 PASS** — G1 타투 q9=4000÷3×9=**12000** · G2 팩 q54=4000÷54×54=**4000** · G3 100x148 유포 mq1=**6700** · G4 90x110 홀로 mq1=**7700**. 라이브 룩업·산술 일치.
5. **BLOCKED 5 정당 + 날조 0** — 타투 base2000·058~064 반칼변형·A4/A3 B01(SIZ_520/521)·팩 환산·팩소재 = apply.sql 체인에서 **전부 부재** 실측. 채번 SIZ_000518/519 = 라이브 max+1/+2(max=SIZ_000517·exact 부재).

---

## 1. R게이트 판정 (라이브·xlsx 직접 근거)

| 게이트 | 항목 | 독립 근거 | 판정 |
|--------|------|-----------|:--:|
| **R1** | 멱등 (PK 시퀀스·조합PK → NOT EXISTS·조건부 U/D) | 라이브 PASS2 = INSERT 0·UPDATE 0·DELETE 0 (전건). delta 0 | **PASS** |
| **R2** | 단일 트랜잭션·FK 위상 | apply.sql `\set ON_ERROR_STOP on`·`BEGIN…ROLLBACK`·중간 COMMIT 0. \i 순서 SB3채번→SB3단가→SB1→SB2 (siz 부모 선행). 독립 단일 txn 실행 성공 | **PASS** |
| **R3** | 실행 가능 | psql -f apply.sql 라이브 무오류 실행. apply.sh = `.env.local` RAILWAY_DB_*·DRY-RUN 기본·`--commit` 분리·백업 4 CSV·비밀값 비노출 | **PASS** |
| **R4** | 영향행수 518 독립 재현 | 라이브 PASS1: SB3채번 **2**·SB3단가 **504**·SB1타투 **5**·SB2팩 **U1·D2·I4**. 합계 INSERT 515+UPDATE 1+DELETE 2 = **518** | **PASS** |
| **R5** | ★.02 min_qty 가드 (돈크리티컬) | 엔진 가드 라인 직접 확인. 라이브 `.02 단가행 min_qty NULL/<=0 = 0`. 타투 mq3·팩 mq54 단일행. 팩 기존 2행(mq 1·1000) 삭제 후 1행·중복 0 | **PASS** |
| **R6** | ★verbatim + 골든 + 채번 | xlsx 504행 byte-identical·단가 verbatim·골든 G1~G4 라이브 일치·SIZ_518/519=max+1 search-before-mint·BLOCKED 5 체인 부재 | **PASS** |

**→ R1~R6 전건 PASS = GO.**

---

## 2. min_qty 가드 판정 (R5 상세 — 돈크리티컬·아크릴 A5 교훈)

- 엔진 `raw/webadmin/webadmin/catalog/pricing.py` `component_subtotal`:
  `if prc_typ == PRC_TYPE_TOTAL: base = tier_min_qty or 0; if base<=0: raise ValueError(…)` — **직접 확인**.
- 라이브 DRY-RUN 내 `.02(합가형) 단가행 중 min_qty IS NULL OR min_qty<=0` 카운트 = **0**.
- 타투 COMP_STK_TATTOO(.02) min_qty=**3**·팩 COMP_STK_PACK(.02) min_qty=**54** → ValueError 회피 보장.
- 팩 교정: 라이브 기존 = (siz_068, mq1, 4000)·(siz_068, mq1000, 4000) 2행(.01) **실측 일치**. SB2가 .01→.02 UPDATE 1 + 2행 DELETE + mq54 1행 INSERT → 단일행·중복 0.

---

## 3. verbatim 판정 (R6 상세)

| 항목 | xlsx 출처 | 값 | 라이브 DRY-RUN | 판정 |
|------|-----------|-----|----------------|:--:|
| 타투 단가 | 메인시트 A81/B81 (resolution §1.1) | 4000 @ min_qty=3 | 4000.00 mq3 | ✅ |
| 팩 단가 | B88 (resolution §2.1) | 4000 @ 54장1세트 | 4000.00 mq54 | ✅ |
| B01 504행 | `4b_component_prices_BLOCKED` 시트 | 14(siz,mat)×36mq | INSERT 504 | ✅ |
| B01 100x148 유포 mq1 | xlsx 셀 | 6700 | 6700.00 | ✅ |
| B01 90x110 홀로 mq1 | xlsx 셀 | 7700 | 7700.00 | ✅ |
| byte-identical 재현 | gen_load_sql.py 재실행 | diff 0 | — | ✅ |

- **자료 정정(harmless)**: resolution §5.2/SB3 표는 "B01 216행"으로 기재했으나, xlsx `4b_component_prices_BLOCKED`의 100*148·90*110 두 사이즈 실제 행수 = 각 252(7mat×36mq) = **504**. 빌더 산출(504)이 **xlsx verbatim에 정합**·resolution의 216은 stale pre-estimate. 빌더가 추정치가 아닌 시트 실값을 따랐으므로 정당. (재단/판수 아님 — 단순 사이즈별 가격행 수)

## 4. 골든 (엔진 합가형 산술 = unit/min_qty × qty)

| # | 룩업 | 산술 | 결과 | 판정 |
|---|------|------|------|:--:|
| G1 | 타투 q9 | 4000÷3×9 | 12000.00 | ✅ |
| G2 | 팩 q54(장) | 4000÷54×54 | 4000.00 | ✅ |
| G3 | B01 100x148(518)·유포·mq1 | verbatim | 6700.00 | ✅ |
| G4 | B01 90x110(519)·홀로·mq1 | verbatim | 7700.00 | ✅ |

## 5. 채번 search-before-mint (R6)

- 라이브 max siz_cd = **SIZ_000517** (실측). SIZ_000518/519 = max+1/+2·exact **부재** 실측 → 무충돌.
- impos_yn='Y'·판걸이=note 보존(앱 임포지션·가격 미저장) = 정합.

## 6. BLOCKED 5 정당성 (체인 부재 실측)

| BLOCKED | apply.sql 체인 | 판정 |
|---------|----------------|:--:|
| 타투 기본가 2000 (Q-STK-1b) | "2000" 출현 = 주석 헤더만(데이터 0) | 정당 분리 ✅ |
| 058~064 반칼변형 바인딩 (Q-STK-8) | PRD_058~064 바인딩 = 0 | 정당 BLOCKED ✅ |
| B01 A4/A3 단가 (Q-STK-7-r) | SIZ_520/521 = 0 | 정당 BLOCKED ✅ |
| 팩 환산단위 (Q-STK-3b) | 적재는 장단위(mq54) GO·의미만 컨펌 | 정직 ✅ |
| 팩 소재 (Q-STK-6) | use_dims에 mat 없음·적재 무관 | 정직 ✅ |
- GAP escalate = **0**. 차단은 전부 출처/값 미확정(컨펌 대기)·데이터 모델 표현 가능.

## 7. 불일치/날조 적발

- **날조 0** — DRY-RUN 행수·골든·verbatim·채번·BLOCKED 부재 전부 라이브/xlsx 직접 재현으로 일치.
- **자료 정정 1건(harmless)**: resolution §5.2 "B01 216행" → 실제 504(xlsx verbatim). 빌더 산출이 정답·resolution 표만 stale. 빌더 행수·dryrun-report(504) 정합.
- 무결성: 팩 DELETE 정확히 2행(mq 1·1000·전부 apply_ymd 2026-06-01·survivor 0)·FK 부모(mat167=타투전용지·siz060=90x190·siz068=75x110·7 print mat·COMP_STK_PRINT) 전부 라이브 실존.

---

## 최종 verdict

**GO** — R1~R6 전건 PASS (독립 라이브 DRY-RUN 2-pass·xlsx verbatim·엔진 가드 직접 확인).
실 COMMIT(`apply.sh --commit`)·BLOCKED 3 해소(타투 base·058~064 출처·A4/A3 단가)·컨펌 2(팩 환산·소재)는 인간 승인. COMMIT 0 유지·라이브 무변경 실증.
