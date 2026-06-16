# RP-Meta M1~M6 게이트 판정 (mgate-verdict)

> rpm-validator. 4파이프라인 산출(01_reverse·02_metamodel·03_gap·04_vessel)을 **독립 재실측**으로 교차검증.
> 생성자 주장 비신뢰 — 소스 재대조(M1) + 라이브 `information_schema`/행수 재실측(M4·M5) 직접 수행.
> 재실측 세션: 2026-06-17, 라이브 Railway `railway` DB 읽기전용 SELECT(쓰기/주문/POST 0·비밀값 비노출).

---

## 종합 판정

| 게이트 | 대상 | 판정 | 근거 요약 |
|---|---|:---:|---|
| **M1** | 01_reverse 추출 충실성 | **GO** | BNBNFBL/BNPTPET 원자 전수 소스 재대조 일치(MAX_CUT·CUT_MRG·자재·PCS·flag·PRICE=0). 날조 0. |
| **M2** | 02_metamodel 정합 | **GO** | 13축 전부 추출 증거 도출·오버피팅 거부 명시·ERD↔사전 정합·도메인 경계 라이브 확증(별색=공정). |
| **M3** | discovered-axes 타당성 | **GO** | D-1~D-7 distinctness 재검 통과·D-8 facet 강등 정당·미발굴 갭(카테고리/usage) 정직 명기. |
| **M4** | 03_gap 판정 정확 | **GO** | 12개 핵심 행수·컬럼 존재 라이브 재실측 일치. "스냅샷 stale→라이브 정정"(option_items 0→469 등) **독립 확인**. |
| **M5** | 04_vessel 건전성 | **GO** | search-before-mint 라이브 입증(width/weight/upr_mat_cd·mand_yn 실재 / ref_param_json·MAT_FACET·RULE_TYPE.04 부재). 신규 테이블 mint 0 정당. |
| **M6** | 생성-검증 독립성 | **GO** | self-approve 0(검증자=별 레인). dodge-hunt 4건 전부 재실측으로 깨기 실패(=주장 견고). |

**전체: GO.** 결함은 전부 Low(문서 정합·freshness 노트)·차단 0. `_defects.md` 라우팅 참조.

---

## M1 — 추출 충실성 (after 01_reverse) → **GO**

추출 산출(`rp-option-extract-BN.md`)의 `[reuse:Vue-BFF]` 2상품(BNBNFBL·BNPTPET)을 인용 소스
(`huni-widget/01_reverse/s3_raw_captures/s3_BNBNFBL.json`·`s3_BNPTPET.json`)에 직접 재대조.

### 재실측 증거 (BNBNFBL — `rp-option-extract-BN.md:37~81`)
| 추출 원자 | 추출값 | 캡처 재실측 | 일치 |
|---|---|---|:--:|
| MAX_CUT_WDT/HGH | 5000 | `5000.00` | ✅ |
| CUT_MRG | 4mm | `4.00` | ✅ |
| item_gbn/price_gbn | real_item/real_price | `real_item`/`real_price` | ✅ |
| WDT_HGH_GBN_YN/NO_STD_ABL_YN | N/N | `N`/`N` | ✅ |
| editor useKoi/useRP | N/N | `N`/`N` | ✅ |
| PRN_CLR_CNT | 4 | `4` | ✅ |
| 자재 PXBFCXXX | 단일 | present | ✅ |
| PCS 그룹 8종(CUT_ZUN·ILT_DFT·LUM_DFT·QBG_DFT·ROP_DFT·SEW_DFT·SEW_RIN·SUB_MTR) | 전부 | 8/8 present | ✅ |
| PCS 멤버(ZDINC·ZDWND·ZDFRM·RCDFT·RCALL·DFLTG·DM003·DM005·DNFLD·DNARN·CT001) | 전부 | 11/11 present | ✅ |
| 사이즈 프리셋(5000X900·900X900·900X5000·1800X1780) | 전부 | 4/4 present | ✅ |
| 플래그(SUB_MTRL_YN·QTY_INPUT_YN·ESN_YN·ORD_CNT·PRN_CNT) | 전부 | 5/5 present | ✅ |
| PRICE | 0 (비로그인·세션결함 명기) | `0`×8 | ✅ (unobserved 정직 표기) |
| COT_DFT(코팅) | BNBNFBL **없음**(PET 전용 주장) | **absent** | ✅ (구별 주장 입증) |

### 재실측 증거 (BNPTPET — `rp-option-extract-BN.md:85~113`)
- 자재 2종 `PXPETXXX`/`PXBOPXXX` present, COT_DFT 코팅 그룹 + 멤버 `TCMAS`/`TCGLS` present, MAX_CUT=`1000.00`, CUT_MRG=`4.00`. **전부 일치.**
- "현수막엔 없던 코팅 그룹"·"PET→코팅필수" 구별 주장 = BNBNFBL absent / BNPTPET present로 교차 입증.

### dodge-hunt(M1 최고위험): "SIZE_0 cut 0x0" 토큰
- 추출(`:54`)이 `사이즈직접입력(SIZE_0 cut 0x0)`로 표기. 캡처에 리터럴 `SIZE_0` **부재**(실제 토큰=`사이즈직접입력`+`DIV_NM`/`DIV_CD`).
- 판정: **날조 아님** — 출처규칙(`:11`)이 `unobserved=날조 금지`를 명시하고, 자유입력 모드는 `사이즈직접입력`으로 캡처 실재. `SIZE_0`은 아키텍트 표기 약어(메타모델 §13 `user_input(SIZE_0 자유)`). Low 결함(표기 정밀도)으로 `_defects.md` D-1.

