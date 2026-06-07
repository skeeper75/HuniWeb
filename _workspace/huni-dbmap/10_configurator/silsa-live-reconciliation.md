# silsa(PRD_000138) 라이브 정합 정정 요약 — LV-1~5

> **상태/이력** 작성 2026-06-08 · `dbm-option-mapper` 산출 · round-6 연장(라이브 admin product-viewer 실측 정합).
> **목적:** `live-admin-groundtruth.md`(라이브 admin UI 실측 ground-truth)를 권위로 기존 silsa 옵션 레이어 설계(`silsa-option-layer.md`·`load_silsa/*.csv`)를 정합 정정한다. 핵심은 **constraint var 키를 라이브 표준 var(차원 코드 7종)로 정정**하고, 표현 불가분을 **LV-2 GAP으로 정직 분리**하는 것이다(억지 변환 금지).
> **권위 입력(인용·발명 금지):** `live-admin-groundtruth.md §2.2`(표준 var 7종·폼빌더 제약)·`§4`(LV-1~5) · `silsa-option-layer.md`(정정 대상) · `cpq-schema.md §2`(트리거)·`§3`(코드값) · `attribute-entity-map.md`(마스터 지도).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean.

---

## 0. 한 줄 요약

라이브 admin 제약 폼빌더 실측 → silsa §5 constraint var 키(`size_mode/width/height/gagong/chuga`)가 **라이브 표준 var 7종(차원 코드 기반)과 불일치**임이 확정. silsa 3 constraint는 전부 **연속 수치·모드·옵션 선택 정체성**에 의존 → 라이브 제약 모델(차원 코드 2항 관계)로 **표현 불가** = **LV-2 GAP**(라이브 적재 constraint 행 0건). option_groups/options/option_items 매핑은 **정합 유지**(LV-4). L2 전 상품 미적재 확증으로 silsa가 **라이브 최초 옵션 레이어 사례 후보**(LV-3). ref_param_json UI 부재 강화(LV-5).

**정정 결과 적재 가능 행수: 25 → 22**(constraints 3 INSERTABLE → 0; option_groups 2·options 11·option_items 9는 불변).

---

## 1. 라이브 표준 var 키 7종 (정정 권위)

라이브 admin `/PRD_000138/constraints/` 폼빌더 안내문 명시 — OPT_REF_DIM 7종 ↔ JSONLogic var 키:

| 차원 | 표준 var 키 | OPT_REF_DIM | ref_key 슬롯 |
|------|------------|:-----------:|-------------|
| 사이즈 | `siz_cd` | .01 | ref_key1=siz_cd |
| 판형 | `plt_siz_cd` | .02 | ref_key1=plt_siz_cd(=siz_cd) |
| 자재 | `mat_cd__usage_cd` | .03 | **복합** ref_key1=mat_cd·ref_key2=usage_cd |
| 공정 | `proc_cd` | .04 | ref_key1=proc_cd |
| 묶음수 | `bdl_qty` | .05 | ref_key1=bdl_qty |
| **도수** | `opt_id` | .06 | ref_key1=**opt_id**(NOT clr_cd) |
| 셋트 | `sub_prd_cd` | .07 | ref_key1=sub_prd_cd |

> 폼빌더 = "조건 차원·코드값 ↔ 결과 차원·코드값" 2항 코드 관계(호환 RULE_TYPE.01/금지 .02/필수동반 .03). **연속 수치·모드 플래그·opt_cd(옵션 선택 정체성)에 대응하는 표준 var는 없다.** 고급 JSONLogic 직접입력도 비표준 var 평가 컨텍스트를 보장하지 않음.

---

## 2. LV-1 — silsa §5 constraint var 키 정정 (핵심)

### 2.1 정정 전후 대조

| rule_cd | 종전 var(비표준) | 라이브 표준 var 표현 | 판정 |
|---|---|---|:--:|
| `R-SIZE-NONSPEC` | `size_mode`·`width`·`height` | 수치/모드 var **부재** → 표현 불가 | **GAP** |
| `R-GAKMOK-HEIGHT` | `chuga`(opt_cd)·`height` | 조건측 각목=`sub_prd_cd` 미상(BLOCKED) + 결과측 `height` 수치 부재 → 이중 불가 | **GAP** |
| `R-BONGJE-PARAM` | `gagong`(opt_cd)·`width`·`height` | 조건측 `proc_cd=PROC_000080` 환원 가능 / 결과측 `width·height>0` 수치 부재 → 부분 불가(규칙 전체 불가) | **GAP** |

