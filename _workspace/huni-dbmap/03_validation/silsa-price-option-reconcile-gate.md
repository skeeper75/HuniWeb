# silsa(일반현수막 PRD_000138) 가격엔진(A)+옵션레이어(B) 통합 재정합 게이트 — 독립 적대 검증

| 항목 | 값 |
|------|----|
| 게이트 | round-2+6 통합 독립 적대 검증 (R6 생성-검증 분리) |
| 검증자 | dbm-validator (생성자 dbm-mapping-designer[A]·dbm-option-mapper[B]와 분리) |
| 일자 | 2026-06-08 |
| 대상 A | `02_mapping/silsa-price-engine/price-mapping-spec.md` + `load/*.csv` (PRF_BANNER_NORMAL) |
| 대상 B | `10_configurator/silsa-option-layer.md` §2/§5 + `load_silsa/*.csv` (재정합 2026-06-08-B) |
| 권위 | 가격표 B26 실측(`06_extract/price-poster-sign-l1.csv` 직접 추출) · `04_audit/banner-domain-competitor-research.md` · 사용자 4답변(HARD) · 라이브 스키마(읽기전용 psql 직접 조회) |
| 방법 | 출처 직접 대조(생성자 결론 비편향) — B26 80셀 verbatim 추출·라이브 코드/공정/siz/컬럼 직접 확인 |

> **검증 제약 준수:** DB 쓰기 0(읽기전용 SELECT만). finding 조용히 수정 0(전건 라우팅). 라이브 직접 조회로 권위 확보.

---

## 총평 — **GO (조건부)**

W-1·W-2·W-5 = **PASS**(가격·옵션가·연결·BLOCKED 정직성 전건 출처 정합). W-4 = **PASS-WITH-NOTE**(sel_typ 택1 1차+[CONFIRM-MULTI] 근거 정합·일률강제 없음). **W-3 = CONDITIONAL**(R-GAKMOK "라이브 폼빌더 표현 가능" 단정이 over-claim — 라이브 admin 폼빌더 배열 멤버십 입력 지원 증거 부재. 단 BLOCKED 분류·차단 사유는 정직). W-3은 적재 가능성에 영향 없음(constraint 현 적재 0행·GAP-DEFER). **즉시 적재본(가격 INSERTABLE 13행·옵션 22행)은 GO**, 차단분은 정직 분리.

---

## W-1 사이즈 매트릭스 정합 — **PASS**

**검증:** B26 블록을 `price-poster-sign-l1.csv`에서 직접 verbatim 추출(가로 B~F열 × 세로 246~261행).

| 항목 | 권위(B26 직접 추출) | A/B 적재본 | 판정 |
|------|---------------------|-----------|:--:|
| 가로 축 | {900,1000,1200,1500,1750} 5규격 (B245 C~F 헤더 실측) | A siz 차원·B §1 동일 | ✅ |
| 세로 축 | {900,1000,1200,1400,1600,1800,2000,2200,2400,2600,2800,3000,3500,4000,4500,5000} **16규격**(A246~A261 직접 카운트=16) | A "16 이산"·B "16규격" | ✅ |
| 매트릭스 | 5×16=**80셀**, 단가 8000~72000 전수 명시 | A INSERTABLE 3 + BLOCKED 77 = **80** | ✅ 완전 |
| 셀단가 정합 | B246(900,900)=8000·E247(1500,1000)=12000·B248(900,1200)=8640 | INSERTABLE: SIZ_000323=8000·SIZ_000403=12000·SIZ_000320=8640 (라이브 치수 직접 확인 일치) | ✅ |
| BLOCKED 셀단가 | C246(1000,900)=8000·E246(1500,900)=10800·F261(1750,5000)=72000 | SIZ_000554=8000·588=10800·618=72000 (note verbatim 일치) | ✅ |
| off-grid 규약 | "한 단계 큰 규격 ceiling"(G247 메모) | A §2.5·frm note "가로·세로 각각 ceiling, DB 미적재 앱책임"(U-1 정합) | ✅ 양쪽 일관 |
| 비치수 연속 잔재 | — | R-SIZE-NONSPEC 폐기·products `nonspec_*` 컬럼 제안 철회·전 siz 이산 규격 | ✅ 잔재 0 |