**M1 = GO.** 샘플 원자 전수 일치, 날조/미출처 0, PRICE=0은 정직하게 unobserved 처리.

---

## M2 — 메타모델 정합 (after 02_metamodel) → **GO**

### 축 도출성 (오버피팅 검사)
- 13축(7정적+4동역학+2횡단) 각 축이 BN 추출 또는 `07_domain` KB 증거로 추적됨(사전 §1~13 각 `D-n` 근거 명시).
- 단일상품 축 신설 0 — `_resolved-fragments.md:87` "단일 상품 전용 축 신설 0건" + A-3/A-5/A-6를 facet으로 흡수(shape 1급화 거부 `:35`). 오버피팅 능동 회피 확인.

### ERD ↔ 사전 정합
- `metamodel-erd.md` 엔티티(MATERIAL/PROCESS_MEMBER/ADDON/CONSTRAINT/PROCESS_PARAMETER/QUANTITY_SLOT…)·관계(consumes/precedes/match/gates)가 사전 §1~13 relationships와 무모순. 제약=간선 모델 일관.

### 도메인 경계 라이브 확증 (dodge-hunt M2 최고위험: "별색=공정")
- 사전 §2·§1이 [HARD] "별색≠자재·별색=공정 PROC_000007"을 핵심 명제로 단언.
- **라이브 재실측:** `PROC_000007 별색인쇄`·`008 화이트`·`009 클리어`·`011 금색`·`012 은색`·`002 UV` 전부 **공정 행으로 실재**. 별색이 자재 아닌 공정으로 모델됨 = 메타모델 명제 라이브 입증. **깨기 실패.**

**M2 = GO.** 축 도출·무모순·ERD 정합·도메인 사실 라이브 확증.

---

## M3 — 발굴 축 타당성 (after 02_metamodel) → **GO**

### distinctness 재검 (`discovered-axes.md`)
| ID | 축 | 생성자 판정 | 재검 | 비고 |
|---|---|---|:--:|---|
| D-1 | 부속물 | distinct | ✅ 타당 | 후니 `t_prd_product_addons` 실재(5행) — 독립 SKU lifecycle 확증. 템플릿(번들)과 구별 정당. |
| D-2 | 자재 합성&공정결합 | distinct(메타규칙) | ✅ 타당 | SUB_MTRL_YN(공정→자재 FK)이 자재 버킷 단독 표현 불가 = distinct 논증 견고. |
| D-3 | 제약 논리유형 | distinct | ✅ 타당 | 6 논리유형 BN 증거표(`:73~81`) 각 행 근거 보유. |
| D-4 | 공정 파라미터 | distinct | ✅ 타당 | prcs_dtl_opt 라이브 스키마(아래 M5)가 파라미터 종속 구조 실증. |
| D-5 | 수량 모델 | distinct | ✅ 타당 | ORD_CNT/PRN_CNT 이중축 BN 전 6상품 일관 관측. |
| D-6 | 가격기여 역할 | distinct(횡단) | ✅ 타당 | 7버킷 부재 횡단 메타 — prc_typ_cd 라이브 운영으로 후니 동형 확증. |
| D-7 | 인쇄방식 레시피 | distinct(조건부) | ✅ 타당 | "RP=자재 facet / 후니=1급" 양면 표현 정직(강제 1급화 거부). |
| D-8 | UI 런타임 | **facet 강등** | ✅ 정당 | 단일 base-data 공유 → 관리 데이터 없음 = facet 강등 옳음. |

### dodge-hunt(M3 최고위험): D-7 distinct가 facet 위장 아닌가
- D-7은 BN에서 자재코드 끝자리(수성C/라텍스L) facet으로만 관측됨(`:160` 자인). 그럼에도 distinct 등재.
- 판정: **타당** — distinctness 근거가 BN이 아니라 `process-recipe-tree §1`(인쇄방식=최상위 게이팅 lifecycle)의 후니 도메인 동형. "조건부 distinct"로 정직 한정 + 갭분석가에 흡수 위치 위임(`:163`). 오버클레임 아님. **깨기 실패.**

### 미발굴 축(놓친 축) 점검
- 생성자가 카테고리 트리/템플릿 계층/usage 다중슬롯을 BN 한계로 미발굴 명기(`:196~200`)+추가 샘플 권고. 명백히 누락된 distinct 축 추가 발견 없음(BN 단일 카테고리 제약 정당).

**M3 = GO.** distinct/facet 판정 재검 통과·facet 오분류 0·미발굴 정직.

---

## M4 — 갭 판정 정확 (after 03_gap) → **GO** ★핵심 재실측

### 라이브 행수 재실측 (gap-matrix §0 "스냅샷 stale→라이브 정정" 주장 독립 확인)
| 테이블 | gap 주장 | **검증자 라이브 재실측(2026-06-17)** | 일치 |
|---|---:|---:|:--:|
| t_prd_product_option_groups | 134 | **134** | ✅ |
| t_prd_product_options | 494 | **494** | ✅ |
| **t_prd_product_option_items** | **469** | **469** | ✅ (0→469 stale-정정 **확인**) |
| t_prd_product_constraints | 10 | **10** | ✅ |
| t_prd_template_selections | 14 | **14** | ✅ |
| t_prd_templates | 12 | **12** | ✅ |
| t_prc_price_formulas | 17 | **17** | ✅ |
| t_prc_component_prices | 3,416 | **3,416** | ✅ |
| t_mat_materials | 340 | **340** | ✅ |
| t_proc_processes | 96 | **96** | ✅ |
| t_prd_product_addons | 5 | **5** | ✅ |
| t_cod_base_codes | 84 | **84** | ✅ |