### 2.2 부분 표현 가능성 분석 (억지 변환 안 함)

- **R-BONGJE-PARAM 조건측만** 표준화 가능: `봉미싱 선택` ≡ option_item이 `proc_cd=PROC_000080` 참조 → `{"==":[{"var":"proc_cd"},"PROC_000080"]}`. 그러나 결과측 `width>0 AND height>0`이 연속 수치라 표준 var 부재 → **규칙 전체는 미완**. 조건 반쪽만 변환하면 의미 왜곡이므로 GAP으로 유지.
- **R-GAKMOK-HEIGHT**는 양측 모두 표준화 불가: 조건측 각목 2변형(LE900/GT900)은 `sub_prd_cd`로 표현해야 하나 sub_prd_cd 미상(BLOCKED) + 결과측 `height` 수치.
- **R-SIZE-NONSPEC**은 순수 수치 범위 + 모드 플래그 → 표준 var 모델 밖.

> **결론(LV-1):** silsa 3 constraint는 표준 var로 **전부 표현 불가** → 라이브 적재 constraint 행 0건. 종전 3행(비표준 var)을 그대로 적재하려면 라이브 폼빌더 입력 불가·고급 JSONLogic도 비표준 var 미보장 → **적재 대상 제외**. 도메인 검증 의도(가로 500~1750 등)는 silsa-l1 권위로 유효하므로 **target spec**으로 보존(`load_silsa/t_prd_product_constraints_GAP.csv` 의 `logic_target_spec`·`status=GAP`).

---

## 3. LV-2 — 비치수 사이즈 범위·파라미터 제약 GAP 정식화

silsa 3 constraint가 검증하려는 것은 **연속 수치 범위**(비치수 가로/세로, 각목규격↔세로, 봉미싱 사이즈필수)라는 한 부류다. 라이브 제약 폼빌더는 "코팅지→박 금지" 류 **차원 호환성** 검증용이지 **수치 범위** 검증용이 아니다.

### 3.1 GAP-NONSPEC-RANGE (신규 정식 GAP)

| 미표현 규칙 | 도메인 의도 | 후보 검증 메커니즘 |
|---|---|---|
| R-SIZE-NONSPEC | nonspec 가로 500~1750·세로 500~5000 | **(A) products 범위 컬럼+앱 검증**(유력) / (B) 비표준 var JSONLogic 평가 컨텍스트 확장+고급 직접입력 |
| R-GAKMOK-HEIGHT | 각목 규격 ↔ 세로 수치 | 각목 sub_prd_cd 선등록(BLOCKED 해소) 후에도 결과측 수치 → (B)/(C 앱 런타임) |
| R-BONGJE-PARAM | 봉미싱 시 사이즈 확정 | 조건측 proc_cd 표준화 가능, 결과측 수치 → (B)/(C) |

### 3.2 검증처 후보 — 도메인/ddl-proposer 결정 라우팅 (침묵 선택 안 함)

| 후보 | 메커니즘 | 장단 | 라우팅 |
|---|---|---|---|
| **(A) products 범위 컬럼** | `t_prd_products`에 `nonspec_w_min/max·nonspec_h_min/max` 신설(DDL) + 앱 런타임 범위 검증 | 비치수 상품 일반 해법·라운드 누적 GAP "비치수 size"(D-5)와 동일 결정. 각목/봉미싱 같은 *조건부* 수치엔 단독 부족 | **ddl-proposer** |
| **(B) 비표준 var 평가 컨텍스트 확장** | POD/백엔드 JSONLogic 평가에 `width/height/size_mode` 등 비표준 var 주입 + 고급 직접입력 logic 사용 | silsa 3건 전부 수용·유연 / 폼빌더 미지원(직접입력만)·var 표준 이탈로 관리성↓ | **도메인 결정** |
| **(C) 앱 런타임 검증 코드** | constraint 테이블 밖, 앱 코드에 하드 검증 | 즉시 가능 / DB 권위 이탈·재사용성↓ | **도메인 결정** |

