# booklet-museon-pur-069-070-commit-log.md — 069 무선·070 PUR 소프트커버 완전 동작화 라이브 COMMIT 로그

> 실행자: hsp-load-executor 2026-07-01 02:04~ · 라이브 운영 DB(Railway `railway`) · 게이트 GO(둘 다) + codex reconcile 합의 + 인간 승인("지금 둘 다 COMMIT") · COMMIT 성공(EXIT=0).
> 안전 프로토콜: 077/082/068 COMMIT과 동일(백업→DRY-RUN→단일 트랜잭션 COMMIT→사후 재실측→undo 보유). 자격증명 `.env.local RAILWAY_DB_*`(비노출).

---

## 0. 종합 — ✅ COMMIT 성공·골든 정확 도달·회귀 0

| 항목 | 069 무선 | 070 PUR |
|------|:--------:|:-------:|
| **셋트행 INSERT** | 2 (표지290 seq1 + 내지289 seq2) | 2 (표지292 seq1 + 내지291 seq2) |
| **반제품 mint** | PRD_000289(내지)·290(표지) | PRD_000291(내지)·292(표지) |
| **골든 evaluate_set_price** | **138,688** (오차 0) | **288,688** (오차 0) |
| **S8 오염** | 0 | 0 |

★ 신규 t_prc_* 공식 0 (PRF_BOOK_COVER·PRF_DGP_INNER·PRF_BIND_MUSEON·PRF_BIND_PUR 전부 라이브 실재·068에서 COMMIT됨) → t_prd_* 단일 트랙 COMMIT.

---

## 1. 실행 전제 3조건 (모두 충족)

- (a) **게이트 GO**: `gate-verdict-booklet-museon-pur-069-070.md` S1~S8 전부 PASS·FAIL 0 → 069·070 둘 다 종합 GO.
- (b) **codex reconcile 합의**: 게이트 S7 — 068 reconcile Q-A 표지용지 누락이 member 단일귀속으로 해소된 패턴 전파·미해결 0.
- (c) **인간 승인**: 사용자 "지금 둘 다 COMMIT" 명시.

---

## 2. 적재 직전 라이브 실측 (search-before-mint·FK 선행)

| 검사 | 결과 |
|------|------|
| MAX prd_cd | **PRD_000288** → 289~292 채번 정합 |
| 289~292 존재 | **0행**(mint 정당) |
| 069/070 완제품 | 실재·PRD_TYPE.01·del_yn=N (FK 부모 OK) |
| 069/070 셋트행 baseline | **0행** |
| 재사용 공식 4종 | PRF_BOOK_COVER/PRF_DGP_INNER/PRF_BIND_MUSEON/PRF_BIND_PUR 전부 use_yn=Y |
| PRF_BOOK_COVER 비목 | 정확히 3개(S1+COAT_MATTE+PAPER·후가공 무혼입) |
| fn_calc_pansu(499,174) | **1**(표지 1판·저청구 가드) |
| FK 타깃 전건 | SIZ 4·POPT 4·PROC 4(t_proc_processes)·CLR 2(t_clr_color_counts)·MAT 13·USAGE.01/.07·OUTPUT_PAPER_TYPE.01·PRD_TYPE.02(t_cod_base_codes) 전부 실재 |

---

## 3. 물리 백업 (시점 스냅샷·`*_setbuild_20260701_0204`)

| 백업 테이블 | 행수 |
|------------|:----:|
| bak_t_prd_products_setbuild_20260701_0204 | 2 (069/070 부모만·289~292 신규=0) |
| bak_t_prd_product_sets_setbuild_20260701_0204 | 0 (069/070 baseline) |
| bak_t_prd_product_price_formulas_setbuild_20260701_0204 | 4 (069/070 제본 부모 바인딩) |
| sizes/print_options/materials/plate_sizes/processes | 0 each (289~292 신규) |

---

## 4. DRY-RUN (BEGIN…ROLLBACK·EXIT=0)

- 1회차 적재: 제약위반 0. products 289~292=4·069셋트=2·070셋트=2·표지자재 290/292 each 7·내지자재 289/291 each 6·공식바인딩 289/291=INNER·290/292=COVER.
- 2회차 멱등 재적재: 36 statement 전건 INSERT 0 0·UPDATE 0행 → **delta 0**.
- FK 고아 검사 = 0.
- ROLLBACK 후 baseline 복귀(289~292=0·069/070 셋트=0) → DB 미적재 실증.

---

## 5. 실 COMMIT (`booklet-museon-pur-069-070-apply.sql`·단일 트랜잭션·EXIT=0)