**증거(라이브 직접):** `SIZ_000320=900×1200`·`SIZ_000323=900×900`·`SIZ_000403=1500×1000` (work_width/height 직접 조회). max 라이브 siz=`SIZ_000510` → 발명 채번 SIZ_000538~000618(77)은 max 위 범위라 충돌 0, 선존재 3규격 BLOCKED 누출 0.

**경미 노트(BLOCKER 아님):** siz 발명 채번 표기 불일치 — 실제 CSV는 `SIZ_000538~000618`인데, price-mapping-spec §2.3/§5는 `SIZ_000536~000618`, 옵션 레이어 §1은 `SIZ_000511~`로 표기. 실 CSV가 권위(538~618, 77개 정합). 문서 본문 숫자만 stale → **라우팅: A=mapping-designer(§2.3/§5 채번 표기 538로 정정)·B=option-mapper(§1 511→538 정정)**. 적재값 자체는 영향 0.

---

## W-2 옵션 추가가격 — **PASS**

**검증:** B26 J/K(가공)·M/N(추가) 컬럼 직접 추출 vs A component_prices.

| 옵션 | B26 실측(직접) | A component(price) | flat/개수/길이 | 판정 |
|------|---------------|--------------------|---------------|:--:|
| 열재단 | K246=3000 | COMP_BANNER_FIN_HEATCUT 3000 | flat | ✅ |
| 타공4/6/8 | K247/248/249=3000/4000/5000 | EYELET4/6/8 = 3000/4000/5000 | 개수별(comp 분리) | ✅ |
| 양면테입 | K250=3000 | COMP_BANNER_FIN_DTAPE 3000 | flat | ✅ |
| 봉미싱 | K251=4000 | COMP_BANNER_FIN_SEW 4000 | flat | ✅ |
| 큐방4 | N247=3000 | COMP_BANNER_ADD_QBANG4 3000 | flat | ✅ |
| 끈4 | N248=4000 | COMP_BANNER_ADD_STRING4 4000 | flat | ✅ |
| 각목900↓+끈 | N249=4000 | LUMBER_LE900 4000 (세로변≤900) | 길이 2단 | ✅ |
| 각목900↑+끈 | N250=8000 | LUMBER_GT900 8000 (세로변>900) | 길이 2단 | ✅ |

