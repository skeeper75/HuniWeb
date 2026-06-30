# NEEDS_FORMULA 고아 7건 §18 가격엔진 설계 명세 — 엽서북30p·캘린더제본·접지카드·폼보드/포맥스

- 입력: `wiring/orphan-classification-260701.md`(표 #9~15) · 권위 `live-snapshot/latest/` · 마스터 `24_master-extract-260610/` · 엔진 `raw/webadmin/.../catalog/pricing.py`
- 작업: **설계 명세까지**(실 COMMIT 없음·DB 미적재·생성≠검증). 단가=가격표 verbatim(날조 0).
- 산출일: 2026-07-01 · 생성측(검증·codex·PRICE≠0 실호출은 후속 별도 패스)

---

## 0. 핵심 결론 (먼저)

7건을 정밀 재실측한 결과 **분류가 갈린다 — 강제 설계 거부([HARD] 억지 배선 금지)**:

| 패밀리 | comp | 판정 | 근거 |
|---|---|---|---|
| **A. 엽서북 30p** PRD_000094 | COMP_PCB_S1_30P·S2_30P | **DESIGNABLE(설계 가능)** | 페이지수 opt_cd 판별차원 신설 + print_opt_cd 보강 → (print_opt×page) 4조합 완전 disjoint 입증. §7 페이지수 선택수단 신설 동반. |
| **B. 캘린더 제본** PRD_000108~112 | COMP_BIND_CAL_WALL | **BLOCKED** | ① 캘린더 가격공식 전무 ② **제본 proc_cd 불일치**(comp=99/100/101/102 ↔ 상품 process=76수축/79타공/21트윈링) → 배선해도 영구 no_match ③ 디지털인쇄 본문(장수×) 가격 본체 미설계. 3중 선행. |
| **C. 접지카드** (COMP_FOLD_CARD) | COMP_FOLD_CARD_3H·6CR | **BLOCKED** | 활성 접지카드 가격경로 = PRF_DGP_E + **병렬 COMP_FOLD_LEAF_*** 패밀리(3FOLD 등 이미 존재). FOLD_CARD는 PRF_FOLD_SUM(048 단독·2H만·옵션그룹0)에만 잔존 → 이중과금 위험·접지유형=상품식별(027/029)이지 옵션택1 아님·048 미구성. 패밀리 권위 충돌→실무진. |
| **D. 폼보드/포맥스** PRD_000129/130 | COMP_POSTER_FOAMBOARD_BLACK·FOMEXBOARD_WHITE5MM | **DESIGNABLE(배선 안전)·§7 선행** | siz_cd disjoint(白174/197/293 ↔ 黑315/317·3mm174/197 ↔ 5mm315/317) → 배선 무해. 단 product_sizes에 315/317 미등록 → 고객 선택불가(배선 inert). §7 사이즈 등록이 발현 조건. |

**즉시 발현 설계 = A(완전)·D(배선+§7 사이즈). B·C = BLOCKED(선행 미충족·강등).**

근본원리 [HARD]: 엔진 `_row_matches`(L94)+`match_component`(L134) — 판별 비수량차원(NON_QTY_DIMS) 없는 단가행=와일드카드=항상 매칭→addtn_yn=Y 무조건 합산. 형제 옆 무판별 배선=동시합산 과대청구. 각 변형을 disjoint 판별차원으로 가른 뒤에만 배선.

---

## A. 엽서북 30p (PRD_000094) — COMP_PCB_S1_30P·S2_30P 【DESIGNABLE】

### A.1 현황 실측
- 공식 PRF_PCB_FIXED(바인딩O) ← COMP_PCB_S1_20P(seq1)·S2_20P(seq2)만 배선. **30P 2건 미배선=고아.**
- comp_typ=PRC_COMPONENT_TYPE.06(완제품가)·prc_typ=PRICE_TYPE.01(단가형=장당가×수량)·각 117행.
- **판별차원 실측**:
  - 20P comps: `use_dims=[siz_cd, min_qty, print_opt_cd]` · 행에 print_opt_cd 충전(S1_20P=POPT_000001 단면 / S2_20P=POPT_000002 양면) · **opt_cd=NULL**
  - 30P comps: `use_dims=[siz_cd, min_qty]` · 행에 **print_opt_cd=NULL · opt_cd=NULL** (둘 다 와일드카드)
- 근본결함: **페이지수(20p/30p) 축이 엔진에 부재.** 30p를 그냥 배선하면 30P(print_opt NULL=와일드카드)가 모든 주문에 매칭→S1_20P+S1_30P 동시합산 과대청구. print_opt만 보강해도 페이지축 없으면 20p·30p 구별 불가.

### A.2 판별차원 설계 (search-before-mint)
- search 결과: 라이브에 **페이지/장수 옵션그룹 0건**(`grep 페이지|장수|면수` → none) → 재사용 불가, 신규 mint 정당.
- 판별차원 = **opt_cd(페이지수) + print_opt_cd(단/양면)** 2축 교차. 페이지수 opt-value 신설:
  - `OPV_PCB_PAGE_20P`(20P) · `OPV_PCB_PAGE_30P`(30P) — 채번/코드체계 최종확정=dbm-axis-staged-load(§7) 위임. 본 설계는 의미값 고정.
- **disjoint 입증** (4 comp × (print_opt_cd, opt_cd)):

  | comp | print_opt_cd | opt_cd(page) |
  |---|---|---|
  | COMP_PCB_S1_20P | POPT_000001 | OPV_PCB_PAGE_20P |
  | COMP_PCB_S2_20P | POPT_000002 | OPV_PCB_PAGE_20P |
  | COMP_PCB_S1_30P | POPT_000001 | OPV_PCB_PAGE_30P |
  | COMP_PCB_S2_30P | POPT_000002 | OPV_PCB_PAGE_30P |

  임의 주문 (print_opt, page) 고정 시 정확히 1 comp만 매칭 — 4조합 상호 배타. ✅ ([HARD] 이중배선 가드 충족)
- ★[HARD] 20P 행에도 opt_cd 충전 필수: 안 하면 S1_20P(opt NULL=와일드)가 30p 주문(POPT1)에도 매칭→S1_30P와 동시합산. 그래서 **20P 234행 opt_cd 보강 + 30P 234행 opt_cd+print_opt_cd 보강**이 한 묶음.

### A.3 선택수단 설계 [HARD] (§7 동반)
- 엽서북 옵션그룹 실측: 사이즈/내지종이/내지인쇄(=단·양면 print_opt)/표지종이/표지인쇄/표지코팅/제본/셋트구성. **페이지수 그룹 없음** → 고객이 20p/30p를 고를 수 없음.
- 신설: 옵션그룹 `페이지수`(sel_typ 택1 필수, MAX(opt_grp)=OPT_000079 → **OPT_000080**) + item(20P→OPV_PCB_PAGE_20P / 30P→OPV_PCB_PAGE_30P, ref_dim_cd=opt_cd) + PRD_000094 매핑.
- 이 선택수단 없으면 배선 무효(고객이 30p 미선택→항상 20p). §7 상품구성 소관·dbmap 위임.

### A.4 배선 + 단가행
- formula_components: PRF_PCB_FIXED ← COMP_PCB_S1_30P(seq3)·S2_30P(seq4) addtn_yn=Y 추가(각 comp 독립 매칭이라 형제와 합산 아님·disjoint).
- component_prices: 단가값 **변경 없음**(verbatim 유지). opt_cd/print_opt_cd **판별차원만 채움**(20P 234행 opt_cd / 30P 234행 opt_cd+print_opt_cd). use_dims 4 comp 갱신.

### A.5 골든 (verbatim·검증가 재현 대상)
단가형(PRICE_TYPE.01): subtotal = unit_price × qty.

| 케이스 | comp/행 | 권위단가(verbatim) | qty | 골든 subtotal | 현행(오산정) |
|---|---|---|---|---|---|
| 30p·단면·100×150(SIZ_000003)·qty2 | S1_30P | 11,500 | 2 | **23,000** | 30p 선택불가→20p 11,000×2=22,000(저청구 −1,000) |
| 30p·단면·100×150·qty4 | S1_30P | 9,900 | 4 | **39,600** | 20p 9,100×4=36,400(−3,200) |
| 30p·양면·100×150·qty2 | S2_30P | 12,500 | 2 | **25,000** | 20p양면 11,500×2=23,000(−2,000) |
| 30p·단면·135×135(SIZ_000004)·qty2 | S1_30P | 12,500 | 2 | **25,000** | 20p 12,000×2=24,000(−1,000) |
| 20p·단면·100×150·qty2 (회귀=불변) | S1_20P | 11,000 | 2 | **22,000** | 22,000(불변·disjoint 확인) |

돈영향: 30p 전 사이즈·수량 저청구 해소(권당 +500~1,000+). 단가 출처 = `t_prc_component_prices` 행 3442/3454/3444/3450 등.

---

## B. 캘린더 제본 (PRD_000108~112) — COMP_BIND_CAL_WALL 【BLOCKED·강등】

### B.1 현황 실측
- 5상품: 108 탁상형·109 미니탁상형·110 엽서캘린더·111 벽걸이·112 와이드벽걸이.
- **product_price_formulas 0행 = 견적 불가(0).** comp는 proc_cd 판별 준비완료(use_dims=[proc_cd,min_qty,proc_grp:PROC_000017]).
- 단가행 24행(verbatim): PROC_000099 벽걸이제본(1→5000/4→4000/10→3000/50→2500/100·1000→2000) · PROC_000100 탁상220 · PROC_000101 탁상130 · PROC_000102 미니. prc_typ=PRICE_TYPE.01.

### B.2 BLOCKED 3중 사유 (억지 설계 거부)
1. **공식 전무**: 캘린더 가격공식이 한 건도 없음. 캘린더 가격 = 디지털인쇄 본문(장수 4~16장·8~32P) + 제본 + 가공추가가(삼각대0/트윈링2000) + 추가상품. 마스터 실측상 **단일 "캘린더 완제품가" 단가 없음** → 본문(장수×) 가격 모델이 선행돼야 함(엽서북식 inner/디지털 멀티페이지 미설계).
2. ★**제본 proc_cd 불일치(돈크리티컬)**: COMP_BIND_CAL_WALL 행 = PROC_000099/100/101/102(=캘린더제본). 그러나 상품 process 실측 = 108/109→PROC_000076(수축포장)·110→079(타공)·111→021(트윈링)+079·112→021. **어떤 캘린더 상품도 99/100/101/102를 가지지 않음** → 배선해도 손님 선택에 proc 99-102가 안 실려 영구 no_match(제본비 0). 탁상형은 제본 process 자체 미할당.
3. **proc_grp 가정**: comp use_dims `proc_grp:PROC_000017` 게이트가 상품 공정트리에 정합하는지 미검증.

### B.3 설계 스케치(선행 충족 시·미적재)
- 캘린더 공식 신설 PRF_CAL_*(상품별 또는 유형별): COMP_PRINT_DIGITAL_S1/S2(본문·장수 페이지축) + COMP_BIND_CAL_WALL(제본·proc_cd) + 가공추가가 + 추가상품. proc_cd(99/100/101/102)는 disjoint(설계는 건전)이나 **상품 process 재할당이 선결**.
- 라우팅: §7(상품 process 99-102 재할당·캘린더제본 정합) → §18(디지털 본문 장수 가격 모델·공식 신설) → 실무진(가공추가가 vs COMP_BIND 단가 이중권위 확인: 마스터 "고리형트윈링제본 2000" vs COMP 5000~2000). DB 미적재.

---

## C. 접지카드 (COMP_FOLD_CARD_3H·6CR) 【BLOCKED·강등】

### C.1 현황 실측 — 패밀리 권위 충돌 발견
- COMP_FOLD_CARD_2H/3H/6CR: use_dims=[min_qty]만(판별차원 0)·prc_typ=PRICE_TYPE.01. note "작업 1건 고정 금액(수량을 곱하지 않음)" ↔ prc_typ.01(단가형×수량) **불일치(별건 결함·2H에도 기존재)**.
- **활성 접지카드/리플렛 가격경로 = PRF_DGP_E**("인쇄비+코팅+용지+접지비+후가공+박+추가"). 접지카드 027(2단)·029(3단) → PRF_DGP_E + 2026-07-01 **PRF_DGP_E_FOIL(박분기 클론)** 재바인딩(활성).
- **PRF_DGP_E의 접지비 = 병렬 COMP_FOLD_LEAF_* 패밀리**(HALF/3FOLD/4ACC/4GATE, seq4~7 배선됨). 즉 3단 접지비는 이미 **COMP_FOLD_LEAF_3FOLD**로 과금 중.
- COMP_FOLD_CARD_*는 **PRF_FOLD_SUM(048 접지리플렛 단독)** 에만 잔존(2H만 배선). 048은 옵션그룹 0·product_sizes 0(미구성).

### C.2 BLOCKED 사유
1. **이중과금 위험(돈크리티컬)**: FOLD_CARD_3H를 접지카드 활성공식(PRF_DGP_E)에 배선하면 이미 있는 FOLD_LEAF_3FOLD와 3단 접지비 **이중 합산**. 어느 패밀리가 권위인지 실무진 확정 필요.
2. **접지유형=상품식별이지 옵션택1 아님**: 2단접지카드(027)·3단접지카드(029)는 **별 상품**(각자 공식 바인딩). 028/029/027의 "접지" 옵션그룹(OPT_000032/037)은 [묶음 동일단가: 가로접지/세로접지]=접지방향이지 단수 아님. 분류 가정("접지유형 택1 opt_cd")이 라이브 모델과 불일치.
3. **6CR 호스트 미식별**: 6단/6크리즈 접지카드 상품 부재(027/028/029=2단/미니/3단). PRF_FOLD_SUM 호스트 048도 미구성.
4. FOLD_CARD 패밀리 = 싸바리式 **superseded 후보**(활성 LEAF로 대체) 강한 신호.

### C.3 조건부 설계(권위 확정 시)
- IF 실무진이 "FOLD_CARD가 권위·접지리플렛 048이 2단/3단/6크리즈 택1 제공" 확정 → 048 단일상품 내 접지유형 opt_cd(2H/3H/6CR) 신설+3 comp opt_cd 충전+택1 옵션그룹+PRF_FOLD_SUM 배선(disjoint).
- IF "FOLD_LEAF가 권위" 확정 → COMP_FOLD_CARD_3H/6CR = superseded → use_yn=N 후보(삭제금지).
- 라우팅: 실무진/goods.asp(권위 패밀리·048 모델·6CR 호스트) → 확정 후 §18. **추측 배선 금지**(이중과금 방지).

---

## D. 폼보드/포맥스 (PRD_000129/130) — BLACK·WHITE5MM 【DESIGNABLE·배선 안전·§7 선행】

### D.1 현황 실측 — 배선 안전(disjoint) 입증
- comp_typ=.06(완제품가·출력+코팅+가공 포함)·prc_typ=PRICE_TYPE.01·use_dims=[siz_cd].
- **siz_cd disjoint 입증**:

  | 공식 | 배선됨(형제) | siz_cd | 고아 | siz_cd | 교집합 |
  |---|---|---|---|---|---|
  | PRF_POSTER_FOAMBOARD(PRD_000129) | COMP_..FOAMBOARD_WHITE | 174(A3)/197(A2)/293(A1) | COMP_..FOAMBOARD_**BLACK** | 315(A3)/317(A2) | **∅** |
  | PRF_POSTER_FOMEXBOARD(PRD_000130) | COMP_..FOMEXBOARD_WHITE3MM | 174/197 | COMP_..FOMEXBOARD_**WHITE5MM** | 315/317 | **∅** |

  siz_cd가 형제와 완전 disjoint → 같은 공식에 배선해도 동시매칭 0(한 siz_cd 주문에 1 comp만). ✅ 배선 자체 무해.
- ★단 발현 차단: **product_sizes 실측 = 129·130 모두 {174,197}만 등록**. 黑보드(315/317)·5mm(315/317) **미등록** → 고객이 그 사이즈 선택 불가 → 배선해도 가격변화 0(inert).

### D.2 선택수단 설계 [HARD] (§7/§21 선행)
- §7 product_sizes에 등록: PRD_000129 ← SIZ_000315(폼보드 블랙 A3)·SIZ_000317(블랙 A2) / PRD_000130 ← SIZ_000315(포맥스5mm A3)·SIZ_000317(5mm A2).
- 제시 방식: 보드색상(화이트/블랙)·두께(3mm/5mm) 옵션 or 사이즈리스트 직접 노출 — 단, siz_cd가 (사이즈×색상/두께)를 이미 인코딩(白A3=174≠黑A3=315)하므로 **사이즈 등록만으로 환원 충분**(별도 색상축 불요·search-before-mint). dbmap/§21 위임.
- 권위성: 단가행이 라이브에 적재됨(가격표 권위에 黑보드·5mm 존재) → 변형은 의도된 상품. 갭=등록 누락뿐.

### D.3 배선 + 골든 (verbatim)
- formula_components: PRF_POSTER_FOAMBOARD ← COMP_POSTER_FOAMBOARD_BLACK(seq2) / PRF_POSTER_FOMEXBOARD ← COMP_POSTER_FOMEXBOARD_WHITE5MM(seq2). addtn_yn=Y. (disjoint→안전)
- 단가행 변경 0(verbatim).

| 케이스 | comp/행 | 권위단가 | qty | 골든 | 현행 |
|---|---|---|---|---|---|
| 폼보드 블랙 A3(SIZ_000315)·qty1 | FOAMBOARD_BLACK(4783) | 8,500 | 1 | **8,500** | 315 미등록→선택불가/견적0 |
| 폼보드 블랙 A2(SIZ_000317)·qty1 | FOAMBOARD_BLACK(4784) | 14,000 | 1 | **14,000** | 견적0 |
| 포맥스 5mm A3(SIZ_000315)·qty1 | FOMEXBOARD_WHITE5MM(4789) | 10,000 | 1 | **10,000** | 견적0 |
| 포맥스 5mm A2(SIZ_000317)·qty1 | FOMEXBOARD_WHITE5MM(4790) | 16,000 | 1 | **16,000** | 견적0 |
| 폼보드 화이트 A3(174)·qty1 (회귀=불변) | FOAMBOARD_WHITE | 6,000 | 1 | **6,000** | 6,000(불변·disjoint) |

돈영향: 黑보드·5mm 변형 견적0→정상가 회복(배선 dryrun은 무해·발현은 §7 사이즈 등록 후).

---

## 4. 분류·라우팅 종합

| 패밀리 | comp수 | 판정 | dryrun 활성 | 선행/라우팅 |
|---|---|---|---|---|
| A 엽서북30p | 2 | DESIGNABLE | 배선2 + 판별차원 보강(20P234+30P234행) + §7 옵션그룹 | §7(페이지수 OPT_000080·dbm-axis-staged-load) |
| B 캘린더제본 | 1 | **BLOCKED** | 0 | §7(proc 99-102 재할당)+§18(본문 장수 모델·공식 신설)+실무진(가공가 이중권위) |
| C 접지카드 | 2 | **BLOCKED** | 0 | 실무진/goods.asp(FOLD_CARD vs FOLD_LEAF 권위·048 모델·6CR 호스트)·이중과금 가드 |
| D 폼보드/포맥스 | 2 | DESIGNABLE(배선안전) | 배선2 (disjoint·무해) | §7/§21(product_sizes 315/317 등록=발현조건) |

- **즉시 발현(설계 완결)**: A(완전·§7 동반) · D 배선(안전, §7 사이즈로 발현).
- **BLOCKED 강등**: B·C — 억지 배선 거부([HARD]). 선행 미충족.
- 검증(생성≠검증): 본 설계는 생성측. codex 교차·E게이트·PRICE≠0 실호출·disjoint 실증은 후속 패스. 골든 수치는 verbatim 근거 제시.
- dryrun = `design-bind-fold-board-dryrun.sql`(BEGIN…ROLLBACK·NOT EXISTS 멱등·COMMIT 없음). A·D만 활성, B·C는 차단 주석.

## 5. 컨펌큐 (인간/실무진)
1. **A**: 페이지수 옵션(20P/30P)을 엽서북 손님 UI에 신설 노출 OK? 20P 234행 opt_cd 보강(데이터 변경) 승인?
2. **B**: 캘린더제본 공정(99/100/101/102)을 상품(108~112) process에 재할당해야 함 — 누가/언제? 가공추가가(트윈링2000 등) vs COMP_BIND 단가(5000~2000) 중 어느 게 손님청구 권위?
3. **C**: 접지비 권위 패밀리 = COMP_FOLD_CARD(레거시) vs COMP_FOLD_LEAF(활성) 택1 확정. 접지리플렛048이 3단/6크리즈 제공? 6단접지카드 상품 존재?
4. **D**: 폼보드 블랙·포맥스5mm를 손님 판매상품으로 노출 OK?(가격표엔 적재됨) → product_sizes 315/317 등록 승인.
