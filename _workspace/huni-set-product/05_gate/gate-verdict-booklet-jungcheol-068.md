# gate-verdict-booklet-jungcheol-068.md — 068 중철 소프트커버 완전 동작화 독립 검증 게이트 (S1~S8)

> 검증자: hsp-set-gate 2026-07-01 · **생성자(set-designer/codex) 주장 비신뢰·직접 재실측** · 라이브 읽기전용 SELECT · DB 미적재(게이트 COMMIT 안 함).
> 검증 대상: `06_load/booklet-jungcheol-068-full-load.sql` + spec + blocked-board.
> 권위[HARD]: `booklet-cover-branch-design.md` rev.2 (G-CB-068A 158,688) · 라이브 t_prc_*/t_prd_* 실측 · pricing.py:844 evaluate_set_price.

---

## 0. 종합 판정 — ✅ **GO (조건부·2트랙 분리)**

| 트랙 | 판정 | 범위 |
|------|:----:|------|
| **① 셋트행+반제품+차원 (t_prd_*)** | ✅ **GO → load-executor 적재 큐** | 셋트행 2(표지288+내지287)·반제품 287/288 mint·표지/내지 차원. 멱등·FK·골든 검증 통과. |
| **② 표지공식 PRF_BOOK_COVER + formula_components 3행 (t_prc_*)** | ⏸ **BLOCKED → §18/dbmap·인간 승인** | set-designer 본분 밖 가격공식 영역. 정의는 게이트 검증 통과(158,688 도달·S8 무오염)·실 COMMIT은 §18 GO + 인간 승인 후. |

★ **핵심 결론**: 068이 골든 **158,688에 정확 도달**(알고리즘 재현·오차 0). 표지 완전 동작. S8 오염 0·판형 저청구 없음. **단 ②(가격공식)와 ①(셋트행) 트랙 분리가 맞음** — ②가 먼저 COMMIT돼야 ①이 실제 평가됨(의존순서: 공식→셋트행). 두 트랙 모두 인간 승인 대상.

---

## 1. S1~S8 판정표

| 게이트 | 판정 | 재실측 증거 |
|--------|:----:|------------|
| **S1 권위 충실성** | ✅ PASS | 단가 라이브 verbatim: 표지인쇄 tier100=**350**·코팅 coat1 tier100=**500**·용지 MAT073@499=**36.88**·제본 JUNGCHEOL tier100=**700**. 158,688 분해(35,000+50,000+3,688+70,000) byte 일치. page_rule 4/28/4·표지 min1/max1 적재본 정합. 날조 0. |
| **S2 구성원 유형** | ✅ PASS | 라이브 실측: 068=`PRD_TYPE.01`(완제품·셋트 완제품 정합). 287/288=`PRD_TYPE.02`(반제품) 적재본 명시·라이브 미존재(mint 정당). 완제품/기성/디자인 혼입 0. 셋트행 2(소프트커버 면지 0). |
| **S3 복합PK/FK** | ✅ PASS | search-before-mint: MAX prd_cd=**PRD_000286**·287/288 라이브 미존재 → 채번 정합. FK 타깃 전건 실재: SIZ_000174(A3)/499(국4절)/170(A5)/172(A4)·MAT_000073(백모120)·POPT_000001/002/008/009·PROC_000004/015/018·CLR_000001/005. 복합PK ON CONFLICT 멱등. min1≤base1≤max1(표지)·4≤base≤28 incr4(내지) 정합. |
| **S4 가격 e2e [HARD]** | ✅ PASS | **evaluate_set_price 알고리즘 재현 = 158,688 (오차 0)**. plate_qty(100,pansu1)=100·표지 88,688+제본 70,000. 표지 3비목+제본 각 매칭행 정확히 1행(ERR_AMBIGUOUS/DUPLICATE 0). 이중합산 0(비목 단일귀속). → `price-e2e-trace-booklet-jungcheol-068.md`. |
| **S5 판형 매칭 정당성** | ✅ PASS | `fn_calc_pansu(499,174)=1` 실측 → 표지 1매=1판=정확 청구. A4(172) pansu=2(÷2 저청구) 부결·499자신=0 부결 라이브 재확인. ★068 완제품 자기 판형=SIZ_000250/251/252/181(SIZ_000499 없음) → 부모공식 직배선 시 표지 단가행(499) 매칭 불가 → **member 분리(499 판형 부여) 필연** 검증됨(적재본 line 308 주장 확증). |
| **S6 적재 가능성 DRY-RUN** | ✅ PASS | BEGIN→적재본→ROLLBACK 제약위반 0. INSERT 카운트: 셋트행 2·표지자재 8·표지사이즈 1·fc 3·반제품 287/288. **멱등 2회차 INSERT/UPDATE delta=0**(ON CONFLICT DO NOTHING + WHERE IS DISTINCT FROM 가드). ROLLBACK 후 287/288 미존재·068 셋트행 0·PRF_BOOK_COVER 미존재 = baseline 완전 복귀·DB 미적재. |
| **S7 생성≠검증 독립성** | ✅ PASS | 게이트 직접 재실측(라이브 단가행·fn_calc_pansu·match 카운트·DRY-RUN)으로 판정 — designer 손계산 인용 아님. codex reconcile-068-071(6/29) **Q-A(표지 용지비 누락·NO-GO 후보)** = 이 full-load(7/1)가 표지용지 COMP_PAPER 3,688을 member288에 명시 단일귀속해 **해소**(codex 권고 선택지 a 정합). 미해결 reconcile 0. |
| **S8 구성요소 경계 무오염 [HARD]** | ✅ PASS | PRF_BOOK_COVER = 인쇄S1+코팅MATTE+용지PAPER **3비목만**(후가공/굿즈 comp 혼입 0). 코팅포함 공식 전수=PRF_DGP_A/A_FOIL/D/E/E_FOIL — PRF_DGP_A에 CORNER_RIGHT/CREASE/PERF/VARTEXT/SPOT_WHITE·PRF_DGP_E에 FOLD_LEAF/CUT_PERF 혼입 실측 → 빌리기 부결 정당. proc_cd 주입 가드: S1·COAT use_dims에 proc_cd + SIZ_000499에서 각 proc 1종(004/015)만 → silent 다중매칭 0. 표지 자재 8종 ⊂ 068 완제품 USAGE.01 13종(경계 안). |