> **권고(침묵 아님, 1차 제안):** R-SIZE-NONSPEC = (A) products 범위 컬럼이 가장 정합적(라운드 누적 비치수 size GAP과 단일 결정). R-GAKMOK/BONGJE 같은 *조건부* 수치 정합은 (B) 또는 (C)가 필요할 수 있음 → 사용자/도메인 최종 결정 대상.

---

## 4. LV-3 — L2 전 상품 미적재 = silsa가 라이브 최초 옵션 레이어 사례

라이브 admin 실측: 일반현수막 PRD_000138 포함 **모든 상품의 옵션그룹/제약/SKU = 0행**(중철책자 PRD_000068·엽서북 PRD_000094·프리미엄엽서 PRD_000016·프리미엄명함 PRD_000031 교차확인 전부 0). 

- `cpq-schema.md §0/§1/§5`가 인용한 "option_groups 13행(제본10/캘린더3)·templates 11행" 적재 기록은 **라이브 admin UI에서 재확인되지 않음** → 해당 인용은 **코드값(SEL_TYPE·OPT_REF_DIM 등) 선례이지 적재된 옵션그룹 행이 아님**으로 정정(`live-admin-groundtruth §2 [HARD]`). 
- **귀결:** silsa 적재본(option_groups 2·options 11·option_items 9)을 적재하면 **라이브 최초 옵션 레이어 사례 중 하나**가 된다. 엽서 파일럿과 함께 최초 적재 후보. → 적재 우선순위·인간 승인 대상.

> [HARD] 본 정정은 cpq-schema의 "13행/11행" 수치를 **라이브 admin 권위로 하향**한다(later + 직접 UI 캡처). 차후 cpq-schema 갱신 시 반영 권장(본 작업 범위 밖, 리드 판단).

---

## 5. LV-4 — 디스패치 정합 재확인 (보강 불요)

라이브 제약 폼 표준 var 표가 메모리 2건을 라이브로 확증:

- **도수 = `opt_id`**(NOT clr_cd) — OPT_REF_DIM.06 ✅. silsa는 도수 0행이라 미해당이나 디스패치 규약 일치.
- **자재 = `mat_cd__usage_cd` 복합슬롯** — OPT_REF_DIM.03 ref_key1=mat_cd·ref_key2=usage_cd ✅. silsa material(MAT_000182·usage USAGE.07) 정합.
- silsa §4 디스패치(공정=`.04` ref_key1=proc_cd · 셋트=`.07` sub_prd_cd) = 라이브 표 일치.

→ **option_groups/options/option_items 매핑 정합 유지. 보강 불요.**

---

## 6. LV-5 — ref_param_json 라이브 UI 부재 강화 (GAP-PARAM D-1)

라이브 admin 옵션그룹 추가 폼·제약 폼빌더·SKU 폼 **어디에도 파라미터(구수·각목규격) 입력 필드 없음**.

- 옵션그룹 폼 = `opt_grp_nm/sel_typ_cd/mand_yn/min_sel_cnt/max_sel_cnt`만.
- 제약 폼 = 차원·코드값·rule_typ·err_msg만(파라미터 미수용).
- 옵션아이템 레벨 폼(ref_dim_cd 선택·ref_param_json)은 그룹 1개+ 저장 후 드릴다운 가능 → 쓰기 금지로 직접 미확인이나, **제약 폼조차 param 미수용**으로 스키마 부재가 UI에서도 재확증.

→ **GAP-PARAM 강화**: 타공 구수(4/6/8)·각목 규격(900이하/초과) 보존처가 스키마·UI 양쪽에서 부재. `cpq-schema §4 🔴8`·D-1 유지. 적재 승인 시 최초 그룹 생성 직후 옵션아이템 폼 재캡처 권장(ref_param_json 필드 실재 최종 확인).

---

## 7. 정정한 파일 목록

