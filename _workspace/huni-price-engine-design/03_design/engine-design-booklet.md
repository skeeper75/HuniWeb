# engine-design-booklet.md — 책자(반제품 세트·다부품 합산형) 가격엔진 설계

> **핵심 설계가(hpe-engine-designer) 5번째 종단 — §18 directive "반제품 세트상품"의 첫 본격 설계.**
> 디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치]·문구[고정가+매트릭스] GO 다음.
> cartographer 지도(`formula-map-booklet.md`)+benchmark 흡수(`absorption-candidates-booklet.md`·`set-pricing-patterns.md` P-6·`competitor-pricing-models.md` §7)를 종합해,
> 책자 **단일 prd 제본비형(A)** + **세트 부모 부품 합산형(B)** 의 가격공식+구성요소+t_prc_*/t_prd_* 단가 그릇+세트 조합+데이터 결함 교정을
> 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — 데이터 그릇/배선/바인딩/교정 명세.**
>
> 권위[HARD]: ① 상품마스터(260610) > ② 인쇄상품 가격표(260527 제본 시트 B01/B02 + 디지털인쇄 종이비/인쇄비) > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학(후보).
> 산출자: hpe-engine-designer · **라이브 읽기전용 SELECT 실측 2026-06-20**(아래 §0.1 freshness) · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털인쇄·아크릴·실사·문구 GO 설계와 동일 컨벤션·동일 engine-contract(pricing.py).

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나

### 0.1 라이브 freshness 실측 (2026-06-20·읽기전용 SELECT)

| 엔티티 | 실측 | freshness(max reg/upd_dt) | 비고 |
|--------|------|---------------------------|------|
| PRF_BIND_SUM | use_yn=Y·formula_components=COMP_BIND_JUNGCHEOL(del_yn='Y') 1개뿐 | — | **G-BK-2 확정(stale 배선)** |
| COMP_BIND_* | 활성 3(TWINRING/SSABARI/CAL_WALL·del_yn='N')·삭제 8(del_yn='Y') | — | cartographer §2.2 일치 |
| COMP_BIND_TWINRING/중철(PROC_000018) | **1=4000·4=3000·10=2000…**(트윈링 값 오염) | comp_prices upd_dt **2026-06-17** | **G-BK-1 확정** |
| COMP_BIND_JUNGCHEOL/중철(PROC_000018) | **1=3000·4=2000·10=1500…**(가격표 B01 정답) | — | 정답값 보유(삭제 comp) |
| 표지/내지/면지/책자 comp | **0행**(`comp_nm LIKE '%표지/내지/면지%' OR comp_cd LIKE '%COVER/INNER%'` = COUNT 0) | — | **G-BK-3 확정** |
| 책자 바인딩 | 068~071=PRF_BIND_SUM·072/077/082/088/100=**미바인딩**·094=PRF_PCB_FIXED | — | G-BK-4 확정 |
| t_prd_product_sets(책자) | 072/077/082/088/094/100 세트 분해 실재(면지·표지 별 prd_cd) | sets 2026-06-03 12:46 | cartographer §3.1 일치 |
| t_prd_product_page_rules | 11행(068=4/28/4·069/070/072/077=24/300/2·071/082=8/100/2·094=20/30/10·097=3/3/3·100=24/150/2·176=28/28/0) | 2026-06-03~05 | cartographer §3.2 일치 |

★ **cartographer §3.3 "comp_prices upd_dt 전건 NULL=값 안정" = 부분 stale**: COMP_BIND 단가행 max upd_dt = **2026-06-17 15:30**(NULL 아님). 라이브가 작업 중 진화하는 표적([[huni-recipe-viz-harness]] R7 교훈) — 단, 단가값 자체는 가격표 B01/B02 verbatim 재현 확인(검증가 E1 재대조 대상). **freshness 갱신만, 결론(부수당 단가) 불변.**

### 0.2 ★두 갈래 구조 (한 공식 강제 금지 [HARD])

책자 시트는 **하나의 가격 클래스가 아니다**. benchmark가 못박은 두 갈래:

| 갈래 | 상품(prd_cd) | 정체 | 가격 클래스 | evaluate_price 경로 |
|------|-------------|------|------------|---------------------|
| **(A) 단일 prd + 공유 제본비 공식** | 중철 068·무선 069·PUR 070·트윈링 071 | 단일 완제품(표지/내지 미분리·시트 컬럼) | **제본비 중심**(표지/내지 인쇄·용지비 합산이 다부품 완성가) | FORMULA(PRF_BIND_<제본방식>·proc_cd 분기) |
| **(B) 세트 부모 + 표지/면지 별 prd_cd 부품** | 하드커버 072·레더HC 077·HC링 082·레더링바인더 088 + 포토북 100 | 반제품 세트(표지·면지 별 prd_cd `t_prd_product_sets`) | **부품 합산**(표지비 + 내지비[페이지] + 제본비 B02 + 후가공) | FORMULA(PRF_<제본방식>_SUM·세트 부모에 바인딩) |

★ **(A)와 (B)를 한 공식으로 강제 금지**(메모리 `dbmap-print-domain-recipe-philosophy`·benchmark §0). 단, **둘 다 결국 "다부품 합산형"**(제본비 + 표지/내지 인쇄·용지비)이며 차이는 **부품을 시트 컬럼으로 두느냐(A) 별 prd_cd로 분해하느냐(B)** — 즉 **세트 그릇 사용 여부**(B만 sets 분해). 가격 합산 메커니즘(공식+comp Σ)은 동형.

