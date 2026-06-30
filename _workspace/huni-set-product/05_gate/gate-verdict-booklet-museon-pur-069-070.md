# gate-verdict-booklet-museon-pur-069-070.md — 069 무선·070 PUR 소프트커버 완전 동작화 독립 검증 게이트 (S1~S8)

> 검증자: hsp-set-gate 2026-07-01 · **생성자(set-designer/codex) 주장 비신뢰·직접 재실측** · 라이브 읽기전용 SELECT · DB 미적재(게이트 COMMIT 안 함).
> 검증 대상: `06_load/booklet-museon-069-load.sql`·`booklet-pur-070-load.sql` + `booklet-museon-pur-069-070-load-spec.md` + blocked-board.
> 권위[HARD]: `booklet-cover-branch-design.md`(069=PRF_BIND_MUSEON·070=PRF_BIND_PUR·page 24/300/2·분해형 펼침 cover_mult=1) · 068 게이트 GO(동형 기준) · 라이브 t_prc_*/t_prd_* 실측 · pricing.py:844 evaluate_set_price.

---

## 0. 종합 판정 — ✅ **GO (069·070 둘 다·068보다 단순)**

| 셋트 | 판정 | 골든 재계산 | 범위 |
|------|:----:|:-----------:|------|
| **069 무선** | ✅ **GO → load-executor 적재 큐** | **138,688** (오차 0) | 셋트행 2(표지290+내지289)·반제품 289/290 mint·차원. 멱등·FK·골든·S8 무오염 PASS. |
| **070 PUR** | ✅ **GO → load-executor 적재 큐** | **288,688** (오차 0) | 셋트행 2(표지292+내지291)·반제품 291/292 mint·차원. 동일 PASS. |

★ **핵심 결론**: 069/070이 골든(**138,688·288,688**)에 **정확 도달**(알고리즘 재현·라이브 단가 실측·오차 0). 표지 완전 동작. **S8 오염 0·판형 저청구 없음**. ★**068과 달리 신규 공식 0** — PRF_BOOK_COVER·PRF_DGP_INNER·PRF_BIND_MUSEON·PRF_BIND_PUR 전부 라이브 실재(use_yn=Y·바인딩 보유) → **t_prc_* 신규 COMMIT 불요**(068의 BLOCKED ②트랙 없음). **t_prd_* 단일 트랙만**(셋트행+반제품+차원) — 인간 승인 후 load-executor 1트랙 COMMIT.

---

## 1. S1~S8 판정표 (라이브 직접 재실측·생성자 인용 아님)

