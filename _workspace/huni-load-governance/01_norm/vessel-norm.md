# 적재 규범 정본 — 상품유형 × 그릇 배치표 (vessel-norm)

> §34 Huni-Load-Governance · Phase 1 · hlg-vessel-norm-curator · 2026-07-03
> **목적**: 진단·정리 전에 "무엇이 올바른 적재인가"를 한 장으로 못박는다. 이 정본이 Phase 2
> 옵션 전수 판정(hlg-option-usage-auditor)의 **유일 기준**이다. 규범 없이 판정 없음.
> **권위**: 상품마스터·인쇄상품 가격표 **260702**(구 260610/260527 대체 — 값 충돌 시 260702가 이긴다).
> **최종 잣대**: 모든 배치의 옳고 그름은 결국 **가격이 제대로 나오는가**(evaluate_price/
> evaluate_set_price PRICE≠0·이중합산 0)로 검증한다. 각 항목에 "가격 파손 모드"를 병기한다.
> **relitigate 금지**: 아래 §1·§2의 고정 규범은 SOT에서 이미 확정 — 재논의하지 않는다.

관련 SOT: `_workspace/_foundation/product-type-classification-sot.md` ·
`_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(12규칙) ·
`_workspace/huni-constraint-rules/01_scenario/constraint-need-spec.md`(CN-1~6) ·
`_workspace/huni-set-product/06_load/set-product-readiness-master.md`(셋트 구조) ·
[[dbmap-option-material-process-bundle]] · [[set-product-bom-role-reassignment-260701]] ·
`option-usage-criteria.md`(옵션 3용도 잣대·본 정본의 짝).

---

## 1. 상품유형 3종 (고정 — SOT `product-type-classification-sot.md`)

| 유형 | prd_typ | 정의 | 셋트 판정 | 가격 |
|------|---------|------|-----------|------|
| **일반 완제품** | .01 | 주문제조 단일 판매상품(셋트 아님). 예: 디지털인쇄·프리미엄엽서 | `t_prd_product_sets` 부모 **미등록** | 자기 공식 1:1 |
| **셋트 완제품(부모)** | .01 | 부품조립 최종상품 = **그릇**. 예: PRD_072 하드커버책자 | `t_prd_product_sets` 부모 **등록** | `evaluate_set_price` = 구성원 합산 + 셋트 본체 공식 |
| **반제품(구성원)** | .02 | 셋트 구성 부품(표지·내지·면지). 단독 판매 안 함 | 부모의 `sub_prd_cd`로 참조 | 부모에 귀속(member evaluate_price) |

- 셋트 완제품과 일반 단일은 **둘 다 .01** — 구분은 오직 `t_prd_product_sets` 부모 등록 여부(별도 코드 아님).
- .03 기성(제조 없음)·.04 디자인(폐기)·.05 addon(템플릿 레이어)은 본 규범표 대상 아님(참조만).

## 2. 그릇 6종 (라이브 테이블 + 코드 소비 지점)

| 그릇 | 라이브 테이블 | 엔진 소비 지점(권위=코드) |
|------|--------------|--------------------------|
| **기준정보** | `t_prd_product_materials`(자재)·`_processes`(공정)·`_sizes`(사이즈)·`_plate_sizes`(판형)·`print_opt_cd`(도수)·수량규칙(min/max/incr) | `evaluate_price(target, selections, qty)` pricing.py:402 — selections={siz_cd·print_opt_cd·mat_cd·proc_cd·plt_siz_cd·opt_cd}. 판형 자동도출 `fn_best_plate`(price_views.py:1757)·판걸이수 `fn_calc_pansu`(pricing.py:215·`t_siz_pansu` lookup 우선) |
| **옵션** | `t_prd_product_option_groups`/`_options`/`_option_items` | 옵션 선택 → `ref_dim_cd`(polymorphic .01~.07)로 위 차원코드로 환원. 트리거 `fn_chk_opt_item_ref`=참조 대상이 같은 prd_cd에 실재 강제. 상세 잣대=`option-usage-criteria.md` |
| **템플릿** | `t_prd_templates`(addon·`base_prd_cd`) | addon 가산상품 레이어. use_dims에 opt_cd 미포함 시 always-add silent 가산(RC-2 가드) |
| **제약규칙** | `t_prd_product_constraints`(`rule_typ_cd` .01호환/.02금지/.03필수동반·`logic` JSONB) | ★`evaluate_price`/`simulate`는 **제약을 안 본다**. SKU 저장 콜백 + `/validate/` Ajax만 강제 → 위젯/주문이 validate 호출해야 차단(§6). CN-1~6만 신설 |
| **가격공식** | `t_prc_formulas` + 상품-공식 바인딩 | 일반=자기 공식 1:1(PRF_<X>). 셋트=본체 공식(제본/조립만)+구성원 합산. 직접단가 0=전상품 공식기반 |
| **가격구성요소·단가행** | `formula_components`(배선)·`t_prc_price_components`(`use_dims`)·`t_prc_component_prices`(`prc_typ`) | 공식 ← 구성요소 배선 ← 차원행(단가). 고아(미배선)=견적0/저청구 |

---

## 3. 규범표 — 적재 대상(행) × 상품유형(열)

> 셀 판정 3값: **MUST**(반드시 있어야) / **금지**(있으면 안 됨) / **권위대로**(260702 시트 구조가 정하는
> 배치 — 일률 강제 금지, 판정 절차로). 각 행마다 근거(SOT/코드) + 가격 파손 모드 병기.

### 3-1. 기준정보 — 자재 (`t_prd_product_materials`)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — 용지·소재 자재 자기 등록 | **권위대로** — 원칙: 자재는 구성원으로 이관. **예외[HARD]**: 옵션이 참조하는(ref_dim_cd.03) 자재는 부모에 실재해야(트리거) | **MUST** — 자기 자재(표지=전용지/레더·내지=종이·면지=색상자재 MAT_382~385) |

- **근거**: [[set-product-bom-role-reassignment-260701]](부모=그릇·속성 구성원 이관·단 옵션참조 자재는 부모 유지) · `fn_chk_opt_item_ref` 트리거.
- **가격 파손 모드**: ① 자재 미등록 → 용지비 component NO_MATCH → **견적 0/저청구**. ② 다른 반제품 자재를 부모에 오적재 → 생산 BOM 오염 + 단가행 **중복 매칭 과대청구**. ③ 옵션참조 자재를 "이관 대상"으로 오판 삭제 → 옵션 끊김/트리거 위반(072/077/082/088 자기교정 사례). ④ 자재명에 사이즈 내장(129/130) → mat×siz 대각선-밖 셀 **견적 0**(→ CN-2 제약).

### 3-2. 기준정보 — 공정 (`t_prd_product_processes`)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — 인쇄 base 공정(자동선택) + 후가공(코팅·박·오시·미싱 등) | **권위대로** — 셋트 **본체 공정(제본/조립)**만. 구성원 인쇄공정을 부모에 두면 안 됨 | **MUST** — 자기 인쇄 base + 후가공 공정 |

- **근거**: 도메인규칙 #1·#8(판형·공정) · pricing.py base_print_proc 자동선택 · [[digital-print-base-proc-missing-260701]].
- **가격 파손 모드**: ① 디지털 base 인쇄공정(PROC_000004) 미바인딩 → **인쇄비 영구 0**(18건 사례). ② 셋트 제본공정 다종-1배선(PRF_BIND_SUM에 중철만) → 무선/PUR/트윈링 제본비 **silent skip/저청구**(~3.3배 과소). ③ 완칼 die-cut 단가형×판수 이중적용 → **과대청구**(023 8M→120K 교정 사례).

### 3-3. 기준정보 — 사이즈 (`t_prd_product_sizes` + nonspec_*_min/max)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — siz_cd(등록형) 또는 nonspec 자유치수 컬럼 | **MUST** — 셋트 완제품 손님선택 사이즈(siz_cd UI 전파) | **MUST** — 내지=판형대상 사이즈(국4절 등)·표지=펼침 사이즈 |

- **근거**: pricing.py selections.siz_cd · [[postcard-book-sim-convergence-260702]](셋트 UI siz_cd 미전파=코드결함·백필 원천=내지) · [[qty-system-audit-260702]].
- **가격 파손 모드**: ① 사이즈 미등록/오적재 → 단가행 매칭 실패 → **견적 0**. ② 완제품 사이즈 오적재(비종이류에 판형용 사이즈) → 127상품 논리삭제 사례. ③ 셋트 부모 사이즈 없으면 구성원 판형 pansu **백필 원천 상실**(094/097/100 화면 0원).

### 3-4. 기준정보 — 도수/인쇄옵션 (`print_opt_cd`)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — 색상축(흑백/칼라). print_opt_cd | **금지**(부모 본체는 제본, 도수는 인쇄 구성원 것) | **MUST** — 인쇄되는 반제품(내지·표지)에 도수 |

- **근거**: 도메인규칙 · [[huni-price-engine-diag-harness]](도수=print_opt_cd) · [[booklet-cover-branch-design-260630]].
- **가격 파손 모드**: 도수축(색상)을 **면축(단면/양면)으로 오해** → S1·S2 단가행 둘 다 매칭 → **이중합산 과대청구**(전 책자 공통 R-3). 별색(spot)은 도수 아님 → 옵션 U-1/자재로(option-usage-criteria U-1 참조).

### 3-5. 기준정보 — 판형 (`t_prd_product_plate_sizes` + fn_best_plate/fn_calc_pansu)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **권위대로** — **종이류 출력소재면 MUST**(판수>0 연결)·**비종이류(아크릴·실사·굿즈)면 금지** | **금지** — 판형은 부모 아닌 내지 반제품에 | **권위대로** — 내지(종이 인쇄대상)=MUST·표지(가변크기)=없음이 정상 |

- **근거**: 도메인규칙 #1·#2·#8[HARD](판형=종이류만·fn_best_plate 자동선택) · [[platesize-paper-only-diagnosis-260630]] · [[pansu-authority-fn-calc-pansu-260628]].
- **가격 파손 모드**: ① 종이류 판형 미연결/판수0 → fn_best_plate NULL → 판형 미결정 → **가격 0**(썬캡 국4절 사례). ② 비종이류 판형 강제 → 오적재/견적불가. ③ 부모에 판형 두면 pansu 대상 **오특정**(내지가 진짜 인쇄대상). ④ 판걸이수 기하 과다 → 판수 과소 → **저청구**(→ t_siz_pansu lookup 교정).

### 3-6. 기준정보 — 수량규칙 (min/max/incr · 상품/사이즈 레벨)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — 주문가능 수량 UI 권위(가격구간과 역할 분리) | **MUST** — 셋트 부수(copies) 규칙 | **MUST** — `sub_prd_qty`·min/max/incr(구성원별·t_prd_product_sets) |

- **근거**: [[qty-system-audit-260702]](수량 UI 권위=상품/사이즈 규칙·가격구간과 분리·제안 min=max(권위,가격표구간)) · pricing.py evaluate_set_price members[].qty.
- **가격 파손 모드**: ① 수량규칙 부재 → UI 무제한 or 가격구간과 혼동. ② 1건 고정금액 .01을 ×수량 → **100~1000배 과대청구**(명함·봉투·모서리비 3건 사례). ③ CN-5 범위규칙과 컬럼 중복 시 유지(강제 계층·중복 아님).

### 3-7. 템플릿 — 추가상품 (`t_prd_templates` addon)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **권위대로** — 부속 가산상품(봉투 등)만 addon 템플릿 | **권위대로** — 셋트 자체가 조립이므로 addon은 별개(있으면 부속) | **금지** — 반제품은 단독 판매·addon 안 함 |

- **근거**: product-type-sot §2(addon=t_prd_templates 레이어·prd_typ 아님) · [[addon-optcd-model-broken-live]](use_dims=[opt_cd] 라이브 미작동→addon 템플릿).
- **가격 파손 모드**: ① addon을 use_dims=[opt_cd]로 모델 → 라이브 미작동. ② 템플릿 use_dims에 opt_cd 미포함 → **always-add silent 가산**(RC-2 가드). ③ addon성을 옵션으로 넣음 → option-usage MOVE-템플릿 대상.

### 3-8. 제약규칙 (`t_prd_product_constraints` · CN-1~6만)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **권위대로** — CN-1~6 조건부 관계만. 컬럼/옵션 정의에 이미 있으면 **금지**(중복) | **권위대로** — 구성원 조합 제약(sub_prd_cd var) | **권위대로** — 자기 선택 제약(단독 노출 안 되나 구성원 선택 시) |

- **근거**: constraint-need-spec.md(CN-1물리불가·CN-2단가부재엇갈림·CN-3필수동반·CN-4상호배제·CN-5범위·CN-6옵션그룹오용이관) · 경계원칙[HARD](옵션그룹=선택지집합·제약=조건부관계).
- **가격 파손 모드**: ① **오차단**(정당 조합 차단) = 매출 차단 → **오차단 0이 최우선 가드**. ② CN-2 미설정 → 팔 가격 없는 조합에 **0원 견적 그대로 노출**(evaluate_price 제약 미참조). ③ 옵션그룹으로 조건부 관계 흉내 → **그룹 폭발**(→ CN-6 이관). ④ raw JSONLogic escape → UI 확인불가(폼빌더 정형 shape만).

### 3-9. 가격공식 (`t_prc_formulas` + 바인딩)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — 자기 공식 1:1(PRF_<X>). (가격포함)=직접단가 취급 | **MUST** — 셋트 **본체 공식만**(제본/조립). 구성원 가격 포함 금지 | **권위대로** — 자기 공식(member 호출)·면지=제본비 포함 **무가격**(unit_price 0) |

- **근거**: pricing.py:854 evaluate_set_price(members 합산 + set_eval 셋트공식) · 도메인규칙 #3(면지 무가격) · [[booklet-set-formula-principle-260629]] · [[hardcover-blocked-resolution-live-260629]].
- **가격 파손 모드**: ① 공식 미바인딩 → **견적 0**(077/082 부모 공식0행 사례). ② 부모 공식이 구성원 가격 재계산 → **이중합산 과대청구**. ③ 면지 단독 단가 → **이중청구**(제본비에 이미 포함). ④ 공식이 시장가 2배 초과 → 가격테이블 lookup으로 전환(도메인규칙 #4).

### 3-10. 가격구성요소·단가행 (`formula_components`/`price_components`/`component_prices`)

| 일반 완제품 | 셋트 부모 | 반제품 |
|---|---|---|
| **MUST** — 공식 ← 구성요소 배선 + use_dims 차원행 충전 | **MUST** — 본체 공식(제본) 구성요소만 | **MUST** — 자기 구성요소·단가행 |

- **근거**: 도메인규칙 #7(차원형 vs 수량×단가 등록방식) · [[formula-components-wiring-subtrack-260701]](배선 결함 4종: 고아·빈배선·삭제오염·미배선) · [[namecard-orphan-component-wiring-260630]] · 통합vs분리 기준([[price-component-unify-vs-split-criterion-260630]]: 통합=한 상품 내 손님선택·분리=종류/상품 다름).
- **가격 파손 모드**: ① 고아(단가행 있으나 미배선) → **저청구/견적 0**. ② 미적재 셀(sparse grid) → **견적 0/최소가**(§26 무결성). ③ 단가형×판수 이중적용 → **과대청구**. ④ 삭제오염(정당 배선 삭제) → 발현 실패. ⑤ 실무진 IMPORT 등록 자재를 "미배선"이라 삭제 금지[HARD] = 배선/단가 채울 갭.

---

## 4. 셋트 규범 주의 — 일률 배치 금지 (판정 절차)

부모 all-in이 권위 정합인 사례와 구성원 분리가 필연인 사례가 **공존**한다. 특정 배치를 강제하지 말고
**260702 시트 구조 + 아래 판정 절차**로 정한다.

- **부모 all-in 정합 사례**: **094 엽서북** — 권위 468셀 verbatim 전수 일치 → 부모 고정가표에 all-in, 자식 분리는 **날조**([[postcard-book-sim-convergence-260702]]).
- **구성원 분리 필연 사례**: **068/072 표지 member** — 완제품 판형 ≠ 단가행 판형(SIZ_000499 NO_MATCH) → 표지를 구성원으로 분리해야 fn_calc_pansu=1 성립([[leather-hardcover-077-live-commit-260701]]).

**셋트 배치 판정 절차**:
1. 260702 해당 시트가 **부모 단위 고정가/완제품가**로 값을 주는가? → 부모 all-in(구성원은 구조만·가격 0).
2. 구성원이 **자기 판형·자재로 독립 계산**돼야 값이 맞는가(완제품 판형≠단가행 판형)? → 구성원 분리(member evaluate_price).
3. 애매하면 **evaluate_set_price 골든 재현**으로 결정(이중합산 0·PRICE≠0이 되는 배치가 정답).

**PRD_072 하드커버책자 규범 적용 예**(파일럿): 부모=그릇(제본/조립 본체 공식) · 표지073=구성원(전용지 자재+판형·member) · 면지074/075/076=구성원(색상 자재·**제본비 포함 무가격**). 부모에는 옵션참조 자재만 유지, 나머지 자재·판형은 구성원으로. 검증=evaluate_set_price PRICE≠0·이중합산 0.

---

## 5. 파일럿 커버리지 확인

| 파일럿 | 유형 | 규범표 커버 |
|--------|------|-------------|
| **디지털인쇄 시트** | 일반 완제품(.01·셋트 아님) | §3 전 행 "일반 완제품" 열 — 자재/공정(base proc)/사이즈/도수/판형(종이류)/수량/공식1:1/배선 |
| **PRD_072 하드커버책자** | 셋트 완제품(.01 부모) + 반제품(.02 구성원) | §3 "셋트 부모"·"반제품" 열 + §4 셋트 판정 절차 + 072 적용 예 |

---

## 6. SOT 충돌 보드 (임의 봉합 금지 — 사용자 컨펌 큐)

전 SOT 종합 결과 **하드 충돌(같은 항목 상반 규범)은 없음**. 아래는 컨펌/유의 항목:

| # | 항목 | 성격 | 출처 | 처리 |
|---|------|------|------|------|
| C-1 | 권위 버전 드리프트 | **유의(충돌 아님)** | SOT 문서 전부 260610/260527 인용, 본 정본 권위=260702 | 규칙 확정: **260702가 이긴다**. 260702 변경분(스티커 소재 연당가 등 +33/+32셀·set HANDOFF 기록)이 반영 안 된 예시는 재적재 후속(High). 재논의 불요 |
| C-2 | 셋트 배치 이원(부모 all-in vs 구성원 분리) | **문서화된 이중성(충돌 아님)** | 094(all-in) vs 068/072(분리) | §4 판정 절차로 해소 — 일률 강제 금지가 정본 규범 |
| C-3 | CN-5 범위규칙 컬럼 중복 | **해소됨(충돌 아님)** | constraint-need-spec P-4 | 컬럼(nonspec_*)에 있어도 evaluate_price 미강제 → UI/주문 차단용 규칙 **유효(강제 계층)**. 중복 아님 |
| C-4 | set-readiness-master(2026-06-26) "072 내지 없음" vs 후속 내지 mint | **stale 문서(충돌 아님)** | 06-26 현황 vs 06-30~07-02 세션 | 규범은 **현행 배치 규칙**만 정함(072 라이브 상태 relitigate 안 함). 라이브 실측은 Phase 2 auditor가 확인 |
| C-5 | [[dbmap-option-material-process-bundle]] 23일 경과 stale 경고 | **유의** | 메모리 point-in-time | U-1 BUNDLE 개념(자재+공정)은 사용자 확정 directive라 유효. 코드 인용은 Phase 2에서 라이브 재확인 |

→ **사용자 컨펌 필요분: 없음**(하드 충돌 0). C-1의 260702 재적재 후속만 별도 큐(High)로 인계.