### 0.3 핵심 작업 4묶음 (gap-board G-BK-1~9 매핑)

| # | 작업 | 갭 | 우선 | 본 설계 §  |
|---|------|----|----|-----------|
| **W1** 제본비 stale 배선 교정 | PRF_BIND_SUM → 통합 COMP_BIND_TWINRING(proc_cd 분기) 재배선·상품별 공식 분기 | G-BK-2 | 🔴 1 | §2 |
| **W2** 중철 단가행 오염 교정 | COMP_BIND_TWINRING/PROC_000018 8행 → 가격표 B01 중철값 verbatim | G-BK-1 | 🔴 1 | §2.4 |
| **W3** 표지/내지/인쇄 comp 신설·합산 배선 | 다부품 완성가(DT-BIND-SCOPE 부품 합산 방향) | G-BK-3 | 🔴 2 | §3 |
| **W4** 하드커버/포토북 세트 부모 바인딩 | 072/077/082/088/100 미바인딩→공식 | G-BK-4 | 🔴 2 | §4·set-product-design |

W5(세트=BOM 가드)·W6(이중수량)·W7(CPQ)·W8(링바인더 보류)·W9(캘린더 경계)는 §5~§7·컨펌큐.

**∴ 책자 설계 핵심 3가지:**
1. **(A) 제본비형 = 배선 교정**(stale 참조 → 활성 통합 comp·proc_cd 분기) + **중철 단가행 오염 교정**(돈크리티컬). 표지/내지 인쇄·용지비 합산이 다부품 완성가(DT-BIND-SCOPE).
2. **(B) 세트형 = 세트 부모 공식 바인딩 + 부품 합산**(표지 별 prd_cd + 면지 택1 + 내지[페이지] + 제본비 B02). 세트 "구성"(sets)≠세트 "가격"(공식 Σ) 분리(이중계상 가드).
3. **★돈크리티컬 해소(확정)**: 제본비 `.01` 단가형 = **부당(권당) 단가가 옳다**(min_qty 하향 추이 입증) → 교정 불요. 디지털 명함 `.01→.02`(묶음총액 오적재)와 **단가 의미 정반대 — 무비판 전이 금지**(§5).

---

## 1. 계산방식 분류 — 다부품 합산형(frm_typ 미참조)

| 갈래 | 계산방식 | 정의 | 엔진 처리(engine-contract·pricing.py) |
|------|---------|------|---------------------------------------|
| (A) | **다부품 합산형(단일 prd)** | 판매가 = [표지 인쇄·용지비] + [내지 인쇄·용지비 × 페이지] + [제본비(부당×부수)] + Σ후가공 − 수량할인 | **FORMULA 경로**(:320-326)·합산형 comp Σ(addtn_yn=Y)·제본비 comp proc_cd 분기 |
| (B) | **다부품 합산형(세트 부모)** | 판매가 = [표지 인쇄·용지비(별 prd_cd 부품)] + [내지비 × 페이지] + [제본비 B02(부당×부수)] + Σ후가공 − 수량할인 | **FORMULA 경로**·세트 부모 prd_cd에 바인딩·세트 sub_prd=구성(BOM)·가격은 공식 Σ |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·`pricing.py:8` "공식유형 frm_typ 폐기"·라이브 t_prc_price_formulas frm_typ_cd 컬럼 부재). "제본비형"·"세트형"은 **별 엔진 분기가 아니라 어느 부품 comp 집합을 한 공식에 배선하느냐의 차이**일 뿐. 디지털·아크릴·실사·문구 설계 §1과 동형(frm_typ 미참조 계약 동일).

★ **(A)/(B) 결정적 차이 = 세트 그릇 사용 여부**: (A)는 표지/내지가 시트 컬럼(같은 행 옵션 축)이라 sets 분해 없음. (B)는 표지·면지가 별 prd_cd(`t_prd_product_sets`)로 분해(생산 BOM·복수 면지색 선택지). **둘 다 가격은 공식(PRF)의 comp Σ로 계산**(세트 sub_prd 자체는 가격 비기여 — §5 이중계상 가드).

---

## 2. ★(A) 제본비형 — stale 배선 교정 + 중철 단가행 오염 교정 (W1·W2·돈크리티컬·1순위)

### 2.1 현 라이브 결함 (실측 확정·G-BK-2)

```
PRD_000068 중철책자 ─┐
PRD_000069 무선책자 ─┼─[바인딩]→ PRF_BIND_SUM (use_yn=Y)
PRD_000070 PUR책자  ─┤              └─ formula_components = COMP_BIND_JUNGCHEOL 1개뿐
PRD_000071 트윈링책자 ─┘                  (addtn_yn=Y·disp_seq 1·★comp del_yn='Y'=삭제됨!)
```

★ **결함 본질**: PRF_BIND_SUM이 **삭제된(del_yn='Y') COMP_BIND_JUNGCHEOL**을 가리킨다(통합 후 배선 갱신 누락). 활성 통합 comp **COMP_BIND_TWINRING**(del_yn='N'·4 proc_cd=중철 018/무선 019/PUR 020/트윈링 021·use_dims=`[proc_cd,min_qty,proc_grp:PROC_000017]`)은 미배선.