- BEGIN → 069 적재본 → 070 적재본 → COMMIT. ON_ERROR_STOP=on.
- INSERT 카운트(트랜잭션 1회): PART A(공식 NO-OP) INSERT 0 0 ×2·반제품 289/290/291/292 each·셋트행 069×2·070×2·자재/사이즈/판형/인쇄옵션/코팅 전건 적재.
- 부모 제본 바인딩 PRF_BIND_MUSEON/PRF_BIND_PUR = 멱등 NO-OP(이미 라이브).

---

## 6. 사후 재실측 (라이브 COMMIT 후)

| # | 검증 | 결과 |
|:-:|------|------|
| ① | 289~292 실재·PRD_TYPE.02·del_yn=N·차원 충전(표지자재7/내지자재6·표지사이즈174/내지170,172·판형499)·page_rule 24/300/2 | ✅ |
| ② | 069/070 셋트행 0→2행 each (표지 seq1 min1/max1 + 내지 seq2 24/300/2) | ✅ |
| ③ | evaluate_set_price 알고리즘 재현 = 069:**138,688** / 070:**288,688** (오차 0) | ✅ |
| ④ | S8 오염 0 (PRF_BOOK_COVER=288/290/292 표지 member 전용·비목 3개 불변·제본 MUSEON 019만/PUR 020만 단일 proc_cd) | ✅ |
| ④ | FK 고아 0·복합PK 중복 0 | ✅ |
| ⑤ | COMMIT 후 재-dryrun delta 0 (36 statement 전건 INSERT 0·멱등) | ✅ |
| ⑥ | 기존 셋트 회귀 0 (068=2·072=5·077=5·082=6 불변·068 표지288+내지287 무손상) | ✅ |

### evaluate_set_price 재현 (라이브 단가 verbatim·100부·A3펼침·칼라단면·백모120 무광·pansu=1)
```
표지 member (290/292·PRF_BOOK_COVER·qty=copies×cover_mult(×1)=100):
  인쇄 COMP_PRINT_DIGITAL_S1@499 POPT001 PROC004 min100 = 350 ×100 = 35,000
  코팅 COMP_COAT_MATTE@499 coat1 PROC015 min100        = 500 ×100 = 50,000
  용지 COMP_PAPER MAT_000073(백모120)@499              = 36.88 ×100 = 3,688
  ───────────────────────────── 표지 소계 = 88,688 (069/070 공통)
셋트 부모 제본 (qty=copies=100):
  069 COMP_BIND_MUSEON PROC019 min100 = 500 ×100 = 50,000  → 069 = 138,688 ✓
  070 COMP_BIND_PUR    PROC020 min100 = 2000×100 = 200,000 → 070 = 288,688 ✓
```

---

## 7. UNDO 방법 (`booklet-museon-pur-069-070-undo.sql`)

- 289~292는 신규 mint(백업 시점 0행)이므로 **물리 DELETE가 무손상 역연산**(del_yn 복원 아님 — 적재 전 0행).
- FK 역위상순: 셋트행 DELETE → 289~292 자식행(price_formulas/processes/plate_sizes/materials/print_options/sizes) DELETE → 반제품 DELETE → 069/070 부모 바인딩 note 백업 복원.
- 검증: 289~292=0·069/070 셋트=0 복귀.

---

## 8. 잔존 BLOCKED (이번 COMMIT 밖·인간 결정/타 트랙)

| 코드 | 내용 | 라우팅 |
|------|------|--------|
| **071 트윈링 cover_mult ×2** | 엔진 ×2 미지원(BLOCKED)·069/070 무관(둘 다 cover_mult=1) | C트랙(개발팀) |
| **088 레더링바인더·DBLPANSU** | C트랙·표지/제본 무영향 | 개발팀 1회 교정 |
| **BLOCKED-MAT070-LINK** | 070 완제품 자재 link 0행·견적 미관여(member에 충전됨) | dbmap(선택) |
| **NA-FOIL-VARIANT** | PRF_BIND_MUSEON_FOIL/PUR_FOIL(박 후가공·별 공식)·기본가 무영향 | 건드리지 않음 |
| **usage_cd 표시명 정합** | 가격 무관·표시만 | dbmap 점검 큐 |

---

## 9. 안전 확인

- 라이브 자격증명 `.env.local RAILWAY_DB_*`만 사용·stdout/산출물 비노출·.env.local chmod 600·gitignore 확인.
- 비인가 COMMIT 0(적재본 BEGIN/COMMIT 미내장·apply.sql 래핑만·미승인 행 0).
- 물리 DELETE 0(undo 외)·라이브 파괴적 쓰기는 승인된 COMMIT 단일 트랜잭션만.