**단일 FAIL = NO-GO 규칙 → FAIL 0 → 종합 GO(조건부·②트랙 BLOCKED 분리).**

---

## 2. 158,688 도달 여부 (실호출 재계산값)

```
[알고리즘 재현·라이브 단가 실측]
표지 member 288 (qty=copies=100·PRF_BOOK_COVER·pansu=1):
  표지인쇄 COMP_PRINT_DIGITAL_S1  350.00 × 100 = 35,000
  표지코팅 COMP_COAT_MATTE        500.00 × 100 = 50,000
  표지용지 COMP_PAPER(백모120)     36.88 × 100 =  3,688
  ─────────────────────────────── 표지 소계 = 88,688
셋트공식 068 (qty=copies=100·PRF_BIND_SUM):
  제본 COMP_BIND_JUNGCHEOL        700.00 × 100 = 70,000
═══════════════════════════════════ 합계 = 158,688  ✓ (오차 0)
```
+ 내지 member 287(PRF_DGP_INNER·page파생) 별도 가산 — 골든 158,688은 표지+제본 정의.

---

## 3. S8 오염·판형 결판

- **S8 오염 = 없음**. 표지공식 PRF_BOOK_COVER 깔끔 3비목·후가공 무혼입. proc_cd 주입으로 silent 다중매칭 0. JUNGCHEOL proc 1종이라 071 TWINRING(4 proc_cd) 다중매칭 위험과 무관.
- **판형 저청구 = 없음**. fn_calc_pansu(499,174)=1 → 표지 정확 1판. A4(pansu=2) 미채택·SIZ_000174(A3펼침) 채택이 옳음. member 분리는 완제품 판형(250)≠단가행 판형(499) 차이로 필연(직배선 불가).

---

## 4. 실 COMMIT 가능분 vs BLOCKED분 (트랙 분리)

| 트랙 | 대상 t_* | 위상 | 라우팅 | 인간 승인 |
|------|---------|------|--------|:--------:|
| **GO·load-executor** | t_prd_products(287/288)·t_prd_product_sizes·_print_options·_materials·_plate_sizes·_processes·t_prd_product_price_formulas(287→INNER·288→COVER·068→BIND_SUM)·t_prd_product_sets(2행) | 1~4·6·7·8·9 | hsp-load-executor | 필요 |
| **BLOCKED·§18/dbmap** | t_prc_price_formulas(PRF_BOOK_COVER)·t_prc_formula_components(3행) | 5a·5b | §18 가격공식 설계 GO + dbmap COMMIT | 필요 |

★ **의존 순서 [HARD]**: ② PRF_BOOK_COVER(t_prc_*)가 먼저 COMMIT돼야 ① 위상8(288→PRF_BOOK_COVER 바인딩)이 FK상 유효·표지 평가 가능. 따라서 **② → ① 순서로 적재**(②만 적재되고 ①이 안 되면 표지 평가 안 됨·①만 적재되고 ②가 안 되면 표지 견적 0).

---

## 5. 인간 승인 큐

1. **[Critical·돈크리티컬·t_prc_*] PRF_BOOK_COVER 신규공식 + formula_components 3행** — §18 가격공식 설계 GO 받고 dbmap COMMIT. 이 공식 없으면 표지 전액 0(저청구 88,688/권). 게이트 검증: 정의 정합·158,688 도달·S8 무오염 PASS. → BLOCKED-COVER-FORMULA-MINT.
2. **[High·t_prd_*] 068 셋트행 2 + 반제품 287/288 + 차원** — load-executor 적재(②선행 후). 멱등·FK·골든 PASS.
3. **[Med·선택·dbmap] 068 완제품 USAGE.01 자재 link 일관성** — 표지 member 8종 ⊂ 완제품 13종(견적 미관여·정합 점검). → BLOCKED-MAT-REWIRE-OPTIONAL.
4. **[Med·C트랙·개발팀] DBLPANSU 내지 이중÷pansu** — price_views.py:1707·전 책자 공통·내지비 환산 영향(표지/제본 무영향)·1회 교정이 068~072/077/082 동시 해소. → NOTE-DLBPANSU-INNER.

---

## 6. 검증 안전 확인

- 라이브 읽기전용 SELECT만 · DRY-RUN BEGIN…ROLLBACK(COMMIT 0) · DB 미적재(baseline 복귀 실증) · 비밀값 비노출.
- 생성자 주장 자동 신뢰 0 — 모든 수치 라이브 재실측. 근거 못 찾은 항목 0(전 게이트 증거 확보).