★ **엔진 영향**: `_evaluate_formula`가 del_yn='Y' comp를 합산에 포함하는지가 결정적. **삭제 comp가 합산되면**(del 필터 미적용) 중철 단가만(JUNGCHEOL=정답 중철값) 산출·무선/PUR/트윈링 4상품 모두 중철값 misfire. **삭제 comp가 제외되면**(del_yn='N' 필터) PRF_BIND_SUM은 **comp 0개=가격 0원/no_match**(4상품 가격계산 불가). 어느 쪽이든 **무선/PUR/트윈링은 자기 제본비를 못 받음**(중철값 misfire 또는 0원). → **재배선 필수**.

> **[검증 결과·validator 2026-06-20]** pricing.py·models.py에 del_yn 참조 **0건**(기본 매니저)=**del_yn 필터 부재 확정→삭제 comp도 평가에 포함됨**. 따라서 "del 필터 적용 시 0원" 가설은 코드상 미발생이고 실제 양상은 중철값 misfire(또는 proc_cd 미주입 시 0원 분기). **4상품 정상 가격 불가·재배선 필수 결론은 불변.**

### 2.2 설계 — 제본비형 공식 분기 (상품별 1:1 vs 공유 proc_cd 분기)

**★핵심 결정 (AD-BK1): 단일 공유 공식 + proc_cd 자동분기** — 4상품(068~071)이 같은 `PRF_BIND_SUM`(또는 상품별 전용)을 쓰되, **제본비 comp가 proc_cd 차원으로 제본방식을 자동분기**한다.

| 후보 | 설계 | trade-off |
|------|------|-----------|
| **후보 ① 공유 공식 + proc_cd 분기 (권고)** | 068~071 모두 PRF_BIND_SUM·formula_components=COMP_BIND_TWINRING(통합·4 proc_cd)·손님 제본방식 선택→proc_cd 주입→해당 단가행 매칭 | comp 1개·use_dims=[proc_cd,min_qty] 이미 보유·통합 comp 패턴([[dbmap-price-component-grouping]]) 정합·**공식 1개로 4상품 커버** |
| 후보 ② 상품별 전용 공식 | PRF_BIND_JUNGCHEOL/MUSEON/PUR/TWINRING 4 공식 신설·각자 1 proc_cd | 공식 4개·과설계(제본방식=상품 고정이라 proc_cd 분기 불요한 듯하나, 한 상품=한 제본방식이므로 분기 자동값) |

★ **권고 = 후보 ①** (디지털 D-1 명함 variant 전용 PRF와 **다른 결정**·이유 명시):
- 명함 variant는 use_dims가 제각각(STD=[mat_cd,min_qty]·SHAPE=[siz_cd,min_qty])이라 한 공식에 묶으면 `_combo_key` 충돌·ERR_AMBIGUOUS → 전용 PRF 필요.
- **제본비는 4 proc_cd 전부 동일 use_dims `[proc_cd,min_qty,proc_grp:PROC_000017]`** → proc_cd가 판별차원으로 작동(중철 선택→PROC_000018 행만 매칭). **`_combo_key` 충돌 없음**(proc_cd가 NON_QTY_DIMS 멤버·정확매칭) → 통합 comp 1개로 안전 분기. 통합 comp 패턴이 정확히 이 용도.
- 단, **각 상품이 한 제본방식 고정**(중철책자=중철만)이므로 proc_cd는 손님 선택이 아니라 **상품→proc_cd 고정값 주입**(중철책자 견적 시 proc_cd=PROC_000018 자동) — CPQ option 또는 상품 메타에서 결정(§7·Q-BK-PROC).

### 2.3 재배선 명세 (W1·formula_components)

```
PRF_BIND_SUM (use_yn=Y·유지)
  formula_components 교정:
    삭제: COMP_BIND_JUNGCHEOL (del_yn='Y' comp 참조 제거)  ← stale 배선
    신규: COMP_BIND_TWINRING  (addtn_yn='Y'·disp_seq 1)    ← 활성 통합 comp(4 proc_cd)
```

- **search-before-mint**: COMP_BIND_TWINRING·use_dims·단가행 전부 실재(신규 mint 0). **작업=formula_components 1행 UPDATE/REPLACE**(stale comp_cd → 활성 comp_cd).
- **제본방식 proc_cd 분기**: COMP_BIND_TWINRING use_dims에 proc_cd 보유 → 중철책자=PROC_000018·무선책자=PROC_000019·PUR=020·트윈링=021로 자동 매칭. **상품→proc_cd 주입이 선결**(미주입 시 4 proc_cd 전부 와일드카드 후보 → 어느 행? → silent 다중매칭 위험). → §7 CPQ proc_cd 주입(Q-BK-PROC).

★ **돈크리티컬 가드 [HARD]**: proc_cd 주입 없이 재배선만 하면 **중철책자 견적 시 4 proc_cd 단가행(중철+무선+PUR+트윈링)이 전부 매칭→합산** 위험(실사 PUNCH_4/6/8 silent 합산·디지털 S1/S2 동형). use_dims에 proc_cd가 있으나 **단가행에 proc_cd 값이 채워져 있고**(실측 확인: PROC_000018~021 행 존재) **손님/상품이 proc_cd를 selections에 주입**해야 1개 proc_cd만 매칭. proc_cd 주입 레이어(CPQ option→차원)가 선결(디지털 G-7·문구 Q-ST-OPT1 동형).

