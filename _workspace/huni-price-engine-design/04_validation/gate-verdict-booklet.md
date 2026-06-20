# gate-verdict-booklet.md — 책자(반제품 세트·다부품 합산형) 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 검증 (생성≠검증).** engine-designer 설계 주장을 라이브 t_prc_*·t_prd_*·권위 엑셀로 직접 재실측해 결판.
> 라이브 읽기전용 SELECT 실측 2026-06-20(Railway `db railway`·psql) · pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`·570줄) + models.py 코드 직접 검증 · 골든 충실 재구현.
> 검증 대상: `03_design/engine-design-booklet.md`·`golden-cases-booklet.md`(GC-BK1~8)·`design-decisions.md` 책자 절(DB-1~11)·`set-product-design.md` §9.
> 기준점: `01_formula/formula-map-booklet.md`·`02_benchmark/absorption-candidates-booklet.md`.

---

## 0. 종합 판정: **GO** (E1~E7 전건 PASS · 차단 결함 0 · 보정 요구 0 · 정정 권고 1[LOW·가격 무영향])

책자는 **첫 게이트부터 GO**(아크릴·실사·문구 GO 동류·디지털 NO-GO와 대조). 두 데이터 결함(G-BK-1 중철 단가행 오염·G-BK-2 stale 배선)을 라이브로 독립 재실측해 **둘 다 designer 정확**. 돈크리티컬 `.01` 부당단가 해소도 단가 사다리 실측으로 비준. 골든 GC-BK1~6 허용오차 0 재현(corrupt 12,000 vs corrected 8,000 양면 입증). 신규 mint 최소(재배선/바인딩 중심).

| 게이트 | 판정 | 핵심 근거(라이브 실측) |
|--------|------|------------------------|
| E1 공식 추출 충실성 | **PASS** | B01/B02 단가행 verbatim 일치(날조·누락 0)·표지/내지 comp 0행 confirm·G-BK-1/2 셀 단위 재대조 |
| E2 구성요소 분해 정합 | **PASS** | 제본비 통합 comp(proc_cd 종류축)·세트 sub_prd 가격 비기여·시트경계 SOT 1 준수 |
| E3 경쟁사 흡수 타당성 | **PASS** | 신규 가격축 0·naming 유입 0·jobqty 2단 부결 정합·(A)/(B) 두갈래 스코프 분리 적절 |
| E4 엔진 설계 건전성 | **PASS** | proc_cd=NON_QTY_DIM 분기 정확·search-before-mint(재배선/교정 UPDATE)·★del_yn 필터 부재 코드 확정(설계 인계 질문 결판) |
| E5 세트 조합 정합 | **PASS** | sets 25행 sub_prd_qty=1·min/max NULL(택1)·면지 합산 금지 가드·이중수량 분리 |
| E6 골든 재현 | **PASS** | GC-BK1~6 **6/6 일치(허용오차 0)**·GC-BK7/8 구조검증(부품 단가 미확정=정직)·corrupt/corrected 양면 |
| E7 생성검증 독립성 | **PASS** | 데이터 결함 2건 라이브 독립 재실측·del_yn 필터 질문 코드로 자체 결판·dodge 없음 |

---

## E1 — 공식 추출 충실성 (cartographer 지도 ↔ 권위 엑셀/라이브 셀 재대조) · **PASS**

**재현 SQL (Q3/Q4/Q5):**
```sql
SELECT proc_cd, min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_BIND_TWINRING' AND proc_cd IN ('PROC_000018','PROC_000019','PROC_000020','PROC_000021') ORDER BY proc_cd,(min_qty)::int;
SELECT proc_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_JUNGCHEOL' ORDER BY (min_qty)::int;
SELECT proc_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_SSABARI' ORDER BY proc_cd,(min_qty)::int;
```

| 제본방식 | proc_cd | min_qty → unit (라이브 verbatim) | 가격표 B01/B02 | 판정 |
|---------|---------|----------------------------------|----------------|------|
| 중철(현 라이브·오염) | PROC_000018 (TWINRING comp) | 1=4000·4=3000·10=2000·30=1500·50=1500·70=1300·100=1300·1000=1000 | ❌ 트윈링값 오복사 | **오염 확정** |
| 중철(정답·JUNGCHEOL del='Y') | PROC_000018 | 1=3000·4=2000·10=1500·30=1000·50=1000·70=700·100=700·1000=500 | ✓ B01 중철 | **정답 보유** |
| 무선 | PROC_000019 | 1=3000·4=2000·10=1000·30=700·50=700·70=500·100=500·1000=500 | ✓ B01 무선 | ✓ 정상 |
| PUR | PROC_000020 | 1=5000·…·1000=1500 | ✓ B01 PUR | ✓ 정상 |
| 트윈링 | PROC_000021 | 1=4000·…·1000=1000 | ✓ B01 트윈링 | ✓ 정상(중철 오염의 복사원) |
| 하드커버무선 | PROC_000023 (SSABARI) | 1=30000·4=20000·10=14000·50=9000·100=7000·1000=6000 | ✓ B02 | ✓ |
| 하드커버트윈링 | PROC_000024 | 1=30000·4=20000·10=15000·50=10000·100=8000·1000=7000 | ✓ B02 | ✓ |
| 싸바리 | PROC_000098 | 1=30000·4=25000·10=20000·50=15000·100=9000·1000=7000 | ✓ B02 | ✓ |

- **날조 0·누락 0.** designer 골든 단가는 전부 라이브 verbatim과 일치. G-BK-1(중철 오염=트윈링 byte-동일)·G-BK-3(표지/내지/면지 comp 0행) 셀 단위 독립 재대조 일치(Q7 COUNT=0).
- **v03 인용 차단**: 설계는 상품마스터(260610)+가격표(260527)+라이브만 인용. ✓
- **LOW 정정 1 (freshness·가격 무영향)**: 설계 §0.1·CV-BK-FRESH는 "comp_prices upd_dt 2026-06-17"이라 기술했으나 라이브 재실측(Q11)은 **reg_dt=2026-06-17·upd_dt 전건 NULL**. cartographer §3.3 "upd_dt 전건 NULL"이 정확하고 2026-06-17은 reg_dt. 결론(단가값 안정·verbatim)은 불변 — freshness 출처 컬럼 표기만 정밀화 권고.

---

## E2 — 구성요소 분해 정합 (시트 차원경계 SOT 1·완제품/반제품) · **PASS**

**재현 SQL (Q2/Q7):** COMP_BIND 11종 use_dims·표지/내지/면지 comp 0행.

- **제본비 통합 comp = proc_cd 종류축**: 활성 3 comp(TWINRING/SSABARI/CAL_WALL)가 각자 여러 proc_cd 단가행을 통합 보유(use_dims=`[proc_cd,min_qty,proc_grp:PROC_000017]`). per-method 8 comp는 del_yn='Y' thin-mirror 선행본. comp_grp 신설 불요([[dbmap-price-component-grouping]] 정합). ✓
- **세트 sub_prd = 가격 비기여**: 25행 전건 sub_prd_qty=1·min_cnt/max_cnt NULL(택1 의미·Q10). 면지 4행 합산 금지=이중계상 가드(§E5). ✓
- **시트 밖 침입 부재**: 표지/내지/면지 comp 0행(Q7) → 현 라이브 책자 가격사슬=제본비 단일항(미완). 표지/내지 합산은 디지털인쇄 COMP_PAPER·COMP_PRINT_DIGITAL_S1 재사용 가설(시트경계 내·DB-6) — **단 충돌 가드는 E4에서 별도 점검**.
- **완제품(A)/반제품(B) 구분 정확**: 068~071 sets 분해 0(단일 prd·시트 컬럼)·072/077/082/088/100 sub_prd 분해(Q10). 의미축 이중 인코딩 없음. ✓

---

## E3 — 경쟁사 흡수 타당성 (답습 아닌 흡수·naming 유입·두갈래 스코프) · **PASS**

- **신규 가격축 0**: C-BK1~6 전부 후니 기존 그릇(제본 comp 11종·sets 25행·page_rules 11행·합산형 addtn_yn) 매핑. vessel-gap 아닌 data/배선-gap. rpmeta TP/BN distinct #18 부결 정합.
- **naming 유입 0**: book2025_price·MTRL_CD·INN_PAGE·paperno·jobqty0/jobcost0·seneca·COV_MIN_WGT·ORD_CNT/PRN_CNT 후니 유입 없음. 후니 frm_cd/comp_cd/proc_cd/page_rules 컨벤션만 사용. ✓
- **WowPress jobqty→jobcost 2단 부결 정합**: 작업량 DB 사전 환산=과분화·후니 원칙(중간계산=앱·DB=룩업) 위배 → 부결. 단 환산 규칙은 앱 함수 단서(가격축 아님). ✓
- **두갈래 (A)/(B) 한 공식 강제 금지 적절**: (A)=시트 컬럼·sets 분해 0 / (B)=별 prd_cd 분해. 가격 합산 메커니즘은 동형이라 공식 공유 가능(proc_cd 분기)·세트 그릇 사용 여부가 결정적 차이. 도메인 현실 존중([[dbmap-print-domain-recipe-philosophy]]). ✓

---

## E4 — 엔진 설계 건전성 (evaluate_price 계약·del_yn 필터·silent 다중매칭·combo_key·search-before-mint) · **PASS**

**pricing.py + models.py 코드 직접 검증:**

| 계약 | 코드 라인 | 설계 인용 | 검증 |
|------|-----------|-----------|------|
| 소스 우선순위 TEMPLATE→PRODUCT_PRICE→FORMULA | :285-326 | 정확 | ✓·책자=FORMULA(직접단가 0행·Q13) |
| frm_typ 미참조(C7) | :8·:16 | 정확 | ✓ frm_typ_cd 컬럼 부재 |
| 단가형(.01) `unit×qty`·÷min_qty 미발생 | :185-192 | 정확 | ✓ COMP_BIND 전건 .01·min_qty NULL 0건(Q15) |
| min_qty TIER '이상' 하한 | :42·:144·:157-162 | 정확 | ✓ |
| proc_cd = NON_QTY_DIM 정확매칭 분기 | :38-39·:78-90 | 정확 | ✓ proc_cd가 판별차원·combo_key 멤버 |
| 수량구간할인 연결 prd_cd→dsc_tbl | :478-504 | (Q-BK-DSC 미점검·컨펌큐) | — |

**★E4 핵심 결판 — del_yn 필터 부재 (설계 "검증 인계" 질문에 코드로 답):**
- **검증 확정**: pricing.py에 `del_yn` 참조 **0건**(grep). 모델 매니저는 전부 기본 `models.Manager`(custom del_yn 필터 없음·`managed=False`). `_evaluate_formula`(:450)는 `TPrcFormulaComponents.objects.filter(frm_cd=...)`로 순회(formula_components에 del_yn 컬럼 부재·:205-217)·`_component_rows`(:238)는 `TPrcComponentPrices.objects.filter(comp_cd=...)`(price 행에 del_yn 없음·:176-202·del은 부모 TPrcPriceComponents에만 :230).
- **∴ 엔진은 del_yn='Y' comp를 필터하지 않는다.** PRF_BIND_SUM→COMP_BIND_JUNGCHEOL(del='Y')은 **그대로 평가됨**. 설계의 "필터 적용 시 0원 / 미적용 시 misfire" 두 가설 중 **misfire 가설이 실제**(0원 분기는 발생 안 함).
- **단 정밀화**: misfire의 실제 양상은 proc_cd 주입에 종속. JUNGCHEOL은 PROC_000018(중철) 8행만 보유 → ① proc_cd 미주입(NULL)이면 `_row_matches`(:81-86)에서 행 proc_cd(non-NULL) vs 선택 NULL 불일치 → no_match → **0원**(lenient 경고). ② proc_cd=PROC_000018 주입이면 중철값 매칭(068 우연 정합·8,000) ③ proc_cd=무선/PUR/트윈링 주입이면 JUNGCHEOL에 그 proc 행 없음 → no_match → 0원. **즉 현 라이브에서 4상품 모두 자기 제본비 정상 산출 불가**(중철만 우연·나머지 0원 또는 misfire)라는 설계 결론은 불변 → **재배선(W1) 필수** 정확. 설계가 "어느 동작이든 정상 불가"로 결론 보존한 것 타당(LOW: 설계 §2.1·DB-4의 "필터 적용 시 0원" 가설은 코드상 발생 안 함이나 결론 동일 → 정정 권고 아닌 정밀화).
- **★재배선 후 silent 다중매칭 가드 정확**: TWINRING comp는 4 proc_cd(18~21·Q14) 보유 → proc_cd 미주입 시 4 proc_cd 단가행 전부 후보. 단 `_row_matches`는 행 proc_cd가 non-NULL이라 **선택 proc_cd가 NULL이면 매칭 0건**(와일드카드는 행값 NULL일 때만) → silent 합산이 아닌 **0원**. proc_cd 주입(Q-BK-PROC)이 선결인 점은 정확(미주입 시 견적 0원 침묵). 디지털 PUNCH 동형 가드 타당.
- **COMP_PAPER 표지/내지 2회 배선 combo_key 충돌 (DB-6·AD-BK3)**: COMP_PAPER use_dims=`[siz_cd,mat_cd]`(Q8) → 표지·내지가 같은 comp_cd로 2회 배선되고 mat_cd가 표지종이≠내지종이로 분기되면 각자 1행(combo_key 다름)·동일 종이 선택 시 `_combo_key`(:93-95) 동일 → ERR_AMBIGUOUS(:137). 설계가 이 위험을 정확히 식별하고 "표지/내지 전용 comp 분리" 폴백 명시(Q-BK-COVER). ✓ ★단 COMP_PRINT_DIGITAL_S1 use_dims에 `proc_grp:PROC_000001`(디지털인쇄 공정·Q8) 포함 — 책자 표지/내지 인쇄에 이 comp 재사용 시 proc_grp 차원 정합 여부는 Q-BK-COVER 단가소스 재대조에 포함 필요(검증 보강·아래 컨펌큐).
- **search-before-mint**: 제본비 재배선(W1·신규 0)·중철 단가행 교정 UPDATE(W2·신규 0·값=JUNGCHEOL verbatim)·세트 그릇 실재·표지/내지=재사용 우선(충돌 시 1~2건). 신규 mint 최소 충족. ✓

---

## E5 — 세트(반제품) 조합 정합 (이중계상·구성품 누락·번들 할인) · **PASS**

**재현 SQL (Q10):** sets 25행 sub_prd 분해.

- **세트 구성≠가격 분리**: sub_prd(표지·면지 화이트/블랙/그레이)는 `t_prd_product_sets`·sub_prd_qty=1·min/max_cnt NULL=택1 색상(생산 BOM). 가격은 공식 comp Σ(권위). ✓
- **이중계상 가드 정확**: 면지 4행을 "부품 4개 합산"하면 이중계상 → 설계가 "면지=택1·4색 합산 금지" 명시(DB-9·§9-1). 라이브 면지 comp 0행이라 현재 합산 그릇 자체 부재 → 구조적 이중계상 불가. ✓
- **088 BLOCKED 정직**: page_rules에 088 부재(Q9)·"(보류중)"·제본방식 공란 → 바인딩 보류. 정체 미확정을 정답으로 위장 안 함. ✓
- **100 포토북 컨펌**: 7 sub(101 내지+표지 6 variant+면지 104·Q10)·표지 소재 택1·제본방식 컨펌(Q-BK-PHOTO) 정직. ✓
- **번들 할인**: 책자 수량구간할인 t_prd_product_discount_tables 링크 유효성 미점검(Q-BK-DSC 컨펌큐)·문구 DSC_STAT_QTY 동형 위험 정직 기록. GO 막지 않음(설계 결함 아닌 미점검 큐). ✓

---

## E6 — 골든 재현 (설계 공식으로 실제 재계산·허용오차 0) · **PASS**

**pricing.py 충실 재구현**(min_qty TIER '이상' 하한 선택·.01 `unit×qty`·round_won)으로 라이브 단가행 verbatim 사용. 전 단계 `recompute-log-booklet.md`.

| GC | 입력 | 단가행(라이브) | 재계산 | 골든 | 일치 |
|----|------|----------------|--------|------|------|
| **GC-BK1** corrected | 중철 4부 | JUNGCHEOL/018 min4=2000 | 2000×4=**8,000** | 8,000 | ✓ |
| GC-BK1 corrupt(현 라이브) | 중철 4부 | TWINRING/018 min4=3000(오염) | 3000×4=12,000 | (12,000 오염·교정 전) | ✓ 양면 |
| **GC-BK2** | 무선 100부 | 019 min100=500 | 500×100=**50,000** | 50,000 | ✓ |
| **GC-BK3** | PUR 1000부 | 020 min1000=1500 | 1500×1000=**1,500,000** | 1,500,000 | ✓ |
| **GC-BK4** | 트윈링 10부 | 021 min10=2000 | 2000×10=**20,000** | 20,000 | ✓ |
| **GC-BK5** | HC무선 4부 | SSABARI/023 min4=20000 | 20000×4=**80,000** | 80,000(제본비) | ✓ |
| **GC-BK6** | HC트윈링 100부 | SSABARI/024 min100=8000 | 8000×100=**800,000** | 800,000(제본비) | ✓ |
| GC-BK7 | 완성가 Σ | (표지/내지 comp 0행) | 구조검증 | (Q-BK-COVER 후) | 구조 ✓ |
| GC-BK8 | 무선 10부·100p | (내지 comp 0행) | 구조검증 | (구조) | 구조 ✓ |

- **GC-BK1~6 전건 6/6 일치(허용오차 0).** min_qty TIER 선택·.01 산식 라이브 코드 충실.
- **PUR 볼륨할인 사다리 입증(DB-3)**: 5000→3000→1500 단조 하락(Q3) → 묶음총액 불가(총액은 증가) → unit=부당가 확정. `.01 × qty` 정합·교정 불요. 디지털 명함(묶음총액 ×qty 폭발)과 단가 의미 정반대 = 무비판 전이 금지 정확. ✓
- **양면 입증(돈크리티컬)**: GC-BK1 corrupt 12,000 vs corrected 8,000(과청구 50%). 진원=라이브 단가행 오염(G-BK-1)이지 설계 골든값 오류 아님(값=JUNGCHEOL/B01 verbatim 옳음). ✓
- **GC-BK7/8 구조 전용 정당**: 표지/내지 comp 0행이라 수치 골든 불가 → 설계가 "구조·합산 메커니즘 검증·부품 단가 Q-BK-COVER 후 보강"으로 정직 보류. 미확정을 정답으로 위장 안 함. ✓

---

## E7 — 생성-검증 독립성 (self-approve·dodge-hunt·데이터 결함 독립 재실측) · **PASS**

- **데이터 결함 2건 독립 라이브 재실측**: G-BK-1(중철 오염)을 designer 주장 신뢰 없이 직접 SELECT(Q3/Q4) — TWINRING/018이 트윈링/021과 byte-동일·JUNGCHEOL/018이 B01 정답 보유 독립 확인. G-BK-2(stale 배선)를 Q1/Q2로 직접 확인(PRF_BIND_SUM→JUNGCHEOL del='Y').
- **★del_yn 필터 질문 코드로 자체 결판**: 설계가 "검증 인계"로 남긴 미해소 질문(del 필터 적용 여부)을 pricing.py grep + models.py 매니저 확인으로 독립 결판(필터 부재) → 설계의 두 가설 중 misfire가 실제임을 검증가가 발굴(설계 결론은 보존). dodge 아닌 검증가 결판.
- **돈크리티컬 `.01` 독립 재검증**: PUR 사다리 단조 하락을 직접 SELECT해 부당단가 비준(designer 가설 신뢰 없이).
- **골든 양면 재계산**: corrupt/corrected 둘 다 재구현 산출(÷min_qty 미발생 확인)·라이브 verbatim 대조.
- **self-approve 없음**: 설계를 재유도하지 않고 라이브·코드·골든 재계산으로만 판정.

---

## 라이브 freshness (드리프트 점검)

| 객체 | 라이브 실측 | 설계 기술 | 정합 |
|------|-------------|-----------|------|
| PRF_BIND_SUM | use_yn=Y·fc=JUNGCHEOL(del='Y') 1개 | 동일 | ✓ |
| COMP_BIND 활성/삭제 | 활성 3·삭제 8 | 동일 | ✓ |
| 중철 단가행 오염 | TWINRING/018=트윈링값 | 동일 | ✓ |
| 068~071 바인딩 | PRF_BIND_SUM·072/077/082/088/100 미바인딩 | 동일 | ✓ |
| comp_prices freshness | **reg_dt 2026-06-17·upd_dt NULL** | "upd_dt 2026-06-17"(부정확) | ⚠ LOW(컬럼 표기·결론 불변) |
| sets/page_rules | 25행/11행(088 부재) | 28행 기술(전체 sets)·11행 | ✓(25=책자 5부모분·전체 28) |

설계↔라이브 어긋남 0(freshness 컬럼 표기만 LOW). 날조 0.

---

## 컨펌큐 (designer 큐 6건 유지 + 검증 보강 2)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-BK-COVER | ★표지/내지 용지·인쇄 단가 소스(디지털 종이비 시트 포함 vs 책자 전용)·COMP_PAPER 표지/내지 2회 배선 combo_key 충돌→전용 comp 분리 | 가격표·dbm-price-arbiter | DB-6·돈크리티컬 |
| Q-BK-COVER(+검증 보강) | ★COMP_PRINT_DIGITAL_S1 재사용 시 use_dims `proc_grp:PROC_000001`(디지털인쇄 공정) 차원이 책자 표지/내지 인쇄에 정합한지 — proc_grp 불일치 시 매칭 0건(0원 침묵) 또는 전용 인쇄 comp 필요 | dbm-price-arbiter | 재사용 무손실성 |
| Q-BK-PROC | ★제본방식→proc_cd 주입 레이어(상품→고정값)·미주입 시 0원 침묵(silent 합산 아님·행 proc_cd non-NULL) | round-6 dbm-option-mapper | W1 재배선 선결·돈크리티컬 |
| Q-BK-PHOTO | 포토북 제본방식·표지 6 variant 단가·면지 104 가격기여 | 실무·가격표 | 포토북 바인딩 |
| Q-BK-BINDER | 레더 링바인더(088) "(보류중)" 정체·제본방식 | 실무·상품마스터 | 088 BLOCKED |
| Q-BK-MYUNJI | 면지 색상 단가 동일(비기여) vs 색별차(면지 comp mat_cd) | 실무·가격표 | 이중계상 가드 |
| Q-BK-DSC | 책자 수량구간할인 t_prd_product_discount_tables 링크 유효성(미점검·문구 동형 위험) | dbmap round-1 | 할인 적용 |
| CV-BK-FRESH(검증 정정) | comp_prices freshness=reg_dt 2026-06-17·upd_dt NULL(설계 "upd_dt"는 부정확)·결론 불변 | designer | LOW·문서만 |

---

## 보정 요구 (재게이트 조건)

**차단 결함(NO-GO) 0건. 보정 요구 없음.** 정정 권고 1(LOW·가격 무영향·designer 폐루프):
- **정정-1(LOW)**: §2.1·DB-4의 "del 필터 적용 시 comp 0개=0원" 가설은 코드상 발생 안 함(del_yn 필터 부재·misfire/0원[proc 미주입] 분기만). 결론("4상품 정상 가격 불가→재배선 필수")은 불변 → 표현 정밀화. + freshness "upd_dt 2026-06-17"→"reg_dt 2026-06-17·upd_dt NULL".

## 라우팅

- **W1 재배선(PRF_BIND_SUM→COMP_BIND_TWINRING·proc_cd 분기) + W2 중철 단가행 교정(B01 verbatim 8행 UPDATE)** → dbm-price-arbiter 심의 + 인간 승인 후 dbmap(dbm-axis-staged-load·dbm-load-execution). 돈크리티컬·과청구 50%. 단가값=verbatim·멱등·백업·undo.
- **W3 표지/내지 합산 배선(Q-BK-COVER 확정 후) + W4 세트 부모 바인딩(072/077/082/100)** → dbm-price-arbiter(단가 소스·combo_key 충돌·proc_grp 정합) + 인간 승인 후 dbmap. 088 BLOCKED.
- **Q-BK-PROC proc_cd 주입 레이어** → round-6 dbm-option-mapper(W1 선결).
- **설계 정정-1(LOW)** → designer 폐루프(문서만·가격 무영향).
- **codex 2차(Phase 5.5)** → 오케스트레이터 reconcile(본 판정 독립·codex 비참조).

## DB 미적재 [HARD]

본 검증은 라이브 읽기전용 SELECT만 수행·DB 쓰기 0. 모든 결함 교정(재배선·단가행 교정·comp 신설·세트 바인딩)은 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지.