**comp_typ_cd 권위 정합(라이브 직접):** PRC_COMPONENT_TYPE 라이브 6종 = .01인쇄/.02코팅/.03용지/.04후가공/.05박형압/**.06완제품비** 전건 확인. 가공6=`.04 후가공비`·추가(큐방/끈/각목)=`.06 완제품비` — 라이브 코드 실재(stale 아님). 면적 comp `COMP_POSTER_BANNER_NORMAL`=라이브 선존재·comp_typ_cd=`.06 완제품비`·명칭"포스터 완제품가" — A가 발명 0(선존재 재사용).

**이중계상 검증(B 가격 미보유):** B option_items.csv = `prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn` — **가격 컬럼 0**(라이브 스키마도 가격 컬럼 없음, 직접 확인). B는 공정/셋트 참조만, 가격은 A가 보유. `option-component-link.csv`가 opt_cd↔comp_cd 연결(비적재 참조표). → **이중계상 없음**(B=구조, A=값 분리). ✅

---

## W-3 R-GAKMOK 세로변 재작성 — **CONDITIONAL (over-claim 부분 적발)**

**적대 질문:** B가 "각목↔세로변 900 siz_cd 집합 멤버십으로 라이브 폼빌더 표현 가능"(GAP-DEFER, 표현불가 아님)이라 주장 — 이산 siz_cd 하에서 정말 라이브 폼빌더로 표현 가능한가?

**증거 대조(B 자신이 인용한 라이브 권위):**
- `live-admin-groundtruth.md` LV-1(라이브 admin 폼빌더 스크린샷 03 실측): 폼빌더 = **"조건 차원값 ↔ 결과 차원값" 2항 코드 관계** — **각 차원에서 단일 코드값 선택**(siz_cd=X ↔ sub_prd_cd=Y).
- 같은 문서 **LV-2: "R-GAKMOK-HEIGHT 표준 표현 불가 → GAP(비치수 size 검증)"** 라고 명시 판정.

**판정:** B §5(재정합 2026-06-08-B)는 이 **LV-2 판정을 뒤집어** "siz_cd 집합 멤버십 `{"in":[{"var":"siz_cd"},[75개 배열]]}`으로 표현 가능"이라 단정했다. 적대 검증 결과:

1. **DB 스키마상 저장은 가능** — 라이브 `t_prd_product_constraints.logic`은 **jsonb 자유형**(직접 확인). 어떤 JSONLogic도 저장 가능. ← 이 한도에선 B 주장 성립.
2. **그러나 "라이브 폼빌더 표현 가능"은 over-claim** — B가 인용한 그 LV-1 실측은 **단일 코드값 2항 관계만** 보여줬고, **배열 멤버십(`in` + 75개 코드 배열) 입력을 admin 폼빌더 UI가 지원한다는 증거는 없다**. groundtruth는 오히려 LV-2에서 R-GAKMOK을 "표준 표현 불가"로 못박았다. B는 이 모순을 "이산화하면 해소"로 봉합했으나, **폼빌더 메커니즘이 배열을 받는지는 미검증**.
3. **현실적 표현은 75행 2항 분해** — 폼빌더가 2항 단일코드만 받는다면, "세로변>900인 siz 75규격"은 각 siz_cd마다 1행씩 **75개 2항 행 수작업**으로만 표현 가능. 이는 "표현 가능"이긴 하나 B가 말한 "siz_cd 집합 멤버십 다중행"과 메커니즘이 다르다(배열 1행 ≠ 75 단일행).

**그러나 차단·분류는 정직:**
- B는 R-GAKMOK을 **현 적재 0행·GAP-DEFER**로 분류 — 선행 2종(각목 sub_prd_cd 미등록·siz 76 미등록) BLOCKED를 명시. 즉 **지금 적재되지 않는다**.
- 이중 BLOCKED 정직: 각목 sub_prd_cd 자체가 라이브 부재(set 차원·각목 완제상품 0행, 직접 확인) → constraint `var:sub_prd_cd`가 가리킬 코드도 부재. B가 이를 숨기지 않고 명시.

**결론:** "표현불가 GAP 아님 → GAP-DEFER"로 **격하한 것이 over-claim**. 정확한 판정 = "**DB jsonb 저장은 가능하나, 라이브 admin 폼빌더의 배열-멤버십 입력 지원은 미검증 — 차원 2종 선등록 + 폼빌더 입력 방식(배열 1행 vs 75 단일행) 확정이 선행 조건**". 적재 가능성엔 무영향(현 0행). 
**라우팅: B=option-mapper** — §5 "라이브 폼빌더 표현 가능" 단정을 "jsonb 저장 가능·폼빌더 배열입력 미검증·75 단일행 분해 대안"으로 정정. **GAP-DEFER 분류 자체는 유지**(차단 정직).

**경미 결함(별건):** GAP CSV 헤더 컬럼명 `logic_target_spec`은 라이브 컬럼 `logic`(jsonb)과 불일치(직접 확인). 현 적재 0행이라 무해하나 적재 시 `logic`으로 매핑 필요. **라우팅: B=option-mapper**(헤더 주석에 라이브 컬럼=logic 명시).

---

## W-4 sel_typ 판정 — **PASS-WITH-NOTE**

| 그룹 | sel_typ_cd | min/max | mand | 근거 정합 | 판정 |
|------|-----------|---------|------|----------|:--:|
| OG-GAGONG | SEL_TYPE.01(택1) `[CONFIRM-MULTI]` | 1/1 | Y | B26 J/K 단일컬럼 캐스케이드(한 셀=한 값)+가공에 "추가없음" 부재=항상 1선택=필수 | ✅ |
| OG-CHUGA | SEL_TYPE.01(택1) `[CONFIRM-MULTI]` | 0/1 | N | B26 M/N 단일컬럼+"추가없음=0원" 센티넬 존재=선택(min0) | ✅ |

**적대 검증:** ① 일률 강제 없음 — 둘 다 `[CONFIRM-MULTI]` 명시(타공+봉미싱/큐방+각목 복수 가능 시 SEL_TYPE.02 정정 여지). ② 근거 명시 — 1차=가격표 B26 캐스케이드(단일컬럼, 직접 추출로 J244/M244 헤더 "가공옵션명 > ... 단일 나열" 확인), 2차=Red pcs `type`(banner-research D.1·D.3, checkbox 혼재 명시). ③ 근거 없는 단정 0. 가격표 캐스케이드 권위 + Red 교차 + 불확실 [CONFIRM] = 정합 판정. **단 [CONFIRM-MULTI]는 리드 에스컬레이션 필요**(가격표만으론 복수가공 가능성 미확정 — banner-research Q-5).

---

## W-5 A↔B 연결·BLOCKED 정직성 — **PASS**

**A↔B 연결 정합:**
- `option-component-link.csv`(비적재 참조표): 11 opt_cd → comp_cd 1:1(OP-CHUGA-NONE만 comp 없음=0원 센티넬). 가격표 B26 옵션값과 char 일치. ✅
- 사슬 분리 정직(FIT-GAP-2): 가격엔진(상품→공식→구성요소)·옵션레이어(상품→옵션→공정) 두 사슬, opt_cd→comp_cd 직접 FK 없음 → 앱 참조표로 연결. DB 구조변경 0. ✅

**BLOCKED 정직성(over/under-block 검증):**

| BLOCKED 항목 | 사유 | 라이브 직접 확인 | over/under-block? |
|---|---|---|:--:|
| siz 76 미등록(가격 77 BLOCKED) | 발명 금지 | max siz=SIZ_000510, 76규격 부재 사실 | ✅ 정직(under-block 0) |
| 열재단 PROC_000084 | 신규 공정 신설 대기(M-1 ①) | PROC_000079/080/081만 PRD_000138 링크, 084 부재 | ✅ 정직 |
| 각목 seq2(set) ×2 | sub_prd_cd 미상 | set 차원 0행·각목 완제상품 0행 | ✅ 정직 |
| R-GAKMOK constraint | 차원 2종 선등록 | (W-3) | ✅ 차단 정직(단 "표현가능" 단정만 over-claim) |

**추측의 라이브 누출 0 검증:** `[CONFIRM]`/`[CONFIRM-CHANNEL]`/`[CONFIRM-MULTI]` 전건 명시 — 각목 sub_prd_cd·열재단 채번·양면테입→{대상:테입}·큐방 enum 확장 모두 발명 0(BLOCKED 또는 [CONFIRM] 플래그). 라이브 부재 코드를 INSERTABLE에 누출한 사례 0.

**라이브 컬럼 정합(직접 확인):** option_items CSV 헤더 = 라이브 컬럼 정합(ref_param_json 부재 정직·note 제거 F-1 준수). option_groups CSV note 컬럼 = 라이브 실재(정합). component_prices/formula_components/price_components CSV 헤더 전건 라이브 컬럼 정합(`_provenance`만 적재 시 제외 보조컬럼).

---

## 적재 가능성 집계

### A 가격엔진 (PRF_BANNER_NORMAL)

| 파일 | 행 | 판정 |
|------|:--:|:--:|
| t_prc_price_formulas | 1 | INSERTABLE(FRM_TYPE.01 합산형, 라이브 코드 실재) |
| t_prc_price_components | 10(옵션 comp 신설) | INSERTABLE(comp_typ .04/.06 라이브 실재) |
| t_prc_formula_components | 11 배선 | INSERTABLE |
| t_prc_component_prices_INSERTABLE | 13(면적 siz선존재 3 + 옵션 10) | INSERTABLE(가격 전건 B26 정합) |
| t_prc_component_prices_BLOCKED | 77(면적 siz 미등록) | BLOCKED(siz 76 선등록 대기) |
| t_prd_product_price_formulas | 1 바인딩 | INSERTABLE |
| **A 즉시 적재** | **26행**(1+10+11+13+1) | **GO** |

### B 옵션 레이어

| 파일 | 행 | 판정 |
|------|:--:|:--:|
| option_groups | 2 | INSERTABLE |
| options | 11 | INSERTABLE |
| option_items | 9 | INSERTABLE(079/080/081 라이브 링크 실재) |
| option_items_BLOCKED | 3 | BLOCKED(열재단 084·각목 seq2 ×2) |
| constraints_GAP | 1 | GAP-DEFER(현 적재 0·W-3 over-claim 정정 후) |
| **B 즉시 적재** | **22행**(2+11+9) | **GO** |

### 통합

| | INSERTABLE | BLOCKED/DEFER | 합 |
|---|:--:|:--:|:--:|
| A 가격 | 26 | 77(siz) | 103 |
| B 옵션 | 22 | 4(item3+constraint1) | 26 |
| **통합** | **48** | **81** | **129** |

> BLOCKED 81 = 가격 면적 siz 77(siz 76 선등록 시 해소) + 옵션 item 3 + constraint 1. 전부 차원 선등록·공정 신설·각목 상품 등록의 인간 승인 대기 — 발명 0.

---

## 발견 결함 (심각도·라우팅)

| # | 심각도 | 결함 | 라우팅 | 적재 영향 |
|---|--------|------|--------|----------|
| **F-1** | **MAJOR** | W-3: R-GAKMOK "라이브 폼빌더 표현 가능" 단정이 over-claim — B 인용 LV-1은 단일코드 2항만 실측, 배열 멤버십 입력 지원 미검증. LV-2는 "표현 불가" 판정인데 §5가 봉합 | **B=option-mapper**: §5를 "jsonb 저장 가능·폼빌더 배열입력 미검증·75 단일행 분해 대안" 으로 정정(GAP-DEFER 분류는 유지) | 없음(현 0행) |
| **F-2** | MINOR | constraints_GAP CSV 헤더 `logic_target_spec` ≠ 라이브 컬럼 `logic`(jsonb) | **B=option-mapper**: 헤더 주석에 라이브=logic 명시 | 없음(현 0행) |
| **F-3** | MINOR | siz 발명 채번 표기 stale — 실 CSV=538~618, A §2.3/§5=536~618, B §1=511~ | **A=mapping-designer·B=option-mapper**: 본문 538로 통일 | 없음(실 CSV 권위) |
| **N-1** | NOTE | sel_typ [CONFIRM-MULTI] 미해소(복수가공 가능성) | 리드 에스컬레이션(banner-research Q-5) | 택1 1차 적재 가능 |

> **편향 비판(W-3) 외 생성자 결론 정합도 높음** — A 가격 전건 B26 정합, B 구조·연결·BLOCKED 정직. 생성-검증 분리(R6)가 실결함 F-1(over-claim) 1건 적발.

---

## GO / NO-GO

**GO (조건부)** — 즉시 적재본(A 26행 + B 22행 = **48행**) 적재 가능성 검증 통과. 단:
1. **F-1 정정 권고**(W-3 over-claim) — 적재 무영향이나 문서 정직성 위해 B §5 정정. constraint는 어차피 현 0행이므로 적재 GO를 막지 않음.
2. **BLOCKED 81행**은 인간 승인 선행(siz 76 등록·열재단 PROC_000084 신설·각목 상품+sets 등록) — 정직 분리됨.
3. **실 INSERT·DDL·코드행·DRY-RUN은 인간 승인 대기**(하네스 원칙). 본 게이트는 적재 가능성 증명까지.

라이브 롤백전용 DRY-RUN(트리거 fn_chk_opt_item_ref 실발화 검증)은 리드 승인 시 추가 실증 가능 — 본 검증은 로컬 출처 대조 + 라이브 읽기전용 조회로 완료(쓰기 0).
