# 셋트 가격 적재 — 097 떡메모지 가격공식 바인딩 라이브 COMMIT 리포트

생성: §23 huni-set-product `06_load/price-pilot-tteokme` · 라이브 Railway DB(`db railway`·비표준 포트) · 인간 승인(사용자 AskUserQuestion "지금 실행" 직접 선택)
권위: 상품마스터 260610 계산공식집 §1.4 고정가형 [수량행][옵션열] · round-16(dbmap) 적재 PRF_TTEOKME_FIXED · 라이브 verbatim
검증: codex(GO·6/6 합의·divergence 0) + 게이트(S1~S7 FAIL 0·골든 정확) 이중 GO

> **결론 한 줄**: 097 떡메모지(PRD_000097) → 기존 라이브 공식 PRF_TTEOKME_FIXED 바인딩 **1행 COMMIT 성공**. 신규 mint 0(round-16 적재 공식 재사용)·돈영향 현재 0(떡메 견적을 올바르게 ON)·골든 60,000/19,200. 바인딩 77→78.

## 1. 적재 내용

```
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000097','PRF_TTEOKME_FIXED','2026-06-01','떡메모지 셋트 완제품 고정가 공식 바인딩(round-16 단절2 해소)')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;
```
- PK=(prd_cd, apply_bgn_ymd) 라이브 실측. 신규 mint 0(상품↔기존 공식 연결 1행).
- search-before-mint: PRF_TTEOKME_FIXED·COMP_TTEOKME·112 단가행·formula_components 전부 라이브 실재(round-16).

## 2. 백업 (undo 가역)

| 백업 테이블 | 행수 | 비고 |
|---|---|---|
| `bak_t_prd_product_price_formulas_tteokme_20260625_153807` | 0 | 097 사전 바인딩 0행(신규 바인딩이라 빈 스냅샷) |

복원 = `undo.sql`(COMMIT한 1행 DELETE → 097 바인딩 0행 복귀).

## 3. 검증 (이중 GO)

- **게이트**(price-pilot-tteokme-gate.md·e2e.md): S1~S7 FAIL 0. evaluate_set_price 독립 손계산 = 골든1 90x90/50장/30권 **60,000**(2,000×30)·골든2 70x120/100장/6권 **19,200**(3,200×6) 정확 일치. 이중합산0·구성원098 비기여·할인0·bdl_qty∈NON_QTY_DIMS(pricing.py:43) 정확매칭·DRY-RUN 멱등 delta0·부작용0.
- **codex**(price-pilot-tteokme-codex-reconcile.md): OVERALL GO·6/6 합의·divergence0·환각0. N-1/N-2/N-3 비차단(거버넌스·copies<6 엔진 명시차단·off-grid UI). 설계문서 PK 오타(apply.sql/CSV는 정확)만 보정 권고.
- **CFM-097**: apply_bgn_ymd=2026-06-01 라이브 3중 정합(단가행 apply_ymd·엽서북 선례·76/77 바인딩 패턴).

## 4. 실 COMMIT + 사후 재실측

| 측정 | 값 |
|---|---|
| pre 097 바인딩 / 전체 | 0 / 77 |
| INSERT | 0 1 |
| post 097 | PRD_000097 \| PRF_TTEOKME_FIXED \| 2026-06-01 |
| post 전체 바인딩 | 78 |

→ **COMMIT 성공.** 떡메모지 가격공식 바인딩 단절 해소.

## 5. 경계·후속

- 097 바인딩 1행만. 신규 mint 0·공유자원 미수정·t_prd_product_sets 불변·타 상품 무영향.
- 후속(BLOCKED·별도 트랙): 072·077·082 책자(원자합산형 PRF/comp/단가/배선 신규 + 선행 W1/W2)·100 포토북(base24/per2p 신규)·088 진성 미정(실무진).
- undo: `undo.sql`.
