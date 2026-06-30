# booklet-museon-pur-069-070-post-verify.md — 사후 라이브 재실측·evaluate_set_price 무손상

> hsp-load-executor 2026-07-01 · COMMIT 후 라이브 직접 재실측(읽기전용 SELECT). 6항 전부 PASS.

## 사후검증 6항

1. **delta 일치** — 069/070 셋트행 0→2행 each·반제품 289~292 0→4·표지자재 290/292 each 7·내지자재 289/291 each 6·공식바인딩 4행(289/291=INNER·290/292=COVER). DRY-RUN 예상 카운트와 완전 일치.
2. **FK 고아 0** — 069/070 셋트행 sub_prd_cd(289~292) 전건 t_prd_products 실재. NOT EXISTS 카운트 0.
3. **복합PK 중복 0** — (prd_cd, sub_prd_cd) GROUP BY HAVING count>1 = 0행.
4. **멱등(재-dryrun delta 0)** — COMMIT 후 BEGIN…ROLLBACK 재적재 36 statement 전건 INSERT 0 0·UPDATE 0행.
5. **evaluate_set_price 무손상(PRICE≠0)** — 069=**138,688**·070=**288,688** 라이브 단가 verbatim 재현·오차 0·PRICE≠0.
6. **회귀 0** — 068(2)/072(5)/077(5)/082(6) 셋트행 불변·068 표지288+내지287 무손상.

## evaluate_set_price 재현 상세 (라이브 단가 실측치)

| 비목 | comp_cd | 매칭 키 | 100부 단가 | ×100 |
|------|---------|--------|:---------:|-----:|
| 표지인쇄 | COMP_PRINT_DIGITAL_S1 | SIZ_000499·POPT_000001·PROC_000004·min_qty=100 | 350 | 35,000 |
| 표지코팅 | COMP_COAT_MATTE | SIZ_000499·coat_side=1·PROC_000015·min_qty=100 | 500 | 50,000 |
| 표지용지 | COMP_PAPER | MAT_000073·SIZ_000499 | 36.88 | 3,688 |
| **표지 소계** | | | | **88,688** |
| 069 제본 | COMP_BIND_MUSEON | PROC_000019·min_qty=100 | 500 | 50,000 |
| 070 제본 | COMP_BIND_PUR | PROC_000020·min_qty=100 | 2,000 | 200,000 |

- **069 = 88,688 + 50,000 = 138,688** (오차 0)
- **070 = 88,688 + 200,000 = 288,688** (오차 0)
- 표지 plate_qty = copies × cover_mult(=×1, 펼침) × fn_calc_pansu(499,174)=1 = 100. 저·과청구 위험 0.
- 내지 member(289/291·PRF_DGP_INNER) 별도 page파생 가산 — 골든 138,688/288,688은 표지+제본 정의(허용오차 0).

## S8 구성요소 경계 무오염 (재실측)

- PRF_BOOK_COVER 바인딩 = PRD_000288(068)·290(069)·292(070) 정확히 3개 표지 member 전용. 069/070 표지가 자기 셋트행으로만 연결 → silent 적용 0.
- PRF_BOOK_COVER 비목 정확히 3개(인쇄+코팅+용지)·후가공/굿즈 comp 혼입 0.
- 제본 격리 결정적: COMP_BIND_MUSEON=PROC_000019만·COMP_BIND_PUR=PROC_000020만 단일 proc_cd → silent 다중매칭 0. 한 책자 제본비가 다른 책자 견적에 새지 않음.

## 결론

069·070 완전 동작화 라이브 COMMIT 무손상 입증. 골든 정확 도달·S8 오염 0·회귀 0·멱등 보존. undo 보유.