### 2.4 ★중철 단가행 오염 교정 (W2·G-BK-1·돈크리티컬)

**라이브 실측 확정**:

| comp_cd / proc_cd | 1 | 4 | 10 | 30 | 50 | 70 | 100 | 1000 | 판정 |
|---|---|---|---|---|---|---|---|---|---|
| **COMP_BIND_TWINRING / PROC_000018(중철)** | 4000 | 3000 | 2000 | 1500 | 1500 | 1300 | 1300 | 1000 | ❌ **오염**(트윈링 값) |
| COMP_BIND_TWINRING / PROC_000021(트윈링) | 4000 | 3000 | 2000 | 1500 | 1500 | 1300 | 1300 | 1000 | (정상·중철과 동일=오염 증거) |
| **COMP_BIND_JUNGCHEOL(del='Y') / PROC_000018** | **3000** | **2000** | **1500** | **1000** | **1000** | **700** | **700** | **500** | ✅ **정답**(가격표 B01 중철·verbatim) |

★ **결함 확정**: 통합 COMP_BIND_TWINRING의 중철(PROC_000018) 8행이 **트윈링(PROC_000021)과 byte-동일** = 통합 시 중철값을 트윈링값으로 잘못 복사. **정답 중철값은 삭제된 COMP_BIND_JUNGCHEOL이 verbatim 보유**(가격표 B01: 1=3000, 4=2000, …).

**교정 명세 (W2·dbmap 위임)**:
```
UPDATE t_prc_component_prices
  SET unit_price = (COMP_BIND_JUNGCHEOL PROC_000018 동 min_qty 값)
  WHERE comp_cd='COMP_BIND_TWINRING' AND proc_cd='PROC_000018'
   -- min_qty 1→3000·4→2000·10→1500·30→1000·50→1000·70→700·100→700·1000→500 (B01 verbatim)
```
- **값 출처 = 삭제된 COMP_BIND_JUNGCHEOL 단가행 verbatim**(가격표 B01 중철 = 정답·날조 0).
- **영향**: 중철책자(PRD_000068) 부당 제본비 직접 교정. 교정 전 중철 4부 = 3000원/부(트윈링값) → 교정 후 2000원/부(정답). **돈크리티컬**(과청구 50%).
- **무선/PUR/트윈링(019/020/021)은 정상** — 교정 불요(가격표 B01 일치 실측 확인).

★ **실 교정은 명세까지** — dbm-price-arbiter 심의(가격사슬 영향) + 인간 승인 후 dbm-axis-staged-load/dbm-load-execution 위임. **단가값=verbatim·멱등 UPSERT·백업·undo**(round-23 패턴).

---

## 3. ★(A)+(B) 표지/내지/인쇄 comp 신설·합산 배선 — DT-BIND-SCOPE 결판 (W3·G-BK-3·2순위)

### 3.1 DT-BIND-SCOPE 결판 (cartographer §4 증거 종합 → 본 설계 확정)

> **질문**: 책자 가격 = "제본비 단일항"(라이브 현황) vs "표지+내지+인쇄+제본 부품 합산"?
> **결판 기준[HARD·benchmark]**: **권위 가격표가 부품별 단가를 주면 부품 합산이 정답.**

| 증거 | 내용 | 함의 |
|------|------|------|
| E-1 가격표 제본 시트(B01/B02) = 제본비만 | "제본/수량" 매트릭스·표지비/내지비/인쇄비 없음 | 제본 시트만으로는 부품 합산 불가 |
| E-2 B02 메모 "표지비용 따로 계산" | 하드커버 표지비 별도 산정 명시 | 표지는 별 가격구성요소 존재해야 |
| E-3 상품마스터 책자 = 표지/내지 사양 보유·가격 컬럼 0 | 표지종이·내지종이·인쇄·페이지 컬럼 실재(사양·가격 아님) | 표지/내지 가격은 종이비 단가표(디지털인쇄 종이비 계열)에서 룩업 |
| E-4 라이브 표지/내지 comp = **0행**(실측 확정) | 가격사슬에 제본비만 | 현 라이브 = "제본비 단일항"(broken·미완) |
| E-5 세트 그릇 실재(sets 28행) | 표지·면지를 별 prd_cd로 분해 | 부품 분리 그릇 보유(vessel-gap 아님) |

★ **본 설계 결판 (DT-BIND-SCOPE = 부품 합산)**:
- **부품별 단가가 권위에 "흩어져" 존재** — 제본비는 가격표 제본 시트(B01/B02·실재·verbatim)·표지/내지 용지·인쇄 단가는 **디지털인쇄 종이비(COMP_PAPER)/인쇄비(COMP_PRINT_DIGITAL_S1) 계열**(별 시트). 즉 **부품 합산이 정답 방향**이나 단가 소스가 시트 간 분산.
- **현 라이브 "제본비 단일항"은 완성가가 아닌 미완**(표지/내지/인쇄 미합산). 다부품 완성가 = **제본비 + 표지 인쇄·용지비 + 내지 인쇄·용지비(×페이지수) + (박/형압/코팅 후가공)**.
- `확신도: 중`(부품 합산 방향 명확·표지/내지 단가 소스 시트 매핑은 가격표 재대조 필요·검증가 E1·컨펌큐 Q-BK-COVER).

### 3.2 표지/내지 comp 설계 (search-before-mint)