| 게이트 | 판정 | 재실측 증거 (2026-07-01 라이브) |
|--------|:----:|------------|
| **S1 권위 충실성** | ✅ PASS | 단가 라이브 verbatim byte 일치: 표지인쇄 S1@499 POPT001 tier100=**350**·코팅 MATTE coat1 tier100=**500**·표지용지 MAT073@499=**36.88**·내지용지 MAT074@499=**70.64**·제본 MUSEON@019 tier100=**500**·PUR@020 tier100=**2000**. 069=138,688(35,000+50,000+3,688+50,000)·070=288,688(...+200,000) 분해 일치. page_rule 24/300/2(component-boundary booklet-l1 r7/r21 verbatim·068=4/28/4와 다름 정합). 표지 min1/max1. 날조 0. |
| **S2 구성원 유형** | ✅ PASS | 라이브 실측: 069/070=`PRD_TYPE.01`(완제품·셋트 완제품 정합). 289~292 라이브 미존재(mint 정당)·적재본 명시 `PRD_TYPE.02`(반제품·라이브 코드명="반제품"). 068 287/288=PRD_TYPE.02 동형 확증. 완제품/기성/디자인 혼입 0. 셋트행 각 2(소프트커버 면지 0). |
| **S3 복합PK/FK** | ✅ PASS | search-before-mint: MAX prd_cd=**PRD_000288**(068 표지·COMMIT됨)·289~292 미존재 → 채번 정합. FK 타깃 전건 실재: SIZ_000170(A5)/172(A4)/174(A3)/499(316x467)·POPT_000001/002/008/009·PROC_000004(디지털인쇄)/015(무광라미네이팅)/019(무선제본)/020(PUR제본)·CLR_000001/005·표지 MAT 7종(073/077/087/095/096/104/105)·내지 MAT 6종(074/081/082/091/092/109)·USAGE.01/07·OUTPUT_PAPER_TYPE.01. 복합PK ON CONFLICT 멱등. min1≤base1≤max1(표지·cnt_incr NULL 허용)·24≤base≤300 incr2(내지). cnt_incr 컬럼 nullable 실측. |
| **S4 가격 e2e [HARD]** | ✅ PASS | **evaluate_set_price 알고리즘 재현 = 069:138,688 / 070:288,688 (오차 0)**. 표지 member qty=copies×1=100·pansu=fn_calc_pansu(499,174)=1→plate_qty=100·표지 88,688(069/070 동일). 제본 069=500×100·070=2000×100. 표지 3비목+제본 각 매칭행 라이브 **정확히 1행**(ERR_AMBIGUOUS/DUPLICATE 0). 이중합산 0(비목 단일귀속). → `price-e2e-trace-booklet-museon-pur-069-070.md`. **신규 공식 0**(전부 재사용·즉시 평가 가능). |
| **S5 판형·page_rule** | ✅ PASS | `fn_calc_pansu(499,174)=1` 실측→표지 1매=1판=정확청구. A4(172)=2(÷2 저청구)·A5(170)=4·499자신=0 부결 라이브 재확인 → A3펼침(174) 채택이 옳음(068 동형). 표지 member 분리(290/292·SIZ_000499 판형)는 완제품 069/070 판형≠표지단가행 판형(499) 차이로 필연. 내지 page_rule 24/300/2 = component-boundary booklet-l1 r7(069)/r21(070) verbatim. (S5는 본 게이트에서 "판형·page_rule 권위 정합"으로 검사.) |
| **S6 적재 가능성 DRY-RUN** | ✅ PASS | BEGIN→069+070 적재본→ROLLBACK(ON_ERROR_STOP=1·EXIT=0) **제약위반 0**. 예상 INSERT 카운트 실증: products 289-292=**4**·셋트행 069=**2**·070=**2**·표지자재 290/292=**7**·내지자재 289/291=**6**·공식바인딩 289/291→PRF_DGP_INNER·290/292→PRF_BOOK_COVER(재사용). **멱등 2회차 INSERT/UPDATE delta=0**(36 statement 전건 INSERT 0 0). ROLLBACK 후 289-292=**0**·069/070 셋트행=**0** = baseline 완전 복귀·DB 미적재 실증. |
| **S7 생성≠검증 독립성** | ✅ PASS | 게이트 직접 재실측(라이브 단가행 6종·fn_calc_pansu 3종·match 카운트·use_dims·FK 실재·DRY-RUN 2-pass)으로 판정 — designer 손계산/spec 표 인용 아님. spec §1·blocked-board의 RESOLVED 5건(공식 재사용·mint 4·NO-OP)을 라이브로 독립 재확증. codex reconcile 미해결 0(069/070은 068 reconcile Q-A 표지용지 누락이 member 단일귀속으로 이미 해소된 패턴 전파). |
| **S8 구성요소 경계 무오염 [HARD]** | ✅ PASS | ① **경계 안**: 표지 자재 7종 ⊂ USAGE.01·내지 6종 USAGE.07·표지 인쇄 POPT001/002·코팅 PROC_000015 — component-boundary(booklet-l1 r7-9/r21-23) 경계 내. ② **공유공식 무오염**: PRF_BOOK_COVER 라이브 현재 PRD_000288만 바인딩→적재 후 290/292 추가(각 표지 member 전용·silent 적용 0). **PRF_BOOK_COVER=정확히 3 comp**(S1+COAT_MATTE+PAPER·후가공/굿즈 혼입 0). ③ **제본 격리 결정적**: 068=PRF_BIND_SUM→JUNGCHEOL(018)·069=PRF_BIND_MUSEON→MUSEON(019)·070=PRF_BIND_PUR→PUR(020) 각 고유 comp·**각 comp 단일 proc_cd**(MUSEON 019만·PUR 020만)→silent 다중매칭 0(현황판 B-4 패턴 없음·TWINRING 4 proc_cd 위험은 069/070 무관). _FOIL 변종(MUSEON_FOIL/PUR_FOIL)은 별 공식이라 박 comp가 기본가에 silent 합산 0. |

**단일 FAIL = NO-GO 규칙 → FAIL 0 → 069·070 둘 다 종합 GO.**

---

## 2. 138,688·288,688 도달 여부 (실호출 재계산값)

```
[알고리즘 재현·라이브 단가 실측·100부·A3펼침 표지/칼라단면/백모120 무광]

표지 member (069=290·070=292·qty=copies×cover_mult(=×1)=100·PRF_BOOK_COVER·pansu=1):
  표지인쇄 COMP_PRINT_DIGITAL_S1  350.00 × 100 = 35,000
  표지코팅 COMP_COAT_MATTE        500.00 × 100 = 50,000
  표지용지 COMP_PAPER(백모120)     36.88 × 100 =  3,688
  ──────────────────────────────── 표지 소계 = 88,688  (069·070 공통)

셋트공식 제본 (qty=copies=100):
  069  COMP_BIND_MUSEON  500.00 × 100 =  50,000
  070  COMP_BIND_PUR    2000.00 × 100 = 200,000

═══════════════════════════════════════════════
  069 = 88,688 +  50,000 = 138,688  ✓ (오차 0)
  070 = 88,688 + 200,000 = 288,688  ✓ (오차 0)
```
+ 내지 member(289/291·PRF_DGP_INNER·page파생) 별도 가산 — 골든 138,688/288,688은 표지+제본 정의.

