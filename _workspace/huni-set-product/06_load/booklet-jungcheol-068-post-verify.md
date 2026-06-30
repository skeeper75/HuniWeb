# booklet-jungcheol-068-post-verify.md — 068 완전 동작화 COMMIT 사후 재실측

> 실행: hsp-load-executor 2026-07-01 · 라이브 재실측(COMMIT 후) · evaluate_set_price 알고리즘 재현.
> COMMIT: `booklet-jungcheol-068-apply.sql`(단일 트랜잭션·18 INSERT) · 백업 `bak_*_setbuild_20260701_0134`.

---

## 0. 종합 — ✅ 무손상 입증 (전 항목 PASS)

| 검증 | 결과 | 증거 |
|------|:----:|------|
| ① 적재 실재 + 차원 충전 | ✅ | 287/288 PRD_TYPE.02·PRF_BOOK_COVER use_yn=Y·비목3 |
| ② 068 셋트행 0→2 | ✅ | 표지288(seq1)·내지287(seq2)·공식 바인딩 정합 |
| ③ FK 고아 0 | ✅ | 셋트행 sub_prd_cd 전건 t_prd_products 실재 |
| ④ 복합PK 중복 0 | ✅ | (068,sub) GROUP BY HAVING count>1 = 0행 |
| ⑤ evaluate_set_price = 158,688 | ✅ | 알고리즘 재현 오차 0 |
| ⑥ 멱등 재-dryrun delta 0 | ✅ | 재적재 18 INSERT 전부 `INSERT 0 0` |
| ⑦ 기존 셋트 회귀 0 | ✅ | 072/077/082/094/100 member 행수 보존 |
| ⑧ S8 오염 0 | ✅ | PRF_BOOK_COVER 비목 = 인쇄+코팅+용지 3개만 |

---

## 1. ⑤ evaluate_set_price 158,688 재현 (라이브 단가 실측·068·100부)

```
pansu = fn_calc_pansu(SIZ_000499, SIZ_000174) = 1 → plate_qty(100) = 100
표지 member 288 (PRF_BOOK_COVER·qty=copies=100):
  표지인쇄 COMP_PRINT_DIGITAL_S1 (499·POPT001·PROC004·tier100)  350.00 × 100 = 35,000
  표지코팅 COMP_COAT_MATTE       (499·coat1·PROC015·tier100)     500.00 × 100 = 50,000
  표지용지 COMP_PAPER            (499·MAT073)                    36.88 × 100 =  3,688
  ───────────────────────────────────────────── 표지 소계 = 88,688
셋트 자기공식 068 (PRF_BIND_SUM·qty=copies=100):
  제본 COMP_BIND_JUNGCHEOL (PROC018·tier100)                    700.00 × 100 = 70,000
═════════════════════════════════════════════════ 합계 = 158,688  ✓ 오차 0
```

라이브 단가 verbatim 재확인: 350 / 500 / 36.88 / 700 (byte 일치).

---

## 2. ② 068 셋트행 (COMMIT 후 라이브 상태)

| disp_seq | sub_prd_cd | sub_prd_qty | min/max/incr | 공식 | 역할 |
|:--------:|------------|:-----------:|:------------:|------|------|
| 1 | PRD_000288 | 1 | 1/1/NULL | PRF_BOOK_COVER | 표지(인쇄+코팅+용지) |
| 2 | PRD_000287 | 1 | 4/28/4 | PRF_DGP_INNER | 내지(page4~28/+4) |

면지 0(소프트커버). 공식 바인딩: 068→PRF_BIND_SUM·287→PRF_DGP_INNER·288→PRF_BOOK_COVER.

---

## 3. ①b 차원 충전 (COMMIT 후)

| 반제품 | 사이즈 | 인쇄옵션 | 자재 | 판형 | 코팅공정 |
|--------|:------:|:--------:|:----:|:----:|:--------:|
| 표지 288 | 1 (A3펼침 SIZ_000174) | 2 (칼라단/양면) | 8 (USAGE.01·백모120 dflt) | 1 (SIZ_000499) | 1 (PROC_000015) |
| 내지 287 | 3 (A5/B5/A4) | 4 (칼라단/양·흑백단/양·dflt흑백양) | 9 (USAGE.07) | 1 (SIZ_000499) | — |

---

## 4. ⑧ S8 오염 0 (라이브 재확인)

PRF_BOOK_COVER formula_components = `COMP_PRINT_DIGITAL_S1`(seq1) + `COMP_COAT_MATTE`(seq2) + `COMP_PAPER`(seq3) **3개만**. 굿즈/명함/리플렛 후가공 comp 혼입 0. addtn_yn 전부 Y(합산). proc_cd 주입 가드(인쇄 PROC004·코팅 PROC015) → silent 다중매칭 0.

---

## 5. ⑦ 기존 셋트 회귀 0

| 부모 | member 행수 | 비고 |
|------|:----------:|------|
| PRD_000068 | 2 | ★신규(이번 COMMIT) |
| PRD_000072 | 5 | 보존 |
| PRD_000077 | 5 | 보존 |
| PRD_000082 | 6 | 보존 |
| PRD_000094 | 2 | 보존 |
| PRD_000100 | 7 | 보존 |

전체 셋트 부모 8개·구성원 33행(068 추가 정상 증가). 기존 셋트행 변동 0.

---

## 6. undo 방법

`booklet-jungcheol-068-undo.sql` 실행 → 적재분(셋트행2·287/288 차원·반제품·PRF_BOOK_COVER 공식+비목3) 물리 제거 + 068 부모공식 note 백업 스냅샷(`bak_t_prd_product_price_formulas_setbuild_20260701_0134`) 복원. 실행 후 sets/287_288/cover_formula 3행 모두 0이면 baseline 복귀 완료.