| 부품 | 단가 소스(권위) | comp 후보 | search-before-mint | prc_typ 가드 |
|------|----------------|-----------|---------------------|--------------|
| **표지 용지비** | 디지털인쇄 출력소재 시트(종이별 절가) | **COMP_PAPER 재사용**(use_dims=[siz_cd,mat_cd]·56행 실재) — 표지 종이=mat_cd 차원 | ★재사용 우선(신규 mint 회피)·표지 사이즈=완제 siz_cd | COMP_PAPER prc_typ=.01·단가=절가(★디지털 명함류 묶음총액 결함과 별개·검증가 재확인) |
| **표지 인쇄비** | 디지털인쇄비 시트([수량][출력판형]×도수) | **COMP_PRINT_DIGITAL_S1 재사용**(212행 실재) | ★재사용 우선 | .01·인쇄면(print_opt_cd) silent 이중합산 가드 상속(D-3 동형) |
| **내지 용지비** | 디지털인쇄 출력소재 시트 | **COMP_PAPER 재사용**·내지 종이=mat_cd | ★재사용 | ×페이지수 = 앱계산(§6·DB는 1면 단가만) |
| **내지 인쇄비** | 디지털인쇄비 시트 | **COMP_PRINT_DIGITAL_S1 재사용**·×페이지수 | ★재사용 | ×페이지수 앱계산 |

★ **search-before-mint 결론**: 표지/내지 용지·인쇄비는 **디지털인쇄 COMP_PAPER·COMP_PRINT_DIGITAL_S1 재사용이 우선**(신규 표지/내지 전용 comp mint 회피). 단 **무손실 표현 가능한지 검증 필요**:
- COMP_PAPER use_dims=[siz_cd,mat_cd]가 표지/내지 용지를 담는가? — 표지 mat_cd(아트지250 등)·siz_cd(완제 사이즈)로 단가 룩업 가능하면 재사용. **가격표 디지털인쇄 종이비 시트가 책자 표지/내지 용지 절가를 포함하는지 재대조**(검증가 E1·컨펌큐 Q-BK-COVER).
- 포함 안 하면(책자 전용 표지/내지 단가표면) **신규 comp 정당**(COMP_BOOKLET_COVER/INNER·채번 MAX+1·`_`·가격표 출처 필수).

★ **결정 (AD-BK2·확신도 중)**: **표지/내지 = COMP_PAPER + COMP_PRINT_DIGITAL_S1 재사용 가설 우선**(디지털 종단 그릇 공유). 무손실 불가(책자 전용 단가표) 입증 시에만 신규 mint. **본 설계는 재사용 방향 명세 + 검증 게이트**(Q-BK-COVER 컨펌 후 확정).

### 3.3 합산 배선 명세 (W3·formula_components)

```
PRF_BIND_SUM (또는 상품별 공식·068~071) — 다부품 완성가 (DT-BIND-SCOPE=부품 합산)
  formula_components (전부 addtn_yn='Y'·Σ):
    disp_seq 1: COMP_BIND_TWINRING        (제본비·proc_cd 분기·부당×부수)  [W1 재배선]
    disp_seq 2: COMP_PAPER                 (표지 용지비·mat_cd 표지종이)     [W3 재사용]
    disp_seq 3: COMP_PRINT_DIGITAL_S1      (표지 인쇄비·도수)               [W3 재사용]
    disp_seq 4: COMP_PAPER                 (내지 용지비·mat_cd 내지종이·×페이지=앱)  [W3·내지]
    disp_seq 5: COMP_PRINT_DIGITAL_S1      (내지 인쇄비·×페이지=앱)         [W3·내지]
    disp_seq 6~: (후가공 박/형압/코팅 add-on·선택 시)                       [W3·후가공]
```

★ **★COMP_PAPER 2회 배선 충돌 가드 [HARD]**: 표지(disp_seq 2)·내지(disp_seq 4) 둘 다 COMP_PAPER면 **같은 comp_cd 2회 배선 → `_combo_key` 충돌·silent 이중합산/ERR_AMBIGUOUS** 위험(디지털 S1/S2 동형). 같은 comp를 표지·내지로 2회 합산하려면 **mat_cd 차원이 표지종이≠내지종이로 분기되어 각자 1행 매칭**되어야 안전. **표지/내지가 같은 mat_cd면 충돌** → 이 경우 **표지/내지 별 comp 분리 필요**(COMP_BOOKLET_COVER_PAPER/INNER_PAPER 신설 정당화). → 컨펌큐 Q-BK-COVER + 검증가 E4(comb_key 충돌 재현).

★ **결정 (AD-BK3·확신도 중)**: **표지/내지 용지비를 한 COMP_PAPER 2회 배선은 위험** — mat_cd 차원만으로 분기 시 손님이 표지=내지 동일 종이 선택하면 충돌. **안전 설계 = 표지/내지 전용 comp 분리**(신규 mint·무손실 표현 위해)가 유력하나, 가격표 단가 소스 재대조 후 확정(Q-BK-COVER). 본 설계는 **재사용 우선 + 충돌 가드 명세**(검증가가 comb_key 충돌 재현으로 판정).

---

## 4. ★(B) 세트 부모 부품 합산 — 하드커버/포토북 바인딩 (W4·G-BK-4·2순위)

> 상세 세트 조합 모델은 `set-product-design.md` 책자 절. 본 절은 공식·바인딩·제본비 소스.

### 4.1 세트 부모 5상품 바인딩 명세