→ gap-analyst의 핵심 주장("data-gap 대부분 닫힘, round-7 'option_items 전역 0행' 진단 stale")을 **독립 재실측으로 확인**. 날조 행수 0.

### 오염/무결성 재실측
- **MAT_TYPE.08/.09/.10 = 17/69/43 = 129** — gap-matrix §0·§1자재 WEAK 주장과 **정확 일치**. `MAT_TYPE.09` 행 샘플 라이브 실측: `원형 90mm·사각 110mm·단면·양면·2구` → 형상/사이즈/인쇄면/구수가 자재 행에 오염(B-3 미적용) **확인**.
- **카테고리 고아 노드 = 0** — gap-matrix ⑦PASS "round-22 교정 반영" 주장 **확인**(upr_cat_cd 부모 부재 노드 0건 재실측).

### 양면 검증(컬럼 존재)
- ⑨공정파라미터 GAP: `t_prd_product_option_items`에 `ref_param_json` **부재** 재실측(컬럼=ref_dim_cd/ref_key1/ref_key2/qty) → GAP 판정 정확(존재 그릇을 GAP으로 오판한 것 아님).
- ②공정 PASS: PROC_000007~012 별색 공정 행 실재 → PASS 정확(존재 않는 컬럼 인용 아님).

### dodge-hunt(M4 최고위험): gap이 "닫힌 data-gap"으로 결함을 은폐했나
- gap-matrix가 vessel-gap(스키마 표현불가)과 data-gap(빈/오염)을 분리(`:6 [HARD]`)하고 후자를 `_data-gaps-noted.md`로 라우팅.
- 검증: option_items 469 적재로 "닫힘" 처리한 것이 실제 닫힘인가 → 라이브 469 재확인. 단 **"행 존재 = 변형 커버리지 완결"은 아님**(round-7 D-1 교훈). gap-matrix는 가격사슬 단절(§2 "단가행 존재≠배선")을 별도 노트로 정직 분리 → 은폐 아님. **깨기 실패.**

### 사소 불일치(Low — 판정 무영향)
- gap-matrix 일부 부차 행수(product_materials 402·sizes 497·product_sizes 444·plate 509)가 라이브(772·510·449·424)와 상이. 어느 PASS/WEAK/GAP 판정의 *근거 행수*가 아님(전부 표현력 판정·핵심 12행수는 일치) → `_defects.md` D-2 freshness 노트(Low).

**M4 = GO.** 모든 핵심 판정 양면(메타모델 항목+라이브 t_*) 재실측 일치. "스냅샷 stale→라이브 정정" 주장 독립 확인.

---

## M5 — 그릇 건전성 (after 04_vessel) → **GO**