---

## 3. S8 오염·판형 결판

- **S8 오염 = 없음**. PRF_BOOK_COVER 깔끔 3비목(후가공 무혼입). PRF_BOOK_COVER 재사용이 069/070에 silent 오염 0(각 표지 member 290/292가 자기 셋트행으로만 연결). **제본 혼선 0** — 069=MUSEON·070=PUR 각자 고유 부모공식·고유 comp·단일 proc_cd. 한 책자 제본비가 다른 책자 견적에 새지 않음(현황판 B-4 결함 부재).
- **판형 저청구 = 없음**. fn_calc_pansu(499,174)=1 → 표지 정확 1판. A4(pansu=2)/A5(pansu=4) 미채택·SIZ_000174(A3펼침) 채택이 옳음. member 분리는 완제품 판형≠단가행 판형(499) 차이로 필연(직배선 불가·068 동형).
- **★cover_mult ×2 BLOCKED 무관**: 069 무선=PROC_000019·070 PUR=PROC_000020 둘 다 책등 있음=펼침 cover_mult=**1** → 표지 ×1(copies). booklet-cover-branch §0.0의 cover_mult ×2 NO-GO(071/082)는 069/070 비해당(부모공식 직배선이든 member 분리든 ×1이라 정확). 본 적재본은 member 분리 방식이나 ×1이라 저·과청구 위험 0.

---

## 4. 실 COMMIT 가능분 (신규 공식 0·t_prd_*만) — 068보다 단순

| 트랙 | 대상 t_* | 위상 | 라우팅 | 인간 승인 |
|------|---------|------|--------|:--------:|
| **GO·load-executor (단일 트랙)** | t_prd_products(289/290/291/292)·t_prd_product_sizes·_print_options·_materials·_plate_sizes·_processes·t_prd_product_price_formulas(289/291→INNER·290/292→COVER·069→BIND_MUSEON NO-OP·070→BIND_PUR NO-OP)·t_prd_product_sets(069×2·070×2) | 1~8 | hsp-load-executor | 필요 |
| **t_prc_* 신규** | **없음(NO-OP)** | A1·A2 | PRF_BOOK_COVER 등 전부 라이브 실재(use_yn=Y) → 멱등 재확인만 | 불요 |

★ **068과의 차이[HARD]**: 068은 ② PRF_BOOK_COVER(t_prc_*) 신규공식이 먼저 COMMIT돼야 ①이 평가 가능(BLOCKED 의존순서). **069/070은 PRF_BOOK_COVER가 이미 라이브(068 COMMIT)** → t_prc_* 신규 0 → **단일 트랙**(t_prd_*만). PART A의 PRF_BOOK_COVER INSERT는 ON CONFLICT 멱등 NO-OP(이미 존재). 따라서 069/070은 t_prd_* 적재 즉시 138,688/288,688 평가됨.

---

## 5. 인간 승인 큐

1. **[High·t_prd_*·GO] 069 셋트행 2(표지290+내지289) + 반제품 289/290 + 차원** — load-executor 적재. 멱등·FK·골든 138,688 PASS. → load-executor 적재 큐.
2. **[High·t_prd_*·GO] 070 셋트행 2(표지292+내지291) + 반제품 291/292 + 차원** — 동일. 골든 288,688 PASS. → load-executor 적재 큐.
3. **[Med·선택·dbmap] 070 완제품(PRD_000070) 자재 link 0행** — BLOCKED-MAT070-LINK. 069는 완제품 USAGE.01/02 보유·070은 0행. member(291/292)에 069 권위 verbatim 충전했으므로 견적 정확(미관여)·완제품 link 부재는 운영자 노출만. 보강은 선택 정합(견적 무영향). → dbmap(선택).
4. **[Med·C트랙·개발팀] DBLPANSU 내지 이중÷pansu** — price_views.py:1707·전 책자 공통(068/069/070/072/077/082)·내지비 환산 영향(표지/제본 무영향)·1회 교정 동시 해소. → NOTE C-TRACK-ENGINE-DBLPANSU(068 게이트와 동일·이월).
5. **[NA] _FOIL 변종·cover_mult ×2** — 박 후가공(별 공식·기본가 무영향)·069/070 cover_mult=1(×배수 없음). 건드리지 않음.

---

## 6. 검증 안전 확인

- 라이브 읽기전용 SELECT만 · DRY-RUN BEGIN…ROLLBACK(COMMIT 0·EXIT=0) · DB 미적재(baseline 289-292=0 복귀 실증) · 비밀값 비노출.
- 생성자 주장 자동 신뢰 0 — 모든 수치(단가 6종·pansu 3종·match 카운트·FK·멱등 delta)를 라이브 재실측. 근거 못 찾은 항목 0.
- 068 게이트(GO·158,688) 유효분 이월: 표지공식 PRF_BOOK_COVER 정의·표지 88,688 패턴·DBLPANSU C트랙 — 069/070에 동형 재확증.