| 세트 부모 | 제본방식 | 제본비 소스(B02) | proc_cd | 공식(바인딩) | sub_prd(구성·가격 비기여) |
|----------|---------|------------------|---------|-------------|---------------------------|
| PRD_000072 하드커버책자 | 하드커버무선 | COMP_BIND_SSABARI/PROC_000023(30000~6000) | PROC_000023 | **PRF_HC_MUSEON_SUM** (신설 or PRF_BIND_SUM 공유) | 표지 073 + 면지 074/075/076(택1 색) |
| PRD_000077 레더 하드커버책자 | 하드커버무선 | SSABARI/PROC_000023 | PROC_000023 | PRF_HC_MUSEON_SUM | 표지 078(레더) + 면지 079/080/081 |
| PRD_000082 하드커버 링책자 | 하드커버트윈링 | SSABARI/PROC_000024(30000~7000) | PROC_000024 | **PRF_HC_TWINRING_SUM** | 표지 083 + 면지 084~087(인쇄면지 포함) |
| PRD_000088 레더 링바인더 | (보류중·공란) | (미정) | — | **BLOCKED**(§4.3·G-BK-8) | 표지 089(레더) + 면지 090~093 |
| PRD_000100 포토북 | (포토북 시트·하드/아트/레더/소프트 표지 variant) | (포토북 제본·표지 소재 택1) | — | **PRF_PHOTOBOOK_SUM**(컨펌 Q-BK-PHOTO) | 7 sub variant(내지 101 + 표지 102~107) |

### 4.2 세트 부모 공식 설계 (제본비 = B02 하드커버 매트릭스)

★ **결정 (AD-BK4): 제본방식별 공식 분기**(하드커버무선/하드커버트윈링/싸바리) — (A)의 proc_cd 분기와 동형이나 **B02 SSABARI 통합 comp(3 proc_cd) 사용**:

```
PRF_HC_MUSEON_SUM (하드커버무선·072/077)  ─┐
PRF_HC_TWINRING_SUM (하드커버트윈링·082)   ─┼─ 또는 공유 PRF_BIND_SUM(B02 SSABARI 통합 comp·proc_cd 분기)
                                            ┘
  formula_components:
    disp_seq 1: COMP_BIND_SSABARI          (제본비 B02·proc_cd 023/024/098 분기·부당×부수)
    disp_seq 2: COMP_PAPER(or 표지전용)     (표지 인쇄·용지비·"따로 계산"=B02 메모·E-2)
    disp_seq 3: COMP_PRINT_DIGITAL_S1       (표지 인쇄비)
    disp_seq 4~5: 내지 용지·인쇄(×페이지)
    disp_seq 6~: 후가공(박/형압)
```

★ **search-before-mint (공식 신설 vs 공유)**:
- **후보 ① 공유 PRF_BIND_SUM + proc_cd 분기**: (A)와 같은 공식에 B02 SSABARI comp 합류·proc_cd가 하드커버무선/트윈링/싸바리 분기. 공식 신설 0. 단 (A)는 B01(COMP_BIND_TWINRING)·(B)는 B02(COMP_BIND_SSABARI) → **두 제본 comp가 같은 공식에 배선되면 손님이 중철 선택 시 SSABARI 행도 후보?** proc_cd 분기로 안전(중철=PROC_000018만 매칭·하드커버무선=PROC_000023만) → 충돌 없으면 공유 가능.
- **후보 ② 제본방식별 전용 공식**: PRF_HC_MUSEON_SUM 등 신설. 명확하나 공식 수 증가.

★ **권고 = 후보 ① 공유 + proc_cd 분기 우선**(공식 신설 0·통합 comp 패턴 정합)·단 **(A)/(B) 부품 집합이 다르면**(B는 표지 "따로" + 면지 + 인쇄면지) **comp 집합 차이로 공유 불가** → 그 경우 후보 ②(전용 공식). **본 설계는 후보 ① 우선·comp 집합 분석 후 분기 결정**(검증가 E5). 신규 공식 신설은 무손실 불가(부품 집합 상이) 입증 후.

### 4.3 ★레더 링바인더(PRD_000088) BLOCKED — 보류중 (G-BK-8)

- 상품마스터 시트상 **"(보류중)"**·제본방식 컬럼 공란·page_rule 부재(라이브 page_rules에 088 없음·실측 확인). 세트 그릇만 실재(표지 089 + 면지 090~093).
- **설계 = 바인딩 보류**(BLOCKED). 제본방식 미정이라 제본비 comp/proc_cd 결정 불가. 정체 확정(상품마스터 "보류중" 해소) 후 바인딩. **컨펌큐 Q-BK-BINDER**.

### 4.4 포토북(PRD_000100) — 7 sub variant·표지 소재 택1 (컨펌)

- 7 sub = 내지 101(몽블랑130) + 표지 6 variant(하드커버 102·아트250+무광 103·레더하드커버 105·레더 106·소프트커버 107) + 면지 104(그레이). **표지 소재 택1**(6 variant 중 손님 선택)·면지 택1.
- 표지 소재별 단가 차이 → **표지 comp가 mat_cd/표지타입 차원으로 분기**(set-product-design §책자 참조). 제본방식=포토북 제본(B02 또는 별도)·page_rule 24/150/2.
- **컨펌큐 Q-BK-PHOTO**(포토북 제본방식·표지 variant별 단가 소스·면지 가격기여 여부).

---

