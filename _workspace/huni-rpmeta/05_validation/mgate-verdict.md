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

---
---

# ═══ TP(디자인템플릿) 확장 검증 (v3.0) ═══

> rpm-validator. TP 확장분(categories/TP/reverse·02_metamodel 16축 v3.0 #16/D-11·T-A~T-E·03_gap §VIII~X·04_vessel V-10/V-11·11_ddl_proposals 2종) 독립 재검.
> **BN/GS verdict(위)는 보존** — TP 섹션만 추가. 생성자 주장 비신뢰: s6 캡처 직접 재파싱(M1) + 라이브 information_schema 직접 재실측(M4·M5) + 양 DDL BEGIN..ROLLBACK DRY-RUN 재실증.
> 재실측 세션: 2026-06-17, 라이브 Railway `railway` DB 읽기전용 SELECT(`SET default_transaction_read_only=on`·쓰기/COMMIT 0·비밀값 비노출). RedPrinting POST 0.

## TP 종합 판정

| 게이트 | 대상 | 판정 | 근거 요약 |
|---|---|:---:|---|
| **M1** | TP 추출 충실성 | **GO** | s6 캡처(TPCLWLB/TPCLECO/HLCLSTD/HLCLWAL/GSCLMGN) 직접 재파싱: item_gbn·에디터 플래그·price_gbn·PCS PRICE 전 load-bearing 원자 일치. ★TPCLWLB PRICE=11900(PRT_DFT 인쇄단면)·에디터/제본/포장 PCS=0 / HLCLSTD twin offset2023·koi=N·tmpl=N·pdf=Y 직접 확인. `unobserved` 정직(Vue client-render 정직 기록). 날조 0. |
| **M2** | 메타모델 정합 (16축 v3.0) | **GO** | #16 D-11이 캡처 증거+비-TP 트윈 대조로 도출·BN/GS/TP 3군 견딤·오버피팅 거부(T-A~T-E facet)·템플릿#4↔#16 이중의미 분리 일관·도메인 경계 정합. |
| **M3** | 발굴축 타당성 (#16 distinct + facet 5) | **GO** | D-11 distinctness 재검 통과(★캡처 cross-tab으로 채널⊥가격/print-method·editor_yn 환원불가 독립 입증). T-A~T-E facet 강등 정당(특히 T-A 이중의미). 과승격/과강등 0. |
| **M4** | TP 갭 판정 정확 | **GO** | #16 vessel-gap 라이브 직접 확정: t_prd_products=editor_yn/file_upload_yn/semi_role_cd만·item_gbn/channel/resource/vdp 컬럼 **전역 0건**·base_code 16그룹에 에디터 채널 enum 0·분포 Y/Y104·Y/N3·N/Y91·N/N49(editor_yn=Y 107). templates 12=봉투 완제SKU·page_rules 11 존재. 전 핵심 행수 일치. |
| **M5** | TP 그릇 건전성 (V-10·V-11) | **GO** | search-before-mint 라이브 입증(2-불리언 환원 한계·채널 1:1→컬럼·시안 1:N→테이블). ★양 DDL BEGIN..ROLLBACK DRY-RUN: INSERT 11코드행+ALTER 8+백필 UPDATE 107+CREATE 2 전부 무오류·**0 leaked**·mint 타깃 부재 확인. FK/reg_dt 트랩 준수. |
| **M6** | 생성-검증 독립성 | **GO** | self-approve 0. M1 캡처 python 재파싱·M4/M5 psql 라이브 재측·DRY-RUN을 *직접* 재생산(생성자 숫자 echo 아님). dodge-hunt 4건 전부 깨기 실패. |

**TP 전체: GO.** NO-GO 0·차단 0. 결함 = Low 2건(D-4 ORD_CNT=13 표기·D-5 proc 96/97·templates 테스트행). `_defects.md` 라우팅.

---

## TP M1 — 추출 충실성 (after categories/TP/reverse) → **GO** ★캡처 직접 재대조

`categories/TP/reverse.md`의 load-bearing 주장 2건을 인용 캡처(`huni-widget/01_reverse/s3_raw_captures/s6_cal_*.json`)에 직접 재파싱 대조.

### ① ★TPCLSTD vs HLCLSTD 직접 대조(에디터 플래그 차이·자재/가격 동일) — reverse §0.1·:41~47
TPCLSTD 자체는 client-render(빈응답)이나, 주장 = "자매 TPCL* 실측 + HLCLSTD 비-TP 트윈 대조". 캡처 직접 재파싱(`product_option.option` 플래그):

| 캡처 | item_gbn | useKoiEditor | useTemplateDownload | usePDF | price_gbn | reverse 주장 일치 |
|---|---|:--:|:--:|:--:|---|:--:|
| **TPCLWLB**(TP) | `vDigital_item` | **Y** | **Y** | N | vTmpl_price | ✅ (:41) |
| **TPCLECO**(TP) | `vDigital_item` | **Y** | **Y** | **Y** | tiered_price | ✅ (:42) |
| **HLCLSTD**(비-TP 트윈) | `offset2023_item` | **N** | **N** | **Y** | offset2023_price | ✅ (:46 "에디터0·템플릿0·PDF 전용") |
| **HLCLWAL**(비-TP) | `offset2023_item` | **N** | **N** | **Y** | offset2023_price | ✅ (:47) |
| **GSCLMGN**(edicus 참조) | `edicus_item` | **Y** | **Y** | N | tmpl_price | ✅ (:45 "Edicus SDK 채널") |

→ "같은 캘린더가 TP면 KOI+템플릿(useKoiEditor=Y·useTemplateDownload=Y), 비-TP(HL)면 offset2023·에디터0·PDF전용" = **캡처로 직접 입증**. TPCLSTD 구조의 자매-실측 확정 정당(직접관측 unobserved 정직).

### ② ★TPCLWLB PRICE=11900·에디터/제본 PCS=0 — reverse §3·:162~164
TPCLWLB priceCall 직접 재파싱(`s6_cal_TPCLWLB.json` priceCalls[0]):

| PCS 라인 | PCS_COD | PCS_NME | PRICE | reverse 주장 일치 |
|---|---|---|---:|:--:|
| result[0] | CUT_DFT | 재단 | **0** | ✅ (CUT_DFT 0) |
| result[1] | STA_CLD | 효도달력 쫄대 | **0** | ✅ (STA_CLD 0) |
| result[2] | PAK_POL | 달력 개별포장 | **0** | ✅ (PAK_POL 0) |
| result[3] | **PRT_DFT** | **인쇄단면** | **11900** | ✅ (PRT_DFT 인쇄=가격 주체) |
| result_sum | — | — | **11900** | ✅ (PRICE=11900) |

→ reverse §3 "가격 주체 = PRT_DFT(인쇄)·템플릿/에디터는 가격 0" = **field-for-field 입증**. 디자인 입력(제본 쫄대·재단·포장) PCS 라인 전부 0, 인쇄단면만 11900. D-11 "입력채널 가격 0" 핵심 증거 캡처로 확정.

### ③ `unobserved` 정직성 (M1 핵심 — 미관측을 fact 위장했나)
- reverse가 TPBCDFT·TPCLSTD·TPCLHOL·디자인X 군을 `[live:SSR] partial`/`unobserved`로 정직 표기(:44·:131·§4 catalog unobs). 신규 Vue client-render·BFF 익명불가를 명시(:248~262). `koi_template_resource_id` 캡처값=**None/빈**(비로그인·미선택)임을 캡처 재파싱으로 확인 → reverse "관측분 null/빈배열"(:60·:256) 정직.
- catalog pdtCode·상품명은 `redprinting_catalog.json` 실재(reverse 출처규칙 :13). 미관측을 사실로 위장한 사례 0.

### dodge-hunt(M1 최고위험): "ORD_CNT=13" 가 캡처에 실재하나
- reverse :163이 "(개당단가, ORD_CNT=13)"로 표기. 캡처 priceCall PRICE_LOG 재파싱 = "개당단가:11900.00원, 인쇄수량:1, 주문건수:**1**" — **ORD_CNT(주문건수)=1**, 13 아님.
- 판정: **날조 아님·Low 표기 결함** — PRICE=11900·PRT_DFT 주체(load-bearing)는 정확. "ORD_CNT=13"은 비-load-bearing 보조 주석(다른 수량 상태 혼입 또는 효도달력 13면 페이지를 ORD_CNT로 오기). 가격 구조 주장 무영향. → `_defects.md` D-4(Low).

**TP M1 = GO.** load-bearing 원자(item_gbn·에디터플래그·price_gbn·PCS PRICE) 캡처 전수 일치, twin 대조·가격0 직접 입증, unobserved 정직. 날조 0.

---

## TP M2 — 메타모델 정합 (16축 v3.0) → **GO**

### #16 도출성 + 오버피팅 검사
- **#16 디자인 입력 채널 도출:** 캡처(item_gbn 3분기·비-TP 트윈 본체동일·가격0)에서 직접 도출(M1 ②③ 입증). 7버킷 어디에도 안 들어감 — 옵션#3(본체속성)·공정#2(본체작업)·템플릿#4(완제번들)와 직교. 단일상품 아님(비-TP 트윈 대조 + GS edicus_item·BN PDF 전 카테고리 채널값 보유).
- **오버피팅 능동 거부:** TP 신패턴 6종 중 distinct는 #16 1종만, 나머지 5종(T-A 템플릿자산·T-B VDP·T-C 페이지계층·T-D 형태variant·T-E 특수인쇄)은 facet 강등(`discovered-axes.md:299` "TP 통합 과잉일반화 거부 기록"). 단일 카테고리 전용 축 신설 0.

### 템플릿#4↔#16 이중의미 분리 일관성 (★directive)
- 사전 #4(:108~109)·#16(:253)이 `Template`(완제SKU·`t_prd_templates`) vs `TemplateAsset`(에디터 디자인 시안·가격0·#16 종속)를 **별 엔티티로 분리** 명시. metamodel 핵심명제 #16(:293) [HARD] 일관. 라이브 `t_prd_templates`=봉투 완제SKU(M4 확인)이라 분리 정당.

### ERD ↔ 사전 정합 + 도메인 경계
- DesignInputChannel→Product(classifies)·→TemplateAsset(provides)·→QuantitySlot(gates ord_cnt)·↔PrintMethod(상관 아님 결정)·⊥본체옵션(직교) 관계가 사전 §16과 무모순. 도메인 경계 [HARD]: 입력채널≠인쇄방식(#12)·TemplateAsset≠템플릿#4·PRT_WHT=공정(T-E) 라이브 정합(별색=공정 BN/GS verdict 확증분 유지).

**TP M2 = GO.** #16 도출·오버피팅 거부·이중의미 분리 일관·ERD/도메인 경계 정합.

---

## TP M3 — 발굴축 타당성 (#16 distinct + facet T-A~T-E) → **GO** ★캡처 cross-tab 재검

### distinctness 재검 (`discovered-axes.md` D-11)
★캡처 cross-tab 직접 재측(s6 5캡처 item_gbn×price_gbn×useKoiEditor):

| 검정 | 캡처 증거 | 결론 |
|---|---|---|
| 채널 = 가격/print-method facet 인가? | 같은 `vDigital_item`(TPCLWLB·TPCLECO)이 **다른** price_gbn(vTmpl vs tiered) | ❌ facet 아님 — 채널이 가격/방식에 종속 안 됨(#12와 별 축) |
| editor_yn 불리언이 채널 인코딩? | useKoiEditor=Y가 `vDigital_item`(TPCLWLB)·`edicus_item`(GSCLMGN) **양쪽** | ❌ 불가 — Y가 KOI·Edicus 평면화(채널 의미축 drop) |
| 본체와 직교? | HLCLSTD/HLCLWAL(offset2023·editor0·PDF) vs TPCL*(KOI·템플릿) 본체동일 | ✅ 직교(M1① twin) |

→ **D-11 distinct 판정에 동의.** 7버킷·기존 8축(BN)·GS 2축과 직교(본체옵션 외부·게이팅 lifecycle 보유). facet 위장 아님 — 캡처 cross-tab으로 채널⊥가격·editor_yn 환원불가 독립 입증.

### facet 강등 정당성 (과승격/과강등 검사 — M3 핵심)
| facet | 정체 | 강등 판정 | 재검 |
|---|---|:--:|:--:|
| **T-A** 템플릿 자산 | 에디터 디자인 시안(가격0) | D-11 리소스 facet + #4 이중의미 분리 | ✅ 정당 — 독립 lifecycle 없음(채널 없으면 0)→D-11 종속. 단 #4와 별 엔티티(이중의미 [HARD]). 침묵선택 거부·양면 트레이드오프 명시. |
| **T-B** VDP | 가변데이터 | D-11 데이터바인딩 facet × 수량#10 | ✅ 정당 — 에디터 능력·변수행수=수량모델. 미관측→검증 라우팅 정직. |
| **T-C** 페이지계층 INN_PAGE | 캘린더 월수·북 대수 | 수량#10 슬롯 + 제약#5 | ✅ 정당 — page_rules 기존 그릇(라이브 11행 확인 M4). 신축 불요. |
| **T-D** 형태variant(M/I/보딩) | 티켓/캘린더 형태 | 사이즈#13 + 칼틀공정#2 | ✅ 정당 — GS THO_CUT 동형. 형태=프리셋/칼틀 enum·고유 lifecycle 없음. |
| **T-E** 특수인쇄(PRT_WHT/박/미싱) | 화이트·메탈릭·박·절취 | 공정#2 (+넘버링=VDP) | ✅ 정당 — 별색=공정 경계(round-22)·화이트 PROC_000008 라이브 보유. |

### dodge-hunt(M3 최고위험): T-A 템플릿 자산이 distinct 인데 facet 강등한 건 아닌가(과강등)
- reverse T-2가 "1순위 분리 필요" 제기 → 신축 후보였음. 그러나 facet 강등.
- 판정: **과강등 아님** — TemplateAsset은 `useKoiEditor=N`이면 0(독립 lifecycle 없음·D-11 종속). 신축 시 D-11과 1:1 종속 축 2개로 분열(중복). 단 "facet=무시"가 아니라 **#4와 별 엔티티 분리 + V-11 신규 테이블 그릇**으로 1급 보존 → 강등이되 그릇은 mint. 의미축 drop 0. **깨기 실패(정당).**

**TP M3 = GO.** #16 distinct 재검 통과(캡처 cross-tab)·T-A~T-E facet 강등 정당·과승격/과강등 0·미관측 정직 라우팅.

---

## TP M4 — 갭 판정 정확 (after 03_gap §VIII~X) → **GO** ★핵심 라이브 재실측

### ① #16 디자인 입력 채널 = GAP(vessel-gap) 라이브 직접 확정 (directive 핵심 질의)
라이브 information_schema 직접 SELECT(2026-06-17·`SET default_transaction_read_only=on`):

| gap-matrix VIII-0 주장 | 검증자 라이브 재실측 | 일치 |
|---|---|:--:|
| t_prd_products 디자인입력 컬럼 = editor_yn·file_upload_yn 불리언만 | 매치 컬럼 = **editor_yn·file_upload_yn·semi_role_cd만**·item_gbn/design_input_channel_cd/editor_kind_cd/koi_template_resource_id/vdp_yn/ord_cnt_source_cd **전부 부재** | ✅ |
| 에디터/채널/리소스/VDP 컬럼 전역 0건 | 전역 정규식(`editor|koi|edicus|vdp|item_gbn|channel|resource|asset|variable|design_input`) = **`t_prd_products.editor_yn` 1건만** | ✅ |
| base_code 16그룹에 에디터 채널 enum 부재 | 부모 그룹 16종(CUS_GRADE…USAGE) = **EDITOR_KIND/DESIGN_INPUT_CHANNEL/ITEM_GBN 없음** | ✅ |
| editor_yn×file_upload_yn 분포 Y/Y104·Y/N3·N/Y91·N/N49 | **Y/Y=104·Y/N=3·N/Y=91·N/N=49**·editor_yn=Y **107** | ✅ (정확 일치) |

→ **#16 = GAP(vessel-gap·후니 그릇 부재) 독립 확정.** RP item_gbn 3분기·에디터종류·리소스ID·VDP를 담을 컬럼·테이블·enum 전무. dbmap 미터치 신규 갭(자재/가격/CPQ 축과 비충돌) 확인. ★directive 핵심 질의 직답 = **GAP 정확**.

### ② TP facet 그릇 판정 (§IX)
| facet | gap 판정 | 검증자 라이브 재측 | 일치 |
|---|---|---|:--:|
| T-A 템플릿 자산 | WEAK(부재+`t_prd_templates` 오염위험) | t_prd_templates 12행=봉투(700x200)/OPP봉투/카드봉투 **완제SKU**(+테스트3) — 디자인 시안 아님·TemplateAsset 전용 그릇 부재 | ✅ |
| T-B VDP | GAP(#16 종속) | 가변데이터 컬럼 0건(전역 검색) | ✅ |
| T-C 페이지계층 | PASS(부분) | `t_prd_product_page_rules` 존재·**11행** | ✅ |
| T-D 형태variant | WEAK | 사이즈/공정 기존 축(BN/GS 판정 유지) | ✅ |
| T-E 특수인쇄 | PASS | 화이트=PROC_000008 등 공정 보유(GS verdict M2 확증분) | ✅ |

### 핵심 행수 재실측 (gap §0/VIII 주장 독립 확인)
option_groups **134**·option_items **469**·constraints **10**·template_selections **14**·templates **12**·price_formulas **17**·component_prices **3,416**·mat_materials **340**·base_codes **84** = gap 표기와 **전수 일치**. 날조 행수 0.

### dodge-hunt(M4 최고위험): #16 GAP이 "editor_yn 있으니 사실 표현 가능"을 과장한 GAP 아닌가
- 반대 검정: editor_yn(Y/N)이 채널 3분기를 환원하나? → 분포 Y/Y=104 셀에 KOI(vDigital)·Edicus가 *섞임*(M1① GSCLMGN edicus_item도 useKoiEditor=Y) → 2-불리언이 채널 못 분해. editor_yn=Y는 *에디터 사용 여부*만·*어느 에디터/리소스/VDP*는 0정보. GAP 판정이 과장 아닌 정확(표현력 부재 실재). **깨기 실패.**

**TP M4 = GO.** #16 vessel-gap 양면 직접 확정·facet 그릇 판정 일치·핵심 행수 전수 일치·dbmap 비충돌. directive 핵심 질의 = GAP 정확.

---

## TP M5 — 그릇 건전성 (V-10·V-11) → **GO** ★양 DDL DRY-RUN 재실증

### search-before-mint 라이브 입증
| vessel | 주장 | 검증자 라이브 재실측 | 판정 |
|---|---|---|:--:|
| **V-10 채널** | editor_yn+file_upload_yn 2-불리언이 5 의미축 환원 불가(GAP) | 컬럼/enum/테이블 전역 0건·Y/Y셀 채널 충돌 확인(M4①) | ✅ GAP 실재·그릇 필요 |
| **V-10 사다리** | 채널=상품 1:1→컬럼에서 멈춤·테이블 mint 거부 | 채널은 prd당 1값(메타모델 §16) → 컬럼 정규 슬롯·테이블 over-modeling | ✅ 컬럼 정당·테이블 거부 옳음 |
| **V-11 시안** | 시안=상품 1:N·독립 lifecycle·가격0→테이블만 무손실 | t_prd_template_assets·t_prd_product_template_assets **둘 다 부재**(신규 mint·중복 아님) | ✅ 신규 테이블 mint 정당 |
| **이중의미 분리** | TemplateAsset≠`t_prd_templates`(완제SKU 흡수 금지) | t_prd_templates=봉투 완제SKU 확인 → 디자인 시안 적재 시 오염 실재 | ✅ 물리 분리 정당 |
| **FK/reg_dt 트랩** | base_codes.cod_cd FK·reg_dt NOT NULL 명시 | base_codes PK=cod_cd·reg_dt NOT NULL·products PK=prd_cd 확인 | ✅ |

### ★양 DDL BEGIN..ROLLBACK DRY-RUN 재실증 (직접 실행·롤백 강제·COMMIT 0)
검증자가 양 DDL(`ddl-proposal-design-input-channel.sql`·`ddl-proposal-template-asset.sql`)을 단일 트랜잭션으로 라이브 실행 후 **강제 ROLLBACK**(ON_ERROR_STOP=1):
- `INSERT 0 11`(코드행 3그룹 11행) → 무오류
- `ALTER TABLE` ×8(ADD COLUMN ×4 + CHECK ×1 + FK ×3) → 무오류
- 백필 `UPDATE 107`(editor_yn='Y'⇒channel∈{.01,.03}) → **107 = editor_yn=Y 분포와 정확 일치**(정합 규칙 적용 검증)
- `CREATE TABLE` ×2(template_assets 마스터+링크·FK 3) → 무오류
- `ROLLBACK` → **post-rollback leak 검사: assets_leaked=f·channel_col_leaked=f·code_leaked=f** = **0 leaked·COMMIT 0**

→ 양 DDL 구문 유효·FK 무결성·reg_dt 트랩 준수·롤백 무위험 **직접 실증**. roadmap "0 leaked" 주장 독립 재현.

### "신규 그릇 불요" facet 흡수 정당성 (§4-TP)
- VDP=vdp_yn 게이트(본문 보류 open)·페이지=page_rules 기존(11행 확인)·형태=사이즈/공정 기존·특수인쇄=공정(PROC_000008) 기존 — 전부 라이브 그릇 실재로 흡수 정당. 신규 0.

### dodge-hunt(M5 최고위험): V-11 신규 테이블 2가 over-modeling 아닌가
- 검정: 시안을 `t_prd_products.template_resource_id` 컬럼 1개로 못 담나? → 시안=상품당 N개(갤러리)·1:1 컬럼 가정 붕괴. jsonb 배열? → 개별 resource_id 조인/FK 무결성 상실. `t_prd_templates` 흡수? → 봉투 완제SKU와 이중의미 오염(라이브 확인). **1:N·독립 lifecycle·이중의미** 3조건이 컬럼/jsonb/기존테이블 전부 배제 → 테이블만 무손실. over-modeling 아닌 정확 사다리(4단 도달). 채널(V-10)은 1:1이라 컬럼에서 멈춤(테이블 0) — 대조가 사다리 규율 입증. **깨기 실패.**

**TP M5 = GO.** search-before-mint 라이브 입증·양 DDL DRY-RUN 0 leaked·신규 테이블 2(V-11) 정당·V-10 테이블 0 정당·컨벤션/FK/reg_dt 정합.

---

## TP M6 — 생성-검증 독립성 → **GO**

- **self-approve 0:** TP 각 단계(reverse→metamodel→gap→vessel) 산출이 다음 입력일 뿐·자기 게이트 0. 본 검증은 별 레인(rpm-validator)이 캡처·라이브·DRY-RUN을 *직접* 재측정.
- **echo 아닌 재유도:** M1(s6 5캡처 python 재파싱·item_gbn/플래그/PCS PRICE 재추출)·M4(psql 컬럼/enum/분포 라이브 재측)·M5(양 DDL BEGIN..ROLLBACK 직접 실행·UPDATE 107 재현·leak 검사) — 생성자 숫자 받아쓰기 0. editor 분포·16 base그룹·12 templates·11 page_rules·mint 타깃 부재 전부 독립 재측정.
- **dodge-hunt 4건**(M1 ORD_CNT=13·M3 T-A 과강등·M4 #16 GAP 과장·M5 V-11 over-modeling) 전부 깨기 시도 → 전부 실패(주장 견고) 또는 Low 결함 격하.
- **★독립성 입증:** 검증자 캡처 cross-tab(item_gbn×price_gbn)이 D-11 distinct를 *생성자 트윈 논증과 다른 각도*(가격 독립성)로 재확인 — 받아쓰기 아닌 재유도.

**TP M6 = GO.**

---

## TP 재실측으로 확인/반증한 핵심 주장

**확인(CONFIRMED):**
1. **#16 디자인 입력 채널 = vessel-gap(GAP)** — t_prd_products=editor_yn/file_upload_yn만·item_gbn/channel/resource/vdp 컬럼 전역 0건·base_code 16그룹에 에디터 enum 0·분포 Y/Y104·Y/N3·N/Y91·N/N49(editor_yn=Y 107). directive 핵심 질의 직답.
2. **비-TP 트윈 대조** — TPCLWLB/TPCLECO(vDigital·KOI·템플릿) vs HLCLSTD/HLCLWAL(offset2023·에디터0·PDF) 캡처 직접 확인. 본체 동일·입력채널만 차이.
3. **TPCLWLB PRICE=11900** — PRT_DFT 인쇄단면 주체·CUT_DFT/STA_CLD/PAK_POL PCS=0 field-for-field 확인(입력채널 가격0).
4. **D-11 distinct(캡처 cross-tab)** — 채널⊥가격/print-method(같은 vDigital이 vTmpl/tiered)·editor_yn 불리언 채널 환원불가(KOI/Edicus 평면화) 독립 입증.
5. **templates 12=봉투 완제SKU**(이중의미 분리 정당)·page_rules 11 존재(T-C PASS)·V-11 mint 타깃 부재.
6. **양 DDL DRY-RUN 0 leaked** — INSERT11+ALTER8+UPDATE107+CREATE2 무오류·ROLLBACK·leak 0·COMMIT 0.

**반증/하향(없음·결함만):**
- 어떤 TP PASS/WEAK/GAP/vessel 판정도 반증 안 됨. 결함 = Low 2건(D-4 ORD_CNT=13 표기·D-5 proc 96/97·templates 테스트행 미언급) — 판정 무영향.

---

## TP 인계
- 결함 라우팅 = `_defects.md` D-4·D-5. NO-GO 0 — 재게이트 불요. TP 전 단계 GO 비준.
- BN/GS verdict 보존. 라이브 재실측 세션 권위(2026-06-17·psql 직접 SELECT·BEGIN..ROLLBACK DRY-RUN).
- **TP 핵심 직답:** #16 디자인 입력 채널 = **GAP(vessel-gap)** 라이브 확정(editor_yn 불리언만·채널/리소스/VDP 그릇 전무·dbmap 미터치 신규) · D-11 = **진짜 distinct**(캡처 cross-tab 동의) · V-10(컬럼·채널1:1)/V-11(테이블·시안1:N 이중의미) 사다리 정확·DRY-RUN 0 leaked.

---
---

# ═══ PR(인쇄물·책자·리플렛·포스터) 확장 검증 (v4.0) ═══

> rpm-validator. PR 확장분(`categories/PR/reverse.md`·02_metamodel 16축 v4.0 PR facet P-1~P-9·`03_gap §XI` PR facet 6항·`04_vessel/vessel-{print-method-recipe,quantity-size-pricing}` PR 보강·deepcheck 20후보) 독립 재검.
> **BN/GS/TP verdict(위)는 보존** — PR 섹션만 추가. 생성자 주장 비신뢰: 캡처 재대조(M1·이미 CONDITIONAL→GO 완료) + 라이브 psql 직접 재실측(M4·M5·M6 dodge-hunt).
> 재실측 세션: 2026-06-17, 라이브 Railway `railway` DB 읽기전용 SELECT(쓰기/주문/POST 0·비밀값 비노출).

## PR 종합 판정

| 게이트 | 대상 | 판정 | 근거 요약 |
|---|---|:---:|---|
| **M2** | 메타모델 정합 (16축 v4.0·PR facet) | **GO** | P-1~P-9 전부 추출 증거(reverse §0~§5·PRBKYPR/PRPOXXX 실측) 도출·**distinct 0** 오버피팅 능동 거부·관계 무모순(ERD usage 전파·자재풀 게이팅·접지 cascade·PAGE_RULE 종속 간선 추가, FK 충돌 0)·**16축 카운트 보존**(#1~#16 dictionary 일관·신축 0). |
| **M3** | 추가 메타모델 타당성 (P-1~P-9 facet) | **GO** | facet 9건 distinctness 역검 통과·**facet 오분류 0(역방향)** — 진짜 distinct를 facet으로 숨긴 것 없음. P-2 표지/내지=usage_cd slot 재판정 **라이브 dodge-hunt로 확증**(섹션 scoping 컬럼 0건→role slot 정당·신규 role 차원 불요). |
| **M4** | PR 갭 판정 정확 ★핵심 재실측 | **GO** | PR facet 6항 PASS4/WEAK1/GAP1 **전건 라이브 직접 재실측 일치**(USAGE 7종·usage 분포 .01=49/.02=67/.03=15/.05=2/.07=639·접지19/제본9/오시2·page_min/max/incr·면지MAT_000001~004·COMP_BIND 11·print_method/frm_typ 컬럼 0건). dbmap 비충돌. ※평량 컬럼 표기 미세결함 1건(Low). |
| **M5** | PR 그릇 건전성 (신규 mint 0) | **GO** | search-before-mint 라이브 입증(constraints.logic+rule_typ_cd 실재·RULE_TYPE 3종·options.tags jsonb·sizes min/max 부재). PASS 4건 그릇 보유·V-2 자재풀 게이팅 흡수·V-7 가격위임 정당. **신규 테이블/컬럼/V-번호 0 = 부당회피 아님**(기존 그릇 무손실 표현 라이브 입증)·**부당추가 0**. |
| **M6** | 생성-검증 독립성 | **GO** | deepcheck **20후보 무검증 채택 0** 확인(전부 unverified/triage·17축 0 도입). H-1(per-section)/H-2(서명대수)/H-3(교정) unverified 정직 분류·metamodel/gap 무유입 grep 확인. dodge-hunt(P-2 robustness) 라이브로 깨기 실패(=판정 견고). |

**PR 전체: GO.** NO-GO 0·차단 0. 결함 = Low 1건(M4 평량 컬럼 표기). `_defects.md` PR 섹션 라우팅.

---

## PR M2 — 메타모델 정합 (16축 v4.0) → **GO**

### 축 도출성 + 오버피팅 (P-1~P-9 distinct 0)
- `discovered-axes.md:30` v4.0 판정 = "PR 9패턴(P-1~P-9) distinct 승격 0·전부 facet/family/cascade/정책". 각 facet의 귀속 축(#)과 reverse 증거 라인 명시(P-1 §1·§3 FLD_DFT 7종 / P-2 §0.1·§2 inner_pdt_* / P-3 §0.2 INN_PAGE / P-5 §2 END_PAP 10색 등). **추출 증거에서 도출 — 날조/근거없는 facet 0.**
- 오버피팅 능동 거부: P-2 "별 role 차원 신설" 검토→거부(usage_cd 값과 1:1 중복), P-4 "상품분기 vs 옵션화"=후니 정책으로 환원(메타모델 판정 아님 명시). **단일상품 강요 축 0.**

### ERD ↔ 사전 정합 (관계 무모순)
- `metamodel-erd.md` PR 반영분 = 새 *축 노드 0* + PAGE_RULE 보조엔티티 1(QUANTITY_SLOT 종속·`erd:68`) + 관계 간선 강화(MATERIAL usage_cd 역할전파 `erd:67`·PRINTING→MATERIAL pool 게이팅·PROCESS 접지→오시 cascade `erd:69`·PRICING_MODEL price_gbn 라우팅 `erd:163`). 사전 `metamodel-dictionary.md:14`(16축 열거)과 **간선·엔티티 일치·모순 FK 0**.
- **16축 카운트 보존 확인:** dictionary `#1~#16` 전부 numbered(#8=부속물 `dict:159`). discovered "D-8 제외"는 *발굴축 D-8(UI런타임)* 제외이지 *사전축 #8* 아님 — 카운트 충돌 없음. PR 통합으로 축 +0.

**PR M2 = GO.** facet 도출·무모순·ERD 정합·16축 보존.

---

## PR M3 — 추가 메타모델 타당성 (P-1~P-9) → **GO**

### facet 판정 역검 (진짜 distinct를 facet으로 숨겼나)
- 9 facet 전수 역방향 점검 — 각 facet이 *고유 lifecycle/governing*을 갖는가 재시험:
  - **P-1 접지**: 면수=접지방식 파생값(2단=4면)·접지↔오시 cascade = 공정#2 family + 제약#5. 고유 governing 없음(공정 멤버) → facet 정당.
  - **P-3 페이지수**: INN_PAGE = 수량#10 슬롯 + page_rule 엔티티(라이브 실재). 별 lifecycle 없음(수량 차원) → facet 정당. TP T-C와 동일 슬롯 공유(횡단 일관).
  - **P-4 제본/인쇄방식 분기**: 상품분기 vs 옵션화 = 카탈로그 *정책*(GS G-2·TP T-4 동류) — 메타모델 양쪽 표현 가능 → 정책 facet 정당.
  - **P-7 인쇄방식 종속자재**: #12→#1 게이팅 *간선*(자재 부분집합) — 새 축 아닌 관계 강화 → facet 정당.
- **facet 오분류 0(역방향) — 진짜 distinct를 숨긴 것 없음.** 가장 distinct-후보였던 P-2(역할 전파)도 usage_cd 값 중복으로 거부 정당(아래 dodge-hunt).

### dodge-hunt(M3 최고위험): P-2 "표지/내지 역할" = 진짜 신규 role 차원 아닌가
- 가설: cover/inner가 자재+도수+가격+평량 *전부* role-paired면 별 "역할(role) 축"이 정당할 수 있다(생성자도 검토 후 거부).
- **라이브 재실측 반증:** `t_prd_product_materials` 컬럼 = `prd_cd·mat_cd·usage_cd·dflt_yn·disp_seq` — **role/section/page_range scoping 컬럼 0건**. 역할은 `usage_cd`(USAGE.01 내지/.02 표지/.03 면지) *값*으로만 인코딩. 도수/가격/평량의 role-pairing은 usage_cd가 그 축으로 *전파된 간선*이지 별도 관리대상 아님 → **신규 role 차원 신설 시 usage_cd와 1:1 중복**. **P-2 facet 판정 = robust(라이브 확증).**

**PR M3 = GO.** facet 9건 재검 통과·역방향 오분류 0·P-2 라이브 robust.

---

## PR M4 — PR 갭 판정 정확 (§XI) → **GO** ★핵심 재실측

> `03_gap/gap-matrix.md §XI` PR facet 6항(PASS4/WEAK1/GAP1)을 라이브 information_schema/데이터 **직접 재실측**(생성자 §XI-0 주장 비신뢰·독립 재조회).

### 라이브 재실측 (psql read-only 2026-06-17·생성자 §XI-0 독립 재현)

| # | facet | 생성자 판정 | 내 재실측 | 일치? |
|---|---|:---:|---|:---:|
| 1 | 표지/내지 usage 슬롯 + cover/inner 단가 | PASS | `USAGE.01~.07` 7종 실재 + `product_materials.usage_cd` 분포 **.01=49/.02=67/.03=15/.05=2/.07=639**(표지/내지 실적재) | ✅ |
| 2 | 접지/제본 공정 family + 오시 cascade | PASS | 접지 **19행**(PROC_000056~074)·제본 **9행**(PROC_000017~025)·오시 **2행**(PROC_000029·090) 공정행 실재 | ✅ |
| 3 | page_rule 엔티티 (INN_PAGE) | PASS | `t_prd_product_page_rules` 컬럼 = **`page_min·page_max·page_incr`**(+note/reg_dt/upd_dt)·**11행** — INN_PAGE→page_rule 1:1 라이브 확증 | ✅ |
| 4 | 인쇄방식 자재풀 게이팅 | GAP | `print_method/prn_mtd/pool/allowed/pricing_model/price_gbn/item_gbn` 컬럼 전역 **0건** — PrintMethod 1급 그릇·allowed_material 관계 부재 | ✅ |
| 5 | digital_price 라우팅 | WEAK | `t_prc_price_formulas` 컬럼 = `frm_cd·frm_nm·note·use_yn`(+dt) — **frm_typ/model 라우팅키 부재**·`price_gbn` 0건 | ✅ |
| 6 | 면지 bundle (자재+공정) | PASS | USAGE.03 자재행 **MAT_000001~004**(화이트/블랙/그레이/인쇄면지)·제본공정 PROC_000017~025·`COMP_BIND_*` **11행** | ✅ |

- **양면 검증:** PASS 측(그릇 존재 라이브 확인)·GAP/WEAK 측(컬럼 부재 라이브 확인) 양쪽 재실측. 존재하지 않는 컬럼 인용한 PASS 0·실재 그릇을 GAP한 것 0.
- **dbmap 정합:** GAP #4=기존 #12(`dbmap-print-method-not-absolute-axis`)·WEAK #5=기존 #11(`dbmap-price-formula-audit-round17` frm_typ_cd 부재)에 매핑 — **신규 충돌 0**. PR distinct 0 → 신규 vessel-gap 0(중복 계상 안 함) 일관.

### dodge-hunt(M4 최고위험): page_rule 11행이 "닫힌 data-gap"으로 결함 은폐했나
- `§XI-1 #3` "11행 적재·breadth는 data-gap" — 그릇(컬럼) 존재 ≠ 전 책자 적재. 재실측: 컬럼 `page_min/max/incr` 실재(vessel PASS 정당)·11행은 TP캘린더+PR책자 공유. **vessel은 PASS·적재 breadth는 data-gap(dbmap)으로 정직 분리** — 은폐 아님.

### 사소 불일치 (Low — 판정 무영향)
- **D-PR-1 (평량 컬럼 표기):** §XI-0 표 "product_materials 평량 min/max 컬럼 `wgt/weight/min/max` 0건" — 내 재실측은 `t_mat_materials.weight` **컬럼 실재**(+`max_sel_cnt`). 단 `weight`=자재 단일 평량값이지 RP `COV_MIN_WGT=150/INN_MAX_WGT=130` *플랫폼 제약 min/max 쌍*이 아님 → **판정(평량제약=제약#5 WEAK 흡수) 무영향**, 표기만 부정확(`weight 0건`은 거짓·`min/max 제약쌍 0건`이 정확). Low.

**PR M4 = GO.** facet 6항 전건 양면 라이브 재실측 일치·dbmap 비충돌. 표기 결함 1건은 Low(판정 무영향).

---

## PR M5 — PR 그릇 건전성 → **GO**

### search-before-mint 라이브 입증 (생성자 = 신규 그릇 0)
- **V-2 인쇄방식(P-7 자재풀 게이팅 흡수):** 경로 A(제약 흡수) 그릇 라이브 실재 — `t_prd_product_constraints.logic`(JSONLogic)+`rule_typ_cd` 컬럼·`RULE_TYPE.02 금지` 코드행 실재. 자재풀 게이팅=공정 게이팅과 *같은 제약 그릇* 무손실 흡수 → **1급 PrintMethod 테이블 mint 보류 정당**(over-modeling 회피). 파일포맷/팀=MES 미완 DEFER 정직.
- **V-7 가격(P-6 digital_price 흡수):** `frm_typ/model` 라우팅키 라이브 부재 확인 → 가격기여는 `use_dims jsonb`+`prc_typ_cd`로 표현·frm_typ_cd=가격트랙 위임. **신규 그릇 0 정당**(라이브가 안 쓰는 축·leverage 최하).
- **V-5/V-6(PR 무관 보강):** `options.tags`=jsonb(미사용 슬롯 실재)·`t_siz_sizes` min/max 컬럼 부재→V-4 RULE_TYPE.05 흡수 — 사다리 근거 라이브 일치.

### 부당회피/부당추가 점검 (양방향)
- **부당회피 0:** 신규 mint 0이 "결함 은폐"가 아님 — PASS 4건(usage·접지/제본·page_rule·면지)은 그릇 *실재 라이브 확인*(표현력 충분), GAP/WEAK 2건은 기존 V-2/V-7로 라우팅(새 그릇 불요가 입증된 결과).
- **부당추가 0:** PR로 신규 테이블/컬럼/V-번호 0 — 16축 포화의 vessel-side 증거. 4번째 카테고리가 새 그릇 요구 0.

### dodge-hunt(M5 최고위험): mint 0이 과소설계(P-7 게이팅 GAP 은폐) 아닌가
- P-7 자재풀 게이팅을 제약 logic으로 흡수 = 표현력 충분한가? 라이브 `constraints.logic`(JSONLogic 임의조건)+`option_items`(ref_dim_cd 자재) 실재 → `{인쇄방식=토너 → disable 윤전전용지풀}` 표현 가능. **게이팅 무손실·과소설계 아님.** 단 토너/인디고 자재풀 차이는 unobserved→validation 정직 라우팅(은폐 아님).

**PR M5 = GO.** search-before-mint 라이브 입증·신규 mint 0 정당(부당회피/추가 0)·제약 흡수 무손실.

---

## PR M6 — 생성-검증 독립성 → **GO**

### deepcheck 무검증 채택 0 확인 (`categories/PR/deepcheck.md`)
- codex 20후보(NEW-AXIS 5·MISSING-OPT/PROC 9·DOMAIN-RULE 6) + 도메인규칙 10항 = **전부 `unverified`·triage 등재까지**(`deepcheck:4·162` "채택 0" 명시).
- **17축 0 도입 grep 확인:** `discovered-axes.md`에 17축/섹션축/서명대수 distinct 채택 **0건**(grep empty). `gap-matrix.md`에 H-1/H-2/H-3/per-section/proofing 신규 GAP 유입 **0건**(grep empty). → **deepcheck 후보가 metamodel/gap에 몰래 채택된 것 없음.**
- H-1(per-section 자재)·H-2(서명/대수)·H-3(교정/승인) = 전부 unverified 정직 분류. **H-1은 deepcheck.md가 갱신되어 `REFUTED-for-RP`(2026-06-17 캡처 실측·채택0·재진입 불요)로 종결**(`deepcheck:43·147`). H-2/H-3 기각 예상·unverified 유지.

### dodge-hunt(M6 최고위험·H-1 독립 재현): per-section 자재가 P-2 facet을 깨나
- H-1 주장: usage_cd 2슬롯이 "1-16p=stockA, 17-32p=stockB" N-섹션을 못 담음→17축(섹션) 후보.
- **내 독립 라이브 재실측:** PRD_000071 USAGE.01(내지) 행 **16개**·PRD_000068 **13개** 등 다중 inner 자재 실재. **그러나** `t_prd_product_materials`에 **section_cd/page_range/scope 컬럼 0건**(`disp_seq`만)·각 행은 `mat_cd` 상이+`dflt_yn` → 이는 **"내지 자재 16종 중 택1 선택풀"**이지 *섹션별 자재 배정*이 아님.
- **결론:** 라이브에 섹션 scoping 키 부재 = RP/후니 모두 per-section 자재 미모델 → **H-1 REFUTED-for-RP 독립 재현·P-2 facet robust**. deepcheck의 "채택0·forward-looking noting만" 정직(나의 재실측이 동일 결론 도달).

### 생성≠검증 레인
- PR reverse(rpm-reverse-engineer)·metamodel(architect)·gap(gap-analyst)·vessel(designer)·deepcheck(codex/deepcheck) 산출을 validator(별 레인)가 라이브 재측으로 재검 — self-approve 0. 핵심 사실(USAGE 분포·접지19/제본9·page_min/max/incr·frm_typ 부재·섹션키 0)을 **생성자 인용 echo 아닌 직접 psql SELECT로 재도출.**

**PR M6 = GO.** deepcheck 20후보 채택 0·17축 0 유입·H-1 dodge-hunt 독립 깨기 실패(판정 견고).

---

## PR 인계
- 결함 라우팅 = `_defects.md` PR 섹션(D-PR-1 평량 컬럼 표기·Low). **NO-GO 0 — 재게이트 불요. PR 전 단계 GO 비준.**
- BN/GS/TP verdict 보존. 라이브 재실측 세션 권위(2026-06-17·psql 직접 SELECT).
- **deepcheck H-1 노트:** 본 검증 시점(deepcheck.md 10:05 갱신분) H-1 = `REFUTED-for-RP`로 종결·채택0. validator 독립 dodge-hunt(PRD_000071 섹션키 0건)가 동일 결론 재현 — H-1 최종 판정 확정(섹션 자재축 미도입 정당·forward-looking noting만).
- **PR 핵심 직답:** PR facet 6항 = **PASS 4**(표지/내지 usage·접지/제본 공정·page_rule·면지 bundle — 그릇 라이브 실재)·**WEAK 1**(digital_price=기존 #11)·**GAP 1**(인쇄방식 자재풀=기존 #12) · **distinct 신축 0 = 신규 vessel-gap 0**(16축 포화 입증) · 신규 테이블/컬럼/V-번호 0 정당.

---

# ═══ ST(스티커) 확장 검증 — M2~M6 (v5.0·★16축 포화 붕괴 검증) ═══

> rpm-validator. ST 확장분(`categories/ST/reverse.md`·`02_metamodel`{discovered-axes D-12·_resolved-fragments S-1~S-10·dictionary §17·erd SHAPE}·`03_gap §XIII`·`04_vessel/vessel-shape-axis.md`+`11_ddl_proposals/ddl-proposal-shape-axis.sql`·`categories/ST/deepcheck.md` 30후보) 독립 재검.
> **BN/GS/TP/PR verdict(위)는 보존** — ST 섹션만 추가. M1(추출 충실성)은 이미 GO 완료(본 게이트는 M2~M6).
> **★핵심 검증 = 형상축 #17 distinct 승격의 건전성**(과잉승격/facet 오분류 적대 검증). 생성자 주장 비신뢰: 라이브 Railway `railway` DB 읽기전용 SELECT(2026-06-17·쓰기/주문/POST 0·비밀값 비노출) + 캡처 직접 재대조(STDCFBR/STTHCIC/STTHSQU shape_info).

## ST 종합 판정

| 게이트 | 대상 | 판정 | 근거 요약 |
|---|---|:---:|---|
| **M2** | 메타모델 정합 (17축 v5.0·SHAPE 엔티티) | **GO** | D-12 형상축이 ST reverse 증거(shape_info enum·1:多 칼틀 span·STDCFBR 5형상 superset)에서 도출·SHAPE 엔티티/관계(gates SizePreset+ProcessMember·classifies Product) ERD↔사전 무모순·**17축 카운트 일관**(dictionary/erd/resolved-fragments 전건 17축). |
| **M3** | distinct 승격 타당성 ★최중요 | **GO** | 형상 #17 = **진짜 distinct**(과잉승격 아님) — STDCFBR 5형상 1상품·STTHCIC CL 1:多(CL0NN 캡처 20회)·전용 shape_info 슬롯·라이브 size축 미수용 **캡처+라이브 직접 재현**. 칼선·재단·점착 3후보 = **진짜 facet**(distinct 숨김 0·라이브 PROC_053/054/055·점착 컬럼 부재 재현). |
| **M4** | 갭 판정 정확 ★핵심 라이브 재실측 | **GO** | #17=GAP **라이브 3-레벨 직접 재실측 전건 일치**(형상 컬럼 0·테이블 0·base_code SHAPE enum 0). facet 5항 PASS1(S-3 PROC_053/054/055 실재)/WEAK2(S-4 점착 컬럼 부재·S-8 RULE_TYPE 3종)/GAP1(S-5)/부분PASS1(S-2)·전건 라이브 일치. dbmap G-SK-2 정합. |
| **M5** | 그릇 건전성 (V-12 SHAPE) | **GO** | search-before-mint 라이브 입증(shape_cd 컬럼 0건·기존 미존재→신설 명백)·**신규 테이블 0·컬럼 2·코드행 6 최소성 정당**(t_prd_product_sizes junction 선재 449행→컬럼 부착 무손실·새 테이블 회피 라이브 입증)·1:1 흡수 카테고리 형상축 강제 금지 [HARD] 명문화·dbmap round-3 정정=정밀화(충돌 아님)·reg_dt NOT NULL 트랩 준수. |
| **M6** | 생성-검증 독립성 | **GO** | deepcheck **codex 30후보 무검증 채택 0** 확인(#18 0 유입·H-3/H-4/H-6 unverified grep 0건). codex "#18 없음·형상 #17만 distinct" 독립 확정이 우리 판정과 일치(단 codex 동의는 근거 아님·라이브 권위). H-5(수정스티커)/H-3(칼선 geometry) unverified 정직 분류. dodge-hunt(형상 1:多 캡처 재현) 독립 통과. |

**ST 전체: GO.** NO-GO 0·차단 0. **★형상축 #17 distinct 승격 = 검증됨(VALIDATED).** 결함 = Low 1건(M5 ②a/②b 중복운영 정합규칙 미확정·open decision·앱검증 권고). `_defects.md` ST 섹션 라우팅.

---

## ST M2 — 메타모델 정합 (17축 v5.0·SHAPE 엔티티) → **GO**

### 축 도출성 (형상 #17이 ST 증거에서 정당히 도출)
- `discovered-axes.md:437` D-12 형상축 증거 = ① 전용 슬롯(`option_info.shape_info`·reverse §0.1 실측) ② 형상↔사이즈 1:多(CL→CL001~010+CLFRE·RC→RC001~025·reverse §0.2) ③ STDCFBR 5형상 superset(reverse §0.1) ④ 형상→칼선 게이팅(FR→THO_GRA·정형→THO_DFT). **전부 reverse 실측 라인 인용 — 날조 0.**
- 후니 KB 정초 = `entity-semantic-model.md:39` G-SK-2 "size축에 형상 enum drop·어느 축에도 없음"이 distinctness test §3(왜곡 없이 못 담음) 충족 증거로 인용. **도메인 권위 기반·추정 0.**

### ERD ↔ 사전 정합 (SHAPE 엔티티 관계 무모순)
- `metamodel-erd.md:192` SHAPE 엔티티(shape_cd·encoding) + 관계 3종: `SHAPE ||--o{ SIZE_PRESET : gates`(erd:55)·`SHAPE ||--o{ PROCESS_MEMBER : gates 칼선`(erd:56)·`SHAPE }o--|| ENUM_VALUE`(erd:57)·`PRODUCT }o--o{ SHAPE : classifies`(erd:29). 사전 `metamodel-dictionary.md:333` §17 형상축의 relationships(Shape→Product classifies·→SizePreset gates·→ProcessMember gates·⊂EnumValue)와 **간선 4종 정확 일치·모순 FK 0.**
- **17축 카운트 일관 (독립 grep):** dictionary `:15`(총 17축)·erd `:202`(17축 분류그래프)·resolved-fragments `:419`(17축)·discovered-axes `:29`(17 dictionaried)·gap-matrix `:434`(XIV 17축). **5파일 전건 17축 — 카운트 충돌 0.** (discovered "총 18 관리 축"은 7버킷+발굴 산식이며 그 중 17 dictionaried[D-8 UI런타임 제외]로 명시·내부 설명됨·축 충돌 아님.)
- **★[HARD] 형상축 적용 경계 명문화 확인:** dictionary `:351`·resolved-fragments `:337`·erd `:343`이 "형상=1:1이면 사이즈 흡수(BN/GS/TP/PR 유지)·1:多면 별 분류축(ST)·형상축 전면 강제 금지=오모델 회피"를 [HARD]로 명시 → 이전 4 카테고리 판정 무번복(보존)·모델 진화가 증거 강제임을 정직 기록.

**ST M2 = GO.** 형상 #17 도출 증거 실측 인용·SHAPE 엔티티 관계 무모순·17축 카운트 5파일 일관.

---

## ST M3 — distinct 승격 타당성 (★최중요·형상 #17 적대 재검) → **GO**

> directive 핵심 = 형상 #17 distinct 승격이 정당한지(사이즈축 #13 facet 과잉승격 아닌지) + 칼선·재단·점착 3후보가 진짜 facet인지(distinct를 facet으로 숨긴 역방향 오류) 적대 양방향 재검.

### ① 형상 #17 = 진짜 distinct (과잉승격 반증 시도 → 실패 = distinct 확정)
**반증 가설:** "형상은 사이즈축(#13)의 facet — 어깨띠·하트·티켓처럼 사이즈 프리셋으로 흡수 가능한 것을 과잉승격했다."
**내 독립 재현(캡처 직접 SELECT):**
- **STDCFBR 캡처 직접 파싱** — `option_info.shape_info = [SQ,CL,EL,RC,FR]` 5형상 전부 **한 상품**에 실재. → 형상이 사이즈 facet이면 한 상품에 5사이즈군이 *형상 사실 없이* 평면 공존해야 하나, 별도 `shape_info` 슬롯에 5형상이 선택 차원으로 존재 = **사이즈와 분리된 전용 차원 확정**(반증 실패).
- **STTHCIC 캡처** — `shape_info=[CL]` 단일 형상이나 CL0NN 칼틀 프리셋이 **20회**(CL001~CL010 open/close), **STTHSQU** `shape_info=[RC]` 단일에 RC0NN **48회**(~24 RC 프리셋). → **형상 1값 ↔ 칼틀/사이즈 多값 = 1:多 직접 재현.** 사이즈축 흡수 시 "원형"을 CL001~CL010 매 행에 중복 인코딩(이행종속·정규화 붕괴) → 형상은 사이즈의 *상위 분류축*(흡수 대상 아님).
- **반증 결과:** 형상은 사이즈 facet으로 흡수 불가(1:多·전용 슬롯·5형상 superset 3중 증거) → **distinct 승격 정당·과잉승격 아님.**

### ② 칼선·재단·점착 3후보 = 진짜 facet (distinct 숨김 역검 → 숨김 0)
**역검 가설:** "distinct를 facet으로 숨긴 게 아닌가."
- **칼선(S-2)** — 라이브 `t_proc_processes`: 완칼 PROC_000053·반칼 054·스티커완칼 055 실재(자유칼선/도무송 전용 row 0건). THO_GRA/THO_DFT는 *모양커팅 공정의 두 모드*이지 별 lifecycle 없음 → 공정#2 family facet **정당**(KB PROC_053/054/055 결정적). 단 자유칼선이 완칼+모양param으로 환원되는 점은 #9 공정파라미터 GAP에 정직 귀속(숨김 아님).
- **재단입자(S-3)** — 반칼=PROC_000054/완칼=053/스티커완칼=055 라이브 직접 실재(전건 확인). "반칼/완칼"은 재단 공정의 분기 멤버 = 공정#2 facet **정당**(별 "재단입자 축" 신설은 공정 멤버 중복).
- **점착(S-4)** — 라이브 `t_mat_materials` 컬럼 = `mat_cd,mat_nm,mat_typ_cd,...,width,height,depth,weight,bdl_qty,...` — **adhesion/weather 분해 컬럼 0건**. 점착/내후는 *자재 합성 차원*(색상→material·두께→material 동형)이지 별 자재계열 아님 → 자재#1 facet **정당**(단 분해축 부재=WEAK로 정직 표기).
- **역검 결과:** 3후보 모두 후니 KB/라이브가 기존 축 멤버/차원으로 확정 → **distinct를 facet으로 숨긴 역방향 오류 0.**

**ST M3 = GO.** ★형상 #17 distinct 승격 = 적대 재검 통과(과잉승격 반증 실패·캡처 1:多 직접 재현)·칼선/재단/점착 facet 판정 = 역검 통과(숨김 0). **양방향 distinct/facet 판정 모두 건전.**

---

## ST M4 — 갭 판정 정확 (after 03_gap §XIII) → **GO** ★핵심 라이브 재실측

> §XIII 주장(#17=GAP·facet 5항 PASS1/WEAK2/GAP1/부분PASS1)을 라이브 information_schema 직접 SELECT로 양면 재실측.

### #17 형상축 = GAP — 라이브 3-레벨 직접 재실측 (전건 일치)
| 측정(내 독립 psql 2026-06-17) | 라이브 결과 | gap-matrix §XIII-0 주장 | 일치 |
|---|---|---|:--:|
| 형상 컬럼 `~* shape\|outline\|form_typ\|die_cut\|form_cd` 전 t_* | **0건**(false positive 0) | "0건(transforms.transform_type false positive)" | ✅(내 regex는 transform 미포함·더 깨끗이 0) |
| 형상 테이블 `~* shape\|outline` | **0건** | "0건" | ✅ |
| base_code 부모 그룹 | **16개**(CUS_GRADE·DSC_TYPE·MAT_TYPE·OPT_REF_DIM·OUTPUT_PAPER_TYPE·PRC_COMPONENT_TYPE·PRD_TYPE·PRICE_TYPE·QTY_UNIT·RULE_TYPE·SEL_TYPE·SEMI_ROLE·USAGE+TEST×3) | "16그룹·SHAPE/형상 enum 부재" | ✅ |
| SHAPE/형상 enum(`cod_cd~*shape OR cod_nm~형상`) | **0건** | "SHAPE/형상 enum 부재" | ✅ |

→ **#17 형상축 = GAP(vessel-gap) 라이브 3-레벨 확증.** KB G-SK-2 "형상이 어느 축에도 없음"이 컬럼/테이블/enum 전 레벨에서 실측 재현. **GAP 판정 정확**(존재하는 그릇을 GAP로 오판한 것 아님).

### facet 5항 라이브 재실측 (PASS/WEAK/GAP 전건 일치)
- **S-3 재단입자=PASS** ✅ — 라이브 `t_proc_processes` 완칼 053·반칼 054·스티커완칼 055(+087/091/094) 실재. 메타모델 주장 전건 실재 = **무손실 PASS 정확.**
- **S-4 점착=WEAK** ✅ — `t_mat_materials`에 adhesion/weather 분해 컬럼 0건(기존 #1 자재 분해축 WEAK과 동일). MAT_TYPE.11(스티커용지) 16행 클린 버킷 실측(파우치 .09 69행 오염과 대조) — ST 자재는 오라벨 아님·분해축만 부재. **WEAK 정확.**
- **S-8 disable 룰엔진=WEAK** ✅ — RULE_TYPE 자식 3종(호환/금지/필수동반) 라이브 실측·disable 전용 유형 부재. logic jsonb 그릇은 227건 스케일 담을 수 있으나 유형 거버넌스 미달 = 기존 #5 WEAK 동일. **WEAK 정확.**
- **S-5 인쇄방식=GAP** ✅ — `print_method/prn_mtd/pool` 전역 0건(기존 #12 GAP·PR P-4/P-7 횡단 합류). **GAP 정확.**
- **S-2 칼선=부분PASS** ✅ — 프리셋칼틀=완칼/반칼 공정 실재(PASS)·자유칼선(도무송) 전용 row 0건(완칼+모양param #9 의존). **부분PASS 정확.**
- **MAT_TYPE 분포** — .08/.09/.10/.11 = 17/69/43/16 라이브 실측 = §XIII-0 주장 정확 일치.

**ST M4 = GO.** #17 GAP 라이브 3-레벨 전건 재현·facet 5항 PASS1/WEAK2/GAP1/부분PASS1 전건 라이브 일치·dbmap G-SK-2 정합·양면 검증(그릇 부재측+RP 표현력측). 존재 그릇 GAP 오판/비존재 PASS 오판 0.

---

## ST M5 — 그릇 건전성 (V-12 SHAPE) → **GO**

### search-before-mint (라이브 입증 — 중복 mint 아님)
- 라이브 `t_prd_products`에 **shape_cd 컬럼 미존재**(prd_cd·nonspec_*_min만 실측) → 형상 슬롯 신설은 중복 아님·명백. base_code 16그룹에 SHAPE 부재(M4 재현) → SHAPE enum 신설 명백.
- **신규 테이블 0 정당성 라이브 입증:** `t_prd_product_sizes`는 **기존 junction**(prd_cd+siz_cd·449행 실측)이며 형상↔칼틀 1:多를 그 행에 `shape_cd` 분류 컬럼 부착으로 무손실 표현 가능 → 새 junction 테이블 불요. vessel `§1.3 ④`가 "1:多여도 junction 선재 시 테이블 mint 불요"를 정밀 판정 — **라이브 junction 실재로 검증됨.** (TP V-11 TemplateAsset이 독립 lifecycle로 테이블 mint 정당이었던 것과 대비 — 형상은 junction 선재로 컬럼이 최소·과잉 mint 아님.)

### 최소성 (과잉/과소 양방향)
- **신규 테이블 0·컬럼 2(②a 상품·②b junction)·코드행 6(SHAPE+5)** = 사다리 ② 단계 정지. ②a/②b 두 컬럼은 *서로 다른 카디널리티의 다른 함수종속*(prd_cd→shape_cd 단일형상 vs (prd_cd,siz_cd)→shape_cd 칼틀별)·의미 중복 아님(정규화 §3.1 무손실/무중복 논증). **과잉 mint 아님.**
- **과소 검증:** siz_sizes 마스터(497행 공유 칼틀)에 형상 안 매는 이유 = `siz_cd→형상` 이행종속이 같은 칼틀 다른 형상 상품과 충돌(자재 오염 MAT_TYPE.09 동형) → prd×siz junction이 정답. **과소도 아님(정규화 근거 명확).**

### 적용 경계 [HARD] + reg_dt 트랩 + dbmap 정합
- **1:1 흡수 카테고리 형상축 강제 금지** [HARD] 명문화 확인(vessel `§5`·`§0`·`shape_cd NULL=비적용`·BN 어깨띠/GS 하트/TP 티켓/PR 카드형 size 유지). 형상축 전면 강제 = 오모델 회피 — directive·gap XIII-1과 일관.
- **reg_dt NOT NULL 트랩 준수** — 라이브 `t_cod_base_codes` reg_dt/use_yn/del_yn 전부 NOT NULL 실측·DDL이 `reg_dt now()`·`use_yn 'Y'`·`del_yn 'N'` 전부 명시(round-5 교훈 반영). ALTER ADD COLUMN NULL = 백필 0·무잠금(275상품·449 junction행 무파손).
- **dbmap round-3 정정 = 정밀화(충돌 아님)** — round-3 "도무송 형상=siz_cd 흡수" 권고를 ST 1:多 증거(CL→CL001~100·5형상 superset)가 siz 흡수=정규화 붕괴임을 입증해 *전용 그릇으로 대체*. dbmap G-SK-2 진단(결함 명시)은 보존·그 위 1:多 정밀화 = 재발견 아닌 신규 vessel-gap. **dbmap 비충돌 확인.**

**ST M5 = GO.** search-before-mint 라이브 입증·최소성 양방향 정당(신규 테이블 0·junction 선재 검증)·적용경계 HARD 명문화·reg_dt 트랩 준수·dbmap 정밀화. 중복 mint/컨벤션 드리프트 0. 결함 = ②a/②b 중복운영 정합규칙 미확정(open decision §6·Low·앱검증 권고).

---

## ST M6 — 생성-검증 독립성 → **GO**

### deepcheck codex 30후보 무검증 채택 0 (grep 확인)
- **#18 distinct 축 유입 0:** metamodel/gap/vessel에 "#18·18 distinct·돔/에폭시/롤가공/VDP distinct 채택" grep = 0건(전부 watchlist/REFUTED/미입증/거부 컨텍스트만). codex가 "#18 없음(no defensible #18)" 독립 확정한 것이 우리 형상 #17 1종 판정과 일치 — **단 codex 동의는 근거 아님**(codex 네트워크 격리 confabulation·라이브가 권위), 일치는 robustness 보강 신호로만 기록.
- **codex HIGH 후보(H-3 칼선 geometry·H-4 전사/weeding·H-6 돔/에폭시) 무검증 유입 0:** "블리드/안전여백/weeding/전사테이프/돔스티커/min-radius/min-island" grep = **0건** in discovered-axes/gap-matrix/vessel. → unverified 후보가 metamodel/gap/vessel에 몰래 채택된 것 없음(deepcheck triage 채택0 준수).
- **H-5(수정스티커 #12→#1 재귀속)·H-1(VDP=#18)** = deepcheck가 unverified/REFUTED-예상으로 정직 분류(H-1은 TP에서 이미 REFUTED·ST 재제기도 동형 예상). 메타모델 그룹E 분류 정정 미반영(unverified 유지)=정직.

### dodge-hunt (M6 최고위험 — 형상 1:多 주장 독립 깨기 시도)
- **최위험 주장:** "형상↔사이즈 1:多"가 형상 distinct의 유일 load-bearing 논거. 캡처가 아닌 메타모델 텍스트만의 주장이면 echo 위험.
- **내 독립 재현:** STDCFBR 캡처 직접 파싱(shape_info=5형상)·STTHCIC CL0NN 20회·STTHSQU RC0NN 48회 — **생성자 인용 echo 아닌 캡처 raw 직접 SELECT로 1:多 재도출.** 형상 distinct 논거가 캡처 실측에 정초됨 확인(깨기 실패=판정 견고).

### 생성≠검증 레인
- ST reverse(rpm-reverse-engineer)·metamodel(architect)·_resolved-fragments(architect)·gap(gap-analyst)·vessel(designer)·deepcheck(codex/deepcheck) 산출을 validator(별 레인)가 라이브 psql + 캡처 raw 재측으로 재검 — **self-approve 0.** 핵심 사실(형상 3-레벨 부재·PROC_053/054/055·점착 컬럼 0·RULE_TYPE 3종·STDCFBR 5형상·CL/RC 1:多·junction 449행)을 **생성자 echo 아닌 직접 psql/캡처 파싱으로 재도출.**

**ST M6 = GO.** deepcheck 30후보 채택 0·#18 0 유입·codex HIGH 무검증 유입 grep 0건·형상 1:多 dodge-hunt 독립 재현(깨기 실패)·self-approve 0.

---

## ST 재실측으로 확인/반증한 핵심 주장 (요약)
1. **형상 컬럼/테이블/SHAPE enum 3-레벨 = 라이브 0/0/0** — #17 GAP 확증(KB G-SK-2 전 레벨 재현).
2. **STDCFBR shape_info=[SQ,CL,EL,RC,FR] 5형상 1상품** — 캡처 직접 파싱·형상=사이즈 facet 반증(전용 차원 확정).
3. **STTHCIC CL0NN 20회·STTHSQU RC0NN 48회** — 형상↔칼틀 1:多 캡처 재현(distinct load-bearing 논거 정초).
4. **완칼 053·반칼 054·스티커완칼 055 라이브 실재·도무송 row 0** — S-3 재단입자 PASS·자유칼선=#9 의존 정직.
5. **t_mat_materials adhesion/weather 컬럼 0·MAT_TYPE.11=16 클린** — S-4 점착 WEAK(분해축 부재) 정확.
6. **RULE_TYPE 3종(호환/금지/필수동반)** — S-8 disable WEAK(유형 미달) 정확.
7. **t_prd_product_sizes 기존 junction 449행·t_prd_products shape_cd 미존재·reg_dt NOT NULL** — V-12 신규 테이블 0·컬럼 2 최소성·reg_dt 트랩 준수 검증.

## ST 인계
- 결함 라우팅 = `_defects.md` ST 섹션(D-ST-1 ②a/②b 중복운영 정합규칙 미확정·Low·open decision). **NO-GO 0 — 재게이트 불요. ST 전 단계(M2~M6) GO 비준.**
- BN/GS/TP/PR verdict 보존. 라이브 재실측 세션 권위(2026-06-17·psql 직접 SELECT + 캡처 raw 파싱).
- **★형상축 #17 distinct 승격 = VALIDATED** — 과잉승격 반증 실패(STDCFBR 5형상·CL/RC 1:多 캡처 재현)·칼선/재단/점착 facet 역검 통과(라이브 PROC/컬럼 재현)·#17 GAP 라이브 3-레벨 확증·V-12 그릇 최소성(junction 선재)·deepcheck #18 0 유입. **16축 포화 붕괴(5번째 카테고리 distinct 1종)는 오버피팅이 아니라 사이즈축 1:1 흡수 전제가 ST 1:多로 깨진 증거 강제 결과 — 검증됨.**
- **ST 핵심 직답:** ST facet 5항 = **PASS 1**(재단입자 S-3·PROC_053/054/055 라이브 실재)·**WEAK 2**(점착 S-4=기존 #1·disable S-8=기존 #5)·**GAP 1**(인쇄방식 S-5=기존 #12)·**부분PASS 1**(칼선 S-2) · **distinct 신축 1(형상 #17)=신규 vessel-gap 1(V-12)** · facet 신규 vessel-gap 0(전부 기존 #1/#2/#5/#12 흡수) · 신규 테이블 0·컬럼 2·코드행 6 최소성 정당.

---

# ═══════════════════════════════════════════════
# CL 카테고리 (의류·티셔츠·앞치마·가방류) M-gate 검증 — M2~M6
# ═══════════════════════════════════════════════

> rpm-validator 독립 재측정 2026-06-17 (read-only psql + 캡처 raw 파싱).
> M1 = 별 세션 GO 완료(증거 `_defects.md` CL-M1). 본 세션 = **M2~M6 + ★의류 variant #18 부결 타당성 적대 검증(역방향 오류 적발)**.
> 생성자(reverse/architect/gap-analyst/designer/deepcheck)와 별 레인. 생성자 주장 = 가설·라이브/캡처 재측으로만 비준.

## CL M-gate 요약

| 게이트 | 대상 | 판정 | 핵심 근거(독립 재측) |
|--------|------|:---:|----------------------|
| **M2** | 메타모델 정합(distinct 0·17축·apparel_sku_matrix facet) | **GO** | discovered-axes/dictionary/erd/_resolved 4문서 17축·distinct 0 일관·apparel_sku_matrix=MATERIAL enum facet(신규 엔티티 0)·관계 무모순 |
| **M3** | ★의류 variant #18 부결 타당성(역방향 오류) | **GO** | size_color_info=227셀=227 distinct (size,color) pair·0 dup(Cartesian 확증)·MTRL_COD=size자리+color자리(G-1 동형)·라이브 ref_key1×ref_key2 2D 페어링 255행 전부 .03자재·PRD_000071=33×4 matrix → 2D=기존 2축 곱·**숨긴 distinct 없음** |
| **M4** | 갭 판정 정확(PASS1/WEAK3/GAP1) | **GO** | 라이브 직접 SELECT 5건 전부 일치: option_items 469/ref_key2 255·ref_dim_cd .03=255/.04=156/.06=45/.01=11/.07=2·PROC_000007 별색 family 실재·print_method/item_gbn 컬럼 0건·processes PK=(prd_cd,proc_cd) |
| **M5** | 그릇 건전성(신규 그릇 0·search-before-mint) | **GO** | ref_key1/ref_key2 2D 페어링이 size×color 무손실 수용(라이브 활성 실증)·OPT_REF_DIM 7종(color 없음)·MAT_TYPE 14종(apparel 버킷 없음)=V-3 WEAK 정확·신규 테이블/컬럼/V번호 0 정당 |
| **M6** | 생성-검증 독립성 | **GO** | deepcheck 13후보 채택 0(H-2만 REFUTED-for-RP·캡처검증·미채택)·codex #18 facet 동의=robustness 기록(근거 아님 명시)·H-1/H-3 정직 unverified·#18 부결 dodge-hunt 독립 재현(깨기 실패) |

**CL 종합 = GO. NO-GO 0. ★의류 variant #18 부결 = VALIDATED(역방향 오류 없음).**

---

## CL M2 — 메타모델 정합 = **GO**

**검사:** distinct 0·17축 카운트 일관·apparel_sku_matrix 관계 무모순·ERD↔dictionary 일치.

- **17축 4문서 일관 (재측):** `discovered-axes.md:29`(17 dictionaried)·`metamodel-dictionary.md:16`(축 총 17)·`metamodel-erd.md:3,205`(17 관리 축)·`_resolved-fragments.md:503`(distinct 승급 0) — **네 문서 전부 17축·CL distinct 0 일관.** CL 통합 후 카운트 변동 0(ST의 #17 형상 유지·#18 미추가).
- **apparel_sku_matrix = MATERIAL enum facet (신규 엔티티 0):** `metamodel-erd.md:108` `enum apparel_sku_matrix "CL C-2/C-3 size×color 2D→단일 MTRL_COD"` = MATERIAL 엔티티의 *enum 속성*(별 테이블/엔티티 아님). `:55` 간선 `SIZE_PRESET }o--o{ MATERIAL : "CL C-3 size×color 2D matrix→MTRL_COD(셀가용성=CONSTRAINT 2D)"` — 기존 SIZE_PRESET↔MATERIAL 다대다 관계의 facet. 모순 FK/composition 0.
- **ERD↔dictionary 일치:** dictionary `:75`(의류 본체=원단PTT×색CLR×사이즈WGT 합성 SKU·별 축 아님)·`:167`(2D 셀가용성=제약#5 2D subject)·`:258`(인쇄방식 삼면 표현=#12)와 erd `:108/:166/:371` 명제 동일. dictionary 명제 #23(`:400`)·과잉일반화 거부 기록 ㉙~㊲(`:412`)이 erd `:371` 본문과 정합.
- **오버피팅 경계:** CL은 단일 카테고리에서 의류 전용 그릇(apparel_info·clothes2025)을 봤으나, "한 카테고리만 필요한 축" 거부 원칙대로 distinct 강요 없이 facet 분해. 6 상품군(BN·GS·TP·PR·ST·CL) 횡단으로 판정 → 오버피팅 아님.

**CL M2 = GO.** 17축 4문서 일관·apparel_sku_matrix=MATERIAL facet(신규 엔티티 0)·관계 무모순·ERD=dictionary.

---

## CL M3 — ★의류 variant #18 부결 타당성 = **GO** (역방향 오류 없음·최중요)

**적대 검사(역방향):** size×color 2D 매트릭스가 진짜 자재#1 SKU matrix + 제약#5 facet인가, 아니면 GS 1D variant를 질적으로 초과하는 distinct를 facet으로 *숨긴* 것인가. 캡처(major_apparel_CLSTSHS) 직접 파싱 + 라이브 재측으로 독립 재현.

### 캡처 직접 파싱 (size×color→MTRL_COD 단일 인코딩 재현)
- **size_color_info = 227셀 = 227 distinct (COD,CLR_COD) pair·dup 0** (python json 파싱·`major_apparel_CLSTSHS.json`). → **진짜 Cartesian product** of 사이즈(COD) × 색(CLR_COD). 새 차원이 아니라 *두 기존 축의 곱*.
- **MTRL_COD = SXSRT + 사이즈자리 + 색자리:** `{COD:1,CLR_COD:03}→SXSRT103`·`{COD:1,CLR_COD:26}→SXSRT126`·`{COD:1,CLR_COD:58}→SXSRT158` 셀별 실측. → 셀→단일 MTRL_COD 해소 = **G-1 본체 SKU 라벨 융합과 동형**(reverse §0.3·architect C-3 판정 토대 진본).
- **apparel_info 6키 카운트 전건 일치:** print_type=3(PTP_DTF/DIR/SLK)·print_area=6·apparel_color=54·size_info=7·size_color_info=227·pantone_color=1124 — **6/6 캡처 재현**(facet 분해의 전제 원자 진본).

### 라이브 재측 (2D 표현 그릇 실재·기존 축이 왜곡 없이 담음)
- **option_items 2D 페어링 라이브 활성:** `t_prd_product_option_items` ref_key1 사용 469/469·ref_key2 사용 **255**·ref_key1 AND ref_key2 동시 사용 **255**·전부 `ref_dim_cd=OPT_REF_DIM.03(자재)`. → 후니 옵션 그릇이 *이미* 2D(사이즈키×자재키) 셀을 운영 중.
- **실제 매트릭스 상품 실재:** `PRD_000071` = 49 cells·distinct ref_key1=33·distinct ref_key2=4 → 33×4 매트릭스. 후니 옵션 그릇이 size×color 같은 2D variant를 *구조적으로 견딤* 실증.

### 역방향 오류 판정 (4 distinct 근거 각각 깨기 시도)
| #18 distinct 근거 | 깨기 결과(독립 재현) | distinct 잔존? |
|---|---|:---:|
| ① item_gbn=clothes2025 별 분기 | 라이브 print_method/item_gbn/pricing_model/price_gbn 컬럼 **전 테이블 0건** — 후니에 discriminator 컬럼조차 없음·RP item_gbn=구현 SP 분기키(관리 데이터 0)·PR P-4/ST S-5 동형 | ❌ 구현 discriminator |
| ② apparel_info 전용 그릇 | 6키 전부 기존 축으로 깔끔 분해(print_type→#12·area→#2·color→#1CLR·size→#13·size_color→#1matrix+#5·pantone→#2별색)·고유 관리 데이터 0(D-8 동근) | ❌ 컨테이너 뷰 |
| ③ size×color 2D 매트릭스 | 227셀=227 distinct pair·0 dup=사이즈#13×색상 Cartesian·셀→MTRL_COD=G-1 동형·라이브 ref_key1×ref_key2 페어링이 무손실 수용 | ❌ 두 기존 축의 곱 |
| ④ Pantone1124/위치6/방식3 | Pantone=PROC_000007 별색 공정(라이브 실재)·위치=공정#2 멀티슬롯·방식=#12 — 전부 기존 축 값도메인 | ❌ 기존 축 |

- **유일 잔여 후보 = 2D 셀가용성:** size×color 227셀의 셀별 HIDE_YN/QUICK_ORD_YN이 *새 관심사*일 가능성을 적대 검정 — 캡처 파싱 결과 HIDE_RSN 분포 = **226 blank + 1 "재고부족"**. 셀가용성은 `use_yn`(제약#5 2D subject)으로 무손실 표현 가능(ST disable 227=S-8 정점과 동일 패턴, subject만 2D). → **제약#5에 무손실 흡수·숨김 아님.**
- **★역방향 오류 없음 확정:** distinct가 요구하는 "기존 축이 *왜곡 없이* 못 담는 고유 lifecycle/governing"이 **부재.** 2D-ness는 cardinality 속성이지 새 관리 축 아님. GS variant(G-4 1D-per-channel)의 2D 일반화 facet로 정확히 환원됨. **architect의 facet 부결은 over-modeling 거부의 정직한 결과이지 distinct 은폐 아님.**

**CL M3 = GO.** 의류 variant #18 부결 = **VALIDATED**(역방향 오류 없음). size×color=사이즈#13×색상 Cartesian + 셀가용성=제약#5 2D subject·캡처+라이브 독립 재현·깨기 4/4 실패.

---

## CL M4 — 갭 판정 정확 = **GO**

**검사:** gap-matrix §XV CL facet 5항 PASS1/WEAK3/GAP1을 라이브 information_schema 직접 SELECT 재실측·dbmap 정합.

| # | CL facet | gap 판정 | 라이브 재측(2026-06-17 psql 직접) | 일치 |
|:-:|---|:---:|---|:---:|
| 1 | size×color 2D matrix | WEAK | option_items 469·ref_key2 255·ref_dim_cd .03자재=255/.04공정=156/.06도수=45/.01사이즈=11/.07셋트=2 (gap §XV-0 주장 byte-exact) / OPT_REF_DIM 7종(사이즈/판형/자재/공정/묶음수/도수/셋트·**color 없음**) / MAT_TYPE 14종(**apparel fabric 버킷 없음**·.09파우치/.10악세사리=상품군명) | ✅ |
| 2 | 인쇄위치 멀티슬롯 | WEAK | `t_prd_product_processes` PK=(prd_cd,proc_cd)·컬럼 8개에 **위치 컬럼 0**·option_groups SEL_TYPE.02(다중)=11행 경유 표현 가능 | ✅ |
| 3 | 인쇄방식 실크/전사/DTF | GAP | print_method/prn_mtd/item_gbn/pricing_model/price_gbn 컬럼 **전 테이블 0건** = #12 1급 그릇 부재 | ✅ |
| 4 | Pantone 별색 | PASS | `PROC_000007 별색인쇄`·008화이트·009클리어·010핑크·011금색·012은색 **라이브 실재**(별색=공정 경계 준수) | ✅ |
| 5 | item_gbn discriminator | WEAK | discriminator 컬럼 0건(=#15 생산형태 WEAK과 동일·prd_typ_cd가 body_model governing 안 함) | ✅ |

- **양쪽 검증 (PASS·GAP 둘 다):** PASS(#4)=PROC_000007 family 실재로 *후니가 그릇 보유* 확인. GAP(#3)=print_method 컬럼 0건으로 *부재* 확인. WEAK(#1/#2/#5)=그릇 일부 보유(2D 페어링/옵션 다중/prd_typ_cd) + 분해축/위치파라미터/discriminator 결손 확인.
- **dbmap 정합:** #1→`dbmap-material-option-normalization`(색상 variant→material)·round-22 ④자재 / #3→`dbmap-print-method-not-absolute-axis`(인쇄방식 비절대축) / #5→`dbmap-grid-binding-round15`(prd_typ_cd≠생산형태) — gap 인용 dbmap 메모리와 비충돌·CL GAP은 기존 #12 GAP과 동일(신규 dbmap 갭 0).
- **카운트 드리프트 노트(판정 무영향):** gap §III 본문은 `t_proc_processes`=96·`t_prd_product_processes`=196로 기록하나 라이브 재측 = **97·270**(데이터 진화). CL §XV 판정의 load-bearing 수치(option_items 469/255·ref_dim 분포·PROC family·print_method 0·PK)는 전부 정확 → CL 판정 무영향. (전역 §III 카운트 갱신은 별 사항·D-CL-3 Low 기록.)

**CL M4 = GO.** 5항 PASS1/WEAK3/GAP1 라이브 직접 SELECT 전건 일치·양쪽 검증·dbmap 정합.

---

## CL M5 — 그릇 건전성 = **GO**

**검사:** CL 신규 그릇 0이 search-before-mint 정당 결과인지(ref_key1/ref_key2가 2D variant 무손실 수용)·기존 V-항목 흡수가 강화인지·부당 mint 회피 아닌지.

- **신규 그릇 0 = search-before-mint 통과(실증):** `_vessel-roadmap.md:12,74` CL 신규 V-번호/테이블/컬럼 0. 핵심 근거 = `option_items.ref_key1/ref_key2` 2D 페어링이 size×color 2D 매트릭스 무손실 수용 → **라이브 재측으로 실증**(255행 2키 동시 사용·PRD_000071 33×4 매트릭스). 별 `apparel_sku_matrix` 테이블 mint 불요 = 정당(기존 그릇이 진짜 담음).
- **기존 V-항목 흡수 = 강화(충돌 아님):** vessel-needs `:184` CL facet 5항이 V-3(자재 분해축)·V-1(위치 공정파라미터)·V-2(인쇄방식)·V-9(생산형태)·V-10(KOI 에디터매핑)에 흡수. 라이브 OPT_REF_DIM에 color 타입 없음·MAT_TYPE에 apparel 버킷 없음 재측 → V-3 WEAK(자재 CLR 분해축·의류 원단 버킷 결손)이 *정확*(기존 #1 WEAK 재확인이지 새 충돌 아님).
- **부당 mint 회피 아님(dodge-hunt):** distinct를 facet으로 강등하고 그릇을 mint 회피했다면 표현력 손실이 있어야 함 — 그러나 2D 매트릭스·셀가용성이 라이브 그릇으로 무손실 수용됨(255행 활성). 손실 없음 = mint 회피가 부당하지 않음. 잔여 결손(자재 CLR 분해축·apparel 버킷)은 V-3로 정직 라우팅(은폐 아님).
- **정규화/컨벤션:** 흡수 대상 전부 기존 t_* 컨벤션(option_items/processes/prd_typ_cd) 내·신규 mint 0이므로 컨벤션 드리프트 가능성 0.

**CL M5 = GO.** 신규 그릇 0=search-before-mint 정당(2D 페어링 라이브 무손실 수용 실증)·V-항목 흡수=강화·mint 회피 부당 아님(표현력 손실 0).

---

## CL M6 — 생성-검증 독립성 = **GO**

**검사:** deepcheck 13후보 무검증 채택 0·codex #18 동의가 근거 아닌 robustness 기록·HIGH 후보 정직 unverified·dodge-hunt.

- **deepcheck 채택 0 (재검):** `categories/CL/deepcheck.md:11`("채택 0")·`:31`("총 13 후보·전부 unverified")·`:151`("채택 0 — owning agent 검증 전 사실 아님"). 라우팅표(`:130~144`) 전 후보 상태 = unverified/기록/흡수확인. **메타모델/갭/그릇에 codex 후보 무검증 유입 0** — discovered-axes/dictionary/erd/gap/vessel grep으로 H-1(blank garment)·H-3(재고 lifecycle)·M-1~M-6 후보가 distinct/그릇으로 *채택된 흔적 0*.
- **H-2(자수) REFUTED는 채택 아닌 반증:** `:46,133` H-2가 캡처 검증으로 REFUTED-for-RP — 내가 독립 재현: `apparel_info.print_type` = PTP_DTF/PTP_DIR/PTP_SLK 3종으로 닫힘(python 파싱)·자수/패치 키워드 0 hit. **모델에 추가가 아니라 후보 제거**(정직 처리·robustness 입증).
- **codex #18 동의 = robustness 기록(근거 아님 명시):** `:20~24,147` "codex 우리 facet 부결에 동의"를 *모델 robustness 추가 입증*으로 기록하되, `:8~11` 환각경계 HARD("codex=외부 의견·라이브/캡처 권위로 검증 전 사실 아님")로 codex 동의를 *판정 근거로 쓰지 않음* 명시. 우리 #18 부결 근거 = 라이브+캡처 재측(M3)이지 codex 동의 아님 — 정확.
- **HIGH 후보 정직 unverified:** H-1(blank garment 거버넌스)·H-3(재고 lifecycle) = `:132,134` unverified 유지. H-3은 내 캡처 파싱에서 실제 신호 1건(HIDE_RSN="재고부족" 1셀) 발견 — deepcheck가 이를 정적 제약#5로 평면화하지 않고 *재고 동역학 미검토*로 열어둠이 정직(과소도 과대도 아님).
- **dodge-hunt (riskiest claim per stage):** 최대 리스크 = "의류 variant #18 부결". 적대 재현(M3) — 4 distinct 근거 깨기 4/4 실패·2D 셀가용성 잔여 후보도 제약#5 무손실 흡수로 환원. **깨기 실패 = 부결 견고.**
- **self-approve 0:** reverse(rpm-reverse-engineer)·metamodel(architect)·gap(gap-analyst)·vessel(designer)·deepcheck(codex/deepcheck) 산출을 validator(별 레인)가 라이브 psql + 캡처 raw 파싱으로 재도출 — echo 아닌 독립 재측.

**CL M6 = GO.** deepcheck 13후보 채택 0·H-2 REFUTED(반증·미채택)·codex #18 동의=robustness 기록(근거 아님)·H-1/H-3 정직 unverified·#18 dodge-hunt 깨기 실패·self-approve 0.
> **노트(H-2 병렬 진행):** H-2(자수)는 본 검증 시점 deepcheck.md에 이미 REFUTED-for-RP로 갱신 완료(`:46,133`)·내가 캡처로 독립 재현(print_type 3종 닫힘). reverse-engineer 측 추가 진행이 있으면 그 결과로 deepcheck.md 재갱신 시 M6 재확인 권고(현재 "채택 0"은 변동 없음).

---

## CL 재실측으로 확인/반증한 핵심 주장 (요약)
1. **size_color_info 227셀=227 distinct (size,color) pair·dup 0** — 캡처 직접 파싱·size×color=두 기존 축 Cartesian 확증(#18 부결 토대).
2. **MTRL_COD=SXSRT+사이즈자리+색자리(SXSRT103/126/158)** — 셀→단일 SKU=G-1 본체 SKU 동형 캡처 재현.
3. **option_items 469·ref_key2 255·2키 동시 255 전부 .03자재·PRD_000071=33×4** — 후니 옵션 그릇이 2D variant 무손실 수용 라이브 실증(search-before-mint 정당).
4. **OPT_REF_DIM 7종(color 없음)·MAT_TYPE 14종(apparel 버킷 없음)** — V-3 WEAK(자재 CLR 분해축·원단 버킷 결손) 정확.
5. **PROC_000007 별색인쇄+008/009/011/012 family 라이브 실재** — Pantone 별색 PASS 정확(별색=공정 경계).
6. **print_method/item_gbn/pricing_model/price_gbn 컬럼 전 테이블 0건** — #12 인쇄방식 GAP·item_gbn discriminator 부재 둘 다 확증.
7. **t_prd_product_processes PK=(prd_cd,proc_cd)·위치 컬럼 0** — 인쇄위치 멀티슬롯 WEAK(공정행 반복 불가·옵션 경유만) 정확.
8. **apparel_info.print_type=PTP_DTF/DIR/SLK 3종 닫힘·자수 0 hit** — H-2 REFUTED-for-RP 독립 재현.
9. **HIDE_RSN=226 blank+1 "재고부족"** — H-3 재고 lifecycle 신호 실재 1셀·deepcheck unverified 유지 정직성 확인.

## CL 인계
- 결함 라우팅 = `_defects.md` CL 섹션(D-CL-2 §XV-2 미묘점 표기·D-CL-3 §III 전역 카운트 드리프트·전부 Low·판정 무영향). **NO-GO 0 — 재게이트 불요. CL M2~M6 GO 비준.**
- BN/GS/TP/PR/ST verdict 보존. 라이브 재실측 세션 권위(2026-06-17·psql 직접 SELECT + 캡처 raw 파싱).
- **★의류 variant #18 부결 = VALIDATED(역방향 오류 없음)** — 캡처(227셀 Cartesian·MTRL_COD 인코딩) + 라이브(ref_key1/ref_key2 2D 페어링 255·PRD_000071 33×4) 독립 재현으로 "distinct를 facet으로 숨김" 적대 검정 4/4 깨기 실패. size×color=사이즈#13×색상 Cartesian·셀가용성=제약#5 2D subject·기존 축이 *왜곡 없이* 담음. **6번째 카테고리 distinct 0=17축 재포화(PR 패턴 반복)는 모델 안정성 재확인이지 distinct 은폐 아님 — 검증됨.**
- **CL 핵심 직답:** CL facet 5항 = **PASS 1**(Pantone 별색 C-7·PROC_000007 family 라이브 실재)·**WEAK 3**(size×color 2D C-2/C-3=기존 #1/#5·인쇄위치 C-4=기존 #2/#9·item_gbn C-5=기존 #15)·**GAP 1**(인쇄방식 C-6=기존 #12) · **distinct 신축 0(의류 variant #18 부결)=신규 vessel-gap 0** · 신규 테이블/컬럼/V번호 0(2D 페어링 라이브 활성이 search-before-mint 정당화) · deepcheck 13후보 채택 0.

---

# AC 카테고리 M2~M6 게이트 (rpm-validator·2026-06-17·라이브 read-only psql + 캡처 raw 직접 파싱)

> M1 이미 GO(위). 본 섹션 = M2~M6 독립 재측정. 7번째 카테고리·distinct 0·17축 재포화. 최중요 검증 = M3 A-8(가공방식 그룹핑)·D-13(layer-stack) 부결이 역방향 오류(distinct를 facet으로 숨김)가 아닌지 적대 재검(ST 형상#17 승격과 일관 기준).
> 재측정 방식: 라이브 `information_schema`/`t_*` 직접 SELECT(railway DB·conn 확인) + AC 3캡처(ACNTHAP/ACTHDKY/ACPDSTD) raw JSON 직접 파싱(생성자 주장 비신뢰·필드 실재성 재확인).

## M2 — 메타모델 정합 (GO)

**검증 대상:** discovered-axes v7.0(AC distinct 0)·metamodel-dictionary v7.0(17축 유지)·metamodel-erd(새 엔티티 0)·_resolved-fragments A-1~A-9.

**재측정 결과 — 전건 일치:**
1. **17축 카운트 일관** — dictionary v7.0(`:14·:17`)·discovered-axes(`:29·:31`)·gap-matrix §XVIII·vessel-needs v7.0 모두 "17축 유지·신규 축 0·AC distinct 0" 동일 진술. 카운트 드리프트 0(7정적+4관계+2횡단+GS2+TP1+ST1=17).
2. **새 엔티티 0** — AC가 metamodel-erd에 새 엔티티/관계 추가 안 함(facet 강화만). dictionary v7.0이 명시("총 17축 유지"). FK/composition 모순 0.
3. **A-1~A-9 증거 도출성** — 9 fragment 전부 reverse 실측(§0.1~§0.6·§1~§4) + [huni-ref] dbmap 31_acrylic 대조로 귀속. domain-researcher 신규 호출 0(추정 0·두께/라미/표면효과/코롯토 전부 후니 KB+[huni-ref] 확정 존재).
4. **오버피팅 경계** — AC 단일 카테고리 특이를 distinct 승격한 것 0(가장 강한 A-8조차 부결). 7군 누적 증거로만 판정.

**M2 판정: GO.** AC facet 9 판정이 reverse 증거+후니 dbmap 대조에서 도출·17축 카운트 4파일 일관·관계 무모순·새 엔티티 0.

## M3 — facet 부결 타당성 (GO·★최중요·역방향 오류 없음 VALIDATED)

**검증 대상:** A-1(두께)·A-2(surface-finish)·A-3(입체)·A-8(가공방식 그룹핑·★강후보)·D-13(layer-stack·codex)·기존 축이 왜곡 없이 담는지 직접 재확인.

### A-8 가공방식 그룹핑 #18 부결 — VALIDATED (캡처 직접 파싱)
ACTHDKY 캡처 raw 직접 파싱(`major_radius_ACTHDKY.json`):
- `option_info.production_method` = **2값 enum**(`{COD:MTG_DFT,일반}`·`{COD:MTG_LAM,라미}`) — 전용 "그룹핑 엔티티" 아닌 단순 옵션 select.
- `pdt_mtrl_info` 6행의 `GRP_OPTION_CD` = **자재행 속성**: PXAATD01/D02(MTG_DFT)·PXAATL01~04(MTG_LAM). 라미 선택→라미 자재행(PXAATL01 "아크릴_3T 투명 라미(2T+1T)") subset 게이팅.
- **무손실 분해 직접 확인:** ① 라미네이션=공정#2(라미 후가공) ② 라미 결과(PXAATL01~04)=자재#1 합성 행(WGT_CD L01~04·홀로그램 surface) ③ production_method→자재 subset=옵션#3 polymorphic cascade(GRP_OPTION_CD가 자재행에 매달림). **별 관리 객체/lifecycle 없음** — production_method는 자재행 필드 + 옵션 enum이지 distinct 슬롯 아님.

### D-13 layer-stack #18 (codex) — REFUTED-for-RP VALIDATED (캡처 직접 파싱)
3캡처 전수 raw 파싱:
- `layer/레이어/sequence/stack/적층/z-index/depth` 필드명 매치 = **0건**(전 3캡처 독립 grep 재현).
- `print_data` = **2값 enum 배열**(`[{O,앞뒤같음},{X,앞뒤다름}]`)·순서화 레이어 배열 아님(ACTHDKY)·ACNTHAP/ACPDSTD는 null.
- 화이트(PRT_WHT)·합지(BON_PAP)=평면 PCS 1행(레이어 위치 슬롯 부재). 라미 적층(2T+1T)=MTRL_NM 텍스트에만.
- **판정 일관성:** ST 형상#17은 `option_info.shape_info` 전용 슬롯 실재(독립 확인=GSTGMIC 등 ST 캡처에 shape_info 존재) + 후니 KB G-SK-2 "형상 어느 축에도 없음"(entity-semantic-model 실재 verbatim 확인) → 기존 축 못 담아 승격. A-8/D-13은 정반대 — 기존 축이 왜곡 없이 담음·후니 KB에 "어느 축에도 없음" 결함 없음(라미=공정 멤버 이미 수용). **승격/부결 비대칭이 일관 기준(전용 슬롯+KB 결함 유무)으로 정당.**

### A-1/A-2/A-3 부결 재확인
- A-1 두께: `mat_nm` 텍스트 융합(라이브 "아크릴 투명 3mm" 실측)·dbmap CLEAR3T가 1.5T/3T를 mat_cd 통합(라이브 comp 실재) = 자재 WGT facet 동형 확증. distinct 아님 정당.
- A-2 surface-finish: surface/finish/glitter/mirror/holo 컬럼 전역 0건(라이브 재현)·ST S-4 점착/내후와 동근 자재 합성 차원. facet 정당.
- A-3 입체/스탠드: 받침=부속물(`t_prd_product_addons` 실재)·코롯토 두께=자재·양면=옵션 분산. 생산형태#15(본체 평면 유지)·형태가공#14(본체 생성 아님) 둘 다 아님 — 분산 facet 정당.

**M3 판정: GO.** ★A-8/D-13 부결 = VALIDATED — 캡처 직접 파싱(production_method=자재행 속성+옵션 enum·layer 필드 0건·print_data=2값 플래그)으로 "기존 축이 왜곡 없이 담음" 재현. ST 형상#17(전용 슬롯+KB 결함)과 일관 기준 적용·**역방향 오류(distinct를 facet으로 숨김) 없음 — 적대 검정 4/4 깨기 실패.**

## M4 — 갭 판정 정확 (GO·라이브 information_schema 직접 재실측)

**검증 대상:** §XVII AC facet 6항 PASS2/WEAK4/GAP0. 라이브 read-only psql 직접 SELECT로 양면 재실측.

| # | facet | gap 판정 | 라이브 재측정(독립) | 재현 |
|---|---|:---:|---|:---:|
| 1 | 두께(A-1) | WEAK | MAT_TYPE.03 아크릴 14행·`weight`/`depth` 컬럼 실재하나 아크릴 전부 **공백/NULL**·두께=`mat_nm` 텍스트("아크릴 투명 3mm")·CLEAR3T(mat_cd 통합) 실재 | ✅ |
| 2 | surface-finish(A-2) | WEAK | `surface/finish/glitter/mirror/holo/effect` 컬럼 전 t_* **0건** | ✅ |
| 3 | 입체/받침(A-3) | PASS | `t_prd_product_addons`(prd_cd·disp_seq·note·tmpl_cd FK)·**5행** 실재 | ✅ |
| 4 | 부자재 횡단(A-4) | WEAK | D링이 MAT_TYPE.02(MAT_000249 56mm)·.04(MAT_000017~020)·.07(MAT_000247 31mm/248 42mm) **3버킷 중복**·고리/자석/와이어링 .04/.07/.10 분산 | ✅(주장보다 강함) |
| 5 | acrylic2025(A-6) | WEAK | `PRF_CLR_ACRYL` 1행·CLEAR3T prc_typ `.02`(84행)·MIRROR3T `.01`(37행)·`frm_typ_cd` 컬럼 **부재** | ✅(수치 정확) |
| 6 | 인쇄면+화이트(A-5) | PASS | `PROC_000008 화이트` 실재 | ✅ |

**중요:** 6항 전부 라이브 재측정과 **정확 일치**(행수 84/37, 컬럼 부재/존재 둘 다 확인). PASS가 비존재 컬럼 인용 0건·GAP 주장 없음(전부 기존 §I~§XVI 축에 흡수·신규 vessel-gap 0). A-4는 gap 주장(D링 3중복)이 라이브에서 더 명확히 재현(.02/.04/.07).

**M4 판정: GO.** AC facet 6항 PASS2/WEAK4/GAP0 전건 라이브 information_schema 재실측 일치·dbmap 31_acrylic(CLEAR3T mat_cd 통합·MIRROR3T 별 comp·Q-ACR-7 .02) 정합·양면 검증(컬럼 존재+값 NULL/0건).

## M5 — 그릇 건전성 (GO·신규 그릇 0 정당·B-3 조율 신중함 타당)

**검증 대상:** vessel-material-axis §10(V-3 3차원)·vessel-quantity-size-pricing §C5·vessel-template-asset §8·_vessel-roadmap.

**재측정:**
1. **신규 그릇 0 = search-before-mint 정당 결과** — AC facet 6항 전부 기존 V-3(자재)·V-7(가격)·V-10/V-11(TemplateAsset)·부속물 PASS(addons)에 흡수. 라이브 재측정이 이를 뒷받침: addons 그릇 실재(A-3 PASS)·화이트 공정 실재(A-5 PASS)·두께 `depth`/`weight` 컬럼 실재(채우기=data)·surface 컬럼 0건이나 MAT_FACET 코드행으로 분류 가능. 새 테이블 mint 0 정당(over-modeling 회피).
2. **V-3 3차원 확장 적정** — ① 두께 measure_type(WGT 슬롯 다의·MAT_FACET 세분) ② surface_finish(ST S-4 adhesion/weather와 통합·동근) ③ 단일 부자재 마스터. 전부 MAT_FACET 코드행/버킷 재정의로 닫음·신규 테이블/컬럼 0(또는 조건부 1 NULL). 무손실·컨벤션 정합(t_cod_base_codes 코드그룹 패턴).
3. **★A-4 단일 부자재 마스터 = round-22 B-3 조율 노트 (신중함 타당)** — vessel-material-axis §10.3가 명시: "designer 단독 mint 금지·dbmap B-3 강결합으로 노트·vessel 선행(버킷 정의)→data 이동(B-3) 순서 [HARD]·행 영향 큼(80/82 상품 BOM 의존)". 라이브 재측정(D링 3버킷 중복 실재)이 이 강결합/위험을 뒷받침 — designer가 독립 mint하지 않고 B-3 조율로 노트한 것은 타당(데이터 강결합·재배선 위험 인식).

**M5 판정: GO.** AC 신규 그릇 0 = search-before-mint 정당 결과(기존 V 흡수·라이브 그릇 실재 확인). V-3 3차원 확장 적정(코드행/버킷·신규 테이블 0·무손실·컨벤션 정합). A-4 단일 부자재 마스터를 B-3 조율로 노트한 신중함 타당(designer 단독 mint 안 함·행 강결합 인식).

## M6 — 생성-검증 독립성 (GO)

**검증 대상:** deepcheck codex 18후보 무검증 채택 0·D-13 REFUTED 정직 분류·HIGH 후보 unverified 정직성·dodge-hunt.

1. **채택 0 확인** — deepcheck `:160` "채택 0·전부 unverified". metamodel(discovered-axes·_resolved-fragments)·gap(§XVII)에 codex 후보 반영 0건 교차 확인(A-1~A-9는 reverse 실측 기반·codex 라우팅은 검증 트리거로만).
2. **D-13 정직 분류** — codex가 layer-stack #18을 강하게 밀었으나(HIGH·confidence HIGH) deepcheck가 캡처 직접 파싱으로 REFUTED-for-RP 분류(`:33-42`). 본 validator 독립 재현(layer 필드 0·print_data 2값 enum) = 정직 분류 검증됨.
3. **HIGH 후보 unverified 정직성** — 엣지가공(H-3)·hole-geometry(H-2)·렌티큘러(H-6)·화이트 순서(H-4) 전부 unverified/라이브 검증 필요로 분류·채택 0. codex "no live access" 자기admission 기록·라이브 권위 명시.
4. **codex A-8 동조 기록** — deepcheck `:14` codex가 A-8 가공방식 그룹핑에 동조한 점 기록하되, "codex 동의는 근거 아님·라이브 권위" 명시(D-13으로 별 각도 제기). 본 validator는 라이브/캡처로 A-8 부결 독립 재검(production_method=자재행 속성).
5. **dodge-hunt(가장 위험한 주장 깨기 시도):** M3 A-8 부결(가장 강한 distinct 후보 부결)을 깨려 시도 — production_method가 전용 그룹핑 엔티티라면 distinct였을 것. 캡처 직접 파싱 결과 자재행 속성(GRP_OPTION_CD)+옵션 enum으로 무손실 분해 = 깨기 실패. M4 acrylic2025 84행/37행 라이브 직접 카운트 = 생성자 수치 echo 아닌 독립 재측정 일치.

**M6 판정: GO.** 무검증 채택 0·D-13 REFUTED 정직 분류(독립 재현)·HIGH 후보 unverified 정직·codex A-8 동조는 근거 아님으로 기록·라이브 재측정으로 핵심 사실 재도출(echo 아님).

## AC 종합 verdict

| 게이트 | 판정 | 핵심 근거(독립 재측정) |
|---|:---:|---|
| M1 | **GO**(기존) | 캡처 4종 실재·수치/코드/헤더 전건 일치·D-AC-1 Low |
| M2 | **GO** | 17축 4파일 일관·새 엔티티 0·증거 도출·오버피팅 0 |
| M3 | **GO** ★ | A-8/D-13 부결 VALIDATED(캡처 직접 파싱·ST#17 일관 기준)·역방향 오류 없음 |
| M4 | **GO** | facet 6항 라이브 information_schema 전건 재실측 일치(84/37행·컬럼 부재 확인) |
| M5 | **GO** | 신규 그릇 0 정당(기존 V 흡수)·V-3 3차원 적정·A-4 B-3 조율 신중함 타당 |
| M6 | **GO** | 채택 0·D-13 정직 분류 독립 재현·dodge-hunt 깨기 실패 |

**★종합: AC M2~M6 전건 GO. NO-GO 0. 재게이트 불요.**

**★A-8/D-13 부결 검증 직답(directive 최중요):** **역방향 오류(distinct를 facet으로 숨김) 없음 — VALIDATED.**
- **A-8(가공방식 그룹핑)**: 캡처 직접 파싱으로 `production_method`=2값 옵션 enum + `GRP_OPTION_CD`=자재행 속성(라미 선택→PXAATL01~04 라미 자재 subset 게이팅) 확인. 라미네이션=공정#2·라미 결과 자재행=자재#1 합성·그룹핑=옵션#3 cascade로 **무손실 분해**·별 관리 객체/lifecycle 없음 → facet 정당.
- **D-13(codex layer-stack)**: 3캡처 layer/sequence/stack/적층 필드 **0건**·print_data=2값 플래그(순서 배열 아님)·화이트/합지=평면 PCS(위치 슬롯 부재) → RP 미운영·REFUTED-for-RP 정당.
- **ST 형상#17 일관 기준**: 형상은 전용 `shape_info` 슬롯 실재 + 후니 KB "어느 축에도 없음"(verbatim 확인) = 기존 축 못 담아 승격. A-8/D-13은 정반대(전용 슬롯 없음·KB 결함 없음·기존 축이 담음) = 부결. **승격/부결 비대칭이 동일 기준(전용 슬롯+KB 결함 유무)으로 일관 — 진짜 distinct를 숨긴 것 아님.** 적대 검정 4/4(A-1·A-2·A-3·A-8) 깨기 실패.

## AC 인계
- 결함 라우팅 = `_defects.md` AC 섹션(D-AC-1 M1 Low·판정 무영향 외 M2~M6 신규 결함 0). **NO-GO 0 — 재게이트 불요. AC M2~M6 GO 비준.**
- BN/GS/TP/PR/ST/CL verdict 보존. 라이브 재실측 세션 권위(2026-06-17·railway DB read-only psql 직접 SELECT + 3캡처 raw JSON 파싱).