| 파일 | 정정 내용 |
|---|---|
| `silsa-option-layer.md §5` | constraint 전면 재작성 — 비표준 var → LV-2 GAP. 5.1(전제)·5.2(GAP 검증처)·5.3(적재 0건)·정합 메모(LV-3/4/5) |
| `silsa-option-layer.md §0` | 상태/이력에 2026-06-08 정정 요지 + R7(신규 정련) 행 추가 |
| `silsa-option-layer.md §8` | load order [4] constraints = live 적재 0행(GAP)·[5] constraint_json NULL 유지 |
| `silsa-option-layer.md §9` | 적재 집계 constraints 3 INSERTABLE → 0, 합계 25→22 |
| `silsa-option-layer.md §10` | D-5 비치수 범위 검증처(LV-2) 확장 + D-6 신규(silsa 3 constraint 검증처) |
| `silsa-option-layer.md 부록` | constraints CSV 인덱스 = GAP·status 컬럼 명시 |
| `load_silsa/t_prd_product_constraints_GAP.csv` | **개명**(종전 `t_prd_product_constraints.csv` → `_GAP.csv`, F-silsa-1 해소 — 적재 glob 격리, items `_BLOCKED.csv`와 일관) + 컬럼 정정 — `logic`→`logic_target_spec`, `use_yn` 제거, `status=GAP`·`gap_reason` 추가. live 적재 대상 아님 명시 |
| `silsa-live-reconciliation.md` | 본 문서 신규 산출 |

> **불변(정합 유지):** `t_prd_product_option_groups.csv`(2행)·`t_prd_product_options.csv`(11행)·`t_prd_product_option_items.csv`(9 INSERTABLE)·`t_prd_product_option_items_BLOCKED.csv`(3 BLOCKED) — LV-4로 디스패치 정합 재확인, 정정 불요. 기존 BLOCKED 판정(열재단 PROC_000084 신설대기·각목 set 부재) **유지**(본 작업은 constraint var 정합이 주, 번복 아님).

---

## 8. 잔존 GAP / `[CONFIRM]` (정정 후 집계)

### 8.1 신규/강화 GAP (본 정정 산출)
- **GAP-NONSPEC-RANGE (신규·High):** silsa 3 constraint(비치수 범위·각목규격↔세로·봉미싱 사이즈필수) 전부 라이브 제약 모델 밖. 검증처 결정 필요 — products 범위 컬럼+앱(A, 유력) vs 비표준 var JSONLogic(B) vs 앱 런타임(C). ddl-proposer/도메인 라우팅.
- **GAP-PARAM (강화·High):** ref_param_json 부재가 라이브 UI(옵션그룹·제약 폼)에서도 재확증. 타공 구수·각목 규격 보존처 부재.

### 8.2 기존 GAP/`[CONFIRM]` 유지 (번복 아님)
- 열재단 = 신규 PROC_000084 신설 인간승인 대기(M-1 ① 확정·완칼 차용 폐기) — **BLOCKED 유지**.
- 각목 sub_prd_cd 미상(각목 완제상품 0행·sets 0행) — **BLOCKED 유지**.
- `[CONFIRM]` 양면테입→{대상:테입}·큐방 enum 확장 — 유지.

---

## 9. Design decisions — 사용자 에스컬레이션 후보

| # | 결정 사항 | 후보 | 우선 |
|---|---|---|:--:|
| **DD-1** | **비치수 사이즈 범위 검증처**(GAP-NONSPEC-RANGE 핵심) | (A) `t_prd_products` 범위 컬럼 신설+앱 검증(권고) / (B) JSONLogic 평가 컨텍스트에 비표준 var 허용 / (C) 앱 런타임 코드 | **High** |
| **DD-2** | **각목규격↔세로·봉미싱 사이즈필수 같은 *조건부* 수치 정합 검증처** | (A) 단독 불가 → (B)/(C) 필요할 수 있음 | **High** |
| **DD-3** | **silsa = 라이브 최초 옵션 레이어 적재 사례 진행 여부**(LV-3) | 적재 승인(최초 그룹 생성 직후 옵션아이템 폼 재캡처) vs 보류 | **Med** |
| **DD-4** | **cpq-schema "13행/11행" 적재 기록 정정 반영**(LV-3, 본 작업 범위 밖) | cpq-schema를 라이브 admin 권위로 하향 갱신 vs 유지 | **Low**(리드 판단) |

> DD-1/2 = round 누적 "비치수 size"(D-5) 결정과 동일 뿌리. 단일 결정으로 닫는 것이 정합적.