## 5. ★세트 "구성"(sets) ≠ 세트 "가격"(공식 Σ) 분리 — 이중계상 가드 (W5·G-BK-5) [HARD]

| 구분 | 책자 요소 | 가격 처리 |
|------|----------|-----------|
| **세트 "구성"(생산 BOM·MES)** | sub_prd(표지 073·면지 074/075/076 화이트/블랙/그레이) | `t_prd_product_sets`·**가격 비기여**(주문/생산 단위 묶음·택1 색상 선택지) |
| **세트 "가격"(공식 Σ)** | 표지비 + 내지비 + 제본비 + 후가공 | PRF 공식의 formula_components Σ(가격 권위) |

★ **이중계상 가드 [HARD]**:
- **면지 4행(074/075/076 = 화이트/블랙/그레이)을 "부품 4개 합산"하면 이중계상** — 면지는 **택1 색상 옵션**(손님이 1색 선택)이지 4색 전부 합산 아님. sub_prd_qty=1·min/max_cnt NULL(택1 의미).
- **세트 sub_prd를 가격 합산에 끌어들이지 말 것**(benchmark P-1b·문구 DT-5 정합). 가격은 **공식의 comp Σ**로만 계산. sets는 어떤 표지/면지를 쓰는지 **구성(BOM) 정보**.
- **면지 색상이 가격에 영향?** — 화이트/블랙/그레이 면지가 같은 단가면 가격 비기여(택1 UI). 색상별 단가 차이가 있으면 **면지 comp의 mat_cd 차원으로 1행 매칭**(택1 선택값 주입). 현 라이브 면지 comp 0행 → 면지 가격기여 미정(컨펌 Q-BK-MYUNJI).

★ **디지털 엽서북(D-5)과의 일관**: 엽서북도 내지/표지 별 SKU(sets)이나 **가격은 완제품 통합단가**(BOM 이중계상 0). 책자(B)는 엽서북과 달리 **표지/내지가 진짜 별 단가로 합산**(부품 합산형)이나, **sub_prd 자체(면지 색 4행)는 여전히 구성**(가격은 공식 comp Σ). 세트 sub_prd ≠ 합산 항.

---

## 6. ★이중수량(부수×페이지) + 페이지 파생 — 앱계산 vs DB룩업 (W6·G-BK-6·돈크리티컬) [HARD]

> 후니 "중간계산=앱·DB=룩업" 원칙([[dbmap-compute-in-app-db-stores-lookup]]) 절대 준수.

### 6.1 두 수량 축 구분 [HARD·혼동 금지]

| 축 | 의미 | 차원/입력 | 가격 작용 |
|----|------|----------|-----------|
| **부수(주문수량)** | 책 몇 권 | `qty`(주문수량)·제본비 min_qty TIER | 제본비 = 부당가 × 부수·볼륨할인 |
| **페이지수(내지)** | 책 1권 몇 페이지 | `t_prd_product_page_rules`(입력 차원·068=4~28/4·069=24~300/2) | 내지비 = 1면 단가 × 페이지수(앱 곱)·DB는 1면 단가만 |

★ **혼동 금지 [HARD]**: 제본비는 **부수 차원만**(min_qty=주문 부수). 내지비는 **부수 × 페이지수**(앱 런타임 2중 곱). 두 축을 섞으면 오모델(benchmark §2 가드).

### 6.2 페이지수 = 입력 차원·SKU 폭발 금지

- `t_prd_product_page_rules`(라이브 11행·실측: 068=4/28/4·069/070/072/077=24/300/2·071/082=8/100/2·094=20/30/10·097=3/3/3·100=24/150/2·176=28/28/0). **페이지수=입력 차원**(RedPrinting INN_PAGE 동형·2~300면을 siz_cd SKU로 베이크 금지).
- **내지단가 × 페이지수 = 앱 런타임 계산**·DB는 1면(또는 1대) 단가 룩업(COMP_PAPER siz_cd·COMP_PRINT_DIGITAL_S1). benchmark C-BK2 정합.

### 6.3 책등(seneca) = 페이지수 파생·앱계산·DB 미저장

- 책등 = 페이지수 × 내지두께 파생값(무선/하드커버 표지 면적 영향). **앱 런타임 계산**(off-grid ceiling·판수·박등급과 동일 철학)·DB 미저장. **신규 축/단가행 불요**(benchmark C-BK3 정합·seneca naming 유입 금지).

### 6.4 WowPress 작업량 2단(jobqty→jobcost) 부결

- WowPress `jobqty0→jobcost0`(페이지·제본·부수→작업량 스칼라 환산 후 단가) = **흡수 부결**(과분화·DB가 파생값 저장·후니 원칙 위배). 후니 단일 evaluate_price + 앱 계산(작업량 환산을 앱에서)/단가 룩업 분리로 이미 표현(benchmark C-BK5). ★단 환산 규칙(내지 출력매수·판수)은 **후니 앱 계산 로직 도메인 단서**(가격축 신규 아님·앱 함수).

---

## 7. CPQ 옵션 (W7·G-BK-7·가격기여 분별)