### search-before-mint 라이브 입증 (생성자 주장 = 신규 테이블 mint 0)
| vessel | 주장 | 검증자 라이브 재실측 | 판정 |
|---|---|---|:--:|
| **V-1 공정파라미터** | `ref_param_json` 부재→ALTER 필요·`qty`만 존재 | option_items 컬럼=ref_dim_cd/ref_key1/ref_key2/**qty**·ref_param_json **부재** | ✅ GAP 실재·mint 정당 |
| **V-1 근거** | prcs_dtl_opt 스키마 실재(값만 없음) | PROC_000029 `{줄수 max3}`·PROC_000017 `{방향·책등mm·고리형bool}`(다축)·PROC_000054 `{모양·조각수}` **실재** | ✅ schema↔value 비대칭 입증 |
| **V-1 jsonb 컨벤션** | jsonb 7컬럼·"8번째 동종" | 라이브 jsonb=**정확히 7**(logic·options.tags·templates.tags·sizes.tags·dim_vals·use_dims·prcs_dtl_opt) | ✅ |
| **V-3 자재분해축** | width/height/depth/weight/upr_mat_cd 실재(PASS)·mat_facet_cd 부재(신규) | 5컬럼 **전부 실재**·mat_facet_cd **부재**·MAT_FACET 코드그룹 **부재** | ✅ 분해 그릇 PASS·facet 코드만 mint 정당 |
| **V-4 essential PASS 재분류** | option_groups `mand_yn`+min/max_sel_cnt로 흡수 | `mand_yn`·`min_sel_cnt`·`max_sel_cnt` **전부 실재** | ✅ essential 신규 불요 정당 |
| **V-4 match/min-max** | RULE_TYPE.04/.05 부재→코드행 신규 | RULE_TYPE=01/02/03만(호환/금지/필수동반)·**.04/.05 부재** | ✅ 코드행 mint 정당 |

### "신규 불요 재분류 5건" 정당성 재검 (생성자 인계 요청 항목)
| 재분류 | 검증 | 판정 |
|---|---|:--:|
| V-2 인쇄방식→제약 흡수 | `constraints.logic jsonb`+option_groups sel_typ_cd 실재로 게이팅 표현 가능·강제 1급화 금지(메모리) 준수 | ✅ 정당(open decision 정직) |
| #4 템플릿가격→가격사슬 위임 | "가격=항상 component 사슬"(후니 철학)·option_items add_price 부재 선례 정합. templates.price 신설 거부 | ✅ 정당(철학 충돌 회피) |
| V-5 수량→보류 | ORD_CNT 후니 미관측(BN 한계)·과잉일반화 경계 | ✅ 정당(샘플 부족 정직) |
| V-6 사이즈 nonspec→V-4 흡수 | nonspec=상품별 제약(마스터 속성 아님)→RULE_TYPE.05 logic 일원화 | ✅ 정당(정규화 논증 견고) |
| V-7 가격role→가격트랙 위임 | use_dims+prc_typ_cd로 이미 표현·frm_typ_cd 라이브 부재 | ✅ 정당(leverage 최하 위임) |

### 정규화·컨벤션·영향분석
- V-1 정규화 증명(무손실/무중복/함수종속/참조무결성) 충실(`:42~46`). 영향분석 라이브 469행 기준 갱신(ADD COLUMN NULL=백필0·무잠금·롤백 시 백업 권고) — 생성자가 과거 0행 stale 제안 능동 정정.
- 컨벤션 정합: `ref_param_json`=ref_* 계열·코드 `cod_cd` 형식·jsonb 무인덱스 관용 준수.
- **중복 mint 0·컨벤션 drift 0.** search-before-mint이 5건을 "그릇 불요"로 억제한 것이 라이브로 정당화됨(round-22 이후 라이브 보강 결과).

### dodge-hunt(M5 최고위험): mint 0이 과소설계(GAP 은폐) 아닌가
- 진짜 GAP 2개(V-1 공정파라미터·V-2 인쇄방식)는 mint(컬럼/데이터)로 닫고, WEAK 6은 기존 그릇 재사용으로 닫음. V-1만이 실 DDL(ALTER) — 라이브에 ref_param_json 부재 확인했으므로 과소설계 아닌 정확한 단일 갭 식별. **깨기 실패.**

**M5 = GO.** search-before-mint 라이브 입증·정규화 충실·신규 테이블 0 정당·중복/drift 0.

---

## M6 — 생성-검증 독립성 (all stages) → **GO**

- **self-approve 0:** 각 단계 산출이 다음 단계의 입력일 뿐, 자기 게이트 부여 없음. 본 검증은 별 레인(rpm-validator)이 라이브·캡처를 *직접* 재측정.
- **echo 아닌 재유도:** M1(캡처 python 재파싱)·M4/M5(psql 라이브 재실측)로 생성자 숫자를 받아쓰지 않고 재생산. 12행수·6컬럼존재·129오염·7jsonb·prcs_dtl_opt를 독립 재측정.
- **dodge-hunt 4건**(M1 SIZE_0·M2 별색=공정·M3 D-7 facet위장·M4 닫힘은폐·M5 과소설계) 전부 깨기 시도 → 전부 실패(주장 견고) 또는 Low 결함으로 격하.

**M6 = GO.**

---

## 재실측으로 확인/반증한 핵심 주장

**확인(CONFIRMED):**
1. option_items 0→**469** 라이브 정정(round-7 stale 진단) — 핵심 주장, 독립 확인.
2. 핵심 12 테이블 행수 전부 일치(option_groups 134·options 494·constraints 10·component_prices 3,416·formulas 17 등).
3. MAT_TYPE.08/.09/.10 = 17/69/43 오염 잔존 + 형상/사이즈/구수 자재행 실측.
4. 카테고리 고아 0(round-22 교정 반영).
5. V-1 `ref_param_json` 부재(GAP 실재)·prcs_dtl_opt 스키마 실재(비대칭 입증)·jsonb 정확히 7.
6. V-3 width/weight/upr_mat_cd 실재·MAT_FACET 부재 / V-4 mand_yn 실재·RULE_TYPE.04/.05 부재.
7. 별색=공정(PROC_000007~012) 라이브 도메인 경계 확증.

**반증/하향(없음·결함만):**
- 어떤 PASS/WEAK/GAP/vessel 판정도 반증 안 됨. 결함은 Low 2건(D-1 SIZE_0 표기·D-2 부차 행수 freshness)뿐 — 판정 무영향.

---

## 인계 (v1.0 BN)
- 결함 라우팅 = `_defects.md`. NO-GO 0 — 재게이트 불요. 전 단계 GO 비준.
- 라이브 재실측 세션 권위(2026-06-17). 후속 세션은 부차 행수(product_materials 등) 갱신 시 본 verdict 행수 우선.

---
---

# ═══ GS(굿즈/잡화) 확장 검증 (v2.0) ═══

> rpm-validator. GS 확장분(01_reverse rp-option-extract-GS·02_metamodel 15축 v2.0·03_gap GS 섹션·04_vessel GS 그릇 4종) 독립 재검.
> **BN verdict(위)는 보존** — GS 섹션만 추가. 생성자 주장 비신뢰: 캡처 재파싱(M1) + 라이브 psql 직접 재실측(M4·M5).
> 재실측 세션: 2026-06-17, 라이브 Railway `railway` DB 읽기전용 SELECT(쓰기/주문/POST 0·비밀값 비노출).

## GS 종합 판정

| 게이트 | 대상 | 판정 | 근거 요약 |
|---|---|:---:|---|
| **M1** | GS 추출 충실성 | **GO** | 8 reuse 캡처 원자 전수 재파싱 일치(price_gbn 3종·PCS_COD·DTL코드·PRICE·자재단가 only-tiered). 4 live-augment pdtCode+상품명 catalog 실재·옵션상세 `unobserved` 정직. 날조 0. |
| **M2** | 메타모델 정합 (15축 v2.0) | **GO** | #14·#15 GS 증거+도메인 권위 도출·BN+GS 2군 견딤·오버피팅 능동 거부(G-1~G-4 facet)·ERD↔사전 정합·도메인 경계 라이브 확증. |
| **M3** | 발굴축 타당성 (#14·#15·facet 4) | **GO** | #14 형태가공·#15 생산형태 distinct 재검 통과·G-1~G-4 facet 강등 정당(양면 트레이드오프)·미발굴 정직. |
| **M4** | GS 갭 판정 정확 | **GO** | GS PASS/WEAK/GAP 양면 라이브 재실측 일치. 본체소재 vessel-gap·#15 신규불요(semi_role 28행)·MAT_TYPE.09/.10 오라벨(69/43)·형태가공 봉제+prcs_dtl_opt **전부 독립 확인**. |
| **M5** | GS 그릇 건전성 | **GO** | search-before-mint 라이브 입증(width/weight/jsonb0·semi_role_cd·template_prices·nonspec_*·RULE_TYPE 3종). 신규 테이블 0·body_model 컬럼화 거부(이행종속) 정당·MAT_TYPE 오라벨 "목적지 선행" 84상품 load-bearing 확증. |
| **M6** | 생성-검증 독립성 | **GO** | self-approve 0(재시도 vessel 산출 독립 재검=온전). dodge-hunt 3건(본체소재 vessel-gap·#15 재분류·MAT_TYPE 112행) 전부 깨기 실패. ★designer 라이브 재측이 gap-analyst 과소카운트 정정(D-3). |

**GS 전체: GO.** 결함 = Low 1건(D-3 gap §V #14 형태가공 행 과소카운트, designer가 이미 정정). 차단 0.

---

## GS M1 — 추출 충실성 → **GO**

8 reuse 상품(`rp-option-extract-GS.md` §1~8)의 캡처(`s3_rp_GS*.json`)를 python 재파싱으로 field-for-field 재대조.

### 재실측 증거 (캡처 재파싱 2026-06-17)
| 추출 주장 | 출처 | 캡처 재실측 | 일치 |
|---|---|---|:--:|
| price_gbn 3종(tmpl/vTmpl/tiered) §0.1 | 8캡처 reqBody | GSTBMWM·GSMLSLC·GSNTSPR·GSNTSTA·GSDRSKS·GSPUFBC=`tmpl_price`·GSPDLNG=`vTmpl_price`·GSTGMIC=`tiered_price` | ✅ 8/8 |
| query SP명(TMPL vs TIERED) | query | tiered만 `WSP_..._TIERED_PRICE`·나머지 `WSP_..._TMPL_PCS_PRICE` | ✅ |
| "자재단가 필드 tiered만(tmpl엔 없음)" §0.1 | PRICE_LOG | GSTGMIC에만 `자재단가` 존재·GSTBMWM/GSPDLNG 부재 | ✅ |
| PCS_COD 세트(DIR_MTR·WRK_MTR·INN_DFT·RIN_DFT·RIN_COL·STA_DFT·THO_CUT·PDT_WRK·FLX_ZIP·COT_DFT·CUT_DFT·PRT_DFT·ROU_DFT·PAK_ETC·PAK_POL) | 각 result | 전 상품 PCS_COD 세트 정확 일치 | ✅ |
| DTL코드(TM039·MLS01·LD001·TG001/TG003·NT001/NT002·INNON·SKSTU·BPLFT·BPTOP·PUBOK·ZPH01·PK012) | PCS_DTL_COD | 전부 실재 | ✅ |
| PRICE 실가(텀블러45000·마스크끈2800·장패드 본체10000/인쇄5000/포장1000=16000·마이크S6000/L7000) | result/result_sum | `45000`·`2800`·`10000/5000/1000`·`6000/7000` | ✅ |
| MTRL_CD(SXMIRW06·SXSML001·SXLPD001·RIBVW350·RXBVW300·PXFBW010) | ORD_INFO | 전부 실재(XML reqBody 내) | ✅ |
| sizePicked(Medium·여권형·13인치 가로형·삼각L) | step1 | 전부 실재 | ✅ |
| ATTB(RIN_BLK 링색·반경4) | GSNTSPR | `ATTB`·`RIN_BLK` 실재 | ✅ |

### 4 live-augment 정직성 (unobserved fact 위장 검사 — M1 핵심)
- catalog 재대조: GSTTDTM 규조토 코스터·GSPLCST 펠트·GSTTCRK 코르크·GSTTPAP 종이·GSTTACR 아크릴 코스터(모양)·GSTTREZ 레더·GSCAPHN 폰케이스 (일반/터프)·GSNTLTR 레더 노트·GSSKHND 효자손 = **9 pdtCode+상품명 전부 catalog 실재**(독립 walk).
- 옵션 상세는 §9~12 전부 `unobserved`/`[live:SSR-negative]` 명시 — "신규 Vue client-render·BFF 익명불가로 라이브 추출 불가"를 정직 기록. **미관측을 fact로 위장한 사례 0.**

### dodge-hunt(M1): GS 본체=DIR_MTR가 정말 PRICE 주체인가
- GSTBMWM `DIR_MTR`(TM039 텀블러)=PRICE 45000 + result_sum=45000 재확인. GSPDLNG 본체10000+인쇄5000+포장1000=16000 합산 재확인. 추출 §0.2 "굿즈 본체=공정성 항목(DIR_MTR)·PRICE 주체" 캡처로 입증. **깨기 실패.**

**GS M1 = GO.** 8 reuse 원자 field 전수 일치·4 augment unobserved 정직·날조 0.

---

## GS M2 — 메타모델 정합 (15축 v2.0) → **GO**

### #14·#15 도출성 + 오버피팅 검사
- **#14 본체형태가공:** GSPUFBC(PDT_WRK·FLX_ZIP)·GSTGMIC(PDT_WRK) 2상품 실관측 + 효자손/폰케이스 추정 + 후니 round-22 "평면→입체 조립" BOM 동형. 단일상품 아님. "본체에 작업"(#2)이 아닌 "본체 생성" lifecycle로 distinct 논증 견고(`dictionary §14`).
- **#15 생산형태:** GS C완제품(텀블러/코스터/효자손) + A/B(노트 표지+내지) 노출 + 도메인 권위 entity-semantic §4 C-9 11군 매핑. 카테고리⊥직교 논증(`dictionary §15`).
- **오버피팅 능동 거부:** GS 신패턴 6종 중 distinct는 2종(#14·#15)만, 나머지 4종(완제본체 SKU·본체소재 pdtCode·variant 3채널·기종 enum)은 facet 강등(`dictionary §260 GS 통합 과잉일반화 거부 기록`). "BN·GS 둘 다 견디는 governing/lifecycle"을 승격 기준으로 명시.

### ERD ↔ 사전 정합 (재대조)
- `metamodel-erd.md`에 `PRODUCTION_TYPE`(#15: prd_typ·body_model·set_structure)·`FORM_ASSEMBLY`(#14: assembly_cd·assembly_type·consumes_material·direction_variant) 엔티티+관계(governs·consumes·seq·⊥category) 전부 사전과 일치. MATERIAL에 `body_repr` facet enum(G-1 두 표현). **무모순 FK/composition 확인.**

### 도메인 경계 라이브 확증 (dodge-hunt M2: "생산형태≠prd_typ_cd"·"별색=공정")
- PRD_TYPE 5종(.01완제품·.02반제품·.03기성·.04디자인·.05추가) 라이브 실재·굿즈 .03 집중 → 사전 #15 "prd_typ_cd≠생산형태 오모델" 명제 라이브 입증. 별색=공정(BN verdict M2 확증분 유지). **깨기 실패.**

**GS M2 = GO.** #14·#15 도출·오버피팅 거부·ERD 정합·도메인 라이브 확증.

---

## GS M3 — 발굴축 타당성 (#14·#15 distinct + facet 4) → **GO**

### distinct 재검
| ID | 축 | 생성자 판정 | 재검 | 비고 |
|---|---|---|:--:|---|
| D-9 | #15 생산형태 | distinct | ✅ 타당 | 카테고리(기능 트리)⊥·템플릿(번들)의 상위 governing. 도메인 권위 11군 매핑+GS A/C 공존. body_model 분기를 카테고리/템플릿이 단독 못 담음. |
| D-10 | #14 형태가공 | distinct | ✅ 타당 | "본체 생성"(없으면 본체 부재)이 일반 후가공(#2 본체에 작업)과 lifecycle 구별. GSPUFBC·GSTGMIC 2상품. |

### facet 강등 정당성 (오승급/오분류 검사 — M3 핵심)
| frag | 정체 | 강등 판정 | 재검 |
|---|---|:--:|:--:|
| G-1 | 완제 본체 SKU(DIR_MTR/WRK_MTR) | 자재 facet | ✅ 정당 — BN본체(ORD_INFO.MTRL)·GS본체(DIR_MTR)는 *같은 자재참조*. 신축 시 자재축 2분열. PRICE주체=#11·SKU성=#4·governing=#15가 흡수. 양면 트레이드오프 명시. |
| G-2 | 본체소재 pdtCode 분리(코스터 6소재) | 자재+카테고리 복합 facet | ✅ 정당 — 소재=mat_cd·기능=카테고리. 분리 vs 옵션화는 메타모델 판정 아닌 카탈로그 정책(하이브리드 권고). |
| G-3 | 폰케이스 기종 enum | 사이즈 프리셋 facet | ✅ 정당 — 기종=칼틀/사이즈 대규모 enum·고유 lifecycle 없음(기능 동일). unobserved 한정 정직. |
| G-4 | variant 3채널(DTL/ATTB/CUT) | 기존축 분배 facet | ✅ 정당 — DTL→옵션·ATTB→공정파라미터·CUT→사이즈. 강결합(TG001/3)은 polymorphic 난점이지 신축 사유 아님. |

### dodge-hunt(M3): #14가 #2 공정의 facet 위장 아닌가
- 재검: 형태가공의 distinctness 근거 = "본체 *생성*성"(파우치는 PDT_WRK 없으면 평면지=본체 미완). 일반 후가공은 본체 존재 전제. lifecycle 질적 차이 → #2가 왜곡 없이 못 담음. 단 designer(M5)는 "분류축 1개만 결손·파라미터는 prcs_dtl_opt PASS"로 *부분 PASS* 하향 — distinct 자체는 유효(축으로서 미구별이 갭). **오승급 아님. 깨기 실패.**

**GS M3 = GO.** #14·#15 distinct 재검 통과·facet 4종 강등 정당·오분류 0.

---

## GS M4 — 갭 판정 정확 → **GO** ★핵심 4 재실측

### ① 본체소재 분해축이 진짜 vessel-gap인가 (사용자 핵심 질의)
- **라이브 `t_mat_materials` 컬럼 재실측:** `mat_cd·mat_nm·mat_typ_cd·upr_mat_cd·sel_typ_cd·max_sel_cnt·width·height·depth·weight·bdl_qty·use_yn·note·reg_dt·upd_dt·del_yn·del_dt`.
  - `width/height/depth/weight numeric` 실재(물리치수) / **`body_color`·`capacity` 분해축 컬럼 부재 확정.** jsonb 컬럼 **0건**(materials.tags 없음 → 색/용량 jsonb 흡수 불가).
- → gap-matrix §IV "본체소재 *링크* 그릇=PASS(product_materials+usage)·*분해축*(색/용량)=vessel-gap·미적재 소재=data-gap" **양면 판정 독립 확인.** 본체자재=vessel-gap 우세 + data 양면 = 정확.

### ② #15 "신규 불요"(semi_role_cd 실재·28행) 독립 재측
- **라이브:** `t_prd_products.semi_role_cd` 컬럼 실재 + SEMI_ROLE 5종(.01내지·.02표지·.03면지·.04간지·.05투명커버) + **populated 28행**(내지3·표지10·면지15). → vessel-production-type "set_structure 그릇 실재·PASS 재분류·신규 그릇 0" **독립 확인.**
- `nonspec_yn·nonspec_width_min/max·nonspec_height_min/max` 컬럼 실재 → gap §VI ⑬nonspec BN정정 확인. `t_prd_template_prices`(tmpl_cd·apply_ymd·unit_price) 실재·0행 → gap §VI ④template_prices BN정정 확인.

### ③ MAT_TYPE.09/.10 "파우치/악세사리" 오라벨·비자재 실측
- **라이브 MAT_TYPE 14종 재측:** .09=`파우치`·.10=`악세사리` 확정(.05특수소재·.06가죽=정상 본체소재).
- **.08/.09/.10 행수 = 17/69/43 = 129** — gap-matrix와 정확 일치. .09+.10=112 = 사용자 directive "112행 비자재" 일치.
- **.09 행 샘플 재측:** `원형 90mm·사각 110mm`(형상/사이즈)·`단면·양면`(인쇄면)·`2구·3구·4구`(구수)·`화이트 M/L/XL`(색+사이즈) → 자재가 하나도 없음. vessel-mat-type-relabel "비자재 버킷·자재유형 축 오염" **독립 확인.**

### ④ 형태가공 봉제 + prcs_dtl_opt/ref_param_json 실재 (★gap vs vessel 분기 판정)
- **gap-matrix §V #14는 "봉제 2행만(PROC_000080·088)"으로 과소카운트.** 라이브 재측: 형태가공 관련 = PROC_000080 봉제·**081 부착·082 족자제작·083 에폭시**(+중복 088/089/093/095). gap-analyst grep이 부착/족자/에폭시 누락.
- **vessel-form-assembly가 이를 정정** — PROC_000080 봉제·081 부착·082 족자제작·083 에폭시를 정확 식별 + prcs_dtl_opt 스키마 인용. **라이브 재측으로 designer 인용이 정확 확인:**
  - PROC_000080 봉제 = `{유형:[오버로크,말아박기,봉미싱], 폭:mm}` ✅
  - PROC_000081 부착 = `{대상:[라벨,맥세이프,끈,테입]}` ✅
  - PROC_000082 족자제작 = `{모양:[사각,원형]}` ✅
  - PROC_000083 에폭시 = NULL ✅
- `t_proc_processes` 컬럼 재측: `proc_cd·proc_nm·upr_proc_cd·prcs_dtl_opt·disp_seq·use_yn·note·...` → **`proc_typ_cd` 부재 확정**(유형 분류 축 없음). gap·vessel 둘 다 **판정=GAP 동일**(분류축 결손)·근거 행수만 designer가 정정.
- → 양쪽 판정 일치(GAP)·designer 재측이 더 정확. **D-3(Low) 라우팅**: gap §V #14 형태가공 행 과소카운트(2→4+). 판정 무영향.

### dodge-hunt(M4): "라이브가 BN/GS 추정 정정" 주장이 결함 은폐인가
- gap §VI BN정정(④template_prices·⑬nonspec vessel발견→완화)을 라이브로 재측: template_prices·nonspec_* 컬럼 **실재 확인** → "후니 표현력이 BN 추정보다 좋다"는 정직한 상향 정정이지 결함 은폐 아님. 반대로 ①자재분해축·#14·#15 governing은 vessel-gap 확증(완화 아님). **균형 잡힌 양방향 정정. 깨기 실패.**

**GS M4 = GO.** 4 핵심 주장 전부 양면 라이브 재실측 일치. PRD_TYPE 분포(.01=8·.02=28·.03=124·.04=115)·카테고리 고아0 확인.

---

## GS M5 — 그릇 건전성 (GS 그릇 4종) → **GO**

### search-before-mint 라이브 입증
| vessel | 주장 | 검증자 라이브 재실측 | 판정 |
|---|---|---|:--:|
| **vessel-material-axis §7** | 색/용량 분해 컬럼 부재·jsonb 0·소재/두께/무게는 기존 컬럼 PASS | width/height/depth/weight 실재·jsonb **0**·body_color/capacity 컬럼 **부재** | ✅ vessel-gap 실재·MAT_FACET 코드행+조건부 capacity 컬럼 정당 |
| **vessel-form-assembly** | proc_typ_cd 부재·prcs_dtl_opt 실재·봉제/부착/족자/에폭시 행 실재 | proc_typ_cd **부재**·prcs_dtl_opt 4스키마 **정확 일치**·4공정 행 실재 | ✅ PROC_CLASS 코드+proc_class_cd 컬럼 정당·"봉제만 GAP" 정정 |
| **vessel-production-type** | semi_role_cd 실재·28행·신규 그릇 0 | semi_role_cd **실재**·SEMI_ROLE 5종·**28행**(내지3/표지10/면지15) | ✅ 신규 그릇 0 정당(PASS 재분류) |
| **vessel-mat-type-relabel** | .09/.10 오라벨·비자재·정상 코드(.05/.06) 충분 | .09파우치/.10악세사리·112 비자재·.05특수/.06가죽 실재 | ✅ use_yn='N'(행 선이동 후) 정당·신규 0 |

### 정규화·컨벤션·영향분석 재검
- **body_model 컬럼화 거부 정당성(M5 핵심):** vessel-production-type §3 "body_model 별 컬럼 추가 = prd_typ_cd→body_model 이행종속 신설" → 정규화상 거부. 라이브에 prd_typ_cd+materials/templates 그릇 실재 확인 → **이행종속 회피=정규화 정답.** 신규 그릇 0이 과소설계 아님(prd_typ_cd로 유도 가능).
- **MAT_TYPE 오라벨 "단순 재명명 금지·목적지 선행" 정당성:** 라이브 재측 — .08/.09/.10 자재행에 **84 distinct 상품 BOM 의존**(product_materials 링크). 선폐기 시 84상품 본체 전손. → "목적지 그릇 선행→B-3 축이동→BOM 재배선→use_yn='N' 마지막" HARD 순서 **load-bearing 확증.** 단순 재명명 거부 정당(파우치는 자재유형 아님).
- **컨벤션:** jsonb 정확히 7컬럼(dim_vals·use_dims·logic·options.tags·templates.tags·prcs_dtl_opt·sizes.tags) 라이브 확인 → roadmap "jsonb 7컬럼" 정합. 코드행 cod_cd 형식·FK 관용 준수.
- **RULE_TYPE 3종(.01호환·.02금지·.03필수동반)** 라이브 확인 → V-4 ".04 match·.05 minmax 코드행 신설" 정당(.04/.05 부재).
- **신규 테이블 mint = 0** — GS 그릇 전부 코드행/컬럼/기존 그릇. 라이브로 전건 입증.

### dodge-hunt(M5): #14 형태가공 GAP을 designer가 "부분 PASS"로 부당 완화했나
- designer가 gap의 GAP을 "부분 PASS"로 하향한 근거 = "파라미터는 prcs_dtl_opt+ref_param_json PASS·분류축 1개만 결손". 라이브 재측: prcs_dtl_opt 봉제/부착/족자 스키마 실재 확인·proc_typ_cd 부재 확인 → 하향 근거가 라이브 사실. 단 vessel은 진짜 결손(PROC_CLASS+proc_class_cd)을 mint로 닫음 → 과소설계 아닌 정확 단일 갭 식별. **깨기 실패.**

**GS M5 = GO.** search-before-mint 라이브 입증·신규 테이블 0·이행종속 거부 정당·84상품 load-bearing 확증·컨벤션/정규화 정합.

---

## GS M6 — 생성-검증 독립성 → **GO**

- **self-approve 0:** GS 각 단계 산출이 다음 단계 입력일 뿐. ★재시도 vessel-designer "직전 산출 완성" 주장 **독립 재검** — 4 GS 그릇 doc 전부 search-before-mint(라이브)·정규화·영향(load-bearing/롤백)·open-decision 완비·비절단 확인. "완성" 주장 = 자기게이트가 아닌 사실(내가 라이브로 별도 재측). 온전·정합.
- **echo 아닌 재유도:** M1(8캡처 python 재파싱)·M4/M5(psql 라이브 재실측)로 생성자 숫자 받아쓰기 거부. mat 컬럼·MAT_TYPE 14종·129오염·prcs_dtl_opt 4스키마·semi_role 28행·PRD_TYPE 분포·jsonb 7·84상품 load-bearing·template_prices·nonspec_* 전부 독립 재측정.
- **★독립성 입증 사례:** designer 라이브 재측(부착/족자/에폭시)이 gap-analyst grep 과소카운트(봉제 2행)를 **정정** — 생성자≠검증자 분리가 실작동(한 레인이 다른 레인 오류 적발). 내 재측이 designer 측 정확성 확인.
- **dodge-hunt 3건**(본체소재 vessel-gap·#15 재분류 semi_role·MAT_TYPE 112행) 전부 깨기 시도 → 전부 라이브 재측으로 실패(주장 견고).

**GS M6 = GO.**

---

## GS 재실측으로 확인/반증한 핵심 주장

**확인(CONFIRMED):**
1. **본체소재 vessel-gap** — `t_mat_materials`에 body_color/capacity 컬럼 부재·jsonb 0 → 분해축 그릇 결손 확정(링크 그릇 product_materials는 PASS·양면).
2. **#15 신규 불요(semi_role 재분류)** — semi_role_cd 컬럼+SEMI_ROLE 5종+28행(내지3/표지10/면지15)·nonspec_*·template_prices 전부 라이브 실재 → 신규 그릇 0 정당.
3. **MAT_TYPE 오라벨** — .09파우치/.10악세사리·112 비자재 행(형상/색/구수/인쇄면)·.05/.06 정상 소재 버킷·84상품 BOM load-bearing → "목적지 선행·use_yn='N' 마지막" 정당.
4. price_gbn 3종·자재단가 only-tiered·PCS_COD/DTL/PRICE 8캡처 전수 일치(M1).
5. #14 형태가공 prcs_dtl_opt 4스키마(봉제/부착/족자/에폭시) 정확·proc_typ_cd 부재(분류축 GAP).
6. PRD_TYPE 분포(.01=8·.02=28·.03=124·.04=115)·굿즈 .03 집중·카테고리 고아0·jsonb 7컬럼.

**반증/하향(없음·결함만):**
- 어떤 GS PASS/WEAK/GAP/vessel 판정도 반증 안 됨. 결함 = Low 1건(D-3 gap §V #14 형태가공 행 과소카운트, designer 이미 정정·판정 무영향).

---

## GS 인계
- 결함 라우팅 = `_defects.md` D-3. NO-GO 0 — 재게이트 불요. GS 전 단계 GO 비준.
- BN verdict 보존. 라이브 재실측 세션 권위(2026-06-17·psql 직접 SELECT).
- 핵심 직답: **본체소재=vessel-gap(분해축)+data 양면** · **#15=신규 그릇 0 정당(semi_role_cd 28행 실재)** · **MAT_TYPE.09/.10=오라벨 확정·112 비자재·교정은 84상품 load-bearing으로 목적지 선행 필수.**