| 옵션 | 가격기여 | 처리 | 그릇 |
|------|---------|------|------|
| **제본방식(중철/무선/PUR/트윈링)** | ★**가격축**(proc_cd 분기·제본비 단가 결정) | 상품→proc_cd 고정값 주입(중철책자=PROC_000018) | round-6 CPQ option→proc_cd 주입(**§2.3 선결·Q-BK-PROC**) |
| **페이지수** | ★가격축(내지비 × 페이지) | 입력 차원·page_rules 제약(min/max/incr) | t_prd_product_page_rules(라이브 실재) |
| **표지 소재(전용지/레더/아트)** | ★가격축(표지 용지비 mat_cd) | 택1→mat_cd 주입 | round-6 CPQ option→mat_cd 주입 |
| **면지 색상(화이트/블랙/그레이)** | 미정(택1·색별 단가차 있으면 가격축) | sub_prd 택1 | t_prd_product_sets(구성)·Q-BK-MYUNJI |
| **박/형압/코팅** | ★가격축(후가공 add-on Σ) | 선택 시 합산 | 후가공 comp(★silent 합산 가드·판별차원 충전) |
| **제본방향(좌철/상철·트윈링)** | 가격 비기여 | proc param | round-6 CPQ |
| **링컬러·투명커버(트윈링)** | 가격 비기여(or 소액 add-on) | option | round-6 CPQ |

★ **가격기여 vs 비기여 분별 [HARD]**: 제본방식·페이지수·표지소재·박/형압 = **가격축**(공식 comp·차원). 제본방향·링컬러 = 비기여(생산 UI). 디지털 G-7·문구 Q-ST-OPT1 동형(option_items→차원 자동주입 선결·미연결 시 0원 침묵).

---

## 8. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| 가격 소스 우선순위(TEMPLATE→PRODUCT_PRICE→FORMULA·:296-326) | ✅ 책자=FORMULA 경로(제본비+표지+내지 comp Σ)·세트 sub_prd는 가격 비기여 |
| C7 frm_typ 미참조·공식=합산 | ✅ (A)/(B) 둘 다 합산형 comp Σ(frm_typ 무참조)·제본방식=proc_cd 데이터 분기(엔진 코드 분기 아님) |
| P3-8 ERR_AMBIGUOUS / silent 이중합산 | ⚠️ **가드 필요**: ① 제본비 proc_cd 미주입 시 4 proc_cd 다중매칭(§2.3) ② COMP_PAPER 표지/내지 2회 배선 시 mat_cd 미분기 충돌(§3.3·AD-BK3). 검증가 E4 재현 |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ 제본비 `.01` 단가형·unit=부당가·unit×qty 정합(§5 돈크리티컬 해소)·÷min_qty 미발생. 표지/내지 comp prc_typ는 디지털 종단 결함 상속 점검(Q-BK-COVER) |
| TIER min_qty '이상' 하한(:42·144) | ✅ 제본비 min_qty=부수 TIER(주문 부수 이하 최대 임계·중철 4부=2000원/부) |
| U-7 시트 차원경계(SOT 1) | ✅ 책자 공식에 시트 밖 comp 침입 금지·표지/내지는 디지털인쇄 종이비 시트 경계 내 재사용(차원 분기 무손실 입증 후) |
| 수량구간할인 연결(:478-504) | ⚠️ 책자 t_prd_product_discount_tables 링크 점검(문구 DSC_STAT_QTY 동형·미점검·컨펌 Q-BK-DSC) |
| search-before-mint | ✅ 제본비 comp 재배선(신규 0)·표지/내지=COMP_PAPER·COMP_PRINT 재사용 우선(무손실 불가 입증 시만 신규)·세트 그릇 실재. **신규 mint 최소화**(충돌 가드 시 표지/내지 전용 comp 1~2건 가능·Q-BK-COVER) |

---

## 9. designer 큐 잔여 (golden-cases·design-decisions로 이관)

- **W1 PRF_BIND_SUM 재배선**(stale JUNGCHEOL → 활성 TWINRING·proc_cd 분기) + **W2 중철 단가행 오염 교정**(B01 verbatim) = 1순위(돈크리티컬·4상품 misfire/0원).
- **W3 표지/내지/인쇄 comp 합산 배선**(DT-BIND-SCOPE=부품 합산·COMP_PAPER/PRINT 재사용 우선·충돌 가드) = 2순위(다부품 완성가)·Q-BK-COVER 컨펌 후 확정.
- **W4 세트 부모 바인딩**(072/077/082/100·B02 SSABARI·표지 따로) = 2순위·088 BLOCKED(보류중).
- **W5 세트=BOM 이중계상 가드** + **W6 이중수량(부수×페이지)·페이지=입력·책등=앱** = 돈크리티컬 가드.
- **W7 CPQ proc_cd/mat_cd 주입**(가격기여 옵션) = 선결(silent 합산 회피).

실 적용(재배선·단가행 교정·comp 신설·세트 바인딩)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·dbm-price-arbiter·webadmin 코드 직접수정 금지).

## naming 유입 가드 [HARD]
`book2025_price`·`MTRL_CD`(RXART250)·`INN_PAGE`·`paperno3/4/5`·`jobqty0`/`jobcost0`·`seneca`·`COV_MIN_WGT`·`BIND_DIRECTION`·`ORD_CNT`/`PRN_CNT` 후니 유입 금지. 후니 `frm_cd`(PRF_BIND_SUM)·`comp_cd`(COMP_BIND_*·COMP_PAPER)·`proc_cd`·`page_rules`·`siz_cd` 컨벤션으로 번역([[dbmap-naming-standardization]] 권위순서: 후니 레거시→라이브 DB→rpmeta→인쇄표준).
